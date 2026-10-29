-- A standalone tool: it runs in luajit (io, os, loadfile), not the game
---@diagnostic disable: undefined-global
-- Builds Types/ProfileAPI/*.lua: type definitions for the profile API, so an editor with the Lua language
-- server (VS Code's "Lua" extension) completes and documents what profiles use: cast, buff, unit, ui, ...
-- usage (from the BR folder, after changing System/API or the spell lists):  luajit Types/generate.lua [out folder]
-- Sources: the --- doc blocks in System/API (each names its function with @function, per-key parts in
-- <angle brackets>: buff.<spell>.exists), the profile environment in System/Loader/ProfileAPI.lua, and
-- the keys of every flavour's spell lists and System/Lists (items, pets).
-- Written as Types/ProfileAPI/*.lua, each under the language server's default file size limit
-- (workspace.preloadFileSize, 500 KB); a class may be declared across files
local OUT_DIR = arg and arg[1] or "Types/ProfileAPI" -- another folder: .tests/types_check.lua compares
local MAX_FILE = 400 * 1024
local BLOCK = "\0" -- marks where a file may end: before each class and the globals

local function readFile(path) local f = assert(io.open(path)); local s = f:read("*a"); f:close(); return s end
local function sortedKeys(t) local k = {} for x in pairs(t) do k[#k + 1] = x end table.sort(k) return k end
local function lines(cmd) local t = {} for l in io.popen(cmd):lines() do t[#t + 1] = l end return t end

---------------------------------------------------------------------------------------------------
-- Keys: what the per-key tables hold
---------------------------------------------------------------------------------------------------
-- Each flavour's lists load into their own br (they assign whole tables, e.g. spells.DRUID.Shared), and
-- the keys of all of them are merged
-- (br.functions calls in a list, like quakingPalm = br.functions.spell:getRacial("Pandaren"), give 0 so
-- their keys stay)
local function newBr()
    return { lists = { spells = {} }, client = { rules = {} }, api = {},
        functions = setmetatable({}, { __index = function() return setmetatable({}, { __index = function() return function() return 0 end end }) end }),
        game = setmetatable({}, { __index = function(_, k) return rawget(_G, k) or function() return nil end end }) }
end
local function loadList(path, into)
    local chunk = loadfile(path)
    if chunk then pcall(chunk, "BadRotations", into) end
end
local flavourBrs, flavourBrByName = {}, {}
-- As br.lists:loadExpansionSpells loads them: Global.lua first (it starts br.lists.spells), then the class
-- and spec files (Spells.lua is only a fallback for a flavour without Global.lua)
for _, dir in ipairs(lines('find Expansions -mindepth 1 -maxdepth 1 -type d | sort')) do
    local flavourBr = newBr()
    loadList(dir .. "/Global.lua", flavourBr)
    for _, path in ipairs(lines('find "' .. dir .. '" -mindepth 2 -name "*.lua" | sort')) do loadList(path, flavourBr) end
    flavourBrs[#flavourBrs + 1] = flavourBr
    flavourBrByName[dir:match("([^/]+)$")] = flavourBr
end
local fakeBr = newBr()
loadList("System/Lists/Items.lua", fakeBr)
loadList("System/Lists/Pets.lua", fakeBr)
loadList("System/Lists/Specs.lua", fakeBr)

-- The profile environment: its API tables, and the power types
local profileAPI = readFile("System/Loader/ProfileAPI.lua")
local TABLES = {}
for name in profileAPI:match("local TABLES = (%b{})"):gmatch('"([%w_]+)"') do TABLES[#TABLES + 1] = name end
local powerTypes = {}
for name in profileAPI:match("local POWER_TYPES = (%b{})"):gmatch("([%a_][%w_]*)%s*=") do powerTypes[name] = true end
local pets = {}
for key in pairs(fakeBr.lists.pets or {}) do pets[key] = true end
local elements = { fire = true, earth = true, water = true, air = true }

-- The keys some spell lists give, as SpellCompiler compiles them (lists: br.lists.spells tables, e.g. the
-- flavour's Shared.Shared, DRUID.Shared and DRUID[103]); heroSpecs: the hero trees' names -> IDs
local function collectSets(lists, heroSpecs)
    local sets = { abilities = {}, buffs = {}, debuffs = {}, talents = {}, glyphs = {}, imbues = {}, items = {}, totems = {},
        heroTrees = {}, pets = pets, powerTypes = powerTypes, elements = elements }
    for _, spec in ipairs(lists) do
        for kind, entries in pairs(spec) do
            if type(entries) == "table" then
                for key, value in pairs(entries) do
                    if kind == "abilities" then sets.abilities[key] = true
                    elseif kind == "buffs" then sets.buffs[key] = true
                    elseif kind == "debuffs" then sets.debuffs[key] = true
                    elseif kind == "talents" or kind == "talentsHeroic" or kind == "traits" then
                        sets.talents[key] = true; sets.abilities[key] = true -- castable once taken
                    elseif kind == "glyphs" then sets.glyphs[key] = true
                    elseif kind == "imbues" then sets.imbues[key] = true
                    elseif kind == "items" then sets.items[key] = true
                    elseif kind == "totem" and type(value) == "table" then
                        for totemKey in pairs(value) do sets.totems[totemKey] = true end
                    end
                end
            end
        end
    end
    -- compileSpells adds the player's racial to every rotation
    sets.abilities.racial = true
    sets.buffs.racial = true
    -- Glyphs are also reachable by a short name: glyphOfFrostShock -> frostShock (ProfileAPI.lua buildGlyphs)
    for _, key in ipairs(sortedKeys(sets.glyphs)) do
        local suffix = key:match("^glyphOf(.+)$")
        if suffix then sets.glyphs[suffix:sub(1, 1):lower() .. suffix:sub(2)] = true end
    end
    for key in pairs(fakeBr.lists.items or {}) do sets.items[key] = true end
    for key in pairs(heroSpecs or {}) do sets.heroTrees[key] = true end
    return sets
end

-- Every flavour's lists together: the types of the global tables (support files, and anything without
-- its own block)
local allLists, allHeroSpecs = {}, {}
for _, flavourBr in ipairs(flavourBrs) do
    for _, class in pairs(flavourBr.lists.spells) do
        for _, spec in pairs(class) do allLists[#allLists + 1] = spec end
    end
end
for _, specs in pairs(fakeBr.lists.heroSpec or {}) do for key, id in pairs(specs) do allHeroSpecs[key] = id end end
local sets = collectSets(allLists, allHeroSpecs)

-- Each key list is one generic class, BR.Keys.<Name><T> (a field of type T per key); a table of
-- per-key entries inherits it with its entry class: BR.cast.able : BR.Keys.Abilities<BR.cast.able.Spell>
local SET_NAMES = { abilities = "Abilities", buffs = "Buffs", debuffs = "Debuffs", glyphs = "Glyphs", items = "Items",
    pets = "Pets", powerTypes = "PowerTypes", elements = "Elements", totems = "Totems" }
-- The sets a profile's flavour, class and spec decide (the others are the same for every profile)
local SCOPED = { abilities = true, buffs = true, debuffs = true, glyphs = true, items = true, totems = true }

-- Which set a placeholder stands for, by the table it's in
local function keysFor(root, placeholder)
    if placeholder == "spell" then
        if root == "buff" then return "buffs" end
        if root == "debuff" then return "debuffs" end
        return "abilities"
    end
    if placeholder == "k" then return root == "glyph" and "glyphs" or "abilities" end
    if placeholder == "item" then return "items" end
    if placeholder == "name" then return "pets" end
    if placeholder == "powerType" then return "powerTypes" end
    if placeholder == "element" then return "elements" end
    if placeholder == "totemName" then return "totems" end
    error("no keys for " .. root .. ".<" .. placeholder .. ">")
end

---------------------------------------------------------------------------------------------------
-- Docs: every documented function in System/API
---------------------------------------------------------------------------------------------------
local SHORT_TYPES = { string = "string", number = "number", int = "integer", bool = "boolean", boolean = "boolean",
    tab = "table", table = "table", func = "function" }
local TYPE_WORDS = { string = true, number = true, integer = true, boolean = true, table = true, ["function"] = true, ["nil"] = true }

-- Parameters are optional unless the doc marks them [req]: the API fills in what a profile leaves out
-- (thisUnit defaults to "player" or "target", ...), and few docs say which have defaults
local function parseTag(text, doc)
    local tag, rest = text:match("^@([%a]+%b[])%s*(.*)$")
    if not tag then tag, rest = text:match("^@(%a+)%s*(.*)$") end
    if not tag then return end
    local base, mods = tag:match("^(%a+)(.*)$")
    if base == "function" then doc.name = rest:match("^(%S+)")
    elseif base == "usage" then
        if rest ~= "" then doc.usage[#doc.usage + 1] = rest end
        doc.inUsage = true
    elseif base == "return" or base == "treturn" then
        if base == "treturn" then
            local typ, desc = rest:match("^(%S+)%s*(.*)$")
            doc.returns[#doc.returns + 1] = { type = typ or "any", desc = desc or "" }
        else
            -- "@return number, number, number x, y, z": each leading type word is one return value, and
            -- "number|nil" one value that may be nil
            local types, desc = {}, rest
            repeat
                local word, comma, after = desc:match("^([%a|]+)%s*(,?)%s*(.*)$")
                local isType = word ~= nil
                for part in (word or ""):gmatch("[^|]+") do isType = isType and TYPE_WORDS[part:lower()] end
                if isType then types[#types + 1] = word:lower(); desc = after end
            until not isType or comma == ""
            if #types == 0 then types[1] = "any" end
            for i, typ in ipairs(types) do
                doc.returns[#doc.returns + 1] = { type = typ, desc = i == #types and desc or "" }
            end
        end
    elseif base == "param" or base == "tparam" or SHORT_TYPES[base] then
        local typ, name, desc
        if base == "tparam" then typ, name, desc = rest:match("^(%S+)%s+([%w_%.]+)%s*(.*)$")
        else
            typ = SHORT_TYPES[base]
            name, desc = rest:match("^([%w_%.]+)%s*(.*)$")
        end
        if name then doc.params[#doc.params + 1] = { name = name, type = typ, desc = desc or "", required = mods:find("req", 1, true) ~= nil } end
    end
end

-- A parameter's type when the doc names none
local function guessType(name)
    if name:find("Unit$") or name == "unit" or name:find("^this") then return "string" end
    if name:find("ID$") or name:find("Id$") or name == "range" or name:find("Count$") then return "number" end
    return "any"
end

local docs = {}
for _, path in ipairs(lines('ls System/API/*.lua')) do
    local src = {}
    for l in io.lines(path) do src[#src + 1] = l end
    local i = 1
    while i <= #src do
        if src[i]:match("^%s*%-%-%-") then
            local doc = { desc = {}, params = {}, returns = {}, usage = {}, file = path }
            local j = i
            while j <= #src and src[j]:match("^%s*%-%-") do
                local text = src[j]:gsub("^%s*%-%-%-?%s?", "")
                if text:match("^%s*@") then
                    doc.inUsage = false
                    parseTag(text:gsub("^%s+", ""), doc)
                elseif doc.inUsage then
                    doc.usage[#doc.usage + 1] = text
                elseif #doc.params == 0 and #doc.returns == 0 and not doc.name then
                    doc.desc[#doc.desc + 1] = text
                elseif #doc.params > 0 and text:match("^%s%s") then
                    local last = doc.params[#doc.params]; last.desc = last.desc .. " " .. text:gsub("^%s+", "")
                end
                j = j + 1
            end
            -- The code after the block: its parameter names are the truth when it is the documented function
            local k = j
            while k <= #src and (src[k]:match("^%s*if .* then%s*$") or src[k]:match("^%s*$")) do k = k + 1 end
            local target, args = (src[k] or ""):match("^%s*([%w_%.%[%]]+)%s*=%s*function%s*%(([^)]*)%)")
            if doc.name then
                local leaf = doc.name:match("([^.]+)$"):gsub("^<(.*)>$", "%1")
                local codeLeaf = target and (target:match("%[([%w_]+)%]$") or target:match("([%w_]+)$"))
                if target and codeLeaf == leaf then
                    local byName = {}
                    for _, p in ipairs(doc.params) do byName[p.name] = p end
                    local params, n = {}, 0
                    for a in args:gmatch("[^,%s]+") do
                        n = n + 1
                        local p = byName[a] or doc.params[n] or {}
                        params[#params + 1] = { name = a, type = p.type, desc = p.desc or "", required = p.required }
                    end
                    doc.params = params
                end
                docs[#docs + 1] = doc
            end
            i = j
        else
            i = i + 1
        end
    end
end

---------------------------------------------------------------------------------------------------
-- The tree of tables and functions, from the documented names
---------------------------------------------------------------------------------------------------
local function newNode(path) return { path = path, children = {}, order = {} } end
local roots = {}
for _, doc in ipairs(docs) do
    local segs = {}
    for s in doc.name:gmatch("[^.]+") do segs[#segs + 1] = s end
    local node = roots[segs[1]] or newNode(segs[1])
    roots[segs[1]] = node
    for n = 2, #segs do
        local seg = segs[n]
        if not node.children[seg] then
            node.children[seg] = newNode(node.path .. "." .. seg)
            node.order[#node.order + 1] = seg
        end
        node = node.children[seg]
    end
    node.doc = doc
end

-- A class name per node: BR.cast.able.Spell for cast.able.<spell>
local function className(path)
    return "BR." .. path:gsub("<(%w)(%w*)>", function(a, b) return a:upper() .. b end)
end

local out = {}
local emit = function(line) out[#out + 1] = line end

local TYPE_NAMES = { bool = "boolean", int = "integer", tab = "table", func = "function", str = "string", num = "number" }
local function luaType(t) return t and (TYPE_NAMES[t] or t) or "any" end
local function signature(doc)
    local parts = {}
    for _, p in ipairs(doc.params) do
        local typ = luaType(p.type ~= "any" and p.type or guessType(p.name))
        parts[#parts + 1] = p.name .. (p.required and "" or "?") .. ": " .. typ
    end
    local rets = {}
    for _, r in ipairs(doc.returns) do rets[#rets + 1] = luaType(r.type) end
    return "fun(" .. table.concat(parts, ", ") .. ")" .. (#rets > 0 and (": " .. table.concat(rets, ", ")) or "")
end
local function docLines(doc, indent)
    for _, d in ipairs(doc.desc) do if d ~= "" then emit(indent .. "--- " .. d) end end
    if #doc.usage > 0 then
        emit(indent .. "--- ```lua")
        for _, u in ipairs(doc.usage) do emit(indent .. "--- " .. u) end
        emit(indent .. "--- ```")
    end
end

local CAST_FORMS = {}
do -- cast.<spell>.aoe(range, minUnits, unit), ...: Cast.lua's FORMS, without the call they wrap
    local forms = readFile("System/API/Cast.lua"):match("local FORMS = (%b{})")
    for name, args in forms:gmatch("\n%s*([%a]+)%s*=%s*function%(call,?%s*([^)]*)%)") do
        local params = {}
        for a in args:gmatch("[^,%s]+") do params[#params + 1] = a .. "?: " .. (a == "unit" and "string" or (a == "predict" or a == "predictPad") and "boolean" or "number") end
        CAST_FORMS[#CAST_FORMS + 1] = { name = name, sig = "fun(" .. table.concat(params, ", ") .. "): boolean" }
    end
    table.sort(CAST_FORMS, function(a, b) return a.name < b.name end)
end

-- Where classes are named and which keys they hold. The global scope (BR.cast, BR.Keys.Abilities, every
-- flavour's keys) types the global tables; a profile's scope (BR.TBC.Druid.cast, BR.Keys.TBC.Druid.Abilities,
-- its own lists' keys) types the locals in its generated block.
local GLOBAL = { prefix = "BR", keys = "BR.Keys", sets = sets }
local function scopedName(scope, path) return scope.prefix .. className(path):sub(3) end

-- True when a table's class depends on the scope's keys (it, or a table in it, holds per-key entries of a
-- scoped set, or keyed fields: talent.<key>)
local dependsMemo = {}
local function dependsOnKeys(node, root)
    if dependsMemo[node] ~= nil then return dependsMemo[node] end
    local depends = node.keyedExtras ~= nil
    for _, seg in ipairs(node.order) do
        local child = node.children[seg]
        local placeholder = seg:match("^<(%w+)>$")
        if (placeholder and SCOPED[keysFor(root, placeholder)]) or dependsOnKeys(child, root) then depends = true end
    end
    dependsMemo[node] = depends
    return depends
end

local emitted, hasBase, var = {}, {}, 0
-- Emits a table's class for a scope and returns its name. A class that doesn't depend on the keys is
-- emitted once, globally. One that does is split: <class>.Base holds what every scope shares (functions,
-- fields, call signature), and each scope's class adds its own keys on top.
local function emitClass(node, root, scope)
    local global = node.class or className(node.path)
    local depends = dependsOnKeys(node, root)
    if scope ~= GLOBAL and not depends then return global end
    local cls = scope == GLOBAL and global or scopedName(scope, node.path)
    if emitted[cls] then return cls end
    emitted[cls] = true
    local block = {} -- this class's lines; its children's blocks come first
    local outerEmit = emit
    emit = function(line) block[#block + 1] = line end
    -- children first, so their classes exist (LuaLS doesn't mind the order, readers do)
    local keyParents, staticParents, keyFields_, staticFields, functions = {}, {}, {}, {}, {}
    for _, seg in ipairs(node.order) do
        local child = node.children[seg]
        local placeholder = seg:match("^<(%w+)>$")
        if placeholder then
            local kind = keysFor(root, placeholder)
            local keys = SCOPED[kind] and scope.keys or GLOBAL.keys
            local parent = keys .. "." .. SET_NAMES[kind] .. "<" .. emitClass(child, root, scope) .. ">"
            if SCOPED[kind] or dependsOnKeys(child, root) then keyParents[#keyParents + 1] = parent
            else staticParents[#staticParents + 1] = parent end
        elseif next(child.children) == nil and child.doc then
            functions[#functions + 1] = child
        else
            -- A literal key that is also one of a placeholder's keys (power.runes) extends that class
            for _, other in ipairs(node.order) do
                local ph = other:match("^<(%w+)>$")
                if ph and GLOBAL.sets[keysFor(root, ph)][seg] then
                    child.base = className(node.children[other].path)
                    child.baseNode = node.children[other]
                end
            end
            local field = { name = seg, type = emitClass(child, root, scope) }
            if dependsOnKeys(child, root) then keyFields_[#keyFields_ + 1] = field
            else staticFields[#staticFields + 1] = field end
        end
    end
    if node.base then staticParents[#staticParents + 1] = node.base end

    -- What every scope shares: in the class itself, or in <class>.Base when the class depends on the keys
    local function emitShared(name, parents)
        emit("---@class " .. name .. (#parents > 0 and (" : " .. table.concat(parents, ", ")) or ""))
        -- a subclass repeats its base's call signature (not every language server inherits it)
        local callDoc = node.doc or (node.baseNode and node.baseNode.doc)
        if callDoc then emit("---@overload " .. signature(callDoc)) end
        if node.path:match("^cast%.<spell>$") or node.path:match("^cast%.able%.<spell>$") or node.path:match("^cast%.opener%.<spell>$") then
            for _, form in ipairs(CAST_FORMS) do emit("---@field " .. form.name .. " " .. form.sig) end
            emit("---@field rank fun(rank: integer): " .. name .. " The spell at a rank (or the highest known below it)")
            emit("---@field forAmount fun(amount: number): " .. name .. " The lowest known rank that heals (or hits) for at least amount, else the highest")
            emit("---@field whileCasting " .. name .. " Goes out even while you cast or channel, for spells the game allows then (SimC use_while_casting)")
        end
        if node.path:match("^use%.<item>$") then
            emit("---@field whileCasting fun(slotID?: number, thisUnit?: string): boolean Uses it even while you cast or channel, for items the game allows then")
        end
        for _, extra in ipairs(node.extraFields or {}) do emit("---@field " .. extra) end
        for _, f in ipairs(staticFields) do emit("---@field " .. f.name .. " " .. f.type) end
        var = var + 1
        local v = "C" .. var
        emit("local " .. v .. " = {}")
        for _, fnNode in ipairs(functions) do
            local doc, fnName = fnNode.doc, fnNode.path:match("([^.]+)$")
            emit("")
            docLines(doc, "")
            for _, p in ipairs(doc.params) do
                local typ = luaType(p.type ~= "any" and p.type or guessType(p.name))
                emit("---@param " .. p.name .. (p.required and "" or "?") .. " " .. typ .. (p.desc ~= "" and (" " .. p.desc) or ""))
            end
            for _, r in ipairs(doc.returns) do emit("---@return " .. luaType(r.type) .. (r.desc ~= "" and (" # " .. r.desc) or "")) end
            local args = {}
            for _, p in ipairs(doc.params) do args[#args + 1] = p.name end
            emit("function " .. v .. "." .. fnName .. "(" .. table.concat(args, ", ") .. ") end")
        end
    end

    emit("")
    if not depends then
        if node.doc then docLines(node.doc, "") end
        emitShared(cls, staticParents)
    else
        local hasShared = node.doc or node.baseNode or node.extraFields or #staticFields > 0 or #functions > 0
            or #staticParents > 0
        if scope == GLOBAL and hasShared then
            emitShared(cls .. ".Base", staticParents)
            hasBase[cls] = true
            emit("")
        end
        if node.doc then docLines(node.doc, "") end
        local parents = {}
        if hasBase[global] then parents[1] = global .. ".Base" end
        for _, p in ipairs(keyParents) do parents[#parents + 1] = p end
        emit("---@class " .. cls .. (#parents > 0 and (" : " .. table.concat(parents, ", ")) or ""))
        if node.doc then emit("---@overload " .. signature(node.doc)) end
        for _, extra in ipairs(node.keyedExtras and node.keyedExtras(scope) or {}) do emit("---@field " .. extra) end
        for _, f in ipairs(keyFields_) do emit("---@field " .. f.name .. " " .. f.type) end
    end
    emit = outerEmit
    emit(BLOCK)
    for _, line in ipairs(block) do emit(line) end
    return cls
end

---------------------------------------------------------------------------------------------------
-- The parts without @function docs: data tables and the profile's own state
---------------------------------------------------------------------------------------------------
local function keyFields(set, typ) local t = {} for _, k in ipairs(sortedKeys(set)) do t[#t + 1] = k .. " " .. typ end return t end
roots.talent = roots.talent or newNode("talent")
roots.talent.keyedExtras = function(scope)
    local fields = keyFields(scope.sets.talents, "boolean # true while the talent is taken")
    table.insert(fields, 1, "rank " .. scope.prefix .. ".talent.rank The rank of each talent (0 when not taken)")
    return fields
end
roots.heroTree = roots.heroTree or newNode("heroTree")
roots.heroTree.keyedExtras = function(scope) return keyFields(scope.sets.heroTrees, "boolean # true for the active hero talent tree") end
roots.imbues = roots.imbues or newNode("imbues")
roots.imbues.keyedExtras = function(scope) return keyFields(scope.sets.imbues, "integer # the weapon enchant ID") end
roots.ui = roots.ui or newNode("ui")
roots.ui.extraFields = { "mode table<string, integer> Each toggle's current mode, by the toggle's name with a lower-case first letter: ui.mode.rotation",
    "dropOptions table<string, string[]> The choices of BR's shared dropdowns (Toggle: the key names, ...)" }
roots.units = roots.units or newNode("units")
roots.units.extraFields = { "friends BR.Friend[] The group members the healing engine keeps" }
for _, r in ipairs({ 5, 8, 10, 12, 15, 20, 25, 30, 35, 40 }) do
    table.insert(roots.units.extraFields, ("dyn%d string? The best unit within %d yards you face (units.get(%d))"):format(r, r, r))
    table.insert(roots.units.extraFields, ("dyn%dAOE string? The best unit within %d yards (units.get(%d, true))"):format(r, r, r))
end
roots.enemies = roots.enemies or newNode("enemies")
-- The lists enemies.get() / .cone.get() / .rect.get() make (Functions/Misc/Units.lua setEnemiesVariable):
-- yards<range><shape: r rect, c cone><unit: t target, p pet, f focus, m mouseover><nc: out of combat too><f: facing>.
-- Named fields, not an indexer: not every language server reads indexers, and named ones complete
roots.enemies.extraFields = {}
do
    local ranges = { [5] = true, [8] = true, [10] = true, [15] = true, [20] = true, [25] = true, [30] = true, [40] = true }
    for _, path in ipairs(lines('find Rotations -name "*.lua"')) do
        local text = readFile(path)
        for range in text:gmatch("enemies%.yards(%d+)") do ranges[tonumber(range)] = true end
        for range in text:gmatch("enemies%.get%(%s*(%d+)") do ranges[tonumber(range)] = true end
        for range in text:gmatch("enemies%.%a+%.get%(%s*%d+%s*,%s*(%d+)") do ranges[tonumber(range)] = true end
    end
    -- Focus and facing share the suffix "f" (yards8f is either), so a name can come up twice
    local seen = {}
    for _, range in ipairs(sortedKeys(ranges)) do
        for _, shape in ipairs({ "", "c", "r" }) do
            for _, who in ipairs({ "", "t", "p", "f", "m" }) do
                for _, nc in ipairs({ "", "nc" }) do
                    for _, facing in ipairs({ "", "f" }) do
                        local name = "yards" .. range .. shape .. who .. nc .. facing
                        if not seen[name] then
                            seen[name] = true
                            table.insert(roots.enemies.extraFields, name .. " string[] Enemies within " .. range .. " yards (enemies.get)")
                        end
                    end
                end
            end
        end
    end
end
roots.var = roots.var or newNode("var")
roots.var.class = "table"

local HEADER = {
    "---@meta",
    "---@diagnostic disable: missing-fields",
    "-- GENERATED by Types/generate.lua from System/API's doc blocks, System/Loader/ProfileAPI.lua and the spell",
    "-- lists. Do not edit: change those and run `luajit Types/generate.lua` from the BR folder.",
    "-- The profile API as the Lua language server sees it, so the editor completes and documents what",
    "-- profiles use. The game never loads these files.",
}
emit("--- A group member the healing engine keeps")
emit("---@class BR.Friend")
emit("---@field unit string The unit token (player, party1, raid12, ...)")
emit("---@field hp number Health percent, with incoming heals")
emit("---@field role string TANK, HEALER or DAMAGER")
emit("---@field guid string")
emit("")
-- A scope's key lists (the global scope has every set; a profile's only the ones its lists decide)
local function emitKeys(scope)
    for _, key in ipairs(sortedKeys(SET_NAMES)) do
        if scope == GLOBAL or SCOPED[key] then
            emit(BLOCK)
            emit("---@class " .. scope.keys .. "." .. SET_NAMES[key] .. "<T>")
            for _, k in ipairs(sortedKeys(scope.sets[key])) do emit("---@field " .. k .. " T") end
        end
    end
    emit(BLOCK)
    emit("---@class " .. scope.prefix .. ".talent.rank")
    for _, k in ipairs(sortedKeys(scope.sets.talents)) do emit("---@field " .. k .. " integer") end
end
emitKeys(GLOBAL)

local globalClass = {}
for _, name in ipairs(TABLES) do
    local node = roots[name]
    if node and node.class ~= "table" then globalClass[name] = emitClass(node, name, GLOBAL)
    else globalClass[name] = node and node.class or "table" end
end

---------------------------------------------------------------------------------------------------
-- Each profile's scope: the keys of its flavour's lists for its class and spec(s), as SpellCompiler
-- picks them (Shared.Shared, <CLASS>.Shared, <CLASS>[specID]), for the block of locals at its top
---------------------------------------------------------------------------------------------------
local specNames = {} -- CLASS -> spec ID -> name (System/Lists/Specs.lua)
for class, specs in pairs(fakeBr.lists.spec or {}) do
    specNames[class] = {}
    for specName, id in pairs(specs) do specNames[class][id] = specName end
end
local function classFolder(path) return path:match("^Rotations/([^/]+)/") end
local function classToken(folder) return folder:upper():gsub("%s", "") end

-- The flavour, class and spec IDs a profile registers for (nil for a file that registers nothing)
local function registration(path, text)
    local def = text:match("registerRotation%s*(%b())")
    if not def or not classFolder(path) then return nil end -- the sample rotation has no class
    local flavour = def:match('expansion%s*=%s*"(%w+)"')
    local specText = def:match("specID%s*=%s*(%b{})") or def:match("specID%s*=%s*(%d+)")
    if not (flavour and specText) then error(path .. ": can't read registerRotation's expansion and specID") end
    local specs = {}
    local enabled = false
    for id in specText:gmatch("%d+") do
        specs[#specs + 1] = tonumber(id)
        if tonumber(id) ~= 0 then enabled = true end
    end
    -- specID 0 matches no spec: the profile is switched off and gets no block
    if not enabled then return { disabled = true } end
    return { flavour = flavour, class = classToken(classFolder(path)), classFolder = classFolder(path):gsub("%s", ""), specs = specs }
end

local scopes = {} -- by name
local function scopeFor(reg)
    local flavourBr = assert(flavourBrByName[reg.flavour], "no Expansions/" .. reg.flavour)
    local spells = flavourBr.lists.spells
    local classLists = spells[reg.class] or {}
    local lists, nameParts = { spells.Shared and spells.Shared.Shared or {}, classLists.Shared or {} }, {}
    local specIDs, seen = {}, {}
    for _, id in ipairs(reg.specs) do
        if not seen[id] then seen[id] = true; specIDs[#specIDs + 1] = id end
    end
    table.sort(specIDs)
    for _, id in ipairs(specIDs) do
        if classLists[id] then
            lists[#lists + 1] = classLists[id]
            nameParts[#nameParts + 1] = (specNames[reg.class] or {})[id] or tostring(id)
        end
    end
    local name = reg.flavour .. "." .. reg.classFolder .. (#nameParts > 0 and ("." .. table.concat(nameParts, "_")) or "")
    if not scopes[name] then
        -- Hero trees only exist on clients with them (Retail)
        local heroSpecs = reg.flavour == "Retail" and (fakeBr.lists.heroSpec or {})[reg.class] or nil
        scopes[name] = { name = name, prefix = "BR." .. name, keys = "BR.Keys." .. name, sets = collectSets(lists, heroSpecs) }
    end
    return scopes[name]
end

local profiles = {} -- { path, text, scope }
local supportCallers = {} -- support file path -> the scopes of the profiles that load it
for _, path in ipairs(lines('find Rotations -name "*.lua" -not -path "*/Support/*" | sort')) do
    local text = readFile(path)
    local reg = registration(path, text)
    if reg and reg.disabled then
        profiles[#profiles + 1] = { path = path, text = text }
    elseif reg then
        local scope = scopeFor(reg)
        profiles[#profiles + 1] = { path = path, text = text, scope = scope }
        for name in text:gmatch('loadSupport%(%s*"([%w_]+)"%s*%)') do
            local support = "Rotations/" .. classFolder(path) .. "/Support/" .. name .. ".lua"
            supportCallers[support] = supportCallers[support] or {}
            supportCallers[support][#supportCallers[support] + 1] = reg
        end
    end
end
-- A support file gets the keys of the profiles that load it, when they share a flavour and class
for _, support in ipairs(sortedKeys(supportCallers)) do
    local callers = supportCallers[support]
    local merged = { flavour = callers[1].flavour, class = callers[1].class, classFolder = callers[1].classFolder, specs = {} }
    local shared = true
    for _, reg in ipairs(callers) do
        if reg.flavour ~= merged.flavour or reg.class ~= merged.class then shared = false end
        for _, id in ipairs(reg.specs) do merged.specs[#merged.specs + 1] = id end
    end
    local f = io.open(support)
    if shared and f then
        local text = f:read("*a"); f:close()
        profiles[#profiles + 1] = { path = support, text = text, scope = scopeFor(merged) }
    elseif f then f:close() end
end

local scopedClass = {} -- scope name -> table name -> class
for _, name in ipairs(sortedKeys(scopes)) do
    local scope = scopes[name]
    emitKeys(scope)
    scopedClass[name] = {}
    for _, tableName in ipairs(TABLES) do
        local node = roots[tableName]
        if node and node.class ~= "table" and dependsOnKeys(node, tableName) then
            scopedClass[name][tableName] = emitClass(node, tableName, scope)
        end
    end
end

emit(BLOCK)
emit("--- What registerRotation takes (System/Loader/ProfileLoader.lua)")
emit("---@class BR.RotationDefinition")
emit("---@field name string Shown in the rotation dropdown; unique for the spec")
emit("---@field specID integer|integer[] The spec ID(s) it is for")
emit('---@field expansion "Retail"|"MOP"|"TBC"|"Classic"|"Forever" The flavour it is for')
emit("---@field run fun(): boolean? Runs every tick")
emit("---@field toggles? fun() Builds the toggle bar (ui.toggle)")
emit("---@field options? fun()|table Builds the Rotation Options page, or a list of { page name, build function }")
emit("---@field author? string Shown in README.md's profile list")
emit("")
emit("--- Registers this file's rotation; BR offers it when specID and expansion match the player.")
emit("---@param def BR.RotationDefinition")
emit("---@return boolean # true when registered for the player's spec and flavour")
emit("function registerRotation(def) end")
emit("")
emit("--- Runs Rotations/<Class>/Support/<name>.lua and returns what it returns (its options and run functions).")
emit("---@param name string")
emit("---@return table")
emit("function loadSupport(name) end")
emit("")
for _, name in ipairs(TABLES) do
    emit("---@type " .. globalClass[name])
    emit(name .. " = {}")
end

-- Into files at block boundaries
os.execute('mkdir -p "' .. OUT_DIR .. '" && rm -f "' .. OUT_DIR .. '"/*.lua')
local files, current, size = {}, nil, 0
local function newFile() current = {}; size = 0; files[#files + 1] = current; for _, h in ipairs(HEADER) do current[#current + 1] = h end end
newFile()
local blocks, block = {}, {}
for _, line in ipairs(out) do
    if line == BLOCK then blocks[#blocks + 1] = block; block = {} else block[#block + 1] = line end
end
blocks[#blocks + 1] = block
for _, b in ipairs(blocks) do
    local text = table.concat(b, "\n")
    if size > 0 and size + #text > MAX_FILE then newFile() end
    current[#current + 1] = ""
    current[#current + 1] = text
    size = size + #text
end
for n, lines_ in ipairs(files) do
    local f = assert(io.open(("%s/%02d.lua"):format(OUT_DIR, n), "w"))
    f:write(table.concat(lines_, "\n"), "\n")
    f:close()
end
print(("%s: %d files, %d documented functions, %d ability keys, %d buffs, %d debuffs, %d items"):format(OUT_DIR, #files,
    #docs, #sortedKeys(sets.abilities), #sortedKeys(sets.buffs), #sortedKeys(sets.debuffs), #sortedKeys(sets.items)))

---------------------------------------------------------------------------------------------------
-- The block of locals at the top of each profile: the API tables with keys, typed for its scope, so the
-- editor completes only what the profile has. Written in place; with another out folder only checked
---------------------------------------------------------------------------------------------------
local MARK = "-- Editor types: "

-- The code alone: comments and string literals blanked, so words in them don't count as uses
---@param text string
---@return string
local function codeOnly(text)
    local parts, i, n = {}, 1, #text
    while i <= n do
        local c = text:sub(i, i)
        local long = text:match("^%-%-%[(=*)%[", i) or (c == "[" and text:match("^%[(=*)%[", i))
        if long then
            local open = text:match("^%-%-%[=*%[", i) or text:match("^%[=*%[", i)
            local close = text:find("]" .. long .. "]", i + #open, true)
            i = (close or n) + #long + 2
            parts[#parts + 1] = " "
        elseif text:sub(i, i + 1) == "--" then
            local eol = text:find("\n", i, true) or n + 1
            i = eol
        elseif c == '"' or c == "'" then
            local j = i + 1
            while j <= n and text:sub(j, j) ~= c and text:sub(j, j) ~= "\n" do
                if text:sub(j, j) == "\\" then j = j + 1 end
                j = j + 1
            end
            i = j + 1
            parts[#parts + 1] = " "
        else
            parts[#parts + 1] = c
            i = i + 1
        end
    end
    return table.concat(parts)
end

-- body: the profile without its block; only the tables its code uses get a local (no unused-local hints)
---@param scope table
---@param body string
---@return string[]|nil
local function profileBlock(scope, body)
    local code = codeOnly(body)
    local result = { MARK .. "the keys of " .. scope.name:gsub("%.", " ") .. "'s spell lists (written by Types/generate.lua)" }
    for _, tableName in ipairs(TABLES) do
        local cls = scopedClass[scope.name][tableName]
        if cls and code:find("%f[%w_.:]" .. tableName .. "%s*[%.%[(]") then
            result[#result + 1] = ("local %s = %s --[[@as %s]]"):format(tableName, tableName, cls)
        end
    end
    return #result > 1 and result or nil
end

-- The file with its block put in (replacing the one there): after the comments it starts with
---@param text string
---@param blockLines string[]|nil
---@return string
local function withBlock(text, blockLines)
    local nl = text:find("\r\n", 1, true) and "\r\n" or "\n"
    local src = {}
    for l in (text:gsub("\r\n", "\n") .. (text:sub(-1) == "\n" and "" or "\n")):gmatch("([^\n]*)\n") do src[#src + 1] = l end
    local start
    for i, l in ipairs(src) do if l:sub(1, #MARK) == MARK then start = i break end end
    if start then
        local stop = start
        while src[stop + 1] and src[stop + 1]:match("^local [%w_]+ = [%w_]+ %-%-%[%[@as ") do stop = stop + 1 end
        for _ = start, stop do table.remove(src, start) end
        -- No block any more (a switched-off profile): also drop the blank line written after it
        if not blockLines and src[start] and src[start]:match("^%s*$") then table.remove(src, start) end
    elseif not blockLines then
        return text
    else
        start = 1
        while src[start] and (src[start]:match("^%-%-") or src[start]:match("^%s*$")) do start = start + 1 end
        table.insert(src, start, "")
    end
    for i, l in ipairs(blockLines or {}) do table.insert(src, start + i - 1, l) end
    return table.concat(src, nl) .. nl
end

local writeProfiles = OUT_DIR == "Types/ProfileAPI"
local stale = 0
for _, p in ipairs(profiles) do
    local new = withBlock(p.text, p.scope and profileBlock(p.scope, withBlock(p.text, nil)))
    if new ~= p.text then
        if writeProfiles then
            local f = assert(io.open(p.path, "wb")); f:write(new); f:close()
            print("  block written: " .. p.path)
        else
            stale = stale + 1
            print("  stale block: " .. p.path)
        end
    end
end
print(("%d profiles in %d scopes"):format(#profiles, #sortedKeys(scopes)) .. (writeProfiles and "" or (", " .. stale .. " stale")))

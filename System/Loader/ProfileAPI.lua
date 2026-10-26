local _, br = ...
--- Profile API
-- br.api.profile is everything a profile sees: the API tables (buff, cast, unit, ui, ...), built here
-- by the br.api.build.* builders (System/API) from the spell lists br.loader.spellCompiler compiles,
-- plus registerRotation, loadSupport and Lua's standard library. Profile files run with it as their
-- environment (ProfileLoader.lua), so they use these by name and reach nothing else: reading a name
-- that isn't here, or setting a global, is an error that names the line.
br.loader.profileAPI = br.loader.profileAPI or {}
local profileAPI = br.loader.profileAPI
local spellCompiler = br.loader.spellCompiler

-- The API tables. Each keeps its identity for the session, so a profile may hold on to one; a new
-- spec empties them (profileAPI:reset) and the build fills them again.
local TABLES = { "buff", "cast", "cd", "charges", "debuff", "enemies", "equiped", "glyph", "has", "heroTree",
    "imbues", "module", "pet", "power", "spell", "talent", "totem", "ui", "unit", "units", "use", "util", "var" }
-- Lua's standard library, as profiles may use it
local LUA = { "assert", "error", "getmetatable", "ipairs", "math", "next", "pairs", "pcall", "rawequal", "rawget",
    "rawset", "select", "setmetatable", "string", "table", "tonumber", "tostring", "type", "unpack", "xpcall" }

local profile = {}
br.api.profile = profile
for _, name in ipairs(TABLES) do profile[name] = {} end
for _, name in ipairs(LUA) do profile[name] = br.game[name] end
profile.print = function(...)
    local parts = {}
    for i = 1, select("#", ...) do parts[i] = tostring((select(i, ...))) end
    return br.log:print(table.concat(parts, " "))
end
profile.registerRotation = function(def) return br.loader.registerRotation(def) end
profile.loadSupport = function(name) return br.loader.profileLoader:loadSupport(name) end
setmetatable(profile, {
    __index = function(_, name)
        error("\"" .. tostring(name) .. "\" is not in the profile API", 2)
    end,
    __newindex = function(_, name)
        error("profiles can't set globals (\"" .. tostring(name) .. "\"); make it local", 2)
    end,
})

-- Parts built once per spec: their builders make every function in one go
local builtOnce = false

--- Empties the API tables for a new spec (Rotation:new); the next build fills them again.
function profileAPI:reset()
    for _, name in ipairs(TABLES) do br.game.wipe(profile[name]) end
    builtOnce = false
end

-- Builds talent.X (including hero talents) and heroTree.
local function buildTalents(rotation, spec)
    local allTalents, listed = spellCompiler:compileTalents(rotation, spec)
    spellCompiler:compileHeroTree(profile.heroTree)

    -- The compiled talent state, for the layers below the profile API (spell:hasTalent / getTalentRank)
    rotation.talentInfo = allTalents
    rotation.talentIDs = listed

    for name, spellID in pairs(listed) do
        br.api.build.talent(profile.talent, name, allTalents[spellID])
    end
end

-- Power types by their names in power.<type>
local POWER_TYPES = {
    mana = 0, rage = 1, focus = 2, energy = 3, comboPoints = 4, runes = 5, runicPower = 6, soulShards = 7,
    astralPower = 8, holyPower = 9, altPower = 10, maelstrom = 11, chi = 12, insanity = 13, arcaneCharges = 16,
    fury = 17, pain = 18, essence = 19,
}

-- Builds power.<type> functions for every power type.
local function buildPower()
    local power = profile.power
    power.list = POWER_TYPES
    for k, v in pairs(POWER_TYPES) do
        if not power[k] then power[k] = {} end
        br.api.build.power(power, k, v)
    end
end

-- Builds buff.X and debuff.X functions (ranked auras resolve to the highest known rank).
local function buildAuras(rotation)
    local spells = rotation.spells
    for k, v in pairs(spells.buffs) do
        if k ~= "rollTheBones" then
            if profile.buff[k] == nil then profile.buff[k] = {} end
            local resolvedID = spellCompiler:resolve(v)
            if resolvedID ~= v then
                -- The resolved ID, for icon references
                spells.buffs[k] = resolvedID
                spells[k] = resolvedID
            end
            br.api.build.buffs(profile.buff, k, v) -- the rank list: buff.X picks the current rank itself
        end
    end
    for k, v in pairs(spells.debuffs) do
        if profile.debuff[k] == nil then profile.debuff[k] = {} end
        local resolvedID = spellCompiler:resolve(v)
        if resolvedID ~= v then
            spells.debuffs[k] = resolvedID
            spells[k] = resolvedID
        end
        br.api.build.debuffs(profile.debuff[k], k, v) -- the rank list: debuff.X picks the current rank itself
    end
end

-- Builds the parts made once per spec: power, units, enemies, unit, totem, the item-ID functions of
-- equiped/has/use, pet, glyph, ui, util and module
-- (module captures ui, so ui comes first).
local function buildOnce()
    if builtOnce then return end
    builtOnce = true
    buildPower()
    br.api.build.units(profile)
    br.api.build.enemies(profile)
    br.api.build.unit(profile)
    br.api.build.totem(profile)
    br.api.build.equiped(profile)
    br.api.build.has(profile)
    br.api.build.use(profile)
    br.api.build.pet(profile, br.lists.pets)
    br.api.build.glyph(profile)
    br.api.build.ui(profile)
    br.api.build.util(profile)
    br.api.build.module(profile)
end

-- Builds glyph functions, plus glyphOfX -> x convenience aliases.
local function buildGlyphs(rotation)
    local glyph = profile.glyph
    for k, v in pairs(rotation.spells.glyphs or {}) do
        glyph[k] = glyph[k] or {}
        br.api.build.glyphs(glyph, k, v)
        -- Convenience alias: glyphOfFrostShock -> frostShock
        if type(k) == "string" and k:sub(1, 7) == "glyphOf" then
            local suffix = k:sub(8)
            if suffix ~= "" then
                local alias = suffix:sub(1, 1):lower() .. suffix:sub(2)
                if glyph[alias] == nil then glyph[alias] = glyph[k] end
            end
        end
    end
end

-- Builds cd, charges, equiped, has and use functions for every item.
local function buildItems(rotation)
    -- The equipped heirloom neck (0 when none) changes with gear, and builds run again on gear changes
    rotation.items.heirloomNeck = br.functions.item:getHeirloomNeck()
    if profile.use.able == nil then profile.use.able = {} end             -- Useable Item Check Functions
    for item, id in pairs(rotation.items) do
        if profile.charges[item] == nil then profile.charges[item] = {} end
        br.api.build.itemCD(profile.cd, item, id)
        br.api.build.itemCharges(profile.charges, item, id)
        br.api.build.equipedItem(profile.equiped, item, id)
        br.api.build.hasItem(profile.has, item, id)
        br.api.build.useItem(profile.use, item, id)
    end
end

-- Builds cast, charges, cd and spell functions for every ability.
local function buildAbilities(rotation)
    local spells = rotation.spells
    for spell, id in pairs(spells.abilities) do
        -- Rank tables (Classic-era) resolve to the highest known rank
        local resolvedID = spellCompiler:resolve(id)
        if resolvedID ~= id then
            spells.abilities[spell] = resolvedID
            spells[spell] = resolvedID
        end
        br.api.build.cast(profile, spell, resolvedID)
        br.api.build.charges(profile.charges, spell, resolvedID)
        br.api.build.cd(profile, spell, resolvedID)
        br.api.build.spell(profile, spell, resolvedID)
    end
    -- cast.racial / cast.able.racial exist even when the race has no racial
    local cast = profile.cast
    if cast.able == nil then cast.able = {} end
    if cast.racial == nil then cast.racial = function() return false end end
    if cast.able.racial == nil then cast.able.racial = function() return false end end
end

--- Builds the profile API for the rotation's spec (rotation.spells already compiled).
-- @param rotation br.runner
-- @param spec Spec ID
function profileAPI:build(rotation, spec)
    buildTalents(rotation, spec)
    buildAuras(rotation)
    br.game.wipe(profile.imbues)
    for k, v in pairs(rotation.spells.imbues or {}) do profile.imbues[k] = v end
    buildGlyphs(rotation)
    buildItems(rotation)
    buildAbilities(rotation)
    buildOnce()
end

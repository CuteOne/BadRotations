local _, br = ...
--- Spell Compiler
-- Turns the expansion spell lists (br.lists.spells) into br.player.spells, maps talent and
-- hero tree state, and validates the lists against the client. Used by builder:new().
br.loader.spellCompiler = br.loader.spellCompiler or {}
local spellCompiler = br.loader.spellCompiler

-- Spec IDs of 1400+ are class-level "Initial" specs (no spec-specific spell lists).
local INITIAL_SPEC_ID = 1400
local function isInitialSpec(spec)
    return spec >= INITIAL_SPEC_ID
end

-- Each broken spell/talent ID prints exactly once per WoW session.
local warnedOnce = {}
local function warnOnce(key, message)
    if warnedOnce[key] then return end
    warnedOnce[key] = true
    br._G.print(message)
end

-- Spell list sources for the player's class and spec, in load order (later sources win
-- unless an earlier entry came from the spec list).
local function getSources(spec)
    -- Lazy-load the spec's spell file if not yet cached (MOP/Retail only)
    if br.api.hasSubSpecs and br.lists and br.lists.loadSpecSpells then
        br.lists:loadSpecSpells(br.loader.selectedSpec)
    end
    local playerClass = select(2, br._G.UnitClass('player'))
    local sources = {
        { list = br.lists.spells["Shared"]["Shared"], origin = "global" },
        { list = br.lists.spells[playerClass]["Shared"], origin = "sharedClass" },
    }
    -- Spec Spells - Don't Load on Initial Levels
    if br.lists.spells[playerClass][spec] ~= nil then
        sources[#sources + 1] = { list = br.lists.spells[playerClass][spec], origin = "spec" }
    end
    return sources
end

-- Stores spellID under spells[spellType][spellRef] unless a spec entry already holds it.
local function assign(player, spellType, spellRef, spellID, origin)
    local existingSource = player.spellSource[spellType][spellRef]
    if existingSource == "spec" and origin ~= "spec" then return false end
    player.spells[spellType][spellRef] = spellID
    player.spellSource[spellType][spellRef] = origin or "shared"
    return true
end

-- Active (castable) spells are also exposed in spells.abilities and spells[spellRef].
local function isActiveType(spellType, spec)
    return spellType == 'abilities' or spellType == 'covenants'
        or ((spellType == 'traits' or spellType == 'talents' or spellType == 'talentsHeroic') and not isInitialSpec(spec))
end

-- Compile one spell list into player.spells
local function compileList(player, spellTable, origin, spec)
    for spellType, spellTypeTable in pairs(spellTable) do
        player.spells[spellType] = player.spells[spellType] or {}
        player.spellSource[spellType] = player.spellSource[spellType] or {}
        for spellRef, spellID in pairs(spellTypeTable) do
            if spellType == 'items' then
                player.items = player.items or {}
                player.items[spellRef] = spellID
            else
                assign(player, spellType, spellRef, spellID, origin)
                -- (imbues are never active: their values are enchant IDs, not spell IDs)
                if isActiveType(spellType, spec) and type(spellID) ~= 'table' and not br._G.C_Spell.IsSpellPassive(spellID) then
                    player.spells.abilities = player.spells.abilities or {}
                    player.spellSource["abilities"] = player.spellSource["abilities"] or {}
                    if assign(player, "abilities", spellRef, spellID, origin) then
                        player.spells[spellRef] = spellID
                    end
                end
            end
        end
    end
end

-- Lists already checked this session: builds run again on every gear, talent and level change,
-- and a list's IDs don't change in between
local validated = setmetatable({}, { __mode = "k" })

-- Warn about list entries whose IDs the client doesn't recognise (once per list per session).
local function validateList(spellTable)
    if validated[spellTable] then return end
    validated[spellTable] = true
    local function check(spellType, spellRef, id)
        local name, _, _, _, _, _, gsiSpellID = br.api.wow.GetSpellInfo(id)
        if not name or gsiSpellID ~= id then
            warnOnce(spellType .. "_" .. spellRef .. "_" .. tostring(id),
                "|cffff0000" .. spellType .. ": |r" .. spellRef .. "|cffff0000 with ID: |r" .. id
                .. "|cffff0000 is not valid in the list of " .. spellType .. " Spell List.")
        end
    end
    for spellType, spellTypeTable in pairs(spellTable) do
        if spellType ~= 'items' and spellType ~= 'imbues' then
            for spellRef, spellID in pairs(spellTypeTable) do
                if type(spellID) ~= "table" then
                    check(spellType, spellRef, spellID)
                else
                    -- Rank lists: check each numeric rank (nested tables, e.g. totems, resolve at runtime)
                    for rankRef, id in pairs(spellID) do
                        if type(id) == "number" then check(spellType, rankRef, id) end
                    end
                end
            end
        end
    end
end

--- Builds player.spells (and player.items / player.imbues) for the given spec.
-- @param player The br.player object being built
-- @param spec Spec ID
function spellCompiler:compileSpells(player, spec)
    player.spells = player.spells or {}
    player.spellSource = player.spellSource or {}
    for _, source in ipairs(getSources(spec)) do
        validateList(source.list)
        compileList(player, source.list, source.origin, spec)
    end

    -- Expose imbues directly on br.player for clean profile access (br.player.imbues)
    player.imbues = player.spells.imbues or {}

    -- Ending the Race War!
    if player.spells.abilities["racial"] == nil then
        -- 0 means "this race has no racial for cast.racial()". The key must still exist
        -- so a profile can call cast.racial() unconditionally; createCastFunction
        -- returns false for 0 without complaint.
        local racialID = br.functions.spell:getRacial() or 0
        player.spells.abilities["racial"] = racialID
        player.spells.buffs["racial"] = racialID
        player.spells["racial"] = racialID
    end
end

-- Warn about active talents missing from the lists, or listed with the wrong ID.
local function validateTalents(allTalents, spec)
    if isInitialSpec(spec) or not (br.lists and br.lists.spells) then return end
    local playerClass = select(2, br._G.UnitClass('player'))
    local classLists = br.lists.spells[playerClass]
    if not (classLists and classLists["Shared"] and classLists[spec]) then return end
    local heroicTalents = classLists["Shared"]["talentsHeroic"] or {}
    local sharedTalents = classLists["Shared"]["talents"] or {}
    local specTalents = classLists[spec]["talents"] or {}

    for talentID, talentData in pairs(allTalents) do
        if talentData.active then
            local spellName = br.api.wow.GetSpellInfo(talentID)
            if spellName then
                local talentName = br.functions.misc:convertName(spellName)
                if sharedTalents[talentName] == nil and specTalents[talentName] == nil and heroicTalents[talentName] == nil then
                    warnOnce("talent_missing_" .. talentName .. "_" .. tostring(talentID),
                        "|cffff0000Talent: |r" .. talentName .. "|cffff0000 with ID: |r" .. talentID .. " is not listed in the Talents Spell List.")
                elseif (specTalents[talentName] ~= nil and specTalents[talentName] ~= talentID) or
                       (sharedTalents[talentName] ~= nil and sharedTalents[talentName] ~= talentID) or
                       (heroicTalents[talentName] ~= nil and heroicTalents[talentName] ~= talentID) then
                    local currentID = specTalents[talentName] or sharedTalents[talentName] or heroicTalents[talentName]
                    warnOnce("talent_mismatch_" .. talentName,
                        "|cffff0000Talent found in Talent Spell List for |r" .. talentName .. "|cffff0000 with ID: |r" .. currentID
                        .. "|cffff0000 it should be changed to ID: |r" .. talentID .. "|cffff0000.")
                end
            end
        end
    end
end

--- Maps talent state into player.talent and adds active talents to player.spells.abilities.
-- @param player The br.player object being built
-- @param spec Spec ID
-- @return table allTalents as reported by the expansion's talent system
function spellCompiler:compileTalents(player, spec)
    local allTalents = br.api.wow.getTalentInfo(spec, player.spells.talents)
    if player.talent == nil then player.talent = {} end

    validateTalents(allTalents, spec)

    -- Map defined spell talents to talent state
    for name, spellID in pairs(player.spells.talents) do
        local entry = allTalents[spellID]
        if entry then
            player.talent[name] = entry.active
            if entry.active and not br.api.wow.IsPassiveSpell(spellID) then
                player.spells.abilities[name] = spellID
                player.spells[name] = spellID
            end
        elseif not isInitialSpec(spec) then
            warnOnce("talent_notfound_" .. name .. "_" .. tostring(spellID),
                "|cffff0000No talent found for: |r" .. name .. " (" .. tostring(spellID)
                .. ") |cffff0000in the talent spell list; please verify ID or remove.")
        end
    end

    return allTalents
end

--- Sets player.heroTree[name] for the active hero talent tree (expansions with hero trees only).
-- @param player The br.player object being built
function spellCompiler:compileHeroTree(player)
    if not br.api.hasHeroTalentTrees then return end
    if not br._G.C_ClassTalents or not br._G.C_ClassTalents.GetActiveHeroTalentSpec then return end
    if not br.lists or not br.lists.heroSpec then return end

    local playerClass = select(2, br._G.UnitClass('player'))
    local activeSpecID = br._G.C_ClassTalents.GetActiveHeroTalentSpec()
    local specs = br.lists.heroSpec[playerClass]
    if specs == nil then return end
    player.heroTree = player.heroTree or {}
    for name, specID in pairs(specs) do
        player.heroTree[name] = specID == activeSpecID
    end
end

--- Resolves a list entry to the ID BR should use: the highest known rank on expansions
-- with spell ranks, otherwise the entry unchanged.
-- @param id Spell ID or table of rank IDs
function spellCompiler:resolve(id)
    if br.api.hasSpellRanks and type(id) == "table" then
        return br.functions.spell:resolveRank(id)
    end
    return id
end

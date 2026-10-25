local _, br = ...
--- Spell Compiler
-- Turns the expansion spell lists (br.lists.spells) into br.rotation.spells, maps talent and
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
    br.game.print(message)
end

-- Spell list sources for the player's class and spec, in load order (later sources win
-- unless an earlier entry came from the spec list).
local function getSources(spec)
    -- Lazy-load the spec's spell file if not yet cached (MOP/Retail only)
    if br.client.rules.hasSubSpecs and br.lists and br.lists.loadSpecSpells then
        br.lists:loadSpecSpells(br.loader.selectedSpec)
    end
    local playerClass = select(2, br.game.UnitClass('player'))
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
local function assign(rotation, spellType, spellRef, spellID, origin)
    local existingSource = rotation.spellSource[spellType][spellRef]
    if existingSource == "spec" and origin ~= "spec" then return false end
    rotation.spells[spellType][spellRef] = spellID
    rotation.spellSource[spellType][spellRef] = origin or "shared"
    return true
end

-- Active (castable) spells are also exposed in spells.abilities and spells[spellRef].
local function isActiveType(spellType, spec)
    return spellType == 'abilities' or spellType == 'covenants'
        or ((spellType == 'traits' or spellType == 'talents' or spellType == 'talentsHeroic') and not isInitialSpec(spec))
end

-- Compile one spell list into rotation.spells
local function compileList(rotation, spellTable, origin, spec)
    for spellType, spellTypeTable in pairs(spellTable) do
        rotation.spells[spellType] = rotation.spells[spellType] or {}
        rotation.spellSource[spellType] = rotation.spellSource[spellType] or {}
        for spellRef, spellID in pairs(spellTypeTable) do
            if spellType == 'items' then
                rotation.items = rotation.items or {}
                rotation.items[spellRef] = spellID
            else
                assign(rotation, spellType, spellRef, spellID, origin)
                -- (imbues are never active: their values are enchant IDs, not spell IDs)
                if isActiveType(spellType, spec) and type(spellID) ~= 'table' and not br.game.C_Spell.IsSpellPassive(spellID) then
                    rotation.spells.abilities = rotation.spells.abilities or {}
                    rotation.spellSource["abilities"] = rotation.spellSource["abilities"] or {}
                    if assign(rotation, "abilities", spellRef, spellID, origin) then
                        rotation.spells[spellRef] = spellID
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
        local info = br.game.C_Spell.GetSpellInfo(id)
        if not info or info.spellID ~= id then
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

--- Builds rotation.spells (and adds the lists' items to rotation.items) for the given spec.
-- @param rotation br.rotation
-- @param spec Spec ID
function spellCompiler:compileSpells(rotation, spec)
    rotation.spells = rotation.spells or {}
    rotation.spellSource = rotation.spellSource or {}
    for _, source in ipairs(getSources(spec)) do
        validateList(source.list)
        compileList(rotation, source.list, source.origin, spec)
    end

    -- Ending the Race War!
    if rotation.spells.abilities["racial"] == nil then
        -- 0 means "this race has no racial for cast.racial()". The key must still exist
        -- so a profile can call cast.racial() unconditionally; createCastFunction
        -- returns false for 0 without complaint.
        local racialID = br.functions.spell:getRacial() or 0
        rotation.spells.abilities["racial"] = racialID
        rotation.spells.buffs["racial"] = racialID
        rotation.spells["racial"] = racialID
    end
end

-- Warn about active talents missing from the lists, or listed with the wrong ID.
local function validateTalents(allTalents, spec)
    if isInitialSpec(spec) or not (br.lists and br.lists.spells) then return end
    local playerClass = select(2, br.game.UnitClass('player'))
    local classLists = br.lists.spells[playerClass]
    if not (classLists and classLists["Shared"] and classLists[spec]) then return end
    local heroicTalents = classLists["Shared"]["talentsHeroic"] or {}
    local sharedTalents = classLists["Shared"]["talents"] or {}
    local specTalents = classLists[spec]["talents"] or {}

    for talentID, talentData in pairs(allTalents) do
        if talentData.active then
            local spellName = br.functions.spell:getName(talentID)
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

--- Adds the active talents to rotation.spells.abilities (talent.X is set by the talent builder).
-- @param rotation br.rotation
-- @param spec Spec ID
-- @return table allTalents as reported by the expansion's talent system
function spellCompiler:compileTalents(rotation, spec)
    local allTalents = br.client.getTalentInfo(spec, rotation.spells.talents)

    validateTalents(allTalents, spec)

    -- Map defined spell talents to talent state
    for name, spellID in pairs(rotation.spells.talents) do
        local entry = allTalents[spellID]
        if entry then
            if entry.active and not br.game.C_Spell.IsSpellPassive(spellID) then
                rotation.spells.abilities[name] = spellID
                rotation.spells[name] = spellID
            end
        elseif not isInitialSpec(spec) then
            warnOnce("talent_notfound_" .. name .. "_" .. tostring(spellID),
                "|cffff0000No talent found for: |r" .. name .. " (" .. tostring(spellID)
                .. ") |cffff0000in the talent spell list; please verify ID or remove.")
        end
    end

    return allTalents
end

--- Sets heroTree[name] for the active hero talent tree (expansions with hero trees only).
-- @param heroTree the profile API's heroTree table
function spellCompiler:compileHeroTree(heroTree)
    if not br.client.rules.hasHeroTalentTrees then return end
    if not br.game.C_ClassTalents or not br.game.C_ClassTalents.GetActiveHeroTalentSpec then return end
    if not br.lists or not br.lists.heroSpec then return end

    local playerClass = select(2, br.game.UnitClass('player'))
    local activeSpecID = br.game.C_ClassTalents.GetActiveHeroTalentSpec()
    local specs = br.lists.heroSpec[playerClass]
    if specs == nil then return end
    for name, specID in pairs(specs) do
        heroTree[name] = specID == activeSpecID
    end
end

--- Resolves a list entry to the ID BR should use: the highest known rank on expansions
-- with spell ranks, otherwise the entry unchanged.
-- @param id Spell ID or table of rank IDs
function spellCompiler:resolve(id)
    if br.client.rules.hasSpellRanks and type(id) == "table" then
        return br.functions.spell:resolveRank(id)
    end
    return id
end

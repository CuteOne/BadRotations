-- Retail WoW API Compatibility Layer
-- Handles API differences in Retail (Dragonflight/The War Within/etc.)
local _, br = ...

if not br.isRetail then return end

-- Capability flags for Retail
br.api.hasHeroTalentTrees     = true   -- hero talent trees (Dragonflight+)
br.api.hasCharmBreakTracking  = true   -- C_LossOfControl available; charm-break spells can fire while charmed
br.api.hasBFAItemChannels     = true   -- BFA trinket/essence follow-up channel lock (Azerite Beam, Cyclotronic, Azshara)
br.api.expansion              = "Retail"

local api = br.api.wow

-- Returns the effective spec id for the player (forces Initial for all classes below level 10 in Retail)
br.api.getEffectiveSpecID = function()
    local class  = select(2, br._G.UnitClass("player"))
    local level  = br._G.UnitLevel("player")
    local specID = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
    if level and level < 10
        and class and br.lists and br.lists.spec
        and br.lists.spec[class] and br.lists.spec[class].Initial
    then
        return br.lists.spec[class].Initial
    end
    return specID
end

-- UnitAura / UnitBuff / UnitDebuff wrappers
-- Retail: the C_UnitAuras record unpacked into the old multi-return. UnitBuff and UnitDebuff
-- read only helpful / only harmful auras, as the old globals did, whatever the filter.
local function unpackAura(method, unit, index, filter)
    local cua = br._G.C_UnitAuras
    if cua and cua[method] then
        local auraData = cua[method](unit, index, filter)
        if auraData and AuraUtil and AuraUtil.UnpackAuraData then
            return AuraUtil.UnpackAuraData(auraData)
        end
    end
    return nil
end

api.UnitAura = function(unit, index, filter)
    return unpackAura("GetAuraDataByIndex", unit, index, filter)
end

api.UnitBuff = function(unit, index, filter)
    return unpackAura("GetBuffDataByIndex", unit, index, filter)
end

api.UnitDebuff = function(unit, index, filter)
    return unpackAura("GetDebuffDataByIndex", unit, index, filter)
end



-- Talent System - Retail uses C_Traits API (Dragonflight talent trees)
br.api.getTalentInfo = function(spec, spellTalents)
    local talents = {}

    -- Initial profiles (spec > 1400) don't have talents
    if spec > 1400 then return talents end

    local configId = _G.C_ClassTalents and _G.C_ClassTalents.GetActiveConfigID and _G.C_ClassTalents.GetActiveConfigID()
    if not configId then return talents end

    local configInfo = _G.C_Traits and _G.C_Traits.GetConfigInfo and _G.C_Traits.GetConfigInfo(configId)
    if not configInfo then return talents end

    -- Helper to get active talents from a node
    local function getActiveTalents(node, configId)
        local activeTalents = {}
        if not node.entryIDsWithCommittedRanks then return activeTalents end

        for _, entryID in pairs(node.entryIDsWithCommittedRanks) do
            local entryInfo = _G.C_Traits.GetEntryInfo(configId, entryID)
            if entryInfo and entryInfo.definitionID then
                local definitionInfo = _G.C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                if definitionInfo and definitionInfo.spellID then
                    activeTalents[definitionInfo.spellID] = {
                        active = true,
                        rank = node.activeRank or 0
                    }
                end
            end
        end
        return activeTalents
    end

    -- Traverse all talent trees
    for _, treeId in pairs(configInfo.treeIDs) do
        local nodes = _G.C_Traits.GetTreeNodes(treeId)
        if nodes then
            for _, nodeId in pairs(nodes) do
                local node = _G.C_Traits.GetNodeInfo(configId, nodeId)
                if node then
                    local activeTalents = getActiveTalents(node, configId)

                    -- Process all entries in this node
                    for _, entryID in pairs(node.entryIDs or {}) do
                        local entryInfo = _G.C_Traits.GetEntryInfo(configId, entryID)
                        if entryInfo and entryInfo.definitionID then
                            local definitionInfo = _G.C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                            if definitionInfo and definitionInfo.spellID then
                                local talentID = definitionInfo.spellID
                                if talentID then
                                    talents[talentID] = {
                                        active = activeTalents[talentID] and true or false,
                                        rank = activeTalents[talentID] and activeTalents[talentID].rank or 0,
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return talents
end

-- Print version info on load
br.api.printCompatLoaded()

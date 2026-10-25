-- Retail WoW API Compatibility Layer
-- Handles API differences in Retail (Dragonflight/The War Within/etc.)
local _, br = ...

if not br.isRetail then return end

-- The unlocker's version of a game name, else the client's (Expansions/Layers.lua)
local base = br.api.base

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

-- Talent System - Retail uses C_Traits API (Dragonflight talent trees)
br.api.getTalentInfo = function(spec, spellTalents)
    local talents = {}

    -- Initial profiles (spec > 1400) don't have talents
    if spec > 1400 then return talents end

    local configId = base.C_ClassTalents and base.C_ClassTalents.GetActiveConfigID and base.C_ClassTalents.GetActiveConfigID()
    if not configId then return talents end

    local configInfo = base.C_Traits and base.C_Traits.GetConfigInfo and base.C_Traits.GetConfigInfo(configId)
    if not configInfo then return talents end

    -- Helper to get active talents from a node
    local function getActiveTalents(node, configId)
        local activeTalents = {}
        if not node.entryIDsWithCommittedRanks then return activeTalents end

        for _, entryID in pairs(node.entryIDsWithCommittedRanks) do
            local entryInfo = base.C_Traits.GetEntryInfo(configId, entryID)
            if entryInfo and entryInfo.definitionID then
                local definitionInfo = base.C_Traits.GetDefinitionInfo(entryInfo.definitionID)
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
        local nodes = base.C_Traits.GetTreeNodes(treeId)
        if nodes then
            for _, nodeId in pairs(nodes) do
                local node = base.C_Traits.GetNodeInfo(configId, nodeId)
                if node then
                    local activeTalents = getActiveTalents(node, configId)

                    -- Process all entries in this node
                    for _, entryID in pairs(node.entryIDs or {}) do
                        local entryInfo = base.C_Traits.GetEntryInfo(configId, entryID)
                        if entryInfo and entryInfo.definitionID then
                            local definitionInfo = base.C_Traits.GetDefinitionInfo(entryInfo.definitionID)
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

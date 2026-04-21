-- Retail WoW API Compatibility Layer
-- Handles API differences in Retail (Dragonflight/The War Within/etc.)
local _, br = ...

if not br.isRetail then return end

-- Capability flags for Retail
br.api.hasHeroTalentTrees = true
br.api.expansion          = "Retail"

local api = br.api.wow

-- GetSpellInfo wrapper
-- Retail: C_Spell.GetSpellInfo returns a table
-- Returns: name, rank, iconID, castTime, minRange, maxRange, spellID, originalIconID
api.GetSpellInfo = function(spellIdentifier)
    if not spellIdentifier then return nil end

    -- C_Spell.GetSpellInfo doesn't accept tables, only numbers or strings
    if type(spellIdentifier) == "table" then return nil end

    if C_Spell and C_Spell.GetSpellInfo then
        local spellInfo = C_Spell.GetSpellInfo(spellIdentifier)
        if spellInfo and type(spellInfo) == "table" then
            return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime,
                   spellInfo.minRange, spellInfo.maxRange, spellInfo.spellID,
                   spellInfo.originalIconID
        end
    end

    return nil
end

-- IsPassiveSpell wrapper
-- Retail: C_Spell.IsSpellPassive
api.IsPassiveSpell = function(spellID)
    if _G.C_Spell and _G.C_Spell.IsSpellPassive then
        return _G.C_Spell.IsSpellPassive(spellID)
    end
    return false
end

-- UnitAura wrapper
-- Retail: C_UnitAuras.GetAuraDataByIndex, returns table
api.UnitAura = function(unit, index, filter)
    local cua = br._G.C_UnitAuras
    if cua and cua.GetAuraDataByIndex then
        local auraData = cua.GetAuraDataByIndex(unit, index, filter)
        if auraData and AuraUtil and AuraUtil.UnpackAuraData then
            return AuraUtil.UnpackAuraData(auraData)
        end
        return nil
    end
    return nil
end

-- UnitBuff wrapper (uses UnitAura in Retail)
api.UnitBuff = function(unit, index, filter)
    return api.UnitAura(unit, index, filter)
end

-- UnitDebuff wrapper (uses UnitAura in Retail)
api.UnitDebuff = function(unit, index, filter)
    return api.UnitAura(unit, index, filter)
end



-- GetAuraDataByIndex wrapper
-- Retail: C_UnitAuras.GetAuraDataByIndex
-- br._G.C_UnitAuras is the nn.lua proxy on NN (applies ObjectUnit conversion) and falls
-- through to the real C_UnitAuras on ICC/Tinkr (which pass standard unit tokens).
api.GetAuraDataByIndex = function(unit, index, filter)
    local cua = br._G.C_UnitAuras
    if cua and cua.GetAuraDataByIndex then
        return cua.GetAuraDataByIndex(unit, index, filter)
    end
    return nil
end

-- GetDebuffDataByIndex wrapper
-- Retail: C_UnitAuras.GetDebuffDataByIndex
api.GetDebuffDataByIndex = function(unit, index, filter)
    local cua = br._G.C_UnitAuras
    if cua and cua.GetDebuffDataByIndex then
        return cua.GetDebuffDataByIndex(unit, index, filter)
    end
    return nil
end

-- GetBuffDataByIndex wrapper
-- Retail: C_UnitAuras.GetBuffDataByIndex
api.GetBuffDataByIndex = function(unit, index, filter)
    local cua = br._G.C_UnitAuras
    if cua and cua.GetBuffDataByIndex then
        return cua.GetBuffDataByIndex(unit, index, filter)
    end
    return nil
end

-- GetPlayerAuraBySpellID wrapper
-- Retail: C_UnitAuras.GetPlayerAuraBySpellID
api.GetPlayerAuraBySpellID = function(spellID)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetPlayerAuraBySpellID then
        return _G.C_UnitAuras.GetPlayerAuraBySpellID(spellID)
    end
    return nil
end

-- Tooltip Hook Compatibility
-- Retail: Use TooltipDataProcessor instead of OnTooltipSetSpell
api.HookTooltipSetSpell = function(callback)
    if _G.TooltipDataProcessor and _G.TooltipDataProcessor.AddTooltipPostCall then
        _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
            if data and data.id then
                callback(tooltip, data.id)
            end
        end)
    end
end

-- Retail: Use TooltipDataProcessor for unit tooltips
api.HookTooltipSetUnit = function(callback)
    if _G.TooltipDataProcessor and _G.TooltipDataProcessor.AddTooltipPostCall then
        _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
            callback(tooltip)
        end)
    end
end

-- Retail: Use TooltipDataProcessor for item tooltips
api.HookTooltipSetItem = function(tooltip, callback)
    if _G.TooltipDataProcessor and _G.TooltipDataProcessor.AddTooltipPostCall then
        _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltipFrame)
            if tooltipFrame == tooltip or not tooltip then
                callback(tooltipFrame)
            end
        end)
    end
end

-- UnitInPhase wrapper
-- Retail: May not exist or use UnitPhaseReason
api.UnitInPhase = function(unit)
    -- In Retail, units are generally always in phase unless there's a specific phase issue
    -- Try UnitPhaseReason first if it exists
    if _G.UnitPhaseReason then
        local phaseReason = _G.UnitPhaseReason(unit)
        -- phaseReason: nil = same phase, 0 = different phase, other values indicate issues
        return not phaseReason or phaseReason == 0
    end
    -- Fallback: assume in phase if unit exists
    if _G.UnitExists then
        return _G.UnitExists(unit)
    end
    return true
end

-- GetNumQuestLogEntries wrapper
-- Retail: Use C_QuestLog.GetNumQuestLogEntries
api.GetNumQuestLogEntries = function()
    if C_QuestLog and C_QuestLog.GetNumQuestLogEntries then
        return C_QuestLog.GetNumQuestLogEntries()
    end
    return 0
end

-- GetQuestLogTitle wrapper
-- Retail: Use C_QuestLog.GetInfo which returns a table
-- Classic: GetQuestLogTitle returns: title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, ...
api.GetQuestLogTitle = function(questLogIndex)
    if C_QuestLog and C_QuestLog.GetInfo then
        local info = C_QuestLog.GetInfo(questLogIndex)
        if info then
            -- Return in classic format: title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID
            return info.title, info.level, info.suggestedGroup, info.isHeader, info.isCollapsed,
                   info.isComplete, info.frequency, info.questID, nil, info.questID,
                   info.isOnMap, info.hasLocalPOI, info.isTask, info.isStory
        end
    end
    return nil
end

-- Print version info on load
if br.api.compat.getVersionInfo then
    local versionInfo = br.api.compat:getVersionInfo()
    print("|cffA330C9BadRotations|r |cffFFFFFFAPI:|r Retail compatibility layer loaded (Build: " .. versionInfo.build .. ")")
end

-- Talent System - Retail uses C_Traits API (Dragonflight talent trees)
api.getTalentInfo = function(spec, spellTalents)
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

-- FindBaseSpellByID: provided by shared.lua; no retail-specific override needed.

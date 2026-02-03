-- Retail WoW API Compatibility Layer
-- Handles API differences in Retail (Dragonflight/The War Within/etc.)
local _, br = ...

if not br.isRetail then return end

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

-- GetSpellLink wrapper
-- Retail: C_Spell.GetSpellLink
api.GetSpellLink = function(spellID)
    if C_Spell and C_Spell.GetSpellLink then
        return C_Spell.GetSpellLink(spellID)
    end
    return nil
end

-- GetSpellName wrapper
-- Retail: C_Spell.GetSpellName
api.GetSpellName = function(spellID)
    if C_Spell and C_Spell.GetSpellName then
        return C_Spell.GetSpellName(spellID)
    end
    return nil
end

-- GetSpellDescription wrapper
-- Retail: C_Spell.GetSpellDescription
api.GetSpellDescription = function(spellID)
    if C_Spell and C_Spell.GetSpellDescription then
        return C_Spell.GetSpellDescription(spellID)
    end
    return nil
end

-- GetSpellCooldown wrapper
-- Retail: C_Spell.GetSpellCooldown returns a table
api.GetSpellCooldown = function(spellID)
    if C_Spell and C_Spell.GetSpellCooldown then
        return C_Spell.GetSpellCooldown(spellID)
    end
    return nil
end

-- GetSpellCharges wrapper
-- Retail: C_Spell.GetSpellCharges returns a table
api.GetSpellCharges = function(spellID)
    if C_Spell and C_Spell.GetSpellCharges then
        return C_Spell.GetSpellCharges(spellID)
    end
    return nil
end

-- IsSpellInRange wrapper
-- Retail: C_Spell.IsSpellInRange
api.IsSpellInRange = function(spellID, unit)
    if C_Spell and C_Spell.IsSpellInRange then
        return C_Spell.IsSpellInRange(spellID, unit)
    end
    return nil
end

-- IsSpellUsable wrapper
-- Retail: C_Spell.IsSpellUsable returns a table
api.IsSpellUsable = function(spellID)
    if C_Spell and C_Spell.IsSpellUsable then
        return C_Spell.IsSpellUsable(spellID)
    end
    return nil
end

-- IsSpellPassive wrapper
-- Retail: C_Spell.IsSpellPassive
api.IsSpellPassive = function(spellID)
    if C_Spell and C_Spell.IsSpellPassive then
        return C_Spell.IsSpellPassive(spellID)
    end
    return nil
end

-- IsSpellHelpful wrapper
-- Retail: C_Spell.IsSpellHelpful
api.IsSpellHelpful = function(spellID)
    if C_Spell and C_Spell.IsSpellHelpful then
        return C_Spell.IsSpellHelpful(spellID)
    end
    return nil
end

-- IsSpellHarmful wrapper
-- Retail: C_Spell.IsSpellHarmful
api.IsSpellHarmful = function(spellID)
    if C_Spell and C_Spell.IsSpellHarmful then
        return C_Spell.IsSpellHarmful(spellID)
    end
    return nil
end

-- SpellHasRange wrapper
-- Retail: C_Spell.SpellHasRange
api.SpellHasRange = function(spellID)
    if C_Spell and C_Spell.SpellHasRange then
        return C_Spell.SpellHasRange(spellID)
    end
    return nil
end

-- GetSpellBookItemInfo wrapper
-- Retail: C_SpellBook.GetSpellBookItemInfo returns a table and requires numerical slot
-- Classic could accept spell names, but Retail cannot - return nil for non-numeric slots
api.GetSpellBookItemInfo = function(slot, bookType)
    -- Retail API requires a numerical slot, not a spell name
    if type(slot) ~= "number" then
        return nil
    end

    if C_SpellBook and C_SpellBook.GetSpellBookItemInfo then
        return C_SpellBook.GetSpellBookItemInfo(slot, bookType)
    end
    return nil
end

-- GetItemInfo wrapper
-- Retail: GetItemInfo still works but may return nil initially, requiring cache
api.GetItemInfo = function(itemID)
    return GetItemInfo(itemID)
end

-- GetItemCooldown wrapper
-- Retail: C_Container.GetItemCooldown
api.GetItemCooldown = function(itemID)
    if C_Container and C_Container.GetItemCooldown then
        return C_Container.GetItemCooldown(itemID)
    end
    return nil
end

-- UnitAura wrapper
-- Retail: C_UnitAuras.GetAuraDataByIndex, returns table
api.UnitAura = function(unit, index, filter)
    if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
        local auraData = C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
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

-- FindAuraByName wrapper
-- TBC: Use AuraUtil.FindAuraByName
api.FindAuraByName = function(spellName, unit, filter)
    -- Prefer the native AuraUtil if present
    if _G.AuraUtil and _G.AuraUtil.FindAuraByName then
        return _G.AuraUtil.FindAuraByName(spellName, unit, filter)
    end

    -- Fallback: try to find the aura by scanning buff/debuff lists
    if not spellName or not unit then return nil end

    local upFilter = filter and br._G.strupper(filter) or nil
    local hasPlayer = upFilter and br._G.strfind(upFilter, "PLAYER")
    local hasHelpful = upFilter and br._G.strfind(upFilter, "HELPFUL")
    local hasHarmful = upFilter and br._G.strfind(upFilter, "HARMFUL")

    local function scanForAura(spellName, unit, filterType, auraType)
        for i = 1, 40 do
            local aura = (hasHelpful or auraType=="HELPFUL") and api.GetBuffDataByIndex(unit, i, filterType)
            or api.GetDebuffDataByIndex(unit, i, filterType)
            if not aura then break end
            if aura.name and aura.name == spellName then return aura end
        end
        return nil
    end

    -- If an explicit filter is provided, prefer using it when scanning
    if upFilter then
        if hasHelpful then
            scanForAura(spellName, unit, filter, "HELPFUL")
        end

        if hasHarmful then
            scanForAura(spellName, unit, filter, "HARMFUL")
        end

        -- If only PLAYER specified (no HELPFUL/HARMFUL), scan both with PLAYER filter
        if hasPlayer and not hasHelpful and not hasHarmful then
            scanForAura(spellName, unit, "PLAYER", "HELPFUL")
            scanForAura(spellName, unit, "PLAYER", "HARMFUL")
        end
    else
        -- No filter provided: scan buffs then debuffs
        scanForAura(spellName, unit, nil, "HELPFUL")
        scanForAura(spellName, unit, nil, "HARMFUL")
    end

    -- Last resort: generic GetAuraDataByIndex scan
    for i = 1, 40 do
        local aura = api.GetAuraDataByIndex(unit, i, filter)
        if not aura then break end
        if aura.name == spellName then return aura end
    end

    return nil
end

-- GetAuraDataByIndex wrapper
-- Retail: C_UnitAuras.GetAuraDataByIndex
api.GetAuraDataByIndex = function(unit, index, filter)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetAuraDataByIndex then
        return _G.C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
    end
    return nil
end

-- GetDebuffDataByIndex wrapper
-- Retail: C_UnitAuras.GetDebuffDataByIndex
api.GetDebuffDataByIndex = function(unit, index, filter)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetDebuffDataByIndex then
        return _G.C_UnitAuras.GetDebuffDataByIndex(unit, index, filter)
    end
    return nil
end

-- GetBuffDataByIndex wrapper
-- Retail: C_UnitAuras.GetBuffDataByIndex
api.GetBuffDataByIndex = function(unit, index, filter)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetBuffDataByIndex then
        return _G.C_UnitAuras.GetBuffDataByIndex(unit, index, filter)
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
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
            if data and data.id then
                callback(tooltip, data.id)
            end
        end)
    end
end

-- Retail: Use TooltipDataProcessor for unit tooltips
api.HookTooltipSetUnit = function(callback)
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
            callback(tooltip)
        end)
    end
end

-- Retail: Use TooltipDataProcessor for item tooltips
api.HookTooltipSetItem = function(tooltip, callback)
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltipFrame)
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

    return talents
end

--FindBaseSpellByID wrapper
-- TBC: Use the global FindBaseSpellByID function if available
api.FindBaseSpellByID = function(spellID)
    if C_SpellBook and C_SpellBook.FindBaseSpellByID then
        return C_SpellBook.FindBaseSpellByID(spellID)
    end
    if _G.FindBaseSpellByID then
        return _G.FindBaseSpellByID(spellID)
    end
    return spellID
end

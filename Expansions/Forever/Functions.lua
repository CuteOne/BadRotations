-- Forever API Compatibility Layer
-- WoW Forever (interface 1.6x) runs on a Retail-based client with Retail's
-- project ID, but plays Classic content: spell ranks and one class-level spec
-- (e.g. Druid reports spec ID 1484 with no Feral/Balance/etc. split).
local _, br = ...

if not br.isForever then return end

-- Capability flags for Forever
br.api.hasSpellRanks          = true   -- Classic content: spells have rank-specific IDs
br.api.hasSubSpecs            = false  -- one class-level spec, no specialization subfolders
br.api.comboPointsOnTarget    = true   -- unverified, the safe choice: Forever's tooltips list combo points as a cost like Retail's
                                        -- (player-held); the combo point probe in System/Debugging.lua records a switch to settle it
br.api.hasCharmBreakTracking  = false  -- TODO: verify whether C_LossOfControl works here
br.api.expansion = "Forever"
-- Game object dynamic flag the server sets on objects for an active quest (0x20, "sparkle"; 0x04 is
-- "activate"). Verified with /qprobe on 2026-10-11: the Trial of the Lake Bauble Container reads 0xC024,
-- a plain object nearby 0x8000. The quest tracker uses it; game object names come back empty here.
br.api.questObjectFlag        = 0x20

local api = br.api.wow

-- GetSpellInfo: shared.lua's default is correct here. Unlike Classic/TBC,
-- C_Spell.GetSpellInfo returns minRange/maxRange in the right order
-- (verified in game: Wrath 5176 -> minRange=0, maxRange=30).

-- Spec ID: GetSpecializationInfo returns the class-level spec ID directly.
br.api.getEffectiveSpecID = function()
    local specInfo = br._G.C_SpecializationInfo
    return specInfo.GetSpecializationInfo(specInfo.GetSpecialization())
end

-- The Retail-based client drops the OnTooltipSet* scripts, so shared.lua's
-- HookScript defaults error. Use TooltipDataProcessor when present and only
-- fall back to the old scripts if the tooltip still has them.
-- onlyThisTooltip limits the modern hook to one tooltip frame (item hooks);
-- spell/unit hooks fire for every tooltip, as on Retail.
local function hookTooltip(dataType, scriptName, tooltip, callback, onlyThisTooltip)
    if br._G.TooltipDataProcessor and br._G.TooltipDataProcessor.AddTooltipPostCall then
        br._G.TooltipDataProcessor.AddTooltipPostCall(dataType, function(tooltipFrame, data)
            if not onlyThisTooltip or not tooltip or tooltipFrame == tooltip then
                callback(tooltipFrame, data)
            end
        end)
    elseif tooltip and tooltip.HasScript and tooltip:HasScript(scriptName) then
        tooltip:HookScript(scriptName, function(self) callback(self) end)
    end
end

api.HookTooltipSetSpell = function(callback)
    hookTooltip(Enum.TooltipDataType.Spell, "OnTooltipSetSpell", GameTooltip, function(tooltip, data)
        local id = data and data.id
        if not id and tooltip.GetSpell then id = select(2, tooltip:GetSpell()) end
        if id then callback(tooltip, id) end
    end)
end

api.HookTooltipSetUnit = function(callback)
    hookTooltip(Enum.TooltipDataType.Unit, "OnTooltipSetUnit", GameTooltip, function(tooltip)
        callback(tooltip)
    end)
end

api.HookTooltipSetItem = function(tooltip, callback)
    hookTooltip(Enum.TooltipDataType.Item, "OnTooltipSetItem", tooltip, function(tooltipFrame)
        callback(tooltipFrame)
    end, true)
end

-- Phasing: Retail's UnitPhaseReason when present, else the Classic global.
api.UnitInPhase = function(unit)
    if _G.UnitPhaseReason then
        local phaseReason = _G.UnitPhaseReason(unit)
        return not phaseReason or phaseReason == 0
    end
    if _G.UnitInPhase then return _G.UnitInPhase(unit) end
    if _G.UnitExists then return _G.UnitExists(unit) end
    return true
end

-- Quest log: Forever's quest-log API isn't confirmed to match Retail or
-- Classic, so prefer C_QuestLog and fall back to the Classic globals.
api.GetNumQuestLogEntries = function()
    if _G.C_QuestLog and _G.C_QuestLog.GetNumQuestLogEntries then
        return _G.C_QuestLog.GetNumQuestLogEntries()
    end
    if _G.GetNumQuestLogEntries then return _G.GetNumQuestLogEntries() end
    return 0
end

api.GetQuestLogTitle = function(questLogIndex)
    if _G.C_QuestLog and _G.C_QuestLog.GetInfo then
        local info = _G.C_QuestLog.GetInfo(questLogIndex)
        if info then
            -- Classic return order: title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID
            return info.title, info.level, info.suggestedGroup, info.isHeader, info.isCollapsed,
                   info.isComplete, info.frequency, info.questID, nil, info.questID,
                   info.isOnMap, info.hasLocalPOI, info.isTask, info.isStory
        end
        return nil
    end
    if _G.GetQuestLogTitle then return _G.GetQuestLogTitle(questLogIndex) end
    return nil
end

-- Items: the Retail-based client moved these globals into C_Item, but BR calls
-- them by their legacy names. Map each legacy name to its C_Item method, using
-- the global if it still exists. (UseItemByName is handled by the unlocker.)
local itemFallbacks = {
    IsEquippedItem = false,
    IsEquippableItem = false,
    IsUsableItem   = false,
    GetItemSpell   = nil,
    GetItemInfo    = nil,
    GetItemCount   = 0,
    GetItemStats   = nil,
}
for _, name in ipairs({ "IsEquippedItem", "IsEquippableItem", "IsUsableItem", "GetItemSpell", "GetItemInfo", "GetItemCount", "GetItemStats" }) do
    api[name] = function(...)
        if _G[name] then return _G[name](...) end
        if _G.C_Item and _G.C_Item[name] then return _G.C_Item[name](...) end
        return itemFallbacks[name]
    end
end

-- IsCurrentSpell: the Retail-based client has no global, only C_Spell.IsCurrentSpell.
-- Without this the cast pipeline can't see an on-next-swing ability (Maul) sitting
-- in the swing queue, so it re-presses it every few ticks.
api.IsCurrentSpell = function(spellIdentifier)
    if _G.IsCurrentSpell then return _G.IsCurrentSpell(spellIdentifier) end
    if _G.C_Spell and _G.C_Spell.IsCurrentSpell then
        return _G.C_Spell.IsCurrentSpell(spellIdentifier)
    end
    return false
end

-- Combat log: COMBAT_LOG_EVENT_UNFILTERED fires, but the global reader is
-- missing. Use whichever reader the client exposes; return nothing otherwise.
api.CombatLogGetCurrentEventInfo = function()
    if _G.CombatLogGetCurrentEventInfo then return _G.CombatLogGetCurrentEventInfo() end
    if _G.C_CombatLog and _G.C_CombatLog.GetCurrentEventInfo then
        return _G.C_CombatLog.GetCurrentEventInfo()
    end
end

-- Talent System - no talent spell API is used yet; rotations gate talents
-- through cast.able.* like Classic.
api.getTalentInfo = function(spec, spellTalents)
    return {}
end

-- Print version info on load
br.api.printCompatLoaded()

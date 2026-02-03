-- Mists of Pandaria Classic API Compatibility Layer
-- Handles API differences in MoP Classic
local _, br = ...

if not br.isMOP then return end

local api = br.api.wow

-- IsPassiveSpell wrapper
-- MoP: C_Spell.IsSpellPassive or fallback to global IsPassiveSpell
api.IsPassiveSpell = function(spellID)
    if _G.C_Spell and _G.C_Spell.IsSpellPassive then
        return _G.C_Spell.IsSpellPassive(spellID)
    end
    if _G.IsPassiveSpell then
        return _G.IsPassiveSpell(spellID)
    end
    return false
end

-- GetSpellInfo wrapper
-- MoP Classic: C_Spell.GetSpellInfo returns a table (like Retail)
-- Returns: name, rank, iconID, castTime, minRange, maxRange, spellID, originalIconID
api.GetSpellInfo = function(spellIdentifier)
    if not spellIdentifier then return nil end

    -- GetSpellInfo doesn't accept tables, only numbers or strings
    if type(spellIdentifier) == "table" then return nil end

    -- Try C_Spell first (MoP Classic has this like Retail)
    if _G.C_Spell and _G.C_Spell.GetSpellInfo then
        local spellInfo = _G.C_Spell.GetSpellInfo(spellIdentifier)
        if spellInfo and type(spellInfo) == "table" then
            return spellInfo.name,
                   nil,
                   spellInfo.iconID,
                   spellInfo.castTime,
                   spellInfo.minRange,
                   spellInfo.maxRange,
                   spellInfo.spellID,
                   spellInfo.originalIconID
        end
    end

    -- Fallback to global GetSpellInfo if C_Spell not available
    if _G.GetSpellInfo then
        return _G.GetSpellInfo(spellIdentifier)
    end

    return nil
end

-- GetAuraDataByIndex wrapper (for C_UnitAuras compatibility)
-- MoP Classic: Convert UnitAura to auraData table format
api.GetAuraDataByIndex = function(unit, index, filter)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetAuraDataByIndex then
        return _G.C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
    end

    -- Fallback: use UnitAura and convert to auraData format
    local name, icon, count, dispelType, duration, expirationTime, source, isStealable,
          nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer,
          nameplateShowAll, timeMod = _G.UnitAura(unit, index, filter)

    if not name then return nil end

    return {
        applications = count,
        auraInstanceID = 0,
        canApplyAura = canApplyAura,
        charges = 0,
        dispelName = dispelType,
        duration = duration,
        expirationTime = expirationTime,
        icon = icon,
        isBossAura = isBossDebuff,
        isFromPlayerOrPlayerPet = castByPlayer,
        isHarmful = false,
        isHelpful = true,
        isNameplateOnly = nameplateShowPersonal,
        isRaid = false,
        isStealable = isStealable,
        name = name,
        nameplateShowAll = nameplateShowAll,
        nameplateShowPersonal = nameplateShowPersonal,
        points = {},
        sourceUnit = source,
        spellId = spellId,
        timeMod = timeMod
    }
end

-- GetDebuffDataByIndex wrapper
-- MoP Classic: Convert UnitDebuff to debuffData format
api.GetDebuffDataByIndex = function(unit, index, filter)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetDebuffDataByIndex then
        return _G.C_UnitAuras.GetDebuffDataByIndex(unit, index, filter)
    end

    local name, icon, count, dispelType, duration, expirationTime, source, isStealable,
          nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer,
          nameplateShowAll, timeMod = _G.UnitDebuff(unit, index, filter)

    if not name then return nil end

    return {
        applications = count,
        auraInstanceID = 0,
        canApplyAura = canApplyAura,
        charges = 0,
        dispelName = dispelType,
        duration = duration,
        expirationTime = expirationTime,
        icon = icon,
        isBossAura = isBossDebuff,
        isFromPlayerOrPlayerPet = castByPlayer,
        isHarmful = true,
        isHelpful = false,
        isNameplateOnly = nameplateShowPersonal,
        isRaid = false,
        isStealable = isStealable,
        name = name,
        nameplateShowAll = nameplateShowAll,
        nameplateShowPersonal = nameplateShowPersonal,
        points = {},
        sourceUnit = source,
        spellId = spellId,
        timeMod = timeMod
    }
end

-- GetBuffDataByIndex wrapper
-- MoP Classic: Convert UnitBuff to buffData format
api.GetBuffDataByIndex = function(unit, index, filter)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetBuffDataByIndex then
        return _G.C_UnitAuras.GetBuffDataByIndex(unit, index, filter)
    end

    local name, icon, count, dispelType, duration, expirationTime, source, isStealable,
          nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer,
          nameplateShowAll, timeMod = _G.UnitBuff(unit, index, filter)

    if not name then return nil end

    return {
        applications = count,
        auraInstanceID = 0,
        canApplyAura = canApplyAura,
        charges = 0,
        dispelName = dispelType,
        duration = duration,
        expirationTime = expirationTime,
        icon = icon,
        isBossAura = isBossDebuff,
        isFromPlayerOrPlayerPet = castByPlayer,
        isHarmful = false,
        isHelpful = true,
        isNameplateOnly = nameplateShowPersonal,
        isRaid = false,
        isStealable = isStealable,
        name = name,
        nameplateShowAll = nameplateShowAll,
        nameplateShowPersonal = nameplateShowPersonal,
        points = {},
        sourceUnit = source,
        spellId = spellId,
        timeMod = timeMod
    }
end

-- GetPlayerAuraBySpellID wrapper
-- MoP Classic: Iterate through player buffs/debuffs to find by spell ID
api.GetPlayerAuraBySpellID = function(spellID)
    if _G.C_UnitAuras and _G.C_UnitAuras.GetPlayerAuraBySpellID then
        return _G.C_UnitAuras.GetPlayerAuraBySpellID(spellID)
    end

    -- Check buffs first
    for i = 1, 40 do
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable,
              nameplateShowPersonal, buffSpellId, canApplyAura, isBossDebuff, castByPlayer,
              nameplateShowAll, timeMod = _G.UnitBuff("player", i)

        if not name then break end
        if buffSpellId == spellID then
            return {
                applications = count,
                auraInstanceID = 0,
                canApplyAura = canApplyAura,
                charges = 0,
                dispelName = dispelType,
                duration = duration,
                expirationTime = expirationTime,
                icon = icon,
                isBossAura = isBossDebuff,
                isFromPlayerOrPlayerPet = castByPlayer,
                isHarmful = false,
                isHelpful = true,
                name = name,
                spellId = buffSpellId,
                timeMod = timeMod
            }
        end
    end

    -- Check debuffs
    for i = 1, 40 do
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable,
              nameplateShowPersonal, debuffSpellId, canApplyAura, isBossDebuff, castByPlayer,
              nameplateShowAll, timeMod = _G.UnitDebuff("player", i)

        if not name then break end
        if debuffSpellId == spellID then
            return {
                applications = count,
                auraInstanceID = 0,
                canApplyAura = canApplyAura,
                charges = 0,
                dispelName = dispelType,
                duration = duration,
                expirationTime = expirationTime,
                icon = icon,
                isBossAura = isBossDebuff,
                isFromPlayerOrPlayerPet = castByPlayer,
                isHarmful = true,
                isHelpful = false,
                name = name,
                spellId = debuffSpellId,
                timeMod = timeMod
            }
        end
    end

    return nil
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

-- Tooltip Hook Compatibility
-- MoP Classic: Use OnTooltipSetSpell script hook
api.HookTooltipSetSpell = function(callback)
    if GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetSpell", function(self)
            local _, id = self:GetSpell()
            if id then
                callback(self, id)
            end
        end)
    end
end

-- MoP Classic: Use OnTooltipSetUnit script hook
api.HookTooltipSetUnit = function(callback)
    if GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetUnit", function(self)
            callback(self)
        end)
    end
end

-- MoP Classic: Use OnTooltipSetItem script hook
api.HookTooltipSetItem = function(tooltip, callback)
    if tooltip and tooltip.HookScript then
        tooltip:HookScript("OnTooltipSetItem", function(self)
            callback(self)
        end)
    end
end

-- UnitInPhase wrapper
-- MoP Classic: Use the global UnitInPhase function if available
api.UnitInPhase = function(unit)
    if _G.UnitInPhase then
        return _G.UnitInPhase(unit)
    end
    -- Fallback: assume in phase if unit exists
    if _G.UnitExists then
        return _G.UnitExists(unit)
    end
    return true
end

-- GetNumQuestLogEntries wrapper
-- MoP Classic: Use the global GetNumQuestLogEntries function
api.GetNumQuestLogEntries = function()
    if _G.GetNumQuestLogEntries then
        return _G.GetNumQuestLogEntries()
    end
    return 0
end

-- GetQuestLogTitle wrapper
-- MoP Classic: Use the global GetQuestLogTitle function
api.GetQuestLogTitle = function(questLogIndex)
    if _G.GetQuestLogTitle then
        return _G.GetQuestLogTitle(questLogIndex)
    end
    return nil
end

-- Talent System - MoP/Classic uses tier/column system
api.getTalentInfo = function(spec, spellTalents)
    local talents = {}

    -- Initial profiles (spec > 1400) don't have talents
    if spec > 1400 then return talents end

    local activeSpecGroup = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetActiveSpecGroup and _G.C_SpecializationInfo.GetActiveSpecGroup()
    if not activeSpecGroup then return talents end

    -- MoP/Classic talents: 7 tiers x 3 columns
    for tier = 1, 7 do
        for column = 1, 3 do
            local info = _G.C_SpecializationInfo and _G.C_SpecializationInfo.GetTalentInfo and
                         _G.C_SpecializationInfo.GetTalentInfo({ tier = tier, column = column, specializationIndex = activeSpecGroup })
            if info and info.spellID then
                talents[info.spellID] = {
                    active = info.selected and true or false,
                    rank = 0, -- Classic talents don't expose rank
                    tier = tier,
                    column = column,
                }
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

-- Print version info on load
if br.api.compat.getVersionInfo then
    local versionInfo = br.api.compat:getVersionInfo()
    print("|cffA330C9BadRotations|r |cffFFFFFFAPI:|r MoP Classic compatibility layer loaded (Build: " .. versionInfo.build .. ")")
end

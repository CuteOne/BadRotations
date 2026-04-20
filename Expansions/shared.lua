-- Shared API Compatibility Helpers
-- Installs common polyfills that apply to all Classic-era clients.
-- These are defaults; expansion files that need different behaviour
-- (e.g. Retail's tooltip hooks use TooltipDataProcessor) override them afterwards.
-- Load order in .toc: wowapi.lua → shared.lua → Retail/Functions.lua / MOP/Functions.lua / TBC/Functions.lua / Classic/Functions.lua
local _, br = ...

local api = br.api.wow

-- IsPassiveSpell: C_Spell.IsSpellPassive with _G.IsPassiveSpell fallback.
-- Retail overrides this (no _G fallback needed on modern clients).
api.IsPassiveSpell = function(spellID)
    if _G.C_Spell and _G.C_Spell.IsSpellPassive then
        return _G.C_Spell.IsSpellPassive(spellID)
    end
    if _G.IsPassiveSpell then
        return _G.IsPassiveSpell(spellID)
    end
    return false
end

-- GetSpellInfo: C_Spell.GetSpellInfo → _G.GetSpellInfo fallback.
-- Returns: name, rank, iconID, castTime, minRange, maxRange, spellID, originalIconID
-- NOTE: TBC and Classic both have minRange/maxRange swapped in the table — those
--       expansion files override this function to fix the field order.
api.GetSpellInfo = function(spellIdentifier)
    if not spellIdentifier then return nil end
    if type(spellIdentifier) == "table" then return nil end
    if _G.C_Spell and _G.C_Spell.GetSpellInfo then
        local spellInfo = _G.C_Spell.GetSpellInfo(spellIdentifier)
        if spellInfo and type(spellInfo) == "table" then
            return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime,
                   spellInfo.minRange, spellInfo.maxRange, spellInfo.spellID,
                   spellInfo.originalIconID
        end
    end
    if _G.GetSpellInfo then
        return _G.GetSpellInfo(spellIdentifier)
    end
    return nil
end

-- Tooltip hooks: classic OnScript pattern.
-- Retail overrides these with TooltipDataProcessor.AddTooltipPostCall.
api.HookTooltipSetSpell = function(callback)
    if GameTooltip and GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetSpell", function(self)
            local _, id = self:GetSpell()
            if id then callback(self, id) end
        end)
    end
end

api.HookTooltipSetUnit = function(callback)
    if GameTooltip and GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetUnit", function(self)
            callback(self)
        end)
    end
end

api.HookTooltipSetItem = function(tooltip, callback)
    if tooltip and tooltip.HookScript then
        tooltip:HookScript("OnTooltipSetItem", function(self)
            callback(self)
        end)
    end
end

-- UnitInPhase: _G.UnitInPhase fallback.
-- Retail overrides this with UnitPhaseReason.
api.UnitInPhase = function(unit)
    if _G.UnitInPhase then return _G.UnitInPhase(unit) end
    if _G.UnitExists then return _G.UnitExists(unit) end
    return true
end

-- GetNumQuestLogEntries: _G fallback.
-- Retail overrides this with C_QuestLog.GetNumQuestLogEntries.
api.GetNumQuestLogEntries = function()
    if _G.GetNumQuestLogEntries then return _G.GetNumQuestLogEntries() end
    return 0
end

-- GetQuestLogTitle: _G fallback.
-- Retail overrides this with C_QuestLog.GetInfo.
api.GetQuestLogTitle = function(questLogIndex)
    if _G.GetQuestLogTitle then return _G.GetQuestLogTitle(questLogIndex) end
    return nil
end

-- FindBaseSpellByID: C_SpellBook → _G.FindBaseSpellByID fallback.
api.FindBaseSpellByID = function(spellID)
    if _G.C_SpellBook and _G.C_SpellBook.FindBaseSpellByID then
        return _G.C_SpellBook.FindBaseSpellByID(spellID)
    end
    if _G.FindBaseSpellByID then
        return _G.FindBaseSpellByID(spellID)
    end
    return spellID
end

-- Aura polyfills.
-- Build a normalised aura record from the pre-Shadowlands multi-return UnitAura/Buff/Debuff
-- globals. Used as a fallback when the native C_UnitAuras methods are absent.
-- Retail's expansion file overwrites GetAuraDataByIndex/GetDebuffDataByIndex/GetBuffDataByIndex/
-- GetPlayerAuraBySpellID with direct C_UnitAuras calls (no fallback needed there).
do
    local function buildAuraRecord(rawGlobal, unit, index, filter, isHarmful)
        local fn = _G[rawGlobal]
        if not fn then return nil end
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable,
              nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer,
              nameplateShowAll, timeMod = fn(unit, index, filter)
        if not name then return nil end
        return {
            applications            = count,
            auraInstanceID          = 0,
            canApplyAura            = canApplyAura,
            charges                 = 0,
            dispelName              = dispelType,
            duration                = duration,
            expirationTime          = expirationTime,
            icon                    = icon,
            isBossAura              = isBossDebuff,
            isFromPlayerOrPlayerPet = castByPlayer,
            isHarmful               = isHarmful,
            isHelpful               = not isHarmful,
            isNameplateOnly         = nameplateShowPersonal,
            isRaid                  = false,
            isStealable             = isStealable,
            name                    = name,
            nameplateShowAll        = nameplateShowAll,
            nameplateShowPersonal   = nameplateShowPersonal,
            points                  = {},
            sourceUnit              = source,
            spellId                 = spellId,
            timeMod                 = timeMod,
        }
    end

    api.GetAuraDataByIndex = function(unit, index, filter)
        if _G.C_UnitAuras and _G.C_UnitAuras.GetAuraDataByIndex then
            return _G.C_UnitAuras.GetAuraDataByIndex(unit, index, filter)
        end
        return buildAuraRecord("UnitAura", unit, index, filter, false)
    end

    api.GetDebuffDataByIndex = function(unit, index, filter)
        if _G.C_UnitAuras and _G.C_UnitAuras.GetDebuffDataByIndex then
            return _G.C_UnitAuras.GetDebuffDataByIndex(unit, index, filter)
        end
        return buildAuraRecord("UnitDebuff", unit, index, filter, true)
    end

    api.GetBuffDataByIndex = function(unit, index, filter)
        if _G.C_UnitAuras and _G.C_UnitAuras.GetBuffDataByIndex then
            return _G.C_UnitAuras.GetBuffDataByIndex(unit, index, filter)
        end
        return buildAuraRecord("UnitBuff", unit, index, filter, false)
    end

    api.GetPlayerAuraBySpellID = function(spellID)
        -- Support Classic/TBC rank tables: resolve to the highest known rank.
        if type(spellID) == "table" then
            for i = #spellID, 1, -1 do
                if br.functions and br.functions.spell and br.functions.spell:isKnown(spellID[i]) then
                    spellID = spellID[i]
                    break
                end
            end
        end
        if _G.C_UnitAuras and _G.C_UnitAuras.GetPlayerAuraBySpellID then
            return _G.C_UnitAuras.GetPlayerAuraBySpellID(spellID)
        end
        for i = 1, 40 do
            local rec = buildAuraRecord("UnitBuff", "player", i, nil, false)
            if not rec then break end
            if rec.spellId == spellID then return rec end
        end
        for i = 1, 40 do
            local rec = buildAuraRecord("UnitDebuff", "player", i, nil, true)
            if not rec then break end
            if rec.spellId == spellID then return rec end
        end
        return nil
    end

    api.FindAuraByName = function(spellName, unit, filter)
        if not spellName or not unit then return nil end
        -- Skip _G.AuraUtil.FindAuraByName: it internally calls GetAuraDataBySpellName which
        -- rejects object pointers in Midnight. api.GetXxxDataByIndex already handles unit
        -- conversion correctly per expansion (including NN ObjectUnit wrapping on Retail).
        local upFilter = filter and string.upper(filter) or nil
        local hasPlayer  = upFilter and string.find(upFilter, "PLAYER",  1, true)
        local hasHelpful = upFilter and string.find(upFilter, "HELPFUL", 1, true)
        local hasHarmful = upFilter and string.find(upFilter, "HARMFUL", 1, true)
        local function scan(name, u, ft, isHarm)
            for i = 1, 40 do
                local aura = isHarm and api.GetDebuffDataByIndex(u, i, ft)
                                     or api.GetBuffDataByIndex(u, i, ft)
                if not aura then break end
                if aura.name == name then return aura end
            end
        end
        if upFilter then
            if hasHelpful then
                local r = scan(spellName, unit, filter, false)
                if r then return r end
            end
            if hasHarmful then
                local r = scan(spellName, unit, filter, true)
                if r then return r end
            end
            if hasPlayer and not hasHelpful and not hasHarmful then
                local r = scan(spellName, unit, "PLAYER", false) or scan(spellName, unit, "PLAYER", true)
                if r then return r end
            end
        else
            local r = scan(spellName, unit, nil, false) or scan(spellName, unit, nil, true)
            if r then return r end
        end
        for i = 1, 40 do
            local aura = api.GetAuraDataByIndex(unit, i, filter)
            if not aura then break end
            if aura.name == spellName then return aura end
        end
        return nil
    end
end

-- C_Spell namespace shims.
-- Polyfill methods missing on older clients. Guards ensure a shim is only
-- installed when the native method is absent; safe to run on all clients.
do
    local cs = br.api.wow.C_Spell

    -- GetSpellLevelLearned: Retail-only. Return 1 so CD.lua level-gate checks always pass.
    if not (_G.C_Spell and _G.C_Spell.GetSpellLevelLearned) then
        cs.GetSpellLevelLearned = function() return 1 end
    end

    -- GetSpellCooldown: wrap multi-return into a table matching the Retail format.
    if not (_G.C_Spell and _G.C_Spell.GetSpellCooldown) then
        cs.GetSpellCooldown = function(spellID)
            if not _G.GetSpellCooldown then return nil end
            local startTime, duration, isEnabled, modRate = _G.GetSpellCooldown(spellID)
            if startTime == nil then return nil end
            return { startTime = startTime, duration = duration, isEnabled = isEnabled, modRate = modRate or 1 }
        end
    end

    -- GetSpellCharges: wrap multi-return into a table matching Retail C_Spell.GetSpellCharges.
    if not (_G.C_Spell and _G.C_Spell.GetSpellCharges) then
        cs.GetSpellCharges = function(spellID)
            if not _G.GetSpellCharges then return nil end
            local currentCharges, maxCharges, cooldownStartTime, cooldownDuration, chargeModRate = _G.GetSpellCharges(spellID)
            if currentCharges == nil then return nil end
            return {
                currentCharges    = currentCharges,
                maxCharges        = maxCharges,
                cooldownStartTime = cooldownStartTime,
                cooldownDuration  = cooldownDuration,
                chargeModRate     = chargeModRate or 1,
            }
        end
    end

    -- IsSpellUsable: same return signature as Retail (isUsable, notEnoughMana).
    if not (_G.C_Spell and _G.C_Spell.IsSpellUsable) then
        cs.IsSpellUsable = function(spellID)
            if _G.IsUsableSpell then return _G.IsUsableSpell(spellID) end
            return true, false
        end
    end

    -- IsSpellInRange: bridge the namespace gap; identical signature.
    if not (_G.C_Spell and _G.C_Spell.IsSpellInRange) then
        cs.IsSpellInRange = function(spellName, unit)
            if _G.IsSpellInRange then return _G.IsSpellInRange(spellName, unit) end
            return nil
        end
    end

    -- IsAutoRepeatSpell: Retail uses C_Spell.IsAutoRepeatSpell; Classic/TBC expose
    -- it as a top-level global.  Polyfill so gateAutoRepeat never calls a nil function.
    if not (_G.C_Spell and _G.C_Spell.IsAutoRepeatSpell) then
        cs.IsAutoRepeatSpell = function(spellName)
            return _G.IsAutoRepeatSpell and _G.IsAutoRepeatSpell(spellName) or false
        end
    end
end

-- GCDSpells: class-specific fallback spells used to detect the GCD on Classic-era clients.
-- Spell 61304 (the canonical Retail GCD probe) does not exist before Wrath.
-- Retail has its own GCD detection and does not use this table.
local GCDSpells = {
    DRUID   = { NONE = 5176, CAT = 5221 },  -- Wrath / Shred
    HUNTER  = 1978,   -- Serpent Sting
    MAGE    = 133,    -- Fireball
    PALADIN = 635,    -- Holy Light
    PRIEST  = 2050,   -- Holy Smite
    ROGUE   = 1752,   -- Sinister Strike
    SHAMAN  = 403,    -- Lightning Bolt
    WARLOCK = 686,    -- Shadow Bolt
    WARRIOR = 772,    -- Rend
}

api.GetGCDSpellID = function()
    local _, class = _G.UnitClass("player")
    if not class then return 5176 end
    local gcdSpell = GCDSpells[class]
    if class == "DRUID" and type(gcdSpell) == "table" then
        local form = _G.GetShapeshiftForm and _G.GetShapeshiftForm()
        return form == 1 and gcdSpell.CAT or gcdSpell.NONE
    end
    return gcdSpell or 5176
end

-- Shared API Compatibility Helpers
-- The default br.api.wow functions for every client. Each one uses whichever API the client has
-- (the old global where it's still there, so older clients keep their own behaviour), so a client
-- only needs its own Expansions/<name>/Functions.lua for what differs in kind (talent systems,
-- spec rules, client bugs).
-- Load order in .toc: wowapi.lua → shared.lua → Retail / MOP / TBC Functions.lua
local _, br = ...

-- The unlocker's version of a game name, else the client's (Expansions/wowapi.lua)
local base = br.api.base
local api = br.api.wow

-- IsPassiveSpell: C_Spell.IsSpellPassive, else the old global.
api.IsPassiveSpell = function(spellID)
    if base.C_Spell and base.C_Spell.IsSpellPassive then
        return base.C_Spell.IsSpellPassive(spellID)
    end
    if base.IsPassiveSpell then
        return base.IsPassiveSpell(spellID)
    end
    return false
end

-- GetSpellInfo: C_Spell.GetSpellInfo → base.GetSpellInfo fallback.
-- Returns: name, rank, iconID, castTime, minRange, maxRange, spellID, originalIconID
-- br.api.spellRangeSwapped: the Classic and TBC clients fill minRange and maxRange the other way round.
api.GetSpellInfo = function(spellIdentifier)
    if not spellIdentifier then return nil end
    if type(spellIdentifier) == "table" then return nil end
    if base.C_Spell and base.C_Spell.GetSpellInfo then
        local spellInfo = base.C_Spell.GetSpellInfo(spellIdentifier)
        if spellInfo and type(spellInfo) == "table" then
            local minRange, maxRange = spellInfo.minRange, spellInfo.maxRange
            if br.api.spellRangeSwapped then minRange, maxRange = maxRange, minRange end
            return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime,
                   minRange, maxRange, spellInfo.spellID, spellInfo.originalIconID
        end
    end
    if base.GetSpellInfo then
        return base.GetSpellInfo(spellIdentifier)
    end
    return nil
end

-- UnitInPhase: the old global, else UnitPhaseReason (nil = same phase), else "in phase if it exists".
api.UnitInPhase = function(unit)
    if base.UnitInPhase then return base.UnitInPhase(unit) end
    if base.UnitPhaseReason then
        local phaseReason = base.UnitPhaseReason(unit)
        return not phaseReason or phaseReason == 0
    end
    if base.UnitExists then return base.UnitExists(unit) end
    return true
end

-- Quest log: the old globals, else C_QuestLog.
api.GetNumQuestLogEntries = function()
    if base.GetNumQuestLogEntries then return base.GetNumQuestLogEntries() end
    if base.C_QuestLog and base.C_QuestLog.GetNumQuestLogEntries then
        return base.C_QuestLog.GetNumQuestLogEntries()
    end
    return 0
end

-- GetQuestLogTitle in the old return order: title, level, suggestedGroup, isHeader, isCollapsed,
-- isComplete, frequency, questID, ...
api.GetQuestLogTitle = function(questLogIndex)
    if base.GetQuestLogTitle then return base.GetQuestLogTitle(questLogIndex) end
    if base.C_QuestLog and base.C_QuestLog.GetInfo then
        local info = base.C_QuestLog.GetInfo(questLogIndex)
        if info then
            return info.title, info.level, info.suggestedGroup, info.isHeader, info.isCollapsed,
                   info.isComplete, info.frequency, info.questID, nil, info.questID,
                   info.isOnMap, info.hasLocalPOI, info.isTask, info.isStory
        end
    end
    return nil
end

-- FindBaseSpellByID: C_SpellBook → base.FindBaseSpellByID fallback.
api.FindBaseSpellByID = function(spellID)
    if base.C_SpellBook and base.C_SpellBook.FindBaseSpellByID then
        return base.C_SpellBook.FindBaseSpellByID(spellID)
    end
    if base.FindBaseSpellByID then
        return base.FindBaseSpellByID(spellID)
    end
    return spellID
end

-- FindSpellOverrideByID: the spell a talent or form puts in this spell's place (e.g. Condemn for
-- Execute). Clients without spell overrides get the ID back unchanged.
api.FindSpellOverrideByID = function(spellID)
    if base.FindSpellOverrideByID then
        return base.FindSpellOverrideByID(spellID)
    end
    if base.C_Spell and base.C_Spell.GetOverrideSpell then
        return base.C_Spell.GetOverrideSpell(spellID)
    end
    return spellID
end

-- Aura readers: C_UnitAuras, else a record built from the pre-Shadowlands multi-return
-- UnitAura/Buff/Debuff globals. The index readers go through br._G.C_UnitAuras, so an unlocker's
-- own version (NN's proxy converts its unit objects) is used.
do
    local function buildAuraRecord(rawGlobal, unit, index, filter, isHarmful)
        local fn = base[rawGlobal]
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
        local cua = br._G.C_UnitAuras
        if cua and cua.GetAuraDataByIndex then
            return cua.GetAuraDataByIndex(unit, index, filter)
        end
        return buildAuraRecord("UnitAura", unit, index, filter, false)
    end

    api.GetDebuffDataByIndex = function(unit, index, filter)
        local cua = br._G.C_UnitAuras
        if cua and cua.GetDebuffDataByIndex then
            return cua.GetDebuffDataByIndex(unit, index, filter)
        end
        return buildAuraRecord("UnitDebuff", unit, index, filter, true)
    end

    api.GetBuffDataByIndex = function(unit, index, filter)
        local cua = br._G.C_UnitAuras
        if cua and cua.GetBuffDataByIndex then
            return cua.GetBuffDataByIndex(unit, index, filter)
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
        if base.C_UnitAuras and base.C_UnitAuras.GetPlayerAuraBySpellID then
            return base.C_UnitAuras.GetPlayerAuraBySpellID(spellID)
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
end

-- IsCurrentSpell: the old global, else C_Spell.IsCurrentSpell (newer clients only have that one).
-- Without it the cast pipeline can't see an on-next-swing ability (Maul) sitting in the swing
-- queue, so it re-presses it every few ticks.
api.IsCurrentSpell = function(spellIdentifier)
    if base.IsCurrentSpell then return base.IsCurrentSpell(spellIdentifier) end
    if base.C_Spell and base.C_Spell.IsCurrentSpell then
        return base.C_Spell.IsCurrentSpell(spellIdentifier)
    end
    return false
end

-- CombatLogGetCurrentEventInfo: whichever combat log reader the client has; nothing otherwise.
api.CombatLogGetCurrentEventInfo = function()
    if base.CombatLogGetCurrentEventInfo then return base.CombatLogGetCurrentEventInfo() end
    if base.C_CombatLog and base.C_CombatLog.GetCurrentEventInfo then
        return base.C_CombatLog.GetCurrentEventInfo()
    end
end

-- Items by their old global names: newer clients only have them in C_Item. The global when it
-- exists, else the C_Item method, else the "no item" answer.
do
    local noItem = { IsEquippedItem = false, IsEquippableItem = false, IsUsableItem = false, GetItemCount = 0 }
    for _, name in ipairs({ "IsEquippedItem", "IsEquippableItem", "IsUsableItem", "GetItemSpell", "GetItemInfo", "GetItemCount", "GetItemStats" }) do
        api[name] = function(...)
            if base[name] then return base[name](...) end
            if base.C_Item and base.C_Item[name] then return base.C_Item[name](...) end
            return noItem[name]
        end
    end
end

-- C_Spell namespace shims.
-- Polyfill methods missing on older clients. Guards ensure a shim is only
-- installed when the native method is absent; safe to run on all clients.
do
    local cs = br.api.wow.C_Spell

    -- GetSpellLevelLearned: Retail-only. Return 1 so CD.lua level-gate checks always pass.
    if not (base.C_Spell and base.C_Spell.GetSpellLevelLearned) then
        cs.GetSpellLevelLearned = function() return 1 end
    end

    -- GetSpellCooldown: wrap multi-return into a table matching the Retail format.
    if not (base.C_Spell and base.C_Spell.GetSpellCooldown) then
        cs.GetSpellCooldown = function(spellID)
            if not base.GetSpellCooldown then return nil end
            local startTime, duration, isEnabled, modRate = base.GetSpellCooldown(spellID)
            if startTime == nil then return nil end
            return { startTime = startTime, duration = duration, isEnabled = isEnabled, modRate = modRate or 1 }
        end
    end

    -- GetSpellCharges: wrap multi-return into a table matching Retail C_Spell.GetSpellCharges.
    if not (base.C_Spell and base.C_Spell.GetSpellCharges) then
        cs.GetSpellCharges = function(spellID)
            if not base.GetSpellCharges then return nil end
            local currentCharges, maxCharges, cooldownStartTime, cooldownDuration, chargeModRate = base.GetSpellCharges(spellID)
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
    if not (base.C_Spell and base.C_Spell.IsSpellUsable) then
        cs.IsSpellUsable = function(spellID)
            if base.IsUsableSpell then return base.IsUsableSpell(spellID) end
            return true, false
        end
    end

    -- IsSpellInRange: bridge the namespace gap; identical signature.
    if not (base.C_Spell and base.C_Spell.IsSpellInRange) then
        cs.IsSpellInRange = function(spellName, unit)
            if base.IsSpellInRange then return base.IsSpellInRange(spellName, unit) end
            return nil
        end
    end

    -- IsAutoRepeatSpell: Retail uses C_Spell.IsAutoRepeatSpell; Classic/TBC expose
    -- it as a top-level global.  Polyfill so gateAutoRepeat never calls a nil function.
    if not (base.C_Spell and base.C_Spell.IsAutoRepeatSpell) then
        cs.IsAutoRepeatSpell = function(spellName)
            return base.IsAutoRepeatSpell and base.IsAutoRepeatSpell(spellName) or false
        end
    end
end

-- C_AddOns namespace shims: the old globals where the client lacks the namespace methods.
-- IsAddOnLoaded returns a boolean, as the namespace does (the old global returns 1/nil).
-- The proxies (wowapi.lua) look up the client's namespace table as it was at load, so a namespace an
-- unlocker created later wouldn't be seen; none does.
do
    local ca = br.api.wow.C_AddOns

    if not (base.C_AddOns and base.C_AddOns.IsAddOnLoaded) then
        ca.IsAddOnLoaded = function(name)
            if base.IsAddOnLoaded then
                local loaded, finished = base.IsAddOnLoaded(name)
                return loaded ~= nil and loaded ~= false, finished
            end
            -- Neither C_AddOns.IsAddOnLoaded nor the legacy global exists: treat as not loaded.
            return false
        end
    end

    if not (base.C_AddOns and base.C_AddOns.GetAddOnMetadata) then
        ca.GetAddOnMetadata = function(name, field)
            if base.GetAddOnMetadata then return base.GetAddOnMetadata(name, field) end
            return nil
        end
    end
end

-- C_SpecializationInfo namespace shims: the old globals (MoP on), else values callers handle on
-- clients without specs (original Classic, TBC):
--   GetSpecialization -> nil, so "== N" spec checks fail (1 would fire spec-1 branches for every class)
--   GetActiveSpecGroup -> 1 (no dual spec)
--   GetSpecializationInfo -> nil; the spec name then becomes "Initial" (System/Bootstrap.lua)
do
    local cs = br.api.wow.C_SpecializationInfo

    if not (base.C_SpecializationInfo and base.C_SpecializationInfo.GetSpecialization) then
        cs.GetSpecialization = function()
            if base.GetSpecialization then return base.GetSpecialization() end
            -- Neither C_SpecializationInfo.GetSpecialization nor the legacy global exists
            -- (original Classic / TBC have no spec system): return nil so == N checks fail.
            return nil
        end
    end

    if not (base.C_SpecializationInfo and base.C_SpecializationInfo.GetActiveSpecGroup) then
        cs.GetActiveSpecGroup = function()
            if base.GetActiveSpecGroup then return base.GetActiveSpecGroup() end
            -- Pre-Wrath: no dual-spec system. Defensive placeholder; the sole live
            -- caller (misc:getTalent) is DK-only and unreachable on pre-Wrath clients.
            return 1
        end
    end

    if not (base.C_SpecializationInfo and base.C_SpecializationInfo.GetSpecializationInfo) then
        cs.GetSpecializationInfo = function(specIndex)
            if base.GetSpecializationInfo then return base.GetSpecializationInfo(specIndex) end
            -- No spec system on the client: return nil so callers' select(2, …)
            -- produces nil, which downstream code already normalises to "Initial".
            return nil
        end
    end
end

-- C_Container namespace shims: the old globals under the namespace names. GetContainerItemInfo
-- turns the old multi-return into the namespace's table (nil for an empty slot).
do
    local cc = br.api.wow.C_Container

    if not (base.C_Container and base.C_Container.GetContainerNumSlots) then
        cc.GetContainerNumSlots = function(bagID)
            if base.GetContainerNumSlots then return base.GetContainerNumSlots(bagID) end
            -- Neither C_Container.GetContainerNumSlots nor the legacy global exists.
            return 0
        end
    end

    if not (base.C_Container and base.C_Container.GetContainerNumFreeSlots) then
        cc.GetContainerNumFreeSlots = function(bagID)
            if base.GetContainerNumFreeSlots then return base.GetContainerNumFreeSlots(bagID) end
            return 0
        end
    end

    if not (base.C_Container and base.C_Container.GetContainerItemID) then
        cc.GetContainerItemID = function(bagID, slot)
            if base.GetContainerItemID then return base.GetContainerItemID(bagID, slot) end
            return nil
        end
    end

    if not (base.C_Container and base.C_Container.GetContainerItemLink) then
        cc.GetContainerItemLink = function(bagID, slot)
            if base.GetContainerItemLink then return base.GetContainerItemLink(bagID, slot) end
            return nil
        end
    end

    if not (base.C_Container and base.C_Container.GetContainerItemInfo) then
        cc.GetContainerItemInfo = function(bagID, slot)
            if not base.GetContainerItemInfo then return nil end
            local texture, itemCount, locked, quality, readable, lootable,
                  itemLink, isFiltered, noValue, itemID, isBound = base.GetContainerItemInfo(bagID, slot)
            if texture == nil then return nil end  -- empty slot: no item
            return {
                iconFileID  = texture,
                stackCount  = itemCount,
                isLocked    = locked,
                quality     = quality,
                isReadable  = readable,
                hasLoot     = lootable,
                hyperlink   = itemLink,
                isFiltered  = isFiltered,
                hasNoValue  = noValue,
                itemID      = itemID,
                isBound     = isBound,
            }
        end
    end

    if not (base.C_Container and base.C_Container.GetItemCooldown) then
        cc.GetItemCooldown = function(itemID)
            -- The legacy global is deprecated on Retail; this branch only runs on
            -- Classic-era clients where it isn't deprecated and is the only option.
            ---@diagnostic disable-next-line: deprecated
            if base.GetItemCooldown then return base.GetItemCooldown(itemID) end
            -- No legacy global either: report "no cooldown" so == 0 checks pass safely.
            return 0, 0, 0
        end
    end

    if not (base.C_Container and base.C_Container.PickupContainerItem) then
        cc.PickupContainerItem = function(bagID, slot)
            -- The legacy global is deprecated on Retail; this branch only runs on
            -- Classic-era clients where it isn't deprecated and is the only option.
            ---@diagnostic disable-next-line: deprecated
            if base.PickupContainerItem then return base.PickupContainerItem(bagID, slot) end
        end
    end
end

-- C_Item namespace shims: the old globals (GetItemIcon for GetItemIconByID) on clients without them.
-- The old globals are deprecated on Retail, where these branches never run.
do
    local ci = br.api.wow.C_Item

    if not (base.C_Item and base.C_Item.GetItemIconByID) then
        ci.GetItemIconByID = function(itemID)
            ---@diagnostic disable-next-line: deprecated
            if base.GetItemIcon then return base.GetItemIcon(itemID) end
            -- Neither C_Item.GetItemIconByID nor the legacy global exists.
            return nil
        end
    end

    if not (base.C_Item and base.C_Item.GetItemSpell) then
        ci.GetItemSpell = function(itemID)
            ---@diagnostic disable-next-line: deprecated
            if base.GetItemSpell then return base.GetItemSpell(itemID) end
            return nil
        end
    end

    if not (base.C_Item and base.C_Item.GetItemCount) then
        ci.GetItemCount = function(itemID, includeBank, includeUses, includeReagentBank)
            ---@diagnostic disable-next-line: deprecated
            if base.GetItemCount then return base.GetItemCount(itemID, includeBank, includeUses, includeReagentBank) end
            return 0
        end
    end

    if not (base.C_Item and base.C_Item.GetItemInfo) then
        ci.GetItemInfo = function(itemID)
            ---@diagnostic disable-next-line: deprecated
            if base.GetItemInfo then return base.GetItemInfo(itemID) end
            return nil
        end
    end
end

-- C_Map namespace shim: GetBestMapForUnit gives nil without C_Map (before Legion). The old map APIs
-- numbered maps differently, so a translation would give a plausible but wrong map; every caller
-- handles nil (the maps BR checks for are Retail zones).
do
    local cm = br.api.wow.C_Map

    if not (base.C_Map and base.C_Map.GetBestMapForUnit) then
        cm.GetBestMapForUnit = function(_)
            -- No legacy fallback: pre-Legion mapID space differs from uiMapID
            -- and delegating would return a plausible-looking wrong-number-space
            -- answer rather than the honest "no value" that callers handle.
            return nil
        end
    end
end

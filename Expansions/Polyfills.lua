-- Polyfills: the modern game API on clients that lack it
-- BR is written against the modern API (C_Spell, C_UnitAuras, C_QuestLog, C_Item, ...). Each polyfill
-- here is installed only where the client lacks that function, has the signature Blizzard documents,
-- and builds the answer from the client's older API; it reads br.client.base, so it wraps an unlocker's
-- version too. Fixes for one client's bugs in a modern function (TBC's cooldowns) live in that
-- client's Expansions/<name>/Functions.lua.
-- Load order in .toc: Layers.lua → Flavours.lua → Polyfills.lua → Retail / MOP / TBC Functions.lua
local _, br = ...

-- The unlocker's version of a game name, else the client's (Expansions/Layers.lua)
local base = br.client.base
local api = br.client.polyfills

-- UnitPhaseReason: why the unit is in another phase, nil when it's in the player's (Enum.PhaseReason;
-- 0 = Phasing). On a client without it, from the old UnitInPhase.
if not base.UnitPhaseReason then
    api.UnitPhaseReason = function(unit)
        if base.UnitInPhase and not base.UnitInPhase(unit) then return 0 end
        return nil
    end
end

-- GetPowerRegenForPowerType: base and casting regeneration of one power type. On a client without
-- it, from the old GetPowerRegen for the power shown; other power types read as not regenerating.
if not base.GetPowerRegenForPowerType then
    api.GetPowerRegenForPowerType = function(powerType)
        if base.UnitPowerType("player") == powerType then return base.GetPowerRegen() end
        return 0, 0
    end
end

-- C_UnitAuras namespace shims: the aura readers on clients without them, built from the
-- pre-Shadowlands multi-return UnitAura/UnitBuff/UnitDebuff (the AuraData table's fields).
do
    local cua = br.client.polyfills.C_UnitAuras

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

    local native = base.C_UnitAuras or {}
    if not native.GetAuraDataByIndex then
        cua.GetAuraDataByIndex = function(unit, index, filter) return buildAuraRecord("UnitAura", unit, index, filter, false) end
    end
    if not native.GetBuffDataByIndex then
        cua.GetBuffDataByIndex = function(unit, index, filter) return buildAuraRecord("UnitBuff", unit, index, filter, false) end
    end
    if not native.GetDebuffDataByIndex then
        cua.GetDebuffDataByIndex = function(unit, index, filter) return buildAuraRecord("UnitDebuff", unit, index, filter, true) end
    end
    if not native.GetPlayerAuraBySpellID then
        cua.GetPlayerAuraBySpellID = function(spellID)
            for _, kind in ipairs({ "UnitBuff", "UnitDebuff" }) do
                for i = 1, 40 do
                    local record = buildAuraRecord(kind, "player", i, nil, kind == "UnitDebuff")
                    if not record then break end
                    if record.spellId == spellID then return record end
                end
            end
            return nil
        end
    end
end

-- CombatLogGetCurrentEventInfo: on a client without the global, C_CombatLog's reader; nothing otherwise.
-- Looked up when called: on clients that give addons no reader (Forever), the unlocker installs one later.
if not base.CombatLogGetCurrentEventInfo then
    api.CombatLogGetCurrentEventInfo = function()
        if base.CombatLogGetCurrentEventInfo then return base.CombatLogGetCurrentEventInfo() end
        if base.C_CombatLog and base.C_CombatLog.GetCurrentEventInfo then
            return base.C_CombatLog.GetCurrentEventInfo()
        end
    end
end

-- C_Spell namespace shims.
-- Polyfill methods missing on older clients. Guards ensure a shim is only
-- installed when the native method is absent; safe to run on all clients.
do
    local cs = br.client.polyfills.C_Spell

    -- GetSpellInfo: the SpellInfo table (name, iconID, originalIconID, castTime, minRange, maxRange,
    -- spellID). Built from the old multi-return where the client lacks it; where the client gives
    -- minRange and maxRange the other way round (br.client.rules.spellRangeSwapped: Classic, TBC) they are
    -- swapped back. Elsewhere the client's own is used as it is.
    if not (base.C_Spell and base.C_Spell.GetSpellInfo) then
        cs.GetSpellInfo = function(spell)
            if not base.GetSpellInfo then return nil end
            local name, _, icon, castTime, minRange, maxRange, spellID, originalIcon = base.GetSpellInfo(spell)
            if name == nil then return nil end
            return { name = name, iconID = icon, originalIconID = originalIcon or icon, castTime = castTime,
                minRange = minRange, maxRange = maxRange, spellID = spellID }
        end
    elseif br.client.rules.spellRangeSwapped then
        cs.GetSpellInfo = function(spell)
            local info = base.C_Spell.GetSpellInfo(spell)
            if info == nil then return nil end
            return { name = info.name, iconID = info.iconID, originalIconID = info.originalIconID,
                castTime = info.castTime, minRange = info.maxRange, maxRange = info.minRange, spellID = info.spellID }
        end
    end

    -- IsCurrentSpell: the old global where the client lacks it. Without it the cast pipeline can't see
    -- an on-next-swing ability (Maul) sitting in the swing queue, so it re-presses it every few ticks.
    if not (base.C_Spell and base.C_Spell.IsCurrentSpell) then
        cs.IsCurrentSpell = function(spell)
            return base.IsCurrentSpell ~= nil and base.IsCurrentSpell(spell) and true or false
        end
    end

    -- IsSpellPassive: the old global IsPassiveSpell where the client lacks it.
    if not (base.C_Spell and base.C_Spell.IsSpellPassive) then
        cs.IsSpellPassive = function(spell)
            return base.IsPassiveSpell ~= nil and base.IsPassiveSpell(spell) or false
        end
    end

    -- GetBaseSpell / GetOverrideSpell: the spell a talent or form replaces / puts in a spell's place
    -- (e.g. Condemn for Execute). From the old globals where the client lacks them; a client without
    -- spell overrides gets the ID back unchanged.
    if not (base.C_Spell and base.C_Spell.GetBaseSpell) then
        cs.GetBaseSpell = function(spellID)
            local book = base.C_SpellBook
            if book and book.FindBaseSpellByID then return book.FindBaseSpellByID(spellID) end
            if base.FindBaseSpellByID then return base.FindBaseSpellByID(spellID) end
            return spellID
        end
    end
    if not (base.C_Spell and base.C_Spell.GetOverrideSpell) then
        cs.GetOverrideSpell = function(spellID)
            if base.FindSpellOverrideByID then return base.FindSpellOverrideByID(spellID) end
            return spellID
        end
    end

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

-- C_QuestLog namespace shims: the quest log on clients without it, from the old globals.
-- GetInfo gives the QuestInfo fields BR reads (the old GetQuestLogTitle order: title, level,
-- suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID); IsComplete finds the quest's
-- entry in the log.
do
    local cq = br.client.polyfills.C_QuestLog
    local native = base.C_QuestLog or {}

    if not native.GetNumQuestLogEntries then
        cq.GetNumQuestLogEntries = function()
            if base.GetNumQuestLogEntries then return base.GetNumQuestLogEntries() end
            return 0, 0
        end
    end

    if not native.GetInfo then
        cq.GetInfo = function(questLogIndex)
            if not base.GetQuestLogTitle then return nil end
            local title, level, suggestedGroup, isHeader, isCollapsed, _, frequency, questID = base.GetQuestLogTitle(questLogIndex)
            if title == nil then return nil end
            return { title = title, questLogIndex = questLogIndex, questID = questID, level = level,
                suggestedGroup = suggestedGroup, isHeader = isHeader and true or false,
                isCollapsed = isCollapsed and true or false, frequency = frequency }
        end
    end

    if not native.IsComplete then
        cq.IsComplete = function(questID)
            if not (base.GetQuestLogTitle and base.GetNumQuestLogEntries) then return false end
            for i = 1, (base.GetNumQuestLogEntries()) do
                local _, _, _, _, _, isComplete, _, id = base.GetQuestLogTitle(i)
                if id == questID then return isComplete == 1 or isComplete == true end
            end
            return false
        end
    end
end

-- C_AddOns namespace shims: the old globals where the client lacks the namespace methods.
-- IsAddOnLoaded returns a boolean, as the namespace does (the old global returns 1/nil).
-- The proxies (Flavours.lua) look up the client's namespace table as it was at load, so a namespace an
-- unlocker created later wouldn't be seen; none does.
do
    local ca = br.client.polyfills.C_AddOns

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
    local cs = br.client.polyfills.C_SpecializationInfo

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
    local cc = br.client.polyfills.C_Container

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
    local ci = br.client.polyfills.C_Item

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

    -- Pure namespace moves: the old global under the C_Item name ("no item" when neither exists)
    for name, none in pairs({ IsEquippedItem = false, IsEquippableItem = false, IsUsableItem = false, GetItemStats = nil }) do
        if not (base.C_Item and base.C_Item[name]) then
            ci[name] = function(...)
                if base[name] then return base[name](...) end
                return none
            end
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
    local cm = br.client.polyfills.C_Map

    if not (base.C_Map and base.C_Map.GetBestMapForUnit) then
        cm.GetBestMapForUnit = function(_)
            -- No legacy fallback: pre-Legion mapID space differs from uiMapID
            -- and delegating would return a plausible-looking wrong-number-space
            -- answer rather than the honest "no value" that callers handle.
            return nil
        end
    end
end

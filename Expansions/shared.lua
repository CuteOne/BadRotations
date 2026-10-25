-- Shared API Compatibility Helpers
-- Installs common polyfills that apply to all Classic-era clients.
-- These are defaults; expansion files that need different behaviour
-- (e.g. Retail's tooltip hooks use TooltipDataProcessor) override them afterwards.
-- Load order in .toc: wowapi.lua → shared.lua → Retail/Functions.lua / MOP/Functions.lua / TBC/Functions.lua / Classic/Functions.lua
local _, br = ...

local api = br.api.wow

-- C_LossOfControl (loss-of-control / charm-break tracking) was introduced in WoD 6.0.
-- Not available on Classic, TBC, or MOP Classic clients.
-- Set true only in Retail/Functions.lua.
br.api.hasCharmBreakTracking = false

-- BFA trinket/essence channels (Focused Azerite Beam, Cyclotronic Blast, Azshara's Font
-- of Power) require a follow-up channel lock after casting. Retail only.
br.api.hasBFAItemChannels = false
-- The server's fleeing unit flag (UNIT_FLAG_FLEEING, the same bit in every version). unit:isFleeing
-- reads it where the unlocker provides UnitFlags (daemonic and tinkr per their docs; nn unknown; the
-- BRMelee.log client line lists its API names). Without it the flee emote is used. Confirmed in play on Forever 2026-10-12: fleeing mobs read 0x00880800
-- against 0x00080800.
br.api.fleeingUnitFlag = 0x00800000

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

-- FindSpellOverrideByID: the spell a talent or form puts in this spell's place (e.g. Condemn for
-- Execute). Clients without spell overrides get the ID back unchanged.
api.FindSpellOverrideByID = function(spellID)
    if _G.FindSpellOverrideByID then
        return _G.FindSpellOverrideByID(spellID)
    end
    if _G.C_Spell and _G.C_Spell.GetOverrideSpell then
        return _G.C_Spell.GetOverrideSpell(spellID)
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

    -- One pass over a unit's buffs or debuffs for an aura with this name
    local function scanByName(name, u, ft, isHarm)
        for i = 1, 40 do
            local aura = isHarm and api.GetDebuffDataByIndex(u, i, ft)
                                 or api.GetBuffDataByIndex(u, i, ft)
            if not aura then return nil end
            if aura.name == name then return aura end
        end
    end

    api.FindAuraByName = function(spellName, unit, filter)
        if not spellName or not unit then return nil end
        -- Skip _G.AuraUtil.FindAuraByName: it internally calls GetAuraDataBySpellName which
        -- rejects object pointers in Midnight. api.GetXxxDataByIndex already handles unit
        -- conversion correctly per expansion (including NN ObjectUnit wrapping on Retail).
        if not filter then
            return scanByName(spellName, unit, nil, false) or scanByName(spellName, unit, nil, true)
        end
        local upFilter = string.upper(filter)
        local hasHelpful = string.find(upFilter, "HELPFUL", 1, true)
        local hasHarmful = string.find(upFilter, "HARMFUL", 1, true)
        if hasHelpful or hasHarmful then
            return (hasHelpful and scanByName(spellName, unit, filter, false))
                or (hasHarmful and scanByName(spellName, unit, filter, true)) or nil
        end
        if string.find(upFilter, "PLAYER", 1, true) then
            return scanByName(spellName, unit, "PLAYER", false) or scanByName(spellName, unit, "PLAYER", true)
        end
        -- A filter without HELPFUL / HARMFUL / PLAYER: only the generic aura list covers it
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

-- C_AddOns namespace shims.
-- C_AddOns is the Retail 10.x+ namespace. Legacy globals IsAddOnLoaded /
-- GetAddOnMetadata exist on every Classic-era client; on Retail 11.x+ the
-- globals were removed but the native namespace covers us. Guards ensure the
-- shim is only installed when the native method is absent.
--
-- IsAddOnLoaded normalises the loaded flag to a boolean so callers see the
-- Retail contract (true/false) regardless of client — the legacy global
-- returns 1/nil.
--
-- Proxy snapshot: br.api.wow.C_AddOns's __index captures _G.C_AddOns by
-- reference at wowapi.lua load time, so later mutations to that table are
-- live. The only stale case is _G.C_AddOns being nil at load and being
-- created afterward (e.g. by an unlocker) — a grep of Unlockers/ rules this
-- out as of writing.
do
    local ca = br.api.wow.C_AddOns

    if not (_G.C_AddOns and _G.C_AddOns.IsAddOnLoaded) then
        ca.IsAddOnLoaded = function(name)
            if _G.IsAddOnLoaded then
                local loaded, finished = _G.IsAddOnLoaded(name)
                return loaded ~= nil and loaded ~= false, finished
            end
            -- Neither C_AddOns.IsAddOnLoaded nor the legacy global exists: treat as not loaded.
            return false
        end
    end

    if not (_G.C_AddOns and _G.C_AddOns.GetAddOnMetadata) then
        ca.GetAddOnMetadata = function(name, field)
            if _G.GetAddOnMetadata then return _G.GetAddOnMetadata(name, field) end
            return nil
        end
    end
end

-- C_SpecializationInfo namespace shims.
-- C_SpecializationInfo is the Retail namespace; on Classic-era clients the
-- equivalents are top-level globals (GetSpecialization, GetActiveSpecGroup,
-- GetSpecializationInfo) that exist from MoP onward. Pre-MoP clients (original
-- Classic, TBC Classic) have no spec system at all — the shims fall through to
-- safe defaults that callers already tolerate.
--
-- Fallback semantics, verified against every non-Expansions/ callsite:
--   GetSpecialization   -> nil. All callers test the result with `== N`; nil
--                          ≠ N short-circuits Retail-spec-keyed branches,
--                          which is the correct behaviour on no-spec clients.
--                          Returning 1 would wrongly fire spec-1 branches
--                          (e.g. Holy Paladin code) for every class.
--   GetActiveSpecGroup  -> 1. Only live caller is misc:getTalent (Necrotic
--                          Plague handler, DK-only). DKs don't exist pre-Wrath
--                          so this fallback is never actually reached; on
--                          Wrath+ the legacy _G.GetActiveSpecGroup exists and
--                          the polyfill defers to it. The 1 is a defensive
--                          placeholder for any future caller, not a load-
--                          bearing value today.
--   GetSpecializationInfo -> nil. Callers `select(2, …)` for the spec name,
--                            which BadRotations.lua:124 already normalises
--                            (empty/nil → "Initial").
--
-- Proxy snapshot caveat is identical to C_AddOns above; no unlocker writes
-- _G.C_SpecializationInfo, so the "nil-at-load then created later" stale case
-- is ruled out by the same grep.
do
    local cs = br.api.wow.C_SpecializationInfo

    if not (_G.C_SpecializationInfo and _G.C_SpecializationInfo.GetSpecialization) then
        cs.GetSpecialization = function()
            if _G.GetSpecialization then return _G.GetSpecialization() end
            -- Neither C_SpecializationInfo.GetSpecialization nor the legacy global exists
            -- (original Classic / TBC have no spec system): return nil so == N checks fail.
            return nil
        end
    end

    if not (_G.C_SpecializationInfo and _G.C_SpecializationInfo.GetActiveSpecGroup) then
        cs.GetActiveSpecGroup = function()
            if _G.GetActiveSpecGroup then return _G.GetActiveSpecGroup() end
            -- Pre-Wrath: no dual-spec system. Defensive placeholder; the sole live
            -- caller (misc:getTalent) is DK-only and unreachable on pre-Wrath clients.
            return 1
        end
    end

    if not (_G.C_SpecializationInfo and _G.C_SpecializationInfo.GetSpecializationInfo) then
        cs.GetSpecializationInfo = function(specIndex)
            if _G.GetSpecializationInfo then return _G.GetSpecializationInfo(specIndex) end
            -- No spec system on the client: return nil so callers' select(2, …)
            -- produces nil, which downstream code already normalises to "Initial".
            return nil
        end
    end
end

-- C_Container namespace shims.
-- C_Container is the Retail 10.x+ namespace. Most methods are pure namespace
-- moves with identical signatures; the only shape change is
-- GetContainerItemInfo, which returns a table on Retail and a flat multi-
-- return on every Classic-era client. The shim translates the multi-return
-- into the documented modern table-field names so callsite code reads the
-- same on every client.
--
-- Proxy already exists at wowapi.lua:51; this block only adds method shims.
-- Proxy snapshot caveat is identical to C_AddOns / C_SpecializationInfo
-- above; grep of Unlockers/ shows nothing rawsets _G.C_Container, so the
-- nil-at-load case is ruled out.
do
    local cc = br.api.wow.C_Container

    if not (_G.C_Container and _G.C_Container.GetContainerNumSlots) then
        cc.GetContainerNumSlots = function(bagID)
            if _G.GetContainerNumSlots then return _G.GetContainerNumSlots(bagID) end
            -- Neither C_Container.GetContainerNumSlots nor the legacy global exists.
            return 0
        end
    end

    if not (_G.C_Container and _G.C_Container.GetContainerNumFreeSlots) then
        cc.GetContainerNumFreeSlots = function(bagID)
            if _G.GetContainerNumFreeSlots then return _G.GetContainerNumFreeSlots(bagID) end
            return 0
        end
    end

    if not (_G.C_Container and _G.C_Container.GetContainerItemID) then
        cc.GetContainerItemID = function(bagID, slot)
            if _G.GetContainerItemID then return _G.GetContainerItemID(bagID, slot) end
            return nil
        end
    end

    if not (_G.C_Container and _G.C_Container.GetContainerItemLink) then
        cc.GetContainerItemLink = function(bagID, slot)
            if _G.GetContainerItemLink then return _G.GetContainerItemLink(bagID, slot) end
            return nil
        end
    end

    -- GetContainerItemInfo translates the legacy 11-value multi-return into the
    -- modern table shape. Field names match the documented Retail return so
    -- callers (LootEngineFunctions.lua reads `.stackCount`; Module.lua reads
    -- `.itemID`) work identically on every client. Empty slots return nil to
    -- match the modern contract; verified callsites either nil-check (Module.lua:93)
    -- or are gated by an upstream GetContainerItemLink check (LootEngineFunctions.lua:11, 35).
    if not (_G.C_Container and _G.C_Container.GetContainerItemInfo) then
        cc.GetContainerItemInfo = function(bagID, slot)
            if not _G.GetContainerItemInfo then return nil end
            local texture, itemCount, locked, quality, readable, lootable,
                  itemLink, isFiltered, noValue, itemID, isBound = _G.GetContainerItemInfo(bagID, slot)
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

    if not (_G.C_Container and _G.C_Container.GetItemCooldown) then
        cc.GetItemCooldown = function(itemID)
            -- The legacy global is deprecated on Retail; this branch only runs on
            -- Classic-era clients where it isn't deprecated and is the only option.
            ---@diagnostic disable-next-line: deprecated
            if _G.GetItemCooldown then return _G.GetItemCooldown(itemID) end
            -- No legacy global either: report "no cooldown" so == 0 checks pass safely.
            return 0, 0, 0
        end
    end

    if not (_G.C_Container and _G.C_Container.PickupContainerItem) then
        cc.PickupContainerItem = function(bagID, slot)
            -- The legacy global is deprecated on Retail; this branch only runs on
            -- Classic-era clients where it isn't deprecated and is the only option.
            ---@diagnostic disable-next-line: deprecated
            if _G.PickupContainerItem then return _G.PickupContainerItem(bagID, slot) end
        end
    end
end

-- C_Item namespace shims.
-- C_Item is the Retail 10.x+ namespace. All four methods used in the codebase
-- are pure namespace moves with identical signatures to their legacy globals,
-- except GetItemIconByID which is named GetItemIcon as a legacy global. Guards
-- ensure the shim is only installed when the native method is absent.
--
-- All four legacy globals (GetItemIcon, GetItemSpell, GetItemCount, GetItemInfo)
-- are formally deprecated on Retail in favour of the C_Item namespace; the
-- `---@diagnostic disable-next-line: deprecated` directives below silence the
-- language server warning, since these branches only run on Classic-era clients
-- where the globals aren't deprecated and are the only available form.
--
-- Proxy snapshot: br.api.wow.C_Item's __index captures _G.C_Item by reference
-- at wowapi.lua load time. The only stale case is _G.C_Item being nil at load
-- and being created afterward by an unlocker — daemonic.lua:249 reads
-- _G.C_Item["UseItemByName"] but doesn't rawset _G.C_Item, so the stale case
-- is ruled out by grep of Unlockers/.
do
    local ci = br.api.wow.C_Item

    if not (_G.C_Item and _G.C_Item.GetItemIconByID) then
        ci.GetItemIconByID = function(itemID)
            ---@diagnostic disable-next-line: deprecated
            if _G.GetItemIcon then return _G.GetItemIcon(itemID) end
            -- Neither C_Item.GetItemIconByID nor the legacy global exists.
            return nil
        end
    end

    if not (_G.C_Item and _G.C_Item.GetItemSpell) then
        ci.GetItemSpell = function(itemID)
            ---@diagnostic disable-next-line: deprecated
            if _G.GetItemSpell then return _G.GetItemSpell(itemID) end
            return nil
        end
    end

    if not (_G.C_Item and _G.C_Item.GetItemCount) then
        ci.GetItemCount = function(itemID, includeBank, includeUses, includeReagentBank)
            ---@diagnostic disable-next-line: deprecated
            if _G.GetItemCount then return _G.GetItemCount(itemID, includeBank, includeUses, includeReagentBank) end
            return 0
        end
    end

    if not (_G.C_Item and _G.C_Item.GetItemInfo) then
        ci.GetItemInfo = function(itemID)
            ---@diagnostic disable-next-line: deprecated
            if _G.GetItemInfo then return _G.GetItemInfo(itemID) end
            return nil
        end
    end
end

-- C_Map namespace shim.
-- C_Map is the Legion 7.0+ namespace using the uiMapID number space.
-- Categorically different from the other polyfills in this file: there is no
-- serviceable legacy fallback. Pre-Legion APIs (GetCurrentMapAreaID, GetMapInfo,
-- SetMapToCurrentZone) used a different mapID number space that doesn't align
-- with uiMapIDs, and they were removed in 7.0 anyway. Every zone referenced
-- in System/Lists/Maps.lua is Retail-only content (Draenor, Legion zones,
-- Shadowlands zones, Proving Grounds) — none can match a pre-Legion mapID
-- via any plausible translation because the zones don't exist on those clients.
--
-- Shape: "polyfill admits it can't translate; caller-tolerance verified."
-- Only GetBestMapForUnit is polyfilled; other C_Map methods aren't covered
-- here and would crash if called on a Classic-era client (the proxy provides
-- namespace-level access but not method-level safety). All 9 GetBestMapForUnit
-- callsites verified during L11 survey to tolerate a nil return — 7 tContains
-- predicates return false (correct: player isn't in a Retail zone on a
-- Classic-era client); 1 == 480 check returns false (correct: Proving Grounds
-- doesn't exist or has different ID); 1 if(mapId) guard skips the world-quest
-- scan block (correct: C_TaskQuest doesn't exist on those clients either).
do
    local cm = br.api.wow.C_Map

    if not (_G.C_Map and _G.C_Map.GetBestMapForUnit) then
        cm.GetBestMapForUnit = function(_)
            -- No legacy fallback: pre-Legion mapID space differs from uiMapID
            -- and delegating would return a plausible-looking wrong-number-space
            -- answer rather than the honest "no value" that callers handle.
            return nil
        end
    end
end

-- The spell whose cooldown is the global cooldown. Clients that have the GCD spell (61304, from Wrath of
-- the Lich King on) use it; older ones use a spell every member of the class knows from level 1 and
-- that shares the GCD in every form (a Druid's Wrath works in Cat and Bear Form too).
local GCD_SPELL = 61304
local GCDSpells = {
    DRUID   = 5176,   -- Wrath
    HUNTER  = 1978,   -- Serpent Sting
    MAGE    = 133,    -- Fireball
    PALADIN = 635,    -- Holy Light
    PRIEST  = 2050,   -- Holy Smite
    ROGUE   = 1752,   -- Sinister Strike
    SHAMAN  = 403,    -- Lightning Bolt
    WARLOCK = 686,    -- Shadow Bolt
    WARRIOR = 772,    -- Rend
}
local hasGCDSpell = nil -- whether this client has GCD_SPELL, checked once

api.GetGCDSpellID = function()
    if hasGCDSpell == nil then
        hasGCDSpell = (_G.C_Spell and _G.C_Spell.GetSpellInfo and _G.C_Spell.GetSpellInfo(GCD_SPELL) ~= nil)
            or (_G.GetSpellInfo and _G.GetSpellInfo(GCD_SPELL) ~= nil) or false
    end
    if hasGCDSpell then return GCD_SPELL end
    local _, class = _G.UnitClass("player")
    return class and GCDSpells[class] or GCDSpells.DRUID
end

-- The standard compatibility-layer banner. Called at the end of each expansion's Functions.lua
-- once br.api.expansion has been set. BR's chat (System/Logging.lua) loads later in the TOC, so the
-- line waits in br.earlyMessages and Logging.lua prints it.
br.api.printCompatLoaded = function()
    if br.api.compat and br.api.compat.getVersionInfo then
        local versionInfo = br.api.compat:getVersionInfo()
        br.earlyMessages = br.earlyMessages or {}
        br.earlyMessages[#br.earlyMessages + 1] = "API: " .. br.api.expansion .. " compatibility layer loaded (Build: " .. versionInfo.build .. ")"
    end
end

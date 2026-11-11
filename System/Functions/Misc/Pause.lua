local _, br = ...
-- When the rotation pauses (key, casting, channelling, mounted, ...).
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
misc.pauseCast = br.game.GetTime()

-- Channels the player can freely act through — moving, attacking, or casting does NOT
-- cancel them — so the rotation must NOT pause while they tick (otherwise we just stand
-- there taking damage until the channel's own timer ends).
--
-- Opt-in per spell on purpose: the default "pause during any channel" behavior is correct
-- for normal channels, where acting would clip them. Reference each by its spell-list name
-- (the actual ID lives in br.lists.spells.Shared.Shared.abilities — e.g. fumping = 39238 in
-- Expansions/TBC/Global.lua). To capture a new channel's ID, run this WHILE channeling it:
--     /run print((select(8, UnitChannelInfo("player"))))
local nonBlockingChannelNames = {
	"fumping", -- Fumper (item 31810, TBC quest "Fumping"): surfaces a hostile bone sifter
}

local nonBlockingChannels

-- Resolved { [spellID] = true } lookup, built lazily on first pause() call (the spell lists
-- load after this file). Names absent on the active expansion resolve to nil and are
-- skipped, so this is safe to share across Classic/TBC/MOP/Retail.

-- The logout countdown (/logout, /camp, /quit, the menu's Log Out / Exit Game). The game refuses
-- every cast until it ends ("Another action is in progress"), and a buff that never lands is asked
-- for again every tick: 2026-11-06 on Forever, Thorns and Bear Form 0.2 s apart for 9 s, all refused.
-- No client has an IsLoggingOut(); the events say when it starts and when it's called off. Combat
-- calls it off too. LOGOUT_SAFETY caps the pause in case a cancel ever goes unannounced (the
-- countdown is 20 s).
local LOGOUT_SAFETY = 30
local logoutStartedAt

--- Feeds the logout events (the frame below; the tests call it directly).
function misc.logoutEvent(event)
	if event == "PLAYER_CAMPING" or event == "PLAYER_QUITING" then
		logoutStartedAt = br.game.GetTime()
	else -- LOGOUT_CANCEL, PLAYER_REGEN_DISABLED
		logoutStartedAt = nil
	end
end

local logoutFrame = br.game.CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_CAMPING", "PLAYER_QUITING", "LOGOUT_CANCEL", "PLAYER_REGEN_DISABLED" }) do
	logoutFrame:RegisterEvent(event)
end
logoutFrame:SetScript("OnEvent", function(_, event) misc.logoutEvent(event) end)

--- True while the logout (or quit) countdown runs.
function misc:isLoggingOut()
	if logoutStartedAt == nil then return false end
	if br.game.GetTime() - logoutStartedAt > LOGOUT_SAFETY then
		logoutStartedAt = nil
		return false
	end
	return true
end

-- A batch of crafts (Create All, or a count): the game starts the next craft about 0.1 s after one ends, so a send in
-- that gap is refused ("Another action is in progress") and a buff that never lands is asked for again at every gap:
-- 2026-11-06 on Forever, Thorns refused 4 times during a run of Linen Bandages. Out of combat only, so a fight is
-- never paused by a craft. C_TradeSkillUI.IsRecipeRepeating is on Forever's client but undocumented: taken to be
-- true while the batch has crafts left; on a client without it nothing pauses.
local function isCraftingBatch()
	local tradeSkill = br.game.C_TradeSkillUI
	local isRepeating = tradeSkill and tradeSkill.IsRecipeRepeating
	if type(isRepeating) ~= "function" or br.functions.misc:isInCombat("player") then return false end
	return isRepeating() == true
end

-- Why the player can't act right now, apart from casting: checked once per tick (memo below).
-- Returns the reason, and whether an Evoker empower may run through it (it must keep updating
-- its charge stage; only the deliberate pauses stop it).
local function standingReason(now)
	local sb = br.lists.spells.Shared.Shared.buffs
	local sd = br.lists.spells.Shared.Shared.debuffs

	-- Dead (health = 0 or ghost-running). UnitHealth == 0 is the fastest pre-filter.
	if br.game.UnitHealth("player") == 0 then return "dead", false end

	-- ── DPS Testing timer ──────────────────────────────────────────────────
	if br.functions.misc:isChecked("DPS Testing") then
		if br.functions.unit:GetObjectExists("target") and br.functions.misc:isInCombat("player") then
			if br.functions.combat:getCombatTime() >= (tonumber(br.functions.misc:getValue("DPS Testing")) * 60) and br.functions.unit:isDummy() then
				br.game.StopAttack()
				br.game.ClearTarget(); br.functions.range:clearDistanceMemo()
				br.game.print(tonumber(br.functions.misc:getValue("DPS Testing")) ..
					" Minute Dummy Test Concluded - Profile Stopped")
				br.profileStop = true
			else
				br.profileStop = false
			end
		elseif not br.functions.misc:isInCombat("player") and br.profileStop == true then
			if br.functions.unit:GetObjectExists("target") then
				br.game.StopAttack()
				br.game.ClearTarget(); br.functions.range:clearDistanceMemo()
				br.profileStop = false
			end
		end
	end

	-- ── Pause Toggle (UI button) ───────────────────────────────────────────
	local toggles = br.data.settings[br.loader.selectedSpec].toggles
	if toggles ~= nil and toggles["Pause"] == 1 then return "pause toggle", false end

	-- ── Pause key: held with keyboard focus clear and the option enabled ───
	if br.functions.misc:isPauseKeyDown() then return "pause key", false end

	if br.profileStop then return "profile stopped", true end

	if misc:isLoggingOut() then return "logging out", true end

	if isCraftingBatch() then return "crafting", true end

	-- Mounted or flying — but NOT when targeting a boss. Some outdoor/encounter
	-- sequences require the rotation to function while the player is airborne
	-- (e.g. Netherwing Drake quests, outdoor world bosses with flying phases).
	-- UnitOnTaxi covers flight paths.
	-- Vehicle: pause unless "Bypass Vehicle Check" is on, OR the player has a
	-- valid attackable target (combat vehicles like Siege Engine, gunship, etc.).
	-- Exception: Draenor Nagrand mounts (164222/165803/157059) are combat mounts
	-- that allow normal spellcasting; Divine Steed (190784) is a Paladin
	-- mobility buff that briefly triggers IsMounted but permits combat.
	local nagrandMount = br.functions.aura:UnitBuffID("player", sb.divineSteed)
		or br.functions.aura:UnitBuffID("player", sb.nagrandTalbuk)
		or br.functions.aura:UnitBuffID("player", sb.nagrandClefthoof)
		or br.functions.aura:UnitBuffID("player", sb.nagrandRidingClefthoof)
		or br.functions.aura:UnitBuffID("player", sb.nagrandGoat)
	if not nagrandMount then
		if (br.game.IsMounted() or br.game.IsFlying()) and not br.functions.unit:isBoss("target") then return "mounted", true end
		if br.game.UnitOnTaxi("player") then return "on a taxi", true end
		if br.game.UnitInVehicle("player")
			and not br.functions.misc:isChecked("Bypass Vehicle Check")
			and not (br.game.UnitExists("target") and br.game.UnitCanAttack("player", "target"))
		then
			return "in a vehicle", true
		end
	end

	-- Spell-targeting cursor active (player clicked a targeted spell)
	if br.game.SpellIsTargeting() then return "targeting a spell", true end

	-- Dead, eating, drinking, specific channeled debuffs/buffs.
	-- 252753 = Potion of Replenishment (BFA mana channel — registered as a debuff).
	-- 114018 = Shroud of Concealment (Rogue group stealth, MOP+); rotation should
	--          remain idle while the group is sneaking.
	if br.game.UnitIsDeadOrGhost("player") then return "dead", true end
	if br.functions.unit:isEating() then return "eating", true end
	if br.functions.unit:isDrinking() then return "drinking", true end
	if br.functions.aura:UnitDebuffID("player", sd.potionOfReplenishment) then return "drinking", true end
	if br.functions.aura:UnitBuffID("player", sb.shroudOfConcealment) then return "sneaking", true end

	-- Pet battle: player character is completely locked during a pet battle UI.
	-- C_PetBattles exists on MOP+ only; nil-guarded for Classic/TBC safety.
	if br.game.C_PetBattles and br.game.C_PetBattles.IsInBattle and br.game.C_PetBattles.IsInBattle() then return "pet battle", true end

	-- Mind Control / Charm: player is controlled by an enemy and cannot act.
	-- On Classic/TBC/MOP, hasCharmBreakTracking = false, so this always pauses
	-- (no C_LossOfControl infrastructure exists on those clients).
	-- On Retail, hasCharmBreakTracking = true: pause by default, but a rotation
	-- that implements a charm-break ability (e.g. DK Lichborne) can enable the
	-- "Bypass CC Pause" option to let Cast.lua's per-spell cannotCast() gate
	-- handle the MC instead of halting the entire rotation here.
	if br.game.UnitIsCharmed("player")
		and (not br.client.rules.hasCharmBreakTracking or not br.functions.misc:isChecked("Bypass CC Pause"))
	then
		return "charmed", true
	end
	return nil
end

-- Per-tick memo of standingReason: Core and the profile both ask each tick. GetTime() is the
-- same for the whole frame. Casting is checked on every call, since a pre-cast sent this tick
-- changes the answer.
local memoTime, memoReason, memoEmpowerRuns

-- True while the player holds the Pause Mode key (with the option on and no edit box focused)
function misc:isPauseKeyDown()
	if not misc:isChecked("Pause Mode") or misc:isTyping() then return false end
	local held = misc:SpecificToggle("Pause Mode")
	if held == nil or misc:getValue("Pause Mode") == 6 then return br.game.IsLeftAltKeyDown() == true end
	return held == true
end

-- The player's own key press, from the game sending it (UNIT_SPELLCAST_SENT that isn't BR's) until its cast shows
-- (then "casting" holds), it goes off or it fails. A BR send in that gap interrupts it: 2026-11-07 on Forever, BR's
-- Bear Form went out 0.1 s after the player pressed Hearthstone, before the cast showed, and interrupted it.
-- Capped (OWN_SEND_HOLD, or a round trip when longer) in case no answer comes.
local OWN_SEND_HOLD = 0.5
local ownSendAt, ownSendGUID

--- Feeds the player's cast events (the frame below; the tests call it directly). SENT is (unit, target, castGUID,
-- spellID); the others are (unit, castGUID, spellID).
function misc.ownSendEvent(event, unit, arg2, arg3, arg4)
	if unit ~= "player" then return end
	if event == "UNIT_SPELLCAST_SENT" then
		local castGUID, spellID = arg3, arg4
		if spellID ~= nil and not misc:canUseValue(spellID) then spellID = nil end
		if br.engines.cast.internal.isBotSend(spellID) then return end
		ownSendAt = br.game.GetTime()
		ownSendGUID = castGUID ~= nil and misc:canUseValue(castGUID) and castGUID or nil
	elseif ownSendAt ~= nil then
		-- The cast showed, went off or failed: the one the player sent, or any when the IDs can't be compared
		local castGUID = arg2
		if ownSendGUID == nil or castGUID == nil or not misc:canUseValue(castGUID) or castGUID == ownSendGUID then
			ownSendAt, ownSendGUID = nil, nil
		end
	end
end

local ownSendFrame = br.game.CreateFrame("Frame")
for _, event in ipairs({ "UNIT_SPELLCAST_SENT", "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_FAILED_QUIET", "UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_STOP" })
do
	ownSendFrame:RegisterEvent(event)
end
ownSendFrame:SetScript("OnEvent", function(_, event, ...) misc.ownSendEvent(event, ...) end)

--- Why the player's own cast or channel holds new casts and item uses now, or nil: "item channel",
-- "channelling", "casting" or "your cast starting" (a key press of the player's the game hasn't answered yet).
-- The rotation still runs; the cast system refuses sends while this holds (Cast/CastFunction.lua), except casts
-- the profile marks .whileCasting and cast.cancel.
function misc:ownCastHold()
	local now = br.game.GetTime()

	-- Resolve the act-through-channel ID set once, now that the spell lists are loaded.
	local sa = br.lists.spells.Shared.Shared.abilities
	if nonBlockingChannels == nil and sa then
		nonBlockingChannels = {}
		for i = 1, #nonBlockingChannelNames do
			local id = sa[nonBlockingChannelNames[i]]
			if id then nonBlockingChannels[id] = true end
		end
	end

	-- ── BFA item channel lock (Retail only) ───────────────────────────────
	-- Focused Azerite Beam (295258→295261), Cyclotronic Blast (293491),
	-- and Azshara's Font of Power / Latent Arcana (296962) each trigger a
	-- follow-up channel that must complete uninterrupted. misc.pauseCast
	-- stores the timestamp at which the follow-up finishes.
	if br.client.rules.hasBFAItemChannels then
		local sb    = br.lists.spells.Shared.Shared.buffs
		local items = br.lists.items
		local lastCast = br.functions.lastCast.lastCastTable.tracker[1]
		if misc.pauseCast - now <= 0 then
			local hasted = (1 - br.game.UnitSpellHaste("player") / 100)
			-- Focused Azerite Beam
			if lastCast == sa.focusedAzeriteBeam and br.functions.spell:getSpellCD(sa.focusedAzeriteBeam) == 0 then
				misc.pauseCast = now + br.engines.cast:getCastTime(sa.focusedAzeriteBeam) + (br.engines.cast:getCastTime(sa.focusedAzeriteBeamChannel) * hasted)
			end
			-- Cyclotronic Blast
			if lastCast == sa.cyclotronicBlast and br.game.C_Container.GetItemCooldown(items.pocketSizedComputationDevice) == 0 then
				misc.pauseCast = now + br.engines.cast:getCastTime(sa.cyclotronicBlast) + (2.5 * hasted) + br.functions.spell:getGlobalCD(true)
			end
			-- Azshara's Font of Power - Latent Arcana
			if lastCast == sb.latentArcana and br.game.C_Container.GetItemCooldown(items.azsharasFontOfPower) == 0 then
				misc.pauseCast = now + br.engines.cast:getCastTime(sb.latentArcana) + (2.5 * hasted)
			end
		end
		if now < misc.pauseCast then
			return "item channel"
		else
			misc.pauseCast = now
		end
	end

	-- An Evoker empower must keep updating its charge stage
	if br.empowerID ~= nil and br.empowerID > 0 then return nil end

	-- Channelling holds EXCEPT act-through channels (nonBlockingChannels): those let us
	-- move/attack/cast without clipping them, so we keep acting and fight back.
	local channelName, _, _, _, _, _, _, channelSpellID = br.game.UnitChannelInfo("player")
	if channelName ~= nil and not (channelSpellID and nonBlockingChannels and nonBlockingChannels[channelSpellID]) then
		return "channelling"
	end

	-- Casting holds until the cast is inside the spell queue window; then one send may
	-- pre-cast whatever the profile ranks highest. After that choice is sent, it holds until
	-- this cast ends so nothing replaces it. Only in combat: a pull spell's window falls before
	-- its bolt lands, so out of combat the profile would pre-cast a second pull spell instead of
	-- letting the first decision after the pull use its in-combat priorities.
	-- Only behind a cast of one of the rotation's spells: a send while Skinning, mining or a Hearthstone casts
	-- interrupts it instead of queueing (2026-11-07 18:59:26: Faerie Fire behind Skinning at 0.18 s left
	-- interrupted the Skinning)
	local castName, _, _, _, endTime, _, castID, _, castSpellID = br.game.UnitCastingInfo("player")
	if castName ~= nil then
		local window = br.game.UnitAffectingCombat("player") and br.engines.cast:getQueueWindow() or 0
		if window > 0 and castSpellID ~= nil and misc:canUseValue(castSpellID)
			and not br.functions.lastCast:isAbility(castSpellID)
		then
			window = 0
		end
		if (endTime / 1000 - now) > window or br.engines.cast:isQueuedBehind(castID, endTime) then
			return "casting"
		end
		-- Inside the queue window and nothing pre-cast yet: one send may pre-cast.
	end
	-- The player pressed something the game hasn't answered yet (no cast showing, not gone off or failed)
	if ownSendAt ~= nil then
		if now - ownSendAt <= math.max(OWN_SEND_HOLD, misc:getRoundTripHold()) then return "your cast starting" end
		ownSendAt, ownSendGUID = nil, nil
	end
	return nil
end

--- Why the rotation should not act now, or nil when it may.
-- Reasons: "dead", "control disabled", "pause toggle", "pause key", "profile stopped", "logging out", "crafting", "mounted",
-- "on a taxi", "in a vehicle", "targeting a spell", "eating", "drinking", "sneaking", "pet battle",
-- "charmed", and unless skipCastingCheck, the player's own cast (ownCastHold: "item channel",
-- "casting", "channelling", "your cast starting"). The rotation itself runs through casts (Rotation:startRotation passes
-- true); the cast system holds its sends instead.
-- @param skipCastingCheck true for code that acts while the player casts or channels
function misc:pauseReason(skipCastingCheck)
	local now = br.game.GetTime()
	if memoTime ~= now then
		memoTime = now
		memoReason, memoEmpowerRuns = standingReason(now)
	end
	if memoReason then
		if br.empowerID ~= nil and br.empowerID > 0 and memoEmpowerRuns then return nil end
		return memoReason
	end
	if skipCastingCheck then return nil end
	return misc:ownCastHold()
end

-- if pause() then
-- set skipCastingCheck to true, to not check if player is casting
-- (useful if you want to use off-cd stuff, or spells which can be cast while other is casting)
function misc:pause(skipCastingCheck)
	return misc:pauseReason(skipCastingCheck) ~= nil
end

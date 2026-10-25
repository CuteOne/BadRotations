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

--- Why the rotation should not act now, or nil when it may.
-- Reasons: "dead", "control disabled", "pause toggle", "pause key", "profile stopped", "mounted",
-- "on a taxi", "in a vehicle", "targeting a spell", "eating", "drinking", "sneaking", "pet battle",
-- "charmed", "item channel", "casting", "channelling".
-- @param skipCastingCheck true for code that acts while the player casts or channels
function misc:pauseReason(skipCastingCheck)
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
	if br.client.rules.hasBFAItemChannels and not skipCastingCheck then
		local sb    = br.lists.spells.Shared.Shared.buffs
		local items = br.lists.items
		local lastCast = br.functions.lastCast.lastCastTable.tracker[1]
		if misc.pauseCast - now <= 0 then
			local hasted = (1 - br.game.UnitSpellHaste("player") / 100)
			-- Focused Azerite Beam
			if lastCast == sa.focusedAzeriteBeam and br.functions.spell:getSpellCD(sa.focusedAzeriteBeam) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sa.focusedAzeriteBeam) + (br.functions.cast:getCastTime(sa.focusedAzeriteBeamChannel) * hasted)
			end
			-- Cyclotronic Blast
			if lastCast == sa.cyclotronicBlast and br.game.C_Container.GetItemCooldown(items.pocketSizedComputationDevice) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sa.cyclotronicBlast) + (2.5 * hasted) + br.functions.spell:getGlobalCD(true)
			end
			-- Azshara's Font of Power - Latent Arcana
			if lastCast == sb.latentArcana and br.game.C_Container.GetItemCooldown(items.azsharasFontOfPower) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sb.latentArcana) + (2.5 * hasted)
			end
		end
		if now < misc.pauseCast then
			return "item channel"
		else
			misc.pauseCast = now
		end
	end

	if memoTime ~= now then
		memoTime = now
		memoReason, memoEmpowerRuns = standingReason(now)
	end
	local empowering = br.empowerID ~= nil and br.empowerID > 0
	if memoReason then
		if empowering and memoEmpowerRuns then return nil end
		return memoReason
	end
	if skipCastingCheck then return nil end

	-- Channeling pauses the rotation EXCEPT for act-through channels (nonBlockingChannels):
	-- those let us move/attack/cast without clipping them, so we keep running and fight back.
	local channelName, _, _, _, _, _, _, channelSpellID = br.game.UnitChannelInfo("player")
	if channelName ~= nil and not (channelSpellID and nonBlockingChannels and nonBlockingChannels[channelSpellID]) then
		if empowering then return nil end
		return "channelling"
	end

	-- Casting: stay paused until the cast is inside the spell queue window, then
	-- run the profile once to pre-cast whatever it ranks highest. After that
	-- choice is sent, stay paused until this cast ends so nothing replaces it.
	-- Only in combat: a pull spell's window falls before its bolt lands, so out of
	-- combat the profile would pre-cast a second pull spell instead of letting the
	-- first decision after the pull use its in-combat priorities.
	local castName, _, _, _, endTime, _, castID = br.game.UnitCastingInfo("player")
	if castName ~= nil then
		if empowering then return nil end
		local window = br.game.UnitAffectingCombat("player") and br.functions.cast:getQueueWindow() or 0
		if (endTime / 1000 - now) > window or br.functions.cast:isQueuedBehind(castID, endTime) then
			return "casting"
		end
		-- Inside the queue window and nothing pre-cast yet: the profile may pre-cast.
	end
	return nil
end

-- if pause() then
-- set skipCastingCheck to true, to not check if player is casting
-- (useful if you want to use off-cd stuff, or spells which can be cast while other is casting)
function misc:pause(skipCastingCheck)
	return misc:pauseReason(skipCastingCheck) ~= nil
end

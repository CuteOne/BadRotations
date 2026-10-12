local _, br = ...
-- When the rotation pauses (key, casting, channelling, mounted, ...).
---@class br.functions.misc
br.functions.misc = br.functions.misc or {}
local misc = br.functions.misc
-- if pause() then
-- set skipCastingCheck to true, to not check if player is casting
-- (useful if you want to use off-cd stuff, or spells which can be cast while other is casting)
misc.pauseCast = br._G.GetTime()

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
function misc:pause(skipCastingCheck)
	-- Cache GetTime() once — used repeatedly below.
	local now = br._G.GetTime()
	local pausekey

	-- ── List references (IDs live in Retail/Global.lua + System/Lists/Items.lua) ──
	local sb    = br.lists.spells.Shared.Shared.buffs      -- Shared.buffs
	local sa    = br.lists.spells.Shared.Shared.abilities  -- Shared.abilities
	local sd    = br.lists.spells.Shared.Shared.debuffs    -- Shared.debuffs
	local items = br.lists.items

	-- Resolve the act-through-channel ID set once, now that the spell lists are loaded.
	if nonBlockingChannels == nil and sa then
		nonBlockingChannels = {}
		for i = 1, #nonBlockingChannelNames do
			local id = sa[nonBlockingChannelNames[i]]
			if id then nonBlockingChannels[id] = true end
		end
	end

	-- ── Fast-path exits (cheapest checks first) ────────────────────────────
	-- Dead (health = 0 or ghost-running). UnitIsDeadOrGhost is more thorough
	-- but UnitHealth == 0 is the fastest pre-filter for the fully-dead state.
	if br._G.UnitHealth("player") == 0 then return true end
	if br.disableControl == true then return true end

	-- ── Deferred locals (only evaluated after cheap early exits) ───────────
	local eating   = br.functions.unit:isEating()
	local drinking = br.functions.unit:isDrinking()

	-- ── Pause key resolution ───────────────────────────────────────────────
	if br.functions.misc:SpecificToggle("Pause Mode") == nil or br.functions.misc:getValue("Pause Mode") == 6 then
		pausekey = br._G.IsLeftAltKeyDown()
	else
		pausekey = br.functions.misc:SpecificToggle("Pause Mode")
	end

	-- ── BFA item channel lock (Retail only) ───────────────────────────────
	-- Focused Azerite Beam (295258→295261), Cyclotronic Blast (293491),
	-- and Azshara's Font of Power / Latent Arcana (296962) each trigger a
	-- follow-up channel that must complete uninterrupted. misc.pauseCast
	-- stores the timestamp at which the follow-up finishes.
	if br.api.hasBFAItemChannels and not skipCastingCheck then
		local lastCast = br.functions.lastCast.lastCastTable.tracker[1]
		if misc.pauseCast - now <= 0 then
			local hasted = (1 - br._G.UnitSpellHaste("player") / 100)
			-- Focused Azerite Beam
			if lastCast == sa.focusedAzeriteBeam and br.functions.spell:getSpellCD(sa.focusedAzeriteBeam) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sa.focusedAzeriteBeam) + (br.functions.cast:getCastTime(sa.focusedAzeriteBeamChannel) * hasted)
			end
			-- Cyclotronic Blast
			if lastCast == sa.cyclotronicBlast and br._G.C_Container.GetItemCooldown(items.pocketSizedComputationDevice) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sa.cyclotronicBlast) + (2.5 * hasted) + br.functions.spell:getGlobalCD(true)
			end
			-- Azshara's Font of Power - Latent Arcana
			if lastCast == sb.latentArcana and br._G.C_Container.GetItemCooldown(items.azsharasFontOfPower) == 0 then
				misc.pauseCast = now + br.functions.cast:getCastTime(sb.latentArcana) + (2.5 * hasted)
			end
		end
		if now < misc.pauseCast then
			return true
		else
			misc.pauseCast = now
		end
	end

	-- ── DPS Testing timer ──────────────────────────────────────────────────
	if br.functions.misc:isChecked("DPS Testing") then
		if br.functions.unit:GetObjectExists("target") and br.functions.misc:isInCombat("player") then
			if br.functions.combat:getCombatTime() >= (tonumber(br.functions.misc:getOptionValue("DPS Testing")) * 60) and br.functions.unit:isDummy() then
				br._G.StopAttack()
				br._G.ClearTarget(); br.functions.range:clearDistanceMemo()
				br._G.print(tonumber(br.functions.misc:getOptionValue("DPS Testing")) ..
					" Minute Dummy Test Concluded - Profile Stopped")
				br.profileStop = true
			else
				br.profileStop = false
			end
		elseif not br.functions.misc:isInCombat("player") and br.profileStop == true then
			if br.functions.unit:GetObjectExists("target") then
				br._G.StopAttack()
				br._G.ClearTarget(); br.functions.range:clearDistanceMemo()
				br.profileStop = false
			end
		end
	end

	-- ── Pause Toggle (UI button) ───────────────────────────────────────────
	if br.data.settings[br.loader.selectedSpec].toggles ~= nil and br.data.settings[br.loader.selectedSpec].toggles["Pause"] == 1 then
		br.ui.chatOverlay:Show("\124cFFED0000 -- Paused -- ")
		return true
	end

	-- ── Build named conditions for the main halt check ────────────────────

	-- Pause key held with keyboard focus clear and option enabled.
	local isPauseKey = pausekey and br._G.GetCurrentKeyBoardFocus() == nil and br.functions.misc:isChecked("Pause Mode")

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
	local isMobilized = not nagrandMount and (
		((br._G.IsMounted() or br._G.IsFlying()) and not br.functions.unit:isBoss("target"))
		or br._G.UnitOnTaxi("player")
		or (br._G.UnitInVehicle("player")
			and not br.functions.misc:isChecked("Bypass Vehicle Check")
			and not (br._G.UnitExists("target") and br._G.UnitCanAttack("player", "target")))
	)

	-- Casting / channeling a spell (with latency window handled in the then-block).
	local isCasting   = not skipCastingCheck and br._G.UnitCastingInfo("player") ~= nil
	-- Channeling pauses the rotation EXCEPT for act-through channels (nonBlockingChannels):
	-- those let us move/attack/cast without clipping them, so we keep running and fight back.
	local channelName, _, _, _, _, _, _, channelSpellID = br._G.UnitChannelInfo("player")
	local isChanneling = not skipCastingCheck and channelName ~= nil
		and not (channelSpellID and nonBlockingChannels and nonBlockingChannels[channelSpellID])

	-- Dead, eating, drinking, specific channeled debuffs/buffs.
	-- 252753 = Potion of Replenishment (BFA mana channel — registered as a debuff).
	-- 114018 = Shroud of Concealment (Rogue group stealth, MOP+); rotation should
	--          remain idle while the group is sneaking.
	local isIncapacitated = br._G.UnitIsDeadOrGhost("player")
		or eating or drinking
		or br.functions.aura:UnitDebuffID("player", sd.potionOfReplenishment)
		or br.functions.aura:UnitBuffID("player", sb.shroudOfConcealment)

	-- Pet battle: player character is completely locked during a pet battle UI.
	-- C_PetBattles exists on MOP+ only; nil-guarded for Classic/TBC safety.
	local inPetBattle = br._G.C_PetBattles and br._G.C_PetBattles.IsInBattle and br._G.C_PetBattles.IsInBattle()

	-- Mind Control / Charm: player is controlled by an enemy and cannot act.
	-- On Classic/TBC/MOP, hasCharmBreakTracking = false, so this always pauses
	-- (no C_LossOfControl infrastructure exists on those clients).
	-- On Retail, hasCharmBreakTracking = true: pause by default, but a rotation
	-- that implements a charm-break ability (e.g. DK Lichborne) can enable the
	-- "Bypass CC Pause" option to let Cast.lua's per-spell cannotCast() gate
	-- handle the MC instead of halting the entire rotation here.
	local isCharmed = br._G.UnitIsCharmed("player")
		and (not br.api.hasCharmBreakTracking or not br.functions.misc:isChecked("Bypass CC Pause"))

	-- ── Spell-targeting cursor active (player clicked a targeted spell) ────
	local isTargeting = br._G.SpellIsTargeting()

	-- ── Main halt condition ────────────────────────────────────────────────
	if isPauseKey or br.profileStop
		or isMobilized or isTargeting
		or isCasting or isChanneling
		or isIncapacitated or inPetBattle or isCharmed
	then
		-- Evoker empowered spells must continue updating their charge stage even
		-- while the outer condition would normally halt everything. Only the
		-- deliberate pause-key press overrides this.
		if br.empowerID ~= nil and br.empowerID > 0 and not isPauseKey then
			return false
		end

		-- Casting: stay paused until the cast is inside the spell queue window, then
		-- run the profile once to pre-cast whatever it ranks highest. After that
		-- choice is sent, stay paused until this cast ends so nothing replaces it.
		-- Only in combat: a pull spell's window falls before its bolt lands, so out of
		-- combat the profile would pre-cast a second pull spell instead of letting the
		-- first decision after the pull use its in-combat priorities.
		if isCasting then
			local _, _, _, _, endTime, _, castID = br._G.UnitCastingInfo("player")
			local window = br._G.UnitAffectingCombat("player") and br.functions.cast:getQueueWindow() or 0
			if (endTime / 1000 - now) > window then
				return true
			end
			if br.functions.cast:isQueuedBehind(castID, endTime) then
				return true
			end
			-- Inside the queue window and nothing pre-cast yet — fall through.
		else
			br.ui.chatOverlay:Show("Profile Paused")
			return true
		end
	end

	return false
end

--Version 1.0.0
local rotationName = "FengshenHoly" -- Change to name of profile listed in options drop down
local StunsBlackList="167876|169861|168318|165824|165919|171799|168942|167612|169893|167536|173044|167731|165137|167538|168886|170572"
local StunSpellList="326450|328177|331718|331743|334708|333145|321807|334748|327130|327240|330532|328400|330423|294171|164737|330586|329224|328429|295001|296355|295001|295985|330471|329753|296748|334542|242391|322169|324609"
local HoJPrioList = "164702|164362|170488|165905|165251|165556"
---------------
--- Toggles ---
---------------
local function createToggles()
	local CreateButton = br["CreateButton"]
	br.CooldownModes = {
	[1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.holyAvenger},
	[2] = {mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.auraMastery},
	[3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.absolution}
	}
	CreateButton("Cooldown", 1, 0)
	br.DefensiveModes = {
	[1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.divineProtection},
	[2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blessingOfProtection}
	}
	CreateButton("Defensive", 2, 0)
	br.InterruptModes = {
	[1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.blindingLight},
	[2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.blindingLight}
	}
	CreateButton("Interrupt", 3, 0)
	br.CleanseModes = {
	[1] = {mode = "On", value = 1, overlay = "Cleanse Enabled", tip = "Cleanse Enabled", highlight = 1, icon = br.player.spell.cleanse},
	[2] = {mode = "Off", value = 2, overlay = "Cleanse Disabled", tip = "Cleanse Disabled", highlight = 0, icon = br.player.spell.cleanse}
	}
	CreateButton("Cleanse", 4, 0)
	br.DamageModes = {
	[1] = {mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.judgment},
	[2] = {mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.judgment}
	}
	CreateButton("Damage", 0, 1)
	br.BeaconModes = {
	[1] = {mode = "B 1", value = 1, overlay = "Boss1", tip = "BossTarget 1", highlight = 1, icon = br.player.spell.beaconOfLight},
	[2] = {mode = "B 2", value = 2, overlay = "Boss2", tip = "BossTarget 2", highlight = 1, icon = br.player.spell.beaconOfLight},
	[3] = {mode = "B 3", value = 3, overlay = "Boss3", tip = "BossTarget 3", highlight = 1, icon = br.player.spell.beaconOfLight},
	[4] = {mode = "Off", value = 4, overlay = "Off", tip = "Off", highlight = 0, icon = br.player.spell.beaconOfLight}
	}
	CreateButton("Beacon", 1, 1)
	br.MythicModes = {
	[1] = {mode = "On", value = 1, overlay = "use m+ logic", tip = "m+", highlight = 1, icon = br.player.spell.blessingOfSacrifice},
	[2] = {mode = "Off", value = 2, overlay = "Dont use m+ logic", tip = "not m+", highlight = 0, icon = br.player.spell.blessingOfSacrifice},
	}
	CreateButton("Mythic", 2, 1)
end

local function createOptions()
	local optionTable

	local function rotationOptions()
		-----------------------
		--- GENERAL OPTIONS ---
		----------------------
		section = br.ui:createSection(br.ui.window.profile, "General - Version 1.002")
		-- Blessing of Freedom
		br.ui:createCheckbox(section, "Blessing of Freedom")
		br.ui:createCheckbox(section, "Automatic Aura replacement")
		-- Critical
		br.ui:createSpinnerWithout(section, "Critical HP", 30, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Critical Heals")
		br.ui:createCheckbox(section, "OOC Healing", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.", 1)
		br.ui:createCheckbox(section, "OoC Spenders")
		br.ui:checkSectionState(section)
		-------------------------
		------ DEFENSIVES -------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Basic Healing Module
		br.player.module.BasicHealing(section)
		br.ui:createSpinner(section, "Divine Protection", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		if br.player.race == "BloodElf" then
			br.ui:createSpinner(section, "Arcane Torrent Dispel", 1, 0, 20, 1, "", "|cffFFFFFFMinimum Torrent Targets")
			br.ui:createSpinner(section, "Arcane Torrent Mana", 30, 0, 95, 1, "", "|cffFFFFFFMinimum When to use for mana")
			br.ui:createCheckbox(section, "Arcane Torrent HolyPower")
		end
		-- Gift of The Naaru
		if br.player.race == "Draenei" then
			br.ui:createSpinner(section, "Gift of The Naaru", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		end
		-- Absolution
		br.ui:createCheckbox(section, "Absolution")
		-- Unstable Temporal Time Shifter
		br.ui:createDropdown(section, "Engineering Revive", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "","|cffFFFFFFTarget to use on")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		--Hammer of Justice
		br.ui:createCheckbox(section, "Hammer of Justice")
		-- Blinding Light
		br.ui:createSpinner(section,  "Blinding Light",  2,  1,  5,  1,  "|cffFFBB00Units to use Blinding Light.")
		-- Interrupt Percentage
		br.ui:createSpinner(section, "InterruptAt", 95, 0, 95, 5, "", "|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		-------------------------
		------ COOL  DOWNS ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Cool Downs")
		-- Trinkets
		br.ui:createDropdown(section,"Use Trinkets 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns"}, 1, "","|cffFFFFFFWhen to use trinkets.")
		br.ui:createDropdownWithout(section,"Trinkets 1 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround","|cffFFFFFFAll Health","|cffFFFFFFTanks Health","|cffFFFFFFSelf Health"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createSpinnerWithout(section, "Trinkets 1",  70,  0,  100,  5,  "Health Percentage to use at")
		br.ui:createDropdown(section,"Use Trinkets 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns"}, 1, "","|cffFFFFFFWhen to use trinkets.")
		br.ui:createDropdownWithout(section,"Trinkets 2 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround","|cffFFFFFFAll Health","|cffFFFFFFTanks Health","|cffFFFFFFSelf Health"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createSpinnerWithout(section, "Trinkets 2",  70,  0,  100,  5,  "Health Percentage to use at")
		-- Lay on Hand
		br.ui:createSpinner(section, "Lay on Hands", 15, 0, 100, 5, "", "|cffFFFFFFMin Health Percent to Cast At")
		br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFSelf", "|cffFFFFFFHealer/DPS"}, 1, "|cffFFFFFFTarget for LoH")
		-- Blessing of Protection
		br.ui:createSpinner(section, "Blessing of Protection", 20, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "BoP Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFHealer/Damage", "|cffFFFFFFSelf"}, 3, "|cffFFFFFFTarget for BoP")
		-- Blessing of Sacrifice
		br.ui:createSpinner(section, "Blessing of Sacrifice", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "BoS Target", {"|cffFFFFFFAll", "|cffFFFFFFTanks", "|cffFFFFFFDamage"}, 2, "|cffFFFFFFTarget for BoS")
		-- Avenging Wrath
		br.ui:createSpinner(section, "Avenging Wrath", 50, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Avenging Wrath Targets", 4, 0, 40, 1, "", "|cffFFFFFFMinimum Avenging Wrath Targets", true)
		-- Holy Avenger
		br.ui:createSpinner(section, "Holy Avenger", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Holy Avenger Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Holy Avenger Targets",true)
		-- Aura Mastery
		br.ui:createSpinner(section, "Aura Mastery", 50, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Aura Mastery Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Aura Mastery Targets", true)
		br.ui:checkSectionState(section)
		-------------------------
		---- SINGLE TARGET ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
		--Flash of Light
		br.ui:createSpinner(section, "Flash of Light", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "FoL Tanks", 70, 0, 100, 5, "", "|cffFFFFFFTanks Health Percent to Cast At", true)
		br.ui:createSpinner(section, "FoL Infuse", 70, 0, 100, 5, "", "|cffFFFFFFIn Infuse buff Health Percent to Cast At", true)
		br.ui:createSpinner(section, "FoL Beacon", 80, 0, 100, 5, "", "|cffFFFFFFHealth of Beacon Target to cast FoL At")
		br.ui:createSpinner(section, "OOC FoL", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		--Holy Light
		br.ui:createSpinner(section, "Holy Light", 85, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "Holy Light Infuse", {"|cffFFFFFFNormal", "|cffFFFFFFOnly Infuse"}, 2, "|cffFFFFFFOnly Use Infusion Procs.")
		--Holy Shock
		br.ui:createSpinner(section, "Holy Shock", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		--Word of Glory
		br.ui:createSpinner(section, "Word of Glory", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		-- Light of the Martyr
		br.ui:createSpinner(section, "Light of the Martyr", 40, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Moving LotM", 80, 0, 100, 5, "", "|cffFFFFFFisMoving Health Percent to Cast At")
		br.ui:createSpinner(section, "LoM after FoL", 60, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "LotM player HP limit", 50, 0, 100, 5, "", "|cffFFFFFFLight of the Martyr Self HP limit", true)
		br.ui:checkSectionState(section)
		-------------------------
		------ AOE HEALING ------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
		--Trinket?
		--Divine Toll
		if br.player.covenant.kyrian.active then
			br.ui:createDropdown(section, "Divine Toll", {"At 0 Holy Power", "As a Heal"}, 1)
			br.ui:createSpinnerWithout(section, "Divine Toll Units", 3, 1, 5, 1)
			br.ui:createSpinnerWithout(section, "Divine Toll Health", 70, 0, 100, 1)
			br.ui:createSpinnerWithout(section, "Max Holy Power", 2, 0, 5, 1, "Only use Divine Toll when at or below this value")
		end
		-- Rule of Law
		br.ui:createSpinner(section, "Rule of Law", 70, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "RoL Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum RoL Targets", true)
		-- Light of Dawn
		br.ui:createSpinner(section, "Light of Dawn", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "LoD Targets", 4, 0, 40, 1, "", "|cffFFFFFFMinimum LoD Targets", true)
		-- Beacon of Virtue
		br.ui:createSpinner(section, "Beacon of Virtue", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "BoV Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum BoV Targets", true)
		-- Holy Prism
		br.ui:createSpinner(section, "Holy Prism", 90, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Holy Prism Targets", 3, 0, 5, 1, "", "|cffFFFFFFMinimum Holy Prism Targets", true)
		-- Light's Hammer
		br.ui:createSpinner(section, "Light's Hammer", 80, 0, 100, 5, "", "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Light's Hammer Targets", 3, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets", true)
		br.ui:checkSectionState(section)
		-------------------------
		---------- DPS ----------
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "DPS")
		br.ui:createDropdown(section, "Hard DPS Key", br.dropOptions.Toggle, 6)
		-- Seraphim
		br.ui:createSpinner(section, "Seraphim",  0,  0,  20,  2,  "|cffFFFFFFEnemy TTD")
		-- Divine Toll Damage
		if br.player.covenant.kyrian.active then
			br.ui:createSpinner(section, "Divine Toll during DPS Key", 3, 1, 5, 1, "Use Divine Toll at >= x units")
		end
		-- Light's Hammer Damage
		br.ui:createSpinner(section, "Light's Hammer Damage", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Light's Hammer Targets")
		-- Shield of the Righteous
		br.ui:createSpinner(section, "Shield of the Righteous", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Shield of the Righteous Targets")
		-- Consecration
		br.ui:createSpinner(section, "Consecration", 1, 0, 40, 1, "", "|cffFFFFFFMinimum Consecration Targets")
		-- Judgment
		br.ui:createCheckbox(section, "Judgment - DPS")
		-- Holy Shock
		br.ui:createCheckbox(section, "Holy Shock Damage")
		-- Hammer of Wrath
		br.ui:createCheckbox(section,"Hammer of Wrath")
		-- Crusader Strike
		br.ui:createCheckbox(section, "Crusader Strike")
		br.ui:checkSectionState(section)
		----------------------
		-------- LISTS -------
		----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Lists")
		br.ui:createScrollingEditBoxWithout(section,"Stuns Black Units", StunsBlackList, "List of units to blacklist when Hammer of Justice", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"Stun Spells", StunSpellList, "List of spells to stun with auto stun function", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"HoJ Prio Units", HoJPrioList, "List of units to prioritize for Hammer of Justice", 240, 50)
		br.ui:checkSectionState(section)
	end
	local function OtherStuff()
		section = br.ui:createSection(br.ui.window.profile, "Devstuff")
		br.ui:createCheckbox(section, "Dev Stuff Leave off")
		br.ui:checkSectionState(section)
	end
	optionTable = {
	{
	[1] = "Rotation Options",
	[2] = rotationOptions
	},
	{
	[1] = "Other Options",
	[2] = OtherStuff
	}
	}
	return optionTable
end
local setwindow = false
local function runRotation()
	if br.UnitDebuffID("player",307161) then
		return true
	end
	if setwindow == false then
		br._G.RunMacroText("/console SpellQueueWindow 0")
		setwindow = true
	end

	local holyPower = br.player.power.holyPower.amount()
	local holyPowerMax = br.player.power.holyPower.max()
	local runeforge = br.player.runeforge
	local buff = br.player.buff
	local cast = br.player.cast
	local php = br.player.health
	local spell = br.player.spell
	local item = br.player.items
	local equiped = br.player.equiped
	local talent = br.player.talent
	local gcdMax = br.player.gcdMax
	local gcd = (((br.player.gcdMax + br.player.gcd) / 2) * 0.9)
	local charges = br.player.charges
	local cd = br.player.cd
	local debuff = br.player.debuff
	local eating = br.getBuffRemain("player",192002) ~= 0 or br.getBuffRemain("player",167152) ~= 0 or br.getBuffRemain("player",192001) ~= 0 or br.getBuffRemain("player",308433) ~= 0
	local resable = br._G.UnitIsPlayer("target") and br._G.UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player")
	local inCombat = br.player.inCombat
	local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
	local inRaid = br.player.instance == "raid"
	local solo = #br.friend == 1
	local OWGroup = br.player.instance == "none" and #br.friend >= 2
	local race = br.player.race
	local racial = br.player.getRacial()
	local traits = br.player.traits
	local moving = br.isMoving("player")
	local tanks = br.getTanksTable()
	local lowest = br.friend[1]
	local friends = friends or {}
	local module = br.player.module
	local glimmerCount = 0
	local enemies = br.player.enemies
	local lastSpell = lastSpellCast
	local mode = br.player.ui.mode
	local pullTimer = br.DBM:getPulltimer()
	local units = br.player.units
	local wingsup = buff.avengingCrusader.exists("player") or buff.avengingWrath.exists("player")
	local LightCount = 0
	local FaithCount = 0
	local SotR = true
	local actionList = {}

	if runeforge.shadowbreaker.equiped then
		lightOfDawn_distance = 40
	else
		lightOfDawn_distance = 15
	end
	if buff.ruleOfLaw.exists("player") then
		lightOfDawn_distance_coff = 1.5
	else
		lightOfDawn_distance_coff = 1
	end

	local lowest = {}
	lowest.unit = "player"
	lowest.hp = 100

	for i = 1, #br.friend do
		if br.friend[i].hp < lowest.hp and br.getLineOfSight(br.friend[i].unit,"player") and not br._G.UnitIsDeadOrGhost(br.friend[i].unit) then
			lowest = br.friend[i]
		end
	end

	local function ccDoubleCheck(unit)
		if br.getOptionCheck("Don't break CCs") and br.isLongTimeCCed(unit) then
			return false
		else
			return true
		end
	end

	local lowestBeacon = {}
	lowestBeacon.unit = nil
	lowestBeacon.hp = 100

	for i = 1, #br.friend do
		if buff.beaconOfLight.exists(br.friend[i].unit) or (buff.beaconOfVirtue.remain(br.friend[i].unit) > br.getCastTime(spell.flashOfLight)) or buff.beaconOfFaith.exists(br.friend[i].unit) then
			if br.friend[i].hp <= lowestBeacon.hp and br.getLineOfSight(br.friend[i].unit, "player") and not br._G.UnitIsDeadOrGhost(br.friend[i].unit) then
				lowestBeacon = br.friend[i]
			end
		end
	end

	for i = 1, #br.friend do
		if buff.glimmerOfLight.remain(br.friend[i].unit) > gcd then
			glimmerCount = glimmerCount + 1
		end
	end

	if br.isChecked("Holy Light") and br.GetObjectID("target") ~= 165759 and cast.current.holyLight() and not buff.infusionOfLight.exists("player") and br.getOptionValue("Holy Light Infuse") == 2 then
		br._G.SpellStopCasting()
	end

	units.get(5)
	units.get(8)
	units.get(15)
	units.get(30)
	units.get(40)
	enemies.get(5)
	enemies.get(8)
	enemies.get(10)
	enemies.get(15)
	enemies.get(30)
	enemies.get(40)
	friends.yards40 = br.getAllies("player", 40)

	if br.timersTable then
		br._G.wipe(br.timersTable)
	end

	local noStunsUnits = {}
	for i in string.gmatch(br.getOptionValue("Stuns Black Units"), "%d+") do
		noStunsUnits[tonumber(i)] = true
	end
	local StunSpellsList = {}
	for i in string.gmatch(br.getOptionValue("Stun Spells"), "%d+") do
		StunSpellsList[tonumber(i)] = true
	end
	local HoJList = {}
	for i in string.gmatch(br.getOptionValue("HoJ Prio Units"), "%d+") do
		HoJList[tonumber(i)] = true
	end

	local function bestConeHeal(spell, minUnits, health, angle, rangeInfront, rangeAround)
		if not br.isKnown(spell) or br.getSpellCD(spell) ~= 0 or select(2, br._G.IsUsableSpell(spell)) then
			return false
		end
		local curFacing = br._G.ObjectFacing("player")
		local playerX, playerY, _ = br._G.ObjectPosition("player")
		local coneTable = {}

		local unitsAround = 0
		for i = 1, #br.friend do
			local thisUnit = br.friend[i].unit
			if br.friend[i].hp < health then
				if br.friend[i].distance < rangeAround then
					unitsAround = unitsAround + 1
				elseif br.friend[i].distance < rangeInfront then
					local unitX, unitY, _ = br._G.ObjectPosition(thisUnit)
					if playerX and unitX then
						local angleToUnit = rad(atan2(unitY - playerY, unitX - playerX))
						if angleToUnit < 0 then
							angleToUnit = rad(360 + atan2(unitY - playerY, unitX - playerX))
						end
						tinsert(coneTable, angleToUnit)
					end
				end
			end
		end
		local facing, bestAngle, bestAngleUnitsHit = 0.1, 0, 0
		while facing <= 6.2 do
			local unitsHit = unitsAround
			for i = 1, #coneTable do
				local angleToUnit = coneTable[i]
				local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
				--local shortestAngle = angleDifference < math.pi and angleDifference or math.pi * 2 - angleDifference
				local finalAngle = angleDifference / math.pi * 180
				if finalAngle < angle then
					unitsHit = unitsHit + 1
				end
			end
			if unitsHit > bestAngleUnitsHit then
				bestAngleUnitsHit = unitsHit
				bestAngle = facing
			end
			facing = facing + 0.05
		end
		if bestAngleUnitsHit >= minUnits then
			local mouselookActive = false
			if br._G.IsMouselooking() then
				mouselookActive = true
				br._G.MouselookStop()
				br._G.TurnOrActionStop()
			end
			br._G.FaceDirection(bestAngle, true)
			br._G.CastSpellByName(br._G.GetSpellInfo(spell))
			br._G.FaceDirection(curFacing)
			if mouselookActive then
				br._G.MouselookStart()
			end
			lodFaced = true
			return true
		end
		return false
	end

	actionList.damageTime = function()
		local dpskey = br.isChecked("Hard DPS Key") and br.SpecificToggle("Hard DPS Key") and not br._G.GetCurrentKeyBoardFocus()

		if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and br.isValidUnit("target") and br.getFacing("player","target") then
			br._G.StartAttack()
		end

		-- Seraphim
		if (br.isChecked("Seraphim") or dpskey) and talent.seraphim and holyPower > 2 and br.getTTD("target") > br.getOptionValue("Seraphim") and br.getSpellCD(152262) <= gcdMax then
			SotR = false
			if cast.seraphim() then return true end
		end

		if br.isChecked("Divine Toll during DPS Key") and br.player.covenant.kyrian.active and dpskey and #enemies.yards30 >= br.getValue("Divine Toll during DPS Key") then
			if cast.divineToll(units.dyn30) then return true end
		end

		-- Hammer of Wrath
		if (br.isChecked("Hammer of Wrath") or dpskey) and br.getSpellCD(24275) == 0 then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if ccDoubleCheck(thisUnit) and (br.isChecked("Dev Stuff Leave off") or br.getFacing("player",thisUnit)) then
					if br.getHP(thisUnit) <= 20 or buff.avengingWrath.exists() or (br.player.covenant.venthyr.active and cd.ashenHallow.remain() > 210) then
						if cast.hammerOfWrath(thisUnit) then return true end
					end
				end
			end
		end

		if ((br.isChecked("Shield of the Righteous") and #enemies.yards5 >= br.getValue("Shield of the Righteous")) or dpskey) and SotR == true and cd.shieldOfTheRighteous.ready() then
			if (holyPower >= 3 or buff.divinePurpose.exists()) and br.getFacing("player",units.dyn5) then
				if cast.shieldOfTheRighteous(units.dyn5) then return true end
			end
		end

		if ((br.isChecked("Consecration") and #enemies.yards8 >= br.getValue("Consecration")) or (dpskey and #enemies.yards8 >= 1)) and cd.consecration.ready() then
			if br.getDebuffRemain("target",204242) == 0 and (not br._G.GetTotemInfo(1) or (br.getDistanceToObject("player", cX, cY, cZ) > 7) or br._G.GetTotemTimeLeft(1) < 2) then
				if cast.consecration() then cX, cY, cZ = br.GetObjectPosition("player") return true end
			end
		end

		-- Light's Hammer
		if talent.lightsHammer and cd.lightsHammer.ready() and not moving then
			if br.isChecked("Light's Hammer Damage") then
				if cast.lightsHammer("best", false,br.getOptionValue("Light's Hammer Damage"),10) then return true end
			end
			if dpskey then
				if cast.lightsHammer("best",false,1,10) then return true end
			end
		end

		-- Judgment
		if (br.isChecked("Judgment - DPS") or dpskey) and cd.judgment.ready() and ccDoubleCheck(units.dyn30) and (br.isChecked("Dev Stuff Leave off") or br.getFacing("player",units.dyn30)) and br.getLineOfSight(units.dyn30,"player") then
			if cast.judgment(units.dyn30) then return true end
		end

		if (br.isChecked("Holy Shock Damage") or dpskey) and cd.holyShock.ready() then
			if talent.glimmerOfLight then
				for i = 1, #enemies.yards40 do
					local thisUnit = enemies.yards40[i]
					if not debuff.glimmerOfLight.exists(thisUnit,"player") and br.getLineOfSight(thisUnit,"player") and ccDoubleCheck(thisUnit) and (br.isChecked("Dev Stuff Leave off") or br.getFacing("player",thisUnit)) then
						if cast.holyShock(thisUnit) then return true end
					end
				end
			end
			if br.getLineOfSight(units.dyn40,"player") and ccDoubleCheck(units.dyn40) and (br.isChecked("Dev Stuff Leave off") or br.getFacing("player",units.dyn40)) then
				if cast.holyShock(units.dyn40) then return true end
			end
		end

		if (br.isChecked("Crusader Strike") or dpskey) and br.getFacing("player",units.dyn5) and ((talent.crusadersMight and br.getSpellCD(20473) > gcdMax) or not talent.crusadersMight) then
			if cast.crusaderStrike(units.dyn5) then return true end
		end
	end

	actionList.spendies = function()
		if holyPower >= 3 or buff.divinePurpose.exists() then
			if br.isChecked("Word of Glory") then
				if php <= br.getValue("Critical HP") then
					SotR = false
					if cast.wordOfGlory("player") then return true end
				end
			end
			if br.isChecked("Light of Dawn") then
				if bestConeHeal(spell.lightOfDawn,br.getValue("LoD Targets"),br.getValue("Light of Dawn"),45,lightOfDawn_distance*lightOfDawn_distance_coff,5) then return true end
			end
			if br.isChecked("Word of Glory") and lowest.hp <= br.getValue("Word of Glory") then
				SotR = false
				if cast.wordOfGlory(lowest.unit) then return true end
			end
		end
	end

	actionList.defensiveTime = function()
		if br.useDefensive() then
			module.BasicHealing()
			-- Arcane Torrent
			if race == "BloodElf" and inCombat and br.getSpellCD(155145) == 0 then
				if br.isChecked("Arcane Torrent Dispel") then
					local torrentUnit = 0
					for i=1, #enemies.yards8 do
						local thisUnit = enemies.yards8[i]
						if br.canDispel(thisUnit,select(7,br._G.GetSpellInfo(br._G.GetSpellInfo(69179)))) then
							torrentUnit = torrentUnit + 1
							if torrentUnit >= br.getOptionValue("Arcane Torrent Dispel") then
								if br._G.CastSpellByName(br._G.GetSpellInfo(155145)) then return true end
								break
							end
						end
					end
				end
				if br.isChecked("Arcane Torrent Mana") and br.player.power.mana.percent() < br.getValue("Arcane Torrent Mana") then
					if br._G.CastSpellByName(br._G.GetSpellInfo(155145)) then return true end
				end
				if br.isChecked("Arcane Torrent HolyPower") and holyPower < 3 and lowest.hp < br.getValue("Critical HP") then
					if br._G.CastSpellByName(br._G.GetSpellInfo(155145)) then return true end
				end
			end

			if br.isChecked("Gift of The Naaru") and php <= br.getOptionValue("Gift of The Naaru") and php > 0 and race == "Draenei" then
				if br.castSpell("player",racial,false,false,false) then return true end
			end

			if br.isChecked("Divine Shield") and cd.divineShield.ready() then
				if php <= br.getOptionValue("Divine Shield") and not br.UnitDebuffID("player",25771) then
					if cast.divineShield("player") then return true end
				end
			end

			if br.isChecked("Divine Protection") and cd.divineProtection.ready() and not buff.divineShield.exists("player") then
				if php <= br.getOptionValue("Divine Protection") then
					if cast.divineProtection() then return true end
				elseif buff.blessingOfSacrifice.exists("player") then
					if cast.divineProtection() then return true end
				end
			end

			-- Engineering Revive
			if br.isChecked("Engineering Revive") and br.canUseItem(184308) and not moving and inCombat then
				if br.getOptionValue("Engineering Revive") == 1 and br._G.UnitIsPlayer("target") and br._G.UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target","player") and br.getDistance("target") <= 5 then
					br._G.UseItemByName(184308,"target")
				elseif br.getOptionValue("Engineering Revive") == 2 and br._G.UnitIsPlayer("mouseover") and br._G.UnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover","player") and br.getDistance("mouseover") <= 5 then
					br._G.UseItemByName(184308,"mouseover")
				elseif br.getOptionValue("Engineering Revive") == 3 then
					for i =1, #br.friend do
						if br._G.UnitIsPlayer(br.friend[i].unit) and br._G.UnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit,"player") and br.getDistance(br.friend[i].unit) <= 5 then
							if br._G.UseItemByName(184308,br.friend[i].unit) then return true end
						end
					end
				end
			end

			-- Absolution
			if br.isChecked("Absolution") and not inCombat and not moving and resable and not br.castingUnit() then
				if cast.absolution("target","dead") then return true end
			end
		end
	end
	-- end defensive list

	actionList.bellsAndWhistles = function()
		if br.isChecked("Blessing of Freedom") and cd.blessingOfFreedom.ready() then
			if br.hasNoControl(spell.blessingOfFreedom) and br.getDebuffRemain("player",323730) == 0 then
				if cast.blessingOfFreedom("player") then return true end
			end
		end

		-- cleanse your friends
		if mode.cleanse == 1 and cd.cleanse.ready() and (br.GetObjectID("boss1") ~= 164267 or buff.divineShield.exists()) then
			for i = 1, #br.friend do
				local thisUnit = br.friend[i].unit
				if br.canDispel(thisUnit,spell.cleanse) and br.getLineOfSight(thisUnit) and br.getDistance(thisUnit) <= 40 then
					if (br.getDebuffStacks(thisUnit,240443) == 0 or br.getDebuffStacks(thisUnit,240443) >= 4) and br.getDebuffRemain(thisUnit,323730) == 0 then
						if cast.cleanse(thisUnit) then return true end
					end
					if br.getDebuffRemain(thisUnit,323730) ~= 0 and #br.getAllies(thisUnit,16) <= 1 then
						if cast.cleanse(thisUnit) then return true end
					end
				end
			end
		end

		-- Interrupt your enemies
		if br.useInterrupts() then
			local BL_Unit = 0
			for i = 1, #enemies.yards10 do
				local thisUnit = enemies.yards10[i]
				-- Stun Spells
				local interruptID
				if br._G.UnitCastingInfo(thisUnit) then
					interruptID = select(9,br._G.UnitCastingInfo(thisUnit))
				elseif br._G.UnitChannelInfo(thisUnit) then
					interruptID = select(8,br._G.UnitChannelInfo(thisUnit))
				end
				if interruptID ~=nil and StunSpellsList[interruptID] and br.getBuffRemain(thisUnit,343503) == 0 and br.GetObjectID(thisUnit) ~= 173044 then
					if br.isChecked("Hammer of Justice") and cd.hammerOfJustice.ready() and br.getBuffRemain(thisUnit,226510) == 0 then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
					if br.isChecked("Blinding Light") and cd.blindingLight.ready() and talent.blindingLight then
						if cast.blindingLight() then return true end
					end
				end
				-- Interrupt
				if br.canInterrupt(thisUnit,br.getOptionValue("InterruptAt")) and not br.isBoss(thisUnit) and noStunsUnits[br.GetObjectID(thisUnit)] == nil and br.getBuffRemain(thisUnit,343503) == 0 then
					if br.isChecked("Blinding Light") and cd.blindingLight.ready() then
						BL_Unit = BL_Unit + 1
						if BL_Unit >= br.getOptionValue("Blinding Light") then
							if cast.blindingLight() then return true end
						end
					end
					-- Hammer of Justice
					if br.isChecked("Hammer of Justice") and cd.hammerOfJustice.ready() and br.getBuffRemain(thisUnit,226510) == 0 then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
				end
			end
		end
	end

	actionList.Beacon = function() -- 100% credit to Laksmackt
		local beaconOfLightinRaid = nil
		local beaconOfLightTANK = nil
		local beaconOfFaithTANK = nil
		local beaconOfFaithplayer = nil
		LightCount = 0
		FaithCount = 0
		for i = 1, #br.friend do
			if br._G.UnitInRange(br.friend[i].unit) then
				if buff.beaconOfLight.exists(br.friend[i].unit) then
					LightCount = LightCount + 1
				end
				if buff.beaconOfFaith.exists(br.friend[i].unit) then
					FaithCount = FaithCount + 1
				end
			end
		end
		if mode.beacon == 1 then
			bosstarget = "boss1target"
		elseif mode.beacon == 2 then
			bosstarget = "boss2target"
		elseif mode.beacon == 3 then
			bosstarget = "boss2target"
		end
		if mode.beacon ~= 4 and (inInstance or inRaid or OWGroup) and #tanks > 0 then
			for i = 1, #br.friend do
				if br._G.UnitInRange(br.friend[i].unit) and not br._G.UnitIsDeadOrGhost(br.friend[i].unit) then
					if (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and br.GetUnitIsUnit(br.friend[i].unit,bosstarget) and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
						beaconOfLightinRaid = br.friend[i].unit
					end
					if LightCount < 1 and (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
						beaconOfLightTANK = br.friend[i].unit
					end
					if FaithCount < 1 and (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
						beaconOfFaithTANK = br.friend[i].unit
					elseif FaithCount < 1 and not inRaid and not buff.beaconOfLight.exists(br.friend[i].unit) and not buff.beaconOfFaith.exists(br.friend[i].unit) then
						beaconOfFaithplayer = br.friend[i].unit
					end
				end
			end
		end
		if inRaid and beaconOfLightinRaid ~= nil then
			if cast.beaconOfLight(beaconOfLightinRaid) then return true end
		end
		if beaconOfLightTANK ~= nil and not cast.last.beaconOfLight() then
			if cast.beaconOfLight(beaconOfLightTANK) then return true end
		end
		if talent.beaconOfFaith then
			if beaconOfFaithTANK ~= nil then
				if cast.beaconOfFaith(beaconOfFaithTANK) then return true end
			end
			if beaconOfFaithplayer ~= nil then
				if cast.beaconOfFaith(beaconOfFaithplayer) then return true end
			end
		end
	end

	actionList.Coolies = function()
		local blessingOfProtectionall = nil
		local blessingOfProtectionTANK = nil
		local blessingOfProtectionHD = nil
		local blessingOfSacrificeall = nil
		local blessingOfSacrificeTANK = nil
		local blessingOfSacrificeDAMAGER = nil
		local layOnHandsTarget = nil

		-- check for bop target / BoS target
		for i = 1, #br.friend do
			if br.friend[i].hp < 100 and br._G.UnitInRange(br.friend[i].unit) and not br.UnitDebuffID(br.friend[i].unit,25771) and not br._G.UnitIsDeadOrGhost(br.friend[i].unit) then
				if br.friend[i].hp <= br.getValue("Blessing of Protection") then
					blessingOfProtectionall = br.friend[i].unit
				end
				if br.friend[i].hp <= br.getValue("Blessing of Protection") and (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
					blessingOfProtectionTANK = br.friend[i].unit
				end
				if br.friend[i].hp <= br.getValue("Blessing of Protection") and (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER") then
					blessingOfProtectionHD = br.friend[i].unit
				end
				if br.friend[i].hp <= br.getValue("Blessing of Sacrifice") and not br.GetUnitIsUnit(br.friend[i].unit, "player") then
					blessingOfSacrificeall = br.friend[i].unit
				end
				if br.friend[i].hp <= br.getValue("Blessing of Sacrifice") and (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
					blessingOfSacrificeTANK = br.friend[i].unit
				end
				if br.friend[i].hp <= br.getValue("Blessing of Sacrifice") and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "DAMAGER" then
					blessingOfSacrificeDAMAGER = br.friend[i].unit
				end
			end
		end

		if br.isChecked("Blessing of Protection") and cd.blessingOfProtection.ready() and not UnitExists("boss1") then
			if br.getOptionValue("BoP Target") == 1 then
				if blessingOfProtectionall ~= nil then
					if cast.blessingOfProtection(blessingOfProtectionall) then return true end
				end
			elseif br.getOptionValue("BoP Target") == 2 then
				if blessingOfProtectionTANK ~= nil then
					if cast.blessingOfProtection(blessingOfProtectionTANK) then return true end
				end
			elseif br.getOptionValue("BoP Target") == 3 then
				if blessingOfProtectionHD ~= nil then
					if cast.blessingOfProtection(blessingOfProtectionHD) then return true end
				end
			elseif br.getOptionValue("BoP Target") == 4 then
				if php <= br.getValue("Blessing of Protection") then
					if cast.blessingOfProtection("player") then return true end
				end
			end
		end

		-- Lay on Hands
		if br.isChecked("Lay on Hands") and br.getSpellCD(633) == 0 then
			for i = 1, #br.friend do
				if br.friend[i].hp < 100 and br._G.UnitInRange(br.friend[i].unit) and not br.UnitDebuffID(br.friend[i].unit,25771) and not br._G.UnitIsDeadOrGhost(br.friend[i].unit) then
					if br.getOptionValue("Lay on Hands Target") == 1 then
						if br.friend[i].hp <= br.getValue("Lay on Hands") then
							layOnHandsTarget = br.friend[i].unit
						end
					elseif br.getOptionValue("Lay on Hands Target") == 2 then
						if br.friend[i].hp <= br.getValue("Lay on Hands") and (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
							layOnHandsTarget = br.friend[i].unit
						end
					elseif br.getOptionValue("Lay on Hands Target") == 3 and php <= br.getValue("Lay on Hands") and not br.UnitDebuffID("player",25771) then
						layOnHandsTarget = "player"
					elseif br.getOptionValue("Lay on Hands Target") == 4 then
						if br.friend[i].hp <= br.getValue("Lay on Hands") and (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br._G.UnitGroupRolesAssigned(lowestUnit) == "DAMAGER") then
							layOnHandsTarget = br.friend[i].unit
						end
					end
					if layOnHandsTarget ~= nil then
						if cast.layOnHands(layOnHandsTarget) then return true end
					end
				end
			end
		end

		-- Blessing of Sacrifice
		if br.isChecked("Blessing of Sacrifice") and cd.blessingOfSacrifice.ready() then
			if br.getOptionValue("BoS Target") == 1 then
				if blessingOfSacrificeall ~= nil then
					if cast.blessingOfSacrifice(blessingOfSacrificeall) then return true end
				end
			elseif br.getOptionValue("BoS Target") == 2 then
				if blessingOfSacrificeTANK ~= nil then
					if cast.blessingOfSacrifice(blessingOfSacrificeTANK) then return true end
				end
			elseif br.getOptionValue("BoS Target") == 3 then
				if blessingOfSacrificeDAMAGER ~= nil then
					if cast.blessingOfSacrifice(blessingOfSacrificeDAMAGER) then return true end
				end
			end
		end

		-- Holy Avenger
		if br.isChecked("Holy Avenger") and cd.holyAvenger.ready() and talent.holyAvenger then
			if br.getLowAllies(br.getValue "Holy Avenger") >= br.getValue("Holy Avenger Targets") then
				if cast.holyAvenger() then return true end
			end
		end
		-- Avenging Wrath
		if br.isChecked("Avenging Wrath") and cd.avengingWrath.ready() then
			if br.getLowAllies(br.getValue "Avenging Wrath") >= br.getValue("Avenging Wrath Targets") then
				if cast.avengingWrath() then return true end
			end
		end

		-- Aura Mastery
		if br.isChecked("Aura Mastery") and cd.auraMastery.ready() then
			if br.getLowAllies(br.getValue "Aura Mastery") >= br.getValue("Aura Mastery Targets") then
				if cast.auraMastery() then return true end
			end
		end
	end
	-- end coolies

	actionList.healingTime = function()
		-- Trinkets
		if br.isChecked("Use Trinkets 1") and br.canUseItem(13) and ((br.getOptionValue("Use Trinkets 1") == 2 and br.useCDs()) or br.getOptionValue("Use Trinkets 1") == 1) then
			if br.getOptionValue("Trinkets 1 Mode") == 1 then
				if br.useItem(13) then return true end
			elseif br.getOptionValue("Trinkets 1 Mode") == 2 then
				if br.useItemGround("target",13,40,0,nil) then return true end
			elseif br.getOptionValue("Trinkets 1 Mode") == 3 and lowest.hp <= br.getOptionValue("Trinkets 1") then
				if br.useItem(13,lowest.unit) then return true end
			elseif br.getOptionValue("Trinkets 1 Mode") == 4 and lowest.hp <= br.getOptionValue("Trinkets 1") and br._G.UnitGroupRolesAssigned(lowest.unit) == "TANK" then
				if br.useItem(13,lowest.unit) then return true end
			elseif br.getOptionValue("Trinkets 1 Mode") == 5 and php <= br.getOptionValue("Trinkets 1") then
				if br.useItem(13,"player") then return true end
			end
		end
		if br.isChecked("Use Trinkets 2") and br.canUseItem(14) and ((br.getOptionValue("Use Trinkets 2") == 2 and br.useCDs()) or br.getOptionValue("Use Trinkets 2") == 1) then
			if br.getOptionValue("Trinkets 2 Mode") == 1 then
				if br.useItem(14) then return true end
			elseif br.getOptionValue("Trinkets 2 Mode") == 2 then
				if br.useItemGround("target",14,40,0,nil) then return true end
			elseif br.getOptionValue("Trinkets 2 Mode") == 3 and lowest.hp <= br.getOptionValue("Trinkets 2") then
				if br.useItem(14,lowest.unit) then return true end
			elseif br.getOptionValue("Trinkets 2 Mode") == 4 and lowest.hp <= br.getOptionValue("Trinkets 2") and br._G.UnitGroupRolesAssigned(lowest.unit) == "TANK" then
				if br.useItem(14,lowest.unit) then return true end
			elseif br.getOptionValue("Trinkets 2 Mode") == 5 and php <= br.getOptionValue("Trinkets 2") then
				if br.useItem(14,"player") then return true end
			end
		end

		if br.isChecked("Rule of Law") and cd.ruleOfLaw.ready() and talent.ruleOfLaw and not buff.ruleOfLaw.exists("player") then
			if br.getLowAllies(br.getValue("Rule of Law")) >= br.getValue("RoL Targets") then
				if cast.ruleOfLaw() then return end
			end
		end

		-- Beacon of Virtue
		if br.isChecked("Beacon of Virtue") and talent.beaconOfVirtue and br.getSpellCD(200025) == 0 then
			if br.getSpellCD(20473) <= gcdMax or holyPower >= 3 or br.getSpellCD(304971) <= gcdMax or buff.divinePurpose.exists() then
				if br.getLowAllies(br.getValue("Beacon of Virtue")) >= br.getValue("BoV Targets") then
					if CastSpellByName(br._G.GetSpellInfo(spell.beaconOfVirtue),lowest.unit) then return true end
				end
			end
		end

		-- Divine Toll
		if br.isChecked("Divine Toll") and br.player.covenant.kyrian.active and cd.divineToll.ready() and (holyPower <= br.getValue("Max Holy Power") or br.getDebuffStacks(lowest.unit,240443) >= 4) then
			if br.getOptionValue("Divine Toll") == 1 and holyPower == 0 then
				if cast.divineToll(lowest.unit) then return true end
			end
			if br.getOptionValue("Divine Toll") == 2 then
				if br.getLowAllies(br.getValue("Divine Toll Health")) >= br.getValue("Divine Toll Units") then
					if cast.divineToll(lowest.unit) then return true end
				end
			end
		end

		-- Light's Hammer
		if br.isChecked("Light's Hammer") and cd.lightsHammer.ready() and talent.lightsHammer and not moving then
			if br.castWiseAoEHeal(br.friend,spell.lightsHammer,10,br.getValue("Light's Hammer"),br.getValue("Light's Hammer Targets"),6,false,true) then return true end
		end

		-- Holy Prism
		if br.isChecked("Holy Prism") and talent.holyPrism and cd.holyPrism.ready() and inCombat then
			for i = 1, #enemies.yards40 do
				local thisUnit = enemies.yards40[i]
				local lowHealthCandidates = br.getUnitsToHealAround(thisUnit,15,br.getValue("Holy Prism"),#br.friend)
				if #lowHealthCandidates >= br.getValue("Holy Prism Targets") and br.getFacing("player",thisUnit) then
					if cast.holyPrism(thisUnit) then return true end
				end
			end
		end

		-- Holy Shock
		if br.isChecked("Holy Shock") and cd.holyShock.ready() then
			if #tanks > 0 then
				if tanks[1].hp <= br.getValue("Critical HP") and br.getLineOfSight("player",tanks[1].unit) and not br._G.UnitIsDeadOrGhost(tanks[1].unit) then
					if cast.holyShock(tanks[1].unit) then return true end
				end
			end
			if php <= br.getValue("Critical HP") then
				if cast.holyShock("player") then return true end
			end
			if lowest.hp <= br.getValue("Holy Shock") then
				if cast.holyShock(lowest.unit) then return true end
			end
		end

		-- BoVing
		if talent.beaconOfVirtue and not moving and cd.flashOfLight.ready() and buff.infusionOfLight.remain() > br.getCastTime(spell.flashOfLight) then
			for i = 1, #br.friend do
				if br.friend[i].hp <= br.getValue("Beacon of Virtue") and buff.beaconOfVirtue.remain(br.friend[i].unit) > br.getCastTime(spell.flashOfLight) then
					if cast.flashOfLight(br.friend[i].unit) then return true end
				end
			end
		end

		-- Judgment of Light
		if talent.judgmentOfLight and cd.judgment.ready() and br.getFacing("player",units.dyn30) and not debuff.judgmentOfLight.exists(units.dyn30) then
			if cast.judgment(units.dyn30) then return true end
		end

		-- Light of the Martyr
		if php >= br.getValue("LotM player HP limit") and cd.lightOfTheMartyr.ready() then
			for i = 1, #br.friend do
				local thisUnit = br.friend[i].unit
				local thisHP = br.friend[i].hp
				if not br.GetUnitIsUnit(thisUnit,"player") and br.getLineOfSight("player",thisUnit) and not br._G.UnitIsDeadOrGhost(thisUnit) then
					if br.isChecked("Moving LotM") and thisHP <= br.getValue("Moving LotM") and moving then
						if cast.lightOfTheMartyr(thisUnit) then return true end
					end
					if br.isChecked("LoM after FoL") and thisHP <= br.getValue("LoM after FoL") and cast.last.flashOfLight() then
						if cast.lightOfTheMartyr(thisUnit) then return true end
					end
					if br.isChecked("Light of the Martyr") and thisHP <= br.getValue("Light of the Martyr") then
						if cast.lightOfTheMartyr(thisUnit) then return true end
					end
				end
			end
		end

		-- Flash of Light
		if not moving and cd.flashOfLight.ready() then
			if br.isChecked("Flash of Light") then
				if php <= br.getValue("Critical HP") then
					if cast.flashOfLight("player") then return true end
				end
				if #tanks > 0 then
					if tanks[1].hp <= br.getValue("Critical HP") and not br._G.UnitIsDeadOrGhost(tanks[1].unit) then
						if cast.flashOfLight(tanks[1].unit) then return true end
					end
				end
				if lowest.hp <= br.getValue("Critical HP") then
					if cast.flashOfLight(lowest.unit) then return true end
				end
				if lowest.hp <= br.getValue("Flash of Light") or (lowest.hp <= br.getValue("FoL Infuse") and buff.infusionOfLight.exists() and not cast.last.flashOfLight()) then
					if cast.flashOfLight(lowest.unit) then return true end
				end
				if #tanks > 0 then
					if tanks[1].hp <= br.getValue("FoL Tanks") and not br._G.UnitIsDeadOrGhost(tanks[1].unit) then
						if cast.flashOfLight(tanks[1].unit) then return true end
					end
				end
			end
			if br.isChecked("FoL Beacon") and lowestBeacon.unit ~= nil and br.isChecked("FoL Beacon") and lowestBeacon.hp <= br.getValue("FoL Beacon") then
				if cast.flashOfLight(lowestBeacon.unit) then return true end
			end
			if br.isChecked("OOC FoL") and not inCombat and lowest.hp <= br.getValue("OOC FoL") then
				if cast.flashOfLight(lowest.unit) then return true end
			end
		end

		-- Holy Light
		if br.isChecked("Holy Light") and not moving and cd.holyLight.ready() then
			if br.getOptionValue("Holy Light Infuse") == 1 or (br.getOptionValue("Holy Light Infuse") == 2 and buff.infusionOfLight.remain() > br.getCastTime(spell.holyLight)) then
				if lowest.hp <= br.getValue("Holy Light") then
					if cast.holyLight(lowest.unit) then return true end
				end
			end
		end

		-- Crusader's Might
		if talent.crusadersMight and cd.crusaderStrike.ready() and br.getFacing("player",units.dyn5) and br.getSpellCD(20473) > gcdMax then
			if cast.crusaderStrike(units.dyn5) then return true end
		end

		if inCombat and inInstance and cd.flashOfLight.ready() and not br.castingUnit() and not moving then
			for i = 1, #br.friend do
				local thisUnit = br.friend[i].unit
				if br.getDebuffRemain(thisUnit,319626) ~= 0 and br.getDebuffRemain(thisUnit,323195) ~= 0 and br.getHP(thisUnit) < 100 and br.getLineOfSight("player",thisUnit) and not br._G.UnitIsDeadOrGhost(thisUnit) then
					if cast.flashOfLight(thisUnit) then return true end
				end
			end
		end

		-- Hammer of Wrath
		if br.getSpellCD(24275) == 0 then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if ccDoubleCheck(thisUnit) and (br.isChecked("Dev Stuff Leave off") or br.getFacing("player",thisUnit)) then
					if br.getHP(thisUnit) <= 20 or buff.avengingWrath.exists() or (br.player.covenant.venthyr.active and cd.ashenHallow.remain() > 210) then
						if cast.hammerOfWrath(thisUnit) then return true end
					end
				end
			end
		end

		-- Shock Barrier and Glimmer Of Light
		if holyPower < 5 and not inCombat and cd.holyShock.ready() then
			for i = 1, #br.friend do
				local thisUnit = br.friend[i].unit
				if (br.getBuffRemain(thisUnit,337824) == 0 and runeforge.shockBarrier.equiped) or (talent.glimmerOfLight and not buff.glimmerOfLight.exists(thisUnit,"exact")) and br.getLineOfSight("player",thisUnit) and not br._G.UnitIsDeadOrGhost(thisUnit) then
					if cast.holyShock(thisUnit) then return true end
				end
			end
			if cast.holyShock("player") then return true end
		end

		-- Grievous Wound
		if not inCombat and inInstance and cd.flashOfLight.ready() and not br.castingUnit() and not moving then
			for i = 1, #br.friend do
				local thisUnit = br.friend[i].unit
				if br.getDebuffRemain(thisUnit,240559) ~= 0 and br.getLineOfSight("player",thisUnit) and not br._G.UnitIsDeadOrGhost(thisUnit) then
					if cast.flashOfLight(thisUnit) then return true end
				end
			end
		end
	end -- end healing

	actionList.mPlusGods = function() -- 99% Feng's massive brain
		for i = 1, #enemies.yards10 do
			local thisUnit = enemies.yards10[i]
			if cd.hammerOfJustice.ready() then
				-- HoJ Prio Units
				if HoJList[br.GetObjectID(thisUnit)] ~= nil then
					if cast.hammerOfJustice(thisUnit) then return true end
				end
				-- Spiteful
				if br.GetObjectID(thisUnit) == 174773 and br.GetUnitIsUnit("player",br._G.UnitTarget(thisUnit)) then
					if cast.hammerOfJustice(thisUnit) then return true end
				end
			end
			-- Special interrupt logic
			if (br._G.UnitCastingInfo(thisUnit) == br._G.GetSpellInfo(332329) and br.getCastTimeRemain(thisUnit) ~=0 and br.getCastTimeRemain(thisUnit) < 2 and br.getBuffRemain(thisUnit,343503) == 0) or br._G.UnitChannelInfo(thisUnit) == br._G.GetSpellInfo(336451) then
				if cd.hammerOfJustice.ready() then
					if cast.hammerOfJustice(thisUnit) then return true end
				end
				if cd.blindingLight.ready() and talent.blindingLight then
					if cast.blindingLight() then return true end
				end
			end
		end
		-- Infectious Rain
		if br._G.UnitChannelInfo("boss1") ~= br._G.GetSpellInfo(331399) and br.getDebuffRemain("player",331399) ~= 0 and cd.cleanse.ready() then
			if cast.cleanse("player") then return true end
		end
		-- Will to
		if race == "Human" and br.getSpellCD(59752) == 0 then
			local STUN_Debuff = {321893,331847,319611,331818}
			for k,v in pairs(STUN_Debuff) do
				if br.getDebuffRemain("player",v) ~= 0 then
					if CastSpellByName(br._G.GetSpellInfo(59752)) then return true end
				end
			end
		end
		-- Divine Protection
		if cd.divineProtection.ready() then 
			-- Castigate
			if br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(322554) and br.GetUnitIsUnit("player",br._G.UnitTarget("boss1")) then
				if cast.divineProtection() then return true end
			end
			-- Rite of Supremacy
			if br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(325360) and br.getCastTimeRemain(thisUnit) ~=0 and br.getCastTimeRemain(thisUnit) < 2 then
				if cast.divineProtection() then return true end
			end
		end
		-- Blessing of Freedom
		if cd.blessingOfFreedom.ready() then
			-- Frozen Binds or Charged Stomp
			if br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(320788) or br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(324608) or br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(319941) then
				if cast.blessingOfFreedom("boss1target") then return true end
			end
			-- Xav the Unfallen logic
			if (br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(317231) or br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(320729)) and br.getDebuffRemain("player",331606) ~= 0 then
				if cast.blessingOfFreedom("player") then return true end
			end
			-- Debuff
			local BoFDebuff = {330810,326827,324608,292942,329326,295929,292910}
			for k,v in pairs(BoFDebuff) do
				if br.getDebuffRemain("player",v) ~= 0 then
					if cast.blessingOfFreedom("player") then return true end
				end
			end
			-- Wretched Phlegm
			if select(8,br._G.GetInstanceInfo()) == 2289 and #tanks > 0 then
				for i = 1, #enemies.yards30 do
					local thisUnit = enemies.yards30[i]
					if br._G.UnitCastingInfo(thisUnit) == br._G.GetSpellInfo(334926) then
						if cast.blessingOfFreedom(tanks[1].unit) then return true end
					end
				end
			end
			-- Rooted in Anima
			if br.GetObjectID("boss1") == 165521 then
				for i = 1, #br.friend do
					if br.getDebuffRemain(br.friend[i].unit,341746) ~= 0 then
						if cast.blessingOfFreedom(br.friend[i].unit) then return true end
					end
				end
			end
		end
	end

	actionList.madParagon = function()
		if runeforge.theMadParagon.equiped and br.getSpellCD(24275) == 0 then
			if (br.getHP("target") <= 20 or br._G.IsSpellOverlayed(24275) or wingsup or (br.player.covenant.venthyr.active and cd.ashenHallow.remain() > 210)) and (br.isChecked("Dev Stuff Leave off") or br.getFacing("player","target")) then
				if cast.hammerOfWrath("target") then return end
			end
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if ccDoubleCheck(thisUnit) and (br.isChecked("Dev Stuff Leave off") or br.getFacing("player",thisUnit)) and lowest.hp >= br.getOptionValue("Critical HP") then
					if br.getHP(thisUnit) <= 20 or br._G.IsSpellOverlayed(24275) or wingsup or (br.player.covenant.venthyr.active and cd.ashenHallow.remain() > 210) then
						if br._G.CastSpellByName(br._G.GetSpellInfo(spell.hammerOfWrath),thisUnit) then return end
					end
				end
			end
		end
	end

	if inCombat then
		if (br.GetObjectID("target") == 165759 or br.GetObjectID("target") == 171577 or br.GetObjectID("target") == 173112) then
			if br.getHP("target") < 100 then
				if not buff.beaconOfLight.exists("target") and br.GetObjectID("target") == 165759 then
					if cast.beaconOfLight("target") then return true end
				end
				if holyPower >= 3 or buff.divinePurpose.exists() then
					SotR = false
					if cast.wordOfGlory("target") then return true end
				end
				if cast.holyShock("target") then return true end
				if br.GetObjectID("target") == 165759 then
					if talent.bestowFaith then
						if cast.bestowFaith("target") then return true end
					end
					if cast.holyLight("target") then return true end
				end
			end
		end
	end

	if br.isChecked("Automatic Aura replacement") and not br.castingUnit() then
		if not inInstance and not inRaid then
			if not buff.devotionAura.exists() and (not br._G.IsMounted() or buff.divineSteed.exists()) and cd.devotionAura.ready() then
				if cast.devotionAura("player") then return true end
			elseif not buff.crusaderAura.exists() and br._G.IsMounted() and cd.crusaderAura.ready() then
				if cast.crusaderAura("player") then return true end
			end
		end
		if (inInstance or inRaid) and not inCombat and not buff.devotionAura.exists() and cd.devotionAura.ready() then
			if cast.devotionAura("player") then return true end
		end
	end

	if br.pause() or eating or br.hasBuff(250873) or br.hasBuff(115834) or br.hasBuff(58984) or br.hasBuff(185710) or br.isCastingSpell(212056) or br.isLooting() or (br._G.IsMounted() and not buff.divineSteed.exists()) then
		return true
	else
		if not inCombat then
			if actionList.bellsAndWhistles() then return true end

			if actionList.defensiveTime() then return true end

			if br.isChecked("OOC Healing") then
				if mode.beacon ~= 4 and not talent.beaconOfVirtue then
					if actionList.Beacon() then return true end
				end

				if br.isChecked("OoC Spenders") then
					if actionList.spendies() then return true end
				end

				if actionList.healingTime() then return true end
			end
		end
		if inCombat then
			if br.isChecked("Hard DPS Key") and (br.SpecificToggle("Hard DPS Key") and not br._G.GetCurrentKeyBoardFocus()) then
				if actionList.damageTime() then return true end
			elseif not br.isChecked("Hard DPS Key") or not (br.SpecificToggle("Hard DPS Key") and not br._G.GetCurrentKeyBoardFocus()) then
				if mode.mythic == 1 then
					if actionList.mPlusGods() then return true end
				end

				if actionList.bellsAndWhistles() then return true end

				if br.useCDs() then
					if actionList.Coolies() then return true end
				end

				if actionList.defensiveTime() then return true end

				if actionList.madParagon() then return true end

				if actionList.spendies() then return true end

				if mode.beacon ~= 4 and not talent.beaconOfVirtue then
					if actionList.Beacon() then return true end
				end

				if actionList.healingTime() then return true end

				if mode.damage == 1 and lowest.hp > br.getValue("Critical HP") then
					if actionList.damageTime() then return true end
				end
			end
		end
	end
end

local id = 65
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
name = rotationName,
toggles = createToggles,
options = createOptions,
run = runRotation,
})

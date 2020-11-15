﻿local rotationName = "Feng"
local StunsBlackList="87318|122984|128455|129553|129552|129602|130400|133935|134174|134158|137474|137478|137486|137487|134251|134331|137484|134739|137969|135231|138489|134144|136214|134150|136249|134417|136353|136295|136297|129369|129373|128969|138255|138465|135245|134991|139422|136076|134691|139110|136250|139946|130485|136139|136643|134012|133430|133463|133436|133482|131436|133912|138281|130025|131677|135329|131812|131670|135365"
local StunSpellList="274400|274383|257756|276292|268273|256897|272542|272888|269266|258317|258864|259711|258917|264038|253239|269931|270084|270482|270506|270507|267433|267354|268702|268846|268865|258908|264574|272659|272655|267237|265568|277567|265540"
local HoJPrioList = "131009|134388|129758"
---------------
--- Toggles ---
---------------
local function createToggles()
	-- Rotation Button
	RotationModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.avengersShield },
	[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.avengersShield },
	[3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.judgment },
	[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.flashOfLight }
	}
	CreateButton("Rotation",1,0)
	-- Cooldown Button
	CooldownModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avengingWrath },
	[2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avengingWrath },
	[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avengingWrath }
	};
	CreateButton("Cooldown",2,0)
	-- Defensive Button
	DefensiveModes = {
	[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.guardianOfAncientKings },
	[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.guardianOfAncientKings }
	};
	CreateButton("Defensive",3,0)
	-- Interrupt Button
	InterruptModes = {
	[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice },
	[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice }
	};
	CreateButton("Interrupt",4,0)
	-- Boss Encounter Case
	BossCaseModes = {
	[1] = { mode = "On", value = 1 , overlay = "BossCase Enabled", tip = "Boss Encounter Case Enabled.", highlight = 1, icon = br.player.spell.shieldOfTheRighteous },
	[2] = { mode = "Off", value = 2 , overlay = "BossCase Disabled", tip = "Boss Encounter Case Disabled.", highlight = 0, icon = br.player.spell.shieldOfTheRighteous }
	};
	CreateButton("BossCase",5,0)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable

	local function rotationOptions()
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
		section = br.ui:createSection(br.ui.window.profile,  "General")
		-- Blessing of Freedom
		br.ui:createCheckbox(section, "Blessing of Freedom")
		-- Auto cancel Blessing of Protection
		br.ui:createCheckbox(section, "Auto cancel BoP")
		-- Auto cancel Divine Shield
		br.ui:createCheckbox(section, "Auto cancel DS")
		-- Automatic Aura replacement
		br.ui:createCheckbox(section, "Automatic Aura replacement")
		-- Taunt
		br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
		br.ui:checkSectionState(section)
		------------------------
		--- COOLDOWN OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
		-- Racial
		br.ui:createCheckbox(section,"Racial")
		-- Trinkets
		br.ui:createSpinner(section, "Trinkets 1",  70,  0,  100,  5,  "Health Percentage to use at")
		br.ui:createDropdownWithout(section,"Trinkets 1 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createSpinner(section, "Trinkets 2",  70,  0,  100,  5,  "Health Percentage to use at")
		br.ui:createDropdownWithout(section,"Trinkets 2 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		-- Seraphim
		br.ui:createSpinner(section, "Seraphim",  0,  0,  20,  2,  "|cffFFFFFFEnemy TTD")
		-- Avenging Wrath
		br.ui:createSpinner(section, "Avenging Wrath",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
		-- Holy Avenger
		br.ui:createSpinner(section, "Holy Avenger",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
		br.ui:createCheckbox(section, "Holy Avenger with Wings")
		br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Healthstone
		br.ui:createSpinner(section, "Pot/Stoned",  30,  0,  100,  5,  "|cffFFFFFFHealth Percentage to use at")
		-- Gift of The Naaru
		if br.player.race == "Draenei" then
			br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percentage to use at")
		end
		if br.player.race == "BloodElf" then
			br.ui:createSpinner (section, "Arcane Torrent Dispel", 1, 0, 20, 1, "","|cffFFFFFFMinimum Torrent Targets")
		end
		-- Ardent Defender
		br.ui:createSpinner(section, "Ardent Defender",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Blinding Light
		br.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percentage to use at")
		-- Cleanse Toxin
		br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target","|cffFF0000Mouseover Target","|cffFFFFFFAny"}, 3, "|ccfFFFFFFTarget to Cast On")
		-- Divine Shield
		br.ui:createSpinner(section, "Divine Shield",  5,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Flash of Light
		br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Guardian of Ancient Kings
		br.ui:createSpinner(section, "Guardian of Ancient Kings",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Hammer of Justice
		br.ui:createSpinner(section, "Hammer of Justice - HP",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Word of Glory
		br.ui:createSpinner(section, "Word of Glory",  60,  0,  100,  5,  "|cffFFBB00Word of Glory to use at.")
		-- Hand of the Protector - on others
		br.ui:createSpinner(section, "Word of Glory - Party",  40,  0,  100,  5,  "|cffFFBB00Teammate Word of Glory to use at.")
		-- Lay On Hands
		br.ui:createSpinner(section, "Lay On Hands", 20, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 8, "|cffFFFFFFTarget for Lay On Hands")
		-- Blessing of Protection
		br.ui:createSpinner(section, "Blessing of Protection", 30, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing of Protection Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 7, "|cffFFFFFFTarget for Blessing of Protection")
		-- Blessing Of Sacrifice
		br.ui:createSpinner(section, "Blessing Of Sacrifice", 40, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing Of Sacrifice Target", {"|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 6, "|cffFFFFFFTarget for Blessing Of Sacrifice")
		-- Shield of the Righteous
		-- br.ui:createSpinner(section, "Shield of the Righteous - HP", 60, 0 , 100, 5, "|cffFFBB00Health Percentage to use at")
		-- Redemption
		br.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
		-- Unstable Temporal Time Shifter
		br.ui:createDropdown(section, "Unstable Temporal Time Shifter", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "","|cffFFFFFFTarget to cast on")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		-- Blinding Light
		br.ui:createCheckbox(section, "Blinding Light - INT")
		-- Hammer of Justice
		br.ui:createCheckbox(section, "Hammer of Justice - INT")
		-- Rebuke
		br.ui:createCheckbox(section, "Rebuke - INT")
		-- Avenger's Shield
		br.ui:createCheckbox(section, "Avenger's Shield - INT")
		-- Interrupt Percentage
		br.ui:createSpinner(section,  "Interrupt At",  40,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		------------------------
		--- ROTATION OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile, "Rotation Options")
		-- Avenger's Shield
		br.ui:createCheckbox(section,"Avenger's Shield")
		-- Consecration
		br.ui:createCheckbox(section,"Consecration")
		-- Blessed Hammer
		br.ui:createCheckbox(section,"Blessed Hammer")
		-- Hammer of the Righteous
		br.ui:createCheckbox(section,"Hammer of the Righteous")
		-- Judgment
		br.ui:createCheckbox(section,"Judgment")
		-- Shield of the Righteous
		br.ui:createCheckbox(section,"Shield of the Righteous")
		-- Hammer of Wrath
		br.ui:createCheckbox(section,"Hammer of Wrath")
		br.ui:checkSectionState(section)
        ----------------------
        -------- LISTS -------
        ----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Lists")
		br.ui:createScrollingEditBoxWithout(section,"Stuns Black Units", StunsBlackList, "List of units to blacklist when Hammer of Justice", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"Stun Spells", StunSpellList, "List of spells to stun with auto stun function", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"HoJ Prio Units", HoJPrioList, "List of units to prioritize for Hammer of Justice", 240, 50)
		br.ui:checkSectionState(section)
		----------------------
		--- TOGGLE OPTIONS ---
		----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
		-- Single/Multi Toggle
		br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  6)
		--Cooldown Key Toggle
		br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  6)
		--Defensive Key Toggle
		br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
		-- Interrupts Key Toggle
		br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
		-- Consecration Key Toggle
		br.ui:createDropdown(section, "Consecration Mode", br.dropOptions.Toggle,  6)
		-- Pause Toggle
		br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
		br.ui:checkSectionState(section)
	end
	optionTable = {{
	[1] = "Rotation Options",
	[2] = rotationOptions,
	}}
	return optionTable
end
----------------
--- ROTATION ---
----------------
local function runRotation()
	-- if br.timer:useTimer("debugProtection", math.random(0.1,0.2)) then
	--Print("Running: "..rotationName)
	---------------
	--- Toggles ---
	---------------
	UpdateToggle("Rotation",0.25)
	UpdateToggle("Cooldown",0.25)
	UpdateToggle("Defensive",0.25)
	UpdateToggle("Interrupt",0.25)
	UpdateToggle("BossCase",0.25)
	br.player.ui.mode.BossCase = br.data.settings[br.selectedSpec].toggles["BossCase"]
	--- FELL FREE TO EDIT ANYTHING BELOW THIS AREA THIS IS JUST HOW I LIKE TO SETUP MY ROTATIONS ---

	--------------
	--- Locals ---
	--------------
	local holyPower     = br.player.power.holyPower.amount()
	local holyPowerMax  = br.player.power.holyPower.max()
	local artifact      = br.player.artifact
	local buff          = br.player.buff
	local cast          = br.player.cast
	local cd            = br.player.cd
	local charges       = br.player.charges
	local combatTime    = getCombatTime()
	local debuff        = br.player.debuff
	local enemies       = br.player.enemies
	local gcd           = br.player.gcd
	local hastar        = GetObjectExists("target")
	local healPot       = getHealthPot()
	local inCombat      = br.player.inCombat
	local level         = br.player.level
	local inInstance    = br.player.instance=="party"
	local inRaid        = br.player.instance=="raid"
	local lowest        = br.friend[1]
	local mode          = br.player.ui.mode
	local php           = br.player.health
	local race          = br.player.race
	local racial        = br.player.getRacial()
	local resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
	local solo          = GetNumGroupMembers() == 0
	local spell         = br.player.spell
	local talent        = br.player.talent
	local ttd           = getTTD("target")
	local units         = br.player.units
	local level         = br.player.level

	units.get(5)
	units.get(10)
	units.get(30)
	enemies.get(5)
	enemies.get(8)
	enemies.get(10)
	enemies.get(30)

	if profileStop == nil then profileStop = false end
	if consecrationCastTime == nil then consecrationCastTime = 0 end
	if consecrationRemain == nil then consecrationRemain = 0 end
	if cast.last.consecration() then consecrationCastTime = GetTime() + 12 end
	if consecrationCastTime > GetTime() then consecrationRemain = consecrationCastTime - GetTime() else consecrationCastTime = 0; consecrationRemain = 0 end
	local lowestUnit = "player"
	for i = 1, #br.friend do
		local thisUnit = br.friend[i].unit
		if UnitInRange(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and UnitIsVisible(thisUnit) and getLineOfSight("player",thisUnit) then
			local thisHP = getHP(thisUnit)
			local lowestHP = getHP(lowestUnit)
			if thisHP < lowestHP then
				lowestUnit = thisUnit
			end
		end
	end
	local noStunsUnits = {}
	for i in string.gmatch(getOptionValue("Stuns Black Units"), "%d+") do
		noStunsUnits[tonumber(i)] = true
	end
	local StunSpellsList = {}
	for i in string.gmatch(getOptionValue("Stun Spells"), "%d+") do
		StunSpellsList[tonumber(i)] = true
	end
	local HoJList = {}
	for i in string.gmatch(getOptionValue("HoJ Prio Units"), "%d+") do
		HoJList[tonumber(i)] = true
	end
	--------------------
	--- Action Lists ---
	--------------------
	-- Action List - Extras
	local function actionList_Extras()
		-- Blessing of Freedom
		if isChecked("Blessing of Freedom") and cast.able.blessingOfFreedom() and hasNoControl(spell.blessingOfFreedom) then
			if cast.blessingOfFreedom("player") then return end
		end
		-- Taunt
		if isChecked("Taunt") and cast.able.handOfReckoning() and inInstance then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
					if cast.handOfReckoning(thisUnit) then return end
				end
			end
		end
		-- Auto cancel Blessing of Protection
		if isChecked("Auto cancel BoP") then
			if buff.blessingOfProtection.exists() and cast.able.handOfReckoning() then
				if cast.handOfReckoning("target") then return end
			end
			if buff.blessingOfProtection.exists() and (getDebuffRemain("target",62124) < 0.2 or getDebuffRemain(br.friend[i].unit,209858) ~= 0) then
				RunMacroText("/cancelAura Blessing of Protection")
			end
		end
		-- Auto cancel Divine Shield
		if isChecked("Auto cancel DS") then
			if buff.divineShield.exists() and cast.able.handOfReckoning() then
				if cast.handOfReckoning("target") then return end
			end
			if buff.divineShield.exists() and (getDebuffRemain("target",62124) < 0.2 or getDebuffRemain(br.friend[i].unit,209858) ~= 0) then
				RunMacroText("/cancelAura Divine Shield")
			end
		end
	end -- End Action List - Extras
	local function BossEncounterCase()
		local hammerOfJusticeCase = nil
		local blessingOfFreedomCase = nil
		local blessingOfProtectionCase = nil
		local cleanseToxinsCase = nil
		local cleanseToxinsCase2 = nil
		for i = 1, #br.friend do
			if UnitIsCharmed(br.friend[i].unit) and getDebuffRemain(br.friend[i].unit,272407) == 0 and getDistance(br.friend[i].unit) <= 10 then
				hammerOfJusticeCase = br.friend[i].unit
			end
			if getDebuffRemain(br.friend[i].unit,264526) ~= 0 or getDebuffRemain(br.friend[i].unit,258058) ~= 0 then
				blessingOfFreedomCase = br.friend[i].unit
			end
			if getDebuffRemain(br.friend[i].unit,255421) ~= 0 or getDebuffRemain(br.friend[i].unit,256038) ~= 0 or getDebuffRemain(br.friend[i].unit,260741) ~= 0 or getDebuffRemain(br.friend[i].unit,258875) ~= 0 then
				blessingOfProtectionCase = br.friend[i].unit
			end
			if (getDebuffRemain(br.friend[i].unit,269686) ~= 0 and UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER") or getDebuffRemain(br.friend[i].unit,257777) ~= 0 or getDebuffRemain(br.friend[i].unit,278961) ~= 0 then
				cleanseToxinsCase = br.friend[i].unit
			end
			if getDebuffRemain(br.friend[i].unit,261440) >= 2 and #getAllies(br.friend[i].unit,7) < 2 then
				cleanseToxinsCase2 = br.friend[i].unit
			end
		end
		-- Automatic catch the pig
		bossHelper()
		-- Avoid indigestion
		if UnitCastingInfo("target") == GetSpellInfo(260793) then
			if not buff.divineSteed.exists() then
				if CastSpellByName(GetSpellInfo(190784),"player") then return end
			end
		end
		-- Flash of Light
		if GetObjectID("target") == 133392 and inCombat then
			if getHP("target") < 100 and getBuffRemain("target",274148) == 0 then
				if CastSpellByName(GetSpellInfo(19750),"target") then return end
			end
		end
		if getDebuffRemain("target",260741) ~= 0 then
			if CastSpellByName(GetSpellInfo(19750),"target") then return end
		end
		-- Hammer of Justice
		if cast.able.hammerOfJustice() then
			for i = 1, #enemies.yards10 do
			local thisUnit = enemies.yards10[i]
				if HoJList[GetObjectID(thisUnit)] ~= nil then
					if cast.hammerOfJustice(thisUnit) then return end
				end
			end
			if hammerOfJusticeCase ~= nil then
				if cast.hammerOfJustice(hammerOfJusticeCase) then return end
			end
		end
		-- Blessing of Freedom
		if cast.able.blessingOfFreedom() then
			if getDebuffRemain("player",267899) ~= 0 or getDebuffRemain("player",268896) ~= 0 or getDebuffRemain("player",257478) ~= 0 then
				if cast.blessingOfFreedom("player") then return end
			end
			if blessingOfFreedomCase ~= nil then
				if cast.blessingOfFreedom(blessingOfFreedomCase) then return end
			end
		end
		-- Blessing of Protection
		if blessingOfProtectionCase ~= nil and not talent.blessingOfSpellwarding and cast.able.blessingOfProtection() then
			if cast.blessingOfProtection(blessingOfProtectionCase) then return end
		end
		-- Cleanse Toxins
		if cast.able.cleanseToxins() then
			if cleanseToxinsCase ~= nil then
				if cast.cleanseToxins(cleanseToxinsCase) then return end
			end
			if cleanseToxinsCase2 ~= nil then
				if cast.cleanseToxins(cleanseToxinsCase2) then return end
			end
		end
		-- Shield of the Righteous
		-- local Debuff={
		-- -- debuff_id
		-- {255434},
		-- {265881},
		-- {264556},
		-- {270487},
		-- {274358},
		-- {270447},
		-- }
		-- for i=1 , #Debuff do
		-- local debuff_id = Debuff[i]
		-- if getDebuffRemain("player",debuff_id) > 1 and not buff.shieldOfTheRighteous.exists() then
		-- if CastSpellByName(GetSpellInfo(53600)) then return end
		-- end
		-- end
		-- local Casting={
		-- -- spell_id	, spell_name
		-- {267899, 'Hindering Cleave'}, -- Shrine of the Storm
		-- {272457, 'Shockwave'}, -- Underrot
		-- {260508, 'Crush'}, -- Waycrest Manor
		-- {249919, 'Skewer'}, -- Atal'Dazar
		-- {265910, 'Tail Thrash'}, -- King's Rest
		-- {268586, 'Blade Combo'}, -- King's Rest
		-- {262277, 'Terrible Thrash'}, -- Fetid Devourer
		-- {265248, 'Shatter'}, -- Zek'voz
		-- {273316, 'Bloody Cleave'}, -- Zul, Reborn
		-- {273282, 'Essence Shear'}, -- Mythrax the Unraveler
		-- }
		-- for i=1 , #Casting do
		-- local spell_id = Casting[i][1]
		-- local spell_name = Casting[i][2]
		-- if UnitCastingInfo("target") == GetSpellInfo(spell_id) and not buff.shieldOfTheRighteous.exists() then
		-- if CastSpellByName(GetSpellInfo(53600)) then Print("damage reduction in advance..."..spell_name) return end
		-- end
		-- end
	end
	-- Action List - Defensives
	local function actionList_Defensive()
		if useDefensive() then
			-- Pot/Stoned
			if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
				and inCombat and (hasHealthPot() or hasItem(5512))then
				if canUseItem(5512) then
					useItem(5512)
				elseif canUseItem(healPot) then
					useItem(healPot)
				end
			end
			-- Divine Shield
			if isChecked("Divine Shield") and cast.able.divineShield() and not buff.ardentDefender.exists() then
				if php <= getOptionValue("Divine Shield") and inCombat then
					if cast.divineShield() then return end
				end
			end
			-- Gift of the Naaru
			if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
				if castSpell("player",racial,false,false,false) then return end
			end
			-- Arcane Torrent
			if isChecked("Arcane Torrent Dispel") and race == "BloodElf" then
				local torrentUnit = 0
				for i=1, #enemies.yards8 do
					local thisUnit = enemies.yards8[i]
					if canDispel(thisUnit, select(7, GetSpellInfo(GetSpellInfo(69179)))) then
						torrentUnit = torrentUnit + 1
						if torrentUnit >= getOptionValue("Arcane Torrent Dispel") then
							if castSpell("player",racial,false,false,false) then return true end
							break
						end
					end
				end
			end
			-- Word of Glory
			if cast.able.wordOfGlory() and (holyPower > 2 or buff.divinePurpose.exists() or buff.shiningLight.exists()) then
				if isChecked("Word of Glory") and getHP("player") <= getOptionValue("Word of Glory") then
					if cast.wordOfGlory("player") then return end
				elseif isChecked("Word of Glory - Party") and getHP(lowestUnit) <= getOptionValue("Word of Glory - Party") then
					if cast.wordOfGlory(lowestUnit) then return end
				end
				if buff.shiningLight.exists() and getBuffRemain("player", 327510) <= 1 then
					if cast.wordOfGlory(lowestUnit) then return end
				end
			end
			-- Lay On Hands
			if isChecked("Lay On Hands") and cast.able.layOnHands() and inCombat then
				-- Player
				if getOptionValue("Lay on Hands Target") == 1 then
					if php <= getValue("Lay On Hands") then
						if cast.layOnHands("player") then return end
					end
					-- Target
				elseif getOptionValue("Lay on Hands Target") == 2 then
					if getHP("target") <= getValue("Lay On Hands") then
						if cast.layOnHands("target") then return end
					end
					-- Mouseover
				elseif getOptionValue("Lay on Hands Target") == 3 then
					if getHP("mouseover") <= getValue("Lay On Hands") then
						if cast.layOnHands("mouseover") then return end
					end
				elseif getHP(lowestUnit) <= getValue("Lay On Hands") and getDebuffRemain(lowestUnit,267037) == 0 and not debuff.forbearance.exists(lowestUnit) then
					-- Tank
					if getOptionValue("Lay on Hands Target") == 4 then
						if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.layOnHands(lowestUnit) then return end
						end
						-- Healer
					elseif getOptionValue("Lay on Hands Target") == 5 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.layOnHands(lowestUnit) then return end
						end
						-- Healer/Tank
					elseif getOptionValue("Lay on Hands Target") == 6 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.layOnHands(lowestUnit) then return end
						end
						-- Healer/Damager
					elseif getOptionValue("Lay on Hands Target") == 7 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.layOnHands(lowestUnit) then return end
						end
						-- Any
					elseif  getOptionValue("Lay on Hands Target") == 8 then
						if cast.layOnHands(lowestUnit) then return end
					end
				end
			end
			-- Blessing of Protection
			if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() and inCombat and not isBoss("boss1") then
				-- Player
				if getOptionValue("Blessing of Protection Target") == 1 then
					if php <= getValue("Blessing of Protection") then
						if cast.blessingOfProtection("player") then return end
					end
					-- Target
				elseif getOptionValue("Blessing of Protection Target") == 2 then
					if getHP("target") <= getValue("Blessing of Protection") then
						if cast.blessingOfProtection("target") then return end
					end
					-- Mouseover
				elseif getOptionValue("Blessing of Protection Target") == 3 then
					if getHP("mouseover") <= getValue("Blessing of Protection") then
						if cast.blessingOfProtection("mouseover") then return end
					end
				elseif getHP(lowestUnit) <= getValue("Blessing of Protection") and not debuff.forbearance.exists(lowestUnit) then
					-- Tank
					if getOptionValue("Blessing of Protection Target") == 4 then
						if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfProtection(lowestUnit) then return end
						end
						-- Healer
					elseif getOptionValue("Blessing of Protection Target") == 5 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.blessingOfProtection(lowestUnit) then return end
						end
						-- Healer/Tank
					elseif getOptionValue("Blessing of Protection Target") == 6 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfProtection(lowestUnit) then return end
						end
						-- Healer/Damager
					elseif getOptionValue("Blessing of Protection Target") == 7 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.blessingOfProtection(lowestUnit) then return end
						end
						-- Any
					elseif  getOptionValue("Blessing of Protection Target") == 8 then
						if cast.blessingOfProtection(lowestUnit) then return end
					end
				end
			end
			-- Blessing Of Sacrifice
			if isChecked("Blessing Of Sacrifice") and cast.able.blessingOfSacrifice() and php >= 50 and inCombat then
				-- Target
				if getOptionValue("Blessing Of Sacrifice Target") == 1 then
					if getHP("target") <= getValue("Blessing Of Sacrifice") then
						if cast.blessingOfSacrifice("target") then return end
					end
					-- Mouseover
				elseif getOptionValue("Blessing Of Sacrifice Target") == 2 then
					if getHP("mouseover") <= getValue("Blessing Of Sacrifice") then
						if cast.blessingOfSacrifice("mouseover") then return end
					end
				elseif getHP(lowestUnit) <= getValue("Blessing Of Sacrifice") and not GetUnitIsUnit(lowestUnit,"player") and getDebuffRemain(lowestUnit,267037) == 0 and not cast.last.blessingOfProtection() then
					-- Tank
					if getOptionValue("Blessing Of Sacrifice Target") == 3 then
						if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfSacrifice(lowestUnit) then return end
						end
						-- Healer
					elseif getOptionValue("Blessing Of Sacrifice Target") == 4 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.blessingOfSacrifice(lowestUnit) then return end
						end
						-- Healer/Tank
					elseif getOptionValue("Blessing Of Sacrifice Target") == 5 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfSacrifice(lowestUnit) then return end
						end
						-- Healer/Damager
					elseif getOptionValue("Blessing Of Sacrifice Target") == 6 then
						if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.blessingOfSacrifice(lowestUnit) then return end
						end
						-- Any
					elseif  getOptionValue("Blessing Of Sacrifice Target") == 7 then
						if cast.blessingOfSacrifice(lowestUnit) then return end
					end
				end
			end
			-- Cleanse Toxins
			if isChecked("Clease Toxin") and cast.able.cleanseToxins() then
				if getOptionValue("Clease Toxin")==1 then
					if canDispel("player",spell.cleanseToxins) and getDebuffRemain("player",261440) == 0 then
						if cast.cleanseToxins("player") then return end
					end
				elseif getOptionValue("Clease Toxin")==2 then
					if canDispel("target",spell.cleanseToxins) then
						if cast.cleanseToxins("target") then return end
					end
				elseif getOptionValue("Clease Toxin")==3 then
					if canDispel("player",spell.cleanseToxins) and getDebuffRemain("player",261440) == 0 then
						if cast.cleanseToxins("player") then return end
					elseif canDispel("target",spell.cleanseToxins) and getDebuffRemain("target",261440) == 0 then
						if cast.cleanseToxins("target") then return end
					end
				elseif getOptionValue("Clease Toxin")==4 then
					if canDispel("mouseover",spell.cleanseToxins) then
						if cast.cleanseToxins("mouseover") then return end
					end
				elseif getOptionValue("Clease Toxin")==5 then
					for i = 1, #br.friend do
						if canDispel(br.friend[i].unit,spell.cleanseToxins) and getDebuffRemain(br.friend[i].unit,261440) == 0 then
							if cast.cleanseToxins(br.friend[i].unit) then return end
						end
					end
				end
			end
			-- Blinding Light
			if isChecked("Blinding Light - HP") and cast.able.blindingLight() and talent.blindingLight and php <= getOptionValue("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
				if cast.blindingLight() then return end
			end
			-- Shield of the Righteous
			-- if isChecked("Shield of the Righteous - HP") and cast.able.shieldOfTheRighteous() then
			-- if php <= getOptionValue("Shield of the Righteous - HP") and inCombat and not buff.shieldOfTheRighteous.exists() then
			-- if cast.shieldOfTheRighteous() then return end
			-- end
			-- end
			-- Guardian of Ancient Kings
			if isChecked("Guardian of Ancient Kings") and cast.able.guardianOfAncientKings() then
				if php <= getOptionValue("Guardian of Ancient Kings") and inCombat and not buff.ardentDefender.exists() and not buff.divineShield.exists() then
					if cast.guardianOfAncientKings() then return end
				end
			end
			-- Ardent Defender
			if isChecked("Ardent Defender") and cast.able.ardentDefender() then
				if (php <= getOptionValue("Ardent Defender") or php <= 10) and inCombat and not buff.guardianOfAncientKings.exists() then
					if cast.ardentDefender() then return end
				end
			end
			-- Gift of the Naaru
			if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and race == "Draenei" then
				if castSpell("player",racial,false,false,false) then return end
			end
			-- Hammer of Justice
			if isChecked("Hammer of Justice - HP") and cast.able.hammerOfJustice() and php <= getOptionValue("Hammer of Justice - HP") and inCombat then
				for i = 1, #enemies.yards10 do
					local thisUnit = enemies.yards10[i]
					if isBoss(thisUnit) and getBuffRemain(thisUnit,226510) == 0 and noStunsUnits[GetObjectID(thisUnit)] == nil then
						if cast.hammerOfJustice(thisUnit) then return end
					end
				end
			end
			-- Flash of Light
			if isChecked("Flash of Light") then
				if (forceHeal or (inCombat and php <= getOptionValue("Flash of Light") / 2) or (not inCombat and php <= getOptionValue("Flash of Light"))) and not isMoving("player") then
					if cast.flashOfLight("player") then return end
				end
			end
			-- Redemption
			if isChecked("Redemption") and not inCombat then
				if getOptionValue("Redemption")==1 and not isMoving("player") and resable then
					if cast.redemption("target","dead") then return end
				end
				if getOptionValue("Redemption")==2 and not isMoving("player") and resable then
					if cast.redemption("mouseover","dead") then return end
				end
			end
			-- Unstable Temporal Time Shifter
			if isChecked("Unstable Temporal Time Shifter") and canUseItem(158379) and not isMoving("player") and inCombat then
				if getOptionValue("Unstable Temporal Time Shifter") == 1
					and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
					UseItemByName(158379,"target")
				end
				if getOptionValue("Unstable Temporal Time Shifter") == 2
					and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
					UseItemByName(158379,"mouseover")
				end
				if getOptionValue("Unstable Temporal Time Shifter") == 3 then
					for i =1, #br.friend do
						if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit,"player") then
							UseItemByName(158379,br.friend[i].unit)
						end
					end
				end
			end
		end
	end -- End Action List - Defensive
	-- Action List - Cooldowns
	local function actionList_Cooldowns()
		if useCDs() or burst then
			-- Trinkets
			if isChecked("Trinkets 1") and canUseItem(13) then
				if getOptionValue("Trinkets 1 Mode") == 1 then
					if php <= getOptionValue("Trinkets 1") then
						useItem(13)
						return true
					end
				elseif getOptionValue("Trinkets 1 Mode") == 2 then
					if useItemGround("target",13,40,0,nil) then return true end
				end
			end
			if isChecked("Trinkets 2") and canUseItem(14) then
				if getOptionValue("Trinkets 2 Mode") == 1 then
					if php <= getOptionValue("Trinkets 2") then
						useItem(14)
						return true
					end
				elseif getOptionValue("Trinkets 2 Mode") == 2 then
					if useItemGround("target",14,40,0,nil) then return true end
				end
			end
			-- Racials
			if isChecked("Racial") then
				if race == "Orc" or race == "Troll" and getSpellCD(racial) == 0 then
					if castSpell("player",racial,false,false,false) then return end
				end
			end
			if GetUnitExists(units.dyn5) then
				-- Seraphim
				if isChecked("Seraphim") and cast.able.seraphim() and talent.seraphim and holyPower > 2 and (getOptionValue("Seraphim") <= ttd ) then
					if cast.seraphim() then return end
				end
				-- Avenging Wrath
				if isChecked("Avenging Wrath") and cast.able.avengingWrath() and (getOptionValue("Avenging Wrath") <= ttd ) then
					if cast.avengingWrath() then return end
				end
				-- Holy Avenger
				if isChecked("Holy Avenger") and cast.able.holyAvenger() and talent.holyAvenger and
				((not isChecked("Holy Avenger with Wings") and getOptionValue("Holy Avenger") <= ttd ) or (isChecked("Holy Avenger with Wings") and getSpellCD(31884) == 0))then
					if cast.holyAvenger() then return end
				end
			end
		end -- End Cooldown Usage Check
	end -- End Action List - Cooldowns
	-- Action List - Interrupts
	local function actionList_Interrupts()
		if useInterrupts() then
			if isChecked("Avenger's Shield - INT") and cast.able.avengersShield() then
				for i = 1, #enemies.yards30 do
					local thisUnit = enemies.yards30[i]
					if canInterrupt(thisUnit,100) and getFacing("player",thisUnit) then
						if cast.avengersShield(thisUnit) then return end
						InterruptTime = GetTime()
					end
				end
			end
			for i = 1, #enemies.yards10 do
				local thisUnit = enemies.yards10[i]
				local distance = getDistance(thisUnit)
				-- Hammer of Justice
				if isChecked("Hammer of Justice - INT") and cast.able.hammerOfJustice() and getBuffRemain(thisUnit,226510) == 0 then
				local interruptID
					if UnitCastingInfo(thisUnit) then
						interruptID = select(9,UnitCastingInfo(thisUnit))
					elseif UnitChannelInfo(thisUnit) then
						interruptID = select(7,GetSpellInfo(UnitChannelInfo(thisUnit)))
					end
					if interruptID ~=nil and StunSpellsList[interruptID] then
						if cast.hammerOfJustice(thisUnit) then return end
					end
				end
				if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
					-- Hammer of Justice
					if isChecked("Hammer of Justice - INT") and cast.able.hammerOfJustice() and not isBoss(thisUnit) and getBuffRemain(thisUnit,226510) == 0 and noStunsUnits[GetObjectID(thisUnit)] == nil then
						if cast.hammerOfJustice(thisUnit) then return end
						InterruptTime = GetTime()
					end
					-- Rebuke
					if isChecked("Rebuke - INT") and cast.able.rebuke() and distance <= 5 and (not InterruptTime or GetTime() - InterruptTime > 0.5) then
						if cast.rebuke(thisUnit) then return end
					end
					-- Blinding Light
					if isChecked("Blinding Light - INT") and cast.able.blindingLight() and talent.blindingLight and not isBoss(thisUnit) and noStunsUnits[GetObjectID(thisUnit)] == nil then
						if cast.blindingLight() then return end
					end
				end
			end
		end
	end -- End Action List - Interrupts
	-- Action List - Opener
	local function actionList_Opener()
		if isValidUnit("target") and getFacing("player","target") then
			if isChecked("Judgment") and getDistance("target") <= 30 and not inCombat and cast.able.judgment() then
				if cast.judgment("target") then return end
			end
			-- Start Attack
			if not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance("target") <= 5 then
				StartAttack()
			end
		end
	end -- End Action List - Opener
	---------------------
	--- Begin Profile ---
	---------------------
	if isChecked("Automatic Aura replacement") then
		if not buff.devotionAura.exists() and (not IsMounted() or buff.divineSteed.exists()) then
			if CastSpellByName(GetSpellInfo(465)) then return end
		elseif not buff.crusaderAura.exists() and IsMounted() then
			if CastSpellByName(GetSpellInfo(32223)) then return end
		end
	end
	--Profile Stop | Pause
	if not inCombat and not hastar and profileStop == true then
		profileStop = false
	elseif (inCombat and profileStop == true) or IsFlying() or pause() or mode.rotation == 4 then
		return true
	else
		-----------------------
		--- Extras Rotation ---
		-----------------------
		if actionList_Extras() then return end
		---------------------------
		--- Boss Encounter Case ---
		---------------------------
		if br.player.ui.mode.BossCase == 1 then
			if BossEncounterCase() then return end
		end
		--------------------------
		--- Defensive Rotation ---
		--------------------------
		if actionList_Defensive() then return end
		----------------------------
		--- Out of Combat Opener ---
		----------------------------
		if actionList_Opener() then return end
		--------------------------
		--- In Combat Rotation ---
		--------------------------
		if inCombat and (not IsMounted() or buff.divineSteed.exists()) and profileStop==false then
			------------------------------
			--- In Combat - Interrupts ---
			------------------------------
			if actionList_Interrupts() then return end
			-----------------------------
			--- In Combat - Cooldowns ---
			-----------------------------
			if actionList_Cooldowns() then return end
			----------------------------------
			--- In Combat - Begin Rotation ---
			----------------------------------
			--------------------------------
			----- In Combat - Feng APL -----
			--------------------------------
			-- Shield of the Righteous
			if isChecked("Shield of the Righteous") and cast.able.shieldOfTheRighteous() and (holyPower > 2 or buff.divinePurpose.exists())
			and ((isChecked("Word of Glory") and getHP("player") > getOptionValue("Word of Glory")) or not isChecked("Word of Glory"))
			and ((isChecked("Word of Glory - Party") and getHP(lowestUnit) > getOptionValue("Word of Glory - Party")) or not isChecked("Word of Glory - Party"))
			and (buff.holyAvenger.remain("player") > gcd or debuff.judgment.exists(units.dyn30) or holyPower == 5) then
				if cast.shieldOfTheRighteous(units.dyn5) then return end
			end
			if GetUnitExists(units.dyn30) and getFacing("player",units.dyn30) then
				-- Avenger's Shield
				if isChecked("Avenger's Shield") and cast.able.avengersShield() and #enemies.yards10 >= 3 then
					if cast.avengersShield(units.dyn30) then return end
				end
				-- Judgment
				if isChecked("Judgment") and cast.able.judgment() and ((talent.crusadersJudgment and charges.judgment.frac() >= 1.99) or not talent.crusadersJudgment or not debuff.judgment.exists(units.dyn30)) then
					if cast.judgment(units.dyn30) then return end
				end
				-- Hammer of Wrath
				if isChecked("Hammer of Wrath") and cast.able.hammerOfWrath() and (getHP(units.dyn30) <= 20 or (level >=58 and buff.avengingWrath.exists()))then
					if cast.hammerOfWrath(units.dyn30) then return end
				end
				-- Avenger's Shield
				if isChecked("Avenger's Shield") and cast.able.avengersShield() then
					if cast.avengersShield(units.dyn30) then return end
				end
			end
			-- Consecration
			if isChecked("Consecration") and cast.able.consecration() and GetUnitExists(units.dyn5) and not buff.consecration.exists() then
				if cast.consecration() then return end
			end
			-- Crusader Strike
			if cast.able.crusaderStrike() and level < 14 and getFacing("player",units.dyn5) and GetUnitExists(units.dyn5) then
				if cast.crusaderStrike(units.dyn5) then return end
			end
			-- Blessed Hammer
			if isChecked("Blessed Hammer") and cast.able.blessedHammer() and talent.blessedHammer and #enemies.yards5 >= 1 then
				if cast.blessedHammer() then return end
			end
			-- Hammer of the Righteous
			if isChecked("Hammer of the Righteous") and cast.able.hammerOfTheRighteous() and not talent.blessedHammer and getFacing("player",units.dyn5) and GetUnitExists(units.dyn5) then
				if cast.hammerOfTheRighteous(units.dyn5) then return end
			end
		end -- End In Combat
	end -- End Profile
	-- end -- Timer
end -- runRotation
local id = 66
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
name = rotationName,
toggles = createToggles,
options = createOptions,
run = runRotation,
})

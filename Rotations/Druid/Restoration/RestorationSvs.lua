﻿local rotationName = "Svs"

---------------
--- Toggles ---
---------------
local function createToggles()
	-- Rotation Button
	RotationModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range", highlight = 1, icon = br.player.spell.wildGrowth },
	[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used", highlight = 1, icon = br.player.spell.wildGrowth },
	[3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used", highlight = 1, icon = br.player.spell.regrowth },
	[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.rejuvenation}
	};
	CreateButton("Rotation",1,0)
	-- Cooldown Button
	CooldownModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 1, icon = br.player.spell.tranquility },
	[2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 0, icon = br.player.spell.tranquility },
	[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.tranquility }
	};
	CreateButton("Cooldown",2,0)
	-- Defensive Button
	DefensiveModes = {
	[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 1, icon = br.player.spell.barkskin },
	[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.barkskin }
	};
	CreateButton("Defensive",3,0)
	-- Decurse Button
	DecurseModes = {
	[1] = { mode = "On", value = 1 , overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.naturesCure },
	[2] = { mode = "Off", value = 2 , overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.naturesCure }
	};
	CreateButton("Decurse",4,0)
	-- Interrupt Button
	InterruptModes = {
	[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mightyBash },
	[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mightyBash }
	};
	CreateButton("Interrupt",5,0)
	-- DPS Button
	DPSModes = {
	[2] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.rake },
	[1] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.regrowth }
	};
	CreateButton("DPS",6,0)
	-- Rejuvenaion Button
	RejuvenaionModes = {
	[2] = { mode = "On", value = 1 , overlay = "Rejuvenaion Enabled", tip = "All players Rejuvenaion Enabled", highlight = 1, icon = br.player.spell.rejuvenation },
	[3] = { mode = "two", value = 2 , overlay = "Double rejuvenaion Enabled", tip = "All players Double rejuvenaion Enabled", highlight = 1, icon = br.player.spell.rejuvenation },
	[1] = { mode = "Off", value = 3 , overlay = "Rejuvenaion Disabled", tip = "All players Rejuvenaion Disabled", highlight = 0, icon = br.player.spell.rejuvenation }
	};
	CreateButton("Rejuvenaion",7,0)
end

--------------
--- COLORS ---
--------------
local colorBlue     = "|cff00CCFF"
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"
local colorGold     = "|cffFFDD11"

---------------
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable
	
	local function rotationOptions()
		local section
		-- General Options
		section = br.ui:createSection(br.ui.window.profile, "General")
		br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.",1)
		-- DBM cast Rejuvenaion
		br.ui:createCheckbox(section,"DBM cast Rejuvenaion","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAccording to BOSS AOE Spells, 5 seconds ahead of schedule cast Rejuvenation|cffFFBB00.")
		-- DOT cast Rejuvenaion
		br.ui:createCheckbox(section,"DOT cast Rejuvenaion","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFDOT damage to teammates cast Rejuvenation|cffFFBB00.")
		-- Pre-Pull Timer
		br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
		-- Travel Shapeshifts
		br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation|cffFFBB00.")
		-- DPS
		br.ui:createSpinnerWithout(section, "DPS", 70, 0, 100, 5, "","|cffFFFFFFMinimum Health to DPS")
		-- DPS Save mana
		br.ui:createSpinnerWithout(section, "DPS Save mana",  40,  0,  100,  5,  "|cffFFFFFFMana Percent no Cast Sunfire and Moonfire")
		-- Overhealing Cancel
		br.ui:createSpinner (section, "Overhealing Cancel", 95, 0, 100, 5, "","|cffFFFFFFSet Desired Threshold at which you want to prevent your own casts")
		-- Affixes Helper
		br.ui:createCheckbox(section,"Affixes Helper","|cff15FF00Please use abundance talent and All players Rejuvenaion Enabled")
		br.ui:checkSectionState(section)
		-- Cooldown Options
		section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
		--  Mana Potion
		br.ui:createSpinner(section, "Mana Potion",  50,  0,  100,  1,  "Mana Percent to Cast At")
		-- Racial
		br.ui:createCheckbox(section,"Racial")
		--The Deceiver's Grand Design
		br.ui:createCheckbox(section, "The Deceiver's Grand Design")
		-- Trinkets
		br.ui:createSpinner(section, "Trinket 1",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets",  4,  1,  40,  1,  "","Minimum Trinket 1 Targets(This includes you)", true)
		br.ui:createSpinner(section, "Trinket 2",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets",  4,  1,  40,  1,  "","Minimum Trinket 2 Targets(This includes you)", true)
		-- Innervate
		br.ui:createSpinner(section, "Innervate",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Innervate Targets",  3,  0,  40,  1,  "","Minimum Innervate Targets", true)
		--Incarnation: Tree of Life
		br.ui:createSpinner(section, "Incarnation: Tree of Life",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Incarnation: Tree of Life Targets",  3,  0,  40,  1,  "","Minimum Incarnation: Tree of Life Targets", true)
		-- Tranquility
		br.ui:createSpinner(section, "Tranquility",  50,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Tranquility Targets",  3,  0,  40,  1,  "","Minimum Tranquility Targets", true)
		br.ui:checkSectionState(section)
		-- Defensive Options
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Rebirth
		br.ui:createCheckbox(section,"Rebirth","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFcast Rebirth|cffFFBB00.",1)
		br.ui:createDropdownWithout(section, "Rebirth - Target", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")
		-- Healthstone
		br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		-- Barkskin
		br.ui:createSpinner(section, "Barkskin",  60,  0,  100,  5,  "|cffFFBB00Health Percent to Cast At.");
		-- Renewal
		br.ui:createSpinner(section, "Renewal",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at");
		br.ui:checkSectionState(section)
		-- Interrupts Options
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		--Mighty Bash
		br.ui:createCheckbox(section, "Mighty Bash")
		-- Interrupt Percentage
		br.ui:createSpinner(section,  "InterruptAt",  95,  0,  95,  5,  "","|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		-- Healing Options
		section = br.ui:createSection(br.ui.window.profile, "Healing")
		-- Efflorescence
		br.ui:createSpinner(section, "Efflorescence",  90,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Efflorescence Targets",  2,  0,  40,  1,  "Minimum Efflorescence Targets")
		br.ui:createSpinnerWithout(section, "Efflorescence recast delay", 20, 8, 30, 1, colorWhite.."Delay to recast Efflo in seconds.")
		br.ui:createDropdown(section,"Efflorescence Key", br.dropOptions.Toggle, 6, "","|cffFFFFFFEfflorescence usage.", true)
		-- Lifebloom
		br.ui:createDropdown(section,"Lifebloom",{"|cffFFFFFFNormal","|cffFFFFFFBoss1 Target"}, 1, "|cffFFFFFFTarget for Lifebloom")
		-- Cenarion Ward
		br.ui:createSpinner(section, "Cenarion Ward",  70,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		-- Ironbark
		br.ui:createSpinner(section, "Ironbark", 30, 0, 100, 5, "","Health Percent to Cast At")
		br.ui:createDropdownWithout(section, "Ironbark Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"}, 7, "|cffFFFFFFcast Ironbark Target")
		-- Swiftmend
		br.ui:createSpinner(section, "Swiftmend", 30, 0, 100, 5, "","Health Percent to Cast At")
		br.ui:createDropdownWithout(section, "Swiftmend Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"}, 7, "|cffFFFFFFcast Swiftmend Target")
		-- Rejuvenaion
		br.ui:createSpinner(section, "Rejuvenation",  90,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Rejuvenation Tank",  90,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At", true)
		br.ui:createSpinnerWithout(section, "Max Rejuvenation Targets",  10,  0,  20,  1,  "","|cffFFFFFFMaximum Rejuvenation Targets")
		-- Germination
		br.ui:createSpinner(section, "Germination",  70,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At", true)
		br.ui:createSpinner(section, "Germination Tank",  80,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At", true)
		-- Regrowth
		br.ui:createSpinner(section, "Regrowth",  80,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Oh Shit! Regrowth",  35,  0,  100,  5,  "","|cffFFFFFFHealth Percent priority Cast At", true)
		-- Regrowth Clearcasting
		br.ui:createSpinner(section, "Regrowth Clearcasting",  80,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At", true)
		-- Regrowth on tank
		br.ui:createCheckbox(section,"Keep Regrowth on tank","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFRegrowth usage|cffFFBB00.")
		-- Healing Touch
		br.ui:createSpinner(section, "Healing Touch",  60,  0,  100,  5,  "","|cffFFFFFFHealth Percent to Cast At")
		-- Cultivation
		br.ui:createCheckbox(section,"Cultivation","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFrejuvenation priority when less than 5 targets are below 60% hp|cffFFBB00.")
		-- Wild Growth
		br.ui:createSpinner(section, "Wild Growth",  80,  0,  100,  5,  "","Health Percent to Cast At")
		br.ui:createSpinner(section, "Wild Growth Targets",  3,  0,  40,  1,  "","Minimum Wild Growth Targets", true)
		-- Essence of G'Hanir
		br.ui:createSpinner(section, "Essence of G'Hanir",  60,  0,  100,  5,  "","Health Percent to Cast At")
		br.ui:createSpinner(section, "Essence of G'Hanir Targets",  3,  0,  40,  1,  "","Minimum Wild Growth Targets", true)
		-- Flourish
		br.ui:createSpinner(section, "Flourish",  60,  0,  100,  5,  "","Health Percent to Cast At")
		br.ui:createSpinner(section, "Flourish Targets",  3,  0,  40,  1,  "","Minimum Flourish Targets", true)
		br.ui:createSpinner(section, "Flourish HOT Targets",  3,  0,  40,  1,  "","Minimum HOT Targets cast Flourish", true)
		br.ui:createSpinner(section, "HOT Time count",  8,  0,  25,  1,  "","HOT Less than how many seconds to count", true)
		br.ui:checkSectionState(section)
		-- Toggle Key Options
		section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
		-- Pause Toggle
		br.ui:createDropdown(section, "Rejuvenaion Mode", br.dropOptions.Toggle,  6)
		br.ui:createDropdown(section, "DPS Mode", br.dropOptions.Toggle,  6)
		br.ui:createDropdown(section, "Decurse Mode", br.dropOptions.Toggle,  6)
		br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
local regrowth_target = nil
local cancel_regrowth = 0
local cancel_wild = 0


local function runRotation()
	if br.timer:useTimer("debugRestoration", 0.1) then
		--print("Running: "..rotationName)
		
		---------------
		--- Toggles --- -- List toggles here in order to update when pressed
		---------------
		UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
		UpdateToggle("Defensive",0.25)
		UpdateToggle("Decurse",0.25)
		UpdateToggle("Interrupt",0.25)
		UpdateToggle("DPS",0.25)
		UpdateToggle("Rejuvenaion",0.25)
		br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]
		br.player.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]
		br.player.mode.rejuvenaion = br.data.settings[br.selectedSpec].toggles["Rejuvenaion"]
		--------------
		--- Locals ---
		--------------
		local clearcast                                     = br.player.buff.clearcasting.exists
		-- local artifact                                      = br.player.artifact
		local buff                                          = br.player.buff
		local cast                                          = br.player.cast
		-- local combatTime                                    = getCombatTime()
		local combo                                         = br.player.power.amount.comboPoints
		-- local cd                                            = br.player.cd
		-- local charges                                       = br.player.charges
		local debuff                                        = br.player.debuff
		local drinking                                      = UnitBuff("player",192002) ~= nil or UnitBuff("player",167152) ~= nil or UnitBuff("player",192001) ~= nil
		local enemies                                       = enemies or {}
		local friends                                       = friends or {}
		local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
		-- local gcd                                           = br.player.gcd
		local healPot                                       = getHealthPot()
		local inCombat                                      = br.player.inCombat
		local inInstance                                    = br.player.instance=="party"
		local inRaid                                        = br.player.instance=="raid"
		local stealthed                                     = UnitBuffID("player",5215) ~= nil
		local lossPercent                                   = getHPLossPercent("player",5)
		local lastSpell                                     = lastSpellCast
		local level                                         = br.player.level
		local lowest                                        = br.friend[1]
		local lowestHP                                      = br.friend[1].unit
		local mana                                          = br.player.power.mana.percent
		local mode                                          = br.player.mode
		-- local perk                                          = br.player.perk
		local php                                           = br.player.health
		local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
		local pullTimer                                     = br.DBM:getPulltimer()
		local race                                          = br.player.race
		local racial                                        = br.player.getRacial()
		-- local recharge                                      = br.player.recharge
		local rejuvCount                                    = 0
		-- local rkTick                                        = 3
		-- local rpTick                                        = 2
		local snapLossHP                                    = 0
		local spell                                         = br.player.spell
		local talent                                        = br.player.talent
		local travel, flight, cat, moonkin, bear, noform    = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.catForm.exists(), br.player.buff.moonkinForm.exists(), br.player.buff.bearForm.exists(), GetShapeshiftForm()==0
		-- local ttm                                           = br.player.power.ttm
		local units                                         = units or {}
		-- local lowestTank                                    = {}    --Tank
		local bloomCount                                    = 0
		-- local tHp                                           = 95
		
		units.dyn5 = br.player.units(5)
		units.dyn8    = br.player.units(8)
		units.dyn40 = br.player.units(40)
		
		enemies.yards5  = br.player.enemies(5)
		enemies.yards8  = br.player.enemies(8)
		enemies.yards40 = br.player.enemies(40)
		friends.yards40 = getAllies("player",40)
		
		if lossPercent > snapLossHP or php > snapLossHP then snapLossHP = lossPercent end
		
		--ChatOverlay("|cff00FF00Abundance stacks: "..buff.abundance.stack().."")
        local function getAllHotCnt(time_remain)
        	hotCnt = 0
        	for i = 1, #br.friend do
        		if buff.lifebloom.exists(br.friend[i].unit) and buff.lifebloom.remain(br.friend[i].unit) <= time_remain then
        			hotCnt=hotCnt+1
        		end
        			
        		if buff.rejuvenation.exists(br.friend[i].unit) and buff.rejuvenation.remain(br.friend[i].unit) <= time_remain then
        			hotCnt=hotCnt+1
        		end
        		
        		if buff.regrowth.exists(br.friend[i].unit) and buff.regrowth.remain(br.friend[i].unit) <= time_remain then
        			hotCnt=hotCnt+1
        		end
        		
        		if buff.rejuvenationGermination.exists(br.friend[i].unit) and buff.rejuvenationGermination.remain(br.friend[i].unit) <= time_remain then
        			hotCnt=hotCnt+1
        		end
        		
        		if buff.wildGrowth.exists(br.friend[i].unit) and buff.wildGrowth.remain(br.friend[i].unit) <= time_remain then
        			hotCnt=hotCnt+1
        		end	
        		
        		if buff.cenarionWard.exists(br.friend[i].unit) and buff.cenarionWard.remain(br.friend[i].unit) <= time_remain then
        			hotCnt=hotCnt+2
        		end	
        		
        		if buff.cultivat.exists(br.friend[i].unit) and buff.cultivat.remain(br.friend[i].unit) <= time_remain then
        			hotCnt=hotCnt+1
        		end	
        	end
        	
        	return hotCnt
        end		
		--------------------
		--- Action Lists ---
		--------------------
		local function overhealingcancel()
			-- StopCasting Wild Growth
			-- if inRaid and isCastingSpell(spell.wildGrowth) and isChecked("Overhealing Cancel") then
				-- if getLowAllies(86) < 4 then
					-- SpellStopCasting()
					-- cancel_wild = cancel_wild + 1
					-- Print("StopCasting Wild Growth "..cancel_wild)
				-- end
			-- end
			-- StopCasting Regrowth
			if isCastingSpell(spell.regrowth) and isChecked("Overhealing Cancel") then
				if regrowth_target ~= nil and regrowth_target.hp > getValue("Overhealing Cancel") then
					SpellStopCasting()
					cancel_regrowth = cancel_regrowth + 1
					Print("StopCasting Regrowth "..cancel_regrowth)
				end
			end
		end
		-- Action List - Extras
		local function actionList_Extras()
			-- Pre-Pull Timer
			if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
				if pullTimer <= getOptionValue("Pre-Pull Timer") then
					if canUse(142117) and not buff.prolongedPower.exists() then
						useItem(142117);
						return true
					end
				end
			end
			-- Shapeshift Form Management
			if ((br.friend[1].hp < getValue("DPS") and not bear) or (talent.balanceAffinity and cat and inCombat)) and not buff.incarnationTreeOfLife.exists() then
				RunMacroText("/CancelForm")
			end
			if isChecked("Auto Shapeshifts") then
				-- Flight Form
				if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and level>=58 then
					RunMacroText("/CancelForm")
					if cast.travelForm("player") then return end
				end
				-- Travel Form
				if not inCombat and swimming and not travel and not hastar and not deadtar and not buff.prowl.exists() then
					RunMacroText("/CancelForm")
					if cast.travelForm("player") then return end
				end
				if not inCombat and moving and not travel and not IsMounted() and not IsIndoors() then
					RunMacroText("/CancelForm")
					if cast.travelForm("player") then return end
				end
				-- Cat Form
				if not cat and not IsMounted() then
					-- Cat Form when not swimming or flying or stag and not in combat
					if not inCombat and moving and not swimming and not flying and not travel and not isValidUnit("target") then
						RunMacroText("/CancelForm")
						if cast.catForm("player") then return end
					end
				end
			end -- End Shapeshift Form Management
			-- Efflorescence
			if (SpecificToggle("Efflorescence Key") and not GetCurrentKeyBoardFocus()) then
				CastSpellByName(GetSpellInfo(spell.efflorescence),"cursor")
				LastEfflorescenceTime = GetTime()
				return
			end
			if isChecked("Efflorescence") and not moving and (not LastEfflorescenceTime or GetTime() - LastEfflorescenceTime > getOptionValue("Efflorescence recast delay")) then
				if getLowAllies(getValue("Efflorescence")) >= getValue("Efflorescence Targets") then
					if castGroundAtBestLocation(spell.efflorescence, 10, 0, 40, 0, "heal") then
						LastEfflorescenceTime = GetTime()
					return true end
				end
			end
		end -- End Action List - Extras
		-- Action List - Pre-Combat
		function actionList_PreCombat()
			-- Swiftmend
			if isChecked("Swiftmend") and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					-- Player
					if getOptionValue("Swiftmend Target") == 1 then
						if php <= getValue("Swiftmend") then
							if cast.swiftmend("player") then return true end
						end
						-- Target
					elseif getOptionValue("Swiftmend Target") == 2 then
						if getHP("target") <= getValue("Swiftmend") then
							if cast.swiftmend("target") then return true end
						end
						-- Mouseover
					elseif getOptionValue("Swiftmend Target") == 3 then
						if getHP("mouseover") <= getValue("Swiftmend") then
							if cast.swiftmend("mouseover") then return true end
						end
					elseif getOptionValue("Swiftmend Target") == 4 then
						-- Tank
						if br.friend[i].hp <= getValue("Swiftmend") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
						-- Healer
					elseif getOptionValue("Swiftmend Target") == 5 then
						if br.friend[i].hp <= getValue("Swiftmend") and UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
						-- Healer/Tank
					elseif getOptionValue("Swiftmend Target") == 6 then
						if br.friend[i].hp <= getValue("Swiftmend") and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
						-- Any
					elseif getOptionValue("Swiftmend Target") == 7 then
						if br.friend[i].hp <= getValue("Swiftmend") then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
					end
				end
			end
			-- Affixes Helper
			if isChecked("Affixes Helper") and talent.abundance and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp >= 80 and br.friend[i].hp <= 90 and buff.abundance.stack() >= 5 and not moving then
						if cast.healingTouch(br.friend[i].unit) then return end
					end
				end
				for i = 1, #br.friend do
					if br.friend[i].hp <= 80 and (not moving or buff.incarnationTreeOfLife.exists()) and buff.abundance.stack() >= 5 then
						if cast.regrowth(br.friend[i].unit) then return end
					end
				end
				for i = 1, #br.friend do
					if br.friend[i].hp <= 90 and talent.germination and not buff.rejuvenationGermination.exists(br.friend[i].unit) and moving then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end
			-- Rejuvenation
			if isChecked("Rejuvenation") and not isCastingSpell(spell.tranquility) then
				rejuvCount = 0
				for i=1, #br.friend do
					if buff.rejuvenation.remain(br.friend[i].unit) > 1 then
						rejuvCount = rejuvCount + 1
					end
				end
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Germination Tank") and talent.germination and (rejuvCount < getValue("Max Rejuvenation Targets")) and not buff.rejuvenationGermination.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.rejuvenation(br.friend[i].unit) then return end
					elseif br.friend[i].hp <= getValue("Germination") and talent.germination and (rejuvCount < getValue("Max Rejuvenation Targets")) and not buff.rejuvenationGermination.exists(br.friend[i].unit) and not UnitIsUnit(br.friend[i].unit,"TANK") then
						if cast.rejuvenation(br.friend[i].unit) then return end
					elseif br.friend[i].hp <= getValue("Rejuvenation Tank") and not buff.rejuvenation.exists(br.friend[i].unit) and (rejuvCount < getValue("Max Rejuvenation Targets")) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.rejuvenation(br.friend[i].unit) then return end
					elseif br.friend[i].hp <= getValue("Rejuvenation") and not buff.rejuvenation.exists(br.friend[i].unit) and (rejuvCount < getValue("Max Rejuvenation Targets")) and not UnitIsUnit(br.friend[i].unit,"TANK") then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end
			-- Regrowth
			if isChecked("Regrowth") and (not moving or buff.incarnationTreeOfLife.exists()) then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > 1.5 and getDebuffStacks(br.friend[i].unit,209858) < 30 then
						if cast.regrowth(br.friend[i].unit) then
							regrowth_target = br.friend[i]
							return
						end
					elseif br.friend[i].hp <= getValue("Regrowth") and buff.regrowth.remain(br.friend[i].unit) <= 1 and getDebuffStacks(br.friend[i].unit,209858) < 30 then
						if cast.regrowth(br.friend[i].unit) then
							regrowth_target = br.friend[i]
							return
						end
					end
				end
			end
		end  -- End Action List - Pre-Combat
		local function actionList_Defensive()
			if useDefensive() then
				-- Rebirth
				if isChecked("Rebirth") then
					if getOptionValue("Rebirth - Target") == 1
						and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
						then
						if cast.rebirth("target","dead") then return end
					end
					if getOptionValue("Rebirth - Target") == 2
						and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
						then
						if cast.rebirth("mouseover","dead") then return end
					end
					if getOptionValue("Rebirth - Target") == 3 then
						for i =1, #br.friend do
							if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsFriend(br.friend[i].unit,"player") then
								if cast.rebirth(br.friend[i].unit,"dead") then return end
							end
						end
					end
				end
				-- Healthstone
				if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and not isCastingSpell(spell.tranquility)
					and inCombat and (hasHealthPot() or hasItem(5512)) then
					if canUse(5512) then
						useItem(5512)
					elseif canUse(healPot) then
						useItem(healPot)
					end
				end
				-- Barkskin
				if isChecked("Barkskin") and not isCastingSpell(spell.tranquility) then
					if php <= getOptionValue("Barkskin") and inCombat then
						if cast.barkskin() then return end
					end
				end
				-- Renewal
				if isChecked("Renewal") and talent.renewal and not isCastingSpell(spell.tranquility) then
					if php <= getOptionValue("Renewal") and inCombat then
						if cast.renewal() then return end
					end
				end
			end -- End Defensive Toggle
		end -- End Action List - Defensive
		-- Interrupt
		local function actionList_Interrupts()
			if useInterrupts() then
				for i = 1, #enemies.yards5 do
					local thisUnit = enemies.yards5[i]
					local distance = getDistance(thisUnit)
					if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
						if isChecked("Mighty Bash") and talent.mightyBash and distance < 5 then
							if cast.mightyBash(thisUnit) then return end
						end
					end
				end
			end
		end
		function actionList_Cooldowns()
			if useCDs() then
				-- Incarnation: Tree of Life
				if isChecked("Incarnation: Tree of Life") and talent.incarnationTreeOfLife and not buff.incarnationTreeOfLife.exists() and not isCastingSpell(spell.tranquility) then
					if getLowAllies(getValue("Incarnation: Tree of Life")) >= getValue("Incarnation: Tree of Life Targets") then
						if cast.incarnationTreeOfLife() then return end
					end
				end
				-- Tranquility
				if isChecked("Tranquility") and not isCastingSpell(spell.tranquility) and not buff.incarnationTreeOfLife.exists() then
					if getLowAllies(getValue("Tranquility")) >= getValue("Tranquility Targets") then
						if cast.tranquility() then return end
					end
				end
				-- Innervate
				if isChecked("Innervate") and not isCastingSpell(spell.tranquility) and mana ~= nil then
					if getLowAllies(getValue("Innervate")) >= getValue("Innervate Targets") and mana < 80 then
						if cast.innervate("player") then return end
					end
				end
				-- The Deceiver's Grand Design
				if isChecked("The Deceiver's Grand Design") then
					for i = 1, #br.friend do
						if hasEquiped(147007) and canUse(147007) and getBuffRemain(br.friend[i].unit,242622) == 0 and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and UnitInRange(br.friend[i].unit) then
							UseItemByName(147007,br.friend[i].unit)
						end
					end
				end
				-- Trinkets
				if isChecked("Trinket 1") and getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") and not isCastingSpell(spell.tranquility) then
					if canUse(13) then
						useItem(13)
						return true
					end
				end
				if isChecked("Trinket 2") and getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") and not isCastingSpell(spell.tranquility) then
					if canUse(14) then
						useItem(14)
						return true
					end
				end
				-- Mana Potion
				if isChecked("Mana Potion") and mana <= getValue("Mana Potion")then
					if hasItem(127835) then
						useItem(127835)
						return true
					end
				end
				-- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
				if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") and not isCastingSpell(spell.tranquility) then
					if castSpell("player",racial,false,false,false) then return end
				end
			end -- End useCooldowns check
		end -- End Action List - Cooldowns
		-- AOE Healing
		function actionList_AOEHealing()
			-- Cultivation
			if isChecked("Cultivation") and inRaid and talent.germination and talent.cultivation then
				for i=1, #br.friend do
					if getLowAllies(60) < 5 and br.friend[i].hp < 60 and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end
			-- Wild Growth
			for i=1, #br.friend do
				if isChecked("Wild Growth") and not moving and not buff.wildGrowth.exists(br.friend[i].unit) and not isCastingSpell(spell.tranquility) then
					local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit,30,getValue("Wild Growth"),#br.friend)
					if #lowHealthCandidates >= getValue("Wild Growth Targets") then
					    if talent.soulOfTheForest and not buff.soulOfTheForest.exists() and getBuffRemain("player",242315) == 0 then
						    if cast.swiftmend(lowestHP) then return true end
						end	
						if cast.wildGrowth(br.friend[i].unit) then return end
					end
				end
			end
			-- Power of the Archdruid
			if buff.powerOfTheArchdruid.exists() then
				if cast.rejuvenation(lowestHP) then return end
			end
			-- Essence of G'Hanir
			if isChecked("Essence of G'Hanir") and not isCastingSpell(spell.tranquility) then
				if getLowAllies(getValue("Essence of G'Hanir")) >= getValue("Essence of G'Hanir Targets") and (lastSpell == spell.wildGrowth or lastSpell == spell.flourish) then
					if cast.essenceOfGhanir() then return end
				end
			end
			-- Flourish
			if isChecked("Flourish") and talent.flourish and not isCastingSpell(spell.tranquility) then
				if getLowAllies(getValue("Flourish")) >= getValue("Flourish Targets") then
					local c = getAllHotCnt(getValue("HOT Time count"))
					if c>= getValue("Flourish HOT Targets") then
						if cast.flourish() then
							Print("Flourish HOT cnt="..c)
							return 
						end
					end
				end
			end
		end	
		-- Single Target
		function actionList_SingleTarget()
			-- Nature's Cure
			if br.player.mode.decurse == 1 then
				for i = 1, #friends.yards40 do
					if canDispel(br.friend[i].unit,spell.naturesCure) then
						if cast.naturesCure(br.friend[i].unit) then return end
					end
				end
			end
			-- Ironbark
			if isChecked("Ironbark") and not isCastingSpell(spell.tranquility) then
				-- Player
				if getOptionValue("Ironbark Target") == 1 then
					if php <= getValue("Ironbark") then
						if cast.ironbark("player") then return true end
					end
					-- Target
				elseif getOptionValue("Ironbark Target") == 2 then
					if getHP("target") <= getValue("Ironbark") then
						if cast.ironbark("target") then return true end
					end
					-- Mouseover
				elseif getOptionValue("Ironbark Target") == 3 then
					if getHP("mouseover") <= getValue("Ironbark") then
						if cast.ironbark("mouseover") then return true end
					end
				elseif lowest.hp <= getValue("Ironbark") then
					-- Tank
					if getOptionValue("Ironbark Target") == 4 then
						if (lowest.role) == "TANK" then
							if cast.ironbark(lowest.unit) then return true end
						end
						-- Healer
					elseif getOptionValue("Ironbark Target") == 5 then
						if (lowest.role) == "HEALER" then
							if cast.ironbark(lowest.unit) then return true end
						end
						-- Healer/Tank
					elseif getOptionValue("Ironbark Target") == 6 then
						if (lowest.role) == "HEALER" or (lowest.role) == "TANK" then
							if cast.ironbark(lowest.unit) then return true end
						end
						-- Any
					elseif  getOptionValue("Ironbark Target") == 7 then
						if cast.ironbark(lowest.unit) then return true end
					end
				end
			end
			-- Swiftmend
			if isChecked("Swiftmend") and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					-- Player
					if getOptionValue("Swiftmend Target") == 1 then
						if php <= getValue("Swiftmend") then
							if cast.swiftmend("player") then return true end
						end
						-- Target
					elseif getOptionValue("Swiftmend Target") == 2 then
						if getHP("target") <= getValue("Swiftmend") then
							if cast.swiftmend("target") then return true end
						end
						-- Mouseover
					elseif getOptionValue("Swiftmend Target") == 3 then
						if getHP("mouseover") <= getValue("Swiftmend") then
							if cast.swiftmend("mouseover") then return true end
						end
					elseif getOptionValue("Swiftmend Target") == 4 then
						-- Tank
						if br.friend[i].hp <= getValue("Swiftmend") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
						-- Healer
					elseif getOptionValue("Swiftmend Target") == 5 then
						if br.friend[i].hp <= getValue("Swiftmend") and UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
						-- Healer/Tank
					elseif getOptionValue("Swiftmend Target") == 6 then
						if br.friend[i].hp <= getValue("Swiftmend") and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
						-- Any
					elseif getOptionValue("Swiftmend Target") == 7 then
						if br.friend[i].hp <= getValue("Swiftmend") then
							if cast.swiftmend(br.friend[i].unit) then return true end
						end
					end
				end
			end
			-- Lifebloom
			if isChecked("Lifebloom") and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp <= 70 and buff.lifebloom.remain(br.friend[i].unit) < 5 and buff.lifebloom.remain(br.friend[i].unit) > 0 and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and UnitInRange(br.friend[i].unit) then
						if cast.lifebloom(br.friend[i].unit) then return end
					end
				end
			end
			-- Affixes Helper
			if isChecked("Affixes Helper") and talent.abundance and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp >= 80 and br.friend[i].hp <= 90 and buff.abundance.stack() >= 5 and not moving then
						if cast.healingTouch(br.friend[i].unit) then return end
					end
				end
				for i = 1, #br.friend do
					if br.friend[i].hp <= 80 and (not moving or buff.incarnationTreeOfLife.exists()) and buff.abundance.stack() >= 5 then
						if cast.regrowth(br.friend[i].unit) then return end
					end
				end
				for i = 1, #br.friend do
					if br.friend[i].hp <= 90 and talent.germination and not buff.rejuvenationGermination.exists(br.friend[i].unit) and moving then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end
			-- Oh Shit! Regrowth
			if isChecked("Regrowth") and (not moving or buff.incarnationTreeOfLife.exists()) and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Oh Shit! Regrowth") and getDebuffStacks(br.friend[i].unit,209858) < 30 then
						if cast.regrowth(br.friend[i].unit) then
							regrowth_target = br.friend[i]
							return
						end
					end
				end
			end
			-- Lifebloom
			if isChecked("Lifebloom") and not isCastingSpell(spell.tranquility) then
				if inInstance then
					for i = 1, #br.friend do
						if not buff.lifebloom.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
							if cast.lifebloom(br.friend[i].unit) then return end
						end
					end
				else
					if inRaid then
						bloomCount = 0
						for i=1, #br.friend do
							if buff.lifebloom.exists(br.friend[i].unit) then
								bloomCount = bloomCount + 1
							end
						end
						for i = 1, #br.friend do
							if bloomCount < 1 and not buff.lifebloom.exists(br.friend[i].unit) and UnitInRange(br.friend[i].unit) and ((getOptionValue("Lifebloom") == 1 and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") or (getOptionValue("Lifebloom") == 2 and UnitIsUnit(br.friend[i].unit,"boss1target"))) then
								if cast.lifebloom(br.friend[i].unit) then return end
							end
						end
					end
				end
			end
			-- Cenarion Ward
			if isChecked("Cenarion Ward") and talent.cenarionWard and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Cenarion Ward") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and not buff.cenarionWard.exists(br.friend[i].unit) then
						if cast.cenarionWard(br.friend[i].unit) then return end
					end
				end
			end
			-- Regrowth
			if isChecked("Regrowth") and (not moving or buff.incarnationTreeOfLife.exists()) and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > 1.5 and getDebuffStacks(br.friend[i].unit,209858) < 30 then
						if cast.regrowth(br.friend[i].unit) then
							regrowth_target = br.friend[i]
							return
						end
					elseif br.friend[i].hp <= getValue("Regrowth") and buff.regrowth.remain(br.friend[i].unit) <= 1 and getDebuffStacks(br.friend[i].unit,209858) < 30 then
						if cast.regrowth(br.friend[i].unit) then
							regrowth_target = br.friend[i]
							return
						end
					elseif isChecked("Keep Regrowth on tank") and buff.lifebloom.exists(br.friend[i].unit) and buff.regrowth.remain(br.friend[i].unit) <= 1 and getDebuffStacks(br.friend[i].unit,209858) < 30 then
						if cast.regrowth(br.friend[i].unit) then return end
					end
				end
			end
			-- Healing Touch with abundance stacks >= 5
			if isChecked("Healing Touch") and not moving and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Healing Touch") and talent.abundance and buff.abundance.stack() >= 5 and getDebuffStacks(br.friend[i].unit,209858) < 30 then
						if cast.healingTouch(br.friend[i].unit) then return end
					end
				end
			end
			-- Cultivation
			if talent.cultivation and inRaid then
				for i=1, #br.friend do
					if br.friend[i].hp < 60 and not buff.rejuvenation.exists(br.friend[i].unit) then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end			
			-- DOT damage to teammates cast Rejuvenation
			if isChecked("DOT cast Rejuvenaion") then
				local debuff_list={
				200620, --  Darkheart Thicket
				196376, --  Archdruid Glaidalis
				199345, --  Dresaron
				197546, --  Illysanna Ravencrest
				211464, --  Court of Stars
				192131, --  Warlord Parjesh
				196111, --  Eye of Azshara
				227325, --  Opera Hall
				227848, --  Maiden of Virtue
				227742, --  Moroes
				227502, --  Mana Devourer
				229159, --  Viz'aduum
				185539, --  Helya
				228253, --  Guarm
				204531, --  Skorpyron
				206607, --  Chronomatic Anomaly
				219966, --  Chronomatic Anomaly
				219965, --  Chronomatic Anomaly
				206798, --  Trilliax
				213166, --  Spellblade Aluriel
				212587, --  Spellblade Aluriel
				206936, --  Star Augur Etraeus
				205649, --  Star Augur Etraeus
				206464, --  Star Augur Etraeus
				214486,--   Star Augur Etraeus
				206480, --  Tichondrius
				219235, --  High Botanist Tel'arn
				218809, --  High Botanist Tel'arn
				206677, --  Krosus
				209615, --  Elisande
				211258, --  Elisande
				206222, --  Gul'dan
				206221, --  Gul'dan
				212568, --  Gul'dan
				233062, --  Goroth
				230345, --  Goroth
				231363, --  Goroth
				233983, --  Demonic Inquisition
				231998, --  Harjatan
				231770, --  Harjatan
				232913, --  Mistress Sassz'ine
				236519, --  Sisters of the Moon
				239264, --  Sisters of the Moon
				236449, --  The Desolate Host
				236515, --  The Desolate Host
				235117, --  Maiden of Vigilance
				242017, --  Fallen Avatar
				240908, --  Kil'jaeden
				234310, --  Kil'jaeden
				241822, --  Kil'jaeden
				239155, --  Kil'jaeden
				}
				for i=1, #br.friend do
					for k,v in pairs(debuff_list) do
						if getDebuffRemain(br.friend[i].unit,v) > 5.0 and not buff.rejuvenation.exists(br.friend[i].unit) and not isCastingSpell(spell.tranquility) and UnitInRange(br.friend[i].unit) then
							if cast.rejuvenation(br.friend[i].unit) then return end
						end
					end
				end
				if talent.germination then
					local debuff2_list={
					200620, --  Darkheart Thicket
					196376, --  Archdruid Glaidalis
					199345, --  Dresaron
					197546, --  Illysanna Ravencrest
					211464, --  Court of Stars
					192131, --  Warlord Parjesh
					227848, --  Maiden of Virtue
					227502, --  Mana Devourer
					229159, --  Viz'aduum
					185539, --  Helya
					}
					for i=1, #br.friend do
						for k,v in pairs(debuff2_list) do
							if getDebuffRemain(br.friend[i].unit,v) > 5.0 and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
								if cast.rejuvenation(br.friend[i].unit) then return end
							end
						end
					end
				end
			end
			-- Rejuvenation
			if isChecked("Rejuvenation") and not isCastingSpell(spell.tranquility) then
				rejuvCount = 0
				for i=1, #br.friend do
					if buff.rejuvenation.remain(br.friend[i].unit) > 1 then
						rejuvCount = rejuvCount + 1
					end
				end
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Germination Tank") and talent.germination and (rejuvCount < getValue("Max Rejuvenation Targets")) and not buff.rejuvenationGermination.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.rejuvenation(br.friend[i].unit) then return end
					elseif br.friend[i].hp <= getValue("Germination") and talent.germination and (rejuvCount < getValue("Max Rejuvenation Targets")) and not buff.rejuvenationGermination.exists(br.friend[i].unit) and not UnitIsUnit(br.friend[i].unit,"TANK") then
						if cast.rejuvenation(br.friend[i].unit) then return end
					elseif br.friend[i].hp <= getValue("Rejuvenation Tank") and not buff.rejuvenation.exists(br.friend[i].unit) and (rejuvCount < getValue("Max Rejuvenation Targets")) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.rejuvenation(br.friend[i].unit) then return end
					elseif br.friend[i].hp <= getValue("Rejuvenation") and not buff.rejuvenation.exists(br.friend[i].unit) and (rejuvCount < getValue("Max Rejuvenation Targets")) and not UnitIsUnit(br.friend[i].unit,"TANK") then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end
			-- Healing Touch
			if isChecked("Healing Touch") and not moving and not isCastingSpell(spell.tranquility) then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Healing Touch") and getDebuffStacks(br.friend[i].unit,209858) < 25 then
						if cast.healingTouch(br.friend[i].unit) then return end
					end
				end
			end			
			--DBM cast Rejuvenaion
			if isChecked("DBM cast Rejuvenaion") then
				local precast_spell_list={
				--spell_id	, precast_time	,	spell_name
				{214652 	, 5				,	'Acidic Fragments'},
				{205862 	, 5				,	'Slam'},
				{218774 	, 5				,	'Summon Plasma Spheres'},
				{206949 	, 5				,	'Frigid Nova'},
				{206517 	, 5				,	'Fel Nova'},
				{207720 	, 5				,	'Witness the Void'},
				{206219 	, 5				,	'Liquid Hellfire'},
				{211439 	, 5				,	'Will of the Demon Within'},
				{209270 	, 5				,	'Eye of Guldan'},
				{227071 	, 5				,	'Flame Crash'},
				{233279 	, 5				,	'Shattering Star'},
				{233441 	, 5				,	'Bone Saw'},
				{235230 	, 5				,	'Fel Squall'},
				{231854 	, 5				,	'Unchecked Rage'},
				{232174 	, 5				,	'Frosty Discharge'},
				{230139 	, 5				,	'Hydra Shot'},
				{233264 	, 5				,	'Embrace of the Eclipse'},
				{236542 	, 5				,	'Sundering Doom'},
				{236544 	, 5				,	'Doomed Sundering'},
				{235059 	, 5				,	'Rupturing Singularity'},
				}
				for i=1 , #precast_spell_list do
					local boss_spell_id = precast_spell_list[i][1]
					local precast_time = precast_spell_list[i][2]
					local spell_name = precast_spell_list[i][3]
					local time_remain = br.DBM:getPulltimer_fix(nil,boss_spell_id)
					if time_remain < precast_time then
						for j = 1, #br.friend do
							if not buff.rejuvenation.exists(br.friend[j].unit) and not isCastingSpell(spell.tranquility) and UnitInRange(br.friend[j].unit) then
								if cast.rejuvenation(br.friend[j].unit) then
									Print("DBM cast Rejuvenaion--"..spell_name)
									return
								end
							end
						end
					end
				end
			end	
		if isChecked("DBM cast Rejuvenaion") then
    		        local Casting={
    			--spell_id	, spell_name	
    			{196587 	, 'Soul Burst'}, --Amalgam of Souls
    			{211464 	, 'Fel Detonation'}, --Advisor Melandrus
    			{237276 	, 'Pulverizing Cudgel'}, --Thrashbite the Scornful
    			{193611 	, 'Focused Lightning'}, --Lady Hatecoil
    			{192305 	, 'Eye of the Storm'}, --Hyrja
    			{239132 	, 'Rupture Realities'}, --Fallen Avatar
    			}
    			for i=1 , #Casting do
    			local spell_id = Casting[i][1]
    			local spell_name = Casting[i][2]
				    for j = 1, #br.friend do
        			    if UnitCastingInfo("boss1") == GetSpellInfo(spell_id) and not buff.rejuvenation.exists(br.friend[j].unit) and not isCastingSpell(spell.tranquility) and UnitInRange(br.friend[j].unit) then
        				    if cast.rejuvenation(br.friend[j].unit) then Print("DBM cast Rejuvenaion--"..spell_name) return end
        				end
        			end	
        		end	
		end	
			-- Ephemeral Paradox trinket
			if hasEquiped(140805) and getBuffRemain("player", 225766) > 2 and getDebuffStacks(lowestHP,209858) < 30 then
				if cast.healingTouch(lowestHP) then return end
			end
			-- Not wasted Innervate
			if buff.innervate.remain() >= 1 and not isCastingSpell(spell.tranquility) then
				for i=1, #br.friend do
					if not buff.rejuvenation.exists(br.friend[i].unit) then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end
			-- Mana hundred percent cast rejuvenation
			for i = 1, #br.friend do
				if not travel and inCombat and mana >= 99 and not buff.rejuvenation.exists(br.friend[i].unit) and inRaid and not isCastingSpell(spell.tranquility) then
					if cast.rejuvenation(br.friend[i].unit) then return end
				end
			end
		end
		-- All players Rejuvenaion
		local function actionList_Rejuvenaion()
			if mode.rejuvenaion == 2 then
				for i = 1, #br.friend do
					if not buff.rejuvenation.exists(br.friend[i].unit) and not isCastingSpell(spell.tranquility) then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			elseif mode.rejuvenaion == 3 then
				for i = 1, #br.friend do
					if talent.germination and not isCastingSpell(spell.tranquility) and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
						if cast.rejuvenation(br.friend[i].unit) then return end
					end
				end
			end
		end
		-- Action List - DPS
		local function actionList_DPS()
			-- Guardian Affinity/Level < 45
			if talent.guardianAffinity or level < 45 then
				if bear then
					if br.player.power.amount.rage >= 60 then
						if cast.ironfur() then return end
					end
					if cast.mangle(units.dyn5) then return end
					if #enemies.yards8 >= 1 then
						if cast.thrash(units.dyn8) then return end
					end
					if (snapLossHP >= 20 or (snapLossHP > php and snapLossHP > 5)) and not buff.frenziedRegeneration.exists() then
						if cast.frenziedRegeneration() then snapLossHP = 0; return end
					end
				end
				-- Sunfire
				if not bear and not debuff.sunfire.exists(units.dyn40) and mana >= getOptionValue("DPS Save mana") then
					if cast.sunfire(units.dyn40) then return end
				end
				-- Moonfire
				if not debuff.moonfire.exists(units.dyn40) and mana >= getOptionValue("DPS Save mana") then
					if cast.moonfire(units.dyn40) then return end
				end
				-- Solar Wrath
				if not moving and not bear then
					if cast.solarWrath(units.dyn40) then return end
				end
			end
			-- Feral Affinity
			if talent.feralAffinity then
				-- Moonfire
				if #enemies.yards8 < 4 and not debuff.moonfire.exists(units.dyn40) and mana >= getOptionValue("DPS Save mana") then
					RunMacroText("/CancelForm")
					if cast.moonfire(units.dyn40) then return end
				end
				-- Sunfire
				if not debuff.sunfire.exists(units.dyn40) and mana >= getOptionValue("DPS Save mana") then
					RunMacroText("/CancelForm")
					if cast.sunfire(units.dyn40) then return end
				end
				-- Cat form
				if not cat and getDistance(units.dyn8) < 8 then
					if cast.catForm("player") then return end
				end
				-- Swipe
				if (#enemies.yards8 > 1 and #enemies.yards8 < 4 and debuff.rake.exists(units.dyn8)) or #enemies.yards8 >= 4 then
					if cast.swipe() then return end
				end
				-- Rip
				if combo == 5 and #enemies.yards8 < 4 then
					for i = 1, #enemies.yards5 do
						local thisUnit = enemies.yards5[i]
						if getDistance(thisUnit) < 5 then
							if not debuff.rip.exists(thisUnit) or debuff.rip.remain(thisUnit) < 4 then
								if cast.rip(thisUnit) then return end
							end
						end
					end
				end
				-- Rake
				if combo < 5 and #enemies.yards8 < 4 then
					for i = 1, #enemies.yards5 do
						local thisUnit = enemies.yards5[i]
						if getDistance(thisUnit) < 5 then
							if not debuff.rake.exists(thisUnit) then
								if cast.rake(thisUnit) then return end
							end
						end
					end
				end
				-- Ferocious Bite
				if combo == 5 and #enemies.yards8 < 4 then
					for i = 1, #enemies.yards5 do
						local thisUnit = enemies.yards5[i]
						if getDistance(thisUnit) < 5 and debuff.rip.exists(thisUnit) then
							if cast.ferociousBite(thisUnit) then return end
						end
					end
				end
				-- Shred
				if combo < 5 and debuff.rake.exists(units.dyn5) and #enemies.yards8 < 2 then
					if cast.shred(units.dyn5) then return end
				end
			end -- End - Feral Affinity
			-- Balance Affinity
			if talent.balanceAffinity then
				-- Moonkin form
				if not moonkin and not moving and not travel and not IsMounted() then
					if cast.moonkinForm() then return end
				end
				-- Lunar Strike 3 charges
				if buff.lunarEmpowerment.stack() == 3 then
					if cast.lunarStrike() then return end
				end
				-- Starsurge
				if cast.starsurge() then return end
				-- Sunfire
				if not debuff.sunfire.exists(units.dyn40) and mana >= getOptionValue("DPS Save mana") then
					if cast.sunfire(units.dyn40) then return end
				end
				-- Moonfire
				if not debuff.moonfire.exists(units.dyn40) and mana >= getOptionValue("DPS Save mana") then
					if cast.moonfire(units.dyn40) then return end
				end
				-- Lunar Strike charged
				if buff.lunarEmpowerment.exists() then
					if cast.lunarStrike() then return end
				end
				-- Solar Wrath charged
				if buff.solarEmpowerment.exists() then
					if cast.solarWrath(units.dyn40) then return end
				end
				-- Solar Wrath uncharged
				if cast.solarWrath(units.dyn40) then return end
				-- Lunar Strike uncharged
				if cast.lunarStrike() then return end
			end -- End -- Balance Affinity
		end -- End Action List - DPS
		overhealingcancel()
		-----------------
		--- Rotations ---
		-----------------
		-- Pause
		if pause() or mode.rotation == 4 then
			return true
		else
			---------------------------------
			--- Out Of Combat - Rotations ---
			---------------------------------
			if not inCombat and not IsMounted() and not stealthed and not drinking and not buff.shadowmeld.exists() and not isCastingSpell(spell.tranquility) then
				actionList_Extras()
				if isChecked("OOC Healing") then
					actionList_PreCombat()
					actionList_Rejuvenaion()
				end
			end -- End Out of Combat Rotation
			-----------------------------
			--- In Combat - Rotations ---
			-----------------------------
			if inCombat and not IsMounted() and not stealthed and not drinking and not buff.shadowmeld.exists() and not isCastingSpell(spell.tranquility) then
				actionList_Extras()
				actionList_Defensive()
				actionList_Cooldowns()
				actionList_Interrupts()
				if br.player.mode.dps == 2 and (br.friend[1].hp > getValue("DPS") or bear) then
					actionList_DPS()
				end
				if not cat and not moonkin and not bear then
					actionList_AOEHealing()
					actionList_SingleTarget()
					actionList_Rejuvenaion()
				end
			end -- End In Combat Rotation
		end -- Pause
	end -- End Timer
end -- End runRotation
local id = 105
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
name = rotationName,
toggles = createToggles,
options = createOptions,
run = runRotation,
})

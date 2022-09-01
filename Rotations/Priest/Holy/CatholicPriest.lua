-------------------------------------------------------
-- Author = Winterz
-- Patch = 9.2.5
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 80%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Limited
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CatholicPriest"

local IsSwimming, IsFlying, GetInstanceInfo, tinsert, GetCurrentKeyBoardFocus,GetSpellInfo, GetItemCooldown, GetSpellCooldown, IsMounted =
_G.IsSwimming, _G.IsFlying, _G.GetInstanceInfo, _G.tinsert, _G.GetCurrentKeyBoardFocus, _G.GetSpellInfo, _G.GetItemCooldown, _G.GetSpellCooldown, _G.IsMounted

--Edit of HolyLedecky Profile. Thanks.
--Editedit of Auras Edit of HolyLedeckys Profile. Also C&P alot from Fengs profile. Thanks a bunch


--------
-- Nightfae
-- Kyrian

---------------
--- Toggles ---
---------------
local function createToggles()
	-- Rotation Button
	local RotationModes = {
		[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range", highlight = 1, icon = br.player.spell.holyWordSanctify },
		[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used", highlight = 0, icon = br.player.spell.prayerOfHealing },
		[3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used", highlight = 0, icon = br.player.spell.heal },
		[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.holyFire}
	};
	br.ui:createToggle(RotationModes,"Rotation",1,0)
	-- Cooldown Button
	local CooldownModes = {
		[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 1, icon = br.player.spell.guardianSpirit },
		[2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 0, icon = br.player.spell.guardianSpirit },
		[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.guardianSpirit }
	};
	br.ui:createToggle(CooldownModes,"Cooldown",2,0)
	-- Defensive Button
	local DefensiveModes = {
		[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 1, icon = br.player.spell.desperatePrayer },
		[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.desperatePrayer }
	};
	br.ui:createToggle(DefensiveModes,"Defensive",3,0)
	-- Purify Button
	local PurifyModes = {
		[1] = { mode = "On", value = 1 , overlay = "Purify Enabled", tip = "Purify Enabled", highlight = 1, icon = br.player.spell.purify },
		[2] = { mode = "Off", value = 2 , overlay = "Purify Disabled", tip = "Purify Disabled", highlight = 0, icon = br.player.spell.purify }
	};
	br.ui:createToggle(PurifyModes,"Purify",4,0)
	-- DPS Button
	local DPSModes = {
		[1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.smite },
		[2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.renew }
	};
	br.ui:createToggle(DPSModes,"DPS",5,0)
	-- PI Button
	local PIModes = {
		[1] = {	mode = "On", value = 1,	overlay = "Auto PI ON",	tip = "Auto PI ON",	highlight = 1,	icon = br.player.spell.powerInfusion},
		[2] = {	mode = "Off", value = 2, overlay = "Auto PI OFF", tip = "Auto PI OFF", highlight = 0, icon = br.player.spell.powerInfusion}
	};
	br.ui:createToggle(PIModes,"PI", 6, 0)

end

--------------
--- COLORS ---
--------------
local colorBlue     = "|cff00CCFF"
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"
local colorGold     = "|cffFFDD11"
local colordk           = "|cffC41F3B"
local colordh           = "|cffA330C9"
local colordrood        = "|cffFF7D0A"
local colorhunter       = "|cffABD473"
local colormage         = "|cff69CCF0"
local colormonk         = "|cff00FF96"
local colorpala         = "|cffF58CBA"
local colorpriest       = "|cffFFFFFF"
local colorrogue        = "|cffFFF569"
local colorshaman       = "|cff0070DE"
local colorwarlock      = "|cff9482C9"
local colorwarrior      = "|cffC79C6E"
local colorLegendary    = "|cffff8000"

---------------
--- LISTS   ---
---------------
local StunsBlackList="167876|169861|168318|165824|165919|171799|168942|167612|169893|167536|173044|167731|165137|167538|168886|170572"
local StunSpellList="326450|328177|331718|331743|334708|333145|321807|334748|327130|327240|330532|328400|330423|294171|164737|330586|329224|328429|295001|296355|295001|295985|330471|329753|296748|334542|242391|322169|324609"
local HWCPrioList = "164702|164362|170488|165905|165251|165556|355640|347721"

---------------
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable
	local section
	local function rotationOptions()

		-- General Options
		section = br.ui:createSection(br.ui.window.profile, "General - Version 1.02")
		br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        br.ui:createCheckbox(section, "Resurrection")
        br.ui:createDropdownWithout(section, "Resurrection - Target", {"|cff00FF00Target", "|cffFF0000Mouseover", "|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")
		br.ui:createCheckbox(section,"Power Word: Fortitude", "Check to auto buff Fortitude on party.")
		br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
		br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
		br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
		br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
		br.ui:createCheckbox(section,"Arcane Torrent","Uses Blood Elf Arcane Torrent for Mana")
		br.ui:createSpinnerWithout(section, "Arcane Torrent Mana",  50,  0,  100,  1,  "Mana Percent to Cast At")
		br.ui:createSpinner(section, "Mana Potion Channeled",  50,  0,  100,  1,  "Mana Percent to Cast At")
		br.ui:createSpinner(section, "Angelic Feather",  2,  0,  100,  1,  "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAngelic Feather usage|cffFFBB00.")
		br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "", "|cffFFFFFFWhen Bursting stacks are above this amount, CDs will be triggered.")
		br.ui:checkSectionState(section)

		-- Dispel and Purify Settings
		section = br.ui:createSection(br.ui.window.profile, colorwarlock.."Dispel and Purify Options")
		br.ui:createCheckbox(section,"Dispel Magic","Will dispel enemy's buffs.")
		br.ui:createDropdown(section,"Mass Dispel Hotkey", br.dropOptions.Toggle, 6, "Hold down the set hotkey and Mass Dispel will be casted at mouse cursor on next GCD.")
		br.ui:createCheckbox(section,"Purify","Enable use of Purify for removing Magic or Disease debuff.")
		br.ui:createCheckbox(section,"Mass Dispel Alternative","Use Mass Dispel as an alternative to Purify if it is on cooldown.")
		br.ui:checkSectionState(section)

		-- Covenants
		section = br.ui:createSection(br.ui.window.profile, colordk.. "Covenants")
		br.ui:createCheckbox(section,"Fae Guardians","Use NF Covenant")
		br.ui:createDropdownWithout(section, "Fae Guardians Mode", { "|cffFFFFFFDR", "|cffFFFFFFCDR", }, 1, "", "")
		br.ui:checkSectionState(section)

		-- Holy Word: Chastise
		section = br.ui:createSection(br.ui.window.profile, colormage.. "HWC Interrupts/Stuns")
		br.ui:createCheckbox(section, "Holy Word: Chastise", "Uses HW:C for Interrupts and Stuns in the corresponding Lists")
		br.ui:createCheckbox(section, "Use HW:Chastise for DPS")
		br.ui:checkSectionState(section)


		-- Cooldown Options
		section = br.ui:createSection(br.ui.window.profile, colorLegendary.."Cooldowns")
		br.ui:createSpinner(section, "Holy Word: Salvation",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Holy Word: Salvation Targets",  6,  0,  40,  1,  "Minimum Targets below Health Percent before casting.")
		br.ui:createSpinner(section, "Divine Hymn",  50,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Divine Hymn Targets",  3,  0,  40,  1,  "Minimum Divine Hymn Targets")
		br.ui:createSpinner(section, "Apotheosis",  50,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Apotheosis Targets",  3,  0,  40,  1,  "Minimum Apotheosis Targets")
		br.ui:createSpinner(section, "Guardian Spirit",  30,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createCheckbox(section,"Guardian Spirit Tank Only")
		br.ui:createCheckbox(section,"Use PI automatically")
		br.ui:createSpinner(section, "Leap of Faith",  20,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:checkSectionState(section)

		-- Defensive Options
		section = br.ui:createSection(br.ui.window.profile, colorwarrior.."Defensive")
		br.player.module.BasicHealing(section)
		br.ui:createSpinner(section, "Desperate Prayer",  80,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		br.ui:createSpinner(section, "Fade",  95,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 95")
		br.ui:checkSectionState(section)

		-- Healing Options
		section = br.ui:createSection(br.ui.window.profile, colorGreen.."Healing Options")
		br.ui:createSpinner(section, "Prayer of Mending",  100,  0,  100,  1,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Heal",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Flash Heal",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Flash Heal Surge of Light",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Flash Heal Emergency",  40,  0,  100,  5,  "Overrides most settings to prioritize casting Flash Heal")
		br.ui:createCheckbox(section,"Tanks Only","Will only use Flash Heal Emergency on Tanks only.")
		br.ui:checkSectionState(section)

		--Renew Settings--
		section = br.ui:createSection(br.ui.window.profile, colorhunter.."Renew Settings")
		br.ui:createSpinner(section, "Renew",  85,  0,  100,  1,  "Health Percent of group to Cast At")
		br.ui:createSpinner(section, "Renew Limit",  6,  0,  40,  1,  "Limits the amount of Renew to cast. Set amount of renews you want to have out")
		br.ui:createSpinner(section, "Renew on Tanks",  90,  0,  100,  1,  "Tanks Health Percent of tanks to Cast At")
		br.ui:createSpinner(section, "Renew while moving",  80,  0,  100,  1,  "Moving Health Percent to Cast At")
		br.ui:checkSectionState(section)

		--Apotheosis Mode
		section = br.ui:createSection(br.ui.window.profile, colorLegendary.."Apotheosis Settings")
		br.ui:createCheckbox(section, "Apotheosis Mode","Will Priotize use of Flash Heal, PoH to get Holy Words off CDs")
		br.ui:createSpinner(section, "Apotheosis Heal",  85,  0,  100,  1,  "Use Flash Heal while Apotheosis is active.")
		br.ui:createSpinner(section, "Apotheosis Flash Heal",  85,  0,  100,  1,  "Use Flash Heal while Apotheosis is active.")
		br.ui:createSpinnerWithout(section, "Apotheosis Serenity CD",  30,  0,  60,  1,  "Use Flash Heal only if Serenity CD is above this.")
		br.ui:createSpinner(section, "Apotheosis Prayer of Healing",  90,  0,  100,  1,  "Use PoH while Apotheosis is active.")
		br.ui:createSpinnerWithout(section, "Apotheosis PoH Targets",  3,  0,  6,  1,  "Use PoH when this many allies are below set HP.")
		br.ui:createSpinnerWithout(section, "Apotheosis PoH CD",  30,  0,  60,  1,  "Use PoH only if Sanctify CD is above this.")
		br.ui:checkSectionState(section)

		-- Holy Word settings
		section = br.ui:createSection(br.ui.window.profile, colorshaman.."Holy Word Settings")
		br.ui:createSpinner(section, "Holy Word: Serenity",  75,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinner(section, "Holy Word: Sanctify",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Holy Word: Sanctify Targets",  3,  0,  40,  1,  "Minimum Holy Word: Sanctify Targets")
		br.ui:createDropdown(section, "Holy Word: Sanctify HK", br.dropOptions.Toggle, 10, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Holy Word: Sanctify Hot Key Usage.")
		br.ui:checkSectionState(section)

		-- Aoe Healing
		section = br.ui:createSection(br.ui.window.profile, colordh.."AOE Healing")
		br.ui:createSpinner(section, "Prayer of Healing",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Prayer of Healing Targets",  3,  0,  40,  1,  "Minimum Prayer of Healing Targets")
		br.ui:createSpinner(section, "Circle of Healing",  75,  0,  100,  5,  "Health Percent to Cast At")
        	br.ui:createSpinnerWithout(section, "Circle of Healing Targets",  3,  0,  40,  1,  "Minimum Circle of Healing Targets")
		br.ui:createSpinner(section, "Divine Star",  80,  0,  100,  5,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Divine Star usage.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Divine Star Targets",  3,  1,  40,  1,  colorBlue.."Minimum Divine Star Targets "..colorGold.."(This includes you)")
		br.ui:createSpinner(section, "Halo",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Halo Targets",  3,  0,  40,  1,  "Minimum Halo Targets")
		br.ui:checkSectionState(section)


		-- Player Emergency Healing
		section = br.ui:createSection(br.ui.window.profile, colorRed.."Self-Heal Emergency")
		br.ui:createSpinner(section, "Serenity On Me",  25,  0,  100,  5,  "Will prioritize using Serenity on myself once CD is up or when it is available if my HP drops below this")
		br.ui:createSpinner(section, "Flash Heal On Me",  25,  0,  100,  5,  "Will spam Flash Heal when my HP is below this.")
		br.ui:checkSectionState(section)

		-- DPS
		section = br.ui:createSection(br.ui.window.profile, colorLegendary.."DPS")
		br.ui:createCheckbox(section, "Smite")
		br.ui:createCheckbox(section, "Holy Fire")
		br.ui:createCheckbox(section, "SW:P")
		br.ui:createCheckbox(section, "Divine Star DPS")
		br.ui:checkSectionState(section)

		-- Lists
		section = br.ui:createSection(br.ui.window.profile,  "Lists")
		br.ui:createScrollingEditBoxWithout(section,"Stuns Blacklist Units", StunsBlackList, "List of units to blacklist when HW:C", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"Stun Spells", StunSpellList, "List of spells to stun with auto stun function", 240, 50)
		br.ui:createScrollingEditBoxWithout(section,"HW:C Prio Units", HWCPrioList, "List of units to prioritize for HW:C", 240, 50)
		br.ui:checkSectionState(section)

	end

	local function PI_Spells()

        section = br.ui:createSection(br.ui.window.profile, colorwarrior.."Warrior")
		br.ui:createCheckbox(section, "PI Recklessness")
		br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colorpala.."Paladin")
		br.ui:createCheckbox(section, "PI Wings")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colorhunter.."Hunter")
		br.ui:createCheckbox(section, "PI Trueshot")
		br.ui:createCheckbox(section, "PI Coordinated Assault")
		br.ui:createCheckbox(section, "PI Aspect of the Wild")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colorrogue.."Rogue")
		br.ui:createCheckbox(section, "PI Adrenaline Rush")
		br.ui:createCheckbox(section, "PI Shadow Blades")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colorpriest.."Priest")
		br.ui:createCheckbox(section, "SOON")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colordk.."Deathknight")
		br.ui:createCheckbox(section, "SOON")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colorshaman.."Shaman")
		br.ui:createCheckbox(section, "PI Stormkeeper")
		br.ui:createCheckbox(section, "PI Feral Spirits")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colormage.."Mage")
		br.ui:createCheckbox(section, "PI Combustion")
		br.ui:createCheckbox(section, "PI Icy Veins")
		br.ui:createCheckbox(section, "PI Arcane Power")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colorwarlock.."Warlock")
		br.ui:createCheckbox(section, "PI Infernal")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colormonk.."Monk")
		br.ui:createCheckbox(section, "SOON")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colordrood.."Druid")
		br.ui:createCheckbox(section, "SOON")
        br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colordh.."Demon Hunter")
		br.ui:createCheckbox(section, "PI Meta")
        br.ui:checkSectionState(section)

    end

	optionTable = {{
		[1] = "Rotation Options",
		[2] = rotationOptions,
	},

	{
		[1] = "\124cffff6060PI Spells\124r",
		[2] = PI_Spells,
	}

}
	return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
	if br.timer:useTimer("debugHoly", 0.1) then
		--Print("Running: "..rotationName)
		--------------
		--- Locals ---
		--------------
		local artifact                                      = br.player.artifact
		local buff                                          = br.player.buff
		local cast                                          = br.player.cast
		local combatTime                                    = br.getCombatTime()
		local cd                                            = br.player.cd
		local charges                                       = br.player.charges
		local debuff                                        = br.player.debuff
		local enemies                                       = br.player.enemies
		local falling, swimming, flying, moving             = br.getFallTime(), IsSwimming(), IsFlying(), br.isMoving("player")
		local gcd                                           = br.player.gcd
		local gcdMax                                        = br.player.gcdMax
		local healPot                                       = br.getHealthPot()
		local inCombat                                      = br.player.inCombat
		local inInstance                                    = br.player.instance=="party"
		local inRaid                                        = br.player.instance=="raid"
		local lastSpell                                     = br.lastSpellCast
		local level                                         = br.player.level
		local lowestHP                                      = br.friend[1].unit
		local mana                                          = br.player.power.mana.percent()
		local mode                                          = br.player.ui.mode
		local perk                                          = br.player.perk
		local php                                           = br.player.health
		local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
		local pullTimer                                     = br.DBM:getPulltimer()
		local race                                          = br.player.race
		local racial                                        = br.player.getRacial()
		local spell                                         = br.player.spell
		local talent                                        = br.player.talent
		local ttm                                           = br.player.power.mana.ttm()
		local units                                         = br.player.units
		local ui            								= br.player.ui
		local var 											= {}
		local covenant 										= br.player.covenant
		local thisUnit
		local runeforge                                     = br.player.runeforge

		local lowest                                        = {}    --Lowest Unit
		lowest.hp                                           = br.friend[1].hp
		lowest.role                                         = br.friend[1].role
		lowest.unit                                         = br.friend[1].unit
		lowest.range                                        = br.friend[1].range
		lowest.guid                                         = br.friend[1].guid
		local friends                                       = {}
		local tank                                          = {}    --Tank
		local averageHealth                                 = 0
		local tanks = br.getTanksTable()
		local burst = nil

		-- Variables

		units.get(5)
		units.get(8,true)
		units.get(40)

		enemies.get(5)
		enemies.get(8)
		enemies.get(8,"target")
		enemies.get(30)
		enemies.get(40)
		friends.yards40 = br.getAllies("player",40)

		if inInstance and select(3, GetInstanceInfo()) == 8 then
            for i = 1, #tanks do
                local ourtank = tanks[i].unit
                local Burststack = br.getDebuffStacks(ourtank, 240443)
                if Burststack >= br.getOptionValue("Bursting") then
                    burst = true
                    break
                else
                    burst = false
                end
            end
        end

		local renewCount = 0
		for i=1, #br.friend do
			local renewRemain = br.getBuffRemain(br.friend[i].unit,spell.buffs.renew,"player") or 0 -- Spell ID 139
			if renewRemain > 0 then
				renewCount = renewCount + 1
			end
		end
		--local lowest = {}
        lowest.unit = "player"
        lowest.hp = 100
        for i = 1, #br.friend do
            if br.friend[i].hp < lowest.hp then
                lowest = br.friend[i]
            end
        end

		local noStunsUnits = {}
		for i in string.gmatch(ui.value("Stuns Blacklist Units"), "%d+") do
			noStunsUnits[tonumber(i)] = true
		end
		local StunSpellsList = {}
		for i in string.gmatch(ui.value("Stun Spells"), "%d+") do
			StunSpellsList[tonumber(i)] = true
		end
		local HWCPrioList = {}
		for i in string.gmatch(ui.value("HW:C Prio Units"), "%d+") do
			HWCPrioList[tonumber(i)] = true
		end

		--------------------
		--- Action Lists ---
		--------------------
		-- Action List Covenants
		local function actionList_Covenants()
			if br.isChecked("Fae Guardians") and cd.faeGuardians.ready() and covenant.nightFae.active then
				for i = 1, #br.friend do
					thisUnit = br.friend[i].unit
						local PITarget = select(2, br._G.UnitClass(thisUnit))
						if not br.GetUnitIsUnit("player", thisUnit) then
							br.addonDebug("Buff Unit is : " .. tostring(thisUnit) .. " Class =" .. PITarget)
							if
									-- MAGE
									PITarget == "MAGE"
									and (br.UnitBuffID(thisUnit, 190319) -- Combustion
									or br.UnitBuffID(thisUnit, 12472) -- Icy Veins
									or br.UnitBuffID(thisUnit, 12042)) -- Arcane Power
									-- DRUID
									or PITarget == "DRUID"
									and (br.UnitBuffID(thisUnit, 194223) -- Celestial Alignment
									or br.UnitBuffID(thisUnit, 102560)) -- Incarnation: Chosen of Elune
									-- WARRIOR
									or PITarget == "WARRIOR" and br.UnitBuffID(thisUnit, 316828) -- recklessness
									-- WARLOCK
									or PITarget == "WARLOCK" and br.UnitBuffID(thisUnit, 266087) -- Infernal // Rainy Thingy
									-- PRIEST
									or PITarget == "PRIEST" and br.UnitBuffID(thisUnit, 21562) -- Bullshit for now
									-- ROGUE
									or PITarget == "ROGUE" and br.UnitBuffID(thisUnit, 121471) -- Shadow Blades
									-- PALARIN
									or PITarget == "PALADIN" and br.UnitBuffID(thisUnit, 31884) -- Wings
									-- HUNTER
									or PITarget == "HUNTER" and (br.UnitBuffID(thisUnit, 288613) -- Trueshot
									or br.UnitBuffID(thisUnit, 266779) -- Coordinated Assault
									or br.UnitBuffID(thisUnit, 193530)) -- Aspect of the Wild
									-- SHAMAN
									or PITarget == "SHAMAN" and (br.UnitBuffID(thisUnit, 191634) -- Stormkeeper
									or br.UnitBuffID(thisUnit, 51533)) -- Feral Spirits
									-- DEMONHUNTER
									or PITarget == "DEMONHUNTER" and br.UnitBuffID(thisUnit, 191427) -- meta
									--or PITarget == "DEATHKNIGHT" and (br.UnitBuffID(thisUnit, 275699) or br.UnitBuffID(thisUnit, 63560) or br.UnitBuffID(thisUnit, 42650))
							then
								if cast.powerInfusion(thisUnit) then return true end
							end
						end
				end
			end
		end

		-- Action List PI
		local function actionList_PI()
				if cd.powerInfusion.ready() and mode.pI == 1 then   --br.player.ui.mode.AutoPI == 1  // br.isChecked("Use PI automatically")
					for i = 1, #br.friend do
						thisUnit = br.friend[i].unit
							local PITarget = select(2, br._G.UnitClass(thisUnit))
							if not br.GetUnitIsUnit("player", thisUnit) then
								br.addonDebug("Buff Unit is : " .. tostring(thisUnit) .. " Class =" .. PITarget)
							if
									-- MAGE
									PITarget == "MAGE" and (br.isChecked("PI Combustion") and br.UnitBuffID(thisUnit, 190319)) -- Combustion
									or (br.isChecked("PI Icy Veins") and br.UnitBuffID(thisUnit, 12472)) -- Icy Veins
									or (br.isChecked("PI Arcane Power") and br.UnitBuffID(thisUnit, 12042)) -- Arcane Power
									-- DRUID
									or PITarget == "DRUID"
									and (br.UnitBuffID(thisUnit, 194223) -- Celestial Alignment
									or br.UnitBuffID(thisUnit, 102560)) -- Incarnation: Chosen of Elune
									-- WARRIOR
									or PITarget == "WARRIOR" and (br.isChecked("PI Recklessness") and br.UnitBuffID(thisUnit, 316828)) -- recklessness
									-- WARLOCK
									or PITarget == "WARLOCK" and (br.isChecked("PI Infernal") and br.UnitBuffID(thisUnit, 266087)) -- Infernal // Rainy Thingy
									-- PRIEST
									or PITarget == "PRIEST" and br.UnitBuffID(thisUnit, 316828) -- Bullshit for now
									-- ROGUE
									or PITarget == "ROGUE" and (br.isChecked("PI Shadow Blades") and br.UnitBuffID(thisUnit, 121471)) -- Shadow Blades
									or (br.isChecked("PI Adrenaline Rush") and br.UnitBuffID(thisUnit, 13750)) -- Adrenaline RUsh
									-- PALARIN
									or PITarget == "PALADIN" and (br.isChecked("PI Wings") and br.UnitBuffID(thisUnit, 31884)) -- Wings
									-- HUNTER
									or PITarget == "HUNTER" and (br.isChecked("PI Trueshot") and br.UnitBuffID(thisUnit, 288613)) -- Trueshot
									or (br.isChecked("PI Coordinated Assault") and br.UnitBuffID(thisUnit, 266779)) -- Coordinated Assault
									or (br.isChecked("PI Aspect of the Wild") and br.UnitBuffID(thisUnit, 193530)) -- Aspect of the Wild
									-- SHAMAN
									or PITarget == "SHAMAN" and (br.isChecked("PI Stormkeeper") and br.UnitBuffID(thisUnit, 191634)) -- Stormkeeper
									or (br.isChecked("PI Feral Spirits") and br.UnitBuffID(thisUnit, 51533)) -- Feral Spirits
									-- DEMONHUNTER
									or PITarget == "DEMONHUNTER" and (br.isChecked("PI Meta") and br.getBuffRemain(thisUnit,191427) >10 and br.UnitBuffID(thisUnit, 191427)) -- meta
									--or PITarget == "DEATHKNIGHT" and (br.UnitBuffID(thisUnit, 275699) or br.UnitBuffID(thisUnit, 63560) or br.UnitBuffID(thisUnit, 42650))
							then
								if cast.powerInfusion(thisUnit) then return true end
							end
							end
					end
				end
		end
		-- Action List - Holy Word Chastise
		local function actionList_HWC()

			if cd.holyWordChastise.ready() then
				for i = 1, #enemies.yards30 do
					local thisUnit = enemies.yards30[i]
					if HWCPrioList[br.GetObjectID(thisUnit)] ~= nil and br.getBuffRemain(thisUnit,343503) == 0 then
						if cast.holyWordChastise(thisUnit) then return true end
					end
					-- Opportunity Strikes copied by Feng because why not
					if br._G.UnitChannelInfo(thisUnit) == br._G.GetSpellInfo(333540) then
						if cast.holyWordChastise(thisUnit) then return true end
					end
				end
			end

			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				local distance = br.getDistance(thisUnit)
				-- Stun Spells
				local interruptID
				if br._G.UnitCastingInfo(thisUnit) then
					interruptID = select(9,br._G.UnitCastingInfo(thisUnit))
				elseif br._G.UnitChannelInfo(thisUnit) then
					interruptID = select(8,br._G.UnitChannelInfo(thisUnit))
				end
				if interruptID ~=nil and StunSpellsList[interruptID] and br.getBuffRemain(thisUnit,343503) == 0 then
					if ui.checked("Holy Word: Chastise") and cd.holyWordChastise.ready() and br.getBuffRemain(thisUnit,226510) == 0 then
						if cast.holyWordChastise(thisUnit) then return true end
					end
				end
			end

		end -- End Action List Holy Word Chastise
		-- Action List - Extras
		local function actionList_Extras()

			if br.isChecked("Resurrection") and not inCombat and not br.isMoving("player") and br.timer:useTimer("Resurrect", 4) then
				if br.getOptionValue("Resurrection - Target") == 1 and br._G.UnitIsPlayer("target") and br.GetUnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
					if cast.resurrection("target", "dead") then
						br.addonDebug("Casting Resurrection (Target)")
						return true
					end
				end
				if br.getOptionValue("Resurrection - Target") == 2 and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
					if cast.resurrection("mouseover", "dead") then
						br.addonDebug("Casting Resurrection (Mouseover)")
						return true
					end
				end
				if br.getOptionValue("Resurrection - Target") == 3 then
					local deadPlayers = {}
					for i =1, #br.friend do
						if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) then
							tinsert(deadPlayers,br.friend[i].unit)
						end
					end
					if #deadPlayers > 1 then
						if cast.massResurrection() then br.addonDebug("Casting Mass Resurrection") return true end
					elseif #deadPlayers == 1 then
						if cast.resurrection(deadPlayers[1],"dead") then br.addonDebug("Casting Resurrection (Auto)") return true end
					end
				end
			end
			-- Moving
			if br.IsMovingTime(br.getOptionValue("Angelic Feather")) then
				if br.isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") then
					if cast.angelicFeather("player") then
						br.addonDebug("Casting Angelic Feather")
						br._G.SpellStopTargeting()
					end
				end
			end
			-- Mass Dispel
			if br.isChecked("Mass Dispel Hotkey") and (br.SpecificToggle("Mass Dispel Hotkey") and not GetCurrentKeyBoardFocus()) then
				br._G.CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
				br.addonDebug("Casting Mass Dispel")
				return
			end
		    -- Battle Shout Check
			if br.timer:useTimer("PWFTimer", math.random(15,40)) then
				if br.isChecked("Power Word: Fortitude") then
					if cast.able.powerWordFortitude() then
						for i = 1, #br.friend do
							local thisUnit = br.friend[i].unit
							if not br.GetUnitIsDeadOrGhost(thisUnit)
									and br.getDistance(thisUnit) < 40
									and br.getBuffRemain(thisUnit, spell.powerWordFortitude) < 60
							then
								if cast.powerWordFortitude() then
									return true
								end
							end
						end
					end
				end
			  end
			--if br.isChecked("Power Word: Fortitude") then
            --    for i = 1, #br.friend do
            --       if not buff.powerWordFortitude.exists(br.friend[i].unit,"any") and br.getDistance("player", br.friend[i].unit) < 40 and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br._G.UnitIsPlayer(br.friend[i].unit) then
            --            if cast.powerWordFortitude() then br.addonDebug("Casting Power Word: Fortitude") return end
            --        end
            --    end
			--end
		end -- End Action List - Extras
		-- Action List - Pre-Combat
		local function actionList_OOCHealing()
			-- Renew on tank
			if br.isChecked("Renew on Tanks")  then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Renew on Tanks") and not buff.renew.exists(br.friend[i].unit) and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew OOC") return end
					end
				end
			end
			-- Renew
			if br.isChecked("Renew") and renewCount < br.getOptionValue("Renew Limit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Renew") and not buff.renew.exists(br.friend[i].unit) then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew OOC") return end
					end
				end
			end

			-- Prayer of Mending
			if br.isChecked("Prayer of Mending") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Prayer of Mending") and not buff.prayerOfMending.exists(br.friend[i].unit) then
						if cast.prayerOfMending(br.friend[i].unit) then br.addonDebug("Casting Prayer of Mending OOC") return end
					end
				end
			end
			-- Heal
			if br.isChecked("Heal") then
				if lowest.hp <= br.getValue("Heal") and not moving then
					if cast.heal(lowest.unit) then br.addonDebug("Casting Heal OOC") return end
				end
			end
			-- Flash Heal
			if br.isChecked("Flash Heal") and br.getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= br.getValue("Flash Heal") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal OOC") return end
				end
			end
			-- Flash Heal Surge of Light
			if br.isChecked("Flash Heal Surge of Light") and talent.surgeOfLight and buff.surgeOfLight.exists() then
				if lowest.hp <= br.getValue("Flash Heal Surge of Light") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal (Surge of Light) OOC") return end
				end
			end
			-- Renew While Moving
			if br.isChecked("Renew while moving") and moving  then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Renew while moving") and not buff.renew.exists(br.friend[i].unit) then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew OOC") return end
					end
				end
			end
		end  -- End Action List - Pre-Combat
		-- Action List Defensive
		local function actionList_Defensive()
			if br.useDefensive() then
				--Fade
				if br.isChecked("Fade") then
					if php <= br.getValue("Fade") then
						if cast.fade() then br.addonDebug("Casting Fade") return end
					end
				end
				-- Mana Potion Channeled
				if br.isChecked("Mana Potion Channeled") and mana <= br.getValue("Mana Potion Channeled")then
					if br.hasItem(171272) then
						br.useItem(171272)
						br.addonDebug("Using Mana Potion")
					end
				end
				-- Desperate Prayer
				if br.isChecked("Desperate Prayer") and php <= br.getOptionValue("Desperate Prayer") then
					if cast.desperatePrayer() then br.addonDebug("Casting Desperate Prayer") return end
				end
			end -- End Defensive Toggle
		end -- End Action List - Defensive
		-- Action List Cooldowns
		local function actionList_Cooldowns()
			if br.useCDs() then
				--Salvation
				if br.isChecked("Holy Word: Salvation") and not moving then
					if br.getLowAllies(br.getValue("Holy Word: Salvation")) >= br.getValue("Holy Word: Salvation Targets") or burst == true then
						if cast.holyWordSalvation() then br.addonDebug("Casting Holy Word: Salvation") return end
					end
				end
				-- Divine Hymn
				if br.isChecked("Divine Hymn") and not moving then
					if br.getLowAllies(br.getValue("Divine Hymn")) >= br.getValue("Divine Hymn Targets") or burst == true then
						if cast.divineHymn() then br.addonDebug("Casting Divine Hymn") return end
					end
				end
				-- Apotheosis
				if br.isChecked("Apotheosis") then
					if GetSpellCooldown(2050) > 1 and br.getLowAllies(br.getValue("Apotheosis")) >= br.getValue("Apotheosis Targets") or burst == true then
						if cast.apotheosis() then br.addonDebug("Casting Apothesis") return end
					end
				end
				-- Trinkets
				if br.isChecked("Trinket 1") and br.canTrinket(13) then
					if br.getOptionValue("Trinket 1 Mode") == 1 then
						if br.getLowAllies(br.getValue("Trinket 1")) >= br.getValue("Min Trinket 1 Targets") or burst == true then
							br.useItem(13)
							br.addonDebug("Using Trinket 1")
							return true
						end
						elseif br.getOptionValue("Trinket 1 Mode") == 2 then
							if (lowest.hp <= br.getValue("Trinket 1") or burst == true) and lowest.hp ~= 250 then
							br._G.UseItemByName(_G.GetInventoryItemID("player", 13), lowest.unit)
							br.addonDebug("Using Trinket 1 (Target)")
							return true
							end
						elseif br.getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
							for i = 1, #tanks do
								-- get the tank's target
								local tankTarget = br._G.UnitTarget(tanks[i].unit)
								if tankTarget ~= nil then
								-- get players in melee range of tank's target
								local meleeFriends = br.getAllies(tankTarget, 5)
								-- get the best ground circle to encompass the most of them
								local loc = nil
								if #meleeFriends < 12 then
									loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
								else
									local meleeHurt = {}
									for j = 1, #meleeFriends do
									if meleeFriends[j].hp < br.getValue("Trinket 1") then
										tinsert(meleeHurt, meleeFriends[j])
									end
									end
									if #meleeHurt >= br.getValue("Min Trinket 1 Targets") or burst == true then
									loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
									end
								end
								if loc ~= nil then
									br.useItem(13)
									br.addonDebug("Using Trinket 1 (Ground)")
									local px,py,pz = br._G.ObjectPosition("player")
									loc.z = select(3,br._G.TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
									if loc.z ~= nil and br._G.TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and br._G.TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions
										br._G.ClickPosition(loc.x, loc.y, loc.z)
										return true
									end
								end
							end
						end
					end
				end
				if br.isChecked("Trinket 2") and br.canTrinket(14) and not br.hasEquiped(165569,14) and not br.hasEquiped(160649,14) and not br.hasEquiped(158320,14) then
					if br.getOptionValue("Trinket 2 Mode") == 1 then
						if br.getLowAllies(br.getValue("Trinket 2")) >= br.getValue("Min Trinket 2 Targets") or burst == true then
							br.useItem(14)
							br.addonDebug("Using Trinket 2")
							return true
						end
						elseif br.getOptionValue("Trinket 2 Mode") == 2 then
							if (lowest.hp <= br.getValue("Trinket 2") or burst == true) and lowest.hp ~= 250 then
							br._G.UseItemByName(_G.GetInventoryItemID("player", 14), lowest.unit)
							br.addonDebug("Using Trinket 2 (Target)")
							return true
							end
						elseif br.getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
							for i = 1, #tanks do
								-- get the tank's target
								local tankTarget = br._G.UnitTarget(tanks[i].unit)
								if tankTarget ~= nil then
								-- get players in melee range of tank's target
								local meleeFriends = br.getAllies(tankTarget, 5)
								-- get the best ground circle to encompass the most of them
								local loc = nil
								if #meleeFriends < 12  then
									loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
								else
									local meleeHurt = {}
									for j = 1, #meleeFriends do
									if meleeFriends[j].hp < br.getValue("Trinket 2") then
										tinsert(meleeHurt, meleeFriends[j])
									end
									end
									if #meleeHurt >= br.getValue("Min Trinket 2 Targets") or burst == true then
									loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
									end
								end
								if loc ~= nil then
									br.useItem(14)
									br.addonDebug("Using Trinket 2 (Ground)")
									br._G.ClickPosition(loc.x, loc.y, loc.z)
									return true
								end
							end
						end
					end
				end
				-- Racial: Blood Elf Arcane Torrent
				if br.isChecked("Arcane Torrent") and inCombat and (br.player.race == "BloodElf") and mana <= br.getValue("Arcane Torrent Mana") then
					if br.castSpell("player",racial,false,false,false) then br.addonDebug("Casting Racial") return end
				end
			end -- End useCooldowns check
		end -- End Action List - Cooldowns
		-- Dispel
		local function actionList_Dispel()
			-- Purify
			if br.player.ui.mode.purify == 1 then
				if br.isChecked("Purify") then
					for i = 1, #br.friend do
						if br.getSpellCD(spell.purify) > 1 and br.isChecked("Mass Dispel Alternative") and br.canDispel(br.friend[i].unit, spell.massDispel)	then
							if br.castGround(br.friend[i].unit, spell.massDispel, 30) then br.addonDebug("Casting Mass Dispel") return end
						elseif br.canDispel(br.friend[i].unit, spell.purify) then
							if cast.purify(br.friend[i].unit) then br.addonDebug("Casting Purify") return end
						end
					end
				end
			end
			-- Mass Dispel
			if br.isChecked("Mass Dispel Hotkey") and (br.SpecificToggle("Mass Dispel Hotkey") and not GetCurrentKeyBoardFocus()) then
				br._G.CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
				br.addonDebug("Casting Mass Dispel")
				return
			end
		end -- End Action List - Dispel
		-- Emergency
		local function actionList_Emergency()
			-- Guardian Spirit
			if br.isChecked("Guardian Spirit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Guardian Spirit") then
						if br.friend[i].role == "TANK" or not br.isChecked("Guardian Spirit Tank Only") then
							if cast.guardianSpirit(br.friend[i].unit) then br.addonDebug("Casting Guardian Spirit") return end
						end
					end
				end
			end
			-- Serenity On Me Emergency
			if br.isChecked("Serenity On Me") and php <= br.getOptionValue("Serenity On Me") then
				if cast.holyWordSerenity("player") then br.addonDebug("Casting Holy Word: Serenity emergency") return end
			end
			-- Holy Word: Serenity
			if br.isChecked("Holy Word: Serenity") then
				if lowest.hp <= br.getValue("Holy Word: Serenity") then
					if cast.holyWordSerenity(lowest.unit) then br.addonDebug("Casting Holy Word: Serenity emergency") return end
				end
			end

			-- Flash Heal On Me
			if br.isChecked("Flash Heal On Me") and (not buff.flashConcentration.exists("player") or buff.flashConcentration.remain() < 4 or buff.flashConcentration.stack() < 5) and inCombat and not moving and php <= br.getValue("Flash Heal On Me") then
				if cast.flashHeal("player") then br.addonDebug("Casting Flash Heal self emergency") return end
			end
			--Apotheosis Mode
			if br.isChecked("Apotheosis Mode") and br.getBuffRemain("player",200183) > 0 then
				for i = 1, #br.friend do
					if br.isChecked("Apotheosis Heal") and br.getDebuffRemain("player",240447) == 0 and not moving and buff.flashConcentration.stack() == 5 and GetSpellCooldown(2050) > br.getValue("Apotheosis Serenity CD") then
						if lowest.hp <= br.getValue("Apotheosis Heal") then
							if cast.heal(lowest.unit) then br.addonDebug("Casting 5-FC APO Heal") return end
						end
					end
					if br.isChecked("Apotheosis Flash Heal") and br.friend[i].hp <= br.getValue("Apotheosis Flash Heal")and (not buff.flashConcentration.exists("player") or buff.flashConcentration.remain() < 4 or buff.flashConcentration.stack() < 5) and GetSpellCooldown(2050) > br.getValue("Apotheosis Serenity CD") and not moving then
						if cast.flashHeal(br.friend[i].unit) then br.addonDebug("Casting Flash Heal apo emergency") return end
					end
					if br.isChecked("Apotheosis Prayer of Healing") and br.getLowAllies(br.getValue("Apotheosis Prayer of Healing")) >= br.getValue("Apotheosis PoH Targets") and GetSpellCooldown(34861) > br.getValue("Apotheosis Sanctify CD") and not moving then
						if cast.prayerOfHealing(lowest.unit) then br.addonDebug("Casting Prayer of Healing apo emergency") return end
					end
				end
			end
			-- Flash Heal Others
			if br.isChecked("Flash Heal Emergency") and br.getDebuffRemain("player",240447) == 0 and not moving then
				for i = 1, #br.friend do
					if br.isChecked("Tanks Only") then
						if br.friend[i].hp <= br.getValue("Flash Heal Emergency") and (not buff.flashConcentration.exists("player") or buff.flashConcentration.remain() < 4 or buff.flashConcentration.stack() < 5) and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
							if cast.flashHeal(br.friend[i].unit) then br.addonDebug("Casting Flash Heal emergency") return end
						end
					elseif br.friend[i].hp <= br.getValue("Flash Heal Emergency") and (not buff.flashConcentration.exists("player") or buff.flashConcentration.remain() < 4 or buff.flashConcentration.stack() < 5) then
						if cast.flashHeal(br.friend[i].unit) then br.addonDebug("Casting Flash Heal emergency") return end
					end
				end
			end
		end -- EndAction List Emergency
		-- Action List Spirit of Redemption
		local function actionList_SoR()
			--Guardian Spirit
			if br.isChecked("Guardian Spirit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Guardian Spirit") then
						if br.friend[i].role == "TANK" or not br.isChecked("Guardian Spirit Tank Only") then
							if cast.guardianSpirit(br.friend[i].unit) then br.addonDebug("Casting Guardian Spirit") return end
						end
					end
				end
			end
			if br.isChecked("Prayer of Mending") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Prayer of Mending") and not buff.prayerOfMending.exists(br.friend[i].unit) then
						if cast.prayerOfMending(br.friend[i].unit) then br.addonDebug("Casting Prayer of Mending") return end
					end
				end
			end
			--Healqw
			if br.isChecked("Heal") and br.getDebuffRemain("player",240447) == 0 and not moving and buff.flashConcentration.stack() == 5 then
				if lowest.hp <= br.getValue("Heal") then
					if cast.heal(lowest.unit) then br.addonDebug("Casting 5-FC Prio Angel Heal") return end
				end
			end
			-- Prayer of Healing
			if br.getLowAllies(br.getOptionValue("Prayer of Healing")) >= 4 then
				if br.castWiseAoEHeal(br.friend,spell.prayerOfHealing,40,br.getValue("Prayer of Healing"),4,5,false,true) then br.addonDebug("Casting Prayer of Healing") return end
			end
			-- Holy Word Serenity
			if lowest.hp <= br.getOptionValue("Holy Word: Serenity") then
				if cast.holyWordSerenity(lowest.unit) then br.addonDebug("Casting Holy Word: Serenity") return end
			end
			-- Flash Heal
			if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal sor") return end
		end -- End Action List SoR
		-- AOE Healing
		local function actionList_AOEHealing()
			-- Holy Word: Serenity
			if br.isChecked("Holy Word: Serenity") then
				if lowest.hp <= br.getValue("Holy Word: Serenity") then
					if cast.holyWordSerenity(lowest.unit) then br.addonDebug("Casting Holy Word: Serenity AOE") return end
				end
			end
			-- Holy Word: Sanctify JR Locals
			local sanctifyCandidates = {}
			--if not br.isChecked("Use Old HW Sanctify") then
				for i=1, #friends.yards40 do
					if cd.holyWordSanctify.remain() == 0 and friends.yards40[i].hp < br.getValue("Holy Word: Sanctify") then
						tinsert(sanctifyCandidates,friends.yards40[i])
					end
				end
			-- Holy Word: Sanctify
				if cd.holyWordSanctify.remain() == 0 and #sanctifyCandidates >= br.getValue("Holy Word: Sanctify Targets") then
					local loc
					-- get the best ground location to heal most or all of them
					if #sanctifyCandidates < 12 then
						loc = br.getBestGroundCircleLocation(sanctifyCandidates,br.getValue("Holy Word: Sanctify Targets"),6,10)
					else
						if br.castWiseAoEHeal(br.friend,spell.holyWordSanctify,10,br.getValue("Holy Word: Sanctify"),br.getValue("Holy Word: Sanctify Targets"),6,false,false) then br.addonDebug("Casting Holy Word: Sanctify") return end
					end
					if loc ~= nil then
						if br.castGroundAtLocation(loc, spell.holyWordSanctify) then br.addonDebug("Casting Holy Word: Sanctify AOE") return end
					end
				end
			--end

			-- Prayer of Mending
			if br.isChecked("Prayer of Mending") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Prayer of Mending") and not buff.prayerOfMending.exists(br.friend[i].unit) then
						if cast.prayerOfMending(br.friend[i].unit) then br.addonDebug("Casting Prayer of Mending AOE") return end
					end
				end
			end
			-- Renew on tank
			if br.isChecked("Renew on Tanks") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Renew on Tanks") and not buff.renew.exists(br.friend[i].unit) and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew AOE") return end
					end
				end
			end
			-- Holy Word: Sanctify Hot Key
			if br.isChecked("Holy Word: Sanctify HK") and (br.SpecificToggle("Holy Word: Sanctify HK") and not GetCurrentKeyBoardFocus()) then
				br._G.CastSpellByName(GetSpellInfo(spell.holyWordSanctify),"cursor")
				br.addonDebug("Casting Holy Word: Sanctify")
				return
			end
			-- Circle of Healing
			if br.isChecked("Circle of Healing") and not moving then
				if br.getLowAllies(br.getValue("Circle of Healing")) >= br.getValue("Circle of Healing Targets") then
					if cast.circleOfHealing() then br.addonDebug("Casting Circle Of Healing") return end
				end
			end
			--Halo
			if br.isChecked("Halo") and talent.halo and not moving then
				if br.getLowAllies(br.getValue("Halo")) >= br.getValue("Halo Targets") then
					if cast.halo() then br.addonDebug("Casting Halo") return end
				end
			end
			-- Prayer of Healing
			if br.isChecked("Prayer of Healing") and br.getDebuffRemain("player",240447) == 0 and not moving then
				if br.castWiseAoEHeal(br.friend,spell.prayerOfHealing,40,br.getValue("Prayer of Healing"),br.getValue("Prayer of Healing Targets"),5,false,true) then br.addonDebug("Casting Prayer of Healing") return end
			end
			-- Divine Star
			if br.isChecked("Divine Star") and talent.divineStar and not moving then
				if br.getUnitsInRect(5,24,false,br.getOptionValue("Divine Star")) >= br.getOptionValue("Min Divine Star Targets") then
					if cast.divineStar() then br.addonDebug("Casting Divine Star") return end
				end
			end
			-- Renew
			if br.isChecked("Renew") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Renew") and not buff.renew.exists(br.friend[i].unit) and not br.isChecked("Renew Limit") then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
					if br.friend[i].hp <= br.getValue("Renew") and not buff.renew.exists(br.friend[i].unit) and br.isChecked("Renew Limit") and renewCount < br.getValue("Renew Limit") then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
		end -- End Action List - AOE Healing
		-- Single Target
		local function actionList_SingleTarget()
			-- Guardian Spirit
			if br.isChecked("Guardian Spirit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Guardian Spirit") then
						if br.friend[i].role == "TANK" or not br.isChecked("Guardian Spirit Tank Only") then
							if cast.guardianSpirit(br.friend[i].unit) then br.addonDebug("Casting Guardian Spirit") return end
						end
					end
				end
			end
			-- Leap of Faith
			if br.isChecked("Leap of Faith") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Leap of Faith") and not br.GetUnitIsUnit(br.friend[i].unit,"player") and br.friend[i].role ~= "TANK" then
						if cast.leapOfFaith(br.friend[i].unit) then br.addonDebug("Casting Leap of Faith") return end
					end
				end
			end
			-- Holy Word: Serenity
			if br.isChecked("Holy Word: Serenity") then
				if lowest.hp <= br.getValue("Holy Word: Serenity") then
					if cast.holyWordSerenity(lowest.unit) then br.addonDebug("Casting Holy Word: Serenity") return end
				end
			end
			-- Heal
			if br.isChecked("Heal") and br.getDebuffRemain("player",240447) == 0 and not moving and buff.flashConcentration.stack() == 5 then
				if lowest.hp <= br.getValue("Heal") then
					if cast.heal(lowest.unit) then br.addonDebug("Casting 5-FC Prio Heal") return end
				end
			end
			-- Flash Heal
			if br.isChecked("Flash Heal") and br.getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= br.getValue("Flash Heal") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal singletarget") return end
				end
			end
			-- Flash Heal Surge of Light
			if br.isChecked("Flash Heal Surge of Light") and talent.surgeOfLight and buff.surgeOfLight.remain() > 1.5 then
				if lowest.hp <= br.getValue("Flash Heal Surge of Light") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal (Surge of Light) single target") return end
				end
			end
			-- Heal
			if br.isChecked("Heal") and br.getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= br.getValue("Heal") then
					if cast.heal(lowest.unit) then br.addonDebug("Casting Low Prio Heal") return end
				end
			end

			-- Prayer of Mending
			if br.isChecked("Prayer of Mending") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Prayer of Mending") and not buff.prayerOfMending.exists(br.friend[i].unit) then
						if cast.prayerOfMending(br.friend[i].unit) then br.addonDebug("Casting Prayer of Mending") return end
					end
				end
			end

			-- Dispel Magic
			if br.isChecked("Dispel Magic") then
				for i = 1, #enemies.yards40 do
					local thisUnit = enemies.yards40[i]
					if br.canDispel(enemies.yards40[i],spell.dispelMagic) and lowest.hp > 40 then
						if cast.dispelMagic() then br.addonDebug("Casting Dispel Magic") return end
					end
				end
			end
			-- Renew While Moving
			if br.isChecked("Renew while moving") and moving then
				for i = 1, #br.friend do
					if  br.isChecked("Renew Limit") and renewCount < br.getValue("Renew Limit") then
						if br.friend[i].hp <= br.getValue("Renew while moving") and not buff.renew.exists(br.friend[i].unit) then
							if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
						end
					elseif br.friend[i].hp <= br.getValue("Renew while moving") and not buff.renew.exists(br.friend[i].unit) then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
			-- Moving
			if br.IsMovingTime(1) then
				if br.isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") then
					if cast.angelicFeather("player") then
						br._G.SpellStopTargeting()
						br.addonDebug("Casting Angelic Feather")
						return
					end
				end
			end
		end -- End Action List - Single Target
		-- DPS
		local function actionList_DPS()
			-- Holy Word: Chastise
			if br.isChecked("Use HW:Chastise for DPS") then
				if cast.holyWordChastise() then br.addonDebug("Casting Holy Word: Chastise for DPS") return end
			end
			-- SW:P
			if br.isChecked("SW:P") then
				for i = 1, #enemies.yards40 do
					local thisUnit = enemies.yards40[i]
						if cd.shadowWordPain.ready() and not debuff.shadowWordPain.exists(thisUnit) or debuff.shadowWordPain.remain(thisUnit) < 4 then
							if cast.shadowWordPain(thisUnit) then br.addonDebug("SW:P") return end
						end
				end
			end
			-- Holy Fire
			if br.isChecked("Holy Fire") then
				if cast.holyFire() then br.addonDebug("Casting Holy Fire") return end
			end
			-- Divine Star
			if br.getEnemiesInRect(5,24) >= br.getOptionValue("Min Divine Star Targets") and br.isChecked("Divine Star DPS") then
				if cast.divineStar() then br.addonDebug("Casting Divine Star") return end
			end
			-- Smite
			if #enemies.yards8 < 8 and br.getDebuffRemain("player",240447) == 0 and not moving and br.isChecked("Smite") then
				if cast.smite() then br.addonDebug("Casting Smite") return end
			end
			-- Holy Nova
			if #enemies.yards8 >= 8 and level > 25 then
				if cast.holyNova() then br.addonDebug("Casting Holy Nova") return end
			end
		end
		if br.data.settings[br.selectedSpec][br.selectedProfile]['HE ActiveCheck'] == false and br.timer:useTimer("Error delay",0.5) then
            br._G.print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
            return
        end
		-----------------
		--- Rotations ---
		-----------------
		-- Pause
		if br.pause() or mode.rotation == 4 then
			return true
		else
			---------------------------------
			--- Out Of Combat - Rotations ---
			---------------------------------
			if not inCombat and not IsMounted() then
				-- maintain FC stacks
				if runeforge.flashConcentration.equiped and not buff.flashConcentration.exists("player") or buff.flashConcentration.remain() < 4 or buff.flashConcentration.stack() < 5 then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal maintain FC") return end
				end
				actionList_Extras()
				actionList_PI()
				actionList_Dispel()
				if br.isChecked("OOC Healing") then
					actionList_OOCHealing()
				end
				-- maintain FC stacks

			end -- End Out of Combat Rotation
			-----------------------------
			--- In Combat - Rotations ---
			-----------------------------
			if inCombat and not IsMounted() then
				if buff.spiritOfRedemption.exists() then
					br.addonDebug("SoR Detected")
					actionList_SoR()
					-- maintain FC stacks
					if runeforge.flashConcentration.equiped and not buff.flashConcentration.exists("player") or buff.flashConcentration.remain() < 4 or buff.flashConcentration.stack() < 5 then
						if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal maintain FC") return end
					end
				end
				if not buff.spiritOfRedemption.exists() then
					-- maintain FC stacks
					if runeforge.flashConcentration.equiped and not buff.flashConcentration.exists("player") or buff.flashConcentration.remain() < 4 or buff.flashConcentration.stack() < 5 then
						if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal maintain FC") return end
					end
					actionList_HWC()
					actionList_Defensive()
					actionList_Cooldowns()
					actionList_Dispel()
					actionList_Emergency()
					actionList_AOEHealing()
					actionList_SingleTarget()
					actionList_PI()
					--actionList_Covenants()
					if br.player.ui.mode.dPS == 1 and (runeforge.flashConcentration.equiped and buff.flashConcentration.remain() > 6) then
						actionList_DPS()
					end
				end
			end -- End In Combat Rotation
		end -- Pause
	end -- End Timer
end -- End runRotation
local id = 257
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
	name = rotationName,
	toggles = createToggles,
	options = createOptions,
	run = runRotation,
})

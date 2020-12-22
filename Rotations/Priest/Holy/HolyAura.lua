local rotationName = "HolyAura"

--Edit of HolyLedecky Profile. Thanks.

---------------
--- Toggles ---
---------------
local function createToggles()
	-- Rotation Button
	RotationModes = {
		[1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range", highlight = 1, icon = br.player.spell.holyWordSanctify },
		[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used", highlight = 0, icon = br.player.spell.prayerOfHealing },
		[3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used", highlight = 0, icon = br.player.spell.heal },
		[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.holyFire}
	};
	CreateButton("Rotation",1,0)
	-- Cooldown Button
	CooldownModes = {
		[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 1, icon = br.player.spell.guardianSpirit },
		[2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 0, icon = br.player.spell.guardianSpirit },
		[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.guardianSpirit }
	};
	CreateButton("Cooldown",2,0)
	-- Defensive Button
	DefensiveModes = {
		[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 1, icon = br.player.spell.desperatePrayer },
		[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.desperatePrayer }
	};
	CreateButton("Defensive",3,0)
	-- Purify Button
	PurifyModes = {
		[1] = { mode = "On", value = 1 , overlay = "Purify Enabled", tip = "Purify Enabled", highlight = 1, icon = br.player.spell.purify },
		[2] = { mode = "Off", value = 2 , overlay = "Purify Disabled", tip = "Purify Disabled", highlight = 0, icon = br.player.spell.purify }
	};
	CreateButton("Purify",4,0)
	-- DPS Button
	DPSModes = {
		[1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.smite },
		[2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.renew }
	};
	CreateButton("DPS",5,0)
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
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable

	local function rotationOptions()
		-- General Options
		section = br.ui:createSection(br.ui.window.profile, "General - Version 1.01")
		-- Dummy DPS Test
		br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
		-- OOC Healing
		br.ui:createCheckbox(section,"OOC Healing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
		--Resurrection
        br.ui:createCheckbox(section, "Resurrection")
        br.ui:createDropdownWithout(section, "Resurrection - Target", {"|cff00FF00Target", "|cffFF0000Mouseover", "|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")
		-- Auto Buff Fortitude
		br.ui:createCheckbox(section,"Power Word: Fortitude", "Check to auto buff Fortitude on party.")
		-- Flask / Crystal
		--    br.ui:createCheckbox(section,"Flask / Crystal")
		-- Trinkets
		br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
		br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
		br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
		br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
		br.ui:createSpinner(section, "Revitalizing Voodoo Totem", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
		br.ui:createSpinner(section, "Inoculating Extract", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
		br.ui:createSpinner(section,"Ward of Envelopment", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
		-- Pre-Pull Timer
		br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  15,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 15 / Interval: 1")
		-- Racial
		br.ui:createCheckbox(section,"Arcane Torrent","Uses Blood Elf Arcane Torrent for Mana")
		br.ui:createSpinnerWithout(section, "Arcane Torrent Mana",  50,  0,  100,  1,  "Mana Percent to Cast At")
		--  Mana Potion Channeled
		br.ui:createSpinner(section, "Mana Potion Channeled",  50,  0,  100,  1,  "Mana Percent to Cast At")
		-- Angelic Feather
		br.ui:createSpinner(section, "Angelic Feather",  2,  0,  100,  1,  "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAngelic Feather usage|cffFFBB00.")
		-- Holy Word: Chastise
		br.ui:createCheckbox(section, "Holy Word: Chastise")
		-- Temple of Sethraliss
		br.ui:createSpinner(section, "Temple of Sethraliss", 70,0,100,1, "Will heal the NPC whenever the debuff is removed and party health is above set value.")
		-- Bursting Stack
		br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "", "|cffFFFFFFWhen Bursting stacks are above this amount, CDs will be triggered.")

		br.ui:createCheckbox(section, "Pig Catcher", "Catch the freehold Pig in the ring of booty")
		br.ui:checkSectionState(section)
		-- Dispel and Purify Settings
		section = br.ui:createSection(br.ui.window.profile, colorwarlock.."Dispel and Purify Options")
		-- Dispel Magic
		br.ui:createCheckbox(section,"Dispel Magic","Will dispel enemy's buffs.")
		-- Mass Dispel Hotkey
		br.ui:createDropdown(section,"Mass Dispel Hotkey", br.dropOptions.Toggle, 6, "Hold down the set hotkey and Mass Dispel will be casted at mouse cursor on next GCD.")
		-- Purify
		br.ui:createCheckbox(section,"Purify","Enable use of Purify for removing Magic or Disease debuff.")
		-- Mass Dispel as Purify Alternative
		br.ui:createCheckbox(section,"Mass Dispel Alternative","Use Mass Dispel as an alternative to Purify if it is on cooldown.")
		br.ui:checkSectionState(section)
		-- Cooldown Options
		section = br.ui:createSection(br.ui.window.profile, colorLegendary.."Cooldowns")
		--Holy Word: Salvation
		br.ui:createSpinner(section, "Holy Word: Salvation",  60,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Holy Word: Salvation Targets",  6,  0,  40,  1,  "Minimum Targets below Health Percent before casting.")
		-- Divine Hymn
		br.ui:createSpinner(section, "Divine Hymn",  50,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Divine Hymn Targets",  3,  0,  40,  1,  "Minimum Divine Hymn Targets")
		-- Apotheosis
		br.ui:createSpinner(section, "Apotheosis",  50,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Apotheosis Targets",  3,  0,  40,  1,  "Minimum Apotheosis Targets")
		-- Guardian Spirit
		br.ui:createSpinner(section, "Guardian Spirit",  30,  0,  100,  5,  "Health Percent to Cast At")
		-- Guardian Spirit Tank Only
		br.ui:createCheckbox(section,"Guardian Spirit Tank Only")
		-- Leap of Faith
		br.ui:createSpinner(section, "Leap of Faith",  20,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:checkSectionState(section)
		 -- Essence Options
		section = br.ui:createSection(br.ui.window.profile, "Essence Options")
		 --Concentrated Flame
			br.ui:createSpinner(section, "Concentrated Flame", 75, 0, 100, 5, colorWhite.."Will cast Concentrated Flame if party member is below value. Default: 75")
		 --Memory of Lucid Dreams
			br.ui:createCheckbox(section, "Lucid Dreams")
		-- Ever-Rising Tide
			br.ui:createDropdown(section, "Ever-Rising Tide", { "Always", "Based on Health" }, 1, "When to use this Essence")
            br.ui:createSpinner(section, "Ever-Rising Tide - Mana", 30, 0, 100, 5, "", "Min mana to use")
			br.ui:createSpinner(section, "Ever-Rising Tide - Health", 30, 0, 100, 5, "", "Health threshold to use")
		-- Well of Existence
			br.ui:createCheckbox(section, "Well of Existence")
		-- Life Binder's Invocation
			br.ui:createSpinner(section, "Life-Binder's Invocation", 85, 1, 100, 5, "Health threshold to use")
            br.ui:createSpinnerWithout(section, "Life-Binder's Invocation Targets", 5, 1, 40, 1, "Number of targets to use")
		br.ui:checkSectionState(section)
		-- Defensive Options
		section = br.ui:createSection(br.ui.window.profile, colorwarrior.."Defensive")
		-- Healthstone
		br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		-- Heirloom Neck
		br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at");
		-- Gift of The Naaru
		if br.player.race == "Draenei" then
			br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percentage to use at")
		end
		-- Desperate Prayer
		br.ui:createSpinner(section, "Desperate Prayer",  80,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		--Fade
		br.ui:createSpinner(section, "Fade",  95,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At. Default: 95")
		br.ui:checkSectionState(section)
		-- Healing Options
		section = br.ui:createSection(br.ui.window.profile, colorGreen.."Healing Options")
		-- Prayer of Mending
		br.ui:createSpinner(section, "Prayer of Mending",  100,  0,  100,  1,  "Health Percent to Cast At")
		-- Heal
		br.ui:createSpinner(section, "Heal",  70,  0,  100,  5,  "Health Percent to Cast At")
		-- Flash Heal
		br.ui:createSpinner(section, "Flash Heal",  60,  0,  100,  5,  "Health Percent to Cast At")
		-- Flash Heal Surge of Light
		br.ui:createSpinner(section, "Flash Heal Surge of Light",  80,  0,  100,  5,  "Health Percent to Cast At")
		-- Flash Heal Emergency
		br.ui:createSpinner(section, "Flash Heal Emergency",  40,  0,  100,  5,  "Overrides most settings to prioritize casting Flash Heal")
		-- Flash Heal Emergency Tanks Only
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
		br.ui:createCheckbox(section, "Apotheosis Mode","Will Priotize use of Flash Heal, PoH, or Binding Heal to get Holy Words off CDs")
		br.ui:createSpinner(section, "Apotheosis Binding Heal",  90,  0,  100,  1,  "Use Binding Heal while Apotheosis is active.")
		br.ui:createSpinnerWithout(section, "Serenity and Sanctify CD",  30,  0,  60,  1,  "Only uses Binding Heal if both Serenity and Sanctify CD is above this.")
		br.ui:createSpinnerWithout(section, "Tank Ignore",  50,  0,  100,  1,  "Ignores using Binding Heal during Apotheosis if Tank HP falls below this.")
		br.ui:createSpinner(section, "Apotheosis Flash Heal",  85,  0,  100,  1,  "Use Flash Heal while Apotheosis is active.")
		br.ui:createSpinnerWithout(section, "Apotheosis Serenity CD",  30,  0,  60,  1,  "Use Flash Heal only if Serenity CD is above this.")
		br.ui:createSpinner(section, "Apotheosis Prayer of Healing",  90,  0,  100,  1,  "Use PoH while Apotheosis is active.")
		br.ui:createSpinnerWithout(section, "Apotheosis PoH Targets",  3,  0,  6,  1,  "Use PoH when this many allies are below set HP.")
		br.ui:createSpinnerWithout(section, "Apotheosis PoH CD",  30,  0,  60,  1,  "Use PoH only if Sanctify CD is above this.")
		br.ui:checkSectionState(section)

		section = br.ui:createSection(br.ui.window.profile, colorshaman.."Holy Word Settings")
		-- Holy Word: Serenity
		br.ui:createSpinner(section, "Holy Word: Serenity",  50,  0,  100,  5,  "Health Percent to Cast At")
		-- Holy Word: Sanctify
		br.ui:createSpinner(section, "Holy Word: Sanctify",  80,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Holy Word: Sanctify Targets",  3,  0,  40,  1,  "Minimum Holy Word: Sanctify Targets")
		--br.ui:createCheckbox(section,"Use Old HW Sanctify","Uses the old method of HW Sanctify. Causes no freezes, but less effective than the current method.")
		-- Holy Word: Sanctify Hot Key
		br.ui:createDropdown(section, "Holy Word: Sanctify HK", br.dropOptions.Toggle, 10, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." Holy Word: Sanctify Hot Key Usage.")
		br.ui:checkSectionState(section)
		section = br.ui:createSection(br.ui.window.profile, colordh.."AOE Healing")
		-- Binding Heal
		br.ui:createSpinner(section, "Binding Heal",  70,  0,  100,  5,  "Cast Binding Heal if anyone falls below this HP.")
		-- Binding Heal Player HP
		br.ui:createSpinner(section, "Binding Heal Player HP",  80,  0,  100,  5,  "|cffFFBB00Will only cast if Player HP is below this Percentage.");
		-- Binding Heal Targets
		br.ui:createCheckbox(section, "Binding Heal Multi","Will attempt to only use Binding Heal if there are at least 2 allies injured and below set HP");
		-- Prayer of Healing
		br.ui:createSpinner(section, "Prayer of Healing",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Prayer of Healing Targets",  3,  0,  40,  1,  "Minimum Prayer of Healing Targets")
		-- Circle of Healing
		br.ui:createSpinner(section, "Circle of Healing",  75,  0,  100,  5,  "Health Percent to Cast At")
        	br.ui:createSpinnerWithout(section, "Circle of Healing Targets",  3,  0,  40,  1,  "Minimum Circle of Healing Targets")
		-- Divine Star
		br.ui:createSpinner(section, "Divine Star",  80,  0,  100,  5,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Divine Star usage.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Divine Star Targets",  3,  1,  40,  1,  colorBlue.."Minimum Divine Star Targets "..colorGold.."(This includes you)")
		-- Halo
		br.ui:createSpinner(section, "Halo",  70,  0,  100,  5,  "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Halo Targets",  3,  0,  40,  1,  "Minimum Halo Targets")
		br.ui:checkSectionState(section)
		-- Player Emergency Healing
		section = br.ui:createSection(br.ui.window.profile, colorRed.."Self-Heal Emergency")
		br.ui:createSpinner(section, "Serenity On Me",  25,  0,  100,  5,  "Will prioritize using Serenity on myself once CD is up or when it is available if my HP drops below this")
		br.ui:createSpinner(section, "Binding Heal On Me",  25,  0,  100,  5,  "Will spam Binding Heal and ignores the rest of the rotation when my HP is below this. If this option is enabled. Most likely the Flash Heal On Me option will not work.")
		br.ui:createSpinner(section, "Flash Heal On Me",  25,  0,  100,  5,  "Will spam Flash Heal when my HP is below this.")
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
	if br.timer:useTimer("debugHoly", 0.1) then
		--Print("Running: "..rotationName)
		--------------
		--- Locals ---
		--------------
		local artifact                                      = br.player.artifact
		local buff                                          = br.player.buff
		local cast                                          = br.player.cast
		local combatTime                                    = getCombatTime()
		local cd                                            = br.player.cd
		local charges                                       = br.player.charges
		local debuff                                        = br.player.debuff
		local enemies                                       = br.player.enemies
		local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), isMoving("player")
		local essence										= br.player.essence
		local gcd                                           = br.player.gcd
		local gcdMax                                        = br.player.gcdMax
		local healPot                                       = getHealthPot()
		local inCombat                                      = br.player.inCombat
		local inInstance                                    = br.player.instance=="party"
		local inRaid                                        = br.player.instance=="raid"
		local lastSpell                                     = lastSpellCast
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

		local lowest                                        = {}    --Lowest Unit
		lowest.hp                                           = br.friend[1].hp
		lowest.role                                         = br.friend[1].role
		lowest.unit                                         = br.friend[1].unit
		lowest.range                                        = br.friend[1].range
		lowest.guid                                         = br.friend[1].guid
		local friends                                       = friends or {}
		local tank                                          = {}    --Tank
		local averageHealth                                 = 0
		local tanks = getTanksTable()
		local burst = nil

		units.get(5)
		units.get(8,true)
		units.get(40)

		enemies.get(5)
		enemies.get(8)
		enemies.get(8,"target")
		enemies.get(40)
		friends.yards40 = getAllies("player",40)

		if inInstance and select(3, GetInstanceInfo()) == 8 then
            for i = 1, #tanks do
                local ourtank = tanks[i].unit
                local Burststack = getDebuffStacks(ourtank, 240443)
                if Burststack >= getOptionValue("Bursting") then
                    burst = true
                    break
                else 
                    burst = false
                end
            end
        end

		renewCount = 0
		for i=1, #br.friend do
			local renewRemain = getBuffRemain(br.friend[i].unit,spell.buffs.renew,"player") or 0 -- Spell ID 139
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


		--------------------
		--- Action Lists ---
		--------------------
		-- Action List - Extras
		local function actionList_Extras()
			-- Dummy Test
			if isChecked("DPS Testing") then
				if GetObjectExists("target") then
					if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
						profileStop = true
					end
				end
			end -- End Dummy Test
			if isChecked("Resurrection") and not inCombat and not isMoving("player") and br.timer:useTimer("Resurrect", 4) then
				if getOptionValue("Resurrection - Target") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
					if cast.resurrection("target", "dead") then
						br.addonDebug("Casting Resurrection (Target)")
						return true
					end
				end
				if getOptionValue("Resurrection - Target") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
					if cast.resurrection("mouseover", "dead") then
						br.addonDebug("Casting Resurrection (Mouseover)")
						return true
					end
				end
				if getOptionValue("Resurrection - Target") == 3 then
					local deadPlayers = {}
					for i =1, #br.friend do
						if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) then
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
			if IsMovingTime(getOptionValue("Angelic Feather")) then
				if isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") then
					if cast.angelicFeather("player") then
						br.addonDebug("Casting Angelic Feather")
						SpellStopTargeting()
					end
				end
			end
			-- Pre-Pull Timer
			if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
				if pullTimer <= getOptionValue("Pre-Pull Timer") then
					if hasItem(166801) and canUseItem(166801) then
						br.addonDebug("Using Sapphire of Brilliance")
						useItem(166801)
					end
					if canUseItem(142117) and not buff.prolongedPower.exists() then
						useItem(142117);
						br.addonDebug("Using Prolonged Power")
						return
					end
				end
			end
			-- Mass Dispel
			if isChecked("Mass Dispel Hotkey") and (SpecificToggle("Mass Dispel Hotkey") and not GetCurrentKeyBoardFocus()) then
				CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
				br.addonDebug("Casting Mass Dispel")
				return
			end
			if isChecked("Power Word: Fortitude") and br.timer:useTimer("PW:F Delay", math.random(120,300)) then
                for i = 1, #br.friend do
                    if not buff.powerWordFortitude.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                        if cast.powerWordFortitude() then br.addonDebug("Casting Power Word: Fortitude") return end
                    end
                end
			end
			if isChecked("Pig Catcher") then
                bossHelper()
            end
		end -- End Action List - Extras
		-- Action List - Pre-Combat
		function actionList_OOCHealing()
			-- Renew on tank
			if isChecked("Renew on Tanks")  then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Renew on Tanks") and not buff.renew.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
			-- Renew
			if isChecked("Renew") and renewCount < getOptionValue("Renew Limit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Renew") and not buff.renew.exists(br.friend[i].unit) then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
			-- Heal
			if isChecked("Heal") then
				if lowest.hp <= getValue("Heal") and not moving then
					if cast.heal(lowest.unit) then br.addonDebug("Casting Heal") return end
				end
			end
			-- Flash Heal
			if isChecked("Flash Heal") and getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= getValue("Flash Heal") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal") return end
				end
			end
			-- Flash Heal Surge of Light
			if isChecked("Flash Heal Surge of Light") and talent.surgeOfLight and buff.surgeOfLight.exists() then
				if lowest.hp <= getValue("Flash Heal Surge of Light") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal (Surge of Light)") return end
				end
			end
			-- Renew While Moving
			if isChecked("Renew while moving") and moving  then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Renew while moving") and not buff.renew.exists(br.friend[i].unit) then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
		end  -- End Action List - Pre-Combat
		local function actionList_Defensive()
			if useDefensive() then
				-- Healthstone
				if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
					if canUseItem(5512) then
						br.addonDebug("Using Healthstone")
						useItem(5512)
					elseif canUseItem(healPot) then
						br.addonDebug("Using Health Pot")
						useItem(healPot)
					elseif hasItem(166799) and canUseItem(166799) then
						br.addonDebug("Using Emerald of Vigor")
						useItem(166799)
					end
				end
				-- Heirloom Neck
				    if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
				        if hasEquiped(122668) then
				            if GetItemCooldown(122668)==0 then
								useItem(122668)
								br.addonDebug("Using Heirloom Neck")
				            end
				        end
				    end
				--Fade
				if isChecked("Fade") then
					if php <= getValue("Fade") then
						if cast.fade() then br.addonDebug("Casting Fade") return end
					end
				end
				-- Mana Potion Channeled
				if isChecked("Mana Potion Channeled") and mana <= getValue("Mana Potion Channeled")then
					if hasItem(152561) then
						useItem(152561)
						br.addonDebug("Using Mana Potion")
					end
				end
				-- Gift of the Naaru
				--    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
				--        if castSpell("player",racial,false,false,false) then return end
				--    end
				-- Desperate Prayer
				if isChecked("Desperate Prayer") and php <= getOptionValue("Desperate Prayer") then
					if cast.desperatePrayer() then br.addonDebug("Casting Desperate Prayer") return end
				end
			end -- End Defensive Toggle
		end -- End Action List - Defensive
		function actionList_Cooldowns()
			if useCDs() then
				if hasItem(166801) and canUseItem(166801) then
					br.addonDebug("Using Sapphire of Brilliance")
					useItem(166801)
				end
				--Salvation
				if isChecked("Holy Word: Salvation") and not moving then
					if getLowAllies(getValue("Holy Word: Salvation")) >= getValue("Holy Word: Salvation Targets") or burst == true then
						if cast.holyWordSalvation() then br.addonDebug("Casting Holy Word: Salvation") return end
					end
				end
				-- Divine Hymn
				if isChecked("Divine Hymn") and not moving then
					if getLowAllies(getValue("Divine Hymn")) >= getValue("Divine Hymn Targets") or burst == true then
						if cast.divineHymn() then br.addonDebug("Casting Divine Hymn") return end
					end
				end
				-- Apotheosis
				if isChecked("Apotheosis") then
					if getLowAllies(getValue("Apotheosis")) >= getValue("Apotheosis Targets") or burst == true then
						if cast.apotheosis() then br.addonDebug("Casting Apothesis") return end
					end
				end	
				--  Lucid Dream
				if isChecked("Lucid Dreams") and essence.memoryOfLucidDreams.active and mana <= 85 and getSpellCD(298357) <= gcdMax then
					if cast.memoryOfLucidDreams("player") then br.addonDebug("Casting Memory of Lucid Dreams") return end
				end
				-- Trinkets
				if isChecked("Revitalizing Voodoo Totem") and hasEquiped(158320) and lowest.hp < getValue("Revitalizing Voodoo Totem") then
					if GetItemCooldown(158320) <= gcdMax then
						UseItemByName(158320, lowest.unit)
						br.addonDebug("Using Revitalizing Voodoo Totem")
					end
				end
				if isChecked("Inoculating Extract") and hasEquiped(160649) and lowest.hp < getValue("Inoculating Extract") then
					if GetItemCooldown(160649) <= gcdMax then
						UseItemByName(160649, lowest.unit)
						br.addonDebug("Using Inoculating Extract")
					end
				end
				if isChecked("Ward of Envelopment") and hasEquiped(165569) and GetItemCooldown(165569) <= gcdMax then
					-- get melee players
					for i = 1, #tanks do
						-- get the tank's target
						local tankTarget = UnitTarget(tanks[i].unit)
						if tankTarget ~= nil then
							-- get players in melee range of tank's target
							local meleeFriends = getAllies(tankTarget, 5)
							-- get the best ground circle to encompass the most of them
							local loc = nil
							if #meleeFriends >= 8 then
								loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
							else
								local meleeHurt = {}
								for j = 1, #meleeFriends do
									if meleeFriends[j].hp < 75 then
										tinsert(meleeHurt, meleeFriends[j])
									end
								end
								if #meleeHurt >= 2 then
									loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
								end
							end
							if loc ~= nil then
								useItem(165569)
								local px,py,pz = ObjectPosition("player")
								loc.z = select(3,TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
								if loc.z ~= nil and TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions 
									ClickPosition(loc.x, loc.y, loc.z)
									br.addonDebug("Using Ward of Envelopment")
									return
								end
							end
						end
					end
				end
				--Pillar of the Drowned Cabal
				if hasEquiped(167863) and canUseItem(16) then
					if not UnitBuffID(lowest.unit,295411) and lowest.hp < 75 then
						UseItemByName(167863,lowest.unit)
						br.addonDebug("Using Pillar of Drowned Cabal")
					end
				end
				if isChecked("Trinket 1") and canTrinket(13) and not hasEquiped(165569,13) and not hasEquiped(160649,13) and not hasEquiped(158320,13) then
					if getOptionValue("Trinket 1 Mode") == 1 then
						if getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") or burst == true then
							useItem(13)
							br.addonDebug("Using Trinket 1")
							return true
						end
						elseif getOptionValue("Trinket 1 Mode") == 2 then
							if (lowest.hp <= getValue("Trinket 1") or burst == true) and lowest.hp ~= 250 then
							UseItemByName(GetInventoryItemID("player", 13), lowest.unit)
							br.addonDebug("Using Trinket 1 (Target)")
							return true
							end
						elseif getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
							for i = 1, #tanks do
								-- get the tank's target
								local tankTarget = UnitTarget(tanks[i].unit)
								if tankTarget ~= nil then
								-- get players in melee range of tank's target
								local meleeFriends = getAllies(tankTarget, 5)
								-- get the best ground circle to encompass the most of them
								local loc = nil
								if #meleeFriends < 12 then
									loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
								else
									local meleeHurt = {}
									for j = 1, #meleeFriends do
									if meleeFriends[j].hp < getValue("Trinket 1") then
										tinsert(meleeHurt, meleeFriends[j])
									end
									end
									if #meleeHurt >= getValue("Min Trinket 1 Targets") or burst == true then
									loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
									end
								end
								if loc ~= nil then
									useItem(13)
									br.addonDebug("Using Trinket 1 (Ground)")
									local px,py,pz = ObjectPosition("player")
									loc.z = select(3,TraceLine(loc.x, loc.y, loc.z+5, loc.x, loc.y, loc.z-5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
									if loc.z ~= nil and TraceLine(px, py, pz+2, loc.x, loc.y, loc.z+1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z+4, loc.x, loc.y, loc.z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 collisions
										ClickPosition(loc.x, loc.y, loc.z)
										return true
									end
								end
							end
						end
					end
				end
				if isChecked("Trinket 2") and canTrinket(14) and not hasEquiped(165569,14) and not hasEquiped(160649,14) and not hasEquiped(158320,14) then
					if getOptionValue("Trinket 2 Mode") == 1 then
						if getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") or burst == true then
							useItem(14)
							br.addonDebug("Using Trinket 2")
							return true
						end
						elseif getOptionValue("Trinket 2 Mode") == 2 then
							if (lowest.hp <= getValue("Trinket 2") or burst == true) and lowest.hp ~= 250 then
							UseItemByName(GetInventoryItemID("player", 14), lowest.unit)
							br.addonDebug("Using Trinket 2 (Target)")
							return true
							end
						elseif getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
							for i = 1, #tanks do
								-- get the tank's target
								local tankTarget = UnitTarget(tanks[i].unit)
								if tankTarget ~= nil then
								-- get players in melee range of tank's target
								local meleeFriends = getAllies(tankTarget, 5)
								-- get the best ground circle to encompass the most of them
								local loc = nil
								if #meleeFriends < 12  then
									loc = getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
								else
									local meleeHurt = {}
									for j = 1, #meleeFriends do
									if meleeFriends[j].hp < getValue("Trinket 2") then
										tinsert(meleeHurt, meleeFriends[j])
									end
									end
									if #meleeHurt >= getValue("Min Trinket 2 Targets") or burst == true then
									loc = getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
									end
								end
								if loc ~= nil then
									useItem(14)
									br.addonDebug("Using Trinket 2 (Ground)")
									ClickPosition(loc.x, loc.y, loc.z)
									return true
								end
							end
						end
					end
				end
				if isChecked("Life-Binder's Invocation") and essence.lifeBindersInvocation.active and cd.lifeBindersInvocation.remain() <= gcd and getLowAllies(getOptionValue("Life-Binder's Invocation")) >= getOptionValue("Life-Binder's Invocation Targets") then
					if cast.lifeBindersInvocation() then
						br.addonDebug("Casting Life-Binder's Invocation")
						return true
					end
				end
				if isChecked("Ever-Rising Tide") and essence.overchargeMana.active and cd.overchargeMana.remain() <= gcd and getOptionValue("Ever-Rising Tide - Mana") <= mana then
					if getOptionValue("Ever-Rising Tide") == 1 then
						if cast.overchargeMana() then
							return
						end
					end
					if getOptionValue("Ever-Rising Tide") == 2 then
						if lowest.hp < getOptionValue("Ever Rising Tide - Health") or burst == true then
							if cast.overchargeMana() then
								return
							end
						end
					end
				end
				-- Racial: Blood Elf Arcane Torrent
				if isChecked("Arcane Torrent") and inCombat and (br.player.race == "BloodElf") and mana <= getValue("Arcane Torrent Mana") then
					if castSpell("player",racial,false,false,false) then br.addonDebug("Casting Racial") return end
				end
			end -- End useCooldowns check
		end -- End Action List - Cooldowns
		-- Dispel
		function actionList_Dispel()
			-- Purify
			if br.player.ui.mode.purify == 1 then
				if isChecked("Purify") then
					for i = 1, #br.friend do
						if getSpellCD(spell.purify) > 1 and isChecked("Mass Dispel Alternative") and canDispel(br.friend[i].unit, spell.massDispel)	then
							if castGround(br.friend[i].unit, spell.massDispel, 30) then br.addonDebug("Casting Mass Dispel") return end
						elseif canDispel(br.friend[i].unit, spell.purify) then
							if cast.purify(br.friend[i].unit) then br.addonDebug("Casting Purify") return end
						end
					end
				end
			end
			-- Mass Dispel
			if isChecked("Mass Dispel Hotkey") and (SpecificToggle("Mass Dispel Hotkey") and not GetCurrentKeyBoardFocus()) then
				CastSpellByName(GetSpellInfo(spell.massDispel),"cursor")
				br.addonDebug("Casting Mass Dispel")
				return
			end
		end -- End Action List - Dispel
		-- Emergency
		function actionList_Emergency()
			-- Guardian Spirit
			if isChecked("Guardian Spirit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Guardian Spirit") then
						if br.friend[i].role == "TANK" or not isChecked("Guardian Spirit Tank Only") then
							if cast.guardianSpirit(br.friend[i].unit) then br.addonDebug("Casting Guardian Spirit") return end
						end
					end
				end
			end
			-- Serenity On Me Emergency
			if isChecked("Serenity On Me") and php <= getOptionValue("Serenity On Me") then
				if cast.holyWordSerenity("player") then br.addonDebug("Casting Holy Word: Serenity") return end
			end
			-- Holy Word: Serenity
			if isChecked("Holy Word: Serenity") then
				if lowest.hp <= getValue("Holy Word: Serenity") then
					if cast.holyWordSerenity(lowest.unit) then br.addonDebug("Casting Holy Word: Serenity") return end
				end
			end
			-- Binding Heal On Me
			if isChecked("Binding Heal On Me") and talent.bindingHeal and php <= getValue("Binding Heal On Me") and getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= getValue("Binding Heal On Me") then
					if cast.bindingHeal(lowest.unit) then
						SpellStopTargeting()
						br.addonDebug("Casting Binding Heal")
						return
					end
				end
			end
			-- Flash Heal On Me
			if isChecked("Flash Heal On Me") and inCombat and not moving and php <= getValue("Flash Heal On Me") then
				if cast.flashHeal("player") then br.addonDebug("Casting Flash Heal") return end
			end
			--Apotheosis Mode
			if isChecked("Apotheosis Mode") and getBuffRemain("player",200183) > 0 then
				for i = 1, #br.friend do
					if (isChecked("Tank Ignore") and isChecked("Apotheosis Binding Heal") and br.friend[i].hp >= getValue("Tank Ignore") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") or (not isChecked("Tank Ignore") and isChecked("Apotheosis Binding Heal"))) and not moving then
						if br.friend[i].hp <= getValue("Apotheosis Binding Heal") and GetSpellCooldown(2050) > getValue("Serenity and Sanctify CD") and GetSpellCooldown(34861) > getValue("Serenity and Sanctify CD") then
							if cast.bindingHeal(br.friend[i].unit) then br.addonDebug("Casting Binding Heal") return end
						end
					end
					if isChecked("Apotheosis Flash Heal") and br.friend[i].hp <= getValue("Apotheosis Flash Heal") and GetSpellCooldown(2050) > getValue("Apotheosis Serenity CD") and not moving then
						if cast.flashHeal(br.friend[i].unit) then br.addonDebug("Casting Flash Heal") return end
					end
					if isChecked("Apotheosis Prayer of Healing") and getLowAllies(getValue("Apotheosis Prayer of Healing")) >= getValue("Apotheosis PoH Targets") and GetSpellCooldown(34861) > getValue("Apotheosis Sanctify CD") and not moving then
						if cast.prayerOfHealing(lowest.unit) then br.addonDebug("Casting Prayer of Healing") return end
					end
				end
			end
			-- Flash Heal Others
			if isChecked("Flash Heal Emergency") and getDebuffRemain("player",240447) == 0 and not moving then
				for i = 1, #br.friend do
					if isChecked("Tanks Only") then
						if br.friend[i].hp <= getValue("Flash Heal Emergency") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
							if cast.flashHeal(br.friend[i].unit) then br.addonDebug("Casting Flash Heal") return end
						end
					elseif br.friend[i].hp <= getValue("Flash Heal Emergency") then
						if cast.flashHeal(br.friend[i].unit) then br.addonDebug("Casting Flash Heal") return end
					end
				end
			end
		end -- EndAction List Emergency
		local function actionList_SoR()
			--Guardian Spirit
			if isChecked("Guardian Spirit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Guardian Spirit") then
						if br.friend[i].role == "TANK" or not isChecked("Guardian Spirit Tank Only") then
							if cast.guardianSpirit(br.friend[i].unit) then br.addonDebug("Casting Guardian Spirit") return end
						end
					end
				end
			end
			-- Prayer of Healing
			if getLowAllies(getOptionValue("Prayer of Healing")) >= 4 then
				if castWiseAoEHeal(br.friend,spell.prayerOfHealing,40,getValue("Prayer of Healing"),4,5,false,true) then br.addonDebug("Casting Prayer of Healing") return end
			end
			-- Holy Word Serenity
			if lowest.hp <= getOptionValue("Holy Word: Serenity") then
				if cast.holyWordSerenity(lowest.unit) then br.addonDebug("Casting Holy Word: Serenity") return end
			end
			-- Flash Heal
			if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal") return end
		end
	-- Temple of Sethraliss
		if inCombat and isChecked("Temple of Sethraliss") and br.player.eID and br.player.eID == 2127 then
			for i = 1, GetObjectCountBR() do
				local thisUnit = GetObjectWithIndex(i)
				if GetObjectID(thisUnit) == 133392 then
					sethObject = thisUnit
					if getHP(sethObject) < 100 and getBuffRemain(sethObject,274148) == 0 then
						if not buff.renew.exists(sethObject) then
							if CastSpellByName(GetSpellInfo(139),sethObject) then br.addonDebug("Casting Renew") return end
						end
						if GetSpellCooldown(2050) == 0 and not moving then
							if CastSpellByName(GetSpellInfo(2050),sethObject) then br.addonDebug("Casting Holy Word: Serenity") return end
						end
						if GetSpellCooldown(32546) == 0 and talent.bindingHeal and not moving then
							if CastSpellByName(GetSpellInfo(32546),sethObject) then br.addonDebug("Casting Binding Heal") return end
						end
						if GetSpellCooldown(2060) == 0 and not moving then
							if CastSpellByName(GetSpellInfo(2060),sethObject) then br.addonDebug("Casting Heal") return end
						end
					end
				end
			end
		end
		-- AOE Healing
		function actionList_AOEHealing()
			-- Holy Word: Serenity
			if isChecked("Holy Word: Serenity") then
				if lowest.hp <= getValue("Holy Word: Serenity") then
					if cast.holyWordSerenity(lowest.unit) then br.addonDebug("Casting Holy Word: Serenity") return end
				end
			end
			-- Holy Word: Sanctify JR Locals
			local sanctifyCandidates = {}
			--if not isChecked("Use Old HW Sanctify") then
				for i=1, #friends.yards40 do
					if cd.holyWordSanctify.remain() == 0 and friends.yards40[i].hp < getValue("Holy Word: Sanctify") then
						tinsert(sanctifyCandidates,friends.yards40[i])
					end
				end
			-- Holy Word: Sanctify
				if cd.holyWordSanctify.remain() == 0 and #sanctifyCandidates >= getValue("Holy Word: Sanctify Targets") then
					local loc
					-- get the best ground location to heal most or all of them
					if #sanctifyCandidates < 12 then
						loc = getBestGroundCircleLocation(sanctifyCandidates,getValue("Holy Word: Sanctify Targets"),6,10)
					else
						if castWiseAoEHeal(br.friend,spell.holyWordSanctify,10,getValue("Holy Word: Sanctify"),getValue("Holy Word: Sanctify Targets"),6,false,false) then br.addonDebug("Casting Holy Word: Sanctify") return end
					end
					if loc ~= nil then
						if castGroundAtLocation(loc, spell.holyWordSanctify) then br.addonDebug("Casting Holy Word: Sanctify") return end
					end
				end
			--end

			-- Prayer of Mending
			if isChecked("Prayer of Mending") and getDebuffRemain("player",240447) == 0 and not moving  then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Prayer of Mending") and not buff.prayerOfMending.exists(br.friend[i].unit) then
						if cast.prayerOfMending(br.friend[i].unit) then br.addonDebug("Casting Prayer of Mending") return end
					end
				end
			end
			-- Renew on tank
			if isChecked("Renew on Tanks") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Renew on Tanks") and not buff.renew.exists(br.friend[i].unit) and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
			-- Holy Word: Sanctify Hot Key
			if isChecked("Holy Word: Sanctify HK") and (SpecificToggle("Holy Word: Sanctify HK") and not GetCurrentKeyBoardFocus()) then
				CastSpellByName(GetSpellInfo(spell.holyWordSanctify),"cursor")
				br.addonDebug("Casting Holy Word: Sanctify")
				return
			end
			-- Circle of Healing
			if isChecked("Circle of Healing") and talent.circleOfHealing and not moving then
				if getLowAllies(getValue("Circle of Healing")) >= getValue("Circle of Healing Targets") then
					if cast.circleOfHealing() then br.addonDebug("Casting Circle Of Healing") return end
				end
			end	
			--Halo
			if isChecked("Halo") and talent.halo and not moving then
				if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then
					if cast.halo() then br.addonDebug("Casting Halo") return end
				end
			end			
			-- Prayer of Healing
			if isChecked("Prayer of Healing") and getDebuffRemain("player",240447) == 0 and not moving then
				if castWiseAoEHeal(br.friend,spell.prayerOfHealing,40,getValue("Prayer of Healing"),getValue("Prayer of Healing Targets"),5,false,true) then br.addonDebug("Casting Prayer of Healing") return end
			end
			-- Divine Star
			if isChecked("Divine Star") and talent.divineStar and not moving then
				if getUnitsInRect(5,24,false,getOptionValue("Divine Star")) >= getOptionValue("Min Divine Star Targets") then
					if cast.divineStar() then br.addonDebug("Casting Divine Star") return end
				end
			end
			--JR Binding Heal Scan
			local bindingHealCandidates = {}
			if isChecked("Binding Heal Multi") then
				for i=1, #friends.yards40 do
					if friends.yards40[i].hp < getValue("Binding Heal") then
						tinsert(bindingHealCandidates,friends.yards40[i])
					end
				end
			end
			-- Binding Heal JR
			if isChecked("Binding Heal Multi") and isChecked("Binding Heal")  then
				if talent.bindingHeal and not moving and #bindingHealCandidates >= 2 then
					for i=1, #tanks do
						thisTank = tanks[i]
						if thisTank.hp <= getValue("Binding Heal") and not GetUnitIsUnit(thisTank.unit,"player") and (php <= getValue("Binding Heal Player HP") or not isChecked("Binding Heal Player HP"))and getDistance(thisTank.unit) <= 40 then
							if cast.bindingHeal(thisTank.unit, "aoe") then br.addonDebug("Casting Binding Heal") return end
						end
					end
					if lowest.hp <= getValue("Binding Heal") and not GetUnitIsUnit(lowest.unit,"player") and (php <= getValue("Binding Heal Player HP") or not isChecked("Binding Heal Player HP")) then
						if cast.bindingHeal(lowest.unit, "aoe") then br.addonDebug("Casting Binding Heal") return end
					end
				end
			end
			-- Binding Heal Single
			if isChecked("Binding Heal") and not isChecked("Binding Heal Multi") and talent.bindingHeal and (php <= getValue("Binding Heal Player HP") or not isChecked("Binding Heal Player HP")) and getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= getValue("Binding Heal") then
					if cast.bindingHeal(lowest.unit) then
						SpellStopTargeting()
						br.addonDebug("Casting Binding Heal")
						return
					end
				end
			end
			-- Renew
			if isChecked("Renew") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Renew") and not buff.renew.exists(br.friend[i].unit) and not isChecked("Renew Limit") then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
					if br.friend[i].hp <= getValue("Renew") and not buff.renew.exists(br.friend[i].unit) and isChecked("Renew Limit") and renewCount < getValue("Renew Limit") then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
		end -- End Action List - AOE Healing
		-- Single Target
		function actionList_SingleTarget()
			-- Guardian Spirit
			if isChecked("Guardian Spirit") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Guardian Spirit") then
						if br.friend[i].role == "TANK" or not isChecked("Guardian Spirit Tank Only") then
							if cast.guardianSpirit(br.friend[i].unit) then br.addonDebug("Casting Guardian Spirit") return end
						end
					end
				end
			end
			-- Leap of Faith
			if isChecked("Leap of Faith") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Leap of Faith") and not GetUnitIsUnit(br.friend[i].unit,"player") and br.friend[i].role ~= "TANK" then
						if cast.leapOfFaith(br.friend[i].unit) then br.addonDebug("Casting Leap of Faith") return end
					end
				end
			end
			-- Concentrated Flame
			if isChecked("Concentrated Flame") and essence.concentratedFlame.active and getSpellCD(295373) <= gcdMax then
				if lowest.hp <= getValue("Concentrated Flame") then
					if cast.concentratedFlame(lowest.unit) then br.addonDebug("Casting Concentrated Flame") return end
				end
			end
			-- Refreshment
            if isChecked("Well of Existence") and essence.refreshment.active and cd.refreshment.remain() <= gcdMax and UnitBuffID("player",296138) and select(16,UnitBuffID("player",296138,"EXACT")) >= 15000 and lowest.hp <= getValue("Flash Heal") then
                if cast.refreshment(lowest.unit) then br.addonDebug("Casting Refreshment") return true end
            end
			-- Flash Heal
			if isChecked("Flash Heal") and getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= getValue("Flash Heal") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal") return end
				end
			end
			-- Flash Heal Surge of Light
			if isChecked("Flash Heal Surge of Light") and talent.surgeOfLight and buff.surgeOfLight.remain() > 1.5 then
				if lowest.hp <= getValue("Flash Heal Surge of Light") then
					if cast.flashHeal(lowest.unit) then br.addonDebug("Casting Flash Heal (Surge of Light)") return end
				end
			end
			-- Heal
			if isChecked("Heal") and getDebuffRemain("player",240447) == 0 and not moving then
				if lowest.hp <= getValue("Heal") then
					if cast.heal(lowest.unit) then br.addonDebug("Casting Heal") return end
				end
			end
			-- Dispel Magic
			if isChecked("Dispel Magic") then
				for i = 1, #enemies.yards40 do
					local thisUnit = enemies.yards40[i]
					if canDispel(enemies.yards40[i],spell.dispelMagic) and lowest.hp > 40 then
						if cast.dispelMagic() then br.addonDebug("Casting Dispel Magic") return end
					end
				end
			end
			-- Renew While Moving
			if isChecked("Renew while moving") and moving then
				for i = 1, #br.friend do
					if  isChecked("Renew Limit") and renewCount < getValue("Renew Limit") then
						if br.friend[i].hp <= getValue("Renew while moving") and not buff.renew.exists(br.friend[i].unit) then
							if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
						end
					elseif br.friend[i].hp <= getValue("Renew while moving") and not buff.renew.exists(br.friend[i].unit) then
						if cast.renew(br.friend[i].unit) then br.addonDebug("Casting Renew") return end
					end
				end
			end
			-- Moving
			if IsMovingTime(1) then
				if isChecked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") then
					if cast.angelicFeather("player") then
						SpellStopTargeting()
						br.addonDebug("Casting Angelic Feather")
						return
					end
				end
			end
		end -- End Action List - Single Target
		-- DPS
		function actionList_DPS()
			-- Holy Word: Chastise
			if isChecked("Holy Word: Chastise") then
				if cast.holyWordChastise() then br.addonDebug("Casting Holy Word: Chastise") return end
			end
			-- Holy Fire
			if cast.holyFire() then br.addonDebug("Casting Holy Fire") return end
			-- Divine Star
			if getEnemiesInRect(5,24) >= getOptionValue("Min Divine Star Targets") then
				if cast.divineStar() then br.addonDebug("Casting Divine Star") return end
			end
			-- Smite
			if #enemies.yards8 < 3 and getDebuffRemain("player",240447) == 0 and not moving then
				if cast.smite() then br.addonDebug("Casting Smite") return end
			end
			-- Holy Nova
			if #enemies.yards8 >= 3 and level > 25 then
				if cast.holyNova() then br.addonDebug("Casting Holy Nova") return end
			end
		end
		if br.data.settings[br.selectedSpec][br.selectedProfile]['HE ActiveCheck'] == false and br.timer:useTimer("Error delay",0.5) then
            Print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
            return
        end
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
			if not inCombat and not IsMounted() then
				actionList_Extras()
				actionList_Dispel()
				if isChecked("OOC Healing") then
					actionList_OOCHealing()
				end
			end -- End Out of Combat Rotation
			-----------------------------
			--- In Combat - Rotations ---
			-----------------------------
			if inCombat and not IsMounted() then
				if buff.spiritOfRedemption.exists() then
					br.addonDebug("SoR Detected")
					actionList_SoR()
				end
				if not buff.spiritOfRedemption.exists() then
					actionList_Defensive()
					actionList_Cooldowns()
					actionList_Dispel()
					actionList_Emergency()
					actionList_AOEHealing()
					actionList_SingleTarget()
					if br.player.ui.mode.dPS == 1 then
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

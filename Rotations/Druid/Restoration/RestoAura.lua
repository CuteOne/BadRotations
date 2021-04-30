local rotationName = "Aura"

---------------
--- Toggles ---
---------------
local function createToggles()
	-- Cooldown Button
	local CreateButton = br["CreateButton"]
	br.CooldownModes = {
		[1] = {
			mode = "Auto",
			value = 1,
			overlay = "Cooldowns Automated",
			tip = "Automatic Cooldowns - Boss Detection",
			highlight = 1,
			icon = br.player.spell.tranquility
		},
		[2] = {
			mode = "On",
			value = 1,
			overlay = "Cooldowns Enabled",
			tip = "Cooldowns used regardless of target",
			highlight = 0,
			icon = br.player.spell.tranquility
		},
		[3] = {
			mode = "Off",
			value = 3,
			overlay = "Cooldowns Disabled",
			tip = "No Cooldowns will be used",
			highlight = 0,
			icon = br.player.spell.tranquility
		}
	}
	CreateButton("Cooldown", 1, 0)
	-- Defensive Button
	br.DefensiveModes = {
		[1] = {
			mode = "On",
			value = 1,
			overlay = "Defensive Enabled",
			tip = "Includes Defensive Cooldowns",
			highlight = 1,
			icon = br.player.spell.barkskin
		},
		[2] = {
			mode = "Off",
			value = 2,
			overlay = "Defensive Disabled",
			tip = "No Defensives will be used",
			highlight = 0,
			icon = br.player.spell.barkskin
		}
	}
	CreateButton("Defensive", 2, 0)
	-- Decurse Button
	br.DecurseModes = {
		[1] = {
			mode = "On",
			value = 1,
			overlay = "Decurse Enabled",
			tip = "Decurse Enabled",
			highlight = 1,
			icon = br.player.spell.naturesCure
		},
		[2] = {
			mode = "Off",
			value = 2,
			overlay = "Decurse Disabled",
			tip = "Decurse Disabled",
			highlight = 0,
			icon = br.player.spell.naturesCure
		}
	}
	CreateButton("Decurse", 3, 0)
	-- Interrupt Button
	br.InterruptModes = {
		[1] = {
			mode = "On",
			value = 1,
			overlay = "Interrupts Enabled",
			tip = "Includes Basic Interrupts.",
			highlight = 1,
			icon = br.player.spell.mightyBash
		},
		[2] = {
			mode = "Off",
			value = 2,
			overlay = "Interrupts Disabled",
			tip = "No Interrupts will be used.",
			highlight = 0,
			icon = br.player.spell.mightyBash
		}
	}
	CreateButton("Interrupt", 4, 0)
	-- DPS Button
	br.DPSModes = {
		[2] = {
			mode = "On",
			value = 1,
			overlay = "DPS Enabled",
			tip = "DPS Enabled",
			highlight = 1,
			icon = br.player.spell.rake
		},
		[1] = {
			mode = "Off",
			value = 2,
			overlay = "DPS Disabled",
			tip = "DPS Disabled",
			highlight = 0,
			icon = br.player.spell.regrowth
		}
	}
	CreateButton("DPS", 5, 0)
	-- Prehot Button
	br.PrehotModes = {
		[1] = {
			mode = "On",
			value = 1,
			overlay = "Pre-Hot",
			tip = "Pre-hot Enabled",
			highlight = 0,
			icon = br.player.spell.rejuvenation
		},
		[2] = {
			mode = "Tank",
			value = 2,
			overlay = "Pre-Hot",
			tip = "Pre-hot on TANK",
			highlight = 0,
			icon = br.player.spell.rejuvenation
		},
		[3] = {
			mode = "Off",
			value = 3,
			overlay = "Pre-Hot",
			tip = "Pre-hots disabled",
			highlight = 0,
			icon = br.player.spell.rejuvenation
		}
	}
	CreateButton("Prehot", 6, 0)
end

--------------
--- COLORS ---
--------------
local colorBlue = "|cff00CCFF"
local colorGreen = "|cff00FF00"
local colorRed = "|cffFF0000"
local colorWhite = "|cffFFFFFF"
local colorGold = "|cffFFDD11"
local colorYellow = "|cffFFFF00"

---------------
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable

	local function rotationOptions()
		local section
		-- General Options
		section = br.ui:createSection(br.ui.window.profile, "General - Version 1.01")
		br.ui:createCheckbox(
			section,
			"OOC Healing",
			"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.",
			1
		)
		-- DBM cast Rejuvenation
		br.ui:createCheckbox(
			section,
			"DBM cast Rejuvenation",
			"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAccording to BOSS AOE Spells, 5 seconds ahead of schedule cast Rejuvenation|cffFFBB00."
		)
		-- DOT cast Rejuvenation
		br.ui:createCheckbox(
			section,
			"DOT cast Rejuvenation",
			"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFDOT damage to teammates cast Rejuvenation|cffFFBB00."
		)
		-- Pre-Pull Timer
		br.ui:createSpinner(
			section,
			"Pre-Pull Timer",
			5,
			0,
			20,
			1,
			"|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1"
		)
		-- Travel Shapeshifts
		br.ui:createDropdown(
			section,
			"Auto Shapeshifts",
			{colorGreen .. "All", colorYellow .. "Travel Only", colorYellow .. "DPS Only"},
			1,
			"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation|cffFFBB00."
		)
		br.ui:createCheckbox(
			section,
			"Bear Form Shifting",
			"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFShapeshifting into Bear Form to DPS for Guardian Affinity"
		)
		br.ui:createSpinner(
			section,
			"Raid Boss Helper",
			70,
			0,
			100,
			5,
			"Minimum party member health to focus on healing raid bosses"
		)
		-- Bursting Stack
		br.ui:createSpinnerWithout(
			section,
			"Bursting",
			1,
			1,
			10,
			1,
			"",
			"|cffFFFFFFWhen Bursting stacks are above this amount, CDs will be triggered."
		)
		-- DPS
		br.ui:createSpinnerWithout(
			section,
			"DPS",
			70,
			0,
			100,
			5,
			"|cffFFFFFFIf over this value, rotation will switch to DPS. (Auto DPS Only)"
		)
		br.ui:createSpinnerWithout(
			section,
			"Critical Heal",
			70,
			0,
			100,
			5,
			"|cffFFFFFFIf under this value, rotation will switch to healing. (Auto DPS Only)"
		)
		br.ui:createDropdown(
			section,
			"DPS Key",
			br.dropOptions.Toggle,
			6,
			"Set a key for using DPS (Will ignore DPS HP Thresholds)"
		)
		br.ui:createCheckbox(section, "HOT Mode", "Keep HOTs on tanks. (Experimental)")
		br.ui:createSpinnerWithout(
			section,
			"Max Moonfire Targets",
			2,
			1,
			10,
			1,
			"|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1"
		)
		br.ui:createSpinnerWithout(
			section,
			"Max Sunfire Targets",
			2,
			1,
			10,
			1,
			"|cff0070deSet to maximum number of targets to dot with Sunfire. Min: 1 / Max: 10 / Interval: 1"
		)
		-- DPS Save mana
		br.ui:createSpinnerWithout(section, "DPS Save mana", 40, 0, 100, 5, "|cffFFFFFFMana Percent to Stop DPS")
		-- Auto Soothe
		br.ui:createCheckbox(section, "Auto Soothe")
		-- Revive
		br.ui:createDropdown(
			section,
			"Revive",
			{"|cffFFFF00Selected Target", "|cffFF0000Mouseover Target", "|cffFFBB00Auto"},
			1,
			"|ccfFFFFFFTarget to Cast On"
		)

		br.ui:createCheckbox(section, "Pig Catcher", "Catch the freehold Pig in the ring of booty")
		br.ui:checkSectionState(section)
		-- Cooldown Options
		section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
		--  Mana Potion
		br.ui:createSpinner(section, "Mana Potion", 50, 0, 100, 1, "Mana Percent to Cast At")
		-- Racial
		br.ui:createCheckbox(section, "Racial")
		-- Trinkets
		br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(
			section,
			"Min Trinket 1 Targets",
			3,
			1,
			40,
			1,
			"",
			"Minimum Trinket 1 Targets(This includes you)",
			true
		)
		br.ui:createDropdownWithout(
			section,
			"Trinket 1 Mode",
			{"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"},
			1,
			"",
			""
		)
		br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(
			section,
			"Min Trinket 2 Targets",
			3,
			1,
			40,
			1,
			"",
			"Minimum Trinket 2 Targets(This includes you)",
			true
		)
		br.ui:createDropdownWithout(
			section,
			"Trinket 2 Mode",
			{"|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround"},
			1,
			"",
			""
		)
		-- Innervate
		br.ui:createSpinner(section, "Innervate", 60, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Innervate Targets", 3, 0, 40, 1, "Minimum Innervate Targets")
		--Incarnation: Tree of Life
		br.ui:createSpinner(section, "Incarnation", 60, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Incarnation Targets", 3, 0, 40, 1, "Minimum Incarnation: Tree of Life Targets")
		-- Tranquility
		br.ui:createSpinner(section, "Tranquility", 50, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Tranquility Targets", 3, 0, 40, 1, "Minimum Tranquility Targets")
		br.ui:createCheckbox(section, "Heart of the Wild")
		br.ui:checkSectionState(section)
		-- Covenant Options
		section = br.ui:createSection(br.ui.window.profile, "Covenant Options")
		br.ui:createDropdown(section, "Convoke Spirits", {"DPS", "HEAL", "BOTH", "Manual"}, 3, "How to use Convoke Spirits")
		br.ui:createSpinnerWithout(section, "Convoke Heal", 40, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Convoke Heal Targets", 1, 0, 40, 1, "Minimum Convoke Targets")
		br.ui:createCheckbox(section, "Ravenous Frenzy")
		br.ui:createSpinner(section, "Adaptive Swarm", 2, 0, 10, 1, "Max Swarm Targets")
		br.ui:checkSectionState(section)
		-- Defensive Options
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Rebirth
		br.ui:createDropdown(
			section,
			"Rebirth",
			{
				"|cffFFFFFFTarget",
				"|cffFFFFFFMouseover",
				"|cffFFFFFFTank",
				"|cffFFFFFFHealer",
				"|cffFFFFFFHealer/Tank",
				"|cffFFFFFFAny"
			},
			1,
			"|cffFFFFFFTarget to cast on"
		)
		-- Healthstone
		br.ui:createSpinner(section, "Healthstone", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		-- Barkskin
		br.ui:createSpinner(section, "Barkskin", 60, 0, 100, 5, "|cffFFBB00Health Percent to Cast At.")
		-- Renewal
		br.ui:createSpinner(section, "Renewal", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at")
		br.ui:checkSectionState(section)
		-- Interrupts Options
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		--Mighty Bash
		br.ui:createCheckbox(section, "Mighty Bash")
		br.ui:createCheckbox(section, "Typhoon")
		-- Interrupt Percentage
		br.ui:createSpinner(section, "InterruptAt", 95, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		-- Healing Options
		section = br.ui:createSection(br.ui.window.profile, "Healing")
		-- Efflorescence
		br.ui:createSpinner(section, "Efflorescence", 80, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Efflorescence Targets", 2, 0, 40, 1, "Minimum Efflorescence Targets")
		br.ui:createSpinnerWithout(
			section,
			"Efflorescence Recast Delay",
			3,
			0,
			30,
			1,
			"Delay Between Checks for Efflorescence"
		)
		br.ui:createDropdown(
			section,
			"Efflorescence Key",
			br.dropOptions.Toggle,
			6,
			colorGreen ..
				"Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Efflorescence manual usage."
		)
		br.ui:createCheckbox(section, "Efflorescence on Melee", "Cast on Melee only")
		br.ui:createCheckbox(section, "Efflorescence on CD", "Requires Efflorescence on Melee to be checked to work")
		-- Overgrowth
		br.ui:createSpinner(section, "Overgrowth", 70, 0, 100, 5, "Health Percent to Cast At")
		-- Nature's Swiftness
		br.ui:createSpinner(section, "Nature's Swiftness", 50, 0, 100, 5, "Health Percent to Cast At")
		-- Lifebloom
		br.ui:createDropdown(
			section,
			"Lifebloom Target",
			{"Tank", "Boss1 Target", "Self", "Focus"},
			1,
			"|cffFFFFFFTarget for Lifebloom"
		)
		-- Cenarion Ward
		br.ui:createSpinner(section, "Cenarion Ward", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(
			section,
			"Cenarion Ward Target",
			{"|cffFFFFFFTank", "|cffFFFFFFBoss1 Target", "|cffFFFFFFSelf", "|cffFFFFFFAny"},
			1,
			"|cffFFFFFFcast Cenarion Ward Target"
		)
		-- Ironbark
		br.ui:createSpinner(section, "Ironbark", 30, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createDropdownWithout(
			section,
			"Ironbark Target",
			{
				"|cffFFFFFFPlayer",
				"|cffFFFFFFTarget",
				"|cffFFFFFFMouseover",
				"|cffFFFFFFTank",
				"|cffFFFFFFHealer",
				"|cffFFFFFFHealer/Tank",
				"|cffFFFFFFAny"
			},
			7,
			"|cffFFFFFFcast Ironbark Target"
		)
		-- Swiftmend
		br.ui:createSpinner(section, "Swiftmend", 30, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createDropdownWithout(
			section,
			"Swiftmend Target",
			{
				"|cffFFFFFFPlayer",
				"|cffFFFFFFTarget",
				"|cffFFFFFFMouseover",
				"|cffFFFFFFTank",
				"|cffFFFFFFHealer",
				"|cffFFFFFFHealer/Tank",
				"|cffFFFFFFAny"
			},
			7,
			"|cffFFFFFFcast Swiftmend Target"
		)
		-- Rejuvenation
		br.ui:createSpinner(section, "Rejuvenation", 90, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Rejuvenation Tank", 90, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinnerWithout(
			section,
			"Max Rejuvenation Targets",
			10,
			0,
			20,
			1,
			"|cffFFFFFFMaximum Rejuvenation Targets"
		)
		-- Germination
		br.ui:createSpinnerWithout(section, "Germination", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Germination Tank", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		-- Hot Regrowth
		br.ui:createSpinner(section, "Regrowth Clearcasting", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createSpinner(section, "Hot Regrowth Tank", 90, 0, 100, 5, "|cffFFFFFFTank Health Percent priority Cast At")
		br.ui:createSpinner(section, "Hot Regrowth", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		-- Regrowth
		br.ui:createSpinner(section, "Regrowth Tank", 50, 0, 100, 5, "|cffFFFFFFTank Health Percent priority Cast At")
		br.ui:createSpinner(section, "Regrowth", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		-- Wild Growth
		br.ui:createSpinner(section, "Wild Growth", 80, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Wild Growth Targets", 3, 0, 40, 1, "Minimum Wild Growth Targets")
		br.ui:createSpinner(section, "Soul of the Forest + Wild Growth", 80, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(
			section,
			"Soul of the Forest + Wild Growth Targets",
			3,
			0,
			40,
			1,
			"Minimum Soul of the Forest + Wild Growth Targets"
		)
		br.ui:createDropdownWithout(section, "Swiftmend + Wild Growth key", br.dropOptions.Toggle, 6)
		-- Flourish
		br.ui:createSpinner(section, "Flourish", 60, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Flourish Targets", 3, 0, 40, 1, "Minimum Flourish Targets")
		br.ui:createSpinnerWithout(section, "Flourish HOT Targets", 5, 0, 40, 1, "Minimum HOT Targets cast Flourish")
		br.ui:createSpinnerWithout(section, "HOT Time count", 8, 0, 25, 1, "HOT Less than how many seconds to count")
		br.ui:checkSectionState(section)
		-- Toggle Key Options
		section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
		-- Pause Toggle
		br.ui:createDropdownWithout(section, "Rejuvenation Mode", br.dropOptions.Toggle, 6)
		br.ui:createDropdownWithout(section, "DPS Mode", br.dropOptions.Toggle, 6)
		br.ui:createDropdownWithout(section, "Decurse Mode", br.dropOptions.Toggle, 6)
		br.ui:checkSectionState(section)
	end
	optionTable = {
		{
			[1] = "Rotation Options",
			[2] = rotationOptions
		}
	}
	return optionTable
end

----------------
--- ROTATION ---
---------------_

local function runRotation()
	-- if br.timer:useTimer("debugRestoration", 0.1) then
	--print("Running: "..rotationName)
	--------------
	--- Locals ---
	--------------
	-- local artifact                                      = br.player.artifact
	-- local combatTime                                    = br.getCombatTime()
	-- local cd 										   = br.player.cd
	-- local charges                                       = br.player.charges
	-- local perk                                          = br.player.perk
	-- local gcd                                           = br.player.gcd
	-- local lastSpell                                     = lastSpellCast
	-- local lowest                                        = br.friend[1]
	local buff = br.player.buff
	local cast = br.player.cast
	local cd = br.player.cd
	local combo = br.player.power.comboPoints.amount()
	local covenant = br.player.covenant
	local debuff = br.player.debuff
	local drinking =
		br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or
		br.getBuffRemain("player", 192001) ~= 0 or
		br.getBuffRemain("player", 314646) ~= 0
	local resable =
		br._G.UnitIsPlayer("target") and br._G.UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") and
		br._G.UnitInRange("target")
	local deadtar = br.GetUnitIsDeadOrGhost("target") or br.isDummy()
	local hastar = hastar or br.GetObjectExists("target")
	local enemies = br.player.enemies
	local friends = friends or {}
	local falling, swimming, flying = br.getFallTime(), br._G.IsSwimming(), br._G.IsFlying()
	local moving = br.isMoving("player") ~= false or br.player.moving
	local gcdMax = br.player.gcdMax
	local healPot = br.getHealthPot()
	local inCombat = br.isInCombat("player")
	local inInstance = br.player.instance == "party"
	local inRaid = br.player.instance == "raid"
	local stealthed = br.UnitBuffID("player", 5215) ~= nil
	local level = br.player.level
	local mana = br.player.power.mana.percent()
	local mode = br.player.ui.mode
	local php = br.player.health
	local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
	local pullTimer = br.DBM:getPulltimer()
	local race = br.player.race
	local racial = br.player.getRacial()
	local runeforge = br.player.runeforge
	local spell = br.player.spell
	local talent = br.player.talent
	local travel = br.player.buff.travelForm.exists()
	local cat = br.player.buff.catForm.exists()
	local moonkin = br.player.buff.moonkinForm.exists()
	local bear = br.player.buff.bearForm.exists()
	local noform = br._G.GetShapeshiftForm() == 0 or buff.treantForm.exists()
	local unit = br.player.unit
	local units = br.player.units
	local bloomCount = 0
	local rejuvCount = 0
	local tanks = br.getTanksTable()
	local ttd = br.getTTD
	local burst = nil

	units.get(5)
	units.get(8)

	enemies.get(5)
	enemies.get(5, "player", false, true)
	enemies.get(8)
	enemies.get(8, "target")
	enemies.get(15)
	enemies.get(40)
	friends.yards40 = br.getAllies("player", 40)

	if inInstance and select(3, br._G.GetInstanceInfo()) == 8 then
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

	local lowest = {}
	lowest.unit = "player"
	lowest.hp = 100
	for i = 1, #br.friend do
		if br.friend[i].hp < lowest.hp then
			lowest = br.friend[i]
		end
	end

	br.shiftTimer = br.shiftTimer or 0
	local function clearform()
		if not noform and not buff.incarnationTreeOfLife.exists() then
			local RunMacroText = br._G["RunMacroText"]
			local CancelShapeshiftForm = br._G["CancelShapeshiftForm"]
			return CancelShapeshiftForm() or RunMacroText("/CancelForm")
		end
	end
	-- All Hot Cnt
	local function getAllHotCnt(time_remain)
		local hotCnt = 0
		for i = 1, #br.friend do
			local lifebloomRemain = buff.lifebloom.remain(br.friend[i].unit)
			local rejuvenationRemain = buff.rejuvenation.remain(br.friend[i].unit)
			local regrowthRemain = buff.regrowth.remain(br.friend[i].unit)
			local rejuvenationGerminationRemain = buff.rejuvenationGermination.remain(br.friend[i].unit)
			local wildGrowthRemain = buff.wildGrowth.remain(br.friend[i].unit)
			local cenarionWardRemain = buff.cenarionWard.remain(br.friend[i].unit)
			local cultivatRemain = buff.cultivat.remain(br.friend[i].unit)
			if lifebloomRemain > 0 and lifebloomRemain <= time_remain then
				hotCnt = hotCnt + 1
			end
			if rejuvenationRemain > 0 and rejuvenationRemain <= time_remain then
				hotCnt = hotCnt + 1
			end
			if regrowthRemain > 0 and regrowthRemain <= time_remain then
				hotCnt = hotCnt + 1
			end
			if rejuvenationGerminationRemain > 0 and rejuvenationGerminationRemain <= time_remain then
				hotCnt = hotCnt + 1
			end
			if wildGrowthRemain > 0 and wildGrowthRemain <= time_remain then
				hotCnt = hotCnt + 1
			end
			if cenarionWardRemain > 0 and cenarionWardRemain <= time_remain then
				hotCnt = hotCnt + 2
			end
			if cultivatRemain > 0 and cultivatRemain <= time_remain then
				hotCnt = hotCnt + 1
			end
		end
		return hotCnt
	end

	local function count_hots(unit)
		local count = 0
		if buff.lifebloom.exists(unit) then
			count = count + 1
		end
		if buff.rejuvenation.exists(unit) then
			count = count + 1
		end
		if buff.regrowth.exists(unit) then
			count = count + 1
		end
		if buff.wildGrowth.exists(unit) then
			count = count + 1
		end
		if buff.cenarionWard.exists(unit) then
			count = count + 1
		end
		if buff.cultivat.exists(unit) then
			count = count + 1
		end
		if buff.springblossom.exists(unit) then
			count = count + 1
		end
		if buff.rejuvenationGermination.exists(unit) then
			count = count + 1
		end
		if count == 0 and runeforge.verdantInfusion.equiped then
			count = count + 1
		end
		return count
	end
	-- wildGrowth Exist
	local function wildGrowthExist()
		for i = 1, #br.friend do
			if buff.wildGrowth.exists(br.friend[i].unit) then
				return true
			end
		end
		return false
	end
	-- Rejuvenation and Lifebloom Count
	for i = 1, #br.friend do
		if buff.rejuvenation.remain(br.friend[i].unit) > gcdMax then
			rejuvCount = rejuvCount + 1
		end
		if buff.lifebloom.remain(br.friend[i].unit) > gcdMax then
			bloomCount = bloomCount + 1
		end
	end

	local function key()
		-- Swiftmend + Wild Growth key
		if
			br.isChecked("Swiftmend + Wild Growth key") and
				(br.SpecificToggle("Swiftmend + Wild Growth key") and not br._G.GetCurrentKeyBoardFocus())
		 then
			if not buff.soulOfTheForest.exists() and br.getSpellCD(48438) < gcdMax and count_hots(lowest.unit) > 0 then
				clearform()
				if cast.swiftmend(lowest.unit) then
					br.addonDebug("Casting Swiftmend (SM + WG)")
					return true
				end
			end
			if buff.soulOfTheForest.exists() then
				clearform()
				if cast.wildGrowth() then
					br.addonDebug("Casting Wildgrowth")
					return true
				end
			end
		end
		-- Efflorescence key
		if (br.SpecificToggle("Efflorescence Key") and not br._G.GetCurrentKeyBoardFocus()) then
			clearform()
			br._G.CastSpellByName(br._G.GetSpellInfo(spell.efflorescence), "cursor")
			br.LastEfflorescenceTime = br._G.GetTime()
			br.addonDebug("Casting Efflorescence")
			return true
		end
	end

	local function BossEncounterCase()
		-- Temple of Sethraliss
		if
			br.isChecked("Raid Boss Helper") and lowest.hp > br.getOptionValue("Raid Boss Helper") and br.player.eID and
				(br.player.eID == 2127 or br.player.eID == 2418 or br.player.eID == 2402)
		 then
			for i = 1, br._G.GetObjectCount() do
				local thisUnit = br._G.GetObjectWithIndex(i)
				local ID = br.GetObjectID(thisUnit)
				if ID == 133392 or ID == 171577 or ID == 173112 or ID == 165759 or ID == 165778 then
					local healObject = thisUnit
					if
						br.getHP(healObject) < 100 and
							((ID == 133392 and br.getBuffRemain(healObject, 274148) == 0) or ID == 171577 or ID == 173112 or
								((ID == 165759 or ID == 165778) and not br.shadeUp))
					 then
						if talent.germination and not buff.rejuvenationGermination.exists(healObject) then
							clearform()
							br._G.CastSpellByName(br._G.GetSpellInfo(774), healObject)
							return true
						end
						if not buff.rejuvenation.exists(healObject) then
							clearform()
							br._G.CastSpellByName(br._G.GetSpellInfo(774), healObject)
							return true
						end
						if buff.rejuvenation.exists(healObject) then
							clearform()
							br._G.CastSpellByName(br._G.GetSpellInfo(8936), healObject)
							return true
						end
					end
				end
			end
		end
		if inInstance then
			for i = 1, #br.friend do
				-- Jagged Nettles and Dessication logic
				if br.getDebuffRemain(br.friend[i].unit, 260741) ~= 0 or br.getDebuffRemain(br.friend[i].unit, 267626) ~= 0 then
					if br.getSpellCD(18562) == 0 and count_hots(br.friend[i].unit) > 0 then
						clearform()
						if cast.swiftmend(br.friend[i].unit) then
							br.addonDebug("Casting Swiftmend (Jagged Nettles)")
							return true
						end
					end
					if br.getSpellCD(18562) > gcdMax then
						if not moonkin then
							clearform()
						end
						if cast.regrowth(br.friend[i].unit) then
							br.addonDebug("Casting Regrowth")
							return true
						end
					end
				end
				-- Devour
				if br.getDebuffRemain(br.friend[i].unit, 255421) ~= 0 and br.friend[i].hp <= 90 then
					if br.getSpellCD(102342) == 0 then
						clearform()
						if cast.ironbark(br.friend[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
					if not moonkin then
						clearform()
					end
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				end
			end
		end
	end

	-- Action List - Extras
	local function actionList_Extras()
		if
			br.isChecked("Auto Shapeshifts") and
				(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 2)
		 then --and br.timer:useTimer("debugShapeshift", 0.25) then
			-- Flight Form
			if
				not inCombat and br.canFly() and br.fallDist > 90 --[[falling > br.getOptionValue("Fall Timer")]] and level >= 58 and
					not buff.prowl.exists()
			 then
				br._G.CastSpellByID(783, "player")
				br.addonDebug("Casting Travelform")
				return true
			end
			-- Aquatic Form
			if
				(not inCombat) --[[or br.getDistance("target") >= 10--]] and swimming and not travel and not buff.prowl.exists() and
					moving
			 then
				br._G.CastSpellByID(783, "player")
				br.addonDebug("Casting Travelform")
				return true
			end
			-- Travel Form
			if
				not inCombat and not swimming and level >= 58 and not buff.prowl.exists() and not travel and not br._G.IsIndoors() and
					br.IsMovingTime(1) and
					br.timer:useTimer("Travel shift", 3)
			 then
				br._G.CastSpellByID(783, "player")
				br.addonDebug("Casting Travelform")
				return true
			end
			-- Cat Form
			if not cat and not br._G.IsMounted() and not flying then
				-- Cat Form when not swimming or flying or stag and not in combat
				if moving and not swimming and not travel and br._G.IsIndoors() then
					if cast.catForm("player") then
						br.addonDebug("Casting Catform")
						return true
					end
				end
				-- Cat Form - Less Fall Damage
				if (not br.canFly() or inCombat or level < 58) and br.fallDist > 90 then --falling > br.getOptionValue("Fall Timer") then
					if cast.catForm("player") then
						br.addonDebug("Casting Catform")
						return true
					end
				end
			end
		end -- End Shapeshift Form Management
		-- Revive
		if br.isChecked("Revive") and not inCombat and not br.isMoving("player") and br.timer:useTimer("Resurrect", 4) then
			if
				br.getOptionValue("Revive") == 1 and br._G.UnitIsPlayer("target") and br.GetUnitIsDeadOrGhost("target") and
					br.GetUnitIsFriend("target", "player")
			 then
				if cast.revive("target", "dead") then
					br.addonDebug("Casting Revive")
					return true
				end
			end
			if
				br.getOptionValue("Revive") == 2 and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and
					br.GetUnitIsFriend("mouseover", "player")
			 then
				if cast.revive("mouseover", "dead") then
					br.addonDebug("Casting Revive")
					return true
				end
			end
			if br.getOptionValue("Revive") == 3 then
				local deadPlayers = {}
				for i = 1, #br.friend do
					if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) then
						br._G.tinsert(deadPlayers, br.friend[i].unit)
					end
				end
				if #deadPlayers > 1 then
					if cast.revitalize() then
						br.addonDebug("Casting Mass Resurrection")
						return true
					end
				elseif #deadPlayers == 1 then
					if cast.revive(deadPlayers[1], "dead") then
						br.addonDebug("Casting Revive (Auto)")
						return true
					end
				end
			end
		end
	end -- End Action List - Extras

	-- Action List - Pre-Combat
	local function actionList_PreCombat()
		if br.isChecked("Pig Catcher") then
			br.bossHelper()
		end
		-- Pre-Pull Timer
		if br.isChecked("Pre-Pull Timer") then
			if br.PullTimerRemain() <= br.getOptionValue("Pre-Pull Timer") then
				if br.hasItem(166801) and br.canUseItem(166801) then
					br.addonDebug("Using Sapphire of Brilliance")
					br.useItem(166801)
				end
				if br.canUseItem(142117) and not buff.prolongedPower.exists() then
					br.addonDebug("Using Prolonged Power Pot")
					br.useItem(142117)
				end
			end
		end
	end -- End Action List - Pre-Combat

	local function actionList_Defensive()
		if br.useDefensive() then
			-- Barkskin
			if br.isChecked("Barkskin") then
				if php <= br.getOptionValue("Barkskin") then
					if cast.barkskin() then
						br.addonDebug("Casting Barkskin")
						return true
					end
				end
			end
			-- Healthstone
			if
				br.isChecked("Healthstone") and php <= br.getOptionValue("Healthstone") and
					(br.hasHealthPot() or br.hasItem(5512) or br.hasItem(166799))
			 then
				if br.canUseItem(5512) then
					br.addonDebug("Using Healthstone")
					br.useItem(5512)
				elseif br.canUseItem(healPot) then
					br.addonDebug("Using Health Pot")
					br.useItem(healPot)
				elseif br.hasItem(166799) and br.canUseItem(166799) then
					br.addonDebug("Using Emerald of Vigor")
					br.useItem(166799)
				end
			end
			-- Renewal
			if br.isChecked("Renewal") and talent.renewal then
				if php <= br.getOptionValue("Renewal") then
					if cast.renewal() then
						br.addonDebug("Casting Renewal")
						return true
					end
				end
			end
			-- Rebirth
			if br.isChecked("Rebirth") and not moving then
				if
					br.getOptionValue("Rebirth") == 1 and -- Target
						br._G.UnitIsPlayer("target") and
						br.GetUnitIsDeadOrGhost("target") and
						br.GetUnitIsFriend("target", "player")
				 then
					if cast.rebirth("target", "dead") then
						br.addonDebug("Casting Rebirth")
						return true
					end
				end
				if
					br.getOptionValue("Rebirth") == 2 and -- Mouseover
						br._G.UnitIsPlayer("mouseover") and
						br.GetUnitIsDeadOrGhost("mouseover") and
						br.GetUnitIsFriend("mouseover", "player")
				 then
					if cast.rebirth("mouseover", "dead") then
						br.addonDebug("Casting Rebirth")
						return true
					end
				end
				if br.getOptionValue("Rebirth") == 3 then -- Tank
					for i = 1, #tanks do
						if
							br._G.UnitIsPlayer(tanks[i].unit) and br.GetUnitIsDeadOrGhost(tanks[i].unit) and
								br.GetUnitIsFriend(tanks[i].unit, "player") and
								br.getDistance(tanks[i].unit) <= 40
						 then
							if cast.rebirth(tanks[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if br.getOptionValue("Rebirth") == 4 then -- Healer
					for i = 1, #br.friend do
						if
							br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and
								br.GetUnitIsFriend(br.friend[i].unit, "player") and
								(br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
						 then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if br.getOptionValue("Rebirth") == 5 then -- Tank/Healer
					for i = 1, #br.friend do
						if
							br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and
								br.GetUnitIsFriend(br.friend[i].unit, "player") and
								(br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or
									br.friend[i].role == "TANK" or
									br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
						 then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if br.getOptionValue("Rebirth") == 6 then -- Any
					for i = 1, #br.friend do
						if
							br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and
								br.GetUnitIsFriend(br.friend[i].unit, "player")
						 then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
			end
		end -- End Defensive Toggle
	end -- End Action List - Defensive

	-- Interrupt
	local function actionList_Interrupts()
		if br.useInterrupts() then
			for i = 1, #enemies.yards15 do
				local thisUnit = enemies.yards15[i]
				if br.canInterrupt(thisUnit, br.getOptionValue("InterruptAt")) then
					-- Typhoon
					if br.isChecked("Typhoon") and talent.typhoon and br.getFacing("player", thisUnit) then
						if cast.typhoon() then
							br.addonDebug("Casting Typhoon")
							return true
						end
					end
					-- Mighty Bash
					if br.isChecked("Mighty Bash") and talent.mightyBash and br.getDistance(thisUnit, "player") <= 5 then
						if cast.mightyBash(thisUnit) then
							br.addonDebug("Casting Mighty Bash")
							return true
						end
					end
				end
			end
		end
	end

	local function actionList_Cooldowns()
		if br.useCDs() then
			-- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
			if br.isChecked("Racial") and (race == "Orc" or race == "Troll" or race == "BloodElf") then
				if br.castSpell("player", racial, false, false, false) then
					br.addonDebug("Casting Racial")
					return true
				end
			end
			-- Trinkets
			if
				br.isChecked("Trinket 1") and br.canTrinket(13) and not br.hasEquiped(165569, 13) and not br.hasEquiped(160649, 13) and
					not br.hasEquiped(158320, 13)
			 then
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
										br._G.tinsert(meleeHurt, meleeFriends[j])
									end
								end
								if #meleeHurt >= br.getValue("Min Trinket 1 Targets") or burst == true then
									loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
								end
							end
							if loc ~= nil then
								br.useItem(13)
								br.addonDebug("Using Trinket 1 (Ground)")
								local px, py, pz = br._G.ObjectPosition("player")
								loc.z = select(3, br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
								if
									loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and
										br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil
								 then -- Check z and LoS, ignore terrain and m2 collisions
									br._G.ClickPosition(loc.x, loc.y, loc.z)
									return true
								end
							end
						end
					end
				end
			end
			if
				br.isChecked("Trinket 2") and br.canTrinket(14) and not br.hasEquiped(165569, 14) and not br.hasEquiped(160649, 14) and
					not br.hasEquiped(158320, 14)
			 then
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
							if #meleeFriends < 12 then
								loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
							else
								local meleeHurt = {}
								for j = 1, #meleeFriends do
									if meleeFriends[j].hp < br.getValue("Trinket 2") then
										br._G.tinsert(meleeHurt, meleeFriends[j])
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
			-- Mana Potion
			if br.isChecked("Mana Potion") and mana <= br.getValue("Mana Potion") then
				if br.hasItem(127835) then
					br.useItem(127835)
					br.addonDebug("Using Mana Potion")
				end
			end
			-- Innervate
			if br.isChecked("Innervate") and mana ~= nil then
				if (br.getLowAllies(br.getValue("Innervate")) >= br.getValue("Innervate Targets") and mana < 80) or burst == true then
					if cast.innervate("player") then
						br.addonDebug("Casting Innervate")
						return true
					end
				end
			end
			-- Incarnation: Tree of Life
			if br.isChecked("Incarnation") and talent.incarnationTreeOfLife and not buff.incarnationTreeOfLife.exists() then
				if br.getLowAllies(br.getValue("Incarnation")) >= br.getValue("Incarnation Targets") or burst == true then
					if cast.incarnationTreeOfLife() then
						br.addonDebug("Casting Incarnation")
						return true
					end
				end
			end
			-- Tranquility
			if br.isChecked("Tranquility") and not moving and not buff.incarnationTreeOfLife.exists() then
				if br.getLowAllies(br.getValue("Tranquility")) >= br.getValue("Tranquility Targets") or burst == true then
					if cast.tranquility() then
						br.addonDebug("Casting Tranquility")
						return true
					end
				end
			end
		end -- End useCooldowns check
	end -- End Action List - Cooldowns

	local function actionList_Decurse()
		-- Soothe
		if br.isChecked("Auto Soothe") then
			for i = 1, #enemies.yards40 do
				local thisUnit = enemies.yards40[i]
				if br.canDispel(thisUnit, spell.soothe) then
					if cast.soothe(thisUnit) then
						br.addonDebug("Casting Soothe")
						return true
					end
				end
			end
		end
		-- Nature's Cure
		if mode.decurse == 1 then
			for i = 1, #friends.yards40 do
				if br.canDispel(br.friend[i].unit, spell.naturesCure) then
					if cast.naturesCure(br.friend[i].unit) then
						br.addonDebug("Casting Nature's Cure")
						return true
					end
				end
			end
		end
	end

	local function actionList_hots()
		local needsHOTs = false
		local hotTank
		local tank
		if br.getFocusedTank() ~= nil then
			tank = br.getFocusedTank()
		elseif #tanks == 1 then
			tank = tanks[1].unit
		end
		if
			br._G.UnitTarget(tank) ~= nil and
				(((bloomCount >= 1 and buff.lifebloom.remains(tank) < 4.5 and buff.lifebloom.remain(tank) > 0) or bloomCount < 1) or
					(not talent.cenarionWard or (talent.cenarionWard and buff.cenarionWard.remains(tank) < 9)) or
					buff.rejuvenation.remains(tank) < 4.5)
		 then
			needsHOTs = true
			hotTank = tank
		end
		if needsHOTs and hotTank then
			if buff.lifebloom.remains(hotTank) < 4.5 then
				if cast.lifebloom(hotTank) then
					br.addonDebug("Casting Lifebloom (HOT Mode)")
					return true
				end
			end
			if talent.cenarionWard and buff.cenarionWard.remains(hotTank) < 9 then
				if cast.cenarionWard(hotTank) then
					br.addonDebug("Casting Cenarion Ward (HOT Mode)")
					return true
				end
			end
			if buff.rejuvenation.remains(hotTank) < 4.5 then
				if cast.rejuvenation(hotTank) then
					br.addonDebug("Casting Rejuvenation (HOT Mode)")
					return true
				end
			end
		end
	end

	-- AOE Healing
	local function actionList_AOEHealing()
		-- Wild Growth
		if br.isChecked("Wild Growth") then
			for i = 1, #br.friend do
				if br._G.UnitInRange(br.friend[i].unit) then
					local lowHealthCandidates = br.getUnitsToHealAround(br.friend[i].unit, 30, br.getValue("Wild Growth"), #br.friend)
					local lowHealthCandidates2 =
						br.getUnitsToHealAround(br.friend[i].unit, 30, br.getValue("Soul of the Forest + Wild Growth"), #br.friend)
					if
						#lowHealthCandidates >= br.getValue("Soul of the Forest + Wild Growth Targets") and talent.soulOfTheForest and
							not buff.soulOfTheForest.exists() and
							br.getSpellCD(48438) < gcdMax and
							count_hots(lowest.unit) > 0
					 then
						clearform()
						if cast.swiftmend(lowest.unit) then
							br.addonDebug("Casting Swiftmend (SotF)")
							return true
						end
					elseif
						#lowHealthCandidates2 >= br.getValue("Soul of the Forest + Wild Growth Targets") and buff.soulOfTheForest.exists() and
							not moving
					 then
						clearform()
						if cast.wildGrowth(br.friend[i].unit) then
							br.addonDebug("Casting Wild Growth (Soul of the Forest)")
							return true
						end
					elseif #lowHealthCandidates >= br.getValue("Wild Growth Targets") and not moving then
						clearform()
						if cast.wildGrowth(br.friend[i].unit) then
							br.addonDebug("Casting Wild Growth")
							return true
						end
					end
				end
			end
		end
		-- Efflorescence
		if not moving then
			if
				(br.SpecificToggle("Efflorescence Key") and not br._G.GetCurrentKeyBoardFocus()) and
					br.isChecked("Efflorescence Key")
			 then
				clearform()
				if br._G.CastSpellByName(br._G.GetSpellInfo(spell.efflorescence), "cursor") then
					br.addonDebug("Casting Efflorescence")
					br.LastEfflorescenceTime = br._G.GetTime()
					return true
				end
			end
			if
				inCombat and br.isChecked("Efflorescence") and
					(not br.LastEfflorescenceTime or
						br._G.GetTime() - br.LastEfflorescenceTime > br.getOptionValue("Efflorescence Recast Delay"))
			 then
				if br.isChecked("Efflorescence on Melee") then
					-- get melee players
					for i = 1, #tanks do
						-- get the tank's target
						local tankTarget = br._G.UnitTarget(tanks[i].unit)
						if tankTarget ~= nil and br.getDistance(tankTarget, "player") < 40 then
							-- get players in melee range of tank's target
							local meleeFriends = br.getAllies(tankTarget, 5)
							-- get the best ground circle to encompass the most of them
							local loc = nil
							if br.isChecked("Efflorescence on CD") then
								if #meleeFriends >= br.getValue("Efflorescence Targets") then
									if #meleeFriends < 12 then
										loc = br.getBestGroundCircleLocation(meleeFriends, br.getValue("Efflorescence Targets"), 6, 10)
									else
										clearform()
										if
											br.castWiseAoEHeal(
												meleeFriends,
												spell.efflorescence,
												10,
												100,
												br.getValue("Efflorescence Targets"),
												6,
												true,
												true
											)
										 then
											br.addonDebug("Casting Efflorescence")
											br.LastEfflorescenceTime = br._G.GetTime()
											return true
										end
									end
								end
							else
								local meleeHurt = {}
								for j = 1, #meleeFriends do
									if meleeFriends[j].hp < br.getValue("Efflorescence") then
										br._G.tinsert(meleeHurt, meleeFriends[j])
									end
								end
								if #meleeHurt >= br.getValue("Efflorescence Targets") then
									if #meleeHurt < 12 then
										loc = br.getBestGroundCircleLocation(meleeHurt, br.getValue("Efflorescence Targets"), 6, 10)
									else
										clearform()
										if
											br.castWiseAoEHeal(
												meleeHurt,
												spell.efflorescence,
												10,
												br.getValue("Efflorescence"),
												br.getValue("Efflorescence Targets"),
												6,
												true,
												true
											)
										 then
											br.addonDebug("Casting Efflorescence")
											br.LastEfflorescenceTime = br._G.GetTime()
											return true
										end
									end
								end
							end
							if loc ~= nil then
								if br.castGroundAtLocation(loc, spell.efflorescence) then
									br.addonDebug("Casting Efflorescence")
									br.LastEfflorescenceTime = br._G.GetTime()
									return true
								end
							end
						end
					end
				else
					clearform()
					if
						br.castWiseAoEHeal(
							br.friend,
							spell.efflorescence,
							10,
							br.getValue("Efflorescence"),
							br.getValue("Efflorescence Targets"),
							6,
							false,
							false
						)
					 then
						br.addonDebug("Casting Efflorescence")
						br.LastEfflorescenceTime = br._G.GetTime()
						return true
					end
				end
			end
		end
		-- Flourish
		if br.isChecked("Flourish") and inCombat and talent.flourish and wildGrowthExist() then
			if br.getLowAllies(br.getValue("Flourish")) >= br.getValue("Flourish Targets") then
				local c = getAllHotCnt(br.getValue("HOT Time count"))
				if c >= br.getValue("Flourish HOT Targets") or buff.tranquility.exists() then
					clearform()
					if cast.flourish() then
						br.addonDebug("Casting Flourish")
						return true
					end
				end
			end
		end
		--Convoke the Spirits
		if
			inCombat and br.isChecked("Convoke Spirits") and covenant.nightFae.active and noform and
				(br.getOptionValue("Convoke Spirits") == 2 or br.getOptionValue("Convoke Spirits") == 3) and
				(br.getLowAllies(br.getValue("Convoke Heal")) >= br.getValue("Convoke Heal Targets") or burst == true)
		 then
			if cast.convokeTheSpirits() then
				br.addonDebug("Casting Convoke the Spirits (Heal)")
				return true
			end
		end
	end

	-- Single Target
	local function actionList_SingleTarget()
		-- Ironbark
		if br.isChecked("Ironbark") and inCombat then
			if br.getOptionValue("Ironbark Target") == 1 then
				if php <= br.getValue("Ironbark") then
					clearform()
					if cast.ironbark("player") then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			elseif br.getOptionValue("Ironbark Target") == 2 then
				if br.getHP("target") <= br.getValue("Ironbark") then
					clearform()
					if cast.ironbark("target") then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			elseif br.getOptionValue("Ironbark Target") == 3 then
				if br.getHP("mouseover") <= br.getValue("Ironbark") then
					clearform()
					if cast.ironbark("mouseover") then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			elseif br.getOptionValue("Ironbark Target") == 4 then
				for i = 1, #tanks do
					if tanks[i].hp <= br.getValue("Ironbark") and br.getDistance(tanks[i].unit) <= 40 then
						clearform()
						if cast.ironbark(tanks[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
				end
			elseif br.getOptionValue("Ironbark Target") == 5 then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Ironbark") and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" then
						clearform()
						if cast.ironbark(br.friend[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
				end
			elseif br.getOptionValue("Ironbark Target") == 6 then
				for i = 1, #br.friend do
					if
						br.friend[i].hp <= br.getValue("Ironbark") and
							(br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or
								br.friend[i].role == "TANK" or
								br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
					 then
						clearform()
						if cast.ironbark(br.friend[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
				end
			elseif br.getOptionValue("Ironbark Target") == 7 then
				if lowest.hp <= br.getValue("Ironbark") then
					clearform()
					if cast.ironbark(lowest.unit) then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			end
		end
		-- Swiftmend
		if br.isChecked("Swiftmend") and inCombat and not buff.soulOfTheForest.exists() then
			if br.getOptionValue("Swiftmend Target") == 1 then
				if php <= br.getValue("Swiftmend") and count_hots("player") > 0 then
					clearform()
					if cast.swiftmend("player") then
						br.addonDebug("Casting Swiftmend (Player)")
						return true
					end
				end
			elseif br.getOptionValue("Swiftmend Target") == 2 then
				if
					br.getHP("target") <= br.getValue("Swiftmend") and
						br.getDebuffStacks("target", 209858) < br.getValue("Necrotic Rot") and
						count_hots("target") > 0
				 then
					clearform()
					if cast.swiftmend("target") then
						br.addonDebug("Casting Swiftmend (Target")
						return true
					end
				end
			elseif br.getOptionValue("Swiftmend Target") == 3 then
				if
					br.getHP("mouseover") <= br.getValue("Swiftmend") and
						br.getDebuffStacks("mouseover", 209858) < br.getValue("Necrotic Rot") and
						count_hots("mouseover") > 0
				 then
					clearform()
					if cast.swiftmend("mouseover") then
						br.addonDebug("Casting Swiftmend (Mouseover)")
						return true
					end
				end
			elseif br.getOptionValue("Swiftmend Target") == 4 then
				for i = 1, #tanks do
					if
						tanks[i].hp <= br.getValue("Swiftmend") and
							(not inInstance or (inInstance and br.getDebuffStacks(tanks[i].unit, 209858) < br.getValue("Necrotic Rot"))) and
							count_hots(tanks[i].unit) > 0 and
							br.getDistance(tanks[i].unit) <= 40
					 then
						clearform()
						if cast.swiftmend(tanks[i].unit) then
							br.addonDebug("Casting Swiftmend (Tank)")
							return true
						end
					end
				end
			elseif br.getOptionValue("Swiftmend Target") == 5 then
				for i = 1, #br.friend do
					if
						br.friend[i].hp <= br.getValue("Swiftmend") and
							(br.friend[i].role == "HEALER" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER") and
							(not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot"))) and
							count_hots(br.friend[i].unit) > 0
					 then
						clearform()
						if cast.swiftmend(br.friend[i].unit) then
							br.addonDebug("Casting Swiftmend (Healer)")
							return true
						end
					end
				end
			elseif br.getOptionValue("Swiftmend Target") == 6 then
				for i = 1, #br.friend do
					if
						br.friend[i].hp <= br.getValue("Swiftmend") and
							(br.friend[i].role == "HEALER" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or
								br.friend[i].role == "TANK" or
								br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
							(not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot"))) and
							count_hots(br.friend[i].unit) > 0
					 then
						clearform()
						if cast.swiftmend(br.friend[i].unit) then
							br.addonDebug("Casting Swiftmend (Tank or Healer)")
							return true
						end
					end
				end
			elseif br.getOptionValue("Swiftmend Target") == 7 then
				if
					lowest.hp <= br.getValue("Swiftmend") and
						(not inInstance or (inInstance and br.getDebuffStacks(lowest.unit, 209858) < br.getValue("Necrotic Rot"))) and
						count_hots(lowest.unit) > 0
				 then
					clearform()
					if cast.swiftmend(lowest.unit) then
						br.addonDebug("Casting Swiftmend (Any)")
						return true
					end
				end
			end
		end
		-- Emergency Regrowth
		if not moving or buff.incarnationTreeOfLife.exists() then
			for i = 1, #br.friend do
				if
					br.isChecked("Regrowth Tank") and br.friend[i].hp <= 50 and
						(br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
						(not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot")))
				 then
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				elseif
					br.isChecked("Regrowth") and br.friend[i].hp <= 30 and
						(not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot")))
				 then
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				end
			end
		end
		-- Adaptive Swarm
		if br.isChecked("Adaptive Swarm") and covenant.necrolord.active then
			for i = 1, #br.friend do
				if not buff.adaptiveSwarm.exists(br.friend[i].unit) then
					if cast.adaptiveSwarm(br.friend[i].unit) then
						br.addonDebug("Casting Adaptive Swarm (Heal)")
						return true
					end
				end
			end
		end
		-- Overgrowth
		if br.isChecked("Overgrowth") and talent.overgrowth and lowest.hp < br.getOptionValue("Overgrowth") then
			if cast.overgrowth(lowest.unit) then
				br.addonDebug("Casting Overgrowth")
				return true
			end
		end
		-- In advance cast Lifebloom
		if br.isChecked("Lifebloom Target") and (mode.prehot == 1 or mode.prehot == 2 or inCombat) and not cat and not travel then
			local focusTank = br.getFocusedTank()
			if (bloomCount < 1 or (runeforge.theDarkTitansLesson.equiped and bloomCount < 2)) then
				if focusTank ~= nil and br.getDistance(focusTank.unit) < 40 and not buff.lifebloom.exists(focusTank.unit) then
					clearform()
					if cast.lifebloom(focusTank.unit) then
						br.addonDebug("Casting Lifebloom")
						return true
					end
				elseif focusTank == nil then
					for i = 1, #tanks do
						if tanks[i].hp <= 90 and not buff.lifebloom.exists(tanks[i].unit) and br.getDistance(tanks[i].unit) < 40 then
							clearform()
							if cast.lifebloom(tanks[i].unit) then
								br.addonDebug("Casting Lifebloom")
								return true
							end
						end
					end
				end
			elseif bloomCount == 1 then
				for i = 1, #tanks do
					if
						tanks[i].hp <= 90 and buff.lifebloom.remain(tanks[i].unit) < 4.5 and buff.lifebloom.remain(tanks[i].unit) > 0 and
							br.getDistance(tanks[i].unit) < 40
					 then
						clearform()
						if cast.lifebloom(tanks[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					end
				end
			end
		end

		-- In advance cast Cenarion Ward
		if
			br.isChecked("Cenarion Ward") and (mode.prehot == 1 or mode.prehot == 2 or inCombat) and not cat and not travel and
				talent.cenarionWard
		 then
			for i = 1, #tanks do
				if buff.cenarionWard.remain(tanks[i].unit) < 4.5 and buff.cenarionWard.remain(tanks[i].unit) > 0 then
					clearform()
					if cast.cenarionWard(tanks[i].unit) then
						br.addonDebug("Casting Cenarion Ward")
						return true
					end
				end
			end
		end
		-- Lifebloom
		if br.isChecked("Lifebloom Target") and (mode.prehot == 1 or mode.prehot == 2 or inCombat) and not cat and not travel then
			if
				((br.getOptionValue("Lifebloom Target") ~= 3 and talent.photosynthesis and not buff.lifebloom.exists("player") and
					br.isCastingSpell(spell.wildGrowth)) or
					(runeforge.theDarkTitansLesson.equiped and not buff.lifebloom.exists("player") and talent.photosynthesis and
						bloomCount == 1))
			 then
				if cast.lifebloom("player") then
					br.addonDebug("Casting Lifebloom (Photosynthesis)")
					return true
				end
			end
			if br.getOptionValue("Lifebloom Target") == 1 then
				for i = 1, #tanks do
					if bloomCount < 1 and not buff.lifebloom.exists(tanks[i].unit) and br.getDistance(tanks[i].unit) <= 40 then
						clearform()
						if cast.lifebloom(tanks[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					elseif
						bloomCount == 1 and buff.lifebloom.remains(tanks[i].unit) < 4.5 and buff.lifebloom.remains(tanks[i].unit) > 0 and
							br.getDistance(tanks[i].unit) <= 40
					 then
						clearform()
						if cast.lifebloom(tanks[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					end
				end
			elseif br.getOptionValue("Lifebloom Target") == 2 then
				for i = 1, #br.friend do
					if
						bloomCount < 1 and not buff.lifebloom.exists(br.friend[i].unit) and
							br.GetUnitIsUnit(br.friend[i].unit, "boss1target")
					 then
						clearform()
						if cast.lifebloom(br.friend[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					elseif
						bloomCount == 1 and buff.lifebloom.remains(br.friend[i].unit) < 4.5 and
							buff.lifebloom.remain(br.friend[i].unit) > 0 and
							br.getDistance(br.friend[i].unit) <= 40
					 then
						clearform()
						if cast.lifebloom(br.friend[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					end
				end
			elseif br.getOptionValue("Lifebloom Target") == 3 then
				if not buff.lifebloom.exists("player") or buff.lifebloom.remains("player") < 4.5 then
					clearform()
					if cast.lifebloom("player") then
						br.addonDebug("Casting Lifebloom")
						return true
					end
				end
			elseif br.getOptionValue("Lifebloom Target") == 4 then
				if (not buff.lifebloom.exists("focus") or buff.lifebloom.remains("focus") < 4.5) and br.getDistance("focus") <= 40 then
					clearform()
					if cast.lifebloom("focus") then
						br.addonDebug("Casting Lifebloom")
						return true
					end
				end
			end
		end
		if
			br.isChecked("Lifebloom Target") and runeforge.theDarkTitansLesson.equiped and bloomCount == 1 and #br.friend > 1 and
				(mode.prehot == 1 or inCombat) and
				not cat and
				not travel
		 then
			if not talent.photosynthesis then
				local lbTargets = {}
				for i = 1, #br.friend do
					local thisUnit = br.friend[i]
					if buff.lifebloom.remains(thisUnit.unit) < 4.5 then
						table.insert(lbTargets, thisUnit)
					end
				end
				if #lbTargets > 1 then
					table.sort(
						lbTargets,
						function(x, y)
							return x.hp < y.hp
						end
					)
					if cast.lifebloom(lbTargets[1].unit) then
						br.addonDebug("Casting Lifebloom (Dark Titan)")
						return true
					end
				end
			end
		end
		-- Cenarion Ward
		if br.isChecked("Cenarion Ward") and (mode.prehot == 1 or mode.prehot == 2 or inCombat) and talent.cenarionWard then
			if br.getOptionValue("Cenarion Ward Target") == 1 then
				for i = 1, #tanks do
					if tanks[i].hp <= br.getValue("Cenarion Ward") and br.getDistance(tanks[i].unit) <= 40 then
						clearform()
						if cast.cenarionWard(tanks[i].unit) then
							br.addonDebug("Casting Cenarion Ward")
							return true
						end
					end
				end
			elseif br.getOptionValue("Cenarion Ward Target") == 2 then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Cenarion Ward") and br.GetUnitIsUnit(br.friend[i].unit, "boss1target") then
						clearform()
						if cast.cenarionWard(br.friend[i].unit) then
							br.addonDebug("Casting Cenarion Ward")
							return true
						end
					end
				end
			elseif br.getOptionValue("Cenarion Ward Target") == 3 then
				if php <= br.getValue("Cenarion Ward") then
					clearform()
					if cast.cenarionWard("player") then
						br.addonDebug("Casting Cenarion Ward")
						return true
					end
				end
			elseif br.getOptionValue("Cenarion Ward Target") == 4 then
				if lowest.hp <= br.getValue("Cenarion Ward") then
					clearform()
					if cast.cenarionWard(lowest.unit) then
						br.addonDebug("Casting Cenarion Ward")
						return true
					end
				end
			end
		end
		-- Hot Regrowth
		if not moving or buff.incarnationTreeOfLife.exists() then
			if
				br.isChecked("Regrowth Clearcasting") and lowest.hp <= br.getValue("Regrowth Clearcasting") and
					buff.clearcasting.remain() > gcdMax
			 then
				if cast.regrowth(lowest.unit) then
					br.addonDebug("Casting Regrowth")
					br.regrowthTime = br._G.GetTime()
					return true
				end
			elseif br.isChecked("Hot Regrowth Tank") then
				for i = 1, #tanks do
					if
						tanks[i].hp <= br.getValue("Hot Regrowth Tank") and buff.regrowth.remain(tanks[i].unit) < gcdMax and
							br.getDistance(tanks[i].unit) <= 40
					 then
						if cast.regrowth(tanks[i].unit) then
							br.addonDebug("Casting Regrowth")
							return true
						end
					end
				end
			elseif br.isChecked("Hot Regrowth") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= br.getValue("Hot Regrowth") and buff.regrowth.remain(br.friend[i].unit) < gcdMax then
						if not moonkin then
							clearform()
						end
						if cast.regrowth(br.friend[i].unit) then
							br.addonDebug("Casting Regrowth")
							return true
						end
					end
				end
			end
		end
		-- Nature's Swiftness
		if br.isChecked("Nature's Swiftness") and lowest.hp < br.getOptionValue("Nature's Swiftness") then
			if cast.naturesSwiftness() then
				br.addonDebug("Casting Nature's Swiftness")
				return true
			end
		end
		-- Swiftmend (Verdant Infusion)
		if runeforge.verdantInfusion.equiped then
			for i = 1, #br.friend do
				if
					buff.rejuvenation.exists(br.friend[i].unit) or buff.cenarionWard.exists(br.friend[i].unit) or
						buff.cultivation.exists(br.friend[i].unit) or
						buff.springBlossoms.exists(br.friend[i].unit) or
						buff.lifebloom.exists(br.friend[i].unit)
				 then
					if cast.swiftmend(br.friend[i].unit) then
						br.addonDebug("Casting Swiftmend (Verdant Infusion)")
						return true
					end
				end
			end
		end
		-- Nourish
		if talent.nourish then
			for i = 1, #br.friend do
				if
					buff.rejuvenation.exists(br.friend[i].unit) and
						(buff.cenarionWard.exists(br.friend[i].unit) or buff.cultivation.exists(br.friend[i].unit) or
							buff.wildGrowth.exists(br.friend[i].unit) or
							buff.lifebloom.exists(br.friend[i].unit) or
							buff.regrowth.exists(br.friend[i].unit))
				 then
					if cast.nourish(br.friend[i].unit) then
						br.addonDebug("Casting Nourish")
						return true
					end
				end
			end
		end
		-- Rejuvenation
		if br.isChecked("Rejuvenation") and (mode.prehot == 1 or mode.prehot == 2 or inCombat) then
			for i = 1, #tanks do
				if
					talent.germination and tanks[i].hp <= br.getValue("Germination Tank") and
						not buff.rejuvenationGermination.exists(tanks[i].unit) and
						br.getDistance(tanks[i].unit) <= 40
				 then
					clearform()
					if cast.rejuvenation(tanks[i].unit) then
						br.addonDebug("Casting Rejuvenation (Germinate Tank)")
						return true
					end
				elseif
					not talent.germination and tanks[i].hp <= br.getValue("Rejuvenation Tank") and
						not buff.rejuvenation.exists(tanks[i].unit) and
						br.getDistance(tanks[i].unit) <= 40
				 then
					clearform()
					if cast.rejuvenation(tanks[i].unit) then
						br.addonDebug("Casting Rejuvenation (Tank Rejuv)")
						return true
					end
				end
			end
			for i = 1, #br.friend do
				if
					talent.germination and br.friend[i].hp <= br.getValue("Germination") and
						(rejuvCount < br.getValue("Max Rejuvenation Targets")) and
						not buff.rejuvenationGermination.exists(br.friend[i].unit)
				 then
					clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (Germinate Party)")
						return true
					end
				elseif
					br.friend[i].hp <= br.getValue("Rejuvenation") and not buff.rejuvenation.exists(br.friend[i].unit) and
						(rejuvCount < br.getValue("Max Rejuvenation Targets"))
				 then
					clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (Rejuv Party)")
						return true
					end
				end
			end
		end
		-- Regrowth
		if not moving or buff.incarnationTreeOfLife.exists() then
			for i = 1, #br.friend do
				if
					br.isChecked("Regrowth Tank") and br.friend[i].hp <= br.getValue("Regrowth Tank") and
						(br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
						(not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot")))
				 then
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				elseif
					br.isChecked("Regrowth") and br.friend[i].hp <= br.getValue("Regrowth") and
						(not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot")))
				 then
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				end
			end
		end
	end

	-- All players Rejuvenation
	local function actionList_Rejuvenation()
		-- DOT damage to teammates cast Rejuvenation
		if br.isChecked("DOT cast Rejuvenation") then
			local debuff_list = {
				-- Uldir
				{spellID = 262313, stacks = 0, secs = 5}, -- Malodorous Miasma
				{spellID = 262314, stacks = 0, secs = 3}, -- Putrid Paroxysm
				{spellID = 264382, stacks = 0, secs = 1}, -- Eye Beam
				{spellID = 264210, stacks = 0, secs = 5}, -- Jagged Mandible
				{spellID = 265360, stacks = 0, secs = 5}, -- Roiling Deceit
				{spellID = 265129, stacks = 0, secs = 5}, -- Omega Vector
				{spellID = 266948, stacks = 0, secs = 5}, -- Plague Bomb
				{spellID = 274358, stacks = 0, secs = 5}, -- Rupturing Blood
				{spellID = 274019, stacks = 0, secs = 1}, -- Mind Flay
				{spellID = 272018, stacks = 0, secs = 1}, -- Absorbed in Darkness
				{spellID = 273359, stacks = 0, secs = 5}, -- Shadow Barrage
				-- Freehold
				{spellID = 257437, stacks = 0, secs = 5}, -- Poisoning Strike
				{spellID = 267523, stacks = 0, secs = 5}, -- Cutting Surge
				{spellID = 256363, stacks = 0, secs = 5}, -- Ripper Punch
				-- Shrine of the Storm
				{spellID = 264526, stacks = 0, secs = 5}, -- Grasp from the Depths
				{spellID = 264166, stacks = 0, secs = 1}, -- Undertow
				{spellID = 268214, stacks = 0, secs = 1}, -- Carve Flesh
				{spellID = 276297, stacks = 0, secs = 5}, -- Void Seed
				{spellID = 268322, stacks = 0, secs = 5}, -- Touch of the Drowned
				-- Siege of Boralus
				{spellID = 256897, stacks = 0, secs = 5}, -- Clamping Jaws
				{spellID = 273470, stacks = 0, secs = 3}, -- Gut Shot
				{spellID = 275014, stacks = 0, secs = 5}, -- Putrid Waters
				-- Tol Dagor
				{spellID = 258058, stacks = 0, secs = 1}, -- Squeeze
				{spellID = 260016, stacks = 0, secs = 3}, -- Itchy Bite
				{spellID = 260067, stacks = 0, secs = 5}, -- Vicious Mauling
				{spellID = 258864, stacks = 0, secs = 5}, -- Suppression Fire
				{spellID = 258917, stacks = 0, secs = 3}, -- Righteous Flames
				{spellID = 256198, stacks = 0, secs = 5}, -- Azerite Rounds: Incendiary
				{spellID = 256105, stacks = 0, secs = 1}, -- Explosive Burst
				-- Waycrest Manor
				{spellID = 266035, stacks = 0, secs = 1}, -- Bone Splinter
				{spellID = 260703, stacks = 0, secs = 1}, -- Unstable Runic Mark
				{spellID = 260741, stacks = 0, secs = 1}, -- Jagged Nettles
				{spellID = 264050, stacks = 0, secs = 3}, -- Infected Thorn
				{spellID = 264556, stacks = 0, secs = 2}, -- Tearing Strike
				{spellID = 264150, stacks = 0, secs = 1}, -- Shatter
				{spellID = 265761, stacks = 0, secs = 1}, -- Thorned Barrage
				{spellID = 263905, stacks = 0, secs = 1}, -- Marking Cleave
				{spellID = 264153, stacks = 0, secs = 3}, -- Spit
				{spellID = 278456, stacks = 0, secs = 3}, -- Infest
				{spellID = 271178, stacks = 0, secs = 3}, -- Ravaging Leap
				{spellID = 265880, stacks = 0, secs = 1}, -- Dread Mark
				{spellID = 265882, stacks = 0, secs = 1}, -- Lingering Dread
				{spellID = 264378, stacks = 0, secs = 5}, -- Fragment Soul
				{spellID = 261438, stacks = 0, secs = 1}, -- Wasting Strike
				{spellID = 261440, stacks = 0, secs = 1}, -- Virulent Pathogen
				{spellID = 268202, stacks = 0, secs = 1}, -- Death Lens
				-- Atal'Dazar
				{spellID = 253562, stacks = 0, secs = 3}, -- Wildfire
				{spellID = 254959, stacks = 0, secs = 2}, -- Soulburn
				{spellID = 255558, stacks = 0, secs = 5}, -- Tainted Blood
				{spellID = 255814, stacks = 0, secs = 5}, -- Rending Maul
				{spellID = 250372, stacks = 0, secs = 5}, -- Lingering Nausea
				{spellID = 250096, stacks = 0, secs = 1}, -- Wracking Pain
				{spellID = 256577, stacks = 0, secs = 5}, -- Soulfeast
				-- King's Rest
				{spellID = 269932, stacks = 0, secs = 3}, -- Gust Slash
				{spellID = 265773, stacks = 0, secs = 4}, -- Spit Gold
				{spellID = 270084, stacks = 0, secs = 3}, -- Axe Barrage
				{spellID = 270865, stacks = 0, secs = 3}, -- Hidden Blade
				{spellID = 270289, stacks = 0, secs = 3}, -- Purification Beam
				{spellID = 271564, stacks = 0, secs = 3}, -- Embalming
				{spellID = 267618, stacks = 0, secs = 3}, -- Drain Fluids
				{spellID = 270487, stacks = 0, secs = 3}, -- Severing Blade
				{spellID = 270507, stacks = 0, secs = 5}, -- Poison Barrage
				{spellID = 266231, stacks = 0, secs = 3}, -- Severing Axe
				{spellID = 267273, stacks = 0, secs = 3}, -- Poison Nova
				{spellID = 268419, stacks = 0, secs = 3}, -- Gale Slash
				-- MOTHERLODE!!
				{spellID = 269298, stacks = 0, secs = 1}, -- Widowmaker
				{spellID = 262347, stacks = 0, secs = 1}, -- Static Pulse
				{spellID = 263074, stacks = 0, secs = 3}, -- Festering Bite
				{spellID = 262270, stacks = 0, secs = 1}, -- Caustic Compound
				{spellID = 262794, stacks = 0, secs = 1}, -- Energy Lash
				{spellID = 259853, stacks = 0, secs = 3}, -- Chemical Burn
				{spellID = 269092, stacks = 0, secs = 1}, -- Artillery Barrage
				{spellID = 262348, stacks = 0, secs = 1}, -- Mine Blast
				{spellID = 260838, stacks = 0, secs = 1}, -- Homing Missile
				-- Temple of Sethraliss
				{spellID = 263371, stacks = 0, secs = 1}, -- Conduction
				{spellID = 272657, stacks = 0, secs = 3}, -- Noxious Breath
				{spellID = 267027, stacks = 0, secs = 1}, -- Cytotoxin
				{spellID = 272699, stacks = 0, secs = 3}, -- Venomous Spit
				{spellID = 268013, stacks = 0, secs = 5}, -- Flame Shock
				-- Underrot
				{spellID = 265019, stacks = 0, secs = 1}, -- Savage Cleave
				{spellID = 265568, stacks = 0, secs = 1}, -- Dark Omen
				{spellID = 260685, stacks = 0, secs = 5}, -- Taint of G'huun
				{spellID = 278961, stacks = 0, secs = 5}, -- Decaying Mind
				{spellID = 260455, stacks = 0, secs = 1}, -- Serrated Fangs
				{spellID = 273226, stacks = 0, secs = 1}, -- Decaying Spores
				{spellID = 269301, stacks = 0, secs = 5} -- Putrid Blood
			}
			for i = 1, #br.friend do
				if br._G.UnitInRange(br.friend[i].unit) then
					for k, v in pairs(debuff_list) do
						if
							br.getDebuffRemain(br.friend[i].unit, v.spellID) > v.secs and
								br.getDebuffStacks(br.friend[i].unit, v.spellID) >= v.stacks and
								not buff.rejuvenation.exists(br.friend[i].unit)
						 then
							clearform()
							if cast.rejuvenation(br.friend[i].unit) then
								br.addonDebug("Casting Rejuvenation (DOT Rejuv)")
								return true
							end
						end
					end
				end
			end
		end
		--DBM cast Rejuvenation
		if br.isChecked("DBM cast Rejuvenation") then
			local precast_spell_list = {
				--spell_id	, precast_time	,	spell_name
				{214652, 5, "Acidic Fragments"},
				{205862, 5, "Slam"},
				{218774, 5, "Summon Plasma Spheres"},
				{206949, 5, "Frigid Nova"},
				{206517, 5, "Fel Nova"},
				{207720, 5, "Witness the Void"},
				{206219, 5, "Liquid Hellfire"},
				{211439, 5, "Will of the Demon Within"},
				{209270, 5, "Eye of Guldan"},
				{227071, 5, "Flame Crash"},
				{233279, 5, "Shattering Star"},
				{233441, 5, "Bone Saw"},
				{235230, 5, "Fel Squall"},
				{231854, 5, "Unchecked Rage"},
				{232174, 5, "Frosty Discharge"},
				{230139, 5, "Hydra Shot"},
				{233264, 5, "Embrace of the Eclipse"},
				{236542, 5, "Sundering Doom"},
				{236544, 5, "Doomed Sundering"},
				{235059, 5, "Rupturing Singularity"},
				{196587, 5, "Soul Burst"}, --Amalgam of Souls
				{211464, 5, "Fel Detonation"}, --Advisor Melandrus
				{237276, 5, "Pulverizing Cudgel"}, --Thrashbite the Scornful
				{193611, 5, "Focused Lightning"}, --Lady Hatecoil
				{192305, 5, "Eye of the Storm"}, --Hyrja
				{239132, 5, "Rupture Realities"}, --Fallen Avatar
				{281936, 5, "Tantrum"}, -- Grong
				{282399, 5, "Death Knell"}, --Grong(Revenant)
				{284941, 5, "Wail of Greed"}, -- Opulence
				{282107, 5, "Paku's Wrath"}, -- Conclave
				{282742, 5, "Storm of Annihilation"} -- Crucible of Storms
			}
			for j = 1, #br.friend do
				if br._G.UnitInRange(br.friend[j].unit) then
					for i = 1, #precast_spell_list do
						local boss_spell_id = precast_spell_list[i][1]
						local precast_time = precast_spell_list[i][2]
						local spell_name = precast_spell_list[i][3]
						local time_remain = br.DBM:getPulltimer(nil, boss_spell_id)
						if time_remain < precast_time then
							if not buff.rejuvenation.exists(br.friend[j].unit) then
								clearform()
								if cast.rejuvenation(br.friend[j].unit) then
									br.addonDebug("Casting Rejuvenation (DBM Rejuv)")
									return true
								end
							end
						end
					end
				end
			end
		end
		-- Avoid wasting Innervate
		if buff.innervate.exists() then
			for i = 1, #br.friend do
				if not buff.rejuvenation.exists(br.friend[i].unit) then
					clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation(Innervate Rejuv)")
						return true
					end
				end
			end
		end
		-- Mana hundred percent cast rejuvenation
		if inRaid then
			for i = 1, #br.friend do
				if not travel and mana >= 99 and not buff.rejuvenation.exists(br.friend[i].unit) then
					clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (100% Rejuv)")
						return true
					end
				end
			end
		end
	end

	local function actionList_RejuvenationMode()
		if rejuvCount < br.getOptionValue("Max Rejuvenation Targets") and (mode.prehot == 1 or inCombat) then
			for i = 1, #br.friend do
				if not buff.rejuvenation.exists(br.friend[i].unit) and (br.friend[i].hp < 75 or (mode.prehot == 1 and not inCombat)) then
					clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (All Player Rejuv)")
						return true
					end
				end
			end
			if talent.germination then
				for i = 1, #br.friend do
					if
						not buff.rejuvenationGermination.exists(br.friend[i].unit) and
							(br.friend[i].hp < 60 or (mode.prehot == 1 and not inCombat))
					 then
						clearform()
						if cast.rejuvenation(br.friend[i].unit) then
							br.addonDebug("Casting Rejuvenation (All Player Double Rejuv)")
							return true
						end
					end
				end
			end
		end
	end

	-- Action List - DPS
	local function actionList_DPS()
		if
			br.useCDs() and covenant.nightFae.active and
				(br.getOptionValue("Convoke Spirits") == 1 or br.getOptionValue("Convoke Spirits") == 3) and
				br.getTTD("target") > 10 and
				(buff.heartOfTheWild.exists() or cd.heartOfTheWild.remains() > 30 or not talent.heartOfTheWild or
					not br.isChecked("Heart of the Wild"))
		 then
			if cast.convokeTheSpirits() then
				br.addonDebug("Casting Convoke the Spirits (Damage)")
				return true
			end
		end
		-- Guardian Affinity/Level < 45
		if talent.guardianAffinity or level < 45 then
			-- Sunfire
			if mana >= br.getOptionValue("DPS Save mana") and debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") then
				for i = 1, #enemies.yards40 do
					local thisUnit = enemies.yards40[i]
					if not debuff.sunfire.exists(thisUnit) and not br.isExplosive(thisUnit) then
						if cast.sunfire(thisUnit) then
							br.addonDebug("Casting Sunfire")
							return true
						end
					end
				end
			end
			-- Moonfire
			if
				(not br.isChecked("DPS Key") and
					(not br.isChecked("Auto Shapeshifts") or
						(br.isChecked("Auto Shapeshifts") and br.getOptionValue("Auto Shapeshifts") == 2))) or
					br.getDistance("target", "player") > 8
			 then
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets")
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not br.isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
			end
			-- Bear Form
			if
				not bear and br.isChecked("Bear Form Shifting") and br.getDistance("target", "player") <= 8 and
					((br.isChecked("Auto Shapeshifts") and
						(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 3)) or
						br.isChecked("DPS Key"))
			 then
				if cast.bearForm("player") then
					br.addonDebug("Casting Bear Form")
					return true
				end
			end
			if bear then
				-- Moonfire
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets")
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not br.isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
				if br.player.power.rage.amount() >= 10 and php < 80 and not buff.frenziedRegeneration.exists() then
					if cast.frenziedRegeneration() then
						br.addonDebug("Casting Frenzied Regeneration")
						return true
					end
				end
				if br.player.power.rage.amount() >= 45 then
					if cast.ironfur() then
						br.addonDebug("Casting Iron Fur")
						return true
					end
				end
				if br.GetUnitExists("target") then
					if cast.mangle("target") then
						br.addonDebug("Casting Mangle")
						return true
					end
				end
				if br.GetUnitExists("target") then
					if cast.thrashBear("target") then
						br.addonDebug("Casting Thrash")
						return true
					end
				end
			end
			-- Wrath
			if not moving and br.GetUnitExists("target") then
				if
					(br.isChecked("Auto Shapeshifts") and
						(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 3)) or
						br.isChecked("DPS Key")
				 then
					if br.getDistance("target", "player") > 5 or not bear and br.getFacing("player", "target") then
						if cast.wrath("target") then
							br.addonDebug("Casting Solar Wrath")
							return true
						end
					end
				elseif
					(not br.isChecked("Auto Shapeshifts") or
						(br.isChecked("Auto Shapeshifts") and br.getOptionValue("Auto Shapeshifts") == 2)) and
						br.getFacing("player", "target")
				 then
					if cast.wrath("target") then
						br.addonDebug("Casting Solar Wrath")
						return true
					end
				end
			end
		end
		-- Feral Affinity
		if talent.feralAffinity and br.GetUnitExists("target") then
			local nearEnemies = #enemies.yards5f
			if not br.druid.catRecover and br.player.power.energy.amount() < 50 and combo == 0 then
				br.druid.catRecover = true
			elseif br.druid.catRecover and br.player.power.energy.amount() == 100 then
				br.druid.catRecover = false
			end
			if
				(br.druid.catRecover or not cat or not br.isChecked("Auto Shapeshifts") or
					(br.isChecked("Auto Shapeshifts") and br.getOptionValue("Auto Shapeshifts") == 2)) and
					br.isChecked("HOT Mode")
			 then
				actionList_hots()
			end
			if cat and br.getDistance("target") <= 5 then
				br._G.StartAttack()
			end
			if
				nearEnemies < 1 or
					((not br.isChecked("Auto Shapeshifts") or
						(br.isChecked("Auto Shapeshifts") and br.getOptionValue("Auto Shapeshifts") == 2)) and
						not cat)
			 then
				-- Moonfire
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets")
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not br.isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
				-- Sunfire
				if mana >= br.getOptionValue("DPS Save mana") and debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.sunfire.exists(thisUnit) and not br.isExplosive(thisUnit) then
							if cast.sunfire(thisUnit) then
								br.addonDebug("Casting Sunfire")
								return true
							end
						end
					end
				end
				-- Solar Wrath
				if not moving and br.getFacing("player", "target") then
					if cast.wrath("target") then
						br.addonDebug("Casting Solar Wrath")
						return true
					end
				end
			elseif nearEnemies == 1 then
				-- Moonfire
				if
					not debuff.moonfire.exists("target") and mana >= br.getOptionValue("DPS Save mana") and
						debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets") and
						not br.isExplosive("target")
				 then
					if cast.moonfire("target") then
						br.addonDebug("Casting Moonfire")
						return true
					end
				end
				-- Sunfire
				if
					not debuff.sunfire.exists("target") and mana >= br.getOptionValue("DPS Save mana") and
						debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") and
						not br.isExplosive("target")
				 then
					if cast.sunfire("target") then
						br.addonDebug("Casting Sunfire")
						return true
					end
				end
				if debuff.sunfire.remains("target") > 2 and debuff.moonfire.remains("target") > 2 then
					-- Cat Form
					if
						not cat and (not bear or (bear and (not br.druid.bearTimer or br._G.GetTime() - br.druid.bearTimer >= br.druid.catRecharge))) and
							br.GetUnitExists("target") and
							br.getDistance("target", "player") <= 8 and
							((br.isChecked("Auto Shapeshifts") and
								(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 3)) or
								br.isChecked("DPS Key"))
					 then
						if cast.catForm("player") then
							br.addonDebug("Casting Cat Form")
							return true
						end
					end
				end
				-- Rake
				if cat and not debuff.rake.exists("target") then
					if cast.rake("target") then
						br.addonDebug("Casting Rake")
						return true
					end
				end
				--Shred
				if cat and combo < 5 and debuff.rake.exists("target") then
					if cast.shred("target") then
						br.addonDebug("Casting Shred")
						return true
					end
				end
				-- Rip
				if
					cat and combo >= 2 and ttd("target") >= 14 and
						(not debuff.rip.exists("target") or debuff.rip.remains("target") < 4)
				 then
					if cast.rip("target") then
						br.addonDebug("Casting Rip")
						return true
					end
				end
				-- Ferocious Bite
				if cat and combo == 5 and br.player.power.energy.amount() >= 50 then
					if cast.ferociousBite("target") then
						br.addonDebug("Casting Ferocious Bite")
						return true
					end
				end
			elseif nearEnemies > 1 and nearEnemies < 4 then
				-- Sunfire
				if
					#enemies.yards8t > 1 and not debuff.sunfire.exists("target") and mana >= br.getOptionValue("DPS Save mana") and
						not br.isExplosive("target")
				 then
					if cast.sunfire("target") then
						br.addonDebug("Casting Sunfire")
						return true
					end
				end
				-- Moonfire
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets")
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards8[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not br.isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
				-- Sunfire
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") and
						not br.isExplosive(thisUnit)
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.sunfire.exists(thisUnit) then
							if cast.sunfire(thisUnit) then
								br.addonDebug("Casting Sunfire")
								return true
							end
						end
					end
				end
				-- Cat Form
				if
					not cat and (not bear or (bear and (not br.druid.bearTimer or br._G.GetTime() - br.druid.bearTimer >= br.druid.catRecharge))) and
						br.GetUnitExists("target") and
						br.getDistance("target", "player") <= 8 and
						((br.isChecked("Auto Shapeshifts") and
							(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 3)) or
							br.isChecked("DPS Key"))
				 then
					if cast.catForm("player") then
						br.addonDebug("Casting Cat Form")
						return true
					end
				end
				-- Rake
				if cat then
					for i = 1, nearEnemies do
						local thisUnit = enemies.yards8[i]
						if ttd(thisUnit) >= 10 and not debuff.rake.exists(thisUnit) then
							if cast.rake(thisUnit) then
								br.addonDebug("Casting Rake")
								return true
							end
						end
					end
				end
				-- Swipe
				if cat and combo < 5 then
					if cast.swipeCat() then
						br.addonDebug("Casting Swipe")
						return true
					end
				end
				-- Rip
				if cat and combo >= 2 then
					for i = 1, nearEnemies do
						local thisUnit = enemies.yards8[i]
						if (not debuff.rip.exists(thisUnit) or debuff.rip.remain(thisUnit) < 4) and ttd(thisUnit) >= 14 then
							if cast.rip(thisUnit) then
								br.addonDebug("Casting Rip")
								return true
							end
						end
					end
				end
				-- Ferocious Bite
				if cat and combo == 5 and br.player.power.energy.amount() >= 50 then
					if cast.ferociousBite("target") then
						br.addonDebug("Casting Ferocious Bite")
						return true
					end
				end
			elseif nearEnemies >= 4 then
				--Sunfire
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") and
						not br.isExplosive(thisUnit)
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.sunfire.exists(thisUnit) then
							if cast.sunfire(thisUnit) then
								br.addonDebug("Casting Sunfire")
								return true
							end
						end
					end
				end
				-- Cat Form
				if
					not cat and (not bear or (bear and (not br.druid.bearTimer or br._G.GetTime() - br.druid.bearTimer >= br.druid.catRecharge))) and
						br.GetUnitExists("target") and
						br.getDistance("target", "player") <= 8 and
						((br.isChecked("Auto Shapeshifts") and
							(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 3)) or
							br.isChecked("DPS Key"))
				 then
					if cast.catForm("player") then
						br.addonDebug("Casting Cat Form")
						return true
					end
				end
				-- Swipe
				if cat then
					if cast.swipeCat() then
						br.addonDebug("Casting Swipe")
						return true
					end
				end
				-- Bear Form
				if
					br.player.power.energy.amount() < 35 and not bear and
						((br.isChecked("Auto Shapeshifts") and
							(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 3)) or
							br.isChecked("DPS Key"))
				 then
					br.druid.bearTimer = br._G.GetTime()
					br.druid.catRecharge = br.player.power.energy.ttm()
					if cast.bearForm("player") then
						br.addonDebug("Casting Bear Form")
						return true
					end
				end
				-- Bear Swipe
				if bear and br._G.GetTime() - br.druid.bearTimer < br.druid.catRecharge then
					if cast.swipeBear() then
						br.addonDebug("Casting Swipe (Bear)")
						return true
					end
				end
			end
		end -- End - Feral Affinity
		-- Balance Affinity
		if talent.balanceAffinity then
			local eclipse_in = (buff.eclipse_solar.exists() or buff.eclipse_lunar.exists()) or false
			local current_eclipse = "none"
			local eclipse_next = "any"
			if br.isChecked("HOT Mode") then
				if actionList_hots() then
					return true
				end
			end
			if mana >= br.getOptionValue("DPS Save mana") then
				-- Moonkin form
				if
					not moonkin and not moving and not travel and not br._G.IsMounted() and br._G.GetTime() - br.shiftTimer > 5 and
						((br.isChecked("Auto Shapeshifts") and
							(br.getOptionValue("Auto Shapeshifts") == 1 or br.getOptionValue("Auto Shapeshifts") == 3)) or
							br.isChecked("DPS Key"))
				 then
					for i = 1, #br.friend do
						if buff.lifebloom.exists(br.friend[i].unit) and buff.lifebloom.remain(br.friend[i].unit) < 5 then
							return true
						end
					end
					if cast.moonkinForm() then
						br.addonDebug("Casting Moonkin Form")
						return true
					end
				end
				-- Ravenous Frenzy
				if br.isChecked("Ravenous Frenzy") and covenant.venthyr.active then
					if cast.ravenousFrenzy() then
						br.addonDebug("Casting Ravenous Frenzy")
						return true
					end
				end
				-- Sunfire
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") and
						not br.isExplosive(thisUnit)
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.sunfire.exists(thisUnit) then
							if cast.sunfire(thisUnit) then
								br.addonDebug("Casting Sunfire")
								return true
							end
						end
					end
				end
				-- Moonfire
				if
					mana >= br.getOptionValue("DPS Save mana") and debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets")
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not br.isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
				-- Adaptive Swarm
				if
					br.isChecked("Adaptive Swarm") and covenant.necrolord.active and
						debuff.adaptiveSwarm.count() < br.getOptionValue("Adaptive Swarm")
				 then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.adaptiveSwarm.exists(thisUnit) and ttd(thisUnit) > 10 and not br.isExplosive(thisUnit) then
							if cast.adaptiveSwarm(thisUnit) then
								br.addonDebug("Casting Adaptive Swarm")
								return true
							end
						end
					end
				end
				-- Empower Bond (To do)
				-- Heart of the Wild
				if br.isChecked("Heart of the Wild") and buff.moonkinForm.exists() and talent.heartOfTheWild then
					if cast.heartOfTheWild() then
						return true
					end
				end

				if buff.eclipse_solar.exists() then
					eclipse_next = "lunar"
				end
				if buff.eclipse_lunar.exists() then
					eclipse_next = "solar"
				end
				-- Starsurge
				if not moving and buff.moonkinForm.exists() and br.getFacing("player", "target") and eclipse_in then
					if cast.starsurgeAff() then
						br.addonDebug("Casting Starsurge")
						return true
					end
				end
				-- Starfire
				if
					not moving and buff.moonkinForm.exists() and br.getFacing("player", "target") and
						(buff.eclipse_lunar.exists() or (not eclipse_in and (eclipse_next == "solar" or eclipse_next == "any")))
				 then
					if cast.starfire(br.getBiggestUnitCluster(45, 8)) then
						br.addonDebug("Casting Starfire")
						return true
					end
				end
				-- Wrath (Solar)
				if
					not moving and buff.moonkinForm.exists() and br.getFacing("player", "target") and
						(buff.eclipse_solar.exists() or (not eclipse_in and (eclipse_next == "lunar" or eclipse_next == "any")))
				 then
					if cast.wrath() then
						br.addonDebug("Casting Wrath")
						return true
					end
				end
				--Wrath
				if not moving and br.getFacing("player", "target") and not eclipse_in then
					if cast.wrath() then
						br.addonDebug("Casting Wrath")
						return true
					end
				end
			end
		end -- End -- Balance Affinity
	end -- End Action List - DPS
	if
		br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and
			br.timer:useTimer("Error delay", 0.5)
	 then
		br._G.print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
		return true
	end
	-----------------
	--- Rotations ---
	-----------------
	-- Pause
	if
		br.pause() or (travel and not inCombat) or stealthed or drinking or br.isCastingSpell(spell.tranquility) or
			cd.global.remains() > 0
	 then
		return true
	else
		---------------------------------
		--- Out Of Combat - Rotations ---
		---------------------------------
		if not inCombat then
			if key() then
				return true
			end
			if actionList_Extras() then
				return true
			end
			if actionList_PreCombat() then
				return true
			end
			if actionList_Decurse() then
				return true
			end
			if br.isChecked("OOC Healing") then
				if actionList_AOEHealing() then
					return true
				end
				if actionList_SingleTarget() then
					return true
				end
				if actionList_RejuvenationMode() then
					return true
				end
			end
		end -- End Out of Combat Rotation
		-----------------------------
		--- In Combat - Rotations ---
		-----------------------------
		if inCombat then
			if not br.isChecked("DPS Key") then
				if
					(br.druid.restoDPS and lowest.hp <= br.getOptionValue("Critical Heal")) or buff.incarnationTreeOfLife.exists() or
						mode.dPS == 1
				 then
					br.ChatOverlay("Healing Engaged")
					br.addonDebug("Healing Engaged")
					br.druid.restoDPS = false
				elseif
					not br.druid.restoDPS and lowest.hp > br.getOptionValue("DPS") and not buff.incarnationTreeOfLife.exists() and mode.dPS == 2
				 then
					br.ChatOverlay("DPS Engaged")
					br.addonDebug("DPS Engaged")
					br.druid.restoDPS = true
				end
			end
			if br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() and br.isChecked("DPS Key") then
				if actionList_DPS() then
					return true
				end
			else
				if key() then
					return true
				end
				if BossEncounterCase() then
					return true
				end
				if actionList_Defensive() then
					return true
				end
				if actionList_Cooldowns() then
					return true
				end
				if actionList_Interrupts() then
					return true
				end
				if actionList_Decurse() then
					return true
				end
				if (not br.druid.restoDPS and not br.isChecked("DPS Key")) or br.isChecked("DPS Key") then
					if actionList_AOEHealing() then
						return true
					end
					if actionList_SingleTarget() then
						return true
					end
				end
				if
					#enemies.yards5 < 1 and mode.dPS == 2 and br.isChecked("DPS Key") and not br.SpecificToggle("DPS Key") and
						not br._G.GetCurrentKeyBoardFocus()
				 then
					-- Moonfire
					if
						mana >= br.getOptionValue("DPS Save mana") and debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets")
					 then
						for i = 1, #enemies.yards40 do
							local thisUnit = enemies.yards40[i]
							if not debuff.moonfire.exists(thisUnit) and not br.isExplosive(thisUnit) then
								if cast.moonfire(thisUnit) then
									br.addonDebug("Casting Moonfire")
									return true
								end
							end
						end
					end
					-- Sunfire
					if mana >= br.getOptionValue("DPS Save mana") then
						for i = 1, #enemies.yards40 do
							local thisUnit = enemies.yards40[i]
							if not debuff.sunfire.exists(thisUnit) and not br.isExplosive(thisUnit) then
								if cast.sunfire(thisUnit) then
									br.addonDebug("Casting Sunfire")
									return true
								end
							end
						end
					end
				end
				if not br.isChecked("DPS Key") and mode.dPS == 2 and br.druid.restoDPS then
					if
						not br.GetUnitExists("target") or
							(br.GetUnitIsDeadOrGhost("target") and not br.GetUnitIsFriend("target")) and #enemies.yards40 ~= 0 and
								br.getOptionValue("Target Dynamic Target")
					 then
						br._G.TargetUnit(enemies.yards40[1])
					end
					if br.GetUnitExists("target") and not br.GetUnitIsFriend("target") then
						if actionList_DPS() then
							return true
						end
					end
				end
				if (not br.druid.restoDPS and not br.isChecked("DPS Key")) or br.isChecked("DPS Key") then
					if actionList_Rejuvenation() then
						return true
					end
					if actionList_RejuvenationMode() then
						return true
					end
					if
						(br.isChecked("DPS Key") and br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus()) or
							(not br.isChecked("DPS Key") and mode.dPS == 2)
					 then
						if actionList_DPS() then
							return true
						end
					end
				end
			end
		end -- End In Combat Rotation
	end -- Pause
	-- end -- End Timer
end -- End runRotation
local id = 105
if br.rotations[id] == nil then
	br.rotations[id] = {}
end
br._G.tinsert(
	br.rotations[id],
	{
		name = rotationName,
		toggles = createToggles,
		options = createOptions,
		run = runRotation
	}
)

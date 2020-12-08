local rotationName = "Aura"

---------------
--- Toggles ---
---------------
local function createToggles()
	-- Cooldown Button
	CooldownModes = {
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
	DefensiveModes = {
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
	DecurseModes = {
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
	InterruptModes = {
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
	DPSModes = {
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
	-- Rejuvenation Button
	RejuvenationModes = {
		[2] = {
			mode = "On",
			value = 1,
			overlay = "Rejuvenation Enabled",
			tip = "All players Rejuvenation Enabled",
			highlight = 1,
			icon = br.player.spell.rejuvenation
		},
		[3] = {
			mode = "two",
			value = 2,
			overlay = "Double Rejuvenation Enabled",
			tip = "All players Double Rejuvenation Enabled",
			highlight = 1,
			icon = 155675
		},
		[1] = {
			mode = "Off",
			value = 3,
			overlay = "Rejuvenation Disabled",
			tip = "All players Rejuvenation Disabled",
			highlight = 0,
			icon = br.player.spell.rejuvenation
		}
	}
	CreateButton("Rejuvenation", 6, 0)
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
		br.ui:createCheckbox(section, "OOC Healing", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.", 1)
		-- DBM cast Rejuvenation
		br.ui:createCheckbox(
			section,
			"DBM cast Rejuvenation",
			"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAccording to BOSS AOE Spells, 5 seconds ahead of schedule cast Rejuvenation|cffFFBB00."
		)
		-- DOT cast Rejuvenation
		br.ui:createCheckbox(section, "DOT cast Rejuvenation", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFDOT damage to teammates cast Rejuvenation|cffFFBB00.")
		-- Pre-Pull Timer
		br.ui:createSpinner(section, "Pre-Pull Timer", 5, 0, 20, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
		-- Travel Shapeshifts
		br.ui:createDropdown(
			section,
			"Auto Shapeshifts",
			{colorGreen .. "All", colorYellow .. "Travel Only", colorYellow .. "DPS Only"},
			1,
			"|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation|cffFFBB00."
		)
		br.ui:createCheckbox(section, "Bear Form Shifting", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFShapeshifting into Bear Form to DPS for Guardian Affinity")
		br.ui:createSpinnerWithout(section, "Temple of Seth Heal", 70, 0, 100, 5, "Minimum party member health to focus on healing Seth")
		-- Bursting Stack
		br.ui:createSpinnerWithout(section, "Bursting", 1, 1, 10, 1, "", "|cffFFFFFFWhen Bursting stacks are above this amount, CDs will be triggered.")
		-- DPS
		br.ui:createSpinnerWithout(section, "DPS", 70, 0, 100, 5, "|cffFFFFFFIf over this value, rotation will switch to DPS. (Auto DPS Only)")
		br.ui:createSpinnerWithout(section, "Critical Heal", 70, 0, 100, 5, "|cffFFFFFFIf under this value, rotation will switch to healing. (Auto DPS Only)")
		br.ui:createDropdown(section, "DPS Key", br.dropOptions.Toggle, 6, "Set a key for using DPS (Will ignore DPS HP Thresholds)")
		br.ui:createCheckbox(section, "HOT Mode", "Keep HOTs on tanks when cat weaving. (Experimental)")
		br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1" )
		br.ui:createSpinnerWithout(section, "Max Sunfire Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Sunfire. Min: 1 / Max: 10 / Interval: 1" )
		-- DPS Save mana
		br.ui:createSpinnerWithout(section, "DPS Save mana", 40, 0, 100, 5, "|cffFFFFFFMana Percent to Stop DPS")
		-- Auto Soothe
		br.ui:createCheckbox(section, "Auto Soothe")
		-- Revive
		br.ui:createDropdown(section, "Revive", {"|cffFFFF00Selected Target", "|cffFF0000Mouseover Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")

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
		br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
		br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
		br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
		br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
		br.ui:createSpinner(section, "Revitalizing Voodoo Totem", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
        br.ui:createSpinner(section, "Inoculating Extract", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
        br.ui:createSpinner(section,"Ward of Envelopment", 75, 0 , 100, 5, "|cffFFFFFFHealth Percent to Cast At. Default: 75")
		-- Innervate
		br.ui:createSpinner(section, "Innervate", 60, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Innervate Targets", 3, 0, 40, 1, "Minimum Innervate Targets")
		--Incarnation: Tree of Life
		br.ui:createSpinner(section, "Incarnation", 60, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Incarnation Targets", 3, 0, 40, 1, "Minimum Incarnation: Tree of Life Targets")
		-- Tranquility
		br.ui:createSpinner(section, "Tranquility", 50, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Tranquility Targets", 3, 0, 40, 1, "Minimum Tranquility Targets")
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
		-- Guardian Shell
			-- br.ui:createSpinner(section, "Guardian Shell", 85, 1, 100, 5, "Health threshold to use")
            -- br.ui:createSpinnerWithout(section, "Guardian Shell Targets", 5, 1, 40, 1, "Number of targets to use")			
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
		br.ui:createSpinnerWithout(section, "Efflorescence Recast Delay", 3, 0, 30, 1, "Delay Between Checks for Efflorescence")
		br.ui:createDropdown(section, "Efflorescence Key", br.dropOptions.Toggle, 6, colorGreen .. "Enables" .. colorWhite .. "/" .. colorRed .. "Disables " .. colorWhite .. " Efflorescence manual usage.")
		br.ui:createCheckbox(section, "Efflorescence on Melee", "Cast on Melee only")
		br.ui:createCheckbox(section, "Efflorescence on CD", "Requires Efflorescence on Melee to be checked to work")
		-- Lifebloom
		br.ui:createDropdown(section, "Lifebloom", {"|cffFFFFFFTank", "|cffFFFFFFBoss1 Target", "|cffFFFFFFSelf", "|cffFFFFFFFocus"}, 1, "|cffFFFFFFTarget for Lifebloom")
		-- Cenarion Ward
		br.ui:createSpinner(section, "Cenarion Ward", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
		br.ui:createDropdownWithout(section, "Cenarion Ward Target", {"|cffFFFFFFTank", "|cffFFFFFFBoss1 Target", "|cffFFFFFFSelf", "|cffFFFFFFAny"}, 1, "|cffFFFFFFcast Cenarion Ward Target")
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
		br.ui:createSpinnerWithout(section, "Max Rejuvenation Targets", 10, 0, 20, 1, "|cffFFFFFFMaximum Rejuvenation Targets")
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
		-- Cultivation
		br.ui:createCheckbox(section, "Cultivation", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFrejuvenation priority when less than 5 targets are below 60% hp|cffFFBB00.")
		-- Wild Growth
		br.ui:createSpinner(section, "Wild Growth", 80, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Wild Growth Targets", 3, 0, 40, 1, "Minimum Wild Growth Targets")
		br.ui:createSpinner(section, "Soul of the Forest + Wild Growth", 80, 0, 100, 5, "Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Soul of the Forest + Wild Growth Targets", 3, 0, 40, 1, "Minimum Soul of the Forest + Wild Growth Targets")
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
	-- local combatTime                                    = getCombatTime()
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
	local debuff = br.player.debuff
	local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0
	local resable = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") and UnitInRange("target")
	local deadtar = UnitIsDeadOrGhost("target") or isDummy()
	local essence = br.player.essence
	local hastar = hastar or GetObjectExists("target")
	local enemies = br.player.enemies
	local friends = friends or {}
	local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
	local moving = isMoving("player") ~= false or br.player.moving
	local gcdMax = br.player.gcdMax
	local healPot = getHealthPot()
	local inCombat = isInCombat("player")
	local inInstance = br.player.instance == "party"
	local inRaid = br.player.instance == "raid"
	local stealthed = UnitBuffID("player", 5215) ~= nil
	local level = br.player.level
	local lowestHP = br.friend[1].unit
	local mana = br.player.power.mana.percent()
	local mode = br.player.ui.mode
	local php = br.player.health
	local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
	local pullTimer = br.DBM:getPulltimer()
	local race = br.player.race
	local racial = br.player.getRacial()
	local spell = br.player.spell
	local talent = br.player.talent
	local travel = br.player.buff.travelForm.exists()
	local cat = br.player.buff.catForm.exists()
	local moonkin = br.player.buff.moonkinForm.exists()
	local bear = br.player.buff.bearForm.exists()
	local noform = GetShapeshiftForm() == 0
	local units = br.player.units
	local bloomCount = 0
	local rejuvCount = 0
	local tanks = getTanksTable()
	local ttd = getTTD
	local burst = nil

	units.get(5)
	units.get(8)

	enemies.get(5)
	enemies.get(5,"player",false,true)
	enemies.get(8)
	enemies.get(8, "target")
	enemies.get(15)
	enemies.get(40)
	friends.yards40 = getAllies("player", 40)

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

	local lowest = {}
	lowest.unit = "player"
	lowest.hp = 100
	for i = 1, #br.friend do
		if br.friend[i].hp < lowest.hp then
			lowest = br.friend[i]
		end
	end

	shiftTimer = shiftTimer or 0
	local function clearform()
		if not noform and not buff.incarnationTreeOfLife.exists() and not buff.treantForm.exists() then
			RunMacroText("/CancelForm")
		end
	end
	-- All Hot Cnt
	local function getAllHotCnt(time_remain)
		hotCnt = 0
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
	-- Photosynthesis logic
	if getOptionValue("Lifebloom") == 1 and talent.photosynthesis and not buff.lifebloom.exists("player") and isCastingSpell(spell.wildGrowth) then
		--clearform()
		if CastSpellByName(GetSpellInfo(33763), "player") then
			br.addonDebug("Casting Lifebloom (Photosynthesis)")
			return true
		end
	end

	local function key()
		-- Swiftmend + Wild Growth key
		if isChecked("Swiftmend + Wild Growth key") and (SpecificToggle("Swiftmend + Wild Growth key") and not GetCurrentKeyBoardFocus()) then
			if not buff.soulOfTheForest.exists() and getSpellCD(48438) < gcdMax then
				--clearform()
				if cast.swiftmend(lowestHP) then
					br.addonDebug("Casting Swiftmend")
					return true
				end
			end
			if buff.soulOfTheForest.exists() then
				--clearform()
				if cast.wildGrowth() then
					br.addonDebug("Casting Wildgrowth")
					return true
				end
			end
		end
		-- Efflorescence key
		if (SpecificToggle("Efflorescence Key") and not GetCurrentKeyBoardFocus()) then
			--clearform()
			CastSpellByName(GetSpellInfo(spell.efflorescence), "cursor")
			LastEfflorescenceTime = GetTime()
			br.addonDebug("Casting Efflorescence")
			return true
		end
	end

	local function BossEncounterCase()
		-- Temple of Sethraliss
		if lowest.hp > getOptionValue("Temple of Seth Heal") and br.player.eID and br.player.eID == 2127 then
			for i = 1, GetObjectCountBR() do
				local thisUnit = GetObjectWithIndex(i)
				if GetObjectID(thisUnit) == 133392 then
					sethObject = thisUnit
					if getHP(sethObject) < 100 and getBuffRemain(sethObject, 274148) == 0 then
						if talent.germination and not buff.rejuvenationGermination.exists(sethObject) then
							--clearform()
							if CastSpellByName(GetSpellInfo(774), sethObject) then
								br.addonDebug("Casting Rejuvenation")
								return true
							end
						end
						if not buff.rejuvenation.exists(sethObject) then
							--clearform()
							if CastSpellByName(GetSpellInfo(774), sethObject) then
								br.addonDebug("Casting Rejuvenation")
								return true
							end
						end
						if buff.rejuvenation.exists(sethObject) then
							--clearform()
							if CastSpellByName(GetSpellInfo(8936), sethObject) then
								br.addonDebug("Casting Regrowth")
								return true
							end
						end
					end
				end
			end
		end
		if inInstance then
			for i = 1, #br.friend do
				-- Jagged Nettles and Dessication logic
				if getDebuffRemain(br.friend[i].unit, 260741) ~= 0 or getDebuffRemain(br.friend[i].unit, 267626) ~= 0 then
					if getSpellCD(18562) == 0 then
						--clearform()
						if cast.swiftmend(br.friend[i].unit) then
							br.addonDebug("Casting Swiftmend")
							return true
						end
					end
					if getSpellCD(18562) > gcdMax then
						if not moonkin then
							--clearform()
						end
						if cast.regrowth(br.friend[i].unit) then
							br.addonDebug("Casting Regrowth")
							return true
						end
					end
				end
				-- Devour
				if getDebuffRemain(br.friend[i].unit, 255421) ~= 0 and br.friend[i].hp <= 90 then
					if getSpellCD(102342) == 0 then
						--clearform()
						if cast.ironbark(br.friend[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
					if not moonkin then
						--clearform()
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
		if isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 2) then --and br.timer:useTimer("debugShapeshift", 0.25) then
			-- Flight Form
			if not inCombat and canFly() and br.fallDist > 90 --[[falling > getOptionValue("Fall Timer")]] and level >= 58 and not buff.prowl.exists() then
				CastSpellByID(783, "player")
				br.addonDebug("Casting Travelform")
				return true
			end
			-- Aquatic Form
			if (not inCombat) --[[or getDistance("target") >= 10--]] and swimming and not travel and not buff.prowl.exists() and moving then
				CastSpellByID(783, "player")
				br.addonDebug("Casting Travelform")
				return true
			end
			-- Travel Form
			if not inCombat and not swimming and level >= 58 and not buff.prowl.exists() and not travel and not IsIndoors() and IsMovingTime(1) and br.timer:useTimer("Travel shift",3) then
				CastSpellByID(783, "player")
				br.addonDebug("Casting Travelform")
				return true
			end
			-- Cat Form
			if not cat and not IsMounted() and not flying then
				-- Cat Form when not swimming or flying or stag and not in combat
				if moving and not swimming and not travel and IsIndoors() then
					if cast.catForm("player") then
						br.addonDebug("Casting Catform")
						return true
					end
				end
				-- Cat Form - Less Fall Damage
				if (not canFly() or inCombat or level < 58) and br.fallDist > 90 then --falling > getOptionValue("Fall Timer") then
					if cast.catForm("player") then
						br.addonDebug("Casting Catform")
						return true
					end
				end
			end
		end -- End Shapeshift Form Management
		-- Revive
		if isChecked("Revive") and not inCombat and not isMoving("player") and br.timer:useTimer("Resurrect", 4) then
			if getOptionValue("Revive") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player") then
				if cast.revive("target", "dead") then
					br.addonDebug("Casting Revive")
					return true
				end
			end
			if getOptionValue("Revive") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
				if cast.revive("mouseover", "dead") then
					br.addonDebug("Casting Revive")
					return true
				end
			end
			if getOptionValue("Revive") == 3 then
				local deadPlayers = {}
				for i =1, #br.friend do
					if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) then
						tinsert(deadPlayers,br.friend[i].unit)
					end
				end
				if #deadPlayers > 1 then
					if cast.revitalize() then br.addonDebug("Casting Mass Resurrection") return true end
				elseif #deadPlayers == 1 then
					if cast.revive(deadPlayers[1],"dead") then br.addonDebug("Casting Revive (Auto)") return true end
				end
			end
		end
	end -- End Action List - Extras

	-- Action List - Pre-Combat
	local function actionList_PreCombat()
		if isChecked("Pig Catcher") then
			bossHelper()
		end
		-- Pre-Pull Timer
		if isChecked("Pre-Pull Timer") then
			if PullTimerRemain() <= getOptionValue("Pre-Pull Timer") then
				if hasItem(166801) and canUseItem(166801) then
					br.addonDebug("Using Sapphire of Brilliance")
					useItem(166801)
				end
				if canUseItem(142117) and not buff.prolongedPower.exists() then
					br.addonDebug("Using Prolonged Power Pot")
					useItem(142117)
				end
			end
		end
	end -- End Action List - Pre-Combat

	local function actionList_Defensive()
		if useDefensive() then
			-- Barkskin
			if isChecked("Barkskin") then
				if php <= getOptionValue("Barkskin") then
					if cast.barkskin() then
						br.addonDebug("Casting Barkskin")
						return true
					end
				end
			end
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
			-- Renewal
			if isChecked("Renewal") and talent.renewal then
				if php <= getOptionValue("Renewal") then
					if cast.renewal() then
						br.addonDebug("Casting Renewal")
						return true
					end
				end
			end
			-- Rebirth
			if isChecked("Rebirth") and not moving then
				if
					getOptionValue("Rebirth") == 1 and -- Target
						UnitIsPlayer("target") and
						UnitIsDeadOrGhost("target") and
						GetUnitIsFriend("target", "player")
				 then
					if cast.rebirth("target", "dead") then
						br.addonDebug("Casting Rebirth")
						return true
					end
				end
				if
					getOptionValue("Rebirth") == 2 and -- Mouseover
						UnitIsPlayer("mouseover") and
						UnitIsDeadOrGhost("mouseover") and
						GetUnitIsFriend("mouseover", "player")
				 then
					if cast.rebirth("mouseover", "dead") then
						br.addonDebug("Casting Rebirth")
						return true
					end
				end
				if getOptionValue("Rebirth") == 3 then -- Tank
					for i = 1, #tanks do
						if UnitIsPlayer(tanks[i].unit) and UnitIsDeadOrGhost(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 then
							if cast.rebirth(tanks[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if getOptionValue("Rebirth") == 4 then -- Healer
					for i = 1, #br.friend do
						if
							UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
								(UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
						 then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if getOptionValue("Rebirth") == 5 then -- Tank/Healer
					for i = 1, #br.friend do
						if
							UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
								(UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
						 then
							if cast.rebirth(br.friend[i].unit, "dead") then
								br.addonDebug("Casting Rebirth")
								return true
							end
						end
					end
				end
				if getOptionValue("Rebirth") == 6 then -- Any
					for i = 1, #br.friend do
						if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
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
		if useInterrupts() then
			for i = 1, #enemies.yards15 do
				local thisUnit = enemies.yards15[i]
				if canInterrupt(thisUnit, getOptionValue("InterruptAt")) then
					-- Typhoon
					if isChecked("Typhoon") and talent.typhoon and getFacing("player", thisUnit) then
						if cast.typhoon() then
							br.addonDebug("Casting Typhoon")
							return true
						end
					end
					-- Mighty Bash
					if isChecked("Mighty Bash") and talent.mightyBash and getDistance(thisUnit, "player") <= 5 then
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
		if useCDs() then
			if hasItem(166801) and canUseItem(166801) then
				br.addonDebug("Using Sapphire of Brilliance")
				useItem(166801)
			end
			-- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
			if isChecked("Racial") and (race == "Orc" or race == "Troll" or race == "BloodElf") then
				if castSpell("player", racial, false, false, false) then
					br.addonDebug("Casting Racial")
					return true
				end
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
			if isChecked("Life-Binder's Invocation") and essence.lifeBindersInvocation.active and cd.lifeBindersInvocation.remain() <= gcdMax and getLowAllies(getOptionValue("Life-Binder's Invocation")) >= getOptionValue("Life-Binder's Invocation Targets") then
                if cast.lifeBindersInvocation() then
                    br.addonDebug("Casting Life-Binder's Invocation")
                    return true
                end
			end
			if isChecked("Guardian Shell") and essence.guardianShell.active and cd.guardianShell.remain() <= gcdMax and getLowAllies(getOptionValue("Guardian Shell")) >= getOptionValue("Guardian Shell Targets") then
                if cast.guardianShell() then
                    br.addonDebug("Casting Guardian Shell")
                    return true
                end
			end
			if isChecked("Ever-Rising Tide") and essence.overchargeMana.active and cd.overchargeMana.remain() <= gcdMax and getOptionValue("Ever-Rising Tide - Mana") <= mana then
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
			-- Mana Potion
			if isChecked("Mana Potion") and mana <= getValue("Mana Potion") then
				if hasItem(127835) then
					useItem(127835)
					br.addonDebug("Using Mana Potion")
				end
			end
			-- Innervate
			if isChecked("Innervate") and mana ~= nil then
				if (getLowAllies(getValue("Innervate")) >= getValue("Innervate Targets") and mana < 80) or burst == true then
					if cast.innervate("player") then
						br.addonDebug("Casting Innervate")
						return true
					end
				end
			end
			-- Incarnation: Tree of Life
			if isChecked("Incarnation") and talent.incarnationTreeOfLife and not buff.incarnationTreeOfLife.exists() then
				if getLowAllies(getValue("Incarnation")) >= getValue("Incarnation Targets") or burst == true then
					if cast.incarnationTreeOfLife() then
						br.addonDebug("Casting Incarnation")
						return true
					end
				end
			end
			-- Tranquility
			if isChecked("Tranquility") and not moving and not buff.incarnationTreeOfLife.exists() then
				if getLowAllies(getValue("Tranquility")) >= getValue("Tranquility Targets") or burst == true then
					if cast.tranquility() then
						br.addonDebug("Casting Tranquility")
						return true
					end
				end
			end
			--  Lucid Dream
            if isChecked("Lucid Dreams") and essence.memoryOfLucidDreams.active and mana <= 85 and getSpellCD(298357) <= gcdMax then
                if cast.memoryOfLucidDreams("player") then br.addonDebug("Casting Memory of Lucid Dreams") return end
            end
		end -- End useCooldowns check
	end -- End Action List - Cooldowns

	local function actionList_Decurse()
		-- Soothe
		if isChecked("Auto Soothe") then
			for i = 1, #enemies.yards40 do
				local thisUnit = enemies.yards40[i]
				if canDispel(thisUnit, spell.soothe) then
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
				if canDispel(br.friend[i].unit,spell.naturesCure) then
					if cast.naturesCure(br.friend[i].unit) then br.addonDebug("Casting Nature's Cure") return true end
				end
			end
		end
	end

	-- AOE Healing
	local function actionList_AOEHealing()
		-- Efflorescence
		if not moving then
			if (SpecificToggle("Efflorescence Key") and not GetCurrentKeyBoardFocus()) and isChecked("Efflorescence Key") then
				--clearform()
				if CastSpellByName(GetSpellInfo(spell.efflorescence), "cursor") then
					br.addonDebug("Casting Efflorescence")
					LastEfflorescenceTime = GetTime()
					return true
				end
			end
			if isChecked("Efflorescence") and (not LastEfflorescenceTime or GetTime() - LastEfflorescenceTime > getOptionValue("Efflorescence Recast Delay")) then
				if isChecked("Efflorescence on Melee") then
					-- get melee players
					for i = 1, #tanks do
						-- get the tank's target
						local tankTarget = UnitTarget(tanks[i].unit)
						if tankTarget ~= nil and getDistance(tankTarget, "player") < 40 then
							-- get players in melee range of tank's target
							local meleeFriends = getAllies(tankTarget, 5)
							-- get the best ground circle to encompass the most of them
							local loc = nil
							if isChecked("Efflorescence on CD") then
								if #meleeFriends >= getValue("Efflorescence Targets") then
									if #meleeFriends < 12 then
										loc = getBestGroundCircleLocation(meleeFriends, getValue("Efflorescence Targets"), 6, 10)
									else
										--clearform()
										if castWiseAoEHeal(meleeFriends, spell.efflorescence, 10, 100, getValue("Efflorescence Targets"), 6, true, true) then
											br.addonDebug("Casting Efflorescence")
											LastEfflorescenceTime = GetTime()
											return true
										end
									end
								end
							else
								local meleeHurt = {}
								for j = 1, #meleeFriends do
									if meleeFriends[j].hp < getValue("Efflorescence") then
										tinsert(meleeHurt, meleeFriends[j])
									end
								end
								if #meleeHurt >= getValue("Efflorescence Targets") then
									if #meleeHurt < 12 then
										loc = getBestGroundCircleLocation(meleeHurt, getValue("Efflorescence Targets"), 6, 10)
									else
										--clearform()
										if castWiseAoEHeal(meleeHurt, spell.efflorescence, 10, getValue("Efflorescence"), getValue("Efflorescence Targets"), 6, true, true) then
											br.addonDebug("Casting Efflorescence")
											LastEfflorescenceTime = GetTime()
											return true
										end
									end
								end
							end
							if loc ~= nil then
								if castGroundAtLocation(loc, spell.efflorescence) then
									br.addonDebug("Casting Efflorescence")
									LastEfflorescenceTime = GetTime()
									return true
								end
							end
						end
					end
				else
					--clearform()
					if castWiseAoEHeal(br.friend, spell.efflorescence, 10, getValue("Efflorescence"), getValue("Efflorescence Targets"), 6, false, false) then
						br.addonDebug("Casting Efflorescence")
						LastEfflorescenceTime = GetTime()
						return true
					end
				end
			end
		end
		-- Cultivation
		if isChecked("Cultivation") and inRaid and talent.cultivation and talent.germination then
			for i = 1, #br.friend do
				if getLowAllies(60) < 5 and br.friend[i].hp < 60 and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
					--clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (Cultivation)")
						return true
					end
				end
			end
		end
		-- Wild Growth
		if isChecked("Wild Growth") then
			for i = 1, #br.friend do
				if UnitInRange(br.friend[i].unit) then
					local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Wild Growth"), #br.friend)
					local lowHealthCandidates2 = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Soul of the Forest + Wild Growth"), #br.friend)
					if #lowHealthCandidates >= getValue("Wild Growth Targets") and talent.soulOfTheForest and not buff.soulOfTheForest.exists() and getSpellCD(48438) < gcdMax then
						--clearform()
						if cast.swiftmend(lowestHP) then
							br.addonDebug("Casting Swiftmend")
							return true
						end
					elseif #lowHealthCandidates2 >= getValue("Soul of the Forest + Wild Growth Targets") and buff.soulOfTheForest.exists() and not moving then
						--clearform()
						if cast.wildGrowth(br.friend[i].unit) then
							br.addonDebug("Casting Wild Growth")
							return true
						end
					elseif #lowHealthCandidates >= getValue("Wild Growth Targets") and not moving then
						--clearform()
						if cast.wildGrowth(br.friend[i].unit) then
							br.addonDebug("Casting Wild Growth")
							return true
						end
					end
				end
			end
		end
		-- Flourish
		if isChecked("Flourish") and inCombat and talent.flourish and wildGrowthExist() then
			if getLowAllies(getValue("Flourish")) >= getValue("Flourish Targets") then
				local c = getAllHotCnt(getValue("HOT Time count"))
				if c >= getValue("Flourish HOT Targets") or buff.tranquility.exists() then
					--clearform()
					if cast.flourish() then
						br.addonDebug("Casting Flourish")
						return true
					end
				end
			end
		end
	end

	-- Single Target
	local function actionList_SingleTarget()
		-- Ironbark
		if isChecked("Ironbark") and inCombat then
			if getOptionValue("Ironbark Target") == 1 then
				if php <= getValue("Ironbark") then
					--clearform()
					if cast.ironbark("player") then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			elseif getOptionValue("Ironbark Target") == 2 then
				if getHP("target") <= getValue("Ironbark") then
					--clearform()
					if cast.ironbark("target") then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			elseif getOptionValue("Ironbark Target") == 3 then
				if getHP("mouseover") <= getValue("Ironbark") then
					--clearform()
					if cast.ironbark("mouseover") then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			elseif getOptionValue("Ironbark Target") == 4 then
				for i = 1, #tanks do
					if tanks[i].hp <= getValue("Ironbark") and getDistance(tanks[i].unit) <= 40 then
						--clearform()
						if cast.ironbark(tanks[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
				end
			elseif getOptionValue("Ironbark Target") == 5 then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Ironbark") and UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" then
						--clearform()
						if cast.ironbark(br.friend[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
				end
			elseif getOptionValue("Ironbark Target") == 6 then
				for i = 1, #br.friend do
					if
						br.friend[i].hp <= getValue("Ironbark") and
							(UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
					 then
						--clearform()
						if cast.ironbark(br.friend[i].unit) then
							br.addonDebug("Casting Ironbark")
							return true
						end
					end
				end
			elseif getOptionValue("Ironbark Target") == 7 then
				if lowest.hp <= getValue("Ironbark") then
					--clearform()
					if cast.ironbark(lowest.unit) then
						br.addonDebug("Casting Ironbark")
						return true
					end
				end
			end
		end
		-- Swiftmend
		if isChecked("Swiftmend") and inCombat and not buff.soulOfTheForest.exists() then
			if getOptionValue("Swiftmend Target") == 1 then
				if php <= getValue("Swiftmend") then
					--clearform()
					if cast.swiftmend("player") then
						br.addonDebug("Casting Swiftmend")
						return true
					end
				end
			elseif getOptionValue("Swiftmend Target") == 2 then
				if getHP("target") <= getValue("Swiftmend") and getDebuffStacks("target", 209858) < getValue("Necrotic Rot") then
					--clearform()
					if cast.swiftmend("target") then
						br.addonDebug("Casting Swiftmend")
						return true
					end
				end
			elseif getOptionValue("Swiftmend Target") == 3 then
				if getHP("mouseover") <= getValue("Swiftmend") and getDebuffStacks("mouseover", 209858) < getValue("Necrotic Rot") then
					--clearform()
					if cast.swiftmend("mouseover") then
						br.addonDebug("Casting Swiftmend")
						return true
					end
				end
			elseif getOptionValue("Swiftmend Target") == 4 then
				for i = 1, #tanks do
					if tanks[i].hp <= getValue("Swiftmend") and (not inInstance or (inInstance and getDebuffStacks(tanks[i].unit, 209858) < getValue("Necrotic Rot"))) and getDistance(tanks[i].unit) <= 40 then
						--clearform()
						if cast.swiftmend(tanks[i].unit) then
							br.addonDebug("Casting Swiftmend")
							return true
						end
					end
				end
			elseif getOptionValue("Swiftmend Target") == 5 then
				for i = 1, #br.friend do
					if
						br.friend[i].hp <= getValue("Swiftmend") and (br.friend[i].role == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER") and
							(not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
					 then
						--clearform()
						if cast.swiftmend(br.friend[i].unit) then
							br.addonDebug("Casting Swiftmend")
							return true
						end
					end
				end
			elseif getOptionValue("Swiftmend Target") == 6 then
				for i = 1, #br.friend do
					if
						br.friend[i].hp <= getValue("Swiftmend") and
							(br.friend[i].role == "HEALER" or UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
							(not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
					 then
						--clearform()
						if cast.swiftmend(br.friend[i].unit) then
							br.addonDebug("Casting Swiftmend")
							return true
						end
					end
				end
			elseif getOptionValue("Swiftmend Target") == 7 then
				if lowest.hp <= getValue("Swiftmend") and (not inInstance or (inInstance and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot"))) then
					--clearform()
					if cast.swiftmend(lowest.unit) then
						br.addonDebug("Casting Swiftmend")
						return true
					end
				end
			end
		end
		-- Emergency Regrowth
		if not moving or buff.incarnationTreeOfLife.exists() then
			for i = 1, #br.friend do
				if
					isChecked("Regrowth Tank") and br.friend[i].hp <= 50 and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
						(not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
				 then
					if not moonkin then
						--clearform()
					end
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				elseif isChecked("Regrowth") and br.friend[i].hp <= 30 and (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot"))) then
					if not moonkin then
						--clearform()
					end
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				end
			end
		end
		-- In advance cast Lifebloom
		if isChecked("Lifebloom") and not cat and not travel then
			local focusTank = getFocusedTank()
			if bloomCount < 1 then
				if focusTank ~= nil and getDistance(focusTank.unit) < 40 then
					--clearform()
					if cast.lifebloom(focusTank.unit) then
						br.addonDebug("Casting Lifebloom")
						return true
					end
				elseif focusTank == nil then
					for i = 1, #tanks do
						if tanks[i].hp <= 90 and not buff.lifebloom.exists(tanks[i].unit) and getDistance(tanks[i].unit) < 40 then
							--clearform()
							if cast.lifebloom(tanks[i].unit) then
								br.addonDebug("Casting Lifebloom")
								return true
							end
						end
					end
				end
			elseif bloomCount == 1 then
				for i = 1, #tanks do
					if tanks[i].hp <= 90 and buff.lifebloom.remain(tanks[i].unit) < 4.5 and buff.lifebloom.remain(tanks[i].unit) > 0 and getDistance(tanks[i].unit) < 40 then
						--clearform()
						if cast.lifebloom(tanks[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					end
				end
			end
		end
		-- In advance cast Cenarion Ward
		if isChecked("Cenarion Ward") and not cat and not travel and talent.cenarionWard then
			for i = 1, #tanks do
				if tanks[i].hp <= 80 and buff.cenarionWard.remain(tanks[i].unit) < 4.5 and buff.cenarionWard.remain(tanks[i].unit) > 0 then
					--clearform()
					if cast.cenarionWard(tanks[i].unit) then
						br.addonDebug("Casting Cenarion Ward")
						return true
					end
				end
			end
		end
		-- Hot Regrowth
		if not moving or buff.incarnationTreeOfLife.exists() then
			if isChecked("Regrowth Clearcasting") and lowest.hp <= getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > gcdMax and (not regrowthTime or GetTime() - regrowthTime > gcdMax) then
				if not moonkin then
					--clearform()
				end
				if cast.regrowth(lowest.unit) then
					br.addonDebug("Casting Regrowth")
					regrowthTime = GetTime()
					return true
				end
			elseif isChecked("Hot Regrowth Tank") then
				for i = 1, #tanks do
					if tanks[i].hp <= getValue("Hot Regrowth Tank") and buff.regrowth.remain(tanks[i].unit) < gcdMax and getDistance(tanks[i].unit) <= 40 then
						if not moonkin then
							--clearform()
						end
						if cast.regrowth(tanks[i].unit) then
							br.addonDebug("Casting Regrowth")
							return true
						end
					end
				end
			elseif isChecked("Hot Regrowth") then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Hot Regrowth") and buff.regrowth.remain(br.friend[i].unit) < gcdMax then
						if not moonkin then
							--clearform()
						end
						if cast.regrowth(br.friend[i].unit) then
							br.addonDebug("Casting Regrowth")
							return true
						end
					end
				end
			end
		end
		-- Lifebloom
		if isChecked("Lifebloom") and not cat and not travel then
			if getOptionValue("Lifebloom") == 1 then
				for i = 1, #tanks do
					if bloomCount < 1 and not buff.lifebloom.exists(tanks[i].unit) and getDistance(tanks[i].unit) <= 40 then
						--clearform()
						if cast.lifebloom(tanks[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					elseif bloomCount == 1 and buff.lifebloom.remains(tanks[i].unit) < 4.5 and buff.lifebloom.remain(tanks[i].unit) > 0 and getDistance(tanks[i].unit) <= 40 then
						--clearform()
						if cast.lifebloom(tanks[i].unit) then 
							br.addonDebug("Casting Lifebloom")
							return true
						end
					end
				end
			elseif getOptionValue("Lifebloom") == 2 then
				for i = 1, #br.friend do
					if bloomCount < 1 and not buff.lifebloom.exists(br.friend[i].unit) and GetUnitIsUnit(br.friend[i].unit, "boss1target") then
						--clearform()
						if cast.lifebloom(br.friend[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					elseif bloomCount == 1 and buff.lifebloom.remains(br.friend[i].unit) < 4.5 and buff.lifebloom.remain(br.friend[i].unit) > 0 and getDistance(br.friend[i].unit) <= 40 then
						--clearform()
						if cast.lifebloom(br.friend[i].unit) then 
							br.addonDebug("Casting Lifebloom")
							return true
						end
					end
				end
			elseif getOptionValue("Lifebloom") == 3 then
				if not buff.lifebloom.exists("player") or buff.lifebloom.remains("player") < 4.5 then
					--clearform()
					if cast.lifebloom("player") then
						br.addonDebug("Casting Lifebloom")
						return true
					end
				end
			elseif getOptionValue("Lifebloom") == 4 then
				if (not buff.lifebloom.exists("focus") or buff.lifebloom.remains("focus") < 4.5) and UnitInRange("focus") then
					--clearform()
					if cast.lifebloom("focus") then
						br.addonDebug("Casting Lifebloom")
						return true
					end
				end
			end
		end
		-- Cenarion Ward
		if isChecked("Cenarion Ward") and inCombat and talent.cenarionWard then
			if getOptionValue("Cenarion Ward Target") == 1 then
				for i = 1, #tanks do
					if tanks[i].hp <= getValue("Cenarion Ward") and getDistance(tanks[i].unit) <= 40 then
						--clearform()
						if cast.cenarionWard(tanks[i].unit) then
							br.addonDebug("Casting Cenarion Ward")
							return true
						end
					end
				end
			elseif getOptionValue("Cenarion Ward Target") == 2 then
				for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Cenarion Ward") and GetUnitIsUnit(br.friend[i].unit, "boss1target") then
						--clearform()
						if cast.cenarionWard(br.friend[i].unit) then
							br.addonDebug("Casting Cenarion Ward")
							return true
						end
					end
				end
			elseif getOptionValue("Cenarion Ward Target") == 3 then
				if php <= getValue("Cenarion Ward") then
					--clearform()
					if cast.cenarionWard("player") then
						br.addonDebug("Casting Cenarion Ward")
						return true
					end
				end
			elseif getOptionValue("Cenarion Ward Target") == 4 then
				if lowest.hp <= getValue("Cenarion Ward") then
					--clearform()
					if cast.cenarionWard(lowest.unit) then
						br.addonDebug("Casting Cenarion Ward")
						return true
					end
				end
			end
		end
		-- Cultivation
		if inRaid and talent.cultivation then
			for i = 1, #br.friend do
				if br.friend[i].hp < 60 and not buff.rejuvenation.exists(br.friend[i].unit) then
					--clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (Cultivation)")
						return true
					end
				end
			end
		end
		-- Refreshment
		if isChecked("Well of Existence") and essence.refreshment.active and cd.refreshment.remain() <= gcdMax and UnitBuffID("player",296138) and select(16,UnitBuffID("player",296138,"EXACT")) >= 15000 and lowest.hp <= getValue("Regrowth") then
			if cast.refreshment(lowest.unit) then br.addonDebug("Casting Refreshment") return true end
		end
		-- Concentrated Flame
		if isChecked("Concentrated Flame") and essence.concentratedFlame.active and getSpellCD(295373) <= gcdMax then
			if lowest.hp <= getValue("Concentrated Flame") then
				if cast.concentratedFlame(lowest.unit) then br.addonDebug("Casting Concentrated Flame") return end
			end
		end
		-- Rejuvenation
		if isChecked("Rejuvenation") then
			for i = 1, #tanks do
				if talent.germination and tanks[i].hp <= getValue("Germination Tank") and not buff.rejuvenationGermination.exists(tanks[i].unit) and getDistance(tanks[i].unit) <= 40 then
					--clearform()
					if cast.rejuvenation(tanks[i].unit) then
						br.addonDebug("Casting Rejuvenation (Germinate Tank)")
						return true
					end
				elseif not talent.germination and tanks[i].hp <= getValue("Rejuvenation Tank") and not buff.rejuvenation.exists(tanks[i].unit) and getDistance(tanks[i].unit) <= 40 then
					--clearform()
					if cast.rejuvenation(tanks[i].unit) then
						br.addonDebug("Casting Rejuvenation (Tank Rejuv)")
						return true
					end
				end
			end
			for i = 1, #br.friend do
				if talent.germination and br.friend[i].hp <= getValue("Germination") and (rejuvCount < getValue("Max Rejuvenation Targets")) and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
					--clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (Germinate Party)")
						return true
					end
				elseif br.friend[i].hp <= getValue("Rejuvenation") and not buff.rejuvenation.exists(br.friend[i].unit) and (rejuvCount < getValue("Max Rejuvenation Targets")) then
					--clearform()
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
					isChecked("Regrowth Tank") and br.friend[i].hp <= getValue("Regrowth Tank") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
						(not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot")))
				 then
					if not moonkin then
						--clearform()
					end
					if cast.regrowth(br.friend[i].unit) then
						br.addonDebug("Casting Regrowth")
						return true
					end
				elseif isChecked("Regrowth") and br.friend[i].hp <= getValue("Regrowth") and (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot"))) then
					if not moonkin then
						--clearform()
					end
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
		if isChecked("DOT cast Rejuvenation") then
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
				if UnitInRange(br.friend[i].unit) then
					for k, v in pairs(debuff_list) do
						if getDebuffRemain(br.friend[i].unit, v.spellID) > v.secs and getDebuffStacks(br.friend[i].unit, v.spellID) >= v.stacks and not buff.rejuvenation.exists(br.friend[i].unit) then
							--clearform()
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
		if isChecked("DBM cast Rejuvenation") then
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
				{282742, 5, "Storm of Annihilation"}, -- Crucible of Storms
			}
			for j = 1, #br.friend do
				if UnitInRange(br.friend[j].unit) then
					for i = 1, #precast_spell_list do
						local boss_spell_id = precast_spell_list[i][1]
						local precast_time = precast_spell_list[i][2]
						local spell_name = precast_spell_list[i][3]
						local time_remain = br.DBM:getPulltimer(nil, boss_spell_id)
						if time_remain < precast_time then
							if not buff.rejuvenation.exists(br.friend[j].unit) then
								--clearform()
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
					--clearform()
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
					--clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (100% Rejuv)")
						return true
					end
				end
			end
		end
	end

	local function actionList_RejuvenationMode()
		if mode.rejuvenation == 2 then
			for i = 1, #br.friend do
				if not buff.rejuvenation.exists(br.friend[i].unit) then
					--clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (All Player Rejuv)")
						return true
					end
				end
			end
		elseif mode.rejuvenation == 3 then
			for i = 1, #br.friend do
				if talent.germination and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
					--clearform()
					if cast.rejuvenation(br.friend[i].unit) then
						br.addonDebug("Casting Rejuvenation (All Player Double Rejuv)")
						return true
					end
				end
			end
		end
	end

	-- Action List - DPS
	local function actionList_DPS()
		-- Guardian Affinity/Level < 45
		if talent.guardianAffinity or level < 45 then
			-- Sunfire
			if mana >= getOptionValue("DPS Save mana") and debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") then
				for i = 1, #enemies.yards40 do
					local thisUnit = enemies.yards40[i]
					if not debuff.sunfire.exists(thisUnit) and not isExplosive(thisUnit) then
						if cast.sunfire(thisUnit) then
							br.addonDebug("Casting Sunfire")
							return true
						end
					end
				end
			end
			-- Moonfire
			if (not isChecked("DPS Key") and (not isChecked("Auto Shapeshifts") or (isChecked("Auto Shapeshifts") and getOptionValue("Auto Shapeshifts") == 2))) or getDistance("target", "player") > 8 then
				if mana >= getOptionValue("DPS Save mana") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not isExplosive(thisUnit) then
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
				not bear and isChecked("Bear Form Shifting") and getDistance("target", "player") <= 8 and
					((isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 3)) or isChecked("DPS Key"))
			 then
				if cast.bearForm("player") then
					br.addonDebug("Casting Bear Form")
					return true
				end
			end
			if bear then
				-- Moonfire
				if mana >= getOptionValue("DPS Save mana") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not isExplosive(thisUnit) then
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
				if GetUnitExists("target") then
					if cast.mangle("target") then
						br.addonDebug("Casting Mangle")
						return true
					end
				end
				if GetUnitExists("target") then
					if cast.thrashBear("target") then
						br.addonDebug("Casting Thrash")
						return true
					end
				end
			end
			-- Solar Wrath
			if not moving and GetUnitExists("target") then
				if (isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 3)) or isChecked("DPS Key") then
					if getDistance("target", "player") > 5 or not bear and getFacing("player","target") then
						if cast.solarWrath("target") then
							br.addonDebug("Casting Solar Wrath")
							return true
						end
					end
				elseif (not isChecked("Auto Shapeshifts") or (isChecked("Auto Shapeshifts") and getOptionValue("Auto Shapeshifts") == 2)) and getFacing("player","target")then
					if cast.solarWrath("target") then
						br.addonDebug("Casting Solar Wrath")
						return true
					end
				end
			end
		end
		-- Feral Affinity
		if talent.feralAffinity and GetUnitExists("target") then
			local nearEnemies = #enemies.yards5f
			if travel then
				--clearform()
			end
			if not catRecover and br.player.power.energy.amount() < 50 and combo == 0 then
				catRecover = true
			elseif catRecover and br.player.power.energy.amount() == 100 then
				catRecover = false
			end
			if (catRecover or not cat or not isChecked("Auto Shapeshifts") or (isChecked("Auto Shapeshifts") and getOptionValue("Auto Shapeshifts") == 2)) and isChecked("HOT Mode") then
				if cat then
					--clearform()
				end
				for i = 1, #tanks do
					if bloomCount == 1 and buff.lifebloom.exists(tanks[i].unit) and buff.lifebloom.remains(tanks[i].unit) < 4.5 and buff.lifebloom.remain(tanks[i].unit) > 0 then
						if cast.lifebloom(tanks[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end
					elseif bloomCount < 1 and UnitTarget(tanks[i].unit) ~= nil then
						if cast.lifebloom(tanks[i].unit) then
							br.addonDebug("Casting Lifebloom")
							return true
						end	
					end
					if talent.cenarionWard and UnitTarget(tanks[i].unit) ~= nil and buff.cenarionWard.remains(tanks[i].unit) < 9 then
						if cast.cenarionWard(tanks[i].unit) then
							br.addonDebug("Casting Cenarion Ward")
							return true
						end
					end
					if buff.rejuvenation.remains(tanks[i].unit) < 4.5 then
						if cast.rejuvenation(tanks[i].unit) then
							br.addonDebug("Casting Rejuvenation (DPS Mode Tank Rejuv)")
							return true
						end
					end
				end
			end
			if cat and getDistance("target") <= 5 then
				StartAttack()
			end
			if nearEnemies < 1 or ((not isChecked("Auto Shapeshifts") or (isChecked("Auto Shapeshifts") and getOptionValue("Auto Shapeshifts") == 2)) and not cat) then
				-- Moonfire
				if mana >= getOptionValue("DPS Save mana") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
				-- Sunfire
				if mana >= getOptionValue("DPS Save mana") and debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.sunfire.exists(thisUnit) and not isExplosive(thisUnit) then
							if cast.sunfire(thisUnit) then
								br.addonDebug("Casting Sunfire")
								return true
							end
						end
					end
				end
				-- Solar Wrath
				if not moving and getFacing("player","target") then
					if cast.solarWrath("target") then
						br.addonDebug("Casting Solar Wrath")
						return true
					end
				end
			elseif nearEnemies == 1 then
				-- Moonfire
				if not debuff.moonfire.exists("target") and mana >= getOptionValue("DPS Save mana") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") and not isExplosive("target") then
					if cast.moonfire("target") then
						br.addonDebug("Casting Moonfire")
						return true
					end
				end
				-- Sunfire
				if not debuff.sunfire.exists("target") and mana >= getOptionValue("DPS Save mana") and debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") and not isExplosive("target") then
					if cast.sunfire("target") then
						br.addonDebug("Casting Sunfire")
						return true
					end
				end
				if debuff.sunfire.remains("target") > 2 and debuff.moonfire.remains("target") > 2 then
					-- Cat Form
					if
						not cat and (not bear or (bear and (not bearTimer or GetTime() - bearTimer >= catRecharge))) and GetUnitExists("target") and getDistance("target", "player") <= 8 and
							((isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 3)) or isChecked("DPS Key"))
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
				if cat and combo >= 2 and ttd("target") >= 14 and (not debuff.rip.exists("target") or debuff.rip.remains("target") < 4) then
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
				if #enemies.yards8t > 1 and not debuff.sunfire.exists("target") and mana >= getOptionValue("DPS Save mana") and not isExplosive("target") then
					if cast.sunfire("target") then
						br.addonDebug("Casting Sunfire")
						return true
					end
				end
				-- Moonfire
				if mana >= getOptionValue("DPS Save mana") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards8[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
				-- Sunfire
				if mana >= getOptionValue("DPS Save mana") and debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") and not isExplosive(thisUnit) then
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
					not cat and (not bear or (bear and (not bearTimer or GetTime() - bearTimer >= catRecharge))) and GetUnitExists("target") and getDistance("target","player") <= 8 and
						((isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 3)) or isChecked("DPS Key"))
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
				if mana >= getOptionValue("DPS Save mana") and debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") and not isExplosive(thisUnit) then
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
					not cat and (not bear or (bear and (not bearTimer or GetTime() - bearTimer >= catRecharge))) and GetUnitExists("target") and getDistance("target","player") <= 8 and
						((isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 3)) or isChecked("DPS Key"))
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
						((isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 3)) or isChecked("DPS Key"))
				 then
					bearTimer = GetTime()
					catRecharge = br.player.power.energy.ttm()
					if cast.bearForm("player") then
						br.addonDebug("Casting Bear Form")
						return true
					end
				end
				-- Bear Swipe
				if bear and GetTime() - bearTimer < catRecharge then
					if cast.swipeBear() then
						br.addonDebug("Casting Swipe (Bear)")
						return true
					end
				end
			end
		end -- End - Feral Affinity
		-- Balance Affinity
		if talent.balanceAffinity then
			if mana >= getOptionValue("DPS Save mana") then
				-- Moonkin form
				if
					not moonkin and not moving and not travel and not IsMounted() and GetTime() - shiftTimer > 5 and
						((isChecked("Auto Shapeshifts") and (getOptionValue("Auto Shapeshifts") == 1 or getOptionValue("Auto Shapeshifts") == 3)) or isChecked("DPS Key"))
				then
					for i = 1, #br.friend do
						if buff.lifebloom.exists(br.friend[i].unit) and buff.lifebloom.remain(br.friend[i].unit) < 5 then
							return
						end
					end
					if cast.moonkinForm() then
						br.addonDebug("Casting Moonkin Form")
						return true
					end
				end
				-- Lunar Strike 3 charges
				if moonkin and buff.lunarEmpowerment.stack() == 3 then
					if cast.lunarStrikeAff() then
						br.addonDebug("Casting Lunar Strike")
						return true
					end
				end
				-- Starsurge
				if moonkin and getFacing("player","target") then
					if cast.starsurgeAff() then
						br.addonDebug("Casting Starsurge")
						return true
					end
				end
				-- Sunfire
				if mana >= getOptionValue("DPS Save mana") and debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") and not isExplosive(thisUnit) then
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
				if mana >= getOptionValue("DPS Save mana") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
					for i = 1, #enemies.yards40 do
						local thisUnit = enemies.yards40[i]
						if not debuff.moonfire.exists(thisUnit) and ttd(thisUnit) > 10 and not isExplosive(thisUnit) then
							if cast.moonfire(thisUnit) then
								br.addonDebug("Casting Moonfire")
								return true
							end
						end
					end
				end
				-- Lunar Strike charged
				if moonkin and buff.lunarEmpowerment.exists() then
					if cast.lunarStrikeAff() then
						br.addonDebug("Casting Lunar Strike")
						return true
					end
				end
				-- Solar Wrath charged
				if buff.solarEmpowerment.exists() and not moving and getFacing("player","target") then
					if cast.solarWrath("target") then
						br.addonDebug("Casting Solar Wrath")
						return true
					end
				end
				-- Solar Wrath uncharged
				if GetUnitExists("target") and not moving and getFacing("player","target") then
					if cast.solarWrath("target") then
						br.addonDebug("Casting Solar Wrath")
						return true
					end
				end
				-- Lunar Strike uncharged
				if moonkin then
					if cast.lunarStrikeAff() then
						br.addonDebug("Casting Lunar Strike")
						return true
					end
				end
			end
		end -- End -- Balance Affinity
	end -- End Action List - DPS
	if br.data.settings[br.selectedSpec][br.selectedProfile]['HE ActiveCheck'] == false and br.timer:useTimer("Error delay",0.5) then
		Print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
		return
	end
	-----------------
	--- Rotations ---
	-----------------
	if SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() and isChecked("DPS Key") and travel then
		--clearform()
	end
	 if lowest.hp < getOptionValue("DPS") and travel and not moving then
	 	--clearform()
	 end
	-- Pause
	if pause(true) or (travel and not inCombat) or IsMounted() or flying or stealthed or drinking or isCastingSpell(spell.tranquility) then
		return true
	else
		---------------------------------
		--- Out Of Combat - Rotations ---
		---------------------------------
		if not inCombat then
			if key() then
				return
			end
			if actionList_Extras() then
				return
			end
			if actionList_PreCombat() then
				return
			end
			if actionList_Decurse() then
				return
			end
			if isChecked("OOC Healing") then
				if actionList_AOEHealing() then
					return
				end
				if actionList_SingleTarget() then
					return
				end
				if actionList_RejuvenationMode() then
					return
				end
			end
		end -- End Out of Combat Rotation
		-----------------------------
		--- In Combat - Rotations ---
		-----------------------------
		if inCombat then
			if not isChecked("DPS Key") then
				if (restoDPS and lowest.hp <= getOptionValue("Critical Heal")) or buff.incarnationTreeOfLife.exists() or mode.dPS == 1 then
					ChatOverlay("Healing Engaged")
					br.addonDebug("Healing Engaged")
					restoDPS = false
				elseif not restoDPS and lowest.hp > getOptionValue("DPS") and not buff.incarnationTreeOfLife.exists() and mode.dPS == 2 then
					ChatOverlay("DPS Engaged")
					br.addonDebug("DPS Engaged")
					restoDPS = true
				end
			end
			if SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() and isChecked("DPS Key") and lowest.hp > getOptionValue("DPS") then
				if actionList_DPS() then
					return
				end
			else
				if key() then
					return
				end
				if BossEncounterCase() then
					return
				end
				if actionList_Defensive() then
					return
				end
				if actionList_Cooldowns() then
					return
				end
				if actionList_Interrupts() then
					return
				end
				if actionList_Decurse() then
					return
				end
				if (not restoDPS and not isChecked("DPS Key")) or isChecked("DPS Key") then
					if actionList_AOEHealing() then
						return
					end
					if actionList_SingleTarget() then
						return
					end
				end
				if #enemies.yards5 < 1 and mode.dPS == 2 and isChecked("DPS Key") and not SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() then
					-- Moonfire
					if mana >= getOptionValue("DPS Save mana") and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") then
						for i = 1, #enemies.yards40 do
							local thisUnit = enemies.yards40[i]
							if not debuff.moonfire.exists(thisUnit) and not isExplosive(thisUnit) then
								if cast.moonfire(thisUnit) then
									br.addonDebug("Casting Moonfire")
									return true
								end
							end
						end
					end
					-- Sunfire
					if mana >= getOptionValue("DPS Save mana")  then
						for i = 1, #enemies.yards40 do
							local thisUnit = enemies.yards40[i]
							if not debuff.sunfire.exists(thisUnit) and not isExplosive(thisUnit) then
								if cast.sunfire(thisUnit) then
									br.addonDebug("Casting Sunfire")
									return true
								end
							end
						end
					end
				end
				if not isChecked("DPS Key") and mode.dPS == 2 and restoDPS then
					if not GetUnitExists("target") or (UnitIsDeadOrGhost("target") and not GetUnitIsFriend("target")) and #enemies.yards40 ~= 0 and getOptionValue("Target Dynamic Target") then
						TargetUnit(enemies.yards40[1])
					end
					if GetUnitExists("target") and not GetUnitIsFriend("target") then
						if actionList_DPS() then
							return
						end
					end
				end
				if  (not restoDPS and not isChecked("DPS Key")) or isChecked("DPS Key") then
					if actionList_Rejuvenation() then
						return
					end
					if actionList_RejuvenationMode() then
						return
					end
					if (isChecked("DPS Key") and SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus()) or (not isChecked("DPS Key") and mode.dPS == 2) then
						if actionList_DPS() then
							return 
						end
					end
				end
			end
		end -- End In Combat Rotation
	end -- Pause
	-- end -- End Timer
end -- End runRotation
local id = 0
if br.rotations[id] == nil then
	br.rotations[id] = {}
end
tinsert(
	br.rotations[id],
	{
		name = rotationName,
		toggles = createToggles,
		options = createOptions,
		run = runRotation
	}
)

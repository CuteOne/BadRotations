local rotationName = "KinkySpirit"
local versionNum = "1.4.2"
local colorPurple = "|cff8788EE"
local colorOrange = "|cffb28cc7"	
local colorWhite = "|cffffffff"							   
local dreadstalkersActive, vilefiendActive, grimoireActive = false, false, false
local dreadstalkersTime, vilefiendTime, grimoireTime, ppDb, castSummonId, opener, summonTime
local DontDotUnits="171557"
local var = {}
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of targets in range.",
            highlight = 1,
            icon = br.player.spell.handOfGuldan
        },
        [2] = {
            mode = "Mult",
            value = 2,
            overlay = "Multiple Target Rotation",
            tip = "Multiple target rotation used.",
            highlight = 0,
            icon = br.player.spell.implosion
        },
        [3] = {
            mode = "Sing",
            value = 3,
            overlay = "Single Target Rotation",
            tip = "Single target rotation used.",
            highlight = 0,
            icon = br.player.spell.shadowBolt
        },
        [4] = {
            mode = "Off",
            value = 4,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spell.drainLife
        }
    }
    br.ui:createToggle(RotationModes,"Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spell.summonDemonicTyrant
        },
        [2] = {
            mode = "On",
            value = 2,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.summonDemonicTyrant
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.shadowBolt
        },
        [4] = {
            mode = "Lust",
            value = 4,
            overlay = "Cooldowns With Lust",
            tip = "Cooldowns will be used with bloodlust or simlar effects.",
            highlight = 0,
            icon = br.player.spell.summonDemonicTyrant
        }
    }
    br.ui:createToggle(CooldownModes,"Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.unendingResolve
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.unendingResolve
        }
    }
    br.ui:createToggle(DefensiveModes,"Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.spellLock
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.spellLock
        }
    }
    br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)
    -- BSB Button
    local BSBModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Bilescourge Bombers Enabled",
            tip = "Bilescourge Bombers Enabled.",
            highlight = 1,
            icon = br.player.spell.bilescourgeBombers
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Bilescourge Bombers Disabled",
            tip = "Bilescourge Bombers Disabled.",
            highlight = 0,
            icon = br.player.spell.bilescourgeBombers
        }
    }
    br.ui:createToggle(BSBModes,"BSB", 3, 1)
    -- GF Button
    local GFModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Grimoire Felguard Enabled",
            tip = "Grimoire Felguard Enabled.",
            highlight = 1,
            icon = br.player.spell.grimoireFelguard
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Grimoire Felguard Disabled",
            tip = "Grimoire Felguard Disabled.",
            highlight = 0,
            icon = br.player.spell.grimoireFelguard
        }
    }
    br.ui:createToggle(GFModes,"GF", 4, 1)
    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Felguard", tip = "Summon Felguard", highlight = 1, icon = br.player.spell.summonFelguard },
        [2] = { mode = "2", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [3] = { mode = "3", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [4] = { mode = "4", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter", highlight = 1, icon = br.player.spell.summonFelhunter },
        [5] = { mode = "5", value = 4 , overlay = "Succubus", tip = "Summon Succubus", highlight = 1, icon = br.player.spell.summonSuccubus },
        [6] = { mode = "None", value = 5 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.conflagrate }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",1,1)

    -- Burning Rush button
    local BurningRushModes = {
        [1] = { mode = "On", value = 1 , overlay = "Burning Rush Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.burningRush},
        [2] = { mode = "Off", value = 2 , overlay = "Burning Rush Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.burningRush}
    };
    br.ui:createToggle(BurningRushModes,"BurningRush",2,1)

end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {
        "None",
        GetBindingKey("Rotation Function 1"),
        GetBindingKey("Rotation Function 2"),
        GetBindingKey("Rotation Function 3"),
        GetBindingKey("Rotation Function 4"),
        GetBindingKey("Rotation Function 5")
    }
    local optionTable
    local function rotationOptions()
        local section
        -------------------------
		---- GENERAL OPTIONS ----
		-------------------------
        section = br.ui:createSection(br.ui.window.profile, 
        colorWhite .. "Demonology " 
        .. colorPurple .. ".:|:. " 
        .. colorWhite .. " General " 
        .. colorWhite .. "Ver " 
        .. colorOrange .. versionNum 
        .. colorPurple .." .:|:.")
        -- APL
        br.ui:createDropdownWithout(section, "APL Mode", {"|cffb28cc7SimC"}, 1, "|cffb28cc7Set APL Mode to use.")
        -- Soulstone healers in Mythic+s
        br.ui:createCheckbox(section, "Soulstone Healer OOC [Mythic+]", "|cffFFBB00Toggle soulstoning your healer while doing mythic+ runs.")
		-- Multi-Target Units
		br.ui:createSpinnerWithout(section, "Multi-Target Units", 3, 1, 25, 1, "|cffb28cc7Number of Targets to use Covenant at.")        
		-- Burning Rush Health Cancel Percent
		br.ui:createSpinnerWithout(section, "Burning Rush Health", 79, 1, 100, 1, "|cffb28cc7Health Percentage to cancel at.")
        -- Auto target
		br.ui:createCheckbox(section, "Auto Target", "|cffb28cc7 Will auto change to a new target, if current target is dead")
        -- Auto Engage
        br.ui:createCheckbox(section, "Auto Engage", "|cffb28cc7 Will auto engage combat when out of combat.")
        -- Auto Faccia
        br.ui:createCheckbox(section, "Auto Faccia", "|cffFFFFFFToggle Auto Faccia")
        --Auto Faccia Delay
        br.ui:createSpinnerWithout(section, "Auto Faccia Delay", 4.5, 0, 15, 0.1, "|cffFFBB00Time in seconds before Auto Faccia - Default: 4.5")
        -- Anti Coof
       -- br.ui:createCheckbox(section,"Anti Coof", "|cff5100FFCheck to never let acid trips, cat shits, or Coof Endemics ruin your day.")
       -- br.ui:createSpinnerWithout(section, "Coof Social Distance", math.random(8,25), 6.5, 40, 0.1, "|cffFFBB00Distance to stay away while coofing, you poor thang. - Default: Random / Min: 6.5 / ")

		-- Dummy DPS Test
		br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffb28cc7Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

		-- Corruption Torghast
        br.ui:createCheckbox(section,"Instant Corruption Torghast")
        -- Curse Of Tongues Torghast
        br.ui:createCheckbox(section,"Curse of Tongues Torghast")

		-- Pet Management
        br.ui:createCheckbox(section, "Pet Management", "|cffb28cc7 Select to enable/disable auto pet management")
        -- Pet Summon Delay
        br.ui:createSpinnerWithout(section, "Summon Pet Delay", 3, 1, 10, 0.1, "|cffFFBB00Delay between Pet Summons")

        -- Fel Domination
        br.ui:createCheckbox(section, "Fel Domination", "|cffFFFFFF Toggle the auto casting of Fel Donmination")
        -- Fel Domination on low pet health
        br.ui:createCheckbox(section, "Fel Domination New Pet", "|cffFFBB00 Toggle the auto casting of Fel Donmination when your pet is low health.")
        -- Pet Summon 
        br.ui:createSpinnerWithout(section, "FelDom Pet HP", 8, 1, 100, 0.1, "|cffFFBB00Health percent of your pet to cast Fel Domination and re-summon your pet.")
	
		-- No Dot units
		br.ui:createCheckbox(section, "Dot Blacklist", "|cffb28cc7 Check to ignore certain units for dots")
		-- Multi-Dot Limit
		br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 7, 1, 10, 1, "|cffb28cc7Unit Count Limit that DoTs will be cast on.")
        -- Implosion Unit
        br.ui:createSpinnerWithout(section, "Implosion Units", 2, 1, 10, 1, "|cffb28cc7Minimum units to cast Implosion")
		-- Implosion ST
		br.ui:createCheckbox(section, "Implosion ST", "|cffb28cc7 Will cast Implosion on ST.")
		-- Bilescourge Bombers Target
		br.ui:createDropdownWithout(section, "Bilescourge Bombers Target", {"|cffb28cc7Target", "|cffb28cc7Best"}, 2, "|cffb28cc7Bilescourge Bombers target")
		-- Bilescourge Bombers Unit
		br.ui:createSpinnerWithout(section, "Bilescourge Bombers Units", 3, 1, 10, 1, "|cffb28cc7Minimum units to cast Bilescourge Bombers")
        br.ui:checkSectionState(section)
        -------------------------
		---- HOTKEYS OPTIONS ----
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, colorWhite .. "Demonology " .. colorPurple .. " .:|:." .. colorWhite .. "Hotkeys")
		    -- Summon Demonic Tyrant Key
            br.ui:createDropdown(section, "Cooldowns", br.dropOptions.Toggle, 6)
            -- Summon Demonic Tyrant Key
            br.ui:createDropdown(section, "Summon Demonic Tyrant", br.dropOptions.Toggle, 6)
            -- Demonic Gateway Key
            br.ui:createDropdown(section, "Demonic Gateway", br.dropOptions.Toggle, 6)
            -- Demonic Circle Summon Key
            br.ui:createDropdown(section, "Demonic Circle Summon", br.dropOptions.Toggle, 6)
           -- Demonic Circle Teleport Key
            br.ui:createDropdown(section, "Demonic Circle Teleport", br.dropOptions.Toggle, 6)
            -- Shadow Fury Key
            br.ui:createDropdown(section, "Shadowfury", br.dropOptions.Toggle, 6)
            -- Shadowfury Target
            br.ui:createDropdownWithout(section, "Shadowfury Target", {"|cffb28cc7Best", "|cffb28cc7Target", "|cffb28cc7Cursor"}, 1, "|cffb28cc7Shadowfury target")
        br.ui:checkSectionState(section)
        -------------------------
		---- TOGGLE OPTIONS ----
		-------------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
            -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
        -------------------------
		--- COOLDOWNS OPTIONS ---
		-------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Bilescourge Bombers with CDs
        br.ui:createCheckbox(section, "Ignore Bilescourge Bombers units when using CDs")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.player.module.BasicTrinkets(nil,section)
        -- Potion
        br.ui:createCheckbox(section, "Potion")
        -- Pre-Pull Timer
		br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffb28cc7Will precast demonbolt on pull if pulltimer is active")
        -- Pre Pot
        br.ui:createCheckbox(section, "Pre Pot", "|cffb28cc7 Requires Pre-Pull logic to be active")
        -- FlaskUp Module
        br.player.module.FlaskUp("Intellect",section)
        br.ui:checkSectionState(section)
        -------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            --- Healthstone Creation
            br.ui:createSpinner(section, "Create Healthstone",  3,  0,  3,  5,  "|cffb28cc7Toggle creating healthstones, and how many in bag before creating more")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffb28cc7Health Percent to Cast At")
            -- Mortal Coil 
            br.ui:createSpinner(section, "Mortal Coil",  23,  0,  100,  5,  "|cffFFBB00Health Percent to Cast At")
            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 50, 0, 100, 5, "|cffb28cc7Health Percent to Cast At")
            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel", 50, 0, 100, 5, "|cffb28cc7Health Percent to Cast At")
            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffb28cc7Health Percent to Cast At")
            --Soulstone
            br.ui:createCheckbox(section, "Auto Soulstone Player", "|cffb28cc7 Will put soulstone on player outside raids and dungeons")
            --Soulstone mouseover
            br.ui:createCheckbox(section, "Auto Soulstone Mouseover", "|cffb28cc7 Auto soulstone your mouseover if dead")
            --Dispel
            br.ui:createCheckbox(section, "Auto Dispel/Purge", "|cffb28cc7 Auto dispel/purge in m+, based on whitelist, set delay in healing engine settings")
        br.ui:checkSectionState(section)
        -------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		-- Interrupt Percentage
		br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffb28cc7Cast Percent to Cast At")
        br.ui:checkSectionState(section)
	end
    local function listsOptions()
        -------------------------
        ----  Lists Options -----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Lists Options")
        -- No Dot units
        br.ui:createCheckbox(section, "No Touch Blacklist", "Ignore certain units for dots")
       -- br.ui:createScrollingEditBoxWithout(section,"No Touch Blacklist Units", NoTouch, "List of units to not touch", 240, 40)
        -- Curse of Exhaustion
        br.ui:createSpinner(section, "Curse of Exhaustion", 2, 1, 10, 1, "|cffFFBB00Number of enemies to cast Curse of Exhaustion at.")
        br.ui:createScrollingEditBoxWithout(section,"Exhaustion Units", exhaustionUnits, "List of units to cast Curse of Exhaustion on.", 240, 40)
        br.ui:checkSectionState(section)
    br.ui:checkSectionState(section)
    end


	optionTable = {{
		[1] = "Rotation Options",
        [2] = rotationOptions,
    },
    {
        [1] = "Lists",
        [2] = listsOptions
     
	}}
	return optionTable
end
----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------
    --- Toggles ---
    ---------------
    br.UpdateToggle("Rotation", 0.25)
    br.UpdateToggle("Cooldown", 0.25)
    br.UpdateToggle("Defensive", 0.25)
    br.UpdateToggle("Interrupt", 0.25)
    br.player.ui.mode.bsb = br.data.settings[br.selectedSpec].toggles["BSB"]
    br.player.ui.mode.gf = br.data.settings[br.selectedSpec].toggles["GF"]
	br.player.ui.mode.br = br.data.settings[br.selectedSpec].toggles["BurningRush"]
    br.player.ui.mode.petSummon = br.data.settings[br.selectedSpec].toggles["PetSummon"]

																
    --------------
    --- Locals ---
    --------------
    local activePet = br.player.pet
    local activePetId = br.player.petId
    local artifact = br.player.artifact
    local buff = br.player.buff
    local cast = br.player.cast
    local castable = br.player.cast.debug
    local combatTime = br.getCombatTime()
    local conduit = br.player.conduit
    local cd = br.player.cd
    local debug = br.addonDebug
    local charges = br.player.charges
    local deadMouse = br.GetUnitIsDeadOrGhost("mouseover")
    local deadtar, attacktar, hastar, playertar = deadtar or br.GetUnitIsDeadOrGhost("target"), attacktar or br._G.UnitCanAttack("target", "player"), hastar or br.GetObjectExists("target"), br._G.UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local equiped = br.player.equiped
    local falling, swimming, flying = br.getFallTime(), IsSwimming(), IsFlying()
    local friendly = friendly or br.GetUnitIsFriend("target", "player")
    local gcd = br.player.gcdMax
    local gcdMax = br.player.gcdMax
    local hasMouse = br.GetObjectExists("mouseover")
    local hasteAmount = GetHaste() / 100
    local hasPet = IsPetActive()
    local healPot = br.getHealthPot()
    local heirloomNeck = 122663 or 122664
    local inCombat = br.isInCombat("player")
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local lastSpell = br.lastSpellCast
    local level = br.player.level
    local lootDelay = br.getOptionValue("LootDelay")
    local manaPercent = br.player.power.mana.percent()
    local mode = br.player.ui.mode
    local module = br.player.module
    local moving = br.isMoving("player") ~= false or br.player.moving
    local pet = br.player.pet.list
    local php = br.player.health
    local playerMouse = br._G.UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer = br.PullTimerRemain()
    local race = br.player.race
    local shards = UnitPower("player", Enum.PowerType.SoulShards)
    local summonPet = br.getOptionValue("Summon Pet")
    local solo = #br.friend == 1
    local spell = br.player.spell
    local talent = br.player.talent
    local thp = br.getHP("target")
    local trait = br.player.traits
    local travelTime = br.getDistance("target") / 16
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local use = br.player.use
    local covenant = br.player.covenant
    local ui = br.player.ui
    local cl = br.read


        units.get(6)
        units.get(8)
        units.get(10)
        units.get(12)
        units.get(16)
        units.get(25)
        units.get(30)
        units.get(40)
        enemies.get(6)
        enemies.get(8)
        enemies.get(10)
        enemies.get(10, "player", true)
        enemies.get(12)
        enemies.get(16)
        enemies.get(18) -- Shifting Power
        enemies.get(25)
        enemies.get(30)
        enemies.get(40)
        enemies.get(6,"target")
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(12,"target")
        enemies.get(16,"target")
        enemies.get(18,"target") -- Shifting Power Target
        enemies.get(25,"target")
        enemies.get(30,"target")
        enemies.get(40,"target")

    -- Profile Specific Locals
    if actionList_PetManagement == nil then
        br.loadSupport("PetCuteOne")
        actionList_PetManagement = br.rotations.support["PetCuteOne"]
    end

    if br.pauseTime == nil then br.pauseTime = GetTime() end

    if br.leftCombat == nil then
        br.leftCombat = GetTime()
    end
    if br.profileStop == nil or not inCombat then
        br.profileStop = false
    end
    if castSummonId == nil then
        castSummonId = 0
    end
    if summonTime == nil then
        summonTime = 0
    end

    local function isCC(unit)
        if br.getOptionCheck("Don't break CCs") then return br.isLongTimeCCed(unit) end
        return false
    end

    -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = {br._G.UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end

    --ttd
    local function ttd(unit)
        local ttdSec = br.getTTD(unit)
        if br.getOptionCheck("Enhanced Time to Die") then
            return ttdSec
        end
        if ttdSec == -1 then
            return 999
        end
        return ttdSec
    end

    -- Blacklist enemies
    local function isTotem(unit)
        local eliteTotems = {
            -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = br._G.UnitCreatureType(unit)
        local objectID = br.GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
                return true
            end
        end
        return false
    end


    local noDotUnits = {}
    for i in string.gmatch(br.getOptionValue("Dot Blacklist Units"), "%d+") do
        noDotUnits[tonumber(i)] = true
    end

    local function noDotCheck(unit)
        if mode.dbl ~= 2 then
            if (noDotUnits[br.GetObjectID(unit)] or br._G.UnitIsCharmed(unit)) then
                return true
            end
            if isTotem(unit) then
                return true
            end
            local unitCreator = br._G.UnitCreator(unit)
            if unitCreator ~= nil and br._G.UnitIsPlayer(unitCreator) ~= nil and br._G.UnitIsPlayer(unitCreator) == true then
                return true
            end
            if br.GetObjectID(unit) == 137119 and br.getBuffRemain(unit, 271965) > 0 then
                return true
            end
            return false
        end
    end

 --Defensive dispel whitelist, value is for range to allies on the unit you are dispelling
    local dDispelList = {
        [255584] = 0, -- Molten Gold
        [255041] = 0, -- terrifying-screech
        [257908] = 0, -- Oiled Blade
        [270920] = 0, -- seduction
        [268233] = 0, -- Electrifying Shock
        [268896] = 0, -- Mind Rend
        [272571] = 0, -- choking-waters
        [275014] = 5, -- putrid-waters
        [268008] = 0, -- snake-charm
        [280605] = 0, -- brain-freeze
        [275102] = 0, -- shocking-claw
        [268797] = 0, -- transmute-enemy-to-goo
        [268846] = 0, -- echo-blade
        [263891] = 0 -- grasping-thorns
    }

    --Offensive dispel whitelist, value is for range to allies on the unit you are dispelling
    local oDispelList = {
        [255579] = 0, -- Gilded Claws
        [257397] = 0, -- Healing Balm
        [273432] = 0, -- Bound by Shadow
        [270901] = 0, -- Induce Regeneration
        [267977] = 0, -- tidal-surge
        [268030] = 0, -- mending-rapids
        [276767] = 0, -- Consuming Void
        [272659] = 0, -- electrified-scales
        [269896] = 0, -- embryonic-vigor
        [269129] = 0, -- accumulated-charge
        [268709] = 0, -- earth-shield
        [263215] = 0, -- tectonic-barrier
        [262947] = 0, -- azerite-injection
        [262540] = 0, -- overcharge
        [265091] = 0, -- gift-of-ghuun
        [266201] = 0, -- bone-shield
        [258133] = 0, -- darkstep
        [258153] = 0, -- watery-dome
        [278567] = 0 -- soul-fetish
    }

    local function dispelUnit(unit)
        local i = 1
        local remain
        local validDispel = false
        local dispelDuration = 0

        if br._G.UnitPhaseReason(unit) ~= nil then
            if br.GetUnitIsFriend("player", unit) then
                while br._G.UnitDebuff(unit, i) do
                    local _, _, _, dispelType, debuffDuration, expire, _, _, _, dispelId = br._G.UnitDebuff(unit, i)
                    if (dispelType and dispelType == "Magic") and dDispelList[dispelId] ~= nil and (dDispelList[dispelId] == 0 or (dDispelList[dispelId] > 0 and #br.getAllies(unit, dDispelList[dispelId]) == 1)) then
                        dispelDuration = debuffDuration
                        remain = expire - GetTime()
                        validDispel = true
                        break
                    end
                    i = i + 1
                end
            else
                while br._G.UnitBuff(unit, i) do
                    local _, _, _, dispelType, buffDuration, expire, _, _, _, dispelId = br._G.UnitBuff(unit, i)
                    if (dispelType and dispelType == "Magic") and oDispelList[dispelId] ~= nil and (oDispelList[dispelId] == 0 or (oDispelList[dispelId] > 0 and #br.getAllies(unit, oDispelList[dispelId]) == 0)) then
                        dispelDuration = buffDuration
                        remain = expire - GetTime()
                        validDispel = true
                        break
                    end
                    i = i + 1
                end
            end
        end
        local dispelDelay = 1.5
        if br.isChecked("Dispel delay") then
            dispelDelay = br.getValue("Dispel delay")
        end
        if validDispel and (dispelDuration - remain) > (dispelDelay - 0.3 + math.random() * 0.6) then
            return true
        end
        return false
    end

--local enemies table with extra data
    local facingUnits = 0
    local enemyTable40 = {}
    if #enemies.yards40 > 0 then
        local highestHP
        local lowestHP
        local distance20Max
        local distance20Min
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (not noDotCheck(thisUnit) or br.GetUnitIsUnit(thisUnit, "target")) and not br.GetUnitIsDeadOrGhost(thisUnit) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = br.getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(br.getDistance(thisUnit) - 20)
                enemyUnit.hpabs = br._G.UnitHealth(thisUnit)
                enemyUnit.facing = br.getFacing("player", thisUnit)
                if enemyUnit.facing then
                    facingUnits = facingUnits + 1
                end
                tinsert(enemyTable40, enemyUnit)
                if highestHP == nil or highestHP < enemyUnit.hpabs then
                    highestHP = enemyUnit.hpabs
                end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then
                    lowestHP = enemyUnit.hpabs
                end
                if distance20Max == nil or distance20Max < enemyUnit.distance20 then
                    distance20Max = enemyUnit.distance20
                end
                if distance20Min == nil or distance20Min > enemyUnit.distance20 then
                    distance20Min = enemyUnit.distance20
                end
            end
        end
        if #enemyTable40 > 1 then
            for i = 1, #enemyTable40 do
                local hpNorm = (5 - 1) / (highestHP - lowestHP) * (enemyTable40[i].hpabs - highestHP) + 5 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0 / 0) then
                    hpNorm = 0
                end -- NaN check
                local distance20Norm = (3 - 1) / (distance20Max - distance20Min) * (enemyTable40[i].distance20 - distance20Min) + 1 -- normalization of distance 20, low is good
                if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0 / 0) then
                    distance20Norm = 0
                end -- NaN check
                local enemyScore = hpNorm + distance20Norm
                if enemyTable40[i].facing then
                    enemyScore = enemyScore + 10
                end
                if enemyTable40[i].ttd > 1.5 then
                    enemyScore = enemyScore + 10
                end
                enemyTable40[i].enemyScore = enemyScore
            end
            table.sort(
                enemyTable40,
                function(x, y)
                    return x.enemyScore > y.enemyScore
                end
            )
        end
        -- Auto target if we have no target in combat. 
        if br.isChecked("Auto Target") and (inCombat or not inCombat and solo ) and #enemyTable40 > 0 
        and ((br.GetUnitExists("target") 
        and br.GetUnitIsDeadOrGhost("target") 
        and not br.GetUnitIsUnit(enemyTable40[1].unit, "target")) 
        or not br.GetUnitExists("target")) 
        then
            br._G.TargetUnit(enemyTable40[1].unit)
        end
        
    -- Declare Auto Faccia's glory into existence. 
    var.kinkyModule_AutoFaccia = function(delay) 
        if delay == nil then delay = ui.value("Auto Faccia Delay") end;
        if bool == nil then bool = true end;

        -- Auto Faccia and solo and are not facing this unit mafukkaaaaa 
        if br.isChecked("Auto Faccia") and (inCombat or not inCombat and solo ) and #enemyTable40 > 0 
        and (br.GetUnitExists("target") and br._G.UnitCanAttack("target", "player") 
        and not br.GetUnitIsDeadOrGhost("target") and br.isValidTarget("target")) and br.getDistance("target") < 30
        and not br.getFacing("player", "target") 
        and br.timer:useTimer("Fauccia Delay1", math.random(5))
        then
            br._G.FaceDirection("target",true);
            -- Persistence is key, young padawan. 
            if not br.getFacing("player", "target") and br.timer:useTimer("Fauccia Delay15", math.random(5)) then br._G.FaceDirection("target",true) end;
        end
    end

        var.kinkyModule_AutoFaccia()
        -- Yeah, my rotation got the vaccine. Fuck off. 
        --var.kinkyModule_AntiCoof = function()
            
      --  end
        

     --   var.kinkyModule_AntiCoof()

    end

    --Keybindings
    local shadowfuryKey = false
    if br.getOptionValue("Shadowfury") ~= 1 then
        shadowfuryKey = _G["rotationFunction" .. (br.getOptionValue("Shadowfury") - 1)]
        if shadowfuryKey == nil then
            shadowfuryKey = false
        end
    end
    -- spell usable check
    local function spellUsable(spellID)
        if br.isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and br.getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end

    
    -- Pet Data
    if mode.petSummon == 1 and HasAttachedGlyph(spell.summonFelguard) then
        summonId = 58965
    elseif mode.petSummon == 1 then
        summonId = 17252
    elseif mode.petSummon == 2 and HasAttachedGlyph(spell.summonImp) then
        summonId = 58959
    elseif mode.petSummon == 2 then
        summonId = 416
    elseif mode.petSummon == 3 and HasAttachedGlyph(spell.summonVoidwalker) then
        summonId = 58960
    elseif mode.petSummon == 3 then
        summonId = 1860
    elseif mode.petSummon == 4 then
        summonId = 417
    elseif mode.petSummon == 5 then
        summonId = 1863
    end



    --Pet locals
    local wildImps = 0
    local tyrantActive = false
    local dreadstalkersRemain = 0
    local foundDreakstalker = false
    local foundVilefiend = false
    local felguardActive = false
    local foundGrimoire = false
    local vilefiendActive = false
    local vilefiendRemain = 0
    local grimoireRemain = 0

    if pet ~= nil then
        for k, v in pairs(pet) do
            local thisUnit = pet[k] or 0
            if thisUnit.id == 135002 and not tyrantActive and not br.GetUnitIsDeadOrGhost(thisUnit.unit) then
                tyrantActive = true
            elseif thisUnit.id == 55659 and not br.GetUnitIsDeadOrGhost(thisUnit.unit) then
                wildImps = wildImps + 1
            elseif thisUnit.id == 135816 and not br.GetUnitIsDeadOrGhost(thisUnit.unit) then
                if not vilefiendActive then
                    vilefiendTime = GetTime()
                end
                foundVilefiend = true
                vilefiendActive = true    
            elseif thisUnit.id == 98035 and not br.GetUnitIsDeadOrGhost(thisUnit.unit) then
                if not dreadstalkersActive then
                    dreadstalkersTime = GetTime()
                end
                foundDreakstalker = true
                dreadstalkersActive = true
            elseif thisUnit.id == 17252 or thisUnit.id == 58965 and not br.GetUnitIsDeadOrGhost(thisUnit.unit) then
                local grimoire = br.getBuffRemain(thisUnit.unit, 216187)
                if grimoire == 0 then
                    felguardActive = true
                end
                if grimoire ~= 0 then
                    if not grimoireActive then
                        grimoireTime = GetTime()
                    end
                    grimoireActive = true
                    foundGrimoire = true
                end
            end
        end
    end
    if not foundDreakstalker then
        dreadstalkersActive = false
    end
    if dreadstalkersActive then
        dreadstalkersRemain = dreadstalkersTime - GetTime() + 12
    end
    if not foundGrimoire then
        grimoireActive = false
    end
    if grimoireActive then
        grimoireRemain = grimoireTime - GetTime() + 12
    end
    if not foundVilefiend then
        vilefiendActive = false
    end
    if vilefiendActive then
        vilefiendRemain = vilefiendTime - GetTime() + 12
    end
    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
    local function actionList_Extras()
        -- Dummy Test
        if br.isChecked("DPS Testing") then
            if br.GetObjectExists("target") then
                if br.getCombatTime() >= (tonumber(br.getOptionValue("DPS Testing")) * 60) and br.isDummy() then
                    br._G.StopAttack()
                    br._G.ClearTarget()
                    if br.isChecked("Pet Management") then
                        br._G.PetStopAttack()
                        br._G.PetFollow()
                    end
                    br._G.print(tonumber(br.getOptionValue("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                    br.profileStop = true
                end
            end
        end -- End Dummy Test
        if br.SpecificToggle("Shadowfury") and br.isChecked("Shadowfury") and not GetCurrentKeyBoardFocus() then
            if br.getOptionValue("Shadowfury Target") == 1 then
                if cast.shadowfury("best", false, 1, 8) then
                    return
                end
            elseif br.getOptionValue("Shadowfury Target") == 2 then
                if cast.shadowfury("target", "ground") then
                    return
                end
            elseif br.getOptionValue("Shadowfury Target") == 3 and br.getSpellCD(spell.shadowfury) == 0 then
                br._G.CastSpellByName(GetSpellInfo(spell.shadowfury), "cursor")
                return
            end
        end
        -- Demonic Gateway
        if br.SpecificToggle("Demonic Gateway") and not GetCurrentKeyBoardFocus() then
            if br.timer:useTimer("RoF Delay", 1) and br._G.CastSpellByName(GetSpellInfo(spell.demonicGateway),"cursor") then br.addonDebug("Casting Demonic Gateway") return end 
            if br._G.IsAoEPending() then br._G.CancelPendingSpell() end
        end

        -- Demonic Circle: Summon
        if br.SpecificToggle("Demonic Circle Summon") 
        and not GetCurrentKeyBoardFocus() 
        then
            if br.timer:useTimer("DC Delay", 1) then cast.demonicCircle("player") br.addonDebug("Demonic Circle (Summon)") return true end 
        end
        -- Demonic Circle: Teleport
        if br.SpecificToggle("Demonic Circle Teleport")
        and not GetCurrentKeyBoardFocus() 
        then
            if br.timer:useTimer("DC Delay", 1) and buff.demonicCircle.exists() then cast.demonicTeleport("player") br.addonDebug("Demonic Circle (Summon)") return true end 
        end
        -- Demonic Circle: Teleport
        if br.SpecificToggle("Demonic Circle Teleport (HP%)")
        and not GetCurrentKeyBoardFocus() 
        then
            if br.timer:useTimer("DC Delay", 1) and buff.demonicCircle.exists() then cast.demonicTeleport("player") br.addonDebug("Demonic Circle (Summon)") return true end 
        end


        --Burn Units
        local burnUnits = {
            [120651] = true, -- Explosive
            [141851] = true, -- Infested
            [164362] = true, -- Plaguefall Dungeon - if they reach boss the heal him
            [168326] = true, -- Shattered Visage
            -- Shadowlands Raid
            [165762] = true, -- Soul Infuser
            [175992] = true, -- Dutiful Attendant
            [176026] = true -- Dancing Fools
            
        }
        if br.GetObjectExists("target") and burnUnits[br.GetObjectID("target")] ~= nil then
        end
        --Soulstone
        if br.isChecked("Auto Soulstone Mouseover") and not moving and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
            if cast.soulstone("mouseover", "dead") then
                return true
            end
        end
        local mapMythicPlusModeID, mythicPlusLevel, mythicPlustime, mythicPlusOnTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()
        if ui.checked("Soulstone Healer OOC [Mythic+]") and not solo and not moving then
            --if mythicPlusLevel ~= 0 then
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") 
                    and (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER") 
                    and (not buff.soulstone.exists(br.friend[i].unit))
                    and br.timer:useTimer("Healer SS", 3) 
                    then
                        if cast.soulstone(br.friend[i].unit) then
                            br.addonDebug("Soulstone Healer OOC [Mythic+] YEEEEEEEEEEEEEEEEET")
                            return true
                        end
                    end
                end
            --end
        end
        -- Auto Mythic+ Keystone | Module
        var.mapID = C_ChallengeMode.GetActiveChallengeMapID();
        if not inCombat and not (IsFlying() or IsMounted()) and not solo then
            if var.activeMythicMapID then
                module.autoKeystone()
            end
        end
        

        if br.isChecked("Auto Soulstone Player") and not inInstance and not inRaid and (not buff.soulstone.exists("player") or buff.soulstone.remain("player") < 100) and not inCombat and not moving then
            if cast.soulstone("player") then
                return
            end
        end
        -- Mortal Coil
        if ui.checked("Mortal Coil") and php <= ui.value("Mortal Coil") then
            if cast.mortalCoil() then br.addonDebug("Casting Mortal Coil") return true end
        end
        -- Burning Rush
        if mode.br ~= 2 and not (IsSwimming() or IsFlying() or IsFalling())then
            if buff.burningRush.exists() and not moving or buff.burningRush.exists() and php <= ui.value("Burning Rush Health") then br._G.RunMacroText("/cancelaura Burning Rush") br.addonDebug("Canceling Burning Rush") return true end 
            if mode.burningRush ~= 2 and br.timer:useTimer("Burning Rush Delay", br.getOptionValue("Burning Rush Delay")) and moving and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end
            if mode.burningRush == 3 and br.timer:useTimer("Burning Rush Delay", br.getOptionValue("Burning Rush Delay")) and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end
        end    
    end -- End Action List - Extras
    -- Action List - Defensive
    local function actionList_Defensive()
        if br.useDefensive() then
            -- Basic Healing Module
            module.BasicHealing()
            --dispel logic for m+
            if inInstance and br.isChecked("Auto Dispel/Purge") then
                if spellUsable(spell.devourMagic) then
                    for i = 1, #enemyTable40 do
                        local thisUnit = enemyTable40[i].unit
                        if dispelUnit(thisUnit) then
                            if cast.devourMagic(thisUnit) then
                                return true
                            end
                        end
                    end
                end
                if spellUsable(spell.singeMagic) or spellUsable(spell.singeMagicGrimoire) then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        if dispelUnit(thisUnit) then
                            if cast.singeMagic(thisUnit) then
                                return true
                            end
                            if cast.singeMagicGrimoire(thisUnit) then
                                return true
                            end
                        end
                    end
                end
            end
            -- Dark Pact
            if br.isChecked("Dark Pact") and php <= br.getOptionValue("Dark Pact") then
                if cast.darkPact() then
                    return
                end
            end
            -- Drain Life
            if br.isChecked("Drain Life") and php <= br.getOptionValue("Drain Life") and br.isValidTarget("target") and not moving then
                if cast.drainLife() then
                    return
                end
            end
            -- Health Funnel
            if (solo or GetRealZoneText() == "Torghast, Tower of the Damned") and br.isChecked("Health Funnel") and br.getHP("pet") <= br.getOptionValue("Health Funnel") and br.GetObjectExists("pet") == true and not br.GetUnitIsDeadOrGhost("pet") and not moving then
                if cast.healthFunnel("pet") then
                    return
                end
            end
            -- Unending Resolve
            if br.isChecked("Unending Resolve") and php <= br.getOptionValue("Unending Resolve") and inCombat then
                if cast.unendingResolve() then
                    return
                end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive
    -- Action List - Interrupts
    local function actionList_Interrupts()
        if br.useInterrupts() then
            if talent.grimoireOfSacrifice then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                        if cast.spellLockgrimoire(thisUnit) then
                            return
                        end
                    end
                end
            elseif br.useInterrupts() and (activePetId == 17252 or activePetId == 58965) then
                for i=1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if br.canInterrupt(thisUnit,br.getOptionValue("Interrupt At")) or br.isCrowdControlCandidates(thisUnit) then
                        if (activePetId == 17252 or activePetId == 58965) then
                            if cast.axeToss(thisUnit) then return true end
                        end
                    end
                end
            end 
        end 
    end -- End Action List - Interrupts
    -- Action List - Cooldowns
    local function actionList_Cooldowns()
        if br.getDistance("target") < 40 then
            -- actions=potion,if=pet.demonic_tyrant.active|target.time_to_die<30
            if br.isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (tyrantActive or ttd("target") < 30) then
                use.battlePotionOfIntellect()
                return true
            end
            -- actions+=/use_items,if=pet.demonic_tyrant.active|target.time_to_die<=15
            -- Trinkets
            module.BasicTrinkets()
            -- actions+=/berserking,if=pet.demonic_tyrant.active|target.time_to_die<=15
            -- actions+=/blood_fury,if=pet.demonic_tyrant.active|target.time_to_die<=15
            -- actions+=/fireblood,if=pet.demonic_tyrant.active|target.time_to_die<=15
            if br.isChecked("Racial") and not moving then
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target", "ground") then
                            return true
                        end
                    else
                        if cast.racial("player") then
                            return true
                        end
                    end
                end
            end
        end -- End useCDs check
    end -- End Action List - Cooldowns

    local function Line_cd (spellid, seconds)
        if br.lastCastTable.line_cd then
            if br.lastCastTable.line_cd[spellid] then
                if br.lastCastTable.line_cd[spellid] + seconds >= GetTime() then
                    return false
                end
            end
        end
        return true
    end

    local function actionList_BuildAShard() 
        -- actions.build_a_shard=soul_strike
        if cast.soulStrike("target")then ui.debug("[Action:BuildAShard] Soul Strike")
            return true
        end
        -- actions.build_a_shard+=/shadow_bolt
        if not moving then
            if cast.shadowBolt("target") then ui.debug("[Action:BuildAShard] Shadow Bolt")
                return true
            end
        end
    end

    local function actionList_NetherPortalBuilding()
        
    if spellQueueReady() then
        -- actions.nether_portal_building=nether_portal,if=so
        if not moving and not buff.demonicCore.exists() then
            if cast.netherPortal("target") then ui.debug("[Action:PortalBuilding] Nether Portal")
                return true
            end
        end
        -- actions.nether_portal_building+=/call_dreadstalkers
        if not moving then
            if cast.callDreadstalkers("target") then ui.debug("[Action:PortalBuilding] Call Dreadstalkers")
                return true
            end
        end
        -- actions.nether_portal_building+=/hand_of_guldan,if=cooldown.call_dreadstalkers.remains>18&soul_shard>=3
        if not moving and cd.callDreadstalkers.remain() > 18 and shards >= 3 then
            if cast.handOfGuldan("target") then ui.debug("[Action:PortalBuilding] Hand of Guldan")
                return true
            end
        end
        -- actions.nether_portal_building+=/power_siphon,if=buff.wild_imps.stack>=2&buff.demonic_core.stack<=2&buff.demonic_power.down&soul_shard>=3
        if wildImps >= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and shards >= 2 then
            if cast.powerSiphon("target") then ui.debug("[Action:PortalBuilding] Power Siphon")
                return true
            end
        end
        -- actions.nether_portal_building+=/hand_of_guldan,if=soul_shard>=5
        if not moving and shards >= 5 then
            if cast.handOfGuldan("target") then ui.debug("[Action:PortalBuilding] Hand of Guldan")
                return true
            end
        end
        -- actions.nether_portal_building+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end
    end
    end

    local function actionList_NetherPortalActive()
    if spellQueueReady() then

        local casttime = select(4,GetSpellInfo(172))
        --bilescourge_bombers
        if mode.bsb == 1 and mode.rotation ~= 3 then
            if br.getOptionValue("Bilescourge Bombers Target") == 1 then
                if (#enemies.yards8t >= br.getOptionValue("Bilescourge Bombers Units") or (br.isChecked("Ignore Bilescourge Bombers units when using CDs") and br.useCDs())) then
                    if cast.bilescourgeBombers("target", "ground") then ui.debug("[Action:PortalActive] Bilescourge Bombers (Ground)")
                        return true
                    end
                end
            else
                if br.isChecked("Ignore Bilescourge Bombers units when using CDs") and br.useCDs() then
                    if cast.bilescourgeBombers("best", false, 1, 8) then ui.debug("[Action:PortalActive] Bilescourge Bombers (Ignore Units)")
                        return true
                    end
                else
                    if cast.bilescourgeBombers("best", false, br.getOptionValue("Bilescourge Bombers Units"), 8) then ui.debug("[Action:PortalActive] Bilescourge Bombers (Best)")
                        return true
                    end
                end
            end
        end
        -- actions.nether_portal_active=grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        if mode.gf == 1 then
            if cast.grimoireFelguard("target") then ui.debug("[Action:PortalActive] Grimoire Felguard")
                return true
            end
        end
        -- actions.nether_portal_active+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>40|cooldown.summon_demonic_tyrant.remains<12
        if not moving and (cd.summonDemonicTyrant.remain() > 40 or cd.summonDemonicTyrant.remain() < 12) then
            if cast.summonVilefiend("target") then ui.debug("[Action:PortalActive] Summon Vilefiend")
                return true
            end
        end
        -- actions.nether_portal_active+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if not moving and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14) then
            if cast.callDreadstalkers("target") then ui.debug("[Action:PortalActive] Call Dreadstalkers")
                return true
            end
        end
        -- actions.nether_portal_active+=/call_action_list,name=build_a_shard,if=soul_shard=1&(cooldown.call_dreadstalkers.remains<action.shadow_bolt.cast_time|(talent.bilescourge_bombers.enabled&cooldown.bilescourge_bombers.remains<action.shadow_bolt.cast_time))
        if shards == 1 and (cd.callDreadstalkers.remain() < cast.time.shadowBolt() or (cast.able.bilescourgeBombers() and cd.bilescourgeBombers.remain() < cast.time.shadowBolt())) then
            if actionList_BuildAShard() then 
                return true
            end
        end
        -- actions.nether_portal_active+=/hand_of_guldan,if=((cooldown.call_dreadstalkers.remains>action.demonbolt.cast_time)&(cooldown.call_dreadstalkers.remains>action.shadow_bolt.cast_time))&cooldown.nether_portal.remains>(160+action.hand_of_guldan.cast_time)
        if not moving and (cd.callDreadstalkers.remain() > cast.time.demonbolt() and cd.callDreadstalkers.remain() > cast.time.shadowBolt() and cd.netherPortal.remain() > (165 + cast.time.handOfGuldan())) then
            if cast.handOfGuldan("target") then ui.debug("[Action:PortalActive] Hand of Guldan")
                return true
            end
        end
        -- actions.nether_portal_active+=/summon_demonic_tyrant,if=buff.nether_portal.remains<10&soul_shard=0
        if not moving and buff.netherPortal.remain() < 5 and shards == 0 then
            if cast.summonDemonicTyrant("target") then ui.debug("[Action:PortalActive] Summon Demonic Tyrant (0 Shards)")
                return true
            end
        end
        -- actions.nether_portal_active+=/summon_demonic_tyrant,if=buff.nether_portal.remains<action.summon_demonic_tyrant.cast_time+5.5
        if not moving and buff.netherPortal.remain() < (cast.time.summonDemonicTyrant() + 0.5) then
            if cast.summonDemonicTyrant("target") then ui.debug("[Action:PortalActive] Summon Demonic Tyrant (NP Buff)")
                return true
            end
        end
        -- actions.nether_portal_active+=/demonbolt,if=buff.demonic_core.up
        if buff.demonicCore.exists() then
            if cast.demonbolt("target") then ui.debug("[Action:PortalActive] Demonbolt") return true end
                if br.isChecked("Auto Faccia") and not br.getLineOfSight("player","target") then
                    var.Module_KinkySex(spell.dragonsBreath,"target")
                    debug("[Action:Combust Phase] Dragons Breath (COMBUUUST) (11)")
                    return true 
            else 
                if cast.dragonsBreath("target") then debug("[Action:Combust Phase] Dragons Breath (COMBUUUST) (11)") return true end
            end  
        end
        -- actions.nether_portal_active+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end 
    end
    end

    local function actionList_NetherPortal()
        local casttime = select(4,GetSpellInfo(172))
        -- actions.nether_portal=call_action_list,name=nether_portal_building,if=cooldown.nether_portal.remains<20
        if cd.netherPortal.remain() < 20 then
            if actionList_NetherPortalBuilding() then
                return true
            end
        end
        -- actions.nether_portal+=/call_action_list,name=nether_portal_active,if=cooldown.nether_portal.remains>160
        if cd.netherPortal.remain() > 165 then
            if actionList_NetherPortalActive() then
                return true
            end
        end
    end

    local function actionList_Implosion()
    if spellQueueReady() then
                local casttime = select(4,GetSpellInfo(172))

        -- actions.implosion=implosion,if=(buff.wild_imps.stack>=6&(soul_shard<3|prev_gcd.1.call_dreadstalkers|buff.wild_imps.stack>=9|prev_gcd.1.bilescourge_bombers|(!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan))&!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan&buff.demonic_power.down)|(time_to_die<3&buff.wild_imps.stack>0)|(prev_gcd.2.call_dreadstalkers&buff.wild_imps.stack>2&!talent.demonic_calling.enabled)
        if (wildImps >= 6 and (shards < 3 or cast.last.callDreadstalkers(1) or wildImps >= 9 or cast.last.bilescourgeBombers(1) or (not cast.last.handOfGuldan(1) or not cast.last.handOfGuldan(2))) and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) and botSpell ~= spell.implosion and not buff.demonicPower.exists()) or (ttd("target") < 3 and wildImps > 0 and br.useCDs()) or (cast.last.callDreadstalkers(2) and wildImps > 2 and not talent.demonicCalling) then
            if cast.implosion("target") then ui.debug("[Action:Implosion] Implosion")
                return true
            end
        end
        -- actions.implosion+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        if not moving and mode.gf == 1 and br.useCDs() then
            if cast.grimoireFelguard("target") then ui.debug("[Action:Implosion] Grimoire Felguard")
                return true
            end
        end
        -- actions.implosion+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if not moving and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14 or not br.useCDs()) then
            if cast.callDreadstalkers("target") then ui.debug("[Action:Implosion] Call Dreadstalkers")
                return true
            end
        end
        -- actions.implosion+=/summon_demonic_tyrant
        if br.useCDs() and not moving then
            if cast.summonDemonicTyrant("target") then ui.debug("[Action:Implosion] Summon Demonic Tyrant")
                return true
            end
        end
        -- actions.implosion+=/hand_of_guldan,if=soul_shard>=5
        if shards >= 5 and not moving then
            if cast.handOfGuldan("target") then ui.debug("[Action:Implosion] Hand of Guldan (Shards >= 5)")
                return true
            end
        end
        -- actions.implosion+=/hand_of_guldan,if=soul_shard>=3&(((prev_gcd.2.hand_of_guldan|buff.wild_imps.stack>=3)&buff.wild_imps.stack<9)|cooldown.summon_demonic_tyrant.remains<=gcd*2|buff.demonic_power.remains>gcd*2)
        if shards >= 3 and not moving and (((cast.last.handOfGuldan(2) or wildImps >= 3) and wildImps < 9) or cd.summonDemonicTyrant.remain() <= gcdMax * 2 or buff.demonicPower.remain() > gcdMax * 2 or not br.useCDs()) then
            if cast.handOfGuldan("target") then ui.debug("[Action:Implosion] Hand of Guldan (Shards >= 3)")
                return true
            end
        end
        -- actions.implosion+=/demonbolt,if=prev_gcd.1.hand_of_guldan&soul_shard>=1&(buff.wild_imps.stack<=3|prev_gcd.3.hand_of_guldan)&soul_shard<4&buff.demonic_core.up
        if cast.last.handOfGuldan(1) and shards >= 1 and (wildImps <= 3 or cast.last.handOfGuldan(3)) and shards < 4 and buff.demonicCore.exists() then
            if cast.demonbolt("target") then ui.debug("[Action:Implosion] Demonbolt")
                return true
            end
        end
        -- actions.implosion+=/summon_vilefiend,if=(cooldown.summon_demonic_tyrant.remains>40&spell_targets.implosion<=2)|cooldown.summon_demonic_tyrant.remains<12
        if not moving and br.useCDs() and ((cd.summonDemonicTyrant.remain() > 40 and (#enemies.yards8t <= 2 or mode.rotation == 3)) or cd.summonDemonicTyrant.remain() < 12) then
            if cast.summonVilefiend("target") then ui.debug("[Action:Implosion] Summon Vilefiend")
                return true
            end
        end
        -- actions.implosion+=/bilescourge_bombers,if=cooldown.summon_demonic_tyrant.remains>9
        if mode.bsb == 1 and (cd.summonDemonicTyrant.remain() > 9 or not br.useCDs()) then
            if br.getOptionValue("Bilescourge Bombers Target") == 1 then
                if (#enemies.yards8t >= br.getOptionValue("Bilescourge Bombers Units") or (br.isChecked("Ignore Bilescourge Bombers units when using CDs") and br.useCDs())) then
                    if cast.bilescourgeBombers("target", "ground") then ui.debug("[Action:Implosion] Bilescourge Bombers (Ground)")
                        return true
                    end
                end
            else
                if br.isChecked("Ignore Bilescourge Bombers units when using CDs") and br.useCDs() then
                    if cast.bilescourgeBombers("best", false, 1, 8) then ui.debug("[Action:Implosion] Bilescourge Bombers (Ignore Units)")
                        return true
                    end
                else
                    if cast.bilescourgeBombers("best", false, br.getOptionValue("Bilescourge Bombers Units"), 8) then ui.debug("[Action:Implosion] Bilescourge Bombers (Best)")
                        return true
                    end
                end
            end
        end
        -- actions.implosion+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
        if shards < 5 and buff.demonicCore.stack() <= 2 and  GetPetActionInfo(4) == GetSpellInfo(30213)  then
            if cast.soulStrike("target") then ui.debug("[Action:Implosion] Soul Strike")
                return true
            end
        end
        -- actions.implosion+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&(buff.demonic_core.stack>=3|buff.demonic_core.remains<=gcd*5.7)
        if shards <= 3 and buff.demonicCore.exists() and (buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() <= gcdMax * 5.7) then
            if cast.demonbolt("target") then ui.debug("[Action:Implosion] Demonbolt (Proc)")
                return true
            end
        end
        -- actions.implosion+=/doom,cycle_targets=1,max_cycle_targets=7,if=refreshable
        if cast.able.doom() and debuff.doom.count() < br.getOptionValue("Multi-Dot Limit") then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if debuff.doom.refresh(thisUnit) then
                    if cast.doom(thisUnit) then ui.debug("[Action:Implosion] Doom (Spreading)")
                        return true
                    end
                end
            end
        end
        -- actions.implosion+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end 
    end
    end

    local function actionList_CovenantSpells()
        ------------------------------------------------
        -- Covenants (Level 60) ------------------------
        ------------------------------------------------
        if level == 60 and not moving then
            ------------------------------------------------
            -- Impending Catastrophe : Venthyr -------------
            ------------------------------------------------
            -- actions.covenant=impending_catastrophe,if=!talent.sacrificed_souls.enabled|active_enemies>1
            if covenant.venthyr.active and ttd("target") > 7 and spellUsable(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax 
            and (not talent.sacrificedSouls or #enemies.yards10t > 1) then
                if cast.impendingCatastrophe("target") then br.addonDebug("[Action:Rotation] Impending Catastrophe") return true end
            end
            ------------------------------------------------
            -- Impending Catastrophe : Venthyr -------------
            ------------------------------------------------
            if covenant.venthyr.active and spellUsable(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax then
                if cast.impendingCatastrophe("target") then br.addonDebug("[Action:AOE] Impending Catastrophe") return true end
            end
            ------------------------------------------------
            -- Decimating Bolt : Necrolord -----------------
            ------------------------------------------------
            -- actions.covenant+=/decimating_bolt
            if covenant.necrolord.active and spellUsable(325289) and select(2,GetSpellCooldown(325289)) <= gcdMax then
                if cast.decimatingBolt("target") then br.addonDebug("[Action:Rotation] Decimating Bolt") return true end
            end    
            ------------------------------------------------
            -- Soul Rot : Night Fae ------------------------
            ------------------------------------------------
            -- actions.covenant+=/scouring_tithe,if=!talent.sacrificed_souls.enabled&active_enemies<4
            if covenant.nightFae.active and spellUsable(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax and ttd("target") > 8
            and br.useCDs() and #enemies.yards6t > 1 then
                if cast.soulRot("target") then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end
            ------------------------------------------------
            -- Soul Rot ------------------------------------
            ------------------------------------------------
            if covenant.nightFae.active and ttd("target") > 8 and spellUsable(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax then
                if cast.soulRot("target") then br.addonDebug("[Action:AoE] Soul Rot") return true end
            end 
            ------------------------------------------------
            -- Scouring Tithe : Kyrian ---------------------
            ------------------------------------------------
            -- actions.covenant+=/scouring_tithe,if=talent.sacrificed_souls.enabled&active_enemies=1
            if covenant.kyrian.active and spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax
            and (talent.sacrificedSouls and #enemies.yards10t == 1) then
                if cast.scouringTithe("target") then br.addonDebug("[Action:Rotation] Scouring Tithe") return true end
            end
            -- actions.covenant+=/scouring_tithe,if=!talent.sacrificed_souls.enabled&active_enemies<4
            if covenant.kyrian.active and spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax
            and (not talent.sacrificedSouls and #enemies.yards10t < 4) then
                if cast.scouringTithe("target") then br.addonDebug("[Action:Rotation] Scouring Tithe") return true end
            end
        end
    end

    local function actionList_Rotation()
        if br.useCDs() then
            if actionList_Cooldowns() then
                return true
            end
        end

        local DisembodiedTongue = br.UnitBuffID("player", 322455)

        if (GetRealZoneText() == "Torghast, Tower of the Damned" and DisembodiedTongue or DisembodiedTongueLearned == true) then 
             for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if debuff.curseOfTongues.refresh(thisUnit) then
                    if cast.curseOfTongues(thisUnit) then ui.debug("[Action:Implosion] Torghast Tongues (Spreading)")
                        DisembodiedTongueLearned = true 
                        return true
                    end
                end
            end
        end
        
        local casttime = select(4,GetSpellInfo(172))
        -- actions.implosion+=/doom,cycle_targets=1,max_cycle_targets=7,if=refreshable
        if br.isChecked("Instant Corruption Torghast") and (GetRealZoneText() == "Torghast, Tower of the Damned" and casttime == 0) and debuff.corruption.count() < br.getOptionValue("Multi-Dot Limit") then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if debuff.corruption.refresh(thisUnit) then
                    if cast.corruption(thisUnit) then ui.debug("[Action:Implosion] Torghast Corruption (Spreading)")
                        return true
                    end
                end
            end
        end
        --
        -- actions+=/hand_of_guldan,if=azerite.explosive_potential.rank&time<5&soul_shard>2&buff.explosive_potential.down&buff.wild_imps.stack<3&!prev_gcd.1.hand_of_guldan&&!prev_gcd.2.hand_of_guldan
        if not moving and combatTime < 5 and shards > 2 and wildImps < 3 and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) then
            if cast.handOfGuldan("target") then ui.debug("[Action:Rotation] Hand of Guldan")
                return true
            end
        end
        -- actions+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&buff.demonic_core.stack=4
        if shards < 4 and buff.demonicCore.exists() then
            if cast.demonbolt("target") then ui.debug("[Action:Rotation] Demonbolt (Proc) ")
                return true
            end
        end
        -- actions+=/implosion,if=active_enemies>1&!talent.sacrificed_souls.enabled&buff.wild_imps.stack>=8&buff.tyrant.down&cooldown.summon_demonic_tyrant.remains>5
        if br.isChecked("Implosion ST") and (#enemies.yards10t < 2 or mode.rotation == 3) and not talent.sacrificedSouls and wildImps >= 8 and not buff.demonicPower.exists() and cd.summonDemonicTyrant.remains() > 5 then
            if cast.implosion("target") then ui.debug("[Action:Rotation] Implosion (Wild Imps >= 8)")
                return true
            end
        end
        -- actions+=/implosion,if=active_enemies>2&buff.wild_imps.stack>=8&buff.tyrant.down
        -- actions+=/doom,if=!ticking&time_to_die>30&spell_targets.implosion<2
        if not debuff.doom.exists("target") and ttd("target") > 30 and (#enemies.yards8t < 2 or mode.rotation == 3) then
            if cast.doom("target") then ui.debug("[Action:Rotation] Doom")
                return true
            end
        end
        -- actions+=/demonic_strength,if=(buff.wild_imps.stack<6|buff.demonic_power.up)|spell_targets.implosion<2
        if felguardActive and botSpell ~= spell.demonicStrength and br.useCDs() and (wildImps < 6 or buff.demonicPower.exists() or (#enemies.yards8t < 2 or mode.rotation == 3)) then
            if cast.demonicStrength("target") then ui.debug("[Action:Rotation] Demonic Strength")
                return true
            end
        end
        -- actions+=/call_action_list,name=nether_portal,if=talent.nether_portal.enabled&spell_targets.implosion<=2
        
        if incombat and not buff.demonicCore.exists() then
            if actionList_NetherPortal() then
                return true
            end
        end
        -- actions+=/call_action_list,name=implosion,if=spell_targets.implosion>1
        if mode.rotation ~= 3 and #enemies.yards8t >= br.getOptionValue("Implosion Units") then
            if actionList_Implosion() then
                return true
            end
        end
        -- actions+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        if mode.gf == 1 and br.useCDs() then
            if cast.grimoireFelguard("target") then ui.debug("[Action:Rotation] Grimoire Felguard")
                return true
            end
        end
        -- actions+=/summon_vilefiend,if=equipped.132369|cooldown.summon_demonic_tyrant.remains>40|cooldown.summon_demonic_tyrant.remains<12
        if not moving and br.useCDs() and (cd.summonDemonicTyrant.remain() > 40 or cd.summonDemonicTyrant.remain() < 12) then
            if cast.summonVilefiend("target") then ui.debug("[Action:Rotation] Summon Vilefiend")
                return true
            end
        end
        -- actions+=/call_dreadstalkers,if=equipped.132369|(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if not moving and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14) then
            if cast.callDreadstalkers("target") then ui.debug("[Action:Rotation] Call Dreadstalkers")
                return true
            end
        end
        local dCTalent = 0
        if talent.demonicConsumption then
            dCTalent = 1
        end
        -- actions+=/summon_demonic_tyrant,if=equipped.132369|(buff.dreadstalkers.remains>cast_time&(buff.wild_imps.stack>=3+talent.inner_demons.enabled+talent.demonic_consumption.enabled*3|prev_gcd.1.hand_of_guldan&(!talent.demonic_consumption.enabled|buff.wild_imps.stack>=3+talent.inner_demons.enabled))&(soul_shard<3|buff.dreadstalkers.remains<gcd*2.7|buff.grimoire_felguard.remains<gcd*2.7))
        --if not moving and br.useCDs() and (dreadstalkersRemain > cast.time.summonDemonicTyrant() and (wildImps >= (3) or (cast.last.handOfGuldan(1) and (not talent.demonicConsumption or wildImps >= 3))) and (shards < 3 or dreadstalkersRemain < gcdMax * 2.7 or grimoireRemain < gcdMax * 2.7)) then
        if not moving and br.useCDs() and wildImps >= 3 and shards < 3 then
            if (dreadstalkersActive or dreadstalkersRemain > cast.time.summonDemonicTyrant()) 
            and (vilefiendActive or vilefiendRemain > cast.time.summonDemonicTyrant())
            and (grimoireActive or grimoireRemain > cast.time.summonDemonicTyrant()) then
                if cast.summonDemonicTyrant("target") then ui.debug("[Action:Rotation] Summon Demonic Tyrant (All)")
                    return true
                end
            elseif (dreadstalkersActive or cd.callDreadstalkers.remains() >= gcdMax)
            and (vilefiendActive or cd.summonVilefiend.remains() >= gcdMax)
            and (grimoireActive or cd.grimoireFelguard.remains() >= gcdMax) then
                if cast.summonDemonicTyrant("target") then ui.debug("[Action:Rotation] Summon Demonic Tyrant")
                    return true
                end
            end
        end
        -- Talent Soul Strike
        if not moving and br.useCDs() and talent.soulStrike and wildImps >= 3 and shards < 3 then
            if (dreadstalkersActive or cd.callDreadstalkers.remains() >= gcdMax)
            and (talent.summonVilefiend and (vilefiendActive or cd.summonVilefiend.remains() >= gcdMax) or not talent.summonVilefiend)
            and (talent.grimoireFelguard and (grimoireActive or cd.grimoireFelguard.remains() >= gcdMax) or not talent.grimoireFelguard) then
                if cast.summonDemonicTyrant("target") then ui.debug("[Action:Rotation] Summon Demonic Tyrant (DS)")
                    return true
                end
            end
        end
        -- hotkey
        if br.isChecked("Summon Demonic Tyrant") and br.SpecificToggle("Summon Demonic Tyrant") and not GetCurrentKeyBoardFocus() and not moving then
            if cast.summonDemonicTyrant("target") then br.addonDebug("[Action:Rotation] Summon Demonic Tyrant (Hotkey)") return true end
        end 
        -- cooldowns hotkeys
        if br.SpecificToggle("Cooldowns") 
        --and not GetCurrentKeyBoardFocus() and not moving 
        then
            module.BasicTrinkets()
            if br.isChecked("Racial") and race == "Troll" or race == "Orc" or race == "DarkIronDwarf" then
                if cast.racial("player") then debug("[Action:Rotation] Racial")
                    return true
                end
            end
            if cast.summonDemonicTyrant("target") then br.addonDebug("[Action:Rotation] Summon Demonic Tyrant (Hotkey)") return true end
            if cast.summonVilefiend("target") then br.addonDebug("[Action:Rotation] Summon Vilefiend (Hotkey)") return true end
            if cast.grimoireFelguard("target") then br.addonDebug("[Action:Rotation] Grimoire Felguard (Hotkey)") return true end
            if cast.callDreadstalkers("target") then br.addonDebug("[Action:Rotation] Call Dreadstalkers(Hotkey)") return true end
            if wildImps <= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and (#enemies.yards8t < 2 or mode.rotation == 2) then
                if cast.powerSiphon("target") then ui.debug("[Action:Rotation] Power Siphon (Hotkey)") return true end 
            end
            if cast.soulStrike("target") then ui.debug("[Action:Rotation] Soul Strike") return true end
            
            if buff.demonicCore.exists() and (buff.demonicCore.stack() >= 0 or buff.demonicCore.remain() <= gcdMax * 5.7) then
                if cast.demonbolt("target") then ui.debug("[Action:Implosion] Demonbolt (Proc)") return true end
            end
            if actionList_CovenantSpells() then return end 
        end 
        -- actions+=/power_siphon,if=buff.wild_imps.stack>=2&buff.demonic_core.stack<=2&buff.demonic_power.down&spell_targets.implosion<2
        if wildImps <= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and (#enemies.yards8t < 2 or mode.rotation == 2) then
            if cast.powerSiphon("target") then ui.debug("[Action:Rotation] Power Sipohn")
                return true
            end
        end
        -- actions+=/doom,if=talent.doom.enabled&refreshable&time_to_die>(dot.doom.remains+30)
        if debuff.doom.refresh("target") and ttd("target") > (debuff.doom.remain() + 30) then
            if cast.doom("target") then ui.debug("[Action:Rotation] Doom (Refresh)")
                return true
            end
        end
        -- actions+=/hand_of_guldan,if=soul_shard>=5|(soul_shard>=3&cooldown.call_dreadstalkers.remains>4&(!talent.summon_vilefiend.enabled|cooldown.summon_vilefiend.remains>3))
        if not moving and not cast.last.handOfGuldan(1) and (shards >= 5 or (shards >= 3 and cd.callDreadstalkers.remain() > 4 and (not talent.summonVilefiend or cd.summonVilefiend.remain() > 3))) then
            if cast.handOfGuldan("target") then ui.debug("[Action:Rotation] Hand of Guldan")
                return true
            end
        end
        --actions+=/power_siphon,if=buff.wild_imps.stack>1&buff.demonic_core.stack<3
        if buff.demonicCore.stack() < 3 then
            if cast.powerSiphon() then ui.debug("[Action:Rotation] Power Infusion")
                return true
            end
        end
        -- actions+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
        if shards < 5 and buff.demonicCore.stack() <= 2 and GetPetActionInfo(4) == GetSpellInfo(30213) then
            if cast.soulStrike("target") then ui.debug("[Action:Rotation] Soul Strike")
                return true
            end
        end

        ------------------------------------------------
        -- Covenants (Level 60) ------------------------
        ------------------------------------------------
        if level == 60 and not moving then
            ------------------------------------------------
            -- Impending Catastrophe : Venthyr -------------
            ------------------------------------------------
            if #enemies.yards10t > 1 or br.useCDs() and covenant.venthyr.active and spellUsable(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax then
                if cast.impendingCatastrophe() then br.addonDebug("[Action:Leveling ST] Impending Catastrophe") return true end
            end
            ------------------------------------------------
            -- Impending Catastrophe : Venthyr -------------
            ------------------------------------------------
            --321792
            if covenant.venthyr.active and #enemies.yards10t >= ui.value("Multi-Target Units") and ttd("target") > 7 and spellUsable(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax then
                if cast.impendingCatastrophe() then br.addonDebug("[Action:AOE] Impending Catastrophe") return true end
            end
            --actions.covenant+=/decimating_bolt,if=cooldown.summon_darkglare.remains>5&(debuff.haunt.remains>4|!talent.haunt.enabled)
            ------------------------------------------------
            -- Decimating Bolt : Necrolord -----------------
            ------------------------------------------------
            if covenant.necrolord.active and spellUsable(325289) and select(2,GetSpellCooldown(325289)) <= gcdMax then
                if cast.decimatingBolt() then br.addonDebug("[Action:Rotation] Decimating Bolt") return true end
            end    
            --actions.covenant+=/soul_rot,if=cooldown.summon_darkglare.remains<5|cooldown.summon_darkglare.remains>50|cooldown.summon_darkglare.remains>25&conduit.corrupting_leer.enabled
            ------------------------------------------------
            -- Soul Rot : Night Fae ------------------------
            ------------------------------------------------
            if #enemies.yards40 > 1 or br.useCDs() and covenant.necrolord.active then
                if cast.soulRot("target") then br.addonDebug("[Action:Leveling ST] Soul Rot")  return true end
            end 
            ------------------------------------------------
            -- Soul Rot ------------------------------------
            ------------------------------------------------
            if covenant.nightFae.active and #enemies.yards10t >= ui.value("Multi-Target Units") and ttd("target") > 7 and spellUsable(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax then
                if cast.soulRot() then br.addonDebug("[Action:AoE] Soul Rot") return true end
            end 
            ------------------------------------------------
            -- Scouring Tithe : Kyrian ---------------------
            ------------------------------------------------
            if talent.sacrificedSouls and #enemies.yards10t == 1 and covenant.kyrian.active and spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax then
                if cast.scouringTithe() then br.addonDebug("[Action:Leveling ST] Scouring Tithe") return true end
            else 
                if not talent.sacrificedSouls and #enemies.yards10t < 4 and covenant.kyrian.active and spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax then
                    if cast.scouringTithe() then br.addonDebug("[Action:Leveling ST] Scouring Tithe") return true end
                end
            end
        end
        -- actions+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&((cooldown.summon_demonic_tyrant.remains<10|cooldown.summon_demonic_tyrant.remains>22)|buff.demonic_core.stack>=3|buff.demonic_core.remains<5|time_to_die<25)
        if shards <= 3 and buff.demonicCore.exists() and (cd.summonDemonicTyrant.remain() < 10 or cd.summonDemonicTyrant.remain() > 22 or buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() < 5 or ttd("target") < 25) then
            if cast.demonbolt("target") then ui.debug("[Action:Rotation] Demonbolt (Proc)")
                return true
            end
        end
        -- actions+=/bilescourge_bombers
        if mode.bsb == 1 and mode.rotation ~= 3 then
            if br.getOptionValue("Bilescourge Bombers Target") == 1 then
                if (#enemies.yards8t >= br.getOptionValue("Bilescourge Bombers Units") or (br.isChecked("Ignore Bilescourge Bombers units when using CDs") and br.useCDs())) then
                    if cast.bilescourgeBombers("target", "ground") then ui.debug("[Action:Rotation] Bilescourge Bombers (Ground)")
                        return true
                    end
                end
            else
                if br.isChecked("Ignore Bilescourge Bombers units when using CDs") and br.useCDs() then
                    if cast.bilescourgeBombers("best", false, 1, 8) then ui.debug("[Action:Rotation] Bilescourge Bombers (Ignore Units)")
                        return true
                    end
                else
                    if cast.bilescourgeBombers("best", false, br.getOptionValue("Bilescourge Bombers Units"), 8) then ui.debug("[Action:Rotation] Bilescourge Bombers (Best)")
                        return true
                    end
                end
            end
        end
        -- doom spread
        if talent.doom and mode.rotation ~= 3 and debuff.doom.count() < br.getOptionValue("Multi-Dot Limit") then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if debuff.doom.refresh(thisUnit) then
                    if cast.doom(thisUnit) then ui.debug("[Action:Rotation] Doom Spread")
                        return true
                    end
                end
            end
        end
        -- actions+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end
    end

    local function actionList_CancelCast()
        local spellID = select(9, br._G.UnitCastingInfo("player"))
        if spellID == nil then
            spellID = 0
        end
        if shards >= 5 and spellID == spell.shadowBolt then
            br._G.SpellStopCasting()
            return true 
        elseif shards < 3 and spellID == spell.handOfGuldan and cd.netherPortal.remain() <= 165 then
            br._G.SpellStopCasting()
            return true
        elseif spellID == spell.demonbolt and combatTime > 4 then
            br._G.SpellStopCasting()
            return true
        end
                local mapMythicPlusModeID, mythicPlusLevel, mythicPlustime, mythicPlusOnTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()
        if ui.checked("Soulstone Healer OOC [Mythic+]") and not solo and not moving then
            --if mythicPlusLevel ~= 0 then
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") 
                    and (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER") 
                    and (not buff.soulstone.exists(br.friend[i].unit))
                    and br.timer:useTimer("Healer SS", 3) 
                    then
                        if cast.soulstone(br.friend[i].unit) then
                            br.addonDebug("Soulstone Healer OOC [Mythic+] YEEEEEEEEEEEEEEEEET")
                            return true
                        end
                    end
                end
            --end
        end

    end

    local function actionList_PetControl()
    if br.GetUnitExists("pet")
    and not br.GetUnitIsDeadOrGhost("pet") 
    and not br.GetUnitExists("pettarget")
    and hastar
    and inCombat
    and br.timer:useTimer("Pet Attack Delay",math.random(0.5,2))
    then
       -- PetAssistMode()
        --PetAttack()
        br._G.RunMacroText("/petattack")
    end

    if br.GetUnitExists("pet")
    and not br.GetUnitIsDeadOrGhost("pet")
    and inCombat
    and hastar and not deadtar
    and (br._G.UnitName("pettarget") ~= br._G.UnitName("target")) -- Our pet is not attacking the same unit name as our target. 
    or (br._G.UnitGUID("pettarget") ~= br._G.UnitGUID("target")) -- Our pet is not attackking the same GUID as our target. 
    and br.timer:useTimer("Pet Attack Player Target",math.random(0.1,0.7))
    then
        br._G.RunMacroText("/petattack")
    end
    -- Legion Strike
    if inCombat then
        -- Legion Strike
        if br.GetUnitExists("pettarget")
        and GetPetActionInfo(4) == GetSpellInfo(30213) or GetPetActionInfo(4) == GetSpellInfo(115625) 
        and not br.GetUnitIsDeadOrGhost("pet") 
        then
            br._G.CastSpellByName(GetSpellInfo(30213),"pettarget") 
        end
        -- Firebolt Spam
        if br.GetUnitExists("pettarget")
        and GetPetActionInfo(4) == GetSpellInfo(3110) 
        and not br.GetUnitIsDeadOrGhost("pet") 
        then
            br._G.CastSpellByName(GetSpellInfo(3110),"pettarget") 
        end
        -- Consuming Shadows Spam
        if br.GetUnitExists("pettarget")
        and GetPetActionInfo(4) == GetSpellInfo(3716)
        and not br.GetUnitIsDeadOrGhost("pet") 
        then
            br._G.CastSpellByName(GetSpellInfo(3716),"pettarget") 
        end
        -- Shadow Bite Spam
        if br.GetUnitExists("pettarget")
        and GetPetActionInfo(4) == GetSpellInfo(19505)
        and not br.GetUnitIsDeadOrGhost("pet") 
        then
            br._G.CastSpellByName(GetSpellInfo(54049),"pettarget") 
        end
        -- Whiplash Spam
        if br.GetUnitExists("pettarget")
        and GetPetActionInfo(4) == GetSpellInfo(6360) -- Succubus Active
        and not br.GetUnitIsDeadOrGhost("pet") 
        then
            br._G.CastSpellByName(GetSpellInfo(6360),"pettarget") 
        end
        -- Lash of Pain
        if br.GetUnitExists("pettarget")
        and GetPetActionInfo(6) == GetSpellInfo(7814) -- Succubus Active
        and not br.GetUnitIsDeadOrGhost("pet") 
        then
            br._G.CastSpellByName(GetSpellInfo(7814),"pettarget") 
        end
    end
end

    local function actionList_SummonPet()
        var.summonImp                   = spell.summonImp
        var.summonFelhunter             = spell.summonFelhunter
        var.summonSuccubus              = spell.summonSuccubus
        var.summonFelguard              = spell.summonFelguard
        var.summonDemonicTyrant         = spell.summonDemonicTyrant
        var.summonVilefiend             = spell.summonVilefiend
        var.summonWrathguard            = spell.summonWrathguard
        var.summonCasttime              = select(4,GetSpellInfo(spell.summonFelguard))
        -- Instant resummon pet in torghast. 
        if (GetRealZoneText() == "Torghast, Tower of the Damned" and var.summonCasttime == 0) and not br.GetObjectExists("pet") or br.GetUnitIsDeadOrGhost("pet") then 
            if talent.demonicStrength or talent.soulstrike then
                if cast.summonFelguard("player") then br.addonDebug("Torghast instant re-summon")  return true end 
            else 
                if cast.summonVoidwalker("player") then br.addonDebug("Torghast instant re-summon")  return true end 
            end
        end
        -- Set petPadding var. 
        local petPadding = 2
        -- Our pet's dead, let's dismiss him so we can summon another. 
        if br.GetUnitIsDeadOrGhost("pet") then br._G.RunMacroText("/petdismiss") return end 
        -- Fel demonination summon a new pet in combat. 
        if ui.checked("Fel Domination") and inCombat
        and (not br.GetObjectExists("pet") or br.GetUnitIsDeadOrGhost("pet"))
        and cd.felDomination.remain() <= gcdMax  
        then
            if cast.felDomination() then br.addonDebug("Fel Domination") return true end
        end
        -- Fel domination summon a new pet before our current one dies. 
        if ui.checked("Fel Domination New Pet") and not moving 
        and cd.felDomination.remain() <= gcdMax 
        and br.getHP("pet") <= br.getOptionValue("FelDom Pet HP") 
        and (br.GetObjectExists("pet") == true and not br.GetUnitIsDeadOrGhost("pet"))
        then
            if cast.felDomination() then br.addonDebug("Fel Domination Low Pet Health") return true end
        end
        -- Summon our pet. 
         if br.isChecked("Pet Management") and not (IsFlying() or IsMounted()) and ((not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) or talent.grimoireOfSacrifice and not buff.grimoireOfSacrifice.exists("player")) and level >= 5 and br.timer:useTimer("Summon Pet Delay", br.getOptionValue("Summon Pet Delay")) and not moving then
            if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0)  then
                if HasAttachedGlyph(spell.summonFelguard) then
                    var.summonFelguard = var.summonWrathguard
                end
                if mode.petSummon == 1 and HasAttachedGlyph(spell.summonFelguard) and (lastSpell ~= spell.summonFelguard or activePetId == 0) then
                    if cast.summonFelguard("player") then
                        castSummonId = 58965
                        return
                    end
                elseif mode.petSummon == 1 and (lastSpell ~= spell.summonFelguard or activePetId == 0) then
                    if cast.summonFelguard("player") then
                        castSummonId = spell.summonFelguard
                        return
                    end
                elseif mode.petSummon == 2 and (lastSpell ~= spell.summonImp or activePetId == 0) then
                    if cast.summonImp("player") then
                        castSummonId = spell.summonImp
                        return
                    end
                elseif mode.petSummon == 3 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                    if cast.summonVoidwalker("player") then
                        castSummonId = spell.summonVoidwalker
                        return
                    end
                elseif mode.petSummon == 4 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                    if cast.summonFelhunter("player") then
                        castSummonId = spell.summonFelhunter
                        return
                    end
                elseif mode.petSummon == 5 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                    if cast.summonSuccubus("player") then
                        castSummonId = spell.summonSuccubus
                        return
                    end
                end
            end
        end
    end


    local function actionList_PreCombat()
                local mapMythicPlusModeID, mythicPlusLevel, mythicPlustime, mythicPlusOnTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()
        if ui.checked("Soulstone Healer OOC [Mythic+]") and not solo and not moving then
            --if mythicPlusLevel ~= 0 then
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") 
                    and (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER") 
                    and (not buff.soulstone.exists(br.friend[i].unit))
                    and br.timer:useTimer("Healer SS", 3) 
                    then
                        if cast.soulstone(br.friend[i].unit) then
                            br.addonDebug("Soulstone Healer OOC [Mythic+] YEEEEEEEEEEEEEEEEET")
                            return true
                        end
                    end
                end
            --end
        end
        -- Auto Mythic+ Keystone | Module
        var.mapID = C_ChallengeMode.GetActiveChallengeMapID();
        if not inCombat and not (IsFlying() or IsMounted()) and not solo then
            if var.activeMythicMapID then
                module.autoKeystone()
            end
        end
        

        -- Create Healthstone
        if not moving and not inCombat and ui.checked("Create Healthstone") then
            if GetItemCount(5512) < 1 and br.timer:useTimer("CH", 5) then
                if cast.createHealthstone() then br.addonDebug("Casting Create Healthstone" ) return true end
            end
        end
        if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask
            -- flask,type=whispered_pact
            -- Flask
            module.FlaskUp("Intellect")
            -- Food
            -- food,type=azshari_salad
            if br.useCDs() and br.isChecked("Pre-Pull Logic") and br.GetObjectExists("target") and br.getDistance("target") < 40 then
                local demonboltExecute = cast.time.demonbolt()
                if pullTimer <= demonboltExecute then
                    if br.isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
                        use.battlePotionOfIntellect()
                    end
                    if ppDb == false then
                        if cast.demonbolt("target") then
                            ppDb = true
                            return true
                        end
                    end
                end
            end -- End Pre-Pull
            if br.isValidUnit("target") and br.getDistance("target") < 40 and inCombat then
                -- actions.precombat+=/demonbolt (we use SB if no buff)
                if buff.demonicCore.exists() then 
                    if cast.demonbolt("target") then return true end 
                end
                -- Shadow Bolt
                if cast.shadowBolt("target") then return true end
            end
        end -- End No Combat
    end -- End Action List - PreCombat

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and br.profileStop == true or  br.SpecificToggle("Pause Mode") then
        br.profileStop = false
    elseif inCombat and br._G.IsAoEPending() then
        br._G.SpellStopTargeting()
        br.addonDebug("Canceling Spell")
        return false
    elseif (inCombat and br.profileStop == true) or UnitIsAFK("player") or IsMounted() or IsFlying() or br.pause(true) or mode.rotation ==4 then
        if not br.pause(true) and IsPetAttackActive() and br.isChecked("Pet Management") then
            br._G.PetStopAttack()
            br._G.PetFollow()
        end
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList_Extras() then return end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            if actionList_Defensive() then return end
        end

        if inCombat then
            if buff.demonicCore.exists() then
                if cast.demonbolt("target") then ui.debug("aDemonbolt")
                    return true
                end
            end
            -------------------
            --- Pet Control ---
            -------------------
            if ui.checked("Pet Management") 
            and hastar 
            and br._G.UnitCanAttack("target", "player") 
            and not br.GetUnitIsDeadOrGhost("target") 
            and br.getLineOfSight("player","target") 
            then
                if actionList_PetControl() then return end
            end

            -- Our pet's dead, let's dismiss him so we can summon another. 
            if br.GetUnitIsDeadOrGhost("pet") then br._G.RunMacroText("/petdismiss") return end 

            -- Fel demonination summon a new pet in combat. 
            if ui.checked("Fel Domination") and inCombat

            and (not br.GetObjectExists("pet") or br.GetUnitIsDeadOrGhost("pet"))
            and cd.felDomination.remain() <= gcdMax  
            then
                if cast.felDomination() then br.addonDebug("Fel Domination") return true end
            end
        end


        -- Fel domination summon a new pet before our current one dies. 
        if ui.checked("Fel Domination New Pet") and not moving 
        and cd.felDomination.remain() <= gcdMax 
        and br.getHP("pet") <= br.getOptionValue("FelDom Pet HP") 
        and (br.GetObjectExists("pet") == true and not br.GetUnitIsDeadOrGhost("pet"))
        then
            if cast.felDomination() then br.addonDebug("Fel Domination Low Pet Health") return true end
        end

        local mapMythicPlusModeID, mythicPlusLevel, mythicPlustime, mythicPlusOnTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()
        if ui.checked("Soulstone Healer OOC [Mythic+]") and not solo and not moving then
            --if mythicPlusLevel ~= 0 then
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") 
                    and (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER") 
                    and (not buff.soulstone.exists(br.friend[i].unit))
                    and br.timer:useTimer("Healer SS", 3) 
                    then
                        if cast.soulstone(br.friend[i].unit) then
                            br.addonDebug("Soulstone Healer OOC [Mythic+] YEEEEEEEEEEEEEEEEET")
                            return true
                        end
                    end
                end
            --end
        end
        -- Auto Mythic+ Keystone | Module
        var.mapID = C_ChallengeMode.GetActiveChallengeMapID();
        if not inCombat and not (IsFlying() or IsMounted()) and not solo then
            if var.activeMythicMapID then
                module.autoKeystone()
            end
        end
        

        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList_PreCombat() then return end
        -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
        if (not inCombat and not moving) or buff.felDomination.exists() then if actionList_SummonPet() then return end 
            br.ChatOverlay("Summon Pet")
            return true 
        elseif inCombat and moving and buff.felDomination.exists() then 
            if actionList_SummonPet() then return end
        end
        -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
        if talent.grimoireOfSacrifice and br.isChecked("Pet Management") and br.GetObjectExists("pet") and not br.GetUnitIsDeadOrGhost("pet") then
            if cast.grimoireOfSacrifice() then
                return
            end
        end
         if actionList_CancelCast() then return end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and br.profileStop == false and br.isValidUnit("target") and br.getDistance("target") < 40 then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then return end   
            -- Send a chat overlay message about pausing queuecast.       
            if br.queueSpell then
                br.ChatOverlay("Pausing for queuecast")
                return true 
            end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if br.getOptionValue("APL Mode") == 1 and not br.pause() then
                -- rotation
                if actionList_Rotation() then return end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End Timer
-- end -- End runRotation
local id = 266
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

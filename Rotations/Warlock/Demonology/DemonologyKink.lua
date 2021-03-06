local rotationName = "KinkySpirit"
local versionNum = "1.3.5"
local colorPurple = "|cff8788EE"
local colorOrange    = "|cffb28cc7"								   
local dreadstalkersActive, vilefiendActive, grimoireActive = false, false, false
local dreadstalkersTime, vilefiendTime, grimoireTime, ppDb, castSummonId, opener, summonTime
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
    br.ui:createToggle("Rotation", 1, 0)
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
    br.ui:createToggle("Cooldown", 2, 0)
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
    br.ui:createToggle("Defensive", 3, 0)
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
    br.ui:createToggle("Interrupt", 4, 0)
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
    br.ui:createToggle("BSB", 3, 1)
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
    br.ui:createToggle("GF", 4, 1)
    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Felguard", tip = "Summon Felguard", highlight = 1, icon = br.player.spell.summonFelguard },
        [2] = { mode = "2", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [3] = { mode = "3", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [4] = { mode = "4", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter", highlight = 1, icon = br.player.spell.summonFelhunter },
        [5] = { mode = "5", value = 4 , overlay = "Succubus", tip = "Summon Succubus", highlight = 1, icon = br.player.spell.summonSuccubus },
        [6] = { mode = "None", value = 5 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.conflagrate }
    };
    br.ui:createToggle("PetSummon",1,1)

    -- Burning Rush button
    local BurningRushModes = {
        [1] = { mode = "On", value = 1 , overlay = "Burning Rush Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.burningRush},
        [2] = { mode = "Off", value = 2 , overlay = "Burning Rush Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.burningRush}
    };
    br.ui:createToggle("BurningRush",2,1)

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
        section = br.ui:createSection(br.ui.window.profile, "Demonology " .. ".:|:. " .. " General " .. "Ver " ..colorOrange .. versionNum .. colorPurple .." .:|:.")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffb28cc7SimC"}, 1, "|cffb28cc7Set APL Mode to use.")
		-- Multi-Target Units
		br.ui:createSpinnerWithout(section, "Multi-Target Units", 3, 1, 25, 1, "|cffb28cc7Number of Targets to use Covenant at.")        
		-- Burning Rush Health Cancel Percent
		br.ui:createSpinnerWithout(section, "Burning Rush Health", 79, 1, 100, 1, "|cffb28cc7Health Percentage to cancel at.")
		-- Dummy DPS Test
		br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffb28cc7Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
		-- Pre-Pull Timer
		br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffb28cc7Will precast demonbolt on pull if pulltimer is active")
		-- Corruption Torghast
        br.ui:createCheckbox(section,"Instant Corruption Torghast")
        -- Curse Of Tongues Torghast
        br.ui:createCheckbox(section,"Curse of Tongues Torghast")

		-- Pet Management
        br.ui:createCheckbox(section, "Pet Management", "|cffb28cc7 Select to enable/disable auto pet management")
        
        -- Fel Domination on low pet health
        br.ui:createCheckbox(section, "Fel Domination New Pet", "|cffFFBB00 Toggle the auto casting of Fel Donmination when your pet is low health.")
        -- Pet Summon 
        br.ui:createSpinnerWithout(section, "FelDom Pet HP", 8, 1, 100, 0.1, "|cffFFBB00Health percent of your pet to cast Fel Domination and re-summon your pet.")
		-- Summon Pet
		--br.ui:createDropdownWithout(section, "Summon Pet", {"|cffb28cc7Felguard", "|cffb28cc7Imp", "|cffb28cc7Voidwalker", "|cffb28cc7Felhunter", "|cffb28cc7Succubus", "|cffb28cc7None"}, 1, "|cffb28cc7Select default pet to summon.")
		-- Life Tap
		br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffb28cc7HP Limit that Life Tap will not cast below.")
		-- No Dot units
		br.ui:createCheckbox(section, "Dot Blacklist", "|cffb28cc7 Check to ignore certain units for dots")
		-- Auto target
		br.ui:createCheckbox(section, "Auto Target", "|cffb28cc7 Will auto change to a new target, if current target is dead")
		-- Implosion Unit
        br.ui:createSpinnerWithout(section, "Implosion Units", 2, 1, 10, 1, "|cffb28cc7Minimum units to cast Implosion")
		-- Implosion ST
		br.ui:createCheckbox(section, "Implosion ST", "|cffb28cc7 Will cast Implosion on ST.")
        
		-- Multi-Dot Limit
		br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 7, 1, 10, 1, "|cffb28cc7Unit Count Limit that DoTs will be cast on.")
		-- Bilescourge Bombers Target
		br.ui:createDropdownWithout(section, "Bilescourge Bombers Target", {"|cffb28cc7Target", "|cffb28cc7Best"}, 2, "|cffb28cc7Bilescourge Bombers target")
		-- Bilescourge Bombers Unit
		br.ui:createSpinnerWithout(section, "Bilescourge Bombers Units", 3, 1, 10, 1, "|cffb28cc7Minimum units to cast Bilescourge Bombers")
        br.ui:checkSectionState(section)
        -------------------------
		---- HOTKEYS OPTIONS ----
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Hotkeys")
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

    units.get(40)
    enemies.get(8, "target")
    enemies.get(10, "target")
    enemies.get(30)
    enemies.get(40)

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

    local coeUnits = {}
    for i in string.gmatch(br.getOptionValue("Exhaustion Units"), "%d+") do
        coeUnits[tonumber(i)] = true
    end

    local function isExhaust(unit)
        if br.isChecked("Curse of Exhaustion") and exhaustionCount < ui.value("Curse of Exhaustion") and coeUnits[br.GetObjectID(unit)] then return true end 
        return false
    end

    local noTouchUnits = {}
    for i in string.gmatch(br.getOptionValue("No Touch Blacklist Units"), "%d+") do
        noTouchUnits[tonumber(i)] = true
    end

    local function noDotCheck(unit)
        if mode.dbl ~= 2 then
            if br.isChecked("No Touch Blacklist") and (noTouchUnits[br.GetObjectID(unit)] or br._G.UnitIsCharmed(unit)) then
                return true
            end
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
        if br._G.UnitInPhase(unit) then
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
        if br.isChecked("Auto Target") and inCombat and #enemyTable40 > 0 and ((br.GetUnitExists("target") and br.GetUnitIsDeadOrGhost("target") and not br.GetUnitIsUnit(enemyTable40[1].unit, "target")) or not br.GetUnitExists("target")) then
            br._G.TargetUnit(enemyTable40[1].unit)
        end
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
                    -- actions.implosion+=/summon_demonic_tyrant
            if not moving then
                if cast.summonDemonicTyrant("target") then ui.debug("[Action:Implosion] Summon Demonic Tyrant")
                    return true
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
        

        -- actions.nether_portal_building=nether_portal,if=so
        if not moving and shards >= 5 and (not talent.powerSiphon or buff.demonicCore.exists()) then
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

    local function actionList_NetherPortalActive()
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
        if shards == 1 and (cd.callDreadstalkers.remain() < cast.time.shadowBolt() or (talent.bilescourgeBombers and cd.bilescourgeBombers.remain() < cast.time.shadowBolt())) then
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
            if cast.demonbolt("target") then ui.debug("[Action:PortalActive] Demonbolt")
                return true
            end
        end
        -- actions.nether_portal_active+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
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

                local casttime = select(4,GetSpellInfo(172))
        
        -- actions.implosion=implosion,if=(buff.wild_imps.stack>=6&(soul_shard<3|prev_gcd.1.call_dreadstalkers|buff.wild_imps.stack>=9|prev_gcd.1.bilescourge_bombers|(!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan))&!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan&buff.demonic_power.down)|(time_to_die<3&buff.wild_imps.stack>0)|(prev_gcd.2.call_dreadstalkers&buff.wild_imps.stack>2&!talent.demonic_calling.enabled)
        if (wildImps >= 6 and (shards < 3 or cast.last.callDreadstalkers(1) or wildImps >= 9 or cast.last.bilescourgeBombers(1) or (not cast.last.handOfGuldan(1) or not cast.last.handOfGuldan(2))) and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) and br.botSpell ~= spell.implosion and not buff.demonicPower.exists()) or (ttd("target") < 3 and wildImps > 0 and br.useCDs()) or (cast.last.callDreadstalkers(2) and wildImps > 2 and not talent.demonicCalling) then
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
        if talent.doom and debuff.doom.count() < br.getOptionValue("Multi-Dot Limit") then
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

    local function actionList_DPS()
        -- # Executed every time the actor is available.
        -- actions=call_action_list,name=off_gcd
        -- actions+=/run_action_list,name=tyrant_prep,if=cooldown.summon_demonic_tyrant.remains<4&!variable.tyrant_ready
        -- actions+=/run_action_list,name=summon_tyrant,if=variable.tyrant_ready
        -- actions+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>40|time_to_die<cooldown.summon_demonic_tyrant.remains+25
        -- actions+=/call_dreadstalkers
        -- actions+=/doom,if=refreshable
        -- actions+=/demonic_strength
        -- actions+=/bilescourge_bombers
        
        -- actions+=/implosion,if=active_enemies>1&!talent.sacrificed_souls.enabled&buff.wild_imps.stack>=8&buff.tyrant.down&cooldown.summon_demonic_tyrant.remains>5
       
        -- actions+=/implosion,if=active_enemies>2&buff.wild_imps.stack>=8&buff.tyrant.down
       
        -- actions+=/hand_of_guldan,if=soul_shard=5|buff.nether_portal.up
       
        -- actions+=/hand_of_guldan,if=soul_shard>=3&cooldown.summon_demonic_tyrant.remains>20&(cooldown.summon_vilefiend.remains>5|!talent.summon_vilefiend.enabled)&cooldown.call_dreadstalkers.remains>2
       
        -- actions+=/call_action_list,name=covenant,if=(covenant.necrolord|covenant.night_fae)&!talent.nether_portal.enabled
      
        -- actions+=/demonbolt,if=buff.demonic_core.react&soul_shard<4
      

        -- actions+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains+cooldown.summon_demonic_tyrant.duration>time_to_die|time_to_die<cooldown.summon_demonic_tyrant.remains+15
      
        -- actions+=/use_items

        -- actions+=/power_siphon,if=buff.wild_imps.stack>1&buff.demonic_core.stack<3

        -- actions+=/soul_strike

        -- actions+=/call_action_list,name=covenant

        -- actions+=/shadow_bolt
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
                if cast.impendingCatastrophe() then br.addonDebug("[Action:Rotation] Impending Catastrophe") return true end
            end
            ------------------------------------------------
            -- Impending Catastrophe : Venthyr -------------
            ------------------------------------------------
            if covenant.venthyr.active and spellUsable(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax then
                if cast.impendingCatastrophe() then br.addonDebug("[Action:AOE] Impending Catastrophe") return true end
            end
            ------------------------------------------------
            -- Decimating Bolt : Necrolord -----------------
            ------------------------------------------------
            -- actions.covenant+=/decimating_bolt
            if covenant.necrolord.active and spellUsable(325289) and select(2,GetSpellCooldown(325289)) <= gcdMax then
                if cast.decimatingBolt() then br.addonDebug("[Action:Rotation] Decimating Bolt") return true end
            end    
            ------------------------------------------------
            -- Soul Rot : Night Fae ------------------------
            ------------------------------------------------
            -- actions.covenant+=/scouring_tithe,if=!talent.sacrificed_souls.enabled&active_enemies<4
            if covenant.nightFae.active and spellUsable(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax and ttd("target") > 8
            and br.useCDs() and #enemies.yards10t > 1 then
                if cast.soulRot() then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end
            ------------------------------------------------
            -- Soul Rot ------------------------------------
            ------------------------------------------------
            if covenant.nightFae.active and ttd("target") > 8 and spellUsable(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax then
                if cast.soulRot() then br.addonDebug("[Action:AoE] Soul Rot") return true end
            end 
            ------------------------------------------------
            -- Scouring Tithe : Kyrian ---------------------
            ------------------------------------------------
            -- actions.covenant+=/scouring_tithe,if=talent.sacrificed_souls.enabled&active_enemies=1
            if covenant.kyrian.active and spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax
            and (talent.sacrificedSouls and #enemies.yards10t == 1) then
                if cast.scouringTithe() then br.addonDebug("[Action:Rotation] Scouring Tithe") return true end
            end
            -- actions.covenant+=/scouring_tithe,if=!talent.sacrificed_souls.enabled&active_enemies<4
            if covenant.kyrian.active and spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax
            and (not talent.sacrificedSouls and #enemies.yards10t < 4) then
                if cast.scouringTithe() then br.addonDebug("[Action:Rotation] Scouring Tithe") return true end
            end
        end
    end

    local function actionList_OffGCD()
        if spellQueueReady() then
            if activePet then
                -- actions.off_gcd+=/blood_fury,if=pet.demonic_tyrant.active
                 -- actions.off_gcd+=/fireblood,if=pet.demonic_tyrant.active
                -- actions.off_gcd=berserking,if=pet.demonic_tyrant.active
                if br.isChecked("Racial") and race == "Troll" or race == "Orc" or race == "DarkIronDwarf" then
                   if cast.racial("player") then debug("[Action:Dark Glare Prep] Racial") return true end
                end

            end
            -- actions.off_gcd+=/potion,if=buff.berserking.up|pet.demonic_tyrant.active&!race.troll
        end
    end

    local function actionList_TyrantPrep()
        if spellQueueReady() then
            -- actions.tyrant_prep=doom,line_cd=30
            if not debuff.doom.exists("target") or debuff.doom.refresh("target") and ttd("target") > 30 and (#enemies.yards8t < 2 or mode.rotation == 3) and Line_cd(spell.doom,30) then
                if cast.doom("target") then ui.debug("[Action:Rotation] Doom (3)")
                    return true
                end
            end
            -- actions.tyrant_prep+=/nether_portal
            if talent.netherPortal and br.useCDs() and (#enemies.yards8t <= 2 or mode.rotation == 3) then
                if actionList_NetherPortal() then return end
            end
            -- actions.tyrant_prep+=/grimoire_felguard
            if mode.gf == 1 and br.useCDs() then
                if cast.grimoireFelguard("target") then ui.debug("[Action:Tyrant Prep] Grimoire Felguard")
                    return true
                end
            end
            -- actions.tyrant_prep+=/summon_vilefiend
            if not moving and br.useCDs() 
            --and (cd.summonDemonicTyrant.remain() > 40 or cd.summonDemonicTyrant.remain() < 12) 
            then
                if cast.summonVilefiend("target") then ui.debug("[Action:Tyrant Prep] Summon Vilefiend")
                    return true
                end
            end 
            -- actions.tyrant_prep+=/call_dreadstalkers
            if cast.callDreadstalkers("target") then ui.debug("[Action:Tyrant Prep] Call Dreadstalkers") return true end
            -- actions.tyrant_prep+=/demonbolt,if=buff.demonic_core.up&soul_shard<4&(talent.demonic_consumption.enabled|buff.nether_portal.down)
            if buff.demonicCore.react() and shards < 4 and (talent.demonicConsumption or not buff.netherPortal.react()) then
                if cast.demonbolt("target") then ui.debug("[Action:Tyrant Prep] Demonbolt") return true end 
            end
            -- actions.tyrant_prep+=/soul_strike,if=soul_shard<5-4*buff.nether_portal.up
            if shards < 5-4 * buff.netherPortal.remains() then
                 if cast.shadowBolt("target") then ui.debug("[Action:Tyrant Prep] Shadow Bolt") return true end 
            end
            -- actions.tyrant_prep+=/shadow_bolt,if=soul_shard<5-4*buff.nether_portal.up
            if not moving and shards < 5-4 * buff.netherPortal.remains() then
                 if cast.shadowBolt("target") then ui.debug("[Action:Tyrant Prep] Shadow Bolt") return true end 
            end
            -- actions.tyrant_prep+=/variable,name=tyrant_ready,value=1
            var.tyrant_ready = 1
            -- actions.tyrant_prep+=/hand_of_guldan
            if not moving and shards >= 2 then
                if cast.handOfGuldan("target") then ui.debug("[Action:Tyrant Prep] HoG") return true end 
            end
        end
    end

    local function actionList_SummonTyrant()
        if spellQueueReady() then 
            -- actions.summon_tyrant=hand_of_guldan,if=soul_shard=5,line_cd=20
            if not moving and shards >= 5 and Line_cd(spell.handOfGuldan,20) and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) then
                if cast.handOfGuldan("target") then ui.debug("[Action:Summon Tyrant] Demonbolt (DC, No NP, Line CD, 20) (1)")return true end 
            end 
            -- actions.summon_tyrant+=/demonbolt,if=buff.demonic_core.up&(talent.demonic_consumption.enabled|buff.nether_portal.down),line_cd=20
            if buff.demonicCore.react() and (talent.demonicConsumption or not buff.netherPortal.react()) and Line_cd(spell.demonbolt,20) then
                if cast.demonbolt("target") then ui.debug("[Action:Summon Tyrant] Demonbolt (DC, No NP, Line CD, 20) (2)")return true end 
            end
            -- actions.summon_tyrant+=/shadow_bolt,if=buff.wild_imps.stack+incoming_imps<4&(talent.demonic_consumption.enabled|buff.nether_portal.down),line_cd=20
            if not moving and shards < 5 and wildImps < 4 and (talent.demonicConsumption or not buff.netherPortal.react()) and Line_cd(spell.shadowBolt,20) then
                if cast.shadowBolt("target") then ui.debug("[Action:Summon Tyrant] Shadow Bolt (Line CD, 20) (3)")return true end 
            end
            -- actions.summon_tyrant+=/call_dreadstalkers
            if not moving and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14) then
                if cast.callDreadstalkers("target") then ui.debug("[Action:Summon Tyrant] Call Dreadstalkers (4)") return true end
            end
            -- actions.summon_tyrant+=/hand_of_guldan
            if not moving and shards >= 2 then
                if cast.handOfGuldan("target") then ui.debug("[Action:Summon Tyrant] HoG (5)") return true end 
            end
            -- actions.summon_tyrant+=/demonbolt,if=buff.demonic_core.up&buff.nether_portal.up&((buff.vilefiend.remains>5|!talent.summon_vilefiend.enabled)&(buff.grimoire_felguard.remains>5|buff.grimoire_felguard.down))
            if buff.demonicCore.react() and buff.netherPortal.react()
            and ((vilefiendRemain > 5 or not talent.summonVilefiend) and (grimoireRemain > 5 or not grimoireActive)) 
            then
                if cast.demonbolt("target") then ui.debug("[Action:Summon Tyrant] Demonbolt (Demonic Core/Nether Portal) (6)") return true end 
            end
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- Soul Strike -.:|:.-----.:|:.-----.:|:.-----
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- actions.summon_tyrant+=/soul_strike,if=buff.nether_portal.up&((buff.vilefiend.remains>5|!talent.summon_vilefiend.enabled)&(buff.grimoire_felguard.remains>5|buff.grimoire_felguard.down))
            var.felguardSpell = 30213 
            var.wrathguardSpell = 115625
            if talent.soulstrike
            and br.GetUnitExists("pettarget")
            and GetPetActionInfo(4) == GetSpellInfo(var.felguardSpell) or GetPetActionInfo(4) == GetSpellInfo(115625) 
            and not br.GetUnitIsDeadOrGhost("pet")
            and buff.netherPortal.react()
            and ((vilefiendRemain > 5 or not talent.summonVilefiend) and (grimoireRemain > 5 or not grimoireActive)) 
            then 
                if cast.soulStrike("target") then ui.debug("[Action:Summon Tyrant] Soul Strike (Nether Portal) (7)") return true end 
            end
            -- actions.summon_tyrant+=/shadow_bolt,if=buff.nether_portal.up&((buff.vilefiend.remains>5|!talent.summon_vilefiend.enabled)&(buff.grimoire_felguard.remains>5|buff.grimoire_felguard.down))
            if buff.netherPortal.react() and not moving 
            and ((vilefiendRemain > 5 or not talent.summonVilefiend) and (grimoireRemain > 5 or not grimoireActive)) 
            then
                if cast.shadowBolt("target") then ui.debug("[Action:Summon Tyrant] Shadow Bolt (Nether Portal) (8)") return true end 
            end
            -- actions.summon_tyrant+=/variable,name=tyrant_ready,value=!cooldown.summon_demonic_tyrant.ready
            var.tyrant_ready = not cd.summonDemonicTyrant.ready()
            -- actions.summon_tyrant+=/summon_demonic_tyrant
            if not moving and br.useCDs() then
                 if cast.summonDemonicTyrant("target") then ui.debug("[Action:Summon Tyrant] Summon Demonic Tyrant (9)")
                    return true
                end
            end
            -- actions.summon_tyrant+=/shadow_bolt
            if not moving and shards < 5 then
                if cast.shadowBolt("target") then ui.debug("[Action:Summon Tyrant] Shadow Bolt (10)") return true end 
           end 
        end
    end

    local function actionList_Rotation()
        if spellQueueReady() then
            -- actions=call_action_list,name=off_gcd
            if actionList_OffGCD() then return end 
            -- actions+=/run_action_list,name=tyrant_prep,if=cooldown.summon_demonic_tyrant.remains<4&!variable.tyrant_ready
            if cd.summonDemonicTyrant.remains() < 4 then
                if actionList_TyrantPrep() then return end 
            end
            -- actions+=/run_action_list,name=summon_tyrant,if=variable.tyrant_ready 
            if cd.summonDemonicTyrant.remains() < 4 then 
                if actionList_SummonTyrant() then return end 
            end 
            -- actions+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>40|time_to_die<cooldown.summon_demonic_tyrant.remains+25
            if not moving and br.useCDs() and (cd.summonDemonicTyrant.remain() > 40 or ttd("target") < cd.summonDemonicTyrant.remain() + 25) then
                if cast.summonVilefiend("target") then ui.debug("[Action:Rotation] Summon Vilefien (1)")
                    return true
                end
            end
            -- actions+=/call_dreadstalkers
            if not moving 
            and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14) 
            then
                if cast.callDreadstalkers("target") then ui.debug("[Action:Rotation] Call Dreadstalkers (2)")
                    return true
                end
            end
            -- actions+=/doom,if=refreshable
            if not debuff.doom.exists("target") or debuff.doom.refresh("target") and ttd("target") > 30 and (#enemies.yards8t < 2 or mode.rotation == 3) then
                if cast.doom("target") then ui.debug("[Action:Rotation] Doom (3)")
                    return true
                end
            end
            -- actions+=/demonic_strength
            if felguardActive and br.botSpell ~= spell.demonicStrength and br.useCDs() or (#enemies.yards8t < 2 or mode.rotation == 3) then
                if cast.demonicStrength("target") then ui.debug("[Action:Rotation] Demonic Strength (4)")
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
            -- actions+=/implosion,if=active_enemies>1&!talent.sacrificed_souls.enabled&buff.wild_imps.stack>=8&buff.tyrant.down&cooldown.summon_demonic_tyrant.remains>5
            if br.isChecked("Implosion ST") and (#enemies.yards10t > 1 or mode.rotation == 3)
            and not talent.sacrificedSouls 
            and wildImps >= 8
            and not tyrantActive
            and cd.summonDemonicTyrant > 5 
            then
                if cast.implosion("target") then ui.debug("[Action:Rotation] Implosion (Wild Imps >= 8) (5)")
                    return true 
                end 
            end
            --if #enemies.yards10t > 1 and not talent.sacrificedSouls and wildImps >= 8 and 
            -- actions+=/implosion,if=active_enemies>2&buff.wild_imps.stack>=8&buff.tyrant.down
            if br.isChecked("Implosion ST") and (#enemies.yards10t > 2 or mode.rotation == 3)  
            and wildImps >= 8
            and not tyrantActive
            then
                if cast.implosion("target") then ui.debug("[Action:Rotation] Implosion (Wild Imps >= 8) (6)")
                    return true
                end
            end
            -- actions+=/hand_of_guldan,if=soul_shard=5|buff.nether_portal.up
            if shards >= 5 and buff.netherPortal.react() 
            or not talent.netherPortal 
            and not moving
            then
                if cast.handOfGuldan("target") then ui.debug("[Action:Rotation] HoG (Shards>=5&BuffNetherPortal or not talented) (7)") return true end
            end
            -- actions+=/hand_of_guldan,if=soul_shard>=3&cooldown.summon_demonic_tyrant.remains>20&(cooldown.summon_vilefiend.remains>5|!talent.summon_vilefiend.enabled)&cooldown.call_dreadstalkers.remains>2
            if shards >= 3 and cd.summonDemonicTyrant.remains() > 20 
            and (cd.summonVilefiend.remains() > 5 or not talent.summonVilefiend) 
            and cd.callDreadstalkers.remains() > 2 
            and not moving and not cast.last.handOfGuldan(1)
            then
                if cast.handOfGuldan("target") then ui.debug("[Action:Rotation] HoG (Shards>=3&TyrantCD>20&VileCD>5&Stalkers>2) (8)") return true end 
            end 
           -- if not moving and not cast.last.handOfGuldan(1) and (shards >= 5 or (shards >= 3 and cd.callDreadstalkers.remain() > 4 and (not talent.summonVilefiend or cd.summonVilefiend.remain() > 3))) then
          --      if cast.handOfGuldan("target") then ui.debug("[Action:Rotation] Hand of Guldan")
            --        return true
           --     end
         --   end
            -- actions+=/call_action_list,name=covenant,if=(covenant.necrolord|covenant.night_fae)&!talent.nether_portal.enabled
            if (covenant.necrolord.active or covenant.nightFae.active) and not talent.netherPortal then
                if actionList_CovenantSpells() then return end 
            end
            -- actions+=/demonbolt,if=buff.demonic_core.react&soul_shard<4
            if shards < 4 and buff.demonicCore.react() then
                if cast.demonbolt("target") then ui.debug("[Action:Rotation] Demonbolt (Demonic Core, Shards < 4) (9)") return true end 
            end
            -- actions+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains+cooldown.summon_demonic_tyrant.duration>time_to_die|time_to_die<cooldown.summon_demonic_tyrant.remains+15
            if mode.gf == 1 and br.useCDs() and (cd.summonDemonicTyrant.remains() + cd.summonDemonicTyrant.duration() > ttd("target") or ttd("target") < cd.summonDemonicTyrant.remains() + 15)then
                if cast.grimoireFelguard("target") then ui.debug("[Action:Rotation] Grimoire Felguard (9)")
                    return true
                end 
            end
            -- actions+=/use_items
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- Power Siphon .:|:.-----.:|:.-----.:|:.-----
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- actions+=/power_siphon,if=buff.wild_imps.stack>1&buff.demonic_core.stack<3
            if wildImps > 1 and buff.demonicCore.stack() < 3 then
                if cast.powerSiphon() then ui.debug("[Action:Rotation] Power Infusion (10)") return true end 
            end
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- Soul Strike -.:|:.-----.:|:.-----.:|:.-----
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            var.felguardSpell = 30213 
            var.wrathguardSpell = 115625
            -- actions+=/soul_strike
            if talent.soulstrike
            and br.GetUnitExists("pettarget")
            and GetPetActionInfo(4) == GetSpellInfo(var.felguardSpell) or GetPetActionInfo(4) == GetSpellInfo(115625) 
            and not br.GetUnitIsDeadOrGhost("pet")
            then 
                if cast.soulStrike("target") then ui.debug("[Action:Rotation] Soul Strike (11)") return true end 
            end  
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- Covenant APL .:|:.-----.:|:.-----.:|:.-----
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- actions+=/call_action_list,name=covenant
            if actionList_CovenantSpells() then return end 

            -- actions+=/shadow_bolt
            if not moving and shards < 5 then if cast.shadowBolt("target") then ui.debug("[Action:Rotation] Shadow Bolt (12)") return true end end 

          --  if br.useCDs() then if actionList_Cooldowns() then return end end
            
            var.DisembodiedTongue = br.UnitBuffID("player", 322455)
            -- Instant Corruption | Torghast
            if (GetRealZoneText() == "Torghast, Tower of the Damned" and var.DisembodiedTongue or var.DisembodiedTongueLearned == true) then 
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if debuff.curseOfTongues.refresh(thisUnit) then
                        if cast.curseOfTongues(thisUnit) then ui.debug("[Action:Rotation] Torghast Tongues (Spreading) (13)")
                            var.DisembodiedTongueLearned = true 
                            return true
                        end
                     end
                end   
            end
            -- Spread Tongues | Torghast
            var.casttime = select(4,GetSpellInfo(172))
            if br.isChecked("Instant Corruption Torghast") and (GetRealZoneText() == "Torghast, Tower of the Damned" and var.casttime == 0) and debuff.corruption.count() < br.getOptionValue("Multi-Dot Limit") then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if debuff.corruption.refresh(thisUnit) then
                        if cast.corruption(thisUnit) then ui.debug("[Action:Rotation] Torghast Corruption (Spreading) (14)")
                            return true
                        end
                    end
                end
            end 
        end -- End Spell Queue Ready
    end -- End Rotation | APL

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
        if br.isChecked("Pet Management") and not (IsFlying() or IsMounted()) or (buff.demonicPower.exists()) and level >= 5 and br.timer:useTimer("summonPet",math.random(1.5,2.5)) then
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
            if br.isValidUnit("target") and br.getDistance("target") < 40 then
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
    if not inCombat and not hastar and br.profileStop == true then
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
        -------------------
        --- Pet Control ---
        -------------------
        if actionList_PetControl() then return end
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
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        --br.getFacing("player","target") == true 
        if inCombat and br.profileStop == false and br.isValidUnit("target") and br.getDistance("target") < 40 and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            if actionList_CancelCast() then return end
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
                if actionList_Rotation() then 
                    return 
                end
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

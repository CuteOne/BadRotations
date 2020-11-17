local rotationName = "Kink"
local rotationVer  = "v1.4.7"
local dsInterrupt = false
----------------------------------------------------
-- Credit to Aura for this rotation's base.
----------------------------------------------------

----------------------------------------------------
-- Credit and huge thanks to:
----------------------------------------------------
--[[

Damply#3489

.G.#1338 

Netpunk | Ben#7486 


--]]

----------------------------------------------------
-- on Discord!
----------------------------------------------------

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.agony},
        -- [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        -- [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonDarkglare},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.summonDarkglare},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonDarkglare}
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.fear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.fear}
    };
    CreateButton("Interrupt",4,0)
    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "3", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter", highlight = 1, icon = br.player.spell.summonFelhunter },
        [4] = { mode = "4", value = 4 , overlay = "Succubus", tip = "Summon Succubus", highlight = 1, icon = br.player.spell.summonSuccubus },
        [5] = { mode = "None", value = 5 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.conflagrate }
    };
    CreateButton("PetSummon",5,0)
    -- Single Target Focus
    SingleModes = {
        [1] = { mode = "On", value = 1, overlay = "Single Target Focus", tip = "Single Target Focus", highlight = 1, icon = br.player.spell.shadowBolt},
        [2] = { mode = "Off", value = 2, overlay = "Multi Target Focus", tip = "Multi Target Focus", highlight = 1, icon = br.player.spell.agony}
    };
    CreateButton("Single",6,0)
end

-- function br.ui:createCDOption(parent, text, tooltip, hideCheckbox)
-- 	local cooldownModes = {"Always", "Always Boss", "OnCooldown", "OnCooldown Boss"}
-- 	local tooltipDrop = cPurple.."Always"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite..[[. 
-- ]]..cPurple.."Always Boss"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite.." as long as the current target is a Boss"..[[. 
-- ]]..cPurple.."OnCooldown"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite..[[. 
-- ]]..cPurple.."OnCooldown Boss"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite.." and Target is a Boss."
-- 	br.ui:createDropdown(parent, text, cooldownModes, 3, tooltip, tooltipDrop, hideCheckbox)
-- end

---------------
--- OPTIONS ---
---------------
local function createOptions ()
	local optionTable

	local function rotationOptions ()
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Affliction .:|:. General ".. ".:|:. ".. rotationVer)
            -- Multi-Target Units
            br.ui:createSpinnerWithout(section, "Multi-Target Units", 3, 1, 25, 1, "|cffFFBB00Health Percentage to use at.")

            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFBB00SimC", "|cffFFBB00Leveling"}, 1, "|cffFFBB00Set APL Mode to use.")

            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

            -- Pig Catcher
            br.ui:createCheckbox(section, "Pig Catcher")

            -- Auto Engage
            br.ui:createCheckbox(section,"Auto Engage")

            -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")

            -- Fel Domination
            br.ui:createCheckbox(section, "Fel Domination", "|cffFFFFFF Toggle the auto casting of Fel Donmination")

            -- Pet - Auto Attack/Passive
            br.ui:createCheckbox(section, "Pet - Auto Attack/Passive")

            -- Use Essence
            br.ui:createCheckbox(section, "Use Essence")

            -- Concentrated Flame
            br.ui:createSpinnerWithout(section, "Concentrated Flame", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")

            -- Azerite Beam Units
            br.ui:createSpinnerWithout(section, "Azerite Beam Units", 3, 1, 10, 1, "|cffFFBB00Number of Targets to use Azerite Beam on.")

            -- Flask
            br.ui:createDropdownWithout(section,"Elixir", {"Greater Flask of Endless Fathoms","Flask of Endless Fathoms","None"}, 1, "|cffFFFFFFSet Elixir to use.")

            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer", 2, 0, 10, 0.1, "Set desired time offset to opener (DBM Required). Min: 0 / Max: 10 / Interval: 0.1")
            
        br.ui:checkSectionState(section)

        ----------------------
		--- TOGGLE OPTIONS ---
		----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)  
        br.ui:checkSectionState(section)

        -------------------------
        --- Damage Over Time  ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Affliction .:|:. DoTs")
            -- Unstable Affliction Mouseover
            -- No Dot units
            br.ui:createCheckbox(section, "Mousever UA", "Toggles casting unstable Affliction to your mouseover target")

            -- Max Dots
            br.ui:createSpinner(section, "Agony Count", 8, 1, 25, 1, "The maximum amount of running Agony. Standard is 8")   
            br.ui:createSpinner(section, "Corruption Count", 8, 1, 25, 1, "The maximum amount of running Corruption. Standard is 8")
            br.ui:createSpinner(section, "Siphon Life Count", 8, 1, 25, 1, "The maximum amount of running Siphon Life. Standard is 8")
            
			-- No Dot units
            br.ui:createCheckbox(section, "Dot Blacklist", "Ignore certain units for dots")

            -- Darkglare dots
            br.ui:createSpinner(section, "Darkglare Dots", 3, 0, 4, 1, "Total number of dots needed on target to cast Darkglare (excluding UA). Standard is 3. Uncheck for auto use.")

			-- Spread agony on single target
            br.ui:createSpinner(section, "Spread Agony on ST", 3, 1, 15, 1, "Check to spread Agony when running in single target", "The amount of additionally running Agony. Standard is 3")
        br.ui:checkSectionState(section)

		-------------------------
        --- OFFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Affliction .:|:. Offensive")
            -- Darkglare
            br.ui:createDropdown(section, "Darkglare", {"|cffFFFFFFAuto", "|cffFFFFFFMax-Dot Duration",	"|cffFFFFFFOn Cooldown"}, 1, "|cffFFFFFFWhen to cast Darkglare")

			-- Agi Pot
            br.ui:createCheckbox(section, "Potion", "Use Potion")

            -- Augment
            br.ui:createCheckbox(section, "Augment", "Use Augment")

            -- Racial
            br.ui:createCheckbox(section, "Racial", "Use Racial")
            
			-- Trinkets
            br.ui:createCheckbox(section, "Trinkets", "Use Trinkets")

            -- Blood oF The Enemy
            br.ui:createCheckbox(section, "Blood oF The Enemy", "Use Blood of the enemy, line it up with darkglare")

            -- Malefic Rapture
            br.ui:createSpinner(section, "Malefic Rapture TTD", 20, 1, 100, 1, "The TTD to be <= to inside a raid/instance to start casting MR to burn")

            -- Malefic Rapture
            br.ui:createSpinner(section, "Malefic Rapture BloodLust", "Cast Malefic Rapture during bloodlust if you have at least 1 shard")

            -- Haunt TTD
            br.ui:createSpinner(section, "Haunt TTD", 6, 1, 15, 1, "The TTD before casting Haunt")

            -- Drain Soul Canceling
            --br.ui:createSpinner(section, "Drain Soul Clipping", 4, 1, 5, 1, "The tick of Drain Soul to cancel the cast at (5-6 ticks total)", true)

            -- Unstable Affliction Priority Mark
            --br.ui:createDropdown(section, "Priority Unit", { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffffffffMoon", "|cff0000ffSquare", "|cffff0000Cross", "|cffffffffSkull" }, 8, "Mark to Prioritize",true)



            -- Seed of Corruption
            --br.ui:createSpinner(section, "Seed of Corruption Unit", 4, 1, 15, 1, nil, "Unit count to cast Seed of Corruption at", true)

            
			-- UA Shards
			--br.ui:createSpinner(section, "UA Shards", 5, 1, 5, 1, nil, "Use UA on Shards", true)
        br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Defensive")
            -- Soulstone
		    br.ui:createDropdown(section, "Soulstone", {"|cffFFFFFFTarget","|cffFFFFFFMouseover","|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny", "|cffFFFFFFPlayer"},
            1, "|cffFFFFFFTarget to cast on")
            
            --- Healthstone Creation
            br.ui:createSpinner(section, "Create Healthstone",  3,  0,  3,  5,  "|cffFFFFFFToggle creating healthstones, and how many in bag before creating more")

            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  45,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Demonic Gateway
            br.ui:createDropdown(section, "Demonic Gateway", br.dropOptions.Toggle, 6)

            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end

            -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Mortal Coil 
            br.ui:createSpinner(section, "Mortal Coil",  23,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 48, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel (Demon)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Demon to Cast At")

            br.ui:createSpinnerWithout(section, "Health Funnel (Player)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Player to Cast At")

            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Devour Magic
            br.ui:createDropdown(section,"Devour Magic", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")

        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Interrupts")
            br.ui:createDropdown(section, "Shadowfury Key", br.dropOptions.Toggle, 6)

            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")

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
    ---------------
    --- Toggles ---
    ---------------
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)

    --------------
    --- Locals ---
    --------------
    local activePet = br.player.pet
    local activePetId = br.player.petId
    local artifact = br.player.artifact
    local agonyCount = br.player.debuff.agony.count()
    local buff = br.player.buff
    local cast = br.player.cast
    local castable = br.player.cast.debug
    local combatTime = getCombatTime()
    local corruptionCount = br.player.debuff.corruption.count()
    local cd = br.player.cd
    local charges = br.player.charges
    local deadMouse = UnitIsDeadOrGhost("mouseover")
    local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local equiped = br.player.equiped
    local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
    local friendly = friendly or GetUnitIsFriend("target", "player")
    local gcd = br.player.gcdMax
    local gcdMax = br.player.gcdMax
    local hasMouse = GetObjectExists("mouseover")
    local hasteAmount = GetHaste() / 100
    local hasPet = IsPetActive()
    local healPot = getHealthPot()
    local heirloomNeck = 122663 or 122664
    local inCombat = isInCombat("player")
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local lastSpell = lastSpellCast
    local level = br.player.level
    local ui = br.player.ui
    local cl = br.read
    local lootDelay = getOptionValue("LootDelay")
    local manaPercent = br.player.power.mana.percent()
    local mode = br.player.ui.mode
    local moving = isMoving("player") ~= false or br.player.moving
    local pet = br.player.pet
    local php = br.player.health
    local playerMouse = UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer = PullTimerRemain()
    local race = br.player.race
    local shards = UnitPower("player", Enum.PowerType.SoulShards)
    local summonPet = getOptionValue("Summon Pet")
    local solo = br.player.instance == "none"
    local siphonLifeCount = br.player.debuff.siphonLife.count()
    local spell = br.player.spell
    local spellHaste = (1 + (GetHaste()/100))
    local talent = br.player.talent
    local thp = getHP("target")
    local trait = br.player.traits
    local travelTime = getDistance("target") / 16
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local use = br.player.use
    actionList = {}

    units.get(40)
    enemies.get(8, "target")
    enemies.get(10, "target")
    enemies.get(40)

    -- Profile Specific Locals
    if actionList_PetManagement == nil then
        loadSupport("PetCuteOne")
        actionList_PetManagement = br.rotations.support["PetCuteOne"]
    end

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil or not inCombat then
        profileStop = false
    end
    if castSummonId == nil then
        castSummonId = 0
    end
    if summonTime == nil then
        summonTime = 0
    end

    --ttd
    local function ttd(unit)
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then
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
        local creatureType = UnitCreatureType(unit)
        local objectID = GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
                return true
            end
        end
        return false
    end

    local noDotUnits = {
        [135824] = true, -- Nerubian Voidweaver
        [139057] = true, -- Nazmani Bloodhexer
        [129359] = true, -- Sawtooth Shark
        [129448] = true, -- Hammer Shark
        [134503] = true, -- Silithid Warrior
        [137458] = true, -- Rotting Spore
        [139185] = true, -- Minion of Zul
        [120651] = true -- Explosive
    }

    local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then
            return true
        end
        if isTotem(unit) then
            return true
        end
        local unitCreator = UnitCreator(unit)
        if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then
            return true
        end
        if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then
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
        if UnitInPhase(unit) then
            if GetUnitIsFriend("player", unit) then
                while UnitDebuff(unit, i) do
                    local _, _, _, dispelType, debuffDuration, expire, _, _, _, dispelId = UnitDebuff(unit, i)
                    if (dispelType and dispelType == "Magic") and dDispelList[dispelId] ~= nil and (dDispelList[dispelId] == 0 or (dDispelList[dispelId] > 0 and #getAllies(unit, dDispelList[dispelId]) == 1)) then
                        dispelDuration = debuffDuration
                        remain = expire - GetTime()
                        validDispel = true
                        break
                    end
                    i = i + 1
                end
            else
                while UnitBuff(unit, i) do
                    local _, _, _, dispelType, buffDuration, expire, _, _, _, dispelId = UnitBuff(unit, i)
                    if (dispelType and dispelType == "Magic") and oDispelList[dispelId] ~= nil and (oDispelList[dispelId] == 0 or (oDispelList[dispelId] > 0 and #getAllies(unit, oDispelList[dispelId]) == 0)) then
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
        if isChecked("Dispel delay") then
            dispelDelay = getValue("Dispel delay")
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
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(getDistance(thisUnit) - 20)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.facing = getFacing("player", thisUnit)
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
        if isChecked("Auto Target") and inCombat and #enemyTable40 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable40[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable40[1].unit)
        end
    end

    --Keybindings
    local shadowfuryKey = false
    if getOptionValue("Shadowfury Hotkey (hold)") ~= 1 then
        shadowfuryKey = _G["rotationFunction" .. (getOptionValue("Shadowfury Hotkey (hold)") - 1)]
        if shadowfuryKey == nil then
            shadowfuryKey = false
        end
    end
    -- spell usable check
    local function spellUsable(spellID)
        if isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end

    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
    local function actionList_Extras()
        -- Dummy Test
        if isChecked("DPS Testing") then
            if GetObjectExists("target") then
                if getCombatTime() >= (tonumber(getOptionValue("DPS Testing")) * 60) and isDummy() then
                    StopAttack()
                    ClearTarget()
                    if isChecked("Pet Management") then
                        PetStopAttack()
                        PetFollow()
                    end
                    Print(tonumber(getOptionValue("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                    profileStop = true
                end
            end
        end -- End Dummy Test
        if isChecked("Shadowfury Hotkey (hold)") and shadowfuryKey and not GetCurrentKeyBoardFocus() then
            if getOptionValue("Shadowfury Target") == 1 then
                if cast.shadowfury("best", false, 1, 8) then
                    return
                end
            elseif getOptionValue("Shadowfury Target") == 2 then
                if cast.shadowfury("target", "ground") then
                    return
                end
            elseif getOptionValue("Shadowfury Target") == 3 and isKnown(spell.shadowfury) and getSpellCD(spell.shadowfury) == 0 then
                CastSpellByName(GetSpellInfo(spell.shadowfury), "cursor")
                return
            end
        end
        --Burn Units
        local burnUnits = {
            [120651] = true, -- Explosive
            [141851] = true -- Infested
        }
        if GetObjectExists("target") and burnUnits[GetObjectID("target")] ~= nil then
        end
        --Soulstone
        if isChecked("Auto Soulstone Mouseover") and not moving and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
            if cast.soulstone("mouseover", "dead") then
                return true
            end
        end
        if isChecked("Auto Soulstone Player") and not inInstance and not inRaid and (not buff.soulstone.exists("player") or buff.soulstone.remain("player") < 100) and not inCombat and not moving then
            if cast.soulstone("player") then
                return
            end
        end
    end -- End Action List - Extras
    -- Action List - Defensive
    local function actionList_Defensive()
        if useDefensive() then
            -- Pot/Stoned
            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                end
            end
            -- Heirloom Neck
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                if hasEquiped(heirloomNeck) then
                    if GetItemCooldown(heirloomNeck) == 0 then
                        useItem(heirloomNeck)
                    end
                end
            end
            --dispel logic for m+
            if inInstance and isChecked("Auto Dispel/Purge") then
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
            -- Gift of the Naaru
            if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end
            -- Dark Pact
            if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
                if cast.darkPact() then
                    return
                end
            end
            -- Drain Life
            if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and isValidTarget("target") and not moving then
                if cast.drainLife() then
                    return
                end
            end
            -- Health Funnel
            if isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") and not moving then
                if cast.healthFunnel("pet") then
                    return
                end
            end
            -- Unending gResolve
            if isChecked("Unending Resolve") and php <= getOptionValue("Unending Resolve") and inCombat then
                if cast.unendingResolve() then
                    return
                end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive
    -- Action List - Interrupts
    local function actionList_Interrupts()
        if useInterrupts() then
            if talent.grimoireOfSacrifice then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if cast.spellLockgrimoire(thisUnit) then
                            return
                        end
                    end
                end
            elseif activePetId ~= nil and (activePetId == 417 or activePetId == 78158) then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if activePetId == 417 then
                            if cast.spellLock(thisUnit) then
                                return
                            end
                        end
                    end
                end
            end
        end -- End useInterrupts check
    end -- End Action List - Interrupts

    -- Action List - Cooldowns
    local function actionList_Cooldowns()
        if getDistance("target") < 40 then

            if isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (tyrantActive or ttd("target") < 30) then
                use.battlePotionOfIntellect()
                return true
            end

            if isChecked("Trinkets") then
                if canUseItem(13) then
                    useItem(13)
                end
                if canUseItem(14) then
                    useItem(14)
                end
            end

            if isChecked("Racial") and not moving then
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

    local function actionList_Rotation()
        if spellQueueReady() then
            ------------------------------------------------
            -- Agony ---------------------------------------
            ------------------------------------------------
            if agonyCount < ui.value("Spread Agony on ST") then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not noDotCheck(thisUnit) and debuff.agony.refresh(thisUnit) and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) then
                        if cast.agony(thisUnit) then br.addonDebug("[Action:Rotation] Agony [Refresh]") return true end
                    end
                end
            end

            --cast.timeSinceLast.unstableAffliction() >= 3 
            ------------------------------------------------
            -- Unstable Affliction -------------------------
            ------------------------------------------------
            if debuff.unstableAffliction.remains("target") <= 7.7 + cast.time.unstableAffliction() and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1  and not cast.last.unstableAffliction(2) then
               if cast.unstableAffliction("target") then br.addonDebug("[Action:Rotation] Unstable Affliction [Refresh]") return true end
            end

            ------------------------------------------------
            -- Corruption ----------------------------------
            ------------------------------------------------
            if not talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and  debuff.corruption.refresh(thisUnit) and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                           if cast.corruption(thisUnit) then br.addonDebug("[Action:Rotation] Corruption [Refresh]") return true end
                        end
                    end
                end
            elseif talent.absoluteCorruption then
                if corruptionCount < 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and not debuff.corruption.exists(thisUnit) and not debuff.seedOfCorruption.exists(thisUnit) then
                            if cast.corruption(thisUnit) then br.addonDebug("[Action:Rotation] Corruption [Absolute Corruption]") return true end
                        end
                    end
                end
            end

            ------------------------------------------------
            -- Cooldowns -----------------------------------
            ------------------------------------------------
            if actionList_Cooldowns() then return end 

            ------------------------------------------------
            -- Vile Taint ----------------------------------
            ------------------------------------------------
            if not moving and talent.vileTaint and shards > 0 then
                if cast.vileTaint("target") then br.addonDebug("[Action:Rotation] Vile Taint") return true end
            end

            ------------------------------------------------
            -- Summon Darkglare ----------------------------
            ------------------------------------------------

            ------------------------------------------------
            -- Phantom Singularity -------------------------
            ------------------------------------------------
            if talent.phantomSingularity then
                if cast.phantomSingularity() then br.addonDebug("[Action:Rotation] Phantom Singularity") return true end
            end
       
            ------------------------------------------------
            -- Haunt ---------------------------------------
            ------------------------------------------------
            if not moving and talent.haunt and not debuff.haunt.exists("target") and getTTD("target") >= ui.value("Haunt TTD") then
                if cast.haunt("target") then br.addonDebug("[Action:Rotation] Haunt") return true end
            end

            ------------------------------------------------
            -- Malefic Rapture, Max Periodic Effects -------
            ------------------------------------------------
            if cast.able.maleficRapture() and not moving and shards > 0 and getDistance("target") <= 40 then
                -- Malefic Rapture, Phantom Singularity
               if debuff.phantomSingularity.exists("target") then if cast.maleficRapture() then br.addonDebug("[Action:Rotation] Malefic Rapture, Phantom Singularity") return true end end 

                -- Malefic Rapture, Vile Taint
               if debuff.vileTaint.exists("target") then if cast.maleficRapture() then br.addonDebug("[Action:Rotation] Malefic Rapture, Vile Taint") return true end end 
            end

            ------------------------------------------------
            -- Agony, Moving -------------------------------
            ------------------------------------------------
            if moving then
                if agonyCount < ui.value("Agony Count") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        local agonyRemain = debuff.agony.remain(thisUnit)
                        if not noDotCheck(thisUnit) and ttd(thisUnit) > 10 then
                            if cast.agony(thisUnit) then br.addonDebug("Casting Agony") return true end
                        end
                    end
                end
            end
        end-- End Spell Queue Ready
    end-- End Action List: Rotation

    local function actionList_Opener()
        opener = true
    end

    local function actionList_PreCombat()
         -- Fel Domination
        if ui.checked("Fel Domination") and inCombat
        and not GetObjectExists("pet") or UnitIsDeadOrGhost("pet")
        and cd.felDomination.remain() <= gcdMax
        then
            if cast.felDomination() then br.addonDebug("Fel Domination") return true end
        end
 
        --actions.precombat+=/summon_pet
        if ui.checked("Pet Management") 
        and (not inCombat or buff.felDomination.exists())
        and (not moving or buff.felDomination.exists())
        and level >= 5 and GetTime() - br.pauseTime > 0.5 and br.timer:useTimer("summonPet", 1) 
        then
            if mode.petSummon == 5 and pet.active.id() ~= 0 then
                PetDismiss()
            end
            if (pet.active.id() == 0 or pet.active.id() ~= summonId) and (lastSpell ~= castSummonId
                or pet.active.id() ~= summonId or pet.active.id() == 0)
            then
            if mode.petSummon == 1 then
                if cast.summonImp("player") then castSummonId = spell.summonImp return true end
            elseif mode.petSummon == 2 then
                if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker return true end
            elseif mode.petSummon == 3 then
                if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter return true end
            elseif mode.petSummon == 4  then
                if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus return true end
                end
            end
        end
        -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
        if talent.grimoireOfSacrifice and isChecked("Pet Management") and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
            if cast.grimoireOfSacrifice() then
                return
            end
        end
        if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask
            -- flask,type=whispered_pact
            -- Food
            -- food,type=azshari_salad
            if (not isChecked("Opener") or opener == true) then
                if useCDs() and isChecked("Pre-Pull Logic") and GetObjectExists("target") and getDistance("target") < 40 then
                    local demonboltExecute = cast.time.demonbolt()
                    if pullTimer <= demonboltExecute then
                        if isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
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
                if isValidUnit("target") and getDistance("target") < 40 and (not isChecked("Opener") or opener == true) then
                    -- Life Tap
                    -- life_tap,if=talent.empowered_life_tap.enabled&!buff.empowered_life_tap.remains
                    if talent.empoweredLifeTap and not buff.empoweredLifeTap.exists() then
                        if cast.lifeTap() then
                            return
                        end
                    end
                    -- Pet Attack/Follow
                    if isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
                        PetAssistMode()
                        PetAttack("target")
                    end
                end
            end
        end -- End No Combat
        if actionList_Opener() then
            return
        end
    end -- End Action List - PreCombat
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif (inCombat and profileStop == true) or IsMounted() or IsFlying() or pause(true) or mode.rotation == 4 then
        if not pause(true) and IsPetAttackActive() and isChecked("Pet Management") then
            PetStopAttack()
            PetFollow()
        end
        return true
    else
        ------------------------------------------------
        -- PET MANAGEMENT ------------------------------
        ------------------------------------------------
        if actionList_PetManagement() then return true end

        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList_Extras() then
            return
        end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList_Defensive() then
            return
        end
        -----------------------
        --- Opener Rotation ---
        -----------------------
        if opener == false and isChecked("Opener") and isBoss("target") then
            if actionList_Opener() then
                return
            end
        end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList_PreCombat() then
            return
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and profileStop == false and isValidUnit("target") and getDistance("target") < 40 and (opener == true or not isChecked("Opener") or not isBoss("target")) and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            if actionList_CancelCast() then
                return
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then
                return
            end

            if br.queueSpell then
                ChatOverlay("Pausing for queuecast")
                return true 
            end

            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if getOptionValue("APL Mode") == 1 and not pause() then
                -- Pet Attack
                if isChecked("Pet Management") and not GetUnitIsUnit("pettarget", "target") and isValidUnit("target") then
                    PetAttack()
                end
                -- rotation
                if actionList_Rotation() then
                    return
                end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End Timer
-- end -- End runRotation

local id = 265 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
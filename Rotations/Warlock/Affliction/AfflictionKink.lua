local rotationName = "KinkAffliction"
local rotationVer  = "v1.5.2"
local dsInterrupt = false
----------------------------------------------------
-- Credit and huge thanks to: Fiskee forthe basis of this rotation/API
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
        [1] = { mode = "Single", value = 1, overlay = "Single Target Focus", tip = "Single Target Focus", highlight = 1, icon = br.player.spell.drainSoul},
        [2] = { mode = "Multi", value = 2, overlay = "Multi Target Focus", tip = "Multi Target Focus", highlight = 1, icon = br.player.spell.agony},
        [3] = { mode = "Spam", value = 3, overlay = "SoC Spam", tip = "Spam SoC Focus", highlight = 1, icon = br.player.spell.seedOfCorruption}

    };
    CreateButton("Single",6,0)

    -- Pet Follow/Attack Toggle
    PetCommandModes = {
        [1] = {mode = "Pet Attack", value = 1, overlay = "Pet Attack Enabled", tip = "Will Pet Attack", highlight = 1, icon =  br.player.spell.summonFelhunter},
        [2] = {mode = "Pet Follow", value = 2, overlay = "Pet Follow Enabled", tip = "Will Pet Follow", highlight = 1, icon = br.player.spell.subjugateDemon}
    }
    CreateButton("PetCommand", 1, 1)



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

            -- Unending Breath
            br.ui:createCheckbox(section, "Unending Breath", "|cffFFFFFF Toggle the auto casting of Unending Breath on party if swimming or submerged")

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

            -- Pre-Pull Spell
            br.ui:createDropdownWithout(section,"Pre-Pull Spell", {"Haunt","Shadow Bolt","None"}, 1, "|cffFFFFFFSet Pre-Pull Spell to cast.")

            -- Pre-Pull SoC
            br.ui:createCheckbox(section, "Pre-Pull SoC", "|cffFFFFFF Toggle the use of casting Seed of corruption on pre-pull w/ >= 3 enemies.")
            -- Pre-Pull SoC Count
            br.ui:createSpinner(section, "Pre-Pull SoC Count", 3, 0, 15, 1, "Set desired amount of units to pre-pull SoC with (DBM Required). Min: 0 / Max: 15 / Interval: 1")
            
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
            -- Seed of Corruption TTD
            br.ui:createSpinnerWithout(section, "Seed of Corruption TTD", 6, 1, 25, 1, "|cffFFBB00Minimum Time to Die of a unit to cast Seed of Corruption on.")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "SoC Spam Delay", 0.1, 0, 10, 0.1, "Set desired delqy between SoC casts during SoC Spam. Min: 0 / Max: 10 / Interval: 0.1")

            -- Unstable Affliction Mouseover
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
            -- Curse of Tongues
            br.ui:createCheckbox(section, "Curse of Tongues", "Use Curse Of Tongues on enemy healers")

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

            -- Demonic Circle Summon
            br.ui:createDropdown(section, "Demonic Circle Summon", br.dropOptions.Toggle, 6)

            -- Demonic Circle Teleport
            br.ui:createDropdown(section, "Demonic Circle Teleport", br.dropOptions.Toggle, 6)

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

    br.player.ui.mode.pc = br.data.settings[br.selectedSpec].toggles["PetCommand"]
    br.player.ui.mode.ss = br.data.settings[br.selectedSpec].toggles["Single"]

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
    enemies.get(10)
    enemies.get(10, "target", true)
    enemies.get(40, nil, nil, nil, spell.drainSoul)

    -- Profile Specific Locals
    if actionList_PetManagement == nil then
        loadSupport("PetCuteOne")
        actionList_PetManagement = br.rotations.support["PetCuteOne"]
    end

    if br.pauseTime == nil then br.pauseTime = GetTime() end

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

    -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = {UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
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

    -- AoE Units
    local aoeUnits = 0
    for i = 1, #enemies.yards10tnc do
        local thisUnit = enemies.yards10tnc[i]
        if ttd(thisUnit) > 4 then
            aoeUnits = aoeUnits + 1
        end
    end

    -- Pet Stance
    local function petFollowActive()
        for i = 1, NUM_PET_ACTION_SLOTS do
            local name, _, _,isActive = GetPetActionInfo(i)
            if isActive and name == "PET_ACTION_FOLLOW" then
                return true
            end
        end
        return false
    end    

    --[[
local function CanUseCurse(target, targetTTD, targetIsPlayer, obj, isP)
    -- @return boolean 
    if (not isP and obj:IsReady(target)) or (isP and obj:IsReadyP(target)) then 
        if obj == A.CurseofAgony then 
            return targetTTD >= 10 and Unit(target):HasDeBuffs(obj.ID) == 0 and obj:AbsentImun(target, Temp.AuraForCC)
        elseif obj == A.CurseofDoom then 
            return targetTTD >= 60 and not targetIsPlayer and Unit(target):HasDeBuffs(obj.ID) == 0 and obj:AbsentImun(target, Temp.AuraForCC)
        elseif obj == A.CurseofExhaustion then 
            return targetTTD >= 6 and targetIsPlayer and Unit(target):GetCurrentSpeed() >= 100 and Unit(target):HasDeBuffs(obj.ID) == 0 and obj:AbsentImun(target, Temp.AuraForFreedom)
        else 
            if targetTTD >= 10 then 
                if Unit(target):HasDeBuffs(obj.ID) == 0 then 
                    return obj:AbsentImun(target, Temp.AuraForCC)
                else 
                    local myDur = Unit(target):HasDeBuffs(obj.ID, true)
                    return myDur > 0 and myDur <= 4 and obj:AbsentImun(target, Temp.AuraForCC)
                end 
            end 
        end 
    end 
end 
    ]]

    local function isHealer(unit)
        if unit == nil then unit = "target" end
        local class = select(2, UnitClass(unit))

        if (class == "DRUID" or class =="PALADIN" or class =="PRIEST" or class =="MONK" or class =="SHAMAN") then
            if UnitPowerMax(unit >= 290000) and not UnitBuffID(unit, 24858) and not UnitBuffID(unit, 15473) and not UnitBuffID(unit, 324) then
                return true
            end
        end
    end

    local function isMelee(unit)
        if unit == nil then unit = "target" end
        local class = select(2, UnitClass(unit))
        if (class == "DRUID" or class =="PALADIN" or class =="WARRIOR" or class =="MONK" or class =="SHAMAN" or class =="DEATHKNIGHT" or class =="ROGUE" or class =="DEMONHUNTER" )and UnitPowerMax(unit) < 70000 then
            return true
        end
    end

    -- canCurse("target", ttd("target"), CoT)
    local function canCurse(unit, obj)
        if unit == nil then unit = target end 
        if UnitIsDeadOrGhost(unit) then return false end 
        local class = select(2, UnitClass(unit))
        local name = GetUnitName(unit, true)
        if obj == nil and isHealer(unit) then obj = CoT end
        
        if GetObjectExists(unit) and UnitCanAttack(unit,"player") and UnitIsPVP(unit) and UnitIsPlayer("target") then 
            if obj == CoT and ttd(unit) >= 6 and isHealer(unit) then
                if cast.curseOfTongues(unit) then 
                    --br.addonDebug("[Action:PvP] Curse of Tongues" .. " | Name: " .. name .. " | Class: ".. class .. " | Level:" .. UnitLevel(unit) .. " | Race: " .. select(1,UnitRace(unit))) 
                    return true
                end
            end
        end
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

    local seedTarget = seedTarget or "target"
    local dsTarget
    dsTicks = br.dsTicks
    dsMaxTicks = br.dsMaxTicks
    local seedHit = 0
    local seedCorruptionExist = 0
    local seedTargetCorruptionExist = 0
    local seedTargetsHit = 1
    local lowestShadowEmbrace = lowestShadowEmbrace or "target"
    local enemyTable40 = enemies.get(40, "player", true)


    local inBossFight = false
    for i = 1, #enemyTable40 do
        local thisUnit = enemyTable40[i].unit
        if isBoss(thisUnit) or ttd("target") >= 30 then
            inBossFight = true
        end
        if talent.shadowEmbrace and debuff.shadowEmbrace.exists(thisUnit) then
            if debuff.shadowEmbrace.exists(lowestShadowEmbrace) then
                shadowEmbraceRemaining = debuff.shadowEmbrace.remain(lowestShadowEmbrace)
            else
                shadowEmbraceRemaining = 40
            end
            if debuff.shadowEmbrace.remain(thisUnit) < shadowEmbraceRemaining then
                lowestShadowEmbrace = thisUnit
            end
        end
        local unitAroundUnit = getEnemies(thisUnit, 10, true)
        if mode.seed == 1 and getFacing("player",thisUnit) and #unitAroundUnit > seedTargetsHit and ttd(thisUnit) > 8 then
            seedHit = 0
            seedCorruptionExist = 0
            for q = 1, #unitAroundUnit do
                local seedAoEUnit = unitAroundUnit[q]
                if ttd(seedAoEUnit) > cast.time.seedOfCorruption()+3 then seedHit = seedHit + 1 end
                if debuff.corruption.exists(seedAoEUnit) then seedCorruptionExist = seedCorruptionExist + 1 end
            end
            if seedHit > seedTargetsHit or (GetUnitIsUnit(thisUnit, "target") and seedHit >= seedTargetsHit) then
                seedTarget = thisUnit
                seedTargetsHit = seedHit
                seedTargetCorruptionExist = seedCorruptionExist
            end
        end
        if getFacing("player",thisUnit) and ttd(thisUnit) <= gcd and getHP(thisUnit) < 80 then
            dsTarget = thisUnit
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

        --Pet assist
        if isChecked("Pet Management") and UnitIsVisible("pet") and not petFollowActive() and (not inCombat or getDistance("target", "pet") > 40) or mode.pc ~= 1 then
            PetFollow()
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

        -- Unending Breath
        if isChecked("Unending Breath") and br.timer:useTimer("UB Delay", math.random(1, 10)) then
            for i = 1, #br.friend do
                if not buff.unendingBreath.exists(br.friend[i].unit,"any") and IsSubmerged(br.friend[i].unit) or IsSwimming(br.friend[i].unit) and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                    if cast.unendingBreath() then return true end
                end
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

        -- Soulstone
        if isChecked("Soulstone") and not moving and inCombat and br.timer:useTimer("Soulstone", 4) then
            if getOptionValue("Soulstone") == 1 and -- Target
                    UnitIsPlayer("target") and
                    UnitIsDeadOrGhost("target") and
                    GetUnitIsFriend("target", "player")
                then
                if cast.soulstone("target", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end

            if getOptionValue("Soulstone") == 2 and -- Mouseover
                    UnitIsPlayer("mouseover") and
                    UnitIsDeadOrGhost("mouseover") and
                    GetUnitIsFriend("mouseover", "player")
                then
                if cast.soulstone("mouseover", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end

            if getOptionValue("Soulstone") == 3 then -- Tank
                for i = 1, #tanks do
                    if UnitIsPlayer(tanks[i].unit) and UnitIsDeadOrGhost(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 then
                        if cast.soulstone(tanks[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end

            if getOptionValue("Soulstone") == 4 then -- Healer
                for i = 1, #br.friend do
                    if
                        UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
                            (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end

            if getOptionValue("Soulstone") == 5 then -- Tank/Healer
                for i = 1, #br.friend do
                    if
                        UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
                            (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end

            if getOptionValue("Soulstone") == 6 then -- Any
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
        end

            -- Demonic Gateway
            if isChecked("Demonic Gateway") 
            and SpecificToggle("Demonic Gateway") 
            and not GetCurrentKeyBoardFocus() 
            then
                if br.timer:useTimer("RoF Delay", 1) and cast.demonicGateway(nil,"aoe",1,8,true) then br.addonDebug("Casting Demonic Gateway") return end 
            end

            -- Demonic Circle: Summon
            if SpecificToggle("Demonic Circle Summon") 
            and not GetCurrentKeyBoardFocus() 
            then
                if br.timer:useTimer("DC Delay", 1) then cast.demonicCircle("player") br.addonDebug("Demonic Circle (Summon)") return true end 
            end
            -- Demonic Circle: Teleport
            if SpecificToggle("Demonic Circle Teleport")
            and not GetCurrentKeyBoardFocus() 
                        then
                if br.timer:useTimer("DC Delay", 1) and buff.demonicCircle.exists() then cast.demonicTeleport("player") br.addonDebug("Demonic Circle (Summon)") return true end 
            end

            -- Mortal Coil
            if ui.checked("Mortal Coil") and php <= ui.value("Mortal Coil") then
                if cast.mortalCoil() then br.addonDebug("Casting Mortal Coil") return true end
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
            if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and not moving then
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

            if isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() or ttd("target") < 30 then
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

    local function actionList_SE()
        --actions.se+=/haunt
        if not moving and cast.able.haunt() then 
            if cast.haunt() then br.addonDebug("[Action:SE] Haunt (Shadow Embrace APL)") return true end 
        end

        --actions.se+=/drain_soul,interrupt_if=debuff.shadow_embrace.stack>=3
        if not moving and cast.able.drainSoul()
        then
        
        end

        --actions.se+=/shadow_bolt
        if not moving and cast.able.shadowBolt() then
            if cast.shadowBolt() then br.addonDebug("[Action:SE] Haunt (Shadow Embrace APL)") return true end
        end
    end -- End Action List: Shadow Embrace

    
    local function actionList_DarkGlarePrep()
        ------------------------------------------------
        -- Vile Taint ----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/vile_taint
        if not moving and talent.vileTaint then
            if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("[Action:Rotation] Vile Taint") return true end
        end

        -- actions.darkglare_prep+=/dark_soul

        -- actions.darkglare_prep+=/potion

        -- actions.darkglare_prep+=/fireblood
        -- actions.darkglare_prep+=/blood_fury
        -- actions.darkglare_prep+=/berserking

        -- actions.darkglare_prep+=/summon_darkglare

    end -- End Action List: DarkGlare prep

    local function actionList_AoE()
        ------------------------------------------------
        -- Phantom Singularity -------------------------
        ------------------------------------------------
        -- actions.aoe=phantom_singularity
        if talent.phantomSingularity and cast.able.phantomSingularity() then 
            if cast.phantomSingularity() then br.addonDebug("[Action:AoE] Phantom Singularity") return true end 
        end

        ------------------------------------------------
        -- Haunt ---------------------------------------
        ------------------------------------------------
        -- actions.aoe+=/haunt
        if talent.haunt and not moving and cast.able.haunt() then 
            if cast.haunt() then br.addonDebug("[Action:AoE] Haunt") return true end 
        end

        ------------------------------------------------
        -- Seed of Corruption, Sow The Seeds -----------
        ------------------------------------------------
        -- actions.aoe+=/seed_of_corruption,if=talent.sow_the_seeds.enabled&can_seed
        if talent.sowTheSeeds and not moving and not cast.inFlight.seedOfCorruption() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local thisHP = getHP(thisUnit)
                if (not moving and not debuff.seedOfCorruption.exists(thisUnit) or not debuff.corruption.exists(thisUnit) and not debuff.seedOfCorruption.exists(thisUnit) and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) >= ui.value("Seed of Corruption TTD") then
                    if cast.seedOfCorruption(thisUnit) then br.addonDebug("Casting Seed of Corruption") return true end
                end
            end
        end

        ------------------------------------------------
        -- Seed of Corruption, No STS Talent -----------
        ------------------------------------------------
        -- actions.aoe+=/seed_of_corruption,if=!talent.sow_the_seeds.enabled&!dot.seed_of_corruption.ticking&!in_flight&dot.corruption.refreshable
        if not talent.sowTheSeeds and not moving and not debuff.seedOfCorruption.exists("target") and not cast.inFlight.seedOfCorruption() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not noDotCheck(thisUnit) and not debuff.corruption.exists(thisUnit) and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                    if cast.seedOfCorruption(thisUnit) then br.addonDebug("[Action:AoE] Seed of Corruption, not Talent Sow The Seeds [Multi]") return true end
                end
            end
        end

        ------------------------------------------------
        -- Cycle Agony  --------------------------------
        ------------------------------------------------
        -- actions.aoe+=/agony,cycle_targets=1,if=active_dot.agony>=4,target_if=refreshable&dot.agony.ticking
        -- actions.aoe+=/agony,cycle_targets=1,if=active_dot.agony<4,target_if=!dot.agony.ticking
        if agonyCount < ui.value("Agony Count") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not noDotCheck(thisUnit) and debuff.agony.remains(thisUnit) <= 7 + gcdMax and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) then
                    if cast.agony(thisUnit) then br.addonDebug("[Action:AoE] Agony [Multi-Cycle]") return true end
                end
            end
        end
  
        ------------------------------------------------
        -- Unstable Affliction -------------------------
        ------------------------------------------------
        -- actions.aoe+=/unstable_affliction,if=dot.unstable_affliction.refreshable
        if not moving and debuff.unstableAffliction.remains("target") <= 10 + cast.time.unstableAffliction() and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 and br.timer:useTimer("UA", 1.5) then
            if cast.unstableAffliction("target") then br.addonDebug("[Action:Rotation] Unstable Affliction [Refresh]") return true end
        end
        
        ------------------------------------------------
        -- Vile Taint ----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/vile_taint,if=soul_shard>1
        if not moving and talent.vileTaint and shards > 1 then
            if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("[Action:Rotation] Vile Taint") return true end
        end

        -- actions.aoe+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.ready&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)

        ------------------------------------------------
        -- Dark Soul -----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
        if talent.darkSoul and useCDs() or isChecked("Cooldowns Hotkey") and SpecificToggle("Cooldowns Hotkey") and not moving and cd.summonDarkglare.remain() > ttd then
            if cast.darkSoul("player") then br.addonDebug("Casting Dark Soul") return true end
        end 
        if talent.darkSoul and useCDs() and not moving and pet.darkglare.active() then
            if cast.darkSoul("player") then br.addonDebug("[Action:Rotation] Dark Soul (Darkglare Active)") return true end
        end 

        -- actions.aoe+=/drain_life,if=buff.inevitable_demise.stack>=50|buff.inevitable_demise.up&time_to_die<5

        ------------------------------------------------
        -- Cooldowns -----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/call_action_list,name=cooldowns
        if actionList_Cooldowns() then return end 


        -- actions.aoe+=/call_action_list,name=item

        ------------------------------------------------
        -- Malefic Rapture, Vile Taint Ticking ---------
        ------------------------------------------------
        -- actions.aoe+=/malefic_rapture,if=dot.vile_taint.ticking
        if not moving and cast.able.maleficRapture() and debuff.vileTaint.exists("target") and shards > 0 then
            if cast.maleficRapture() then br.addonDebug("[Action:AoE] Malefic Rapture, Vile Taint Ticking") return true end
        end

        ------------------------------------------------
        -- Malefic Rapture, No Vile Taint --------------
        ------------------------------------------------
        -- actions.aoe+=/malefic_rapture,if=!talent.vile_taint.enabled
        if not moving and cast.able.maleficRapture() and not talent.vileTaint and shards > 0 then
            if cast.maleficRapture() then br.addonDebug("[Action:AoE] Malefic Rapture, No Vile Taint Talent") return true end 
        end
        
        ------------------------------------------------
        -- Cycle Siphon Life  --------------------------
        ------------------------------------------------
        -- actions.aoe+=/siphon_life,cycle_targets=1,if=active_dot.siphon_life<=3,target_if=!dot.siphon_life.ticking
        if siphonLifeCount < ui.value("Siphon Life Count") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not noDotCheck(thisUnit) and debuff.siphonLife.refresh(thisUnit) and getTTD(thisUnit) > debuff.siphonLife.remain(thisUnit) + (3/spellHaste)  then
                    if cast.siphonLife(thisUnit) then br.addonDebug("[Action:AoE] Siphon Life [Multi-Cycle]") return true end
                end
            end
        end

        ------------------------------------------------
        -- Drain Life, Inevitable Demise > 50, TTD < 5 -
        ------------------------------------------------
        -- actions.aoe+=/drain_life,if=buff.inevitable_demise.stack>=50|buff.inevitable_demise.up&time_to_die<5
        if not moving and talent.inevitableDemise and buff.inevitableDemise.stack() >= 50 or buff.inevitableDemise.exists() and ttd("target") < 5 and br.timer:useTimer("ID Delay", 5) then
            if cast.drainLife() then br.addonDebug("[Action:Rotation] Drain Life (ID and TTD < 5)") return true end
        end


        ------------------------------------------------
        -- Drain Soul ----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/drain_soul
        if not moving and cast.able.shadowBolt() then
            if cast.shadowBolt() then br.addonDebug("[Action:AoE] Haunt (Shadow Embrace APL)") return true end
        end

        ------------------------------------------------
        -- Shadow Bolt ---------------------------------
        ------------------------------------------------
        --actions.se+=/shadow_bolt
        if not moving and cast.able.shadowBolt() then
            if cast.shadowBolt() then br.addonDebug("[Action:AoE] Haunt (Shadow Embrace APL)") return true end
        end

    end -- End Action List: AoE

    --[[
Single Target Action list Date: 11/16/20
actions=call_action_list,name=aoe,if=active_enemies>3
actions+=/phantom_singularity
actions+=/agony,if=refreshable
actions+=/agony,cycle_targets=1,if=active_enemies>1,target_if=refreshable
actions+=/call_action_list,name=darkglare_prep,if=active_enemies>2&cooldown.summon_darkglare.ready&(dot.phantom_singularity.ticking|!talent.phantom_singularity.enabled)
actions+=/seed_of_corruption,if=active_enemies>2&!talent.vile_taint.enabled&(!talent.writhe_in_agony.enabled|talent.sow_the_seeds.enabled)&!dot.seed_of_corruption.ticking&!in_flight&dot.corruption.refreshable
actions+=/vile_taint,if=(soul_shard>1|active_enemies>2)&cooldown.summon_darkglare.remains>12
actions+=/siphon_life,if=refreshable
actions+=/unstable_affliction,if=refreshable
actions+=/unstable_affliction,if=azerite.cascading_calamity.enabled&buff.cascading_calamity.remains<3
actions+=/corruption,if=(active_enemies<3|talent.vile_taint.enabled|talent.writhe_in_agony.enabled&!talent.sow_the_seeds.enabled)&refreshable
actions+=/haunt
actions+=/malefic_rapture,if=soul_shard>4
actions+=/siphon_life,cycle_targets=1,if=active_enemies>1,target_if=dot.siphon_life.remains<3
actions+=/corruption,cycle_targets=1,if=active_enemies<3|talent.vile_taint.enabled|talent.writhe_in_agony.enabled&!talent.sow_the_seeds.enabled,target_if=dot.corruption.remains<3
actions+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
actions+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
actions+=/call_action_list,name=cooldowns
actions+=/call_action_list,name=item
actions+=/call_action_list,name=se,if=debuff.shadow_embrace.stack<(3-action.shadow_bolt.in_flight)|debuff.shadow_embrace.remains<3
actions+=/malefic_rapture,if=dot.vile_taint.ticking
actions+=/malefic_rapture,if=talent.phantom_singularity.enabled&(dot.phantom_singularity.ticking||cooldown.phantom_singularity.remains>12||soul_shard>3)
actions+=/malefic_rapture,if=talent.sow_the_seeds.enabled
actions+=/drain_life,if=buff.inevitable_demise.stack>30|buff.inevitable_demise.up&time_to_die<5
actions+=/drain_life,if=buff.inevitable_demise_az.stack>30
actions+=/drain_soul
actions+=/shadow_bolt

    ]]

    local function actionList_Rotation()
        ------------------------------------------------
        --SpellQueueReady ------------------------------
        ------------------------------------------------
        if spellQueueReady() then
            if dsTarget ~= nil and (not cast.current.drainSoul() or (cast.current.drainSoul() and dsInterrupt)) and not moving and shards < 5 then
                if cast.drainSoul(dsTarget) then
                    dsInterrupt = false
                    return true
                end
            end

            if not moving and seedTargetsHit <= 2 then
                if cast.haunt() then return true end
            end

            if getSpellCD(spell.summonDarkglare) == 0 and useCDs() and debuff.agony.exists() and debuff.corruption.exists() and (debuff.unstableAffliction.exists() or shards == 5) and (not talent.phantomSingularity or (talent.phantomSingularity and (cd.phantomSingularity.remain() > 0 or aoeUnits < getOptionValue("PS Units") or mode.ps ~= 1))) then
                CastSpellByName(GetSpellInfo(spell.summonDarkglare))
                return true
            end

            ------------------------------------------------
            -- AoE Rotation --------------------------------
            ------------------------------------------------
            if aoeUnits >= ui.value("Multi-Target Units") and mode.single ~= 1 then if actionList_AoE() then return end end
        if ui.checked("Curse of Tongues") then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if isHealer(unit) and canCurse(unit, CoT) then
                    return true
                end
            end
        end
            ------------------------------------------------
            -- Agony ---------------------------------------
            ------------------------------------------------
            if not debuff.agony.exists("target") and ttd("target") > 10 then
                if cast.agony("target") then return true end
            end

            if ui.checked("Spread Agony on ST") and agonyCount < 6 and agonyCount < ui.value("Agony Count") then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if not debuff.agony.exists(thisUnit) and ttd(thisUnit) > 10 and not noDotCheck(thisUnit) then
                        if cast.agony(thisUnit) then return true end
                    end
                end
            end

            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if ttd(thisUnit) > 10 and debuff.agony.exists(thisUnit) and debuff.agony.remains(thisUnit) <= 7.5 then
                    if cast.agony(thisUnit) then return true end
                end
            end

            ------------------------------------------------
            -- Unstable Affliction -------------------------
            ------------------------------------------------
            if not moving and debuff.unstableAffliction.remains("target") <= 10 + cast.time.unstableAffliction() and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 and br.timer:useTimer("UA", 1.5) then
               if cast.unstableAffliction("target") then br.addonDebug("[Action:Rotation] Unstable Affliction [Refresh]") return true end
            end

            -- actions+=/call_action_list,name=darkglare_prep,if=active_enemies>2&cooldown.summon_darkglare.ready&(dot.phantom_singularity.ticking|!talent.phantom_singularity.enabled)

            ------------------------------------------------
            -- Seed of Corruption, ST ----------------------
            ------------------------------------------------

            ------------------------------------------------
            -- Seed of Corruption, ST ----------------------
            ------------------------------------------------
        if aoeUnits >= ui.value("Multi-Target Units") then
            if not moving and debuff.corruption.remain(seedTarget) <= cast.time.seedOfCorruption() and debuff.seedOfCorruption.count() == 0 and not cast.last.seedOfCorruption(1) and not cast.last.seedOfCorruption(2) then
                if cast.seedOfCorruption(seedTarget) then return true end
            end
            -- actions+=/seed_of_corruption,if=variable.spammable_seed
            if mode.ss == 3 and not moving and br.timer:useTimer("SoC Spam", ui.value("SoC Spam Delay")) then
               if cast.seedOfCorruption(seedTarget) then return true end
            end
        end
            ------------------------------------------------
            -- Agony on seed if missing --------------------
            ------------------------------------------------
            if not debuff.agony.exists(seedTarget) and debuff.seedOfCorruption.exists(seedTarget) then
                if cast.agony(seedTarget) then return true end
            end
            -- actions+=/seed_of_corruption,if=active_enemies>2&!talent.vile_taint.enabled&(!talent.writhe_in_agony.enabled|talent.sow_the_seeds.enabled)&!dot.seed_of_corruption.ticking&!in_flight&dot.corruption.refreshable
            --[[if not moving and aoeUnits > 2 and not talent.vileTaint and (not talent.writheInAgony or talent.sowTheSeeds) and not debuff.seedOfCorruption.exists("target") and not cast.inFlight.seedOfCorruption() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not noDotCheck(thisUnit) and debuff.corruption.refresh(thisUnit) and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                        if cast.seedOfCorruption(thisUnit) then br.addonDebug("[Action:AoE] Seed of Corruption, not Talent Sow The Seeds [Multi]") return true end
                    end
                end
            end--]]

            --actions+=/vile_taint,if=(soul_shard>1|active_enemies>2)&cooldown.summon_darkglare.remains>12
            --cast.timeSinceLast.unstableAffliction() >= 3 

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
            -- Summon Darkglare ----------------------------
            ------------------------------------------------
            --actions+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)

            --actions+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
            ------------------------------------------------
            -- Dark Soul -----------------------------------
            ------------------------------------------------
            -- Dark Soul
            if talent.darkSoul and useCDs() or isChecked("Cooldowns Hotkey") and SpecificToggle("Cooldowns Hotkey") and not moving and cd.summonDarkglare.remain() > ttd then
                if cast.darkSoul() then br.addonDebug("Casting Dark Soul") return true end
            end 
            -- Dark Soul
            if talent.darkSoul and useCDs() and not moving and pet.darkglare.active() then
                if cast.darkSoul() then br.addonDebug("[Action:Rotation] Dark Soul (Darkglare Active)") return true end
            end 

            ------------------------------------------------
            -- Phantom Singularity -------------------------
            ------------------------------------------------
            if talent.phantomSingularity then 
                if cast.phantomSingularity() then br.addonDebug("[Action:Rotation] Phantom Singularity") return true end 
            end

            ------------------------------------------------
            -- Vile Taint ----------------------------------
            ------------------------------------------------
            if not moving and talent.vileTaint and shards > 1 or aoeUnits > 2 then
                if cast.vileTaint("target") then br.addonDebug("[Action:Rotation] Vile Taint") return true end
            end

            ------------------------------------------------
            -- Cooldowns -----------------------------------
            ------------------------------------------------
            if actionList_Cooldowns() then return end 


            --actions+=/call_action_list,name=se,if=debuff.shadow_embrace.stack<(3-action.shadow_bolt.in_flight)|debuff.shadow_embrace.remains<3
            -- Shadowlands

            ------------------------------------------------
            -- Malefic Rapture, Max Shards -----------------
            ------------------------------------------------
            if not moving and shards > 0 and getDistance("target") <= 40 then
                if shards > 4 then 
                    if cast.maleficRapture() then br.addonDebug("[Action:Rotation] Malefic Rapture (Max Shards)") return true end 
                end 
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
            if not moving and shards > 0 and getDistance("target") <= 40 then
                -- Malefic Rapture, Phantom Singularity
                if debuff.phantomSingularity.exists("target") or (cd.phantomSingularity.remain() > 12 or shards > 3) then 
                   if cast.maleficRapture() then br.addonDebug("[Action:Rotation] Malefic Rapture, Phantom Singularity") return true end 
                end 

                -- Malefic Rapture, Vile Taint
                if debuff.vileTaint.exists("target") then 
                    if cast.maleficRapture() then br.addonDebug("[Action:Rotation] Malefic Rapture, Vile Taint") return true end 
                end 
               
                -- Malefic Rapture, Sow The Seeds
                if talent.sowTheSeeds then
                   if cast.maleficRapture() then br.addonDebug("[Action:Rotation] Malefic Rapture, Sow The Seeds") return true end 
                end
            end

          
            -- actions+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)

            ------------------------------------------------
            -- Drain Life, Inevitable Demise > 30, TTD < 5 -
            ------------------------------------------------
            -- actions+=/drain_life,if=buff.inevitable_demise.stack>30|buff.inevitable_demise.up&time_to_die<5
            if not moving and talent.inevitableDemise and buff.inevitableDemise.stack() >= 30 or buff.inevitableDemise.exists() and ttd("target") < 5 and br.timer:useTimer("ID Delay", 5) then
                if cast.drainLife() then br.addonDebug("[Action:Rotation] Drain Life (ID and TTD < 5)") return true end
            end

            ------------------------------------------------
            -- Drain Life, Inevitable Demise > 30 ----------
            ------------------------------------------------
            -- actions+=/drain_life,if=buff.inevitable_demise_az.stack>30
            if not moving and talent.inevitableDemise and buff.inevitableDemise.stack() >= 30 and br.timer:useTimer("ID Delay", 5) then
                if cast.drainLife() then br.addonDebug("[Action:Rotation] Drain Life (ID > 30)") return true end
            end

            ------------------------------------------------
            -- Drain Soul ----------------------------------
            ------------------------------------------------
            --if not moving and not cast.current.drainSoul() then
           --     if cast.drainSoul("target") then return true end
           -- end
            if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and debuff.unstableAffliction.remains("target") <= 8 then SpellStopCasting() end

            if not moving and not cast.current.drainSoul() then
                if cast.drainSoul() then
                    dsInterrupt = true
                    return true 
                end
            end

            ------------------------------------------------
            -- Shadow Bolt ---------------------------------
            ------------------------------------------------
            if cast.able.shadowBolt() and not moving then
                if cast.shadowBolt("target") then return true end
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
            if useCDs() and isChecked("Pre-Pull Logic") and GetObjectExists("target") and getDistance("target") < 40 then
                    if isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
                        use.battlePotionOfIntellect()
                    end
                    if ppDb == false then
                        if cast.haunt("target") then
                            ppDb = true
                            return true
                        end
                    end
            end -- End Pre-Pull

                    -- Pet Attack/Follow
                --    if mode.pc ~= 2 and isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
                   --     PetAssistMode()
                    --    PetAttack("target")
                --    end
            if getOptionValue("Soulstone") == 7 then -- Player
                if not UnitIsDeadOrGhost("player") then
                    if cast.soulstone("player") then br.addonDebug("Casting Soulstone [Player]" ) return true end
                end
            end

            if isChecked("Pet Management") and not talent.grimoireOfSacrifice and not UnitAffectingCombat("pet") and mode.pc ~= 2 and hastar and UnitCanAttack("target", "player") then
                PetAssistMode()
                PetAttack("target")
            end

            -- Create Healthstone
            if ui.checked("Create Healthstone") and GetItemCount(5512) < 1 or itemCharges(5512) < 3 then
                if cast.createHealthstone() then br.addonDebug("Casting Create Healthstone" ) return true end
            end

            -- Auto Engage
            if ui.checked("Auto Engage") and not inCombat and getDistance("target") <= 40 and getFacing("player","target") and br.timer:useTimer("Agony Delay", 2) then
                if cast.agony() then br.addonDebug("Casting Agony [Auto Engage]") return true end

            -- actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3&!equipped.169314
            if not moving and pullTimer <= 3 and br.timer:useTimer("SoC Delay", 3) and aoeUnits >= ui.value("Pre-Pull SoC Count") and ui.checked("Pre-Pull SoC") then
                CastSpellByName(GetSpellInfo(spell.seedOfCorruption)) br.addonDebug("Casting Seed of Corruption [Pre-Pull]") return
            elseif pullTimer <= 2 and br.timer:useTimer("Haunt Delay", 2) and GetUnitExists("target") then
                if talent.haunt and ui.value("Pre-Pull Spell") ~= 2 and ui.value("Pre-Pull Spell") ~= 3 then    
                    CastSpellByName(GetSpellInfo(spell.haunt)) br.addonDebug("Casting Haunt [Pre-Pull]") return
                end
                if ui.value("Pre-Pull Spell") ~= 1 and ui.value("Pre-Pull Spell") ~= 3 then
                    CastSpellByName(GetSpellInfo(spell.shadowBolt)) br.addonDebug("Casting Shadowbolt [Pre-Pull]") return
                end
            end
            end
        end -- End No Combat
    end -- End Action List - PreCombat

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif (inCombat and profileStop == true) or IsMounted() or IsFlying() or pause(true) or mode.rotation == 4 then
        
        --if mode.pc == 2 then PetStopAttack() PetFollow() return true end 

        if not pause(true) and not talent.grimoireOfSacrifice and IsPetAttackActive() and isChecked("Pet Management") then
            PetStopAttack()
            PetFollow()
        end
        return true
      --  return true
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
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList_PreCombat() then
            return
        end

        if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and debuff.unstableAffliction.remains("target") <= 12 + cast.time.unstableAffliction() then
         --  SpellStopCasting()
            if not moving 
            and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
           -- and not cast.current.unstableAffliction()
            and br.timer:useTimer("UA", 1.3) 
           -- and cast.timeSinceLast.unstableAffliction() >= 3
           -- and not cast.last.unstableAffliction(2)
            then
               if cast.unstableAffliction("target") then br.addonDebug("[Action:Rotation] Unstable Affliction, Clipped DS [Refresh]") return true end
            end
        end

        if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) 
        and debuff.unstableAffliction.remains("target") >= 11
        and debuff.phantomSingularity.remains("target") >= cast.time.maleficRapture() + gcd 
        or debuff.vileTaint.remains("target") >= cast.time.maleficRapture() + gcdMax and shards > 0 
        then
              --SpellStopCasting()
            if not moving and cast.able.maleficRapture()
           -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
           -- and not cast.current.unstableAffliction()
           -- and br.timer:useTimer("UA", 1.5) 
           -- and cast.timeSinceLast.unstableAffliction() >= 3
           -- and not cast.last.unstableAffliction(2)
            then
               if cast.maleficRapture("target") then br.addonDebug("[Action:Rotation] MaleficRapture, Clipped DS") return true end
            end
        end

        if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) 
        --and debuff.unstableAffliction.remains("target") >= 11
        and cd.haunt.remain() <= gcdMax
        then
              --SpellStopCasting()
            if not moving
           -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
           -- and not cast.current.unstableAffliction()
           -- and br.timer:useTimer("UA", 1.5) 
           -- and cast.timeSinceLast.unstableAffliction() >= 3
           -- and not cast.last.unstableAffliction(2)
            then
               if cast.haunt("target") then br.addonDebug("[Action:Rotation] Haunt, Clipped DS") return true end
            end
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and profileStop == false and getDistance("target") < 40 and not cast.current.unstableAffliction() and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then return end

            if br.queueSpell then
                ChatOverlay("Pausing for queuecast")
                return true 
            end

            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if getOptionValue("APL Mode") == 1 and not pause() then
                -- Pet Attack
                if isChecked("Pet Management") and mode.pc ~= 2 and not GetUnitIsUnit("pettarget", "target") and hastar and UnitCanAttack("target", "player") then
                   PetAttack()
               end

                -- rotation
                if actionList_Rotation() then return end
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
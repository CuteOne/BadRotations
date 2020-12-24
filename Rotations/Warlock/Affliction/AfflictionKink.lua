local rotationName = "KinkAffliction"
local VerNum  = "1.8.0"
local colorPurple = "|cff8788EE"
local colorOrange    = "|cffFFBB00"
local dsInterrupt = false
local ExhaustionUnits="165762"
local DontDotUnits="171557"
----------------------------------------------------
-- Credit and huge thanks to: Fiskee for the basis of this rotation/API
----------------------------------------------------
--[[

╲⎝⧹ ADSpirit ⧸⎠╱ | adspirit#2405 - Mods and Fixes

Damply#3489 - Tester

.G.#1338 - Tester

Netpunk | Ben#7486 - Tester

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
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple.", highlight = 1, icon = br.player.spell.agony},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bladestorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.furiousSlash },
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
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spellLock},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spellLock}
    };
    CreateButton("Interrupt",4,0)

    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker.", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "3", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter.", highlight = 1, icon = br.player.spell.summonFelhunter },
        [4] = { mode = "4", value = 4 , overlay = "Succubus", tip = "Summon Succubus.", highlight = 1, icon = br.player.spell.summonSuccubus },
        [5] = { mode = "None", value = 5 , overlay = "No pet", tip = "Dont Summon any Pet.", highlight = 0, icon = br.player.spell.conflagrate }
    };
    CreateButton("PetSummon",3,1)

    -- Seed of Corruption button
    SeedOfCorruptionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Seed of Corruption Enabled", tip = "Will cast Seed of Corruption.", highlight = 1, icon = br.player.spell.seedOfCorruption},
        [2] = { mode = "Off", value = 2 , overlay = "Seed of Corruption Disabled", tip = "Will not cast Seed of Corruption.", highlight = 0, icon = br.player.spell.seedOfCorruption}
    };
    CreateButton("SeedOfCorruption",4,1)

    -- Burning Rush button
    BurningRushModes = {
        [1] = { mode = "On", value = 1 , overlay = "Burning Rush Enabled", tip = "Burning Rush Enabled.", highlight = 1, icon = br.player.spell.burningRush},
        [2] = { mode = "Off", value = 2 , overlay = "Burning Rush Disabled", tip = "Burning Rush Disabled.", highlight = 0, icon = br.player.spell.burningRush}
    };
    CreateButton("BurningRush",1,1)

    -- Dot Blacklist button
    DotBlacklistModes = {
        [1] = { mode = "On", value = 1 , overlay = "Dot Blacklist Enabled", tip = "Dot Blacklist Enabled.", highlight = 1, icon = br.player.spell.corruption},
        [2] = { mode = "Off", value = 2 , overlay = "Dot Blacklist Disabled", tip = "Dot Blacklist Disabled.", highlight = 0, icon = br.player.spell.corruption}
    };
    CreateButton("DotBlacklist",2,1)

    -- MultiDotting button
    MultiDotModes = {
        [1] = { mode = "On", value = 1 , overlay = "Multi-Dotting Enabled", tip = "Multi-Dotting Enabled.", highlight = 1, icon = br.player.spell.siphonLife},
        [2] = { mode = "Off", value = 2 , overlay = "Multi-Dotting Disabled", tip = "Multi-Dotting Disabled.", highlight = 0, icon = br.player.spell.siphonLife}
    };
    CreateButton("MultiDot",5,1)

    -- Fear Toggle
    FearModes = {
        [1] = { mode = "On", value = 1 , overlay = "Fear Local Units Enabled", tip = "Fear Local Units Enabled.", highlight = 1, icon = br.player.spell.fear},
        [2] = { mode = "Off", value = 2 , overlay = "Fear Local Units Disabled", tip = "Fear Local Units Disabled.", highlight = 0, icon = br.player.spell.fear}
    };
    CreateButton("Fear",5,0)
    

end

---------------
--- OPTIONS ---
---------------
local function createOptions ()
	local optionTable

	local function rotationOptions ()
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
        section = br.ui:createSection(br.ui.window.profile,  colorPurple .. "Affliction " .. ".:|:. " .. " General " .. "Ver " ..colorOrange .. VerNum .. colorPurple .." .:|:. ")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFBB00SimC", "|cffFFBB00Leveling"}, 1, "|cffFFBB00Set APL Mode to use.")

            -- Auto target
            br.ui:createCheckbox(section, "Auto Target", "|cffFFBB00 Will auto change to a new target, if current target is dead")

            -- Multi-Target Units
            br.ui:createSpinnerWithout(section, "Multi-Target Units", 3, 1, 25, 1, "|cffFFBB00Health Percentage to use at.")

            -- Burning Rush Health Cancel Percent
            br.ui:createSpinnerWithout(section, "Burning Rush Health", 79, 1, 100, 1, "|cffFFBB00Health Percentage to cancel at.")

            -- Burning Rush Health Cancel Percent
            br.ui:createSpinnerWithout(section, "Burning Rush Delay", 6, 1, 10, 0.1, "|cffFFBB00Delay between casting Burning Rush")

            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFBB00Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

            -- Auto Engage
            br.ui:createCheckbox(section,"Auto Engage")

            -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFBB00 Select to enable/disable auto pet management")

            -- Pet Summon Delay
            br.ui:createSpinnerWithout(section, "Summon Pet Delay", 1, 1, 10, 0.1, "|cffFFBB00Delay between Pet Summons")

            -- Fel Domination
            br.ui:createCheckbox(section, "Fel Domination", "|cffFFBB00 Toggle the auto casting of Fel Donmination")

            -- Unending Breath
            br.ui:createCheckbox(section, "Unending Breath", "|cffFFBB00 Toggle the auto casting of Unending Breath on party if swimming or submerged")

            -- Curse of Tongues
            --br.ui:createCheckbox(section, "Curse of Tongues")
            
            -- Curse of Weakness
            --br.ui:createCheckbox(section, "Curse of Weakness")
            
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer", 2, 0, 10, 0.1, "Set desired time offset to opener (DBM Required). Min: 0 / Max: 10 / Interval: 0.1")

            -- Pre-Pull Spell
            br.ui:createDropdownWithout(section,"Pre-Pull Spell", {"|cffFFBB00Haunt","|cffFFBB00Shadow Bolt","|cffFFBB00None"}, 1, "|cffFFBB00Set Pre-Pull Spell to cast.")

            -- Pre-Pull SoC
            br.ui:createCheckbox(section, "Pre-Pull SoC", "|cffFFBB00 Toggle the use of casting Seed of corruption on pre-pull w/ >= 3 enemies.")
            
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
            
            -- Seef of Corruption
            br.ui:createCheckbox(section, "Spam Seed of Corruption", "Check to spam SoC if SoC is talented")
            br.ui:createSpinner(section, "SoC Spam Delay", 0.1, 0, 10, 0.1, "Set desired delqy between SoC casts during SoC Spam. Min: 0 / Max: 10 / Interval: 0.1")
           
            -- Unstable Affliction Mouseover
            --br.ui:createCheckbox(section, "Mousever UA", "Toggles casting unstable Affliction to your mouseover target")
            br.ui:createText(section, "|cffFFBB00.:|:. |cffFF0000Dots Refresh Time |cffFFBB00.:|:.")
            -- Refresh Times
            br.ui:createSpinnerWithout(section, "Agony Refresh", 7, 1, 25, 0.1, "The remaining time when to refresh Agony. Standard is 7")   
            br.ui:createSpinnerWithout(section, "Corruption Refresh", 7, 1, 25, 0.1, "The remaining time when to refresh Corruption. Standard is 7")   
            br.ui:createSpinnerWithout(section, "UA Refresh", 8.5, 1, 25, 0.1, "The remaining time when to refresh Unstable Affliction. Standard is 8.5")   
            br.ui:createSpinnerWithout(section, "Siphon Life Refresh", 8, 1, 25, 0.1, "The remaining time when to refresh Siphon Life. Standard is 8")   

            -- Max Dots
            br.ui:createText(section, "|cffFFBB00.:|:. |cffFF0000Multi-Dotting Enemy Count |cffFFBB00.:|:.")
            br.ui:createSpinnerWithout(section, "Agony Count", 4, 1, 10, 1, "The maximum amount of running Agony.")   
            br.ui:createSpinnerWithout(section, "Corruption Count", 4, 1, 10, 1, "The maximum amount of running Corruption.")
            br.ui:createSpinnerWithout(section, "Siphon Life Count", 4, 1, 10, 1, "The maximum amount of running Siphon Life. Standard is 8")
                
        br.ui:checkSectionState(section)

		-------------------------
        --- OFFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Affliction .:|:. Offensive")

            -- Darkglare
            br.ui:createDropdown(section, "Darkglare", {"|cffFFBB00Auto", "|cffFFBB00Max-Dot Duration",	"|cffFFBB00On Cooldown"}, 1, "|cffFFBB00When to cast Darkglare")

			-- Agi Pot
            br.ui:createCheckbox(section, "Potion", "Use Potion")

            -- Augment
            br.ui:createCheckbox(section, "Augment", "Use Augment")

            -- Racial
            br.ui:createCheckbox(section, "Racial", "Use Racial")
            
			-- Trinkets
            br.ui:createCheckbox(section, "Trinkets", "Use Trinkets")

            -- Malefic Rapture
            br.ui:createSpinner(section, "Malefic Rapture TTD", 20, 1, 100, 1, "The TTD to be <= to inside a raid/instance to start casting MR to burn")

            -- Malefic Rapture
            --br.ui:createSpinner(section, "Malefic Rapture BloodLust", "Cast Malefic Rapture during bloodlust if you have at least 1 shard")

            -- Haunt TTD
            br.ui:createSpinner(section, "Haunt TTD", 6, 1, 15, 1, "The TTD before casting Haunt")


            -- Phantom of Singularity TTD
            --br.ui:createSpinner(section, "Phantom of Singularity TTD", 6, 1, 15, 1, "The TTD before casting Phantom of Singularity")

            -- Vile Taint TTD
            --br.ui:createSpinner(section, "Vile Taint TTD", 6, 1, 15, 1, "The TTD before casting Vile Taint")
                        
            -- Drain Soul Canceling
            --br.ui:createSpinner(section, "Drain Soul Clipping", 4, 1, 5, 1, "The tick of Drain Soul to cancel the cast at (5-6 ticks total)", true)

            -- Unstable Affliction Priority Mark
            --br.ui:createDropdown(section, "Priority Unit", { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffFFBB00Moon", "|cff0000ffSquare", "|cffff0000Cross", "|cffFFBB00Skull" }, 8, "Mark to Prioritize",true)
        br.ui:checkSectionState(section)
        
        -------------------------
		---- HOTKEYS OPTIONS ----
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Hotkeys")
            -- Demonic Gateway Key
            br.ui:createDropdown(section, "Demonic Gateway", br.dropOptions.Toggle, 6)

            -- Demonic Circle Summon Key
            br.ui:createDropdown(section, "Demonic Circle Summon", br.dropOptions.Toggle, 6)

            -- Demonic Circle Teleport Key
            br.ui:createDropdown(section, "Demonic Circle Teleport", br.dropOptions.Toggle, 6)

            -- Dark Soul Key
            br.ui:createDropdown(section, "Dark Soul: Misery", br.dropOptions.Toggle, 6)

            -- Cooldowns Key
            br.ui:createDropdown(section, "Cooldowns", br.dropOptions.Toggle, 6)

            -- Shadow Fury Key
            br.ui:createDropdown(section, "Shadowfury", br.dropOptions.Toggle, 6)
           
            -- Shadowfury Target
            br.ui:createDropdownWithout(section, "Shadowfury Target", {"|cffFFBB00Best", "|cffFFBB00Target", "|cffFFBB00Cursor"}, 1, "|cffFFBB00Shadowfury target")
        br.ui:checkSectionState(section)

        -------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Defensive")
            -- Soulstone
		    br.ui:createDropdown(section, "Soulstone", {"|cffFFBB00Target","|cffFFBB00Mouseover","|cffFFBB00Tank", "|cffFFBB00Healer", "|cffFFBB00Healer/Tank", "|cffFFBB00Any", "|cffFFBB00Player"},
            1, "|cffFFBB00Target to cast on")
            
            --Fear Solo Farming
            br.ui:createSpinner(section, "Fear Bonus Mobs",   7,  0,  15,  1,  "|cffFFBB00Toggle the use of auto casting fear when solo farming.")

            --- Healthstone Creation
            br.ui:createSpinner(section, "Create Healthstone",  3,  0,  3,  5,  "|cffFFBB00Toggle creating healthstones, and how many in bag before creating more")

            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  45,  0,  100,  5,  "|cffFFBB00Health Percent to Cast At")

            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFBB00Health Percent to Cast At")
            end

            -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

            -- Mortal Coil 
            br.ui:createSpinner(section, "Mortal Coil",  23,  0,  100,  5,  "|cffFFBB00Health Percent to Cast At")

            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 48, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel", 50, 0, 100, 5, "|cffFFBB00Health Percent of Demon to Cast At")

            br.ui:createSpinnerWithout(section, "Health Funnel", 50, 0, 100, 5, "|cffFFBB00Health Percent of Player to Cast At")

            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

            -- Devour Magic
            br.ui:createDropdown(section,"Devour Magic", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        br.ui:checkSectionState(section)

        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Affliction .:|:. Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percent to Cast At")
        br.ui:checkSectionState(section)
    end
    local function listsOptions()
        -------------------------
        ----  Lists Options -----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Lists Options")
        -- No Dot units
        br.ui:createScrollingEditBoxWithout(section,"Dot Blacklist Units", dotBlacklist, "List of units to blacklist when multidotting", 240, 40)
        -- Curse of Exhaustion
        br.ui:createSpinner(section, "Curse of Exhaustion", 2, 1, 10, 1, "|cffFFBB00Number of enemies to cast Curse of Exhaustion at.")
        br.ui:createScrollingEditBoxWithout(section,"Exhaustion Units", exhaustionUnits, "List of units to cast Curse of Exhaustion on.", 240, 40)
        -- Fear
        br.ui:createCheckbox(section, "Fear", "Will cast fear on units around target.")
        br.ui:createScrollingEditBoxWithout(section,"Fear Units", Fear, "List of units to Fear.", 240, 40)
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
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    UpdateToggle("PetCommand", 0.25)
    UpdateToggle("BurningRush", 0.25)
    UpdateToggle("SeedOfCorruption", 0.25)
    UpdateToggle("DotBlacklist", 0.25)
    UpdateToggle("PetCommand", 0.25)

    br.player.ui.mode.pc = br.data.settings[br.selectedSpec].toggles["PetCommand"]
    br.player.ui.mode.ss = br.data.settings[br.selectedSpec].toggles["Single"]
    br.player.ui.mode.br = br.data.settings[br.selectedSpec].toggles["BurningRush"]
    br.player.ui.mode.soc = br.data.settings[br.selectedSpec].toggles["SeedOfCorruption"]
    br.player.ui.mode.summonPet = br.data.settings[br.selectedSpec].toggles["PetSummon"]
    br.player.ui.mode.dbl = br.data.settings[br.selectedSpec].toggles["DotBlacklist"]
    br.player.ui.mode.md = br.data.settings[br.selectedSpec].toggles["MultiDot"]


    --------------
    --- Locals ---
    --------------
    local activePet = br.player.pet
    local activePetId = br.player.petId
    local artifact = br.player.artifact
    local agonyCount = br.player.debuff.agony.count()
    local exhaustionCount = br.player.debuff.curseOfExhaustion.count()
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
    local fearCount = br.player.debuff.fear.count()
    local friendly = friendly or GetUnitIsFriend("target", "player")
    local gcd = br.player.gcdMax
    local gcdMax = br.player.gcdMax
    local hasMouse = GetObjectExists("mouseover")
    local hasteAmount = GetHaste() / 100
    local hasPet = IsPetActive()
    local healPot = getHealthPot()
    local heirloomNeck = 122663 or 122664
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local lastSpell = lastSpellCast
    local level = br.player.level
    local ui = br.player.ui
    local cl = br.read
    local lootDelay = getOptionValue("LootDelay")
    local manaPercent = br.player.power.mana.percent()
    local mode = br.player.ui.mode
    local moving = isMoving("player")
    local pet = br.player.pet
    local php = br.player.health
    local playerMouse = UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer = PullTimerRemain()
    local race = br.player.race
    local shards = UnitPower("player", Enum.PowerType.SoulShards)
    local summonPet = getOptionValue("Summon Pet")
    local solo = #br.friend == 1
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
    local tanks = getTanksTable()
    local covenant = br.player.covenant
    local anydots = debuff.agony.exists("target") or debuff.corruption.exists("target") or debuff.unstableAffliction.exists("target") or debuff.haunt.exists("target") or debuff.phantomSingularity.exists("target") or debuff.vileTaint.exists("target")

    actionList = {}

    units.get(40)
    enemies.get(10)
    enemies.get(10, "target", true) -- makes enemeis.yards10tnc
    enemies.get(10,"target") -- makes enemies.yards10t
    enemies.get(40, nil, nil, nil, spell.drainSoul)
    enemies.get(40,"player",false,true) -- makes enemies.yards40f


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

    
    -- Pet Data
    if mode.petSummon == 1 and HasAttachedGlyph(spell.summonImp) then summonId = 58959
    elseif mode.petSummon == 1 then summonId = 416
    elseif mode.petSummon == 2 and HasAttachedGlyph(spell.summonVoidwalker) then summonId = 58960
    elseif mode.petSummon == 2 then summonId = 1860
    elseif mode.petSummon == 3 then summonId = 417
    elseif mode.petSummon == 4 then summonId = 1863 end

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
            if UnitPowerMax(unit) >= 290000 and not UnitBuffID(unit, 24858) and not UnitBuffID(unit, 15473) and not UnitBuffID(unit, 324) then
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

    local icecrownRares = {
        [174065] = true, -- lood Queen Lana'thel
        [174064] = true, -- Professor Putricide
        [174063] = true, -- Lady Deathwhisper
        [174062] = true, -- Skadi the Ruthless
        [174061] = true, -- Ingvar the Plunderer
        [174060] = true, -- Prince Keleseth
        [174059] = true, -- The Black Knight
        [174058] = true, -- Bronjahm
        [174057] = true, -- Scourgelord Tyrannus
        [174056] = true, -- Forgemaster Garfrost
        [174055] = true, -- Marwyn
        [174054] = true, -- Falric
        [174053] = true, -- The Prophet Tharon'ja
        [174052] = true, -- Novos the Summoner
        [174051] = true, -- Trollgore
        [174050] = true, -- Krik'thir the Gatewatcher
        [174049] = true, -- Prince Taldaram
        [174048] = true, -- Elder Nadox
        [174047] = true, -- Noth the Plaguebringer
        [174046] = true  -- Patchwerk
    }

    local function isRare(unit)
        if icecrownRares[GetObjectID(unit)] then return true end 
        return false
    end

    local coeUnits = {}
    for i in string.gmatch(getOptionValue("Exhaustion Units"), "%d+") do
        coeUnits[tonumber(i)] = true
    end

    local function isExhaust(unit)
        if isChecked("Curse of Exhaustion") and exhaustionCount < ui.value("Curse of Exhaustion") and coeUnits[GetObjectID(unit)] then return true end 
        return false
    end

    local noDotUnits = {}
    for i in string.gmatch(getOptionValue("Dot Blacklist Units"), "%d+") do
        noDotUnits[tonumber(i)] = true
    end

    local function noDotCheck(unit)
        if mode.dbl ~= 2 then
            if (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then
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
        if isChecked("Auto Target") and inCombat and #enemyTable40 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable40[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable40[1].unit)
        end
    end

    --Keybindings
    local shadowfuryKey = false
    if getOptionValue("Shadowfury") ~= 1 then
        shadowfuryKey = _G["rotationFunction" .. (getOptionValue("Shadowfury") - 1)]
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
    --dsTicks = br.dsTicks
   -- dsMaxTicks = br.dsMaxTicks
    local seedHit = 0
    local seedCorruptionExist = 0
    local seedTargetCorruptionExist = 0
    local seedTargetsHit = 1
    local lowestShadowEmbrace = lowestShadowEmbrace or "target"
    local enemyTable40 = enemies.get(40, "player", true)


    local inBossFight = false
    for i = 1, #enemyTable40 do
        local thisUnit = enemyTable40[i].unit
        if isRare(thisUnit) or isBoss(thisUnit) or ttd("target") >= 30 then 
            inBossFight = true
        end
        if talent.drainSoul and debuff.shadowEmbrace.exists(thisUnit) then
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

        if SpecificToggle("Shadowfury") and isChecked("Shadowfury") and not GetCurrentKeyBoardFocus() then
            if getOptionValue("Shadowfury Target") == 1 then
                if cast.shadowfury("best", false, 1, 8) then
                    return
                end
            elseif getOptionValue("Shadowfury Target") == 2 then
                if cast.shadowfury("target", "ground") then
                    return
                end
            elseif getOptionValue("Shadowfury Target") == 3 and getSpellCD(spell.shadowfury) == 0 then
                CastSpellByName(GetSpellInfo(spell.shadowfury), "cursor")
                return
            end
        end

        -- Demonic Gateway
        if SpecificToggle("Demonic Gateway") and not GetCurrentKeyBoardFocus() then
            if br.timer:useTimer("RoF Delay", 1) and CastSpellByName(GetSpellInfo(spell.demonicGateway),"cursor") then br.addonDebug("Casting Demonic Gateway") return end 
            if IsAoEPending() then CancelPendingSpell() end
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

        local fearUnits = {}
        for i in string.gmatch(getOptionValue("Fear Units"), "%d+") do
            fearUnits[tonumber(i)] = true
        end
    
        if isChecked("Fear") and mode.fear ~= 2 then
            for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
                if GetObjectExists(thisUnit) and fearUnits[GetObjectID(thisUnit)] then
                    if not UnitIsUnit(thisUnit,"target") and not moving and not debuff.fear.exists(thisUnit) and fearCount < 1 then
                        if cast.fear(thisUnit) then br.addonDebug("Fearing unit.") return true end
                    end 
                end
            end
        end
        
        -- --Soulstone
        -- if isChecked("Auto Soulstone Mouseover") and not moving and not inCombat and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
        --     if cast.soulstone("mouseover", "dead") then
        --         return true
        --     end
        -- end

        -- if isChecked("Auto Soulstone Player") and not inInstance and not inRaid and (not buff.soulstone.exists("player") or buff.soulstone.remain("player") < 100) and not inCombat and not moving then
        --     if cast.soulstone("player") then
        --         return
        --     end
        -- end

        -- Unending Breath
        if isChecked("Unending Breath") and br.timer:useTimer("UB Delay", math.random(1, 10)) then
            for i = 1, #br.friend do
                if not buff.unendingBreath.exists(br.friend[i].unit,"any") and IsSubmerged(br.friend[i].unit) or IsSwimming(br.friend[i].unit) and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                    if cast.unendingBreath() then return true end
                end
            end
        end

        -- Burning Rush
        if mode.br ~= 2 and not (IsSwimming() or IsFlying() or IsFalling())then
            if buff.burningRush.exists() and not moving or buff.burningRush.exists() and php <= ui.value("Burning Rush Health") then RunMacroText("/cancelaura Burning Rush") br.addonDebug("Canceling Burning Rush") return true end 
    
            if mode.burningRush ~= 2 and br.timer:useTimer("Burning Rush Delay", getOptionValue("Burning Rush Delay")) and moving and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end
    
            if mode.burningRush == 3 and br.timer:useTimer("Burning Rush Delay", getOptionValue("Burning Rush Delay")) and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end
        end  

        -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
        if talent.grimoireOfSacrifice and not buff.grimoireOfSacrifice.exists() and isChecked("Pet Management") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") then
            if CastSpellByID(108503, "player") then ui.debug("Casting Grimoire of Sacrifice")
                return
            end
        end
        
        -- Fear Bonus Mobs
        if ui.checked("Fear Bonus Mobs") and not cast.last.fear() and debuff.fear.count() < 1 and inCombat then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local thisHP = getHP(thisUnit)
                if (not moving and i > 1 and not debuff.fear.exists(thisUnit) and thisHP > 80) or getTTD(thisUnit,20) >= 3 then
                    if cast.fear(thisUnit) then br.addonDebug("Fearing bonus mobs") return true end
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

            --for i = 1, #enemyTable40 do 
            --    local unit = enemyTable40[i].unit
            --    if isRare(unit) then return true end 
           -- end

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
            if solo and isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") and not moving then
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
        if useInterrupts() and (pet.active.id() == 417) then
            for i=1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if pet.active.id() == 417 then
                        if CastSpellByName(GetSpellInfo(119910),thisUnit) then return true end
                    end
                end
            end
        end -- End useInterrupts check
    end -- End Interrupts ActionList

    -- Action List - Cooldowns
    local function actionList_Cooldowns()
        if getDistance(units.dyn40) < 40 and useCDs() then

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
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" then
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
    
    local function actionList_AoE()
        ------------------------------------------------
        -- Malefic Rapture Max Shards ------------------
        ------------------------------------------------
        -- if not moving then
        --     if anydots and shards > 4 then
        --         if cast.maleficRapture("target") then br.addonDebug("[Action:AoE] Malefic Rapture (Max Shards)") return true end 
        --     end
        -- end
        ------------------------------------------------
        -- Seed of Corruption, No STS Talent -----------
        ------------------------------------------------
        if mode.soc ~= 2 and getDistance(units.dyn40) < 40 and #enemies.yards10t >= ui.value("Multi-Target Units") then
            for i = 1, #enemies.yards10t do
            local thisUnit = enemies.yards10t[i]
                if not UnitIsUnit(thisUnit,"target") and not moving and debuff.corruption.remain(thisUnit) <= cast.time.seedOfCorruption()+3 and debuff.seedOfCorruption.count() == 0 and not cast.last.seedOfCorruption(1) and not cast.last.seedOfCorruption(2) then
                    if cast.seedOfCorruption("target") then br.addonDebug("[Action:AoE] Seed of Corruption") return true end
                end
            end
        end
        ------------------------------------------------
        -- Seed of Corruption, Sow The Seeds -----------
        ------------------------------------------------
        -- actions.aoe+=/seed_of_corruption,if=talent.sow_the_seeds.enabled&can_seed
        if mode.soc ~= 2 and isChecked("Spam Seed of Corruption") and talent.sowTheSeeds and #enemies.yards10t >= ui.value("Multi-Target Units") and not moving and not cast.inFlight.seedOfCorruption() then
                if (not moving and not debuff.seedOfCorruption.exists(thisUnit) or not debuff.corruption.exists(thisUnit) and not debuff.seedOfCorruption.exists(thisUnit) and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) >= ui.value("Seed of Corruption TTD")
                and br.timer:useTimer("SoC Spam", ui.value("SoC Spam Delay")) then
                    if cast.seedOfCorruption(thisUnit) then br.addonDebug("[Action:AoE] Spamming Seed of Corruption") return true end
                end
        end
        ------------------------------------------------
        -- Cycle Exhaustion  ---------------------------
        ------------------------------------------------
        if ui.checked("Curse of Exhaustion") and exhaustionCount < ui.value("Curse of Exhaustion") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not noDotCheck(thisUnit) and not debuff.curseOfExhaustion.exists(thisUnit) and isExhaust(thisUnit) then
                    if cast.curseOfExhaustion(thisUnit) then br.addonDebug("[Action:AoE] Exhaustion [Multi-Cycle]") return true end
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
                if not noDotCheck(thisUnit) and debuff.agony.remains(thisUnit) <= ui.value("Agony Refresh") + 1.5 and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) and (not isExhaust(thisUnit)) then
                    if cast.agony(thisUnit) then br.addonDebug("[Action:AoE] Agony [Multi-Cycle]") return true end
                end
            end
        end
        ------------------------------------------------
        -- Cycle Siphon Life  --------------------------
        ------------------------------------------------
        -- actions.aoe+=/siphon_life,cycle_targets=1,if=active_dot.siphon_life<=3,target_if=!dot.siphon_life.ticking
        if siphonLifeCount < ui.value("Siphon Life Count") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not noDotCheck(thisUnit) and debuff.siphonLife.remains(thisUnit) <= ui.value("Siphon Life Refresh") + 1.5 and getTTD(thisUnit) > debuff.siphonLife.remain(thisUnit) + (3/spellHaste) then
                    if cast.siphonLife(thisUnit) then br.addonDebug("[Action:AoE] Siphon Life [Multi-Cycle]") return true end
                end
            end
        end
        ------------------------------------------------
        -- Cycle Corruption  --------------------------
        ------------------------------------------------
        if not talent.absoluteCorruption and corruptionCount < ui.value("Corruption Count") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not noDotCheck(thisUnit) and debuff.corruption.remains(thisUnit) <= ui.value("Corruption Refresh") + 1.5 and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) then
                    if cast.corruption(thisUnit) then br.addonDebug("[Action:AoE] Corruption [Multi-Cycle]") return true end
                end
            end
        end
        ------------------------------------------------
        -- Unstable Affliction -------------------------
        ------------------------------------------------
        -- actions.aoe+=/unstable_affliction,if=dot.unstable_affliction.refreshable
        if not moving and debuff.unstableAffliction.remains("target") <= ui.value("UA Refresh") + 1.5 and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 then
            if cast.unstableAffliction("target") then br.addonDebug("[Action:AOE] Unstable Affliction [Refresh]") lcast = GetTime() return true end
         end
        ------------------------------------------------
        -- Haunt ---------------------------------------
        ------------------------------------------------
        -- actions.aoe+=/haunt
        if not moving and talent.haunt and (cd.haunt.remain() <= gcdMax or debuff.haunt.remains() < 4) and getTTD("target") >= ui.value("Haunt TTD") then
            if cast.haunt("target") then br.addonDebug("[Action:AoE] Haunt") return true end
        end
        -- actions.aoe+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.ready&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
        ------------------------------------------------
        -- Soul Rot ------------------------------------
        ------------------------------------------------
        if covenant.nightFae.active and not moving and getDistance(units.dyn40) < 40 and #enemies.yards10t >= ui.value("Multi-Target Units") and ttd("target") > 7 and spellUsable(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax then
            if cast.soulRot() then br.addonDebug("[Action:AOE] Soul Rot") return true end
        end
        ------------------------------------------------
        -- Impending Catastrophe : Venthyr -------------
        ------------------------------------------------
        --321792
        if covenant.venthyr.active and not moving and getDistance(units.dyn40) < 40 and #enemies.yards10t >= ui.value("Multi-Target Units") and ttd("target") > 7 and spellUsable(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax then
            if cast.impendingCatastrophe() then br.addonDebug("[Action:AOE] Impending Catastrophe") return true end
        end
        ------------------------------------------------
        -- Vile Taint ----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/vile_taint,if=soul_shard>1
        if not moving and talent.vileTaint and shards > 1 then
            if cast.vileTaint(nil,"aoe",1,8,true) then br.addonDebug("[Action:AOE] Vile Taint") return true end
        end
        ------------------------------------------------
        -- Phantom Singularity -------------------------
        ------------------------------------------------
        -- actions.aoe=phantom_singularity
        if talent.phantomSingularity then 
            if cast.phantomSingularity() then br.addonDebug("[Action:AoE] Phantom Singularity") return true end 
        end
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
        if not moving and cast.able.maleficRapture() and not talent.vileTaint and shards > 4 and anydots then
            if cast.maleficRapture() then br.addonDebug("[Action:AoE] Malefic Rapture, Max Shards (Not Vile Taint Talent)") return true end 
        end
        ------------------------------------------------
        --- Malefic Rapture, Phantom of Singularity ----
        ------------------------------------------------
        -- actions.aoe+=/malefic_rapture,if=!talent.vile_taint.enabled
        if not moving and cast.able.maleficRapture() and debuff.phantomSingularity.exists("target") and shards > 0 then
            if cast.maleficRapture() then br.addonDebug("[Action:AoE] Malefic Rapture, Phantom of Singularity") return true end 
        end
        ------------------------------------------------
        -- Malefic Rapture, No Phantom of Singularity --
        ------------------------------------------------
        -- actions.aoe+=/malefic_rapture,if=!talent.vile_taint.enabled
        if not moving and cast.able.maleficRapture() and not talent.phantomSingularity and shards > 4 and anydots then
            if cast.maleficRapture() then br.addonDebug("[Action:AoE] Malefic Rapture, Max Shards (Not Phantom Talent)") return true end 
        end
        ------------------------------------------------
        -- Drain Soul Filler----------------------------
        ------------------------------------------------
        -- actions.aoe+=/drain_soul
        if not moving then
            if talent.vileTaint and not debuff.vileTaint.exists("target") and (not cd.vileTaint.ready() and shards < 5 or cd.vileTaint.ready() and shards <= 1) then   
                if cast.drainSoul() then br.addonDebug("[Action:AoE] Drain Soul Filler (Vile Taint)")
                    dsInterrupt = true
                    return true 
                end
            elseif talent.vileTaint and debuff.vileTaint.exists("target") and shards < 1 then   
                if cast.drainSoul() then br.addonDebug("[Action:AoE] Drain Soul Filler - Shards <= 1 (Vile Taint)")
                    dsInterrupt = true
                    return true 
                end
            elseif talent.phantomSingularity and not debuff.phantomSingularity.exists("target") and (not cd.phantomSingularity.ready() and shards < 5 or cd.phantomSingularity.ready() and shards <= 1) then   
                if cast.drainSoul() then br.addonDebug("[Action:AoE] Drain Soul Filler (Phantom)")
                    dsInterrupt = true
                    return true 
                end
            elseif talent.phantomSingularity and debuff.phantomSingularity.exists("target") and shards < 1 then   
                if cast.drainSoul() then br.addonDebug("[Action:AoE] Drain Soul Filler - Shards <= 1 (Phantom)")
                    dsInterrupt = true
                    return true 
                end
            elseif talent.seedOfCorruption and shards < 5 then   
                if cast.drainSoul() then br.addonDebug("[Action:AoE] Drain Soul Filler - (SoC)")
                    dsInterrupt = true
                    return true 
                end                            
            end
        end
        ------------------------------------------------
        -- Dark Soul -----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
        if talent.darkSoul and useCDs() and not moving and pet.darkglare.active() then
            if cast.darkSoul("player") then br.addonDebug("[Action:AoE] Dark Soul (Darkglare Active)") return true end
        end 
        if isChecked("Dark Soul: Misery") and SpecificToggle("Dark Soul: Misery") and not GetCurrentKeyBoardFocus() and not moving then
            if cast.darkSoul("player") then br.addonDebug("[Action:AoE] Dark Soul (Hotkey)") return true end
        end 
        if isChecked("Cooldowns") and SpecificToggle("Cooldowns") and not GetCurrentKeyBoardFocus() and not moving then
            if cast.darkSoul("player") then br.addonDebug("[Action:AoE] Cooldowns Hotkey (Dark Soul)") return true end
            if getSpellCD(spell.summonDarkglare) == 0 then CastSpellByName(GetSpellInfo(spell.summonDarkglare)) br.addonDebug("[Action:Rotation] Cooldowns Hotkey (Darkglare)") return true end
        end
        -- actions.aoe+=/drain_life,if=buff.inevitable_demise.stack>=50|buff.inevitable_demise.up&time_to_die<5
        ------------------------------------------------
        -- Cooldowns -----------------------------------
        ------------------------------------------------
        -- actions.aoe+=/call_action_list,name=cooldowns
        if actionList_Cooldowns() then return end 
        if isChecked("Cooldowns") and SpecificToggle("Cooldowns") and not GetCurrentKeyBoardFocus() and not moving then
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
        end
        -- actions.aoe+=/call_action_list,name=item

        ------------------------------------------------
        -- Summon Darkglare ----------------------------
        ------------------------------------------------
        if getSpellCD(spell.summonDarkglare) == 0 and useCDs() and not moving and debuff.agony.exists() and debuff.corruption.exists() and (debuff.unstableAffliction.exists() or shards == 5) then
            CastSpellByName(GetSpellInfo(spell.summonDarkglare)) br.addonDebug("[Action:AoE] Summon Darkglare")
            return true
        end
        ------------------------------------------------
        -- Drain Life, Inevitable Demise > 50, TTD < 5 -
        ------------------------------------------------
        -- actions.aoe+=/drain_life,if=buff.inevitable_demise.stack>=50|buff.inevitable_demise.up&time_to_die<5
        if not moving and talent.inevitableDemise and buff.inevitableDemise.stack() >= 50 or buff.inevitableDemise.exists() and ttd("target") < 5 and br.timer:useTimer("ID Delay", 5) then
            if cast.drainLife() then br.addonDebug("[Action:AoE] Drain Life (ID and TTD < 5)") return true end
        end

        ------------------------------------------------
        -- Shadow Bolt Filler --------------------------
        ------------------------------------------------
        --actions.se+=/shadow_bolt
        if not moving or (talent.nightfall and buff.nightfall.exists() or not buff.nightfall.exists()) then
            if talent.vileTaint and (debuff.vileTaint.exists("target") or not debuff.vileTaint.exists("target")) and not cd.vileTaint.ready() and shards <= 1 then   
                if cast.shadowBolt() then br.addonDebug("[Action:AoE] Shadow Bolt Filler (Vile Taint)")
                    return true 
                end
            elseif talent.phantomSingularity and (debuff.phantomSingularity.exists("target") or not debuff.phantomSingularity.exists("target")) and not cd.phantomSingularity.ready() and shards <= 1 then   
                if cast.shadowBolt() then br.addonDebug("[Action:AoE] Shadow Bolt Filler (Phantom)")
                    return true 
                end
            end
        end

    end -- End Action List: AoE

local function actionList_Rotation()
        ------------------------------------------------
        --SpellQueueReady ------------------------------
        ------------------------------------------------
        if spellQueueReady() then      
            --[[-- Curse of Weakness
            for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ui.checked("Curse of Weakness") and ttd(unit) >= 6 and isMelee(unit) and GetObjectExists(unit) and UnitCanAttack(unit,"player") and UnitIsPVP(unit) and UnitIsPlayer("target") then 
                        if cast.curseOfWeakness(unit) then 
                    --br.addonDebug("[Action:PvP] Curse of Tongues" .. " | Name: " .. name .. " | Class: ".. class .. " | Level:" .. UnitLevel(unit) .. " | Race: " .. select(1,UnitRace(unit))) 
                        return true
                    end
                end
            end
            -- Curse of Tongues
            for i = 1, #enemies.yards40f do
                local thisUnit = enemies.yards40f[i]
                if ui.checked("Curse of Tongues") and ttd(unit) >= 6 and isHealer(unit) and GetObjectExists(unit) and UnitCanAttack(unit,"player") and UnitIsPVP(unit) and UnitIsPlayer("target") then
                    if cast.curseOfTongues(unit) then 
                    --br.addonDebug("[Action:PvP] Curse of Tongues" .. " | Name: " .. name .. " | Class: ".. class .. " | Level:" .. UnitLevel(unit) .. " | Race: " .. select(1,UnitRace(unit))) 
                    return true
                    end
                end
            end]]
            --[[ if ui.checked("Curse of Tongues") then
                    for i = 1, #enemyTable40 do
                        local thisUnit = enemyTable40[i].unit
                        if isHealer(unit) and canCurse(unit, CoT) then
                            return true
                        end
                    end
                end]]
            ------------------------------------------------
            -- Malefic Rapture Max Shards ------------------
            ------------------------------------------------
            -- if not moving then
            --     if anydots and shards > 4 then
            --         if cast.maleficRapture("target") then br.addonDebug("[Action:Rotation] Malefic Rapture (Max Shards)") return true end 
            --     end
            -- end
            ------------------------------------------------
            -- Cycle Exhaustion  ---------------------------
            ------------------------------------------------
            if ui.checked("Curse of Exhaustion") and exhaustionCount < ui.value("Curse of Exhaustion") then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not noDotCheck(thisUnit) and not debuff.curseOfExhaustion.exists(thisUnit) and isExhaust(thisUnit) then
                        if cast.curseOfExhaustion(thisUnit) then br.addonDebug("[Action:Rotation] Exhaustion [Cycle]") return true end
                    end
                end
            end
            ------------------------------------------------
            -- Agony ---------------------------------------
            ------------------------------------------------
            --if not noDotCheck("target") and not debuff.agony.exists("target") then if cast.agony() then br.addonDebug("[Action:Rotation] Agony Apply") return true end end 

            if mode.md ~= 2 then  -- Multi-Dotting Enabled
                if agonyCount < ui.value("Agony Count") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and debuff.agony.remain(thisUnit) <= ui.value("Agony Refresh") and getTTD(thisUnit) > debuff.agony.remain(thisUnit) + (2/spellHaste) and (not isExhaust(thisUnit)) then
                            if cast.agony(thisUnit) then br.addonDebug("[Action:Rotation] Agony [Multi-Dot-Refresh]") return true end
                        end
                    end
                end
            end -- Multi-Dotting Disabled
            if not noDotCheck("target") and debuff.agony.remain("target") <= ui.value("Agony Refresh") and getTTD("target") > debuff.agony.remain("target") + (2/spellHaste) and (not isExhaust("target")) then
                    if cast.agony("target") then br.addonDebug("[Action:Rotation] Agony [ST-Refresh]") return true end
            end
            ------------------------------------------------
            -- Unstable Affliction -------------------------
            ------------------------------------------------
            if not moving and debuff.unstableAffliction.remains("target") <= ui.value("UA Refresh") and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 then
               if cast.unstableAffliction("target") then br.addonDebug("[Action:Rotation] Unstable Affliction [Refresh]") return true end
            end   
            ------------------------------------------------
            -- Corruption ----------------------------------
            ------------------------------------------------
            if mode.md ~= 2 then -- Multi-Dotting Enabled 
                if not talent.absoluteCorruption and corruptionCount < ui.value("Corruption Count") then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if not noDotCheck(thisUnit) and debuff.corruption.remains(thisUnit) <= ui.value("Corruption Refresh") and getTTD(thisUnit) > debuff.corruption.remain(thisUnit) + (2/spellHaste) and not debuff.seedOfCorruption.exists(thisUnit) then
                               if cast.corruption(thisUnit) then br.addonDebug("[Action:Rotation] Corruption [Refresh]") return true end
                            end
                        end
                elseif talent.absoluteCorruption and corruptionCount < ui.value("Corruption Count") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and not debuff.corruption.exists(thisUnit) and not debuff.seedOfCorruption.exists(thisUnit) then
                            if cast.corruption(thisUnit) then br.addonDebug("[Action:Rotation] Corruption [Absolute Corruption]") return true end
                        end
                    end
                end       
            end -- Multi-Dotting Disabled
            if not talent.absoluteCorruption then
                if not noDotCheck("target") and debuff.corruption.remains("target") <= ui.value("Corruption Refresh") and getTTD("target") > debuff.corruption.remain("target") + (2/spellHaste) and not debuff.seedOfCorruption.exists("target") then
                    if cast.corruption("target") then br.addonDebug("[Action:Rotation] Corruption [Refresh]") return true end
                end
            elseif talent.absoluteCorruption then
                if not noDotCheck("target") and not debuff.corruption.exists("target") and not debuff.seedOfCorruption.exists("target") then
                    if cast.corruption("target") then br.addonDebug("[Action:Rotation] Corruption [Absolute Corruption]") return true end
                end
            end      
            ------------------------------------------------
            -- Siphon Life ---------------------------------
            ------------------------------------------------
            --if not noDotCheck("target") and not debuff.siphonLife.exists("target") then if cast.siphonLife() then br.addonDebug("[Action:Rotation] Siphon Life Apply") return true end end 

            if mode.md ~= 2 then -- Multi-Dotting enabled. 
                if talent.siphonLife and siphonLifeCount < ui.value("Siphon Life Count") then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if not noDotCheck(thisUnit) and debuff.siphonLife.remain(thisUnit) <= ui.value("Siphon Life Refresh") and getTTD(thisUnit) > debuff.siphonLife.remain(thisUnit) + (3/spellHaste) then
                            if cast.siphonLife(thisUnit) then br.addonDebug("[Action:Rotation] Siphon Life [Cycle Multi-Dot-Refresh]") return true end
                        end
                    end
                end
            end -- Multi-Dotting disabled. 
            if talent.siphonLife then
                if not noDotCheck("target") and debuff.siphonLife.remain("target") <= ui.value("Siphon Life Refresh") and getTTD("target") > debuff.siphonLife.remain("target") + (3/spellHaste) then
                    if cast.siphonLife("target") then br.addonDebug("[Action:Rotation] Siphon Life [ST-Refresh]") return true end
                end
            end
            -- actions+=/call_action_list,name=darkglare_prep,if=active_enemies>2&cooldown.summon_darkglare.ready&(dot.phantom_singularity.ticking|!talent.phantom_singularity.enabled)
            ------------------------------------------------
            -- Seed of Corruption, ST ----------------------
            ------------------------------------------------
            if mode.soc ~= 2 and getDistance(units.dyn40) < 40 and talent.seedOfCorruption then
                if not moving and debuff.corruption.remain(seedTarget) <= cast.time.seedOfCorruption() and debuff.seedOfCorruption.count() == 0 and not cast.last.seedOfCorruption(1) and not cast.last.seedOfCorruption(2) then
                    if cast.seedOfCorruption(seedTarget) then br.addonDebug("[Action:Rotation] Seed of Corruption") return true end
                end

                -- actions+=/seed_of_corruption,if=variable.spammable_seed
                if  isChecked("Spam Seed of Corruption") and not moving and br.timer:useTimer("SoC Spam", ui.value("SoC Spam Delay")) then
                    if cast.seedOfCorruption(seedTarget) then br.addonDebug("[Action:Rotation] Seed of Corruption (SPAM)") return true end
                end
            end
            ------------------------------------------------
            -- Haunt ---------------------------------------
            ------------------------------------------------
            if not moving and talent.haunt and (cd.haunt.remain() <= gcdMax or debuff.haunt.remains() < 4) and getTTD("target") >= ui.value("Haunt TTD") then
                if cast.haunt("target") then br.addonDebug("[Action:Rotation] Haunt") return true end
            end
            ------------------------------------------------
            -- Drain Soul ----------------------------------
            ------------------------------------------------
            if not moving then
                if (not debuff.shadowEmbrace.exists("target") or (debuff.shadowEmbrace.exists("target") and getDebuffStacks("target", 32390) < 3)) then
                    if cast.drainSoul() then br.addonDebug("[Action:Rotation] Applying 3 Stacks Shadow Embrace - Drain Soul")
                        dsInterrupt = true
                        return true 
                    end
                elseif debuff.shadowEmbrace.stack("target") == 3 and debuff.shadowEmbrace.remains("target") < 4 then
                    if cast.drainSoul() then br.addonDebug("[Action:Rotation] Maintaining 3 Stacks Shadow Embrace - Drain Soul")
                        dsInterrupt = true
                        return true 
                    end
                elseif talent.seedOfCorruption and shards < 5 then   
                    if cast.drainSoul() then br.addonDebug("[Action:Rotation] Drain Soul Filler - (SoC)")
                        dsInterrupt = true
                        return true 
                    end                                
                elseif talent.vileTaint and not debuff.vileTaint.exists("target") and (not cd.vileTaint.ready() and shards < 5 or cd.vileTaint.ready() and shards <= 1) then   
                    if cast.drainSoul() then br.addonDebug("[Action:Rotation] Drain Soul Filler (Vile Taint)")
                        dsInterrupt = true
                        return true 
                    end
                elseif talent.vileTaint and debuff.vileTaint.exists("target") and shards < 1 then   
                    if cast.drainSoul() then br.addonDebug("[Action:Rotation] Drain Soul Filler - Shards <= 1 (Vile Taint)")
                        dsInterrupt = true
                        return true 
                    end
                elseif talent.phantomSingularity and not debuff.phantomSingularity.exists("target") and (not cd.phantomSingularity.ready() and shards < 5 or cd.phantomSingularity.ready() and shards <= 1) then   
                    if cast.drainSoul() then br.addonDebug("[Action:Rotation] Drain Soul Filler (Phantom)")
                        dsInterrupt = true
                        return true 
                    end
                elseif talent.phantomSingularity and debuff.phantomSingularity.exists("target") and shards < 1 then   
                    if cast.drainSoul() then br.addonDebug("[Action:Rotation] Drain Soul Filler - Shards <= 1 (Phantom)")
                        dsInterrupt = true
                        return true 
                    end 
                end
            end
            ------------------------------------------------
            -- Covenants (Level 60) ------------------------
            ------------------------------------------------
            if level == 60 and not moving 
            and debuff.agony.exists("target") 
            --and getTTD("target") >= gcdMax + cast.time.maleficRapture()
            and debuff.unstableAffliction.exists("target") 
            and debuff.corruption.exists("target")
            and (talent.siphonLife and debuff.siphonLife.exists("target") or not talent.siphonLife) then
                --actions.covenant=impending_catastrophe,if=cooldown.summon_darkglare.remains<10|cooldown.summon_darkglare.remains>50
                ------------------------------------------------
                -- Impending Catastrophe : Venthyr -------------
                ------------------------------------------------
                --321792
                if #enemies.yards40 > 0 or useCDs() and covenant.venthyr.active and spellUsable(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax and (cd.summonDarkglare.remains() < 10 or cd.summonDarkglare.remains() > 50) then
                    if cast.impendingCatastrophe() then br.addonDebug("[Action:Rotation] Impending Catastrophe") return true end
                end
       
                --actions.covenant+=/decimating_bolt,if=cooldown.summon_darkglare.remains>5&(debuff.haunt.remains>4|!talent.haunt.enabled)
                ------------------------------------------------
                -- Decimating Bolt : Necrolord -----------------
                ------------------------------------------------
                if #enemies.yards40 > 0 or useCDs() and covenant.necrolord.active and spellUsable(325289) and select(2,GetSpellCooldown(325289)) <= gcdMax and (cd.summonDarkglare.remains() > 5 and debuff.haunt.remains() > 4 or not talent.haunt) then
                    if cast.decimatingBolt() then br.addonDebug("[Action:Rotation] Decimating Bolt") return true end
                end    
                --actions.covenant+=/soul_rot,if=cooldown.summon_darkglare.remains<5|cooldown.summon_darkglare.remains>50|cooldown.summon_darkglare.remains>25&conduit.corrupting_leer.enabled
                ------------------------------------------------
                -- Soul Rot : Night Fae ------------------------
                ------------------------------------------------
                if #enemies.yards40 > 0 or useCDs() and covenant.nightFae.active and ttd("target") > 7 and spellUsable(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax or cd.summonDarkglare.remains() > 50 or cd.summonDarkglare.remains() > 25 and IsSpellKnown(339455) then
                    if cast.soulRot() then br.addonDebug("[Action:Rotation] Soul Rot") return true end
                end 
                ------------------------------------------------
                -- Scouring Tithe : Kyrian ---------------------
                ------------------------------------------------
                if #enemies.yards40 > 0 or useCDs() and covenant.kyrian.active and spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax then
                    if cast.scouringTithe() then br.addonDebug("[Action:Rotation] Scouring Tithe") return true end
                end
            end
            ------------------------------------------------
            -- Covenant (Levelling) ------------------------
            ------------------------------------------------       
            if level < 60 and not moving and not GetRealZoneText() == "The Maw" then
                -- Decimating Bolt
                if IsSpellKnown(313347) and spellUsable(313347) and select(2,GetSpellCooldown(313347)) <= gcdMax and not moving and getTTD("target") > 7 or aoeUnits >= 3 then if CastSpellByName(GetSpellInfo(313347)) then return true end end 
                ------------------------------------------------
                -- Soul Rot : Night Fae ------------------------
                ------------------------------------------------
                if useCDs() and not moving and spellUsable(325640) and IsSpellKnown(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax then
                    if CastSpellByName(GetSpellInfo(325640)) then br.addonDebug("[Action:Rotation] Soul Rot") return true end
                end 
            end
            ------------------------------------------------
            -- Agony on seed if missing --------------------
            ------------------------------------------------
            if not debuff.agony.exists(seedTarget) and debuff.seedOfCorruption.exists(seedTarget) then
                if cast.agony(seedTarget) then br.addonDebug("Agony Seed of Corruption") return true end
            end
            ------------------------------------------------
            -- Phantom Singularity -------------------------
            ------------------------------------------------
            if not moving and talent.phantomSingularity then
                if cast.phantomSingularity("target") then br.addonDebug("[Action:Rotation] Phantom Singularity") return true end 
            end
            ------------------------------------------------
            -- Vile Taint ----------------------------------
            ------------------------------------------------
            if not moving and talent.vileTaint and shards > 1 or aoeUnits > 2 then
                if cast.vileTaint("target") then br.addonDebug("[Action:Rotation] Vile Taint") return true end
            end
            ------------------------------------------------
            -- Summon Darkglare ----------------------------
            ------------------------------------------------
            if getSpellCD(spell.summonDarkglare) == 0 and useCDs() and not moving and debuff.agony.exists("target") and debuff.corruption.exists("target") and (debuff.unstableAffliction.exists("target") or shards == 5) then
                CastSpellByName(GetSpellInfo(spell.summonDarkglare)) br.addonDebug("[Action:Rotation] Summon Darkglare")
                return true
            end
            --actions+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
            ------------------------------------------------
            -- Dark Soul -----------------------------------
            ------------------------------------------------
            --actions+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
            -- Dark Soul
            if talent.darkSoul and useCDs() and not moving and pet.darkglare.active() then
                if cast.darkSoul("player") then br.addonDebug("[Action:Rotation] Dark Soul (Darkglare Active)") return true end
            end 
            if isChecked("Dark Soul: Misery") and SpecificToggle("Dark Soul: Misery") and not GetCurrentKeyBoardFocus() and not moving then
                if cast.darkSoul("player") then br.addonDebug("[Action:Rotation] Dark Soul (Hotkey)") return true end
            end 
            if isChecked("Cooldowns") and SpecificToggle("Cooldowns") and not GetCurrentKeyBoardFocus() and not moving then
                if cast.darkSoul("player") then br.addonDebug("[Action:Rotation] Cooldowns (Hotkey)") return true end
                if getSpellCD(spell.summonDarkglare) == 0 then CastSpellByName(GetSpellInfo(spell.summonDarkglare)) br.addonDebug("[Action:Rotation] Cooldowns (Hotkey)") return true end
            end
            ------------------------------------------------
            -- Racial --------------------------------------
            ------------------------------------------------
            if isChecked("Racial") and not moving and race == "Troll" and pet.darkglare.active() then
                if cast.racial("player") then br.addonDebug("[Action:Rotation] Berserking")
                    return true
                end
            end
            ------------------------------------------------
            -- Malefic Rapture  ----------------------------
            ------------------------------------------------
            if not moving and shards > 0 then
                -- Malefic Rapture Vile Taint
                if talent.vileTaint and debuff.vileTaint.exists("target")
                then
                    if cast.maleficRapture("target") then br.addonDebug("[Action:Rotation] Malefic Rapture (Vile Taint)") return true end 
                end
                if talent.vileTaint and cd.vileTaint.remains() > 10 and shards > 2 then
                    if cast.maleficRapture("target") then br.addonDebug("[Action:Rotation] Waiting for Vile Taint CD") return true end
                end
                -- Phantom Singularity
                -- actions+=/malefic_rapture,if=talent.phantom_singularity.enabled&(dot.phantom_singularity.ticking||cooldown.phantom_singularity.remains>12||soul_shard>3)
                if talent.phantomSingularity and debuff.phantomSingularity.exists("target")
                then
                    if cast.maleficRapture("target") then br.addonDebug("[Action:Rotation] Malefic Rapture (Phantom Singularity)") return true end 
                end
                if talent.phantomSingularity and cd.phantomSingularity.remains() > 20 and shards > 1 then
                    if cast.maleficRapture("target") then br.addonDebug("[Action:Rotation] Waiting for Phantom of Singularity CD") return true end
                end
                --- Soul Rot 
                if debuff.soulRot.exists("target") then
                    if cast.maleficRapture("target") then br.addonDebug("[Action:Rotation] Malefic Rapture (Soul Rot Active)") return true end 
                end				   
            end
            ------------------------------------------------
            -- Cooldowns -----------------------------------
            ------------------------------------------------
            if actionList_Cooldowns() then return end 
            if isChecked("Cooldowns") and SpecificToggle("Cooldowns") and not GetCurrentKeyBoardFocus() and not moving then
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
                    if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" then
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
            end
            ------------------------------------------------
            -- Agony, Moving -------------------------------
            ------------------------------------------------
            if IsMovingTime(math.random(2.5,20)/100) then
                if agonyCount < ui.value("Agony Count") and mode.md ~= 2 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        local agonyRemain = debuff.agony.remain(thisUnit)
                        if not noDotCheck(thisUnit) and debuff.agony.remains(thisUnit) <= ui.value("Agony Refresh") and ttd(thisUnit) > 10 and (not isExhaust(thisUnit)) then
                            if cast.agony(thisUnit) then br.addonDebug("[APL:Rotation] Agony Movement (Spread)") return true end
                        end
                    end
                end
            end
        end-- End Spell Queue Ready
end-- End Action List: Rotation

local function actionList_PetControl()

    if UnitExists("pet")
    and not UnitIsDeadOrGhost("pet") 
    and not UnitExists("pettarget")
    and inCombat
    and br.timer:useTimer("Summon Pet Delay",math.random(0.5,2))
    then
        PetAssistMode()
        PetAttack()
        RunMacroText("/petattack")
    end

    if not inCombat 
    and UnitExists("pet")
    and not UnitIsDeadOrGhost("pet") 
    and UnitExists("pettarget")
    then    
        PetFollow()   
        RunMacroText("/petfollow")
        br.addonDebug("PET FOLLOW!")
    end

    -- Firebolt Spam
    if UnitExists("pettarget")
    and pet.imp.active()
    and not UnitIsDeadOrGhost("pet") 
    then
        CastSpellByName(GetSpellInfo(3110),"pettarget") 
    end
    -- Consuming Shadows Spam
    if UnitExists("pettarget")
    and pet.voidwalker.active()
    and not UnitIsDeadOrGhost("pet") 
    then
        CastSpellByName(GetSpellInfo(3716),"pettarget") 
    end
    -- Shadow Bite Spam
    if UnitExists("pettarget")
    and pet.felhunter.active()
    and not UnitIsDeadOrGhost("pet") 
    then
        CastSpellByName(GetSpellInfo(54049),"pettarget") 
    end


end

    local function actionList_SummonPet()
        local petPadding = 2
        if talent.grimoireOfSacrifice then
            petPadding = 5
        end

        if UnitIsDeadOrGhost("pet") then RunMacroText("/petdismiss") return end 

        if ui.checked("Fel Domination") and inCombat and not GetObjectExists("pet") or UnitIsDeadOrGhost("pet") and cd.felDomination.remain() <= gcdMax and not buff.grimoireOfSacrifice.exists() 
        then
            if cast.felDomination() then br.addonDebug("Fel Domination") return true end
        end

        if ui.checked("Fel Domination Pet HP%") and not moving and cd.felDomination.remain() <= gcdMax and getHP("pet") <= getOptionValue("FD Pet HP%") and (GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet"))
        then
            if cast.felDomination() then br.addonDebug("Fel Domination Low Pet Health") return true end
        end

        -- If we're casting pet summons 
      --  if UnitCastingInfo("Player") == GetSpellInfo() then if UnitExists("pet") and not UnitIsDeadOrGhost("pet") then SpellStopCasting()  return true end  end

        local var = {} 
        var.summonImp                   = spell.summonImp
        var.summonFelhunter             = spell.summonFelhunter
        var.summonSuccubus              = spell.summonSuccubus
        var.summonFelguard              = spell.summonFelguard
        var.summonDemonicTyrant         = spell.summonDemonicTyrant
        var.summonVilefiend             = spell.summonVilefiend
        if isChecked("Pet Management") and not (IsFlying() or IsMounted()) and ((not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) or talent.grimoireOfSacrifice and not buff.grimoireOfSacrifice.exists("player")) and level >= 5 and br.timer:useTimer("Summon Pet Delay", getOptionValue("Summon Pet Delay")) and not moving then
            if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0) then
                if mode.summonPet == 1 and (lastSpell ~= spell.summonImp or activePetId == 0) then
                    if cast.summonImp("player") then castSummonId = spell.summonImp return end
                elseif mode.summonPet == 2 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                    if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker return end
                elseif mode.summonPet == 3 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                    if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter return end
                elseif mode.summonPet == 4 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                    if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus return end
                elseif mode.summonPet == 5 then
                    RunMacroText("/petdismiss") ui.debug("Dismiss Pet")
                end
            end
        end
    end
local function actionList_drainSoulST()
    --------------------------
    --- Drain Soul Clipped ---
    --------------------------
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.unstableAffliction.remains("target") <= 3.5 and not lcast then
        -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
            if cast.unstableAffliction("target") then br.addonDebug("[Action:Clipped ST] Unstable Affliction [Refresh]") return true end
        end
    end
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.agony.remains("target") <= 2 then
        -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
            if cast.agony("target") then br.addonDebug("[Action:Clipped ST] Agony [Refresh]") return true end
        end
    end
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.siphonLife.remains("target") <= 2 then
        -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
            if cast.siphonLife("target") then br.addonDebug("[Action:Clipped ST] Siphon Life [Refresh]") return true end
        end 
    end
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.corruption.remains("target") <= 2 then
        -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
            if cast.corruption("target") then br.addonDebug("[Action:Clipped ST] Corruption [Refresh]") return true end
        end               
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and shards > 0
    --and debuff.unstableAffliction.remains("target") >= 9
    and talent.phantomSingularity and debuff.phantomSingularity.exists("target")
    or talent.vileTaint and debuff.vileTaint.exists("target")
    then
            --SpellStopCasting()
        if not moving and cast.able.maleficRapture()
        -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
        -- and not cast.current.unstableAffliction()
        -- and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
        then
            if cast.maleficRapture("target") then br.addonDebug("[Action:Clipped ST] Malefic Rapture") return true end
        end
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and shards > 2
    --and debuff.unstableAffliction.remains("target") >= 9
    then
            --SpellStopCasting()
        if talent.vileTaint and cd.vileTaint.remains() > 10 and not moving
        -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
        -- and not cast.current.unstableAffliction()
        -- and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
        then
            if cast.maleficRapture("target") then br.addonDebug("[Action:Clipped ST] Waiting for Vile Taint CD") return true end
        end
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and shards > 2
    --and debuff.unstableAffliction.remains("target") >= 9
    then
            --SpellStopCasting()
        if talent.phantomSingularity and cd.phantomSingularity.remains() > 10 and not moving
        -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
        -- and not cast.current.unstableAffliction()
        -- and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
        then
            if cast.maleficRapture("target") then br.addonDebug("[Action:Clipped ST] Waiting for Phantom of Singularity CD") return true end
        end
    end
end
local function actionList_drainSoulAoE()
    --------------------------
    --- Drain Soul Clipped ---
    --------------------------
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.unstableAffliction.remains("target") <= getOptionValue("UA Refresh") + 1.5 and not lcast then
       -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
           if cast.unstableAffliction("target") then br.addonDebug("[Action:Clipped AoE] Unstable Affliction [Refresh]") return true end
        end
    end
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.agony.remains("target") <= getOptionValue("Agony Refresh") + 1.5 then
       -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
           if cast.agony("target") then br.addonDebug("[Action:Clipped AoE] Agony [Refresh]") return true end
        end
    end
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.siphonLife.remains("target") <= getOptionValue("Siphon Life Refresh") + 1.5 then
       -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
           if cast.siphonLife("target") then br.addonDebug("[Action:Clipped AoE] Siphon Life [Refresh]") return true end
        end 
    end
    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) then
        --  SpellStopCasting()
        if not moving and debuff.corruption.remains("target") <= getOptionValue("Corruption Refresh") + 1.5 then
        -- and not cast.current.unstableAffliction()
        --and br.timer:useTimer("UA", 1.5) 
        -- and cast.timeSinceLast.unstableAffliction() >= 3
        -- and not cast.last.unstableAffliction(2)
            if cast.corruption("target") then br.addonDebug("[Action:Clipped AoE] Corruption [Refresh]") return true end
        end               
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and shards > 0
    --and debuff.unstableAffliction.remains("target") >= 9
    and talent.phantomSingularity and debuff.phantomSingularity.exists("target")
    or talent.vileTaint and debuff.vileTaint.exists("target")
    then
          --SpellStopCasting()
        if not moving and cast.able.maleficRapture()
       -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
       -- and not cast.current.unstableAffliction()
       -- and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
        then
           if cast.maleficRapture("target") then br.addonDebug("[Action:Clipped AoE] Malefic Rapture") return true end
        end
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and shards > 4
    --and debuff.unstableAffliction.remains("target") >= 9
    then
          --SpellStopCasting()
        if anydots and not moving and cast.able.maleficRapture()
       -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
       -- and not cast.current.unstableAffliction()
       -- and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
        then
           if cast.maleficRapture("target") then br.addonDebug("[Action:Clipped AoE] Malefic Rapture (Max Shards)") return true end
        end
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and shards > 2
    --and debuff.unstableAffliction.remains("target") >= 9
    then
          --SpellStopCasting()
        if talent.vileTaint and cd.vileTaint.remains() > 10 and not moving
       -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
       -- and not cast.current.unstableAffliction()
       -- and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
        then
           if cast.maleficRapture("target") then br.addonDebug("[Action:Clipped AoE] Waiting for Vile Taint CD") return true end
        end
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) and shards > 2
    --and debuff.unstableAffliction.remains("target") >= 9
    then
          --SpellStopCasting()
        if talent.phantomSingularity and cd.phantomSingularity.remains() > 10 and not moving
       -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
       -- and not cast.current.unstableAffliction()
       -- and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
        then
           if cast.maleficRapture("target") then br.addonDebug("[Action:Clipped AoE] Waiting for Phantom of Singularity CD") return true end
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
           if cast.haunt("target") then br.addonDebug("[Action:Clipped AoE] Haunt") return true end
        end
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) 
    --and debuff.unstableAffliction.remains("target") >= 11
    and debuff.shadowEmbrace.stack("target") == 3
    and cd.vileTaint.remain() <= gcdMax
    and shards > 1
    then
          --SpellStopCasting()
        if not moving
       -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
       -- and not cast.current.unstableAffliction()
       -- and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
        then
           if cast.vileTaint("target") then br.addonDebug("[Action:Clipped AoE] Vile Taint") return true end
        end
    end

    if UnitChannelInfo("player") == GetSpellInfo(spell.drainSoul) 
    --and debuff.unstableAffliction.remains("target") >= 11
    and debuff.shadowEmbrace.stack("target") == 3
    and cd.phantomSingularity.remain() <= gcdMax
    then
          --SpellStopCasting()
        if not moving
       -- and select(2,GetSpellCooldown(spell.unstableAffliction)) ~= 1 
       -- and not cast.current.unstableAffliction()
       -- and br.timer:useTimer("UA", 1.5) 
       -- and cast.timeSinceLast.unstableAffliction() >= 3
       -- and not cast.last.unstableAffliction(2)
        then
           if cast.phantomSingularity("target") then br.addonDebug("[Action:Clipped AoE] Phantom of Singularity") return true end
        end
    end
end

local function actionList_PreCombat()
        if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask
            -- flask,type=whispered_pact
            -- Food
            -- food,type=azshari_salad
            if pullTimer <= getOptionValue("Pre-Pull Timer") then
                if talent.haunt and not moving and getOptionValue("Pre-Pull Spell") ~=2 and getOptionValue("Pre-Pull Spell") ~= 3 then
                    if cast.haunt("target") then br.addonDebug("Casting Haunt Pre-pull")
                    return end
                end
                if not talent.drainSoul and not moving and getOptionValue("Pre-Pull Spell") ~=1 and getOptionValue("Pre-Pull Spell") ~= 3 then
                    if cast.shadowBolt("target") then br.addonDebug("Casting Shadow Bolt Pre-Pull")
                    return end
                end
            end -- End Pre-Pull

                    -- Pet Attack/Follow
                --    if mode.pc ~= 2 and isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
                   --     PetAssistMode()
                    --    PetAttack("target")
                --    end
            if isChecked("Soulstone") and getOptionValue("Soulstone") == 7 then -- Player
                if not UnitIsDeadOrGhost("player") and not moving and not inCombat then
                    if cast.soulstone("player") then br.addonDebug("Casting Soulstone [Player]" ) return true end
                end
            end

            -- Create Healthstone
            if not moving and not inCombat and ui.checked("Create Healthstone") then
                if GetItemCount(5512) < 1 and br.timer:useTimer("CH", 5) then
                     if cast.createHealthstone() then br.addonDebug("Casting Create Healthstone" ) return true end
                end
            end

            -- Auto Engage
            if ui.checked("Auto Engage") and not inCombat and getDistance("target") <= 40 and getFacing("player","target") and br.timer:useTimer("Agony Delay", 2) then
                if cast.agony() then br.addonDebug("Casting Agony [Auto Engage]") return true end

            -- actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3&!equipped.169314
            if mode.soc ~= 2 and not moving and pullTimer <= 3 and br.timer:useTimer("SoC Delay", 3) and aoeUnits >= ui.value("Pre-Pull SoC Count") and ui.checked("Pre-Pull SoC") then
                CastSpellByName(GetSpellInfo(spell.seedOfCorruption)) br.addonDebug("[Action:Pre-Combat] Seed of Corruption [Pre-Pull]") return
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
    elseif (inCombat and profileStop == true) or IsMounted() or IsFlying() or pause(true) or mode.rotation ==4 then
        if not pause(true) and IsPetAttackActive() and isChecked("Pet Management") then
            PetStopAttack()
            PetFollow()
        end
        return true
    else

        --if mode.pc == 2 then PetStopAttack() PetFollow() return true end 
      --  return tru
        ------------------------------------------------
        -- PET MANAGEMENT ------------------------------
        ------------------------------------------------
        if actionList_PetManagement() then return true end

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
        -----------------------
        --- Opener Rotation ---
        -----------------------
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList_PetControl() then return end
        if actionList_PreCombat() then return end

        if UnitIsDeadOrGhost("pet") then RunMacroText("/petdismiss") return end 

        if ui.checked("Fel Domination") and inCombat and not GetObjectExists("pet") or UnitIsDeadOrGhost("pet") and cd.felDomination.remain() <= gcdMax and not buff.grimoireOfSacrifice.exists() 
        then
            if cast.felDomination() then br.addonDebug("Fel Domination") return true end
        end

        if ui.checked("Fel Domination New Pet") and not moving and cd.felDomination.remain() <= gcdMax and getHP("pet") <= getOptionValue("FelDom Pet HP") and (GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet"))
        then
            if cast.felDomination() then br.addonDebug("Fel Domination Low Pet Health") return true end
        end

        -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
        if (not inCombat and not moving) or buff.felDomination.exists() then 
            if actionList_SummonPet() then return end 
        elseif inCombat and moving and buff.felDomination.exists() then 
            if actionList_SummonPet() then return end
        end
        if ((mode.rotation == 1 and #enemies.yards40f < ui.value("Multi-Target Units")) or (mode.rotation == 3 and #enemies.yards40f > 0)) then
            if actionList_drainSoulST() then return end
        end

        if ((mode.rotation == 1 and #enemies.yards40f >= ui.value("Multi-Target Units")) or (mode.rotation == 2 and #enemies.yards40f > 0)) then
            if actionList_drainSoulAoE() then return end
        end
    
        --------------------------
        --- In Combat Rotation ---
        --------------------------
         if inCombat and isValidUnit("target") then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then return end
                
            if br.queueSpell then
                ChatOverlay("Pausing for queuecast")
                return true 
            end
        
            if getOptionValue("APL Mode") == 1 and not pause() then
                ------------------------------------------------
                -- AoE Rotation --------------------------------
                ------------------------------------------------
                    if ((mode.rotation == 1 and #enemies.yards40f >= ui.value("Multi-Target Units")) or (mode.rotation == 2 and #enemies.yards40f > 0)) then
                        if actionList_AoE() then return end
                    end
                ------------------------------------------------
                -- ST Rotation ---------------------------------
                ------------------------------------------------
                    if ((mode.rotation == 1 and #enemies.yards40f < ui.value("Multi-Target Units")) or (mode.rotation == 3 and #enemies.yards40f > 0)) then
                       if actionList_Rotation() then return end
                    ------------------------------------------------
                    -- Shadow Bolt ---------------------------------
                    ------------------------------------------------
                    if not talent.drainSoul and not moving then
                        if cast.shadowBolt("target") then return true end
                    end
                end
            end
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

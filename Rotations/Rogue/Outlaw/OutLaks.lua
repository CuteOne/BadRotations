local rotationName = "OutLaks" -- Change to name of profile listed in options drop down


---------------
--- Toggles ---
---------------
local function createToggles()
    -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.bladeFlurry },
        [2] = { mode = "Sing", value = 2, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.sinisterStrike },
        [3] = { mode = "Off", value = 3, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = 1804 }
    };
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns Enabled", highlight = 0, icon = br.player.spell.adrenalineRush },
        [2] = { mode = "Off", value = 2, overlay = "Cooldowns Disabled", tip = "Cooldowns Disabled", highlight = 0, icon = br.player.spell.adrenalineRush }
    };
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    };
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick },
        [3] = { mode = "NXT", value = 3, overlay = "Use once", tip = "Use once.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt", 4, 0)

    CloakModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Cloak logic", tip = "Use Cloak logic", highlight = 0, icon = br.player.spell.cloakOfShadows },
        [2] = { mode = "Off", value = 2, overlay = "Use Cloak logic", tip = "Won't Use Cloak logic", highlight = 0, icon = br.player.spell.cloakOfShadows }
    };
    CreateButton("Cloak", 5, 0)

    PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
        [2] = { mode = "Off", value = 2, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 }
    }
    CreateButton("Pots", 6, 0)

    KidneyModes = {
        [1] = { mode = "INT", value = 1, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot },
        [2] = { mode = "STUN", value = 2, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot },
        [3] = { mode = "ALL", value = 3, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot },
        [4] = { mode = "OFF", value = 4, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot }
    };
    CreateButton("Kidney", 5, -1)

    CovModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Covenant", tip = "Use Covenant powers", highlight = 0, icon = br.player.spell.summonSteward },
        [2] = { mode = "Off", value = 2, overlay = "Use Covenant", tip = "Use Covenant powers", highlight = 0, icon = br.player.spell.summonSteward }
    };
    CreateButton("Cov", 6, -1)

    VanishModes = {
        [1] = { mode = "On", value = 1, overlay = "Vanish Enabled", tip = "Will use Vanish.", highlight = 0, icon = br.player.spell.vanish },
        [2] = { mode = "Off", value = 2, overlay = "Vanish Disabled", tip = "Won't use Vanish.", highlight = 0, icon = br.player.spell.vanish }
    };
    CreateButton("Vanish", 1, -1)

    AmbushModes = {
        [1] = { mode = "On", value = 1, overlay = "Ambush Enabled", tip = "Will use Ambush.", highlight = 0, icon = br.player.spell.ambush },
        [2] = { mode = "Off", value = 2, overlay = "Ambush Disabled", tip = "Won't use Ambush.", highlight = 0, icon = br.player.spell.ambush }
    };
    CreateButton("Ambush", 2, -1)

    BlindModes = {
        [1] = { mode = "INT", value = 1, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind },
        [2] = { mode = "STUN", value = 2, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind },
        [3] = { mode = "ALL", value = 3, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind },
        [4] = { mode = "OFF", value = 4, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind }
    };
    CreateButton("Blind", 3, -1)

    GougeModes = {
        [1] = { mode = "INT", value = 1, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [2] = { mode = "STUN", value = 2, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [3] = { mode = "ALL", value = 3, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [4] = { mode = "CD", value = 4, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [5] = { mode = "OFF", value = 5, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge }
    };
    CreateButton("Gouge", 4, -1)


end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Keys - 2018121510 ")
        br.ui:createDropdownWithout(section, "DPS Key", br.dropOptions.Toggle, 6, "DPS Override")
        br.ui:createCheckbox(section, "Group CD's with DPS key", "Adrenaline + BladeFurry", 1)
        br.ui:createDropdownWithout(section, "Distract", br.dropOptions.Toggle, 6, "Distract at cursor")
        br.ui:createDropdownWithout(section, "Blind Key", br.dropOptions.Toggle, 6, "Blind Mouseover")
        br.ui:createSpinner(section, "Auto Soothe", 1, 0, 100, 5, "TTD for soothing")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createDropdown(section, "Non-Lethal Poison", { "Crippling", "Numbing", }, 1, "Non-Lethal Poison to apply")
        br.ui:createDropdown(section, "Lethal Poison", { "Instant", "Wound", }, 1, "Lethal Poison to apply")
        br.ui:createDropdown(section, "Auto Stealth", { "Always", "25 Yards" }, 1, "Auto stealth mode.")
        br.ui:createCheckbox(section, "Cheap Shot", "Will use cheap shot")
        br.ui:createDropdown(section, "Priority Mark", { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffffffffMoon", "|cff0000ffSquare", "|cffff0000Cross", "|cffffffffSkull" }, 8, "Mark to Prioritize")
        br.ui:createSpinner(section, "Pistol Spam", 50, 0, 100, 1, "", "Min Energy to spam pistol shots")
        br.ui:createDropdown(section, "Eng Brez", { "Target", "Mouseover", "Auto" }, 1, "", "Target to cast on")
        br.ui:createDropdownWithout(section, "Draw Range", { "Never", "Blade Flurry", "always" }, 1, "Draw range on screen")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createDropdownWithout(section, "Pots - 1 target (Boss)", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury", "Phantom fire" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury", "Phantom fire" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury", "Phantom fire" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createCheckbox(section, "Use Racial", "Use your racial")
        if br.player.race == "BloodElf" then
            br.ui:createSpinner(section, "Arcane Torrent Dispel", 1, 0, 20, 1, "", "Minimum Torrent Targets")
            br.ui:createCheckbox(section, "Arcane Torrent regen")
        end
        br.ui:createCheckbox(section, "Auto Sprint")
        br.ui:createCheckbox(section, "Use Trinkets")
        br.ui:checkSectionState(section)

        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Pot/Stoned", 30, 0, 100, 5, "", "Health Percent to Cast At")
        br.ui:createSpinner(section, "Engineering Belt", 60, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Crimson Vial", 10, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Feint", 10, 0, 100, 5, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Evasion", 10, 0, 100, 5, "Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt/stun Options")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt %", 0, 0, 95, 5, "Remaining Cast Percentage to interrupt at.")
        br.ui:createCheckbox(section, "Kick", "Will use Kick to int")

        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Aggro")
        br.ui:createCheckbox(section, "Aggro Management", "Shake aggro?")
        if br.player.race == "NightElf" then
            br.ui:createCheckbox(section, "[AM] - Shadowmeld", "Shake aggro?")
        end
        br.ui:createCheckbox(section, "[AM] - Tricks", "Shake aggro?")
        br.ui:createCheckbox(section, "[AM] - Vanish", "Shake aggro?")
        br.ui:createCheckbox(section, "[AM] - Evasion", "Shake aggro?")
        br.ui:createCheckbox(section, "[AM] - Kidney", "Shake aggro?")
        br.ui:checkSectionState(section)

    end

    local function mplusoptions()
        section = br.ui:createSection(br.ui.window.profile, "M+ Settings")
        -- m+ Rot
        br.ui:createCheckbox(section, "No m+ settings to see here", 1)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Controlled by CD toggle")
        br.ui:createCheckbox(section, "Adrenaline Rush", "triggerred by CD toggle", 1)
        --  br.ui:createCheckbox(section, "Roll The Bones", "triggerred by CD toggle", 1)
        --  br.ui:createCheckbox(section, "Slice and Dice", "triggerred by CD toggle", 1)
        br.ui:createCheckbox(section, "Level 90 talent row", "triggerred by CD toggle", 1)
        br.ui:createCheckbox(section, "Racial", "triggerred by CD toggle", 1)
        br.ui:checkSectionState(section)

    end

    optionTable = { {
                        [1] = "Rotation Options ",
                        [2] = rotationOptions,
                    },

                    {
                        [1] = "M+ Options",
                        [2] = mplusoptions,
                    },

    }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive

-- BR API Locals
local ui
local buff
local cast
local cd
local debuff
local enemies
local equiped
local gcd
local gcdMax
local has
local inCombat
local item
local covenant
local level
local mode
local php
local spell
local talent
local units
local use
local conduit
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local hastar
local healPot
local profileStop
local ttd
local stealth
local combo, comboDeficit, comboMax
local ambush_flag = false
local do_stun
local auto_stealthed
local should_pool
local rnd5 -- rand number between 1 and 5
local rnd10 --random number between 1 and 10
local dynamic_target_melee
local dynamic_range
local buff_rollTheBones_remain = 0
local buff_rollTheBones_count = 0


-- lists ...lots of lists



local debuff_list = {

    --junkyard
    { spellID = 298669, stacks = 0, secs = 1 }, -- Taze
    -- Uldir
    { spellID = 262313, stacks = 0, secs = 5 }, -- Malodorous Miasma
    { spellID = 262314, stacks = 0, secs = 3 }, -- Putrid Paroxysm
    { spellID = 264382, stacks = 0, secs = 1 }, -- Eye Beam
    { spellID = 264210, stacks = 0, secs = 5 }, -- Jagged Mandible
    { spellID = 265360, stacks = 0, secs = 5 }, -- Roiling Deceit
    { spellID = 265129, stacks = 0, secs = 5 }, -- Omega Vector
    { spellID = 266948, stacks = 0, secs = 5 }, -- Plague Bomb
    { spellID = 274358, stacks = 0, secs = 5 }, -- Rupturing Blood
    { spellID = 274019, stacks = 0, secs = 1 }, -- Mind Flay
    { spellID = 272018, stacks = 0, secs = 1 }, -- Absorbed in Darkness
    { spellID = 273359, stacks = 0, secs = 5 }, -- Shadow Barrage
    -- Freehold
    { spellID = 257437, stacks = 0, secs = 5 }, -- Poisoning Strike
    { spellID = 267523, stacks = 0, secs = 5 }, -- Cutting Surge
    { spellID = 256363, stacks = 0, secs = 5 }, -- Ripper Punch
    { spellID = 256979, stacks = 0, secs = 2 }, -- Powder Shot
    -- Shrine of the Storm
    { spellID = 264526, stacks = 0, secs = 5 }, -- Grasp from the Depths
    { spellID = 264166, stacks = 0, secs = 1 }, -- Undertow
    { spellID = 268214, stacks = 0, secs = 1 }, -- Carve Flesh
    { spellID = 276297, stacks = 0, secs = 5 }, -- Void Seed
    { spellID = 268322, stacks = 0, secs = 5 }, -- Touch of the Drowned
    -- Siege of Boralus
    { spellID = 256897, stacks = 0, secs = 5 }, -- Clamping Jaws
    { spellID = 273470, stacks = 0, secs = 3 }, -- Gut Shot
    { spellID = 275014, stacks = 0, secs = 5 }, -- Putrid Waters
    -- Tol Dagor
    { spellID = 258058, stacks = 0, secs = 1 }, -- Squeeze
    { spellID = 260016, stacks = 0, secs = 3 }, -- Itchy Bite
    { spellID = 260067, stacks = 0, secs = 5 }, -- Vicious Mauling
    { spellID = 258864, stacks = 0, secs = 5 }, -- Suppression Fire
    { spellID = 258917, stacks = 0, secs = 3 }, -- Righteous Flames
    { spellID = 256198, stacks = 0, secs = 5 }, -- Azerite Rounds: Incendiary
    { spellID = 256105, stacks = 0, secs = 1 }, -- Explosive Burst
    -- Waycrest Manor
    { spellID = 266035, stacks = 0, secs = 1 }, -- Bone Splinter
    { spellID = 260703, stacks = 0, secs = 1 }, -- Unstable Runic Mark
    { spellID = 260741, stacks = 0, secs = 1 }, -- Jagged Nettles
    { spellID = 264050, stacks = 0, secs = 3 }, -- Infected Thorn
    { spellID = 264556, stacks = 0, secs = 2 }, -- Tearing Strike
    { spellID = 264150, stacks = 0, secs = 1 }, -- Shatter
    { spellID = 265761, stacks = 0, secs = 1 }, -- Thorned Barrage
    { spellID = 263905, stacks = 0, secs = 1 }, -- Marking Cleave
    { spellID = 264153, stacks = 0, secs = 3 }, -- Spit
    { spellID = 278456, stacks = 0, secs = 3 }, -- Infest
    { spellID = 271178, stacks = 0, secs = 3 }, -- Ravaging Leap
    { spellID = 265880, stacks = 0, secs = 1 }, -- Dread Mark
    { spellID = 265882, stacks = 0, secs = 1 }, -- Lingering Dread
    { spellID = 264378, stacks = 0, secs = 5 }, -- Fragment Soul
    { spellID = 261438, stacks = 0, secs = 1 }, -- Wasting Strike
    { spellID = 261440, stacks = 0, secs = 1 }, -- Virulent Pathogen
    { spellID = 268202, stacks = 0, secs = 1 }, -- Death Lens
    -- Atal'Dazar
    { spellID = 253562, stacks = 0, secs = 3 }, -- Wildfire
    { spellID = 254959, stacks = 0, secs = 2 }, -- Soulburn
    { spellID = 255558, stacks = 0, secs = 5 }, -- Tainted Blood
    { spellID = 255814, stacks = 0, secs = 5 }, -- Rending Maul
    { spellID = 250372, stacks = 0, secs = 5 }, -- Lingering Nausea
    { spellID = 250096, stacks = 0, secs = 1 }, -- Wracking Pain
    { spellID = 256577, stacks = 0, secs = 5 }, -- Soulfeast
    -- King's Rest
    { spellID = 269932, stacks = 0, secs = 3 }, -- Gust Slash
    { spellID = 265773, stacks = 0, secs = 4 }, -- Spit Gold
    { spellID = 270084, stacks = 0, secs = 3 }, -- Axe Barrage
    { spellID = 270865, stacks = 0, secs = 3 }, -- Hidden Blade
    { spellID = 270289, stacks = 0, secs = 3 }, -- Purification Beam
    { spellID = 271564, stacks = 0, secs = 3 }, -- Embalming
    { spellID = 267618, stacks = 0, secs = 3 }, -- Drain Fluids
    { spellID = 270487, stacks = 0, secs = 3 }, -- Severing Blade
    { spellID = 270507, stacks = 0, secs = 5 }, -- Poison Barrage
    { spellID = 266231, stacks = 0, secs = 3 }, -- Severing Axe
    { spellID = 267273, stacks = 0, secs = 3 }, -- Poison Nova
    { spellID = 268419, stacks = 0, secs = 3 }, -- Gale Slash
    -- MOTHERLODE!!
    { spellID = 269298, stacks = 0, secs = 1 }, -- Widowmaker
    { spellID = 262347, stacks = 0, secs = 1 }, -- Static Pulse
    { spellID = 263074, stacks = 0, secs = 3 }, -- Festering Bite
    { spellID = 262270, stacks = 0, secs = 1 }, -- Caustic Compound
    { spellID = 262794, stacks = 0, secs = 1 }, -- Energy Lash
    { spellID = 259853, stacks = 0, secs = 3 }, -- Chemical Burn
    { spellID = 269092, stacks = 0, secs = 1 }, -- Artillery Barrage
    { spellID = 262348, stacks = 0, secs = 1 }, -- Mine Blast
    { spellID = 260838, stacks = 0, secs = 1 }, -- Homing Missile
    -- Temple of Sethraliss
    { spellID = 263371, stacks = 0, secs = 1 }, -- Conduction
    { spellID = 272657, stacks = 0, secs = 3 }, -- Noxious Breath
    { spellID = 267027, stacks = 0, secs = 1 }, -- Cytotoxin
    { spellID = 272699, stacks = 0, secs = 3 }, -- Venomous Spit
    { spellID = 268013, stacks = 0, secs = 5 }, -- Flame Shock
    -- Underrot
    { spellID = 265019, stacks = 0, secs = 1 }, -- Savage Cleave
    { spellID = 265568, stacks = 0, secs = 1 }, -- Dark Omen
    { spellID = 260685, stacks = 0, secs = 5 }, -- Taint of G'huun
    { spellID = 278961, stacks = 0, secs = 5 }, -- Decaying Mind
    { spellID = 260455, stacks = 0, secs = 1 }, -- Serrated Fangs
    { spellID = 273226, stacks = 0, secs = 1 }, -- Decaying Spores
    { spellID = 269301, stacks = 0, secs = 5 }, -- Putrid Blood
    -- all
    { spellID = 302421, stacks = 0, secs = 5 }, -- Queen's Decree
}

local precast_spell_list = {
    --spell_id	, precast_time	,	spell_name
    { 214652, 5, 'Acidic Fragments' },
    { 205862, 5, 'Slam' },
    { 259832, 1.5, 'Massive Glaive - Stormbound Conqueror (Warport Wastari, Zuldazar, for testing purpose only)' },
    { 218774, 5, 'Summon Plasma Spheres' },
    { 206949, 5, 'Frigid Nova' },
    { 206517, 5, 'Fel Nova' },
    { 207720, 5, 'Witness the Void' },
    { 206219, 5, 'Liquid Hellfire' },
    { 211439, 5, 'Will of the Demon Within' },
    { 209270, 5, 'Eye of Guldan' },
    { 227071, 5, 'Flame Crash' },
    { 233279, 5, 'Shattering Star' },
    { 233441, 5, 'Bone Saw' },
    { 235230, 5, 'Fel Squall' },
    { 231854, 5, 'Unchecked Rage' },
    { 232174, 5, 'Frosty Discharge' },
    { 230139, 5, 'Hydra Shot' },
    { 233264, 5, 'Embrace of the Eclipse' },
    { 236542, 5, 'Sundering Doom' },
    { 236544, 5, 'Doomed Sundering' },
    { 235059, 5, 'Rupturing Singularity' },
    { 288693, 3, 'Tormented Soul - Grave Bolt (Reaping affix)' },
    { 262347, 5, 'Static Pulse' },
    { 302420, 5, 'Queen\'s Decree: Hide' },
    { 260333, 7, 'Tantrum - Underrot 2nd boss' },
    { 255577, 5, 'Transfusion' }, -- https://www.wowhead.com/spell=255577/transfusion
    { 259732, 5, 'Festering Harvest' }, --https://www.wowhead.com/spell=259732/festering-harvest
    { 285388, 5, 'Vent Jets' }, --https://www.wowhead.com/spell=285388/vent-jets
    { 291626, 3, 'Cutting Beam' }, --https://www.wowhead.com/spell=291626/cutting-beam
    { 300207, 3, 'shock-coil' }, -- https://www.wowhead.com/spell=300207/shock-coil
    { 297261, 5, 'rumble' }, -- https://www.wowhead.com/spell=297261/rumble
    { 262347, 5, 'pulse' }, --https://www.wowhead.com/spell=262347/static-pulse
    { 256106, 1, 'test shot' }, -- https://www.wowhead.com/spell=256106/azerite-powder-shot
}
--end of dbm list


local StunsBlackList = {
    -- DeOtherSide
    [171333] = "Atal'ai Devoted",
    [168942] = "Death Speaker",
    [167964] = "4.RF-4.RF",
    [166608] = "Mueh'zala",
    [169905] = "Risen Warlord",
    [168934] = "Enraged Spirit",
    [164558] = "Hakkar the Soulflayer",
    [164556] = "Millhouse Manastorm",
    [171343] = "Bladebeak Matriarch",
    [167962] = "Defunct Dental Drill",
    [164555] = "Millificent Manastorm",
    [171184] = "Mythresh, Sky's Talons",
    [164450] = "Dealer Xy'exa",
    [170572] = "Atal'ai Hoodoo Hexxer",

    -- Halls of Atonement
    [164557] = "Shard of Halkias",
    [167876] = "Inquisitor Sigar",
    [165408] = "Halkias",
    [164218] = "Lord Chamberlain",
    [174175] = "Loyal Stoneborn",
    [167612] = "Stoneborn Reaver",
    [167607] = "Stoneborn Slasher",
    [164185] = "Echelon",
    [165410] = "High Adjudicator Aleez",

    --Mists of Tirna Scithe
    [164929] = "Tirnenn Villager",
    [167111] = "Spinemaw Staghorn",
    [164926] = "Drust Boughbreaker",
    [164517] = "Tred'ova",
    [173720] = "Mistveil Gorgegullet",
    [164567] = "Ingra Maloch",
    [173655] = "Mistveil Matriarch",
    [164804] = "Droman Oulfarran",
    [173714] = "Mistveil Nightblossom",
    [164501] = "Mistcaller",

    -- Plaguefall
    [164967] = "Doctor Ickus",
    [168155] = "Plaguebound",
    [168153] = "Plagueroc",
    [163882] = "Decaying Flesh Giant",
    [163915] = "Hatchling Nest",
    [164255] = "Globgrog",
    [163894] = "Blighted Spinebreaker",
    [164266] = "Domina Venomblade",
    [169159] = "Unstable Canister",
    [169861] = "Ickor Bileflesh",
    [168396] = "Plaguebelcher",
    [168886] = "Virulax Blightweaver",
    [164267] = "Margrave Stradama",

    -- Sanguine Depths
    [162100] = "Kryxis the Voracious",
    [171799] = "Depths Warden",
    [162103] = "Executor Tarvold",
    [162038] = "Regal Mistdancer",
    [162057] = "Chamber Sentinel",
    [162099] = "General Kaal",
    [162040] = "Grand Overseer",
    [162047] = "Insatiable Brute",
    [162102] = "Grand Proctor Beryllia",
    [171376] = "Head Custodian Javlin",

    -- Spires of Ascension
    [163077] = "Azules",
    [162059] = "Kin-Tara",
    [162058] = "Ventunax",
    [162061] = "Devos",
    [162060] = "Oryphrion",
    [168681] = "Forsworn Helion",
    [168844] = "Lakesis",
    [168843] = "Klotos",
    [168845] = "Astronos",
    [168318] = "Forsworn Goliath",
    [163520] = "Forsworn Squad-Leader",


    -- The Necrotic Wave
    [164414] = "Reanimated Mage",

    --[[   -- Theater of Pain
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",


      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
      [164501] = "Mistcaller",
   ]]

    -- 8.3 tier 4 adds
    [161244] = "Blood of the Corruptor ",
    [161243] = "Samh 'rek, Beckoner of Chaos",
    [161124] = "Urg'roth, Breaker of Heroes ",
    [161241] = "Voidweaver Mal 'thir",
    -- Atal'Dazar
    [87318] = "Dazar'ai Colossus",
    [122984] = "Dazar'ai Colossus",
    [128455] = "T'lonja",
    [129553] = "Dinomancer Kish'o",
    [129552] = "Monzumi",
    -- Freehold
    [129602] = "Irontide Enforcer",
    [130400] = "Irontide Crusher",
    -- King's Rest
    [133935] = "Animated Guardian",
    [134174] = "Shadow-Borne Witch Doctor",
    [134158] = "Shadow-Borne Champion",
    [137474] = "King Timalji",
    [137478] = "Queen Wasi",
    [137486] = "Queen Patlaa",
    [137487] = "Skeletal Hunting Raptor",
    [134251] = "Seneschal M'bara",
    [134331] = "King Rahu'ai",
    [137484] = "King A'akul",
    [134739] = "Purification Construct",
    [137969] = "Interment Construct",
    [135231] = "Spectral Brute",
    [138489] = "Shadow of Zul",
    -- Shrine of the Storm
    [134144] = "Living Current",
    [136214] = "Windspeaker Heldis",
    [134150] = "Runecarver Sorn",
    [136249] = "Guardian Elemental",
    [134417] = "Deepsea Ritualist",
    [136353] = "Colossal Tentacle",
    [136295] = "Sunken Denizen",
    [136297] = "Forgotten Denizen",
    -- Siege of Boralus
    [129369] = "Irontide Raider",
    [129373] = "Dockhound Packmaster",
    [128969] = "Ashvane Commander",
    [138255] = "Ashvane Spotter",
    [138465] = "Ashvane Cannoneer",
    [135245] = "Bilge Rat Demolisher",
    -- Temple of Sethraliss
    [134991] = "Sandfury Stonefist",
    [139422] = "Scaled Krolusk Tamer",
    [136076] = "Agitated Nimbus",
    [134691] = "Static-charged Dervish",
    [139110] = "Spark Channeler",
    [136250] = "Hoodoo Hexer",
    [139946] = "Heart Guardian",
    -- MOTHERLODE!!
    [130485] = "Mechanized Peacekeeper",
    [136139] = "Mechanized Peacekeeper",
    [136643] = "Azerite Extractor",
    [134012] = "Taskmaster Askari",
    [133430] = "Venture Co. Mastermind",
    [133463] = "Venture Co. War Machine",
    [133436] = "Venture Co. Skyscorcher",
    [133482] = "Crawler Mine",
    -- Underrot
    [131436] = "Chosen Blood Matron",
    [133912] = "Bloodsworn Defiler",
    [138281] = "Faceless Corruptor",
    -- Tol Dagor
    [130025] = "Irontide Thug",
    -- Waycrest Manor
    [131677] = "Heartsbane Runeweaver",
    [135329] = "Matron Bryndle",
    [131812] = "Heartsbane Soulcharmer",
    [131670] = "Heartsbane Vinetwister",
    [135365] = "Matron Alma",
    -- Mechagon Workshop
    [151476] = "Blastatron X-80",
    [151773] = "Junkyard D.0.G.",
    -- Mechagon Junkyard
    [152009] = "Malfunctioning Scrapbot",
    [150160] = "Scrapbone Bully",
    [150276] = "Heavy Scrapbot",
    [150169] = "Toxic Lurker",
    [150292] = "Mechagon Cavalry",
    [150168] = "Toxic Monstrosity",
}


-- Profile Specific Locals - Any custom to profile locals
local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local function int (b)
    return b and 1 or 0
end

local function noDamageCheck(unit)
    if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
        return true
    end
    if hasBuff(263246, unit) then
        -- shields on first boss in temple
        return true
    end
    if hasBuff(260189, unit) then
        -- shields on last boss in MOTHERLODE
        return true
    end
    if hasBuff(261264, unit) or hasBuff(261265, unit) or hasBuff(261266, unit) then
        -- shields on witches in wm
        return true
    end
    if GetObjectID(unit) == 128652 then
        --https://www.wowhead.com/npc=128652/viqgoth
        return true
    end
    if GetObjectID(unit) == 127019 then
        --dummies inside of Freehold
        return true
    end
    return false --catchall
end

local function already_stunned(Unit)
    if Unit == nil then
        return false
    end
    local already_stunned_list = {
        [47481] = "Gnaw",
        [5211] = "Mighty Bash",
        [22570] = "Maim",
        [19577] = "Intimidation",
        [119381] = "Leg Sweep",
        [853] = "Hammer of Justice",
        [408] = "Kidney Shot",
        [1833] = "Cheap Shot",
        [199804] = "Between the eyes",
        [107570] = "Storm Bolt",
        [46968] = "Shockwave",
        [221562] = "Asphyxiate",
        [91797] = "Monstrous Blow",
        [179057] = "Chaos Nova",
        [211881] = "Fel Eruption",
        [1822] = "Rake",
        [192058] = "Capacitor Totem",
        [118345] = "Pulverize",
        [89766] = "Axe Toss",
        [30283] = "Shadowfury",
        [1122] = "Summon Infernal",
    }
    for i = 1, #already_stunned_list do
        --  Print(select(10, UnitDebuff(Unit, i)))
        local debuffSpellID = select(10, UnitDebuff(Unit, i))
        if debuffSpellID == nil then
            return false
        end

        --    Print(tostring(already_stunned_list[tonumber(debuffSpellID)]))
        if already_stunned_list[tonumber(debuffSpellID)] ~= nil then
            return true
        end
    end
    return false
end

local function ambushCondition()
    if mode.ambush == 1 and #br.friend > 1 then
        local buff_count = 0
        if (talent.ghostlyStrike and cd.ghostlyStrike.remains() < 1) then
            buff_count = buff_count + 1
        end
        if buff.broadside.exists() and br.player.power.energy.amount() > 50 and (not conduit.countTheOdds.active or buff.rollTheBones.remain() >= 10)
        then
            buff_count = buff_count + 1
        end
        if (comboDeficit >= 2 + buff_count) and not (buff.bladeFlurry.exists and #enemies.yards8 >= 2) then
            return true
        else
            return false
        end
    end
end

local function dps_key()

    -- popping CD's with DPS Key
    if mode.rotation == 1 then
        if (mode.cooldown == 1 and isChecked("Adrenaline Rush")) then
            if cast.adrenalineRush() then
                return true
            end
        end
        if cast.bladeFlurry() then
            return true
        end
        if (mode.cooldown == 1 and isChecked("Racial") or not isChecked("Racial")) then
            if isChecked("Use Racial") and cast.able.racial() and (br.player.race == "Troll" or br.player.race == "Orc") then
                if cast.racial() then
                    return true
                end
            end
        end
    end

    --marked for death
    --[[
      if talent.markedForDeath and cast.able.markedForDeath() then
          --lets find the lowest health mob to cast this on
          for i = 1, #enemies.yards25nc do
              local unit_health = UnitHealth(enemies.yards25nc[1])
              local mfd_target
              if UnitHealth(enemies.yards25nc[i]) < unit_health then
                  unit_health = UnitHealth(enemies.yards25nc[i])
                  mfd_target = enemies.yards25nc[i]
                  Print("mfd_target: " .. mfd_target .. " health: " .. unit_health)
              end
          end
          if cast.markedForDeath(mfd_target.dyn25) then
              return true
          end
      end
    ]]

end

--[[
if combo is >= max_combo - (boradside 1, opportunity 1)

if combo >= combo_max-(buff.broadside.exists()+buff.opportunity.exists())*(talent.quickDraw and(not talent.markedForDeath or cd.markedForDeath.remain() > 1))
*(br.player.traits.aceupyoursleeve.rank < 2 or cd.betweenTheEyes() > 0 or buff.rollTheBones.remain ==  0)
Finish at maximum CP. Substract one for each Broadside and Opportunity when Quick Draw is selected and MfD is not ready after the next second. Always max BtE with 2+ Ace.
]]
function buff_count()
    local buff_count = 0
    if buff.broadside.exists() then
        buff_count = buff_count + 1
    end
    if buff.opportunity.exists() then
        buff_count = buff_count + 1
    end
    if talent.quickDraw then
        buff_count = buff_count * 1
    else
        buff_count = buff_count * 0
    end
    if not talent.markedForDeath or cd.markedForDeath.remain() > 1 then
        if br.player.traits.aceupyoursleeve.rank < 2 or not cd.betweenTheEyes.exists() or buff_rollTheBones_remain == 0 then
            buff_count = buff_count * 1
        else
            buff_count = buff_count * 0
        end
    else
        buff_count = buff_count * 0
    end
    return (buff_count)
end

local timers = {}
timers._timers = {}
function timers.time(name, fn)
    local time = timers._timers[name]
    if fn then
        if not time then
            time = GetTime()
        end
    else
        time = nil
    end
    timers._timers[name] = time
    return time and (GetTime() - time) or 0
end

function getOutLaksTTD(ttd_time)
    local lowTTD = 100
    local lowTTDcount = 0
    local LowTTDtarget
    local mob_count = #enemies.yards8
    if mob_count > 6 then
        mob_count = 6
    end
    for i = 1, mob_count do
        if getTTD(enemies.yards8[i]) < lowTTD and not isExplosive(enemies.yards8[i]) and
                isSafeToAttack(enemies.yards8[i]) then
            LowTTDtarget = enemies.yards8[i]
            lowTTD = getTTD(LowTTDtarget)
        end
        if getTTD(enemies.yards8[i]) > ttd_time then
            lowTTDcount = lowTTDcount + 1
        end
    end
    return tonumber(lowTTDcount)
end

function getOutLaksTTDMAX()
    local highTTD = 0
    local mob_count = #enemies.yards8
    if mob_count > 6 then
        mob_count = 6
    end
    for i = 1, mob_count do
        if getTTD(enemies.yards8[i]) > highTTD and getTTD(enemies.yards8[i]) < 999 and not isExplosive(enemies.yards8[i]) and
                isSafeToAttack(enemies.yards8[i]) then
            highTTD = getTTD(enemies.yards8[i])
        end
    end
    return tonumber(highTTD)
end


--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------



actionList.nogcd = function()
    --skills that can be used without waiting for a gcd
end


--dps()
actionList.dps = function()


    if isChecked("Group CD's with DPS key") and SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() then
        dps_key()
    end

    if stealth and (ambush_flag or mode.ambush == 1) then
        if actionList.Stealth() then
            return true
        end
    end

    --Print(units.dyn5 or talent.acrobaticStrikes and units.dyn8)

    --Auto attack
    if not IsAutoRepeatSpell(GetSpellInfo(6603)) and #enemies.yards8 >= 1 then
        StartAttack(dynamic_target_melee)
    end
    --[[
        --Marked for death, high priority
        if talent.markedForDeath and cast.able.markedForDeath() then
            local mfdhealth = 100
            local mfdtarget
            for i = 1, #enemies.yards8 do
                if getTTD(enemies.yards8[i]) < mfdhealth then
                    mfdtarget = enemies.yards8[i]
                    mfdhealth = getTTD(enemies.yards8[i])
                end
                if cast.able.markedForDeath() and mfdtarget then
                    if cast.markedForDeath(mfdtarget) then
                    end
                end
            end]]

    if not stealth and ambushCondition() and cd.vanish.remain() <= 0.2 and getDistance(units.dyn5) <= 5 and useCDs() and not cast.last.shadowmeld(1) and (GetUnitExists(units.dyn5) and getBuffRemain(units.dyn5, 226510) == 0) then
        --and #br.friend > 0
        ambush_flag = true
        if mode.vanish == 1 then
            if cast.vanish() then
                return true
            end
        end
        if br.player.race == "NightElf" and isChecked("Use Racial") and not cast.last.vanish(1) then
            if cast.shadowmeld() then
                return true
            end
        end
    end

    --  Print(tostring(getOutLaksTTD(8)))
    if cast.able.bladeFlurry() and mode.rotation == 1 then
        local explosiveCount = 0
        for i = 1, #enemies.yards8 do
            thisUnit = enemies.yards8[i]
            if isExplosive(thisUnit) then
                explosiveCount = explosiveCount + 1
            end
        end
        -- dps cd's
        if (#enemies.yards8 - explosiveCount) >= 2 and not buff.bladeFlurry.exists() and getOutLaksTTD(8) >= 2 then
            if cast.bladeFlurry() then
                return true
            end
        end
    end

    if (mode.cooldown == 1 and isChecked("Level 90 talent row") or not isChecked("Level 90 talent row")) then
        if getCombatTime() > 2 and getFacing("player", dynamic_target_melee, 45) then
            if talent.killingSpree and cast.able.killingSpree(dynamic_target_melee)
                    and ((getTTD(dynamic_target_melee) > 5 and #enemies.yards8 < 2 or talent.acrobaticStrikes and #enemies.yards8 < 2)
                    or buff.bladeFlurry.exists()) then
                if cast.killingSpree() then
                    return true
                end
            end
            if talent.bladeRush and cast.able.bladeRush(dynamic_target_melee)
                    and (#enemies.yards8 == 1 or buff.bladeFlurry.exists())
                    and (br.player.power.energy.ttm() > 1 or #enemies.yards8 > 3)
                    and getDistance(dynamic_target_melee) <= dynamic_range then
                if cast.bladeRush(dynamic_target_melee) then
                    return true
                end
            end
        end
    end

    --flagellation
    --0.00	flagellation_cleanse,if=debuff.flagellation.remains<2

    --    if cast.able.flagellation(dynamic_target_melee) and not debuff.flagellation.exists(dynamic_target_melee) then
    --        if cast.flagellation(dynamic_target_melee) then
    --            return true
    --        end
    --    end

    if (mode.cooldown == 1 and isChecked("Adrenaline Rush") or not isChecked("Adrenaline Rush")) and getCombatTime() > 2 then
        if cast.able.adrenalineRush() and not buff.adrenalineRush.exists() and getOutLaksTTD(25) > 0 then
            if cast.adrenalineRush() then
                return true
            end
        end
    end


    -- dps regular damage
    --[[
      if combo >= comboMax - (int(buff.broadside.exists()) + int(buff.opportunity.exists()))
              * int(talent.quickDraw and (not talent.markedForDeath or cd.markedForDeath.remain() < 1))
              * int(br.player.traits.aceupyoursleeve.rank < 2 or cd.betweenTheEyes.exists())
              or hasBuff(323558) and combo == 2 or hasBuff(323559) and combo == 3 or hasBuff(323560) and combo == 4
      then
    ]]
    if not stealth and combo >= comboMax - int(buff.broadside.exists()) - (int(buff.opportunity.exists()) * int(talent.quickDraw))
            or hasBuff(323558) and combo == 2 or hasBuff(323559) and combo == 3 or hasBuff(323560) and combo == 4
    then

        if cast.able.betweenTheEyes() and ttd(units.dyn20) > combo * 3 then
            if (GetUnitExists(units.dyn20) and not isExplosive(units.dyn20)) then
                if cast.betweenTheEyes(units.dyn20) then
                    return true
                end
            end
        end

        --slice_and_dice,if=buff.slice_and_dice.remains<fight_remains&buff.slice_and_dice.remains<(1+combo_points)*1.8
        if (mode.cooldown == 1 and isChecked("Slice and Dice") or not isChecked("Slice and Dice")) then
            if cast.able.sliceAndDice() and combo > 0 and not (combo == 2 or hasBuff(323559) and combo == 3 or hasBuff(323560) and combo == 4) then
                if buff.sliceAndDice.remains() < ttd("target") and buff.sliceAndDice.remains() < (1 + combo) * 1.8 then
                    if cast.sliceAndDice() then
                        return true
                    end
                end
            end
        end

        if cast.able.dispatch(dynamic_target_melee) and not isExplosive(dynamic_target_melee) and getDistance(dynamic_target_melee) <= dynamic_range and getFacing("player", dynamic_target_melee) then
            if cast.dispatch(dynamic_target_melee) then
                return true
            end
        end
    else
        if not stealth and not should_pool and not cast.last.vanish(1) and not cast.able.ambush(dynamic_target_melee) then

            if mode.ambush == 1 and cast.able.ambush(dynamic_target_melee) then
                if cast.ambush(dynamic_target_melee) then
                    return true
                end
            end

            if talent.ghostlyStrike and cast.able.ghostlyStrike(dynamic_target_melee) then
                if cast.ghostlyStrike(dynamic_target_melee) then
                    return true
                end
            end

            if mode.cov == 1 then
                --sepsis,if=!stealthed.all
                if cast.able.sepsis(dynamic_target_melee) and not stealth and getDistance(dynamic_target_melee) < dynamic_range and getFacing("player", dynamic_target_melee) then
                    if cast.sepsis(dynamic_target_melee) then
                        return true
                    end
                end
                if cast.able.echoingReprimand(dynamic_target_melee) and not cast.able.ambush(dynamic_target_melee) then
                    if cast.echoingReprimand(dynamic_target_melee) then
                        return true
                    end
                end
                if cast.able.flagellation(dynamic_target_melee) then
                    if not debuff.flagellation.exists(dynamic_target_melee) and getTTD(dynamic_target_melee) > 10 then
                        if cast.flagellation(dynamic_target_melee) then
                            return true
                        end
                    end
                    if debuff.flagellation.remain(dynamic_target_melee) < 2 and debuff.flagellation.exists(dynamic_target_melee) and cast.able.flagellationCleanse(dynamic_target_melee) then
                        if cast.flagellationCleanse(dynamic_target_melee) then
                            return true
                        end
                    end
                end
                if cast.able.serratedBoneSpike(dynamic_target_melee) and buff.sliceAndDice.exists("player") or debuff.serratedBoneSpikeDot.exists(dynamic_target_melee)
                        or ttd(dynamic_target_melee) <= 5 or br.player.charges.serratedBoneSpike.frac() >= 2.75 then
                    if cast.serratedBoneSpike(dynamic_target_melee) then
                        return true
                    end
                end
            end

            if cast.able.pistolShot() and not cast.able.ambush(dynamic_target_melee) and
                    (buff.opportunity.exists() and (br.player.power.energy.amount() < 45 or talent.quickDraw)
                            or isChecked("Pistol Spam") and (#enemies.yards5 == 0 or talent.acrobaticStrikes and #enemies.yards8 == 0) and br.player.power.energy.amount() > getOptionValue("Pistol Spam")
                            or buff.opportunity.exists() and buff.deadShot.exists()) --or buff.greenskinsWickers.exists() or buff.concealedBlunderbuss.exists())
                    and not isExplosive(units.dyn20) and not noDamageCheck(units.dyn20) then
                --    Print("Shooting with " .. tostring(combo) .. " combo points and a deficit of: " .. tostring(comboDeficit))
                if cast.pistolShot(units.dyn20) then
                    return true
                end
            end

            if cast.able.sinisterStrike(dynamic_target_melee) and not cast.able.ambush(dynamic_target_melee) and not noDamageCheck(dynamic_target_melee) and getDistance(dynamic_target_melee) < dynamic_range and getFacing("player", dynamic_target_melee) then
                if cast.sinisterStrike(dynamic_target_melee) then
                    return true
                end
            end
            if mode.gouge == 4 and talent.dirtyTricks and cast.able.gouge(dynamic_target_melee) and getFacing(dynamic_target_melee, "player", 45) and br.player.power.comboPoints.deficit() >= 1 + (int(buff.broadside.exists())) then
                if cast.gouge(dynamic_target_melee) then
                    return true
                end
            end
        end
    end -- end finishers


    stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists() or buff.sepsis.exists()

    --variable,name=blade_flurry_sync,value=spell_targets.blade_flurry<2&raid_event.adds.in>20|buff.blade_flurry.up


    --[[
    vanish,if=!stealthed.all&variable.ambush_condition
    Using Vanish/Ambush is only a very tiny increase, so in reality, you're absolutely fine to use it as a utility spell.
    N	2.89	shadowmeld,if=!stealthed.all&variable.ambush_condition
    ]]


    --pots
    --potion support
    --[[
    1, none, frX
    2, battle, 163222
    3, RisingDeath, 152559
    4, Draenic, 109218
    5, Prolonged, 142117
    6, Empowered Proximity, 168529
    7, Focused Resolve, 168506
    8, Superior Battle, 168489
    9, unbridal fury
    10, Phantom Fire
    ]]


    if mode.pots == 1 then
        local auto_pot
        if #enemies.yards8 == 1 and isBoss("target") then
            auto_pot = getOptionValue("Pots - 1 target (Boss)")
        elseif #enemies.yards8 >= 2 and #enemies.yards8 <= 3 then
            auto_pot = getOptionValue("Pots - 2-3 targets")
        elseif #enemies.yards8 >= 4 then
            auto_pot = getOptionValue("Pots - 4+ target")
        end

        if auto_pot ~= 1 and (buff.adrenalineRush.remain() > 12 or hasBloodLust()) then

            if auto_pot == 2 and canUseItem(163222) then
                useItem(163222)
            elseif auto_pot == 3 and canUseItem(152559) then
                useItem(152559)
            elseif auto_pot == 4 and canUseItem(109218) then
                useItem(109218)
            elseif auto_pot == 5 and canUseItem(142117) then
                useItem(142117)
            elseif auto_pot == 6 and #enemies.yards8 > 3 and canUseItem(168529) then
                useItem(168529)
            elseif auto_pot == 7 and canUseItem(168506) then
                useItem(168506)
            elseif auto_pot == 8 and canUseItem(168489) then
                useItem(168489)
            elseif auto_pot == 9 and canUseItem(169299) then
                useItem(169299)
            elseif auto_pot == 10 and canUseItem(171349) then
                useItem(171349)
            end
        end
    end -- end pots


    --[[
    blood_fury
    0.00	berserking
    0.00	fireblood
    0.00	ancestral_call]]

    if (mode.cooldown == 1 and isChecked("Racial") or not isChecked("Racial")) then
        if isChecked("Use Racial") and cast.able.racial() and (br.player.race == "Troll" or br.player.race == "Orc") then
            if cast.racial() then
                return true
            end
        end
    end


    --trinkets

    if isChecked("Use Trinkets") then

        local Trinket13 = GetInventoryItemID("player", 13)
        local Trinket14 = GetInventoryItemID("player", 14)

        local hold13, hold14

        --darkmoon trinket
        if (GetInventoryItemID("player", 13) == 173087 or GetInventoryItemID("player", 14) == 173087)
                and canUseItem(173087) and inCombat and not stealth then
            useItem(173087)
        end

        --trinket 13
        if canUseItem(13) then
            if Trinket13 == 169769 then
                useItem(13, getBiggestUnitCluster(30, 8))
            else
                if not hold13 and (Trinket13 ~= 178715) then
                    if hasBloodLust() or getOutLaksTTD(20) > 1 or buff.adrenalineRush.exists() then
                        useItem(13)
                    end
                end
            end
        end
        if canUseItem(14) then
            if Trinket14 == 169769 then
                useItem(13, getBiggestUnitCluster(30, 8))
            else
                if not hold14 and (Trinket14 ~= 178715) then
                    if hasBloodLust() or getOutLaksTTD(20) > 1 or buff.adrenalineRush.exists() then
                        useItem(14)
                    end
                end
            end
        end
    end
end

actionList.Stealth = function()
    -- stealth()

    if stealth and #br.friend > 1 and (ambush_flag or do_stun ~= nil) then
        if isChecked("Cheap Shot") and cast.able.cheapShot() and not isBoss(dynamic_target_melee) and
                (talent.preyOnTheWeak and not debuff.preyOnTheWeak.exists(dynamic_target_melee) or not talent.preyOnTheWeak) or do_stun ~= nil
        then
            if do_stun == nil then
                do_stun = dynamic_target_melee
            end
            if StunsBlackList[GetObjectID(do_stun)] == nil then
                if cast.cheapShot(do_stun) then
                    br.addonDebug("Cheapshot stun")
                    do_stun = nil
                    return true
                end
            end
        end
    end
    if mode.ambush == 1 then
        if cast.ambush(dynamic_target_melee) then
            return true
        end
    end


end
actionList.Extra = function()

    if SpecificToggle("Distract") and not GetCurrentKeyBoardFocus() then
        CastSpellByName(GetSpellInfo(spell.distract), "cursor")
        return
    end
    if SpecificToggle("Blind Key") and not GetCurrentKeyBoardFocus() then
        CastSpellByName(GetSpellInfo(spell.blind), "mouseover")
        return
    end

    if (mode.cooldown == 1 and isChecked("Slice and Dice") or not isChecked("Slice and Dice")) then
        if cast.able.sliceAndDice() and combo > 0 then
            if buff.sliceAndDice.remains() < (1 + combo) * 1.8 then
                if cast.sliceAndDice() then
                    return true
                end
            end
        end
    end
    if isChecked("Group CD's with DPS key") and SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() then
        dps_key()
    end

    if isChecked("Auto Sprint") and cast.able.sprint() and timers.time("is player moving", isMoving("player")) > rnd5 and isMoving("player") and (not inCombat or #enemies.yards8 == 0) then
        if cast.sprint() then
            return true
        end
    end

    if cast.able.rollTheBones() and (inCombat or #enemies.yards25nc > 0) then
        local badguy = false
        if not inCombat and #enemies.yards25nc > 0 then
            for i = 1, #enemies.yards25nc do
                local thisUnit = enemies.yards25nc[i]
                local react = GetUnitReaction(thisUnit, "player") or 10
                if react < 4 and UnitIsEnemy("player", thisUnit) then
                    badguy = true
                end
            end
        else
            if inCombat or badguy then
                if br.timer:useTimer("check_for_buffs", 1) then
                    buff_rollTheBones_count = 0
                    for k, v in pairs(br.player.spell.buffs.rollTheBones) do
                        if UnitBuffID("player", tonumber(v)) then
                            buff_rollTheBones_remain = tonumber(getBuffRemain("player", tonumber(v)))
                            buff_rollTheBones_count = buff_rollTheBones_count + 1
                        end
                    end
                end

                if (buff_rollTheBones_count == 0 or buff_rollTheBones_remain < 3 or buff_rollTheBones_count < 2 and (buff.buriedTreasure.exists() or buff.grandMelee.exists() or buff.trueBearing.exists())) then
                    if cast.rollTheBones() then
                        br.player.ui.debug("rolling bones!")
                        return true
                    end
                end
            end
        end
    end


    -- Soothe
    if isChecked("Auto Soothe") and cast.able.shiv() and buff.numbingPoison.exists() then
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if canDispel(thisUnit, spell.shiv) and ttd(thisUnit) > getValue("Auto Soothe") then
                if cast.shiv(thisUnit) then
                    br.player.ui.debug("Soothing " .. UnitName(thisUnit))
                    return true
                end
            end
        end
    end

    --OOC trinket usage
    --Mistcaller Ocarina
    if isChecked("Use Trinkets") and not inCombat then
        if (GetInventoryItemID("player", 13) == 178715 or GetInventoryItemID("player", 14) == 178715)
                and buff.mistcallerOcarina.remain() < 60 and not isMoving("player") and canUseItem(178715) then
            useItem(178715)
            return true
        end

        if (GetInventoryItemID("player", 13) == 184016 or GetInventoryItemID("player", 14) == 184016) and canUseItem(184016) then
            if #enemies.yards25nc > 0 then
                for i = 1, #enemies.yards25nc do
                    local thisUnit = enemies.yards25nc[i]
                    local react = GetUnitReaction(thisUnit, "player") or 10
                    if react < 4 and UnitIsEnemy("player", thisUnit) then
                        useItem(184016)
                        return true
                    end
                end
            end
        end
        --Inscrutable Quantum Device
        if (GetInventoryItemID("player", 13) == 179350 or GetInventoryItemID("player", 14) == 179350) and canUseItem(179350) then
            if #enemies.yards25nc > 0 then
                for i = 1, #enemies.yards25nc do
                    local thisUnit = enemies.yards25nc[i]
                    local react = GetUnitReaction(thisUnit, "player") or 10
                    if react < 4 and UnitIsEnemy("player", thisUnit) then
                        useItem(179350)
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Extra



-- Action List - Defensive
actionList.Defensive = function()
    php = br.player.health
    local should_feint





    --just testing stuff
    --[[
       Print("Cloak mode: " .. tostring(mode.cloak))
       Print("Stun mode: " .. tostring(mode.stun))
    ]]
    if useDefensive() then
        -- dwarf racial
        if (br.player.race == "Dwarf" or br.player.race == "DarkIronDwarf") and isChecked("Use Racial") and cast.able.racial() then
            if php < 30
                    --KR
                    or UnitDebuffID("player", 266231) --266231/severing-axe
                    or UnitDebuffID("player", 270507) --270507/poison-barrage
                    or UnitDebuffID("player", 270084) --270084/axe-barrage
                    or UnitDebuffID("player", 314483) -- 314483/cascading-terror
                    --catchall
                    or canDispel("player", spell.cleanse)
            then
                if cast.racial("player") then
                    return true
                end
            end
        end

        --   Print(tostring(someone_casting))

        -- Feint
        if isChecked("Feint") and cast.able.feint() and not buff.feint.exists() and inCombat then
            for k, v in pairs(debuff_list) do
                --   Print("K: " .. tostring(k) .. " V: " .. tostring(v.spellID))
                if getDebuffRemain("player", v.spellID) > 0 then
                    --      Print("foo33")
                    should_feint = true
                end
            end
            if not should_feint then
                -- check against list of dbm timers
                for i = 1, #precast_spell_list do
                    local boss_spell_id = precast_spell_list[i][1]
                    local time_remain = br.DBM:getPulltimer(nil, boss_spell_id)
                    if time_remain < 1 then
                        should_feint = true
                    end
                end
                --if we are low on health
                if php <= getOptionValue("Feint") then
                    should_feint = true
                end
                --if we stand in shit
                if UnitDebuffID("player", 226512) -- Sanguine 226489
                        or UnitDebuffID("player", 314565) -- defiled-ground (from pillar mini boss)
                        or UnitDebuffID("player", 265773) and getDebuffRemain("player", 265773) <= 2 -- golden spit KR
                --   or UnitDebuffID("player", xx) -- fire snot in Siege
                then
                    should_feint = true
                end
            end

            if should_feint then
                if cast.feint() then
                    br.addonDebug("Feint!")
                    return true
                end
            end

        end

        --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
        if isChecked("Pot/Stoned") and php <= getValue("Pot/Stoned") and (hasHealthPot() or hasItem(5512) or hasItem(156634) or hasItem(177278)) then
            if canUseItem(177278) then
                useItem(177278)
            elseif canUseItem(5512) then
                useItem(5512)
            elseif canUseItem(156634) then
                useItem(156634)
            elseif canUseItem(169451) then
                useItem(169451)
            elseif canUseItem(getHealthPot()) then
                useItem(getHealthPot())
            elseif canUseItem(getHealthPot()) then
                useItem(getHealthPot())
            end
        end
        if mode.cov == 1 then
            if covenant.kyrian.active and not hasItem(177278) and cast.able.summonSteward() then
                if cast.summonSteward() then
                    return true
                end
            end
        end

        -- Crimson Vial
        if cast.able.crimsonVial() and isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
            if cast.crimsonVial() then
                return true
            end
        end

        -- Evasion
        if isChecked("Evasion") and php <= getOptionValue("Evasion") and inCombat then
            if cast.evasion() then
                return true
            end
        end
        if isChecked("Engineering Belt") and php <= getOptionValue("Engineering Belt") and inCombat then
            if canUseItem(6) then
                useItem(6)
            end
        end
    end


    -- Arcane Torrent
    if isChecked("Arcane Torrent Dispel") and br.player.race == "BloodElf" and getSpellCD(25046) == 0 then
        local torrentUnit = 0
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if canDispel(thisUnit, select(7, GetSpellInfo(GetSpellInfo(69179)))) then
                torrentUnit = torrentUnit + 1
                if torrentUnit >= getOptionValue("Arcane Torrent Dispel") then
                    if CastSpellByID(25046, "player") then
                        return true
                    end
                end
            end
        end
    end
    if isChecked("Arcane Torrent regen") and inCombat and race == "BloodElf" and getSpellCD(25046) == 0 and (br.player.power.energy.deficit() >= 15 + br.player.power.energy.regen()) then
        if CastSpellByID(25046, "player") then
            return true
        end
    end


    -- Unstable Temporal Time Shifter
    if isChecked("Eng Brez") and canUseItem(184308) and not moving and inCombat then
        if getOptionValue("Eng Brez") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
            UseItemByName(184308, "target")
        end
        if getOptionValue("Eng Brez") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
            UseItemByName(184308, "mouseover")
        end
        if getOptionValue("Eng Brez") == 3 then
            for i = 1, #br.friend do
                if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                    UseItemByName(184308, br.friend[i].unit)
                end
            end
        end
    end


end -- End Action List - Defensive

-- Action List - Interrrupt


actionList.Interrupt = function()
    local tanks = getTanksTable()


    --vanish logic
    local vanishList = {
        [260551] = true, -- Soul Thorns WM
        [261440] = true, -- Virulent Pathogen WM
        [266231] = true, --Severing Axe KR
        [263371] = true, --conduction
        [260741] = true, --nettles wm
        [291973] = true, --Explosive Leap
    }

    local cloakList = {
        [320788] = true, -- Frozen Binds, last boss Necrotic wave
        [261439] = true, -- Virulent Pathogen WM
        [261440] = true, -- Virulent Pathogen WM
        [265773] = true -- Spit Gold KR
    }
    local dodgeList = {
        [266231] = true -- Severing Axe KR
    }

    local feintList = {
        [256979] = true -- Powder shot FH 2nd
    }

    if useDefensive() and (cast.able.vanish() or cast.able.cloakOfShadows() or cast.able.evasion() or cast.able.feint()) then
        local bosscount = 0 -- counting bosses
        for i = 1, 5 do
            if GetUnitExists("boss" .. i) then
                bosscount = bosscount + 1
            end
        end
        for i = 1, bosscount do
            local spellname, castEndTime, interruptID, spellnamechannel, castorchan, spellID
            thisUnit = tostring("boss" .. i)
            if UnitCastingInfo(thisUnit) then
                spellname = UnitCastingInfo(thisUnit)
                -- castStartTime = select(4,UnitCastingInfo(thisUnit)) / 1000
                castEndTime = select(5, UnitCastingInfo(thisUnit)) / 1000
                interruptID = select(9, UnitCastingInfo(thisUnit))
                castorchan = "cast"
            elseif UnitChannelInfo(thisUnit) then
                spellname = UnitChannelInfo(thisUnit)
                -- castStartTime = select(4,UnitChannelInfo(thisUnit)) / 1000
                castEndTime = select(5, UnitChannelInfo(thisUnit)) / 1000
                interruptID = select(9, UnitChannelInfo(thisUnit))
                castorchan = "channel"
            end
            if spellname ~= nil then
                local castleft = castEndTime - GetTime()
                if (select(3, UnitCastID(thisUnit)) == ObjectPointer("player") or select(4, UnitCastID(thisUnit)) == ObjectPointer("player")) and castleft <= 1.5 then
                    if mode.cloak == 1 and cloakList[interruptID] then
                        if cast.cloakOfShadows() then
                            return true
                        end
                    elseif dodgeList[interruptID] then
                        if cast.evasion() then
                            return true
                        end
                    elseif br.player.talent.elusiveness and (feintList[interruptID] or getDebuffStacks("player", 240443) > 3) then
                        if cast.pool.feint() and cd.feint.remain() <= castleft then
                            should_pool = true
                        end
                        if cast.feint() then
                            should_pool = false
                            return true
                        end
                    elseif vanishList[interruptID] then
                        if cast.vanish() then
                            return true
                        end
                    end
                else
                    if cloakList[interruptID] then
                        if cast.cloakOfShadows() then
                            return true
                        end
                    elseif dodgeList[interruptID] then
                        if cast.evasion() then
                            return true
                        end
                    elseif feintList[interruptID] then
                        if cast.pool.feint() and cd.feint.remain() <= castleft then
                            should_pool = true
                        end
                        if cast.feint() then

                            should_pool = false
                            return true
                        end
                    end
                end
                -- end
            end
        end
    end

    if mode.interrupt == 1 or mode.interrupt == 3 then
        --   if useInterrupts() then
        local interrupt_target
        local distance
        local priority_target
        local mob_count = #enemies.yards20
        if mob_count > 6 then
            mob_count = 6
        end

        if isChecked("Priority Mark") then
            for i = 1, mob_count do
                if GetRaidTargetIndex(enemies.yards20[i]) == getOptionValue("Priority Mark") then
                    priority_target = enemies.yards20[i]
                    break
                end
            end
        end
        --     br.addonDebug("1 - int_target: " .. UnitName(interrupt_target))
        for i = 1, mob_count do
            if priority_target ~= nil then
                interrupt_target = priority_target
                --  Print("PRIORITY: " .. UnitName(interrupt_target))
            else
                interrupt_target = enemies.yards20[i]
            end

            -- Print("Target: " .. UnitName(interrupt_target))


            if canInterrupt(interrupt_target, getOptionValue("Interrupt %")) then
                distance = getDistance(interrupt_target)
                if not (inInstance and #tanks > 0 and select(3, UnitClass(tanks[1].unit)) == 1 and hasBuff(23920, tanks[1].unit) and UnitIsUnit(select(3, UnitCastID(interrupt_target)), tanks[1].unit)) then
                    if StunsBlackList[GetObjectID(interrupt_target)] == nil and br.player.cast.timeRemain(interrupt_target) < getTTD(interrupt_target) then
                        if cd.global.remain() == 0 then
                            if mode.gouge ~= 2 and mode.gouge < 5 and not cd.gouge.exists()
                                    and not cast.last.gouge(1)
                                    and getFacing(interrupt_target, "player", 45)
                                    and (distance < 5 or talent.acrobaticStrikes and distance < 8) then
                                if cast.gouge(interrupt_target) then
                                    someone_casting = false
                                    br.addonDebug("[int]Gouged " .. UnitName(interrupt_target))
                                    return true
                                end
                            end
                            if (mode.blind == 1 or mode.blind == 3) and distance <= 15 and cast.able.blind(interrupt_target) then
                                if cast.blind(interrupt_target) then
                                    br.addonDebug("[int]Blind " .. UnitName(interrupt_target))
                                    someone_casting = false
                                    return true
                                end
                            end
                            if cast.able.kidneyShot(interrupt_target) and (mode.kidney == 1 or mode.kidney == 3) and cast.able.kidneyShot(interrupt_target) and combo > 0 and not already_stunned(interrupt_target) then
                                if getDistance(interrupt_target) < 8 and getFacing("player", interrupt_target) then
                                    if cast.kidneyShot(interrupt_target) then
                                        br.addonDebug("[int]Kidney/stunning")
                                        someone_casting = false
                                        return true
                                    end
                                end
                            end
                        end
                    end

                    if isChecked("Kick") and not cd.kick.exists() and distance < dynamic_range and getFacing("player", interrupt_target) then
                        if cast.kick(interrupt_target) then
                            br.addonDebug("[int]Kicked " .. UnitName(interrupt_target))
                            someone_casting = false
                            if mode.interrupt == 3 then
                                RunMacroText("/br toggle interrupt 2")
                            end
                            return true
                        end

                    end
                end
            end

            --check for stun here
            if cd.global.remain() == 0 and mode.stun == 1 then
                if cast.able.blind() or cast.able.cheapShot() or cast.able.kidneyShot() then
                    distance = getDistance(interrupt_target)
                    if isCrowdControlCandidates(interrupt_target)
                            and not already_stunned(interrupt_target)
                            and GetUnitExists(interrupt_target) and getBuffRemain(interrupt_target, 226510) == 0 and distance <= 20 then
                        if mode.gouge > 1 and mode.gouge ~= 5 and cast.able.gouge() and (distance <= dynamic_range) and getFacing(interrupt_target, "player", 45) then
                            if cast.gouge(interrupt_target) then
                                br.addonDebug("[STUN]Gouge on " .. interrupt_target)
                                someone_casting = false
                                return true
                            end
                        elseif (mode.blind == 2 or mode.blind == 3) and distance <= 15 and cast.able.blind(interrupt_target) then
                            if cast.blind(interrupt_target) then
                                br.addonDebug("[STUN]Blind on " .. interrupt_target)
                                someone_casting = false
                                return true
                            end
                        elseif (mode.kidney == 2 or mode.kidney == 3) and cast.able.kidneyShot() and combo > 0 then
                            if cast.kidneyShot(interrupt_target) then
                                br.addonDebug("[STUN]Kidney on " .. interrupt_target)
                                someone_casting = false
                                return true
                            end
                        elseif cast.able.cheapShot() and not stealth then
                            if (mode.vanish == 1 and cast.able.vanish()) or (br.player.race == "NightElf" and cast.able.shadowmeld() and isChecked("Use Racial")) then
                                if mode.vanish == 1 and cast.able.vanish() then
                                    if cast.vanish() then
                                        do_stun = interrupt_target
                                        br.addonDebug("[Stun] Vanish!")
                                        someone_casting = false
                                        return true
                                    end
                                end
                                if br.player.race == "NightElf" and cast.able.shadowmeld() and isChecked("Use Racial") then
                                    if cast.shadowmeld() then
                                        do_stun = interrupt_target
                                        br.addonDebug("[Stun] ShadowMeld!")
                                        someone_casting = false
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end -- End Interrupt
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()

end -- End Action List - PreCombat

----------------
--- ROTATION ---
---------------


local someone_casting = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local function reader()
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if param == "SPELL_CAST_START" and bit.band(sourceFlags, 0x00000800) > 0 then
        C_Timer.After(0.02, function()
            someone_casting = true
            --   Print(sourceName .. " is casting " .. spellName .. " - creature[" .. tostring(bit.band(sourceFlags, 0x00000800) > 0) .. "]")
        end)
    end
end
frame:SetScript("OnEvent", reader)

local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff = br.player.buff
    cast = br.player.cast
    cd = br.player.cd
    debuff = br.player.debuff
    enemies = br.player.enemies
    equiped = br.player.equiped
    gcd = br.player.gcd
    gcdMax = br.player.gcdMax
    has = br.player.has
    covenant = br.player.covenant
    inCombat = br.player.inCombat
    item = br.player.items
    level = br.player.level
    mode = br.player.ui.mode
    php = br.player.health
    spell = br.player.spell
    talent = br.player.talent
    combo, comboDeficit, comboMax = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
    units = br.player.units
    use = br.player.use
    conduit = br.player.conduit
    stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists() or buff.sepsis.exists()
    -- General Locals
    hastar = GetObjectExists("target")
    healPot = getHealthPot()
    profileStop = profileStop or false
    ttd = getTTD
    haltProfile = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation == 4 or cast.current.focusedAzeriteBeam() or buff.soulshape.exists()
    dynamic_target_melee = talent.acrobaticStrikes and units.dyn8 or units.dyn5
    dynamic_range = talent.acrobaticStrikes and 8 or 5

    local charges = br.player.charges

    local inInstance = br.player.instance == "party" or br.player.instance == "scenario" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"
    local inRaid = br.player.instance == "raid" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"


    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(8) -- Makes a variable called, units.dyn8
    units.get(20)-- Makes a variable called, units.dyn20
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5) -- Makes a variable  called, enemies.yards5
    enemies.get(8) -- enemies.yards8
    enemies.get(8, "target") -- enemies.yards8t
    enemies.get(20)
    enemies.get(25, "player", true) -- makes enemies.yards25nc
    enemies.get(30) -- Makes a variable called, enemies.yards40
    enemies.get(40) -- Makes a variable called, enemies.yards40


    -- Profile Specific Locals

    -- executed outside of gcd
    --We will check for interrupt whenever someone is casting (based on log)
    if someone_casting == true and inCombat then
        -- if actionList.Defensive() then
        --end
        if actionList.Interrupt() then
        end
    end

    --setting some random variuables
    if br.timer:useTimer("random_timer", 5) then
        rnd5 = math.random(1, 5)
        rnd10 = math.random(1, 10)
    end


    --marked for death
    --marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.rogue&combo_points.deficit>=cp_max_spend-1)
    if #enemies.yards8 > 0 and talent.markedForDeath and cast.able.markedForDeath() and not stealth and (comboDeficit >= 4) then
        --lets find the lowest health mob to cast this on
        local unit_health = UnitHealth(enemies.yards8[1])
        local mfd_target = enemies.yards8[1]
        for i = 1, #enemies.yards8 do
            if UnitHealth(enemies.yards8[i]) < unit_health then
                unit_health = UnitHealth(enemies.yards8[i])
                mfd_target = enemies.yards8[i]
                --      Print("mfd_target: " .. mfd_target .. " health: " .. unit_health)
            end
        end
        if cast.markedForDeath(mfd_target) then
            --         Print("BAM BAM BAM : " .. mfd_target .. " health: " .. unit_health)
            -- return true
        end
    end


    --        br.ui:createDropdown(section, "Draw Range", { "Never", "Blade Flurry", "always" }, 1, "Draw range on screen")
    if inCombat and getOptionValue("Draw Range") == 3 or getOptionValue("Draw Range") == 2 and buff.bladeFlurry.exists() then
        local draw_range = talent.acrobaticStrikes and 8 or 5
        local playerX, playerY, playerZ = GetObjectPosition("player")
        LibDraw.SetColorRaw(1, 0, 0, 1)
        LibDraw.Circle(playerX, playerY, playerZ, draw_range)
    end
    --aggro management
    if isChecked("Aggro Management") and #br.friend > 1 and inCombat then
        local tricksunit
        local mob_count = #enemies.yards20
        if mob_count > 6 then
            mob_count = 6
        end
        for i = 1, mob_count do
            if not isExplosive(enemies.yards20[i]) and UnitThreatSituation("player", enemies.yards20[i]) ~= nil and UnitThreatSituation("player", enemies.yards20[i]) > 0 then
                if isChecked("[AM] - Tricks") and cast.able.tricksOfTheTrade() and #br.friend > 1 and not buff.tricksOfTheTrade.exists() then
                    for i = 1, #br.friend do
                        if UnitGroupRolesAssigned(br.friend[i].unit) == "TANK"
                                and not UnitIsDeadOrGhost(br.friend[i].unit) and getLineOfSight("player", br.friend[i].unit) and getDistance("player", br.friend[i].unit) < 25 then
                            tricksunit = br.friend[i].unit
                            break
                        end
                    end
                    if tricksunit ~= nil then
                        -- and getFacing(tricksunit, "player", 45) then
                        if cast.tricksOfTheTrade(tricksunit) then
                            br.addonDebug("[AM] - Tricks on: " .. tricksunit)
                        end
                    end
                end
                if getHP("player") < 80 then
                    if isChecked("[AM] - Kidney") and cast.able.kidneyShot(enemies.yards20[i]) and combo > 0 and getDistance(enemies.yards20[i]) < 8 and ObjectIsFacing("player", enemies.yards20[i])
                            and not isBoss(enemies.yards20[i]) and StunsBlackList[GetObjectID(enemies.yards20[i])] == nil and not already_stunned(enemies.yards20[i]) then
                        if cast.kidneyShot(enemies.yards20[i]) then
                            br.addonDebug("[AM]Kidney/stunning")
                            return true
                        end
                    end
                    if isChecked("[AM] - Evasion") and cast.able.evasion() and useDefensive() then
                        if cast.evasion() then
                            return true
                        end
                    end
                    if not stealth then
                        if isChecked("[AM] - Shadowmeld") and br.player.race == "NightElf" and cast.able.shadowmeld() and isChecked("Use Racial") and not cast.last.tricksOfTheTrade(1) then
                            if cast.shadowmeld() then
                                br.addonDebug("[AM] - Shadowmeld")
                            end
                        end
                        if isChecked("[AM] - Vanish") and mode.vanish == 1 and cast.able.vanish() and not cast.last.shadowmeld(1) and not cast.last.tricksOfTheTrade(1) then
                            if cast.vanish() then
                                br.addonDebug("[AM] - Vanish")
                            end
                        end
                    end
                end
            end
        end
    end


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause

    --lets try to kick here


    if not inCombat and not hastar and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        if timers.time("poison", not inCombat and not moving) > 1 then
            if isChecked("Lethal Poison") then
                --and not inCombat and not moving
                if getOptionValue("Lethal Poison") == 1 and buff.instantPoison.remain() < 500 and not cast.last.instantPoison(1) then
                    if cast.instantPoison("player") then
                        return true
                    end
                elseif getOptionValue("Lethal Poison") == 2 and buff.woundPoison.remain() < 500 and not cast.last.woundPoison(1) then
                    if cast.woundPoison("player") then
                        return true
                    end
                end
            end

            if isChecked("Non-Lethal Poison") then
                --and not inCombat and not moving
                if getOptionValue("Non-Lethal Poison") == 1 and buff.cripplingPoison.remain() < 500 and not cast.last.cripplingPoison(1) then
                    if cast.cripplingPoison("player") then
                        return true
                    end
                elseif getOptionValue("Non-Lethal Poison") == 2 and buff.numbingPoison.remain() < 500 and not cast.last.numbingPoison(1) and level >= 54 then
                    if cast.numbingPoison("player") then
                        return true
                    end
                end
            end
        end
        --Print(tostring(auto_stealthed))
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        ---

        if stealth then
            if actionList.Stealth() then
                return true
            end
            if getOptionValue("Auto Stealth") == 2 and #enemies.yards25nc == 0 and buff.stealth.exists() and auto_stealthed then
                cancelBuff(1784)
                auto_stealthed = nil
            end
        else
            if isChecked("Auto Stealth") and IsUsableSpell(GetSpellInfo(spell.stealth)) and not cast.last.vanish() and not IsResting() and
                    (botSpell ~= spell.stealth or (botSpellTime == nil or GetTime() - botSpellTime > 0.1)) then
                if getOptionValue("Auto Stealth") == 1 then
                    if cast.stealth() then
                        return
                    end
                end
                if getOptionValue("Auto Stealth") == 1 and not stealth then
                    if cast.stealth() then
                        return
                    end
                end
                if getOptionValue("Auto Stealth") == 2 then
                    if #enemies.yards25nc > 0 then
                        for i = 1, #enemies.yards25nc do
                            local thisUnit = enemies.yards25nc[i]
                            local react = GetUnitReaction(thisUnit, "player") or 10
                            if react < 4 and UnitIsEnemy("player", thisUnit) then
                                auto_stealthed = true
                                if cast.stealth() then
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then
            return true
        end
        -----------------
        --- Defensive ---
        -----------------

        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then
            return true
        end

        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat then
            if cd.global.remain() == 0 then
                -- isValidUnit("target") and
                if timersTable then
                    wipe(timersTable)
                end
                if actionList.Defensive() then
                    return true
                end
                if actionList.Extra() then
                    return true
                end
                if actionList.dps() then
                    return true
                end
            end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 260 -- Change to the spec id profile is for.
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
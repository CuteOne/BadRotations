local rotationName = "OutLaks" -- Change to name of profile listed in options drop down


---------------
--- Toggles ---
---------------
local function createToggles()
    -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.bladeFlurry },
        [2] = { mode = "Sing", value = 2, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.sinisterStrike },
        [3] = { mode = "Off", value = 3, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = 1804 }
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns Enabled", highlight = 0, icon = br.player.spell.adrenalineRush },
        [2] = { mode = "Off", value = 2, overlay = "Cooldowns Disabled", tip = "Cooldowns Disabled", highlight = 0, icon = br.player.spell.adrenalineRush }
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick },
        [3] = { mode = "NXT", value = 3, overlay = "Use once", tip = "Use once.", highlight = 0, icon = br.player.spell.kick }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)

    local CloakModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Cloak logic", tip = "Use Cloak logic", highlight = 0, icon = br.player.spell.cloakOfShadows },
        [2] = { mode = "Off", value = 2, overlay = "Use Cloak logic", tip = "Won't Use Cloak logic", highlight = 0, icon = br.player.spell.cloakOfShadows }
    }
    br.ui:createToggle(CloakModes, "Cloak", 5, 0)

    local PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
        [2] = { mode = "Off", value = 2, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 }
    }
    br.ui:createToggle(PotsModes, "Pots", 6, 0)

    local KidneyModes = {
        [1] = { mode = "INT", value = 1, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot },
        [2] = { mode = "STUN", value = 2, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot },
        [3] = { mode = "ALL", value = 3, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot },
        [4] = { mode = "OFF", value = 4, overlay = "Kidney Logic", tip = "Kidney Logic", highlight = 0, icon = br.player.spell.kidneyShot }
    }
    br.ui:createToggle(KidneyModes, "Kidney", 5, -1)

    local CovModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Covenant", tip = "Use Covenant powers", highlight = 0, icon = br.player.spell.summonSteward },
        [2] = { mode = "Off", value = 2, overlay = "Use Covenant", tip = "Use Covenant powers", highlight = 0, icon = br.player.spell.summonSteward }
    }
    br.ui:createToggle(CovModes, "Cov", 6, -1)

    local VanishModes = {
        [1] = { mode = "On", value = 1, overlay = "Vanish Enabled", tip = "Will use Vanish.", highlight = 0, icon = br.player.spell.vanish },
        [2] = { mode = "Off", value = 2, overlay = "Vanish Disabled", tip = "Won't use Vanish.", highlight = 0, icon = br.player.spell.vanish }
    }
    br.ui:createToggle(VanishModes, "Vanish", 1, -1)

    local AmbushModes = {
        [1] = { mode = "On", value = 1, overlay = "Ambush Enabled", tip = "Will use Ambush.", highlight = 0, icon = br.player.spell.ambush },
        [2] = { mode = "Off", value = 2, overlay = "Ambush Disabled", tip = "Won't use Ambush.", highlight = 0, icon = br.player.spell.ambush }
    }
    br.ui:createToggle(AmbushModes, "Ambush", 2, -1)

    local BlindModes = {
        [1] = { mode = "INT", value = 1, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind },
        [2] = { mode = "STUN", value = 2, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind },
        [3] = { mode = "ALL", value = 3, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind },
        [4] = { mode = "OFF", value = 4, overlay = "Blind Logic", tip = "Blind Logic", highlight = 0, icon = br.player.spell.blind }
    }
    br.ui:createToggle(BlindModes, "Blind", 3, -1)

    local GougeModes = {
        [1] = { mode = "INT", value = 1, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [2] = { mode = "STUN", value = 2, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [3] = { mode = "ALL", value = 3, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [4] = { mode = "CD", value = 4, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge },
        [5] = { mode = "OFF", value = 5, overlay = "Gouge logic", tip = "Gouge logic", highlight = 0, icon = br.player.spell.gouge }
    }
    br.ui:createToggle(GougeModes, "Gouge", 4, -1)
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
        section = br.ui:createSection(br.ui.window.profile, "Keys - 2103241515")
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
        br.ui:createDropdownWithout(section, "Pots - 1 target (Boss)", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Exorcism", "Unbridled Fury", "Phantom fire" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Exorcism", "Unbridled Fury", "Phantom fire" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Exorcism", "Unbridled Fury", "Phantom fire" }, 1, "", "Use Pot when Adrenaline is up")
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

    optionTable = {
        {
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
local charges
local gcdMax
local someone_casting
local has
local inCombat
local item
local MA_flag
local covenant
local level
local mode
local php
local spell
local runeforge
local talent
local race
local units
local use
local conduit
-- General Locals - Common Non-BR API Locals used in profiles
local devtest
local haltProfile
local hastar
local profileStop
local ttd
local lastSpell
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
local buff_rollTheBones_high = 0
local unit

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



   ]]

}


-- Profile Specific Locals - Any custom to profile locals
local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
local function int (b)
    return b and 1 or 0
end

--[[
function br.getDistance(unit)
    if unit then
        local x2, y2, z2 = br._G.ObjectPosition("target")
        local x1, y1, z1 = br._G.ObjectPosition("player")
               br.addonDebug("Distance: " .. tostring(GetDistanceBetweenPositions(x1, y1, z1, x2, y2, z2)))xxxxxxxxxxxx
        return (GetDistanceBetweenPositions(x1, y1, z1, x2, y2, z2))
    end
end
]]
local function noDamageCheck(unit)
    if br.isChecked("Dont DPS spotter") and br.GetObjectID(unit) == 135263 then
        return true
    end
    if br.hasBuff(263246, unit) then
        -- shields on first boss in temple
        return true
    end
    if br.hasBuff(260189, unit) then
        -- shields on last boss in MOTHERLODE
        return true
    end
    if br.hasBuff(261264, unit) or br.hasBuff(261265, unit) or br.hasBuff(261266, unit) then
        -- shields on witches in wm
        return true
    end
    if br.GetObjectID(unit) == 128652 then
        --https://www.wowhead.com/npc=128652/viqgoth
        return true
    end
    if br.GetObjectID(unit) == 127019 then
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
        local debuffSpellID = select(10, br._G.UnitDebuff(Unit, i))
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

local function int (b)
    return b and 1 or 0
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
        -- (!runeforge.deathly_shadows|buff.deathly_shadows.down&combo_points<=2)
        if (comboDeficit >= 2 + buff_count) and (#enemies.yards8 == 1 or buff.bladeFlurry.exists())
                and (not runeforge.deathlyShadows.equiped or not buff.deathlyShadows.exists() and combo <= 2) then
            return true
        else
            return false
        end
    end
end

local function dps_key()

    -- popping CD's with DPS Key
    if mode.rotation == 1 then

        if runeforge.markOfTheMasterAssassin.equiped and talent.killingSpree then
            if cd.killingSpree.ready() and (cd.vanish.ready() or MA_flag)
                    and (buff.bladeFlurry.remains() > 3.5 or cd.bladeFlurry.ready() or #enemies.yards8 == 1)
            then
                if buff.bladeFlurry.remains() < 2 and #enemies.yards8 > 1 then
                    if cast.bladeFlurry() then
                        return true
                    end
                end
                if cast.vanish() then
                    MA_flag = true
                    return true
                end
                if stealth and buff.bladeFlurry.remains() > 3.5 then
                    if cast.ambush("target") then
                        return true
                    end
                end
                if cast.killingSpree() then
                    MA_flag = nil
                    return true
                end
            end
        elseif runeforge.deathlyShadows.equiped and talent.bladeRush then
            if cd.bladeRush.ready() and (cd.vanish.ready() or MA_flag)
                    and (buff.bladeFlurry.remains() > 3.5 or cd.bladeFlurry.ready() or #enemies.yards8 == 1)
            then
                if buff.bladeFlurry.remains() < 2 and #enemies.yards8 > 1 then
                    if cast.bladeFlurry() then
                        return true
                    end
                end
                if cast.vanish() then
                    MA_flag = true
                    return true
                end
                if cast.bladeRush() then
                    MA_flag = nil
                    return true
                end
            end
        else
            if (mode.cooldown == 1 and br.isChecked("Adrenaline Rush")) then
                if cast.adrenalineRush() then
                    return true
                end
            end
            if cast.bladeFlurry() then
                return true
            end
            if (mode.cooldown == 1 and br.isChecked("Racial") or not br.isChecked("Racial")) then
                if br.isChecked("Use Racial") and cast.able.racial() and (br.player.race == "Troll" or br.player.race == "Orc" or br.player.race == "MagharOrc") then
                    if cast.racial() then
                        return true
                    end
                end
            end
        end
    end
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
            time = br._G.GetTime()
        end
    else
        time = nil
    end
    timers._timers[name] = time
    return time and (br._G.GetTime() - time) or 0
end

local function getOutLaksTTD(ttd_time)
    local lowTTD = 100
    local lowTTDcount = 0
    local LowTTDtarget
    local mob_count = #enemies.yards8
    if mob_count > 6 then
        mob_count = 6
    end
    for i = 1, mob_count do
        if br.getTTD(enemies.yards8[i]) < lowTTD
                and br.GetObjectID(enemies.yards8[i]) ~= 120651
                and br.GetObjectID(enemies.yards8[i]) ~= 174773
                and br.isSafeToAttack(enemies.yards8[i]) then
            LowTTDtarget = enemies.yards8[i]
            lowTTD = br.getTTD(LowTTDtarget)
        end
        if br.getTTD(enemies.yards8[i]) > ttd_time then
            lowTTDcount = lowTTDcount + 1
        end
    end
    return tonumber(lowTTDcount)
end

local function shitmob(Unit)
    if br.GetObjectID(Unit) == 120651
            or br.GetObjectID(Unit) == 174773
    then
        return true
    else
        return false
    end
end
local function getOutLaksTTDMAX()
    local highTTD = 0
    local mob_count = #enemies.yards
    if mob_count > 6 then
        mob_count = 6
    end
    for i = 1, mob_count do
        if br.getTTD(enemies.yards8[i]) > highTTD and br.getTTD(enemies.yards8[i]) < 999 and not br.isExplosive(enemies.yards8[i]) and
                br.isSafeToAttack(enemies.yards8[i]) then
            highTTD = br.getTTD(enemies.yards8[i])
        end
    end
    return tonumber(highTTD)
end

local function focus(spell, target)
    if devtest == 1 then
        if select(4, GetSpellInfo(spell)) == 0 and br.getSpellCD(spell) == 0 then
            if target == nil then
                if spell == 35395 then
                    for i = 1, #enemies.yards5 do
                        if unit.exists("target") and unit.distance("target") <= 5 and not unit.isUnit("target", "player") then
                            target = "target"
                        else
                            target = enemies.yards5[i]
                        end
                    end
                end
                if spell == 24275 or spell == 275773 or spell == 20473 then
                    for i = 1, #enemies.yards30 do
                        if unit.exists("target") and unit.distance("target") <= 30 and not unit.isUnit("target", "player") then
                            target = "target"
                        else
                            target = enemies.yards30[i]
                        end
                    end
                end
            end
            if unit.valid(target) and br.getLineOfSight("player", target) then
                local curFacing = br._G.ObjectFacing("player")
                br._G.FaceDirection(target, true)
                br._G.CastSpellByName(br._G.GetSpellInfo(spell), target)
                br._G.FaceDirection(curFacing)
            end
        else
            if not ui.checked("Dev Stuff Leave off") and br.getSpellCD(spell) == 0 then
                if target == nil then
                    if spell == 35395 then
                        target = units.dyn5
                    end
                    if spell == 24275 or spell == 275773 or spell == 20473 then
                        target = units.dyn30
                    end
                end
                if unit.valid(target) and br.getLineOfSight("player", target) then
                    if unit.facing("player", target) then
                        br._G.CastSpellByName(br._G.GetSpellInfo(spell), target)
                    end
                end
            end
        end
    end
end

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------



actionList.nogcd = function()
    --skills that can be used without waiting for a gcd
end


--dps()
actionList.dps = function()

    if mode.vanish == 1 and cast.able.vanish() and (mode.cooldown == 1 and br.isChecked("Adrenaline Rush") or not br.isChecked("Adrenaline Rush"))
            and br.isBoss() and not stealth and unit.distance(dynamic_target_melee) < 8 and br.getCombatTime() < 4 and not buff.masterAssassinsMark.exists() then
        cast.adrenalineRush()
        cast.vanish()
        return true
    end

    if mode.vanish == 1 and not stealth and cast.able.vanish() and (cd.killingSpree.remain() < 1 or cd.bladeRush.remain() < 1) and not buff.masterAssassinsMark.exists() and runeforge.markOfTheMasterAssassin.equiped then
        if cast.vanish() then
            return true
        end
    end

    if br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() then
        dps_key()
    end

    if (stealth or lastSpellCast == spell.vanish) and (ambush_flag or mode.ambush == 1 or runeforge.markOfTheMasterAssassin.equiped) then
        if actionList.Stealth() then
            return true
        end
    else

        --Print(units.dyn5 or talent.acrobaticStrikes and units.dyn8)

        --Auto attack
        if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and #enemies.yards8 >= 1 then
            br._G.StartAttack()
        end
        --[[
            --Marked for death, high priority
            if talent.markedForDeath and cast.able.markedForDeath() then
                local mfdhealth = 100
                local mfdtarget
                for i = 1, #enemies.yards8 do
                    if br.getTTD(enemies.yards8[i]) < mfdhealth then
                        mfdtarget = enemies.yards8[i]
                        mfdhealth = br.getTTD(enemies.yards8[i])
                    end
                    if cast.able.markedForDeath() and mfdtarget then
                        if cast.markedForDeath(mfdtarget) then
                        end
                    end
                end]]

        if not stealth and ambushCondition() and cd.vanish.remain() <= 0.2 and br.getDistance(units.dyn5) <= 5 and not cast.last.shadowmeld(1) and (br.GetUnitExists(units.dyn5) and (br.getBuffRemain(units.dyn5, 226510) == 0 or not br.isChecked("Cheap Shot")))
                and #br.friend > 1 then
            ambush_flag = true
            if mode.vanish == 1 then
                if cast.vanish() then
                    return true
                end
            end
            if br.player.race == "NightElf" and br.isChecked("Use Racial") and not cast.last.vanish(1) then
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
                if br.isExplosive(thisUnit) or br.getUnitID(thisUnit) == 166969 or br.getUnitID(thisUnit) == 166970 or br.getUnitID(thisUnit) == 175992 then
                    explosiveCount = explosiveCount + 1
                end
            end
            -- dps cd's
            if (#enemies.yards8 - explosiveCount) >= 2 and not buff.bladeFlurry.exists() then
                if cast.bladeFlurry() then
                    return true
                end
            end
        end

        if (mode.cooldown == 1 and br.isChecked("Level 90 talent row") or not br.isChecked("Level 90 talent row")) then
            if br.getCombatTime() > 2 and br.getFacing("player", dynamic_target_melee, 45) then
                if talent.killingSpree and cast.able.killingSpree(dynamic_target_melee)
                        and (((br.getTTD(dynamic_target_melee) > 5 and #enemies.yards8 < 2 or talent.acrobaticStrikes and #enemies.yards8 < 2) or buff.bladeFlurry.remain() > 2)
                        and (buff.masterAssassinsMark.remain() > 2 or not runeforge.markOfTheMasterAssassin.equiped)) then
                    if cast.killingSpree() then
                        return true
                    end
                end

                if talent.bladeRush and cast.able.bladeRush(dynamic_target_melee)
                        and (#enemies.yards8 == 1 or buff.bladeFlurry.exists())
                        --and (br.player.power.energy.ttm() > 1 or #enemies.yards8 > 2 or energy <= 30)
                        and unit.distance(dynamic_target_melee) <= dynamic_range
                        and (buff.masterAssassinsMark.remain() > 1 or cd.vanish.remain() > 30 or cast.last.vanish(1) or mode.vanish ~= 1 or not runeforge.markOfTheMasterAssassin.equiped)
                then
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

        if (mode.cooldown == 1 and br.isChecked("Adrenaline Rush") or not br.isChecked("Adrenaline Rush")) and (br.getCombatTime() > 2 or br.isBoss()) then
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
                  or br.hasBuff(323558) and combo == 2 or br.hasBuff(323559) and combo == 3 or br.hasBuff(323560) and combo == 4
          then
        ]]
        if not stealth and ((combo >= comboMax - int(buff.broadside.exists()) - (int(buff.opportunity.exists()) * int(talent.quickDraw)))
                or (cd.echoingReprimand.exists() and
                (
                        (br.hasBuff(323558) and combo == 2) or (br.hasBuff(323559) and combo == 3) or (br.hasBuff(323560) and combo == 4)
                ))
        )
        then

            if cd.betweenTheEyes.ready() and not buff.masterAssassinsMark.exists() and ttd(dynamic_target_melee) > 3
                    and not shitmob(dynamic_target_melee)
            then
                if cast.betweenTheEyes(dynamic_target_melee) then
                    return true
                end
            end

            --slice_and_dice,if=buff.slice_and_dice.remains<fight_remains&buff.slice_and_dice.remains<(1+combo_points)*1.8
            if (mode.cooldown == 1 and br.isChecked("Slice and Dice") or not br.isChecked("Slice and Dice")) and not buff.grandMelee.exists() and not buff.masterAssassinsMark.exists() then
                if cast.able.sliceAndDice() and combo > 0 and not ((br.hasBuff(323558) and combo == 2) or (br.hasBuff(323559) and combo == 3) or (br.hasBuff(323560) and combo == 4)) then
                    if buff.sliceAndDice.remains() < ttd("target") and buff.sliceAndDice.remains() < (1 + combo) * 1.8 and br.getCombatTime() > 2 then
                        if cast.sliceAndDice() then
                            return true
                        end
                    end
                end
            end

            if cast.able.dispatch(dynamic_target_melee) and not br.isExplosive(dynamic_target_melee) and br.getDistance(dynamic_target_melee) <= dynamic_range and br.getFacing("player", dynamic_target_melee) then
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
                    if cast.able.sepsis(dynamic_target_melee) and not stealth and br.getDistance(dynamic_target_melee) < dynamic_range and br.getFacing("player", dynamic_target_melee) then
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
                        if not debuff.flagellation.exists(dynamic_target_melee) and br.getTTD(dynamic_target_melee) > 10 then
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

                    if not stealth and charges.serratedBoneSpike.count() > 0 and br.getBuffRemain("player", 342181) <= 3 then
                        local spikeCount = debuff.serratedBoneSpike.count() + 2 + int(buff.broadside.exists())
                        local spikeList
                        if devtest == 0 then
                            spikeList = enemies.get(30, "player", false, true)
                        else
                            spikeList = enemies.get(30)
                        end
                        if #spikeList > 0 then
                            if (buff.bladeFlurry.exists("player") or #enemies.yards8 <= 1)
                                    and (comboDeficit >= spikeCount or (spikeCount > 3 and combo < 2)) and not buff.opportunity.exists() then
                                if #spikeList > 1 then
                                    table.sort(spikeList, function(x, y)
                                        return br.getHP(x) < br.getHP(y)
                                    end
                                    )
                                end
                                for i = 1, #spikeList do
                                    if br.isSafeToAttack(spikeList[i]) and not debuff.serratedBoneSpikeDot.exists(spikeList[i]) then
                                        if devtest == 0 then
                                            if cast.serratedBoneSpike(spikeList[i]) then
                                                return true
                                            end
                                        else
                                            if unit.valid(spikeList[i]) and br.getLineOfSight("player", spikeList[i]) then
                                                local curFacing = br._G.ObjectFacing("player")
                                                br._G.FaceDirection(spikeList[i], true)
                                                br._G.CastSpellByName(br._G.GetSpellInfo(328547), spikeList[i])
                                                br._G.FaceDirection(curFacing)
                                            end
                                        end
                                    end
                                end
                                if #spikeList == 1 and comboDeficit == 2 or comboDeficit >= spikeCount then
                                    if cast.serratedBoneSpike("target") then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end -- end covenant

                if cast.able.pistolShot()
                        and (buff.opportunity.exists()
                        and (br.player.power.energy.deficit() > (br.player.power.energy.regen() + 10) or comboDeficit <= 1 + int(buff.broadside.exists()) or talent.quickDraw)
                        or br.isChecked("Pistol Spam") and (#enemies.yards5 == 0 or talent.acrobaticStrikes and #enemies.yards8 == 0) and br.player.power.energy.amount() > br.getOptionValue("Pistol Spam"))
                        and not br.isExplosive(units.dyn20) and not noDamageCheck(units.dyn20) and not stealth then
                    if devtest == 0 then
                        if cast.pistolShot(units.dyn20) then
                            return true
                        end
                    else
                        if unit.valid(enemies.dyn20) and br.getLineOfSight("player", enemies.dyn20) then
                            local curFacing = br._G.ObjectFacing("player")
                            br._G.FaceDirection(enemies.dyn20, true)
                            br._G.CastSpellByName(br._G.GetSpellInfo(185763), enemies.dyn20)
                            br._G.FaceDirection(curFacing)
                        end
                    end
                end

                if cast.able.sinisterStrike(dynamic_target_melee) and not stealth and not cast.able.ambush(dynamic_target_melee) and not noDamageCheck(dynamic_target_melee) and br.getDistance(dynamic_target_melee) < dynamic_range and br.getFacing("player", dynamic_target_melee) then
                    if cast.sinisterStrike(dynamic_target_melee) then
                        return true
                    end
                end
                if mode.gouge == 4 and talent.dirtyTricks and cast.able.gouge(dynamic_target_melee) and br.getFacing(dynamic_target_melee, "player", 45) and br.player.power.comboPoints.deficit() >= 1 + (int(buff.broadside.exists())) then
                    if cast.gouge(dynamic_target_melee) then
                        return true
                    end
                end
            end
        end -- end finishers
    end

    stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists() or buff.sepsis.exists()

    if mode.pots == 1 then
        local auto_pot
        if #enemies.yards8 == 1 and br.isBoss("target") then
            auto_pot = br.getOptionValue("Pots - 1 target (Boss)")
        elseif #enemies.yards8 >= 2 and #enemies.yards8 <= 3 then
            auto_pot = br.getOptionValue("Pots - 2-3 targets")
        elseif #enemies.yards8 >= 4 then
            auto_pot = br.getOptionValue("Pots - 4+ target")
        end

        if auto_pot ~= 1 and (buff.adrenalineRush.remain() > 12 or br.hasBloodLust()) then

            if auto_pot == 2 and br.canUseItem(163222) then
                br.useItem(163222)
            elseif auto_pot == 3 and br.canUseItem(152559) then
                br.useItem(152559)
            elseif auto_pot == 4 and br.canUseItem(109218) then
                br.useItem(109218)
            elseif auto_pot == 5 and br.canUseItem(142117) then
                br.useItem(142117)
            elseif auto_pot == 6 and #enemies.yards8 > 3 and br.canUseItem(168529) then
                br.useItem(168529)
            elseif auto_pot == 7 and br.canUseItem(168506) then
                br.useItem(168506)
            elseif auto_pot == 8 and br.canUseItem(171352) then
                br.useItem(171352)
            elseif auto_pot == 9 and br.canUseItem(169299) then
                br.useItem(169299)
            elseif auto_pot == 10 and br.canUseItem(171349) then
                br.useItem(171349)
            end
        end
    end -- end pots


    if (mode.cooldown == 1 and br.isChecked("Racial") or not br.isChecked("Racial")) then
        if br.isChecked("Use Racial") and cast.able.racial() and (br.player.race == "Troll" or br.player.race == "Orc") then
            if cast.racial() then
                return true
            end
        end
    end

    --trinkets

    if br.isChecked("Use Trinkets") then

        local Trinket13 = br._G.GetInventoryItemID("player", 13)
        local Trinket14 = br._G.GetInventoryItemID("player", 14)


        -- Skuler's Wing
        if (Trinket13 == 184016 or Trinket14 == 184016)
                and br.canUseItem(184016) and inCombat and not stealth and unit.distance(dynamic_target_melee) < 8 then
            br.useItem(184016)
        end
        --darkmoon trinket
        if (Trinket13 == 173087 or Trinket14 == 173087)
                and br.canUseItem(173087) and inCombat and not stealth then
            br.useItem(173087)
        end

        --trinket 13
        if br.canUseItem(13) then
            if Trinket13 == 169769 then
                br.useItem(13, br.getBiggestUnitCluster(30, 8))
            elseif Trinket13 == 179356 and br.getTTD("target") > 15 then
                br.useItem(13)
            else
                if (Trinket13 ~= 178715 and Trinket13 ~= 179356) then
                    if br.hasBloodLust() or getOutLaksTTD(20) > 0 or buff.adrenalineRush.exists() then
                        br.useItem(13)
                    end
                end
            end
        end
        if br.canUseItem(14) then
            if Trinket14 == 169769 then
                br.useItem(13, br.getBiggestUnitCluster(30, 8))
            else
                if (Trinket14 ~= 178715) then
                    if br.hasBloodLust() or getOutLaksTTD(20) > 0 or buff.adrenalineRush.exists() then
                        br.useItem(14)
                    end
                end
            end
        end
    end
end

actionList.Stealth = function()
    -- stealth()

    if stealth then
        --marked for death
        if talent.markedForDeath and cast.able.markedForDeath() and not buff.sliceAndDice.exists and #enemies.yards25nc > 1 then
            local mfd_target
            --lets find the lowest health mob to cast this on
            for i = 1, #enemies.yards25nc do
                local unit_health = br._G.UnitHealth(enemies.yards25nc[1])
                if br._G.UnitHealth(enemies.yards25nc[i]) < unit_health then
                    unit_health = br._G.UnitHealth(enemies.yards25nc[i])
                    mfd_target = enemies.yards25nc[i]
                end
            end
            if mfd_target then
                if cast.markedForDeath(mfd_target.dyn25) then
                    br.addonDebug("mfd_target: " .. mfd_target)
                    return true
                end
            end
        end

        if do_stun ~= nil then
            if br.isChecked("Cheap Shot") and cast.able.cheapShot() and not br.isBoss(dynamic_target_melee) and
                    (talent.preyOnTheWeak and not debuff.preyOnTheWeak.exists(dynamic_target_melee) or not talent.preyOnTheWeak) or do_stun ~= nil
            then
                if do_stun == nil then
                    do_stun = dynamic_target_melee
                end
                if StunsBlackList[br.GetObjectID(do_stun)] == nil then
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
end
actionList.Extra = function()

    if br.SpecificToggle("Distract") and not br._G.GetCurrentKeyBoardFocus() then
        br._G.CastSpellByName(br._G.GetSpellInfo(spell.distract), "cursor")
        return
    end
    if br.SpecificToggle("Blind Key") and not br._G.GetCurrentKeyBoardFocus() then
        br._G.CastSpellByName(br._G.GetSpellInfo(spell.blind), "mouseover")
        return
    end

    if br.SpecificToggle("DPS Key") and not br._G.GetCurrentKeyBoardFocus() then
        dps_key()
    end

    if (mode.cooldown == 1 and br.isChecked("Slice and Dice") or not br.isChecked("Slice and Dice")) and not buff.grandMelee.exists() and (not buff.masterAssassinsMark.exists() or stealth) then
        if cast.able.sliceAndDice() and combo > 0 then
            if buff.sliceAndDice.remains() < (1 + combo) * 1.8 and (br.getCombatTime() > 2 or cd.vanish.exists()) then
                if cast.sliceAndDice() then
                    return true
                end
            end
        end
    end

    if br.isChecked("Auto Sprint") and cast.able.sprint() and timers.time("is player moving", br.isMoving("player")) > rnd5 and br.isMoving("player") and (not inCombat or #enemies.yards8 == 0) then
        if cast.sprint() then
            return true
        end
    end

    if cast.able.rollTheBones() and (inCombat or #enemies.yards8 > 0 or br.DBM:getPulltimer() < 1.5) and (not buff.masterAssassinsMark.exists() or stealth) then
        local badguy = false
        if not inCombat and #enemies.yards25nc > 0 then
            for i = 1, #enemies.yards25nc do
                local thisUnit = enemies.yards25nc[i]
                local react = br.GetUnitReaction(thisUnit, "player") or 10
                if react < 4 and br._G.UnitIsEnemy("player", thisUnit) then
                    badguy = true
                end
            end
        end
        if inCombat or badguy then
            if br.timer:useTimer("check_for_buffs", 1) then
                buff_rollTheBones_count = 0
                for k, v in pairs(br.player.spell.buffs.rollTheBones) do
                    if br.UnitBuffID("player", tonumber(v)) then
                        buff_rollTheBones_remain = tonumber(br.getBuffRemain("player", tonumber(v)))
                        buff_rollTheBones_count = buff_rollTheBones_count + 1
                        if buff_rollTheBones_remain > buff_rollTheBones_high then
                            buff_rollTheBones_high = buff_rollTheBones_remain
                        end
                    end
                end
            end
            if (buff_rollTheBones_count == 0 or buff_rollTheBones_high <= 3 or (buff_rollTheBones_count < 2 and not buff.trueBearing.exists() and not buff.broadside.exists())) then
                if cast.rollTheBones() then
                    br.player.ui.debug("rolling bones!")
                    return true
                end
            end
        end
    end


    -- Soothe
    if br.isChecked("Auto Soothe") and cast.able.shiv() and buff.numbingPoison.exists() then
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if br.canDispel(thisUnit, spell.shiv) and ttd(thisUnit) > br.getValue("Auto Soothe") then
                if cast.shiv(thisUnit) then
                    br.player.ui.debug("Soothing " .. br._G.UnitName(thisUnit))
                    return true
                end
            end
        end
    end

    --OOC trinket usage
    --Mistcaller Ocarina
    if br.isChecked("Use Trinkets") and not inCombat then
        if (br._G.GetInventoryItemID("player", 13) == 178715 or br._G.GetInventoryItemID("player", 14) == 178715)
                and buff.mistcallerOcarina.remain() < 60 and not br.isMoving("player") and br.canUseItem(178715) then
            br.useItem(178715)
            return true
        end

        --[[
        if  (br._G.GetInventoryItemID("player", 13) == 184016 or br._G.GetInventoryItemID("player", 14) == 184016) and br.canUseItem(184016) then
            if #enemies.yards25nc > 0 then
                for i = 1, #enemies.yards25nc do
                    local thisUnit = enemies.yards25nc[i]
                    local react = br.GetUnitReaction(thisUnit, "player") or 10
                    if react < 4 and br._G.UnitIsEnemy("player", thisUnit) then
                        br.useItem(184016)
                        return true
                    end
                end
            end
        end
        --Inscrutable Quantum Device
        if  (br._G.GetInventoryItemID("player", 13) == 179350 or br._G.GetInventoryItemID("player", 14) == 179350) and br.canUseItem(179350) then
            if #enemies.yards25nc > 0 then
                for i = 1, #enemies.yards25nc do
                    local thisUnit = enemies.yards25nc[i]
                    local react = br.GetUnitReaction(thisUnit, "player") or 10
                    if react < 4 and br._G.UnitIsEnemy("player", thisUnit) then
                        br.useItem(179350)
                        return true
                    end
                end
            end
        end]]
    end
end -- End Action List - Extra



-- Action List - Defensive
actionList.Defensive = function()
    php = br.player.health
    local should_feint

    if br.useDefensive() then
        -- dwarf racial
        if (br.player.race == "Dwarf" or br.player.race == "DarkIronDwarf") and br.isChecked("Use Racial") and cast.able.racial() then
            if php < 30
                    --KR
                    or br.UnitDebuffID("player", 266231) --266231/severing-axe
                    or br.UnitDebuffID("player", 270507) --270507/poison-barrage
                    or br.UnitDebuffID("player", 270084) --270084/axe-barrage
                    or br.UnitDebuffID("player", 314483) -- 314483/cascading-terror
                    --catchall
                    or br.canDispel("player", spell.cleanse)
            then
                if cast.racial("player") then
                    return true
                end
            end
        end

        --   Print(tostring(someone_casting))

        -- Feint
        if br.isChecked("Feint") and cast.able.feint() and not buff.feint.exists() and inCombat then
            for k, v in pairs(debuff_list) do
                if br.getDebuffRemain("player", v.spellID) > 0 then
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
                if php <= br.getOptionValue("Feint") then
                    should_feint = true
                end
                --if we stand in shit
                if br.UnitDebuffID("player", 226512) -- Sanguine 226489
                        or br.UnitDebuffID("player", 314565) -- defiled-ground (from pillar mini boss)
                        or br.UnitDebuffID("player", 265773) and br.getDebuffRemain("player", 265773) <= 2 -- golden spit KR
                --   or br.UnitDebuffID("player", xx) -- fire snot in Siege
                then
                    should_feint = true
                end
            end

            if cast.able.feint() and should_feint then
                if cast.feint() then
                    br.addonDebug("Feint!")
                    return true
                end
            end

        end

        --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
        if br.isChecked("Pot/Stoned") and php <= br.getValue("Pot/Stoned") and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(156634) or br.hasItem(177278)) then
            if br.canUseItem(5512) then
                br.useItem(5512)
            elseif br.canUseItem(177278) then
                br.useItem(177278)
            elseif br.canUseItem(171267) then
                br.useItem(171267)
            end
        end

        if mode.cov == 1 then
            if covenant.kyrian.active and not br.hasItem(177278) and cast.able.summonSteward() and not inCombat then
                if cast.summonSteward() then
                    return true
                end
            end
        end

        -- Crimson Vial
        if cast.able.crimsonVial() and br.isChecked("Crimson Vial") and php < br.getOptionValue("Crimson Vial") then
            if cast.crimsonVial() then
                return true
            end
        end

        -- Evasion
        if br.isChecked("Evasion") and php <= br.getOptionValue("Evasion") and inCombat then
            if cast.evasion() then
                return true
            end
        end
        if br.isChecked("Engineering Belt") and php <= br.getOptionValue("Engineering Belt") and inCombat then
            if br.canUseItem(6) then
                br.useItem(6)
            end
        end
    end


    -- Arcane Torrent
    if br.isChecked("Arcane Torrent Dispel") and br.player.race == "BloodElf" and br.getSpellCD(25046) == 0 then
        local torrentUnit = 0
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if br.canDispel(thisUnit, select(7, br._G.GetSpellInfo(br._G.GetSpellInfo(69179)))) then
                torrentUnit = torrentUnit + 1
                if torrentUnit >= br.getOptionValue("Arcane Torrent Dispel") then
                    if br._G.CastSpellByID(25046, "player") then
                        return true
                    end
                end
            end
        end
    end
    if br.isChecked("Arcane Torrent regen") and inCombat and race == "BloodElf" and br.getSpellCD(25046) == 0 and (br.player.power.energy.deficit() >= 15 + br.player.power.energy.regen()) and br.getCombatTime() > 4 then
        if br._G.CastSpellByID(25046, "player") then
            return true
        end
    end


    -- Unstable Temporal Time Shifter
    if br.isChecked("Eng Brez") and br.canUseItem(184308) and not moving and inCombat then
        if br.getOptionValue("Eng Brez") == 1 and br._G.UnitIsPlayer("target") and br.GetUnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target", "player") then
            br._G.UseItemByName(184308, "target")
        end
        if br.getOptionValue("Eng Brez") == 2 and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
            br._G.UseItemByName(184308, "mouseover")
        end
        if br.getOptionValue("Eng Brez") == 3 then
            for i = 1, #br.friend do
                if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") then
                    br._G.UseItemByName(184308, br.friend[i].unit)
                end
            end
        end
    end


end -- End Action List - Defensive

-- Action List - Interrrupt


actionList.Interrupt = function()
    local tanks = br.getTanksTable()


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
        [265773] = true, -- Spit Gold KR
        [322554] = true, -- Castigate SD
    }
    local dodgeList = {
        [266231] = true, -- Severing Axe KR
    }

    local feintList = {
        [325245] = true, -- Shadow Ambush PF
        [323195] = true, -- Purifying Blast SoA
        [319592] = true, -- Stone Shattering Leap HoA
    }

    if br.useDefensive() and (cast.able.vanish() or cast.able.cloakOfShadows() or cast.able.evasion() or cast.able.feint()) then
        local bosscount = 0 -- counting bosses
        for i = 1, 5 do
            if br.GetUnitExists("boss" .. i) then
                bosscount = bosscount + 1
            end
        end
        for i = 1, bosscount do
            local spellname, castEndTime, interruptID, spellnamechannel, castorchan, spellID
            local thisUnit = tostring("boss" .. i)
            if br._G.UnitCastingInfo(thisUnit) then
                spellname = br._G.UnitCastingInfo(thisUnit)
                -- castStartTime = select(4,br._G.UnitCastingInfo(thisUnit)) / 1000
                castEndTime = select(5, br._G.UnitCastingInfo(thisUnit)) / 1000
                interruptID = select(9, br._G.UnitCastingInfo(thisUnit))
                castorchan = "cast"
            elseif br._G.UnitChannelInfo(thisUnit) then
                spellname = br._G.UnitChannelInfo(thisUnit)
                -- castStartTime = select(4,br._G.UnitChannelInfo(thisUnit)) / 1000
                castEndTime = select(5, br._G.UnitChannelInfo(thisUnit)) / 1000
                interruptID = select(9, br._G.UnitChannelInfo(thisUnit))
                castorchan = "channel"
            end
            if spellname ~= nil
                    and (select(1, br._G.UnitCastID(thisUnit)) > 0
                    or select(2, br._G.UnitCastID(thisUnit)) > 0) then

                --   Print("--")
                --   Print(tostring(br.GetUnitIsUnit("player", br._G.UnitTarget(thisUnit))))
                --   Print(tostring(select(3, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player") or select(4, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player")) and castleft <= 1.5)
                --   Print(br.GetUnitIsUnit("player", select(3, br._G.UnitCastID(thisUnit))))

                local castleft = castEndTime - br._G.GetTime()
                if (select(3, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player") or select(4, br._G.UnitCastID(thisUnit)) == br._G.ObjectPointer("player")) and castleft <= 1.5 then
                    if cast.able.cloakOfShadows() and mode.cloak == 1 and cloakList[interruptID] then
                        if cast.cloakOfShadows() then
                            return true
                        end
                    elseif cast.able.evasion and dodgeList[interruptID] then
                        if cast.evasion() then
                            return true
                        end
                    elseif cast.able.feint() and br.player.talent.elusiveness and (feintList[interruptID] or br.getDebuffStacks("player", 240443) > 3) then
                        if cast.pool.feint() and cd.feint.remain() <= castleft then
                            should_pool = true
                        end
                        if cast.feint() then
                            should_pool = false
                            return true
                        end
                    elseif cast.able.vanish() and vanishList[interruptID] and mode.vanish == 1 then
                        if cast.vanish() then
                            return true
                        end
                    end
                else
                    if cast.able.feint() and feintList[interruptID] and castleft <= 3 then
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

        if br.isChecked("Priority Mark") then
            for i = 1, mob_count do
                if br._G.GetRaidTargetIndex(enemies.yards20[i]) == br.getOptionValue("Priority Mark") then
                    priority_target = enemies.yards20[i]
                    break
                end
            end
        end
        --     br.addonDebug("1 - int_target: " .. br._G.UnitName(interrupt_target))
        for i = 1, mob_count do
            if priority_target ~= nil then
                interrupt_target = priority_target
                --  Print("PRIORITY: " .. br._G.UnitName(interrupt_target))
            else
                interrupt_target = enemies.yards20[i]
            end

            -- Print("Target: " .. br._G.UnitName(interrupt_target))


            if br.canInterrupt(interrupt_target, br.getOptionValue("Interrupt %")) then
                distance = br.getDistance(interrupt_target)
                if not (inInstance and #tanks > 0 and select(3, br._G.UnitClass(tanks[1].unit)) == 1 and br.hasBuff(23920, tanks[1].unit) and br._G.GetUnitIsUnit(select(3, br._G.UnitCastID(interrupt_target)), tanks[1].unit)) then
                    if StunsBlackList[br.GetObjectID(interrupt_target)] == nil and br.player.cast.timeRemain(interrupt_target) < br.getTTD(interrupt_target) then
                        if cd.global.remain() == 0 then
                            if mode.gouge ~= 2 and mode.gouge < 5 and not cd.gouge.exists()
                                    and not cast.last.gouge(1)
                                    and br.getFacing(interrupt_target, "player", 45)
                                    and (distance < 5 or talent.acrobaticStrikes and distance < 8) then
                                if cast.gouge(interrupt_target) then
                                    someone_casting = false
                                    br.addonDebug("[int]Gouged " .. br._G.UnitName(interrupt_target))
                                    return true
                                end
                            end
                            if (mode.blind == 1 or mode.blind == 3) and distance <= 15 and cast.able.blind(interrupt_target) then
                                if cast.blind(interrupt_target) then
                                    br.addonDebug("[int]Blind " .. br._G.UnitName(interrupt_target))
                                    someone_casting = false
                                    return true
                                end
                            end
                            if cast.able.kidneyShot(interrupt_target) and (mode.kidney == 1 or mode.kidney == 3) and cast.able.kidneyShot(interrupt_target) and combo > 0 and not already_stunned(interrupt_target) then
                                if br.getDistance(interrupt_target) < 8 and br.getFacing("player", interrupt_target) then
                                    if cast.kidneyShot(interrupt_target) then
                                        br.addonDebug("[int]Kidney/stunning")
                                        someone_casting = false
                                        return true
                                    end
                                end
                            end
                        end
                    end

                    if br.isChecked("Kick") and not cd.kick.exists() and distance < dynamic_range and br.getFacing("player", interrupt_target) then
                        if cast.kick(interrupt_target) then
                            br.addonDebug("[int]Kicked " .. br._G.UnitName(interrupt_target))
                            someone_casting = false
                            if mode.interrupt == 3 then
                                br._G.RunMacroText("/br toggle interrupt 2")
                            end
                            return true
                        end
                    end
                end
            end

            --check for stun here
            if (mode.blind == 2 or mode.blind == 3) or (mode.gouge == 2 or mode.gouge == 3) or (mode.kidney == 2 or mode.kidney == 3) then
                if cast.able.blind() or cast.able.cheapShot() or cast.able.kidneyShot() then
                    distance = br.getDistance(interrupt_target)
                    local castStartTime
                    if br._G.UnitCastingInfo(interrupt_target) then
                        castStartTime = select(4, br._G.UnitCastingInfo(interrupt_target))
                    elseif br._G.UnitChannelInfo(interrupt_target) then
                        castStartTime = select(4, br._G.UnitChannelInfo(interrupt_target))
                    end
                    if br.isCrowdControlCandidates(interrupt_target) and (br._G.GetTime() - (castStartTime / 1000)) > 0.1
                            and not already_stunned(interrupt_target)
                            and br.GetUnitExists(interrupt_target) and br.getBuffRemain(interrupt_target, 226510) == 0 and distance <= 20 then
                        if mode.gouge > 1 and mode.gouge ~= 5 and cast.able.gouge() and (distance <= dynamic_range) and br.getFacing(interrupt_target, "player", 45) then
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
                            if (mode.vanish == 1 and cast.able.vanish()) or (br.player.race == "NightElf" and cast.able.shadowmeld() and br.isChecked("Use Racial")) then
                                if mode.vanish == 1 and cast.able.vanish() then
                                    if cast.vanish() then
                                        do_stun = interrupt_target
                                        br.addonDebug("[Stun] Vanish!")
                                        someone_casting = false
                                        return true
                                    end
                                end
                                if br.player.race == "NightElf" and cast.able.shadowmeld() and br.isChecked("Use Racial") then
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


local frame = br._G.CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local function reader()
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = br._G.CombatLogGetCurrentEventInfo()
    if param == "SPELL_CAST_START" and br._G.bit.band(sourceFlags, 0x00000800) > 0 then
        br._G.C_Timer.After(0.02, function()
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
    charges = br.player.charges
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
    race = br.player.race
    runeforge = br.player.runeforge
    spell = br.player.spell
    lastSpell = lastSpellCast
    talent = br.player.talent
    combo, comboDeficit, comboMax = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
    units = br.player.units
    use = br.player.use
    conduit = br.player.conduit
    stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists() or buff.sepsis.exists()
    -- General Locals
    hastar = br.GetObjectExists("target")
    profileStop = profileStop or false
    ttd = br.getTTD
    haltProfile = (inCombat and profileStop) or (br._G.IsMounted() or br._G.IsFlying()) or br.pause() or mode.rotation == 4 or buff.soulshape.exists()
    devtest = 0
    unit = br.player.unit
    ui = br.player.ui

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
    enemies.get(30) -- Makes a variable called, enemies.yards30
    enemies.get(40) -- Makes a variable called, enemies.yards40

    if br.timer:useTimer("target_timer", 0.5) then
        dynamic_target_melee = talent.acrobaticStrikes and units.dyn8 or units.dyn5
        dynamic_range = talent.acrobaticStrikes and 8 or 5
    end
    -- Profile Specific Locals

    -- executed outside of gcd
    --We will check for interrupt whenever someone is casting (based on log)
    if someone_casting == true and inCombat and (mode.interrupt == 1 or mode.interrupt == 3) then
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


    --marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.rogue&combo_points.deficit>=cp_max_spend-1)
    --If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or without any CP.

    --marked for death
    --marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.rogue&combo_points.deficit>=cp_max_spend-1)
    if not cast.last.markedForDeath(1) and #enemies.yards8 > 0 and talent.markedForDeath and cd.markedForDeath.ready() and not stealth and comboDeficit >= 4 then
        --lets find the lowest health mob to cast this on
        local unit_health = br._G.UnitHealth(enemies.yards8[1])
        local mfd_target = enemies.yards8[1]
        for i = 1, #enemies.yards8 do
            if br._G.UnitHealth(enemies.yards8[i]) < unit_health then
                unit_health = br._G.UnitHealth(enemies.yards8[i])
                mfd_target = enemies.yards8[i]
            end
        end
        if cast.markedForDeath(mfd_target) then
        end
    end


    --        br.ui:createDropdown(section, "Draw Range", { "Never", "Blade Flurry", "always" }, 1, "Draw range on screen")
    if inCombat and br.getOptionValue("Draw Range") == 3 or br.getOptionValue("Draw Range") == 2 and buff.bladeFlurry.exists() then
        local LibDraw = LibStub("LibDraw-BR")
        local draw_range = talent.acrobaticStrikes and 8 or 5
        local playerX, playerY, playerZ = br.GetObjectPosition("player")
        LibDraw.SetColorRaw(1, 0, 0, 1)
        LibDraw.Circle(playerX, playerY, playerZ, draw_range)
    end
    --aggro management
    if br.isChecked("Aggro Management") and #br.friend > 1 and inCombat then
        local tricksunit
        local mob_count = #enemies.yards20
        if mob_count > 6 then
            mob_count = 6
        end
        for i = 1, mob_count do
            if not br.isExplosive(enemies.yards20[i]) and br._G.UnitThreatSituation("player", enemies.yards20[i]) ~= nil and br._G.UnitThreatSituation("player", enemies.yards20[i]) > 0 then
                if br.isChecked("[AM] - Tricks") and cast.able.tricksOfTheTrade() and #br.friend > 1 and not buff.tricksOfTheTrade.exists() then
                    for i = 1, #br.friend do
                        if br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK"
                                and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.getLineOfSight("player", br.friend[i].unit) and br.getDistance(br.friend[i].unit) < 25 then
                            tricksunit = br.friend[i].unit
                            break
                        end
                    end
                    if tricksunit ~= nil and cd.tricksOfTheTrade.ready() then
                        -- and br.getFacing(tricksunit, "player", 45) then
                        if cast.tricksOfTheTrade(tricksunit) then
                            br.addonDebug("[AM] - Tricks on: " .. tricksunit)
                        end
                    end
                end
                if br.getHP("player") < 80 then
                    if br.isChecked("[AM] - Kidney") and cast.able.kidneyShot(enemies.yards20[i]) and combo > 0 and br.getDistance(enemies.yards20[i]) < 8 and br._G.ObjectIsFacing("player", enemies.yards20[i])
                            and not br.isBoss(enemies.yards20[i]) and StunsBlackList[br.GetObjectID(enemies.yards20[i])] == nil and not already_stunned(enemies.yards20[i]) then
                        if cast.kidneyShot(enemies.yards20[i]) then
                            br.addonDebug("[AM]Kidney/stunning")
                            return true
                        end
                    end
                    if br.isChecked("[AM] - Evasion") and cast.able.evasion() and br.useDefensive() then
                        if cast.evasion() then
                            return true
                        end
                    end
                    if not stealth then
                        if br.isChecked("[AM] - Shadowmeld") and br.player.race == "NightElf" and cast.able.shadowmeld() and br.isChecked("Use Racial") and not cast.last.tricksOfTheTrade(1) then
                            if cast.shadowmeld() then
                                br.addonDebug("[AM] - Shadowmeld")
                            end
                        end
                        if br.isChecked("[AM] - Vanish") and mode.vanish == 1 and cast.able.vanish() and not cast.last.shadowmeld(1) and not cast.last.tricksOfTheTrade(1) then
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
            if br.isChecked("Lethal Poison") then
                --and not inCombat and not moving
                if br.getOptionValue("Lethal Poison") == 1 and buff.instantPoison.remain() < 500 and not cast.last.instantPoison(1) then
                    if cast.instantPoison("player") then
                        return true
                    end
                elseif br.getOptionValue("Lethal Poison") == 2 and buff.woundPoison.remain() < 500 and not cast.last.woundPoison(1) then
                    if cast.woundPoison("player") then
                        return true
                    end
                end
            end

            if br.isChecked("Non-Lethal Poison") then
                --and not inCombat and not moving
                if br.getOptionValue("Non-Lethal Poison") == 1 and buff.cripplingPoison.remain() < 500 and not cast.last.cripplingPoison(1) then
                    if cast.cripplingPoison("player") then
                        return true
                    end
                elseif br.getOptionValue("Non-Lethal Poison") == 2 and buff.numbingPoison.remain() < 500 and not cast.last.numbingPoison(1) and level >= 54 then
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
            if br.getOptionValue("Auto Stealth") == 2 and #enemies.yards25nc == 0 and buff.stealth.exists() and auto_stealthed then
                br.cancelBuff(1784)
                auto_stealthed = nil
            end
        else
            if br.isChecked("Auto Stealth") and br._G.IsUsableSpell(br._G.GetSpellInfo(spell.stealth)) and not cast.last.vanish() and not br._G.IsResting() and
                    (br.botSpell ~= spell.stealth or (br.botSpellTime == nil or br._G.GetTime() - br.botSpellTime > 0.1)) then
                if br.getOptionValue("Auto Stealth") == 1 then
                    if cast.stealth() then
                        return
                    end
                end
                if br.getOptionValue("Auto Stealth") == 1 and not stealth then
                    if cast.stealth() then
                        return
                    end
                end
                if br.getOptionValue("Auto Stealth") == 2 then
                    if #enemies.yards25nc > 0 then
                        for i = 1, #enemies.yards25nc do
                            local thisUnit = enemies.yards25nc[i]
                            local react = br.GetUnitReaction(thisUnit, "player") or 10
                            if react < 4 and br._G.UnitIsEnemy("player", thisUnit) then
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
                -- br.isValidUnit("target") and
                if br.timersTable then
                    br._G.wipe(br.timersTable)
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
local id = 260
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
local rotationName = "OutLaks" -- Change to name of profile listed in options drop down


-- TODO When aggro, do what?   (auto tricks, vanish, racial)


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
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 0, icon = br.player.spell.riposte },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.riposte }
    };
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt", 4, 0)

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
    EssenceModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Essences", tip = "Use Essences", highlight = 0, icon = br.player.spell.reapingFlames },
        [2] = { mode = "Off", value = 2, overlay = "Use Essences", tip = "Use Essences", highlight = 0, icon = br.player.spell.reapingFlames },
    };
    CreateButton("Essence", 3, -1)
    PotsModes = {
        [1] = { mode = "On", value = 1, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
        [2] = { mode = "Off", value = 2, overlay = "Use Pots", tip = "Use Pots", highlight = 0, icon = 2259 },
    }
    CreateButton("Pots", 4, -1)

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
        section = br.ui:createSection(br.ui.window.profile, "Keys - 105506222020")
        br.ui:createDropdownWithout(section, "DPS Key", br.dropOptions.Toggle, 6, "DPS Override")
        br.ui:createCheckbox(section, "Group CD's with DPS key", "Adrenaline + BladeFurry", 1)
        br.ui:createDropdown(section, "Eng Brez", { "Target", "Mouseover", "Auto" }, 1, "", "Target to cast on")
        br.ui:createDropdownWithout(section, "Distract", br.dropOptions.Toggle, 6, "Distract at cursor")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createDropdown(section, "Auto Stealth", { "Always", "25 Yards" }, 1, "Auto stealth mode.")
        br.ui:createCheckbox(section, "Cheap Shot", "Will use cheap shot")
        br.ui:createDropdown(section, "Priority Mark", { "|cffffff00Star", "|cffffa500Circle", "|cff800080Diamond", "|cff008000Triangle", "|cffffffffMoon", "|cff0000ffSquare", "|cffff0000Cross", "|cffffffffSkull" }, 8, "Mark to Prioritize")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createDropdownWithout(section, "Pots - 1 target (Boss)", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createDropdownWithout(section, "Pots - 2-3 targets", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createDropdownWithout(section, "Pots - 4+ target", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Adrenaline is up")
        br.ui:createCheckbox(section, "Racial", "Use your racial")
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
        br.ui:createSpinner(section, "Riposte", 10, 0, 100, 5, "Health Percentage to use at.")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Aggro")
        br.ui:createCheckbox(section, "Aggro Management", "Shake aggro?")
        if br.player.race == "NightElf" then
            br.ui:createCheckbox(section, "[AM] - Shadowmeld", "Shake aggro?")
        end
        br.ui:createCheckbox(section, "[AM] - Tricks", "Shake aggro?")
        br.ui:createCheckbox(section, "[AM] - Vanish", "Shake aggro?")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt Options")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 0, 0, 95, 5, "Cast Percentage to use at.")
        br.ui:createCheckbox(section, "Kick", "Will use Kick to int")
        br.ui:createCheckbox(section, "Gouge", "Will use Gouge to int")
        br.ui:createCheckbox(section, "Blind", "Will use Blind to int")
        br.ui:createCheckbox(section, "Between the Eyes", "Will use BTE to int")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Corruption")
        br.ui:createDropdown(section, "Shroud of Resolve", { "Snare", "Eye", "THING", "Eye/THING ", "Never" }, 4, " ", " ")
        br.ui:createDropdown(section, "Cloak of Shadows ", { "Snare", "Eye", "THING", "Eye/THING ", "Never" }, 4, " ", " ")
        br.ui:createSpinnerWithout(section, "Cloak - Eye Of Corruption Stacks", 1, 0, 20, 1)
        br.ui:createSpinnerWithout(section, "Cloak - Min HP", 75, 0, 100, 5, "Health Percentage to use corruption immunities. ")
        br.ui:createCheckbox(section, "Vanish THING", "Will use Vanish when Thing from beyond spawns ")
        if br.player.race == "NightElf" then
            br.ui:createCheckbox(section, "Shadowmeld THING", "Will use shadowmeld when Thing from beyond spawns ")
        end
        br.ui:createCheckbox(section, "Blind THING", "Will use blind on Thing from beyond ")
        br.ui:createCheckbox(section, "Between the eyes THING", "Will use Between the eyes on Thing from beyond ")
        br.ui:createCheckbox(section, "Gouge the eyes THING", "Will use Gouge on Thing from beyond ")
        br.ui:checkSectionState(section)
    end
    optionTable = { {
                        [1] = "Rotation Options ",
                        [2] = rotationOptions,
                    } }
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
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
local level
local mode
local php
local spell
local talent
local units
local use
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local hastar
local healPot
local profileStop
local ttd
local essence
local stealth
local combo, comboDeficit, comboMax
local ambush_flag = false
local do_stun
local dynamic_target_melee_melee

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

local STUN_unitList = {
    [131009] = "Spirit of Gold",
    [134388] = "A Knot of Snakes",
    [129758] = "Irontide Grenadier",
    [152703] = "walkie-shockie-x1"
}

if isChecked("ML - Stun jockeys") then
    STUN_unitList[130488] = "Mech Jockey"
end
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------

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
    for i = 1, 21 do
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

local function rollthebones()
    local buff_count = 0
    local rtb_reroll

    rtb_reroll = buff.rollTheBones.count < 2 and not buff.ruthlessPrecision.exists("player") and not buff.grandMelee.exists("player")
    if br.player.traits.deadshot.active then
        rtb_reroll = buff.rollTheBones.count < 2 and (buff.loadedDice.exists() or not buff.broadside.exists())
    end

    if br.player.traits.aceupyoursleeve.active and (br.player.traits.aceupyoursleeve.rank >= br.player.traits.deadshot.rank) then
        rtb_reroll = buff.rollTheBones.count < 2 and (buff.loadedDice.exists() or buff.ruthlessPrecision.remains() <= cd.betweenTheEyes.remains())
    end
    if br.player.traits.snakeeyes.rank >= 2 and buff.snakeeyes.stack() >= (2 - buff.broadside.exists()) then
        rtb_reroll = false
    end
    if buff.bladeFlurry.exists() then
        buff_count = 0
        if buff.skullAndCrossbones.exists() then
            buff_count = 1
        end
        rtb_reroll = ((buff.rollTheBones.count - buff_count) < 2)
                and (buff.loadedDice.exists() or not buff.grandMelee.exists() and not buff.ruthlessPrecision.exists() and not buff.broadside.exists())
    end
    if buff.loadedDice.exists() then
        rtb_reroll = buff.rollTheBones.count - buff.buriedTreasure.exists() < 2 or buff.rollTheBones.remains() < 10.8 + (1.8 * br.player.talent.deeperStratagem)
    end
    return (rtb_reroll)

end
local function ambushCondition()
    if mode.ambush == 1 and #br.friend > 1 then
        local buff_count = 0
        if (talent.ghostlyStrike and cd.ghostlyStrike.remains() < 1) then
            buff_count = buff_count + 1
        end
        if buff.broadside.exists() and br.player.power.energy.amount() > 60 and not buff.skullAndCrossbones.exists() and not buff.wits.exists()
        then
            buff_count = buff_count + 1
        end
        if (comboDeficit >= 2 + (2 * buff_count)) and not (buff.bladeFlurry.exists and #enemies.yards8 >= 2) then
            return true
        else
            return false
        end
    end
end

local function dps_key()

    -- popping CD's with DPS Key
    if mode.cooldown == 1 then
        if cast.adrenalineRush() then
            return true
        end
        if mode.rotation == 1 then
            if cast.bladeFlurry() then
                return true
            end
        end
    end

    --marked for death
    if talent.markedForDeath and cast.able.markedForDeath() then
        if cast.markedForDeath(units.dyn25) then
        end
    end

    --trinkets w/CD
    if isChecked("Trinket 1") and getOptionValue("Trinket 1 Mode") == 5 and inCombat then
        if canUseItem(13) then
            useItem(13)
        end
    end
    if isChecked("Trinket 2") and getOptionValue("Trinket 1 Mode") == 5 and inCombat then
        if canUseItem(14) then
            useItem(14)
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
        if br.player.traits.aceupyoursleeve.rank < 2 or not cd.betweenTheEyes.exists() or buff.rollTheBones.remain == 0 then
            buff_count = buff_count * 1
        else
            buff_count = buff_count * 0
        end
    else
        buff_count = buff_count * 0
    end

    return (buff_count)
end

function getOutLaksTTD(ttd_time)
    local lowTTD = 100
    local lowTTDcount = 0
    for i = 1, #enemies.yards8 do
        if getTTD(enemies.yards8[i]) < lowTTD then
            LowTTDtarget = enemies.yards8[i]
            lowTTD = getTTD(LowTTDtarget)
        end
        if getTTD(enemies.yards8[i]) > ttd_time then
            lowTTDcount = lowTTDcount + 1
        end
    end

    return tonumber(lowTTDcount)
end
--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------

--dps()

actionList.dps = function()


    if isChecked("Group CD's with DPS key") and SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() then
        dps_key()
    end





    --  Print("Enemies: "..tostring(#enemies.yards8))

    -- dps cooldowns

    --    blade_flurry,if=spell_targets>=2&!buff.blade_flurry.up&(!raid_event.adds.exists|raid_event.adds.remains>8|raid_event.adds.in>(2-cooldown.blade_flurry.charges_fractional)*25)
    --Blade Flurry on 2+ enemies. With adds: Use if they stay for 8+ seconds or if your next charge will be ready in time for the next wave.

    --get lowest ttd in group


    -- Print(tostring(getOutLaksTTD(1)))


    --finishers
    --roll_the_bones,if=buff.roll_the_bones.remains<=3|variable.rtb_reroll



    --[[
    run_action_list,name=finish,if=combo_points>=cp_max_spend-(buff.broadside.up+buff.opportunity.up)*(talent.quick_draw.enabled&(!talent.marked_for_death.enabled|cooldown.marked_for_death.remains>1))*(azerite.ace_up_your_sleeve.rank<2|!cooldown.between_the_eyes.up|!buff.roll_the_bones.up)
    Finish at maximum CP. Substract one for each Broadside and Opportunity when Quick Draw is selected and MfD is not ready after the next second. Always max BtE with 2+ Ace.
    ]]

    local bte_condition = buff.ruthlessPrecision.exists() or (br.player.traits.deadshot.active or br.player.traits.aceupyoursleeve.active) and buff.rollTheBones.count >= 1

    if stealth and ambush_flag then
        if actionList.Stealth() then
            return true
        end
    end

    --Print(units.dyn5 or talent.acrobaticStrikes and units.dyn8)

    --Auto attack
    if not IsAutoRepeatSpell(GetSpellInfo(6603)) and #enemies.yards8 >= 1 then
        StartAttack(units.dyn5 or talent.acrobaticStrikes and units.dyn8)
    end
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
        end
    end


    --  bloodOfTheEnemy
    if combo >= comboMax - buff_count() and essence.bloodOfTheEnemy.major and cast.able.bloodOfTheEnemy() and bte_condition then
        if (cd.bladeFlurry.remain() == 0 or buff.bladeFlurry.exists()) and (getOutLaksTTD(8) >= 2 or isBoss("target"))
                and cast.able.betweenTheEyes() then
            if cast.bloodOfTheEnemy() then
                return true
            end
        end
    end

    -- Finishers
    -- test
    if combo >= comboMax - buff_count() and not isExplosive(units.dyn20) then
        if cast.able.betweenTheEyes() and bte_condition then
            --  and getBuffRemain(units.dyn20, 226510) == 0 then
            if cast.betweenTheEyes(units.dyn20) then
                return true
            end
        end
        if combo > 0 and (buff.rollTheBones.remain <= 3 or rollthebones()) then
            if cast.rollTheBones() then
                return true
            end
        end
        if cast.able.betweenTheEyes(units.dyn20) and (br.player.traits.deadshot.active or br.player.traits.aceupyoursleeve.active) and getBuffRemain(units.dyn20, 226510) == 0 then
            if cast.betweenTheEyes(units.dyn20) then
                return true
            end
        end

        if cast.able.dispatch(units.dyn5 or talent.acrobaticStrikes and units.dyn8) then
            if cast.dispatch(units.dyn5 or talent.acrobaticStrikes and units.dyn8) then
                return true
            end
        end
    end -- end finishers

    -- ambush stuff here
    --[[
    cheap_shot,target_if=min:debuff.prey_on_the_weak.remains,if=talent.prey_on_the_weak.enabled&!target.is_boss

    ambush
    ]]


    --  blood_of_the_enemy,
    --if =variable.blade_flurry_sync&cooldown.between_the_eyes.up&variable.bte_condition&(spell_targets.blade_flurry>=2|raid_event.adds. in >45)
    -- variable,name=blade_flurry_sync,value=spell_targets.blade_flurry<2&raid_event.adds.in>20|buff.blade_flurry.up
    --#enemies.yards8 >= 2 and not buff.bladeFlurry.exists() and getOutLaksTTD(8) >= 2 then

    stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists()

    if mode.essence == 1 then
        if getCombatTime() > 1 and not stealth and not IsMounted() then
            --purification protocol
            if essence.purifyingBlast.major and cast.able.purifyingBlast() and getOutLaksTTD(8) > 2 or isBoss("target") then
                if cast.purifyingBlast("best", nil, 1, 8) then
                    return true
                end
            end

            -- Reaping Flames
            if essence.reapingFlames.major and cast.able.reapingFlames() then
                local reapingDamage = buff.reapingFlames.exists("player") and 66769 * 2 or 66769
                local reapingPercentage = 0
                local thisHP = 0
                local thisABSHP = 0

                local thisABSHPmax = 0
                local reapTarget, thisUnit, reap_execute, reap_hold, reap_fallback = false, false, false, false, false
                if #enemies.yards30 == 1 then
                    if ((br.player.essence.reapingFlames.rank >= 2 and getHP(enemies.yards30[1]) > 80) or getHP(enemies.yards30[1]) <= 20 or getTTD(enemies.yards30[1], 20) > 30) then
                        reapTarget = enemies.yards30[1]
                    end
                elseif #enemies.yards30 > 1 then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        local reapTTD = getTTD(thisUnit)
                        if getTTD(thisUnit) ~= 999 then
                            --  Print("TTD:" .. tostring(getTTD(thisUnit)))
                            thisHP = getHP(thisUnit)
                            thisABSHP = UnitHealth(thisUnit)
                            thisABSHPmax = UnitHealthMax(thisUnit)
                            reapingPercentage = round2(reapingDamage / UnitHealthMax(thisUnit), 2)
                            --Print("H:" .. tostring(thisABSHP) .. "  D:" .. tostring(reapingDamage) .. "  goal %:" .. tostring(reapingPercentage) .. "  current %:" .. tostring(round2(reapingDamage / thisABSHP, 2)))
                            if UnitHealth(thisUnit) <= reapingDamage or reapTTD < 1.5 or buff.reapingFlames.remain() <= 1.5 then
                                reap_execute = thisUnit
                                break
                            elseif getTTD(thisUnit, reapingPercentage) < 29 or getTTD(thisUnit, 20) > 30 and (getTTD(thisUnit, reapingPercentage) < 44)
                            then
                                reap_hold = true
                            elseif (thisHP > 80 or thisHP <= 20) or getTTD(thisUnit, 20) > 30 then
                                reap_fallback = thisUnit
                            end
                        end
                    end
                    --        end
                end

                if reap_execute then
                    reapTarget = reap_execute
                elseif not reap_hold and reap_fallback then
                    reapTarget = reap_fallback
                end

                if reapTarget ~= nil and not isExplosive(reapTarget) then
                    if cast.reapingFlames(reapTarget) then
                        --  Print("REAP: " .. UnitName(reapTarget) .. "DMG:" .. tostring(reapingDamage) .. "/" .. tostring(UnitHealth(reapTarget)))
                        return true
                    end
                end
            end
        end
    end -- end essence
    --  Print(tostring(getOutLaksTTD(8)))
    if mode.rotation == 1 then
        if #enemies.yards8 >= 2 and not buff.bladeFlurry.exists() and getOutLaksTTD(8) >= 2 then
            if cast.bladeFlurry() then
                return true
            end
        end
    end

    --[[
    blade_rush,if=variable.blade_flurry_sync&energy.time_to_max>2
    variable,name=blade_flurry_sync,value=spell_targets.blade_flurry<2&raid_event.adds.in>20|buff.blade_flurry.up
    ]]
    if talent.bladeRush and cast.able.bladeRush() then
        if cast.bladeRush(units.dyn5 or talent.acrobaticStrikes and units.dyn8) then
            return true
        end
    end

    --[[
    marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.rogue&combo_points.deficit>=cp_max_spend-1)
    If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or without any CP.
    0.00	marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&!stealthed.rogue&combo_points.deficit>=cp_max_spend-1
    If no adds will die within the next 30s, use MfD on boss without any CP.
    ]]






    --adrenaline_rush,if=!buff.adrenaline_rush.up&(!equipped.azsharas_font_of_power|cooldown.latent_arcana.remains>20)
    if mode.cooldown == 1 then
        if cast.able.adrenalineRush() and not buff.adrenalineRush.exists() and getOutLaksTTD(20) > 0 then
            if cast.adrenalineRush() then
                return true
            end
        end
    end
    --[[
    vanish,if=!stealthed.all&variable.ambush_condition
    Using Vanish/Ambush is only a very tiny increase, so in reality, you're absolutely fine to use it as a utility spell.
    N	2.89	shadowmeld,if=!stealthed.all&variable.ambush_condition
    ]]


    if not stealth and ambushCondition() and cd.vanish.remain() <= 0.2 and getDistance(units.dyn5) <= 5 and useCDs() and #br.friend > 0 and not cast.last.shadowmeld(1) and getBuffRemain(units.dyn5, 226510) == 0 then
        ambush_flag = true
        if mode.vanish == 1 then
            if cast.vanish() then
                return true
            end
        end
        if br.player.race == "NightElf" and isChecked("Racial") and not cast.last.vanish(1) then
            if cast.shadowmeld() then
                return true
            end
        end
    end

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

        if auto_pot ~= 1 and (buff.adrenalineRush.remain() > 12) then

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
            end
        end
    end  -- end pots


    --trinkets

    if isChecked("Use Trinkets") then

        local Trinket13 = GetInventoryItemID("player", 13)
        local Trinket14 = GetInventoryItemID("player", 14)

        local hold13, hold14
        --trinket 13
        if Trinket13 == 173946 and br.player.essence.bloodOfTheEnemy.active then
            hold13 = true
            if buff.seethingRage.exists() and canUseItem(173946) and #enemies.yards5 > 0 then
                useItem(173946)
            end
        end
        if not hold13 then
            if hasBloodLust() or getOutLaksTTD(20) > 1 or buff.adrenalineRush.exists() then
                --or comboDeficit <= 2
                if canUseItem(13) then
                    useItem(13)
                end
            end
        end

        --trinket 14
        if Trinket14 == 173946 and br.player.essence.bloodOfTheEnemy.active then
            hold14 = true
            if buff.seethingRage.exists() and canUseItem(173946) and #enemies.yards5 > 0 then
                useItem(173946)
            end
        end

        if not hold14 then
            if hasBloodLust() or getOutLaksTTD(20) > 1 or buff.adrenalineRush.exists() then
                --or comboDeficit <= 2
                if canUseItem(14) then
                    useItem(14)
                end
            end
        end
    end
    -- builders


    if comboDeficit > 0 then
        if (br.player.talent.quickDraw and comboDeficit > 1 or not br.player.talent.quickDraw and comboDeficit > 0) then
            if (br.player.talent.quickDraw or br.player.traits.keepYourWitsAboutYou.rank < 2)
                    and buff.opportunity.exists() and (buff.wits.stack() < 14 or br.player.power.energy.amount() < 45)
                    or (buff.opportunity.exists() and buff.deadShot.exists() and not isExplosive(units.dyn20)) then
                --    Print("Shooting with " .. tostring(combo) .. " combo points and a deficit of: " .. tostring(comboDeficit))
                if cast.pistolShot(units.dyn20) then
                    return true
                end
            end
        end
        if cast.sinisterStrike(units.dyn5 or talent.acrobaticStrikes and units.dyn8)
        then
            return true
        end
    end
end

actionList.Stealth = function()
    -- stealth()

    if stealth and #br.friend > 1 and (ambush_flag or do_stun ~= nil) then
        if isChecked("Cheap Shot") and cast.able.cheapShot() and
                (talent.preyOnTheWeak and not isBoss(units.dyn5) and not debuff.preyOnTheWeak.exists(units.dyn5) or do_stun ~= nil)
        then
            if do_stun == nil then
                do_stun = units.dyn5
            end
            if StunsBlackList[GetObjectID(do_stun)] == nil then
                if cast.cheapShot(do_stun) then
                    br.addonDebug("Cheapshot stun on:" .. do_stun)
                    do_stun = nil
                    return true
                end
            end
        end
    end
    if mode.ambush == 1 then
        if cast.ambush(units.dyn5) then
            return true
        end
    end


end
actionList.Extra = function()

    if SpecificToggle("Distract") and not GetCurrentKeyBoardFocus() then
        CastSpellByName(GetSpellInfo(spell.distract), "cursor")
        return
    end

    if not inCombat and #enemies.yards40 > 0 and not stealth and combo > 0 and (buff.rollTheBones.remain <= 3 or rollthebones()) then
        if cast.rollTheBones() then
            return true
        end
    end

    if isChecked("Group CD's with DPS key") and SpecificToggle("DPS Key") and not GetCurrentKeyBoardFocus() then
        dps_key()
    end

    if isChecked("Auto Sprint") and cast.able.sprint() and isMoving("player") and (not inCombat or #enemies.yards8 == 0) and IsMovingTime(math.random(1, 5)) then
        if cast.sprint() then
            return true
        end
    end


end -- End Action List - Extra

actionList.Corruption = function()

    php = br.player.health
    -- Corruption stuff
    -- 1 = snare,  2 = eye,  3 = thing, 4 = eye/thing  . 5 never

    --shroudOfResolve / cloak
    if debuff.grandDelusions.exists("player") or debuff.graspingTendrils.exists("player") or getDebuffStacks("player", 315161) > 0 then
        if isChecked("Shroud of Resolve") and br.player.equiped.shroudOfResolve and canUseItem(br.player.items.shroudOfResolve) and not IsMounted() then
            if getValue("Shroud of Resolve") == 1 and debuff.graspingTendrils.exists("player")
                    or (getValue("Shroud of Resolve") == 2 or getValue("Shroud of Resolve") == 4) and getDebuffStacks("player", 315161) >= getOptionValue("Cloak - Eye Of Corruption Stacks") and php <= getOptionValue("Cloak - Min HP")
                    or (getValue("Shroud of Resolve") == 3 or getValue("Shroud of Resolve") == 4) and debuff.grandDelusions.exists("player") then
                if br.player.use.shroudOfResolve() then
                    return true
                end
            end
        end
        --cloak of shadows
        if isChecked("Cloak of Shadows") and cast.able.cloakOfShadows() then
            if getValue("Cloak of Shadows") == 1 and debuff.graspingTendrils.exists("player")
                    or (getValue("Cloak of Shadows") == 2 or getValue("Cloak of Shadows") == 4) and getDebuffStacks("player", 315161) >= getOptionValue("Cloak - Eye Of Corruption Stacks") and php <= getOptionValue("Cloak - Min HP")
                    or (getValue("Cloak of Shadows") == 3 or getValue("Cloak of Shadows") == 4) and debuff.grandDelusions.exists("player") then
                if cast.cloakOfShadows() then
                    return true
                end
            end
        end
    end

    if debuff.grandDelusions.exists("player") then
        if isChecked("Vanish THING") and cast.able.vanish() and #br.friend > 1 and not cast.last.shadowmeld(1) and mode.vanish == 1 then
            if cast.vanish() then
                return true
            end
        elseif isChecked("Shadowmeld THING") and cast.able.shadowmeld() and isChecked("use Racials") and #br.friend > 1 and not cast.last.vanish(1) then
            if cast.shadowmeld() then
                return true
            end
        elseif isChecked("Blind THING") or isChecked("Between the eyes THING") or isChecked("Gouge the eyes THING") and not cast.last.vanish(1) and not cast.last.shadowmeld(1) then
            local stun = 0
            local stun_range = 10
            if cast.able.blind() and isChecked("Blind THING") then
                stun = 43433
                stun_range = 10
            elseif cast.able.betweenTheEyes() and isChecked("Between the eyes THING") then
                stun = 199804
                stun_range = 20
            elseif cast.able.gouge() and isChecked("Gouge the eyes THING") then
                stun = 174503
                stun_range = 5
                if talent.acrobaticStrikes then
                    stun_range = 8
                end
            end
            for i = 1, GetObjectCount() do
                local object = GetObjectWithIndex(i)
                local ID = ObjectID(object)
                if ID == 161895 and not isLongTimeCCed(object) and not debuff.betweenTheEyes.exists() and not debuff.gouge.exists() then
                    local x1, y1, z1 = ObjectPosition("player")
                    local x2, y2, z2 = ObjectPosition(object)
                    local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                    if distance < stun_range then
                        CastSpellByName(GetSpellInfo(stun), object)
                        return true
                    end
                end
            end
        end
    end
end


-- Action List - Defensive
actionList.Defensive = function()
    php = br.player.health
    local should_feint

    if useDefensive() then
        --aggro management
        if isChecked("Aggro Management") and #br.friend > 1 then
            local tricksunit
            for i = 1, #enemies.yards20 do
                if not isExplosive(enemies.yards20[i]) and UnitThreatSituation("player", enemies.yards20[i]) ~= nil and UnitThreatSituation("player", enemies.yards20[i]) > 0 then
                    if isChecked("[AM] - Tricks") and cast.able.tricksOfTheTrade() and #br.friend > 1 then
                        for i = 1, #br.friend do
                            if UnitGroupRolesAssigned(br.friend[i].unit) == "TANK"
                                    and not UnitIsDeadOrGhost(br.friend[i].unit) and getLineOfSight("player", br.friend[i].unit) and getDistance("player", br.friend[i].unit) < 25 then
                                tricksunit = br.friend[i].unit
                                break
                            end
                        end
                        if tricksunit ~= nil and getFacing(tricksunit, "player", 45) then
                            if cast.tricksOfTheTrade(tricksunit) then
                                br.addonDebug("[AM] - Tricks on: " .. tricksunit)
                                -- Print("[AM] - Tricks on: " .. tricksunit)
                                return true
                            end
                        end
                    end
                    if not stealth then
                        if isChecked("[AM] - Shadowmeld") and br.player.race == "NightElf" and cast.able.shadowmeld() and isChecked("use Racials") and not cast.last.tricksOfTheTrade(1) then
                            if cast.shadowmeld() then
                                br.addonDebug("[AM] - Shadowmeld")
                                return true
                            end
                        end
                        if isChecked("[AM] - Vanish") and mode.vanish == 1 and cast.able.vanish() and not cast.last.shadowmeld(1) and not cast.last.tricksOfTheTrade(1) then
                            if cast.vanish() then
                                br.addonDebug("[AM] - Vanish")
                                return true
                            end
                        end
                    end
                end
            end
        end

        -- Feint
        if isChecked("Feint") and cast.able.feint() and not buff.feint.exists() and inCombat then
            for k, v in pairs(debuff_list) do
                --   Print("K: " .. tostring(k) .. " V: " .. tostring(v.spellID))
                if getDebuffRemain("player", v.spellID) > 0 then
                    should_feint = true
                end
            end
            if not should_feint then
                for i = 1, #precast_spell_list do
                    local boss_spell_id = precast_spell_list[i][1]
                    --    local precast_time = precast_spell_list[i][2]
                    --   local spell_name = precast_spell_list[i][3]
                    local time_remain = br.DBM:getPulltimer(nil, boss_spell_id)
                    if time_remain < 1 then
                        should_feint = true
                    end
                end
                if php <= getOptionValue("Feint") then
                    should_feint = true
                end
                if should_feint then
                    if cast.feint() then
                        return true
                    end
                end
            end
        end

        --Healthstone / Heathpots :  156634 == Silas Vial of Continuous curing / 5512 == warlock health stones
        if isChecked("Pot/Stoned") and php <= getValue("Pot/Stoned") and (hasHealthPot() or hasItem(5512) or hasItem(156634)) then
            if canUseItem(166799) then
                useItem(166799)
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
        -- Crimson Vial
        if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
            if cast.crimsonVial() then
                return true
            end
        end

        -- Evasion
        if isChecked("Riposte") and php <= getOptionValue("Riposte") and inCombat then
            if cast.riposte() then
                return true
            end
        end
        if isChecked("Engineer's Belt") and php <= getOptionValue("Engineer's Belt") and inCombat then
            if canUseItem(6) then
                useItem(6)
            end
        end
    end

    -- Unstable Temporal Time Shifter
    if isChecked("Eng Brez") and canUseItem(158379) and not moving and inCombat then
        if getOptionValue("Eng Brez") == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
            UseItemByName(158379, "target")
        end
        if getOptionValue("Eng Brez") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
            UseItemByName(158379, "mouseover")
        end
        if getOptionValue("Eng Brez") == 3 then
            for i = 1, #br.friend do
                if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                    UseItemByName(158379, br.friend[i].unit)
                end
            end
        end
    end


end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()

    if useInterrupts() then
        local interrupt_target
        local distance
        local priority_target

        if isChecked("Priority Mark") then
            for i = 1, #enemies.yards20 do
                if GetRaidTargetIndex(enemies.yards20[i]) == getOptionValue("Priority Mark") then
                    priority_target = enemies.yards20[i]
                    break
                end
            end
        end
        --     br.addonDebug("1 - int_target: " .. UnitName(interrupt_target))
        for i = 1, #enemies.yards20 do
            if priority_target ~= nil then
                interrupt_target = priority_target
                --  Print("PRIORITY: " .. UnitName(interrupt_target))
            else
                interrupt_target = enemies.yards20[i]
            end

            -- Print("Target: " .. UnitName(interrupt_target))

            if canInterrupt(interrupt_target, getValue("InterruptAt")) then
                --Print(UnitName(enemies.yards20[i]))
                distance = getDistance(interrupt_target)
                if not isBoss(interrupt_target) and StunsBlackList[GetObjectID(interrupt_target)] == nil then
                    if isChecked("Gouge") and not cd.gouge.exists()
                            and not cast.last.gouge(1)
                            and getFacing(interrupt_target, "player", 45)
                            and (distance < 5 or talent.acrobaticStrikes and distance < 8) then
                        if cast.gouge(interrupt_target) then
                            br.addonDebug("[int]Gouged " .. UnitName(interrupt_target))
                            return true
                        end
                    end
                    if isChecked("Between the Eyes") and distance <= 20 and combo >= 4 and not cd.betweenTheEyes.exists() and (cd.kick.exists or (distance > 5 or talent.acrobaticStrikes and distance > 8)) then
                        if cast.betweenTheEyes(interrupt_target) then
                            br.addonDebug("[int]BetweenTheEyes " .. UnitName(interrupt_target))
                            return true
                        end
                    end
                end
                if isChecked("Kick") and not cd.kick.exists() and (distance < 5 or talent.acrobaticStrikes and distance < 8) then
                    if cast.kick(interrupt_target) then
                        br.addonDebug("[int]Kicked " .. UnitName(interrupt_target))
                        return true
                    end
                end
            end

            --check for stun here
            if cast.able.betweenTheEyes() or cast.able.blind() or cast.able.cheapShot() then
                distance = getDistance(interrupt_target)
                if isCrowdControlCandidates(interrupt_target) and not already_stunned(interrupt_target)
                        and getBuffRemain(interrupt_target, 226510) == 0 and distance <= 20 then
                    if isChecked("Blind") and cast.able.blind() and (distance <= 15 or talent.blindingPowder and distance <= 30) and not cd.blind.exists() then
                        if cast.blind(interrupt_target) then
                            br.addonDebug("Blind/stunning")
                            return true
                        end
                    elseif isChecked("Between the Eyes") and cast.able.betweenTheEyes(interrupt_target) and distance < 20 and not cd.betweenTheEyes.exists() then
                        if cast.betweenTheEyes(interrupt_target) then
                            br.addonDebug("Bte/stunning " .. interrupt_target)
                            return true
                        end
                    elseif cast.able.cheapShot() and not stealth then
                        if (mode.vanish == 1 and cast.able.vanish()) or (br.player.race == "NightElf" and cast.able.shadowmeld() and isChecked("use Racials")) then
                            if mode.vanish == 1 and cast.able.vanish() then
                                if cast.vanish() then
                                    do_stun = interrupt_target
                                    br.addonDebug("[Stun] Vanish!")
                                    return true
                                end
                            end
                            if br.player.race == "NightElf" and cast.able.shadowmeld() and isChecked("use Racials") then
                                if cast.shadowmeld() then
                                    do_stun = interrupt_target
                                    br.addonDebug("[Stun] ShadowMeld!")
                                    return true
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
----------------
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
    inCombat = br.player.inCombat
    item = br.player.items
    level = br.player.level
    mode = br.player.mode
    php = br.player.health
    spell = br.player.spell
    talent = br.player.talent
    combo, comboDeficit, comboMax = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()

    units = br.player.units
    essence = br.player.essence
    use = br.player.use
    stealth = buff.stealth.exists() or buff.vanish.exists() or buff.shadowmeld.exists()
    -- General Locals
    hastar = GetObjectExists("target")
    healPot = getHealthPot()
    profileStop = profileStop or false
    ttd = getTTD
    haltProfile = (inCombat and profileStop) or (IsMounted() or IsFlying()) or pause() or mode.rotation == 4 or cast.current.focusedAzeriteBeam()

    local inInstance = br.player.instance == "party" or br.player.instance == "scenario" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"
    local inRaid = br.player.instance == "raid" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"


    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(8) -- Makes a variable called, units.dyn8
    units.get(40) -- Makes a variable called, units.dyn40
    -- Enemies
    enemies.get(5) -- Makes a variable  called, enemies.yards5
    enemies.get(8) -- enemies.yards8
    enemies.get(8, "target") -- enemies.yards8t
    enemies.get(20)
    enemies.get(25, "player", true) -- makes enemies.yards25nc
    enemies.get(30) -- Makes a varaible called, enemies.yards40
    enemies.get(40) -- Makes a varaible called, enemies.yards40


    -- Profile Specific Locals

    -- SimC specific variables

    if buff.rollTheBones == nil then
        buff.rollTheBones = {}
    end
    buff.rollTheBones.count = 0
    buff.rollTheBones.duration = 0
    buff.rollTheBones.remain = 0
    for k, v in pairs(spell.buffs.rollTheBones) do
        if UnitBuffID("player", v) ~= nil then
            buff.rollTheBones.count = buff.rollTheBones.count + 1
            buff.rollTheBones.duration = getBuffDuration("player", v)
            buff.rollTheBones.remain = getBuffRemain("player", v)
        end
    end

    if talent.acrobaticStrikes then
        dynamic_target_melee = units.dyn8
    else
        dynamic_target_melee = units.dyn5
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
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if stealth then
            if actionList.Stealth() then
                return true
            end
            if getOptionValue("Auto Stealth") == 2 and #enemies.yards25nc == 0 and buff.stealth.exists() then
                cancelBuff(1784)
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
                        if cast.stealth() then
                            return
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
        if actionList.Defensive() then
            return true
        end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then
            return true
        end

        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if inCombat and isValidUnit("target") and cd.global.remain() == 0 then

            if timersTable then
                wipe(timersTable)
            end

            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Corruption() then
                return true
            end
            if actionList.Interrupt() then
                return true
            end
            if actionList.dps() then
                return true
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
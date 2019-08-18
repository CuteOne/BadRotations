local rotationName = "Laksmackt" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 0, icon = br.player.spell.tranquility },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 0, icon = br.player.spell.tranquility },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.tranquility }
    };

    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 0, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.barkskin }
    };
    CreateButton("Defensive", 2, 0)
    -- Decurse Button
    DecurseModes = {
        [1] = { mode = "On", value = 1, overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 0, icon = br.player.spell.naturesCure },
        [2] = { mode = "Off", value = 2, overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.naturesCure }
    };
    CreateButton("Decurse", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.mightyBash },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mightyBash }
    };
    CreateButton("Interrupt", 4, 0)
    -- DPS Button
    DPSModes = {
        [2] = { mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.rake },
        [1] = { mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.regrowth }
    };
    CreateButton("DPS", 5, 0)

    FormsModes = {
        [1] = { mode = "On", value = 1, overlay = "Auto Forms Enabled", tip = "Will change forms", highlight = 0, icon = br.player.spell.travelForm },
        [2] = { mode = "Key", value = 2, overlay = "Auto Forms hotkey", tip = "Key triggers Auto Forms", highlight = 0, icon = br.player.spell.travelForm },
        [3] = { mode = "Off", value = 3, overlay = "Auto Forms Disabled", tip = "Will Not change forms", highlight = 0, icon = br.player.spell.travelForm }
    };
    CreateButton("Forms", 6, 0)


    -- Rejuvenation Button
    PrehotModes = {
        [1] = { mode = "On", value = 1, overlay = "Pre-Hot", tip = "Pre-hot Enabled", highlight = 0, icon = br.player.spell.rejuvenation },
        [2] = { mode = "Off", value = 3, overlay = "Pre-Hot", tip = "Pre-hot Disabled", highlight = 0, icon = br.player.spell.rejuvenation }
    };
    CreateButton("Prehot", 1, -1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "Forms")
        br.ui:createDropdownWithout(section, "Cat Key", br.dropOptions.Toggle, 6, "Set a key for cat")
        br.ui:createDropdownWithout(section, "Bear Key", br.dropOptions.Toggle, 6, "Set a key for bear")
        br.ui:createDropdownWithout(section, "Travel Key", br.dropOptions.Toggle, 6, "Set a key for travel")
        br.ui:createCheckbox(section, "Cat Charge", "Use Wild Charge to close distance.", 1)
        br.ui:createCheckbox(section, "Break form for critical", 1)
        br.ui:createCheckbox(section, "Break form for dispel", 1)
        br.ui:createCheckbox(section, "auto stealth", 1)
        br.ui:createCheckbox(section, "auto dash", 1)
        br.ui:createSpinner(section, "Bear Frenzies Regen HP", 50, 0, 100, 1, "HP Threshold start regen")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "M+")
        -- br.ui:createSpinnerWithout(section, "Necrotic Rot", 30, 0, 100, 1, "|cffFFFFFFNecrotic Rot Stacks does not healing the unit")
        br.ui:createSpinner(section, "Bursting", 1, 0, 10, 4, "", "|cffFFFFFFBurst Targets")

        br.ui:createCheckbox(section, "Freehold - pig", 1)
        br.ui:createCheckbox(section, "Freehold - root grenadier", 1)
        br.ui:createCheckbox(section, "Atal - root Spirit of Gold")
        br.ui:createCheckbox(section, "KR - Minions of Zul")

        --
        br.ui:createCheckbox(section, "All - root Emissary of the Tides")
        br.ui:createCheckbox(section, "Punt Enchanted Emissary", 1)
        --("Emissary of the Tides"
        br.ui:createSpinnerWithout(section, "Temple of Seth Heal", 40, 0, 100, 5)
        br.ui:createCheckbox(section, "Shrine - Dispel Whisper of Power", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFBubble Devour target|cffFFBB00.", 0)
        br.ui:createSpinner(section, "Grievous Wounds", 5, 0, 20, 1, "HP Threshold to trust hots to do the job")

        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createCheckbox(section, "OOC Healing", "Enables/Disables out of combat healing.", 1)
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 0, 20, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")

        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Heals")
        br.ui:createCheckbox(section, "Smart Hot", "Pre-hot based on DBM or incoming casts", 1)
        br.ui:createSpinner(section, "Critical HP", 30, 0, 100, 5, "", "When to stop what we do, emergency heals!")
        br.ui:createSpinner(section, "Swiftmend", 45, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Rejuvenation", 85, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Rejuvenation Tank", 90, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Max Rejuvenation Targets", 10, 0, 20, 1, "Maximum Rejuvenation Targets")
        br.ui:createSpinnerWithout(section, "Germination", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Germination Tank", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createCheckbox(section, "Efflorescence", "green circle - automated")
        br.ui:createCheckbox(section, "Cenarion Ward", "Cenarion Ward - wont use if smart hot is enabled")
        br.ui:createSpinner(section, "Regrowth Clearcasting", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Regrowth Tank", 50, 0, 100, 5, "|cffFFFFFFTank Health Percent priority Cast At")
        br.ui:createSpinner(section, "Regrowth", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Wild Growth", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Wild Growth Targets", 3, 0, 40, 1, "Minimum Wild Growth Targets")
        br.ui:createSpinner(section, "Photosynthesis", 60, 0, 100, 5, "Health % for switching to healer")
        br.ui:createSpinnerWithout(section, "Photosynthesis Count", 3, 0, 40, 1, "Minimum hurt Targets")
        br.ui:createCheckbox(section, "pre-hot in combat", "apply pre-hotting routine while in combat")
        br.ui:checkSectionState(section)
        -- Essences
        --"Memory of Lucid Dreams"
        section = br.ui:createSection(br.ui.window.profile, "Essences")
        br.ui:createSpinner(section, "ConcentratedFlame - Heal", 50, 0, 100, 5, "", "health to heal at")
        br.ui:createCheckbox(section, "ConcentratedFlame - DPS")
        br.ui:createSpinner(section, "Memory of Lucid Dreams", 50, 0, 100, 5, "", "mana to pop it at")
        br.ui:createCheckbox(section, "Lucid Cat")

        br.ui:createDropdown(section, "Ever Rising Tide", { "Always", "Pair with CDs", "Based on health" }, 1, "When to use this essence")
        br.ui:createSpinner(section, "Ever Rising Tide - Mana", 30, 0, 100, 5, "", "min mana to use")
        br.ui:createSpinner(section, "Ever Rising Tide - Health", 30, 0, 100, 5, "", "health threshold to pop at")
        br.ui:createSpinner(section, "Well of Existence  - Health", 30, 0, 100, 5, "", "health threshold to pop at")
        br.ui:createSpinner(section, "Seed of Eonar", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Seed of Eonar Targets", 3, 0, 40, 1, "Minimum hurting friends")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Auto Stuff")
        br.ui:createCheckbox(section, "Auto Soothe")
        br.ui:createSpinner(section, "Ironbark", 30, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createDropdownWithout(section, "Ironbark Target", { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny" }, 7, "|cffFFFFFFcast Ironbark Target")
        br.ui:createSpinner(section, "Auto Innervate", 10, 0, 100, 50, "Health Percent to Cast At")
        br.ui:createDropdown(section, "Revive", { "|cffFFFF00Selected Target", "|cffFF0000Mouseover Target" }, 1, "|ccfFFFFFFTarget to Cast On")
        br.ui:createSpinner(section, "Mana Potion", 50, 0, 100, 1, "Mana Percent to Cast At")

        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "DPS")
        br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 4, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Max Sunfire Targets", 10, 1, 30, 1, "|cff0070deSet to maximum number of targets to dot with Sunfire. Min: 1 / Max: 30 / Interval: 1")

        --"Max Sunfire Targets"
        br.ui:createSpinnerWithout(section, "DPS Save mana", 40, 0, 100, 5, "|cffFFFFFFMana Percent no Cast Sunfire and Moonfire")
        br.ui:createSpinnerWithout(section, "DPS Min % health", 40, 0, 100, 5, "Don't DPS if under this health % in group (cat enforced w/key")
        br.ui:createCheckbox(section, "Safe Dots")
        br.ui:checkSectionState(section)

        -- Trinkets
        section = br.ui:createSection(br.ui.window.profile, "Trinkets")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround" }, 1, "", "")
        -- br.ui:createCheckbox(section, "Advanced Trinket Support")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Racial")

        --Incarnation: Tree of Life
        br.ui:createSpinner(section, "Incarnation", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Incarnation Targets", 3, 0, 40, 1, "Minimum Incarnation: Tree of Life Targets")
        -- Tranquility
        br.ui:createSpinner(section, "Tranquility", 50, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Tranquility Targets", 3, 0, 40, 1, "Minimum Tranquility Targets")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Rebirth
        br.ui:createDropdown(section, "Rebirth", { "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny" }, 1, "|cffFFFFFFTarget to cast on")
        -- Healthstone
        br.ui:createSpinner(section, "Healthstone", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Barkskin
        br.ui:createSpinner(section, "Barkskin", 60, 0, 100, 5, "|cffFFBB00Health Percent to Cast At.");
        -- Renewal
        br.ui:createSpinner(section, "Renewal", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at");
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


    end
    optionTable = { {
                        [1] = "Rotation Options",
                        [2] = rotationOptions,
                    } }
    return optionTable
end

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
    { 260333, 5, 'Tantrum - Underrot 2nd boss' },
    { 302420, 5, 'Queen\'s Decree: Hide' },
}
--end of dbm list
local debuff_list = {
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
}
local pre_hot_list = {
    --Battle of Dazar'alor
    [283572] = { targeted = true }, --"Sacred Blade"
    [284578] = { targeted = true }, --"Penance"
    [286988] = { targeted = true }, --Divine Burst"
    [282036] = { targeted = true }, --"Fireball"
    [282182] = { targeted = false }, --"Buster Cannon"
    --Uldir
    [279669] = { targeted = false }, --"Bacterial Outbreak"
    [279660] = { targeted = false }, --"Endemic Virus"
    [274262] = { targeted = false }, --"Explosive Corruption"
    --Reaping
    [288693] = { targeted = true }, --"Grave Bolt",
    --Atal'Dazar
    [250096] = { targeted = true }, --"Wracking Pain"
    [253562] = { targeted = true }, --"Wildfire"
    [252781] = { targeted = true }, --"Unstable Hex"
    [252923] = { targeted = true }, --"Venom Blast"
    [253239] = { targeted = true }, -- Dazarai Juggernaut - Merciless Assault },
    [256846] = { targeted = true }, --'Dinomancer Kisho - Deadeye Aim'},
    [257407] = { targeted = true }, -- Rezan - Pursuit},
    --Kings Rest
    [267618] = { targeted = true }, --"Drain Fluids"
    [267308] = { targeted = true }, --"Lighting Bolt"
    [270493] = { targeted = true }, --"Spectral Bolt"
    [269973] = { targeted = true }, --"Deathly Chill"
    [270923] = { targeted = true }, --"Shadow Bolt"
    [272388] = { targeted = true }, --"Shadow Barrage"
    [266231] = { targeted = true }, -- Kula the Butcher - Severing Axe},
    [270507] = { targeted = true }, --  Spectral Beastmaster - Poison Barrage},
    [265773] = { targeted = true }, -- The Golden Serpent - Spit Gold},
    [270506] = { targeted = true }, -- Spectral Beastmaster - Deadeye Shot},
    --Free Hold
    [259092] = { targeted = true }, --"Lightning Bolt"
    [281420] = { targeted = true }, --"Water Bolt"
    [257267] = { targeted = false }, --"Swiftwind Saber"
    [257739] = { targeted = true }, -- Blacktooth Scrapper - Blind Rage},
    [258338] = { targeted = true }, -- Captain Raoul - Blackout Barrel},
    [256979] = { targeted = true }, -- Captain Eudora - Powder Shot},
    --Siege of Boralus
    [272588] = { targeted = true }, --"Rotting Wounds"
    [272827] = { targeted = false }, --"Viscous Slobber"
    [272581] = { targeted = true }, -- "Water Spray"
    [257883] = { targeted = false }, -- "Break Water"
    [257063] = { targeted = true }, --"Brackish Bolt"
    [272571] = { targeted = true }, --"Choking Waters"
    [257641] = { targeted = true }, -- Kul Tiran Marksman - Molten Slug},
    [272874] = { targeted = true }, -- Ashvane Commander - Trample},
    [272581] = { targeted = true }, -- Bilge Rat Tempest - Water Spray},
    [272528] = { targeted = true }, -- Ashvane Sniper - Shoot},
    [272542] = { targeted = true }, -- Ashvane Sniper - Ricochet},
    -- Temple of Sethraliss
    [263775] = { targeted = true }, --"Gust"
    [268061] = { targeted = true }, --"Chain Lightning"
    [272820] = { targeted = true }, --"Shock"
    [268013] = { targeted = true }, --"Flame Shock"
    [274642] = { targeted = true }, --"Lava Burst"
    [268703] = { targeted = true }, --"Lightning Bolt"
    [272699] = { targeted = true }, --"Venomous Spit"
    [268703] = { targeted = true }, -- Charged Dust Devil - Lightning Bolt},
    [272670] = { targeted = true }, -- Sandswept Marksman - Shoot},
    [267278] = { targeted = true }, -- Static-charged Dervish - Electrocute},
    [272820] = { targeted = true }, -- Spark Channeler - Shock},
    [274642] = { targeted = true }, -- Hoodoo Hexer - Lava Burst},
    [268061] = { targeted = true }, -- Plague Doctor - Chain Lightning},
    --Shrine of the Storm
    [265001] = { targeted = true }, --"Sea Blast"
    [268347] = { targeted = true }, --"Void Bolt"
    [267969] = { targeted = true }, --"Water Blast"
    [268233] = { targeted = true }, --"Electrifying Shock"
    [268315] = { targeted = true }, --"Lash"
    [268177] = { targeted = true }, --"Windblast"
    [268273] = { targeted = true }, --"Deep Smash"
    [268317] = { targeted = true }, --"Rip Mind"
    [265001] = { targeted = true }, --"Sea Blast"
    [274703] = { targeted = true }, --"Void Bolt"
    [268214] = { targeted = true }, --"Carve Flesh"
    [264166] = { targeted = true }, -- Aqusirr - Undertow},
    [268214] = { targeted = true }, -- Runecarver Sorn - Carve Flesh},
    --Motherlode
    [259856] = { targeted = true }, --"Chemical Burn"
    [260318] = { targeted = true }, --"Alpha Cannon"
    [262794] = { targeted = true }, --"Energy Lash"
    [263202] = { targeted = true }, --"Rock Lance"
    [262268] = { targeted = true }, --"Caustic Compound"
    [263262] = { targeted = true }, --"Shale Spit"
    [263628] = { targeted = true }, --"Charged Claw"
    [268185] = { targeted = true }, -- Refreshment Vendor, Iced Spritzer},
    [258674] = { targeted = true }, -- Off-Duty Laborer - Throw Wrench},
    [276304] = { targeted = true }, -- Rowdy Reveler - Penny For Your Thoughts},
    [263209] = { targeted = true }, -- Mine Rat - Throw Rock},
    [263202] = { targeted = true }, -- Venture Co. Earthshaper - Rock Lance},
    [262794] = { targeted = true }, -- Venture Co. Mastermind - Energy Lash},
    [260669] = { targeted = true }, -- Rixxa Fluxflame - Propellant Blast},
    --Underrot
    [260879] = { targeted = true }, --"Blood Bolt"
    [265084] = { targeted = true }, --"Blood Bolt"
    [259732] = { targeted = false }, --"Festering Harvest"
    [266209] = { targeted = false }, --"Wicked Frenzy"
    [265376] = { targeted = true }, -- Fanatical Headhunter - Barbed Spear},
    [265625] = { targeted = true }, -- Befouled Spirit - Dark Omen},
    --Tol Dagor
    [257777] = { targeted = true }, --"Crippling Shiv"
    [258150] = { targeted = true }, --"Salt Blast"
    [258869] = { targeted = true }, --"Blaze"
    [256039] = { targeted = true }, -- Overseer Korgus - Deadeye},
    [185857] = { targeted = true }, -- Ashvane Spotter - Shoot},
    --Waycrest Manor
    [260701] = { targeted = true }, --"Bramble Bolt"
    [260700] = { targeted = true }, --"Ruinous Bolt"
    [260699] = { targeted = true }, --"Soul Bolt"
    [261438] = { targeted = true }, --"Wasting Strike"
    [266225] = { targeted = true }, --Darkened Lightning"
    [273653] = { targeted = true }, --"Shadow Claw"
    [265881] = { targeted = true }, --"Decaying Touch"
    [264153] = { targeted = true }, --"Spit"
    [278444] = { targeted = true }, --"Infest"
    [167385] = { targeted = true }, --"Infest"
    [263891] = { targeted = true }, -- Heartsbane Vinetwister - Grasping Thorns},
    [264510] = { targeted = true }, -- Crazed Marksman - Shoot},
    [260699] = { targeted = true }, -- Coven Diviner - Soul Bolt},
    [260551] = { targeted = true }, -- Soulbound Goliath - Soul Thorns},
    [260741] = { targeted = true }, -- Heartsbane Triad - Jagged Nettles},
    [268202] = { targeted = true } -- Gorak Tul - Death Lens},
}


----------------
--- ROTATION ---
---------------_

local function runRotation()
    -- if br.timer:useTimer("debugRestoration", 0.1) then
    --print("Running: "..rotationName)

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Decurse", 0.25)
    UpdateToggle("Interrupt", 0.25)
    UpdateToggle("DPS", 0.25)
    UpdateToggle("Forms", 0.25)
    UpdateToggle("prehot", 0.25)

    br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]
    br.player.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]
    br.player.mode.forms = br.data.settings[br.selectedSpec].toggles["Forms"]
    br.player.mode.rejuvenation = br.data.settings[br.selectedSpec].toggles["prehot"]



    --------------
    --- Locals ---
    --------------
    -- local artifact                                      = br.player.artifact
    -- local combatTime                                    = getCombatTime()
    local cd = br.player.cd
    -- local charges                                       = br.player.charges
    -- local perk                                          = br.player.perk
    local gcd = br.player.gcd
    -- local lastSpell                                     = lastSpellCast
    local lowest = br.friend[1]
    local LastEfflorescenceTime = nil
    local buff = br.player.buff
    local cast = br.player.cast
    local combo = br.player.power.comboPoints.amount()
    local debuff = br.player.debuff
    local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0
    local resable = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") and UnitInRange("target")
    local deadtar = UnitIsDeadOrGhost("target") or isDummy()
    local hastar = hastar or GetObjectExists("target")
    local enemies = br.player.enemies
    local friends = friends or {}
    local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
    local moving = isMoving("player") ~= false or br.player.moving
    local gcdMax = br.player.gcdMax
    local essence = br.player.essence
    local traits = br.player.traits

    local healPot = getHealthPot()
    local inCombat = isInCombat("player")
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    local inRaid = br.player.instance == "raid"
    local stealthed = UnitBuffID("player", 5215) ~= nil
    local level = br.player.level
    local lowestHP = br.friend[1].unit
    local mana = br.player.power.mana.percent()
    local mode = br.player.mode
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
    local traits = br.player.traits
    local solo = #br.friend == 1
    local rejuvCount = 0
    tanks = getTanksTable()
    local tank = nil
    local critical = nil
    local ttd = getTTD
    local BleedFriend = nil
    local BleedFriendCount = 0
    local BleedStack = 0
    local norepeat = false
    local hasteAmount = GetHaste() / 100
    local catspeed = br.player.buff.dash.exists() or br.player.buff.tigerDash.exists()
    local freeMana = buff.innervate.exists() or buff.symbolOfHope.exists()

    units.get(5)
    units.get(8)
    units.get(40)

    enemies.get(5)
    enemies.get(8)
    enemies.get(8, "target") -- enemies.yards8t
    enemies.get(10, "target", true)
    enemies.get(11, "target") -- enemies.yards8t
    enemies.get(15)
    enemies.get(25)
    enemies.get(40)
    friends.yards40 = getAllies("player", 40)

    local lowest = br.friend[1]
    local friends = friends or {}

    if #tanks > 0 and inInstance then
        for i = 1, #tanks do
            tank = tanks[i].unit
        end
    else
        tank = "Player"
    end

    shiftTimer = shiftTimer or 0
    local function clearForm()
        if not noform and not buff.incarnationTreeOfLife.exists() then
            RunMacroText("/CancelForm")
        end
    end

    --old un-used feng functions
    --[[
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
]]
    local function BossEncounterCase()
        --critical
        if isChecked("Critical HP") and lowest.hp <= getOptionValue("Critical HP") then
            if cast.able.cenarionWard then
                if cast.cenarionWard(lowest.hp) then
                    br.addonDebug("[CRIT]CWard on: " .. lowest.unit)
                    return true
                end
            end
            if cast.able.swiftmend() then
                if cast.swiftmend(lowest.unit) then
                    br.addonDebug("[CRIT]Swiftmend on: " .. lowest.unit)
                    return true
                end
            end
            if talent.germination and not buff.rejuvenationGermination.exists(lowest.unit) then
                if cast.rejuvenation(lowest.unit) then
                    br.addonDebug("[CRIT]Germination on: " .. lowest.unit)
                    return true
                end
            elseif not talent.germination and not buff.rejuvenation.exists(lowest.unit) then
                if cast.rejuvenation(lowest.unit) then
                    br.addonDebug("[CRIT]Rejuvenation on: " .. lowest.unit)
                    return true
                end
            end
            if cast.able.regrowth() then
                if cast.regrowth(lowest.unit) then
                    br.addonDebug("[CRIT]Regrowth on: " .. lowest.unit)
                    return true
                end
            end
        end



        -- DOT damage to teammates cast Rejuvenation
        if isChecked("Smart Hot") then

            local spellTarget = nil
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local _, _, _, _, endCast, _, _, _, spellcastID = UnitCastingInfo(thisUnit)
                spellTarget = select(3, UnitCastID(thisUnit))
                if spellTarget ~= nil and endCast and pre_hot_list[spellcastID] and ((endCast / 1000) - GetTime()) < 1 then
                    if cast.cenarionWard(spellTarget) then
                        br.addonDebug("[Snipe]CW on: " .. spellTarget)
                        return true
                    end
                    if talent.germination and not buff.rejuvenationGermination.exists(spellTarget) then
                        if cast.rejuvenation(spellTarget) then
                            br.addonDebug("[Snipe]Germination on: " .. spellTarget)
                            return true
                        end
                    elseif not talent.germination and not buff.rejuvenation.exists(spellTarget) then
                        if cast.rejuvenation(spellTarget) then
                            br.addonDebug("[Snipe]Rejuvenation on: " .. spellTarget)
                            return true
                        end
                    end
                end
            end
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    for k, v in pairs(debuff_list) do
                        if getDebuffRemain(br.friend[i].unit, v.spellID) > v.secs and getDebuffStacks(br.friend[i].unit, v.spellID) >= v.stacks and not buff.rejuvenation.exists(br.friend[i].unit) then
                            if talent.germination and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
                                if cast.rejuvenation(br.friend[i].unit) then
                                    br.addonDebug("[DEBUFF]Germination on: " .. br.friend[1].name)
                                    return true
                                end
                            elseif not buff.rejuvenation.exists(br.friend[i].unit) then
                                if cast.rejuvenation(br.friend[i].unit) then
                                    br.addonDebug("[DEBUFF]Rejuv on: " .. br.friend[1].name)
                                    return true
                                end
                            end
                            return true
                        end
                    end
                end
            end -- cw snipe


            for i = 1, #precast_spell_list do
                local boss_spell_id = precast_spell_list[i][1]
                local precast_time = precast_spell_list[i][2]
                local spell_name = precast_spell_list[i][3]
                local time_remain = br.DBM:getPulltimer(nil, boss_spell_id)
                if time_remain < precast_time then
                    for j = 1, #br.friend do
                        if UnitInRange(br.friend[j].unit) then
                            if not buff.rejuvenation.exists(br.friend[j].unit) then
                                if cast.rejuvenation(br.friend[j].unit) then
                                    br.addonDebug("[PRE-HOT]Rejuv on: " .. br.friend[j].name .. " because: " .. spell_name)

                                    return true
                                end
                            end
                        end
                    end
                end
            end
            local Casting = {
                --spell_id	, spell_name
                { 196587, 'Soul Burst' }, --Amalgam of Souls
                { 211464, 'Fel Detonation' }, --Advisor Melandrus
                { 237276, 'Pulverizing Cudgel' }, --Thrashbite the Scornful
                { 193611, 'Focused Lightning' }, --Lady Hatecoil
                { 192305, 'Eye of the Storm' }, --Hyrja
                { 239132, 'Rupture Realities' }, --Fallen Avatar
            }
            for i = 1, #Casting do
                local spell_id = Casting[i][1]
                local spell_name = Casting[i][2]
                for j = 1, #br.friend do
                    if UnitInRange(br.friend[j].unit) then
                        if UnitCastingInfo("boss1") == GetSpellInfo(spell_id) and not buff.rejuvenation.exists(br.friend[j].unit) then
                            if cast.rejuvenation(br.friend[j].unit) then
                                br.addonDebug("[DBM PRE-HOT]Rejuv on: " .. br.friend[j].name .. " because: " .. spell_name)
                                return
                            end
                        end
                    end
                end
            end
        end

        if isChecked("Freehold - pig") then
            bossHelper()
        end


        -- Temple of Sethraliss
        if lowest.hp > getOptionValue("Temple of Seth Heal") then
            for i = 1, GetObjectCount() do
                local thisUnit = GetObjectWithIndex(i)
                if GetObjectID(thisUnit) == 133392 then
                    sethObject = thisUnit
                    if getHP(sethObject) < 100 and getBuffRemain(sethObject, 274148) == 0 then
                        if talent.germination and not buff.rejuvenationGermination.exists(sethObject) then
                            if cast.rejuvenation(sethObject) then
                                br.addonDebug("[Seth]Germination on: " .. sethObject)
                                return true
                            end
                        elseif not talent.germination and not buff.rejuvenation.exists(sethObject) then
                            if cast.rejuvenation(sethObject) then
                                br.addonDebug("[Seth]Rejuvenation on: " .. sethObject)
                                return true
                            end
                        end
                        if cast.able.swiftmend() then
                            if cast.swiftmend(sethObject) then
                                br.addonDebug("[Seth]Swiftmend on: " .. sethObject)
                                return true
                            end
                        end
                        if cast.regrowth(sethObject) then
                            br.addonDebug("[Seth]Regrowth on: " .. sethObject)
                            return true
                        end
                    end
                end
            end
        end

        if inInstance and inCombat and (select(8, GetInstanceInfo()) == 1862 or select(8, GetInstanceInfo()) == 1762) then
            for i = 1, #br.friend do
                -- Jagged Nettles and Dessication logic
                if getDebuffRemain(br.friend[i].unit, 260741) ~= 0 or getDebuffRemain(br.friend[i].unit, 267626) ~= 0 then
                    if getSpellCD(18562) == 0 then
                        if cast.swiftmend(br.friend[i].unit) then
                            return true
                        end
                    end
                    if cast.ironbark(br.friend[i].unit) then
                        return true
                    end
                    if getSpellCD(18562) > gcdMax then
                        if cast.regrowth(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end
        -- Sacrifical Pits
        -- Devour
        if inInstance and inCombat and select(8, GetInstanceInfo()) == 1763 then
            for i = 1, #br.friend do
                if getDebuffRemain(br.friend[i].unit, 255421) ~= 0 and br.friend[i].hp <= 90 then
                    if getSpellCD(102342) == 0 then
                        if cast.ironbark(br.friend[i].unit) then
                            return true
                        end
                    end
                    if cast.regrowth(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end

    -- Action List - Extras
    local function auto_forms()
        if mode.forms == 1 then
            --and br.timer:useTimer("debugShapeshift", 0.25) then
            -- Flight Form
            if not inCombat and canFly() and not swimming and br.fallDist > 90 and level >= 58 and not buff.prowl.exists() then
                if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                    -- CancelShapeshiftForm()
                    RunMacroText("/CancelForm")
                    CastSpellByID(783, "player")
                    return true
                else
                    CastSpellByID(783, "player")
                    return true
                end
            end
            -- Aquatic Form
            if (not inCombat --[[or getDistance("target") >= 10--]]) and swimming and not travel and not buff.prowl.exists() and isMoving("player") then
                if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                    -- CancelShapeshiftForm()
                    RunMacroText("/CancelForm")
                    CastSpellByID(783, "player")
                    return true
                else
                    CastSpellByID(783, "player")
                    return true
                end
            end
            -- Travel Form
            if not inCombat and not swimming and level >= 58 and not buff.prowl.exists() and not travel and not IsIndoors() and IsMovingTime(1) then
                if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                    RunMacroText("/CancelForm")
                    CastSpellByID(783, "player")
                    return true
                else
                    CastSpellByID(783, "player")
                    return true
                end
            end
            -- Cat Form
            if not cat and not IsMounted() and not flying and IsIndoors() then
                -- Cat Form when not swimming or flying or stag and not in combat
                if moving and not swimming and not flying and not travel then
                    if cast.catForm("player") then
                        return true
                    end
                end
                -- Cat Form - Less Fall Damage
                if (not canFly() or inCombat or level < 58) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then
                    --falling > getOptionValue("Fall Timer") then
                    if cast.catForm("player") then
                        return true
                    end
                end
            end
        end -- End Shapeshift Form Management
        -- Revive
        if isChecked("Revive") then
            if getOptionValue("Revive") == 1 and hastar and playertar and deadtar then
                if cast.revive("target", "dead") then
                    br.addonDebug("Casting Revive")
                    return true
                end
            end
            if getOptionValue("Revive") == 2 and hasMouse and playerMouse and deadMouse then
                if cast.revive("mouseover", "dead") then
                    br.addonDebug("Casting Revive")
                    return true
                end
            end
        end
    end -- End Action List - Extras


    local function Defensive()
        if useDefensive() then

            --Kings Rest Specific stuff


            -- Barkskin
            if isChecked("Barkskin") and cast.able.barkskin() then
                if
                php <= getOptionValue("Barkskin")
                        or UnitDebuffID("player", 265773) -- spit-gold from KR
                then
                    if cast.barkskin() then
                        return
                    end
                end
            end
            -- Healthstone
            if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and (hasHealthPot() or hasItem(5512)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                end
            end
            -- Renewal
            if isChecked("Renewal") and talent.renewal then
                if php <= getOptionValue("Renewal") then
                    if cast.renewal() then
                        return true
                    end
                end
            end
            -- Rebirth
            if isChecked("Rebirth") and not moving then
                if getOptionValue("Rebirth") == 1 -- Target
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
                    if cast.rebirth("target", "dead") then
                        return true
                    end
                end
                if getOptionValue("Rebirth") == 2 -- Mouseover
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
                    if cast.rebirth("mouseover", "dead") then
                        return true
                    end
                end
                if getOptionValue("Rebirth") == 3 then
                    -- Tank
                    for i = 1, #tanks do
                        if UnitIsPlayer(tanks[i].unit) and UnitIsDeadOrGhost(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") then
                            if cast.rebirth(tanks[i].unit, "dead") then
                                return true
                            end
                        end
                    end
                end
                if getOptionValue("Rebirth") == 4 then
                    -- Healer
                    for i = 1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER") then
                            if cast.rebirth(br.friend[i].unit, "dead") then
                                return true
                            end
                        end
                    end
                end
                if getOptionValue("Rebirth") == 5 then
                    -- Tank/Healer
                    for i = 1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                            if cast.rebirth(br.friend[i].unit, "dead") then
                                return true
                            end
                        end
                    end
                end
                if getOptionValue("Rebirth") == 6 then
                    -- Any
                    for i = 1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                            if cast.rebirth(br.friend[i].unit, "dead") then
                                return true
                            end
                        end
                    end
                end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive

    -- Interrupt
    local function Interrupts()
        if useInterrupts() then
            for i = 1, #enemies.yards15 do
                local thisUnit = enemies.yards15[i]
                if canInterrupt(thisUnit, getOptionValue("InterruptAt")) then
                    -- Typhoon
                    if isChecked("Typhoon") and talent.typhoon and getFacing("player", thisUnit) then
                        if cast.typhoon() then
                            return
                        end
                    end
                    -- Mighty Bash
                    if isChecked("Mighty Bash") and talent.mightyBash and getDistance(thisUnit, "player") <= 5 then
                        if cast.mightyBash(thisUnit) then
                            return true
                        end
                    end
                end
            end
        end
    end

    local function Cooldowns()

        --Essence Support
        --overchargeMana

        if isChecked("Ever Rising Tide") and essence.overchargeMana.active and getSpellCD(296072) <= gcd then

            if getOptionValue("Ever Rising Tide") == 1 then
                if cast.overchargeMana() then
                    return
                end
            end
            if getOptionValue("Ever Rising Tide") == 2 then
                if cd.ironbark.exists() or cd.incarnationTreeOfLife.exists() or burst == true then
                    if cast.overchargeMana() then
                        return
                    end
                end
            end
            if getOptionValue("Ever Rising Tide") == 3 then
                if lowest.hp < getOptionValue("Ever Rising Tide - Health") or burst == true then
                    if cast.overchargeMana() then
                        return
                    end
                end
            end
        end
        --lucid dreams
        if isChecked("Memory of Lucid Dreams") and getSpellCD(298357) <= gcd
                and mana <= getValue("Memory of Lucid Dreams") then
            if cast.memoryOfLucidDreams() then
                return
            end
        end

        --"Well of Existence  - Health"
        if isChecked("Well of Existence  - Health") and essence.refreshment.active and getSpellCD(296197) <= gcd then
            if lowest.hp < getOptionValue("Well of Existence  - Health") or burst == true then
                if cast.refreshment(lowest.unit) then
                    return true
                end
            end
        end
        --Seed of Eonar
        if isChecked("Seed of Eonar") and essence.lifeBindersInvocation.active and cast.able.lifeBindersInvocation and not moving then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Seed of Eonar"), #br.friend)
                    if #lowHealthCandidates >= getValue("Seed of Eonar Targets") and not moving or burst == true then
                        if cast.lifeBindersInvocation() then
                            return true
                        end
                    end
                end
            end
        end

        --stat gem from crown
        if hasItem(166801) and canUseItem(166801) and not buff.saphireofBrilliance.exists("player") then
            useItem(166801)
            return true
        end

        local burst = nil
        --Bursting
        --Print("Check" ..isChecked("Bursting").."#: "..getOptionValue("Bursting"))
        if isChecked("Bursting") and inInstance and #tanks > 0 then
            local ourtank = tanks[1].unit
            local Burststack = getDebuffStacks(ourtank, 240443)
            if Burststack >= getOptionValue("Bursting") then
                burst = true
            end
        end


        -- Ironbark
        if isChecked("Ironbark") and inCombat then
            if getOptionValue("Ironbark Target") == 1 then
                if php <= getValue("Ironbark") then

                    if cast.ironbark("player") then
                        return true
                    end
                end
            elseif getOptionValue("Ironbark Target") == 2 then
                if getHP("target") <= getValue("Ironbark") then

                    if cast.ironbark("target") then
                        return true
                    end
                end
            elseif getOptionValue("Ironbark Target") == 3 then
                if getHP("mouseover") <= getValue("Ironbark") then

                    if cast.ironbark("mouseover") then
                        return true
                    end
                end
            elseif getOptionValue("Ironbark Target") == 4 then
                for i = 1, #tanks do
                    if tanks[i].hp <= getValue("Ironbark") then

                        if cast.ironbark(tanks[i].unit) then
                            return true
                        end
                    end
                end
            elseif getOptionValue("Ironbark Target") == 5 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Ironbark") and UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" then
                        if cast.ironbark(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            elseif getOptionValue("Ironbark Target") == 6 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Ironbark") and (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                        if cast.ironbark(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            elseif getOptionValue("Ironbark Target") == 7 then
                if lowest.hp <= getValue("Ironbark") then

                    if cast.ironbark(lowest.unit) then
                        return true
                    end
                end
            end
        end

        if useCDs() then
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
            if isChecked("Racial") and (race == "Orc" or race == "Troll") then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end

            -- Trinkets
            if isChecked("Trinket 1") and canUseItem(13) then
                if getOptionValue("Trinket 1 Mode") == 1 then
                    if getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") then
                        useItem(13)
                        return true
                    end
                elseif getOptionValue("Trinket 1 Mode") == 2 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Trinket 1") then
                            UseItemByName(select(1, GetInventoryItemID("player", 13)), br.friend[i].unit)
                            return true
                        end
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
                            if #meleeFriends >= 8 then
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
                                local px, py, pz = ObjectPosition("player")
                                loc.z = select(3, TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                if loc.z ~= nil and TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then
                                    -- Check z and LoS, ignore terrain and m2 collisions
                                    useItem(13)
                                    ClickPosition(loc.x, loc.y, loc.z)
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            if isChecked("Trinket 2") and canUseItem(14) then
                if getOptionValue("Trinket 2 Mode") == 1 then
                    if getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") then
                        useItem(14)
                        return true
                    end
                elseif getOptionValue("Trinket 2 Mode") == 2 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= getValue("Trinket 2") then
                            UseItemByName(select(1, GetInventoryItemID("player", 14)), br.friend[i].unit)
                            return true
                        end
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
                            if #meleeFriends >= 8 then
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
                                local px, py, pz = ObjectPosition("player")
                                loc.z = select(3, TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                if loc.z ~= nil and TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then
                                    -- Check z and LoS, ignore terrain and m2 collisions
                                    useItem(13)
                                    ClickPosition(loc.x, loc.y, loc.z)
                                    return true
                                end
                            end
                        end
                    end
                end
            end


            -- Mana Potion
            if isChecked("Mana Potion") and mana <= getValue("Mana Potion") then
                if hasItem(127835) then
                    useItem(127835)
                end
            end

            -- Innervate
            if isChecked("Auto Innervate") and cast.able.innervate() and getTTD("target") >= 12 and (br.player.traits.livelySpirit.active or mana < getValue("Auto Innervate")) then
                if cast.innervate("Player") then
                    return true
                end
            end

            -- Incarnation: Tree of Life
            if isChecked("Incarnation") and talent.incarnationTreeOfLife and not buff.incarnationTreeOfLife.exists() then
                if getLowAllies(getValue("Incarnation")) >= getValue("Incarnation Targets") then
                    if cast.incarnationTreeOfLife() then
                        return true
                    end
                end
            end
            -- Tranquility
            if isChecked("Tranquility") and not moving and not buff.incarnationTreeOfLife.exists() then
                if getLowAllies(getValue("Tranquility")) >= getValue("Tranquility Targets") then
                    if cast.tranquility() then
                        return true
                    end
                end
            end
        end -- End useCooldowns check
    end -- End Action List - Cooldowns


    local function DPS()
        clearForm()

        --dots

        local sunfire_target = 0
        local sunfire_radius = 8
        if traits.highNoon.active then
            sunfire_target = #enemies.yards11t
            sunfire_radius = 11
        else
            sunfire_target = #enemies.yards8t
            sunfire_radius = 8
        end

        for i = 1, #enemies.yards40 do
            if isChecked("Safe Dots") and
                    ((inInstance and #tanks > 0 and getDistance(thisUnit, tanks[1].unit) <= 10)
                            or (inInstance and #tanks == 0)
                            or (inRaid and #tanks > 1 and (getDistance(thisUnit, tanks[1].unit) <= 10 or (getDistance(thisUnit, tanks[2].unit) <= 10)))
                            or solo
                            or (inInstance and #tanks > 0 and getDistance(tanks[1].unit) >= 90)
                    ) or not isChecked("Safe Dots") then

                if debuff.sunfire.count() == 0 then
                    if cast.sunfire(getBiggestUnitCluster(40, sunfire_radius)) then
                        br.addonDebug("Initial Sunfire - Cluster(" .. sunfire_radius .. ")")
                        return true
                    end
                end

                if cast.able.sunfire() and (debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") or isBoss(thisUnit)) and ttd(thisUnit) > 5 then
                    if not debuff.sunfire.exists(thisUnit) then
                        if cast.sunfire(thisUnit) then
                            br.addonDebug("Initial Sunfire - non-Cluster")
                            return true
                        end
                    end
                elseif debuff.sunfire.exists(thisUnit) and debuff.sunfire.remain(thisUnit) < 5 and ttd(thisUnit) > 5 then
                    if cast.sunfire(thisUnit) then
                        br.addonDebug("Refreshing sunfire - remain: " .. debuff.sunfire.remain(thisUnit))
                        return true
                    end
                end

                if cast.able.moonfire() and debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") or isBoss(thisUnit) and ttd(thisUnit) > 5 then
                    if not debuff.moonfire.exists(thisUnit) then
                        if cast.moonfire(thisUnit) then
                            br.addonDebug("Initial Moonfire")
                            return true
                        end
                    end
                elseif debuff.moonfire.exists(thisUnit) and debuff.moonfire.remain(thisUnit) < 6 and ttd(thisUnit) > 5 then
                    if cast.moonfire(thisUnit) then
                        br.addonDebug("Refreshing moonfire - remain: " .. debuff.moonfire.remain(thisUnit))
                        return true
                    end
                end

                if cast.concentratedFlame("target") then
                    return true
                end

                -- Solar Wrath
                if cast.solarWrath(units.dyn40) then
                    return true
                end
            end
        end
    end -- End Action List - DPS

    -----------------------------
    --- In Combat - Rotations ---
    -----------------------------

    local function fully_auto_dps()
        if cat and buff.prowl.exists() then

        end

    end

    local function auto_combat()


        --[[
A	1.00	rake,if=buff.shadowmeld.up|buff.prowl.up
B	1.00	auto_attack
C	35.73	moonfire,target_if=refreshable|(prev_gcd.1.sunfire&remains<duration*0.8&spell_targets.sunfire=1)
D	17.10	sunfire,target_if=refreshable|(prev_gcd.1.moonfire&remains<duration*0.8)
E	4.81	solar_wrath,if=energy<=50&!buff.cat_form.up
F	15.95	cat_form,if=!buff.cat_form.up&energy>50
G	0.78	ferocious_bite,if=(combo_points>3&target.time_to_die<3)|(combo_points=5&energy>=50&dot.rip.remains>14)&spell_targets.swipe_cat<5
0.00	swipe_cat,if=spell_targets.swipe_cat>=6
H	11.52	rip,target_if=refreshable&combo_points=5
I	33.48	rake,target_if=refreshable
J	28.64	swipe_cat,if=spell_targets.swipe_cat>=2
0.00	shred
]]


    end

    local function cat_combat()


        --aoe_count
        local aoe_count = 0
        for i = 1, #enemies.yards10tnc do
            local thisUnit = enemies.yards10tnc[i]
            if ttd(thisUnit) > 4 then
                aoe_count = aoe_count + 1
            end
        end

        if not cat then
            if cast.catForm("player") then
                return true
            end
        end
        --auto attack
        StartAttack(units.dyn5)

        --lucid dreams
        if cat and inCombat and isChecked("Lucid Cat") and getSpellCD(298357) <= gcd and ttd("target") > 12 then
            if cast.memoryOfLucidDreams() then
                br.addonDebug("Lucid Kitty Dreams ....")
                return
            end
        end


        --rush if we can -
        if talent.wildCharge and isChecked("Cat Charge") and #enemies.yards8 < 1 then
            local tankTarget = UnitTarget(tank) or "target"
            if getDistance(tankTarget) > 8 and getDistance(tankTarget) < 25
                    and (inInstance and tankTarget ~= nil or not inInstance) and getDistance(tankTarget, tank) < 8 then
                if cast.wildCharge(tankTarget) then
                    return true
                end
            end
        end

        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]



            -- Ferocious Bite
            --ferocious_bite,if=(combo_points>3&target.time_to_die<3)|(combo_points=5&energy>=50&dot.rip.remains>14)&spell_targets.swipe_cat<5
            if cat and combo > 3 and ttd(thisUnit) < 3 or (combo == 5 and br.player.power.energy.amount() >= 50 and debuff.rip.remain(thisUnit) > 14)
                    and aoe_count < 5 then
                if cast.ferociousBite(thisUnit)
                then
                    br.addonDebug("[CAT-DPS] Bite: " .. thisUnit .. " Combo points: " .. combo .. "ttd: " .. ttd(thisUnit))
                    return true
                end
            end

            --swipe_cat,if=spell_targets.swipe_cat>=6
            if aoe_count >= 6 then
                if cast.swipeCat() then
                    br.addonDebug("[CAT-DPS] Swipe - aoe: " .. aoe_count)
                    return true
                end
            end

            -- rip,target_if=refreshable&combo_points=5
            if combo == 5 and (not debuff.rip.exists(thisUnit) or (debuff.rip.remain(thisUnit) < 4) and ttd(thisUnit) >= 4) then
                if cast.rip(thisUnit) then
                    br.addonDebug("[CAT-DPS] Applying Rip")
                    return true
                end
            end

            -- Rake 	rake,target_if=refreshable
            --TODO lets rake different targets
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if not (debuff.rake.exists(thisUnit) or debuff.rake.remain(thisUnit) < 4.5) and not noDamageCheck(thisUnit) and not UnitIsDeadOrGhost(thisUnit) then
                    if cast.rake(thisUnit) then
                        br.addonDebug("[CAT-DPS] Raking")
                        return true
                    end
                end
            end

            --swipe_cat,if=spell_targets.swipe_cat>=2
            if aoe_count >= 2 then
                if cast.swipeCat() then
                    br.addonDebug("[CAT-DPS] Multiple targets - swiping")
                    return true
                end
            else
                if cast.shred(thisUnit) then
                    br.addonDebug("[CAT-DPS] Shred")
                    return true
                end
            end
        end -- end cat loop

        if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
        then
            return
        end
    end

    local function cleanse()
        -- clearForm()

        -- Soothe
        if isChecked("Auto Soothe") and cast.able.soothe() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if canDispel(thisUnit, spell.soothe) then
                    if cast.soothe(thisUnit) then
                        return true
                    end
                end
            end
        end
        -- Nature's Cure / Cleanse   --Shrine == 1864
        if br.player.mode.decurse == 1 and cast.able.naturesCure() and not cast.last.naturesCure() then
            for i = 1, #br.friend do
                if canDispel(br.friend[i].unit, spell.naturesCure) and getLineOfSight(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 40 and
                        ((select(8, GetInstanceInfo()) == 1864 and isChecked("Shrine - Dispel Whisper of Power"))
                                or select(8, GetInstanceInfo()) ~= 1864) then
                    if cast.naturesCure(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end
    local function isCC(unit)
        if getOptionCheck("Don't break CCs") then
            return isLongTimeCCed(Unit)
        end
        return false
    end
    local function root_cc()


        local root_UnitList = {}
        if isChecked("Freehold - root grenadier") and select(8, GetInstanceInfo()) == 1754 then
            root_UnitList[129758] = "Irontide Grenadier"
        end
        if isChecked("Atal - root Spirit of Gold") and select(8, GetInstanceInfo()) == 1763 then
            root_UnitList[131009] = "Spirit of Gold"
        end
        if isChecked("All - root Emissary of the Tides") then
            root_UnitList[155434] = "Emissary of the Tides"
        end
        if isChecked("KR - Minions of Zul") then
            root_UnitList[133943] = "minion-of-zul"
            -- root_UnitList[126562] = "minion-of-zul"  testing purpose -  Irritable Deimetradon
        end

        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]

            --Enchanted emmisary == 155432
            if isChecked("Punt Enchanted Emissary") and inInstance then
                if GetObjectID(thisUnit) == 155432 and not isCasting(155432, thisUnit) then
                    if #tanks > 0 and getDistance(tank, thisUnit) <= 26 then
                        br.addonDebug("Punting Emissary - Range from tank: " .. getDistance(tank, thisUnit))
                        if cast.moonfire(thisUnit) then
                            return true
                        end
                    end
                end
            end

            if isChecked("Freehold - root grenadier") or isChecked("Atal - root Spirit of Gold") or isChecked("All - root Emissary of the Tides") or isChecked("KR - Minions of Zul") then
                --br.addonDebug("Mob: " .. thisUnit .. " Health: " .. getHP(thisUnit))
                if cast.able.massEntanglement() and not isCC(thisUnit) and getHP(thisUnit) > 90 then
                    if (root_UnitList[GetObjectID(thisUnit)] ~= nil and getBuffRemain(thisUnit, 226510) <= 3) then
                        if cast.massEntanglement(thisUnit) then
                            br.addonDebug("Mass Rooting: " .. thisUnit)
                            return true
                        end
                    end
                end
                if cast.able.entanglingRoots() and not isCC(thisUnit) and getHP(thisUnit) > 90 then
                    if (root_UnitList[GetObjectID(thisUnit)] ~= nil and getBuffRemain(thisUnit, 226510) <= 3) then
                        if cast.entanglingRoots(thisUnit) then
                            br.addonDebug("Rooting: " .. thisUnit)
                            return true
                        end
                    end
                end
            end

        end
    end

    local function heal()

        if #tanks > 0 and inInstance then
            tank = tanks[1].unit
        else
            tank = "Player"
        end
        if buff.innervate.exists() then
            freemana = true
        else
            freemana = false
        end

        clearForm()
        --determine if we got any criticals
        --[[ for i = 1, #br.friend do
             if UnitInRange(br.friend[i].unit) and br.friend[i].hp <= getValue("Critical") then
                 Critical = true
             end
         end
         ]]

        --lifebloom
        local lifebloom_count = 0
        -- big dots

        if inInstance and inCombat and br.player.eID and (br.player.eID == 2127 or br.player.eID == 2142) then
            for i = 1, #br.friend do
                if getDebuffRemain(br.friend[i].unit, 260741) ~= 0 or getDebuffRemain(br.friend[i].unit, 267626) ~= 0 then
                    if not buff.lifebloom.exists(br.friend[i].unit) or (buff.lifebloom.exists(br.friend[i].unit) and buff.lifebloom.remain(br.friend[i].unit) < 4.5) then
                        if cast.lifebloom(br.friend[i].unit) then
                            br.addonDebug("Lifebloom for big dot on : " .. br.friend[i].unit)
                            return true
                        end
                    end
                end
            end
        else
            if not talent.photosynthesis and not cast.last.lifebloom(1) and inInstance and inCombat then
                if not (buff.lifebloom.exists(tank)) or (buff.lifebloom.exists(tank) and buff.lifebloom.remain(tank) < 4.5 and tanks[1].hp < 80) then
                    if cast.lifebloom(tank) then
                        br.addonDebug("Lifebloom on tank")
                        return true
                    end
                end
            elseif talent.photosynthesis and not cast.last.lifebloom(1) and inInstance then
                for i = 1, #br.friend do
                    if UnitInRange(br.friend[i].unit) and br.friend[i].hp <= getValue("Photosynthesis") then
                        lifebloom_count = lifebloom_count + 1
                    end
                end
                if lifebloom_count >= getValue("Photosynthesis Count") and (not buff.lifebloom.exists("Player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5 and php < 80)) then
                    if cast.lifebloom("player") then
                        br.addonDebug("Lifebloom on healer(photo) - [" .. lifebloom_count .. "/" .. getValue("Photosynthesis Count") .. "]")
                        return true
                    end
                elseif lifebloom_count < getValue("Photosynthesis Count") and (not buff.lifebloom.exists(tank) or (buff.lifebloom.exists(tank) and buff.lifebloom.remain(tank) < 4.5 and getHP(tank) < 80)) then
                    if cast.lifebloom(tank) then
                        br.addonDebug("Lifebloom on tank(photo)- [" .. lifebloom_count .. "/" .. getValue("Photosynthesis Count") .. "]")
                        return true
                    end
                end
            end
        end

        for i = 1, #br.friend do
            if br.friend[i].hp < 100 and UnitInRange(br.friend[i].unit) or GetUnitIsUnit(br.friend[i].unit, "player") then
                --count grievance stacks here
                if isChecked("Grievous Wounds") then
                    local CurrentBleedstack = getDebuffStacks(br.friend[i].unit, 240559)
                    if getDebuffStacks(br.friend[i].unit, 240559) > 0 then
                        BleedFriendCount = BleedFriendCount + 1
                    end
                    if CurrentBleedstack > BleedStack then
                        BleedStack = CurrentBleedstack
                        BleedFriend = br.friend[i]
                        --debug stuff
                        --Print("Griev Debug Target: " .. BleedFriend.unit .. " Stacks: " ..CurrentBleedstack .. " HP: " .. BleedFriend.hp)
                    end
                end
            end
        end


        -- Grievous stuff
        if BleedFriend ~= nil then

            -- wild growth if more than 1 grievance
            if BleedFriendCount > 1 then
                if cast.wildGrowth(BleedFriend.unit) then
                    return true
                end
            end
            if talent.germination and not buff.rejuvenationGermination.exists(BleedFriend.unit) then
                if cast.rejuvenation(BleedFriend.unit) then
                    return true
                end
            elseif not talent.germination and not buff.rejuvenation.exists(BleedFriend.unit) then
                if cast.rejuvenation(BleedFriend.unit) then
                    return true
                end
            end
            if cast.swiftmend(BleedFriend.unit) then
                return true
            end
            if cast.able.regrowth() then
                if not buff.regrowth.exists(BleedFriend.unit) or BleedFriend.hp < getValue("Grievous") then
                    if cast.regrowth(BleedFriend.unit) then
                        return true
                    end
                end
            end
        end -- end grievance


        --lifeBindersInvocation


        --Swiftmend
        --Print("Lowest is: " .. lowest.unit)
        if lowest.hp <= getValue("Swiftmend") and (not inInstance or (inInstance and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot"))) then
            if cast.swiftmend(lowest.unit) then
                return true
            end
        end

        -- Wild Growth
        if isChecked("Wild Growth") and not moving then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) then
                    local lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Wild Growth"), #br.friend)
                    --local lowHealthCandidates2 = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Soul of the Forest + Wild Growth"), #br.friend)
                    if (#lowHealthCandidates >= getValue("Wild Growth Targets") or freemana) and not moving then
                        if cast.wildGrowth(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end


        -- cenarionWard
        if not isChecked("Smart Hot") and isChecked("Cenarion Ward") and talent.cenarionWard and not buff.cenarionWard.exists(tank) and cast.able.cenarionWard(tank) and inCombat then
            if cast.cenarionWard(tank) then
                return true
            end
        end

        -- Rejuvenation
        if isChecked("Rejuvenation") then
            for i = 1, #tanks do
                if talent.germination and (tanks[i].hp <= getValue("Germination Tank") or freemana) and (not buff.rejuvenationGermination.exists(tanks[i].unit) or buff.rejuvenationGermination.remain(tanks[i].unit) < 4.5) then
                    if cast.rejuvenation(tanks[i].unit) then
                        br.addonDebug("[Rejuv]Germination on: " .. tanks[i].unit)
                        return true
                    end
                elseif not talent.germination and (tanks[i].hp <= getValue("Rejuvenation Tank") or freemana) and (not buff.rejuvenation.exists(tanks[i].unit) or buff.rejuvenation.remain(tanks[i].unit) < 4.5) then
                    if cast.rejuvenation(tanks[i].unit) then
                        br.addonDebug("[Rejuv]rejuvenation on: " .. tanks[i].unit)
                        return true
                    end
                end
            end
            for i = 1, #br.friend do
                if talent.germination and (br.friend[i].hp <= getValue("Germination") or freemana) and ((rejuvCount < getValue("Max Rejuvenation Targets")) or freemana) and
                        (not buff.rejuvenationGermination.exists(br.friend[i].unit) or buff.rejuvenationGermination.remain(br.friend[i].unit) < 4.5) then
                    if cast.rejuvenation(br.friend[i].unit) then
                        br.addonDebug("[Rejuv]Germination on: " .. br.friend[i].unit)
                        return true
                    end
                elseif (br.friend[i].hp <= getValue("Rejuvenation") or freemana) and
                        (not buff.rejuvenation.exists(br.friend[i].unit) or buff.rejuvenation.remain(br.friend[i].unit) < 4.5)
                        and ((rejuvCount < getValue("Max Rejuvenation Targets")) or freemana) then
                    if cast.rejuvenation(br.friend[i].unit) then
                        br.addonDebug("[Rejuv]rejuvenation on: " .. br.friend[i].unit)
                        return true
                    end
                end
            end
        end


        --Efflorescence
        if isChecked("Efflorescence") then
            if inCombat and #tanks > 0 and botSpell ~= spell.efflorescence and not buff.springblossom.exists(tanks[1].unit) and GetTotemTimeLeft(1) < 20 then
                local tankTarget = UnitTarget(tanks[1].unit)
                if tankTarget ~= nil and getDistance(tankTarget, "player") < 40 then
                    local meleeFriends = getAllies(tankTarget, 8)
                    local loc = getBestGroundCircleLocation(meleeFriends, 1, 6, 10)
                    if loc ~= nil then
                        local px, py, pz = ObjectPosition("player")
                        loc.z = select(3, TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                        if loc.z ~= nil and TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil then
                            -- Check z and LoS, ignore terrain and m2 collisions
                            if cast.efflorescence() then
                                ClickPosition(loc.x, loc.y, loc.z)
                                return true
                            end
                        end
                    end
                end
            end
        end
        -- Regrowth
        if not moving or buff.incarnationTreeOfLife.exists() then
            for i = 1, #br.friend do
                if isChecked("Regrowth Tank") and br.friend[i].hp <= getValue("Regrowth Tank") and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot"))) then
                    if cast.regrowth(br.friend[i].unit) then
                        return true
                    end
                elseif isChecked("Regrowth") and br.friend[i].hp <= getValue("Regrowth") and (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot"))) then
                    if cast.regrowth(br.friend[i].unit) then
                        return true
                    end
                elseif isChecked("Regrowth Clearcasting") and lowest.hp <= getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > gcdMax then
                    if cast.regrowth(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

    end -- end heal

    local function travel_rest()
        if not travel then
            if cast.travelForm("Player") then
                return true
            end
        end
    end

    local function travel_combat()
        if not travel then
            if cast.travelForm("Player") then
                return true
            end
        end
    end
    local function bear_rest()
        if not bear then
            if cast.bearForm("Player") then
                return true
            end
        end
    end
    local function bear_combat()

        if not bear then
            if cast.bearForm("Player") then
                return true
            end
        end

        StartAttack()

        if isChecked("Bear Frenzies Regen HP") and talent.guardianAffinity and cast.able.frenziedRegeneration() and php <= getValue("Bear Frenzies Regen HP") then
            if cast.frenziedRegeneration() then
                br.addonDebug("[BEAR]Regen")
                return true
            end
        end

        if cast.able.ironfur() and br.player.power.rage.amount() >= 40 then
            if cast.ironfur() then
                return true
            end
        end

        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]

            if talent.guardianAffinity and cd.thrashBear.remain() == 0 then
                if cast.able.thrashBear() and (debuff.thrashBear.stack(thisUnit) < 3 or debuff.trashBear.remain(thisUnit) < 4.5 or cd.mangle.remain() > 0) then
                    if cast.thrashBear(thisUnit) then
                        br.addonDebug("[BEAR]trash - stacks[" .. debuff.thrashBear.stack(thisUnit) .. "]")
                        return true
                    end
                end
            end

            if cast.able.mangle(thisUnit) then
                if cast.mangle(thisUnit) then
                    br.addonDebug("[BEAR]Mangle")
                end
                return true
            end

            if cast.able.swipeResto(thisUnit) then
                if cast.swipeResto(thisUnit) then
                    br.addonDebug("[BEAR]Swipe")
                end
                return true
            end


        end
    end

    local function cat_rest()
        if not cat then
            if cast.catForm("player") then
                return true
            end
        end

        if isChecked("auto stealth") then
            if not br.player.buff.prowl.exists() then
                if cast.prowl("Player") then
                    return true
                end
            end
        end

        if isChecked("auto dash") and not catspeed then
            if cast.tigerDash() then
                return true
            end
            if cast.dash() then
                return true
            end
        end

        if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical")) then
            return
        end
    end

    local function pre_combat()
        clearForm()
        if not cat and not travel and not bear then


            if #tanks > 0 and mode.prehot == 1 then
                -- cenarionWard
                if not isChecked("Smart Hot") and talent.cenarionWard and isChecked("Cenarion Ward") and not buff.cenarionWard.exists(tanks[1].unit) and cast.able.cenarionWard(tank) then
                    if cast.cenarionWard(tanks[1].unit) then
                        br.addonDebug("[PRE-HOT]:CW on: " .. tanks[1].unit)
                        return true
                    end
                end

                if not buff.lifebloom.exists(tanks[1].unit) then
                    if cast.lifebloom(tanks[1].unit) then
                        br.addonDebug("[PRE-HOT]:Lifebloom on: " .. tanks[1].unit)
                        return true
                    end
                end

                --rejuvenation

                for i = 1, #br.friend do

                    if talent.germination and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
                        if cast.rejuvenation(br.friend[i].unit) then
                            br.addonDebug("[PRE-HOT]Germination on: " .. br.friend[1].name)
                            return true
                        end
                    elseif not buff.rejuvenation.exists(br.friend[i].unit) then
                        if cast.rejuvenation(br.friend[i].unit) then
                            br.addonDebug("[PRE-HOT]Rejuv on: " .. br.friend[1].name)
                            return true
                        end
                    end
                end
            end
        end
    end
    -----------------
    --- Rotations ---
    -----------------

    -- Print(tostring(mode.forms))

    -- Pause
    if pause(true) or IsMounted() or flying or drinking or isCastingSpell(spell.tranquility) then
        --or stealthed (travel and not inCombat) or
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat and not UnitBuffID("player", 115834) then

            if isChecked("Break form for dispel") then
                if cleanse() then
                    return true
                end
            end
            if mode.forms == 2 then
                if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical")) then
                    cat_rest()
                    return true
                elseif SpecificToggle("Bear Key") and not GetCurrentKeyBoardFocus() then
                    bear_rest()
                    return true
                elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical")) then
                    travel_rest()
                    return true
                end
            elseif mode.forms == 1 then
                auto_forms()
                return true
            end
            if mode.forms == 3 and noform or mode.forms ~= 3 then
                if cleanse() then
                    return true
                end
                if isChecked("OOC Healing") then
                    if heal() then
                        return true
                    end
                end
                if pre_combat() then
                    return true
                end
            end

        end


        ---------------------------------
        ---  Combat - Rotation        ---
        ---------------------------------
        --    br.ui:createCheckbox(section, "Break form for critical", 1)
        --    br.ui:createCheckbox(section, "Break form for dispel", 1)


        if inCombat and not UnitBuffID("player", 115834) then
            if isChecked("Break form for dispel") then
                if cleanse() then
                    return true
                end
            end
            if mode.forms == 2 then
                if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus() and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical")) then
                    cat_combat()
                    return true
                elseif SpecificToggle("Bear Key") and not GetCurrentKeyBoardFocus() then
                    bear_combat()
                    return true
                elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical")) then
                    travel_combat()
                    return true
                end
            end
            if mode.forms == 3 then
                if cat then
                    cat_combat()
                    return true
                end
                if bear then
                    bear_combat()
                    return true
                end
                if travel then
                    travel_combat()
                    return true
                end
            end
            if mode.forms == 3 and noform or mode.forms ~= 3 or buff.incarnationTreeOfLife.exists() then
                if cleanse() then
                    return true
                end
                if Defensive() then
                    return
                end
                if Cooldowns() then
                    return
                end
                if root_cc() then
                    return
                end
                if Interrupts() then
                    return
                end
                if BossEncounterCase() then
                    return
                end
                if heal() then
                    return true
                end
                if isChecked("pre-hot in combat") then
                    if pre_combat() then
                        return true
                    end
                end
                if mode.DPS == 2 and lowest.hp > getValue("DPS Min % health") then
                    if DPS() then
                        return true
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
tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
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
        [1] = { mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.sunfire },
        [2] = { mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.sunfire }
    };
    CreateButton("DPS", 1, -1)

    FormsModes = {
        [1] = { mode = "On", value = 1, overlay = "Auto Forms Enabled", tip = "Will change forms", highlight = 0, icon = br.player.spell.travelForm },
        [2] = { mode = "Key", value = 2, overlay = "Auto Forms hotkey", tip = "Key triggers Auto Forms", highlight = 0, icon = br.player.spell.travelForm },
        [3] = { mode = "Off", value = 3, overlay = "Auto Forms Disabled", tip = "Will Not change forms", highlight = 0, icon = br.player.spell.travelForm }
    };
    CreateButton("Forms", 5, 0)


    -- Rejuvenation Button
    PrehotModes = {
        [1] = { mode = "On", value = 1, overlay = "Pre-Hot", tip = "Pre-hot Enabled", highlight = 0, icon = br.player.spell.rejuvenation },
        [2] = { mode = "Tank", value = 2, overlay = "Pre-Hot", tip = "Pre-hot on TANK", highlight = 0, icon = br.player.spell.rejuvenation },
        [3] = { mode = "Off", value = 3, overlay = "Pre-Hot", tip = "Pre-hots disabled", highlight = 0, icon = br.player.spell.rejuvenation }

    };
    CreateButton("Prehot", 5, -1)

    HEALSModes = {
        [1] = { mode = "On", value = 1, overlay = "Heals Enabled", tip = "Heals Enabled", highlight = 0, icon = 145108 },
        [2] = { mode = "Off", value = 2, overlay = "Heals Disabled", tip = "Heals Disabled", highlight = 0, icon = 145108 }
    };
    CreateButton("HEALS", 0, -1)

end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "Forms - 2012211544")
        br.ui:createDropdownWithout(section, "Cat Key", br.dropOptions.Toggle, 6, "Set a key for cat/DPS form")
        br.ui:createDropdownWithout(section, "Bear Key", br.dropOptions.Toggle, 6, "Set a key for bear")
        br.ui:createDropdownWithout(section, "Owl Key", br.dropOptions.Toggle, 6, "Set a key for Owl/DPS form")
        br.ui:createDropdownWithout(section, "Travel Key", br.dropOptions.Toggle, 6, "Set a key for travel")
        br.ui:createCheckbox(section, "Cat Charge", "Use Wild Charge to close distance.", 1)
        br.ui:createCheckbox(section, "Break form for critical", "", 1)
        br.ui:createCheckbox(section, "Break form for dispel", "", 1)
        br.ui:createCheckbox(section, "Break form for dots", "")
        br.ui:createCheckbox(section, "auto stealth", "", 1)
        br.ui:createCheckbox(section, "auto dash", "", 1)
        br.ui:createSpinnerWithout(section, "Max RIP Targets", 10, 1, 10, 1, "Max Rip Targets")
        br.ui:createSpinner(section, "Bear Frenzies Regen HP", 50, 0, 100, 1, "HP Threshold start regen")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "M+")
        br.ui:createSpinner(section, "Bursting", 3, 0, 10, 4, "", "Burst Targets - also counts as number under critical")
        br.ui:createSpinner(section, "Grievous Wounds", 2, 0, 10, 1, "Hot Value (calculated to see how much healing is needed for Griev")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Pots")
        br.ui:createCheckbox(section, "Auto use Pots")
        br.ui:createDropdownWithout(section, "Pots - burst healing", { "None", "Battle", "RisingDeath", "Draenic", "Prolonged", "Empowered Proximity", "Focused Resolve", "Superior Battle", "Unbridled Fury" }, 1, "", "Use Pot when Incarnation/Celestial Alignment is up")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createCheckbox(section, "OOC Healing", "Enables/Disables out of combat healing.", 1)
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 0, 20, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinner(section, "Auto Drink", 45, 0, 100, 5, "Mana Percent to Drink At")
        br.ui:createCheckbox(section, "Sugar Crusted Fish Feast", "Use feasts for mana?")
        br.ui:createDropdown(section, "Convoke Spirits", { "DPS", "HEAL", "BOTH", "Manual" }, 3, "How to use Convoke Spirits")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Heals")
        br.ui:createSpinner(section, "Lifebloom", 8, 1, 10, 1, "Delay in seconds before checking for targets")
        br.ui:createSpinner(section, "Smart Hot", 5, 0, 100, 1, "Pre-hot based on DBM or incoming casts - number is max enemies")
        br.ui:createSpinner(section, "Use Bark w/Smart Hot", 30, 0, 100, 5, "Bark based on smart hot - and HP limit to use it at")
        br.ui:createCheckbox(section, "Smart Charge", 1)
        br.ui:createSpinner(section, "Critical HP", 30, 0, 100, 5, "", "When to stop what we do, emergency heals!")
        br.ui:createCheckbox(section, "Natures Swiftness", "Use NS when critical")
        br.ui:createSpinner(section, "Swiftmend", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Nourish", 45, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Nourish - hot count", 3, 0, 5, 1, "Hot count where we like this option")
        br.ui:createSpinner(section, "Rejuvenation", 85, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Rejuvenation Tank", 90, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Germination", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Germination Tank", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createCheckbox(section, "Efflorescence", "green circle - automated")
        br.ui:createCheckbox(section, "Cenarion Ward", "Cenarion Ward - wont use setting if smart hot is enabled")
        br.ui:createSpinner(section, "Regrowth Clearcasting", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Regrowth Tank", 80, 0, 100, 5, "|cffFFFFFFTank Health Percent priority Cast At")
        br.ui:createSpinner(section, "Regrowth", 65, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Wild Growth", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Wild Growth Targets", 3, 0, 40, 1, "Minimum Wild Growth Targets")
        br.ui:createSpinner(section, "Photosynthesis", 70, 0, 100, 5, "Health % for switching to healer")
        br.ui:createSpinnerWithout(section, "Photosynthesis Count", 3, 0, 40, 1, "Minimum hurt Targets")
        br.ui:createCheckbox(section, "pre-hot in combat", "apply pre-hotting routine while in combat")
        br.ui:checkSectionState(section)

        br.ui:createSpinner(section, "Flourish", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Flourish Targets", 3, 0, 40, 1, "Minimum Flourish Targets")
        br.ui:createSpinnerWithout(section, "Flourish HOT Targets", 5, 0, 40, 1, "Minimum HOT Targets cast Flourish")
        br.ui:createSpinnerWithout(section, "HOT Time count", 8, 0, 25, 1, "HOT Less than how many seconds to count")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Auto Stuff")
        --br.ui:createCheckbox(section, "Auto Soothe")
        br.ui:createSpinner(section, "Auto Soothe", 1, 0, 100, 5, "TTD for soothing")
        br.ui:createSpinner(section, "Ironbark", 30, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createDropdownWithout(section, "Ironbark Target", { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny" }, 7, "|cffFFFFFFcast Ironbark Target")
        br.ui:createSpinner(section, "Auto Innervate", 10, 0, 100, 50, "Mana Percent to Cast At")
        br.ui:createDropdown(section, "Revive", { "Target", "Mouseover" }, 1, "|ccfFFFFFFTarget to Cast On")
        -- Rebirth
        br.ui:createDropdown(section, "Rebirth", { "Target", "Mouseover", "Tank", "Healer", "Healer/Tank", "Any" }, 1, "|cffFFFFFFTarget to cast on")
        br.ui:createCheckbox(section, "Auto mass Resurrection")
        br.ui:createSpinner(section, "Mana Potion", 50, 0, 100, 1, "Mana Percent to Cast At")

        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "DPS")

        br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 4, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1")
        br.ui:createSpinnerWithout(section, "Max Sunfire Targets", 10, 1, 30, 1, "|cff0070deSet to maximum number of targets to dot with Sunfire. Min: 1 / Max: 30 / Interval: 1")
        br.ui:createCheckbox(section, "Heart of the Wild")
        --"Max Sunfire Targets"
        br.ui:createSpinnerWithout(section, "DPS Save mana", 40, 0, 100, 5, "|cffFFFFFFMana Percent no Cast Sunfire and Moonfire")
        br.ui:createSpinnerWithout(section, "DPS Min % health", 40, 0, 100, 5, "Don't DPS if under this health % in group (cat enforced w/key")
        br.ui:createCheckbox(section, "Safe Dots")
        br.ui:createCheckbox(section, "Aggressive Dots")
        br.ui:checkSectionState(section)

        -- Trinkets
        section = br.ui:createSection(br.ui.window.profile, "Trinkets")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets", 3, 1, 40, 1, "", "Minimum Trinket 1 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "|cffFFFFFFPocket-Sized CP" }, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "|cffFFFFFFPocket-Sized CP", "DPS target" }, 1, "", "")
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
        -- Healthstone
        br.ui:createSpinner(section, "Potion/Healthstone", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Barkskin
        br.ui:createSpinner(section, "Barkskin", 60, 0, 100, 5, "|cffFFBB00Health Percent to Cast At.");
        -- Renewal
        br.ui:createSpinner(section, "Renewal", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at");
        br.ui:checkSectionState(section)
        -- Interrupts Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Hibernate as Interrupt")
        br.ui:createCheckbox(section, "Mighty Bash")
        br.ui:createCheckbox(section, "Typhoon")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "InterruptAt", 95, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Root/CC")
        br.ui:createCheckbox(section, "Mist - Spirit vulpin")
        br.ui:createCheckbox(section, "Plague - Globgrod")
        br.ui:checkSectionState(section)
    end
    optionTable = { {
                        [1] = "Rotation Options",
                        [2] = rotationOptions,
                    } }
    return optionTable
end
local function isCC(unit)
    if getOptionCheck("Don't break CCs") then
        return isLongTimeCCed(Unit)
    end
    return false
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

local function noDamageCheck(unit)
    if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
        return true
    end
    if isCC(unit) then
        return true
    end
    if GetObjectID(unit) == 127019 then
        --dummies inside of Freehold
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
    --[[if isCasting(302415, unit) then
        -- emmisary teleporting home
        return true
    end
    if GetObjectID(thisUnit) == 155432 then
        --emmisaries to punt, dealt with seperately
        return true
    end]]
    return false --catchall
end

local fishfeast = 0

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
}
--end of dbm list
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
local pre_hot_list = {   --snipe list
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
    [265773] = { targeted = true }, -- https://www.wowhead.com/spell=270487/severing-blade
    [268586] = { targeted = true }, -- https://www.wowhead.com/spell=268586/blade-combo
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
    [263365] = { targeted = true }, --"https://www.wowhead.com/spell=263365/a-peal-of-thunder"
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
    [271456] = { targeted = true }, -- https://www.wowhead.com/spell=271456/drill-smash},
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

    --work shop_
    [294195] = { targeted = true }, --https://www.wowhead.com/spell=294195/arcing-zap
    [293827] = { targeted = true }, --https://www.wowhead.com/spell=293827/giga-wallop
    [292264] = { targeted = true }, -- https://www.wowhead.com/spell=292264/giga-zap
    --junk yard
    [300650] = { targeted = true }, --https://www.wowhead.com/spell=300650/suffocating-smog
    [299438] = { targeted = true }, --https://www.wowhead.com/spell=299438/sledgehammer
    [300188] = { targeted = true }, -- https://www.wowhead.com/spell=300188/scrap-cannon#used-by-npc
    [302682] = { targeted = true }, --https://www.wowhead.com/spell=302682/mega-taze

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
local CC_CreatureTypeList = { "Beast", "Dragonkin" }
local StunsBlackList = {
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
    --mini bosses
    [161241] = "Voidweaver Mal'thir",
}

----------------
--- ROTATION ---
---------------_



--listener based on combatlog

local someone_casting = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local function reader()
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    -- print(...)
    --[[
     if param == "SPELL_CAST_SUCCESS" and spell == 193316 then
         -- or param == "SPELL_AURA_REMOVED" then
         C_Timer.After(0.02, function()
             --    print("refresh rtb")
             dice_reroll = true
         end)
     end]]
    if param == "SPELL_CAST_START" then
        C_Timer.After(0.02, function()
            someone_casting = true
            --Print(source .. "/" .. sourceName .. " is casting " .. spellName)
        end)
    end
end
frame:SetScript("OnEvent", reader)

local eclipse_next = "any"
local wrath_counter = 0
local starfire_counter = 0
local x = 0

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

    --  br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]
    -- br.player.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]
    -- br.player.mode.forms = br.data.settings[br.selectedSpec].toggles["Forms"]
    -- br.player.mode.rejuvenation = br.data.settings[br.selectedSpec].toggles["prehot"]
    -- br.player.mode.HEALS = br.data.settings[br.selectedSpec].toggles["HEALS"]


    --------------
    --- Locals ---
    --------------
    -- local combatTime                                    = getCombatTime()
    local cd = br.player.cd
    -- local charges                                       = br.player.charges
    local gcd = br.player.gcd
    local lowest = br.friend[1]
    local LastEfflorescenceTime = nil
    local buff = br.player.buff
    local runeforge = br.player.runeforge
    local lastSpell = lastSpellCast
    local cast = br.player.cast
    local combo = br.player.power.comboPoints.amount()
    local debuff = br.player.debuff
    local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0 or getBuffRemain("player", 185710) ~= 0
    local resable = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") and UnitInRange("target")
    local deadtar = UnitIsDeadOrGhost("target") or isDummy()
    local hastar = hastar or GetObjectExists("target")
    local enemies = br.player.enemies
    local friends = friends or {}
    local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
    local moving = isMoving("player") ~= false or br.player.moving
    local gcdMax = br.player.gcdMax
    local healPot = getHealthPot()
    local inCombat = isInCombat("player")
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    local inRaid = br.player.instance == "raid"

    local stealthed = UnitBuffID("player", 5215) ~= nil
    local level = br.player.level
    local lowestHP = br.friend[1].unit
    local mana = br.player.power.mana.percent()
    -- local mode = br.player.mode
    local php = br.player.health
    local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local racial = br.player.getRacial()
    local spell = br.player.spell
    local talent = br.player.talent
    local travel = br.player.buff.travelForm.exists()
    local cat = br.player.buff.catForm.exists()
    local owl = br.player.buff.moonkinForm.exists()
    local bear = br.player.buff.bearForm.exists()
    local noform = GetShapeshiftForm() == 0
    local units = br.player.units
    local traits = br.player.traits
    local mode = br.player.ui.mode
    local solo = #br.friend == 1
    local tanks = getTanksTable()
    local tank = nil
    local covenant = br.player.covenant
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

    enemies.get(8, "target") -- enemies.yards8t
    enemies.get(8)
    enemies.get(10, "target", true)
    enemies.get(11, "target") -- enemies.yards8t
    enemies.get(15)
    enemies.get(25)
    enemies.get(30)
    enemies.get(40)
    enemies.get(45)
    friends.yards40 = getAllies("player", 40)

    local lowest = br.friend[1]
    local friends = friends or {}

    local sunfire_target = 0
    local sunfire_radius = 8
    if traits.highNoon.active then
        sunfire_target = #enemies.yards11t
        sunfire_radius = 11
    else
        sunfire_target = #enemies.yards8t
        sunfire_radius = 8
    end

    if #tanks > 0 and not solo then
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

    local function count_hots(unit)
        local count = 0
        if buff.lifebloom.exists(unit) then
            count = count + 1
        end
        if buff.rejuvenation.exists(unit) then
            count = count + 1
        end
        if buff.regrowth.exists(unit) then
            count = count + 1
        end
        if buff.wildGrowth.exists(unit) then
            count = count + 1
        end
        if buff.cenarionWard.exists(unit) then
            count = count + 1
        end
        if buff.cultivat.exists(unit) then
            count = count + 1
        end
        if buff.springblossom.exists(unit) then
            count = count + 1
        end
        if buff.rejuvenationGermination.exists(unit) then
            count = count + 1
        end
        return count
    end

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

    local function owl_combat()

        local is_aoe = #enemies.yards45 > 1 or false
        local current_eclipse = "none"
        local eclipse_in = (buff.eclipse_solar.exists() or buff.eclipse_lunar.exists()) or false



        --  Print("In Eclipse: " .. tostring(eclipse_in) .. " next:  " .. eclipse_next)

        if not buff.moonkinForm.exists() then
            if cast.moonkinForm() then
                return true
            end
        end


        --dots
        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if not noDamageCheck(thisUnit) then
                if isChecked("Safe Dots") and
                        ((inInstance and #tanks > 0 and getDistance(thisUnit, tanks[1].unit) <= 10)
                                or (inInstance and #tanks == 0)
                                or (inRaid and #tanks > 1 and (getDistance(thisUnit, tanks[1].unit) <= 10 or (getDistance(thisUnit, tanks[2].unit) <= 10)))
                                or solo
                                or (inInstance and #tanks > 0 and getDistance(tanks[1].unit) >= 90)
                                --need to add, or if tank is dead
                        ) or not isChecked("Safe Dots") then

                    if debuff.sunfire.count() < getOptionValue("Max Sunfire Targets") and cast.able.sunfire(thisUnit) and debuff.sunfire.refresh(thisUnit) then
                        if cast.sunfire(thisUnit) then
                            return true
                        end
                    end

                    if (debuff.moonfire.count() < getOptionValue("Max Moonfire Targets") or isBoss(thisUnit)) and ttd(thisUnit) > 5 then
                        if cast.able.moonfire() then
                            if not debuff.moonfire.exists(thisUnit) then
                                if cast.moonfire(thisUnit) then
                                    br.addonDebug("Initial Moonfire")
                                    return true
                                end
                            elseif debuff.moonfire.exists(thisUnit) and debuff.moonfire.remain(thisUnit) < 6 and ttd(thisUnit) > 5 then
                                if cast.moonfire(thisUnit) then
                                    br.addonDebug("Refreshing moonfire - remain: " .. round(debuff.moonfire.remain(thisUnit), 3))
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end

        if isChecked("Heart of the Wild") and buff.moonkinForm.exists() and talent.heartOfTheWild and cast.able.heartOfTheWild() then
            if cast.heartOfTheWild() then
                return true
            end
        end

        --covenant here

        if useCDs() and cast.able.convokeTheSpirits()
                and (getOptionValue("Convoke Spirits") == 1 or getOptionValue("Convoke Spirits") == 3)
                and getTTD("target") > 10
                and (buff.heartOfTheWild.exists() or cd.heartOfTheWild.remains() > 30 or not talent.heartOfTheWild or not isChecked("Heart of the Wild")) then
            if cast.convokeTheSpirits() then
                return true
            end
        end


        --eclipse

        --[[7	69.05	moonfire,target_if=refreshable
        --8	27.90	sunfire,target_if=refreshable


        --0.00	heart_of_the_wild
        --0.00	convoke_the_spirits,if=buff.eclipse_solar.up
        --9	22.86	starsurge
        --A	66.20	wrath,if=buff.eclipse_solar.up|eclipse.lunar_next
        --B	39.13	starfire]]

        if cast.able.starsurge(units.dyn45) and eclipse_in then
            if cast.starsurge(units.dyn45) then
                return true
            end
        end

        if buff.eclipse_solar.exists() then
            eclipse_next = "lunar"
        end
        if buff.eclipse_lunar.exists() then
            eclipse_next = "solar"
        end

        -- Print("Next Eclipse should be: " .. eclipse_next)

        if is_aoe then
            -- AOE
            if cast.able.wrath()
                    and not eclipse_in and (eclipse_next == "lunar" or eclipse_next == "any" and is_aoe)
                    or buff.eclipse_solar.exists()
            then
                if cast.wrath(units.dyn45) then
                    return true
                end
            end
            if cast.able.starfire() then
                if cast.starfire(getBiggestUnitCluster(45, 8)) then
                    return true
                end
            end
        else
            -- ST
            if cast.able.starfire() then
                if buff.eclipse_lunar.exists()
                        or (not eclipse_in and eclipse_next == "solar")
                        or (not eclipse_in and eclipse_next == "any")
                then
                    if cast.starfire(getBiggestUnitCluster(45, 8)) then
                        return true
                    end
                end
            end
        end

        --wrath fall back
        if cast.able.wrath(units.dyn45) then
            if cast.wrath(units.dyn45) then
                return true
            end
        end

        if SpecificToggle("Owl Key") and not GetCurrentKeyBoardFocus()
                and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
                and isChecked("Break form for dots") and (not debuff.moonfire.exists("target") or not debuff.sunfire.exists("target")) or not isChecked("Break form for dots")
        then
            return
        end

    end

    local function BossEncounterCase()

        local burst = false
        local crit_count = 0
        --Bursting
        --Print("Check" ..isChecked("Bursting").."#: "..getOptionValue("Bursting"))
        if isChecked("Bursting") and inInstance and #tanks > 0 then
            local ourtank = tanks[1].unit
            local Burststack = getDebuffStacks(ourtank, 240443)
            if Burststack >= getOptionValue("Bursting") then
                burst = true
            else
                burst = false
            end
        end
        if burst == false then
            for i = 1, #br.friend do
                if UnitInRange(br.friend[i].unit) and br.friend[i].hp <= getValue("Critical HP") then
                    crit_count = crit_count + 1
                end
                if crit_count >= getOptionValue("Bursting") then
                    burst = true
                end
            end
        end

        --cw on ourself to survive bursting
        if burst == true and cast.able.cenarionWard() and (getDebuffStacks("player", 240443) > 1 or php <= getValue("Critical HP") or getDebuffStacks("player", 240559) > 2) then
            if cast.able.cenarionWard() then
                if cast.cenarionWard("player") then
                    br.addonDebug("[BURST]: CW on self")
                    return true
                end
            end
        end

        if cast.able.cenarionWard() and php <= getValue("Critical HP") or getDebuffStacks("player", 240559) > 2 then
            if cast.able.cenarionWard() then
                if cast.cenarionWard("player") then
                    br.addonDebug("[CRIT]: CW on self")
                    return true
                end
            end
        end

        if mode.hEALS == 1 then
            --critical
            if isChecked("Critical HP") and lowest.hp <= getOptionValue("Critical HP") then

                if isChecked("Natures Swiftness") and cast.able.naturesSwiftness() then
                    if cast.naturesSwiftness() then
                        br.addonDebug("[CRIT] Natures Swiftness")
                    end
                end
                if cast.able.cenarionWard(lowest.unit) then
                    if cast.cenarionWard(lowest.unit) then
                        br.addonDebug("[CRIT]CWard on: " .. UnitName(lowest.unit))
                        return true
                    end
                end
                if cast.able.swiftmend(lowest.unit) and count_hots(lowest.unit) > 0 then
                    if cast.swiftmend(lowest.unit) then
                        br.addonDebug("[CRIT]Swiftmend on: " .. UnitName(lowest.unit))
                        return true
                    end
                end
                if covenant.nightFae.active and cast.able.convokeTheSpirits() and (getOptionValue("Convoke Spirits") == 2 or getOptionValue("Convoke Spirits") == 3) then
                    if cast.convokeTheSpirits() then
                        br.addonDebug("[CRIT] Convoke The Spirits!")
                        return true
                    end
                end
                if talent.germination and not buff.rejuvenationGermination.exists(lowest.unit) then
                    if cast.rejuvenation(lowest.unit) then
                        br.addonDebug("[CRIT]Germination on: " .. UnitName(lowest.unit))
                        return true
                    end
                elseif not talent.germination and not buff.rejuvenation.exists(lowest.unit) then
                    if cast.rejuvenation(lowest.unit) then
                        br.addonDebug("[CRIT]Rejuvenation on: " .. UnitName(lowest.unit))
                        return true
                    end
                end

                if talent.nourish and cast.able.nourish() and count_hots(lowest.unit) > getValue("Nourish - hot count") then
                    if cast.nourish(lowest.unit) then
                        br.addonDebug("[CRIT]nourish on: " .. UnitName(lowest.unit))
                        return true
                    end
                end
                if cast.able.regrowth(lowest.unit) then
                    if cast.regrowth(lowest.unit) then
                        br.addonDebug("[CRIT]Regrowth on: " .. UnitName(lowest.unit))
                        return true
                    end
                end
            end
        end

        -- aggressive dots
        if isChecked("Aggressive Dots") and mode.dPS == 1 and lowest.hp > getValue("DPS Min % health") and not noDamageCheck("target") and burst == false then
            thisUnit = "target"
            if isChecked("Safe Dots") and not noDamageCheck(thisUnit) and
                    ((inInstance and #tanks > 0 and getDistance(thisUnit, tanks[1].unit) <= 10)
                            or (inInstance and #tanks == 0)
                            or (inRaid and #tanks > 1 and (getDistance(thisUnit, tanks[1].unit) <= 10 or (getDistance(thisUnit, tanks[2].unit) <= 10)))
                            or solo
                            or (inInstance and #tanks > 0 and getDistance(tanks[1].unit) >= 90)
                            --need to add, or if tank is dead
                    ) or (not isChecked("Safe Dots") or #tanks == 0) then
                if not debuff.sunfire.exists("target") then
                    if cast.sunfire("target", "aoe", 1, sunfire_radius) then
                        br.addonDebug("Aggressive  Sunfire - target")
                        return true
                    end
                end
                if not debuff.moonfire.exists("target") then
                    if cast.moonfire("target") then
                        br.addonDebug("Aggressive Moonfire - target")
                        return true
                    end
                end
            end
        end

        --Smart Stuff
        if 1 == 2 then
            if isSelected("Smart Charge") or isChecked("Smart Hot") then

                local countSmart = #enemies.yards40
                local smarthottargets = getValue("Smart Hot")
                if smarthottargets < #enemies.yards40 then
                    countSmart = smarthottargets
                end

                local spellTarget = nil
                local furthers_friend
                local furthest_distance = 0

                if someone_casting and mode.hEALS == 1 then
                    for i = 1, countSmart do
                        local thisUnit = enemies.yards40[i]
                        local _, _, _, _, endCast, _, _, _, spellcastID = UnitCastingInfo(thisUnit)
                        spellTarget = select(3, UnitCastID(thisUnit))

                        --[[
                        --wild charge stuff  - not working, needs more testing
                        if talent.wildCharge and cast.able.wildCharge() and spellTarget == "player" then
                            -- find furthest friend in range
                            if isSelected("Smart Charge") then
                                if #friends > 1 then
                                    for i = 1, #friends do
                                        if getDistance(friends[i].unit) > furthest_distance then
                                            furthest_distance = getDistance(friends[i].unit)
                                            furthers_friend = friends[i].unit
                                        end
                                    end
                                    if spellTarget ~= nil and endCast
                                            and (spellcastID == 253239 or spellcastID == 268932)
                                            and ((endCast / 1000) - GetTime()) < 1
                                            and GetShapeshiftForm() == 0 then
                                        if cast.wildCharge(furthers_friend) then
                                            br.addonDebug("[CHARGE] to " .. UnitName(furthers_friend))
                                            return true
                                        end
                                    end
                                end
                            end
                        end
        ]]
                        if isChecked("Smart Hot") then
                            --        if someone_casting then
                            if spellTarget ~= nil and endCast and pre_hot_list[spellcastID] and ((endCast / 1000) - GetTime()) < 1 then
                                if cast.able.cenarionWard() then
                                    if cast.cenarionWard(spellTarget) then
                                        br.addonDebug("[Snipe]CW on: " .. UnitName(spellTarget))
                                        return true
                                    end
                                end
                                if talent.germination and not buff.rejuvenationGermination.exists(spellTarget) then
                                    if cast.rejuvenation(spellTarget) then
                                        br.addonDebug("[Snipe]Germination on: " .. UnitName(spellTarget))
                                        return true
                                    end
                                elseif not talent.germination and not buff.rejuvenation.exists(spellTarget) then
                                    if cast.rejuvenation(spellTarget) then
                                        br.addonDebug("[Snipe]Rejuvenation on: " .. UnitName(spellTarget))
                                        return true
                                    end
                                end
                                if isSelected("Use Bark w/Smart Hot") and getHP(spellTarget) < getValue("Use Bark w/Smart Hot") then
                                    if cast.ironbark(spellTarget) then
                                        br.addonDebug("[Snipe]Bark on: " .. UnitName(spellTarget))
                                        return true
                                    end
                                end
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
                                        br.addonDebug("[DEBUFF]Germination on: " .. UnitName(br.friend[i].unit))
                                        return true
                                    end
                                elseif not buff.rejuvenation.exists(br.friend[i].unit) then
                                    if cast.rejuvenation(br.friend[i].unit) then
                                        br.addonDebug("[DEBUFF]Rejuv on: " .. UnitName(br.friend[i].unit))
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

                    -- Innervate
                    if (time_remain < precast_time + 2 and time_remain < precast_time + 4) then
                        if cast.able.innervate and not buff.innervate.exists("player") then
                            if cast.innervate() then
                                br.addonDebug("[PRE-HOT] Innervate - pre-pre-hot")
                                return true
                            end
                        end
                    end

                    -- wildGrowth
                    if time_remain < precast_time - 2 then
                        if cast.able.wildGrowth then
                            if cast.wildGrowth("player") then
                                br.addonDebug("[PRE-HOT] Wildgrowth")
                                return true
                            end
                        end
                    end

                    if time_remain < precast_time then
                        for j = 1, #br.friend do
                            if UnitInRange(br.friend[j].unit) then
                                if not buff.rejuvenation.exists(br.friend[j].unit) then
                                    if cast.rejuvenation(br.friend[j].unit) then
                                        br.addonDebug("[PRE-HOT]Rejuv on: " .. UnitName(br.friend[j].unit) .. " because: " .. spell_name)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        local heal_target = "none"
        using_lifebloom = false
        local seth_routine

        if 1 == 2 then
            -- Waycrest Manor
            if inInstance and inCombat and select(8, GetInstanceInfo()) == 1862 then
                for i = 1, #br.friend do
                    if getDebuffRemain(br.friend[i].unit, 260741) ~= 0 --Jagged Nettles
                            and br.friend[i].hp < 95 then
                        heal_target = br.friend[i].unit
                    end
                end
            end

            --Kings Rest
            if inInstance and inCombat and select(8, GetInstanceInfo()) == 1762 then
                for i = 1, #br.friend do
                    if getDebuffRemain(br.friend[i].unit, 267626) ~= 0 -- Dessication
                            or getDebuffRemain(br.friend[i].unit, 267618) ~= 0 -- Drain Fluids
                            or getDebuffRemain(br.friend[i].unit, 266231) ~= 0 -- Severing axe from axe lady in council
                            or getDebuffRemain(br.friend[i].unit, 272388) ~= 0 -- shadow barrage
                            or getDebuffRemain(br.friend[i].unit, 265773) > 1 -- spit-gold
                            or (getDebuffRemain(br.friend[i].unit, 270487) ~= 0 and getDebuffStacks(br.friend[i].unit, 270487) > 1) -- severing-blade
                            and br.friend[i].hp < 95 then
                        heal_target = br.friend[i].unit
                    end
                end
            end

            -- Sacrifical Pits/ Devour
            if inInstance and inCombat and select(8, GetInstanceInfo()) == 1763 then
                for i = 1, #br.friend do
                    if (getDebuffRemain(br.friend[i].unit, 255421) or getDebuffRemain(br.friend[i].unit, 255434)) ~= 0 and br.friend[i].hp <= 90 then
                        heal_target = br.friend[i].unit
                    end
                end
            end

            if heal_target ~= "none" then
                if talent.germination and not buff.rejuvenationGermination.exists(heal_target) then
                    if cast.rejuvenation(heal_target) then
                        br.addonDebug("[BOSS]Germination on: " .. UnitName(heal_target))
                        return true
                    end
                elseif not talent.germination and not buff.rejuvenation.exists(heal_target) then
                    if cast.rejuvenation(heal_target) then
                        br.addonDebug("[CRIT]Rejuvenation on: " .. UnitName(heal_target))
                        return true
                    end
                end
                if not seth_routine then
                    if cast.able.ironbark() then
                        if cast.ironbark(heal_target) then
                            br.addonDebug("[BOSS]Bark on: " .. UnitName(heal_target))
                            return true
                        end
                    end
                    if cast.able.cenarionWard() then
                        if cast.cenarionWard(heal_target) then
                            br.addonDebug("[BOSS]CWard on: " .. UnitName(heal_target))
                            return true
                        end
                    end
                end
                if cast.able.lifebloom() and (not buff.lifebloom.exists(heal_target) or buff.lifebloom.remains(heal_target) < 2) then
                    if cast.lifebloom(heal_target) then
                        using_lifebloom = true
                        br.addonDebug("[BOSS]Bloom on: " .. UnitName(heal_target))
                        return true
                    end
                end
                if cast.able.swiftmend() and count_hots(heal_target) > 0 and (getHP(heal_target) < 80 or (seth_routine and getHP(heal_target) < 95)) then
                    if cast.swiftmend(heal_target) then
                        br.addonDebug("[BOSS]Swiftmend on: " .. UnitName(heal_target))
                        return true
                    end
                end
                if talent.nourish and cast.able.nourish() and count_hots(heal_target) >= getOptionCheck("Nourish - hot count") then
                    if cast.nourish(heal_target) then
                        br.addonDebug("[BOSS]nourish on: " .. UnitName(heal_target))
                        return true
                    end
                end
                if cast.able.regrowth() and (getHP(heal_target) < 80 or (seth_routine and getHP(heal_target) < 98)) then
                    if cast.regrowth(heal_target) then
                        br.addonDebug("[BOSS]Regrowth on: " .. UnitName(heal_target))
                        return true
                    end
                end
            end
        end
    end


    -- Action List - Extras
    local function auto_forms()
        if mode.forms == 1 then
            local standingTime = 0
            if DontMoveStartTime then
                standingTime = GetTime() - DontMoveStartTime
            end            --     local moveTimer = player.movingTime()
            --     Print(tostring(moveTimer))

            --and br.timer:useTimer("debugShapeshift", 0.25) then
            -- Flight Form
            if not inCombat and canFly() and not swimming and (br.fallDist > 90 or 1 == 1) and level >= 24 and not buff.prowl.exists() then
                if GetShapeshiftForm() ~= 0 and not buff.travelForm.exists() then
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
                end
            end
            -- Travel Form
            if not inCombat and not swimming and level >= 24 and not buff.prowl.exists() and not travel and not IsIndoors() and IsMovingTime(1) then
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
                if (not canFly() or inCombat or level < 24) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then
                    --falling > getOptionValue("Fall Timer") then
                    if cast.catForm("player") then
                        return true
                    end
                end
            end
        end -- End Shapeshift Form Management
        -- Revive
        if isChecked("Revive") and not cast.last.revive(1) then
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
            -- Barkskin
            if isChecked("Barkskin") and cast.able.barkskin() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    local _, _, _, startCast, endCast, _, _, _, spellcastID = UnitCastingInfo(thisUnit)

                    if php <= getOptionValue("Barkskin")
                            or UnitDebuffID("player", 265773) -- spit-gold from KR
                            or UnitDebuffID("player", 302420) and thisUnit == 155433 and getCastTimeRemain(thisUnit) < 4   -- 302420
                    then
                        if cast.barkskin() then
                            return
                        end
                    end
                end
            end
            -- Pot/Stoned
            if isChecked("Potion/Healthstone") and php <= getValue("Potion/Healthstone") then
                if inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                    if canUseItem(5512) then
                        br.addonDebug("Using Healthstone")
                        useItem(5512)
                    elseif hasItem(156634) and canUseItem(156634) then
                        br.addonDebug("Using Silas' Vial of Continuous Curing")
                        useItem(156634)
                    elseif hasItem(166799) and canUseItem(166799) then
                        br.addonDebug("Using Emerald of Vigor")
                        useItem(166799)
                    elseif hasItem(169451) and canUseItem(169451) then
                        br.addonDebug("Using Health Pot")
                        useItem(169451)
                    end
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

            if isChecked("Rebirth") and not moving and inCombat then
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
            if (isChecked("Typhoon") and talent.typhoon and cast.able.typhoon()) or (isChecked("Mighty Bash") and talent.mightyBash and cast.able.mightyBash()) then
                for i = 1, #enemies.yards15 do
                    local thisUnit = enemies.yards15[i]
                    if cast.able.mightyBash() and isCrowdControlCandidates(thisUnit) and not getUnitID(thisUnit) == 130488
                            and not already_stunned(thisUnit)
                            and GetUnitExists(thisUnit) and getBuffRemain(thisUnit, 226510) == 0 and distance <= 5 then
                        if cast.mightyBash(thisUnit) then
                            --Print("Stun")
                            return true
                        end
                    end
                    if canInterrupt(thisUnit, getOptionValue("InterruptAt")) then
                        -- Typhoon
                        if isChecked("Typhoon") and talent.typhoon and getFacing("player", thisUnit) then
                            if cast.typhoon() then
                                return
                            end
                        end
                        -- Mighty Bash
                        if isChecked("Mighty Bash") and talent.mightyBash and getDistance(thisUnit, "player") <= 8
                                and getBuffRemain(thisUnit, 226510) == 0 and StunsBlackList[GetObjectID(thisUnit)] == nil
                                and (thisUnit == 130488 and isChecked("Motherload - Stun jockeys") or thisUnit ~= 130488) then
                            if cast.mightyBash(thisUnit) then
                                --Print("Stun")
                                return true
                            end
                        end
                    end
                end
            end
        end


        -- hibernate  as interrupt
        if isChecked("Hibernate as Interrupt") and cast.able.hibernate() then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                --canInterrupt(thisUnit, 99)
                if UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] and getCastTimeRemain(thisUnit) > getCastTime(spell.hibernate) and StunsBlackList[GetObjectID(thisUnit)] == nil and not isBoss(thisUnit) then
                    --and UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923)
                    --and UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] then
                    if cast.hibernate(thisUnit) then
                        return true
                    end
                end
            end
        end
    end

    local function Cooldowns()

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

        -- Ghetto Flourish Support
        if talent.flourish and isChecked("Flourish") and inCombat and talent.flourish and buff.wildGrowth.exists() then
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
                elseif getOptionValue("Trinket 2 Mode") == 5 then
                    -- Generic fallback
                    if Trinket13 ~= 168905 and Trinket13 ~= 167555 then
                        if canUseItem(13) then
                            useItem(13)
                        end
                    end
                    if Trinket14 ~= 168905 and Trinket14 ~= 167555 then
                        if canUseItem(14) then
                            useItem(14)
                        end
                    end
                end
            end

            -- Mana Potion
            if isChecked("Mana Potion") and mana <= getValue("Mana Potion") then
                if hasItem(152495) and canUseItem(152495) then
                    useItem(152495)
                end
                if hasItem(127835) and canUseItem(127835) then
                    useItem(127835)
                end
            end

            if isChecked("Auto use Pots") and burst == true then
                -- print("foo") 169300
                if hasItem(169300) and canUseItem(169300) then
                    useItem(169300)
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
        if not owl and talent.balanceAffinity then
            clearForm()
        end

        --dots


        local debuffsunfirecount = debuff.sunfire.count()  -- < getOptionValue("Max Sunfire Targets")
        local debuffmoonfirecount = debuff.moonfire.count()

        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if not noDamageCheck(thisUnit) then
                if isChecked("Safe Dots") and
                        ((inInstance and #tanks > 0 and getDistance(thisUnit, tanks[1].unit) <= 10)
                                or (inInstance and #tanks == 0)
                                or (inRaid and #tanks > 1 and (getDistance(thisUnit, tanks[1].unit) <= 10 or (getDistance(thisUnit, tanks[2].unit) <= 10)))
                                or solo
                                or (inInstance and #tanks > 0 and getDistance(tanks[1].unit) >= 90)
                                --need to add, or if tank is dead
                        ) or not isChecked("Safe Dots") then
                    if cast.able.sunfire() then
                        if debuff.sunfire.count() == 0 then
                            if cast.sunfire(getBiggestUnitCluster(40, sunfire_radius), "aoe", 1, sunfire_radius) then
                                br.addonDebug("Initial Sunfire - Cluster")
                                return true
                            end
                        end
                        if (debuffsunfirecount < getOptionValue("Max Sunfire Targets") or isBoss(thisUnit)) and ttd(thisUnit) > 5 then
                            if not debuff.sunfire.exists(thisUnit) then
                                if cast.sunfire(thisUnit, "aoe", 1, sunfire_radius) then
                                    br.addonDebug("Initial Sunfire - non-Cluster")
                                    return true
                                end
                            elseif debuff.sunfire.exists(thisUnit) and debuff.sunfire.remain(thisUnit) < 5 and ttd(thisUnit) > 5 then
                                if cast.sunfire(thisUnit, "aoe", 1, sunfire_radius) then
                                    br.addonDebug("Refreshing sunfire - remain: " .. round(debuff.sunfire.remain(thisUnit), 3))
                                    return true
                                end
                            end
                        end
                    end

                    if (debuffmoonfirecount < getOptionValue("Max Moonfire Targets") or isBoss(thisUnit)) and ttd(thisUnit) > 5 then
                        if cast.able.moonfire() then
                            if not debuff.moonfire.exists(thisUnit) then
                                if cast.moonfire(thisUnit) then
                                    br.addonDebug("Initial Moonfire")
                                    return true
                                end
                            elseif debuff.moonfire.exists(thisUnit) and debuff.moonfire.remain(thisUnit) < 6 and ttd(thisUnit) > 5 then
                                if cast.moonfire(thisUnit) then
                                    br.addonDebug("Refreshing moonfire - remain: " .. round(debuff.moonfire.remain(thisUnit), 3))
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end


        -- balance affinity here
        if talent.balanceAffinity and lowest.hp > getOptionValue("Critical HP") and mode.forms == 1 then
            if owl_combat() then
                return true
            end
        end

        if owl and #enemies.yards40 > 2 and cast.able.starfire() then
            if cast.starfire(getBiggestUnitCluster(45, 8)) then
                return true
            end
        end
        --wrath fall back
        if cast.able.wrath() then
            if cast.wrath(units.dyn45) then
                return true
            end
        end


    end -- End Action List - DPS


    -----------------------------
    --- In Combat - Rotations ---
    -----------------------------

    function round(num, numDecimalPlaces)
        local mult = 10 ^ (numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

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
        --cat_dps

        if Interrupts() then
            return true
        end

        --aoe_count
        local aoe_count = 0
        for i = 1, #enemies.yards10tnc do
            local thisUnit = enemies.yards10tnc[i]
            if ttd(thisUnit) > 4 and not isExplosive(thisUnit) then
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

        --pocket size computing device
        if isChecked("Trinket 1") and canUseItem(13) and getOptionValue("Trinket 1 Mode") == 4
                or isChecked("Trinket 2") and canUseItem(14) and getOptionValue("Trinket 2 Mode") == 4 then
            local Trinket13 = GetInventoryItemID("player", 13)
            local Trinket14 = GetInventoryItemID("player", 14)
            if (Trinket13 == 167555 or Trinket14 == 167555) and lowest.hp >= 60
                    and ttd("target") > 10 and not isMoving("player") and not noDamageCheck("target") and not buff.innervate.exists("player") and burst == false then
                if canUseItem(167555) then
                    br.player.use.pocketSizedComputationDevice()
                end
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

            -- rip,target_if=refreshable&combo_points=5
            --   if combo == 5 then
            if debuff.rip.count() < getOptionValue("Max RIP Targets") and not isExplosive(thisUnit) then
                if (not debuff.rip.exists(thisUnit) or (debuff.rip.remain(thisUnit) < 4) and (ttd(thisUnit) > (debuff.rip.remain(thisUnit) + 24)
                        or (debuff.rip.remain(thisUnit) + combo * 4 < ttd(thisUnit) and debuff.rip.remain(thisUnit) + 4 + combo * 4 > ttd(thisUnit))))
                then
                    if cast.rip(thisUnit) then
                        br.addonDebug("[CAT-DPS] Applying Rip")
                        return true
                    end
                end
            end

            -- Rake
            if cast.able.rake() and (not debuff.rake.exists(thisUnit) or debuff.rake.remain(thisUnit) < 4.5) and ttd(thisUnit) >= 10
                    and (combo < 5 or debuff.rake.remain(thisUnit) < 1) and aoe_count < 4 and not isExplosive(thisUnit) then
                if cast.rake(thisUnit) then
                    br.addonDebug("[CAT-DPS] Raking")
                    return true
                end
            end

            -- Ferocious Bite
            --ferocious_bite,if=(combo_points>3&target.time_to_die<3)|(combo_points=5&energy>=50&dot.rip.remains>14)&spell_targets.swipe_cat<5
            if cast.able.ferociousBite() and cat and combo > 3 and ttd(thisUnit) < 3 or (combo == 5 and br.player.power.energy.amount() >= 40 and (debuff.rip.remain(thisUnit) > 8 or not cast.able.rip()))
                    and #enemies.yards8 < 5 and not noDamageCheck(thisUnit) then
                if cast.ferociousBite(thisUnit)
                then
                    br.addonDebug("[CAT-DPS] Bite: " .. UnitName(thisUnit) .. " Combo points: " .. combo .. " ttd: " .. ttd(thisUnit))
                    return true
                end
            end

            if combo < 5 then
                --swipe_cat,if=spell_targets.swipe_cat>=6
                if cast.able.swipeCat() then
                    if #enemies.yards8 >= 6 then
                        if cast.swipeCat() then
                            br.addonDebug("[CAT-DPS] Swipe - aoe: " .. aoe_count)
                            return true
                        end
                    end
                    --swipe_cat,if=spell_targets.swipe_cat>=2
                    if aoe_count >= 2 then
                        if cast.swipeCat() then
                            br.addonDebug("[CAT-DPS] Multiple targets - swiping")
                            return true
                        end
                    end
                end
                if cast.able.shred() then
                    if cast.shred(thisUnit) then
                        br.addonDebug("[CAT-DPS] Shred")
                        return true
                    end
                end
            end
        end

        if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus()
                and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
                and isChecked("Break form for dots") and (not debuff.moonfire.exists("target") or not debuff.sunfire.exists("target")) or not isChecked("Break form for dots")
        then
            return
        end
    end -- end cat loop

    local function cleanse()
        -- clearForm()

        -- Soothe
        if isChecked("Auto Soothe") and cast.able.soothe() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if canDispel(thisUnit, spell.soothe) and ttd(thisUnit) > getValue("Auto Soothe") then
                    if cast.soothe(thisUnit) then
                        return true
                    end
                end
            end
        end
        -- Nature's Cure / Cleanse
        --        local _, _, _, _, endCast, _, _, _, spellcastID = UnitCastingInfo(enemies.yards40[1])
        if #enemies.yards40 > 0 then
            spellTarget = select(3, UnitCastID(enemies.yards40[1]))
        end
        if mode.decurse == 1 and cast.able.naturesCure() and not cast.last.naturesCure() then
            for i = 1, #br.friend do
                if canDispel(br.friend[i].unit, spell.naturesCure) and getLineOfSight(br.friend[i].unit) and getDistance(br.friend[i].unit) <= 40
                        and (getDebuffStacks(br.friend[i].unit, 240443) == 0 or getDebuffStacks("player", 240443) >= getOptionValue("Bursting")) --https://www.wowhead.com/spell=240443/burst
                        and (getDebuffStacks(br.friend[i].unit, 319603) == 0 or getDebuffStacks(br.friend[i].unit, 319603) ~= 0 and isCasting(319592, enemies.yards40[1]) and GetUnitIsUnit(spellTarget, br.friend[i].unit))
                then
                    if cast.naturesCure(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end -- end cleanse

    local function isCC(unit)
        if getOptionCheck("Don't break CCs") then
            return isLongTimeCCed(Unit)
        end
    end

    local function root_cc()

        if talent.mightyBash and cast.able.mightyBash() then
            for i = 1, #enemies.yards10tnc do
                local thisUnit = enemies.yards10tnc[i]
                if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) > 1 and UnitAffectingCombat(thisUnit) then
                    if cast.mightyBash(thisUnit) then
                        return true
                    end
                end
            end
        end

        local radar = "off"

        --Building root list
        local root_UnitList = {}
        if isChecked("Mist - Spirit vulpin") then
            root_UnitList[165251] = "Spirit vulpin"
            radar = "on"
        end
        if isChecked("Plague - Globgrod") then
            root_UnitList[171887] = "Globgrod"
            radar = "on"
        end
        if isChecked("FH - root grenadier") then
            root_UnitList[129758] = "grenadier"
            radar = "on"
        end
        if isChecked("KR - root Spirit of Gold") then
            root_UnitList[131009] = "the thing from beyond"
            radar = "on"
        end
        if isChecked("KR - animated gold") then
            root_UnitList[135406] = "animated gold"
            radar = "on"
        end
        if debuff.thirstForBlood.exists() then
            root_UnitList[133835] = "feral-bloodswarmer"
            radar = "on"
        end

        if radar == "on" then

            local root = 339
            local root_range = 35
            if talent.massEntanglement and cast.able.massEntanglement() then
                root = 102359
                root_range = 30
            end

            if lowest.hp > 45 then
                for i = 1, GetObjectCountBR() do
                    local object = GetObjectWithIndex(i)
                    local ID = ObjectID(object)
                    if root_UnitList[ID] ~= nil and getBuffRemain(object, 226510) == 0 and getHP(object) > 90 and not isCC(object) and not already_stunned(object) and (getBuffRemain(object, 102359) < 2 or getBuffRemain(object, 339) < 2) then
                        local x1, y1, z1 = ObjectPosition("player")
                        local x2, y2, z2 = ObjectPosition(object)
                        local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                        if talent.mightyBash and cast.able.mightyBash() then
                            if not debuff.mightyBash.exists(object) then
                                if root == 339 and distance <= 8 then
                                    root = 5211
                                    root_range = 8
                                    --CastSpellByName("Mighty Bash", object)
                                end
                            end
                        end
                        if root == 339 and UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] then
                            -- Using hibernate as root if we can
                            root = 2637
                            root_range = 30
                        end
                        if distance < root_range and not isLongTimeCCed(object) then
                            br.addonDebug("Root: " .. tostring(root) .. " target:" .. UnitName(object) .. " Distance: " .. tostring(distance))
                            CastSpellByName(GetSpellInfo(root), object)
                        end
                    end
                end
            end -- end root
        end -- end radar
    end -- end cc_root


    local function heal()

        --checking for HE
        if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and br.timer:useTimer("Error delay", 3.5) then
            Print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
            return
        end

        if mode.hEALS == 1 then

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

            if isChecked("Swiftmend") and cast.able.swiftmend() and count_hots(lowest.unit) > 0
                    and (lowest.hp <= getValue("Swiftmend") or (talent.soulOfTheForest and burst == true and not buff.soulOfTheForest.exists()))
                    and (not inInstance or (inInstance and getDebuffStacks(lowest.unit, 209858) < getValue("Necrotic Rot"))) then
                if cast.swiftmend(lowest.unit) then
                    return true
                end
            end

            -- Wild Growth
            if isChecked("Wild Growth") and cast.able.wildGrowth() and not moving then
                local lowHealthCandidates = getUnitsToHealAround("player", 30, getValue("Wild Growth"), getValue("Wild Growth Targets"))
                --[[      if not freemana or not buff.soulOfTheForest.exists() then
                          for i = 1, #br.friend do
                              if UnitInRange(br.friend[i].unit) then
                                  lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Wild Growth"), #br.friend)
                                  --local lowHealthCandidates2 = getUnitsToHealAround(br.friend[i].unit, 30, getValue("Soul of the Forest + Wild Growth"), #br.friend)
                              end
                          end
                      end
                  ]]
                if (#lowHealthCandidates >= getValue("Wild Growth Targets") or freemana or buff.soulOfTheForest.exists()) then
                    if cast.wildGrowth(lowest.unit) then
                        return true
                    end
                end
            end

            if talent.nourish and cast.able.nourish() and count_hots(lowest.unit) >= getValue("Nourish - hot count") then
                if cast.nourish(lowest.unit) then
                    br.addonDebug("[HEAL]nourish on: " .. UnitName(lowest.unit))
                    return true
                end
            end





            --lifebloom
            local lifebloom_count = 0
            local raid_bloom_target = "none"
            local kill_boss
            local bloom_count_max = 0

            if inCombat and isChecked("Lifebloom") and lastSpell ~= spell.lifebloom then
                if using_lifebloom then
                    br.addonDebug("Lifebloom in use for boss mechanics - skipping")
                    return true
                else
                    if runeforge.theDarkTitansLesson.equiped then
                        if not buff.lifebloom.exists("player") then
                            -- or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5) then
                            if cast.lifebloom("player") then
                                br.addonDebug("[BLOOM][DT] Lifebloom on player")
                                return true
                            end
                        end
                    end
                    --  if inRaid then
                    -- raid lifebloom logic
                    -- if talent.photosynthesis then
                    --bloom on tanking tank here
                    -- keep it on focus
                    if UnitExists("focus") and not UnitIsDeadOrGhost("focus")
                            and UnitAffectingCombat("focustarget") and hasThreat("focus") and getLineOfSight("focus", "player") then
                        raid_bloom_target = "focus"
                    end
                    if #br.friend > 1 then
                        if #br.friend > 10 then
                            bloom_count_max = 10
                        else
                            bloom_count_max = #br.friend
                        end
                        if not runeforge.theDarkTitansLesson.equiped and talent.photosynthesis and raid_bloom_target == "none" then
                            for i = 1, bloom_count_max do
                                if UnitInRange(br.friend[i].unit) and br.friend[i].hp <= getValue("Photosynthesis") then
                                    lifebloom_count = lifebloom_count + 1
                                end
                            end
                            if (lifebloom_count >= getValue("Photosynthesis Count") or bursting) and (not buff.lifebloom.exists("Player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5 and php < 80)) then
                                raid_bloom_target = "player"
                                br.addonDebug("Lifebloom on healer(photo) - [" .. lifebloom_count .. "/" .. getValue("Photosynthesis Count") .. "]")
                            else
                                raid_bloom_target = "tank"
                                br.addonDebug("Lifebloom on tank(photo)- [" .. lifebloom_count .. "/" .. getValue("Photosynthesis Count") .. "]")
                            end
                        end

                        if GetTime() - x > getValue("Lifebloom") and raid_bloom_target == "none" or raid_bloom_target == "tank" then
                            tanks = getTanksTable()
                            if #tanks > 0 then
                                for i = 1, #tanks do
                                    --if not focus, check critical health on tanks
                                    if isChecked("Critical HP") and getHP(tanks[i].unit) < getValue("Critical HP") then
                                        raid_bloom_target = tanks[i].unit
                                        break
                                    else
                                        --stick it on the tank that has aggro
                                        if UnitExists("boss1target") then
                                            kill_boss = "boss1target"
                                        elseif UnitExists("boss2target") then
                                            kill_boss = "boss2target"
                                        end
                                        if kill_boss and cast.able.lifebloom(tanks[i].unit) and UnitThreatSituation(tanks[i].unit, kill_boss) ~= nil and UnitThreatSituation(tanks[i].unit, kill_boss) > 2 and getLineOfSight("player", tanks[i].unit) then
                                            raid_bloom_target = tanks[i].unit
                                            break
                                        else
                                            raid_bloom_target = tanks[1].unit
                                        end
                                    end
                                end

                            else
                                raid_bloom_target = "player"
                                --     Print(" ERROR - tanks: " .. tostring(#tanks))
                            end
                        end
                        -- cast bloom
                        if raid_bloom_target ~= "none" and getLineOfSight("player", raid_bloom_target)
                                and buff.lifebloom.remain(raid_bloom_target) < 4.5 then
                            --  (not buff.lifebloom.exists(raid_bloom_target) or (buff.lifebloom.exists(raid_bloom_target) and
                            if cast.lifebloom(raid_bloom_target) then
                                br.addonDebug("Bloom_target: " .. UnitName(raid_bloom_target))
                                raid_bloom_target = "none"
                                -- I want to set a timer here
                                x = GetTime()
                                --   Print(tostring(x))
                                return true
                            end
                        end
                    end
                end
            end
            if 1 == 2 then
                if not using_lifebloom then

                    if not inRaid then
                        if not talent.photosynthesis and not cast.last.lifebloom(1) and inInstance and inCombat and #tanks == 1 then
                            if not (buff.lifebloom.exists(tank)) or (buff.lifebloom.exists(tank) and buff.lifebloom.remain(tank) < 4.5 and tanks[1].hp < 80) then
                                if cast.lifebloom(tank) then
                                    br.addonDebug("Lifebloom on tank")
                                    return true
                                end
                            end
                        elseif talent.photosynthesis and not cast.last.lifebloom(1) and inInstance and not runeforge.theDarkTitansLesson.equiped then
                            for i = 1, #br.friend do
                                if UnitInRange(br.friend[i].unit) and br.friend[i].hp <= getValue("Photosynthesis") then
                                    lifebloom_count = lifebloom_count + 1
                                end
                            end
                            if (lifebloom_count >= getValue("Photosynthesis Count") or bursting) and (not buff.lifebloom.exists("Player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5 and php < 80)) then
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
                        elseif talent.photosynthesis and not cast.last.lifebloom(1) and (inRaid or #tanks > 1) and buff.lifebloom.remains() < 2 and not runeforge.theDarkTitansLesson.equiped then
                            if cast.lifebloom("player") then
                                br.addonDebug("Lifebloom on healer(photo) - [" .. lifebloom_count .. "/" .. getValue("Photosynthesis Count") .. "]")
                                return true
                            end
                        elseif talent.photosynthesis and not cast.last.lifebloom(1) and inInstance and runeforge.theDarkTitansLesson.equiped then
                            if not buff.lifebloom.exists(tank) or (buff.lifebloom.exists(tank) and buff.lifebloom.remain(tank) < 4.5) then
                                if cast.lifebloom(tank) then
                                    return true
                                end
                            end
                            if not buff.lifebloom.exists("player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5) then
                                if cast.lifebloom("player") then
                                    return true
                                end
                            end
                        end
                    else
                        --raid shit here
                        local raid_bloom_target = "none"
                        if runeforge.theDarkTitansLesson.equiped and
                                (not buff.lifebloom.exists("player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5)) then
                            if cast.lifebloom("player") then
                                return true
                            end
                        end
                        -- keep it on focus
                        if UnitExists("focustarget") and not UnitIsDeadOrGhost("focustarget")
                                and UnitAffectingCombat("focustarget") and hasThreat("focustarget") and getLineOfSight("focustarget", "player") then
                            raid_bloom_target = "focustarget"
                        end
                        if raid_bloom_target == "none" then
                            for i = 1, #tanks do
                                tank = tanks[i].unit
                                --if not focus, check critical health on tanks
                                if isChecked("Critical HP") and getHP(tank) < getValue("Critical HP") then
                                    raid_bloom_target = tank
                                    break
                                else
                                    --stick it on the tank that has aggro
                                    Print("Tell Laks this: " .. tostring(UnitThreatSituation(tank, "boss1target")))
                                    if cast.able.lifebloom(tank) and UnitThreatSituation(tank, "boss1target") ~= nil and UnitThreatSituation(tank, "boss1target") > 2 and getLineOfSight("player", tank) then
                                        raid_bloom_target = tank
                                        break
                                    end
                                end
                            end
                        end
                        if raid_bloom_target ~= "none" then
                            if (buff.lifebloom.remain(raid_bloom_target) < 4.5 or not buff.lifebloom.exists(raid_bloom_target)) then
                                if cast.lifebloom(raid_bloom_target) then
                                    return true
                                end
                            end
                        end
                    end
                else
                    br.addonDebug("Lifebloom in use for boss mechanics - skipping")
                    return true
                end
            end -- old shitty code

            if isChecked("Grievous Wounds") then
                for i = 1, #br.friend do
                    thisUnit = br.friend[i].unit
                    local hotCount = 0

                    if buff.lifebloom.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end
                    if buff.rejuvenation.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end
                    if buff.regrowth.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end
                    if buff.wildGrowth.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end
                    if buff.cenarionWard.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end
                    if buff.cultivat.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end
                    if buff.rejuvenationGermination.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end
                    if buff.groveTending.exists(thisUnit) then
                        hotCount = hotCount + 1
                    end

                    local hotvalue = getValue("Grievous Wounds")
                    local grievance_value = 90

                    if br.friend[i].hp < grievance_value - (hotCount * hotvalue) and UnitInRange(br.friend[i].unit) or GetUnitIsUnit(br.friend[i].unit, "player") then
                        --count grievance stacks here
                        local CurrentBleedstack = getDebuffStacks(br.friend[i].unit, 240559)
                        if getDebuffStacks(br.friend[i].unit, 240559) > 0 then
                            BleedFriendCount = BleedFriendCount + 1
                        end
                        if CurrentBleedstack > BleedStack then
                            BleedStack = CurrentBleedstack
                            BleedFriend = br.friend[i]
                            --br.addonDebug("Hotcount: " .. hotCount .. " Check: " .. (grievance_value - (hotCount * hotvalue)))
                            --debug stuff
                            --Print("Griev Debug Target: " .. BleedFriend.unit .. " Stacks: " ..CurrentBleedstack .. " HP: " .. BleedFriend.hp)
                        end
                    end
                    if isChecked("Decaying Mind") then
                        local CurrentBleedstack = getDebuffStacks(br.friend[i].unit, 278961)
                        if getDebuffStacks(br.friend[i].unit, 278961) > 0 then
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

                    --Efflorescence if more than 1 grievance
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
                end --multi grievance

                if talent.germination and not buff.rejuvenationGermination.exists(BleedFriend.unit) then
                    if cast.rejuvenation(BleedFriend.unit) then
                        return true
                    end
                elseif not talent.germination and not buff.rejuvenation.exists(BleedFriend.unit) then
                    if cast.rejuvenation(BleedFriend.unit) then
                        return true
                    end
                end
                if count_hots(BleedFriend.unit) > 0 then
                    if cast.swiftmend(BleedFriend.unit) then
                        return true
                    end
                end
                if cast.able.regrowth() then
                    if not buff.regrowth.exists(BleedFriend.unit) or BleedFriend.hp < getValue("Grievous") then
                        if cast.regrowth(BleedFriend.unit) then
                            return true
                        end
                    end
                end
            end -- end grievance

            -- cenarionWard
            if not isChecked("Smart Hot") and isChecked("Cenarion Ward") and talent.cenarionWard then
                for i = 1, #tanks do
                    tank = tanks[i].unit
                    if not buff.cenarionWard.exists(tank) and cast.able.cenarionWard(tank) and inCombat then
                        if cast.cenarionWard(tank) then
                            return true
                        end
                    end
                end
            end

            --
            --Efflorescence
            if isChecked("Efflorescence") and inCombat then
                if inInstance and talent.springBlossoms then
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
                elseif #br.friend > 1 then
                    if cast.able.efflorescence(7) and GetTotemTimeLeft(1) < 20 then
                        local meleeFriends = getAllies(tankTarget, 5)
                        if castWiseAoEHeal(meleeFriends, spell.efflorescence, 10, 100, 1, 5, true, false) then
                            return true
                        end
                    end
                end
            end
            --

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
                            br.addonDebug("[Rejuv]rejuvenation on: " .. UnitName(tanks[i].unit))
                            return true
                        end
                    end
                end
                for i = 1, #br.friend do
                    if talent.germination and (br.friend[i].hp <= getValue("Germination") or freemana) and
                            (not buff.rejuvenationGermination.exists(br.friend[i].unit) or buff.rejuvenationGermination.remain(br.friend[i].unit) < 4.5) then
                        if cast.rejuvenation(br.friend[i].unit) then
                            br.addonDebug("[Rejuv]Germination on: " .. UnitName(br.friend[i].unit))
                            return true
                        end
                    elseif (br.friend[i].hp <= getValue("Rejuvenation") or freemana) and
                            (not buff.rejuvenation.exists(br.friend[i].unit) or buff.rejuvenation.remain(br.friend[i].unit) < 4.5)
                    then
                        if cast.rejuvenation(br.friend[i].unit) then
                            br.addonDebug("[Rejuv]rejuvenation on: " .. UnitName(br.friend[i].unit))
                            return true
                        end
                    end
                end
            end


            -- Regrowth
            if not moving or buff.incarnationTreeOfLife.exists() then
                for i = 1, #br.friend do
                    if isChecked("Regrowth Tank") and br.friend[i].hp <= getValue("Regrowth Tank")
                            and (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                            and (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot"))) then
                        if cast.regrowth(br.friend[i].unit) then
                            return true
                        end
                    elseif isChecked("Regrowth") and br.friend[i].hp <= getValue("Regrowth") and (not inInstance or (inInstance and getDebuffStacks(br.friend[i].unit, 209858) < getValue("Necrotic Rot"))) then
                        if cast.regrowth(br.friend[i].unit) then
                            return true
                        end
                    elseif isChecked("Regrowth Clearcasting") and br.friend[i].hp <= getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > gcdMax then
                        if cast.regrowth(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end


        end
    end -- end heal

    local function travel_rest()
        if SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() then
            if not travel then
                CastSpellByID(783, "player")
                return true
            end
        end

        --rush if we can -
        if talent.wildCharge then
            if CastSpellByID(102417, "player") then
                return true
            end
        end

        if SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus()
        then
            return
        end
    end

    local function travel_combat()
        if not travel then
            if cast.travelForm("Player") then
                return true
            end
        end
        --rush if we can -
        if talent.wildCharge then
            if CastSpellByID(102417, "player") then
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
                if cast.able.thrashBear() and (debuff.thrashBear.stack(thisUnit) < 3 or debuff.thrashBear.remain(thisUnit) < 4.5 or cd.mangle.remain() > 0) then
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

    local function owl_rest()
        if not owl then
            if cast.moonkinForm("player") then
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

        if br.player.buff.prowl.exists() and cast.able.rake() then
            for i = 1, #enemies.yards10tnc do
                --if our target is engaged with our tank
                local thisUnit = enemies.yards10tnc[i]
                if #tanks > 0 and UnitThreatSituation(tanks[1].unit, thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) or solo then
                    if cast.rake(thisUnit) then
                        return
                    end
                end
            end
        end

        if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus()
                and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
        then
            return
        end
    end

    local function pre_combat()
        -- clearForm()
        if not cat and not travel and not bear then
            local tank_unit

            if (#tanks > 0 or UnitExists("focus")) and (mode.prehot == 1 or mode.prehot == 2) and mode.hEALS == 1 then


                if runeforge.theDarkTitansLesson.equiped then
                    if not buff.lifebloom.exists("player") then
                        if cast.lifebloom("player") then
                            br.addonDebug("[BLOOM][PRE] Lifebloom on player")
                            return true
                        end
                    end
                end

                if UnitExists("focus") then
                    tank_unit = "focus"
                else
                    if tanks[1] ~= nil then
                        tank_unit = tanks[1].unit
                    end
                end

                if tank_unit and getLineOfSight("player", tank_unit) then
                    -- cenarionWard
                    if not isChecked("Smart Hot") and talent.cenarionWard and isChecked("Cenarion Ward") and not buff.cenarionWard.exists(tank_unit) and cast.able.cenarionWard(tank_unit) and getLineOfSight(tank_unit, "player") then
                        if cast.cenarionWard(tank_unit) then
                            br.addonDebug("[PRE-HOT]:CW on: " .. UnitName(tank_unit))
                            return true
                        end
                    end

                    if cast.able.lifebloom(tank_unit) and not buff.lifebloom.exists(tank_unit) then
                        if cast.lifebloom(tank_unit) then
                            br.addonDebug("[PRE-HOT]:Lifebloom on: " .. UnitName(tank_unit))
                            return true
                        end
                    end
                    if runeforge.theDarkTitansLesson.equiped and not buff.lifebloom.exists("player") then
                        if cast.lifebloom("player") then
                            br.addonDebug("[PRE-HOT]:Lifebloom on: " .. UnitName("player"))
                            return true
                        end
                    end
                    if talent.germination and cast.able.rejuvenation(tank_unit) and not buff.rejuvenationGermination.exists(tank_unit) then
                        if cast.rejuvenation(tank_unit) then
                            br.addonDebug("[PRE-HOT]Germination on: " .. UnitName(tank_unit))
                            return true
                        end
                    elseif not buff.rejuvenation.exists(tank_unit) and cast.able.rejuvenation(tank_unit) then
                        if cast.rejuvenation(tank_unit) then
                            br.addonDebug("[PRE-HOT]Rejuv on: " .. UnitName(tank_unit))
                            return true
                        end
                    end

                end
            end


            --rejuvenation
            if mode.prehot == 1 and mode.hEALS == 1 then
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
    if pause() or IsMounted() or flying or drinking or isCasting(spell.focusedAzeriteBeam) or isCastingSpell(spell.tranquility) or isCasting(spell.replicaOfKnowledge) or isCasting(293491) or hasBuff(250873) or hasBuff(115834) or hasBuff(58984) or hasBuff(185710) or buff.soulshape.exists() then
        --or stealthed (travel and not inCombat) or
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat then
            --[[
               -- using crystal if we got no flask or crystal buff
               if not hasBuff(298837) and not hasBuff(176151) and hasItem(118922) and canUseItem(118922) then
                   if useItem(118922) then
                       return true
                   end
               end
            ]]
            local friendlydeadcount = 0
            local friendlydeadcountinrange = 0
            if isChecked("Auto mass Resurrection") then
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                        friendlydeadcount = friendlydeadcount + 1
                    end
                    if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and UnitInRange(br.friend[i].unit) then
                        friendlydeadcountinrange = friendlydeadcountinrange + 1
                    end
                end
                if friendlydeadcount == 1 and friendlydeadcount == 1 then
                    for i = 1, #br.friend do
                        if cast.revive(br.friend[i].unit, "dead") then
                            return true
                        end
                    end
                elseif friendlydeadcount > 0 then
                    if cast.revitalize() then
                        return true
                    end
                end
            end -- end auto mass rez

            --br.addonDebug("mana = " .. tostring(mana))

            --
            -- auto drinking
            if isChecked("Auto Drink") and mana <= getOptionValue("Auto Drink") and not moving and getDebuffStacks("player", 240443) == 0 and getDebuffStacks("player", 240443) == 0 then
                --240443 == bursting
                -- 226510 == sanguine
                --drink list
                --[[
                item=65499/conjured mana cookies - TW food
                item=159867/rockskip-mineral-wate (alliance bfa)
                item=163784/seafoam-coconut-water  (horde bfa)
                item=113509/conjured-mana-bun
                item=126936/sugar-crusted-fish-feast ff
                item=177040/SL water
                item=178217/moar SL water
                item=173859/water from Kyrian steward
                ]]

                if not isChecked("Sugar Crusted Fish Feast") or (isChecked("Sugar Crusted Fish Feast") and not hasItem(126936)) and not hasBuff(185710) then
                    if hasItem(65499) and canUseItem(65499) then
                        useItem(65499)
                    end
                    if hasItem(113509) and canUseItem(113509) then
                        useItem(113509)
                    end
                    if hasItem(177040) and canUseItem(177040) then
                        useItem(177040)
                    end
                    if hasItem(178217) and canUseItem(178217) then
                        useItem(178217)
                    end
                    if hasItem(173859) and canUseItem(173859) then
                        useItem(173859)
                    end
                elseif isChecked("Sugar Crusted Fish Feast") and hasItem(126936) then
                    local x1, y1, z1 = ObjectPosition("player")
                    br.addonDebug("scaninning -  fish thingy")
                    for i = 1, GetObjectCountBR() do
                        local object = GetObjectWithIndex(i)
                        local ID = ObjectID(object)
                        local x2, y2, z2 = ObjectPosition(object)
                        local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                        if ID == 242405 and distance < 15 then
                            --print(tostring(distance))
                            InteractUnit(object)
                            fishfeast = 1
                            return true
                        else
                            if hasItem(126936) and canUseItem(126936) and fishfeast == 0 then
                                useItem(126936)
                                x1 = x1 + math.random(-2, 2)
                                ClickPosition(x1, y1, z1)
                                br.addonDebug("Placing fish thingy")
                                fishfeast = 1
                                return true
                            end
                        end
                    end
                end
            end

            if isChecked("Break form for dispel") then
                if cleanse() then
                    return true
                end
            end
            if mode.forms == 2 then
                if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus()
                        and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
                then
                    cat_rest()
                    return true
                elseif SpecificToggle("Owl Key") and not GetCurrentKeyBoardFocus()
                        and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
                then
                    owl_rest()
                    return true
                elseif SpecificToggle("Bear Key") and not GetCurrentKeyBoardFocus() then
                    bear_rest()
                    return true
                elseif SpecificToggle("Travel Key") and not GetCurrentKeyBoardFocus() and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical")) then
                    travel_rest()
                    return true
                else
                    clearForm()
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
                if SpecificToggle("Cat Key") and not GetCurrentKeyBoardFocus()
                        and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
                        and (isChecked("Break form for dots") and (debuff.moonfire.exists("target") and debuff.sunfire.exists("target"))
                        or not isChecked("Break form for dots"))
                then
                    cat_combat()
                    return true
                elseif SpecificToggle("Owl Key") and not GetCurrentKeyBoardFocus()
                        and (isChecked("Break form for critical") and lowest.hp > getOptionValue("Critical HP") or not isChecked("Break form for critical"))
                then
                    owl_combat()
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
                if owl then
                    owl_combat()
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
                    return true
                end
                if BossEncounterCase() then
                    return
                end
                if heal() then
                    return true
                end
                if isChecked("pre-hot in combat") or buff.incarnationTreeOfLife.exists() then
                    if pre_combat() then
                        return true
                    end
                end
                if mode.dPS == 1 and lowest.hp > getValue("DPS Min % health") then
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
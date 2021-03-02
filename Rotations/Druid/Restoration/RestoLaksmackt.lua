local rotationName = "Laksmackt" -- Change to name of profile listed in options drop down
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 0, icon = br.player.spell.tranquility },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 0, icon = br.player.spell.tranquility },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.tranquility }
    }

    br.ui:createToggle(CooldownModes, "Cooldown", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 0, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.barkskin }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Decurse Button
    local DecurseModes = {
        [1] = { mode = "On", value = 1, overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 0, icon = br.player.spell.naturesCure },
        [2] = { mode = "Off", value = 2, overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.naturesCure }
    }
    br.ui:createToggle(DecurseModes, "Decurse", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 0, icon = br.player.spell.mightyBash },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mightyBash }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- DPS Button
    local DPSModes = {
        [1] = { mode = "On", value = 1, overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 0, icon = br.player.spell.sunfire },
        [2] = { mode = "Off", value = 2, overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.sunfire }
    }
    br.ui:createToggle(DPSModes, "DPS", 1, -1)

    local FormsModes = {
        [1] = { mode = "On", value = 1, overlay = "Auto Forms Enabled", tip = "Will change forms", highlight = 0, icon = br.player.spell.travelForm },
        [2] = { mode = "Key", value = 2, overlay = "Auto Forms hotkey", tip = "Key triggers Auto Forms", highlight = 0, icon = br.player.spell.travelForm },
        [3] = { mode = "Off", value = 3, overlay = "Auto Forms Disabled", tip = "Will Not change forms", highlight = 0, icon = br.player.spell.travelForm }
    }
    br.ui:createToggle(FormsModes, "Forms", 5, 0)

    -- Rejuvenation Button
    local PrehotModes = {
        [1] = { mode = "On", value = 1, overlay = "Pre-Hot", tip = "Pre-hot Enabled", highlight = 0, icon = br.player.spell.rejuvenation },
        [2] = { mode = "Tank", value = 2, overlay = "Pre-Hot", tip = "Pre-hot on TANK", highlight = 0, icon = br.player.spell.rejuvenation },
        [3] = { mode = "Off", value = 3, overlay = "Pre-Hot", tip = "Pre-hots disabled", highlight = 0, icon = br.player.spell.rejuvenation }
    }
    br.ui:createToggle(PrehotModes, "Prehot", 5, -1)

    local HEALSModes = {
        [1] = { mode = "On", value = 1, overlay = "Heals Enabled", tip = "Heals Enabled", highlight = 0, icon = 145108 },
        [2] = { mode = "Off", value = 2, overlay = "Heals Disabled", tip = "Heals Disabled", highlight = 0, icon = 145108 }
    }
    br.ui:createToggle(HEALSModes, "HEALS", 0, -1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "Forms - SL 2101011533")
        br.ui:createDropdownWithout(section, "Cat Key", br.dropOptions.Toggle, 6, "Set a key for cat/DPS form")
        br.ui:createDropdownWithout(section, "Bear Key", br.dropOptions.Toggle, 6, "Set a key for bear")
        br.ui:createDropdownWithout(section, "Owl Key", br.dropOptions.Toggle, 6, "Set a key for Owl/DPS form")
        br.ui:createDropdownWithout(section, "Travel Key", br.dropOptions.Toggle, 6, "Set a key for travel")
        br.ui:createDropdownWithout(section, "Auto Forms", { "Any", "Travel Forms", "Cat Form" }, 1, "|cffFFFFFFSelect the forms you want to use while moving")
        br.ui:createCheckbox(section, "Use Mount Form", "Uses the Mount Form for ground travel.", 1)
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
        br.ui:createCheckbox(section, "Sunfire Explosives")

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
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Covenant")
        br.ui:createDropdownWithout(section, "Covenant Ability", { "DPS", "HEAL", "BOTH", "Manual" }, 3, "when")
        br.ui:createSpinnerWithout(section, "Covenant Ability Health", 70, 0, 100, 5, "Health % for switching to healer")
        br.ui:createSpinnerWithout(section, "Covenant Ability Heal Targets", 3, 0, 40, 1, "Minimum hurt Targets")
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
        br.ui:createDropdownWithout(section, "Trinket 1 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "On Lust" }, 1, "", "")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets", 3, 1, 40, 1, "", "Minimum Trinket 2 Targets(This includes you)", true)
        br.ui:createDropdownWithout(section, "Trinket 2 Mode", { "|cffFFFFFFNormal", "|cffFFFFFFTarget", "|cffFFFFFFGround", "On Lust", "DPS target" }, 1, "", "")
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
        br.ui:createSpinner(section, "Barkskin", 60, 0, 100, 5, "|cffFFBB00Health Percent to Cast At.")
        -- Renewal
        br.ui:createSpinner(section, "Renewal", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at")
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
        br.ui:createCheckbox(section, "Root - Spiteful(M+)")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end
local function isCC(unit)
    if br.getOptionCheck("Don't break CCs") then
        return br.isLongTimeCCed(unit)
    end
    return false
end

function isExplosive(Unit)
    return GetObjectID(Unit) == 120651
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
        [1122] = "Summon Infernal"
    }
    for i = 1, #already_stunned_list do
        --  Print(select(10, br._G.UnitDebuff(Unit, i)))
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

local function noDamageCheck(unit)
    if br.isChecked("Sunfire Explosives") and br.GetObjectID(unit) == 120651 then
        return true
    end
    if isCC(unit) then
        return true
    end
    if br.GetObjectID(unit) == 127019 then
        --dummies inside of Freehold
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
    --[[if isCasting(302415, unit) then
        -- emmisary teleporting home
        return true
    end
    if br.GetObjectID(thisUnit) == 155432 then
        --emmisaries to punt, dealt with seperately
        return true
    end]]
    return false --catchall
end

local fishfeast = 0

local precast_spell_list = {
    --spell_id	, precast_time	,	spell_name
    { 214652, 5, "Acidic Fragments" },
    { 205862, 5, "Slam" },
    { 259832, 1.5, "Massive Glaive - Stormbound Conqueror (Warport Wastari, Zuldazar, for testing purpose only)" },
    { 218774, 5, "Summon Plasma Spheres" },
    { 206949, 5, "Frigid Nova" },
    { 206517, 5, "Fel Nova" },
    { 207720, 5, "Witness the Void" },
    { 206219, 5, "Liquid Hellfire" },
    { 211439, 5, "Will of the Demon Within" },
    { 209270, 5, "Eye of Guldan" },
    { 227071, 5, "Flame Crash" },
    { 233279, 5, "Shattering Star" },
    { 233441, 5, "Bone Saw" },
    { 235230, 5, "Fel Squall" },
    { 231854, 5, "Unchecked Rage" },
    { 232174, 5, "Frosty Discharge" },
    { 230139, 5, "Hydra Shot" },
    { 233264, 5, "Embrace of the Eclipse" },
    { 236542, 5, "Sundering Doom" },
    { 236544, 5, "Doomed Sundering" },
    { 235059, 5, "Rupturing Singularity" },
    { 288693, 3, "Tormented Soul - Grave Bolt (Reaping affix)" },
    { 262347, 5, "Static Pulse" },
    { 302420, 5, "Queen's Decree: Hide" },
    { 260333, 7, "Tantrum - Underrot 2nd boss" },
    { 255577, 5, "Transfusion" }, -- https://www.wowhead.com/spell=255577/transfusion
    { 259732, 5, "Festering Harvest" }, --https://www.wowhead.com/spell=259732/festering-harvest
    { 285388, 5, "Vent Jets" }, --https://www.wowhead.com/spell=285388/vent-jets
    { 291626, 3, "Cutting Beam" }, --https://www.wowhead.com/spell=291626/cutting-beam
    { 300207, 3, "shock-coil" }, -- https://www.wowhead.com/spell=300207/shock-coil
    { 297261, 5, "rumble" }, -- https://www.wowhead.com/spell=297261/rumble
    { 262347, 5, "pulse" } --https://www.wowhead.com/spell=262347/static-pulse
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
    { spellID = 302421, stacks = 0, secs = 5 } -- Queen's Decree
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
    [270487] = { targeted = true }, -- https://www.wowhead.com/spell=270487/severing-blade
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
    [161241] = "Voidweaver Mal'thir"
}

----------------
--- ROTATION ---
---------------_

--listener based on combatlog

local someone_casting = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local function reader()
    -- local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    local _, param, _, _, _, _, _, _, _, _, _, _, _, _, _ = CombatLogGetCurrentEventInfo()
    if param == "SPELL_CAST_SUCCESS" and spell == 193316 then
        -- or param == "SPELL_AURA_REMOVED" then
        C_Timer.After(0.02, function()
            --    print("refresh rtb")
            dice_reroll = true
        end)
    end
    if param == "SPELL_CAST_START" then
        C_Timer.After(0.02, function()
            someone_casting = true
            --Print(source .. "/" .. sourceName .. " is casting " .. spellName)
        end)
    end
end
frame:SetScript("OnEvent", reader)

local eclipse_next = "any"
local x = 0

local function runRotation()
    -- if br.timer:useTimer("debugRestoration", 0.1) then
    --print("Running: "..rotationName)

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------
    br.UpdateToggle("Rotation", 0.25)
    br.UpdateToggle("Cooldown", 0.25)
    br.UpdateToggle("Defensive", 0.25)
    br.UpdateToggle("Decurse", 0.25)
    br.UpdateToggle("Interrupt", 0.25)
    br.UpdateToggle("DPS", 0.25)
    br.UpdateToggle("Forms", 0.25)
    br.UpdateToggle("prehot", 0.25)

    --  br.player.mode.decurse = br.data.settings[br.selectedSpec].toggles["Decurse"]
    -- br.player.mode.DPS = br.data.settings[br.selectedSpec].toggles["DPS"]
    -- br.player.mode.forms = br.data.settings[br.selectedSpec].toggles["Forms"]
    -- br.player.mode.rejuvenation = br.data.settings[br.selectedSpec].toggles["prehot"]
    -- br.player.mode.HEALS = br.data.settings[br.selectedSpec].toggles["HEALS"]

    --------------
    --- Locals ---
    --------------
    -- local combatTime                                    = br.getCombatTime()
    local cd = br.player.cd
    -- local charges                                       = br.player.charges
    local buff = br.player.buff
    local runeforge = br.player.runeforge
    local lastSpell = br.lastSpellCast
    local cast = br.player.cast
    local combo = br.player.power.comboPoints.amount()
    local debuff = br.player.debuff
    local drinking = br.getBuffRemain("player", 192002) ~= 0 or br.getBuffRemain("player", 167152) ~= 0 or br.getBuffRemain("player", 192001) ~= 0 or br.getBuffRemain("player", 185710) ~= 0
    local deadtar = br.GetUnitIsDeadOrGhost("target") or br.isDummy()
    local deadMouse, hasMouse, playerMouse = br._G.UnitIsDeadOrGhost("mouseover"), br.GetObjectExists("mouseover"), br._G.UnitIsPlayer("mouseover")
    local hastar = hastar or br.GetObjectExists("target")
    local playertar = br._G.UnitIsPlayer("target")
    local enemies = br.player.enemies
    local friends = br.friends or {}
    local moving = br.isMoving("player") ~= false or br.player.moving
    local gcdMax = br.player.gcdMax
    local inCombat = br.isInCombat("player")
    local inInstance = br.player.instance == "party" or br.player.instance == "scenario"
    local inRaid = br.player.instance == "raid"

    local level = br.player.level
    local mana = br.player.power.mana.percent()
    -- local mode = br.player.mode
    local php = br.player.health
    local race = br.player.race
    local racial = br.player.getRacial()
    local spell = br.player.spell
    local talent = br.player.talent
    local travel = br.player.buff.travelForm.exists()
    local cat = br.player.buff.catForm.exists()
    local owl = br.player.buff.moonkinForm.exists()
    local bear = br.player.buff.bearForm.exists()
    local mount = br._G.GetShapeshiftForm() == 5 --- or maybe br.player.buff.mountForm.exists() but this is not working (mountform has no buff? idk)
    local noform = br._G.GetShapeshiftForm() == 0 or br.player.buff.treantForm.exists()
    local units = br.player.units
    local traits = br.player.traits
    local mode = br.player.ui.mode
    local solo = #br.friend == 1
    local tanks = br.getTanksTable()
    local tank
    local covenant = br.player.covenant
    local ttd = br.getTTD
    local BleedFriend
    local BleedFriendCount = 0
    local BleedStack = 0
    local catspeed = br.player.buff.dash.exists() or br.player.buff.tigerDash.exists()
    local freemana = buff.innervate.exists() or buff.symbolOfHope.exists()

    if talent.balanceAffinity then
        -- BalanceAffinity adds one stance
        mount = br._G.GetShapeshiftForm() == 6
    else
        mount = br._G.GetShapeshiftForm() == 5
    end

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
    friends.yards40 = br.getAllies("player", 40)

    local lowest = br.friend[1]

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

    local function round(num, numDecimalPlaces)
        local mult = 10 ^ (numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

    br.druid.shiftTimer = br.druid.shiftTimer or 0
    local function clearForm()
        if not noform and not buff.incarnationTreeOfLife.exists() then
            br._G.RunMacroText("/CancelForm")
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

    local function can_swiftmend(unit)
        if buff.rejuvenation.exists(unit) or buff.regrowth.exists(unit) or buff.wildGrowth.exists(unit) then
            return true
        else
            return false
        end
    end

    local function getAllHotCnt(time_remain)
        local hotCnt = 0
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
        local eclipse_in = (buff.eclipse_solar.exists() or buff.eclipse_lunar.exists()) or false

        --  Print("In Eclipse: " .. tostring(eclipse_in) .. " next:  " .. eclipse_next)

        if not buff.moonkinForm.exists() then
            if cast.moonkinForm() then
                return true
            end
        end

        --dots

        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not noDamageCheck(thisUnit) then
                if
                br.isChecked("Safe Dots") and
                        ((inInstance and #tanks > 0 and br.getDistance(thisUnit, tanks[1].unit) <= 10) or (inInstance and #tanks == 0) or
                                (inRaid and #tanks > 1 and (br.getDistance(thisUnit, tanks[1].unit) <= 10 or (br.getDistance(thisUnit, tanks[2].unit) <= 10))) or
                                solo or
                                (inInstance and #tanks > 0 and br.getDistance(tanks[1].unit) >= 90)) or
                        --need to add, or if tank is dead or
                        not br.isChecked("Safe Dots")
                then
                    if debuff.sunfire.count() < br.getOptionValue("Max Sunfire Targets") and cast.able.sunfire(thisUnit) and debuff.sunfire.refresh(thisUnit) then
                        if cast.sunfire(thisUnit) then
                            return true
                        end
                    end

                    if (debuff.moonfire.count() < br.getOptionValue("Max Moonfire Targets") or br.isBoss(thisUnit)) and ttd(thisUnit) > 5 then
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
        if br.isChecked("Heart of the Wild") and buff.moonkinForm.exists() and talent.heartOfTheWild and cast.able.heartOfTheWild() then
            if cast.heartOfTheWild() then
                return true
            end
        end

        --covenant here
        if br.useCDs()
                and (covenant.nightFae.active and cast.able.convokeTheSpirits() or (covenant.venthyr.active and cast.able.ravenousFrenzy()))
                and (getOptionValue("Covenant Ability") == 1 or getOptionValue("Covenant Ability") == 3)
                and getOutLaksTTDMAX() > 20
                and (buff.heartOfTheWild.exists() or cd.heartOfTheWild.remains() > 30 or not talent.heartOfTheWild or not isChecked("Heart of the Wild")) then
            if covenant.nightFae.active then
                if cast.convokeTheSpirits() then
                    return true
                end
            elseif covenant.venthyr.active then
                if cast.ravenousFrenzy() then
                    return true
                end
            end
        end

        if
        br.useCDs() and cast.able.convokeTheSpirits() and (br.getOptionValue("Convoke Spirits") == 1 or br.getOptionValue("Convoke Spirits") == 3) and br.getTTD("target") > 10 and
                (buff.heartOfTheWild.exists() or cd.heartOfTheWild.remains() > 30 or not talent.heartOfTheWild or not br.isChecked("Heart of the Wild"))
        then
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
                if cast.starfire(br.getBiggestUnitCluster(45, 8)) then
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
                    if cast.starfire(br.getBiggestUnitCluster(45, 8)) then
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

        if
        br.SpecificToggle("Owl Key") and not br._G.GetCurrentKeyBoardFocus() and
                (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical")) and
                br.isChecked("Break form for dots") and
                (not debuff.moonfire.exists("target") or not debuff.sunfire.exists("target")) or
                not br.isChecked("Break form for dots")
        then
            return
        end
    end

    local function BossEncounterCase()
        local burst = false
        local crit_count = 0
        --Bursting
        --Print("Check" ..br.isChecked("Bursting").."#: "..br.getOptionValue("Bursting"))
        if br.isChecked("Bursting") and inInstance and #tanks > 0 then
            local ourtank = tanks[1].unit
            local Burststack = br.getDebuffStacks(ourtank, 240443)
            if Burststack >= br.getOptionValue("Bursting") then
                burst = true
            else
                burst = false
            end
        end
        if burst == false then
            for i = 1, #br.friend do
                if br._G.UnitInRange(br.friend[i].unit) and br.friend[i].hp <= br.getValue("Critical HP") then
                    crit_count = crit_count + 1
                end
                if crit_count >= br.getOptionValue("Bursting") then
                    burst = true
                end
            end
        end

        --cw on ourself to survive bursting
        if burst == true and cast.able.cenarionWard() and (br.getDebuffStacks("player", 240443) > 1 or php <= br.getValue("Critical HP") or br.getDebuffStacks("player", 240559) > 2) then
            if cast.able.cenarionWard() then
                if cast.cenarionWard("player") then
                    br.addonDebug("[BURST]: CW on self")
                    return true
                end
            end
        end

        if cast.able.cenarionWard() and php <= br.getValue("Critical HP") or br.getDebuffStacks("player", 240559) > 2 then
            if cast.able.cenarionWard() then
                if cast.cenarionWard("player") then
                    br.addonDebug("[CRIT]: CW on self")
                    return true
                end
            end
        end

        if mode.hEALS == 1 then
            --critical
            if br.isChecked("Critical HP") and lowest.hp <= br.getOptionValue("Critical HP") then

                if br.isChecked("Natures Swiftness") and cast.able.naturesSwiftness() then
                    if cast.naturesSwiftness() then
                        br.addonDebug("[CRIT] Natures Swiftness")
                    end
                end
                if cast.able.cenarionWard(lowest.unit) then
                    if cast.cenarionWard(lowest.unit) then
                        br.addonDebug("[CRIT]CWard on: " .. br._G.UnitName(lowest.unit))
                        return true
                    end
                end
                if cast.able.swiftmend(lowest.unit) and can_swiftmend(lowest.unit) then
                    if cast.swiftmend(lowest.unit) then
                        br.addonDebug("[CRIT]Swiftmend on: " .. br._G.UnitName(lowest.unit))
                        return true
                    end
                end
                if covenant.nightFae.active and cast.able.convokeTheSpirits() and (br.getOptionValue("Convoke Spirits") == 2 or br.getOptionValue("Convoke Spirits") == 3) then
                    if cast.convokeTheSpirits() then
                        br.addonDebug("[CRIT] Convoke The Spirits!")
                        return true
                    end
                end
                if talent.germination and not buff.rejuvenationGermination.exists(lowest.unit) then
                    if cast.rejuvenation(lowest.unit) then
                        br.addonDebug("[CRIT]Germination on: " .. br._G.UnitName(lowest.unit))
                        return true
                    end
                elseif not talent.germination and not buff.rejuvenation.exists(lowest.unit) then
                    if cast.rejuvenation(lowest.unit) then
                        br.addonDebug("[CRIT]Rejuvenation on: " .. br._G.UnitName(lowest.unit))
                        return true
                    end
                end

                if talent.nourish and cast.able.nourish() and count_hots(lowest.unit) > br.getValue("Nourish - hot count") then
                    if cast.nourish(lowest.unit) then
                        br.addonDebug("[CRIT]nourish on: " .. br._G.UnitName(lowest.unit))
                        return true
                    end
                end
                if cast.able.regrowth(lowest.unit) then
                    if cast.regrowth(lowest.unit) then
                        br.addonDebug("[CRIT]Regrowth on: " .. br._G.UnitName(lowest.unit))
                        return true
                    end
                end
            end
        end

        if br.isChecked("Sunfire Explosives") and timers.time("Explosion_delay", isExplosive(units.dyn45)) > 0.25 then
            if cast.able.sunfire(units.dyn45) and isExplosive(units.dyn45) then
                --     Print(tostring(timers.time("Explosion_delay", isExplosive(units.dyn45))))
                if cast.sunfire(units.dyn45) then
                    br.addonDebug("killed explosive - at" .. timers.time("Explosion_delay", isExplosive(units.dyn45)))
                    return true
                end
            end
        end



        -- aggressive dots
        if br.isChecked("Aggressive Dots") and mode.dPS == 1 and lowest.hp > br.getValue("DPS Min % health") and not noDamageCheck("target") and burst == false then
            local thisUnit = "target"
            if
            br.isChecked("Safe Dots") and not noDamageCheck(thisUnit) and
                    ((inInstance and #tanks > 0 and br.getDistance(thisUnit, tanks[1].unit) <= 10) or (inInstance and #tanks == 0) or
                            (inRaid and #tanks > 1 and (br.getDistance(thisUnit, tanks[1].unit) <= 10 or (br.getDistance(thisUnit, tanks[2].unit) <= 10))) or
                            solo or
                            (inInstance and #tanks > 0 and br.getDistance(tanks[1].unit) >= 90))(
                    --need to add, or if tank is dead or
                            not br.isChecked("Safe Dots") or #tanks == 0
                    )
            then
                if not debuff.sunfire.exists("target") and mana > br.getOptionValue("DPS Save mana") then
                    if cast.sunfire("target", "aoe", 1, sunfire_radius) then
                        br.addonDebug("Aggressive  Sunfire - target")
                        return true
                    end
                end
                if not debuff.moonfire.exists("target") and mana > br.getOptionValue("DPS Save mana") then
                    if cast.moonfire("target") then
                        br.addonDebug("Aggressive Moonfire - target")
                        return true
                    end
                end
            end
        end

        --Smart Stuff
        if 1 == 2 then
            if br.isSelected("Smart Charge") or br.isChecked("Smart Hot") then
                local countSmart = #enemies.yards40
                local smarthottargets = br.getValue("Smart Hot")
                if smarthottargets < #enemies.yards40 then
                    countSmart = smarthottargets
                end

                local spellTarget

                if someone_casting and mode.hEALS == 1 then
                    for i = 1, countSmart do
                        local thisUnit = enemies.yards40[i]
                        local _, _, _, _, endCast, _, _, _, spellcastID = br._G.UnitCastingInfo(thisUnit)
                        spellTarget = select(3, br._G.UnitCastID(thisUnit))

                        if br.isChecked("Smart Hot") then
                            --        if someone_casting then
                            if spellTarget ~= nil and endCast and pre_hot_list[spellcastID] and ((endCast / 1000) - br._G.GetTime()) < 1 then
                                if cast.able.cenarionWard() then
                                    if cast.cenarionWard(spellTarget) then
                                        br.addonDebug("[Snipe]CW on: " .. br._G.UnitName(spellTarget))
                                        return true
                                    end
                                end
                                if talent.germination and not buff.rejuvenationGermination.exists(spellTarget) then
                                    if cast.rejuvenation(spellTarget) then
                                        br.addonDebug("[Snipe]Germination on: " .. br._G.UnitName(spellTarget))
                                        return true
                                    end
                                elseif not talent.germination and not buff.rejuvenation.exists(spellTarget) then
                                    if cast.rejuvenation(spellTarget) then
                                        br.addonDebug("[Snipe]Rejuvenation on: " .. br._G.UnitName(spellTarget))
                                        return true
                                    end
                                end
                                if br.isSelected("Use Bark w/Smart Hot") and br.getHP(spellTarget) < br.getValue("Use Bark w/Smart Hot") then
                                    if cast.ironbark(spellTarget) then
                                        br.addonDebug("[Snipe]Bark on: " .. br._G.UnitName(spellTarget))
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end

                for i = 1, #br.friend do
                    if br._G.UnitInRange(br.friend[i].unit) then
                        for _, v in pairs(debuff_list) do
                            if
                            br.getDebuffRemain(br.friend[i].unit, v.spellID) > v.secs and br.getDebuffStacks(br.friend[i].unit, v.spellID) >= v.stacks and
                                    not buff.rejuvenation.exists(br.friend[i].unit)
                            then
                                if talent.germination and not buff.rejuvenationGermination.exists(br.friend[i].unit) then
                                    if cast.rejuvenation(br.friend[i].unit) then
                                        br.addonDebug("[DEBUFF]Germination on: " .. br._G.UnitName(br.friend[i].unit))
                                        return true
                                    end
                                elseif not buff.rejuvenation.exists(br.friend[i].unit) then
                                    if cast.rejuvenation(br.friend[i].unit) then
                                        br.addonDebug("[DEBUFF]Rejuv on: " .. br._G.UnitName(br.friend[i].unit))
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
                            if br._G.UnitInRange(br.friend[j].unit) then
                                if not buff.rejuvenation.exists(br.friend[j].unit) then
                                    if cast.rejuvenation(br.friend[j].unit) then
                                        br.addonDebug("[PRE-HOT]Rejuv on: " .. br._G.UnitName(br.friend[j].unit) .. " because: " .. spell_name)
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
        br.druid.using_lifebloom = false
        local seth_routine

        if 1 == 2 then
            -- Waycrest Manor
            if inInstance and inCombat and select(8, br._G.GetInstanceInfo()) == 1862 then
                for i = 1, #br.friend do
                    if br.getDebuffRemain(br.friend[i].unit, 260741) ~= 0 and br.friend[i].hp < 95 then
                        --Jagged Nettles
                        heal_target = br.friend[i].unit
                    end
                end
            end

            --Kings Rest
            if inInstance and inCombat and select(8, br._G.GetInstanceInfo()) == 1762 then
                for i = 1, #br.friend do
                    if
                    br.getDebuffRemain(br.friend[i].unit, 267626) ~= 0 or -- Dessication
                            br.getDebuffRemain(br.friend[i].unit, 267618) ~= 0 or -- Drain Fluids
                            br.getDebuffRemain(br.friend[i].unit, 266231) ~= 0 or -- Severing axe from axe lady in council
                            br.getDebuffRemain(br.friend[i].unit, 272388) ~= 0 or -- shadow barrage
                            br.getDebuffRemain(br.friend[i].unit, 265773) > 1 or -- spit-gold
                            (br.getDebuffRemain(br.friend[i].unit, 270487) ~= 0 and br.getDebuffStacks(br.friend[i].unit, 270487) > 1) and -- severing-blade
                                    br.friend[i].hp < 95
                    then
                        heal_target = br.friend[i].unit
                    end
                end
            end

            -- Sacrifical Pits/ Devour
            if inInstance and inCombat and select(8, br._G.GetInstanceInfo()) == 1763 then
                for i = 1, #br.friend do
                    if (br.getDebuffRemain(br.friend[i].unit, 255421) or br.getDebuffRemain(br.friend[i].unit, 255434)) ~= 0 and br.friend[i].hp <= 90 then
                        heal_target = br.friend[i].unit
                    end
                end
            end

            if heal_target ~= "none" then
                if talent.germination and not buff.rejuvenationGermination.exists(heal_target) then
                    if cast.rejuvenation(heal_target) then
                        br.addonDebug("[BOSS]Germination on: " .. br._G.UnitName(heal_target))
                        return true
                    end
                elseif not talent.germination and not buff.rejuvenation.exists(heal_target) then
                    if cast.rejuvenation(heal_target) then
                        br.addonDebug("[CRIT]Rejuvenation on: " .. br._G.UnitName(heal_target))
                        return true
                    end
                end
                if not seth_routine then
                    if cast.able.ironbark() then
                        if cast.ironbark(heal_target) then
                            br.addonDebug("[BOSS]Bark on: " .. br._G.UnitName(heal_target))
                            return true
                        end
                    end
                    if cast.able.cenarionWard() then
                        if cast.cenarionWard(heal_target) then
                            br.addonDebug("[BOSS]CWard on: " .. br._G.UnitName(heal_target))
                            return true
                        end
                    end
                end
                if cast.able.lifebloom() and (not buff.lifebloom.exists(heal_target) or buff.lifebloom.remains(heal_target) < 2) then
                    if cast.lifebloom(heal_target) then
                        br.druid.using_lifebloom = true
                        br.addonDebug("[BOSS]Bloom on: " .. br._G.UnitName(heal_target))
                        return true
                    end
                end
                if cast.able.swiftmend() and can_swiftmend(heal_target) and (br.getHP(heal_target) < 80 or (seth_routine and br.getHP(heal_target) < 95)) then
                    if cast.swiftmend(heal_target) then
                        br.addonDebug("[BOSS]Swiftmend on: " .. br._G.UnitName(heal_target))
                        return true
                    end
                end
                if talent.nourish and cast.able.nourish() and count_hots(heal_target) >= br.getOptionCheck("Nourish - hot count") then
                    if cast.nourish(heal_target) then
                        br.addonDebug("[BOSS]nourish on: " .. br._G.UnitName(heal_target))
                        return true
                    end
                end
                if cast.able.regrowth() and (br.getHP(heal_target) < 80 or (seth_routine and br.getHP(heal_target) < 98)) then
                    if cast.regrowth(heal_target) then
                        br.addonDebug("[BOSS]Regrowth on: " .. br._G.UnitName(heal_target))
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
            if br.DontMoveStartTime then
                standingTime = br._G.GetTime() - br.DontMoveStartTime
            end --     local moveTimer = player.movingTime()
            --     Print(tostring(moveTimer))
            --and br.timer:useTimer("debugShapeshift", 0.25) then

            -- Flight Form
            if
            not inCombat and br.canFly() and not swimming and (br.fallDist > 90 or 1 == 1) and level >= 24 and not buff.prowl.exists() and
                    (br.getOptionValue("Auto Forms") == 1 or br.getOptionValue("Auto Forms") == 2)
            then
                if br._G.GetShapeshiftForm() ~= 0 and not buff.travelForm.exists() then
                    -- br._G.RunMacroText("/CancelForm")
                    br._G.CastSpellByID(783, "player")
                    return true
                end
            end
            -- Aquatic Form
            if
            (not inCombat) --[[or br.getDistance("target") >= 10--]] and swimming and not travel and not buff.prowl.exists() and br.isMoving("player") and
                    (br.getOptionValue("Auto Forms") == 1 or br.getOptionValue("Auto Forms") == 2)
            then
                if br._G.GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                    -- CancelShapeshiftForm()
                    br._G.RunMacroText("/CancelForm")
                    br._G.CastSpellByID(783, "player")
                    return true
                end
            end
            -- Travel Form
            if
            not inCombat and not swimming and level >= 24 and not buff.prowl.exists() and not travel and not mount and not br._G.IsIndoors() and br.isMovingTime(1) and
                    (br.getOptionValue("Auto Forms") == 1 or br.getOptionValue("Auto Forms") == 2)
            then
                -- Print(br._G.GetShapeshiftForm())
                if br._G.GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
                    br._G.RunMacroText("/CancelForm")
                    if br.isChecked("Use Mount Form") and not br.canFly() then
                        br._G.CastSpellByID(210053, "player")
                    else
                        br._G.CastSpellByID(783, "player")
                    end
                    return true
                else
                    if br.isChecked("Use Mount Form") and not br.canFly() then
                        br._G.CastSpellByID(210053, "player")
                    else
                        br._G.CastSpellByID(783, "player")
                    end
                    return true
                end
            end
            -- Cat Form
            if
            not cat and not br._G.IsMounted() and not flying and (br._G.IsIndoors() or br.getOptionValue("Auto Forms") == 3) and
                    (br.getOptionValue("Auto Forms") == 1 or br.getOptionValue("Auto Forms") == 3)
            then
                -- Cat Form when not swimming or flying or stag and not in combat
                if moving and not swimming and not flying and not travel then
                    if cast.catForm("player") then
                        return true
                    end
                end
                -- Cat Form - Less Fall Damage
                if (not br.canFly() or inCombat or level < 24) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then
                    --falling > br.getOptionValue("Fall Timer") then
                    if cast.catForm("player") then
                        return true
                    end
                end
            end
        end -- End Shapeshift Form Management

        -- Revive
        if br.isChecked("Revive") and not cast.last.revive(1) then
            if br.getOptionValue("Revive") == 1 and hastar and playertar and deadtar then
                if cast.revive("target", "dead") then
                    br.addonDebug("Casting Revive")
                    return true
                end
            end
            if br.getOptionValue("Revive") == 2 and hasMouse and playerMouse and deadMouse then
                if cast.revive("mouseover", "dead") then
                    br.addonDebug("Casting Revive")
                    return true
                end
            end
        end
    end -- End Action List - Extras

    local function Defensive()
        if br.useDefensive() then
            -- Barkskin
            if br.isChecked("Barkskin") and cast.able.barkskin() then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    --        local _, _, _, startCast, endCast, _, _, _, spellcastID = br._G.UnitCastingInfo(thisUnit)

                    if
                    php <= br.getOptionValue("Barkskin") or br.UnitDebuffID("player", 265773) or -- spit-gold from KR
                            br.UnitDebuffID("player", 302420) and thisUnit == 155433 and br.getCastTimeRemain(thisUnit) < 4
                    then
                        -- 302420
                        if cast.barkskin() then
                            return
                        end
                    end
                end
            end
            -- Pot/Stoned
            if br.isChecked("Potion/Healthstone") and php <= br.getValue("Potion/Healthstone") then
                if inCombat and (br.hasHealthPot() or br.hasItem(5512) or br.hasItem(166799)) then
                    if br.canUseItem(5512) then
                        br.addonDebug("Using Healthstone")
                        br.useItem(5512)
                    elseif br.hasItem(156634) and br.canUseItem(156634) then
                        br.addonDebug("Using Silas' Vial of Continuous Curing")
                        br.useItem(156634)
                    elseif br.hasItem(166799) and br.canUseItem(166799) then
                        br.addonDebug("Using Emerald of Vigor")
                        br.useItem(166799)
                    elseif br.hasItem(169451) and br.canUseItem(169451) then
                        br.addonDebug("Using Health Pot")
                        br.useItem(169451)
                    end
                end
            end
            -- Renewal
            if br.isChecked("Renewal") and talent.renewal then
                if php <= br.getOptionValue("Renewal") then
                    if cast.renewal() then
                        return true
                    end
                end
            end
            -- Rebirth

            if br.isChecked("Rebirth") and not moving and inCombat then
                if
                br.getOptionValue("Rebirth") == 1 and -- Target
                        br._G.UnitIsPlayer("target") and
                        br.GetUnitIsDeadOrGhost("target") and
                        br.GetUnitIsFriend("target", "player")
                then
                    if cast.rebirth("target", "dead") then
                        return true
                    end
                end
                if
                br.getOptionValue("Rebirth") == 2 and -- Mouseover
                        br._G.UnitIsPlayer("mouseover") and
                        br.GetUnitIsDeadOrGhost("mouseover") and
                        br.GetUnitIsFriend("mouseover", "player")
                then
                    if cast.rebirth("mouseover", "dead") then
                        return true
                    end
                end
                if br.getOptionValue("Rebirth") == 3 then
                    -- Tank
                    for i = 1, #tanks do
                        if br._G.UnitIsPlayer(tanks[i].unit) and br.GetUnitIsDeadOrGhost(tanks[i].unit) and br.GetUnitIsFriend(tanks[i].unit, "player") then
                            if cast.rebirth(tanks[i].unit, "dead") then
                                return true
                            end
                        end
                    end
                end
                if br.getOptionValue("Rebirth") == 4 then
                    -- Healer
                    for i = 1, #br.friend do
                        if
                        br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") and
                                (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
                        then
                            if cast.rebirth(br.friend[i].unit, "dead") then
                                return true
                            end
                        end
                    end
                end
                if br.getOptionValue("Rebirth") == 5 then
                    -- Tank/Healer
                    for i = 1, #br.friend do
                        if
                        br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") and
                                (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or
                                        br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                        then
                            if cast.rebirth(br.friend[i].unit, "dead") then
                                return true
                            end
                        end
                    end
                end
                if br.getOptionValue("Rebirth") == 6 then
                    -- Any
                    for i = 1, #br.friend do
                        if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") then
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
        if br.useInterrupts() then
            if (br.isChecked("Typhoon") and talent.typhoon and cast.able.typhoon()) or (br.isChecked("Mighty Bash") and talent.mightyBash and cast.able.mightyBash()) then
                for i = 1, #enemies.yards15 do
                    local thisUnit = enemies.yards15[i]
                    if
                    cast.able.mightyBash() and br.isCrowdControlCandidates(thisUnit) and not br.getUnitID(thisUnit) == 130488 and not already_stunned(thisUnit) and
                            br.GetUnitExists(thisUnit) and
                            br.getBuffRemain(thisUnit, 226510) == 0 and
                            br.getDistance(thisUnit, "player") <= 5
                    then
                        if cast.mightyBash(thisUnit) then
                            --Print("Stun")
                            return true
                        end
                    end
                    if br.canInterrupt(thisUnit, br.getOptionValue("InterruptAt")) then
                        -- Typhoon
                        if br.isChecked("Typhoon") and talent.typhoon and br.getFacing("player", thisUnit) then
                            if cast.typhoon() then
                                return
                            end
                        end
                        -- Mighty Bash
                        if
                        br.isChecked("Mighty Bash") and talent.mightyBash and br.getDistance(thisUnit, "player") <= 8 and br.getBuffRemain(thisUnit, 226510) == 0 and
                                StunsBlackList[br.GetObjectID(thisUnit)] == nil and
                                (thisUnit == 130488 and br.isChecked("Motherload - Stun jockeys") or thisUnit ~= 130488)
                        then
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
        if br.isChecked("Hibernate as Interrupt") and cast.able.hibernate() then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                --br.canInterrupt(thisUnit, 99)
                if
                br._G.UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] and br.getCastTimeRemain(thisUnit) > br.getCastTime(spell.hibernate) and
                        StunsBlackList[br.GetObjectID(thisUnit)] == nil and
                        not br.isBoss(thisUnit)
                then
                    --and br._G.UnitCastingInfo(thisUnit) ~= GetSpellInfo(257899) and br._G.UnitCastingInfo(thisUnit) ~= GetSpellInfo(258150) and br._G.UnitCastingInfo(thisUnit) ~= GetSpellInfo(252923)
                    --and br._G.UnitCreatureType(thisUnit) == CC_CreatureTypeList[i] then
                    if cast.hibernate(thisUnit) then
                        return true
                    end
                end
            end
        end
    end

    local function Cooldowns()
        -- Ironbark
        if br.isChecked("Ironbark") and inCombat then
            if br.getOptionValue("Ironbark Target") == 1 then
                if php <= br.getValue("Ironbark") then
                    if cast.ironbark("player") then
                        return true
                    end
                end
            elseif br.getOptionValue("Ironbark Target") == 2 then
                if br.getHP("target") <= br.getValue("Ironbark") then
                    if cast.ironbark("target") then
                        return true
                    end
                end
            elseif br.getOptionValue("Ironbark Target") == 3 then
                if br.getHP("mouseover") <= br.getValue("Ironbark") then
                    if cast.ironbark("mouseover") then
                        return true
                    end
                end
            elseif br.getOptionValue("Ironbark Target") == 4 then
                for i = 1, #tanks do
                    if tanks[i].hp <= br.getValue("Ironbark") then
                        if cast.ironbark(tanks[i].unit) then
                            return true
                        end
                    end
                end
            elseif br.getOptionValue("Ironbark Target") == 5 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= br.getValue("Ironbark") and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" then
                        if cast.ironbark(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            elseif br.getOptionValue("Ironbark Target") == 6 then
                for i = 1, #br.friend do
                    if
                    br.friend[i].hp <= br.getValue("Ironbark") and
                            (br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or
                                    br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                    then
                        if cast.ironbark(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            elseif br.getOptionValue("Ironbark Target") == 7 then
                if lowest.hp <= br.getValue("Ironbark") then
                    if cast.ironbark(lowest.unit) then
                        return true
                    end
                end
            end
        end

        -- Ghetto Flourish Support
        if talent.flourish and br.isChecked("Flourish") and inCombat and talent.flourish and buff.wildGrowth.exists() then
            if br.getLowAllies(br.getValue("Flourish")) >= br.getValue("Flourish Targets") then
                local c = getAllHotCnt(br.getValue("HOT Time count"))
                if c >= br.getValue("Flourish HOT Targets") or buff.tranquility.exists() then
                    --clearform()
                    if cast.flourish() then
                        br.addonDebug("Casting Flourish")
                        return true
                    end
                end
            end
        end

        if br.useCDs() then
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
            if br.isChecked("Racial") and (race == "Orc" or race == "Troll") then
                if br.castSpell("player", racial, false, false, false) then
                    return
                end
            end

            -- Trinkets
            if br.isChecked("Trinket 1") and br.canUseItem(13) then
                if br.getOptionValue("Trinket 1 Mode") == 1 then
                    if br.getLowAllies(br.getValue("Trinket 1")) >= br.getValue("Min Trinket 1 Targets") then
                        br.useItem(13)
                        return true
                    end
                elseif br.getOptionValue("Trinket 1 Mode") == 2 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= br.getValue("Trinket 1") then
                            br._G.UseItemByName(select(1, br._G.GetInventoryItemID("player", 13)), br.friend[i].unit)
                            return true
                        end
                    end
                elseif br.getOptionValue("Trinket 1 Mode") == 3 and #tanks > 0 then
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = br._G.UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                            -- get players in melee range of tank's target
                            local meleeFriends = br.getAllies(tankTarget, 5)
                            -- get the best ground circle to encompass the most of them
                            local loc
                            if #meleeFriends >= 8 then
                                loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                            else
                                local meleeHurt = {}
                                for j = 1, #meleeFriends do
                                    if meleeFriends[j].hp < br.getValue("Trinket 1") then
                                        br._G.tinsert(meleeHurt, meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= br.getValue("Min Trinket 1 Targets") or burst == true then
                                    loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                end
                            end
                            if loc ~= nil then
                                local px, py, pz = br._G.ObjectPosition("player")
                                loc.z = select(3, br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                if
                                loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and
                                        br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil
                                then
                                    -- Check z and LoS, ignore terrain and m2 collisions
                                    br.useItem(13)
                                    br._G.ClickPosition(loc.x, loc.y, loc.z)
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            if br.isChecked("Trinket 2") and br.canUseItem(14) then
                if br.getOptionValue("Trinket 2 Mode") == 1 then
                    if br.getLowAllies(br.getValue("Trinket 2")) >= br.getValue("Min Trinket 2 Targets") then
                        br.useItem(14)
                        return true
                    end
                elseif br.getOptionValue("Trinket 2 Mode") == 2 then
                    for i = 1, #br.friend do
                        if br.friend[i].hp <= br.getValue("Trinket 2") then
                            br._G.UseItemByName(select(1, br._G.GetInventoryItemID("player", 14)), br.friend[i].unit)
                            return true
                        end
                    end
                elseif br.getOptionValue("Trinket 2 Mode") == 3 and #tanks > 0 then
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = br._G.UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil then
                            -- get players in melee range of tank's target
                            local meleeFriends = br.getAllies(tankTarget, 5)
                            -- get the best ground circle to encompass the most of them
                            local loc
                            if #meleeFriends >= 8 then
                                loc = br.getBestGroundCircleLocation(meleeFriends, 4, 6, 10)
                            else
                                local meleeHurt = {}
                                for j = 1, #meleeFriends do
                                    if meleeFriends[j].hp < br.getValue("Trinket 2") then
                                        br._G.tinsert(meleeHurt, meleeFriends[j])
                                    end
                                end
                                if #meleeHurt >= br.getValue("Min Trinket 2 Targets") or burst == true then
                                    loc = br.getBestGroundCircleLocation(meleeHurt, 2, 6, 10)
                                end
                            end
                            if loc ~= nil then
                                local px, py, pz = br._G.ObjectPosition("player")
                                loc.z = select(3, br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                if
                                loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and
                                        br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil
                                then
                                    -- Check z and LoS, ignore terrain and m2 collisions
                                    br.useItem(13)
                                    br._G.ClickPosition(loc.x, loc.y, loc.z)
                                    return true
                                end
                            end
                        end
                    end
                elseif br.getOptionValue("Trinket 2 Mode") == 5 then
                    local Trinket13 = _G.GetInventoryItemID("player", 13)
                    local Trinket14 = _G.GetInventoryItemID("player", 14)
                    -- Generic fallback
                    if Trinket13 ~= 168905 and Trinket13 ~= 167555 then
                        if br.canUseItem(13) then
                            br.useItem(13)
                        end
                    end
                    if Trinket14 ~= 168905 and Trinket14 ~= 167555 then
                        if Trinket14 == 173944 and mana < 90 and br.canUseItem(14) then
                            br.useItem(14)
                        elseif br.canUseItem(14) then
                            br.useItem(14)
                        end
                    end
                end
            end

            -- Mana Potion
            if br.isChecked("Mana Potion") and mana <= br.getValue("Mana Potion") then
                if br.hasItem(152495) and br.canUseItem(152495) then
                    br.useItem(152495)
                end
                if br.hasItem(127835) and br.canUseItem(127835) then
                    br.useItem(127835)
                end
            end

            if br.isChecked("Auto use Pots") and burst == true then
                -- print("foo") 169300
                if br.hasItem(169300) and br.canUseItem(169300) then
                    br.useItem(169300)
                end
            end

            -- Innervate
            if br.isChecked("Auto Innervate") and cast.able.innervate() and br.getTTD("target") >= 12 and (br.player.traits.livelySpirit.active or mana < br.getValue("Auto Innervate")) then
                if cast.innervate("Player") then
                    return true
                end
            end

            -- Incarnation: Tree of Life
            if br.isChecked("Incarnation") and talent.incarnationTreeOfLife and not buff.incarnationTreeOfLife.exists() then
                if br.getLowAllies(br.getValue("Incarnation")) >= br.getValue("Incarnation Targets") then
                    if cast.incarnationTreeOfLife() then
                        return true
                    end
                end
            end
            -- Tranquility
            if br.isChecked("Tranquility") and not moving and not buff.incarnationTreeOfLife.exists() then
                if br.getLowAllies(br.getValue("Tranquility")) >= br.getValue("Tranquility Targets") then
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

        local debuffsunfirecount = debuff.sunfire.count() -- < br.getOptionValue("Max Sunfire Targets")
        local debuffmoonfirecount = debuff.moonfire.count()

        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not noDamageCheck(thisUnit) then
                if
                br.isChecked("Safe Dots") and
                        ((inInstance and #tanks > 0 and br.getDistance(thisUnit, tanks[1].unit) <= 10) or (inInstance and #tanks == 0) or
                                (inRaid and #tanks > 1 and (br.getDistance(thisUnit, tanks[1].unit) <= 10 or (br.getDistance(thisUnit, tanks[2].unit) <= 10))) or
                                solo or
                                (inInstance and #tanks > 0 and br.getDistance(tanks[1].unit) >= 90)) or
                        --need to add, or if tank is dead or
                        not br.isChecked("Safe Dots")
                then
                    if cast.able.sunfire() and mana > br.getOptionValue("DPS Save mana") then
                        if debuff.sunfire.count() == 0 then
                            if cast.sunfire(br.getBiggestUnitCluster(40, sunfire_radius), "aoe", 1, sunfire_radius) then
                                br.addonDebug("Initial Sunfire - Cluster")
                                return true
                            end
                        end
                        if (debuffsunfirecount < br.getOptionValue("Max Sunfire Targets") or br.isBoss(thisUnit)) and ttd(thisUnit) > 5 and mana > br.getOptionValue("DPS Save mana") then
                            if not debuff.sunfire.exists(thisUnit) then
                                if cast.sunfire(thisUnit, "aoe", 1, sunfire_radius) then
                                    br.addonDebug("Initial Sunfire - non-Cluster")
                                    return true
                                end
                            elseif debuff.sunfire.exists(thisUnit) and debuff.sunfire.remain(thisUnit) < 5 and ttd(thisUnit) > 5 and mana > br.getOptionValue("DPS Save mana") then
                                if cast.sunfire(thisUnit, "aoe", 1, sunfire_radius) then
                                    br.addonDebug("Refreshing sunfire - remain: " .. round(debuff.sunfire.remain(thisUnit), 3))
                                    return true
                                end
                            end
                        end
                    end

                    if (debuffmoonfirecount < br.getOptionValue("Max Moonfire Targets") or br.isBoss(thisUnit)) and ttd(thisUnit) > 5 and mana > br.getOptionValue("DPS Save mana") then
                        if cast.able.moonfire() then
                            if not debuff.moonfire.exists(thisUnit) then
                                if cast.moonfire(thisUnit) then
                                    br.addonDebug("Initial Moonfire")
                                    return true
                                end
                            elseif debuff.moonfire.exists(thisUnit) and debuff.moonfire.remain(thisUnit) < 6 and ttd(thisUnit) > 5 and mana > br.getOptionValue("DPS Save mana") then
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
        if talent.balanceAffinity and lowest.hp > br.getOptionValue("Critical HP") and mode.forms == 1 then
            if owl_combat() then
                return true
            end
        end

        if owl and #enemies.yards40 > 2 and cast.able.starfire() then
            if cast.starfire(br.getBiggestUnitCluster(45, 8)) then
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
    --unused for now

    local function cat_combat()
        --cat_dps

        if Interrupts() then
            return true
        end

        --aoe_count
        local aoe_count = 0
        for i = 1, #enemies.yards10tnc do
            local thisUnit = enemies.yards10tnc[i]
            if ttd(thisUnit) > 4 and not br.isExplosive(thisUnit) then
                aoe_count = aoe_count + 1
            end
        end

        if not cat then
            if cast.catForm("player") then
                return true
            end
        end
        --auto attack
        br._G.StartAttack(units.dyn5)

        --rush if we can -
        if talent.wildCharge and br.isChecked("Cat Charge") and #enemies.yards8 < 1 then
            local tankTarget = br._G.UnitTarget(tank) or "target"
            if br.getDistance(tankTarget) > 8 and br.getDistance(tankTarget) < 25 and (inInstance and tankTarget ~= nil or not inInstance) and br.getDistance(tankTarget, tank) < 8 then
                if cast.wildCharge(tankTarget) then
                    return true
                end
            end
        end

        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]

            -- rip,target_if=refreshable&combo_points=5
            --   if combo == 5 then
            if debuff.rip.count() < br.getOptionValue("Max RIP Targets") and not br.isExplosive(thisUnit) then
                if
                (not debuff.rip.exists(thisUnit) or
                        (debuff.rip.remain(thisUnit) < 4) and
                                (ttd(thisUnit) > (debuff.rip.remain(thisUnit) + 24) or
                                        (debuff.rip.remain(thisUnit) + combo * 4 < ttd(thisUnit) and debuff.rip.remain(thisUnit) + 4 + combo * 4 > ttd(thisUnit))))
                then
                    if cast.rip(thisUnit) then
                        br.addonDebug("[CAT-DPS] Applying Rip")
                        return true
                    end
                end
            end

            -- Rake
            if
            cast.able.rake() and (not debuff.rake.exists(thisUnit) or debuff.rake.remain(thisUnit) < 4.5) and ttd(thisUnit) >= 10 and
                    (combo < 5 or debuff.rake.remain(thisUnit) < 1) and
                    aoe_count < 4 and
                    not br.isExplosive(thisUnit)
            then
                if cast.rake(thisUnit) then
                    br.addonDebug("[CAT-DPS] Raking")
                    return true
                end
            end

            -- Ferocious Bite
            --ferocious_bite,if=(combo_points>3&target.time_to_die<3)|(combo_points=5&energy>=50&dot.rip.remains>14)&spell_targets.swipe_cat<5
            if
            cast.able.ferociousBite() and cat and combo > 3 and ttd(thisUnit) < 3 or
                    (combo == 5 and br.player.power.energy.amount() >= 40 and (debuff.rip.remain(thisUnit) > 8 or not cast.able.rip())) and #enemies.yards8 < 5 and
                            not noDamageCheck(thisUnit)
            then
                if cast.ferociousBite(thisUnit) then
                    br.addonDebug("[CAT-DPS] Bite: " .. br._G.UnitName(thisUnit) .. " Combo points: " .. combo .. " ttd: " .. ttd(thisUnit))
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

        if
        br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() and
                (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical")) and
                br.isChecked("Break form for dots") and
                (not debuff.moonfire.exists("target") or not debuff.sunfire.exists("target")) or
                not br.isChecked("Break form for dots")
        then
            return
        end
    end -- end cat loop

    local function cleanse()
        -- clearForm()

        -- Soothe
        if br.isChecked("Auto Soothe") and cast.able.soothe() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if br.canDispel(thisUnit, spell.soothe) and ttd(thisUnit) > br.getValue("Auto Soothe") then
                    if cast.soothe(thisUnit) then
                        return true
                    end
                end
            end
        end
        -- Nature's Cure / Cleanse
        --        local _, _, _, _, endCast, _, _, _, spellcastID = br._G.UnitCastingInfo(enemies.yards40[1])
        if mode.decurse == 1 then
            if #enemies.yards40 > 0 then
                spellTarget = select(3, br._G.UnitCastID(enemies.yards40[1]))
            end
            for i = 1, #friends.yards40 do
                if br.canDispel(br.friend[i].unit, spell.naturesCure)
                        and (br.getDebuffStacks(br.friend[i].unit, 240443) == 0 or br.getDebuffStacks("player", 240443) >= br.getOptionValue("Bursting")) --https://www.wowhead.com/spell=240443/burst
                        and (not br.UnitDebuffID(br.friend[i].unit, 319603) or br.UnitDebuffID(br.friend[i].unit, 319603) and br.isCasting(319592, enemies.yards40[1]) and br.GetUnitIsUnit(spellTarget, br.friend[i].unit)) -- https://www.wowhead.com/spell=319592/stone-shattering-leap
                then
                    if cast.naturesCure(br.friend[i].unit) then
                        br.addonDebug("Casting Nature's Cure")
                        return true
                    end
                end
            end
        end
    end -- end cleanse

    local function root_cc()
        if talent.mightyBash and cast.able.mightyBash() then
            for i = 1, #enemies.yards10tnc do
                local thisUnit = enemies.yards10tnc[i]
                if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) > 1 and br._G.UnitAffectingCombat(thisUnit) then
                    if cast.mightyBash(thisUnit) then
                        return true
                    end
                end
            end
        end

        local radar = "off"

        --Building root list
        local root_UnitList = {}
        if br.isChecked("Mist - Spirit vulpin") then
            root_UnitList[165251] = "Spirit vulpin"
            radar = "on"
        end
        if br.isChecked("Plague - Globgrod") then
            root_UnitList[171887] = "Globgrod"
            radar = "on"
        end
        if br.isChecked("Root - Spiteful(M+)") then
            root_UnitList[174773] = "Spiteful"
            radar = "on"
        end
        if br.isChecked("KR - root Spirit of Gold") then
            root_UnitList[131009] = "the thing from beyond"
            radar = "on"
        end
        if br.isChecked("KR - animated gold") then
            root_UnitList[135406] = "animated gold"
            radar = "on"
        end
        if debuff.thirstForBlood.exists() then
            root_UnitList[133835] = "feral-bloodswarmer"
            radar = "on"
        end

        if (root == "Mass Entanglement" and cast.able.massEntanglement()) or cast.able.entanglingRoots() then
            if radar == "on" then
                local root = 339
                local root_range = 35
                if talent.massEntanglement and cast.able.massEntanglement() then
                    root = 102359
                    root_range = 30
                end

                if lowest.hp > 45 then
                    for i = 1, br._G.GetObjectCount() do
                        local object = br._G.GetObjectWithIndex(i)
                        local ID = br._G.ObjectID(object)
                        if
                        root_UnitList[ID] ~= nil and br.getBuffRemain(object, 226510) == 0 and br.getHP(object) > 90 and not isCC(object) and not already_stunned(object) and
                                (br.getBuffRemain(object, 102359) < 2 or br.getBuffRemain(object, 339) < 2)
                        then
                            local x1, y1, z1 = br._G.ObjectPosition("player")
                            local x2, y2, z2 = br._G.ObjectPosition(object)
                            local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                            if talent.mightyBash and cast.able.mightyBash() then
                                if not debuff.mightyBash.exists(object) then
                                    if root == 339 and distance <= 8 then
                                        root = 5211
                                        root_range = 8
                                        --br._G.CastSpellByName("Mighty Bash", object)
                                    end
                                end
                            end
                            if root == 339 and br._G.UnitCreatureType(object) == CC_CreatureTypeList[i] then
                                -- Using hibernate as root if we can
                                root = 2637
                                root_range = 30
                            end
                            if distance < root_range and not br.isLongTimeCCed(object) then
                                br.addonDebug("Root: " .. tostring(root) .. " target:" .. br._G.UnitName(object) .. " Distance: " .. tostring(distance))
                                br._G.CastSpellByName(br._G.GetSpellInfo(root), object)
                            end
                        end
                    end
                end
            end -- end root
        end -- end radar
    end -- end cc_root

    local function heal()
        --checking for HE
        if br.data.settings[br.selectedSpec][br.selectedProfile]["HE ActiveCheck"] == false and br.timer:useTimer("Error delay", 3.5) then
            br._G.print("Detecting Healing Engine is not turned on.  Please activate Healing Engine to use this profile.")
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

            if
            br.isChecked("Swiftmend") and cast.able.swiftmend() and can_swiftmend(lowest.unit) and
                    (lowest.hp <= br.getValue("Swiftmend") or (talent.soulOfTheForest and burst == true and not buff.soulOfTheForest.exists())) and
                    (not inInstance or (inInstance and br.getDebuffStacks(lowest.unit, 209858) < br.getValue("Necrotic Rot")))
            then
                if cast.swiftmend(lowest.unit) then
                    return true
                end
            end

            -- Wild Growth
            if br.isChecked("Wild Growth") and cast.able.wildGrowth() and not moving then
                local lowHealthCandidates = br.getUnitsToHealAround("player", 30, br.getValue("Wild Growth"), br.getValue("Wild Growth Targets"))
                --[[      if not freemana or not buff.soulOfTheForest.exists() then
                          for i = 1, #br.friend do
                              if br._G.UnitInRange(br.friend[i].unit) then
                                  lowHealthCandidates = getUnitsToHealAround(br.friend[i].unit, 30, br.getValue("Wild Growth"), #br.friend)
                                  --local lowHealthCandidates2 = getUnitsToHealAround(br.friend[i].unit, 30, br.getValue("Soul of the Forest + Wild Growth"), #br.friend)
                              end
                          end
                      end
                  ]]
                if (#lowHealthCandidates >= br.getValue("Wild Growth Targets") or freemana or buff.soulOfTheForest.exists()) then
                    if cast.wildGrowth(lowest.unit) then
                        return true
                    end
                end
            end

            if talent.nourish and cast.able.nourish() and count_hots(lowest.unit) >= br.getValue("Nourish - hot count") then
                if cast.nourish(lowest.unit) then
                    br.addonDebug("[HEAL]nourish on: " .. br._G.UnitName(lowest.unit))
                    return true
                end
            end

            --lifebloom
            local lifebloom_count = 0
            local raid_bloom_target = "none"
            local kill_boss
            local bloom_count_max = 0

            if inCombat and br.isChecked("Lifebloom") and lastSpell ~= spell.lifebloom then
                if br.druid.using_lifebloom then
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
                    if br._G.UnitExists("focus") and not br.GetUnitIsDeadOrGhost("focus") and br._G.UnitAffectingCombat("focustarget") and br.hasThreat("focus") and br.getLineOfSight("focus", "player") then
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
                                if br._G.UnitInRange(br.friend[i].unit) and br.friend[i].hp <= br.getValue("Photosynthesis") then
                                    lifebloom_count = lifebloom_count + 1
                                end
                            end
                            if
                            (lifebloom_count >= br.getValue("Photosynthesis Count") or bursting) and
                                    (not buff.lifebloom.exists("Player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5 and php < 80))
                            then
                                raid_bloom_target = "player"
                                br.addonDebug("Lifebloom on healer(photo) - [" .. lifebloom_count .. "/" .. br.getValue("Photosynthesis Count") .. "]")
                            else
                                raid_bloom_target = "tank"
                                br.addonDebug("Lifebloom on tank(photo)- [" .. lifebloom_count .. "/" .. br.getValue("Photosynthesis Count") .. "]")
                            end
                        end

                        if br._G.GetTime() - x > br.getValue("Lifebloom") and raid_bloom_target == "none" or raid_bloom_target == "tank" then
                            tanks = br.getTanksTable()
                            if #tanks > 0 then
                                for i = 1, #tanks do
                                    --if not focus, check critical health on tanks
                                    if br.isChecked("Critical HP") and br.getHP(tanks[i].unit) < br.getValue("Critical HP") then
                                        raid_bloom_target = tanks[i].unit
                                        break
                                    else
                                        --stick it on the tank that has aggro
                                        if br._G.UnitExists("boss1target") then
                                            kill_boss = "boss1target"
                                        elseif br._G.UnitExists("boss2target") then
                                            kill_boss = "boss2target"
                                        end
                                        if
                                        kill_boss and cast.able.lifebloom(tanks[i].unit) and br._G.UnitThreatSituation(tanks[i].unit, kill_boss) ~= nil and
                                                br._G.UnitThreatSituation(tanks[i].unit, kill_boss) > 2 and
                                                br.getLineOfSight("player", tanks[i].unit)
                                        then
                                            raid_bloom_target = tanks[i].unit
                                            break
                                        else
                                            raid_bloom_target = tanks[1].unit
                                        end
                                    end
                                end
                            else
                                --     Print(" ERROR - tanks: " .. tostring(#tanks))
                                raid_bloom_target = "player"
                            end
                        end
                        -- cast bloom
                        if raid_bloom_target ~= "none" and br.getLineOfSight("player", raid_bloom_target) and buff.lifebloom.remain(raid_bloom_target) < 4.5 then
                            --  (not buff.lifebloom.exists(raid_bloom_target) or (buff.lifebloom.exists(raid_bloom_target) and
                            if cast.lifebloom(raid_bloom_target) then
                                br.addonDebug("Bloom_target: " .. br._G.UnitName(raid_bloom_target))
                                raid_bloom_target = "none"
                                -- I want to set a timer here
                                x = br._G.GetTime()
                                --   Print(tostring(x))
                                return true
                            end
                        end
                    end
                end
            end
            if 1 == 2 then
                if not br.druid.using_lifebloom then
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
                                if br._G.UnitInRange(br.friend[i].unit) and br.friend[i].hp <= br.getValue("Photosynthesis") then
                                    lifebloom_count = lifebloom_count + 1
                                end
                            end
                            if
                            (lifebloom_count >= br.getValue("Photosynthesis Count") or bursting) and
                                    (not buff.lifebloom.exists("Player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5 and php < 80))
                            then
                                if cast.lifebloom("player") then
                                    br.addonDebug("Lifebloom on healer(photo) - [" .. lifebloom_count .. "/" .. br.getValue("Photosynthesis Count") .. "]")
                                    return true
                                end
                            elseif
                            lifebloom_count < br.getValue("Photosynthesis Count") and
                                    (not buff.lifebloom.exists(tank) or (buff.lifebloom.exists(tank) and buff.lifebloom.remain(tank) < 4.5 and br.getHP(tank) < 80))
                            then
                                if cast.lifebloom(tank) then
                                    br.addonDebug("Lifebloom on tank(photo)- [" .. lifebloom_count .. "/" .. br.getValue("Photosynthesis Count") .. "]")
                                    return true
                                end
                            end
                        elseif
                        talent.photosynthesis and not cast.last.lifebloom(1) and (inRaid or #tanks > 1) and buff.lifebloom.remains() < 2 and
                                not runeforge.theDarkTitansLesson.equiped
                        then
                            if cast.lifebloom("player") then
                                br.addonDebug("Lifebloom on healer(photo) - [" .. lifebloom_count .. "/" .. br.getValue("Photosynthesis Count") .. "]")
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
                        raid_bloom_target = "none"
                        if
                        runeforge.theDarkTitansLesson.equiped and
                                (not buff.lifebloom.exists("player") or (buff.lifebloom.exists("player") and buff.lifebloom.remain("player") < 4.5))
                        then
                            if cast.lifebloom("player") then
                                return true
                            end
                        end
                        -- keep it on focus
                        if
                        br._G.UnitExists("focustarget") and not br.GetUnitIsDeadOrGhost("focustarget") and br._G.UnitAffectingCombat("focustarget") and br.hasThreat("focustarget") and
                                br.getLineOfSight("focustarget", "player")
                        then
                            raid_bloom_target = "focustarget"
                        end
                        if raid_bloom_target == "none" then
                            for i = 1, #tanks do
                                tank = tanks[i].unit
                                --if not focus, check critical health on tanks
                                if br.isChecked("Critical HP") and br.getHP(tank) < br.getValue("Critical HP") then
                                    raid_bloom_target = tank
                                    break
                                else
                                    --stick it on the tank that has aggro
                                    br._G.print("Tell Laks this: " .. tostring(br._G.UnitThreatSituation(tank, "boss1target")))
                                    if
                                    cast.able.lifebloom(tank) and br._G.UnitThreatSituation(tank, "boss1target") ~= nil and br._G.UnitThreatSituation(tank, "boss1target") > 2 and
                                            br.getLineOfSight("player", tank)
                                    then
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

            if br.isChecked("Grievous Wounds") then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
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

                    local hotvalue = br.getValue("Grievous Wounds")
                    local grievance_value = 90

                    if br.friend[i].hp < grievance_value - (hotCount * hotvalue) and br._G.UnitInRange(br.friend[i].unit) or br.GetUnitIsUnit(br.friend[i].unit, "player") then
                        --count grievance stacks here
                        local CurrentBleedstack = br.getDebuffStacks(br.friend[i].unit, 240559)
                        if br.getDebuffStacks(br.friend[i].unit, 240559) > 0 then
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
                    if br.isChecked("Decaying Mind") then
                        local CurrentBleedstack = br.getDebuffStacks(br.friend[i].unit, 278961)
                        if br.getDebuffStacks(br.friend[i].unit, 278961) > 0 then
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
                    if br.isChecked("Efflorescence") then
                        if inCombat and #tanks > 0 and br.botSpell ~= spell.efflorescence and not buff.springblossom.exists(tanks[1].unit) and br._G.GetTotemTimeLeft(1) < 20 then
                            local tankTarget = br._G.UnitTarget(tanks[1].unit)
                            if tankTarget ~= nil and br.getDistance(tankTarget, "player") < 40 then
                                local meleeFriends = br.getAllies(tankTarget, 8)
                                local loc = br.getBestGroundCircleLocation(meleeFriends, 1, 6, 10)
                                if loc ~= nil then
                                    local px, py, pz = br._G.ObjectPosition("player")
                                    loc.z = select(3, br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                    if
                                    loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and
                                            br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil
                                    then
                                        -- Check z and LoS, ignore terrain and m2 collisions
                                        if cast.efflorescence() then
                                            br._G.ClickPosition(loc.x, loc.y, loc.z)
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
                if can_swiftmend(BleedFriend.unit) then
                    if cast.swiftmend(BleedFriend.unit) then
                        return true
                    end
                end
                if cast.able.regrowth() then
                    if not buff.regrowth.exists(BleedFriend.unit) or BleedFriend.hp < br.getValue("Grievous") then
                        if cast.regrowth(BleedFriend.unit) then
                            return true
                        end
                    end
                end
            end -- end grievance

            -- cenarionWard
            if not br.isChecked("Smart Hot") and br.isChecked("Cenarion Ward") and talent.cenarionWard then
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
            if br.isChecked("Efflorescence") and inCombat then
                if inInstance and talent.springBlossoms then
                    if inCombat and #tanks > 0 and br.botSpell ~= spell.efflorescence and not buff.springblossom.exists(tanks[1].unit) and br._G.GetTotemTimeLeft(1) < 20 then
                        local tankTarget = br._G.UnitTarget(tanks[1].unit)
                        if tankTarget ~= nil and br.getDistance(tankTarget, "player") < 40 then
                            local meleeFriends = br.getAllies(tankTarget, 8)
                            local loc = br.getBestGroundCircleLocation(meleeFriends, 1, 6, 10)
                            if loc ~= nil then
                                local px, py, pz = br._G.ObjectPosition("player")
                                loc.z = select(3, br._G.TraceLine(loc.x, loc.y, loc.z + 5, loc.x, loc.y, loc.z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
                                if
                                loc.z ~= nil and br._G.TraceLine(px, py, pz + 2, loc.x, loc.y, loc.z + 1, 0x100010) == nil and
                                        br._G.TraceLine(loc.x, loc.y, loc.z + 4, loc.x, loc.y, loc.z, 0x1) == nil
                                then
                                    -- Check z and LoS, ignore terrain and m2 collisions
                                    if cast.efflorescence() then
                                        br._G.ClickPosition(loc.x, loc.y, loc.z)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                elseif #br.friend > 1 then
                    if cast.able.efflorescence(7) and br._G.GetTotemTimeLeft(1) < 20 then
                        local tankTarget = br._G.UnitTarget(tanks[1].unit)
                        local meleeFriends = br.getAllies(tankTarget, 5)
                        if br.castWiseAoEHeal(meleeFriends, spell.efflorescence, 10, 100, 1, 5, true, false) then
                            return true
                        end
                    end
                end
            end
            --

            -- Rejuvenation
            if br.isChecked("Rejuvenation") then
                for i = 1, #tanks do
                    if
                    talent.germination and (tanks[i].hp <= br.getValue("Germination Tank") or freemana) and
                            (not buff.rejuvenationGermination.exists(tanks[i].unit) or buff.rejuvenationGermination.remain(tanks[i].unit) < 4.5)
                    then
                        if cast.rejuvenation(tanks[i].unit) then
                            br.addonDebug("[Rejuv]Germination on: " .. tanks[i].unit)
                            return true
                        end
                    elseif
                    not talent.germination and (tanks[i].hp <= br.getValue("Rejuvenation Tank") or freemana) and
                            (not buff.rejuvenation.exists(tanks[i].unit) or buff.rejuvenation.remain(tanks[i].unit) < 4.5)
                    then
                        if cast.rejuvenation(tanks[i].unit) then
                            br.addonDebug("[Rejuv]rejuvenation on: " .. br._G.UnitName(tanks[i].unit))
                            return true
                        end
                    end
                end
                for i = 1, #br.friend do
                    if
                    talent.germination and (br.friend[i].hp <= br.getValue("Germination") or freemana) and
                            (not buff.rejuvenationGermination.exists(br.friend[i].unit) or buff.rejuvenationGermination.remain(br.friend[i].unit) < 4.5)
                    then
                        if cast.rejuvenation(br.friend[i].unit) then
                            br.addonDebug("[Rejuv]Germination on: " .. br._G.UnitName(br.friend[i].unit))
                            return true
                        end
                    elseif
                    (br.friend[i].hp <= br.getValue("Rejuvenation") or freemana) and
                            (not buff.rejuvenation.exists(br.friend[i].unit) or buff.rejuvenation.remain(br.friend[i].unit) < 4.5)
                    then
                        if cast.rejuvenation(br.friend[i].unit) then
                            br.addonDebug("[Rejuv]rejuvenation on: " .. br._G.UnitName(br.friend[i].unit))
                            return true
                        end
                    end
                end
            end

            -- Regrowth
            if not moving or buff.incarnationTreeOfLife.exists() then
                for i = 1, #br.friend do
                    if
                    br.isChecked("Regrowth Tank") and br.friend[i].hp <= br.getValue("Regrowth Tank") and
                            (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and
                            (not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot")))
                    then
                        if cast.regrowth(br.friend[i].unit) then
                            return true
                        end
                    elseif
                    br.isChecked("Regrowth") and br.friend[i].hp <= br.getValue("Regrowth") and
                            (not inInstance or (inInstance and br.getDebuffStacks(br.friend[i].unit, 209858) < br.getValue("Necrotic Rot")))
                    then
                        if cast.regrowth(br.friend[i].unit) then
                            return true
                        end
                    elseif br.isChecked("Regrowth Clearcasting") and br.friend[i].hp <= br.getValue("Regrowth Clearcasting") and buff.clearcasting.remain() > gcdMax then
                        if cast.regrowth(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end
    end -- end heal

    local function travel_rest()
        if br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
            if not br._G.IsIndoors() and not travel then
                if cast.travelForm("player") then
                    return
                end
            elseif br._G.IsIndoors() and not cat then
                if cast.catForm("player") then
                    return
                end
            end
        end

        --rush if we can -
        if talent.wildCharge then
            if br._G.CastSpellByID(102417, "player") then
                return true
            end
        end

        if br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() then
            return
        end
    end

    local function travel_combat()
        if not br._G.IsIndoors() and not travel then
            if cast.travelForm("player") then
                return
            end
        elseif br._G.IsIndoors() and not cat then
            if cast.catForm("player") then
                return
            end
        end
        --rush if we can -
        if talent.wildCharge then
            if br._G.CastSpellByID(102417, "player") then
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

        br._G.StartAttack()

        if br.isChecked("Bear Frenzies Regen HP") and talent.guardianAffinity and cast.able.frenziedRegeneration() and php <= br.getValue("Bear Frenzies Regen HP") then
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

        if br.isChecked("auto stealth") then
            if not br.player.buff.prowl.exists() then
                if cast.prowl("Player") then
                    return true
                end
            end
        end

        if br.isChecked("auto dash") and not catspeed then
            if cast.stampedingRoarCat("player") then
                return true
            end
            if talent.tigerDash then
                if cast.tigerDash() then
                    return true
                end
            end
            if cast.dash() then
                return true
            end
        end

        if br.player.buff.prowl.exists() and cast.able.rake() then
            for i = 1, #enemies.yards10tnc do
                --if our target is engaged with our tank
                local thisUnit = enemies.yards10tnc[i]
                if #tanks > 0 and br._G.UnitThreatSituation(tanks[1].unit, thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) or solo then
                    if cast.rake(thisUnit) then
                        return
                    end
                end
            end
        end

        if
        br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() and
                (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical"))
        then
            return
        end
    end

    local function pre_combat()
        -- clearForm()
        if not cat and not travel and not bear then
            local tank_unit

            if (#tanks > 0 or br._G.UnitExists("focus")) and (mode.prehot == 1 or mode.prehot == 2) and mode.hEALS == 1 then
                if runeforge.theDarkTitansLesson.equiped then
                    if not buff.lifebloom.exists("player") then
                        if cast.lifebloom("player") then
                            br.addonDebug("[BLOOM][PRE] Lifebloom on player")
                            return true
                        end
                    end
                end

                if br._G.UnitExists("focus") then
                    tank_unit = "focus"
                else
                    if tanks[1] ~= nil then
                        tank_unit = tanks[1].unit
                    end
                end

                if tank_unit and br.getLineOfSight("player", tank_unit) then
                    -- cenarionWard
                    if
                    not br.isChecked("Smart Hot") and talent.cenarionWard and br.isChecked("Cenarion Ward") and not buff.cenarionWard.exists(tank_unit) and
                            cast.able.cenarionWard(tank_unit) and
                            br.getLineOfSight(tank_unit, "player")
                    then
                        if cast.cenarionWard(tank_unit) then
                            br.addonDebug("[PRE-HOT]:CW on: " .. br._G.UnitName(tank_unit))
                            return true
                        end
                    end

                    if cast.able.lifebloom(tank_unit) and not buff.lifebloom.exists(tank_unit) then
                        if cast.lifebloom(tank_unit) then
                            br.addonDebug("[PRE-HOT]:Lifebloom on: " .. br._G.UnitName(tank_unit))
                            return true
                        end
                    end
                    if runeforge.theDarkTitansLesson.equiped and not buff.lifebloom.exists("player") then
                        if cast.lifebloom("player") then
                            br.addonDebug("[PRE-HOT]:Lifebloom on: " .. br._G.UnitName("player"))
                            return true
                        end
                    end
                    if talent.germination and cast.able.rejuvenation(tank_unit) and not buff.rejuvenationGermination.exists(tank_unit) then
                        if cast.rejuvenation(tank_unit) then
                            br.addonDebug("[PRE-HOT]Germination on: " .. br._G.UnitName(tank_unit))
                            return true
                        end
                    elseif not buff.rejuvenation.exists(tank_unit) and cast.able.rejuvenation(tank_unit) then
                        if cast.rejuvenation(tank_unit) then
                            br.addonDebug("[PRE-HOT]Rejuv on: " .. br._G.UnitName(tank_unit))
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
    if
    br.pause() or br._G.IsMounted() or flying or drinking or br.isCastingSpell(spell.tranquility) or br.isCasting(spell.replicaOfKnowledge) or br.isCasting(293491) or br.hasBuff(250873) or
            br.hasBuff(115834) or
            br.hasBuff(58984) or
            br.hasBuff(185710) or
            buff.soulshape.exists()
    then
        --or stealthed (travel and not inCombat) or
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        if not inCombat then
            --[[
               -- using crystal if we got no flask or crystal buff
               if not br.hasBuff(298837) and not br.hasBuff(176151) and br.hasItem(118922) and br.canUseItem(118922) then
                   if br.useItem(118922) then
                       return true
                   end
               end
            ]]
            local friendlydeadcount = 0
            local friendlydeadcountinrange = 0
            if br.isChecked("Auto mass Resurrection") then
                for i = 1, #br.friend do
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") then
                        friendlydeadcount = friendlydeadcount + 1
                    end
                    if br._G.UnitIsPlayer(br.friend[i].unit) and br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit, "player") and br._G.UnitInRange(br.friend[i].unit) then
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
            if br.isChecked("Auto Drink") and mana <= br.getOptionValue("Auto Drink") and not moving and br.getDebuffStacks("player", 240443) == 0 and br.getDebuffStacks("player", 240443) == 0 then
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
                if not br.isChecked("Sugar Crusted Fish Feast") or (br.isChecked("Sugar Crusted Fish Feast") and not br.hasItem(126936)) and not br.hasBuff(185710) then
                    if br.hasItem(65499) and br.canUseItem(65499) then
                        br.useItem(65499)
                    end
                    if br.hasItem(113509) and br.canUseItem(113509) then
                        br.useItem(113509)
                    end
                    if br.hasItem(177040) and br.canUseItem(177040) then
                        br.useItem(177040)
                    end
                    if br.hasItem(178217) and br.canUseItem(178217) then
                        br.useItem(178217)
                    end
                    if br.hasItem(173859) and br.canUseItem(173859) then
                        br.useItem(173859)
                    end
                elseif br.isChecked("Sugar Crusted Fish Feast") and br.hasItem(126936) then
                    local x1, y1, z1 = br._G.ObjectPosition("player")
                    br.addonDebug("scaninning -  fish thingy")
                    for i = 1, br._G.GetObjectCount() do
                        local object = br._G.GetObjectWithIndex(i)
                        local ID = br._G.ObjectID(object)
                        local x2, y2, z2 = br._G.ObjectPosition(object)
                        local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
                        if ID == 242405 and distance < 15 then
                            --print(tostring(distance))
                            br._G.InteractUnit(object)
                            fishfeast = 1
                            return true
                        else
                            if br.hasItem(126936) and br.canUseItem(126936) and fishfeast == 0 then
                                br.useItem(126936)
                                x1 = x1 + math.random(-2, 2)
                                br._G.ClickPosition(x1, y1, z1)
                                br.addonDebug("Placing fish thingy")
                                fishfeast = 1
                                return true
                            end
                        end
                    end
                end
            end

            if br.isChecked("Break form for dispel") then
                if cleanse() then
                    return true
                end
            end
            if mode.forms == 2 then
                if
                br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() and
                        (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical"))
                then
                    cat_rest()
                    return true
                elseif
                br.SpecificToggle("Owl Key") and not br._G.GetCurrentKeyBoardFocus() and
                        (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical"))
                then
                    owl_rest()
                    return true
                elseif br.SpecificToggle("Bear Key") and not br._G.GetCurrentKeyBoardFocus() then
                    bear_rest()
                    return true
                elseif
                br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() and
                        (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical"))
                then
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
                if br.isChecked("OOC Healing") then
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

        if inCombat and not br.UnitBuffID("player", 115834) then
            if br.isChecked("Break form for dispel") then
                if cleanse() then
                    return true
                end
            end
            if mode.forms == 2 then
                if
                br.SpecificToggle("Cat Key") and not br._G.GetCurrentKeyBoardFocus() and
                        (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical")) and
                        (br.isChecked("Break form for dots") and (debuff.moonfire.exists("target") and debuff.sunfire.exists("target")) or not br.isChecked("Break form for dots"))
                then
                    cat_combat()
                    return true
                elseif
                br.SpecificToggle("Owl Key") and not br._G.GetCurrentKeyBoardFocus() and
                        (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical"))
                then
                    owl_combat()
                    return true
                elseif br.SpecificToggle("Bear Key") and not br._G.GetCurrentKeyBoardFocus() then
                    bear_combat()
                    return true
                elseif
                br.SpecificToggle("Travel Key") and not br._G.GetCurrentKeyBoardFocus() and
                        (br.isChecked("Break form for critical") and lowest.hp > br.getOptionValue("Critical HP") or not br.isChecked("Break form for critical"))
                then
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
                if br.isChecked("pre-hot in combat") or buff.incarnationTreeOfLife.exists() then
                    if pre_combat() then
                        return true
                    end
                end
                if mode.dPS == 1 and lowest.hp > br.getValue("DPS Min % health") and mana >= br.getValue("DPS Save mana") then
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
br._G.tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)

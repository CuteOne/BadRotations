local rotationName = "LyLoLoq"

--------------
--- COLORS ---
--------------
local colorBlue         = "|cff00CCFF"  
local colorGreen        = "|cff00FF00"  
local colorRed          = "|cffFF0000"  
local colorWhite        = "|cffFFFFFF"  
local colorGold         = "|cffFFDD11"  
local colordk           = "|cffC41F3B"  
local colordh           = "|cffA330C9"  
local colordrood        = "|cffFF7D0A"  
local colorhunter       = "|cffABD473"  
local colormage         = "|cff69CCF0"  
local colormonk         = "|cff00FF96"  
local colorpala         = "|cffF58CBA"  
local colorpriest       = "|cffFFFFFF"  
local colorrogue        = "|cffFFF569"  
local colorshaman       = "|cff0070DE"  
local colorwarlock      = "|cff9482C9"  
local colorwarrior      = "|cffC79C6E"  
local colorLegendary    = "|cffff8000"
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection", highlight = 1, icon = br.player.spell.lifeCocoon },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target", highlight = 1, icon = br.player.spell.lifeCocoon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used", highlight = 0, icon = br.player.spell.lifeCocoon }
    };
    CreateButton("Cooldown",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",2,0)
    -- Dispell
    DispellModes = {
        [1] = { mode = "On", value = 1 , overlay = "Dispell Enabled", tip = "Include dispell", highlight = 1, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2 , overlay = "Dispell Disabled", tip = "No detox will be used", highlight = 0, icon = br.player.spell.detox }
    };
    CreateButton("Dispell",3,0)
    -- DPS Button
    DPSModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "DPS Enabled", highlight = 1, icon = br.player.spell.risingSunKick },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Disabled", tip = "DPS Disabled", highlight = 0, icon = br.player.spell.risingSunKick }
    };
    CreateButton("DPS",4,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.legSweep },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Interrupt",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        --------------
        --- OPTIONS ---
        --------------

       -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createCheckbox(section,"OOC Healing",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables".. colorWhite.."out of combat healing.",1)
		br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  colorWhite.."Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:createDropdown(section, "Roll/Chi Torpedo Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Roll/Chi Torpedo with Key.",colorWhite.."Set hotkey to use Roll/Chi Torpedo with key.")
        br.ui:createDropdown(section, "Transcendence/Transcendence:Transfer Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Transcendence/Transcendence:Transfer with Key.",colorWhite.."Set hotkey to use Transcendence/Transcendence:Transfer with key.")
        br.ui:createCheckbox(section, "Tiger's Lust", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Tiger's Lust"..colorBlue.." (Auto use on snare and root).")
        br.ui:createDropdown(section, "Tiger's Lust Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Tiger's Lust with Key.",colorWhite.."Set hotkey to use Tiger's Lust with key.")
        br.ui:createDropdown(section, "Ring Of Peace Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Ring Of Peace with Key on "..colorRed.."Cursor",colorWhite.."Set hotkey to use Ring Of Peace with key.")
		br.ui:createCheckbox(section, "DOT cast EM", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables"..colorWhite.."Cast EM on important debuffs.")
        br.ui:createSpinnerWithout(section, "DPS",  90,  0,  100,  1,  colorWhite.." Dps when lowest health >= ")
        br.ui:checkSectionState(section)

        -- Boss Section
        section = br.ui:createSection(br.ui.window.profile, "Boss Mods Settings")
        br.ui:createCheckbox(section,colorwarlock.."Find Illidan",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables".. colorWhite.."Find Illidan in KJ encounter.",1)
        br.ui:checkSectionState(section)

        -- Tier Section
        section = br.ui:createSection(br.ui.window.profile, "Tier Settings")
        br.ui:createSpinner(section, colormonk.."Enveloping Mist with Surge of Mist",  65,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Trigger t20 4piece bonus", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormonk.."Min Enveloping Mist with Surge of Mist Targets",  2,  1,  3,  1,  colorBlue.."Minimum Trigger t20 4p bonus Targets "..colorGold.."(This includes you)")
		br.ui:createSpinner(section, colormonk.."Emergency Enveloping Mist with Surge of Mist",  65,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Emergency cast when Surge of Mist duration < 5 sec to don't lose the Surge of Mist proc", colorWhite.."Health Percent to Cast At")
        br.ui:checkSectionState(section)

        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldown")
        br.ui:createSpinner(section, colorshaman.."Revival",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Revival.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Min Revival Targets",  3,  1,  40,  1,  colorBlue.."Minimum Revival Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colorshaman.."Invoke Chi-Ji, the Red Crane",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Invoke Chi-Ji, the Red Crane.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Min Invoke Chi-Ji, the Red Crane Targets",  3,  1,  40,  1,  colorBlue.."Minimum Invoke Chi-Ji, the Red Crane Targets "..colorGold.."(This includes you)")
		br.ui:createSpinner(section, colorshaman.."Life Cocoon",  20,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Life Cocoon.", colorWhite.."Health Percent to Cast At")
        br.ui:createDropdownWithout(section, colorshaman.."Life Cocoon Target", {colorGreen.."Player",colorBlue.."Target",colorWhite.."Mouseover",colorRed.."Tank",colorGreen.."Healer",colorGreen.."Healer/Tank",colorBlue.."Any"}, 6, colorWhite.."Target to cast on")
        br.ui:createSpinner(section, colorshaman.."Trinket 1",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Trinket 1.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Min Trinket 1 Targets",  1,  1,  40,  1,  colorBlue.."Minimum Trinket 1 Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colorshaman.."Trinket 2",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Trinket 2.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Min Trinket 2 Targets",  1,  1,  40,  1,  colorBlue.."Minimum Trinket 2 Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colorshaman.."Mana Tea",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Mana Tea.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Mana Tea - Life",  50,  0,  100,  1,  colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Min Mana Tea Targets",  3,  1,  40,  1,  colorBlue.."Minimum Low Life Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colorshaman.."Arcane Torrent",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Arcane Torrent to mana recover.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinner(section, colorshaman.."Mana Potion",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Ancient Mana Potion.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinner(section, colorshaman.."Thunder Focus Tea + Vivify",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Vivify.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Thunder Focus Tea + Vivify - Mana",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Vivify.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinner(section, colorshaman.."Thunder Focus Tea + Renewing Mist", 50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Renewing Mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinner(section, colorshaman.."Thunder Focus Tea + Enveloping Mist",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Enveloping Mist.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinner(section, colorshaman.."Thunder Focus Tea + Essence Font",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Essence Font.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, colorshaman.."Min Thunder Focus Tea + Essence Font Targets",  5,  1,  40,  1,  colorBlue.."Minimum Thunder Focus Tea + Essence Font Targets "..colorGold.."(This includes you)")     
		br.ui:createSpinner(section, colorshaman.."Gnawed Thumb Ring",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Gnawed Thumb Ring.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Min Gnawed Thumb Ring Targets",  3,  1,  40,  1,  colorBlue.."Minimum Gnawed Thumb Ring Targets "..colorGold.."(This includes you)")
		br.ui:createCheckbox(section, colorshaman.."The Deceiver's Grand Design")
		br.ui:createSpinner(section, colorshaman.."Archive of Faith", 50, 0, 100, 5, "","|cffFFFFFFTanks Health Percent to Cast At")		
        br.ui:createSpinner(section, colorshaman.."Velen's Future Sight",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Velen's Future Sight.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colorshaman.."Min Velen's Future Sight Targets",  3,  1,  40,  1,  colorBlue.."Minimum Velen's Future Sight Targets "..colorGold.."(This includes you)")
        br.ui:createDropdownWithout(section, colorshaman.."Velen's Future Sight logic", {colorGreen.."Full Automatic",colorBlue.."Use Settings"}, 1, colorWhite.."Cast it automatic with other CD's or follow settings above")
        br.ui:checkSectionState(section)

        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, colorwarrior.."Healing Elixir/Diffuse Magic/Dampen Harm",  40,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Healing Elixir/Diffuse Magic/Dampen Harm.", colorWhite.."Health Percent to Cast At")
        br.ui:createDropdown(section, colorwarrior.."Healing Elixir/Diffuse Magic/Dampen Harm Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Healing Elixir/Diffuse Magic/Dampen Harm with Key.",colorWhite.."Set hotkey to use Healing Elixir/Diffuse Magic/Dampen Harm with key.")
        br.ui:createSpinner(section, colorwarrior.."Fortifying Brew",  40,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Fortifying Brew.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinner(section, colorwarrior.."Healthstone",  30,  0,  100,  5,  colorWhite.."Health Percent to Cast At")
        br.ui:checkSectionState(section)

        -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinner(section, colormage.."Essence Font",  60,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Essence Font.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Essence Font Targets",  5,  1,  40,  1,  colorBlue.."Minimum Essence Font Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colormage.."Refreshing Jade Wind",  60,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Refreshing Jade Wind.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Refreshing Jade Wind Targets",  3,  1,  40,  1,  colorBlue.."Minimum Refreshing Jade Wind "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colormage.."Chi Burst",  70,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Chi Burst.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Chi Burst Targets",  3,  1,  40,  1,  colorBlue.."Minimum Chi Burst Targets "..colorGold.."(This includes you)")
        --br.ui:createCheckbox(section,"Show Lines",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Lines of Chi Burst.")
        br.ui:createSpinner(section, colormage.."Vivify",  80,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Vivify Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colormage.."Vivify with Lifecycles",  85,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Lifecycles.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Vivify with Lifecycles Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Lifecycles Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colormage.."Vivify with Uplift",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Uplift.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Vivify with Uplift Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Uplift Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colormage.."Vivify with Lifecycles + Uplift",  95,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Lifecycles + Uplift.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Vivify with Lifecycles + Uplift Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Lifecycles + Uplift Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colormage.."Vivify with Dance Of Mist",  85,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Dance of mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Min Vivify with Dance Of Mist Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Dance of Mist Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, colormage.."Sheilun's Gift",  70,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Sheilun's Gift.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Sheilun's Gift Charges",  5,  1,  12,  1,  colorBlue.."Minimum Sheilun's Gift charges")
        br.ui:createSpinner(section, colormage.."Enveloping Mist",  75,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Enveloping Mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createCheckbox(section, colormage.."Enveloping Mist - Tank Only", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Enveloping Mist on tank only.")
        br.ui:createSpinner(section, colormage.."Enveloping Mist with Lifecycles",  65,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Enveloping Mist.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinner(section, colormage.."Zen Pulse",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Zen Pulse.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, colormage.."Zen Pulse Enemies",  3,  1,  100,  1,  colorBlue.."Minimum Zen Pulse Enemies")
        br.ui:createCheckbox(section, colormage.."Effuse", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Effuse.")
        br.ui:createSpinnerWithout(section, colormage.."Effuse Greater or equals",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Effuse.", colorWhite.."Health Percent to Cast At. (Exemple: Effuse Greater or equals 80% and <= 100%)")
        br.ui:createSpinnerWithout(section, colormage.."Effuse Less or equals",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Effuse.", colorWhite.."Health Percent to Cast At. (Exemple: Effuse Greater or equals 80% and <= 100%)")
        br.ui:createSpinner(section, colormage.."Renewing Mist",  100,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Renewing Mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createCheckbox(section,colormage.."Renewing Mist - On CD",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Renewing Mist on CD regardless in combat.")
        --        br.ui:createSpinner(section, "Mistwalk",  80,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Mistwalk.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinner(section, colormage.."Chi Wave",  80,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Chi Wave.", colorWhite.."Health Percent to Cast At")
        br.ui:createDropdown(section, colormage.."Summon Jade Serpent", {colorGreen.."Player",colorBlue.."Target",colorRed.."Tank"}, 3,colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Summon Jade Serpent.", colorWhite.."Use Summon Jade Serpent at location of.")
        br.ui:checkSectionState(section)


        --Offensive Options
        section = br.ui:createSection(br.ui.window.profile, "Offensive")
        br.ui:createCheckbox(section, colordh.."Crackling Jade Lightning",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."the use of Crackling Jade Lightning.")
		br.ui:createCheckbox(section, colordh.."Rising Sun Kick", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Rising Sun Kick on DPS rotation")
		br.ui:createCheckbox(section, colordh.."Spinning Crane Kick", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Spinning Crane Kick on DPS rotation")
        br.ui:checkSectionState(section)


        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
        br.ui:createCheckbox(section, colorrogue.."Leg Sweep",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Leg Sweep.")
        br.ui:createCheckbox(section, colorrogue.."Paralysis",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Paralysis.")
        br.ui:checkSectionState(section)

        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section,  "Interrupt at",  50,  0,  100,  1,  colorBlue.."Cast Percentage to use at.")
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
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Dispell",0.25)
    UpdateToggle("DPS",0.25)
    UpdateToggle("Interrupt",0.25)
    br.player.mode.dispell = br.data.settings[br.selectedSpec].toggles["Dispell"]
    br.player.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]
    br.player.mode.interrupt = br.data.settings[br.selectedSpec].toggles["Interrupt"]

    --------------
    --- Locals ---
    --------------
    local cast                                          = br.player.cast
    local talent                                        = br.player.talent
    local cd                                            = br.player.cd
    local buff                                          = br.player.buff
    local spell                                         = br.player.spell
    local inCombat                                      = br.player.inCombat
    local useDispell                                    = br.player.mode.dispell == 1
    local useDPS                                        = br.player.mode.dps == 1
    local php                                           = br.player.health
    local healPot                                       = getHealthPot()
    local mana                                          = br.player.power.mana.percent()
    local debuff                                        = br.player.debuff
    local gcd                                           = br.player.gcd
	local gcdMax										= br.player.gcdMax
    local drinking                                      = UnitBuffID("player",192002) ~= nil or UnitBuffID("player",167152) ~= nil or UnitBuffID("player",192001) ~= nil
    local racial                                        = br.player.getRacial()
    local use                                           = br.player.use

	local pullTimer                                     = br.DBM:getPulltimer()
    local inRaid                                        = br.player.instance=="raid"

    local lowest                                        = br.friend[1]
    local lossPercent                                   = getHPLossPercent(lowest.unit,5)
    local enemies                                       = enemies or {}
    local friends                                       = friends or {}
	local tanks                                         = getTanksTable()
    local encounterID                                   = ""

    enemies.yards5 = br.player.enemies(5)
    enemies.yards8 = br.player.enemies(8)
    enemies.yards20 = br.player.enemies(20)
    enemies.yards40 = br.player.enemies(40)
    friends.yards8 = getAllies("player",8)
    friends.yards25 = getAllies("player",25)
    friends.yards40 = getAllies("player",40)

    

    if not inCombat then
        TFV = false
        TFRM = false
        TFEM = false
		TFEF = false
    end
    if botSpell == nil then
        botSpell = 61304
    end
    if currentTarget == nil then
        currentTarget = UnitGUID("player")
    end
    --    Print("LastSpell:"..GetSpellInfo(botSpell))
    --    Print("LastTarget:"..SetRaidTarget(currentTarget,8))
    
    local function getLowest()
        local lowestUnit = br.friend[1]
        for i = 1, #br.friend do
            local thisUnit = br.friend[i]
            local thisHP = thisUnit.hp
            local thisBuff = UnitBuffID(thisUnit.unit,191840)
            if thisBuff then
                thisHP = thisHP - 5
            end
            local lowestHP = lowestUnit.hp
            local lowestBuff = UnitBuffID(lowestUnit.unit,191840)
            if lowestBuff then
                lowestHP = lowestHP - 5
            end
            if thisHP < lowestHP then
                lowestUnit = thisUnit
            end
        end
        return lowestUnit
    end

    lowest = getLowest()
    -------------------
    ---  Boss Mods  ---
    -------------------
    AddEventCallback("ENCOUNTER_START",function(...)
	    encounterID = select(1,...)
        --print(encounterID)
    end)

    --local function drawline(target)
    --    local LibDraw = LibStub("LibDraw-1.0")
    --    local playerX, playerY, playerZ = ObjectPosition("player")
    --   local targetX, targetY, targetZ = ObjectPosition(target)
    --    LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
    --end

    --local function clearCanvas()
    --    local LibDraw = LibStub("LibDraw-1.0")
    --    LibDraw.clearCanvas()
    --end

    local function findIllidan()
        for i = 1, ObjectCount() do
            local name = ObjectName(GetObjectWithIndex(i))
            local object = GetObjectWithIndex(i)
            --local px, py, pz = ObjectPosition("player")
            --local tx, ty, tz = ObjectPosition(object)
            if name == "Lord Illidan Stormrage" and ObjectExists(object) then
                return object
            end
        end
    end
    
    local function actionList_bossmods()
    --print(select(1,GetCurrentMapAreaID()))
        --if GetCurrentMapAreaID() == 1147 then            
        -- Kill Jaeden
            if encounterID == 2051 then
            --if inRaid then
                if isChecked(colorwarlock.."Find Illidan") then
                    debuff = UnitDebuffID("player",236555) --Deceiver veil
                    if debuff then
                        illi = findIllidan()
                    end
                    print(ObjectIsTracked(illi))
                    if debuff and not ObjectIsTracked(illi) then
                        ObjectSetTracked(illi,true)
                        return true
                    else
                        ObjectSetTracked(illi,false)
                        return true
                    end
                end
            end
            --end
        --end
    end
    
    --------------------
    --- Action Lists ---
    --------------------
    -- Detox
    local function actionList_Detox()
        --Mouseover dispell
        if canDispel("mouseover",spell.detox) then
            SpellStopCasting()
            if cast.detox("mouseover") then return true end
		end	
        if useDispell then
            for i = 1, #friends.yards40 do
                if canDispel(br.friend[i].unit,spell.detox) then
					if cast.detox(br.friend[i].unit) then return true end
				end				
            end
        end
        return false
    end

    local function actionList_Interrupt()
        if useInterrupts() then
            if isChecked(colorrogue.."Leg Sweep") and talent.legSweep and cd.legSweep.remain() == 0 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if canInterrupt(thisUnit,getValue("Interrupt at")) then
                        if cast.legSweep() then return true end
                    end
                end
            end
            if isChecked(colorrogue.."Paralysis") and cd.paralysis.remain() == 0 then
                for i = 1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    if canInterrupt(thisUnit,getValue("Interrupt at")) then
                        if cast.paralysis(thisUnit) then return true end
                    end
                end
            end
            return false
        end
    end
	-- Velen's Future Sight
    local function actionList_CheckVelen()
        if isChecked(colorshaman.."Velen's Future Sight") then
            if hasEquiped(144258) and canUseItem(144258) then
            -- Automatic
                if getOptionValue(colorshaman.."Velen's Future Sight logic") == 1 then
                    useItem(144258)
					return true
            -- Following Settings
                elseif getOptionValue(colorshaman.."Velen's Future Sight logic") == 2 then
                    if getLowAllies(getValue(colorshaman.."Velen's Future Sight")) >= getValue(colorshaman.."Min Velen's Future Sight Targets") then
                        useItem(144258)
                        return true
                    end
                end
            end
        end
    end
    local function actionList_Defensive()
        if useDefensive() then
            if (isChecked(colorwarrior.."Healing Elixir/Diffuse Magic/Dampen Harm") and php <= getValue(colorwarrior.."Healing Elixir/Diffuse Magic/Dampen Harm"))
                    or (isChecked(colorwarrior.."Healing Elixir/Diffuse Magic/Dampen Harm Key") and (SpecificToggle(colorwarrior.."Healing Elixir/Diffuse Magic/Dampen Harm Key") and not GetCurrentKeyBoardFocus())) then
                if cast.healingElixir() then return true end
                if cast.diffuseMagic() then return true end
                if cast.dampenHarm() then return true end
            end
            if isChecked(colorwarrior.."Fortifying Brew") and php <=  getValue(colorwarrior.."Fortifying Brew") and cd.fortifyingBrew.remain() == 0 then
                if cast.fortifyingBrew() then return true end
            end
            if isChecked(colorwarrior.."Healthstone") and php <= getValue(colorwarrior.."Healthstone") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUseItem(5512) then
                    useItem(5512)
                    return true
                elseif canUseItem(healPot) then
                    useItem(healPot)
                    return true
                end
            end
        end
        return false
    end

    local function actionList_Extra()
	-- Pre-Pull Timer
		if isChecked("Pre-Pull Timer") then
            if pullTimer <= getOptionValue("Pre-Pull Timer") then
                if canUseItem(142117) and not buff.prolongedPower.exists() and inRaid then
                    useItem(142117);
                        return true
                    end
			end
			if pullTimer <= 6 then
                if cd.renewingMist.remain() == 0 then
                    for i=1, #tanks do
                        tank = tanks[i].unit
                        if UnitInRange(tank) and not buff.renewingMist.exists(tank) then
                            if cast.renewingMist(tanks[i].unit) then return true end
                        end
                    end
                end
            end
		end
	-- Roll
        if isChecked("Roll/Chi Torpedo Key") and (SpecificToggle("Roll/Chi Torpedo Key") and not GetCurrentKeyBoardFocus()) then
            if cast.roll() then return true end
            if cast.chiTorpedo() then return true end
        end
	-- Transcendence
        if isChecked("Transcendence/Transcendence:Transfer Key") and (SpecificToggle("Transcendence/Transcendence:Transfer Key") and not GetCurrentKeyBoardFocus()) then
            if tPX == nil or tPY == nil or not buff.transcendence.exists() then tPX, tPY, tPZ = ObjectPosition("player"); if cast.transcendence() then return true end
            elseif getDistanceToObject("player",tPX,tPY,tPZ) > 40 and buff.transcendence.exists() then
                if cast.transcendence() then return true end
            else
                if cast.transcendenceTransfer("player") then return true end
            end
        end
	-- Tiger Lust
        if isChecked("Tiger's Lust") and hasNoControl()
                or (isChecked("Tiger's Lust Key") and (SpecificToggle("Tiger's Lust Key") and not GetCurrentKeyBoardFocus())) then
            if cast.tigersLust() then return true end
        end
	-- Ring of Peace
        if isChecked("Ring Of Peace Key") and (SpecificToggle("Ring Of Peace Key") and not GetCurrentKeyBoardFocus()) and cd.ringOfPeace.remain() == 0 then
            CastSpellByName(GetSpellInfo(spell.ringOfPeace),"cursor")
            return true
        end
	-- Invervate Logic
        if inRaid and buff.innervate.exists() or buff.symbolOfHope.exists() or buff.manaTea.exists() then
            actionList_CheckVelen()
            if isChecked(colormage.."Essence Font") and cd.essenceFont.remain() == 0 and #friends.yards25 > 5 then
                if cast.essenceFont() then return true end
            end
            if isChecked(colormage.."Refreshing Jade Wind") and talent.refreshingJadeWind and #friends.yards8 > 1 then
                if cast.refreshingJadeWind() then return true end
            end
            if isChecked(colormage.."Vivify") then
                if cast.vivify(getLowest().unit) then return true end
            end
        end
        if IsInInstance ~= "party" and buff.innervate.exists() or buff.symbolOfHope.exists() or buff.manaTea.exists() then
            actionList_CheckVelen()
            if isChecked(colormage.."Essence Font") and cd.essenceFont.remain() == 0 and #friends.yards25 > 3 then
                if cast.essenceFont() then return true end
            end
            if isChecked(colormage.."Refreshing Jade Wind") and talent.refreshingJadeWind and #friends.yards8 > 1 then
                if cast.refreshingJadeWind() then return true end
            end
            if isChecked(colormage.."Vivify") then
                if cast.vivify(getLowest().unit) then return true end
            end
        end
	-- RM on CD
        if isChecked(colormage.."Renewing Mist - On CD") then
            for i = 1, #friends.yards40 do
                local thisUnit = friends.yards40[i]
                if thisUnit.hp <= getValue(colormage.."Renewing Mist") and buff.renewingMist.remain(thisUnit.unit) < gcdMax then
                    if cast.renewingMist(thisUnit.unit) then return true end
                end
            end
        end
        return false
    end

    local function actionList_Cooldown()
        if useCDs() then
        -- The Deceiver's Grand Design
			if isChecked(colorshaman.."The Deceiver's Grand Design") then
				for i = 1, #br.friend do
					if hasEquiped(147007) and canUseItem(147007) and getBuffRemain(br.friend[i].unit,242622) == 0 and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and UnitInRange(br.friend[i].unit) and not UnitIsDeadOrGhost(br.friend[i].unit) then
						UseItemByName(147007,br.friend[i].unit)
					end
				end
			end
    	-- Archive of Faith
    		if isChecked(colorshaman.."Archive of Faith") then
    			for i = 1, #br.friend do
    				if hasEquiped(147006) and canUseItem(147006) and br.friend[i].hp <= getValue ("Archive of Faith") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" and UnitInRange(br.friend[i].unit) and not UnitIsDeadOrGhost(br.friend[i].unit) then
    					UseItemByName(147006,br.friend[i].unit)
    				end
    			end
    		end
		-- Trinket 1
            if isChecked(colorshaman.."Trinket 1") and getLowAllies(getValue(colorshaman.."Trinket 1")) >= getValue(colorshaman.."Min Trinket 1 Targets") and mana > 1 then
                if canUseItem(13) then
                    useItem(13)
                    return true
                end
            end
		-- Trinket 2
            if isChecked(colorshaman.."Trinket 2") and getLowAllies(getValue(colorshaman.."Trinket 2")) >= getValue(colorshaman.."Min Trinket 2 Targets") and mana > 1 then
                if canUseItem(14) then
                    useItem(14)
                    return true
                end
            end
		-- Velen's Future Sight
            if actionList_CheckVelen() then return true end
		-- Gnawed Thumb Ring
            if isChecked(colorshaman.."Gnawed Thumb Ring") and getLowAllies(getValue(colorshaman.."Gnawed Thumb Ring")) >= getValue(colorshaman.."Min Gnawed Thumb Ring Targets") and mana > 2 then
                if hasEquiped(134526) and canUseItem(134526) and select(2,IsInInstance()) ~= "pvp" then
                    useItem(134526)
                    return true
                end
            end
		-- Mana potion
            if isChecked(colorshaman.."Mana Potion") and mana <= getValue(colorshaman.."Mana Potion") then
                if hasItem(127835) and canUseItem(127835) then
                    useItem(127835)
                    return true
                end
            end
		-- Arcane Torrent
            if isChecked(colorshaman.."Arcane Torrent") and mana <= getValue(colorshaman.."Arcane Torrent") and br.player.race == "BloodElf" then
                if castSpell("player",racial,false,false,false) then return end
            end
		-- Enveloping Mist + Surge of Mist. Avoid wasting proc 
            if isChecked(colormonk.."Emergency Enveloping Mist with Surge of Mist") and buff.surgeOfMist.exist and buff.surgeOfMist.remain(br.player.unit) < 6 then 
                for i = 1, #br.friend do 
                    if br.friend[i].hp <= getValue(colormonk.."Emergency Enveloping Mist with Surge of Mist") and (not buff.envelopingMist.exists(br.friend[i].unit) or buff.envelopingMist.remain(br.friend[i].unit) <= getCastTime(spell.envelopingMist)) then 
                        if cast.envelopingMist(br.friend[i].unit) then return end 
                    end 
                end 
            end 
		-- Tier 20 4p Trigger
			if isChecked(colormonk.."Enveloping Mist with Surge of Mist") and buff.surgeOfMist.exists() then
                if getLowAllies(getValue(colormonk.."Enveloping Mist with Surge of Mist")) >= getValue(colormonk.."Min Enveloping Mist with Surge of Mist Targets") then
                        if cast.envelopingMist(getLowest().unit) then return true end
                end
            end
		-- Mana Tea
            if isChecked(colorshaman.."Mana Tea") and mana <= getValue(colorshaman.."Mana Tea") and getLowAllies(getValue(colorshaman.."Mana Tea - Life")) >= getValue(colorshaman.."Min Mana Tea Targets") and talent.manaTea  then
                if cast.manaTea() then return true end
            end
		-- Revival
            if isChecked(colorshaman.."Revival") and getLowAllies(getValue(colorshaman.."Revival")) >= getValue(colorshaman.."Min Revival Targets") and cd.revival.remain() == 0 then
                SpellStopCasting()
                actionList_CheckVelen()
                if cast.revival() then return true end
            end
		-- ChiJi
            if isChecked(colorshaman.."Invoke Chi-Ji, the Red Crane") and talent.invokeChiJiTheRedCrane and cd.invokeChiJiTheRedCrane.remain() == 0 then
                if getLowAllies(getValue(colorshaman.."Invoke Chi-Ji, the Red Crane")) >= getValue(colorshaman.."Min Invoke Chi-Ji, the Red Crane Targets") then
                    SpellStopCasting()
                    if cast.invokeChiJiTheRedCrane("player") then return true end
                end
            end
		-- Life Cocoon
            if isChecked(colorshaman.."Life Cocoon") and cd.lifeCocoon.remain() == 0  then
                lowest = getLowest()
                -- Player
                if getOptionValue(colorshaman.."Life Cocoon Target") == 1 then
                    if php <= getValue(colorshaman.."Life Cocoon") then
                        SpellStopCasting()
                        if cast.lifeCocoon("player") then return true end
                    end
                    -- Target
                elseif getOptionValue(colorshaman.."Life Cocoon Target") == 2 then
                    if getHP("target") <= getValue(colorshaman.."Life Cocoon") then
                        SpellStopCasting()
                        if cast.lifeCocoon("target") then return true end
                    end
                    -- Mouseover
                elseif getOptionValue(colorshaman.."Life Cocoon Target") == 3 then
                    if getHP("mouseover") <= getValue(colorshaman.."Life Cocoon") then
                        SpellStopCasting()
                        if cast.lifeCocoon("mouseover") then return true end
                    end
                elseif lowest.hp <= getValue(colorshaman.."Life Cocoon") then
                    -- Tank
                    if getOptionValue(colorshaman.."Life Cocoon Target") == 4 then
                        if (lowest.role) == "TANK" then
                            SpellStopCasting()
                            if cast.lifeCocoon(lowest.unit) then return true end
                        end

                        -- Healer
                    elseif getOptionValue(colorshaman.."Life Cocoon Target") == 5 then
                        if (lowest.role) == "HEALER" then
                            SpellStopCasting()
                            if cast.lifeCocoon(lowest.unit) then return true end
                        end
                        -- Healer/Tank
                    elseif getOptionValue(colorshaman.."Life Cocoon Target") == 6 then
                        if (lowest.role) == "HEALER" or (lowest.role) == "TANK" then
                            SpellStopCasting()
                            if cast.lifeCocoon(lowest.unit) then return true end
                        end
                        -- Any
                    elseif  getOptionValue(colorshaman.."Life Cocoon Target") == 7 then
                        SpellStopCasting()
                        if cast.lifeCocoon(lowest.unit) then return true end
                    end
                end
            end
        end
        return false
    end

    local function actionList_SingleTargetHealing()
	-- Jade Serpent
        if isChecked(colormage.."Summon Jade Serpent") and getLowest().hp >= 55 and talent.summonJadeSerpentStatue then
            --player
            if getOptionValue(colormage.."Summon Jade Serpent") == 1 then
                param = "player"
                --target
            elseif getOptionValue(colormage.."Summon Jade Serpent") == 2 and GetObjectExists("target") then
                param = "target"
                --tank
            elseif getOptionValue(colormage.."Summon Jade Serpent") == 3 and #getTanksTable() > 0 then
                local tanks = getTanksTable()
                param = tanks[1].unit
            else
                param = "player"
            end
            if tsPX == nil or tsPY == nil then
                tsPX, tsPY, tsPZ = GetObjectPosition(param)
                if cast.summonJadeSerpentStatue(param) then return true end
            elseif getDistanceToObject("player",tsPX,tsPY,tsPZ) > 40 then
                tsPX, tsPY, tsPZ = GetObjectPosition(param)
                if cast.summonJadeSerpentStatue(param) then return true end
            end
        end
        lowest = getLowest()
        if (botSpell ~= spell.envelopingMist and currentTarget ~= UnitGUID(lowest.unit)) or not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= 2 then
		-- Sheilun's Gift'
            if isChecked(colormage.."Sheilun's Gift") and GetSpellCount(spell.sheilunsGift) >= getValue(colormage.."Sheilun's Gift Charges") then
                if lowest.hp <= getValue(colormage.."Sheilun's Gift") then
                    if cast.sheilunsGift(lowest.unit) then return true end
                end
            end
		-- Zen Pulse	
            if isChecked(colormage.."Zen Pulse") and talent.zenPulse then
                if lowest.hp <= getValue(colormage.."Zen Pulse") and getNumEnemies(lowest.unit, 8) >= getValue(colormage.."Zen Pulse Enemies") then
                    if cast.zenPulse(lowest.unit) then return true end
                end
            end
        -- Chi Wave
			if isChecked(colormage.."Chi Wave") and talent.chiWave and lowest.hp <= getValue(colormage.."Chi Wave") then
                if cast.chiWave(lowest.unit) then return true end
            end
		-- Enveloping Mist + Surge of Mist. Avoid wasting proc
			if isChecked(colormonk.."Emergency Enveloping Mist with Surge of Mist") and buff.surgeOfMist.exist and buff.surgeOfMist.remain(br.player.unit) < 6 then
                for i = 1, #br.friend do
					if br.friend[i].hp <= getValue(colormonk.."Emergency Enveloping Mist with Surge of Mist") and (not buff.envelopingMist.exists(br.friend[i].unit) or buff.envelopingMist.remain(br.friend[i].unit) <= getCastTime(spell.envelopingMist)) then
						if cast.envelopingMist(br.friend[i].unit) then return end
					end
				end
            end
		-- Enveloping Mist
            if isChecked(colormage.."Enveloping Mist") then
                if (not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= getCastTime(spell.envelopingMist)) and lowest.hp <= getValue(colormage.."Enveloping Mist")then
                    if (isChecked(colormage.."Enveloping Mist - Tank Only") and (lowest.role) == "TANK") or not isChecked(colormage.."Enveloping Mist - Tank Only") then
                        if cast.envelopingMist(lowest.unit) then return true end
                    end
                end
            end
		-- Enveloping Mist + Lifecycles
            if isChecked(colormage.."Enveloping Mist with Lifecycles") then
                if buff.lifeCyclesEnvelopingMist.exists() and (not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= getCastTime(spell.envelopingMist))
                        and lowest.hp <= getValue(colormage.."Enveloping Mist with Lifecycles") then
                    if (isChecked(colormage.."Enveloping Mist - Tank Only") and (lowest.role) == "TANK") or not isChecked(colormage.."Enveloping Mist - Tank Only") then
                        if cast.envelopingMist(lowest.unit) then return true end
                    end
                end
            end
		-- Renewing Mist
            if isChecked(colormage.."Renewing Mist") and cd.renewingMist.remain() == 0 then
                for i = 1, #friends.yards40 do
                    local thisUnit = friends.yards40[i]
                    if thisUnit.hp <= getValue(colormage.."Renewing Mist") and buff.renewingMist.remain(thisUnit.unit) < gcdMax then
                        if cast.renewingMist(thisUnit.unit) then return true end
                    end
                end
            end
		-- Effuse
            if isChecked(colormage.."Effuse") and getValue(colormage.."Effuse Greater or equals") <= lowest.hp and getValue(colormage.."Effuse Less or equals") >= lowest.hp then
                if botSpell == spell.effuse and currentTarget == UnitGUID(lowest.unit) then
                    return false
                end
                if cast.effuse(lowest.unit) then return true end
            end
        end

        -- DOT damage to teammates cast Enveloping Mist
			if isChecked("DOT cast EM") then
				local debuff_list={
                    {spellID = 230345   ,   stacks = 0   ,   secs = 6},   --Crashing Comet
                    {spellID = 236603   ,   stacks = 0   ,   secs = 4},   --Rapid Shot
                    {spellID = 236712   ,   stacks = 0   ,   secs = 2},   --Lunar Beacon
                    {spellID = 242017   ,   stacks = 2   ,   secs = 6},   --Black Winds
                    {spellID = 240915   ,   stacks = 0   ,   secs = 6},   --Armageddon hail
                    {spellID = 235117   ,   stacks = 0   ,   secs = 7}    --unstable-soul
				}
				for i=1, #br.friend do
					for k,v in pairs(debuff_list) do
						if getDebuffRemain(br.friend[i].unit,v.spellID) > v.secs and getDebuffStacks(br.friend[i].unit,v.spellID) >= v.stacks and not buff.envelopingMist.exists(br.friend[i].unit) and not isCastingSpell(spell.essenceFont) and UnitInRange(br.friend[i].unit) then
							if cast.envelopingMist(br.friend[i].unit) then return end
						end
					end
				end
			end

        -- Ephemeral Paradox trinket
        if hasEquiped(140805) and getBuffRemain("player", 225767) > 2 then
            if cast.effuse(getLowest().unit) then return true end
        end
        return false
    end

    local function actionList_AOEHealing()
	-- Chi Burst
        if isChecked(colormage.."Chi Burst") and talent.chiBurst and inCombat then
            --if castWiseAoEHeal(br.friend,spell.chiBurst,10,getValue("Chi Burst"),getValue("Min Chi Burst Targets"),10,true,true) then return end
            if getUnitsInRect(7,47,false,getValue(colormage.."Chi Burst")) >= getValue(colormage.."Min Chi Burst Targets") then
                -- actionList_CheckVelen()
                 if cast.chiBurst("player") then return true end
            end
        end
    -- Essence Font
			if isChecked(colormage.."Essence Font") and cd.essenceFont.remain() == 0 and getLowAlliesInTable(getValue(colormage.."Essence Font"), friends.yards25) >= getValue(colormage.."Min Essence Font Targets") then
				if cast.essenceFont() then return true end
			end
    -- Refreshing Jade Wind
        if isChecked(colormage.."Refreshing Jade Wind") and talent.refreshingJadeWind and getLowAlliesInTable(getValue(colormage.."Refreshing Jade Wind"), friends.yards8) >= getValue(colormage.."Min Refreshing Jade Wind Targets")  then
            if cast.refreshingJadeWind() then return true end
        end
        lowest = getLowest()
        if (botSpell ~= spell.envelopingMist and currentTarget ~= UnitGUID(lowest.unit)) or not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= 2 then
	-- Vivify with Dance of Mist
            if isChecked(colormage.."Vivify with Dance Of Mist") and buff.danceOfMist.exists() then
                if getLowAlliesInTable(getValue(colormage.."Vivify with Dance Of Mist"), friends.yards40) >= getValue(colormage.."Min Vivify with Dance Of Mist Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
	-- Vivify Lifecycles + uplift
            if isChecked(colormage.."Vivify with Lifecycles + Uplift") and buff.upliftTrance.exists() and buff.lifeCyclesVivify.exists() then
                if getLowAlliesInTable(getValue(colormage.."Vivify with Lifecycles + Uplift"), friends.yards40) >= getValue(colormage.."Min Vivify with Lifecycles + Uplift Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
    -- Vivify Uplift
            if isChecked(colormage.."Vivify with Uplift") and buff.upliftTrance.exists() then
                if getLowAlliesInTable(getValue(colormage.."Vivify with Uplift"), friends.yards40) >= getValue(colormage.."Min Vivify with Uplift Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
    -- Vivify lifecycles
            if isChecked(colormage.."Vivify with Lifecycles") and buff.lifeCyclesVivify.exists() then
                if getLowAlliesInTable(getValue(colormage.."Vivify with Lifecycles"), friends.yards40) >= getValue(colormage.."Min Vivify with Lifecycles Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
    -- Vivify normal
            if isChecked(colormage.."Vivify")  then
                if getLowAlliesInTable(getValue(colormage.."Vivify"), friends.yards40) >= getValue(colormage.."Min Vivify Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
        end
		return false
    end

    local function actionList_DPS()
        if useDPS then
            if getLowest().hp >= getValue("DPS") then
                if talent.risingThunder then
                    if cast.risingSunKick() then return true end
                end
                if  isChecked(colordh.."Spinning Crane Kick") and not talent.spiritOfTheCrane and #enemies.yards8 >= 3 and not isCastingSpell(spell.spinningCraneKick) then
                    if cast.spinningCraneKick() then return true end
                elseif #enemies.yards5 >= 1 then
                    if isChecked(colordh.."Rising Sun Kick") and cd.risingSunKick.remain()  == 0 then
                        if cast.risingSunKick() then return true end
                    end
                    if buff.teachingsOfTheMonastery.stack() == 3 then
                        if cast.blackoutKick() then return true end
                    end
                    if cast.tigerPalm() then return true end
                elseif #enemies.yards40 > 0 and not isCastingSpell(spell.cracklingJadeLighting) and isChecked(colordh.."Crackling Jade Lightning") then
                    if cast.cracklingJadeLighting() then return true end
                end
            end
        end
        return false
    end

    local function actionList_ThunderFocus()
		
		if isChecked(colorshaman.."Thunder Focus Tea + Essence Font") and cd.essenceFont.remain() == 0  and getLowAlliesInTable(getValue(colorshaman.."Thunder Focus Tea + Essence Font"), friends.yards25) >= getValue(colorshaman.."Min Thunder Focus Tea + Essence Font Targets") then
			if cd.thunderFocusTea.remain() == 0 then
                if cast.thunderFocusTea() then
                    TFEF = true
                    return true
                end
            end
        end
        if isChecked(colorshaman.."Thunder Focus Tea + Vivify") and getLowest().hp <= getValue(colorshaman.."Thunder Focus Tea + Vivify") and mana <= getValue(colorshaman.."Thunder Focus Tea + Vivify - Mana") then
            if cd.thunderFocusTea.remain() == 0 then
                if cast.thunderFocusTea() then
                    TFV = true
                    return true
                end
            end
        end
        lowest = getLowest()
        if isChecked(colorshaman.."Thunder Focus Tea + Enveloping Mist") and lowest.hp <= getValue(colorshaman.."Thunder Focus Tea + Enveloping Mist") then
             if not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= 2 then
                if cd.thunderFocusTea.remain() == 0 then
                    if cast.thunderFocusTea() then
                        TFEM = true
                        return true
                    end
                end
            end
        end
        if isChecked(colorshaman.."Thunder Focus Tea + Renewing Mist") and cd.renewingMist.remain() == 0 and getLowest().hp <= getValue(colorshaman.."Thunder Focus Tea + Renewing Mist") then
            if cd.thunderFocusTea.remain() == 0 then
                if cast.thunderFocusTea() then
                    TFRM = true
                    return true
                end
            end
        end
		if isChecked(colorshaman.."Thunder Focus Tea + Essence Font") and cd.essenceFont.remain() == 0 and getLowAlliesInTable(getValue(colorshaman.."Thunder Focus Tea + Essence Font"), friends.yards25) >= getValue(colorshaman.."Min Thunder Focus Tea + Essence Font Targets") then
			if cast.essenceFont() then
                TFEF = false
                return true
            end
        end
        if isChecked(colorshaman.."Thunder Focus Tea + Vivify") and getLowest().hp <= getValue(colorshaman.."Thunder Focus Tea + Vivify") and TFV and mana <= getValue(colorshaman.."Thunder Focus Tea + Vivify - Mana") then
            if cast.vivify(getLowest().unit) then
                TFV = false
                return true
            end
        end
        if isChecked(colorshaman.."Thunder Focus Tea + Enveloping Mist") and getLowest().hp <= getValue(colorshaman.."Thunder Focus Tea + Enveloping Mist") and TFEM then
            if cast.envelopingMist(getLowest().unit) then
                TFEM = false
                return true
            end
        end
        if isChecked(colorshaman.."Thunder Focus Tea + Renewing Mist") and cd.renewingMist.remain() == 0 and getLowest().hp <= getValue(colorshaman.."Thunder Focus Tea + Renewing Mist") and TFRM then
            for i = 1, #friends.yards40 do
                local thisUnit = friends.yards40[i]
                if thisUnit.hp <= getValue(colorshaman.."Thunder Focus Tea + Renewing Mist") and buff.renewingMist.remain(thisUnit.unit) < gcdMax then
                    if cast.renewingMist(thisUnit.unit) then
                        TFRM = false
                        return true
                    end
                end
            end
        end
        return false
    end

    function profile()
        -----------------
        --- Rotations ---
        -----------------
        -- Pause
        if pause(true) or isCastingSpell(spell.essenceFont) or UnitDebuffID("player",188030) then return true end

        if not IsMounted() and not inCombat and not drinking then
            if actionList_Extra() then return true end			
			if isChecked("OOC Healing") then
                if actionList_SingleTargetHealing() then return true end
                if actionList_AOEHealing() then return true end
			end
        end
        if not IsMounted() and inCombat then
            if actionList_ThunderFocus() then return true end
        end
        
        if inCombat and not IsMounted() and getBuffRemain("player", 192002 ) < 10 then
            actionList_bossmods()
            if actionList_Defensive() then return true end
            if actionList_Cooldown() then return true end
            if actionList_AOEHealing() then return true end
            if actionList_Detox() then return true end
            if actionList_SingleTargetHealing() then return true end
            if actionList_Interrupt() then return true end
            if actionList_DPS() then return true end
            
        end
        -----------
        --- END ---
        -----------
    end
--    if not executando and getSpellCD(spell.effuse) == 0 then
--    if botSpell == spell.envelopingMist or botSpell == spell.effuse or botSpell == spell.sheilunsGift or botSpell == spell.vivify or botSpell == spell.lifeCoccon or
    if br.timer:useTimer("debugMistweaver", 0.25)  then
--        executando = true
        profile()
--        executando = false
    end
    return true
end

--local id = 270
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
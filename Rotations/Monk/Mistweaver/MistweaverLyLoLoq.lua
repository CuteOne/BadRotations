local rotationName = "LyLoLoq"
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
        --------------
        --- OPTIONS ---
        --------------

       -- General Options
        section = br.ui:createSection(br.ui.window.profile, colormonk.."General")
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

        -- Tier Section
        section = br.ui:createSection(br.ui.window.profile, "Tier Settings")
        br.ui:createSpinner(section, "Enveloping Mist with Surge of Mist",  65,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Trigger t20 4piece bonus", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Enveloping Mist with Surge of Mist Targets",  2,  1,  3,  1,  colorBlue.."Minimum Trigger t20 4p bonus Targets "..colorGold.."(This includes you)")
		br.ui:createSpinner(section, "Emergency Enveloping Mist with Surge of Mist",  65,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Emergency cast when Surge of Mist duration < 5 sec to don't lose the Surge of Mist proc", colorWhite.."Health Percent to Cast At")
        br.ui:checkSectionState(section)

        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldown")
        br.ui:createSpinner(section, "Revival",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Revival.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Revival Targets",  3,  1,  40,  1,  colorBlue.."Minimum Revival Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Invoke Chi-Ji, the Red Crane",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Invoke Chi-Ji, the Red Crane.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Invoke Chi-Ji, the Red Crane Targets",  3,  1,  40,  1,  colorBlue.."Minimum Invoke Chi-Ji, the Red Crane Targets "..colorGold.."(This includes you)")
		br.ui:createSpinner(section, "Life Cocoon",  20,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Life Cocoon.", colorWhite.."Health Percent to Cast At")
        br.ui:createDropdownWithout(section, "Life Cocoon Target", {colorGreen.."Player",colorBlue.."Target",colorWhite.."Mouseover",colorRed.."Tank",colorGreen.."Healer",colorGreen.."Healer/Tank",colorBlue.."Any"}, 6, colorWhite.."Target to cast on")
        br.ui:createSpinner(section, "Trinket 1",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Trinket 1.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 1 Targets",  1,  1,  40,  1,  colorBlue.."Minimum Trinket 1 Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Trinket 2",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Trinket 2.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Trinket 2 Targets",  1,  1,  40,  1,  colorBlue.."Minimum Trinket 2 Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Mana Tea",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Mana Tea.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Mana Tea - Life",  50,  0,  100,  1,  colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Mana Tea Targets",  3,  1,  40,  1,  colorBlue.."Minimum Low Life Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Arcane Torrent",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Arcane Torrent to mana recover.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinner(section, "Mana Potion",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Ancient Mana Potion.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinner(section, "Thunder Focus Tea + Vivify",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Vivify.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Thunder Focus Tea + Vivify - Mana",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Vivify.", colorWhite.."Mana Percent to Cast At")
        br.ui:createSpinner(section, "Thunder Focus Tea + Renewing Mist",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Renewing Mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinner(section, "Thunder Focus Tea + Enveloping Mist",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Enveloping Mist.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinner(section, "Thunder Focus Tea + Essence Font",  50,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Thunder Focus Tea + Essence Font.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinnerWithout(section, "Min Thunder Focus Tea + Essence Font Targets",  5,  1,  40,  1,  colorBlue.."Minimum Thunder Focus Tea + Essence Font Targets "..colorGold.."(This includes you)")     
		br.ui:createSpinner(section, "Gnawed Thumb Ring",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Gnawed Thumb Ring.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Gnawed Thumb Ring Targets",  3,  1,  40,  1,  colorBlue.."Minimum Gnawed Thumb Ring Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Velen's Future Sight",  30,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Velen's Future Sight.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Velen's Future Sight Targets",  3,  1,  40,  1,  colorBlue.."Minimum Velen's Future Sight Targets "..colorGold.."(This includes you)")
        br.ui:createDropdownWithout(section, "Velen's Future Sight logic", {colorGreen.."Full Automatic",colorBlue.."Use Settings"}, 1, colorWhite.."Cast it automatic with other CD's or follow settings above")
        br.ui:checkSectionState(section)

        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Healing Elixir/Diffuse Magic/Dampen Harm",  40,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Healing Elixir/Diffuse Magic/Dampen Harm.", colorWhite.."Health Percent to Cast At")
        br.ui:createDropdown(section, "Healing Elixir/Diffuse Magic/Dampen Harm Key", br.dropOptions.Toggle, 6, colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Healing Elixir/Diffuse Magic/Dampen Harm with Key.",colorWhite.."Set hotkey to use Healing Elixir/Diffuse Magic/Dampen Harm with key.")
        br.ui:createSpinner(section, "Fortifying Brew",  40,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Fortifying Brew.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinner(section, "Healthstone",  30,  0,  100,  5,  colorWhite.."Health Percent to Cast At")
        br.ui:checkSectionState(section)

        -- Healing Options
        section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinner(section, "Essence Font",  60,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Essence Font.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Essence Font Targets",  5,  1,  40,  1,  colorBlue.."Minimum Essence Font Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Refreshing Jade Wind",  60,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Refreshing Jade Wind.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Refreshing Jade Wind Targets",  3,  1,  40,  1,  colorBlue.."Minimum Refreshing Jade Wind "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Chi Burst",  70,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Chi Burst.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Chi Burst Targets",  3,  1,  40,  1,  colorBlue.."Minimum Chi Burst Targets "..colorGold.."(This includes you)")
        --br.ui:createCheckbox(section,"Show Lines",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Lines of Chi Burst.")
        br.ui:createSpinner(section, "Vivify",  80,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Vivify Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Vivify with Lifecycles",  85,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Lifecycles.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Vivify with Lifecycles Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Lifecycles Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Vivify with Uplift",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Uplift.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Vivify with Uplift Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Uplift Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Vivify with Lifecycles + Uplift",  95,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Lifecycles + Uplift.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Vivify with Lifecycles + Uplift Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Lifecycles + Uplift Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Vivify with Dance Of Mist",  85,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Vivify with Dance of mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Min Vivify with Dance Of Mist Targets",  2,  1,  3,  1,  colorBlue.."Minimum Vivify with Dance of Mist Targets "..colorGold.."(This includes you)")
        br.ui:createSpinner(section, "Sheilun's Gift",  70,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Sheilun's Gift.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Sheilun's Gift Charges",  5,  1,  12,  1,  colorBlue.."Minimum Sheilun's Gift charges")
        br.ui:createSpinner(section, "Enveloping Mist",  75,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Enveloping Mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createCheckbox(section, "Enveloping Mist - Tank Only", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Enveloping Mist on tank only.")
        br.ui:createSpinner(section, "Enveloping Mist with Lifecycles",  65,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Enveloping Mist.", colorWhite.."Health Percent to Cast At")
		br.ui:createSpinner(section, "Zen Pulse",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Zen Pulse.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Zen Pulse Enemies",  3,  1,  100,  1,  colorBlue.."Minimum Zen Pulse Enemies")
        br.ui:createCheckbox(section, "Effuse", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Effuse.")
        br.ui:createSpinnerWithout(section, "Effuse Greater or equals",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Effuse.", colorWhite.."Health Percent to Cast At. (Exemple: Effuse Greater or equals 80% and <= 100%)")
        br.ui:createSpinnerWithout(section, "Effuse Less or equals",  90,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Effuse.", colorWhite.."Health Percent to Cast At. (Exemple: Effuse Greater or equals 80% and <= 100%)")
        br.ui:createSpinner(section, "Renewing Mist",  100,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Renewing Mist.", colorWhite.."Health Percent to Cast At")
        br.ui:createCheckbox(section,"Renewing Mist - On CD",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Renewing Mist on CD regardless in combat.")
        --        br.ui:createSpinner(section, "Mistwalk",  80,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Mistwalk.", colorWhite.."Health Percent to Cast At")
        br.ui:createSpinner(section, "Chi Wave",  80,  0,  100,  1,  colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Chi Wave.", colorWhite.."Health Percent to Cast At")
        br.ui:createDropdown(section, "Summon Jade Serpent", {colorGreen.."Player",colorBlue.."Target",colorRed.."Tank"}, 3,colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."Use of Summon Jade Serpent.", colorWhite.."Use Summon Jade Serpent at location of.")
        br.ui:checkSectionState(section)


        --Offensive Options
        section = br.ui:createSection(br.ui.window.profile, "Offensive")
        br.ui:createCheckbox(section,"Crackling Jade Lightning",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.."the use of Crackling Jade Lightning.")
		br.ui:createCheckbox(section, "Rising Sun Kick", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Rising Sun Kick on DPS rotation")
		br.ui:createCheckbox(section, "Spinning Crane Kick", colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Spinning Crane Kick on DPS rotation")
        br.ui:checkSectionState(section)


        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
        br.ui:createCheckbox(section,"Leg Sweep",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Leg Sweep.")
        br.ui:createCheckbox(section,"Paralysis",colorGreen.."Enables"..colorWhite.."/"..colorRed.."Disables "..colorWhite.." use of Paralysis.")
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
    local mana                                          = br.player.power.mana.percent
    local debuff                                        = br.player.debuff
    local gcd                                           = br.player.gcd
	local gcdMax										= br.player.gcdMax
    local drinking                                      = UnitBuff("player",192002) ~= nil or UnitBuff("player",167152) ~= nil or UnitBuff("player",192001) ~= nil

	local pullTimer                                     = br.DBM:getPulltimer()

    local lowest                                        = br.friend[1]
    local lossPercent                                   = getHPLossPercent(lowest.unit,5)
    local enemies                                       = enemies or {}
    local friends                                       = friends or {}
	local tanks                                         = getTanksTable()

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
            if isChecked("Leg Sweep") and talent.legSweep and cd.legSweep == 0 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if canInterrupt(thisUnit,getValue("Interrupt at")) then
                        if cast.legSweep() then return true end
                    end
                end
            end
            if isChecked("Paralysis") and cd.paralysis == 0 then
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
        if isChecked("Velen's Future Sight") then
            if hasEquiped(144258) and canUse(144258) then
            -- Automatic
                if getOptionValue("Velen's Future Sight logic") == 1 then
                    useItem(144258)
					return true
            -- Following Settings
                elseif getOptionValue("Velen's Future Sight logic") == 2 then
                    if getLowAllies(getValue("Velen's Future Sight")) >= getValue("Min Velen's Future Sight Targets") then
                        useItem(144258)
                        return true
                    end
                end
            end
        end
    end
    local function actionList_Defensive()
        if useDefensive() then
            if (isChecked("Healing Elixir/Diffuse Magic/Dampen Harm") and php <= getValue("Healing Elixir/Diffuse Magic/Dampen Harm"))
                    or (isChecked("Healing Elixir/Diffuse Magic/Dampen Harm Key") and (SpecificToggle("Healing Elixir/Diffuse Magic/Dampen Harm Key") and not GetCurrentKeyBoardFocus())) then
                if cast.healingElixir() then return true end
                if cast.diffuseMagic() then return true end
                if cast.dampenHarm() then return true end
            end
            if isChecked("Fortifying Brew") and php <=  getValue("Fortifying Brew") and cd.fortifyingBrew == 0 then
                if cast.fortifyingBrew() then return true end
            end
            if isChecked("Healthstone") and php <= getValue("Healthstone") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUse(5512) then
                    useItem(5512)
                    return true
                elseif canUse(healPot) then
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
                if canUse(142117) and not buff.prolongedPower.exists() and inRaid then
                    useItem(142117);
                        return true
                    end
			end
			if pullTimer <= 6 then
                if cd.renewingMist == 0 then
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
        if isChecked("Ring Of Peace Key") and (SpecificToggle("Ring Of Peace Key") and not GetCurrentKeyBoardFocus()) and cd.ringOfPeace == 0 then
            CastSpellByName(GetSpellInfo(spell.ringOfPeace),"cursor")
            return true
        end
	-- Invervate Logic
        if buff.innervate.exists() or buff.symbolOfHope.exists() or buff.manaTea.exists() then
            if isChecked("Essence Font") and cd.essenceFont == 0 and #friends.yards25 > 5 then
                if cast.essenceFont() then return true end
            end
            if isChecked("Refreshing Jade Wind") and talent.refreshingJadeWind and #friends.yards8 > 1 then
                if cast.refreshingJadeWind() then return true end
            end
            if isChecked("Vivify") then
                if cast.vivify(lowest.unit) then return true end
            end
        end
	-- RM on CD
        if isChecked("Renewing Mist - On CD") then
            for i = 1, #friends.yards40 do
                local thisUnit = friends.yards40[i]
                if thisUnit.hp <= getValue("Renewing Mist") and buff.renewingMist.remain(thisUnit.unit) < gcdMax then
                    if cast.renewingMist(thisUnit.unit) then return true end
                end
            end
        end
        return false
    end

    local function actionList_Cooldown()
        if useCDs() then
		-- Trinket 1
            if isChecked("Trinket 1") and getLowAllies(getValue("Trinket 1")) >= getValue("Min Trinket 1 Targets") and mana > 2 then
                if canUse(13) then
                    useItem(13)
                    return true
                end
            end
		-- Trinket 2
            if isChecked("Trinket 2") and getLowAllies(getValue("Trinket 2")) >= getValue("Min Trinket 2 Targets") and mana > 2 then
                if canUse(14) then
                    useItem(14)
                    return true
                end
            end
		-- Velen's Future Sight
            if actionList_CheckVelen() then return true end
		-- Gnawed Thumb Ring
            if isChecked("Gnawed Thumb Ring") and getLowAllies(getValue("Gnawed Thumb Ring")) >= getValue("Min Gnawed Thumb Ring Targets") and mana > 2 then
                if hasEquiped(134526) and canUse(134526) and select(2,IsInInstance()) ~= "pvp" then
                    useItem(134526)
                    return true
                end
            end
		-- Mana potion
            if isChecked("Mana Potion") and mana <= getValue("Mana Potion") then
                if hasItem(127835) and canUse(127835) then
                    useItem(127835)
                    return true
                end
            end
		-- Arcane Torrent
            if isChecked("Arcane Torrent") and mana <= getValue("Arcane Torrent") and br.player.race == "BloodElf" then
                if br.player.castRacial() then return true end
            end
		-- Enveloping Mist + Surge of Mist. Avoid wasting proc 
            if isChecked("Emergency Enveloping Mist with Surge of Mist") and buff.surgeOfMist.exist and buff.surgeOfMist.remain(br.player.unit) < 6 then 
                for i = 1, #br.friend do 
                    if br.friend[i].hp <= getValue("Emergency Enveloping Mist with Surge of Mist") and (not buff.envelopingMist.exists(br.friend[i].unit) or buff.envelopingMist.remain(br.friend[i].unit) <= getCastTime(spell.envelopingMist)) then 
                        if cast.envelopingMist(br.friend[i].unit) then return end 
                    end 
                end 
            end 
		-- Tier 20 4p Trigger
			if isChecked("Enveloping Mist with Surge of Mist") and buff.surgeOfMist.exists() then
                if getLowAllies(getValue("Enveloping Mist with Surge of Mist")) >= getValue("Min Enveloping Mist with Surge of Mist Targets") then
                        if cast.envelopingMist(lowest.unit) then return true end
                end
            end
		-- Mana Tea
            if isChecked("Mana Tea") and mana <= getValue("Mana Tea") and getLowAllies(getValue("Mana Tea - Life")) >= getValue("Min Mana Tea Targets") and talent.manaTea  then
                if cast.manaTea() then return true end
            end
		-- Revival
            if isChecked("Revival") and getLowAllies(getValue("Revival")) >= getValue("Min Revival Targets") and cd.revival == 0 then
                SpellStopCasting()
                actionList_CheckVelen()
                if cast.revival() then return true end
            end
		-- ChiJi
            if isChecked("Invoke Chi-Ji, the Red Crane") and talent.invokeChiJiTheRedCrane and cd.invokeChiJiTheRedCrane == 0 then
                if getLowAllies(getValue("Invoke Chi-Ji, the Red Crane")) >= getValue("Min Invoke Chi-Ji, the Red Crane Targets") then
                    SpellStopCasting()
                    if cast.invokeChiJiTheRedCrane("player") then return true end
                end
            end
		-- Life Cocoon
            if isChecked("Life Cocoon") and cd.lifeCocoon == 0  then
                -- Player
                if getOptionValue("Life Cocoon Target") == 1 then
                    if php <= getValue("Life Cocoon") then
                        SpellStopCasting()
                        if cast.lifeCocoon("player") then return true end
                    end
                    -- Target
                elseif getOptionValue("Life Cocoon Target") == 2 then
                    if getHP("target") <= getValue("Life Cocoon") then
                        SpellStopCasting()
                        if cast.lifeCocoon("target") then return true end
                    end
                    -- Mouseover
                elseif getOptionValue("Life Cocoon Target") == 3 then
                    if getHP("mouseover") <= getValue("Life Cocoon") then
                        SpellStopCasting()
                        if cast.lifeCocoon("mouseover") then return true end
                    end
                elseif lowest.hp <= getValue("Life Cocoon") then
                    -- Tank
                    if getOptionValue("Life Cocoon Target") == 4 then
                        if (lowest.role) == "TANK" then
                            SpellStopCasting()
                            if cast.lifeCocoon(lowest.unit) then return true end
                        end

                        -- Healer
                    elseif getOptionValue("Life Cocoon Target") == 5 then
                        if (lowest.role) == "HEALER" then
                            SpellStopCasting()
                            if cast.lifeCocoon(lowest.unit) then return true end
                        end
                        -- Healer/Tank
                    elseif getOptionValue("Life Cocoon Target") == 6 then
                        if (lowest.role) == "HEALER" or (lowest.role) == "TANK" then
                            SpellStopCasting()
                            if cast.lifeCocoon(lowest.unit) then return true end
                        end
                        -- Any
                    elseif  getOptionValue("Life Cocoon Target") == 7 then
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
        if isChecked("Summon Jade Serpent") and lowest.hp >= 55 and talent.summonJadeSerpentStatue then
            --player
            if getOptionValue("Summon Jade Serpent") == 1 then
                param = "player"
                --target
            elseif getOptionValue("Summon Jade Serpent") == 2 and GetObjectExists("target") then
                param = "target"
                --tank
            elseif getOptionValue("Summon Jade Serpent") == 3 and #getTanksTable() > 0 then
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
        if (botSpell ~= spell.envelopingMist and currentTarget ~= UnitGUID(lowest.unit)) or not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= 2 then
		-- Sheilun's Gift'
            if isChecked("Sheilun's Gift") and GetSpellCount(spell.sheilunsGift) >= getValue("Sheilun's Gift Charges") then
                if lowest.hp <= getValue("Sheilun's Gift") then
                    if cast.sheilunsGift(lowest.unit) then return true end
                end
            end
			-- Heal ourself if critical HP.
            --if php < getValue("Critical Health") then
            --    if cd.renewingMist == 0 then
            --       if cast.renewingMist("player") then return true end
            --    else
            --        if cast.envelopingMist("player") then return true end
            --    end
            --end
		-- Zen Pulse	
            if isChecked("Zen Pulse") and talent.zenPulse then
                if lowest.hp <= getValue("Zen Pulse") and getNumEnemies(lowest.unit, 8) >= getValue("Zen Pulse Enemies") then
                    if cast.zenPulse(lowest.unit) then return true end
                end
            end
        -- Chi Wave
			if isChecked("Chi Wave") and talent.chiWave and lowest.hp <= getValue("Chi Wave") then
                if cast.chiWave(lowest.unit) then return true end
            end
		-- Enveloping Mist + Surge of Mist. Avoid wasting proc
			if isChecked("Emergency Enveloping Mist with Surge of Mist") and buff.surgeOfMist.exist and buff.surgeOfMist.remain(br.player.unit) < 6 then
                for i = 1, #br.friend do
					if br.friend[i].hp <= getValue("Emergency Enveloping Mist with Surge of Mist") and (not buff.envelopingMist.exists(br.friend[i].unit) or buff.envelopingMist.remain(br.friend[i].unit) <= getCastTime(spell.envelopingMist)) then
						if cast.envelopingMist(br.friend[i].unit) then return end
					end
				end
            end
		-- Enveloping Mist
            if isChecked("Enveloping Mist") then
                if (not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= getCastTime(spell.envelopingMist)) and lowest.hp <= getValue("Enveloping Mist")then
                    if (isChecked("Enveloping Mist - Tank Only") and (lowest.role) == "TANK") or not isChecked("Enveloping Mist - Tank Only") then
                        if cast.envelopingMist(lowest.unit) then return true end
                    end
                end
            end
		-- Enveloping Mist + Lifecycles
            if isChecked("Enveloping Mist with Lifecycles") then
                if buff.lifeCyclesEnvelopingMist.exists() and (not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= getCastTime(spell.envelopingMist))
                        and lowest.hp <= getValue("Enveloping Mist with Lifecycles") then
                    if (isChecked("Enveloping Mist - Tank Only") and (lowest.role) == "TANK") or not isChecked("Enveloping Mist - Tank Only") then
                        if cast.envelopingMist(lowest.unit) then return true end
                    end
                end
            end
		-- Renewing Mist
            if isChecked("Renewing Mist") and cd.renewingMist == 0 then
                for i = 1, #friends.yards40 do
                    local thisUnit = friends.yards40[i]
                    if thisUnit.hp <= getValue("Renewing Mist") and buff.renewingMist.remain(thisUnit.unit) < gcdMax then
                        if cast.renewingMist(thisUnit.unit) then return true end
                    end
                end
            end
		-- Effuse
            if isChecked("Effuse") and getValue("Effuse Greater or equals") <= lowest.hp and getValue("Effuse Less or equals") >= lowest.hp then
                if botSpell == spell.effuse and currentTarget == UnitGUID(lowest.unit) then
                    return false
                end
                if cast.effuse(lowest.unit) then return true end
            end
        end

        -- DOT damage to teammates cast Enveloping Mist
			if isChecked("DOT cast EM") then
				local debuff_list={
                    spellID = 230345    , stacks = 0   ,   --Crashing Comet
                    spellID = 236603    , stacks = 0   ,   --Rapid Shot
                    spellID = 236712    , stacks = 0   ,   --Lunar Beacon
                    spellID = 242017    , stacks = 2   ,   --Black Winds
				}
				for i=1, #br.friend do
					for k,v in pairs(debuff_list) do
						if getDebuffRemain(br.friend[i].unit,v.spellID) > 4 and getDebuffStacks(br.friend[i].unit,v.spellID) >= v.stacks and not buff.envelopingMist.exists(br.friend[i].unit) and not isCastingSpell(spell.essenceFont) and UnitInRange(br.friend[i].unit) then
							if cast.envelopingMist(br.friend[i].unit) then return end
						end
					end
				end
			end

        -- Ephemeral Paradox trinket
        if hasEquiped(140805) and getBuffRemain("player", 225767) > 2 then
            if cast.effuse(lowest.unit) then return true end
        end
        return false
    end

    local function actionList_AOEHealing()
	-- Chi Burst
        if isChecked("Chi Burst") and talent.chiBurst then
            if castWiseAoEHeal(br.friend,spell.chiBurst,7,getValue("Chi Burst"),getValue("Min Chi Burst Targets"),10,true,true) then return end
        
            --if getUnitsInRect(7,47,false,getValue("Chi Burst")) >= getValue("Min Chi Burst Targets") then
                --actionList_CheckVelen()
                --if cast.chiBurst("player") then return true end
            --end
        end
    -- Essence Font
			if isChecked("Essence Font") and cd.essenceFont == 0 and getLowAlliesInTable(getValue("Essence Font"), friends.yards25) >= getValue("Min Essence Font Targets") then
				if cast.essenceFont() then return true end
			end
    -- Refreshing Jade Wind
        if isChecked("Refreshing Jade Wind") and talent.refreshingJadeWind and getLowAlliesInTable(getValue("Refreshing Jade Wind"), friends.yards8) >= getValue("Min Refreshing Jade Wind Targets")  then
            if cast.refreshingJadeWind() then return true end
        end
        if (botSpell ~= spell.envelopingMist and currentTarget ~= UnitGUID(lowest.unit)) or not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= 2 then
	-- Vivify with Dance of Mist
            if isChecked("Vivify with Dance Of Mist") and buff.danceOfMist.exists() then
                if getLowAlliesInTable(getValue("Vivify with Dance Of Mist"), friends.yards40) >= getValue("Min Vivify with Dance Of Mist Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
	-- Vivify Lifecycles + uplift
            if isChecked("Vivify with Lifecycles + Uplift") and buff.upliftTrance.exists() and buff.lifeCyclesVivify.exists() then
                if getLowAlliesInTable(getValue("Vivify with Lifecycles + Uplift"), friends.yards40) >= getValue("Min Vivify with Lifecycles + Uplift Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
    -- Vivify Uplift
            if isChecked("Vivify with Uplift") and buff.upliftTrance.exists() then
                if getLowAlliesInTable(getValue("Vivify with Uplift"), friends.yards40) >= getValue("Min Vivify with Uplift Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
    -- Vivify lifecycles
            if isChecked("Vivify with Lifecycles") and buff.lifeCyclesVivify.exists() then
                if getLowAlliesInTable(getValue("Vivify with Lifecycles"), friends.yards40) >= getValue("Min Vivify with Lifecycles Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
    -- Vivify normal
            if isChecked("Vivify")  then
                if getLowAlliesInTable(getValue("Vivify"), friends.yards40) >= getValue("Min Vivify Targets") then
                    if cast.vivify(lowest.unit) then return true end
                end
            end
        end
		return false
    end

    local function actionList_DPS()
        if useDPS then
            if lowest.hp >= getValue("DPS") then
                if talent.risingThunder then
                    if cast.risingSunKick() then return true end
                end
                if  isChecked("Spinning Crane Kick") and not talent.spiritOfTheCrane and #enemies.yards8 >= 3 and not isCastingSpell(spell.spinningCraneKick) then
                    if cast.spinningCraneKick() then return true end
                elseif #enemies.yards5 >= 1 then
                    if isChecked("Rising Sun Kick") and cd.risingSunKick  == 0 then
                        if cast.risingSunKick() then return true end
                    end
                    if buff.teachingsOfTheMonastery.stack() == 3 then
                        if cast.blackoutKick() then return true end
                    end
                    if cast.tigerPalm() then return true end
                elseif #enemies.yards40 > 0 and not isCastingSpell(spell.cracklingJadeLighting) and isChecked("Crackling Jade Lightning") then
                    if cast.cracklingJadeLighting() then return true end
                end
            end
        end
        return false
    end

    local function actionList_ThunderFocus()
		
		if isChecked("Thunder Focus Tea + Essence Font") and cd.essenceFont == 0  and getLowAlliesInTable(getValue("Thunder Focus Tea + Essence Font"), friends.yards25) >= getValue("Min Thunder Focus Tea + Essence Font Targets") then
			if cd.thunderFocusTea == 0 then
                if cast.thunderFocusTea() then
                    TFEF = true
                    return true
                end
            end
        end
        if isChecked("Thunder Focus Tea + Vivify") and lowest.hp <= getValue("Thunder Focus Tea + Vivify") and mana <= getValue("Thunder Focus Tea + Vivify - Mana") then
            if cd.thunderFocusTea == 0 then
                if cast.thunderFocusTea() then
                    TFV = true
                    return true
                end
            end
        end
        if isChecked("Thunder Focus Tea + Enveloping Mist") and lowest.hp <= getValue("Thunder Focus Tea + Enveloping Mist") then
             if not buff.envelopingMist.exists(lowest.unit) or buff.envelopingMist.remain(lowest.unit) <= 2 then
                if cd.thunderFocusTea == 0 then
                    if cast.thunderFocusTea() then
                        TFEM = true
                        return true
                    end
                end
            end
        end
        if isChecked("Thunder Focus Tea + Renewing Mist") and cd.renewingMist == 0 and lowest.hp <= getValue("Thunder Focus Tea + Renewing Mist") then
            if cd.thunderFocusTea == 0 then
                if cast.thunderFocusTea() then
                    TFRM = true
                    return true
                end
            end
        end
		if isChecked("Thunder Focus Tea + Essence Font") and cd.essenceFont == 0 and getLowAlliesInTable(getValue("Thunder Focus Tea + Essence Font"), friends.yards25) >= getValue("Min Thunder Focus Tea + Essence Font Targets") then
			if cast.essenceFont() then
                TFEF = false
                return true
            end
        end
        if isChecked("Thunder Focus Tea + Vivify") and lowest.hp <= getValue("Thunder Focus Tea + Vivify") and TFV and mana <= getValue("Thunder Focus Tea + Vivify - Mana") then
            if cast.vivify(lowest.unit) then
                TFV = false
                return true
            end
        end
        if isChecked("Thunder Focus Tea + Enveloping Mist") and lowest.hp <= getValue("Thunder Focus Tea + Enveloping Mist") and TFEM then
            if cast.envelopingMist(lowest.unit) then
                TFEM = false
                return true
            end
        end
        if isChecked("Thunder Focus Tea + Renewing Mist") and cd.renewingMist == 0 and lowest.hp <= getValue("Thunder Focus Tea + Renewing Mist") and TFRM then
            for i = 1, #friends.yards40 do
                local thisUnit = friends.yards40[i]
                if thisUnit.hp <= getValue("Thunder Focus Tea + Renewing Mist") and buff.renewingMist.remain(thisUnit.unit) < gcdMax then
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
        if not IsMounted and not inCombat and not drinking then
            if isChecked("OOC Healing") then
                if actionList_SingleTargetHealing() then return true end
                if actionList_AOEHealing() then return true end
			end
        end
        if not IsMounted() and inCombat then
            if actionList_ThunderFocus() then return true end
        end
        if not IsMounted() and getBuffRemain("player", 192002 ) < 10 then
            if actionList_Extra() then return true end
        end
        if inCombat and not IsMounted() and getBuffRemain("player", 192002 ) < 10 then
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

local id = 270

if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
local rotationName = "Sinweaving"
local version = "1.0.1"

--[[
Discord @ Sinweaver
"5P" mode is for Dungeoning
"20"  mode is for Raiding
--]]

--[[
Based on Lylo's old profile
Edited for double use (Dungeons / Raids) without profile loads
Discord @ Sinweaver
--]]




local colors = {
    blue    = "|cff4285F4",
    red     = "|cffDB4437",
    yellow  = "|cffF4B400",
    green   = "|cff0F9D58",
    white   = "|cffFFFFFF",
    purple  = "|cff9B30FF",
    aqua    = "|cff89E2C7",
    blue2   = "|cffb8d0ff",
    green2  = "|cff469a81",
    blue3   = "|cff6c84ef",
    orange  = "|cffff8000"
}

local text = {
    debug                           = "Debug Info",
    detailedDebugger                = "Detailed Debugger",
    heal                            = {
        options                     = colors.red.."5P | " ..colors.green.."Heal - Options",
        chiWave                     = colors.red.."5P | " ..colors.green.."Chi Wave",
        chiBurst                    = colors.red.."5P | " ..colors.green.."Chi Burst",
        refreshingJadeWind          = colors.red.."5P | " ..colors.green.."Refreshing Jade Wind",
        invokeYulonTheJadeSerpent   = colors.red.."5P | " ..colors.green.."Invoke Yu'lon, the Jade Serpent",
        invokeChiJiTheRedCrane      = colors.red.."5P | " ..colors.green.."Invoke Chi-Ji, the Red Crane",
        lifeCocoon                  = colors.red.."5P | " ..colors.green.."Life Cocoon",
        lifeCocoonMode              = colors.red.."5P | " ..colors.green.."Life Cocoon - Mode",
        revival                     = colors.red.."5P | " ..colors.green.."Revival",
        renewingMist                = colors.red.."5P | " ..colors.green.."Renewing Mist",
        vivify                      = colors.red.."5P | " ..colors.green.."Vivify",
        envelopingBreath            = colors.red.."5P | " ..colors.green.."Enveloping Breath",
        envelopingMist              = colors.red.."5P | " ..colors.green.."Enveloping Mist",
        essenceFont                 = colors.red.."5P | " ..colors.green.."Essence Font",
		faelineStomp				= colors.red.."5P | " ..colors.green.."Faeline Stomp",
		zenPulse					= colors.red.."5P | " ..colors.green.."Zen Pulse",
        soothingMist                = {
            soothingMist            = colors.red.."5P | " ..colors.aqua.."Soothing Mist",
            vivify                  = colors.red.."5P | " ..colors.aqua.."Vivify",
            vivifyAoE               = colors.red.."5P | " ..colors.aqua.."Vivify AoE",
            envelopingMist          = colors.red.."5P | " ..colors.aqua.."Enveloping Mist",
            expelHarm               = colors.red.."5P | " ..colors.aqua.."Expel Harm",
        },
        outOfCombat                 = {
            essenceFont             = colors.red.."5P | " ..colors.green2.."Essence Font",
            vivify                  = colors.red.."5P | " ..colors.green2.."Vivify",
            renewingMist            = colors.red.."5P | " ..colors.green2.."Renewing Mist",
        },
        thunderFocusTea             = {
            envelopingMist          = colors.red.."5P | " ..colors.blue3.."Enveloping Mist",
            renewingMist            = colors.red.."5P | " ..colors.blue3.."Renewing Mist",
            vivify                  = colors.red.."5P | " ..colors.blue3.."Vivify",
            risingSunKick           = colors.red.."5P | " ..colors.blue3.."Rising Sun Kick",
        }
    },
    utility = {
        options                     = colors.red.."5P | " ..colors.yellow.."Utility - Options",
        tigersLust                  = colors.red.."5P | " ..colors.yellow.."Tiger's Lust",
        manaTea                     = colors.red.."5P | " ..colors.yellow.."Mana Tea",
        manaTeaWithYulon            = colors.red.."5P | " ..colors.yellow.."Mana Tea with Yulon",
        summonJadeSerpentStatue     = colors.red.."5P | " ..colors.yellow.."Summon Jade Serpent Statue",
        arcaneTorrent               = colors.red.."5P | " ..colors.yellow.."Arcane Torrent",
        ringOfPeace                 = colors.red.."5P | " ..colors.yellow.."Ring of Peace",
		spearHandStrike             = colors.red.."5P | " ..colors.yellow.."Spear Hand Strike",
    },
    manual = {
        options                     = colors.red.."5P | " ..colors.blue.."Manual - Options",
        chiBurst                    = colors.red.."5P | " ..colors.blue.."Chi Burst",
        rollOrChiTorpedo            = colors.red.."5P | " ..colors.blue.."Chi Torpedo / Roll",
        manaTea                     = colors.red.."5P | " ..colors.blue.."Mana Tea",
        songOfChiJiOrRingOfPeace    = colors.red.."5P | " ..colors.blue.."Song of Chi-Ji / Ring of Peace",
        diffuseMagicOrDampenHarm    = colors.red.."5P | " ..colors.blue.."Diffuse Magic / Dampen Harm",
        transcendenceOrTransfer     = colors.red.."5P | " ..colors.blue.."Transcendence / Transfer",
        lifeCocoon                  = colors.red.."5P | " ..colors.blue.."Life Cocoon",
        revival                     = colors.red.."5P | " ..colors.blue.."Revival",
        invokeYulonTheJadeSerpent   = colors.red.."5P | " ..colors.blue.."Invoke Yu'lon, the Jade Serpent",
        invokeChiJiTheRedCrane      = colors.red.."5P | " ..colors.blue.."Invoke Chi-Ji, the Red Crane",
        summonJadeSerpentStatue     = colors.red.."5P | " ..colors.blue.."Summon Jade Serpent Statue",
        tigersLust                  = colors.red.."5P | " ..colors.blue.."Tiger's Lust",
        fortifyingBrew              = colors.red.."5P | " ..colors.blue.."Fortifying Brew",
        legSweep                    = colors.red.."5P | " ..colors.blue.."Leg Sweep",

    },
    selfDefense = {
        options                                     = colors.red.."5P | " ..colors.purple.."Self Defense - Options",
        healingElixirOrDiffuseMagicOrDampenHarm     = colors.red.."5P | " ..colors.purple.."Healing Elixir / Diffuse Magic / Dampen Harm",
        fortifyingBrew                              = colors.red.."5P | " ..colors.purple.."Fortifying Brew",
        legSweep                                    = colors.red.."5P | " ..colors.purple.."Leg Sweep",
        expelHarm                                   = colors.red.."5P | " ..colors.purple.."Expel Harm",
    },
    damage = {
        options                                     = colors.red.."5P | " ..colors.red.."Damage - Options",
        dpsThreshold                                = colors.red.."5P | " ..colors.red.."DPS Threshold",
        chiJiDpsThreshold                           = colors.red.."5P | " ..colors.red.."Chi-Ji DPS Threshold",
        cracklingJadeLightning                      = colors.red.."5P | " ..colors.red.."Crackling Jade Lightning",
        touchOfDeath                                = colors.red.."5P | " ..colors.red.."Touch of Death",
    }
}

local text2 = {
    debug2                           = "Debug Info",
    detailedDebugger2                = "Detailed Debugger",
	heal2 = {
        options2                     = colors.red.."20P | " ..colors.green.."Heal - Options",
        chiWave2                     = colors.red.."20P | " ..colors.green.."Chi Wave",
        chiBurst2                    = colors.red.."20P | " ..colors.green.."Chi Burst",
        refreshingJadeWind2          = colors.red.."20P | " ..colors.green.."Refreshing Jade Wind",
        invokeYulonTheJadeSerpent2   = colors.red.."20P | " ..colors.green.."Invoke Yu'lon, the Jade Serpent",
        invokeChiJiTheRedCrane2      = colors.red.."20P | " ..colors.green.."Invoke Chi-Ji, the Red Crane",
        lifeCocoon2                  = colors.red.."20P | " ..colors.green.."Life Cocoon",
        lifeCocoonMode2              = colors.red.."20P | " ..colors.green.."Life Cocoon - Mode",
        revival2                     = colors.red.."20P | " ..colors.green.."Revival",
        renewingMist2                = colors.red.."20P | " ..colors.green.."Renewing Mist",
        vivify2                      = colors.red.."20P | " ..colors.green.."Vivify",
        envelopingBreath2            = colors.red.."20P | " ..colors.green.."Enveloping Breath",
        envelopingMist2              = colors.red.."20P | " ..colors.green.."Enveloping Mist",
        essenceFont2                 = colors.red.."20P | " ..colors.green.."Essence Font",
		faelineStomp2				 = colors.red.."20P | " ..colors.green.."Faeline Stomp",
		zenPulse2					 = colors.red.."20P | " ..colors.green.."Zen Pulse",
        soothingMist2                = {
            soothingMist2            = colors.red.."20P | " ..colors.aqua.."Soothing Mist",
            vivify2                  = colors.red.."20P | " ..colors.aqua.."Vivify",
            vivifyAoE2               = colors.red.."20P | " ..colors.aqua.."Vivify AoE",
            envelopingMist2          = colors.red.."20P | " ..colors.aqua.."Enveloping Mist",
            expelHarm2               = colors.red.."20P | " ..colors.aqua.."Expel Harm",
        },
        outOfCombat2                 = {
            essenceFont2             = colors.red.."20P | " ..colors.green2.."Essence Font",
            vivify2                  = colors.red.."20P | " ..colors.green2.."Vivify",
            renewingMist2            = colors.red.."20P | " ..colors.green2.."Renewing Mist",
        },
        thunderFocusTea2             = {
            envelopingMist2          = colors.red.."20P | " ..colors.blue3.."Enveloping Mist",
            renewingMist2            = colors.red.."20P | " ..colors.blue3.."Renewing Mist",
            vivify2                  = colors.red.."20P | " ..colors.blue3.."Vivify",
            risingSunKick2           = colors.red.."20P | " ..colors.blue3.."Rising Sun Kick",
		}
    },
    utility2 = {
        options2                     = colors.red.."20P | " ..colors.yellow.."Utility - Options",
        tigersLust2                  = colors.red.."20P | " ..colors.yellow.."Tiger's Lust",
        manaTea2                     = colors.red.."20P | " ..colors.yellow.."Mana Tea",
        manaTeaWithYulon2            = colors.red.."20P | " ..colors.yellow.."Mana Tea with Yulon",
        summonJadeSerpentStatue2     = colors.red.."20P | " ..colors.yellow.."Summon Jade Serpent Statue",
        arcaneTorrent2               = colors.red.."20P | " ..colors.yellow.."Arcane Torrent",
        ringOfPeace2                 = colors.red.."20P | " ..colors.yellow.."Ring of Peace",
		spearHandStrike2             = colors.red.."20P | " ..colors.yellow.."Spear Hand Strike",
    },
    manual2 = {
        options2                     = colors.red.."20P | " ..colors.blue.."Manual - Options",
        chiBurst2                    = colors.red.."20P | " ..colors.blue.."Chi Burst",
        rollOrChiTorpedo2            = colors.red.."20P | " ..colors.blue.."Chi Torpedo / Roll",
        manaTea2                     = colors.red.."20P | " ..colors.blue.."Mana Tea",
        songOfChiJiOrRingOfPeace2    = colors.red.."20P | " ..colors.blue.."Song of Chi-Ji / Ring of Peace",
        diffuseMagicOrDampenHarm2    = colors.red.."20P | " ..colors.blue.."Diffuse Magic / Dampen Harm",
        transcendenceOrTransfer2     = colors.red.."20P | " ..colors.blue.."Transcendence / Transfer",
        lifeCocoon2                  = colors.red.."20P | " ..colors.blue.."Life Cocoon",
        revival2                     = colors.red.."20P | " ..colors.blue.."Revival",
        invokeYulonTheJadeSerpent2   = colors.red.."20P | " ..colors.blue.."Invoke Yu'lon, the Jade Serpent",
        invokeChiJiTheRedCrane2      = colors.red.."20P | " ..colors.blue.."Invoke Chi-Ji, the Red Crane",
        summonJadeSerpentStatue2     = colors.red.."20P | " ..colors.blue.."Summon Jade Serpent Statue",
        tigersLust2                  = colors.red.."20P | " ..colors.blue.."Tiger's Lust",
        fortifyingBrew2              = colors.red.."20P | " ..colors.blue.."Fortifying Brew",
        legSweep2                    = colors.red.."20P | " ..colors.blue.."Leg Sweep",
    },
    selfDefense2 = {
        options2                                     = colors.red.."20P | " ..colors.purple.."Self Defense - Options",
        healingElixirOrDiffuseMagicOrDampenHarm2     = colors.red.."20P | " ..colors.purple.."Healing Elixir / Diffuse Magic / Dampen Harm",
        fortifyingBrew2                              = colors.red.."20P | " ..colors.purple.."Fortifying Brew",
        legSweep2                                    = colors.red.."20P | " ..colors.purple.."Leg Sweep",
        expelHarm2                                   = colors.red.."20P | " ..colors.purple.."Expel Harm",
    },
    damage2 = {
        options2                                     = colors.red.."20P | " ..colors.red.."Damage - Options",
        dpsThreshold2                                = colors.red.."20P | " ..colors.red.."DPS Threshold",
        chiJiDpsThreshold2                           = colors.red.."20P | " ..colors.red.."Chi-Ji DPS Threshold",
        cracklingJadeLightning2                      = colors.red.."20P | " ..colors.red.."Crackling Jade Lightning",
        touchOfDeath2                                = colors.red.."20P | " ..colors.red.."Touch of Death",
    }
}

local function createToggles()
    local Content = {
        [1] = { mode = "5P", value = 1 , overlay = "5 Players Mode", tip = "Dungeon Settings", highlight = 1, icon = 388031},
        [2] = { mode = "20P", value = 2 , overlay = "20 Players Mode", tip = "Raid Settings", highlight = 1, icon = 388615}
    }
    br.ui:createToggle(Content,"Content",1,0)
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.lifeCocoon },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.lifeCocoon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.lifeCocoon }
    }
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    local ThunderFocusTeaModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Thunder Focus Tea Mode Auto", tip = "Thunder Focus Tea Mode Auto", highlight = 1, icon = br.player.spell.thunderFocusTea },
        [2] = { mode = "EM", value = 2, overlay = "Thunder Focus Tea Mode - Enveloping Mist", tip = "Thunder Focus Tea Mode - Enveloping Mist", highlight = 1, icon = br.player.spell.envelopingMist },
        [3] = { mode = "VVF", value = 3, overlay = "Thunder Focus Tea Mode - Vivify", tip = "Thunder Focus Tea Mode - Vivify", highlight = 1, icon = br.player.spell.vivify },
        [4] = { mode = "RM", value = 4, overlay = "Thunder Focus Tea Mode - Renewing Mist", tip = "Thunder Focus Tea Mode - Renewing Mist", highlight = 1, icon = br.player.spell.renewingMist },
        [5] = { mode = "RSK", value = 5, overlay = "Thunder Focus Tea Mode - Rising Sun Kick", tip = "Thunder Focus Tea Mode - Rising Sun Kick", highlight = 1, icon = br.player.spell.risingSunKick }
    }
    br.ui:createToggle(ThunderFocusTeaModes,"ThunderFocusTea", 3, 0)
    local DPSModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.tigerPalm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 1, icon = br.player.spell.spinningCraneKick },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 1, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.vivify}
    }
    br.ui:createToggle(DPSModes,"DPS", 4, 0)
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.paralysis },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.paralysis }
    }
    br.ui:createToggle(InterruptModes,"Interrupt", 5, 0)
    local DetoxModes = {
        [1] = { mode = "On", value = 1, overlay = "Detox Enabled", tip = "Detox Enabled", highlight = 1, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2, overlay = "Detox Disabled", tip = "Detox Disabled", highlight = 0, icon = br.player.spell.detox }
    }
    br.ui:createToggle(DetoxModes,"Detox", 6, 0)
end

local labels = {
    lowest = nil,
    dynamic = {
        range5 = nil,
        range40 = nil,
    },
    lowAllies = {
        essenceFont                 = nil,
        essenceFontOoc              = nil,
        revival                     = nil,
        invokeYulonTheJadeSerpent   = nil,
        invokeChiJiTheRedCrane      = nil,
    }
}

local function createOptions()
    local optionTable
	
		
    local function welcome()
		section = br.ui:createSection(br.ui.window.profile, "Welcome")
		br.ui:createText(section, colors.green    .. "5P".. colors.blue .." (5 Players) mode is for Dungeoning ")
		br.ui:createText(section, colors.green    .. "20P".. colors.blue .." (20 Players) mode is for Raiding ")
        br.ui:createText(section, "")
		br.ui:createText(section, colors.blue     .. "Based on Lylo's old profile")
        br.ui:createText(section, colors.blue     .. "Edited for double use (Dungeons / Raids) without profile loads")
        br.ui:createText(section, "")
        br.ui:createText(section, colors.blue     .. "Still W.I.P, default values for settings need to be hardtuned ")
        br.ui:createText(section, colors.blue     .. "Can still be use with custom settings")
        br.ui:createText(section, colors.blue     .. "1.0.0 update will not broke your saved settings")
        br.ui:checkSectionState(section)
    end

	local function dungeonsettings()
        section = br.ui:createSection(br.ui.window.profile, text.heal.options)
        br.ui:createText(section, "5P | CDs - Options")
        br.ui:createSpinner(section, text.heal.lifeCocoon, 30, 1, 100, 5, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDropdownWithout(section, text.heal.lifeCocoonMode,   {colors.blue .. "Any", colors.green .. "Tank", colors.red .. "Tank/Healer"}, 2, "Use ability only on selected type ".. colors.green .. "(default: Tank)")
        br.ui:createDoubleSpinner(section, text.heal.revival,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 50, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text.heal.invokeYulonTheJadeSerpent,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text.heal.invokeChiJiTheRedCrane,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createText(section, "5P | Thunder Focus Tea - Options")
        br.ui:createSpinner(section, text.heal.thunderFocusTea.envelopingMist,  50, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDoubleSpinner(section, text.heal.thunderFocusTea.vivify,
                { number = 80, min = 1, max = 100, step = 1, tooltip = "Mana of player to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createSpinner(section, text.heal.thunderFocusTea.renewingMist,    90, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createCheckbox(section, text.heal.thunderFocusTea.risingSunKick,  "Enable auto usage of this spell")
        br.ui:createText(section, "5P | Soothing Mist - Options")
        br.ui:createSpinner(section, text.heal.soothingMist.soothingMist, 85, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text.heal.soothingMist.envelopingMist, 80, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text.heal.soothingMist.vivify, 75, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDoubleSpinner(section, text.heal.soothingMist.vivifyAoE,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends with renewing mist buff" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createSpinner(section, text.heal.soothingMist.expelHarm, 75, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createText(section, "5P | Other - Options")
        br.ui:createSpinner(section, text.heal.renewingMist, 100, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text.heal.vivify, 80, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text.heal.envelopingMist, 70, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createCheckbox(section, text.heal.chiWave, "Enable auto usage of this spell")
        br.ui:createDoubleSpinner(section, text.heal.chiBurst,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 85, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text.heal.refreshingJadeWind,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 75, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text.heal.essenceFont,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text.heal.envelopingBreath,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
		br.ui:createDoubleSpinner(section, text.heal.faelineStomp,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 95, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
		br.ui:createSpinner(section, text.heal.zenPulse, 90, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, text.utility.options)
        br.ui:createCheckbox(section, text.utility.tigersLust,       "Enable auto usage of this spell on player or allies")
        br.ui:createSpinner(section, text.utility.manaTea, 60, 1, 100, 5, "Mana of player to cast spell")
        br.ui:createCheckbox(section, text.utility.manaTeaWithYulon,       "Enable auto usage of this spell when Yulon is activated")
        br.ui:createDropdown(section, text.utility.summonJadeSerpentStatue, {"Around Tank", "Around Player"}, 2, "Enable usage of this spell around option", "Select")
        br.ui:createSpinner(section, text.utility.arcaneTorrent, 70, 1, 100, 5, "Mana of player to cast spell")
        br.ui:createCheckbox(section, text.utility.ringOfPeace,       "Enable auto usage of this spell to interrupt")
		br.ui:createCheckbox(section, text.utility.spearHandStrike,       "Enable auto usage of this spell to interrupt")
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, text.selfDefense.options)
        br.ui:createSpinner(section, text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm,  65, 1, 100, 05, "Enable auto usage of this spell", "Health of player to cast spell")
        br.ui:createSpinner(section, text.selfDefense.fortifyingBrew,                           65, 1, 100, 05, "Enable auto usage of this spell", "Health of player to cast spell")
        br.ui:createDoubleSpinner(section, text.selfDefense.legSweep,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Number of Units in 5 Yards to Cast At" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "or Health Percent to Cast At" }, false)
        br.ui:createSpinner(section, text.selfDefense.expelHarm,                                40, 0, 100, 05, "Enable auto usage of this spell", "Health Percent to Cast At")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.damage.options)
        br.ui:createSpinnerWithout(section, text.damage.dpsThreshold,           85, 1, 100, 5, "Lowest friend HP has to be higher then")
        br.ui:createSpinnerWithout(section, text.damage.chiJiDpsThreshold,      60, 1, 100, 5, "Lowest friend HP has to be higher then")

        br.ui:createCheckbox(section, text.damage.cracklingJadeLightning,       "Enable auto usage of this spell")
        br.ui:createDropdown(section, text.damage.touchOfDeath,       {colors.blue .. "Always", colors.green .. "Bosses", colors.red .. "Never"}, 2, "Enable auto usage of this spell.", "Select")
        br.ui:checkSectionState(section)
	end
	
	local function raidsettings()
        section = br.ui:createSection(br.ui.window.profile, text2.heal2.options2)
        br.ui:createText(section, "20P | CDs - Options")
        br.ui:createSpinner(section, text2.heal2.lifeCocoon2, 30, 1, 100, 5, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDropdownWithout(section, text2.heal2.lifeCocoonMode2,   {colors.blue .. "Any", colors.green .. "Tank", colors.red .. "Tank/Healer"}, 2, "Use ability only on selected type ".. colors.green .. "(default: Tank)")
        br.ui:createDoubleSpinner(section, text2.heal2.revival2,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 50, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text2.heal2.invokeYulonTheJadeSerpent2,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text2.heal2.invokeChiJiTheRedCrane2,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createText(section, "20P | Thunder Focus Tea - Options")
        br.ui:createSpinner(section, text2.heal2.thunderFocusTea2.envelopingMist2,  50, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDoubleSpinner(section, text2.heal2.thunderFocusTea2.vivify2,
                { number = 80, min = 1, max = 100, step = 1, tooltip = "Mana of player to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createSpinner(section, text2.heal2.thunderFocusTea2.renewingMist2,    90, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createCheckbox(section, text2.heal2.thunderFocusTea2.risingSunKick2,  "Enable auto usage of this spell")
        br.ui:createText(section, "20P | Soothing Mist - Options")
        br.ui:createSpinner(section, text2.heal2.soothingMist2.soothingMist2, 85, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text2.heal2.soothingMist2.envelopingMist2, 80, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text2.heal2.soothingMist2.vivify2, 75, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDoubleSpinner(section, text2.heal2.soothingMist2.vivifyAoE2,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends with renewing mist buff" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createSpinner(section, text2.heal2.soothingMist2.expelHarm2, 75, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createText(section, "20P | Other - Options")
        br.ui:createSpinner(section, text2.heal2.renewingMist2, 94, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text2.heal2.vivify2, 80, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(section, text2.heal2.envelopingMist2, 70, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createCheckbox(section, text2.heal2.chiWave2, "Enable auto usage of this spell")
        br.ui:createDoubleSpinner(section, text2.heal2.chiBurst2,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 85, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text2.heal2.refreshingJadeWind2,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 75, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text2.heal2.essenceFont2,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(section, text2.heal2.envelopingBreath2,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
		br.ui:createDoubleSpinner(section, text2.heal2.faelineStomp2,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 95, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
		br.ui:createSpinner(section, text2.heal2.zenPulse2, 90, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, text2.utility2.options2)
        br.ui:createCheckbox(section, text2.utility2.tigersLust2,       "Enable auto usage of this spell on player or allies")
        br.ui:createSpinner(section, text2.utility2.manaTea2, 60, 1, 100, 5, "Mana of player to cast spell")
        br.ui:createCheckbox(section, text2.utility2.manaTeaWithYulon2,       "Enable auto usage of this spell when Yulon is activated")
        br.ui:createDropdown(section, text2.utility2.summonJadeSerpentStatue2, {"Around Tank", "Around Player"}, 2, "Enable usage of this spell around option", "Select")
        br.ui:createSpinner(section, text2.utility2.arcaneTorrent2, 70, 1, 100, 5, "Mana of player to cast spell")
        br.ui:createCheckbox(section, text2.utility2.ringOfPeace2,       "Enable auto usage of this spell to interrupt")
		br.ui:createCheckbox(section, text2.utility2.spearHandStrike2,       "Enable auto usage of this spell to interrupt")
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, text2.selfDefense2.options2)
        br.ui:createSpinner(section, text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2,  65, 1, 100, 05, "Enable auto usage of this spell", "Health of player to cast spell")
        br.ui:createSpinner(section, text2.selfDefense2.fortifyingBrew2,                           65, 1, 100, 05, "Enable auto usage of this spell", "Health of player to cast spell")
        br.ui:createDoubleSpinner(section, text2.selfDefense2.legSweep2,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Number of Units in 5 Yards to Cast At" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "or Health Percent to Cast At" }, false)
        br.ui:createSpinner(section, text2.selfDefense2.expelHarm2,                                40, 0, 100, 05, "Enable auto usage of this spell", "Health Percent to Cast At")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text2.damage2.options2)
        br.ui:createSpinnerWithout(section, text2.damage2.dpsThreshold2,           85, 1, 100, 5, "Lowest friend HP has to be higher then")
        br.ui:createSpinnerWithout(section, text2.damage2.chiJiDpsThreshold2,      60, 1, 100, 5, "Lowest friend HP has to be higher then")

        br.ui:createCheckbox(section, text2.damage2.cracklingJadeLightning2,       "Enable auto usage of this spell")
        br.ui:createDropdown(section, text2.damage2.touchOfDeath2,       {colors.blue .. "Always", colors.green .. "Bosses", colors.red .. "Never"}, 2, "Enable auto usage of this spell.", "Select")
        br.ui:checkSectionState(section)
	end

    optionTable = {
        {
            [1] = "Welcome",
            [2] = welcome,
        },
        {
            [1] = "Dungeon Settings",
            [2] = dungeonsettings,
        },
		{
            [1] = "Raid Settings",
            [2] = raidsettings,
        }
	}
    return optionTable
end

-- Variables
local buff
local cast
local cd
local charges
local dynamic
local enemies
local friends
local lastSoothingMist = {
    hp = nil,
    unit = nil
}
local player
local spell
local talent
local totemInfo
local summonJadeSerpentStatuePosition = {
    x = 0,
    y = 0,
    z = 0,
}
local transcendencePosition = {
    x = 0,
    y = 0,
    z = 0,
}
local tanks
local ui
local unit


local debugMessage = function(message)
    if br.player.ui.checked(text.detailedDebugger) then
        print(colors.red.. date() .. colors.white .. ": ".. message)
    end
end

local getRealHP = function(param)
    return 100*(br._G.UnitHealth(param)+br._G.UnitGetIncomingHeals(param,"player"))/br._G.UnitHealthMax(param)
end


local actionList = {
    healing = {
        CDs = function()
            -- Life Cocoon
			if br.player.ui.mode.content == 1 then
            if ui.checked(text.heal.lifeCocoon) and cd.lifeCocoon.ready() then
                local lifeCocoonMode = ui.value(text.heal.lifeCocoonMode)
                if friends.lowest.role == "TANK" or (lifeCocoonMode == 3 and friends.lowest.role == "HEALER") or lifeCocoonMode == 1 then
                    if friends.lowest.hp <= ui.value(text.heal.lifeCocoon) then
                        if cast.lifeCocoon(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.lifeCocoon) return true else ui.debug("[FAIL]: "..text.heal.lifeCocoon) return false end
                    end
                end
            end
			elseif br.player.ui.mode.content == 2 then
		    if ui.checked(text2.heal2.lifeCocoon2) and cd.lifeCocoon.ready() then
                local lifeCocoonMode = ui.value(text2.heal2.lifeCocoonMode2)
                if friends.lowest.role == "TANK" or (lifeCocoonMode == 3 and friends.lowest.role == "HEALER") or lifeCocoonMode == 1 then
                    if friends.lowest.hp <= ui.value(text2.heal2.lifeCocoon2) then
                        if cast.lifeCocoon(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.lifeCocoon2) return true else ui.debug("[FAIL]: "..text2.heal2.lifeCocoon2) return false end
                    end
                end
            end
			end
            -- Revival
			if br.player.ui.mode.content == 1 then
            if ui.checked(text.heal.revival) and cd.revival.ready() then
                if friends.lowAllies.revival >= ui.value(text.heal.revival.."1") then
                    if cast.revival(player.unit) then ui.debug("[SUCCESS]: "..text.heal.revival) return true else ui.debug("[FAIL]: "..text.heal.revival) return false end
                end
            end
			elseif br.player.ui.mode.content == 2 then
            if ui.checked(text2.heal2.revival2) and cd.revival.ready() then
                if friends.lowAllies.revival >= ui.value(text2.heal2.revival2.."1") then
                    if cast.revival(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.revival2) return true else ui.debug("[FAIL]: "..text2.heal2.revival2) return false end
                end
            end
			end
            -- Invoke Yu'lon, the Jade Serpent
			if br.player.ui.mode.content == 1 then	
            if ui.checked(text.heal.invokeYulonTheJadeSerpent) and cd.invokeYulonTheJadeSerpent.ready() then
                if not talent.invokeChiJiTheRedCrane and friends.lowAllies.invokeYulonTheJadeSerpent >= ui.value(text.heal.invokeYulonTheJadeSerpent.."1") then
                    if cast.invokeYulonTheJadeSerpent(player.unit) then ui.debug("[SUCCESS]: "..text.heal.invokeYulonTheJadeSerpent) return true else ui.debug("[FAIL]: "..text.heal.invokeYulonTheJadeSerpent) return false end
                end
            end
			elseif br.player.ui.mode.content == 2 then
		   if ui.checked(text2.heal2.invokeYulonTheJadeSerpent2) and cd.invokeYulonTheJadeSerpent.ready() then
                if not talent.invokeChiJiTheRedCrane and friends.lowAllies.invokeYulonTheJadeSerpent >= ui.value(text2.heal2.invokeYulonTheJadeSerpent2.."1") then
                    if cast.invokeYulonTheJadeSerpent(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.invokeYulonTheJadeSerpent2) return true else ui.debug("[FAIL]: "..text2.heal2.invokeYulonTheJadeSerpent2) return false end
                end
            end
			end
            -- Invoke Chi-Ji, The Red Crane
			if br.player.ui.mode.content == 1 then	
			if ui.checked(text.heal.invokeChiJiTheRedCrane) and cd.invokeChiJiTheRedCrane.ready() then
                if talent.invokeChiJiTheRedCrane and friends.lowAllies.invokeChiJiTheRedCrane >= ui.value(text.heal.invokeChiJiTheRedCrane.."1") then
                    if cast.invokeChiJiTheRedCrane(player.unit) then ui.debug("[SUCCESS]: "..text.heal.invokeChiJiTheRedCrane) return true else ui.debug("[FAIL]: "..text.heal.invokeChiJiTheRedCrane) return false end
                end
            end
			elseif br.player.ui.mode.content == 2 then	
            if ui.checked(text2.heal2.invokeChiJiTheRedCrane2) and cd.invokeChiJiTheRedCrane.ready() then
                if talent.invokeChiJiTheRedCrane and friends.lowAllies.invokeChiJiTheRedCrane >= ui.value(text2.heal2.invokeChiJiTheRedCrane2.."1") then
                    if cast.invokeChiJiTheRedCrane(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.invokeChiJiTheRedCrane2) return true else ui.debug("[FAIL]: "..text2.heal2.invokeChiJiTheRedCrane2) return false end
                end
            end
			end
		end,

    renewingMist = function()
		if br.player.ui.mode.content == 1 then
            if cast.active.essenceFont() then
                return nil
            end
            if cast.active.soothingMist() and friends.lowest.hp <= 60 then
                return nil
            end
            -- Renewing Mist
            debugMessage("Renewing Mist Init")
            if ui.checked(text.heal.renewingMist) and charges.renewingMist.exists() and cd.renewingMist.ready() then
                local renewingMistUnit

                for i = 1, #tanks do
                    local tempUnit = tanks[i]
                    if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text.heal.renewingMist) and renewingMistUnit == nil then
                        renewingMistUnit = tempUnit
                    end
                end

                if renewingMistUnit == nil then
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text.heal.renewingMist) and renewingMistUnit == nil then
                            renewingMistUnit = tempUnit
                        end
                    end
                end

                if renewingMistUnit == nil then
                    if not buff.renewingMist.exists(player.unit) and player.hp <= ui.value(text.heal.renewingMist) then
                        renewingMistUnit = player
                    end
                end

                if renewingMistUnit ~= nil then
                    if cast.renewingMist(renewingMistUnit.unit) then ui.debug("[SUCCESS]: "..text.heal.renewingMist) return true else ui.debug("[FAIL]: "..text.heal.renewingMist) return false end
                end
            end
            debugMessage("Renewing Mist End")
		elseif br.player.ui.mode.content == 2 then
		    if cast.active.essenceFont() then
                return nil
            end
            if cast.active.soothingMist() and friends.lowest.hp <= 60 then
                return nil
            end
            -- Renewing Mist
            debugMessage("Renewing Mist Init")
            if ui.checked(text2.heal2.renewingMist2) and charges.renewingMist.exists() and cd.renewingMist.ready() then
                local renewingMistUnit

                for i = 1, #tanks do
                    local tempUnit = tanks[i]
                    if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text2.heal2.renewingMist2) and renewingMistUnit == nil then
                        renewingMistUnit = tempUnit
                    end
                end

                if renewingMistUnit == nil then
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text2.heal2.renewingMist2) and renewingMistUnit == nil then
                            renewingMistUnit = tempUnit
                        end
                    end
                end

                if renewingMistUnit == nil then
                    if not buff.renewingMist.exists(player.unit) and player.hp <= ui.value(text2.heal2.renewingMist2) then
                        renewingMistUnit = player
                    end
                end

                if renewingMistUnit ~= nil then
                    if cast.renewingMist(renewingMistUnit.unit) then ui.debug("[SUCCESS]: "..text2.heal2.renewingMist2) return true else ui.debug("[FAIL]: "..text2.heal2.renewingMist2) return false end
                end
            end
            debugMessage("Renewing Mist End")
		end
    end,
	
	faelineStompRotation = function()
		if br.player.ui.mode.content == 1 then
			debugMessage("Faeline Stomp Init")
			if ui.checked(text.heal.faelineStomp) and cd.faelineStomp.ready() and talent.faelineStomp then
				local lowAlliesTargetsfaelineStomp = br.getUnitsInRect(7 , 40, false, ui.value(text.heal.faelineStomp.."2"))
				if lowAlliesTargetsfaelineStomp >= ui.value(text.heal.faelineStomp.."1") then
					if cast.faelineStomp(player.unit) then ui.debug("[SUCCESS]: "..text.heal.faelineStomp) return true else ui.debug("[FAIL]: "..text.heal.faelineStomp) return false end
				end
			end
			debugMessage("Faeline Stomp End")
		elseif br.player.ui.mode.content == 2 then
			debugMessage("Faeline Stomp Init")
			if ui.checked(text2.heal2.faelineStomp2) and cd.faelineStomp.ready() and talent.faelineStomp then
				local lowAlliesTargetsfaelineStomp2 = br.getUnitsInRect(7 , 40, false, ui.value(text2.heal2.faelineStomp2.."2"))
				if lowAlliesTargetsfaelineStomp2 >= ui.value(text2.heal2.faelineStomp2.."1") then
					if cast.faelineStomp(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.faelineStomp2) return true else ui.debug("[FAIL]: "..text2.heal2.faelineStomp2) return false end
				end
			end
			debugMessage("Faeline Stomp End")
		end
    end,
	
	zenPulseRotation = function()
		if br.player.ui.mode.content == 1 then
			debugMessage("Zen Pulse Init")
			if ui.checked(text.heal.zenPulse) and cd.zenPulse.ready() and talent.zenPulse then
				local lowAlliesTargetszenPulse = br.getUnitsInRect(7 , 40, false, ui.value(text.heal.zenPulse.."2"))
				if lowAlliesTargetszenPulse >= ui.value(text.heal.zenPulse.."1") then
					if cast.zenPulse(player.unit) then ui.debug("[SUCCESS]: "..text.heal.zenPulse) return true else ui.debug("[FAIL]: "..text.heal.zenPulse) return false end
				end
			end
			debugMessage("Zen Pulse End")
		elseif br.player.ui.mode.content == 2 then
			debugMessage("Zen Pulse Init")
			if ui.checked(text.heal.zenPulse2) and cd.zenPulse.ready() and talent.zenPulse then
				local lowAlliesTargetszenPulse2 = br.getUnitsInRect(7 , 40, false, ui.value(text2.heal2.zenPulse2.."2"))
				if lowAlliesTargetszenPulse2 >= ui.value(text2.heal2.zenPulse2.."1") then
					if cast.zenPulse(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.zenPulse2) return true else ui.debug("[FAIL]: "..text2.heal2.zenPulse2) return false end
				end
			end
			debugMessage("Zen Pulse End")
		end
    end,
	
    soothingMistRotation = function()
		if br.player.ui.mode.content == 1 then
            -- Cancel Soothing Mist
            if cast.active.soothingMist() then
                if getRealHP(lastSoothingMist.unit) - friends.lowest.hp >= 20 or getRealHP(lastSoothingMist.unit) >= ui.value(text.heal.soothingMist.soothingMist)+5 then
                    if cast.cancel.soothingMist() then ui.debug("[SUCCESS]: Cancel - "..text.heal.soothingMist.soothingMist) return true else ui.debug("[FAIL]: Cancel - "..text.heal.soothingMist.soothingMist) return false end
                end
            end
            -- Soothing Mist
            if ui.checked(text.heal.soothingMist.soothingMist) and cd.soothingMist.ready() and not cast.active.soothingMist() and not player.isMoving then
                if friends.lowest.hp <= ui.value(text.heal.soothingMist.soothingMist) then
                    if cast.soothingMist(friends.lowest.unit) then
                        lastSoothingMist = {
                            hp = friends.lowest.hp,
                            unit = friends.lowest.unit
                        }
                        ui.debug("[SUCCESS]: "..text.heal.soothingMist.soothingMist) return true else ui.debug("[FAIL]: "..text.heal.soothingMist.soothingMist) return false end
                end
            end
            -- Instant casts
            if cast.active.soothingMist() and friends.lowest.unit == lastSoothingMist.unit then
                -- Enveloping Mist
                if ui.checked(text.heal.soothingMist.envelopingMist) and cd.envelopingMist.ready() then
                    if friends.lowest.hp <= ui.value(text.heal.soothingMist.envelopingMist) and buff.envelopingMist.remains(friends.lowest.unit) < 2 then
                        if cast.envelopingMist(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.soothingMist.envelopingMist) return true else ui.debug("[FAIL]: "..text.heal.soothingMist.envelopingMist) return false end
                    end
                end
                -- Expel Harm
                if ui.checked(text.heal.soothingMist.expelHarm) and cd.expelHarm.ready() then
                    if friends.lowest.hp <= ui.value(text.heal.soothingMist.expelHarm) then
                        if cast.expelHarm(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.soothingMist.expelHarm) return true else ui.debug("[FAIL]: "..text.heal.soothingMist.expelHarm) return false end
                    end
                end
                -- Vivify
                if ui.checked(text.heal.soothingMist.vivify) and cd.vivify.ready() then
                    if friends.lowest.hp <= ui.value(text.heal.soothingMist.vivify) then
                        if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.soothingMist.vivify) return true else ui.debug("[FAIL]: "..text.heal.soothingMist.vivify) return false end
                    end
                end
            end
            if cast.active.soothingMist() then
                return false
            end
		elseif br.player.ui.mode.content == 2 then
		            -- Cancel Soothing Mist
            if cast.active.soothingMist() then --and lastSoothingMist.unit ~= friends.lowest.unit then
                if getRealHP(lastSoothingMist.unit) - friends.lowest.hp >= 20 or getRealHP(lastSoothingMist.unit) >= ui.value(text2.heal2.soothingMist2.soothingMist2)+5 then
                    if cast.cancel.soothingMist() then ui.debug("[SUCCESS]: Cancel - "..text2.heal2.soothingMist2.soothingMist2) return true else ui.debug("[FAIL]: Cancel - "..text2.heal2.soothingMist2.soothingMist2) return false end
                end
            end
            -- Soothing Mist
            if ui.checked(text2.heal2.soothingMist2.soothingMist2) and cd.soothingMist.ready() and not cast.active.soothingMist() and not player.isMoving then
                if friends.lowest.hp <= ui.value(text2.heal2.soothingMist2.soothingMist2) then
                    if cast.soothingMist(friends.lowest.unit) then
                        lastSoothingMist = {
                            hp = friends.lowest.hp,
                            unit = friends.lowest.unit
                        }
                        ui.debug("[SUCCESS]: "..text2.heal2.soothingMist2.soothingMist2) return true else ui.debug("[FAIL]: "..text2.heal2.soothingMist2.soothingMist2) return false end
                end
            end
            -- Instant casts
            if cast.active.soothingMist() and friends.lowest.unit == lastSoothingMist.unit then
                -- Enveloping Mist
                if ui.checked(text2.heal2.soothingMist2.envelopingMist2) and cd.envelopingMist.ready() then
                    if friends.lowest.hp <= ui.value(text2.heal2.soothingMist2.envelopingMist2) and buff.envelopingMist.remains(friends.lowest.unit) < 2 then
                        if cast.envelopingMist(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.soothingMist2.envelopingMist2) return true else ui.debug("[FAIL]: "..text2.heal2.soothingMist2.envelopingMist2) return false end
                    end
                end
                -- Expel Harm
                if ui.checked(text.heal.soothingMist.expelHarm) and cd.expelHarm.ready() then
                    if friends.lowest.hp <= ui.value(text2.heal2.soothingMist2.expelHarm2) then
                        if cast.expelHarm(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.soothingMist2.expelHarm2) return true else ui.debug("[FAIL]: "..text2.heal2.soothingMist2.expelHarm2) return false end
                    end
                end
                -- Vivify
                if ui.checked(text.heal.soothingMist.vivify) and cd.vivify.ready() then
                    if friends.lowest.hp <= ui.value(text2.heal2.soothingMist2.vivify2) then
                        if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.soothingMist2.vivify2) return true else ui.debug("[FAIL]: "..text2.heal2.soothingMist2.vivify2) return false end
                    end
                end
            end
            if cast.active.soothingMist() then
                return false
            end
		end
    end,

    vivifyAoE = function()
		if br.player.ui.mode.content == 1 then
            if cast.active.soothingMist() and friends.lowest.unit == lastSoothingMist.unit then
                -- Vivify AoE
                if ui.checked(text.heal.soothingMist.vivifyAoE) and cd.vivify.ready() then
                    local countUnitsWithRenewingMistUnderHealth = 0
                    if not buff.renewingMist.exists(friends.lowest.unit) and friends.lowest.hp <= ui.value(text.heal.soothingMist.vivifyAoE.."2") then
                        countUnitsWithRenewingMistUnderHealth = 1
                    end
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text.heal.soothingMist.vivifyAoE.."2") then
                            countUnitsWithRenewingMistUnderHealth = countUnitsWithRenewingMistUnderHealth + 1
                        end
                    end
                    if countUnitsWithRenewingMistUnderHealth >= ui.value(text.heal.soothingMist.vivifyAoE.."1") then
                        if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.soothingMist.vivifyAoE) return true else ui.debug("[FAIL]: "..text.heal.soothingMist.vivifyAoE) return false end
                    end
                end
            end
		elseif br.player.ui.mode.content == 2 then
         if cast.active.soothingMist() and friends.lowest.unit == lastSoothingMist.unit then
                -- Vivify AoE
                if ui.checked(text2.heal2.soothingMist2.vivifyAoE2) and cd.vivify.ready() then
                    local countUnitsWithRenewingMistUnderHealth = 0
                    if not buff.renewingMist.exists(friends.lowest.unit) and friends.lowest.hp <= ui.value(text2.heal2.soothingMist2.vivifyAoE2.."2") then
                        countUnitsWithRenewingMistUnderHealth = 1
                    end
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text2.heal2.soothingMist2.vivifyAoE2.."2") then
                            countUnitsWithRenewingMistUnderHealth = countUnitsWithRenewingMistUnderHealth + 1
                        end
                    end
                    if countUnitsWithRenewingMistUnderHealth >= ui.value(text2.heal2.soothingMist2.vivifyAoE2.."1") then
                        if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.soothingMist2.vivifyAoE2) return true else ui.debug("[FAIL]: "..text2.heal2.soothingMist2.vivifyAoE2) return false end
                    end
                end
            end
		end
	end,

    AoERotation = function()
		if br.player.ui.mode.content == 1 then
            -- Chi Burst
            debugMessage("Chi Burst Init")
            if ui.checked(text.heal.chiBurst) and cd.chiBurst.ready() and talent.chiBurst and not player.isMoving then
                local lowAlliesTargetsChiBurst = br.getUnitsInRect(7 , 40, false, ui.value(text.heal.chiBurst.."2"))
                if lowAlliesTargetsChiBurst >= ui.value(text.heal.chiBurst.."1") then
                    if cast.chiBurst(player.unit) then ui.debug("[SUCCESS]: "..text.heal.chiBurst) return true else ui.debug("[FAIL]: "..text.heal.chiBurst) return false end
                end
            end
            debugMessage("Chi Burst End")
            -- Essence Font
            debugMessage("Essence Font Init")
            if ui.checked(text.heal.essenceFont) and cd.essenceFont.ready() then
                if friends.lowAllies.essenceFont >= ui.value(text.heal.essenceFont.."1") then
                    if cast.essenceFont(player.unit) then ui.debug("[SUCCESS]: "..text.heal.essenceFont) return true else ui.debug("[FAIL]: "..text.heal.essenceFont) return false end
                end
            end
            debugMessage("Essence Font End")
            -- Enveloping Breath
            debugMessage("Enveloping Breath Init")
            if ui.checked(text.heal.envelopingBreath) and cd.envelopingMist.ready() and not player.isMoving then
                if totemInfo.yulonDuration > cast.time.envelopingMist() + br.getLatency() or totemInfo.chiJiDuration > cast.time.envelopingMist() + br.getLatency() then
                    local lowHealthAroundUnit = br.getUnitsToHealAround(friends.lowest.unit, 7.5, ui.value(text.heal.envelopingBreath.."2"), 6)
                    if #lowHealthAroundUnit >= ui.value(text.heal.envelopingBreath.."1") then
                        if cast.envelopingMist(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.envelopingBreath) return true else ui.debug("[FAIL]: "..text.heal.envelopingBreath) return false end
                    end
                end
            end
            debugMessage("Enveloping Breath End")
            -- Refreshing Jade Wind
            debugMessage("Refreshing Jade Wind Init")
            if ui.checked(text.heal.refreshingJadeWind) and cd.refreshingJadeWind.ready() and talent.refreshingJadeWind then
                if friends.lowAllies.refreshingJadeWind >= ui.value(text.heal.refreshingJadeWind.."1") then
                    if cast.refreshingJadeWind(player.unit) then ui.debug("[SUCCESS]: "..text.heal.refreshingJadeWind) return true else ui.debug("[FAIL]: "..text.heal.refreshingJadeWind) return false end
                end
            end
            debugMessage("Refreshing Jade Wind End")
		elseif br.player.ui.mode.content == 2 then
            -- Chi Burst
            debugMessage("Chi Burst Init")
            if ui.checked(text2.heal2.chiBurst2) and cd.chiBurst.ready() and talent.chiBurst and not player.isMoving then
                local lowAlliesTargetsChiBurst = br.getUnitsInRect(7 , 40, false, ui.value(text2.heal2.chiBurst2.."2"))
                if lowAlliesTargetsChiBurst >= ui.value(text2.heal2.chiBurst2.."1") then
                    if cast.chiBurst(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.chiBurst2) return true else ui.debug("[FAIL]: "..text2.heal2.chiBurst2) return false end
                end
            end
            debugMessage("Chi Burst End")
            -- Essence Font
            debugMessage("Essence Font Init")
            if ui.checked(text2.heal2.essenceFont2) and cd.essenceFont.ready() then
                if friends.lowAllies.essenceFont >= ui.value(text2.heal2.essenceFont2.."1") then
                    if cast.essenceFont(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.essenceFont2) return true else ui.debug("[FAIL]: "..text2.heal2.essenceFont2) return false end
                end
            end
            debugMessage("Essence Font End")
            -- Enveloping Breath
            debugMessage("Enveloping Breath Init")
            if ui.checked(text2.heal2.envelopingBreath2) and cd.envelopingMist.ready() and not player.isMoving then
                if totemInfo.yulonDuration > cast.time.envelopingMist() + br.getLatency() or totemInfo.chiJiDuration > cast.time.envelopingMist() + br.getLatency() then
                    local lowHealthAroundUnit = br.getUnitsToHealAround(friends.lowest.unit, 7.5, ui.value(text2.heal2.envelopingBreath2.."2"), 6)
                    if #lowHealthAroundUnit >= ui.value(text2.heal2.envelopingBreath2.."1") then
                        if cast.envelopingMist(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.envelopingBreath2) return true else ui.debug("[FAIL]: "..text2.heal2.envelopingBreath2) return false end
                    end
                end
            end
            debugMessage("Enveloping Breath End")
            -- Refreshing Jade Wind
            debugMessage("Refreshing Jade Wind Init")
            if ui.checked(text2.heal2.refreshingJadeWind2) and cd.refreshingJadeWind.ready() and talent.refreshingJadeWind then
                if friends.lowAllies.refreshingJadeWind >= ui.value(text2.heal2.refreshingJadeWind2.."1") then
                    if cast.refreshingJadeWind(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.refreshingJadeWind2) return true else ui.debug("[FAIL]: "..text2.heal2.refreshingJadeWind2) return false end
                end
            end
            debugMessage("Refreshing Jade Wind End")
		end
    end,

    singleTargetRotation = function()
		if br.player.ui.mode.content == 2 then
            -- Chi Wave
            debugMessage("Chi Wave Init")
            if ui.checked(text.heal.chiWave) and cd.chiWave.ready() and talent.chiWave and dynamic.range40 ~= nil then
                if cast.chiWave(player.unit,"aoe") then ui.debug("[SUCCESS]: "..text.heal.chiWave) return true else ui.debug("[FAIL]: "..text.heal.chiWave) return false end
            end
            debugMessage("Chi Wave End")
            -- Enveloping Mist
            debugMessage("Enveloping Mist Init")
            if ui.checked(text.heal.envelopingMist) and cd.envelopingMist.ready() and not player.isMoving then
                if friends.lowest.hp <= ui.value(text.heal.envelopingMist) then
                    if cast.envelopingMist(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.envelopingMist) return true else ui.debug("[FAIL]: "..text.heal.envelopingMist) return false end
                end
            end
            debugMessage("Enveloping Mist End")
            -- Vivify
            debugMessage("Vivify Init")
            if ui.checked(text.heal.vivify) and cd.vivify.ready() and (buff.vivaciousVivification.exists(player.unit) or not player.isMoving) then
                if friends.lowest.hp <= ui.value(text.heal.vivify) then
                    if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.vivify) return true else ui.debug("[FAIL]: "..text.heal.vivify) return false end
                end
            end
            debugMessage("Vivify End")
		elseif br.player.ui.mode.content == 1 then
            -- Chi Wave
            debugMessage("Chi Wave Init")
            if ui.checked(text2.heal2.chiWave2) and cd.chiWave.ready() and talent.chiWave and dynamic.range40 ~= nil then
                if cast.chiWave(player.unit,"aoe") then ui.debug("[SUCCESS]: "..text2.heal2.chiWave2) return true else ui.debug("[FAIL]: "..text2.heal2.chiWave2) return false end
            end
            debugMessage("Chi Wave End")
            -- Enveloping Mist
            debugMessage("Enveloping Mist Init")
            if ui.checked(text2.heal2.envelopingMist2) and cd.envelopingMist.ready() and not player.isMoving then
                if friends.lowest.hp <= ui.value(text2.heal2.envelopingMist2) then
                    if cast.envelopingMist(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.envelopingMist2) return true else ui.debug("[FAIL]: "..text2.heal2.envelopingMist2) return false end
                end
            end
            debugMessage("Enveloping Mist End")
            -- Vivify
            debugMessage("Vivify Init")
            if ui.checked(text2.heal2.vivify2) and cd.vivify.ready() and (buff.vivaciousVivification.exists(player.unit) or not player.isMoving) then
                if friends.lowest.hp <= ui.value(text2.heal2.vivify2) then
                    if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.vivify2) return true else ui.debug("[FAIL]: "..text2.heal2.vivify2) return false end
                end
            end
            debugMessage("Vivify End")
		end
    end,

    outOfCombatRotation = function()
		if br.player.ui.mode.content == 1 then
            if cast.active.essenceFont() then
                return nil
            end
            -- Renewing Mist
            if ui.checked(text.heal.outOfCombat.renewingMist) and charges.renewingMist.exists() and cd.renewingMist.ready() then
                local renewingMistUnit

                for i = 1, #tanks do
                    local tempUnit = tanks[i]
                    if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text.heal.outOfCombat.renewingMist) and renewingMistUnit == nil then
                        renewingMistUnit = tempUnit
                    end
                end

                if renewingMistUnit == nil then
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text.heal.outOfCombat.renewingMist) and renewingMistUnit == nil then
                            renewingMistUnit = tempUnit
                        end
                    end
                end

                if renewingMistUnit == nil then
                    if not buff.renewingMist.exists(player.unit) and player.hp <= ui.value(text.heal.outOfCombat.renewingMist) then
                        renewingMistUnit = player
                    end
                end

                if renewingMistUnit ~= nil then
                    if cast.renewingMist(renewingMistUnit.unit) then ui.debug("[SUCCESS]: "..text.heal.outOfCombat.renewingMist) return true else ui.debug("[FAIL]: "..text.heal.outOfCombat.renewingMist) return false end
                end
            end
            -- Essence Font
            if ui.checked(text.heal.outOfCombat.essenceFont) and cd.essenceFont.ready() then
                if friends.lowAllies.essenceFontOoc >= ui.value(text.heal.outOfCombat.essenceFont.."1") then
                    if cast.essenceFont(player.unit) then ui.debug("[SUCCESS]: "..text.heal.outOfCombat.essenceFont) return true else ui.debug("[FAIL]: "..text.heal.outOfCombat.essenceFont) return false end
                end
            end
            -- Vivify
            if ui.checked(text.heal.outOfCombat.vivify) and cd.vivify.ready() and not player.isMoving then
                if friends.lowest.hp <= ui.value(text.heal.outOfCombat.vivify) then
                    if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text.heal.outOfCombat.vivify) return true else ui.debug("[FAIL]: "..text.heal.outOfCombat.vivify) return false end
                end
            end
		elseif br.player.ui.mode.content == 2 then
            if cast.active.essenceFont() then
                return nil
            end
            -- Renewing Mist
            if ui.checked(text2.heal2.outOfCombat2.renewingMist2) and charges.renewingMist.exists() and cd.renewingMist.ready() then
                local renewingMistUnit

                for i = 1, #tanks do
                    local tempUnit = tanks[i]
                    if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text2.heal2.outOfCombat2.renewingMist2) and renewingMistUnit == nil then
                        renewingMistUnit = tempUnit
                    end
                end

                if renewingMistUnit == nil then
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if not buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text2.heal2.outOfCombat2.renewingMist2) and renewingMistUnit == nil then
                            renewingMistUnit = tempUnit
                        end
                    end
                end

                if renewingMistUnit == nil then
                    if not buff.renewingMist.exists(player.unit) and player.hp <= ui.value(text2.heal2.outOfCombat2.renewingMist2) then
                        renewingMistUnit = player
                    end
                end

                if renewingMistUnit ~= nil then
                    if cast.renewingMist(renewingMistUnit.unit) then ui.debug("[SUCCESS]: "..text2.heal2.outOfCombat2.renewingMist2) return true else ui.debug("[FAIL]: "..text2.heal2.outOfCombat2.renewingMist2) return false end
                end
            end
            -- Essence Font
            if ui.checked(text2.heal2.outOfCombat2.essenceFont2) and cd.essenceFont.ready() then
                if friends.lowAllies.essenceFontOoc >= ui.value(text2.heal2.outOfCombat2.essenceFont2.."1") then
                    if cast.essenceFont(player.unit) then ui.debug("[SUCCESS]: "..text2.heal2.outOfCombat2.essenceFont2) return true else ui.debug("[FAIL]: "..text2.heal2.outOfCombat2.essenceFont2) return false end
                end
            end
            -- Vivify
            if ui.checked(text2.heal2.outOfCombat2.vivify2) and cd.vivify.ready() and not player.isMoving then
                if friends.lowest.hp <= ui.value(text2.heal2.outOfCombat2.vivify2) then
                    if cast.vivify(friends.lowest.unit) then ui.debug("[SUCCESS]: "..text2.heal2.outOfCombat2.vivify2) return true else ui.debug("[FAIL]: "..text2.heal2.outOfCombat2.vivify2) return false end
                end
            end
		end
    end,

    thunderFocusTeaRotation = function()
		if br.player.ui.mode.content == 1 then
            if cd.thunderFocusTea.ready() then
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 2 and not player.isMoving then -- EM
                    -- Thunder Focus Tea + Enveloping Mist
                    if ui.checked(text.heal.thunderFocusTea.envelopingMist) and friends.lowest.hp <= ui.value(text.heal.thunderFocusTea.envelopingMist) and cd.envelopingMist.ready() then
                        if cast.thunderFocusTea(player.unit) and cast.envelopingMist(friends.lowest.unit) then
                            ui.debug("[SUCCESS]: "..text.heal.thunderFocusTea.envelopingMist)
                            return true
                        else ui.debug("[FAIL]: "..text.heal.thunderFocusTea.envelopingMist) return false end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 3 and not player.isMoving then -- VVF
                    -- Thunder Focus Tea + Vivify
                    if ui.checked(text.heal.thunderFocusTea.vivify) and friends.lowest.hp <= ui.value(text.heal.thunderFocusTea.vivify.."2") and cd.vivify.ready() then
                        if player.mana <= ui.value(text.heal.thunderFocusTea.vivify.."1") then
                            if cast.thunderFocusTea(player.unit) and cast.vivify(friends.lowest.unit) then
                                ui.debug("[SUCCESS]: "..text.heal.thunderFocusTea.vivify)
                                return true
                            else ui.debug("[FAIL]: "..text.heal.thunderFocusTea.vivify) return false end
                        end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 4 then -- RM
                    -- Thunder Focus Tea + Renewing Mist
                    if ui.checked(text.heal.thunderFocusTea.renewingMist) and friends.lowest.hp <= ui.value(text.heal.thunderFocusTea.renewingMist) and not buff.renewingMist.exists(friends.lowest.unit) and charges.renewingMist.exists() and cd.renewingMist.ready() then
                        if cast.thunderFocusTea(player.unit) and cast.renewingMist(friends.lowest.unit) then
                            ui.debug("[SUCCESS]: "..text.heal.thunderFocusTea.renewingMist)
                            return true
                        else ui.debug("[FAIL]: "..text.heal.thunderFocusTea.renewingMist) return false end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 5 then -- RSK
                    -- Thunder Focus Tea + Rising Sun Kick
                    if ui.checked(text.heal.thunderFocusTea.risingSunKick) and cd.risingSunKick.ready() and dynamic.range5 ~= nil and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.thunderFocusTea(player.unit) and cast.risingSunKick(friends.lowest.unit) then
                            ui.debug("[SUCCESS]: "..text.heal.thunderFocusTea.risingSunKick)
                            return true
                        else ui.debug("[FAIL]: "..text.heal.thunderFocusTea.risingSunKick) return false end
                    end
                end
            end
		elseif br.player.ui.mode.content == 2 then
            if cd.thunderFocusTea.ready() then
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 2 and not player.isMoving then -- EM
                    -- Thunder Focus Tea + Enveloping Mist
                    if ui.checked(text2.heal2.thunderFocusTea2.envelopingMist2) and friends.lowest.hp <= ui.value(text2.heal2.thunderFocusTea2.envelopingMist2) and cd.envelopingMist.ready() then
                        if cast.thunderFocusTea(player.unit) and cast.envelopingMist(friends.lowest.unit) then
                            ui.debug("[SUCCESS]: "..text2.heal2.thunderFocusTea2.envelopingMist2)
                            return true
                        else ui.debug("[FAIL]: "..text2.heal2.thunderFocusTea2.envelopingMist2) return false end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 3 and not player.isMoving then -- VVF
                    -- Thunder Focus Tea + Vivify
                    if ui.checked(text2.heal2.thunderFocusTea2.vivify2) and friends.lowest.hp <= ui.value(text2.heal2.thunderFocusTea2.vivify2.."2") and cd.vivify.ready() then
                        if player.mana <= ui.value(text2.heal2.thunderFocusTea2.vivify2.."1") then
                            if cast.thunderFocusTea(player.unit) and cast.vivify(friends.lowest.unit) then
                                ui.debug("[SUCCESS]: "..text2.heal2.thunderFocusTea2.vivify2)
                                return true
                            else ui.debug("[FAIL]: "..text2.heal2.thunderFocusTea2.vivify2) return false end
                        end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 4 then -- RM
                    -- Thunder Focus Tea + Renewing Mist
                    if ui.checked(text2.heal2.thunderFocusTea2.renewingMist2) and friends.lowest.hp <= ui.value(text2.heal2.thunderFocusTea2.renewingMist2) and not buff.renewingMist.exists(friends.lowest.unit) and charges.renewingMist.exists() and cd.renewingMist.ready() then
                        if cast.thunderFocusTea(player.unit) and cast.renewingMist(friends.lowest.unit) then
                            ui.debug("[SUCCESS]: "..text2.heal2.thunderFocusTea2.renewingMist2)
                            return true
                        else ui.debug("[FAIL]: "..text2.heal2.thunderFocusTea2.renewingMist2) return false end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 5 then -- RSK
                    -- Thunder Focus Tea + Rising Sun Kick
                    if ui.checked(text2.heal2.thunderFocusTea2.risingSunKick2) and cd.risingSunKick.ready() and dynamic.range5 ~= nil and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.thunderFocusTea(player.unit) and cast.risingSunKick(friends.lowest.unit) then
                            ui.debug("[SUCCESS]: "..text2.heal2.thunderFocusTea2.risingSunKick2)
                            return true
                        else ui.debug("[FAIL]: "..text2.heal2.thunderFocusTea2.risingSunKick2) return false end
                    end
                end
            end
		end
	end
	},

    utility = function()
	if br.player.ui.mode.content == 1 then
        -- Tiger's Lust
        debugMessage("Tiger's Lust Init")
        if ui.checked(text.utility.tigersLust) and talent.tigersLust and cd.tigersLust.ready()  then
            for i = 1, #friends.range40 do
                local tempUnit = friends.range40[i]
                if cast.noControl.tigersLust(tempUnit.unit) then
                    if cast.tigersLust(tempUnit.unit) then ui.debug("[SUCCESS]: "..text.utility.tigersLust) return true else ui.debug("[FAIL]: "..text.utility.tigersLust) return false end
                end
            end
        end
        debugMessage("Tiger's Lust End")
        -- Mana Tea
        debugMessage("Mana Tea Init")
        if ui.checked(text.utility.manaTea) and talent.manaTea and cd.manaTea.ready() then
            if player.mana <= ui.value(text.utility.manaTea) then
                if cast.manaTea(player.unit) then ui.debug("[SUCCESS]: "..text.utility.manaTea) return true else ui.debug("[FAIL]: "..text.utility.manaTea) return false end
            end
        end
        -- Mana Tea Yulon
        if ui.checked(text.utility.manaTeaWithYulon) and talent.manaTea and cd.manaTea.ready() and totemInfo.yulonDuration >= 5 then
            if cast.manaTea(player.unit) then ui.debug("[SUCCESS]: "..text.utility.manaTeaWithYulon) return true else ui.debug("[FAIL]: "..text.utility.manaTeaWithYulon) return false end
        end
        debugMessage("Mana Tea End")
        -- Summon Jade Serpent Statue
        debugMessage("Summon Jade Serpent Statue Init")
        if ui.checked(text.utility.summonJadeSerpentStatue) and talent.summonJadeSerpentStatue and cd.summonJadeSerpentStatue.ready() then
            local distanceToStatue = br.getDistanceToObject(player.unit, summonJadeSerpentStatuePosition.x, summonJadeSerpentStatuePosition.y, summonJadeSerpentStatuePosition.z)
            if distanceToStatue > 40 or totemInfo.jadeSerpentStatueDuration <= 5 then
                local aroundUnit
                if ui.value(text.utility.summonJadeSerpentStatue) == 1 and #br.friend > 1 then
                    aroundUnit = tanks[1].unit
                else
                    aroundUnit = player.unit
                end
                local px, py, pz = br.GetObjectPosition(aroundUnit)
                px = px + math.random(-2, 2)
                py = py + math.random(-2, 2)
                if br.castGroundAtLocation({x = px, y = py, z = pz}, spell.summonJadeSerpentStatue) then
                    summonJadeSerpentStatuePosition = {
                        x = px,
                        y = py,
                        z = pz
                    }
                    br.addonDebug(colors.yellow .. "[?]:5P | Jade Serpent Statue - distance to statue: " .. distanceToStatue .. ", old totem duration: " .. totemInfo.jadeSerpentStatueDuration)
                    return true
                end
            end
        end
        debugMessage("Summon Jade Serpent Statue End")
        -- Arcane Torrent
        debugMessage("Arcane Torrent Init")
        if ui.checked(text.utility.arcaneTorrent) and player.race == "BloodElf" and br.getSpellCD(129597) == 0 then
            if player.mana <= ui.value(text.utility.arcaneTorrent) then
                br._G.CastSpellByName(GetSpellInfo(129597))
                ui.debug("[?]: "..text.utility.arcaneTorrent)
                return true
            end
        end
        debugMessage("Arcane Torrent End")
        -- Detox
        debugMessage("Detox Init")
        if ui.mode.detox == 1 and cd.detox.ready() then
            for i = 1, #br.friend do
                if br.canDispel(br.friend[i].unit, spell.detox) and (br.getLineOfSight(br.friend[i].unit) and br.getDistance(br.friend[i].unit) <= 40 or br.friend[i].unit == "player") then
                    if cast.detox(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
        debugMessage("Detox End")
	elseif br.player.ui.mode.content == 2 then
        -- Tiger's Lust
        debugMessage("Tiger's Lust Init")
        if ui.checked(text2.utility2.tigersLust2) and talent.tigersLust and cd.tigersLust.ready()  then
            for i = 1, #friends.range40 do
                local tempUnit = friends.range40[i]
                if cast.noControl.tigersLust(tempUnit.unit) then
                    if cast.tigersLust(tempUnit.unit) then ui.debug("[SUCCESS]: "..text2.utility2.tigersLust2) return true else ui.debug("[FAIL]: "..text2.utility2.tigersLust2) return false end
                end
            end
        end
        debugMessage("Tiger's Lust End")
        -- Mana Tea
        debugMessage("Mana Tea Init")
        if ui.checked(text2.utility2.manaTea2) and talent.manaTea and cd.manaTea.ready() then
            if player.mana <= ui.value(text2.utility2.manaTea2) then
                if cast.manaTea(player.unit) then ui.debug("[SUCCESS]: "..text2.utility2.manaTea2) return true else ui.debug("[FAIL]: "..text2.utility2.manaTea2) return false end
            end
        end
        -- Mana Tea Yulon
        if ui.checked(text2.utility2.manaTeaWithYulon2) and talent.manaTea and cd.manaTea.ready() and totemInfo.yulonDuration >= 5 then
            if cast.manaTea(player.unit) then ui.debug("[SUCCESS]: "..text2.utility2.manaTeaWithYulon2) return true else ui.debug("[FAIL]: "..text2.utility2.manaTeaWithYulon2) return false end
        end
        debugMessage("Mana Tea End")
        -- Summon Jade Serpent Statue
        debugMessage("Summon Jade Serpent Statue Init")
        if ui.checked(text2.utility2.summonJadeSerpentStatue2) and talent.summonJadeSerpentStatue and cd.summonJadeSerpentStatue.ready() then
            local distanceToStatue = br.getDistanceToObject(player.unit, summonJadeSerpentStatuePosition.x, summonJadeSerpentStatuePosition.y, summonJadeSerpentStatuePosition.z)
            if distanceToStatue > 40 or totemInfo.jadeSerpentStatueDuration <= 5 then
                local aroundUnit
                if ui.value(text2.utility2.summonJadeSerpentStatue2) == 1 and #br.friend > 1 then
                    aroundUnit = tanks[1].unit
                else
                    aroundUnit = player.unit
                end
                local px, py, pz = br.GetObjectPosition(aroundUnit)
                px = px + math.random(-2, 2)
                py = py + math.random(-2, 2)
                if br.castGroundAtLocation({x = px, y = py, z = pz}, spell.summonJadeSerpentStatue) then
                    summonJadeSerpentStatuePosition = {
                        x = px,
                        y = py,
                        z = pz
                    }
                    br.addonDebug(colors.yellow .. "[?]:20P | Jade Serpent Statue - distance to statue: " .. distanceToStatue .. ", old totem duration: " .. totemInfo.jadeSerpentStatueDuration)
                    return true
                end
            end
        end
        debugMessage("Summon Jade Serpent Statue End")
        -- Arcane Torrent
        debugMessage("Arcane Torrent Init")
        if ui.checked(text2.utility2.arcaneTorren2t) and player.race == "BloodElf" and br.getSpellCD(129597) == 0 then
            if player.mana <= ui.value(text2.utility2.arcaneTorrent2) then
                br._G.CastSpellByName(GetSpellInfo(129597))
                ui.debug("[?]: "..text2.utility2.arcaneTorrent2)
                return true
            end
        end
        debugMessage("Arcane Torrent End")
        -- Detox
        debugMessage("Detox Init")
        if ui.mode.detox == 1 and cd.detox.ready() then
            for i = 1, #br.friend do
                if br.canDispel(br.friend[i].unit, spell.detox) and (br.getLineOfSight(br.friend[i].unit) and br.getDistance(br.friend[i].unit) <= 40 or br.friend[i].unit == "player") then
                    if cast.detox(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
        debugMessage("Detox End")
	end
    end,

	selfDefense = function()
	if br.player.ui.mode.content == 1 then
        -- Healing Elixir / Diffuse Magic / Dampen Harm
        if ui.checked(text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) and player.hp <= ui.value(text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) then
            if talent.healingElixir and charges.healingElixir.exists() then
                if cast.healingElixir(player.unit) then ui.debug("[SUCCESS]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return true else ui.debug("[FAIL]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return false end
            elseif talent.diffuseMagic and cd.diffuseMagic.ready() then
                if cast.diffuseMagic(player.unit) then ui.debug("[SUCCESS]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return true else ui.debug("[FAIL]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return false end
            elseif talent.dampenHarm and cd.dampenHarm.ready() then
                if cast.dampenHarm(player.unit) then ui.debug("[SUCCESS]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return true else ui.debug("[FAIL]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return false end
            end
        end
        -- Fortifying Brew
        if talent.fortifyingBrew and ui.checked(text.selfDefense.fortifyingBrew) and player.hp <= ui.value(text.selfDefense.fortifyingBrew) and cd.fortifyingBrew.ready() then
            if cast.fortifyingBrew(player.unit) then ui.debug("[SUCCESS]: "..text.selfDefense.fortifyingBrew) return true else ui.debug("[FAIL]: "..text.selfDefense.fortifyingBrew) return false end
        end
        -- Leg Sweep
        if ui.checked(text.selfDefense.legSweep) and cd.legSweep.ready() then
            -- AoE
            if #enemies.range6 >= ui.value(text.selfDefense.legSweep.."1") then
                if cast.legSweep(player.unit) then ui.debug("[SUCCESS]: "..text.selfDefense.legSweep) return true else ui.debug("[FAIL]: "..text.selfDefense.legSweep) return false end
            end
            -- Health
            if #enemies.range6 >= 1 and player.hp <= ui.value(text.selfDefense.legSweep.."2") then
                if cast.legSweep(player.unit) then ui.debug("[SUCCESS]: "..text.selfDefense.legSweep) return true else ui.debug("[FAIL]: "..text.selfDefense.legSweep) return false end
            end

        end
        -- Paralysis
        if ui.useInterrupt() then
            for i = 1, #enemies.range40 do
                local thisUnit = enemies.range40[i]
                local distance = br.player.unit.distance(thisUnit)
                if br.player.unit.interruptable(thisUnit) then
					-- Spear Hand Strike
                    if cd.spearHandStrike.ready() and ui.checked(text.utility.spearHandStrike) then
                        if cast.spearHandStrike(thisUnit) then ui.debug("[SUCCESS - INTERRUPT]:5P | Spear Hand Strike") return true else ui.debug("[FAIL - INTERRUPT]:5P | Spear Hand Strike") return false end
                    end
                    -- Paralysis
                    if cd.paralysis.ready() and distance < 20 then
                        if cast.paralysis(thisUnit) then ui.debug("[SUCCESS - INTERRUPT]:5P | Paralysis") return true else ui.debug("[FAIL - INTERRUPT]:5P | Paralysis") return false end
                    end
                    -- Ring of Peace
                    if talent.ringOfPeace and cd.ringOfPeace.ready() and ui.checked(text.utility.ringOfPeace) then
                        if cast.ringOfPeace(thisUnit, "ground") then ui.debug("[SUCCESS - INTERRUPT]:5P | Ring Of Peace") return true else ui.debug("[FAIL - INTERRUPT]:5P | Ring Of Peace") return false end
                    end
                    -- Leg Sweep
                    if cd.legSweep.ready() and ui.checked(text.selfDefense.legSweep) then
                        if cast.legSweep(thisUnit, "ground") then ui.debug("[SUCCESS - INTERRUPT]:5P | Leg Sweep") return true else ui.debug("[FAIL - INTERRUPT]:5P | Leg Sweep") return false end
                    end
                end
            end
        end
        -- Expel Harm
        if ui.checked(text.selfDefense.expelHarm) and cd.expelHarm.ready() then
            if player.hp <= ui.value(text.selfDefense.expelHarm) then
                if cast.expelHarm(player.unit) then ui.debug("[SUCCESS]: "..text.selfDefense.expelHarm) return true else ui.debug("[FAIL]: "..text.selfDefense.expelHarm) return false end
            end
        end
	elseif br.player.ui.mode.content == 2 then
        -- Healing Elixir / Diffuse Magic / Dampen Harm
        if ui.checked(text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) and player.hp <= ui.value(text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) then
            if talent.healingElixir and charges.healingElixir.exists() then
                if cast.healingElixir(player.unit) then ui.debug("[SUCCESS]: "..text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) return true else ui.debug("[FAIL]: "..text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) return false end
            elseif talent.diffuseMagic and cd.diffuseMagic.ready() then
                if cast.diffuseMagic(player.unit) then ui.debug("[SUCCESS]: "..text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) return true else ui.debug("[FAIL]: "..text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) return false end
            elseif talent.dampenHarm and cd.dampenHarm.ready() then
                if cast.dampenHarm(player.unit) then ui.debug("[SUCCESS]: "..text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) return true else ui.debug("[FAIL]: "..text2.selfDefense2.healingElixirOrDiffuseMagicOrDampenHarm2) return false end
            end
        end
        -- Fortifying Brew
        if ui.checked(text2.selfDefense2.fortifyingBrew2) and player.hp <= ui.value(text2.selfDefense2.fortifyingBrew2) and cd.fortifyingBrew.ready() then
            if cast.fortifyingBrew(player.unit) then ui.debug("[SUCCESS]: "..text2.selfDefense2.fortifyingBrew2) return true else ui.debug("[FAIL]: "..text2.selfDefense2.fortifyingBrew2) return false end
        end
        -- Leg Sweep
        if ui.checked(text2.selfDefense2.legSweep2) and cd.legSweep.ready() then
            -- AoE
            if #enemies.range6 >= ui.value(text2.selfDefense2.legSweep2.."1") then
                if cast.legSweep(player.unit) then ui.debug("[SUCCESS]: "..text2.selfDefense2.legSweep2) return true else ui.debug("[FAIL]: "..text2.selfDefense2.legSweep2) return false end
            end
            -- Health
            if #enemies.range6 >= 1 and player.hp <= ui.value(text2.selfDefense2.legSweep2.."2") then
                if cast.legSweep(player.unit) then ui.debug("[SUCCESS]: "..text2.selfDefense2.legSweep2) return true else ui.debug("[FAIL]: "..text2.selfDefense2.legSweep2) return false end
            end

        end
        -- Paralysis
        if ui.useInterrupt() then
            for i = 1, #enemies.range40 do
                local thisUnit = enemies.range40[i]
                local distance = br.player.unit.distance(thisUnit)
                if br.player.unit.interruptable(thisUnit) then
					-- Spear Hand Strike
                    if cd.spearHandStrike.ready() and ui.checked(text2.utility2.spearHandStrike2) then
                        if cast.spearHandStrike(thisUnit) then ui.debug("[SUCCESS - INTERRUPT]:20P | Spear Hand Strike") return true else ui.debug("[FAIL - INTERRUPT]:20P | Spear Hand Strike") return false end
                    end
                    -- Paralysis
                    if cd.paralysis.ready() and distance < 20 then
                        if cast.paralysis(thisUnit) then ui.debug("[SUCCESS - INTERRUPT]:20P | Paralysis") return true else ui.debug("[FAIL - INTERRUPT]:20P | Paralysis") return false end
                    end
                    -- Ring of Peace
                    if talent.ringOfPeace and cd.ringOfPeace.ready() and ui.checked(text2.utility2.ringOfPeace2) then
                        if cast.ringOfPeace(thisUnit, "ground") then ui.debug("[SUCCESS - INTERRUPT]:20P | Ring Of Peace") return true else ui.debug("[FAIL - INTERRUPT]:20P | Ring Of Peace") return false end
                    end
                    -- Leg Sweep
                    if cd.legSweep.ready() and ui.checked(text2.selfDefense2.legSweep2) then
                        if cast.legSweep(thisUnit, "ground") then ui.debug("[SUCCESS - INTERRUPT]:20P | Leg Sweep") return true else ui.debug("[FAIL - INTERRUPT]:20P | Leg Sweep") return false end
                    end
                end
            end
        end
        -- Expel Harm
        if ui.checked(text2.selfDefense2.expelHarm2) and cd.expelHarm.ready() then
            if player.hp <= ui.value(text.selfDefense.expelHarm) then
                if cast.expelHarm(player.unit) then ui.debug("[SUCCESS]: "..text2.selfDefense2.expelHarm2) return true else ui.debug("[FAIL]: "..text2.selfDefense2.expelHarm2) return false end
            end
        end
	end
end,

    damage = {
        CDs = function()
            -- Touch of Death
			if br.player.ui.mode.content == 1 then
            if ui.checked(text.damage.touchOfDeath) and cd.touchOfDeath.ready() then
                local touchOfDeathMode = ui.value(text.damage.touchOfDeath)
                for i = 1, #enemies.range5 do
                    local thisUnit = enemies.range5[i]
                    if br._G.ObjectIsFacing(player.unit, thisUnit) then
                        if touchOfDeathMode == 1 or (touchOfDeathMode == 2 and br.isBoss(thisUnit)) then
                            if unit.health(player.unit) > unit.health(thisUnit) or (br.isBoss(thisUnit) and unit.hp(thisUnit) <= 15) then
                                if cast.touchOfDeath(thisUnit) then ui.debug("[SUCCESS]: "..text.damage.touchOfDeath) return true else ui.debug("[FAIL]: "..text.damage.touchOfDeath) return false end
                            end
                        end
                    end
                end
            end
			elseif br.player.ui.mode.content == 2 then
			if ui.checked(text2.damage2.touchOfDeath2) and cd.touchOfDeath.ready() then
                local touchOfDeathMode = ui.value(text.damage.touchOfDeath)
                for i = 1, #enemies.range5 do
                    local thisUnit = enemies.range5[i]
                    if br._G.ObjectIsFacing(player.unit, thisUnit) then
                        if touchOfDeathMode == 1 or (touchOfDeathMode == 2 and br.isBoss(thisUnit)) then
                            if unit.health(player.unit) > unit.health(thisUnit) or (br.isBoss(thisUnit) and unit.hp(thisUnit) <= 15) then
                                if cast.touchOfDeath(thisUnit) then ui.debug("[SUCCESS]: "..text2.damage2.touchOfDeath2) return true else ui.debug("[FAIL]: "..text2.damage2.touchOfDeath2) return false end
                            end
                        end
                    end
                end
            end
			end
        end,

        AoERotation = function()
		if br.player.ui.mode.content == 1 then
            if #enemies.range8 >= 3 then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[SUCCESS]:5P | Rising Sun Kick AoE") return true else ui.debug("[FAIL]:5P | Rising Sun Kick AoE") return false end
                end
                -- Spinning Crane Kick
                if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                    if cast.spinningCraneKick(player.unit) then ui.debug("[SUCCESS]:5P | Spinning Crane Kick AoE") return true else ui.debug("[FAIL]:5P | Spinning Crane Kick AoE") return false end
                end
            end
		elseif br.player.ui.mode.content == 2 then
		        if #enemies.range8 >= 3 then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[SUCCESS]:20P | Rising Sun Kick AoE") return true else ui.debug("[FAIL]:20P | Rising Sun Kick AoE") return false end
                end
                -- Spinning Crane Kick
                if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                    if cast.spinningCraneKick(player.unit) then ui.debug("[SUCCESS]:20P | Spinning Crane Kick AoE") return true else ui.debug("[FAIL]:20P | Spinning Crane Kick AoE") return false end
                end
            end
		end
        end,

        singleTargetRotation = function()
		if br.player.ui.mode.content == 1 then
            if dynamic.range5 ~= nil and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[SUCCESS]:5P | Rising Sun Kick ST") return true else ui.debug("[FAIL]:5P | Rising Sun Kick ST") return false end
                end
                -- Blackout Kick
                if cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 then
                    if cast.blackoutKick(dynamic.range5) then ui.debug("[SUCCESS]:5P | Blackout Kick ST") return true else ui.debug("[FAIL]:5P | Blackout Kick ST") return false end
                end
                -- Tiger Palm
                if cd.tigerPalm.ready() then
                    if cast.tigerPalm(dynamic.range5) then ui.debug("[SUCCESS]:5P | Tiger Palm ST") return true else ui.debug("[FAIL]:5P | Tiger Palm ST") return false end
                end
            end
		elseif br.player.ui.mode.content == 2 then
		        if dynamic.range5 ~= nil and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[SUCCESS]:20P | Rising Sun Kick ST") return true else ui.debug("[FAIL]:20P | Rising Sun Kick ST") return false end
                end
                -- Blackout Kick
                if cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 then
                    if cast.blackoutKick(dynamic.range5) then ui.debug("[SUCCESS]:20P | Blackout Kick ST") return true else ui.debug("[FAIL]:20P | Blackout Kick ST") return false end
                end
                -- Tiger Palm
                if cd.tigerPalm.ready() then
                    if cast.tigerPalm(dynamic.range5) then ui.debug("[SUCCESS]:20P | Tiger Palm ST") return true else ui.debug("[FAIL]:20P | Tiger Palm ST") return false end
                end
            end
		end
        end,

        chiJiRotation = function()
            -- Enveloping Mist Chi-Ji
		if br.player.ui.mode.content == 1 then
            if buff.invokeChiJiTheRedCrane.stack() == 3 or (totemInfo.chiJiDuration == 0 and buff.invokeChiJiTheRedCrane.stack() > 0 and not player.isMoving) then
                debugMessage("Enveloping Mist - Chi-Ji Init")
                local theUnit
                if cd.envelopingMist.ready() then
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if buff.envelopingMist.remains(friends.lowest.unit) < 2 and theUnit == nil then
                            theUnit = tempUnit
                        end
                    end
                    if theUnit == nil then
                        theUnit = player
                    end
                    if cast.envelopingMist(theUnit.unit) then ui.debug("[SUCCESS]: "..text.heal.envelopingMist) return true else ui.debug("[FAIL]: "..text.heal.envelopingMist) return false end
                end
                debugMessage("Enveloping Mist - Chi-Ji End")
            end
		elseif br.player.ui.mode.content == 2 then
            if buff.invokeChiJiTheRedCrane.stack() == 3 or (totemInfo.chiJiDuration == 0 and buff.invokeChiJiTheRedCrane.stack() > 0 and not player.isMoving) then
                debugMessage("Enveloping Mist - Chi-Ji Init")
                local theUnit
                if cd.envelopingMist.ready() then
                    for i = 1, #friends.range40 do
                        local tempUnit = friends.range40[i]
                        if buff.envelopingMist.remains(friends.lowest.unit) < 2 and theUnit == nil then
                            theUnit = tempUnit
                        end
                    end
                    if theUnit == nil then
                        theUnit = player
                    end
                    if cast.envelopingMist(theUnit.unit) then ui.debug("[SUCCESS]: "..text2.heal2.envelopingMist2) return true else ui.debug("[FAIL]: "..text2.heal2.envelopingMist2) return false end
                end
                debugMessage("Enveloping Mist - Chi-Ji End")
            end
		end
		if br.player.ui.mode.content == 1 then
            if totemInfo.chiJiDuration > 0 and dynamic.range5 ~= nil and friends.lowest.hp >= ui.value(text.damage.chiJiDpsThreshold) then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[SUCCESS]:5P | Rising Sun Kick Chi-Ji") return true else ui.debug("[FAIL]:5P | Rising Sun Kick Chi-Ji") return false end
                end
                -- Blackout Kick on 3 stacks
                if cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.blackoutKick(dynamic.range5) then ui.debug("[SUCCESS]:5P | Blackout Kick Chi-Ji") return true else ui.debug("[FAIL]:5P | Blackout Kick Chi-Ji") return false end
                end
                if #enemies.range8 >= 3 then
                    -- Tiger Palm alternate with Spinning Crane Kick
                    if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                        if cast.spinningCraneKick(player.unit) then ui.debug("[SUCCESS]:5P | Spinning Crane Kick Chi-Ji") return true else ui.debug("[FAIL]:5P | Spinning Crane Kick Chi-Ji") return false end
                    end
                else
                    -- Tiger Palm alternate with Spinning Crane Kick
                    if cd.tigerPalm.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.tigerPalm(dynamic.range5) then ui.debug("[SUCCESS]:5P | Tiger Palm Chi-Ji") return true else ui.debug("[FAIL]:5P | Tiger Palm Chi-Ji") return false end
                    end
                end
            end
		elseif br.player.ui.mode.content == 2 then
			if totemInfo.chiJiDuration > 0 and dynamic.range5 ~= nil and friends.lowest.hp >= ui.value(text2.damage2.chiJiDpsThreshold2) then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[SUCCESS]:20P | Rising Sun Kick Chi-Ji") return true else ui.debug("[FAIL]:20P | Rising Sun Kick Chi-Ji") return false end
                end
                -- Blackout Kick on 3 stacks
                if cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.blackoutKick(dynamic.range5) then ui.debug("[SUCCESS]:20P | Blackout Kick Chi-Ji") return true else ui.debug("[FAIL]:20P | Blackout Kick Chi-Ji") return false end
                end
                if #enemies.range8 >= 3 then
                    -- Tiger Palm alternate with Spinning Crane Kick
                    if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                        if cast.spinningCraneKick(player.unit) then ui.debug("[SUCCESS]:20P | Spinning Crane Kick Chi-Ji") return true else ui.debug("[FAIL]:20P | Spinning Crane Kick Chi-Ji") return false end
                    end
                else
                    -- Tiger Palm alternate with Spinning Crane Kick
                    if cd.tigerPalm.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.tigerPalm(dynamic.range5) then ui.debug("[SUCCESS]:20P | Tiger Palm Chi-Ji") return true else ui.debug("[FAIL]:20P | Tiger Palm Chi-Ji") return false end
                    end
                end
            end
		end			
        end,

        rangedDamage = function()
		if br.player.ui.mode.content == 1 then
            -- Crackling Jade Lightning
            if dynamic.range40 ~= nil and not player.isMoving and not cast.active.cracklingJadeLightning() then
                if ui.checked(text.damage.cracklingJadeLightning) and cd.cracklingJadeLightning.ready() then
                    if cast.cracklingJadeLightning(dynamic.range40) then ui.debug("[SUCCESS]: ".. text.damage.cracklingJadeLightning) return true else ui.debug("[FAIL]: ".. text.damage.cracklingJadeLightning) return false end
                end
            end
		elseif br.player.ui.mode.content == 2 then
            if dynamic.range40 ~= nil and not player.isMoving and not cast.active.cracklingJadeLightning() then
                if ui.checked(text2.damage2.cracklingJadeLightning2) and cd.cracklingJadeLightning.ready() then
                    if cast.cracklingJadeLightning(dynamic.range40) then ui.debug("[SUCCESS]: ".. text2.damage2.cracklingJadeLightning2) return true else ui.debug("[FAIL]: ".. text2.damage2.cracklingJadeLightning2) return false end
                end
            end
		end
        end
    },

    extra = function()
        if br.player.module.BasicHealing() then
            return true
        end
    end
}

local getTotemInfo = function()
    for index=1,4 do
        local exists, totemName, startTime, duration, _ = GetTotemInfo(index)
        if exists and totemName ~= nil then
            local estimateDuration = br.round2(startTime + duration - GetTime())
            if string.find(totemName, "Jade") then
                totemInfo.jadeSerpentStatueDuration = estimateDuration
            elseif string.find(totemName, "Yulon") then
                totemInfo.yulonDuration = estimateDuration
            elseif string.find(totemName, "Chi") then
                totemInfo.chiJiDuration = estimateDuration
            end
        end
    end
end

local function runRotation()
    debugMessage("##########################################")
    buff                = br.player.buff
    cast                = br.player.cast
    cd                  = br.player.cd
    charges             = br.player.charges
    dynamic       = {
        range5          = br.player.units.get(5),
        range40         = br.player.units.get(40)
    }
    enemies             = {
        range5          = br.player.enemies.get(5),
        range6          = br.player.enemies.get(6),
        range8          = br.player.enemies.get(8),
        range40         = br.player.enemies.get(40)
    }
    friends             = {
        lowest          = br.friend[1],
        range10         = br.getAllies("player", 10),
        range30         = br.getAllies("player", 30),
        range40         = br.getAllies("player", 40),
    }
	if br.player.ui.mode.content == 1 then
    friends.lowAllies   = {
        essenceFont                 = br.getLowAlliesInTable(br.player.ui.value(text.heal.essenceFont.."2"), friends.range30),
        essenceFontOoc              = br.getLowAlliesInTable(br.player.ui.value(text.heal.outOfCombat.essenceFont.."2") , friends.range30),
        revival                     = br.getLowAlliesInTable(br.player.ui.value(text.heal.revival.."2"), friends.range40),
        refreshingJadeWind          = br.getLowAlliesInTable(br.player.ui.value(text.heal.refreshingJadeWind.."2"), friends.range10),
        invokeYulonTheJadeSerpent   = br.getLowAlliesInTable(br.player.ui.value(text.heal.invokeYulonTheJadeSerpent.."2"), friends.range40),
        invokeChiJiTheRedCrane      = br.getLowAlliesInTable(br.player.ui.value(text.heal.invokeChiJiTheRedCrane.."2"), friends.range40),
    }
	elseif br.player.ui.mode.content == 2 then
	    friends.lowAllies   = {
        essenceFont                 = br.getLowAlliesInTable(br.player.ui.value(text2.heal2.essenceFont2.."2"), friends.range30),
        essenceFontOoc              = br.getLowAlliesInTable(br.player.ui.value(text2.heal2.outOfCombat2.essenceFont2.."2") , friends.range30),
        revival                     = br.getLowAlliesInTable(br.player.ui.value(text2.heal2.revival2.."2"), friends.range40),
        refreshingJadeWind          = br.getLowAlliesInTable(br.player.ui.value(text2.heal2.refreshingJadeWind2.."2"), friends.range10),
        invokeYulonTheJadeSerpent   = br.getLowAlliesInTable(br.player.ui.value(text2.heal2.invokeYulonTheJadeSerpent2.."2"), friends.range40),
        invokeChiJiTheRedCrane      = br.getLowAlliesInTable(br.player.ui.value(text2.heal2.invokeChiJiTheRedCrane2.."2"), friends.range40),
    }
	end
    player              = {
        hp              = br.player.health,
        unit            = "player",
        mana            = br.player.power.mana.percent(),
        race            = br.player.unit.race(),
        isFlying        = IsFlying(),
        isMounted       = IsMounted(),
        isMoving        = br.isMoving("player"),
        isDrinking      = br.getBuffRemain("player", 308433) > 0 or br.getBuffRemain("player", 167152) > 0,
        inCombat        = br.player.inCombat
    }
    spell               = br.player.spell
    talent              = br.player.talent
    tanks               = br.getTanksTable()
    totemInfo           = {
        jadeSerpentStatueDuration   = 0,
        yulonDuration               = 0,
        chiJiDuration               = 0
    }
    ui                  = br.player.ui
    unit                = br.player.unit

    ui.mode.thunderFocusTea = br.data.settings[br.selectedSpec].toggles["ThunderFocusTea"]
    ui.mode.dps = br.data.settings[br.selectedSpec].toggles["DPS"]

    local current

    debugMessage("Loaded variables")

    if ui.checked(text.debug) then
        debugMessage("Debug Info Begin")
        getDebugInfo()
        debugMessage("Debug Info Done")
    end

    debugMessage("Totem Info Begin")
    getTotemInfo()
    debugMessage("Totem Info Done")


    if br.pause(true) or player.isMounted or player.isFlying or player.isDrinking then
        debugMessage("paused")
        return true
    end

    debugMessage("  Extra Rotation Init")
    current = actionList.extra()
    debugMessage("  Extra Rotation End")
    if current ~= nil then
        return true
    end

    if player.inCombat then

        if br._G.IsAoEPending() then
            br._G.CancelPendingSpell()
        end

        debugMessage("In Combat")
        if current ~= nil then
            return true
        end

        if ui.useCDs() then
            debugMessage("  Healing CDs Init")
            current = actionList.healing.CDs()
            debugMessage("  Healing CDs End")
            if current ~= nil then
                return true
            end
        end

        -- Don't cancel essence font on large group
        if #friends.range30 > 5 then
            if cast.active.essenceFont() then
                return true
            end
        end

        debugMessage("  Healing Thunder Focus Tea Rotation Init")
        current = actionList.healing.thunderFocusTeaRotation()
        debugMessage("  Healing Thunder Focus Tea Rotation End")
        if current ~= nil then
            return true
        end

        debugMessage("  Healing Renewing Mist Init")
        current = actionList.healing.renewingMist()
        debugMessage("  Healing Renewing Mist End")
        if current ~= nil then
            return true
        end

        debugMessage("  Healing AoE Vivify Init")
        current = actionList.healing.vivifyAoE()
        debugMessage("  Healing AoE Vivify End")
        if current ~= nil then
            return true
        end

        debugMessage("  Healing AoE Rotation Init")
        current = actionList.healing.AoERotation()
        debugMessage("  Healing AoE Rotation End")
        if current ~= nil then
            return true
        end

        debugMessage("  Healing Self Defense Rotation Init")
        current = actionList.selfDefense()
        debugMessage("  Healing Self Defense Rotation End")
        if current ~= nil then
            return true
        end

        debugMessage("  Utility Rotation Init")
        current = actionList.utility()
        debugMessage("  Utility Rotation End")
        if current ~= nil then
            return true
        end

        debugMessage("  Damage Chi-Ji Rotation Init")
        current = actionList.damage.chiJiRotation()
        debugMessage("  Damage Chi-Ji Rotation End")
        if current ~= nil then
            return true
        end
		
		debugMessage("  Healing Faeline Stomp Rotation Init")
        current = actionList.healing.faelineStompRotation()
        debugMessage("  Healing Faeline Stomp Rotation End")
        if current ~= nil then
            return true
        end
		
		debugMessage("  Healing Zen Pulse Rotation Init")
        current = actionList.healing.zenPulseRotation()
        debugMessage("  Healing en Pulse Rotation End")
        if current ~= nil then
            return true
        end

        debugMessage("  Healing Soothing Mist Rotation Init")
        current = actionList.healing.soothingMistRotation()
        debugMessage("  Healing Soothing Mist Rotation End")
        if current ~= nil then
            return true
        end

        debugMessage("  Healing Single Target Rotation Init")
        current = actionList.healing.singleTargetRotation()
        debugMessage("  Healing Single Target Rotation End")
        if current ~= nil then
            return true
        end

        if ui.useCDs() then
            debugMessage("  Damage CDs Init")
            current = actionList.damage.CDs()
            debugMessage("  Damage CDs End")
            if current ~= nil then
                return true
            end
        end

        if friends.lowest.hp >= ui.value(text.damage.dpsThreshold) and ui.mode.dps < 4 then
            if ui.mode.dps == 1 or ui.mode.dps == 2 then
                debugMessage("  Damage AoE Rotation Init")
                current = actionList.damage.AoERotation()
                debugMessage("  Damage AoE Rotation End")
                if current ~= nil then
                    return true
                end
            end
            if ui.mode.dps == 1 or ui.mode.dps == 3 then
                debugMessage("  Damage ST Rotation Init")
                current = actionList.damage.singleTargetRotation()
                debugMessage("  Damage ST Rotation End")
                if current ~= nil then
                    return true
                end

                debugMessage("  Damage Ranged Rotation Init")
                current = actionList.damage.rangedDamage()
                debugMessage("  Damage Ranged Rotation End")
                if current ~= nil then
                    return true
                end
            end
        end
    else
        debugMessage("  Healing OoC Init")
        current = actionList.healing.outOfCombatRotation()
        debugMessage("  Healing OoC End")
        if current ~= nil then
            return true
        end
    end

end

local id = 270

if br.rotations[id] == nil then
    br.rotations[id] = {}
end

tinsert(
        br.rotations[id],
        {
            name = rotationName,
            toggles = createToggles,
            options = createOptions,
            run = runRotation
        }
)
local rotationName = "Lylo"
local version = "2.2.2"


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
        options                     = colors.green.."Heal - Options",
        chiWave                     = colors.green.."Chi Wave",
        chiBurst                    = colors.green.."Chi Burst",
        refreshingJadeWind          = colors.green.."Refreshing Jade Wind",
        invokeYulonTheJadeSerpent   = colors.green.."Invoke Yu'lon, the Jade Serpent",
        invokeChiJiTheRedCrane      = colors.green.."Invoke Chi-Ji, the Red Crane",
        lifeCocoon                  = colors.green.."Life Cocoon",
        lifeCocoonMode              = colors.green.."Life Cocoon - Mode",
        revival                     = colors.green.."Revival",
        weaponsOfOrder              = colors.green.."Weapons of Order",
        renewingMist                = colors.green.."Renewing Mist",
        vivify                      = colors.green.."Vivify",
        envelopingBreath            = colors.green.."Enveloping Breath",
        envelopingMist              = colors.green.."Enveloping Mist",
        essenceFont                 = colors.green.."Essence Font",
        soothingMist                = {
            soothingMist            = colors.aqua.."Soothing Mist",
            vivify                  = colors.aqua.."Vivify",
            vivifyAoE               = colors.aqua.."Vivify AoE",
            envelopingMist          = colors.aqua.."Enveloping Mist",
            expelHarm               = colors.aqua.."Expel Harm",
        },
        outOfCombat                 = {
            essenceFont             = colors.green2.."Essence Font",
            vivify                  = colors.green2.."Vivify",
            renewingMist            = colors.green2.."Renewing Mist",
        },
        thunderFocusTea             = {
            envelopingMist          = colors.blue3.."Enveloping Mist",
            renewingMist            = colors.blue3.."Renewing Mist",
            vivify                  = colors.blue3.."Vivify",
            risingSunKick           = colors.blue3.."Rising Sun Kick",
        },
    },
    utility = {
        options                     = colors.yellow.."Utility - Options",
        tigersLust                  = colors.yellow.."Tiger's Lust",
        manaTea                     = colors.yellow.."Mana Tea",
        manaTeaWithYulon            = colors.yellow.."Mana Tea with Yulon",
        weaponsOfOrderWithChiji     = colors.yellow.."Weapons of Order with Chi-Ji",
        summonJadeSerpentStatue     = colors.yellow.."Summon Jade Serpent Statue",
        arcaneTorrent               = colors.yellow.."Arcane Torrent",
        ringOfPeace                 = colors.yellow.."Ring of Peace",
    },
    manual = {
        options                     = colors.blue.."Manual - Options",
        chiBurst                    = colors.blue.."Chi Burst",
        rollOrChiTorpedo            = colors.blue.."Chi Torpedo / Roll",
        manaTea                     = colors.blue.."Mana Tea",
        songOfChiJiOrRingOfPeace    = colors.blue.."Song of Chi-Ji / Ring of Peace",
        diffuseMagicOrDampenHarm    = colors.blue.."Diffuse Magic / Dampen Harm",
        transcendenceOrTransfer     = colors.blue.."Transcendence / Transfer",
        lifeCocoon                  = colors.blue.."Life Cocoon",
        revival                     = colors.blue.."Revival",
        invokeYulonTheJadeSerpent   = colors.blue.."Invoke Yu'lon, the Jade Serpent",
        invokeChiJiTheRedCrane      = colors.blue.."Invoke Chi-Ji, the Red Crane",
        summonJadeSerpentStatue     = colors.blue.."Summon Jade Serpent Statue",
        weaponsOfOrder              = colors.blue.."Weapons Of Order",
        tigersLust                  = colors.blue.."Tiger's Lust",
        fortifyingBrew              = colors.blue.."Fortifying Brew",
        legSweep                    = colors.blue.."Leg Sweep",
    },
    selfDefense = {
        options                                     = colors.purple.."Self Defense - Options",
        healingElixirOrDiffuseMagicOrDampenHarm     = colors.purple.."Healing Elixir / Diffuse Magic / Dampen Harm",
        fortifyingBrew                              = colors.purple.."Fortifying Brew",
        legSweep                                    = colors.purple.."Leg Sweep",
        expelHarm                                   = colors.purple.."Expel Harm",
    },
    damage = {
        options                                     = colors.red.."Damage - Options",
        dpsThreshold                                = colors.red.."DPS Threshold",
        chiJiDpsThreshold                           = colors.red.."Chi-Ji DPS Threshold",
        cracklingJadeLightning                      = colors.red.."Crackling Jade Lightning",
        touchOfDeath                                = colors.red.."Touch of Death",
    },
    legendary = {
        options                         = colors.orange.."Legendary - Options",
        ancientTeachingOfTheMonastery   = colors.orange.."Ancient Teachings of the Monastery",
    },
    extra = {
        options = "Extra - Options"
    }
}

local function createToggles()
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.lifeCocoon },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.lifeCocoon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.lifeCocoon }
    }
    br.ui:createToggle(CooldownModes,"Cooldown",1,0)
    local ThunderFocusTeaModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Thunder Focus Tea Mode Auto", tip = "Thunder Focus Tea Mode Auto", highlight = 1, icon = br.player.spell.thunderFocusTea },
        [2] = { mode = "EM", value = 2, overlay = "Thunder Focus Tea Mode - Enveloping Mist", tip = "Thunder Focus Tea Mode - Enveloping Mist", highlight = 1, icon = br.player.spell.envelopingMist },
        [3] = { mode = "VVF", value = 3, overlay = "Thunder Focus Tea Mode - Vivify", tip = "Thunder Focus Tea Mode - Vivify", highlight = 1, icon = br.player.spell.vivify },
        [4] = { mode = "RM", value = 4, overlay = "Thunder Focus Tea Mode - Renewing Mist", tip = "Thunder Focus Tea Mode - Renewing Mist", highlight = 1, icon = br.player.spell.renewingMist },
        [5] = { mode = "RSK", value = 5, overlay = "Thunder Focus Tea Mode - Rising Sun Kick", tip = "Thunder Focus Tea Mode - Rising Sun Kick", highlight = 1, icon = br.player.spell.risingSunKick }
    }
    br.ui:createToggle(ThunderFocusTeaModes,"ThunderFocusTea", 2, 0)
    local DPSModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.tigerPalm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 1, icon = br.player.spell.spinningCraneKick },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 1, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.vivify}
    }
    br.ui:createToggle(DPSModes,"DPS", 3, 0)
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.paralysis },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.paralysis }
    }
    br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)
    local DetoxModes = {
        [1] = { mode = "On", value = 1, overlay = "Detox Enabled", tip = "Detox Enabled", highlight = 1, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2, overlay = "Detox Disabled", tip = "Detox Disabled", highlight = 0, icon = br.player.spell.detox }
    };
    br.ui:createToggle(DetoxModes,"Detox", 5, 0)
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
        weaponsOfOrder              = nil,
    }
}

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        section = br.ui:createSection(br.ui.window.profile, "Debug Info - Version " .. version)
        br.ui:createCheckbox(       section, text.debug,  "Enable Debug Info")
        br.ui:createCheckbox(       section, text.detailedDebugger,  "Enable Debug Info")
        br.ui:createText(section, "Lowest Unit")
        labels.lowest   = br.ui:createText(section, "")
        br.ui:createText(section, "Dynamic Target")
        labels.dynamic.range5     = br.ui:createText(section, "")
        labels.dynamic.range40    = br.ui:createText(section, "")
        br.ui:createText(section, "Group Healing")
        labels.lowAllies.essenceFont                = br.ui:createText(section, "")
        labels.lowAllies.essenceFontOoc             = br.ui:createText(section, "")
        labels.lowAllies.revival                    = br.ui:createText(section, "")
        labels.lowAllies.invokeYulonTheJadeSerpent  = br.ui:createText(section, "")
        labels.lowAllies.invokeChiJiTheRedCrane     = br.ui:createText(section, "")
        labels.lowAllies.weaponsOfOrder             = br.ui:createText(section, "")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.heal.options)
        br.ui:createText(section, "CDs - Options")
        br.ui:createSpinner(        section, text.heal.lifeCocoon, 30, 1, 100, 5, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDropdownWithout(section, text.heal.lifeCocoonMode,   {colors.blue .. "Any", colors.green .. "Tank", colors.red .. "Tank/Healer"}, 2, "Use ability only on selected type ".. colors.green .. "(default: Tank)")
        br.ui:createDoubleSpinner(  section, text.heal.revival,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 50, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(  section, text.heal.invokeYulonTheJadeSerpent,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(  section, text.heal.invokeChiJiTheRedCrane,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(  section, text.heal.weaponsOfOrder,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)

        br.ui:createText(section, "Thunder Focus Tea - Options")
        br.ui:createSpinner(        section, text.heal.thunderFocusTea.envelopingMist,  50, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDoubleSpinner(  section, text.heal.thunderFocusTea.vivify,
                { number = 80, min = 1, max = 100, step = 1, tooltip = "Mana of player to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createSpinner(        section, text.heal.thunderFocusTea.renewingMist,    90, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createCheckbox(       section, text.heal.thunderFocusTea.risingSunKick,  "Enable auto usage of this spell")
        br.ui:createText(section, "Soothing Mist - Options")
        br.ui:createSpinner(        section, text.heal.soothingMist.soothingMist, 85, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(        section, text.heal.soothingMist.envelopingMist, 80, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(        section, text.heal.soothingMist.vivify, 75, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createDoubleSpinner(  section, text.heal.soothingMist.vivifyAoE,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends with renewing mist buff" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createSpinner(        section, text.heal.soothingMist.expelHarm, 75, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createText(section, "Other - Options")
        br.ui:createSpinner(        section, text.heal.renewingMist, 94, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(        section, text.heal.vivify, 80, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(        section, text.heal.envelopingMist, 70, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createCheckbox(       section, text.heal.chiWave, "Enable auto usage of this spell")
        br.ui:createDoubleSpinner(  section, text.heal.chiBurst,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 85, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(  section, text.heal.refreshingJadeWind,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 75, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(  section, text.heal.essenceFont,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createDoubleSpinner(  section, text.heal.envelopingBreath,
                { number = 3, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createText(section, "Out of Combat - Options")
        br.ui:createDoubleSpinner(  section, text.heal.outOfCombat.essenceFont,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Amount of friends under health to cast spell" },
                { number = 90, min = 1, max = 100, step = 5, tooltip = "Health of friends to cast spell" }, false)
        br.ui:createSpinner(        section, text.heal.outOfCombat.renewingMist,    95, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:createSpinner(        section, text.heal.outOfCombat.vivify, 90, 1, 100, 1, "Enable auto usage of this spell", "Health of unit to cast spell")
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, text.utility.options)
        br.ui:createCheckbox( section, text.utility.tigersLust,       "Enable auto usage of this spell on player or allies")
        br.ui:createSpinner(  section, text.utility.manaTea, 60, 1, 100, 5, "Mana of player to cast spell")
        br.ui:createCheckbox( section, text.utility.manaTeaWithYulon,       "Enable auto usage of this spell when Yulon is activated")
        br.ui:createCheckbox( section, text.utility.weaponsOfOrderWithChiji,       "Enable auto usage of this spell when Chi-Ji is activated")
        br.ui:createDropdown( section, text.utility.summonJadeSerpentStatue, {"Around Tank", "Around Player"}, 2, "Enable usage of this spell around option", "Select")
        br.ui:createSpinner(  section, text.utility.arcaneTorrent, 70, 1, 100, 5, "Mana of player to cast spell")
        br.ui:createCheckbox( section, text.utility.ringOfPeace,       "Enable auto usage of this spell to interrupt")
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, text.selfDefense.options)
        br.ui:createSpinner(        section, text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm,  65, 1, 100, 05, "Enable auto usage of this spell", "Health of player to cast spell")
        br.ui:createSpinner(        section, text.selfDefense.fortifyingBrew,                           65, 1, 100, 05, "Enable auto usage of this spell", "Health of player to cast spell")
        br.ui:createDoubleSpinner(  section, text.selfDefense.legSweep,
                { number = 2, min = 1, max = 40, step = 1, tooltip = "Number of Units in 5 Yards to Cast At" },
                { number = 70, min = 1, max = 100, step = 5, tooltip = "or Health Percent to Cast At" }, false)
        br.ui:createSpinner(        section, text.selfDefense.expelHarm,                                40, 0, 100, 05, "Enable auto usage of this spell", "Health Percent to Cast At")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.damage.options)
        br.ui:createSpinnerWithout( section, text.damage.dpsThreshold,           85, 1, 100, 5, "Lowest friend HP has to be higher then")
        br.ui:createSpinnerWithout( section, text.damage.chiJiDpsThreshold,      60, 1, 100, 5, "Lowest friend HP has to be higher then")

        br.ui:createCheckbox(       section, text.damage.cracklingJadeLightning,       "Enable auto usage of this spell")
        br.ui:createDropdown(       section, text.damage.touchOfDeath,       {colors.blue .. "Always", colors.green .. "Bosses", colors.red .. "Never"}, 2, "Enable auto usage of this spell.", "Select")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.legendary.options)
        br.ui:createSpinner(        section, text.legendary.ancientTeachingOfTheMonastery,  60, 1, 100, 5, "Enable support of this legendary", "Lowest friend HP has to be higher then")
        br.ui:checkSectionState(section)


        section = br.ui:createSection(br.ui.window.profile, text.manual.options)
        br.ui:createDropdown( section, text.manual.chiBurst, br.dropOptions.Toggle,                     6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.rollOrChiTorpedo, br.dropOptions.Toggle,             6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.manaTea, br.dropOptions.Toggle,                      6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.songOfChiJiOrRingOfPeace, br.dropOptions.Toggle,     6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.diffuseMagicOrDampenHarm, br.dropOptions.Toggle,     6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.transcendenceOrTransfer, br.dropOptions.Toggle,      6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.lifeCocoon, br.dropOptions.Toggle,                   6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.revival, br.dropOptions.Toggle,                      6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.invokeYulonTheJadeSerpent, br.dropOptions.Toggle,    6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.invokeChiJiTheRedCrane, br.dropOptions.Toggle,       6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.summonJadeSerpentStatue, br.dropOptions.Toggle,      6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.weaponsOfOrder, br.dropOptions.Toggle,               6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.tigersLust, br.dropOptions.Toggle,                   6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.fortifyingBrew, br.dropOptions.Toggle,               6, "Enable usage of this spell on key press", "Select key")
        br.ui:createDropdown( section, text.manual.legSweep, br.dropOptions.Toggle,                     6, "Enable usage of this spell on key press", "Select key")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, text.extra.options)
        br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Made By: Lylo")
        br.ui:createText(section, colors.red    .. "Discord contact: " .. colors.green .. "LyLo#0253")
        br.ui:createText(section, colors.red    .. "This is not a job, it's a hobby. I don't get paid for this, I do ")
        br.ui:createText(section, colors.red    .. "it because I like it. SO if you make me hate this, I just STOP. ")
        br.ui:createText(section, "")
        br.ui:createText(section, colors.red    .. "Required: " .. colors.yellow .. "Healing Engine > HR")
        br.ui:createText(section, colors.blue   .. "Good to have: " .. colors.yellow .. "Enemies Engine > Dynamic Targeting")
        br.ui:createText(section, colors.red    .. "FAQ:")
        br.ui:createText(section, colors.blue   .. "  1 - What are the best settings?")
        br.ui:createText(section, colors.green  .. "     Go to Proving Grounds and tweek settings")
        br.ui:createText(section, colors.green  .. "     until you find something you like.")
        br.ui:createText(section, colors.blue   .. "  2 - How can I request changes?")
        br.ui:createText(section, colors.green  .. "     Send a message on discord.")
        br.ui:createText(section, colors.blue   .. "  3 - I want to support the developer, how can I do it?")
        br.ui:createText(section, colors.green  .. "     You can support BR through Patreon or support me (Lylo) via paypal :)")
        br.ui:checkSectionState(section)
    end

    optionTable = {{
                       [1] = "Rotation Options",
                       [2] = rotationOptions,
                   }}
    return optionTable
end

-- Variables
local buff
local cast
local cd
local charges
local dynamicTarget
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
            if ui.checked(text.heal.lifeCocoon) and cd.lifeCocoon.ready() then
                local lifeCocoonMode = ui.value(text.heal.lifeCocoonMode)
                if friends.lowest.role == "TANK" or (lifeCocoonMode == 3 and friends.lowest.role == "HEALER") or lifeCocoonMode == 1 then
                    if friends.lowest.hp <= ui.value(text.heal.lifeCocoon) then
                        if cast.lifeCocoon(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.lifeCocoon) return true else ui.debug("[AUTO - FAIL]: "..text.heal.lifeCocoon) return false end
                    end
                end
            end
            -- Revival
            if ui.checked(text.heal.revival) and cd.revival.ready() then
                if friends.lowAllies.revival >= ui.value(text.heal.revival.."1") then
                    if cast.revival(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.revival) return true else ui.debug("[AUTO - FAIL]: "..text.heal.revival) return false end
                end
            end
            -- Invoke Yu'lon, the Jade Serpent
            if ui.checked(text.heal.invokeYulonTheJadeSerpent) and cd.invokeYulonTheJadeSerpent.ready() then
                if not talent.invokeChiJiTheRedCrane and friends.lowAllies.invokeYulonTheJadeSerpent >= ui.value(text.heal.invokeYulonTheJadeSerpent.."1") then
                    if cast.invokeYulonTheJadeSerpent(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.invokeYulonTheJadeSerpent) return true else ui.debug("[AUTO - FAIL]: "..text.heal.invokeYulonTheJadeSerpent) return false end
                end
            end
            -- Invoke Chi-Ji, The Red Crane
            if ui.checked(text.heal.invokeChiJiTheRedCrane) and cd.invokeChiJiTheRedCrane.ready() then
                if talent.invokeChiJiTheRedCrane and friends.lowAllies.invokeChiJiTheRedCrane >= ui.value(text.heal.invokeChiJiTheRedCrane.."1") then
                    if cast.invokeChiJiTheRedCrane(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.invokeChiJiTheRedCrane) return true else ui.debug("[AUTO - FAIL]: "..text.heal.invokeChiJiTheRedCrane) return false end
                end
            end
            -- Weapons of Order
            if ui.checked(text.heal.weaponsOfOrder) and cd.weaponsOfOrder.ready() then
                if friends.lowAllies.weaponsOfOrder >= ui.value(text.heal.weaponsOfOrder.."1") then
                    if cast.weaponsOfOrder(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.weaponsOfOrder) return true else ui.debug("[AUTO - FAIL]: "..text.heal.weaponsOfOrder) return false end
                end
            end
            if ui.checked(text.utility.weaponsOfOrderWithChiji) and cd.weaponsOfOrder.ready() and totemInfo.chiJiDuration > 0 then
                if cast.weaponsOfOrder(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.utility.weaponsOfOrderWithChiji) return true else ui.debug("[AUTO - FAIL]: "..text.utility.weaponsOfOrderWithChiji) return false end
            end
        end,

        renewingMist = function()
            if cast.active.essenceFont() then
                return nil
            end
            if cast.active.soothingMist() and friends.lowest.hp <= 60 then
                return nil
            end
            -- Renewing Mist
            debugMessage("      Renewing Mist Init")
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
                    if cast.renewingMist(renewingMistUnit.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.renewingMist) return true else ui.debug("[AUTO - FAIL]: "..text.heal.renewingMist) return false end
                end
            end
            debugMessage("      Renewing Mist End")
        end,

        soothingMistRotation = function()
            -- Cancel Soothing Mist
            if cast.active.soothingMist() then --and lastSoothingMist.unit ~= friends.lowest.unit then
                if getRealHP(lastSoothingMist.unit) - friends.lowest.hp >= 20 or getRealHP(lastSoothingMist.unit) >= ui.value(text.heal.soothingMist.soothingMist)+5 then
                    if cast.cancel.soothingMist() then ui.debug("[AUTO - SUCCESS]: Cancel - "..text.heal.soothingMist.soothingMist) return true else ui.debug("[AUTO - FAIL]: Cancel - "..text.heal.soothingMist.soothingMist) return false end
                end
            end
            -- Soothing Mist
            if ui.checked(text.heal.soothingMist.soothingMist) and cd.soothingMist.ready() and not cast.active.soothingMist() and not player.br.isMoving then
                if friends.lowest.hp <= ui.value(text.heal.soothingMist.soothingMist) then
                    if cast.soothingMist(friends.lowest.unit) then
                        lastSoothingMist = {
                            hp = friends.lowest.hp,
                            unit = friends.lowest.unit
                        }
                        ui.debug("[AUTO - SUCCESS]: "..text.heal.soothingMist.soothingMist) return true else ui.debug("[AUTO - FAIL]: "..text.heal.soothingMist.soothingMist) return false end
                end
            end
            -- Instant casts
            if cast.active.soothingMist() and friends.lowest.unit == lastSoothingMist.unit then
                -- Enveloping Mist
                if ui.checked(text.heal.soothingMist.envelopingMist) and cd.envelopingMist.ready() then
                    if friends.lowest.hp <= ui.value(text.heal.soothingMist.envelopingMist) and buff.envelopingMist.remains(friends.lowest.unit) < 2 then
                        if cast.envelopingMist(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.soothingMist.envelopingMist) return true else ui.debug("[AUTO - FAIL]: "..text.heal.soothingMist.envelopingMist) return false end
                    end
                end
                -- Expel Harm
                if ui.checked(text.heal.soothingMist.expelHarm) and cd.expelHarm.ready() then
                    if friends.lowest.hp <= ui.value(text.heal.soothingMist.expelHarm) then
                        if cast.expelHarm(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.soothingMist.expelHarm) return true else ui.debug("[AUTO - FAIL]: "..text.heal.soothingMist.expelHarm) return false end
                    end
                end
                -- Vivify
                if ui.checked(text.heal.soothingMist.vivify) and cd.vivify.ready() then
                    if friends.lowest.hp <= ui.value(text.heal.soothingMist.vivify) then
                        if cast.vivify(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.soothingMist.vivify) return true else ui.debug("[AUTO - FAIL]: "..text.heal.soothingMist.vivify) return false end
                    end
                end
            end
            if cast.active.soothingMist() then
                return false
            end
        end,

        vivifyAoE = function()
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
                        if cast.vivify(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.soothingMist.vivifyAoE) return true else ui.debug("[AUTO - FAIL]: "..text.heal.soothingMist.vivifyAoE) return false end
                    end
                end
            end
        end,

        AoERotation = function()
            -- Chi Burst
            debugMessage("      Chi Burst Init")
            if ui.checked(text.heal.chiBurst) and cd.chiBurst.ready() and talent.chiBurst and not player.br.isMoving then
                local lowAlliesTargetsChiBurst = br.getUnitsInRect(7 , 40, false, ui.value(text.heal.chiBurst.."2"))
                if lowAlliesTargetsChiBurst >= ui.value(text.heal.chiBurst.."1") then
                    if cast.chiBurst(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.chiBurst) return true else ui.debug("[AUTO - FAIL]: "..text.heal.chiBurst) return false end
                end
            end
            debugMessage("      Chi Burst End")
            -- Essence Font
            debugMessage("      Essence Font Init")
            if ui.checked(text.heal.essenceFont) and cd.essenceFont.ready() then
                if friends.lowAllies.essenceFont >= ui.value(text.heal.essenceFont.."1") then
                    if cast.essenceFont(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.essenceFont) return true else ui.debug("[AUTO - FAIL]: "..text.heal.essenceFont) return false end
                end
            end
            debugMessage("      Essence Font End")
            -- Enveloping Breath
            debugMessage("      Enveloping Breath Init")
            if ui.checked(text.heal.envelopingBreath) and cd.envelopingMist.ready() and not player.br.isMoving then
                if totemInfo.yulonDuration > cast.time.envelopingMist() + br.getLatency() or totemInfo.chiJiDuration > cast.time.envelopingMist() + br.getLatency() then
                    local lowHealthAroundUnit = br.getUnitsToHealAround(friends.lowest.unit, 7.5, ui.value(text.heal.envelopingBreath.."2"), 6)
                    if #lowHealthAroundUnit >= ui.value(text.heal.envelopingBreath.."1") then
                        if cast.envelopingMist(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.envelopingBreath) return true else ui.debug("[AUTO - FAIL]: "..text.heal.envelopingBreath) return false end
                    end
                end
            end
            debugMessage("      Enveloping Breath End")
            -- Vivify AoE - testing to be insta cast with soothingMist
            --debugMessage("      Vivify AoE Init")
            --if ui.checked(text.heal.vivifyAoE) and cd.vivify.ready() and not player.br.isMoving then
            --    local countUnitsWithRenewingMistUnderHealth = 0
            --    if not buff.renewingMist.exists(friends.lowest.unit) and friends.lowest.hp <= ui.value(text.heal.vivifyAoE.."2") then
            --        countUnitsWithRenewingMistUnderHealth = 1
            --    end
            --    for i = 1, #friends.range40 do
            --        local tempUnit = friends.range40[i]
            --        if buff.renewingMist.exists(tempUnit.unit) and tempUnit.hp <= ui.value(text.heal.vivifyAoE.."2") then
            --            countUnitsWithRenewingMistUnderHealth = countUnitsWithRenewingMistUnderHealth + 1
            --        end
            --    end
            --    if countUnitsWithRenewingMistUnderHealth >= ui.value(text.heal.vivifyAoE.."1") then
            --        if cast.vivify(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.vivifyAoE) return true else ui.debug("[AUTO - FAIL]: "..text.heal.vivifyAoE) return false end
            --    end
            --end
            --debugMessage("      Vivify AoE End")
            -- Refreshing Jade Wind
            debugMessage("      Refreshing Jade Wind Init")
            if ui.checked(text.heal.refreshingJadeWind) and cd.refreshingJadeWind.ready() and talent.refreshingJadeWind then
                if friends.lowAllies.refreshingJadeWind >= ui.value(text.heal.refreshingJadeWind.."1") then
                    if cast.refreshingJadeWind(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.refreshingJadeWind) return true else ui.debug("[AUTO - FAIL]: "..text.heal.refreshingJadeWind) return false end
                end
            end
            debugMessage("      Refreshing Jade Wind End")
        end,

        singleTargetRotation = function()
            -- Chi Wave
            debugMessage("      Chi Wave Init")
            if ui.checked(text.heal.chiWave) and cd.chiWave.ready() and talent.chiWave and dynamic.range40 ~= nil then
                if cast.chiWave(player.unit,"aoe") then ui.debug("[AUTO - SUCCESS]: "..text.heal.chiWave) return true else ui.debug("[AUTO - FAIL]: "..text.heal.chiWave) return false end
            end
            debugMessage("      Chi Wave End")
            -- Enveloping Mist
            debugMessage("      Enveloping Mist Init")
            if ui.checked(text.heal.envelopingMist) and cd.envelopingMist.ready() and not player.br.isMoving then
                if friends.lowest.hp <= ui.value(text.heal.envelopingMist) then
                    if cast.envelopingMist(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.envelopingMist) return true else ui.debug("[AUTO - FAIL]: "..text.heal.envelopingMist) return false end
                end
            end
            debugMessage("      Enveloping Mist End")
            -- Vivify
            debugMessage("      Vivify Init")
            if ui.checked(text.heal.vivify) and cd.vivify.ready() and not player.br.isMoving then
                if friends.lowest.hp <= ui.value(text.heal.vivify) then
                    if cast.vivify(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.vivify) return true else ui.debug("[AUTO - FAIL]: "..text.heal.vivify) return false end
                end
            end
            debugMessage("      Vivify End")
        end,

        outOfCombatRotation = function()
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
                    if cast.renewingMist(renewingMistUnit.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.outOfCombat.renewingMist) return true else ui.debug("[AUTO - FAIL]: "..text.heal.outOfCombat.renewingMist) return false end
                end
            end
            -- Essence Font
            if ui.checked(text.heal.outOfCombat.essenceFont) and cd.essenceFont.ready() then
                if friends.lowAllies.essenceFontOoc >= ui.value(text.heal.outOfCombat.essenceFont.."1") then
                    if cast.essenceFont(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.outOfCombat.essenceFont) return true else ui.debug("[AUTO - FAIL]: "..text.heal.outOfCombat.essenceFont) return false end
                end
            end
            -- Vivify
            if ui.checked(text.heal.outOfCombat.vivify) and cd.vivify.ready() and not player.br.isMoving then
                if friends.lowest.hp <= ui.value(text.heal.outOfCombat.vivify) then
                    if cast.vivify(friends.lowest.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.outOfCombat.vivify) return true else ui.debug("[AUTO - FAIL]: "..text.heal.outOfCombat.vivify) return false end
                end
            end
        end,

        thunderFocusTeaRotation = function()
            if cd.thunderFocusTea.ready() then
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 2 and not player.br.isMoving then -- EM
                    -- Thunder Focus Tea + Enveloping Mist
                    if ui.checked(text.heal.thunderFocusTea.envelopingMist) and friends.lowest.hp <= ui.value(text.heal.thunderFocusTea.envelopingMist) and cd.envelopingMist.ready() then
                        if cast.thunderFocusTea(player.unit) and cast.envelopingMist(friends.lowest.unit) then
                            ui.debug("[AUTO - SUCCESS]: "..text.heal.thunderFocusTea.envelopingMist)
                            return true
                        else ui.debug("[AUTO - FAIL]: "..text.heal.thunderFocusTea.envelopingMist) return false end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 3 and not player.br.isMoving then -- VVF
                    -- Thunder Focus Tea + Vivify
                    if ui.checked(text.heal.thunderFocusTea.vivify) and friends.lowest.hp <= ui.value(text.heal.thunderFocusTea.vivify.."2") and cd.vivify.ready() then
                        if player.mana <= ui.value(text.heal.thunderFocusTea.vivify.."1") then
                            if cast.thunderFocusTea(player.unit) and cast.vivify(friends.lowest.unit) then
                                ui.debug("[AUTO - SUCCESS]: "..text.heal.thunderFocusTea.vivify)
                                return true
                            else ui.debug("[AUTO - FAIL]: "..text.heal.thunderFocusTea.vivify) return false end
                        end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 4 then -- RM
                    -- Thunder Focus Tea + Renewing Mist
                    if ui.checked(text.heal.thunderFocusTea.renewingMist) and friends.lowest.hp <= ui.value(text.heal.thunderFocusTea.renewingMist) and not buff.renewingMist.exists(friends.lowest.unit) and charges.renewingMist.exists() and cd.renewingMist.ready() then
                        if cast.thunderFocusTea(player.unit) and cast.renewingMist(friends.lowest.unit) then
                            ui.debug("[AUTO - SUCCESS]: "..text.heal.thunderFocusTea.renewingMist)
                            return true
                        else ui.debug("[AUTO - FAIL]: "..text.heal.thunderFocusTea.renewingMist) return false end
                    end
                end
                if ui.mode.thunderFocusTea == 1 or ui.mode.thunderFocusTea == 5 then -- RSK
                    -- Thunder Focus Tea + Rising Sun Kick
                    if ui.checked(text.heal.thunderFocusTea.risingSunKick) and cd.risingSunKick.ready() and dynamic.range5 ~= nil and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.thunderFocusTea(player.unit) and cast.risingSunKick(friends.lowest.unit) then
                            ui.debug("[AUTO - SUCCESS]: "..text.heal.thunderFocusTea.risingSunKick)
                            return true
                        else ui.debug("[AUTO - FAIL]: "..text.heal.thunderFocusTea.risingSunKick) return false end
                    end
                end
            end
        end
    },

    utility = function()
        -- Tiger's Lust
        debugMessage("      Tiger's Lust Init")
        if ui.checked(text.utility.tigersLust) and talent.tigersLust and cd.tigersLust.ready()  then
            for i = 1, #friends.range40 do
                local tempUnit = friends.range40[i]
                if cast.noControl.tigersLust(tempUnit.unit) then
                    if cast.tigersLust(tempUnit.unit) then ui.debug("[AUTO - SUCCESS]: "..text.utility.tigersLust) return true else ui.debug("[AUTO - FAIL]: "..text.utility.tigersLust) return false end
                end
            end
        end
        debugMessage("      Tiger's Lust End")
        -- Mana Tea
        debugMessage("      Mana Tea Init")
        if ui.checked(text.utility.manaTea) and talent.manaTea and cd.manaTea.ready() then
            if player.mana <= ui.value(text.utility.manaTea) then
                if cast.manaTea(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.utility.manaTea) return true else ui.debug("[AUTO - FAIL]: "..text.utility.manaTea) return false end
            end
        end
        -- Mana Tea Yulon
        if ui.checked(text.utility.manaTeaWithYulon) and talent.manaTea and cd.manaTea.ready() and totemInfo.yulonDuration >= 5 then
            if cast.manaTea(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.utility.manaTeaWithYulon) return true else ui.debug("[AUTO - FAIL]: "..text.utility.manaTeaWithYulon) return false end
        end
        debugMessage("      Mana Tea End")
        -- Summon Jade Serpent Statue
        debugMessage("      Summon Jade Serpent Statue Init")
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
                    br.addonDebug(colors.yellow .. "[AUTO - ?]: Jade Serpent Statue - distance to statue: " .. distanceToStatue .. ", old totem duration: " .. totemInfo.jadeSerpentStatueDuration)
                    return true
                end
            end
        end
        debugMessage("      Summon Jade Serpent Statue End")
        -- Arcane Torrent
        debugMessage("      Arcane Torrent Init")
        if ui.checked(text.utility.arcaneTorrent) and player.race == "BloodElf" and br.getSpellCD(129597) == 0 then
            if player.mana <= ui.value(text.utility.arcaneTorrent) then
                br._G.CastSpellByName(GetSpellInfo(129597))
                ui.debug("[AUTO - ?]: "..text.utility.arcaneTorrent)
                return true
            end
        end
        debugMessage("      Arcane Torrent End")
        -- Detox
        debugMessage("      Detox Init")
        if ui.mode.detox == 1 and cd.detox.ready() then
            for i = 1, #friends.range40 do
                local dispelUnit = friends.range40[i]
                if br.canDispel(dispelUnit.unit, spell.detox) and (br.getLineOfSight(dispelUnit.unit) and br.getDistance(dispelUnit.unit) <= 40) then
                    if cast.detox(dispelUnit.unit) then ui.debug("[AUTO - SUCCESS]: Detox") return true else ui.debug("[AUTO - FAIL]: Detox") return false end
                end
            end
        end
        debugMessage("      Detox End")
    end,

    selfDefense = function()
        -- Healing Elixir / Diffuse Magic / Dampen Harm
        if ui.checked(text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) and player.hp <= ui.value(text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) then
            if talent.healingElixir and charges.healingElixir.exists() then
                if cast.healingElixir(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return true else ui.debug("[AUTO - FAIL]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return false end
            elseif talent.diffuseMagic and cd.diffuseMagic.ready() then
                if cast.diffuseMagic(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return true else ui.debug("[AUTO - FAIL]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return false end
            elseif talent.dampenHarm and cd.dampenHarm.ready() then
                if cast.dampenHarm(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return true else ui.debug("[AUTO - FAIL]: "..text.selfDefense.healingElixirOrDiffuseMagicOrDampenHarm) return false end
            end
        end
        -- Fortifying Brew
        if ui.checked(text.selfDefense.fortifyingBrew) and player.hp <= ui.value(text.selfDefense.fortifyingBrew) and cd.fortifyingBrew.ready() then
            if cast.fortifyingBrew(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.selfDefense.fortifyingBrew) return true else ui.debug("[AUTO - FAIL]: "..text.selfDefense.fortifyingBrew) return false end
        end
        -- Leg Sweep
        if ui.checked(text.selfDefense.legSweep) and cd.legSweep.ready() then
            -- AoE
            if #enemies.range6 >= ui.value(text.selfDefense.legSweep.."1") then
                if cast.legSweep(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.selfDefense.legSweep) return true else ui.debug("[AUTO - FAIL]: "..text.selfDefense.legSweep) return false end
            end
            -- Health
            if #enemies.range6 >= 1 and player.hp <= ui.value(text.selfDefense.legSweep.."2") then
                if cast.legSweep(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.selfDefense.legSweep) return true else ui.debug("[AUTO - FAIL]: "..text.selfDefense.legSweep) return false end
            end

        end
        -- Paralysis
        if ui.useInterrupt() then
            for i = 1, #enemies.range40 do
                local thisUnit = enemies.range40[i]
                local distance = br.player.unit.distance(thisUnit)
                if br.player.unit.interruptable(thisUnit) then
                    -- Paralysis
                    if cd.paralysis.ready() and distance < 20 then
                        if cast.paralysis(thisUnit) then ui.debug("[AUTO - SUCCESS - INTERRUPT]: Paralysis") return true else ui.debug("[AUTO - FAIL - INTERRUPT]: Paralysis") return false end
                    end
                    -- Ring of Peace
                    if talent.ringOfPeace and cd.ringOfPeace.ready() and ui.checked(text.utility.ringOfPeace) then
                        if cast.ringOfPeace(thisUnit, "ground") then ui.debug("[AUTO - SUCCESS - INTERRUPT]: Ring Of Peace") return true else ui.debug("[AUTO - FAIL - INTERRUPT]: Ring Of Peace") return false end
                    end
                    -- Leg Sweep
                    if cd.legSweep.ready() and (distance < 5 or (talent.tigerTailSweep and distance < 7)) then
                        if cast.legSweep(player.unit) then ui.debug("[AUTO - SUCCESS - INTERRUPT]: Leg Sweep") return true else ui.debug("[AUTO - FAIL - INTERRUPT]: Leg Sweep") return false end
                    end
                end
            end
        end
        -- Expel Harm
        if ui.checked(text.selfDefense.expelHarm) and cd.expelHarm.ready() then
            if player.hp <= ui.value(text.selfDefense.expelHarm) then
                if cast.expelHarm(player.unit) then ui.debug("[AUTO - SUCCESS]: "..text.selfDefense.expelHarm) return true else ui.debug("[AUTO - FAIL]: "..text.selfDefense.expelHarm) return false end
            end
        end
    end,

    damage = {
        CDs = function()
            -- Touch of Death
            if ui.checked(text.damage.touchOfDeath) and cd.touchOfDeath.ready() then
                local touchOfDeathMode = ui.value(text.damage.touchOfDeath)
                for i = 1, #enemies.range5 do
                    local thisUnit = enemies.range5[i]
                    if br._G.ObjectIsFacing(player.unit, thisUnit) then
                        if touchOfDeathMode == 1 or (touchOfDeathMode == 2 and br.isBoss(thisUnit)) then
                            if unit.health(player.unit) > unit.health(thisUnit) or (br.isBoss(thisUnit) and unit.hp(thisUnit) <= 15) then
                                if cast.touchOfDeath(thisUnit) then ui.debug("[AUTO - SUCCESS]: "..text.damage.touchOfDeath) return true else ui.debug("[AUTO - FAIL]: "..text.damage.touchOfDeath) return false end
                            end
                        end
                    end
                end
            end
        end,

        AoERotation = function()
            if #enemies.range8 >= 3 then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Rising Sun Kick AoE") return true else ui.debug("[AUTO - FAIL]: Rising Sun Kick AoE") return false end
                end
                -- Spinning Crane Kick
                if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                    if cast.spinningCraneKick(player.unit) then ui.debug("[AUTO - SUCCESS]: Spinning Crane Kick AoE") return true else ui.debug("[AUTO - FAIL]: Spinning Crane Kick AoE") return false end
                end
            end
        end,

        singleTargetRotation = function()
            if dynamic.range5 ~= nil and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Rising Sun Kick ST") return true else ui.debug("[AUTO - FAIL]: Rising Sun Kick ST") return false end
                end
                -- Blackout Kick
                if cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 then
                    if cast.blackoutKick(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Blackout Kick ST") return true else ui.debug("[AUTO - FAIL]: Blackout Kick ST") return false end
                end
                -- Tiger Palm
                if cd.tigerPalm.ready() then
                    if cast.tigerPalm(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Tiger Palm ST") return true else ui.debug("[AUTO - FAIL]: Tiger Palm ST") return false end
                end
            end
        end,

        chiJiRotation = function()
            -- Enveloping Mist Chi-Ji
            if buff.invokeChiJiTheRedCrane.stack() == 3 or (totemInfo.chiJiDuration == 0 and buff.invokeChiJiTheRedCrane.stack() > 0 and not player.br.isMoving) then
                debugMessage("      Enveloping Mist - Chi-Ji Init")
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
                    if cast.envelopingMist(theUnit.unit) then ui.debug("[AUTO - SUCCESS]: "..text.heal.envelopingMist) return true else ui.debug("[AUTO - FAIL]: "..text.heal.envelopingMist) return false end
                end
                debugMessage("      Enveloping Mist - Chi-Ji End")
            end
            if totemInfo.chiJiDuration > 0 and dynamic.range5 ~= nil and friends.lowest.hp >= ui.value(text.damage.chiJiDpsThreshold) then
                -- Rising Sun Kick
                if cd.risingSunKick.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.risingSunKick(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Rising Sun Kick Chi-Ji") return true else ui.debug("[AUTO - FAIL]: Rising Sun Kick Chi-Ji") return false end
                end
                -- Blackout Kick on 3 stacks
                if cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                    if cast.blackoutKick(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Blackout Kick Chi-Ji") return true else ui.debug("[AUTO - FAIL]: Blackout Kick Chi-Ji") return false end
                end
                if #enemies.range8 >= 3 then
                    -- Tiger Palm alternate with Spinning Crane Kick
                    if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                        if cast.spinningCraneKick(player.unit) then ui.debug("[AUTO - SUCCESS]: Spinning Crane Kick Chi-Ji") return true else ui.debug("[AUTO - FAIL]: Spinning Crane Kick Chi-Ji") return false end
                    end
                else
                    -- Tiger Palm alternate with Spinning Crane Kick
                    if cd.tigerPalm.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.tigerPalm(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Tiger Palm Chi-Ji") return true else ui.debug("[AUTO - FAIL]: Tiger Palm Chi-Ji") return false end
                    end
                end
            end
        end,

        ancientTeachingOfTheMonasteryRotation = function()
            if ui.checked(text.legendary.ancientTeachingOfTheMonastery) then
                if not buff.ancientTeachingOfTheMonastery.exists() and cd.essenceFont.ready() then
                    if cast.essenceFont(player.unit) then ui.debug("[AUTO - SUCCESS]: Essence Font Ancient Teaching Of The Monastery") return true else ui.debug("[AUTO - FAIL]: Essence Font Ancient Teaching Of The Monastery") return false end
                end
                if buff.ancientTeachingOfTheMonastery.exists() and dynamic.range5 ~= nil and friends.lowest.hp >= ui.value(text.legendary.ancientTeachingOfTheMonastery) then
                    -- Rising Sun Kick
                    if cd.risingSunKick.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.risingSunKick(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Rising Sun Kick Ancient Teaching Of The Monastery") return true else ui.debug("[AUTO - FAIL]: Rising Sun Kick Ancient Teaching Of The Monastery") return false end
                    end
                    -- Blackout Kick on 3 stacks
                    if cd.blackoutKick.ready() and buff.teachingsOfTheMonastery.stack() == 3 and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                        if cast.blackoutKick(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Blackout Kick Ancient Teaching Of The Monastery") return true else ui.debug("[AUTO - FAIL]: Blackout Kick Ancient Teaching Of The Monastery") return false end
                    end
                    if #enemies.range8 >= 3 and ui.mode.dps ~= 3 then
                        -- Tiger Palm alternate with Spinning Crane Kick
                        if cd.spinningCraneKick.ready() and not cast.active.spinningCraneKick() then
                            if cast.spinningCraneKick(player.unit) then ui.debug("[AUTO - SUCCESS]: Spinning Crane Kick Ancient Teaching Of The Monastery") return true else ui.debug("[AUTO - FAIL]: Spinning Crane Kick Ancient Teaching Of The Monastery") return false end
                        end
                    else
                        -- Tiger Palm alternate with Spinning Crane Kick
                        if cd.tigerPalm.ready() and br._G.ObjectIsFacing(player.unit, dynamic.range5) then
                            if cast.tigerPalm(dynamic.range5) then ui.debug("[AUTO - SUCCESS]: Tiger Palm Ancient Teaching Of The Monastery") return true else ui.debug("[AUTO - FAIL]: Tiger Palm Ancient Teaching Of The Monastery") return false end
                        end
                    end
                end
            end
        end,



        rangedDamage = function()
            -- Crackling Jade Lightning
            if dynamic.range40 ~= nil and not player.br.isMoving and not cast.active.cracklingJadeLightning() then
                if ui.checked(text.damage.cracklingJadeLightning) and cd.cracklingJadeLightning.ready() then
                    if cast.cracklingJadeLightning(dynamic.range40) then ui.debug("[AUTO - SUCCESS]: ".. text.damage.cracklingJadeLightning) return true else ui.debug("[AUTO - FAIL]: ".. text.damage.cracklingJadeLightning) return false end
                end
            end
        end
    },

    manual = function()
        -- Chi Burst
        debugMessage("      Chi Burst Init")
        if ui.checked(text.manual.chiBurst) and ui.toggle(text.manual.chiBurst)  then
            if talent.chiBurst and cd.chiBurst.ready() then
                if cast.chiBurst(player.unit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.chiBurst) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.chiBurst) return false end
            end
        end
        debugMessage("      Chi Burst End")
        -- Roll or Chi Torpedo
        debugMessage("      Roll or Chi Torpedo Init")
        if ui.checked(text.manual.rollOrChiTorpedo) and ui.toggle(text.manual.rollOrChiTorpedo) then
            if talent.chiTorpedo and charges.chiTorpedo.exists() then
                if cast.chiTorpedo(player.unit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.rollOrChiTorpedo) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.rollOrChiTorpedo) return false end
            elseif charges.roll.exists() then
                if cast.roll(player.unit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.rollOrChiTorpedo) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.rollOrChiTorpedo) return false end
            end
        end
        debugMessage("      Roll or Chi Torpedo End")
        -- Mana Tea
        debugMessage("      Mana Tea Init")
        if ui.checked(text.manual.manaTea) and ui.toggle(text.manual.manaTea) then
            if talent.manaTea and cd.manaTea.ready() then
                if cast.manaTea() then ui.debug("[MANUAL - SUCCESS]: "..text.manual.manaTea) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.manaTea) return false end
            end
        end
        debugMessage("      Mana Tea End")
        -- Song of Chi-Ji or Ring of Peace
        debugMessage("      Song of Chi-Ji or Ring of Peace Init")
        if ui.checked(text.manual.songOfChiJiOrRingOfPeace) and ui.toggle(text.manual.songOfChiJiOrRingOfPeace) then
            if talent.ringOfPeace and cd.ringOfPeace.ready() then
                br._G.CastSpellByName(GetSpellInfo(spell.ringOfPeace),"cursor")
                ui.debug("[MANUAL - ?]: "..text.manual.songOfChiJiOrRingOfPeace)
                return true
            elseif talent.songOfChiJi and cd.songOfChiJi.ready() then
                if cast.songOfChiJi(player.unit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.songOfChiJiOrRingOfPeace) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.songOfChiJiOrRingOfPeace) return false end
            end
        end
        debugMessage("      Song of Chi-Ji or Ring of Peace End")
        -- Diffuse Magic or Dampen Harm
        debugMessage("      Diffuse Magic or Dampen Harm Init")
        if ui.checked(text.manual.diffuseMagicOrDampenHarm) and ui.toggle(text.manual.diffuseMagicOrDampenHarm) then
            if talent.diffuseMagic and cd.diffuseMagic.ready() then
                if cast.diffuseMagic() then ui.debug("[MANUAL - SUCCESS]: "..text.manual.diffuseMagicOrDampenHarm) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.diffuseMagicOrDampenHarm) return false end
            elseif talent.dampenHarm and cd.dampenHarm.ready() then
                if cast.dampenHarm() then ui.debug("[MANUAL - SUCCESS]: "..text.manual.diffuseMagicOrDampenHarm) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.diffuseMagicOrDampenHarm) return false end
            end
        end
        debugMessage("      Diffuse Magic or Dampen Harm End")
        -- Transcendence / Transfer
        debugMessage("      Transcendence / Transfer Init")
        if ui.checked(text.manual.transcendenceOrTransfer) and ui.toggle(text.manual.transcendenceOrTransfer) then
            if cd.transcendence.ready() and transcendencePosition.x == nil or not buff.transcendence.exists() then
                if cast.transcendence() then
                    transcendencePosition.x, transcendencePosition.y, transcendencePosition.z = br._G.ObjectPosition(player.unit)
                    ui.debug("[MANUAL - SUCCESS]: "..text.manual.transcendenceOrTransfer)
                    return true
                else ui.debug("[MANUAL - FAIL]: "..text.manual.transcendenceOrTransfer) return false end
            elseif cd.transcendence.ready() and br.getDistanceToObject(player.unit,transcendencePosition.x, transcendencePosition.y, transcendencePosition.z) > 40 and buff.transcendence.exists() then
                if cast.transcendence() then
                    transcendencePosition.x, transcendencePosition.y, transcendencePosition.z = br._G.ObjectPosition(player.unit)
                    ui.debug("[MANUAL - SUCCESS]: "..text.manual.transcendenceOrTransfer)
                    return true
                else ui.debug("[MANUAL - FAIL]: "..text.manual.transcendenceOrTransfer) return false end
            elseif cd.transcendenceTransfer.ready() then
                if cast.transcendenceTransfer(player.unit) then
                    transcendencePosition.x, transcendencePosition.y, transcendencePosition.z = br._G.ObjectPosition(player.unit)
                    ui.debug("[MANUAL - SUCCESS]: "..text.manual.transcendenceOrTransfer)
                    return true
                else ui.debug("[MANUAL - FAIL]: "..text.manual.transcendenceOrTransfer) return false end
            end
        end
        debugMessage("      Transcendence / Transfer End")
        -- Life Cocoon
        debugMessage("      Life Cocoon Init")
        if ui.checked(text.manual.lifeCocoon) and ui.toggle(text.manual.lifeCocoon) then
            if cd.lifeCocoon.ready() then
                local targetUnit = player.unit
                if br.GetUnitExists("mouseover") then
                    targetUnit = "mouseover"
                end
                if cast.lifeCocoon(targetUnit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.lifeCocoon) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.lifeCocoon) return false end
            end
        end
        debugMessage("      Life Cocoon End")
        -- Revival
        debugMessage("      Revival Init")
        if ui.checked(text.manual.revival) and ui.toggle(text.manual.revival) then
            if cd.revival.ready() then
                if cast.revival() then ui.debug("[MANUAL - SUCCESS]: "..text.manual.revival) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.revival) return false end
            end
        end
        debugMessage("      Revival End")
        -- Invoke Yu'lon The Jade Serpent
        debugMessage("      Invoke Yu'lon The Jade Serpent Init")
        if ui.checked(text.manual.invokeYulonTheJadeSerpent) and ui.toggle(text.manual.invokeYulonTheJadeSerpent) then
            if not talent.invokeChiJiTheRedCrane and cd.invokeYulonTheJadeSerpent.ready() then
                if cast.invokeYulonTheJadeSerpent(player.unit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.invokeYulonTheJadeSerpent) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.invokeYulonTheJadeSerpent) return false end
            end
        end
        debugMessage("      Invoke Yu'lon The Jade Serpent End")
        -- Summon Jade Serpent Statue
        debugMessage("      Summon Jade Serpent Statue Init")
        if ui.checked(text.manual.summonJadeSerpentStatue) and ui.toggle(text.manual.summonJadeSerpentStatue) then
            if not talent.invokeChiJiTheRedCrane and cd.summonJadeSerpentStatue.ready() then
                br._G.CastSpellByName(GetSpellInfo(spell.summonJadeSerpentStatue),"cursor")
                ui.debug("[MANUAL - ?]: "..text.manual.summonJadeSerpentStatue)
                return true
            end
        end
        debugMessage("      Summon Jade Serpent Statue End")
        -- Invoke Chi-Ji, the Red Crane
        debugMessage("      Invoke Chi-Ji, the Red Crane Init")
        if ui.checked(text.manual.invokeChiJiTheRedCrane) and ui.toggle(text.manual.invokeChiJiTheRedCrane) then
            if talent.invokeChiJiTheRedCrane and cd.invokeChiJiTheRedCrane.ready() then
                if cast.invokeChiJiTheRedCrane(player.unit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.invokeChiJiTheRedCrane) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.invokeChiJiTheRedCrane) return false end
            end
        end
        debugMessage("      Invoke Chi-Ji, the Red Crane End")
        -- Weapons of Order
        debugMessage("      Weapons of Order Init")
        if ui.checked(text.manual.weaponsOfOrder) and ui.toggle(text.manual.weaponsOfOrder) then
            if cd.weaponsOfOrder.ready() then
                if cast.weaponsOfOrder() then ui.debug("[MANUAL - SUCCESS]: "..text.manual.weaponsOfOrder) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.weaponsOfOrder) return false end
            end
        end
        debugMessage("      Weapons of Order End")
        -- Tiger's Lust
        debugMessage("      Tiger's Lust Init")
        if ui.checked(text.manual.tigersLust) and ui.toggle(text.manual.tigersLust) then
            if talent.tigersLust and cd.tigersLust.ready() then
                local targetUnit = player.unit
                if br.GetUnitExists("mouseover") then
                    targetUnit = "mouseover"
                end
                if cast.tigersLust(targetUnit) then ui.debug("[MANUAL - SUCCESS]: "..text.manual.tigersLust) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.tigersLust) return false end
            end
        end
        debugMessage("      Tiger's Lust End")
        -- Fortifying Brew
        debugMessage("      Fortifying Brew Init")
        if ui.checked(text.manual.fortifyingBrew) and ui.toggle(text.manual.fortifyingBrew) then
            if cd.fortifyingBrew.ready() then
                if cast.fortifyingBrew() then ui.debug("[MANUAL - SUCCESS]: "..text.manual.fortifyingBrew) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.fortifyingBrew) return false end
            end
        end
        debugMessage("      Fortifying Brew End")
        -- Leg Sweep
        debugMessage("      Leg Sweep Init")
        if ui.checked(text.manual.legSweep) and ui.toggle(text.manual.legSweep) then
            if cd.legSweep.ready() then
                if cast.legSweep() then ui.debug("[MANUAL - SUCCESS]: "..text.manual.legSweep) return true else ui.debug("[MANUAL - FAIL]: "..text.manual.legSweep) return false end
            end
        end
        debugMessage("      Leg Sweep End")
    end,

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
            elseif string.find(totemName, "Yu'lon") then
                totemInfo.yulonDuration = estimateDuration
            elseif string.find(totemName, "Chi") then
                totemInfo.chiJiDuration = estimateDuration
            end
        end
    end
end

local getDebugInfo = function()
    if labels.lowest then
        if friends.lowest then
            labels.lowest:SetText("   ".. br._G.UnitName(friends.lowest.unit) .. " at " .. br.round2(friends.lowest.hp, 2) .."%")
        end
        local tempColor = colors.red
        if friends.lowAllies.essenceFont >= ui.value(text.heal.essenceFont.."1") then
            tempColor = colors.green
        end
        labels.lowAllies.essenceFont:SetText("   Essence Font: ".. tempColor .. friends.lowAllies.essenceFont .."/".. ui.value(text.heal.essenceFont.."1") .. colors.white .. " under " .. ui.value(text.heal.essenceFont.."2") .. "%")
        tempColor = colors.red
        if friends.lowAllies.essenceFontOoc >= ui.value(text.heal.outOfCombat.essenceFont.."1") then
            tempColor = colors.green
        end
        labels.lowAllies.essenceFontOoc:SetText("   Essence Font OOC: ".. tempColor .. friends.lowAllies.essenceFontOoc .."/".. ui.value(text.heal.outOfCombat.essenceFont.."1") .. colors.white .." under " .. ui.value(text.heal.outOfCombat.essenceFont.."2").. "%")
        tempColor = colors.red
        if friends.lowAllies.revival >= ui.value(text.heal.revival.."1") then
            tempColor = colors.green
        end
        labels.lowAllies.revival:SetText("   Revival: ".. tempColor .. friends.lowAllies.revival .."/".. ui.value(text.heal.revival.."1") .. colors.white .. " under " .. ui.value(text.heal.revival.."2").. "%")
        tempColor = colors.red
        if friends.lowAllies.invokeYulonTheJadeSerpent >= ui.value(text.heal.invokeYulonTheJadeSerpent.."1") then
            tempColor = colors.green
        end
        labels.lowAllies.invokeYulonTheJadeSerpent:SetText("   Invoke Yu'lon, The Jade Serpent: ".. tempColor .. friends.lowAllies.invokeYulonTheJadeSerpent .."/".. ui.value(text.heal.invokeYulonTheJadeSerpent.."1") .. colors.white .. " under " .. ui.value(text.heal.invokeYulonTheJadeSerpent.."2").. "%")
        tempColor = colors.red
        if friends.lowAllies.invokeChiJiTheRedCrane >= ui.value(text.heal.invokeChiJiTheRedCrane.."1") then
            tempColor = colors.green
        end
        labels.lowAllies.invokeChiJiTheRedCrane:SetText("   Invoke Chi-Ji, The Red Crane: ".. tempColor .. friends.lowAllies.invokeChiJiTheRedCrane .."/".. ui.value(text.heal.invokeChiJiTheRedCrane.."1") .. colors.white .. " under " .. ui.value(text.heal.invokeChiJiTheRedCrane.."2").. "%")
        tempColor = colors.red
        if friends.lowAllies.weaponsOfOrder >= ui.value(text.heal.weaponsOfOrder.."1") then
            tempColor = colors.green
        end
        labels.lowAllies.weaponsOfOrder:SetText("   Weapons Of Order: ".. tempColor .. friends.lowAllies.weaponsOfOrder .."/".. ui.value(text.heal.weaponsOfOrder.."1") .. colors.white .. " under " .. ui.value(text.heal.weaponsOfOrder.."2").. "%")
        if dynamic.range5 then
            labels.dynamic.range5:SetText("   ".. br._G.UnitName(dynamic.range5) .. " at " .. br.round2(br.getHP(dynamic.range5), 2) .."% at 5 yards")
        else
            labels.dynamic.range5:SetText("   No dynamic target at 5 yards")
        end
        if dynamic.range40 then
            labels.dynamic.range40:SetText("   ".. br._G.UnitName(dynamic.range40) .. " at " .. br.round2(br.getHP(dynamic.range40), 2) .."% at 40 yards")
        else
            labels.dynamic.range40:SetText("   No dynamic target at 40 yards")
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
    friends.lowAllies   = {
        essenceFont                 = br.getLowAlliesInTable(br.player.ui.value(text.heal.essenceFont.."2"), friends.range30),
        essenceFontOoc              = br.getLowAlliesInTable(br.player.ui.value(text.heal.outOfCombat.essenceFont.."2") , friends.range30),
        revival                     = br.getLowAlliesInTable(br.player.ui.value(text.heal.revival.."2"), friends.range40),
        refreshingJadeWind          = br.getLowAlliesInTable(br.player.ui.value(text.heal.refreshingJadeWind.."2"), friends.range10),
        invokeYulonTheJadeSerpent   = br.getLowAlliesInTable(br.player.ui.value(text.heal.invokeYulonTheJadeSerpent.."2"), friends.range40),
        invokeChiJiTheRedCrane      = br.getLowAlliesInTable(br.player.ui.value(text.heal.invokeChiJiTheRedCrane.."2"), friends.range40),
        weaponsOfOrder              = br.getLowAlliesInTable(br.player.ui.value(text.heal.weaponsOfOrder.."2"), friends.range40)
    }
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
        debugMessage("  Manual Toggles Init")
        current = actionList.manual()
        debugMessage("  Manual Toggles End")
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

        debugMessage("  Damage Ancient Teaching Of The Monastery Rotation Init")
        current = actionList.damage.ancientTeachingOfTheMonasteryRotation()
        debugMessage("  Damage Ancient Teaching Of The Monastery Rotation End")
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
local rotationName = "LyLoLoq"
--Last: https://github.com/simulationcraft/simc/commits/legion-dev/profiles/Tier20M/Druid_Balance_T20M.simc (2ef8b68dfc130e0c2a5e33911c60936e9424ad99)
--------------
--- COLORS ---
--------------
local colorPurple   = "|cffC942FD"
local colorBlue     = "|cff00CCFF"
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"
local colorGold     = "|cffFFDD11"
local colorLegendary= "|cffff8000"
local colorBlueMage = "|cff68ccef"
local colorMarin    = "|cff04e0bf"

---------------
--- Toggles ---
---------------
local function createToggles()
    ---------------------
    -- Rotation Button --
    ---------------------
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.starfall },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 1, icon = br.player.spell.starfall },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 1, icon = br.player.spell.starsurge },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
    };
    CreateButton("Rotation",1,0)
    ---------------------
    -- Cooldown Button --
    ---------------------
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.celestialAlignment }
    };
    CreateButton("Cooldown",2,0)
    ----------------------
    -- Defensive Button --
    ----------------------
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
    };
    CreateButton("Defensive",3,0)
    ----------------------
    -- Interrupt Button --
    ----------------------
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.solarBeam },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.solarBeam }
    };
    CreateButton("Interrupt",4,0)
    -------------------------------
    -- Starfall Placement Button --
    -------------------------------
    StarfallPlacementModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Auto placement of Starfall", tip = "Auto placement of Starfall", highlight = 1, icon = br.player.spell.starfall },
        [2] = { mode = "Target", value = 2 , overlay = "Place Starfall on center of target", tip = "Place Starfall on center of target", highlight = 1, icon = br.player.spell.starfall },
        [3] = { mode = "Player", value = 2 , overlay = "Place Starfall on center of player", tip = "Place Starfall on center of player", highlight = 1, icon = br.player.spell.starfall }
    };
    CreateButton("StarfallPlacement",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local function rotationOptions()
        local section
        -----------------------
        --- General OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createSpinner(section,    "DPS Testing",          5,  1,  60,  5,                                         colorWhite.."Set to desired time for test in minuts")
        br.ui:createDropdown(section,   "Deadly Chicken",    {colorWhite.."All",colorWhite.."Don't kill boss"}, 1,      colorWhite.."Enable this mode to 1 hit mobs, select the desired mode")
        br.ui:createSpinner(section,    "Pre-Pull Timer",       5,  1,  10,  0.1,                                       colorWhite.."Set to desired time to start Pre-Pull")
        br.ui:createCheckbox(section,   "Memekin Rotation",                                                             colorWhite.."Enable the use of Memekin Rotation")
        br.ui:checkSectionState(section)
        -----------------------
        --- Setting OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "Setting")
        -- Maximum Sunfire Targets
        br.ui:createSpinnerWithout(section, colorGold.."Sunfire targets",                  5,    1,      100,  1,  colorWhite.."Maximum Sunfire targets")
        -- Maximum Moonfire Targets
        br.ui:createSpinnerWithout(section, colorGold.."Moonfire targets",                 3,    1,      100,  1,  colorWhite.."Maximum Moonfire targets")
        -- Maximum Stellar Flare Targets
        br.ui:createSpinnerWithout(section, colorGold.."Stellar Flare targets",            4,    1,      100,  1,  colorWhite.."Maximum Stellar Flare targets")
        -- Minimium Starfall Targets
        br.ui:createSpinnerWithout(section, colorGold.."Starfall targets",                 3,    1,      100,  1,  colorWhite.."Minimum starfall targets")
        -- Minimium Starfall Targets
        br.ui:createSpinnerWithout(section, colorGold.."Minimum HP to dot",                1,  0.001,  1000000,  1,  colorWhite.."Minimum HP to dot in millions")
        -- Minimium Starfall Targets
        br.ui:createSpinnerWithout(section, colorGold.."Starsurge Min Astral Power",      40,    5,      100,  5,  colorWhite.."Minimum Astral Power to use Starsurge")
        br.ui:checkSectionState(section)
        -------------------------
        --- Cooldowns OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldown")
        br.ui:createCheckbox(section, colorBlue.."Potion",                              colorWhite.."Auto use of Potion of Prolonged Power")
        br.ui:createCheckbox(section, colorBlue.."Flask",                               colorWhite.."Auto use of Flask of the Whispered Pact")
        br.ui:createCheckbox(section, colorBlue.."Augment Rune",                        colorWhite.."Auto use of Defiled Augment Rune")
        br.ui:createCheckbox(section, colorBlue.."Racial",                              colorWhite.."Auto use of Blood Fury or Berserking")
        br.ui:createCheckbox(section, colorBlue.."Incarnation/Celestial Alignament",    colorWhite.."Auto use of Incarnation or Celestial Alignament")
        br.ui:createCheckbox(section, colorBlue.."Warrior of Elune",                    colorWhite.."Auto use of Warrior of Elune")
        br.ui:createCheckbox(section, colorBlue.."Force of Nature",                     colorWhite.."Auto use of Force of Nature")
        br.ui:createCheckbox(section, colorBlue.."Astral Communion",                    colorWhite.."Auto use of Astral Communion")
        br.ui:createCheckbox(section, colorBlue.."Trinket 1",                           colorWhite.."Auto use of Trinket 1")
        br.ui:createCheckbox(section, colorBlue.."Trinket 2",                           colorWhite.."Auto use of Trinket 2")
        br.ui:checkSectionState(section)
        -------------------------
        --- Defensive OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, colorGreen.."Renewal",             25,  1,  100,  1,  colorWhite.."Health Percent to cast at")
        br.ui:createSpinner(section, colorGreen.."Swiftmend",           30,  1,  100,  1,  colorWhite.."Health Percent to cast at")
        br.ui:createSpinner(section, colorGreen.."Potion/Healthstone",  20,  1,  100,  1,  colorWhite.."Health Percent to cast at")
        br.ui:createSpinner(section, colorGreen.."Regrowth",            30,  1,  100,  1,  colorWhite.."Health Percent to cast at")
        br.ui:createSpinner(section, colorGreen.."Rejuvenation",        45,  1,  100,  1,  colorWhite.."Health Percent to cast at")
        br.ui:createSpinner(section, colorGreen.."Barkskin",            60,  1,  100,  1,  colorWhite.."Health Percent to cast at")
        br.ui:checkSectionState(section)
        -------------------------
        --- Help OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Help")
        br.ui:createDropdown(section, colorMarin.."Rebirth",                     {colorWhite.."Target",colorWhite.."Mouseover"},                      1, colorWhite.."Target to cast on")
        br.ui:createDropdown(section, colorMarin.."Remove Corruption",           {colorWhite.."Target",colorWhite.."Mouseover",colorWhite.."Player"}, 1, colorWhite.."Target to cast on")
        br.ui:createDropdown(section, colorMarin.."Innervate",                   br.dropOptions.Toggle,                                               1, colorWhite.."Set hotkey to use Innervate on "..colorRed.."Mouseover")
        br.ui:createDropdown(section, colorMarin.."Displacer Beast/Wild Charge", br.dropOptions.Toggle,                                               2, colorWhite.."Set hotkey to use Displacer Beast/Wild Charge")
        br.ui:createCheckbox(section, colorMarin.."Auto Shapeshifts",                                                                                    colorWhite.."Auto Shapeshifting to best form for situation")
        br.ui:createCheckbox(section, colorMarin.."Auto Blessing of The Ancients",                                                                       colorWhite.."Number of enemies <= 2 then Blessing of Elune else Blessing of Anshe")
        br.ui:createCheckbox(section, colorMarin.."Break Crowd Control",                                                                                 colorWhite.."Auto Shapeshifting to break crowd control")
        br.ui:checkSectionState(section)
        --------------------------
        --- Interrupts OPTIONS ---
        --------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
        br.ui:createCheckbox(section,       "Solar Beam",                       colorWhite.."Use Solar Beam")
        br.ui:createCheckbox(section,       "Mighty Bash",                      colorWhite.."Use Mighty Bash")
        br.ui:createSpinnerWithout(section, "Interrupt at", 50,  10,  95,  1,   colorWhite.."Cast Percentage to use at")
        br.ui:checkSectionState(section)
        -------------------------
        --- Legendary OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Legendary")
        br.ui:createCheckbox(section,       colorLegendary.."Emerald Dreamcatcher",                                 colorWhite.."Use Emerald Dreamcatcher Rotation")
        br.ui:createCheckbox(section,       colorLegendary.."Oneth's Intuition",                                    colorWhite.."Include use of Oneth's Intuition buffs")
        br.ui:createSpinner(section,        colorLegendary.."Promisse Of Elune, The Moon Goddness", 15, 1, 100, 1,  colorWhite.."Check to enable usage of Promisse Of Elune, The Moon Goddness, and set the number of HP to self heal")
        br.ui:createCheckbox(section,       colorLegendary.."Sephuz's Secret",                                      colorWhite.."Check to enable Sephuz's Secret usage.")
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
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    UpdateToggle("StarfallPlacement",0.25)
    br.player.mode.starfallPlacement = br.data.settings[br.selectedSpec].toggles["StarfallPlacement"]

    --------------
    --- Locals ---
    --------------
    local cast                  = br.player.cast
    local inCombat              = br.player.inCombat
    local talent                = br.player.talent
    local buff                  = br.player.buff
    local cd                    = br.player.cd
    local gcd                   = br.player.gcd
    local debuff                = br.player.debuff
    local spell                 = br.player.spell
    local charges               = br.player.charges
    local mode                  = br.player.mode
    local race                  = br.player.race
    local health                = br.player.health
    local astralPower           = br.player.power.astralPower.amount()
    local astralPowerDeficit    = br.player.power.astralPower.deficit()
    local falling               = getFallTime()
    local swimming              = IsSwimming()
    local flying                = IsFlying()
    local moving                = isMoving("player")
    local level                 = br.player.level
    local starfallRadius        = 15
    local starfallPlacement     = "playerGround"
    local racial                = br.player.getRacial()
    local pullTimer             = br.DBM:getPulltimer()
    local hpDotMin              = getValue(colorGold.."Minimum HP to dot")*1000000
    local ttd                   = getTTD
    local hasteAmount           = 1/(1+(GetHaste()/100))
    local latency               = getLatency()
    local enemies               = enemies or {}
    local friends               = friends or {}
    local travel                = br.player.buff.travelForm.exists()
    local flight                = br.player.buff.flightForm.exists()
    local chicken               = br.player.buff.moonkinForm.exists()
    local cat                   = br.player.buff.catForm.exists()
    local noform                = GetShapeshiftForm()==0
    local hastar                = GetObjectExists("target")
    local deadtar               = UnitIsDeadOrGhost("target")
    local starfallTargetsMin    = getValue(colorGold.."Starfall targets")


    enemies.activeYards40       = br.player.enemies(40,"player")
    --------------------
    -- Starfall Stuff --
    if talent.stellarDrift then starfallRadius = 15*1.3 end
    if mode.starfallPlacement == 1 then
        starfallPlacement = "best"
    elseif mode.starfallPlacement == 2 then
        starfallPlacement = "targetGround"
    end
    if isChecked("Memekin Rotation") then starfallTargetsMin = 1 end
    -- Starfall Stuff --
    --------------------

    local function castMoon(name)
        if cd.newMoon.remain() == 0 then
            local moonActive = select(3,GetSpellInfo(spell.newMoon))
            if name == "newMoon" and moonActive == 1392545 then
                if cast.newMoon() then return true end
            elseif name == "halfMoon" and moonActive == 1392543 then
                if cast.newMoon() then return true end
            elseif name == "fullMoon" and moonActive == 1392542 then
                if cast.newMoon() then return true end
            elseif name == "any" then
                if cast.newMoon() then return true end
            end
        end
        return false
    end

    local function castTimeMoon()
        local moonActive = select(3,GetSpellInfo(spell.newMoon))
        local castTime = 0
        if moonActive == 1392545 then
            castTime = getCastTime(spell.newMoon)
        elseif moonActive == 1392543 then
            castTime = getCastTime(spell.halfMoon)
        elseif moonActive == 1392542 then
            castTime = getCastTime(spell.fullMoon)
        end
        return castTime + latency
    end

    ------------------
    --- Locals END ---
    ------------------
    local function actionListSimcraftDruidBalanceT20M()
        --# Default consumables
        --potion=potion_of_prolonged_power
        local potion = 142117 -- http://www.wowhead.com/item=142117
        local potionBuff = 229206
        --flask=whispered_pact
        local flask = 127847 -- http://www.wowhead.com/item=127847
        local flaskBuff = 188031
        --food=lavish_suramar_feast
        --local food = 133579 -- http://www.wowhead.com/item=133579
        --local foodBuff = 201640
        --augmentation=defiled
        local augumentation = 140587 -- http://www.wowhead.com/item=140587
        local augumentationBuff = 224001

        local function actionsPrecombat()
            --# Executed before combat begins. Accepts non-harmful actions only.
            --actions.precombat=flask
            if not UnitBuffID("player",flaskBuff) and canUseItem(flask) and useCDs() and isChecked(colorBlue.."Flask") then
                if useItem(flask) then return true end
            end
            --TODO:actions.precombat+=/food

            --actions.precombat+=/augmentation
            if not UnitBuffID("player",augumentationBuff) and canUseItem(augumentation) and useCDs() and isChecked(colorBlue.."Augment Rune") then
                if useItem(augumentation) then return true end
            end
            ----actions.precombat+=/moonkin_form
            ----actions.precombat+=/blessing_of_elune
            --# Snapshot raid buffed stats before combat begins and pre-potting is done.
            if isChecked("Pre-Pull Timer") and pullTimer <= castTimeMoon() and not inCombat then
                --actions.precombat+=/potion
                if not UnitBuffID("player",potionBuff) and canUseItem(potion) and useCDs() and isChecked(colorBlue.."Potion") then
                    if useItem(potion) then Print("Pre-Potion Used!") return true end
                end
                --actions.precombat+=/new_moon
                if castMoon("any") then Print("Moon Spell Used!") return true end
            end
            return false
        end

        local function actionsEmeraldDreamcatcher()
            --actions.ed=astral_communion,if=astral_power.deficit>=75&buff.the_emerald_dreamcatcher.up
            if cd.astralCommunion.remain() == 0 and astralPowerDeficit >= 75 and buff.emeraldDreamcatcher.exists() and useCDs() and isChecked(colorBlue.."Astral Communion") then
                if cast.astralCommunion() then return true end
            end
            --actions.ed+=/incarnation,if=astral_power>=60|buff.bloodlust.up
            --actions.ed+=/celestial_alignment,if=astral_power>=60&!buff.the_emerald_dreamcatcher.up
            if (not talent.incarnationChoseOfElune and cd.celestialAlignment.remain() == 0 or talent.incarnationChoseOfElune and cd.incarnationChoseOfElune.remain() == 0) and astralPower >= 40 and useCDs() and isChecked(colorBlue.."Incarnation/Celestial Alignament") then
                if debuff.moonfire.exists() and debuff.sunfire.exists() then
                    if cast.celestialAlignment() then return true end
                end
            end
            --actions.ed+=/starsurge,if=(gcd.max*astral_power%26)>target.time_to_die
            if ((latency+gcd)*astralPower%26) > ttd("target") then
                if cast.starsurge() then return true end
            end
            --actions.ed+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2
            if talent.stellarFlare and UnitHealth("target") >= hpDotMin and astralPower >= 10 and debuff.stellarFlare.count() <= 4 and #enemies.activeYards40 <4 and debuff.stellarFlare.remain("target") < 7.2 then
                if cast.stellarFlare("target", "aoe") then return true end
            end
            --actions.ed+=/sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
            if UnitHealth("target") >= hpDotMin and (talent.naturesBalance and debuff.sunfire.remain("target") < 3) or (debuff.sunfire.remain("target") < 5.4 and not talent.naturesBalance) and (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd or not buff.emeraldDreamcatcher.exists()) then
                if cast.sunfire("target","aoe") then return true end
            end
            --actions.ed+=/moonfire,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
            if UnitHealth("target") >= hpDotMin and (talent.naturesBalance and debuff.moonfire.remain("target") < 3) or (debuff.moonfire.remain("target") < 6.6 and not talent.naturesBalance) and (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd or not buff.emeraldDreamcatcher.exists()) then
                if cast.moonfire("target","aoe") then return true end
            end
            --actions.ed+=/starfall,if=buff.oneths_overconfidence.up&buff.the_emerald_dreamcatcher.remains>execute_time
            if isChecked(colorLegendary.."Oneth's Intuition") and buff.onethsOverconfidence.exists() and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd+getCastTime(spell.starfall) then
                if cast.starfall(starfallPlacement, nil, 1, starfallRadius) then return true end
            end
            --actions.ed+=/new_moon,if=astral_power.deficit>=10&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=16
            if astralPowerDeficit >= 20 and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd+getCastTime(spell.newMoon) and astralPower >= 16 then
                if castMoon("newMoon") then return true end
            end
            --actions.ed+=/half_moon,if=astral_power.deficit>=20&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=6
            if astralPowerDeficit >= 20 and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd+getCastTime(spell.halfMoon) and astralPower >= 6 then
                if castMoon("newMoon") then return true end
            end
            --actions.ed+=/full_moon,if=astral_power.deficit>=40&buff.the_emerald_dreamcatcher.remains>execute_time
            if astralPowerDeficit >= 40 and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd+getCastTime(spell.fullMoon) then
                if castMoon("fullMoon") then return true end
            end
            --actions.ed+=/lunar_strike,if=(buff.lunar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=15|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=22.5))&spell_haste<0.4
            if (buff.lunarEmpowerment.exists() and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd+getCastTime(spell.lunarStrike) and (not(buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit >= 15 or (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit >= 22.5)) and hasteAmount < 0.4 then
                if cast.lunarStrike() then return true end
            end
            --actions.ed+=/solar_wrath,if=buff.solar_empowerment.stack>1&buff.the_emerald_dreamcatcher.remains>2*execute_time&astral_power>=6&(dot.moonfire.remains>5|(dot.sunfire.remains<5.4&dot.moonfire.remains>6.6))&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=10|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=15)
            if buff.solarEmpowerment.stack() > 1 and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > 2*(latency+gcd+getCastTime(spell.solarWrath)) and astralPower >= 6 and (debuff.moonfire.remain()>5 or (debuff.sunfire.remain()<5.4 and debuff.moonfire.remain()>6.6)) and (not(buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit >= 10 or (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit >= 15) then
                if cast.solarWrath() then return true end
            end
            --actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=11&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=15|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=22.5)
            if buff.lunarEmpowerment.exists() and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd+getCastTime(spell.lunarStrike) and astralPower >= 11 and (not(buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit>= 15 or (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit >= 22.5) then
                if cast.lunarStrike() then return true end
            end
            --actions.ed+=/solar_wrath,if=buff.solar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=16&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=10|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power.deficit>=15)
            if buff.solarEmpowerment.exists() and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > latency+gcd+getCastTime(spell.solarWrath) and astralPower >=16 and (not(buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit >= 10 or (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPowerDeficit >= 15) then
                if cast.solarWrath() then return true end
            end
            --actions.ed+=/starsurge,if=(buff.the_emerald_dreamcatcher.up&buff.the_emerald_dreamcatcher.remains<gcd.max)|astral_power>85|((buff.celestial_alignment.up|buff.incarnation.up)&astral_power>30)
            if (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() < latency+gcd) or astralPower > 85 or ((buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPower > 30) then
                if cast.starsurge() then return true end
            end
            --actions.ed+=/starfall,if=buff.oneths_overconfidence.up
            if isChecked(colorLegendary.."Oneth's Intuition") and  buff.onethsOverconfidence.exists() then
                if cast.starfall(starfallPlacement, nil, 1, starfallRadius) then return true end
            end
            --actions.ed+=/new_moon,if=astral_power.deficit>=10
            if astralPowerDeficit >= 10 then
                if castMoon("newMoon") then return true end
            end
            --actions.ed+=/half_moon,if=astral_power.deficit>=20
            if astralPowerDeficit >= 20 then
                if castMoon("halfMoon") then return true end
            end
            --actions.ed+=/full_moon,if=astral_power.deficit>=40
            if astralPowerDeficit >= 40 then
                if castMoon("fullMoon") then return true end
            end
            --actions.ed+=/solar_wrath,if=buff.solar_empowerment.up
            if buff.solarEmpowerment.exists() then
                if cast.solarWrath() then return true end
            end
            --actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up
            if buff.lunarEmpowerment.exists() then
                if cast.lunarStrike() then return true end
            end
            --actions.ed+=/solar_wrath
            if cast.solarWrath() then return true end
            return false
        end

        local function actionsAoE()
            --actions.AoE=starfall,if=debuff.stellar_empowerment.remains<gcd.max*2|astral_power.deficit<22.5|(buff.celestial_alignment.remains>8|buff.incarnation.remains>8)|target.time_to_die<8
            if debuff.stellarEmpowerment.remain() < (latency+gcd)*2 or astralPowerDeficit < 22.5 or ((buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() > 8) or (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() > 8)) or ttd("target") < 8 then
                if cast.starfall(starfallPlacement, nil, starfallTargetsMin, starfallRadius) then return true end
            end
            --actions.AoE+=/new_moon,if=astral_power.deficit>14
            if astralPowerDeficit > 14 and (not moving or buff.stellarDrift.exists()) then
                if castMoon("newMoon") then return true end
            end
            --actions.AoE+=/half_moon,if=astral_power.deficit>24
            if astralPowerDeficit > 24 and (not moving or buff.stellarDrift.exists()) then
                if castMoon("halfMoon") then return true end
            end
            --actions.AoE+=/full_moon,if=astral_power.deficit>44
            if astralPowerDeficit > 44 and (not moving or buff.stellarDrift.exists()) then
                if castMoon("fullMoon") then return true end
            end
            --actions.AoE+=/warrior_of_elune
            if talent.warriorOfElune and cd.warriorOfElune.remain() == 0 and isChecked(colorBlue.."Warrior of Elune") and useCDs() then
                if cast.warriorOfElune() then return true end
            end
            --actions.AoE+=/lunar_strike,if=buff.warrior_of_elune.up
            if buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists() then
                if cast.lunarStrike() then return true end
            end
            --actions.AoE+=/solar_wrath,if=buff.solar_empowerment.up
            if buff.solarEmpowerment.exists() and (not moving or buff.stellarDrift.exists()) then
                if cast.solarWrath() then return true end
            end
            --actions.AoE+=/lunar_strike,if=buff.lunar_empowerment.up
            if buff.lunarEmpowerment.exists() and (not moving or buff.stellarDrift.exists()) then
                if cast.lunarStrike() then return true end
            end
            --actions.AoE+=/lunar_strike,if=active_enemies>=4|spell_haste<0.45
            if #enemies.activeYards40 >= 4 or hasteAmount < 0.45 and (not moving or buff.stellarDrift.exists()) then
                if cast.lunarStrike() then return true end
            end
            --actions.AoE+=/solar_wrath
            if (not moving or buff.stellarDrift.exists()) then
                if cast.solarWrath() then return true end
            end
            return false
        end

        local function actionsSingleTarget()
            --actions.single_target=starsurge,if=astral_power.deficit<44|(buff.celestial_alignment.up|buff.incarnation.up|buff.astral_acceleration.up)|(gcd.max*(astral_power%40))>target.time_to_die
            if astralPowerDeficit < 44 or (buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists() or buff.astralAcceleration.exists()) or (latency+gcd*(astralPower%40)) > ttd("target") then
                if cast.starsurge() then return true end
            end
            --actions.single_target+=/new_moon,if=astral_power.deficit>14&!(buff.celestial_alignment.up|buff.incarnation.up)
            if astralPowerDeficit > 14 and not(buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists()) and (not moving or buff.stellarDrift.exists()) then
                if castMoon("newMoon") then return true end
            end
            --actions.single_target+=/half_moon,if=astral_power.deficit>24&!(buff.celestial_alignment.up|buff.incarnation.up)
            if astralPowerDeficit > 24 and not(buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists()) and (not moving or buff.stellarDrift.exists()) then
                if castMoon("halfMoon") then return true end
            end
            --actions.single_target+=/full_moon,if=astral_power.deficit>44
            if astralPowerDeficit > 44  and (not moving or buff.stellarDrift.exists()) then
                if castMoon("fullMoon") then return true end
            end
            --actions.single_target+=/warrior_of_elune
            if talent.warriorOfElune and cd.warriorOfElune.remain() == 0 and isChecked(colorBlue.."Warrior of Elune") and useCDs() then
                if cast.warriorOfElune() then return true end
            end
            --actions.single_target+=/lunar_strike,if=buff.warrior_of_elune.up
            if buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists() then
                if cast.lunarStrike() then return true end
            end
            --actions.single_target+=/solar_wrath,if=buff.solar_empowerment.up
            if buff.solarEmpowerment.exists() and (not moving or buff.stellarDrift.exists()) then
                if cast.solarWrath() then return true end
            end
            --actions.single_target+=/lunar_strike,if=buff.lunar_empowerment.up
            if buff.lunarEmpowerment.exists() and (not moving or buff.stellarDrift.exists()) then
                if cast.lunarStrike() then return true end
            end
            --actions.single_target+=/solar_wrath
            if (not moving or buff.stellarDrift.exists()) then
                if cast.solarWrath() then return true end
            end
            return false
        end

        local function actions()
            --# Executed every time the actor is available.
            --actions=potion,name=potion_of_prolonged_power,if=buff.celestial_alignment.up|buff.incarnation.up
            if (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and useCDs() and isChecked(colorBlue.."Potion") then
                if not UnitBuffID("player",potionBuff) and canUseItem(potion) then
                    if useItem(potion) then return true end
                end
            end
            if talent.blessingOfTheAncients and cd.blessingOfTheAncients.remain() == 0 and isChecked(colorMarin.."Auto Blessing of The Ancients") then
                --actions+=/blessing_of_elune,if=active_enemies<=2&talent.blessing_of_the_ancients.enabled&buff.blessing_of_elune.down
                if (mode.rotation == 3 or (mode.rotation == 1 and #enemies.activeYards40 <= 2)) and not buff.blessingOfElune.exists() then
                    if cast.blessingOfTheAncients() then return true end
                    --actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
                elseif (mode.rotation == 2 or (mode.rotation == 1 and #enemies.activeYards40 >= 3)) and not buff.blessingOfAnshe.exists() then
                    if cast.blessingOfTheAncients() then return true end
                end
            end
            --actions+=/celestial_alignment,if=astral_power>=40|incarnation,if=astral_power>=40
            if (not talent.incarnationChoseOfElune and cd.celestialAlignment.remain() == 0 or talent.incarnationChoseOfElune and cd.incarnationChoseOfElune.remain() == 0) and astralPower >= 40 and useCDs() and isChecked(colorBlue.."Incarnation/Celestial Alignament") then
                if debuff.moonfire.exists() and debuff.sunfire.exists() then
                    if cast.celestialAlignment() then return true end
                end
            end
            --actions+=/berserking|blood_fury,if=buff.celestial_alignment.up|buff.incarnation.up
            if (race == "Orc" or race == "Troll") and getSpellCD(racial) == 0 and useCDs() and isChecked(colorBlue.."Racial") then
                if buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists() then
                    if castSpell("player",racial,true,false) == true then return true end
                end
            end
            --actions+=/use_item,slot=trinket1&trinket2
            if buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists() then
                if canUseItem(13) and useCDs() and isChecked(colorBlue.."Trinket 1") then
                    if useItem(13) then return true end
                end
                if canUseItem(14) and useCDs() and isChecked(colorBlue.."Trinket 2") then
                    if useItem(14) then return true end
                end
            end
            ----actions+=/call_action_list,name=fury_of_elune,if=talent.fury_of_elune.enabled&cooldown.fury_of_elue.remains<target.time_to_die
            if (not talent.incarnationChoseOfElune and cd.celestialAlignment.remain() > 0 or talent.incarnationChoseOfElune and cd.incarnationChoseOfElune.remain() > 0) or not isBoss("target") then
                if (mode.rotation == 1 or mode.rotation == 3) and not isChecked("Memekin Rotation") then
                    ----EXTRA:starsurge
                    if astralPower >= getValue("Starsurge Min Astral Power") and #enemies.activeYards40 < starfallTargetsMin then
                        if cast.starsurge() then return true end
                    end
                end
                if mode.rotation == 1 or mode.rotation == 2 then
                    ----EXTRA:starfall
                    if (astralPower >= 60) or (astralPower >= 40 and talent.soulOfTheForest) then
                        if cast.starfall(starfallPlacement, nil, starfallTargetsMin, starfallRadius) then return true end
                    end
                end
            end
            --actions+=/call_action_list,name=ed,if=equipped.the_emerald_dreamcatcher&active_enemies<=1
            if isChecked(colorLegendary.."Emerald Dreamcatcher") then
                if actionsEmeraldDreamcatcher() then return true end
            end
            --actions+=/new_moon,if=((charges=2&recharge_time<5)|charges=3)&astral_power.deficit>14
            if ((charges.newMoon.count() == 2 and charges.newMoon.recharge() < 5) or  charges.newMoon.count() == 3) and astralPowerDeficit > 14 and (not moving or buff.stellarDrift.exists()) then
                if castMoon("newMoon") then return true end
            end
            --actions+=/half_moon,if=((charges=2&recharge_time<5)|charges=3|(target.time_to_die<15&charges=2))&astral_power.deficit>24
            if ((charges.newMoon.count() == 2 and charges.halfMoon.recharge() < 5) or  charges.newMoon.count() == 3 or (ttd("target") < 15 and charges.newMoon.count() == 2)) and astralPowerDeficit > 24  and (not moving or buff.stellarDrift.exists()) then
                if castMoon("halfMoon") then return true end
            end
            --actions+=/full_moon,if=((charges=2&recharge_time<5)|charges=3|target.time_to_die<15)&astral_power.deficit>44
            if ((charges.newMoon.count() == 2 and charges.fullMoon.recharge() < 5) or  charges.newMoon.count() == 3 or ttd("target") < 15) and astralPowerDeficit > 24 and (not moving or buff.stellarDrift.exists()) then
                if castMoon("fullMoon") then return true end
            end
            if mode.rotation == 3 or (mode.rotation == 1 and #enemies.activeYards40 == 1) then
                --actions+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2
                if talent.stellarFlare and UnitHealth("target") >= hpDotMin and astralPower>= 10 and debuff.stellarFlare.count() <= 4 and debuff.stellarFlare.remain("target") < 7.2 and (not moving or buff.stellarDrift.exists()) then
                    if cast.stellarFlare("target", "aoe") then return true end
                end
                --actions+=/sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&astral_power.deficit>7
                if UnitHealth("target") >= hpDotMin and ((talent.naturesBalance and debuff.sunfire.remain("target") < 3) or (debuff.sunfire.remain("target") < 5.4 and not talent.naturesBalance)) and astralPowerDeficit > 7 then
                    if cast.sunfire("target","aoe") then return true end
                end
                --actions+=/moonfire,cycle_targets=1,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&astral_power.deficit>7
                if UnitHealth("target") >= hpDotMin and ((talent.naturesBalance and debuff.moonfire.remain("target") < 3) or (debuff.moonfire.remain("target") < 6.6 and not talent.naturesBalance)) and astralPowerDeficit > 7 then
                    if cast.moonfire("target","aoe") then return true end
                end
            elseif mode.rotation == 1 or mode.rotation == 2 then
                for i = 1, #enemies.activeYards40 do
                    local thisUnit = enemies.activeYards40[i]
                    --actions+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2
                    if talent.stellarFlare and UnitHealth(thisUnit) >= hpDotMin and astralPower>= 10 and debuff.stellarFlare.count() <= getValue(colorGold.."Stellar Flare targets") and debuff.stellarFlare.remain(thisUnit) < 7.2 and (not moving or buff.stellarDrift.exists()) then
                        if cast.stellarFlare(thisUnit, "aoe") then return true end
                    end
                    --actions+=/sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&astral_power.deficit>7
                    if UnitHealth(thisUnit) >= hpDotMin and ((talent.naturesBalance and debuff.sunfire.remain(thisUnit) < 3) or (debuff.sunfire.remain(thisUnit) < 5.4 and not talent.naturesBalance)) and astralPowerDeficit > 7 and debuff.sunfire.count() < getValue(colorGold.."Sunfire targets") then
                        if cast.sunfire(thisUnit,"aoe") then return true end
                    end
                    --actions+=/moonfire,cycle_targets=1,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&astral_power.deficit>7
                    if UnitHealth(thisUnit) >= hpDotMin and ((talent.naturesBalance and debuff.moonfire.remain(thisUnit) < 3) or (debuff.moonfire.remain(thisUnit) < 6.6 and not talent.naturesBalance)) and astralPowerDeficit > 7 and debuff.moonfire.count() < getValue(colorGold.."Moonfire targets") then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    end
                end
            end
            --actions+=/astral_communion,if=astral_power.deficit>=71
            if talent.astralCommunion and cd.astralCommunion.remain() == 0 and astralPowerDeficit >= 71 and useCDs() and isChecked(colorBlue.."Astral Communion") then
                if cast.astralCommunion() then return true end
            end
            ----EXTRA: FORCE OF NATURE
            if talent.forceOfNature and cd.forceOfNature.remain() == 0 and isChecked(colorBlue.."Force of Nature") and useCDs() then
                if cast.forceOfNature() then return true end
            end
            --actions+=/use_item,name=tarnished_sentinel_medallion,if=cooldown.incarnation.remains>60|cooldown.celestial_alignment.remains>60
            if hasItem(147017) and (not talent.incarnationChoseOfElune and cd.celestialAlignment.remain() > 60 or talent.incarnationChoseOfElune and cd.incarnationChoseOfElune.remain() == 60) then
                if useItem(147017) then return true end
            end
            --actions+=/starfall,if=buff.oneths_overconfidence.up
            if isChecked(colorLegendary.."Oneth's Intuition") and buff.onethsOverconfidence.exists() then
                if cast.starfall(starfallPlacement, nil, 1, starfallRadius) then return true end
            end
            --actions+=/solar_wrath,if=buff.solar_empowerment.stack=3
            if buff.solarEmpowerment.stack() == 3 and (not moving or buff.stellarDrift.exists()) then
                if cast.solarWrath() then return true end
            end
            --actions+=/lunar_strike,if=buff.lunar_empowerment.stack=3
            if buff.lunarEmpowerment.stack() == 3 and (not moving or buff.stellarDrift.exists()) then
                if cast.lunarStrike() then return true end
            end
            --actions+=/starsurge,if=buff.oneths_intuition.up
            if isChecked(colorLegendary.."Oneth's Intuition") and buff.onethsIntuition.exists() then
                if cast.starsurge() then return true end
            end
            --actions+=/call_action_list,name=AoE,if=(active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3
            if mode.rotation == 1 and #enemies.activeYards40 >= starfallTargetsMin or mode.rotation == 2 or isChecked("Memekin Rotation") then
                if actionsAoE() then return true end
            end
            --actions+=/call_action_list,name=single_target
            if (mode.rotation == 1 or mode.rotation == 3) and not isChecked("Memekin Rotation") then
                if actionsSingleTarget() then return true end
            end
            ----EXTRA:
            if mode.rotation == 3 or (mode.rotation == 1 and #enemies.activeYards40 == 1) then
                if debuff.moonfire.remain("target") <= debuff.sunfire.remain("target") and isValidUnit("target") then
                    if cast.moonfire("target","aoe") then return true end
                elseif isValidUnit("target") then
                    if cast.sunfire("target","aoe") then return true end
                end
            elseif mode.rotation == 1 or mode.rotation == 2 then
                for i = 1, #enemies.activeYards40 do
                    local thisUnit = enemies.activeYards40[i]
                    if debuff.moonfire.remain(thisUnit) <= debuff.sunfire.remain(thisUnit) and isValidUnit(thisUnit) then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    elseif isValidUnit(thisUnit) then
                        if cast.sunfire(thisUnit,"aoe") then return true end
                    end
                end
            end
            return false
        end

        if actionsPrecombat() then return true end
        if inCombat then
            if actions() then return true end
        end
        return false
    end

    local function actionListDefensive()
        if inCombat then
            -- Renewal
            if cd.renewal.remain() == 0 and isChecked(colorGreen.."Renewal") and health <= getValue(colorGreen.."Renewal") then
                if cast.renewal("player") then return true end
            end
            -- Swiftmend
            if cd.swiftmend.remain() == 0 and isChecked(colorGreen.."Swiftmend") and health <= getValue(colorGreen.."Swiftmend") then
                if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                if cast.swiftmend("player") then return true end
            end
            --Potion or Stone
            if isChecked(colorGreen.."Potion/Healthstone") and health <= getValue(colorGreen.."Potion/Healthstone") then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(getHealthPot()) then
                    useItem(getHealthPot())
                end
            end
            -- Regrowth
            if isChecked(colorGreen.."Regrowth") and health <= getValue(colorGreen.."Regrowth") then
                if cast.regrowth("player") then return true end
            end
            -- Rejuvenation
            if isChecked(colorGreen.."Rejuvenation") and health <= getValue(colorGreen.."Rejuvenation") and (not buff.rejuvenation.exists() or buff.rejuvenation.remain() <= 3) then
                if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                if cast.rejuvenation("player") then return true end
            end
            -- Barkskin
            if cd.barkskin.remain() == 0 and isChecked(colorGreen.."Barkskin") and health <= getValue(colorGreen.."Barkskin") then
                if cast.barkskin() then return true end
            end
        end
        return false
    end

    local function actionListInterrupt()
        if inCombat then
            for i = 1, #enemies.activeYards40 do
                local thisUnit = enemies.activeYards40[i]
                if canInterrupt(thisUnit,getValue("Interrupt at")) then
                    -- Solar Beam
                    if cd.solarBeam.remain() == 0 and isChecked("Solar Beam") then
                        if cast.solarBeam(thisUnit) then return true end
                    end
                    -- Mighty Bash
                    if talent.mightyBash and cd.mightyBash.remain() == 0 and isChecked("Mighty Bash")  and getDistance(thisUnit) <= 10 then
                        if cast.mightyBash(thisUnit) then return true end
                    end
                end
            end
        end
        return false
    end

    local function actionListLegendary()
        if inCombat then
            -- Promisse Of Elune, The Moon Goddness
            if isChecked(colorLegendary.."Promisse Of Elune, The Moon Goddness") then
                if buff.powerOfEluneTheMoonGoddness.stack() == 20 and health <= getValue(colorLegendary.."Promisse Of Elune, The Moon Goddness") then
                    if cast.regrowth("player") then return true end
                end
            end
            --Sephuz's Secret
            if isChecked(colorLegendary.."Sephuz's Secret") then
                if SEPSEC == nil then SEPSEC = 0 end
                if buff.sephuzSecret.exists() and SEPSEC == 0 then
                    SEPSEC = GetTime()
                end
                if GetTime() - SEPSEC >= 30.000 then
                    --dispell
                    if cd.removeCorruption.remain() == 0 and canDispel("player",spell.removeCorruption) then
                        if cast.removeCorruption("player") then SEPSEC=0 return true end
                    end
                    for i = 1, #enemies.activeYards40 do
                        local thisUnit = enemies.activeYards40[i]
                        --root (instant cast)
                        if talent.massEntanglement and cd.massEntanglement.remain() == 0 and (not isBoss(thisUnit) or isDummy(thisUnit)) and getDistance(thisUnit) <= 35 then
                            if cast.massEntanglement(thisUnit) then SEPSEC=0 return true end
                        end
                        --silence
                        if cd.solarBeam.remain() == 0 and (not isBoss(thisUnit) or isDummy(thisUnit)) and getDistance(thisUnit) <= 45 and canInterrupt(thisUnit,getValue("Interrupt at"))  then
                            if cast.solarBeam(thisUnit) then SEPSEC=0 return true end
                        end
                        --stun
                        if talent.mightyBash and cd.mightyBash.remain() == 0 and getDistance(thisUnit) <= 10 then
                            if cast.mightyBash(thisUnit) then SEPSEC=0 return true end
                        end
                    end
                end
            end
        end
        return false
    end

    local function actionListHelp()
        if inCombat then
            --Rebirth
            if isChecked(colorMarin.."Rebirth") then
                if getOptionValue(colorMarin.."Rebirth" ) == 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player") then
                    if cast.rebirth("target","dead") then return true end
                end
                if getOptionValue(colorMarin.."Rebirth") == 2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player") then
                    if cast.rebirth("mouseover","dead") then return true end
                end
            end
            -- Remove Corruption
            if isChecked(colorMarin.."Remove Corruption") then
                if getOptionValue(colorMarin.."Remove Corruption") == 1 and canDispel("target",spell.removeCorruption) then
                    if cast.removeCorruption("target") then return true end
                end
                if getOptionValue(colorMarin.."Remove Corruption") == 2 and canDispel("mouseover",spell.removeCorruption) then
                    if cast.removeCorruption("mouseover") then return true end
                end
                if getOptionValue(colorMarin.."Remove Corruption") == 3 and canDispel("player",spell.removeCorruption) then
                    if cast.removeCorruption("player") then return true end
                end
            end
            --Break Crowd Control
            if isChecked(colorMarin.."Break Crowd Control") then
                if hasNoControl() then
                    if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                end
            end
            -- Innervate
            if isChecked(colorMarin.."Innervate") and (SpecificToggle(colorMarin.."Innervate") and not GetCurrentKeyBoardFocus()) and cd.innervate.remain() == 0 then
                if cast.innervate("mouseover") then return true end
            end
        end
        --Displacer Beast/Wild Charge
        if isChecked(colorMarin.."Displacer Beast/Wild Charge") and (SpecificToggle(colorMarin.."Displacer Beast/Wild Charge") and not GetCurrentKeyBoardFocus()) then
            if talent.displacerBeast and cd.displacerBeast.remain() == 0 then
                if cast.displacerBeast("player") then return true end
            elseif talent.wildCharge and cd.wildCharge.remain() == 0 and chicken then
                if cast.wildCharge("player") then return true end
            end
        end
        --Auto Shapeshifts
        if isChecked(colorMarin.."Auto Shapeshifts") then
            -- Flight Form
            if IsFlyableArea() and canFly() and not swimming and falling > 2 and level>=58 and not travel then
                if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                if cast.travelForm("player") then return true end
            end
            -- Aquatic Form
            if swimming and not travel and not hastar and not deadtar and not buff.prowl.exists() then
                if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                if cast.travelForm("player") then return true end
            end
            -- moonkinForm
            if not chicken and not IsMounted() and (not buff.dash.exists() or IsStandingTime(2,"player")) and not flying and not flight then
                -- moonkinForm when not swimming or flying or stag and not in combat
                if not inCombat and moving and not swimming and not flying and not travel and not isValidUnit("target") then
                    if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                    if cast.moonkinForm("player") then return true end
                end
                -- moonkinForm when not in combat and target selected and within 40yrds
                if not inCombat and isValidUnit("target") and getDistance("target") < 40 then
                    if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                    if cast.moonkinForm("player") then return true end
                end
                --moonkinForm when in combat and not flying
                if inCombat then
                    if GetShapeshiftForm() ~= 0 then RunMacroText("/CancelForm") end
                    if cast.moonkinForm("player") then return true end
                end
            end
        end
        return false
    end

    local function actionListGeneral()
        if isChecked("Deadly Chicken") then
            enemies.yards40       = br.player.enemies(40,"player",false)
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if getOptionValue("Deadly Chicken") == 1 then
                    if debuff.moonfire.remain(thisUnit) == 0 then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    elseif debuff.sunfire.remain(thisUnit) == 0 then
                        if cast.sunfire(thisUnit,"aoe") then return true end
                    end
                else
                    if debuff.moonfire.remain(thisUnit) == 0 and not isBoss(thisUnit) then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    end
                end
            end
        end
        return false
    end

    local function balanceRotation()
        if pause() or (GetUnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return false
        else
            if mode.defensive == 1 then if actionListDefensive() then return true end end
            if actionListLegendary() then return true end
            if mode.interrupt == 1 then if actionListInterrupt() then return true end end
            if actionListGeneral() then return true end
            if actionListHelp() then return true end
            if actionListSimcraftDruidBalanceT20M() then return true end
        end
        return false
    end

    ------------------
    --- START HERE ---
    ------------------
    if balanceRotation() then return true end
    return false
end
--local id = 102
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

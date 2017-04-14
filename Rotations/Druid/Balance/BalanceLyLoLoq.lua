local rotationName = "LyLoLoq"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.starfall },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.starfall },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.starsurge },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.celestialAlignment },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.celestialAlignment },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.celestialAlignment }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.solarBeam },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.solarBeam }
    };
    CreateButton("Interrupt",4,0)
    -- AstralPower Button
    AstralPowerModes = {
        [1] = { mode = "On", value = 1 , overlay = "Spells that uses Astral Power Enabled", tip = "Includes Spells that uses Astral Power.", highlight = 1, icon = br.player.spell.starfall },
        [2] = { mode = "Off", value = 2 , overlay = "Spells that uses Astral Power Disabled", tip = "No Spells that uses Astral Power will be used.", highlight = 0, icon = br.player.spell.starfall }
    };
    CreateButton("AstralPower",5,0)

end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Opener
        br.ui:createCheckbox(section, "Opener")
        -- Deadly Chicken
        br.ui:createCheckbox(section, "Deadly Chicken","|cff15FF00Enable|cffFFFFFF|cffFFFFFF this mode when running through low level content where you 1 hit kill mobs.")
        -- Deadly Chicken - DONT KILL BOSS
        br.ui:createCheckbox(section, "Deadly Chicken - DONT KILL BOSS","|cff15FF00Enable|cffFFFFFF to not kill bosses with Crazy Chicken")
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  0.1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Travel Shapeshifts
        br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
        -- Break Crowd Control
        br.ui:createCheckbox(section,"Break Crowd Control","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
        -- Maximum Sunfire Targets
        br.ui:createSpinnerWithout(section, "Sunfire targets",  3,  1,  100,  1,  "Maximum Sunfire targets. Min: 1 / Max: 100")
        -- Maximum Moonfire Targets
        br.ui:createSpinnerWithout(section, "Moonfire targets",  3,  1,  100,  1,  "Maximum Moonfire targets. Min: 1 / Max: 100")
        -- Maximum Stellar Flare Targets
        br.ui:createSpinnerWithout(section, "Stellar Flare targets",  4,  1,  100,  1,  "Maximum Stellar Flare targets. Min: 1 / Max: 100")
        -- Minimium Starfall Targets
        br.ui:createSpinnerWithout(section, "Starfall targets",  3,  1,  100,  1,  "Minimum starfall targets. Min: 1 / Max: 100")
        -- Minimium Starfall Targets
        br.ui:createSpinnerWithout(section, "Minimum HP to dot (in Milions)",  1,  0.1,  1000000,  1,  "Minimum starfall targets. Min: 0.1 Milion / Max: 1000000 Milion [To Raid And Party]")
        -- Displacer Beast
        br.ui:createDropdown(section, "Displacer Beast/Wild Charge", br.dropOptions.Toggle, 3, "Set hotkey to use Displacer Beast/Wild Charge-Will use only if on balance form.")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Int Pot
        br.ui:createCheckbox(section,"Potion")
        -- Flask / Crystal
        br.ui:createCheckbox(section,"Flask / Crystal")
        -- Racial
        br.ui:createCheckbox(section,"Racial")
        -- Incarnation: Chosen of Elune/Celestial Alignament
        br.ui:createCheckbox(section,"Incarnation: Chosen of Elune/Celestial Alignament")
        -- Warrior of Elune
        br.ui:createCheckbox(section,"Warrior of Elune")
        -- Force of Nature
        br.ui:createCheckbox(section,"Force of Nature")
        -- Astral Comunication
        br.ui:createCheckbox(section,"Astral Communion")
        -- Trinkets
        br.ui:createCheckbox(section,"Trinkets")
        -- Auto Blessing of The Ancients
        br.ui:createCheckbox(section,"Auto Blessing of The Ancients","Number of enemies <= 2 then Blessing of Elune else Blessing of Anshe")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Rebirth
        br.ui:createCheckbox(section,"Rebirth")
        br.ui:createDropdownWithout(section, "Rebirth - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        -- Revive
        br.ui:createCheckbox(section,"Revive")
        br.ui:createDropdownWithout(section, "Revive - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        -- Remove Corruption
        br.ui:createCheckbox(section,"Remove Corruption")
        br.ui:createDropdownWithout(section, "Remove Corruption - Target", {"|cff00FF00Player","|cffFFFF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        -- Innervate
        br.ui:createDropdown(section, "Innervate", br.dropOptions.Toggle, 3, "Set hotkey to use Innervate on |cffFF0000Mouseover.")
        br.ui:createCheckbox(section, "Announce Inervate", "Should announce on /yell innervate target?")
        -- Renewal
        br.ui:createSpinner(section, "Renewal",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Engineering: Shield-o-tronic
        br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Barkskin
        br.ui:createSpinner(section, "Barkskin",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Regrowth
        br.ui:createSpinner(section, "Regrowth",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Rejuvenation
        br.ui:createSpinner(section, "Rejuvenation",  45,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Swiftmend
        br.ui:createSpinner(section, "Swiftmend",  30,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Dream of Cenarius Auto-Heal
        br.ui:createDropdown(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  2,  "|cffFFFFFFSelect Target to Auto-Heal")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Mighty Bash
        br.ui:createDropdown(section,"Mighty Bash", br.dropOptions.Toggle, 6, "Set auto usage (No Hotkey) or desired hotkey to use Mighty Bash.")
        -- Solar Beam + Mass Entanglement
        br.ui:createCheckbox(section,"Solar Beam + Mass Entanglement", "Mass Entanglement with Solar Beam?")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt at",  50,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
    UpdateToggle("AstralPower",0.25)
    br.player.mode.astralPower = br.data.settings[br.selectedSpec].toggles["AstralPower"]

    --------------
    --- Locals ---
    --------------
    local cast                                          = br.player.cast
    local inCombat                                      = br.player.inCombat
    local talent                                        = br.player.talent
    local buff                                          = br.player.buff
    local cd                                            = br.player.cd
    local gcd                                           = br.player.gcd
    local recharge                                      = br.player.recharge
    local debuff                                        = br.player.debuff
    local spell                                         = br.player.spell
    local race                                          = br.player.race
    local health                                        = br.player.health
    local travel, flight, chicken, noform, cat          = buff.travelForm.exists(), buff.flightForm.exists(), buff.balanceForm.exists(), GetShapeshiftForm()==0, buff.catForm.exists()
    local falling, swimming, flying                     = getFallTime(), IsSwimming(), IsFlying()
    local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local astralPower                                   = br.player.power.amount.astralPower
    local multidot                                      = br.player.mode.rotation == 1 or br.player.mode.rotation == 2
    local nodps                                         = br.player.mode.rotation == 4
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.intellectBig)
    local pullTimer                                     = br.DBM:getPulltimer()
    local iconMoon                                      = select(3,GetSpellInfo(spell.newMoon))
    local useAstralPower                                = br.player.mode.astralPower == 1
    local ttd                                           = getTTD
    local hpDotMin                                      = getValue("Minimum HP to dot (in Milions)")*1000000

    local enemies                                       = enemies or {}
    local units                                         = units or {}

    enemies.yards40 = br.player.enemies(40)
    enemies.yards40 = br.player.enemies(40)


    if isChecked("Dynamic Targetting") then
        units.dyn40 = br.player.units(40)
        ttdUnit = ttd(units.dyn40)
        target = units.dyn40
    else
        ttdUnit = ttd("target")
        target = "target"
    end

    if lastForm == nil then lastForm = 0 end
    if profileStop == nil then profileStop = false end
    if opener == nil then opener = false end

    --Full Moon
    if iconMoon == 1392542 then
        activeMoon = 1
        --Half Moon
    elseif iconMoon == 1392543 then
        activeMoon = 2
        --New Moon
    else--1392545
        activeMoon = 3
    end

    if not inCombat and not GetObjectExists("target") then
        SW = false
        MM1 = false
        MF = false
        AC = false
        SF = false
        CA = false
        RA = false
        MM2 = false
        MM3 = false
        opener = false
        FON = false
        STS = false
        SW2 = false
        SP = false
        LS = false
        STS2 = false
        SW3 = false
        SW4 = false
        STS3 = false
        STS4 = false
        STS5 = false
        SW5 = false
        LS2 = false
        LS3 = false
    end
    if talent.stellarDrift then starfallRadius = 19.5 else starfallRadius = 15 end
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    end

    local function actionList_Extras()
        if isChecked("Innervate") and (SpecificToggle("Innervate") and not GetCurrentKeyBoardFocus()) and cd.innervate == 0 then
            if cast.innervate("mouseover") then
                if isChecked("Announce Inervate") then
                    SendChatMessage("Innervate casted on " .. UnitName("mouseover"), "YELL", nil, UnitName("mouseover"))
                end
                return true
            end
        end
        if isChecked("Displacer Beast/Wild Charge") and (SpecificToggle("Displacer Beast/Wild Charge") and not GetCurrentKeyBoardFocus()) then
            if talent.displacerBeast and cd.displacerBeast == 0 then
                if cast.displacerBeast() then return true end
            elseif talent.wildCharge and cd.wildCharge == 0 and chicken then
                if cast.wildCharge() then return true end
            end
        end
        if isChecked("Auto Shapeshifts") then
            -- Flight Form
            if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and br.player.level>=58 then
                if cast.travelForm() then return true end
            end
            -- Aquatic Form
            if swimming and not travel and not hastar and not deadtar and not buff.prowl.exists() then
                if cast.travelForm() then return true end
            end
            -- balanceForm
            if not chicken and not IsMounted() then
                -- balanceForm when not swimming or flying or stag and not in combat
                if not inCombat and isMoving("player") and not swimming and not flying and not travel and not isValidUnit("target") then
                    if cast.balanceForm() then return true end
                end
                -- balanceForm when not in combat and target selected and within 40yrds
                if not inCombat and isValidUnit("target") and getDistance("target") < 40 then
                    if cast.balanceForm() then return true end
                end
                --balanceForm when in combat and not flying
                if inCombat and not flying then
                    if cast.balanceForm() then return true end
                end
            end
        end
        if isChecked("DPS Testing") then
            if GetObjectExists("target") then
                if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                    StopAttack()
                    ClearTarget()
                    Print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    profileStop = true
                end
            end
        end
        return false
    end

    local function actionList_PreCombat()
        if not (flight or travel or IsMounted() or IsFlying()) and not buff.prowl.exists() then
            -- actions.precombat=flask,type=flask_of_the_whispered_pact
            if isChecked("Flask / Crystal") and not not buff.prowl.exists() then
                if inRaid and canUse(br.player.flask.wod.intellectBig) and flaskBuff==0 and not UnitBuffID("player",br.player.flask.wod.intellectBig) then
                    useItem(br.player.flask.wod.intellectBig)
                    return true
                end
                if flaskBuff==0 then
                    if not UnitBuffID("player",br.player.flask.wod.intellectBig) and canUse(118922) then --Draenor Insanity Crystal
                        useItem(118922)
                        return true
                    end
                end
            end
            --TODO:actions.precombat+=/food,type=azshari_salad
            --TODO:actions.precombat+=/augmentation,type=defiled
            --actions.precombat+=/moonkin_form
            if not chicken then
                if cast.balanceForm() then return true end
            end
            --actions.precombat+=/blessing_of_elune
            if talent.blessingOfTheAncients and isChecked("Auto Blessing of The Ancients") then
                --actions+=/blessing_of_elune,if=active_enemies<=2&talent.blessing_of_the_ancients.enabled&buff.blessing_of_elune.down
                if ((#enemies.yards40 <= 2 or not multidot) and not buff.blessingOfElune.exists())  then
                    if cast.blessingOfTheAncients() then return true end
                elseif #enemies.yards40 >= 3  and not buff.blessingOfAnshe.exists() and multidot then
                    --actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
                    if cast.blessingOfTheAncients() then return true end
                end
            end
        end
        return false
    end

    local function actionList_FuryOfElune()
        --actions.fury_of_elune=incarnation,if=astral_power>=95&cooldown.fury_of_elune.remains<=gcd
        if astralPower >= 95 and cd.furyOfElune <= gcd then
            if useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                if talent.incarnationChoseOfElune then
                    if cast.celestialAlignment() then return true end
                else
                    if cast.celestialAlignment() then return true end
                end
            end
            --actions.fury_of_elune+=/fury_of_elune,if=astral_power>=95
            if cast.furyOfElune("best", nil, 3) then return true end
        end
        --actions.fury_of_elune+=/new_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=90))
        if activeMoon == 3 and ttdUnit*2 >= getCastTime(spell.newMoon) then
            if ((getCharges(spell.newMoon) == 2 and recharge.newMoon < 5) or getCharges(spell.newMoon) == 3) and (buff.furyOfElune.exists() or (cd.furyOfElune > gcd*3 and astralPower <= 90)) then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 2 and ttdUnit*2 >= getCastTime(spell.halfMoon) then
            --actions.fury_of_elune+=/half_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=80))
            if (getCharges(spell.newMoon) == 2 and recharge.newMoon < 5) or (getCharges(spell.newMoon) == 3) and (buff.furyOfElune.exists() or (cd.furyOfElune > gcd*3 and astralPower <= 80)) then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 1 and ttdUnit*2 >= getCastTime(spell.fullMoon) then
            --actions.fury_of_elune+=/full_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=60))
            if (getCharges(spell.newMoon) == 2 and recharge.newMoon < 5) or(getCharges(spell.newMoon) == 3) and (buff.furyOfElune.exists() or (cd.furyOfElune > gcd*3 and astralPower <= 60)) then
                if cast.newMoon() then return true end
            end
        end
        --actions.fury_of_elune+=/astral_communion,if=buff.fury_of_elune_up.up&astral_power<=25
        if useCDs() and isChecked("Astral Communion") then
            if talent.astralCommunion and buff.furyOfElune.exists() and astralPower <= 25 then
                if cast.astralCommunion() then return true end
            end
        end
        --actions.fury_of_elune+=/warrior_of_elune,if=buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.up)
        if useCDs() and isChecked("Warrior of Elune") then
            if talent.warriorOfElune and (buff.furyOfElune.exists() or cd.furyOfElune >= 35 and buff.lunarEmpowerment.exists()) then
                if cast.warriorOfElune() then return true end
            end
        end
        --actions.fury_of_elune+=/lunar_strike,if=buff.warrior_of_elune.up&(astral_power<=90|(astral_power<=85&buff.incarnation.up))
        if buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists() and (astralPower <= 90 or buff.incarnationChoseOfElune.exists()) then
            if cast.lunarStrike() then return true end
        end
        --actions.fury_of_elune+=/new_moon,if=astral_power<=90&buff.fury_of_elune_up.up
        if activeMoon == 3 and ttdUnit*2 >= getCastTime(spell.newMoon) then
            if astralPower <= 90 and buff.furyOfElune.exists() then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 2 and ttdUnit*2 >= getCastTime(spell.halfMoon) then
            --actions.fury_of_elune+=/half_moon,if=astral_power<=80&buff.fury_of_elune_up.up&astral_power>cast_time*12
            if astralPower <= 80 and buff.furyOfElune.exists() and astralPower > getCastTime(spell.newMoon)*12 then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 1 and ttdUnit*2 >= getCastTime(spell.fullMoon) then
            --actions.fury_of_elune+=/full_moon,if=astral_power<=60&buff.fury_of_elune_up.up&astral_power>cast_time*12
            if astralPower <= 60 and buff.furyOfElune.exists() and astralPower > getCastTime(spell.newMoon)*12 then
                if cast.newMoon() then return true end
            end
        end
        if useAstralPower then
            if buff.onethsOverconfidence.exists() then
                if cast.starfall("best", nil, 1, starfallRadius) then return true end
            elseif buff.onethsIntuition.exists() then
                if cast.starsurge() then return true end
            end
            if multidot then
                --actions.fury_of_elune+=/starfall,if=(active_enemies>=2&talent.stellar_flare.enabled|active_enemies>=3)&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>10
                if not buff.furyOfElune.exists() and cd.furyOfElune > 10 then
                    if (astralPower >= 60) or (astralPower >= 40 and talent.soulOfTheForest) then
                        if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then return true elseif cast.starsurge() then return true end
                    end
                end
                --actions.fury_of_elune+=/starsurge,if=buff.fury_of_elune_up.down&((astral_power>=92&cooldown.fury_of_elune.remains>gcd*3)|(cooldown.warrior_of_elune.remains<=5&cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.stack<2))
                if not buff.furyOfElune.exists() and ((astralPower >= 92 and cd.furyOfElune > gcd*3) or (cd.warriorOfElune <=5 and cd.furyOfElune>=35 and buff.lunarEmpowerment.stack() < 2 ))  then
                    if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then return true elseif cast.starsurge() then return true end
                end
            else
                --actions.fury_of_elune+=/starsurge,if=active_enemies<=2&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>7
                if (not buff.furyOfElune.exists() and cd.furyOfElune > 7)  then
                    if (#enemies.yards40 <= 2) or not multidot then
                        if cast.starsurge() then return true end
                    end
                end
                --actions.fury_of_elune+=/starsurge,if=buff.fury_of_elune_up.down&((astral_power>=92&cooldown.fury_of_elune.remains>gcd*3)|(cooldown.warrior_of_elune.remains<=5&cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.stack<2))
                if not buff.furyOfElune.exists() and ((astralPower >= 92 and cd.furyOfElune > gcd*3) or (cd.warriorOfElune <=5 and cd.furyOfElune>=35 and buff.lunarEmpowerment.stack() < 2 ))   then
                    if cast.starsurge() then return true end
                end
            end
        end
        if multidot then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                --actions.fury_of_elune+=/moonfire,if=buff.fury_of_elune_up.down&remains<=6.6
                if not buff.furyOfElune.exists() and debuff.moonfire.remain(thisUnit) <= 6.6 and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    if debuff.moonfire.remain(thisUnit) < gcd and (debuff.moonfire.count() < getValue("Moonfire targets")) and isValidUnit(thisUnit) then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    end
                end
                --actions.fury_of_elune+=/sunfire,if=buff.fury_of_elune_up.down&remains<5.4
                if not buff.furyOfElune.exists() and debuff.sunfire.remain(thisUnit) <= 5.4 and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    if debuff.sunfire.remain(thisUnit) < gcd and (debuff.sunfire.count() < getValue("Sunfire targets")) and isValidUnit(thisUnit) then
                        if cast.sunfire(thisUnit,"aoe") then return true end
                    end
                end
            end
        else
            if not buff.furyOfElune.exists() and debuff.moonfire.remain() <= 6.6 and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if debuff.moonfire.remain() < gcd and (debuff.moonfire.count() < getValue("Moonfire targets")) then
                    if cast.moonfire(target ,"aoe") then return true end
                end
            end
            --actions.fury_of_elune+=/sunfire,if=buff.fury_of_elune_up.down&remains<5.4
            if not buff.furyOfElune.exists() and debuff.sunfire.remain() <= 5.4 and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if debuff.sunfire.remain() < gcd and (debuff.sunfire.count() < getValue("Sunfire targets"))  then
                    if cast.sunfire(target ,"aoe") then return true end
                end
            end
        end

        --force of natur
        if useCDs() and isChecked("Force of Nature") then
            if talent.forceOfNature then
                if cast.forceOfNature(target,"best", 1, 8) then return true  end
            end
        end

        --actions.fury_of_elune+=/stellar_flare,if=remains<7.2&active_enemies=1
        if talent.stellarFlare and astralPower >= 10 and debuff.stellarFlare.remain() < 7.2 and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
            if debuff.stellarFlare.remain() < gcd and (debuff.stellarFlare.count() < getValue("Stellar Flare targets")) then
                if cast.stellarFlare(target ,"aoe") then return true end
            end
        end
        --actions.fury_of_elune+=/solar_wrath,if=buff.solar_empowerment.up
        if buff.solarEmpowerment.exists() then
            if buff.owlkinFrenzy.exists() then
                if cast.lunarStrike() then return true end
            else
                if cast.solarWrath() then return true end
            end
        end
        --actions.fury_of_elune+=/lunar_strike,if=buff.lunar_empowerment.stack=3|(buff.lunar_empowerment.remains<5&buff.lunar_empowerment.up)|active_enemies>=2
        if buff.lunarEmpowerment.stack() == 3 or (buff.lunarEmpowerment.remain() < 5 and buff.lunarEmpowerment.exists()) or #getEnemies(target,5)>=2 then
            if cast.lunarStrike() then return true end
        end
        --actions.fury_of_elune+=/solar_wrath
        if buff.owlkinFrenzy.exists() then
            if cast.lunarStrike() then return true end
        else
            if cast.solarWrath() then return true end
        end
        return true
    end

    local function actionList_EmeralDreamcatcher()
        local function getExecuteTime(spellID)
            if getCastTime(spellID) > gcd then
                return getCastTime(spellID)
            else
                return gcd
            end
        end
        --extra
        if useAstralPower then
            if multidot then
                --if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
                if (astralPower >= 60) or (astralPower >= 40 and talent.soulOfTheForest) or buff.onethsOverconfidence.exists() then
                    if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then return true end
                end
            end
        end
        --astral_communion,if=astral_power.deficit>=75&buff.the_emerald_dreamcatcher.up
        if talent.astralCommunion and astralPower <= 25 and buff.emeraldDreamcatcher.exists() and useCDs() and isChecked("Astral Communion") then
            if cast.astralCommunion() then return true end
        end
        if useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
            --incarnation		  ,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up|buff.bloodlust.up
            --celestial_alignment,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up
            if astralPower >= 85 and not buff.emeraldDreamcatcher.exists() or buff.bloodlust.exists() then
                if cast.celestialAlignment() then return true end
            end
        end
        if useAstralPower then
            --starsurge,if=(buff.celestial_alignment.up&buff.celestial_alignment.remains<(10))|(buff.incarnation.up&buff.incarnation.remains<(3*execute_time)&astral_power>78)|(buff.incarnation.up&buff.incarnation.remains<(2*execute_time)&astral_power>52)|(buff.incarnation.up&buff.incarnation.remains<execute_time&astral_power>26)
            if buff.celestialAlignment.exists() and buff.celestialAlignment.remain() < 10 or
                    (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() < (3*getExecuteTime(spell.starsurge)) and astralPower>78) or
                    (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() < (2*getExecuteTime(spell.starsurge)) and astralPower>52) or
                    (buff.celestialAlignment.exists() and buff.celestialAlignment.remain() < getExecuteTime(spell.starsurge) and astralPower>26) then
                if cast.starsurge() then return true end
            end
            if buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() < 10 or
                    (buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() < (3*getExecuteTime(spell.starsurge)) and astralPower>78) or
                    (buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() < (2*getExecuteTime(spell.starsurge)) and astralPower>52) or
                    (buff.incarnationChoseOfElune.exists() and buff.incarnationChoseOfElune.remain() < getExecuteTime(spell.starsurge) and astralPower>26) then
                if cast.starsurge() then return true end
            end
        end
        if multidot then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if debuff.stellarFlare.count() <= 4 and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    --stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
                    if talent.stellarFlare  and astralPower >= 15 and debuff.stellarFlare.remain(thisUnit) < 7.2 then
                        if cast.stellarFlare(thisUnit,"aoe") then return true end
                    end
                end
                if debuff.moonfire.count() <= getValue("Moonfire targets") and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    --moonfire,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                    if (talent.naturesBalance and debuff.moonfire.remain(thisUnit) < 3) or (debuff.moonfire.remain(thisUnit) < 6.6 and not talent.naturesBalance) and
                            (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > gcd or not buff.emeraldDreamcatcher.exists()) then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    end
                end
                if debuff.sunfire.count() <= getValue("Sunfire targets") and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    --sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                    if (talent.naturesBalance and debuff.sunfire.remain(thisUnit) < 3) or (debuff.sunfire.remain(thisUnit) < 5.4 and not talent.naturesBalance) and
                            (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > gcd or not buff.emeraldDreamcatcher.exists()) then
                        if cast.sunfire(thisUnit,"aoe") then return true end
                    end
                end
            end
        else
            if debuff.stellarFlare.count() <= 1 and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                --stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
                if talent.stellarFlare  and astralPower >= 15 and debuff.stellarFlare.remain(target) < 7.2 then
                    if cast.stellarFlare(target,"aoe") then return true end
                end
            end
            if debuff.moonfire.count() <= 1 and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                --moonfire,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                if (talent.naturesBalance and debuff.moonfire.remain(target) < 3) or (debuff.moonfire.remain(target) < 6.6 and not talent.naturesBalance) and
                        (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > gcd or not buff.emeraldDreamcatcher.exists()) then
                    if cast.moonfire(target,"aoe") then return true end
                end
            end
            if debuff.sunfire.count() <= 1 and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                --sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                if (talent.naturesBalance and debuff.sunfire.remain(target) < 3) or (debuff.sunfire.remain(target) < 5.4 and not talent.naturesBalance) and
                        (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > gcd or not buff.emeraldDreamcatcher.exists()) then
                    if cast.sunfire(target,"aoe") then return true end
                end
            end
        end
        --starfall,if=buff.oneths_overconfidence.up&buff.the_emerald_dreamcatcher.remains>execute_time&remains<2
        if useAstralPower then
            if buff.onethsOverconfidence.exists() and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > getExecuteTime(spell.starfall) then
                if cast.starfall("best", nil, 1, starfallRadius) then return true end
            end
        end
        --half_moon,if=astral_power<=80&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=6
        if activeMoon == 2 and ttdUnit*2 >= getCastTime(spell.halfMoon) then
            if astralPower <= 80 and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > getExecuteTime(spell.halfMoon) and astralPower >= 6 then
                if cast.newMoon() then return true end
            end
        end
        --full_moon,if=astral_power<=60&buff.the_emerald_dreamcatcher.remains>execute_time
        if activeMoon == 1 and ttdUnit*2 >= getCastTime(spell.fullMoon) then
            if astralPower <= 60 and buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() > getExecuteTime(spell.fullMoon) then
                if cast.newMoon() then return true end
            end
        end
        --solar_wrath,if=buff.solar_empowerment.stack>1&buff.the_emerald_dreamcatcher.remains>2*execute_time&astral_power>=6&(dot.moonfire.remains>5|(dot.sunfire.remains<5.4&dot.moonfire.remains>6.6))&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
        if buff.solarEmpowerment.stack() > 1 and buff.emeraldDreamcatcher.remain() > 2*getExecuteTime(spell.solarWrath) and astralPower >=6 and
                (debuff.moonfire.remain()>5 or debuff.sunfire.remain()<5.4 and debuff.moonfire.remain()>6.6) and
                (not(buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists())
                        and astralPower <=90 or (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPower<=85) then
            if buff.owlkinFrenzy.exists() then
                if cast.lunarStrike() then return true end
            else
                if cast.solarWrath() then return true end
            end
        end
        --lunar_strike,if=buff.lunar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=11&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=77.5)
        if buff.lunarEmpowerment.exists() and buff.emeraldDreamcatcher.remain() > getExecuteTime(spell.lunarStrike) and astralPower >=11 and
                (not(buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPower <=85 or
                        (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPower<= 77.5) or buff.owlkinFrenzy.exists() then
            if cast.lunarStrike() then return true end
        end
        --solar_wrath,if=buff.solar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=16&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
        if buff.solarEmpowerment.exists() and buff.emeraldDreamcatcher.remain() > getExecuteTime(spell.solarWrath) and astralPower >=16 and
                (not(buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPower<=90 or
                        (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPower<= 85) then
            if cast.solarWrath() then return true end
        end
        --starsurge,if=(buff.the_emerald_dreamcatcher.up&buff.the_emerald_dreamcatcher.remains<gcd.max)|astral_power>90|((buff.celestial_alignment.up|buff.incarnation.up)&astral_power>=85)|(buff.the_emerald_dreamcatcher.up&astral_power>=77.5&(buff.celestial_alignment.up|buff.incarnation.up))
        if useAstralPower then
            if (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() < 1) or astralPower > 90 or
                    ((buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) and astralPower >= 85) or
                    (buff.emeraldDreamcatcher.exists() and buff.emeraldDreamcatcher.remain() < 1 and astralPower >=77.5 and (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists())) then
                if cast.starsurge() then return true end
            end
        end
        --starfall,if=buff.oneths_overconfidence.up&remains<2
        if useAstralPower then
            if buff.onethsOverconfidence.exists() then
                if cast.starfall("best", nil, 1, starfallRadius) then return true end
            end
        end
        --new_moon,if=astral_power<=90
        if activeMoon == 3 and ttdUnit*2 >= getCastTime(spell.newMoon) then
            if astralPower <= 90 then
                if cast.newMoon() then return true end
            end
        end
        --half_moon,if=astral_power<=80
        if activeMoon == 2 and ttdUnit*2 >= getCastTime(spell.halfMoon) then
            if astralPower <= 80 then
                if cast.newMoon() then return true end
            end
        end
        --full_moon,if=astral_power<=60&((cooldown.incarnation.remains>65&cooldown.full_moon.charges>0)|(cooldown.incarnation.remains>50&cooldown.full_moon.charges>1)|(cooldown.incarnation.remains>25&cooldown.full_moon.charges>2))
        if activeMoon == 1 and ttdUnit*2 >= getCastTime(spell.fullMoon) then
            if (buff.emeraldDreamcatcher.remain() > getExecuteTime(spell.fullMoon)) or not buff.emeraldDreamcatcher.exists() then
                if astralPower <= 60 and ((cd.celestialAlignment > 65 and getCharges(spell.fullMoon) > 0) or
                        (cd.celestialAlignment > 50 and getCharges(spell.fullMoon) > 1) or
                        (cd.celestialAlignment > 25 and getCharges(spell.fullMoon) > 2)) then
                    if cast.newMoon() then return true end
                end
            end
        end
        --extra
        if buff.owlkinFrenzy.exists() then
            if cast.lunarStrike() then return true end
        end
        --solar_wrath,if=buff.solar_empowerment.up
        if buff.solarEmpowerment.exists() then
            if cast.solarWrath() then return true end
        end
        --lunar_strike,if=buff.lunar_empowerment.up
        if buff.lunarEmpowerment.exists() then
            if cast.lunarStrike() then return true end
        end
        --solar_wrath
        if cast.solarWrath() then return true end
        return true
    end

    local function actionList_CelestialAlignmentPhase()
        if useAstralPower then
            if buff.onethsOverconfidence.exists() then
                if cast.starfall("best", nil, 1, starfallRadius) then return true end
            elseif buff.onethsIntuition.exists() then
                if cast.starsurge() then return true end
            end
            if multidot then
                --if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
                if (astralPower >= 60) or (astralPower >= 40 and talent.soulOfTheForest)  then
                    if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then return true elseif cast.starsurge() then return true end
                end
            else
                --actions.celestial_alignment_phase+=/starsurge,if=active_enemies<=2
                if (#enemies.yards40 <= 2 or not multidot) and astralPower >= 40  then
                    if cast.starsurge() then return true end
                end
            end
        end
        --actions.celestial_alignment_phase+=/warrior_of_elune
        if useCDs()  and isChecked("Warrior of Elune") then
            if talent.warriorOfElune then
                if cast.warriorOfElune() then return true end
            end
        end
        --actions.celestial_alignment_phase+=/lunar_strike,if=buff.warrior_of_elune.up
        if buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists() then
            if cast.lunarStrike() then return true end
        end
        --actions.celestial_alignment_phase+=/solar_wrath,if=buff.solar_empowerment.up
        if buff.solarEmpowerment.exists() then
            if cast.solarWrath() then return true end
        end
        --actions.celestial_alignment_phase+=/lunar_strike,if=buff.lunar_empowerment.up
        if buff.lunarEmpowerment.exists() then
            if cast.lunarStrike() then return true end
        end
        --actions.celestial_alignment_phase+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
        if talent.naturesBalance and debuff.sunfire.remain() < 5 and getCastTime(spell.sunfire) < debuff.sunfire.remain() then
            if cast.solarWrath() then return true end
        end
        --actions.celestial_alignment_phase+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
        if (talent.naturesBalance and debuff.moonfire.remain() < 5 and getCastTime(spell.moonfire) < debuff.moonfire.remain()) or #getEnemies(target,5) >= 2 then
            if cast.lunarStrike() then return true end
        end
        --actions.celestial_alignment_phase+=/solar_wrath
        if buff.owlkinFrenzy.exists() or #getEnemies(target,5)>=2 then
            if cast.lunarStrike() then return true end
        else
            if cast.solarWrath() then return true end
        end
        return true
    end

    local function actionList_SingleTarget()
        if useAstralPower then
            if buff.onethsOverconfidence.exists() then
                if cast.starfall("best", nil, 1, starfallRadius) then return true end
            elseif buff.onethsIntuition.exists() then
                if cast.starsurge() then return true end
            end
            if multidot then
                if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then return true end
            else
                if cast.starsurge() then return true end
            end
        end
        --actions.single_target=new_moon,if=astral_power<=90
        if activeMoon == 3 and ttdUnit*2 >= getCastTime(spell.newMoon) then
            if astralPower <= 90 then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 2 and ttdUnit*2 >= getCastTime(spell.halfMoon) then
            --actions.single_target+=/half_moon,if=astral_power<=80
            if astralPower <= 80 then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 1 and ttdUnit*2 >= getCastTime(spell.fullMoon) then
            --actions.single_target+=/full_moon,if=astral_power<=60
            if astralPower <= 60 then
                if cast.newMoon() then return true end
            end
        end
        --actions.single_target+=/warrior_of_elune
        if useCDs() and isChecked("Warrior of Elune") then
            if talent.warriorOfElune then
                if cast.warriorOfElune() then return true end
            end
        end
        --actions.single_target+=/lunar_strike,if=buff.warrior_of_elune.up
        if buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists() then
            if cast.lunarStrike() then return true end
        end
        --actions.single_target+=/solar_wrath,if=buff.solar_empowerment.up
        if buff.solarEmpowerment.exists() then
            if buff.owlkinFrenzy.exists() then
                if cast.lunarStrike() then return true end
            else
                if cast.solarWrath() then return true end
            end
        end
        --actions.single_target+=/lunar_strike,if=buff.lunar_empowerment.up
        if buff.lunarEmpowerment.exists() then
            if cast.lunarStrike() then return true end
        end
        --actions.single_target+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
        if talent.naturesBalance and debuff.sunfire.remain() < 5 and getCastTime(spell.sunfire) < debuff.sunfire.remain() then
            if buff.owlkinFrenzy.exists() then
                if cast.lunarStrike() then return true end
            else
                if cast.solarWrath() then return true end
            end
        end
        --actions.single_target+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
        if (talent.naturesBalance and debuff.moonfire.remain() < 5 and getCastTime(spell.moonfire) < debuff.moonfire.remain()) or #getEnemies(target,5) >= 2 then
            if cast.lunarStrike() then return true end
        end
        --actions.single_target+=/solar_wrath
        if buff.owlkinFrenzy.exists() or #getEnemies(target,5)>=2 then
            if cast.lunarStrike() then return true end
        else
            if cast.solarWrath() then return true end
        end
        return false
    end

    local function actionList_SomeCDS()
        --actions+=/blood_fury,if=buff.celestial_alignment.up|buff.incarnation.up
        --actions+=/berserking,if=buff.celestial_alignment.up|buff.incarnation.up
        if (race == "Orc" or race == "Troll") and getSpellCD(br.player.getRacial()) == 0 and useCDs()  and isChecked("Racial")  then
            if buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists() then
                if br.player.castRacial() then return true end
            end
        end
        --force of natur
        if useCDs() and isChecked("Force of Nature") then
            if talent.forceOfNature then
                if cast.forceOfNature(target,"best", 1, 8) then return true  end
            end
        end

        --actions+=/astral_communion,if=astral_power.deficit>=75
        if useCDs()  and isChecked("Astral Communion") then
            if talent.astralCommunion and astralPower <= 25 then
                if cast.astralCommunion() then return true end
            end
        end
        --actions+=/incarnation,if=astral_power>=40
        if useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
            if talent.incarnationChoseOfElune and astralPower >= 40 and cd.incarnationChoseOfElune == 0 then
                if cast.celestialAlignment() then return true end
            end
            --actions+=/celestial_alignment,if=astral_power>=40
            if not talent.incarnationChoseOfElune and astralPower >= 40 and cd.celestialAlignment == 0  then
                if cast.celestialAlignment() then return true end
            end
        end
        if useCDs() and isChecked("Trinkets") then
            if buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists() then
                if canUse(13) then
                    useItem(13)
                    return true
                end
                if canUse(14) then
                    useItem(14)
                    return true
                end
            end
        end
        if useCDs() and isChecked("Potion") and canUse(127843) and (inRaid or inInstance) then
            if buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists() then
                useItem(127843)
                return true
            end
        end

        return false
    end

    local function actionList_Combat()
        if actionList_SomeCDS() then return true end

        --TODO:actions=potion,name=deadly_grace,if=buff.celestial_alignment.up|buff.incarnation.up
        if talent.blessingOfTheAncients and isChecked("Auto Blessing of The Ancients") then
            --actions+=/blessing_of_elune,if=active_enemies<=2&talent.blessing_of_the_ancients.enabled&buff.blessing_of_elune.down
            if ((#enemies.yards40 <= 2 or not multidot) and not buff.blessingOfElune.exists())  then
                if cast.blessingOfTheAncients() then return true end
            elseif #enemies.yards40 >= 3  and not buff.blessingOfAnshe.exists() and multidot then
                --actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
                if cast.blessingOfTheAncients() then return true end
            end
        end

        --actions+=/call_action_list,name=fury_of_elune,if=talent.fury_of_elune.enabled&cooldown.fury_of_elue.remains<target.time_to_die
        if talent.furyOfElune then
            if cd.furyOfElune < ttdUnit*2 then
                if actionList_FuryOfElune() then return true end
            end
        end
        --actions+=/call_action_list,name=ed,if=equipped.the_emerald_dreamcatcher&active_enemies<=2
        if hasEquiped(137062) then
            if actionList_EmeralDreamcatcher() then return true end
        end
        if useAstralPower then
            --actions+=/starfall,if=buff.oneths_overconfidence.up
            if buff.onethsOverconfidence.exists() then
                if cast.starfall("best", nil, 1, starfallRadius) then return true end
            elseif buff.onethsIntuition.exists() then
                if cast.starsurge() then return true end
            end
            --if buff.onethsOverconfidence.exists() then
            if multidot then
                if (astralPower >= 60) or (astralPower >= 40 and talent.soulOfTheForest)  then
                    if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then return true elseif cast.starsurge() then return true end
                end
            elseif astralPower >= 40  then
                if cast.starsurge() then return true end
            end
            --end
        end
        --actions+=/new_moon,if=(charges=2&recharge_time<5)|charges=3
        if activeMoon == 3 and ttdUnit*2 >= getCastTime(spell.newMoon) then
            if (getCharges(spell.newMoon) == 2 and recharge.newMoon < 5) or getCharges(spell.newMoon) == 3 then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 2 and ttdUnit*2 >= getCastTime(spell.halfMoon) then
            --actions+=/half_moon,if=(charges=2&recharge_time<5)|charges=3|(target.time_to_die<15&charges=2)
            if (getCharges(spell.newMoon) == 2 and recharge.newMoon < 5) or (getCharges(spell.newMoon) == 3) or (ttdUnit<15 and getCharges(spell.newMoon) == 2) then
                if cast.newMoon() then return true end
            end
        end
        if activeMoon == 1 and ttdUnit*2 >= getCastTime(spell.fullMoon) then
            --actions+=/full_moon,if=(charges=2&recharge_time<5)|charges=3|target.time_to_die<15
            if (getCharges(spell.newMoon) == 2 and recharge.newMoon < 5) or(getCharges(spell.newMoon) == 3) or (ttdUnit<15 and getCharges(spell.newMoon) == 2) then
                if cast.newMoon() then return true end
            end
        end
        if multidot then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                --actions+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
                if debuff.stellarFlare.count() <= getValue("Stellar Flare targets") and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    if talent.stellarFlare and astralPower >= 15 and debuff.stellarFlare.remain(thisUnit) < 7.2 and isValidUnit(thisUnit) then
                        if cast.stellarFlare(thisUnit, "aoe") then return true end
                    end
                end
                --actions+=/moonfire,cycle_targets=1,if=(talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled)
                if (talent.naturesBalance and debuff.moonfire.remain(thisUnit) < 3) or (debuff.moonfire.remain(thisUnit) < 6.6 and not talent.naturesBalance) and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    if debuff.moonfire.remain(thisUnit) < gcd  and (debuff.moonfire.count() < getValue("Moonfire targets")) and isValidUnit(thisUnit) then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    end
                end
                --actions+=/sunfire,if=(talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled)
                if (talent.naturesBalance and debuff.sunfire.remain(thisUnit) < 3) or (debuff.sunfire.remain(thisUnit) < 5.4 and not talent.naturesBalance) and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    if debuff.sunfire.remain(thisUnit) < gcd and (debuff.sunfire.count() < getValue("Sunfire targets")) and isValidUnit(thisUnit) then
                        if cast.sunfire(thisUnit,"aoe") then return true end
                    end
                end
            end
        else
            if talent.stellarFlare and astralPower >= 15 and debuff.stellarFlare.remain() < 7.2 and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if debuff.stellarFlare.remain() < gcd and (debuff.stellarFlare.count() < getValue("Stellar Flare targets")) then
                    if cast.stellarFlare(target ,"aoe") then return true end
                end
            end
            if (talent.naturesBalance and debuff.moonfire.remain() < 3) or (debuff.moonfire.remain() < 6.6 and not talent.naturesBalance) and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if debuff.moonfire.remain() < gcd and (debuff.moonfire.count() < getValue("Moonfire targets")) then
                    if cast.moonfire(target ,"aoe") then return true end
                end
            end
            if (talent.naturesBalance and debuff.sunfire.remain() < 3) or (debuff.sunfire.remain() < 5.4 and not talent.naturesBalance) and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if debuff.sunfire.remain() < gcd and (debuff.sunfire.count() < getValue("Sunfire targets"))  then
                    if cast.sunfire(target ,"aoe") then return true end
                end
            end
        end
        --actions+=/solar_wrath,if=buff.solar_empowerment.stack=3
        if buff.solarEmpowerment.stack() == 3 then
            if buff.owlkinFrenzy.exists() then
                if cast.lunarStrike() then return true end
            else
                if cast.solarWrath() then return true end
            end
        end
        --actions+=/lunar_strike,if=buff.lunar_empowerment.stack=3
        if buff.lunarEmpowerment.stack() == 3 then
            if cast.lunarStrike() then return true end
        end
        --actions+=/call_action_list,name=celestial_alignment_phase,if=buff.celestial_alignment.up|buff.incarnation.up
        if buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists() then
            if actionList_CelestialAlignmentPhase() then return true end
        end
        --actions+=/call_action_list,name=single_target
        if actionList_SingleTarget() then return true end
        return false
    end

    local function actionList_CombatMoving()
        if useCDs() and isChecked("Force of Nature") then
            if talent.forceOfNature then
                if cast.forceOfNature(target,"best", 1, 8) then return true  end
            end
        end
        if buff.warriorOfElune.exists() or buff.owlkinFrenzy.exists() then
            if cast.lunarStrike() then return true end
        end
        if buff.onethsOverconfidence.exists() then
            if cast.starfall("best", nil, 1, starfallRadius) then return true end
        elseif buff.onethsIntuition.exists() then
            if cast.starsurge() then return true end
        end
        if multidot then
            if useAstralPower then
                if (astralPower >= 60) or (astralPower >= 40 and talent.soulOfTheForest)  then
                    if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then return true elseif cast.starsurge() then return true end
                end
            end
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (talent.naturesBalance and debuff.moonfire.remain(thisUnit) < 3) or (debuff.moonfire.remain(thisUnit) < 6.6 and not talent.naturesBalance) and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    if debuff.moonfire.remain(thisUnit) < gcd  and (debuff.moonfire.count() < getValue("Moonfire targets")) and isValidUnit(thisUnit) then
                        if cast.moonfire(thisUnit,"aoe") then return true end
                    end
                end
                if (talent.naturesBalance and debuff.sunfire.remain(thisUnit) < 3) or (debuff.sunfire.remain(thisUnit) < 5.4 and not talent.naturesBalance) and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                    if debuff.sunfire.remain(thisUnit) < gcd and (debuff.sunfire.count() < getValue("Sunfire targets")) and isValidUnit(thisUnit)  then
                        if cast.sunfire(thisUnit,"aoe") then return true end
                    end
                end
            end
        else
            if useAstralPower then
                if astralPower >= 40  then
                    if cast.starsurge() then return true end
                end
            end
            if debuff.moonfire.remain() < 6.6  and (debuff.moonfire.count() < getValue("Moonfire targets")) and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if debuff.moonfire.remain() < gcd then
                    if cast.moonfire(target ,"aoe") then return true end
                end
            end
            if debuff.sunfire.remain() < 5.4  and (debuff.sunfire.count() < getValue("Sunfire targets")) and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if debuff.sunfire.remain() < gcd then
                    if cast.sunfire(target ,"aoe") then return true end
                end
            end
        end
        --just to do something
        if multidot then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if debuff.moonfire.remain(thisUnit) <= debuff.sunfire.remain(thisUnit) and isValidUnit(thisUnit)  and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid)  then
                    if cast.moonfire(thisUnit,"aoe") then return true end
                elseif isValidUnit(thisUnit)  and ((UnitHealth(thisUnit) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid)  then
                    if cast.sunfire(thisUnit,"aoe") then return true end
                end
            end
        else
            if debuff.moonfire.remain() <= debuff.sunfire.remain() and ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if cast.moonfire(target ,"aoe") then return true end
            elseif ((UnitHealth(target) >= hpDotMin and (inInstance or inRaid)) or not inInstance and not inRaid) then
                if cast.sunfire(target ,"aoe") then return true end
            end
        end
        return false
    end

    local function actionList_Interrupts()
        if useInterrupts() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if canInterrupt(thisUnit,getValue("Interrupt at")) then
                    if isChecked("Solar Beam + Mass Entanglement") then
                        if talent.massEntanglement then
                            cast.massEntanglement(thisUnit)
                        end
                        if  br.timer:useTimer("gcd", 1.5) then
                            if cast.solarBeam(thisUnit) then return end
                        end
                    end
                end
                if talent.mightyBash then
                    if isChecked("Mighty Bash") and getDistance(thisUnit) <= 10 then
                        if getOptionValue("Mighty Bash")==6 and canInterrupt(thisUnit,getValue("Interrupt at")) then
                            if cast.mightyBash(thisUnit) then return true end
                        elseif (SpecificToggle("Mighty Bash") and not GetCurrentKeyBoardFocus()) then
                            if cast.mightyBash("target") then return true end
                        end
                    end
                end
            end
        end
        return false
    end

    local function actionList_Defensive()
        if useDefensive() and not (flight or travel or IsMounted() or IsFlying()) and not buff.prowl.exists() then
            --Revive/Rebirth
            if isChecked("Rebirth") then
                if getOptionValue("Rebirth - Target")== 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.rebirth("target","dead") then return true end
                end
                if getOptionValue("Rebirth - Target")==2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.rebirth("mouseover","dead") then return true end
                end
            end
            if isChecked("Revive") then
                if getOptionValue("Revive - Target")==1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.revive("target","dead") then return true end
                end
                if getOptionValue("Revive - Target")==2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.revive("mouseover","dead") then return true end
                end
            end
            -- Remove Corruption
            if isChecked("Remove Corruption") then
                if getOptionValue("Remove Corruption - Target")==1 and canDispel("player",spell.removeCorruption) then
                    if cast.removeCorruption("player") then return true end
                end
                if getOptionValue("Remove Corruption - Target")==2 and canDispel("target",spell.removeCorruption) then
                    if cast.removeCorruption("target") then return true end
                end
                if getOptionValue("Remove Corruption - Target")==3 and canDispel("mouseover",spell.removeCorruption) then
                    if cast.removeCorruption("mouseover") then return true end
                end
            end
            -- Renewal
            if isChecked("Renewal") and health <= getValue("Renewal") and inCombat then
                if cast.renewal() then return true end
            end
            -- Swiftmend
            if isChecked("Swiftmend") and health <= getValue("Swiftmend") and inCombat then
                if cast.swiftmend() then return true end
            end
            -- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
            if isChecked("Break Crowd Control") then
                if not hasNoControl() and lastForm ~= 0 then
                    CastShapeshiftForm(lastForm)
                    if GetShapeshiftForm() == lastForm then
                        lastForm = 0
                    end
                elseif hasNoControl() then
                    if GetShapeshiftForm() == 0 then
                        cast.balanceForm()
                    else
                        for i=1, GetNumShapeshiftForms() do
                            if i == GetShapeshiftForm() then
                                lastForm = i
                                CastShapeshiftForm(i)
                                return true
                            end
                        end
                    end
                end
            end
            -- Pot/Stoned
            if isChecked("Pot/Stoned") and health <= getValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512))
            then
                if canUse(5512) then
                    useItem(5512)
                elseif canUse(getHealthPot()) then
                    useItem(getHealthPot())
                end
            end
            -- Heirloom Neck
            if isChecked("Heirloom Neck") and health <= getValue("Heirloom Neck") then
                if hasEquiped(122668) then
                    if GetItemCooldown(122668)==0 then
                        useItem(122668)
                    end
                end
            end
            -- Engineering: Shield-o-tronic
            if isChecked("Shield-o-tronic") and health <= getValue("Shield-o-tronic")
                    and inCombat and canUse(118006)
            then
                useItem(118006)
            end
            -- Regrowth
            if isChecked("Regrowth") then
                if inCombat and getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40
                        and ((getHP(br.friend[1].unit) <= getValue("Regrowth")/2 and inCombat)
                        or (getHP(br.friend[1].unit) <= getValue("Regrowth") and not inCombat))
                then
                    if cast.regrowth(br.friend[1].unit) then return true end
                end
                if (getOptionValue("Auto Heal")==2 or not inCombat) and health <= getValue("Regrowth") then
                    if cast.regrowth("player") then return true end
                end
            end
            -- Rejuvenation
            if isChecked("Rejuvenation") and not buff.rejuvenation.exists() then
                if inCombat and getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40
                        and ((getHP(br.friend[1].unit) <= getValue("Rejuvenation")/2 and inCombat)
                        or (getHP(br.friend[1].unit) <= getValue("Rejuvenation") and not inCombat))
                then
                    if cast.rejuvenation(br.friend[1].unit) then return true end
                end
                if (getOptionValue("Auto Heal")==2 or not inCombat) and health <= getValue("Rejuvenation") then
                    if cast.rejuvenation("player") then return true end
                end
            end
            -- Barkskin
            if isChecked("Barkskin") and health <= getValue("Barkskin")
                    and inCombat and not buff.barkskin.exists() and cd.barkskin == 0
            then
                if cast.barkskin() then return true end
            end
        end -- End Defensive Toggle
        return false
    end

    local function actionList_OpenerDefault()
        if isValidUnit("target") and opener == false then
            if (isChecked("Pre-Pull Timer") and (pullTimer <= getValue("Pre-Pull Timer") or (pullTimer == 999 and SW))) or not isChecked("Pre-Pull Timer") or inCombat then
                -- potion,name=Potion of Deadly Grace
                if useCDs() and isChecked("Potion") and getDistance("target") <= 45 then
                    if canUse(127843) then
                        useItem(127843)
                        Print("Potion Used!");
                    end
                    if canUse(142117) then
                        useItem(142117)
                        Print("Potion Used!");
                    end
                end
                -- Solar Wrath
                if not SW then
                    if not isMoving("player") then
                        castOpener("solarWrath","SW",1)
                    else
                        Print("1: Solar Wrath (Not Casted: Mooving)")
                    end

                end
                -- New Moon | Half Moon | Full Moon
                if not MM1 then
                    if getCharges(spell.newMoon) > 0 then
                        if not isMoving("player") then
                            castOpener("newMoon","MM1",2)
                        else
                            Print("2: Moon Spells (Not Casted: Mooving)")
                        end
                    else
                        Print("2: Moon Spells (Not Casted: Cooldown)")
                        MM1 = true
                    end
                    --Moonfire
                elseif not MF then
                    castOpener("moonfire","MF",3)
                    --force of nature
                elseif not FON and useCDs() and isChecked("Force of Nature")   then
                    if talent.forceOfNature then
                        castOpener("forceOfNature","FON","3.4")
                    else
                        FON = true
                    end
                    --Astral Communion
                elseif not AC and useCDs() and isChecked("Astral Communion") and astralPower <= 20 then
                    if talent.astralCommunion then
                        if cd.astralCommunion == 0 then
                            castOpener("astralCommunion","AC","3.5")
                        else
                            Print("3.5: Astral Communion (Not Casted: Cooldown)")
                            AC = true
                        end
                    else
                        AC = true
                    end
                    --Sunfire
                elseif not SF then
                    castOpener("sunfire","SF",4)
                    --Celestial Alignment | Incarnation
                elseif not CA and useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                    if (talent.incarnationChoseOfElune and cd.incarnationChoseOfElune == 0) or (not talent.incarnationChoseOfElune and cd.celestialAlignment == 0) then
                        castOpener("celestialAlignment","CA",5,false)
                    else
                        Print("5: Incarnation: Chosen of Elune/Celestial Alignament (Not Casted: Cooldown)")
                        CA = true
                    end
                    --Racial
                elseif not RA and  (race == "Orc" or race == "Troll") and useCDs()  and isChecked("Racial") then
                    if getSpellCD(br.player.getRacial()) == 0 then
                        if br.player.castRacial() then
                            Print("5.5: Racial")
                            RA = true
                        end
                    else
                        RA = true
                        Print("5.5: Racial (Not Casted: Cooldown)")
                    end
                    -- Starsurge
                elseif astralPower == 99 or astralPower == 59 then
                    if cast.starfall("best", nil, getValue("Starfall targets"), starfallRadius) then Print("5.55: Starfall") return true elseif cast.starsurge() then Print("5.55: Starsurge") return true end
                    -- New Moon | Half Moon | Full Moon
                elseif not MM2 then
                    if getCharges(spell.newMoon) > 0 then
                        if not isMoving("player") then
                            castOpener("newMoon","MM2",6)
                        else
                            Print("6: Moon Spells (Not Casted: Mooving)")
                        end
                    else
                        Print("6: Moon Spells (Not Casted: Cooldown)")
                        MM2 = true
                    end
                    -- New Moon | Half Moon | Full Moon
                elseif not MM3 then
                    if getCharges(spell.newMoon) > 0 then
                        if not isMoving("player") then
                            castOpener("newMoon","MM3",7)
                        else
                            Print("7: Moon Spells (Not Casted: Mooving)")
                        end
                    else
                        Print("7: Moon Spells (Not Casted: Cooldown)")
                        MM3 = true
                    end
                else
                    Print("--Opener Complete--")
                    opener = true
                end
            end
        end
        return false
    end

    local function actionList_OpenerEmealdDreamCatcher()
        if isValidUnit("target") and opener == false then
            if (isChecked("Pre-Pull Timer") and (pullTimer <= getValue("Pre-Pull Timer") or (pullTimer == 999 and SW))) or not isChecked("Pre-Pull Timer") or inCombat then
                -- potion,name=Potion of Deadly Grace
                if useCDs() and isChecked("Potion") and getDistance("target") <= 45 then
                    if canUse(127843) then
                        useItem(127843)
                        Print("Potion Used!");
                    end
                    if canUse(142117) then
                        useItem(142117)
                        Print("Potion Used!");
                    end
                end
                -- Solar Wrath
                if not SW then
                    if not isMoving("player") then
                        castOpener("solarWrath","SW",1)
                    else
                        Print("1: Solar Wrath (Not Casted: Mooving)")
                    end
                    -- New Moon | Half Moon | Full Moon
                elseif not MM1 then
                    if getCharges(spell.newMoon) > 0 then
                        if not isMoving("player") then
                            castOpener("newMoon","MM1",2)
                        else
                            Print("2: Moon Spells (Not Casted: Mooving)")
                        end
                    else
                        Print("2: Moon Spells (Not Casted: Cooldown)")
                        MM1 = true
                    end
                    --Moonfire
                elseif not MF then
                    castOpener("moonfire","MF",3)
                    --Sunfire
                elseif not SF then
                    castOpener("sunfire","SF",4)
                    --Celestial Alignment | Incarnation
                elseif not CA and useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                    if (talent.incarnationChoseOfElune and cd.incarnationChoseOfElune == 0) or (not talent.incarnationChoseOfElune and cd.celestialAlignment == 0) then
                        castOpener("celestialAlignment","CA",5,false)
                    else
                        Print("5: Incarnation: Chosen of Elune/Celestial Alignament (Not Casted: Cooldown)")
                        CA = true
                    end
                    --Racial
                elseif not RA and  (race == "Orc" or race == "Troll") and useCDs()  and isChecked("Racial") then
                    if getSpellCD(br.player.getRacial()) == 0 then
                        if castSpell("player",br.player.getRacial(),false,false,false) then
                            Print("5.5: Racial")
                            RA = true
                        end
                    else
                        RA = true
                        Print("5.5: Racial (Not Casted: Cooldown)")
                    end
                    -- New Moon | Half Moon | Full Moon
                elseif not MM2 then
                    if getCharges(spell.newMoon) > 0 then
                        if not isMoving("player") then
                            castOpener("newMoon","MM2",6)
                        else
                            Print("6: Moon Spells (Not Casted: Mooving)")
                        end
                    else
                        Print("6: Moon Spells (Not Casted: Cooldown)")
                        MM2 = true
                    end
                    -- New Moon | Half Moon | Full Moon
                elseif not MM3 then
                    if getCharges(spell.newMoon) > 0 then
                        if not isMoving("player") then
                            castOpener("newMoon","MM3",7)
                        else
                            Print("7: Moon Spells (Not Casted: Mooving)")
                        end
                    else
                        Print("7: Moon Spells (Not Casted: Cooldown)")
                        MM3 = true
                    end
                elseif not STS then
                    castOpener("starsurge","STS",8)
                elseif not SW2 then
                    castOpener("solarWrath","SW2",9)
                elseif hasBloodLust() and SP then

                elseif SP then
                    if not LS and buff.emeraldDreamcatcher.remain() > getCastTime(spell.lunarStrike) then
                        castOpener("lunarStrike","LS",10)
                    elseif not STS2 then
                        castOpener("starsurge","STS2",11)
                    elseif not SW3 and buff.emeraldDreamcatcher.remain() > getCastTime(spell.solarWrath) then
                        castOpener("solarWrath","SW3",12)
                    elseif not SW4 then
                        castOpener("solarWrath","SW4",13)
                    elseif not STS3 then
                        castOpener("starsurge","STS3",14)
                    elseif not STS4 then
                        castOpener("starsurge","STS4",15)
                    elseif not STS5 then
                        castOpener("starsurge","STS5",16)
                    elseif not SW5 then
                        castOpener("solarWrath","SW5",17)
                    elseif not LS2 then
                        castOpener("lunarStrike","LS2",18)
                    elseif not LS3 then
                        castOpener("lunarStrike","LS3",19)
                    else
                        SP = true
                    end
                else
                    Print("--Opener Complete--")
                    opener = true
                end
            end
        end
        return false
    end

    local function actionList_Opener()
        if opener == false and isChecked("Opener") and isBoss("target") then
            --            if isChecked("Pre-Pull Timer") and inCombat and getCombatTime() > 10 then
            --                opener = true
            --                return true
            --            end
            if hasEquiped(137062) then
                if actionList_OpenerEmealdDreamCatcher() then return true end
            else
                if actionList_OpenerDefault() then return true end
            end
        end
        return false
    end

    local function deadlyChicken()
        if isChecked("Deadly Chicken") then
            -- local objectCount = GetObjectCount() or 0
            for i = 1, ObjectCount() do
                -- define our unit
                local thisUnit = GetObjectWithIndex(i)
                -- check if it a unit first
                if ObjectIsType(thisUnit, ObjectTypes.Unit)  then
                    br.debug.cpu.enemiesEngine.unitTargets = br.debug.cpu.enemiesEngine.unitTargets + 1
                    -- sanity checks
                    if GetObjectExists(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and not UnitIsFriend(thisUnit, "player") and UnitCanAttack("player",thisUnit) and getDistance(thisUnit) < 40 and getLineOfSight("player", thisUnit)
                    then
                        if isChecked("Deadly Chicken - DONT KILL BOSS") then
                            if debuff.moonfire.remain(thisUnit) == 0 then
                                if not isBoss(thisUnit) then
                                    CastSpellByName(GetSpellInfo(spell.moonfire),thisUnit)
                                    return true
                                end
                            end
                        elseif debuff.sunfire.remain(thisUnit) == 0 then
                            CastSpellByName(GetSpellInfo(spell.sunfire),thisUnit)
                            return true
                        end
                    end
                end
            end
            return false
        end
    end

    --if br.timer:useTimer("debugBalance", getSpellCD(61304)+0.02)  then
    function profile()
        -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or (IsMounted() or IsFlying()) or br.player.mode.rotation==4 then
            return true
        end
        if (not isMoving("player") and buff.dash.exists()) or not buff.dash.exists() then
            if actionList_Extras() then  return true end
            if actionList_PreCombat() then  return true end
            if actionList_Opener() then  return true end
            if deadlyChicken() then  return true end
            if inCombat and (opener == true or not isChecked("Opener") or not isBoss("target")) then
                if actionList_Interrupts() then  return true end
                if actionList_Defensive() then  return true end
                if (not isMoving("player") or buff.stellarDrift.exists()) then
                    if actionList_Combat() then  return true end
                elseif isMoving("player") then
                    if actionList_CombatMoving() then  return true end
                end
            end
        elseif not chicken and IsMovingTime(2) and buff.dash.exists() and not cat then
            cast.catForm()
        end--End Pause
        return false
    end

    if executando == nil then executando = false end
    if lastGCD == nil then lastGCD = false end
    if lastSpellCast == spell.forceOfNature
            or lastSpellCast == spell.incarnationChoseOfElune
            or lastSpellCast == spell.warriorOfElune
            or lastSpellCast == spell.solarBeam
            or lastSpellCast == spell.celestialAlignment
            or lastSpellCast == spell.barkskin
            or lastSpellCast == spell.dash
            or lastSpellCast == 26297 then
        lastGCD = true
    else
        lastGCD = false
    end

    if not executando and (getSpellCD(61304) == 0 or lastGCD) then
        executando = true
        profile()
        executando = false
    end

    -- end -- End Timer
end-- End runRotation
local id = 102

if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

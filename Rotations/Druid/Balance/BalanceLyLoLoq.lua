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
        br.ui:createSpinnerWithout(section, "Starfall targets",  3,  2,  100,  1,  "Minimum starfall targets. Min: 2 / Max: 100")
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
        -- Astral Comunication
        br.ui:createCheckbox(section,"Astral Communion")
        -- Trinkets
        br.ui:createCheckbox(section,"Trinkets")
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
        br.ui:createDropdown(section, "Innervate", br.dropOptions.Toggle, 1, "Set hotkey to use Innervate on |cffFF0000Mouseover.")
        br.ui:createCheckbox(section, "Announce Inervate", "Should announce on /i innervate target?")
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
        -- Solar Beam + Mass Entanglement
        br.ui:createCheckbox(section,"Solar Beam + Mass Entanglement")
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
    local player                                        = br.player
    local travel, flight, chicken, noform               = player.buff.travelForm.exists(), player.buff.flightForm.exists(), player.buff.balanceForm.exists(), GetShapeshiftForm()==0
    local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
    local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
    local astralPower                                   = player.power.amount.astralPower
    local multidot                                      = player.mode.rotation == 1 or player.mode.rotation == 2
    local nodps                                         = player.mode.rotation == 4
    local inInstance                                    = player.instance=="party"
    local inRaid                                        = player.instance=="raid"
    local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.intellectBig)
    local pullTimer                                     = br.DBM:getPulltimer()

    local enemies                                       = enemies or {}
    local units                                         = units or {}

    enemies.yards40 = player.enemies(40)
    units.dyn40 = player.units(40)


    ---------------
    --- Toggles ---
    ---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)


    if lastForm == nil then lastForm = 0 end
    if profileStop == nil then profileStop = false end
    if opener == nil then opener = false end


    if not player.inCombat and not ObjectExists("target") then
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
    end
    if player.talent.stellarDrift then starfallRadius = 19.5 else starfallRadius = 15 end
    if not player.inCombat and not hastar and profileStop==true then
        profileStop = false
    end


    --    if br.timer:useTimer("debugBalance", math.random(0.5,0.8)) then

    if br.timer:useTimer("debugBalance", 0.1)  then

        local function actionList_Extras()
            if isChecked("Innervate") and (SpecificToggle("Innervate") and not GetCurrentKeyBoardFocus()) and player.cd.innervate == 0 then
                if player.cast.innervate("mouseover") then
                    SendChatMessage("Innervate casted on " .. UnitName("mouseover"), "INSTANCE_CHAT", nil, UnitName("mouseover"))
                    return true end
            end
            if isChecked("Auto Shapeshifts") then
                -- Flight Form
                if IsFlyableArea() and ((not (isInDraenor() or isInLegion())) or isKnown(191633)) and not swimming and falling > 1 and player.level>=58 then
                    if player.cast.travelForm() then return true end
                end
                -- Aquatic Form
                if swimming and not travel and not hastar and not deadtar and not player.buff.prowl.exists() then
                    if player.cast.travelForm() then return true end
                end
                -- balanceForm
                if not chicken and not IsMounted() then
                    -- balanceForm when not swimming or flying or stag and not in combat
                    if not player.inCombat and moving and not swimming and not flying and not travel and not isValidUnit("target") then
                        if player.cast.balanceForm() then return true end
                    end
                    -- balanceForm when not in combat and target selected and within 40yrds
                    if not player.inCombat and isValidUnit("target") and getDistance("target") < 40 then
                        if player.cast.balanceForm() then return true end
                    end
                    --balanceForm when in combat and not flying
                    if player.inCombat and not flying then
                        if player.cast.balanceForm() then return true end
                    end
                end
            end
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end
            return false
        end

        local function actionList_PreCombat()
            if not (flight or travel or IsMounted() or IsFlying()) and not player.buff.prowl.exists() then
                -- actions.precombat=flask,type=flask_of_the_whispered_pact
                if isChecked("Flask / Crystal") and not not player.buff.prowl.exists() then
                    if inRaid and canUse(player.flask.wod.intellectBig) and flaskBuff==0 and not UnitBuffID("player",player.flask.wod.intellectBig) then
                        useItem(player.flask.wod.intellectBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if not UnitBuffID("player",player.flask.wod.intellectBig) and canUse(118922) then --Draenor Insanity Crystal
                            useItem(118922)
                            return true
                        end
                    end
                end
                --TODO:actions.precombat+=/food,type=azshari_salad
                --TODO:actions.precombat+=/augmentation,type=defiled
                --actions.precombat+=/moonkin_form
                if not chicken then
                    if player.cast.balanceForm() then return true end
                end
                --actions.precombat+=/blessing_of_elune
                if player.talent.blessingOfTheAncients then
                    --actions+=/blessing_of_elune,if=active_enemies<=2&talent.blessing_of_the_ancients.enabled&buff.blessing_of_elune.down
                    if ((#enemies.yards40 <= 2 or not multidot) and not player.buff.blessingOfElune.exists())  then
                        if player.cast.blessingOfTheAncients() then return true end
                    elseif #enemies.yards40 >= 3  and not player.buff.blessingOfAnshe.exists() and multidot then
                        --actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
                        if player.cast.blessingOfTheAncients() then return true end
                    end
                end
                --TODO:actions.precombat+=/potion,name=deadly_grace
                --actions.precombat+=/new_moon
                --                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                --                    if player.cast.newMoon() then return true end
                --                    if player.cast.solarWrath() then return true end
                --                end
            end
            return false
        end

        --------------------------
        --- In Combat Rotation ---
        --------------------------
        local function actionList_FuryOfElune()
            --actions.fury_of_elune=incarnation,if=astral_power>=95&cooldown.fury_of_elune.remains<=gcd
            if astralPower >= 95 and player.cd.furyOfElune <= player.gcd then
                if player.talent.incarnationChoseOfElune and useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                    if player.cast.celestialAlignment() then return true end
                elseif useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                    if player.cast.celestialAlignment() then return true end
                end
                --actions.fury_of_elune+=/fury_of_elune,if=astral_power>=95
                if player.cast.furyOfElune("target", "best", nil, 3) then return true end
            end
            --actions.fury_of_elune+=/new_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=90))
            if ((getCharges(player.spell.newMoon) == 2 and player.recharge.newMoon < 5) or getCharges(player.spell.newMoon) == 3) and (player.buff.furyOfElune.exists() or (player.cd.furyOfElune > player.gcd*3 and astralPower <= 90)) then
                if player.cast.newMoon() then return true end
            end
            --actions.fury_of_elune+=/half_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=80))
            if (getCharges(player.spell.halfMoon) == 2 and player.recharge.halfMoon < 5) or (getCharges(player.spell.halfMoon) == 3) and (player.buff.furyOfElune.exists() or (player.cd.furyOfElune > player.gcd*3 and astralPower <= 80)) then
                if player.cast.halfMoon() then return true end
            end
            --actions.fury_of_elune+=/full_moon,if=((charges=2&recharge_time<5)|charges=3)&&(buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>gcd*3&astral_power<=60))
            if (getCharges(player.spell.fullMoon) == 2 and player.recharge.fullMoon < 5) or(getCharges(player.spell.fullMoon) == 3) and (player.buff.furyOfElune.exists() or (player.cd.furyOfElune > player.gcd*3 and astralPower <= 60)) then
                if player.cast.fullMoon() then return true end
            end
            --actions.fury_of_elune+=/astral_communion,if=buff.fury_of_elune_up.up&astral_power<=25
            if player.talent.astralCommunion and player.buff.furyOfElune.exists() and astralPower <= 25 and useCDs() and isChecked("Astral Communion") then
                if player.cast.astralCommunion() then return true end
            end
            --actions.fury_of_elune+=/warrior_of_elune,if=buff.fury_of_elune_up.up|(cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.up)
            if player.talent.warriorOfElune and (player.buff.furyOfElune.exists() or player.cd.furyOfElune >= 35 and player.buff.lunarEmpowerment.exists()) and useCDs() and isChecked("Warrior of Elune")  then
                if player.cast.warriorOfElune() then return true end
            end
            --actions.fury_of_elune+=/lunar_strike,if=buff.warrior_of_elune.up&(astral_power<=90|(astral_power<=85&buff.incarnation.up))
            if player.buff.warriorOfElune.exists() and (astralPower <= 90 or player.buff.incarnationChoseOfElune.exists()) then
                if player.cast.lunarStrike() then return true end
            end
            --actions.fury_of_elune+=/new_moon,if=astral_power<=90&buff.fury_of_elune_up.up
            if astralPower <= 90 and player.buff.furyOfElune.exists() then
                if player.cast.newMoon() then return true end
            end
            --actions.fury_of_elune+=/half_moon,if=astral_power<=80&buff.fury_of_elune_up.up&astral_power>cast_time*12
            if astralPower <= 80 and player.buff.furyOfElune.exists() and astralPower > getCastTime(player.spell.halfMoon)*12 then
                if player.cast.halfMoon() then return true end
            end
            --actions.fury_of_elune+=/full_moon,if=astral_power<=60&buff.fury_of_elune_up.up&astral_power>cast_time*12
            if astralPower <= 60 and player.buff.furyOfElune.exists() and astralPower > getCastTime(player.spell.fullMoon)*12 then
                if player.cast.fullMoon() then return true end
            end

            if multidot then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    --actions.fury_of_elune+=/moonfire,if=buff.fury_of_elune_up.down&remains<=6.6
                    if not player.buff.furyOfElune.exists() and player.debuff.moonfire.remain(thisUnit) <= 6.6  then
                        if player.debuff.moonfire.remain(thisUnit) < player.gcd and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) and isValidUnit(thisUnit) then
                            if player.cast.moonfire(thisUnit,"aoe") then return true end
                        end
                    end
                    --actions.fury_of_elune+=/sunfire,if=buff.fury_of_elune_up.down&remains<5.4
                    if not player.buff.furyOfElune.exists() and player.debuff.sunfire.remain(thisUnit) <= 5.4  then
                        if player.debuff.sunfire.remain(thisUnit) < player.gcd and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets")) and isValidUnit(thisUnit) then
                            if player.cast.sunfire(thisUnit,"aoe") then return true end
                        end
                    end
                end
            else
                if not player.buff.furyOfElune.exists() and player.debuff.moonfire.remain() <= 6.6  then
                    if player.debuff.moonfire.remain() < player.gcd and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) then
                        if player.cast.moonfire() then return true end
                    end
                end
                --actions.fury_of_elune+=/sunfire,if=buff.fury_of_elune_up.down&remains<5.4
                if not player.buff.furyOfElune.exists() and player.debuff.sunfire.remain() <= 5.4 then
                    if player.debuff.sunfire.remain() < player.gcd and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets"))  then
                        if player.cast.sunfire() then return true end
                    end
                end
            end

            --actions.fury_of_elune+=/stellar_flare,if=remains<7.2&active_enemies=1
            if player.talent.stellarFlare and astralPower >= 10 and player.debuff.stellarFlare.remain() < 7.2 then
                if player.debuff.stellarFlare.remain() < player.gcd and (player.debuff.stellarFlare.count() < getOptionValue("Stellar Flare targets")) then
                    if player.cast.stellarFlare() then return true end
                end
            end
            if multidot then
                --actions.fury_of_elune+=/starfall,if=(active_enemies>=2&talent.stellar_flare.enabled|active_enemies>=3)&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>10
                if not player.buff.furyOfElune.exists() and player.cd.furyOfElune > 10 then
                    if (astralPower >= 60) or (astralPower >= 40 and player.talent.soulOfTheForest) then
                        if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then return else if player.cast.starsurge() then return true end end
                    end
                end
            end

            --actions.fury_of_elune+=/starsurge,if=active_enemies<=2&buff.fury_of_elune_up.down&cooldown.fury_of_elune.remains>7
            if not player.buff.furyOfElune.exists() and player.cd.furyOfElune > 7 then
                if (#enemies.yards40 <= 2) or not multidot then
                    if player.cast.starsurge() then return true end
                end
            end
            --actions.fury_of_elune+=/starsurge,if=buff.fury_of_elune_up.down&((astral_power>=92&cooldown.fury_of_elune.remains>gcd*3)|(cooldown.warrior_of_elune.remains<=5&cooldown.fury_of_elune.remains>=35&buff.lunar_empowerment.stack<2))
            if not player.buff.furyOfElune.exists() and ((astralPower >= 92 and player.cd.furyOfElune > player.gcd*3) or (player.cd.warriorOfElune <=5 and player.cd.furyOfElune>=35 and player.buff.lunarEmpowerment.stack() < 2 )) then
                if player.cast.starsurge() then return true end
            end
            --actions.fury_of_elune+=/solar_wrath,if=buff.solar_empowerment.up
            if player.buff.solarEmpowerment.exists() then
                if player.cast.solarWrath() then return true end
            end
            --actions.fury_of_elune+=/lunar_strike,if=buff.lunar_empowerment.stack=3|(buff.lunar_empowerment.remains<5&buff.lunar_empowerment.up)|active_enemies>=2
            if player.buff.lunarEmpowerment.stack() == 3 or (player.buff.lunarEmpowerment.remain() < 5 and player.buff.lunarEmpowerment.exists()) or #getEnemies("target",5)>=2 then
                if player.cast.lunarStrike() then return true end
            end
            --actions.fury_of_elune+=/solar_wrath
            if player.cast.solarWrath() then return true end
            return true
        end

        local function actionList_EmeralDreamcatcher()
            --actions.ed=astral_communion,if=astral_power.deficit>=75&buff.the_emerald_dreamcatcher.up
            if player.talent.astralCommunion and astralPower <= 25 and player.buff.emeraldDreamcatcher.exists() and useCDs() and isChecked("Astral Communion")  then
                if player.cast.astralCommunion() then return true end
            end
            --actions.ed+=/incarnation,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up|buff.bloodlust.up
            if player.talent.incarnationChoseOfElune and astralPower >= 85 and player.cd.incarnationChoseOfElune == 0 and not player.buff.emeraldDreamcatcher.exists() or player.buff.bloodlust.exists() and useCDs()  and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                if player.cast.celestialAlignment() then return true end
            end
            --actions.ed+=/celestial_alignment,if=astral_power>=85&!buff.the_emerald_dreamcatcher.up
            if not player.talent.incarnationChoseOfElune and astralPower >= 85 and player.cd.celestialAlignment == 0 and not player.buff.emeraldDreamcatcher.exists() and useCDs()  and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                if player.cast.celestialAlignment() then return true end
            end
            --actions.ed+=/starsurge,if=(buff.celestial_alignment.up&buff.celestial_alignment.remains<(10))|(buff.incarnation.up&buff.incarnation.remains<(3*execute_time)&astral_power>78)|(buff.incarnation.up&buff.incarnation.remains<(2*execute_time)&astral_power>52)|(buff.incarnation.up&buff.incarnation.remains<execute_time&astral_power>26)
            if (player.buff.celestialAlignment.exists() and player.buff.celestialAlignment.remain() < 10) or (player.buff.incarnationChoseOfElune.exists() and player.buff.incarnationChoseOfElune.remain() < (3*getCastTime(player.spell.starsurge)) and astralPower > 78) or (player.buff.incarnationChoseOfElune.exists() and player.buff.incarnationChoseOfElune.remain() < (2*getCastTime(player.spell.starsurge)) and astralPower > 52) or (player.buff.incarnationChoseOfElune.exists() and player.buff.incarnationChoseOfElune.remain() < (getCastTime(player.spell.starsurge)) and astralPower > 26) then
                if player.cast.starsurge() then return true end
            end
            if multidot then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    --actions.ed+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
                    if player.debuff.stellarFlare.count() <= getOptionValue("Stellar Flare targets") then
                        if player.talent.stellarFlare  and astralPower >= 15 and player.debuff.stellarFlare.remain(thisUnit) < 7.2 and isValidUnit(thisUnit) then
                            if player.cast.stellarFlare(thisUnit, "aoe") then return true end
                        end
                    end
                    --actions.ed+=/moonfire,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                    if (player.talent.naturesBalance and player.debuff.moonfire.remain(thisUnit) < 3) or (player.debuff.moonfire.remain(thisUnit) < 6.6 and not player.talent.naturesBalance) then
                        if player.debuff.moonfire.remain(thisUnit) < player.gcd  and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) and isValidUnit(thisUnit) then
                            if player.cast.moonfire(thisUnit,"aoe") then return true end
                        end
                    end
                    --actions.ed+=/sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                    if (player.talent.naturesBalance and player.debuff.sunfire.remain(thisUnit) < 3) or (player.debuff.sunfire.remain(thisUnit) < 5.4 and not player.talent.naturesBalance) then
                        if player.debuff.sunfire.remain(thisUnit) < player.gcd and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets")) and isValidUnit(thisUnit)  then
                            if player.cast.sunfire(thisUnit,"aoe") then return true end
                        end
                    end
                end
            else
                --actions.ed+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
                if player.debuff.stellarFlare.count() <= getOptionValue("Stellar Flare targets") then
                    if player.talent.stellarFlare and astralPower >= 15 and player.debuff.stellarFlare.remain() < 7.2 then
                        if player.cast.stellarFlare() then return true end
                    end
                end
                --actions.ed+=/moonfire,if=((talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                if (player.talent.naturesBalance and player.debuff.moonfire.remain() < 3) or (player.debuff.moonfire.remain() < 6.6 and not player.talent.naturesBalance)  then
                    if player.debuff.moonfire.remain() < player.gcd  and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) then
                        if player.cast.moonfire() then  return true end
                    end
                end
                --actions.ed+=/sunfire,if=((talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled))&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
                if (player.talent.naturesBalance and player.debuff.sunfire.remain() < 3) or (player.debuff.sunfire.remain() < 5.4 and not player.talent.naturesBalance) then
                    if player.debuff.sunfire.remain() < player.gcd and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets"))  then
                        if player.cast.sunfire() then return true end
                    end
                end
            end
            if multidot then
                --actions.ed+=/starfall,if=buff.oneths_overconfidence.up&buff.the_emerald_dreamcatcher.remains>execute_time&remains<2
                if player.buff.onethsOverconfidence.exists() and player.buff.emeraldDreamcatcher.remain() > player.gcd then
                    if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then return else if player.cast.starsurge() then return true end end
                end
            else
                if player.buff.onethsOverconfidence.exists() and player.buff.emeraldDreamcatcher.remain() > player.gcd then
                    if player.cast.starsurge() then return true end
                end
            end
            --actions.ed+=/half_moon,if=astral_power<=80&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=6
            if astralPower <= 80 and player.buff.emeraldDreamcatcher.remain() > getCastTime(player.spell.halfMoon) then
                if player.cast.halfMoon() then return true end
            end
            --actions.ed+=/full_moon,if=astral_power<=60&buff.the_emerald_dreamcatcher.remains>execute_time
            if astralPower <= 60 and player.buff.emeraldDreamcatcher.remain() > getCastTime(player.spell.fullMoon) then
                if player.cast.fullMoon() then return true end
            end
            --actions.ed+=/solar_wrath,if=buff.solar_empowerment.stack>1&buff.the_emerald_dreamcatcher.remains>2*execute_time&astral_power>=6&(dot.moonfire.remains>5|(dot.sunfire.remains<5.4&dot.moonfire.remains>6.6))&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
            if player.buff.solarEmpowerment.exists() and player.buff.emeraldDreamcatcher.remain() > 2*getCastTime(player.spell.solarWrath) and astralPower >=6 and (player.debuff.moonfire.remain()>5 or player.debuff.sunfire.remain()<5.4 and player.debuff.moonfire.remain()>6.6) and (not(player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists()) and astralPower <=90 or (player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists()) and astralPower<=85) then
                if player.cast.solarWrath() then return true end
            end
            --actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=11&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=77.5)
            if player.buff.lunarEmpowerment.exists() and player.buff.emeraldDreamcatcher.remain()> getCastTime(player.spell.lunarStrike) and astralPower >=11 and(not(player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists()) and astralPower <=85 or (player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists()) and astralPower<= 77.5) then
                if player.cast.lunarStrike() then return true end
            end
            --actions.ed+=/solar_wrath,if=buff.solar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time&astral_power>=16&(!(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=90|(buff.celestial_alignment.up|buff.incarnation.up)&astral_power<=85)
            if player.buff.solarEmpowerment.exists() and player.buff.emeraldDreamcatcher.remain() > getCastTime(player.spell.solarWrath) and astralPower >=16 and (not(player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists()) and astralPower<=90 or (player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists()) and astralPower<= 85) then
                if player.cast.solarWrath() then return true end
            end
            --actions.ed+=/starsurge,if=(buff.the_emerald_dreamcatcher.up&buff.the_emerald_dreamcatcher.remains<gcd.max)|astral_power>90|((buff.celestial_alignment.up|buff.incarnation.up)&astral_power>=85)|(buff.the_emerald_dreamcatcher.up&astral_power>=77.5&(buff.celestial_alignment.up|buff.incarnation.up))
            if (player.buff.emeraldDreamcatcher.exists() and player.buff.emeraldDreamcatcher.remain() < player.gcd) or astralPower>90 or ((player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists()) and astralPower>=85) or (player.buff.emeraldDreamcatcher.exists() and astralPower >=77.5 and (player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists())) then
                if player.cast.starsurge() then return true end
            end
            if multidot then
                --actions.ed+=/starfall,if=buff.oneths_overconfidence.up&remains<2
                if player.buff.onethsOverconfidence.exists() and player.buff.onethsOverconfidence.remain() < 2 then
                    if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then return else if player.cast.starsurge() then return true end end
                end
            else
                if player.buff.onethsOverconfidence.remain()<2 then
                    if player.cast.starsurge() then return true end
                end
            end
            --actions.ed+=/new_moon,if=astral_power<=90
            if astralPower <= 90 then
                if player.cast.newMoon() then return true end
            end
            --actions.ed+=/half_moon,if=astral_power<=80
            if astralPower <= 80 then
                if player.cast.halfMoon() then return true end
            end
            --actions.ed+=/full_moon,if=astral_power<=60&((cooldown.incarnation.remains>65&cooldown.full_moonfire.charges>0)|(cooldown.incarnation.remains>50&cooldown.full_moonfire.charges>1)|(cooldown.incarnation.remains>25&cooldown.full_moonfire.charges>2))
            if astralPower <= 60 and ((player.cd.incarnationChoseOfElune > 65 and getCharges(player.spell.fullMoon) > 0) or (player.cd.incarnationChoseOfElune > 50 and getCharges(player.spell.fullMoon) > 1) or player.cd.incarnationChoseOfElune > 25 and getCharges(player.spell.fullMoon) > 2) then
                if player.cast.fullMoon() then return true end
            end
            --actions.ed+=/solar_wrath,if=buff.solar_empowerment.up
            if player.buff.solarEmpowerment.exists() then
                if player.cast.solarWrath() then return true end
            end
            --actions.ed+=/lunar_strike,if=buff.lunar_empowerment.up
            if player.buff.lunarEmpowerment.exists() then
                if player.cast.lunarStrike() then return true end
            end
            --actions.ed+=/solar_wrath
            if player.cast.solarWrath() then return true end
            return true
        end

        local function actionList_CelestialAlignmentPhase()
            if multidot then
                --if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
                if (astralPower >= 60) or (astralPower >= 40 and player.talent.soulOfTheForest) then
                    if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then return else if player.cast.starsurge() then return true end end
                end
            end
            --actions.celestial_alignment_phase+=/starsurge,if=active_enemies<=2
            if #enemies.yards40 <= 2 or not multidot then
                if player.cast.starsurge() then return true end
            end
            --actions.celestial_alignment_phase+=/warrior_of_elune
            if player.talent.warriorOfElune and useCDs()  and isChecked("Warrior of Elune") then
                if player.cast.warriorOfElune() then return true end
            end
            --actions.celestial_alignment_phase+=/lunar_strike,if=buff.warrior_of_elune.up
            if player.buff.warriorOfElune.exists() then
                if player.cast.lunarStrike() then return true end
            end
            --actions.celestial_alignment_phase+=/solar_wrath,if=buff.solar_empowerment.up
            if player.buff.solarEmpowerment.exists() then
                if player.cast.solarWrath() then return true end
            end
            --actions.celestial_alignment_phase+=/lunar_strike,if=buff.lunar_empowerment.up
            if player.buff.lunarEmpowerment.exists() then
                if player.cast.lunarStrike() then return true end
            end
            --actions.celestial_alignment_phase+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
            if player.talent.naturesBalance and player.debuff.sunfire.remain() < 5 and getCastTime(player.spell.sunfire) < player.debuff.sunfire.remain() then
                if player.cast.solarWrath() then return true end
            end
            --actions.celestial_alignment_phase+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
            if (player.talent.naturesBalance and player.debuff.moonfire.remain() < 5 and getCastTime(player.spell.moonfire) < player.debuff.moonfire.remain()) or #getEnemies("target",5) >= 2 then
                if player.cast.lunarStrike() then return true end
            end
            --actions.celestial_alignment_phase+=/solar_wrath
            if player.cast.solarWrath() then return true end
            return true
        end

        local function actionList_SingleTarget()
            --actions.single_target=new_moon,if=astral_power<=90
            if astralPower <= 90 then
                if player.cast.newMoon() then return true end
            end
            --actions.single_target+=/half_moon,if=astral_power<=80
            if astralPower <= 80 then
                if player.cast.halfMoon() then return true end
            end
            --actions.single_target+=/full_moon,if=astral_power<=60
            if astralPower <= 60 then
                if player.cast.fullMoon() then return true end
            end
            if multidot then
                --actions.single_target+=/starfall,if=((active_enemies>=2&talent.stellar_drift.enabled)|active_enemies>=3)
                if (astralPower >= 60) or (astralPower >= 40 and player.talent.soulOfTheForest) then
                    if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then return else if player.cast.starsurge() then return true end end
                end
            end
            --actions.single_target+=/starsurge,if=active_enemies<=2
            if #enemies.yards40 <= 2 or not multidot then
                if player.cast.starsurge() then return true end
            end
            --actions.single_target+=/warrior_of_elune
            if player.talent.warriorOfElune and useCDs()  and isChecked("Warrior of Elune")  then
                if player.cast.warriorOfElune() then return true end
            end
            --actions.single_target+=/lunar_strike,if=buff.warrior_of_elune.up
            if player.buff.warriorOfElune.exists() then
                if player.cast.lunarStrike() then return true end
            end
            --actions.single_target+=/solar_wrath,if=buff.solar_empowerment.up
            if player.buff.solarEmpowerment.exists() then
                if player.cast.solarWrath() then return true end
            end
            --actions.single_target+=/lunar_strike,if=buff.lunar_empowerment.up
            if player.buff.lunarEmpowerment.exists() then
                if player.cast.lunarStrike() then return true end
            end
            --actions.single_target+=/solar_wrath,if=talent.natures_balance.enabled&dot.sunfire_dmg.remains<5&cast_time<dot.sunfire_dmg.remains
            if player.talent.naturesBalance and player.debuff.sunfire.remain() < 5 and getCastTime(player.spell.sunfire) < player.debuff.sunfire.remain() then
                if player.cast.solarWrath() then return true end
            end
            --actions.single_target+=/lunar_strike,if=(talent.natures_balance.enabled&dot.moonfire_dmg.remains<5&cast_time<dot.moonfire_dmg.remains)|active_enemies>=2
            if (player.talent.naturesBalance and player.debuff.moonfire.remain() < 5 and getCastTime(player.spell.moonfire) < player.debuff.moonfire.remain()) or #getEnemies("target",5) >= 2 then
                if player.cast.lunarStrike() then return true end
            end
            --actions.single_target+=/solar_wrath
            if player.cast.solarWrath() then return true end
            return false
        end

        local function actionList_SomeCDS()
            if useCDs() and isChecked("Trinkets") then
                if player.buff.incarnationChoseOfElune.exists() or player.buff.celestialAlignment.exists() then
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
                if player.buff.incarnationChoseOfElune.exists() or player.buff.celestialAlignment.exists() then
                    useItem(127843)
                    return true
                end
            end
            return false
        end

        local function actionList_Combat()
            if actionList_SomeCDS() then return true end

            --TODO:actions=potion,name=deadly_grace,if=buff.celestial_alignment.up|buff.incarnation.up
            if player.talent.blessingOfTheAncients then
                --actions+=/blessing_of_elune,if=active_enemies<=2&talent.blessing_of_the_ancients.enabled&buff.blessing_of_elune.down
                if ((#enemies.yards40 <= 2 or not multidot) and not player.buff.blessingOfElune.exists())  then
                    if player.cast.blessingOfTheAncients() then return true end
                elseif #enemies.yards40 >= 3  and not player.buff.blessingOfAnshe.exists() and multidot then
                    --actions+=/blessing_of_elune,if=active_enemies>=3&talent.blessing_of_the_ancients.enabled&buff.blessing_of_anshe.down
                    if player.cast.blessingOfTheAncients() then return true end
                end
            end
            --actions+=/blood_fury,if=buff.celestial_alignment.up|buff.incarnation.up
            --actions+=/berserking,if=buff.celestial_alignment.up|buff.incarnation.up
            if (player.race == "Orc" or player.race == "Troll") and getSpellCD(player.getRacial()) == 0 and useCDs()  and isChecked("Racial")  then
                if player.buff.incarnationChoseOfElune.exists() or player.buff.celestialAlignment.exists() then
                    if castSpell("player",player.getRacial(),false,false,false) then return true end
                end
            end
            --actions+=/call_action_list,name=fury_of_elune,if=talent.fury_of_elune.enabled&cooldown.fury_of_elue.remains<target.time_to_die
            if player.talent.furyOfElune then
                if player.cd.furyOfElune < getTTD("target") then
                    if actionList_FuryOfElune() then return true end
                end
            end
            --actions+=/call_action_list,name=ed,if=equipped.the_emerald_dreamcatcher&active_enemies<=2
            if hasEquiped(137062) and #enemies.yards40 <= 2 then
                if actionList_EmeralDreamcatcher() then return true end
            end
            --actions+=/new_moon,if=(charges=2&recharge_time<5)|charges=3
            if (getCharges(player.spell.newMoon) == 2 and player.recharge.newMoon < 5) or getCharges(player.spell.newMoon) == 3 then
                if player.cast.newMoon() then return true end
            end
            --actions+=/half_moon,if=(charges=2&recharge_time<5)|charges=3|(target.time_to_die<15&charges=2)
            if (getCharges(player.spell.halfMoon) == 2 and player.recharge.halfMoon < 5) or (getCharges(player.spell.halfMoon) == 3) or (getTTD("target")<15 and getCharges(player.spell.halfMoon) == 2) then
                if player.cast.halfMoon() then return true end
            end
            --actions+=/full_moon,if=(charges=2&recharge_time<5)|charges=3|target.time_to_die<15
            if (getCharges(player.spell.fullMoon) == 2 and player.recharge.fullMoon < 5) or(getCharges(player.spell.fullMoon) == 3) or (getTTD("target")<15 and getCharges(player.spell.fullMoon) == 2) then
                if player.cast.fullMoon() then return true end
            end
            if multidot then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    --actions+=/stellar_flare,cycle_targets=1,max_cycle_targets=4,if=active_enemies<4&remains<7.2&astral_power>=15
                    if player.debuff.stellarFlare.count() <= getOptionValue("Stellar Flare targets") then
                        if player.talent.stellarFlare and astralPower >= 15 and player.debuff.stellarFlare.remain(thisUnit) < 7.2 and isValidUnit(thisUnit) then
                            if player.cast.stellarFlare(thisUnit, "aoe") then return true end
                        end
                    end
                    --actions+=/moonfire,cycle_targets=1,if=(talent.natures_balance.enabled&remains<3)|(remains<6.6&!talent.natures_balance.enabled)
                    if (player.talent.naturesBalance and player.debuff.moonfire.remain(thisUnit) < 3) or (player.debuff.moonfire.remain(thisUnit) < 6.6 and not player.talent.naturesBalance) then
                        if player.debuff.moonfire.remain(thisUnit) < player.gcd  and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) and isValidUnit(thisUnit) then
                            if player.cast.moonfire(thisUnit,"aoe") then return true end
                        end
                    end
                    --actions+=/sunfire,if=(talent.natures_balance.enabled&remains<3)|(remains<5.4&!talent.natures_balance.enabled)
                    if (player.talent.naturesBalance and player.debuff.sunfire.remain(thisUnit) < 3) or (player.debuff.sunfire.remain(thisUnit) < 5.4 and not player.talent.naturesBalance) then
                        if player.debuff.sunfire.remain(thisUnit) < player.gcd and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets")) and isValidUnit(thisUnit) then
                            if player.cast.sunfire(thisUnit,"aoe") then return true end
                        end
                    end
                end
            else
                if player.talent.stellarFlare and astralPower >= 15 and player.debuff.stellarFlare.remain() < 7.2 then
                    if player.debuff.stellarFlare.remain() < player.gcd and (player.debuff.stellarFlare.count() < getOptionValue("Stellar Flare targets")) then
                        if player.cast.stellarFlare() then return true end
                    end
                end
                if (player.talent.naturesBalance and player.debuff.moonfire.remain() < 3) or (player.debuff.moonfire.remain() < 6.6 and not player.talent.naturesBalance) then
                    if player.debuff.moonfire.remain() < player.gcd and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) then
                        if player.cast.moonfire() then return true end
                    end
                end
                if (player.talent.naturesBalance and player.debuff.sunfire.remain() < 3) or (player.debuff.sunfire.remain() < 5.4 and not player.talent.naturesBalance) then
                    if player.debuff.sunfire.remain() < player.gcd and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets"))  then
                        if player.cast.sunfire() then return true end
                    end
                end
            end

            --actions+=/astral_communion,if=astral_power.deficit>=75
            if player.talent.astralCommunion and astralPower <= 25 and useCDs()  and isChecked("Astral Communion") then
                if player.cast.astralCommunion() then return true end
            end
            --actions+=/incarnation,if=astral_power>=40
            if player.talent.incarnationChoseOfElune and astralPower >= 40 and player.cd.incarnationChoseOfElune == 0 and useCDs()  and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                if player.cast.celestialAlignment() then return true end
            end
            --actions+=/celestial_alignment,if=astral_power>=40
            if not player.talent.incarnationChoseOfElune and astralPower >= 40 and player.cd.celestialAlignment == 0 and useCDs()  and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                if player.cast.celestialAlignment() then return true end
            end

            --actions+=/starfall,if=buff.oneths_overconfidence.up
            if player.buff.onethsOverconfidence.exists() then
                if multidot then
                    if (astralPower >= 60) or (astralPower >= 40 and player.talent.soulOfTheForest) then
                        if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then return else if player.cast.starsurge() then return true end end
                    end
                else
                    if player.cast.starsurge() then return true end
                end
            end
            --actions+=/solar_wrath,if=buff.solar_empowerment.stack=3
            if player.buff.solarEmpowerment.stack() == 3 then
                if player.cast.solarWrath() then return true end
            end
            --actions+=/lunar_strike,if=buff.lunar_empowerment.stack=3
            if player.buff.lunarEmpowerment.stack() == 3 then
                if player.cast.lunarStrike() then return true end
            end
            --actions+=/call_action_list,name=celestial_alignment_phase,if=buff.celestial_alignment.up|buff.incarnation.up
            if player.buff.celestialAlignment.exists() or player.buff.incarnationChoseOfElune.exists() then
                if actionList_CelestialAlignmentPhase() then return true end
            end
            --actions+=/call_action_list,name=single_target
            if actionList_SingleTarget() then return true end
            return false
        end

        local function actionList_CombatMoving()
            --actions.single_target+=/starsurge,if=active_enemies<=2
            if #enemies.yards40 <= 2 or not multidot then
                if player.cast.starsurge() then return true end
            end
            if multidot then
                if (astralPower >= 60) or (astralPower >= 40 and player.talent.soulOfTheForest) then
                    if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then return else if player.cast.starsurge() then return true end end
                end
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (player.talent.naturesBalance and player.debuff.moonfire.remain(thisUnit) < 3) or (player.debuff.moonfire.remain(thisUnit) < 6.6 and not player.talent.naturesBalance) then
                        if player.debuff.moonfire.remain(thisUnit) < player.gcd  and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) and isValidUnit(thisUnit) then
                            if player.cast.moonfire(thisUnit,"aoe") then return true end
                        end
                    end
                    if (player.talent.naturesBalance and player.debuff.sunfire.remain(thisUnit) < 3) or (player.debuff.sunfire.remain(thisUnit) < 5.4 and not player.talent.naturesBalance) then
                        if player.debuff.sunfire.remain(thisUnit) < player.gcd and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets")) and isValidUnit(thisUnit)  then
                            if player.cast.sunfire(thisUnit,"aoe") then return true end
                        end
                    end
                end
            else
                if player.debuff.moonfire.remain() < 6.6  and (player.debuff.moonfire.count() < getOptionValue("Moonfire targets")) then
                    if player.debuff.moonfire.remain() < player.gcd then
                        if player.cast.moonfire() then return true end
                    end
                end
                if player.debuff.sunfire.remain() < 5.4  and (player.debuff.sunfire.count() < getOptionValue("Sunfire targets")) then
                    if player.debuff.sunfire.remain() < player.gcd then
                        if player.cast.sunfire() then return true end
                    end
                end
            end
            if player.buff.warriorOfElune.exists() then
                if player.cast.lunarStrike() then return true end
            end
            if player.buff.warriorOfElune.exists() then
                if player.cast.lunarStrike() then return true end
            end

            --just to do something
            if multidot then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if player.debuff.moonfire.remain(thisUnit) <= player.debuff.sunfire.remain(thisUnit) and isValidUnit(thisUnit) then
                        if player.cast.moonfire(thisUnit,"aoe") then return true end
                    elseif isValidUnit(thisUnit) then
                        if player.cast.sunfire(thisUnit,"aoe") then return true end
                    end
                end
            else
                if player.debuff.moonfire.remain() <= player.debuff.sunfire.remain() then
                    if player.cast.moonfire() then return true end
                else
                    if player.cast.sunfire() then return true end
                end
            end
            return false
        end

        local function actionList_Interrupts()
            if useInterrupts() and player.cd.solarBeam == 0 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt at")) then
                        if player.cast.solarBeam(thisUnit) then
                            if player.talent.massEntanglement then
                                if isChecked("Solar Beam + Mass Entanglement") then
                                    if player.cast.massEntanglement(thisUnit) then return true end
                                end
                            end
                        end
                    end
                end
            end
            return false
        end

        local function actionList_Defensive()
            if useDefensive() and not (flight or travel or IsMounted() or IsFlying()) and not player.buff.prowl.exists() then
                --Revive/Rebirth
                if isChecked("Rebirth") then
                    if getOptionValue("Rebirth - Target")== 1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
                        if player.cast.rebirth("target","dead") then return true end
                    end
                    if getOptionValue("Rebirth - Target")==2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
                        if player.cast.rebirth("mouseover","dead") then return true end
                    end
                end
                if isChecked("Revive") then
                    if getOptionValue("Revive - Target")==1 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
                        if player.cast.revive("target","dead") then return true end
                    end
                    if getOptionValue("Revive - Target")==2 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
                        if player.cast.revive("mouseover","dead") then return true end
                    end
                end
                -- Remove Corruption
                if isChecked("Remove Corruption") then
                    if getOptionValue("Remove Corruption - Target")==1 and canDispel("player",player.spell.removeCorruption) then
                        if player.cast.removeCorruption("player") then return true end
                    end
                    if getOptionValue("Remove Corruption - Target")==2 and canDispel("target",player.spell.removeCorruption) then
                        if player.cast.removeCorruption("target") then return true end
                    end
                    if getOptionValue("Remove Corruption - Target")==3 and canDispel("mouseover",player.spell.removeCorruption) then
                        if player.cast.removeCorruption("mouseover") then return true end
                    end
                end
                -- Renewal
                if isChecked("Renewal") and player.health <= getOptionValue("Renewal") and player.inCombat then
                    if player.cast.renewal() then return true end
                end
                -- Swiftmend
                if isChecked("Swiftmend") and player.health <= getOptionValue("Swiftmend") and player.inCombat then
                    if player.cast.swiftmend() then return true end
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
                            player.cast.balanceForm()
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
                if isChecked("Pot/Stoned") and player.health <= getOptionValue("Pot/Stoned") and player.inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(getHealthPot()) then
                        useItem(getHealthPot())
                    end
                end
                -- Heirloom Neck
                if isChecked("Heirloom Neck") and player.health <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
                -- Engineering: Shield-o-tronic
                if isChecked("Shield-o-tronic") and player.health <= getOptionValue("Shield-o-tronic")
                        and inCombat and canUse(118006)
                then
                    useItem(118006)
                end
                -- Regrowth
                if isChecked("Regrowth") then
                    if player.inCombat and getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40
                            and ((getHP(br.friend[1].unit) <= getOptionValue("Regrowth")/2 and player.inCombat)
                            or (getHP(br.friend[1].unit) <= getOptionValue("Regrowth") and not player.inCombat))
                    then
                        if player.cast.regrowth(br.friend[1].unit) then return true end
                    end
                    if (getOptionValue("Auto Heal")==2 or not player.inCombat) and player.health <= getOptionValue("Regrowth") then
                        if player.cast.regrowth("player") then return true end
                    end
                end
                -- Rejuvenation
                if isChecked("Rejuvenation") and not player.buff.rejuvenation.exists() then
                    if player.inCombat and getOptionValue("Auto Heal")==1 and getDistance(br.friend[1].unit) < 40
                            and ((getHP(br.friend[1].unit) <= getOptionValue("Rejuvenation")/2 and player.inCombat)
                            or (getHP(br.friend[1].unit) <= getOptionValue("Rejuvenation") and not player.inCombat))
                    then
                        if player.cast.rejuvenation(br.friend[1].unit) then return true end
                    end
                    if (getOptionValue("Auto Heal")==2 or not player.inCombat) and player.health <= getOptionValue("Rejuvenation") then
                        if player.cast.rejuvenation("player") then return true end
                    end
                end
                -- Barkskin
                if isChecked("Barkskin") and player.health <= getOptionValue("Barkskin")
                        and player.inCombat and not player.buff.barkskin.exists() and player.cd.barkskin == 0
                then
                    if player.cast.barkskin() then return true end
                end
            end -- End Defensive Toggle
            return false
        end

        local function actionList_OpenerDefault()
            if isValidUnit("target") and opener == false then
                if (isChecked("Pre-Pull Timer") and (pullTimer <= getOptionValue("Pre-Pull Timer") or (pullTimer == 999 and SW))) or not isChecked("Pre-Pull Timer") or player.inCombat then
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
                        if getCharges(player.spell.newMoon) > 0 then
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
                        --Astral Communion
                    elseif not AC and useCDs() and isChecked("Astral Communion") and astralPower <= 20 then
                        if player.cd.astralCommunion == 0 then
                            castOpener("astralCommunion","AC","3.5")
                        else
                            Print("3.5: Astral Communion (Not Casted: Cooldown)")
                            AC = true
                        end
                        --Sunfire
                    elseif not SF then
                        castOpener("sunfire","SF",4)
                        --Celestial Alignment | Incarnation
                    elseif not CA and useCDs() and isChecked("Incarnation: Chosen of Elune/Celestial Alignament") then
                        if (player.talent.incarnationChoseOfElune and player.cd.incarnationChoseOfElune == 0) or (not player.talent.incarnationChoseOfElune and player.cd.celestialAlignment == 0) then
                            castOpener("celestialAlignment","CA",5)
                        else
                            Print("5: Incarnation: Chosen of Elune/Celestial Alignament (Not Casted: Cooldown)")
                            CA = true
                        end
                        --Racial
                    elseif not RA and  (player.race == "Orc" or player.race == "Troll") and useCDs()  and isChecked("Racial") then
                        if getSpellCD(player.getRacial()) == 0 then
                            if castSpell("player",player.getRacial(),false,false,false) then
                                Print("5.5: Racial")
                                RA = true
                            end
                        else
                            RA = true
                            Print("5.5: Racial (Not Casted: Cooldown)")
                        end
                        -- Starsurge
                    elseif astralPower == 99 or astralPower == 59 then
                        if player.cast.starfall("best", nil, getOptionValue("Starfall targets"), starfallRadius) then Print("5.55: Starfall") return else if player.cast.starsurge() then Print("5.55: Starsurge") return true end end
                        -- New Moon | Half Moon | Full Moon
                    elseif not MM2 then
                        if getCharges(player.spell.newMoon) > 0 then
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
                        if getCharges(player.spell.newMoon) > 0 then
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

        local function actionList_Opener()
            --            if hasEquiped(137062) then
            --                actionList_OpenerEmealdDreamCatcher()
            --            else
            if actionList_OpenerDefault() then return true end
            --            end
            return false
        end

        local function deadlyChicken()
            for i = 1, ObjectCount() do
                -- define our unit
                local thisUnit = GetObjectWithIndex(i)
                -- check if it a unit first
                if ObjectIsType(thisUnit, ObjectTypes.Unit)  then
                    br.debug.cpu.enemiesEngine.unitTargets = br.debug.cpu.enemiesEngine.unitTargets + 1
                    -- sanity checks
                    if ObjectExists(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and not UnitIsFriend(thisUnit, "player") and UnitCanAttack("player",thisUnit) and getDistance(thisUnit) < 40 and getLineOfSight("player", thisUnit)
                    then
                        if player.debuff.sunfire.remain(thisUnit) == 0 then
                            if isChecked("Deadly Chicken - DONT KILL BOSS") then
                                if not isBoss(thisUnit) then
                                    CastSpellByName(GetSpellInfo(player.spell.sunfire),thisUnit)
                                    return
                                end
                            else
                                CastSpellByName(GetSpellInfo(player.spell.sunfire),thisUnit)
                                return
                            end
                        end
                    end
                end
            end
        end



        if actionList_Extras() then return true end
        if actionList_PreCombat() then return true end
        ---------------------
        --- Begin Profile ---
        ---------------------
        -- Profile Stop | Pause
        if not player.inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (player.inCombat and profileStop==true) or pause() or (IsMounted() or IsFlying()) or player.mode.rotation==4 then
            return true
        else
            -----------------------
            --- Opener Rotation ---
            -----------------------
            if opener == false and isChecked("Opener") and isBoss("target") then
                if isChecked("Pre-Pull Timer") and player.inCombat and getCombatTime() > 10 then
                    opener = true;
                    return
                end
                if actionList_Opener() then return true end
            elseif isChecked("Deadly Chicken") then
                deadlyChicken()
            elseif player.inCombat and profileStop==false and isValidUnit(units.dyn40) and (opener == true or not isChecked("Opener") or not isBoss("target")) then
                if not(moving and player.buff.dash.exists()) then
                    if actionList_Interrupts() then return true end
                    if actionList_Defensive() then return true end
                    if (not isMoving("player") or player.buff.stellarDrift.exists()) then
                        if actionList_Combat() then return true end
                    elseif isMoving("player") then
                        if actionList_CombatMoving() then return true end
                    end
                end
            end
            return
        end--End Pause
        return false
    end -- End Timer
end-- End runRotation
local id = 102

if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

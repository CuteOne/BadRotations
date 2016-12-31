local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.howlingBlast },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.howlingBlast },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.frostStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathStrike}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.empowerRuneWeapon },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.empowerRuneWeapon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.empowerRuneWeapon }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceboundFortitude }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Artifact 
            br.ui:createDropdownWithout(section, "Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")            
            br.ui:createSpinnerWithout(section, "Artifact Units",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Singragosa's Fury on. Min: 1 / Max: 10 / Interval: 1")           
            -- Death Grip
            br.ui:createCheckbox(section,"Death Grip")
            -- Glacial Advance
            br.ui:createSpinner(section, "Glacial Advance",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Glacial Advance on. Min: 1 / Max: 10 / Interval: 1") 
            -- Path of Frost
            br.ui:createCheckbox(section,"Path of Frost")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Strength Potion
            br.ui:createCheckbox(section,"Potion")
            -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Breath of Sindragosa
            br.ui:createCheckbox(section,"Breath of Sindragosa")
            -- Empower Rune Weapon
            br.ui:createCheckbox(section,"Empower/Hungering Rune Weapon")
            -- Obliteration
            br.ui:createCheckbox(section,"Obliteration")
            -- Pillar of Frost
            br.ui:createCheckbox(section,"Pillar of Frost")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Anti-Magic Shell
            br.ui:createSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Blinding Sleet
            br.ui:createSpinner(section, "Blinding Sleet",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Anti-Magic Zone
            -- br.ui:createCheckbox(section,"Anti-Magic Zone - Int")
            -- Blinding Sleet
            -- br.ui:createCheckbox(section,"Blinding Sleet - Int")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdownWithout(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugFrost", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
--------------
--- Locals ---
--------------
        local attacktar         = UnitCanAttack("target", "player")
        local buff              = br.player.buff
        local cast              = br.player.cast
        local cd                = br.player.cd
        local charges           = br.player.charges
        local deadtar           = UnitIsDeadOrGhost("target") or isDummy()
        local debuff            = br.player.debuff
        local enemies           = br.player.enemies
        local gcd               = br.player.gcd
        local glyph             = br.player.glyph
        local inCombat          = br.player.inCombat
        local level             = br.player.level
        local mode              = br.player.mode
        local moving            = GetUnitSpeed("player")>0
        local php               = br.player.health
        local power             = br.player.power
        local pullTimer         = br.DBM:getPulltimer()
        local runicPower        = br.player.power.amount.runicPower
        local runicPowerDeficit = br.player.power.runicPower.deficit
        local runes             = br.player.power.runes.frac
        local swimming          = IsSwimming()
        local talent            = br.player.talent
        local units             = br.player.units

    -- Profile Stop
        if profileStop == nil then profileStop = false end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        profileStop = true
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        return true
                    end
                end
            end
        -- Chains of Ice
            if isChecked("Chains of Ice") then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if not debuff.chainsOfIce[thisUnit].exists and not getFacing(thisUnit,"player") and getFacing("player",thisUnit) 
                        and isMoving(thisUnit) and getDistance(thisUnit) > 8 and inCombat 
                    then
                        if cast.chainsOfIce(thisUnit) then return end
                    end
                end
            end
        -- Death Grip
            if isChecked("Death Grip") then
                if inCombat and isValidUnit(units.dyn30) and getDistance(units.dyn30) > 8 and not isDummy(units.dyn30) then
                    if cast.deathGrip(units.dyn30) then return end
                end
            end
        -- Path of Frost
            if isChecked("Path of Frost") then
                if not inCombat and swimming and not buff.pathOfFrost.exists then
                    if cast.pathOfFrost() then return end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() and not IsMounted() then
        -- Anti-Magic Shell
                if isChecked("Anti-Magic Shell") and php < getOptionValue("Anti-Magic Shell") and inCombat then
                    if cast.antiMagicShell() then return end
                end
        -- Blinding Sleet
                if isChecked("Blinding Sleet") and php < getOptionValue("Blinding Sleet") and inCombat then
                    if cast.blindingSleet() then return end
                end
        -- Death Strike
                if isChecked("Death Strike") and (buff.darkSuccor or php < getOptionValue("Death Strike")) and inCombat then
                    if cast.deathStrike() then return end
                end
        -- Icebound Fortitude
                if isChecked("Icebound Fortitude") and php < getOptionValue("Icebound Fortitude") and inCombat then
                    if cast.iceboundFortitude() then return end
                end
        -- Raise Ally
                if isChecked("Raise Ally") then
                    if getOptionValue("Raise Ally - Target")==1
                        and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                    then
                        if cast.raiseAlly("target","dead") then return end
                    end
                    if getOptionValue("Raise Ally - Target")==2
                        and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                    then
                        if cast.raiseAlly("mouseover","dead") then return end
                    end
                end 
            end -- End Use Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
        -- Mind Freeze
                if isChecked("Mind Freeze") then
                    for i=1, #enemies.yards15 do
                        thisUnit = enemies.yards15[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if cast.mindFreeze(thisUnit) then return end
                        end
                    end
                end
            end -- End Use Interrupts Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if useCDs() and getDistance(units.dyn5) < 5 then
        -- Pillar of Frost
                -- pillar_of_frost
                if isChecked("Pillar of Frost") then
                    if cast.pillarOfFrost() then return end
                end
        -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end                
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- arcane_torrent,if=runic_power.deficit>20
                -- blood_fury,if=!talent.breath_of_sindragosa.enabled|dot.breath_of_sindragosa.ticking
                -- berserking,if=buff.pillar_of_frost.up
                if ((br.player.race == "Orc" and (not talent.breathOfSindragosa or not buff.breathOfSingragosa)) 
                    or (br.player.race == "Troll" and buff.pillarOfFrost.exist) 
                    or (br.player.race == "Blood Elf" and runicPowerDeficit > 20)) 
                then
                    if br.player.castRacial() then return end
                end
        -- Potion
                -- potion,name=draenic_strength,if=target.time_to_die<=30|(target.time_to_die<=60&buff.pillar_of_frost.up)
                if raid and (getTimeToDie(units.dyn5)<=30 or (getTimeToDie(units.dyn5) <= 60 and buff.pillarOfFrost.exists)) then
                    -- Draenic Strength Potion
                    if isChecked("Str-Pot") and canUse(109219) then
                        useItem(109219)
                    end
                    -- -- Commander's Draenic Strength Potion
                    -- if canUse(br.player.spell.strengthPotGarrison) then
                    --     useItem(br.player.spell.strengthPotGarrison)
                    -- end
                end
            end -- End Use Cooldowns Check
        end -- End Action List - Cooldowns
    -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Flask / Crystal
            -- flask,name=countless_armies
            if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
                if (raid or solo) and not (buff.strenthFlaskLow or buff.strengthFlaskBig) then--Draenor Str Flasks
                    if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
                        if br.player.useCrystal() then return end
                    end
                end
            end
        -- Food
            -- food,type=food,name=fishbrul_special
            -- TODO
        -- Augmentation
            -- augmentation,name=defiled
            -- TODO
        -- Potion
            -- potion,name=old_war
            -- TODO
        -- Pre-pull
            if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

            end -- Pre-Pull
        -- Start Attack
            if isValidUnit("target") and not inCombat then
                StartAttack()
            end
        end -- End Action List - PreCombat
    -- Action List - Breath of Sindragosa
        function actionList_BreathOfSindragosa()
        -- Howling Blast
            -- howling_blast,target_if=!dot.frost_fever.ticking
            if debuff.frostFever[units.dyn30] ~= nil and not debuff.frostFever[units.dyn30].exists then
                if cast.howlingBlast() then return end
            end
        -- Breath of Sindragosa
            -- breath_of_sindragosa,if=runic_power>=50
            if useCDs() then
                if runicPower >= 50 then
                    if cast.breathOfSindragosa() then return end
                end
            end
        -- Frost Strike
            -- frost_strike,if=!dot.breath_of_sindragosa.ticking&cooldown.breath_of_sindragosa.remains>15&buff.icy_talons.remains<=gcd
            if not buff.breathOfSindragosa.exists and cd.breathOfSindragosa > 15 and buff.icyTalons.remain <= gcd then
                if cast.frostStrike() then return end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.react&runic_power>40&dot.breath_of_sindragosa.ticking
            -- howling_blast,if=buff.rime.react&!dot.breath_of_sindragosa.ticking
            if buff.rime.exists and ((runicPower > 40 and buff.breathOfSindragosa.exists) or not buff.breathOfSindragosa.exists) then
                if cast.howlingBlast() then return end
            end
        -- Obliterate
            -- obliterate,if=dot.breath_of_sindragosa.ticking&runic_power<70
            -- obliterate,if=dot.breath_of_sindragosa.ticking&rune>=3
            -- obliterate,if=!dot.breath_of_sindragosa.ticking
            if (buff.breathOfSindragosa.exists and (runicPower < 70 or runes >= 3)) or not buff.breathOfSindragosa then
                if cast.obliterate() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=!dot.breath_of_sindragosa.ticking
            if not buff.breathOfSindragosa.exists then
                if cast.remorselessWinter() then return end
            end
        -- Frost Strike
            -- frost_strike,if=!dot.breath_of_sindragosa.ticking&cooldown.breath_of_sindragosa.remains>15
            if not buff.breathOfSindragosa.exists and cd.breathOfSindragosa > 15 then
                if cast.frostStrike() then return end
            end
        -- Horn of Winter
            -- horn_of_winter
            if cast.hornOfWinter() then return end
            if isChecked("Empower/Hungering Rune Weapon") and useCDs() then
        -- Empower Rune Weapon
                -- empower_rune_weapon,if=runic_power<=40
                if runicPower <= 40 and runes < 1 then
                    if cast.empowerRuneWeapon() then return end
                end
        -- Hungering Rune Weapon
                -- hungering_rune_weapon,if=runic_power<=40
                if runicPower <= 40 and runes < 1 then
                    if cast.hungeringRuneWeapon() then return end
                end
            end
        end
    -- Action List - Core
        function actionList_Core()
        -- Frost Strike
            -- frost_strike,if=buff.obliteration.up&!buff.killing_machine.react
            if buff.obliteration.exists and not buff.killingMachine.exists then
                if cast.frostStrike() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=(spell_targets.remorseless_winter>=2|talent.gathering_storm.enabled)&!talent.frozen_pulse.enabled
            if (#enemies.yards25 >= 2 or talent.gatheringStorm) and not talent.frozenPulse then
                if cast.remorselessWinter() then return end
            end
        -- Frostscythe
            -- frostscythe,if=!talent.breath_of_sindragosa.enabled&(buff.killing_machine.react|spell_targets.frostscythe>=4)
            if not talent.breathOfSindragosa and (buff.killingMachine.exists or #enemies.yards8 >= 4) and getFacing("player",units.dyn8) then
                if cast.frostscythe() then return end
            end
        -- Glacial Advance
            -- glacial_advance
            if isChecked("Glacial Advance") and #enemies.yards15 >= getOptionValue("Glacial Advance") and getFacing("player",units.dyn15) then
                if cast.glacialAdvance() then return end
            end
        -- Obliterate
            -- obliterate,if=buff.killing_machine.react
            if buff.killingMachine.exists then
                if cast.obliterate() then return end
            end 
            -- obliterate
            if cast.obliterate() then return end
        end
    -- Action List - Storm
        function actionList_Storm()
        -- Frost Strike
            -- frost_strike,if=buff.icy_talons.remains<=gcd|runic_power>=70
            if buff.icyTalons.remain <= gcd or runicPower >= 70 then
                if cast.frostStrike() then return end
            end
        -- Howling Blast
            -- howling_blast,target_if=!dot.frost_fever.ticking&buff.icy_talons.remains>=gcd+0.1
            if debuff.frostFever[units.dyn30] ~= nil and not debuff.frostFever[units.dyn30].exists and buff.icyTalons.remain >= gcd + 0.1 then
                if cast.howlingBlast() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=rune>=3&buff.icy_talons.remains>=gcd+0.1
            if runes >= 3 and buff.icyTalons.remain >= gcd + 0.1 then
                if cast.remorselessWinter() then return end
            end
        -- Howling Blast
            -- howling_blast,if=buff.rime.react&buff.icy_talons.remains>=gcd+0.1
            if buff.rime.exists and buff.icyTalons.remain >= gcd + 0.1 then
                if cast.howlingBlast() then return end
            end
        -- Obliterate
            -- obliterate,if=buff.killing_machine.react&buff.icy_talons.remains>=gcd+0.1
            if buff.killingMachine.exists and buff.icyTalons.remain >= gcd + 0.1 then
                if cast.obliterate() then return end
            end
        -- Glacial Advance
            -- glacial_advance,if=buff.icy_talons.remains>=gcd+0.1
            if isChecked("Glacial Advance") and #enemies.yards15 >= getOptionValue("Glacial Advance") and getFacing("player",units.dyn15) then
                if buff.icyTalons.remain >= gcd + 0.01 then
                    if cast.glacialAdvance() then return end
                end
            end
        -- Obliterate
            -- obliterate,if=(cooldown.remorseless_winter.remains>2|dot.remorseless_winter.ticking|rune>=3)&buff.icy_talons.remains>=gcd+0.1
            if (cd.remorselessWinter > 2 or debuff.remorselessWinter[units.dyn25].exists or runes >= 3) and buff.icyTalons.remain >= gcd + 0.1 then
                if cast.obliterate() then return end
            end
        -- Frost Strike
            -- frost_strike,if=buff.icy_talons.stack<3
            if buff.icyTalons.stack < 3 then
                if cast.frostStrike() then return end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=rune>=3
            if runes >= 3 then
                if cast.remorselessWinter() then return end
            end
        -- Glacial Advance
            -- glacial_advance
            if isChecked("Glacial Advance") and #enemies.yards15 >= getOptionValue("Glacial Advance") and getFacing("player",units.dyn15) then
                if cast.glacialAdvance() then return end
            end
        -- Obliterate
            -- obliterate,if=cooldown.remorseless_winter.remains>2|dot.remorseless_winter.ticking|rune>=3
            if cd.remorselessWinter > 2 or debuff.remorselessWinter[units.dyn25].exists or runes >= 3 then
                if cast.obliterate() then return end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power>=40
            if runicPower >= 40 then
                if cast.frostStrike() then return end
            end
        -- Horn of Winter
            -- horn_of_winter,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
            -- horn_of_winter,if=!talent.breath_of_sindragosa.enabled
            if (talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa then
                if cast.hornOfWinter() then return end
            end
            if isChecked("Empower/Hungering Rune Weapon") and useCDs() then
        -- Empower Rune Weapon
                -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- empower_rune_weapon,if=!talent.breath_of_sindragosa.enabled
                if ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) and runes < 1 then
                    if cast.empowerRuneWeapon() then return end
                end
        -- Hungering Rune Weapon
                -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- hungering_rune_weapon,if=!talent.breath_of_sindragosa.enabled
                if ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) and runes < 1 then
                    if cast.hungeringRuneWeapon() then return end
                end
            end
        end
    -- Action List - Generic
        function actionList_Generic()
        -- Howling Blast
            -- howling_blast,target_if=!dot.frost_fever.ticking
            -- howling_blast,if=buff.rime.react
            if debuff.frostFever[units.dyn30] ~= nil and not debuff.frostFever[units.dyn30].exists or buff.rime.exists then
                if cast.howlingBlast() then return end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power>=80
            if runicPower >= 80 then
                if cast.frostStrike() then return end
            end
        -- Call Action - Core
            -- call_action_list,name=core
            if actionList_Core() then return end
        -- Horn of Winter
            -- horn_of_winter,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
            -- horn_of_winter,if=!talent.breath_of_sindragosa.enabled
            if (talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa then
                if cast.hornOfWinter() then return end
            end
        -- Frost Strike
            -- frost_strike,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
            -- frost_strike,if=!talent.breath_of_sindragosa.enabled
            if (talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa then
                if cast.frostStrike() then return end
            end
            if isChecked("Empower/Hungering Rune Weapon") and useCDs() then
        -- Empower Rune Weapon
                -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- empower_rune_weapon,if=!talent.breath_of_sindragosa.enabled
                if ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) and runes < 1 then
                    if cast.empowerRuneWeapon() then return end
                end
        -- Hungering Rune Weapon
                -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- hungering_rune_weapon,if=!talent.breath_of_sindragosa.enabled
                if ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) and runes < 1 then
                    if cast.hungeringRuneWeapon() then return end
                end
            end
        end
    -- Action List - Machine Gun
        function actionList_Machinegun()
        -- Frost Strike
            -- frost_strike,if=buff.icy_talons.remains<=gcd|runic_power>=80
            if buff.icyTalons.remain <= gcd or runicPower >= 80 then
                if cast.frostStrike() then return end
            end
        -- Howling Blast
            -- howling_blast,target_if=!dot.frost_fever.ticking&buff.icy_talons.remains>=gcd+0.1
            -- howling_blast,if=buff.rime.up&!buff.obliteration.up
            if (debuff.frostFever[units.dyn30] ~= nil and not debuff.frostFever[units.dyn30].exists and buff.icyTalons.remain >= gcd + 0.1) or buff.rime.exists or not buff.obliteration.exists then
                if cast.howlingBlast() then return end
            end
        -- Obliteration
            -- obliteration,if=rune>=2&runic_power>=25
            if isChecked("Obliteration") and useCDs() then
                if runes >= 2 and runicPower >= 25 then
                    if cast.obliteration() then return end
                end
            end
        -- Frost Strike
            -- frost_strike,if=buff.obliteration.up&!buff.killing_machine.up
            if buff.obliteration.exists and not buff.killingMachine.exists then
                if cast.frostStrike() then return end
            end
        -- Obliterate
            -- obliterate,if=buff.icy_talons.remains>gcd+0.1&buff.killing_machine.up&runic_power<15&buff.obliteration.remains>=gcd+01
            if buff.icyTalons.remain > gcd + 0.1 and buff.killingMachine.exists and runicPower < 15 and buff.obliteration.remain >= gcd + 0.1 then
                if cast.obliterate() then return end
            end
        -- Frostscythe
            -- frostscythe,if=buff.icy_talons.remains>=gcd+0.1&buff.killing_machine.up&rune=1
            if buff.icyTalons.remain >= gcd + 0.1 and buff.killingMachine.exists and runes == 1 and getFacing("player",units.dyn8) then
                if cast.frostscythe() then return end
            end
        -- Obliterate
            -- obliterate,if=buff.icy_talons.remains>gcd+0.1
            if buff.icyTalons.remain > gcd + 0.1 then
                if cast.obliterate() then return end
            end
        -- Glacial Advance
            -- glacial_advance,if=buff.icy_talons.remains>=gcd+0.1
            if isChecked("Glacial Advance") and #enemies.yards15 >= getOptionValue("Glacial Advance") and getFacing("player",units.dyn15) then
                if buff.icyTalons.remain > gcd + 0.1 then
                    if cast.glacialAdvance() then return end
                end
            end
        -- Remorseless Winter
            -- remorseless_winter,if=buff.icy_talons.remains>=gcd+0.1&!buff.killing_machine.up
            if buff.icyTalons.remain > gcd + 0.1 and not buff.killingMachine.exists then
                if cast.remorselessWinter() then return end
            end
        -- Frost Strike
            -- frost_strike,if=buff.icy_talons.stack<3
            if buff.icyTalons.remain > gcd + 0.1 then
                if cast.frostStrike() then return end
            end
        -- Obliterate
            -- obliterate
            if cast.obliterate() then return end
        -- Glacial Advance
            -- glacial_advance
            if isChecked("Glacial Advance") and #enemies.yards15 >= getOptionValue("Glacial Advance") and getFacing("player",units.dyn15) then
                if cast.glacialAdvance() then return end
            end
        -- Remorseless Winder
            -- remorseless_winter,if=!buff.killing_machine.up
            if not buff.killingMachine.exists then
                if cast.remorselessWinter() then return end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power>=40&talent.runic_attenuation.enabled
            -- frost_strike,if=runic_power>=50
            if (runicPower >= 40 and talent.runicAttenuation) or runicPower >= 50 then
                if cast.frostStrike() then return end
            end
        -- Horn of Winter
            -- horn_of_winter,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
            -- horn_of_winter,if=!talent.breath_of_sindragosa.enabled
            if (talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa then
                if cast.hornOfWinter() then return end
            end
            if isChecked("Empower/Hungering Rune Weapon") and useCDs() then
        -- Empowering Rune Weapoon
                -- empower_rune_weapon,if=rune<1&runic_power<40&talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- empower_rune_weapon,if=rune<1&runic_power<40&!talent.breath_of_sindragosa.enabled
                if runes < 1 and runicPower < 40 and ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) then
                    if cast.empowerRuneWeapon() then return end
                end
        -- Hungering Rune Weapoon
                -- hungering_rune_weapon,if=rune<1&runic_power<40&talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- hungering_rune_weapon,if=rune<1&runic_power<40&!talent.breath_of_sindragosa.enabled
                if runes < 1 and runicPower < 40 and ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) then
                    if cast.hungeringRuneWeapon() then return end
                end
            end
        end
    -- Action List - Shatter
        function actionList_Shatter()
        -- Frost Strike
            -- frost_strike,if=debuff.razorice.stack=5
            if debuff.razorice[units.dyn5].stack == 5 then
                if cast.frostStrike() then return end
            end
        -- Howling Blast
            -- howling_blast,target_if=!dot.frost_fever.ticking
            -- howling_blast,if=buff.rime.react
            if debuff.frostFever[units.dyn30] ~= nil and not debuff.frostFever[units.dyn5].exists or buff.rime.exists then
                if cast.howlingBlast() then return end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power>=80
            if runicPower >= 80 then
                if cast.frostStrike() then return end
            end
        -- Call Action List - Core
            -- call_action_list,name=core
            if actionList_Core() then return end
        -- Horn of Winter
            -- horn_of_winter,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
            -- horn_of_winter,if=!talent.breath_of_sindragosa.enabled
            if (talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa then
                if cast.hornOfWinter() then return end
            end
        -- Frost Strike
            -- frost_strike,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
            -- frost_strike,if=!talent.breath_of_sindragosa.enabled
            if (talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa then
                if cast.frostStrike() then return end
            end
            if isChecked("Empower/Hungering Rune Weapon") and useCDs() then
        -- Empower Rune Weapon
                -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- empower_rune_weapon,if=!talent.breath_of_sindragosa.enabled
                if ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) and runes < 1 then
                    if cast.empowerRuneWeapon() then return end
                end
        -- Hungering Rune Weapon
                -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
                -- hungering_rune_weapon,if=!talent.breath_of_sindragosa.enabled
                if ((talent.breathOfSindragosa and cd.breathOfSindragosa > 15) or not talent.breathOfSindragosa) and runes < 1 then
                    if cast.hungeringRuneWeapon() then return end
                end
            end
        end 
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
            return true
        else
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- Cat is 4 fyte!
            if inCombat and profileStop==false and isValidUnit(units.dyn5) then
                -- auto_attack
                if getDistance(units.dyn5) < 5 then
                    StartAttack()
                end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
                if actionList_Cooldowns() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
        -- Singragosa's Fury
                    -- sindragosas_fury,if=buff.pillar_of_frost.up&debuff.razorice.stack=5&buff.unholy_strength.up
                    if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                        if buff.pillarOfFrost.exists and debuff.razorice[units.dyn5].stack == 5 and buff.unholyStrength.exists 
                            and #enemies.yards40 >= getOptionValue("Artifact Units") and getFacing("player",units.dyn8) 
                        then
                            if cast.sindragosasFury() then return end
                        end
                    end
        -- Obliteration
                    -- obliteration,if=(!talent.runic_attenuation.enabled&!talent.icy_talons.enabled)
                    if isChecked("Obliteration") and useCDs() then
                        if not talent.runicAttenuation and not talent.icyTalons then
                            if cast.obliteration() then return end
                        end
                    end 
        -- Breath of Sindragosa
                    -- call_action_list,name=bos,if=talent.breath_of_sindragosa.enabled
                    if isChecked("Breath of Sindragosa") then
                        if talent.breathOfSindragosa then
                            if actionList_BreathOfSindragosa() then return end
                        end
                    end
        -- Shatter
                    -- call_action_list,name=shatter,if=talent.shattering_strikes.enabled
                    if talent.shatteringStrikes then
                        if actionList_Shatter() then return end
                    end
        -- Storm
                    -- call_action_list,name=storm,if=talent.gathering_storm.enabled
                    if talent.gatheringStorm then
                        if actionList_Storm() then return end
                    end
        -- Machinegun
                    -- call_action_list,name=machinegun,if=(talent.icy_talons.enabled&(talent.runic_attenuation.enabled|talent.frostscythe.enabled))
                    if (talent.icyTalons and (talent.runicAttenuation or talent.frostscythe)) then
                        if actionList_Machinegun() then return end
                    end
        -- Generic
                    -- call_action_list,name=generic,if=(!talent.shattering_strikes.enabled&!talent.icy_talons.enabled)
                    if (not talent.shatteringStrikes and not talent.icyTalons) or level < 90 then
                        if actionList_Generic() then return end
                    end
                end -- End Simc APL 
            end -- End Combat Check
        end -- End Rotation Pause
    end -- End Timer
end -- runRotation
local id = 251
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

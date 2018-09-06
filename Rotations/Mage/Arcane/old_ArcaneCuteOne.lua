local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.arcaneMissles},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.arcaneExplosion},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneBlast},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.arcanePower},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.arcanePower},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.arcanePower}
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.frostNova},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.frostNova}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Arcane Charges During Conserve
            br.ui:createSpinnerWithout(section, "Arcane Charges During Conserve", 1, 1, 4, 1, "|cffFFFFFFSet to desired Arcane Charges to use during Conserve Phase.")
        -- Arcane Explosion
            br.ui:createSpinnerWithout(section, "Arcane Explosion", 5, 1, 10, 1, "|cffFFFFFFSet to desired units to use Arcane Explosion.")
        -- Burn Phase Debug
            br.ui:createCheckbox(section, "Burn Phase Debug", "|cffFFFFFFShow burn phase status and duration, requires Chat Overlay option to be enabled.")
        -- -- Burn Phase Start
        --     br.ui:createSpinnerWithout(section, "Burn Phase Start", 70, 0, 100, 5, "|cffFFFFFFSet to desired mana percent to start burn phase.")
        -- -- Burn Phase End
        --     br.ui:createSpinnerWithout(section, "Burn Phase End", 35, 0, 100, 5, "|cffFFFFFFSet to desired mana percent to stop burn phase.")
        -- -- Evocation
        --     br.ui:createSpinnerWithout(section, "Evocation", 40, 0, 100, 5, "|cffFFFFFFSet to desired mana percent to use evocation at.")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Potion
            br.ui:createCheckbox(section,"Potion")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Arcane Power
            br.ui:createCheckbox(section,"Arcane Power")
        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")
        -- Rune of Power
            br.ui:createCheckbox(section,"Rune of Power")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Frost Nova
            br.ui:createSpinner(section, "Frost Nova",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Couterspell
            br.ui:createCheckbox(section, "Counterspell")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugArcane", math.random(0.15,0.3)) then
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
        local addsExist                                     = false
        local addsIn                                        = 999
        local arcaneCharges                                 = br.player.power.arcaneCharges.amount()
        local arcaneChargesMax                              = br.player.power.arcaneCharges.max()
        local activePet                                     = br.player.pet
        local activePetId                                   = br.player.petId
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local hasPet                                        = IsPetActive()
        local hasteAmount                                   = GetHaste()/100
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local moveIn                                        = 999
        local moving                                        = isMoving("player")
        local perk                                          = br.player.perk
        local petInfo                                       = br.player.petInfo
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen, br.player.power.mana.deficit()
        local manaPercent                                   = br.player.power.mana.percent()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local t20_2pc                                       = TierScan("T20") >= 2
        local t20_4pc                                       = TierScan("T20") >= 4
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local dt                                            = date("%H:%M:%S")
        local debug                                         = false

        units.get(40)
        enemies.get(10)
        enemies.get(12)
        enemies.get(30)
        enemies.get(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if talent.overpowered or not buff.arcanePower.exists() then overArcaned = 1 else overArcaned = 0 end
        if hasEquiped(132451) then runeMaster = 1 else runeMaster = 0 end
        if phaseMode == nil or (not inCombat and not isDummy()) then phaseMode = "None" end
        if castArtifact == nil or (not inCombat and not isDummy()) then castArtifact = false end
        if castArtifact == true and buff.runeOfPower.exists() then castArtifact = false end

-----------------
--- Variables ---
-----------------
    -- Burn Phase Mechanics
        if burnPhase == nil or (not inCombat and not isDummy()) then burnPhase = false end
        if burnPhaseStart == nil or (not inCombat and not isDummy()) then burnPhaseStart = 0 end
        if burnPhaseDuration == nil or (not inCombat and not isDummy()) then burnPhaseDuration = 0 end
        if totalBurns == nil or (not inCombat and not isDummy()) then totalBurns = 0; priorBurnCount = 0 end
        if not burnPhase then priorBurnCount = totalBurns end
        if averageBurnLength == nil or (not inCombat and not isDummy()) then averageBurnLength = 0 end
    -- -- Total Burns
    --     -- variable,name=total_burns,op=add,value=1,if=!burn_phase
    --     if not burnPhase and arcaneCharges == 4 and timeUntilBurn == 0 and cd.evocation.remain() ~= 0 then
    --         totalBurns = totalBurns + 1
    --     end
        if burnPhase and priorBurnCount == totalBurns then totalBurns = totalBurns + 1 end
    -- Average Burn Length
        -- variable,name=average_burn_length,op=set,value=(variable.average_burn_length*variable.total_burns-variable.average_burn_length+burn_phase_duration)%variable.total_burns
        if burnPhase then
            averageBurnLength = (averageBurnLength * totalBurns - averageBurnLength + (GetTime() - burnPhaseStart)) / totalBurns
            burnPhaseDuration = GetTime() - burnPhaseStart
        end
    -- Time Until Burn
        -- variable,name=time_until_burn,op=set,value=cooldown.arcane_power.remains
        -- variable,name=time_until_burn,op=max,value=cooldown.evocation.remains-variable.average_burn_length
        -- variable,name=time_until_burn,op=max,value=cooldown.presence_of_mind.remains,if=set_bonus.tier20_2pc
        if t20_2pc then t20_2pcTimer = cd.presenceOfMind.remain() else t20_2pcTimer = 0 end
        -- variable,name=time_until_burn,op=max,value=action.rune_of_power.usable_in,if=talent.rune_of_power.enabled
        if talent.runeOfPower then runeTimer = cd.runeOfPower.remain() else runeTimer = 0 end
        -- variable,name=time_until_burn,op=reset,if=target.time_to_die<variable.average_burn_length
        if (UnitExists("target") and ttd("target") < averageBurnLength and not isDummy("target")) or burnPhase then
            timeUntilBurn = 0
        else
            timeUntilBurn = math.max(cd.arcanePower.remain(),cd.evocation.remain() - averageBurnLength,t20_2pcTimer,runeTimer)
        end
    -- Stop Burn Phase
        -- stop_burn_phase,if=prev_gcd.1.evocation&cooldown.evocation.charges=0&burn_phase_duration>0
        if burnPhase and (lastSpell == spell.evocation --[[or cd.evocation.remain() > gcd]]) and charges.evocation.count() == 0 and burnPhaseDuration > 0 then
            burnPhase = false
        end


        if isChecked("Burn Phase Debug") then
            ChatOverlay("Mode: "..tostring(phaseMode)..", Time Until Burn: "..round2(timeUntilBurn,2)..
                ", Duration: "..round2(burnPhaseDuration,2)..", Total: "..totalBurns..", Avg: "..round2(averageBurnLength,2))
        end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
            -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end -- End Dummy Test
        end -- End Action List - Extras
    -- Action List - Defensive
        local function actionList_Defensive()
            if useDefensive() then
                -- Pot/Stoned
                if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned")
                    and inCombat and (hasHealthPot() or hasItem(5512))
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
                -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
                -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
                -- Frost Nova
                if isChecked("Frost Nova") and php <= getOptionValue("Frost Nova") and #enemies.yards12 > 0 then
                    if cast.frostNova() then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        -- Counterspell
                        if isChecked("Counterspell") then
                            if cast.counterspell(thisUnit) then return end
                        end
                    end
                end
            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() and getDistance(units.dyn40) < 40 then
            -- Mirror Image
                -- mirror_image
                if isChecked("Mirror Image") then
                    if cast.mirrorImage("player") then return end
                end
            -- Rune of Power
                -- rune_of_power,if=mana.pct>30|(buff.arcane_power.up|cooldown.arcane_power.up)
                if isChecked("Rune of Power") then
                    --if manaPercent > 30 or cd.arcanePower.remain() == 0 then
                    if (charges.runeOfPower.count() == 2 and buff.arcaneMissles.stack() >= 2 and arcaneCharges == 4) 
                        or (charges.runeOfPower.count() < 2 and cd.markOfAluneth.remain() > charges.runeOfPower.recharge() and (castArtifact or buff.arcaneMissles.stack() >= 2)) 
                    then 
                        if cast.runeOfPower("player") then return end
                    end
                end
            -- Arcane Power
                -- arcane_power
                if isChecked("Arcane Power") and buff.arcaneMissles.stack() >= 2 and not buff.runeOfPower.exists() then
                    if cast.arcanePower("player") then return end
                end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") and getSpellCD(racial) == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Potion
                -- potion,if=buff.arcane_power.up&(buff.berserking.up|buff.blood_fury.up|!(race.troll|race.orc))
                if isChecked("Potion") and canUse(127843) and inRaid then
                    if buff.arcanePower.exists() and (buff.berserking.exists() or buff.bloodFury.exists() or not (br.player.race == "Troll" or br.player.race == "Orc")) then
                        if useItem(127843) then return end
                    end
                end
            -- Trinkets
                -- use_items,if=buff.arcane_power.up|target.time_to_die<cooldown.arcane_power.remains
                if isChecked("Trinkets") and (buff.arcanePower.exists() or ttd("target") < cd.arcanePower.remain()) then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            end -- End useCDs check
        end -- End Action List - Cooldowns
    -- Action List - Build
        local function actionList_Build()
            phaseMode = "Build"
        -- Presence of Mind
            if ((manaPercent > 30 or buff.arcanePower.exists()) and t20_2pc) then
                if cast.presenceOfMind("player") then return end
            end
        -- Arcane Orb
            -- arcane_orb
            if cast.arcaneOrb() then return end
        -- Charged Up
            -- charged_up
            -- charged_up,if=equipped.mystic_kilt_of_the_rune_master|(variable.arcane_missiles_procs=buff.arcane_missiles.max_stack&active_enemies<3)
            -- if hasEquiped(132451) or (buff.arcaneMissles.stack() == 3 and ((mode.rotation == 1 and #enemies.yards40 < 3) or mode.rotation == 3)) then
            if arcaneCharges == 0 then
                if cast.chargedUp() then return end
            end
        -- Arcane Missles
            -- arcane_missiles,if=variable.arcane_missiles_procs=buff.arcane_missiles.max_stack&active_enemies<3
            if buff.arcaneMissles.stack() == 3 then
                if cast.arcaneMissles() then return end
            end
        -- Arcane Explosion
            -- arcane_explosion,if=active_enemies>1
            if ((mode.rotation == 1 and #enemies.yards10 >= getOptionValue("Arcane Explosion")) or (mode.rotation == 2 and #enemies.yards10 > 0)) then
                if cast.arcaneExplosion("player") then return end
            end
        -- Arcane Blast
            -- arcane_blast
            if not isCastingSpell(spell.arcaneBlast) then
                if cast.arcaneBlast() then return end
            end
        end -- End Action List - Build
    -- Action List - Burn
        local function actionList_Burn()
            phaseMode = "Burn"
        -- Start Burn Phase
            -- start_burn_phase,if=!burn_phase
            if not burnPhase then
                burnPhaseStart = GetTime();
                -- totalBurns = totalBurns + 1
                burnPhase = true
            end
        -- Arcane Blast
            -- arcane_blast,if=buff.presence_of_mind.up
            if buff.presenceOfMind.exists() and not isCastingSpell(spell.arcaneBlast) then
                if cast.arcaneBlast() then return end
            end
        -- Charged Up
            if arcaneCharges == 0 then
                if cast.chargedUp() then return end
            end
        -- Arcane Barrage
            -- arcane_barrage,if=buff.rune_of_power.remains>=travel_time&((cooldown.presence_of_mind.remains<=execute_time&set_bonus.tier20_2pc)|(talent.charged_up.enabled&cooldown.charged_up.remains<=execute_time))&buff.arcane_charge.stack=buff.arcane_charge.max_stack
            if ((cd.presenceOfMind.remain() <= getCastTime(spell.arcaneBarrage) and t20_2pc) or (talent.chargedUp and cd.chargedUp.remain() <= getCastTime(spell.arcaneBarrage))) and arcaneCharges == arcaneChargesMax then
                if cast.arcaneBarrage() then return end
            end
        -- Nether Tempest
            -- nether_tempest,if=refreshable|!ticking
            if debuff.netherTempest.refresh(units.dyn40) or not debuff.netherTempest.exists(units.dyn40) then
                if cast.netherTempest() then return end
            end
        -- Mark of Aluneth
            -- mark_of_aluneth
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and artifact.markOfAluneth.enabled() and not buff.runeOfPower.exists() then
                if cast.markOfAluneth() then castArtifact = true; return end
            end
        -- Call Action List - Cooldowns
            -- call_action_list,name=cooldowns
            if actionList_Cooldowns() then return end
        -- Presence of Mind
            -- presence_of_mind,if=((mana.pct>30|buff.arcane_power.up)&set_bonus.tier20_2pc)|buff.rune_of_power.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time|buff.arcane_power.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time
            if ((manaPercent > 30 or buff.arcanePower.exists()) and t20_2pc) 
                or (not t20_2pc and (buff.runeOfPower.remain() <= 2 * getCastTime(spell.arcaneBlast) or buff.arcanePower.remain() <= 2 * getCastTime(spell.arcaneBlast))) 
            then
                if cast.presenceOfMind("player") then return end
            end
        -- Arcane Orb
            -- arcane_orb
            if cast.arcaneOrb() then return end
        -- Arcane Barrage
            -- arcane_barrage,if=active_enemies>4&equipped.mantle_of_the_first_kirin_tor&buff.arcane_charge.stack=buff.arcane_charge.max_stack
            if #enemies.yards40 > 4 and hasEquiped(151808) and arcaneCharges == arcaneChargesMax and not buff.arcanePower.exists() then
                if cast.arcaneBarrage() then return end
            end
        -- Arcane Missles
            -- arcane_missiles,if=variable.arcane_missiles_procs=buff.arcane_missiles.max_stack&active_enemies<3
            if arcaneCharges == 4 and (buff.arcanePower.exists() or buff.arcaneMissles.stack() >= 2) then
                if cast.arcaneMissles() then return end
            end
        -- Arcane Explosion
            -- arcane_explosion,if=active_enemies>1
            if ((mode.rotation == 1 and #enemies.yards10 >= getOptionValue("Arcane Explosion")) or (mode.rotation == 2 and #enemies.yards10 > 0)) then
                if cast.arcaneExplosion("player") then return end
            end
        -- Arcane Missles
            -- arcane_missiles,if=variable.arcane_missiles_procs
            if buff.arcaneMissles.stack() > 0 and power < getSpellCost(spell.arcaneBlast) then
                if cast.arcaneMissles() then return end
            end
        -- Arcane Barrage
            -- arcane_barrage,if=buff.rune_of_power.remains<action.arcane_blast.cast_time&buff.rune_of_power.remains>=travel_time&cooldown.charged_up.remains<=execute_time
            if buff.runeOfPower.remain() < getCastTime(spell.arcaneBlast) and buff.runeOfPower.remain() >= 1 and cd.chargedUp.remain() <= getCastTime(spell.arcaneBarrage) and not buff.arcanePower.exists() then
                if cast.arcaneBarrage() then return end
            end
        -- Arcane Blast
            -- arcane_blast
            if not isCastingSpell(spell.arcaneBlast) then
                if cast.arcaneBlast() then return end
            end
        -- Evocation
            -- evocation,interrupt_if=ticks=2|mana.pct>=85,interrupt_immediate=1
            if power < getSpellCost(spell.arcaneBlast) and not buff.presenceOfMind.exists() then
                if cast.evocation() then return end
            end
        end -- End Action List - Burn
    -- Action List - Miniburn
        local function actionList_Miniburn()
            phaseMode = "Miniburn"
        -- Rune Of Power
            -- rune_of_power
            if isChecked("Rune of Power") and useCDs() and talent.runeOfPower then
                cast.runeOfPower("player")
            end 
        -- Arcane Barrage
            -- arcane_barrage
            if arcaneCharges > 0 then
                cast.arcaneBarrage()
            end
        -- Presence Of Mind
            -- presence_of_mind
            cast.presenceOfMind("player")
            return
        end -- End Action List - Miniburn
    -- Action List - Conserve
        local function actionList_Conserve()
            phaseMode = "Conserve"
        -- Mirror Image
            -- mirror_image,if=variable.time_until_burn>recharge_time|variable.time_until_burn>target.time_to_die
            if isChecked("Mirror Image") and useCDs() and talent.mirrorImage then
                if timeUntilBurn > charges.mirrorImage.recharge() or timeUntilBurn > ttd("target") then
                    if cast.mirrorImage("player") then return end
                end
            end
        -- Mark of Aluneth
            -- mark_of_aluneth
            if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and artifact.markOfAluneth.enabled() and not buff.runeOfPower.exists() then
                if cast.markOfAluneth() then return end
            end
        -- Rune of Power
            -- rune_of_power,if=full_recharge_time<=execute_time|(prev_gcd.1.mark_of_aluneth&!set_bonus.tier20_4pc)
            if isChecked("Rune of Power") and useCDs() and talent.runeOfPower then
                if charges.runeOfPower.recharge() <= getCastTime(spell.runeOfPower) or (lastSpell == spell.markOfAluneth and not t20_4pc) then
                    if cast.runeOfPower("player") then return end
                end
            end
        -- Run Action List - Miniburn
            -- swap_action_list,name=miniburn_init,if=set_bonus.tier20_4pc&cooldown.presence_of_mind.up&cooldown.arcane_power.remains>20&(action.rune_of_power.usable|!talent.rune_of_power.enabled)
            if t20_4pc and cd.presenceOfMind.remain() == 0 and cd.arcanePower.remain() > 20 and (charges.runeOfPower.count() >= 1 or not talent.runeOfPower) then
                if actionList_Miniburn() then return end
            end
        -- Arcane Missles
            -- arcane_missiles,if=variable.arcane_missiles_procs=buff.arcane_missiles.max_stack&active_enemies<3
            if buff.arcaneMissles.stack() == 3 then
                if cast.arcaneMissles() then return end
            end
        -- Supernova
            -- supernova
            if useCDs() then
                if cast.supernova() then return end
            end
        -- Nether Tempest
            -- nether_tempest,if=(refreshable|!ticking)
            if debuff.netherTempest.refresh(units.dyn40) or not debuff.netherTempest.exists(units.dyn40) then
                if cast.netherTempest() then return end
            end
        -- Arcane Explosion
            -- arcane_explosion,if=active_enemies>1&(mana.pct>=70-(10*equipped.mystic_kilt_of_the_rune_master))
            if ((mode.rotation == 1 and #enemies.yards10 >= getOptionValue("Arcane Explosion")) or (mode.rotation == 2 and #enemies.yards10 > 0)) and (manaPercent >= 70 - (10 * runeMaster)) then
                if cast.arcaneExplosion("player") then return end
            end            
        -- Arcane Blast
            -- arcane_blast,if=mana.pct>=90|buff.rhonins_assaulting_armwraps.up
            -- arcane_blast,if=mana.pct>=90|buff.rhonins_assaulting_armwraps.up|(buff.rune_of_power.remains>=cast_time&equipped.mystic_kilt_of_the_rune_master)
            if (manaPercent >= 90 or buff.rhoninsAssaultingArmwraps.exists() or (buff.runeOfPower.remain() >= getCastTime(spell.arcaneBlast) and hasEquiped(132451))) and not isCastingSpell(spell.arcaneBlast) then
                if cast.arcaneBlast() then return end
            end
        -- Arcane Missles
            -- arcane_missles
            if buff.arcaneMissles.stack() > 0 then
                if cast.arcaneMissles() then return end
            end
        -- Arcane Barrage
            -- arcane_barrage
            if arcaneCharges >= getOptionValue("Arcane Charges During Conserve") then
                if cast.arcaneBarrage() then return end
            end
        -- Arcane Explosion
            -- arcane_explosion,if=active_enemies>1
            if ((mode.rotation == 1 and #enemies.yards10 >= getOptionValue("Arcane Explosion")) or (mode.rotation == 2 and #enemies.yards10 > 0)) then
                if cast.arcaneExplosion("player") then return end
            end            
        -- Arcane Blast
            -- arcane_blast
            if arcaneCharges < getOptionValue("Arcane Charges During Conserve") and not isCastingSpell(spell.arcaneBlast) then
                if cast.arcaneBlast() then return end
            end
        end -- End Action List - Conserve
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
                -- Arcane familiar
                if not buff.arcaneFamiliar.exists() then
                    -- Print("Familiar is DOWN Pre.")
                    if not hasPet then
                        -- print("we have no pet -- Pr Combat ")
                        CastSpellByName("Arcane Familiar", "")
                    end
                end
                if buff.arcaneFamiliar.exists() then
                    --Print("Familiar is UP Pre.")
                end
            -- Flask
                -- flask,type=flask_of_the_whispered_pact
                -- TODO
            -- Food
                -- food,type=azshari_salad
            -- Augmentation
                -- augmentation,type=defile
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then

                end -- End Pre-Pull
                if isValidUnit("target") and getDistance("target") < 40 then
            -- Mirror Image
                    -- mirror_image
                    if isChecked("Mirror Image") and useCDs() then
                        if cast.mirrorImage() then return end
                    end
            -- Potion
                    -- potion,name=deadly_grace
                    -- TODO
            -- Mark of Aluneth
                    -- mark_of_aluneth,if=set_bonus.tier20_2pc|talent.charged_up.enabled
                    if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) and artifact.markOfAluneth.enabled() then
                        if t20_2pc or talent.chargedUp then
                            if cast.markOfAluneth() then castArtifact = true; return end
                        end
                    end
            -- Arcane Blast
                    -- arcane_blast,if=!(set_bonus.tier20_2pc|talent.charged_up.enabled)
                    if not (t20_2pc or talent.chargedUp) and not isCastingSpell(spell.arcaneBlast) then
                        if cast.arcaneBlast("target") then return end
                    end
                end
            end -- End No Combat
        end -- End Action List - PreCombat

---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or (IsMounted() or IsFlying()) or pause() or mode.rotation==4 then
            if not pause() and IsPetAttackActive() then
                PetStopAttack()
                PetFollow()
            end
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
            if actionList_PreCombat() then
                -- Arcane Familiar
                if not hasPet then
                    -- print("we have no pet Out of Combat ")
                    CastSpellByName("Arcane Familiar", "")
                end
            end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not isCastingSpell(spell.arcaneMissles) then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
            -- Call Action List - Build
                    -- call_action_list,name=build,if=buff.arcane_charge.stack<buff.arcane_charge.max_stack&!burn_phase&time>0
                    if arcaneCharges < 4 and not burnPhase and timeUntilBurn <= gcd then
                        if actionList_Build() then return end
                    end
            -- Call Action List - Burn Phase
                    -- call_action_list,name=burn,if=variable.time_until_burn=0|burn_phase
                    if (arcaneCharges == 4 or (burnPhase and talent.chargedUp and cd.chargedUp.remain() <= getCastTime(spell.arcaneBarrage))) and timeUntilBurn <= gcd then --and (charges.evocation.count() > 0 or cd.evocation.remain() <= averageBurnLength) then
                        if actionList_Burn() then return end
                    end
            -- Call Action List - Conserve
                    -- call_action_list,name=conserve
                    if not burnPhase and timeUntilBurn > gcd then
                        if actionList_Conserve() then return end
                    end
                end -- End SimC APL
         	end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

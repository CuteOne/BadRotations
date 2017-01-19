local rotationName = "Cpoworks"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.aimedShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multiShot },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneShot },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.aspectOfTheCheetah}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.trueshot },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.trueshot },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.trueshot }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 2, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        br.ui:checkSectionState(section)
    -- Pet Options
        section = br.ui:createSection(br.ui.window.profile, "Pet")
        -- Auto Summon
            br.ui:createDropdown(section, "Auto Summon", {"Pet 1","Pet 2","Pet 3","Pet 4","Pet 5",}, 1, "Select the pet you want to use")
        -- Mend Pet
            br.ui:createSpinner(section, "Mend Pet",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Agi Pot
            br.ui:createCheckbox(section,"Agi-Pot")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Trueshot
            br.ui:createCheckbox(section,"Trueshot")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Engineering: Shield-o-tronic
            br.ui:createSpinner(section, "Shield-o-tronic",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Heirloom Neck
            br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Counter Shot
            br.ui:createCheckbox(section,"Counter Shot")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  6)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
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
    if br.timer:useTimer("debugMarksmanship", math.random(0.15,0.3)) then
        --print("Running: "..rotationName)

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
        local animality                                     = false
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
        local debuff, debuffcount                           = br.player.debuff, br.player.debuffcount
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = ObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
        local multishotTargets                              = getEnemies(br.player.units.dyn40,8)
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local potion                                        = br.player.potion
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.amount.focus, br.player.power.focus.max, br.player.power.regen, br.player.power.focus.deficit
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = br.player.units
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        function br.player.getDebuffsCount()
            local UnitDebuffID = UnitDebuffID
            local huntersMarkCount = 0
            local vulnerableCount = 0
            
            if not br.player.debuffcount then br.player.debuffcount = {} end
            if huntersMarkCount>0 and not inCombat then huntersMarkCount = 0 end
            if vulnerableCount>0 and not inCombat then vulnerableCount = 0 end

            for i=1,#getEnemies("player", 40) do
                local thisUnit = getEnemies("player", 40)[i]
                if UnitDebuffID(thisUnit,185365,"player") then
                    huntersMarkCount = huntersMarkCount+1
                end
                if UnitDebuffID(thisUnit,187131,"player") then
                    vulnerableCount = vulnerableCount+1
                end
            end
            br.player.debuffcount.huntersMark       = huntersMarkCount or 0
            br.player.debuffcount.vulnerable        = vulnerableCount or 0
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if not talent.loneWolf and not IsMounted() then
                if isChecked("Auto Summon") and not UnitExists("pet") and (UnitIsDead("pet") ~= nil or UnitIsDead("pet") == false) then
                  if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
                    if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
                      if castSpell("player",RevivePet) then return; end
                    else
                      local Autocall = getValue("Auto Summon");

                      if Autocall == 1 then
                        if castSpell("player",883) then return; end
                      elseif Autocall == 2 then
                        if castSpell("player",83242) then return; end
                      elseif Autocall == 3 then
                        if castSpell("player",83243) then return; end
                      elseif Autocall == 4 then
                        if castSpell("player",83244) then return; end
                      elseif Autocall == 5 then
                        if castSpell("player",83245) then return; end
                      else
                        print("Auto Call Pet Error")
                      end
                    end
                  end
                  if waitForPetToAppear == nil then
                    waitForPetToAppear = GetTime()
                  end
                end

                -- Revive Pet
                if isChecked("Auto Summon") and UnitIsDeadOrGhost("pet") then
                  if castSpell("player",982) then return; end
                end

                -- Mend Pet
                if isChecked("Mend Pet") and getHP("pet") < getValue("Mend Pet") and not UnitBuffID("pet",136) then
                  if castSpell("pet",136) then return; end
                end

                -- Pet Attack / retreat
                if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 then
                    if not UnitIsUnit("target","pettarget") then
                        PetAttack()
                    end
                else
                    if IsPetAttackActive() then
                        PetStopAttack()
                    end
                end
            end
        end
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
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
        -- Engineering: Shield-o-tronic
                if isChecked("Shield-o-tronic") and php <= getOptionValue("Shield-o-tronic") 
                    and inCombat and canUse(118006) 
                then
                    useItem(118006)
                end
        -- Exhilaration
                if isChecked("Exhilaration") and php <= getOptionValue("Exhilaration") then
                    if cast.exhilaration("player") then return end
                end
        -- Exhilaration
                if isChecked("Aspect Of The Turtle") and php <= getOptionValue("Aspect Of The Turtle") then
                    if cast.aspectOfTheTurtle("player") then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then

            end -- End useInterrupts check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() then
        -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
        -- Agi-Pot
                if isChecked("Agi-Pot") and canUse(agiPot) and inRaid then
                    useItem(agiPot);
                    return true
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                     if castSpell("player",racial,false,false,false) then return end
                end
        -- Trueshot
                if isChecked("Trueshot") then
                    if cast.trueshot("player") then return end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns 
    -- Action List - Non Patient Sniper
        local function actionList_nonPatientSniper()
            -- actions.non_patient_sniper=windburst
            if cast.windburst(units.dyn40) then return end
            -- actions.non_patient_sniper+=/piercing_shot,if=focus>=100
            if talent.piercingShot and power > 100 then
                if cast.piercingShot(units.dyn40) then return end
            end
            -- actions.non_patient_sniper+=/sentinel,if=debuff.hunters_mark.down&focus>30&buff.trueshot.down
            -- actions.non_patient_sniper+=/sidewinders,if=debuff.vulnerability.remains<gcd&time>6
            -- actions.non_patient_sniper+=/aimed_shot,if=buff.lock_and_load.up&spell_targets.barrage<3
            -- actions.non_patient_sniper+=/marked_shot
            if cast.markedShot(units.dyn40) then return end
            -- actions.non_patient_sniper+=/explosive_shot
            if cast.explosiveShot(units.dyn40) then return end
            -- actions.non_patient_sniper+=/sidewinders,if=((buff.marking_targets.up|buff.trueshot.up)&focus.deficit>70)|charges_fractional>=1.9
            -- actions.non_patient_sniper+=/arcane_shot,if=!variable.use_multishot&(buff.marking_targets.up|(talent.steady_focus.enabled&(buff.steady_focus.down|buff.steady_focus.remains<2)))
            -- actions.non_patient_sniper+=/multishot,if=variable.use_multishot&(buff.marking_targets.up|(talent.steady_focus.enabled&(buff.steady_focus.down|buff.steady_focus.remains<2)))
            -- actions.non_patient_sniper+=/aimed_shot,if=!talent.piercing_shot.enabled|cooldown.piercing_shot.remains>3
            -- actions.non_patient_sniper+=/arcane_shot,if=!variable.use_multishot
            -- actions.non_patient_sniper+=/multishot,if=variable.use_multishot
        end -- End Action List - Non Patient Sniper
    -- Action List - Patient Sniper
        local function actionList_patientSniper()
            -- actions.patient_sniper=marked_shot,cycle_targets=1,if=(talent.sidewinders.enabled&talent.barrage.enabled&spell_targets>2)|debuff.hunters_mark.remains<2|((debuff.vulnerability.up|talent.sidewinders.enabled)&debuff.vulnerability.remains<gcd)
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                local huntersMark = debuff.huntersMark[thisUnit]
                local vulnerable = debuff.vulnerable[thisUnit]
                if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                    if (talent.sidewinders and talent.barrage) or (huntersMark.exists and huntersMark.remain < 2) or ((vulnerable.exists or talent.sidewinders) and (vulnerable.exists and vulnerable.remain < gcd)) then
                        if cast.markedShot(thisUnit) then return end
                    end
                end
            end
            -- actions.patient_sniper+=/windburst,if=talent.sidewinders.enabled&(debuff.hunters_mark.down|(debuff.hunters_mark.remains>execute_time&focus+(focus.regen*debuff.hunters_mark.remains)>=50))|buff.trueshot.up
            if talent.sidewinders and (debuff.huntersMark[units.dyn40].exists == false or (debuff.huntersMark[units.dyn40].exists and debuff.huntersMark[units.dyn40].remain > ttd(units.dyn40) and (debuff.huntersMark[units.dyn40].exists and power + powerRegen * debuff.huntersMark[units.dyn40].remain >= 50))) or buff.trueshot.exists then
                if cast.windburst(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/sidewinders,if=buff.trueshot.up&((buff.marking_targets.down&buff.trueshot.remains<2)|(charges_fractional>=1.9&(focus.deficit>70|spell_targets>1)))
            -- TODO:Finish statement
            if buff.trueshot.exists and ((buff.markingTargets.exists == false and buff.trueshot.remains < 2) or (charges.frac.sidewinders >= 1.9 and (powerDeficit > 70 or multishotTargets > 1))) then
                if cast.sidewinders(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/multishot,if=buff.marking_targets.up&debuff.hunters_mark.down&variable.use_multishot&focus.deficit>2*spell_targets+gcd*focus.regen
            if buff.markingTargets.exists and debuff.huntersMark[units.dyn40].exists == false and useMultishot and powerDeficit > 2 * #enemies.yards40 + gcd * powerRegen then
                if cast.multiShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/aimed_shot,if=buff.lock_and_load.up&buff.trueshot.up&debuff.vulnerability.remains>execute_time
            if buff.lockAndLoad.exists and buff.trueshot.exists and (debuff.vulnerable[units.dyn40].exists and debuff.vulnerable[units.dyn40].remain > ttd(units.dyn40)) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/marked_shot,if=buff.trueshot.up&!talent.sidewinders.enabled
            if buff.trueshot.exists and not talent.sidewinders then
                if cast.markedShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/arcane_shot,if=buff.trueshot.up
            if buff.trueshot.exists then
                if cast.arcaneShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/aimed_shot,if=debuff.hunters_mark.down&debuff.vulnerability.remains>execute_time
            if debuff.huntersMark[units.dyn40].exists == false and debuff.vulnerable[units.dyn40].remain > ttd(units.dyn40) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/aimed_shot,if=talent.sidewinders.enabled&debuff.hunters_mark.remains>execute_time&debuff.vulnerability.remains>execute_time&(buff.lock_and_load.up|(focus+debuff.hunters_mark.remains*focus.regen>=80&focus+focus.regen*debuff.vulnerability.remains>=80))&(!talent.piercing_shot.enabled|cooldown.piercing_shot.remains>5|focus>120)
            if talent.sidewinders and debuff.huntersMark[units.dyn40].remain > ttd(units.dyn40) and debuff.vulnerable[units.dyn40].remain > ttd(units.dyn40) and (buff.lockAndLoad.exists or (power + debuff.huntersMark[units.dyn40].remain * powerRegen >= 80 and power + powerRegen*debuff.vulnerable[units.dyn40].remain >= 80)) and (not talent.piercingShot or cd.piercingShot > 5 or power > 120) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/aimed_shot,if=!talent.sidewinders.enabled&debuff.hunters_mark.remains>execute_time&debuff.vulnerability.remains>execute_time&(buff.lock_and_load.up|(buff.trueshot.up&focus>=80)|(buff.trueshot.down&focus+debuff.hunters_mark.remains*focus.regen>=80&focus+focus.regen*debuff.vulnerability.remains>=80))&(!talent.piercing_shot.enabled|cooldown.piercing_shot.remains>5|focus>120)
            if not talent.sidewinders and debuff.huntersMark[units.dyn40].remain > ttd(units.dyn40) and debuff.vulnerable[units.dyn40].remain > ttd(units.dyn40) and (buff.lockAndLoad.exists or (buff.trueshot.exists and focus>=80) or (not buff.trueshot.exists and power + debuff.huntersMark[units.dyn40].remain * powerRegen >= 80 and power + powerRegen*debuff.vulnerable[units.dyn40].remain >= 80)) and (not talent.piercingShot or cd.piercingShot > 5 or power > 120) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/windburst,if=!talent.sidewinders.enabled&focus>80&(debuff.hunters_mark.down|(debuff.hunters_mark.remains>execute_time&focus+(focus.regen*debuff.hunters_mark.remains)>=50))
            if not talent.sidewinders and power > 80 and (debuff.huntersMark[units.dyn40].exists == false or (debuff.huntersMark[units.dyn40].remains > ttd(units.dyn40) and power + (powerRegen * debuff.huntersMark[units.dyn40].remains) >= 50)) then
                if cast.windburst(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/marked_shot,if=(talent.sidewinders.enabled&spell_targets>1)|focus.deficit<50|buff.trueshot.up|(buff.marking_targets.up&(!talent.sidewinders.enabled|cooldown.sidewinders.charges_fractional>=1.2))
            if (talent.sidewinders and #multishotTargets > 1) or powerDeficit < 50 or buff.trueshot.exists or (buff.markingTargets.exists and (not talent.sidewinders or charges.frac.sidewinders > 1.2)) then
                if cast.markedShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/piercing_shot,if=focus>80
            if talent.piercingShot and power > 80 then
                if cast.piercingShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/sidewinders,if=variable.safe_to_build&((buff.trueshot.up&focus.deficit>70)|charges_fractional>=1.9)
            if safeToBuild and ((buff.trueshot.exists and powerDeficit > 70) or charges.frac.sidewinders > 1.9) then
                if cast.sidewinders(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/sidewinders,if=(buff.marking_targets.up&debuff.hunters_mark.down&buff.trueshot.down)|(cooldown.sidewinders.charges_fractional>1&target.time_to_die<11)
            if (buff.markingTargets and debuff.huntersMark[units.dyn40].exists == false and buff.trueshot.exists == false) or (charges.frac.sidewinders > 1 and ttd(units.dyn40) < 11)then
                if cast.sidewinders(units.dyn40) then return end
            end 
            -- actions.patient_sniper+=/arcane_shot,if=variable.safe_to_build&!variable.use_multishot&focus.deficit>5+gcd*focus.regen
            if safeToBuild and not useMultishot and powerDeficit > 5 + gcd*powerRegen then
                if cast.arcaneShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/multishot,if=variable.safe_to_build&variable.use_multishot&focus.deficit>2*spell_targets+gcd*focus.regen
            if safeToBuild and useMultishot and powerDeficit > 5 + gcd + powerRegen then
                if cast.multiShot(units.dyn40) then return end
            end
            -- actions.patient_sniper+=/aimed_shot,if=debuff.vulnerability.down&focus>80&cooldown.windburst.remains>focus.time_to_max
            if not debuff.vulnerable[units.dyn40].exists  and power > 80 then
                if cast.aimedShot(units.dyn40) then return end
            end 
        end -- End Action List - Patient Sniper
    -- Action List - Single Target
        local function actionList_SingleTarget()
            -- A Murder of Crows
            if talent.aMurderOfCrows and (debuff.vulnerable[units.dyn40].exists or (debuff.vulnerable[units.dyn40].remain < getCastTime(spell.aimedShot) and not buff.lockAndLoad.exists )) then
                if cast.aMurderOfCrows(units.dyn40) then return end
            end
            -- Piercing Shot
            -- if not HasTalent(PatientSniper) and Power > 50
            if talent.piercingShot and not talent.patientSniper and power > 50 then
                if cast.piercingShot(units.dyn40) then return end
            end
            -- Windburst
            if cast.windburst(units.dyn40) then return end
            -- Aimed Shot
            -- if HasBuff(LockAndLoad) and HasBuff(Vulnerable) and HasTalent(PatientSniper)
            if buff.lockAndLoad.exists and debuff.vulnerable[units.dyn40].exists then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Arcane Shot
            -- if (HasBuff(MarkingTargets) or HasBuff(Trueshot)) and not HasBuff(HuntersMark)
            if (buff.markingTargets.exists or buff.trueshot.exists) and debuff.huntersMark[units.dyn40].exists == false then
                if cast.arcaneShot(units.dyn40) then return end
            end 
            -- Multi-Shot
            -- if TargetsInRadius(MultiShot) > 1 and HasBuff(MarkingTargets) and BuffCount(HuntersMark) < TargetsInRadius(MultiShot)
            if #multishotTargets > 1 and buff.markingTargets.exists and debuffcount.huntersMark < #multishotTargets then
                if cast.multiShot(units.dyn40) then return end
            end
            -- Sentinel
            -- if not HasBuff(HuntersMark) and not HasBuff(Vulnerable) and not HasBuff(MarkingTargets)
            -- is a cooldown
            
            -- Aimed Shot
            -- if SpellCastTimeSec(AimedShot) < BuffRemainingSec(Vulnerable) and 
            -- (not HasTalent(Barrage) or CooldownSecRemaining(Barrage) > GlobalCooldownSec)
            if getCastTime(spell.aimedShot) < debuff.vulnerable[units.dyn40].remain and (not talent.piercingShot or cd.piercingShot > debuff.vulnerable[units.dyn40].remain) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Marked Shot
            if not talent.patientSniper or debuff.vulnerable[units.dyn40].remain < getCastTime(spell.aimedShot) then
                if cast.markedShot(units.dyn40) then return end
            end
            -- Bursting Shot
            -- if HasItem(MagnetizedBlastingCapLauncher) and SecondsUntilAoe(2,8) > SpellCooldownSec(BurstingShot)
            
            -- Black Arrow
            if talent.blackArrow then
                if cast.blackArrow(units.dyn40) then return end
            end
            -- Explosive Shot
            if talent.explosiveShot then
                if cast.explosiveShot(units.dyn40) then return end
            end
            -- Aimed Shot
            if powerDeficit < 25 then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Sidewinders
            -- if not HasBuff(HuntersMark) and (HasBuff(MarkingTargets) or HasBuff(Trueshot)) or 
            -- ChargeSecRemaining(Sidewinders) < BuffDurationSec(Vulnerable) - SpellCastTimeSec(AimedShot)
            if talent.sidewinders and debuff.huntersMark[units.dyn40].exists == false and (buff.markingTargets.exists or buff.trueshot.exists) or recharge.sidewinders < debuff.vulnerable[units.dyn40].duration - getCastTime(spell.aimedShot) then
                if cast.sidewinders(units.dyn40) then return end
            end 
            -- Arcane Shot
            -- if not HasBuff(HuntersMark) or not HasBuff(MarkingTargets)
            if debuff.huntersMark[units.dyn40].exists == false or buff.markingTargets.exists == false then
                if cast.arcaneShot(units.dyn40) then return end
            end
        end -- End Action List - Single Target
    -- Action List - Multi Target
        local function actionList_MultiTarget()
            -- A Murder of Crows
            -- if TargetSecRemaining < 60
            if talent.aMurderOfCrows and ttd(units.dyn40) < 60 then
                if cast.aMurderOfCrows(units.dyn40) then return end
            end
            -- Barrage
            if talent.barrage then
                if cast.barrage(units.dyn40) then return end
            end
            -- Bursting Shot
            -- if HasItem(MagnetizedBlastingCapLauncher)
            
            -- Explosive Shot
            if talent.explosiveShot then
                if cast.explosiveShot(units.dyn40) then return end
            end
            -- Multi-Shot
            -- if BuffCount(HuntersMark) < 2 and (HasBuff(MarkingTargets) or HasBuff(Trueshot))
            if debuffcount.huntersMark < 2 and (buff.markingTargets.exists or buff.trueshot.exists) then
                if cast.multiShot(units.dyn40) then return end
            end
            -- Sidewinders
            -- if BuffCount(HuntersMark) < 2 and (HasBuff(MarkingTargets) or HasBuff(Trueshot))
            if debuffcount.huntersMark < 2 and (buff.markingTargets.exists or buff.trueshot.exists) then
                if cast.sidewinders(units.dyn40) then return end
            end
            -- Sentinel
            -- if BuffCount(HuntersMark) < TargetsInRadius(MultiShot)
            
            -- Marked Shot
            if cast.markedShot(units.dyn40) then return end
            -- Aimed Shot
            -- if BuffStack(SentinelsSight) = BuffMaxStack(SentinelsSight)
            
            -- Aimed Shot
            -- if HasTalent(TrickShot) and BuffCount(Vulnerable) > 1 and HasBuff(LockAndLoad)
            if talent.trickShot and debuffcount.vulnerable > 1 and buff.lockAndLoad.exists then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Multi-Shot
            if cast.multiShot(units.dyn40) then return end
            -- Arcane Shot
            if cast.arcaneShot(units.dyn40) then return end
        end -- End Action List - Multi Target


---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4  then
            return true
        else
            br.player.getDebuffsCount()
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
-----------------
--- Pet Logic ---
-----------------             
            if actionList_PetManagement() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and (debuff.huntersMark[units.dyn40] ~= nil and debuff.vulnerable[units.dyn40] ~= nil) and isCastingSpell(spell.barrage) == false then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                    if actionList_Interrupts() then return end              
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                    if getOptionValue("APL Mode") == 1 then

                    end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                    if getOptionValue("APL Mode") == 2 then
                        -- Volley
                        -- If you choose this talent, you will do more damage by having it always on, even against one target.
                        if not buff.volley.exists then
                            if cast.volley(units.dyn40) then return end
                        end
                        -- Arcane Shot
                        -- if WasLastSpell(ArcaneShot) and HasTalent(SteadyFocus) and not HasBuff(SteadyFocus) and PowerToMax >= GlobalCooldownSec * 2 * PowerRegen + 10
                        if lastSpellCast == spell.arcaneShot and talent.steadyFocus and not buff.steadyFocus.exists and powerDeficit >= gcd * 2 * powerRegen + 10 then
                            if cast.arcaneShot(units.dyn40) then return end
                        end
                        -- Cooldowns
                        if actionList_Cooldowns() then return end
                        -- MultiTarget
                        -- if TargetsInRadius(MultiShot) > 2
                        if (#multishotTargets > 2 and mode.rotation == 1) or mode.rotation == 2 then
                            if actionList_MultiTarget() then return end
                        end
                        -- SingleTarget
                        if actionList_SingleTarget() then return end          
                    end
            end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
local id = 254
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
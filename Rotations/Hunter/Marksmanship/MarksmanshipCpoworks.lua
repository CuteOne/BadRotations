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
        -- Explosive Shot
            br.ui:createCheckbox(section, "Explosive Shot")
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
        local enemies                                       = enemies or {}
        local explosiveTarget                               = explosiveTarget
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
        local multishotTargets                              = getEnemies(br.player.units(40),8)
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
        local units                                         = units or {}

        units.dyn40 = br.player.units(40)
        enemies.yards8t = br.player.enemies(8,br.player.units(8,true))
        enemies.yards40 = br.player.enemies(40)

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        local lowestVuln = lowestVuln or 100
        for i=1,#getEnemies("player", 40) do
            local thisUnit = getEnemies("player", 40)[i]
            if debuff.vulnerable.remain(thisUnit) < lowestVuln then
                lowestVuln = debuff.vulnerable.remain(thisUnit)
            end
        end

        local attackHaste = 1 / (1 + (UnitSpellHaste("player")/100))

        -- Pool for Piercing Shot
        -- pooling_for_piercing,value=talent.piercing_shot.enabled&cooldown.piercing_shot.remains<5&lowest_vuln_within.5>0&lowest_vuln_within.5>cooldown.piercing_shot.remains&(buff.trueshot.down|spell_targets=1)
        local poolForPiercing
        if talent.piercingShot and cd.piercingShot < 5 and lowestVuln > 0 and lowestVuln > cd.piercingShot and (not buff.trueshot.exists() or ((mode.rotation == 1 and #enemies.yards40 == 1) or mode.rotation == 3)) then
            poolForPiercing = true
        else
            poolForPiercing = false
        end

        -- Wait for Sentinel
        -- waiting_for_sentinel,value=talent.sentinel.enabled&(buff.marking_targets.up|buff.trueshot.up)&!cooldown.sentinel.up&((cooldown.sentinel.remains>54&cooldown.sentinel.remains<(54+gcd.max))|(cooldown.sentinel.remains>48&cooldown.sentinel.remains<(48+gcd.max))|(cooldown.sentinel.remains>42&cooldown.sentinel.remains<(42+gcd.max)))
        local waitForSentinel
        if talent.sentinel and (buff.markingTargets.exists() or buff.trueshot.exists()) and cd.sentinel > 0 
            and ((cd.sentinel > 54 and cd.sentinel < (54 + gcd)) or (cd.sentinel > 48 and cd.sentinel < (48 + gcd)) or (cd.sentinel > 42 and cd.sentinel < (42 + gcd))) 
        then
            waitForSentinel = true
        else
            waitForSentinel = false
        end

        -- Vulnerable Window
        local vulnWindow = vulnWindow or 0
        -- vuln_window,op=set,value=debuff.vulnerability.remains
        vulnWindow = debuff.vulnerable.remain(units.dyn40) - 0.5 
        -- vuln_window,op=set,value=(24-cooldown.sidewinders.charges_fractional*12)*attack_haste,if=talent.sidewinders.enabled&(24-cooldown.sidewinders.charges_fractional*12)*attack_haste<variable.vuln_window
        if talent.sidewinders and (24 - charges.frac.sidewinders * 12) * attackHaste < vulnWindow then 
            vulnWindow = ((24 - charges.frac.sidewinders * 12) * attackHaste) - 0.5
        end

        -- Vulnerable Aim Casts
        local vulnAimCast = vulnAimCast or 0
        -- vuln_aim_casts,op=set,value=floor(variable.vuln_window%(2*attack_haste))
        vulnAimCast = math.floor(vulnWindow / (2 * attackHaste))
        -- vuln_aim_casts,op=set,value=floor((focus+20*(variable.vuln_aim_casts-1))%50),if=variable.vuln_aim_casts>0&variable.vuln_aim_casts>floor((focus+20*(variable.vuln_aim_casts-1))%50)
        if vulnWindow > math.floor((power + 20 * (vulnAimCast - 1)) / 50) then
            vulnAimCast = math.floor((power + 20 * (vulnAimCast - 1)) / 50)
        end

        -- Can GCD
        -- can_gcd,value=variable.vuln_window>variable.vuln_aim_casts*(2*attack_haste)+gcd.max 
        local canGCD = vulnWindow > vulnAimCast * (2 * attackHaste) + gcd            

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

        local function getExplosiveDistance(otherUnit)
            -- local objectCount = GetObjectCount() or 0
            if otherUnit == nil then otherUnit = "target" end
            for i = 1, ObjectCount() do
                local thisUnit = GetObjectWithIndex(i)
                if ObjectExists(otherUnit) and GetObjectID(thisUnit) == 11492 then --and UnitIsUnit("player",UnitCreator(thisUnit)) then

                    return GetDistanceBetweenObjects(thisUnit,otherUnit)
                end
            end
            return 40
        end
        if explosiveTarget == nil or not ObjectExists(explosiveTarget) then explosiveTarget = "target" end
        if ObjectExists(explosiveTarget) and getExplosiveDistance(explosiveTarget) < 5 then
            if castSpell(explosiveTarget,spell.explosiveShotDetonate,false,false,false,true,false,true,true,false) then return end
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
                        PetStopAttack()
                        PetFollow()
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
                for i=1, #getEnemies("player",50) do
                    thisUnit = getEnemies("player",50)[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupts")) then
                        if distance < 50 then
        -- Counter Shot
                            if isChecked("Counter Shot") then
                                if cast.counterShot(thisUnit) then return end
                            end
                        end
                    end
                end
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
                -- arcane_torrent,if=focus.deficit>=30&(!talent.sidewinders.enabled|cooldown.sidewinders.charges<2)
                -- berserking,if=buff.trueshot.up
                -- blood_fury,if=buff.trueshot.up
                if isChecked("Racial") and cd.racial == 0
                    and ((buff.trueshot.exists() and (br.player.race == "Orc" or br.player.race == "Troll")) 
                        or (powerDeficit >= 30 and (not talent.sidewinders or charges.sidewinders < 2) and br.player.race == "BloodElf")) 
                then
                     if castSpell("player",racial,false,false,false) then return end
                end
        -- Trueshot
                -- variable,name=trueshot_cooldown,op=set,value=time*1.1,if=time>15&cooldown.trueshot.up&variable.trueshot_cooldown=0
                -- trueshot,if=variable.trueshot_cooldown=0|buff.bloodlust.up|(variable.trueshot_cooldown>0&target.time_to_die>(variable.trueshot_cooldown+duration))|buff.bullseye.react>25|target.time_to_die<16
                if isChecked("Trueshot") then
                    local trueshotCD = trueshotCD or 0
                    if combatTime > 15 and cd.trueshot == 0 and trueshotCD == 0 then trueshotCD = combatTime * 1.1 else trueshotCD = 0 end
                    if trueshotCD == 0 or hasBloodLust() or (trueshotCD > 0 and ttd(units.dyn40) > (trueshotCD + buff.trueshot.duration())) or buff.bullseye.exists() or ttd(units.dyn40) < 16 then
                        if cast.trueshot("player") then return end
                    end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
    -- Action List - Non Patient Sniper
        local function actionList_NonPatientSniper()
        -- Bursting Shot
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and hasEquiped(141353) and not debuff.vulnerable.exists(units.dyn40) then
                if cast.burstingShot() then return end
            end
        -- Explosive Shot
            -- explosive_shot
            if cast.explosiveShot(units.dyn40) then explosiveTarget = units.dyn40; return end
        -- Piercing Shot
            -- piercing_shot,if=lowest_vuln_within.5>0&focus>100
            if lowestVuln > 0 and power > 100 then
                if cast.piercingShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=spell_targets>1&debuff.vulnerability.remains>cast_time&talent.trick_shot.enabled&buff.sentinels_sight.stack=20
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and talent.trickShot and buff.sentinelsSight.stack() == 20 then
                if cast.aimedShot() then return end
            end
        -- Marked Shot
            -- marked_shot,if=spell_targets>1
            if debuff.huntersMark.count() > 1 then
                if cast.markedShot() then return end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets>1&(buff.marking_targets.up|buff.trueshot.up)
            if ((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) and (buff.markingTargets.exists() or buff.trueshot.exists()) then
                if cast.multiShot() then return end
            end
        -- Sentinel
            -- sentinel,if=!debuff.hunters_mark.up
            if not debuff.huntersMark.exists(units.dyn40) then
                if cast.sentinel() then return end
            end 
        -- Black Arrow
            -- black_arrow,if=talent.sidewinders.enabled|spell_targets.multishot<6
            if talent.sidewinders or ((mode.rotation == 1 and #enemies.yards8t < 6) or mode.rotation == 1) then
                if cast.blackArrow() then return end
            end  
        -- A Murder of Crows
            -- a_murder_of_crows
            if cast.aMurderOfCrows() then return end
        -- Windburst
            -- windburst
            if cast.windburst() then return end
        -- Barrage
            -- barrage,if=spell_targets>2|(target.health.pct<20&buff.bullseye.stack<25)
            if ((mode.rotation == 1 and #enemies.yards40 > 2) or mode.rotation == 2) or (getHP(units.dyn40) < 20 and buff.bullseye.stack() < 25) then
                if cast.barrage() then return end
            end
        -- Marked Shot
            -- marked_shot,if=buff.marking_targets.up|buff.trueshot.up
            if buff.markingTargets.exists() or buff.trueshot.exists() then
                if cast.markedShot() then return end
            end
        -- Sidewinders
            -- !variable.waiting_for_sentinel&(debuff.hunters_mark.down|(buff.trueshot.down&buff.marking_targets.down))&((buff.marking_targets.up|buff.trueshot.up)|charges_fractional>1.8)&(focus.deficit>cast_regen)
            if not waitForSentinel and (not debuff.huntersMark.exists(units.dyn40) or (not buff.trueshot.exists() and not buff.markingTargets.exists())) 
                and ((buff.markingTargets.exists() or buff.trueshot.exists()) or charges.frac.sidewinders > 1.8) and (powerDeficit > powerRegen) 
            then
                if cast.sidewinders() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time
            if talent.sidewinders and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) then
                if cast.aimedShot() then return end
            end
            -- aimed_shot,if=!talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time&(!variable.pooling_for_piercing|(buff.lock_and_load.up&lowest_vuln_within.5>gcd.max))&(spell_targets.multishot<4|talent.trick_shot.enabled|buff.sentinels_sight.stack=20)
            if not talent.sidewinders and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and (not poolForPiercing or (buff.lockAndLoad.exists() and lowestVuln > gcd)) 
                and (((mode.rotation == 1 and #enemies.yards8t < 4) or mode.rotation == 3) or talent.trickShot or buff.sentinelsSight.stack() == 20) 
            then
                if cast.aimedShot() then return end
            end
        -- Marked Shot
            -- marked_shot
            if cast.markedShot() then return end
        -- Aimed Shot
            -- aimed_shot,if=talent.sidewinders.enabled&spell_targets.multi_shot=1&focus>110
            if talent.sidewinders and ((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) and power > 110 then
                if cast.aimedShot() then return end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets.multi_shot>1&!variable.waiting_for_sentinel
            if ((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) and not waitForSentinel then
                if cast.multiShot() then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=spell_targets.multi_shot<2&!variable.waiting_for_sentinel
            if ((mode.rotation == 1 and #enemies.yards8t < 2) or mode.rotation == 3) and not waitForSentinel then
                if cast.multiShot() then return end
            end
        end -- End Action List - Non Patient Sniper
    -- Action List - Patient Sniper
        local function actionList_PatientSniper()
        -- Bursting Shot
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and hasEquiped(141353) and not debuff.vulnerable.exists(units.dyn40) then
                if cast.burstingShot() then return end
            end
        -- Piercing Shot
            -- piercing_shot,if=cooldown.piercing_shot.up&spell_targets=1&lowest_vuln_within.5>0&lowest_vuln_within.5<1
            if cd.piercingShot == 0 and ((mode.rotation == 1 and #enemies.yards40 == 1) or mode.rotation == 3) and lowestVuln > 0 and lowestVuln < 1 then
                if cast.piercingShot() then return end
            end
            -- piercing_shot,if=cooldown.piercing_shot.up&spell_targets>1&lowest_vuln_within.5>0&((!buff.trueshot.up&focus>80&(lowest_vuln_within.5<1|debuff.hunters_mark.up))|(buff.trueshot.up&focus>105&lowest_vuln_within.5<6))
            if cd.piercingShot == 0 and ((mode.rotation == 1 and #enemies.yards40 == 1) or mode.rotation == 3) and lowestVuln > 0 
                and ((not buff.trueshot.exists() and power > 80 and (lowestVuln < 1 or debuff.huntersMark.exists(units.dyn40))) or (buff.trueshot.exists() and power > 105 and lowestVuln < 6)) 
            then
                if cast.piercingShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=spell_targets>1&debuff.vulnerability.remains>cast_time&talent.trick_shot.enabled&buff.sentinels_sight.stack=20
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and talent.trickShot and buff.sentinelsSight.stack() == 20 then
                if cast.aimedShot() then return end
            end
        -- Marked Shot
            -- marked_shot,if=spell_targets>1
            if ((mode.rotation == 1 and debuff.huntersMark.count() > 1) or mode.rotation == 2) then
                if cast.markedShot() then return end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets>1&(buff.marking_targets.up|buff.trueshot.up)
            if ((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) and (buff.markingTargets.exists() or buff.trueshot.exists()) then
                if cast.multiShot() then return end
            end
        -- Windburst
            -- windburst,if=variable.vuln_aim_casts<1&!variable.pooling_for_piercing
            if vulnAimCast < 1 and not poolForPiercing then
                if cast.windburst() then return end
            end
        -- Black Arrow
            -- black_arrow,if=variable.can_gcd&(talent.sidewinders.enabled|spell_targets.multishot<6)&(!variable.pooling_for_piercing|(lowest_vuln_within.5>gcd.max&focus>85))
            if canGCD and (talent.sidewinders or ((mode.rotation == 1 and #enemies.yards8t < 6) or mode.rotation == 3)) and (not poolForPiercing or (lowestVuln > gcd and power > 85)) then
                if cast.blackArrow() then return end
            end
        -- A Murder of Crows
            -- a_murder_of_crows,if=(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)&(target.time_to_die>=cooldown+duration|target.health.pct<20|target.time_to_die<16)
            if (not poolForPiercing or lowestVuln > gcd) and (ttd(units.dyn40) >= cd.aMurderOfCrows + debuff.aMurderOfCrows.duration(units.dyn40) or getHP(units.dyn40) < 20 or ttd(units.dyn40) < 16) then
                if cast.aMurderOfCrows() then return end
            end
        -- Barrage
            -- barrage,if=spell_targets>2|(target.health.pct<20&buff.bullseye.stack<25)
            if ((mode.rotation == 1 and #enemies.yards40 > 2) or mode.rotation == 2) or (getHP(units.dyn40) < 20 and buff.bullseye.stack() < 25) then
                if cast.barrage() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=debuff.vulnerability.up&buff.lock_and_load.up&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)&(spell_targets.multi_shot<4|talent.trick_shot.enabled)
            if debuff.vulnerable.exists(units.dyn40) and buff.lockAndLoad.exists() and (not poolForPiercing or lowestVuln > gcd) and (((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) or talent.trickShot) then
                if cast.aimedShot() then return end
            end
            -- aimed_shot,if=spell_targets.multishot>1&debuff.vulnerability.remains>execute_time&(!variable.pooling_for_piercing|(focus>100&lowest_vuln_within.5>(execute_time+gcd.max)))&(spell_targets.multishot<4|buff.sentinels_sight.stack=20|talent.trick_shot.enabled)
            if ((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) 
                and (not poolForPiercing or (power > 100 and lowestVuln > (getCastTime(spell.aimedShot) + gcd))) 
                and (((mode.rotation == 1 and #enemies.yards8t < 4) or mode.rotation == 3) or buff.sentinelsSight.stack() == 20 or talent.trickShot) 
            then
                if cast.aimedShot() then return end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets>1&variable.can_gcd&focus+cast_regen+20<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if ((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) and canGCD and power + powerRegen + 20 < powerMax and (not poolForPiercing or lowestVuln > gcd) then
                if cast.multiShot() then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=spell_targets.multi_shot=1&variable.vuln_aim_casts>0&debuff.vulnerability.remains>(2*attack_haste)&variable.can_gcd&focus+cast_regen+20<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if ((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) and vulnAimCast > 0 and debuff.vulnerable.remain(units.dyn40) > (2 * attackHaste) 
                and canGCD and power + powerRegen + 20 < powerMax and (not poolForPiercing or lowestVuln > gcd) 
            then
                if cast.arcaneShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=talent.sidewinders.enabled&(debuff.vulnerability.remains>cast_time|(buff.lock_and_load.down&action.windburst.in_flight))&(variable.vuln_window-(2*attack_haste*variable.vuln_aim_casts)<1|focus.deficit<25|buff.trueshot.up)&(spell_targets.multishot=1|focus>100)
            if talent.sidewinders and (debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) or (not buff.lockAndLoad.exists() and lastSpell == spell.windburst)) 
                and (vulnWindow - (2 * attackHaste * vulnAimCast) < 1 or powerDeficit < 25 or buff.trueshot.exists()) 
                and (((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) or power > 100)
            then
                if cast.aimedShot() then return end
            end
            -- aimed_shot,if=!talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time&(!variable.pooling_for_piercing|(focus>100&lowest_vuln_within.5>(execute_time+gcd.max)))
            if not talent.sidewinders and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and (not poolForPiercing or (power > 100 and lowestVuln > (getCastTime(spell.aimedShot) + gcd))) then
                if cast.aimedShot() then return end
            end
        -- Marked Shot
            -- marked_shot,if=!talent.sidewinders.enabled&!variable.pooling_for_piercing
            if not talent.sidewinders and not poolForPiercing then
                if cast.markedShot() then return end
            end
            -- marked_shot,if=talent.sidewinders.enabled&(variable.vuln_aim_casts<1|buff.trueshot.up|variable.vuln_window<(2*attack_haste))
            if talent.sidewinders and (vulnAimCast < 1 or buff.trueshot.exists() or vulnWindow < (2 * attackHaste)) then
                if cast.markedShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=spell_targets.multi_shot=1&focus>110
            if ((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) or power > 100 then
                if cast.aimedShot() then return end
            end
        -- Sidewinders
            -- sidewinders,if=(!debuff.hunters_mark.up|(!buff.marking_targets.up&!buff.trueshot.up))&((buff.marking_targets.up&variable.vuln_aim_casts<1)|buff.trueshot.up|charges_fractional>1.9)
            if (not debuff.huntersMark.exists(units.dyn40) or (not buff.markingTargets.exists() and not buff.trueshot.exists())) 
                and ((buff.markingTargets.exists() and vulnAimCast < 1) or buff.trueshot.exists() or charges.frac.sidewinders > 1.9) 
            then
                if cast.sidewinders() then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=spell_targets.multi_shot=1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if ((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) and (not poolForPiercing or lowestVuln > gcd) then
                if cast.arcaneShot() then return end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets>1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if ((mode.rotation == 1 and #enemies.yards8t > 1) or mode.rotation == 2) and (not poolForPiercing or lowestVuln > gcd) then
                if cast.multiShot() then return end
            end            
        end -- End Action List - Patient Sniper
    -- Action List - Target Die 
        local function actionList_TargetDie()
        -- Piercing Shot
            -- piercing_shot,if=debuff.vulnerability.up
            if debuff.vulnerable.exists(units.dyn40) then
                if cast.piercingShot() then return end
            end
        -- Explosive Shot
            -- explosive_shot
            if cast.explosiveShot() then explosiveTarget = units.dyn40; return end
        -- Windburst
            -- windburst
            if cast.windburst() then return end
        -- Aimed Shot
            -- aimed_shot,if=debuff.vulnerability.up&buff.lock_and_load.up
            if debuff.vulnerable.exists(units.dyn40) and buff.lockAndLoad.exists() then
                if cast.aimedShot() then return end
            end
        -- Marked Shot
            -- marked_shot
            if cast.markedShot() then return end
        -- Arcane Shot
            -- arcane_shot,if=buff.marking_targets.up|buff.trueshot.up
            if buff.markingTargets.exists() or buff.trueshot.exists() then
                if cast.arcaneShot() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=debuff.vulnerability.remains>execute_time&target.time_to_die>cast_time
            if debuff.vulnerable.exists(units.dyn40) and ttd(units.dyn40) > getCastTime(spell.aimedShot) then
                if cast.aimedShot() then return end
            end
        -- Sidewinders
            -- sidewinders
            if cast.sidewinders() then return end
        -- Arcane Shot
            -- arcane_shot
            if cast.arcaneShot() then return end
        end -- End Action List - Target Die
    -- Action List - Single Target
        local function actionList_SingleTarget()
            -- A Murder of Crows
            if talent.aMurderOfCrows and (debuff.vulnerable.exists(units.dyn40) or (debuff.vulnerable.remain(units.dyn40) < getCastTime(spell.aimedShot) and not buff.lockAndLoad.exists() )) then
                if cast.aMurderOfCrows(units.dyn40) then return end
            end
            -- Piercing Shot
            -- if not HasTalent(PatientSniper) and Power > 50
            if talent.piercingShot and not talent.patientSniper and power > 50 then
                if cast.piercingShot(units.dyn40) then return end
            end
            -- Windburst
            if cast.windburst(units.dyn40) and not debuff.vulnerable.exists(units.dyn40) then return end
            -- Aimed Shot
            -- if HasBuff(LockAndLoad) and HasBuff(Vulnerable) and HasTalent(PatientSniper)
            if buff.lockAndLoad.exists() and debuff.vulnerable.exists(units.dyn40) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Multi-Shot
            -- if TargetsInRadius(MultiShot) > 1 and HasBuff(MarkingTargets) and BuffCount(HuntersMark) < TargetsInRadius(MultiShot)
            if #multishotTargets > 1 and buff.markingTargets.exists() and debuffcount.huntersMark < #multishotTargets then
                if cast.multiShot(units.dyn40) then return end
            end
            -- Arcane Shot
            -- if (HasBuff(MarkingTargets) or HasBuff(Trueshot)) and not HasBuff(HuntersMark)
            if (buff.markingTargets.exists() or buff.trueshot.exists()) and debuff.huntersMark.exists(units.dyn40) == false then
                if cast.arcaneShot(units.dyn40) then return end
            end
            -- Sentinel
            -- if not HasBuff(HuntersMark) and not HasBuff(Vulnerable) and not HasBuff(MarkingTargets)
            -- is a cooldown

            -- Aimed Shot
            -- if SpellCastTimeSec(AimedShot) < BuffRemainingSec(Vulnerable) and
            -- (not HasTalent(Barrage) or CooldownSecRemaining(Barrage) > GlobalCooldownSec)
            if getCastTime(spell.aimedShot) < debuff.vulnerable.remain(units.dyn40) and (not talent.piercingShot or cd.piercingShot > debuff.vulnerable.remain(units.dyn40)) then       
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Marked Shot
            if (debuff.vulnerable.remain(units.dyn40) < getCastTime(spell.aimedShot) and debuff.huntersMark.exists(units.dyn40))then
                if cast.markedShot(units.dyn40) then
                    return 
                end
            end
            -- Bursting Shot
            -- if HasItem(MagnetizedBlastingCapLauncher) and SecondsUntilAoe(2,8) > SpellCooldownSec(BurstingShot)

            -- Black Arrow
            if talent.blackArrow then
                if cast.blackArrow(units.dyn40) then return end
            end
            -- Explosive Shot
            if isChecked("Explosive Shot") and talent.explosiveShot then
                if cast.explosiveShot(units.dyn40) then explosiveTarget = units.dyn40; return end
            end
            -- Aimed Shot
            if powerDeficit < 25 then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Sidewinders
            -- if not HasBuff(HuntersMark) and (HasBuff(MarkingTargets) or HasBuff(Trueshot)) or
            -- ChargeSecRemaining(Sidewinders) < BuffDurationSec(Vulnerable) - SpellCastTimeSec(AimedShot)
            if talent.sidewinders and debuff.huntersMark.exists(units.dyn40) == false and (buff.markingTargets.exists() or buff.trueshot.exists()) or recharge.sidewinders < (debuff.vulnerable.duration(units.dyn40) - getCastTime(spell.aimedShot)) then
                if cast.sidewinders(units.dyn40) then return end
            end
            -- Arcane Shot
            -- if not HasBuff(HuntersMark) or not HasBuff(MarkingTargets)
            if debuff.huntersMark.exists(units.dyn40) == false or buff.markingTargets.exists() == false then
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
            if isChecked("Explosive Shot") and talent.explosiveShot then
                if cast.explosiveShot(units.dyn40) then explosiveTarget = units.dyn40; return end
            end
            -- Multi-Shot
            -- if BuffCount(HuntersMark) < 2 and (HasBuff(MarkingTargets) or HasBuff(Trueshot))
            if debuffcount.huntersMark < 2 and (buff.markingTargets.exists() or buff.trueshot.exists()) then
                if cast.multiShot(units.dyn40) then return end
            end
            -- Sidewinders
            -- if BuffCount(HuntersMark) < 2 and (HasBuff(MarkingTargets) or HasBuff(Trueshot))
            if debuffcount.huntersMark < 2 and (buff.markingTargets.exists() or buff.trueshot.exists()) then
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
            if talent.trickShot and debuffcount.vulnerable > 1 and buff.lockAndLoad.exists() then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- Multi-Shot
            if cast.multiShot(units.dyn40) then return end
            -- Arcane Shot
            if cast.arcaneShot(units.dyn40) then return end
        end -- End Action List - Multi Target
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
            if not inCombat then
            -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if isChecked("Flask / Crystal") then
                    if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                        useItem(br.player.flask.wod.agilityBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                            useItem(118922)
                            return true
                        end
                    end
                end
            -- Summon Pet
                -- summon_pet
                if actionList_PetManagement() then return end
                if isValidUnit("target") and getDistance("target") < 40 then
            -- Windburst
                    -- windburst
                    if cast.windburst() then return end
            -- Auto Shot
                    StartAttack()
                end
            end
        end 
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
------------------
--- Pre-Combat ---
------------------
            if not inCombat then
                if actionList_PreCombat() then return end
            end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and isCastingSpell(spell.barrage) == false then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
                -- Auto Shot
                    -- auto_shot
                    if getDistance(units.dyn40) < 40 then
                        StartAttack()
                    end
                -- Volley
                    -- volley,toggle=on
                    if not buff.volley.exists() then
                        if cast.volley(units.dyn40) then return end
                    end
                -- Call Action List - Cooldowns
                    -- call_action_list,name=cooldowns
                    if actionList_Cooldowns() then return end
                -- Call Action List - Target Die
                    -- call_action_list,name=targetdie,if=target.time_to_die<6&spell_targets.multishot=1
                    if ttd(units.dyn40) < 6 and ((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) then
                        if actionList_TargetDie() then return end
                    end
                -- Call Action List - Patient Sniper
                    -- call_action_list,name=patient_sniper,if=talent.patient_sniper.enabled
                    if talent.patientSniper then
                        if actionList_PatientSniper() then return end
                    end
                -- Call Action List - Non-Patient Sniper
                    -- call_action_list,name=non_patient_sniper,if=!talent.patient_sniper.enabled
                    if not talent.patientSniper then
                        if actionList_NonPatientSniper() then return end
                    end
                end -- End SimC APL
    ------------------------
    --- Ask Mr Robot APL ---
    ------------------------
                if getOptionValue("APL Mode") == 2 then
                    -- Volley
                    -- If you choose this talent, you will do more damage by having it always on, even against one target.
                    if not buff.volley.exists() then
                        if cast.volley(units.dyn40) then return end
                    end
                    -- Arcane Shot
                    -- if WasLastSpell(ArcaneShot) and HasTalent(SteadyFocus) and not HasBuff(SteadyFocus) and PowerToMax >= GlobalCooldownSec * 2 * PowerRegen + 10
                    if lastSpellCast == spell.arcaneShot and talent.steadyFocus and not buff.steadyFocus.exists() and powerDeficit >= gcd * 2 * powerRegen + 10 then
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

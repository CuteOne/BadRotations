local rotationName = "Aura"

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
-- Explosive Shot Button
    ExplosiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Explosive Shot Enabled", tip = "Will use Explosive Shot.", highlight = 1, icon = br.player.spell.explosiveShot },
        [2] = { mode = "Off", value = 2 , overlay = "Explosive Shot Disabled", tip = "Explosive Shot will not be used.", highlight = 0, icon = br.player.spell.explosiveShot }
    };
    CreateButton("Explosive",5,0)
-- Piercing Shot Button
    PiercingModes = {
        [1] = { mode = "On", value = 1 , overlay = "Piercing Shot Enabled", tip = "Will use Piercing Shot.", highlight = 1, icon = br.player.spell.piercingShot },
        [2] = { mode = "Off", value = 2 , overlay = "Piercing Shot Disabled", tip = "Piercing Shot will not be used.", highlight = 0, icon = br.player.spell.piercingShot }
    };
    CreateButton("Piercing",6,0)
-- MD Button
    MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    CreateButton("Misdirection",7, 0)
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
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC", "|cffFFFFFFIcy Veins"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Explosive Shot
            -- br.ui:createCheckbox(section, "Explosive Shot")
        -- Piercing Shot
            -- br.ui:createCheckbox(section, "Piercing Shot")
            br.ui:createSpinnerWithout(section, "Piercing Shot Units", 3, 1, 5, 1, "|cffFFFFFFSet to desired units to cast Piercing Shot")
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
        -- Explosive Shot Key Toggle
            br.ui:createDropdown(section, "Explosive Shot Mode", br.dropOptions.Toggle,  6)
        -- Piercing Shot Key Toggle
            br.ui:createDropdown(section, "Piercing Shot Mode", br.dropOptions.Toggle,  6)
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
        UpdateToggle("Explosive",0.25)
        br.player.mode.explosive = br.data.settings[br.selectedSpec].toggles["Explosive"]
        UpdateToggle("Piercing",0.25)
        br.player.mode.piercing = br.data.settings[br.selectedSpec].toggles["Piercing"]
        br.player.mode.misdirection = br.data.settings[br.selectedSpec].toggles["Misdirection"]

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
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff, debuffcount                           = br.player.debuff, br.player.debuffcount
        local enemies                                       = enemies or {}
        local explosiveTarget                               = explosiveTarget
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local fatality                                      = false
        local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
        local friendly                                      = friendly or UnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = GetObjectExists("mouseover")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastCast
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
        local power, powerMax, powerRegen, powerDeficit     = br.player.power.focus.amount(), br.player.power.focus.max(), br.player.power.focus.regen(), br.player.power.focus.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local solo                                          = #br.friend < 2
        local friendsInRange                                = friendsInRange
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local trinketProc                                   = false
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.focus.ttm()
        local units                                         = units or {}
        local t20_2pc                                       = TierScan("T20") >= 2

        units.dyn38 = br.player.units(40 * (1 + GetMasteryEffect()/100))
        units.dyn40 = br.player.units(40 * (1 + GetMasteryEffect()/100))
        enemies.yards8t = br.player.enemies(8,br.player.units(40,true))
        enemies.yards40 = br.player.enemies(40 * (1 + GetMasteryEffect()/100))
        enemies.yards40r = getEnemiesInRect(10,40 * (1 + GetMasteryEffect()/100),false) or 0

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        --ExecuteTime (credits to dknk)
        function getExecuteTime(spellId)
                local spellId = spellId
                local castTime = getCastTime(spellId) or 0
                local gcd = getSpellCD(61304)
                local t = (castTime > gcd) and castTime or gcd
                return t
        end
        -- Spell Power Cost (credits to dknk)
        function getSpellPowerCost(spellID)
         local cost = GetSpellPowerCost(spellID)[1].cost
         return cost
        end 

        local lowestVuln
        for i=1,#enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if lowestVuln == nil then lowestVuln = 100 end
            if debuff.vulnerable.remain(thisUnit) < lowestVuln and debuff.vulnerable.remain(thisUnit) > 0 then
                lowestVuln = debuff.vulnerable.remain(thisUnit)
            end
        end
        if lowestVuln == nil or lowestVuln == 100 then lowestVuln = 0 end

        local attackHaste = 1 / (1 + (UnitSpellHaste("player")/100))

        -- Pool for Piercing Shot
        -- pooling_for_piercing,value=talent.piercing_shot.enabled&cooldown.piercing_shot.remains<5&lowest_vuln_within.5>0&lowest_vuln_within.5>cooldown.piercing_shot.remains&(buff.trueshot.down|spell_targets=1)
        local poolForPiercing
        if mode.piercing == 1 and talent.piercingShot and cd.piercingShot.remain() < 5 and lowestVuln > 0 and lowestVuln > cd.piercingShot.remain() and (not buff.trueshot.exists() or enemies.yards40r >= getOptionValue("Piercing Shot Units")) then
            poolForPiercing = true
        else
            poolForPiercing = false
        end

        -- Wait for Sentinel
        -- waiting_for_sentinel,value=talent.sentinel.enabled&(buff.marking_targets.up|buff.trueshot.up)&!cooldown.sentinel.up&((cooldown.sentinel.remains>54&cooldown.sentinel.remains<(54+gcd.max))|(cooldown.sentinel.remains>48&cooldown.sentinel.remains<(48+gcd.max))|(cooldown.sentinel.remains>42&cooldown.sentinel.remains<(42+gcd.max)))
        local waitForSentinel
        if talent.sentinel and (buff.markingTargets.exists() or buff.trueshot.exists()) and cd.sentinel.remain() > 0 
            and ((cd.sentinel.remain() > 54 and cd.sentinel.remain() < (54 + gcd)) or (cd.sentinel.remain() > 48 and cd.sentinel.remain() < (48 + gcd)) or (cd.sentinel.remain() > 42 and cd.sentinel.remain() < (42 + gcd))) 
        then
            waitForSentinel = true
        else
            waitForSentinel = false
        end

        -- Full RechargeTime of a Spell/dump getFullRechargeTime(214579)
        function getFullRechargeTime(spellID)
            local currentCharges,maxCharges,start,CD=GetSpellCharges(spellID)
            if maxCharges ~= nil then
                local currentChargeTime=(currentCharges or 0)<(maxCharges or 0) and CD -(GetTime()-(start or 0)) or 0
                local leftChargesTotalTime = (maxCharges - currentCharges - 1) * CD
                if currentCharges ~= maxCharges then
                    return currentChargeTime + leftChargesTotalTime
                end

            end
            return 0
        end

        -- VulnWindow variable
        local vulnWindow = vulnWindow or 0
        local sidewindersRecharge = sidewindersRecharge or 0
        vulnWindow = debuff.vulnerable.remain(units.dyn40)
        --talent.sidewinders.enabled&cooldown.sidewinders.full_recharge_time<variable.vuln_window
        if talent.sidewinders and getFullRechargeTime(spell.sidewinders) < vulnWindow then
            vulnWindow = getFullRechargeTime(spell.sidewinders)
        else
            vulnWindow = debuff.vulnerable.remain(units.dyn40)
        end
        

        -- Vulnerable Aim Casts
        local vulnAimCast = vulnAimCast or 0
        --actions.patient_sniper+=/variable,name=vuln_aim_casts,op=set,value=floor(variable.vuln_window%action.aimed_shot.execute_time)
        vulnAimCast = math.floor(vulnWindow /getExecuteTime(spell.aimedShot))
        -- vuln_aim_casts,op=set,value=floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost),if=variable.vuln_aim_casts>0&variable.vuln_aim_casts>floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost)
        if vulnAimCast > 0 and vulnAimCast > math.floor((power + getCastRegen(spell.aimedShot)*(vulnAimCast-1))/getSpellPowerCost(spell.aimedShot)) then
            vulnAimCast = math.floor((power + getCastRegen(spell.aimedShot)*(vulnAimCast-1))/getSpellPowerCost(spell.aimedShot))
        end

        -- Can GCD
        --can_gcd,value=variable.vuln_window<action.aimed_shot.cast_time|variable.vuln_window>variable.vuln_aim_casts*action.aimed_shot.execute_time+gcd.max+0.1
        local canGCD = vulnWindow < getCastTime(spell.aimedShot) or (vulnWindow > vulnAimCast* getExecuteTime(spell.aimedShot) + gcdMax + 0.1)       

        


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
            -- Find Explosive Shot Object
            local explosiveObject = nil
            if ObjectExists("target") and otherUnit == nil then otherUnit = "target" end
            if not ObjectExists(otherUnit) then otherUnit = nil end
            for i = 1,GetObjectCount() do
                local thisUnit = GetObjectWithIndex(i)
                if GetObjectID(thisUnit) == 11492 then
                    explosiveObject = thisUnit
                  --  print("Used Explosive!")
                    local x1, y1 = ObjectPosition(thisUnit)
                   -- print(tostring(ObjectName(thisUnit)))
                    break
                end
            end
            -- Return Distances
            if ObjectExists(explosiveObject) and ObjectExists(otherUnit) then
                return GetDistanceBetweenObjects(explosiveObject,otherUnit)
            -- elseif ObjectExists("target") then
            --     return GetDistanceBetweenObjects("target","player")
            else 
                return 99
            end
        end

        local function getAngle(unit1, unit2)
            local unit1X, unit1Y,unit1Z = GetObjectPosition(unit1)
            local unit1Facing = ObjectFacing(unit1)
            local unit2X, unit2Y,unit2Z = GetObjectPosition(unit2)

            if unit1X and unit2X then
                local angleToUnit = getAngles(unit1X,unit1Y,unit1Z,unit2X,unit2Y,unit2Z)
                local angleDifference = unit1Facing > angleToUnit and unit1Facing - angleToUnit or angleToUnit - unit1Facing
                local shortestAngle = angleDifference < math.pi and angleDifference or math.pi*2 - angleDifference
                local finalAngle = shortestAngle/math.pi*180
                return finalAngle
            end
            
        end

        currentExplosiveDistance = currentExplosiveDistance or 999
        if getExplosiveDistance(explosiveTarget) > currentExplosiveDistance then
            detonate = true
            currentExplosiveDistance = 999
        else
            currentExplosiveDistance = getExplosiveDistance(explosiveTarget)
        end
        -- Explosions Gotta Have More Explosions!
        if detonate then
          --  print("Explode NOW!")
            -- if castSpell(explosiveTarget,spell.explosiveShotDetonate,true,false,false,true,false,true,true,false) then Print("EXPLOSIONS!") return end
            CastSpellByName(GetSpellInfo(spell.explosiveShotDetonate))
            detonate = false
        end
        if getExplosiveDistance(explosiveTarget) < 99 then
            --print("Explosive Distance: "..getExplosiveDistance(explosiveTarget))
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Pet Management
        local function actionList_PetManagement()
            if not talent.loneWolf then
                if IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player") then
                    waitForPetToAppear = GetTime()
                elseif isChecked("Auto Summon") and not GetUnitExists("pet") and (UnitIsDeadOrGhost("pet") ~= nil or IsPetActive() == false) then
                    if waitForPetToAppear ~= nil and GetTime() - waitForPetToAppear > 2 then
                        if deadPet == true then
                            if cast.revivePet() then return end
                        elseif deadPet == false then
                            local Autocall = getValue("Auto Summon");
                            if Autocall == 1 then
                                if cast.callPet1() then return end
                            elseif Autocall == 2 then
                                if cast.callPet2() then return end
                            elseif Autocall == 3 then
                                if cast.callPet3() then return end
                            elseif Autocall == 4 then
                                if cast.callPet4() then return end
                            elseif Autocall == 5 then
                                if cast.callPet5() then return end
                            else
                                Print("Auto Call Pet Error")
                            end
                        end
                    end
                    if waitForPetToAppear == nil then
                        waitForPetToAppear = GetTime()
                    end
                end
                --Revive
                if isChecked("Auto Summon") and UnitIsDeadOrGhost("pet") then
                    if cast.revivePet() then return; end
                end
                -- Mend Pet
                if isChecked("Mend Pet") and getHP("pet") < getValue("Mend Pet") and not UnitBuffID("pet",136) then
                    if cast.mendPet() then return; end
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
                if GetObjectExists("target") then
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
         -- Misdirection
            if br.player.mode.misdirection == 1 then
              if getSpellCD(34477) <= 0.1 then
                if (UnitThreatSituation("player", "target") ~= nil or (UnitExists("target") and isDummy("target"))) and UnitAffectingCombat("player") then
                    if inInstance or inRaid then
                        for i = 1, #br.friend do
                            if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and UnitAffectingCombat(br.friend[i].unit) then
                              CastSpellByName(GetSpellInfo(34477),br.friend[i].unit)
                            end
                        end
                    else
                        if GetUnitExists("pet") then
                          CastSpellByName(GetSpellInfo(34477),"pet")
                        end
                    end
                end
              end
            end
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
                    if hasEquiped(147017) and (((cd.trueshot.remain() < 6 or cd.trueshot.remain() > 30) and (ttd(units.dyn40) > 120+ 20)) or (ttd(units.dyn40) < 25 or buff.bullseye.stack() == 30)) then
                        useItem(147017)
                    end
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
        -- Agi-Pot
                if isChecked("Agi-Pot") then
                    if canUse(142117) and (buff.trueshot.exists() and buff.bloodlust.exists()) or buff.bullseye.stack() >= 23 or ttd(units.dyn40) < 31 then
                        useItem(142117)
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- arcane_torrent,if=focus.deficit>=30&(!talent.sidewinders.enabled|cooldown.sidewinders.charges<2)
                -- berserking,if=buff.trueshot.up
                -- blood_fury,if=buff.trueshot.up
                if isChecked("Racial") and ((buff.trueshot.exists() and (br.player.race == "Orc" or br.player.race == "Troll")) 
                        or (powerDeficit >= 30 and (not talent.sidewinders or charges.sidewinders.count() < 2) and br.player.race == "BloodElf")) and getSpellCD(racial) == 0 
                then
                     if castSpell("player",racial,false,false,false) then return end
                end
        -- Trueshot
                -- variable,name=trueshot_cooldown,op=set,value=time*1.1,if=time>15&cooldown.trueshot.up&variable.trueshot_cooldown=0
                -- trueshot,if=variable.trueshot_cooldown=0|buff.bloodlust.up|(variable.trueshot_cooldown>0&target.time_to_die>(variable.trueshot_cooldown+duration))|buff.bullseye.react>25|target.time_to_die<16
                if isChecked("Trueshot") then
                    local trueshotCD = trueshotCD or 0
                    if combatTime > 15 and cd.trueshot.remain() == 0 and trueshotCD == 0 then trueshotCD = combatTime * 1.1 else trueshotCD = 0 end
                    if trueshotCD == 0 or hasBloodLust() or (trueshotCD > 0 and ttd(units.dyn40) > (trueshotCD + buff.trueshot.duration())) or buff.bullseye.exists() or ttd(units.dyn40) < 16 then
                        if (lastSpell == spell.markedShot or lastSpell == spell.windburst) then
                            if cast.trueshot("player") then return end
                        end
                    end
                end
            end -- End useCooldowns check
        end -- End Action List - Cooldowns
        -- Action List - Target Die 
        local function actionList_TargetDie()
        -- Piercing Shot
            -- piercing_shot,if=debuff.vulnerability.up
            if mode.piercing == 1 and debuff.vulnerable.exists(units.dyn40) and enemies.yards40r >= getOptionValue("Piercing Shot Units") then
                if cast.piercingShot(units.dyn38) then return end
            end
        -- Windburst
            -- windburst
            if cast.windburst(units.dyn40) then return end
        -- Aimed Shot
            -- aimed_shot,if=debuff.vulnerability.remains>cast_time&target.time_to_die>cast_time
            if debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and ttd(units.dyn40) > getCastTime(spell.aimedShot) then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Marked Shot
            -- marked_shot
            if not isCastingSpell(spell.windburst) and power > 85 then
                if debuff.huntersMark.count() > 1 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.huntersMark.exists(thisUnit) and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                            if cast.markedShot(thisUnit) then return end
                        end
                    end
                end
            end
        -- Arcane Shot
            -- arcane_shot
              if cast.arcaneShot(units.dyn40) and (not debuff.vulnerable.exists(units.dyn40) or (debuff.vulnerable.exists(units.dyn40) and debuff.vulnerable.remain(units.dyn40) < getCastTime(spell.aimedShot))) then return end
        -- Sidewinders
            -- sidewinders

            if charges.sidewinders.count() >= 1 and getSpellCD(spell.sidewinders) < gcd and getSpellCD(214579) < gcd then
                if cast.sidewinders() then return end
            end
        end -- End Action List - Target Die

    -- Action List Non Patient Sniper
        local function actionList_NonPatientSniper()
        -- Explosive Shot
            -- explosive_shot
            if mode.explosive == 1 and talent.explosiveShot and cd.explosiveShot.remain() == 0 then
                if getAngle("player",units.dyn40) < 3 then
                    if cast.explosiveShot(units.dyn40) then explosiveTarget = units.dyn40; return end
                end
            end
            -- Bursting Shot
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and hasEquiped(141353) and not debuff.vulnerable.exists(units.dyn40) then
                if cast.burstingShot() then return end
            end
        -- Piercing Shot
            -- piercing_shot,if=lowest_vuln_within.5>0&focus>100
            if talent.piercingShot then
                if mode.piercing == 1 and lowestVuln > 0 and power > 100 and enemies.yards40r >= getOptionValue("Piercing Shot Units") then
                    if cast.piercingShot(units.dyn38) then return end
                end
            end
        -- Aimed Shot
            -- aimed_shot,if=spell_targets>1&debuff.vulnerability.remains>cast_time&talent.trick_shot.enabled&buff.sentinels_sight.stack=20
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and (talent.trickShot or buff.lockAndLoad.exists()) and buff.sentinelsSight.stack() == 20 then
                if cast.aimedShot(units.dyn40) then return end
            end
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot)  and talent.trickShot and t20_2pc and not buff.t20_2pc_critical_aimed.exists() and lastSpellCast == spell.aimedShot then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Marked Shot
            -- marked_shot,if=spell_targets>1
            if debuff.huntersMark.count() > 1 and power > 70 and cd.windburst.remain() > 2 and cd.windburst.remain() < 18 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                  if debuff.huntersMark.exists(thisUnit) and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                        if cast.markedShot(thisUnit) then return end
                  end
                end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets>1&(buff.marking_targets.up|buff.trueshot.up)
            if ((mode.rotation == 1 and (#enemies.yards8t > 2 )) or mode.rotation == 2) and (buff.markingTargets.exists() or buff.trueshot.exists()) 
            then
                if cast.multiShot(units.dyn40) then return end
            end
        -- Sentinel
            -- sentinel,if=!debuff.hunters_mark.up
            if not debuff.huntersMark.exists(units.dyn40) then
                if cast.sentinel() then return end
            end 
        -- Black Arrow
            -- black_arrow,if=talent.sidewinders.enabled|spell_targets.multishot<6
            if talent.sidewinders or #enemies.yards8t < 6 then
                if cast.blackArrow(units.dyn40) then return end
            end  
        -- A Murder of Crows
            -- a_murder_of_crows
            if ttd(units.dyn40) >= 75 or getHP(units.dyn40) < 20 then
              if cast.aMurderOfCrows(units.dyn40) then return end
            end
        -- Windburst
            -- windburst
            if power >= 50 then
                if cast.windburst(units.dyn40) then return end
            end
        -- Barrage
            -- barrage,if=spell_targets>2|(target.health.pct<20&buff.bullseye.stack<25)
            if ((mode.rotation == 1 and #enemies.yards40 > 2) or mode.rotation == 2) or (getHP(units.dyn40) < 20 and buff.bullseye.stack() < 25) then
                if cast.barrage(units.dyn40) then return end
            end
        -- Marked Shot
            -- marked_shot,if=buff.marking_targets.up|buff.trueshot.up
            if power > 70 and cd.windburst.remain() > 2 and cd.windburst.remain() < 18 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.huntersMark.exists(thisUnit) and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                        if cast.markedShot(thisUnit) then return end
                    end
                end
            end
        -- Sidewinders
            -- !variable.waiting_for_sentinel&(debuff.hunters_mark.down|(buff.trueshot.down&buff.marking_targets.down))&((buff.marking_targets.up|buff.trueshot.up)|charges_fractional>1.8)&(focus.deficit>cast_regen)
            if talent.sidewinders and not waitForSentinel and (not debuff.huntersMark.exists(units.dyn40) or (not buff.trueshot.exists() and not buff.markingTargets.exists())) 
                and ((buff.markingTargets.exists() or buff.trueshot.exists()) or charges.sidewinders.frac() > 1.8) and (powerDeficit > getCastRegen(spell.sidewinders)) and charges.sidewinders.count() >= 1 and lastSpell ~= spell.sidewinders
            then
                if cast.sidewinders() then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time
            if talent.sidewinders and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- aimed_shot,if=!talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time&(!variable.pooling_for_piercing|(buff.lock_and_load.up&lowest_vuln_within.5>gcd.max))&(spell_targets.multishot<4|talent.trick_shot.enabled|buff.sentinels_sight.stack=20)
            if not talent.sidewinders and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and (not poolForPiercing or (buff.lockAndLoad.exists() and lowestVuln > gcdMax)) 
                and (((mode.rotation == 1 and #enemies.yards8t < 4) or mode.rotation == 3) or talent.trickShot or buff.sentinelsSight.stack() == 20) 
            then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Marked Shot
            -- marked_shot
            if power > 70 and cd.windburst.remain() > 2 and cd.windburst.remain() < 18 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if debuff.huntersMark.exists(thisUnit) and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                      if cast.markedShot(thisUnit) then return end
                    end
                end
            end
        -- Aimed Shot
            -- aimed_shot,if=focus+cast_regen>focus.max&!buff.sentinels_sight.up
            if power + getCastRegen(spell.aimedShot) > powerMax and not buff.sentinelsSight.exists() then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets.multi_shot>1&!variable.waiting_for_sentinel
            if ((mode.rotation == 1 and #enemies.yards8t > 1)  or mode.rotation == 2) and not waitForSentinel then
                if cast.multiShot(units.dyn40) then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=spell_targets.multi_shot<2&!variable.waiting_for_sentinel
            if ((mode.rotation == 1 and #enemies.yards8t < 2) or mode.rotation == 3) and not waitForSentinel then
                if cast.arcaneShot(units.dyn40) then return end
            end
        end -- End Action List - Non Patient Sniper

    -- Action List - Patient Sniper
        local function actionList_PatientSniper()
            
        -- Piercing Shot
            -- piercing_shot,if=cooldown.piercing_shot.up&spell_targets=1&lowest_vuln_within.5>0&lowest_vuln_within.5<1
            if mode.piercing == 1 and cd.piercingShot.remain() == 0 and enemies.yards40r >= getOptionValue("Piercing Shot Units") and lowestVuln > 0 and lowestVuln < 1 then
                if cast.piercingShot(units.dyn40) then return end
            end
            -- piercing_shot,if=cooldown.piercing_shot.up&spell_targets>1&lowest_vuln_within.5>0&((!buff.trueshot.up&focus>80&(lowest_vuln_within.5<1|debuff.hunters_mark.up))|(buff.trueshot.up&focus>105&lowest_vuln_within.5<6))
            if mode.piercing == 1 and cd.piercingShot.remain() == 0 and enemies.yards40r >= getOptionValue("Piercing Shot Units") and lowestVuln > 0 
                and ((not buff.trueshot.exists() and power > 80 and (lowestVuln < 1 or debuff.huntersMark.exists(units.dyn40))) or (buff.trueshot.exists() and power > 105 and lowestVuln < 6)) 
            then
                if cast.piercingShot(units.dyn38) then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=spell_targets>1&talent.trick_shot.enabled&debuff.vulnerability.remains>cast_time&(buff.sentinels_sight.stack>=spell_targets.multishot*5|buff.sentinels_sight.stack+(spell_targets.multishot%2)>20|buff.lock_and_load.up|(set_bonus.tier20_2pc&!buff.t20_2p_critical_aimed_damage.up&action.aimed_shot.in_flight))
            if ((mode.rotation == 1 and #enemies.yards40 > 1) or mode.rotation == 2) and talent.trickShot and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot)  and (buff.sentinelsSight.stack() >= #enemies.yards8t * 5 or (buff.sentinelsSight.stack() + ((#enemies.yards8t % 2)) > 20) or buff.lockAndLoad.exists() or (t20_2pc and not buff.t20_2pc_critical_aimed.exists() and lastSpellCast == spell.aimedShot ))  then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Marked Shot
            -- marked_shot,if=spell_targets>1
            if ((mode.rotation == 1 and debuff.huntersMark.count() > 1) or mode.rotation == 2) then
                if debuff.huntersMark.count() > 1 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.huntersMark.exists(thisUnit) then
                            if cast.markedShot(thisUnit) then
                            --print("Marked Shot A cast at "..power.." Focus") 
                                return 
                            end
                        end
                    end
                end
            end
        -- Multi-Shot
            -- multi-shot,if=spell_targets>1&(buff.marking_targets.up|buff.trueshot.up)
            if ((mode.rotation == 1 and (#enemies.yards8t > 2 or (debuff.huntersMark.exists(units.dyn40) and #enemies.yards8t > 1))) or mode.rotation == 2) and (buff.markingTargets.exists() or buff.trueshot.exists()) then
                if cast.multiShot(units.dyn40) then return end
            end
        -- Windburst
            -- windburst,if=variable.vuln_aim_casts<1&!variable.pooling_for_piercing
            if vulnAimCast < 1 and not poolForPiercing and power >= 50 and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                if cast.windburst(units.dyn40) then
               -- print("Windburst cast at "..power.." Focus") 
                    return 
                end
            end
        -- Black Arrow
            -- black_arrow,if=variable.can_gcd&(!variable.pooling_for_piercing|(lowest_vuln_within.5>gcd.max&focus>85))
            if talent.blackArrow then
                if  canGCD and not poolForPiercing or (lowestVuln > gcdMax and power > 85) then
                    if cast.blackArrow(units.dyn40) then return end
                end
            end
        -- A Murder of Crows
            -- a_murder_of_crows,if=(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)&(target.time_to_die>=cooldown+duration|target.health.pct<20|target.time_to_die<16)&variable.vuln_aim_casts=0
            if (not poolForPiercing or lowestVuln > gcdMax) and (ttd(units.dyn40) >= cd.aMurderOfCrows.remain() + 15 or getHP(units.dyn40) < 20 or ttd(units.dyn40) < 16) and vulnAimCast == 0 then
                if cast.aMurderOfCrows(units.dyn40) then return end
            end
        -- Barrage
            -- barrage,if=spell_targets>2|(target.health.pct<20&buff.bullseye.stack<25)
            if ((mode.rotation == 1 and #enemies.yards40 > 2) or mode.rotation == 2) or (getHP(units.dyn40) < 20 and buff.bullseye.stack() < 25) then
                if cast.barrage(units.dyn40) then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=debuff.vulnerability.up&buff.lock_and_load.up&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if debuff.vulnerable.exists(units.dyn40) and buff.lockAndLoad.exists() and (not poolForPiercing or lowestVuln > gcdMax) then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- aimed_shot,if=spell_targets.multishot>1&debuff.vulnerability.remains>execute_time&(!variable.pooling_for_piercing|(focus>100&lowest_vuln_within.5>(execute_time+gcd.max)))
            if ((mode.rotation == 1 and #enemies.yards8t >= 1) or mode.rotation == 2) and debuff.vulnerable.remain(units.dyn40) > getExecuteTime(spell.aimedShot) 
                and (not poolForPiercing or (power > 100 and lowestVuln > (getExecuteTime(spell.aimedShot) + gcdMax))) 
            then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Multi-Shot
            -- multishot,if=spell_targets>1&variable.can_gcd&focus+cast_regen+action.aimed_shot.cast_regen<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if ((mode.rotation == 1 and (#enemies.yards8t > 2 or (debuff.huntersMark.exists(units.dyn40) and #enemies.yards8t > 1))) or mode.rotation == 2) and canGCD and power + (getCastRegen(spell.multiShot) + getCastRegen(spell.aimedShot)) < powerMax and (not poolForPiercing or lowestVuln > gcdMax) then
                if cast.multiShot(units.dyn40) then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=spell_targets.multishot=1&(!set_bonus.tier20_2pc|!action.aimed_shot.in_flight|buff.t20_2p_critical_aimed_damage.remains>action.aimed_shot.execute_time+gcd)&variable.vuln_aim_casts>0&variable.can_gcd&focus+cast_regen+action.aimed_shot.cast_regen<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd)
            if ((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) and (not t20_2pc or lastSpellCast ~= spell.aimedShot or (buff.t20_2pc_critical_aimed.exists() and buff.t20_2pc_critical_aimed.remain > (getExecuteTime(spell.aimedShot) + gcd))) 
               and vulnAimCast > 0 and canGCD and power + getCastRegen(spell.arcaneShot) + getCastRegen(spell.aimedShot) < powerMax and (not poolForPiercing or lowestVuln > gcd) 
            then
                if cast.arcaneShot(units.dyn40) then return end
            end
        -- Aimed Shot
            -- aimed_shot,if=talent.sidewinders.enabled&(debuff.vulnerability.remains>cast_time|(buff.lock_and_load.down&action.windburst.in_flight))&(variable.vuln_window-(execute_time*variable.vuln_aim_casts)<1|focus.deficit<25|buff.trueshot.up)&(spell_targets.multishot=1|focus>100)
            if talent.sidewinders and (debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) or (not buff.lockAndLoad.exists() and lastSpell == spell.windburst)) 
                and (vulnWindow - (getExecuteTime(spell.aimedShot)*vulnAimCast) < 1 or powerDeficit < 25 or buff.trueshot.exists()) 
                and (((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) or power > 100)
            then
                if cast.aimedShot(units.dyn40) then return end
            end
            -- aimed_shot,if=!talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time&(!variable.pooling_for_piercing|lowest_vuln_within.5>execute_time+gcd.max)
            if not talent.sidewinders and debuff.vulnerable.remain(units.dyn40) > getCastTime(spell.aimedShot) and (not poolForPiercing or lowestVuln > getExecuteTime(spell.aimedShot) + gcdMax) then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Marked Shot
            -- marked_shot,if=!talent.sidewinders.enabled&!variable.pooling_for_piercing&!action.windburst.in_flight&(focus>65|buff.trueshot.up|(1%attack_haste)>1.171)
            if not talent.sidewinders and not poolForPiercing and cd.windburst.remain() > 2 and cd.windburst.remain() < 18 and power > 70 then
                if debuff.huntersMark.count() >= 1 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.huntersMark.exists(thisUnit) and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                            if cast.markedShot(thisUnit) then
                            --print("Marked Shot B cast at "..power.." Focus") 
                            return end
                        end
                    end
                end
            end
        -- Marked Shot
            -- marked_shot,if=talent.sidewinders.enabled&(variable.vuln_aim_casts<1|buff.trueshot.up|variable.vuln_window<action.aimed_shot.cast_time)
            if talent.sidewinders and (vulnAimCast < 1 or buff.trueshot.exists() or vulnWindow < getCastTime(spell.aimedShot)) and power > 70 and cd.windburst.remain() > 2 and cd.windburst.remain() < 18 then
                if debuff.huntersMark.count() >= 1 then
                    for i = 1, #enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if debuff.huntersMark.exists(thisUnit) and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                            if cast.markedShot(thisUnit) then
                            --print("Marked Shot C cast at "..power.." Focus") 
                            return end
                        end
                    end
                end
            end
        -- Aimed Shot
            -- aimed_shot,if=focus+cast_regen>focus.max&!buff.sentinels_sight.up
            if power + getCastRegen(spell.aimedShot) > powerMax and not buff.sentinelsSight.exists() then
                if cast.aimedShot(units.dyn40) then return end
            end
        -- Sidewinders
            -- sidewinders,if=(!debuff.hunters_mark.up|(!buff.marking_targets.up&!buff.trueshot.up))&((buff.marking_targets.up&variable.vuln_aim_casts<1)|buff.trueshot.up|charges_fractional>1.9)
            if (not debuff.huntersMark.exists(units.dyn40) or (not buff.markingTargets.exists() and not buff.trueshot.exists())) and ((buff.markingTargets.exists() and vulnAimCast < 1) or buff.trueshot.exists() or charges.sidewinders.frac() > 1.9) and charges.sidewinders.count() >= 1 and lastSpell ~= spell.sidewinders then
                if cast.sidewinders() then return end
            end
        -- Arcane Shot
            -- arcane_shot,if=spell_targets.multi_shot=1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if ((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) and (not poolForPiercing or lowestVuln > gcdMax) then
                if (power < 90 and not debuff.vulnerable.exists(units.dyn40)) or (power <= 70 and debuff.vulnerable.exists(units.dyn40)) then
                    if cast.arcaneShot(units.dyn40) then return  end
                end
            end
        -- Multi-Shot
            -- Multi-Shot,if=spell_targets>1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
            if ((mode.rotation == 1 and (#enemies.yards8t > 2 or (debuff.huntersMark.exists(units.dyn40) and #enemies.yards8t > 1))) or mode.rotation == 2) and (not poolForPiercing or lowestVuln > gcdMax) then
                if cast.multiShot(units.dyn40) then return end
            end            
        end -- End Action List - Patient Sniper
    
    
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
             --   if isValidUnit("target") and getDistance("target") < 40 then
            -- Windburst
                    -- windburst
             --       if cast.windburst() then return end
            -- Auto Shot
             --      StartAttack()
             --   end
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
                if getOptionValue("APL Mode") == 2 then -- IV APL
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
                    -- Patient Sniper
                    if talent.patientSniper then
                        if getHP(units.dyn40) > 25 or getHP(units.dyn40) <= 20 then
                            if cast.aMurderOfCrows(units.dyn40) then return end
                        end
                        if (vulnAimCast < 1 or (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot)))) and power >= 50 then
                            if cast.windburst(units.dyn40) then return end
                        end
                        if vulnAimCast < 1 and cd.windburst.remain() >= 2 and power >= 70 then
                            for i = 1, #enemies.yards40 do
                                local thisUnit = enemies.yards40[i]
                                if debuff.huntersMark.exists(thisUnit) and (not debuff.vulnerable.exists(thisUnit) or (debuff.vulnerable.exists(thisUnit) and debuff.vulnerable.remain(thisUnit) < getCastTime(spell.aimedShot))) then
                                    if cast.markedShot(thisUnit) then return end
                                end
                            end
                        end
                        if (vulnAimCast >= 1 and debuff.vulnerable.exists(units.dyn40) and debuff.vulnerable.remain(units.dyn40) < 5) or power >= 95  then
                            if cast.aimedShot(units.dyn40) then return end
                        end
                        if (((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) and power < 90 and not debuff.vulnerable.exists(units.dyn40)) or (((mode.rotation == 1 and #enemies.yards8t == 1) or mode.rotation == 3) and power <= 70 and debuff.vulnerable.exists(units.dyn40)) then 
                            if cast.arcaneShot(units.dyn40) then return end
                        end
                        if ((((mode.rotation == 1 and #enemies.yards8t >= 3) and not hasEquiped(137081)) or ((mode.rotation == 1 and #enemies.yards8t >= 2) and hasEquiped(137081)) or mode.rotation == 3) and power < 90 and not debuff.vulnerable.exists(units.dyn40)) or  
                            ((((mode.rotation == 1 and #enemies.yards8t >= 3) and not hasEquiped(137081)) or ((mode.rotation == 1 and #enemies.yards8t >= 2) and hasEquiped(137081)) or mode.rotation == 3) and power <= 70 and debuff.vulnerable.exists(units.dyn40)) then
                            if cast.multiShot(units.dyn40) then return end
                        end
                    else
                        actionList_NonPatientSniper()
                    end
                end
            end --End In Combat
        end --End Rotation Logic
    end -- End Timer
end -- End runRotation
--local id = 254
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

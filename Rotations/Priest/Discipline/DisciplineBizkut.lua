local rotationName = "Bizkut" 

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.powerInfusion },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.powerInfusion },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.powerInfusion }
    };
    CreateButton("Cooldown",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordBarrier}
    };
    CreateButton("Defensive",2,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -------------------------
        -------- ARTIFACT -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Artifact")
            --Light's Wrath
            br.ui:createSpinner(section, "Light's Wrath",  85,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Light's Wrath Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Light's Wrath Targets")
            --Save Overloaded with Light for CD
            br.ui:createCheckbox(section,"Save Overloaded with Light for CD")
            --Always use on CD
            br.ui:createCheckbox(section,"Always use on CD")
        br.ui:checkSectionState(section)
        -------------------------
        ----- DAMAGE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Damage")
            --Shadow Word: Pain
            br.ui:createCheckbox(section,"Shadow Word: Pain")
            --Purge The Wicked
            br.ui:createCheckbox(section,"Purge The Wicked")
            --Schism
            br.ui:createCheckbox(section,"Schism")
            --Penance
            br.ui:createCheckbox(section,"Penance")
            --Power Word: Solace
            br.ui:createCheckbox(section,"Power Word: Solace")
            --Smite
            br.ui:createCheckbox(section,"Smite")
            --Divine Star
            br.ui:createSpinner(section, "Divine Star",  3,  0,  10,  1,  "|cffFFFFFFMinimum Divine Star Targets")
            --Halo Damage
            br.ui:createSpinner(section, "Halo Damage",  3,  0,  10,  1,  "|cffFFFFFFMinimum Halo Damage Targets")
            --Mindbender
            br.ui:createSpinner(section,"Mindbender",  90,  0,  100,  1,  "|cffFFFFFFMana Percent to Cast At")
            --Shadowfiend
            br.ui:createSpinner(section, "Shadowfiend",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Shadowfiend Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Shadowfiend Targets")  
        br.ui:checkSectionState(section)
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
            --Plea
            br.ui:createSpinner(section, "Plea",  90,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Power Word: Shield
            br.ui:createSpinner(section, "Power Word: Shield",  99,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Penance Heal
            br.ui:createSpinner(section, "Penance Heal",  70,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Shadow Mend
            br.ui:createSpinner(section, "Shadow Mend",  60,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Clarity of Will
            br.ui:createSpinner(section, "Clarity of Will",  40,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Pain Suppression Tank
            br.ui:createSpinner(section, "Pain Suppression Tank",  40,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Pain Suppression
            br.ui:createSpinner(section, "Pain Suppression",  30,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Shining Force
            br.ui:createSpinner(section, "Shining Force",  50,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Leap Of Faith
            br.ui:createSpinner(section, "Leap Of Faith",  20,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Purify
            br.ui:createCheckbox(section, "Purify")
            --Fade
            br.ui:createSpinner(section, "Fade",  99,  0,  100,  1,  "|cffFFFFFFHealth Percent to Cast At")
            --Resurrection
            br.ui:createCheckbox(section,"Resurrection")
            br.ui:createDropdownWithout(section, "Resurrection - Target", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
            --Rapture
            br.ui:createSpinner(section, "Rapture",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Rapture Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Rapture Targets") 
            --Power Word: Radiance
            br.ui:createSpinner(section, "Power Word: Radiance",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "PWR Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWR Targets")  
            --Power Word: Barrier
            br.ui:createSpinner(section, "Power Word: Barrier",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "PWB Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum PWB Targets")
            --Shadow Covenant
            br.ui:createSpinner(section, "Shadow Covenant",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Shadow Covenant Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Shadow Covenant Targets") 
            --Halo
            br.ui:createSpinner(section, "Halo",  80,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At") 
            br.ui:createSpinnerWithout(section, "Halo Targets",  3,  0,  40,  1,  "|cffFFFFFFMinimum Halo Targets")
        br.ui:checkSectionState(section)
        -------------------------
        ------- COOLDOWNS -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            --Int Pot
            br.ui:createCheckbox(section,"Prolonged Pot","|cffFFFFFFUse Potion of Prolonged Power")
            --Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            --Touch of the Void
            if hasEquiped(128318) then
                br.ui:createCheckbox(section,"Touch of the Void")
            end
            --Mindbender/Shadowfiend
            br.ui:createCheckbox(section,"Mindbender/Shadowfiend","|cffFFFFFFAlways cast Mindbender or Shadowfiend on CD")
            --Power Infusion
            br.ui:createCheckbox(section,"Power Infusion")
            --Rapture and PW:S
            br.ui:createCheckbox(section,"Rapture and PW:S","|cffFFFFFFAlways cast Rapture and apply Power Word: Shield to all players on CD")
        br.ui:checkSectionState(section)
        -------------------------
        ------- DEFENSIVE -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
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
    if br.timer:useTimer("debugDiscipline", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = enemies or {}
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk        
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.amount.mana, br.player.power.mana.max, br.player.power.regen
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local recharge                                      = br.player.recharge
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.ttm
        local units                                         = units or {}
        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid                      
        local tank                                          = {}    --Tank
        local averageHealth                                 = 0

        units.dyn30 = br.player.units(30)
        units.dyn40 = br.player.units(40)
        enemies.dyn30 = br.player.enemies(30)
        enemies.dyn40 = br.player.enemies(40)

        for i = 1, #br.friend do
            if UnitIsDeadOrGhost(br.friend[i].unit) or getDistance(br.friend[i].unit) > 40 then 
                br.friend[i].hp = 100 
            end
            averageHealth = averageHealth + br.friend[i].hp
        end
        averageHealth = averageHealth/#br.friend

        -- Atonement Count
        atonementCount = 0
        for i=1, #br.friend do
            local atonementRemain = getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") or 0 -- 194384
            if atonementRemain > 0 then
                atonementCount = atonementCount + 1
            end
        end
        
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------
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
                    if cast.giftOfTheNaaru() then return end
                end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        -----------------
        --- COOLDOWNS ---
        -----------------
        function actionList_Cooldowns()
            if useCDs() then
                --Racials
                --blood_fury
                --arcane_torrent
                --berserking
                if (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") then
                    if br.player.castRacial() then return end
                end
                --potion,name=prolonged_power
                if isChecked("Prolonged Pot") and canUse(142117) and not solo then
                    useItem(142117)
                end
                --Power Infusion
                if isChecked("Power Infusion") then
                    if cast.powerInfusion() then return end
                end
                --Touch of the Void
                if isChecked("Touch of the Void") and getDistance(br.player.units.dyn5)<5 then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
                --Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
                --Rapture and PW:S
                if isChecked("Rapture and PW:S") then
                    if cast.rapture() then return end
                    for i = 1, #br.friend do                           
                        if getBuffRemain(br.friend[i].unit, spell.powerWordShield, "player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then return end     
                        end
                    end
                end
                --Always use on CD
                if isChecked("Always use on CD") then
                    if getSpellCD(207946) == 0 then
                        actionList_SpreadAtonement()
                        if isBoss("target") and getDistance("player","target") < 40 then
                           if cast.lightsWrath("target") then return end
                        end
                    end
                end
                --Mindbender/Shadowfiend
                if isChecked("Mindbender/Shadowfiend") then
                    if cast.mindbender() then return end
                    if cast.shadowfiend() then return end
                end
            end
        end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
        function actionList_PreCombat()
            -- Power Word: Shield Body and Soul
            if isMoving("player") then -- talent.bodyandSoul and 
                if cast.powerWordShield("player") then return end
            end                
        end  -- End Action List - Pre-Combat
        --Spread Atonement
        function actionList_SpreadAtonement()
            --Plea
            if isChecked("Plea") then
                for i = 1, #br.friend do                           
                    if getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and lastSpell ~= spell.plea and atonementCount < 6 then
                        --Print("Atonement Count: "..atonementCount)
                        if cast.plea(br.friend[i].unit) then return end     
                    end
                end
            end
        end
        --AOE Healing
        function actionList_AOEHealing()
            --Power Word: Barrier
            if isChecked("Power Word: Barrier") then
                if getLowAllies(getValue("Power Word: Barrier")) >= getValue("PWB Targets") then    
                    if cast.powerWordBarrier(lowest.unit) then return end    
                end
            end
            --Shadow Covenant
            if isChecked("Shadow Covenant") and talent.shadowCovenant then
                if getLowAllies(getValue("Shadow Covenant")) >= getValue("Shadow Covenant Targets") and lastSpell ~= spell.shadowCovenant then    
                    if cast.shadowCovenant(lowest.unit) then return end    
                end
            end
            --Rapture
            if isChecked("Rapture") then
                if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then    
                    if cast.rapture() then return end                   
                end
            end
            --Power Word: Radiance
            if isChecked("Power Word: Radiance") then
                if getLowAllies(getValue("Power Word: Radiance")) >= getValue("PWR Targets") and lastSpell ~= spell.powerWordRadiance then    
                    if cast.powerWordRadiance(lowest.unit) then return end    
                end
            end
            --Halo
            if isChecked("Halo") then
                if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then    
                    if cast.halo(lowest.unit) then return end    
                end
            end
        end
        --Single Target Defence
        function actionList_SingleTargetDefence()
            --Leap Of Faith
            if isChecked("Leap Of Faith") then
                for i = 1, #br.friend do                           
                    if php > br.friend[i].hp and br.friend[i].hp <= getValue("Leap Of Faith") then
                        if cast.leapOfFaith(br.friend[i].unit) then return end     
                    end
                end
            end
        	--Pain Suppression Tank
            if isChecked("Pain Suppression Tank") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression Tank") and getBuffRemain(br.friend[i].unit, spell.painSuppression, "player") < 1 and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.painSuppression(br.friend[i].unit) then return end
                    end
                end
            end
            --Pain Suppression
            if isChecked("Pain Suppression") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression") and getBuffRemain(br.friend[i].unit, spell.painSuppression, "player") < 1 then
                        if cast.painSuppression(br.friend[i].unit) then return end
                    end
                end
            end
            --Shining Force
            if isChecked("Shining Force") and talent.shiningForce then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Shining Force") then
                        if cast.shiningForce(br.friend[i].unit) then return end
                    end
                end
            end
            --Power Word: Shield
            if isChecked("Power Word: Shield") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Power Word: Shield") 
                    and getBuffRemain(br.friend[i].unit, spell.powerWordShield, "player") < 1 then
                        if cast.powerWordShield(br.friend[i].unit) then return end     
                    end
                end
            end
            --Clarity of Will
            if isChecked("Clarity of Will") and talent.clarityOfWill then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Clarity of Will") then
                        if cast.clarityOfWill(br.friend[i].unit) then return end     
                    end
                end
            end
        end
        --Single Target Heal
        function actionList_SingleTargetHeal()
            --Resurrection
            if isChecked("Resurrection") and not inCombat then
                if getOptionValue("Resurrection - Target") == 1 
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.resurrection("target","dead") then return end
                end
                if getOptionValue("Resurrection - Target") == 2 
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.resurrection("mouseover","dead") then return end
                end
                if getOptionValue("Resurrection - Target") == 3 then
                    for i =1, #br.friend do
                        if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) then
                            if cast.resurrection(br.friend[i].unit) then return end
                        end
                    end
                end
            end
            --Shadow Mend
            if isChecked("Shadow Mend") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Shadow Mend") and lastSpell ~= spell.shadowMend then
                        if cast.shadowMend(br.friend[i].unit) then return end     
                    end
                end
            end
            --Penance Heal
            if isChecked("Penance Heal") and talent.thePenitent then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Penance Heal") then
                        if cast.penance(br.friend[i].unit) then return end     
                    end
                end
            end
            --Plea
            if isChecked("Plea") then
                for i = 1, #br.friend do                           
                    if br.friend[i].hp <= getValue("Plea") and getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and lastSpell ~= spell.plea and atonementCount < 6 then
                        --Print("Atonement Count: "..atonementCount)
                        if cast.plea(br.friend[i].unit) then return end     
                    end
                end
            end
            --Purify
            if isChecked("Purify") then
            for i = 1, #br.friend do
                for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Curse" or bufftype == "Magic" then
                                if cast.purify(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            --Fade
            if isChecked("Fade") then                         
                if php <= getValue("Fade") then
                    if cast.fade() then return end     
                end
            end
        end
        ------------
        -- DAMAGE --
        ------------
        function actionList_Damage()
            --Purge The Wicked
            if isChecked("Purge The Wicked") and talent.purgeTheWicked then
                for i = 1, #enemies.dyn40 do
                    local thisUnit = enemies.dyn40[i]
                    if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                        if ttd(thisUnit) > debuff.purgeTheWicked.duration(thisUnit) and debuff.purgeTheWicked.refresh(thisUnit) then
                            if cast.purgeTheWicked(thisUnit,"aoe") then return end
                        end
                    end
                end
            end
            --Shadow Word: Pain
            if isChecked("Shadow Word: Pain") then
                for i = 1, #enemies.dyn40 do
                    local thisUnit = enemies.dyn40[i]
                    if UnitIsUnit(thisUnit,"target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                        if ttd(thisUnit) > debuff.shadowWordPain.duration(thisUnit) and debuff.shadowWordPain.refresh(thisUnit) then
                            if cast.shadowWordPain(thisUnit,"aoe") then return end
                        end
                    end
                end
            end
            --Schism
            if isChecked("Schism") and power > 20 then
                if cast.schism() then return end
            end
            --Penance
            if isChecked("Penance") then
                if cast.penance() then return end
            end
            --Mindbender
            if isChecked("Mindbender") and power <= getValue("Mindbender") then
                if cast.mindbender() then return end
            end
           --Shadowfiend
            if isChecked("Shadowfiend") then
                if getLowAllies(getValue("Shadowfiend")) >= getValue("Shadowfiend Targets") then    
                    if cast.shadowfiend() then return end    
                end
            end
            --PowerWordSolace
            if isChecked("Power Word: Solace") then
                if cast.powerWordSolace() then return end
            end
            --Light's Wrath
            if isChecked("Light's Wrath") then
                if isChecked("Save Overloaded with Light for CD") and UnitBuffID("player",223166) then return end
                elseif getLowAllies(getValue("Light's Wrath")) >= getValue("Light's Wrath Targets") then
                    if not inInstance and not inRaid then
                        if cast.lightsWrath() then return end
                    else
                        if getSpellCD(207946) == 0 then
                            actionList_SpreadAtonement()
                            if cast.lightsWrath() then return end
                    end
                end
            end
            --Smite
            if isChecked("Smite") and power > 20 then
                if not inInstance and not inRaid then
                    if cast.smite() then return end
                else
                    if atonementCount >= 5 then
                        if cast.smite() then return end
                    end
                end
            end
            --Divine Star
            if isChecked("Divine Star") and talent.divineStar then
                if #enemies.dyn30 >= getOptionValue("Divine Star") then
                    if cast.divineStar() then return end
                end
            end
            --Halo Damage
            if isChecked("Halo Damage") and talent.halo then
                if #enemies.dyn30 >= getOptionValue("Halo Damage") then
                    if cast.halo(lowest.unit) then return end
                end
            end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() then
                actionList_PreCombat()
                actionList_SingleTargetHeal()
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat and not IsMounted() then
                actionList_Defensive()
                actionList_Cooldowns()
                actionList_AOEHealing()
                actionList_SingleTargetDefence()
                actionList_SingleTargetHeal()
                actionList_Damage()
                
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation 
local id = 256
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
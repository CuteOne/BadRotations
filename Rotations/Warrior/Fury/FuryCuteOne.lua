if select(3,UnitClass("player")) == 1 then

    function cFury:FuryCuteOne()
        FuryKeyToggles();
    --------------
    --- Locals ---
    --------------
        local buff              = self.buff
        local dyn5              = self.units.dyn5
        local canFlask          = canUse(self.flask.wod.strengthBig)
        local cd                = self.cd
        local charges           = self.charges
        local combatTime        = getCombatTime()
        local debuff            = self.debuff
        local distance          = getDistance("target")
        local enemies           = self.enemies
        local flaskBuff         = getBuffRemain("player",self.flask.wod.buff.strengthBig) or 0
        local frac              = self.frac
        local gcd               = self.gcd
        local glyph             = self.glyph
        local hasThreat         = hasThreat("target")
        local healthPot         = getHealthPot() or 0
        local inCombat          = self.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local level             = self.level
        local php               = self.health
        local power             = self.power
        local powermax          = self.powerMax
        local race              = self.race
        local racial            = self.getRacial()
        local raidAdd           = false --Need to determine how to check raid add
        local raidAddIn         = 0 --Time until Raid Add
        local ravaging          = false --Need to determine prev gcd is ravager
        local recharge          = self.recharge
        local regen             = self.powerRegen
        local solo              = select(2,IsInInstance())=="none"
        local strPot            = 1 --Get Stregth Potion ID
        local t17_2pc           = self.eq.t17_2pc
        local t18_2pc           = self.eq.t18_2pc 
        local t18_4pc           = self.eq.t18_4pc
        local t18trinket        = false --Need to get check for T18 class trinket
        local talent            = self.talent
        local targets           = #getEnemies("player",8)
        local thp               = getHP(self.units.dyn5)
        local ttd               = getTimeToDie(self.units.dyn5)
        local ttm               = self.timeToMax
        if t18_4pc then t18_4pcBonus = 1 else t18_4pcBonus = 0 end

    --------------------
    --- Action Lists ---
    --------------------
    -- Action list - Extras
        function actionList_Extra()
            -- Battle Shout
            if self.castBattleShout() then return end
            -- Commanding Shout
            if self.castCommandingShout() then return end
            -- Berserker Rage
            if isChecked("Berserker Rage") and hasNoControl(self.spell.berserkerRage) then
                if self.castBeserkerRage() then return end
            end
            -- Hamstring
            if isChecked("Hamstring") then
                for i=1,#getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if isMoving(thisUnit) and getFacing(thisUnit,"player") == false then
                        if self.castHamstring(thisUnit) then return end
                    end
                end
            end
            -- Intervene
            if isChecked("Intervene") then
                if self.castIntervene("target") then return end
            end
        end -- End Action List - Extra
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end 
            -- Gift of the Naaru
                if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and self.race=="Draenei" then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Defensive Stance
                if isChecked("Defensive Stance") and inCombat and php <= getOptionValue("Defensive Stance") then
                    if self.castDefensiveStance() then return end
                elseif buff.defensiveStance then
                    if self.castBattleStance() then return end
                end 
            -- Die by the Sword
                if isChecked("Die by the Sword") and inCombat and php <= getOptionValue("Die by the Sword") then
                    if self.castDieByTheSword() then return end
                end
            -- Intervene
                if isChecked("Intervene") then
                    for i=1,#nNova do
                        thisUnit = nNova[i].unit
                        if UnitGroupRolesAssigned(thisUnit)=="HEALER" and getHP(thisUnit)<getOptionValue("Intervene") and getDistance(thisUnit)<25 then
                            if self.castIntervene(thisUnit) then return end
                        end
                    end
                end
            -- Intimidating Shout
                if isChecked("Intimidating Shout") and inCombat and php <= getOptionValue("Intimidating Shout") then
                    if self.castIntimidatingShout() then return end
                end
            -- Vigilance
                if isChecked("Vigilance") then
                    for i=1,#nNova do
                        thisUnit = nNova[i].unit
                        if UnitGroupRolesAssigned(thisUnit)=="HEALER" and getHP(thisUnit)<getOptionValue("Vigilance") and getDistance(thisUnit)<40 then
                            if self.castVigilance(thisUnit) then return end
                        end
                    end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
            -- Pummel
                if isChecked("Pummel") then
                    for i=1, #getEnemies("player",5) do
                        thisUnit = getEnemies("player",5)[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castPummel(thisUnit) then return end
                        end
                    end
                end
            -- Intimidating Shout
                if isChecked("Intimidating Shout - Int") then
                    for i=1, #getEnemies("player",8) do
                        thisUnit = getEnemies("player",8)[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castIntimidatingShout() then return end
                        end
                    end
                end
            -- Spell Reflection
                if isChecked("Spell Reflection") then
                    for i=1, #getEnemies("player",40) do
                        thisUnit = getEnemies("player",40)[i]
                        if UnitCastingInfo(thisUnit) ~= nil then
                            if (select(6,UnitCastingInfo(thisUnit))/1000 - GetTime())<5 and UnitName("targettarget") == UnitName("player") then
                                if self.castSpellReflection() then return end
                            end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Flask
            -- flask,type=greater_draenic_strength_flask
            if isChecked("Str-Pot") then
                if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
                    useItem(self.flask.wod.strengthBig)
                    return true
                end
                if flaskBuff==0 then
                    if self.useCrystal() then return end
                end
            end
            -- food,type=pickled_eel
            -- stance,choose=battle
            if not buff.battleStance and php > getOptionValue("Defensive Stance") then
                if self.castBattleStance() then return end
            end
            -- snapshot_stats
            -- potion,name=draenic_strength
        end  -- End Action List - Pre-Combat
    -- Action List - Movement
        function actionList_Movement()
        -- Heroic Leap
            -- heroic_leap
            if self.castHeroicLeap() then return end
        -- Charge
            -- charge,cycle_targets=1,if=debuff.charge.down
            -- TODO
        -- Storm Bolt
            -- storm_bolt
            if self.castStormBolt() then return end
        -- Heroic Throw
            -- heroic_throw
            if self.castHeroicThrow() then return end
        end
    -- Action List - Bladestorm (OH GOD WHY!?!?!)
        function actionList_Bladestorm() 
        -- Recklessness
            -- recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
            if useCDs() and isChecked("Recklessness") and getDistance(self.units.dyn8AoE)<8 then
                if buff.remain.enrage>6 then
                    if self.castRecklessness() then return end
                end
            end
        -- Bladestorm
            -- bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
            if useCDs() and isChecked("Bladestorm") and getDistance(self.units.dyn8AoE)<8 then
                if buff.remain.enrage>6 then
                    if self.castBladestorm() then return end
                end
            end
        end -- End Action List - Bladestorm (OH GOD WHY!?!?!)
    -- Action List - Single
        function actionList_Single()
        -- Bloodbath
            -- bloodbath
            if useCDs() and isChecked("Bloodbath") and getDistance(self.units.dyn8AoE)<8 then
                if self.castBloodbath() then return end
            end
        -- Recklessness
            -- recklessness,if=target.health.pct<20&raid_event.adds.exists
            if useCDs() and isChecked("Recklessness") then
                if thp<20 then
                    if self.castRecklessness() then return end
                end
            end
        -- Wild Strike
            -- wild_strike,if=(rage>rage.max-20)&target.health.pct>20
            if (power>powermax-20) and thp>20 then
                if self.castWildStrike() then return end
            end
        -- Bloodthirst
            -- bloodthirst,if=(!talent.unquenchable_thirst.enabled&(rage<rage.max-40))|buff.enrage.down|buff.raging_blow.stack<2
            if (not talent.unquenchableThirst and (power<powermax-40)) or not buff.enrage or charges.ragingBlow<2 then
                if self.castBloodthirst() then return end
            end
        -- Ravager
            -- ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.in>60|target.time_to_die<40))
            if useCDs() and isChecked("Ravager") then
                if buff.bloodbath or (not talent.bloodbath and ttd<40) then
                    if self.castRavager() then return end
                end
            end
        -- Siegebreaker
            -- siegebreaker
            if useCDs() and isChecked("Siegebreaker") and getDistance(self.units.dyn5)<5 then
                if self.castSiegebreaker() then return end
            end
        -- Execute
            -- execute,if=buff.sudden_death.react
            if buff.suddenDeath then
                if self.castExecute(self.units.dyn5) then return end
            end
        -- Storm Bolt
            -- storm_bolt
            if self.castStormBolt() then return end
        -- Wild Strike
            -- wild_strike,if=buff.bloodsurge.up
            if buff.bloodsurge then
                if self.castWildStrike() then return end
            end
        -- Execute
            -- execute,if=buff.enrage.up|target.time_to_die<12
            if buff.enrage or ttd<12 then
                if self.castExecute(self.units.dyn5) then return end
            end
        -- Dragon Roar
            -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
            if useCDs() and isChecked("Dragon Roar") and getDistance(self.units.dyn8AoE)<8 then
                if buff.bloodbath or not talent.bloodbath then
                    if self.castDragonRoar() then return end
                end
            end
        -- Raging Blow
            -- raging_blow
            if self.castRagingBlow() then return end
        -- Wait
            -- wait,sec=cooldown.bloodthirst.remains,if=cooldown.bloodthirst.remains<0.5&rage<50
            if cd.bloodthirst>0 and cd.bloodthirst<0.5 and power<50 then
                return true
            end
        -- Wild Strike
            -- wild_strike,if=buff.enrage.up&target.health.pct>20
            if buff.enrage and thp>20 then
                if self.castWildStrike() then return end
            end
        -- Bladestorm
            -- bladestorm,if=!raid_event.adds.exists
            if useCDs() and isChecked("Bladestorm") and getDistance(self.units.dyn8AoE)<8 then 
                if self.castBladestorm() then return end
            end
        -- Shockwave
            -- shockwave,if=!talent.unquenchable_thirst.enabled
            if useCDs() and isChecked("Shockwave") and getDistance(self.units.dyn8AoE)<8 then
                if not talent.unquenchableThirst then
                    if self.castShockwave() then return end
                end
            end
        -- Impending Victory
            -- impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
            if not talent.unquenchableThirst and thp>20 then
                if self.castImpendingVictory() then return end
            end
        -- Bloodthirst
            -- bloodthirst
            if self.castBloodthirst() then return end
        end -- End Action List - Single
    -- Action List - Two Targets
        function actionList_TwoTargets()
        -- Bloodbath
            -- bloodbath
            if useCDs() and isChecked("Bloodbath") and getDistance(self.units.dyn8AoE)<8 then
                if self.castBloodbath() then return end
            end
        -- Ravager
            -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
            if useCDs() and isChecked("Ravager") then
                if buff.bloodbath or not talent.bloodbath then
                    if self.castRavager() then return end
                end
            end
        -- Dragon Roar
            -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
            if useCDs() and isChecked("Dragon Roar") and getDistance(self.units.dyn8AoE)<8 then
                if buff.bloodbath or not talent.bloodbath then
                    if self.castDragonRoar() then return end
                end
            end
        -- Call Action List - Bladestorm (OH GOD WHY!?!?!)
            -- call_action_list,name=bladestorm
            if actionList_Bladestorm() then return end
        -- Bloodthirst
            -- bloodthirst,if=buff.enrage.down|rage<40|buff.raging_blow.down
            if not buff.enrage or power<40 or not buff.ragingBlow then
                if self.castBloodthirst() then return end
            end
        -- Siegebreaker
            -- siegebreaker
            if useCDs() and isChecked("Siegebreaker") and getDistance(self.units.dyn5)<5 then
                if self.castSiegebreaker() then return end
            end
        -- Execute
            -- execute,cycle_targets=1
            for i=1, #getEnemies("player",5) do
                thisUnit = getEnemies("player",5)[i]
                if self.castExecute(thisUnit) then return end
            end
        -- Raging Blow
            -- raging_blow,if=buff.meat_cleaver.up|target.health.pct<20
            if buff.meatCleaver or thp<20 then
                if self.castRagingBlow() then return end
            end
        -- Whirlwind
            -- whirlwind,if=!buff.meat_cleaver.up&target.health.pct>20
            if not buff.meatCleaver and thp>20 then
                if self.castWhirlwind() then return end
            end
        -- Wild Strike
            -- wild_strike,if=buff.bloodsurge.up
            if buff.bloodsurge then
                if self.castWildStrike() then return end
            end
        -- Bloodthirst
            -- bloodthirst
            if self.castBloodthirst() then return end
        -- Whirlwind
            -- whirlwind
            if self.castWhirlwind() then return end
        end -- End Action List - Two Targets
    -- Action List - Three Targets
        function actionList_ThreeTargets()
        -- Bloodbath
            -- bloodbath
            if useCDs() and isChecked("Bloodbath") and getDistance(self.units.dyn8AoE)<8 then
                if self.castBloodbath() then return end
            end
        -- Ravager
            -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
            if useCDs() and isChecked("Ravager") then
                if buff.bloodbath or not talent.bloodbath then
                    if self.castRavager() then return end
                end
            end
        -- Call Action List - Bladestorm (OH GOD WHY!?!?!)
            if actionList_Bladestorm() then return end
        -- Bloodthirst
            -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
            if not buff.enrage or power<50 or not buff.ragingBlow then
                if self.castBloodthirst() then return end
            end
        -- Raging Blow
            -- raging_blow,if=buff.meat_cleaver.stack>=2
            if charges.meatCleaver>=2 then
                if self.castRagingBlow() then return end
            end
        -- Siegebreaker
            -- siegebreaker
            if useCDs() and isChecked("Siegebreaker") and getDistance(self.units.dyn5)<5 then
                if self.castSiegebreaker() then return end
            end
        -- Execute
            -- execute,cycle_targets=1
            for i=1, #getEnemies("player",5) do
                thisUnit = getEnemies("player",5)[i]
                if self.castExecute(thisUnit) then return end
            end
        -- Dragon Roar
            -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
            if useCDs() and isChecked("Dragon Roar") and getDistance(self.units.dyn8AoE)<8 then
                if buff.bloodbath or not talent.bloodbath then
                    if self.castDragonRoar() then return end
                end
            end
        -- Whirlwind
            -- whirlwind,if=target.health.pct>20
            if thp>20 then
                if self.castWhirlwind() then return end
            end
        -- Bloodthirst
            -- bloodthirst
            if self.castBloodthirst() then return end
        -- Wild Strike
            -- wild_strike,if=buff.bloodsurge.up
            if buff.bloodsurge then
                if self.castWildStrike() then return end
            end
        -- Raging Blow
            if self.castRagingBlow() then return end
        end -- End Action List - Three Targets
    -- Action List - MultiTarget
        function actionList_MultiTarget()
        -- Touch of the Void
            if isChecked("Touch of the Void") and getDistance(self.units.dyn5)<5 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
                    end
                end
            end
        -- Bloodbath
            -- bloodbath
            if useCDs() and isChecked("Bloodbath") and getDistance(self.units.dyn8AoE)<8 then
                if self.castBloodbath() then return end
            end
        -- Ravager
            -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
            if useCDs() and isChecked("Ravager") then
                if buff.bloodbath or not talent.bloodbath then
                    if self.castRavager() then return end
                end
            end
        -- Raging Blow
            -- if=buff.meat_cleaver.stack>=3&buff.enrage.up
            if charges.meatCleaver>=3 and buff.enrage then
                if self.castRagingBlow() then return end
            end
        -- Bloodthirst
            -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
            if not buff.enrage or power<50 or not buff.ragingBlow then
                if self.castBloodthirst() then return end
            end
        -- Call Action List - Bladestorm (OH GOD WHY!?!?!)
            -- call_action_list,name=bladestorm
            if actionList_Bladestorm() then return end
        -- Whirlwind
            -- whirlwind
            if self.castWhirlwind() then return end
        -- Siegebreaker
            -- siegebreaker
            if useCDs() and isChecked("Siegebreaker") and getDistance(self.units.dyn5)<5 then
                if self.castSiegebreaker() then return end
            end
        -- Execute
            -- execute,if=buff.sudden_death.react
            if buff.suddenDeath then
                if self.castExecute(self.units.dyn5) then return end
            end
        -- Dragon Roar
            -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
            if useCDs() and isChecked("Dragon Roar") and getDistance(self.units.dyn8AoE)<8 then
                if buff.bloodbath or not talent.bloodbath then
                    if self.castDragonRoar() then return end
                end
            end  
        -- Bloodthirst
            -- bloodthirst
            if self.castBloodthirst() then return end
        -- Wild Strike
            -- wild_strike,if=buff.bloodsurge.up
            if buff.bloodsurge then
                if self.castWildStrike() then return end
            end   
        end -- End Action List - MultiTarget
    -- Action List - Recklessness w/ Anger Management
        function actionList_ReckAngerManagement()
        -- Recklessness
            -- recklessness,if=(target.time_to_die>140|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled|target.time_to_die<15)
            if useCDs() and isChecked("Recklessness") then
                if (ttd>140 or thp<20) and (buff.bloodbath or not talent.bloodbath or ttd<15) then
                    if self.castRecklessness() then return end
                end
            end
        end -- End Action List - Recklessness w/ Anger Management
    -- Action List - Recklessness w/o Anger Management
        function actionList_ReckNoAnger()
        -- Recklessness
            -- recklessness,if=(target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled|target.time_to_die<15)
            if useCDs() and isChecked("Recklessness") then
                if (ttd>190 or thp<20) and (buff.bloodbath or not talent.bloodbath or ttd<15) then
                    if self.castRecklessness() then return end
                end
            end 
        end -- End Action List - Recklessness w/o Anger Management
  -----------------
  --- Rotations ---
  -----------------
        if actionList_Extra() then return end
        if actionList_Defensive() then return end
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) then
            return true
        else
  ---------------------------------
  --- Out Of Combat - Rotations ---
  ---------------------------------
            if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_PreCombat() then return end
                if distance<5 then
                    StartAttack()
                else
                    if self.castCharge() then return end
                end
            end
  -----------------------------
  --- In Combat - Rotations --- 
  -----------------------------
            if inCombat then
            -- Charge
                -- charge,if=debuff.charge.down
                if self.castCharge() then return end
            -- Auto Attack
                --auto_attack
                if distance<5 then
                    StartAttack()
                end
            -- Action List - Movement
                -- run_action_list,name=movement,if=movement.distance>5
                if distance>5 then
                    if actionList_Movement() then return end
                end
            -- Action List - Interrupts
                if actionList_Interrupts() then return end
            -- Berserker Rage
                -- berserker_rage,if=buff.enrage.down|(prev_gcd.bloodthirst&buff.raging_blow.stack<2)
                if not buff.enrage or (lastSpellCast==self.spell.bloodthirst and charges.ragingBlow<2) then
                    if self.castBeserkerRage() then return end
                end
            -- Heroic Leap
                -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
                if self.castHeroicLeap() then return end
            -- Legendary Ring
                -- use_item,name=thorasus_the_stone_heart_of_draenor,if=(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))
                -- TODO
            -- Potion
                -- potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<=30
                if useCDs() and getDistance(self.units.dyn5)<5 and canUse(strPot) and inRaid and isChecked("Agi-Pot") then
                    if (thp<20 and buff.recklessness) or ttd<=30 then
                        useItem(strPot)
                    end
                end
            -- Touch of the Void
                if useCDs() and isChecked("Touch of the Void") and getDistance(self.units.dyn5)<5 then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
            -- Trinkets
                if useCDs() and isChecked("Trinkets") and getDistance(self.units.dyn5)<5 then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            -- Action List - Single Target
                -- run_action_list,name=single_target,if=(raid_event.adds.cooldown<60&raid_event.adds.count>2&spell_targets.whirlwind=1)|raid_event.movement.cooldown<5
                if targets==1 or not useAoE() then
                    if actionList_Single() then return end
                end
            -- Recklessness
                -- recklessness,if=(buff.bloodbath.up|cooldown.bloodbath.remains>25|!talent.bloodbath.enabled|target.time_to_die<15)&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)&set_bonus.tier18_4pc
                if useCDs() and isChecked("Recklessness") and getDistance(self.units.dyn5)<5 then
                    if (buff.bloodbath or cd.bloodbath > 25 or not talent.bloodbath or ttd<15) and ((talent.bladestorm and (targets==1)) or not talent.bladestorm) and t18_4pc then
                        if self.castRecklessness() then return end
                    end
                end
            -- Call Action List - Recklessness w/ Anger Management
                -- call_action_list,name=reck_anger_management,if=talent.anger_management.enabled&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)&!set_bonus.tier18_4pc
                if useCDs() and getDistance(self.units.dyn5)<5 then
                    if talent.angerManagement and ((talent.bladestorm and enemies==1) or not talent.bladestorm) and not t18_4pc then
                        if actionList_ReckAngerManagement() then return end
                    end
                end
            -- Call Action List - Recklessness w/o Anger Management
                -- call_action_list,name=reck_no_anger,if=!talent.anger_management.enabled&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)&!set_bonus.tier18_4pc
                if useCDs() and getDistance(self.units.dyn5)<5 then
                    if not talent.angerManagement and ((talent.bladestorm and enemies==1) or not talent.bladestorm) and not t18_4pc then
                        if actionList_ReckNoAnger() then return end
                    end
                end
            -- Avatar
                -- avatar,if=buff.recklessness.up|cooldown.recklessness.remains>60|target.time_to_die<30
                if useCDs() and isChecked("Avatar") and getDistance(self.units.dyn5)<5 then
                    if buff.recklessness or cd.recklessness>60 or ttd<30 then
                        if self.castAvatar() then return end
                    end
                end
            -- Racials
                -- blood_fury
                -- arcane_torrent
                -- berserking
                if useCDs() and isChecked("Racial") and getDistance(self.units.dyn5)<5 then
                    if (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
                        if self.castRacial() then return end
                    end
                end
            -- Action List - Two Targets
                -- call_action_list,name=two_targets,if=spell_targets.whirlwind=2
                if targets==2 and useAoE() then
                    if actionList_TwoTargets() then return end
                end
            -- Action List - Three Targets
                -- call_action_list,name=three_targets,if=spell_targets.whirlwind=3
                if targets==3 and useAoE() then
                    if actionList_ThreeTargets() then return end
                end
            -- Action List - Multi Target
                if targets>3 and useAoE() then
                    if actionList_MultiTarget() then return end
                end
            -- Action List - Single Target
                if targets==1 or not useAoE() then
                    if actionList_Single() then return end
                end
            end -- End Combat Rotation
        end -- Pause
    end -- End cFury:FuryCuteOne()
end -- End Select Warrior
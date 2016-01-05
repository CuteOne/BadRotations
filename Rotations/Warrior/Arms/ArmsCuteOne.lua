if select(3,UnitClass("player")) == 1 then

    function cArms:ArmsCuteOne()
        WarriorArmsToggles();
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
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if getDistance(dyn5)<5 then
            -- Legendary Ring
                -- use_item,name=thorasus_the_stone_heart_of_draenor,if=(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))
                -- TODO
            -- Potion
                -- potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<25
                if useCDs() and canUse(strPot) and inRaid and isChecked("Agi-Pot") then
                    if (thp<20 and buff.recklessness) or ttd<25 then
                        useItem(strPot)
                    end
                end
            -- Recklessness
                -- recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((desired_targets=1&!raid_event.adds.exists)|!talent.bladestorm.enabled)
                if useCDs() and (((ttd>190 or thp<20) and (buff.bloodbath or not talent.bloodbath)) or ttd<=12 or talent.angerManagement) and ((targets==1 and not raidAdd) or not talent.bladestorm) then
                    if self.castRecklessness() then return end
                end
            -- Bloodbath
                -- bloodbath,if=(dot.rend.ticking&cooldown.colossus_smash.remains<5&((talent.ravager.enabled&prev_gcd.ravager)|!talent.ravager.enabled))|target.time_to_die<20
                if useCDs() and (debuff.rend and cd.colossusSmash<5 and ((talent.ravager and not ravaging) or not talent.ravager)) or ttd<20 then
                    if self.castBloodbath() then return end
                end
            -- Avatar
                -- avatar,if=buff.recklessness.up|target.time_to_die<25
                if useCDs() and buff.recklessness or ttd<25 then
                    if self.castAvatar() then return end
                end
            -- Racials
                -- blood_fury
                -- arcane_torrent
                -- berserking
                if useCDs() and (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
                    if self.castRacial() then return end
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
                if useCDs() and isChecked("Trinkets") then
                    if canUse(13) then
                        useItem(13)
                    end
                    if canUse(14) then
                        useItem(14)
                    end
                end
            -- Heroic Leap 
                -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
                -- TODO   
            end
        end -- End Action List - Cooldowns
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
            -- food,type=sleeper_sushi
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
    -- Action List - Single
        function actionList_Single()
        -- Rend
            -- rend,if=target.time_to_die>4&(remains<gcd|(debuff.colossus_smash.down&remains<5.4))
            if ttd>4 and (debuff.remain.rend<gcd or (not debuff.colosusSmash and debuff.remain.rend<5.4)) then
                if self.castRend(self.units.dyn5) then return end
            end
        -- Ravager
            -- ravager,if=cooldown.colossus_smash.remains<4&(!raid_event.adds.exists|raid_event.adds.in>55)
            if cd.colossusSmash<4 then
                if self.castRavager() then return end
            end
        -- Colossus Smash
            -- colossus_smash,if=debuff.colossus_smash.down
            if not debuff.colossusSmash then
                if self.castColossusSmash() then return end
            end
        -- Mortal Strike
            -- mortal_strike,if=target.health.pct>20
            if thp>20 then
                if self.castMortalStrike() then return end
            end
        -- Colossus Smash
            -- colossus_smash
            if self.castColossusSmash() then return end
        -- Bladestorm
            -- bladestorm,if=(((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4))&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
            if (((debuff.colossusSmash or cd.colossusSmash>3) and thp>20) or (thp<20 and power<30 and cd.colossusSmash>4)) then
                if self.castBladestorm() then return end
            end
        -- Storm Bolt
            -- storm_bolt,if=debuff.colossus_smash.down
            if not debuff.colossusSmash then
                if self.castStormBolt() then return end
            end
        -- Siegebreaker
            -- siegebreaker
            if self.castSiegebreaker() then return end
        -- Dragon Roar
            -- dragon_roar,if=!debuff.colossus_smash.up&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
            if not debuff.colossusSmash then
                if self.castDragonRoar() then return end
            end
        -- Execute
            -- execute,if=buff.sudden_death.react
            if buff.suddenDeath then
                if self.castExecute(self.units.dyn5) then return end
            end
            -- execute,if=!buff.sudden_death.react&(rage.deficit<48&cooldown.colossus_smash.remains>gcd)|debuff.colossus_smash.up|target.time_to_die<5
            if not buff.suddenDeath and (self.powerDeficit<48 and (cd.colossusSmash>gcd or level<81)) or debuff.colossusSmash or ttd<5 then
                if self.castExecute(self.units.dyn5) then return end
            end
        -- Rend
            -- rend,if=target.time_to_die>4&remains<5.4
            if ttd>4 and debuff.remain.rend<5.4 then
                if self.castRend(self.units.dyn5) then return end
            end
        -- Wait
            -- wait,sec=cooldown.colossus_smash.remains,if=cooldown.colossus_smash.remains<gcd
            if cd.colossusSmash<gcd then
                pause()
            end
        -- Shockwave
            -- shockwave,if=target.health.pct<=20
            if thp<=20 then
                if self.castShockwave() then return end
            end
        -- Wait
            -- wait,sec=0.1,if=target.health.pct<=20
            -- TODO
        -- Impending Victory
            -- impending_victory,if=rage<40&!set_bonus.tier18_4pc
            if power<40 and not t18_4pc then
                if self.castImpendingVictory() then return end
            end
        -- Victory Rush
            if self.castVictoryRush() then return end
        -- Slam
            -- slam,if=rage>20&!set_bonus.tier18_4pc
            if power>20 and not t18_4pc then
                if self.castSlam() then return end
            end
        -- Thunder Clap
            -- thunder_clap,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)&glyph.resonating_power.enabled
            if ((not t18_2pc and not t18trinket) or (not t18_4pc and self.powerDeficit<45) or self.powerDeficit<30) and (not talent.slam or t18_4pc) and (power>=40 or debuff.colossusSmash or level<81) and (glyph.resonatingPower or level<26) then
                if self.castThunderClap() then return end
            end
        -- Whirlwind
            -- whirlwind,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)
            if ((not t18_2pc and not t18trinket) or (not t18_4pc and self.powerDeficit<45) or self.powerDeficit<30) and (not talent.slam or t18_4pc) and (power>=40 or debuff.colossusSmash or level<81) then
                if self.castWhirlwind() then return end
            end
        -- Shockwave
            --shockwave
            if self.castShockwave() then return end
        end -- End Action List - Single
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
        -- Sweeping Strikes
            --sweeping_strikes
            if self.castSweepingStrikes() then return end
        -- Rend
            -- rend,if=dot.rend.remains<5.4&target.time_to_die>4
            if debuff.remain.rend<5.4 and ttd>4 then
                if self.castRend(self.units.dyn5) then return end
            end
            -- rend,cycle_targets=1,max_cycle_targets=2,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&talent.taste_for_blood.enabled
            if debuff.count.rend<2 then
                for i=1, #getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if getDebuffRemain(thisUnit,self.spell.rend,"player")<5.4 and getTimeToDie(thisUnit)>8 and talent.tasteForBlood then --TODO: Add buff check for Colossus Smash
                        if self.castRend(thisUnit) then return end
                    end
                end
            end
            -- rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die-remains>18&!buff.colossus_smash_up.up&spell_targets.whirlwind<=8
            for i=1, #getEnemies("player",5) do
                thisUnit = getEnemies("player",5)[i]
                if getDebuffRemain(thisUnit,self.spell.rend,"player")<5.4 and getTimeToDie(thisUnit)>18 and targets<=8 then --TODO: Add buff check for Colossus Smash
                    if self.castRend(thisUnit) then return end
                end
            end
        -- Ravager
            -- ravager,if=buff.bloodbath.up|cooldown.colossus_smash.remains<4
            if buff.bloodbath or cd.colossusSmash<4 then
                if self.castRavager() then return end
            end
        -- Bladestorm
            -- bladestorm,if=((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4)
            if ((debuff.colossusSmash or cd.colossusSmash>3) and thp>20) or (thp<20 and power<30 and cd.colossusSmash>4) then
                if self.castBladestorm() then return end
            end
        -- Colossus Smash
            -- colossus_smash,if=dot.rend.ticking
            if debuff.rend then
                if self.castColossusSmash() then return end
            end
        -- Execute
            -- execute,cycle_targets=1,if=!buff.sudden_death.react&spell_targets.whirlwind<=8&((rage.deficit<48&cooldown.colossus_smash.remains>gcd)|rage>80|target.time_to_die<5|debuff.colossus_smash.up)
            for i=1, #getEnemies("player",5) do
                thisUnit = getEnemies("player",5)[i]
                if buff.suddenDeath and targets<=8 and ((self.powerDeficit<48 and cd.colossusSmash>gcd) or power>80 or ttd<5 or debuff.colossusSmash or level<81) then
                    if self.castExecute(thisUnit) then return end
                end
            end
        -- Mortal Strike
            -- mortal_strike,if=target.health.pct>20&(rage>60|debuff.colossus_smash.up)&spell_targets.whirlwind<=5
            if thp>20 and (power>60 or debuff.colossusSmash or level<81) and targets<=5 then
                if self.castMortalStrike() then return end
            end
        -- Dragon Roar
            -- dragon_roar,if=!debuff.colossus_smash.up
            if not debuff.colossusSmash then
                if self.castDragonRoar() then return end
            end
        -- Thunder Clap
            -- thunder_clap,if=(target.health.pct>20|spell_targets.whirlwind>=9)&glyph.resonating_power.enabled
            if (thp>20 or targets>=9) and (glyph.resonatingPower or level<26) then
                if self.castThunderClap() then return end
            end
        -- Rend
            -- rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&spell_targets.whirlwind>=9&rage<50&!talent.taste_for_blood.enabled
            for i=1, #getEnemies("player",5) do
                thisUnit = getEnemies("player",5)[i]
                if getDebuffRemain(thisUnit,self.spell.rend,"player")<5.4 and getTimeToDie(thisUnit)>8 and targets>=9 and power<50 and not talent.tasteForBlood then --TODO: Add buff check for Colossus Smash
                    if self.castRend(thisUnit) then return end
                end
            end
        -- Whirlwind
            -- whirlwind,if=target.health.pct>20|spell_targets.whirlwind>=9
            if thp>20 or targets>=9 then
                if self.castWhirlwind() then return end
            end
        -- Siegebreaker
            -- siegebreaker
            if self.castSiegebreaker() then return end
        -- Storm Bolt
            -- storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
            if cd.colossusSmash>4 or debuff.colossusSmash then
                if self.castStormBolt() then return end
            end
        -- Shockwave
            -- shockwave
            if self.castShockwave() then return end
        -- Execute
            -- execute,if=buff.sudden_death.react
            if buff.suddenDeath then
                if self.castExecute() then return end
            end      
        end -- End Action List - MultiTarget
  -----------------
  --- Rotations ---
  -----------------
        if actionList_Extra() then return end
        if actionList_Defensive() then return end
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
        -- Action List - Cooldowns
            if actionList_Cooldowns() then return end
        -- Action List - Multi Target
            if targets>1 and useAoE() then
                if actionList_MultiTarget() then return end
            end
        -- Action List - Single Target
            if targets==1 or not useAoE() then
                if actionList_Single() then return end
            end
        end -- End Combat Rotation
    end -- End cArms:ArmsCuteOne()
end -- End Select Warrior
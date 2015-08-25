-- SimC Rotation
-- Based on Version: 6.2.0 r3
-- Released on 15 July 2015
if select(2, UnitClass("player")) == "ROGUE" then

    function cAssassination:assassinationSimC()
        -- Locals
        local player, comboPoints, recharge, stealth, power, powerRegen = "player", self.comboPoints, self.recharge, self.stealth, self.power, self.powerRegen
        local buff, debuff, cd, mode, talent, glyph, gcd = self.buff, self.debuff, self.cd, self.mode, self.talent, self.glyph, self.gcd
        local isChecked, enemies, units, eq, charges, getCombatTime = isChecked, self.enemies, self.units, self.eq, self.charges, getCombatTime
        local lastSpellCast, getTimeToDie, UnitExists = lastSpellCast, getTimeToDie, UnitExists
        local timeToDie = getTimeToDie("target")
        local hasTarget = UnitExists("target")
        local targetDistance = getDistance("target", "player")

        --------------------
        --- Action Lists ---
        --------------------

        --- # Combo point generators
        -- TODO: AoE Fan of Knives + Crimson Tempest
        local function actionList_Generator()
            -- dispatch,cycle_targets=1,if=dot.deadly_poison_dot.remains<4& talent.anticipation.enabled&((anticipation_charges<4&set_bonus.tier18_4pc=0)|(anticipation_charges<2&set_bonus.tier18_4pc=1))
            -- dispatch,cycle_targets=1,if=dot.deadly_poison_dot.remains<4& !talent.anticipation.enabled&combo_points<5&set_bonus.tier18_4pc=0
            -- dispatch,cycle_targets=1,if=dot.deadly_poison_dot.remains<4& !talent.anticipation.enabled&set_bonus.tier18_4pc=1&(combo_points<2|target.health.pct<35)
            --
            -- dispatch,if=                                                 talent.anticipation.enabled&((anticipation_charges<4&set_bonus.tier18_4pc=0)|(anticipation_charges<2&set_bonus.tier18_4pc=1))
            -- dispatch,if=                                                 !talent.anticipation.enabled&combo_points<5&set_bonus.tier18_4pc=0
            -- dispatch,if=                                                 !talent.anticipation.enabled&set_bonus.tier18_4pc=1&(combo_points<2|target.health.pct<35)
            if talent.anticipation and ((charges.anticipation < 4 and not eq.t18_4pc) or (charges.anticipation < 2 and eq.t18_4pc))
                    or not talent.anticipation and comboPoints < 5 and not eq.t18_4pc
                    or not talent.anticipation and eq.t18_4pc and comboPoints < 2
            then
                -- Deadly Poison cond. inside cycle
                if self.castDispatch(true) then return end -- Cycle
                if self.castDispatch() then return end
            end

            -- mutilate,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct>35&(combo_points<5|(talent.anticipation.enabled&anticipation_charges<3))
            -- mutilate,if=                                                target.health.pct>35&(combo_points<5|(talent.anticipation.enabled&anticipation_charges<3))
            if comboPoints < 5 or (talent.anticipation and charges.anticipation < 3) then
                -- Deadly Poison cond. inside cycle
                if self.castMutilate(true) then return end -- Cycle
                if self.castMutilate() then return end
            end

            -- preparation,if=(cooldown.vanish.remains>50|!glyph.disappearance.enabled&cooldown.vanish.remains>110)&buff.vanish.down&buff.stealth.down
            -- TODO: preparation
        end

        --- # Combo point finishers
        local function actionList_Finisher()
            -- rupture,cycle_targets=1,if=(remains<2|(combo_points=5&remains<=(duration*0.3)))
            if self.castRuptureCycle() then return end

            -- pool_resource,for_next=1
            -- TODO: pool energy ?
            -- death_from_above,if=(cooldown.vendetta.remains>10|debuff.vendetta.up|target.time_to_die<=25)
            if talent.deathFromAbove then
                -- if self.power < 50 and cd.deathFromAbove < 2 then return end
                if cd.vendetta > 10 or debuff.vendetta or timeToDie <= 25 then
                    if self.castDeathFromAbove then return end
                end
            end

            -- envenom,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up
            -- envenom,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct>35 &(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up
            --
            -- envenom,if=                                                target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up
            -- envenom,if=                                                target.health.pct>35 &(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up
            if ((power + powerRegen * cd.vendetta >= 105) and (buff.remain.envenom <= 1.8 or power > 45)) or hasBloodLust() or debuff.vendetta then
                -- Deadly Poison cond. inside cycle
                if self.castEnvenom(true) then return end -- Cycle
                if self.castEnvenom() then return end
            end
        end

        --------------------------------
        --- Out of Combat Actionlist ---
        --------------------------------
        local function actionList_OOC()
            if not (IsMounted() or IsFlying() or UnitIsFriend("target", "player")) then
                -- Stealth
                if isChecked("Stealth") and (stealthTimer == nil or stealthTimer <= GetTime() - getValue("Stealth Timer")) and getCreatureType("target") == true and not stealth then
                    -- Always
                    if getValue("Stealth") == 1 then
                        if self.castStealth() then stealthTimer = GetTime(); return end
                    end
                    -- Pre-Pot
                    --if getValue("Stealth") == 2 and getBuffRemain("player",105697) > 0 and tarDist < 20 then
                    --	if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
                    --end
                    -- 20 Yards
                    --if getValue("Stealth") == 3 and tarDist < 20 then
                    --	if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
                    --end
                end

                self.castPickPocket()
            end

            -- actions.precombat+=/marked_for_death
            -- actions.precombat+=/slice_and_dice,if=talent.marked_for_death.enabled
            if talent.markedForDeath and hasTarget and targetDistance < 10 and not UnitIsFriend("target", "player") then
                if comboPoints == 0 then
                    self.castMarkedForDeath()
                end
                if comboPoints == 5 then
                    if self.castSliceAndDice() then return end
                end
            end

            return true
        end

        ------------------------
        --- END Action Lists ---
        ------------------------

        if self.inCombat == false then
            if actionList_OOC() then return end
        end

        -- actions.precombat+=/potion,name=draenic_agility
        -- actions.precombat+=/stealth


        -- actions=potion,name=draenic_agility,if=buff.bloodlust.react|target.time_to_die<40|debuff.vendetta.up
        -- TODO: Pot usage

        -- actions+=/preparation,if=!buff.vanish.up&cooldown.vanish.remains>60&time>10
        if buff.vanish and cd.vanish > 30 and getCombatTime() > 10 then
            if self.castPreparation() then return end
        end

        -- actions+=/blood_fury
        -- actions+=/berserking
        -- actions+=/arcane_torrent,if=energy<60
        if self.race == "BloodElf" and power < 60 then
            if self.castRacial() then return end
        elseif self.race == "Orc" or self.race == "Troll" then
            if self.castRacial() then return end
        end

        -- actions+=/vanish,if=time>10&energy>13&!buff.stealth.up&buff.blindside.down&energy.time_to_max>gcd*2&((combo_points+anticipation_charges<8)|(!talent.anticipation.enabled&combo_points<=1))
        -- TODO: fucking long line

        -- actions+=/mutilate,if=buff.stealth.up|buff.vanish.up
        if buff.stealth or buff.vanish then
            if self.castMutilate() then return end
        end

        -- actions+=/rupture,if=((combo_points>=4&!talent.anticipation.enabled)|combo_points=5)&ticks_remain<3
        if ((comboPoints >= 4 and not talent.anticipation) or comboPoints == 5) and debuff.remain.rupture*2 < 3 then
            if self.castRupture() then return end
        end

        -- actions+=/rupture,cycle_targets=1,if=spell_targets.fan_of_knives>1&!ticking&combo_points=5
        if enemies.yards10 > 1 and comboPoints == 5 then
            if self.castRuptureCycle() then return end
        end

        -- actions+=/marked_for_death,if=combo_points=0
        if comboPoints == 0 then
            self.castMarkedForDeath()
        end

        -- actions+=/shadow_reflection,if=combo_points>4|target.time_to_die<=20
        if comboPoints > 4 or timeToDie <= 20 then
            if self.castShadowReflection() then return end
        end

        -- actions+=/vendetta,if=buff.shadow_reflection.up|!talent.shadow_reflection.enabled|target.time_to_die<=20|(target.time_to_die<=30&glyph.vendetta.enabled)
        if buff.shadowReflection or not talent.shadowReflection or timeToDie <=20 or (timeToDie <= 30 and glyph.vendetta) then
            if self.castVendetta() then return end
        end

        -- actions+=/rupture,cycle_targets=1,if=combo_points=5&remains<=duration*0.3&spell_targets.fan_of_knives>1
        if enemies.yards10 > 1 and comboPoints == 5 then
            if self.castRuptureCycle() then return end
        end

        -- actions+=/call_action_list,name=finishers,if=combo_points=5&((!cooldown.death_from_above.remains&talent.death_from_above.enabled)|buff.envenom.down|!talent.anticipation.enabled|anticipation_charges+combo_points>=6)
        if comboPoints == 5 and ((cd.deathFromAbove == 0 and talent.deathFromAbove) or buff.envenom or not talent.anticipation or charges.anticipation+comboPoints >= 6) then
            if actionList_Finisher() then return end
        end

        -- actions+=/call_action_list,name=finishers,if=dot.rupture.remains<2
        if debuff.remain.rupture < 2 then
            if actionList_Finisher() then return end
        end

        -- actions+=/call_action_list,name=generators
        if actionList_Generator() then return end

        ---- Rotation END -----
        -----------------------
    end -- Main rota function
end -- Select Rogue
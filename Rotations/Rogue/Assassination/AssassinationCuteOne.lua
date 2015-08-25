if select(2, UnitClass("player")) == "ROGUE" then
    function cAssassination:AssassinationCuteOne()
--------------
--- Locals ---
--------------
		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end
		local attacktar 									= UnitCanAttack("target","player")
		local buff, buffRemain								= self.buff, self.buff.remain
		local cd 											= self.cd
		local charge 										= self.charges
		local combo 										= self.comboPoints
		local debuff, debuffRemain							= self.debuff, self.debuff.remain
		local dynTar5, dynTable5							= self.units.dyn5, (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar5, ["distance"] = getDistance(dynTar5)}} --Melee
		local dynTar20AoE, dynTable20AoE					= self.units.dyn20AoE, (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar20AoE, ["distance"] = getDistance(dynTar20AoE)}} --Stealth
		local dynTar30AoE 									= self.units.dyn30AoE
		local enemies10										= self.enemies.yards10
		local flaskBuff, canFlask							= getBuffRemain("player",self.flask.wod.buff.agilityBig), canUse(self.flask.wod.agilityBig)	
		local gcd 											= self.gcd
		local glyph				 							= self.glyph
		local hastar 										= ObjectExists("target")
		local inCombat 										= self.inCombat
		local level											= self.level
		local perk											= self.perk
		local php											= self.health
		local power, powerRegen								= self.power, self.powerRegen
		local ruptureTick 									= self.debuff.remain.rupture/2
		local stealth 										= self.stealth
		local t18_4pc 										= self.eq.t18_4pc
		local talent 										= self.talent
		local targets10										= self.enemies.yards10
		local time 											= getCombatTime()
		local ttm 											= self.timeToMax

--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
			-- TODO: Add Extra Features To Base Profile
			-- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end
		end -- End Action List - Extras
	-- Action List - Defensives
		local function actionList_Defensive()
			-- TODO: Add Defensive Abilities
			if useDefensive() and not stealth then
                -- Evasion
                if php<50 then
                    if self.castEvasion() then return end
                end
                -- Combat Readiness
                if php<40 then
                    if self.castCombatReadiness() then return end
                end
                -- Recuperate
                if php<30 and combo>3 and not buff.recuperate then
                    if self.castRecuperate() then return end
                end
                -- Cloak of Shadows
		        if canDispel("player") then
		            if self.castCloakOfShadows() then return end
		        end
                -- Vanish
                if isChecked("Vanish") and php<15 then
                    if self.castVanish() then StopAttack(); ClearTarget(); return end
                end
            end
		end -- End Action List - Defensive
	-- Action List - PreCombat
		local function actionList_PreCombat()
			if not inCombat then
				if not stealth then
		-- Flask
					-- flask,type=greater_draenic_agility_flask
					if isChecked("Agi-Pot") then
						if select(2,IsInInstance())=="raid" and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
							useItem(self.flask.wod.agilityBig)
							return true
						end
			            if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") and flaskBuff==0 then
			                -- if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
			                --     UseItemByName(tostring(select(1,GetItemInfo(118922))))
			                -- end
			                if self.useCrystal() then return end
			            end
				    end
		-- Food
					-- food,type=sleeper_sushi
		-- Poisons
					-- apply_poison,lethal=deadly
					-- NOTHING TO CODE - PROFILE APPLIES BY DEFAULT!
		-- Potion
					-- potion,name=draenic_agility
		-- Stealth
					if isChecked("Stealth") and (stealthTimer == nil or stealthTimer <= GetTime() - getValue("Stealth Timer")) and getCreatureType("target") == true and not stealth then
	                    -- Always
	                    if getValue("Stealth") == 1 then
	                        if self.castStealth() then stealthTimer = GetTime()-getValue("Stealth Timer"); return end
	                    end
	                    -- Pre-Pot
	                    if getValue("Stealth") == 2 and getBuffRemain("player",105697) > 0 and getDistance(dynTar20AoE) < 20 then
	                    	if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
	                    end
	                    -- 20 Yards
	                    if not friendly or isDummy() then
							for i=1, #dynTable20AoE do
								local thisUnit = dynTable20AoE[i].unit
						        if getValue("Stealth") == 3 and ObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player") then
						        	if self.castStealth() then stealthTimer=GetTime(); return end
						        end
						    end
						end
	                end
	            end -- End Stealth Check
		-- Marked For Death
				-- marked_for_death
				if self.castMarkedForDeath(dynTar30AoE) then return end
		-- Slice And Dice
				-- slice_and_dice,if=talent.marked_for_death.enabled
				if talent.markedForDeath then
					if self.castSliceAndDice() then return end
				end
			end -- End No Combat
			-- Slice and Dice
			-- if=buff.slice_and_dice.remains<5
			if not perk.improvedSliceAndDice and buffRemain.sliceAndDice<5 then
				if self.castSliceAndDice() then return end
			end
		-- Opener
			if hastar and attacktar and stealth then
                -- Shadowstep
                if getDistance("target") < 25 and getDistance("target") >= 8 and talent.shadowStep and (select(2,IsInInstance())=="none" or isInCombat("target")) then
                    if self.castShadowStep() then return end
                end
                -- Cloak and Dagger
                if getDistance("target") < 40 and getDistance("target") >= 8 and talent.cloakAndDagger and (select(2,IsInInstance())=="none" or isInCombat("target")) then
                    if self.castAmbush() then return end
                end
                -- Sap
                if noattack() and sapRemain==0 and getDistance("target") < 8 then
                    if self.castSap("target") then return end
                end
                -- Pick Pocket
               	self.castPickPocket()
                if not noattack() and (self.isPicked() or level<15) then
                    -- Ambush
                    if combo<5 and power>60 then
                        if self.castAmbush() then return end
                    end
                    -- 5 Combo Opener
                    if combo == 5 then
                        if power>35 and level<20 and (buffRemain.sliceAndDice>=5 or level<14) then
                            if self.castEviscerate() then return end
                        end
                        if power>25 and buffRemain.sliceAndDice<5 then
                            if self.castSliceAndDice() then return end
                        end
                        if power>25 and debuffRemain.rupture<3 then
                            if self.castRupture(dynTar5) then return end
                        end
                        if power>35 and envenomRemain(dynTar5)<2 then
                            if self.castEnvenom2(dynTar5) then return end
                        end
                    end
                    -- Mutilate
                    if combo < 5 and power>55 then
                        if self.castMutilate2(dynTar5) then return end
                    end
                end -- End Open Attack from Stealth
            end -- End Stealth
		end -- End Action List - PreCombat
	-- Action List - Finishers
		local function actionList_Finishers()
			-- if enemies10<=3 and not useAoE() then
			-- Rupture
				-- cycle_targets=1,if=(remains<2|(combo_points=5&remains<=(duration*0.3)))
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if (ruptureRemain(thisUnit)<2 or (combo==5 and ruptureRemain(thisUnit)<=ruptureDuration(thisUnit)*0.3)) then
						if self.castRupture(thisUnit) then return end
					end
				end
			-- Pool/Death From Above
				-- if=(cooldown.vendetta.remains>10|debuff.vendetta.up|target.time_to_die<=25)
				if useCDs() and (cd.vendetta>10 or debuff.vendetta or ttd(dynTar5)<=25) then
					if power<=50 then

						return true
					else
						if self.castDeathFromAbove() then return end
					end
				end
			-- Envenom
				-- cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if deadlyRemain(thisUnit)<4 and thp(thisUnit)<=35 and (power+powerRegen*cd.vendetta>=105 and (buffRemain.envenom<=1.8 or power>40)) or hasBloodLust() or debuff.vendetta then
						if self.castEnvenom2(thisUnit) then return end
					end
				end 
				-- cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct>35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if deadlyRemain(thisUnit)<4 and thp(thisUnit)>35 and (power+powerRegen*cd.vendetta>=105 and (buffRemain.envenom<=1.8 or power>55)) or hasBloodLust() or debuff.vendetta then
						if self.castEnvenom2(thisUnit) then return end
					end
				end 
				-- if=target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up
				if thp(dynTar5)<=35 and (power+powerRegen*cd.vendetta>=105 and (buffRemain.envenom<=1.8 or power>45)) or hasBloodLust() or debuff.vendetta then
					if self.castEnvenom2(dynTar5) then return end
				end
				-- if=target.health.pct>35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up
				if thp(dynTar5)>35 and (power+powerRegen*cd.vendetta>=105 and (buffRemain.envenom<=1.8 or power>55)) or hasBloodLust() or debuff.vendetta then
					if self.castEnvenom2(dynTar5) then return end
				end
			-- end
			-- if enemies10>3 or useAoE() then
			-- -- Crimson Tempest
			-- 	if self.castCrimsonTempest() then return end
			-- end
		end -- End Action List - Finishers
	-- Action List - Generators
		local function actionList_Generators()
			-- if enemies10<=3 and not useAoE() then
			-- Dispatch
				-- cycle_targets=1,if=dot.deadly_poison_dot.remains<4&talent.anticipation.enabled&((anticipation_charges<4&set_bonus.tier18_4pc=0)|(anticipation_charges<2&set_bonus.tier18_4pc=1))
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if deadlyRemain(thisUnit)<4 and talent.anticipation and ((charge.anticipation<4 and t18_4pc==false) or (charge.anticipation<2 and t18_4pc==true)) then
						if self.castDispatch2(thisUnit) then return end
					end
				end
				-- cycle_targets=1,if=dot.deadly_poison_dot.remains<4&!talent.anticipation.enabled&combo_points<5&set_bonus.tier18_4pc=0
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if deadlyRemain(thisUnit)<4 and not talent.anticipation and combo<5 and t18_4pc==false then
						if self.castDispatch2(thisUnit) then return end
					end
				end
				-- cycle_targets=1,if=dot.deadly_poison_dot.remains<4&!talent.anticipation.enabled&set_bonus.tier18_4pc=1&(combo_points<2|target.health.pct<35)
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if deadlyRemain(thisUnit)<4 and not talent.anticipation and t18_4pc==true and (combo<2 or thp(thisUnit)<35) then
						if self.castDispatch2(thisUnit) then return end
					end
				end
				-- if=talent.anticipation.enabled&((anticipation_charges<4&set_bonus.tier18_4pc=0)|(anticipation_charges<2&set_bonus.tier18_4pc=1))
				if talent.anticipation and ((charge.anticipation<4 and t18_4pc==false) or charge.anticipation<2 and t18_4pc==true) then
					if self.castDispatch2(dynTar5) then return end
				end
				-- if=!talent.anticipation.enabled&combo_points<5&set_bonus.tier18_4pc=0
				if not talent.anticipation and combo<5 and t18_4pc==false then
					if self.castDispatch2(dynTar5) then return end
				end
				-- if=!talent.anticipation.enabled&set_bonus.tier18_4pc=1&(combo_points<2|target.health.pct<35)
				if not talent.anticipation and t18_4pc==true and (combo<2 or thp(dynTar5)<35) then
					if self.castDispatch2(dynTar5) then return end
				end	
			-- Mutilate
				-- cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct>35&(combo_points<5|(talent.anticipation.enabled&anticipation_charges<3))
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if deadlyRemain(thisUnit)<4 and thp(thisUnit)>35 and (combo<5 or (talent.anticipation and charge.anticipation<3)) and hastar then
						if self.castMutilate2(thisUnit) then return end
					end
				end
				-- if=target.health.pct>35&(combo_points<5|(talent.anticipation.enabled&anticipation_charges<3))
				if thp(dynTar5)>35 and (combo<5 or (talent.anticipation and charge.anticipation<3)) then
					if self.castMutilate2(dynTar5) then return end
				end
			-- end
			-- if enemies10>3 or useAoE() then
			-- 	if self.castFanOfKnives() then return end
			-- end
		-- Preparation
			-- if=(cooldown.vanish.remains>50|!glyph.disappearance.enabled&cooldown.vanish.remains>110)&buff.vanish.down&buff.stealth.down
			if (cd.vanish>50 or (not glyph.disappearance and cd.vanish>110)) and not buff.vanish and not buff.stealth then
				if self.castVanish() then return end
			end
		end -- End Action List - Generators
---------------------
--- Begin Profile ---
---------------------
	--Profile Stop | Pause
		if not inCombat and not hastar and profileStop==true then
			profileStop = false
		elseif (inCombat and profileStop==true) or pause() then
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
		-- Assassination is 4 shank!
			if inCombat then
		-- Potion
				-- draenic_agility,if=buff.bloodlust.react|target.time_to_die<40|debuff.vendetta.up
				if useCDs() and canUse(109217) and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
	            	if hasBloodLust() or ttd(dynTar5) or debuff.vendetta then
	                	UseItemByName(tostring(select(1,GetItemInfo(109217))))
	                end
	            end
		-- Kick
				if useInterrupts() then
					-- kick
					for i=1, #dynTable5 do
						thisUnit = dynTable5[i].unit
						if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
							if self.castKick(thisUnit) then return end
						end
					end
				end
		-- Preparation
				-- if=!buff.vanish.up&cooldown.vanish.remains>60&time>10
				if not buff.vanish and cd.vanish>60 and time>10 then
					if self.castPreparation() then return end
				end
		-- Legendary Ring
				-- use_item,slot=finger1,if=spell_targets.fan_of_knives>1|(debuff.vendetta.up&spell_targets.fan_of_knives=1)
		-- Racials - Orc: Blood Fury | Troll: Berserking | Blood Elf: Arcane Torrent
				-- blood_fury | berserking | arcane_torrent,if=energy<60
				if self.race == "Orc" or self.race== "Troll" or (self.race=="Blood Elf" and power<60) then
					if self.castRacial() then return end
				end
		-- Vanish
				-- if=time>10&energy>13&!buff.stealth.up&buff.blindside.down&energy.time_to_max>gcd*2&((combo_points+anticipation_charges<8)|(!talent.anticipation.enabled&combo_points<=1))
				if time>10 and power>13 and not stealth and not buff.blindside and ttm>gcd*2 and ((combo + charge.anticipation<8) or (not talent.anticipation and combo<=1)) then
					if self.castVanish() then return end
				end
		-- Mutilate
				-- if=buff.stealth.up|buff.vanish.up
				if stealth or buff.vanish then
					if self.castMutilate2(dynTar5) then return end
				end
		-- Rupture
				-- if=((combo_points>=4&!talent.anticipation.enabled)|combo_points=5)&ticks_remain<3
				if ((combo>=4 and not talent.anticipation) or combo==5) and ruptureTick<3 then
					if self.castRupture(dynTar5) then return end
				end
				-- cycle_targets=1,if=spell_targets.fan_of_knives>1&!ticking&combo_points=5
				for i=1, #dynTable5 do
					thisUnit = dynTable5[i].unit
					if targets10>1 and ruptureRemain(thisUnit)<2 and combo==5 then
						if self.castRupture(thisUnit) then return end
					end
				end
		-- Marked For Death
				-- if=combo_points=0
				if combo==0 then
					if self.castMarkedForDeath() then return end
				end
		-- Shadow Reflection
				-- if=combo_points>4|target.time_to_die<=20
				if combo>4 or ttd(dynTar20AoE) then
					if self.castShadowReflection() then return end
				end
		-- Vendetta
				-- if=buff.shadow_reflection.up|!talent.shadow_reflection.enabled|target.time_to_die<=20|(target.time_to_die<=30&glyph.vendetta.enabled)
				if buff.ShadowRelection or not talent.shadowReflection or ttd(dynTar5)<=20 or (ttd(dynTar5)<=30 and glyph.vendetta) then
					if self.castVendetta() then return end
				end
		-- Rupture
				-- cycle_targets=1,if=combo_points=5&remains<=duration*0.3&spell_targets.fan_of_knives>1
				for i=1, #dynTable5 do
					local thisUnit = dynTable5[i].unit
					if combo==5 and ruptureRemain(thisUnit)<=ruptureDuration(thisUnit)*0.3 and targets10>1 then
						if self.castRupture(thisUnit) then return end
					end
				end
		-- Finishers
				-- name=finishers,if=combo_points=5&((!cooldown.death_from_above.remains&talent.death_from_above.enabled)|buff.envenom.down|!talent.anticipation.enabled|anticipation_charges+combo_points>=6)
				if combo==5 and ((cd.deathFromAbove==0 and talent.deathFromAbove) or not buff.envenom or not talent.anticipation or charge.anticipation+combo>=6) then
					if actionList_Finishers() then return end
				end
				-- name=finishers,if=dot.rupture.remains<2
				if debuffRemain.rupture<2 then
					if actionList_Finishers() then return end
				end
		-- Generators
				if actionList_Generators() then return end
			end -- End In Combat
		end -- End Profile
    end -- End Rotation Function
end -- End Class Check
-- Simcraft Arms Rotation
-- Date: 29.10.2015

if select(3, UnitClass("player")) == 1 and GetSpecialization() == 1 then
	function cArms:Simcraft()

		-- Locals
		local player,health = "player",self.health
		local buff,debuff,cd,mode,talent,glyph,gcd = self.buff,self.debuff,self.cd,self.mode,self.talent,self.glyph,self.gcd
		local isChecked,enemies,units,mode = isChecked,self.enemies,self.units,self.mode
		local spell,options,eq = self.spell,self.options,self.eq
		local active_enemies_30, active_enemies_40 = self.enemies.active_enemies_30, self.enemies.active_enemies_40
		local dyn5 = self.units.dyn5
		local rage,rageMax,rageDeficit = self.rage,self.rageMax,self.rageDeficit



		------------------------------------------------------------------------------------------------------
		-- Spell Queue ---------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		-- Check for queued spells
		if _Queues[spell.bladestorm] == true then
			ChatOverlay("Q - Bladestorm")
			if self.castBladestorm() then return end
		end
		if _Queues[spell.shockwave] == true then
			ChatOverlay("Q - Shockwave")
			if self.castShockwave() then return end
		end
		if _Queues[spell.dragon_roar] == true then
			ChatOverlay("Q - Dragon Roar")
			if self.castDragonRoar() then return end
		end



		------------------------------------------------------------------------------------------------------
		-- Do everytime --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		-- battle stance
		if not self.battlestance then
			if self.castBattleStance() then return end
		end

		-- auto_attack
		if getDistance(dynTar5)<5 then
			StartAttack()
		end

		------------------------------------------------------------------------------------------------------
		-- Boss Helper ---------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if mode.bosshelper == 2 then
			--self:BossHelperT17()
			--self:BossHelperT18()
		end



		------------------------------------------------------------------------------------------------------
		-- Defensive -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if mode.defensive==1 then
			local php = getHP("player")
			-- Die by the Sword
			if options.defensive.Dbts then
				if php<=options.defensive.DbtsValue then
					if self.castDieByTheSword() then return end
				end
			end
			-- Rallying Cry
			if options.defensive.RallyingCry then
				if php <=options.defensive.RallyingCryValue then
					if self.castRallyingCry() then return end
				end
			end
			-- Enraged Regeneration
			if options.defensive.EnragedRegeneration then
				if php<=options.defensive.EnragedRegenerationValue then
					if self.castEnragedRegeneration() then return end
				end
			end
			-- Impending Victory
			if options.defensive.ImpendingVictory then
				if php<=options.defensive.ImpendingVictoryValue then
					if self.castImpendingVictory() then return end
				end
			end
			-- Healing Tonic
			if options.defensive.HealingTonic then
				if php<=options.defensive.HealingTonicValue then
					if canUse(109223) then useItem(109223) return end
				end
			end
			-- Vigilance on Focus
			if isChecked("Vigilance on Focus") == true then
				if php<=options.defensive.VigilanceValue then
					if self.castVigilanceOn("focus") then return end
				end
			end
			-- Def Stance
			if options.defensive.DefStance then
				if php<=options.defensive.DefStanceValue then
					if self.castDefensiveStance() then return end
				end
			end
		end


		------------------------------------------------------------------------------------------------------
		-- Offensive -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------



		------------------------------------------------------------------------------------------------------
		-- Special keys --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		-- Heroic Leap
		if options.rotation.HeroicLeap and SpecificToggle("Heroic Leap") == true then
			if not IsMouselooking() then
				CastSpellByName(GetSpellInfo(6544))
				if SpellIsTargeting() then
					CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
					return true
				end
			end
		end
		-- Ravager
		if options.rotation.Ravager and SpecificToggle("Ravager") == true then
			if not IsMouselooking() then
				CastSpellByName(GetSpellInfo(152277))
				if SpellIsTargeting() then
					CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
					return true
				end
			end
		end



		------------------------------------------------------------------------------------------------------
		-- Rotation ------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		-- actions=charge,if=debuff.charge.down
		-- actions+=/auto_attack
		-- actions+=/run_action_list,name=movement,if=movement.distance>5
		-- actions+=/use_item,name=thorasus_the_stone_heart_of_draenor,if=(buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up))
		-- actions+=/potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<25
		if self.useCD() then
			-- actions+=/recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((desired_targets=1&!raid_event.adds.exists)|!talent.bladestorm.enabled)
			if self.castRecklessness() then return end
			-- actions+=/bloodbath,if=(dot.rend.ticking&cooldown.colossus_smash.remains<5&((talent.ravager.enabled&prev_gcd.ravager)|!talent.ravager.enabled))|target.time_to_die<20
			if self.castBloodbath() then return end
			-- actions+=/avatar,if=buff.recklessness.up|target.time_to_die<25
			if self.castAvatar() then return end
			-- actions+=/blood_fury,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
			
			-- actions+=/berserking,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
			
		end
		-- actions+=/arcane_torrent,if=rage<rage.max-40
		-- actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
		
		--                ______ 
		--     /\        |  ____|
		--    /  \   ___ | |__   
		--   / /\ \ / _ \|  __|  
		--  / ____ \ (_) | |____ 
		-- /_/    \_\___/|______|
		if self.useAoE() then
		-- actions+=/call_action_list,name=aoe,if=spell_targets.whirlwind>1
			-- 	actions.aoe=sweeping_strikes
			if not buff.sweeping_strikes then
				if self.castSweepingStrike() then return end
			end
			
			-- 	actions.aoe+=/rend,if=dot.rend.remains<5.4&target.time_to_die>4
			if debuff.remain.rend<5.4 and getTTD(dyn5)>4 then
				if self.castRendOnUnit() then return end
			end
			
			-- 	actions.aoe+=/rend,cycle_targets=1,max_cycle_targets=2,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&talent.taste_for_blood.enabled
			if self.getRendRunning()<=2 then
				if debuff.remain.rend<5.4 and getTTD(dyn5)>8 then
					if not buff.colossus_smash and talent.taste_for_blood then
						if self.castRendOnUnit() then return end
					end
				end
			end
			
			-- 	actions.aoe+=/rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die-remains>18&!buff.colossus_smash_up.up&spell_targets.whirlwind<=8
			if self.getRendRunning()<2 then
				if debuff.remain.rend<5.4 and getTTD(dyn5)-debuff.remain.rend>18 then
					if not buff.colossus_smash and #getEnemies("player",8)<=8 then
						if self.castRendOnUnit() then return end
					end
				end
			end
			-- 	actions.aoe+=/ravager,if=buff.bloodbath.up|cooldown.colossus_smash.remains<4

			-- 	actions.aoe+=/bladestorm,if=((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4)

			-- 	actions.aoe+=/colossus_smash,if=dot.rend.ticking
			if debuff.rend then
				if self.castColossusSmash() then return end
			end
			
			-- 	actions.aoe+=/execute,cycle_targets=1,if=!buff.sudden_death.react&spell_targets.whirlwind<=8&((rage.deficit<48&cooldown.colossus_smash.remains>gcd)|rage>80|target.time_to_die<5|debuff.colossus_smash.up)
			if not buff.sudden_death and enemies.yards8<=8 then
				if (rageDeficit<48 and cd.colossus_smash>gcd) or rage>80 or getTTD(dyn5)<5 or debuff.colossus_smash then
					if self.castExecute() then return end
				end
			end
			
			-- 	actions.aoe+=/heroic_charge,cycle_targets=1,if=target.health.pct<20&rage<70&swing.mh.remains>2&debuff.charge.down
			
			-- 	actions.aoe+=/mortal_strike,if=target.health.pct>20&(rage>60|debuff.colossus_smash.up)&spell_targets.whirlwind<=5
			if getHP(dyn5)>20 then
				if rage>60 or debuff.colossus_smash then
					if enemies.yards8<=5 then
						if self.castMortalStrike() then return end
					end
				end
			end
			
			-- 	actions.aoe+=/dragon_roar,if=!debuff.colossus_smash.up
			if not debuff.colossus_smash then
				if self.castDragonRoar() then return end
			end
			
			-- 	actions.aoe+=/thunder_clap,if=(target.health.pct>20|spell_targets.whirlwind>=9)&glyph.resonating_power.enabled
			if (getHP(dyn5)>20 or enemies.yards8>=9) then
				if glyph.resonating_power then
					if self.castThunderClap() then return end
				end
			end
			
			-- 	actions.aoe+=/rend,cycle_targets=1,if=dot.rend.remains<5.4&target.time_to_die>8&!buff.colossus_smash_up.up&spell_targets.whirlwind>=9&rage<50&!talent.taste_for_blood.enabled
			
			-- 	actions.aoe+=/whirlwind,if=target.health.pct>20|spell_targets.whirlwind>=9
			if getHP(dyn5)>20 or enemies.yards8>=9 then
				if self.castWhirlwind() then return end
			end
			
			-- 	actions.aoe+=/siegebreaker
			if self.castSiegebreaker() then return end
			
			-- 	actions.aoe+=/storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
			if cd.colossus_smash>4 or debuff.colossus_smash then
				if self.castStormBolt() then return end
			end
			
			-- 	actions.aoe+=/shockwave
			if self.castShockwave() then return end
			
			-- 	actions.aoe+=/execute,if=buff.sudden_death.react
			if buff.sudden_death then
				if self.castExecute() then return end
			end
		end
		--   _____ _             _      
		--  / ____(_)           | |     
		-- | (___  _ _ __   __ _| | ___ 
		--  \___ \| | '_ \ / _` | |/ _ \
		--  ____) | | | | | (_| | |  __/
		-- |_____/|_|_| |_|\__, |_|\___|
		--                  __/ |       
		--                 |___/        
		-- actions+=/call_action_list,name=single
			-- 	actions.single=rend,if=target.time_to_die>4&(remains<gcd|(debuff.colossus_smash.down&remains<5.4))
			if getTTD(dyn5)>4 then
				if debuff.remain.rend<gcd 
				or (not debuff.colossus_smash and debuff.remain.rend<5.4) then
					if self.castRendOnUnit() then return end
				end
			end
			-- 	actions.single+=/ravager,if=cooldown.colossus_smash.remains<4&(!raid_event.adds.exists|raid_event.adds.in>55)
			
			-- 	actions.single+=/colossus_smash,if=debuff.colossus_smash.down
			if cd.colossus_smash<=0 then
				if not debuff.colossus_smash then
					if self.castColossusSmash() then return end
				end
			end
			
			-- 	actions.single+=/mortal_strike,if=target.health.pct>20
			if getHP(dyn5)>20 then
				if self.castMortalStrike() then return end
			end
			
			-- 	actions.single+=/colossus_smash
			if self.castColossusSmash() then return end

			-- 	actions.single+=/bladestorm,if=(((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4))&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
			
			-- 	actions.single+=/storm_bolt,if=debuff.colossus_smash.down
			if not debuff.colossus_smash then
				if self.castStormBolt() then return end
			end
			
			-- 	actions.single+=/siegebreaker
			if self.castSiegebreaker() then return end

			-- 	actions.single+=/dragon_roar,if=!debuff.colossus_smash.up&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
			
			-- 	actions.single+=/execute,if=buff.sudden_death.react
			if buff.sudden_death then
				if self.castExecute() then return end
			end
			-- 	actions.single+=/execute,if=!buff.sudden_death.react&(rage.deficit<48&cooldown.colossus_smash.remains>gcd)|debuff.colossus_smash.up|target.time_to_die<5
			if not buff.sudden_death then
				if (rageDeficit<48 and cd.colossus_smash>gcd)
				or debuff.colossus_smash 
				or getTTD(dyn5)<5 then
					if self.castExecute() then return end
				end
			end
			-- 	actions.single+=/rend,if=target.time_to_die>4&remains<5.4
			if getTTD(dyn5)>4 then
				if debuff.remain.rend < 5.4 then
					if self.castRendOnUnit() then return end
				end
			end
			-- 	actions.single+=/wait,sec=cooldown.colossus_smash.remains,if=cooldown.colossus_smash.remains<gcd
			if cd.colossus_smash<gcd then return end

			-- 	actions.single+=/shockwave,if=target.health.pct<=20
			if getHP(dyn5) <= 20 then
				if self.castShockwave() then return end
			end
			-- 	actions.single+=/wait,sec=0.1,if=target.health.pct<=20

			-- 	actions.single+=/impending_victory,if=rage<40&!set_bonus.tier18_4pc
			if rage<40 and not eq.tier18_4pc then
				if self.castImpendingVictory() then return end
			end
			
			-- 	actions.single+=/slam,if=rage>20&!set_bonus.tier18_4pc
			if rage>20 and not eq.tier18_4pc then
				if self.castSlam() then return end
			end
			
			-- 	actions.single+=/thunder_clap,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)&glyph.resonating_power.enabled
			if glyph.resonating_power then
				if rage>=40 or debuff.colossus_smash then
					if not talent.slam or eq.tier18_4pc then
						if (not eq.tier18_2pc and not eq.classTrinket)
						or (not eq.tier18_4pc and rageDeficit<45)
						or rageDeficit<30 then
							if self.castThunderClap() then return end
						end
					end
				end
			end

			-- 	actions.single+=/whirlwind,if=((!set_bonus.tier18_2pc&!t18_class_trinket)|(!set_bonus.tier18_4pc&rage.deficit<45)|rage.deficit<30)&(!talent.slam.enabled|set_bonus.tier18_4pc)&(rage>=40|debuff.colossus_smash.up)
			if rage>=40 or debuff.colossus_smash then
				if not talent.slam or eq.tier18_4pc then
					if rageDeficit<30
					or not eq.tier18_4pc and rageDeficit<45
					or not eq.tier18_2pc and not eq.classTrinket then
						if self.castWhirlwind() then return end
					end
				end
			end

			-- 	actions.single+=/shockwave
			if self.castShockwave() then return end
		--  __  __                                     _   
		-- |  \/  |                                   | |  
		-- | \  / | _____   _____ _ __ ___   ___ _ __ | |_ 
		-- | |\/| |/ _ \ \ / / _ \ '_ ` _ \ / _ \ '_ \| __|
		-- | |  | | (_) \ V /  __/ | | | | |  __/ | | | |_ 
		-- |_|  |_|\___/ \_/ \___|_| |_| |_|\___|_| |_|\__|
		-- actions.movement=heroic_leap
			-- actions.movement+=/charge,cycle_targets=1,if=debuff.charge.down
			-- actions.movement+=/charge
			-- actions.movement+=/storm_bolt
			-- actions.movement+=/heroic_throw
	end
end
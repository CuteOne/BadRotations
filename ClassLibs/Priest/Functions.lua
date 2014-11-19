if select(3, UnitClass("player")) == 5 then

	--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
	--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
	--[[]]	   --[[]]		  --[[]]		--[[]]	   			--[[]]
	--[[]]	   --[[]]		  --[[]]		--[[           ]]	--[[]]
	--[[]]	   --[[]]		  --[[]]				   --[[]]	--[[]]
	--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
	--[[         ]] 	--[[           ]]	--[[           ]]	--[[           ]]

	--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
	--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]					 --[[]]
	--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
	--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]

	--[[           ]]	--[[]]	   --[[]]		  --[[]]		--[[         ]]		--[[           ]]	--[[]] 	   --[[]]
	--[[           ]]	--[[]]	   --[[]]	     --[[  ]]		--[[          ]]	--[[           ]]	--[[]] 	   --[[]]
	--[[]]				--[[]]	   --[[]]	    --[[    ]] 		--[[]]	   --[[]]	--[[]]	   --[[]]	--[[ ]]   --[[ ]]
	--[[           ]]	--[[           ]]	   --[[      ]] 	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
			   --[[]] 	--[[]]	   --[[]] 	  --[[        ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
	--[[           ]]	--[[]]	   --[[]]	 --[[]]    --[[]]	--[[          ]]	--[[           ]]	--[[ ]]   --[[ ]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]      --[[]]	--[[         ]]		--[[           ]]	 --[[]]   --[[]]

	--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
	--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
	--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
	--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
	--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
	--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
	--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]

	function debug()
		ShadowDefensive()
		ShadowCooldowns()

		ShadowDecision()
		cop_advanced_mfi_dots()
		cop_advanced_mfi()
		cop_mfi()
		cop()
		ShadowMain()
	end

	-- get threat situation on player and return the number
	function getThreat()
		return UnitThreatSituation("player")
		-- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
		-- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
		-- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
		-- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
	end

	-- check if Insanity is up
	function getInsanity()
		if UnitBuffID("player",InsanityBuff) then return true; end
		if not UnitBuffID("player",InsanityBuff) then return false; end
	end






	--[[                    ]] -- Defensives
		function ShadowDefensive()

			-- Shield
			if isChecked("PW: Shield") and (BadBoy_data['Defensive'] == 2) and php <= getValue("PW: Shield") then
				if castSpell("player",PWS) then return; end
			end

			-- Fade (Glyphed)
			if hasGlyph(GlyphOfFade) then
				if isChecked("Fade Glyph") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Fade Glyph") then
					if castSpell("player",Fade) then return; end
				end
			end

			-- Fade (Aggro)
			if IsInRaid() ~= false then
				if isChecked("Fade Aggro") and (BadBoy_data['Defensive'] == 2) and getThreat()>=2 then
					if castSpell("player",Fade) then return; end
				end
			end
			
			-- Healthstone
			if isChecked("Healthstone") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Healthstone") then
				if canUse(5512) ~= false then UseItemByName(tostring(select(1,GetItemInfo(5512))));	end
			end

			-- Dispersion
			if isChecked("Dispersion") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Dispersion") then
				if castSpell("player",Fade) then return; end
			end

			-- Desperate Prayer
			if isKnown(DesperatePrayer) then
				if isChecked("Desperate Prayer") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Desperate Prayer") then
					if castSpell("player",DesperatePrayer) then return; end
				end
			end
		end -- END SHADOW DEFENSIVES

	--[[                    ]] -- Cooldowns
		function ShadowCooldowns()
			-- Mindbender
			if isKnown(Mindbender) and BadBoy_data['Cooldowns'] == 2 and isChecked("Mindbender") then
				if castSpell("target",Mindbender) then return; end
			end
			-- Shadowfiend
			if isKnown(SF) and BadBoy_data['Cooldowns'] == 2 and isChecked("Shadowfiend") then
				if castSpell("target",SF) then return; end
			end

			-- Power Infusion
			if isKnown(PI) and BadBoy_data['Cooldowns'] == 2 and isChecked("Power Infusion") then
				if castSpell("player",PI) then return; end
			end
		end -- END SHADOW Cooldowns

	--[[                    ]] -- Executed every time the actor is available.

		-- actions=shadowform,if=!buff.shadowform.up
		-- actions+=/potion,name=draenic_intellect,if=buff.bloodlust.react|target.time_to_die<=40
		-- actions+=/power_infusion,if=talent.power_infusion.enabled
		-- actions+=/blood_fury
		-- actions+=/berserking
		-- actions+=/arcane_torrent
		-- actions+=/call_action_list,name=pvp_dispersion,if=set_bonus.pvp_2pc
		-- actions+=/call_action_list,name=decision

	--[[                    ]] -- Decision
	--[[ TBD ACTIVE ENEMIES?]]
		function ShadowDecision()
			-- actions.decision=call_action_list,name=cop_advanced_mfi_dots,if=target.health.pct>=20&(shadow_orb>=4|target.dot.shadow_word_pain.ticking|target.dot.vampiric_touch.ticking|target.dot.devouring_plague.ticking)&talent.clarity_of_power.enabled&talent.insanity.enabled&active_enemies<=2
			if isKnown(CoP) and isKnown(InsanityTalent) then 
				if thp>=20 then
					if (ORBS>=4 or UnitDebuffID("target",SWP,"player") or UnitDebuffID("target",VT,"player") or UnitDebuffID("target",DP,"player")) then
						cop_advanced_mfi_dots();
					end
				end
			end

			-- actions.decision+=/call_action_list,name=cop_advanced_mfi,if=target.health.pct>=20&talent.clarity_of_power.enabled&talent.insanity.enabled&active_enemies<=2
			if thp>=20 and isKnown(CoP) and isKnown(InsanityTalent) then
				cop_advanced_mfi();
			end

			-- actions.decision+=/call_action_list,name=cop_mfi,if=talent.clarity_of_power.enabled&talent.insanity.enabled&active_enemies<=2
			if isKnown(CoP) then
				if isKnown(InsanityTalent) then
					cop_mfi();
				end
			end

			-- actions.decision+=/call_action_list,name=cop,if=talent.clarity_of_power.enabled&(active_enemies<=2|target.health.pct<20)
			if isKnown(CoP) then
				if thp<20 then
					cop();
				end
			end

			-- actions.decision+=/call_action_list,name=main
			ShadowMain();
		end


	--[[                    ]] -- cop_advanced_mfi_dots
	function cop_advanced_mfi_dots()
		-- actions.cop_advanced_mfi_dots=mind_spike,if=((target.dot.shadow_word_pain.ticking&target.dot.shadow_word_pain.remains<gcd)|(target.dot.vampiric_touch.ticking&target.dot.vampiric_touch.remains<gcd))&!target.dot.devouring_plague.ticking
		
		-- actions.cop_advanced_mfi_dots+=/shadow_word_pain,if=!ticking&miss_react&!target.dot.vampiric_touch.ticking
		
		-- actions.cop_advanced_mfi_dots+=/vampiric_touch,if=!ticking&miss_react
		
		-- actions.cop_advanced_mfi_dots+=/mind_blast
		
		-- actions.cop_advanced_mfi_dots+=/devouring_plague,if=shadow_orb>=3&target.dot.shadow_word_pain.ticking&target.dot.vampiric_touch.ticking
		
		-- actions.cop_advanced_mfi_dots+=/insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1
		
		-- actions.cop_advanced_mfi_dots+=/insanity,if=active_enemies<=2,interrupt=1,chain=1
		
		-- actions.cop_advanced_mfi_dots+=/mind_spike,if=(target.dot.shadow_word_pain.ticking&target.dot.shadow_word_pain.remains<gcd*2)|(target.dot.vampiric_touch.ticking&target.dot.vampiric_touch.remains<gcd*2)
		
		-- actions.cop_advanced_mfi_dots+=/mind_flay,chain=1,interrupt=1
	end -- END cop_advanced_mfi_dots()

	--[[                    ]] -- cop_advanced_mfi
	function cop_advanced_mfi()
		-- actions.cop_advanced_mfi=mind_blast,if=mind_harvest=0,cycle_targets=1
		
		-- actions.cop_advanced_mfi+=/mind_blast,if=active_enemies<=5&cooldown_react
		
		-- actions.cop_advanced_mfi+=/mindbender,if=talent.mindbender.enabled
		
		-- actions.cop_advanced_mfi+=/shadowfiend,if=!talent.mindbender.enabled
		
		-- actions.cop_advanced_mfi+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
		
		-- actions.cop_advanced_mfi+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
		
		-- actions.cop_advanced_mfi+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
		
		-- actions.cop_advanced_mfi+=/shadow_word_pain,if=remains<(18*0.3)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
		
		-- actions.cop_advanced_mfi+=/vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
		
		-- actions.cop_advanced_mfi+=/mind_sear,if=active_enemies>=6,chain=1,interrupt=1
		
		-- actions.cop_advanced_mfi+=/mind_spike
		
		-- actions.cop_advanced_mfi+=/shadow_word_death,moving=1
		
		-- actions.cop_advanced_mfi+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
		
		-- actions.cop_advanced_mfi+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
		
		-- actions.cop_advanced_mfi+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
		
		-- actions.cop_advanced_mfi+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
		
		-- actions.cop_advanced_mfi+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
	end -- END cop_advanced_mfi()

	--[[                    ]] -- cop_mfi
	function cop_mfi()
		-- actions.cop_mfi=devouring_plague,if=shadow_orb=5
		
		-- actions.cop_mfi+=/mind_blast,if=mind_harvest=0,cycle_targets=1
		
		-- actions.cop_mfi+=/mind_blast,if=active_enemies<=5&cooldown_react
		
		-- actions.cop_mfi+=/shadow_word_death,cycle_targets=1
		
		-- actions.cop_mfi+=/devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)
		
		-- actions.cop_mfi+=/mindbender,if=talent.mindbender.enabled
		
		-- actions.cop_mfi+=/shadowfiend,if=!talent.mindbender.enabled
		
		-- actions.cop_mfi+=/insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1
		
		-- actions.cop_mfi+=/insanity,if=active_enemies<=2,interrupt=1,chain=1
		
		-- actions.cop_mfi+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
		
		-- actions.cop_mfi+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
		
		-- actions.cop_mfi+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
		
		-- actions.cop_mfi+=/shadow_word_pain,if=remains<(18*0.3)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
		
		-- actions.cop_mfi+=/vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
		
		-- actions.cop_mfi+=/mind_sear,if=active_enemies>=6,chain=1,interrupt=1
		
		-- actions.cop_mfi+=/mind_spike
		
		-- actions.cop_mfi+=/shadow_word_death,moving=1
		
		-- actions.cop_mfi+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
		
		-- actions.cop_mfi+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
		
		-- actions.cop_mfi+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
		
		-- actions.cop_mfi+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
		
		-- actions.cop_mfi+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
	end -- END cop_mfi()

	--[[                    ]] -- cop
	function cop()
		-- actions.cop=devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<=gcd*1.0|cooldown.shadow_word_death.remains<=gcd*1.0)&primary_target=0,cycle_targets=1
		
		-- actions.cop+=/devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<=gcd*1.0|cooldown.shadow_word_death.remains<=gcd*1.0)
		
		-- actions.cop+=/mind_blast,if=mind_harvest=0,cycle_targets=1
		
		-- actions.cop+=/mind_blast,if=active_enemies<=5&cooldown_react
		
		-- actions.cop+=/shadow_word_death,cycle_targets=1
		
		-- actions.cop+=/mindbender,if=talent.mindbender.enabled
		
		-- actions.cop+=/shadowfiend,if=!talent.mindbender.enabled
		
		-- actions.cop+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
		
		-- actions.cop+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
		
		-- actions.cop+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
		
		-- actions.cop+=/shadow_word_pain,if=miss_react&!ticking&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
		
		-- actions.cop+=/vampiric_touch,if=remains<cast_time&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
		
		-- actions.cop+=/mind_sear,if=active_enemies>=5,chain=1,interrupt=1
		
		-- actions.cop+=/mind_spike,if=active_enemies<=4&buff.surge_of_darkness.react
		
		-- actions.cop+=/mind_sear,if=active_enemies>=3,chain=1,interrupt=1
		
		-- actions.cop+=/mind_flay,if=target.dot.devouring_plague_tick.ticks_remain>1&active_enemies=1,chain=1,interrupt=1
		
		-- actions.cop+=/mind_spike
		
		-- actions.cop+=/shadow_word_death,moving=1
		
		-- actions.cop+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
		
		-- actions.cop+=/halo,moving=1,if=talent.halo.enabled&target.distance<=30
		
		-- actions.cop+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
		
		-- actions.cop+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
		
		-- actions.cop+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
	end -- END cop()

	--[[                    ]] -- main
	function ShadowMain()
		-- actions.main=mindbender,if=talent.mindbender.enabled
		-- actions.main+=/shadowfiend,if=!talent.mindbender.enabled

		-- actions.main+=/void_entropy,if=talent.void_entropy.enabled&shadow_orb>=3&miss_react&!ticking&target.time_to_die>60&cooldown.mind_blast.remains<=gcd*2,cycle_targets=1,max_cycle_targets=3

		-- actions.main+=/devouring_plague,if=talent.void_entropy.enabled&shadow_orb>=3&dot.void_entropy.ticking&dot.void_entropy.remains<10,cycle_targets=1,max_cycle_targets=3
		-- actions.main+=/devouring_plague,if=talent.void_entropy.enabled&shadow_orb>=3&dot.void_entropy.ticking&dot.void_entropy.remains<20,cycle_targets=1,max_cycle_targets=3
		-- actions.main+=/devouring_plague,if=talent.void_entropy.enabled&shadow_orb=5
		
		-- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=4&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
		if not isKnown(VoidEntropy) then
			if ORBS>=4 and not UnitDebuffID("target",DP,"player") and isKnown(SoD) then
				if castSpell("target",DP,true,false) then return;end
			end
		end

		-- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&((shadow_orb>=4)|(shadow_orb>=3&set_bonus.tier17_2pc))
		if not isKnown(VoidEntropy) then
			if ORBS>=4 or (ORBS>=3 and isKnown(T17_2pc)) then
				if castSpell("target",DP,true,false) then return;end
			end
		end

		-- actions.main+=/shadow_word_death,cycle_targets=1
		if thp<=20 then
			if castSpell("target",SWD,true,false) then return;end
		end
		
		-- actions.main+=/mind_blast,if=!glyph.mind_harvest.enabled&active_enemies<=5&cooldown_react
		if not hasGlyph(GlyphOfMindHarvest) then
			if castSpell("target",MB,false,true) then return;end
		end
		
		-- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)&!target.dot.devouring_plague_tick.ticking&talent.surge_of_darkness.enabled,cycle_targets=1
		if not isKnown(VoidEntropy) then
			if ORBS>=3 and (MBCD<1.5 or thp<20 and SWDCD<1.5) and not UnitDebuffID("target",DP,"player") and isKnown(SoD) then
				if castSpell("target",DP,true,false) then return;end
			end
		end

		-- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&(cooldown.mind_blast.remains<1.5|target.health.pct<20&cooldown.shadow_word_death.remains<1.5)
		if not isKnown(VoidEntropy) then
			if ORBS>=3 and (MBCD<1.5 or thp<20 and SWDCD<1.5) then
				if castSpell("target",SWD,true,false) then return;end
			end
		end
		
		-- actions.main+=/mind_blast,if=glyph.mind_harvest.enabled&mind_harvest=0,cycle_targets=1
		if hasGlyph(GlyphOfMindHarvest) then
			if castSpell("target",MB,false,true) then return;end
		end
		
		-- actions.main+=/mind_blast,if=active_enemies<=5&cooldown_react
		if castSpell("target",MB,false,true) then return;end
		
		-- actions.main+=/insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1
		if UnitBuffID("player",InsanityBuff) then
			if select(1,UnitChannelInfo("player")) == nil then
				if getBuffRemain("player",InsanityBuff)<(0.5*GCD) then
					if castSpell("target",MF,false,true) then return;end
				end
			end
		end
		
		-- actions.main+=/insanity,interrupt=1,chain=1,if=active_enemies<=2
		if UnitBuffID("player",InsanityBuff) then
			if select(1,UnitChannelInfo("player")) == nil then
				if castSpell("target",MF,false,true) then 
					return;end
			end
		end


		-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&active_enemies>2
		if isKnown(Halo) and isChecked(Halo) and getNumEnemiesInRange("player",30)>2 then
			if castSpell("player",Halo) then return;end
		end
		
		-- actions.main+=/cascade,if=talent.cascade.enabled&active_enemies>2&target.distance<=40
		if isKnown(Cascade) and getNumEnemiesInRange("player",40)>2 and getDistance("player","target")<=40 then
			if castSpell("target",Cascade) then return;end
		end
		
		-- actions.main+=/divine_star,if=talent.divine_star.enabled&active_enemies>4&target.distance<=24
		if isKnown(DivineStar) and getNumEnemiesInRange("player",24)>4 then
			if castSpell("target",DivineStar,false,true) then return;end
		end
		
		-- actions.main+=/shadow_word_pain,if=talent.auspicious_spirits.enabled&remains<(18*0.3)&miss_react,cycle_targets=1
		if isKnown(AuspiciousSpirits) then
			if getDebuffRemain("target",SWP)<(18*0.3) then
				if castSpell("target",SWP) then return;end
			end
		end

		
		-- actions.main+=/shadow_word_pain,if=!talent.auspicious_spirits.enabled&remains<(18*0.3)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
		--[[   TBD                                                                                                                                              ]]
		
		-- actions.main+=/vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react&active_enemies<=5,cycle_targets=1,max_cycle_targets=5
		--[[   TBD                                                                                                                   ]]

		-- actions.main+=/devouring_plague,if=!talent.void_entropy.enabled&shadow_orb>=3&ticks_remain<=1
		if not isKnown(VoidEntropy) then
			if ORBS>=3 and DPTICK<=getDebuffRemain("target",DP,"player") then
				if castSpell("target",DP) then return;end
			end
		end

		-- actions.main+=/mind_spike,if=active_enemies<=5&buff.surge_of_darkness.react=3
		if isKnown(SoD) then
			if UnitBuffID("player",SoDProcs) and getBuffStacks(SoDProcs)==3 then
				if castSpell("target",MS,false,false) then return;end
			end
		end

		-- actions.main+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
		if isKnown(Halo) and isChecked(Halo) and getDistance("player","target")<=30 and getDistance("player","target")>=17 then
			if castSpell("player",Halo) then return;end
		end
		
		-- actions.main+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
		
		-- actions.main+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
		if isKnown(DivineStar) then
			if getNumEnemiesInRange("player",24)>1 or getDistance("player","target")<=24 then
				if castSpell("target",DivineStar,false,true) then return;end
			end
		end
		
		-- actions.main+=/wait,sec=cooldown.shadow_word_death.remains,if=target.health.pct<20&cooldown.shadow_word_death.remains&cooldown.shadow_word_death.remains<0.5&active_enemies<=1
		
		-- actions.main+=/wait,sec=cooldown.mind_blast.remains,if=cooldown.mind_blast.remains<0.5&cooldown.mind_blast.remains&active_enemies<=1
		
		-- actions.main+=/mind_spike,if=buff.surge_of_darkness.react&active_enemies<=5
		if isKnown(SoD) then
			if UnitBuffID("player",SoDProcs) and getBuffStacks(SoDProcs)>=1 then
				if castSpell("target",MS,false,false) then return;end
			end
		end
		
		-- actions.main+=/divine_star,if=talent.divine_star.enabled&target.distance<=28&active_enemies>1
		if isKnown(DivineStar) then
			if getNumEnemiesInRange("player",24)>1 or getDistance("player","target")<=28 then
				if castSpell("target",DivineStar,false,true) then return;end
			end
		end
		
		-- actions.main+=/mind_sear,chain=1,interrupt=1,if=active_enemies>=4
		
		-- actions.main+=/shadow_word_pain,if=shadow_orb>=2&ticks_remain<=3&talent.insanity.enabled
		if isKnown(InsanityTalent) then
			if ORBS>=2 and getDebuffRemain("target",SWP,"player")<=3*SWPTICK then
				if castSpell("target",SWP) then return;end
			end
		end
		
		-- actions.main+=/vampiric_touch,if=shadow_orb>=2&ticks_remain<=3.5&talent.insanity.enabled
		if isKnown(InsanityTalent) then
			if ORBS>=2 and getDebuffRemain("target",VT,"player")<=3.5*VTTICK then
				if castSpell("target",VT) then return;end
			end
		end

		-- actions.main+=/mind_flay,chain=1,interrupt=1
		if select(1,UnitChannelInfo("player")) == nil then
			if castSpell("target",MF,false,true) then 
				return;
			end
		end
		
		-- actions.main+=/shadow_word_death,moving=1
		if isMoving("player") then
			if castSpell("target",SWD,true,false) then
				return;
			end
		end
		
		-- actions.main+=/mind_blast,moving=1,if=buff.shadowy_insight.react&cooldown_react
		if isKnown(ShadowyInsight) and isMoving("player") then
			if UnitBuffID("player",DIProc) then
				if castSpell("target",MB,false) then return;end
			end
		end
		
		-- actions.main+=/divine_star,moving=1,if=talent.divine_star.enabled&target.distance<=28
		if isKnown(DivineStar) then
			if isMoving("player") and getDistance("player","target")<=28 then
				if castSpell("target",DivineStar) then	return;end
			end
		end

		-- actions.main+=/cascade,moving=1,if=talent.cascade.enabled&target.distance<=40
		if isKnown(Cascade) then
			if isMoving("player") and getDistance("player","target")<=40 then
				if castSpell("target",Cascade) then	return;end
			end
		end

		-- actions.main+=/shadow_word_pain,moving=1,cycle_targets=1
		if isMoving("player") then
			if castSpell("target",SWP) then	return;end
		end

	end -- END ShadowMain()

end
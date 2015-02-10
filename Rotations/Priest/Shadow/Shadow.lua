if select(3, UnitClass("player")) == 5 then
	function PriestShadow()

		if currentConfig ~= "Shadow ragnar" then
			ShadowConfig();
			ShadowToggles();
			currentConfig = "Shadow ragnar";
		end
		-- Head End


		-- Locals / Globals--
		--GCD = 1.5/(1+UnitSpellHaste("player")/100)
		--hasTarget = UnitExists("target")
		--hasMouse = UnitExists("mouseover")
		--php = getHP("player")
		-- thp = getHP("target")


		--MBCD = getSpellCD(MB)
		--SWDCD = getSpellCD(SWD)

		if lastDP==nil then	lastDP=99 end
		if lastVT==nil then lastVT=99 end

		--DPTICK = DPTIME/6
		-- SWP (18sec)
		--SWPTICK = 18.0/(1+UnitSpellHaste("player")/100)/6
		-- VT (15sec)
		--VTTICK = 16.0/(1+UnitSpellHaste("player")/100)/5
		--VTCASTTIME = 1.5/(1+UnitSpellHaste("player")/100)



		-- Set Enemies Table
		--makeEnemiesTable(40)

		-- Sort enemiesTable by absolute HP
		if isChecked("sortByHPabs") then
			table.sort(enemiesTable, function(x,y)
				return x.hpabs and y.hpabs and x.hpabs > y.hpabs or false
			end)
		end



		local options = {
			-- Player values
			player = {
				GCD = 		1.5/(1+UnitSpellHaste("player")/100),
				php =		getHP("player"),
				ORBS = 		UnitPower("player", SPELL_POWER_SHADOW_ORBS),
				DPTIME = 	6.0/(1+UnitSpellHaste("player")/100),
				lastVT,
				lastDP,
				MBCD = 		getSpellCD(MB),
				SWDCD = 	getSpellCD(SWD),
				Bubble = 	isChecked("Bubble"),
				},
			-- Buttons
			buttons = {
				Defensive =	BadBoy_data['Defensive'],
				Halo =		BadBoy_data['Halo'],
				DoT =		BadBoy_data['DoT'],
				--Single =	BadBoy_data['Single'],
				Rotation =	BadBoy_data['Rotation'],
				--Rotation =	1,
				Cooldowns =	BadBoy_data['Cooldowns'],
				Feather =	BadBoy_data['Feather'],
			},
			-- isChecked
			isChecked = {
				-- Offensive
				isBoss = 			isChecked("isBoss"),
				Berserking = 		isChecked("Berserking"),
				Mindbender = 		isChecked("Mindbender"),
				Shadowfiend	= 		isChecked("Shadowfiend"),
				Trinket1 = 			isChecked("Trinket 1"),
				Trinket2 =	 		isChecked("Trinket 2"),
				SWDglyphed =		isChecked("SWD glyphed"),
				ScanOrbs = 			isChecked("Scan for Orbs"),
				ScanToF =			isChecked("Scan for ToF"),
				-- Defensive
				Shield = 			isChecked("PW: Shield"),
				Healthstone	= 		isChecked("Healthstone"),
				DesperatePrayer = 	isChecked("Desperate Prayer"),
				FadeGlyph =			isChecked("Fade Glyph"),
				Dispersion =		isChecked("Dispersion"),
				Fade =				isChecked("Fade Aggro"),
				-- DoT Weave
				DoTWeave =			isChecked("DoTWeave"),
				SWP =				isChecked("SWP"),
				VT =				isChecked("VT"),
				-- Multitarget
				-- MultiSWP =			isChecked("Multi SWP"),
				-- MultiVT =			isChecked("Multi VT"),
				-- BossSWP =			isChecked("Boss SWP"),
				-- BossVT =			isChecked("Boss VT"),
				MindSear =			isChecked("MS Targets"),
				-- Encounter Specific
				TwinOgrons = 		isChecked("Ogron Focus Style"),  -- DP on Focus, DPonFocus
				-- Utilities
				PWF = 				isChecked("PW: Fortitude"),
				Shadowform =		isChecked("Shadowform Outfight"),
				Feather =			isChecked("Angelic Feather"),
				BodyAndSoul = 		isChecked("Body And Soul"),
				},
			-- Values
			values = {
				PWShield = 			getValue("PW: Shield"),
				Healthstone =		getValue("Healthstone"),
				Dispersion	=		getValue("Dispersion"),
				Glyph = 			getValue("Fade Glyph"),
				MinHealth =			getValue("Min Health")*1000000,
				MaxTargets = 		getValue("Max Targets"),
				RefreshTime = 		getValue("Refresh Time"),
				VTRefresh =			4.5,
				SWPRefresh = 		5.4,
				MindSear = 			getValue("MS Targets"),
			}
		}


		-- correct twin ogrons options for SoD talent automatically
		if getTalent(3,1) then options.isChecked.TwinOgrons=true end

		-- set îf not set
		if options.player.lastVT==nil then options.player.lastVT=0 end
		if options.player.lastDP==nil then options.player.lastDP=99 end

		-------------
		-- TOGGLES --
		-------------

		-- Pause toggle
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
		end

		-- Focus Toggle
		if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
			RunMacroText("/focus mouseover");
		end

		-- -- Auto Resurrection
		-- if isChecked("Auto Rez") then
		-- 	if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		-- 		if castSpell("mouseover",Rez,true,true) then return; end
		-- 	end
		-- end

		------------
		-- CHECKS --
		------------

			-- Ko'ragh Mind Controll Check
			if UnitDebuffID("player",163472) then
				return false
			end

			-- Food/Invis Check
			if canRun() ~= true then return false; end

			-- Mounted Check (except nagrand outpost mounts)
			if IsMounted("player") and not (UnitBuffID("player",164222) or UnitBuffID("player",165803)) then return false; end

			-- Do not Interrupt "player" while GCD (61304)
			if getSpellCD(61304) > 0 then return false;	end

		-------------------
		-- OUT OF COMBAT --
		-------------------

			-- Power Word: Fortitude
			if not isInCombat("player") then
				if options.isChecked.PWF and (lastPWF == nil or lastPWF <= GetTime() - 5) then
					for i = 1, #nNova do
						if isPlayer(nNova[i].unit) == true 
							and not isBuffed(nNova[i].unit,{21562,109773,469,90364}) 
							and (UnitInRange(nNova[i].unit) 
								or UnitIsUnit(nNova[i].unit,"player")) then
							if castSpell("player",PWF,true) then lastPWF = GetTime(); return; end
						end
					end
				end
			end

		---------------------------------------
		-- Shadowform and AutoSpeed Selfbuff --
		---------------------------------------

			-- Shadowform outfight
			if not UnitBuffID("player",Shadowform) and options.isChecked.Shadowform then
				if castSpell("player",Shadowform,true,false) then return; end
			end

			-- Angelic Feather
			if isKnown(AngelicFeather) and options.buttons.Feather==2 then
				if getGround("player") and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
					--if options.isChecked.Feather and getGround("player") and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
					--if useFeather==true and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
					if castGround("player",AngelicFeather,30) then
						SpellStopTargeting();
						return;
					end
				end
			end

			-- Body and Soul
			if isKnown(BodyAndSoul) then
				if options.isChecked.BodyAndSoul then
					if getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",PWS) and not UnitDebuffID("player",PWSDebuff) then
						if castSpell("player",PWS,true,false) then return; end
					end
				end
			end

		---------------
		-- IN COMBAT --
		---------------
			-- AffectingCombat, Pause, Target, Dead/Ghost Check
			if UnitAffectingCombat("player") or UnitAffectingCombat("target") or options.isChecked.AttackAll then

			-- Shadowform
			if not UnitBuffID("player",Shadowform) then
				if castSpell("player",Shadowform,true,false) then return; end
			end

			-- Bubble infight
			if options.player.Bubble then
				if PlayerHasToy(114227)==1 then
					if getBuffRemain("player",168657)<=0 then
						UseToyByName(tostring(select(1,GetItemInfo(114227))))
					end
				end
			end

		-------------------
		-- Dummy Testing --
		-------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print("____ " .. tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped ____")
					end
				end
			end


		--[[-----------------------------------------------------------------------------------------------------------------------------------------------]]
		----------------
		-- Defensives --
		----------------
			ShadowDefensive(options)


		--if options.buttons.Rotation == 1 then
		----------------
		-- Offensives --
		----------------
			if options.isChecked.isBoss and isBoss() then ShadowCooldowns(options) end
			if not options.isChecked.isBoss then ShadowCooldowns(options) end

		-------------------
		-- Single target --
		-------------------
			--if options.buttons.Rotation == 1 then
				if isCastingSpell(129197) and getSpellCD(MB)==0 then
					if castSpell("target",MB,false,false) then return; end
				end

				if isCasting() then return; end

				Execute(options)
				LFOrbs(options)
				LFToF(options)

				if getHP("target")>20 then
					if options.buttons.DoT>=2 then DotEmAll(options) end
					if options.buttons.Rotation==1 then IcySingleWeave(options) end
					if options.buttons.Rotation==2 then IcyMultiTarget(options) end
				end
			--end
		--[[-----------------------------------------------------------------------------------------------------------------------------------------------]]





	    -- -- Dual Target
	    -- if options.buttons.Rotation == 2 then
	    -- 	Execute()
	    -- 	LFOrbs()
	    -- 	if getHP("target")>20 then IcyDualTarget() end
	    -- end

	      -- -- 3+ Targets
	      -- if options.buttons.Rotation == 2 then
	      -- 	Execute(options)
	      -- 	LFOrbs(options)
	      -- 	if getHP("target")>20 then IcyMultiTarget(options) end
	      -- end

	      -- Auto
	      -- if BadBoy_data['AoE'] == 3 then
	      -- 	if #enemiesTable<2 then
	      -- 	if #enemiesTable>=2 and #enemiesTable<3 then Icy23Targets() end
	      -- 	if #enemiesTable>=4

	      -- Spamming (Off GCD Spells/Items etc.)



	      -- if options.buttons.Rotation ~= 2 then return; end
	      -- print("GOT INTO BETA")


	      -- -- Cooldowns ---------------------------------------------------------------------------------------
	      -- 	-- Berserking (Troll Racial)
	      -- 	if isKnown(Berserking) and options.buttons.Cooldowns==2 and options.isChecked.Berserking then
	      -- 		if castSpell("player",Berserking,true,false) then return; end
	      -- 	end
	      -- 	-- Trinket 1
	      -- 	if options.isChecked.Trinket1 and options.buttons.Cooldowns==2 and canTrinket(13) then
	      -- 		RunMacroText("/use 13")
	      -- 	end

	      -- 	-- Trinket 2
	      -- 	if options.isChecked.Trinket2 and options.buttons.Cooldowns==2 and canTrinket(14) then
	      -- 		RunMacroText("/use 14")
	      -- 	end



	      -- -- GCD Check ---------------------------------------------------------------------------------------
	      -- 	if castingUnit() then
	      -- 		return
	      -- 	end

	      -- -- Scan for Orbs ---------------------------------------------------------------------------------------
	      -- 	if options.isChecked.ScanOrbs then
	      -- 		if UnitPower("player", SPELL_POWER_SHADOW_ORBS)<5 then
	      -- 			for i=1,#enemiesTable do
	      -- 				local thisUnit = enemiesTable[i].unit
	      -- 				local hp = enemiesTable[i].hp
	      -- 				--print("Scanned Unit:"..i)
	      -- 				if hp<20 then
	      -- 					if castSpell(thisUnit,SWD,true,false,false,false,false,false,true) then
	      -- 						--print("ORBED on unit: ")
	      -- 						return
	      -- 					end
	      -- 				end
	      -- 			end
	      -- 		end
	      -- 	end

	      -- -- Scan for ToF
	      -- 	if options.isChecked.ScanToF then
	      -- 		if getBuffRemain("player",ToF)<=options.player.GCD then
	      -- 			for i=1,#enemiesTable do
	      -- 				local thisUnit = enemiesTable[i].unit
	      -- 				local hp = enemiesTable[i].hp
	      -- 				--print("Scanned Unit:"..i)
	      -- 				if hp<35 then
	      -- 					if getSpellCD(MB)>0 then
	      -- 						if castSpell(thisUnit,SWP,true,false) then return; end
	      -- 					end
	      -- 					if getSpellCD(MB)==0 then
	      -- 						if castSpell(thisUnit,MB,false,false) then return; end
	      -- 					end
	      -- 				end
	      -- 			end
	      -- 		end
	      -- 	end





	      -- -- Simcraft Rotations ---------------------------------------------------------------------------------------
	      -- --[[actions.decision=call_action_list,name=cop_dotweave,if=talent.clarity_of_power.enabled&talent.insanity.enabled&target.health.pct>20&active_enemies<=5]]
	      -- if getTalent(7,1)
	      --   and getTalent(3,3)
	      --   and getHP("target")>20 then
	      --   --[[ Beginning of cop_dotweave ]]

	      --   	print("cop_dotweave")

	      --   	-- interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1)
	      -- 	-- interrupt Mind Flay
	      --   	if select(1,UnitChannelInfo("player")) == "Mind Flay"
	      --   	  --and getSpellCD(61304)==0
	      --   	  and (options.player.MBCD<=0.1 or options.player.SWDCD<=0.1) then
	      --   		RunMacroText("/stopcasting")
	      --   	end

	      -- 	--actions.cop_dotweave=devouring_plague,if=target.dot.vampiric_touch.ticking&target.dot.shadow_word_pain.ticking&shadow_orb=5&cooldown_react
	      -- 	if getDebuffRemain("target",VT,"player")>0
	      -- 	  and getDebuffRemain("target",SWP,"player")>0
	      -- 	  and options.player.ORBS==5 then
	      -- 	  	if castSpell("target",DP,true,true) then return; end
	      --   	end

	      -- 	--actions.cop_dotweave+=/devouring_plague,if=(buff.mental_instinct.remains<gcd&buff.mental_instinct.remains)
	      -- 	if isKnown(MentalInstinct)
	      -- 	  and getBuffRemain("player",MentalInstinct)<options.player.GCD then
	      -- 		if castSpell("target",DP,true,true) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/devouring_plague,if=(target.dot.vampiric_touch.ticking&target.dot.shadow_word_pain.ticking&!buff.shadow_word_insanity.remains&cooldown.mind_blast.remains>0.4*gcd)
	      -- 	if getDebuffRemain("target",VT,"player")>0
	      -- 	  and getDebuffRemain("target",SWP,"player")>0
	      -- 	  and getBuffRemain("player",InsanityBuff)==0
	      -- 	  and options.player.MBCD>0.4*options.player.GCD then
	      -- 		if castSpell("target",DP,true,true) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/mind_blast,if=glyph.mind_harvest.enabled&mind_harvest=0&shadow_orb<=2,cycle_targets=1
	      -- 		-- TBD add units already Mind Blasted to a table. check the already blasted by this table

	      -- 	--actions.cop_dotweave+=/mind_blast,if=shadow_orb<=4&cooldown_react
	      -- 	if options.player.ORBS<=4 then
	      -- 		if castSpell("target",MB,false,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/shadowfiend,if=!talent.mindbender.enabled&!buff.shadow_word_insanity.remains
	      -- 	if not getTalent(3,2)
	      -- 	  and options.buttons.Cooldowns==2
	      -- 	  and options.isChecked.Shadowfiend
	      -- 	  and getBuffRemain("player",InsanityBuff)==0 then
	      -- 		if castSpell("target",SF,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/mindbender,if=talent.mindbender.enabled&!buff.shadow_word_insanity.remains
	      -- 	if getTalent(3,2)
	      -- 	  and options.buttons.Cooldowns==2
	      -- 	  and options.isChecked.Shadowfiend
	      -- 	  and getBuffRemain("player",InsanityBuff)==0 then
	      -- 		if castSpell("target",Mindbender,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/shadow_word_pain,if=shadow_orb=4&set_bonus.tier17_2pc&!target.dot.shadow_word_pain.ticking&!target.dot.devouring_plague.ticking&cooldown.mind_blast.remains<1.2*gcd&cooldown.mind_blast.remains>0.2*gcd
	      -- 	if options.player.ORBS==4
	      -- 	  and isKnown(MentalInstinct)
	      -- 	  and getDebuffRemain("target",SWP,"player")==0
	      -- 	  and getDebuffRemain("target",DP,"player")==0
	      -- 	  and options.player.MBCD<1.2*options.player.GCD
	      -- 	  and options.player.MBCD>0.2*options.player.GCD then
	      -- 		if castSpell("target",SWP,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/shadow_word_pain,if=shadow_orb=5&!target.dot.devouring_plague.ticking&!target.dot.shadow_word_pain.ticking
	      -- 	if options.player.ORBS==5
	      -- 	  and getDebuffRemain("target",DP,player,"player")==0
	      -- 	  and getDebuffRemain("target",SWP,player,"player")==0 then
	      -- 		if castSpell("target",SWP,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/vampiric_touch,if=shadow_orb=5&!target.dot.devouring_plague.ticking&!target.dot.vampiric_touch.ticking
	      -- 	if options.player.ORBS==5
	      -- 	  and getDebuffRemain("target",DP,player,"player")==0
	      -- 	  and getDebuffRemain("target",VT,player,"player")==0 then
	      -- 	  --and GetTime()-options.player.lastVT > 1.5*options.player.GCD then
	      -- 		if castSpell("target",VT,true,true,false) then
	      -- 			options.player.lastVT=GetTime()
	      -- 			return
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/insanity,if=buff.shadow_word_insanity.remains,chain=1,interrupt_if=cooldown.mind_blast.remains<=0.1
	      -- 	if getBuffRemain("player",InsanityBuff)>0
	      -- 	  and select(1,UnitChannelInfo("player")) ~= "Insanity" then
	      -- 		if castSpell("target",MF,false,true) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/shadow_word_pain,if=shadow_orb>=2&target.dot.shadow_word_pain.remains>=6&cooldown.mind_blast.remains>0.5*gcd&target.dot.vampiric_touch.remains&buff.bloodlust.up&!set_bonus.tier17_2pc
	      -- 	if options.player.ORBS>=2
	      -- 	  and getDebuffRemain("target",SWP,"player")>=6
	      -- 	  and options.player.MBCD>0.5*options.player.GCD
	      -- 	  and getDebuffRemain("target",VT,"player")>0
	      -- 	  and hasBloodLust()
	      -- 	  and not isKnown(T172) then
	      -- 		if castSpell("target",SWP,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/vampiric_touch,if=shadow_orb>=2&target.dot.vampiric_touch.remains>=5&cooldown.mind_blast.remains>0.5*gcd&buff.bloodlust.up&!set_bonus.tier17_2pc
	      -- 	if options.player.ORBS>=2
	      -- 	  and getDebuffRemain("target",VT,"player")>=5
	      -- 	  and options.player.MBCD>0.5*options.player.GCD
	      -- 	  and hasBloodLust()
	      -- 	  and not isKnown(T172) then
	      -- 		if castSpell("target",VT,true,true,false) then
	      -- 			options.player.lastVT=GetTime()
	      -- 			return
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/halo,if=cooldown.mind_blast.remains>0.5*gcd&talent.halo.enabled&target.distance<=30&target.distance>=17
	      -- 	if options.buttons.Halo == 2
	      -- 	  and options.player.MBCD>0.5*options.player.GCD
	      -- 	  and getTalent(6,3)
	      -- 	  and getDistance("player","target")<=30
	      -- 	  and getDistance("player","target")>=17 then
	      -- 		if castSpell("player",Halo,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/divine_star,if=cooldown.mind_blast.remains>0.5&gcd&talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
	      -- 	if options.player.MBCD>0.5*options.player.GCD
	      -- 	  and getTalent(6,2)
	      -- 	  and getDistance("player","target")<=24 then
	      -- 		if castSpell("target",DivineStar,false,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/cascade,if=cooldown.mind_blast.remains>0.5*gcd&talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
	      -- 	if options.player.MBCD>0.5*options.player.GCD
	      -- 	  and getTalent(6,1)
	      -- 	  and ((#getEnemies("player",40)>1 or getDistance("player","target")>=28) and getDistance("player","target")<=40 and getDistance("player","target")>=1) then
	      -- 		if castSpell("target",Cascade,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/shadow_word_pain,if=primary_target=0&(!ticking|remains<=18*0.3),cycle_targets=1,max_cycle_targets=5
	      -- 	if options.buttons.DoT==2 or options.buttons.DoT==4
	      -- 	  and getSWP()<=options.values.MaxTargets then
	      -- 		for i=1, #enemiesTable do
	      -- 			local thisUnit = enemiesTable[i].unit
	      -- 			local thisHP = enemiesTable[i].hpabs
	      -- 			if (not UnitIsUnit(thisUnit,"focus")) and (not UnitIsUnit("target","target"))
	      -- 			  and safeDoT(thisUnit)
	      -- 			  and thisHP >= options.values.MinHealth then
	      -- 				local swpRem = getDebuffRemain(thisUnit,SWP,"player")
	      -- 				if swpRem<=18*0.3  then
	      -- 					if castSpell(thisUnit,SWP,true,false) then return; end
	      -- 				end
	      -- 			end
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/vampiric_touch,if=primary_target=0&(!ticking|remains<=15*0.3),cycle_targets=1,max_cycle_targets=5
	      -- 	if options.buttons.DoT==3 or options.buttons.DoT==4
	      -- 	  and getVT()<=options.values.MaxTargets then
	      -- 		for i=1, #enemiesTable do
	      -- 			local thisUnit = enemiesTable[i].unit
	      -- 			local thisHP = enemiesTable[i].hpabs
	      -- 			if (not UnitIsUnit(thisUnit,"focus")) and (not UnitIsUnit("target","target"))
	      -- 			  and safeDoT(thisUnit)
	      -- 			  and thisHP >= options.values.MinHealth then
	      -- 				local vtRem = getDebuffRemain(thisUnit,VT,"player")
	      -- 				if vtRem<=15*0.3  then
	      -- 					if castSpell(thisUnit,VT,true,true,false) then return; end
	      -- 				end
	      -- 			end
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/mind_spike,if=buff.shadow_word_insanity.remains<=gcd&buff.bloodlust.up&!target.dot.shadow_word_pain.remains&!target.dot.vampiric_touch.remains
	      -- 	if getBuffRemain("player",InsanityBuff)<=options.player.GCD
	      -- 	  and hasBloodLust()
	      -- 	  and getDebuffRemain("target",SWP,"player")==0
	      -- 	  and getDebuffRemain("target",VT,"player")==0 then
	      -- 		if castSpell("target",MSp,false,true) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/mind_spike,if=((target.dot.shadow_word_pain.remains&!target.dot.vampiric_touch.remains)|(!target.dot.shadow_word_pain.remains&target.dot.vampiric_touch.remains))&shadow_orb<=2&cooldown.mind_blast.remains>0.5*gcd
	      -- 	if options.player.ORBS<=2
	      -- 	  and options.player.MBCD>0.5*options.player.GCD
	      -- 	  and ((getDebuffRemain("target",SWP,"player")>=0 and getDebuffRemain("target",VT,"player")==0) or (getDebuffRemain("target",SWP,"player")==0 and getDebuffRemain("target",VT,"player")>=0)) then
	      -- 		if castSpell("target",MSp,false,true) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/mind_flay,if=set_bonus.tier17_2pc&target.dot.shadow_word_pain.remains&target.dot.vampiric_touch.remains&cooldown.mind_blast.remains>0.9*gcd,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1)
	      -- 	if isKnown(T172)
	      -- 	  and select(1,UnitChannelInfo("player")) == nil
	      -- 	  and getDebuffRemain("target",SWP,"player")>0
	      -- 	  and getDebuffRemain("target",VT,"player")>0
	      -- 	  and options.player.MBCD>0.9*options.player.GCD then
	      -- 		if castSpell("target",MF,false,true) then return; end
	      -- 	end

	      -- 	--actions.cop_dotweave+=/mind_spike
	      -- 	--if getBuffRemain("player",InsanityBuff)==0 then
	      -- 		if castSpell("target",MSp,false,true) then return; end
	      -- 	--end

	      -- 	if isMoving("player") then
	      -- 		--actions.cop_dotweave+=/shadow_word_death,moving=1
	      -- 		for i=1,#enemiesTable do
	      -- 			local thisUnit = enemiesTable[i].unit
	      -- 			local hp = enemiesTable[i].hp
	      -- 			if hp<20 then
	      -- 				if castSpell(thisUnit,SWD,true,false,false,false,false,false,true) then
	      -- 					return
	      -- 				end
	      -- 			end
	      -- 		end

	      -- 		--actions.cop_dotweave+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
	      -- 		if options.buttons.Halo == 2
	      -- 		  and options.player.MBCD>0.5*options.player.GCD
	      -- 		  and getTalent(6,3)
	      -- 		  and getDistance("player","target")<=30 then
	      -- 			if castSpell("player",Halo,true,false) then return; end
	      -- 		end

	      -- 		--actions.cop_dotweave+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
	      -- 		if getTalent(6,2)
	      -- 		  and getDistance("player","target")<=24 then
	      -- 			if castSpell("target",DivineStar,false,false) then return; end
	      -- 		end

	      -- 		--actions.cop_dotweave+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
	      -- 		if getTalent(6,1)
	      -- 		  and getDistance("player","target")<=40 then
	      -- 			if castSpell("target",Cascade,true,false) then return; end
	      -- 		end

	      -- 		--actions.cop_dotweave+=/shadow_word_pain,moving=1
	      -- 		--if castSpell("target",SWP,true,false) then return; end

	      -- 	end
	      -- end --[[actions.decision=call_action_list,name=cop_dotweave]]

	      -- --[[actions.decision+=/call_action_list,name=cop_mfi,if=talent.clarity_of_power.enabled&talent.insanity.enabled&target.health.pct<=20]]
	      -- if getTalent(7,1)
	      --   and getTalent(3,3)
	      --   and getHP("target")<=20 then

	      -- 	print("cop_mfi")

	      -- 	-- interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1)
	      -- 	-- interrupt Mind Flay
	      --   	if select(1,UnitChannelInfo("player")) == "Mind Flay"
	      --   	  --and getSpellCD(61304)==0
	      --   	  and (options.player.MBCD<=0.1 or options.player.SWDCD<=0.1) then
	      --   		RunMacroText("/stopcasting")
	      --   	end

	      -- 	--actions.cop_mfi=devouring_plague,if=shadow_orb=5
	      -- 	if options.player.ORBS==5 then
	      -- 		if castSpell("target",DP,true,true) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/mind_blast,if=glyph.mind_harvest.enabled&mind_harvest=0,cycle_targets=1
	      -- 	-- tbd

	      -- 	--actions.cop_mfi+=/mind_blast,if=active_enemies<=5&cooldown_react  -- tbd: active enemies
	      -- 	if castSpell("target",MB,false,false) then return; end

	      -- 	--actions.cop_mfi+=/shadow_word_death,if=target.health.pct<20,cycle_targets=1
	      -- 	for i=1,#enemiesTable do
	      -- 		local thisUnit = enemiesTable[i].unit
	      -- 		local hp = enemiesTable[i].hp
	      -- 		if hp<20 then
	      -- 			if castSpell(thisUnit,SWD,true,false,false,false,false,false,true) then
	      -- 				return
	      -- 			end
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_mfi+=/devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<gcd*1.0|target.health.pct<20&cooldown.shadow_word_death.remains<gcd*1.0)
	      -- 	if options.player.ORBS>=3
	      -- 	  and (options.player.MBCD<options.player.GCD or options.player.SWDCD<options.player.GCD) then
	      -- 		if castSpell("target",DP,true,true) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/mindbender,if=talent.mindbender.enabled
	      -- 	if getTalent(3,2)
	      -- 	  and options.buttons.Cooldowns==2
	      -- 	  and options.isChecked.Shadowfiend
	      -- 	  and getBuffRemain("player",InsanityBuff)==0 then
	      -- 		if castSpell("target",Mindbender,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/shadowfiend,if=!talent.mindbender.enabled
	      -- 	if not getTalent(3,2)
	      -- 	  and options.buttons.Cooldowns==2
	      -- 	  and options.isChecked.Shadowfiend
	      -- 	  and getBuffRemain("player",InsanityBuff)==0 then
	      -- 		if castSpell("target",SF,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/shadow_word_pain,if=remains<(18*0.3)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
	      -- 	if options.buttons.DoT==2 or options.buttons.DoT==4
	      -- 	  and getSWP()<=options.values.MaxTargets then
	      -- 		for i=1, #enemiesTable do
	      -- 			local thisUnit = enemiesTable[i].unit
	      -- 			local thisHP = enemiesTable[i].hpabs
	      -- 			if (not UnitIsUnit(thisUnit,"focus")) and (not UnitIsUnit("target","target"))
	      -- 			  and safeDoT(thisUnit)
	      -- 			  and thisHP >= options.values.MinHealth then
	      -- 				local swpRem = getDebuffRemain(thisUnit,SWP,"player")
	      -- 				if swpRem<=18*0.3  then
	      -- 					if castSpell(thisUnit,SWP,true,false) then return; end
	      -- 				end
	      -- 			end
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_mfi+=/vampiric_touch,if=remains<(15*0.3+cast_time)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
	      -- 	if options.buttons.DoT==3 or options.buttons.DoT==4
	      -- 	  and getVT()<=options.values.MaxTargets then
	      -- 		for i=1, #enemiesTable do
	      -- 			local thisUnit = enemiesTable[i].unit
	      -- 			local thisHP = enemiesTable[i].hpabs
	      -- 			if (not UnitIsUnit(thisUnit,"focus")) and (not UnitIsUnit("target","target"))
	      -- 			  and safeDoT(thisUnit)
	      -- 			  and thisHP >= options.values.MinHealth then
	      -- 				local vtRem = getDebuffRemain(thisUnit,VT,"player")
	      -- 				local vtCast = select(4,GetSpellInfo(34914))/1000
	      -- 				if vtRem<=15*0.3+vtCast  then
	      -- 					if castSpell(thisUnit,VT,true,true,false) then return; end
	      -- 				end
	      -- 			end
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_mfi+=/insanity,if=buff.shadow_word_insanity.remains<0.5*gcd&active_enemies<=2,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|(cooldown.shadow_word_death.remains<=0.1*target.health.pct<20))
	      -- 	if getBuffRemain("player",InsanityBuff)<0.5*options.player.GCD
	      -- 	  and #getEnemies("player",40)<=2 then
	      -- 		if castSpell("target",MF,false,true) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/insanity,if=active_enemies<=2,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|(cooldown.shadow_word_death.remains<=0.1*target.health.pct<20))
	      -- 		-- no insanity buff check. error or fail?

	      -- 	--actions.cop_mfi+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
	      -- 	if options.buttons.Halo == 2
	      -- 	  and options.player.MBCD>0.5*options.player.GCD
	      -- 	  and getTalent(6,3)
	      -- 	  and getDistance("player","target")<=30
	      -- 	  and getDistance("player","target")>=17 then
	      -- 		if castSpell("player",Halo,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
	      -- 	if options.player.MBCD>0.5*options.player.GCD
	      -- 	  and getTalent(6,1)
	      -- 	  and ((#getEnemies("player",40)>1 or getDistance("player","target")>=28) and getDistance("player","target")<=40 and getDistance("player","target")>=1) then
	      -- 		if castSpell("target",Cascade,true,false) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
	      -- 	if options.player.MBCD>0.5*options.player.GCD
	      -- 	  and getTalent(6,2)
	      -- 	  and getDistance("player","target")<=24 then
	      -- 		if castSpell("target",DivineStar,false,false) then return; end
	      -- 	end

	      -- 	--actions.cop_mfi+=/mind_sear,if=active_enemies>=6,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1)
	      -- 	if options.isChecked.MindSear then
	      -- 		if #getEnemies("target",10)>=options.values.MindSear then
	      -- 			if select(1,UnitChannelInfo("player")) ~= "Mind Sear" then
	      -- 				if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
	      -- 					if castSpell("target",MS,false,true) then return; end
	      -- 				end
	      -- 			end
	      -- 		end
	      -- 	end

	      -- 	--actions.cop_mfi+=/mind_spike
	      -- 	if castSpell("target",MSp,false,true) then return; end

	      -- 	if isMoving("player") then
	      -- 		--actions.cop_mfi+=/shadow_word_death,moving=1
	      -- 		for i=1,#enemiesTable do
	      -- 			local thisUnit = enemiesTable[i].unit
	      -- 			local hp = enemiesTable[i].hp
	      -- 			if hp<20 then
	      -- 				if castSpell(thisUnit,SWD,true,false,false,false,false,false,true) then
	      -- 					return
	      -- 				end
	      -- 			end
	      -- 		end

	      -- 		--actions.cop_mfi+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
	      -- 		if getBuffRemain(ShadowyInsight)>0 then
	      -- 			if castSpell("target",MB,false,false) then return; end
	      -- 		end

	      -- 		--actions.cop_mfi+=/halo,if=talent.halo.enabled&target.distance<=30,moving=1
	      -- 		if options.buttons.Halo == 2
	      -- 		  and options.player.MBCD>0.5*options.player.GCD
	      -- 		  and getTalent(6,3)
	      -- 		  and getDistance("player","target")<=30 then
	      -- 			if castSpell("player",Halo,true,false) then return; end
	      -- 		end

	      -- 		--actions.cop_mfi+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
	      -- 		if getTalent(6,2)
	      -- 		  and getDistance("player","target")<=24 then
	      -- 			if castSpell("target",DivineStar,false,false) then return; end
	      -- 		end

	      -- 		--actions.cop_mfi+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
	      -- 		if getTalent(6,1)
	      -- 		  and getDistance("player","target")<=40 then
	      -- 			if castSpell("target",Cascade,true,false) then return; end
	      -- 		end

	      -- 		--actions.cop_mfi+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
	      -- 		-- if options.buttons.DoT==2 or options.buttons.DoT==4
	      -- 		--   and getSWP()<=options.values.MaxTargets then
	      -- 		-- 	for i=1, #enemiesTable do
	      -- 		-- 		local thisUnit = enemiesTable[i].unit
	      -- 		-- 		--local thisHP = enemiesTable[i].hpabs
	      -- 		-- 		if (not UnitIsUnit(thisUnit,"focus") or not UnitIsUnit("target","boss1") or not UnitIsUnit("target","target")) then
	      -- 		-- 		  --and safeDoT(thisUnit)
	      -- 		-- 		  --and thisHP >= options.values.MinHealth then
	      -- 		-- 			--local swpRem = getDebuffRemain(thisUnit,SWP,"player")
	      -- 		-- 			--if swpRem<=18*0.3 then
	      -- 		-- 				if castSpell(thisUnit,SWP,true,false) then return; end
	      -- 		-- 			--end
	      -- 		-- 		end
	      -- 		-- 	end
	      -- 		-- end
	      -- 	end
	      -- end --[[actions.decision+=/call_action_list,name=cop_mfi]]

	      -- --[[actions.decision+=/call_action_list,name=cop,if=talent.clarity_of_power.enabled]]
	      -- if getTalent(7,1)
	      --   and not getTalent(3,3) then

	      -- 	print("cop")
	      -- 	--actions.cop=devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<=gcd*1.0|(cooldown.shadow_word_death.remains<=gcd*1.0&target.health.pct<20))&primary_target=0,cycle_targets=1
	      -- 	--actions.cop+=/devouring_plague,if=shadow_orb>=3&(cooldown.mind_blast.remains<=gcd*1.0|(cooldown.shadow_word_death.remains<=gcd*1.0&target.health.pct<20))
	      -- 	--actions.cop+=/mind_blast,if=mind_harvest=0,cycle_targets=1
	      -- 	--actions.cop+=/mind_blast,if=active_enemies<=5&cooldown_react
	      -- 	--actions.cop+=/shadow_word_death,if=target.health.pct<20,cycle_targets=1
	      -- 	--actions.cop+=/mindbender,if=talent.mindbender.enabled
	      -- 	--actions.cop+=/shadowfiend,if=!talent.mindbender.enabled
	      -- 	--actions.cop+=/halo,if=talent.halo.enabled&target.distance<=30&target.distance>=17
	      -- 	--actions.cop+=/cascade,if=talent.cascade.enabled&((active_enemies>1|target.distance>=28)&target.distance<=40&target.distance>=11)
	      -- 	--actions.cop+=/divine_star,if=talent.divine_star.enabled&(active_enemies>1|target.distance<=24)
	      -- 	--actions.cop+=/shadow_word_pain,if=miss_react&!ticking&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
	      -- 	--actions.cop+=/vampiric_touch,if=remains<cast_time&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
	      -- 	--actions.cop+=/mind_sear,if=active_enemies>=5,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1)
	      -- 	--actions.cop+=/mind_spike,if=active_enemies<=4&buff.surge_of_darkness.react
	      -- 	--actions.cop+=/mind_sear,if=active_enemies>=3,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1)
	      -- 	--actions.cop+=/mind_flay,if=target.dot.devouring_plague_tick.ticks_remain>1&active_enemies=1,chain=1,interrupt_if=(cooldown.mind_blast.remains<=0.1|cooldown.shadow_word_death.remains<=0.1)
	      -- 	--actions.cop+=/mind_spike
	      -- 	--actions.cop+=/shadow_word_death,moving=1
	      -- 	--actions.cop+=/mind_blast,if=buff.shadowy_insight.react&cooldown_react,moving=1
	      -- 	--actions.cop+=/halo,moving=1,if=talent.halo.enabled&target.distance<=30
	      -- 	--actions.cop+=/divine_star,if=talent.divine_star.enabled&target.distance<=28,moving=1
	      -- 	--actions.cop+=/cascade,if=talent.cascade.enabled&target.distance<=40,moving=1
	      -- 	--actions.cop+=/shadow_word_pain,if=primary_target=0,moving=1,cycle_targets=1
	      -- end

	      --[[actions.decision+=/call_action_list,name=vent,if=talent.void_entropy.enabled]]
	      --[[actions.decision+=/call_action_list,name=main]]




		end -- AffectingCombat, Pause, Target, Dead/Ghost Check
	end
end

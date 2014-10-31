if select(3, UnitClass("player")) == 10 then
	function WindwalkerMonk()
	    if Currentconfig ~= "Windwalker CuteOne" then
	        WindwalkerConfig();
	        Currentconfig = "Windwalker CuteOne";
	    end
	    WindwalkerToggles()
	    GroupInfo()
       makeEnemiesTable(40)
       targets = enemiesTable
       table.sort(targets, function(x,y)
         return x.hp > y.hp
       end)



	    if not canRun() then
	    	return true
	    end
--------------
--- Locals ---
--------------
		if tebCast == nil then tebCast = 0; end
		local tarDist = getDistance2("target")
		local php = getHP("player")
		local power = getPower("player")
		local powgen = getRegen("player")
		local chi = getChi("player")
		local chimax = getChiMax("player")
		local chiDiff = chimax-chi
		local sckRemain = getBuffRemain("player",_SpinningCraneKick)
		local rjwRemain = getBuffRemain("player",_RushingJadeWind)
		local cbCharge = getCharges(_ChiBrew)
		local cbRecharge = getRecharge(_ChiBrew)
		if tebCast ~= 0 then
			tebRemain = tebCast - GetTime()
		else
			tebRemain = 0
		end
		--local getBuffRemain("player",_TigereyeBrew)
		local tebStack = getBuffStacks("player",_TigereyeBrewStacks)
		local sefStack = getBuffStacks("player",_StormEarthFire)
		local ebRemain = getBuffRemain("player",_EnergizingBrew)
		local ttd = getTimeToDie("target")
		local ttm = getTimeToMax("player")
		local tpRemain = getBuffRemain("player",_TigerPower)
		local serRemain = getBuffRemain("player",_Serenity)
		local rskRemain = getDebuffRemain("target",_RaisingSunKick,"player")
		local fofChanTime = 4-(4*UnitSpellHaste("player")/100)
		local hsChanTime = 2-(2*UnitSpellHaste("player")/100)
		local powtime = power+powgen
		local fofCD = getSpellCD(_FistsOfFury)
		local zsRemain = getBuffRemain("player",_ZenSphere)
		local bkcRemain = getBuffRemain("player",_ComboBreakerBlackoutKick)
		local cecRemain = getBuffRemain("player",_ComboBreakerChiExplosion)
		local tpcRemain = getBuffRemain("player",_ComboBreakerTigerPalm)

--------------------------------------------------
--- Ressurection/Dispelling/Healing/Pause/Misc ---
--------------------------------------------------
	-- Death Monk mode
		if isChecked("Death Monk Mode") then
			-- if (#targets == 0 and sefStack==1) then --(#targets == 1 and sefStack==2) or
			-- 	CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
			-- end
		 	if sefStack == 0 and #targets>0 then
				if castSpell(targets[1].unit,_StormEarthFire,false,false,false) then return; end
		 	end
			if sefStack == 1 and #targets>1 then
				if castSpell(targets[2].unit,_StormEarthFire,false,false,false) then return; end
			end
			if UnitExists("target") then
				if not useAoE() then
					if castSpell("target",_Jab,false,false) then return; end
				else
					if castSpell("target",_SpinningCraneKick,false,false) then return; end
				end
			end
		end
	-- Tigereye Brew Timer
		if tebCast ~= 0 then
			if tebCast <= GetTime() then
				tebCast = 0
			end
		end
	-- Stop Cast 
		if ((tarDist<5 or (BadBoy_data['FSK']==1 and getSpellCD(_FlyingSerpentKick)==0)) and isCastingSpell(_CracklingJadeLightning)) or (not useAoE() and isCastingSpell(_SpinningCraneKick)) then
			RunMacroText("/stopcasting")
		end
	-- Cancel Storm, Earth, and Fire
		if sefStack~=0 and (not isInCombat("player") or BadBoy_data['SEF']~=1) then
			CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
		end
	-- Tiger's Lust
		if hasNoControl() then
			if castSpell("player",_TigersLust,false,false) then return; end
		end
	-- Detox
		if canDispel("player",_Detox) then
			if castSpell("player",_Detox,false,false) then return; end
		end
		if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
			if canDispel("mouseover",_Detox) then
				if castSpell("mouseover",_Detox,false,false) then return; end
			end
	-- Resuscitate
			if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") then
				if castSpell("mouseover",_Resuscitate,false) then return; end
			end
		end
			-- Pause
		if pause() then
			return true
		elseif not isChecked("Death Monk Mode") then
-------------
--- Buffs ---
-------------
		   	if not UnitExists("mouseover") and not isInCombat("player") then
			  	for i = 1, #members do
			  		if (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
	-- Legacy of the White Tiger
						if not isBuffed(members[i].Unit,{17007,1459,61316,116781,90309,126373,160052,126309,24604}) then
							if castSpell("player",_LegacyOfTheWhiteTiger,false,false) then return; end
			  			end
			  		end
				end
			end


------------------
--- Defensives ---
------------------
			if useDefensive() then
	-- Pot/Stoned
		        if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and isInCombat("player") and usePot then
		            if canUse(5512) then
		                UseItemByName(tostring(select(1,GetItemInfo(5512))))
		            elseif canUse(76097) then
		                UseItemByName(tostring(select(1,GetItemInfo(76097))))
		            end
		        end
	--	Expel Harm
				if isChecked("Expel Harm") and php<=getValue("Expel Harm") and power>=40 and getSpellCD(_ExpelHarm)==0 then
					if (isInCombat("player") and chiDiff>=2) or not isInCombat("player") then
						if castSpell("player",_ExpelHarm,false,false,false) then return; end
					end
				end
	-- Surging Mist
				if isChecked("Surging Mist") and php<=getValue("Surging Mist") and not isInCombat("player") and power>=30 and not isMoving("player") then
					if castSpell("player",_SurgingMist,false,false) then return; end
				end
	-- Touch of Karma
				if isChecked("Touch of Karma") and php<=getValue("Touch of Karma") and isInCombat("player") then
					if castSpell("target",_TouchOfKarma,false,false) then return; end
				end
	-- Fortifying Brew
				if isChecked("Fortifying Brew") and php<=getValue("Fortifying Brew") and isInCombat("player") then
					if castSpell("player",_FortifyingBrew,false,false) then return; end
				end
				if isChecked("Diffuse/Dampen") then
	-- Diffuse Magic
					if (php<=getValue("Diffuse/Dampen") and isInCombat("player")) or canDispel("player",_DiffuseMagic) then
						if castSpell("player",_DiffuseMagic,false,false) then return; end
					end
	-- Dampen Harm
					if php<=getValue("Diffuse/Dampen") and isInCombat("player") then
						if castSpell("player",_DampenHarm,false,false) then return; end
					end
				end
	-- Nimble Brew
				if hasNoControl() then
					if castSpell("player",_NimbleBrew,false,false) then return; end
				end
			end

---------------------
--- Out of Combat ---
---------------------
			if not isInCombat("player") then
	-- Expel Harm (Chi Builer)
				if BadBoy_data['Builder']==1 and chiDiff>=2 and power>=40 and getSpellCD(_ExpelHarm) then
					if castSpell("player",_ExpelHarm,false,false,false) then return; end
				end
	-- Provoke
				if select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" and getSpellCD(_FlyingSerpentKick)>1 and tarDist > 10 then
					if select(2,IsInInstance())=="none" and #members==1 then
						if castSpell("target",_Provoke,false,false) then return; end
					end
				end
	-- Flying Serpent Kick
				if BadBoy_data['FSK']==1 then
					if canFSK("target") and not isDummy() and (select(2,IsInInstance())=="none" or isInCombat("target")) then
						if castSpell("player",_FlyingSerpentKick,false,false,false) then return; end
					end
					if (tarDist < 10 or (not canContFSK("target") and UnitExists("target"))) and select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
						if castSpell("player",_FlyingSerpentKickEnd,false,false,false) then return; end
					end
				end
			end

-----------------
--- In Combat ---
-----------------
		if isInCombat("player") then

      -- Automatically target the next-closest enemy within 10 yards (if already in combat)
		findTarget(10,false)

	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
	-- Dummy Test
				if isChecked("DPS Testing") then
					if UnitExists("target") then
						if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
							CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
							StopAttack()
							ClearTarget()
							StopAttack()
							ClearTarget()
							print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
						end
					end
				end
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
				if useInterrupts() then
	-- Quaking Palm
					if isChecked("Quaking Palm") and canInterrupt(_QuakingPalm,tonumber(getValue("Interrupts"))) and tarDist<5 then
						if castSpell("target",_QuakingPalm,false,false) then return; end
					end
	-- Spear Hand Strike
					if isChecked("Spear Hand Strike") and canInterrupt(_SpearHandStrike,tonumber(getValue("Interrupts"))) and getSpellCD(_QuakingPalm)>0 and getSpellCD(_QuakingPalm)<119 and tarDist<5 then
						if castSpell("target",_SpearHandStrike,false,false) then return; end
					end
	-- Paralysis
					if isChecked("Paralysis") and canInterrupt(_Paralysis,tonumber(getValue("Interrupts"))) and ((getSpellCD(_SpearHandStrike)>0 and getSpellCD(_SpearHandStrike)<13) or tarDist>5) and tarDist<20 then
						if castSpell("target",_Paralysis,false,false) then return; end
					end
	-- Leg Sweep
					if isChecked("Leg Sweep") and canInterrupt(_LegSweep,tonumber(getValue("Interrupts"))) and getSpellCD(_Paralysis)>0 and getSpellCD(_Paralysis)<13 and tarDist<5 then
						if castSpell("target",_LegSweep,false,false) then return; end
					end
				end

	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if useCDs() then
			-- Invoke Xuen
					if isChecked("Xuen") then
						if castSpell("target",_InvokeXuen) then return; end
					end
			-- Racial: Troll Berserking
          if isChecked("Racial") and select(2, UnitRace("player")) == "Troll" then
            if castSpell("player",_Berserking,false,false) then return; end
          end
	      end
	--------------------------------
	--- In Combat - All Rotation ---
	--------------------------------

	-- Storm, Earth, and Fire
				if UnitExists("target") and BadBoy_data['SEF']==1 then
					if (#targets == 1 and sefStack==2) or (#targets == 0 and sefStack==1) then
						CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
					end
				 	if sefStack == 0 and #targets>0 then
						if castSpell(targets[1].unit,_StormEarthFire,false,false,false) then return; end
				 	end
					if sefStack == 1 and #targets>1 then
						if castSpell(targets[2].unit,_StormEarthFire,false,false,false) then return; end
					end
				end

	-- Crackling Jade Lightning
				if tarDist >= 8 and (BadBoy_data['FSK']==1 and getSpellCD(_FlyingSerpentKick)>1) and power>20 and chiDiff>=2 and not isCastingSpell(_CracklingJadeLightning) and isInCombat("target") then
					if castSpell("target",_CracklingJadeLightning,false) then return; end
				end
	-- Chi Brew
				if chiDiff>=2 and ((cbCharge==1 and cbRecharge<=10) or cbCharge==2 or ttd<cbCharge*10) and tebStack<=16 then
					if castSpell("player",_ChiBrew,false,false,false) then return; end
				end
	-- Tiger Palm
				if  tarDist<5 and tpRemain<=3 and chi>=1 and sckRemain==0 then
					if castSpell("target",_TigerPalm,false,false) then return; end
				end
	-- Tigereye Brew
				if tebRemain==0
					and (tebStack==20
						or (tebStack>=10 and serRemain>0)
						or (tebStack>=10 and fofCD==0 and chi>=3 and rskRemain>0 and tpRemain>0)
						or (getTalent(7,1) and tebStack>=10 and getSpellCD(_HurricaneStrike)>0 and chi>=3 and rskRemain>0 and tpRemain>0)
						or (chi>=2 and (tebStack>=16 or ttd<40) and rskRemain>0 and tpRemain>0))
				then
					if castSpell("player",_TigereyeBrew,false,false) then tebCast = GetTime()+15; return; end
				end
	-- Raising Sun Kick
				if tarDist<5 and rskRemain==0 and sckRemain==0 and chi>=2 then
					if castSpell("target",_RaisingSunKick,false,false) then return; end
				end
	-- Tiger Palm
				if tarDist<5 and tpRemain==0 and rskRemain>1 and ttm>1 and chi>=1 and sckRemain==0 then
					if castSpell("target",_TigerPalm,false,false) then return; end
				end
	-- Serenity
				if getTalent(7,3) and tarDist<5 and chi>=2 and tpRemain>0 and rskRemain>0 then
					if castSpell("player",_Serenity,false,false) then return; end
				end

			-- Tiger's Lust
				if isMoving("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") and tarDist>=15 then
					if castSpell("player",_TigersLust,false,false) then return; end
				end


	--------------------------------
	--- In Combat - AoE Rotation ---
	--------------------------------
				if useAoE() then
	-- Chi Explosion
					if getTalent(7,2) and chi>=4 then
						if castSpell("player",_ChiExplosion,false,false) then return; end
					end
	-- Rushing Jade Wind
					if getTalent(6,1) and power>=40 and rjwRemain==0 then
						if castSpell("player",_RushingJadeWind,false,false) then return; end
					end
	-- Raising Sun Kick
					if not getTalent(6,1) and chi==chimax and tarDist<5 then
						if castSpell("target",_RaisingSunKick,false,false) then return; end
					end
	-- Fists of Fury
					if getTalent(6,1) and ttm>fofChanTime and tpRemain>fofChanTime and rskRemain>fofChanTime and serRemain==0 then
						if castSpell("target",_FistsOfFury,false,false) then return; end
					end
	-- Touch of Death
					if (UnitBuffID("player",_DeathNote) or UnitHealth("target")<=php) and not UnitIsPlayer("target") and tarDist<5 then
						if castSpell("target",_TouchOfDeath,false,false) then return; end
					end
	-- Hurricane Strike
					if getTalent(6,1) and ttm>hsChanTime and tpRemain>hsChanTime and rskRemain>hsChanTime and ebRemain==0 then
						if castSpell("target",_HurricaneStrike,false,false) then return; end
					end
	-- Zen Sphere
					if zsRemain==0 and tarDist<10 then
						if castSpell("player",_ZenSphere,false,false) then return; end
					end
	-- Chi Wave
					if ttm>2 and serRemain==0 and tarDist<40 then
						if castSpell("player",_ChiWave,false,false) then return; end
					end
	-- Chi Burst
					if getTalent(2,3) and ttm>2 and serRemain==0 and tarDist<40 then
						if castSpell("player",_ChiBurst,false,false) then return; end
					end
	-- Blackout Kick
					if getTalent(6,1) and not getTalent(7,2) and (bkcRemain>0 or serRemain>0) and tarDist<5 then
						if castSpell("target",_BlackoutKick,false,false) then return; end
					end
	-- Tiger Palm
					if getTalent(6,1) and tpcRemain>0 and tpcRemain<=2 and tarDist<5 then
						if castSpell("target",_TigerPalm,false,false) then return; end
					end
	-- Blackout Kick
					if getTalent(6,1) and not getTalent(7,2) and chiDiff<2 and tarDist<5 then
						if castSpell("target",_BlackoutKick,false,false) then return; end
					end
	-- Spinning Crane Kick
					if not getTalent(6,1) and power>=40 then
						if castSpell("player",_SpinningCraneKick,false,false) then return; end
					end
	-- Jab
					if getTalent(6,1) and chiDiff>=2 and power>=45 and (php>=80 or getSpellCD(_ExpelHarm)>0) and tarDist<5 then
						if castSpell("target",_Jab,false,false) then return; end
					end
				end
	-----------------------------------
	--- In Combat - Single Rotation ---
	-----------------------------------
				if not useAoE() then
	-- Fists of Fury
					if ttm>fofChanTime and tpRemain>fofChanTime and rskRemain>fofChanTime and serRemain==0 then
						if castSpell("target",_FistsOfFury,false,false) then return; end
					end
	-- Touch of Death
					if (UnitBuffID("player",_DeathNote) or UnitHealth("target")<=php) and not UnitIsPlayer("target") and tarDist<5 and sckRemain==0 then
						if castSpell("target",_TouchOfDeath,false,false) then return; end
					end
	-- Hurricane Strike
					if getTalent(7,1) and ttm>hsChanTime and tpRemain>hsChanTime and rskRemain>hsChanTime and ebRemain==0 then
						if castSpell("target",_HurricaneStrike,false,false) then return; end
					end
	-- Energizing Brew
					if fofCD>6 and (not getTalent(7,3) or (serRemains==0 and getSpellCD(_Serenity)>4)) and powtime<50 then
						if castSpell("player",_EnergizingBrew,false,false) then return; end
					end
	-- Raising Sun Kick
					if chi>=2 and not getTalent(7,2) and tarDist<5 then
						if castSpell("target",_RaisingSunKick,false,false) then return; end
					end
	-- Chi Wave
					if ttm>2 and serRemain==0 and tarDist<40 then
						if castSpell("player",_ChiWave,false,false) then return; end
					end
	-- Chi Burst
					if getTalent(2,3) and ttm>2 and serRemain==0 and tarDist<40 then
						if castSpell("player",_ChiBurst,false,false) then return; end
					end
	-- Zen Sphere
					if ttm>2 and zsRemain==0 and serRemain==0 and tarDist<10 then
						if castSpell("player",_ZenSphere,false,false) then return; end
					end
	-- Blackout Kick
					if not getTalent(7,2) and (bkcRemain>0 or serRemain>0) and tarDist<5 then
						if castSpell("target",_BlackoutKick,false,false) then return; end
					end
	-- Chi Explosion
					if getTalent(7,2) and chi>=3 and cecRemain>0 and tarDist<30 then
						if castSpell("target",_ChiExplosion,false,false) then return; end
					end
	-- Tiger Palm
					if tarDist<5 and tpcRemain>0 and tpcRemain<=2 then
						if castSpell("target",_TigerPalm,false,false) then return; end
					end
	-- Blackout Kick
					if not getTalent(7,2) and chiDiff<2 and tarDist<5 then
						if castSpell("target",_BlackoutKick,false,false) then return; end
					end
	-- Chi Explosion
					if getTalent(7,2) and chi>=3 and tarDist<30 then
						if castSpell("target",_ChiExplosion,false,false) then return; end
					end
	-- Jab
					if chiDiff>=2 and power>=45 and (php>=80 or getSpellCD(_ExpelHarm)>0) and tarDist<5 then
						if castSpell("target",_Jab,false,false) then return; end
					end
				end
	-- Flying Serpent Kick
				if BadBoy_data['FSK']==1 then
					if canFSK("target") and not isDummy() and (select(2,IsInInstance())=="none" or isInCombat("target")) then
						if castSpell("player",_FlyingSerpentKick,false,false,false) then return; end
					end
					if (tarDist < 10 or not canContFSK("target")) and select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
						if castSpell("player",_FlyingSerpentKickEnd,false,false,false) then return; end
					end
				end
				-- TODO: Start Attack automatticaly when in combat? Is this redundent?
				--if tarDist<5 then
				--	StartAttack()
				--end
			end
		end --In Combat End
	end
end

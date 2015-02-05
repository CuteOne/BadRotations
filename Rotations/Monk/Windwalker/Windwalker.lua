function WindwalkerMonk()
	if select(3, UnitClass("player")) == 10 then
	    if Currentconfig ~= "Windwalker CuteOne" then
	        WindwalkerConfig();
	        Currentconfig = "Windwalker CuteOne";
	    end
	    WindwalkerToggles()
	    GroupInfo()
       	makeEnemiesTable(40)
       	getLoot2()
       	ChatOverlay(GetCurrentKeyBoardFocus())

	    if not canRun() then
	    	return true
	    end
--------------
--- Locals ---
--------------
		if profileStop == nil then profileStop = false end
		if tebCast == nil then tebCast = 0; end
		local dynamicUnit = {
			["dyn5"] = dynamicTarget(5,true), --Melee
			["dyn8"] = dynamicTarget(8,true), --Crackling Jade Lightning - Minimal Range
			["dyn8AoE"] = dynamicTarget(8,false), --Spinning Crane Kick
			["dyn10AoE"] = dynamicTarget(10,false), --Zen Sphere
			["dyn12AoE"] = dynamicTarget(12,false), --Hurricane Strikes
			["dyn20AoE"] = dynamicTarget(20,false), --Paralysis
			["dyn25AoE"] = dynamicTarget(25,false), --Touch of Karma
			["dyn30"] = dynamicTarget(30,true), --Chi Explosion
			["dyn40"] = dynamicTarget(40,true), --Crackling Jade Lightning
			["dyn40AoE"] = dynamicTarget(40,false), --Chi Wave
		}
		local dynamicDist = {
			["dyn5"] = getDistance("player",dynamicUnit.dyn5),
			["dyn8"] = getDistance("player",dynamicUnit.dyn8),
			["dyn10AoE"] = getDistance("player",dynamicUnit.dyn10AoE),
			["dyn30"] = getDistance("player",dynamicUnit.dyn30),
			["dyn40"] = getDistance("player",dynamicUnit.dyn40),
			["dyn40AoE"] = getDistance("player",dynamicUnit.dyn40AoE),
		}
		local tarDist = getDistance("player","target")
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
		local ttd = getTimeToDie(dynamicUnit.dyn5)
		local ttm = getTimeToMax("player")
		local tpRemain = getBuffRemain("player",_TigerPower)
		local serRemain = getBuffRemain("player",_Serenity)
		local rskRemain = getDebuffRemain(dynamicUnit.dyn5,_RaisingSunKick,"player")
		local fofChanTime = 4-(4*UnitSpellHaste("player")/100)
		local hsChanTime = 2-(2*UnitSpellHaste("player")/100)
		local powtime = (getPower("player")+getRegen("player"))*((1.5/GetHaste("player"))+1)
		local fofCD = GetSpellCooldown(_FistsOfFury)
		local zsRemain = getBuffRemain("player",_ZenSphere)
		local bkcRemain = getBuffRemain("player",_ComboBreakerBlackoutKick)
		local cecRemain = getBuffRemain("player",_ComboBreakerChiExplosion)
		local tpcRemain = getBuffRemain("player",_ComboBreakerTigerPalm)

--------------------------------------------------
--- Ressurection/Dispelling/Healing/Pause/Misc ---
--------------------------------------------------
	-- Profile Stop
		if isInCombat("player") and profileStop==true then
			return true
		else
			profileStop=false
		end
	-- Death Monk mode
		if isChecked("Death Monk Mode") then
			if UnitGUID(targets[1].Unit)==UnitGUID(dynmaicUnit.dyn5) or UnitGUID(targets[2].Unit)==UnitGUID(dynmaicUnit.dyn5) then
				CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
			end
		 	if sefStack == 0 and #targets>0 then
				if castSpell(targets[1].Unit,_StormEarthFire,false,false,false) then return end
		 	end
			if sefStack == 1 and #targets>1 then
				if castSpell(targets[2].Unit,_StormEarthFire,false,false,false) then return end
			end
			if not useAoE() then
				if castSpell(dynamicUnit.dyn5,_Jab,false,false) then return end
			else
				if castSpell(dynamicUnit.dyn5,_SpinningCraneKick,false,false) then return end
			end
		end
	-- Tigereye Brew Timer
		if tebCast ~= 0 then
			if tebCast <= GetTime() then
				tebCast = 0
			end
		end
	-- Stop Cast
		if ((dynamicDist.dyn5<5 or (BadBoy_data['FSK']==1 and GetSpellCooldown(_FlyingSerpentKick)==0)) and isCastingSpell(_CracklingJadeLightning)) or (not useAoE() and isCastingSpell(_SpinningCraneKick)) then
			RunMacroText("/stopcasting")
		end
	-- Cancel Storm, Earth, and Fire
		if sefStack~=0 and (not isInCombat("player") or BadBoy_data['SEF']~=1) then
			CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
		end
	-- Tiger's Lust
		if hasNoControl() then
			if castSpell("player",_TigersLust,false,false) then return end
		end
	-- Detox
		if canDispel("player",_Detox) then
			if castSpell("player",_Detox,false,false) then return end
		end
		if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
			if canDispel("mouseover",_Detox) then
				if castSpell("mouseover",_Detox,false,false) then return end
			end
	-- Resuscitate
			if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") then
				if castSpell("mouseover",_Resuscitate,false) then return end
			end
		end
			-- Pause
		if pause() then
			return true
		elseif not isChecked("Death Monk Mode") then
-------------
--- Buffs ---
-------------
		   	if not ObjectExists("mouseover") and not isInCombat("player") and isChecked(getOption(_LegacyOfTheWhiteTiger)) then
			  	for i = 1, #members do
			  		if (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
	-- Legacy of the White Tiger
						if not isBuffed(members[i].Unit,{17007,1459,61316,116781,90309,126373,160052,126309,24604}) then
							if castSpell("player",_LegacyOfTheWhiteTiger,false,false) then return end
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
				if isChecked(getOption(_ExpelHarm)) and php<=getValue(getOption(_ExpelHarm)) and power>=40 and GetSpellCooldown(_ExpelHarm)==0 then
					if (isInCombat("player") and chiDiff>=2) or not isInCombat("player") then
						if castSpell("player",_ExpelHarm,true,false,false) then return end
					end
				end
	-- Surging Mist
				if isChecked(getOption(_SurgingMist)) and php<=getValue(getOption(_SurgingMist)) and not isInCombat("player") and power>=30 and not isMoving("player") then
					if castSpell("player",_SurgingMist,true,false) then return end
				end
	-- Touch of Karma
				if isChecked(getOption(_TouchOfKarma)) and php<=getValue(getOption(_TouchOfKarma)) and isInCombat("player") then
					if castSpell(dynamicUnit.dyn25AoE,_TouchOfKarma,false,false) then return end
				end
	-- Fortifying Brew
				if isChecked(getOption(_FortifyingBrew)) and php<=getValue(getOption(_FortifyingBrew)) and isInCombat("player") then
					if castSpell("player",_FortifyingBrew,true,false) then return end
				end
	-- Diffuse Magic
				if isChecked(getOption(_DiffuseMagic)) and (php<=getValue(getOption(_DiffuseMagic)) and isInCombat("player")) or canDispel("player",_DiffuseMagic) then
					if castSpell("player",_DiffuseMagic,true,false) then return end
				end
	-- Dampen Harm
				if isChecked(getOption(_DampenHarm)) and php<=getValue(getOption(_DampenHarm)) and isInCombat("player") then
					if castSpell("player",_DampenHarm,true,false) then return end
				end
	-- Zen Meditation
				if isChecked(getOption(_ZenMeditation)) then
					if php<=getValue(getOption(_ZenMeditation)) and isInCombat("player") then
						if (hasGlyph(120477) or (not hasGlyph(120477) and GetUnitSpeed("player")==0)) and tarDist>5 then
							if castSpell("player",_ZenMeditation,true,false) then return end
						end
					end
				end
	-- Nimble Brew
				if isChecked(getOption(_NimbleBrew)) and hasNoControl() then
					if castSpell("player",_NimbleBrew,false,false) then return end
				end
			end

---------------------
--- Out of Combat ---
---------------------
			if not isInCombat("player") then
	-- Expel Harm (Chi Builer)
				if BadBoy_data['Builder']==1 and chiDiff>=2 and power>=40 and GetSpellCooldown(_ExpelHarm)==0 and select(2,IsInInstance())~="none" then
					if castSpell("player",_ExpelHarm,false,false,false) then return end
				end
	-- Provoke
				if select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" and GetSpellCooldown(_FlyingSerpentKick)>1 and dynamicDist.dyn40AoE > 10 and ObjectExists("target") then
					if select(2,IsInInstance())=="none" and #members==1 then
						if castSpell(dynamicUnit.dyn40AoE,_Provoke,false,false) then return end
					end
				end
	-- Flying Serpent Kick
				if BadBoy_data['FSK']==1 and ObjectExists("target") then
					if canFSK("target") and not isDummy() and (select(2,IsInInstance())=="none" or isInCombat("target")) then
						if castSpell("player",_FlyingSerpentKick,false,false,false) then return end
					end
					if (tarDist < 5 or (not canContFSK("target") and ObjectExists("target"))) and select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
						if castSpell("player",_FlyingSerpentKickEnd,false,false,false) then return end
					end	
	-- Roll
					if not canFSK("target") and not canContFSK("target") and tarDist>10 and getFacingDistance()<5 and getFacing("player","target",10) and getCharges(_Roll)>0 then
						if castSpell("player",_Roll,true,false,false) then return end
					end
				end
	-- Start Attack
          		if dynamicDist.dyn5<5 and ObjectExists("target") then
            		StartAttack()
          		end
			end

-----------------
--- In Combat ---
-----------------
		if isInCombat("player") and profileStop==false then
	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
	-- Dummy Test
				if isChecked("DPS Testing") then
					if ObjectExists("target") then
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
					if isChecked(getOption(_QuakingPalm)) then
						if castInterrupt(_QuakingPalm,tonumber(getValue("Interrupt At"))) then return end
					end
	-- Spear Hand Strike
					if isChecked(getOption(_SpearHandStrike)) then
						if castInterrupt(_SpearHandStrike,tonumber(getValue("Interrupt At"))) then return end
					end
	-- Paralysis
					if isChecked(getOption(_Paralysis)) then
						if castInterrupt(_Paralysis,tonumber(getValue("Interrupt At"))) then return end
					end
	-- Leg Sweep
					if isChecked(getOption(_LegSweep)) then
						if castInterrupt(_LegSweep,tonumber(getValue("Interrupt At"))) then return end
					end
				end
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
				if useCDs() and tarDist<5 and not IsMounted() then
			-- Trinkets
					if canTrinket(13) and useCDs() then
						RunMacroText("/use 13")
						if IsAoEPending() then
							local X,Y,Z = ObjectPosition(Unit)
							CastAtPosition(X,Y,Z)
						end
					end
					if canTrinket(14) and useCDs() then
						RunMacroText("/use 14")
						if IsAoEPending() then
							local X,Y,Z = ObjectPosition(Unit)
							CastAtPosition(X,Y,Z)
						end
					end
			-- Invoke Xuen
					if isChecked(getOption(_InvokeXuen)) then
						if castSpell(thisUnit,_InvokeXuen,true,false,false) then return end
					end
			-- Potion
					if canUse(109217) and serRemain>0 and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
						UseItemByName(tostring(select(1,GetItemInfo(109217))))
	            	end
			-- Racial: Troll Berserking
					if isChecked("Racial") and select(2, UnitRace("player")) == "Troll" then
						if castSpell("player",_Berserking,false,false) then return end
					end
	      		end
	--------------------------------
	--- In Combat - All Rotation ---
	--------------------------------
	-- Start Attack
		        if dynamicDist.dyn5<5 then
		        	StartAttack()
		        end
	-- Storm, Earth, and Fire
				if ObjectExists(dynamicUnit.dyn40AoE) and BadBoy_data['SEF']==1 then
					local sefEnemies = getEnemies("player",40)
					if #sefEnemies>1 then
						for i=1, #sefEnemies do
							local sefTar = sefEnemies[i]
							local sefGUID = UnitGUID(sefTar)
							local tarGUID = UnitGUID("target")
							local sefed = UnitDebuffID(sefTar,_StormEarthFireDebuff,"player")~=nil
							if not sefed and sefGUID~=tarGUID and sefStack<2 and isAggroed(sefTar) then
								if castSpell(sefTar,_StormEarthFire,false,false,false) then sefTar1 = sefTar; return end
							elseif sefed and sefGUID==tarGUID then
								CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
							end
						end
					elseif sefStack>0 and #sefEnemies==1 then
						CancelUnitBuff("player", GetSpellInfo(_StormEarthFire))
					end
				end
	-- Roll
				if BadBoy_data['FSK']==1 and not canFSK("target") and tarDist>10 
					and getFacingDistance()<5 and getFacing("player","target",10) and getCharges(_Roll)>0 
				then
					if castSpell("player",_Roll,true,false,false) then return end
				end
	-- Crackling Jade Lightning
				if dynamicDist.dyn8 >= 8 and (BadBoy_data['FSK']==1 and GetSpellCooldown(_FlyingSerpentKick)>1) and power>20 
					and chiDiff>=2 and not isCastingSpell(_CracklingJadeLightning) and isInCombat(dynamicUnit.dyn40) 
				then
					if castSpell(dynamicUnit.dyn40,_CracklingJadeLightning,false) then return end
				end
	-- Chi Brew
				if chiDiff>=2 and ((cbCharge==1 and cbRecharge<=10) or cbCharge==2 or ttd<cbCharge*10) and tebStack<=16 then
					if castSpell("player",_ChiBrew,false,false,false) then return end
				end
	-- Tiger Palm
				if tpRemain<=3 and chi>=1 and sckRemain==0 then
					if castSpell(dynamicUnit.dyn5,_TigerPalm,false,false) then return end
				end
	-- Tigereye Brew
				if tebRemain==0
					and (tebStack==20
						or (tebStack>=10 and serRemain>0)
						or (tebStack>=10 and fofCD==0 and chi>=3 and rskRemain>0 and tpRemain>0)
						or (getTalent(7,1) and tebStack>=10 and GetSpellCooldown(_HurricaneStrike)>0 and chi>=3 and rskRemain>0 and tpRemain>0)
						or (chi>=2 and (tebStack>=16 or ttd<40) and rskRemain>0 and tpRemain>0))
				then
					if castSpell("player",_TigereyeBrew,false,false) then tebCast = GetTime()+15; return end
				end
	-- Raising Sun Kick
				if rskRemain==0 and sckRemain==0 and chi>=2 then
					if castSpell(dynamicUnit.dyn5,_RaisingSunKick,false,false) then return end
				end
	-- Tiger Palm
				if tpRemain==0 and rskRemain>1 and ttm>1 and chi>=1 and sckRemain==0 then
					if castSpell(dynamicUnit.dyn5,_TigerPalm,false,false) then return end
				end
	-- Serenity
				if getTalent(7,3) and dynamicDist.dyn5<5 and chi>=2 and tpRemain>0 and rskRemain>0 then
					if castSpell("player",_Serenity,true,false) then return end
				end
	-- Tiger's Lust
				if isMoving("player") and ObjectExists("target") and not UnitIsDeadOrGhost("target") and tarDist>=15 then
					if castSpell("player",_TigersLust,false,false) then return end
				end

	--------------------------------
	--- In Combat - AoE Rotation ---
	--------------------------------
				if useAoE() then
	-- Chi Explosion
					if getTalent(7,2) and chi>=4 then
						if castSpell(dynamicUnit.dyn30,_ChiExplosion,false,false) then return end
					end
	-- Rushing Jade Wind
					if getTalent(6,1) and power>=40 and rjwRemain==0 then
						if castSpell("player",_RushingJadeWind,false,false) then return end
					end
	-- Raising Sun Kick
					if not getTalent(6,1) and chi==chimax then
						if castSpell(dynamicUnit.dyn5,_RaisingSunKick,false,false) then return end
					end
	-- Fists of Fury
					if getTalent(6,1) and ttm>fofChanTime and tpRemain>fofChanTime and rskRemain>fofChanTime and serRemain==0 then
						if castSpell(dynamicUnit.dyn5,_FistsOfFury,false,false) then return end
					end
	-- Touch of Death
					if (UnitBuffID("player",_DeathNote) or UnitHealth(dynamicUnit.dyn5)<=php) and not UnitIsPlayer(dynamicUnit.dyn5) then
						if castSpell(dynamicUnit.dyn5,_TouchOfDeath,false,false) then return end
					end
	-- Hurricane Strike
					if getTalent(6,1) and ttm>hsChanTime and tpRemain>hsChanTime and rskRemain>hsChanTime and ebRemain==0 then
						if castSpell(dynamicUnit.dyn12AoE,_HurricaneStrike,false,false) then return end
					end
	-- Zen Sphere
					if zsRemain==0 and dynamicDist.dyn10AoE<10 then
						if castSpell("player",_ZenSphere,false,false) then return end
					end
	-- Chi Wave
					if ttm>2 and serRemain==0 and dynamicDist.dyn40AoE<40 then
						if castSpell("player",_ChiWave,false,false) then return end
					end
	-- Chi Burst
					if getTalent(2,3) and ttm>2 and serRemain==0 and dynamicDist.dyn40AoE<40 then
						if castSpell("player",_ChiBurst,false,false) then return end
					end
	-- Blackout Kick
					if getTalent(6,1) and not getTalent(7,2) and (bkcRemain>0 or serRemain>0) then
						if castSpell(dynamicUnit.dyn5,_BlackoutKick,false,false) then return end
					end
	-- Tiger Palm
					if getTalent(6,1) and tpcRemain>0 and tpcRemain<=2 then
						if castSpell(dynamicUnit.dyn5,_TigerPalm,false,false) then return end
					end
	-- Blackout Kick
					if getTalent(6,1) and not getTalent(7,2) and chiDiff<2 then
						if castSpell(dynamicUnit.dyn5,_BlackoutKick,false,false) then return end
					end
	-- Spinning Crane Kick
					if not getTalent(6,1) and power>=40 then
						if castSpell("player",_SpinningCraneKick,false,false) then return end
					end
	-- Jab
					if getTalent(6,1) and chiDiff>=2 and power>=45 and (php>=getValue("Expel Harm") or GetSpellCooldown(_ExpelHarm)>0) then
						if castSpell(dynamicUnit.dyn5,_Jab,false,false) then return end
					end
				end
	-----------------------------------
	--- In Combat - Single Rotation ---
	-----------------------------------
				if not useAoE() then
	-- Fists of Fury
					if ttm>fofChanTime and tpRemain>fofChanTime and rskRemain>fofChanTime and serRemain==0 then
						if castSpell(dynamicUnit.dyn5,_FistsOfFury,false,false) then return end
					end
	-- Empowered Touch of Death
					if canEnhanceToD() and sckRemain==0 then
						if castSpell("player",_FortifyingBrew,true,false) then return end
					end
	-- Touch of Death
					if canToD() and sckRemain==0 then
						if castSpell(dynamicUnit.dyn5,_TouchOfDeath,false,false) then return end
					end
	-- Hurricane Strike
					if getTalent(7,1) and ttm>hsChanTime and tpRemain>hsChanTime and rskRemain>hsChanTime and ebRemain==0 then
						if castSpell(dynamicUnit.dyn12AoE,_HurricaneStrike,false,false) then return end
					end
	-- Energizing Brew
					if fofCD>6 and (not getTalent(7,3) or (serRemain==0 and GetSpellCooldown(_Serenity)>4)) and powtime<50 then
						if castSpell("player",_EnergizingBrew,false,false) then return end
					end
	-- Raising Sun Kick
					if chi>=2 and not getTalent(7,2) then
						if castSpell(dynamicUnit.dyn5,_RaisingSunKick,false,false) then return end
					end
	-- Chi Wave
					if ttm>2 and serRemain==0 and dynamicDist.dyn40AoE<40 then
						if castSpell("player",_ChiWave,false,false) then return end
					end
	-- Chi Burst
					if getTalent(2,3) and ttm>2 and serRemain==0 and dynamicDist.dyn40AoE<40 then
						if castSpell("player",_ChiBurst,false,false) then return end
					end
	-- Zen Sphere
					if ttm>2 and zsRemain==0 and serRemain==0 and dynamicDist.dyn10AoE<10 then
						if castSpell("player",_ZenSphere,false,false) then return end
					end
	-- Blackout Kick
					if not getTalent(7,2) and (bkcRemain>0 or serRemain>0) then
						if castSpell(dynamicUnit.dyn5,_BlackoutKick,false,false) then return end
					end
	-- Chi Explosion
					if getTalent(7,2) and chi>=3 and cecRemain>0 and dynamicDist.dyn30<30 then
						if castSpell(dynamicUnit.dyn30,_ChiExplosion,false,false) then return end
					end
	-- Tiger Palm
					if tpcRemain>0 and tpcRemain<=2 then
						if castSpell(dynamicUnit.dyn5,_TigerPalm,false,false) then return end
					end
	-- Blackout Kick
					if not getTalent(7,2) and chiDiff<2 then
						if castSpell(dynamicUnit.dyn5,_BlackoutKick,false,false) then return end
					end
	-- Chi Explosion
					if getTalent(7,2) and chi>=3 and dynamicDist.dyn30<30 then
						if castSpell(dynamicUnit.dyn30,_ChiExplosion,false,false) then return end
					end
	-- Jab
					if (chiDiff>=2 or chi==0) and power>=45 and (php>=getValue("Expel Harm") or GetSpellCooldown(_ExpelHarm)>0) then
						if castSpell(dynamicUnit.dyn5,_Jab,false,false) then return end
					end
				end
	-- Flying Serpent Kick
				if BadBoy_data['FSK']==1 then
					if canFSK("target") and not isDummy() and (select(2,IsInInstance())=="none" or isInCombat("target")) then
						if castSpell("player",_FlyingSerpentKick,false,false,false) then return end
					end
					if (tarDist < 5 or not canContFSK("target")) and select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
						if castSpell("player",_FlyingSerpentKickEnd,false,false,false) then return end
					end
				end
				-- TODO: Start Attack automatticaly when in combat? Is this redundent?
				if dynamicDist.dyn5<5 and isInCombat("player") and profileStop==false then
					StartAttack()
				end
			end
		end --In Combat End
	end
end

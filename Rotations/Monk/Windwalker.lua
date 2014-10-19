if select(3, UnitClass("player")) == 10 then
	function WindwalkerMonk()
	    if Currentconfig ~= "Windwalker CuteOne" then
	        WindwalkerConfig();
	        Currentconfig = "Windwalker CuteOne";
	    end
	    WindwalkerToggles()
	    GroupInfo()
	    if not canRun() then
	    	return true
	    end
--------------
--- Locals ---
--------------
		local tarDist = targetDistance
		local php = getHP("player")
		local power = getPower("player")
		local powgen = getRegen("player")
		local chi = getChi("player")
		local chimax = getChiMax("player")
		local chiDiff = chimax-chi
		local sckRemain = getBuffRemain("player",_SpinningCraneKick)
		local cbCharge = getCharges(_ChiBrew)
		local cbRecharge = getRecharge(_ChiBrew)
		local tebStack = getBuffStacks("player",_TigereyeBrew)
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

----------------------
--- Rotation Pause ---
----------------------
		if pause() then
			return true
		else
---------------------------------------
--- Ressurection/Dispelling/Healing ---
---------------------------------------
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
				if not isInCombat("player") then
					if castSpell("mouseover",_Resuscitate,false) then return; end
				end
			end
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
	--	Expel Harm
			if php<=80 and power>=40 and getSpellCD(_ExpelHarm)==0 then
				if isInCombat("player") and chiDiff>=2 then
					if castSpell("player",_ExpelHarm,false,false) then return; end
				end
				if not isInCombat("player") and getNumEnemies("player",10)==0 then
					if castSpell("player",_ExpelHarm,false,false) then return; end
				end
			end
	-- Touch of Karma
			if php<=50 then
				if castSpell("target",_TouchOfKarma,false,false) then return; end
			end
	-- Fortifying Brew
			if php<=40 then
				if castSpell("player",_FortifyingBrew,false,false) then return; end
			end
	-- Diffuse Magic
			if php<=30 or canDispel("player",_DiffuseMagic) then
				if castSpell("player",_DiffuseMagic,false,false) then return; end
			end
	-- Nimble Brew
			if hasNoControl() then
				if castSpell("player",_NimbleBrew,false,false) then return; end
			end

---------------------
--- Out of Combat ---
---------------------
			if not isInCombat("player") then
	-- Expel Harm (Chi Builer)
				if BadBoy_data['Builder']==1 and chiDiff>=2 and power>=40 and getSpellCD(_ExpelHarm) then
					if castSpell("player",_ExpelHarm,false,false) then return; end
				end
	-- Provoke
				if getSpellCD(_FlyingSerpentKick)>1 and tarDist > 10 then
					if select(2,IsInInstance())=="none" and #members==1 then
						if castSpell("target",_Provoke,false,false) then return; end
					end
				end
	-- Flying Serpent Kick
				if canFSK("target") and not isDummy() then
					if castSpell("player",_FlyingSerpentKick,false,false) then return; end
				end
				if tarDist < 10 and select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
					if castSpell("player",_FlyingSerpentKickEnd,false,false) then return; end
				end
			end

-----------------
--- In Combat ---
-----------------
			if isInCombat("player") then
				if isCastingSpell(_CracklingJadeLightning) and tarDist < 4 then
					RunMacroText("/stopcasting")
				end

	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
	-- Dummy Test
				if isChecked("DPS Testing") then
					if UnitExists("target") then
						if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
							StopAttack()
							ClearTarget()
							print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
						end
					end
				end
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
	-- Quaking Palm
				if canInterrupt(_QuakingPalm,tonumber(getValue("Interrupts"))) and tarDist<4 then
					if castSpell("target",_QuakingPalm,false,false) then return; end
				end
	-- Spear Hand Strike
				if canInterrupt(_SpearHandStrike,tonumber(getValue("Interrupts"))) and getSpellCD(_QuakingPalm)>0 and getSpellCD(_QuakingPalm)<119 and tarDist<4 then
					if castSpell("target",_SpearHandStrike,false,false) then return; end
				end
	-- Paralysis
				if canInterrupt(_Paralysis,tonumber(getValue("Interrupts"))) and getSpellCD(_SpearHandStrike)>0 and getSpellCD(_SpearHandStrike)<13 and tarDist<20 then
					if castSpell("target",_Paralysis,false,false) then return; end
				end
	-- Leg Sweep
				if canInterrupt(_LegSweep,tonumber(getValue("Interrupts"))) and getSpellCD(_Paralysis)>0 and getSpellCD(_Paralysis)<13 and tarDist<5 then
					if castSpell("target",_LegSweep,false,false) then return; end
				end

	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
		-- Invoke Xuen
				if useCDs() then
					if castSpell("target",_InvokeXuen) then return; end
				end
	--------------------------------
	--- In Combat - All Rotation ---
	--------------------------------
	-- Crackling Jade Lightning
				if tarDist >= 8 and getSpellCD(_FlyingSerpentKick)>1 and power>20 and chiDiff>=2 and not isCastingSpell(_CracklingJadeLightning) then
					if castSpell("target",_CracklingJadeLightning,false) then return; end
				end
	-- Chi Brew
				if chiDiff>=2 and ((cbCharge==1 and cbRecharge<=10) or cbCharge==2 or ttd<cbCharge*10) and tebStack<=16 then
					if castSpell("player",_ChiBrew,false,false) then return; end
				end
	-- Tiger Palm
				if  tarDist<4 and tpRemain<=3 and chi>=1 and sckRemain==0 then
					if castSpell("target",_TigerPalm,false,false) then return; end
				end
	-- Tigereye Brew
				if getTigereyeRemain()==0
					and (tebStack==20
						or (tebStack>=10 and serRemain>0)
						or (tebStack>=10 and fofCD==0 and chi>=3 and rskRemain>0 and tpRemain>0)
						or (getTalent(7,1) and tebStack>=10 and getSpellCD(_HurricaneStrike)>0 and chi>=3 and rskRemain>0 and tpRemain>0)
						or (chi>=2 and (tebStack>=16 or ttd<40) and rskRemain>0 and tpRemain>0))
				then
					if castSpell("player",_TigereyeBrew,false,false) then return; end
				end
	-- Raising Sun Kick
				if tarDist<4 and rskRemain==0 and sckRemain==0 and chi>=2 then
					if castSpell("target",_RaisingSunKick,false,false) then return; end
				end
	-- Tiger Palm
				if tarDist<4 and tpRemain==0 and rskRemain>1 and ttm>1 and chi>=1 and sckRemain==0 then
					if castSpell("target",_TigerPalm,false,false) then return; end
				end
	-- Serenity
				if getTalent(7,3) and tarDist<4 and chi>=2 and tpRemain>0 and rskRemain>0 then
					if castSpell("player",_Serenity,false,false) then return; end
				end

	-----------------------------------------
	--- In Combat - Multi-Target Rotation ---
	-----------------------------------------
				if useAoE() then
	-- Raising Sun Kick
					if tarDist<4 and chi>=4 then
						if castSpell("target",_RaisingSunKick,false,false) then return; end
					end
	--	Spinning Crane Kick
					if power>=40 and tpRemain>2 and sckRemain==0 and sckRemain==0 then
						if castSpell("player",_SpinningCraneKick,false,false) then return; end
					end
				end --End Multitarget Rotation
	------------------------------------------
	--- In Combat - Single-Target Rotation ---
	------------------------------------------
				if not useAoE() then
	-- Fists of Fury - if=energy.time_to_max>cast_time&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&!buff.serenity.remains
					if ttm>fofChanTime and tpRemain>fofChanTime and rskRemain>fofChanTime and serRemain==0 then
						if castSpell("target",_FistsOfFury,false,false) then return; end
					end
	-- Touch of Death
					if (UnitBuffID("player",_DeathNote) or UnitHealth("target")<=php) and not UnitIsPlayer("target") and tarDist<4 and sckRemain==0 then
						if castSpell("target",_TouchOfDeath,false,false) then return; end
					end
	-- Hurricane Strike
					if getTalent(7,1) and ttm>hsChanTime and tpRemain>hsChanTime and rskRemain>hsChanTime and ebRemain==0 then
						if castSpell("target",_HurricaneStrike,false,false) then return; end
					end
	--Energizing Brew
					if fofCD>6 and (not getTalent(7,3) or (serRemains==0 and getSpellCD(_Serenity)>4)) and powtime<50 then
						if castSpell("player",_EnergizingBrew,false,false) then return; end
					end
	-- Raising Sun Kick
					if chi>=2 and not getTalent(7,2) then
						if castSpell("target",_RaisingSunKick,false,false) then return; end
					end
	-- Chi Wave
					if ttm>2 and serRemain==0 and tarDist<=40 then
						if castSpell("player",_ChiWave,false,false) then return; end
					end
	-- Chi Burst
					if getTalent(2,3) and ttm>2 and serRemain==0 and tarDist<=40 then
						if castSpell("player",_ChiBurst,false,false) then return; end
					end
	-- Zen Sphere
					if ttm>2 and zsRemain==0 and serRemain==0 and tarDist<10 then
						if castSpell("player",_ZenSphere,false,false) then return; end
					end
	-- Blackout Kick
					if not getTalent(7,2) and (bkcRemain>0 or serRemain==0) and tarDist<4 then
						if castSpell("target",_BlackoutKick,false,false) then return; end
					end
	-- Chi Explosion
					if getTalent(7,2) and chi>=3 and cecRemain>0 and tarDist<30 then
						if castSpell("target",_ChiExplosion,false,false) then return; end
					end
	-- Tiger Palm
					if tarDist<4 and tpcRemain>0 and tpcRemain<=2 then
						if castSpell("target",_TigerPalm,false,false) then return; end
					end
	-- Blackout Kick
					if not getTalent(7,2) and chiDiff<2 and tarDist<4 then
						if castSpell("target",_BlackoutKick,false,false) then return; end
					end
	-- Chi Explosion
					if getTalent(7,2) and chi>=3 and tarDist<30 then
						if castSpell("target",_ChiExplosion,false,false) then return; end
					end
	-- Jab
					if chiDiff>=2 and power>=45 and (php>=80 or getSpellCD(_ExpelHarm)>0) and tarDist<4 then
						if castSpell("target",_Jab,false,false) then return; end
					end
				end -- End Single Target Rotation
	-- Flying Serpent Kick
				if canFSK("target") and not isDummy() then
					if castSpell("player",_FlyingSerpentKick,false,false) then return; end
				end
				if tarDist < 10 and select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
					if castSpell("player",_FlyingSerpentKickEnd,false,false) then return; end
				end
			end --In Combat End
	-- Start Attack
			if tarDist<4 then
				StartAttack()
			end
		end
	end
end

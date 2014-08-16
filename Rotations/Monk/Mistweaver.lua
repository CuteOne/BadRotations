if select(3,UnitClass("player")) == 10 then

function MistweaverMonk()
	if HealingModesLoaded ~= "Mist Monk Healing Modes" then
		MonkMistToggles();
		MonkMistConfig();
	end
-- Healing Sheres
	if SpellIsTargeting() then
		if UnitExists("target") then
			local X, Y, Z = IGetLocation(UnitGUID("target"));
			CastAtLocation(X,Y,Z);
			SpellStopTargeting()
			return true;
		end
	end
-- Locals
	local isSoothing = UnitChannelInfo("player") == GetSpellInfo(_SoothingMist) or nil;
	local chi = UnitPower("player", SPELL_POWER_CHI);
	local chiMax = UnitPowerMax("player", SPELL_POWER_CHI)
	local energy = getPower("player");
	local myHP = getHP("player");
	local ennemyUnits = getNumEnnemies("player", 5)
-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then return false; end
    GroupInfo()
---------------------------------------
--- Ressurection/Dispelling/Healing ---
---------------------------------------
	if isValidTarget("mouseover")
		and UnitIsDeadOrGhost("mouseover") 
		and UnitIsPlayer("mouseover") 
		and not UnitBuffID("player", 80169) -- Food
  		and not UnitBuffID("player", 87959) -- Drink
 	 	and UnitCastingInfo("player") == nil
 	 	and UnitChannelInfo("player") == nil 
	  	and not UnitIsDeadOrGhost("player")
	  	and not IsMounted()
	  	and not IsFlying()
	  	and targetDistance <= 40
	then
-- Detox
		if isChecked("Detox") == true and canDispel("player",_Detox) then
			if castSpell("player",_Detox,true) then return; end
		end
		if isChecked("Detox") == true and canDispel("mouseover",_Detox) then
			if castSpell("mouseover",_Detox,true) then return; end
		end
-- Resuscitate
		if isChecked("Resuscitate") == true and not isInCombat("player") then
			if castSpell("mouseover",_Resuscitate,true) then return; end
		end
	end
-------------
--- Buffs ---
-------------
	if not UnitBuffID("player", 80169) -- Food
		and not UnitBuffID("player", 87959) -- Drink
		and UnitCastingInfo("player") == nil
		and UnitChannelInfo("player") == nil 
		and not UnitIsDeadOrGhost("player")
		and not IsMounted()
		and not IsFlying()
		and not isInCombat("player")
	then
-- Stance
		local myStance = GetShapeshiftForm()
	    if isChecked("Stance") then
	    	if getValue("Stance") == 1 and myStance ~= 1 then
	    		if castSpell("player",115070,true) then return; end
	    	elseif getValue("Stance") == 2 and myStance ~= 2 then
	    		if castSpell("player",103985,true) then return; end
	    	end
	    end
	   	if not UnitExists("mouseover") then
		  	for i = 1, #members do
		  		if (#members==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
-- Legacy of the Emperor
		  			if not isBuffed(members[i].Unit,{115921,20217,1126,90363}) then
						if castSpell("player",_LegacyOfTheEmperor,true) then return; end
			  		end
		  		end
			end 
		end
	end

------------------
--- Defensives ---
------------------
--	Expel Harm
	if getHP("player")<=80 and (getChiMax("player")-getChi("player"))>=2 and getPower("player")>=40 and not isCasting("player") then
		if castSpell("player",_ExpelHarm,true) then return; end
	end
-- Nimble Brew
	if hasNoControl() then
		if castSpell("player",_NimbleBrew,true) then 
			return; 
		elseif castSpell("player",_TigersLust,true) then 
			return;
		end
	end

---------------------
--- Out of Combat ---
---------------------
	if not isInCombat("player") then
		if canAttack("target","player") and not UnitIsDeadOrGhost("target") then
-- Dazzling Brew
			if isChecked("Dazzling Brew") == true then
				if targetDistance <= 40 and getGround("target") == true and UnitExists("target") and (isDummy("target") or getDistance("target","targettarget") <= 15) then
					 CastSpellByName(GetSpellInfo(115180),nil);
					 return;
				end
			end 
		end
	end
-----------------
--- In Combat ---
-----------------
	--if isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then			
----------------------
--- Rotation Pause ---
----------------------
	-- Pause toggle
	if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end
	-- Focus Toggle
	if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then 
		RunMacroText("/focus mouseover");
	end


------Abilities------
_BlackoutKick           	=   100784  --Blackout Kick
_ChiWave                	=   115098  --Chi Wave
_CracklingJadeLightning 	=   117952  --Crackling Jade Lightning
_DampenHarm             	=   122278  --Dampen Harm
_Disable                	=   116095  --Disable
_Detox                  	=   115450  --Detox
_EnergizingBrew				=   115288  --Energizing Brew
_ExpelHarm					=   115072  --Expel Harm
_FistsOfFury				=   113656  --Fists of Fury
_FlyingSerpentKick			=   101545  --Flying Serpent Kick
_FortifyingBrew				=   115203  --Fortifying Brew
_GrapleWaepon				=   117368  --Grapple Weapon
_InvokeXuen					=   123904  --Invoke Xuen
_Jab						=   115698  --Jab
_LegacyOfTheEmperor			=   115921  --Legacy of the Emperor
_LegSweep					=   119381  --Leg Sweep
_LegacyOfTheWhiteTiger		=   116781  --Legacy of the White Tiger
_NimbleBrew					=   137562  --Nimble Brew
_Paralysis					=   115078  --Paralysis
_Provoke					=   115546  --Provoke
_QuakingPalm				=   107079  --Quaking Palm
_Resuscitate				=   115178  --Resuscitate
_Roll						=   109132  --Roll
_RaisingSunKick				=   107428  --Raising Sun Kick
_SpinningCraneKick			=   101546  --Spinning Crane Kick
_SpinningFireBlossom		=   115073  --Spinning Fire Blossom
_StanceOfTheFierceTiger		=   103985  --Stance of the Fierce Tiger
_SpearHandStrike			=   116705  --Spear Hand Strike
_TigereyeBrew				=   116740  --Tigereye Brew
_TigerPalm					=   100787  --Tiger Palm
_TouchOfDeath				=   115080  --Touch of Death
_TouchOfKarma 				=   122470  --Touch of Karma
_ZenPilgramage				=   126892  --Zen Pilgramage
_ZenSphere					=   124081  --Zen Sphere

------Buffs/Debuffs------
_DeathNote					=   121125 --Tracking Touch of Death Availability
_TigerPower					=   125359 --Tiger Power
_ComboBreakerTigerPalm		=   118864 --Combo Breaker: Tiger Palm
_ComboBreakerBlackoutKick	=   116768 --Combo Breaker: Blackout Kick
_ZenSphereBuff				=   124081 --Zen Sphere Buff
_TigereyeBrewStacks			=   125195 --Tigereye Brew Stacks
_DisableDebuff				=   116706 --Disable (root)

------Racials------
_GiftOfTheNaaru			 	=   59547   --Gift of the Naaru

_EnvelopingMist				=	124682;
_RenewingMist				=	115151;
_SerpentsZeal				=	127722;
_SoothingMist				=	115175;
_SurgingMist				=	116694;
_VitalMists 				=	118674;


		--[["TaMere","@CML.SoothingStops()"},]]

		-- Expel Harm
		--[["115072",{"ExpelHarm.novaHealing(0)"}},]]
		if chi < chiMax and getHP("player") <= getValue("Expel Harm") then
			if castSpell("player",_ExpelHarm, true) then return; end
		end

		-- Summon Jade Serpent Statue
		--[["115313","JadeSerpentStatue.pqikeybind","ground"},]]

		-- Detox
		--[["115450",{"Detox.maincheck","@CML.Dispel()"}},]]
		if isChecked("Detox") then
			if getValue("Detox") == 1 then -- Mouse Match
				if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
					for i = 1, #nNova do
						if nNova[i].guid == UnitGUID("mouseover") and nNova[i].dispel == true then
							if castSpell(nNova[i].unit,_Detox, true,false) then return; end
						end
					end		
				end		
			elseif getValue("Detox") == 2 then -- Raid Match
				for i = 1, #nNova do
					if nNova[i].dispel == true then
						if castSpell(nNova[i].unit,_Detox, true,false) then return; end
					end
				end
			elseif getValue("Detox") == 3 then -- Mouse All
				if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
				    for n = 1,40 do 
				      	local buff,_,_,count,bufftype,duration = UnitDebuff("mouseover", n)
			      		if buff then 
			        		if bufftype == "Magic" or bufftype == "Disease" or bufftype == "Poison" then 
			        			if castSpell("mouseover",_Detox, true,false) then return; end 
			        		end 
			      		else
			        		break;
			      		end   
				  	end
				end		
			elseif getValue("Detox") == 4 then -- Raid All
				for i = 1, #nNova do
				    for n = 1,40 do 
				      	local buff,_,_,count,bufftype,duration = UnitDebuff(nNova[i].unit, n)
			      		if buff then 
			        		if bufftype == "Magic" or bufftype == "Disease" or bufftype == "Poison" then 
			        			if castSpell(nNova[i].unit,_Detox, true,false) then return; end 
			        		end 
			      		else
			        		break;
			      		end 
				  	end
				end	
			end
		end

		--------------------------------------------------Cooldowns------------------------------------------------
		-- Invoke Xuen, the White Tiger
		--[["123904",{"InvokeXuen.coolHealing(MembersforCooldowns)"}},]]

		-- Revival
		--[["115310",{"Revival.coolHealing(MembersforCooldowns)"}},]]

		-- Spinning Crane Kick
		--[["101546",{"SpinningCraneKick.coolHealing(MembersforCooldowns)"}},]]


		--------------------------------------------------Healing Rotation-----------------------------------------
		-- Life Cocoon
		--[["116849",{"LifeCocoon.novaHealing(1)"}},]]

		-- Uplift
		--[["116670","@CML.Uplift()"},]]

		-- Renewing Mist
		--[["115151",{"@CML.ReMs()"}},]]
		--[["115151","player.chi < 5"},]]
		if isChecked("Renewing Mist") == true and canCast(_RenewingMist) == true then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Renewing Mist") then
					if castSpell(nNova[i].unit,_RenewingMist,true) then return; end
				end
			end
		end

		-- Mana Tea without Glyph of Mana Tea 
		--[["123761",{"@CML.IsGlyphed(123763,false)","123761.stopcasting","!player.moving","player.buff(115867).count >= 10","ManaTea.pqiMana(0)"}},]] 

		-- Mana Tea with Glyph of Mana Tea 
		--[["!123761",{"@CML.IsGlyphed(123763,true)","player.buff(115867).count >= 2","ManaTea.pqiMana(0)"}},]] 

		-- Chi Wave
		--[["115098",{"ChiWave.novaHealing(1)"}},]]
		if isChecked("Chi Wave") == true and canCast(_ChiWave) == true then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Chi Wave") then
					if castSpell(nNova[i].unit,_ChiWave,true) then return; end
				end
			end
		end		

		-- Surging Mist/Vital Mists
		--[["116694",{"player.buff(118674).count = 5","SurgingMist.novaHealing(1)"}},]] 

		-- Enveloping Mist
		--[["124682",{"@CML.EnvelopingMist()"}},]]
		if isChecked("Enveloping Mist") == true and isSoothing and chi >= 3 then
			if getHP("current") <= getValue("Enveloping Mist") then
				CastSpellByName(GetSpellInfo(124682))
				if castSpell("current", _EnvelopingMist, true, true) then return; end
			end
		end

		-- Surging Mist  
		--[["116694",{"@CML.SurgingMist()"}},]]  
		if isSoothing then
			if getHP("current") <= getValue("Surging Mist") then
				if castSpell("current", _SurgingMist, true) then return; end
			end
		end

		-- Soothing Mist
		--[["115175",{"115175.stopcasting","SoothingMist.novaHealing(1)"}},]]
		if isChecked("Soothing Mist") == true and canCast(_SoothingMist) == true and getMana("player") >= 12 then
			if isSoothing ~= true then
				for i = 1, #nNova do
					if nNova[i].hp <= getValue("Soothing Mist") then
						if castSpell(nNova[i].unit,_SoothingMist,true) then return; end
					end
				end
			else
				if getHP("current") >= 100 then
					SpellStopCasting(); return;
				end
			end
		end

		-- Legendary Meta Support
		--[["!108557",{"player.buff(137331)","108557.multiTarget","!modifier.last"}},]] -- Jab

		--[[ Mana Management]] 
		if targetDistance < 5 then
			-- Blackout Kick/Serpents Zeal
			if getBuffRemain("player",_SerpentsZeal) <= 3 and chi >= 2 then
				if castSpell("target",_BlackoutKick,false) then return; end
			end
			-- Tiger Palm/Vital Mists
			if getBuffRemain("player",_VitalMists) <= 3 and chi >= 1 then
				if castSpell("target",_TigerPalm,false) then return; end
			end
			-- Touch of Death
			if chi >= 3 and getBuffRemain("player",121125) > 0 then
				if castSpell("target",_TouchOfDeath,false) then return; end
			end
			-- Blackout Kick/Serpents Zeal
			if getBuffRemain("player",_SerpentsZeal) <= 15 and chi >= chiMax-2 then
				if castSpell("target",_BlackoutKick,false) then return; end
			end			
			-- Tiger Palm/Vital Mists
			if chi >= chiMax-1 then
				if castSpell("target",_TigerPalm,false) then return; end
			end			
			if castSpell("target",_Jab,false) then return; end
		end




		--[["115080",{"115080.multiTarget","player.buff(121125)"}},]]

		------------------------------------------------Multi target-----------------------------------------------
		-- Rushing Jade Wind  
		--[["116847",{"talent(16)","player.aoe != 1"}},]]

		-- Spinning Crane Kick    
		--[["101546","player.aoe != 1"},]]    

		-------------------------------------------------Mist------------------------------------------------------
		-- Blackout Kick/Max Chi and no Serpent's Zeal
		--[["100784",{"player.mode = 1","player.chi = 5","!player.buff(127722)","100784.multiTarget"}},]] 

		 -- Blackout Kick/Muscle Memory and no Serpent's Zeal
		--[["100784",{"player.mode = 1","player.chi >= 2","player.buff(139597)","!player.buff(127722)","100784.multiTarget"}},]]

		-- Jab/no Muscle Memory and no Serpent's Zeal
		--[["108557",{"player.mode = 1","player.chi < 5","!player.buff(139597)","!player.buff(127722)","108557.multiTarget"}},]] 

		-------------------------------------------------Fist------------------------------------------------------
		-- Blackout Kick/Max Chi and no Serpent's Zeal
		--[["100784",{"player.mode = 2","player.chi = 5","!player.buff(127722)","100784.multiTarget"}},]] 

		-- Blackout Kick/Muscle Memory and no Serpent's Zeal
		--[["100784",{"player.mode = 2","player.chi >= 2","player.buff(139597)","!player.buff(127722)","100784.multiTarget"}},]] 

		-- Blackout Kick/Max Chi and Muscle Memory and no Serpent's Zeal
		--[["100784",{"player.mode = 2","player.chi = 5","player.buff(139597)","!player.buff(127722)","100784.multiTarget"}},]] 

		-- Tiger Palm/Chi Dump
		--[["100787",{"player.mode = 2","player.chi = 5","100787.multiTarget"}},]] 

		-- Jab/no Muscle Memory
		--[["108557",{"player.mode = 2","player.chi < 5","!player.buff(127722)","108557.multiTarget"}},]] 

		-- Jab/no Serpent's Zeal
		--[["108557",{"player.mode = 2","player.chi < 5","!player.buff(139597)","108557.multiTarget"}},]] 
		-------------------------------------------------Light------------------------------------------------------

		-- Jab/no Chi
		--[["108557",{"player.mode = 3","player.chi < 1","player.buff(139597)","108557.multiTarget"}},]] 

		-- Blackout Kick/Muscle Memory
		--[["100784",{"player.mode = 3","player.chi >= 2","player.buff(139597)","100784.multiTarget"}},]] 

		-- Blackout Kick/no Serpent's Zeal
		--[["100784",{"player.mode = 3","player.chi >= 3","!player.buff(127722)","100784.multiTarget"}},]] 

		-- Tiger Palm/Muscle Memory
		--[["100787",{"player.mode = 3","player.chi >= 1","player.buff(139597)","100787.multiTarget"}},]]

		-- Tiger Palm/no Tiger Power
		--[["100787",{"player.mode = 3","player.chi >= 1","!player.buff(125359)","100787.multiTarget"}},]] 

		-- Crackling Jade Lightning/no Muscle Memory
		--[["117952",{"player.mode = 3","player.chi < 5","!player.buff(139597)","117952.multiTarget"}},]] 

		-- Crackling Jade Lightning/no Muscle Memory and no Lucidity
		--[["117952",{"player.mode = 3","player.chi < 5","!player.buff(137331)","!player.buff(139597)","!player.moving","player.mana > 15","117952.multiTarget"}},]] 

		-- Blackout Kick/Max Chi
		--[["100784",{"player.mode = 3","player.chi = 5","100784.multiTarget"}},]] 

		------------------------------------------------Out of Combat----------------------------------------------

		--[["TaMere","@CML.SoothingStops()"},]]
		-- Healing Sphere
		--[["115460",{"HealingSpheresKey.pqikeybind"},"ground"},]]
		-- Expel Harm
		--[["115072",{"ExpelHarm.novaHealing(0)"}},]]
		-- Fortifying Brew
		--[["115203",{"FortifyingBrew.novaHealing(0)"}},]]
		-- Healthstone   
		--[["#5512",{"@CML.HealthStone()","Healthstone.novaHealing(0)"}},]]
		-- Legacy of The Emperor               
		--[["115921",{"LegacyOfTheEmperor.pqivalue = 1","!player.hasaura(1)"},"player"},]]
		-- Summon Jade Serpent Statue
		--[["115313","JadeSerpentStatue.pqikeybind","ground"},]]
		-- Renewing Mist
		--[["115151","@CML.ReMs()"},]]
		-- Surging Mist/Vital Mists
		--[["116694",{"player.buff(118674).count = 5","SurgingMist.novaHealing(1)"},nil},]] -- need to check
		-- Uplift
		--[["116670","@CML.Uplift()"},]]
		-- Stance of the Jade Serpent
		--[["115070",{"player.seal != 1"}},]]
		-- Mana Tea without Glyph of Mana Tea 
		--[["123761",{"@CML.IsGlyphed(123763,false)","123761.stopcasting","!player.moving","player.buff(115867).count >= 10","ManaTea.pqiMana(0)"}},]] 
		-- Mana Tea with Glyph of Mana Tea 
		--[["123761",{"@CML.IsGlyphed(123763,true)","player.buff(115867).count >= 2","ManaTea.pqiMana(0)"}},]]





	--end

end



end

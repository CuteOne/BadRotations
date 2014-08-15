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
	local chi = UnitPower("player", SPELL_POWER_CHI);
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
	if isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then			
----------------------
--- Rotation Pause ---
----------------------
		if pause() then
			return true
		end



--[["TaMere","@CML.SoothingStops()"},]]

-- Expel Harm
--[["115072",{"ExpelHarm.novaHealing(0)"}},]]

-- Summon Jade Serpent Statue
--[["115313","JadeSerpentStatue.pqikeybind","ground"},]]

-- Detox
--[["115450",{"Detox.maincheck","@CML.Dispel()"}},]]


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

-- Mana Tea without Glyph of Mana Tea 
--[["123761",{"@CML.IsGlyphed(123763,false)","123761.stopcasting","!player.moving","player.buff(115867).count >= 10","ManaTea.pqiMana(0)"}},]] 

-- Mana Tea with Glyph of Mana Tea 
--[["!123761",{"@CML.IsGlyphed(123763,true)","player.buff(115867).count >= 2","ManaTea.pqiMana(0)"}},]] 

-- Chi Wave
--[["115098",{"ChiWave.novaHealing(1)"}},]]

-- Surging Mist/Vital Mists
--[["116694",{"player.buff(118674).count = 5","SurgingMist.novaHealing(1)"}},]] 

-- Enveloping Mist
--[["124682",{"@CML.EnvelopingMist()"}},]]

-- Surging Mist  
--[["116694",{"@CML.SurgingMist()"}},]]  

-- Soothing Mist
--[["115175",{"115175.stopcasting","SoothingMist.novaHealing(1)"}},]]

-- Legendary Meta Support
--[["!108557",{"player.buff(137331)","108557.multiTarget","!modifier.last"}},]] -- Jab

-- Mana Management
--[["!100784", {"player.buff(139597)","100784.multiTarget","player.aoe != 1"}},]] -- Blackout Kick/Muscle Memory

--[["!100787", {"player.buff(139597)","100787.multiTarget"}},]] -- Tiger Palm/Muscle Memory

-- Touch of Death
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





	end

end



end

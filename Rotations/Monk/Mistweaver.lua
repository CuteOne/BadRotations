if select(3,UnitClass("player")) == 10 then

  function MistweaverMonk()
    if HealingModesLoaded ~= "Mist Monk Healing Modes" then
      MonkMistToggles();
      MonkMistConfig();
    end
    --------------
    --- Locals ---
    --------------
    local isSoothing = UnitChannelInfo("player") == GetSpellInfo(_SoothingMist) or nil;
    local chi = UnitPower("player", SPELL_POWER_CHI);
    local chiMax = UnitPowerMax("player", SPELL_POWER_CHI)
    local energy = getPower("player");
    local myHP = getHP("player");
    local ennemyUnits = getNumEnemies("player", 5);
    local totUnits = 0;
    ------------------------
    --- Food/Invis Check ---
    ------------------------
    if canRun() ~= true or UnitInVehicle("Player") then return false; end
    if IsMounted("player") then return false; end
    if UnitBuffID("player", 80169) then return false; end -- Food
    if UnitBuffID("player", 87959) then return false; end -- Drink
    --------------------
    --- Ressurection ---
    --------------------
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
      -- Legacy of the Emperor
      if not UnitExists("mouseover") then
        for i = 1, #nNova do
          if (UnitInParty(nNova[i].unit) or UnitInRaid(nNova[i].unit) or UnitIsUnit("player",nNova[i].unit)) and UnitIsVisible(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{115921,20217,1126,90363}) then
            if castSpell("player",_LegacyOfTheEmperor,true) then return; end
          end
        end
      end
    end
    ------------------
    --- Defensives ---
    ------------------

    --Healthstone/Pot
    if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and inCombat then
      if canUse(5512) then
          useItem(5512)
      end
    end

    
    -- Fortifying Brew
    if getHP("player") <= getValue("Fortifying Brew") then
       if castSpell("player",_FortifyingBrew,true) then
        return;
      end
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
    --- Utility ---
    ---------------------
    -- Spear Hand Strike
    if isChecked("Spear Hand Strike") then
      for i=1, #getEnemies("player",5) do
        thisUnit = getEnemies("player",5)[i]
        if canInterrupt(thisUnit,getOptionValue("Spear Hand Strike")) then
          if castSpell(thisUnit,_SpearHandStrike,true) then return end
        end
      end
    end

    -- Paralysis
    if isChecked("Paralysis") then
      for i=1, #getEnemies("player",20) do
        thisUnit = getEnemies("player",20)[i]
        if canInterrupt(thisUnit,getOptionValue("Paralysis")) then
          if castSpell(thisUnit,_Paralysis,true) then return end
        end
      end
    end

    -----------------
    --- In Combat ---
    -----------------



    ----------------------
    --- Rotation Pause ---
    ----------------------
    -- Pause toggle
    if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then ChatOverlay("|cffFF0000BadBoy Paused", 0); return; end

    -- Summon Jade Serpent Statue
    --[["115313","JadeSerpentStatue.pqikeybind","ground"},]]
    if isChecked("Jade Serpent Statue (Left Shift)") and IsLeftShiftKeyDown() then
      if not IsMouselooking() then
        CastSpellByName(GetSpellInfo(115313))
        if SpellIsTargeting() then
          CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
          return true
        end
      end
    end

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
    -----------------
    --- Cooldowns ---
    -----------------
    --[[Invoke Xuen, the White Tiger]]

    --[[Revival]]
    local revivalUnits = 0
    if isChecked("Revival") then
      for i = 1, #nNova do
    	  if nNova[i].hp <= getValue("Revival") then
      	   	revivalUnits = revivalUnits + 1
      		  if revivalUnits >= getValue("Revival People") then
      			  if castSpell("player",_Revival,true) then
       			 	  revivalUnits = 0
      				  return;
      			  end
      		  end
      	  end
      end
    end
  

    --[[Life Cocoon]]
    if isInCombat("player") and isChecked("Life Cocoon") then
    	for i = 1, #nNova do
    		if nNova[i].hp <= getValue("Life Cocoon") then
    			if castSpell(nNova[i].unit,_LifeCocoon,true) then
    				return;
    			end
    		end
    	end
    end

    ------------------------
    --- Healing Rotation ---
    ------------------------
    -- Mana Tea with Glyph of Mana Tea
    --[["!123761",{"@CML.IsGlyphed(123763,true)","player.buff(115867).count >= 2","ManaTea.pqiMana(0)"}},]]

    if isChecked ("Mana Tea") then
      if hasGlyph(123763) then
        if getMana("player") <= getValue("Mana Tea") and getBuffStacks("player",115867) >= 2 then
          if castSpell("player",_ManaTea,true) then return; end
        end
      end
    end
    

    --[[Renewing Mist]]
    if getTalent(7,3) then
      if isChecked("Renewing Mist") and getCharges(_RenewingMist) > 0 then
        for i = 1, #nNova do
          if not UnitBuffID(nNova[i].unit, _RenewingMistBuff) then
            if castSpell("player",_ThunderFocusTea,true) then
            end
            if castSpell(nNova[i].unit,_RenewingMist,true) then return; end
          end
        end
      end
    elseif isChecked ("Renewing Mist") then
      for i = 1, #nNova do
        if not UnitBuffID(nNova[i].unit, _RenewingMistBuff) then
          if castSpell("player",_ThunderFocusTea,true) then
            if castSpell(nNova[i].unit,_RenewingMist,true) then return; end
          end
        end
      end
    end
  
    

     -- Chi Wave
    --[["115098",{"ChiWave.novaHealing(1)"}},]]
    if isChecked("Chi Wave") == true and getTalent(2,1) then
      for i = 1, #nNova do
        if nNova[i].hp <= getValue("Chi Wave") then
          if castSpell(nNova[i].unit,_ChiWave,true) then return; end
        end
      end
    end

    --[[Uplift]]
    local totUnits = 0
    if isChecked("Uplift") then
	   for i = 1, #nNova do
 		   if nNova[i].hp <= getValue("Uplift") and UnitBuffID(nNova[i].unit, 119611) then
  		   totUnits = totUnits + 1
  			 if totUnits >= getValue("Uplift People") then
  			    if chi < 2 and getCharges(_ChiBrew) > 0 then
  				   if castSpell("player",_ChiBrew,true) then
  			  	    if castSpell("player",_Uplift,true) then
  					 	 	  totUnits = 0
  					 	 	  return;
    					 	end
    					end
  	 			  elseif chi >= 2 then
  					  if castSpell("player",_Uplift,true) then
  						  totUnits = 0
  						  return;
  					  end
  				  end
  			  end
 		    end
	    end   
    end

    -- Spinning Crane Kick/Rushing Jade Wind
    local sckUnits = 0
    if isChecked("Spinning Crane Kick") then
      for i = 1, #nNova do
        if nNova[i].hp <= getValue("Spinning Crane Kick") and nNova[i].distance <= 8 then
          sckUnits = sckUnits + 1
          if sckUnits >= 3 then
            if getTalent(6,1) then
              if castSpell("player",_RushingJadeWind,true) then
                sckUnits = 0
                return;
              end
            else
              if castSpell("player",_SpinningCraneKick,true) then
                sckUnits = 0
                return;
              end
            end
          end
        end
      end
    end
    
    -- Surging Mist
    --[["116694",{"@CML.SurgingMist()"}},]]
    for i = 1, #nNova do
    	if nNova[i].hp <= getValue("Surging Mist") then
    		if isSoothing then
	        	if castSpell(nNova[i].unit, _SurgingMist, true) then 
	        		return; 
	        	end
	        else
	        	if castSpell(nNova[i].unit, _SoothingMist,true) then
	        		if castSpell(nNova[i].unit, _SurgingMist,true) then
	        			return;
	        		end
	        	end
	        end
	    end
	  end

    -- Enveloping Mist
    --[["124682",{"@CML.EnvelopingMist()"}},]]
    for i = 1, #nNova do
    	if isChecked("Enveloping Mist") == true and chi >= 3 then
      		if nNova[i].hp <= getValue("Enveloping Mist") then
      			if isSoothing then
	        		if castSpell(nNova[i].unit, _EnvelopingMist, true) then 
	        			return; 
	        		end
	        	else
	        		if castSpell(nNova[i].unit, _SoothingMist,true) then
	        			if castSpell(nNova[i].unit, _EnvelopingMist,true) then
	        				return;
	        			end
	        		end
	        	end
    	  	end
    	end
    end
   

    -- Soothing Mist
    --[["115175",{"115175.stopcasting","SoothingMist.novaHealing(1)"}},]]
    if isChecked("Soothing Mist") == true and canCast(_SoothingMist) == true and getMana("player") >= 12 then
      for i = 1, #nNova do
      	if isSoothing ~= true then
         	if nNova[i].hp <= getValue("Soothing Mist") then
	          if castSpell(nNova[i].unit,_SoothingMist,true) then return; end
         	end
       	end
      end
    end
        
    

    --Expel Harm party heal
	  for i = 1, #nNova do
    	if nNova[i].hp <= getValue("Expel Harm") then
      		if castSpell(nNova[i].unit,_MistExpelHarm, true) then return; end
    	end
    end

    

    --ChiGen
    if chi < 2 then
    	if castSpell("player",_MistExpelHarm,true) then 
    		return;
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

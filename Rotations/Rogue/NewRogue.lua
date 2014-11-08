if select(3, UnitClass("player")) == 4 then
	function NewRogue()
		if Currentconfig ~= "New Rogue CuteOne" then
	        NewRogueConfig();
	        Currentconfig = "New Rogue CuteOne";
	    end
	    local tarDist = getDistance("target")
	    if tarDist < 20 and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
	    	if not UnitBuffID("player",_Stealth) and not isInCombat("player") then
	    		if castSpell("player",_Stealth,true,false,false) then return; end
	    	end
	    	if getHP("player")<=50 and isInCombat("player") then
	    		if castSpell("player",_Evasion,true,false,false) then return; end
	    	end
	    	if UnitBuffID("player",_Stealth) and getPower("player")>60 and tarDist<5 then
	    		if castSpell("target",_Ambush,false,false,false) then return; end
	    	end
    		if getPower("player")>35 and (getCombo()==5 or (getTimeToDie("target")<3 and getCombo()>0)) and tarDist<5 then
    			if castSpell("target",_Eviscerate,false,false,false) then return; end
    		end
    		if getPower("player")>50 and (not UnitBuffID("player",_Stealth) and UnitLevel("player")>=6) and (getCombo()<5 or UnitLevel("player")<3) and tarDist<5 then
    			if castSpell("target",_SinisterStrike,false,false,false) then return; end
    		end
		end
	end
end
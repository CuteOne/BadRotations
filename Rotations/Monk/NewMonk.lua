if select(3, UnitClass("player")) == 10 then
	function NewMonk()
		if Currentconfig ~= "New Monk CuteOne" then
	        NewMonkConfig();
	        Currentconfig = "New Monk CuteOne";
	    end
	    if targetDistance < 3.5 and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
	    -- Blackout Kick
	    	if getChi("player")>1 and getBuffRemain("player",_TigerPower)>0 then
	    		if castSpell("target",_BlackoutKick) then return; end
	    	end
		--Tiger Palm
			if getChi("player")>0 then
				if UnitLevel("player")>=7 then 
					if getBuffRemain("player",_TigerPower)==0 then
						if castSpell("target",_TigerPalm) then return; end
					end
				else
					if castSpell("target",_TigerPalm) then return; end
				end
			end
		--Jab
			if getPower("player")>=40 and getChi("player")<4 then
				if castSpell("target",_Jab) then return; end
			end
		end
	end
end
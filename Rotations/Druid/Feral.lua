if select(3, UnitClass("player")) == 11 then
	function DruidFeral()
	    if Currentconfig ~= "Feral CuteOne" then
	        FeralCatConfig();
	        Currentconfig = "Feral CuteOne";
	    end
	    KeyToggles()
	    GroupInfo()
	    if UnitCastingInfo("target") then
	    	if not select(9,UnitCastingInfo("target")) then
	    		print(select(9,UnitCastingInfo("target")))
	    		ChatOverlay((select(6,UnitCastingInfo("target"))/1000) - GetTime())
	    	end
	    end
	    if not canRun() then
	    	return true
	    end
	    if feralBuffs() then
	    	return true
	    end
	    if feralForms() then
	    	return true
	    end
	    if feralDefensives() then
	    	return true
	    end
	    if feralInterrupts() then
	    	return true
	    end
	    if feralOpener() then
	    	return true
	    end
	    if feralCooldowns() then
	    	return true
	    end
	    if feralSingle() then
	    	return true
	    end
	end --Druid Function End
end --Class Check End
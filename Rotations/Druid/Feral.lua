if select(3, UnitClass("player")) == 11 then
	function DruidFeral()
	    if Currentconfig ~= "Feral CuteOne" then
	        FeralCatConfig();
	        Currentconfig = "Feral CuteOne";
	    end
	    KeyToggles()
	    GroupInfo()
	    if not canRun() then
	    	return true
	    end
	    feralBuffs()
	    feralForms()
	    feralDefensives()
	    feralOpener()
	    feralCooldowns()
	    feralSingle()
	end --Druid Function End
end --Class Check End
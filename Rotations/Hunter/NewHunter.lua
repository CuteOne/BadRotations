if select(3, UnitClass("player")) == 3 then
	function NewHunter()
		if Currentconfig ~= "New Hunter CuteOne" then
            Currentconfig = "New Hunter CuteOne";
        end
    ---===LOCALS===---
    	local arcaneShot 		= 3044
    	local callPet 			= 883
    	local concussiveShot 	= 5116
    	local distance 			= getDistance("target")
    	local mendPet 			= 136
    	local mending 			= UnitBuffID("pet",136)~=nil or false
    	local steadyShot 		= 56641
    	local petExists 		= UnitExists("pet")
    	local petHP 			= getHP("pet")
    	local power 			= getPower("player")

    ---===ROTATION===---
    	-- Call Pet
    	if not petExists then
    		if castSpell("player",callPet,false,false,false) then return end
    	end
    	-- Mend Pet
    	if petExists and petHP<50 and not mending then
    		if castSpell("pet",mendPet,false,false,false) then return end
    	end
    	if UnitExists("target") and canAttack("target","player") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("target","player") and not pause() then
    		if distance<40 then
    	-- Concussive Shot
    			if getSpellCD(concussiveShot)==0 then
    				if castSpell("target",concussiveShot,false,false,false) then return end
    			end
    	-- Arcane Shot
    			if power>30 then
    				if castSpell("target",arcaneShot,false,false,false) then return end
    			end
    	-- Steady Shot
    			if power<=30 then
    				if castSpell("target",steadyShot,false,false,false) then return end
    			end
    		end
    	end
	end
end
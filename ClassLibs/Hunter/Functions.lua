if select(3, UnitClass("player")) == 3 then
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]
--[[           ]]   --[[]]     --[[]]   --[[  ]]   --[[]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[  ]]   --[[]]
--[[]]              --[[]]     --[[]]   --[[    ]] --[[]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[    ]] --[[]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[           ]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[           ]]
--[[]]              --[[           ]]   --[[]]   --[[  ]]   --[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]   --[[]]   --[[  ]]
--[[]]              --[[           ]]   --[[]]     --[[]]   --[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]   --[[]]     --[[]]

--[[           ]]	--[[           ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	     --[[  ]]		--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[]]				    --[[    ]] 		--[[]]					 --[[ ]]
--[[         ]]		--[[           ]]	   --[[      ]] 	--[[           ]]		 --[[ ]]
--[[]]	   --[[]]	--[[]]				  --[[        ]]			   --[[]]		 --[[ ]]
--[[           ]]	--[[           ]]	 --[[]]    --[[]]	--[[           ]]		 --[[ ]]		
--[[           ]] 	--[[           ]]	--[[]]      --[[]]	--[[           ]]		 --[[ ]]

function AutoCallPet()
    if BadBoy_data["Check Auto Call Pet"] ~= 1 then 
        autoCallPetValue = 7; 
    else
    --if tryWhistle == nil then tryWhistle = 0; end
   --[[ if (not UnitExists("pet") or UnitIsDeadOrGhost("pet")) and tryWhistle <= GetTime() then
        if GetUnitSpeed("player") == 0 then
            tryWhistle = (GetTime()+3);
            autoCallPetValue = 0;
            return;
        end
    end]]
        if (not UnitExists("pet") or UnitIsDeadOrGhost("pet")) then
            if BadBoy_data["Box Auto Call Pet"] == 1 then
                autoCallPetValue = 1;
            elseif BadBoy_data["Box Auto Call Pet"] == 2 then
                autoCallPetValue = 2;
            elseif BadBoy_data["Box Auto Call Pet"] == 3 then
                autoCallPetValue = 3;
            elseif BadBoy_data["Box Auto Call Pet"] == 4 then
                autoCallPetValue = 4;
            elseif BadBoy_data["Box Auto Call Pet"] == 5 then
                autoCallPetValue = 5;
            end
        else
            autoCallPetValue = 6;
        end
    end
end

function Cooldowns()
    local bestialWrath = 19574;
    local rapidFire = 3045;
    local focusFire = 82692;
    local frenzyStacks = 19615;
    local killCommand = 34026;
    local beastWithin = 34471;
    -- Bestial Wrath
    if BadBoy_data["Check Bestial Wrath"] == 1
      and GetSpellCD(bestialWrath) < 1
      and GetSpellCD(killCommand) < 2
      and (BadBoy_data["Box Bestial Wrath"] and GetFocus() > BadBoy_data["Box Bestial Wrath"]) then
        cooldownValue = 1;
    -- Focus Fire
    elseif BadBoy_data["Check Focus Fire"] == 1
      and select(4,UnitBuffID("player",frenzyStacks)) == 5
      and not (UnitBuffID("player", beastWithin) and GetFocus() > 12)-- Not under Beast Within
      and GetSpellCD(killCommand) > 1 -- Kill Command CD over 1 sec
      and (GetSpellCD(bestialWrath) > 20 or BadBoy_data["Check Bestial Wrath"] == 0) -- Bestial Wrath CD over 20 sec
      and UnitBuffID("player", rapidFire) ~= true -- not under Rapid Fire
      and GetSpellCD(rapidFire) >= 5 then -- Rapid Fire CD over 5 sec
        cooldownValue = 2;
    else
        cooldownValue = 0;
    end
end

function Misdirection()
	if BadBoy_data["Box Misdirection"] ~= nil then local MisdirectionValue = BadBoy_data["Box Misdirection"]; end
	if BadBoy_data["Box Misdirection"] ~= 0 and UnitExists("target") and UnitIsUnit("player","target") ~= 1 then
		local MisdirectionTarget = nil
		if UnitExists("focus") and not UnitIsDeadOrGhost("focus") then
			MisdirectionTarget = "focus"
		elseif UnitExists("pet") and not UnitIsDeadOrGhost("pet") then
		    MisdirectionTarget = "pet"
		end	
	  	if UnitThreatSituation("player", "target") == 3 then
			if MisdirectionTarget ~= nil then
				if castSpell(MisdirectionTarget,_Misdirection) then return; end
			end
	  	end
	  	if UnitThreatSituation("player", "target") == 1 and MisdirectionValue == 2 then
			if MisdirectionTarget ~= nil then
				if castSpell(MisdirectionTarget,_Misdirection) then return; end
			end
	  	end
	  	if MisdirectionValue == 3 then
			if MisdirectionTarget ~= nil then
				if castSpell(MisdirectionTarget,_Misdirection) then return; end
			end
	  	end  	
	end
end

--[[]]     --[[]] 		  --[[]]		--[[           ]]	--[[]]	   --[[]]	--[[           ]]
--[[ ]]   --[[ ]] 		 --[[  ]] 		--[[           ]]	--[[]]	  --[[]]	--[[           ]]
--[[           ]] 	    --[[    ]]		--[[]]	   --[[]]	--[[        ]]		--[[]]
--[[           ]]	   --[[      ]] 	--[[           ]] 	--[[    ]] 			--[[           ]]
--[[]] 	   --[[]]	  --[[        ]]	--[[        ]]		--[[        ]]				   --[[]]
--[[]]	   --[[]]	 --[[]]    --[[]]	--[[]]	  --[[]]	--[[]]	  --[[]]	--[[           ]]
--[[]]	   --[[]]	--[[]]      --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]

--[[           ]] 	--[[]]	   --[[]]	--[[           ]]  	--[[]]	   --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]] 	--[[]]	   --[[]]
--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	 --[[]]	  --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]] 	 --[[]]	  --[[]]
	   	   --[[]]	--[[]]	   --[[]]	--[[        ]]		  --[[]] --[[]]
--[[           ]] 	--[[           ]] 	--[[]]	  --[[]]	  --[[       ]]
--[[           ]] 	--[[           ]] 	--[[]]	   --[[]]	   --[[     ]]








end

if select(3,UnitClass("player")) == 6 then
--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]

--[[           ]]	--[[]]				--[[           ]]	--[[           ]]	--[[        ]]
--[[           ]]	--[[]]				--[[           ]]	--[[           ]]	--[[         ]]
--[[]]	   --[[]]	--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]    --[[]]
--[[         ]]		--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]
--[[]]	   --[[]]	--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	  --[[]]
--[[           ]]	--[[]]				--[[           ]]	--[[           ]]	--[[         ]]
--[[           ]] 	--[[           ]]	--[[           ]]	--[[           ]]	--[[        ]]

if not DeathknightFunctions then
	DeathknightFunctions = true


    function canSpreadDiseases()
    	if canCast(_BloodBoil) and targetDistance < 8 and meleeEnemies > 2 and (runesBlood >= 1 or runesDeath >= 1) and (pestiTimer == nil or pestiTimer <= GetTime() - 1) and getDebuffRemains("target",55078,"player") >= 2 then
    		return true
    	end
    end


	function canTap()
		local RuneCount = 0
		for i = 1,6 do
			RuneCount = RuneCount + GetRuneCount(i)
		end
		if RuneCount < 3 then
			return true
		end
	end

	function petMove()
		if UnitExists("pet") then
			if UnitExists("mouseover") == 1 then
				PetAttack("mouseover")
				return false
			end
			if not GetCurrentKeyBoardFocus() then
				PetMoveTo()
				CameraOrSelectOrMoveStart()
				CameraOrSelectOrMoveStop()
			end
			return false
		end
	end

	function getRunes(Type)
		Type = string.lower(Type);
  		if Type == "frost" then
		  	local frostRunes = 0;
		  	for i = 5, 6 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 3 then
					frostRunes = frostRunes + 1;
				end
			end
		    return frostRunes;
  		elseif Type == "blood" then
		  	local bloodRunes = 0;
		  	for i = 1, 2 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 1 then
					bloodRunes = bloodRunes + 1;
				end
			end
		    return bloodRunes;
		elseif Type == "unholy" then
		  	local unholyRunes = 0;
		  	for i = 3, 4 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 2 then
					unholyRunes = unholyRunes + 1;
				end
			end
		    return unholyRunes;
		elseif Type == "death" then
		  	local deathRunes = 0;
		  	for i = 3, 6 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 4 then
					deathRunes = deathRunes + 1;
				end
			end
		    return deathRunes;
		end
		return 0;
	end
end

--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]	--[[           ]]
--[[]]	  			--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				     --[[ ]]
--[[         ]]		--[[         ]]	    --[[]]	   --[[]]	--[[           ]]		 --[[ ]]
--[[       	 ]]		--[[        ]]		--[[]]	   --[[]]			   --[[]]	 	 --[[ ]]
--[[]]				--[[]]	  --[[]]	--[[           ]]	--[[           ]]	 	 --[[ ]]
--[[]] 				--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[ ]]
function getmeleeEnemies()
    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
    meleeEnemies, ScanTimer = getNumEnemies("player",8), GetTime();
   -- print("MeleeEnemies:"..meleeEnemies);
    end
    return meleeEnemies;
end
function useAoE()
    if (BadBoy_data['AoE'] == 1 and getmeleeEnemies() >= 2) or BadBoy_data['AoE'] == 2 then
    -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end

--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]	 --[[         ]] 	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[]]	   --[[]]	--[[           ]] 	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[]]	   --[[]]	--[[           ]]	 --[[         ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]	--[[]]	   --[[]]	--[[]]			  		 --[[]]
--[[           ]]	--[[]]	 --[[  ]]	--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	 --[[         ]]	--[[           ]]		 --[[]]


















end
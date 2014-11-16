if select(3, UnitClass("player")) == 4 then
--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]

	  --[[]]		--[[           ]]	--[[           ]]		  --[[]]		--[[           ]]	--[[           ]]
     --[[  ]]		--[[           ]]	--[[           ]]	     --[[  ]]		--[[           ]]	--[[           ]]
    --[[    ]] 		--[[]]				--[[]]				    --[[    ]] 		--[[]]				--[[]]
   --[[      ]] 	--[[           ]]	--[[           ]]	   --[[      ]] 	--[[           ]]	--[[           ]]
  --[[        ]]			   --[[]]		 	   --[[]]	  --[[        ]]			   --[[]]		 	   --[[]]
 --[[]]    --[[]]	--[[           ]]	--[[           ]]	 --[[]]    --[[]]	--[[           ]]	--[[           ]]
--[[]]      --[[]]	--[[           ]]	--[[           ]] 	--[[]]      --[[]]	--[[           ]]	--[[           ]]


	function useCDs()
	    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
	        return true
	    else
	        return false
	    end
	end

	function useAoE()
	    if numEnemies == nil then numEnemies = 0 end
	    if not enemiesTimer or enemiesTimer <= GetTime() - 1 then
	        numEnemies, enemiesTimer = getNumEnemies("player",8), GetTime()
	    end
	    if (BadBoy_data['AoE'] == 1 and numEnemies >= 3) or BadBoy_data['AoE'] == 2 then
	        return true
	    else
	        return false
	    end
	end

	function useDefensive()
	    if BadBoy_data['Defensive'] == 1 then
	        return true
	    else
	        return false
	    end
	end

	function useInterrupts()
	    if BadBoy_data['Interrupts'] == 1 then
	        return true
	    else
	        return false
	    end
	end

	function canPP() --Pick Pocket Toggle State
		if BadBoy_data['Picker'] == 1 or BadBoy_data['Picker'] == 2 then
			return true
		else
			return false
		end
	end

	function noattack() --Pick Pocket Toggle State
		if BadBoy_data['Picker'] == 2 then
			return true
		else
			return false
		end
	end

	function isPicked()	--	Pick Pocket Testing
		if UnitExists("target") then
			if myTarget ~= UnitGUID("target") then
				canPickpocket = true
				myTarget = UnitGUID("target")
			end
		end
		if (canPickpocket == false or BadBoy_data['Picker'] == 3 or GetNumLootItems()>0) then
			return true
		else
			return false
		end
	end

	function getDistance2(Unit1,Unit2)
	    if Unit2 == nil then Unit2 = "player"; end
	    if UnitExists(Unit1) and UnitExists(Unit2) then
	        local X1,Y1,Z1 = ObjectPosition(Unit1);
	        local X2,Y2,Z2 = ObjectPosition(Unit2);
	        local unitSize = 0;
	        if UnitGUID(Unit1) ~= UnitGUID("player") and UnitCanAttack(Unit1,"player") then
	            unitSize = UnitCombatReach(Unit1);
	        elseif UnitGUID(Unit2) ~= UnitGUID("player") and UnitCanAttack(Unit2,"player") then
	            unitSize = UnitCombatReach(Unit2);
	        end
	        local distance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2))
	        if distance < max(5, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 4/3) then
	            return 4.9999
	        elseif distance < max(8, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 6.5) then
	            if distance-unitSize <= 5 then
	                return 5
	            else
	                return distance-unitSize
	            end
	        elseif distance-(unitSize+UnitCombatReach("player")) <= 8 then
	            return 8
	        else
	            return distance-(unitSize+UnitCombatReach("player"))
	        end
	    else
	        return 1000;
	    end
	end
--[[           ]] 	--[[           ]]	--[[]]     --[[]]	--[[           ]] 		  --[[]]		--[[           ]]
--[[           ]] 	--[[           ]]	--[[ ]]   --[[ ]]	--[[           ]] 	  	 --[[  ]] 		--[[           ]]
--[[]]				--[[]]	   --[[]]	--[[           ]]	--[[]]	   --[[]]	    --[[    ]]			 --[[ ]]
--[[]] 				--[[]]	   --[[]]	--[[           ]]	--[[         ]]	 	   --[[      ]] 		 --[[ ]]
--[[]]				--[[]]	   --[[]]	--[[]] 	   --[[]]	--[[]]	   --[[]]	  --[[        ]]		 --[[ ]]
--[[           ]] 	--[[           ]] 	--[[]] 	   --[[]]	--[[           ]] 	 --[[]]    --[[]]		 --[[ ]]
--[[           ]] 	--[[           ]] 	--[[]] 	   --[[]]	--[[           ]]	--[[]]      --[[]]		 --[[ ]]

--[[           ]] 	--[[]]	   --[[]]	--[[           ]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]]
--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[         ]]
	   	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]
--[[           ]] 	--[[           ]] 	--[[           ]]
--[[           ]] 	--[[           ]] 	--[[           ]]


end

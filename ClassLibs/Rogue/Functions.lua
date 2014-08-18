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
	function canRedirect()
		if cps == nil then
			cps = 0
		end
		if outcom then
			csp = 0
		end
		local ComboPoints = GetComboPoints("player", "target")
		if UnitExists("target") and ComboPoints ~= cps and cps~=0 then
	   		return true
		else
			return false
		end
	end

	function getRupr()	--Rupture Duration Tracking
		if UnitDebuffID("target",_Rupture,"player") then
			return (select(7, UnitDebuffID("target",_Rupture,"player")) - GetTime())
		else
			if UnitLevel("player") < 46 then
				return 99
			else
				return 0
			end
		end
	end

	function getEnvr()	
		if UnitBuffID("player",_Envenom) then
			return (select(7, UnitBuffID("player",_Envenom)) - GetTime())
		else
			if UnitLevel("player") < 20 then
				return 99
			else
				return 0
			end
		end
	end

	function getSndr()	
		if UnitBuffID("player",_SliceAndDice) then
			return (select(7, UnitBuffID("player",_SliceAndDice)) - GetTime())
		else
			if UnitLevel("player") < 14 then
				return 99
			else
				return 0
			end
		end
	end

	function getAntStack()	
		if UnitBuffID("player",_Anticipation) then
			return select(4,UnitBuffID("player",_Anticipation))
		else
			return 0
		end
	end

	function getVanr()	
		vstart, vduration = GetSpellCooldown(_Vanish)
		vancdr = vstart + vduration - GetTime()
		if UnitBuffID("player",_Vanish) or UnitBuffID("player",_VanishBuff) then
			if UnitBuffID("player",_Vanish) then
				return (select(7,UnitBuffID("player",_Vanish)) - GetTime())
			end
			if UnitBuffID("player",_VanishBuff) then
				return (select(7,UnitBuffID("player",_VanishBuff)) - GetTime())
			end
		else
			return 0
		end
	end

	function getVenr()	
		vens, vend = GetSpellCooldown(_Vendetta)
		vencdr = vens + vend - GetTime()
		if UnitDebuffID("target",_Vendetta,"player") then
			return (select(7, UnitDebuffID("target",_Vendetta,"player")) - GetTime())
		else
			return 0
		end
	end

	function getShbr()	
		if UnitBuffID("player",_ShadowBlades) then
			return (select(7, UnitBuffID("player",_ShadowBlades)) - GetTime())
		else
			return 0
		end
	end

	function getPow(value)
		if value == 110 then
			if (UnitPower("player") + (select(2, GetPowerRegen("player")) * (getRupr() - 2)) + 25) < value then
				return true
			else
				return false
			end
		elseif (UnitPower("player") + (select(2, GetPowerRegen("player")) * 1.5)) > value then
			return true
		else
			return false
		end
	end

	function useAoE()
	    if ((BadBoy_data['AoE'] == 1 and getNumEnnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2) and UnitLevel("player")>=46 then
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
		if canPickpocket == false or BadBoy_data['Picker'] == 3 or GetNumLootItems() > 0 then
			return true
		else
			return false
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

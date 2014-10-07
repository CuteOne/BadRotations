if select(3, UnitClass("player")) == 5 then

--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[]]	   --[[]]		  --[[]]		--[[]]	   			--[[]]
--[[]]	   --[[]]		  --[[]]		--[[           ]]	--[[]]
--[[]]	   --[[]]		  --[[]]				   --[[]]	--[[]]	  
--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[         ]] 	--[[           ]]	--[[           ]]	--[[           ]]

--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]	   
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]					 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]

--[[           ]]	--[[]]	   --[[]]		  --[[]]		--[[         ]]		--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[]]	   --[[]]	     --[[  ]]		--[[          ]]	--[[           ]]	--[[]] 	   --[[]]
--[[]]				--[[]]	   --[[]]	    --[[    ]] 		--[[]]	   --[[]]	--[[]]	   --[[]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[           ]]	   --[[      ]] 	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
		   --[[]] 	--[[]]	   --[[]] 	  --[[        ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	 --[[]]    --[[]]	--[[          ]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]      --[[]]	--[[         ]]		--[[           ]]	 --[[]]   --[[]]

--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]



-- is Casting VampiricTouch or MindBlast

--	function shadowCasting()
--		if isCastingSpell(_VampiricTouch) or isCastingSpell(_MindBlast) then
--			return false;
--		end
--	end

	-- Casting MindBlast or VampiricTouch -> return true
	function castingShadow()
		if isCastingSpell(_MindBlast)
		or isCastingSpell(_MindSpike)
		or isCastingSpell(_VampiricTouch)
		or isCastingSpell(_MindFlayI) then
			return true
		else
			return false
		end
	end

	-- Casting MindFlay -> return true
	function castingMF()
		if isCastingSpell(_MindFlay) then
			return true
		else 
			return false
		end
	end

	-- Casting MindFlayInsanity -> return true
	function castingMFI()
		if isCastingSpell(_MindFlayI) then
			return true
		else 
			return false
		end
	end

	-- Stopcasting MindFlay after next Tick
	function StopMFCasting()
		name, _, _, _, startTime, endTime = UnitChannelInfo("player");
		local spellsToCancel = {_MindFlay} -- this spells will be checked for cancelling 
				local CastTime;
				local CastTimeLeft;
				local TimePerTick;
				local MFPuffer;

		for i = 1 , #spellsToCancel do
			-- check if spell in table matches casted spell at the moment and the other restrictions
			if GetSpellInfo(spellsToCancel[i]) == name then
				
				-- maths
				CastTime = (endTime - startTime)/1000
				CastTimeLeft = (endTime/1000) - GetTime()
				TimePerTick = CastTime/3
				MFPuffer = 0.06;  -- Lag compensation, maybe have to be adjusted a litte bit depending on you latency

				-- -- Prints for Debug
				-- print("--- CastTime ---");
				-- print(CastTime);
				-- print("--- Cast Time Left ---")
				-- print(CastTimeLeft);
				-- print("--- Time per Tick ---");
				-- print(TimePerTick);
				-- print("--- MFPuffer ---");
				-- print(MFPuffer);
				-- print("=================================");

				-- -- Tick1
				-- if CastTimeLeft > CastTime and CastTimeLeft < 2*TimePerTick then
				-- 	print("--- Tick 1 ---");
				-- end

				-- -- Tick2
				-- if CastTimeLeft > TimePerTick and CastTimeLeft < 2* TimePerTick then
				-- 	if (CastTimeLeft - MFPuffer) < TimePerTick then
				-- 		print("--- Tick 2 ---");
				-- 		RunMacroText("/stopcasting");
				-- 		return;
				-- 	end
				-- end

				-- Tick3
				if CastTimeLeft - MFPuffer <= TimePerTick then
					print("--- Tick 3 reached. Stopcasting ---");
					RunMacroText("/stopcasting");
					return;
				end
			end
		end
	end
end

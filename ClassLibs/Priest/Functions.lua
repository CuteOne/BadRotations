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

	------------------------------------------
	-- Stopcasting MindFlay after next Tick --
	------------------------------------------
	-- function StopMFCasting()
	-- 	RunMacroText("/stopcasting")
	-- end

	function StopMFCasting()
		name, _, _, _, startTime, endTime, _, _ = UnitChannelInfo("player");
		local spellsToCancel = {_MindFlay} -- this spells will be checked for cancelling
				local CastTime;
				local CastTimeLeft;
				local TimePerTick;
				local MFPuffer;

				-- maths
				CastTime = (endTime - startTime)/1000
				CastTimeLeft = (endTime/1000) - GetTime()
				TimePerTick = CastTime/3
				MFPuffer = 0.00;  -- Lag compensation, maybe have to be adjusted a litte bit depending on you latency

		for i = 1 , #spellsToCancel do
			-- check if spell in table matches casted spell at the moment and the other restrictions
			if GetSpellInfo(spellsToCancel[i]) == name then

				-- maths


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
					--print("--- Tick 3 reached. Stopcasting ---");
					RunMacroText("/stopcasting");
					return;
				end
			end
		end
	end

	-------------------------------
	-- Bloodlust check by chumii --
	-------------------------------

	function hasLust()
	    if UnitBuffID("player",2825)        -- Bloodlust
	    or UnitBuffID("player",80353)       -- Timewarp
	    or UnitBuffID("player",32182)       -- Heroism
	    or UnitBuffID("player",90355) then  -- Ancient Hysteria
	        return true
	    else
	        return false
	    end
	end

	--------------------------
	-- GroupInfo by CuteOne --
	--------------------------
	function CalculateHP(unit)
		incomingheals = UnitGetIncomingHeals(unit) or 0
	 	return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
	end

	function GroupInfo()
		members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
		group.type = IsInRaid() and "raid" or "party"
		group.number = GetNumGroupMembers()
		if group.number > 0 then
			for i=1,group.number do
				if canHeal(group.type..i) then
					local unit, hp = group.type..i, CalculateHP(group.type..i)
					table.insert( members,{ Unit = unit, HP = hp } )
					if hp < 90 then
						group.low = group.low + 1
					end
					if UnitGroupRolesAssigned(unit) == "TANK" then
						table.insert(group.tanks,unit)
					end
				end
			end
        if group.type == "raid" and #members > 1 then table.remove(members,1) end
        table.sort(members, function(x,y) return x.HP < y.HP end)
        --local customtarget = canHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover"
        --if customtarget then table.sort(members, function(x) return UnitIsUnit(customtarget,x.Unit) end) end
    end


end
end

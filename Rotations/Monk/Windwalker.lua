if select(3, UnitClass("player")) == 10 then
	function WindwalkerMonk()
	    if Currentconfig ~= "Windwalker CuteOne" then
	        WindwalkerConfig();
	        Currentconfig = "Windwalker CuteOne";
	    end
	    if not canRun() then
	    	return true
	    end

---------------------------------------
--- Ressurection/Dispelling/Healing ---
---------------------------------------

-------------
--- Buffs ---
-------------

------------------
--- Defensives ---
------------------

---------------------
--- Out of Combat ---
---------------------
		if not isInCombat("player") then

		end

-----------------
--- In Combat ---
-----------------
		if isInCombat("player") then			
	
	----------------------
	--- Rotation Pause ---
	----------------------
			if pause() then
				return true
			end

	--------------------------------------------------
	--- In Combat - Dummy Test / Cat Form Maintain ---
	--------------------------------------------------
		-- Dummy Test
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then  
						StopAttack()
						ClearTarget()
						print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end

	------------------------------
	--- In Combat - Interrupts ---
	------------------------------

	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------

	-----------------------------------------
	--- In Combat - Multi-Target Rotation ---
	-----------------------------------------

	------------------------------------------
	--- In Combat - Single-Target Rotation ---
	------------------------------------------

		-- Start Attack
				if not UnitBuffID("player",prl) then
					StartAttack()
				end
		end --In Combat End	
	end
end
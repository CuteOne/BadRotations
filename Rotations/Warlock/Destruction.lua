if select(3, UnitClass("player")) == 9 then
	function WarlockDestruction()
	    if Currentconfig ~= "Destruction Cpoworks" then
	        DestructionConfig();

	        Currentconfig = "Destruction Cpoworks";
	    end
		DestructionToggles()
	    if not canRun() then
	    	return true
	    end

		if not IsMounted() then

			-- Dark Intent
			if getBuffRemain("player",_DarkIntent)<10  then
				if castSpell("player",_DarkIntent,true) then return; end
			end

			------------------
			--- Dummy Test ---
			------------------
			-- Dummy Test
			if BadBoy_data["Check DPS Testing"] == 1 then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						if castSpell("player",_TotemRecall,true) and hasTotem() then return; end
						StopAttack()
						ClearTarget()
						ChatOverlay(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end


			---------------------------
			--- Defensive Abilities ---
			---------------------------
			if not castingUnit("player") and isInCombat("player") then

			end



			------------------
			--- Interrupts ---
			------------------
			-- CS


			-----------------
			--- Cooldowns ---
			-----------------
			if useCDs() and targetDistance<40 and isInCombat("player") then


			end

			-------------
			--- Pause ---
			-------------
			if pause() then
				return true
			end

			-----------------------------
			--- Multi-Target Rotation ---
			-----------------------------
			if getNumEnemies("player",10) >= 3 and targetDistance<40 and useAoE() and isEnnemy("target") and isAlive("target") then



			end --Multi-Target Rotation End


			------------------------------
			--- Single Target Rotation ---
			------------------------------
			if getNumEnemies("player",8) < 3 and targetDistance<40 and not useAoE() and isEnnemy("target") and isAlive("target") then


			end --Single Target Rotation End



		end --IsMounted End
	end --Class Function End
end --Final End
function SubRogue()
	if select(3, UnitClass("player")) == 4 and GetSpecialization()==3 then
		if AoEModesLoaded ~= "Subtlety CuteOne/Starshine" then
			SubOptions();
			AoEModesLoaded = "Subtlety CuteOne/Starshine";
		end
		if not canRun() then
	    	return true
	    end
		SubToggles()
		poisonAssData()
		makeEnemiesTable(40)
-- --------------
-- --- Locals ---
-- --------------
	-- General Player Variables
		local profileStop = profileStop
		local lootDelay = getValue("LootDelay")
		local level = UnitLevel("player")
		local php = getHP("player")
		local power, powmax, powgen = getPower("player"), UnitPowerMax("player"), getRegen("player")
		local ttm = getTimeToMax("player")
		local enemies, enemiesList = #getEnemies("player",8), getEnemies("player",8)
		local falling, swimming = getFallTime(), IsSwimming()
		local oneHand, twoHand = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
	--General Target Variables
		local tarUnit = {
		["dyn0"] = "target", --No Dynamic
		["dyn5"] = dynamicTarget(5,true), --Melee
		['dyn8AoE'] = dynamicTarget(8,false), --Pick Pocket
		["dyn10"] = dynamicTarget(10,true), --Sap
		["dyn20AoE"] = dynamicTarget(20,false), --Stealth
		["dyn25AoE"] = dynamicTarget(25,false), --Shadowstep
		["dyn40AoE"] = dynamicTarget(40,false), --Cloak and Dagger
		}
		local tarDist = {
		["dyn0"] = getDistance("player",tarUnit.dyn0),
		["dyn5"] = getDistance("player",tarUnit.dyn5),
		["dyn8AoE"] = getDistance("player",tarUnit.dyn8AoE),
		["dyn10"] = getDistance("player",tarUnit.dyn10),
		["dyn20AoE"] = getDistance("player",tarUnit.dyn20AoE),
		["dyn25AoE"] = getDistance("player",tarUnit.dyn25AoE),
		["dyn40AoE"] = getDistance("player",tarUnit.dyn40AoE),
		}
		local hasMouse, deadMouse, playerMouse, mouseDist = ObjectExists("mouseover"), UnitIsDeadOrGhost("mouseover"), UnitIsPlayer("mouseover"), getDistance("player","mouseover") 
		local hastar, deadtar, attacktar, playertar = ObjectExists(tarUnit.dyn0), UnitIsDeadOrGhost(tarUnit.dyn0), UnitCanAttack(tarUnit.dyn0, "player"), UnitIsPlayer(tarUnit.dyn0)
		local friendly = UnitIsFriend(tarUnit.dyn0, "player")
		local thp = getHP(tarUnit.dyn5)
		local ttd = getTimeToDie(tarUnit.dyn5)
		local enemies = #getEnemies("player",8)
	--Specific Player Variables
 		local combo = getCombo()
 		local sdRemain =  getBuffRemain("player",_ShadowDance,"player")
 		local subRemain = getBuffRemain("player",_Subterfuge,"player")
 	--Specific Target Variables
 		local findweak 


 	-- Profile Stop
		if isInCombat("player") and profileStop==true then
			return true
		else
			profileStop=false
		end
----------------------------------
--- Poisons/Healing/Dispelling ---
----------------------------------


	-- Pause
		if pause() then
			return true
		else
-------------
--- Buffs ---
-------------

------------------
--- Defensives ---
------------------

---------------------
--- Out of Combat ---
---------------------

-----------------
--- In Combat ---
-----------------

	------------------------------
	--- In Combat - Dummy Test ---
	------------------------------
	
	------------------------------
	--- In Combat - Interrupts ---
	------------------------------
	castInterrupt(_Kick,75)
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
	-- premedatation 
	--if=combo_points<=4&!(buff.shadow_dance.up&energy>100&combo_points>1)&!buff.subterfuge.up|(buff.subterfuge.up&debuff.find_weakness.up)
	--if combo <=4 and not (sdRemain>0 and power>100 and combo>1) and subRemain ==0 or (subRemain>0 and )
	------------------------------------------
	--- In Combat Rotation ---
	------------------------------------------

		end -- Pause End
	end --Rogue Function End
end --Class Check End



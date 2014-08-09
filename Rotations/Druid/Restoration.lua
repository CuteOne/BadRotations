if select(3, UnitClass("player")) == 11 then
function DruidRestoration()
	if currentConfig ~= "Restoration Masou" then
		RestorationConfig();
		RestorationToggles();
		currentConfig = "Restoration Masou";
	end

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end

--[[ 	-- On GCD After here, palce out of combats spells here
]]

	if isCasting() then return false; end

	-- Barkskin if < 30%
	if isChecked("Barkskin") and getHP("player") <= getValue("Barkskin") then
		if castSpell("player",_Barkskin,true) then return; end
	end


--[[ 	-- Combats Starts Here
]]

	if isInCombat("player") then

		--if isAlive() and (isEnnemy() or isDummy("target")) and getLineOfSight("player","target") == true and getFacing("player","target") == true then

		-- Lifebloom
		if isChecked("Lifebloom") then
			if getHP("focus") <= getValue("Lifebloom") and (getBuffRemain("focus",33763) < 4 or getBuffStacks("focus",33763) < 3) then
				if castSpell("focus",33763,true) then return; end
			end
		end		

 		-- Healing Touch via Sage Mender
 		local SMName, _, _, SMcount, _, _, SMexpirationTime = UnitBuffID("player", 144871) --Sage Mender - 2p bonus tier 16  
		if SMName and  SMcount >= 5   then
			if isChecked("Healing Touch") and nNova[1].hp <= getValue("Healing Touch") then
				if castSpell(nNova[1].unit,5185,true) then return; end
			end
		end

		-- Swiftmend
		local allies10Yards;
		if getBuffRemain(nNova[1].unit,774) > 1 or getBuffRemain(nNova[1].unit,8936) > 1 then
			allies10Yards = getAllies(nNova[1].unit,10)
			if #allies10Yards >= 3 then
				local count = 0;
				for i = 1, #allies10Yards do
					if getHP(allies10Yards[i]) < 90 then
						count = count + 1
					end
				end
				if count > 3 then
					if castSpell(nNova[1].unit,18562,true) then return; end
				end
			end
		end

 		-- Rejuvenation
		if isChecked("Rejuvenation") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Rejuvenation") and getBuffRemain(nNova[i].unit,774) < 2 then
					if castSpell(nNova[i].unit,774,true) then return; end
				end
			end
		end

 		-- Regrowth
		if isChecked("Regrowth") then
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Regrowth") and getBuffRemain(nNova[i].unit,8936) < 3 then
					if castSpell(nNova[i].unit,8936,true) then return; end
				end
			end
		end





		--end
	end
end
end
if select(3,UnitClass("player")) == 6 then

	function canTap()
		local RuneCount = 0
		for i = 1, 6 do
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
		Type = string.lower(Type)
  		if Type == "frost" then
		  	local frostRunes = 0
		  	for i = 5, 6 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 3 then
					frostRunes = frostRunes + 1
				end
			end
		    return frostRunes
  		elseif Type == "blood" then
		  	local bloodRunes = 0
		  	for i = 1, 2 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 1 then
					bloodRunes = bloodRunes + 1
				end
			end
		    return bloodRunes
		elseif Type == "unholy" then
		  	local unholyRunes = 0
		  	for i = 3, 4 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 2 then
					unholyRunes = unholyRunes + 1
				end
			end
		    return unholyRunes;
		elseif Type == "death" then
		  	local deathRunes = 0
		  	for i = 3, 6 do
		  		if select(3, GetRuneCooldown(i)) and GetRuneType(i) == 4 then
					deathRunes = deathRunes + 1
				end
			end
		    return deathRunes
		end
		return 0
	end
end
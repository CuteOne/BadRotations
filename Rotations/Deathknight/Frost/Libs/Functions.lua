if select(3,UnitClass("player")) == 6 then

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

	function getDeath()
		local rune1 = select(3, GetRuneCooldown(1))
		local rune2 = select(3, GetRuneCooldown(2))
		if rune1 and rune2 then
			return 2
		end
		if (rune1 and not rune2) or (rune2 and not rune1) then
			return 1
		end
		if not rune1 and not rune2 then
			return 0
		end
	end

	function getFrost()
		local rune3 = select(3, GetRuneCooldown(3))
		local rune4 = select(3, GetRuneCooldown(4))
		if rune3 and rune4 then
			return 2
		end
		if (rune3 and not rune4) or (rune4 and not rune3) then
			return 1
		end
		if not rune3 and not rune4 then
			return 0
		end
	end

	function getUnholy()
		local rune5 = select(3, GetRuneCooldown(5))
		local rune6 = select(3, GetRuneCooldown(6))
		if rune5 and rune6 then
			return 2
		end
		if (rune5 and not rune6) or (rune6 and not rune5) then
			return 1
		end
		if not rune5 and not rune6 then
			return 0
		end
	end

	function getRunes(Type)
		Type = string.lower(Type)
		local bloodRunes = 0
		local unholyRunes = 0
		local frostRunes = 0
		local deathRunes = 0
		for i = 1, 6 do
			if select(3, GetRuneCooldown(i)) then
				if GetRuneType(i) == 4 then
					print("Death Runes!")
					deathRunes = deathRunes + 1
				end
				if GetRuneType(i) == 1 then
					bloodRunes = bloodRunes + 1
				end
				if GetRuneType(i) == 2 then
					frostRunes = frostRunes + 1
				end
				if GetRuneType(i) == 3 then
					unholyRunes = unholyRunes + 1
				end
			end
		end
  		if Type == "blood" then
		    return bloodRunes
		end
		if Type == "unholy" then
		    return unholyRunes
		end
		if Type == "frost" then
		    return frostRunes
		end
		if Type == "death" then
			--print("Returning Count")
		    return deathRunes
		end
		return 0
	end

    function useAoE()
        if (BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 2) or BadBoy_data['AoE'] == 2 then
        -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
            return true
        else
            return false
        end
    end
end
if select(3, UnitClass("player")) == 3 then

function TargetValid(target)
	if UnitExists(target) ~= nil then
		if UnitIsDeadOrGhost(target) == nil then
			if UnitCanAttack("player",target) == 1 then
				if isInCombat(target) ~= nil then
					if IsSpellInRange(GetSpellInfo(SerpentSting),target) == 1 then
						return true
					end
				end
			end
		end
	end
	return false
end

end























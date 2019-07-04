function canFly()
	local hasDraenorFly = select(4,GetAchievementInfo(10018))
	local hasLegionFly = select(4,GetAchievementInfo(11446))
	return IsOutdoors() and IsFlyableArea() and ((not isInDraenor() and not isInLegion()) or (hasDraenorFly and isInDraenor()) or (hasLegionFly and isInLegion()))
end

-- if canHeal("target") then
function canHeal(Unit)
	if GetUnitExists(Unit) and UnitInRange(Unit) == true and UnitCanCooperate("player",Unit)
		and not UnitIsEnemy("player",Unit) and not UnitIsCharmed(Unit) and not UnitIsDeadOrGhost(Unit)
		and getLineOfSight(Unit) == true and not UnitDebuffID(Unit,33786) then
		return true
	end
	return false
end

-- if canRun() then
function canRun()
	if getOptionCheck("Pause") ~= 1 then
		if isAlive("player") then
			if SpellIsTargeting()
				--or UnitInVehicle("Player")
				or (IsMounted() and not UnitBuffID("player",164222) and not UnitBuffID("player",165803) and not UnitBuffID("player",157059) and not UnitBuffID("player",157060))
				or UnitBuffID("player",11392) ~= nil
				or UnitBuffID("player",80169) ~= nil
				or UnitBuffID("player",87959) ~= nil
				or UnitBuffID("player",104934) ~= nil
				or UnitBuffID("player",9265) ~= nil then -- Deep Sleep(SM)
				return nil
			else
				if GetObjectExists("target") then
					if GetObjectID("target") ~= 5687 then
						return nil
					end
				end
				return true
			end
		end
	else
		ChatOverlay("|cffFF0000-BadRotations Paused-")
		return false
	end
end
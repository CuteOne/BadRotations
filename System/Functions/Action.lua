local _, br = ...
function br.canFly()
	return _G.IsOutdoors() and _G.IsFlyableArea()
end

-- if canHeal("target") then
function br.canHeal(Unit)
	if
		br.GetUnitExists(Unit) and br._G.UnitInRange(Unit) == true and br._G.UnitCanCooperate("player", Unit) and not br._G.UnitIsEnemy("player", Unit) and not br._G.UnitIsCharmed(Unit) and
			not br.GetUnitIsDeadOrGhost(Unit) and
			br.getLineOfSight(Unit) == true and
			not br.UnitDebuffID(Unit, 33786)
	 then
		return true
	end
	return false
end

-- if br.canRun() then
function br.canRun()
	if br.getOptionCheck("Pause") ~= 1 then
		if br.isAlive("player") then
			if
				_G.SpellIsTargeting() or --or UnitInVehicle("Player")
					(_G.IsMounted() and not br.UnitBuffID("player", 164222) and not br.UnitBuffID("player", 165803) and not br.UnitBuffID("player", 157059) and not br.UnitBuffID("player", 157060)) or
					br.UnitBuffID("player", 11392) ~= nil or
					br.UnitBuffID("player", 80169) ~= nil or
					br.UnitBuffID("player", 87959) ~= nil or
					br.UnitBuffID("player", 104934) ~= nil or
					br.UnitBuffID("player", 9265) ~= nil
			 then -- Deep Sleep(SM)
				return nil
			else
				if br.GetObjectExists("target") then
					if br.GetObjectID("target") ~= 5687 then
						return nil
					end
				end
				return true
			end
		end
	else
		br.ChatOverlay("|cffFF0000-BadRotations Paused-")
		return false
	end
end

local _, br = ...
br.functions.action = br.functions.action or {}
local action = br.functions.action
local aura = br.functions.aura
local misc = br.functions.misc

function action:canFly()
	return br._G.IsOutdoors() and br._G.IsFlyableArea()
end

-- if br.functions.action:canHeal("target") then
function action:canHeal(Unit)
	if
		br.functions.unit:GetUnitExists(Unit) and br._G.UnitInRange(Unit) == true and br._G.UnitCanCooperate("player", Unit) and not br._G.UnitIsEnemy("player", Unit) and not br._G.UnitIsCharmed(Unit) and
			not br.functions.unit:GetUnitIsDeadOrGhost(Unit) and
			misc:getLineOfSight(Unit) == true and
			not aura:UnitDebuffID(Unit, 33786)
	 then
		return true
	end
	return false
end

-- if br.functions.action:canRun() then
function action:canRun()
	if misc:getOptionCheck("Pause") ~= 1 then
		if br.functions.unit:isAlive("player") then
			if
				br._G.SpellIsTargeting() or --or UnitInVehicle("Player")
					(br._G.IsMounted() and not aura:UnitBuffID("player", 164222) and not aura:UnitBuffID("player", 165803) and not aura:UnitBuffID("player", 157059) and not aura:UnitBuffID("player", 157060)) or
					aura:UnitBuffID("player", 11392) ~= nil or
					aura:UnitBuffID("player", 80169) ~= nil or
					aura:UnitBuffID("player", 87959) ~= nil or
					aura:UnitBuffID("player", 104934) ~= nil or
					aura:UnitBuffID("player", 9265) ~= nil
			 then -- Deep Sleep(SM)
				return nil
			else
				if br.functions.unit:GetObjectExists("target") then
					if br.functions.unit:GetObjectID("target") ~= 5687 then
						return nil
					end
				end
				return true
			end
		end
	else
		br.ui.chatOverlay:Show("|cffFF0000-BadRotations Paused-")
		return false
	end
end

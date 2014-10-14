if select(3,UnitClass("player")) == 10 then

--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]



--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]
--[[           ]]	--[[           ]]	--[[           ]]	--[[]] 	   --[[]]	
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				--[[ ]]   --[[ ]]
--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[        ]]		--[[]]				--[[           ]]
--[[           ]]	--[[]]	  --[[]]	--[[           ]]	--[[ ]]   --[[ ]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	 --[[]]   --[[]]

--[[]]     --[[]]	--[[           ]]	--[[           ]]	--[[           ]]
--[[ ]]   --[[ ]] 		 --[[ ]]		--[[           ]]	--[[           ]]
--[[           ]] 		 --[[ ]]		--[[]]	   				 --[[ ]]
--[[           ]]		 --[[ ]]		--[[           ]]		 --[[ ]]
--[[]] 	   --[[]]		 --[[ ]]				   --[[]]		 --[[ ]]
--[[]]	   --[[]]		 --[[ ]]		--[[           ]]		 --[[ ]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[ ]]

--[[]] 	   --[[]]	--[[           ]]	--[[]]	   --[[]]	--[[         ]]
--[[]] 	   --[[]]		  --[[]]		--[[  ]]   --[[]]	--[[          ]]
--[[ ]]   --[[ ]]		  --[[]]		--[[    ]] --[[]]	--[[]]	   --[[]]
--[[           ]]		  --[[]]		--[[           ]]	--[[]]	   --[[]]
--[[           ]]		  --[[]]		--[[   		   ]]	--[[]]	   --[[]]
--[[ ]]   --[[ ]]		  --[[]]		--[[]]	 --[[  ]]	--[[          ]]
 --[[]]   --[[]]	--[[           ]]	--[[]]	   --[[]]	--[[         ]]

------Member Check------
function CalculateHP(unit)
  incomingheals = UnitGetIncomingHeals(unit) or 0
  return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
end

function GroupInfo()
    members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }      
    group.type = IsInRaid() and "raid" or "party" 
    group.number = GetNumGroupMembers()
    if group.number > 0 then
        for i=1,group.number do 
            if canHeal(group.type..i) then 
                local unit, hp = group.type..i, CalculateHP(group.type..i) 
                table.insert( members,{ Unit = unit, HP = hp } ) 
                if hp < 90 then group.low = group.low + 1 end 
                if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end 
            end 
        end 
        if group.type == "raid" and #members > 1 then table.remove(members,1) end 
        table.sort(members, function(x,y) return x.HP < y.HP end)
        --local customtarget = canHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover" 
        --if customtarget then table.sort(members, function(x) return UnitIsUnit(customtarget,x.Unit) end) end 
    end
end

------Tracking------
-- Raising Sun Kick Debuff Remain
function getRSR()
	if UnitDebuffID("target",_RaisingSunKick,"player") then
		return (select(7, UnitDebuffID("target",_RaisingSunKick,"player")) - GetTime())
	else
		if UnitLevel("player")>=56 then
			if getSpellCD(_RaisingSunKick)~=0 then
				return 999
			else
				return 0
			end
		else
			return 999
		end
	end
end
-- Raising Sun Kick Cooldown
function getRSRCD()
	if UnitLevel("player")<56 then
		return 8
	else
		return getSpellCD(_RaisingSunKick)
	end
end
-- Fists of Fury Haste
function getFistsOfFuryHaste()
	return (4 / (1 + UnitSpellHaste("player") / 100))
end

function useAoE()
    if ((BadBoy_data['AoE'] == 1 and getNumEnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2) and UnitLevel("player")>=46 then
        return true
    else
        return false
    end
end

function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
end

function getFacingDistance()
    if IExists(UnitGUID("player")) and IExists(UnitGUID("target")) then
        local Y1,X1,Z1,Angle1 = IGetLocation(UnitGUID("player"));
        local Y2,X2 = IGetLocation(UnitGUID("target"));
        local deltaY = Y2 - Y1
        local deltaX = X2 - X1
        Angle1 = math.deg(math.abs(Angle1-math.pi*2))
        if deltaX > 0 then
            Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
        elseif deltaX <0 then
            Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
        end
        return round2(math.tan(math.abs(Angle2 - Angle1)*math.pi/180)*targetDistance*10000)/10000
    else
        return 1000
    end
end

function canFSK(unit)
    if ((targetDistance <= 8 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 8 and getFacing("player",unit))) 
        and not hasGlyph(1017) 
        and getSpellCD(_FlyingSerpentKick)==0 
        and getFacingDistance() <= 7
        and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" 
        and not UnitIsDeadOrGhost(unit)
        and getTimeToDie(unit) > 2
        and not IsSwimming()
    then
        return true
    else
        return false
    end
end

function getTigereyeRemain()
    if getBuffStacks("player",_TigereyeBrew) > 0 then
        return 0
    else
        return getBuffRemain("player",_TigereyeBrew)
    end
end

end
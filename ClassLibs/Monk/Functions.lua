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

function StaggerValue()
    local staggerLight, _, iconLight, _, _, remainingLight, _, _, _, _, _, _, _, _, _, valueStaggerLight, _ = UnitAura("player", GetSpellInfo(124275), "", "HARMFUL")
    local staggerModerate, _, iconModerate, _, _, remainingModerate, _, _, _, _, _, _, _, _, _, valueStaggerModerate, _ = UnitAura("player", GetSpellInfo(124274), "", "HARMFUL")
    local staggerHeavy, _, iconHeavy, _, _, remainingHeavy, _, _, _, _, _, _, _, _, _, valueStaggerHeavy, _ = UnitAura("player", GetSpellInfo(124273), "", "HARMFUL")
    local staggerTotal= (valueStaggerLight or valueStaggerModerate or valueStaggerHeavy or 0)
    local percentOfHealth=(100/UnitHealthMax("player")*staggerTotal)
    local ticksTotal=(valueStaggerLight or valueStaggerLight or valueStaggerLight or 0)
    return percentOfHealth;
end

function DrinkStagger()
    if UnitDebuff("player", GetSpellInfo(124273)) then --Heavy Stagger
        return true
    end
    if UnitDebuff("player", GetSpellInfo(124274)) and StaggerValue() > 25 then --Moderate Stagger and Staggervalue > 25% HP
        return true
    end
    -- else
    --     return false
    -- end
end

function useCDsBrM()
    if (BadBoy_data['Cooldowns'] == 1 and (isBoss("target") or isDummy("target"))) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
end

function useDefCDsBrM()
    if BadBoy_data['Defensive'] == 1 then
        return true
    else
        return false
    end
end

function getmeleeEnemiesBrM()
    if ScanTimer == nil or ScanTimer <= GetTime() - 1 then
    meleeEnemies, ScanTimer = getNumEnemies("player",8), GetTime();
   -- print("MeleeEnemies:"..meleeEnemies);
    end
    return meleeEnemies;
end

function useAoEBrM()
    if BadBoy_data['AoE'] == 1 and getmeleeEnemiesBrM() >= 3 then
    -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end

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

function sefTargets()
    if enemies == nil then enemies = 0 end
    if not myenemiesTimer or myenemiesTimer <= GetTime() - 1 then
        enemies, myenemiesTimer = getEnemies("player",40), GetTime()
    end
    if currtar == nil then
        currtar = UnitGUID("player")
    elseif UnitExists("target") then
        currtar = UnitGUID("target")
    end
    targets = {}
    for i=1,#enemies do
        if UnitExists(enemies[i])
            and getCreatureType(enemies[i])
            and UnitCanAttack("player",enemies[i])
            and not UnitIsDeadOrGhost(enemies[i])
            and (isInCombat(enemies[i]) or isDummy(enemies[i]) or isChecked("Death Monk Mode"))
            and UnitGUID(enemies[i])~=currtar
        then
            table.insert( targets,{ Name = UnitName(enemies[i]), Unit = enemies[i], HP = UnitHealth(enemies[i]), Range = getDistance("player",enemies[i]) })
        end
    end
    table.sort(targets, function(x,y) return x.HP > y.HP end)
    -- if #targets > 2 then
    --     for i=1,#targets do
    --         if i>2 then table.remove(targets,i) end
    --     end
    -- end
end

function getDistance2(Unit1,Unit2)
    if Unit2 == nil then Unit2 = "player"; end
    if UnitExists(Unit1) and UnitExists(Unit2) then
        local X1,Y1,Z1 = ObjectPosition(Unit1);
        local X2,Y2,Z2 = ObjectPosition(Unit2);
        local unitSize = 0;
        if UnitGUID(Unit1) ~= UnitGUID("player") and UnitCanAttack(Unit1,"player") then
            unitSize = UnitCombatReach(Unit1);
        elseif UnitGUID(Unit2) ~= UnitGUID("player") and UnitCanAttack(Unit2,"player") then
            unitSize = UnitCombatReach(Unit2);
        end
        local distance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2))
        if distance < max(5, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 4/3) then
            return 4.9999
        elseif distance < max(8, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 6.5) then
            if distance-unitSize <= 5 then
                return 5
            else
                return distance-unitSize
            end
        elseif distance-(unitSize+UnitCombatReach("player")) <= 8 then
            return 8
        else
            return distance-(unitSize+UnitCombatReach("player"))
        end
    else
        return 1000;
    end
end
-- -- if getEnemiesTable("target",10) >= 3 then
-- function getEnemiesTable(Unit,Radius)
--     local enemiesTable = {};
--     if UnitExists("target") == true and getCreatureType("target") == true then
--         if UnitCanAttack("player","target") == true and UnitIsDeadOrGhost("target") == false then
--             local myDistance = getDistance("player","target")
--             if myDistance <= Radius then
--                 table.insert(enemiesTable, { unit = "target" , range = myDistance });
--             end
--         end
--     end
--     for i=1,ObjectCount() do
--         if bit.band(ObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
--             local thisUnit = ObjectWithIndex(i);
--             if UnitGUID(thisUnit) ~= UnitGUID("target") and getCreatureType(thisUnit) == true then
--                 if UnitCanAttack("player",thisUnit) == true and UnitIsDeadOrGhost(thisUnit) == false then
--                     local myDistance = getDistance("player",thisUnit)
--                     if myDistance <= Radius then
--                         table.insert({ unit = thisUnit , range = myDistance });
--                     end
--                 end
--             end
--         end
--     end
--     return enemiesTable;
-- end

function useAoE()
    if myEnemies == nil then myEnemies = 0 end
    if not enemiesTimer or enemiesTimer <= GetTime() - 1 then
        myEnemies, enemiesTimer = getEnemies("player",8), GetTime()
    end
    if ((BadBoy_data['AoE'] == 1 and #myEnemies >= 3) or BadBoy_data['AoE'] == 2) and UnitLevel("player")>=46 then
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

function useDefensive()
    if BadBoy_data['Defensive'] == 1 then
        return true
    else
        return false
    end
end

function useInterrupts()
    if BadBoy_data['Interrupts'] == 1 then
        return true
    else
        return false
    end
end

function getFacingDistance()
    if UnitIsVisible("player") and UnitIsVisible("target") then
        local Y1,X1,Z1 = ObjectPosition("player");
        local Y2,X2,Z2 = ObjectPosition("target");
        local Angle1 = ObjectFacing("player")
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
    if ((targetDistance <= 8 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5 and getFacing("player",unit)))
        and not hasGlyph(1017)
        and getSpellCD(_FlyingSerpentKick)==0
        and getFacingDistance() < 5
        and select(3,GetSpellInfo(_FlyingSerpentKick)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green"
        and not UnitIsDeadOrGhost(unit)
        and getTimeToDie(unit) > 2
        and not IsSwimming()
    then
        return true
    else
        return false
    end
end

function canContFSK(unit)
    if ((targetDistance <= 8 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5 and getFacing("player",unit)))
        and not hasGlyph(1017)
        and getFacingDistance() < 5
        and not UnitIsDeadOrGhost(unit)
        and getTimeToDie(unit) > 2
        and not IsSwimming()
    then
        return true
    else
        return false
    end
end

end
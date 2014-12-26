if select(3,UnitClass("player")) == 6 then

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
        end
    end

    function getLoot()
        if lootedTargets == nil then lootedTargets = {} end
        if #lootedTargets > 0 then
            for x = 1, #lootedTargets do
                if not UnitExists(lootedTargets[x].Unit) then
                    --print("Looted Corpse no longer Exists")
                    table.remove(lootedTargets,x)
                    break
                end
            end
        end
        looted = false
        for i=1,ObjectCount() do
            if bit.band(ObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
                local thisUnit = ObjectWithIndex(i)
                if UnitGUID(thisUnit) ~= UnitGUID("target") and getCreatureType(thisUnit) == true then
                    if UnitCanAttack("player",thisUnit) == true and UnitIsDeadOrGhost(thisUnit) then
                        local myDistance = getDistance("player",thisUnit)
                        if myDistance < 5 then
                            if #lootedTargets == 0 then looted = false end
                            if #lootedTargets > 0 then
                                for x = 1, #lootedTargets do
                                    if UnitGUID(thisUnit)==UnitGUID(lootedTargets[x].Unit) then
                                        looted = true
                                    end
                                end
                            end
                            if looted==false then
                                --print("Found a lootable corpse")
                                if PriorAutoLoot == nil then PriorAutoLoot = false end
                                if GetCVar("autoLootDefault") == "1" then
                                    ChatOverlay("Autoloot Begin")
                                    PriorAutoLoot = true
                                end
                                if GetCVar("autoLootDefault") == "0" then 
                                    SetCVar("autoLootDefault", "1")
                                    ChatOverlay("Autoloot Begin")                   
                                end
                                InteractUnit(thisUnit)
                                if GetCVar("autoLootDefault") == "1" and PriorAutoLoot == true then
                                    ChatOverlay("Autoloot End")
                                end
                                if GetCVar("autoLootDefault") == "1" and PriorAutoLoot == false then 
                                    SetCVar("autoLootDefault", "0")
                                    ChatOverlay("Autoloot End")
                                end
                                if GetNumLootItems()==0 then
                                    --print("Looted Corpse")
                                    table.insert(lootedTargets, {Unit = thisUnit, Looted = true})
                                    ClearTarget()
                                    looted = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- function getDeadEnemies(Unit,Radius)
    --     local myEnemiesTable = {};
    --     -- if UnitExists("target") == true and getCreatureType("target") == true then
    --     --     if UnitCanAttack("player","target") == true and UnitIsDeadOrGhost("target") == false then
    --     --         local myDistance = getDistance("player","target")
    --     --         if myDistance <= Radius then
    --     --             table.insert(myEnemiesTable, { unit = "target" , range = myDistance });
    --     --         end
    --     --     end
    --     -- end
    --     for i=1,ObjectCount() do
    --         if bit.band(ObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
    --             local thisUnit = ObjectWithIndex(i)
    --             if UnitGUID(thisUnit) ~= UnitGUID("target") and getCreatureType(thisUnit) == true then
    --                 if UnitCanAttack("player",thisUnit) == true and UnitIsDeadOrGhost(thisUnit) then
    --                     local myDistance = getDistance("player",thisUnit)
    --                     if myDistance <= Radius then
    --                         table.insert(myEnemiesTable, { unit = thisUnit , range = myDistance });
    --                     end
    --                 end
    --             end
    --         end
    --     end
    --     return myEnemiesTable;
    -- end

    -- function getCorpse()
    --     local myEnemies = getDeadEnemies("player",5)
    --     if corpseTargets == nil then corpseTargets = {} end
    --     if #corpseTargets>0 then
    --         for i = 1, #corpseTargets do
    --             if corpseTargets[i].Looted == true and not UnitExists(corpseTargets[i].Unit) then
    --                 table.remove(corpseTargets,i)
    --             end
    --         end
    --     end
    --     if #myEnemies>0 then
    --         for i=1,#myEnemies do
    --             thisUnit = myEnemies[i].unit
    --             if UnitExists(thisUnit)
    --                 and getCreatureType(thisUnit)
    --                 and UnitCanAttack("player",thisUnit)
    --                 and UnitIsDeadOrGhost(thisUnit)
    --             then
    --                 if corpseTargets == nil then
    --                     table.insert(corpseTargets,{ Name = UnitName(thisUnit), Unit = thisUnit, Looted = false })
    --                 elseif #corpseTargets>0 then
    --                     matchFound = false
    --                     for i = 1, #corpseTargets do
    --                         if thisUnit == corpseTargets[i].Unit then
    --                             matchFound = true
    --                         end
    --                     end
    --                     if matchFound == false then
    --                         table.insert(corpseTargets,{ Name = UnitName(thisUnit), Unit = thisUnit, Looted = false })
    --                     end
    --                 end
    --             end
    --         end
    --     end
    -- end

    -- function getLoot()
    --     local corpseTargets = corpseTargets
    --     if #corpseTargets>0 then
    --         for i=1,#corpseTargets do
    --             if corpseTargets[i].Looted == false and not isMoving("player") then
    --                 thisUnit = corpseTargets[i].Unit
    --                 if PriorAutoLoot == nil then PriorAutoLoot = false end
    --                 if GetCVar("autoLootDefault") == "1" then
    --                     ChatOverlay("Autoloot Begin")
    --                     PriorAutoLoot = true
    --                 end
    --                 if GetCVar("autoLootDefault") == "0" then 
    --                     SetCVar("autoLootDefault", "1")
    --                     ChatOverlay("Autoloot Begin")                   
    --                 end
    --                 InteractUnit(thisUnit)
    --                 corpseTargets[i].Looted = true
    --                 ClearTarget()
    --                 if GetCVar("autoLootDefault") == "1" and PriorAutoLoot == true then
    --                     ChatOverlay("Autoloot End")
    --                 end
    --                 if GetCVar("autoLootDefault") == "1" and PriorAutoLoot == false then 
    --                     SetCVar("autoLootDefault", "0")
    --                     ChatOverlay("Autoloot End")
    --                 end
    --             end
    --         end
    --     end
    -- end
    
	function getRuneInfo()
		local bCount = 0
		local uCount = 0
		local fCount = 0
		local dCount = 0
		local bPercent = 0
		local uPercent = 0
		local fPercent = 0
		local dPercent = 0
		if not runeTable then
			runeTable = {}
		else
			table.wipe(runeTable)
		end
		for i = 1,6 do
			local CDstart = select(1,GetRuneCooldown(i))
			local CDduration = select(2,GetRuneCooldown(i))
			local CDready = select(3,GetRuneCooldown(i))
			local CDrune = CDduration-(GetTime()-CDstart)
			local CDpercent = CDpercent
			local runePercent = 0
			local runeCount = 0 
			local runeCooldown = 0
			if CDrune > CDduration then
				CDpercent = 1-(CDrune/(CDduration*2))
			else
				CDpercent = 1-CDrune/CDduration
			end
			if not CDready then
				runePercent = CDpercent
				runeCount = 0
				runeCooldown = CDrune
			else
				runePercent = 1
				runeCount = 1
				runeCooldown = 0
			end
			if GetRuneType(i) == 4 then
				dPercent = runePercent
				dCount = runeCount
				dCooldown = runeCooldown
				table.insert( runeTable,{ Type = "death", Index = i, Count = dCount, Percent = dPercent, Cooldown = dCooldown})
			end
			if GetRuneType(i) == 1 then
				bPercent = runePercent
				bCount = runeCount
				bCooldown = runeCooldown
				table.insert( runeTable,{ Type = "blood", Index = i, Count = bCount, Percent = bPercent, Cooldown = bCooldown})
			end
			if GetRuneType(i) == 2 then
				uPercent = runePercent
				uCount = runeCount
				uCooldown = runeCooldown
				table.insert( runeTable,{ Type = "unholy", Index = i, Count = uCount, Percent = uPercent, Cooldown = uCooldown})
			end
			if GetRuneType(i) == 3 then
				fPercent = runePercent
				fCount = runeCount
				fCooldown = runeCooldown
				table.insert( runeTable,{ Type = "frost", Index = i, Count = fCount, Percent = fPercent, Cooldown = fCooldown})
			end
		end
	end

	function getRunes(Type)
		Type = string.lower(Type)
		local runeCount = 0
		local runeTable = runeTable
		for i = 1, 6 do
			if runeTable[i].Type == Type then
				runeCount = runeCount + runeTable[i].Count
			end
		end
		return runeCount
	end

	function getRunePercent(Type)
		Type = string.lower(Type)
		local runePercent = 0
		local runeCooldown = 0
		local runeTable = runeTable
		for i = 1, 6 do
			if runeTable[i].Type == Type and runeTable[i].Cooldown > runeCooldown then
				runePercent = runeTable[i].Percent
				runeCooldown = runeTable[i].Cooldown
			end
		end
		if getRunes(Type)==2 then
			return 2
		elseif getRunes(Type)==1 then
			return runePercent+1
		else
			return runePercent
		end
	end

    function useAoE()
        if (BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2 then
        -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
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

    function useCleave()
        if BadBoy_data['Cleave']==1 and BadBoy_data['AoE'] ~= 3 then
            return true
        else
            return false
        end
    end
end
if select(3, UnitClass("player")) == 1 then

	function EvilEye()
	  if CD_Trinket == nil then

		if (GetInventoryItemID("player", 13) == 105491
		  or GetInventoryItemID("player", 14) == 105491) then -- heroic warforged 47%
			CD_Reduction_Value = (1 / 1.47)
			CD_Trinket = true

		elseif (GetInventoryItemID("player", 13) == 104495 -- heroic 44%
		  or GetInventoryItemID("player", 14) == 104495) then
			CD_Reduction_Value = (1 / 1.44)
			CD_Trinket = true

		elseif (GetInventoryItemID("player", 13) == 105242 -- warforged 41%
		  or GetInventoryItemID("player", 14) == 105242) then
			CD_Reduction_Value = (1 / 1.41)
			CD_Trinket = true

		elseif (GetInventoryItemID("player", 13) == 102298  -- normal 39%
		  or GetInventoryItemID("player", 14) == 102298) then
			CD_Reduction_Value = (1 / 1.39)
			CD_Trinket = true

		elseif (GetInventoryItemID("player", 13) == 104744 -- flex 34%
		  or GetInventoryItemID("player", 14) == 104744) then
			CD_Reduction_Value = (1 / 1.34)
			CD_Trinket = true

		elseif (GetInventoryItemID("player", 13) == 104993  -- lfr 31%
		  or GetInventoryItemID("player", 14) == 104993) then
			CD_Reduction_Value = (1 / 1.31)
			CD_Trinket = true
		end

		if CD_Trinket ~= true then
		  CD_Trinket = false
		  CD_Reduction_Value = 1
		end
	  end
	end

	function useAoE()
		if (BadBoy_data['AoE'] == 1 and getNumEnemies("player",8) >= 2) or BadBoy_data['AoE'] == 2 then
		-- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
			return true
		else
			return false
		end
	end

	function useCDs()
		if (BadBoy_data['Cooldowns'] == 1 and isBoss("target") or isDummy("target")) or BadBoy_data['Cooldowns'] == 2 then
			return true
		else
			return false
		end
	end

	function hasLust()
		if UnitBuffID("player",2825)        -- Bloodlust
		or UnitBuffID("player",80353)       -- Timewarp
		or UnitBuffID("player",32182)       -- Heroism
		or UnitBuffID("player",90355) then  -- Ancient Hysteria
			return true
		else
			return false
		end
	end

	SLASH_BLOCKBARRIER1 = '/blockbarrier';
	function SlashCmdList.BLOCKBARRIER(msg, editbox)
	  if BadBoy_data["Drop BlockBarrier"] == 1 then
		RunMacroText("/run BadBoy_data['Drop BlockBarrier'] = 2");
		ChatOverlay("Using Shield Barrier")
	  elseif BadBoy_data["Drop BlockBarrier"] == 2 then
		RunMacroText("/run BadBoy_data['Drop BlockBarrier'] = 1");
		ChatOverlay("Using Shield Block")
	  end
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
	
	function TargetValid(target)
		if UnitExists(target) ~= nil then
			if UnitIsDeadOrGhost(target) == nil then
				if UnitCanAttack("player",target) == 1 then
					if isInCombat(target) ~= nil then
						if IsSpellInRange(GetSpellInfo(MortalStrike),target) == 1 then
							return true;
						end
					end
				end
			end
		end
		return false;
	end

end

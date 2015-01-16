function bb.matchUnit(unit,table)
	for i = 1,#table do
		local guid = unit.guid
		if table[i].guid == guid then
			bb.read.enraged.unit = table[i]
			return table[i]
		end
	end
end

-- function to compare spells to casting units
-- /run bb.castOffensiveDispel(19801)
function bb.castOffensiveDispel(spell)
	-- first make sure we will be able to cast the spell
	if isChecked("Enrages Handler") and canCast(spell,false,false) == true then

		-- ToDo if the user sets its selector to target, only interupt current target.
		-- ToDo:this is ugly...
		selectedMode,selectedTargets = getOptionValue("Enrages Handler"),{ }
		if selectedMode == 1 then
			selectedTargets = { "target" }
		elseif selectedMode == 2 then
			selectedTargets = { "target","mouseover","focus" }
		elseif selectedMode == 3 then
			selectedTargets = { "target","mouseover" }
		end

		-- make sure we cover melee range
		local allowedDistance = select(6,GetSpellInfo(spell))
		if allowedDistance < 5 then
			allowedDistance = 5
		end

		for i = 1, #bb.read.enraged do
			if bb.read.enraged[i] ~= nil then
				-- if i still dont know wich unit it is compared to my fh units, find it.
				local thisUnit = bb.read.enraged[i].unit
				if thisUnit == nil then
					thisUnit = bb.matchUnit(bb.read.enraged[i],enemiesTable)
				end
				if thisUnit ~= nil then
					if ObjectExists(thisUnit.unit) then
						--if selectedMode == 4 or isSelectedTarget(thisUnit.unit) then
						  	if getDistance("player",thisUnit.unit) < allowedDistance then
								if castSpell(thisUnit.unit,spell,false,false) then
									--print("Cast Dispel "..thisUnit.name.." with "..spell)
									return true
								end
							end
						--end
					end
				end
			end
		end
	end
	return false
end
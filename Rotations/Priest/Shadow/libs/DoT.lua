if select(3, UnitClass("player")) == 5 and GetSpecialization()==3 then	

	-- Check if SWP is on 3 units or if #enemiesTable is <3 then on #enemiesTable
	function getSWP()
		local counter = 0
		-- iterate units for SWP
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			-- increase counter for each SWP
			if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,SWP,"player") then
				counter=counter+1
			end
		end
		-- return counter
		return counter
	end

	-- Check if VT is on 3 units or if #enemiesTable is <3 then on #enemiesTable
	function getVT()
		local counter = 0
		-- iterate units for SWP
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			-- increase counter for each SWP
			if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,VT,"player") then
				counter=counter+1
			end
		end
		-- return counter
		return counter
	end

	-- check unit for dot blacklist
	function safeDoT(checkUnit)
		local checkUnit = checkUnit
		local unitID = getUnitID(checkUnit)

		local blacklistUnitID = {
		-- highmaul
			79956,		-- Ko'ragh: Volatile Anomaly
			78077,		-- Mar'gok: Volatile Anomaly
		-- blackrock foundry
			77128,		-- Darmac: Pack Beast
			77394,		-- Thogar: Iron Raider (Train Ads)
			77893,		-- Kromog: Grasping Earth (Hands)
			77665,		-- Blackhand: Iron Soldier
		-- Hellfire Citadel
		}
		local blacklistBuffID = {
			155176, 	-- BRF: Blast Furnace: Primal Elementalist: http://www.wowhead.com/spell=155176/damage-shield
			176141, 	-- BRF: Blast Furnace: Slag Elemental: http://www.wowhead.com/spell=176141/hardened-slag
		}
		if checkUnit == nil then return false end
		-- check buff
		for i = 1, #blacklistBuffID do
			if getBuffRemain(checkUnit,blacklistBuffID[i]) > 0 or getDebuffRemain(checkUnit,blacklistBuffID[i]) > 0 then return false end
		end
		-- check unitID
		for i = 1, #blacklistUnitID do
			if getUnitID(checkUnit) == blacklistUnitID[i] then return false	end
		end
		-- unit is not in blacklist
		return true
	end

	-- check unit for VT blacklist
	function safeVT(checkUnit)
		local checkUnit = checkUnit
		local unitID = getUnitID(checkUnit)

		local blacklistUnitID = {
			-- Blackrock Foundry
			77893,		-- Kromog: Grasping Earth (Hands)
			78981,		-- Thogar: Iron Gunnery Sergeant (canons on trains)
			93717,		-- Iron Reaver: Volatile Firebomb
			-- Hellfire Citadel
			94865,		-- Hellfire Council: Jubei'thos Mirrors
			94231,		-- Xhul'horac: Wild Pyromaniac
		}
		if checkUnit == nil then return false end
		-- check unitID
		for i = 1, #blacklistUnitID do
			if getUnitID(checkUnit) == blacklistUnitID[i] then return false	end
		end
		-- unit is not in blacklist
		return true
	end

	-- no dotweave, just press damage
	function noDoTWeave(datUnit)
		local blacklistUnitID = {
			-- Highmaul
			77878, 		-- Mar'gok: Fortified Arcane Aberration
			77877, 		-- Mar'gok: Replicating Arcane Aberration
			77879, 		-- Mar'gok: Displacing Arcane Aberration
			77809,		-- Mar'gok: Arcane Aberration
			-- Blackrock Foundry
			77893,		-- Kromog: Grasping Earth (Hands)
			78981,		-- Thogar: Iron Gunnery Sergeant (canons on trains)
		}
		if checkUnit == nil then return false end
		-- check unitID
		for i = 1, #blacklistUnitID do
			if getUnitID(checkUnit) == blacklistUnitID[i] then return true end
		end
		-- unit is not in blacklist, we can dotweave -> return false
		return false
	end

	--[[                    ]] -- SWP
		-- refresh
		function refreshSWP(options,targetAlso)
			--if options.buttons.DoT==2 or options.buttons.DoT==4 then
				local SWPCount = getSWP()
				if SWPCount <= options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local range = enemiesTable[i].distance
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if range < 40 and getLineOfSight(thisUnit) then 
								if not UnitIsUnit("target",thisUnit) or targetAlso then
									if UnitDebuffID(thisUnit,SWP,"player") then
										-- check remaining time and minhealth
										if getDebuffRemain(thisUnit,SWP,"player")<=options.values.SWPRefresh and thisHP>options.values.MinHealth then
											if castSpell(thisUnit,SWP,true,false) then 
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			--end
		end
		
		-- apply
		function throwSWP(options,targetAlso)
			--if options.buttons.DoT==2 or options.buttons.DoT==4 then
				local SWPCount = getSWP()
				if SWPCount<options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local range = enemiesTable[i].distance
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if range < 40 and getLineOfSight(thisUnit) then
								if not UnitIsUnit("target",thisUnit) or targetAlso then
									-- check remaining time and minhealth
									if getDebuffRemain(thisUnit,SWP,"player")<=0 and thisHP>options.values.MinHealth then
										if castSpell(thisUnit,SWP,true,false) then 
											return true
										end
									end
								end
							end
						end
					end
				end
			--end
		end
	--[[                    ]] -- SWP

	--[[                    ]] -- VT
		function refreshVT(options,targetAlso)
			--if options.buttons.DoT==3 or options.buttons.DoT==4 then
				local VTCount = getVT()
				-- refresh VT
				if VTCount <= options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local range = enemiesTable[i].distance
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if safeVT(thisUnit) then
								if range < 40 and getLineOfSight(thisUnit) then
									if not UnitIsUnit("target",thisUnit) or targetAlso then
										if UnitDebuffID(thisUnit,VT,"player") then
											-- check remaining time and minhealth
											if getDebuffRemain(thisUnit,VT,"player")<=options.values.VTRefresh and thisHP>options.values.MinHealth then
												if castSpell(thisUnit,VT,true,true) then 
													return true
												end
											end
										end
									end
								end
							end
						end
					end
				end
			--end
		end
		
		function throwVT(options,targetAlso)
			--if options.buttons.DoT==3 or options.buttons.DoT==4 then
				local VTCount = getVT()
				if VTCount<options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local range = enemiesTable[i].distance
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if safeVT(thisUnit) then
								if range < 40 and getLineOfSight(thisUnit) then
									if not UnitIsUnit("target",thisUnit) or targetAlso then
										-- check remaining time and minhealth
										if getDebuffRemain(thisUnit,VT,"player")<=0 and thisHP>options.values.MinHealth then
											if castSpell(thisUnit,VT,true,true) then 
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			--end
		end
	--[[                    ]] -- VT
end
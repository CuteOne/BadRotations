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

	-- Units not to dot with DoTEmAll
	function safeDoT(datUnit)
		local BlacklistName = {
			-- Highmaul
			"Volatile Anomaly",
			-- Blackrock Foundry
			"Pack Beast",
			"Grasping Earth",
		}
		local BlacklistBuff = {
			155176, 			-- BRF: Blast Furnace: Primal Elementalist: http://www.wowhead.com/spell=155176/damage-shield
			176141, 			-- BRF: Blast Furnace: Slag Elemental: http://www.wowhead.com/spell=176141/hardened-slag
		}
		-- nil Protection
		if datUnit == nil then 
			return true 
		end
		-- check buff
		for i = 1, #BlacklistBuff do
			if getBuffRemain(datUnit,BlacklistBuff[i])>0 
			or getDebuffRemain(datUnit,BlacklistBuff[i])>0 then
				return false
			end
		end
		-- check name
		for i = 1, #BlacklistName do
			if UnitName(datUnit) == BlacklistName[i] then
				return false
			end
		end
		-- unit is not in blacklist
		return true
	end

	function safeVT(datUnit)
		local Blacklist = {
			-- Blackrock Foundry
			"Grasping Earth",
		}
		-- nil Protection
		if datUnit == nil then 
			return true
		end
		-- Iterate the blacklist
		for i = 1, #Blacklist do
			if UnitName(datUnit) == Blacklist[i] then
				return false
			end
		end
		-- unit is not in blacklist
		return true
	end

	-- Units not to dotweave, just press damage
	function noDoTWeave(datUnit)
		local Blacklist = {
			-- Highmaul
			"Fortified Arcane Aberration",
			"Replicating Arcane Aberration",
			"Displacing Arcane Aberration",
			"Arcane Aberration",
			-- Blackrock Foundry
			"Siegemaker",
			"Ore Crate",
			"Dominator Turret",
			"Grasping Earth",
			"Cinder Wolf",
			"Iron Gunnery Sergeant",
			"Heavy Spear",
			"Aknor Steelbringer",
		}
		if datUnit==nil then return false end
			for i = 1, #Blacklist do
				if UnitName(datUnit) == Blacklist[i] then
					return  true
				end
			return false
		end
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
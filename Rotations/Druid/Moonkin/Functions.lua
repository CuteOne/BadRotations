if select(3, UnitClass("player")) == 11 then
	--function BoomkinFunctions()

		-- eclipse timer
		function getEclipseTimer()
			local peakTimer
			local eclipsePosition
			local eclipseTimers
			local moon
			local currentPowerTime
			local extraTimer

			if GetEclipseDirection() == 'moon' then
				moon = true
			else
				moon = false
			end

			eclipsePosition = UnitPower('player',SPELL_POWER_ECLIPSE)
			currentPowerTime = math.asin(UnitPower('player', SPELL_POWER_ECLIPSE)/105)/math.pi*20
			peakTimer = math.asin(100/105)/math.pi*20
			extraTimer = (math.asin(105/105)/math.pi*20 - peakTimer)*2

			if moon and eclipsePosition > 0 then
				eclipseTimers = abs(currentPowerTime)
			elseif moon and eclipsePosition < 0 then
				eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
			elseif not moon and eclipsePosition < 0 then
				eclipseTimers = abs(currentPowerTime)
			else
				eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
			end

			return 0.5*eclipseTimers
		end

		-- eclipse change timer
		function getEclipseChangeTimer()
			-- this function shows the remaining time until eclipse will change.
			-- it's value isnt correct if the energy is raising

			-- moon -> sun
			-- 	energy = negative
			-- 	direction = sun

			-- sun -> moon
			-- 	energy = positive
			-- 	direction moon
			local peakTimer
			local eclipsePosition
			local eclipseTimers
			local currentPowerTime
			local extraTimer

			local energy = UnitPower("player",8)
			local moon
			local sun

			-- timer calculation
			eclipsePosition = UnitPower('player',SPELL_POWER_ECLIPSE)
			currentPowerTime = math.asin(UnitPower('player', SPELL_POWER_ECLIPSE)/105)/math.pi*20
			peakTimer = math.asin(100/105)/math.pi*20
			extraTimer = (math.asin(105/105)/math.pi*20 - peakTimer)*2

			-- energy
			if energy<0 then
				negative = true
				positive = false
			else
				negative = false
				positive = true
			end

			-- direction
			if GetEclipseDirection() == 'moon' then
				moon = true
				sun  = false
			else
				moon = false
				sun  = true
			end

			-- timer
			if moon and eclipsePosition > 0 then
				eclipseTimers = abs(currentPowerTime)
			elseif moon and eclipsePosition < 0 then
				eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
			elseif not moon and eclipsePosition < 0 then
				eclipseTimers = abs(currentPowerTime)
			else
				eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
			end

			-- return specific timer
			if negative and sun then
				return 0.5*eclipseTimers
			elseif negative and moon then
				return extraTimer
			elseif positive and moon then
				return 0.5*eclipseTimers
			elseif positive and sun then
				return extraTimer
			end
		end

		-- time till lunar max
		function lunar_max()
			local eclipseDirection = GetEclipseDirection()
			local eclipseEnergy = UnitPower("player",8)
			
			local eclipseHalf = 0.5*math.asin(100/105)/math.pi*20
			local peakTime = (math.asin(105/105)/math.pi*20 - math.asin(100/105)/math.pi*20)*2
			local eclipseRemaining = getEclipseTimer()

			
			-- timer return
			if eclipseDirection=="moon" 
			and eclipseEnergy<=0 then
				return eclipseRemaining
			end
			if eclipseDirection=="moon" 
			and eclipseEnergy>0 then
				return eclipseHalf + eclipseRemaining
			end
			if eclipseDirection=="sun" 
			and eclipseEnergy<=0 then
				return 3*eclipseHalf + peakTime + eclipseRemaining
			end
			if eclipseDirection=="sun" 
			and eclipseEnergy>0 then
				return 2*eclipseHalf + peakTime + eclipseRemaining
			end
		end
		
		-- time till solar max
		function solar_max()
			local eclipseDirection = GetEclipseDirection()
			local eclipseEnergy = UnitPower("player",8)
			
			local eclipseHalf = 0.5*math.asin(100/105)/math.pi*20
			local peakTime = (math.asin(105/105)/math.pi*20 - math.asin(100/105)/math.pi*20)*2
			local eclipseRemaining = getEclipseTimer()

			
			-- timer return
			if eclipseDirection=="sun" 
			and eclipseEnergy>=0 then
				return eclipseRemaining
			end
			if eclipseDirection=="sun" 
			and eclipseEnergy<0 then
				return eclipseHalf + eclipseRemaining
			end
			if eclipseDirection=="moon" 
			and eclipseEnergy>=0 then
				return 3*eclipseHalf + peakTime + eclipseRemaining
			end
			if eclipseDirection=="moon" 
			and eclipseEnergy<0 then
				return 2*eclipseHalf + peakTime + eclipseRemaining
			end
		end

		-- isSunfire()
		function isSunfire()
			-- moonfire: 8921, sunfire: 93402
			if select(3,GetSpellInfo(8921)) == select(3,GetSpellInfo(93402)) then
				return true
			else
				return false
			end
		end

		-- current druid form
		function getDruidForm()
			local id = GetShapeshiftFormID()
			if     id == 5 then
				return "bear"
			elseif id == 1 then 
				return "cat"
			elseif id == 4 then 
				return "aquatic"
			elseif id == 3 then 
				return "travel"
			elseif id == 31 then 
				return "boomkin"
			elseif id == 2 then
				return "tree"
			elseif id == 27 then 
				return "flight"
			else 
				return nil
			end
		end

		function safeDoT(datUnit)
			local Blacklist = {
				-- Highmaul
				"Volatile Anomaly",
				-- Blackrock Foundry
				"Pack Beast",
			}
			-- nil Protection
			if datUnit == nil then 
				return true 
			end
			-- BRF: Blast Furnace: Primal Elementalist: http://www.wowhead.com/spell=155176/damage-shield
			-- BRF: Blast Furnace: Slag Elemental: http://www.wowhead.com/spell=176141/hardened-slag
			if UnitBuffID(datUnit,155176)
			or UnitBuffID(datUnit,176141) then
				return false
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

		function getSunfire()
			local counter = 0
			-- iterate units for Sunfire
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				-- increase counter for each Sunfire
				if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,164815,"player") then
					counter=counter+1
				end
			end
			-- return counter
			return counter
		end

		function getMoonfire()
			local counter = 0
			-- iterate units for Sunfire
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				-- increase counter for each Sunfire
				if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,164812,"player") then
					counter=counter+1
				end
			end
			-- return counter
			return counter
		end

		function throwSunfire(maxTargets,minHP)
			if isSunfire() then
				--if options.buttons.DoT==2 or options.buttons.DoT==4 then
					local SunfireCount = getSunfire()
					if SunfireCount<=maxTargets then
						for i=1, #enemiesTable do
							local thisUnit = enemiesTable[i].unit
							local range = enemiesTable[i].distance
							local thisHP = enemiesTable[i].hpabs
							-- check for target and safeDoT
							if safeDoT(thisUnit) then
								if range < 40 then
									-- check remaining time and minhealth
									if getDebuffRemain(thisUnit,164815,"player")<=8 and thisHP>minHP then
										if castSpell(thisUnit,8921,false,false) then 
											return true
										end
									end
								end
							end
						end
					end
				--end
			end
		end

		function throwMoonfire(maxTargets,minHP)
			--if options.buttons.DoT==2 or options.buttons.DoT==4 then
				local MoonfireCount = getMoonfire()
				if MoonfireCount<=maxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local range = enemiesTable[i].distance
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if range < 40 then
								-- check remaining time and minhealth
								if getDebuffRemain(thisUnit,164812,"player")<=8 and thisHP>minHP then
									if castSpell(thisUnit,8921,false,false) then 
										return true
									end
								end
							end
						end
					end
				end
			--end
		end


		
	--end -- BoomkinFunctions()
end
if select(3, UnitClass("player")) == 11 then
	--function BoomkinFunctions()

		-- eclipse timer
		function getEclipseTimer2()
			local OUTPUT1 = 0
			local OUTPUT2 = 0

			local peakTimer
			local eclipsePosition
			local eclipseTimers
			local moon
			local currentPowerTime
			local extraTimer
			local euphoria_mod = 1

			-- euphoria mod
			if getTalent(7,1) then
				euphoria_mod = 2
			else
				euphoria_mod = 1
			end

			-- eclipse direction
			if GetEclipseDirection() == 'moon' then
				moon = true
			else
				moon = false
			end

			local eclipsePosition = UnitPower('player',SPELL_POWER_ECLIPSE)

			local currentPowerTime = math.asin(UnitPower('player', SPELL_POWER_ECLIPSE)/105)/math.pi*20
			local peakTimer = math.asin(100/105)/math.pi*20
			local extraTimer = (math.asin(105/105)/math.pi*20 - peakTimer)*2

			if moon and eclipsePosition > 0 then
				eclipseTimers = abs(currentPowerTime)
			elseif moon and eclipsePosition < 0 then
				eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
			elseif not moon and eclipsePosition < 0 then
				eclipseTimers = abs(currentPowerTime)
			else
				eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
			end

			if eclipsePosition < 0 then -- lunar active
				return (eclipseTimers/euphoria_mod)
			else -- solar active
				return (eclipseTimers/euphoria_mod)
			end
		end




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

		-- isSunfire()
		function isSunfire()
			-- moonfire: 8921, sunfire: 93402
			if select(3,GetSpellInfo(8921)) == select(3,GetSpellInfo(93402)) then
				return true
			else
				return false
			end
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

		
	--end -- BoomkinFunctions()
end
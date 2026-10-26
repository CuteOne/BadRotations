---
-- Small helpers a profile needs that aren't about units, spells or the screen: the game clock, named
-- timers and rounding.
-- Util functions are the profile API table `util` (br.api.profile.util); profiles use it by name.
-- @module util
local _, br = ...

br.api.build.util = function(api)
    local util = api.util
    -- The profile's timer names, kept apart from BR's own timers
    local profileTimers = {}

    --- Rounds a number to the specified number of decimal places (default 2)
    -- @function util.round
    -- @number num - The number to round.
    -- @number[opt=2] numDecimalPlaces - The number of decimal places to round to.
    -- @return number - Returns the rounded number
    util.round = function(num, numDecimalPlaces)
        if numDecimalPlaces == nil then numDecimalPlaces = 2 end
        return br.functions.misc:round2(num, numDecimalPlaces)
    end

    --- Returns the time, value of GetTime
    -- @function util.time
    -- @return number - Returns the current game time
    util.time = function()
        return br.functions.misc:getTime()
    end

    --- True the first time, then again each time the interval has passed since it was last true
    -- @function util.timer
    -- @string timerName - The name of the timer check, should be unique.
    -- @number interval - The length of time to wait until true, in seconds.
    -- @return boolean - Returns true if the interval has passed
    -- @usage if util.timer("Hunter's Mark", 2) then
    util.timer = function(timerName, interval)
        return br.functions.misc:useTimer(timerName, interval, profileTimers)
    end
end

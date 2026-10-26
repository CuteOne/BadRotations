---
-- These functions find units: the "best" unit for a range and AOE/facing, the group members, the dead to loot.
-- Units functions are the profile API table `units` (br.api.profile.units); profiles use it by name.
-- @module units
local _, br = ...
br.api.build.units = function(api)
    local units = api.units

    -- units.friends: the group members the healing engine keeps, each with .unit, .hp, .role, ...
    setmetatable(units, { __index = function(_, key)
        if key == "friends" then return br.engines.healingEngine.friend end
    end })
    -- The profile's own target weight is cleared whenever the profile is built
    br.engines.targeting.customWeight = nil

    --- Gets the unit to buff from a "Player/Target/Mouseover/Focus/Group" dropdown option.
    -- @function units.buffUnit
    -- @string thisOption - Name of the dropdown option.
    -- @param needsBuff - function(unit) returning true if that group member needs the buff (Group mode).
    -- @number[opt=40] range - Maximum range for group members.
    -- @return string - Unit token; falls back to "player" when the chosen unit doesn't exist.
    units.buffUnit = function(thisOption, needsBuff, range)
        return br.functions.unit:getBuffUnit(br.functions.misc:getValue(thisOption), needsBuff, range)
    end

    --- Gets the "best" unit within a specified range in front or around the player.
    -- Call once per profile rotation and use the variable it creates in units
    -- IE: units.get(5,false) makes units.dyn5, units.get(8,true) makes units.dyn8AOE
    -- @function units.get
    -- @number range - Distance in yards to look for the "best" unit
    -- @boolean[opt=false] aoe - If true, looks for best unit anywhere in range, otherwise only units you are facing will be considered.
    -- @returns unit object
    units.get = function(range,aoe)
        local dynString = "dyn"..range
        aoe = aoe or false
        if aoe then dynString = dynString.."AOE" end
        local facing = not aoe
        local thisUnit = br.engines.enemiesEngineFunctions:dynamicTarget(range, facing)
        -- Build units.dyn varaible
        units[dynString] = units[dynString] or {}
        units[dynString] = thisUnit
        return thisUnit -- Backwards compatability for old way
    end

    --- True when the group hasn't changed (members joining or leaving) for that many seconds
    -- @function units.groupStable
    -- @number seconds
    -- @return boolean
    units.groupStable = function(seconds)
        return br.engines.healingEngine:isGroupStable(seconds)
    end

    --- The group members within radius yards of a unit at or below health percent, lowest first, at
    -- most count of them (each with .hp, .guid, .name, position)
    -- @function units.healAround
    -- @string thisUnit The centre
    -- @number radius Yards
    -- @number health Health percent
    -- @number count The most members to return
    -- @return table
    units.healAround = function(thisUnit, radius, health, count)
        return br.engines.healingEngineFunctions:getUnitsToHealAround(thisUnit, radius, health, count)
    end

    --- The dead units the player can loot
    -- @function units.lootable
    -- @return table
    units.lootable = function()
        return br.engines.enemiesEngine.lootable
    end

    --- How many dead units are waiting to be looted
    -- @function units.lootCount
    -- @return number
    units.lootCount = function()
        return br.engines.lootEngine:lootCount()
    end

    --- Sets the profile's own target weight for dynamic targeting: fn(unit) returns a number added to
    -- the unit's score (higher = more priority), or nil to leave it. Cleared whenever the profile is built.
    -- @function units.setTargetWeight
    -- @param fn function(unit) or nil
    -- @usage
    -- -- Example: Feral druid prioritizing Rip refresh
    -- units.setTargetWeight(function(thisUnit)
    --     if debuff.rip.exists(thisUnit) and debuff.rip.remains(thisUnit) < 5 then
    --         return 80 -- High priority to refresh expiring Rip
    --     end
    -- end)
    units.setTargetWeight = function(fn)
        br.engines.targeting.customWeight = fn
    end
end

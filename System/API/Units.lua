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

    --- Gets the unit to buff from a "cast on" dropdown option (choices = "CastOn": You, You + Target,
    -- You + Mouseover, You + Focus, You + Group). Older form of units.castOn: range by distance, no cast check.
    -- @function units.buffUnit
    -- @string thisOption - Name of the dropdown option.
    -- @param needsBuff - function(unit) returning true if that unit needs the buff.
    -- @number[opt=40] range - Maximum range for others.
    -- @return string - Unit token: you, else the first friendly player the option allows that needs it, else "player".
    units.buffUnit = function(thisOption, needsBuff, range)
        return br.functions.unit:getBuffUnit(br.functions.misc:getValue(thisOption), needsBuff, range)
    end

    --- The unit a "cast on" dropdown option (choices = "CastOn") puts a helpful spell on now, or nil: you first,
    -- then the option's target, mouseover or focus, or for You + Group each member (lowest health first). Each one
    -- must be a friendly player you can help (alive, online, not charmed), want it (needs) and be castable (able,
    -- usually cast.able.<spell>, which judges range and sight); one that fails is passed over for the next.
    -- @function units.castOn
    -- @string thisOption - Name of the dropdown option.
    -- @param needs - function(unit) returning true if that unit wants the spell (nil: anyone).
    -- @param able - function(unit) returning true if the spell can go on that unit now (nil: no check).
    -- @param[opt] opts - { self = false: leave yourself out; others = false: only yourself (a key not held);
    --   roles = { "TANK", ... }: group members in these roles first; dead = true: dead players to resurrect
    --   instead of living ones }.
    -- @return string|nil - Unit token, or nil when nobody qualifies.
    -- @usage local thisUnit = units.castOn("Thorns", buff.thorns.refresh, cast.able.thorns, { roles = { "TANK" } })
    units.castOn = function(thisOption, needs, able, opts)
        return br.functions.unit:getCastOnUnit(br.functions.misc:getValue(thisOption), needs, able, opts)
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

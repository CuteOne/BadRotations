---
-- This function helps in retrieving the "best" unit for the specified range and AOE/Facing.
-- Units functions are stored in br.player.units and can be utilized by `local units = br.player.units` in your profile.
-- @module br.player.units
local _, br = ...
if br.api == nil then br.api = {} end
br.api.units = function(self)
    local units = self.units

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
    br.engines.targeting.customWeight = nil
    units.setTargetWeight = function(fn)
        br.engines.targeting.customWeight = fn
    end

    --- Gets the "best" unit within a specified range in front or around the player.
    -- Call once per profile rotation and use the variable it creates in br.player.units
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
end

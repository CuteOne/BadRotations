local _, br = ...
if br.api == nil then br.api = {} end
br.api.units = function(self)
    local units = self.units
    -- Gets a unit within a specified range in front or around the player.
---@diagnostic disable-next-line: inject-field
    units.get = function(range,aoe)
        local dynString = "dyn"..range
        aoe = aoe or false
        if aoe then dynString = dynString.."AOE" end
        local facing = not aoe
        local thisUnit = br.dynamicTarget(range, facing)
        -- Build units.dyn varaible
        units[dynString] = units[dynString] or {}
        units[dynString] = thisUnit
        return thisUnit -- Backwards compatability for old way
    end
end

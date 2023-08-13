local _, br = ...
if br.api == nil then br.api = {} end

local MAW_BUFF_MAX_DISPLAY = 44;
local mawBuff = {};

local function getAnimaInfo(animaID)
    table.wipe(mawBuff)
    mawBuff.exists = false
    mawBuff.count = 0
    if br._G.IsInJailersTower() then
        for i=1, MAW_BUFF_MAX_DISPLAY do
            local _, icon, count, _, _, _, _, _, _, spellID = br._G.UnitAura("player", i, "MAW");
            if icon then
                if count == 0 then
                    count = 1;
                end
                if spellID == animaID then
                    mawBuff.exists = true
                    mawBuff.count = count
                end
            end
        end
    end
    return mawBuff
end

--- Anima Powers functions.
-- These functions are accessible via `br.player.animas.spell.functionName()`.
-- @tparam table anima The anima power table.
-- @tparam number v The ID of the anima power.
br.api.animas = function(anima,v)
    --- Check if a specific anima power exists.
    -- @treturn boolean True if the anima power exists, false otherwise.
    -- @usage local anima = br.player.animas
    -- anima.spell.exists()  -- Checks if the anima power exists, replace spell with name of spell to check.
    anima.exists = function()
        local thisAnima = getAnimaInfo(v)
        return thisAnima.exists
    end

    --- Get the rank of a specific anima power.
    -- @treturn number The rank of the anima power.
    -- @usage local anima = br.player.animas
    -- anima.spell.rank()  -- Gets the rank of the anima power, replace spell with name of spell to check.
    anima.rank = function()
        local thisAnima = getAnimaInfo(v)
        return thisAnima.count
    end
end

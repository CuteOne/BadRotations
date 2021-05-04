local _, br = ...
if br.api == nil then br.api = {} end
local MAW_BUFF_MAX_DISPLAY = 44;
local mawBuff = {};
local function getAnimaInfo(animaID)
    table.wipe(mawBuff)
    mawBuff.exists = false
    mawBuff.count = 0
    if IsInJailersTower() then
        for i=1, MAW_BUFF_MAX_DISPLAY do
            local _, icon, count, _, _, _, _, _, _, spellID = UnitAura("player", i, "MAW");
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
br.api.animas = function(anima,v)
    anima.exists = function()
        local thisAnima = getAnimaInfo(v)
        return thisAnima.exists
    end
    anima.rank = function()
        local thisAnima = getAnimaInfo(v)
        return thisAnima.count
    end

end
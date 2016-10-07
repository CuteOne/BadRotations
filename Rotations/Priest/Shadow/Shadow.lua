function PriestShadow()
    if GetSpecializationInfo(GetSpecialization()) == 258 then
        if bb.player == nil or bb.player.profile ~= "Shadow" then
            bb.player = cShadow:new("Shadow")
            setmetatable(bb.player, {__index = cShadow})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end --Spec Function End
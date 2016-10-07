function PaladinHoly()
    if GetSpecializationInfo(GetSpecialization()) == 65 then
        if bb.player == nil or bb.player.profile ~= "Holy" then
            bb.player = cHoly:new("Holy")
            setmetatable(bb.player, {__index = cHoly})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end 
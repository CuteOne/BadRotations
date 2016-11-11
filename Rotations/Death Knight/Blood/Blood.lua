function DeathKnightBlood()
    if GetSpecializationInfo(GetSpecialization()) == 250 then
        if bb.player == nil or bb.player.profile ~= "Blood" then
            bb.player = cBlood:new("Blood")
            setmetatable(bb.player, {__index = cBlood})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
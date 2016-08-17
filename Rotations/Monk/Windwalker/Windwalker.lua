function MonkWindwalker()
    if GetSpecializationInfo(GetSpecialization()) == 269 then
        if bb.player == nil or bb.player.profile ~= "Windwalker" then
            bb.player = cWindwalker:new("Windwalker")
            setmetatable(bb.player, {__index = cWindwalker})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Class Check End
end --Monk Function End
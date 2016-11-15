function MonkWindwalker()
    if GetSpecializationInfo(GetSpecialization()) == 269 then
        if br.player == nil or br.player.profile ~= "Windwalker" then
            br.player = cWindwalker:new("Windwalker")
            setmetatable(br.player, {__index = cWindwalker})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()

    end --Class Check End
end --Monk Function End
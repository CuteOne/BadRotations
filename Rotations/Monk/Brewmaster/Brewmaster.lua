function MonkBrewmaster()
    if GetSpecializationInfo(GetSpecialization()) == 268 then
        if br.player == nil or br.player.profile ~= "Brewmaster" then
            br.player = cBrewmaster:new("Brewmaster")
            setmetatable(br.player, {__index = cBrewmaster})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()

    end --Class Check End
end --Monk Function End
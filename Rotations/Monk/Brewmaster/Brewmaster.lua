function MonkBrewmaster()
    if GetSpecializationInfo(GetSpecialization()) == 268 then
        if bb.player == nil or bb.player.profile ~= "Brewmaster" then
            bb.player = cBrewmaster:new("Brewmaster")
            setmetatable(bb.player, {__index = cBrewmaster})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Class Check End
end --Monk Function End
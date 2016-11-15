function MonkMistweaver()
    if GetSpecializationInfo(GetSpecialization()) == 270 then
        if br.player == nil or br.player.profile ~= "Mistweaver" then
            br.player = cMistweaver:new("Mistweaver")
            setmetatable(br.player, {__index = cMistweaver})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()

    end --Class Check End
end --Monk Function End
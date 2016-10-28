function MonkMistweaver()
    if GetSpecializationInfo(GetSpecialization()) == 270 then
        if bb.player == nil or bb.player.profile ~= "Mistweaver" then
            bb.player = cMistweaver:new("Mistweaver")
            setmetatable(bb.player, {__index = cMistweaver})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Class Check End
end --Monk Function End
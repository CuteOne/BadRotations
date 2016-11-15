function RogueSubtlety()
    if GetSpecializationInfo(GetSpecialization()) == 261 then
        if br.player == nil or br.player.profile ~= "Subtlety" then
            br.player = cSubtlety:new("Subtlety")
            setmetatable(br.player, {__index = cSubtlety})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()

    end --Class Check End
end --Rogue Function End
function RogueSubtlety()
    if GetSpecializationInfo(GetSpecialization()) == 261 then
        if bb.player == nil or bb.player.profile ~= "Subtlety" then
            bb.player = cSubtlety:new("Subtlety")
            setmetatable(bb.player, {__index = cSubtlety})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Class Check End
end --Rogue Function End
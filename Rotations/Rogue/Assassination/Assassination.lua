function RogueAssassination()
    if GetSpecializationInfo(GetSpecialization()) == 259 then
        if bb.player == nil or bb.player.profile ~= "Assassination" then
            bb.player = cAssassination:new("Assassination")
            setmetatable(bb.player, {__index = cAssassination})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Spec Check End
end --Rogue Function End

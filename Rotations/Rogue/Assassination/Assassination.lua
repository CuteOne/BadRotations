function RogueAssassination()
    if GetSpecializationInfo(GetSpecialization()) == 259 then
        if br.player == nil or br.player.profile ~= "Assassination" then
            br.player = cAssassination:new("Assassination")
            setmetatable(br.player, {__index = cAssassination})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()

    end --Spec Check End
end --Rogue Function End

function PaladinRetribution() 
    if GetSpecializationInfo(GetSpecialization()) == 70 then 
        if br.player == nil or br.player.profile ~= "Retribution" then 
            br.player = cRetribution:new("Retribution") 
            setmetatable(br.player, {__index = cRetribution})
            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end
        br.player:update()

    end --Class Check End
end --Spec Function End
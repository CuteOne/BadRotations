function PaladinRetribution() 
    if GetSpecializationInfo(GetSpecialization()) == 70 then 
        if bb.player == nil or bb.player.profile ~= "Retribution" then 
            bb.player = cRetribution:new("Retribution") 
            setmetatable(bb.player, {__index = cRetribution})
            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end
        bb.player:update()

    end --Class Check End
end --Spec Function End
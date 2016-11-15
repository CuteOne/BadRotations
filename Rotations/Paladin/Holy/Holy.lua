function PaladinHoly()
    if GetSpecializationInfo(GetSpecialization()) == 65 then
        if br.player == nil or br.player.profile ~= "Holy" then
            br.player = cHoly:new("Holy")
            setmetatable(br.player, {__index = cHoly})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end 
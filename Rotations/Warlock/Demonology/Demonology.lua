function WarlockDemonology()
    if GetSpecializationInfo(GetSpecialization()) == 266 then
        if br.player == nil or br.player.profile ~= "Demonology" then
            br.player = cDemonology:new("Demonology")
            setmetatable(br.player, {__index = cDemonology})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
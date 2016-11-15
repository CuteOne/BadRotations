function MageFire()
    if GetSpecializationInfo(GetSpecialization()) == 63 then
        if br.player == nil or br.player.profile ~= "Fire" then
            br.player = cFire:new("Fire")
            setmetatable(br.player, {__index = cFire})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
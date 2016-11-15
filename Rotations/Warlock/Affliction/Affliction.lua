function WarlockAffliction()
    if GetSpecializationInfo(GetSpecialization()) == 265 then
        if br.player == nil or br.player.profile ~= "Affliction" then
            br.player = cAffliction:new("Affliction")
            setmetatable(br.player, {__index = cAffliction})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
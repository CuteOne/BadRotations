function DemonHunterVengeance()
    if GetSpecializationInfo(GetSpecialization()) == 581 then
        if br.player == nil or br.player.profile ~= "Vengeance" then
            br.player = cVengeance:new("Vengeance")
            setmetatable(br.player, {__index = cVengeance})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
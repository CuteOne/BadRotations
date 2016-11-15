function DruidMoonkin()
    if GetSpecializationInfo(GetSpecialization()) == 102 then
        if br.player == nil or br.player.profile ~= "Balance" then
            br.player = cBalance:new("Balance")
            setmetatable(br.player, {__index = cBalance})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end





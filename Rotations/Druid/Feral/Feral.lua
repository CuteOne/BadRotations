function DruidFeral()
    if GetSpecializationInfo(GetSpecialization()) == 103 then
        if br.player == nil or br.player.profile ~= "Feral" then
            br.player = cFeral:new("Feral")
            setmetatable(br.player, {__index = cFeral})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end

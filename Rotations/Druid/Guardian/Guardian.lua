function DruidGuardian()
    if GetSpecializationInfo(GetSpecialization()) == 104 then
        if br.player == nil or br.player.profile ~= "Guardian" then
            br.player = cGuardian:new("Guardian")
            setmetatable(br.player, {__index = cGuardian})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end

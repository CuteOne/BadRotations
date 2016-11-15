function WarriorProtection()
    if GetSpecializationInfo(GetSpecialization()) == 73 then
        if br.player == nil or br.player.profile ~= "Protection" then
            br.player = cProtection:new("Protection")
            setmetatable(br.player, {__index = cProtection})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
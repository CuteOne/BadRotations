function WarriorArms()
    if GetSpecializationInfo(GetSpecialization()) == 71 then
        if br.player == nil or br.player.profile ~= "Arms" then
            br.player = cArms:new("Arms")
            setmetatable(br.player, {__index = cArms})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
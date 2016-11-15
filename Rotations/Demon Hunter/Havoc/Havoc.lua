function DemonHunterHavoc()
    if GetSpecializationInfo(GetSpecialization()) == 577 then
        if br.player == nil or br.player.profile ~= "Havoc" then
            br.player = cHavoc:new("Havoc")
            setmetatable(br.player, {__index = cHavoc})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
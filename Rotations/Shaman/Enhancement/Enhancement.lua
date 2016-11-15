function ShamanEnhancement()
    if GetSpecializationInfo(GetSpecialization()) == 263 then
        if br.player == nil or br.player.profile ~= "Enhancement" then
            br.player = cEnhancement:new("Enhancement")
            setmetatable(br.player, {__index = cEnhancement})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
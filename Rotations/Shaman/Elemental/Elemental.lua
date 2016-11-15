function ShamanElemental()
    if GetSpecializationInfo(GetSpecialization()) == 262 then
        if br.player == nil or br.player.profile ~= "Elemental" then
            br.player = cElemental:new("Elemental")
            setmetatable(br.player, {__index = cElemental})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
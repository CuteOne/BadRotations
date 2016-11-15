function PriestDiscipline()
    if GetSpecializationInfo(GetSpecialization()) == 256 then
        if br.player == nil or br.player.profile ~= "Discipline" then
            br.player = cDiscipline:new("Discipline")
            setmetatable(br.player, {__index = cDiscipline})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
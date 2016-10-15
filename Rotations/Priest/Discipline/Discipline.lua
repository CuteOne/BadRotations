function PriestDiscipline()
    if GetSpecializationInfo(GetSpecialization()) == 256 then
        if bb.player == nil or bb.player.profile ~= "Discipline" then
            bb.player = cDiscipline:new("Discipline")
            setmetatable(bb.player, {__index = cDiscipline})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
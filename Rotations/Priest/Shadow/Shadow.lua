function PriestShadow()
    if GetSpecializationInfo(GetSpecialization()) == 258 then
        if br.player == nil or br.player.profile ~= "Shadow" then
            br.player = cShadow:new("Shadow")
            setmetatable(br.player, {__index = cShadow})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end --Spec Function End
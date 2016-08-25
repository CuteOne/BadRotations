function ShamanElemental()
    if GetSpecializationInfo(GetSpecialization()) == 262 then
        if bb.player == nil or bb.player.profile ~= "Elemental" then
            bb.player = cElemental:new("Elemental")
            setmetatable(bb.player, {__index = cElemental})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
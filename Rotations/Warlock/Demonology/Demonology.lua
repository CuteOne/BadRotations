function WarlockDemonology()
    if GetSpecializationInfo(GetSpecialization()) == 266 then
        if bb.player == nil or bb.player.profile ~= "Demonology" then
            bb.player = cDemonology:new("Demonology")
            setmetatable(bb.player, {__index = cDemonology})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
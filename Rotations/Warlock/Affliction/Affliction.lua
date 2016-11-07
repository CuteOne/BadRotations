function WarlockAffliction()
    if GetSpecializationInfo(GetSpecialization()) == 265 then
        if bb.player == nil or bb.player.profile ~= "Affliction" then
            bb.player = cAffliction:new("Affliction")
            setmetatable(bb.player, {__index = cAffliction})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
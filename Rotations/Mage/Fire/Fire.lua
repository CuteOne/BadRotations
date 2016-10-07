function MageFire()
    if GetSpecializationInfo(GetSpecialization()) == 63 then
        if bb.player == nil or bb.player.profile ~= "Fire" then
            bb.player = cFire:new("Fire")
            setmetatable(bb.player, {__index = cFire})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
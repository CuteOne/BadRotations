function DemonHunterVengeance()
    if GetSpecializationInfo(GetSpecialization()) == 581 then
        if bb.player == nil or bb.player.profile ~= "Vengeance" then
            bb.player = cVengeance:new("Vengeance")
            setmetatable(bb.player, {__index = cVengeance})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
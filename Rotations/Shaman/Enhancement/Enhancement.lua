function ShamanEnhancement()
    if GetSpecializationInfo(GetSpecialization()) == 263 then
        if bb.player == nil or bb.player.profile ~= "Enhancement" then
            bb.player = cEnhancement:new("Enhancement")
            setmetatable(bb.player, {__index = cEnhancement})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
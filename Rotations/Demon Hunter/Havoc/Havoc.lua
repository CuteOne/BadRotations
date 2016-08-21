function DemonHunterHavoc()
    if GetSpecializationInfo(GetSpecialization()) == 577 then
        if bb.player == nil or bb.player.profile ~= "Havoc" then
            bb.player = cHavoc:new("Havoc")
            setmetatable(bb.player, {__index = cHavoc})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
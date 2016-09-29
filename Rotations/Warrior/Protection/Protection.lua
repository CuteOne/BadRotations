function WarriorProtection()
    if GetSpecializationInfo(GetSpecialization()) == 73 then
        if bb.player == nil or bb.player.profile ~= "Protection" then
            bb.player = cProtection:new("Protection")
            setmetatable(bb.player, {__index = cProtection})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
function DeathKnightBlood()
    if br.player == nil or br.player.profile ~= "Blood" then
        br.player = cBlood:new("Blood")
        setmetatable(br.player, {__index = cBlood})

        br.player:createOptions()
        br.player:createToggles()
        br.player:update()
    end

    br.player:update()
end
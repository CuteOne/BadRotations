function WarlockDestruction()
    if br.player == nil or br.player.profile ~= "Destruction" then
        br.player = cDestruction:new("Destruction")
        setmetatable(br.player, {__index = cDestruction})

        br.player:createOptions()
        br.player:createToggles()
        br.player:update()
    end

    br.player:update()
end
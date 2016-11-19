function DruidFeral()
    if br.player == nil or br.player.profile ~= "Feral" then
        br.player = cFeral:new("Feral")
        setmetatable(br.player, {__index = cFeral})

        br.player:createOptions()
        br.player:createToggles()
        br.player:update()
        -- br.tracker.onUpdate()
    end

    br.player:update()
    -- br.tracker.onUpdate()
end

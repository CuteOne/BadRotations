function HunterBeastmaster()
    if br.player == nil or br.player.profile ~= "Beastmaster" then
        br.player = cBeastmaster:new("Beastmaster")
        setmetatable(br.player, {__index = cBeastmaster})

        br.player:createOptions()
        br.player:createToggles()
        br.player:update()
        -- br.tracker.onUpdate()
    end

    br.player:update()
    -- br.tracker.onUpdate()
end

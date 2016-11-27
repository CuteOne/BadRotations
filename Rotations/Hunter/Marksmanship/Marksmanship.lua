function HunterMarksmanship()
    if br.player == nil or br.player.profile ~= "Marksmanship" then
        br.player = cMarksmanship:new("Marksmanship")
        setmetatable(br.player, {__index = cMarksmanship})

        br.player:createOptions()
        br.player:createToggles()
        br.player:update()
        -- br.tracker.onUpdate()
    end

    br.player:update()
    -- br.tracker.onUpdate()
end

if select(3, UnitClass("player")) == 10 then
    function MonkWindwalker()
        if bb.player == nil or bb.player.profile ~= "Windwalker" then
            bb.player = cWindwalker:new("Windwalker")
            setmetatable(bb.player, {__index = cWindwalker})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Monk Function End
end --Class Check End
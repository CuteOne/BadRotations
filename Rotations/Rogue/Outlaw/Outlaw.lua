if select(3, UnitClass("player")) == 4 then
    function RogueOutlaw()
        if bb.player == nil or bb.player.profile ~= "Outlaw" then
            bb.player = cOutlaw:new("Outlaw")
            setmetatable(bb.player, {__index = cOutlaw})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Rogue Function End
end --Class Check End
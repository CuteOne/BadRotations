if select(3, UnitClass("player")) == 6 then
    function FrostDK()
        if bb.player == nil or bb.player.profile ~= "Frost" then
            bb.player = cFrost:new("Frost")
            setmetatable(bb.player, {__index = cFrost})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Rogue Function End
end --Class Check End
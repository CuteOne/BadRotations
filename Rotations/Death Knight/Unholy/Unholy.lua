if select(3, UnitClass("player")) == 6 then
    function DeathKnightUnholy()
        if bb.player == nil or bb.player.profile ~= "Unholy" then
            bb.player = cUnholy:new("Unholy")
            setmetatable(bb.player, {__index = cUnholy})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
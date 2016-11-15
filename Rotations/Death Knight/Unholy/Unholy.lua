if select(3, UnitClass("player")) == 6 then
    function DeathKnightUnholy()
        if br.player == nil or br.player.profile ~= "Unholy" then
            br.player = cUnholy:new("Unholy")
            setmetatable(br.player, {__index = cUnholy})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end
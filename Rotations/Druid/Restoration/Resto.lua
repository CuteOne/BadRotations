if select(3, UnitClass("player")) == 11 then
    function DruidResto()
        if bb.player == nil or bb.player.profile ~= "Resto" then
            bb.player = cResto:new("Resto")
            setmetatable(bb.player, {__index = cResto})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end

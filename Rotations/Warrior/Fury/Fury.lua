if select(3, UnitClass("player")) == 1 then
    function FuryWarrior()
        if bb.player == nil or bb.player.profile ~= "Fury" then
            bb.player = cFury:new("Fury")
            setmetatable(bb.player, {__index = cFury})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end -- Function End
end --Class Check End
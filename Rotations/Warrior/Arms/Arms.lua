if select(3, UnitClass("player")) == 1 then
    function ArmsWarrior()
        if bb.player == nil or bb.player.profile ~= "Arms" then
            bb.player = cArms:new("Arms")
            setmetatable(bb.player, {__index = cArms})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end -- Function End
end --Class Check End
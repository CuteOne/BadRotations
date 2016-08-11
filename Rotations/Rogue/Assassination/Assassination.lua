if select(3, UnitClass("player")) == 4 then
    function RogueAssassination()
        if bb.player == nil or bb.player.profile ~= "Assassination" then
            bb.player = cAssassination:new("Assassination")
            setmetatable(bb.player, {__index = cAssassination})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Rogue Function End
end --Class Check End

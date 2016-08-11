if select(3, UnitClass("player")) == 4 then
    function RogueSubtlety()
        if bb.player == nil or bb.player.profile ~= "Subtlety" then
            bb.player = cSubtlety:new("Subtlety")
            setmetatable(bb.player, {__index = cSubtlety})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Rogue Function End
end --Class Check End
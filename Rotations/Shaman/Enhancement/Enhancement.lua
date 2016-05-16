if select(3, UnitClass("player")) == 7 then
    function ShamanEnhancement()
        if bb.player == nil or bb.player.profile ~= "Enhancement" then
            bb.player = cEnhancement:new("Enhancement")
            setmetatable(bb.player, {__index = cEnhancement})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end -- Function End
end --Class Check End
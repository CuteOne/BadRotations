if select(3, UnitClass("player")) == 6 then
    function FrostDK()
        if br.player == nil or br.player.profile ~= "Frost" then
            br.player = cFrost:new("Frost")
            setmetatable(br.player, {__index = cFrost})

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()

    end --Rogue Function End
end --Class Check End
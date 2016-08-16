if select(3, UnitClass("player")) == 2 then  -- Changed to name of class. IE: DRUID, DEATHKNIGHT
    function PaladinRetribution() -- Change to name of Class and Spec (called by Core.lua) IE: DruidFeral or MonkWindwalker
        if bb.player == nil or bb.player.profile ~= "Retribution" then -- Change "Spec" to name of spec IE: "Feral" or "Windwalker"
            bb.player = cRetribution:new("Retribution") -- change cSpec to name of spec IE: cFeral or cWindwalker also change "Spec" to name of spec IE: "Feral" or "Windwalker"
            setmetatable(bb.player, {__index = cRetribution}) -- -- change cSpec to name of spec IE: cFeral or cWindwalker
            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end
        bb.player:update()

    end --Spec Function End
end --Class Check End
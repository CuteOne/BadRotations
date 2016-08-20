if select(2, UnitClass("player")) == "PRIEST" then  -- Changed to name of class. IE: DRUID, DEATHKNIGHT
    function PriestShadow() -- Change to name of Class and Spec (called by Core.lua) IE: DruidFeral or MonkWindwalker
        if bb.player == nil or bb.player.profile ~= "Shadow" then -- Change "Spec" to name of spec IE: "Feral" or "Windwalker"
            bb.player = cShadow:new("Shadow") -- change cSpec to name of spec IE: cFeral or cWindwalker also change "Spec" to name of spec IE: "Feral" or "Windwalker"
            setmetatable(bb.player, {__index = cShadow}) -- -- change cSpec to name of spec IE: cFeral or cWindwalker

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()

    end --Spec Function End
end --Class Check End
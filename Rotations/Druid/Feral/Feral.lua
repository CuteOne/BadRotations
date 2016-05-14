if select(3, UnitClass("player")) == 11 then
    function DruidFeral()
        if bb.player == nil or bb.player.profile ~= "Feral" then
            bb.player = cFeral:new("Feral")
            setmetatable(bb.player, {__index = cFeral})

            bb.player:createOptions()
            bb.player:createToggles()
            bb.player:update()
        end

        bb.player:update()
    end
end
        -- if Currentconfig ~= "Feral CuteOne" and FeralCuteOne == nil then
--             --FeralOptions()
--             FeralCuteOne = cFeral:new()
--             setmetatable(FeralCuteOne, {__index = cFeral})
--             FeralCuteOne:update()
--             KeyToggles()
--             Currentconfig = "Feral CuteOne"
--         end

--         if not canRun() then
--             return true
--         end

--         -- ToDo add pause toggle
--         -- Manual Input
--         -- if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
--         -- return true
--         -- end
--         -- if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
--         -- return true
--         -- end
--         -- if IsLeftAltKeyDown() then
--         --     return true
--         -- end

--         FeralCuteOne:update()

--     end --DruidFeral Function End
-- end --Class Check End


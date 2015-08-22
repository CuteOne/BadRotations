if select(3, UnitClass("player")) == 11 then
    function DruidFeral()
        if Currentconfig ~= "Feral CuteOne" and druidFeral == nil then
            --FeralOptions()
            druidFeral = cFeral:new()
            setmetatable(druidFeral, {__index = cFeral})
            KeyToggles()
            druidFeral:update()
            Currentconfig = "Feral CuteOne"
        end

        if not canRun() then
            return true
        end

        -- ToDo add pause toggle
        -- Manual Input
        -- if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
        -- return true
        -- end
        -- if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
        -- return true
        -- end
        if IsLeftAltKeyDown() then
            return true
        end

        druidFeral:update()

    end --DruidFeral Function End
end --Class Check End


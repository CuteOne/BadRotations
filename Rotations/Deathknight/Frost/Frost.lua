if select(3, UnitClass("player")) == 6 then
    function FrostDK()
        if Currentconfig ~= "Frost DK CuteOne" and FrostCuteOne == nil then
            --FeralOptions()
            FrostCuteOne = cFrost:new()
            setmetatable(FrostCuteOne, {__index = cFrost})
            FrostCuteOne:update()
            KeyToggles()
            Currentconfig = "Frost DK CuteOne"
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
        -- if IsLeftAltKeyDown() then
        --     return true
        -- end

        FrostCuteOne:update()

    end --Rogue Function End
end --Class Check End
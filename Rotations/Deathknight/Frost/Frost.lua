if select(3, UnitClass("player")) == 4 then
    function FrostDK()
        if Currentconfig ~= "Frost DK CuteOne" and deathKnightFrost == nil then
            --AssOptions()
            deathKnightFrost = cFrost:new()
            setmetatable(deathKnightFrost, {__index = cFrost})
            KeyToggles()
            deathKnightFrost:update()
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

        deathKnightFrost:update()

    end --Rogue Function End
end --Class Check End
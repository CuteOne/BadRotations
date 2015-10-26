if select(3, UnitClass("player")) == 6 then
    function FrostDK()
        if frostDeathknight == nil then
            frostDeathknight = cFrost:new()
            setmetatable(frostDeathknight, {__index = cFrost})
            frostDeathknight:update()
            KeyToggles()
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

        frostDeathknight:update()

    end --Rogue Function End
end --Class Check End
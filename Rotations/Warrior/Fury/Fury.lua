if select(3, UnitClass("player")) == 1 then
    function FuryWarrior()
        if furyWarrior == nil then
            furyWarrior = cFury:new()
            setmetatable(furyWarrior, {__index = cFury})
            furyWarrior:update()
            --KeyToggles()
            if furyWarrior.rotation == 1 then 
                FuryKeyToggles();
            end
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

        furyWarrior:update()

    end -- Function End
end --Class Check End
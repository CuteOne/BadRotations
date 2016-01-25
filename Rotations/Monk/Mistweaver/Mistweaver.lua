if select(3, UnitClass("player")) == 10 then
    function MistweaverMonk()
        if Currentconfig ~= "Mistweaver Monk" and mistweaverMonk == nil then
            mistweaverMonk = cMistweaver:new()
            setmetatable(mistweaverMonk, {__index = cMistweaver})
            mistweaverMonk:update()
            --KeyToggles()
            if mistweaverMonk.rotation == 1 then 
                MistweaverToggles()
            --    MistweaverConfig() 
            end
            Currentconfig = "Mistweaver Monk"
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

        mistweaverMonk:update()

    end --Monk Function End
end --Class Check End
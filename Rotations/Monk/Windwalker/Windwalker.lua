if select(3, UnitClass("player")) == 10 then
    function WindwalkerMonk()
        if Currentconfig ~= "Windwalker Monk" and windwalkerMonk == nil then
            windwalkerMonk = cWindwalker:new()
            setmetatable(windwalkerMonk, {__index = cWindwalker})
            windwalkerMonk:update()
            --KeyToggles()
            if windwalkerMonk.rotation == 1 then 
                WindwalkerToggles()
                -- WindwalkerConfig() 
            end
            if windwalkerMonk.rotation == 2 then 
                MonkWwToggles()
                -- MonkWwOptions() 
            end
            Currentconfig = "Windwalker Monk"
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

        windwalkerMonk:update()

    end --Monk Function End
end --Class Check End
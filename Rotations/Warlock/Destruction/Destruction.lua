if select(3, UnitClass("player")) == 9 then
    function DestructionWarlock()
        if Currentconfig ~= "Destruction Warlock" and destructionWarlock == nil then
            destructionWarlock = cDestruction:new()
            setmetatable(destructionWarlock, {__index = cDestruction})
            destructionWarlock:update()
            --KeyToggles()
            if destructionWarlock.rotation == 1 then 
              --  DestructionToggles()
                DestructionConfig() 
            end
            Currentconfig = "Destruction Warlock"
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

        destructionWarlock:update()

    end --Warlock Function End
end --Class Check End
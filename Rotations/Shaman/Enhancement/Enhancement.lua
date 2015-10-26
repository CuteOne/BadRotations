if select(3, UnitClass("player")) == 7 then
    function ShamanEnhancement()
        if enhancementShaman == nil then
            enhancementShaman = cEnhancement:new()
            setmetatable(enhancementShaman, {__index = cEnhancement})
            enhancementShaman:update()
            --KeyToggles()
            if enhancementShaman.rotation == 1 then 
                KeyToggles()
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

        enhancementShaman:update()

    end -- Function End
end --Class Check End
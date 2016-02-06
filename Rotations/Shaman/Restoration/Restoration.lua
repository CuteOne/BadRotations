if select(3, UnitClass("player")) == 7 then
    function ShamanRestoration()
        if Currentconfig ~= "Restoration Shaman" and restorationShaman == nil then
            restorationShaman = cRestoration:new()
            setmetatable(restorationShaman, {__index = cRestoration})
            restorationShaman:update()
            --KeyToggles()
            if restorationShaman.rotation == 1 then 
                RestorationToggles()
                RestorationConfig()
            end
            Currentconfig = "Restoration Shaman"
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

        restorationShaman:update()

    end --Monk Function End
end --Class Check End
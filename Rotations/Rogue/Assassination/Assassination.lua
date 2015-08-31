if select(3, UnitClass("player")) == 4 then
    function AssassinationRogue()
        if Currentconfig ~= "Assassination CuteOne" and rogueAssassination == nil then
            --AssOptions()
            rogueAssassination = cAssassination:new()
            setmetatable(rogueAssassination, {__index = cAssassination})
            AssToggles()
            rogueAssassination:update()
            Currentconfig = "Assassination CuteOne"
        end

        if not canRun() then
            return true
        end
        --poisonAssData()
        --GroupInfo()
        --makeEnemiesTable(40)
        --getLoot2()

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

        rogueAssassination:update()

    end --Rogue Function End
end --Class Check End

if select(3, UnitClass("player")) == 1 then
    function ArmsWarrior()
        if armsWarrior == nil then
            armsWarrior = cArms:new()
            setmetatable(armsWarrior, {__index = cArms})
            armsWarrior:update()
            --KeyToggles()
            if armsWarrior.rotation == 1 then 
                WarriorArmsToggles();
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

        armsWarrior:update()

    end -- Function End
end --Class Check End
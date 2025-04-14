---
-- These functions help in retrieving information about or manipulating UI elements.
-- UI functions are stored in br.player.ui and can be utilized by `local ui = br.player.ui` in your profile.
-- @module br.player.ui
local _, br = ...
if br.api == nil then br.api = {} end

br.api.ui = function(self)
    local ui = self.ui
    if ui ~= nil and ui.mode == nil then ui.mode = {} end

    --- Checks if the passed option is set to "Always, CD, or Never"
    -- @function ui.alwaysCdNever
    -- @string thisOption - Name of the option from the defined profile options.
    -- @return boolean - Returns true if the option is set to Always or if CD is selected and CDs are enabled
    ui.alwaysCdNever = function(thisOption)
        -- Option Dropdown Requires
        -- {"|cff008000Always", "|cff0000ffCD", "|cffff0000Never"}
        if br.data.settings[br.selectedSpec][br.selectedProfile]["Rotation Options"] == nil then return 0 end
        thisOption = br.data.settings[br.selectedSpec][br.selectedProfile]["Rotation Options"][thisOption] ~= nil and
            ui.value(thisOption, "Rotation Options") or
            ui.value(thisOption, "Base Options")
        return thisOption == 1 or (thisOption == 2 and ui.useCDs())
    end

    --- Checks if the passed option is set to "Always, AOE/CD, CD, or Never"
    -- @function ui.alwaysCdAoENever
    -- @string thisOption - Name of the option from the defined profile options.
    -- @number[opt=3] minUnits - Minimum Number of units to count for AOE checks.
    -- @number[opt] enemyCount - Number of enemies for a given range, default is the number of enemies in 40yrds.
    -- @return boolean - Returns true based on selected option and current combat conditions
    ui.alwaysCdAoENever = function(thisOption, minUnits, enemyCount)
        -- Option Dropdown Requires
        -- {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
        if br.data.settings[br.selectedSpec][br.selectedProfile]["Rotation Options"] == nil then return 0 end
        thisOption = br.data.settings[br.selectedSpec][br.selectedProfile]["Rotation Options"][thisOption] ~= nil and
            ui.value(thisOption, "Rotation Options") or
            ui.value(thisOption, "Base Options")
        minUnits = minUnits or 3
        enemyCount = enemyCount or #br.getEnemies("player", 40, false, true)
        return thisOption == 1
            or (thisOption == 2 and enemyCount >= minUnits)
            or (thisOption == 3 and (ui.useCDs() or enemyCount >= minUnits))
            or (thisOption == 4 and ui.useCDs())
    end

    if ui.chatOverlay == nil then
        --- Displays the passed text as an overlay on the chat windows
        -- @function ui.chatOverlay
        -- @string text - The text to display.
        -- @return nil
        ui.chatOverlay = function(text)
            return br.ChatOverlay(text)
        end
    end

    if ui.checked == nil then
        --- Checks if the passed option is enabled
        -- @function ui.checked
        -- @string thisOption - Name of the option from the defined profile options.
        -- @string[opt] optionPage - The page where the option is located.
        -- @return boolean - Returns true if the option is checked
        ui.checked = function(thisOption, optionPage)
            if thisOption == nil then return false end
            return br.isChecked(thisOption, optionPage)
        end
    end

    if ui.debug == nil then
        --- Displays the text as a debug message in chat (if Addon Debug Messages option is enabled)
        -- @function ui.debug
        -- @string text - The message to show in chat.
        -- @return nil
        ui.debug = function(text)
            return br.addonDebug(text)
        end
    end

    if ui.delay == nil then
        --- Returns false unless the specified delay time has passed since it was last true
        -- @function ui.delay
        -- @string delayName - The name of the delay check, should be unique.
        -- @number delayTime - The length of time to wait until true, in seconds.
        -- @return boolean - Returns true if the delay time has passed
        ui.delay = function(delayName, delayTime)
            return br.timer:useTimer(delayName, delayTime)
        end
    end

    if ui.fullBags == nil then
        --- Checks if your bags are full
        -- @function ui.fullBags
        -- @return boolean - Returns true if bags are full
        ui.fullBags = function()
            return br.lootManager:emptySlots() == 0
        end
    end

    if ui.isMouseDown == nil then
        --- Checks if the mouse button specified is down, or any if none are specified
        -- @function ui.isMouseDown
        -- @string[opt] mouseButton - Name of the mouse button.
        -- @return boolean - Returns true if the specified mouse button is down
        ui.isMouseDown = function(mouseButton)
            local mouseDown = br._G.IsMouseButtonDown
            if mouseButton == nil then
                return mouseDown("LeftButton") or mouseDown("RightButton") or mouseDown("MiddleButton") or
                    mouseDown("Button4") or mouseDown("Button5")
            else
                return mouseDown(mouseButton)
            end
        end
    end

    if ui.pause == nil then
        --- Returns true if special conditions are met to pause
        -- @see br.pause for these conditions
        -- @function ui.pause
        -- @boolean[opt=false] ignoreChannel - Set to true to ignore pausing on channel casts
        -- @return boolean - Returns true if rotation should be paused
        ui.pause = function(ignoreChannel)
            --local pause = br._G["pause"]
            if ignoreChannel == nil then ignoreChannel = false end
            return br.pause(ignoreChannel)
        end
    end

    if ui.print == nil then
        --- Shows the specified message in chat.
        -- @function ui.print
        -- @string msg - The message to show in chat.
        -- @return nil
        ui.print = function(msg)
            return br._G.print(msg)
        end
    end

    -- if ui.print == nil then
    --     ui.print = function(text)
    --         local Print = br._G["Print"]
    --         return Print(text)
    --     end
    -- end

    if ui.pullTimer == nil then
        --- Returns the time remaining on the pull timer (DBM/BigWigs)
        -- @function ui.pullTimer
        -- @return number - Returns seconds remaining on pull timer
        ui.pullTimer = function()
            --local PullTimerRemain = br._G["PullTimerRemain"]
            return br.PullTimerRemain()
        end
    end

    if ui.time == nil then
        --- Returns the time, value of GetTime
        -- @function ui.time
        -- @return number - Returns the current game time
        ui.time = function()
            return br._G.GetTime()
        end
    end

    if ui.timer == nil then
        --- Returns false unless the specified interval has passed since it was last true
        -- @function ui.timer
        -- @string timerName - The name of the timer check, should be unique.
        -- @number interval - The length of time to wait until true, in seconds.
        -- @return boolean - Returns true if the interval has passed
        ui.timer = function(timerName, interval)
            return br.timer:useTimer(timerName, interval)
        end
    end

    if ui.toggle == nil then
        --- Checks if the specified toggle from the toggle options is pressed
        -- @function ui.toggle
        -- @string thisToggle - Name of the toggle to check.
        -- @return boolean - Returns true if the toggle is active
        ui.toggle = function(thisToggle)
            return not br._G.GetCurrentKeyBoardFocus() and br.SpecificToggle(thisToggle) or false
        end
    end

    if ui.useAOE == nil then
        --- Checks if the specified parameters are valid for AOE, based on Rotation toggle setting.
        -- @function ui.useAOE
        -- @number[opt=8] range - The range of the AOE damage in yards.
        -- @number[opt=3] minCount - The minimum number of units to be in range before true
        -- @string[opt="player"] useTarget - the reference unit to check range and units against.
        -- @return boolean - Returns true if AOE should be used
        ui.useAOE = function(range, minCount, useTarget)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            if useTarget == nil then useTarget = "player" end
            local _, enemyCount = self.enemies.get(range, useTarget)
            return ((ui.mode.rotation == 1 and enemyCount >= minCount) or (ui.mode.rotation == 2 and enemyCount > 0))
        end
    end

    if ui.useCDs == nil then
        --- Check if Cooldowns should be used or not based on CD toggle setting.
        -- @function ui.useCDs
        -- @return boolean - Returns true if cooldowns should be used
        ui.useCDs = function()
            local hasBloodLust = br._G["hasBloodLust"]
            return (ui.mode.cooldown == 1 and br.isBoss())
                or ui.mode.cooldown == 2
                or (ui.mode.cooldown == 4 and hasBloodLust())
        end
    end

    if ui.useDefensive == nil then
        --- Check if Defensives should be used or not based on Defensive toggle setting.
        -- @function ui.useDefensive
        -- @return boolean - Returns true if defensive abilities should be used
        ui.useDefensive = function()
            return ui.mode.defensive == 1
        end
    end

    if ui.useInterrupt == nil then
        --- Check if Interrupts should be used or not based on Interrupt toggle setting.
        -- @function ui.useInterrupt
        -- @return boolean - Returns true if interrupts should be used
        ui.useInterrupt = function()
            return ui.mode.interrupt == 1
        end
    end

    if ui.useST == nil then
        --- Checks if the specified parameters are valid for Single Target, based on Rotation toggle setting.
        -- @function ui.useST
        -- @number[opt=8] range - The range of the AOE damage in yards.
        -- @number[opt=3] minCount - The minimum number of units to be in range before true
        -- @string[opt="player"] useTarget - the reference unit to check range and units against.
        -- @return boolean - Returns true if single target abilities should be used
        ui.useST = function(range, minCount, useTarget)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            if useTarget == nil then useTarget = "player" end
            local _, enemyCount = self.enemies.get(range, useTarget)
            return ((ui.mode.rotation == 1 and enemyCount < minCount) or (ui.mode.rotation == 3 and enemyCount > 0))
        end
    end

    if ui.useTrinkets == nil then
        --- Checks if the option to use trinkets are valid per each Trinket slot.
        -- @function ui.useTrinkets
        -- @number trinket - The item id of the trinket to check for.
        -- @return boolean - Returns true if the trinket should be used
        ui.useTrinkets = function(trinket)
            for slotID = 13, 14 do
                -- local useTrinket = (opValue == 1 or (opValue == 2 and (ui.useCDs() or ui.useAOE())) or (opValue == 3 and ui.useCDs()))
                if self.use.able.slot(slotID)
                    and ui.alwaysCdAoENever("Trinket " .. slotID - 12)
                    and self.equiped.item(trinket, slotID)
                then
                    return true
                end
            end
            return false
        end
    end

    if ui.value == nil then
        --- Returns the value of the specified option.
        -- @function ui.value
        -- @string thisOption - The name of the option specified in the options section
        -- @string[opt] optionPage - The page where the option is located.
        -- @return number - Returns the value of the specified option
        ui.value = function(thisOption, optionPage)
            if thisOption == nil then return 0 end
            return br.getOptionValue(thisOption, optionPage)
        end
    end
end

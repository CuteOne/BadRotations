---
-- These functions help in retrieving information about or manipulating UI elements.
-- UI functions are stored in br.player.ui and can be utilized by `local ui = br.player.ui` in your profile.
-- @module br.player.ui
local _, br = ...
if br.api == nil then br.api = {} end

br.api.ui = function(self)
    local ui --= self.ui
    if ui ~= nil and ui.mode == nil then ui.mode = {} end

    --- Checks if the passed option is set to "Always, CD, or Never"
    -- @function ui.alwaysCdNever
    -- @string thisOption - Name of the option from the defined profile options.
    -- @returns boolean
    ui.alwaysCdNever = function(thisOption)
        -- Option Dropdown Requires
        -- {"|cff008000Always", "|cff0000ffCD", "|cffff0000Never"}
        thisOption = ui.value(thisOption)
        return thisOption == 1 or (thisOption == 2 and ui.useCDs())
    end

    --- Checks if the passed option is set to "Always, AOE/CD, CD, or Never"
    -- @function ui.alwaysCdAoENever
    -- @string thisOption - Name of the option from the defined profile options.
    -- @number[opt=3] minUnits - Minimum Number of units to cound for AOE checks.
    -- @number[opt] enemyCount - Number of enemies for a given range, default is the number of enemies in 40yrds.
    -- @returns boolean
    ui.alwaysCdAoENever = function(thisOption, minUnits, enemyCount)
        -- Option Dropdown Requires
        -- {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
        thisOption = ui.value(thisOption)
        minUnits = minUnits or 3
        enemyCount = enemyCount or #br.getEnemies("player",40,false,true)
        return thisOption == 1
            or (thisOption == 2 and enemyCount >= minUnits)
            or (thisOption == 3 and (ui.useCDs() or enemyCount >= minUnits))
            or (thisOption == 4 and ui.useCDs())
    end

    if ui.chatOverlay == nil then
        --- Displays the passed text as an overlay on the chat windows
        -- @function ui.chatOverlay
        -- @string text - The text to display.
        ui.chatOverlay = function(text)
            return br.ChatOverlay(text)
        end
    end

    if ui.checked == nil then
        --- Checks if the passed option is enabled
        -- @function ui.checked
        -- @string thisOption - Name of the option from the defined profile options.
        -- @return boolean
        ui.checked = function(thisOption)
            if thisOption == nil then return false end
            return br.isChecked(thisOption)
        end
    end

    if ui.debug == nil then
        --- Displays the text as a debug message in chat (if Addon Debug Messages option is enabled)
        -- @function ui.debug
        -- @string text - The message to show in chat.
        ui.debug = function(text)
            return br.addonDebug(text)
        end
    end

    if ui.delay == nil then
        --- Returns false unless the specified delay time has passed since it was last true
        -- @function ui.delay
        -- @string delayName - The name of the delay check, should be unique.
        -- @number delayTime - The length of time to wait until true, in seconds.
        -- @return boolean
        ui.delay = function(delayName, delayTime)
            return br.timer:useTimer(delayName, delayTime)
        end
    end

    if ui.fullBags == nil then
        --- Checks if your bags are full
        -- @function ui.fullBags
        -- @return boolean
        ui.fullBags = function()
            return br.lootManager:emptySlots() == 0
        end
    end

    if ui.isMouseDown == nil then
        --- Checks if the mouse button specified is down, or any if none are specified
        -- @function ui.isMouseDown
        -- @string[opt] mouseButton - Name of the mouse button.
        -- @return boolean
        ui.isMouseDown = function(mouseButton)
            local mouseDown = br._G.IsMouseButtonDown
            if mouseButton == nil then
                return mouseDown("LeftButton") or mouseDown("RightButton") or mouseDown("MiddleButton") or mouseDown("Button4") or mouseDown("Button5")
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
        -- @return boolean
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
        -- @return number
        ui.pullTimer = function()
            --local PullTimerRemain = br._G["PullTimerRemain"]
            return br.PullTimerRemain()
        end
    end

    if ui.time == nil then
        --- Returns the time, value of GetTime
        -- @function ui.time
        -- return number
        ui.time = function()
            return br._G.GetTime()
        end
    end

    if ui.timer == nil then
        --- Returns false unless the specified interval has passed since it was last true
        -- @function ui.timer
        -- @string timerName - The name of the timer check, should be unique.
        -- @number interval - The length of time to wait until true, in seconds.
        -- @return boolean
        ui.timer = function(timerName, interval)
            return br.timer:useTimer(timerName, interval)
        end
    end

    if ui.toggle == nil then
        --- Checks if the specified toggle from the toggle options is pressed
        -- @function ui.toggle
        -- @string thisToggle - Name of the toggle to check.
        -- @return boolean
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
        ui.useAOE = function(range,minCount,useTarget)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            if useTarget == nil then useTarget = "player" end
            return ((ui.mode.rotation == 1 and #self.enemies.get(range,useTarget) >= minCount) or (ui.mode.rotation == 2 and #self.enemies.get(range, useTarget) > 0))
        end
    end

    if ui.useCDs == nil then
        --- Check if Cooldowns should be used or not based on CD toggle setting.
        -- @function ui.useCDs
        -- @return boolean
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
        -- @return boolean
        ui.useDefensive = function()
            return ui.mode.defensive == 1
        end
    end

    if ui.useInterrupt == nil then
        --- Check if Interrupts should be used or not based on Interrupt toggle setting.
        -- @function ui.useInterrupt
        -- @return boolean
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
        ui.useST = function(range,minCount,useTarget)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            if useTarget == nil then useTarget = "player" end
            return ((ui.mode.rotation == 1 and #self.enemies.get(range,useTarget) < minCount) or (ui.mode.rotation == 3 and #self.enemies.get(range, useTarget) > 0))
        end
    end

    if ui.value == nil then
        --- Returns the value of the specified option.
        -- @function ui.value
        -- @string thisOption - The name of the option specified in the options section
        -- @return number
        ui.value = function(thisOption)
            if thisOption == nil then return 0 end
            return br.getOptionValue(thisOption)
        end
    end
end

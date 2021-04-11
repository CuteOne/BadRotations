local _, br = ...
if br.api == nil then br.api = {} end
br.api.ui = function(self)
    local ui = self.ui
    if ui ~= nil and ui.mode == nil then ui.mode = {} end
    ui.alwaysCdNever = function(thisOption)
        thisOption = ui.value(thisOption)
        return thisOption == 1 or (thisOption == 2 and ui.useCDs())
    end
    ui.alwaysCdAoENever = function(thisOption, minUnits, enemyCount)
        thisOption = ui.value(thisOption)
        minUnits = minUnits or 3
        enemyCount = enemyCount or 0
        return thisOption == 1 or (thisOption == 2 and ui.useCDs()) or (thisOption == 3 and (ui.useCDs() or enemyCount >= minUnits))
    end
    if ui.chatOverlay == nil then
        ui.chatOverlay = function(text)
            return br.ChatOverlay(text)
        end
    end
    if ui.checked == nil then
        ui.checked = function(thisOption)
            if thisOption == nil then return false end
            return br.isChecked(thisOption)
        end
    end
    if ui.debug == nil then
        ui.debug = function(text)
            return br.addonDebug(text)
        end
    end
    if ui.fullBags == nil then
        ui.fullBags = function()
            return br.lootManager:emptySlots() == 0
        end
    end
    if ui.pause == nil then
        ui.pause = function(ignoreChannel)
            --local pause = _G["pause"]
            if ignoreChannel == nil then ignoreChannel = false end
            return br.pause(ignoreChannel)
        end
    end
    if ui.print == nil then
        ui.print = function(msg)
            return br._G.print(msg)
        end
    end
    if ui.pullTimer == nil then
        ui.pullTimer = function()
            --local PullTimerRemain = _G["PullTimerRemain"]
            return br.PullTimerRemain()
        end
    end
    if ui.toggle == nil then
        ui.toggle = function(thisToggle)
            return not br._G.GetCurrentKeyBoardFocus() and br.SpecificToggle(thisToggle) or false
        end
    end
    if ui.value == nil then
        ui.value = function(thisOption)
            if thisOption == nil then return 0 end
            return br.getOptionValue(thisOption)
        end
    end
    if ui.useAOE == nil then
        ui.useAOE = function(range,minCount,useTarget)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            if useTarget == nil then useTarget = "player" end
            return ((ui.mode.rotation == 1 and #self.enemies.get(range,useTarget) >= minCount) or (ui.mode.rotation == 2 and #self.enemies.get(range, useTarget) > 0))
        end
    end
    if ui.useCDs == nil then
        ui.useCDs = function()
            local hasBloodLust = _G["hasBloodLust"]
            return (ui.mode.cooldown == 1 and br.isBoss())
                or ui.mode.cooldown == 2
                or (ui.mode.cooldown == 4 and hasBloodLust())
        end
    end
    if ui.useDefensive == nil then
        ui.useDefensive = function()
            return ui.mode.defensive == 1
        end
    end
    if ui.useInterrupt == nil then
        ui.useInterrupt = function()
            return ui.mode.interrupt == 1
        end
    end
    if ui.useST == nil then
        ui.useST = function(range,minCount,useTarget)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            if useTarget == nil then useTarget = "player" end
            return ((ui.mode.rotation == 1 and #self.enemies.get(range,useTarget) < minCount) or (ui.mode.rotation == 3 and #self.enemies.get(range, useTarget) > 0))
        end
    end
    if ui.print == nil then
        ui.print = function(text)
            local Print = _G["Print"]
            return Print(text)
        end
    end
end
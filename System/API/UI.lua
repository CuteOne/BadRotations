local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.ui = function(self)
    local ui = self.ui
    if ui ~= nil and ui.mode == nil then ui.mode = {} end
    ui.alwaysCdNever = function(thisOption)
        local thisOption = ui.value(thisOption)
        return thisOption == 1 or (thisOption == 2 and ui.useCDs())
    end
    if ui.chatOverlay == nil then
        ui.chatOverlay = function(text)
            local ChatOverlay = _G["ChatOverlay"]
            return ChatOverlay(text)
        end
    end
    if ui.checked == nil then
        ui.checked = function(thisOption)
            local isChecked = _G["isChecked"]
            if thisOption == nil then return false end
            return isChecked(thisOption)
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
            local pause = _G["pause"]
            if ignoreChannel == nil then ignoreChannel = false end
            return pause(ignoreChannel)
        end
    end
    if ui.pullTimer == nil then 
        ui.pullTimer = function()
            local PullTimerRemain = _G["PullTimerRemain"]
            return PullTimerRemain()
        end
    end
    if ui.toggle == nil then
        ui.toggle = function(thisToggle)
            local SpecificToggle = _G["SpecificToggle"]
            return not GetCurrentKeyBoardFocus() and SpecificToggle(thisToggle) or false
        end
    end
    if ui.value == nil then
        ui.value = function(thisOption)
            local getOptionValue = _G["getOptionValue"]
            if thisOption == nil then return 0 end
            return getOptionValue(thisOption)
        end
    end
    if ui.useAOE == nil then
        ui.useAOE = function(range,minCount)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            return ((ui.mode.rotation == 1 and #self.enemies.get(range) >= minCount) or (ui.mode.rotation == 2 and #self.enemies.get(range) > 0))
        end
    end
    if ui.useCDs == nil then
        ui.useCDs = function()
            local isBoss = _G["isBoss"]
            local hasBloodLust = _G["hasBloodLust"]
            return (ui.mode.cooldown == 1 and isBoss())
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
        ui.useST = function(range,minCount)
            if range == nil then range = 8 end
            if minCount == nil then minCount = 3 end
            return ((ui.mode.rotation == 1 and #self.enemies.get(range) < minCount) or (ui.mode.rotation == 3 and #self.enemies.get(range) > 0))
        end
    end
    if ui.print == nil then
        ui.print = function(text)
            local Print = _G["Print"]
            return Print(text)
        end
    end
end
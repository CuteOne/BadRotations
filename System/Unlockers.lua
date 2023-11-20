local _, br = ...
local b = br._G

function br:loadUnlockerAPI()
    local unlocked = false
    --local class = self.class
    if self.unlock["NNUnlock"] ~= nil and self.unlock:NNUnlock() then
        unlocked = true
    elseif self.unlock["TinkrUnlock"] ~= nil and self.unlock.TinkrUnlock() then
        unlocked = true
    elseif self.unlock["DaemonicUnlock"] ~= nil and self.unlock.DaemonicUnlock() then
        unlocked = true
    end
    -- Set Spell Queue Window
    --if class == 8 or class == 9 then
        if unlocked and self.prevQueueWindow ~= 400 then
            b.RunMacroText("/console SpellQueueWindow 400")
        end
    --else
    --     if unlocked and self.prevQueueWindow ~= 0 then
    --         b.RunMacroText("/console SpellQueueWindow 0")
    --     end
    -- end
    return unlocked
end

-- Checks for BR Out of Date with current version based on TOC file
local brlocVersion
local brcurrVersion
local brUpdateTimer
function br:checkBrOutOfDate()
    brlocVersion = b.C_AddOns.GetAddOnMetadata(self.addonName, "Version")
    if (not brUpdateTimer or (b.GetTime() - brUpdateTimer) > 300) and self.player ~= nil then
        local startTime = b.debugprofilestop()
        -- Request Current Version from GitHub
        if b["EasyWoWToolbox"] ~= nil then -- EWT
            --SendHTTPRequest('https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc', nil,
                --function(body) brcurrVersion =(string.match(body, "(%d+%p%d+%p%d+)")) end)

            -- Check for commit updates from System/Updater.lua, which relies on EWT
            self.updater:CheckOutdated()
            brUpdateTimer = b.GetTime()
        elseif b["wmbapi"] ~= nil then -- MB
            local info = {
                Url = "https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc",
                Method = "GET"
            }
            if not self.locVersionRequest then
                self.locVersionRequest = b["SendHTTPRequest"](info)
            else
                self.locVersionStatus, self.locVersionResponce = b["wmbapi"].ReceiveHttpResponse(self.locVersionRequest)
                if self.locVersionResponce then
                    brcurrVersion = string.match(self.locVersionResponce.Body, "(%d+%p%d+%p%d+)")
                end
            end
            -- Check against current version installed
            if brlocVersion and brcurrVersion then
                -- Print("Local: "..tostring(brlocVersion).." | Remote: "..tostring(brcurrVersion))
                local brcleanCurr = b.gsub(tostring(brcurrVersion), "%p", "")
                local brcleanLoc = b.gsub(tostring(brlocVersion), "%p", "")
                if tonumber(brcleanCurr) ~= tonumber(brcleanLoc) then
                    local msg =
                        "BadRotations is currently out of date. Local Version: " ..
                        brlocVersion .. " Current Version: " .. brcurrVersion
                            .. ".  Please download latest version for best performance."
                    if self.isChecked("Overlay Messages") then
                        b["RaidNotice_AddMessage"](b["RaidWarningFrame"], msg, {r = 1, g = 0.3, b = 0.1})
                    else
                        b.print(msg)
                    end
                end
            end
            brUpdateTimer = b.GetTime()
        end
        self.debug.cpu:updateDebug(startTime, "outOfDate")
    end
end


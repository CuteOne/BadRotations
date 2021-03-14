local _, br = ...
local b = br._G
function br:loadUnlockerAPI()
    local unlocked = false
    local class = br.class
    if _G.lb then
        unlocked = br.unlock.LBUnlock()
    elseif _G.EWT then
        unlocked = br.unlock.EWTUnlock()
    elseif _G.wmbapi then
        unlocked = br.unlock.MBUnlock()
    elseif _G.UCSLoaded then
        _G.br = br
    elseif _G.CallSecureFunction then
        unlocked = br.unlock.WowAdUnlock()
    else
        unlocked = false
    end
    -- Set Spell Queue Window
    --if class == 8 or class == 9 then
        if unlocked and br.prevQueueWindow ~= 400 then
            b.RunMacroText("/console SpellQueueWindow 400")
        end
    --else
    --     if unlocked and br.prevQueueWindow ~= 0 then
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
    brlocVersion = b.GetAddOnMetadata(br.addonName, "Version")
    if (not brUpdateTimer or (b.GetTime() - brUpdateTimer) > 300) and br.player ~= nil then --and EasyWoWToolbox ~= nil then
        local startTime = b.debugprofilestop()
        -- Request Current Version from GitHub
        if EasyWoWToolbox ~= nil then -- EWT
            --SendHTTPRequest('https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc', nil, function(body) brcurrVersion =(string.match(body, "(%d+%p%d+%p%d+)")) end)

            -- Check for commit updates from System/Updater.lua, which relies on EWT
            br.updater:CheckOutdated()
            brUpdateTimer = b.GetTime()
        elseif wmbapi ~= nil then -- MB
            local info = {
                Url = "https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc",
                Method = "GET"
            }
            if not br.locVersionRequest then
                br.locVersionRequest = b.SendHTTPRequest(info)
            else
                br.locVersionStatus, br.locVersionResponce = wmbapi.ReceiveHttpResponse(br.locVersionRequest)
                if br.locVersionResponce then
                    brcurrVersion = string.match(br.locVersionResponce.Body, "(%d+%p%d+%p%d+)")
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
                        brlocVersion .. " Current Version: " .. brcurrVersion .. ".  Please download latest version for best performance."
                    if br.isChecked("Overlay Messages") then
                        b.RaidNotice_AddMessage(b.RaidWarningFrame, msg, {r = 1, g = 0.3, b = 0.1})
                    else
                        b.print(msg)
                    end
                end
            end
            brUpdateTimer = b.GetTime()
        end
        br.debug.cpu:updateDebug(startTime, "outOfDate")
    end
end

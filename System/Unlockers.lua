local _, br = ...
local b = br._G
br.unlockers = br.unlockers or {}
local unlockers = br.unlockers

br.unlockers.selected = "None"
br.unlockers.unlock = {}

function unlockers:loadUnlockerAPI()
    local unlocked = false
    --local class = self.class
    if unlockers["NNUnlock"] ~= nil and unlockers:NNUnlock() then
        unlocked = true
    elseif unlockers["TinkrUnlock"] ~= nil and unlockers:TinkrUnlock() then
        unlocked = true
    elseif br.unlock["DaemonicUnlock"] ~= nil and br.unlock:DaemonicUnlock() then
        unlocked = true
    end

    if unlocked then
        -- Set Spell Queue Window to 400ms for smoother cast queueing.
        -- Save the player's original value first so we can restore it on logout.
        br.unlockers.origQueueWindow = br._G.C_CVar and br._G.C_CVar.GetCVar("SpellQueueWindow")
        br._G.RunMacroText("/console SpellQueueWindow 400")
        -- UPDATE MEDIA PATH: derive from the unlocker's reported directory so that
        -- BadRotations is fully self-contained (no WoW AddOns folder required).
        -- Each unlocker sets br._G.GetWoWDirectory to its script root:
        --   Tinkr   -> "scripts"
        --   NoName  -> "\\scripts"
        --   Daemonic-> absolute path, e.g. "C:\WoW\_retail_\Interface\AddOns"
        local DiesalStyle = LibStub("DiesalStyle-1.0")
        if DiesalStyle.SetMediaPath then
            local newPath
            local wowDir = br._G.GetWoWDirectory and br._G.GetWoWDirectory()
            if wowDir then
                -- Normalize: forward-slash -> backslash, strip leading/trailing backslashes
                local dir = tostring(wowDir):gsub("/", "\\"):gsub("^\\+", ""):gsub("\\+$", "")
                newPath = dir .. "\\BadRotations\\Libs\\DiesalStyle-1.0\\Media\\"
            else
                -- Fallback for a standard WoW addon installation
                newPath = "Interface\\AddOns\\BadRotations\\Libs\\DiesalStyle-1.0\\Media\\"
            end
            -- br._G.print("Unlocker loaded, media path: " .. newPath)
            local addonPath = "Interface\\AddOns\\BadRotations\\Libs\\DiesalStyle-1.0\\Media\\"
            DiesalStyle:SetMediaPath(newPath, addonPath)
            DiesalStyle:ReloadMedia()
        end
    end
    return unlocked
end

-- Checks for BR Out of Date with current version based on TOC file
local brlocVersion
local brcurrVersion
local brUpdateTimer
function unlockers:checkBrOutOfDate()
    brlocVersion = br._G.C_AddOns.GetAddOnMetadata(self.addonName, "Version")
    if (not brUpdateTimer or (br._G.GetTime() - brUpdateTimer) > 300) and self.player ~= nil then
        local startTime = br._G.debugprofilestop()
        -- Request Current Version from GitHub
        if b["EasyWoWToolbox"] ~= nil then -- EWT
            --SendHTTPRequest('https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc', nil,
            --function(body) brcurrVersion =(string.match(body, "(%d+%p%d+%p%d+)")) end)

            -- Check for commit updates from System/Updater.lua, which relies on EWT
            self.updater:CheckOutdated()
            brUpdateTimer = br._G.GetTime()
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
                local brcleanCurr = br._G.gsub(tostring(brcurrVersion), "%p", "")
                local brcleanLoc = br._G.gsub(tostring(brlocVersion), "%p", "")
                if tonumber(brcleanCurr) ~= tonumber(brcleanLoc) then
                    local msg =
                        "BadRotations is currently out of date. Local Version: " ..
                        brlocVersion .. " Current Version: " .. brcurrVersion
                        .. ".  Please download latest version for best performance."
                    if self.isChecked("Overlay Messages") then
                        b["RaidNotice_AddMessage"](b["RaidWarningFrame"], msg, { r = 1, g = 0.3, b = 0.1 })
                    else
                        br._G.print(msg)
                    end
                end
            end
            brUpdateTimer = br._G.GetTime()
        end
        self.debug.cpu:updateDebug(startTime, "outOfDate")
    end
end

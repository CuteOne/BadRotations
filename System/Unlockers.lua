local _, br = ...
local b = br._G
br.unlockers = br.unlockers or {}
local unlockers = br.unlockers

br.unlockers.selected = "None"

-- Unlocker adapters, in priority order. Each adapter file (Unlockers/*.lua)
-- defines br.unlockers:<fn>(): it sets up br._G and returns true only when its
-- unlocker is present, and returns false quietly otherwise. Detection and the
-- "no unlocker" case are handled here, not by any adapter.
local adapters = {
    { name = "NN",       fn = "NNUnlock" },
    { name = "Tinkr",    fn = "TinkrUnlock" },
    { name = "Daemonic", fn = "DaemonicUnlock" },
}
local reportedNoUnlocker = false

-- Adapters that don't ship with BR (loaded alongside it by their unlocker)
-- register here. They're tried before the built-in ones, since they are only
-- present when their unlocker explicitly loaded them.
function unlockers:registerAdapter(name, unlock)
    table.insert(adapters, 1, { name = name, unlock = unlock })
end

function unlockers:loadUnlockerAPI()
    local unlocked = false
    for _, adapter in ipairs(adapters) do
        local unlock = adapter.unlock or unlockers[adapter.fn]
        if unlock ~= nil and unlock(unlockers) then
            unlockers.selected = adapter.name
            unlocked = true
            break
        end
    end

    -- Called every pulse until an unlocker is found, so report only once.
    if not unlocked and not reportedNoUnlocker then
        reportedNoUnlocker = true
        br._G.print("No supported unlocker detected.")
    end

    if unlocked then
        -- Set Spell Queue Window to 400ms for smoother cast queueing.
        -- Save the player's original value first so we can restore it on logout.
        br.unlockers.origQueueWindow = br._G.C_CVar and br._G.C_CVar.GetCVar("SpellQueueWindow")
        br._G.RunMacroText("/console SpellQueueWindow 400")
        -- MEDIA PATH: the client only loads textures and fonts from its own Interface folder (paths
        -- to BR's own folder fail with "file not found", measured on Forever). The "3rd Party Files/Media"
        -- folder is copied to Interface\AddOns\Media; BR installed as a normal addon has its own copy.
        local DiesalStyle = LibStub("DiesalStyle-1.0")
        if DiesalStyle.SetMediaPath then
            DiesalStyle:SetMediaPath("Interface\\AddOns\\Media\\", "Interface\\AddOns\\BadRotations\\Libs\\DiesalStyle-1.0\\Media\\")
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

local _, br = ...
br.engines = {}

function br:getUpdateRate()
    local updateRate = 0.1

    local FrameRate = br._G.GetFramerate() or 0
    if br.isChecked("Auto Delay") then
        if FrameRate >= 0 and FrameRate < 60 then
            updateRate = (60 - FrameRate) / 60
        else
            updateRate = 0.1
        end
    elseif br.getOptionValue("Bot Update Rate") == nil then
        updateRate = 0.1
    else
        updateRate = br.getOptionValue("Bot Update Rate")
    end
    return updateRate
end

-- Main Engine
function br:Engine()
    if br.engines.Pulse_Engine == nil then
        br.engines.Pulse_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        br.engines.Pulse_Engine:SetScript("OnUpdate", br.BadRotationsUpdate)
        br.engines.Pulse_Engine:Show()
    end
end

-- Object Manager Engine
local function ObjectManagerUpdate(self)
    if br.unlocked then
        if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.selectedSpec] ~= nil
            and br.data.settings[br.selectedSpec].toggles ~= nil
        then
            if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil
                and br.data.settings[br.selectedSpec].toggles["Power"] == 1
            then
                -- attempt to update objects every frame
                -- updates for each object will be spread out randomly
                br:updateOM()
                br.om:Update()
            end
        end
    end
end

function br:ObjectManager()
    if br.engines.OM_Engine == nil then
        br.engines.OM_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        br.engines.OM_Engine:SetScript("OnUpdate", ObjectManagerUpdate)
        br.engines.OM_Engine:Show()
    end
end

-- Object Tracker
local function ObjectTrackerUpdate(self)
    if br.unlocked then
        if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.selectedSpec] ~= nil
            and br.data.settings[br.selectedSpec].toggles ~= nil
        then
            if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil
                and br.data.settings[br.selectedSpec].toggles["Power"] == 1
            then
                -- Tracker
                br.objectTracker()
            end
        end
    end
end

function br:ObjectTracker()
    if br.engines.Tracker_Engine == nil then
        br.engines.Tracker_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        br.engines.Tracker_Engine:SetScript("OnUpdate", ObjectTrackerUpdate)
        br.engines.Tracker_Engine:Show()
    end
end

local function updateRotationOnSpecChange()
    br.ui:closeWindow("all")
    br:saveSettings(nil, nil, br.selectedSpec, br.selectedProfileName)
    -- Update Selected Spec/Profile
    br.selectedSpec = select(2, br._G.GetSpecializationInfo(br._G.GetSpecialization()))
    br.selectedSpecID = br._G.GetSpecializationInfo(br._G.GetSpecialization())
    br.loader.loadProfiles()
    br.loadLastProfileTracker()
    br.data.loadedSettings = false
    -- Load Default Settings
    br:defaultSettings()
    br.rotationChanged = true
    br._G.wipe(br.commandHelp)
    br:slashHelpList()
end

local collectGarbage = true
function br.BadRotationsUpdate(self)
    local startTime = br._G.debugprofilestop()
    local LibDraw = br._G.LibStub("LibDraw-BR")
    local Print = br._G["print"]
    -- Check for Unlocker
    if not br.unlocked then
        br.unlocked = br:loadUnlockerAPI()
    end
    if br.disablePulse == true then
        return
    end
    -- BR Not Unlocked
    if not br.unlocked then
        -- Load and Cycle BR
        -- Notify Not Unlocked
        br.ui:closeWindow("all")
        br.ChatOverlay("Unable To Load")
        if br.isChecked("Notify Not Unlocked") and
            br.timer:useTimer("notLoaded", br.getOptionValue("Notify Not Unlocked")) then
            Print(
                "|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
        end
        return false
    elseif br.unlocked and br._G.GetObjectCount() ~= nil then
        br.devMode()
        -- Check BR Out of Date
        -- br:checkBrOutOfDate()
        -- Get Current Addon Name
        br:setAddonName()
        -- Load Saved Settings
        br:loadSavedSettings()
        -- Continue Load
        if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.selectedSpec] ~= nil and br.data.settings[br.selectedSpec].toggles ~= nil then
            -- BR Main Toggle Off
            if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 1 then
                -- BR Main Toggle On - Main Cycle
                -- Clear Queue
                if br.player ~= nil and br.player.queue ~= nil and #br.player.queue ~= 0 then
                    br._G.wipe(br.player.queue)
                    if not br.isChecked("Mute Queue") then
                        Print("BR Disabled! - Queue Cleared.")
                    end
                end
                -- Close All UI
                br.ui:closeWindow("all")
                -- Clear All Tracking
                LibDraw.clearCanvas()
                return false
            elseif br.timer:useTimer("playerUpdate", br:getUpdateRate()) then
                -- Set Fall Distance
                br.fallDist = br.getFallDistance() or 0
                -- Quaking helper
                if br.getOptionCheck("Quaking Helper") then
                    if (br._G.UnitChannelInfo("player") or br._G.UnitCastingInfo("player")) and
                        br.getDebuffRemain("player", 240448) < 0.5 and br.getDebuffRemain("player", 240448) > 0 then
                        br._G.RunMacroText("/stopcasting")
                    end
                end
                -- Blizz br._G.CastSpellByName bug bypass
                if br.castID then
                    -- Print("Casting by ID")
                    br._G.CastSpellByID(br.botSpell, br.botUnit)
                    br.castID = false
                end
                local playerSpec = br._G.GetSpecializationInfo(br._G.GetSpecialization())
                if playerSpec == "" then
                    playerSpec = "Initial"
                end
                -- Initialize Player
                if br.player == nil or br.player.profile ~= br.selectedSpec or br.rotationChanged then
                    -- Load Last Profile Tracker
                    -- br:loadLastProfileTracker()
                    br.selectedProfile = br.data.settings[br.selectedSpec]["RotationDrop"] or 1
                    -- Load Profile
                    -- br.loaded = false
                    br.player = br.loader:new(playerSpec, br.selectedSpec)
                    setmetatable(br.player, {
                        __index = br.loader
                    })
                    br.ui:closeWindow("profile")
                    br.player:createOptions()
                    br.player:createToggles()

                    br.player:update()
                    if br.player ~= nil and br.rotationChanged then
                        br:saveLastProfileTracker()
                        br:loadSettings(nil, br.player.class, br.selectedSpec, br.selectedProfileName)
                        br.ui:closeWindow("profile")
                        br.player:createOptions()
                        br.player:createToggles()
                    end
                    collectGarbage = true
                    br.rotationChanged = false
                end
                -- Queue Casting
                if (br.isChecked("Queue Casting") or (br.player ~= nil and br.player.queue ~= 0)) and
                    not br._G.UnitChannelInfo("player") then
                    if br.castQueue() then
                        return
                    end
                end
                if (not br.isChecked("Queue Casting") or br.GetUnitIsDeadOrGhost("player") or
                    not br._G.UnitAffectingCombat("player")) and br.player ~= nil and #br.player.queue ~= 0 then
                    br._G.wipe(br.player.queue)
                    if not br.isChecked("Mute Queue") then
                        if not br.isChecked("Queue Casting") then
                            Print("Queue System Disabled! - Queue Cleared.")
                        end
                        if br.GetUnitIsDeadOrGhost("player") then
                            Print("Player Death Detected! - Queue Cleared.")
                        end
                        if not br._G.UnitAffectingCombat("player") then
                            Print("No Combat Detected! - Queue Cleared.")
                        end
                    end
                end
                -- Smart Queue
                if br.unlocked and br.isChecked("Smart Queue") then
                    br.smartQueue()
                end
                -- Update Player
                if br.player ~= nil and (not br._G.CanExitVehicle() or (br.GetUnitExists("target") and br.getDistance("target") < 5)) then
                    br.player:update()
                end
                -- Automatic catch the pig
                if br.getOptionCheck("Freehold - Pig Catcher") or br.getOptionCheck("De Other Side - Bomb Snatcher") then
                    br.bossHelper()
                end
                -- Healing Engine
                if br.isChecked("HE Active") then
                    br.friend:Update()
                end
                -- Auto Loot
                br.autoLoot()
                -- Close windows and swap br.selectedSpec on Spec Change
                local thisSpec = select(2, br._G.GetSpecializationInfo(br._G.GetSpecialization()))
                if thisSpec ~= "" and thisSpec ~= br.selectedSpec then
                    updateRotationOnSpecChange()
                end
                -- Show Main Button
                if br.data.settings ~= nil and br.data.settings[br.selectedSpec].toggles["Main"] ~= 1 and
                    br.data.settings[br.selectedSpec].toggles["Main"] ~= 0 then
                    if not br._G.UnitAffectingCombat("player") then
                        br.data.settings[br.selectedSpec].toggles["Main"] = 1
                        br.mainButton:Show()
                    end
                end
                -- Display Distance on Main Icon
                if br.mainButton ~= nil then
                    local targetDistance = br.getDistance("target") or 0
                    local displayDistance = math.ceil(targetDistance)
                    br.mainText:SetText(displayDistance)
                end
                -- LoS Line Draw
                if br.isChecked("Healer Line of Sight Indicator") then
                    br.inLoSHealer()
                end
                -- Get DBM/BigWigs Timer/Bars
                -- global -> br.DBM.Timer
                if br._G.IsAddOnLoaded("DBM-Core") then
                    br.DBM:getBars()
                elseif br._G.IsAddOnLoaded("BigWigs") then
                    if not br.DBM.BigWigs then
                        br.BWInit()
                    else
                        br.BWCheck()
                    end
                end
                -- Accept dungeon queues
                br:AcceptQueues()
                -- Fishing
                br.fishing()
                -- Profession Helper
                br.ProfessionHelper()
                -- Rotation Log
                br.ui:toggleDebugWindow()
                -- Settings Garbage Collection
                if not br.loadFile and collectGarbage then
                    -- Ensure we have all the settings recorded
                    br.ui:recreateWindows()
                    -- Compare br.data.settings for the current spec/profile to the ui options
                    for k, _ in pairs(br.data.settings[br.selectedSpec][br.selectedProfile]) do
                        -- local inOptions = br.data.ui[k] ~= nil
                        -- Remove any Check/Drop/Status Options that are no longer a UI Option
                        if br.data.ui[k] == nil then
                            local drop = k.sub(k, -4)
                            local check = k.sub(k, -5)
                            local status = k.sub(k, -6)
                            if check == "Check" or drop == "Drop" or status == "Status" then
                                Print("Removing Unused Option: " .. k)
                                br.data.settings[br.selectedSpec][br.selectedProfile][k] = nil
                            end
                        end
                    end
                    -- Set flag to prevent un-needed runs
                    collectGarbage = false
                end
            end -- End Update Check
        else
            updateRotationOnSpecChange()
        end -- End Settings Loaded Check
    end -- End Unlock Check
    br.debug.cpu:updateDebug(startTime, "pulse")
end -- End Bad Rotations Update Function

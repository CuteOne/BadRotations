local _, br = ...
br.engines = br.engines or {}
local engines = br.engines

function engines:getUpdateRate()
    local updateRate = br.functions.misc:getOptionValue("Bot Update Rate") or 0.1

    if br.functions.misc:isChecked("Auto Delay") then
        local FrameRate = br._G.GetFramerate() or 0
        if FrameRate >= 0 and FrameRate < 60 then
            updateRate = (60 - FrameRate) / 60
        end
    end
    return updateRate
end

-- Main Engine
function engines:Main()
    if engines.Pulse_Engine == nil then
        engines.Pulse_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        engines.Pulse_Engine:SetScript("OnUpdate", engines.Update)
        engines.Pulse_Engine:Show()
    end
end

-- Object Manager Engine
local function ObjectManagerUpdate(self)
    if br.unlocked then
        if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.loader.selectedSpec] ~= nil
            and br.data.settings[br.loader.selectedSpec].toggles ~= nil
        then
            if br.data.settings[br.loader.selectedSpec].toggles["Power"] ~= nil
                and br.data.settings[br.loader.selectedSpec].toggles["Power"] == 1
            then
                -- attempt to update objects every frame
                -- updates for each object will be spread out randomly
                engines.enemiesEngineFunctions:updateOM()
                engines.enemiesEngine:Update()
            end
        end
    end
end

function engines:ObjectManager()
    if engines.OM_Engine == nil then
        engines.OM_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        engines.OM_Engine:SetScript("OnUpdate", ObjectManagerUpdate)
        engines.OM_Engine:Show()
    end
end

-- Object Tracker
local function ObjectTrackerUpdate(self)
    if br.unlocked then
        if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.loader.selectedSpec] ~= nil
            and br.data.settings[br.loader.selectedSpec].toggles ~= nil
        then
            if br.data.settings[br.loader.selectedSpec].toggles["Power"] ~= nil
                and br.data.settings[br.loader.selectedSpec].toggles["Power"] == 1
            then
                -- Tracker
                engines.tracker:objectTracker()
            end
        end
    end
end

function engines:ObjectTracker()
    if engines.Tracker_Engine == nil then
        engines.Tracker_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        engines.Tracker_Engine:SetScript("OnUpdate", ObjectTrackerUpdate)
        engines.Tracker_Engine:Show()
    end
end

local function updateRotationOnSpecChange()
    br.ui:closeWindow("all")
    br.ui.settingsManagement:saveSettings(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName)
    -- Update Selected Spec/Profile
    br.loader.selectedSpec = select(2, br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()))
    br.loader.selectedSpecID = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
    br.loader.cBuilder:loadProfiles()
    br.ui.settingsManagement:loadLastProfileTracker()
    br.data.loadedSettings = false
    -- Load Default Settings
    br:defaultSettings()
    br.rotationChanged = true
    br._G.wipe(br.slashCommands.commandHelp)
    br.slashCommands:slashHelpList()
end

local collectGarbage = true
function engines:Update(self)
    local startTime = br._G.debugprofilestop()
    local LibDraw = br._G.LibStub("LibDraw-BR")
    local Print = br._G["print"]
    -- Check for Unlocker
    if not br.unlocked then
        br.unlocked = br.unlockers:loadUnlockerAPI()
    end
    if br.disablePulse == true then
        return
    end
    -- BR Not Unlocked
    if not br.unlocked then
        -- Load and Cycle BR
        -- Notify Not Unlocked
        br.ui:closeWindow("all")
        br.ui.chatOverlay:Show("Unable To Load")
        if br.functions.misc:isChecked("Notify Not Unlocked") and
            br.debug.timer:useTimer("notLoaded", br.functions.misc:getOptionValue("Notify Not Unlocked"))
        then
            Print("|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
        end
        return false
    elseif br.unlocked and br._G.GetObjectCount() ~= nil then
        br.functions.misc:devMode()
        -- Check BR Out of Date
        -- br.unlockers:checkBrOutOfDate()
        -- Load Saved Settings
        br.ui.settingsManagement:loadSavedSettings()
        -- Cache settings check
        local settings = br.data and br.data.settings and br.data.settings[br.loader.selectedSpec]
        local toggles = settings and settings.toggles
        -- Continue Load
        if toggles then
            -- BR Main Toggle Off
            if toggles["Power"] ~= nil and toggles["Power"] ~= 1 then
                -- BR Main Toggle On - Main Cycle
                -- Clear Queue
                if br.player ~= nil and br.player.queue ~= nil and #br.player.queue ~= 0 then
                    br._G.wipe(br.player.queue)
                    if not br.functions.misc:isChecked("Mute Queue") then
                        Print("BR Disabled! - Queue Cleared.")
                    end
                end
                -- Close All UI
                br.ui:closeWindow("all")
                -- Clear All Tracking
                LibDraw.clearCanvas()
                return false
            elseif br.debug.timer:useTimer("playerUpdate", br.engines:getUpdateRate()) then
                -- Quaking helper
                if br.functions.misc:getOptionCheck("Quaking Helper") then
                    if (br._G.UnitChannelInfo("player") or br._G.UnitCastingInfo("player")) and
                        br.functions.aura:getDebuffRemain("player", 240448) < 0.5 and br.functions.aura:getDebuffRemain("player", 240448) > 0 then
                        br._G.RunMacroText("/stopcasting")
                    end
                end
                -- Blizz br._G.CastSpellByName bug bypass
                if br.castID then
                    -- Print("Casting by ID")
                    br._G.CastSpellByID(br.botSpell, br.botUnit)
                    br.castID = false
                end
                local playerSpec = br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
                if playerSpec == "" then
                    playerSpec = "Initial"
                end
                -- Initialize Player
                if br.player == nil or br.player.profile ~= br.loader.selectedSpec or br.rotationChanged then
                    -- Load Last Profile Tracker
                    -- br:loadLastProfileTracker()
                    br.loader.selectedProfile = br.data.settings[br.loader.selectedSpec]["RotationDrop"] or 1
                    -- Load Profile
                    -- br.loaded = false
                    br.player = br.loader.cBuilder:new(playerSpec, br.loader.selectedSpec)
                    if br.player ~= nil then
                        setmetatable(br.player, {
                            __index = br.loader
                        })
                        br.ui:closeWindow("profile")
                        br.player:createOptions()
                        br.player:createToggles()

                        br.player:update()
                        if br.rotationChanged then
                            br.ui.settingsManagement:saveLastProfileTracker()
                            br.ui.settingsManagement:loadSettings(nil, br.player.class, br.loader.selectedSpec, br.loader.selectedProfileName)
                            br.ui:closeWindow("profile")
                            br.player:createOptions()
                            br.player:createToggles()
                        end
                        collectGarbage = true
                        br.rotationChanged = false
                        br._G.print("Profile Load Complete - Ready to run.")
                    end
                end
                -- Queue Casting
                if (br.functions.misc:isChecked("Queue Casting") or (br.player ~= nil and br.player.queue ~= 0)) and
                    not br._G.UnitChannelInfo("player") then
                    if br.functions.cast:castQueue() then
                        return
                    end
                end
                if (not br.functions.misc:isChecked("Queue Casting") or br.functions.unit:GetUnitIsDeadOrGhost("player") or
                        not br._G.UnitAffectingCombat("player")) and br.player ~= nil and #br.player.queue ~= 0 then
                    br._G.wipe(br.player.queue)
                    if not br.functions.misc:isChecked("Mute Queue") then
                        if not br.functions.misc:isChecked("Queue Casting") then
                            Print("Queue System Disabled! - Queue Cleared.")
                        end
                        if br.functions.unit:GetUnitIsDeadOrGhost("player") then
                            Print("Player Death Detected! - Queue Cleared.")
                        end
                        if not br._G.UnitAffectingCombat("player") then
                            Print("No Combat Detected! - Queue Cleared.")
                        end
                    end
                end
                -- Smart Queue
                if br.unlocked and br.functions.misc:isChecked("Smart Queue") then
                    br.functions.SmartQueue:smartQueue()
                end
                -- Update Player
                if br.player ~= nil and (not br._G.CanExitVehicle() or (br.functions.unit:GetUnitExists("target") and br.functions.range:getDistance("target") < 5)) then
                    br.player:update()
                end
                -- Automatic catch the pig
                if br.functions.misc:getOptionCheck("Freehold - Pig Catcher") or br.functions.misc:getOptionCheck("De Other Side - Bomb Snatcher") then
                    br.misc.Zu:bossHelper()
                end
                -- Healing Engine
                if br.functions.misc:isChecked("HE Active") then
                    br.engines.healingEngine.friend:Update()
                end
                -- Auto Loot
                br.lootManager:autoLoot()
                -- Close windows and swap br.loader.selectedSpec on Spec Change
                local thisSpec = select(2, br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization()))
                if thisSpec ~= "" and thisSpec ~= br.loader.selectedSpec then
                    updateRotationOnSpecChange()
                end
                -- Show Main Button
                if br.data.settings ~= nil and br.data.settings[br.loader.selectedSpec].toggles["Main"] ~= 1 and
                    br.data.settings[br.loader.selectedSpec].toggles["Main"] ~= 0 then
                    if not br._G.UnitAffectingCombat("player") then
                        br.data.settings[br.loader.selectedSpec].toggles["Main"] = 1
                        br.ui.toggles.mainButton:Show()
                    end
                end
                -- Display Distance on Main Icon
                if br.ui.toggles.mainButton ~= nil then
                    local targetDistance = br.functions.range:getDistance("target") or 0
                    local displayDistance = math.ceil(targetDistance)
                    br.ui.toggles.mainText:SetText(displayDistance)
                end
                -- LoS Line Draw
                if br.functions.misc:isChecked("Healer Line of Sight Indicator") then
                    br.engines.healingEngineFunctions:inLoSHealer()
                end
                -- Get DBM/BigWigs Timer/Bars
                -- global -> br.functions.DBM.Timer
                if br._G.C_AddOns.IsAddOnLoaded("DBM-Core") then
                    br.functions.DBM:getBars()
                elseif br._G.C_AddOns.IsAddOnLoaded("BigWigs") then
                    if not br.functions.DBM.BigWigs then
                        br.functions.custom:BWInit()
                    else
                        br.functions.custom:BWCheck()
                    end
                end
                -- Accept dungeon queues
                br.functions.misc:AcceptQueues()
                -- Fishing
                br.misc.ProfessionHelper:fishing()
                -- Profession Helper
                br.misc.ProfessionHelper:ProfessionHelper()
                -- Rotation Log
                br.ui:toggleDebugWindow()
                -- Collect Garbage
                if collectGarbage then
                    -- Ensure we have all the settings recorded
                    br.ui:recreateWindows()
                    -- Delete old settings
                    br.ui.settingsManagement:cleanSettings()
                    -- Set flag to prevent un-needed runs
                    collectGarbage = false
                end
            end -- End Update Check
        elseif br.player ~= nil then
            updateRotationOnSpecChange()
        end -- End Settings Loaded Check
    end -- End Unlock Check
    br.debug.cpu:updateDebug(startTime, "pulse")
end -- End Bad Rotations Update Function

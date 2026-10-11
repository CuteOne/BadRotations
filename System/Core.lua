local _, br = ...
br.engines = br.engines or {}
local engines = br.engines

local Print  = print
local LibDraw -- assigned lazily on first Update call (LibStub must be registered first)

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

-- Returns true when BR is unlocked and the Power toggle is on.
-- Used by sub-engine update callbacks to gate their work behind the same
-- condition as the main pulse engine.
local function isPowerEnabled()
    if not br.unlocked then return false end
    -- The unlocker can pause BR while the game hides values from it (secret values).
    if br.api.canPulse and not br.api.canPulse() then return false end
    local toggles = br.data and br.data.settings
        and br.data.settings[br.loader.selectedSpec]
        and br.data.settings[br.loader.selectedSpec].toggles
    return toggles ~= nil and toggles["Power"] == 1
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
local function ObjectManagerUpdate(self, elapsed)
    if not isPowerEnabled() then return end
    self.omElapsed = (self.omElapsed or 0) + (elapsed or 0)
    if self.omElapsed < math.max(0.05, engines:getUpdateRate()) then return end
    self.omElapsed = 0
    engines.enemiesEngine:Update()
end

function engines:ObjectManager()
    if engines.OM_Engine == nil then
        engines.OM_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        engines.OM_Engine:SetScript("OnUpdate", ObjectManagerUpdate)
        engines.OM_Engine:Show()
    end
end

-- Object Tracker
-- Runs every frame: the tracker scans on its own interval but must re-project its
-- markers each frame or they lag behind the camera.
local function ObjectTrackerUpdate(self, elapsed)
    if not isPowerEnabled() then
        engines.tracker:suspend()
        return
    end
    engines.tracker:update(elapsed or 0)
end

function engines:ObjectTracker()
    if engines.Tracker_Engine == nil then
        engines.Tracker_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        engines.Tracker_Engine:SetScript("OnUpdate", ObjectTrackerUpdate)
        engines.Tracker_Engine:Show()
    end
end

-- Seeded true so the first check after loading compares the live spec once.
-- Thereafter only ACTIVE_PLAYER_SPECIALIZATION_CHANGED sets it (System/readers/common.lua).
br.loader.specDirty = true
function engines.Update(frame, elapsed)
    local startTime = br._G.debugprofilestop()
    LibDraw = LibDraw or br._G.LibStub("LibDraw-BR")
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
    else -- br.unlocked guaranteed true here
        br.functions.misc:devMode()
        -- Startup sequence (spell lists, rotations, profile, settings, player, UI): see Loader/Bootstrap.lua
        local bootstrap = br.loader.bootstrap
        local wasSettingsStage = bootstrap.stage == "SETTINGS"
        bootstrap:advance()
        if wasSettingsStage and bootstrap.settingsLoaded and not bootstrap.announced then
            bootstrap.announced = true
            br.ui.chatOverlay:Show("-= BadRotations Loaded =-")
            br._G.print("Initialization Complete.")
        end
        if not bootstrap:isPlayerReady() then
            return
        end
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
            elseif br.api.canPulse and not br.api.canPulse() then
                -- Paused by the unlocker while the game hides values from BR (secret values).
                return false
            elseif br.debug.timer:useTimer("playerUpdate", br.engines:getUpdateRate()) then
                -- Quaking helper
                if br.functions.misc:getOptionCheck("Quaking Helper") then
                    local quakingID = br.functions.spell:getHighestSpellID("quaking") or 240448
                    if (br._G.UnitChannelInfo("player") or br._G.UnitCastingInfo("player")) and
                        br.functions.aura:getDebuffRemain("player", quakingID) < 0.5 and br.functions.aura:getDebuffRemain("player", quakingID) > 0 then
                        br._G.RunMacroText("/stopcasting")
                    end
                end
                -- Blizz br._G.CastSpellByName bug bypass
                if br.castID then
                    -- Print("Casting by ID")
                    br._G.CastSpellByID(br.botSpell, br.botUnit)
                    br.castID = false
                end
                -- Queue Casting
                if (br.functions.misc:isChecked("Queue Casting") or (br.player ~= nil and br.player.queue ~= 0))
                    and not br._G.UnitChannelInfo("player")
                then
                    if br.functions.cast:castQueue() then return end
                end
                if (not br.functions.misc:isChecked("Queue Casting") or br.functions.unit:GetUnitIsDeadOrGhost("player")
                    or not br._G.UnitAffectingCombat("player")) and br.player ~= nil and #br.player.queue ~= 0 
                then
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
                -- Healing Engine: before the profile runs, so heal decisions see this tick's group health
                if br.functions.misc:isChecked("HE Active") then
                    br.engines.healingEngine.friend:Update()
                end
                -- Update Player
                if br.player ~= nil and (not br._G.CanExitVehicle() or (br.functions.unit:GetUnitExists("target") and br.functions.range:getDistance("target") < 5)) then
                    br.player:update()
                end
                -- Automatic catch the pig
                if br.functions.misc:getOptionCheck("Freehold - Pig Catcher") or br.functions.misc:getOptionCheck("De Other Side - Bomb Snatcher") then
                    br.misc.Zu:bossHelper()
                end
                -- Auto Loot
                br.engines.lootEngine:autoLoot()
                -- Spec change: save and restart from ROTATIONS (Loader/Bootstrap.lua)
                bootstrap:checkSpecChange()
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
            end -- End Update Check
        end -- End Settings Loaded Check
    end -- End Unlock Check
    br.debug.cpu:updateDebug(startTime, "pulse")
end -- End Bad Rotations Update Function

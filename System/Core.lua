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
    engines.enemiesEngineFunctions:updateOM()
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
local function ObjectTrackerUpdate(self, elapsed)
    if not isPowerEnabled() then return end
    self.trackerElapsed = (self.trackerElapsed or 0) + (elapsed or 0)
    if self.trackerElapsed < math.max(0.10, engines:getUpdateRate()) then return end
    self.trackerElapsed = 0
    engines.tracker:objectTracker()
end

function engines:ObjectTracker()
    if engines.Tracker_Engine == nil then
        engines.Tracker_Engine = br._G.CreateFrame("Frame", nil, br._G.UIParent)
        engines.Tracker_Engine:SetScript("OnUpdate", ObjectTrackerUpdate)
        engines.Tracker_Engine:Show()
    end
end

local function updateRotationOnSpecChange(newSpecID, newSpecName)
    br.ui:closeWindow("all")
    br.ui.settingsManagement:saveSettings(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName)
    -- Update Selected Spec/Profile using the already-computed values from engines.Update
    br.loader.selectedSpecID = newSpecID
    br.loader.selectedSpec   = newSpecName
    br.loader.cBuilder:loadProfiles()
    if not (br.loader.noRotationsFound and br.loader.noRotationsFound[newSpecID]) then
        br.ui.settingsManagement:loadLastProfileTracker()
    end
    br.data.loadedSettings = nil
    -- Load Default Settings
    br.ui.settingsManagement:defaultSettings()
    br.loader.rotationChanged = true
    br._G.wipe(br.slashCommands.commandHelp)
    br.slashCommands:slashHelpList()
    -- Invalidate cached melee spell so getDistanceCalc picks up the new spec.
    if br.functions and br.functions.range and br.functions.range.invalidateMeleeSpellCache then
        br.functions.range:invalidateMeleeSpellCache()
    end
end

-- collectGarbage should only be set when rotation explicitly changes
local collectGarbage = false
local initialized = false
local profileLoadAttempts = 0
-- Seeded true so the first pulse tick always resolves spec ID/name.
-- Thereafter only ACTIVE_PLAYER_SPECIALIZATION_CHANGED resets it.
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
        -- Check BR Out of Date
        -- br.unlockers:checkBrOutOfDate()
        -- One-time initialization: load spell lists, saved settings, show banner
        if not initialized then
            br.lists:loadExpansionSpells()
            br.ui.settingsManagement:loadSavedSettings()
            br.ui.chatOverlay:Show("-= BadRotations Loaded =-")
            br._G.print("Initialization Complete.")
            initialized = true
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
                -- Spec change detection: only re-query the API when the
                -- ACTIVE_PLAYER_SPECIALIZATION_CHANGED event has fired (or on
                -- the very first tick where specDirty is pre-seeded to true).
                if br.loader.specDirty then
                    br.loader.specDirty = false
                    local playerSpecID = (br.api and br.api.getEffectiveSpecID and br.api.getEffectiveSpecID())
                        or br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
                    local playerSpecName = select(2, br._G.GetSpecializationInfoForSpecID(playerSpecID)) or "Initial"
                    if playerSpecName == "" then playerSpecName = "Initial" end
                    local thisSpec = br.ui.settingsManagement:normalizeSpecKey(playerSpecName)
                    -- Cache resolved values for use later this tick
                    br.loader._resolvedSpecID   = playerSpecID
                    br.loader._resolvedSpecName = thisSpec
                end
                local playerSpecID = br.loader._resolvedSpecID   or br.loader.selectedSpecID
                local thisSpec     = br.loader._resolvedSpecName or br.loader.selectedSpec
                -- Initialize Player
                if br.player == nil or br.player.profile ~= br.loader.selectedSpec or br.loader.rotationChanged then
                    -- Always complete the data load so the rotation can execute in combat.
                    -- Only createOptions/createToggles (secure frames) are deferred until out of combat.
                    profileLoadAttempts = profileLoadAttempts + 1
                    br.loader.selectedProfile = br.data.settings[br.loader.selectedSpec]["RotationDrop"] or 1
                    br.player = br.loader.cBuilder:new(playerSpecID, br.loader.selectedSpec)
                    if br.player ~= nil then
                        setmetatable(br.player, {
                            __index = br.loader
                        })
                        if br.loader.rotationChanged then
                            br.ui.settingsManagement:saveLastProfileTracker()
                            br.ui.settingsManagement:loadSettings(nil, br.player.class, br.loader.selectedSpec, br.loader.selectedProfileName)
                            collectGarbage = true
                        end
                        br.loader.rotationChanged = false
                        profileLoadAttempts = 0 -- reset on success
                        if br._G.InCombatLockdown() then
                            -- Defer UI-only setup; rotation logic runs via update() below
                            if not br.loader._uiPending then
                                br.loader._uiPending = true
                                br._G.print("[BadRotations] Rotation loaded. Toggle bar setup deferred until after combat.")
                            end
                        else
                            br.loader._uiPending = nil
                            br.ui:closeWindow("profile")
                            br.player:createOptions()
                            br.player:createToggles()
                            br._G.print("Profile Load Complete")
                        end
                        br.player:update()
                    else
                        if profileLoadAttempts > 5 then return false end
                    end
                end
                -- Apply deferred UI setup once out of combat
                if br.loader._uiPending and not br._G.InCombatLockdown() and br.player ~= nil then
                    br.loader._uiPending = nil
                    br.ui:closeWindow("profile")
                    br.player:createOptions()
                    br.player:createToggles()
                    br._G.print("Profile Load Complete (deferred from combat).")
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
                br.engines.lootEngine:autoLoot()
                -- Close windows and swap br.loader.selectedSpec on Spec Change
                if thisSpec ~= "" and thisSpec ~= br.loader.selectedSpec then
                    updateRotationOnSpecChange(playerSpecID, thisSpec)
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
                -- Recreate windows when the rotation changed. cleanSettings is deferred
                -- to the UILoadCallback timer (1 s later) so it runs after buildAllUIPages.
                if collectGarbage then
                    br.ui:recreateWindows()
                    collectGarbage = false
                end
            end -- End Update Check
        elseif br.player ~= nil then
            -- Settings not yet ready; re-derive spec so updateRotationOnSpecChange has
            -- the correct values without waiting for the next rate-limited tick.
            local fbSpecID = (br.api and br.api.getEffectiveSpecID and br.api.getEffectiveSpecID())
                or br._G.C_SpecializationInfo.GetSpecializationInfo(br._G.C_SpecializationInfo.GetSpecialization())
            local fbSpecName = br.ui.settingsManagement:normalizeSpecKey(
                select(2, br._G.GetSpecializationInfoForSpecID(fbSpecID)) or "Initial")
            updateRotationOnSpecChange(fbSpecID, fbSpecName)
        end -- End Settings Loaded Check
    end -- End Unlock Check
    br.debug.cpu:updateDebug(startTime, "pulse")
end -- End Bad Rotations Update Function

local addonName, br = ...
br.engines = {}
-- Main Engine
function br:Engine()
	if br.engines.Pulse_Engine == nil then
		br.engines.Pulse_Engine = CreateFrame("Frame", nil, UIParent)
		br.engines.Pulse_Engine:SetScript("OnUpdate", BadRotationsUpdate)
		br.engines.Pulse_Engine:Show()
	end
end
-- Object Manager Engine
function br:ObjectManager()
	local function ObjectManagerUpdate(self)
		if br.unlocked then
			if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.selectedSpec] ~= nil and br.data.settings[br.selectedSpec].toggles ~= nil then
				if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] == 1 then
					--if br.timer:useTimer("omUpdate", 1) then
						br:updateOM()
						br.om:Update()
					--end
				end
			end
		end
	end
	if br.engines.OM_Engine == nil then
		-- ObjectManagerUpdate()
		br.engines.OM_Engine = CreateFrame("Frame", nil, UIParent)
		br.engines.OM_Engine:SetScript("OnUpdate", ObjectManagerUpdate)
		br.engines.OM_Engine:Show()
	end
end

--[[This function is refired everytime wow ticks. This frame is located at the top of Core.lua]]
function br:getUpdateRate()
	local updateRate = updateRate or 0.1

	local FrameRate = GetFramerate() or 0
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

local collectGarbage = true
function BadRotationsUpdate(self)
	local startTime = debugprofilestop()
	local LibDraw = _G["LibDraw"]
	local Print = br._G["Print"]
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
		if br.isChecked("Notify Not Unlocked") and br.timer:useTimer("notLoaded", br.getOptionValue("Notify Not Unlocked")) then
			Print("|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
		end
		return false
	elseif br.unlocked and br._G.GetObjectCount() ~= nil then
		-- Check BR Out of Date
		br:checkBrOutOfDate()
		-- Get Current Addon Name
		br:setAddonName()
		-- Load Saved Settings
		br:loadSavedSettings()
		-- Continue Load
		if br.data ~= nil and br.data.settings ~= nil and br.data.settings[br.selectedSpec] ~= nil and br.data.settings[br.selectedSpec].toggles ~= nil then
			-- BR Main Toggle Off
			if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 1 then
				-- BR Main Toggle On - Main Cycle
				-- BR Main Toggle On - Main Cycle
				-- Clear Queue
				if br.player ~= nil and br.player.queue ~= nil and #br.player.queue ~= 0 then
					wipe(br.player.queue)
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
					if (UnitChannelInfo("player") or UnitCastingInfo("player")) and br.getDebuffRemain("player", 240448) < 0.5 and br.getDebuffRemain("player", 240448) > 0 then
						RunMacroText("/stopcasting")
					end
				end
				if br.isCastingSpell(318763) then
					return true
				end
				-- Blizz br._G.CastSpellByName bug bypass
				if br.castID then
					-- Print("Casting by ID")
					CastSpellByID(botSpell, botUnit)
					br.castID = false
				end
				local playerSpec = GetSpecializationInfo(GetSpecialization())
				if playerSpec == "" then
					playerSpec = "Initial"
				end
				-- Initialize Player
				if br.player == nil or br.player.profile ~= br.selectedSpec or br.rotationChanged then
					-- Load Last Profile Tracker
					--br:loadLastProfileTracker()
					br.selectedProfile = br.data.settings[br.selectedSpec]["RotationDrop"] or 1
					-- Load Profile
					-- br.loaded = false
					br.player = br.loader:new(playerSpec, br.selectedSpec)
					setmetatable(br.player, {__index = br.loader})
					br.ui:closeWindow("profile")
					br.player:createOptions()
					br.player:createToggles()
					
					br.player:update()
					if br.player ~= nil and br.rotationChanged then
						br:saveLastProfileTracker()
					end
					collectGarbage = true
					br.rotationChanged = false
				end
				-- Queue Casting
				if (br.isChecked("Queue Casting") or (br.player ~= nil and br.player.queue ~= 0)) and not UnitChannelInfo("player") then
					if br.castQueue() then
						return
					end
				end
				if (not br.isChecked("Queue Casting") or UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player")) and br.player ~= nil and #br.player.queue ~= 0 then
					wipe(br.player.queue)
					if not br.isChecked("Mute Queue") then
						if not br.isChecked("Queue Casting") then
							Print("Queue System Disabled! - Queue Cleared.")
						end
						if UnitIsDeadOrGhost("player") then
							Print("Player Death Detected! - Queue Cleared.")
						end
						if not UnitAffectingCombat("player") then
							Print("No Combat Detected! - Queue Cleared.")
						end
					end
				end
				--Smart Queue
				if br.unlocked and br.isChecked("Smart Queue") then
					br.smartQueue()
				end
				-- Update Player
				if br.player ~= nil and (not CanExitVehicle() or (UnitExists("target") and br.getDistance("target") < 5)) then
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
				autoLoot()
				-- Close windows and swap br.selectedSpec on Spec Change
				local thisSpec = select(2, GetSpecializationInfo(GetSpecialization()))
				if thisSpec ~= "" and thisSpec ~= br.selectedSpec then
					-- Closing the windows will save the position
					br.ui:closeWindow("all")
					br:saveSettings(nil, nil, br.selectedSpec, br.selectedProfileName)
					-- Update Selected Spec/Profile
					br.selectedSpec = select(2, GetSpecializationInfo(GetSpecialization()))
					br.selectedSpecID = GetSpecializationInfo(GetSpecialization())
					br.loader.loadProfiles()
					br.loadLastProfileTracker()
					br.activeSpecGroup = GetActiveSpecGroup()
					br.data.loadedSettings = false
					-- Load Default Settings
					br:defaultSettings()
					br.rotationChanged = true
					wipe(br.commandHelp)
					br:slashHelpList()
				end
				-- Show Main Button
				if br.data.settings ~= nil and br.data.settings[br.selectedSpec].toggles["Main"] ~= 1 and br.data.settings[br.selectedSpec].toggles["Main"] ~= 0 then
					if not UnitAffectingCombat("player") then
						br.data.settings[br.selectedSpec].toggles["Main"] = 1
						br.mainButton:Show()
					end
				end
				-- Display Distance on Main Icon
				local targetDistance = br.getDistance("target") or 0
				local displayDistance = math.ceil(targetDistance)
				if br.mainButton ~= nil then
					br.mainText:SetText(displayDistance)
				end
				-- LoS Line Draw
				if br.isChecked("Healer Line of Sight Indicator") then
					inLoSHealer()
				end
				-- Get DBM/BigWigs Timer/Bars
				-- global -> br.DBM.Timer
				if IsAddOnLoaded("DBM-Core") then
					br.DBM:getBars()
				elseif IsAddOnLoaded("BigWigs") then
					if not br.DBM.BigWigs then
						br.BWInit()
					else
						br.BWCheck()
					end
				end
				-- Accept dungeon queues
				br:AcceptQueues()
				--Tracker
				br.objectTracker()
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
					for k, v in pairs(br.data.settings[br.selectedSpec][br.selectedProfile]) do
						local inOptions = br.data.ui[k] ~= nil
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
			end --End Update Check
		end -- End Settings Loaded Check
	end -- End Unlock Check
	br.debug.cpu:updateDebug(startTime, "pulse")
end -- End Bad Rotations Update Function

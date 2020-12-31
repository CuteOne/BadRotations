local br = _G["br"]
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
					br:updateOM()
					br.om:Update()
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
	if isChecked("Auto Delay") then
		if FrameRate >= 0 and FrameRate < 60 then
			updateRate = (60 - FrameRate) / 60
		else
			updateRate = 0.1
		end
	elseif getOptionValue("Bot Update Rate") == nil then
		updateRate = 0.1
	else
		updateRate = getOptionValue("Bot Update Rate")
	end
	return updateRate
end



function br.antiAfk()
	if br.unlocked and br.player then
		local ui = br.player.ui
		local IsHackEnabled = _G["IsHackEnabled"]
		local SetHackEnabled = _G["SetHackEnabled"]
		if ui.checked("Anti-Afk") then
			if not IsHackEnabled("antiafk") and ui.value("Anti-Afk") == 1 then
				SetHackEnabled("antiafk",true)
			end
		elseif ui.checked("Anti-Afk") and ui.value("Anti-Afk") == 2 then
			if IsHackEnabled("antiafk") then
				SetHackEnabled("antiafk",false)
			end
		end
	end
end

local collectGarbage = true
function BadRotationsUpdate(self)
	local startTime = debugprofilestop()
	local ChatOverlay = _G["ChatOverlay"]
	local getOptionValue = _G["getOptionValue"]
	local isChecked = _G["isChecked"]
	local LibDraw = _G["LibDraw"]
	local Print = _G["Print"]
	-- Check for Unlocker
	if not br.unlocked then
		br.unlocked = br:loadUnlockerAPI()
	end
	if br.disablePulse == true then return end
	-- BR Not Unlocked
	if not br.unlocked then
		-- Notify Not Unlocked
		br.ui:closeWindow("all")
		ChatOverlay("Unable To Load")
		if isChecked("Notify Not Unlocked") and br.timer:useTimer("notLoaded", getOptionValue("Notify Not Unlocked")) then
			Print("|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
		end
		return false
	-- Load and Cycle BR
	elseif br.unlocked and GetObjectCountBR() ~= nil then
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
				-- Clear Queue
				if br.player ~= nil and br.player.queue ~= nil and #br.player.queue ~= 0 then 
					wipe(br.player.queue)
					if not isChecked("Mute Queue") then Print("BR Disabled! - Queue Cleared.") end
				end
				-- Close All UI
				br.ui:closeWindow("all")
				-- Clear All Tracking
				LibDraw.clearCanvas()
				return false
			-- BR Main Toggle On - Main Cycle
			elseif br.timer:useTimer("playerUpdate", br:getUpdateRate()) then
				-- Set Fall Distance
				br.fallDist = getFallDistance() or 0
				-- Quaking helper
				if getOptionCheck("Quaking Helper") then
					if (UnitChannelInfo("player") or UnitCastingInfo("player")) and getDebuffRemain("player", 240448) < 0.5 and getDebuffRemain("player", 240448) > 0 then
						RunMacroText("/stopcasting")
					end
				end
				if isCastingSpell(318763) then
					return true
				end
				--Quaking helper
				if getOptionCheck("Pig Catcher") then
					-- Automatic catch the pig
					if select(8, GetInstanceInfo()) == 1754  then
						for i = 1, GetObjectCountBR() do
							local ID = ObjectID(GetObjectWithIndex(i))
							local object = GetObjectWithIndex(i)
							local x1, y1, z1 = ObjectPosition("player")
							local x2, y2, z2 = ObjectPosition(object)
							local distance = math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
							if ID == 130099 and distance < 10 and br.timer:useTimer("Pig Delay", 0.5) then
								InteractUnit(object)
							end
						end
					end
				end
				-- Blizz CastSpellByName bug bypass
				if br.castID then
					-- Print("Casting by ID")
					CastSpellByID(botSpell, botUnit)
					br.castID = false
				end
				local playerSpec = GetSpecializationInfo(GetSpecialization())
				if playerSpec == "" then playerSpec = "Initial" end
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
				if (isChecked("Queue Casting") or (br.player ~= nil and br.player.queue ~= 0)) and not UnitChannelInfo("player") then
					if castQueue() then
						return
					end
				end
				if (not isChecked("Queue Casting") or UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player")) and br.player ~= nil and #br.player.queue ~= 0 then
					wipe(br.player.queue) 
					if not isChecked("Mute Queue") then
						if not isChecked("Queue Casting") then Print("Queue System Disabled! - Queue Cleared.") end
						if UnitIsDeadOrGhost("player") then Print("Player Death Detected! - Queue Cleared.") end 
						if not UnitAffectingCombat("player") then Print("No Combat Detected! - Queue Cleared.") end
					end
				end 
				--Smart Queue
				if br.unlocked and isChecked("Smart Queue") then
					br.smartQueue()
				end
				-- Update Player
				if br.player ~= nil and not CanExitVehicle() then
					br.player:update()
				end
				-- Healing Engine
				if isChecked("HE Active") then
					br.friend:Update()
					local groupSize
					groupSize = GetNumGroupMembers()
					if groupSize == 0 then
						groupSize = 1
					end
					if #br.friend < groupSize and br.timer:useTimer("Reform", 5) then
						br.addonDebug("Group size ("..groupSize..") does not match #br.friend ("..#br.friend.."). Recreating br.friend.", true)
						table.wipe(br.memberSetup.cache)
						table.wipe(br.friend)
						SetupTables()
					end
				end
				-- Auto Loot
				autoLoot()
				-- Close windows and swap br.selectedSpec on Spec Change
				local thisSpec = select(2, GetSpecializationInfo(GetSpecialization()))
				if thisSpec ~= "" and thisSpec ~= br.selectedSpec then
					-- Closing the windows will save the position
					br.ui:closeWindow("all")
					br:saveSettings(nil,nil,br.selectedSpec,br.selectedProfileName)
					-- Update Selected Spec/Profile
					br.selectedSpec = select(2, GetSpecializationInfo(GetSpecialization()))
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
						mainButton:Show()
					end
				end
				-- Display Distance on Main Icon
				local targetDistance = getDistance("target") or 0
				local displayDistance = math.ceil(targetDistance)
				if mainButton ~= nil then mainText:SetText(displayDistance) end
				-- LoS Line Draw
				if isChecked("Healer Line of Sight Indicator") then
					inLoSHealer()
				end
				-- Get DBM/BigWigs Timer/Bars
				-- global -> br.DBM.Timer
				if IsAddOnLoaded('DBM-Core') then
					br.DBM:getBars()
				elseif IsAddOnLoaded("BigWigs") then
					if not br.DBM.BigWigs then
						BWInit()
					else
						BWCheck()
					end
				end
				-- Accept dungeon queues
				br:AcceptQueues()
				--Tracker
				br.objectTracker()
				-- Anti-Afk
				br.antiAfk()
				-- Fishing
				br.fishing()
				-- Profession Helper
				ProfessionHelper()
				-- Rotation Log
				br.ui:toggleDebugWindow()
				-- Settings Garbage Collection
				if not br.loadFile and collectGarbage then
					-- Ensure we have all the settings recorded
					br.ui:recreateWindows()
					-- Compare br.data.settings for the current spec/profile to the ui options
					for k,v in pairs(br.data.settings[br.selectedSpec][br.selectedProfile]) do
						local inOptions = br.data.ui[k] ~= nil
						-- Remove any Check/Drop/Status Options that are no longer a UI Option
						if br.data.ui[k] == nil then
							local drop = k.sub(k,-4)
							local check = k.sub(k,-5)
							local status = k.sub(k,-6)
							if check == "Check" or drop == "Drop" or status == "Status" then
								Print("Removing Unused Option: "..k)
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
	br.debug.cpu:updateDebug(startTime,"pulse")
end -- End Bad Rotations Update Function

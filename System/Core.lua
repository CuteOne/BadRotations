local brMainThread = nil
deadPet = false
local keyPause

function br:Engine()
	-- Hidden Frame
	if Pulse_Engine == nil then
		Pulse_Engine = CreateFrame("Frame", nil, UIParent)
		Pulse_Engine:SetScript("OnUpdate", BadRotationsUpdate)
		Pulse_Engine:Show()
	end
end
function br:ObjectManager()
	-- Object Manager
	if OM_Engine == nil then
		ObjectManagerUpdate()
		OM_Engine = CreateFrame("Frame", nil, UIParent)
		OM_Engine:SetScript("OnUpdate", ObjectManagerUpdate)
		OM_Engine:Show()
	end
end

--[[This function is refired everytime wow ticks. This frame is located at the top of Core.lua]]
function getUpdateRate()
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
--	if updateRate < 0.2 then
--		updateRate = 0.2
-- 	end
	return updateRate
end

function ObjectManagerUpdate(self)
	-- Check for Unlocker
    if EWT then
		if EasyWoWToolbox ~= nil then -- Only EWT support
            updateOMEWT()
        else -- Legacy OM
            if omPulse == nil then
                omPulse = GetTime()
            end
            if GetTime() > omPulse then
                omPulse = GetTime() + getUpdateRate()
                updateOM()
            end
		end
		br.om:Update()
	end
end

function br.antiAfk()
	if isChecked("Anti-Afk") and EasyWoWToolbox ~= nil then
		if not IsHackEnabled("antiafk") and getOptionValue("Anti-Afk") == 1 then
			SetHackEnabled("antiafk",true)
		end
	elseif isChecked("Anti-Afk") and EasyWoWToolbox ~= nil and getOptionValue("Anti-Afk") == 2 then
		if IsHackEnabled("antiafk") then
			SetHackEnabled("antiafk",false)
		end
	end
end
-- Key Pause from Beniamin
-- local rotationPause
-- local buttonName
-- local pauseSpellId

-- local ignoreKeys = {"W", "A", "S", "D", "Q", "E", "SPACE", "ENTER", "UP", "DOWN", "LEFT", "RIGHT", "LALT", "RALT", "LCTRL", "RCTRL", "LSHIFT", "RSHIFT", "TAB"}
-- local actionBarKeys = {"1","2","3","4","5","6","7","8","9","0","-","="}

-- local keyBoardFrame = CreateFrame("Frame")
-- keyBoardFrame:SetPropagateKeyboardInput(true)
-- local function testKeys(self, key)
-- 	local ignorePause = ignoreKeys
-- 	-- iterate over a list to ignore pause
-- 	if not isChecked("Disable Key Pause Queue") then
--         for i = 1, #actionBarKeys do
--             if string.find(key,actionBarKeys[i]) and not IsLeftShiftKeyDown() and not IsLeftAltKeyDown() and not IsLeftControlKeyDown() and not IsRightShiftKeyDown() and not IsRightAltKeyDown() and not IsRightControlKeyDown() and (UnitAffectingCombat("player") or isChecked("Ignore Combat")) and not isChecked("Queue Casting") then
--                 buttonName = GetBindingAction(actionBarKeys[i])
--                 local slot = buttonName:match("ACTIONBUTTON(%d+)") or buttonName:match("BT4Button(%d+)")
--                 if slot and HasAction(slot) then       
--                     local actionType, id = GetActionInfo(slot)
--                     if actionType == "spell" then
--                         pauseSpellId = id
--                         if not isChecked("Queue Casting") and GetSpellInfo(pauseSpellId) and pauseSpellId ~= 0 then
--                             ChatOverlay("Spell "..GetSpellInfo(pauseSpellId).." queued. Found on "..buttonName..".")
--                         end
--                     end
--                 end
--             end
--         end
--     elseif isChecked("Disable Key Pause Queue") then
--         pauseSpellId = nil
--     end
-- 	for i = 1, #ignorePause do
-- 		if string.find(key, ignorePause[i]) then
-- 			return
-- 		end
-- 	end
-- 	rotationPause = GetTime()
-- end

-- keyBoardFrame:SetScript("OnKeyDown", testKeys)
local brlocVersion = GetAddOnMetadata("BadRotations","Version")
local brcurrVersion
local brUpdateTimer
local collectGarbage = true
function BadRotationsUpdate(self)
	if br.disablePulse == true then return end
	local startTime = debugprofilestop()
	-- Check for Unlocker
	if not EWT then
		br.ui:closeWindow("all")
		ChatOverlay("Unable To Load")
		if isChecked("Notify Not Unlocked") and br.timer:useTimer("notLoaded", getOptionValue("Notify Not Unlocked")) then
			Print("|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
		end
		return false
	else 
		if EWT and GetObjectCount() ~= nil then
			if (brcurrVersion == nil or not brUpdateTimer or (GetTime() - brUpdateTimer) > 300) and EasyWoWToolbox ~= nil then
				SendHTTPRequest('https://raw.githubusercontent.com/CuteOne/BadRotations/master/BadRotations.toc', nil, function(body) brcurrVersion =(string.match(body, "(%d+%p%d+%p%d+)")) end)
				if brlocVersion and brcurrVersion then
					brcleanCurr = gsub(tostring(brcurrVersion),"%p","")
					brcleanLoc = gsub(tostring(brlocVersion),"%p","")
					 if tonumber(brcleanCurr) ~= tonumber(brcleanLoc) then 
						local msg = "BadRotations is currently out of date. Local Version: "..brlocVersion.. " Current Version: "..brcurrVersion..".  Please download latest version for best performance."
						if isChecked("Overlay Messages") then
							RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1, g=0.3, b=0.1})
						else
							Print(msg)
						end
					end
					brUpdateTimer = GetTime()
				end
			end
			if br.data.settings ~= nil and br.data.settings[br.selectedSpec].toggles ~= nil then
				if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 1 then
					if pauseSpellId ~= nil then
						pauseSpellId = nil
					end
					if br.player ~= nil and br.player.queue ~= nil and #br.player.queue ~= 0 then 
						wipe(br.player.queue)
						if not isChecked("Mute Queue") then Print("BR Disabled! - Queue Cleared.") end
					end
					br.ui:closeWindow("all")
					return false
				elseif br.timer:useTimer("playerUpdate", getUpdateRate()) then
					br.fallDist = getFallDistance() or 0
					if isChecked("Talent Anywhere") then
						talentAnywhere()
					end

					--Quaking helper
					if getOptionCheck("Quaking Helper") then
						if (UnitChannelInfo("player") or UnitCastingInfo("player")) and getDebuffRemain("player", 240448) < 0.5 and getDebuffRemain("player", 240448) > 0 then
							RunMacroText("/stopcasting")
						end
					end
					-- Pause if key press that is not ignored
					if not GetCurrentKeyBoardFocus() and not isChecked("Queue Casting") and (UnitAffectingCombat("player") or isChecked("Ignore Combat")) and UnitChannelInfo("player") == nil then
						if rotationPause and not keyPause and GetTime() - rotationPause < getOptionValue("Pause Interval") and (getSpellCD(61304) > 0 or UnitCastingInfo("player") ~= nil) then
							keyPause = true
							return
						elseif keyPause and getSpellCD(61304) == 0 and not UnitCastingInfo("player") then
							keyPause = false
							rotationPause = GetTime()
							return
						elseif rotationPause and not keyPause and GetTime() - rotationPause < getOptionValue("Pause Interval") and getSpellCD(61304) == 0 then
							local lastSpell
							if pauseSpellId ~= nil and (pauseSpellId ~= lastSpell or lastSpell == nil) then
								local target
								if IsHarmfulSpell(GetSpellInfo(pauseSpellId)) then
									target = "target"
								elseif IsHelpfulSpell(GetSpellInfo(pauseSpellId)) then
									if UnitExists("target") and not UnitCanAttack("target","player") then
										target = "target"
									else
										target = "player"
									end
								end
								CastSpellByID(pauseSpellId,target)
								lastSpell = pauseSpellId
								ChatOverlay("Spell "..GetSpellInfo(pauseSpellId).." cast.")
								pauseSpellId = nil
							end
							return
						elseif keyPause then
							return
						end
					elseif pauseSpellId ~= nil and (not (UnitAffectingCombat("player") or isChecked("Ignore Combat")) or isChecked("Queue Casting")) then
						pauseSpellId = nil
					end
					-- Blizz CastSpellByName bug bypass
					if castID then
						-- Print("Casting by ID")
						CastSpellByID(botSpell, botUnit)
						castID = false
					end
					-- Load Spec Profiles
					br.selectedProfile = br.data.settings[br.selectedSpec]["Rotation" .. "Drop"] or 1
					local playerSpec = GetSpecializationInfo(GetSpecialization())
					-- Initialize Player
					if br.player == nil or br.player.profile ~= br.selectedSpec or br.rotationChanged then
						brLoaded = false
						br.player = br.loader:new(playerSpec, br.selectedSpec)
						setmetatable(br.player, {__index = br.loader})
						br.ui:closeWindow("profile")
						br.player:createOptions()
						br.player:createToggles()
						br.player:update()
						collectGarbage = true
						Print("Loaded Profile: " .. br.player.rotation.name)
						br.settingsFile = GetWoWDirectory() .. '\\Interface\\AddOns\\BadRotations\\Settings\\' .. 
							br.selectedSpec .. br.selectedProfileName .. ".lua"
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
					if EasyWoWToolbox ~= nil and isChecked("Smart Queue") then
						br.smartQueue()
					end
					-- Update Player
					if br.player ~= nil and not CanExitVehicle() then --br.debug.cpu.pulse.currentTime/10) then
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
							br.addonDebug("Group size ("..groupSize..") does not match #br.friend ("..#br.friend.."). Recreating br.friend.")
							table.wipe(br.memberSetup.cache)
							table.wipe(br.friend)
							SetupTables()
						end
					end
					-- Auto Loot
					autoLoot()
					-- Close windows and swap br.selectedSpec on Spec Change
					if select(2, GetSpecializationInfo(GetSpecialization())) ~= br.selectedSpec then
						-- Closing the windows will save the position
						br.ui:closeWindow("all")
						-- Update Selected Spec/Profile
						br.selectedSpec = select(2, GetSpecializationInfo(GetSpecialization()))
						br.activeSpecGroup = GetActiveSpecGroup()
						br:loadSettings()
						br.rotationChanged = true
						commandHelp = nil
						commandHelp = ""
						slashHelpList()
					end

					if br.data.settings[br.selectedSpec].toggles["Main"] ~= 1 and br.data.settings[br.selectedSpec].toggles["Main"] ~= 0 then
						if not UnitAffectingCombat("player") then
							br.data.settings[br.selectedSpec].toggles["Main"] = 1
							mainButton:Show()
						end
					end

					-- Display Distance on Main Icon
					targetDistance = getDistance("target") or 0
					displayDistance = math.ceil(targetDistance)
					mainText:SetText(displayDistance)

					-- LoS Line Draw
					if isChecked("Healer Line of Sight Indicator") then
						inLoSHealer()
					end

					-- get DBM Timer/Bars
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

					-- Anti-Afk
					br.antiAfk()
					
					-- Fishing
					br.fishing()

					-- Profession Helper
					ProfessionHelper()

					-- Rotation Log
					br.ui:toggleDebugWindow()

					-- Settings Garbage Collection
					if collectGarbage then
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
			end -- End Update In Progress Check
		end
	end -- End Main Button Active Check
	if isChecked("Debug Timers") then
		br.debug.cpu.pulse.totalIterations = br.debug.cpu.pulse.totalIterations + 1
		br.debug.cpu.pulse.currentTime = debugprofilestop() - startTime
		br.debug.cpu.pulse.elapsedTime = br.debug.cpu.pulse.elapsedTime + debugprofilestop() - startTime
		br.debug.cpu.pulse.averageTime = br.debug.cpu.pulse.elapsedTime / br.debug.cpu.pulse.totalIterations
	end
end -- End Bad Rotations Update Function

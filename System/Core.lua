deadPet = false


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
	return updateRate
end

function ObjectManagerUpdate(self)
	-- Check for Unlocker
	if br.unlocked == false then
		br.unlocked = loadUnlockerAPI()
	end
    -- if EWT then
		if br.unlocked then --EasyWoWToolbox ~= nil then -- Only EWT support
            updateOMEWT()
        -- else -- Legacy OM
        --     if omPulse == nil then
        --         omPulse = GetTime()
        --     end
        --     if GetTime() > omPulse then
        --         omPulse = GetTime() + getUpdateRate()
        --         updateOM()
        --     end
		-- end
		br.om:Update()
	end
end

function br.tracker()
	if br.timer:useTimer("Tracker Lag", 0.07) then
        LibDraw.clearCanvas()
        for i = 1, GetObjectCountBR() do
            local object = GetObjectWithIndex(i)
            local name = ObjectName(object)
            if isChecked("Chest Tracker") then
                if string.match(strupper(name),strupper("cache")) or string.match(strupper(name),strupper("chest")) then
                    local xOb, yOb, zOb = ObjectPosition(object)
                    local pX,pY,pZ = ObjectPosition("player")
                    if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) < 300 then
                        --LibDraw.Circle(xOb,yOb,zOb, 2)
                        LibDraw.Text(name,"GameFontNormal",xOb,yOb,zOb+3)
                        if isChecked("Draw Lines to Tracked Objects") then 
                            LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
                        end
                    end
                end
            end

			if isChecked("Potions Tracker") then
				--[[ local badpot = {"Blank","Red","Black","Green","Blue","Purple"} ]]
				if string.match(strupper(name),strupper("vial")) then
                    local xOb, yOb, zOb = ObjectPosition(object)
                    local pX,pY,pZ = ObjectPosition("player")
                    if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <200 then
                        --LibDraw.Circle(xOb,yOb,zOb, 1)
                        LibDraw.Text(name,"GameFontNormal",xOb,yOb,zOb+3)
                        if isChecked("Draw Lines to Tracked Objects") then 
                            LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
                        end
                    end
                end
            end

            if isChecked("Custom Tracker") then
                if getDistance(object) < 100 and getOptionValue("Custom Tracker") ~= "" and string.len(getOptionValue("Custom Tracker")) >= 3 and string.match(strupper(name),strupper(getOptionValue("Custom Tracker"))) then
                    local xOb, yOb, zOb = ObjectPosition(object)
                    local pX,pY,pZ = ObjectPosition("player")
                    if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <200 then
                        --LibDraw.Circle(xOb,yOb,zOb, 1)
                        LibDraw.Text(name,"GameFontNormal",xOb,yOb,zOb+3)
                        if isChecked("Draw Lines to Tracked Objects") then 
                            LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
                        end
                    end
                end
            end
        end
    end
end

function br.antiAfk()
	if isChecked("Anti-Afk") and br.unlocked then --EasyWoWToolbox ~= nil then
		if not IsHackEnabled("antiafk") and getOptionValue("Anti-Afk") == 1 then
			SetHackEnabled("antiafk",true)
		end
	elseif isChecked("Anti-Afk") and br.unlocked --[[EasyWoWToolbox ~= nil]] and getOptionValue("Anti-Afk") == 2 then
		if IsHackEnabled("antiafk") then
			SetHackEnabled("antiafk",false)
		end
	end
end

local brlocVersion = GetAddOnMetadata("BadRotations","Version")
local brcurrVersion
local brUpdateTimer
local collectGarbage = true
function BadRotationsUpdate(self)
	-- Check for Unlocker
	if br.unlocked == false then
		br.unlocked = loadUnlockerAPI()
	end
	if br.disablePulse == true then return end
	local startTime = debugprofilestop()
	-- Check for Unlocker

	if not br.unlocked then
		br.ui:closeWindow("all")
		ChatOverlay("Unable To Load")
		if isChecked("Notify Not Unlocked") and br.timer:useTimer("notLoaded", getOptionValue("Notify Not Unlocked")) then
			Print("|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
		end
		return false
	else 
		if br.unlocked and GetObjectCountBR() ~= nil then
			if (brcurrVersion == nil or not brUpdateTimer or (GetTime() - brUpdateTimer) > 300) then --and EasyWoWToolbox ~= nil then
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
						-- Creates Settings Directory if not exist
						local settingsDir = GetWoWDirectory() .. '\\Interface\\AddOns\\BadRotations\\Settings\\'
						CreateDirectory(settingsDir)
						br.settingsFile = settingsDir .. br.selectedSpec .. br.selectedProfileName .. ".lua"
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
					if br.unlocked and --[[EasyWoWToolbox ~= nil and ]]isChecked("Smart Queue") then
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
							br.addonDebug("Group size ("..groupSize..") does not match #br.friend ("..#br.friend.."). Recreating br.friend.", true)
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

					--Tracker
					br.tracker()

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

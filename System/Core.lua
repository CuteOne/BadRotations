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
		if FrameRate >= 0 and FrameRate < 100 then
			updateRate = (100 - FrameRate) / 100
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
	if EWT then
		-- Pulse Object Manager for Caching
		if omPulse == nil then
			omPulse = GetTime()
		end
		if GetTime() > omPulse then
			omPulse = GetTime() + getUpdateRate()
			updateOM()
		end
	end
end

-- Key Pause from Beniamin
local rotationPause
local buttonName
local spellId

local ignoreKeys = {"W", "A", "S", "D", "Q", "E", "SPACE", "ENTER", "UP", "DOWN", "LEFT", "RIGHT", "LALT", "RALT", "LCTRL", "RCTRL", "LSHIFT", "RSHIFT", "TAB"}
local actionBarKeys = {"1","2","3","4","5","6","7","8","9","0","-","="}

local keyBoardFrame = CreateFrame("Frame")
keyBoardFrame:SetPropagateKeyboardInput(true)
local function testKeys(self, key)
	local ignorePause = ignoreKeys
	-- iterate over a list to ignore pause
	for i = 1, #ignorePause do
		if string.find(key, ignorePause[i]) then
			return
		end
	end
	for i = 1, #actionBarKeys do
		if string.find(key,actionBarKeys[i]) then
			buttonName = "ActionButton"..i
			local button = _G[buttonName]
			local slot = ActionButton_CalculateAction(button) or button:GetAttribute("action") or 0
			if HasAction(slot) then
				local actionType, id, _, actionName = GetActionInfo(slot)
				if actionType == "spell" then
					spellId = id
					if not isChecked("Queue Casting") then
						ChatOverlay("Spell "..GetSpellInfo(spellId).." queued.")
					end
				end
			end
		end
	end
	rotationPause = GetTime()
end

keyBoardFrame:SetScript("OnKeyDown", testKeys)

function BadRotationsUpdate(self)
	local startTime = debugprofilestop()
	-- Check for Unlocker
	if not EWT then
		br.ui:closeWindow("all")
		if getOptionCheck("Start/Stop BadRotations") then
			ChatOverlay("Unable To Load")
			if isChecked("Notify Not Unlocked") and br.timer:useTimer("notLoaded", getOptionValue("Notify Not Unlocked")) then
				Print("|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
			end
		end
		return false
	else 
		if EWT and GetObjectCount() ~= nil then
			if br.data.settings ~= nil then
				if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 1 then
					br.ui:closeWindow("all")
					return false
				elseif br.timer:useTimer("playerUpdate", getUpdateRate()) then
					br.fallDist = getFallDistance() or 0
					if isChecked("Talent Anywhere") then
						talentAnywhere()
					end

					--Quaking helper
					if getOptionCheck("Quaking Helper") then
						if UnitChannelInfo("player") and getDebuffRemain("player", 240448) < 0.5 and getDebuffRemain("player", 240448) > 0 then
							SpellStopCasting()
						end
					end
					-- Pause if key press that is not ignored
					if not GetCurrentKeyBoardFocus() and not isChecked("Queue Casting") then
						if rotationPause and not keyPause and GetTime() - rotationPause < getOptionValue("Pause Interval") and (getSpellCD(61304) > 0 or UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil) then
							if UnitChannelInfo("player") ~= nil or UnitCastingInfo("player") ~= nil then
								SpellStopCasting()
							end
							keyPause = true
							return
						elseif keyPause and getSpellCD(61304) == 0 and not UnitCastingInfo("player") and not UnitChannelInfo("player") then
							keyPause = false
							rotationPause = GetTime()
							return
						elseif rotationPause and not keyPause and GetTime() - rotationPause < getOptionValue("Pause Interval") and getSpellCD(61304) == 0 then
							local lastSpell
							if spellId ~= nil and (spellId ~= lastSpell or lastSpell == nil) then
								local target
								if IsHarmfulSpell(GetSpellInfo(spellId)) then
									target = "target"
								elseif IsHelpfulSpell(GetSpellInfo(spellId)) then
									if UnitExists("target") and not UnitCanAttack("target","player") then
										target = "target"
									else
										target = "player"
									end
								end
								CastSpellByID(spellId,target)
								lastSpell = spellId
								ChatOverlay("Spell "..GetSpellInfo(spellId).." cast.")
								spellId = nil
							end
							return
						elseif keyPause then
							return
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
						br.player:createOptions()
						br.player:createToggles()
						br.player:update()
						Print("Loaded Profile: " .. br.player.rotation.name)
						br.rotationChanged = false
					end
					-- Queue Casting
					if (isChecked("Queue Casting") or (br.player ~= nil and br.player.queue ~= 0)) and not UnitChannelInfo("player") then
						if castQueue() then
							return
						end
					end
					-- Update Player
					if br.player ~= nil and not CanExitVehicle() then --br.debug.cpu.pulse.currentTime/10) then
						br.player:update()
					end
					-- Healing Engine
					if isChecked("HE Active") then
						br.friend:Update()
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
						-- Recreate Config Window and commandHelp with new Spec
						br.ui.window.config = {}
						br.ui:createConfigWindow()
						br.ui:toggleWindow("config")
						commandHelp = nil
						commandHelp = ""
						slashHelpList()
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
					br.DBM:getBars()

					-- Accept dungeon queues
					br:AcceptQueues()

					-- Profession Helper
					ProfessionHelper()

					-- Rotation Log
					br.ui:toggleDebugWindow()
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

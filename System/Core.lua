local brMainThread = nil
deadPet = false


function br:Engine()
	-- Hidden Frame
	if Pulse_Engine == nil then
		Pulse_Engine = CreateFrame("Frame", nil, UIParent)
		-- Pulse_Engine:SetScript("OnUpdate", ThreadHelper)
		Pulse_Engine:SetScript("OnUpdate", BadRotationsUpdate)
		Pulse_Engine:Show()
	end
end
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[---------          ---           --------       -------           --------------------------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----   ---------------  ----  -------  --------  ---------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----           ------  ------  ------  ---------  ----------------------------------------------------------------------------------------------------------]]
--[[---------       ------  --------------             ----  ---------  -------------------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----  -------------  ----------  ----  --------  -------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----           ---  ------------  ---            -------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
-- local elapsedTime = 0
-- local updateRate = 0
-- function EnemyEngine(_, time)
-- 	elapsedTime = elapsedTime + time
-- 	if getOptionValue("Enemy Update Rate") ~= nil and getOptionValue("Enemy Update Rate") > 0.5 then updateRate = getOptionValue("Enemy Update Rate")
-- 		else updateRate = 0.5
-- 	end
-- 	if updateRate < #getEnemies("player",50) then
-- 		updateRate = #getEnemies("player",50)
-- 	end
-- 	-- ChatOverlay(updateRate)
-- 	--print(updateRate)
-- 	if FireHack ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] == 1 and elapsedTime >= updateRate then --0.5 then
-- 		elapsedTime = 0
-- 		-- Enemies Engine
-- 		-- br.handleObjects()
-- 		-- br.EnemiesEngine()
-- 		-- EnemiesEngine();
-- 		FindEnemy()
-- 	end
-- end

 local frame = CreateFrame("FRAME")
-- frame:SetScript("OnUpdate", EnemyEngine)

-- local elapsedTime2 = 0
-- function PlayerUpdate(_, time)
-- 	elapsedTime2 = elapsedTime + time
-- 	if FireHack ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] == 1 and elapsedTime2 >= getOptionValue("Player Update Rate") then
-- 		elapsedTime2 = 0
-- 	-- Load Spec Profiles
-- 	    br.selectedProfile = br.data.settings[br.selectedSpec]["Rotation".."Drop"] or 1
-- 		local playerSpec = GetSpecializationInfo(GetSpecialization())

-- 		if br.player == nil or br.player.profile ~= br.selectedSpec then
-- 	        br.player = br.loader:new(playerSpec,br.selectedSpec)
-- 	        setmetatable(br.player, {__index = br.loader})
-- 	        br.player:createOptions()
-- 	        br.player:createToggles()
-- 	        br.player:update()
-- 	    end
-- 	    -- Update Player
-- 		if br.player ~= nil then
-- 			br.player:update()
-- 		end
-- 	end
-- end

-- local playerUpdate = CreateFrame("Frame")
-- playerUpdate:SetScript("OnUpdate", PlayerUpdate)


frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
frame:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SENT")
frame:RegisterUnitEvent("UI_ERROR_MESSAGE")
function frame:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
	if event == "ADDON_LOADED" and arg1 == "BadRotations" then
		-- Load Settings
		br.data = deepcopy(brdata)
		br.dungeon = deepcopy(dungeondata)
		br.mdungeon = deepcopy(mdungeondata)
		br.raid = deepcopy(raiddata)
		br.mraid = deepcopy(mraiddata)
	end
    if event == "PLAYER_LOGOUT" then
        br.ui:saveWindowPosition()
        if getOptionCheck("Reset Options") then
        	-- Reset Settings
        	brdata = {}
		elseif getOptionCheck("Reset Saved Profiles") then
			dungeondata = {}
        	raiddata = {}
        	mdungeondata = {}
        	mraiddata = {}
        	br.dungeon = {}
			br.mdungeon = {}
			br.raid = {}
			br.mraid = {}
        else
        	-- Save Settings
        	brdata = deepcopy(br.data)
        	dungeondata = deepcopy(br.dungeon)
        	mdungeondata = deepcopy(br.mdungeon)
        	raiddata = deepcopy(br.raid)
        	mraiddata = deepcopy(br.mraid)
        end
    end
    if event == "PLAYER_ENTERING_WORLD" then
    	-- Update Selected Spec
        br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
        br.activeSpecGroup = GetActiveSpecGroup()
    	if not br.loadedIn then
    		bagsUpdated = true
        	br:Run()
        end
    end
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
    	-- Cast anything in spell queue
    	local sourceName, spellName, rank, line, spell = arg1, arg2, arg3, arg4, arg5
    	-- Print("Source: "..sourceName..", Spell: "..spellName..", ID: "..spell)
		if botCast == true then botCast = false end
        if sourceName ~= nil then
            if UnitIsUnit(sourceName,"player") then
            	if br.player ~= nil then
	                if #br.player.queue ~= 0 then
	                    for i = 1, #br.player.queue do
	                        if GetSpellInfo(spell) == GetSpellInfo(br.player.queue[i].id) then
	                            tremove(br.player.queue,i)
	                            if not isChecked("Mute Queue") then
	                            	Print("Cast Success! - Removed |cFFFF0000"..spellName.."|r from the queue.")
	                            end
	                            break
	                        end
	                    end
	                end
	            end
            end
        end
    end
    -- Blizz CastSpellByName bug bypass
    if event == "UNIT_SPELLCAST_SENT" then
    	local unitID, spell, rank, target, lineID = arg1, arg2, arg3, arg4, arg5
    	if unitID == "player" and spell == "Metamorphosis" then
    		CastSpellByID(191427,"player")
    	end
    end
	if event == "UI_ERROR_MESSAGE" then
		local arg1 = arg1
		if arg1 == 275 then
			if deadPet == false then
				deadPet = true
			elseif deadPet == true then
				deadPet = false
			end
		end
	end
end
frame:SetScript("OnEvent", frame.OnEvent)

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[This function is refired everytime wow ticks. This frame is located at the top of Core.lua]]
local updateRate = updateRate or 0.1

function getUpdateRate()
	return updateRate
end
function BadRotationsUpdate(self)
	if updateRate < 0.1 then
		updateRate = 0.1
	end
	if isChecked("Talent Anywhere") then
		talentAnywhere()
	end
	 local startTime = debugprofilestop()
	 if br.updateInProgress ~= true then
	 	self.updateInProgress = true
	 	local tempTime = GetTime();
	 	if not self.lastUpdateTime then
	 		self.lastUpdateTime = tempTime
	 	end
	 	
	 	local FrameRate = GetFramerate() or 0
	 	if isChecked("Auto Delay") then	 		
		 	if FrameRate ~= 0 and FrameRate < 30 and updateRate < 0.5  then
		 		updateRate = updateRate + 0.1
		 	elseif FrameRate > 80 and updateRate ~= 0.1 then
		 		updateRate = updateRate - 0.1
		 	end
		elseif getOptionValue("Bot Update Rate") == nil then 
		 	updateRate = 0.1 else updateRate = getOptionValue("Bot Update Rate") 
		end

	 	if self.lastUpdateTime and (tempTime - self.lastUpdateTime) > updateRate then --0.1 then
	 		self.lastUpdateTime = tempTime
			-- Check for Unlocker
			if FireHack == nil then
			 	br.ui:closeWindow("all")
				if getOptionCheck("Start/Stop BadRotations") then
					ChatOverlay("FireHack not Loaded.")
					if isChecked("Notify Not Unlocked") and br.timer:useTimer("notLoaded", getOptionValue("Notify Not Unlocked")) then
						Print("|cffFFFFFFCannot Start... |cffFF1100Firehack |cffFFFFFFis not loaded. Please attach Firehack.")
					end
				end
				return false
			else
				if br.data.settings ~= nil then
					if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 1 then
						br.ui:closeWindow("all")
						return false
					else
					-- Blizz CastSpellByName bug bypass
						if castID then
							-- Print("Casting by ID")
							CastSpellByID(botSpell,botUnit)
							castID = false
						end
					-- Load Spec Profiles
					    br.selectedProfile = br.data.settings[br.selectedSpec]["Rotation".."Drop"] or 1
						local playerSpec = GetSpecializationInfo(GetSpecialization())

						if br.player == nil or br.player.profile ~= br.selectedSpec then
					        br.player = br.loader:new(playerSpec,br.selectedSpec)
					        setmetatable(br.player, {__index = br.loader})
					        br.player:createOptions()
					        br.player:createToggles()
					        br.player:update()
					    end
					    -- Update Player
					    if br.player ~= nil then
							br.player:update()
						end
						FindEnemy()
					-- Enemies Engine
						-- FindEnemy()
						-- EnemiesEngine()
					-- Close windows and swap br.selectedSpec on Spec Change
						if select(2,GetSpecializationInfo(GetSpecialization())) ~= br.selectedSpec then
					    	-- Closing the windows will save the position
					        br.ui:closeWindow("all")

					    	-- Update Selected Spec/Profile
					        br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
					        br.activeSpecGroup = GetActiveSpecGroup()
					        br:loadSettings()

					        -- Recreate Config Window and commandHelp with new Spec
					        if br.ui.window.config.parent == nil then br.ui:createConfigWindow() end
							commandHelp = nil
							commandHelp = ""
							slashHelpList()
					    end

					-- Display Distance on Main Icon
				    	targetDistance = getDistance("target") or 0
				    	displayDistance = math.ceil(targetDistance)
						mainText:SetText(displayDistance)

					-- Auto Loot
						autoLoot()

					-- Queue Casting
						if isChecked("Queue Casting") and not UnitChannelInfo("player") then
							-- Catch for spells not registering on Combat log
						    if castQueue() then return end
						end

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
				    	if not br.ui.window['debug']['parent'] then
				    		br.ui:createDebugWindow()
				    		br.ui:closeWindow("debug")
				    	end
					    if getOptionCheck("Rotation Log") then
					    	if not br.ui.window['debug']['parent'] then br.ui:createDebugWindow() end
					    	br.ui:showWindow("debug")
					    elseif br.data.settings[br.selectedSpec]["debug"] == nil then
				    			br.data.settings[br.selectedSpec]["debug"] = {}
				    			br.data.settings[br.selectedSpec]["debug"].active = false
				    	elseif br.data.settings[br.selectedSpec]["debug"].active == true then
					    	br.ui:closeWindow("debug")
					    end
		    -- FPS Intensive Functions
					-- Healing Engine
						if isChecked("HE Active") then
							br.friend:Update()
						end

					-- Enemies Engine
						-- EnemiesEngine()

					end --End Update Check
					self.updateInProgress = false
				end -- End Update In Progress Check
		 	end -- End Main Button Active Check
		 end
	end	-- End FireHack Check
	br.debug.cpu.pulse.totalIterations = br.debug.cpu.pulse.totalIterations + 1
	br.debug.cpu.pulse.currentTime = debugprofilestop()-startTime
	br.debug.cpu.pulse.elapsedTime = br.debug.cpu.pulse.elapsedTime + debugprofilestop()-startTime
	br.debug.cpu.pulse.averageTime = br.debug.cpu.pulse.elapsedTime / br.debug.cpu.pulse.totalIterations
end -- End Bad Rotations Update Function
-- Enemies Engine
-- EnemiesEngine();

-- -- Update Player
-- if br.player ~= nil then
-- 	br.player:update()
-- end
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

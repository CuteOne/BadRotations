function br:Engine()
	-- Hidden Frame
	if Pulse_Engine == nil then
		Pulse_Engine = CreateFrame("Frame", nil, UIParent)
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
local frame = CreateFrame("FRAME")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
frame:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED")
function frame:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
    if event == "PLAYER_LOGOUT" then
        br.ui:saveWindowPosition()
        brdata = br.data
    end
    if event == "PLAYER_ENTERING_WORLD" then
    	-- Update Selected Spec
        br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
        br.activeSpecGroup = GetActiveSpecGroup()
    	if not br.loadedIn then
    		bagsUpdated = true
        	br:Run()
        end
        brdata = br.data
    end
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
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
end
frame:SetScript("OnEvent", frame.OnEvent)
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[This function is refired everytime wow ticks. This frame is located at the top of Core.lua]]

function BadRotationsUpdate(self)
	-- getEnemiesInRect(6,25)
	local tempTime = GetTime();
	if not self.lastUpdateTime then
		self.lastUpdateTime = tempTime
	end
	if self.lastUpdateTime and (tempTime - self.lastUpdateTime) > (1/10) then
		self.lastUpdateTime = tempTime


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

		-- prevent ticking when firechack isnt loaded
		-- if user click power button, stop everything from pulsing and hide frames.
		if not getOptionCheck("Start/Stop BadRotations") or (br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 1) then
			br.ui:closeWindow("all")
			return false
		end
		if FireHack == nil then
		 	br.ui:closeWindow("all")
			if getOptionCheck("Start/Stop BadRotations") then
				ChatOverlay("FireHack not Loaded.")
				if br.timer:useTimer("notLoaded", 10) then
					Print("|cffFFFFFFCannot Start... |cffFF1100Firehack |cffFFFFFFis not loaded. Please attach Firehack.")
				end	
			end
			return false
		end

		-- Pulse enemiesEngine
		br:PulseUI()

	    -- get DBM Timer/Bars
	    -- global -> br.DBM.Timer
	    br.DBM:getBars()

	    -- Rotation Log
	    if getOptionCheck("Rotation Log") then
	    	br.ui:createDebugWindow()
	    else
	    	br.ui:closeWindow("debug")
	    end		

		-- Accept dungeon queues
		br:AcceptQueues()

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
        if br.player ~= nil then
        	br.player:update()
        end
	end
end

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

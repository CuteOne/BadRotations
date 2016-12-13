function br:Engine()
	-- Hidden Frame
	if Pulse_Engine == nil then
		Pulse_Engine = CreateFrame("Frame", nil, UIParent)
		Pulse_Engine:SetScript("OnUpdate", BadRotationsUpdate)
		Pulse_Engine:Show()
	end
end
-- Chat Overlay: Originally written by Sheuron.
local function onUpdate(self,elapsed)
	if self.time < GetTime() - 2.0 then if self:GetAlpha() == 0 then self:Hide(); else self:SetAlpha(self:GetAlpha() - 0.02); end end
end
chatOverlay = CreateFrame("Frame",nil,ChatFrame1)
chatOverlay:SetSize(ChatFrame1:GetWidth(),50)
chatOverlay:Hide()
chatOverlay:SetScript("OnUpdate",onUpdate)
chatOverlay:SetPoint("TOP",0,0)
chatOverlay.text = chatOverlay:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
chatOverlay.text:SetAllPoints()
chatOverlay.texture = chatOverlay:CreateTexture()
chatOverlay.texture:SetAllPoints()
chatOverlay.texture:SetTexture(0,0,0,.50)
chatOverlay.time = 0
function ChatOverlay(Message, FadingTime)
	if getOptionCheck("Overlay Messages") then
		chatOverlay:SetSize(ChatFrame1:GetWidth(),50)
		chatOverlay.text:SetText(Message)
		chatOverlay:SetAlpha(1)
		if FadingTime == nil then
			chatOverlay.time = GetTime()
		else
			chatOverlay.time = GetTime() - 2 + FadingTime
		end
		chatOverlay:Show()
	end
end
-- Minimap Button
function br:MinimapButton()
	local dragMode = nil --"free", nil
	local function moveButton(self)
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		centerX, centerY = math.abs(x), math.abs(y)
		centerX, centerY = (centerX / math.sqrt(centerX^2 + centerY^2)) * 76, (centerY / sqrt(centerX^2 + centerY^2)) * 76
		centerX = x < 0 and -centerX or centerX
		centerY = y < 0 and -centerY or centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", centerX, centerY)
	end
	local button = CreateFrame("Button", "BadRotationsButton", Minimap)
	button:SetHeight(25)
	button:SetWidth(25)
	button:SetFrameStrata("MEDIUM")
	button:SetPoint("CENTER", 75.70,-6.63)
	button:SetMovable(true)
	button:SetUserPlaced(true)
	button:SetNormalTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	button:SetPushedTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-Background.blp")
	button:SetScript("OnMouseDown",function(self, button)
		if button == "RightButton" then
			if br.data.settings[br.selectedSpec] then
				if not FireHack then
						Print("|cffFF1100BadRotations |cffFFFFFFCannot Start... |cffFF1100Firehack |cffFFFFFFis not loaded. Please attach Firehack.")
                else
                    if br.ui.window.profile.parent then
                        if br.data.settings[br.selectedSpec].profile["active"] == true then
                            br.ui.window.profile.parent.closeButton:Click()
                        else
                            br.ui.window.profile.parent:Show()
                            br.data.settings[br.selectedSpec].profile["active"] = true
                        end
                    end
				end
			end
        end
        if button == "MiddleButton" then
            if br.ui.window.help then
                br.ui.window.help.parent:Show()
            end
        end
		if IsShiftKeyDown() and IsAltKeyDown() then
			self:SetScript("OnUpdate",moveButton)
		end
	end)
	button:SetScript("OnMouseUp",function(self)
		self:SetScript("OnUpdate",nil)
	end)
	button:SetScript("OnClick",function(self, button)
		if button == "LeftButton" then
			if IsShiftKeyDown() and not IsAltKeyDown() then
				if br.data.settings[br.selectedSpec].toggles["Main"] == 1 then
					br.data.settings[br.selectedSpec].toggles["Main"] = 0
					mainButton:Hide()
				else
					br.data.settings[br.selectedSpec].toggles["Main"] = 1
					mainButton:Show()
				end
			elseif not IsShiftKeyDown() and not IsAltKeyDown() then
                if br.ui.window.config.parent then
                    if br.data.settings[br.selectedSpec].config["active"] == true then
                        br.ui.window.config.parent.closeButton:Click()
                    else
                        br.ui.window.config.parent:Show()
                        br.data.settings[br.selectedSpec].config["active"] = true
                    end
                end
            end
		end
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
		GameTooltip:SetText("BadRotations", 214/255, 25/255, 25/255)
		GameTooltip:AddLine("by CuteOne")
		GameTooltip:AddLine("Left Click to toggle config frame.", 1, 1, 1, 1)
		GameTooltip:AddLine("Shift+Left Click to toggle toggles frame.", 1, 1, 1, 1)
		GameTooltip:AddLine("Alt+Shift+LeftButton to drag.", 1, 1, 1, 1)
		GameTooltip:AddLine("Right Click to open profile options.", 1, 1, 1, 1)
        GameTooltip:AddLine("Middle Click to open help frame.", 1, 1, 1, 1)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
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
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterUnitEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterUnitEvent("CHARACTER_POINTS_CHANGED")
frame:RegisterUnitEvent("PLAYER_ENTERING_WORLD")
frame:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterUnitEvent("PLAYER_LEVEL_UP")
frame:RegisterUnitEvent("PLAYER_TALENT_UPDATE")
frame:RegisterUnitEvent("ZONE_CHANGED")
frame:RegisterUnitEvent("ZONE_CHANGED_NEW_AREA")
function br:reloadOnSpecChange()
    if br.data.settings[br.selectedSpec].toggles["Power"] == 1 then
        ReloadUI()
    end
end
-- Sets 'talentHasChanged' to true
function br:characterTalentChanged()
    if br.talentHasChanged == nil then
        br.talentHasChanged = true
    end
end
-- Sets 'equipHasChanged' to true
function br:characterEquipChanged()
    if br.equipHasChanged ~= true then
        br.equipHasChanged = true
    end
end
function br:savePosition(windowName)
	if br.selectedSpec == nil then br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization())) end
	if br.data.settings[br.selectedSpec] == nil then br.data.settings[br.selectedSpec] = {} end
	if br.data.settings[br.selectedSpec][windowName] == nil then br.data.settings[br.selectedSpec][windowName] = {} end
	if br.ui.window[windowName] ~= nil then
		if br.ui.window[windowName].parent ~= nil then
			local point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(1)
	        br.data.settings[br.selectedSpec][windowName]["point"] = point
	        br.data.settings[br.selectedSpec][windowName]["relativeTo"] = relativeTo:GetName()
	        br.data.settings[br.selectedSpec][windowName]["relativePoint"] = relativePoint
	        br.data.settings[br.selectedSpec][windowName]["xOfs"] = xOfs
	        br.data.settings[br.selectedSpec][windowName]["yOfs"] = yOfs
	        point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(2)
	        if point then
	            br.data.settings[br.selectedSpec][windowName]["point2"] = point
	        	br.data.settings[br.selectedSpec][windowName]["relativeTo2"] = relativeTo:GetName()
	        	br.data.settings[br.selectedSpec][windowName]["relativePoint2"] = relativePoint
	        	br.data.settings[br.selectedSpec][windowName]["xOfs2"] = xOfs
	        	br.data.settings[br.selectedSpec][windowName]["yOfs2"] = yOfs
	        end
	        br.data.settings[br.selectedSpec][windowName]["width"]  = br.ui.window[windowName].parent:GetWidth()
	        br.data.settings[br.selectedSpec][windowName]["height"] = br.ui.window[windowName].parent:GetHeight()
	    end
	end
end
function br:saveWindowPosition()
    br:savePosition("config")
    br:savePosition("debug")
    br:savePosition("profile")
end

function frame:OnEvent(event, arg1, arg2)
    if event == "PLAYER_LOGOUT" then
        br:saveWindowPosition()
        brdata = br.data
    end
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        br:characterEquipChanged() -- Sets a global to indicate equip was changed
    end
    if event == "PLAYER_ENTERING_WORLD" then
    	-- Update Selected Spec
        br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
    	if not br.loadedIn then
    		bagsUpdated = true
        	br:Run()
        end
        brdata = br.data
    end
end
frame:SetScript("OnEvent", frame.OnEvent)
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[This function is refired everytime wow ticks. This frame is located in Core.lua]]
function BadRotationsUpdate(self)
	local tempTime = GetTime();
	if not self.lastUpdateTime then
		self.lastUpdateTime = tempTime
	end
	if self.lastUpdateTime and (tempTime - self.lastUpdateTime) > (1/10) then
		self.lastUpdateTime = tempTime

		-- prevent ticking when firechack isnt loaded
		-- if user click power button, stop everything from pulsing and hide frames.
		if not getOptionCheck("Start/Stop BadRotations") or br.data.settings[br.selectedSpec].toggles["Power"] ~= 1 then
			-- optionsFrame:Hide()
			-- _G["debugFrame"]:Hide()
			br.ui.window.config.parent:Hide()
			br.ui.window.debug.parent:Hide()
			-- br.ui.window.help.parent:Hide()
			br.ui.window.profile.parent:Hide()
			return false
		end
		if FireHack == nil then
			-- optionsFrame:Hide()
			-- _G["debugFrame"]:Hide()
			br.ui.window.config.parent:Hide()
			br.ui.window.debug.parent:Hide()
			-- br.ui.window.help.parent:Hide()
			br.ui.window.profile.parent:Hide()
			if getOptionCheck("Start/Stop BadRotations") then
				ChatOverlay("FireHack not Loaded.")
			end
			return
		end

		-- pulse enemiesEngine
		br:PulseUI()

	    -- get DBM Timer/Bars
	    -- global -> br.DBM.Timer
	    br.DBM:getBars()

	    -- Create Rotation Log
    	if br.ui.window.debug.parent == nil then br.ui:createDebugWindow() end
	    if getOptionCheck("Rotation Log") then
			br.ui.window.debug.parent:Show()
	        br.data.settings[br.selectedSpec].debug["active"] = true
	    end
	    if not getOptionCheck("Rotation Log") then
	    	br.ui.window.debug.parent:Hide()
	    end		

		-- accept dungeon queues
		br:AcceptQueues()

		--[[Class/Spec Selector]]
	    br.selectedProfile = br.data.settings[br.selectedSpec]["Rotation".."Drop"] or 1
		local playerSpec = GetSpecializationInfo(GetSpecialization())
		br.playerSpecName = select(2,GetSpecializationInfo(GetSpecialization()))

		if br.player == nil or br.player.profile ~= br.playerSpecName then
            br.player = br.loader:new(playerSpec,br.playerSpecName)
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

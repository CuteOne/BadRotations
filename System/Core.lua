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
			if br.data.options[br.selectedSpec] then
				if not FireHack then
						print("|cffFF1100BadRotations |cffFFFFFFCannot Start... |cffFF1100Firehack |cffFFFFFFis not loaded. Please attach Firehack.")
                else
                    if br.ui.window.profile.parent then
                        if br.data.options[br.selectedSpec]["configFrame"] == true then
                            br.ui.window.profile.parent.closeButton:Click()
                        else
                            br.ui.window.profile.parent:Show()
                            br.data.options[br.selectedSpec]["configFrame"] = true
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
				if br.data["Main"] == 1 then
					br.data["Main"] = 0
					mainButton:Hide()
				else
					br.data["Main"] = 1
					mainButton:Show()
				end
			elseif not IsShiftKeyDown() and not IsAltKeyDown() then
                if br.ui.window.config.parent then
                    if br.data.options[br.selectedSpec]["optionsFrame"] == true then
                        br.ui.window.config.parent.closeButton:Click()
                    else
                        br.ui.window.config.parent:Show()
                        br.data.options[br.selectedSpec]["optionsFrame"] = true
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
    if br.data["Power"] == 1 then
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
	if br.data.options[br.selectedSpec] == nil then br.data.options[br.selectedSpec] = {} end
	if br.ui.window[windowName] ~= nil then
		if br.ui.window[windowName].parent ~= nil then
			local point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(1)
	        br.data.options[br.selectedSpec][windowName.. "Frame".. "_point"] = point
	        br.data.options[br.selectedSpec][windowName.. "Frame".. "_relativeTo"] = relativeTo:GetName()
	        br.data.options[br.selectedSpec][windowName.. "Frame".. "_relativePoint"] = relativePoint
	        br.data.options[br.selectedSpec][windowName.. "Frame".. "_xOfs"] = xOfs
	        br.data.options[br.selectedSpec][windowName.. "Frame".. "_yOfs"] = yOfs

	        point, relativeTo, relativePoint, xOfs, yOfs = br.ui.window[windowName].parent:GetPoint(2)
	        if point then
	            br.data.options[br.selectedSpec][windowName.. "Frame".. "_point2"] = point
	            br.data.options[br.selectedSpec][windowName.. "Frame".. "_relativeTo2"] = relativeTo:GetName()
	            br.data.options[br.selectedSpec][windowName.. "Frame".. "_relativePoint2"] = relativePoint
	            br.data.options[br.selectedSpec][windowName.. "Frame".. "_xOfs2"] = xOfs
	            br.data.options[br.selectedSpec][windowName.. "Frame".. "_yOfs2"] = yOfs
	        end

	        br.data.options[br.selectedSpec][windowName.. "Frame".. "_width"]  = br.ui.window[windowName].parent:GetWidth()
	        br.data.options[br.selectedSpec][windowName.. "Frame".. "_height"] = br.ui.window[windowName].parent:GetHeight()
	    end
	end
end
function br:saveWindowPosition()
    br:savePosition("profile")
    br.savePosition("config")
end

function frame:OnEvent(event, arg1, arg2)
	if event == "ADDON_LOADED" and arg1 == "BadRotations" then
		--br:Run()
	end
	if ((event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_SPECIALIZATION_CHANGED") and arg1 ~= arg2 and arg2 ~= 0 and br.loadedIn) then
        -- Closing the windows will save the position
        br.ui.window.config.parent.closeButton:Click()
        br.ui.window.profile.parent.closeButton:Click()

        -- Update Selected Spec/Profile
        br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
        br.activeSpecGroup = GetActiveSpecGroup()
        br.talent = {}
        for r = 1, 7 do --search each talent row
            for c = 1, 3 do -- search each talent column
                local _,_,_,selected,_,talentID = GetTalentInfo(r,c,br.activeSpecGroup)
                table.insert(br.talent,talentID,selected)
            end
        end
        if br.data.options[br.selectedSpec]["RotationDrop"] == nil then
	        br.selectedProfile = 1
	    else
	        br.selectedProfile = br.data.options[br.selectedSpec]["RotationDrop"]
	    end

        -- Recreate ConfigWindow with new Spec
        br.ui:createConfigWindow()

        -- rebuild up UI
		BadRotationsFrame()
    end
    if event == "PLAYER_LOGOUT" then
        br:saveWindowPosition()
    end
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        br:characterEquipChanged() -- Sets a global to indicate equip was changed
    end
    if event == "PLAYER_ENTERING_WORLD" then
    	-- Update Selected Spec
        br.selectedSpec = select(2,GetSpecializationInfo(GetSpecialization()))
        br.activeSpecGroup = GetActiveSpecGroup()
        br.talent = {}
        for r = 1, 7 do --search each talent row
            for c = 1, 3 do -- search each talent column
                local _,_,_,selected,_,talentID = GetTalentInfo(r,c,br.activeSpecGroup)
                table.insert(br.talent,talentID,selected)
            end
        end
    	-- Update Selected Spec
    	if not br.loadedIn then
    		bagsUpdated = true
        	br:Run()
        end
    end
    if event == "ZONE_CHANGED" then
        -- temp
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
		-- if user click power button, stop everything from pulsing.
		if not getOptionCheck("Start/Stop BadRotations") or br.data["Power"] ~= 1 then
			optionsFrame:Hide()
			_G["debugFrame"]:Hide()
			return false
		end
		if FireHack == nil then
			optionsFrame:Hide()
			_G["debugFrame"]:Hide()
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

	    -- Show Debug Frame TEMP
	    if isChecked("Debug Frame") then
	        br.ui.window.debug.parent:Show()--_G["debugFrame"]:Show()
	    else
	        br.ui.window.debug.parent:Hide()--_G["debugFrame"]:Hide()
	    end

		-- accept dungeon queues
		br:AcceptQueues()

		--[[Class/Spec Selector]]
	    br.selectedProfile = br.data.options[br.selectedSpec]["Rotation".."Drop"] or 1
		local functionSelector = {
			[ 62] = {className = "Mage", 		specName = "Arcane"},
			[ 63] = {className = "Mage", 		specName = "Fire"},
			[ 64] = {className = "Mage", 		specName = "Frost"},
			[ 65] = {className = "Paladin",		specName = "Holy"},
			[ 66] = {className = "Paladin", 	specName = "Protection"},
			[ 70] = {className = "Paladin", 	specName = "Retribution"},
			[ 71] = {className = "Warrior", 	specName = "Arms"},
			[ 72] = {className = "Warrior", 	specName = "Fury"},
			[ 73] = {className = "Warrior", 	specName = "Protection"},
			[102] = {className = "Druid", 		specName = "Balance"},
			[103] = {className = "Druid", 		specName = "Feral"},
			[104] = {className = "Druid", 		specName = "Guardian"},
			[105] = {className = "Druid", 		specName = "Restoration"},
		 	[250] = {className = "DeathKnight", specName = "Blood"},
		 	[251] = {className = "DeathKnight", specName = "Frost"},
		 	[252] = {className = "DeathKnight", specName = "Unholy"},
		 	[253] = {className = "Hunter", 		specName = "BeastMastery"},
		 	[254] = {className = "Hunter", 		specName = "Marksmanship"},
		 	[255] = {className = "Hunter", 		specName = "Survival"},
		 	[256] = {className = "Priest", 		specName = "Discipline"},
		 	[257] = {className = "Priest", 		specName = "Holy"},
		 	[258] = {className = "Priest", 		specName = "Shadow"},
		 	[259] = {className = "Rogue", 		specName = "Assassination"},
		 	[260] = {className = "Rogue", 		specName = "Outlaw"},
		 	[261] = {className = "Rogue", 		specName = "Subtlety"},
		 	[262] = {className = "Shaman", 		specName = "Elemental"},
		 	[263] = {className = "Shaman", 		specName = "Enhancement"},
		 	[264] = {className = "Shaman", 		specName = "Restoration"},
		 	[265] = {className = "Warlock", 	specName = "Affliction"},
		 	[266] = {className = "Warlock", 	specName = "Demonology"},
		 	[267] = {className = "Warlock", 	specName = "Destruction"},
		 	[268] = {className = "Monk", 		specName = "Brewmaster"},
		 	[269] = {className = "Monk", 		specName = "Windwalker"},
		 	[270] = {className = "Monk", 		specName = "Mistweaver"},
		 	[577] = {className = "DemonHunter", specName = "Havoc"},
		 	[581] = {className = "DemonHunter", specName = "Vengeance"},
		}
		local playerSpec = GetSpecializationInfo(GetSpecialization())
		_G[functionSelector[playerSpec].className..functionSelector[playerSpec].specName]()
	end
end

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

-- this handles old profiles buttons
function TogglesFrame()
	GarbageButtons()
---------------------------
--     Main Button       --
---------------------------
-- Default Values
	emptyIcon = [[Interface\FrameGeneral\UI-Background-Marble]]
	backIconOn = [[Interface\ICONS\Spell_Holy_PowerWordShield]]
	backIconOff = [[Interface\ICONS\SPELL_HOLY_DEVOTIONAURA]]
	genericIconOff = [[Interface\GLUES\CREDITS\Arakkoa1]]
	genericIconOn = [[Interface/BUTTONS/CheckButtonGlow]]
	buttonSize = br.data.settings["buttonSize"]
	buttonWidth = br.data.settings["buttonSize"]
	buttonHeight = br.data.settings["buttonSize"]
	if not mainButton then mainButton = CreateFrame("Button","MyButtonBR",UIParent,"SecureHandlerClickTemplate") end
	mainButton:SetWidth(buttonWidth)
	mainButton:SetHeight(buttonHeight)
	mainButton:RegisterForClicks("AnyUp")
	local anchor,x,y
	if not br.data.settings.mainButton then
		anchor = "CENTER"
		x = -75
		y = -200
	else
		anchor = br.data.settings.mainButton.pos.anchor or "CENTER"
		x = br.data.settings.mainButton.pos.x or -75
		y = br.data.settings.mainButton.pos.y or -200
	end
	mainButton:SetPoint(anchor,x,y)
	mainButton:EnableMouse(true)
	mainButton:SetMovable(true)
	mainButton:SetClampedToScreen(true)
	mainButton:RegisterForDrag("LeftButton")
	mainButton:SetScript("OnDragStart", mainButton.StartMoving)
	mainButton:SetScript("OnDragStop", mainButton.StopMovingOrSizing)
-- Set Main Button
	if br.data.settings[br.selectedSpec] ~= nil and br.data.settings[br.selectedSpec].toggles ~= nil and br.data.settings[br.selectedSpec].toggles['Power'] == 1 then
		mainButton:SetNormalTexture(backIconOn)
	else
		mainButton:SetNormalTexture(backIconOff)
	end
	mainButton:SetScript("OnClick", function()
		if br.data.settings[br.selectedSpec].toggles['Power'] ~= 0 then
			br.data.settings[br.selectedSpec].toggles['Power'] = 0
			mainButton:SetNormalTexture(backIconOff)
			-- on/off switch
			if br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] ~= 0 then
                br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] = 0
                ChatOverlay("|cFFFF0000-= BadRotations Off =-")
			end
			GameTooltip:SetText("|cff00FF00Enable |cffFF0000BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
			mainButtonFrame.texture:SetTexture(genericIconOff)
		else
			br.data.settings[br.selectedSpec].toggles['Power'] = 1
			-- on/off switch
			if br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] ~= 1 then
                br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] = 1
                ChatOverlay("|cFF00FF00-= BadRotations On =-")
			end
			GameTooltip:SetText("|cffFF0000Disable BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
			mainButton:SetNormalTexture(backIconOn)
			mainButtonFrame.texture:SetTexture(genericIconOn)
		end
	end)
	mainButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(mainButton, 0 , 0)
		if br.data.settings[br.selectedSpec].toggles['Power'] == 1 then
			GameTooltip:SetText("|cffFF0000Disable BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
		else
			GameTooltip:SetText("|cff00FF00Enable |cffFF0000BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.", 225/255, 225/255, 225/255)
		end
		GameTooltip:Show()
	end)
	mainButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	mainButton:SetScript("OnReceiveDrag", function(self)
		local _, _, anchor, x, y = mainButton:GetPoint(1)
		br.data.settings.mainButton.pos.x = x
		br.data.settings.mainButton.pos.y = y
		br.data.settings.mainButton.pos.anchor = anchor
	end)
	mainButton:SetScript("OnMouseWheel", function(self, delta)
		if IsLeftAltKeyDown() then
			local Go = false
			if delta < 0 and br.data.settings["buttonSize"] > 1 then
				Go = true
			elseif delta > 0 and br.data.settings["buttonSize"] < 50 then
				Go = true
			end
			if Go == true then
				br.data.settings["buttonSize"] = br.data.settings["buttonSize"] + delta
				mainButton:SetWidth(br.data.settings["buttonSize"])
				mainButton:SetHeight(br.data.settings["buttonSize"])
				mainText:SetTextHeight(br.data.settings["buttonSize"]/3)
				mainText:SetPoint("CENTER",0,-(br.data.settings["buttonSize"]/4))
				mainButtonFrame:SetWidth(br.data.settings["buttonSize"]*1.67)
				mainButtonFrame:SetHeight(br.data.settings["buttonSize"]*1.67)
				mainButtonFrame.texture:SetWidth(br.data.settings["buttonSize"]*1.67)
				mainButtonFrame.texture:SetHeight(br.data.settings["buttonSize"]*1.67)
				buttonsResize()
			end
		end
	end)
	mainButtonFrame = CreateFrame("Frame", nil, mainButton)
	mainButtonFrame:SetWidth(br.data.settings["buttonSize"]*1.67)
	mainButtonFrame:SetHeight(br.data.settings["buttonSize"]*1.67)
	mainButtonFrame:SetPoint("CENTER")
	mainButtonFrame.texture = mainButtonFrame:CreateTexture(mainButton, "OVERLAY")
	mainButtonFrame.texture:SetAllPoints()
	mainButtonFrame.texture:SetWidth(br.data.settings["buttonSize"]*1.67)
	mainButtonFrame.texture:SetHeight(br.data.settings["buttonSize"]*1.67)
	mainButtonFrame.texture:SetAlpha(100)
	mainButtonFrame.texture:SetTexture(genericIconOn)
	mainText = mainButton:CreateFontString(nil, "OVERLAY")
	mainText:SetFont(br.data.settings.font,br.data.settings.fontsize,"THICKOUTLINE")
	mainText:SetTextHeight(br.data.settings["buttonSize"]/3)
	mainText:SetPoint("CENTER",3,-(br.data.settings["buttonSize"]/8))
	mainText:SetTextColor(.90,.90,.90,1)
	if br.data.settings[br.selectedSpec] ~= nil then
		if br.data.settings[br.selectedSpec].toggles == nil then br.data.settings[br.selectedSpec].toggles = {} end
		if br.data.settings[br.selectedSpec].toggles['Power'] == 0 then
			br.data.settings[br.selectedSpec].toggles['Power'] = 0
			mainText:SetText("Off")
			mainButtonFrame.texture:SetTexture(genericIconOff)
		else
			br.data.settings[br.selectedSpec].toggles['Power'] = 1
			mainText:SetText("On")
			mainButtonFrame.texture:SetTexture(genericIconOn)
		end
	end
	buttonsTable = { }
end

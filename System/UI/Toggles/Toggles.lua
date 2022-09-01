local _, br = ...
-- this handles old profiles buttons
function br.TogglesFrame()
	br.GarbageButtons()
	---------------------------
	--     Main Button       --
	---------------------------
	-- Default Values
	br.emptyIcon = [[Interface\FrameGeneral\UI-Background-Marble]]
	br.backIconOn = [[Interface\ICONS\Spell_Holy_PowerWordShield]]
	br.backIconOff = [[Interface\ICONS\SPELL_HOLY_DEVOTIONAURA]]
	br.genericIconOff = [[Interface\GLUES\CREDITS\Arakkoa1]]
	br.genericIconOn = [[Interface/BUTTONS/CheckButtonGlow]]
	br.buttonSize = br.data.settings["buttonSize"]
	br.buttonWidth = br.data.settings["buttonSize"]
	br.buttonHeight = br.data.settings["buttonSize"]
	if not br.mainButton then
		br.mainButton = _G.CreateFrame("Button", "MyButtonBR", br._G.UIParent, "SecureHandlerClickTemplate")
	end
	local mainButtonFrame = _G.CreateFrame("Frame", nil, br.mainButton)
	br.mainButton:SetWidth(br.buttonWidth)
	br.mainButton:SetHeight(br.buttonHeight)
	br.mainButton:RegisterForClicks("AnyUp")
	local anchor, x, y
	if not br.data.settings.mainButton then
		anchor = "CENTER"
		x = -75
		y = -200
	else
		anchor = br.data.settings.mainButton.pos.anchor or "CENTER"
		x = br.data.settings.mainButton.pos.x or -75
		y = br.data.settings.mainButton.pos.y or -200
	end
	br.mainButton:SetPoint(anchor, x, y)
	br.mainButton:EnableMouse(true)
	br.mainButton:SetMovable(true)
	br.mainButton:SetClampedToScreen(true)
	br.mainButton:RegisterForDrag("LeftButton")
	br.mainButton:SetScript("OnDragStart", br.mainButton.StartMoving)
	br.mainButton:SetScript("OnDragStop", br.mainButton.StopMovingOrSizing)
	-- Set Main Button
	if
		br.data.settings[br.selectedSpec] ~= nil and br.data.settings[br.selectedSpec].toggles ~= nil and
			br.data.settings[br.selectedSpec].toggles["Power"] == 1
	 then
		br.mainButton:SetNormalTexture(br.backIconOn)
	else
		br.mainButton:SetNormalTexture(br.backIconOff)
	end
	br.mainButton:SetScript(
		"OnClick",
		function()
			if br.data.settings[br.selectedSpec].toggles["Power"] ~= 0 then
				br.data.settings[br.selectedSpec].toggles["Power"] = 0
				br.mainButton:SetNormalTexture(br.backIconOff)
				-- on/off switch
				if br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] ~= 0 then
					br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] = 0
					br.ChatOverlay("|cFFFF0000-= BadRotations Off =-")
				end
				_G.GameTooltip:SetText(
					"|cff00FF00Enable |cffFF0000BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
				mainButtonFrame.texture:SetTexture(br.genericIconOff)
			else
				br.data.settings[br.selectedSpec].toggles["Power"] = 1
				-- on/off switch
				if br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] ~= 1 then
					br.data.settings[br.selectedSpec]["Start/Stop BadRotationsCheck"] = 1
					br.ChatOverlay("|cFF00FF00-= BadRotations On =-")
				end
				_G.GameTooltip:SetText(
					"|cffFF0000Disable BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
				br.mainButton:SetNormalTexture(br.backIconOn)
				mainButtonFrame.texture:SetTexture(br.genericIconOn)
			end
		end
	)
	br.mainButton:SetScript(
		"OnEnter",
		function()
			_G.GameTooltip:SetOwner(br.mainButton, 0, 0)
			if br.data.settings[br.selectedSpec].toggles["Power"] == 1 then
				_G.GameTooltip:SetText(
					"|cffFF0000Disable BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
			else
				_G.GameTooltip:SetText(
					"|cff00FF00Enable |cffFF0000BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
			end
			_G.GameTooltip:Show()
		end
	)
	br.mainButton:SetScript(
		"OnLeave",
		function()
			_G.GameTooltip:Hide()
		end
	)
	br.mainButton:SetScript(
		"OnReceiveDrag",
		function()
			local _, _, anchor, x, y = br.mainButton:GetPoint(1)
			br.data.settings.mainButton.pos.x = x
			br.data.settings.mainButton.pos.y = y
			br.data.settings.mainButton.pos.anchor = anchor
		end
	)
	br.mainButton:SetScript(
		"OnMouseWheel",
		function(_,delta)
			if _G.IsLeftAltKeyDown() then
				local Go = false
				if delta < 0 and br.data.settings["buttonSize"] > 1 then
					Go = true
				elseif delta > 0 and br.data.settings["buttonSize"] < 50 then
					Go = true
				end
				if Go == true then
					br.data.settings["buttonSize"] = br.data.settings["buttonSize"] + delta
					br.mainButton:SetWidth(br.data.settings["buttonSize"])
					br.mainButton:SetHeight(br.data.settings["buttonSize"])
					br.mainText:SetTextHeight(br.data.settings["buttonSize"] / 3)
					br.mainText:SetPoint("CENTER", 0, -(br.data.settings["buttonSize"] / 4))
					mainButtonFrame:SetWidth(br.data.settings["buttonSize"] * 1.67)
					mainButtonFrame:SetHeight(br.data.settings["buttonSize"] * 1.67)
					mainButtonFrame.texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
					mainButtonFrame.texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
					br.buttonsResize()
				end
			end
		end
	)
	mainButtonFrame:SetWidth(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame:SetHeight(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame:SetPoint("CENTER")
	mainButtonFrame.texture = mainButtonFrame:CreateTexture(br.mainButton, "OVERLAY")
	mainButtonFrame.texture:SetAllPoints()
	mainButtonFrame.texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame.texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame.texture:SetAlpha(100)
	mainButtonFrame.texture:SetTexture(br.genericIconOn)
	br.mainText = br.mainButton:CreateFontString(nil, "OVERLAY")
	br.mainText:SetFont(br.data.settings.font, br.data.settings.fontsize, "THICKOUTLINE")
	br.mainText:SetTextHeight(br.data.settings["buttonSize"] / 3)
	br.mainText:SetPoint("CENTER", 3, -(br.data.settings["buttonSize"] / 8))
	br.mainText:SetTextColor(.90, .90, .90, 1)
	if br.data.settings[br.selectedSpec] ~= nil then
		if br.data.settings[br.selectedSpec].toggles == nil then
			br.data.settings[br.selectedSpec].toggles = {}
		end
		if br.data.settings[br.selectedSpec].toggles["Power"] == 0 then
			br.mainText:SetText("Off")
			mainButtonFrame.texture:SetTexture(br.genericIconOff)
		else
			br.data.settings[br.selectedSpec].toggles["Power"] = 1
			br.mainText:SetText("On")
			mainButtonFrame.texture:SetTexture(br.genericIconOn)
		end
	end
	br.buttonsTable = {}
end

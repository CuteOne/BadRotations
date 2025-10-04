local _, br = ...
br.ui.toggles = br.ui.toggles or {}
local toggles = br.ui.toggles
-- this handles old profiles buttons
function toggles:TogglesFrame()
	br.ui:GarbageButtons()
	---------------------------
	--     Main Button       --
	---------------------------
	-- Default Values
	toggles.emptyIcon = [[Interface\FrameGeneral\UI-Background-Marble]]
	toggles.backIconOn = [[Interface\ICONS\Spell_Holy_PowerWordShield]]
	toggles.backIconOff = [[Interface\ICONS\SPELL_HOLY_DEVOTIONAURA]]
	toggles.genericIconOff = [[Interface\GLUES\CREDITS\Arakkoa1]]
	toggles.genericIconOn = [[Interface/BUTTONS/CheckButtonGlow]]
	toggles.buttonSize = br.data.settings["buttonSize"]
	toggles.buttonWidth = br.data.settings["buttonSize"]
	toggles.buttonHeight = br.data.settings["buttonSize"]
	if not toggles.mainButton then
		toggles.mainButton = br._G.CreateFrame("Button", "MyButtonBR", br._G.UIParent, "SecureHandlerClickTemplate")
	end
	local mainButtonFrame = br._G.CreateFrame("Frame", nil, toggles.mainButton)
	toggles.mainButton:SetWidth(toggles.buttonWidth)
	toggles.mainButton:SetHeight(toggles.buttonHeight)
	toggles.mainButton:RegisterForClicks("AnyUp")
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
	toggles.mainButton:ClearAllPoints()
	toggles.mainButton:SetPoint(anchor, x, y)
	toggles.mainButton:EnableMouse(true)
	toggles.mainButton:SetMovable(true)
	toggles.mainButton:SetClampedToScreen(true)
	toggles.mainButton:RegisterForDrag("LeftButton")
	toggles.mainButton:SetScript("OnDragStart", toggles.mainButton.StartMoving)
	toggles.mainButton:SetScript("OnDragStop", toggles.mainButton.StopMovingOrSizing)
	-- Set Main Button
	if
		br.data.settings[br.loader.selectedSpec] ~= nil and br.data.settings[br.loader.selectedSpec].toggles ~= nil and
		br.data.settings[br.loader.selectedSpec].toggles["Power"] == 1
	then
		toggles.mainButton:SetNormalTexture(toggles.backIconOn)
	else
		toggles.mainButton:SetNormalTexture(toggles.backIconOff)
	end
	toggles.mainButton:SetScript(
		"OnClick",
		function()
			if br.data.settings[br.loader.selectedSpec].toggles["Power"] ~= 0 then
				br.data.settings[br.loader.selectedSpec].toggles["Power"] = 0
				toggles.mainButton:SetNormalTexture(toggles.backIconOff)
				-- on/off switch
				if br.data.settings[br.loader.selectedSpec]["Start/Stop BadRotationsCheck"] ~= 0 then
					br.data.settings[br.loader.selectedSpec]["Start/Stop BadRotationsCheck"] = 0
					br.ui.chatOverlay:Show("|cFFFF0000-= BadRotations Off =-")
				end
				br._G.GameTooltip:SetText(
					"|cff00FF00Enable |cffFF0000BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
				mainButtonFrame.texture:SetTexture(toggles.genericIconOff)
			else
				br.data.settings[br.loader.selectedSpec].toggles["Power"] = 1
				-- on/off switch
				if br.data.settings[br.loader.selectedSpec]["Start/Stop BadRotationsCheck"] ~= 1 then
					br.data.settings[br.loader.selectedSpec]["Start/Stop BadRotationsCheck"] = 1
					br.ui.chatOverlay:Show("|cFF00FF00-= BadRotations On =-")
				end
				br._G.GameTooltip:SetText(
					"|cffFF0000Disable BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
				toggles.mainButton:SetNormalTexture(toggles.backIconOn)
				mainButtonFrame.texture:SetTexture(toggles.genericIconOn)
			end
		end
	)
	toggles.mainButton:SetScript(
		"OnEnter",
		function()
			br._G.GameTooltip:SetOwner(toggles.mainButton, 0, 0)
			if br.data.settings[br.loader.selectedSpec].toggles["Power"] == 1 then
				br._G.GameTooltip:SetText(
					"|cffFF0000Disable BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
			else
				br._G.GameTooltip:SetText(
					"|cff00FF00Enable |cffFF0000BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size.",
					225 / 255,
					225 / 255,
					225 / 255
				)
			end
			br._G.GameTooltip:Show()
		end
	)
	toggles.mainButton:SetScript(
		"OnLeave",
		function()
			br._G.GameTooltip:Hide()
		end
	)
	-- toggles.mainButton:SetScript(
	-- 	"OnReceiveDrag",
	-- 	function(frame)
	-- 		local self = frame.obj
	-- 		print("Dragging Togglebar!")
	-- 		local _, _, anchor, x, y = self:GetPoint(1)
	-- 		br.data.settings.mainButton.pos.x = x
	-- 		br.data.settings.mainButton.pos.y = y
	-- 		br.data.settings.mainButton.pos.anchor = anchor
	-- 	end
	-- )
	toggles.mainButton:SetScript(
		"OnDragStop",
		function()
			local _, _, anchor, x, y = toggles.mainButton:GetPoint(1)
			br.data.settings.mainButton.pos.x = x
			br.data.settings.mainButton.pos.y = y
			br.data.settings.mainButton.pos.anchor = anchor
			toggles.mainButton:StopMovingOrSizing()
		end
	)
	toggles.mainButton:SetScript(
		"OnMouseWheel",
		function(_, delta)
			if br._G.IsLeftAltKeyDown() then
				local Go = false
				if delta < 0 and br.data.settings["buttonSize"] > 1 then
					Go = true
				elseif delta > 0 and br.data.settings["buttonSize"] < 50 then
					Go = true
				end
				if Go == true then
					br.data.settings["buttonSize"] = br.data.settings["buttonSize"] + delta
					toggles.mainButton:SetWidth(br.data.settings["buttonSize"])
					toggles.mainButton:SetHeight(br.data.settings["buttonSize"])
					toggles.mainText:SetTextHeight(br.data.settings["buttonSize"] / 3)
					toggles.mainText:SetPoint("CENTER", 0, -(br.data.settings["buttonSize"] / 4))
					mainButtonFrame:SetWidth(br.data.settings["buttonSize"] * 1.67)
					mainButtonFrame:SetHeight(br.data.settings["buttonSize"] * 1.67)
					mainButtonFrame.texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
					mainButtonFrame.texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
					br.ui:buttonsResize()
				end
			end
		end
	)
	mainButtonFrame:SetWidth(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame:SetHeight(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame:SetPoint("CENTER")
	mainButtonFrame.texture = mainButtonFrame:CreateTexture(nil, "OVERLAY")
	mainButtonFrame.texture:SetAllPoints()
	mainButtonFrame.texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame.texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
	mainButtonFrame.texture:SetAlpha(1)
	mainButtonFrame.texture:SetTexture(toggles.genericIconOn)
	toggles.mainText = toggles.mainButton:CreateFontString(nil, "OVERLAY")
	toggles.mainText:SetFont(br.data.settings.font, br.data.settings.fontsize, "THICKOUTLINE")
	toggles.mainText:SetTextHeight(br.data.settings["buttonSize"] / 3)
	toggles.mainText:SetPoint("CENTER", 3, -(br.data.settings["buttonSize"] / 8))
	toggles.mainText:SetTextColor(.90, .90, .90, 1)
	if br.data.settings[br.loader.selectedSpec] ~= nil then
		if br.data.settings[br.loader.selectedSpec].toggles == nil then
			br.data.settings[br.loader.selectedSpec].toggles = {}
		end
		if br.data.settings[br.loader.selectedSpec].toggles["Power"] == 0 then
			br.data.settings[br.loader.selectedSpec].toggles["Power"] = 0
			toggles.mainText:SetText("Off")
			mainButtonFrame.texture:SetTexture(toggles.genericIconOff)
		else
			br.data.settings[br.loader.selectedSpec].toggles["Power"] = 1
			toggles.mainText:SetText("On")
			mainButtonFrame.texture:SetTexture(toggles.genericIconOn)
		end
	end
	toggles.buttonsTable = {}
end

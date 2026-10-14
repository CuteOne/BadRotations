local _, br = ...
br.ui.toggles = br.ui.toggles or {}
local toggles = br.ui.toggles

local function specToggles()
	local specSettings = br.data.settings[br.loader.selectedSpec]
	return specSettings and specSettings.toggles
end

-- Power is on unless it was switched off (a new spec has none saved yet)
local function isPowerOn()
	local saved = specToggles()
	return saved == nil or saved["Power"] ~= 0
end

-- The main button's tooltip, which says what a click does
local function mainTip()
	local text = isPowerOn() and "|cffFF0000Disable BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size."
		or "|cff00FF00Enable |cffFF0000BadRotations \n|cffFFDD11Hold Left Alt and scroll mouse to adjust size."
	br._G.GameTooltip:SetText(text, 225 / 255, 225 / 255, 225 / 255)
end

-- Sizes the main button for the current button size
local function layoutMain()
	local size = br.data.settings["buttonSize"]
	toggles.mainButton:SetSize(size, size)
	toggles.mainText:SetTextHeight(size / 3)
	toggles.mainText:ClearAllPoints()
	toggles.mainText:SetPoint("CENTER", 3, -(size / 8))
	toggles.mainGlow:SetSize(size * 1.67, size * 1.67)
end

--- Makes the toggle bar's main button (the BadRotations on/off switch that the toggle buttons sit on).
function toggles:TogglesFrame()
	toggles.emptyIcon = [[Interface\FrameGeneral\UI-Background-Marble]]
	toggles.backIconOn = [[Interface\ICONS\Spell_Holy_PowerWordShield]]
	toggles.backIconOff = [[Interface\ICONS\SPELL_HOLY_DEVOTIONAURA]]
	toggles.genericIconOff = [[Interface\GLUES\CREDITS\Arakkoa1]]
	toggles.genericIconOn = [[Interface/BUTTONS/CheckButtonGlow]]
	if toggles.mainButton then return end
	local mainButton = br._G.CreateFrame("Button", nil, br._G.UIParent)
	toggles.mainButton = mainButton
	mainButton:RegisterForClicks("AnyUp")
	local pos = br.data.settings.mainButton and br.data.settings.mainButton.pos or {}
	mainButton:ClearAllPoints()
	mainButton:SetPoint(pos.anchor or "CENTER", pos.x or -75, pos.y or -200)
	mainButton:EnableMouse(true)
	mainButton:SetMovable(true)
	mainButton:SetClampedToScreen(true)
	mainButton:RegisterForDrag("LeftButton")
	mainButton:SetScript("OnDragStart", mainButton.StartMoving)

	local glow = br._G.CreateFrame("Frame", nil, mainButton)
	glow:SetPoint("CENTER")
	glow.texture = glow:CreateTexture(nil, "OVERLAY")
	glow.texture:SetAllPoints()
	glow.texture:SetAlpha(1)
	toggles.mainGlow = glow
	local mainText = mainButton:CreateFontString(nil, "OVERLAY")
	mainText:SetFont(br.data.settings.font, br.data.settings.fontsize, "THICKOUTLINE")
	mainText:SetTextColor(.90, .90, .90, 1)
	toggles.mainText = mainText
	layoutMain()

	mainButton:SetScript("OnClick", function()
		local turnOn = not isPowerOn()
		local specSettings = br.data.settings[br.loader.selectedSpec]
		specSettings.toggles = specSettings.toggles or {}
		local saved = specSettings.toggles
		saved["Power"] = turnOn and 1 or 0
		br.log.session:toggleChanged("Power", saved["Power"])
		-- on/off switch
		if specSettings["Start/Stop BadRotationsCheck"] ~= saved["Power"] then
			specSettings["Start/Stop BadRotationsCheck"] = saved["Power"]
			br.ui.chatOverlay:Show(turnOn and "|cFF00FF00-= BadRotations On =-" or "|cFFFF0000-= BadRotations Off =-")
		end
		mainButton:SetNormalTexture(turnOn and toggles.backIconOn or toggles.backIconOff)
		glow.texture:SetTexture(turnOn and toggles.genericIconOn or toggles.genericIconOff)
		if br._G.GameTooltip:IsOwned(mainButton) then mainTip() end
		br.ui.settingsManagement:saveIfLoaded()
	end)
	mainButton:SetScript("OnEnter", function()
		br._G.GameTooltip:SetOwner(mainButton, "ANCHOR_RIGHT")
		mainTip()
		br._G.GameTooltip:Show()
	end)
	mainButton:SetScript("OnLeave", function()
		br._G.GameTooltip:Hide()
	end)
	mainButton:SetScript("OnDragStop", function()
		mainButton:StopMovingOrSizing()
		local anchor, _, _, x, y = mainButton:GetPoint(1)
		br.data.settings.mainButton = br.data.settings.mainButton or {}
		br.data.settings.mainButton.pos = { anchor = anchor, x = x, y = y }
		br.ui.settingsManagement:saveIfLoaded()
	end)
	mainButton:SetScript("OnMouseWheel", function(_, delta)
		if not br._G.IsLeftAltKeyDown() then return end
		local size = br.data.settings["buttonSize"] + delta
		if size < 1 or size > 50 then return end
		br.data.settings["buttonSize"] = size
		layoutMain()
		br.ui:buttonsResize()
	end)

	-- Show the saved Power state (a new spec starts on)
	local saved = specToggles()
	if saved ~= nil then
		saved["Power"] = saved["Power"] == 0 and 0 or 1
		mainText:SetText(saved["Power"] == 1 and "On" or "Off")
	end
	mainButton:SetNormalTexture(isPowerOn() and toggles.backIconOn or toggles.backIconOff)
	glow.texture:SetTexture(isPowerOn() and toggles.genericIconOn or toggles.genericIconOff)
end

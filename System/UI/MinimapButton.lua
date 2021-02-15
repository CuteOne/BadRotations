local _, br = ...
-- Minimap Button
function br:MinimapButton()
	local dragMode = nil --"free", nil
	local function moveButton(self)
		local centerX, centerY = br._G.Minimap:GetCenter()
		local x, y = br._G.GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		centerX, centerY = math.abs(x), math.abs(y)
		centerX, centerY =
			(centerX / math.sqrt(centerX ^ 2 + centerY ^ 2)) * 76,
			(centerY / math.sqrt(centerX ^ 2 + centerY ^ 2)) * 76
		centerX = x < 0 and -centerX or centerX
		centerY = y < 0 and -centerY or centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", centerX, centerY)
	end
	br.BadRotationsButton = br._G.CreateFrame("Button", "BadRotationsButton", br._G.Minimap)
	br.BadRotationsButton:SetHeight(25)
	br.BadRotationsButton:SetWidth(25)
	br.BadRotationsButton:SetFrameStrata("MEDIUM")
	br.BadRotationsButton:SetPoint("CENTER", 75.70, -6.63)
	br.BadRotationsButton:SetMovable(true)
	br.BadRotationsButton:SetUserPlaced(true)
	br.BadRotationsButton:SetNormalTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	br.BadRotationsButton:SetPushedTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
	br.BadRotationsButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-Background.blp")
	br.BadRotationsButton:SetScript(
		"OnMouseDown",
		function(self, button)
			if button == "RightButton" then
				br.ui:toggleWindow("profile")
			end
			if button == "MiddleButton" then
				if br.ui.window.help.parent == nil then
					br.ui:createHelpWindow()
				else
					br.ui:toggleWindow("help")
				end
			end
			if br._G.IsShiftKeyDown() and br._G.IsAltKeyDown() then
				self:SetScript("OnUpdate", moveButton)
			end
		end
	)
	br.BadRotationsButton:SetScript(
		"OnMouseUp",
		function(self)
			self:SetScript("OnUpdate", nil)
		end
	)
	br.BadRotationsButton:SetScript(
		"OnClick",
		function(self, button)
			if button == "LeftButton" then
				if br._G.IsShiftKeyDown() and not br._G.IsAltKeyDown() and not br._G.UnitAffectingCombat("player") then
					if br.data.settings[br.selectedSpec].toggles["Main"] == 1 then
						br.data.settings[br.selectedSpec].toggles["Main"] = 0
						br.mainButton:Hide()
					else
						br.data.settings[br.selectedSpec].toggles["Main"] = 1
						br.mainButton:Show()
					end
				elseif br._G.IsShiftKeyDown() and not br._G.IsAltKeyDown() and br._G.UnitAffectingCombat("player") then
					br._G_.print("Combat Lockdown detected. Unable to modify br.BadRotationsButton bar. Please try again when out of combat.")
				elseif not br._G.IsShiftKeyDown() and not br._G.IsAltKeyDown() then
					br.ui:toggleWindow("config")
				end
			end
		end
	)
	br.BadRotationsButton:SetScript(
		"OnEnter",
		function(self)
			br._G.GameTooltip:SetOwner(br._G.Minimap, "ANCHOR_CURSOR", 50, 50)
			br._G.GameTooltip:SetText("BadRotations", 214 / 255, 25 / 255, 25 / 255)
			br._G.GameTooltip:AddLine("by CuteOne")
			br._G.GameTooltip:AddLine("Left Click to toggle config frame.", 1, 1, 1, 1)
			br._G.GameTooltip:AddLine("Shift+Left Click to toggle toggles frame.", 1, 1, 1, 1)
			br._G.GameTooltip:AddLine("Alt+Shift+LeftButton to drag.", 1, 1, 1, 1)
			br._G.GameTooltip:AddLine("Right Click to open profile options.", 1, 1, 1, 1)
			br._G.GameTooltip:AddLine("Middle Click to open help frame.", 1, 1, 1, 1)
			br._G.GameTooltip:Show()
		end
	)
	br.BadRotationsButton:SetScript(
		"OnLeave",
		function(self)
			br._G.GameTooltip:Hide()
		end
	)
end

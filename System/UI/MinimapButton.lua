local _, br = ...
-- Minimap Button
function br:MinimapButton()
	-- Handle different shaped minimaps
	local minimap_shape_quads = {
		["ROUND"] = {true,true,true,true},
		["SQUARE"] = {false,false,false,false},
		["CORNER-TOPLEFT"] = {false,false,false,true},
		["CORNER-TOPRIGHT"] = {false, false, true, false},
		["CORNER-BOTTOMLEFT"] = {false, true, false, false},
		["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
		["SIDE-LEFT"] = {false, true, false, true},
		["SIDE-RIGHT"] = {true,false,true,false},
		["SIDE-TOP"] = {false,false,true,true},
		["SIDE-BOTTOM"] = {true,true,false,false},
		["TRICORNER-TOPLEFT"] = {false,true,true,true},
		["TRICORNER-TOPRIGHT"] = {true,false,true,true},
		["TRICORNER-BOTTOMLEFT"] = {true,true,false,true},
		["TRICORNER-BOTTOMRIGHT"] = {true,true,true,false},
	}

	local function update_position(self, position)
		local angle = math.rad(position or 225)
		local x, y, q = math.cos(angle), math.sin(angle), 1
		if x < 0 then q = q + 1 end
		if y > 0 then q = q + 2 end
		local shape = br._G.GetMinimapShape and br._G.GetMinimapShape() or "ROUND"
		local quad_table = minimap_shape_quads[shape]
		local w = (br._G.Minimap:GetWidth() / 2) + 5
		local h = (br._G.Minimap:GetHeight() / 2) + 5
		if quad_table[q] then
			x, y = x * w, y * h
		else
			local radiusw = math.sqrt(2*(w)^2)-10
			local radiush = math.sqrt(2*(h)^2)-10
			x = math.max(-w, math.min(x*radiusw, w))
			y = math.max(-h, math.min(y*radiush, h))
		end
		br.data.settings.minimapButton.pos.x = x
		br.data.settings.minimapButton.pos.y = y
		self:ClearAllPoints()
		self:SetPoint("CENTER", br._G.Minimap, "CENTER", x, y)
	end
	-- local dragMode = nil -- "free", nil
	local function moveButton(self)
		local centerX, centerY = br._G.Minimap:GetCenter()
		local x, y = br._G.GetCursorPosition()
		x, y = x / self:GetEffectiveScale(), y / self:GetEffectiveScale()
		local pos = math.deg(math.atan2(y - centerY, x - centerX)) % 360
		update_position(self, pos)
	end
	br.BadRotationsButton = br._G.CreateFrame("Button", "BadRotationsButton", br._G.Minimap)
	br.BadRotationsButton:SetHeight(25)
	br.BadRotationsButton:SetWidth(25)
	br.BadRotationsButton:SetFrameStrata("MEDIUM")
	local x, y
	if not br.data.settings.minimapButton then
		x = 75.70
		y = -6.63
	else
		x = br.data.settings.minimapButton.pos.x or 75.70
		y = br.data.settings.minimapButton.pos.y or -6.63
	end
	br.BadRotationsButton:SetPoint("CENTER", x, y)
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
			if not br.unlocked then
				print("|cffFFFFFFCannot Start... |cffFF1100BR |cffFFFFFFcan not complete loading. Please check requirements.")
			end
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

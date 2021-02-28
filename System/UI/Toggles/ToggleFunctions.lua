local _, br = ...
function br.ui:createToggle(table,name,col,row)
	br[name.."Modes"] = table
	br["CreateButton"](name,col,row)
end
-- when we find a match, we reset tooltip
function br.ResetTip(toggleValue, thisValue)
	_G.GameTooltip:SetOwner(br["button" .. toggleValue], br.mainButton, 0, 0)
	_G.GameTooltip:SetText(br[toggleValue .. "Modes"][thisValue].tip, 225 / 255, 225 / 255, 225 / 255, nil, true)
	_G.GameTooltip:Show()
end

function br.GarbageButtons()
	if br.buttonsTable and not _G.UnitAffectingCombat("player") then
		for i = 1, #br.buttonsTable do
			local Name = br.buttonsTable[i].name
			br["button" .. Name]:Hide()
			br["text" .. Name]:Hide()
			br["frame" .. Name].texture:Hide()
			br[Name .. "Modes"] = nil
		end
	end
end

local function FindToggle(toggleValue)
	local toggles = br.data.settings[br.selectedSpec].toggles
	for k, _ in pairs(toggles) do
		if string.upper(toggleValue) == string.upper(k) then
			return k
		end
	end
	return nil
end

function br.ToggleToValue(toggleValue, index)
	if br[toggleValue .. "Modes"] == nil then
		toggleValue = FindToggle(toggleValue)
	end
	index = tonumber(index)
	local modesCount = #br[toggleValue .. "Modes"]
	if index > modesCount then
		br._G.print(
			"Invalid Toggle Index for |cffFFDD11" ..
				toggleValue ..
					": |cFFFF0000 Index ( |r" .. index .. "|cFFFF0000) exceeds Max ( |r" .. modesCount .. "|cFFFF0000)|r."
		)
	else
		br.specialToggleCodes(toggleValue, index)
		if not br.data.settings[br.selectedSpec].toggles then
			br.data.settings[br.selectedSpec].toggles = {}
		end
		br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = index
		br.changeButton(toggleValue, index)
		-- We reset the tip
		br.ResetTip(toggleValue, index)
	end
end

function br.ToggleValue(toggleValue)
	if br[toggleValue .. "Modes"] == nil then
		toggleValue = FindToggle(toggleValue)
	end
	-- prevent nil fails
	local toggleOldValue
	if br.data.settings[br.selectedSpec].toggles then
		toggleOldValue = br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] or 1
	end
	local modesCount = #br[toggleValue .. "Modes"]
	if toggleOldValue == nil then
		if not br.data.settings[br.selectedSpec].toggles then
			br.data.settings[br.selectedSpec].toggles = {}
		end
		br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = 1
		toggleOldValue = br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)]
	end
	-- Scan Table and find which mode = our i
	for i = 1, modesCount do
		if toggleOldValue == i then
			-- see if we can go higher in modes is #modes > i
			if modesCount > i then
				-- calculate newValue
				local newValue = i + 1
				br.specialToggleCodes(toggleValue, newValue)
				-- We set the value in DB
				br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = newValue
				br.changeButton(toggleValue, newValue)
				-- We reset the tip
				br.ResetTip(toggleValue, newValue)
				break
			else
				br.specialToggleCodes(toggleValue, 1)
				-- if cannot go higher we define mode to 1.
				br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = 1
				br.changeButton(toggleValue, 1)
				-- We reset the tip
				br.ResetTip(toggleValue, 1)
				break
			end
		end
	end
end

function br.ToggleMinus(toggleValue)
	if br[toggleValue .. "Modes"] == nil then
		toggleValue = FindToggle(toggleValue)
	end
	-- prevent nil fails
	if not br.data.settings[br.selectedSpec].toggles then
		br.data.settings[br.selectedSpec].toggles = {}
	end
	if br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] == nil then
		br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = 1
	end
	local modesCount = #br[toggleValue .. "Modes"]
	-- Scan Table and find which mode = our i
	for i = 1, modesCount do
		local thisValue = br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] or 1
		if thisValue == i then
			-- see if we can go lower in modes
			local newValue = i - 1
			if i > 1 then
				-- calculate newValue
				br.specialToggleCodes(toggleValue, newValue)
				-- We set the value in DB
				br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = newValue
				-- change the button
				br.changeButton(toggleValue, newValue)
				-- We reset the tip
				br.ResetTip(toggleValue, newValue)
				break
			else
				-- if cannot go higher we define to last mode
				br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = modesCount
				br.specialToggleCodes(toggleValue, newValue)
				br.changeButton(toggleValue, newValue)
				-- We reset the tip
				br.ResetTip(toggleValue, newValue)
				break
			end
		end
	end
end

function br.specialToggleCodes(toggleValue, newValue)
	if toggleValue == "Interrupts" then
		local InterruptsModes = br.InterruptsModes
		if newValue == 1 and InterruptsModes[1].mode == "None" then
			-- no interupts mode
			if br.data.settings[br.selectedSpec]["Interrupts HandlerCheck"] ~= 0 then
				br["optionsInterrupts HandlerCheck"]:Click()
			end
		elseif newValue == 2 and InterruptsModes[2].mode == "Raid" then
			-- on/off switch
			if br.data.settings[br.selectedSpec]["Interrupts HandlerCheck"] ~= 1 then
				br["optionsInterrupts HandlerCheck"]:Click()
			end
			-- only known switch
			if br.data.settings[br.selectedSpec]["Only Known UnitsCheck"] ~= 1 then
				br["optionsOnly Known UnitsCheck"]:Click()
			end
		elseif newValue == 3 and InterruptsModes[3].mode == "All" then
			-- interrupt all mode
			-- on/off switch
			if br.data.settings[br.selectedSpec]["Interrupts HandlerCheck"] ~= 1 then
				br["optionsInterrupts HandlerCheck"]:Click()
			end
			-- only known switch
			if br.data.settings[br.selectedSpec]["Only Known UnitsCheck"] ~= 0 then
				br["optionsOnly Known UnitsCheck"]:Click()
			end
		end
	end
end

function br.changeButtonValue(toggleValue, newValue)
	if br[toggleValue .. "Modes"] == nil then
		toggleValue = FindToggle(toggleValue)
	end
	br.data.settings[br.selectedSpec].toggles[tostring(toggleValue)] = newValue
end

-- set to desired button value
function br.changeButton(toggleValue, newValue)
	local Icon
	-- define text
	br["text" .. toggleValue]:SetText(br[toggleValue .. "Modes"][newValue].mode)
	-- define icon
	if type(br[toggleValue .. "Modes"][newValue].icon) == "number" then
		Icon = select(3, _G.GetSpellInfo(br[toggleValue .. "Modes"][newValue].icon))
	else
		Icon = br[toggleValue .. "Modes"][newValue].icon
	end
	br["button" .. toggleValue]:SetNormalTexture(Icon or br.emptyIcon)
	-- define highlight
	if br[toggleValue .. "Modes"][newValue].highlight == 0 then
		br["frame" .. toggleValue].texture:SetTexture(br.genericIconOff)
	else
		br["frame" .. toggleValue].texture:SetTexture(br.genericIconOn)
	end
	-- We tell the user we changed mode
	br.ChatOverlay("\124cFF3BB0FF" .. br[toggleValue .. "Modes"][newValue].overlay)
	-- We reset the tip
	br.ResetTip(toggleValue, newValue)
end

function br.UpdateButton(Name)
	Name = tostring(Name) --string.upper(Name)
	br.ToggleValue(Name)
end

function br.buttonsResize()
	for i = 1, #br.buttonsTable do
		local Name = br.buttonsTable[i].name
		local x = br.buttonsTable[i].bx
		local y = br.buttonsTable[i].by
		br["button" .. Name]:SetWidth(br.data.settings["buttonSize"])
		br["button" .. Name]:SetHeight(br.data.settings["buttonSize"])
		br["button" .. Name]:SetPoint("LEFT", x * (br.data.settings["buttonSize"]), y * (br.data.settings["buttonSize"]))
		br["text" .. Name]:SetTextHeight(br.data.settings["buttonSize"] / 3)
		br["text" .. Name]:SetPoint("CENTER", 0, -(br.data.settings["buttonSize"] / 4))
		br["frame" .. Name]:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br["frame" .. Name]:SetHeight(br.data.settings["buttonSize"] * 1.67)
		br["frame" .. Name].texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br["frame" .. Name].texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
	end
end

-- /run CreateButton("AoE",2,2)
function br.CreateButton(Name, x, y)
	if br.data.settings[br.selectedSpec] ~= nil then
		local Icon
		-- local Name = string.upper(Name)
		-- todo: extend to use spec + profile specific variable; ATM it shares between profile AND spec, -> global for char
		if
			br.data.settings[br.selectedSpec].toggles[Name] == nil or
				br.data.settings[br.selectedSpec].toggles[Name] > #br[Name .. "Modes"]
		 then
			br.data.settings[br.selectedSpec].toggles[Name] = 1
		end
		if br.buttonsTable then
			_G.tinsert(br.buttonsTable, {name = Name, bx = x, by = y})
		end
		br["button" .. Name] = _G.CreateFrame("Button", "MyButtonBR", br.mainButton, "SecureHandlerClickTemplate")
		br["button" .. Name]:SetWidth(br.data.settings["buttonSize"])
		br["button" .. Name]:SetHeight(br.data.settings["buttonSize"])
		br["button" .. Name]:SetPoint(
			"LEFT",
			x * (br.data.settings["buttonSize"]) + (x * 2),
			y * (br.data.settings["buttonSize"]) + (y * 2)
		)
		br["button" .. Name]:RegisterForClicks("AnyUp")
		if
			br[Name .. "Modes"][br.data.settings[br.selectedSpec].toggles[Name]].icon ~= nil and
				type(br[Name .. "Modes"][br.data.settings[br.selectedSpec].toggles[Name]].icon) == "number"
		 then
			Icon = select(3, _G.GetSpellInfo(br[Name .. "Modes"][br.data.settings[br.selectedSpec].toggles[Name]].icon))
		else
			Icon = br[Name .. "Modes"][br.data.settings[br.selectedSpec].toggles[Name]].icon
		end
		br["button" .. Name]:SetNormalTexture(Icon or br.emptyIcon)
		--CreateBorder(br["button"..Name], 8, 0.6, 0.6, 0.6)
		br["text" .. Name] = br["button" .. Name]:CreateFontString(nil, "OVERLAY")
		br["text" .. Name]:SetFont(br.data.settings.font, br.data.settings.fontsize, "THICKOUTLINE")
		br["text" .. Name]:SetJustifyH("CENTER")
		br["text" .. Name]:SetTextHeight(br.data.settings["buttonSize"] / 3)
		br["text" .. Name]:SetPoint("CENTER", 3, -(br.data.settings["buttonSize"] / 8))
		br["text" .. Name]:SetTextColor(1, 1, 1, 1)
		br["frame" .. Name] = _G.CreateFrame("Frame", nil, br["button" .. Name])
		br["frame" .. Name]:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br["frame" .. Name]:SetHeight(br.data.settings["buttonSize"] * 1.67)
		br["frame" .. Name]:SetPoint("CENTER")
		br["frame" .. Name].texture = br["frame" .. Name]:CreateTexture(br["button" .. Name], "OVERLAY")
		br["frame" .. Name].texture:SetAllPoints()
		br["frame" .. Name].texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br["frame" .. Name].texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
		br["frame" .. Name].texture:SetAlpha(100)
		br["frame" .. Name].texture:SetTexture(br.genericIconOn)
		if br[Name .. "Modes"] == nil then
			br._G.print("No table found for " .. Name)
			br[Name .. "Modes"] = tostring(Name)
		else
			br[Name .. "Modes"] = br[Name .. "Modes"]
		end
		local modeValue
		if br.data.settings[br.selectedSpec].toggles[tostring(Name)] == nil then
			br.data.settings[br.selectedSpec].toggles[tostring(Name)] = 1
			modeValue = 1
		else
			modeValue = br.data.settings[br.selectedSpec].toggles[tostring(Name)]
		end
		br["button" .. Name]:SetScript(
			"OnClick",
			function(_, button)
				if button == "RightButton" then
					br.ToggleMinus(Name)
				else
					br.ToggleValue(Name)
				end
			end
		)
		br["button" .. Name]:SetScript(
			"OnMouseWheel",
			function(_, delta)
				local Go = false
				if delta < 0 and br.data.settings[br.selectedSpec].toggles[tostring(Name)] > 1 then
					Go = true
				elseif delta > 0 and br.data.settings[br.selectedSpec].toggles[tostring(Name)] < #br[Name .. "Modes"] then
					Go = true
				end
				if Go == true then
					br.data.settings[br.selectedSpec].toggles[tostring(Name)] =
						br.data.settings[br.selectedSpec].toggles[tostring(Name)] + delta
				end
			end
		)
		br["button" .. Name]:SetScript(
			"OnEnter",
			function()
				_G.GameTooltip:SetOwner(br["button" .. Name], _G.UIParent, 0, 0)
				_G.GameTooltip:SetText(
					br[Name .. "Modes"][br.data.settings[br.selectedSpec].toggles[Name]].tip,
					225 / 255,
					225 / 255,
					225 / 255,
					nil,
					true
				)
				_G.GameTooltip:Show()
			end
		)
		br["button" .. Name]:SetScript(
			"OnLeave",
			function()
				_G.GameTooltip:Hide()
			end
		)
		br["text" .. Name]:SetText(br[Name .. "Modes"][modeValue].mode)
		if br[Name .. "Modes"][modeValue].highlight == 0 then
			br["frame" .. Name].texture:SetTexture(br.genericIconOff)
		else
			br["frame" .. Name].texture:SetTexture(br.genericIconOn)
		end
		if br.mainButton ~= nil then
			if br.data.settings[br.selectedSpec].toggles["Main"] == 1 and not br._G.UnitAffectingCombat("player") then
				br.mainButton:Show()
			elseif not br._G.UnitAffectingCombat("player") then
				br.mainButton:Hide()
			elseif br._G.UnitAffectingCombat("player") then
				br._G.print("Combat Lockdown detected. Unable to modify button bar. Please try again when out of combat.")
			end
		end
		br.SlashCommandHelp(
			"br toggle " .. Name .. " 1-" .. #br[Name .. "Modes"],
			"Toggles " .. Name .. " Modes, Optional: specify number"
		)
	end
end

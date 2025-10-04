local _, br = ...
br.ui.toggles = br.ui.toggles or {}

local function StripModes(name)
  return name:gsub("Modes$", "")
end

local function Trim(s)
	return s:match("^%s*(.-)%s*$")
end

local function FindToggle(toggleValue)
	local toggles = br.data.settings[br.loader.selectedSpec].toggles
	for k, _ in pairs(toggles) do
		if string.upper(toggleValue) == string.upper(k) then
			return k
		end
	end
	return nil
end

function br.ui:createToggle(table, name, col, row)
	if type(name) ~= "string" then
		br._G.print("Invaild type " .. type(name) .. " detected for table " .. name .. ".  Please let devs know!")
	else
		br.ui.toggles[name] = table
		br.ui:CreateButton(name, col, row)
		-- br.ui:RefreshButton(name)
	end
end

function br.ui:RefreshButton(name)
	local index = br.ui.toggles[name] and br.ui.toggles[name].value or 1
	br.ui:changeButton(name, index)
end

-- when we find a match, we reset tooltip
function br.ui:ResetTip(toggleValue, thisValue)
	br._G.GameTooltip:SetOwner(br.ui.toggles["button" .. StripModes(toggleValue)], br.ui.toggles.mainButton, 0, 0)
	br._G.GameTooltip:SetText(br.ui.toggles[toggleValue][thisValue].tip, 225 / 255, 225 / 255, 225 / 255, nil, true)
	br._G.GameTooltip:Show()
end

function br.ui:GarbageButtons()
	if br.ui.toggles.buttonsTable and not br._G.UnitAffectingCombat("player") then
		for i = 1, #br.ui.toggles.buttonsTable do
			local Name = br.ui.toggles.buttonsTable[i].name
			if br.ui.toggles["button" .. Name] then br.ui.toggles["button" .. Name]:Hide() end
			if br.ui.toggles["text" .. Name] then br.ui.toggles["text" .. Name]:Hide() end
			if br.ui.toggles["frame" .. Name] then br.ui.toggles["frame" .. Name].texture:Hide() end
			br.ui.toggles[Name] = nil
		end
	end
end

function br.ui:ToggleToValue(toggleValue, index)
	if br.ui.toggles[toggleValue] == nil then
		toggleValue = FindToggle(toggleValue)
	end
	index = tonumber(index)
	local modesCount = #br.ui.toggles[toggleValue]
	if index > modesCount then
		br._G.print(
			"Invalid Toggle Index for |cffFFDD11" ..
			toggleValue ..
			": |cFFFF0000 Index ( |r" .. index .. "|cFFFF0000) exceeds Max ( |r" .. modesCount .. "|cFFFF0000)|r."
		)
	else
		br.ui:specialToggleCodes(toggleValue, index)
		if not br.data.settings[br.loader.selectedSpec].toggles then
			br.data.settings[br.loader.selectedSpec].toggles = {}
		end
		br.data.settings[br.loader.selectedSpec].toggles[tostring(toggleValue)] = index
		br.ui:changeButton(toggleValue, index)
		-- We reset the tip
		br.ui:ResetTip(toggleValue, index)
	end
end

function br.ui:ToggleValue(toggleValue)
	local toggles = br.data.settings[br.loader.selectedSpec].toggles
	if toggles[toggleValue] == nil then
		toggleValue = FindToggle(toggleValue)
	end
	if toggles[toggleValue] == nil then
		br._G.print("No toggle mode found for " .. toggleValue .. ". Please inform devs of this error!")
		return
	end
	-- prevent nil fails
	local toggleOldValue
	if toggles then
		toggleOldValue = toggles[tostring(toggleValue)] or 1
	end
	local modesCount = #br.ui.toggles[toggleValue]
	if toggleOldValue == nil then
		if not toggles then
			toggles = {}
		end
		toggles[tostring(toggleValue)] = 1
		toggleOldValue = toggles[tostring(toggleValue)]
	end
	-- Scan Table and find which mode = our i
	for i = 1, modesCount do
		if toggleOldValue == i then
			-- see if we can go higher in modes is #modes > i
			if modesCount > i then
				-- calculate newValue
				local newValue = i + 1
				br.ui:specialToggleCodes(toggleValue, newValue)
				-- We set the value in DB
				toggles[tostring(toggleValue)] = newValue
				br.ui:changeButton(toggleValue, newValue)
				-- We reset the tip
				br.ui:ResetTip(toggleValue, newValue)
				break
			else
				br.ui:specialToggleCodes(toggleValue, 1)
				-- if cannot go higher we define mode to 1.
				toggles[tostring(toggleValue)] = 1
				br.ui:changeButton(toggleValue, 1)
				-- We reset the tip
				br.ui:ResetTip(toggleValue, 1)
				break
			end
		end
	end
end

function br.ui:ToggleMinus(toggleValue)
	local toggles = br.data.settings[br.loader.selectedSpec].toggles
	if not toggles[tostring(toggleValue)] then
		toggleValue = FindToggle(toggleValue)
	end
	if not toggles[tostring(toggleValue)] then
		br._G.print("No toggle mode found for " .. toggleValue .. ". Please inform devs of this error!")
		return
	end
	-- prevent nil fails
	if not toggles then
		toggles = {}
	end
	if toggles[tostring(toggleValue)] == nil then
		toggles[tostring(toggleValue)] = 1
	end
	local modesCount = #br.ui.toggles[tostring(toggleValue)]
	-- Scan Table and find which mode = our i
	for i = 1, modesCount do
		local thisValue = toggles[tostring(toggleValue)] or 1
		if thisValue == i then
			-- see if we can go lower in modes
			local newValue = i - 1
			if i > 1 then
				-- calculate newValue
				br.ui:specialToggleCodes(toggleValue, newValue)
				-- We set the value in DB
				toggles[tostring(toggleValue)] = newValue
				-- change the button
				br.ui:changeButton(toggleValue, newValue)
				-- We reset the tip
				br.ui:ResetTip(toggleValue, newValue)
				break
			else
				-- if cannot go lower we define to last mode
				toggles[tostring(toggleValue)] = modesCount
				br.ui:specialToggleCodes(toggleValue, modesCount)
				br.ui:changeButton(toggleValue, modesCount)
				-- We reset the tip
				br.ui:ResetTip(toggleValue, modesCount)
				break
			end
		end
	end
end

function br.ui:specialToggleCodes(toggleValue, newValue)
	if toggleValue == "Interrupts" then
		local InterruptsModes = br.InterruptsModes
		if newValue == 1 and InterruptsModes[1].mode == "None" then
			-- no interupts mode
			if br.data.settings[br.loader.selectedSpec]["Interrupts HandlerCheck"] ~= 0 then
				br["optionsInterrupts HandlerCheck"]:Click()
			end
		elseif newValue == 2 and InterruptsModes[2].mode == "Raid" then
			-- on/off switch
			if br.data.settings[br.loader.selectedSpec]["Interrupts HandlerCheck"] ~= 1 then
				br["optionsInterrupts HandlerCheck"]:Click()
			end
			-- only known switch
			if br.data.settings[br.loader.selectedSpec]["Only Known UnitsCheck"] ~= 1 then
				br["optionsOnly Known UnitsCheck"]:Click()
			end
		elseif newValue == 3 and InterruptsModes[3].mode == "All" then
			-- interrupt all mode
			-- on/off switch
			if br.data.settings[br.loader.selectedSpec]["Interrupts HandlerCheck"] ~= 1 then
				br["optionsInterrupts HandlerCheck"]:Click()
			end
			-- only known switch
			if br.data.settings[br.loader.selectedSpec]["Only Known UnitsCheck"] ~= 0 then
				br["optionsOnly Known UnitsCheck"]:Click()
			end
		end
	end
end

function br.ui:changeButtonValue(toggleValue, newValue)
	if br.ui.toggles[toggleValue] == nil then
		toggleValue = FindToggle(toggleValue)
	end
	if br.ui.toggles[toggleValue] == nil then
		br._G.print("No toggle mode found for " .. toggleValue .. ". Please inform devs of this error!")
		return
	end
	br.data.settings[br.loader.selectedSpec].toggles[tostring(toggleValue)] = newValue
end

-- set to desired button value
function br.ui:changeButton(toggleValue, newValue)
	local toggleValue = Trim(toggleValue)
	if newValue == 0 then newValue = 1 end
	local Icon
	-- define text
	br.ui.toggles["text" .. StripModes(toggleValue)]:SetText(br.ui.toggles[toggleValue][newValue].mode)
	-- define icon
	if type(br.ui.toggles[toggleValue][newValue].icon) == "number" then
		Icon = select(3, br._G.GetSpellInfo(br.ui.toggles[toggleValue][newValue].icon))
	else
		Icon = br.ui.toggles[toggleValue][newValue].icon
	end
	br.ui.toggles["button" .. StripModes(toggleValue)]:SetNormalTexture(Icon or br.ui.toggles.emptyIcon)
	-- define highlight
	if br.ui.toggles[toggleValue][newValue].highlight == 0 then
		br.ui.toggles["frame" .. StripModes(toggleValue)].texture:SetTexture(br.ui.toggles.genericIconOff)
	else
		br.ui.toggles["frame" .. StripModes(toggleValue)].texture:SetTexture(br.ui.toggles.genericIconOn)
	end
	-- We tell the user we changed mode
	br.ui.chatOverlay:Show("\124cFF3BB0FF" .. br.ui.toggles[toggleValue][newValue].overlay)
	-- We reset the tip
	br.ui:ResetTip(toggleValue, newValue)
end

function br.ui:UpdateButton(Name)
	Name = tostring(Name) --string.upper(Name)
	br.ui:ToggleValue(Name)
end

function br.ui:buttonsResize()
	for i = 1, #br.ui.toggles.buttonsTable do
		local Name = br.ui.toggles.buttonsTable[i].name
		local x = br.ui.toggles.buttonsTable[i].bx
		local y = br.ui.toggles.buttonsTable[i].by
		br.ui.toggles["button" .. Name]:SetWidth(br.data.settings["buttonSize"])
		br.ui.toggles["button" .. Name]:SetHeight(br.data.settings["buttonSize"])
		br.ui.toggles["button" .. Name]:SetPoint("LEFT", x * (br.data.settings["buttonSize"]), y * (br.data.settings["buttonSize"]))
		br.ui.toggles["text" .. Name]:SetTextHeight(br.data.settings["buttonSize"] / 3)
		br.ui.toggles["text" .. Name]:SetPoint("CENTER", 0, -(br.data.settings["buttonSize"] / 4))
		br.ui.toggles["frame" .. Name]:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br.ui.toggles["frame" .. Name]:SetHeight(br.data.settings["buttonSize"] * 1.67)
		br.ui.toggles["frame" .. Name].texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br.ui.toggles["frame" .. Name].texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
	end
end

-- /run CreateButton("AoE",2,2)
function br.ui:CreateButton(Name, x, y)
	if type(Name) ~= "string" then
		br._G.print("Invaild type " .. type(Name) .. " detected for table " .. Name .. ".  Please let devs know!")
		return
	end
	if br.data.settings[br.loader.selectedSpec] ~= nil then
		local Icon
		-- local Name = string.upper(Name)
		-- todo: extend to use spec + profile specific variable; ATM it shares between profile AND spec, -> global for char
		local toggleIndex = br.data.settings[br.loader.selectedSpec].toggles[Name]
		if toggleIndex == nil or toggleIndex > #br.ui.toggles[Name] or toggleIndex == 0 then
			toggleIndex = 1
		end
		if br.ui.toggles.buttonsTable then
			br._G.tinsert(br.ui.toggles.buttonsTable, { name = Name, bx = x, by = y })
		end
		br.ui.toggles["button" .. Name] = br._G.CreateFrame("Button", "MyButtonBR", br.ui.toggles.mainButton, "SecureHandlerClickTemplate")
		br.ui.toggles["button" .. Name]:SetWidth(br.data.settings["buttonSize"])
		br.ui.toggles["button" .. Name]:SetHeight(br.data.settings["buttonSize"])
		br.ui.toggles["button" .. Name]:SetPoint(
			"LEFT",
			x * (br.data.settings["buttonSize"]) + (x * 2),
			y * (br.data.settings["buttonSize"]) + (y * 2)
		)
		br.ui.toggles["button" .. Name]:RegisterForClicks("AnyUp")
		local toggleIcon = br.ui.toggles[Name][toggleIndex].icon
		if toggleIcon ~= nil and type(toggleIcon) == "number" then
			Icon = toggleIcon
		else
			Icon = br.ui.toggles.emptyIcon
		end
		local _, _, spellIcon = br._G.GetSpellInfo(Icon)
		Icon = spellIcon or br.ui.toggles.emptyIcon
		br.ui.toggles["button" .. Name]:SetNormalTexture(Icon)
		--CreateBorder(br["button"..Name], 8, 0.6, 0.6, 0.6)
		br.ui.toggles["text" .. Name] = br.ui.toggles["button" .. Name]:CreateFontString(nil, "OVERLAY")
		br.ui.toggles["text" .. Name]:SetFont(br.data.settings.font, br.data.settings.fontsize, "THICKOUTLINE")
		br.ui.toggles["text" .. Name]:SetJustifyH("CENTER")
		br.ui.toggles["text" .. Name]:SetTextHeight(br.data.settings["buttonSize"] / 3)
		br.ui.toggles["text" .. Name]:SetPoint("CENTER", 3, -(br.data.settings["buttonSize"] / 8))
		br.ui.toggles["text" .. Name]:SetTextColor(1, 1, 1, 1)
		br.ui.toggles["frame" .. Name] = br._G.CreateFrame("Frame", nil, br.ui.toggles["button" .. Name])
		br.ui.toggles["frame" .. Name]:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br.ui.toggles["frame" .. Name]:SetHeight(br.data.settings["buttonSize"] * 1.67)
		br.ui.toggles["frame" .. Name]:SetPoint("CENTER")
		br.ui.toggles["frame" .. Name].texture = br.ui.toggles["frame" .. Name]:CreateTexture(nil, "OVERLAY")
		br.ui.toggles["frame" .. Name].texture:SetAllPoints()
		br.ui.toggles["frame" .. Name].texture:SetWidth(br.data.settings["buttonSize"] * 1.67)
		br.ui.toggles["frame" .. Name].texture:SetHeight(br.data.settings["buttonSize"] * 1.67)
		br.ui.toggles["frame" .. Name].texture:SetAlpha(1)
		br.ui.toggles["frame" .. Name].texture:SetTexture(br.ui.toggles.genericIconOn)
		if br.ui.toggles[Name] == nil then
			br._G.print("No table found for " .. Name)
			br.ui.toggles[Name] = tostring(Name)
		else
			br.ui.toggles[Name] = br.ui.toggles[Name] or ""
		end
		local modeValue
		if toggleIndex == nil then
			toggleIndex = 1
			modeValue = 1
		else
			modeValue = toggleIndex
		end
		br.data.settings[br.loader.selectedSpec].toggles[Name] = modeValue
		br.ui.toggles["button" .. Name]:SetScript(
			"OnClick",
			function(_, button)
				if button == "RightButton" then
					br.ui:ToggleMinus(Name)
				else
					br.ui:ToggleValue(Name)
				end
			end
		)
		br.ui.toggles["button" .. Name]:SetScript(
			"OnMouseWheel",
			function(_, delta)
				local Go = false
				if delta < 0 and toggleIndex > 1 then
					Go = true
				elseif delta > 0 and toggleIndex < #br.ui.toggles[Name] then
					Go = true
				end
				if Go == true then
					toggleIndex = toggleIndex + delta
				end
			end
		)
		br.ui.toggles["button" .. Name]:SetScript(
			"OnEnter",
			function()
				br._G.GameTooltip:SetOwner(br.ui.toggles["button" .. Name], br._G.UIParent, 0, 0)
				br._G.GameTooltip:SetText(
					br.ui.toggles[Name][toggleIndex].tip,
					225 / 255,
					225 / 255,
					225 / 255,
					nil,
					true
				)
				br._G.GameTooltip:Show()
			end
		)
		br.ui.toggles["button" .. Name]:SetScript(
			"OnLeave",
			function()
				br._G.GameTooltip:Hide()
			end
		)
		br.ui.toggles["text" .. Name]:SetText(br.ui.toggles[Name][modeValue].mode)
		if br.ui.toggles[Name][modeValue].highlight == 0 then
			br.ui.toggles["frame" .. Name].texture:SetTexture(br.ui.toggles.genericIconOff)
		else
			br.ui.toggles["frame" .. Name].texture:SetTexture(br.ui.toggles.genericIconOn)
		end
		if br.ui.toggles.mainButton ~= nil then
			if br.data.settings[br.loader.selectedSpec].toggles["Main"] == 1 and not br._G.UnitAffectingCombat("player") then
				br.ui.toggles.mainButton:Show()
			elseif not br._G.UnitAffectingCombat("player") then
				br.ui.toggles.mainButton:Hide()
			elseif br._G.UnitAffectingCombat("player") then
				br._G.print(
					"Combat Lockdown detected. Unable to modify button bar. Please try again when out of combat.")
			end
		end
		br.slashCommands:SlashCommandHelp(
			"br toggle " .. Name .. " 1-" .. #br.ui.toggles[Name],
			"Toggles " .. Name .. ", Optional: specify number to toggle to or 2 numbers to toggle between"
		)
	end
end

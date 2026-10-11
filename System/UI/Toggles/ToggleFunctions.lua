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
	local iconValue = br.ui.toggles[toggleValue][newValue].icon
	-- Handle table-based spell ranks (Classic WoW)
	if type(iconValue) == "table" then
		-- Get highest known rank for icon display
		if br.functions and br.functions.spell and br.functions.spell.getHighestKnownRank then
			iconValue = br.functions.spell:getHighestKnownRank(iconValue) or iconValue[1]
		else
			iconValue = iconValue[1] -- Fallback to first rank
		end
	end
	if type(iconValue) == "number" then
		-- Try spell first, then item if spell doesn't exist
		local spellName, _, spellIcon = br.api.wow.GetSpellInfo(iconValue)
		if spellName then
			Icon = spellIcon
		else
			-- Try as item ID
			Icon = br._G.C_Item.GetItemIconByID(iconValue)
		end
	else
		Icon = iconValue
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
		if br.data.settings[br.loader.selectedSpec].toggles == nil then
			br.data.settings[br.loader.selectedSpec].toggles = {}
		end
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
		-- Handle table-based spell ranks (Classic WoW)
		if type(toggleIcon) == "table" then
			-- Get highest known rank for icon display
			if br.functions and br.functions.spell and br.functions.spell.getHighestKnownRank then
				toggleIcon = br.functions.spell:getHighestKnownRank(toggleIcon) or toggleIcon[1]
			else
				toggleIcon = toggleIcon[1] -- Fallback to first rank
			end
		end
		if toggleIcon ~= nil and type(toggleIcon) == "number" then
			-- Try spell first, then item if spell doesn't exist
			local spellName, _, spellIcon = br.api.wow.GetSpellInfo(toggleIcon)
			if spellName then
				Icon = spellIcon
			else
				-- Try as item ID
				Icon = br._G.C_Item.GetItemIconByID(toggleIcon)
			end
		else
			Icon = toggleIcon or br.ui.toggles.emptyIcon
		end
		Icon = Icon or br.ui.toggles.emptyIcon
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

-- Toggles made with br.ui:toggle for the current rotation (for the Toggle Keys section)
local declaredToggles = {}

---@class br.ui.ToggleMode
---@field name string Shown on the button
---@field icon? string|number|table A spell from the class spell list (e.g. "swipe"), or a spell/item ID
---@field overlay? string Shown in the middle of the screen when picked (name)
---@field tip? string Tooltip
---@field highlight? boolean Lights up the button's border (only the first mode)
local MODE_FIELDS = { name = "string", icon = "string/number/table", overlay = "string", tip = "string",
    highlight = "boolean" }

---@class br.ui.ToggleOptions
---@field modes br.ui.ToggleMode[] The modes in click order; the first is the default
---@field key? string Keybind that cycles it, from br.ui.dropOptions.Toggle (None)
---@field row? number Button row (0)
---@field col? number Button column (the next free one in its row)
local TOGGLE_FIELDS = { modes = "table", key = "string", row = "number", col = "number" }

--- Adds a button to the toggle bar. Read it in the rotation with ui.mode.<name>, e.g.
--- ui.mode.rotation == 1. Its keybind goes in the Toggle Keys section BR adds to the options.
---@param name string The toggle's name
---@param options br.ui.ToggleOptions
function br.ui:toggle(name, options)
    local elementOptions = br.ui.elementOptions
    if type(name) ~= "string" or name == "" then
        return elementOptions.problem("toggle() needs a name first, e.g. br.ui:toggle(\"Rotation\", { modes = { ... } })")
    end
    local what = "toggle \"" .. name .. "\""
    options = elementOptions.check(what, options, TOGGLE_FIELDS, { "modes" })
    if options == nil then return end
    local key = options.key
    if key ~= nil and not elementOptions.indexOf(br.ui.dropOptions.Toggle, key) then
        elementOptions.problem(what .. ": key \"" .. key .. "\" is not one of " .. table.concat(br.ui.dropOptions.Toggle, ", "))
        key = nil
    end
    local modes = {}
    for i, given in ipairs(options.modes) do
        local mode = elementOptions.check(what .. " mode " .. i, given, MODE_FIELDS, { "name" })
        if mode == nil then return end
        local icon = mode.icon
        if type(icon) == "string" then
            icon = br.player and br.player.spells and br.player.spells[icon]
            if icon == nil then
                elementOptions.notice(what .. " mode \"" .. mode.name .. "\": no spell named \"" .. mode.icon .. "\" for its icon")
            end
        end
        local highlight = i == 1
        if mode.highlight ~= nil then highlight = mode.highlight end
        modes[i] = { mode = mode.name, value = i, overlay = mode.overlay or mode.name, tip = mode.tip or "",
            highlight = highlight and 1 or 0, icon = icon }
    end
    if #modes == 0 then return elementOptions.problem(what .. " needs at least one mode") end
    local row = options.row or 0
    local col = options.col
    if col == nil then
        col = 1
        for _, other in ipairs(declaredToggles) do
            if other.row == row and other.col >= col then col = other.col + 1 end
        end
    end
    declaredToggles[#declaredToggles + 1] = { name = name, key = key, row = row, col = col }
    br.ui:createToggle(modes, name, col, row)
end

--- Forgets the toggles made with br.ui:toggle (a rotation's toggles are about to be created).
function br.ui:forgetToggles()
    declaredToggles = {}
end

--- True when toggles made with br.ui:toggle need a Toggle Keys section.
function br.ui:hasToggleKeys()
    return #declaredToggles > 0
end

--- Adds the "Toggle Keys" section: a keybind dropdown for each toggle made with br.ui:toggle, read
--- by misc:UpdateToggle as "<name> Mode".
function br.ui:toggleKeys()
    if #declaredToggles == 0 then return end
    local keys = br.ui.dropOptions.Toggle
    local section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
    for _, toggle in ipairs(declaredToggles) do
        br.functions.misc:registerKeyOption(toggle.name .. " Mode")
        br.ui:createDropdownWithout(section, toggle.name .. " Mode", keys, br.ui.elementOptions.indexOf(keys, toggle.key or "None"),
            br.ui.elementOptions.white("Key that cycles the " .. toggle.name .. " toggle"))
    end
    br.ui:checkSectionState(section)
end

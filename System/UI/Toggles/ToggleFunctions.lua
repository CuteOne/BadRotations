local _, br = ...
br.ui.toggles = br.ui.toggles or {}
local toggles = br.ui.toggles
-- The modes of each toggle the loaded profile made, by toggle name
toggles.modes = toggles.modes or {}
-- The toggle bar's buttons by toggle name ({ button, text, glow, col, row }). A profile reload hides
-- them and a toggle made again with the same name gets its button back.
toggles.bar = toggles.bar or {}

local function savedToggles()
	local specSettings = br.data.settings[br.loader.selectedSpec]
	specSettings.toggles = specSettings.toggles or {}
	return specSettings.toggles
end

-- The name a toggle was made with, matched without case ("rotation" finds "Rotation")
local function findToggle(name)
	if type(name) ~= "string" then return nil end
	if toggles.modes[name] then return name end
	local wanted = name:upper()
	for made in pairs(toggles.modes) do
		if made:upper() == wanted then return made end
	end
end

-- The saved mode of a toggle, or 1 when nothing (or a mode it no longer has) is saved
local function currentIndex(name)
	local index = tonumber(savedToggles()[name]) or 1
	if index < 1 or index > #toggles.modes[name] then index = 1 end
	return index
end

-- A mode's icon: a spell (the highest known rank of a ranked list) or item ID, or a texture
local function modeIcon(mode)
	local icon = mode.icon
	if type(icon) == "table" then
		icon = br.functions.spell:getHighestKnownRank(icon) or icon[1]
	end
	if type(icon) == "number" then
		local info = br.game.C_Spell.GetSpellInfo(icon)
		icon = info and info.iconID or br.game.C_Item.GetItemIconByID(icon)
	end
	return icon or toggles.emptyIcon
end

local function showTip(name)
	local tooltip = br.game.GameTooltip
	tooltip:SetOwner(toggles.bar[name].button, "ANCHOR_RIGHT")
	tooltip:SetText(toggles.modes[name][currentIndex(name)].tip, 225 / 255, 225 / 255, 225 / 255, nil, true)
	tooltip:Show()
end

-- Shows a toggle's saved mode on its button
local function drawToggle(name)
	local entry, mode = toggles.bar[name], toggles.modes[name][currentIndex(name)]
	entry.text:SetText(mode.mode)
	entry.button:SetNormalTexture(modeIcon(mode))
	entry.glow.texture:SetTexture(mode.highlight == 0 and toggles.genericIconOff or toggles.genericIconOn)
	-- Only while the mouse is on this button: a keybind changes the mode without a hover
	if br.game.GameTooltip:IsOwned(entry.button) then showTip(name) end
end

-- Sizes and places a toggle button for the current button size
local function layoutButton(entry)
	local size = br.data.settings.buttonSize
	entry.button:SetSize(size, size)
	entry.button:ClearAllPoints()
	entry.button:SetPoint("LEFT", entry.col * (size + 2), entry.row * (size + 2))
	entry.text:SetTextHeight(size / 3)
	entry.text:ClearAllPoints()
	entry.text:SetPoint("CENTER", 3, -(size / 8))
	entry.glow:SetSize(size * 1.67, size * 1.67)
end

local function newButton(name)
	local button = br.game.CreateFrame("Button", nil, toggles.mainButton)
	button:RegisterForClicks("AnyUp")
	local text = button:CreateFontString(nil, "OVERLAY")
	text:SetFont(br.data.settings.font, br.data.settings.fontsize, "THICKOUTLINE")
	text:SetJustifyH("CENTER")
	text:SetTextColor(1, 1, 1, 1)
	local glow = br.game.CreateFrame("Frame", nil, button)
	glow:SetPoint("CENTER")
	glow.texture = glow:CreateTexture(nil, "OVERLAY")
	glow.texture:SetAllPoints()
	glow.texture:SetAlpha(1)
	button:SetScript("OnClick", function(_, mouseButton)
		if mouseButton == "RightButton" then br.ui:ToggleMinus(name) else br.ui:ToggleValue(name) end
	end)
	button:SetScript("OnEnter", function() showTip(name) end)
	button:SetScript("OnLeave", function() br.game.GameTooltip:Hide() end)
	return { button = button, text = text, glow = glow }
end

-- Saves and shows a toggle's new mode, and names it in the chat overlay
local function setToggle(name, index)
	savedToggles()[name] = index
	drawToggle(name)
	br.ui.chatOverlay:Show("\124cFF3BB0FF" .. toggles.modes[name][index].overlay)
	br.log.session:toggleChanged(name, index .. " (" .. br.log.plain(toggles.modes[name][index].overlay) .. ")")
end

--- Adds a toggle (its modes) and its button at column col, row row of the toggle bar.
function br.ui:createToggle(modes, name, col, row)
	if type(name) ~= "string" then
		return br.log:error("Invalid toggle name " .. tostring(name) .. ". Please let devs know!")
	end
	toggles.modes[name] = modes
	br.ui:CreateButton(name, col, row)
end

--- Shows the button of a toggle made with createToggle, making it the first time.
function br.ui:CreateButton(name, col, row)
	if br.data.settings[br.loader.selectedSpec] == nil or toggles.modes[name] == nil then return end
	local entry = toggles.bar[name]
	if entry == nil then
		entry = newButton(name)
		toggles.bar[name] = entry
	end
	entry.col, entry.row = col, row
	layoutButton(entry)
	entry.button:Show()
	local saved = savedToggles()
	saved[name] = currentIndex(name)
	drawToggle(name)
	if toggles.mainButton ~= nil then
		if saved["Main"] == 1 then toggles.mainButton:Show() else toggles.mainButton:Hide() end
	end
	br.slashCommands:SlashCommandHelp(
		"br toggle " .. name .. " 1-" .. #toggles.modes[name],
		"Toggles " .. name .. ", Optional: specify number to toggle to or 2 numbers to toggle between"
	)
end

--- Hides the toggle bar's buttons and forgets the toggles (a profile's toggles are about to be made).
function br.ui:GarbageButtons()
	for name, entry in pairs(toggles.bar) do
		entry.button:Hide()
		toggles.modes[name] = nil
	end
end

--- Resizes and places every toggle button for the current button size.
function br.ui:buttonsResize()
	for _, entry in pairs(toggles.bar) do layoutButton(entry) end
end

--- Sets a toggle (name without case) to mode index.
function br.ui:ToggleToValue(name, index)
	local found = findToggle(name)
	if found == nil then
		return br.log:warning("No toggle named " .. br.log.highlight(tostring(name)) .. ".")
	end
	local modesCount = #toggles.modes[found]
	index = tonumber(index)
	if index == nil or index < 1 or index > modesCount then
		return br.log:error("Invalid toggle index for " .. br.log.highlight(found) .. ": " .. tostring(index)
			.. " (must be 1 to " .. modesCount .. ")")
	end
	if index ~= currentIndex(found) then setToggle(found, index) end
end

--- Moves a toggle (name without case) to its next mode, from the last back to the first.
function br.ui:ToggleValue(name)
	local found = findToggle(name)
	if found == nil then
		return br.log:warning("No toggle named " .. br.log.highlight(tostring(name)) .. ".")
	end
	setToggle(found, currentIndex(found) % #toggles.modes[found] + 1)
end

--- Moves a toggle (name without case) to its previous mode, from the first to the last.
function br.ui:ToggleMinus(name)
	local found = findToggle(name)
	if found == nil then
		return br.log:warning("No toggle named " .. br.log.highlight(tostring(name)) .. ".")
	end
	setToggle(found, (currentIndex(found) - 2) % #toggles.modes[found] + 1)
end

-- Toggles made with br.ui:toggle for the current rotation (for the Toggle Keys section)
local declaredToggles = {}

-- A mode's icon given by name: a spell or talent from the class spell list, or an item from the item
-- list (its use spell, whose icon is the item's)
local function iconByName(name)
    local rotation = br.rotation
    if rotation == nil then return nil end
    local spells = rotation.spells
    local spellID = spells[name] or (spells.talents and spells.talents[name])
    if spellID ~= nil then return spellID end
    return rotation.items[name] and br.functions.item:getSpell(rotation.items[name])
end

---@class br.ui.ToggleMode
---@field name string Shown on the button
---@field icon? string|number|table A spell or talent from the class spell list or an item from the item list
---  (e.g. "swipe"), or a spell/item ID
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
            icon = iconByName(icon)
            if icon == nil then
                elementOptions.notice(what .. " mode \"" .. mode.name .. "\": no spell, talent or item named \"" .. mode.icon .. "\" for its icon")
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

local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...

local function spinnerSettings(min, max, step)
    return {
        height = 12,
        width = 29,
        mouse = true,
        mouseWheel = true,
        buttons = false,
        buttonsWidth = 0,
        bar = true,
        min = min or 0,
        max = max or 100,
        step = step or 5,
        shiftStep = 1
    }
end

-- A spinner at offset x on row Y of parent, saving its number as data[key] (default number)
local function addSpinner(parent, page, data, key, number, min, max, step, x, Y, tooltip)
    local elementOptions = br.ui.elementOptions
    local spinner = DiesalGUI:Create("Spinner")
    parent:AddChild(spinner)
    spinner:SetParent(parent.content)
    spinner:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", x, Y)
    spinner:SetSettings(spinnerSettings(min, max, step))
    br.functions.misc:registerOption(page, key, number)
    if data[key] == nil then
        data[key] = number
    end
    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    elementOptions.mirror(page, key, data[key])
    spinner:SetNumber(data[key])
    spinner:SetEventListener(
        "OnValueChanged",
        function()
            data[key] = spinner:GetNumber()
        end
    )
    if tooltip then elementOptions.cursorTooltip(spinner, tooltip) end
    spinner:ApplySettings()
    return spinner
end

-- checked (optional): default state of the option's checkbox for new settings
function br.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, hideCheckbox, checked)
    local elementOptions = br.ui.elementOptions
    local activePage, data = elementOptions.pageData(parent)
    local Y = elementOptions.nextRowY(parent)
    local checkBox = br.ui:createCheckbox(parent, text, tooltip, checked)
    if hideCheckbox then br.ui:hideCheckbox(checkBox, data[text .. " Check"]) end
    local spinner = addSpinner(parent, activePage, data, text .. " Status", number, min, max, step, -10, Y,
        tooltipSpin or tooltip)
    return spinner, checkBox
end

-- Spinner Object : {number, min, max, step, tooltip}
-- checked (optional): default state of the option's checkbox for new settings
function br.ui:createDoubleSpinner(parent, text, spinner1, spinner2, hideCheckbox, checked)
    local elementOptions = br.ui.elementOptions
    -- The window page this is on (double spinners used to be saved under it)
    local windowPage = elementOptions.windowPage(parent)
    -- Saved under the section's storage name, like every other option
    local activePage, data = elementOptions.pageData(parent)
    -- Move values saved under the window page's name before this changed
    local profileSettings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
    local oldData = windowPage ~= activePage and profileSettings[windowPage] or nil
    if type(oldData) == "table" then
        for _, key in ipairs({ text .. " 1Status", text .. " 2Status" }) do
            if data[key] == nil and oldData[key] ~= nil then data[key] = oldData[key] end
            oldData[key] = nil
        end
        if next(oldData) == nil then profileSettings[windowPage] = nil end
    end
    local Y = elementOptions.nextRowY(parent)
    local checkBox = br.ui:createCheckbox(parent, text, "Enable auto usage of this spell", checked)
    if hideCheckbox then br.ui:hideCheckbox(checkBox, data[text .. " Check"]) end
    local first = addSpinner(parent, activePage, data, text .. " 1Status", spinner1.number, spinner1.min, spinner1.max,
        spinner1.step, -50, Y, spinner1.tooltip)
    local second = addSpinner(parent, activePage, data, text .. " 2Status", spinner2.number, spinner2.min, spinner2.max,
        spinner2.step, -10, Y, spinner2.tooltip)
    return first, second, checkBox
end

function br.ui:createSpinnerWithout(parent, text, number, min, max, step, tooltip, tooltipSpin)
    return br.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, true)
end

---@class br.ui.SpinnerOptions
---@field value? number Starting value for new settings (min)
---@field min? number Lowest value (0)
---@field max? number Highest value (100)
---@field step? number Change per click (5)
---@field checkbox? boolean false leaves out the checkbox in front of it (true)
---@field checked? boolean The checkbox starts ticked for new settings (false)
---@field tip? string Tooltip
---@field boxTip? string Tooltip for the number box alone (tip)
local SPINNER_FIELDS = { value = "number", min = "number", max = "number", step = "number", checkbox = "boolean",
    checked = "boolean", tip = "string", boxTip = "string" }

--- Adds a number spinner, with a checkbox unless checkbox = false. Read it in the rotation with
--- ui.value(name) (and ui.checked(name) for the checkbox).
---@param section table The section from br.ui:section
---@param name string The option's name
---@param options? br.ui.SpinnerOptions
function br.ui:spinner(section, name, options)
    local elementOptions = br.ui.elementOptions
    if not elementOptions.ready("spinner", section, name) then return end
    options = elementOptions.check("spinner \"" .. name .. "\"", options, SPINNER_FIELDS)
    if options == nil then return end
    local white = elementOptions.white
    local min = options.min or 0
    return br.ui:createSpinner(section, name, options.value or min, min, options.max or 100, options.step or 5,
        white(options.tip), white(options.boxTip), options.checkbox == false, options.checked)
end

---@class br.ui.DoubleSpinnerPart
---@field value? number Starting value for new settings (min)
---@field min? number Lowest value (0)
---@field max? number Highest value (100)
---@field step? number Change per click (5)
---@field tip? string Tooltip for this spinner
local PART_FIELDS = { value = "number", min = "number", max = "number", step = "number", tip = "string" }

---@class br.ui.DoubleSpinnerOptions
---@field first br.ui.DoubleSpinnerPart The left spinner
---@field second br.ui.DoubleSpinnerPart The right spinner
---@field checkbox? boolean false leaves out the checkbox in front of them (true)
---@field checked? boolean The checkbox starts ticked for new settings (false)
local DOUBLE_FIELDS = { first = "table", second = "table", checkbox = "boolean", checked = "boolean" }

--- Adds two number spinners on one line, with a checkbox unless checkbox = false.
---@param section table The section from br.ui:section
---@param name string The option's name
---@param options br.ui.DoubleSpinnerOptions
function br.ui:doubleSpinner(section, name, options)
    local elementOptions = br.ui.elementOptions
    if not elementOptions.ready("doubleSpinner", section, name) then return end
    local what = "doubleSpinner \"" .. name .. "\""
    options = elementOptions.check(what, options, DOUBLE_FIELDS, { "first", "second" })
    if options == nil then return end
    local spinners = {}
    for i, which in ipairs({ "first", "second" }) do
        local part = elementOptions.check(what .. " " .. which, options[which], PART_FIELDS)
        if part == nil then return end
        local min = part.min or 0
        spinners[i] = { number = part.value or min, min = min, max = part.max or 100, step = part.step or 5,
            tooltip = elementOptions.white(part.tip) }
    end
    return br.ui:createDoubleSpinner(section, name, spinners[1], spinners[2], options.checkbox == false, options.checked)
end

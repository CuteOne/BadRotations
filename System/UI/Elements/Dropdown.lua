local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
-- checked (optional): default state of the option's checkbox for new settings
function br.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, hideCheckbox, checked)
    local elementOptions = br.ui.elementOptions
    local activePage, data = elementOptions.pageData(parent)
    local Y = elementOptions.nextRowY(parent)
    local checkBox = br.ui:createCheckbox(parent, text, tooltip, checked)
    if hideCheckbox then br.ui:hideCheckbox(checkBox, data[text .. " Check"]) end

    local newDropdown = DiesalGUI:Create("Dropdown")
    parent:AddChild(newDropdown)
    newDropdown:SetParent(parent.content)
    newDropdown:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, Y)
    newDropdown:SetHeight(12)
    newDropdown:SetList(itemlist)

    local key = text .. " Drop"
    default = default or 1
    br.functions.misc:registerOption(activePage, key, default)
    if data[key] == nil then
        data[key] = default
    end
    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    elementOptions.mirror(activePage, key, data[key])
    newDropdown:SetValue(data[key])

    -- The open list goes on the window (the top frame under UIParent) so the window doesn't clip it
    local main_window = parent.content
    if main_window:GetParent() ~= br._G.UIParent then
        repeat
            main_window = main_window:GetParent()
        until main_window:GetParent() == nil or main_window:GetParent() == br._G.UIParent
    end
    local strata = newDropdown.dropdown:GetFrameStrata()
    newDropdown:SetEventListener("OnClick", function(self)
        if self.dropdown:IsShown() then
            strata = self.dropdown:GetFrameStrata()
            self.dropdown:SetParent(main_window)
            self.dropdown:SetFrameStrata("HIGH")
        else
            self.dropdown:SetParent(self.frame)
            self.dropdown:SetFrameStrata(strata)
        end
    end)
    newDropdown:SetEventListener(
        "OnValueChanged",
        function(this, event, choice)
            data[key] = choice
            if br.functions.misc:isKeyOption(text) then br.functions.misc:checkKeyClashes() end
        end
    )
    if tooltip or tooltipDrop then elementOptions.cursorTooltip(newDropdown, tooltipDrop or tooltip) end
    newDropdown:ApplySettings()
    return newDropdown, checkBox
end

function br.ui:createDropdownWithout(parent, text, itemlist, default, tooltip, tooltipDrop)
    return br.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, true)
end

---@class br.ui.DropdownOptions
---@field choices string[]|string The choices, or the name of a br.ui.dropOptions list (e.g. "AlwaysCdNever")
---@field value? string|number Default choice for new settings, by its text or position (the first)
---@field checkbox? boolean false leaves out the checkbox in front of it (true)
---@field checked? boolean The checkbox starts ticked for new settings (false)
---@field tip? string Tooltip
---@field boxTip? string Tooltip for the dropdown box alone (tip)
local DROPDOWN_FIELDS = { choices = "table/string", value = "string/number", checkbox = "boolean",
    checked = "boolean", tip = "string", boxTip = "string" }

--- Adds a dropdown, with a checkbox unless checkbox = false. Read it in the rotation with
--- ui.value(name), which gives the chosen position (and ui.checked(name) for the checkbox).
---@param section table The section from br.ui:section
---@param name string The option's name
---@param options br.ui.DropdownOptions
function br.ui:dropdown(section, name, options)
    local elementOptions = br.ui.elementOptions
    if not elementOptions.ready("dropdown", section, name) then return end
    local what = "dropdown \"" .. name .. "\""
    options = elementOptions.check(what, options, DROPDOWN_FIELDS, { "choices" })
    if options == nil then return end
    local choices = options.choices
    if type(choices) == "string" then
        choices = br.ui.dropOptions[choices]
        if choices == nil then
            return elementOptions.problem(what .. ": there is no br.ui.dropOptions list named \"" .. options.choices .. "\"")
        end
    end
    if #choices == 0 then return elementOptions.problem(what .. " needs at least one choice") end
    local default = options.value or 1
    if type(default) == "string" then default = elementOptions.indexOf(choices, default) end
    if default == nil or choices[default] == nil then
        local shownValue = type(options.value) == "string" and ("\"" .. options.value .. "\"") or tostring(options.value)
        return elementOptions.problem(what .. ": value " .. shownValue .. " is not one of its choices")
    end
    if options.choices == "Toggle" then br.functions.misc:registerKeyOption(name) end
    local white = elementOptions.white
    local shown = {}
    for i, choice in ipairs(choices) do shown[i] = white(choice) end
    return br.ui:createDropdown(section, name, shown, default, white(options.tip), white(options.boxTip),
        options.checkbox == false, options.checked)
end

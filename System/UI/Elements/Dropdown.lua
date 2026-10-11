local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...
-- checked (optional): default state of the option's checkbox for new settings
function br.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, hideCheckbox, checked)
    local activePage = parent.settings.storageName or parent.settings.sectionName or ""
    if activePage == "" then
        if parent and parent.settings and parent.settings.parentObject and parent.settings.parentObject.pageDD then
            local pdd = parent.settings.parentObject.pageDD
            if pdd.value and pdd.settings and pdd.settings.list and pdd.settings.list[pdd.value] then
                activePage = pdd.settings.list[pdd.value]
            end
        end
    end
    br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][activePage] = br.data.settings[br.loader.selectedSpec]
        [br.loader.selectedProfile][activePage] or {}
    local data = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][activePage]
    -- Ensure the active page is registered in the profile PageList so
    -- option lookups (findOption) can locate values immediately.
    br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"] = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"] or {}
    local pageList = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"]
    local found = false
    for i = 1, #pageList do
        if pageList[i] == activePage then
            found = true
            break
        end
    end
    if not found then
        br._G.tinsert(pageList, activePage)
    end
    -------------------------------
    ----Need to calculate Y Pos----
    -------------------------------
    local Y = -5
    for i = 1, #parent.children do
        if parent.children[i].type ~= "Spinner" and parent.children[i].type ~= "Dropdown" then
            Y = Y - parent.children[i].frame:GetHeight() * 1.2
        end
    end
    Y = DiesalTools.Round(Y)

    -------------------------------
    --------Create CheckBox--------
    -------------------------------
    local checkBox = br.ui:createCheckbox(parent, text, tooltip, checked)
    if hideCheckbox then br.ui:hideCheckbox(checkBox, data[text .. " Check"]) end
    -------------------------------

    -------------------------------
    --------Create Dropdown--------
    -------------------------------
    local newDropdown = DiesalGUI:Create("Dropdown")
    local default = default or 1
    parent:AddChild(newDropdown)

    newDropdown:SetParent(parent.content)
    newDropdown:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, Y)
    newDropdown:SetHeight(12)
    newDropdown:SetList(itemlist)

    --------------
    ---BR Stuff---
    --------------
    local value = text .. " Drop"
    br.functions.misc:registerOption(activePage, value, default)

    -- Read from config or set default
    if data[value] == nil then
        data[value] = default
    end

    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    if br.data.ui == nil then
        br.data.ui = {}
    end
    if br.data.ui[activePage] == nil then br.data.ui[activePage] = {} end
    br.data.ui[activePage][value] = data[value]

    local value = data[value]
    newDropdown:SetValue(value)

    ------------------
    ------Events------
    ------------------
    -- Event: OnClick
    local main_window = parent.content
    if main_window:GetParent() ~= UIParent then
        repeat
            main_window = main_window:GetParent()
        until main_window:GetParent() == nil or main_window:GetParent() == UIParent
    end

    local strata = newDropdown.dropdown:GetFrameStrata()
    newDropdown:SetEventListener("OnClick", function(self, event, ...)
        if self.dropdown:IsShown() then
            strata = self.dropdown:GetFrameStrata()
            self.dropdown:SetParent(main_window)
            self.dropdown:SetFrameStrata("HIGH")
        else
            self.dropdown:SetParent(self.frame)
            self.dropdown:SetFrameStrata(strata)
        end
    end)

    -- Event: OnValueChange
    newDropdown:SetEventListener(
        "OnValueChanged",
        function(this, event, key, value, selection)
            data[text .. " Drop"] = key
        end
    )
    -- Event: Tooltip
    if tooltip or tooltipDrop then
        local tooltip = tooltipDrop or tooltip
        newDropdown:SetEventListener(
            "OnEnter",
            function(this, event)
                br._G.GameTooltip:SetOwner(br._G.Minimap, "ANCHOR_CURSOR", 50, 50)
                br._G.GameTooltip:SetText(tooltip, 214 / 255, 25 / 255, 25 / 255)
                br._G.GameTooltip:Show()
            end
        )
        newDropdown:SetEventListener(
            "OnLeave",
            function(this, event)
                br._G.GameTooltip:Hide()
            end
        )
    end

    ----------------------
    ------END Events------
    ----------------------
    newDropdown:ApplySettings()
    ----------------------------
    --------END Dropdown--------
    ----------------------------

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
    local white = elementOptions.white
    local shown = {}
    for i, choice in ipairs(choices) do shown[i] = white(choice) end
    return br.ui:createDropdown(section, name, shown, default, white(options.tip), white(options.boxTip),
        options.checkbox == false, options.checked)
end

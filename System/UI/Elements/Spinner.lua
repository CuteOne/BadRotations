local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...
-- checked (optional): default state of the option's checkbox for new settings
function br.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, hideCheckbox, checked)
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
    if hideCheckbox then
        local check = data[text .. " Check"]
        if check == 0 then
            check = false
        end
        if check == 1 then
            check = true
        end
        if check == true then
            checkBox:SetChecked(false)
        end
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end
    -------------------------------

    ------------------------------
    --------Create Spinner--------
    ------------------------------
    local spinner = DiesalGUI:Create("Spinner")
    parent:AddChild(spinner)

    spinner:SetParent(parent.content)
    spinner:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, Y)
    spinner:SetSettings(
        {
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
    )
    --    spinner:AddStyleSheet(spinnerStyleSheet)

    --------------
    ---BR Stuff---
    --------------
    -- Read number from config or set default
    br.functions.misc:registerOption(activePage, text .. " Status", number)
    if data[text .. " Status"] == nil then
        data[text .. " Status"] = number
    end

    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    if br.data.ui == nil then
        br.data.ui = {}
    end
    if br.data.ui[activePage] == nil then br.data.ui[activePage] = {} end
    br.data.ui[activePage][text .. " Status"] = data[text .. " Status"]

    local state = data[text .. " Status"]
    spinner:SetNumber(state)

    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChange
    spinner:SetEventListener(
        "OnValueChanged",
        function()
            data[text .. " Status"] = spinner:GetNumber()
        end
    )
    -- Event: Tooltip
    if tooltip or tooltipSpin then
        local tooltip = tooltipSpin or tooltip
        spinner:SetEventListener(
            "OnEnter",
            function()
                -- GameTooltip:SetOwner(spinner.frame, "ANCHOR_TOPLEFT", 0 , 2)
                -- GameTooltip:AddLine(tooltip)
                br._G.GameTooltip:SetOwner(br._G.Minimap, "ANCHOR_CURSOR", 50, 50)
                br._G.GameTooltip:SetText(tooltip, 214 / 255, 25 / 255, 25 / 255)
                br._G.GameTooltip:Show()
            end
        )
        spinner:SetEventListener(
            "OnLeave",
            function()
                br._G.GameTooltip:Hide()
            end
        )
    end
    ----------------------
    ------END Events------
    ----------------------
    spinner:ApplySettings()
    ---------------------------
    --------END Spinner--------
    ---------------------------
    return spinner, checkBox
end

-- Spinner Object : {number, min, max, step, tooltip}
-- checked (optional): default state of the option's checkbox for new settings
function br.ui:createDoubleSpinner(parent, text, spinner1, spinner2, hideCheckbox, checked)
    -- The window page this is on (double spinners used to be saved under it)
    local windowPage = ""
    if parent and parent.settings and parent.settings.parentObject and parent.settings.parentObject.pageDD then
        local pdd = parent.settings.parentObject.pageDD
        if pdd.value and pdd.settings and pdd.settings.list and pdd.settings.list[pdd.value] then
            windowPage = pdd.settings.list[pdd.value]
        end
    end
    -- Saved under the section's storage name, like every other option
    local activePage = parent.settings.storageName or parent.settings.sectionName or windowPage
    local profileSettings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
    profileSettings[activePage] = profileSettings[activePage] or {}
    local data = profileSettings[activePage]
    -- Move values saved under the window page's name before this changed
    local oldData = windowPage ~= activePage and profileSettings[windowPage] or nil
    if type(oldData) == "table" then
        for _, key in ipairs({ text .. " 1Status", text .. " 2Status" }) do
            if data[key] == nil and oldData[key] ~= nil then data[key] = oldData[key] end
            oldData[key] = nil
        end
        if next(oldData) == nil then profileSettings[windowPage] = nil end
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
    local checkBox = br.ui:createCheckbox(parent, text, "Enable auto usage of this spell", checked)
    if hideCheckbox then
        local check = data[text .. " Check"]
        if check == 0 then
            check = false
        end
        if check == 1 then
            check = true
        end
        if check == true then
            checkBox:SetChecked(false)
        end
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end

    ------------------------------
    --------Create Spinner--------
    ------------------------------
    local spinnerElement1 = DiesalGUI:Create("Spinner")
    local spinnerElement2 = DiesalGUI:Create("Spinner")
    parent:AddChild(spinnerElement1)
    parent:AddChild(spinnerElement2)

    spinnerElement1:SetParent(parent.content)
    spinnerElement2:SetParent(parent.content)
    spinnerElement1:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -50, Y)
    spinnerElement2:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, Y)
    spinnerElement1:SetSettings(
        {
            height = 12,
            width = 29,
            mouse = true,
            mouseWheel = true,
            buttons = false,
            buttonsWidth = 0,
            bar = true,
            min = spinner1.min or 0,
            max = spinner1.max or 100,
            step = spinner1.step or 5,
            shiftStep = 1
        }
    )
    spinnerElement2:SetSettings(
        {
            height = 12,
            width = 29,
            mouse = true,
            mouseWheel = true,
            buttons = false,
            buttonsWidth = 0,
            bar = true,
            min = spinner2.min or 0,
            max = spinner2.max or 100,
            step = spinner2.step or 5,
            shiftStep = 1
        }
    )

    --------------
    ---BR Stuff---
    --------------
    -- Read number from config or set default
    br.functions.misc:registerOption(activePage, text .. " 1Status", spinner1.number)
    br.functions.misc:registerOption(activePage, text .. " 2Status", spinner2.number)
    if data[text .. " 1Status"] == nil then
        data[text .. " 1Status"] = spinner1.number
    end
    if data[text .. " 2Status"] == nil then
        data[text .. " 2Status"] = spinner2.number
    end

    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    if br.data.ui == nil then
        br.data.ui = {}
    end
    if br.data.ui[activePage] == nil then br.data.ui[activePage] = {} end
    br.data.ui[activePage][text .. " 1Status"] = data[text .. " 1Status"]
    br.data.ui[activePage][text .. " 2Status"] = data[text .. " 2Status"]

    local state1 = data[text .. " 1Status"]
    spinnerElement1:SetNumber(state1)
    local state2 = data[text .. " 2Status"]
    spinnerElement2:SetNumber(state2)

    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChange
    spinnerElement1:SetEventListener(
        "OnValueChanged",
        function()
            data[text .. " 1Status"] = spinnerElement1:GetNumber()
        end
    )
    spinnerElement2:SetEventListener(
        "OnValueChanged",
        function()
            data[text .. " 2Status"] = spinnerElement2:GetNumber()
        end
    )
    -- Event: Tooltip
    if spinner1.tooltip then
        spinnerElement1:SetEventListener(
            "OnEnter",
            function()
                br._G.GameTooltip:SetOwner(br._G.Minimap, "ANCHOR_CURSOR", 50, 50)
                br._G.GameTooltip:SetText(spinner1.tooltip, 214 / 255, 25 / 255, 25 / 255)
                br._G.GameTooltip:Show()
            end
        )
        spinnerElement1:SetEventListener(
            "OnLeave",
            function()
                br._G.GameTooltip:Hide()
            end
        )
    end
    if spinner2.tooltip then
        spinnerElement2:SetEventListener(
            "OnEnter",
            function()
                br._G.GameTooltip:SetOwner(br._G.Minimap, "ANCHOR_CURSOR", 50, 50)
                br._G.GameTooltip:SetText(spinner2.tooltip, 214 / 255, 25 / 255, 25 / 255)
                br._G.GameTooltip:Show()
            end
        )
        spinnerElement2:SetEventListener(
            "OnLeave",
            function()
                br._G.GameTooltip:Hide()
            end
        )
    end
    ----------------------
    ------END Events------
    ----------------------
    spinnerElement1:ApplySettings()
    spinnerElement2:ApplySettings()
    ---------------------------
    --------END Spinner--------
    ---------------------------
    return spinner1, spinner2
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

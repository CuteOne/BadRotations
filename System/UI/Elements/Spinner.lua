local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...
function br.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, hideCheckbox)
    local activePageIdx = parent.settings.parentObject.pageDD.value
    local activePage = parent.settings.parentObject.pageDD.settings.list[activePageIdx]
    br.data.settings[br.selectedSpec][br.selectedProfile][activePage] = br.data.settings[br.selectedSpec]
        [br.selectedProfile][activePage] or {}
    local data = br.data.settings[br.selectedSpec][br.selectedProfile][activePage]
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
    local checkBox = br.ui:createCheckbox(parent, text, tooltip)
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
function br.ui:createDoubleSpinner(parent, text, spinner1, spinner2, hideCheckbox)
    local activePageIdx = parent.settings.parentObject.pageDD.value
    local activePage = parent.settings.parentObject.pageDD.settings.list[activePageIdx]
    -- string.gsub(parent.settings.parentObject.pageDD.settings.list[activePageIdx], " Options", "")
    -- activePage = string.gsub(activePage, " ", "")
    br.data.settings[br.selectedSpec][br.selectedProfile][activePage] = br.data.settings[br.selectedSpec]
        [br.selectedProfile][activePage] or {}
    local data = br.data.settings[br.selectedSpec][br.selectedProfile][activePage]
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
    local checkBox = br.ui:createCheckbox(parent, text, "Enable auto usage of this spell")
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

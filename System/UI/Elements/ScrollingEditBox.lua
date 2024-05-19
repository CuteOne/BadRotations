local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local DiesalStyle = _G.LibStub("DiesalStyle-1.0")
local Colors = DiesalStyle.Colors
local _, br = ...
function br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, hideCheckbox)
    local activePageIdx = parent.settings.parentObject.pageDD.value
    local activePage = parent.settings.parentObject.pageDD.settings.list[activePageIdx]
    br.data.settings[br.selectedSpec][br.selectedProfile][activePage] = br.data.settings[br.selectedSpec]
        [br.selectedProfile][activePage] or {}
    local data = br.data.settings[br.selectedSpec][br.selectedProfile][activePage]

    if width == nil then
        width = 240
    end
    if height == nil then
        height = 50
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
    local inputStyleSheet = {
        ["frame-background"] = {
            type = "texture",
            layer = "BACKGROUND",
            color = "000000",
            alpha = .6
        },
        ["track-background"] = {
            type = "texture",
            layer = "BACKGROUND",
            color = "000000",
            alpha = .3
        },
        ["grip-background"] = {
            type = "texture",
            layer = "BACKGROUND",
            color = Colors.UI_400
        },
        ["grip-inline"] = {
            type = "outline",
            layer = "BORDER",
            color = "FFFFFF",
            alpha = .02
        },
        ["frame-outline"] = {
            type = "outline",
            layer = "BORDER",
            color = "FFFFFF",
            offset = 0
        }
    }
    -------------------------------

    ------------------------------
    --------Create input--------
    ------------------------------
    local input = DiesalGUI:Create("ScrollingEditBox")
    parent:AddChild(input)

    input:SetParent(parent.content)
    input:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, Y - 14)
    input:SetStylesheet(inputStyleSheet)

    input.settings.contentPadding = { 1, 1, 1, 1 }

    --------------
    ---BR Stuff---
    --------------
    -- Read number from config or set default
    if data[text .. " EditBox"] == nil then
        data[text .. " EditBox"] = content
        br.data.ui[activePage][text .. " EditBox"] = content
    end
    local state = data[text .. " EditBox"]
    input:SetText(state)
    input:SetWidth(width)
    input:SetHeight(height)

    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChange
    input:SetEventListener(
        "OnTextChanged",
        function()
            data[text .. " EditBox"] = input.editBox:GetText()
            br.data.ui[activePage][text .. " EditBox"] = input.editBox:GetText()
            input.settings.text = input.editBox:GetText()
        end
    )
    ----------------------
    ------END Events------
    ----------------------
    input:ApplySettings()
    ---------------------------
    --------END input--------
    ---------------------------
    return input, checkBox
end

function br.ui:createScrollingEditBoxWithout(parent, text, content, tooltip, width, height)
    return br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, true)
end

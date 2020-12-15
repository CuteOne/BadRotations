local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local Colors = DiesalStyle.Colors

function br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, hideCheckbox)
    if width == nil then width = 240 end
    if height == nil then height = 50 end
    -------------------------------
    ----Need to calculate Y Pos----
    -------------------------------
    local Y = -5
    for i=1, #parent.children do
        if parent.children[i].type ~= "Spinner" and parent.children[i].type ~= "Dropdown" then
            Y = Y - parent.children[i].frame:GetHeight()*1.2
        end
    end
    Y = DiesalTools.Round(Y)

    -------------------------------
    --------Create CheckBox--------
    -------------------------------
    local checkBox = br.ui:createCheckbox(parent, text, tooltip)
    if hideCheckbox then
        local check = br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"]
        if check == 0 then check = false end
        if check == 1 then check = true end
        if check == true then checkBox:SetChecked(false) end
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end
    local inputStyleSheet = {
        ['frame-background'] = {
            type	= 'texture',
            layer	= 'BACKGROUND',
            color	= '000000',
            alpha   = .6,
        },
        ['track-background'] = {
            type	= 'texture',
            layer	= 'BACKGROUND',
            color	= '000000',
            alpha   = .3,
        },
        ['grip-background'] = {
            type	= 'texture',
            layer	= 'BACKGROUND',
            color	= Colors.UI_400,
        },
        ['grip-inline'] = {
            type    = 'outline',
            layer   = 'BORDER',
            color   = 'FFFFFF',
            alpha   = .02,
        },
        ["frame-outline"] = {
            type = "outline",
            layer = "BORDER",
            color = 'FFFFFF',
            offset = 0
        },
    }
    -------------------------------

    ------------------------------
    --------Create input--------
    ------------------------------
    local input = DiesalGUI:Create('ScrollingEditBox')
    parent:AddChild(input)

    input:SetParent(parent.content)
    input:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, Y-14)
    input:SetStylesheet(inputStyleSheet)

    input.settings.contentPadding        = {1,1,1,1}

    --------------
    ---BR Stuff---
    --------------
    -- Read number from config or set default
    if br.data.settings[br.selectedSpec][br.selectedProfile][text.."EditBox"] == nil then br.data.settings[br.selectedSpec][br.selectedProfile][text.."EditBox"] = content end
    local state = br.data.settings[br.selectedSpec][br.selectedProfile][text.."EditBox"]
    input:SetText(state)
    input:SetWidth(width)
    input:SetHeight(height)

    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChange
    input:SetEventListener('OnTextChanged', function()
        br.data.settings[br.selectedSpec][br.selectedProfile][text.."EditBox"] = input.editBox:GetText()
        input.settings.text = input.editBox:GetText()
    end)
    ----------------------
    ------END Events------
    ----------------------
    input:ApplySettings()
    ---------------------------
    --------END input--------
    ---------------------------
end

function br.ui:createScrollingEditBoxWithout(parent, text, content, tooltip, width, height)
    return br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, true)
end
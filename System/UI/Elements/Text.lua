local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...
function br.ui:createText(parent, text, isCheckbox)
    if isCheckbox == nil then
        isCheckbox = false
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
    --------------------------------------------------
    --------Create Hidden CheckBox for Spacing--------
    --------------------------------------------------
    if not isCheckbox then -- Bypass for Checkbox element that calls this createText
        local checkBox = br.ui:createCheckbox(parent, text, "")
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end
    ----------------------------
    --------Create Label--------
    ----------------------------
    local label = DiesalGUI:Create("FontString")

    label:SetParent(parent.content)

    parent:AddChild(label)

    label = label.fontString

    -- Ensure font is set before using the FontString
    if not label:GetFont() then
        label:SetFontObject(_G.GameFontNormal)
    end

    label:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, Y)
    label:SetWidth(parent.content:GetWidth() - 10)
    label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
    label:SetText(text)
    label:SetWordWrap(false)

    -------------------------
    --------END Label--------
    -------------------------

    return label
end

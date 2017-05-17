local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalTools = LibStub("DiesalTools-1.0")

function br.ui:createText(parent, text)
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
    ----------------------------
    --------Create Label--------
    ----------------------------
    local label = DiesalGUI:Create("FontString")

    label:SetParent(parent.content)

    parent:AddChild(label)

    label = label.fontString

    label:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, Y)
    label:SetWidth(parent.content:GetWidth()-10)
    label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
    label:SetText(text)
    label:SetWordWrap(false)

    -------------------------
    --------END Label--------
    -------------------------
end
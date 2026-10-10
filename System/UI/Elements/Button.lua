local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...
function br.ui:createButton(parent, buttonName, x, y, onClickFunction, alignRight)
    if y == nil then
        y = -5
        for i = 1, #parent.children do
            if parent.children[i].type ~= "Spinner" and parent.children[i].type ~= "Dropdown" then
                y = y - parent.children[i].frame:GetHeight() * 1.2
            end
        end
        y = DiesalTools.Round(y)
    end
    if x == nil then
        x = 5
    end
    local newButton = DiesalGUI:Create("Button")
    local parent = parent
    -- A pooled button that was a page arrow keeps its arrow texture (Arrow.lua)
    if newButton.arrowIcon then newButton.arrowIcon:Hide() end

    newButton:SetParent(parent.content)
    parent:AddChild(newButton)
    newButton:SetStylesheet(br.ui.buttonStyleSheet)
    if alignRight then
        newButton:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", x, y)
    else
        newButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    end
    newButton:SetText(buttonName)
    newButton:SetWidth(100)
    newButton:SetHeight(20)
    newButton:SetEventListener(
        "OnClick",
        function()
            onClickFunction()
        end
    )
end

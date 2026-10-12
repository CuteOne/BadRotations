local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
function br.ui:createButton(parent, buttonName, x, y, onClickFunction, alignRight)
    y = y or br.ui.elementOptions.nextRowY(parent)
    if x == nil then
        x = 5
    end
    local newButton = DiesalGUI:Create("Button")
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

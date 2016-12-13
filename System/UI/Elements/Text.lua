local DiesalGUI = LibStub("DiesalGUI-1.0")

function createNewText(parent, text)
    local newText = DiesalGUI:Create("FontString")
    local offset = -2
    local anchor = parent.content

    -- Calculate Position
    local howManyTexts = 1
    for i=1, #parent.children do
        if parent.children[i].type == "FontString" then
            anchor = parent.children[i]
        end
    end

    local y = howManyTexts
    if y  ~= 1 then y = ((y-1) * -br.spacing) -5 end
    if y == 1 then y = -5 end

    newText:SetParent(parent.content)
    parent:AddChild(newText)
    newText = newText.fontString


    newText:SetPoint("TOPLEFT", anchor.content, "TOPLEFT", 5, offset)
    newText:SetPoint("TOPRIGHT", anchor.content, "TOPRIGHT", -5, offset)

    newText:SetText(text)
    newText:SetJustifyH('LEFT')
    newText:SetJustifyV('TOP')
    newText:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    newText:SetWidth(parent.content:GetWidth()-10)
    newText:SetWordWrap(true)

    return newText
end
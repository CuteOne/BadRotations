local DiesalGUI = LibStub("DiesalGUI-1.0")

function br.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, hideCheckbox)
    local newDropdown = DiesalGUI:Create('DropdownBR')
    local parent = parent
    local itemlist = itemlist
    local default = default or 1

    -- Create Checkbox for Dropdown
    local checkBox = br.ui:createCheckbox(parent,text,tooltip)

    -- Calculate position
    local howManyBoxes = 0
    for i=1, #parent.children do
        if parent.children[i].type == "Toggle" then
            howManyBoxes = howManyBoxes + 1
        end
    end
    local y = howManyBoxes
    if y  ~= 1 then y = ((y-1) * -br.spacing) -5 end
    if y == 1 then y = -5 end

    if hideCheckbox then
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end

    --newDropdown.settings.text = text
    newDropdown.settings.height = 12
    newDropdown:SetParent(parent.content)
    newDropdown:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, y)

    -- Create the Dropdown List
    newDropdown:SetList(itemlist)

    -- Read from config or set default
    if br.data.settings[br.selectedSpec][br.selectedProfile][text.."Drop"] == nil then br.data.settings[br.selectedSpec][br.selectedProfile][text.."Drop"] = default end
    local value = br.data.settings[br.selectedSpec][br.selectedProfile][text.."Drop"]
    newDropdown:SetValue(value)

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        br.data.settings[br.selectedSpec][br.selectedProfile][text.."Drop"]  = key
    end)
    -- Event: Tooltip
    if tooltip or tooltipDrop then
        local tooltip = tooltipDrop or tooltip
        newDropdown:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newDropdown:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    return newDropdown
end

function br.ui:createDropdownWithout(parent, text, itemlist, default, tooltip, tooltipDrop)
    return br.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, true)
end
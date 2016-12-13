local DiesalGUI = LibStub("DiesalGUI-1.0")

function br.ui:createSection(parent, sectionName, tooltip)
    local newSection = DiesalGUI:Create('AccordianSectionBR')
    local parent = parent

    -- Calculate Position
    local howManySections = 1
    for i=1, #parent.children do
        if parent.children[i].type == "AccordianSectionBR" then
            howManySections = howManySections + 1
        end
    end

    local position = howManySections

    newSection:SetParentObject(parent)
    newSection.settings.position = position
    newSection.settings.sectionName = sectionName
    if br.data.settings[br.selectedSpec][br.selectedProfile] == nil then br.data.settings[br.selectedSpec][br.selectedProfile] = {} end
    newSection.settings.expanded = br.data.settings[br.selectedSpec][br.selectedProfile][sectionName.."Section"] or true
    --newSection.settings.contentPad = {0,0,12,32}

    newSection:SetEventListener('OnStateChange', function(this, event)
       br.data.settings[br.selectedSpec][br.selectedProfile][sectionName.."Section"] = newSection.settings.expanded
    end)
    -- Event: Tooltip
    if tooltip then
        newSection:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newSection:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end

    newSection:ApplySettings()
    newSection:UpdateHeight()

    parent:AddChild(newSection)

    return newSection
end

-- Restore last saved state of section (collapsed or expanded)
function br.ui:checkSectionState(section)
    local state = br.data.settings[br.selectedSpec][br.selectedProfile][section.settings.sectionName.."Section"]

    if state then
        section:Expand()
    else
        section:Collapse()
    end
end
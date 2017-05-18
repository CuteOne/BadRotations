local DiesalGUI = LibStub("DiesalGUI-1.0")

function br.ui:createSection(parent, sectionName, tooltip)
    local newSection = DiesalGUI:Create('AccordianSection')
    local parent = parent

    newSection:SetParentObject(parent)
    newSection:ClearAllPoints()
    -- Calculate Position
    if #parent.children == nil then
        newSection.settings.position = 1
    else
        newSection.settings.position = #parent.children + 1
    end
    newSection.settings.sectionName = sectionName
    if br.data.settings[br.selectedSpec][br.selectedProfile] == nil then br.data.settings[br.selectedSpec][br.selectedProfile] = {} end
    newSection.settings.expanded = br.data.settings[br.selectedSpec][br.selectedProfile][sectionName.."Section"] or true
    -- newSection.settings.contentPadding = {0,0,12,32}

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

    --Override UpdateHeight()
    local function UpdateHeight(self)
        local settings, children = self.settings, self.children
        local contentHeight = 0
        self.content:SetPoint('TOPLEFT',self.frame,0,settings.button and -settings.buttonHeight or 0)

        if settings.expanded then
            contentHeight = settings.contentPadding[3] + settings.contentPadding[4]
            for i=1 , #children do
                --                Print("children[i].type: "..children[i].type)
                if children[i].type ~= "Spinner" and children[i].type ~= "Dropdown" then
                    contentHeight = contentHeight + children[i].frame:GetHeight()*1.2
                end
            end
        end
        self.content:SetHeight(contentHeight)
        self:SetHeight((settings.button and settings.buttonHeight or 0) + contentHeight)
        self:FireEvent("OnHeightChange",contentHeight)
    end

    if state then
        section:Expand()
        UpdateHeight(section)
    else
        section:Collapse()
    end
end
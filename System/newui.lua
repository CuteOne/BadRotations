local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0") 
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")

--if BadBoy_data.options[GetSpecialization()] == nil then BadBoy_data.options[GetSpecialization()] = {} end
--if BadBoy_data.options[GetSpecialization()][bb.selectedProfile] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile] = {} end

-- TODO: save window position and restore it



local buttonStyleSheet = {
    ['frame-color'] = {
        type			= 'texture',
        layer			= 'BACKGROUND',
        color			= '2f353b',
        offset		= 0,
    },
    ['frame-highlight'] = {
        type			= 'texture',
        layer			= 'BORDER',
        gradient	= 'VERTICAL',
        color			= 'FFFFFF',
        alpha 		= 0,
        alphaEnd	= .1,
        offset		= -1,
    },
    ['frame-outline'] = {
        type			= 'outline',
        layer			= 'BORDER',
        color			= '000000',
        offset		= 0,
    },
    ['frame-inline'] = {
        type			= 'outline',
        layer			= 'BORDER',
        gradient	= 'VERTICAL',
        color			= 'ffffff',
        alpha 		= .02,
        alphaEnd	= .09,
        offset		= -1,
    },
    ['frame-hover'] = {
        type			= 'texture',
        layer			= 'HIGHLIGHT',
        color			= 'ffffff',
        alpha			= .1,
        offset		= 0,
    },
    ['text-color'] = {
        type			= 'Font',
        color			= 'b8c2cc',
    },
}

function createNewWindow(name, width, height)
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadBoy', name)
    window.settings.width = width or 250
    window.settings.height = height or 250
    window:ApplySettings()

    return window
end

function createNewProfileWindow(name, width, height)
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadBoy', name)
    window.settings.width = width or 300
    window.settings.height = height or 250
    window:ApplySettings()

    --bb:checkProfileWindowStatus()
    return window
end

function createNewCheckbox(parent, text)
    local newBox = DiesalGUI:Create('Toggle')
    local parent = parent
    local anchor = anchor or "TOPLEFT"
    -- todo: profile updaten

    -- Set text
    newBox:SetText(text)

    -- Change size
    --newBox.settings.height = 12
    --newBox.settings.width = 12

    -- Calculate Position
    local howManyBoxes = 1
    for i=1, #parent.children do
        if parent.children[i].type == "Toggle" then
            howManyBoxes = howManyBoxes + 1
        end
    end

    local y = howManyBoxes
    if y  ~= 1 then y = ((y-1) * -15) -5 end
    if y == 1 then y = -5 end

    -- Set parent
    newBox:SetParent(parent.content)

    -- Set anchor
    newBox:SetPoint("TOPLEFT", parent.content, anchor, 10, y)

    -- Read check value from config, false if nothing found
    -- Set default
    if BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"] = false end
    local check = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"]
    if check == 0 then check = false end
    if check == 1 then check = true end


    newBox:SetChecked(check)

    -- Event: OnValueChanged
    newBox:SetEventListener('OnValueChanged', function(this, event, checked)
        BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"] = checked

        -- Create Chat Overlay
        if checked then
            ChatOverlay("|cff15FF00"..text.." Enabled")
        else
            ChatOverlay("|cFFED0000"..text.." Disabled")
        end
    end)

    -- Apply changed settings like size, position, etc
    newBox:ApplySettings()

    -- Add as a child element to parent
    parent:AddChild(newBox)

    return newBox
end

function createNewSpinner(parent, text, number, min, max, step)
    local newSpinner = DiesalGUI:Create('Spinner')
    local parent = parent
    local profile = BadBoy_data.options[GetSpecialization()]["Rotation".."Drop"]

    -- Create Checkbox for Spinner
    createNewCheckbox(parent, text)

    -- Calculate position
    local howManyBoxes = 0
    for i=1, #parent.children do
        if parent.children[i].type == "Toggle" then
            howManyBoxes = howManyBoxes + 1
        end
    end
    local y = howManyBoxes
    if y  ~= 1 then y = ((y-1) * -15) -5 end
    if y == 1 then y = -5 end

    -- Set size
    newSpinner.settings.height = 12

    -- Set Steps
    newSpinner.settings.min = min or 0
    newSpinner.settings.max = max or 100
    newSpinner.settings.step = step or 5

    newSpinner:SetParent(parent.content)

    -- Set anchor
    newSpinner:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, y)

    -- Read number from config or set default
    if BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"] = number end
    local state = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"]
    newSpinner:SetNumber(state)


    -- Event: OnValueChange
    newSpinner:SetEventListener('OnValueChanged', function(this, event, checked)
        BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"] = newSpinner:GetNumber()
    end)

    newSpinner:ApplySettings()

    parent:AddChild(newSpinner)

    return newSpinner
end

function createNewDropdown(parent, text, itemlist)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent
    local itemlist = itemlist

    -- Create Checkbox for Spinner
    createNewCheckbox(parent,text)

    -- Calculate position
    local howManyBoxes = 0
    for i=1, #parent.children do
        if parent.children[i].type == "Toggle" then
            howManyBoxes = howManyBoxes + 1
        end
    end
    local y = howManyBoxes
    if y  ~= 1 then y = ((y-1) * -15) -5 end
    if y == 1 then y = -5 end

    --newDropdown.settings.text = text
    newDropdown.settings.height = 12
    newDropdown:SetParent(parent.content)
    newDropdown:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, y)

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"]  = key
    end)
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    -- Create the Dropdown List
    newDropdown:SetList(itemlist)

    -- Read from config or set default
    local value = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"] or 1
    newDropdown:SetValue(value)
    if BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"] = value end

    return newDropdown
end

function createNewRotationDropdown(parent, itemlist)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent
    local text = "Rotation"
    --local profile = BadBoy_data.options[GetSpecialization()]["Rotation".."Drop"]

    newDropdown:SetParent(parent.titleBar)
    newDropdown:SetPoint("TOPRIGHT", parent.closeButton, "TOPLEFT", 0, -2)

    newDropdown:SetList(itemlist)

    if BadBoy_data.options[GetSpecialization()][text.."Drop"] == nil then BadBoy_data.options[GetSpecialization()][text.."Drop"] = 1 end
    local value = BadBoy_data.options[GetSpecialization()][text.."Drop"]
    newDropdown:SetValue(value)
    if BadBoy_data.options[GetSpecialization()][text.."Drop"] == nil then BadBoy_data.options[GetSpecialization()][text.."Drop"] = value end

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        BadBoy_data.options[GetSpecialization()][text.."Drop"]  = key
        BadBoy_data.options[GetSpecialization()][text.."DropValue"]  = value
        bb.selectedProfile = key
        bb:recreateWindows()
        bb.rotation_changed = true
    end)
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    return newDropdown
end

function createNewSection(parent, sectionName)
    local newSection = DiesalGUI:Create('AccordianSectionBB')
    local parent = parent

    -- Calculate Position
    local howManySections = 1
    for i=1, #parent.children do
        if parent.children[i].type == "AccordianSectionBB" then
            howManySections = howManySections + 1
        end
    end

    local position = howManySections

    newSection:SetParentObject(parent)
    newSection.settings.position = position
    newSection.settings.sectionName = sectionName
    newSection.settings.expanded = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][sectionName.."Section"]
    --newSection.settings.contentPad = {0,0,12,32}

    newSection:SetEventListener('OnStateChange', function(this, event)
       BadBoy_data.options[GetSpecialization()][bb.selectedProfile][sectionName.."Section"] = newSection.settings.expanded
    end)

    newSection:ApplySettings()
    newSection:UpdateHeight()

    parent:AddChild(newSection)

    return newSection
end

-- Restore last saved state of section (collapsed or expanded)
function checkSectionState(section)
    local state = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][section.settings.sectionName.."Section"]

    if state then
        section:Expand()
    else
        section:Collapse()
    end
end

function createNewButton(buttonName, parent)
    local newButton = DiesalGUI:Create('Button')
    local parent = parent

    parent:AddChild(newButton)
    newButton:SetParent(parent.content)
    newButton:AddStyleSheet(buttonStyleSheet)
    newButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 10, -10)
    newButton:SetText(buttonName)
    newButton:SetWidth(100)
    newButton:SetHeight(20)
    --newBox:SetEventListener("OnClick", function()
    --
    --end)

    parent:AddChild(newButton)

    return newButton
end

-- Checks if profile button was shown or closed on last logout and restores it
-- TODO: BUG atm as it only saves state when uses via minimap icon, doesnt save if window is closed by clickin on X
-- TODO: BUG on / off toggle doesnt behave correctly
function bb:checkProfileWindowStatus()
    if BadBoy_data.options[GetSpecialization()]["configFrame"] ~= true then
        if bb.profile_window then
            bb.profile_window:Show()
            return true
        end
    else
        if bb.profile_window then
            bb.profile_window.closeButton:Click()
            return false
        end
    end
end

function bb:checkConfigWindowStatus()
    if BadBoy_data.options[GetSpecialization()] then
        if BadBoy_data.options[GetSpecialization()]["optionsFrame"] then
            if bb.config_window then
                bb.config_window.closeButton:Click()
                optionsFrame:Hide()
                BadBoy_data.options[GetSpecialization()]["optionsFrame"] = false
            end
        else
            if bb.config_window then
                bb.config_window:Show()
                optionsFrame:Show()
                BadBoy_data.options[GetSpecialization()]["optionsFrame"] = true
            end
        end
    end
end

function bb:recreateWindows()
    bb.config_window.closeButton:Click()
    bb.profile_window.closeButton:Click()

    bb:createConfigWindowNew()
end


function bb:createConfigWindowNew()
    bb.config_window = createNewWindow("Configuration", 275, 400)

    -- General
    local section_general = createNewSection(bb.config_window, "General")
    createNewCheckbox(section_general, "Start/Stop BadBoy")
    createNewCheckbox(section_general, "Debug Frame")
    createNewCheckbox(section_general, "Display Failcasts")
    createNewCheckbox(section_general, "Queue Casting")
    createNewSpinner(section_general,  "Auto Loot" ,0.5, 0.1, 3, 0.1)
    createNewCheckbox(section_general, "Auto-Sell/Repair")
    createNewCheckbox(section_general, "Accept Queues")
    createNewCheckbox(section_general, "Overlay Messages")
    checkSectionState(section_general)

    -- Enemies Engine
    local section_enemies = createNewSection(bb.config_window, "Enemies Engine")
    createNewCheckbox(section_enemies, "Dynamic Targetting")
    createNewDropdown(section_enemies, "Wise Target", {"Highest", "Lowest"})
    createNewCheckbox(section_enemies, "Forced Burn")
    createNewCheckbox(section_enemies, "Avoid Shields")
    createNewCheckbox(section_enemies, "Tank Threat")
    createNewCheckbox(section_enemies, "Safe Damage Check")
    createNewCheckbox(section_enemies, "Don't break CCs")
    createNewCheckbox(section_enemies, "Skull First")
    createNewDropdown(section_enemies, "Interrupts Handler", {"Target", "T/M", "T/M/F", "All"})
    createNewCheckbox(section_enemies, "Only Known Units")
    createNewCheckbox(section_enemies, "Crowd Control")
    createNewCheckbox(section_enemies, "Enrages Handler")
    checkSectionState(section_enemies)

    -- Healing Engine
    local section_healing = createNewSection(bb.config_window, "Healing Engine")
    createNewCheckbox(section_healing, "HE Active")
    createNewCheckbox(section_healing, "Heal Pets")
    createNewDropdown(section_healing, "Special Heal", {"Target", "T/M", "T/M/F", "T/F"})
    createNewCheckbox(section_healing, "Sorting with Role")
    createNewDropdown(section_healing, "Prioritize Special Targets", {"Special", "All"})
    createNewSpinner(section_healing, "Blacklist", 95)
    createNewCheckbox(section_healing, "Ignore Absorbs")
    createNewCheckbox(section_healing, "Incoming Heals")
    createNewSpinner(section_healing, "Overhealing Cancel", 95)
    createNewCheckbox(section_healing, "Healing Debug")
    createNewSpinner(section_healing, "Debug Refresh", 500, 0, 1000, 25)
    createNewSpinner(section_healing, "Dispel delay", 15, 5, 90, 5)
    checkSectionState(section_healing)

    -- Other Features
    local section_other = createNewSection(bb.config_window, "Other Features")
    createNewSpinner(section_other, "Profession Helper", 0.5, 0, 1, 0.1)
    createNewDropdown(section_other, "Prospect Ores", {"WoD", "MoP", "Cata", "All"})
    createNewDropdown(section_other, "Mill Herbs", {"WoD", "MoP", "Cata", "All"})
    createNewCheckbox(section_other, "Disenchant")
    createNewCheckbox(section_other, "Leather Scraps")
    createNewSpinner(section_other, "Salvage", 15, 5, 30, 1)
    checkSectionState(section_other)

    -- temp
    if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()]["optionsFrame"] ~= true then
        bb.config_window.closeButton:Click()
    end
end

local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0") 
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

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

    local scrollFrame = DiesalGUI:Create('ScrollFrame')
    window:AddChild(scrollFrame)
    scrollFrame:SetParent(window.content)
    scrollFrame:SetAllPoints(window.content)
    scrollFrame.parent = window

    return scrollFrame
end

function createNewProfileWindow(name, width, height)
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadBoy', name)
    window.settings.width = width or 300
    window.settings.height = height or 250
    window:ApplySettings()

    local scrollFrame = DiesalGUI:Create('ScrollFrame')
    window:AddChild(scrollFrame)
    scrollFrame:SetParent(window.content)
    scrollFrame:SetAllPoints(window.content)
    scrollFrame.parent = window

    return scrollFrame
end

function createNewMessageWindow(name, width, height)
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadBoy', name)
    window.settings.width = width or 300
    window.settings.height = height or 250
    window:ApplySettings()

    local newMessageFrame = DiesalGUI:Create('ScrollingMessageFrameBB')
    window:AddChild(newMessageFrame)
    newMessageFrame:SetParent(window.content)
    newMessageFrame:SetAllPoints(window.content)
    newMessageFrame.parent = window

    return newMessageFrame
end

function createNewCheckbox(parent, text, tooltip)
    local newBox = DiesalGUI:Create('Toggle')
    local parent = parent
    local anchor = anchor or "TOPLEFT"

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
    -- Event: Tooltip
    if tooltip then
        newBox:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newBox:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end

    -- Apply changed settings like size, position, etc
    newBox:ApplySettings()

    -- Add as a child element to parent
    parent:AddChild(newBox)

    return newBox
end

function createNewSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin)
    local newSpinner = DiesalGUI:Create('Spinner')
    local parent = parent

    -- Create Checkbox for Spinner
    createNewCheckbox(parent, text, tooltip)

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
    -- Event: Tooltip
    if tooltip or tooltipSpin then
        local tooltip = tooltipSpin or tooltip
        newSpinner:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newSpinner:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end

    newSpinner:ApplySettings()

    parent:AddChild(newSpinner)

    return newSpinner
end

function createNewDropdown(parent, text, itemlist, default, tooltip, tooltipDrop)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent
    local itemlist = itemlist
    local default = default or 1

    -- Create Checkbox for Spinner
    createNewCheckbox(parent,text,tooltip)

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

    -- Create the Dropdown List
    newDropdown:SetList(itemlist)

    -- Read from config or set default
    if BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"] = default end
    local value = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"]
    newDropdown:SetValue(value)

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"]  = key
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

function createNewRotationDropdown(parent, itemlist, tooltip)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent
    local text = "Rotation"

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
    -- Event: Tooltip
    if tooltip then
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

function createNewSection(parent, sectionName, tooltip)
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

--[[ FROM PE ]]--

DiesalGUI:RegisterObjectConstructor("FontString", function()
    local self 		= DiesalGUI:CreateObjectBase(Type)
    local frame		= CreateFrame('Frame',nil,UIParent)
    local fontString = frame:CreateFontString(nil, "OVERLAY", 'DiesalFontNormal')
    self.frame		= frame
    self.fontString = fontString
    self.SetParent = function(self, parent)
        self.frame:SetParent(parent)
    end
    self.OnRelease = function(self)
        self.fontString:SetText('')
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "FontString"
    return self
end, 1)

DiesalGUI:RegisterObjectConstructor("Rule", function()
    local self 		= DiesalGUI:CreateObjectBase(Type)
    local frame		= CreateFrame('Frame',nil,UIParent)
    self.frame		= frame
    frame:SetHeight(1)
    frame.texture = frame:CreateTexture()
    frame.texture:SetTexture(0,0,0,0.5)
    frame.texture:SetAllPoints(frame)
    self.SetParent = function(self, parent)
        self.frame:SetParent(parent)
    end
    self.OnRelease = function(self)
        self:Hide()
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "Rule"
    return self
end, 1)

local statusBarStylesheet = {
    ['frame-texture'] = {
        type		= 'texture',
        layer		= 'BORDER',
        gradient	= 'VERTICAL',
        color		= '000000',
        alpha 		= 0.7,
        alphaEnd	= 0.1,
        offset		= 0,
    }
}

DiesalGUI:RegisterObjectConstructor("StatusBar", function()
    local self  = DiesalGUI:CreateObjectBase(Type)
    local frame = CreateFrame('StatusBar',nil,UIParent)
    self.frame  = frame

    self:AddStyleSheet(statusBarStylesheet)

    frame.Left = frame:CreateFontString()
    frame.Left:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    frame.Left:SetShadowColor(0,0,0, 0)
    frame.Left:SetShadowOffset(-1,-1)
    frame.Left:SetPoint("LEFT", frame)

    frame.Right = frame:CreateFontString()
    frame.Right:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    frame.Right:SetShadowColor(0,0,0, 0)
    frame.Right:SetShadowOffset(-1,-1)

    frame:SetStatusBarTexture(1,1,1,0.8)
    frame:GetStatusBarTexture():SetHorizTile(false)
    frame:SetMinMaxValues(0, 100)
    frame:SetHeight(15)

    self.SetValue = function(self, value)
        self.frame:SetValue(value)
    end
    self.SetParent = function(self, parent)
        self.parent = parent
        self.frame:SetParent(parent)
        self.frame:SetPoint("LEFT", parent, "LEFT")
        self.frame:SetPoint("RIGHT", parent, "RIGHT")
        self.frame.Right:SetPoint("RIGHT", self.frame, "RIGHT", -2, 2)
        self.frame.Left:SetPoint("LEFT", self.frame, "LEFT", 2, 2)
    end
    self.OnRelease = function(self)
        self:Hide()
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "Rule"
    return self
end, 1)


--[[ ]]--

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
    if y  ~= 1 then y = ((y-1) * -15) -5 end
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


-- Restore last saved state of section (collapsed or expanded)
function checkSectionState(section)
    local state = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][section.settings.sectionName.."Section"]

    if state then
        section:Expand()
    else
        section:Collapse()
    end
end

function createNewButton(parent, buttonName, x, y)
    local newButton = DiesalGUI:Create('Button')
    local parent = parent

    parent:AddChild(newButton)
    newButton:SetParent(parent.content)
    newButton:AddStyleSheet(buttonStyleSheet)
    newButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
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
            bb.profile_window.parent:Show()
            return true
        end
    else
        if bb.profile_window then
            bb.profile_window.parent.closeButton:Click()
            return false
        end
    end
end

function bb:checkConfigWindowStatus()
    if BadBoy_data.options[GetSpecialization()] then
        if BadBoy_data.options[GetSpecialization()]["optionsFrame"] then
            if bb.config_window then
                bb.config_window.parent.closeButton:Click()
                --optionsFrame:Hide()
                BadBoy_data.options[GetSpecialization()]["optionsFrame"] = false
            end
        else
            if bb.config_window then
                bb.config_window.parent:Show()
                --optionsFrame:Show()
                BadBoy_data.options[GetSpecialization()]["optionsFrame"] = true
            end
        end
    end
end

function bb:recreateWindows()
    bb.config_window.parent.closeButton:Click()
    bb.profile_window.parent.closeButton:Click()

    bb:createConfigWindowNew()
end

-- todo
function bb:createOverviewWindow()
    bb.overview_window = createNewWindow("Overview")

    -- Open ABOUT window
    local buttonAbout = createNewButton(bb.overview_window, "About", 10, -10)
    buttonAbout:SetEventListener("OnClick", function()
        bb.about_window:Show()
    end)
end

-- todo
function bb:createAboutWindow()
    bb.about_window = createNewWindow("About")


end

function bb:createHelpWindow()
    bb.help_window = createNewMessageWindow("Help")
    local colorBlue = "|cff00CCFF"
    local colorGreen = "|cff00FF00"
    local colorRed = "|cffFF0011"
    local colorWhite = "|cffFFFFFF"
    local colorGold = "|cffFFDD11"
    bb.help_window:AddMessage(colorGreen.."--- [[ AUTHORS ]] ---")
    bb.help_window:AddMessage(colorRed.."CodeMyLife - CuteOne - Ragnar - Defmaster")
    bb.help_window:AddMessage(colorRed.."Gabbz - Chumii - AveryKey")
    bb.help_window:AddMessage(colorRed.."Masoud - Cpoworks - Tocsin")
    bb.help_window:AddMessage(colorRed.."Mavmins - CukieMunster - Magnu")
    bb.help_window:AddMessage("----------------------------------------")
    --
    bb.help_window:AddMessage(colorGreen.."--- [[ TODO ]] ---")
    bb.help_window:AddMessage(colorGold.."HELP WINDOW NOT FINISHED YET ! ")
    bb.help_window.parent:Hide()
end


-- This creates the normal BadBay Configuration Window
function bb:createConfigWindowNew()
    bb:createHelpWindow()
    bb.config_window = createNewWindow("Configuration", 275, 400)

    -- General
    local section_general = createNewSection(bb.config_window, "General")
    createNewCheckbox(section_general, "Start/Stop BadBoy")
    createNewCheckbox(section_general, "Debug Frame")
    createNewCheckbox(section_general, "Display Failcasts")
    createNewCheckbox(section_general, "Queue Casting")
    createNewSpinner(section_general,  "Auto Loot" ,0.5, 0.1, 3, 0.1, "Sets Autloot on/off.", "Sets a delay for Auto Loot.")
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
        bb.config_window.parent.closeButton:Click()
    end
end

-- TODO: create new debug frame
function bb.createDebugWindow()

end
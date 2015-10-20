local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0") 
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")

guit = {}

-- TODO: make options profile/rotation based atm its always eg. protection instead of protection/defmaster protection/cute etc.

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

    return window
end

function createNewCheckbox(text, x, y, parent)
    local newBox = DiesalGUI:Create('Toggle')
    local parent = parent
    local anchor = anchor or "TOPLEFT"

    newBox:SetText(text)
    --newBox.settings.height = 12
    --newBox.settings.width = 12
    local y = y
    if y  ~= 1 then y = ((y-1) * -15) -5 end
    if y == 1 then y = -5 end

    newBox:SetParent(parent.content)
    newBox:SetPoint("TOPLEFT", parent.content, anchor, x, y)
    local check = BadBoy_data.options[GetSpecialization()][text.."Check"] or false
    if check == 0 then check = false end
    if check == 1 then check = true end
    newBox:SetChecked(check)
    newBox:SetEventListener('OnValueChanged', function(this, event, checked)
        BadBoy_data.options[GetSpecialization()][text.."Check"] = checked
    end)

    newBox:ApplySettings()
    parent:AddChild(newBox)

    return newBox
end

function createNewSpinner(text, number, x, y, parent, min, max, step)
    local newSpinner = DiesalGUI:Create('Spinner')
    local parent = parent

    local y = y
    if y  ~= 1 then y = ((y-1) * -15) -5 end
    if y == 1 then y = -5 end
    newSpinner.settings.height = 12
    newSpinner.settings.min = min or 0
    newSpinner.settings.max = max or 100
    newSpinner.settings.step = step or 5
    newSpinner:SetParent(parent.content)
    newSpinner:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", x, y)
    newSpinner:SetNumber(BadBoy_data.options[GetSpecialization()][text.."Status"] or number)

    newSpinner:SetEventListener('OnValueChanged', function(this, event, checked)
        BadBoy_data.options[GetSpecialization()][text.."Status"] = newSpinner:GetNumber()
    end)
    newSpinner:ApplySettings()

    parent:AddChild(newSpinner)

    return newSpinner
end

function createNewDropdown(text, x, y, parent, itemlist)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent
    local itemlist = itemlist

    local y = y
    if y  ~= 1 then y = ((y-1) * -15) -5 end
    if y == 1 then y = -5 end
    --newDropdown.settings.text = text
    newDropdown.settings.height = 12
    newDropdown:SetParent(parent.content)
    newDropdown:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", x, y)

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        BadBoy_data.options[GetSpecialization()][text.."Drop"]  = key
    end)
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    newDropdown:SetList(itemlist)
    newDropdown:SetValue(BadBoy_data.options[GetSpecialization()][text.."Drop"] or 1)

    return newDropdown
end

function createNewRotationDropdown(text, parent, itemlist)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent

    newDropdown:SetParent(parent.titleBar)
    newDropdown:SetPoint("TOPRIGHT", parent.closeButton, "TOPLEFT", 0, -2)
    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        BadBoy_data.options[GetSpecialization()][text.."Drop"]  = key
        BadBoy_data.options[GetSpecialization()][text.."DropValue"]  = value
        bb.rotation_changed = true
    end)
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    newDropdown:SetList(itemlist)
    newDropdown:SetValue(BadBoy_data.options[GetSpecialization()][text.."Drop"] or 1)

    return newDropdown
end

function createNewSection(sectionName, position, parent)
    local newSection = DiesalGUI:Create('AccordianSectionBB')
    local parent = parent

    newSection:SetParentObject(parent)
    newSection.settings.position = position
    newSection.settings.sectionName = sectionName
    --newSection.settings.contentPad = {0,0,12,32}

    newSection:ApplySettings()
    newSection:UpdateHeight()

    parent:AddChild(newSection)

    return newSection
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
-- TODO: Bug atm as it only saves state when uses via minimap icon, doesnt save if window is closed by clickin on X
function bb:checkProfileWindowStatus()
    if BadBoy_data.options[GetSpecialization()][currentProfileName.."Frame"] ~= true then
        if profile_window then
            profile_window:Show()
        end
        --_G[currentProfileName.."Frame"]:Show()
        BadBoy_data.options[GetSpecialization()][currentProfileName.."Frame"] = true
    else
        if profile_window then
            profile_window.closeButton:Click()
        end
        --_G[currentProfileName.."Frame"]:Hide()
        BadBoy_data.options[GetSpecialization()][currentProfileName.."Frame"] = false
    end
end

function guit.GUI()

	window = DiesalGUI:Create('Window')
	window:SetTitle('BadBoy', 'Option Selecter')
	window.settings.width = 250
	window.settings.height = 250

	window:ApplySettings()

    local boxClassOption = createNewButton("Class Options",window)
    boxClassOption:SetEventListener("OnClick", function()
        windowClassOption = DiesalGUI:Create('Window')
        windowClassOption:SetTitle('BadBoy', 'Protection Defmaster')
        windowClassOption.settings.width = 250
        windowClassOption.settings.height = 250

        windowClassOption:ApplySettings()


        createNewCheckbox("Use emp. Rune new", 10, -10, windowClassOption)
    end)

end

--FHAugment.init()

SLASH_GUIT1 = '/guit'
function SlashCmdList.GUIT(msg, editbox)
	guit.GUI()
end

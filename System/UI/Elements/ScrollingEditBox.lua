local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalStyle = _G.LibStub("DiesalStyle-1.0")
local Colors = DiesalStyle.Colors
local _, br = ...
function br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, hideCheckbox)
    local elementOptions = br.ui.elementOptions
    -- The window page this is on (edit boxes used to be saved under it)
    local windowPage = elementOptions.windowPage(parent)
    -- Saved under the section's storage name, like every other option
    local activePage, data = elementOptions.pageData(parent)
    local key = text .. " EditBox"
    -- Move a value saved under the window page's name before this changed
    local profileSettings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
    local oldData = windowPage ~= activePage and profileSettings[windowPage] or nil
    if type(oldData) == "table" then
        if data[key] == nil and oldData[key] ~= nil then data[key] = oldData[key] end
        oldData[key] = nil
        if next(oldData) == nil then profileSettings[windowPage] = nil end
    end
    width = width or 240
    height = height or 50
    local Y = elementOptions.nextRowY(parent)
    local checkBox = br.ui:createCheckbox(parent, text, tooltip)
    if hideCheckbox then br.ui:hideCheckbox(checkBox, data[text .. " Check"]) end
    local inputStyleSheet = {
        ["frame-background"] = {
            type = "texture",
            layer = "BACKGROUND",
            color = "000000",
            alpha = .6
        },
        ["track-background"] = {
            type = "texture",
            layer = "BACKGROUND",
            color = "000000",
            alpha = .3
        },
        ["grip-background"] = {
            type = "texture",
            layer = "BACKGROUND",
            color = Colors.UI_400
        },
        ["grip-inline"] = {
            type = "outline",
            layer = "BORDER",
            color = "FFFFFF",
            alpha = .02
        },
        ["frame-outline"] = {
            type = "outline",
            layer = "BORDER",
            color = "FFFFFF",
            offset = 0
        }
    }

    local input = DiesalGUI:Create("ScrollingEditBox")
    parent:AddChild(input)
    input:SetParent(parent.content)
    input:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, Y - 14)
    input:SetStylesheet(inputStyleSheet)
    input.settings.contentPadding = { 1, 1, 1, 1 }

    br.functions.misc:registerOption(activePage, key, content)
    if data[key] == nil then
        data[key] = content
    end
    -- Listed in the UI mirror like every other option, so clean-up keeps the saved text
    elementOptions.mirror(activePage, key, data[key])
    input:SetText(data[key])
    input:SetWidth(width)
    input:SetHeight(height)
    input:SetEventListener(
        "OnTextChanged",
        function()
            local typed = input.editBox:GetText()
            data[key] = typed
            elementOptions.mirror(activePage, key, typed)
            input.settings.text = typed
        end
    )
    input:ApplySettings()
    return input, checkBox
end

function br.ui:createScrollingEditBoxWithout(parent, text, content, tooltip, width, height)
    return br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, true)
end

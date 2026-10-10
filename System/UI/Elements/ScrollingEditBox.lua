local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local DiesalStyle = _G.LibStub("DiesalStyle-1.0")
local Colors = DiesalStyle.Colors
local _, br = ...
function br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, hideCheckbox)
    -- The window page this is on (edit boxes used to be saved under it)
    local windowPage = ""
    local pageDD = parent.settings.parentObject and parent.settings.parentObject.pageDD
    if pageDD and pageDD.value and pageDD.settings and pageDD.settings.list then
        windowPage = pageDD.settings.list[pageDD.value] or ""
    end
    -- Saved under the section's storage name, like every other option
    local activePage = parent.settings.storageName or parent.settings.sectionName or windowPage
    if br.data.ui[activePage] == nil then br.data.ui[activePage] = {} end
    local profileSettings = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]
    profileSettings[activePage] = profileSettings[activePage] or {}
    local data = profileSettings[activePage]
    -- Move a value saved under the window page's name before this changed
    local oldData = windowPage ~= activePage and profileSettings[windowPage] or nil
    if type(oldData) == "table" then
        local key = text .. " EditBox"
        if data[key] == nil and oldData[key] ~= nil then data[key] = oldData[key] end
        oldData[key] = nil
        if next(oldData) == nil then profileSettings[windowPage] = nil end
    end

    -- Ensure the active page is registered in the profile PageList so
    -- option lookups (findOption) can locate values immediately.
    br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"] = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"] or {}
    local pageList = br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["PageList"]
    local found = false
    for i = 1, #pageList do
        if pageList[i] == activePage then
            found = true
            break
        end
    end
    if not found then
        br._G.tinsert(pageList, activePage)
    end

    if width == nil then
        width = 240
    end
    if height == nil then
        height = 50
    end
    -------------------------------
    ----Need to calculate Y Pos----
    -------------------------------
    local Y = -5
    for i = 1, #parent.children do
        if parent.children[i].type ~= "Spinner" and parent.children[i].type ~= "Dropdown" then
            Y = Y - parent.children[i].frame:GetHeight() * 1.2
        end
    end
    Y = DiesalTools.Round(Y)

    -------------------------------
    --------Create CheckBox--------
    -------------------------------
    local checkBox = br.ui:createCheckbox(parent, text, tooltip)
    if hideCheckbox then
        local check = data[text .. " Check"]
        if check == 0 then
            check = false
        end
        if check == 1 then
            check = true
        end
        if check == true then
            checkBox:SetChecked(false)
        end
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end
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
    -------------------------------

    ------------------------------
    --------Create input--------
    ------------------------------
    local input = DiesalGUI:Create("ScrollingEditBox")
    parent:AddChild(input)

    input:SetParent(parent.content)
    input:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, Y - 14)
    input:SetStylesheet(inputStyleSheet)

    input.settings.contentPadding = { 1, 1, 1, 1 }

    --------------
    ---BR Stuff---
    --------------
    -- Read number from config or set default
    br.functions.misc:registerOption(activePage, text .. " EditBox", content)
    if data[text .. " EditBox"] == nil then
        data[text .. " EditBox"] = content
    end
    -- Listed in the UI mirror like every other option, so clean-up keeps the saved text
    br.data.ui[activePage][text .. " EditBox"] = data[text .. " EditBox"]
    local state = data[text .. " EditBox"]
    input:SetText(state)
    input:SetWidth(width)
    input:SetHeight(height)

    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChange
    input:SetEventListener(
        "OnTextChanged",
        function()
            data[text .. " EditBox"] = input.editBox:GetText()
            br.data.ui[activePage][text .. " EditBox"] = input.editBox:GetText()
            input.settings.text = input.editBox:GetText()
        end
    )
    ----------------------
    ------END Events------
    ----------------------
    input:ApplySettings()
    ---------------------------
    --------END input--------
    ---------------------------
    return input, checkBox
end

function br.ui:createScrollingEditBoxWithout(parent, text, content, tooltip, width, height)
    return br.ui:createScrollingEditBox(parent, text, content, tooltip, width, height, true)
end

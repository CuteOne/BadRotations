local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalStyle = _G.LibStub("DiesalStyle-1.0")
local _, br = ...
-- Hides a checkbox that's only there to hold its row's spacing (text lines, and spinners, dropdowns
-- and edit boxes made without a checkbox): unticks a saved tick, disables it, and makes the whole frame
-- invisible. Disable() paints the box's own check texture grey, which releasing the style textures
-- doesn't remove, so it showed as a grey square. The frame stays in place so the layout doesn't move;
-- createCheckbox makes a reused frame visible again.
function br.ui:hideCheckbox(checkBox, savedValue)
    if savedValue == true or savedValue == 1 then checkBox:SetChecked(false) end
    checkBox:Disable()
    checkBox:ReleaseTextures()
    checkBox.frame:SetAlpha(0)
    checkBox.frame:EnableMouse(false)
end

-- checked (optional): default state for new settings. layoutOnly (optional): build the checkbox and
-- its label for spacing only, without saving or registering an option (br.ui:createText uses this).
function br.ui:createCheckbox(parent, text, tooltip, checked, layoutOnly)
    local elementOptions = br.ui.elementOptions
    -- Class Specific Color for UI Elements
    local classColor = {
        color = br.ui.colors:getColor("player").hex
    }
    local Y = elementOptions.nextRowY(parent)
    br.ui:createText(parent, text, true)

    local checkBox = DiesalGUI:Create("CheckBox")
    -- DiesalGUI reuses released checkboxes; one may have been a hidden spacer (br.ui:hideCheckbox)
    checkBox.frame:SetAlpha(1)
    checkBox.frame:EnableMouse(true)
    checkBox:SetParent(parent.content)
    checkBox:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, Y)
    checkBox:SetSettings(
        {
            height = 12,
            width = 12,
            name = text .. " Check",
        }
    )
    if layoutOnly then
        checkBox:ApplySettings()
        parent:AddChild(checkBox)
        return checkBox
    end

    local activePage, data = elementOptions.pageData(parent)
    local value = text .. " Check"
    br.functions.misc:registerOption(activePage, value, checked and true or false)
    -- New settings start at the default
    if data[value] == nil then
        data[value] = checked and true or false
    end
    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    elementOptions.mirror(activePage, value, data[value])
    local check = data[value]
    if check == true or check == 1 then
        checkBox:SetChecked(true)
    elseif check == false or check == 0 then
        checkBox:SetChecked(false)
    end

    checkBox:SetEventListener(
        "OnValueChanged",
        function(this, event, checked)
            data[value] = checked
            elementOptions.changed(activePage, value, checked)
            if checkBox.onChange then checkBox.onChange(checked) end
            -- Create Chat Overlay
            if checked then
                DiesalStyle:StyleTexture(checkBox.check, classColor)
                br.ui.chatOverlay:Show("|cff15FF00" .. text .. " Enabled")
            else
                br.ui.chatOverlay:Show("|cFFED0000" .. text .. " Disabled")
            end
        end
    )
    if tooltip then
        checkBox:SetEventListener(
            "OnEnter",
            function()
                br.game.GameTooltip:SetOwner(checkBox.frame, "ANCHOR_TOPLEFT", 0, 2)
                br.game.GameTooltip:AddLine(tooltip)
                br.game.GameTooltip:Show()
            end
        )
        checkBox:SetEventListener(
            "OnLeave",
            function()
                br.game.GameTooltip:Hide()
            end
        )
    end

    DiesalStyle:StyleTexture(checkBox.check, classColor)
    checkBox:ApplySettings()
    parent:AddChild(checkBox)
    return checkBox
end

---@class br.ui.CheckboxOptions
---@field checked? boolean Starts ticked for new settings (false)
---@field tip? string Tooltip
---@field onChange? fun(checked: boolean) Called when the player ticks or unticks it

-- The type each field takes, for elementOptions.check
---@type table<string, string>
local CHECKBOX_FIELDS = { checked = "boolean", tip = "string", onChange = "function" }

--- Adds a checkbox. Read it in the rotation with ui.checked(name).
---@param section table The section from br.ui:section
---@param name string The option's name
---@param options? br.ui.CheckboxOptions
function br.ui:checkbox(section, name, options)
    local elementOptions = br.ui.elementOptions
    if not elementOptions.ready("checkbox", section, name) then return end
    options = elementOptions.check("checkbox \"" .. name .. "\"", options, CHECKBOX_FIELDS)
    if options == nil then return end
    local checkBox = br.ui:createCheckbox(section, name, elementOptions.white(options.tip), options.checked)
    if checkBox and options.onChange then checkBox.onChange = options.onChange end
    return checkBox
end

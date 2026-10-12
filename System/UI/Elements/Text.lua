local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
function br.ui:createText(parent, text, isCheckbox)
    if isCheckbox == nil then
        isCheckbox = false
    end
    local Y = br.ui.elementOptions.nextRowY(parent)
    --------------------------------------------------
    --------Create Hidden CheckBox for Spacing--------
    --------------------------------------------------
    if not isCheckbox then -- Bypass for Checkbox element that calls this createText
        -- Older versions saved this spacer as an unticked "<text> Check" setting; remove that leftover
        -- unless a real checkbox with the same name has registered on this page
        local page = parent.settings.storageName or parent.settings.sectionName
        local pageSettings = page and br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile][page]
        local key = text .. " Check"
        local defaults = br.functions.misc:getOptionDefaults()[page]
        if pageSettings and pageSettings[key] == false and not (defaults and defaults[key] ~= nil) then
            pageSettings[key] = nil
        end
        br.ui:hideCheckbox(br.ui:createCheckbox(parent, text, "", nil, true))
    end
    ----------------------------
    --------Create Label--------
    ----------------------------
    local label = DiesalGUI:Create("FontString")

    label:SetParent(parent.content)

    parent:AddChild(label)

    label = label.fontString

    -- Ensure font is set before using the FontString
    if not label:GetFont() then
        label:SetFontObject(_G.GameFontNormal)
    end

    label:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 20, Y)
    label:SetWidth(parent.content:GetWidth() - 10)
    label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
    label:SetText(text)
    label:SetWordWrap(false)

    -------------------------
    --------END Label--------
    -------------------------

    return label
end

--- Adds a line of text (an empty string adds a gap).
---@param section table The section from br.ui:section
---@param text string
function br.ui:text(section, text)
    if not br.ui.elementOptions.ready("text", section, "text") then return end
    return br.ui:createText(section, tostring(text or ""))
end

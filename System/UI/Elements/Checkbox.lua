local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local DiesalStyle = _G.LibStub("DiesalStyle-1.0")
local _, br = ...
function br.ui:createCheckbox(parent, text, tooltip, checked)
    -- Class Specific Color for UI Elements
    local classColor = {
        color = br.classColors[select(3, br._G.UnitClass("player"))].hex
    }
    -- Option Storage Location
    -- local parent1 = parent.children[1]
    if (parent.settings.sectionName == "Cooldowns") then
        br.parent = parent
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

    ----------------------------
    --------Create Label--------
    ----------------------------
    br.ui:createText(parent, text, true)
    ----------------------------

    -------------------------------
    --------Create CheckBox--------
    -------------------------------
    local checkBox = DiesalGUI:Create("CheckBox")

    checkBox:SetParent(parent.content)
    checkBox:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, Y)
    checkBox:SetSettings(
        {
            height = 12,
            width = 12,
            name = text .. " Check",
        }
    )
    --------------
    ---BR Stuff---
    --------------
    local activePageIdx = parent.settings.parentObject.pageDD.value
    local activePage = parent.settings.parentObject.pageDD.settings.list[activePageIdx]
    br.data.settings[br.selectedSpec][br.selectedProfile][activePage] = br.data.settings[br.selectedSpec]
        [br.selectedProfile][activePage] or {}
    local data = br.data.settings[br.selectedSpec][br.selectedProfile][activePage]
    local value = text .. " Check"

    -- Read check value from config, false if nothing found
    -- Set default
    if data[value] == nil and not checked then
        data[value] = false
        if br.data.ui[activePage] ~= nil then
            br.data.ui[activePage][value] = false
        end
    end
    if data[value] == nil and checked then
        data[value] = true
        if br.data.ui[activePage] ~= nil then
            br.data.ui[activePage][value] = false
        end
    end
    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    if br.data.ui == nil then
        br.data.ui = {}
    end
    if br.data.ui[activePage] == nil then br.data.ui[activePage] = {} end
    br.data.ui[activePage][value] = data[value]

    local check = data[value]
    if check == 0 then
        check = false
    end
    if check == 1 then
        check = true
    end

    if check == false then
        checkBox:SetChecked(false)
    end
    if check == true then
        checkBox:SetChecked(true)
    end
    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChanged
    checkBox:SetEventListener(
        "OnValueChanged",
        function(this, event, checked)
            data[value] = checked
            br.data.ui[activePage][value] = checked
            -- Create Chat Overlay
            if checked then
                DiesalStyle:StyleTexture(checkBox.check, classColor)
                br.ChatOverlay("|cff15FF00" .. text .. " Enabled")
            else
                br.ChatOverlay("|cFFED0000" .. text .. " Disabled")
            end
        end
    )
    -- Event: Tooltip
    if tooltip then
        checkBox:SetEventListener(
            "OnEnter",
            function()
                br._G.GameTooltip:SetOwner(checkBox.frame, "ANCHOR_TOPLEFT", 0, 2)
                br._G.GameTooltip:AddLine(tooltip)
                br._G.GameTooltip:Show()
            end
        )
        checkBox:SetEventListener(
            "OnLeave",
            function()
                br._G.GameTooltip:Hide()
            end
        )
    end
    ----------------------
    ------END Events------
    ----------------------

    DiesalStyle:StyleTexture(checkBox.check, classColor)
    checkBox:ApplySettings()
    ----------------------------
    --------END CheckBox--------
    ----------------------------
    parent:AddChild(checkBox)

    return checkBox
end

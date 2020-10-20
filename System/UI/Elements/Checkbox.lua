local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")

function br.ui:createCheckbox(parent, text, tooltip, checked)
    -- Class Specific Color for UI Elements
    local classColor = {
        color = br.classColors[select(3,UnitClass("player"))].hex,
    }
    -------------------------------
    ----Need to calculate Y Pos----
    -------------------------------
    local Y = -5
    for i=1, #parent.children do
        if parent.children[i].type ~= "Spinner" and parent.children[i].type ~= "Dropdown" then
            Y = Y - parent.children[i].frame:GetHeight()*1.2
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
    local checkBox = DiesalGUI:Create('CheckBox')

    checkBox:SetParent(parent.content)
    checkBox:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 5, Y)
    checkBox:SetSettings({
        height 		= 12,
        width 		= 12,
    })
    --------------
    ---BR Stuff---
    --------------
    -- Read check value from config, false if nothing found
    -- Set default
    if br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"] == nil and not checked then br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"] = false end
    if br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"] == nil and checked then br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"] = true end
    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    if br.data.ui == nil then br.data.ui = {} end
    br.data.ui[text.."Check"] = br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"]

    local check = br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"]
    if check == 0 then check = false end
    if check == 1 then check = true end

    if check == false then checkBox:SetChecked(false) end
    if check == true then  checkBox:SetChecked(true) end
    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChanged
    checkBox:SetEventListener('OnValueChanged', function(this, event, checked)
        br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"] = checked
        -- Create Chat Overlay
        if checked then
            DiesalStyle:StyleTexture(checkBox.check,classColor)
            ChatOverlay("|cff15FF00"..text.." Enabled")
        else
            ChatOverlay("|cFFED0000"..text.." Disabled")
        end
    end)
    -- Event: Tooltip
    if tooltip then
        checkBox:SetEventListener("OnEnter", function()
            GameTooltip:SetOwner(checkBox.frame, "ANCHOR_TOPLEFT", 0 , 2)
            GameTooltip:AddLine(tooltip)
            GameTooltip:Show()
        end)
        checkBox:SetEventListener("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
    ----------------------
    ------END Events------
    ----------------------

    DiesalStyle:StyleTexture(checkBox.check,classColor)
    checkBox:ApplySettings()
    ----------------------------
    --------END CheckBox--------
    ----------------------------
    parent:AddChild(checkBox)

    return checkBox
end
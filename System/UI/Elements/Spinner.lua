local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalTools = LibStub("DiesalTools-1.0")

function br.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, hideCheckbox)

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

    -------------------------------
    --------Create CheckBox--------
    -------------------------------
    checkBox = br.ui:createCheckbox(parent, text, tooltip)
    if hideCheckbox then
        local check = br.data.settings[br.selectedSpec][br.selectedProfile][text.."Check"]
        if check == 0 then check = false end
        if check == 1 then check = true end
        if check == true then checkBox:SetChecked(false) end
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end
    -------------------------------

    ------------------------------
    --------Create Spinner--------
    ------------------------------
    local spinner = DiesalGUI:Create('Spinner')
    parent:AddChild(spinner)

    spinner:SetParent(parent.content)
    spinner:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, Y)
    spinner:SetSettings({
        height 			= 12,
        width 			= 29,
        mouse			= true,
        mouseWheel	    = true,
        buttons			= false,
        buttonsWidth    = 0,
        bar				= true,
        min				= min or 0,
        max				= max or 100,
        step			= step or 5,
        shiftStep		= 1,
    })
    --    spinner:AddStyleSheet(spinnerStyleSheet)

    --------------
    ---BR Stuff---
    --------------
    -- Read number from config or set default
    if br.data.settings[br.selectedSpec][br.selectedProfile][text.."Status"] == nil then br.data.settings[br.selectedSpec][br.selectedProfile][text.."Status"] = number end

    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    if br.data.ui == nil then br.data.ui = {} end
    br.data.ui[text.."Status"] = br.data.settings[br.selectedSpec][br.selectedProfile][text.."Status"]

    local state = br.data.settings[br.selectedSpec][br.selectedProfile][text.."Status"]
    spinner:SetNumber(state)

    ------------------
    ------Events------
    ------------------
    -- Event: OnValueChange
    spinner:SetEventListener('OnValueChanged', function()
        br.data.settings[br.selectedSpec][br.selectedProfile][text.."Status"] = spinner:GetNumber()
    end)
    -- Event: Tooltip
    if tooltip or tooltipSpin then
        local tooltip = tooltipSpin or tooltip
        spinner:SetEventListener("OnEnter", function()
            -- GameTooltip:SetOwner(spinner.frame, "ANCHOR_TOPLEFT", 0 , 2)
            -- GameTooltip:AddLine(tooltip)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        spinner:SetEventListener("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
    ----------------------
    ------END Events------
    ----------------------
    spinner:ApplySettings()
    ---------------------------
    --------END Spinner--------
    ---------------------------
end

function br.ui:createSpinnerWithout(parent, text, number, min, max, step, tooltip, tooltipSpin)
    return br.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, true)
end
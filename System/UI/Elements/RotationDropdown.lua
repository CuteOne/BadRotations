local DiesalGUI = LibStub("DiesalGUI-1.0")

function br.ui:createRotationDropdown(parent, itemlist, tooltip)
    local newDropdown = DiesalGUI:Create('Dropdown')
    local parent = parent
    local text = "Rotation"

    newDropdown:SetParent(parent.titleBar)
    newDropdown:SetPoint("TOPRIGHT", parent.closeButton, "TOPLEFT", 0, -2)

    newDropdown:SetList(itemlist)

    -- Set selected profile to 1 if not found

    if br.data.settings[br.selectedSpec][text.."Drop"] == nil then
        br.data.settings[br.selectedSpec][text.."Drop"] = 1
    elseif br.data.settings[br.selectedSpec][text.."Drop"] > #itemlist then
        --[[ Rest the profile which is no longer found
             If someone adds a profile then the old options from profile befopre would be loaded
        --]]
        local notFoundProfile = br.data.settings[br.selectedSpec][text.."Drop"]
        br.data.settings[br.selectedSpec][notFoundProfile] = {}

        br.data.settings[br.selectedSpec][text.."Drop"] = 1
        Print("Selected profile not found fallback to profile 1.")
    end

    if br.data.tracker ~= nil and br.data.tracker.lastProfile ~= nil then br.data.settings[br.selectedSpec][text.."Drop"] = br.data.tracker.lastProfile end
    -- Set Values
    local value = br.data.settings[br.selectedSpec][text.."Drop"]
    br.selectedProfile = value
    br.selectedProfileName = itemlist[value]
    br.settingsFile = itemlist[value] .. ".lua"
    newDropdown:SetValue(value)
    -- Load Settings for Profile
    br:loadSavedSettings()

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        if UnitAffectingCombat("player") then
            Print("Unable to change profile in combat.  Please try again when combat ends.")
        else
            -- Save Settings
            if br.data.tracker == nil then br.data.tracker = {} end
            br.data.tracker.lastProfile = key
            br:saveSettings()
            br.data.settings[br.selectedSpec][text.."Drop"] = key
            br.data.settings[br.selectedSpec][text.."DropValue"] = value
            br.data.lastProfile = key 
            br.selectedProfile = key
            br.selectedProfileName = value
        -- br.ui:recreateWindows()
        end
        br.rotationChanged = true
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

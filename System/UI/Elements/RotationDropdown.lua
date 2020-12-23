local DiesalGUI = LibStub("DiesalGUI-1.0")

function br.ui:createRotationDropdown(parent, itemlist, tooltip)
    local newDropdown = DiesalGUI:Create('Dropdown')
    local parent = parent
    local text = "Rotation"

    newDropdown:SetParent(parent.titleBar)
    newDropdown:SetPoint("TOPRIGHT", parent.closeButton, "TOPLEFT", 0, -2)

    newDropdown:SetList(itemlist)

    -- Set selected profile to 1 if not found
    -- br:loadLastProfileTracker()
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

    -- if br.data.tracker ~= nil and br.data.tracker.lastProfile ~= nil then br.data.settings[br.selectedSpec][text.."Drop"] = br.data.tracker.lastProfile end
    -- Set Values
    local value = br.data.settings[br.selectedSpec][text.."Drop"]
    br.selectedProfile = value
    br.selectedProfileName = itemlist[value]
    br.settingsFile = itemlist[value] .. ".lua"
    newDropdown:SetValue(value)
    -- br.ui:loadWindowPositions("config")
    -- br.ui:loadWindowPositions("profile")

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        if UnitAffectingCombat("player") then
            Print("Unable to change profile in combat.  Please try again when combat ends.")
        else
            -- Print("Rotation Changed")
            br:saveSettings(nil,nil,br.selectedSpec,br.selectedProfileName)
            br:saveLastProfileTracker()
            br.data.settings[br.selectedSpec][text.."Drop"] = key
            br.data.tracker[br.selectedSpec][text..'Drop'] = key
            br.data.settings[br.selectedSpec][text.."DropValue"] = value
            br.data.tracker[br.selectedSpec][text..'DropValue'] = value
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

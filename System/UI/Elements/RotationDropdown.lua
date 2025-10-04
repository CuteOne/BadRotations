local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
function br.ui:createRotationDropdown(parent, itemlist, tooltip)
    local newDropdown = DiesalGUI:Create("Dropdown")
    local parent = parent
    local text = "Rotation"

    newDropdown:SetParent(parent.titleBar)
    newDropdown:SetPoint("TOPRIGHT", parent.closeButton, "TOPLEFT", 0, -2)

    newDropdown:SetList(itemlist)

    -- Set selected profile to 1 if not found
    -- br:loadLastProfileTracker()
    if br.data.settings[br.loader.selectedSpec][text .. "Drop"] == nil then
        br.data.settings[br.loader.selectedSpec][text .. "Drop"] = 1
    elseif br.data.settings[br.loader.selectedSpec][text .. "Drop"] > #itemlist then
        --[[ Rest the profile which is no longer found
             If someone adds a profile then the old options from profile befopre would be loaded
        --]]
        local notFoundProfile = br.data.settings[br.loader.selectedSpec][text .. "Drop"]
        br.data.settings[br.loader.selectedSpec][notFoundProfile] = {}

        br.data.settings[br.loader.selectedSpec][text .. "Drop"] = 1
        br._G.print("Selected profile not found fallback to profile 1.")
    end

    -- if br.data.tracker ~= nil and br.data.tracker.lastProfile ~= nil then br.data.settings[br.loader.selectedSpec][text.."Drop"] = br.data.tracker.lastProfile end
    -- Set Values
    local value = br.data.settings[br.loader.selectedSpec][text .. "Drop"]
    br.loader.selectedProfile = value
    br.loader.selectedProfileName = itemlist[value]
    br.loader.settingsFile = itemlist[value] .. ".lua"
    newDropdown:SetValue(value)
    -- br.ui:loadWindowPositions("config")
    -- br.ui:loadWindowPositions("profile")

    newDropdown:SetEventListener(
        "OnValueChanged",
        function(this, event, key, value, selection)
            if br._G.UnitAffectingCombat("player") then
                br._G.print("Unable to change profile in combat.  Please try again when combat ends.")
            else
                -- br.ui:recreateWindows()
                -- br._G.print("Rotation Changed")
                br.settingsManagement:saveSettings(nil, nil, br.loader.selectedSpec, br.loader.selectedProfileName)
                br:saveLastProfileTracker()
                br.data.settings[br.loader.selectedSpec][text .. "Drop"] = key
                br.data.tracker[br.loader.selectedSpec][text .. "Drop"] = key
                br.data.settings[br.loader.selectedSpec][text .. "DropValue"] = value
                br.data.tracker[br.loader.selectedSpec][text .. "DropValue"] = value
                br.data.lastProfile = key
                br.loader.selectedProfile = key
                br.loader.selectedProfileName = value
            end
            br.rotationChanged = true
        end
    )
    -- Event: Tooltip
    if tooltip then
        newDropdown:SetEventListener(
            "OnEnter",
            function(this, event)
                br._G.GameTooltip:SetOwner(br._G.Minimap, "ANCHOR_CURSOR", 50, 50)
                br._G.GameTooltip:SetText(tooltip, 214 / 255, 25 / 255, 25 / 255)
                br._G.GameTooltip:Show()
            end
        )
        newDropdown:SetEventListener(
            "OnLeave",
            function(this, event)
                br._G.GameTooltip:Hide()
            end
        )
    end
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    return newDropdown
end

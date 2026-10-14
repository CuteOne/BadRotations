local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local _, br = ...
function br.ui:createRotationDropdown(parent, itemlist, tooltip)
    local newDropdown = DiesalGUI:Create("Dropdown")
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
        br.log:warning("Selected profile not found, falling back to profile 1.")
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
                br.log:warning("Unable to change profile in combat. Please try again when combat ends.")
            else
                -- Save the current profile before switching (saving after would write it into the new one)
                br.ui.settingsManagement:saveIfLoaded(true)
                br.data.settings[br.loader.selectedSpec][text .. "Drop"] = key
                br.data.settings[br.loader.selectedSpec][text .. "DropValue"] = value
                br.data.lastProfile = key
                br.loader.selectedProfile = key
                br.loader.selectedProfileName = value
                br.ui.settingsManagement:saveSelection()
                br.loader.bootstrap:reloadProfile()
            end
        end
    )
    if tooltip then br.ui.elementOptions.cursorTooltip(newDropdown, tooltip) end

    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    return newDropdown
end

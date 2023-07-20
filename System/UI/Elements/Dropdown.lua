local DiesalGUI = _G.LibStub("DiesalGUI-1.0")
local DiesalTools = _G.LibStub("DiesalTools-1.0")
local _, br = ...
function br.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, hideCheckbox)
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
        local check = br.data.settings[br.selectedSpec][br.selectedProfile][text .. "Check"]
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
    -------------------------------

    -------------------------------
    --------Create Dropdown--------
    -------------------------------
    local newDropdown = DiesalGUI:Create("Dropdown")
    local default = default or 1
    parent:AddChild(newDropdown)

    newDropdown:SetParent(parent.content)
    newDropdown:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, Y)
    newDropdown:SetHeight(12)
    newDropdown:SetList(itemlist)

    --------------
    ---BR Stuff---
    --------------
    -- Read from config or set default
    if br.data.settings[br.selectedSpec][br.selectedProfile][text .. "Drop"] == nil then
        br.data.settings[br.selectedSpec][br.selectedProfile][text .. "Drop"] = default
    end

    -- Add to UI Settings **Do not comment out or remove, will result in loss of settings**
    if br.data.ui == nil then
        br.data.ui = {}
    end
    br.data.ui[text .. "Drop"] = br.data.settings[br.selectedSpec][br.selectedProfile][text .. "Drop"]

    local value = br.data.settings[br.selectedSpec][br.selectedProfile][text .. "Drop"]
    newDropdown:SetValue(value)

    ------------------
    ------Events------
    ------------------
    -- Event: OnClick
    local main_window = parent.content
    if main_window:GetParent() ~= UIParent then
        repeat
            main_window = main_window:GetParent()
        until main_window:GetParent() == nil or main_window:GetParent() == UIParent
    end

    local strata = newDropdown.dropdown:GetFrameStrata()
    newDropdown:SetEventListener("OnClick", function(self, event, ...)
        if self.dropdown:IsShown() then
            strata = self.dropdown:GetFrameStrata()
            self.dropdown:SetParent(main_window)
            self.dropdown:SetFrameStrata("HIGH")
        else
            self.dropdown:SetParent(self.frame)
            self.dropdown:SetFrameStrata(strata)
        end
    end)
    
    -- Event: OnValueChange
    newDropdown:SetEventListener(
        "OnValueChanged",
        function(this, event, key, value, selection)
            br.data.settings[br.selectedSpec][br.selectedProfile][text .. "Drop"] = key
        end
    )
    -- Event: Tooltip
    if tooltip or tooltipDrop then
        local tooltip = tooltipDrop or tooltip
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

    ----------------------
    ------END Events------
    ----------------------
    newDropdown:ApplySettings()
    ----------------------------
    --------END Dropdown--------
    ----------------------------

    return newDropdown, checkBox
end

function br.ui:createDropdownWithout(parent, text, itemlist, default, tooltip, tooltipDrop)
    return br.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, true)
end

function br.ui:createProfileDropdown(parent)
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

    local profiles = br.fetch(br.selectedSpec .. "_" .. "profiles", {{key = "default", text = "Default"}})
    -- local selectedProfile = br.fetch(br.selectedSpec .. "_" .. "profile", "default")
    local profile_drop = DiesalGUI:Create("Dropdown")
    parent:AddChild(profile_drop)
    profile_drop:SetParent(parent.content)
    profile_drop:SetPoint("TOPLEFT", parent.content, "TOPLEFT", 1, Y)
    profile_drop:SetHeight(18)
    profile_drop:SetWidth(200)
    local list = {}
    for i, value in pairs(profiles) do
        list[value.key] = value.key
    end
    profile_drop:SetList(list)
    profile_drop:SetValue(br.fetch(br.selectedSpec .. "_" .. "profile", "Default Profile"))
    profile_drop:SetEventListener(
        "OnValueChanged",
        function(this, event, key, value, selection)
            br.profileDropValue = key
        end
    )
end

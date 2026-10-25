local _, br = ...
--- Profile UI
-- Builds the profile options window (Base Options + the rotation's own pages) and the toggle
-- bar, and copies toggle states into ui.mode each tick. br.player keeps createOptions /
-- createToggles / getToggleModes / createBaseOptions as forwards (Core calls them).
br.loader.profileUI = br.loader.profileUI or {}
local profileUI = br.loader.profileUI

local rotationNames = {}

--- Creates the "Base Options" page shared by every profile.
-- @param player br.player
function profileUI:createBaseOptions(player)
    -- Sections created on this page are stored as "Base Options/<section>" (shared by all profiles)
    br.ui.sectionStoragePrefix = "Base Options/"
    local ok, err = pcall(profileUI.buildBaseOptionsPage, profileUI, player)
    br.ui.sectionStoragePrefix = nil
    if not ok then br.log:reportError(err) end
end

function profileUI:buildBaseOptionsPage(player)
    -----------------
    --- Base Wrap ---
    -----------------
    local section_base = br.ui:section("Base Options")
    br.ui:checkbox(section_base, "Ignore Combat", { tip = "Checking this will make BR think it is always in combat" })
    br.ui:checkbox(section_base, "Mute Queue", { tip = "Mute messages from Smart Queue and Queue Casting" })
    br.ui:dropdown(section_base, "Pause Mode", { choices = "Toggle", value = "LeftShift", tip = "Define a key which pauses the rotation." })
    -------------------
    --- Module Wrap ---
    -------------------
    -- Each module only creates options that apply to this WoW flavor, race and class.
    local section_module = br.ui:section("Module Options")
    br.ui:text(section_module, "|cffff0000Overridden by modules used")
    br.ui:text(section_module, "|cffff0000in Rotation Options")
    br.ui:text(section_module, "===General Options===")
    player.module.autoKeystone(section_module) -- Retail
    player.module.Racial(section_module)
    player.module.TwoForms(section_module) -- Worgen
    br.ui:text(section_module, "===Healing Options===")
    player.module.BasicHealing(section_module)
    br.ui:text(section_module, "===Combat Options===")
    player.module.CombatPotionUp(section_module) -- Mists of Pandaria
    if br.isMOP then -- checked here too, so the primary stat (secret in combat on Forever) is only read on MoP
        player.module.FlaskUp(br.functions.unit:getPrimaryStat(), section_module) -- Mists of Pandaria
    end
    player.module.BasicTrinkets(nil, section_module)
end

--- Creates the profile options window: rotation dropdown, Base Options, and the rotation's pages.
-- @param player br.player
-- @param spec Spec ID
function profileUI:createOptions(player, spec)
    local specSettings = br.data.settings[br.loader.selectedSpec]
    if specSettings[br.loader.selectedProfile] == nil then specSettings[br.loader.selectedProfile] = {} end
    br.ui:createProfileWindow(player.specName)

    -- Rotation dropdown with the names of every profile for this spec
    br._G.wipe(rotationNames)
    for i = 1, #br.loader.rotations[spec] do
        br._G.tinsert(rotationNames, br.loader.rotations[spec][i].name)
    end
    br.ui.window.profile.rotationDD = br.ui:createRotationDropdown(br.ui.window.profile.parent, rotationNames)

    -- Base Options first, then the pages the rotation defines
    local optionTable = {
        {
            [1] = "Base Options",
            [2] = function() profileUI:createBaseOptions(player) end,
        },
    }
    br.functions.custom:insertTableIntoTable(optionTable, profileUI:rotationPages(player.rotation.options))

    br.ui:createPagesDropdown(br.ui.window.profile, optionTable)
    br.ui:checkWindowStatus("profile")
    profileUI:checkDropdowns("built") -- TEMP diagnostic
end

-- TEMP diagnostic: the profile window's dropdowns showed no text (Anniversary 2026-10-25). Session.log
-- gets what each dropdown holds right after the window is built, 2 s later and whenever it's shown.
local function describeDropdown(label, dropdown)
    if dropdown == nil then return label .. " missing" end
    local fontString = dropdown.text
    local text = fontString and fontString:GetText()
    local font, size = nil, nil
    if fontString then font, size = fontString:GetFont() end
    local list = dropdown.settings and dropdown.settings.list
    local listCount = 0
    if type(list) == "table" then for _ in pairs(list) do listCount = listCount + 1 end end
    local selected
    for _, item in ipairs(dropdown.children or {}) do
        if item.settings and item.settings.selected then selected = tostring(item.settings.key) .. "=" .. tostring(item.settings.value) end
    end
    return ("%s: text %q, font %s %s, items %d, list %d, selected %s, shown %s"):format(label, tostring(text),
        tostring(font), tostring(size), #(dropdown.children or {}), listCount, tostring(selected),
        tostring(dropdown.frame and dropdown.frame:IsVisible()))
end

function profileUI:checkDropdowns(when)
    local function note()
        local profile, config = br.ui.window.profile, br.ui.window.config
        br.log.session:note("UI check (" .. when .. "): " .. describeDropdown("profile pages", profile and profile.pageDD)
            .. " | " .. describeDropdown("profile rotation", profile and profile.rotationDD)
            .. " | " .. describeDropdown("config pages", config and config.pageDD))
    end
    note()
    br._G.C_Timer.After(2, function() when = when .. " +2s"; note() end)
    local parent = br.ui.window.profile and br.ui.window.profile.parent
    if parent and parent.frame and not parent.diagnosticHooked then
        parent.diagnosticHooked = true
        parent.frame:HookScript("OnShow", function() profileUI:checkDropdowns("shown") end)
    end
end

--- The rotation's option pages as { { page name, build function } }. options is the function that
-- builds the "Rotation Options" page, or a list of { page name, build function } for several pages.
-- Each page restores its last br.ui:section's state; the first also gets the Toggle Keys section
-- for toggles made with br.ui:toggle.
-- @param options the rotation's options (function, table or nil)
function profileUI:rotationPages(options)
    local pages = {}
    if type(options) == "table" then
        pages = options
    elseif type(options) == "function" then
        pages = { { "Rotation Options", options } }
    end
    local result = {}
    for i, page in ipairs(pages) do
        local build, withKeys = page[2], i == 1
        result[i] = {
            [1] = page[1],
            [2] = function()
                local ok, result = pcall(build)
                br.ui:closeSection()
                if withKeys then br.ui:toggleKeys() end
                if not ok then error(result, 0) end
                -- The old createOptions style returned its pages instead of building one
                if type(result) == "table" then
                    br.log:error(tostring(br.loader.selectedProfileName) .. ": options should build the page"
                        .. " (br.ui:section, br.ui:checkbox, ...) or be a list of pages, not return pages - see Rotations/sample rotation.lua")
                end
            end,
        }
    end
    if #result == 0 and br.ui:hasToggleKeys() then
        result[1] = { [1] = "Toggle Keys", [2] = function() br.ui:toggleKeys() end }
    end
    return result
end

--- Creates the toggle bar defined by the rotation (br.ui:toggle or br.ui:createToggle calls).
-- @param player br.player
function profileUI:createToggles(player)
    br.ui:GarbageButtons()
    br.ui:forgetToggles()
    if player.rotation ~= nil and player.rotation.toggles ~= nil then
        player.rotation.toggles()
    end
end

--- Copies each saved toggle state into ui.mode (e.g. "Rotation" -> ui.mode.rotation) and
-- refreshes the toggle buttons.
-- @param player br.player
-- ui.mode names by toggle name ("Rotation" -> "rotation")
local modeNames = setmetatable({}, { __index = function(t, k)
    local name = k:sub(1, 1):lower() .. k:sub(2)
    t[k] = name
    return name
end })

function profileUI:updateToggleModes(player)
    local toggles = br.data.settings[br.loader.selectedSpec].toggles
    local made = br.ui.toggles.modes
    for k, value in pairs(toggles) do
        player.ui.mode[modeNames[k]] = value
        -- Only toggles the profile made have a key option and a button to cycle
        if made[k] then br.functions.misc:UpdateToggle(k, 0.25) end
    end
end

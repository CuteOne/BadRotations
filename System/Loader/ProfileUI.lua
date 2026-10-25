local _, br = ...
--- Profile UI
-- Builds the profile options window (Base Options + the rotation's own pages) and the toggle
-- bar, and copies toggle states into ui.mode each tick. br.rotation keeps createOptions /
-- createToggles / getToggleModes as forwards (Bootstrap and the tick call them).
br.loader.profileUI = br.loader.profileUI or {}
local profileUI = br.loader.profileUI

local rotationNames = {}

--- Creates the "Base Options" page shared by every profile.
function profileUI:createBaseOptions()
    -- Sections created on this page are stored as "Base Options/<section>" (shared by all profiles)
    br.ui.sectionStoragePrefix = "Base Options/"
    local ok, err = pcall(profileUI.buildBaseOptionsPage, profileUI)
    br.ui.sectionStoragePrefix = nil
    if not ok then br.log:reportError(err) end
end

function profileUI:buildBaseOptionsPage()
    local module = br.api.profile.module
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
    module.autoKeystone(section_module) -- Retail
    module.Racial(section_module)
    module.TwoForms(section_module) -- Worgen
    br.ui:text(section_module, "===Healing Options===")
    module.BasicHealing(section_module)
    br.ui:text(section_module, "===Combat Options===")
    module.CombatPotionUp(section_module) -- Mists of Pandaria
    if br.client.isMOP then -- checked here too, so the primary stat (secret in combat on Forever) is only read on MoP
        module.FlaskUp(br.functions.unit:getPrimaryStat(), section_module) -- Mists of Pandaria
    end
    module.BasicTrinkets(nil, section_module)
end

--- Creates the profile options window: rotation dropdown, Base Options, and the rotation's pages.
-- @param rotation br.rotation
-- @param spec Spec ID
function profileUI:createOptions(rotation, spec)
    local specSettings = br.data.settings[br.loader.selectedSpec]
    if specSettings[br.loader.selectedProfile] == nil then specSettings[br.loader.selectedProfile] = {} end
    br.ui:createProfileWindow(rotation.specName)

    -- Rotation dropdown with the names of every profile for this spec
    br.game.wipe(rotationNames)
    for i = 1, #br.loader.rotations[spec] do
        br.game.tinsert(rotationNames, br.loader.rotations[spec][i].name)
    end
    br.ui.window.profile.rotationDD = br.ui:createRotationDropdown(br.ui.window.profile.parent, rotationNames)

    -- Base Options first, then the pages the rotation defines
    local optionTable = {
        {
            [1] = "Base Options",
            [2] = function() profileUI:createBaseOptions() end,
        },
    }
    br.functions.custom:insertTableIntoTable(optionTable, profileUI:rotationPages(rotation.selected.options))

    br.ui:createPagesDropdown(br.ui.window.profile, optionTable)
    br.ui:checkWindowStatus("profile")
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
-- @param rotation br.rotation
function profileUI:createToggles(rotation)
    br.ui:GarbageButtons()
    br.ui:forgetToggles()
    if rotation.selected.toggles ~= nil then
        rotation.selected.toggles()
    end
end

--- Copies each saved toggle state into ui.mode (e.g. "Rotation" -> ui.mode.rotation) and
-- refreshes the toggle buttons.
-- ui.mode names by toggle name ("Rotation" -> "rotation")
local modeNames = setmetatable({}, { __index = function(t, k)
    local name = k:sub(1, 1):lower() .. k:sub(2)
    t[k] = name
    return name
end })

function profileUI:updateToggleModes()
    local toggles = br.data.settings[br.loader.selectedSpec].toggles
    local made = br.ui.toggles.modes
    local mode = br.api.profile.ui.mode
    for k, value in pairs(toggles) do
        mode[modeNames[k]] = value
        -- Only toggles the profile made have a key option and a button to cycle
        if made[k] then br.functions.misc:UpdateToggle(k, 0.25) end
    end
end

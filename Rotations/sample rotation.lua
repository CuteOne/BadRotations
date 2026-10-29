-- A profile sees the profile API by name, and nothing else: cast, buff, debuff, cd, charges, unit, units,
-- enemies, ui, module, power, talent, spell, has, use, equiped, pet, totem, glyph, heroTree, imbues and
-- var (all in System/API), plus registerRotation, loadSupport and Lua's standard library. There is no
-- br and no game API; reading any other name, or setting a global, is an error that names the line.
-- Keep your own names local.
--   var        keeps values between ticks, is shared with the support files you load, and starts empty
--              for each spec
--   loadSupport("PetCuteOne") runs Rotations/<Class>/Support/PetCuteOne.lua and returns what it returns
--
-- Debugging: tick Bot Options > Debug Options > Addon Debug Messages (All) and set Debug Level to
-- Developer. Chat then shows idle stretches ([IDLE]), spells you've learned but never cast ([UNUSED]),
-- a line per fight ([FIGHT]) and casts the game refused. /br why <spell> says why BR last refused a
-- spell; the Rotation Log option lists every cast. More in AGENTS.md, "Debugging a Profile".

---------------
--- Toggles ---
---------------
-- The buttons on the toggle bar. ui.toggle(name, { modes = { ... } }) adds one; each click moves
-- to the next mode and the first mode is the default. Read the current mode in the rotation with
-- ui.mode.<name>, e.g. ui.mode.rotation == 1 for "Auto".
-- key (optional) is a keybind that also cycles the toggle; BR lists it in a "Toggle Keys" section.
-- Every field (icon, overlay, tip, highlight, row, col, ...) is described in
-- System/UI/Toggles/ToggleFunctions.lua.
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "whirlwind",           overlay = "Automatic Rotation",       tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Mult", icon = "bladestorm",          overlay = "Multiple Target Rotation", tip = "Multiple target rotation used." },
        { name = "Sing", icon = "ragingBlow",          overlay = "Single Target Rotation",   tip = "Single target rotation used." },
        { name = "Off",  icon = "enragedRegeneration", overlay = "DPS Rotation Disabled",    tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "recklessness", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On",   icon = "recklessness", overlay = "Cooldowns Enabled",   tip = "Cooldowns used regardless of target." },
        { name = "Off",  icon = "recklessness", overlay = "Cooldowns Disabled",  tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On",  icon = "enragedRegeneration", overlay = "Defensive Enabled",  tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "enragedRegeneration", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On",  icon = "pummel", overlay = "Interrupts Enabled",  tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "pummel", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
end

---------------
--- Options ---
---------------
-- The Rotation Options page. ui.section(name) starts a collapsible group and returns it; pass it
-- to each option after it. Each option takes the section, its name, then only the settings you want
-- to change from the defaults:
--   ui.checkbox(section, name, { checked, tip })
--   ui.spinner(section, name, { value, min, max, step, checkbox, checked, tip, boxTip })
--   ui.dropdown(section, name, { choices, value, checkbox, checked, tip, boxTip })
--   ui.doubleSpinner(section, name, { first = { value, ... }, second = { value, ... }, checkbox, checked })
--   ui.text(section, text)
-- Spinners and dropdowns have a checkbox in front of them unless checkbox = false; checked = true
-- starts a checkbox ticked. Every field and its default is described in System/UI/Elements.
-- Read them in the rotation with ui.checked("Name") and ui.value("Name").
-- Module options (e.g. module.BasicHealing(section)) can go between these. For more than one page,
-- make options a list instead:
--   local options = { { "Page Name", buildFunction }, { "Other Page", otherFunction } }
local function options()
    local section = ui.section("General")
    ui.checkbox(section, "Example Checkbox", { tip = "Ticked or not - read with ui.checked(\"Example Checkbox\")" })

    section = ui.section("Cooldowns")
    ui.dropdown(section, "Example Cooldown", { choices = "AlwaysCdNever", value = "Cooldowns", checkbox = false,
        tip = "When to use it - read with ui.value(\"Example Cooldown\") (1 = Always, 2 = Cooldowns, 3 = Never)" })

    section = ui.section("Defensive")
    ui.spinner(section, "Example Defensive", { value = 40, checked = true, tip = "Health Percent to Cast At" })

    section = ui.section("Interrupts")
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- Any variables/functions made should have a local here (profiles can't set globals).


-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- OPTIONAL: a target weight — bias the automatic target scorer without editing core code.
-- Return a positive number to raise a unit's priority, negative to lower it, nil to leave unchanged.
-- Example: prefer targets that already have a debuff on them (set it once, in runRotation).
-- units.setTargetWeight(function(thisUnit)
--     if debuff.someDebuff.exists(thisUnit) then return 2.0 end
-- end)

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.
-- Action List - Extra
actionList.Extra = function()

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()

end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()

end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and unit.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull
        if unit.valid("target") then -- Abilities below this only used when target is valid
            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40

    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(40) -- Makes a varaible called, enemies.yards40

    ------------------------
    --- Custom Variables ---
    ------------------------
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else -- Profile is free to perform actions
        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end -- This runs the Extra Action List and anything in it will run in or out of combat, this generally contains utility functions.
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
        -----------------
        --- In Combat ---
        -----------------
        if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
            ------------------
            --- Interrupts ---
            ------------------
            if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
            ------------
            --- Main ---
            ------------
            -- Start Attack - This will start auto attacking your target if it's within 5yrds and valid
            if unit.distance("target") <= 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
-------------------------
--- REGISTER ROTATION ---
-------------------------
-- Registers this profile with BadRotations. Any .lua file in Rotations/<Class>/<Spec>/ (or
-- Rotations/<Class>/<Class>/ on expansions without specs) is loaded automatically; BR offers the
-- rotation only when specID and expansion match the player.
registerRotation({
    name      = "MyProfile",    -- Shown in the rotation dropdown; must be unique for the spec
    specID    = 000,            -- Spec ID(s) this is for: https://wowpedia.fandom.com/wiki/SpecializationID
                                -- (a list like { 103, 104 } also works)
    expansion = "Retail",       -- One of "Retail", "MOP", "TBC", "Classic" or "Forever"
    author    = "YourName",     -- Optional: shown in README.md
    -- actsWhileCasting = true, -- Optional: keep running while casting or channelling (BR pauses otherwise)
    -- handlesRacials = true,   -- Optional: the rotation uses racials itself (the shared Racial module doesn't)
    -- handlesTrinkets = true,  -- Optional: the rotation uses trinkets itself (the shared Trinkets module doesn't)
    toggles   = toggles,        -- The toggles function above
    options   = options,        -- The options function above (or a list of pages)
    run       = runRotation,
})

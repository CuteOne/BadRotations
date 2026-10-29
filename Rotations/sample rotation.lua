-- Sample rotation: the starting point for a profile of your own.
--   1. Copy this file into Rotations/<Class>/<Spec>/ (on clients without specializations,
--      Rotations/<Class>/<Class>/) and give it your own file name.
--   2. At the bottom, set name, specID and expansion. BR then lists it in the rotation dropdown.
--   3. Fill in the action lists with your class's spells, then /reload in game to try each change.
-- "Writing a profile.md", next to this file, walks through every part.
--
-- Spell names: cast.<name>(), buff.<name>.exists() and so on use the names in your class's spell
-- list, Expansions/<Version>/<CLASS>/ (Global.lua next to those folders has the ones every class
-- shares, such as autoAttack). Your editor completes them if you open the BadRotations folder with
-- the Lua extension (see Types/).

---------------
--- Toggles ---
---------------
-- The buttons on the toggle bar. Each click moves to the next mode; the first mode is the default.
-- Keep these four names and the order of their modes: BR's helpers (ui.useAOE, ui.useCDs,
-- ui.useDefensive, ui.useInterrupt) and the shared Base Options read them. Add your own below them.
-- icon: a spell name from your class's list (icon = "fireball") or any spell ID.
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = 1680, tip = "Single target or AoE, by the number of enemies around you." },
        { name = "Mult", icon = 1680, tip = "Always the AoE rotation." },
        { name = "Sing", icon = 1680, tip = "Always the single target rotation." },
        { name = "Off",  icon = 1680, tip = "The rotation does nothing." },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = 1719, tip = "Cooldowns on bosses only." },
        { name = "On",   icon = 1719, tip = "Cooldowns on any target." },
        { name = "Off",  icon = 1719, tip = "No cooldowns." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On",  icon = 871, tip = "Use defensive abilities." },
        { name = "Off", icon = 871, tip = "No defensive abilities." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On",  icon = 6552, tip = "Interrupt enemy casts." },
        { name = "Off", icon = 6552, tip = "No interrupts." },
    } })
end

---------------
--- Options ---
---------------
-- The Rotation Options page. ui.section starts a group; each option after it takes the section,
-- its name, and only the settings you want to change. Read them in the rotation with
-- ui.checked("Name") (its checkbox) and ui.value("Name") (its number or dropdown choice).
local function options()
    local section = ui.section("General")
    ui.spinner(section, "Pre-Pull Timer", { value = 5, min = 1, max = 10, tip = "Seconds left on a boss mod pull timer to start your opener." })

    section = ui.section("Cooldowns")
    ui.dropdown(section, "Example Cooldown", { choices = "AlwaysCdNever", value = "Cooldowns", checkbox = false,
        tip = "When to use it: always, only when the Cooldown toggle allows, or never." })

    section = ui.section("Defensive")
    ui.spinner(section, "Example Defensive", { value = 40, checked = true, tip = "Your health percent to use it at." })

    section = ui.section("Interrupts")
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "How far into the enemy's cast, in percent (0 = random)." })
end

--------------
--- Locals ---
--------------
-- A profile can't create globals: declare every name of your own as local, here or in a function.
local enemy -- the enemy the rotation acts on this tick (set in runRotation)

--------------------
--- Action Lists ---
--------------------
-- Each list tries its casts in order. A cast returns true when BR sends it; return true straight
-- away, so BR does one thing per tick and starts again from the top next tick.
-- The commented casts are examples: replace them with your class's spells.
local actionList = {}

actionList.Defensive = function()
    if not ui.useDefensive() then return end
    if ui.checked("Example Defensive") and unit.hp() <= ui.value("Example Defensive") then
        -- if cast.shieldWall() then return true end
    end
end

actionList.Interrupt = function()
    if not ui.useInterrupt() then return end
    if unit.interruptable(enemy, ui.value("Interrupt At")) then
        -- if cast.pummel(enemy) then return true end
    end
end

actionList.Cooldown = function()
    if ui.alwaysCdNever("Example Cooldown") then
        -- if cast.recklessness() then return true end
    end
end

actionList.PreCombat = function()
    if unit.inCombat() then return end
    -- A boss mod (DBM, BigWigs) pull timer is nearly done: start the fight on time
    if ui.checked("Pre-Pull Timer") and unit.pullTimer() <= ui.value("Pre-Pull Timer") then
        -- if cast.charge(enemy) then return true end
    end
end

actionList.Combat = function()
    -- AoE: true on Mult, or on Auto with 3 or more enemies within 8 yards
    if ui.useAOE(8, 3) then
        -- if cast.whirlwind() then return true end
    end
    -- Single target
    -- if cast.heroicStrike(enemy) then return true end
    -- Melee: start auto attack once in range (cast.auto tells whether it is already on)
    if unit.distance(enemy) < 5 and not cast.auto.autoAttack() then
        if cast.autoAttack(enemy) then return true end
    end
end

----------------
--- Rotation ---
----------------
-- BR runs this many times a second. It doesn't run while BR is paused or you are mounted, on a taxi
-- or dead, so the rotation needn't check for those.
local function runRotation()
    -- The best enemy within 40 yards (BR's pick; see Targeting in Bot Options), or nil. Use
    -- units.get(5) for one in melee range.
    enemy = units.get(40)

    if ui.mode.rotation == 4 then return end -- the Rotation toggle is Off

    if actionList.Defensive() then return true end
    if actionList.PreCombat() then return true end
    if unit.inCombat() and enemy then
        if actionList.Interrupt() then return true end
        if ui.useCDs() and actionList.Cooldown() then return true end
        if actionList.Combat() then return true end
    end
end

-------------------------
--- Register Rotation ---
-------------------------
-- BR loads every .lua file in the spec's folder and offers this rotation when the specID and
-- expansion match your character.
registerRotation({
    name      = "MyProfile",    -- Shown in the rotation dropdown; unique for the spec
    specID    = 000,            -- Your spec's ID (000 keeps the sample switched off):
                                -- https://warcraft.wiki.gg/wiki/SpecializationID
    expansion = "Retail",       -- One of "Retail", "MOP", "TBC", "Classic" or "Forever"
    author    = "YourName",     -- Optional: shown in README.md
    toggles   = toggles,
    options   = options,
    run       = runRotation,
    -- Optional:
    -- actsWhileCasting = true, -- keep running while you cast or channel (BR waits otherwise)
    -- handlesRacials = true,   -- the rotation uses racials itself (Base Options' racial doesn't)
    -- handlesTrinkets = true,  -- the rotation uses trinkets itself (Base Options' trinkets don't)
})

-- Sample rotation: a starting point for a profile of your own.
-- Lines starting with two dashes (--) are notes like this one; the game skips them.
-- "Writing a profile.md", next to this file, explains every part step by step. Start there if
-- you haven't written Lua before.
--
-- To use it:
--   1. Copy this file into the folder for your class and spec, Rotations/<Class>/<Spec>/ (for the
--      game versions without specs, Rotations/<Class>/<Class>/), and rename the copy.
--   2. At the bottom of the file, fill in name, specID and expansion.
--   3. In game, type /reload. Your profile is now in the rotation list in BR's options.
--   4. Fill in the action lists below with your class's spells, and /reload after each change.

---------------
--- Toggles ---
---------------
-- The buttons on BR's toggle bar. Each click on a button moves it to its next mode; the first mode
-- is where it starts. (Guide: "Toggles")
-- Keep these four buttons as they are: BR reads them by these names and in this order. You can add
-- buttons of your own after them.
-- icon: a spell's ID number (any spell), or a spell name from your class's spell list.
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
-- The settings players can change on the "Rotation Options" page. (Guide: "Options")
-- ui.section starts a group. Each option names its group, its own name, and any settings that
-- differ from the usual (its starting value, a tip, ...). In the rotation, ui.checked("Name") says
-- whether its box is ticked, and ui.value("Name") gives its number or dropdown choice.
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

-------------------------
--- Your own values ---
-------------------------
-- Names you make up to keep a value start with the word local, the first time you use them.
-- (Guide: "Lua in five minutes")
local enemy -- the enemy the rotation attacks right now (set in runRotation below)

--------------------
--- Action Lists ---
--------------------
-- What to cast, in order of priority: BR tries each line from the top, and the first spell that
-- can be cast right now is cast. (Guide: "Action lists")
--   if cast.shieldWall() then return true end
-- means "cast Shield Wall if you can; if it was cast, stop here". BR does one thing at a time and
-- starts again from the top a moment later.
-- The examples below are switched off. To use one, remove the -- in front of it and put your
-- class's spell in place of the example spell.
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
    -- A boss mod (DBM, BigWigs) pull countdown is nearly done: start the fight on time
    if ui.checked("Pre-Pull Timer") and unit.pullTimer() <= ui.value("Pre-Pull Timer") then
        -- if cast.charge(enemy) then return true end
    end
end

actionList.Combat = function()
    -- Several enemies: the Rotation toggle is on Mult, or on Auto with 3 or more enemies within 8 yards
    if ui.useAOE(8, 3) then
        -- if cast.whirlwind() then return true end
    end
    -- One enemy
    -- if cast.heroicStrike(enemy) then return true end
    -- Melee classes: start auto attack once in range, unless it is already on
    if unit.distance(enemy) < 5 and not cast.auto.autoAttack() then
        if cast.autoAttack(enemy) then return true end
    end
end

----------------
--- Rotation ---
----------------
-- The main part: BR runs it many times a second, and it decides which action list to try.
-- BR already skips it while you are paused, mounted, on a taxi or dead, and holds new casts while
-- you are casting, so you don't need to check for those. (Guide: "The rotation")
local function runRotation()
    -- The best enemy within 40 yards (BR picks it; see Targeting in Bot Options), or nil if there
    -- is none. units.get(5) gives one in melee range instead.
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
-- Tells BR about this profile. BR offers it to characters of this spec on this game version.
registerRotation({
    name      = "MyProfile",    -- Its name in the rotation list (different from the spec's other profiles)
    specID    = 000,            -- Your spec's number, from https://warcraft.wiki.gg/wiki/SpecializationID
                                -- (000 keeps the sample switched off)
    expansion = "Retail",       -- The game version: "Retail", "MOP", "TBC", "Classic" or "Forever"
    author    = "YourName",     -- Optional: your name, shown in BR's profile list
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

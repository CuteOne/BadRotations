local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "swipe", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Multi", icon = "swipe", overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation." },
        { name = "Single", icon = "shred", overlay = "Single Target Rotation", tip = "Forces Single Target Rotation." },
        { name = "Off", icon = "healingTouch", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "bestialWrath", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "bestialWrath", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "bestialWrath", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "healingTouch", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "healingTouch", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "bash", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "bash", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = ui.section("General")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupts")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local var = {}
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------


--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then

    end
end -- End Action List - Defensive

-- * Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true)) then
        local thisUnit
        -- * Bash
        if ui.checked("Bash - Int") then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then

                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if ui.useCDs() then

    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if unit.valid("target") then
            local thisDistance = unit.distance("target") or 99

            if thisDistance < 5 then
                -- Auto Attack
                if not cast.auto.autoAttack() and unit.valid("target") and not unit.deadOrGhost("target") and unit.distance("target") < 5 then
                    unit.startAttack()
                    ui.debug("Casting Auto Shot [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") then
        ------------------------
        --- In Combat - Main ---
        ------------------------
        -- Start Attack
        if unit.exists(units.dyn5) and not cast.auto.autoAttack() and not unit.deadOrGhost("target") then
            unit.startAttack()
            ui.debug("Casting Auto Shot")
            return true
        end
    end -- End In Combat Rotation
end     -- End Action list - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716
    -- Units
    units.get(5)        -- Makes a variable called, units.dyn5
    units.get(40)       -- Makes a variable called, units.dyn40
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(20)     -- Makes a varaible called, enemies.yards20
    enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(40)     -- Makes a varaible called, enemies.yards40

    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
    end         -- Pause
    return true
end             -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 361,
    expansion = "Classic",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

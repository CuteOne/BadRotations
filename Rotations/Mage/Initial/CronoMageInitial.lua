local rotationName = "Crono" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "arcaneExplosion", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range." },
        { name = "Sing", icon = "frostbolt", overlay = "Single Target Rotation", tip = "Single target rotation used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "frostNova", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "frostNova", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "counterspell", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "counterspell", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS --- -- Define General Options
    -----------------------
    section = ui.section("General")
    -- Pre-Pull Timer
    ui.spinner(section, "Pre-Pull Timer", { value = 5, min = 1, max = 10, step = 1,
        tip = "Seconds left on the boss mod pull timer to start the pre-pull." })

    -------------------------
    --- DEFENSIVE OPTIONS --- -- Define Defensive Options
    -------------------------
    section = ui.section("Defensive")

    -------------------------
    --- INTERRUPT OPTIONS --- -- Define Interrupt Options
    -------------------------
    section = ui.section("Interrupts")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local mode
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
-- Any variables/functions made should have a local here to prevent possible conflicts with other things.


-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------

--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {} -- Table for holding action lists.
-- Action List - Extra
actionList.Extra = function()

end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    --Frost Nova
    if unit.hp() < 95 then
        if cast.able.frostNova("player", "aoe", 1, 12) then
            if cast.frostNova("player", "aoe", 1, 12) then
                ui.debug("Casting Frost Nova")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    --Counterspell Interrupt
    if unit.interruptable(units.dyn40) then
        if cast.able.counterspell() and unit.distance(units.dyn40) then
            if cast.counterspell() then
                ui.debug("Casting Counterspell")
                return true
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end                                     -- End Pre-Pull
        if unit.valid("target") then            -- Abilities below this only used when target is valid
            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Pre-Combat]")
                        return true
                    end
                end
            end
        end
    end -- End No Combat
end     -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    mode        = ui.mode
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or ui.pause() or mode.rotation == 4
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)

    -- Pause Timer
    if var.pauseTime == nil then var.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        var.pauseTime = ui.time()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        --Arcane Intellect
        if cast.able.arcaneIntellect("player") and not buff.arcaneIntellect.exists("player") then
            if cast.arcaneIntellect("player") then
                ui.debug("Casting Arcane Intellect")
                return true
            end
        end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                if actionList.Interrupt() then return true end
                -- Start Attack
                -- actions=auto_attack
                if not cast.auto.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    unit.startAttack(units.dyn5)
                end
                --Arcane Explosion
                if cast.able.arcaneExplosion("player", "aoe", 1, 8) then
                    if cast.arcaneExplosion("player", "aoe", 1, 8) then
                        ui.debug("Casting Arcane Explosion")
                        return true
                    end
                end
                --Fire Blast
                if cast.able.fireBlast() and unit.distance(units.dyn40) then
                    if cast.fireBlast() then
                        ui.debug("Casting Fire Blast")
                        return true
                    end
                end
                --Frost Bolt
                if cast.able.frostBolt(units.dyn40) and not unit.moving() then
                    if cast.frostBolt() then
                        ui.debug("Casting Frost Bolt")
                        return true
                    end
                end
            end -- End In Combat Rotation
        end
    end         -- Pause
end             -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 0, --1449 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
    expansion = "Retail",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

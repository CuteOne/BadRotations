local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { modes = {
        { name = "On", icon = "sinisterStrike", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "sinisterStrike", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "crimsonVial", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "crimsonVial", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "kick", overlay = "Interrupts Enabled", tip = "Use Interrupt Abilities" },
        { name = "Off", icon = "kick", overlay = "Interrupts Disabled", tip = "Do Not Use Interrupt Abilities" },
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
    -- Eviscerate Execute
    ui.dropdown(section, "Eviscerate Execute", { choices = { "|cffFFFF00Enabled Notify", "|cff00FF00Enabled", "|cffFF0000Disabled" }, value = "Enabled", checkbox = false,
        tip = "Options for using Eviscerate when the damage from it will kill the unit." })
    -- Stealth
    ui.checkbox(section, "Stealth", { tip = "Will use stealth at all times." })
    -- Stealth Breaker
    ui.dropdown(section, "Stealth Breaker", { choices = { "|cff00FF00Ambush", "|cffFF0000Sinister Strike" }, checkbox = false,
        tip = "Set what to break Stealth with." })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Crimson Vial
    ui.spinner(section, "Crimson Vial", { value = 70, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupt")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local combo
local energy
local mode
-- General Locals
local haltProfile
local profileStop
local finishHim
-- Profile Specific Locals
local actionList = {}

-----------------
--- Functions ---
-----------------
-- Eviscerate Finish
local function eviscerateFinish(thisUnit)
    return ui.value("Eviscerate Execute") ~= 3 and spell.eviscerate.kills(thisUnit)
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Instant Poison (Deadly Poison is Assassination's; before a spec this is the rogue's poison)
    if cast.able.instantPoison() and not buff.instantPoison.exists() then
        if cast.instantPoison() then
            ui.debug("Casting Instant Poison")
            return true
        end
    end
    -- Stealth
    if ui.checked("Stealth") and cast.able.stealth() and not buff.stealth.exists()
        and not unit.casting() and not unit.inCombat() and not (unit.mounted() or unit.flying()) and not unit.resting()
    then
        if cast.stealth() then
            ui.debug("Casting Stealth")
            return true
        end
    end
end
-- Action List - Defensive
actionList.Defensive = function()
    -- Crimson Vial (Evasion is a talent, so not there before a spec)
    if ui.checked("Crimson Vial") then
        if cast.able.crimsonVial() and unit.inCombat() and unit.hp() <= ui.value("Crimson Vial") then
            if cast.crimsonVial() then
                ui.debug("Casting Crimson Vial")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then

    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if unit.valid("target") and unit.distance("target") < 5 then
        if buff.stealth.exists() or unit.level() < 3 then
            --Ambush
            if ui.value("Stealth Breaker") == 1 and cast.able.ambush("target") and not unit.facing("target", "player") then
                if cast.ambush("target") then
                    ui.debug("Casting Ambush [Pre-Combat]")
                    return true
                end
            end
            -- Sinister Strike
            if (ui.value("Stealth Breaker") == 2 or (ui.value("Stealth Breaker") == 1
                and (unit.level() < 6 or unit.facing("target", "player"))))
                and cast.able.sinisterStrike("target") and not unit.inCombat() and (combo() < 5 or unit.level() < 3)
            then
                if cast.sinisterStrike("target") then
                    ui.debug("Casting Sinister Strike [Pre-Combat]")
                    return true
                end
            end
        end
        -- Start Attack
        if cast.able.autoAttack("target") and not unit.inCombat() and energy() < 40 then
            if cast.autoAttack("target") then
                ui.debug("Casting Auto Attack [Pre-Combat]")
                return true
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    -- Start Attack
    if cast.able.autoAttack(units.dyn5) then
        if cast.autoAttack(units.dyn5) then
            ui.debug("Casting Auto Attack")
            return true
        end
    end
    -- Eviscerate Finish
    if cast.able.eviscerate() and (combo() >= 5 or finishHim) then
        if finishHim then
            if cast.eviscerate() then
                ui.debug("Casting Eviscerate [Finish]")
                return true
            end
        else
            if cast.eviscerate() then
                ui.debug("Casting Eviscerate")
                return true
            end
        end
    end
    --Eviscerate
    if cast.able.eviscerate() and (combo() > 4 or unit.hp(units.dyn5) < 20) then
        if cast.eviscerate() then
            ui.debug("Casting Eviscerate")
            return true
        end
    end
    -- Sinister Strike
    if cast.able.sinisterStrike() then
        if cast.sinisterStrike() then
            ui.debug("Casting Sinister Strike")
            return true
        end
    end
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    combo       = power.comboPoints
    energy      = power.energy
    mode        = ui.mode
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or ui.pause() or mode.rotation == 2
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(5, "player", false, true) -- makes enemies.yards5f

    finishHim = eviscerateFinish(units.dyn5)

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
        if actionList.Extras() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        if unit.inCombat() and not profileStop and unit.exists(units.dyn5) and not buff.stealth.exists() then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
            --------------
            --- Combat ---
            --------------
            if actionList.Combat() then return true end
        end
    end         -- Pause
end             -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 1453,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "runeStrike", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "runeStrike", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "deathStrike", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "deathStrike", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "mindFreeze", overlay = "Interrupt Enabled", tip = "Enabled Interrupt" },
        { name = "Off", icon = "mindFreeze", overlay = "Interrupt Disabled", tip = "Disable Interrupt" },
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
    -- Death Grip
    ui.checkbox(section, "Death Grip")
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = ui.section("Cooldowns")
    -- Basic Trinkets Module
    module.BasicTrinkets(nil, section)
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Basic Healing Module
    module.BasicHealing(section)
    -- Lichborne
    ui.spinner(section, "Lichborne", { value = 30, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupt")
    -- Death Grip
    ui.checkbox(section, "Death Grip - Int")
    -- Mind Freeze
    ui.checkbox(section, "Mind Freeze")
    -- "Interrupt At"
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local runes
local runicPower
-- Profile Specific Locals
local actionList = {}
local var = {}
var.haltProfile = false
var.profileStop = false

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Lichborne
        if ui.checked("Lichborne") and cast.able.lichborne() and unit.hp() < ui.value("Lichborne") then
            if cast.lichborne() then
                ui.debug("Casting Lichborne")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        --Death Grip
        if ui.checked("Death Grip (Interrupt)") and cast.able.deathGrip() then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) and unit.distance(thisUnit) > 8 then
                    if cast.deathGrip(thisUnit) then
                        ui.debug("Casting Death Grip [Int]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
                and (not unit.moving("target") or (unit.moving("target") and not unit.facing("target", "player")))
            then
                if cast.deathGrip("target") then
                    ui.debug("Casting Death Grip [Precombat]")
                    return true
                end
            end
            -- Death Coil - Ranged
            if cast.able.deathCoil() and runicPower > 30 and unit.distance(units.dyn5) >= 5 then
                if cast.deathCoil() then
                    ui.debug("Casting Death Coil [Precombat")
                    return true
                end
            end
            -- Start Attack
            -- actions=auto_attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    -- Check for combat
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -- Start Attack
            -- actions=auto_attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Death Grip
            if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.isDummy("target")
                and unit.distance("target") > 8 and unit.distance("target") < 30
                and (not unit.moving("target") or (unit.moving("target") and not unit.facing("target", "player")))
            then
                if cast.deathGrip("target") then
                    ui.debug("Casting Death Grip [Pull]")
                    return true
                end
            end
            -- Trinkets
            module.BasicTrinkets()
            -- Death and Decay
            if cast.able.deathAndDecay("best", nil, 1, 8) and runes > 0 and #enemies.yards8 > 2 then
                if cast.deathAndDecay("best", nil, 1, 8) then
                    ui.debug("Casting Death and Decay")
                    return true
                end
            end
            -- Death Coil
            if cast.able.deathCoil() and runicPower > 30 and (runes == 0 or runicPower >= 80) then
                if cast.deathCoil() then
                    ui.debug("Casting Death Coil")
                    return true
                end
            end
            -- Rune Strike
            if cast.able.runeStrike() and runes > 0 then
                if cast.runeStrike() then
                    ui.debug("Casting Rune Strike")
                    return true
                end
            end
            -- Death Coil - Ranged
            if cast.able.deathCoil() and runicPower > 30 and unit.distance(units.dyn5) >= 5 then
                if cast.deathCoil() then
                    ui.debug("Casting Death Coil")
                    return true
                end
            end
        end -- End In Combat Rotation
    end
end         -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    runes           = power.runes()
    runicPower      = power.runicPower()
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or ui.pause() or ui.mode.rotation == 2
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40)
    -- Enemies
    enemies.get(8)
    enemies.get(15)

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
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
        -----------------
        --- Interrupt ---
        -----------------
        if actionList.Interrupts() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
    end -- Pause
end     -- End runRotation
registerRotation({
    name      = rotationName,
    specID    = 1455,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

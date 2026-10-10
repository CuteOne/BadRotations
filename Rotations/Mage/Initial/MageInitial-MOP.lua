local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "frostfireBolt", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "frostfireBolt", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "frostNova", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "frostNova", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("Interrupt", { modes = {
        { name = "On", icon = "counterspell", overlay = "Interrupt Enabled", tip = "Enables Interrupt" },
        { name = "Off", icon = "counterspell", overlay = "Interrupt Disabled", tip = "Disables Interrupt" },
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
    section = br.ui:section("General")

    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
    -- Forst Nova
    br.ui:spinner(section, "Frost Nova", { value = 30, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = br.ui:section("Interrupts")
    -- Counterspell
    br.ui:checkbox(section, "Counterspell")
    -- Interrupt Percentage
    br.ui:spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local enemies
local ui
local unit
local units
-- Profile Specific Locals
local profileStop
local haltProfile
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()

end
-- Action List - Defensive
actionList.Defensive = function()
    -- Frost Nova
    if ui.checked("Frost Nova") and cast.able.frostNova("player", "aoe", 1, 8) and unit.hp() < ui.value("Frost Nova") then
        if cast.frostNova("player", "aoe", 1, 8) then
            ui.debug("Casting Frost Nova")
            return true
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if br.functions.spell:canInterrupt(thisUnit, ui.value("Interrupt At")) then
                -- Counterspell
                if br.functions.spell:canInterrupt() then
                    if cast.able.counterspell(thisUnit) and unit.distance(thisUnit) then
                        if cast.counterspell(thisUnit) then
                            ui.debug("Casting Counterspell")
                            return true
                        end
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
            local thisDistance = unit.distance("target") or 99
            if not unit.moving() and thisDistance < 40 then
                if cast.able.frostfireBolt("target") and (unit.level() < 2 or not cast.last.frostfireBolt() or cast.timeSinceLast.frostfireBolt() > unit.gcd(true) + 0.5) then
                    if cast.frostfireBolt("target") then
                        ui.debug("Casting Frostfire Bolt [Pre-Pull]")
                        return true
                    end
                end
            end
            -- Start Attack
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Pre-Combat]")
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
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Fire Blast
            if cast.able.fireBlast() then
                if cast.fireBlast() then
                    ui.debug("Casting Fire Blast")
                    return true
                end
            end
            -- Frostfire Bolt
            if cast.able.frostfireBolt() and not unit.moving() then
                if cast.frostfireBolt() then
                    ui.debug("Casting Frostfire Bolt")
                    return true
                end
            end
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
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    enemies     = br.player.enemies
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or br.functions.misc:pause() or ui.mode.rotation == 2
    -- Units
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(40)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = br._G.GetTime() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = br._G.GetTime()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        --------------
        --- Extras ---
        --------------
        if actionList.Extras() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
        if actionList.Interrupts() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
    end         -- Pause
end             -- End runRotation
br.loader.registerRotation({
    name      = rotationName,
    specID    = 1449,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

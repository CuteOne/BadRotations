local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { modes = {
        { name = "On", icon = "sinisterStrike", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "sinisterStrike", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "evasion", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "evasion", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("Interrupt", { modes = {
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
    section = br.ui:section("General")
    -- Eviscerate Execute
    br.ui:dropdown(section, "Eviscerate Execute", { choices = { "|cffFFFF00Enabled Notify", "|cff00FF00Enabled", "|cffFF0000Disabled" }, value = "Enabled", checkbox = false,
        tip = "Options for using Eviscerate when the damage from it will kill the unit." })
    -- Stealth
    br.ui:checkbox(section, "Stealth", { tip = "Will use stealth at all times." })
    -- Stealth Breaker
    br.ui:dropdown(section, "Stealth Breaker", { choices = { "|cff00FF00Ambush", "|cffFF0000Sinister Strike" }, checkbox = false,
        tip = "Set what to break Stealth with." })
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
    -- Evasion
    br.ui:spinner(section, "Evasion", { value = 70, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = br.ui:section("Interrupt")
    -- Interrupt Percentage
    br.ui:spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percent to Cast At (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local combo
local enemies
local energy
local mode
local ui
local spell
local unit
local units
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
    local desc = br._G.C_Spell.GetSpellDescription(spell.eviscerate)
    local damage = 0
    finishHim = false
    if ui.value("Eviscerate Execute") == 3 or combo() == 0 or unit.isDummy(thisUnit) then return false end
    local comboStart = desc:find(" " .. combo() .. " ", 1, true)
    if comboStart ~= nil then
        comboStart = comboStart + 2
        local damageList = desc:sub(comboStart, desc:len())
        comboStart = damageList:find(": ", 1, true) + 2
        damageList = damageList:sub(comboStart, desc:len())
        local comboEnd = damageList:find(" ", 1, true) - 1
        damageList = damageList:sub(1, comboEnd)
        damage = damageList:gsub(",", "")
    end
    local lower = tonumber(string.match(damage, "^(%d+)%-%d+$")) or 0
    finishHim = tonumber(lower) >= unit.health(thisUnit)
    return finishHim
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Deadly Poison
    if cast.able.deadlyPoison() and not buff.deadlyPoison.exists() then
        if cast.deadlyPoison() then
            ui.debug("Casting Deadly Poison")
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
    --Evasion
    if unit.level() >= 8 and ui.checked("Evasion") then
        if cast.able.evasion() and unit.inCombat() and unit.hp() <= ui.value("Evasion") then
            if cast.evasion() then
                ui.debug("Casting Evasion")
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
    buff        = br.player.buff
    cast        = br.player.cast
    combo       = br.player.power.comboPoints
    enemies     = br.player.enemies
    energy      = br.player.power.energy
    mode        = br.player.ui.mode
    ui          = br.player.ui
    spell       = br.player.spells
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or br.functions.misc:pause() or mode.rotation == 2
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(5, "player", false, true) -- makes enemies.yards5f

    finishHim = eviscerateFinish(units.dyn5)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = ui.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = ui.time()
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
br.loader.registerRotation({
    name      = rotationName,
    specID    = 1453,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

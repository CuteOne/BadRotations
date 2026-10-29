-- Editor types: the keys of MOP Paladin's spell lists (written by Types/generate.lua)
local cast = cast --[[@as BR.MOP.Paladin.cast]]
local cd = cd --[[@as BR.MOP.Paladin.cd]]
local spell = spell --[[@as BR.MOP.Paladin.spell]]

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "crusaderStrike", overlay = "Rotation Enabled", tip = "Enables Rotation" },
        { name = "Off", icon = "crusaderStrike", overlay = "Rotation Disabled", tip = "Disables Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "flashOfLight", overlay = "Defensive Enabled", tip = "Enables Defensive" },
        { name = "Off", icon = "flashOfLight", overlay = "Defensive Disabled", tip = "Disables Defensive" },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "hammerOfJustice", overlay = "Interrupt Enabled", tip = "Enables Interrupt" },
        { name = "Off", icon = "hammerOfJustice", overlay = "Interrupt Disabled", tip = "Disables Interrupt" },
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
    -- Seal of Command
    ui.checkbox(section, "Seal of Command")
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = ui.section("Cooldown")

    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Hammer of Justice
    ui.spinner(section, "Hammer of Justice - Defensive", { value = 30, tip = "Health Percent to Cast At" })
   -- Word of Glory
    ui.spinner(section, "Word of Glory", { value = 40, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupts")
    -- Hammer of Justice
    ui.checkbox(section, "Hammer of Justice")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "|cffFFBB00Cast Percentage to use at." })
end

--------------
--- Locals ---
--------------
-- BR API Locals
-- Profile Specific Locals
local actionList     = {}
local var            = {}
var.haltProfile      = false
var.profileStop      = false

--------------------
--- Action Lists ---
--------------------

-- Action List - Extras
actionList.Extras = function()
    -- Seal of Command
    if ui.checked("Seal of Command") and cast.able.sealOfCommand("player") and not unit.formActive(spell.sealOfCommand.id()) then
        if cast.sealOfCommand("player") then
            ui.debug("Casting Seal of Command")
            return true
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Hammer of Justice
        if ui.checked("Hammer of Justice - Defensive") and cast.able.hammerOfJustice()
            and unit.inCombat() and unit.hp() < ui.value("Hammer of Justice - Defensive")
        then
            if cast.hammerOfJustice() then
                ui.debug("Casting Hammer of Justice [Defensive]")
                return true
            end
        end
        -- Word of Glory
        if ui.checked("Word of Glory") and cast.able.wordOfGlory() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and unit.hp(thisUnit) <= ui.value("Word of Glory") then
                if cast.wordOfGlory(thisUnit) then
                    ui.debug("Casting Word of Glory on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) then
                    if cast.hammerOfJustice(thisUnit) then
                        ui.debug("Casting Hammer of Justice [Interrupt]")
                        return true
                    end
                end
            end
        end
    end -- End Interrupt Check
end     -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldowns = function()

end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Judgment
            if cast.able.judgment("target") and unit.exists("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then
                    ui.debug("Casting Judgment [Precombat]")
                    return true
                end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike("target") and unit.exists("target") and unit.distance("target") < 5 then
                if cast.crusaderStrike("target") then
                    ui.debug("Casting Crusader Strike [Precombat]")
                    return true
                end
            end
            -- Auto Attack
            if cast.able.autoAttack("target") and unit.exists("target") and unit.distance("target") < 5 then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat    = function()
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            -- Auto Attack
            if cast.able.autoAttack(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack(units.dyn5) then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Judgment
            if cast.able.judgment() then
                if cast.judgment() then
                    ui.debug("Casting Judgment")
                    return true
                end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike() then
                if cast.crusaderStrike() then
                    ui.debug("Casting Crusader Strike")
                    return true
                end
            end
        end -- End In Combat Rotation
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
    -- Units
    units.get(5)
    -- Enemies
    enemies.get(10)
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or ui.pause() or ui.mode.rotation == 2


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
        -------------
        --- Extra ---
        -------------
        if actionList.Extras() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        if unit.inCombat() then
            -----------------
            --- Cooldowns ---
            -----------------
            if actionList.Cooldowns() then return true end
            -----------------
            --- Interrupt ---
            -----------------
            if actionList.Interrupt() then return true end
            --------------
            --- Combat ---
            --------------
            if actionList.Combat() then return true end
        end
    end -- Pause
end -- End runRotation
registerRotation({
    name      = "Initial",
    specID    = 1451,
    expansion = "MOP",
    author    = "CuteOne",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

-- Editor types: the keys of Retail Priest's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Priest.buff]]
local cast = cast --[[@as BR.Retail.Priest.cast]]
local cd = cd --[[@as BR.Retail.Priest.cd]]
local debuff = debuff --[[@as BR.Retail.Priest.debuff]]

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "smite", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "smite", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "powerWordShield", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "powerWordShield", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
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
    ui.checkbox(section, "Power Word: Fortitude")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    ui.spinner(section, "Desperate Prayer", { value = 30, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Fade", { value = 25, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Power Word: Shield", { value = 50, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Flash Heal", { value = 80, tip = "Health Percent to Cast At" })
    ui.spinner(section, "Psychic Scream", { value = 40, tip = "Health Percent to Cast At" })
    ui.checkbox(section, "Resurrection")
end

--------------
--- Locals ---
--------------
-- BR API Locals
local mode
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}
local var = {}

--------------------
--- Action Lists ---
--------------------

-- Action List - Extra
actionList.Extra = function()
    -- Power Word: Fortitude
    if ui.checked("Power Word: Fortitude") and cast.able.powerWordFortitude(var.friendUnit) and not buff.powerWordFortitude.exists(var.friendUnit) then
        if cast.powerWordFortitude(var.friendUnit) then
            ui.debug("Casting Power Word: Fortitude")
            return true
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    -- Flash Heal
    if ui.checked("Flash Heal") and cast.able.flashHeal(var.friendUnit) and not unit.moving() and unit.hp(var.friendUnit) <= ui.value("Flash Heal") then
        if cast.flashHeal(var.friendUnit) then
            ui.debug("Casting Flash Heal")
            return true
        end
    end
    -- Psychic Scream
    if ui.checked("Psychic Scream") and cast.able.psychicScream() and unit.inCombat() and unit.hp() <= ui.value("Psychic Scream") then
        if cast.psychicScream() then
            ui.debug("Casting Psychic Scream")
            return true
        end
    end
    -- Desperate Prayer
    if ui.checked("Desperate Prayer") and cast.able.desperatePrayer()
        and unit.inCombat() and unit.hp() <= ui.value("Desperate Prayer")
    then
        if cast.desperatePrayer() then
            ui.debug("Casting Desperate Prayer")
            return true
        end
    end
    -- Fade
    if ui.checked("Fade") and cast.able.fade() and unit.inCombat() and unit.hp() <= ui.value("Fade") then
        if cast.fade() then
            ui.debug("Casting Fade")
            return true
        end
    end
    -- Power Word: Shield
    if ui.checked("Power Word: Shield") and cast.able.powerWordShield(var.friendUnit)
        and not buff.powerWordShield.exists(var.friendUnit) and unit.hp(var.friendUnit) <= ui.value("Power Word: Shield")
    then
        if cast.powerWordShield(var.friendUnit) then
            ui.debug("Casting Power Word: Shield")
            return true
        end
    end
    -- Resurrection
    if ui.checked("Resurrection") and not unit.inCombat() then
        var.resUnit = unit.isUnit(var.friendUnit, "target") and "target" or "mouseover"
        if cast.able.resurrection(var.resUnit, "dead") and unit.deadOrGhost(var.resUnit)
            and (unit.friend(var.resUnit) and unit.player(var.resUnit))
        then
            if cast.resurrection(var.resUnit, "dead") then
                ui.debug("Casting Resurrection on " .. unit.name(var.resUnit))
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Smite
            if cast.able.smite("target") and not unit.moving() then
                if cast.smite("target") then
                    ui.debug("Casting Smite [Precombat]")
                    return true
                end
            end
            -- Shadow Word: Pain
            if cast.able.shadowWordPain("target") and debuff.shadowWordPain.refresh("target") then
                if cast.shadowWordPain("target") then
                    ui.debug("Casting Shadow Word: Pain [Precombat]")
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
actionList.Combat = function()
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            -- Auto Attack
            if cast.able.autoAttack(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack(units.dyn5) then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Shadow Word: Pain
            if cast.able.shadowWordPain(units.dyn40) and debuff.shadowWordPain.refresh(units.dyn40) then
                if cast.shadowWordPain(units.dyn40) then
                    ui.debug("Casting Shadow Word: Pain")
                    return true
                end
            end
            -- Mind Blast
            if cast.able.mindBlast() and not unit.moving() then
                if cast.mindBlast() then
                    ui.debug("Casting Mind Blast")
                    return true
                end
            end
            -- Smite
            if cast.able.smite() and not unit.moving() then
                if cast.smite() then
                    ui.debug("Casting Smite")
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
    mode           = ui.mode
    -- General Locals
    profileStop    = profileStop or false
    haltProfile    = (unit.inCombat() and profileStop) or unit.mounted() or ui.pause() or mode.rotation == 2
    var.friendUnit = (unit.player("target") and unit.friend("target")) and "target" or "player"
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)

    -- Pause Timer
    if var.pauseTime == nil then var.pauseTime = util.time() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        var.pauseTime = util.time()
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -------------
        --- Extra ---
        -------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        --------------
        --- Combat ---
        --------------
        if unit.inCombat() then
            if actionList.Combat() then return true end
        end
    end         -- Pause
end             -- End runRotation
registerRotation({
    name      = "Initial",
    specID    = 1452,
    expansion = "Retail",
    author    = "CuteOne",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

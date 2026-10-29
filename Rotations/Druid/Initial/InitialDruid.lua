-- Editor types: the keys of Retail Druid Initial's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Druid.Initial.buff]]
local cast = cast --[[@as BR.Retail.Druid.Initial.cast]]
local cd = cd --[[@as BR.Retail.Druid.Initial.cd]]
local debuff = debuff --[[@as BR.Retail.Druid.Initial.debuff]]
local spell = spell --[[@as BR.Retail.Druid.Initial.spell]]

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "wrath", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range." },
        { name = "Off", icon = "regrowth", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "regrowth", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "regrowth", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Cooldown", { modes = {
        { name = "On", icon = "rebirth", overlay = "Cooldown Enabled", tip = "Includes Offensive Cooldowns." },
        { name = "Off", icon = "rebirth", overlay = "Cooldown Disabled", tip = "No Offensive Cooldowns Used." },
    } })
    ui.toggle("Forms", { modes = {
        { name = "Caster", icon = "moonkinForm", overlay = "Caster Form", tip = "Will force and use Caster Form" },
        { name = "Cat", icon = "catForm", overlay = "Cat Form", tip = "Will force and use Cat Form" },
        { name = "Bear", icon = "bearForm", overlay = "Bear Form", tip = "Will force and use Bear Form" },
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
    ui.spinner(section, "Shift Wait Time", { value = 2, max = 5, step = 1, checkbox = false,
        tip = "Time in seconds the profile will wait while moving to shift. Combat is instant!" })
    -- Mark of the Wild
    ui.dropdown(section, "Mark of the Wild", { choices = { "Player", "Target", "Mouseover", "Focus", "Group" }, value = "Player",
        tip = "Set how to use Mark of the Wild" })
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = ui.section("Cooldowns")

    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Regrowth
    ui.spinner(section, "Regrowth", { value = 50, tip = "Health Percent to Cast At" })
end

--------------
--- Locals ---
--------------
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local comboPoints
local energy
local var = {}
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
local fbMaxEnergy

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------

local getMarkUnitOption = function(option)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then
        thisUnit = "player"
    end
    if thisTar == 2 then
        thisUnit = "target"
    end
    if thisTar == 3 then
        thisUnit = "mouseover"
    end
    if thisTar == 4 then
        thisUnit = "focus"
    end
    if thisTar == 5 then
        thisUnit = "player"
        if #units.friends > 1 then
            for i = 1, #units.friends do
                local nextUnit = units.friends[i].unit
                if buff.markOfTheWild.refresh(nextUnit) and unit.distance(var.markUnit) < 40 then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Auto Shapeshift
    if (not buff.travelForm.exists() and unit.moving() and unit.movingTime() > ui.value("Shift Wait Time")) or unit.inCombat()
        or (unit.exists("target") and (unit.id("target") == 164577 or unit.id("target") == 166906) and unit.canAttack("player", "target"))
    then
        local formValue = ui.mode.forms
        -- Bear Form
        if formValue == 3 and unit.level() >= 8 and cast.able.bearForm() and not buff.bearForm.exists() then
            if cast.bearForm() then
                ui.debug("Casting Bear Form")
                return true
            end
        end
        -- Caster Form
        if (formValue == 1 or (unit.exists("target") and (unit.id("target") == 164577 or unit.id("target") == 166906) and unit.canAttack("player", "target")))
            and (buff.bearForm.exists() or buff.catForm.exists())
        then
            unit.cancelForm()
            ui.debug("Casting Caster Form")
            return true
        end
        --Cat Form
        if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5 and cast.able.catForm() and not buff.catForm.exists()
            and ((unit.id("target") ~= 164577 and unit.id("target") ~= 166906) or not unit.canAttack("player", "target"))
        then
            if cast.catForm() then
                ui.debug("Casting Cat Form")
                return true
            end
        end
        -- Mark of the Wild
        if ui.checked("Mark of the Wild") then
            var.markUnit = getMarkUnitOption("Mark of the Wild")
            if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit) and not unit.resting() and unit.distance(var.markUnit) < 40 then
                if cast.markOfTheWild(var.markUnit) then
                    ui.debug("Casting Mark of the Wild")
                    return true
                end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Regrowth
        if ui.checked("Regrowth") and cast.able.regrowth() and not cast.current.regrowth() and not unit.moving() then
            if unit.friend("target") and unit.hp("target") <= ui.value("Regrowth") and unit.player("target") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    -- CancelShapeshiftForm()
                    unit.cancelForm()
                else
                    if cast.regrowth("target") then
                        ui.debug("Casting Regrowth on " .. unit.name("target"))
                        return true
                    end
                end
            end
            if not unit.friend("target") and unit.hp() <= ui.value("Regrowth") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    -- CancelShapeshiftForm()
                    unit.cancelForm()
                else
                    if cast.regrowth("player") then
                        ui.debug("Casting Regrowth on " .. unit.name("player"))
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Cooldowns
actionList.Cooldowns = function()
    module.BasicTrinkets()
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() then
        if unit.valid("target") then
            local thisDistance = unit.distance("target") or 99
            -- Wrath
            if not unit.moving() and not (buff.catForm.exists() or buff.bearForm.exists()) and thisDistance < 40 then
                if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) then
                    if cast.wrath("target") then
                        ui.debug("Casting Wrath [Precombat]")
                        return true
                    end
                end
            end
            if thisDistance < 5 then
                -- Shred
                if cast.able.shred() and buff.catForm.exists() then
                    if cast.shred() then
                        ui.debug("Casting Shred [Precombat]")
                        return true
                    end
                end
                -- Auto Attack
                if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.autoAttack() then
                        ui.debug("Casting Auto Attack [Precombat]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") and cd.global.remain() == 0 then
        ------------------------
        --- In Combat - Main ---
        ------------------------
        -- Melee in melee range
        if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            -- Start Attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Call Action List - Cooldowns
            if actionList.Cooldowns() then return true end
            -- Bear Form
            if buff.bearForm.exists() then
                -- Mangle
                if cast.able.mangle(units.dyn5) then
                    if cast.mangle(units.dyn5) then
                        ui.debug("Casting Mangle")
                        return true
                    end
                end
            end
            -- Cat Form
            if buff.catForm.exists() then
                local finish = spell.ferociousBite.kills(units.dyn5)
                -- Ferocious Bite
                if cast.able.ferociousBite() and ((comboPoints == 5 and fbMaxEnergy) or finish) then
                    if finish then
                        if cast.ferociousBite() then
                            ui.debug("Casting Ferocious Bite [Finish]")
                            return true
                        end
                    else
                        if cast.ferociousBite() then
                            ui.debug("Casting Ferocious Bite")
                            return true
                        end
                    end
                end
                -- Shred
                if cast.able.shred() and (comboPoints < 5 or unit.level() < 7) then
                    if cast.shred() then
                        ui.debug("Casting Shred")
                        return true
                    end
                end
            end
        end
        -- Caster Form
        if not (buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists()) then
            -- Moonfire
            if cast.able.moonfire(units.dyn40AOE) and (unit.level() < 5 or not buff.catForm.exists()) and debuff.moonfire.refresh(units.dyn40AOE) then
                if cast.moonfire(units.dyn40AOE) then
                    ui.debug("Casting Moonfire")
                    return true
                end
            end
            -- Wrath
            if not unit.moving() and cast.able.wrath() and (unit.level() < 2 or (not cast.last.wrath() and cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) or not debuff.moonfire.refresh(units.dyn40AOE)) then
                if cast.wrath() then
                    ui.debug("Casting Wrath")
                    return true
                end
            end
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
    comboPoints = power.comboPoints()
    energy      = power.energy()
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 2 or unit.id("target") == 156716
    -- Units
    units.get(5)        -- Makes a variable called, units.dyn5
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(40)     -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    fbMaxEnergy = energy >= 50
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
    name      = "Initial Druid",
    specID    = 1447,
    expansion = "Retail",
    author    = "CuteOne",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

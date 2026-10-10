local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "tigerPalm", overlay = "Rotation Enabled", tip = "Enables Rotation" },
        { name = "Off", icon = "tigerPalm", overlay = "Rotation Disabled", tip = "Disables Rotation" },
    } })
    br.ui:toggle("Cooldown", { modes = {
        { name = "Auto", icon = "touchOfDeath", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "touchOfDeath", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "touchOfDeath", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "vivify", overlay = "Defensive Enabled", tip = "Enables Defensive" },
        { name = "Off", icon = "vivify", overlay = "Defensive Disabled", tip = "Disables Defensive" },
    } })
    br.ui:toggle("Interrupt", { modes = {
        { name = "On", icon = "legSweep", overlay = "Interrupt Enabled", tip = "Enables Interrupt" },
        { name = "Off", icon = "legSweep", overlay = "Interrupt Disabled", tip = "Interrupt Defensive" },
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
    -- Crackling Jade lightning
    br.ui:checkbox(section, "Crackling Jade Lightning")
    br.ui:spinner(section, "Cancel CJL Range", { value = 10, min = 5, max = 40, checkbox = false,
        tip = "Cancels Crackling Jade Lightning below this range in yards." })
    -- Roll
    br.ui:checkbox(section, "Roll")
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = br.ui:section("Cooldown")
    -- Touch of Death
    br.ui:dropdown(section, "Touch of Death", { choices = { "Always", "|cff0000ffCD", "|cffff0000Never" }, value = "CD", checkbox = false,
        tip = "When to use Touch of Death" })
    -- Trinkets
    br.player.module.BasicTrinkets(nil, section)
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
    -- Expel Harm
    br.ui:spinner(section, "Expel Harm", { value = 40, tip = "Health Percent to Cast At" })
    -- Healthstone / Potion
    br.ui:spinner(section, "Healthstone/Potion", { value = 30, tip = "Health Percent to Cast At" })
    -- Heirloom Neck
    br.ui:spinner(section, "Heirloom Neck", { value = 80, tip = "Health Percent to Cast At" })
    -- Leg Sweep
    br.ui:spinner(section, "Leg Sweep - HP", { value = 50, tip = "Health Percent to Cast At" })
    br.ui:spinner(section, "Leg Sweep - AoE", { value = 5, max = 10, step = 1, tip = "Number of Units in 5 Yards to Cast At" })
    -- Vivify
    br.ui:spinner(section, "Vivify", { value = 60, tip = "Health Percent to Cast At" })
    -- Target Heal Key
    br.ui:dropdown(section, "Target Heal Key", { choices = "Toggle", value = "LeftShift", checkbox = false })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = br.ui:section("Interrupts")
    -- Pandaren Racial
    if select(2, UnitRace("player")) == "Pandaren" then
        br.ui:checkbox(section, "Quaking Palm", { tip = "|cffFFBB00Pandaren Racial" })
    end
    -- Leg Sweep
    br.ui:checkbox(section, "Leg Sweep")
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
local chi
local enemies
local energy
local module
local ui
local unit
local units
local spell
-- Profile Specific Locals
local actionList = {}
local var = {}
var.getFacingDistance = br.functions.range.getFacingDistance
var.haltProfile = false
var.profileStop = false

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Crackling Jade Lightning
    -- if ui.checked("Crackling Jade Lightning") and not unit.mounted() and not cast.current.cracklingJadeLightning()
    --     and not unit.moving() and cast.able.cracklingJadeLightning("target") and unit.valid("target")
    --     and unit.distance("target") > ui.value("Cancel CJL Range")
    -- then
    --     if cast.cracklingJadeLightning("target") then
    --         ui.debug("Casting Crackling Jade Lightning")
    --         return true
    --     end
    -- end
    -- Roll
    if ui.checked("Roll") and cast.able.roll() and unit.moving()
        and unit.distance("target") > 10 and unit.valid("target")
        and var.getFacingDistance() < 5 and unit.facing("player", "target", 10)
    then
        if cast.roll() then
            ui.debug("Casting Roll")
            return true
        end
    end
end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- -- Expel Harm
        -- if ui.checked("Expel Harm") and cast.able.expelHarm() and unit.hp() <= ui.value("Expel Harm") then
        --     if cast.expelHarm() then
        --         ui.debug("Casting Expel Harm")
        --         return true
        --     end
        -- end
        -- -- Leg Sweep
        -- if ui.checked("Leg Sweep - HP") and cast.able.legSweep() and unit.hp() <= ui.value("Leg Sweep - HP")
        --     and unit.inCombat() and #enemies.yards5 > 0
        -- then
        --     if cast.legSweep() then
        --         ui.debug("Casting Leg Sweep [HP]")
        --         return true
        --     end
        -- end
        -- if ui.checked("Leg Sweep - AoE") and cast.able.legSweep()
        --     and #enemies.yards5 >= ui.value("Leg Sweep - AoE")
        -- then
        --     if cast.legSweep() then
        --         ui.debug("Casting Leg Sweep [AOE]")
        --         return true
        --     end
        -- end
        -- -- Vivify
        -- local vivifyUnit = unit.friend("target") and "target" or "player"
        -- if ui.checked("Vivify") and cast.able.vivify(vivifyUnit) then
        --     if unit.hp(vivifyUnit) <= ui.value("Vivify") then
        --         if cast.vivify(vivifyUnit) then
        --             ui.debug("Casting Vivify on " .. unit.name(vivifyUnit))
        --             return true
        --         end
        --     end
        -- end
    end
end -- End Action List - Defensive

-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- Touch of Death
    -- if ui.alwaysCdNever("Touch of Death") and cast.able.touchOfDeath(units.dyn5) and unit.health(units.dyn5) < unit.healthMax("player") then
    --     if cast.touchOfDeath(units.dyn5) then
    --         ui.debug("Casting Touch of Death - Omae wa mou shindeiru")
    --         return true
    --     end
    -- end
    -- Trinket - Non-Specific
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if br.functions.spell:canInterrupt(thisUnit, ui.value("Interrupt At")) then
                -- Quaking Palm (Pandaren Racial)
                if ui.checked("Quaking Palm") and unit.race("Pandaren") and cast.able.racial(thisUnit) and unit.distance(thisUnit) < 5 then
                    if cast.racial(thisUnit) then
                        ui.debug("Casting Quaking Palm [Interrupt]")
                        return true
                    end
                end
                -- Leg Sweep
                -- if ui.checked("Leg Sweep") and cast.able.legSweep(thisUnit) and unit.distance(thisUnit) < 5 then
                --     if cast.legSweep(thisUnit) then
                --         ui.debug("Casting Leg Sweep [Interrupt]")
                --         return true
                --     end
                -- end
            end
        end
    end -- End Interrupt Check
end     -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
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
    -- Check for combat
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -- Auto Attack
            if cast.able.autoAttack() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Call Action List - Cooldowns
            if actionList.Cooldowns() then return true end
            -- -- Spinning Crane Kick
            -- if cast.able.spinningCraneKick() and #enemies.yards8 > 3 then
            --     if cast.spinningCraneKick() then
            --         ui.debug("Casting Spinning Crane Kick")
            --         return true
            --     end
            -- end
            -- Blackout Kick
            if cast.able.blackoutKick() and buff.tigerPower.exists() then
                if cast.blackoutKick() then
                    ui.debug("Casting Blackout Kick")
                    return true
                end
            end
            -- Tiger Palm
            if cast.able.tigerPalm() and (buff.tigerPower.refresh() or (chi() >= chi.max() - 1) or energy() < 40) then
                if cast.tigerPalm() then
                    ui.debug("Casting Tiger Palm")
                    return true
                end
            end
            -- Jab
            if cast.able.jab() then
                if cast.jab() then
                    ui.debug("Casting Jab")
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
    -- This profile handles racials itself; skip the shared Racial module
    if not br.player.localRacial then br.player.localRacial = true end
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff            = br.player.buff
    cast            = br.player.cast
    cd              = br.player.cd
    chi             = br.player.power.chi
    enemies         = br.player.enemies
    energy          = br.player.power.energy
    module          = br.player.module
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    spell           = br.player.spell
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or br.functions.misc:pause() or ui.mode.rotation == 2
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)

    -- Cancel Crackling Jade Lightning
    -- if cast.current.cracklingJadeLightning() and unit.distance("target") < ui.value("Cancel CJL Range") then
    --     if cast.cancel.cracklingJadeLightning() then
    --         ui.debug("Canceling Crackling Jade Lightning [Within " .. ui.value("Cancel CJL Range") .. "yrds]")
    --         return true
    --     end
    -- end

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
        if actionList.Extra() then return true end
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
            --- Interrupt ---
            -----------------
            if actionList.Interrupt() then return true end
            --------------
            --- Combat ---
            --------------
            if actionList.Combat() then return true end
        end
    end -- Pause
end     -- End runRotation
br.loader.registerRotation({
    name      = rotationName,
    specID    = 1450,
    expansion = "MOP",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

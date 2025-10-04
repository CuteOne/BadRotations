local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spells.tigerPalm },
        [2] = { mode = "Off", value = 2, overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spells.tigerPalm }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.touchOfDeath },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.touchOfDeath },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.touchOfDeath }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spells.vivify },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spells.vivify }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spells.legSweep },
        [2] = { mode = "Off", value = 2, overlay = "Interrupt Disabled", tip = "Interrupt Defensive", highlight = 0, icon = br.player.spells.legSweep }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Crackling Jade lightning
        br.ui:createCheckbox(section, "Crackling Jade Lightning")
        br.ui:createSpinnerWithout(section, "Cancel CJL Range", 10, 5, 40, 5,
            "|cffFFFFFFCancels Crackling Jade Lightning below this range in yards.")
        -- Roll
        br.ui:createCheckbox(section, "Roll")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldown")
        -- Touch of Death
        br.ui:createDropdownWithout(section, "Touch of Death", { "Always", "|cff0000ffCD", "|cffff0000Never" }, 2,
            "|cffFFFFFFWhen to use Touch of Death")
        -- Trinkets
        br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Expel Harm
        br.ui:createSpinner(section, "Expel Harm", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Healthstone / Potion
        br.ui:createSpinner(section, "Healthstone/Potion", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Leg Sweep
        br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Vivify
        br.ui:createSpinner(section, "Vivify", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Target Heal Key
        br.ui:createDropdownWithout(section, "Target Heal Key", br.ui.dropOptions.Toggle, 2)
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Pandaren Racial
        if select(2, UnitRace("player")) == "Pandaren" then
            br.ui:createCheckbox(section, "Quaking Palm", "|cffFFBB00Pandaren Racial")
        end
        -- Leg Sweep
        br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.ui.dropOptions.Toggle, 6)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.ui.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = { {
        [1] = "Rotation Options",
        [2] = rotationOptions,
    } }
    return optionTable
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
local id = 1450
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spells.runeStrike },
        [2] = { mode = "Off", value = 4, overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spells.runeStrike }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.deathStrike },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.deathStrike }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupt Enabled", tip = "Enabled Interrupt", highlight = 1, icon = br.player.spells.mindFreeze },
        [2] = { mode = "Off", value = 2, overlay = "Interrupt Disabled", tip = "Disable Interrupt", highlight = 0, icon = br.player.spells.mindFreeze }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 3, 0)
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
        -- Death Grip
        br.ui:createCheckbox(section, "Death Grip")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Basic Trinkets Module
        br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Lichborne
        br.ui:createSpinner(section, "Lichborne", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
        -- Death Grip
        br.ui:createCheckbox(section, "Death Grip - Int")
        -- Mind Freeze
        br.ui:createCheckbox(section, "Mind Freeze")
        -- "Interrupt At"
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupt Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
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
local cast
local cd
local enemies
local module
local runes
local runicPower
local ui
local unit
local units
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
    cast            = br.player.cast
    cd              = br.player.cd
    enemies         = br.player.enemies
    module          = br.player.module
    runes           = br.player.power.runes()
    runicPower      = br.player.power.runicPower()
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation == 2
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
local id = 1455
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

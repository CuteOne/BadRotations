local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spells.crusaderStrike },
        [2] = { mode = "Off", value = 2, overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spells.crusaderStrike }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spells.flashOfLight },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spells.flashOfLight }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spells.hammerOfJustice },
        [2] = { mode = "Off", value = 2, overlay = "Interrupt Disabled", tip = "Disables Interrupt", highlight = 0, icon = br.player.spells.hammerOfJustice }
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

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldown")
        -- Trinkets
        br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Divine Shield
        br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Flash of Light
        br.ui:createSpinner(section, "Flash of Light", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Hammer of Justice
        br.ui:createSpinner(section, "Hammer of Justice - Defensive", 30, 0, 100, 5,
            "|cffFFFFFFHealth Percent to Cast At")
        -- Lay on Hands
        br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Word of Glory
        br.ui:createSpinner(section, "Word of Glory", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Hammer of Justice
        br.ui:createCheckbox(section, "Hammer of Justice")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        --Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.ui.dropOptions.Toggle, 6)
        --Defensive Key Toggle
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
local debuff
local enemies
local module
local ui
local unit
local units
-- Profile Specific Locals
local actionList     = {}
local var            = {}
var.haltProfile      = false
var.profileStop      = false

--------------------
--- Action Lists ---
--------------------

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Lay on Hands
        if ui.checked("Lay on Hands") and cast.able.layOnHands() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit) and unit.hp(thisUnit) <= ui.value("Lay on Hands") then
                if cast.layOnHands(thisUnit) then
                    ui.debug("Casting Lay on Hands on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit) and unit.hp(thisUnit) <= ui.value("Divine Shield") then
                if cast.divineShield(thisUnit) then
                    ui.debug("Casting Divine Shield on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Call Module- Basic Healing
        module.BasicHealing()
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
        -- Flash of Light
        if ui.checked("Flash of Light") and cast.able.flashOfLight() and not unit.moving() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if (unit.inCombat() and unit.hp(thisUnit) <= ui.value("Flash of Light"))
                or (not unit.inCombat() and unit.hp() < 90)
            then
                if cast.flashOfLight(thisUnit) then
                    ui.debug("Casting Flash of Light on " .. unit.name(thisUnit))
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
            if br.functions.spell:canInterrupt(thisUnit, ui.value("Interrupt At")) then
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
    -- Trinket - Non-Specific
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Judgment
            if cast.able.judgment("target") and unit.exists("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then
                    ui.debug("Casting Judgment [Pull]")
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
            -- Shield of the Righteous
            if cast.able.shieldOfTheRighteous() then
                if cast.shieldOfTheRighteous() then
                    ui.debug("Casting Shield of the Righteous")
                    return true
                end
            end
            -- Consecration
            if cast.able.consecration("player", "aoe", 3, 10) and not buff.consecration.exists() and #enemies.yards10 > 2 and not unit.moving() then
                if cast.consecration("player", "aoe", 3, 10) then
                    ui.debug("Casting Consecration")
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
end         -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff    = br.player.buff
    cast    = br.player.cast
    cd      = br.player.cd
    debuff  = br.player.debuff
    enemies = br.player.enemies
    module  = br.player.module
    ui      = br.player.ui
    unit    = br.player.unit
    units   = br.player.units
    -- Units
    units.get(5)
    -- Enemies
    enemies.get(10)
    -- General Locals
    var.haltProfile = (unit.inCombat() and var.profileStop) or unit.mounted() or br.functions.misc:pause() or ui.mode.rotation == 2


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
        --- Cooldowns ---
        -----------------
        if actionList.Cooldowns() then return true end
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
local id = 1451
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

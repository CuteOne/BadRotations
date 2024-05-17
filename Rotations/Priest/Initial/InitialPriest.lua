local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spells.smite },
        [2] = { mode = "Off", value = 4, overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spells.smite }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.powerWordShield },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.powerWordShield }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
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
        br.ui:createCheckbox(section, "Power Word: Fortitude")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Desperate Prayer", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Fade", 25, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Power Word: Shield", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Flash Heal", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createSpinner(section, "Psychic Scream", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createCheckbox(section, "Resurrection")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
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
local buff
local cast
local cd
local debuff
local mode
local ui
local unit
local units
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
                    br.addonDebug("Casting Smite [Precombat]")
                    return true
                end
            end
            -- Shadow Word: Pain
            if cast.able.shadowWordPain("target") and debuff.shadowWordPain.refresh("target") then
                if cast.shadowWordPain("target") then
                    br.addonDebug("Casting Shadow Word: Pain [Precombat]")
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
                    br.addonDebug("Casting Shadow Word: Pain")
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
                    br.addonDebug("Casting Smite")
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
    buff           = br.player.buff
    cast           = br.player.cast
    cd             = br.player.cd
    debuff         = br.player.debuff
    mode           = br.player.ui.mode
    ui             = br.player.ui
    unit           = br.player.unit
    units          = br.player.units
    -- General Locals
    profileStop    = profileStop or false
    haltProfile    = (unit.inCombat() and profileStop) or IsMounted() or br.pause() or mode.rotation == 2
    var.friendUnit = (unit.player("target") and unit.friend("target")) and "target" or "player"
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = GetTime() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = GetTime()
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
local id = 1452 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

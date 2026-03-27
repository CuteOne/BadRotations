local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "DPS Rotation Enabled", tip = "Enable DPS Rotation", highlight = 1, icon = br.player.spells.lightningBolt },
        [2] = { mode = "Off", value = 2, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.primalStrike }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.healingSurge },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.healingSurge }
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
        -- Flametongue Weapon
        br.ui:createCheckbox(section, "Flametongue Weapon", "|cff0070deCheck this to keep flametongue weapon enchant up.")
        -- Lightning Shield
        br.ui:createCheckbox(section, "Lightning Shield", "|cff0070deCheck this to keep lightning shield up.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healing Surge
        br.ui:createSpinner(section, "Healing Surge", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- OOC Healing
        br.ui:createCheckbox(section, "OOC Healing",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
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
local spell
local ui
local unit
local units
local var
local actionList = {}

-----------------
--- Functions ---
-----------------
local function cancelLightningBolt()
    if cast.current.lightningBolt() and cast.timeRemain() > unit.gcd(true) then
        if cast.cancel.lightningBolt() then
            ui.debug("Canceled Lightning Bolt Cast [Melee Range]")
            return true
        end
    end
    return false
end
local function canLightningBolt()
    -- Earth Shock
    if (not spell.earthShock.known() or cast.time.lightningBolt() > cd.earthShock.remain()) and
        unit.distance(units.dyn25) < 25
    then
        return false
    end
    -- Primal Strike
    if (not spell.primalStrike.known() or cast.time.lightningBolt() > cd.primalStrike.remain()) and unit.distance(units.dyn5) < 5 then
        return false
    end
    return true
end
--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Flametongue Weapon
    if ui.checked("Flametongue Weapon") and cast.able.flametongueWeapon() and not unit.weaponImbue.exists() then
        if cast.flametongueWeapon("player") then
            ui.debug("Casting Flametongue Weapon [Extra]")
            return true
        end
    end
    -- Lightning Shield
    if ui.checked("Lightning Shield") and cast.able.lightningShield() and not buff.lightningShield.exists() then
        if cast.lightningShield("player") then
            ui.debug("Casting Lightning Shield [Extra]")
            return true
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Healing Surge
        if ui.checked("Healing Surge") and cast.able.healingSurge() and not unit.moving() then
            if unit.friend("target") and unit.hp("target") <= ui.value("Healing Surge") then
                if cast.healingSurge("target") then
                    ui.debug("Casting Healing Surge on " .. unit.name("target") .. " [Defensive]")
                    return true
                end
            elseif unit.hp("player") <= ui.value("Healing Surge") then
                if cast.healingSurge("player") then
                    ui.debug("Casting Healing Surge on " .. unit.name("player") .. " [Defensive]")
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if unit.valid("target") and unit.exists("target") then
            if unit.distance("target") > 5 then
                -- Lightning Bolt
                if cast.able.lightningBolt("target") and var.useLightningBolt then
                    if cast.lightningBolt("target") then
                        ui.debug("Casting Lightning Bolt [Precombat]")
                        return true
                    end
                end
                -- Earth Shock
                if cast.able.earthShock("target") then
                    if cast.earthShock("target") then
                        ui.debug("Casting Earth Shock [Precombat]")
                        return true
                    end
                end
            else
                -- Primal Strike
                if cast.able.primalStrike("target") then
                    if cast.primalStrike("target") then
                        ui.debug("Casting Primal Strike [Precombat]")
                        return true
                    end
                end
                -- Start Attack
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
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
    if (unit.inCombat() or (not unit.inCombat() and unit.valid(units.dyn5))) and not var.profileStop
        and unit.exists(units.dyn5) and cd.global.remain() == 0
    then
        -- Start Attack
        if cast.able.autoAttack("target") then
            if cast.autoAttack("target") then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- Earth Shock
        if cast.able.earthShock() then
            if cast.earthShock() then
                ui.debug("Casting Earth Shock [Combat]")
                return true
            end
        end
        -- Primal Strike
        if cast.able.primalStrike() then
            if cast.primalStrike() then
                ui.debug("Casting Primal Strike [Combat]")
                return true
            end
        end
        -- Lightning Bolt
        if cast.able.lightningBolt() and var.useLightningBolt then
            if cast.lightningBolt() then
                ui.debug("Casting Lightning Bolt [Combat]")
                return true
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
    buff            = br.player.buff
    cast            = br.player.cast
    cd              = br.player.cd
    debuff          = br.player.debuff
    enemies         = br.player.enemies
    module          = br.player.module
    spell           = br.player.spell
    ui              = br.player.ui
    unit            = br.player.unit
    units           = br.player.units
    var             = br.player.variables
    -- General Locals
    var.profileStop = var.profileStop or false
    var.haltProfile = (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or ui.pause() or
        ui.mode.rotation == 2
    -- Units
    units.get(5)
    units.get(25)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(10)
    enemies.get(20)
    enemies.get(40)

    var.useLightningBolt = canLightningBolt()
    if not var.useLightningBolt then
        cancelLightningBolt()
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- * Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        if ui.mode.rotation ~= 2 then
            ------------------
            --- Pre-Combat ---
            ------------------
            if actionList.PreCombat() then return true end
            -----------------------------
            --- In Combat - Rotations ---
            -----------------------------
            if actionList.Combat() then return true end
        end -- End In Combat Rotation
    end     -- Pause
    return true
end         -- End runRotation
local id = 1444
br.loader.rotations[id] = br.loader.rotations[id] or {}
if br.api.expansion == "MOP" then
    br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
    })
end

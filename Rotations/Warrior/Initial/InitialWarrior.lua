local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spells.slam },
        [2] = { mode = "Off", value = 4, overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spells.victoryRush }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.shieldBlock },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.shieldBlock }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Movement Button
    local MoverModes = {
        [1] = { mode = "On", value = 1, overlay = "Mover Enabled", tip = "Will use Charge.", highlight = 1, icon = br.player.spells.charge },
        [2] = { mode = "Off", value = 2, overlay = "Mover Disabled", tip = "Will NOT use Charge.", highlight = 0, icon = br.player.spells.charge }
    };
    br.ui:createToggle(MoverModes, "Mover", 3, 0)
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
        -- Basic Trinket Module
        br.player.module.BasicTrinkets(nil, section)
        -- Battle Shout
        br.ui:createCheckbox(section, "Battle Shout")
        -- Charge
        br.ui:createCheckbox(section, "Charge")
        -- Hamstring
        br.ui:createCheckbox(section, "Hamstring")
        -- Heroic Throw
        br.ui:createCheckbox(section, "Heroic Throw")
        -- Victory Rush
        br.ui:createCheckbox(section, "Victory Rush")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Shield Block
        br.ui:createSpinner(section, "Shield Block", 30, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupt")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Pummel
        br.ui:createCheckbox(section, "Pummel", "|cffFFFFFFUse Pummel")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 6)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
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
local buff
local cast
local cd
local enemies
local mode
local module
local ui
local unit
local units
-- General Locals
local haltProfile
local profileStop
-- Profile Specific Locals
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List -Extras
actionList.Extras = function()
    -- Battle Shout
    if ui.checked("Battle Shout") then
        if cast.able.battleShout() and buff.battleShout.refresh() and not unit.resting() then
            if cast.battleShout() then
                ui.debug("Casting Battle Shout")
                return true
            end
        end
    end
    -- Hamstring
    if ui.checked("Hamstring") and cast.able.hamstring("target") and not unit.facing("target", "player") and unit.moving("target") then
        if cast.hamstring("target") then
            ui.debug("Casting Hamstring")
            return true
        end
    end
end -- End Action List -Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        --Shield Block
        if ui.checked("Shield Block") and cast.able.shieldBlock() and unit.exists("target")
            and unit.distance("target") < 5 and unit.hp() < ui.value("Shield Block")
        then
            if cast.shieldBlock() then
                ui.debug("Casting Shield Block")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        -- Pummel
        if ui.checked("Pummel") then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if cast.able.pummel(thisUnit) and unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.pummel(thisUnit) then
                        ui.debug("Casting Pummel on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() and unit.valid("target") then
        -- Whirlwind
        if ui.useAOE(8, 2) and unit.level() >= 9 and cast.able.whirlwind() then
            if cast.whirlwind() then
                ui.debug("Casting Whirlwind")
                return true
            end
        end
        -- Slam
        if (ui.useST(8, 2) or unit.level() < 9) and cast.able.slam("target") then
            if cast.slam("target") then
                ui.debug("Casting Slam")
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
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -- Charge
            if mode.mover == 1 and ui.checked("Charge") and cast.able.charge("target")
                and unit.distance("target") >= 8 and unit.distance("target") <= 25
            then
                if cast.charge("target") then
                    ui.debug("Casting Charge")
                    return true
                end
            end
            -- Heroic Throw
            if ui.checked("Heroic Throw") and cast.able.heroicThrow("target")
                and unit.distance("target") >= 8 and unit.distance("target") <= 25
            then
                if cast.heroicThrow("target") then
                    ui.debug("Casting Heroic Throw")
                    return true
                end
            end
            -- Interrupts
            if actionList.Interrupt() then return true end
            -- Execute
            if unit.inCombat() then
                if unit.hp("target") < 20 and cast.able.execute() then
                    if cast.execute() then
                        ui.debug("Casting Execute")
                        return true
                    end
                end
                -- Victory Rush
                if ui.checked("Victory Rush") and cast.able.victoryRush("target") and buff.victorious.exists() then
                    if cast.victoryRush("target") then
                        ui.debug("Casting Victory Rush")
                        return true
                    end
                end
                -- Start Attack
                if not cast.auto.autoAttack(units.dyn5) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    if cast.autoAttack(units.dyn5) then
                        ui.debug("Casting Auto Attack")
                        return true
                    end
                end
                -- Basic Trinkets Module
                module.BasicTrinkets()
                -- Shield Slam
                if cast.able.shieldSlam() then
                    if cast.shieldSlam() then
                        ui.debug("Casting Shield Slam")
                        return true
                    end
                end
                -- Whirlwind
                if ui.useAOE(8, 2) and unit.level() >= 9 and cast.able.whirlwind() then
                    if cast.whirlwind() then
                        ui.debug("Casting Whirlwind")
                        return true
                    end
                end
                -- Slam
                if (ui.useST(8, 2) or unit.level() < 9) and cast.able.slam() then
                    if cast.slam() then
                        ui.debug("Casting Slam")
                        return true
                    end
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
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    enemies     = br.player.enemies
    mode        = br.player.ui.mode
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or br.pause() or mode.rotation == 2
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(5, "player", false, true) -- Makes a variable called, enemies.yards5f

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
        --------------
        --- Extras ---
        --------------
        if actionList.Extras() then return true end
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
end             -- End runRotation
local id = 1446 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

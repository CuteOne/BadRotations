local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spells.frostBolt },
        [2] = { mode = "Off", value = 4, overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spells.frostBolt }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.frostNova },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.frostNova }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spells.counterspell },
        [2] = { mode = "Off", value = 2, overlay = "Interrupt Disabled", tip = "Disables Interrupt", highlight = 0, icon = br.player.spells.counterspell }
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
        -- Arcane Intellect
        br.ui:createCheckbox(section, "Arcane Intellect")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Forst Nova
        br.ui:createSpinner(section, "Frost Nova", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        --Invisibility
        br.ui:createSpinner(section, "Invisibility", 25, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Counterspell
        br.ui:createCheckbox(section, "Counterspell")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
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
local enemies
local ui
local unit
local units
-- Profile Specific Locals
local profileStop
local haltProfile
local actionList = {}

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Arcane Intellect
    if ui.checked("Arcane Intellect") and cast.able.arcaneIntellect("player") and not buff.arcaneIntellect.exists() then
        if cast.arcaneIntellect("player") then
            ui.debug("Casting Arcane Intellect")
            return true
        end
    end
end
-- Action List - Defensive
actionList.Defensive = function()
    -- Frost Nova
    if ui.checked("Frost Nova") and cast.able.frostNova("player", "aoe", 1, 8) and unit.hp() < ui.value("Frost Nova") then
        if cast.frostNova("player", "aoe", 1, 8) then
            ui.debug("Casting Frost Nova")
            return true
        end
    end
    -- Invisibility
    if ui.checked("Invisibility") and cast.able.invisibility() and unit.hp() < ui.value("Invisibility") then
        if cast.invisibility() then
            ui.debug("Casting Invisibility")
            return true
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if br.functions.spell:canInterrupt(thisUnit, ui.value("Interrupt At")) then
                -- Counterspell
                if br.functions.spell:canInterrupt() then
                    if cast.able.counterspell(thisUnit) and unit.distance(thisUnit) then
                        if cast.counterspell(thisUnit) then
                            ui.debug("Casting Counterspell")
                            return true
                        end
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
            local thisDistance = unit.distance("target") or 99
            if not unit.moving() and thisDistance < 40 then
                if cast.able.frostbolt("target") and (unit.level() < 2 or not cast.last.frostbolt() or cast.timeSinceLast.frostbolt() > unit.gcd(true) + 0.5) then
                    if cast.frostbolt("target") then
                        ui.debug("Casting Frostbolt [Pre-Pull]")
                        return true
                    end
                end
            end
            -- Start Attack
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack [Pre-Combat]")
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
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Arcane Explosion
            if cast.able.arcaneExplosion("player", "aoe", 3, 10) then
                if cast.arcaneExplosion("player", "aoe", 3, 10) then
                    ui.debug("Casting Arcane Explosion")
                    return true
                end
            end
            -- Fire Blast
            if cast.able.fireBlast() then
                if cast.fireBlast() then
                    ui.debug("Casting Fire Blast")
                    return true
                end
            end
            -- Frost Bolt
            if cast.able.frostBolt() and not unit.moving() then
                if cast.frostBolt() then
                    ui.debug("Casting Frost Bolt")
                    return true
                end
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
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    enemies     = br.player.enemies
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or br.functions.misc:pause() or ui.mode.rotation == 2
    -- Units
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(40)

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = br._G.GetTime() end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        br.pauseTime = br._G.GetTime()
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
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
        if actionList.Interrupts() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
    end         -- Pause
end             -- End runRotation
local id = 1449 -- Change to the spec id profile is for.
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

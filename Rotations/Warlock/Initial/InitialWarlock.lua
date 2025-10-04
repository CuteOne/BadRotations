local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1, overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spells.shadowBolt },
        [2] = { mode = "Off", value = 4, overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spells.fear }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.unendingResolve },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.unendingResolve }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    --Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1, overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spells.summonImp },
        [2] = { mode = "2", value = 2, overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spells.summonVoidwalker },
        [3] = { mode = "None", value = 3, overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spells.fear }
    };
    br.ui:createToggle(PetSummonModes, "PetSummon", 3, 0)
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
        -- Corruption
        br.ui:createCheckbox(section, "Use Corruption")
        -- Curse of Weakness
        br.ui:createCheckbox(section, "Use Curse of Weakness")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Drain Life
        br.ui:createSpinner(section, "Drain Life", 40, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
        -- Health Funnel
        br.ui:createSpinner(section, "Health Funnel", 30, 0, 95, 5, "|cffFFFFFFPet Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Player Limit", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to not use below.")
        -- Unending Resolve
        br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
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
local cast
local cd
local debuff
local enemies
local mode
local module
local ui
local pet
local spell
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

-- Action List - Extra
actionList.Extras = function()
    -- Summon Pet
    if not unit.moving() and unit.level() >= 3 and GetTime() - br.pauseTime > 0.5
        and br.debug.timer:useTimer("summonPet", 1)
    then
        if (mode.petSummon == 1 or (mode.petSummon == 2 and not spell.summonVoidwalker.known())) and not pet.imp.active() then
            if cast.summonImp("player") then return true end
        end
        if mode.petSummon == 2 and spell.summonVoidwalker.known() and not pet.voidwalker.active() then
            if cast.summonVoidwalker("player") then return true end
        end
        if mode.petSummon == 3 and (pet.imp.active() or pet.voidwalker.active()) then
            PetDismiss()
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    -- Basic Healing Module
    module.BasicHealing()
    -- Drain Life
    if cast.able.drainLife(units.dyn40) and unit.hp() <= ui.value("Drain Life") and unit.inCombat() then
        if cast.drainLife() then
            ui.debug("Channeling Drain Life")
            return true
        end
    end
    -- Health Funnel
    if cast.able.healthFunnel() and unit.hp("pet") <= ui.value("Health Funnel") and unit.hp("player") > ui.value("Player Limit") then
        if cast.healthFunnel("pet") then
            ui.debug("Channeling Health Funnel")
            return true
        end
    end
    -- Unending Resolve
    if ui.checked("Unending Resolve") and unit.hp() <= ui.value("Unending Resolve") and unit.inCombat() then
        if cast.unendingResolve() then
            ui.debug("Casting Unending Resolve")
            return true
        end
    end
end -- End Action List - Defensive

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Corruption
            if cast.able.corruption("target") and ui.checked("Use Corruption")
                and debuff.corruption.refresh("target") and not unit.moving()
                and cast.timeSinceLast.corruption("target") > unit.gcd(true) + 2
            then
                if cast.corruption("target") then
                    ui.debug("Casting Corruption [Precombat]")
                    return true
                end
            end
            -- Shadow Bolt
            if cast.able.shadowBolt("target") and not unit.moving() then
                if cast.shadowBolt("target") then
                    ui.debug("Casting Shadow Bolt [Precombat]")
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
end -- End Action List - PreCombat

actionList.Combat = function()
    if unit.valid("target") and cd.global.remain() == 0 then
        if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
            -- Start Attack
            if cast.able.autoAttack() then
                if cast.autoAttack() then
                    ui.debug("Casting Auto Attack")
                    return true
                end
            end
            -- Corruption
            if ui.checked("Use Corruption") and not unit.moving() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if cast.able.corruption(thisUnit) and debuff.corruption.refresh(thisUnit) then
                        if cast.corruption(thisUnit) then
                            ui.debug("Casting Corruption")
                            return true
                        end
                    end
                end
            end
            -- if cast.able.corruption("target") and ui.checked("Use Corruption")
            --     and debuff.corruption.refresh("target") and not unit.moving()
            -- then
            --     if cast.corruption("target") then
            --         ui.debug("Casting Corruption")
            --         return true
            --     end
            -- end
            -- Curse of Weakness
            if cast.able.curseOfWeakness() and ui.checked("Use Curse of Weakness")
                and debuff.curseOfWeakness.refresh(units.dyn40)
            then
                if cast.curseOfWeakness() then
                    ui.debug("Casting Curse of Weakness")
                    return true
                end
            end
            -- Shadow Bolt
            if cast.able.shadowBolt() and not unit.moving() then
                if cast.shadowBolt() then
                    ui.debug("Casting Shadow Bolt")
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
    cast        = br.player.cast
    cd          = br.player.cd
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    mode        = br.player.ui.mode
    module      = br.player.module
    ui          = br.player.ui
    pet         = br.player.pet
    spell       = br.player.spell
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or unit.mounted() or ui.pause() or mode.rotation == 2
    -- Units
    units.get(5)  -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40
    units.get(40, true)
    -- Enemies
    enemies.get(40, "player", false, true) -- Makes a variable called, enemies.yards40f

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
        --------------
        --- Combat ---
        --------------
        if actionList.Combat() then return true end
    end         -- Pause
end             -- End runRotation
local id = 1454 -- Change to the spec id profile is for.
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

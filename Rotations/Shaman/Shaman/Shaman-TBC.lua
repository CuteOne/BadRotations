local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spells.chainLightning },
        [2] = { mode = "Multi", value = 2, overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation.", highlight = 0, icon = br.player.spells.chainLightning },
        [3] = { mode = "Single", value = 3, overlay = "Single Target Rotation", tip = "Forces Single Target Rotation.", highlight = 0, icon = br.player.spells.lightningBolt },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.healingWave }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.heroism },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.heroism },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.heroism }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.healingWave },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.healingWave }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.windShear },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.windShear }
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
            -- Purge
            br.ui:createCheckbox(section,"Purge")
        br.ui:checkSectionState(section)
        --------------------------
        --- TOTEM MANAGEMENT ---
        --------------------------
        section = br.ui:createSection(br.ui.window.profile, "Totem Management")
            -- Earth Totems
            br.ui:createDropdownWithout(section, "Earth Totem", {"Stoneskin Totem", "Strength of Earth Totem", "None"}, 1)
        br.ui:checkSectionState(section)
        ---------------------
        --- BUFF OPTIONS ---
        ---------------------
        section = br.ui:createSection(br.ui.window.profile, "Buffs")
        -- Shield's Up
        br.ui:createDropdownWithout(section, "Shield's Up", {"Lightning Shield", "Water Shield", "None"}, 1)
        -- Weapon's Online
        br.ui:createDropdownWithout(section, "MH Weapon's Online", {"Rockbiter Weapon", "Flametongue Weapon", "Frostbrand Weapon", "None"}, 1)
        br.ui:createDropdownWithout(section, "OH Weapon's Online", {"Rockbiter Weapon", "Flametongue Weapon", "Frostbrand Weapon", "None"}, 2)
        -- Water Shield Swap At
        br.ui:createSpinnerWithout(section, "Water Shield Swap At", 30, 0, 100, 5, "|cffFFFFFFMana Percent to Swap to Water Shield")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
            -- Healing Wave
            br.ui:createSpinner(section, "Healing Wave", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Stoneclaw Totem
            br.ui:createSpinner(section, "Stoneclaw Totem Defensive", 45, 0, 100, 5,
                "|cffFFFFFFHealth Percent to Cast At (requires Earth Totem = Stoneclaw Totem and no tank nearby)")
            -- OOC Healing
            br.ui:createCheckbox(section, "OOC Healing",
                "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFout of combat healing|cffFFBB00.")
        br.ui:checkSectionState(section)
        -------------------------
        --- Interrupt Options ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.ui.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
        -- Interrupt Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle, 6)
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
-- BR API Locals - Many of these are located from System/API, this is a sample of commonly used ones but no all inclusive
local buff
local cast
local cd
local debuff
local enemies
local mana
local module
local ui
local unit
local units
local spell
local totem
local var = {}
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}


-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------


--------------------
--- Action Lists ---
--------------------

-- Action List - Extra
actionList.Extra = function()
    -- * Lightning Shield
    if ui.value("Shield's Up") == 1 and cast.able.lightningShield() and not buff.lightningShield.exists()
        and (mana.percent() >= math.min(100, ui.value("Water Shield Swap At") * 2)
            or not ui.value("Shield's Up") == 2 or not spell.waterShield.known())
    then
        if cast.lightningShield() then ui.debug("Casting Lightning Shield [Extra]") return true end
    end
    -- * Rockbiter Weapon
    if ui.value("MH Weapon's Online") == 1 and cast.able.rockbiterWeapon()
        and not (unit.weaponImbue.exists(29) or unit.weaponImbue.exists(6))
    then
        if cast.rockbiterWeapon("player") then ui.debug("Casting Rockbiter Weapon - Main [Extra]") return true end
    end
    if ui.value("OH Weapon's Online") == 1 and cast.able.rockbiterWeapon()
        and not (unit.weaponImbue.exists(29,true) or unit.weaponImbue.exists(6,true))
    then
        if cast.rockbiterWeapon("player") then ui.debug("Casting Rockbiter Weapon - Off [Extra]") return true end
    end
    -- * Purge
    if ui.checked("Purge") and cast.able.purge() and cast.dispel.purge("target") and not unit.isBoss() and unit.exists("target") then
        if cast.purge() then ui.debug("Casting Purge [Extra]") return true end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- * Ancestral Spirit
        if ui.checked("Ancestral Spirit") and cast.timeSinceLast.ancestralSpirit() > 5 then
            if ui.value("Ancestral Spirit")==1 and cast.able.ancestralSpirit("target","dead") and unit.player("target") then
                if cast.ancestralSpirit("target","dead") then ui.debug("Casting Ancestral Spirit - Target [Defensive]") return true end
            end
            if ui.value("Ancestral Spirit")==2 and cast.able.ancestralSpirit("mouseover","dead") and unit.player("mouseover") then
                if cast.ancestralSpirit("mouseover","dead") then ui.debug("Casting Ancestral Spirit - Mouseover [Defensive]") return true end
            end
        end
        -- * Healing Wave
        if ui.checked("Healing Wave") and cast.able.healingWave() and not unit.moving() then
            if unit.friend("target") and unit.hp("target") <= ui.value("Healing Wave") then
                if cast.healingWave("target") then
                    ui.debug("Casting Healing Wave on " .. unit.name("target") .. " [Defensive]")
                    return true
                end
            elseif unit.hp("player") <= ui.value("Healing Wave") then
                if cast.healingWave("player") then
                    ui.debug("Casting Healing Wave on " .. unit.name("player") .. " [Defensive]")
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- * Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true)) then
        local thisUnit

    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if unit.distance("target") < 5 then
        -- * Module- Basic Trinkets
        -- use_items
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - Totem Management
actionList.TotemManagement = function()
    -- * Fire Totems
    -- Fire Nova Totem
    if cast.able.fireNovaTotem("player","aoe",1,10) and ui.useAOE(2,10)
        and (unit.inCombat() or (unit.valid("target") and unit.distance("target") < 10))
        and not totem.fire.fireNova.exists() and unit.standingTime() > 1
    then
        if cast.fireNovaTotem("player","aoe",1,10) then ui.debug("Casting Fire Nova Totem [AOE]") return true end
    end
    -- * Earth Totems
    -- Stoneclaw Totem
    if ui.checked("Stoneclaw Totem Defensive") and ui.value("Earth Totem") == 2 and cast.able.stoneclawTotem()
        and unit.inCombat() and unit.hp("player") <= ui.value("Stoneclaw Totem Defensive") and unit.standingTime() > 1
    then
        local tankInRange = unit.isTankInRange()
        local stoneclawExists = totem.earth.stoneclaw and totem.earth.stoneclaw.exists and totem.earth.stoneclaw.exists()
        local stoneclawDistance = (totem.earth.stoneclaw and totem.earth.stoneclaw.distance and totem.earth.stoneclaw.distance()) or 99
        if not tankInRange and enemies.yards15 > 0 and (not stoneclawExists or stoneclawDistance > 15) then
            if cast.stoneclawTotem() then
                ui.debug("Casting Stoneclaw Totem [Defensive]")
                return true
            end
        end
    end
    -- Stoneskin Totem
    if ui.value("Earth Totem") == 1 and cast.able.stoneskinTotem()
        and (unit.inCombat() or (unit.valid("target") and unit.distance("target") < 20))
        and (not totem.earth.stoneskin.exists() or totem.earth.stoneskin.distance() > 20) and unit.standingTime() > 1
    then
        if cast.stoneskinTotem() then ui.debug("Casting Stoneskin Totem [Totem Management]") return true end
    end
    -- Strength of Earth Totem
    if ui.value("Earth Totem") == 2 and cast.able.strengthOfEarthTotem()
        and (unit.inCombat() or (unit.valid("target") and unit.distance("target") < 20))
        and (not totem.earth.strengthOfEarth.exists() or totem.earth.strengthOfEarth.distance() > 20) and unit.standingTime() > 1
    then
        if cast.strengthOfEarthTotem() then ui.debug("Casting Strength of Earth Totem [Totem Management]") return true end
    end
end -- End Action List - Totem Management

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if unit.valid("target") and unit.exists("target") then
            if unit.distance("target") > 5 then
                -- Lightning Bolt
                if cast.able.lightningBolt("target") and not unit.moving() then --and var.useLightningBolt then
                    if cast.lightningBolt("target") then
                        ui.debug("Casting Lightning Bolt [Precombat]")
                        return true
                    end
                end
                -- Flame Shock
                if cast.able.flameShock("target") then
                    if cast.flameShock("target") then
                        ui.debug("Casting Flame Shock [Precombat]")
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
                -- -- Primal Strike
                -- if cast.able.primalStrike("target") then
                --     if cast.primalStrike("target") then
                --         ui.debug("Casting Primal Strike [Precombat]")
                --         return true
                --     end
                -- end
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
    -- if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
    --     if unit.valid("target") then
    --         local thisDistance = unit.distance("target") or 99

    --         if thisDistance < 5 then
    --             -- Auto Attack
    --             if not cast.auto.autoAttack() and unit.valid("target") and not unit.deadOrGhost("target") and unit.distance("target") < 5 then
    --                 br._G.StartAttack()
    --                 ui.debug("Casting Auto Attack [Precombat]")
    --                 return true
    --             end
    --         end
    --     end
    -- end
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
        -- Flame Shock
        if cast.able.flameShock() and debuff.flameShock.refresh(units.dyn5) and unit.ttd(units.dyn5) > 6 then
            if cast.flameShock() then
                ui.debug("Casting Flame Shock [Combat]")
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
        -- -- Primal Strike
        -- if cast.able.primalStrike() then
        --     if cast.primalStrike() then
        --         ui.debug("Casting Primal Strike [Combat]")
        --         return true
        --     end
        -- end
        -- Lightning Bolt
        if cast.able.lightningBolt() and not unit.moving()
            and (unit.distance(units.dyn5) > 10 or mana.percent() > 50)-- or unit.ttd(units.dyn5) < 3)
        then--and var.useLightningBolt then
            if cast.lightningBolt() then
                ui.debug("Casting Lightning Bolt [Combat]")
                return true
            end
        end
    end -- End Combat Check
end     -- End Action list - Combat

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
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    mana        = br.player.power.mana
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell
    totem       = br.player.totem
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716

    -- Units
    units.get(5)        -- Makes a variable called, "target"
    -- units.get(40)       -- Makes a variable called, units.dyn40
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(15)     -- Makes a varaible called, enemies.yards15
    -- enemies.get(20)     -- Makes a varaible called, enemies.yards20
    -- enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(40)     -- Makes a varaible called, enemies.yards40


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
        -----------------------
        --- Totem Management ---
        -----------------------
        if actionList.TotemManagement() then return true end
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
local id = 261 -- Change to the spec id profile is for.
local expansion = br.isBC -- Change to the expansion the profile is for.
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

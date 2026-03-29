-------------------------------------------------------
-- Author      = CuteOne
-- Patch       = 2.4.3
-- Coverage    = 85%
--    Rotation logic is sourced from the wowsims/tbc Enhancement Shaman simulator:
--    https://github.com/wowsims/tbc/tree/master/sim/shaman/enhancement
-- Status      = Limited
-- Readiness   = NoRaid
-------------------------------------------------------

local rotationName = "Wowsims"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto",   value = 1, overlay = "Automatic Rotation",     tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spells.stormstrike },
        [2] = { mode = "Multi",  value = 2, overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation.",   highlight = 0, icon = br.player.spells.chainLightning },
        [3] = { mode = "Single", value = 3, overlay = "Single Target Rotation",   tip = "Forces Single Target Rotation.",     highlight = 0, icon = br.player.spells.stormstrike },
        [4] = { mode = "Off",    value = 4, overlay = "DPS Rotation Disabled",    tip = "Disable DPS Rotation.",              highlight = 0, icon = br.player.spells.healingWave },
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.heroism },
        [2] = { mode = "On",   value = 2, overlay = "Cooldowns Enabled",   tip = "Cooldowns used regardless of target.",  highlight = 0, icon = br.player.spells.heroism },
        [3] = { mode = "Off",  value = 3, overlay = "Cooldowns Disabled",  tip = "No Cooldowns will be used.",            highlight = 0, icon = br.player.spells.heroism },
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On",  value = 1, overlay = "Defensive Enabled",  tip = "Includes Defensive Cooldowns.",     highlight = 1, icon = br.player.spells.healingWave },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.healingWave },
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On",  value = 1, overlay = "Interrupts Enabled",  tip = "Includes Basic Interrupts.",     highlight = 1, icon = br.player.spells.earthShock },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.earthShock },
    }
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
            -- Primary Shock: wowsims schedules a shock every 6s on a shared CD.
            -- Earth Shock is the default; Frost Shock is an alternative.
            br.ui:createDropdownWithout(section, "Primary Shock", { "Earth Shock", "Frost Shock", "None" }, 1,
                "|cffFFFFFFShock spell to cast on the 6s shared shock cooldown.")
            -- Flame Shock weave: from wowsims WeaveFlameShock option.
            -- When enabled, Flame Shock is cast instead of the primary shock whenever
            -- the DoT is not active, then the rotation falls back to the primary shock.
            br.ui:createCheckbox(section, "Weave Flame Shock",
                "|cffFFFFFFCast Flame Shock in place of the primary shock when the DoT is not active.")
        br.ui:checkSectionState(section)
        ---------------------
        --- BUFF OPTIONS ---
        ---------------------
        section = br.ui:createSection(br.ui.window.profile, "Buffs")
            -- Shield
            br.ui:createDropdownWithout(section, "Shield", { "Lightning Shield", "Water Shield", "None" }, 1,
                "|cffFFFFFFShield buff to maintain.")
            -- Water Shield swap threshold
            br.ui:createSpinnerWithout(section, "Water Shield Swap At", 30, 0, 100, 5,
                "|cffFFFFFFMana percent at which to swap from Lightning Shield to Water Shield.")
            -- MH Weapon imbue: wowsims default is Windfury on main hand.
            br.ui:createDropdownWithout(section, "MH Weapon", { "Windfury Weapon", "Flametongue Weapon", "Rockbiter Weapon", "None" }, 1,
                "|cffFFFFFFWeapon imbue for main hand.")
            -- OH Weapon imbue: wowsims default is Flametongue on off-hand.
            br.ui:createDropdownWithout(section, "OH Weapon", { "Flametongue Weapon", "Windfury Weapon", "Rockbiter Weapon", "None" }, 1,
                "|cffFFFFFFWeapon imbue for off-hand (requires dual wield).")
        br.ui:checkSectionState(section)
        --------------------------
        --- TOTEM MANAGEMENT ---
        --------------------------
        section = br.ui:createSection(br.ui.window.profile, "Totem Management")
            -- Fire: Searing is the standard single-target fire totem in the wowsims preset.
            br.ui:createDropdownWithout(section, "Fire Totem", { "Searing Totem", "Magma Totem", "Fire Nova Totem", "None" }, 1,
                "|cffFFFFFFFire totem to maintain.")
            -- Air: Windfury Totem is the highest-value air totem for melee groups.
            br.ui:createDropdownWithout(section, "Air Totem", { "Windfury Totem", "Grace of Air Totem", "None" }, 1,
                "|cffFFFFFFAir totem to maintain.")
            -- Earth: Strength of Earth is the standard pick for Enhancement.
            br.ui:createDropdownWithout(section, "Earth Totem", { "Strength of Earth Totem", "Stoneskin Totem", "None" }, 1,
                "|cffFFFFFFEarth totem to maintain.")
            -- Water: Mana Spring helps sustain in long fights.
            br.ui:createDropdownWithout(section, "Water Totem", { "Mana Spring Totem", "None" }, 1,
                "|cffFFFFFFWater totem to maintain.")
        br.ui:checkSectionState(section)
        -------------------------
        --- COOLDOWN OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Bloodlust / Heroism: wowsims schedules Bloodlust via the CD system.
            br.ui:createCheckbox(section, "Bloodlust",
                "|cffFFFFFFUse Bloodlust (Horde) or Heroism (Alliance) when Cooldowns are active.")
            -- Shamanistic Rage: strong mana-recovery CD; default to Cooldowns only.
            br.ui:createDropdownWithout(section, "Shamanistic Rage", { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }, 2,
                "|cffFFFFFFWhen to use Shamanistic Rage.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Ancestral Spirit
            br.ui:createDropdown(section, "Ancestral Spirit", { "|cffFFFF00Selected Target", "|cffFF0000Mouseover Target" }, 1,
                "|cffFFFFFFTarget to resurrect with Ancestral Spirit.")
            -- Healing Wave
            br.ui:createSpinner(section, "Healing Wave", 50, 0, 100, 5,
                "|cffFFFFFFHealth percent at which to cast Healing Wave.")
            -- OOC Healing
            br.ui:createCheckbox(section, "OOC Healing",
                "|cffFFFFFFCast Healing Wave on self when out of combat.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt percent
            br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
                "|cffFFFFFFCast percent at which to interrupt (0 = random).")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            br.ui:createDropdownWithout(section, "Rotation Mode",  br.ui.dropOptions.Toggle, 4)
            br.ui:createDropdownWithout(section, "Cooldown Mode",  br.ui.dropOptions.Toggle, 3)
            br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
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
local buff
local cast
local cd
local debuff
local enemies
local mana
local module
local spell
local totem
local ui
local unit
local units
local var = {}

local haltProfile
local profileStop
local actionList = {}

--------------------
--- Action Lists ---
--------------------

-- Action List - Extra
-- Maintains weapon imbues and shield out of and in combat.
actionList.Extra = function()
    -- *** WEAPON IMBUES ***
    -- Main Hand: Windfury Weapon (enchant ID 283)
    -- wowsims default: MH Windfury is the highest-value imbue for Enhancement.
    if ui.value("MH Weapon") == 1 and cast.able.windfuryWeapon()
        and not unit.weaponImbue.exists(283)
    then
        if cast.windfuryWeapon("player") then ui.debug("Casting Windfury Weapon - MH [Extra]") return true end
    end
    -- Main Hand: Flametongue Weapon (enchant ID 5)
    if ui.value("MH Weapon") == 2 and cast.able.flametongueWeapon()
        and not unit.weaponImbue.exists(5)
    then
        if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon - MH [Extra]") return true end
    end
    -- Main Hand: Rockbiter Weapon (enchant IDs 29, 6)
    if ui.value("MH Weapon") == 3 and cast.able.rockbiterWeapon()
        and not (unit.weaponImbue.exists(29) or unit.weaponImbue.exists(6))
    then
        if cast.rockbiterWeapon("player") then ui.debug("Casting Rockbiter Weapon - MH [Extra]") return true end
    end
    -- Off Hand: Flametongue Weapon (enchant ID 5)
    -- wowsims default: OH Flametongue is the standard off-hand imbue.
    if ui.value("OH Weapon") == 1 and cast.able.flametongueWeapon()
        and unit.dualWielding() and not unit.weaponImbue.exists(5, true)
    then
        if cast.flametongueWeapon("player") then ui.debug("Casting Flametongue Weapon - OH [Extra]") return true end
    end
    -- Off Hand: Windfury Weapon (enchant ID 283)
    if ui.value("OH Weapon") == 2 and cast.able.windfuryWeapon()
        and unit.dualWielding() and not unit.weaponImbue.exists(283, true)
    then
        if cast.windfuryWeapon("player") then ui.debug("Casting Windfury Weapon - OH [Extra]") return true end
    end
    -- Off Hand: Rockbiter Weapon (enchant IDs 29, 6)
    if ui.value("OH Weapon") == 3 and cast.able.rockbiterWeapon()
        and unit.dualWielding()
        and not (unit.weaponImbue.exists(29, true) or unit.weaponImbue.exists(6, true))
    then
        if cast.rockbiterWeapon("player") then ui.debug("Casting Rockbiter Weapon - OH [Extra]") return true end
    end
    -- *** SHIELDS ***
    -- Lightning Shield: maintain above the Water Shield swap threshold.
    if ui.value("Shield") == 1 and cast.able.lightningShield()
        and not buff.lightningShield.exists()
        and mana.percent() > ui.value("Water Shield Swap At")
    then
        if cast.lightningShield("player") then ui.debug("Casting Lightning Shield [Extra]") return true end
    end
    -- Water Shield: use when selected as the preferred shield, OR when mana drops below
    -- the swap threshold while Lightning Shield is selected.
    if cast.able.waterShield()
        and not buff.waterShield.exists()
        and (ui.value("Shield") == 2 or (ui.value("Shield") == 1 and mana.percent() <= ui.value("Water Shield Swap At")))
    then
        if cast.waterShield("player") then ui.debug("Casting Water Shield [Extra]") return true end
    end
    -- *** PURGE ***
    if cast.able.purge() and cast.dispel.purge("target")
        and not unit.isBoss() and unit.exists("target")
    then
        if cast.purge() then ui.debug("Casting Purge [Extra]") return true end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- * Ancestral Spirit
        if ui.checked("Ancestral Spirit") and cast.timeSinceLast.ancestralSpirit() > 5 then
            if ui.value("Ancestral Spirit") == 1 and cast.able.ancestralSpirit("target", "dead") and unit.player("target") then
                if cast.ancestralSpirit("target", "dead") then ui.debug("Casting Ancestral Spirit - Target [Defensive]") return true end
            end
            if ui.value("Ancestral Spirit") == 2 and cast.able.ancestralSpirit("mouseover", "dead") and unit.player("mouseover") then
                if cast.ancestralSpirit("mouseover", "dead") then ui.debug("Casting Ancestral Spirit - Mouseover [Defensive]") return true end
            end
        end
        -- * Healing Wave (on self or friendly target)
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
        -- * OOC Healing Wave
        if ui.checked("OOC Healing") and not unit.inCombat()
            and cast.able.healingWave("player") and not unit.moving()
            and unit.hp("player") < 95
        then
            if cast.healingWave("player") then ui.debug("Casting Healing Wave - OOC [Defensive]") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
-- Earth Shock is the only interrupt available to TBC Shaman (Wind Shear is WotLK+).
-- It shares the 6s shock CD, so interrupt usage will delay the primary shock.
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true)) then
        local thisUnit
        for i = 1, #enemies.yards20 do
            thisUnit = enemies.yards20[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                if cast.able.earthShock(thisUnit) then
                    if cast.earthShock(thisUnit) then
                        ui.debug("Casting Earth Shock (interrupt) on " .. unit.name(thisUnit) .. " [Interrupts]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Cooldowns
-- wowsims schedules Bloodlust and uses Shamanistic Rage as an OOM recovery CD.
actionList.Cooldowns = function()
    if ui.useCooldown() then
        -- * Bloodlust (Horde) / Heroism (Alliance)
        if ui.checked("Bloodlust") then
            if cast.able.bloodlust() then
                if cast.bloodlust() then ui.debug("Casting Bloodlust [Cooldowns]") return true end
            end
            if cast.able.heroism() then
                if cast.heroism() then ui.debug("Casting Heroism [Cooldowns]") return true end
            end
        end
        -- * Shamanistic Rage: wowsims uses this to recover from OOM states.
        -- Cast when below 80% mana so it doesn't waste the mana gain.
        if ui.alwaysCdNever("Shamanistic Rage") and cast.able.shamanisticRage()
            and mana.percent() < 80 and unit.inCombat()
        then
            if cast.shamanisticRage() then ui.debug("Casting Shamanistic Rage [Cooldowns]") return true end
        end
    end
    -- * Trinkets
    if unit.distance("target") < 5 then
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - Totem Management
-- wowsims drops attack totems (Searing/Magma) immediately on combat entry and
-- refreshes them when they expire. 2-minute buff totems (Windfury, Strength of Earth,
-- Mana Spring) are dropped on pull and refreshed at ~1:55.
-- All drops are gated by unit.standingTime() > 1 to avoid dropping while repositioning.
actionList.TotemManagement = function()
    local inCombatOrEngaging = unit.inCombat() or (unit.valid("target") and unit.distance("target") < 30)
    if not inCombatOrEngaging then return end

    local standing = unit.standingTime() > 1

    -- *** FIRE TOTEM ***
    -- Searing Totem (option 1) — 1-minute attack totem, best single-target fire totem.
    if ui.value("Fire Totem") == 1 and standing and cast.able.searingTotem("player")
        and not totem.fire.searing.exists()
    then
        if cast.searingTotem("player") then ui.debug("Casting Searing Totem [Totem Management]") return true end
    end
    -- Magma Totem (option 2) — 20-second AoE fire totem.
    if ui.value("Fire Totem") == 2 and standing and cast.able.magmaTotem("player")
        and not totem.fire.magma.exists()
    then
        if cast.magmaTotem("player") then ui.debug("Casting Magma Totem [Totem Management]") return true end
    end
    -- Fire Nova Totem (option 3) — drop when not active for on-demand AoE.
    if ui.value("Fire Totem") == 3 and standing and cast.able.fireNovaTotem("player", "aoe", 1, 10)
        and not totem.fire.fireNova.exists()
    then
        if cast.fireNovaTotem("player", "aoe", 1, 10) then ui.debug("Casting Fire Nova Totem [Totem Management]") return true end
    end

    -- *** AIR TOTEM ***
    -- Windfury Totem (option 1) — highest-value air totem for melee groups.
    if ui.value("Air Totem") == 1 and standing and cast.able.windfuryTotem()
        and (not totem.air.windfury.exists() or totem.air.windfury.distance() > 30)
    then
        if cast.windfuryTotem() then ui.debug("Casting Windfury Totem [Totem Management]") return true end
    end
    -- Grace of Air Totem (option 2) — agility-based alternative.
    if ui.value("Air Totem") == 2 and standing and cast.able.graceOfAirTotem()
        and (not totem.air.graceOfAir.exists() or totem.air.graceOfAir.distance() > 30)
    then
        if cast.graceOfAirTotem() then ui.debug("Casting Grace of Air Totem [Totem Management]") return true end
    end

    -- *** EARTH TOTEM ***
    -- Strength of Earth Totem (option 1) — best earth totem for Enhancement.
    if ui.value("Earth Totem") == 1 and standing and cast.able.strengthOfEarthTotem()
        and (not totem.earth.strengthOfEarth.exists() or totem.earth.strengthOfEarth.distance() > 20)
    then
        if cast.strengthOfEarthTotem() then ui.debug("Casting Strength of Earth Totem [Totem Management]") return true end
    end
    -- Stoneskin Totem (option 2) — armor-based alternative.
    if ui.value("Earth Totem") == 2 and standing and cast.able.stoneskinTotem()
        and (not totem.earth.stoneskin.exists() or totem.earth.stoneskin.distance() > 20)
    then
        if cast.stoneskinTotem() then ui.debug("Casting Stoneskin Totem [Totem Management]") return true end
    end

    -- *** WATER TOTEM ***
    -- Mana Spring Totem (option 1) — helps sustain casters in the group.
    if ui.value("Water Totem") == 1 and standing and cast.able.manaSpringTotem()
        and (not totem.water.manaSpring.exists() or totem.water.manaSpring.distance() > 30)
    then
        if cast.manaSpringTotem() then ui.debug("Casting Mana Spring Totem [Totem Management]") return true end
    end
end -- End Action List - Totem Management

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if unit.valid("target") and unit.exists("target") then
            if unit.distance("target") < 5 then
                -- Ensure auto-attack is running before the pull.
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [PreCombat]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
-- Priority order mirrors the wowsims GCD schedule:
--   1. Stormstrike  (10s CD) — always highest priority
--   2. Flame Shock weave — replace the shock slot when DoT is not active
--   3. Primary Shock (Earth or Frost) — fires on the 6s shared shock CD
--
-- The shared shock CD means only one of steps 2-3 can fire per window.
-- cast.able.* already incorporates the cooldown check, so no explicit cd.*.ready()
-- guards are needed.
actionList.Combat = function()
    if (unit.inCombat() or (not unit.inCombat() and unit.valid(units.dyn5)))
        and not var.profileStop
        and unit.exists(units.dyn5)
        and cd.global.remain() == 0
    then
        -- Auto Attack
        if cast.able.autoAttack("target") then
            if cast.autoAttack("target") then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end

        -- Stormstrike: wowsims schedules this first with the highest priority.
        -- 10s cooldown; hits with both weapons and applies the nature damage debuff.
        if cast.able.stormstrike(units.dyn5) then
            if cast.stormstrike(units.dyn5) then
                ui.debug("Casting Stormstrike [Combat]")
                return true
            end
        end

        -- Flame Shock Weave: replaces the primary shock when the DoT is not active.
        -- Once the DoT is up the rotation falls back to the primary shock until
        -- the 12s DoT expires and the cycle repeats.
        if ui.checked("Weave Flame Shock")
            and cast.able.flameShock(units.dyn5)
            and not debuff.flameShock.exists(units.dyn5)
        then
            if cast.flameShock(units.dyn5) then
                ui.debug("Casting Flame Shock - Weave [Combat]")
                return true
            end
        end

        -- Earth Shock: primary shock; also used for interrupts (see actionList.Interrupts).
        -- wowsims default PrimaryShock is Earth.
        if ui.value("Primary Shock") == 1 and cast.able.earthShock(units.dyn5) then
            if cast.earthShock(units.dyn5) then
                ui.debug("Casting Earth Shock [Combat]")
                return true
            end
        end

        -- Frost Shock: alternative primary shock for kiting / slow utility.
        if ui.value("Primary Shock") == 2 and cast.able.frostShock(units.dyn5) then
            if cast.frostShock(units.dyn5) then
                ui.debug("Casting Frost Shock [Combat]")
                return true
            end
        end

    end -- End Combat Check
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    buff        = br.player.buff
    cast        = br.player.cast
    cd          = br.player.cd
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    mana        = br.player.power.mana
    module      = br.player.module
    spell       = br.player.spell
    totem       = br.player.totem
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716
    -- Units (melee range primary target; 40-yard AoE list)
    units.get(5)
    units.get(40, true)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(20)
    enemies.get(40)

    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    if not unit.inCombat() and not unit.exists("target") and profileStop then
        profileStop = false
    elseif haltProfile then
        return true
    else
        -- Weapon imbues, shields, purge
        if actionList.Extra() then return true end
        -- Survivability
        if actionList.Defensive() then return true end
        -- Interrupt (Earth Shock) — before combat priority so interrupts are not delayed
        if actionList.Interrupts() then return true end
        -- Major CDs: Bloodlust, Shamanistic Rage, trinkets
        if actionList.Cooldowns() then return true end
        -- Drop / refresh totems
        if actionList.TotemManagement() then return true end
        -- Pull setup
        if actionList.PreCombat() then return true end
        -- Main DPS rotation
        if actionList.Combat() then return true end
    end
    return true
end -- End runRotation

-- Register the profile under the TBC Shaman ID.
-- TBC does not use spec-specific IDs at runtime; all Shaman profiles share id = 261.
-- The rotation name "Wowsims" differentiates this entry in the dropdown alongside
-- other profiles registered under the same ID.
local id = 261
br.loader.rotations[id] = br.loader.rotations[id] or {}
if br.api.expansion == "TBC" then
    br._G.tinsert(br.loader.rotations[id], {
        name     = rotationName,
        toggles  = createToggles,
        options  = createOptions,
        run      = runRotation,
    })
end

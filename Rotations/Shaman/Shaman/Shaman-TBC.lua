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
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.earthShock },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.earthShock }
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
            -- Searing Totem (always-on fire slot)
            br.ui:createCheckbox(section, "Searing Totem",
                "|cffFFFFFFMaintain Searing Totem in the fire slot.")
            -- AoE Fire Totem — overrides Searing when enemy count meets threshold
            br.ui:createDropdownWithout(section, "AoE Fire Totem", {"Magma Totem", "Fire Nova Totem", "None"}, 1,
                "|cffFFFFFFOverrides Searing Totem when enemies within 8 yards meets threshold.")
            br.ui:createSpinnerWithout(section, "AoE Fire At", 3, 2, 10, 1,
                "|cffFFFFFFEnemy count within 8 yards to trigger AoE fire override.")
            -- Air Totem
            br.ui:createDropdownWithout(section, "Air Totem", {"Windfury Totem", "Grace of Air Totem", "None"}, 1,
                "|cffFFFFFFAir totem to maintain.")
            -- Tremor Totem (reactive — drops on fear or charm)
            br.ui:createCheckbox(section, "Tremor Totem",
                "|cffFFFFFFReactively drop Tremor Totem when fear or charm is detected on the player.")
            -- Earth Totem (always-on)
            br.ui:createDropdownWithout(section, "Earth Totem", {"Stoneskin Totem", "Strength of Earth Totem", "None"}, 1)
            -- Mana Spring Totem (always-on water slot)
            br.ui:createCheckbox(section, "Mana Spring Totem",
                "|cffFFFFFFMaintain Mana Spring Totem in the water slot.")
        br.ui:checkSectionState(section)
        ---------------------
        --- BUFF OPTIONS ---
        ---------------------
        section = br.ui:createSection(br.ui.window.profile, "Buffs")
        -- Shield's Up
        br.ui:createDropdownWithout(section, "Shield's Up", {"Lightning Shield", "Water Shield", "None"}, 1)
        -- Weapon's Online (index matches imbueKeys table; option 5 = None / off)
        br.ui:createDropdownWithout(section, "MH Weapon's Online", {"Rockbiter Weapon", "Flametongue Weapon", "Frostbrand Weapon", "Windfury Weapon", "None"}, 1)
        br.ui:createDropdownWithout(section, "OH Weapon's Online", {"Rockbiter Weapon", "Flametongue Weapon", "Frostbrand Weapon", "Windfury Weapon", "None"}, 2)
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
                "|cffFFFFFFHealth Percent to Cast At (requires no tank nearby)")
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
local imbues
local imbueKeys = { "rockbiterWeapon", "flametongueWeapon", "frostbrandWeapon", "windfuryWeapon" } -- index matches MH/OH dropdown (1-4); index 5 = None
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
    -- * Main Hand Weapon Imbue
    local mhImbueSpell = imbueKeys[ui.value("MH Weapon's Online")]
    if mhImbueSpell and unit.weaponImbue.needed(imbues[mhImbueSpell]) and cast.able[mhImbueSpell]() then
        if cast[mhImbueSpell]("player") then
            ui.debug("Casting " .. unit.weaponImbue.spellName(mhImbueSpell) .. " - Main Hand [Extra]")
            return true
        end
    end
    -- * Off Hand Weapon Imbue
    local ohImbueSpell = imbueKeys[ui.value("OH Weapon's Online")]
    if ohImbueSpell and unit.weaponImbue.needed(imbues[ohImbueSpell], true) and cast.able[ohImbueSpell]() then
        if cast[ohImbueSpell]("player") then
            ui.debug("Casting " .. unit.weaponImbue.spellName(ohImbueSpell) .. " - Off Hand [Extra]")
            return true
        end
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
        -- * Earth Shock (20-yard instant interrupt, locks spell school for 2 sec)
        for i = 1, #enemies.yards20 do
            thisUnit = enemies.yards20[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                if cast.able.earthShock(thisUnit) then
                    if cast.earthShock(thisUnit) then
                        ui.debug("Casting Earth Shock on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
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
    local standing      = unit.standingTime() > 1
    -- totem.*.distance() always measures from the PLAYER to the totem (API limitation).
    --   Buff totems (Air/Earth/Water): re-drop when totem.distance() > X — correct, since
    --     the buff radiates from the totem and must stay near the player/group.
    --   Attack totems (Searing/Magma): only re-drop on expiry. At 60s (Searing) and 20s
    --     (Magma) duration the GCD and rotation interrupt from a movement re-drop is always
    --     a net DPS loss; let the totem expire naturally then re-place.
    local buffTrigger   = unit.inCombat() or unit.valid("target")
    local attackTrigger = unit.inCombat() or (unit.valid("target") and unit.distance("target") < 30)

    -- *** FIRE TOTEMS ***
    -- Determine if the AoE fire override is active (enough enemies in 8-yard range)
    local aoeFireActive = ui.value("AoE Fire Totem") ~= 3
        and #enemies.yards8 >= ui.value("AoE Fire At")
    -- Nil-safe existence checks: sub-tables are nil when the spell is not known/populated.
    local magmaExists    = totem.fire.magma    and totem.fire.magma.exists    and totem.fire.magma.exists()
    local searingExists  = totem.fire.searing  and totem.fire.searing.exists  and totem.fire.searing.exists()
    local fireNovaExists = totem.fire.fireNova and totem.fire.fireNova.exists and totem.fire.fireNova.exists()
    -- Magma Totem (AoE override, option 1) — re-drop only on expiry
    if aoeFireActive and ui.value("AoE Fire Totem") == 1 and attackTrigger and standing
        and cast.able.magmaTotem("player") and not magmaExists
    then
        if cast.magmaTotem("player") then ui.debug("Casting Magma Totem [Totem Management]") return true end
    end
    -- Fire Nova Totem (AoE override, option 2) — re-drop only on expiry
    if aoeFireActive and ui.value("AoE Fire Totem") == 2 and attackTrigger and standing
        and cast.able.fireNovaTotem("player","aoe",1,10) and not fireNovaExists
    then
        if cast.fireNovaTotem("player","aoe",1,10) then ui.debug("Casting Fire Nova Totem [Totem Management]") return true end
    end
    -- Searing Totem (always-on; only when AoE override is not active) — re-drop only on expiry
    if ui.checked("Searing Totem") and not aoeFireActive and attackTrigger and standing
        and cast.able.searingTotem("player") and not searingExists
    then
        if cast.searingTotem("player") then ui.debug("Casting Searing Totem [Totem Management]") return true end
    end

    -- *** AIR TOTEM ***
    -- Windfury Totem (option 1) — highest-value melee group buff in TBC
    if ui.value("Air Totem") == 1 and buffTrigger and standing
        and cast.able.windfuryTotem("player")
        and (not totem.air.windfury.exists() or totem.air.windfury.distance() > 30)
    then
        if cast.windfuryTotem("player") then ui.debug("Casting Windfury Totem [Totem Management]") return true end
    end
    -- Grace of Air Totem (option 2) — agility-based alternative
    if ui.value("Air Totem") == 2 and buffTrigger and standing
        and cast.able.graceOfAirTotem("player")
        and (not totem.air.graceOfAir.exists() or totem.air.graceOfAir.distance() > 30)
    then
        if cast.graceOfAirTotem("player") then ui.debug("Casting Grace of Air Totem [Totem Management]") return true end
    end

    -- *** EARTH TOTEMS ***
    -- Stoneclaw Totem (defensive reactive — HP threshold, evaluated before always-on earth)
    if ui.checked("Stoneclaw Totem Defensive") and cast.able.stoneclawTotem("player")
        and unit.inCombat() and unit.hp("player") <= ui.value("Stoneclaw Totem Defensive") and standing
    then
        local tankInRange = unit.isTankInRange()
        local stoneclawExists = totem.earth.stoneclaw and totem.earth.stoneclaw.exists and totem.earth.stoneclaw.exists()
        local stoneclawDistance = (totem.earth.stoneclaw and totem.earth.stoneclaw.distance and totem.earth.stoneclaw.distance()) or 99
        if not tankInRange and enemies.yards15 > 0 and (not stoneclawExists or stoneclawDistance > 15) then
            if cast.stoneclawTotem("player") then
                ui.debug("Casting Stoneclaw Totem [Totem Management]")
                return true
            end
        end
    end
    -- Tremor Totem (reactive CC override — drops before always-on earth totem)
    -- TODO: add fear/sleep detection when a confirmed TBC API is available; currently covers charm only
    local tremorNeeded = ui.checked("Tremor Totem") and unit.charmed("player")
    if tremorNeeded and buffTrigger and standing
        and cast.able.tremorTotem("player") and not totem.earth.tremor.exists()
    then
        if cast.tremorTotem("player") then ui.debug("Casting Tremor Totem [Totem Management]") return true end
    end
    -- Stoneskin Totem (always-on, option 1; yields to Tremor when CC is active)
    if not tremorNeeded and ui.value("Earth Totem") == 1 and buffTrigger and standing
        and cast.able.stoneskinTotem("player")
        and (not totem.earth.stoneskin.exists() or totem.earth.stoneskin.distance() > 20)
    then
        if cast.stoneskinTotem("player") then ui.debug("Casting Stoneskin Totem [Totem Management]") return true end
    end
    -- Strength of Earth Totem (always-on, option 2; yields to Tremor when CC is active)
    if not tremorNeeded and ui.value("Earth Totem") == 2 and buffTrigger and standing
        and cast.able.strengthOfEarthTotem("player")
        and (not totem.earth.strengthOfEarth.exists() or totem.earth.strengthOfEarth.distance() > 20)
    then
        if cast.strengthOfEarthTotem("player") then ui.debug("Casting Strength of Earth Totem [Totem Management]") return true end
    end

    -- *** WATER TOTEM ***
    -- Mana Spring Totem (always-on; drops on target acquisition like other buff totems)
    if ui.checked("Mana Spring Totem") and buffTrigger and standing
        and cast.able.manaSpringTotem("player")
        and (not totem.water.manaSpring.exists() or totem.water.manaSpring.distance() > 30)
    then
        if cast.manaSpringTotem("player") then ui.debug("Casting Mana Spring Totem [Totem Management]") return true end
    end
end -- End Action List - Totem Management

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if unit.valid("target") and unit.exists("target") then
            if unit.distance("target") > 5 then
                -- Lightning Bolt
                -- if cast.able.lightningBolt("target") and not unit.moving() then --and var.useLightningBolt then
                --     if cast.lightningBolt("target") then
                --         ui.debug("Casting Lightning Bolt [Precombat]")
                --         return true
                --     end
                -- end
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
        -- if cast.able.lightningBolt() and not unit.moving()
        --     and (unit.distance(units.dyn5) > 10) --or mana.percent() > 50)-- or unit.ttd(units.dyn5) < 3)
        -- then--and var.useLightningBolt then
        --     if cast.lightningBolt() then
        --         ui.debug("Casting Lightning Bolt [Combat]")
        --         return true
        --     end
        -- end
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
    imbues      = br.player.imbues
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716

    -- Units
    units.get(5)        -- Makes a variable called, "target"
    -- units.get(40)       -- Makes a variable called, units.dyn40
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(8)      -- Makes a variable called,  enemies.yards8
    enemies.get(15)     -- Makes a varaible called, enemies.yards15
    enemies.get(20)     -- Makes a variable called, enemies.yards20
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
br.loader.rotations[id] = br.loader.rotations[id] or {}
if br.api.expansion == "TBC" then
    br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
    })
end

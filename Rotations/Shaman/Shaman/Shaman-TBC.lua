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
            -- Fire Nova Cycling (Wowhead step 4: cycle FNT then Searing on single targets)
            br.ui:createCheckbox(section, "Fire Nova Cycling",
                "|cffFFFFFFCycle Fire Nova Totem then Searing Totem on single targets (Wowhead guide).")
            -- Air Totem
            br.ui:createDropdownWithout(section, "Air Totem", {"Windfury Totem", "Grace of Air Totem", "Wrath of Air Totem", "Tranquil Air Totem", "None"}, 1,
                "|cffFFFFFFAir totem to maintain (used when Totem Twisting is OFF).")
            -- Totem Twisting — cycles Windfury → Grace of Air every ~10s
            br.ui:createCheckbox(section, "Totem Twisting",
                "|cffFFFFFFCycle Windfury Totem then Grace of Air Totem every ~10 seconds. Overrides Air Totem dropdown.")
            -- Tremor Totem (reactive — drops on fear or charm)
            br.ui:createCheckbox(section, "Tremor Totem",
                "|cffFFFFFFReactively drop Tremor Totem when fear or charm is detected on the player.")
            -- Earth Totem (always-on)
            br.ui:createDropdownWithout(section, "Earth Totem", {"Stoneskin Totem", "Strength of Earth Totem", "None"}, 1)
            -- Water Totem
            br.ui:createDropdownWithout(section, "Water Totem", {"Mana Spring Totem", "Healing Stream Totem", "None"}, 1,
                "|cffFFFFFFWater totem to maintain.")
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
            -- Shamanistic Rage
            br.ui:createSpinnerWithout(section, "Shamanistic Rage", 30, 0, 100, 5,
                "|cffFFFFFFMana Percent to Cast At")
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
    -- * Lightning Shield (maintain above the swap-to-Water-Shield mana threshold)
    if ui.value("Shield's Up") == 1 and cast.able.lightningShield()
        and not buff.lightningShield.exists()
        and mana.percent() > ui.value("Water Shield Swap At")
    then
        if cast.lightningShield("player") then ui.debug("Casting Lightning Shield [Extra]") return true end
    end
    -- * Water Shield (preferred shield OR mana at/below the swap threshold)
    if cast.able.waterShield() and not buff.waterShield.exists()
        and (ui.value("Shield's Up") == 2
            or (ui.value("Shield's Up") == 1 and mana.percent() <= ui.value("Water Shield Swap At")))
    then
        if cast.waterShield("player") then ui.debug("Casting Water Shield [Extra]") return true end
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
    -- -- * Totemic Call (mana recovery)
    -- -- Any active totem slot contributes mana on recall (25% of cast cost each).
    -- -- totem.exists() with no args doesn't work (requires a candidate), so check slots directly.
    -- local anyTotemUp = totem.fire.active() or totem.earth.active()
    --                 or totem.water.active() or totem.air.active()
    -- if cast.able.totemicRecall() and anyTotemUp then
    --     -- OOC with no nearby enemies: free mana recovery between pulls
    --     local recallOOC = not unit.inCombat() and #enemies.yards20 == 0
    --     -- IC: all buff totems have drifted out of effective range — they're doing nothing,
    --     -- recall them to recover mana. Only worth a GCD when mana is low.
    --     local allDrifted = unit.inCombat() and mana.percent() < 30
    --         and (not totem.air.active()   or totem.air.distance()   > 30)
    --         and (not totem.earth.active() or totem.earth.distance() > 25)
    --         and (not totem.water.active() or totem.water.distance() > 25)
    --     if recallOOC or allDrifted then
    --         if cast.totemicRecall() then ui.debug("Casting Totemic Call [Extra]") return true end
    --     end
    -- end
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
    if unit.distance(units.dyn5) < 5 then
        -- * Module- Basic Trinkets
        -- use_items
        module.BasicTrinkets()
    end
    -- * Shamanistic Rage (mana recovery — fire when mana falls to/below the threshold)
    if cast.able.shamanisticRage("player")
        and mana.percent() <= ui.value("Shamanistic Rage") and unit.inCombat() and #enemies.yards5 > 0 and unit.ttdGroup(20) > 10
    then
        if cast.shamanisticRage("player") then ui.debug("Casting Shamanistic Rage [Cooldowns]") return true end
    end
end -- End Action List - Cooldowns

-- Action List - Totem Management
actionList.TotemManagement = function()
    local standing  = unit.standingTime() > 1
    local inCombat  = unit.inCombat()
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
    local fireCycling   = ui.checked("Fire Nova Cycling")
    -- Use totem.fire.name() (GetTotemInfo slot check) to detect which fire totem is active.
    -- Specific sub-object exists() calls fail because array spell IDs are not flat-promoted
    -- into br.player.spells, so resolveCandidateName always falls back to a literal key mismatch.
    local fireName       = totem.fire.name() or ""
    local magmaExists    = fireName:find("Magma")     ~= nil
    local searingExists  = fireName:find("Searing")   ~= nil
    local fireNovaExists = fireName:find("Fire Nova") ~= nil
    -- Magma Totem (AoE override, option 1) — replace fire slot contents
    if aoeFireActive and ui.value("AoE Fire Totem") == 1 and attackTrigger and standing
        and cast.able.magmaTotem("player") and not magmaExists
    then
        if cast.magmaTotem("player") then ui.debug("Casting Magma Totem [Totem Management]") return true end
    end
    -- Fire Nova Totem (AoE override option 2, OR single-target cycling when enabled)
    -- Cycling is gated on TTD and mana: no point cycling on dying targets or when OOM
    local cyclingAllowed = fireCycling and unit.ttd(units.dyn5) > 20 and mana.percent() > 30
    if (aoeFireActive and ui.value("AoE Fire Totem") == 2 or cyclingAllowed) and attackTrigger and standing
        and cast.able.fireNovaTotem("player","aoe",1,10) and not fireNovaExists
    then
        if cast.fireNovaTotem("player","aoe",1,10) then ui.debug("Casting Fire Nova Totem [Totem Management]") return true end
    end
    -- Searing Totem (always-on; backfills fire slot while FNT is on CD during cycling,
    --               or whenever AoE override and cycling are both inactive)
    local suppressSearing = aoeFireActive
        or (cyclingAllowed and (fireNovaExists or cast.able.fireNovaTotem("player","aoe",1,10)))
    if ui.checked("Searing Totem") and not suppressSearing and attackTrigger and standing
        and cast.able.searingTotem("player") and not searingExists
    then
        if cast.searingTotem("player") then ui.debug("Casting Searing Totem [Totem Management]") return true end
    end

    -- *** AIR TOTEM ***
    -- Use element-level API: totem.air.active/name/distance all call GetTotemInfo(slot) directly.
    local airActive = totem.air.active()
    local airName   = totem.air.name() or ""
    local airDist   = airActive and totem.air.distance() or 99
    local totemTwisting = ui.checked("Totem Twisting")
    -- Air totem re-drop distance threshold: in a group the totem must stay near party members;
    -- solo it only needs to cover the player. Use a tighter threshold in party/raid.
    local inGroup      = br.player.instance == "party" or br.player.instance == "raid"
    local airRedropDist = inGroup and 20 or 40
    -- In combat: only re-drop when completely expired — never burn a GCD on a buff totem
    -- when Stormstrike or Earth Shock could fire instead.
    -- Out of combat: re-drop on distance when less than 60s remain (pre-pull refresh).
    local airNeedsRedrop = airActive and (
        inCombat and totem.air.remain() == 0
        or (not inCombat and airDist > airRedropDist and totem.air.remain() < 60)
    )
    if totemTwisting and mana.percent() > 40 then
        -- Totem Twisting: WF applies a 10s weapon enchant that persists after the totem is replaced.
        -- Cycle: drop WF → drop GoA (enchant still ticking) → re-drop WF at ~9s → repeat.
        -- Mana floor: below 40% mana fall back to static air totem to conserve resources.
        if buffTrigger and standing and cast.able.windfuryTotem("player")
            and cast.timeSinceLast.windfuryTotem() >= 9
        then
            if cast.windfuryTotem("player") then ui.debug("Casting Windfury Totem [Totem Twisting]") return true end
        end
        -- Drop GoA after WF enchant is applied; skip if GoA already in range
        if buffTrigger and standing and cast.able.graceOfAirTotem("player")
            and cast.timeSinceLast.windfuryTotem() < 9
            and (not airName:find("Grace") or airNeedsRedrop)
        then
            if cast.graceOfAirTotem("player") then ui.debug("Casting Grace of Air Totem [Totem Twisting]") return true end
        end
    else
        -- Static air totem — honour the Air Totem dropdown (also used as twisting fallback below mana floor)
        if ui.value("Air Totem") == 1 and buffTrigger and standing
            and cast.able.windfuryTotem("player")
            and (not airActive or airNeedsRedrop)
        then
            if cast.windfuryTotem("player") then ui.debug("Casting Windfury Totem [Totem Management]") return true end
        end
        if ui.value("Air Totem") == 2 and buffTrigger and standing
            and cast.able.graceOfAirTotem("player")
            and (not airActive or airNeedsRedrop)
        then
            if cast.graceOfAirTotem("player") then ui.debug("Casting Grace of Air Totem [Totem Management]") return true end
        end
        if ui.value("Air Totem") == 3 and buffTrigger and standing
            and cast.able.wrathOfAirTotem("player")
            and (not airActive or airNeedsRedrop)
        then
            if cast.wrathOfAirTotem("player") then ui.debug("Casting Wrath of Air Totem [Totem Management]") return true end
        end
        if ui.value("Air Totem") == 4 and buffTrigger and standing
            and cast.able.tranquilAirTotem("player")
            and (not airActive or airNeedsRedrop)
        then
            if cast.tranquilAirTotem("player") then ui.debug("Casting Tranquil Air Totem [Totem Management]") return true end
        end
    end

    -- *** EARTH TOTEMS ***
    -- Stoneclaw Totem (defensive reactive — HP threshold, evaluated before always-on earth)
    if ui.checked("Stoneclaw Totem Defensive") and cast.able.stoneclawTotem("player")
        and unit.inCombat() and unit.hp("player") <= ui.value("Stoneclaw Totem Defensive") and standing
    then
        local tankInRange   = unit.isTankInRange()
        local earthName_sc  = totem.earth.name() or ""
        local stoneclawUp   = earthName_sc:find("Stoneclaw") ~= nil
        local stoneclawDist = stoneclawUp and totem.earth.distance() or 99
        if not tankInRange and #enemies.yards15 > 0 and (not stoneclawUp or stoneclawDist > 15) then
            if cast.stoneclawTotem("player") then
                ui.debug("Casting Stoneclaw Totem [Totem Management]")
                return true
            end
        end
    end
    -- Tremor Totem (reactive CC override — drops before always-on earth totem)
    -- TODO: add fear/sleep detection when a confirmed TBC API is available; currently covers charm only
    local tremorNeeded = ui.checked("Tremor Totem") and unit.charmed("player")
    local earthName    = totem.earth.name() or ""
    local earthDist    = totem.earth.active() and totem.earth.distance() or 99
    if tremorNeeded and buffTrigger and standing
        and cast.able.tremorTotem("player") and not earthName:find("Tremor")
    then
        if cast.tremorTotem("player") then ui.debug("Casting Tremor Totem [Totem Management]") return true end
    end
    -- Earth/Water totem re-drop thresholds: tighter in group content so the buff covers the party.
    -- Only re-drop on distance if less than 60s remain — don't replace a totem early.
    local earthRedropDist  = inGroup and 15 or 30
    local earthNeedsRedrop = totem.earth.active() and (
        inCombat and totem.earth.remain() == 0
        or (not inCombat and earthDist > earthRedropDist and totem.earth.remain() < 60)
    )
    -- Stoneskin Totem (always-on, option 1; yields to Tremor when CC is active)
    if not tremorNeeded and ui.value("Earth Totem") == 1 and buffTrigger and standing
        and cast.able.stoneskinTotem("player")
        and (not earthName:find("Stoneskin") or earthNeedsRedrop)
    then
        if cast.stoneskinTotem("player") then ui.debug("Casting Stoneskin Totem [Totem Management]") return true end
    end
    -- Strength of Earth Totem (always-on, option 2; yields to Tremor when CC is active)
    if not tremorNeeded and ui.value("Earth Totem") == 2 and buffTrigger and standing
        and cast.able.strengthOfEarthTotem("player")
        and (not earthName:find("Strength") or earthNeedsRedrop)
    then
        if cast.strengthOfEarthTotem("player") then ui.debug("Casting Strength of Earth Totem [Totem Management]") return true end
    end

    -- *** WATER TOTEM ***
    local waterName        = totem.water.name() or ""
    local waterDist        = totem.water.active() and totem.water.distance() or 99
    local waterRedropDist  = inGroup and 20 or 35
    local waterNeedsRedrop = totem.water.active() and (
        inCombat and totem.water.remain() == 0
        or (not inCombat and waterDist > waterRedropDist and totem.water.remain() < 60)
    )
    if ui.value("Water Totem") == 1 and buffTrigger and standing
        and cast.able.manaSpringTotem("player")
        and (not waterName:find("Mana Spring") or waterNeedsRedrop)
    then
        if cast.manaSpringTotem("player") then ui.debug("Casting Mana Spring Totem [Totem Management]") return true end
    end
    if ui.value("Water Totem") == 2 and buffTrigger and standing
        and cast.able.healingStreamTotem("player")
        and (not waterName:find("Healing Stream") or waterNeedsRedrop)
    then
        if cast.healingStreamTotem("player") then ui.debug("Casting Healing Stream Totem [Totem Management]") return true end
    end
end -- End Action List - Totem Management

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if unit.valid("target") and unit.exists("target") then
            if unit.distance(units.dyn5) > 5 then
                -- Lightning Bolt — primary ranged opener per guide.
                -- Use Rank 1 at low mana to save resources; max rank otherwise.
                if cast.able.lightningBolt("target") and not unit.moving() then
                    if mana.percent() <= 20 then
                        if cast.rank.lightningBolt(1, "target") then
                            ui.debug("Casting Lightning Bolt Rank 1 [Precombat]")
                            return true
                        end
                    else
                        if cast.lightningBolt("target") then
                            ui.debug("Casting Lightning Bolt [Precombat]")
                            return true
                        end
                    end
                end
                -- Flame Shock — follow-up to get the DoT ticking before melee contact
                if cast.able.flameShock("target") then
                    if cast.flameShock("target") then
                        ui.debug("Casting Flame Shock [Precombat]")
                        return true
                    end
                end
                -- Earth Shock removed: its 6s CD is too valuable to burn pre-combat
            else
                -- -- Primal Strike
                -- if cast.able.primalStrike(units.dyn5) then
                --     if cast.primalStrike(units.dyn5) then
                --         ui.debug("Casting Primal Strike [Precombat]")
                --         return true
                --     end
                -- end
                -- Start Attack
                if not cast.auto.autoAttack() and not unit.deadOrGhost(units.dyn5) then
                    unit.startAttack()
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
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
        if not cast.auto.autoAttack() and unit.exists(units.dyn5) and not unit.deadOrGhost(units.dyn5) then
            unit.startAttack()
            ui.debug("Casting Auto Attack [Combat]")
            return true
        end
        -- Multi-Target: Chain Lightning (Wowhead AoE primary — best AoE damage, especially in SS debuff window)
        if ui.mode.rotation == 2 and cast.able.chainLightning() and not unit.moving()
            and #enemies.yards20 >= 3
        then
            if cast.chainLightning() then
                ui.debug("Casting Chain Lightning [Combat AoE]")
                return true
            end
        end
        -- Multi-Target: spread Flame Shock across enemies (guide AoE step 3)
        if ui.mode.rotation == 2 and cast.able.flameShock() then
            for i = 1, #enemies.yards20 do
                local aoeTarget = enemies.yards20[i]
                if unit.valid(aoeTarget) and not debuff.flameShock.exists(aoeTarget) and unit.ttd(aoeTarget) > 6 then
                    if cast.flameShock(aoeTarget) then
                        ui.debug("Casting Flame Shock on " .. unit.name(aoeTarget) .. " [Combat AoE]")
                        return true
                    end
                end
            end
        end
        -- Stormstrike (highest priority GCD — always on its own 10s CD)
        if cast.able.stormstrike() then--and unit.ttd(units.dyn5) > 2 then
            if cast.stormstrike() then
                ui.debug("Casting Stormstrike [Combat]")
                return true
            end
        end
        -- Flame Shock (only if the enemy will live long enough to tick the full 12s DoT)
        if cast.able.flameShock() and debuff.flameShock.refresh(units.dyn5) and unit.ttd(units.dyn5) > 12 then
            if cast.flameShock() then
                ui.debug("Casting Flame Shock [Combat]")
                return true
            end
        end
        -- Earth Shock (primary damage filler — use whenever possible)
        if cast.able.earthShock() then
            if cast.earthShock() then
                ui.debug("Casting Earth Shock [Combat]")
                return true
            end
        end
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
        --- Cooldowns ---
        -----------------
        if actionList.Cooldowns() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        -----------------------------------------------
        --- Totem Setup (pre-pull, out of combat only) ---
        -----------------------------------------------
        if not unit.inCombat() and actionList.TotemManagement() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if actionList.Combat() then return true end
        ----------------------------------------------------------
        --- Totem Refresh (in combat — expired slots only,     ---
        --- never preempts Stormstrike or Earth Shock)         ---
        ----------------------------------------------------------
        if unit.inCombat() and actionList.TotemManagement() then return true end
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

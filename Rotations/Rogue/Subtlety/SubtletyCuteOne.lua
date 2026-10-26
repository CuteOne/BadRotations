-- Editor types: the keys of MOP Rogue Subtlety's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.MOP.Rogue.Subtlety.buff]]
local cast = cast --[[@as BR.MOP.Rogue.Subtlety.cast]]
local cd = cd --[[@as BR.MOP.Rogue.Subtlety.cd]]
local charges = charges --[[@as BR.MOP.Rogue.Subtlety.charges]]
local debuff = debuff --[[@as BR.MOP.Rogue.Subtlety.debuff]]
local equiped = equiped --[[@as BR.MOP.Rogue.Subtlety.equiped]]
local glyph = glyph --[[@as BR.MOP.Rogue.Subtlety.glyph]]
local has = has --[[@as BR.MOP.Rogue.Subtlety.has]]
local heroTree = heroTree --[[@as BR.MOP.Rogue.Subtlety.heroTree]]
local imbues = imbues --[[@as BR.MOP.Rogue.Subtlety.imbues]]
local spell = spell --[[@as BR.MOP.Rogue.Subtlety.spell]]
local talent = talent --[[@as BR.MOP.Rogue.Subtlety.talent]]
local totem = totem --[[@as BR.MOP.Rogue.Subtlety.totem]]
local use = use --[[@as BR.MOP.Rogue.Subtlety.use]]

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function toggles()
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "fanOfKnives", overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range." },
        { name = "Mult", icon = "fanOfKnives", overlay = "Multiple Target Rotation", tip = "Multiple target rotation used." },
        { name = "Sing", icon = "backstab", overlay = "Single Target Rotation", tip = "Single target rotation used." },
        { name = "Off", icon = "stealth", overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation" },
    } })
    ui.toggle("Cooldown", { key = "RightCtrl", modes = {
        { name = "Auto", icon = "shadowBlades", overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection." },
        { name = "On", icon = "shadowBlades", overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target." },
        { name = "Off", icon = "shadowBlades", overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used." },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "evasion", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "evasion", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("Interrupt", { modes = {
        { name = "On", icon = "kick", overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts." },
        { name = "Off", icon = "kick", overlay = "Interrupts Disabled", tip = "No Interrupts will be used." },
    } })
    ui.toggle("PickPocket", { modes = {
        { name = "Auto", icon = "pickPocket", overlay = "Pick Pocket Auto", tip = "Automatically Pick Pocket before engaging, minimal delay." },
        { name = "Only", icon = "pickPocket", overlay = "Pick Pocket Only", tip = "Only Pick Pocket targets (Sap > Pick Pocket > Clear Target)." },
        { name = "Off", icon = "pickPocket", overlay = "Pick Pocket Disabled", tip = "Never Pick Pocket." },
    } })
end

---------------
--- OPTIONS ---
---------------
local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = ui.section("General")
    -- Dummy DPS Test
    ui.spinner(section, "DPS Testing", { value = 5, min = 5, max = 60,
        tip = "Set to desired time for test in minutes. Min: 5 / Max: 60 / Interval: 5" })
    -- Auto Stealth
    ui.checkbox(section, "Auto Stealth")
    -- Stealth Breaker
    ui.dropdown(section, "Stealth Breaker", { choices = { "|cff00FF00Ambush", "|cffFF0000Hemorrhage" }, value = "Ambush", checkbox = false,
        tip = "Set what to break Stealth with." })
    -- Poisons
    ui.dropdown(section, "Lethal Poison", { choices = { "Instant", "Deadly", "Wound" }, value = "Deadly", checkbox = false,
        tip = "Select Lethal Poison to use." })
    ui.dropdown(section, "Non-Lethal Poison", { choices = { "None", "Crippling", "Mind-Numbing", "Paralytic" }, value = "Crippling", checkbox = false,
        tip = "Select Non-Lethal Poison to use." })
    ------------------------
    --- COOLDOWN OPTIONS ---
    ------------------------
    section = ui.section("Cooldowns")
    -- Shadowstep
    ui.checkbox(section, "Shadowstep")
    -- Shadow Blades
    ui.dropdown(section, "Shadow Blades", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false,
        tip = "When to use Shadow Blades." })
    -- Shadow Dance
    ui.dropdown(section, "Shadow Dance", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false, tip = "When to use Shadow Dance." })
    -- Vanish
    ui.dropdown(section, "Vanish", { choices = "AlwaysCdAoeNever", value = "AOE", checkbox = false, tip = "When to use Vanish." })
    -- Preparation
    ui.checkbox(section, "Preparation")
    -- Premeditation
    ui.checkbox(section, "Premeditation")
    -- Marked for Death
    ui.checkbox(section, "Marked for Death")
    -- Use Racial
    ui.checkbox(section, "Use Racial")
    -- Use Combat Potion
    ui.checkbox(section, "Use Combat Potion")
    -- Trinkets
    module.BasicTrinkets(section)
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
    -- Cloak of Shadows
    ui.checkbox(section, "Cloak of Shadows")
    -- Combat Readiness
    ui.spinner(section, "Combat Readiness", { value = 40, tip = "Health Percent to Cast At" })
    -- Evasion
    ui.spinner(section, "Evasion", { value = 35, tip = "Health Percent to Cast At" })
    -- Feint
    ui.spinner(section, "Feint", { value = 50, tip = "Health Percent to Cast At" })
    -- Recuperate
    ui.spinner(section, "Recuperate", { value = 60, tip = "Health Percent to Cast At" })
    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = ui.section("Interrupts")
    -- Kick
    ui.checkbox(section, "Kick")
    -- Kidney Shot
    ui.checkbox(section, "Kidney Shot")
    -- Gouge
    ui.checkbox(section, "Gouge")
    -- Interrupt Percentage
    ui.spinner(section, "Interrupt At", { value = 0, max = 95, checkbox = false, tip = "Cast Percentage to use at. (0 is random)" })
end

--------------
--- Locals ---
--------------
-- BR API Locals
local actionList = {}
local comboPoints
local energy
local var = {}

-- General Locals
var.profileStop = false
var.stealthed = false
var.openerCast = false
var.openerTime = nil
var.openerAttemptTime = nil
var.getTime = 0
-- Pick Pocket Locals
var.pickPocketAttempted = {} -- Table to track attempted units by GUID
var.pickPocketSuccess = {} -- Table to track successful Pick Pockets by GUID
var.pickPocketFailed = {} -- Table to track failed Pick Pockets by GUID
var.pickPocketCastTime = 0 -- Time when Pick Pocket was last cast
var.pickPocketLastGUID = nil -- GUID of last Pick Pocket target for validation

-----------------
--- Functions ---
-----------------
local function isStealthed()
    return buff.stealth.exists() or buff.vanish.exists() or buff.shadowDance.exists() or buff.shadowmeld.exists()
end

-- Pick Pocket Helper Functions
local function getPickPocketMode()
    return ui.mode.pickPocket or 3
end

local function canPickPocket(thisUnit)
    thisUnit = thisUnit or "target"

    -- Check if unit exists and is valid
    if not unit.exists(thisUnit) or not unit.valid(thisUnit) then
        return false
    end

    -- Must be stealthed
    if not var.stealthed then
        return false
    end

    -- Get unit GUID
    local guid = unit.guid(thisUnit)
    if not guid then
        return false
    end

    -- Check if already attempted and failed
    if var.pickPocketFailed[guid] then
        return false
    end

    -- Check if already successfully picked
    if var.pickPocketSuccess[guid] then
        return false
    end

    -- Must be enemy
    if not unit.enemy(thisUnit) then
        return false
    end

    -- Can't pickpocket players
    if unit.player(thisUnit) then
        return false
    end

    -- Must be in range
    if unit.distance(thisUnit) > 10 then
        return false
    end

    return true
end

---@param lootMsg string? The loot message on success
---@param errorMsg string? The error message on failure
local function markPickPocketResult(thisUnit, success, lootMsg, errorMsg)
    local guid = unit.guid(thisUnit)
    if not guid then return end

    if success then
        var.pickPocketSuccess[guid] = true
        var.pickPocketFailed[guid] = nil
        -- Extract item links from loot message for display
        local itemInfo = ""
        if lootMsg then
            -- Extract all item links [Item Name]
            for itemLink in lootMsg:gmatch("%[.-%]") do
                itemInfo = itemInfo .. " " .. itemLink
            end
            -- If no item links, check if it's a money message
            if itemInfo == "" and lootMsg:find("%d") then
                itemInfo = " (Money)"
            end
        end
        ui.debug("|cff00FF00[Pick Pocket]|r Success" .. itemInfo)
    else
        var.pickPocketFailed[guid] = true
        var.pickPocketAttempted[guid] = nil
        if errorMsg then
            ui.debug("|cffFF0000[Pick Pocket]|r Failed: " .. errorMsg)
        else
            ui.debug("|cffFF0000[Pick Pocket]|r Failed on " .. (unit.name(thisUnit) or thisUnit))
        end
    end
end

-- The game's answer to the Pick Pocket in flight, within 2 seconds of the cast: an error (no pockets,
-- already picked, ...) means it failed, a loot or money message that it worked. Checked each tick.
local PICK_POCKET_FAILURES = {
    ERR_SPELL_FAILED_S = true,         -- Generic spell failure (covers "no pockets to pick")
    ERR_ALREADY_PICKPOCKETED = true,   -- Already pickpocketed this target
    ERR_NO_LOOT = true,                -- Target has no loot (empty pockets)
    SPELL_FAILED_BAD_TARGETS = true,   -- Invalid target
    SPELL_FAILED_TARGET_ENEMY = true,  -- Must be an enemy
}
local function checkPickPocketResult()
    local castTime = var.pickPocketCastTime
    if castTime == 0 or not var.pickPocketLastGUID then return end
    local errorKey, errorMessage, errorAt = ui.lastError()
    -- An error for the same target (one for a new target is ignored)
    if errorAt >= castTime and errorAt - castTime < 2.0 and PICK_POCKET_FAILURES[errorKey]
        and unit.guid("target") == var.pickPocketLastGUID
    then
        markPickPocketResult("target", false, nil, errorMessage)
        var.pickPocketCastTime = 0
        var.pickPocketLastGUID = nil
        return
    end
    -- Loot: an item link (any language) or money
    local lootMessage, lootAt, money = ui.lastLoot()
    if lootMessage and lootAt >= castTime and lootAt - castTime < 2.0 and (money or lootMessage:find("%[.+%]")) then
        markPickPocketResult("target", true, lootMessage)
        var.pickPocketCastTime = 0
        var.pickPocketLastGUID = nil
    end
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Pick Pocket
actionList.PickPocket = function()
    local ppMode = getPickPocketMode()

    -- Mode 3 = Off, skip entirely
    if ppMode == 3 then
        return false
    end

    -- Must have a target
    if not unit.valid("target") then
        return false
    end

    -- Mode 2 = Only (Sap > Pick Pocket > Clear Target)
    if ppMode == 2 then
        -- Must be stealthed for "Only" mode
        if not var.stealthed then
            if ui.checked("Auto Stealth") and cast.able.stealth() and not unit.resting() then
                if cast.stealth() then
                    ui.debug("[Pick Pocket] Entering Stealth")
                    return true
                end
            end
            return false
        end

        -- Get target GUID for tracking
        local guid = unit.guid("target")
        if not guid then
            return false
        end

        -- Check if we've already processed this target (success or failure)
        if var.pickPocketSuccess[guid] or var.pickPocketFailed[guid] then
            -- Wait brief moment to see loot (if successful)
            if cast.last.pickPocket(1) and cast.timeSinceLast.pickPocket() < 1.5 then
                return true
            end
            -- Clear target and stop
            unit.clearTarget()
            ui.debug("[Pick Pocket] Complete - Target cleared")
            return true
        end

        -- Check if we just cast Pick Pocket, wait for result
        if cast.last.pickPocket(1) and cast.timeSinceLast.pickPocket() < 1.5 then
            return true
        end

        -- Check if Pick Pocket is in-flight waiting for event (timeout after 3 seconds)
        if var.pickPocketCastTime > 0 and var.pickPocketLastGUID then
            local waitTime = var.getTime - var.pickPocketCastTime
            if waitTime < 3.0 then
                -- Still waiting for success/failure event
                return true
            else
                -- Timeout - no event received, consider it failed
                ui.debug("[Pick Pocket] Timeout waiting for event - clearing state")
                var.pickPocketCastTime = 0
                var.pickPocketLastGUID = nil
            end
        end

        -- Check if target is sapped
        local isSapped = debuff.sap.exists("target")
        local sapAble = cast.able.sap("target")
        local sapRefresh = debuff.sap.refresh("target")

        -- PRIORITY 1: Cast Sap if needed and available (only if we CAN cast it)
        if (not isSapped) and sapAble and sapRefresh then
            if cast.sap("target") then
                ui.debug("[Pick Pocket] Casting Sap")
                return true
            end
        end

        -- PRIORITY 2: If target is sapped OR we can't cast Sap anymore (meaning it's in flight/on CD), try Pick Pocket
        if isSapped or (not sapAble) then
            -- Check range before attempting Pick Pocket (Pick Pocket has 5yd range, Sap has 10yd)
            local targetDistance = unit.distance("target")

            if targetDistance > 5 then
                -- Too far for Pick Pocket, move closer
                -- Target is sapped so we have time to approach safely
                -- ui.debug("[Pick Pocket] Moving closer (" .. string.format("%.1f", targetDistance) .. "yd)")
                return true -- Wait and let movement happen
            end

            if canPickPocket("target") then
                if cast.able.pickPocket("target") then
                    -- Set timing BEFORE attempting cast so event handler can match the error
                    var.pickPocketCastTime = ui.time()
                    var.pickPocketLastGUID = guid
                    var.pickPocketAttempted[guid] = true

                    -- DEBUG: Verify timing is set
                    ui.debug("[Pick Pocket] Setting CastTime to: " .. var.pickPocketCastTime)

                    if cast.pickPocket("target") then
                        ui.debug("[Pick Pocket] Attempting Pick Pocket")
                    else
                        -- cast.pickPocket returned false, but game may have still attempted it
                        -- Keep timing data so event handler can process the error
                        ui.debug("[Pick Pocket] Cast attempt - waiting for result")
                    end

                    -- Wait for result (success or failure event)
                    return true
                end
                -- If cast.able is false, just wait (likely on GCD from Sap)
                return true
            end
        end

        return false
    end    -- Mode 1 = Auto (Pick Pocket before engaging, minimal delay)
    if ppMode == 1 then
        -- Only attempt if stealthed and not in combat
        if not var.stealthed or unit.inCombat() then
            return false
        end

        -- Check if we can and should Pick Pocket
        if canPickPocket("target") and cast.able.pickPocket("target") then
            local targetGUID = unit.guid("target")
            var.pickPocketCastTime = ui.time()
            var.pickPocketLastGUID = targetGUID
            var.pickPocketAttempted[targetGUID] = true
            if cast.pickPocket("target") then
                ui.debug("Casting Pick Pocket [Auto Mode] on " .. unit.name("target"))
                return true
            end
        end

        -- If we just cast Pick Pocket, wait very briefly for result
        if cast.last.pickPocket(1) and cast.timeSinceLast.pickPocket() < 0.3 then
            return true
        end

        -- Allow rotation to continue after brief delay
        return false
    end

    return false
end -- End Action List - Pick Pocket

-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() and not var.stealthed then
        -- Cloak of Shadows
        if ui.checked("Cloak of Shadows") and cast.able.cloakOfShadows() and cast.dispel.cloakOfShadows("player") then
            if cast.cloakOfShadows() then
                ui.debug("Casting Cloak of Shadows")
                return true
            end
        end
        -- Evasion
        if ui.checked("Evasion") and cast.able.evasion() and unit.hp() <= ui.value("Evasion") and unit.inCombat() then
            if cast.evasion() then
                ui.debug("Casting Evasion")
                return true
            end
        end
        -- Feint
        if ui.checked("Feint") and cast.able.feint() and unit.hp() <= ui.value("Feint") and unit.inCombat() and not buff.feint.exists() then
            if cast.feint() then
                ui.debug("Casting Feint")
                return true
            end
        end
        -- Combat Readiness
        if ui.checked("Combat Readiness") and cast.able.combatReadiness() and unit.hp() <= ui.value("Combat Readiness")
            and unit.inCombat() and not buff.combatReadiness.exists()
        then
            if cast.combatReadiness() then
                ui.debug("Casting Combat Readiness")
                return true
            end
        end
        -- Recuperate
        if ui.checked("Recuperate") and cast.able.recuperate() and unit.hp() <= ui.value("Recuperate")
            and comboPoints() > 0 and not buff.recuperate.exists()
        then
            if cast.recuperate() then
                ui.debug("Casting Recuperate")
                return true
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and not var.stealthed then
        for i = 1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                -- Kick
                if ui.checked("Kick") and cast.able.kick(thisUnit) and distance < 5 then
                    if cast.kick(thisUnit) then
                        ui.debug("Casting Kick on " .. unit.name(thisUnit))
                        return true
                    end
                end
                -- Kidney Shot
                if ui.checked("Kidney Shot") and cast.able.kidneyShot(thisUnit) and comboPoints() > 0 and distance < 5 then
                    if cast.kidneyShot(thisUnit) then
                        ui.debug("Casting Kidney Shot on " .. unit.name(thisUnit))
                        return true
                    end
                end
                -- Gouge
                if ui.checked("Gouge") and cast.able.gouge(thisUnit) and distance < 5 then
                    if cast.gouge(thisUnit) then
                        ui.debug("Casting Gouge on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if ui.useCDs() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Potion
        -- virmens_bite_potion,if=buff.bloodlust.react|target.time_to_die<40
        if ui.checked("Use Combat Potion") and (buff.bloodLust.exists() or unit.ttd(units.dyn5) < 40) then
            module.CombatPotionUp()
        end
        -- Racial
        -- blood_fury,if=buff.shadow_dance.up
        -- berserking,if=buff.shadow_dance.up
        -- arcane_torrent,if=energy<60
        if ui.checked("Use Racial") and cast.able.racial() then
            if (unit.race() == "Orc" or unit.race() == "Troll") and buff.shadowDance.exists() then
                if cast.racial() then
                    ui.debug("Casting Racial - Blood Fury/Berserking")
                    return true
                end
            end
            if unit.race() == "BloodElf" and energy() < 60 then
                if cast.racial() then
                    ui.debug("Casting Racial - Arcane Torrent")
                    return true
                end
            end
        end
        -- Shadow Blades (only if available)
        -- shadow_blades
        if cast.able.shadowBlades() and ui.alwaysCdAoENever("Shadow Blades", 3, #enemies.yards10) then
            if cast.shadowBlades() then
                ui.debug("Casting Shadow Blades")
                return true
            end
        end
        -- Premeditation (only if available)
        -- premeditation,if=combo_points<=4
        if cast.able.premeditation() and ui.checked("Premeditation") and buff.stealth.exists() and comboPoints() <= 4 then
            if cast.premeditation() then
                ui.debug("Casting Premeditation")
                return true
            end
        end
        -- Module - Basic Trinkets
        module.BasicTrinkets()
    end
end -- End Action List - Cooldowns

-- Action List - Pool Resource
actionList.Pool = function()
    -- Preparation (only if available)
    -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
    if cast.able.preparation() and ui.checked("Preparation") and not buff.vanish.exists() and cd.vanish.remains() > 60 then
        if cast.preparation() then
            ui.debug("Casting Preparation")
            return true
        end
    end
    return false
end -- End Action List - Pool

-- Action List - Generator
actionList.Generator = function()
    -- Pool Resource Check
    -- run_action_list,name=pool,if=buff.master_of_subtlety.down&buff.shadow_dance.down&debuff.find_weakness.down&(energy+cooldown.shadow_dance.remains*energy.regen<80|energy+cooldown.vanish.remains*energy.regen<60)
    if not buff.masterOfSubtlety.exists() and not buff.shadowDance.exists() and not debuff.findWeakness.exists(units.dyn5)
        and (energy() + cd.shadowDance.remains() * energy.regen() < 80 or energy() + cd.vanish.remains() * energy.regen() < 60)
    then
        if actionList.Pool() then return true end
    end
    -- Fan of Knives
    -- fan_of_knives,if=active_enemies>=4
    if cast.able.fanOfKnives("player", "aoe", 1, 10) and ui.useAOE(10, 4) then
        if cast.fanOfKnives("player", "aoe", 1, 10) then
            ui.debug("Casting Fan of Knives")
            return true
        end
    end
    -- Hemorrhage (if talented)
    -- hemorrhage,if=remains<3|position_front
    if cast.able.hemorrhage(units.dyn5)
        and (debuff.hemorrhage.remains(units.dyn5) < 3 or unit.facing(units.dyn5, "player") or unit.level() < 40)
    then
        if cast.hemorrhage(units.dyn5) then
            ui.debug("Casting Hemorrhage")
            return true
        end
    end
    -- Shuriken Toss (if talented)
    -- shuriken_toss,if=talent.shuriken_toss.enabled&(energy<65&energy.regen<16)
    if talent.shurikenToss and cast.able.shurikenToss(units.dyn30)
        and (energy() < 65 and energy.regen() < 16)
    then
        if cast.shurikenToss(units.dyn30) then
            ui.debug("Casting Shuriken Toss")
            return true
        end
    end
    -- Backstab
    -- backstab
    if cast.able.backstab(units.dyn5) then
        if cast.backstab(units.dyn5) then
            ui.debug("Casting Backstab")
            return true
        end
    end
    -- Pool
    if actionList.Pool() then return true end
end -- End Action List - Generator

-- Action List - Finisher
actionList.Finisher = function()
    -- Slice and Dice
    -- slice_and_dice,if=buff.slice_and_dice.remains<4
    if cast.able.sliceAndDice() and buff.sliceAndDice.remains() < 4 then
        if cast.sliceAndDice() then
            ui.debug("Casting Slice and Dice")
            return true
        end
    end
    -- Rupture (if available)
    -- rupture,if=ticks_remain<2&active_enemies<3
    if cast.able.rupture(units.dyn5) and debuff.rupture.ticksRemain(units.dyn5) < 2 and ui.useST(10, 3) then
        if cast.rupture(units.dyn5) then
            ui.debug("Casting Rupture")
            return true
        end
    end
    -- Crimson Tempest (if talented and available)
    -- crimson_tempest,if=(active_enemies>1&dot.crimson_tempest_dot.ticks_remain<=2&combo_points=5)|active_enemies>=5
    if talent.crimsonTempest and cast.able.crimsonTempest("player", "aoe", 1, 10) then
        if (ui.useAOE(10, 2) and debuff.crimsonTempest.ticksRemain(units.dyn10AOE) <= 2 and comboPoints() == 5)
            or ui.useAOE(10, 5)
        then
            if cast.crimsonTempest("player", "aoe", 1, 10) then
                ui.debug("Casting Crimson Tempest")
                return true
            end
        end
    end
    -- Eviscerate
    -- eviscerate,if=active_enemies<4|(active_enemies>3&dot.crimson_tempest_dot.ticks_remain>=2)
    if cast.able.eviscerate(units.dyn5) then
        if ui.useST(10, 4) or (ui.useAOE(10, 4) and (not talent.crimsonTempest or debuff.crimsonTempest.ticksRemain(units.dyn10AOE) >= 2)) then
            if cast.eviscerate(units.dyn5) then
                ui.debug("Casting Eviscerate")
                return true
            end
        end
    end
    -- Pool
    if actionList.Pool() then return true end
end -- End Action List - Finisher

-- Action List - Opener
actionList.Opener = function(thisUnit)
    -- Use provided unit or default to units.dyn5
    thisUnit = thisUnit or units.dyn5

    -- Only run if target exists and is valid
    -- unit.valid() handles: exists, alive, attackable, reaction checks
    if not unit.valid(thisUnit) then
        return false
    end

    -- If opener has already been cast AND we're in combat, skip
    -- This allows the opener to retry if we're still out of combat
    if var.openerCast and unit.inCombat() then
        return false
    end

    -- Don't fire opener while falling/moving from Shadowstep
    -- Wait at least 0.5 seconds after Shadowstep to ensure we're positioned behind target
    if unit.falling() or (cast.last.shadowstep(1) and cast.timeSinceLast.shadowstep() < 0.5) then
        return false
    end

    -- Apply Slice and Dice first if missing (can be cast from stealth without breaking it)
    if not buff.sliceAndDice.exists() and cast.able.sliceAndDice("player") and comboPoints() > 0 then
        if cast.sliceAndDice("player") then
            ui.debug("Casting Slice and Dice [Opener - Pre-buff]")
            return true -- Applied, will try opener again next frame
        end
    end

    local targetDistance = unit.distance(thisUnit)
    local behindTarget = not unit.facing(thisUnit, "player")
    local enemyCount = #enemies.yards10 -- Count enemies for AoE decision
    local inStealth = var.stealthed

    -- ==================== RANGE CHECK & SHADOWSTEP ====================
    -- If out of melee range and Shadowstep is available, use it first
    if ui.checked("Shadowstep") and targetDistance >= 8 and targetDistance <= 25
        and cast.able.shadowstep(thisUnit)
    then
        if cast.shadowstep(thisUnit) then
            ui.debug("Shadowstep to engage " .. unit.name(thisUnit) .. " [Opener]")
            return true
        end
    end

    -- If still out of melee range and can't Shadowstep, can't engage yet
    if targetDistance >= 5 then
        return false
    end

    -- ==================== STEALTH OPENERS ====================
    if inStealth then
        -- Premeditation before opener
        if cast.able.premeditation() and ui.checked("Premeditation") and comboPoints() < 5 then
            if cast.premeditation() then
                ui.debug("Casting Premeditation [Opener]")
                return true
            end
        end

        -- * AoE Opener (3+ enemies) - Fan of Knives
        if ui.useAOE(10, 3) and enemyCount >= 3 then
            if cast.able.fanOfKnives("player", "aoe", 1, 10) then
                if cast.fanOfKnives("player", "aoe", 1, 10) then
                    var.openerCast = true
                    var.openerTime = var.getTime
                    var.openerAttemptTime = nil
                    ui.debug("Casting Fan of Knives [Opener - AoE Stealth]")
                    return true
                end
            end
        end

        -- ==================== SINGLE TARGET STEALTH OPENER ====================
        -- Priority: Ambush (from behind) > Hemorrhage

        -- * Ambush - Only from behind
        if cast.able.ambush(thisUnit) then
            if behindTarget then
                -- Perfect conditions - cast Ambush
                if cast.ambush(thisUnit) then
                    var.openerCast = true
                    var.openerTime = var.getTime
                    var.openerAttemptTime = nil
                    ui.debug("Casting Ambush on " .. unit.name(thisUnit) .. " [Opener - Stealth Behind]")
                    return true
                end
                -- Ambush failed to cast (could be range, GCD, etc) - don't fall through yet
                return false
            else
                -- Not behind target - use smart timeout logic
                if not var.openerAttemptTime then
                    var.openerAttemptTime = var.getTime
                end

                local openerWaitTime = var.getTime - var.openerAttemptTime

                -- Dynamic timeout based on situation:
                -- 1. If just used Shadowstep: Give extra time (1.5s) for positioning to settle
                -- 2. If player is moving: Give more time (1.2s) - might be repositioning
                -- 3. Base timeout: 1.0s
                local timeoutDuration = 1.0 -- Base timeout

                if cast.last.shadowstep(2) then
                    timeoutDuration = 1.5 -- Give Shadowstep time to settle
                end

                -- If player is moving, we might be trying to get behind - give more time
                if unit.moving("player") then
                    timeoutDuration = math.max(timeoutDuration, 1.2)
                end

                if openerWaitTime < timeoutDuration then
                    -- Still waiting for positioning
                    return true
                else
                    -- Timeout - fall through to Hemorrhage
                    var.openerAttemptTime = nil
                end
            end
        elseif not cast.able.ambush(thisUnit) and not cast.last.ambush(1) then
            -- Ambush not available (wrong level, not learned) - but don't spam if we just cast it
        end

        -- * Hemorrhage - Fallback when Ambush not available or positioning timeout
        if cast.able.hemorrhage(thisUnit) then
            if cast.hemorrhage(thisUnit) then
                var.openerCast = true
                var.openerTime = var.getTime
                var.openerAttemptTime = nil
                ui.debug("Casting Hemorrhage on " .. unit.name(thisUnit) .. " [Opener - Stealth]")
                return true
            end
        end

        -- * Backstab - Last resort fallback
        if cast.able.backstab(thisUnit) and behindTarget then
            if cast.backstab(thisUnit) then
                var.openerCast = true
                var.openerTime = var.getTime
                var.openerAttemptTime = nil
                ui.debug("Casting Backstab on " .. unit.name(thisUnit) .. " [Opener - Stealth Fallback]")
                return true
            end
        end
    end

    -- ==================== NON-STEALTH OPENERS ====================
    if not inStealth then
        -- * AoE Non-Stealth Opener (3+ enemies)
        if ui.useAOE(10, 3) and enemyCount >= 3 then
            -- Fan of Knives for instant AoE damage
            if cast.able.fanOfKnives("player", "aoe", 1, 10) then
                if cast.fanOfKnives("player", "aoe", 1, 10) then
                    var.openerCast = true
                    var.openerTime = var.getTime
                    ui.debug("Casting Fan of Knives [Opener - AoE]")
                    return true
                end
            end
        end

        -- * Single Target Non-Stealth Opener
        -- Hemorrhage - best opener for combo point + debuff
        if cast.able.hemorrhage(thisUnit) then
            if cast.hemorrhage(thisUnit) then
                var.openerCast = true
                var.openerTime = var.getTime
                ui.debug("Casting Hemorrhage on " .. unit.name(thisUnit) .. " [Opener]")
                return true
            end
        end

        -- * Backstab - Fallback if behind target
        if cast.able.backstab(thisUnit) and behindTarget then
            if cast.backstab(thisUnit) then
                var.openerCast = true
                var.openerTime = var.getTime
                ui.debug("Casting Backstab on " .. unit.name(thisUnit) .. " [Opener - Fallback]")
                return true
            end
        end

        -- * Sinister Strike - Last resort for low levels
        if cast.able.sinisterStrike(thisUnit) then
            if cast.sinisterStrike(thisUnit) then
                var.openerCast = true
                var.openerTime = var.getTime
                ui.debug("Casting Sinister Strike on " .. unit.name(thisUnit) .. " [Opener - Low Level]")
                return true
            end
        end
    end

    return false
end -- End Action List - Opener

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Apply Poisons
        if not unit.moving() then
            -- Lethal Poison
            if ui.value("Lethal Poison") == 1 and buff.instantPoison.remain() < 300 and not cast.last.instantPoison() then
                if cast.instantPoison("player") then
                    ui.debug("Casting Instant Poison")
                    return true
                end
            end
            if ui.value("Lethal Poison") == 2 and buff.deadlyPoison.remain() < 300 and not cast.last.deadlyPoison() then
                if cast.deadlyPoison("player") then
                    ui.debug("Casting Deadly Poison")
                    return true
                end
            end
            if ui.value("Lethal Poison") == 3 and buff.woundPoison.remain() < 300 and not cast.last.woundPoison() then
                if cast.woundPoison("player") then
                    ui.debug("Casting Wound Poison")
                    return true
                end
            end
            -- Non-Lethal Poison
            if ui.value("Non-Lethal Poison") == 2 and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison() then
                if cast.cripplingPoison("player") then
                    ui.debug("Casting Crippling Poison")
                    return true
                end
            end
            if ui.value("Non-Lethal Poison") == 4 and buff.mindNumbingPoison.remain() < 300 and not cast.last.mindNumbingPoison() then
                if cast.mindNumbingPoison("player") then
                    ui.debug("Casting Mind-Numbing Poison")
                    return true
                end
            end
            if ui.value("Non-Lethal Poison") == 5 and buff.paralyticPoison.remain() < 300 and not cast.last.paralyticPoison() then
                if cast.paralyticPoison("player") then
                    ui.debug("Casting Paralytic Poison")
                    return true
                end
            end
        end
        -- Stealth
        if ui.checked("Auto Stealth") and cast.able.stealth() and not unit.resting() and not var.stealthed then
            if cast.stealth() then
                ui.debug("Casting Stealth [Pre-Combat]")
                return true
            end
        end
        -- Pick Pocket (highest priority after stealth, before opener)
        if actionList.PickPocket() then return true end
        -- Call Opener if target is valid (but NOT in Pick Pocket Only mode)
        local ppMode = getPickPocketMode()
        if ppMode ~= 2 and unit.valid("target") then
            if actionList.Opener("target") then return true end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    -- Block entire combat rotation if in Pick Pocket Only mode
    local ppMode = getPickPocketMode()
    if ppMode == 2 and not unit.inCombat() then
        return false -- Don't engage in combat in Pick Pocket Only mode
    end

    if unit.inCombat() and not var.profileStop and unit.valid("target") then
        -- * Opener - Must execute first
        if actionList.Opener() then return true end

        -- * Block entire rotation until opener has been cast AND landed
        -- This prevents any abilities from firing before the engagement opener completes
        -- Also ensure we wait at least 0.3s after opener to confirm it landed
        if not var.openerCast or (var.openerTime and var.getTime - var.openerTime < 0.3) then
            return true -- Wait for opener to execute and land
        end

        -- Auto Attack
        -- auto_attack
        if cast.able.autoAttack(units.dyn5) and unit.distance(units.dyn5) < 5 and not var.stealthed then
            if cast.autoAttack(units.dyn5) then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- Kick (Outside of Interrupt Toggle for Priority)
        -- kick
        if actionList.Interrupts() then return true end
        -- Shadowstep
        if ui.checked("Shadowstep") and cast.able.shadowstep(units.dyn5) and unit.distance(units.dyn5) > 10 then
            if cast.shadowstep(units.dyn5) then
                ui.debug("Casting Shadowstep [Combat]")
                return true
            end
        end
        -- Cooldowns
        if actionList.Cooldowns() then return true end
        -- Pool Resource for Ambush
        -- pool_resource,for_next=1
        -- ambush,if=combo_points<5|(talent.anticipation.enabled&anticipation_charges<3)|(buff.sleight_of_hand.up&buff.sleight_of_hand.remains<=gcd)
        if var.stealthed then
            if cast.able.ambush(units.dyn5) then
                if comboPoints() < 5
                    or (talent.anticipation and buff.anticipation.stack() < 3)
                    or (buff.sleightOfHand.exists() and buff.sleightOfHand.remains() <= unit.gcd(true))
                then
                    if energy() < 60 then
                        -- Pool energy
                        return true
                    end
                    if cast.ambush(units.dyn5) then
                        ui.debug("Casting Ambush [Combat]")
                        return true
                    end
                end
            end
        end
        -- Pool Resource for Shadow Dance (only if available)
        -- pool_resource,for_next=1,extra_amount=75
        -- shadow_dance,if=energy>=75&buff.stealth.down&buff.vanish.down&debuff.find_weakness.down
        if cast.able.shadowDance() and ui.alwaysCdAoENever("Shadow Dance", 3, #enemies.yards10) then
            if energy() >= 75 and not buff.stealth.exists() and not buff.vanish.exists() and not debuff.findWeakness.exists(units.dyn5) then
                if cast.shadowDance() then
                    ui.debug("Casting Shadow Dance [Combat]")
                    return true
                end
            elseif not buff.stealth.exists() and not buff.vanish.exists() and not debuff.findWeakness.exists(units.dyn5) and energy() < 75 then
                -- Pool 75 energy
                return true
            end
        end
        -- Pool Resource for Vanish (only if available)
        -- pool_resource,for_next=1,extra_amount=45
        -- vanish,if=energy>=45&energy<=75&combo_points<=3&buff.shadow_dance.down&buff.master_of_subtlety.down&debuff.find_weakness.down
        if cast.able.vanish() and ui.alwaysCdAoENever("Vanish", 3, #enemies.yards10) then
            if energy() >= 45 and energy() <= 75 and comboPoints() <= 3
                and not buff.shadowDance.exists() and not buff.masterOfSubtlety.exists()
                and not debuff.findWeakness.exists(units.dyn5)
            then
                if cast.vanish() then
                    ui.debug("Casting Vanish [Combat]")
                    return true
                end
            elseif energy() < 45 and comboPoints() <= 3
                and not buff.shadowDance.exists() and not buff.masterOfSubtlety.exists()
                and not debuff.findWeakness.exists(units.dyn5)
            then
                -- Pool 45 energy
                return true
            end
        end
        -- Marked for Death (only if talented)
        -- marked_for_death,if=talent.marked_for_death.enabled&combo_points=0
        if talent.markedForDeath and ui.checked("Marked for Death") and cast.able.markedForDeath(units.dyn5) and comboPoints() == 0 then
            if cast.markedForDeath(units.dyn5) then
                ui.debug("Casting Marked for Death [Combat]")
                return true
            end
        end
        -- Generator (for building Slice and Dice / Rupture) - only if Anticipation talented
        -- run_action_list,name=generator,if=talent.anticipation.enabled&anticipation_charges<4&buff.slice_and_dice.up&dot.rupture.remains>2&(buff.slice_and_dice.remains<6|dot.rupture.remains<4)
        if talent.anticipation and buff.anticipation.stack() < 4 and buff.sliceAndDice.exists() and debuff.rupture.remains(units.dyn5) > 2
            and (buff.sliceAndDice.remains() < 6 or debuff.rupture.remains(units.dyn5) < 4)
        then
            if actionList.Generator() then return true end
        end
        -- Finisher (flexible combo point requirement for leveling)
        -- run_action_list,name=finisher,if=combo_points>=5 or (combo_points>=3 and level<20)
        if comboPoints() >= 5 or (comboPoints() >= 3 and unit.level("player") < 20) then
            if actionList.Finisher() then return true end
        end
        -- Generator
        -- run_action_list,name=generator,if=combo_points<4|energy>80|talent.anticipation.enabled
        if comboPoints() < 4 or energy() > 80 or talent.anticipation then
            if actionList.Generator() then return true end
        end
        -- Pool
        -- run_action_list,name=pool
        if actionList.Pool() then return true end
    end
end -- End Action List - Combat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- BR API
    if comboPoints == nil then
        comboPoints = power.comboPoints
        energy      = power.energy
    end

    -- Get Best Unit for Range
    units.get(5)
    units.get(10, true)
    units.get(30)

    -- Get List of Enemies for Range
    enemies.get(5)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)

    -- General Vars
    var.getTime = ui.time()
    var.stealthed = isStealthed()
    checkPickPocketResult()

    -- Reset opener flag when out of combat
    if not unit.inCombat() then
        if var.profileStop then var.profileStop = false end
        var.openerCast = false -- Reset opener flag
        var.openerTime = nil -- Reset opener time
        var.openerAttemptTime = nil -- Reset opener attempt timer

        -- Clear Pick Pocket in-flight tracking when out of combat
        -- BUT only if it's been more than 2 seconds (don't clear if we just cast it)
        if var.pickPocketCastTime > 0 and (var.getTime - var.pickPocketCastTime) > 2.0 then
            var.pickPocketCastTime = 0
            var.pickPocketLastGUID = nil
        end

        -- Clean up old Pick Pocket tracking (keep recent attempts for persistence)
        -- Only clear entries that are more than 5 minutes old
        local currentTime = var.getTime
        for guid, _ in pairs(var.pickPocketSuccess) do
            -- Keep successful picks indefinitely during session, only clear on reload
        end
        for guid, timestamp in pairs(var.pickPocketAttempted) do
            if type(timestamp) == "number" and (currentTime - timestamp) > 300 then
                var.pickPocketAttempted[guid] = nil
            end
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation == 4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if actionList.Combat() then return true end
    end
end -- runRotation

registerRotation({
    handlesRacials = true,
    name      = rotationName,
    specID    = 261,
    expansion = "MOP",
    author    = "CuteOne",
    patch     = "5.4.8 (Mists of Pandaria)",
    coverage  = "100%",
    status    = "Full",
    readiness = "Basic",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})

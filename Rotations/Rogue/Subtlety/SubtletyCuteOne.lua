-------------------------------------------------------
-- Author = CuteOne
-- Patch = 5.4.8 (Mists of Pandaria)
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Basic
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.fanOfKnives },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.fanOfKnives },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.backstab },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.stealth }
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.shadowBlades },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.shadowBlades },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.shadowBlades }
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.evasion },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.evasion }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.kick },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.kick }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Pick Pocket Button
    local PickPocketModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Pick Pocket Auto", tip = "Automatically Pick Pocket before engaging, minimal delay.", highlight = 1, icon = br.player.spells.pickPocket },
        [2] = { mode = "Only", value = 2, overlay = "Pick Pocket Only", tip = "Only Pick Pocket targets (Sap > Pick Pocket > Clear Target).", highlight = 0, icon = br.player.spells.pickPocket },
        [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Never Pick Pocket.", highlight = 0, icon = br.player.spells.pickPocket }
    }
    br.ui:createToggle(PickPocketModes, "PickPocket", 5, 0)
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
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minutes. Min: 5 / Max: 60 / Interval: 5")
        -- Auto Stealth
        br.ui:createCheckbox(section, "Auto Stealth")
        -- Stealth Breaker
        br.ui:createDropdownWithout(section, "Stealth Breaker",
            { "|cff00FF00Ambush", "|cffFF0000Hemorrhage" }, 1,
            "|cffFFFFFFSet what to break Stealth with.")
        -- Poisons
        br.ui:createDropdownWithout(section, "Lethal Poison", { "|cffFFFFFFInstant", "|cffFFFFFFDeadly", "|cffFFFFFFWound" }, 2,
            "|cffFFFFFFSelect Lethal Poison to use.")
        br.ui:createDropdownWithout(section, "Non-Lethal Poison", { "|cffFFFFFFNone", "|cffFFFFFFCrippling", "|cffFFFFFFMind-Numbing", "|cffFFFFFFParalytic" }, 2,
            "|cffFFFFFFSelect Non-Lethal Poison to use.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Shadowstep
        br.ui:createCheckbox(section, "Shadowstep")
        -- Shadow Blades
        br.ui:createDropdownWithout(section, "Shadow Blades", br.ui.dropOptions.AlwaysCdAoeNever,
            2, "|cffFFFFFFWhen to use Shadow Blades.")
        -- Shadow Dance
        br.ui:createDropdownWithout(section, "Shadow Dance", br.ui.dropOptions.AlwaysCdAoeNever,
            2, "|cffFFFFFFWhen to use Shadow Dance.")
        -- Vanish
        br.ui:createDropdownWithout(section, "Vanish", br.ui.dropOptions.AlwaysCdAoeNever,
            2, "|cffFFFFFFWhen to use Vanish.")
        -- Preparation
        br.ui:createCheckbox(section, "Preparation")
        -- Premeditation
        br.ui:createCheckbox(section, "Premeditation")
        -- Marked for Death
        br.ui:createCheckbox(section, "Marked for Death")
        -- Use Racial
        br.ui:createCheckbox(section, "Use Racial")
        -- Use Combat Potion
        br.ui:createCheckbox(section, "Use Combat Potion")
        -- Trinkets
        br.player.module.BasicTrinkets(section)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Cloak of Shadows
        br.ui:createCheckbox(section, "Cloak of Shadows")
        -- Combat Readiness
        br.ui:createSpinner(section, "Combat Readiness", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Evasion
        br.ui:createSpinner(section, "Evasion", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Feint
        br.ui:createSpinner(section, "Feint", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Recuperate
        br.ui:createSpinner(section, "Recuperate", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Kick
        br.ui:createCheckbox(section, "Kick")
        -- Kidney Shot
        br.ui:createCheckbox(section, "Kidney Shot")
        -- Gouge
        br.ui:createCheckbox(section, "Gouge")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percentage to use at. (0 is random)")
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
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle, 6)
        -- Pick Pocket Key Toggle
        br.ui:createDropdownWithout(section, "Pick Pocket Mode", br.ui.dropOptions.Toggle, 6)
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
local actionList = {}
local buff
local cast
local cd
local charges
local comboPoints
local debuff
local enemies
local energy
local equiped
local items
local module
local spell
local talent
local ui
local unit
local units
local use
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
    return br.data.settings[br.loader.selectedSpec].toggles["PickPocket"] or 3
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
    local guid = br._G.UnitGUID(thisUnit)
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

local function markPickPocketResult(thisUnit, success, lootMsg, errorMsg)
    local guid = br._G.UnitGUID(thisUnit)
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
        -- Use br.player.ui directly since this may be called from event handler
        if br.player and br.player.ui then
            br.player.ui.debug("|cff00FF00[Pick Pocket]|r Success" .. itemInfo)
        end
    else
        var.pickPocketFailed[guid] = true
        var.pickPocketAttempted[guid] = nil
        -- Use br.player.ui and br.player.unit directly since this may be called from event handler
        if br.player and br.player.ui then
            if errorMsg then
                br.player.ui.debug("|cffFF0000[Pick Pocket]|r Failed: " .. errorMsg)
            else
                local unitName = br.player.unit and br.player.unit.name(thisUnit) or thisUnit
                br.player.ui.debug("|cffFF0000[Pick Pocket]|r Failed on " .. unitName)
            end
        end
    end
end

-- Event handler for Pick Pocket detection
local pickPocketFrame = pickPocketFrame or br._G.CreateFrame("Frame")
pickPocketFrame:RegisterEvent("UI_ERROR_MESSAGE")
pickPocketFrame:RegisterEvent("CHAT_MSG_LOOT")
pickPocketFrame:RegisterEvent("CHAT_MSG_MONEY")
pickPocketFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "UI_ERROR_MESSAGE" then
        local errorType, msg = ...
        local currentTime = br._G.GetTime()

        -- DEBUG: Log all errors to see what's coming through
        local errorString = br._G.GetGameMessageInfo(errorType)

        -- DEBUG: Try direct print to avoid br.player.ui issues
        -- pcall(function()
        --     if br.player and br.player.ui then
        --         br.player.ui.debug("[PP Event] Error: " .. tostring(errorString) .. " | Type: " .. tostring(errorType) .. " | Msg: " .. tostring(msg))
        --     end
        -- end)

        -- Try printing directly to see if br.player.ui is the issue
        -- pcall(print, "[PP Event DEBUG] CastTime:", var.pickPocketCastTime, "CurrentTime:", currentTime)        -- Only process errors that occurred shortly after Pick Pocket cast
        -- Extended window to 2.0s to account for GCD + network delay
        -- AND verify we actually have a Pick Pocket in flight
        if var.pickPocketCastTime > 0 and (currentTime - var.pickPocketCastTime) < 2.0
            and var.pickPocketLastGUID then

            -- pcall(function()
            --     br.player.ui.debug("[PP Event] Within time window. Time since cast: " .. tostring(currentTime - var.pickPocketCastTime))
            -- end)

            -- Verify the target is still the same one we tried to Pick Pocket
            local currentGUID = br._G.UnitGUID("target")
            if currentGUID ~= var.pickPocketLastGUID then
                -- Target changed, ignore this error
                -- pcall(function()
                --     br.player.ui.debug("[PP Event] Target changed, ignoring")
                -- end)
                return
            end

            -- pcall(function()
            --     br.player.ui.debug("[PP Event] Checking error type: " .. tostring(errorString))
            -- end)

            -- Use language-agnostic error type IDs
            -- ERR_SPELL_FAILED_S = Generic spell failure (covers "no pockets to pick")
            -- ERR_ALREADY_PICKPOCKETED = Already pickpocketed this target
            -- ERR_NO_LOOT = Target has no loot (empty pockets)
            -- SPELL_FAILED_BAD_TARGETS = Invalid target
            -- SPELL_FAILED_TARGET_ENEMY = Must be an enemy

            if errorString == "ERR_SPELL_FAILED_S" or
               errorString == "ERR_ALREADY_PICKPOCKETED" or
               errorString == "ERR_NO_LOOT" or
               errorString == "SPELL_FAILED_BAD_TARGETS" or
               errorString == "SPELL_FAILED_TARGET_ENEMY" then
                -- msg contains the actual localized error message shown to player
                -- pcall(print, "[PP Event] Calling markPickPocketResult with error:", msg)
                markPickPocketResult("target", false, nil, msg)
                var.pickPocketCastTime = 0
                var.pickPocketLastGUID = nil
            end
        end
    elseif event == "CHAT_MSG_LOOT" or event == "CHAT_MSG_MONEY" then
        local msg = ...
        local currentTime = br._G.GetTime()

        -- DEBUG: Print to see if we're catching money events
        -- pcall(print, "[PP Event] Loot/Money:", event, "Msg:", msg, "CastTime:", var.pickPocketCastTime, "GetTime:", currentTime)

        -- Detect successful Pick Pocket by loot message (language-agnostic item link detection)
        -- Or money message (CHAT_MSG_MONEY fires when you get gold/silver/copper)
        if msg and var.pickPocketCastTime > 0 and (currentTime - var.pickPocketCastTime) < 2.0
            and var.pickPocketLastGUID then
            -- pcall(print, "[PP Event] Conditions met - calling success")
            -- Check if message contains item links [Item Name] OR if it's a money event
            if msg:find("%[.+%]") or event == "CHAT_MSG_MONEY" then
                markPickPocketResult("target", true, msg)
                var.pickPocketCastTime = 0
                var.pickPocketLastGUID = nil
            else
                -- pcall(print, "[PP Event] No item link found and not money event")
            end
        else
            -- pcall(print, "[PP Event] Conditions NOT met - CastTime:", var.pickPocketCastTime, "Diff:", currentTime - var.pickPocketCastTime, "GUID:", var.pickPocketLastGUID)
        end
    end
end)

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
        local guid = br._G.UnitGUID("target")
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
            br._G.ClearTarget()
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
                    var.pickPocketCastTime = br._G.GetTime()
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
            local targetGUID = br._G.UnitGUID("target")
            var.pickPocketCastTime = br._G.GetTime()
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
        buff        = br.player.buff
        cast        = br.player.cast
        cd          = br.player.cd
        charges     = br.player.charges
        comboPoints = br.player.power.comboPoints
        debuff      = br.player.debuff
        enemies     = br.player.enemies
        energy      = br.player.power.energy
        equiped     = br.player.equiped
        items       = br.player.items
        module      = br.player.module
        spell       = br.player.spell
        talent      = br.player.talent
        ui          = br.player.ui
        unit        = br.player.unit
        units       = br.player.units
        use         = br.player.use
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
    var.getTime = br._G.GetTime()
    var.stealthed = isStealthed()

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

local id = 261
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

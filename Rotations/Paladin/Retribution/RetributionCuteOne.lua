-------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 90%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Sporadic
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
        [1] = {mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.divineStorm},
        [2] = {mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.divineStorm},
        [3] = {mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.crusaderStrike},
        [4] = {mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.flashOfLight}
    }
   br.ui:createToggle(RotationModes,"Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avengingWrath},
        [2] = {mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avengingWrath},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avengingWrath}
    }
   br.ui:createToggle(CooldownModes,"Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.flashOfLight},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.flashOfLight}
    }
   br.ui:createToggle(DefensiveModes,"Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice}
    }
   br.ui:createToggle(InterruptModes,"Interrupt", 4, 0)
    -- Aura
    local AuraModes = {
        [1] = {mode = "Con", value = 1, overlay = "Concentration Aura", tip = "Use Concentration Aura", highlight = 0, icon = br.player.spell.concentrationAura},
        [2] = {mode = "Dev", value = 2, overlay = "Devotion Aura", tip = "Use Devotion Aura", highlight = 0, icon = br.player.spell.devotionAura},
        [3] = {mode = "Ret", value = 2, overlay = "Retribution Aura", tip = "Use Retribution Aura", highlight = 0, icon = br.player.spell.retributionAura}
    }
   br.ui:createToggle(AuraModes,"Aura", 5, 0)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never"}
        local playTarMouseFocLow = {"|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFLowest"}
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Blessing of Freedom
        br.ui:createDropdown(section, "Blessing of Freedom", playTarMouseFocLow, 1, "|cffFFFFFFTarget to Cast On")
        -- Hand of Hindrance
        br.ui:createCheckbox(section, "Hand of Hindrance")
        -- Divine Storm Units
        br.ui:createSpinnerWithout(section, "Divine Storm Units", 2, 1, 5, 1, "|cffFFBB00Units to use Divine Storm.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Potion
        -- br.ui:createCheckbox(section,"Potion")
        -- FlaskUp Module
        br.player.module.FlaskUp("Strength", section)
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.player.module.BasicTrinkets(nil, section)
        -- Covenant Ability
        br.ui:createDropdownWithout(section, "Covenant Ability", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Avenging Wrath
        br.ui:createDropdownWithout(section, "Avenging Wrath", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Crusade
        br.ui:createDropdownWithout(section, "Crusade", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Execution Sentence
        br.ui:createDropdownWithout(section, "Execution Sentence", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Final Reckoning
        br.ui:createDropdownWithout(section, "Final Reckoning", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Holy Avenger
        br.ui:createDropdownWithout(section, "Holy Avenger", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Seraphim
        br.ui:createDropdownWithout(section, "Seraphim", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Shield of Vengeance
        br.ui:createDropdownWithout(section, "Shield of Vengeance - CD", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Wake of Ashes
        br.ui:createDropdownWithout(section, "Wake of Ashes", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Blessing of Protection
        br.ui:createSpinner(section, "Blessing of Protection", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createDropdownWithout(section, "Blessing of Protection Target", playTarMouseFocLow, 5, "|cffFFFFFFTarget for Blessing of Protection")
        -- Blessing of Sacrifice
        br.ui:createDropdown(section, "Blessing of Sacrifice", playTarMouseFocLow, 5, "|cffFFFFFFTarget for Blessing of Sacrifice")
        br.ui:createSpinnerWithout(section, "Friendly HP", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Personal HP Limit", 80, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Blinding Light
        br.ui:createSpinner(section, "Blinding Light", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Blinding Light Units", 3, 1, 5, 1, "|cffFFFFFFUnits to Cast On")
        -- Cleanse Toxin
        br.ui:createDropdown(section, "Cleanse Toxins", playTarMouseFocLow, 1, "|cffFFFFFFTarget to Cast On")
        -- Divine Shield
        br.ui:createSpinner(section, "Divine Shield", 35, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Eye for an Eye
        br.ui:createSpinner(section, "Eye for an Eye", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Flash of Light
        br.ui:createSpinner(section, "Flash of Light", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createDropdownWithout(section, "Flash of Light Target", playTarMouseFocLow, 5, "|cffFFFFFFTarget for Flash of Light")
        -- Hammer of Justice
        br.ui:createSpinner(section, "Hammer of Justice - HP", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Justicar's Vengeance
        br.ui:createSpinner(section, "Justicar's Vengeance", 45, 0, 100, 5, "|cffFFBB00Health Percentage to use at over Templar's Verdict.")
        -- Lay On Hands
        br.ui:createSpinner(section, "Lay On Hands", 20, 0, 100, 5, "", "Health Percentage to use at")
        br.ui:createDropdownWithout(section, "Lay on Hands Target", playTarMouseFocLow, 5, "|cffFFFFFFTarget for Lay On Hands")
        -- Redemption
        br.ui:createDropdown(section, "Redemption", {"|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus"}, 1, "|cffFFFFFFTarget to Cast On")
        -- Shield of Vengeance
        br.ui:createSpinner(section, "Shield of Vengeance", 55, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Turn Evil
        br.ui:createCheckbox(section, "Turn Evil")
        -- Word of Glory
        br.ui:createSpinner(section, "Word of Glory", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Blinding Light
        br.ui:createCheckbox(section, "Blinding Light - Int")
        -- Hammer of Justice
        br.ui:createCheckbox(section, "Hammer of Justice")
        -- Rebuke
        br.ui:createCheckbox(section, "Rebuke")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        --Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        --Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Wake of Ashes Key Toggle
        br.ui:createDropdownWithout(section, "Wake Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

local debugprofilestop = br._G["debugprofilestop"]

--------------
--- Locals ---
--------------
-- BR API
local buff
local cast
local cd
local charges
local conduit
local covenant
local debuff
local enemies
local holyPower
local module
local race
local runeforge
local talent
local ui
local unit
local units
local var

------------------------
--- Custom Functions ---
------------------------
local canGlory = function()
    local optionValue = ui.value("Word of Glory")
    local otherCounter = 0
    if holyPower >= 3 then
        if #br.friend == 1 then
            if unit.hp("player") <= optionValue then
                var.gloryUnit = "player"
                return true
            end
        end
        for i = 1, #br.friend do
            local thisUnit = br.friend[i].unit
            local thisHP = unit.hp(thisUnit)
            if thisHP < optionValue then
                -- Emergency Single
                if thisHP < 25 then
                    var.gloryUnit = thisUnit
                    return true
                end
                -- Group Heal
                if otherCounter < 2 then
                    for j = 1, #br.friend do
                        local otherUnit = br.friend[j].unit
                        local otherHP = unit.hp(otherUnit)
                        local distanceFromYou = unit.distance(otherUnit, "player")
                        if distanceFromYou < 30 and otherHP < optionValue then
                            otherCounter = otherCounter + 1
                        end
                    end
                else
                    var.gloryUnit = thisUnit
                    return true
                end
            end
        end
    end
    return false
end

local getHealUnitOption = function(option, checkForbearance)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then
        thisUnit = "player"
    end
    if thisTar == 2 then
        thisUnit = "target"
    end
    if thisTar == 3 then
        thisUnit = "mouseover"
    end
    if thisTar == 4 then
        thisUnit = "focus"
    end
    if thisTar == 5 then
        thisUnit = var.lowestUnit
        -- Get the next lowest unit if lowest unit has Forbearance debuff
        if checkForbearance and #br.friend > 1 and debuff.forbearance.exists(thisUnit) then
            for i = 1, #br.friend do
                local nextUnit = br.friend[i].unit
                if not debuff.forbearance.exists(nextUnit) then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

local findEvil = function()
    for i = 1, #enemies.yards20 do
        local thisUnit = enemies.yards20[i]
        if unit.undead() or unit.aberration() or unit.demon() then
            return thisUnit
        end
    end
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") and unit.isDummy() then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
    -- Blessing of Freedom
    if ui.checked("Blessing of Freedom") then
        var.freedomUnit = getHealUnitOption("Blessing of Freedom")
        if cast.able.blessingOfFreedom(var.freedomUnit) and cast.noControl.blessingOfFreedom(var.freedomUnit) and unit.distance(var.freedomUnit) < 40 then
            if cast.blessingOfFreedom(var.freedomUnit) then
                ui.debug("Casting Blessing of Freedom")
                return true
            end
        end
    end
    -- Hand of Hindrance
    if ui.checked("Hand of Hindrance") and cast.able.handOfHindrance("target") and unit.moving("target")
        and not unit.facing("target", "player") and unit.distance("target") > 8 and unit.hp("target") < 25
    then
        if cast.handOfHindrance("target") then
            ui.debug("Casting Hand of Hindrance on " .. unit.name("target"))
            return true
        end
    end
end -- End Action List - Extras
-- Action List - Defensives
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Blessing of Protection
        if ui.checked("Blessing of Protection", true) then
            var.protectionUnit = getHealUnitOption("Blessing of Protection Target")
            if var.protectionUnit ~= nil and cast.able.blessingOfProtection(var.protectionUnit) and unit.inCombat(var.protectionUnit)
                and unit.role(var.protectionUnit) ~= "TANK" and not debuff.forbearance.exists(var.protectionUnit)
                and unit.hp(var.protectionUnit) < ui.value("Blessing of Protection") and unit.distance(var.protectionUnit) < 40
            then
                if cast.blessingOfProtection(var.protectionUnit) then
                    ui.debug("Casting Blessing of Protection on " .. unit.name(var.protectionUnit) .. " [" .. unit.hp(var.protectionUnit) .. "% Remaining]")
                    return true
                end
            end
        end
        -- Blessing of Sacrifice
        if ui.checked("Blessing of Sacrifice") then
           var.sacificeUnit = getHealUnitOption("Blessing of Sacrifice")
            if var.sacrificeUnit ~= nil and cast.able.blessingOfSacrifice(var.sacificeUnit) and unit.inCombat(var.sacificeUnit) and unit.distance(var.sacificeUnit) < 40
                and unit.hp(var.sacificeUnit) < ui.value("Friendly HP") and unit.hp() >= ui.value("Personal HP Limit")
            then
                if cast.blessingOfSacrifice(var.sacificeUnit) then
                    ui.debug("Casting Blessing of Sacrifice on " .. unit.name(var.sacificeUnit) .. " [" .. unit.hp(var.sacificeUnit) .. "% Remaining]")
                    return true
                end
            end
        end
        -- Blinding Light
        if ui.checked("Blinding Light") and unit.inCombat() and #enemies.yards10 >= ui.value("Blinding Light Units") and unit.hp() < ui.value("Blinding Light") then
            if cast.blindingLight() then
                ui.debug("Casting Blinding Light")
                return true
            end
        end
        -- Cleanse Toxins
        if ui.checked("Cleanse Toxins") then
            var.cleanseUnit = getHealUnitOption("Cleanse Toxin")
            if var.cleanseUnit ~= nil and cast.able.cleanseToxins(var.cleanseUnit) and cast.dispel.cleanseToxins(var.cleanseUnit) and unit.distance(var.cleanseUnit) < 40 then
                if cast.cleanseToxins(var.cleanseUnit) then
                    ui.debug("Casting Cleanse Toxins on " .. unit.name(var.cleanseUnit))
                    return true
                end
            end
        end
        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() and unit.inCombat() then
            if unit.hp() <= ui.value("Divine Shield") and not debuff.forbearance.exists("player") then
                if cast.divineShield() then
                    ui.debug("Casting Divine Shield")
                    return true
                end
            end
        end
        -- Eye for an Eye
        if ui.checked("Eye for an Eye") and cast.able.eyeForAnEye() and unit.inCombat() then
            if unit.hp() <= ui.value("Eye for an Eye") and #enemies.yards5 > 0 then
                if cast.eyeForAnEye() then
                    ui.debug("Casting Eye For An Eye")
                    return true
                end
            end
        end
        -- Flash of Light
        if ui.checked("Flash of Light") and not (unit.mounted() or unit.flying()) and not cast.current.flashOfLight() then
            var.flashUnit = getHealUnitOption("Flash of Light Target")
            if var.flashUnit ~= nil and cast.able.flashOfLight(var.flashUnit) and unit.distance(var.flashUnit) < 40 then
                -- Instant Cast
                if talent.selflessHealer and buff.selflessHealer.stack() == 4 then
                    -- Don't waste instant heal!
                    var.flashUnit = unit.hp(var.flashUnit) <= ui.value("Flash of Light") and var.flashUnit or var.lowestUnit
                    if cast.flashOfLight(var.flashUnit) then
                        ui.debug("Casting Flash of Light on " .. unit.name(var.flashUnit) .. " [Instant]")
                        return true
                    end
                end
                -- Long Cast
                if not unit.moving("player") and (var.forceHeal
                    or (unit.inCombat() and unit.hp(var.flashUnit) <= ui.value("Flash of Light"))
                    or (not unit.inCombat() and unit.hp(var.flashUnit) <= 90))
                then
                    if cast.flashOfLight(var.flashUnit) then
                        ui.debug("Casting Flash of Light on " .. unit.name(var.flashUnit) .. " [Long]")
                        return true
                    end
                end
            end
        end
        -- Hammer of Justice
        if ui.checked("Hammer of Justice - HP") and cast.able.hammerOfJustice() and unit.inCombat() then
            if unit.hp() <= ui.value("Hammer of Justice - HP") then
                if cast.hammerOfJustice() then
                    ui.debug("Casting Hammer of Justice [Defensive]")
                    return true
                end
            end
        end
        -- Justicar's Vengeance
        if ui.checked("Justicar's Vengeance") and cast.able.justicarsVengeance() and unit.inCombat() and holyPower >= 5 then
            if unit.hp() <= ui.value("Justicar's Vengeance") then
                if cast.justicarsVengeance() then
                    ui.debug("Casting Justicar's Vengeance")
                    return true
                end
            end
        end
        -- Lay On Hands
        if ui.checked("Lay On Hands") then
            var.layUnit = getHealUnitOption("Lay On Hands Target", true)
            if var.layUnit ~= nil and cast.able.layOnHands(var.layUnit) and unit.inCombat(var.layUnit) and not debuff.forbearance.exists(var.layUnit)
                and unit.hp(var.layUnit) <= ui.value("Lay On Hands") and unit.distance(var.layUnit) < 40
            then
                if cast.layOnHands(var.layUnit) then
                    ui.debug("Casting Lay On Hands on " .. tostring(unit.name(var.layUnit)) .. " [" .. tostring(unit.hp(var.layUnit)) .. "% Remaining]")
                    return true
                end
            end
        end
        -- Redemption
        if ui.checked("Redemption") and not unit.moving("player") and var.resable then
            local redemptionTar = ui.value("Redemption")
            local redemptionUnit
            if redemptionTar == 1 then
                redemptionUnit = "target"
            end
            if redemptionTar == 2 then
                redemptionUnit = "mouseover"
            end
            if redemptionTar == 3 then
                redemptionUnit = "focus"
            end
            if redemptionUnit ~= nil and cast.able.redemption(redemptionUnit, "dead") then
                if cast.redemption(redemptionUnit, "dead") then
                    ui.debug("Casting Redemption on " .. unit.name(redemptionUnit))
                    return true
                end
            end
        end
        -- Shield of Vengeance
        if ui.checked("Shield of Vengeance") and cast.able.shieldOfVengeance() and unit.inCombat() then
            if unit.hp() <= ui.value("Shield of Vengeance") and unit.ttdGroup(8) > 15 then
                if cast.shieldOfVengeance() then
                    ui.debug("Casting Shield of Vengeance")
                    return true
                end
            end
        end
        -- Turn Evil
        if ui.checked("Turn Evil") and unit.inCombat() then
            local thisUnit = findEvil()
            if cast.able.turnEvil(thisUnit) and unit.hp() < ui.value("Turn Evil") and not debuff.turnEvil.exists(var.turnedEvil) then
                if cast.turnEvil(thisUnit) then
                    ui.debug("Casting Turn Evil")
                    var.turnedEvil = thisUnit
                    return true
                end
            end
        end
        -- Word of Glory
        if ui.checked("Word of Glory") and canGlory() then
            if var.gloryUnit ~= nil and cast.able.wordOfGlory(var.gloryUnit) then
                if cast.wordOfGlory(var.gloryUnit) then
                    ui.debug("Casting Word of Glory on " .. unit.name(var.gloryUnit))
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive
-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards20 do
            var.interruptUnit = enemies.yards20[i]
            local distance = unit.distance(var.interruptUnit)
            if unit.interruptable(var.interruptUnit, ui.value("Interrupt At")) then
                -- Blinding Light
                if ui.checked("Blinding Light - Int") and cast.able.blindingLight(var.interruptUnit) and distance < 10 and
                    ((cd.rebuke.remains() > unit.gcd() or distance >= 5) and cd.hammerOfJustice.remains() > unit.gcd())
                then
                    if cast.blindingLight() then
                        ui.debug("Casting Blinding Light [Interrupt]")
                        return true
                    end
                end
                -- Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice(var.interruptUnit) and distance < 10 and (cd.rebuke.remains() > unit.gcd() or distance >= 5) then
                    if cast.hammerOfJustice(var.interruptUnit) then
                        ui.debug("Casting Hammer of Justice [Interrupt]")
                        return true
                    end
                end
                -- Rebuke
                if ui.checked("Rebuke") and cast.able.rebuke(var.interruptUnit) and distance < 5 then
                    if cast.rebuke(var.interruptUnit) then
                        ui.debug("Casting Rebuke")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - Interrupts
-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- -- Potion
    -- potion,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10|fight_remains<25
    -- if ui.checked("Potion") and use.able.potionOfFocusedResolve() and unit.instance("raid") then
    --     if (cd.guardianOfAzeroth.remain() > 90 or not essence.condensedLifeForce.active)
    --         and (hasBloodlust() or (buff.avengingWrath.exists() and buff.avengingWrath.remain() > 18)
    --             or (buff.crusade.exists() and buff.crusade.remain() < 25))
    --     then
    --         use.potionOfFocusedResolve()
    --         ui.debug("Used Potion of Focused Resolve")
    --     end
    -- end
    -- Racial
    if ui.checked("Racial") and cast.able.racial() then
        -- lights_judgment,if=spell_targets.lights_judgment>=2|!raid_event.adds.exists|raid_event.adds.in>75|raid_event.adds.up
        if ui.useCDs() and race == "LightforgedDraenei" and not unit.isUnit("player",var.highestEnemy) then
            if cast.racial(var.highestEnemy) then
                ui.debug("Casting Racial: Lightforged Draenei")
                return true
            end
        end
        -- fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
        if race == "DarkIronDwarf" and
                (unit.level() < 37 or buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack() == 10) or
                    ((not ui.alwaysCdNever("Avenging Wrath") and not talent.crusade) or (talent.crusade and not ui.alwaysCdNever("Crusade"))))
        then
            if cast.racial() then
                ui.debug("Casting Racial: Dark Iron Dwarf")
                return true
            end
        end
    end
    -- Shield of Vengenace
    -- shield_of_vengeance,if=(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains<52)&fight_remains>15
    if ui.alwaysCdNever("Shield of Vengeance - CD") and cast.able.shieldOfVengeance() and (not talent.executionSentence or cd.executionSentence.remain() < 52) and unit.ttdGroup(8) > 15 then
        if cast.shieldOfVengeance() then
            ui.debug("Casting Shield of Vengeance [CD]")
            return true
        end
    end
    -- Trinkets
    if #enemies.yards5 > 0 and unit.standingTime() >= 2 then
        module.BasicTrinkets()
    end
    -- Avenging Wrath
    -- avenging_wrath,if=(holy_power>=4&time<5|holy_power>=3&(time>5|runeforge.the_magistrates_judgment)|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)&(!talent.seraphim.enabled|cooldown.seraphim.remains>0|talent.sanctified_wrath.enabled)
    if ui.alwaysCdNever("Avenging Wrath") and not talent.crusade and cast.able.avengingWrath() and unit.distance("target") < 5
        and (holyPower >= 4 and unit.combatTime() < 5 or holyPower >= 3 and (unit.combatTime() > 5 or runeforge.theMagistratesJudgment.equiped) or talent.holyAvenger and not cd.holyAvenger.exists())
        and (not talent.seraphim or cd.seraphim.exists() or not ui.alwaysCdNever("Seraphim") or talent.sanctifiedWrath)
    then
        if cast.avengingWrath() then ui.debug("Casting Avenging Wrath") return true end
    end
    -- Crusade
    -- crusade,if=holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0
    if ui.alwaysCdNever("Crusade") and talent.crusade and cast.able.crusade()
        and (holyPower >= 4 and unit.combatTime() < 5 or holyPower >= 3 and unit.combatTime() > 5 or talent.holyAvenger and not cd.holyAvenger.exists())
    then
        if cast.crusade() then ui.debug("Casting Crusade") return true end
    end
    -- Ashen Hallow
    -- ashen_hallow
    --if ui.alwaysCdNever("Covenant Ability") and cast.able.ashenHallow() then
    --    if cast.ashenHallow() then ui.debug("Casting Ashen Hallow [Venthyr]") return true end
    --end
    -- Holy Avenger
    -- holy_avenger,if=time_to_hpg=0&(buff.avenging_wrath.up|buff.crusade.up|buff.avenging_wrath.down&cooldown.avenging_wrath.remains>40|buff.crusade.down&cooldown.crusade.remains>40)
    if ui.alwaysCdNever("Holy Avenger") and cast.able.holyAvenger() and var.timeToHPG == 0 and (buff.avengingWrath.exists() or buff.crusade.exists()
        or (not buff.avengingWrath.exists() and (cd.avengingWrath.remains() > 40 or not ui.alwaysCdNever("Avenging Wrath")))
        or (not buff.crusade.exists() and (buff.crusade.remains() > 40 or not ui.alwaysCdNever("Crusade"))))
    then
        if cast.holyAvenger() then ui.debug("Casting Holy Avenger") return true end
    end
    -- Final Reckoning
    -- final_reckoning,if=(holy_power>=4&time<8|holy_power>=3&time>=8)&cooldown.avenging_wrath.remains>gcd&time_to_hpg=0&(!talent.seraphim.enabled|buff.seraphim.up)&(!raid_event.adds.exists|raid_event.adds.up|raid_event.adds.in>40)
    if ui.alwaysCdNever("Final Reckoning") and cast.able.finalReckoning()
        and ((holyPower >= 4 and unit.combatTime() < 8) or (holyPower >= 3 and unit.combatTime() >= 8))
        and (cd.avengingWrath.remains() > unit.gcd(true) or talent.crusade or not ui.alwaysCdNever("Avenging Wrath"))
        and var.timeToHPG == 0 and (not talent.seraphim or buff.seraphim.exists() or not ui.alwaysCdNever("Seraphim"))
    then
        if cast.finalReckoning() then ui.debug("Casting Final Reckoning") return true end
    end
end -- End Action List - Cooldowns
-- Action List - Finisher
actionList.Finisher = function()
    -- Seraphim
    -- seraphim,if=(cooldown.avenging_wrath.remains>15|cooldown.crusade.remains>15|talent.final_reckoning.enabled)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains<=gcd*3&(!raid_event.adds.exists|raid_event.adds.in>40|raid_event.adds.in<gcd|raid_event.adds.up))&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains<=gcd*3|talent.final_reckoning.enabled)&(!covenant.kyrian|cooldown.divine_toll.remains<9)|target.time_to_die<15&target.time_to_die>5
    if ui.alwaysCdNever("Seraphim") and cast.able.seraphim()
        and (((not talent.crusade and (cd.avengingWrath.remains() > 15 or not ui.alwaysCdNever("Avenging Wrath")))
            or (talent.crusade and (cd.crusade.remains() > 15 or not ui.alwaysCdNever("Crusade"))) or talent.finalReckoning)
        and (not talent.finalReckoning or cd.finalReckoning.remains() <= unit.gcd(true) * 3 or holyPower == 5 or ui.alwaysCdNever("Final Reckoning"))
        and (not talent.executionSentence or (cd.executionSentence.remains() <= unit.gcd(true) * 3 or talent.finalReckoning or ui.alwaysCdNever("Execution Sentence")))
        and (not covenant.kyrian.active or cd.divineToll.remain() < 9 or holyPower == 5)) --or unit.ttdGroup(5) < 15 and unit.ttdGroup(5) > 5)
    then
        if cast.seraphim() then ui.debug("Casting Seraphim") return true end
    end
    -- -- Vanquisher's Hammer
    -- -- vanquishers_hammer,if=(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10|debuff.final_reckoning.up)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10|debuff.execution_sentence.up)|spell_targets.divine_storm>=2
    -- if ui.alwaysCdNever("Covenant Ability") and cast.able.vanquishersHammer()
    --     and (not talent.finalReckoning or cd.finalReckoning.remains() > unit.gcd(true) * 10 or debuff.finalReckoning.exists(units.dyn5))
    --     and (not talent.executionSentence or cd.executionSentence.remains() > unit.gcd(true) * 10 or debuff.executionSentence.exists(units.dyn5)
    --         or not ui.alwaysCdNever("Execution Sentence")) or var.dsUnits
    -- then
    --     if cast.vanquishersHammer() then ui.debug("Casting Vanquisher's Hammer [Necrolord]") return true end
    -- end
    -- Execution Sentence
    -- execution_sentence,if=(buff.crusade.down&cooldown.crusade.remains>10 |buff.crusade.stack>=3|cooldown.avenging_wrath.remains>10)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>10)&target.time_to_die>8
    if ui.alwaysCdNever("Execution Sentence") and cast.able.executionSentence()
        and ((talent.crusade and not buff.crusade.exists() and (cd.crusade.remain() > 10 or not ui.alwaysCdNever("Crusade")) or buff.crusade.stack() >= 3)
            or (not talent.crusade and (cd.avengingWrath.remain() > 10 or not ui.alwaysCdNever("Avenging Wrath"))))
        and (not talent.finalReckoning or cd.finalReckoning.remains() > 10 or not ui.alwaysCdNever("Final Reckoning")) and unit.ttd(units.dyn5) > 8
    then
        if cast.executionSentence() then ui.debug("Casting Execution Sentence") return true end
    end
    -- Divine Storm
    -- divine_storm,if=variable.ds_castable&!buff.vanquishers_hammer.up&((!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*6|cooldown.execution_sentence.remains>gcd*5&holy_power>=4|target.time_to_die<8|!talent.seraphim.enabled&cooldown.execution_sentence.remains>gcd*2)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*6|cooldown.final_reckoning.remains>gcd*5&holy_power>=4|!talent.seraphim.enabled&cooldown.final_reckoning.remains>gcd*2)&(!talent.seraphim.enabled|cooldown.seraphim.remains%gcd+holy_power>3|talent.final_reckoning.enabled|talent.execution_sentence.enabled|covenant.kyrian)|(talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.holy_avenger.up|buff.crusade.up&buff.crusade.stack<10))
    if cast.able.divineStorm("player", "aoe", var.theseUnits, 8) and var.dsCastable and (var.useFinisher or buff.empyreanPower.exists()) then
        if cast.divineStorm("player", "aoe", var.theseUnits, 8) then ui.debug("Casting Divine Storm") return true end
    end
    -- Templar's Verdict
    -- templars_verdict,if=(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*6|cooldown.execution_sentence.remains>gcd*5&holy_power>=4|target.time_to_die<8|!talent.seraphim.enabled&cooldown.execution_sentence.remains>gcd*2)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*6|cooldown.final_reckoning.remains>gcd*5&holy_power>=4|!talent.seraphim.enabled&cooldown.final_reckoning.remains>gcd*2)&(!talent.seraphim.enabled|cooldown.seraphim.remains%gcd+holy_power>3|talent.final_reckoning.enabled|talent.execution_sentence.enabled|covenant.kyrian)|talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.holy_avenger.up|buff.crusade.up&buff.crusade.stack<10
    if cast.able.templarsVerdict() and var.useFinisher then
        if cast.templarsVerdict() then ui.debug("Casting Templar's Verdict") return true end
    end
end -- End Action List - Finisher
-- Action List - Generator
actionList.Generator = function()
    -- Call Action List - Finishers
    -- call_action_list,name=finishers,if=holy_power=5|buff.holy_avenger.up|debuff.final_reckoning.up|debuff.execution_sentence.up
    if holyPower >= 5 or buff.holyAvenger.exists() or debuff.finalReckoning.exists(units.dyn5) or debuff.executionSentence.exists(units.dyn5) then
        if actionList.Finisher() then return true end
    end
    -- Divine Toll
    -- divine_toll,if=!debuff.judgment.up&(!talent.seraphim.enabled|buff.seraphim.up)&(!raid_event.adds.exists|raid_event.adds.in>30|raid_event.adds.up)&(holy_power<=2|holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10|target.time_to_die<8)&(cooldown.avenging_wrath.remains|cooldown.crusade.remains)
--    if ui.alwaysCdNever("Covenant Ability") and cast.able.divineToll() then
 --       if not debuff.judgment.exists(units.dyn5) and (not talent.seraphim or buff.seraphim.exists() or not ui.alwaysCdNever("Seraphim"))
--            and (holyPower <= 2 or (holyPower <= 4 and (cd.bladeOfJustice.remains() > unit.gcd(true) * 2 or debuff.executionSentence.exists(units.dyn5) or debuff.finalReckoning.exists(units.dyn5))))
--            and (not talent.finalReckoning or cd.finalReckoning.remains() > unit.gcd(true) * 10 or not ui.alwaysCdNever("Final Reckoning"))
--            and (not talent.executionSentence or cd.executionSentence.remains() > unit.gcd(true) * 10 or unit.ttd(units.dyn5) < 8 or not ui.alwaysCdNever("Execution Sentence"))
--            and ((not talent.crusade and cd.avengingWrath.remains() > unit.gcd(true) or not ui.alwaysCdNever("Avenging Wrath"))
--                or (talent.crusade and cd.crusade.remains() > unit.gcd(true) or not ui.alwaysCdNever("Crusade")))--       then
--            if cast.divineToll() then ui.debug("Casting Divine Toll [Kyrian]") return true end
--        end
--    end
    -- Hammer or Wrath
    -- hammer_of_wrath,if=runeforge.the_mad_paragon|runeforge.vanguards_momentum&talent.execution_sentence.enabled|covenant.venthyr&cooldown.ashen_hallow.remains>210
    if cast.able.hammerOfWrath() and (runeforge.theMadParagon.equiped or (runeforge.vanguardsMomentum.equiped and talent.executionSentence)
        or (covenant.venthyr.active and (cd.ashenHallow.remain() > 210 or not ui.alwaysCdNever("Covenant Ability"))))
    then
        if cast.hammerOfWrath() then ui.debug("Casting HammerOfWrath [Paragon / Momentum / Ashen Hallow") return true end
    end
    -- Judgment
    -- judgment,if=!debuff.judgment.up&buff.holy_avenger.up
    if cast.able.judgment() and not debuff.judgment.exists(unit.dyn5) and buff.holyAvenger.exists() then
        if cast.judgment() then ui.debug("Casting Judgment [Holy Avenger]") return true end
    end
    -- Wake of Ashes
    -- wake_of_ashes,if=(holy_power<=2&talent.execution_sentence.enabled&debuff.execution_sentence.remains>0&debuff.execution_sentence.remains<gcd*2)
    if ui.alwaysCdNever("Wake of Ashes") and cast.able.wakeOfAshes(units.dyn12, "cone", 1, 12)
        and #enemies.yards12c > 0 and (holyPower <= 2 and talent.executionSentence
            and ((debuff.executionSentence.exists(units.dyn5) and debuff.executionSentence.remains(units.dyn5) < unit.gcd(true) * 2) or not ui.alwaysCdNever("Execution Sentence")))
    then
        if cast.wakeOfAshes(units.dyn12, "cone", 1, 12) then ui.debug("Casting Wake of Ashes [Execution Sentence]") return true end
    end
    -- Blade of Justice
    -- blade_of_justice,if=holy_power<=3&talent.blade_of_wrath.enabled&(talent.final_reckoning.enabled&debuff.final_reckoning.remains>gcd*2|talent.execution_sentence.enabled&!talent.final_reckoning.enabled&(debuff.execution_sentence.up|cooldown.execution_sentence.remains=0))
    if cast.able.bladeOfJustice() and holyPower <= 3
        and ((talent.finalReckoning and (debuff.finalReckoning.remains() > unit.gcd(true) * 2 or not ui.alwaysCdNever("Final Reckoning")))
            or (talent.executionSentence and not talent.finalReckoning
                and (debuff.executionSentence.exists(units.dyn5) or not cd.executionSentence.exists() or not ui.alwaysCdNever("Execution Sentence"))))
    then
        if cast.bladeOfJustice() then ui.debug("Casting Blade of Justice [Execution Sentence]") return true end
    end
    -- Judgment
    -- judgment,if=!debuff.judgment.up&talent.seraphim.enabled&(holy_power>=1&runeforge.the_magistrates_judgment|holy_power>=2)
    if cast.able.judgment() and not debuff.judgment.exists(units.dyn5) and talent.seraphim and ((holyPower >= 1 and runeforge.theMagistratesJudgment.equiped) or holyPower >= 2) then
        if cast.judgment() then ui.debug("Casting Judgment [The Magistrates Judgment]") return true end
    end
    -- Wake of Ashes
    -- wake_of_ashes,if=(holy_power=0|holy_power<=2&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|target.time_to_die<8|debuff.final_reckoning.up))&(!raid_event.adds.exists|raid_event.adds.in>20|raid_event.adds.up)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>15|target.time_to_die<8)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>15|target.time_to_die<8)&(cooldown.avenging_wrath.remains|cooldown.crusade.remains)
    if ui.alwaysCdNever("Wake of Ashes") and cast.able.wakeOfAshes(units.dyn12, "cone", 1, 12) and #enemies.yards12c > 0
        and (holyPower == 0 or (holyPower <= 2
            and (cd.bladeOfJustice.remains() > unit.gcd(true) * 2 or debuff.executionSentence.exists(units.dyn5) --[[or unit.ttdGroup(12) < 8]] or debuff.finalReckoning.exists(units.dyn5))
            and (not talent.executionSentence or cd.executionSentence.remains() > 15 --[[or unit.ttdGroup(12) < 8]] or not ui.alwaysCdNever("Execution Sentence"))
            and (not talent.finalReckoning or cd.finalReckoning.remains() > 15 --[[or unit.ttdGroup(12) < 8]] or not ui.alwaysCdNever("Final Reckoning"))
            and ((not talent.crusade and (cd.avengingWrath.exists() or not ui.alwaysCdNever("Avenging Wrath"))) or (talent.crusade and (cd.crusade.exists() or not ui.alwaysCdNever("Crusade"))))))
    then
        if cast.wakeOfAshes(units.dyn12, "cone", 1, 12) then ui.debug("Casting Wake of Ashes") return true end
    end
    -- Call Action List - Finishers
    -- call_action_list,name=finishers,if=holy_power>=3&buff.crusade.up&buff.crusade.stack<10
    if holyPower >= 3 and talent.crusade and buff.crusade.exists() and buff.crusade.stack() < 10 then
        if actionList.Finisher() then return true end
    end
    -- Blade of Justice
    -- blade_of_justice,if=holy_power<=3&conduit.expurgation.enabled&!covenant.venthyr
    if cast.able.bladeOfJustice() and holyPower <= 3 and conduit.expurgation.enabled and not covenant.venthyr.active then
        if cast.bladeOfJustice() then ui.debug("Casting Blade of Justice [Expurgation]") return true end
    end
    -- Judgment
    -- judgment,if=!debuff.judgment.up
    if cast.able.judgment() and not debuff.judgment.exists(unit.dyn5) then
        if cast.judgment() then ui.debug("Casting Judgment") return true end
    end
    -- Hammer of Wrath
    -- hammer_of_wrath
    if cast.able.hammerOfWrath() then
        if buff.avengingWrath.exists() or buff.crusade.exists() then
            if cast.hammerOfWrath() then ui.debug("Casting Hammer of Wrath [Avenging Wrath / Crusade]") return true end
        end
        for i = 1, #enemies.yards30f do
            local thisUnit = enemies.yards30f[i]
            if unit.hp(thisUnit) < 20 then
                if cast.hammerOfWrath(thisUnit) then ui.debug("Casting Hammer of Wrath [Less Than 20 HP]") return true end
            end
        end
    end
    -- Blade of Justice
    -- blade_of_justice,if=holy_power<=3
    if cast.able.bladeOfJustice() and holyPower <= 3 then
        if cast.bladeOfJustice() then ui.debug("Casting Blade of Justice") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers,if=(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up|buff.empyrean_power.up)
    if (unit.hp(units.dyn5) <= 20 or buff.avengingWrath.exists() or buff.crusade.exists() or buff.empyreanPower.exists() or buff.divinePurpose.exists()) then
        if actionList.Finisher() then return end
    end
    -- Crusader Strike
    -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
    if cast.able.crusaderStrike() and charges.crusaderStrike.frac() >= 1.75
        and (holyPower <= 2 or (holyPower <= 3 and cd.bladeOfJustice.remain() > unit.gcd(true) * 2) or (holyPower == 4
        and cd.bladeOfJustice.remain() > unit.gcd(true) * 2 and cd.judgment.remain() > unit.gcd(true) * 2))
    then
        if cast.crusaderStrike() then ui.debug("Casting Crusader Strike [Cap Prevention]") return true end
    end
    -- Consecration
    -- consecration,if=!consecration.up&spell_targets.divine_storm>=2
    if #enemies.yards8 > 0 and cast.able.consecration("player", "aoe", 1, 8) and not br._G.GetTotemInfo(1) and var.dsUnits and unit.standingTime() >= 2 then
        if cast.consecration("player", "aoe", 1, 8) then ui.debug("Casting Consecration [AOE]") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers
    if actionList.Finisher() then return end
    -- Consecration
    -- consecration,if=!consecration.up
    if #enemies.yards8 > 0 and cast.able.consecration("player", "aoe", 1, 8) and not br._G.GetTotemInfo(1) and unit.standingTime() >= 2 then
        if cast.consecration("player", "aoe", 1, 8) then ui.debug("Casting Consecration") return true end
    end
    -- Crusader Strike
    -- crusader_strike
    if cast.able.crusaderStrike() then
        if cast.crusaderStrike() then ui.debug("Casting Crusader Strike") return true end
    end
    -- Arcane Torrent
    -- arcane_torrent
    if ui.checked("Racial") and cast.able.racial() and race == "BloodElf" then
        if cast.racial() then ui.debug("Casting Racial: Blood Elf") return true end
    end
    -- Consecration
    -- consecration
    if #enemies.yards8 > 0 and cast.able.consecration("player", "aoe", 1, 8) and unit.standingTime() >= 2 then
        if cast.consecration("player", "aoe", 1, 8) then ui.debug("Casting Consecration [Nothing Else Available]") return true end
    end
end -- End Action List - Generator
-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Flask
        -- flask,type=flask_of_the_countless_armies
        module.FlaskUp("Strength")
        -- Food
        -- food,type=azshari_salad
        -- Augmenation
        -- augmentation,type=defiled
        -- Potion
        -- potion,name=old_war
        -- if ui.checked("Potion") and br.canUseItem(127844) and unit.instance("raid") then
        --     br.useItem(127844)
        -- end
        if unit.valid("target") then --and opener.complete then
            -- Judgment
            if cast.able.judgment("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then
                    ui.debug("Casting Judgment [Pre-Pull]")
                    return true
                end
            end
            -- Blade of Justice
            if cast.able.bladeOfJustice("target") and unit.distance("target") < 12 then
                if cast.bladeOfJustice("target") then
                    ui.debug("Casting Blade of Justice [Pre-Pull]")
                    return true
                end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike("target") and unit.distance("target") < 5 then
                if cast.crusaderStrike("target") then
                    ui.debug("Casting Crusader Strike [Pre-Pull]")
                    return true
                end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Pull]") return true end
                end
            end
        end
    end
    -- Opener
    -- if actionList.Opener() then return true end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local runRotation = function()
    -----------------
    --- Variables ---
    -----------------
    -- BR API
    buff = br.player.buff
    cast = br.player.cast
    cd = br.player.cd
    charges = br.player.charges
    conduit = br.player.conduit
    covenant = br.player.covenant
    debuff = br.player.debuff
    enemies = br.player.enemies
    holyPower = br.player.power.holyPower.amount()
    module = br.player.module
    race = br.player.race
    runeforge = br.player.runeforge
    talent = br.player.talent
    ui = br.player.ui
    unit = br.player.unit
    units = br.player.units
    var = br.player.variables
    -- General API

    -- Dynamic Units
    units.get(5)
    units.get(8)
    -- Enemies Lists
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(12)
    enemies.cone.get(45, 12, false, false)
    enemies.get(20)
    enemies.get(30, "player", false, true)
    enemies.get(40)

    -- Profile Variables
    -- variable,name=ds_castable,value=spell_targets.divine_storm=2&!(runeforge.final_verdict&talent.righteous_verdict.enabled&conduit.templars_vindication.enabled)|spell_targets.divine_storm>2|buff.empyrean_power.up&debuff.judgment.down&buff.divine_purpose.down
    var.dsUnits = ((ui.mode.rotation == 1 and ((#enemies.yards8 == 2 and not (runeforge.finalVerdict.equiped and talent.righteousVerdict and conduit.templarsVindication.enabled)) or #enemies.yards8 > 2)) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
    var.dsCastable = (var.dsUnits or (buff.empyreanPower.exists() and not debuff.judgment.exists(units.dyn8) and not buff.divinePurpose.exists()))
    var.lowestUnit = br.friend[1].unit
    var.resable = unit.player("target") and unit.deadOrGhost("target") and unit.friend("target", "player")
    var.timeToHPG = 99
    if unit.level() >= 46 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(), cd.hammerOfWrath.remain(), cd.wakeOfAshes.remain())
    end
    if unit.level() < 46 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(), cd.wakeOfAshes.remain())
    end
    if unit.level() < 39 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain())
    end
    if unit.level() < 19 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.judgment.remain())
    end
    if unit.level() < 16 then var.timeToHPG = cd.crusaderStrike.remain() end
    if holyPower == 5 then var.timeToHPG = 0 end
    var.turnedEvil = var.turnedEvil or "player"
    if var.profileStop == nil then
        var.profileStop = false
    end
    var.highestEnemy = "player"
    var.highestHealth = 1
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local _, enemyCount = enemies.get(8,var.highestEnemy)
        if unit.health(thisUnit) > var.highestHealth and unit.ttd(thisUnit) > 3 and (enemyCount > 2 or unit.isBoss(thisUnit)) then
            var.highestHealth = unit.health(thisUnit)
            var.highestEnemy = thisUnit
            if unit.isBoss(thisUnit) then break end
        end
    end
    var.theseUnits = (ui.mode.rotation == 2 or buff.empyreanPower.exists()) and 1 or ui.value("Divine Storm Units")
    -- (!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)
    var.useFinisher = ((not talent.crusade or cd.crusade.remains() > unit.gcd(true) * 3 or not ui.alwaysCdNever("Crusade"))
        -- &(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*6|cooldown.execution_sentence.remains>gcd*5&holy_power>=4
        and (not talent.executionSentence or cd.executionSentence.remains() > unit.gcd(true) * 6 or (cd.executionSentence.remains() > unit.gcd(true) * 5 and holyPower >= 4)
            -- |target.time_to_die<8|!talent.seraphim.enabled&cooldown.execution_sentence.remains>gcd*2)
            --or ((#enemies.yards8 == 1 and unit.ttdGroup(5) < 8) or (#enemies.yards8 > 1 and unit.ttdGroup(8) < 8))
            or (not talent.seraphim and cd.executionSentence.remains() > unit.gcd(true) * 2) or not ui.alwaysCdNever("Execution Sentence"))
        -- &(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*6|cooldown.final_reckoning.remains>gcd*5&holy_power>=4
        and (not talent.finalReckoning or cd.finalReckoning.remains() > unit.gcd(true) * 6 or (cd.finalReckoning.remains() > unit.gcd(true) * 5 and holyPower >= 4)
            -- |!talent.seraphim.enabled&cooldown.final_reckoning.remains>gcd*2)
            or (not talent.seraphim and cd.finalReckoning.remains() > unit.gcd(true) * 2) or not ui.alwaysCdNever("Final Reckoning"))
        -- &(!talent.seraphim.enabled|cooldown.seraphim.remains%gcd+holy_power>3|talent.final_reckoning.enabled
        and (not talent.seraphim or cd.seraphim.remains() / unit.gcd(true) + holyPower > 3 or talent.finalReckoning
            -- |talent.execution_sentence.enabled|covenant.kyrian)
            or talent.executionSentence or covenant.kyrian.active or not ui.alwaysCdNever("Seraphim")))
        -- |talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.holy_avenger.up|buff.crusade.up&buff.crusade.stack<10
        or (talent.holyAvenger and cd.holyAvenger.remains() < unit.gcd(true) * 3) or buff.holyAvenger.exists() or (talent.crusade and buff.crusade.exists() and buff.crusade.stack() < 10)

    -- MultiUnits
    var.freedomUnit = getHealUnitOption("Blessing of Freedom") or "player"
    var.protectionUnit = "player"
    var.sacificeUnit = "player"
    var.cleanseUnit = "player"
    var.flashUnit = "player"
    var.layUnit = "player"
    var.gloryUnit = "player"

    -- Auras
    if not unit.casting() then
        -- Crusader Aura
        if unit.mounted() and cast.able.crusaderAura() and not buff.crusaderAura.exists() then
            if cast.crusaderAura("player") then
                ui.debug("Casting Crusader Aura")
                return true
            end
        end
        -- Concentration Aura
        if ui.mode.aura == 1 and not unit.mounted() and cast.able.concentrationAura() and not buff.concentrationAura.exists() then
            if cast.concentrationAura("player") then
                ui.debug("Casting Concentration Aura")
                return true
            end
        end
        -- Devotion Aura
        if ui.mode.aura == 2 and not unit.mounted() and cast.able.devotionAura() and not buff.devotionAura.exists() then
            if cast.devotionAura("player") then
                ui.debug("Casting Devotion Aura")
                return true
            end
        end
        -- Retribution Aura
        if ui.mode.aura == 3 and not unit.mounted() and cast.able.retributionAura() and not buff.retributionAura.exists() then
            if cast.retributionAura("player") then
                ui.debug("Casting Retribution Aura")
                return true
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
        if actionList.Extras() then
            return
        end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then
            return
        end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then
            return
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and unit.valid("target") then --and opener.complete then
            ----------------------------------
            --- In Combat - Begin Rotation ---
            ----------------------------------
            local startTime = debugprofilestop()
            -- Start Attack
            -- auto_attack
            if #enemies.yards5 > 0 and unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
                end
            end
            -- Action List - Interrupts
            -- rebuke
            if actionList.Interrupts() then
                return
            end
            -- Light's Judgment - Lightforged Draenei Racial
            if ui.checked("Racial") and race == "LightforgedDraenei" and not unit.isUnit("player",var.highestEnemy) then
                if cast.racial(var.highestEnemy) then
                    ui.debug("Casting Racial: Lightforged Draenei [AOE]")
                    return true
                end
            end
            -- Action List - Cooldowns
            -- call_action_list,name=cooldowns
            if actionList.Cooldowns() then
                return
            end
            -- Call Action List - Generator
            -- call_action_list,name=generators
            if actionList.Generator() then
                return
            end
            br.debug.cpu.rotation.inCombat = debugprofilestop() - startTime
        end -- End In Combat
    end -- End Profile
end -- runRotation
local id = 70
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
br._G.tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)
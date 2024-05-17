-------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 90%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Sporadic
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Development
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
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.consecration },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.consecration },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.crusaderStrike },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.flashOfLight }
    }
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.avengingWrath },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.avengingWrath },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.avengingWrath }
    }
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.flashOfLight },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.flashOfLight }
    }
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.hammerOfJustice },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.hammerOfJustice }
    }
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Aura
    local AuraModes = {
        [1] = { mode = "Con", value = 1, overlay = "Concentration Aura", tip = "Use Concentration Aura", highlight = 0, icon = br.player.spells.concentrationAura },
        [2] = { mode = "Dev", value = 2, overlay = "Devotion Aura", tip = "Use Devotion Aura", highlight = 0, icon = br.player.spells.devotionAura },
        [3] = { mode = "Ret", value = 2, overlay = "Retribution Aura", tip = "Use Retribution Aura", highlight = 0, icon = br.player.spells.retributionAura }
    }
    br.ui:createToggle(AuraModes, "Aura", 5, 0)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        local playTarMouseFocLow = { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus",
            "|cffFFFFFFLowest" }
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Blessing of Freedom
        br.ui:createDropdown(section, "Blessing of Freedom", playTarMouseFocLow, 1, "|cffFFFFFFTarget to Cast On")
        -- Divine Storm Units
        br.ui:createSpinnerWithout(section, "Divine Storm Units", 2, 1, 5, 1, "|cffFFBB00Units to use Divine Storm.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Potion
        br.player.module.CombatPotionUp(section)
        -- Phial
        br.player.module.PhialUp(section)
        -- Imbue
        br.player.module.ImbueUp(section)
        -- Trinkets
        br.player.module.BasicTrinkets(nil, section)
        -- Racial
        br.ui:createDropdownWithout(section, "Racial", alwaysCdAoENever, 3, "|cffFFFFFFSet mode to use.")
        -- Avenging Wrath
        br.ui:createDropdownWithout(section, "Avenging Wrath", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Crusade
        br.ui:createDropdownWithout(section, "Crusade", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Execution Sentence
        br.ui:createDropdownWithout(section, "Execution Sentence", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        -- Final Reckoning
        br.ui:createDropdownWithout(section, "Final Reckoning", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
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
        br.ui:createDropdownWithout(section, "Blessing of Protection Target", playTarMouseFocLow, 5,
            "|cffFFFFFFTarget for Blessing of Protection")
        -- Blessing of Sacrifice
        br.ui:createDropdown(section, "Blessing of Sacrifice", playTarMouseFocLow, 5,
            "|cffFFFFFFTarget for Blessing of Sacrifice")
        br.ui:createSpinnerWithout(section, "Friendly HP", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Personal HP Limit", 80, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Blinding Light
        br.ui:createSpinner(section, "Blinding Light", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Blinding Light Units", 3, 1, 5, 1, "|cffFFFFFFUnits to Cast On")
        -- Cleanse Toxin
        br.ui:createDropdown(section, "Cleanse Toxins", playTarMouseFocLow, 1, "|cffFFFFFFTarget to Cast On")
        -- Divine Shield
        br.ui:createSpinner(section, "Divine Shield", 35, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Flash of Light
        br.ui:createSpinner(section, "Flash of Light", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:createDropdownWithout(section, "Flash of Light Target", playTarMouseFocLow, 5,
            "|cffFFFFFFTarget for Flash of Light")
        -- Hammer of Justice
        br.ui:createSpinner(section, "Hammer of Justice - HP", 40, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Justicar's Vengeance
        br.ui:createSpinner(section, "Justicar's Vengeance", 45, 0, 100, 5,
            "|cffFFBB00Health Percentage to use at over Templar's Verdict.")
        -- Lay On Hands
        br.ui:createSpinner(section, "Lay On Hands", 20, 0, 100, 5, "", "Health Percentage to use at")
        br.ui:createDropdownWithout(section, "Lay on Hands Target", playTarMouseFocLow, 5,
            "|cffFFFFFFTarget for Lay On Hands")
        -- Redemption
        br.ui:createDropdown(section, "Redemption", { "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus" }, 1,
            "|cffFFFFFFTarget to Cast On")
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
local debuff
local enemies
local equiped
local holyPower
local module
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
    if holyPower() >= 3 then
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
                    ui.debug("Casting Blessing of Protection on " ..
                        unit.name(var.protectionUnit) .. " [" .. unit.hp(var.protectionUnit) .. "% Remaining]")
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
                    ui.debug("Casting Blessing of Sacrifice on " ..
                        unit.name(var.sacificeUnit) .. " [" .. unit.hp(var.sacificeUnit) .. "% Remaining]")
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
        -- Flash of Light
        if ui.checked("Flash of Light") and not (unit.mounted() or unit.flying()) and not cast.current.flashOfLight() then
            var.flashUnit = getHealUnitOption("Flash of Light Target")
            if var.flashUnit ~= nil and cast.able.flashOfLight(var.flashUnit) and unit.distance(var.flashUnit) < 40 then
                -- Instant Cast
                if talent.selflessHealer and buff.selflessHealer.stack() == 4 then
                    -- Don't waste instant heal!
                    var.flashUnit = unit.hp(var.flashUnit) <= ui.value("Flash of Light") and var.flashUnit or
                        var.lowestUnit
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
        if ui.checked("Justicar's Vengeance") and cast.able.justicarsVengeance() and unit.inCombat() and holyPower() >= 5 then
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
                    ui.debug("Casting Lay On Hands on " ..
                        tostring(unit.name(var.layUnit)) .. " [" .. tostring(unit.hp(var.layUnit)) .. "% Remaining]")
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
    -- Module - Combatpotion Up
    -- potion,if=buff.avenging_wrath.up|buff.crusade.up|fight_remains<30
    if (buff.avengingWrath.exists() or buff.crusade.exists() or unit.ttdGroup(40) < 30) then
        module.CombatpotionUp()
    end

    -- Lights Judgment
    -- lights_judgment,if=spell_targets.lights_judgment>=2|!raid_event.adds.exists|raid_event.adds.in>75|raid_event.adds.up
    if ui.alwaysCdAoENever("Racial") and unit.race() == "LightforgedDraenei"
        and cast.able.lightsJudgment(units.dyn5, "aoe", 1, 5) and (#enemies.yards5 >= 2 or ui.useCDs())
    then
        if cast.lightsJudgment(units.dyn5, "aoe", 1, 5) then
            ui.debug("Casting Light's Judgment [Cooldowns]")
            return true
        end
    end

    -- Fireblood
    -- fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
    if ui.alwaysCdAoENever("Racial") and unit.race() == "DarkIronDwarf" and cast.able.fireblood()
        and ((buff.avengingWrath.exists() or buff.crusade.exists() and buff.crusade.stack() == 10))
    then
        if cast.fireblood() then
            ui.debug("Casting Fireblood [Cooldowns]")
            return true
        end
    end

    -- Trinkets
    if #enemies.yards5 > 0 and unit.standingTime() >= 2 then
        module.BasicTrinkets()
    end

    -- -- Use Item - Algethar Puzzle Box
    -- -- use_item,name=algethar_puzzle_box,if=(cooldown.avenging_wrath.remains<5&!talent.crusade|cooldown.crusade.remains<5&talent.crusade)&(holy_power>=4&time<5|holy_power>=3&time>5)
    -- if use.able.algetharPuzzleBox() and (((cd.avengingWrath.remains() < 5 and not talent.crusade or cd.crusade.remains() < 5 and talent.crusade) and (holyPower() >= 4 and unit.combatTime() < 5 or holyPower() >= 3 and unit.combatTime() > 5))) then
    --     if use.algetharPuzzleBox() then
    --         ui.debug("Using Algethar Puzzle Box [Cooldowns]")
    --         return true
    --     end
    -- end

    -- -- Use Item - Slot1
    -- -- use_item,slot=trinket1,if=(buff.avenging_wrath.up&cooldown.avenging_wrath.remains>40|buff.crusade.up&buff.crusade.stack=10)&(!trinket.2.has_cooldown|trinket.2.cooldown.remains|variable.trinket_priority=1)|trinket.1.proc.any_dps.duration>=fight_remains
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.2.has_cooldown
    -- -- trinket.1.proc.any_dps.duration
    -- if use.able.slot1() and (((buff.avengingWrath.exists() and cd.avengingWrath.remains()>40 or buff.crusade.exists() and buff.crusade.stack()==10) and (not  or cd.slot.remains(14) or var.trinketPriority==1) or >=unit.ttdGroup(40))) then
    --     if use.slot1() then ui.debug("Using Slot1 [Cooldowns]") return true end
    -- end

    -- -- Use Item - Slot2
    -- -- use_item,slot=trinket2,if=(buff.avenging_wrath.up&cooldown.avenging_wrath.remains>40|buff.crusade.up&buff.crusade.stack=10)&(!trinket.1.has_cooldown|trinket.1.cooldown.remains|variable.trinket_priority=2)|trinket.2.proc.any_dps.duration>=fight_remains
    -- -- TODO: The following conditions were not converted:
    -- -- trinket.1.has_cooldown
    -- -- trinket.2.proc.any_dps.duration
    -- if use.able.slot2() and (((buff.avengingWrath.exists() and cd.avengingWrath.remains()>40 or buff.crusade.exists() and buff.crusade.stack()==10) and (not  or cd.slot.remains(13) or var.trinketPriority==2) or >=unit.ttdGroup(40))) then
    --     if use.slot2() then ui.debug("Using Slot2 [Cooldowns]") return true end
    -- end

    -- -- Use Item - Slot1
    -- -- use_item,slot=trinket1,if=!variable.trinket_1_buffs&(trinket.2.cooldown.remains|!variable.trinket_2_buffs|!buff.crusade.up&cooldown.crusade.remains>20|!buff.avenging_wrath.up&cooldown.avenging_wrath.remains>20)
    -- if use.able.slot1() and ((not var.trinket1Buffs and (cd.slot.remains(14) or not var.trinket2Buffs or not buff.crusade.exists() and cd.crusade.remains()>20 or not buff.avengingWrath.exists() and cd.avengingWrath.remains()>20))) then
    --     if use.slot1() then ui.debug("Using Slot1 [Cooldowns]") return true end
    -- end

    -- -- Use Item - Slot2
    -- -- use_item,slot=trinket2,if=!variable.trinket_2_buffs&(trinket.1.cooldown.remains|!variable.trinket_1_buffs|!buff.crusade.up&cooldown.crusade.remains>20|!buff.avenging_wrath.up&cooldown.avenging_wrath.remains>20)
    -- if use.able.slot2() and ((not var.trinket2Buffs and (cd.slot.remains(13) or not var.trinket1Buffs or not buff.crusade.exists() and cd.crusade.remains()>20 or not buff.avengingWrath.exists() and cd.avengingWrath.remains()>20))) then
    --     if use.slot2() then ui.debug("Using Slot2 [Cooldowns]") return true end
    -- end

    -- -- Use Item - Shadowed Razing Annihilator
    -- -- use_item,name=shadowed_razing_annihilator,if=(trinket.2.cooldown.remains|!variable.trinket_2_buffs)&(trinket.2.cooldown.remains|!variable.trinket_2_buffs)
    -- if use.able.shadowedRazingAnnihilator() and (((cd.slot.remains(14) or not var.trinket2Buffs) and (cd.slot.remains(14) or not var.trinket2Buffs))) then
    --     if use.shadowedRazingAnnihilator() then ui.debug("Using Shadowed Razing Annihilator [Cooldowns]") return true end
    -- end

    -- -- Use Item - Fyralath The Dreamrender
    -- -- use_item,name=fyralath_the_dreamrender,if=dot.mark_of_fyralath.ticking&!buff.avenging_wrath.up&!buff.crusade.up
    -- if use.able.fyralathTheDreamrender() and debuff.markOfFyralath.exists(PLACEHOLDER) and not buff.avengingWrath.exists() and not buff.crusade.exists() then
    --     if use.fyralathTheDreamrender() then ui.debug("Using Fyralath The Dreamrender [Cooldowns]") return true end
    -- end

    -- Shield Of Vengeance
    -- shield_of_vengeance,if=fight_remains>15&(!talent.execution_sentence|!debuff.execution_sentence.up)
    if ui.checked("Shield of Vengeance - CD") and cast.able.shieldOfVengeance() and ((unit.ttdGroup(40) > 15
            and (not talent.executionSentence or not debuff.executionSentence.exists(units.dyn5))))
    then
        if cast.shieldOfVengeance() then
            ui.debug("Casting Shield Of Vengeance [Cooldowns]")
            return true
        end
    end

    -- Execution Sentence
    -- execution_sentence,if=(!buff.crusade.up&cooldown.crusade.remains>15|buff.crusade.stack=10|cooldown.avenging_wrath.remains<0.75|cooldown.avenging_wrath.remains>15)&(holy_power>=4&time<5|holy_power>=3&time>5|holy_power>=2&talent.divine_auxiliary)&(target.time_to_die>8&!talent.executioners_will|target.time_to_die>12)
    if ui.alwaysCdNever("Execution Sentence") and cast.able.executionSentence() and (((not buff.crusade.exists() and cd.crusade.remains() > 15
                or buff.crusade.stack() == 10 or cd.avengingWrath.remains() < 0.75 or cd.avengingWrath.remains() > 15)
            and (holyPower() >= 4 and unit.combatTime() < 5 or holyPower() >= 3 and unit.combatTime() > 5 or holyPower() >= 2 and talent.divineAuxiliary)
            and (unit.timeToDie(units.dyn30) > 8 and not talent.executionersWill or unit.timeToDie(units.dyn30) > 12)))
    then
        if cast.executionSentence() then
            ui.debug("Casting Execution Sentence [Cooldowns]")
            return true
        end
    end

    -- Avenging Wrath
    -- avenging_wrath,if=(holy_power>=4&time<5|holy_power>=3&(time>5|!talent.vanguard_of_justice)|holy_power>=2&talent.divine_auxiliary&(cooldown.execution_sentence.remains=0|cooldown.final_reckoning.remains=0))&(!raid_event.adds.up|target.time_to_die>10)
    if ui.alwaysCdNever("Avenging Wrath") and cast.able.avengingWrath() and (((holyPower() >= 4 and unit.combatTime() < 5 or holyPower() >= 3
            and (unit.combatTime() > 5 or not talent.vanguardOfJustice) or holyPower() >= 2 and talent.divineAuxiliary
            and (cd.executionSentence.remains() == 0 or cd.finalReckoning.remains() == 0)) and unit.timeToDie(units.dyn5) > 10))
    then
        if cast.avengingWrath() then
            ui.debug("Casting Avenging Wrath [Cooldowns]")
            return true
        end
    end

    -- Crusade
    -- crusade,if=holy_power>=5&time<5|holy_power>=3&time>5
    if ui.alwaysCdNever("Crusade") and cast.able.crusade() and ((holyPower() >= 5 and unit.combatTime() < 5 or holyPower() >= 3 and unit.combatTime() > 5)) then
        if cast.crusade() then
            ui.debug("Casting Crusade [Cooldowns]")
            return true
        end
    end

    -- Final Reckoning
    -- final_reckoning,if=(holy_power>=4&time<8|holy_power>=3&(time>=8|!talent.vanguard_of_justice)|holy_power>=2&talent.divine_auxiliary)&(cooldown.avenging_wrath.remains>10|cooldown.crusade.remains&(!buff.crusade.up|buff.crusade.stack>=10))&(!raid_event.adds.exists|raid_event.adds.up|raid_event.adds.in>40)
    if ui.alwaysCdNever("Final Reckoning") and cast.able.finalReckoning() and (((holyPower() >= 4 and unit.combatTime() < 8 or holyPower() >= 3
                and (unit.combatTime() >= 8 or not talent.vanguardOfJustice) or holyPower() >= 2 and talent.divineAuxiliary)
            and ((cd.avengingWrath.remains() > 10 or cd.crusade.remains() and (not buff.crusade.exists() or buff.crusade.stack() >= 10))
                or (talent.crusade and not ui.alwaysCdNever("Crusade")) or (not talent.crusade and not ui.alwaysCdNever("Avenging Wrath")))))
    then
        if cast.finalReckoning() then
            ui.debug("Casting Final Reckoning [Cooldowns]")
            return true
        end
    end
end -- End Action List - Cooldowns

-- Action List - Finisher
actionList.Finishers = function()
    -- Variable - Ds Castable
    -- variable,name=ds_castable,value=(spell_targets.divine_storm>=3|spell_targets.divine_storm>=2&!talent.divine_arbiter|buff.empyrean_power.up)&!buff.empyrean_legacy.up&!(buff.divine_arbiter.up&buff.divine_arbiter.stack>24)
    var.dsCastable = ((#enemies.yards8 >= 3 or #enemies.yards8 >= 2 and not talent.divineArbiter or buff.empyreanPower.exists())
        and not buff.empyreanLegacy.exists() and not (buff.divineArbiter.exists() and buff.divineArbiter.stack() > 24))

    -- Divine Storm
    -- divine_storm,if=variable.ds_castable&(!talent.crusade|cooldown.crusade.remains>gcd*3|buff.crusade.up&buff.crusade.stack<10)
    if cast.able.divineStorm("player", "aoe", var.theseUnits, 8) and ((var.dsCastable and (not talent.crusade or cd.crusade.remains() > unit.gcd(true) * 3 or buff.crusade.exists() and buff.crusade.stack() < 10))) then
        if cast.divineStorm("player", "aoe", var.theseUnits, 8) then
            ui.debug("Casting Divine Storm [Finishers]")
            return true
        end
    end

    -- Justicars Vengeance
    -- justicars_vengeance,if=!talent.crusade|cooldown.crusade.remains>gcd*3|buff.crusade.up&buff.crusade.stack<10
    if cast.able.justicarsVengeance() and ((not talent.crusade or cd.crusade.remains() > unit.gcd(true) * 3 or buff.crusade.exists() and buff.crusade.stack() < 10)) then
        if cast.justicarsVengeance() then
            ui.debug("Casting Justicars Vengeance [Finishers]")
            return true
        end
    end

    -- Templars Verdict
    -- templars_verdict,if=!talent.crusade|cooldown.crusade.remains>gcd*3|buff.crusade.up&buff.crusade.stack<10
    if cast.able.templarsVerdict() and ((not talent.crusade or cd.crusade.remains() > unit.gcd(true) * 3 or buff.crusade.exists() and buff.crusade.stack() < 10)) then
        if cast.templarsVerdict() then
            ui.debug("Casting Templars Verdict [Finishers]")
            return true
        end
    end
end -- End Action List - Finishers
-- Action List - Generator
actionList.Generators = function()
    -- Call Action List - Finishers
    -- call_action_list,name=finishers,if=holy_power=5|buff.echoes_of_wrath.up&set_bonus.tier31_4pc&talent.crusading_strikes|(debuff.judgment.up|holy_power=4)&buff.divine_resonance.up&!set_bonus.tier31_2pc
    if (holyPower() == 5 or buff.echoesOfWrath.exists() and equiped.tier(31) >= 4
            and talent.crusadingStrikes or (debuff.judgment.exists(units.dyn5) or holyPower() == 4)
            and buff.divineResonance.exists() and not equiped.tier(31) >= 2)
    then
        if actionList.Finishers() then return true end
    end

    -- Wake Of Ashes
    -- wake_of_ashes,if=holy_power<=2&(cooldown.avenging_wrath.remains>6|cooldown.crusade.remains>6)&(!talent.execution_sentence|cooldown.execution_sentence.remains>4|target.time_to_die<8)&(!raid_event.adds.exists|raid_event.adds.in>20|raid_event.adds.up)
    if ui.alwaysCdNever("Wake of Ashes") and cast.able.wakeOfAshes(units.dyn12, "cone", 1, 12)
        and ((holyPower() <= 2 and (cd.avengingWrath.remains() > 6 or cd.crusade.remains() > 6)
            and (not talent.executionSentence or (cd.executionSentence.remains() > 4 or not ui.alwaysCdNever("Execution Sentence")) or unit.timeToDie(units.dyn12) < 8)))
    then
        if cast.wakeOfAshes(units.dyn12, "cone", 1, 12) then
            ui.debug("Casting Wake Of Ashes [Generators]")
            return true
        end
    end

    -- Blade Of Justice
    -- blade_of_justice,if=!dot.expurgation.ticking&set_bonus.tier31_2pc
    if cast.able.bladeOfJustice() and not debuff.expurgation.exists(units.dyn12) and equiped.tier(31) >= 2 then
        if cast.bladeOfJustice() then
            ui.debug("Casting Blade Of Justice - Expurgation [Generators]")
            return true
        end
    end

    -- Divine Toll
    -- divine_toll,if=holy_power<=2&(!raid_event.adds.exists|raid_event.adds.in>30|raid_event.adds.up)&(cooldown.avenging_wrath.remains>15|cooldown.crusade.remains>15|fight_remains<8)
    if cast.able.divineToll() and ((holyPower() <= 2 and (cd.avengingWrath.remains() > 15 or cd.crusade.remains() > 15 or unit.ttdGroup(40) < 8))) then
        if cast.divineToll() then
            ui.debug("Casting Divine Toll - Low Holy [Generators]")
            return true
        end
    end

    -- Judgment
    -- judgment,if=dot.expurgation.ticking&!buff.echoes_of_wrath.up&set_bonus.tier31_2pc
    if cast.able.judgment() and debuff.expurgation.exists(units.dyn40) and not buff.echoesOfWrath.exists() and equiped.tier(31) >= 2 then
        if cast.judgment() then
            ui.debug("Casting Judgment - Expurgation [Generators]")
            return true
        end
    end

    -- Call Action List - Finishers
    -- call_action_list,name=finishers,if=holy_power>=3&buff.crusade.up&buff.crusade.stack<10
    if holyPower() >= 3 and buff.crusade.exists() and buff.crusade.stack() < 10 then
        if actionList.Finishers() then return true end
    end

    -- Templar Slash
    -- templar_slash,if=buff.templar_strikes.remains<gcd&spell_targets.divine_storm>=2
    if cast.able.templarSlash() and buff.templarStrikes.remains() < unit.gcd(true) and #enemies.yards8 >= 2 then
        if cast.templarSlash() then
            ui.debug("Casting Templar Slash - AOE [Generators]")
            return true
        end
    end

    -- Blade Of Justice
    -- blade_of_justice,if=(holy_power<=3|!talent.holy_blade)&(spell_targets.divine_storm>=2&!talent.crusading_strikes|spell_targets.divine_storm>=4)
    if cast.able.bladeOfJustice() and (((holyPower() <= 3 or not talent.holyBlade) and (#enemies.yards8 >= 2 and not talent.crusadingStrikes or #enemies.yards8 >= 4))) then
        if cast.bladeOfJustice() then
            ui.debug("Casting Blade Of Justice - AOE [Generators]")
            return true
        end
    end

    -- Hammer Of Wrath
    -- hammer_of_wrath,if=(spell_targets.divine_storm<2|!talent.blessed_champion|set_bonus.tier30_4pc)&(holy_power<=3|target.health.pct>20|!talent.vanguards_momentum)
    if cast.able.hammerOfWrath() and (unit.hp(unit.dyn30) < 20 or buff.avengingWrath.exists() or buff.finalVerdict.exists())
        and (((#enemies.yards8 < 2 or not talent.blessedChampion or equiped.tier(30) >= 4)
            and (holyPower() <= 3 or unit.hp(unit.dyn30) > 20 or not talent.vanguardsMomentum)))
    then
        if cast.hammerOfWrath() then
            ui.debug("Casting Hammer Of Wrath - ST | No Blessed Champion | T30-4 [Generators]")
            return true
        end
    end

    -- Templar Slash
    -- templar_slash,if=buff.templar_strikes.remains<gcd
    if cast.able.templarSlash() and buff.templarStrikes.remains() < unit.gcd(true) then
        if cast.templarSlash() then
            ui.debug("Casting Templar Slash - Buff Exipry [Generators]")
            return true
        end
    end

    -- Judgment
    -- judgment,if=!debuff.judgment.up&(holy_power<=3|!talent.boundless_judgment)
    if cast.able.judgment() and ((not debuff.judgment.exists(units.dyn40) and (holyPower() <= 3 or not talent.boundlessJudgment))) then
        if cast.judgment() then
            ui.debug("Casting Judgment - Low Holy | No Boundless Judgment [Generators]")
            return true
        end
    end

    -- Blade Of Justice
    -- blade_of_justice,if=holy_power<=3|!talent.holy_blade
    if cast.able.bladeOfJustice() and ((holyPower() <= 3 or not talent.holyBlade)) then
        if cast.bladeOfJustice() then
            ui.debug("Casting Blade Of Justice - Low Holy | No Holy Blade [Generators]")
            return true
        end
    end

    -- Call Action List - Finishers
    -- call_action_list,name=finishers,if=(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up|buff.empyrean_power.up)
    if ((unit.hp(units.dyn5) <= 20 or buff.avengingWrath.exists() or buff.crusade.exists() or buff.empyreanPower.exists())) then
        if actionList.Finishers() then return true end
    end

    -- Consecration
    -- consecration,if=!consecration.up&spell_targets.divine_storm>=2
    if cast.able.consecration("player", "aoe", 1, 8) --[[and not consecration.up ]] and #enemies.yards8 >= 2 then
        if cast.consecration("player", "aoe", 1, 8) then
            ui.debug("Casting Consecration - AOE [Generators]")
            return true
        end
    end

    -- Divine Hammer
    -- divine_hammer,if=spell_targets.divine_storm>=2
    if cast.able.divineHammer() and #enemies.yards8 >= 2 then
        if cast.divineHammer() then
            ui.debug("Casting Divine Hammer - AOE [Generators]")
            return true
        end
    end

    -- Crusader Strike
    -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
    if cast.able.crusaderStrike() and ((charges.crusaderStrike.frac() >= 1.75 and (holyPower() <= 2 or holyPower() <= 3
            and cd.bladeOfJustice.remains() > unit.gcd(true) * 2 or holyPower() == 4 and cd.bladeOfJustice.remains() > unit.gcd(true) * 2
            and cd.judgment.remains() > unit.gcd(true) * 2)))
    then
        if cast.crusaderStrike() then
            ui.debug("Casting Crusader Strike - Max Charges [Generators]")
            return true
        end
    end

    -- Call Action List - Finishers
    -- call_action_list,name=finishers
    if actionList.Finishers() then return true end

    -- Templar Slash
    -- templar_slash
    if cast.able.templarSlash() then
        if cast.templarSlash() then
            ui.debug("Casting Templar Slash [Generators]")
            return true
        end
    end

    -- Templar Strike
    -- templar_strike
    if cast.able.templarStrike() then
        if cast.templarStrike() then
            ui.debug("Casting Templar Strike [Generators]")
            return true
        end
    end

    -- Judgment
    -- judgment,if=holy_power<=3|!talent.boundless_judgment
    if cast.able.judgment() and ((holyPower() <= 3 or not talent.boundlessJudgment)) then
        if cast.judgment() then
            ui.debug("Casting Judgment [Generators]")
            return true
        end
    end

    -- Hammer Of Wrath
    -- hammer_of_wrath,if=holy_power<=3|target.health.pct>20|!talent.vanguards_momentum
    if cast.able.hammerOfWrath() and (unit.hp(unit.dyn30) < 20 or buff.avengingWrath.exists() or buff.finalVerdict.exists())
        and ((holyPower() <= 3 or unit.hp(units.dyn30) > 20 or not talent.vanguardsMomentum))
    then
        if cast.hammerOfWrath() then
            ui.debug("Casting Hammer Of Wrath [Generators]")
            return true
        end
    end

    -- Crusader Strike
    -- crusader_strike
    if cast.able.crusaderStrike() then
        if cast.crusaderStrike() then
            ui.debug("Casting Crusader Strike [Generators]")
            return true
        end
    end

    -- Arcane Torrent
    -- arcane_torrent
    if cast.able.arcaneTorrent() then
        if cast.arcaneTorrent() then
            ui.debug("Casting Arcane Torrent [Generators]")
            return true
        end
    end

    -- Consecration
    -- consecration
    if cast.able.consecration("player", "aoe", 1, 8) then
        if cast.consecration("player", "aoe", 1, 8) then
            ui.debug("Casting Consecration [Generators]")
            return true
        end
    end

    -- Divine Hammer
    -- divine_hammer
    if cast.able.divineHammer() then
        if cast.divineHammer() then
            ui.debug("Casting Divine Hammer [Generators]")
            return true
        end
    end
end -- End Action List - Generators

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Module - Phial Up
        -- flask
        module.PhialUp()
        -- Module - Imbue Up
        -- augmentation
        module.ImbueUp()
        if unit.valid("target") then
            -- Shield Of Vengeance
            -- shield_of_vengeance
            if cast.able.shieldOfVengeance("target") then
                if cast.shieldOfVengeance("target") then
                    ui.debug("Casting Shield Of Vengeance [Precombat]")
                    return true
                end
            end
            -- Judgment
            if cast.able.judgment("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then
                    ui.debug("Casting Judgment [Precombat]")
                    return true
                end
            end
            -- Blade of Justice
            if cast.able.bladeOfJustice("target") and unit.distance("target") < 12 then
                if cast.bladeOfJustice("target") then
                    ui.debug("Casting Blade of Justice [Precombat]")
                    return true
                end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike("target") and unit.distance("target") < 5 then
                if cast.crusaderStrike("target") then
                    ui.debug("Casting Crusader Strike [Precombat]")
                    return true
                end
            end
            -- Start Attack
            if unit.distance("target") < 5 then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Precombat]")
                        return true
                    end
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") then
        -- Auto Attack
        -- auto_attack
        if cast.able.autoAttack() then
            if cast.autoAttack() then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        ------------------
        --- Interrupts ---
        ------------------
        if actionList.Interrupts() then return true end
        -- Call Action List - Cooldowns
        -- call_action_list,name=cooldowns
        if actionList.Cooldowns() then return true end
        -- Call Action List - Generators
        -- call_action_list,name=generators
        if actionList.Generators() then return true end
    end
end -- End Action List - Combat

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
    debuff = br.player.debuff
    enemies = br.player.enemies
    equiped = br.player.equiped
    holyPower = br.player.power.holyPower
    module = br.player.module
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
    -- var.dsUnits = ((ui.mode.rotation == 1 and ((#enemies.yards8 == 2 and not (runeforge.finalVerdict.equiped and talent.righteousVerdict and conduit.templarsVindication.enabled)) or #enemies.yards8 > 2)) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
    -- var.dsCastable = (var.dsUnits or (buff.empyreanPower.exists() and not debuff.judgment.exists(units.dyn8) and not buff.divinePurpose.exists()))
    var.lowestUnit = br.friend[1].unit
    var.resable = unit.player("target") and unit.deadOrGhost("target") and unit.friend("target", "player")
    var.timeToHPG = 99
    if unit.level() >= 46 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(),
            cd.hammerOfWrath.remain(), cd.wakeOfAshes.remain())
    end
    if unit.level() < 46 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(),
            cd.wakeOfAshes.remain())
    end
    if unit.level() < 39 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain())
    end
    if unit.level() < 19 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.judgment.remain())
    end
    if unit.level() < 16 then var.timeToHPG = cd.crusaderStrike.remain() end
    if holyPower() == 5 then var.timeToHPG = 0 end
    var.turnedEvil = var.turnedEvil or "player"
    if var.profileStop == nil then
        var.profileStop = false
    end
    var.highestEnemy = "player"
    var.highestHealth = 1
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local _, enemyCount = enemies.get(8, var.highestEnemy)
        if unit.health(thisUnit) > var.highestHealth and unit.ttd(thisUnit) > 3 and (enemyCount > 2 or unit.isBoss(thisUnit)) then
            var.highestHealth = unit.health(thisUnit)
            var.highestEnemy = thisUnit
            if unit.isBoss(thisUnit) then break end
        end
    end
    var.theseUnits = (ui.mode.rotation == 2 or buff.empyreanPower.exists()) and 1 or ui.value("Divine Storm Units")

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
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        --------------------------
        --- Precombat Rotation ---
        --------------------------
        if actionList.PreCombat() then return true end
        -----------------------
        --- Combat Rotation ---
        -----------------------
        if actionList.Combat() then return true end
        -- if unit.inCombat() and unit.valid("target") then --and opener.complete then
        --     ----------------------------------
        --     --- In Combat - Begin Rotation ---
        --     ----------------------------------
        --     local startTime = debugprofilestop()
        --     -- Start Attack
        --     -- auto_attack
        --     if #enemies.yards5 > 0 and unit.distance("target") < 5 then
        --         if cast.able.autoAttack("target") then
        --             if cast.autoAttack("target") then
        --                 ui.debug("Casting Auto Attack")
        --                 return true
        --             end
        --         end
        --     end
        --     -- Action List - Interrupts
        --     -- rebuke
        --     if actionList.Interrupts() then
        --         return
        --     end
        --     -- Light's Judgment - Lightforged Draenei Racial
        --     if ui.checked("Racial") and race == "LightforgedDraenei" and not unit.isUnit("player", var.highestEnemy) then
        --         if cast.racial(var.highestEnemy) then
        --             ui.debug("Casting Racial: Lightforged Draenei [AOE]")
        --             return true
        --         end
        --     end
        --     -- Action List - Cooldowns
        --     -- call_action_list,name=cooldowns
        --     if actionList.Cooldowns() then
        --         return
        --     end
        --     -- Call Action List - Generator
        --     -- call_action_list,name=generators
        --     if actionList.Generator() then
        --         return
        --     end
        --     br.debug.cpu.rotation.inCombat = debugprofilestop() - startTime
        -- end -- End In Combat
    end -- End Profile
end     -- runRotation
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

local rotationName = "CuteOne" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spells.swipe },
        [2] = { mode = "Multi", value = 2, overlay = "Multiple Target Rotation", tip = "Forces Multiple Target Rotation.", highlight = 0, icon = br.player.spells.swipe },
        [3] = { mode = "Single", value = 3, overlay = "Single Target Rotation", tip = "Forces Single Target Rotation.", highlight = 0, icon = br.player.spells.shred },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.healingTouch }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.tigersFury },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.tigersFury },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.tigersFury }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.healingTouch },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.healingTouch }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.bash },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.bash }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Form Button
    local FormModes = {
        [1] = { mode = "Caster", value = 1, overlay = "Caster Form", tip = "Will force and use Caster Form", highlight = 1, icon = br.player.spells.moonkinForm },
        [2] = { mode = "Cat", value = 2, overlay = "Cat Form", tip = "Will force and use Cat Form", highlight = 0, icon = br.player.spells.catForm },
        [3] = { mode = "Bear", value = 3, overlay = "Bear Form", tip = "Will force and use Bear Form", highlight = 0, icon = br.player.spells.bearForm }
    };
    br.ui:createToggle(FormModes, "Forms", 5, 0)
    -- Prowl Button
    local ProwlModes = {
        [1] = { mode = "On", value = 1, overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon = br.player.spells.prowl },
        [2] = { mode = "Off", value = 2, overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon = br.player.spells.prowl }
    };
    br.ui:createToggle(ProwlModes, "Prowl", 6, 0)
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
        br.ui:createSpinnerWithout(section, "Shift Wait Time", 2, 0, 5, 1,
            "|cffFFFFFFTime in seconds the profile will wait while moving to shift. Combat is instant!")
        br.ui:createCheckbox(section, "Behind Debug", "|cffFFFFFFDebug behind/facing checks for Shred/Ravage.")
        -- Powershifting
        br.ui:createCheckbox(section, "Powershifting", "|cffFFFFFFFeral DPS In-Form Shifting for Energy")
        -- Prowl
        br.ui:createCheckbox(section, "Prowl", "|cffFFFFFFUses Prowl when near aggro range")
        -- Cat Opener
        br.ui:createDropdown(section, "Cat Opener",
            { "|cffFFFFFFPounce", "|cffFFFFFFRavage", "|cffFFFFFFShred", "|cffFFFFFFRake", "|cffFFFFFFMangle" }, 2,
            "|cffFFFFFFSelect Spell to Open with from Stealth")
        br.ui:checkSectionState(section)
        --------------------------
        --- FORM MANAGEMENT ---
        --------------------------
        section = br.ui:createSection(br.ui.window.profile, "Form Management")
        -- Aquatic Form
        br.ui:createCheckbox(section, "Aquatic Form", "|cffFFFFFFEnable/Disable Using Aquatic Form")
        -- Travel Form
        br.ui:createCheckbox(section, "Travel Form", "|cffFFFFFFEnable/Disable Using Travel Form")
        -- Last Form
        br.ui:createCheckbox(section, "Last Form", "|cffFFFFFFEnable/Disable Returning to Last Form")
        -- Energy Threshold
        br.ui:createSpinner(section, "Energy", 30, 1, 100, 1, "|cffFFFFFFCat Form Energy Threshold to Break Form")
        -- Rage Threshold
        br.ui:createSpinner(section, "Rage", 10, 1, 100, 1, "|cffFFFFFFBear Form Rage Threshold to Break Form")
        br.ui:checkSectionState(section)
        ----------------------
        --- BLEED OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Bleeds")
        -- Rake
        br.ui:createCheckbox(section, "Rake", "|cffFFFFFFEnable/Disable Using Rake")
        -- Rip
        br.ui:createCheckbox(section, "Rip", "|cffFFFFFFEnable/Disable Using Rip")
        br.ui:checkSectionState(section)
        ---------------------
        --- BUFF OPTIONS ---
        ---------------------
        section = br.ui:createSection(br.ui.window.profile, "Buffs")
        -- Self-Innervate
        br.ui:createCheckbox(section, "Self-Innervate", "|cffFFFFFFEnable/Disable Using Innervate on Self")
        -- Mark of the Wild
        br.ui:createDropdown(section, "Mark of the Wild",
            { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFGroup" }, 1,
            "|cffFFFFFFSet how to use Mark of the Wild")
        -- Omen of Clarity
        br.ui:createDropdown(section, "Omen of Clarity",
            { "|cffFFFFFFAny", "|cffFFFFFFFocus DPS", "|cffFFFFFFFocus Healing", "|cffFFFFFFNone" }, 1,
            "|cffFFFFFFSelect how to use Omen of Clarity procs")
        -- Thorns
        br.ui:createDropdown(section, "Thorns",
            { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFGroup" }, 1,
            "|cffFFFFFFSet how to use Thorns")
        -- Tiger's Fury
        br.ui:createCheckbox(section, "Tiger's Fury", "|cffFFFFFFEnable/Disable Using Tiger's Fury")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Self-Heal In Group
        br.ui:createCheckbox(section, "Self Heal In Group", "|cffFFFFFFEnable/Disable Healing Self while Grouped")
        -- Healing Touch
        br.ui:createSpinner(section, "Healing Touch", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Regrowth
        br.ui:createSpinner(section, "Regrowth", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Rejuvenation
        br.ui:createSpinner(section, "Rejuvenation", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Barkskin
        br.ui:createSpinner(section, "Barkskin", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Abolish Poison
        br.ui:createCheckbox(section, "Abolish Poison", "|cffFFFFFFEnable/Disable Using Abolish Poison")
        -- Cure Poison
        br.ui:createCheckbox(section, "Cure Poison", "|cffFFFFFFEnable/Disable Using Cure Poison")
        -- Remove Curse
        br.ui:createCheckbox(section, "Remove Curse", "|cffFFFFFFEnable/Disable Using Remove Curse")
        -- Entangling Roots
        br.ui:createCheckbox(section, "Entangling Roots", "|cffFFFFFFEnable/Disable Using Entangling Roots on fleeing enemies")
        -- Faerie Fire
        br.ui:createCheckbox(section, "Faerie Fire", "|cffFFFFFFEnable/Disable Using Faerie Fire/Faerie Fire Feral")
        -- Nature's Grasp
        br.ui:createCheckbox(section, "Nature's Grasp", "|cffFFFFFFEnable/Disable Using Nature's Grasp")
        -- -- Health Potion
        -- br.ui:createCheckbox(section, "Health Potion", "|cffFFFFFFEnable/Disable Using Health Potion")
        -- -- Mana Potion
        -- br.ui:createCheckbox(section, "Mana Potion", "|cffFFFFFFEnable/Disable Using Mana Potion")
        -- Bash
        br.ui:createSpinner(section, "Bash", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- Interrupt Options ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Bash
        br.ui:createCheckbox(section, "Bash - Int")
        -- Maim
        br.ui:createCheckbox(section, "Maim")
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
        -- Forms Key Toggle
        br.ui:createDropdownWithout(section, "Forms Mode", br.ui.dropOptions.Toggle, 6)
        -- Prowl Key Toggle
        br.ui:createDropdownWithout(section, "Prowl Mode", br.ui.dropOptions.Toggle, 6)
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
local comboPoints
local debuff
local enemies
local energy
local rage
local mana
local module
local ui
local unit
local units
local spell
local var = {}
-- General Locals - Common Non-BR API Locals used in profiles
local haltProfile
local profileStop
-- Profile Specific Locals - Any custom to profile locals
local actionList = {}
-- local fbMaxEnergy
local formCost
local formValue
local movingTimer
local lastForm
local powershiftReady = false
local powershiftArmedAt = 0
-- local lastFormBuff = false
-- local freeDPS
-- local freeHeal
local keepAquatic

-- local noShapeshiftPower
-- local needsHealing

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
---
-- estimate time (s) until next energy 'tick' using regen (energy/sec)
local function timeToNextEnergyTick()
    local regen = br.player.power.energy.regen() or 0
    if regen > 0 then
        return 1 / regen
    end
    return 99
end

-- AutoProwl
local function autoProwl()
    if not unit.inCombat() and not buff.prowl.exists() then
        if #enemies.yards20 > 0 then return true end
        if #enemies.yards20nc > 0 then
            for i = 1, #enemies.yards20nc do
                local thisUnit = enemies.yards20nc[i]
                local threatRange = math.max((20 + (unit.level(thisUnit) - unit.level())), 5)
                local react = unit.reaction(thisUnit) or 10
                if unit.distance(thisUnit) < threatRange and (react < 4 or (unit.isUnit("target", thisUnit) and react == 4))
                    and unit.enemy(thisUnit) and unit.canAttack(thisUnit) and not unit.deadOrGhost(thisUnit)
                then
                    return true
                end
            end
        end
        -- if unit.isDummy("target") and unit.distance("target") < 20 then return true end
    end
    return false
end

-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local desc = br._G.C_Spell.GetSpellDescription(spell.ferociousBite.id()) or ""
    if desc == "" then return false end

    local finishHim = false
    if thisUnit == nil then thisUnit = "target" end
    if comboPoints() <= 0 or unit.isDummy(thisUnit) then return false end

    local comboStart = desc:find(" " .. comboPoints() .. " ", 1, true)
    if comboStart == nil then return false end

    local damageList = desc:sub(comboStart + 2)
    local colonPos = damageList:find(": ", 1, true)
    if colonPos == nil then return false end
    damageList = damageList:sub(colonPos + 2)

    local spacePos = damageList:find(" ", 1, true) or (#damageList + 1)
    local token = damageList:sub(1, spacePos - 1):gsub(",", "")

    local low = token:match("^(%d+)%-%d+$") or token:match("^(%d+)$")
    local lower = tonumber(low)
    if lower == nil then return false end

    finishHim = lower >= (unit.health(thisUnit) or 0)
    return finishHim
end

-- Time Moving
local function timeMoving()
    if movingTimer == nil then movingTimer = br._G.GetTime() end
    if not unit.moving() then
        movingTimer = br._G.GetTime()
    end
    return br._G.GetTime() - movingTimer
end

-- Behind check (nil-safe)
-- Prefer the engine API so all profiles share the same fix/behavior.
local function isBehind(thisUnit, otherUnit, degrees)
    if unit == nil or unit.isBehind == nil then return false end
    local result = unit.isBehind(thisUnit, otherUnit, degrees)
    if result == nil or result == false then
        if ui and ui.checked and ui.checked("Behind Debug") then
            ui.debug(string.format(
                "isBehind: FALSE (angle missing or not behind) | thisUnit=%s | otherUnit=%s | degrees=%s",
                tostring(thisUnit), tostring(otherUnit), tostring(degrees)
            ))
        end
        return false
    end
    return true
end

local function safeCancelForm(outOfFormSpellRef, reason, treatOutSpellAsFree)
    treatOutSpellAsFree = false -- Not currently used, but can be used to allow ignoring mana cost of out of form spell when checking if we can break form
    if unit.exists("target") and unit.friend("target") then
        -- ui.debug("Skip Cancel Form [" .. tostring(reason) .. "] (friendly target)")
        return false
    end

    if unit == nil or unit.canCancelFormFor == nil or unit.formBreakManaRequired == nil then
        -- Fallback (shouldn't happen during normal profile execution)
        if buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists() then
            if unit and unit.cancelForm then
                unit.cancelForm()
            else
                br._G.RunMacroText("/CancelForm")
            end
            ui.debug("Cancel Form [" .. tostring(reason) .. "]")
            return true
        end
        return false
    end

    if not unit.canCancelFormFor(outOfFormSpellRef, lastForm, treatOutSpellAsFree) then
        local requiredMana, currentMana = unit.formBreakManaRequired(outOfFormSpellRef, lastForm, treatOutSpellAsFree)
        -- ui.debug("Skip Cancel Form [" .. tostring(reason) .. "] (mana " .. tostring(currentMana) .. " < need " .. tostring(requiredMana) .. ")")
        return false
    end

    if unit and unit.cancelForm then
        unit.cancelForm()
    else
        br._G.RunMacroText("/CancelForm")
    end
    ui.debug("Cancel Form [" .. tostring(reason) .. "]")
    return true
end

-- In Aggro Range Check
local function inAggroRange(offset)
    offset = offset or 0
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local threatRange = math.max((20 + (unit.level(thisUnit) - unit.level())), 5) + offset
        local react = unit.reaction(thisUnit) or 10
        if unit.distance(thisUnit) < threatRange and (react < 4 or (unit.isUnit("target", thisUnit) and react == 4)) then
            return true
        end
    end
    return false
end

local getBuffUnitOption = function(option)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then
        thisUnit = "player"
    end
    if thisTar == 2 then
        thisUnit = "target"
        if not unit.exists(thisUnit) then
            thisUnit = "player"
        end
    end
    if thisTar == 3 then
        thisUnit = "mouseover"
        if not unit.exists(thisUnit) then
            thisUnit = "player"
        end
    end
    if thisTar == 4 then
        thisUnit = "focus"
        if not unit.exists(thisUnit) then
            thisUnit = "player"
        end
    end
    if thisTar == 5 then
        thisUnit = "player"
        if #br.engines.healingEngine.friend > 1 then
            for i = 1, #br.engines.healingEngine.friend do
                local nextUnit = br.engines.healingEngine.friend[i].unit
                local needsBuff = false
                if option == "Mark of the Wild" then
                    needsBuff = buff.markOfTheWild.refresh(nextUnit)
                elseif option == "Thorns" then
                    needsBuff = buff.thorns.refresh(nextUnit)
                end
                if needsBuff and unit.distance(nextUnit) < 40 then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

-- Keep Aquatic Form while swimming unless danger/enemy target.
keepAquatic = function()
    return ui.checked("Aquatic Form")
        and br._G.IsSwimming()
        and buff.aquaticForm.exists()
        and not inAggroRange()
        and (not unit.exists("target") or unit.friend("target"))
end

--------------------
--- Action Lists ---
--------------------

-- Action List - Extra
actionList.Extra = function()
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") and not unit.flying() and not buff.prowl.exists()
        and mana() > cast.cost.markOfTheWild() + formCost
    then
        var.markUnit = getBuffUnitOption("Mark of the Wild")
        if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 40
            and (var.markUnit == "player" or unit.player(var.markUnit))
            and not buff.giftOfTheWild.exists(var.markUnit)
        then
            -- Cancel form if needed to buff
            local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
            if needsCancel then
                if safeCancelForm(spell.markOfTheWild, "Mark of the Wild") then
                    return true
                end
            else
                if cast.markOfTheWild(var.markUnit) then
                    ui.debug("Casting Mark of the Wild")
                    return true
                end
            end
        end
    end
    -- Thorns
    if ui.checked("Thorns") and not unit.flying() and not buff.prowl.exists() and mana() > cast.cost.thorns() + formCost then
        var.thornUnit = getBuffUnitOption("Thorns")
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.thornUnit) < 40
            and (var.thornUnit == "player" or unit.player(var.thornUnit))
        then
            -- Cancel form if needed to buff
            local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
            if needsCancel then
                if safeCancelForm(spell.thorns, "Thorns") then
                    return true
                end
            else
                if cast.thorns(var.thornUnit) then
                    ui.debug("Casting Thorns")
                    return true
                end
            end
        end
    end
    -- Omen of Clarity
    if ui.value("Omen of Clarity") ~= 4 and not unit.flying() and not unit.inCombat() and not unit.resting() and not buff.prowl.exists()
        and mana() > cast.cost.omenOfClarity() + formCost
    then
        if cast.able.omenOfClarity("player") and buff.omenOfClarity.refresh("player") then
            -- Cancel form if needed to buff
            local needsCancel = buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() or buff.aquaticForm.exists()
            if needsCancel then
                if safeCancelForm(spell.omenOfClarity, "Omen of Clarity") then
                    return true
                end
            else
                if cast.omenOfClarity("player") then
                    ui.debug("Casting Omen of Clarity")
                    return true
                end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Abolish Poison
        if ui.checked("Abolish Poison") and cast.able.abolishPoison("player")
            and not buff.abolishPoison.exists("player") and cast.dispel.abolishPoison("player")
            and mana() > cast.cost.abolishPoison() + formCost
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.abolishPoison, "Abolish Poison") then
                    return true
                end
            else
                if cast.abolishPoison("player") then
                    ui.debug("Casting Abolish Poison")
                    return true
                end
            end
        end
        -- Cure Poison
        if ui.checked("Cure Poison") and cast.able.curePoison("player")
            and (not ui.checked("Abolish Poison") --[[or not spell.abolishPoison.known()]]) and cast.dispel.curePoison("player")
            and mana() > cast.cost.curePoison() + formCost
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.curePoison, "Cure Poison") then
                    return true
                end
            else
                if cast.curePoison("player") then
                    ui.debug("Casting Cure Poison")
                    return true
                end
            end
        end
        -- Remove Curse
        if ui.checked("Remove Curse") and cast.able.removeCurse("player")
            and not unit.inCombat() and cast.dispel.removeCurse("player")
            and mana() > cast.cost.removeCurse() + formCost
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.removeCurse, "Remove Curse") then
                    return true
                end
            else
                if cast.removeCurse("player") then
                    ui.debug("Casting Remove Curse")
                    return true
                end
            end
        end
        -- Barkskin
        if ui.checked("Barkskin") and cast.able.barkskin()
            and unit.hp() <= ui.value("Barkskin") and unit.inCombat()
            and mana() > cast.cost.barkskin() + formCost
        then
            if cast.barkskin() then
                ui.debug("Casting Barkskin")
                return true
            end
        end
        -- Entangling Roots (fleeing enemies)
        if ui.checked("Entangling Roots") and cast.able.entanglingRoots("target")
            and unit.exists("target") and not unit.facing("target", "player") and unit.moving("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and unit.inCombat()
            and mana() > cast.cost.entanglingRoots() + formCost
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.entanglingRoots, "Entangling Roots", buff.clearcasting.exists()) then
                    return true
                end
            else
                if cast.entanglingRoots("target") then
                    ui.debug("Casting Entangling Roots")
                    return true
                end
            end
        end
        -- Faerie Fire (Caster)
        if ui.checked("Faerie Fire") and cast.able.faerieFire("target") and not buff.prowl.exists() and formValue == 1
            and unit.exists("target") and unit.enemy("target") and unit.canAttack("target") and not debuff.faerieFire.exists("target")
            and not (buff.catForm.exists() or buff.bearForm.exists())
            and unit.distance("target") > 8 and mana() > cast.cost.faerieFire() + formCost
        then
            if cast.faerieFire("target") then
                ui.debug("Casting Faerie Fire")
                return true
            end
        end
        -- Nature's Grasp
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp()
            and not buff.naturesGrasp.exists("player") and unit.inCombat()
            and #enemies.yards10 > 0 and mana() > cast.cost.naturesGrasp() + formCost
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.naturesGrasp, "Nature's Grasp", buff.clearcasting.exists()) then
                    return true
                end
            else
                if cast.naturesGrasp("player") then
                    ui.debug("Casting Nature's Grasp")
                    return true
                end
            end
        end
        -- Regrowth
        if ui.checked("Regrowth") and cast.able.regrowth("player") and not cast.current.regrowth() and not unit.moving()
            and unit.hp() <= ui.value("Regrowth") and not buff.regrowth.exists("player")
            and (buff.clearcasting.exists() or mana() > cast.cost.regrowth() + formCost)
            and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.regrowth, "Regrowth", buff.clearcasting.exists()) then
                    return true
                end
            else
                if cast.regrowth("player") then
                    ui.debug("Casting Regrowth")
                    return true
                end
            end
        end
        -- Rejuvenation
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target") and mana() > cast.cost.rejuvenation() + formCost then
            if cast.able.rejuvenation("target") and unit.friend("target") and unit.hp("target") <= ui.value("Rejuvenation")
                and unit.player("target") and buff.rejuvenation.refresh("target")
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if safeCancelForm(spell.rejuvenation, "Rejuvenation", buff.clearcasting.exists()) then
                        return true
                    end
                else
                    ui.debug("Attempting to cast Rejuvenation on " .. unit.name("target"))
                    if cast.rejuvenation("target") then
                        return true
                    end
                end
            end
            if cast.able.rejuvenation("player") and not unit.friend("target") and unit.hp() <= ui.value("Rejuvenation")
                and buff.rejuvenation.refresh("player") and not buff.clearcasting.exists()
                and (unit.solo() or ui.checked("Self Heal In Group"))
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if safeCancelForm(spell.rejuvenation, "Rejuvenation", buff.clearcasting.exists()) then
                        return true
                    end
                else
                    if cast.rejuvenation("player") then
                        ui.debug("Casting Rejuvenation on " .. unit.name("player"))
                        return true
                    end
                end
            end
        end
        -- Healing Touch
        if ui.checked("Healing Touch") and not cast.current.healingTouch() and not unit.moving()
            and (buff.clearcasting.exists() or mana() > cast.cost.healingTouch() + formCost)
            and cast.timeSinceLast.healingTouch() > unit.gcd(true)
        then
            if cast.able.healingTouch("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Touch") and unit.player("target") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if safeCancelForm(spell.healingTouch, "Healing Touch", buff.clearcasting.exists()) then
                        return true
                    end
                else
                    if cast.healingTouch("target") then
                        ui.debug("Casting Healing Touch on " .. unit.name("target"))
                        return true
                    end
                end
            end
            if cast.able.healingTouch("player") and not unit.friend("target") and unit.hp() <= ui.value("Healing Touch")
                and (not unit.inGroup() or ui.checked("Self Heal In Group"))
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if safeCancelForm(spell.healingTouch, "Healing Touch", buff.clearcasting.exists()) then
                        return true
                    end
                else
                    if cast.healingTouch("player") then
                        ui.debug("Casting Healing Touch on " .. unit.name("player"))
                        return true
                    end
                end
            end
        end
        -- -- Health Potion
        -- if ui.checked("Health Potion") and unit.canUseItem(5512)
        --     and unit.hp() < ui.value("Rejuvenation")
        --     and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        -- then
        --     if buff.catForm.exists() or buff.bearForm.exists() then
        --         br._G.RunMacroText("/CancelForm")
        --         ui.debug("Cancel Form for Health Potion")
        --         return true
        --     end
        --     if unit.useItem(5512) then
        --         ui.debug("Using Health Potion")
        --         return true
        --     end
        -- end
        -- -- Mana Potion
        -- if ui.checked("Mana Potion") and unit.canUseItem(2455)
        --     and mana.percent() < 30
        -- then
        --     if buff.catForm.exists() or buff.bearForm.exists() then
        --         br._G.RunMacroText("/CancelForm")
        --         ui.debug("Cancel Form for Mana Potion")
        --         return true
        --     end
        --     if unit.useItem(2455) then
        --         ui.debug("Using Mana Potion")
        --         return true
        --     end
        -- end
        -- Bash (low HP defensive stun)
        if ui.checked("Bash") and unit.hp() <= ui.value("Bash") then
            if (buff.bearForm.exists() or buff.direBearForm.exists()) and cast.able.bash("target") then
                if cast.bash("target") then
                    ui.debug("Casting Bash [Defensive]")
                    return true
                end
            end
        end
    end
end -- End Action List - Defensive

-- * Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true))
        -- and not (buff.prowl.exists() or buff.shadowmeld.exists())
    then
        local thisUnit
        -- * Bash
        if ui.checked("Bash - Int") then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    -- Bash is Bear Form only in Classic; shift first if needed.
                    if not buff.bearForm.exists() and cast.able.bearForm() then
                        if cast.bearForm() then
                            ui.debug("Shifting to Bear Form for Bash interrupt")
                            return true
                        end
                    end
                    if (buff.bearForm.exists() or buff.direBearForm.exists()) and cast.able.bash(thisUnit) then
                        if cast.bash(thisUnit) then
                            ui.debug("Casting Bash on " .. unit.name(thisUnit))
                            return true
                        end
                    end
                end
            end
        end
        -- * Maim
        if ui.checked("Maim") and comboPoints() > 0 and energy() >= 35 then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.able.maim(thisUnit) then
                        if cast.maim(thisUnit) then
                            ui.debug("Casting Maim on " .. unit.name(thisUnit))
                            return true
                        end
                    end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if not buff.prowl.exists() and unit.distance("target") < 5 then
        -- * Module- Basic Trinkets
        -- use_items
        module.BasicTrinkets()
        -- Innervate
        if ui.checked("Self-Innervate") and ui.useCDs()
            and cast.able.innervate() and mana.percent() < 30
        then
            if cast.innervate("player") then
                ui.debug("Casting Innervate")
                return true
            end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Form Management
actionList.FormManagement = function()
    -- Aquatic Form
    if ui.checked("Aquatic Form") and not unit.inCombat() and cast.able.aquaticForm()
        and br._G.IsSwimming() and not buff.aquaticForm.exists() and not buff.prowl.exists()
        and unit.moving() and timeMoving() > 2 and not inAggroRange()
    then
        if buff.catForm.exists() or buff.bearForm.exists() or buff.travelForm.exists() then
            if safeCancelForm(spell.aquaticForm, "Swimming") then
                return true
            end
        end
        if cast.aquaticForm() then
            ui.debug("Casting Aquatic Form")
            return true
        end
    end

    -- Travel Form
    if ui.checked("Travel Form") and not unit.inCombat() and not br._G.IsMounted()
        and not br._G.IsSwimming() and not br._G.IsFalling() and cast.able.travelForm()
        and not buff.travelForm.exists() and not buff.prowl.exists()
        and unit.moving() and timeMoving() > 2 and not inAggroRange()
    then
        if buff.catForm.exists() or buff.bearForm.exists() then
            if safeCancelForm(spell.travelForm, "Travel") then
                return true
            end
        end
        if cast.travelForm() then
            ui.debug("Casting Travel Form")
            return true
        end
    end

    -- Auto Shapeshift
    if not keepAquatic() --and not needsFormBreak()
        and ((unit.moving() and timeMoving() > ui.value("Shift Wait Time")) or unit.inCombat() or inAggroRange(5))
    then
        -- Bear Form
        if formValue == 3 and (spell.bearForm.known() or spell.direBearForm.known())
            and ((cast.able.bearForm() and not spell.direBearForm.known()) or cast.able.direBearForm())
            and not buff.bearForm.exists() and not buff.direBearForm.exists()
        then
            if spell.direBearForm.known() then
                if cast.direBearForm() then
                    ui.debug("Casting Dire Bear Form")
                    return true
                end
            else
                if cast.bearForm() then
                    ui.debug("Casting Bear Form")
                    return true
                end
            end
        end
        -- Cat Form
        if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5
            -- and not unit.inCombat()
            and cast.able.catForm() and not buff.catForm.exists()
            and not (buff.aquaticForm.exists() or buff.travelForm.exists() or buff.flightForm.exists() or buff.swiftFlightForm.exists())
        then
            if cast.catForm() then
                ui.debug("Casting Cat Form")
                return true
            end
        end
        -- Caster Form
        if formValue == 1 and (buff.bearForm.exists() or buff.direBearForm.exists() or buff.catForm.exists()) then
            if unit and unit.cancelForm then
                unit.cancelForm()
            else
                br._G.RunMacroText("/CancelForm")
            end
            ui.debug("Casting Caster Form")
            return true
        end
    end
end -- End Action List - Form Management

-- Action List - Bear Form
actionList.BearForm = function()
    -- -- Bear Form
    -- if ((cast.able.bearForm() and not spell.direBearForm.known()) or cast.able.direBearForm())
    --     and not buff.bearForm.exists() and not buff.direBearForm.exists()
    --     and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
    --     and not (buff.thorns.refresh() and ui.checked("Thorns"))
    -- then
    --     if spell.direBearForm.known() then
    --         if cast.direBearForm() then
    --             ui.debug("Casting Dire Bear Form")
    --             return true
    --         end
    --     else
    --         if cast.bearForm() then
    --             ui.debug("Casting Bear Form")
    --             return true
    --         end
    --     end
    -- end
    -- Enrage
    if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage() < 10 and unit.hp() > 80 then
        if cast.enrage() then
            ui.debug("Casting Enrage")
            return true
        end
    end
    -- Demoralizing Roar
    if cast.able.demoralizingRoar() and not debuff.demoralizingRoar.exists("target")
        and #enemies.yards10 > 0
    then
        if cast.demoralizingRoar() then
            ui.debug("Casting Demoralizing Roar")
            return true
        end
    end
    -- Swipe (multi-target)
    if cast.able.swipe() and ui.useAOE(8,3) then
        if cast.swipe() then
            ui.debug("Casting Swipe")
            return true
        end
    end
    -- Maul
    if cast.able.maul("target") and (ui.useST(8,3) or not spell.swipe.known()) then
        if cast.maul("target") then
            ui.debug("Casting Maul")
            return true
        end
    end
end -- End Action List - Bear Form

-- Action List - Cat Opener (Stealth + Non-Stealth)
actionList.CatOpener = function()
    if not buff.catForm.exists() then return false end
    if not unit.valid("target") or unit.deadOrGhost("target") or unit.distance("target") >= 5 then return false end
    if unit.player("target") then return false end

    -- Tiger's Fury gating: if enabled+known and we're at full energy, cast it before opening.
    if ui.checked("Tiger's Fury") and spell.tigersFury.known() and energy()== 100 and not buff.tigersFury.exists() then
        if cast.able.tigersFury() and cast.tigersFury() then
            ui.debug("Casting Tiger's Fury [Opener]")
            return true
        end
        return false
    end

    local opener = ui.value("Cat Opener")

    -- Stealth Opener
    if buff.prowl.exists() then
        -- Pounce (Opener 1)
        if opener == 1 and cast.able.pounce() then
            if cast.pounce("target") then
                ui.debug("Casting Pounce [Stealth Opener]")
                return true
            end
        end

        -- Ravage from behind (Opener 2 or fallback)
        if (opener == 2 or (opener <= 1 and not spell.pounce.known()))
            and cast.able.ravage("target") and isBehind("target", "player")
        then
            if cast.ravage("target") then
                ui.debug("Casting Ravage [Stealth Opener]")
                return true
            end
        end

        -- Shred from behind (Opener 3 or fallback)
        if (opener == 3 or (opener <= 2 and not spell.ravage.known()))
            and cast.able.shred("target") and isBehind("target", "player") and not unit.facing("target", "player")
        then
            if cast.shred("target") then
                ui.debug("Casting Shred [Stealth Opener]")
                return true
            end
        end

        -- Rake (Opener 4 or fallback)
        if ui.checked("Rake") and (opener == 4 or (opener <= 3 and not spell.shred.known()))
            and cast.able.rake("target")
        then
            if cast.rake("target") then
                ui.debug("Casting Rake [Stealth Opener]")
                return true
            end
        end

        -- Mangle
        if ((opener == 5 and not ui.checked("Rake")) or (opener < 5 and not spell.rake.known()))
            and cast.able.mangleCat("target") and (not (spell.ravage.known() or spell.shred.known()) or unit.facing("target", "player"))
        then
            if cast.mangleCat("target") then
                ui.debug("Casting Mangle [Stealth Opener]")
                return true
            end
        end

        -- Claw (ultimate fallback)
        if ((opener == 4 and not ui.checked("Rake")) or (opener < 4 and not spell.rake.known()))
            and not spell.mangleCat.known() and cast.able.claw("target")
        then
            if cast.claw("target") then
                ui.debug("Casting Claw [Stealth Opener]")
                return true
            end
        end

        return false
    end

    -- Non-Stealth Opener
    local behindTarget = isBehind("target", "player")
    if (behindTarget or not spell.shred.known()) then
        -- Shred (from behind)
        local triedShred = false
        if behindTarget and cast.able.shred("target") then
            if not unit.facing("target", "player") then
                triedShred = true
                if cast.shred("target") then
                    ui.debug("Casting Shred [Opener]")
                    return true
                end
            end
        end
        -- Mangle
        if cast.able.mangleCat("target") and (not spell.shred.known() or not behindTarget) then
            if cast.mangleCat("target") then
                ui.debug("Casting Mangle [Opener]")
                return true
            end
        end
        -- Claw (fallback)
        if cast.able.claw("target") and ((not spell.shred.known() or not behindTarget) or not spell.mangleCat.known()) then
            if cast.claw("target") then
                ui.debug("Casting Claw [Opener]")
                return true
            end
        end
    end

    return false
end

-- Action List - Cat Form
actionList.CatForm = function()
    if unit.inCombat("player") and buff.catForm.exists() then
        -- Powershift for Energy (Cat Form with Furor talent)
        if ui.checked("Powershifting") and cast.able.catForm() and unit.inCombat()
            and not buff.clearcasting.exists() and mana() > formCost
        then
            local cp = comboPoints()
            local nextTick = timeToNextEnergyTick()
            local omen = buff.clearcasting.exists()
            local maxWait = 0.75
            local immediateShiftThreshold = math.max(10, ui.round(ui.value("Energy")*(mana.percent()/100), 0))

            -- Immediate shift if energy is very low
            if energy() < immediateShiftThreshold then
                if cast.macro("/cast !"..spell.catForm.name()) then
                    ui.debug("Powershift for Energy")
                    powershiftReady = false
                    return true
                end
            end

            -- -- Decide whether to shift now or wait for next tick
            -- local shouldShift = false
            -- if cp > 0 then
            --     -- If we can finish now, prefer finishing rather than shifting
            --     if energy() >= 35 or omen then
            --         shouldShift = false
            --     else
            --         -- Not enough energy to finish; shift if next tick is sufficiently far
            --         if nextTick > maxWait then shouldShift = true end
            --     end
            -- else
            --     -- No combo points: shift when waiting for next tick would be long
            --     if nextTick > maxWait then shouldShift = true end
            -- end

            -- if shouldShift then
            --     if not powershiftReady then
            --         powershiftReady = true
            --         powershiftArmedAt = br._G.GetTime()
            --         ui.debug("Powershift - armed, will execute next tick")
            --         return true
            --     else
            --         -- small safety: ensure at least a tiny delay after arming
            --         if br._G.GetTime() - powershiftArmedAt < 0.05 then
            --             return true
            --         end
            --         -- Execute powershift: recast via macro (macro handles rebuff)
            --         if cast.macro("/cast !"..spell.catForm.name()) then
            --             ui.debug("Powershift")
            --             powershiftReady = false
            --             powershiftArmedAt = 0
            --             return true
            --         end
            --     end
            -- else
            --     powershiftReady = false
            -- end
        end
        -- Ferocious Bite - Finish Him!
        local finish = ferociousBiteFinish("target")
        if cast.able.ferociousBite("target") and energy() >= 35 and finish then
            if cast.ferociousBite("target") then
                ui.debug("Casting Ferocious Bite [Finish Him!]")
                return true
            end
        end

        -- Tiger's Fury
        if ui.checked("Tiger's Fury") and cast.able.tigersFury() and buff.catForm.exists() and energy() == 100
            and not buff.tigersFury.exists()
        then
            if cast.tigersFury() then
                ui.debug("Casting Tiger's Fury")
                return true
            end
        end

        -- Faerie Fire (Feral)
        if ui.checked("Faerie Fire") and cast.able.faerieFireFeral("target") and unit.valid("target")
            and not buff.prowl.exists()
            and not debuff.faerieFireFeral.exists("target")
            and not unit.isElemental("target")
            and unit.ttd("target") > cd.global.remain()
        then
            if cast.faerieFireFeral("target") then
                ui.debug("Casting Faerie Fire (Feral)")
                return true
            end
        end

        -- 5 Combo Points - Finishers
        if comboPoints() >= 4 and not finish then
            -- Rip
            if ui.checked("Rip") and cast.able.rip("target") and unit.ttd("target") > 6 and debuff.rip.refresh("target") then
                if cast.rip("target") then
                    ui.debug("Casting Rip")
                    return true
                end
            end
            -- Ferocious Bite (low energy)
            if cast.able.ferociousBite("target") and energy() >= 35 and energy() < 60 then
                if cast.ferociousBite("target") then
                    ui.debug("Casting Ferocious Bite")
                    return true
                end
            end
        end

        -- Combo Point Builders
        if (comboPoints() < 5 or energy() >= 60 or buff.clearcasting.exists()) and not finish then
            -- Ravage (from Prowl)
            local behindRavage = isBehind("target", "player")
            if cast.able.ravage("target") and buff.prowl.exists() and behindRavage then
                if cast.ravage("target") then
                    ui.debug("Casting Ravage")
                    return true
                end
            end
            -- Rake
            if ui.checked("Rake") and cast.able.rake("target") and debuff.rake.refresh("target")
                and (unit.ttd("target") <= 3 or not spell.ferociousBite.known())
                and not buff.clearcasting.exists()
            then
                if cast.rake("target") then
                    ui.debug("Casting Rake")
                    return true
                end
            end
            -- Mangle
            local behindDyn5 = isBehind("target", "player")
            if cast.able.mangleCat("target") and ((not spell.shred.known() or not behindDyn5)
                or debuff.mangleCat.refresh("target","any"))
            then
                if cast.mangleCat("target") then
                    ui.debug("Casting Mangle")
                    return true
                end
            end
            -- Shred (from behind)
            local triedShred = false
            if behindDyn5 and cast.able.shred("target") then
                if not unit.facing("target", "player") then
                    triedShred = true
                    if cast.shred("target") then
                        ui.debug("Casting Shred")
                        return true
                    end
                end
            end
            -- Claw (not behind)
            if cast.able.claw("target") and (not spell.shred.known() or not behindDyn5) and not spell.mangleCat.known() then
                if cast.claw("target") then
                    ui.debug("Casting Claw")
                    return true
                end
            end
        end
    end
end -- End Action List - Cat Form

-- Action List - Caster Form
actionList.CasterForm = function()
    -- Moonfire
    if cast.able.moonfire(units.dyn40AOE) and debuff.moonfire.refresh(units.dyn40AOE) then
        if cast.moonfire(units.dyn40AOE) then
            ui.debug("Casting Moonfire")
            return true
        end
    end
    -- Starfire (if available)
    if cast.able.starfire() and not unit.moving() and cast.able.starfire() and unit.level() >= 20
        and (debuff.moonfire.exists(units.dyn40AOE) or not spell.moonfire.known())
        and (not cast.last.starfire() or cast.timeSinceLast.starfire() > unit.gcd(true) + 0.5)
    then
        if cast.starfire() then
            ui.debug("Casting Starfire")
            return true
        end
    end
    -- Wrath
    if cast.able.wrath() and not unit.moving()
        and (unit.level() < 20 or not spell.starfire.known())
        and (debuff.moonfire.exists(units.dyn40AOE) or not spell.moonfire.known())
        and (not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5)
    then
        if cast.wrath() then
            ui.debug("Casting Wrath")
            return true
        end
    end
end -- End Action List - Caster Form

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            -- Prowl
            if ui.checked("Prowl") and cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1
                and not buff.prowl.exists() and not unit.resting() and not unit.deadOrGhost("target")
            then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl [Precombat]")
                    return true
                end
            end
        end -- End No Stealth
        if unit.valid("target") then
            local thisDistance = unit.distance("target") or 99
            -- Wrath
            if not unit.moving() and not (buff.catForm.exists() or buff.bearForm.exists() or buff.direBearForm.exists()) and thisDistance < 30 then
                if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) then
                    if cast.wrath("target") then
                        ui.debug("Casting Wrath [Precombat]")
                        return true
                    end
                end
            end
            if thisDistance < 5 then
                -- Cat Opener (Stealth + Non-Stealth)
                if formValue == 2 then
                    if actionList.CatOpener() then return true end
                end
                -- Bear Form
                if formValue == 3 then
                    -- Bear Form
                    if ((cast.able.bearForm() and not spell.direBearForm.known()) or cast.able.direBearForm())
                        and not buff.bearForm.exists() and not buff.direBearForm.exists()
                        and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
                        and not (buff.thorns.refresh() and ui.checked("Thorns"))
                    then
                        if spell.direBearForm.known() then
                            if cast.direBearForm() then
                                ui.debug("Casting Dire Bear Form")
                                return true
                            end
                        else
                            if cast.bearForm() then
                                ui.debug("Casting Bear Form")
                                return true
                            end
                        end
                    end
                    if (buff.bearForm.exists() or buff.direBearForm.exists()) then
                        -- Enrage
                        if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage() < 10 then
                            if cast.enrage() then
                                ui.debug("Casting Enrage [Precombat]")
                                return true
                            end
                        end
                        -- Swipe
                        if cast.able.swipe() and ui.useAOE(8,3) then
                            if cast.swipe() then
                                ui.debug("Casting Swipe [Precombat]")
                                return true
                            end
                        end
                        -- Maul
                        if cast.able.maul("target") and (ui.useST(8,3) or not spell.swipe.known()) then
                            if cast.maul("target") then
                                ui.debug("Casting Maul [Precombat]")
                                return true
                            end
                        end
                    end
                end
                -- Auto Attack (do not break Prowl)
                if not buff.prowl.exists() and not cast.auto.autoAttack() and unit.valid("target") and not unit.deadOrGhost("target") and unit.distance("target") < 5 then
                    br._G.StartAttack()
                    ui.debug("Casting Auto Attack [Precombat]")
                    return true
                end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Combat
actionList.Combat = function()
    if unit.inCombat() and unit.valid("target") then
        ------------------------
        --- In Combat - Main ---
        ------------------------
        -- Start Attack (do not break Prowl)
        if not buff.prowl.exists() and unit.exists("target") and not cast.auto.autoAttack() and not unit.deadOrGhost("target") then
            br._G.StartAttack()
            ui.debug("Casting Auto Attack")
            return true
        end

        -- Call Action List - Cooldowns
        if actionList.Cooldowns() then return true end

        -- Wait for swing if in melee range
        -- if unit.exists("target") and unit.distance("target") < 5 and
        --     (formValue == 2 and buff.catForm.exists()
        --     or formValue == 3 and (buff.bearForm.exists() or buff.direBearForm.exists()))
        -- then
        --     local swing = br.swingTimer
        --     -- ui.debug("Swing Timer: " .. tostring(swing) .. " | Distance: " .. tostring(unit.distance("target")))
        --     local waitThreshold = 0.15 -- seconds; tune between 0.15-0.30
        --     if swing and swing > 0 and swing < waitThreshold then
        --         if not br.waitingForSwing then
        --             br.waitingForSwing = true
        --             br.waitingForSwingTimeout = br._G.GetTime() + 1.5 -- safety timeout
        --             ui.debug("Waiting for swing: " .. br.functions.misc:round2(swing,2) .. "s")
        --         end
        --         -- clear waiting flag if swing occurred or timeout expired
        --         if br.swingTimer == 0 or (br.waitingForSwingTimeout and br._G.GetTime() >= br.waitingForSwingTimeout) then
        --             br.waitingForSwing = false
        --             br.waitingForSwingTimeout = nil
        --         else
        --             return true
        --         end
        --     end
        -- end

        -- Call Action List - Bear Form
        if formValue == 3 and (buff.bearForm.exists() or buff.direBearForm.exists()) and unit.exists("target") and unit.distance("target") < 5 then
            if actionList.BearForm() then return true end
        end

        -- Call Action List - Cat Form
        if formValue == 2 and unit.exists("target") and unit.distance("target") < 5 then
            if buff.prowl.exists() and actionList.CatOpener() then return true end
            if actionList.CatForm() then return true end
        end

        -- Call Action List - Caster Form
        if formValue == 1 and not (buff.catForm.exists() or buff.bearForm.exists() or buff.direBearForm.exists()) then
            if actionList.CasterForm() then return true end
        end
    end -- End In Combat Rotation
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
    comboPoints = br.player.power.comboPoints
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    energy      = br.player.power.energy
    mana        = br.player.power.mana
    rage        = br.player.power.rage
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716
    formValue = ui.mode.forms
    formCost = 0
    if not br.player.localTrinkets then br.player.localTrinkets = true end
    if ui.mode.forms == 2 then formCost = cast.cost.catForm() end
    if ui.mode.forms == 3 then formCost = spell.direBearForm.known() and cast.cost.direBearForm() or cast.cost.bearForm() end
    -- Units
    units.get(5)        -- Makes a variable called, "target"
    -- units.get(40)       -- Makes a variable called, units.dyn40
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    -- enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(20)     -- Makes a varaible called, enemies.yards20
    enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(40)     -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    -- fbMaxEnergy = energy() >= 50

    -- Update Last Form tracking
    -- updateLastForm()

    -- -- Omen of Clarity Logic
    -- local omenSetting = ui.value("Omen of Clarity")
    -- needsHealing = (ui.checked("Regrowth") and unit.hp() <= ui.value("Regrowth"))
    --     or (ui.checked("Healing Touch") and unit.hp() <= ui.value("Healing Touch"))
    --     or (ui.checked("Rejuvenation") and unit.hp() <= ui.value("Rejuvenation"))

    -- freeDPS = omenSetting ~= 4 and omenSetting ~= 2 and buff.clearcasting.exists()
    --     and (not needsHealing or omenSetting == 3)

    -- freeHeal = omenSetting ~= 4 and omenSetting ~= 3 and buff.clearcasting.exists()

    -- No Shapeshift Power check
    -- noShapeshiftPower = ((not buff.catForm.exists() or (buff.catForm.exists() and energy() < ui.value("Energy")))
    --     and (not (buff.bearForm.exists() and buff.direBearForm.exists())
    --         or ((buff.bearForm.exists() or buff.direBearForm.exists()) and rage() < ui.value("Rage"))))
    --     or not unit.inCombat()

    if not unit.inCombat() and not unit.exists("target") then
        if profileStop then profileStop = false end
    end

    -- ui.chatOverlay("Shift At: "..tostring(ui.round(math.max(10, ui.value("Energy")*(mana.percent()/100)),0)))

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
        --- Form Management ---
        -----------------------
        if actionList.FormManagement() then return true end
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
local id = 283 -- Change to the spec id profile is for.
local expansion = br.isBC -- Change to the expansion the profile is for.
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

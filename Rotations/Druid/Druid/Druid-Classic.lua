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
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.healingTouch },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.healingTouch }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.bash },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.bash }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 3, 0)
    -- Form Button
    local FormModes = {
        [1] = { mode = "Caster", value = 1, overlay = "Caster Form", tip = "Will force and use Caster Form", highlight = 1, icon = br.player.spells.moonkinForm },
        [2] = { mode = "Cat", value = 2, overlay = "Cat Form", tip = "Will force and use Cat Form", highlight = 0, icon = br.player.spells.catForm },
        [3] = { mode = "Bear", value = 3, overlay = "Bear Form", tip = "Will force and use Bear Form", highlight = 0, icon = br.player.spells.bearForm }
    };
    br.ui:createToggle(FormModes, "Forms", 4, 0)
    -- Prowl Button
    local ProwlModes = {
        [1] = { mode = "On", value = 1, overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon = br.player.spells.prowl },
        [2] = { mode = "Off", value = 2, overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon = br.player.spells.prowl }
    };
    br.ui:createToggle(ProwlModes, "Prowl", 5, 0)
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
            { "|cffFFFFFFPounce", "|cffFFFFFFRavage", "|cffFFFFFFShred", "|cffFFFFFFRake" }, 2,
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
local fbMaxEnergy
local movingTimer
local lastForm
local lastFormBuff = false
local freeDPS
local freeHeal
local noShapeshiftPower
local needsHealing

-----------------
--- Functions --- -- List all profile specific custom functions here
-----------------
-- AutoProwl
local function autoProwl()
    if not unit.inCombat() and not buff.prowl.exists() then
        if #enemies.yards20 > 0 then return true end
        if #enemies.yards20nc > 0 then
            for i = 1, #enemies.yards20nc do
                local thisUnit = enemies.yards20nc[i]
                local threatRange = math.max((20 + (unit.level(thisUnit) - unit.level())), 5)
                local react = unit.reaction(thisUnit) or 10
                if unit.distance(thisUnit) < threatRange and (react < 4 or (unit.isUnit("target", thisUnit) and react == 4)) and unit.enemy(thisUnit) and unit.canAttack(thisUnit) then
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
    if thisUnit == nil then thisUnit = units.dyn5 end
    if comboPoints <= 0 or unit.isDummy(thisUnit) then return false end

    local comboStart = desc:find(" " .. comboPoints .. " ", 1, true)
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

local function debugBehind(label, thisUnit)
    if ui == nil or ui.checked == nil or not ui.checked("Behind Debug") then return end
    if thisUnit == nil or not unit.exists(thisUnit) then return end
    local targetName = unit.exists("target") and unit.name("target") or "none"
    local thisName = unit.name(thisUnit) or tostring(thisUnit)
    local isTarget = unit.exists("target") and unit.isUnit(thisUnit, "target")
    local dist = unit.distance(thisUnit) or -1

    -- Engine-facing results
    local facingPlayer = unit.facing(thisUnit, "player")
    local behindPlayer = unit.isBehind(thisUnit, "player")

    -- Raw unlocker-facing check (front 180 cone)
    local rawFacing180
    if br and br._G and br._G.ObjectIsFacing then
        local ok, res = pcall(br._G.ObjectIsFacing, thisUnit, "player", 180)
        rawFacing180 = ok and res or nil
    end

    ui.debug(string.format(
        "%s | unit=%s (isTarget=%s, dist=%.1f) | target=%s | facingPlayer=%s | behindPlayer=%s | rawFacing180=%s",
        tostring(label), tostring(thisName), tostring(isTarget), tonumber(dist) or -1, tostring(targetName),
        tostring(facingPlayer), tostring(behindPlayer), tostring(rawFacing180)
    ))
end

-- Update Last Form
local function updateLastForm()
    if buff.direBearForm.exists() then lastForm = spell.direBearForm end
    if buff.bearForm.exists() then lastForm = spell.bearForm end
    if buff.catForm.exists() then lastForm = spell.catForm end
    if buff.moonkinForm.exists() then lastForm = spell.moonkinForm end

    lastFormBuff = false
    if buff.direBearForm.exists() or buff.bearForm.exists() or buff.catForm.exists() or buff.moonkinForm.exists() then
        lastFormBuff = true
    end

    -- Set default last form if none set
    if lastForm == nil and unit.level() >= 10 and spell.bearForm.known() then
        lastForm = spell.direBearForm.known() and spell.direBearForm or spell.bearForm
    end
    if lastForm == nil and unit.level() >= 20 and spell.catForm.known() then
        lastForm = spell.catForm
    end
end
local function safeCancelForm(outOfFormSpellRef, reason, treatOutSpellAsFree)
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

-- Powershift for Energy
local function powershift()
    if cd.global.remain() == 0 and unit.combatTime() > 1 then
        for i = 1, br._G.GetNumShapeshiftForms() do
            local _, name, active = br._G.GetShapeshiftFormInfo(i)
            if name and active then
                br._G.CancelShapeshiftForm()
                ui.debug("Powershift - Canceling Form")
                br._G.CastShapeshiftForm(i)
                return true
            end
        end
    end
    return false
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

-- Check if we need to cast anything that requires breaking form
local function needsFormBreak()
    -- Buffs
    if ui.checked("Mark of the Wild") then
        var.markUnit = getBuffUnitOption("Mark of the Wild")
        if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 40
            and (var.markUnit == "player" or unit.player(var.markUnit))
        then
            return true
        end
    end
    if ui.checked("Thorns") then
        var.thornUnit = getBuffUnitOption("Thorns")
        if cast.able.thorns(var.thornUnit) and buff.thorns.refresh(var.thornUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.thornUnit) < 40
            and (var.thornUnit == "player" or unit.player(var.thornUnit))
        then
            return true
        end
    end
    if ui.value("Omen of Clarity") ~= 4 and not unit.inCombat() then
        if cast.able.omenOfClarity("player") and buff.omenOfClarity.refresh("player") then
            return true
        end
    end

    -- Defensive actions
    if ui.useDefensive() then
        -- Dispels
        if ui.checked("Abolish Poison") and cast.able.abolishPoison("player")
            and not buff.abolishPoison.exists("player") and unit.hasDispel("player", spell.abolishPoison)
        then
            return true
        end
        if ui.checked("Cure Poison") and cast.able.curePoison("player")
            and not ui.checked("Abolish Poison") and unit.hasDispel("player", spell.curePoison)
        then
            return true
        end
        if ui.checked("Remove Curse") and cast.able.removeCurse("player")
            and not unit.inCombat() and unit.hasDispel("player", spell.removeCurse)
        then
            return true
        end
        -- Entangling Roots
        if ui.checked("Entangling Roots") and cast.able.entanglingRoots("target")
            and unit.exists("target") and not unit.facing("target", "player") and unit.moving("target")
            and unit.valid("target") and unit.hp("target") < 100 and not debuff.entanglingRoots.exists("target")
            and unit.distance("target") > 8 and unit.inCombat()
        then
            return true
        end
        -- Nature's Grasp
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp()
            and not buff.naturesGrasp.exists("player") and unit.inCombat()
            and #enemies.yards10 > 0
        then
            return true
        end
        -- Healing
        if ui.checked("Regrowth") and cast.able.regrowth("player") and not cast.current.regrowth() and not unit.moving()
            and unit.hp() <= ui.value("Regrowth") and not buff.regrowth.exists("player")
            and (freeHeal or noShapeshiftPower)
            and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        then
            return true
        end
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target") then
            if cast.able.rejuvenation("target") and unit.friend("target") and unit.hp("target") <= ui.value("Rejuvenation")
                and unit.player("target") and buff.rejuvenation.refresh("target")
            then
                return true
            end
            if cast.able.rejuvenation("player") and not unit.friend("target") and unit.hp() <= ui.value("Rejuvenation")
                and buff.rejuvenation.refresh("player") and not buff.clearcasting.exists()
                and (unit.solo() or ui.checked("Self Heal In Group"))
            then
                return true
            end
        end
        if ui.checked("Healing Touch") and not cast.current.healingTouch() and not unit.moving()
            and (freeHeal or noShapeshiftPower)
        then
            if cast.able.healingTouch("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Touch") and unit.player("target") then
                return true
            end
            if cast.able.healingTouch("player") and not unit.friend("target") and unit.hp() <= ui.value("Healing Touch")
                and (not unit.inGroup() or ui.checked("Self Heal In Group"))
            then
                return true
            end
        end
    end

    return false
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Cancel Form to Interact with NPCs
    -- if unit.exists("target") and unit.friend("target") and not unit.deadOrGhost("target") and not unit.player("target")
    --     and unit.distance("target") < 8 and (buff.catForm.exists() or buff.bearForm.exists())
    -- then
    --     br._G.RunMacroText("/CancelForm")
    --     ui.debug("Cancel Form [NPC]")
    --     br._G.InteractUnit("target")
    --     ui.debug("Interacting [NPC]")
    --     return true
    -- end

    -- Aquatic Form
    if ui.checked("Aquatic Form") and not unit.inCombat() and cast.able.aquaticForm()
        and br._G.IsSwimming() and not buff.aquaticForm.exists() and not buff.prowl.exists()
        and unit.moving() and timeMoving() > 2 and not inAggroRange()
        and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
        and not (buff.thorns.refresh() and ui.checked("Thorns"))
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
        and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
        and not (buff.thorns.refresh() and ui.checked("Thorns"))
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

    -- Powershift for Energy (Cat Form with Furor talent)
    if ui.checked("Powershifting") and cast.able.catForm() and buff.catForm.exists() and unit.inCombat() and energy < 30
        and comboPoints < 5 and not buff.clearcasting.exists() and unit.power.mana.percent() > 30
    then
        if powershift() then
            ui.debug("Powershift for Energy")
            return true
        end
    end

    -- Keep Aquatic Form while swimming unless danger/enemy target.
    local keepAquatic = ui.checked("Aquatic Form")
        and br._G.IsSwimming()
        and buff.aquaticForm.exists()
        and not inAggroRange()
        and (not unit.exists("target") or unit.friend("target"))

    -- Auto Shapeshift
    if not keepAquatic and not needsFormBreak()
        and ((unit.moving() and timeMoving() > ui.value("Shift Wait Time")) or unit.inCombat() or inAggroRange(5))
    then
        local formValue = ui.mode.forms
        -- Bear Form
        if formValue == 3 and unit.level() >= 8 and cast.able.bearForm() and not buff.bearForm.exists()
            and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
            and not (buff.thorns.refresh() and ui.checked("Thorns"))
        then
            if cast.bearForm() then
                ui.debug("Casting Bear Form")
                return true
            end
        end
        -- Caster Form
        if formValue == 1 and (buff.bearForm.exists() or buff.catForm.exists()) then
            if unit and unit.cancelForm then
                unit.cancelForm()
            else
                br._G.RunMacroText("/CancelForm")
            end
            ui.debug("Casting Caster Form")
            return true
        end
        -- Cat Form
        if (formValue == 2 or (formValue == 3 and unit.level() < 8)) and unit.level() >= 5
            and cast.able.catForm() and not buff.catForm.exists()
            and not (buff.markOfTheWild.refresh() and ui.checked("Mark of the Wild"))
            and not (buff.thorns.refresh() and ui.checked("Thorns"))
        then
            if cast.catForm() then
                ui.debug("Casting Cat Form")
                return true
            end
        end
    end
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") then
        var.markUnit = getBuffUnitOption("Mark of the Wild")
        if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
            and not unit.inCombat() and not unit.resting() and unit.distance(var.markUnit) < 40
            and (var.markUnit == "player" or unit.player(var.markUnit))
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
    if ui.checked("Thorns") then
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
    if ui.value("Omen of Clarity") ~= 4 and not unit.inCombat() then
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
            and not buff.abolishPoison.exists("player") and unit.hasDispel("player", spell.abolishPoison)
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
            and (not ui.checked("Abolish Poison") --[[or not spell.known.abolishPoison()]]) and unit.hasDispel("player", spell.curePoison)
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
            and not unit.inCombat() and unit.hasDispel("player", spell.removeCurse)
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
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.entanglingRoots, "Entangling Roots", freeDPS) then
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
        if ui.checked("Faerie Fire") and cast.able.faerieFire("target")
            and unit.exists("target") and unit.enemy("target") and unit.canAttack("target") and not debuff.faerieFire.exists("target")
            and not (buff.catForm.exists() or buff.bearForm.exists())
            and unit.distance("target") > 8 and noShapeshiftPower
        then
            if cast.faerieFire("target") then
                ui.debug("Casting Faerie Fire")
                return true
            end
        end
        -- Nature's Grasp
        if ui.checked("Nature's Grasp") and cast.able.naturesGrasp()
            and not buff.naturesGrasp.exists("player") and unit.inCombat()
            and #enemies.yards10 > 0
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.naturesGrasp, "Nature's Grasp", freeDPS) then
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
            and (freeHeal or noShapeshiftPower)
            and (not unit.inGroup() or ui.checked("Self Heal In Group"))
        then
            if buff.catForm.exists() or buff.bearForm.exists() then
                if safeCancelForm(spell.regrowth, "Regrowth", freeHeal) then
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
        if ui.checked("Rejuvenation") and not cast.current.rejuvenation("target") then
            if cast.able.rejuvenation("target") and unit.friend("target") and unit.hp("target") <= ui.value("Rejuvenation")
                and unit.player("target") and buff.rejuvenation.refresh("target")
            then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if safeCancelForm(spell.rejuvenation, "Rejuvenation", freeHeal) then
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
                    if safeCancelForm(spell.rejuvenation, "Rejuvenation", freeHeal) then
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
            and (freeHeal or noShapeshiftPower)
        then
            if cast.able.healingTouch("target") and unit.friend("target") and unit.hp("target") <= ui.value("Healing Touch") and unit.player("target") then
                if buff.catForm.exists() or buff.bearForm.exists() then
                    if safeCancelForm(spell.healingTouch, "Healing Touch", freeHeal) then
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
                    if safeCancelForm(spell.healingTouch, "Healing Touch", freeHeal) then
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
        --     and unit.power.mana.percent() < 30
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
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if ui.useCDs() then
        -- Innervate
        if ui.checked("Self-Innervate") and cast.able.innervate()
            and unit.power.mana.percent() < 30
        then
            if cast.innervate("player") then
                ui.debug("Casting Innervate")
                return true
            end
        end
    end
end -- End Action List - Cooldowns

-- Action List - Bear Form
actionList.BearForm = function()
    -- Enrage
    if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage < 10 and unit.hp() > 80 then
        if cast.enrage() then
            ui.debug("Casting Enrage")
            return true
        end
    end
    -- Demoralizing Roar
    if cast.able.demoralizingRoar() and not debuff.demoralizingRoar.exists(units.dyn5)
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
    if cast.able.maul(units.dyn5) and (ui.useST(8,3) or not spell.swipe.known()) then
        if cast.maul(units.dyn5) then
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
    if ui.checked("Tiger's Fury") and spell.tigersFury.known() and energy == 100 and not buff.tigersFury.exists() then
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
            and cast.able.ravage() and isBehind("target", "player")
        then
            if cast.ravage("target") then
                ui.debug("Casting Ravage [Stealth Opener]")
                return true
            end
        end

        -- Shred from behind (Opener 3 or fallback)
        if (opener == 3 or (opener <= 2 and not spell.ravage.known()))
            and cast.able.shred() and isBehind("target", "player") and not unit.facing("target", "player")
        then
            if cast.shred("target") then
                ui.debug("Casting Shred [Stealth Opener]")
                return true
            end
        end

        -- Rake (Opener 4 or fallback)
        if ui.checked("Rake") and (opener == 4 or (opener <= 3 and not spell.shred.known()))
            and cast.able.rake()
        then
            if cast.rake("target") then
                ui.debug("Casting Rake [Stealth Opener]")
                return true
            end
        end

        -- Claw (ultimate fallback)
        if ((opener == 4 and not ui.checked("Rake")) or (opener < 4 and not spell.rake.known())) and cast.able.claw() then
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
        if behindTarget and cast.able.shred() then
            if not unit.facing("target", "player") then
                triedShred = true
                if cast.shred("target") then
                    ui.debug("Casting Shred [Opener]")
                    return true
                end
            end
        end
        -- Claw (fallback)
        if cast.able.claw() and (not spell.shred.known() or not behindTarget) then
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
    -- Ferocious Bite - Finish Him!
    local finish = ferociousBiteFinish(units.dyn5)
    if cast.able.ferociousBite(units.dyn5) and energy >= 35 and finish then
        if cast.ferociousBite(units.dyn5) then
            ui.debug("Casting Ferocious Bite [Finish Him!]")
            return true
        end
    end

    -- Tiger's Fury
    if ui.checked("Tiger's Fury") and cast.able.tigersFury() and buff.catForm.exists() and energy == 100
        and not buff.tigersFury.exists()
    then
        if cast.tigersFury() then
            ui.debug("Casting Tiger's Fury")
            return true
        end
    end

    -- Faerie Fire (Feral)
    if ui.checked("Faerie Fire") and cast.able.faerieFireFeral() and unit.enemy(units.dyn5) and unit.canAttack(units.dyn5)
        and not debuff.faerieFireFeral.exists(units.dyn5)
        and not unit.isElemental(units.dyn5)
        and unit.ttd(units.dyn5) > cd.global.remain()
    then
        if cast.faerieFireFeral() then
            ui.debug("Casting Faerie Fire (Feral)")
            return true
        end
    end

    -- 5 Combo Points - Finishers
    if comboPoints == 5 and not finish then
        -- Ferocious Bite (low energy)
        if cast.able.ferociousBite(units.dyn5) and energy >= 35 and energy < 60 then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite")
                return true
            end
        end
        -- Rip
        if ui.checked("Rip") and cast.able.rip() and unit.ttd(units.dyn5) > 6 and debuff.rip.refresh(units.dyn5) then
            if cast.rip(units.dyn5) then
                ui.debug("Casting Rip")
                return true
            end
        end
    end

    -- Combo Point Builders
    if (comboPoints < 5 or energy >= 60 or freeDPS) and not finish then
        -- Ravage (from Prowl)
        local behindRavage = isBehind(units.dyn5, "player")
        if behindRavage then debugBehind("Ravage behind=true", units.dyn5) end
        if cast.able.ravage() and buff.prowl.exists() and behindRavage then
            if cast.ravage(units.dyn5) then
                ui.debug("Casting Ravage")
                return true
            end
        end
        -- Rake
        if ui.checked("Rake") and cast.able.rake() and debuff.rake.refresh(units.dyn5)
            and (unit.ttd(units.dyn5) <= 3 or not spell.ferociousBite.known())
            and not freeDPS
        then
            if cast.rake(units.dyn5) then
                ui.debug("Casting Rake")
                return true
            end
        end
        -- Shred (from behind)
        local behindDyn5 = isBehind(units.dyn5, "player")
        if behindDyn5 then debugBehind("Shred behind=true", units.dyn5) end

        local triedShred = false
        if behindDyn5 and cast.able.shred() then
            if not unit.facing(units.dyn5, "player") then
                triedShred = true
                if cast.shred(units.dyn5) then
                    ui.debug("Casting Shred")
                    return true
                end
            end
        end
        -- Claw (not behind)
        if cast.able.claw() and (not spell.shred.known() or not behindDyn5) then
            if cast.claw(units.dyn5) then
                ui.debug("Casting Claw")
                return true
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
                and not buff.prowl.exists() and not unit.resting()
            then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl [Precombat]")
                    return true
                end
            end
        end -- End No Stealth
        if unit.valid("target") then
            local formValue = ui.mode.forms
            local thisDistance = unit.distance("target") or 99
            -- Wrath
            if not unit.moving() and not (buff.catForm.exists() or buff.bearForm.exists()) and thisDistance < 30 then
                if cast.able.wrath("target") and (unit.level() < 2 or not cast.last.wrath() or cast.timeSinceLast.wrath() > unit.gcd(true) + 0.5) then
                    if cast.wrath("target") then
                        ui.debug("Casting Wrath [Precombat]")
                        return true
                    end
                end
            end
            if thisDistance < 5 then
                -- Cat Opener (Stealth + Non-Stealth)
                if actionList.CatOpener() then return true end
                -- Bear Form
                if formValue == 3 and buff.bearForm.exists() then
                    -- Enrage
                    if cast.able.enrage() and not unit.deadOrGhost("target") and not buff.enrage.exists() and rage < 10 then
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
                    if cast.able.maul(units.dyn5) and (ui.useST(8,3) or not spell.swipe.known()) then
                        if cast.maul(units.dyn5) then
                            ui.debug("Casting Maul [Precombat]")
                            return true
                        end
                    end
                end
                -- Auto Attack (do not break Prowl)
                if not buff.prowl.exists() and not cast.auto.autoAttack() and unit.valid("target") and not unit.deadOrGhost("target") and unit.distance("target") < 5 then
                    StartAttack()
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
        local formValue = ui.mode.forms
        ------------------------
        --- In Combat - Main ---
        ------------------------
        -- Start Attack (do not break Prowl)
        if not buff.prowl.exists() and unit.exists(units.dyn5) and not cast.auto.autoAttack() and not unit.deadOrGhost("target") then
            StartAttack()
            ui.debug("Casting Auto Attack")
            return true
        end

        -- Wait for swing if in melee range
        if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            local swing = br.swingTimer
            -- ui.debug("Swing Timer: " .. tostring(swing) .. " | Distance: " .. tostring(unit.distance(units.dyn5)))
            if swing and swing > 0 and swing < 0.3 then
                -- ui.debug("Waiting for swing: " .. br.functions.misc:round2(swing) .. "s")
                return true
            end
        end

        -- Call Action List - Cooldowns
        if actionList.Cooldowns() then return true end

        -- Last Form restoration
        if ui.checked("Last Form") and lastForm ~= nil
            and (((unit.moving() and timeMoving() > 2 and (not spell.travelForm.known() or not ui.checked("Travel Form")))
                or (unit.inCombat() or inAggroRange(5)) and ((unit.exists("target") and not unit.friend("target")) or not unit.exists("target")))
            and not lastFormBuff and not (buff.aquaticForm.exists() or buff.travelForm.exists() or inAggroRange(5)))
        then
            if cast.able.catForm() and lastForm == spell.catForm then
                if cast.catForm() then
                    ui.debug("Casting Last Form [Cat]")
                    return true
                end
            end
            if cast.able.bearForm() and (lastForm == spell.bearForm or lastForm == spell.direBearForm) then
                if cast.bearForm() then
                    ui.debug("Casting Last Form [Bear]")
                    return true
                end
            end
        end

        -- Call Action List - Bear Form
        if formValue == 3 and buff.bearForm.exists() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if actionList.BearForm() then return true end
        end

        -- Call Action List - Cat Form
        if formValue == 2 and buff.catForm.exists() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if buff.prowl.exists() and actionList.CatOpener() then return true end
            if actionList.CatForm() then return true end
        end

        -- Call Action List - Caster Form
        if formValue == 1 and not (buff.catForm.exists() or buff.bearForm.exists()) then
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
    comboPoints = br.player.power.comboPoints()
    debuff      = br.player.debuff
    enemies     = br.player.enemies
    energy      = br.player.power.energy()
    rage        = br.player.power.rage()
    module      = br.player.module
    ui          = br.player.ui
    unit        = br.player.unit
    units       = br.player.units
    spell       = br.player.spell
    -- General Locals
    profileStop = profileStop or false
    haltProfile = (unit.inCombat() and profileStop) or ui.pause() or ui.mode.rotation == 4 or unit.id("target") == 156716
    -- Units
    units.get(5)        -- Makes a variable called, units.dyn5
    units.get(40)       -- Makes a variable called, units.dyn40
    units.get(40, true) -- Makes a variable called, units.dyn40AOE
    -- Enemies
    enemies.get(5)      -- Makes a varaible called, enemies.yards5
    enemies.get(20)     -- Makes a varaible called, enemies.yards20
    enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(40)     -- Makes a varaible called, enemies.yards40

    -- Profile Specific Locals
    fbMaxEnergy = energy >= 50

    -- Update Last Form tracking
    updateLastForm()

    -- Omen of Clarity Logic
    local omenSetting = ui.value("Omen of Clarity")
    needsHealing = (ui.checked("Regrowth") and unit.hp() <= ui.value("Regrowth"))
        or (ui.checked("Healing Touch") and unit.hp() <= ui.value("Healing Touch"))
        or (ui.checked("Rejuvenation") and unit.hp() <= ui.value("Rejuvenation"))

    freeDPS = omenSetting ~= 4 and omenSetting ~= 2 and buff.clearcasting.exists()
        and (not needsHealing or omenSetting == 3)

    freeHeal = omenSetting ~= 4 and omenSetting ~= 3 and buff.clearcasting.exists()

    -- No Shapeshift Power check
    noShapeshiftPower = ((not buff.catForm.exists() or (buff.catForm.exists() and energy < ui.value("Energy")))
        and (not buff.bearForm.exists() or (buff.bearForm.exists() and rage < ui.value("Rage"))))
        or not unit.inCombat()

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
local expansion = br.isClassic -- Change to the expansion the profile is for.
if br.loader.rotations[id] == nil then br.loader.rotations[id] = {} end
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

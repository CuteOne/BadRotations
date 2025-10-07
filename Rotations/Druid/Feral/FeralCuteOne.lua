-------------------------------------------------------
-- Author = CuteOne
-- Patch = 11.0.2
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Untested
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
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spells.swipe },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spells.swipe },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.mangle },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.rejuvenation }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.berserk },
        [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.berserk },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.berserk }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spells.barkskin },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spells.barkskin }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.skullBash },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.skullBash }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
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
        --- General Options ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- Death Cat
        br.ui:createCheckbox(section, "Death Cat Mode",
            "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
        -- Fire Cat
        br.ui:createCheckbox(section, "Perma Fire Cat",
            "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic use of Fandrel's Seed Pouch or Burning Seeds.")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5,
            "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Ferocious Bite Execute
        br.ui:createDropdownWithout(section, "Ferocious Bite Execute",
            { "|cffFFFF00Enabled Notify", "|cff00FF00Enabled", "|cffFF0000Disabled" }, 2,
            "Options for using Ferocious Bite when the damage from it will kill the unit.")
        -- Pre-Pull Timer
        br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1,
            "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Auto Shapeshifts
        br.ui:createCheckbox(section, "Auto Shapeshifts",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
        -- Fall Timer
        br.ui:createSpinnerWithout(section, "Fall Timer", 2, 1, 5, 0.25,
            "|cffFFFFFFSet to desired time to wait until shifting to Flight/Cat Form form when falling (in secs).")
        -- Break Crowd Control
        br.ui:createCheckbox(section, "Break Crowd Control",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
        -- Wild Charge
        br.ui:createCheckbox(section, "Wild Charge",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
        -- Mark of the Wild
        br.ui:createDropdown(section, "Mark of the Wild",
            { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFGroup" }, 1,
            "|cffFFFFFFSet how to use Mark of the Wild")
        br.ui:checkSectionState(section)
        ------------------------
        --- Cooldown Options ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Tiger's Fury
        br.ui:createCheckbox(section, "Tiger's Fury")
        -- Berserk / Incarnation: King of the Jungle
        br.ui:createDropdownWithout(section, "Berserk/Incarnation", br.ui.dropOptions.AlwaysCdAoeNever,
            2, "|cffFFFFFFSet when to use Berserk/Incarnation")
        br.ui:checkSectionState(section)
        -------------------------
        --- Defensive Options ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Barkskin
        br.ui:createSpinner(section, "Barkskin", 55, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Natures Vigil
        br.ui:createDropdownWithout(section, "Nature's Vigil",
            { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }, 2,
            "|cffFFFFFFSet when to use Nature's Vigil")
        -- Rebirth
        br.ui:createCheckbox(section, "Rebirth")
        br.ui:createDropdownWithout(section, "Rebirth - Target", { "|cff00FF00Target", "|cffFF0000Mouseover" }, 1,
            "|cffFFFFFFTarget to cast on")
        -- Healing Touch
        br.ui:createSpinner(section, "Healing Touch", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Healing Touch - OoC", { "|cff00FF00Break Form", "|cffFF0000Keep Form" }, 1,
            "|cffFFFFFFSelect if Healing Touch is allowed to break shapeshift to heal out of combat.")
        br.ui:createDropdownWithout(section, "Healing Touch - InC", { "|cff00FF00Immediately", "|cffFF0000Save For DoC" }, 1,
            "|cffFFFFFFSelect if Predatory Swiftness is used when available or saved for Bloodtalons.")
        -- Rejuvenation
        br.ui:createSpinner(section, "Rejuvenation", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Remove Corruption
        br.ui:createCheckbox(section, "Remove Corruption")
        br.ui:createDropdownWithout(section, "Remove Corruption - Target",
            { "|cff00FF00Player", "|cffFFFF00Target", "|cffFF0000Mouseover" }, 1, "|cffFFFFFFTarget to cast on")
        -- Renewal
        br.ui:createSpinner(section, "Renewal", 75, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Revive
        br.ui:createCheckbox(section, "Revive")
        br.ui:createDropdownWithout(section, "Revive - Target", { "|cff00FF00Target", "|cffFF0000Mouseover" }, 1,
            "|cffFFFFFFTarget to cast on")
        -- Soothe
        br.ui:createCheckbox(section, "Soothe")
        -- Survival Instincts
        br.ui:createSpinner(section, "Survival Instincts", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Auto-Heal
        br.ui:createDropdownWithout(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player" }, 1,
            "|cffFFFFFFSelect Target to Auto-Heal")
        br.ui:checkSectionState(section)
        -------------------------
        --- Interrupt Options ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Skull Bash
        br.ui:createCheckbox(section, "Skull Bash")
        -- Mighty Bash
        br.ui:createCheckbox(section, "Mighty Bash")
        -- Maim
        br.ui:createCheckbox(section, "Maim")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        --------------------------
        --- Toggle Key Options ---
        --------------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.ui.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.ui.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.ui.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.ui.dropOptions.Toggle, 6)
        -- Prowl Toggle
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
local module
local spell
local talent
local ui
local unit
local units
local use
local var

-----------------
--- Functions ---
-----------------

-- * Potential Mangle Damage
local function getMangleDamage()
    local calc = (1 * 78 + 1.25 * (select(1, UnitDamage("player")) + select(2, UnitDamage("player"))))*(1 - (24835 * (1 - .04 * 0)) / (24835 * (1 - .04*0) + 46257.5));
    if buff.dreamOfCenarius.exists() then
        return calc;
    else
        return calc*1.3;
    end
end
-- * AutoProwl
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
-- * Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local desc = br._G.C_Spell.GetSpellDescription(spell.ferociousBite.id())
    local damage = 0
    local finishHim = false
    if ui.value("Ferocious Bite Execute") == 3 or comboPoints(thisUnit) == 0 or unit.isDummy(thisUnit) then return false end
    local comboStart = desc:find(" " .. comboPoints(thisUnit) .. " ", 1, true)
    if comboStart ~= nil then
        comboStart = comboStart + 2
        local damageList = desc:sub(comboStart, desc:len())
        comboStart = damageList:find(": ", 1, true) + 2
        damageList = damageList:sub(comboStart, desc:len())
        local comboEnd = damageList:find(" ", 1, true) - 1
        damageList = damageList:sub(1, comboEnd)
        damage = damageList:gsub(",", "")
    end
    local lower = tonumber(string.match(damage, "^(%d+)%-%d+$")) or 0
    finishHim = tonumber(lower) >= unit.health(thisUnit)
    return finishHim
end
-- * Get Mark Unit Option
local getMarkUnitOption = function(option)
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
        thisUnit = "player"
        if #br.engines.healingEngine.friend > 1 then
            for i = 1, #br.engines.healingEngine.friend do
                local nextUnit = br.engines.healingEngine.friend[i].unit
                if buff.markOfTheWild.refresh(nextUnit) and unit.distance(var.markUnit) < 40 then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end
-- *Cast Healing Touch
local function castHealingTouch(healingTouchUnit, tag)
    -- Break Form
    -- if unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(healingTouchUnit, "player") then
    --     unit.cancelForm()
    --     ui.debug("Cancel Form [Healing Touch - "..tag.."]")
    -- end
    -- Lowest Party/Raid or Player
    if unit.form() == 0 or buff.predatorySwiftness.exists() or (buff.naturesSwiftness.exists() and unit.isUnit(healingTouchUnit, "player")) then
        if cast.healingTouch(healingTouchUnit) then
            ui.debug("Casting Healing Touch ["..tag.."] on " .. unit.name(healingTouchUnit))
            return true
        end
    end
end

--------------------
--- Action Lists ---
--------------------

-- * Action List - Extras
actionList.Extras = function()
    -- * Shapeshift Form Management
    if ui.checked("Auto Shapeshifts") then --and br.debug.timer:useTimer("debugShapeshift", 0.25) then
        local fallDist = br.functions.misc:getFallDistance() or 0
        -- Flight Form
        if cast.able.travelForm("player") and not unit.inCombat() and br.functions.action:canFly() and not unit.swimming() and fallDist > 90
            --[[falling > ui.value("Fall Timer")]] and unit.level() >= 24 and not buff.prowl.exists()
        then
            if unit.form() ~= 0 and not cast.last.travelForm() then
                unit.cancelForm()
                ui.debug("Cancel Form [Flying]")
            elseif unit.form() == 0 then
                if cast.travelForm("player") then
                    ui.debug("Casting Travel Form [Flying]")
                    return true
                end
            end
        end
        -- * Aquatic Form
        if cast.able.aquaticForm("player") and (not unit.inCombat() --[[or unit.distance("target") >= 10--]])
            and unit.swimming() and not buff.aquaticForm.exists() and not buff.prowl.exists() and unit.moving()
        then
            if unit.form() ~= 0 and not cast.last.aquaticForm() then
                unit.cancelForm()
                ui.debug("Cancel Form [Swimming]")
            elseif unit.form() == 0 then
                if cast.aquaticForm("player") then
                    ui.debug("Casting Aquatic Form [Swimming]")
                    return true
                end
            end
        end
        -- * Cat Form
        if cast.able.catForm() and not buff.catForm.exists() and not unit.mounted() and not unit.flying() then
            -- Cat Form when not swimming or flying or stag and not in combat
            if unit.moving() and not unit.swimming() and not unit.flying()
                and not buff.travelForm.exists() and not (buff.flightForm.exists() or buff.swiftFlightForm.exists())
            then
                if cast.catForm("player") then
                    ui.debug("Casting Cat Form [No Swim / Travel / Combat]")
                    return true
                end
            end
            -- Cat Form when not in combat and target selected and within 20yrds
            if not unit.inCombat() and unit.valid("target") and ((unit.distance("target") < 30 and not unit.swimming())
                    or (unit.distance("target") < 10 and unit.swimming()))
            then
                if cast.catForm("player") then
                    ui.debug("Casting Cat Form [Target In 20yrds]")
                    return true
                end
            end
            -- Cat Form - Less Fall Damage
            if (not br.functions.action:canFly() or unit.inCombat() or unit.level() < 24 or not unit.outdoors())
                and (not unit.swimming() or (not unit.moving() and unit.swimming() and #enemies.yards5f > 0))
                and fallDist > 90 --falling > ui.value("Fall Timer")
            then
                if cast.catForm("player") then
                    ui.debug("Casting Cat Form [Reduce Fall Damage]")
                    return true
                end
            end
        end
    end -- End Shapeshift Form Management
    -- * Perma Fire Cat
    if ui.checked("Perma Fire Cat") and (use.able.fandralsSeedPouch() or use.able.burningSeeds())
        and not unit.inCombat() and not buff.prowl.exists() and buff.catForm.exists()
    then
        if not buff.burningEssence.exists() then
            -- Fandral's Seed Pouch
            if use.able.fandralsSeedPouch() and equiped.fandralsSeedPouch() then
                if use.fandralsSeedPouch() then
                    ui.debug("Using Fandral's Seed Pouch")
                    return true
                end
                -- Burning Seeds
            elseif use.able.burningSeeds() then
                if use.burningSeeds() then
                    ui.debug("Using Burning Seeds")
                    return true
                end
            end
        end
    end -- End Perma Fire Cat
    -- * Death Cat mode
    if ui.checked("Death Cat Mode") and buff.catForm.exists() then
        if unit.exists("target") and unit.distance(units.dyn8AOE) > 8 then
            unit.clearTarget()
        end
        if autoProwl() then
            -- *Tiger's Fury - Low Energy
            if ui.checked("Tiger's Fury") and cast.able.tigersFury() and energy.deficit() > 60 then
                if cast.tigersFury() then
                    ui.debug("Casting Tiger's Fury [Death Cat Mode]")
                    return true
                end
            end
            -- * Savage Roar - Use Combo Points
            if cast.able.savageRoar() and comboPoints(units.dyn5) >= 5 then
                if cast.savageRoar() then
                    ui.debug("Casting Savage Roar [Death Cat Mode]")
                    return true
                end
            end
            -- * Shred - Single
            if cast.able.shred() and #enemies.yards5f == 1 and not unit.facing(units.dyn5,"player") then
                if cast.shred() then
                    ui.debug("Casting Shred [Death Cat Mode]"); var.swipeSoon = nil; return true
                end
            end
            -- * Swipe - AoE
            if cast.able.swipe("player", "aoe", 1, 8) and #enemies.yards8 > 1 then
                if var.swipeSoon == nil then
                    var.swipeSoon = var.getTime;
                end
                if var.swipeSoon ~= nil and var.swipeSoon < var.getTime - 1 then
                    if cast.swipe("player", "aoe", 1, 8) then
                        ui.debug("Casting Swipe [Death Cat Mode]"); var.swipeSoon = nil; return true
                    end
                end
            end
        end -- End 20yrd Enemy Scan
    end     -- End Death Cat Mode
    -- * Mark of the Wild
    if ui.checked("Mark of the Wild") and not (buff.legacyOfTheEmperor.exists() or buff.blessingOfKings.exists()) then
        var.markUnit = getMarkUnitOption("Mark of the Wild")
        if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit)
            and not (buff.prowl.exists() or buff.shadowmeld.exists()) and not unit.resting() and unit.distance(var.markUnit) < 40
        then
            if cast.markOfTheWild(var.markUnit) then
                ui.debug("Casting Mark of the Wild")
                return true
            end
        end
    end
    -- * Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing")) * 60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
end     -- End Action List - Extras

-- * Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() and not unit.mounted() and not (buff.prowl.exists() or buff.shadowmeld.exists()) and not buff.flightForm.exists() and not buff.prowl.exists() then
        local opValue
        local thisUnit
        -- * Rebirth
        if ui.checked("Rebirth") and unit.inCombat() then
            opValue = ui.value("Rebirth - Target")
            if opValue == 1 then
                thisUnit = "target"
            elseif opValue == 2 then
                thisUnit = "mouseover"
            end
            if cast.able.rebirth(thisUnit, "dead") and unit.deadOrGhost(thisUnit)
                and (unit.friend(thisUnit) or unit.player(thisUnit))
            then
                if unit.form() ~= 0 then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Rebirth]")
                elseif unit.form() == 0 then
                    if cast.rebirth(thisUnit, "dead") then
                        ui.debug("Casting Rebirth on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
        -- * Revive
        if ui.checked("Revive") and not unit.inCombat() then
            opValue = ui.value("Revive - Target")
            if opValue == 1 then
                thisUnit = "target"
            elseif opValue == 2 then
                thisUnit = "mouseover"
            end
            if cast.able.revive(thisUnit, "dead") and unit.deadOrGhost(thisUnit)
                and (unit.friend(thisUnit) and unit.player(thisUnit))
            then
                if cast.revive(thisUnit, "dead") then
                    ui.debug("Casting Revive on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- * Remove Corruption
        if ui.checked("Remove Corruption") then
            opValue = ui.value("Remove Corruption - Target")
            if opValue == 1 then
                thisUnit = "player"
            elseif opValue == 2 then
                thisUnit = "target"
            elseif opValue == 3 then
                thisUnit = "mouseover"
            end
            if cast.able.removeCorruption(thisUnit) and (unit.friend(thisUnit) or unit.player(thisUnit))
                and cast.dispel.removeCorruption(thisUnit)
            then
                if cast.removeCorruption(thisUnit) then
                    ui.debug("Casting Remove Corruption on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- * Soothe
        if ui.checked("Soothe") then
            for i = 1, #enemies.yards40 do
                local sootheUnit = enemies.yards40[i]
                if cast.able.soothe(sootheUnit) and cast.dispel.soothe(sootheUnit) then
                    if cast.soothe(sootheUnit) then
                        ui.debug("Casting Soothe on " .. unit.name(sootheUnit))
                        return true
                    end
                end
            end
        end
        -- * Renewal
        if ui.checked("Renewal") and talent.renewal and unit.inCombat() and cast.able.renewal() and unit.hp() <= ui.value("Renewal") then
            if cast.renewal() then
                ui.debug("Casting Renewal")
                return true
            end
        end
        -- * PowerShift - Breaks Crowd Control (R.I.P Powershifting)
        if ui.checked("Break Crowd Control") and cast.able.catForm() and cast.noControl.catForm() then
            if cast.macro("/cast !Cat Form") then
                ui.debug("Casting Cat Form [Breaking CC]")
                return true
            end
            -- if not cast.noControl.catForm() and var.lastForm ~= 0 then
            --     cast.form(var.lastForm)
            --     var.lastForm = 0
            --     -- if currentForm == var.lastForm or currentForm == 0 then
            --     --     var.lastForm = 0
            --     -- end
            -- elseif cast.noControl.catForm() then
            --     if unit.form() == 0 then
            --         cast.catForm("player")
            --         ui.debug("Casting Cat Form [Breaking CC]")
            --     else
            --         for i = 1, unit.formCount() do
            --             if i == unit.form() then
            --                 var.lastForm = i
            --                 cast.form(i)
            --                 ui.debug("Casting Last Form [Breaking CC]")
            --                 return true
            --             end
            --         end
            --     end
            -- end
        end
        -- * Rejuvenation
        if ui.checked("Rejuvenation") and not (unit.mounted() or unit.flying())
            and (ui.value("Auto Heal") ~= 1 or (ui.value("Auto Heal") == 1 and unit.distance(br.engines.healingEngine.friend[1].unit) < 40))
        then
            local thisHP = unit.hp()
            local rejuvUnit = "player"
            local lowestUnit = unit.lowest(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 then
                thisHP = fhp; rejuvUnit = lowestUnit
            end
            local rejuvPercent = ui.value("Rejuvenation")
            if cast.able.rejuvenation(rejuvUnit) and buff.rejuvenation.refresh(rejuvUnit) and thisHP <= rejuvPercent then
                if unit.form() ~= 0 and unit.level() < 26 then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Rejuvenation]")
                elseif unit.form() == 0 then
                    if cast.rejuvenation(rejuvUnit) then
                        ui.debug("Casting Rejuvenation on " .. unit.name(rejuvUnit))
                        return true
                    end
                end
            end
        end
        -- * Healing Touch
        if ui.checked("Healing Touch") and cast.able.healingTouch("player")
            and not (unit.mounted() or unit.flying()) and not cast.current.healingTouch()
        then
            local thisHP = unit.hp()
            local healingTouchUnit = "player"
            local lowestUnit = unit.lowest(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 and unit.distance(lowestUnit) < 40 then
                thisHP = fhp; healingTouchUnit = lowestUnit
            else
                healingTouchUnit = "player"
            end
            if not unit.inCombat() and thisHP <= ui.value("Healing Touch") and (not unit.moving() or buff.predatorySwiftness.exists()) then
                return castHealingTouch(healingTouchUnit, "OoC")
            elseif unit.inCombat()then
                -- Always Use Predatory Swiftness when available
                if ui.value("Healing Touch - InC") == 1 and (thisHP <= ui.value("Healing Touch")
                    or (buff.predatorySwiftness.exists() and not talent.dreamOfCenarius))
                then
                    return castHealingTouch(healingTouchUnit, "InC Instant")
                end
                -- Hold Predatory Swiftness for Dream of Cenarius unless Health is Below Half of Threshold or Predatory Swiftness is about to Expire.
                if ui.value("Healing Touch - InC") == 2
                    and (thisHP <= ui.value("Healing Touch") and not buff.predatorySwiftness.exists())
                        or (buff.predatorySwiftness.exists() and buff.predatorySwiftness.remain() < unit.gcd(true) * 2)
                then
                    return castHealingTouch(healingTouchUnit, "InC DoC Hold")
                end
                -- Nature's Swiftness - Emergency Heal
                if talent.naturesSwiftness and cast.able.naturesSwiftness() and unit.hp() <= 20
                    and not buff.naturesSwiftness.exists() and not buff.predatorySwiftness.exists()
                then
                    if cast.naturesSwiftness() then
                        ui.debug("Casting Nature's Swiftness [Emergency Heal]")
                        return castHealingTouch(healingTouchUnit, "Emergency Heal")
                    end
                end
            end
        end
        -- -- * Barkskin
        if ui.checked("Barkskin") and unit.inCombat() and cast.able.barkskin() and unit.hp() <= ui.value("Barkskin") then
            if cast.barkskin() then
                ui.debug("Casting Barkskin")
                return true
            end
        end
        -- -- * Survival Instincts
        if ui.checked("Survival Instincts") and unit.inCombat() and cast.able.survivalInstincts()
            and unit.hp() <= ui.value("Survival Instincts")
            and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0
        then
            if cast.survivalInstincts() then
                ui.debug("Casting Survival Instincts")
                return true
            end
        end
    end -- End Defensive Toggle
end     -- End Action List - Defensive

-- * Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true)) then
        local thisUnit
        -- * Skull Bash
        if ui.checked("Skull Bash") then
            for i = 1, #enemies.yards13f do
                thisUnit = enemies.yards13f[i]
                if cast.able.skullBash(thisUnit) and unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.skullBash(thisUnit) then
                        ui.debug("Casting Skull Bash on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
        -- * Mighty Bash
        if ui.checked("Mighty Bash") and talent.mightyBash then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if cast.able.mightyBash(thisUnit) and unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.mightyBash(thisUnit) then
                        ui.debug("Casting Mighty Bash on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
        -- * Maim
        if ui.checked("Maim") then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if cast.able.maim(thisUnit) and unit.interruptable(thisUnit, ui.value("Interrupt At"))
                    and comboPoints(thisUnit) > 0
                then
                    if cast.maim(thisUnit) then
                        ui.debug("Casting Maim on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
    end -- End useInterrupts check
end     -- End Action List - Interrupts

-- * Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            -- * Flask: Flask of Spring Blossoms
            module.FlaskUp()
            -- * Prowl
            -- prowl,if=!buff.prowl.up
            if cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1
            and not buff.prowl.exists() and (not unit.resting() or unit.isDummy("target"))
            and not buff.bsInc.exists()
            then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl [Pre-Combat]")
                    return true
                end
            end
        end -- End No Stealth
        -- * Wild Charge
        if ui.checked("Displacer Beast / Wild Charge") and cast.able.wildCharge("target") and unit.valid("target") then
            if cast.wildCharge("target") then
                ui.debug("Wild Charge on " .. unit.name("target"))
                return true
            end
        end
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- * Virmen's Bite
            if ui.useCDs() and ui.checked("Use Combat Potion") then
                module.CombatPotionUp()
            end
        end -- End Pre-Pull
        -- * Pull
        if unit.valid("target") and unit.exists("target") then
            -- * Savage Roar
            -- savage_roar
            if cast.able.savageRoar("player") and buff.catForm.exists() and not buff.savageRoar.exists() and unit.distance("target") < 20 then
                if cast.savageRoar("player") then
                    ui.debug("Casting Savage Roar [Pre-Combat]")
                    return true
                end
            end
            -- * Action List - Filler
            if unit.distance("target") < 5 then
                if actionList.Filler() then return true end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

-- * Action List - Combat
actionList.Combat = function()
    -- * Cat is 4 fyte!
    if unit.inCombat() and cast.able.catForm("player") and not buff.catForm.exists()
        and #enemies.yards5f > 0 and not unit.moving() and ui.checked("Auto Shapeshifts")
    then
        if cast.catForm("player") then
            ui.debug("Casting Cat Form [Combat]")
            return true
        end
    elseif (unit.inCombat() or (not unit.inCombat() and unit.valid(units.dyn5))) and buff.catForm.exists() and not var.profileStop
        and not ui.checked("Death Cat Mode") and unit.exists(units.dyn5) and cd.global.remain() == 0
    then
        -- * Wild Charge
        if ui.checked("Wild Charge") and cast.able.wildCharge(units.dyn5) then --and unit.valid("target") then
            if cast.wildCharge(units.dyn5) then
                ui.debug("Casting Wild Charge on " .. unit.name(units.dyn5) .. " [Out of Melee]")
                return true
            end
        end
        -- * Ferocious Bite
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if cast.able.ferociousBite(thisUnit) then
                -- execute
                if ferociousBiteFinish(thisUnit) then
                    if cast.ferociousBite(thisUnit) then
                        if ui.value("Ferocious Bite Execute") == 1 then
                            ui.print("Ferocious Bite Finished! " ..
                                unit.name(thisUnit) .. " with " .. br.functions.misc:round2(unit.hp(thisUnit), 0) .. "% health remaining.")
                        else
                            ui.debug("Casting Ferocious Bite on " .. unit.name(thisUnit) .. " [Execute]")
                        end
                        return true
                    end
                end
            end
        end
        -- * Prowl
        -- prowl,if=(buff.bs_inc.down|!in_combat)&!buff.prowl.up
        if cast.able.prowl("player") and buff.catForm.exists() and autoProwl()
        and ui.mode.prowl == 1 and not buff.prowl.exists() and not unit.resting()
        and (((not buff.bsInc.exists() or not unit.inCombat()) and not buff.prowl.exists()))
        then
            if cast.prowl("player") then
                ui.debug("Casting Prowl [Combat]")
                return true
            end
        end
        -- * Call Action List - AoE
        -- swap_action_list,name=aoe,if=active_enemies>=5
        if ui.useAOE(8,5) then
            if actionList.AoE() then return true end
        end
        -- * Auto Attack
        -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
        if cast.able.autoAttack(units.dyn5) and unit.distance(units.dyn5) < 5 and not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            if cast.autoAttack(units.dyn5) then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- * Call Action List - Interrupts
        -- skull_bash_cat
        if actionList.Interrupts() then return true end
        -- * Force of Nature
        -- force_of_nature,if=charges=3|(buff.rune_of_reorigination.react&buff.rune_of_reorigination.remains<1)|(buff.vicious.react&buff.vicious.remains<1)|target.time_to_die<20
        if cast.able.forceOfNature(units.dyn40) and charges.forceOfNature.count() == 3
            or (buff.runeOfReorigination.exists() and buff.runeOfReorigination.remains() < 1)
            or (buff.vicious.exists() and buff.vicious.remains() < 1)
            or unit.ttd(units.dyn40) < 20
        then
            if cast.forceOfNature(units.dyn40) then
                ui.debug("Casting Force of Nature on " .. unit.name(units.dyn40) .. " [Combat]")
                return true
            end
        end
        -- * Racial
        -- blood_fury,if=buff.tigers_fury.up
        -- berserking,if=buff.tigers_fury.up
        -- arcane_torrent,if=buff.tigers_fury.up
        if ui.checked("Use Racial") and buff.tigersFury.exists() then
            if unit.race() == "Orc" or unit.race() == "Troll" or unit.race() == "BloodElf" then
                if cast.racial() then
                    ui.debug("Casting Racial [Combat]")
                    return true
                end
            end
        end
        -- * Ravage
        -- ravage,if=buff.stealthed.up
        if cast.able.ravage(units.dyn5) and (buff.prowl.exists() or buff.shadowmeld.exists()) and not unit.facing(units.dyn5, "player") then
            if cast.ravage(units.dyn5) then
                ui.debug("Casting Ravage [Combat]")
                return true
            end
        end
        -- * Ferocious Bite
        -- # Keep Rip from falling off during execute range.
        -- ferocious_bite,if=dot.rip.ticking&dot.rip.remains<=3&target.health.pct<=25
        if cast.able.ferociousBite(units.dyn5) and comboPoints(units.dyn5) > 0
            and debuff.rip.exists(units.dyn5) and debuff.rip.remains(units.dyn5) <= 3 and unit.hp(units.dyn5) <= 25
        then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite - Maintain Rip [Combat]"); return true
            end
        end
        -- * Faerie Fire
        -- faerie_fire,if=debuff.weakened_armor.stack<3
        if cast.able.faerieFire(units.dyn5) and not (buff.prowl.exists() or buff.shadowmeld.exists()) and debuff.weakenedArmor.stack(units.dyn5) < 3 then
            if cast.faerieFire(units.dyn5) then
                ui.debug("Casting Faerie Fire [Combat]")
                return true
            end
        end
        -- * Healing Touch
        -- # Proc Dream of Cenarius at 4+ CP or when PS is about to expire.
        -- healing_touch,if=talent.dream_of_cenarius.enabled&buff.predatory_swiftness.up&buff.dream_of_cenarius.down&(buff.predatory_swiftness.remains<1.5|combo_points>=4)
        if cast.able.healingTouch() and buff.predatorySwiftness.exists()
            and not buff.dreamOfCenarius.exists() and (buff.predatorySwiftness.remains() < 1.5 or comboPoints(units.dyn5) >= 4)
        then
            if cast.healingTouch("player") then
                ui.debug("Casting Healing Touch [Combat]")
                return true
            end
        end
        -- * Savage Roar
        -- savage_roar,if=buff.savage_roar.down
        if cast.able.savageRoar() and not buff.savageRoar.exists() then
            if cast.savageRoar() then
                ui.debug("Casting Savage Roar - No Exist [Combat]")
                return true
            end
        end
        -- * Tiger's Fury
        -- tigers_fury,if=energy<=35&!buff.omen_of_clarity.react
        if ui.checked("Tiger's Fury") and cast.able.tigersFury() and energy.deficit() > 35 and not buff.clearcasting.exists() then
            if cast.tigersFury() then
                ui.debug("Casting Tiger's Fury [Combat]")
                return true
            end
        end
        -- * Berserk
        -- berserk,if=buff.tigers_fury.up|(target.time_to_die<18&cooldown.tigers_fury.remains>6)
        if ui.useCDs() and ui.alwaysCdNever("Berserk/Incarnation") and cast.able.berserk()
            and (buff.tigersFury.exists() or (unit.ttd(units.dyn5) < 18 and cd.tigersFury.remains() > 6))
        then
            if cast.berserk() then
                ui.debug("Casting Berserk [Combat]")
                return true
            end
        end
        -- * Action List - Cooldown
        if actionList.Cooldown() then return true end
        -- * Use Item Slot - Hands
        -- use_item,slot=hands,if=buff.tigers_fury.up
        -- TODO

        -- * Thrash
        -- thrash_cat,if=buff.omen_of_clarity.react&dot.thrash_cat.remains<3&target.time_to_die>=6
        if cast.able.thrash("player", "aoe", 1, 8) and buff.clearcasting.exists() and debuff.thrash.remains(units.dyn5) < 3 and unit.ttd(units.dyn5) >= 6 then
            if cast.thrash("player", "aoe", 1, 8) then
                ui.debug("Casting Thrash [Combat]")
                return true
            end
        end
        -- * Ferocious Bite
        -- ferocious_bite,if=target.time_to_die<=1&combo_points>=3
        if cast.able.ferociousBite(units.dyn5)
            and ((unit.ttd(units.dyn5) <= 1 or ferociousBiteFinish(units.dyn5)) and comboPoints(units.dyn5) >= 3)
        then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite - TTD <= 1 [Combat]")
                return true
            end
        end
        -- * Savage Roar
        -- savage_roar,if=buff.savage_roar.remains<=3&combo_points>0&target.health.pct<25
        if cast.able.savageRoar() and buff.savageRoar.remains() <= 3 and comboPoints(units.dyn5) > 0 and unit.hp(units.dyn5) < 25 then
            if cast.savageRoar() then
                ui.debug("Casting Savage Roar - Low Target HP [Combat]")
                return true
            end
        end
        -- * Potion - Virmen's Bite
        -- # Potion near or during execute range when Rune is up and we have 5 CP.
        -- virmens_bite_potion,if=(combo_points>=5&(target.time_to_die*(target.health.pct-25)%target.health.pct)<15&buff.rune_of_reorigination.up)|target.time_to_die<=40
        if ui.useCDs() and ui.checked("Use Combat Potion")
            and ((comboPoints(units.dyn5) >= 5 and (unit.ttd(units.dyn5) * (unit.hp(units.dyn5) - 25) / unit.hp(units.dyn5)) < 15
                and buff.runeOfReorigination.exists()) or unit.ttd(units.dyn5) <= 40)
        then
            module.CombatPotionUp()
        end

        -- * Rip
        -- # Overwrite Rip if it's at least 15% stronger than the current.
        -- rip,if=combo_points>=5&action.rip.tick_damage%dot.rip.tick_dmg>=1.15&target.time_to_die>30
        -- NOTE: SimC '%' here means new_tick / current_tick (strength increase), not Lua modulus.
        if comboPoints(units.dyn5) >= 5 and debuff.rip.applied(units.dyn5) and debuff.rip.applied(units.dyn5) > 0 -- ensure an existing Rip to compare
            and (debuff.rip.calc() / debuff.rip.applied(units.dyn5)) >= 1.15 and unit.ttd(units.dyn5) > 30
        then
            if cast.rip(units.dyn5) then
                ui.debug("Casting Rip - Overwrite [Combat]")
                return true
            end
        end
        -- # Use 4 or more CP to apply Rip if Rune of Reorigination is about to expire and it's at least close to the current rip in damage.
        -- rip,if=combo_points>=4&action.rip.tick_damage%dot.rip.tick_dmg>=0.95&target.time_to_die>30&buff.rune_of_reorigination.up&buff.rune_of_reorigination.remains<=1.5
        if comboPoints(units.dyn5) >= 4 and (debuff.rip.calc() / debuff.rip.applied(units.dyn5)) >= 0.95 and unit.ttd(units.dyn5) > 30
            and buff.runeOfReorigination.exists() and buff.runeOfReorigination.remains() <= 1.5
        then
            if cast.rip(units.dyn5) then
                ui.debug("Casting Rip - Rune of Reorigination [Combat]")
                return true
            end
        end
        -- * Pool Resource
        -- # Pool 50 energy for Ferocious Bite.
        -- pool_resource,if=combo_points>=5&target.health.pct<=25&dot.rip.ticking&!(energy>=50|(buff.berserk.up&energy>=25))
        if comboPoints(units.dyn5) >= 5 and unit.hp(units.dyn5) <= 25 and debuff.rip.exists(units.dyn5)
            and not (energy() >= 50 or (buff.berserk.exists() and energy() >= 25))
        then
            -- ui.debug("Pooling 50 energy for Ferocious Bite [Combat]")
            return true
        end
        -- * Ferocious Bite
        -- ferocious_bite,if=combo_points>=5&dot.rip.ticking&target.health.pct<=25
        if cast.able.ferociousBite(units.dyn5) and comboPoints(units.dyn5) >= 5
            and debuff.rip.exists(units.dyn5) and unit.hp(units.dyn5) <= 25
        then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite - Low Target HP [Combat]")
                return true
            end
        end
        -- * Rip
        -- rip,if=combo_points>=5&target.time_to_die>=6&dot.rip.remains<2&(buff.berserk.up|dot.rip.remains+1.9<=cooldown.tigers_fury.remains)
        if cast.able.rip(units.dyn5) and comboPoints(units.dyn5) >= 5 and unit.ttd(units.dyn5) >= 6 and debuff.rip.remains(units.dyn5) < 2
            and (buff.berserk.exists() or debuff.rip.remains(units.dyn5) + 1.9 <= cd.tigersFury.remains())
        then
            if cast.rip(units.dyn5) then
                ui.debug("Casting Rip [Combat]")
                return true
            end
        end
        -- * Savage Roar
        -- savage_roar,if=buff.savage_roar.remains<=3&combo_points>0&buff.savage_roar.remains+2>dot.rip.remains
        if cast.able.savageRoar() and buff.savageRoar.remains() <= 3 and comboPoints(units.dyn5) > 0
            and buff.savageRoar.remains() + 2 > debuff.rip.remains(units.dyn5)
        then
            if cast.savageRoar() then
                ui.debug("Casting Savage Roar - Remain <= 3 [Combat]")
                return true
            end
        end
        -- savage_roar,if=buff.savage_roar.remains<=6&combo_points>=5&buff.savage_roar.remains+2<=dot.rip.remains&dot.rip.ticking
        if cast.able.savageRoar() and buff.savageRoar.remains() <= 6 and comboPoints(units.dyn5) >= 5
            and buff.savageRoar.remains() + 2 <= debuff.rip.remains(units.dyn5) and debuff.rip.exists(units.dyn5)
        then
            if cast.savageRoar() then
                ui.debug("Casting Savage Roar - Remain <= 6 [Combat]")
                return true
            end
        end
        -- # Savage Roar if we're about to energy cap and it will keep our Rip from expiring around the same time as Savage Roar.
        -- savage_roar,if=buff.savage_roar.remains<=12&combo_points>=5&energy.time_to_max<=1&buff.savage_roar.remains<=dot.rip.remains+6&dot.rip.ticking
        if cast.able.savageRoar() and buff.savageRoar.remains() <= 12 and comboPoints(units.dyn5) >= 5
            and energy.ttm() <= 1 and buff.savageRoar.remains() <= debuff.rip.remains(units.dyn5) + 6
            and debuff.rip.exists(units.dyn5)
        then
            if cast.savageRoar() then
                ui.debug("Casting Savage Roar - Energy Cap [Combat]")
                return true
            end
        end
        -- * Rake
        -- # Refresh Rake as Re-Origination is about to end if Rake has <9 seconds left.
        -- rake,if=buff.rune_of_reorigination.up&dot.rake.remains<9&buff.rune_of_reorigination.remains<=1.5
        if cast.able.rake(units.dyn5) and buff.runeOfReorigination.exists() and debuff.rake.remains(units.dyn5) < 9
            and buff.runeOfReorigination.remains() <= 1.5
        then
            if cast.rake(units.dyn5) then
                ui.debug("Casting Rake - Rune of Reorigination [Combat]")
                return true
            end
        end
        -- # Rake if we can apply a stronger Rake or if it's about to fall off and clipping the last tick won't waste too much damage.
        -- rake,cycle_targets=1,if=target.time_to_die-dot.rake.remains>3&(action.rake.tick_damage>dot.rake.tick_dmg|(dot.rake.remains<3&action.rake.tick_damage%dot.rake.tick_dmg>=0.75))
        if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                local applied = debuff.rake.applied(thisUnit) > 0 and debuff.rake.applied(thisUnit) or 1
                if cast.able.rake(thisUnit) and (unit.ttd(thisUnit) - debuff.rake.remains(thisUnit) > 3)
                    and (debuff.rake.calc(thisUnit) > applied
                        or (debuff.rake.remains(thisUnit) < 3
                            and (debuff.rake.calc(thisUnit) / applied) >= 0.75))
                then
                    if cast.rake(thisUnit) then
                        ui.debug("Casting Rake on " .. unit.name(thisUnit) .. " [Combat]")
                        return true
                    end
                end
            end
        end
        -- * Thrash
        -- thrash_cat,if=target.time_to_die>=6&dot.thrash_cat.remains<3&(dot.rip.remains>=8&buff.savage_roar.remains>=12|buff.berserk.up|combo_points>=5)&dot.rip.ticking
        if unit.ttd(units.dyn8AOE) >= 6 and debuff.thrash.remains(units.dyn8AOE) < 3
            and ((debuff.rip.remains(units.dyn8AOE) >= 8 and buff.savageRoar.remains() >= 12)
                or buff.berserk.exists() or comboPoints(units.dyn8AOE) >= 5) and debuff.rip.exists(units.dyn8AOE)
        then
            -- Pool Energy for Thrash
            -- # Pool energy for and maintain Thrash.
            -- pool_resource,for_next=1
            if energy() < 50 then return true end
            if cast.able.thrash("player", "aoe", 1, 8) then
                if cast.thrash("player", "aoe", 1, 8) then
                    ui.debug("Casting Thrash - Refresh [Combat]")
                    return true
                end
            end
        end
        -- # Pool energy for and clip Thrash if Rune of Re-Origination is expiring.
        -- pool_resource,for_next=1
        -- thrash_cat,if=target.time_to_die>=6&dot.thrash_cat.remains<9&buff.rune_of_reorigination.up&buff.rune_of_reorigination.remains<=1.5&dot.rip.ticking
        if unit.ttd(units.dyn8AOE) >= 6 and debuff.thrash.remains(units.dyn8AOE) < 9
            and buff.runeOfReorigination.exists() and buff.runeOfReorigination.remains() <= 1.5
            and debuff.rip.exists(units.dyn8AOE)
        then
            if energy() < 50 then return true end
            if cast.able.thrash("player", "aoe", 1, 8) then
                if cast.thrash("player", "aoe", 1, 8) then
                    ui.debug("Casting Thrash - Rune of Reorigination [Combat]")
                    return true
                end
            end
        end
        -- * Pool Energy for Ferocious Bite
        -- # Pool to near-full energy before casting Ferocious Bite.
        -- pool_resource,if=combo_points>=5&!(energy.time_to_max<=1|(buff.berserk.up&energy>=25))&dot.rip.ticking
        if comboPoints(units.dyn5) >= 5
            and not (energy.ttm() <= 1 or (buff.berserk.exists() and energy() >= 25))
            and debuff.rip.exists(units.dyn5)
        then
            -- ui.debug("Pooling to near-full energy for Ferocious Bite [Combat]")
            return true
        end
        -- * Ferocious Bite
        -- # Ferocious Bite if we reached near-full energy without spending our CP on something else.
        -- ferocious_bite,if=combo_points>=5&dot.rip.ticking
        if cast.able.ferociousBite(units.dyn5) and comboPoints(units.dyn5) >= 5 and debuff.rip.exists(units.dyn5) then
            if cast.ferociousBite(units.dyn5) then
                ui.debug("Casting Ferocious Bite - Max Combo [Combat]")
                return true
            end
        end
        -- * Call Action List - Filler
        -- # Conditions under which we should execute a CP generator.
        -- run_action_list,name=filler,if=buff.omen_of_clarity.react
        if buff.clearcasting.exists() then
            if actionList.Filler("Clearcasting") then return true end
        end
        -- run_action_list,name=filler,if=buff.feral_fury.react
        if buff.feralFury.exists() then
            if actionList.Filler("Feral Fury") then return true end
        end
        -- run_action_list,name=filler,if=(combo_points<5&dot.rip.remains<3.0)|(combo_points=0&buff.savage_roar.remains<2)
        if (comboPoints(units.dyn5) < 5 and debuff.rip.remains(units.dyn5) < 3) or (comboPoints(units.dyn5) == 0 and buff.savageRoar.remains() < 2) then
            if actionList.Filler("Rip/Savage Roar") then return true end
        end
        -- run_action_list,name=filler,if=target.time_to_die<=8.5
        if unit.ttd(units.dyn5) <= 8.5 and comboPoints(units.dyn5) < 5 and not ferociousBiteFinish(units.dyn5) then
            if actionList.Filler("TTD") then return true end
        end
        -- run_action_list,name=filler,if=buff.tigers_fury.up|buff.berserk.up
        if (buff.tigersFury.exists() or buff.berserk.exists()) then
            if actionList.Filler("Tiger/Berserk") then return true end
        end
        -- run_action_list,name=filler,if=cooldown.tigers_fury.remains<=3
        if cd.tigersFury.remains() <= 3 then
            if actionList.Filler("Tiger Soon") then return true end
        end
        -- run_action_list,name=filler,if=energy.time_to_max<=1.0
        if energy.ttm() <= 1.0 then
            if actionList.Filler("Energy Max") then return true end
        end
    end
end -- End Action List - Combat

-- * Action List - AoE
actionList.AoE = function()
    -- * Call Action List
    -- swap_action_list,name=default,if=active_enemies<5
    if ui.useST(8, 5) then
        if actionList.Combat() then return true end
    end
    -- * Auto Attack
    -- auto_attack
    if cast.able.autoAttack(units.dyn5) and unit.distance(units.dyn5) < 5 then
        if cast.autoAttack(units.dyn5) then
            ui.debug("Casting Auto Attack [AoE]")
            return true
        end
    end
    -- * Faerie Fire
    -- faerie_fire,cycle_targets=1,if=debuff.weakened_armor.stack<3
    if not buff.prowl.exists() and not buff.shadowmeld.exists() then
        for i = 1, #enemies.yards35 do
            local thisUnit = enemies.yards35[i]
            if cast.able.faerieFire(thisUnit) then
                if debuff.weakenedArmor.stack(thisUnit) < 3 then
                    if cast.faerieFire(thisUnit) then
                        ui.debug("Casting Faerie Fire on " .. unit.name(thisUnit) .. " [AoE]")
                        return true
                    end
                end
            end
        end
    end
    -- * Savage Roar
    -- savage_roar,if=buff.savage_roar.down|(buff.savage_roar.remains<3&combo_points>0)
    if cast.able.savageRoar() then
        if not buff.savageRoar.exists() or (buff.savageRoar.remains() < 3 and comboPoints(units.dyn5) > 0) then
            if cast.savageRoar() then
                ui.debug("Casting Savage Roar - No Exist / Expire Soon [AoE]")
                return true
            end
        end
    end
    -- * Use Item Slot - Hands
    -- use_item,slot=hands,if=buff.tigers_fury.up
    -- TODO

    -- * Racial
    -- blood_fury,if=buff.tigers_fury.up
    -- berserking,if=buff.tigers_fury.up
    -- arcane_torrent,if=buff.tigers_fury.up
    if ui.checked("Use Racial") and buff.tigersFury.exists() then
        if unit.race() == "Orc" or unit.race() == "Troll" or unit.race() == "BloodElf" then
            if cast.racial() then
                ui.debug("Casting Racial [Combat]")
                return true
            end
        end
    end
    -- * Tiger's Fury
    -- tigers_fury,if=energy<=35&!buff.omen_of_clarity.react
    if ui.checked("Tiger's Fury") and cast.able.tigersFury() then
        if energy() <= 35 and not buff.clearcasting.exists() then
            if cast.tigersFury() then
                ui.debug("Casting Tiger's Fury [AoE]")
                return true
            end
        end
    end
    -- * Berserk
    -- berserk,if=buff.tigers_fury.up
    if ui.useCDs() and ui.alwaysCdNever() and cast.able.berserk() then
        if buff.tigersFury.exists() then
            if cast.berserk() then
                ui.debug("Casting Berserk [AoE]")
                return true
            end
        end
    end
    -- * Action List - Cooldown
    if actionList.Cooldown() then return true end
    -- * Pool Resource
    -- pool_resource,for_next=1
    -- * Thrash
    -- thrash_cat,if=buff.rune_of_reorigination.up
    if buff.runeOfReorigination.exists() then
        if energy() < 50 and not buff.clearcasting.exists() then
            return true
        end
        if cast.able.thrash("player", "aoe", 1, 8) then
            if cast.thrash("player", "aoe", 1, 8) then
                ui.debug("Casting Thrash - Rune of Reorigination [AoE]")
                return true
            end
        end
    end
    -- * Pool Resource
    -- pool_resource,wait=0.1,for_next=1
    -- * Thrash
    -- thrash_cat,if=dot.thrash_cat.remains<3|(buff.tigers_fury.up&dot.thrash_cat.remains<9)
    if debuff.thrash.remains(units.dyn8AOE) < 3 or (buff.tigersFury.exists() and debuff.thrash.remains(units.dyn8AOE) < 9) then
        if energy() < 50 and not buff.clearcasting.exists() then
            return true
        end
        if cast.able.thrash("player", "aoe", 1, 8) then
            if cast.thrash("player", "aoe", 1, 8) then
                ui.debug("Casting Thrash [AoE]")
                return true
            end
        end
    end
    -- * Savage Roar
    -- savage_roar,if=buff.savage_roar.remains<9&combo_points>=5
    if cast.able.savageRoar() then
        if buff.savageRoar.remains() < 9 and comboPoints(units.dyn5) >= 5 then
            if cast.savageRoar() then
                ui.debug("Casting Savage Roar - Max Combo [AoE]")
                return true
            end
        end
    end
    -- * Rip
    -- rip,if=combo_points>=5
    if cast.able.rip(units.dyn5) then
        if comboPoints(units.dyn5) >= 5 then
            if cast.rip(units.dyn5) then
                ui.debug("Casting Rip [AoE]")
            end
        end
    end
    -- * Rake
    -- rake,cycle_targets=1,if=active_enemies<8&dot.rake.remains<3&target.time_to_die>=15
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if cast.able.rake(thisUnit) then
            if #enemies.yards5f < 8 and debuff.rake.remains(thisUnit) < 3 and unit.ttd(thisUnit) >= 15 then
                if cast.rake(thisUnit) then
                    ui.debug("Casting Rake on " .. unit.name(thisUnit) .. " [AoE]")
                    return true
                end
            end
        end
    end
    -- * Swipe
    -- swipe_cat,if=buff.savage_roar.remains<=5
    if cast.able.swipe("player", "aoe", 1, 8) and buff.savageRoar.remains() <= 5 then
        if cast.swipe("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe - Savage Roar [AoE]")
            return true
        end
    end
    -- swipe_cat,if=buff.tigers_fury.up|buff.berserk.up
    if cast.able.swipe("player", "aoe", 1, 8) and (buff.tigersFury.exists() or buff.berserk.exists()) then
        if cast.swipe("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe - Tiger's Fury/Berserk [AoE]")
            return true
        end
    end
    -- swipe_cat,if=cooldown.tigers_fury.remains<3
    if cast.able.swipe("player", "aoe", 1, 8) and cd.tigersFury.remains() < 3 then
        if cast.swipe("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe - Tiger's Fury [AoE]")
            return true
        end
    end
    -- swipe_cat,if=buff.omen_of_clarity.react
    if cast.able.swipe("player", "aoe", 1, 8) and buff.clearcasting.exists() then
        if cast.swipe("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe - Clearcasting [AoE]")
            return true
        end
    end
    -- swipe_cat,if=energy.time_to_max<=1
    if cast.able.swipe("player", "aoe", 1, 8) and energy.ttm() <= 1 then
        if cast.swipe("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe - Energy Time to Max [AoE]")
            return true
        end
    end
end -- End Action List - AoE

-- * Action List - Filler
actionList.Filler = function(reason)
    reason = reason and " - " .. reason or ""
    -- * Ravage
    -- ravage
    if cast.able.ravage() and (buff.prowl.exists() or buff.shadowmeld.exists()) and not unit.facing(units.dyn5, "player") then
        if cast.ravage(units.dyn5) then
            ui.debug("Casting Ravage [Filler" .. reason .. "]")
            return true
        end
    end
    -- * Rake
    -- # Rake if it hits harder than Mangle and we won't apply a weaker bleed to the target.
    -- rake,if=target.time_to_die-dot.rake.remains>3&action.rake.tick_damage*(dot.rake.ticks_remain+1)-dot.rake.tick_dmg*dot.rake.ticks_remain>action.mangle_cat.hit_damage
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if cast.able.rake(thisUnit) then
            if unit.ttd(thisUnit) - debuff.rake.remains(thisUnit) > 3
                and ((debuff.rake.calc() * (debuff.rake.ticksRemain(thisUnit) + 1)
                    - debuff.rake.applied(thisUnit) * debuff.rake.ticksRemain(thisUnit)
                    > getMangleDamage()) or (not unit.inCombat() and unit.facing(thisUnit, "player")))
            then
                if cast.rake(thisUnit) then
                    ui.debug("Casting Rake on " .. unit.name(thisUnit) .. " [Filler" .. reason .. "]")
                    return true
                end
            end
        end
    end
    -- * Shred
    -- shred,if=(buff.omen_of_clarity.react|buff.berserk.up|energy.regen>=15)&buff.king_of_the_jungle.down
    if cast.able.shred(units.dyn5) and not unit.facing(units.dyn5,"player")
        and (not (buff.prowl.exists() or buff.shadowmeld.exists()) or unit.level() < 54)
        and (buff.clearcasting.exists() or buff.berserk.exists() or energy.regen() >= 15)
        and not buff.incarnation.exists()
    then
        if buff.clearcasting.exists() then
            if cast.shred(units.dyn5) then
                ui.debug("Casting Shred (Clearcasting) on " .. unit.name(units.dyn5) .. " [Filler" .. reason .. "]")
                return true
            end
        end
        if buff.berserk.exists() then
            if cast.shred(units.dyn5) then
                ui.debug("Casting Shred (Berserk) on " .. unit.name(units.dyn5) .. " [Filler" .. reason .. "]")
                return true
            end
        end
        if energy.regen() >= 15 then
            if cast.shred(units.dyn5) then
                ui.debug("Casting Shred (Hi Regen) on " .. unit.name(units.dyn5) .. " [Filler" .. reason .. "]")
                return true
            end
        end
        -- if cast.shred(units.dyn5) then
        --     ui.debug("Casting Shred on " .. unit.name(units.dyn5) .. " [Filler" .. reason .. "]")
        --     return true
        -- end
    end
    -- * Mangle
    -- mangle_cat,if=buff.king_of_the_jungle.down
    if cast.able.mangle(units.dyn5) and (not (buff.prowl.exists() or buff.shadowmeld.exists()) or unit.level() < 54)
        -- and (unit.facing(units.dyn5, "player") or (not unit.facing(units.dyn5,"player")
        --     and not (buff.clearcasting.exists() or buff.berserk.exists() or energy.regen() >= 15)))
        and not buff.incarnation.exists()
    then
        if cast.mangle(units.dyn5) then
            ui.debug("Casting Mangle on " .. unit.name(units.dyn5) .. " [Filler" .. reason .. "]")
            return true
        end
    end
end -- End Action List - Filler

-- * Action List - Cooldown
actionList.Cooldown = function()
    if unit.distance(units.dyn5) < 5 and not buff.prowl.exists()then
        -- * Module- Basic Trinkets
        -- use_items
        module.BasicTrinkets()
    end -- End useCooldowns check
end     -- End Action List - Cooldowns

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- * Initialize
    if not br.player.initialized then
        -- BR API
        br.player.actionList    = actionList
        buff                    = br.player.buff
        cast                    = br.player.cast
        cd                      = br.player.cd
        charges                 = br.player.charges
        comboPoints             = br.player.power.comboPoints
        debuff                  = br.player.debuff
        enemies                 = br.player.enemies
        energy                  = br.player.power.energy
        equiped                 = br.player.equiped
        module                  = br.player.module
        spell                   = br.player.spell
        talent                  = br.player.talent
        ui                      = br.player.ui
        unit                    = br.player.unit
        units                   = br.player.units
        use                     = br.player.use
        var                     = br.player.variables

        -- General Variables - Init
        var.getTime             = ui.time()
        var.lastForm            = 0
        var.leftCombat          = var.getTime
        var.lootDelay           = 0
        var.minCount            = 3
        var.noDoT               = false
        var.profileStop         = false

        br.player.initialized   = true
    end

    -- Throttle scans / overlays to improve FPS
    if var.lastEnemyScan == nil then var.lastEnemyScan = 0 end
    if var.enemyScanInterval == nil then var.enemyScanInterval = 0.25 end -- seconds; raise this to reduce CPU
    local now = ui.time()
    if (now - var.lastEnemyScan) >= var.enemyScanInterval then
        var.lastEnemyScan = now

        -- * Get Best Unit for Range
        -- units.get(range, aoe)
        units.get(40)
        units.get(8, true)
        units.get(5)

        -- * Get List of Enemies for Range
        -- enemies.get(range, from unit, no combat, variable)
        enemies.get(40)                        -- makes enemies.yards40
        enemies.get(35)                        -- makes enemies.yards35
        enemies.get(20, "player", true)        -- makes enemies.yards20nc
        enemies.get(20)
        enemies.get(13, "player", false, true) -- makes enemies.yards13f
        enemies.get(8)                         -- makes enemies.yards8
        enemies.get(5, "player", false, true)  -- makes enemies.yards5f

        var.lastEnemyScan = now
        -- Debug overlay (commented out / throttled). Enable only if needed:

    end

    -- * General Vars
    var.multidot  = ui.mode.cleave == 1 and ui.mode.rotation < 3
    var.getTime   = br._G.GetTime()
    var.lootDelay = ui.checked("Auto Loot") and ui.value("Auto Loot") or 0
    var.minCount  = ui.useCDs() and 1 or 3
    if not unit.inCombat() and not unit.exists("target") then
        if var.profileStop then var.profileStop = false end
        var.leftCombat = var.getTime
    end
    -- Add buff.bsInc.exists()
    buff.bsInc      = buff.bsInc or {}
    if not buff.bsInc.exists then
        buff.bsInc.exists = function()
            return buff.berserk.exists() or buff.incarnation.exists()
        end
    end
    -- Add buff.bsInc.remain()
    if not buff.bsInc.remains then
        buff.bsInc.remains = function()
            return math.max(buff.berserk.remain(), buff.incarnation.remain())
        end
    end
    -- Add cd.bsInc.remains()
    cd.bsInc = cd.bsInc or {}
    if not cd.bsInc.remains then
        cd.bsInc.remains = function()
            return math.max(cd.berserk.remains(), cd.incarnation.remains())
        end
    end
    -- Add cd.bsInc.duration()
    cd.bsInc = cd.bsInc or {}
    if not cd.bsInc.duration then
        cd.bsInc.duration = function()
            return math.max(cd.berserk.duration(), cd.incarnation.duration())
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- * Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() then
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
        --- Don't run if rotation mode is off --
        if ui.mode.rotation ~= 4 then
            ------------------------------
            --- Out of Combat Rotation ---
            ------------------------------
            if actionList.PreCombat() then return true end
            --------------------------
            --- In Combat Rotation ---
            --------------------------
            if actionList.Combat() then return true end
        end
    end --End Rotation Logic
end -- End runRotation

local id = 103
br.loader.rotations[id] = br.loader.rotations[id] or {}
br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

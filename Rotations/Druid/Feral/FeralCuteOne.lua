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
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spells.shred },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spells.regrowth }
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
    -- Cleave Button
    local CleaveModes = {
        [1] = { mode = "On", value = 1, overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spells.rake },
        [2] = { mode = "Off", value = 2, overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spells.rake }
    };
    br.ui:createToggle(CleaveModes, "Cleave", 5, 0)
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
            "|cffFFFFFFSet to desired time to wait until shifting to buff.flightForm.exists() form when falling (in secs).")
        -- Break Crowd Control
        br.ui:createCheckbox(section, "Break Crowd Control",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
        -- Wild Charge
        br.ui:createCheckbox(section, "Wild Charge",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
        -- Brutal Slash Targets
        br.ui:createSpinnerWithout(section, "Brutal Slash Targets", 3, 1, 10, 1,
            "|cffFFFFFFSet to desired targets to use Brutal Slash on. Min: 1 / Max: 10 / Interval: 1")
        -- Primal Wrath Usage
        br.ui:createDropdownWithout(section, "Primal Wrath Usage", { "|cffFFFF00Always", "|cff00FF00Refresh Only" })
        -- Mark of the Wild
        br.ui:createDropdown(section, "Mark of the Wild",
            { "|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFGroup" }, 1,
            "|cffFFFFFFSet how to use Mark of the Wild")
        br.ui:checkSectionState(section)
        -----------------------------
        --- SimC Specific Options ---
        -----------------------------
        section = br.ui:createSection(br.ui.window.profile, "SimC")
        -- Regrowth-SimC
        br.ui:createCheckbox(section, "Regrowth-SimC",
            "|cffFFFFFFSends regrowth and renewal casts. |cffD60000THIS IS A DPS LOSS EVEN WITHOUT TOXIC THORN")
        -- Easy Swipe
        br.ui:createCheckbox(section, "Easy Swipe",
            "|cffFFFFFFAvoids using shred in AoE situations. |cffD60000THIS IS A DPS LOSS")
        br.ui:checkSectionState(section)
        ------------------------
        --- Cooldown Options ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Basic Trinkets
        br.player.module.BasicTrinkets(nil, section)
        -- Convoke The Spirits
        br.ui:createDropdownWithout(section, "Convoke The Spirits",
            { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }, 2,
            "|cffFFFFFFSet when to use Convoke The Spirits")
        -- Tiger's Fury
        br.ui:createCheckbox(section, "Tiger's Fury")
        -- Berserk / Incarnation: King of the Jungle
        br.ui:createDropdownWithout(section, "Berserk/Incarnation",
            { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }, 2,
            "|cffFFFFFFSet when to use Berserk/Incarnation")
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
        -- Regrowth
        br.ui:createSpinner(section, "Regrowth", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Regrowth - OoC", { "|cff00FF00Break Form", "|cffFF0000Keep Form" }, 1,
            "|cffFFFFFFSelect if Regrowth is allowed to break shapeshift to heal out of combat.")
        br.ui:createDropdownWithout(section, "Regrowth - InC", { "|cff00FF00Immediately", "|cffFF0000Save For BT" }, 1,
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
        -- Swiftmend
        br.ui:createSpinner(section, "Swiftmend", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Wild Growth
        br.ui:createSpinner(section, "Wild Growth", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
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
        -- Cleave Toggle
        br.ui:createDropdownWithout(section, "Cleave Mode", br.ui.dropOptions.Toggle, 6)
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
local heroTree
local items
local module
local race
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
-- Multi-Dot HP Limit Set
local function canDoT(thisUnit)
    local unitHealthMax = unit.healthMax(thisUnit)
    if var.noDoT or not unit.exists(thisUnit) then return false end
    if not unit.isBoss(thisUnit) and unit.facing("player", thisUnit)
        and (var.multidot or (unit.isUnit(thisUnit, units.dyn5) and not var.multidot))
        and not unit.charmed(thisUnit)
    then
        return ((unitHealthMax > unit.healthMax("player") * 3)
            or (unit.health(thisUnit) < unitHealthMax and unit.ttd(thisUnit) > 10))
    end
    local maxHealth = 0
    for i = 1, #enemies.yards5f do
        local thisMaxHealth = unit.healthMax(enemies.yards5f[i])
        if thisMaxHealth > maxHealth then
            maxHealth = thisMaxHealth
        end
    end
    return unitHealthMax > maxHealth / 10
end
-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local desc = br._G.C_Spell.GetSpellDescription(spell.ferociousBite.id())
    local damage = 0
    local finishHim = false
    if ui.value("Ferocious Bite Execute") ~= 3 and comboPoints() > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" " .. comboPoints() .. " ", 1, true)
        if comboStart ~= nil then
            comboStart = comboStart + 2
            local damageList = desc:sub(comboStart, desc:len())
            comboStart = damageList:find(": ", 1, true) + 2
            damageList = damageList:sub(comboStart, desc:len())
            local comboEnd = damageList:find(" ", 1, true) - 1
            damageList = damageList:sub(1, comboEnd)
            damage = damageList:gsub(",", "")
        end
        finishHim = tonumber(damage) >= unit.health(thisUnit)
    end
    return finishHim
end
-- Primal Wrath Usable
local function usePrimalWrath()
    if talent.primalWrath and cast.able.primalWrath("player", "aoe", 1, 8)
        and ui.useAOE(8, 2)
        and not unit.isExplosive("target")
    then
        if ui.value("Primal Wrath Usage") == 1 and ui.useAOE(8, 3) then return true end
        local ripCount = 0
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if debuff.rip.remain(thisUnit) <= 4 and (unit.ttd(thisUnit) > 8 or unit.isDummy(thisUnit)) then
                ripCount = ripCount + 1
            end
        end
        return ripCount > 1
    end
    return false
end
-- Get Mark Unit Option
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

--------------------
--- Action Lists ---
--------------------

-- Action List - Extras
actionList.Extras = function()
    -- Shapeshift Form Management
    if ui.checked("Auto Shapeshifts") then --and br.timer:useTimer("debugShapeshift", 0.25) then
        -- Flight Form
        if cast.able.travelForm("player") and not unit.inCombat() and unit.canFly() and not unit.swimming() and unit.fallDist() > 90
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
        -- Aquatic Form
        if cast.able.travelForm("player") and (not unit.inCombat() --[[or unit.distance("target") >= 10--]])
            and unit.swimming() and not buff.travelForm.exists() and not buff.prowl.exists() and unit.moving()
        then
            if unit.form() ~= 0 and not cast.last.travelForm() then
                unit.cancelForm()
                ui.debug("Cancel Form [Swimming]")
            elseif unit.form() == 0 then
                if cast.travelForm("player") then
                    ui.debug("Casting Travel From [Swimming]")
                    return true
                end
            end
        end
        -- Cat Form
        if cast.able.catForm() and not buff.catForm.exists() and not unit.mounted() and not unit.flying() then
            -- Cat Form when not swimming or flying or stag and not in combat
            if unit.moving() and not unit.swimming() and not unit.flying() and not buff.travelForm.exists() and not buff.soulshape.exists() then
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
            if (not unit.canFly() or unit.inCombat() or unit.level() < 24 or not unit.outdoors())
                and (not unit.swimming() or (not unit.moving() and unit.swimming() and #enemies.yards5f > 0))
                and unit.fallDist() > 90 --falling > ui.value("Fall Timer")
            then
                if cast.catForm("player") then
                    ui.debug("Casting Cat Form [Reduce Fall Damage]")
                    return true
                end
            end
        end
    end -- End Shapeshift Form Management
    -- Perma Fire Cat
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
    -- Death Cat mode
    if ui.checked("Death Cat Mode") and buff.catForm.exists() then
        if unit.exists("target") and unit.distance(units.dyn8AOE) > 8 then
            unit.clearTarget()
        end
        if autoProwl() then
            -- Tiger's Fury - Low Energy
            if ui.checked("Tiger's Fury") and cast.able.tigersFury() and energy.deficit() > 60 then
                if cast.tigersFury() then
                    ui.debug("Casting Tiger's Fury [Death Cat Mode]")
                    return true
                end
            end
            -- -- Savage Roar - Use Combo Points
            -- if cast.able.savageRoar() and comboPoints() >= 5 then
            --     if cast.savageRoar() then
            --         ui.debug("Casting Savage Roar [Death Cat Mode]")
            --         return true
            --     end
            -- end
            -- Shred - Single
            if cast.able.shred() and #enemies.yards5f == 1 then
                if cast.shred() then
                    ui.debug("Casting Shred [Death Cat Mode]"); var.swipeSoon = nil; return true
                end
            end
            -- Swipe - AoE
            if cast.able.swipeCat() and #enemies.yards8 > 1 then
                if var.swipeSoon == nil then
                    var.swipeSoon = var.getTime;
                end
                if var.swipeSoon ~= nil and var.swipeSoon < var.getTime - 1 then
                    if cast.swipeCat("player", "aoe", 1, 8) then
                        ui.debug("Casting Swipe [Death Cat Mode]"); var.swipeSoon = nil; return true
                    end
                end
            end
        end -- End 20yrd Enemy Scan
    end     -- End Death Cat Mode
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") then
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
    end -- End Dummy Test
end     -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() and not unit.mounted() and not (buff.prowl.exists() or buff.shadowmeld.exists()) and not buff.flightForm.exists() and not buff.prowl.exists() then
        local opValue
        local thisUnit
        -- Rebirth
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
        -- Revive
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
        -- Remove Corruption
        if ui.checked("Remove Corruption") then
            opValue = ui.value("Remove Corruption - Target")
            if opValue == 1 then
                thisUnit = "player"
            elseif opValue == 2 then
                thisUnit = "target"
            elseif opValue == 3 then
                thisUnit = "mouseover"
            end
            if cast.able.removeCorruption() and (unit.friend(thisUnit) or unit.player(thisUnit))
                and cast.dispel.removeCorruption(thisUnit)
            then
                if cast.removeCorruption(thisUnit) then
                    ui.debug("Casting Remove Corruption on " .. unit.name(thisUnit))
                    return true
                end
            end
        end
        -- Soothe
        if ui.checked("Soothe") and cast.able.soothe() then
            for i = 1, #enemies.yards40 do
                local sootheUnit = enemies.yards40[i]
                if cast.dispel.soothe(sootheUnit) then
                    if cast.soothe(sootheUnit) then
                        ui.debug("Casting Soothe on " .. unit.name(sootheUnit))
                        return true
                    end
                end
            end
        end
        -- Renewal
        if ui.checked("Renewal") and unit.inCombat() and cast.able.renewal() and unit.hp() <= ui.value("Renewal") then
            if cast.renewal() then
                ui.debug("Casting Renewal")
                return true
            end
        end
        -- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
        if ui.checked("Break Crowd Control") and cast.able.catForm() then
            if not cast.noControl.catForm() and var.lastForm ~= 0 then
                cast.form(var.lastForm)
                var.lastForm = 0
                -- if currentForm == var.lastForm or currentForm == 0 then
                --     var.lastForm = 0
                -- end
            elseif cast.noControl.catForm() then
                if unit.form() == 0 then
                    cast.catForm("player")
                    ui.debug("Casting Cat Form [Breaking CC]")
                else
                    for i = 1, unit.formCount() do
                        if i == unit.form() then
                            var.lastForm = i
                            cast.form(i)
                            ui.debug("Casting Last Form [Breaking CC]")
                            return true
                        end
                    end
                end
            end
        end
        -- Resto Affinity
        if talent.restorationAffinity and not (unit.mounted() or unit.flying())
            and (ui.value("Auto Heal") ~= 1 or (ui.value("Auto Heal") == 1
                and unit.distance(br.engines.healingEngine.friend[1].unit) < 40))
        then
            local thisHP = unit.hp()
            local thisUnit = "player"
            local lowestUnit = unit.lowest(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 then
                thisHP = fhp; thisUnit = lowestUnit
            end
            -- Swiftmend
            local swiftPercent = ui.value("Swiftmend")
            if ui.checked("Swiftmend") and cast.able.swiftmend()
                and ((not unit.inCombat() and thisHP <= swiftPercent) or (unit.inCombat() and thisHP <= swiftPercent / 2))
            then
                if unit.form() ~= 0 then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Swiftmend]")
                elseif unit.form() == 0 then
                    if cast.swiftmend(thisUnit) then
                        ui.debug("Casting Swiftmend on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
            -- Rejuvenation
            local rejuvPercent = ui.value("Rejuvenation")
            if ui.checked("Rejuvenation") and cast.able.rejuvenation() and buff.rejuvenation.refresh(thisUnit)
                and ((not unit.inCombat() and thisHP <= rejuvPercent) or (unit.inCombat() and thisHP <= rejuvPercent / 2))
            then
                if unit.form() ~= 0 then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Rejuvenation]")
                elseif unit.form() == 0 then
                    if cast.rejuvenation(thisUnit) then
                        ui.debug("Casting Rejuvenation on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
            -- Wild Growth
            if ui.checked("Wild Growth") and not unit.inCombat() and cast.able.wildGrowth() then
                for i = 1, #br.engines.healingEngine.friend do
                    local wildGrowthUnit = br.engines.healingEngine.friend[i].unit
                    local lowHealthCandidates = br.getUnitsToHealAround(wildGrowthUnit, 30, ui.value("Wild Growth"),
                        #br.engines.healingEngine.friend)
                    if #lowHealthCandidates > 1 and not unit.moving() then
                        if unit.form() ~= 0 then
                            unit.cancelForm()
                            ui.debug("Cancel Form [Wild Growth]")
                        elseif unit.form() == 0 then
                            if cast.wildGrowth(br.engines.healingEngine.friend[i].unit) then
                                ui.debug("Casting Wild Growth on " .. unit.name(wildGrowthUnit))
                                return true
                            end
                        end
                    end
                end
            end
        end
        -- Regrowth
        if ui.checked("Regrowth") and cast.able.regrowth("player") and not (unit.mounted() or unit.flying()) and not cast.current.regrowth() then
            local thisHP = unit.hp()
            local regrowthUnit = "player"
            local lowestUnit = unit.lowest(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 and unit.distance(lowestUnit) < 40 then
                thisHP = fhp; regrowthUnit = lowestUnit
            else
                regrowthUnit = "player"
            end
            if not unit.inCombat() and thisHP <= ui.value("Regrowth") and (not unit.moving() or buff.predatorySwiftness.exists()) then
                -- Break Form
                if ui.value("Regrowth - OoC") == 1 and unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(regrowthUnit, "player") then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Regrowth - OoC Break]")
                end
                -- Lowest Party/Raid or Player
                if unit.form() == 0 or buff.predatorySwiftness.exists() then
                    if cast.regrowth(regrowthUnit) then
                        ui.debug("Casting Regrowth [OoC] on " .. unit.name(regrowthUnit))
                        return true
                    end
                end
            elseif unit.inCombat() and (buff.predatorySwiftness.exists() or unit.level() < 49) then
                -- Always Use Predatory Swiftness when available
                if ui.value("Regrowth - InC") == 1 or not talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= ui.value("Regrowth") and unit.level() >= 49) or (unit.level() < 49 and thisHP <= ui.value("Regrowth") / 2) then
                        if unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(regrowthUnit, "player") then
                            unit.cancelForm()
                            ui.debug("Cancel Form [Regrowth - InC Break]")
                        elseif unit.form() == 0 or buff.predatorySwiftness.exists() then
                            if cast.regrowth(regrowthUnit) then
                                ui.debug("Casting Regrowth [IC Instant] on " .. unit.name(regrowthUnit))
                                return true
                            end
                        end
                    end
                end
                -- Hold Predatory Swiftness for Bloodtalons unless Health is Below Half of Threshold or Predatory Swiftness is about to Expire.
                if ui.value("Regrowth - InC") == 2 and talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= ui.value("Regrowth") / 2) or buff.predatorySwiftness.remain() < unit.gcd(true) * 2 then
                        if unit.form() ~= 0 and not buff.predatorySwiftness.exists() then
                            unit.cancelForm()
                            ui.debug("Cancel Form [Regrowth - InC Break]")
                        elseif unit.form() == 0 or buff.predatorySwiftness.exists() then
                            if cast.regrowth(regrowthUnit) then
                                ui.debug("Casting Regrowth [IC BT Hold] on " .. unit.name(regrowthUnit))
                                return true
                            end
                        end
                    end
                end
            end
        end
        -- Barkskin
        if ui.checked("Barkskin") and unit.inCombat() and cast.able.barkskin() and unit.hp() <= ui.value("Barkskin") then
            if cast.barkskin() then
                ui.debug("Casting Barkskin")
                return true
            end
        end
        -- Survival Instincts
        if ui.checked("Survival Instincts") and unit.inCombat() and cast.able.survivalInstincts()
            and unit.hp() <= ui.value("Survival Instincts")
            and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0
        then
            if cast.survivalInstincts() then
                ui.debug("Casting Survival Instincts")
                return true
            end
        end
        -- -- Fleshcraft
        -- if cast.able.fleshcraft() and unit.exists("target") and unit.deadOrGhost("target") and not unit.moving() and unit.ooCombatTime() > 2 then
        --     if cast.fleshcraft("player") then
        --         ui.debug("Casting Fleshcraft")
        --         return true
        --     end
        -- end
    end -- End Defensive Toggle
end     -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() and ui.delay("Interrupts", unit.gcd(true)) then
        local thisUnit
        -- Skull Bash
        if ui.checked("Skull Bash") and cast.able.skullBash() then
            for i = 1, #enemies.yards13f do
                thisUnit = enemies.yards13f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.skullBash(thisUnit) then
                        ui.debug("Casting Skull Bash on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
        -- Mighty Bash
        if ui.checked("Mighty Bash") and cast.able.mightyBash() then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                    if cast.mightyBash(thisUnit) then
                        ui.debug("Casting Mighty Bash on " .. unit.name(thisUnit))
                        return true
                    end
                end
            end
        end
        -- Maim
        if ui.checked("Maim") and cast.able.maim() then
            for i = 1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit, ui.value("Interrupt At"))
                    and comboPoints() > 0 and not buff.fieryRedMaimers.exists()
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

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            if (ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer")) or unit.isDummy("target") then
                -- Heart of the Wild
                -- heart_of_the_wild
                if cast.able.heartOfTheWild() then --and unit.valid("target") and unit.exists("target") and unit.distance("target") < 5 then
                    if cast.heartOfTheWild() then
                        ui.debug("Casting Heart Of The Wild [Pre-Combat]")
                        return true
                    end
                end
            end
            -- Prowl
            -- prowl,if=!buff.prowl.up
            if cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1
                and not buff.prowl.exists() and (not unit.resting() or unit.isDummy("target"))
                and not buff.bsInc.exists() -- and var.getTime - var.leftCombat > lootDelay
            then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl [Pre-Combat]")
                    return true
                end
            end
        end -- End No Stealth
        -- Tiger's Fury: pre-pull when using custom timers with immediate TF window
        -- tigers_fury,if=variable.use_custom_timers&variable.nextTFTimer=0
        if ui.checked("Tiger's Fury") and var.useCustomTimers and var.nextTFTimer == 0
            and cast.able.tigersFury()
        then
            if cast.tigersFury() then
                ui.debug("Casting Tiger's Fury [Pre-Combat - Custom Timer]")
                return true
            end
        end
        -- Wild Charge
        if ui.checked("Displacer Beast / Wild Charge") and cast.able.wildCharge("target") and unit.valid("target") then
            if cast.wildCharge("target") then
                ui.debug("Wild Charge on " .. unit.name("target"))
                return true
            end
        end
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
        end -- End Pre-Pull
        -- Pull
        if unit.valid("target") and unit.exists("target") and unit.distance("target") < 5 then
            -- Rake (Stealth)
            -- rake,if=buff.prowl.up|buff.shadowmeld.up
            if cast.able.rake("target") and (buff.prowl.exists("player") or buff.shadowmeld.exists("player")) then
                if cast.rake("target") then
                    ui.debug("Casting Rake [Pre-Combat]")
                    return true
                end
            end
            -- Auto Attack
            -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
            if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
                if cast.able.autoAttack("target") and not cast.auto.autoAttack() then
                    if cast.autoAttack("target") then
                        ui.debug("Casting Auto Attack [Pre-Combat]")
                        return true
                    end
                end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

-- Action List - Custom Timers
-- actions.custom_timers: manages static TF/Berserk timing windows
actionList.CustomTimers = function()
    -- Latch currentTFTimer/currentBSTimer when time passes the scheduled timer
    -- variable,name=currentTFTimer,default=-10,op=set,if=time>variable.nextTFTimer,value=variable.nextTFTimer
    if var.getTime > var.nextTFTimer and var.nextTFTimer > 0 then
        var.currentTFTimer = var.nextTFTimer
    end
    -- variable,name=currentBSTimer,default=-10,op=set,if=time>variable.nextBSTimer,value=variable.nextBSTimer
    if var.getTime > var.nextBSTimer and var.nextBSTimer > 0 then
        var.currentBSTimer = var.nextBSTimer
    end
    -- Advance nextTFTimer through the scheduled sequence
    local tfTimers = { 30, 60, 90, 120, 151, 181, 211, 241, 271, 301, 332, 362, 392, 422, 452, 482, 513, 543 }
    for i = 1, #tfTimers do
        if var.getTime > var.nextTFTimer and tfTimers[i] > var.nextTFTimer then
            var.nextTFTimer = tfTimers[i]
            break
        end
    end
    -- Advance nextBSTimer through the scheduled sequence
    local bsTimers = { 121, 242, 363, 483 }
    for i = 1, #bsTimers do
        if var.getTime > var.nextBSTimer and bsTimers[i] > var.nextBSTimer then
            var.nextBSTimer = bsTimers[i]
            break
        end
    end
    -- Disable custom timers once all scheduled windows are exhausted
    -- variable,name=use_custom_timers,op=set,if=time>variable.nextTFTimer&time>variable.nextBSTimer,value=0
    if var.getTime > var.nextTFTimer and var.getTime > var.nextBSTimer then
        var.useCustomTimers = false
    end
    -- tfNow: true during [currentTFTimer, currentTFTimer+4)
    -- variable,name=tfNow,default=0,op=set,value=...*(currentTFTimer+4>time&time>=currentTFTimer)
    var.tfNow = var.useCustomTimers
        and var.currentTFTimer > 0
        and var.getTime >= var.currentTFTimer
        and var.getTime < var.currentTFTimer + 4
    -- zerkNow: true during [currentBSTimer, currentBSTimer+4)
    -- variable,name=zerkNow,default=0,op=set,value=...*(currentBSTimer+4>time&time>=currentBSTimer)
    var.zerkNow = var.useCustomTimers
        and var.currentBSTimer > 0
        and var.getTime >= var.currentBSTimer
        and var.getTime < var.currentBSTimer + 4
end -- End Action List - Custom Timers

-- Action List - Combat
actionList.Combat = function()
    -- Cat is 4 fyte!
    if unit.inCombat() and cast.able.catForm("player") and not buff.catForm.exists() and not buff.moonkinForm.exists()
        and #enemies.yards5f > 0 and not unit.moving() and ui.checked("Auto Shapeshifts") and not talent.fluidForm
    then
        if cast.catForm("player") then
            ui.debug("Casting Cat Form [Combat]")
            return true
        end
    elseif (unit.inCombat() or (not unit.inCombat() and unit.valid(units.dyn5))) and (buff.catForm.exists() or buff.moonkinForm.exists()) and not var.profileStop
        and not ui.checked("Death Cat Mode") and unit.exists(units.dyn5) and cd.global.remain() == 0
    then
        -- Wild Charge
        if ui.checked("Wild Charge") and cast.able.wildCharge(units.dyn5) then --and unit.valid("target") then
            if cast.wildCharge(units.dyn5) then
                ui.debug("Casting Wild Charge on " .. unit.name(units.dyn5) .. " [Out of Melee]")
                return true
            end
        end
        -- Ferocious Bite
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if cast.able.ferociousBite(thisUnit) and unit.distance(units.dyn5) < 5 then
                -- execute
                if ferociousBiteFinish(thisUnit) and not usePrimalWrath() then
                    if ui.value("Ferocious Bite Execute") == 1 and ferociousBiteFinish(thisUnit) then
                        ui.print("Ferocious Bite Finished! " ..
                            unit.name(thisUnit) .. " with " .. br.round2(unit.hp(thisUnit), 0) .. "% health remaining.")
                    end
                    if cast.ferociousBite(thisUnit) then
                        ui.debug("Casting Ferocious Bite on " .. unit.name(thisUnit) .. " [Execute]"); return true
                    end
                end
            end
        end
        -- Call Action List - Interrupts
        if actionList.Interrupts() then return true end
        -- Prowl
        -- prowl,if=buff.bs_inc.down&!buff.prowl.up&!buff.shadowmeld.up
        if cast.able.prowl("player") and buff.catForm.exists()
            and ui.mode.prowl == 1 and not buff.prowl.exists() and not unit.resting()
            and not buff.bsInc.exists() and not buff.shadowmeld.exists() and not cast.last.prowl()
        then
            if cast.prowl("player") then
                ui.debug("Casting Prowl [Combat]")
                return true
            end
        end
        -- Call Action List - Custom Timers
        -- call_action_list,name=custom_timers,if=variable.use_custom_timers
        if var.useCustomTimers then
            if actionList.CustomTimers() then return true end
        end
        -- Variable - tfRemains
        -- variable,name=tfRemains,op=setif,condition=variable.use_custom_timers,value=(!variable.tfNow*(variable.nextTFTimer-time)),value_else=cooldown.tigers_fury.remains
        if var.useCustomTimers then
            var.tfRemains = var.tfNow and 0 or (var.nextTFTimer - var.getTime)
        else
            var.tfRemains = cd.tigersFury.remains()
        end
        -- Auto Attack
        -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
        if cast.able.autoAttack(units.dyn5) and unit.distance(units.dyn5) < 5
            and not buff.prowl.exists() and not buff.shadowmeld.exists()
            and not cast.auto.autoAttack()
        then
            if cast.autoAttack(units.dyn5) then
                ui.debug("Casting Auto Attack [Combat]")
                return true
            end
        end
        -- Action List - Variables (per-frame computed vars)
        actionList.Variables()
        -- Tiger's Fury
        --- tigers fury on cooldown, in aoe patchwerk we can hold ~2s for frantic frenzy as needed. Like frantic frenzy, holding can sometimes be a gain in dr/ds, but the conditions are unclear. Addendum: Seems't've been related to holding Berserk, attempt to check holding tigers fury at your own risk.
        -- tigers_fury,if=(cooldown.bs_inc.remains<=1|cooldown.bs_inc.remains>10)&(cooldown.frantic_frenzy.remains<buff.tigers_fury.duration-1.5|cooldown.frantic_frenzy.remains>22|!talent.frantic_frenzy|spell_targets=1|fight_style.dungeonroute|fight_style.dungeonslice)&!variable.use_custom_timers|variable.tfNow
        if ui.checked("Tiger's Fury") and cast.able.tigersFury()
            and (((cd.bsInc.remains() <= 1 or cd.bsInc.remains() > 10)
                    and (cd.franticFrenzy.remains() < buff.tigersFury.duration() - 1.5 or cd.franticFrenzy.remains() > 22
                        or not talent.franticFrenzy or ui.useST(8, 1) or ui.fightStyle.dungeonRoute() or ui.fightStyle.dungeonSlice())
                    and not var.useCustomTimers)
                or var.tfNow)
        then
            if cast.tigersFury() then
                ui.debug("Casting Tigers Fury [Combat - Frenzy]")
                return true
            end
        end
        -- Rake
        -- rake,if=buff.prowl.up|buff.shadowmeld.up
        if cast.able.rake() and ((buff.shadowmeld.exists() or buff.prowl.exists())) then
            if cast.rake() then
                ui.debug("Casting Rake [Combat]")
                return true
            end
        end
        -- Chomp
        -- chomp,if=buff.chomp_enabler.up
        if cast.able.chomp() and buff.chompEnabler.exists() then
            if cast.chomp() then
                ui.debug("Casting Chomp [Combat]")
                return true
            end
        end
        -- Call Action List - Cooldown
        -- call_action_list,name=cooldown
        if actionList.Cooldown() then return true end
        -- Ferocious Bite
        -- ferocious_bite,if=buff.apex_predators_craving.up
        if cast.able.ferociousBite() and buff.apexPredatorsCraving.exists() then
            if cast.ferociousBite() then
                ui.debug("Casting Ferocious Bite [Combat - Apex]")
                return true
            end
        end
        -- Action List - Finisher
        -- call_action_list,name=finisher,if=spell_targets=1
        if ui.useST(8, 2, "player") then
            if actionList.Finisher() then return true end
        end
        -- Action List - Aoe Finisher
        -- call_action_list,name=aoe_finisher,if=spell_targets>=2
        if ui.useAOE(8, 2, "player") then
            if actionList.AoeFinisher() then return true end
        end
        -- Action List - Builder
        -- call_action_list,name=builder,if=spell_targets=1&combo_points<=4
        if ui.useST(8, 2, "player") and comboPoints() < 5 then
            if actionList.Builder() then return true end
        end
        -- Action List - Aoe Builder
        -- call_action_list,name=aoe_builder,if=spell_targets>1&combo_points<=4
        if ui.useAOE(8, 2, "player") and comboPoints() < 5 then
            if actionList.AoeBuilder() then return true end
        end
        -- Regrowth
        -- regrowth,if=buff.predatory_swiftness.up&variable.regrowth
        if cast.able.regrowth() and buff.predatorySwiftness.exists() and var.regrowth then
            if cast.regrowth() then
                ui.debug("Casting Regrowth")
                return true
            end
        end
    end
end -- End Action List - Combat

-- Action List - AoEBuilder
actionList.AoeBuilder = function()
    -- Rake: priority spread for DCR and Wildstalker hero tree
    -- rake,target_if=refreshable,if=(talent.doubleclawed_rake&(!talent.lunar_inspiration|!talent.panthers_guile|active_dot.rake<5))|hero_tree.wildstalker&(active_dot.rake<2+!talent.panthers_guile+talent.lunar_inspiration)
    if cast.able.rake(var.rakeRefreshUnit)
        and ((talent.doubleclawedRake
                and (not talent.lunarInspiration or not talent.panthersGuile or var.activeDotRake < 5))
            or (heroTree.wildstalker and var.activeDotRake < 2
                + (not talent.panthersGuile and 1 or 0)
                + (talent.lunarInspiration and 1 or 0)))
    then
        if cast.rake(var.rakeRefreshUnit) then
            ui.debug("Casting Rake - DCR/Wildstalker Priority [Aoe Builder]")
            return true
        end
    end
    -- Moonfire Cat: spread to all refreshable targets
    -- moonfire_cat,target_if=refreshable
    if talent.lunarInspiration and cast.able.moonfireCat(var.moonfireRefreshUnit) then
        if cast.moonfireCat(var.moonfireRefreshUnit) then
            ui.debug("Casting Moonfire Cat - Spread [Aoe Builder]")
            return true
        end
    end
    -- Swipe Cat: DotC during Berserk, or Clearcasting at 3-6 targets
    -- swipe_cat,if=hero_tree.druid_of_the_claw&buff.bs_inc.up|buff.clearcasting.react&spell_targets>2&(hero_tree.druid_of_the_claw|spell_targets<7)
    if cast.able.swipeCat("player", "aoe", 1, 8)
        and ((heroTree.druidOfTheClaw and buff.bsInc.exists())
            or (buff.clearcasting.exists() and #enemies.yards8 > 2
                and (heroTree.druidOfTheClaw or #enemies.yards8 < 7)))
    then
        if cast.swipeCat("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe Cat - DotC Berserk / Clearcast [Aoe Builder]")
            return true
        end
    end
    -- Swipe Cat: Sudden Ambush at 5+ targets (7+ for Wildstalker)
    -- swipe_cat,if=buff.sudden_ambush.up&spell_targets.swipe_cat>=5+(2*hero_tree.wildstalker)
    if cast.able.swipeCat("player", "aoe", 1, 8) and buff.suddenAmbush.exists()
        and #enemies.yards8 >= 5 + (heroTree.wildstalker and 2 or 0)
    then
        if cast.swipeCat("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe Cat - Sudden Ambush High Targets [Aoe Builder]")
            return true
        end
    end
    -- Rake: spread on refreshable targets up to dotcRakeThreshold (or always for Wildstalker)
    -- rake,target_if=refreshable,if=hero_tree.wildstalker|spell_targets.swipe_cat<=variable.dotc_rake_threshold
    if cast.able.rake(var.rakeRefreshUnit)
        and (heroTree.wildstalker or #enemies.yards8 <= var.dotcRakeThreshold)
    then
        if cast.rake(var.rakeRefreshUnit) then
            ui.debug("Casting Rake - Spread Below Threshold [Aoe Builder]")
            return true
        end
    end
    -- Rake: upgrade weaker snapshot at exactly 2 targets
    -- rake,target_if=min:pmultiplier,if=persistent_multiplier>pmultiplier&spell_targets=2
    if cast.able.rake(var.lowRakeMultiUnit) and #enemies.yards5f == 2
        and debuff.rake.calc() > debuff.rake.applied(var.lowRakeMultiUnit)
    then
        if cast.rake(var.lowRakeMultiUnit) then
            ui.debug("Casting Rake - Upgrade Snapshot 2T [Aoe Builder]")
            return true
        end
    end
    -- Shred: at 0-1 CP on 2 targets with Panther's Guile
    -- shred,if=combo_points<=1&spell_targets=2&talent.panthers_guile
    if cast.able.shred() and comboPoints() <= 1 and #enemies.yards5f == 2 and talent.panthersGuile then
        if cast.shred() then
            ui.debug("Casting Shred - Panther's Guile 2T [Aoe Builder]")
            return true
        end
    end
    -- Swipe Cat: fallback builder
    -- swipe_cat,if=combo_points>1|spell_targets>2|!talent.panthers_guile
    if cast.able.swipeCat("player", "aoe", 1, 8)
        and (comboPoints() > 1 or #enemies.yards8 > 2 or not talent.panthersGuile)
    then
        if cast.swipeCat("player", "aoe", 1, 8) then
            ui.debug("Casting Swipe Cat - Fallback [Aoe Builder]")
            return true
        end
    end
end -- End Action List - AoE Builder

-- Action List - Builder
actionList.Builder = function()
    -- Prowl: stealth-empower rake when snapshot is weak or refreshable
    -- prowl,if=!buff.shadowmeld.up&(action.rake.pmultiplier<1.6|dot.rake.refreshable)
    if cast.able.prowl("player") and buff.catForm.exists() and ui.mode.prowl == 1
        and not buff.prowl.exists() and not buff.shadowmeld.exists()
        and (debuff.rake.pmultiplier(units.dyn5) < 1.6 or debuff.rake.refresh(units.dyn5))
    then
        if cast.prowl("player") then
            ui.debug("Casting Prowl [Builder]")
            return true
        end
    end
    -- Shadowmeld: same condition for Night Elf
    -- shadowmeld,if=!buff.prowl.up&(action.rake.pmultiplier<1.6|dot.rake.refreshable)
    if ui.checked("Racial") and race == "NightElf" and cast.able.racial() and ui.useCDs()
        and not unit.moving() and unit.distance(units.dyn5) < 5
        and not buff.prowl.exists()
        and (debuff.rake.pmultiplier(units.dyn5) < 1.6 or debuff.rake.refresh(units.dyn5))
    then
        if cast.racial() then
            ui.debug("Casting Shadowmeld [Builder]")
            return true
        end
    end
    -- Rake: freely upgrade during Tiger's Fury or when it expires before TF comes back
    -- rake,if=(buff.tigers_fury.up|remains<variable.tfRemains)&(refreshable&persistent_multiplier>=pmultiplier|remains<2|persistent_multiplier>pmultiplier)
    if cast.able.rake()
        and (buff.tigersFury.exists() or debuff.rake.remains(units.dyn5) < var.tfRemains)
        and (
            (debuff.rake.refresh(units.dyn5) and debuff.rake.calc() >= debuff.rake.applied(units.dyn5))
            or debuff.rake.remains(units.dyn5) < 2
            or debuff.rake.calc() > debuff.rake.applied(units.dyn5)
        )
    then
        if cast.rake() then
            ui.debug("Casting Rake - TF Snapshot [Builder]")
            return true
        end
    end
    -- Moonfire Cat (Lunar Inspiration): freely upgrade during Tiger's Fury or before TF
    -- moonfire_cat,if=(buff.tigers_fury.up|remains<variable.tfRemains)&(refreshable&persistent_multiplier>=pmultiplier|remains<2|persistent_multiplier>pmultiplier)
    if talent.lunarInspiration and cast.able.moonfireCat()
        and (buff.tigersFury.exists() or debuff.moonfireCat.remains(units.dyn5) < var.tfRemains)
        and (
            (debuff.moonfireCat.refresh(units.dyn5) and debuff.moonfireCat.calc() >= debuff.moonfireCat.applied(units.dyn5))
            or debuff.moonfireCat.remains(units.dyn5) < 2
            or debuff.moonfireCat.calc() > debuff.moonfireCat.applied(units.dyn5)
        )
    then
        if cast.moonfireCat() then
            ui.debug("Casting Moonfire Cat - TF Snapshot [Builder]")
            return true
        end
    end
    -- Shred: primary builder
    -- shred
    if cast.able.shred() then
        if cast.shred() then
            ui.debug("Casting Shred [Builder]")
            return true
        end
    end
end -- End Action List - Builder

-- Action List - Cooldown
actionList.Cooldown = function()
    if unit.distance(units.dyn5) < 5 then
        -- Use Item - Imperfect Ascendancy Serum
        -- use_item,name=imperfect_ascendancy_serum,if=cooldown.bs_inc.remains<=1
        if use.able.imperfectAscendancySerum() and cd.bsInc.remains() <= 1 then
            if use.imperfectAscendancySerum() then ui.debug("Using Imperfect Ascendancy Serum [Cooldown]") return true end
        end
        -- Compute hold variables (simplified from cd_variable)
        -- variable,name=holdBerserk: hold if convoke would sync, or custom timer says so
        var.holdBerserk = (talent.convokeTheSpirits
                and cd.convokeTheSpirits.remains() > 10
                and cd.convokeTheSpirits.remains() <= 20)
            or (var.useCustomTimers and var.nextBSTimer - 5 > var.getTime and not var.zerkNow)
        -- variable,name=holdConvoke: hold last convoke for last berserk if berserk isn't up yet
        var.holdConvoke = (not buff.bsInc.exists() and cd.bsInc.remains() > 0 and cd.bsInc.remains() < 15)
            or (var.useCustomTimers and talent.ashamanesGuidance and cd.bsInc.remains() < 50)

        -- Racial: Berserking (Troll)
        -- berserking
        if ui.checked("Racial") and race == "Troll" and cast.able.racial() and ui.useCDs() then
            if cast.racial() then
                ui.debug("Casting Berserking [Cooldown]")
                return true
            end
        end
        -- Module - Combatpotion Up (fires before Berserk/Incarnation, matching SimC order)
        -- potion,if=buff.bs_inc.up|fight_remains<32|buff.tigers_fury.up&!variable.holdPot
        if buff.bsInc.exists() or unit.ttdGroup() < 32 or buff.tigersFury.exists() then
            module.CombatPotionUp()
        end
        if ui.alwaysCdNever("Berserk/Incarnation") and ui.useCDs() then
            -- Incarnation
            -- incarnation,if=buff.tigers_fury.up&!variable.holdBerserk&!variable.use_custom_timers|variable.zerkNow
            if cast.able.incarnationAvatarOfAshamane()
                and ((buff.tigersFury.exists() and not var.holdBerserk and not var.useCustomTimers)
                    or var.zerkNow)
            then
                if cast.incarnationAvatarOfAshamane() then
                    ui.debug("Casting Incarnation [Cooldown]")
                    return true
                end
            end
            -- Berserk
            -- berserk,if=buff.tigers_fury.up&!variable.holdBerserk&!variable.use_custom_timers|variable.zerkNow
            if cast.able.berserk()
                and ((buff.tigersFury.exists() and not var.holdBerserk and not var.useCustomTimers)
                    or var.zerkNow)
            then
                if cast.berserk() then
                    ui.debug("Casting Berserk [Cooldown]")
                    return true
                end
            end
        end
        -- Module - Basic Trinkets
        -- use_items / stat on-use trinkets (align with bsInc)
        module.BasicTrinkets()
        -- Feral Frenzy (no Frantic Frenzy talent)
        -- feral_frenzy,if=!talent.frantic_frenzy&combo_points<=2+(2*buff.bs_inc.up)
        if cast.able.feralFrenzy() and not talent.franticFrenzy
            and comboPoints() <= 2 + (buff.bsInc.exists() and 2 or 0)
        then
            if cast.feralFrenzy() then
                ui.debug("Casting Feral Frenzy [Cooldown]")
                return true
            end
        end
        -- Frantic Frenzy (replaces Feral Frenzy when talented)
        -- frantic_frenzy,if=(!fight_style.dungeonroute&!fight_style.dungeonslice|raid_event.adds.remains>5)&(buff.tigers_fury.up&spell_targets>=2|combo_points<=2+(2*buff.bs_inc.up))
        if cast.able.franticFrenzy() and talent.franticFrenzy
            and ((not ui.fightStyle.dungeonRoute() and not ui.fightStyle.dungeonSlice())
                or (#enemies.yards8 > 1 and unit.ttd(var.minTTDUnit) > 5))
            and (buff.tigersFury.exists() and #enemies.yards8 >= 2
                or comboPoints() <= 2 + (buff.bsInc.exists() and 2 or 0))
        then
            if cast.franticFrenzy() then
                ui.debug("Casting Frantic Frenzy [Cooldown]")
                return true
            end
        end
        -- Convoke The Spirits
        -- convoke_the_spirits,if=fight_remains<5|buff.bs_inc.up&buff.bs_inc.remains<5-talent.ashamanes_guidance|buff.tigers_fury.up&!variable.holdConvoke&(prev_gcd.1.rip|prev_gcd.1.ferocious_bite)|variable.use_custom_timers&variable.nextTFTimer+cooldown.convoke_the_spirits.duration-10>variable.nextBSTimer&combo_points<=2
        if ui.alwaysCdNever("Convoke The Spirits") and cast.able.convokeTheSpirits()
            and (unit.ttdGroup(40) < 5
                or (buff.bsInc.exists() and buff.bsInc.remains() < 5 - var.ashamanesGuidance)
                or (buff.tigersFury.exists() and not var.holdConvoke
                    and (cast.last.rip() or cast.last.ferociousBite()))
                or (var.useCustomTimers
                    and var.nextTFTimer + cd.convokeTheSpirits.duration() - 10 > var.nextBSTimer
                    and comboPoints() <= 2))
        then
            if cast.convokeTheSpirits() then
                ui.debug("Casting Convoke The Spirits [Cooldown]")
                return true
            end
        end
    end -- End distance check
end     -- End Action List - Cooldowns

-- Action List - Finisher (Single Target)
actionList.Finisher = function()
    -- Rip: maintain during Tiger's Fury or before TF returns
    -- rip,if=combo_points>=4&refreshable&(buff.tigers_fury.up|dot.rip.remains<variable.tfRemains)
    if cast.able.rip(units.dyn5) and comboPoints() >= 4
        and debuff.rip.refresh(units.dyn5)
        and (buff.tigersFury.exists() or debuff.rip.remains(units.dyn5) < var.tfRemains)
    then
        if cast.rip(units.dyn5) then
            ui.debug("Casting Rip [Finisher]")
            return true
        end
    end
    -- Ferocious Bite: standard (4 CP in Berserk, 5 CP outside; hold with Saber Jaws if not in Berserk)
    -- pool_resource,for_next=1
    -- ferocious_bite,if=combo_points>=4+buff.bs_inc.up&(!talent.saber_jaws|buff.bs_inc.up)
    if cast.able.ferociousBite()
        and comboPoints() >= 4 + (buff.bsInc.exists() and 1 or 0)
        and (not talent.saberJaws or buff.bsInc.exists())
    then
        if cast.ferociousBite() then
            ui.debug("Casting Ferocious Bite - Standard [Finisher]")
            return true
        end
    end
    -- Ferocious Bite: at max energy with 5 CP (4 with Panther's Guile) outside Berserk
    -- pool_resource,for_next=1
    -- ferocious_bite,max_energy=1,if=combo_points>=5-talent.panthers_guile&!buff.bs_inc.up
    if cast.able.ferociousBite() and energy() >= 50 and not buff.bsInc.exists()
        and comboPoints() >= 5 - (talent.panthersGuile and 1 or 0)
    then
        if cast.ferociousBite() then
            ui.debug("Casting Ferocious Bite - Max Energy [Finisher]")
            return true
        end
    end
end -- End Action List - Finisher

-- Action List - AoE Finisher
actionList.AoeFinisher = function()
    -- Primal Wrath: maintain on all targets
    -- primal_wrath,target_if=min:remains,if=combo_points>=5&spell_targets.primal_wrath>1&(dot.primal_wrath.remains<6.5&!buff.bs_inc.up|dot.primal_wrath.refreshable)
    if talent.primalWrath and cast.able.primalWrath("player", "aoe", 1, 8)
        and comboPoints() >= 5 and #enemies.yards8 > 1
        and (debuff.rip.remains(var.minRipUnit) < 6.5 and not buff.bsInc.exists()
            or debuff.rip.refresh(var.minRipUnit))
    then
        if cast.primalWrath("player", "aoe", 1, 8) then
            ui.debug("Casting Primal Wrath - Maintain [Aoe Finisher]")
            return true
        end
    end
    -- Ferocious Bite: with Ravage on 2-5 targets when no Primal Wrath
    -- ferocious_bite,if=buff.ravage.up&combo_points>=4&!talent.primal_wrath&spell_targets>=2+(3*!talent.rampant_ferocity)
    if cast.able.ferociousBite() and buff.ravage.exists() and comboPoints() >= 4
        and not talent.primalWrath
        and #enemies.yards5f >= 2 + (not talent.rampantFerocity and 3 or 0)
    then
        if cast.ferociousBite() then
            ui.debug("Casting Ferocious Bite - Ravage No PW [Aoe Finisher]")
            return true
        end
    end
    -- Rip: apply without Primal Wrath
    -- rip,target_if=min:remains,if=combo_points>=4&!talent.primal_wrath&refreshable
    if not talent.primalWrath and cast.able.rip(var.minRipUnit)
        and comboPoints() >= 4 and debuff.rip.refresh(var.minRipUnit)
    then
        if cast.rip(var.minRipUnit) then
            ui.debug("Casting Rip - No PW [Aoe Finisher]")
            return true
        end
    end
    -- Ferocious Bite: with Rampant Ferocity splash, Ravage, or Bloodseeker Vines
    -- ferocious_bite,target_if=min:dot.rip.remains,if=combo_points>=4+talent.primal_wrath&(talent.rampant_ferocity|buff.ravage.up&spell_targets<8|dot.bloodseeker_vines.ticking&spell_targets<5)
    if cast.able.ferociousBite(var.minRipUnit)
        and comboPoints() >= 4 + (talent.primalWrath and 1 or 0)
        and (talent.rampantFerocity
            or (buff.ravage.exists() and #enemies.yards8 < 8)
            or (debuff.bloodseekerVines.exists(var.minRipUnit) and #enemies.yards8 < 5))
    then
        if cast.ferociousBite(var.minRipUnit) then
            ui.debug("Casting Ferocious Bite - Rampant/Ravage/Vines [Aoe Finisher]")
            return true
        end
    end
    -- Primal Wrath: fallback at 5 CP
    -- primal_wrath,if=combo_points>=5
    if talent.primalWrath and cast.able.primalWrath("player", "aoe", 1, 8) and comboPoints() >= 5 then
        if cast.primalWrath("player", "aoe", 1, 8) then
            ui.debug("Casting Primal Wrath - Fallback [Aoe Finisher]")
            return true
        end
    end
    -- Ferocious Bite: fallback
    -- ferocious_bite,target_if=min:dot.rip.remains,if=combo_points>=4+talent.primal_wrath
    if cast.able.ferociousBite(var.minRipUnit)
        and comboPoints() >= 4 + (talent.primalWrath and 1 or 0)
    then
        if cast.ferociousBite(var.minRipUnit) then
            ui.debug("Casting Ferocious Bite - Fallback [Aoe Finisher]")
            return true
        end
    end
end -- End Action List - AoE Finisher

-- Action List - Variables
actionList.Variables = function()
    -- Variable - Regrowth
    -- variable,name=regrowth,op=reset
    var.regrowth = ui.checked("Regrowth-SimC")
end -- End Action List - Variables

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- Initialize
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
        heroTree                = br.player.heroTree
        items                   = br.player.items
        module                  = br.player.module
        race                    = br.player.race
        spell                   = br.player.spell
        talent                  = br.player.talent
        ui                      = br.player.ui
        unit                    = br.player.unit
        units                   = br.player.units
        use                     = br.player.use
        var                     = br.player.variables

        -- General Variables - Init
        var.friendsInRange      = false
        var.getTime             = ui.time()
        var.htTimer             = var.getTime
        var.lastForm            = 0
        var.lastRune            = var.getTime
        var.leftCombat          = var.getTime
        var.lootDelay           = 0
        var.minCount            = 3
        var.noDoT               = false
        var.profileStop         = false
        var.unit5ID             = 0

        -- General Variables - Numeric Conversion
        var.ashamanesGuidance   = talent.ashamanesGuidance and 1 or 0
        var.druidOfTheClaw      = heroTree.druidOfTheClaw and 1 or 0
        var.incarnation         = buff.incarnationAvatarOfAshamane.exists() and 1 or 0

        -- Custom Timer Variables - Init
        -- variable,name=use_custom_timers,op=set,value=0
        -- variable,name=nextTFTimer,op=set,value=0
        -- variable,name=nextBSTimer,op=set,value=1
        var.useCustomTimers     = false
        var.nextTFTimer         = 0
        var.nextBSTimer         = 1
        var.currentTFTimer      = -10
        var.currentBSTimer      = -10
        var.tfNow               = false
        var.zerkNow             = false
        var.holdBerserk         = false
        var.holdConvoke         = false

        -- dotcRakeThreshold - Init (updated per-frame)
        -- variable,name=dotc_rake_threshold,op=set,value=5
        var.dotcRakeThreshold   = 5
        var.activeDotRake       = 0
        var.minRipRemains       = 99999
        var.minRipUnit          = "target"
        var.moonfireRefreshUnit = "target"

        br.player.initialized   = true
    end

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    units.get(8, true)
    units.get(5)

    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(40)                        -- makes enemies.yards40
    enemies.get(20, "player", true)        -- makes enemies.yards20nc
    enemies.get(20)
    enemies.get(13, "player", false, true) -- makes enemies.yards13f
    enemies.get(8)                         -- makes enemies.yards8
    enemies.get(8, "player", false, true)  -- makes enemies.yards8f
    enemies.get(8, "target")               -- makes enemies.yards8t
    enemies.get(5, "player", false, true)  -- makes enemies.yards5f

    -- General Vars
    var.multidot  = ui.mode.cleave == 1 and ui.mode.rotation < 3
    var.getTime   = br._G.GetTime()
    var.lootDelay = ui.checked("Auto Loot") and ui.value("Auto Loot") or 0
    var.minCount  = ui.useCDs() and 1 or 3
    if not unit.inCombat() and not unit.exists("target") then
        if var.profileStop then var.profileStop = false end
        var.leftCombat = var.getTime
    end
    -- Per-frame talent/hero-tree numeric conversions
    var.ashamanesGuidance   = talent.ashamanesGuidance and 1 or 0
    var.druidOfTheClaw      = heroTree.druidOfTheClaw and 1 or 0
    var.incarnation         = buff.incarnationAvatarOfAshamane.exists() and 1 or 0
    -- variable,name=dotc_rake_threshold,op=set,value=5 (modified by wild_slashes/infected_wounds)
    var.dotcRakeThreshold   = 5
    if talent.wildSlashes and not talent.infectedWounds then var.dotcRakeThreshold = 3 end
    if not talent.wildSlashes and talent.infectedWounds then var.dotcRakeThreshold = 8 end

    var.rakeRefresh = (debuff.rake.refresh(units.dyn5) or debuff.rake.pmultiplier(units.dyn5) < 1.4) and 1 or 0
    var.unit5ID     = unit.id(units.dyn5) or 0
    var.noDoT       = var.unit5ID == 153758 or var.unit5ID == 156857 or var.unit5ID == 156849 or var.unit5ID == 156865 or
        var.unit5ID == 156869
    -- Add buff.bsInc.exists()
    buff.bsInc      = buff.bsInc or {}
    if not buff.bsInc.exists then
        buff.bsInc.exists = function()
            return buff.berserk.exists() or buff.incarnationAvatarOfAshamane.exists()
        end
    end
    -- Add buff.bsInc.remain()
    if not buff.bsInc.remains then
        buff.bsInc.remains = function()
            return math.max(buff.berserk.remain(), buff.incarnationAvatarOfAshamane.remain())
        end
    end
    -- Add cd.bsInc.remains()
    cd.bsInc = cd.bsInc or {}
    if not cd.bsInc.remains then
        cd.bsInc.remains = function()
            return math.max(cd.berserk.remains(), cd.incarnationAvatarOfAshamane.remains())
        end
    end
    -- Add cd.bsInc.duration()
    cd.bsInc = cd.bsInc or {}
    if not cd.bsInc.duration then
        cd.bsInc.duration = function()
            return math.max(cd.berserk.duration(), cd.incarnationAvatarOfAshamane.duration())
        end
    end

    -- Friends In Range
    var.solo = #br.engines.healingEngine.friend < 2
    var.friendsInRange = false
    if not var.solo then
        for i = 1, #br.engines.healingEngine.friend do
            if unit.distance(br.engines.healingEngine.friend[i].unit) < 15 then
                var.friendsInRange = true
                break
            end
        end
    end

    -- Yards8 Target_If Variables (Midnight APL)
    -- active_dot.rake count and moonfire_cat refreshable target
    var.activeDotRake       = 0
    var.moonfireRefreshUnit = units.dyn8AOE
    for i = 1, #enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        if debuff.rake.exists(thisUnit) then
            var.activeDotRake = var.activeDotRake + 1
        end
        if debuff.moonfireCat.refresh(thisUnit) then
            var.moonfireRefreshUnit = thisUnit
        end
    end

    -- Yards5f Target_If Variables
    var.minTTD = 99999
    var.minTTDUnit = "target"
    var.noRakeUnit = "target"
    var.lowRakeMultiUnit = "target"
    var.minRakePmulti = 99999
    var.maxRakePandemic = 0
    var.maxRakePandemicUnit = "target"
    var.maxRakeRefresh = 0
    var.maxRakeRefreshUnit = "target"
    var.rakeRefreshUnit = "target"
    var.maxRakeTicksGain = 0
    var.maxRakeTicksGainUnit = "target"
    var.minRakePandemicX20 = 999
    var.minRakePandemicX20Unit = "target"
    var.maxRakePandemicX25 = 0
    var.maxRakePandemicX25Unit = "target"
    -- target_if=min:dot.rip.remains
    var.minRipRemains       = 99999
    var.minRipUnit          = units.dyn5
    var.maxBloodseekerVines = 0
    var.maxBloodseekerVinesUnit = "target"
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        local ttdUnit = unit.ttd(thisUnit)
        local applied = debuff.rake.applied(thisUnit)
        local pmulti = debuff.rake.pmultiplier(thisUnit)
        local gainRefresh = debuff.rake.ticksGainedOnRefresh(thisUnit)
        local remain = debuff.rake.remains(thisUnit)
        local refresh = debuff.rake.refresh(thisUnit) and 1 or 0
        local pandemic = (applied > pmulti) and 1 or 0
        local rakeable = (pmulti < 1.6 or refresh) and 1 or 0
        local ticksGain = (rakeable * gainRefresh)
        local rakePandemic = (pmulti < applied) and 1 or 0
        local rakeRemain = remain - (rakePandemic * 20)
        local rakePandemic = (pmulti <= applied) and 1 or 0
        local rakeRefresh = (rakePandemic * 25) + gainRefresh
        local bloodseeker = debuff.bloodseekerVines.remain(thisUnit)
        -- target_if=min:target.time_to_die
        if ttdUnit < var.minTTD then
            var.minTTD = ttdUnit
            var.minTTDUnit = thisUnit
        end
        -- target_if=!dot.rake.ticking
        if not debuff.rake.exists(thisUnit) then
            var.noRakeUnit = thisUnit
        end
        -- target_if=max:refreshable+(persistent_multiplier>dot.rake.pmultiplier)
        if (refresh + pandemic) > var.maxRakePandemic then
            var.maxRakePandemic = pandemic
            var.maxRakePandemicUnit = thisUnit
        end
        -- target_if=max:refreshable+(persistent_multiplier>dot.rake.pmultiplier)
        if (refresh + pandemic) > var.maxRakeRefresh then
            var.maxRakeRefresh = (refresh + pandemic)
            var.maxRakeRefreshUnit = thisUnit
        end
        -- target_if=dot.rake.refreshable|dot.rake.pmultiplier<1.4 (first match; loop continues for other target_if vars)
        if var.rakeRefreshUnit == "target" and (refresh == 1 or debuff.rake.pmultiplier(thisUnit) < 1.4) then
            var.rakeRefreshUnit = thisUnit
        end
        -- target_if=max:(dot.rake.pmultiplier<1.6|dot.rake.refreshable)*druid.rake.ticks_gained_on_refresh
        if ticksGain > var.maxRakeTicksGain then
            var.maxRakeTicksGain = ticksGain
            var.maxRakeTicksGainUnit = thisUnit
        end
        -- target_if=min:pmultiplier
        if pmulti < var.minRakePmulti then
            var.minRakePmulti = pmulti
            var.lowRakeMultiUnit = thisUnit
        end
        -- target_if=min:dot.rake.remains-20*(dot.rake.pmultiplier<persistent_multiplier)
        if rakeRemain < var.minRakePandemicX20 then
            var.minRakePandemicX20 = rakeRemain
            var.minRakePandemicX20Unit = thisUnit
        end
        -- target_if=max:((dot.rake.pmultiplier<=persistent_multiplier)*25)+druid.rake.ticks_gained_on_refresh
        if rakeRefresh > var.maxRakePandemicX25 then
            var.maxRakePandemicX25 = rakeRefresh
            var.maxRakePandemicX25Unit = thisUnit
        end
        -- target_if=max:dot.bloodseeker_vines.ticking
        if bloodseeker > var.maxBloodseekerVines then
            var.maxBloodseekerVines = bloodseeker
            var.maxBloodseekerVinesUnit = thisUnit
        end
        -- target_if=min:dot.rip.remains
        local ripRemain = debuff.rip.remains(thisUnit)
        if ripRemain < var.minRipRemains then
            var.minRipRemains = ripRemain
            var.minRipUnit = thisUnit
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
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
end     -- End runRotation

local id = 103
br.loader.rotations[id] = br.loader.rotations[id] or {}
if br.api.expansion == "Retail" then
    br._G.tinsert(br.loader.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
    })
end
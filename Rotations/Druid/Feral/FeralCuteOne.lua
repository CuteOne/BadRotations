-------------------------------------------------------
-- Author = CuteOne
-- Patch = 10.0
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 75%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
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
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.swipe },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.swipe },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shred },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.berserk },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.berserk },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.berserk }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.skullBash },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.skullBash }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Cleave Button
	local CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.rake },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.rake }
    };
    br.ui:createToggle(CleaveModes,"Cleave",5,0)
    -- Prowl Button
	local ProwlModes = {
        [1] = { mode = "On", value = 1 , overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon = br.player.spell.prowl },
        [2] = { mode = "Off", value = 2 , overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon = br.player.spell.prowl }
    };
    br.ui:createToggle(ProwlModes,"Prowl",6,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- br.ui:createCheckbox(section, "Garbage")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Death Cat
            br.ui:createCheckbox(section,"Death Cat Mode","|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
            -- Fire Cat
            br.ui:createCheckbox(section,"Perma Fire Cat","|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic use of Fandrel's Seed Pouch or Burning Seeds.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Ferocious Bite Execute
            br.ui:createDropdownWithout(section, "Ferocious Bite Execute",{"|cffFFFF00Enabled Notify","|cff00FF00Enabled","|cffFF0000Disabled"}, 2,"Options for using Ferocious Bite when the damage from it will kill the unit.")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
	        -- Berserk/Tiger's Fury Pre-Pull
            br.ui:createCheckbox(section, "Berserk/Tiger's Fury Pre-Pull")
            -- Travel Shapeshifts
            br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
            -- Fall Timer
            br.ui:createSpinnerWithout(section,"Fall Timer", 2, 1, 5, 0.25, "|cffFFFFFFSet to desired time to wait until shifting to buff.flightForm.exists() form when falling (in secs).")
            -- Break Crowd Control
            br.ui:createCheckbox(section,"Break Crowd Control","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
            -- Wild Charge
            br.ui:createCheckbox(section,"Wild Charge","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
            -- Brutal Slash Targets
            br.ui:createSpinnerWithout(section,"Brutal Slash Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired targets to use Brutal Slash on. Min: 1 / Max: 10 / Interval: 1")
            -- Multi-DoT Limit
            br.ui:createSpinnerWithout(section,"Multi-DoT Limit", 8, 2, 10, 1, "|cffFFFFFFSet to number of enemies to stop multi-dotting with Rake and Moonfire.")
            -- Primal Wrath Usage
            br.ui:createDropdownWithout(section,"Primal Wrath Usage",{"|cffFFFF00Always","|cff00FF00Refresh Only"})
            -- Filler Spell
            br.ui:createDropdownWithout(section,"Filler Spell",{"Shred", "Rake", "Snapshot Rake", "Lunar Inspiration", "Swipe"}, 1, "|cffFFFFFFSet which spell to use as filler.")
            -- Mark of the Wild
            br.ui:createDropdown(section, "Mark of the Wild",{"|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFGroup"}, 1, "|cffFFFFFFSet how to use Mark of the Wild")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Augment Rune
            br.ui:createCheckbox(section,"Augment Rune")
            -- Potion
            br.ui:createDropdownWithout(section,"Potion", {"Spectral Agility","None"}, 1, "|cffFFFFFFSet Potion to use.")
            -- FlaskUp Module
            br.player.module.FlaskUp("Agility",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Adaptive Swarm
            br.ui:createDropdownWithout(section,"Adaptive Swarm",{"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}, 2, "|cffFFFFFFSet when to use Adaptive Swarm")
            -- Convoke The Spirits
            br.ui:createDropdownWithout(section,"Convoke The Spirits",{"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}, 2, "|cffFFFFFFSet when to use Convoke The Spirits")
            -- Tiger's Fury
            br.ui:createCheckbox(section,"Tiger's Fury")
            -- Berserk / Incarnation: King of the Jungle
            br.ui:createDropdownWithout(section,"Berserk/Incarnation",{"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}, 2, "|cffFFFFFFSet when to use Berserk/Incarnation")
            -- Owlweave
            -- br.ui:createDropdownWithout(section,"Owlweave",{"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}, 3, "|cffFFFFFFSet when to use Owlweaving.")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Barkskin
            br.ui:createSpinner(section, "Barkskin",  55,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Rebirth
            br.ui:createCheckbox(section,"Rebirth")
            br.ui:createDropdownWithout(section, "Rebirth - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Revive
            br.ui:createCheckbox(section,"Revive")
            br.ui:createDropdownWithout(section, "Revive - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Remove Corruption
            br.ui:createCheckbox(section,"Remove Corruption")
            br.ui:createDropdownWithout(section, "Remove Corruption - Target", {"|cff00FF00Player","|cffFFFF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
            -- Soothe
            br.ui:createCheckbox(section,"Soothe")
            -- Renewal
            br.ui:createSpinner(section, "Renewal",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Survival Instincts
            br.ui:createSpinner(section, "Survival Instincts",  40,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Regrowth
            br.ui:createSpinner(section, "Regrowth",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createDropdownWithout(section, "Regrowth - OoC", {"|cff00FF00Break Form","|cffFF0000Keep Form"}, 1, "|cffFFFFFFSelect if Regrowth is allowed to break shapeshift to heal out of combat.")
            br.ui:createDropdownWithout(section, "Regrowth - InC", {"|cff00FF00Immediately","|cffFF0000Save For BT"}, 1, "|cffFFFFFFSelect if Predatory Swiftness is used when available or saved for Bloodtalons.")
            -- Rejuvenation
            br.ui:createSpinner(section, "Rejuvenation",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Swiftmend
            br.ui:createSpinner(section, "Swiftmend",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Wild Growth
            br.ui:createSpinner(section, "Wild Growth",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Auto-Heal
            br.ui:createDropdownWithout(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player"},  1,  "|cffFFFFFFSelect Target to Auto-Heal")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Skull Bash
            br.ui:createCheckbox(section,"Skull Bash")
            -- Mighty Bash
            br.ui:createCheckbox(section,"Mighty Bash")
            -- Maim
            br.ui:createCheckbox(section,"Maim")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdownWithout(section, "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Prowl Toggle
            br.ui:createDropdownWithout(section, "Prowl Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
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
local function autoProwl()
    if not unit.inCombat() and not buff.prowl.exists() then
        if #enemies.yards20nc > 0 then
            for i = 1, #enemies.yards20nc do
                local thisUnit = enemies.yards20nc[i]
                local threatRange = math.max((20 + (unit.level(thisUnit) - unit.level())),5)
                local react = unit.reaction(thisUnit) or 10
                if unit.distance(thisUnit) < threatRange and (react < 4 or (unit.isUnit("target",thisUnit) and react == 4)) and unit.enemy(thisUnit) and unit.canAttack(thisUnit) then
                    return true
                end
            end
        end
    end
    return false
end
-- Multi-Dot HP Limit Set
local function canDoT(thisUnit)
    local unitHealthMax = unit.healthMax(thisUnit)
    if var.noDoT or not unit.exists(thisUnit) then return false end
    if not unit.isBoss(thisUnit) and unit.facing("player",thisUnit)
        and (var.multidot or (unit.isUnit(thisUnit,units.dyn5) and not var.multidot))
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
    local GetSpellDescription = br._G["GetSpellDescription"]
    local desc = GetSpellDescription(spell.ferociousBite)
    local damage = 0
    local finishHim = false
    if ui.value("Ferocious Bite Execute") ~= 3 and comboPoints() > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" "..comboPoints().." ",1,true)
        if comboStart ~= nil then
            comboStart = comboStart + 2
            local damageList = desc:sub(comboStart,desc:len())
            comboStart = damageList:find(": ",1,true)+2
            damageList = damageList:sub(comboStart,desc:len())
            local comboEnd = damageList:find(" ",1,true)-1
            damageList = damageList:sub(1,comboEnd)
            damage = damageList:gsub(",","")
        end
        finishHim = tonumber(damage) >= unit.health(thisUnit)
    end
    return finishHim
end
-- Primal Wrath Usable
local function usePrimalWrath()
    if talent.primalWrath and cast.able.primalWrath("player","aoe",1,8)
        and ui.useAOE(8,2)
        and not unit.isExplosive("target")
    then
        if ui.value("Primal Wrath Usage") == 1 and #enemies.yards8 >= 3 then return true end
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

local function findKindredSpirit()
    local kindredSpirit
    for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
        local thisRole = unit.role(thisUnit)
        if not unit.isUnit(thisUnit,"player") and (kindredSpirit == nil or (not unit.exists(kindredSpirit) and not unit.deadOrGhost(kindredSpirit))) then
            if thisRole == "DAMAGER" then
                kindredSpirit = thisUnit
                break
            end
            if kindredSpirit == nil and thisRole == "TANK" then
                kindredSpirit = thisUnit
                break
            end
            if kindredSpirit == nil and thisRole == "HEALER" then
                kindredSpirit = thisUnit
                break
            end
        end
    end
    return kindredSpirit
end

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
        if #br.friend > 1 then
            for i = 1, #br.friend do
                local nextUnit = br.friend[i].unit
                if buff.markOfTheWild.refresh(nextUnit) and unit.distance(var.markUnit) < 40 then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

local useTrinket = function(trinket)
    for slotID = 13, 14 do
        -- local useTrinket = (opValue == 1 or (opValue == 2 and (ui.useCDs() or ui.useAOE())) or (opValue == 3 and ui.useCDs()))
        if use.able.slot(slotID) and ui.alwaysCdAoENever("Trinket "..slotID - 12) and equiped.item(trinket,slotID) then
            return true
        end
    end
    return false
end

--------------------
--- Action Lists ---
--------------------
-- Action List - Extras
actionList.Extras = function()
    -- Shapeshift Form Management
    if ui.checked("Auto Shapeshifts") then --and br.timer:useTimer("debugShapeshift", 0.25) then
        -- Flight Form
        if cast.able.travelForm("player") and not unit.inCombat() and br.canFly() and not unit.swimming() and br.fallDist > 90
            --[[falling > ui.value("Fall Timer")]] and unit.level() >= 24 and not buff.prowl.exists()
        then
            if unit.form() ~= 0 and not cast.last.travelForm() then
                unit.cancelForm()
                ui.debug("Cancel Form [Flying]")
            elseif unit.form() == 0 then
                if cast.travelForm("player") then ui.debug("Casting Travel Form [Flying]") return true end
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
                if cast.travelForm("player") then ui.debug("Casting Travel From [Swimming]") return true end
            end
        end
        -- Cat Form
        if cast.able.catForm() and not buff.catForm.exists() and not unit.mounted() and not unit.flying() then
            -- Cat Form when not swimming or flying or stag and not in combat
            if unit.moving() and not unit.swimming() and not unit.flying() and not buff.travelForm.exists() and not buff.soulshape.exists() then
                if cast.catForm("player") then ui.debug("Casting Cat Form [No Swim / Travel / Combat]") return true end
            end
            -- Cat Form when not in combat and target selected and within 20yrds
            if not unit.inCombat() and unit.valid("target") and ((unit.distance("target") < 30 and not unit.swimming())
                or (unit.distance("target") < 10 and unit.swimming()))
            then
                if cast.catForm("player") then ui.debug("Casting Cat Form [Target In 20yrds]") return true end
            end
            -- Cat Form - Less Fall Damage
            if (not br.canFly() or unit.inCombat() or unit.level() < 24 or not unit.outdoors())
                and (not unit.swimming() or (not unit.moving() and unit.swimming() and #enemies.yards5f > 0))
                and br.fallDist > 90 --falling > ui.value("Fall Timer")
            then
                if cast.catForm("player") then ui.debug("Casting Cat Form [Reduce Fall Damage]") return true end
            end
        end
        -- Kindred Spirits
        if ui.alwaysCdNever("Covenant Ability") and var.kindredSpirit ~= nil and cast.able.kindredSpirits(var.kindredSpirit) then
            if (#br.friend > 1 and not buff.kindredSpirits.exists(var.kindredSpirit)) or (#br.friend == 1 and not buff.loneSpirit.exists()) then
                if cast.kindredSpirits(var.kindredSpirit) then ui.debug("Casting Kindred Spirits on "..unit.name(var.kindredSpirit).." [Kyrian]") return true end
            end
        end
        -- -- Lycara's Bargin - Torghast Anima Power
        -- if anima.lycarasBargin.exists() and debuff.lycarasBargin.stack("player") > 50 then
        --     if unit.form() ~= 0 then
        --         unit.cancelForm()
        --         ui.debug("Cancel Form [Lycara's Bargin]")
        --     elseif unit.form() == 0 then
        --         if cast.catForm("player") then ui.debug("Casting Cat From [Lycara's Bargin]") return true end
        --     end
        -- end
        -- -- Lycara's Twig - Torghast Anima Power
        -- if anima.lycarasTwig.exists() and not buff.lycarasTwig.exists() and not buff.prowl.exists() and not unit.inCombat() and ui.useCDs() and unit.distance("target") < 60 then
        --     if unit.form() ~= 0 then
        --         unit.cancelForm()
        --         ui.debug("Cancel Form [Lycara's Twig]")
        --     elseif unit.form() == 0 then
        --         if cast.catForm("player") then ui.debug("Casting Cat From [Lycara's Twig]") return true end
        --     end
        -- end
    end -- End Shapeshift Form Management
    -- Perma Fire Cat
    if ui.checked("Perma Fire Cat") and (use.able.fandralsSeedPouch() or use.able.burningSeeds())
        and not unit.inCombat() and not buff.prowl.exists() and buff.catForm.exists()
    then
        if not buff.burningEssence.exists() then
            -- Fandral's Seed Pouch
            if use.able.fandralsSeedPouch() and equiped.fandralsSeedPouch() then
                if use.fandralsSeedPouch() then ui.debug("Using Fandral's Seed Pouch") return true end
            -- Burning Seeds
            elseif use.able.burningSeeds() then
                if use.burningSeeds() then ui.debug("Using Burning Seeds") return true end
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
            if cast.able.tigersFury() and energy.deficit() > 60 then
                if cast.tigersFury() then ui.debug("Casting Tiger's Fury [Death Cat Mode]") return true end
            end
            -- Savage Roar - Use Combo Points
            if cast.able.savageRoar() and comboPoints() >= 5 then
                if cast.savageRoar() then ui.debug("Casting Savage Roar [Death Cat Mode]") return true end
            end
            -- Shred - Single
            if cast.able.shred() and #enemies.yards5f == 1 then
                if cast.shred() then ui.debug("Casting Shred [Death Cat Mode]"); var.swipeSoon = nil; return true end
            end
            -- Swipe - AoE
            if cast.able.swipeCat() and #enemies.yards8 > 1 then
                if var.swipeSoon == nil then
                    var.swipeSoon = var.getTime;
                end
                if var.swipeSoon ~= nil and var.swipeSoon < var.getTime - 1 then
                    if cast.swipeCat("player","aoe",1,8) then ui.debug("Casting Swipe [Death Cat Mode]") ; var.swipeSoon = nil; return true end
                end
            end
        end -- End 20yrd Enemy Scan
    end -- End Death Cat Mode
    -- Mark of the Wild
    if ui.checked("Mark of the Wild") then
        var.markUnit = getMarkUnitOption("Mark of the Wild")
        if cast.able.markOfTheWild(var.markUnit) and buff.markOfTheWild.refresh(var.markUnit) and unit.distance(var.markUnit) < 40 then
            if cast.markOfTheWild(var.markUnit) then ui.debug("Casting Mark of the Wild") return true end
        end
    end
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
end -- End Action List - Extras

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
            if cast.able.rebirth(thisUnit,"dead") and unit.deadOrGhost(thisUnit)
                and (unit.friend(thisUnit) or unit.player(thisUnit))
            then
                if unit.form() ~= 0 then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Rebirth]")
                elseif unit.form() == 0 then
                    if cast.rebirth(thisUnit,"dead") then ui.debug("Casting Rebirth on "..unit.name(thisUnit)) return true end
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
            if cast.able.revive(thisUnit,"dead") and unit.deadOrGhost(thisUnit)
                and (unit.friend(thisUnit) and unit.player(thisUnit))
            then
                if cast.revive(thisUnit,"dead") then ui.debug("Casting Revive on "..unit.name(thisUnit)) return true end
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
                if cast.removeCorruption(thisUnit) then ui.debug("Casting Remove Corruption on "..unit.name(thisUnit)) return true end
            end
        end
        -- Soothe
        if ui.checked("Soothe") and cast.able.soothe() then
            for i=1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if cast.dispel.soothe(thisUnit) then
                    if cast.soothe(thisUnit) then ui.debug("Casting Soothe on "..unit.name(thisUnit)) return true end
                end
            end
        end
        -- Renewal
        if ui.checked("Renewal") and unit.inCombat() and cast.able.renewal() and unit.hp() <= ui.value("Renewal") then
            if cast.renewal() then ui.debug("Casting Renewal") return true end
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
                    for i=1, unit.formCount() do
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
        -- Basic Healing Module
        module.BasicHealing()
        -- Resto Affinity
        if talent.restorationAffinity and not (unit.mounted() or unit.flying())
            and (ui.value("Auto Heal") ~= 1 or (ui.value("Auto Heal") == 1
            and unit.distance(br.friend[1].unit) < 40))
        then
            local thisHP = unit.hp()
            local thisUnit = "player"
            local lowestUnit = unit.lowest(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 then thisHP = fhp; thisUnit = lowestUnit end
            -- Swiftmend
            local swiftPercent = ui.value("Swiftmend")
            if ui.checked("Swiftmend") and cast.able.swiftmend()
                and ((not unit.inCombat() and thisHP <= swiftPercent) or (unit.inCombat() and thisHP <= swiftPercent/2))
            then
                if unit.form() ~= 0 then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Swiftmend]")
                elseif unit.form() == 0 then
                    if cast.swiftmend(thisUnit) then ui.debug("Casting Swiftmend on "..unit.name(thisUnit)) return true end
                end
            end
            -- Rejuvenation
            local rejuvPercent = ui.value("Rejuvenation")
            if ui.checked("Rejuvenation") and cast.able.rejuvenation() and buff.rejuvenation.refresh(thisUnit)
                and ((not unit.inCombat() and thisHP <= rejuvPercent) or (unit.inCombat() and thisHP <= rejuvPercent/2))
            then
                if unit.form() ~= 0 then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Rejuvenation]")
                elseif unit.form() == 0 then
                    if cast.rejuvenation(thisUnit) then ui.debug("Casting Rejuvenation on "..unit.name(thisUnit)) return true end
                end
            end
            -- Wild Growth
            if ui.checked("Wild Growth") and not unit.inCombat() and cast.able.wildGrowth() then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
                    local lowHealthCandidates = br.getUnitsToHealAround(thisUnit, 30, ui.value("Wild Growth"), #br.friend)
                    if #lowHealthCandidates > 1 and not unit.moving() then
                        if unit.form() ~= 0 then
                            unit.cancelForm()
                            ui.debug("Cancel Form [Wild Growth]")
                        elseif unit.form() == 0 then
                            if cast.wildGrowth(br.friend[i].unit) then ui.debug("Casting Wild Growth on "..unit.name(thisUnit)) return true end
                        end
					end
                end
            end
        end
        -- Regrowth
        if ui.checked("Regrowth") and cast.able.regrowth("player") and not (unit.mounted() or unit.flying()) and not cast.current.regrowth() then
            local thisHP = unit.hp()
            local thisUnit = "player"
            local lowestUnit = unit.lowest(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 and unit.distance(lowestUnit) < 40 then thisHP = fhp; thisUnit = lowestUnit else thisUnit = "player" end
            if not unit.inCombat() and thisHP <= ui.value("Regrowth") and (not unit.moving() or buff.predatorySwiftness.exists()) then
                -- Break Form
                if ui.value("Regrowth - OoC") == 1 and unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(thisUnit,"player") then
                    unit.cancelForm()
                    ui.debug("Cancel Form [Regrowth - OoC Break]")
                end
                -- Lowest Party/Raid or Player
                if unit.form() == 0 or buff.predatorySwiftness.exists() then
                    if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth [OoC] on "..unit.name(thisUnit)) return true end
                end
            elseif unit.inCombat() and (buff.predatorySwiftness.exists() or unit.level() < 49) then
                -- Always Use Predatory Swiftness when available
                if ui.value("Regrowth - InC") == 1 or not talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= ui.value("Regrowth") and unit.level() >= 49) or (unit.level() < 49 and thisHP <= ui.value("Regrowth") / 2) then
                        if unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(thisUnit,"player") then
                            unit.cancelForm()
                            ui.debug("Cancel Form [Regrowth - InC Break]")
                        elseif unit.form() == 0 or buff.predatorySwiftness.exists() then
                            if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth [IC Instant] on "..unit.name(thisUnit)) return true end
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
                            if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth [IC BT Hold] on "..unit.name(thisUnit)) return true end
                        end
                    end
                end
            end
        end
        -- Barkskin
        if ui.checked("Barkskin") and unit.inCombat() and cast.able.barkskin() and unit.hp() <= ui.value("Barkskin") then
            if cast.barkskin() then ui.debug("Casting Barkskin") return true end
        end
        -- Survival Instincts
        if ui.checked("Survival Instincts") and unit.inCombat() and cast.able.survivalInstincts()
            and unit.hp() <= ui.value("Survival Instincts")
            and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0
        then
            if cast.survivalInstincts() then ui.debug("Casting Survival Instincts") return true end
        end
        -- Fleshcraft
        if cast.able.fleshcraft() and unit.exists("target") and unit.deadOrGhost("target") and not unit.moving() and unit.ooCombatTime() > 2 then
            if cast.fleshcraft("player") then ui.debug("Casting Fleshcraft") return true end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        local thisUnit
        -- Skull Bash
        if ui.checked("Skull Bash") and cast.able.skullBash() then
            for i=1, #enemies.yards13f do
                thisUnit = enemies.yards13f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.skullBash(thisUnit) then ui.debug("Casting Skull Bash on "..unit.name(thisUnit)) return true end
                end
            end
        end
        -- Mighty Bash
        if ui.checked("Mighty Bash") and cast.able.mightyBash() then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.mightyBash(thisUnit) then ui.debug("Casting Mighty Bash on "..unit.name(thisUnit)) return true end
                end
            end
        end
        -- Maim
        if ui.checked("Maim") and cast.able.maim() then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At"))
                    and comboPoints() > 0 and not buff.fieryRedMaimers.exists()
                then
                    if cast.maim(thisUnit) then ui.debug("Casting Maim on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
            -- FlaskUp Module
            -- flask
            module.FlaskUp("Agility")
            -- Battle Scarred Augment Rune
            -- augmentation,type=defiled
            if ui.checked("Augment Rune") and unit.instance("raid") and not buff.battleScarredAugmentation.exists()
                and use.able.battleScarredAugmentRune() and var.lastRune + unit.gcd(true) < var.getTime
            then
                if use.battleScarredAugmentRune() then ui.debug("Using Battle Scared Augment Rune [Precombat]") var.lastRune = var.getTime return true end
            end
            -- Heart of the Wild
            -- heart_of_the_wild
            if cast.able.heartOfTheWild() then
                if cast.heartOfTheWild() then ui.debug("Casting Heart Of The Wild [Precombat]") return true end
            end
            -- Use Item - Algethar Puzzle Box
            -- use_item,name=algethar_puzzle_box
            if use.able.algetharPuzzleBox() then
                if use.algetharPuzzleBox() then ui.debug("Using Algethar Puzzle Box [Precombat]") return true end
            end
            -- Prowl
            -- prowl,if=!buff.prowl.up
            if cast.able.prowl("player")
                and buff.catForm.exists()
                and autoProwl()
                and ui.mode.prowl == 1
                and not buff.prowl.exists()
                and not unit.resting()
                and not buff.bsInc.exists()
                -- and var.getTime - var.leftCombat > lootDelay
            then
                if cast.prowl("player") then ui.debug("Casting Prowl [Precombat]") return true end
            end
        end -- End No Stealth
        -- Wild Charge
        if ui.checked("Displacer Beast / Wild Charge") and cast.able.wildCharge("target") and unit.valid("target") then
            if cast.wildCharge("target") then ui.debug("Wild Charge on "..unit.name("target")) return true end
        end
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
        end -- End Pre-Pull
        -- Pull
        if unit.valid("target") and unit.exists("target") and unit.distance("target") < 5 then
            -- Rake (Stealth)
            -- rake,if=buff.prowl.up|buff.shadowmeld.up
            if cast.able.rake("target") and (buff.prowl.exists() or buff.shadowmeld.exists()) then
                if cast.rake("target") then ui.debug("Casting Rake [Pre-Combat]") return true end
            end
            -- Auto Attack
            -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
            if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

-- Action List - AoEBuilder
actionList.AoeBuilder = function()
    -- Brutal Slash
    -- brutal_slash,target_if=min:target.time_to_die,if=(cooldown.brutal_slash.full_recharge_time<4|target.time_to_die<5)&!((variable.need_bt|buff.bs_inc.up)&buff.bt_brutal_slash.up)
    if talent.brutalSlash and cast.able.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) and (((charges.brutalSlash.timeTillFull()<4 or unit.ttd(var.minTTDUnit)<5)
        and not ((var.needBt or buff.bsInc.exists()) and var.btGen.brutalSlash)))
    then
        if cast.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) then ui.debug("Casting Brutal Slash [Aoe Builder - Max Charges]") return true end
    end
    -- Thrash Cat
    -- thrash_cat,if=dot.thrash_cat.remains<3&(!buff.sudden_ambush.up|!talent.doubleclawed_rake.enabled)&!talent.thrashing_claws
    if cast.able.thrashCat("player","aoe",1,8) and ((debuff.thrashCat.remains(units.dyn8AOE)<3
        and (not buff.suddenAmbush.exists() or not talent.doubleclawedRake) and not talent.thrashingClaws))
    then
        if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash Cat [Aoe Builder - Expire Soon]") return true end
    end
    -- Prowl
    -- prowl,target_if=max:dot.rake.pmultiplier<1.6|dot.rake.refreshable,if=(dot.rake.pmultiplier<1.6|dot.rake.refreshable)&!(variable.need_bt&buff.bt_rake.up)
    if cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1 and not buff.prowl.exists()
        and (((debuff.rake.pmultiplier(var.maxProwlRakeRefreshUnit)<1.6 or debuff.rake.refresh(var.maxProwlRakeRefreshUnit)) and not (var.needBt and var.btGen.rake)))
    then
        if cast.prowl("player") then ui.debug("Casting Prowl [Aoe Builder]") return true end
    end
    -- Shadowmeld
    -- shadowmeld,target_if=max:(dot.rake.pmultiplier<1.6|dot.rake.refreshable),if=(dot.rake.pmultiplier<1.6|dot.rake.refreshable)&!(variable.need_bt&buff.bt_rake.up)
    if ui.checked("Racial") and race == "NightElf" and cast.able.racial() and ui.useCDs() and not unit.moving()
        and unit.distance(units.dyn5) < 5 and not var.solo and var.friendsInRange
    then
        if (((debuff.rake.pmultiplier(var.maxRakePanUnit)<1.6 or debuff.rake.refresh(var.maxRakePanUnit)) and not (var.needBt and var.btGen.rake))) then
            if cast.racial() then ui.debug("Casting Shadowmeld [Aoe Builder]") return true end
        end
    end
    -- Rake
    -- rake,target_if=max:(dot.rake.pmultiplier<1.6|dot.rake.refreshable)*druid.rake.ticks_gained_on_refresh,if=(buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier|dot.rake.refreshable)&!(variable.need_bt&buff.bt_rake.up)
    if cast.able.rake(var.maxRakeRefreshTicksGainUnit) and (((buff.suddenAmbush.exists()
        and debuff.rake.applied(var.maxRakeRefreshTicksGainUnit)>debuff.rake.pmultiplier(var.maxRakeRefreshTicksGainUnit)
            or debuff.rake.refresh(var.maxRakeRefreshTicksGainUnit)) and not (var.needBt and var.btGen.rake)))
    then
        if cast.rake(var.maxRakeRefreshTicksGainUnit) then ui.debug("Casting Rake [Aoe Builder - Sudden Ambush]") return true end
    end
    -- Thrash Cat
    -- thrash_cat,if=refreshable&!talent.thrashing_claws
    if cast.able.thrashCat("player","aoe",1,8) and debuff.thrashCat.refresh(units.dyn8AOE) and not talent.thrashingClaws then
        if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash Cat [Aoe Builder - Refresh]") return true end
    end
    -- Brutal Slash
    -- brutal_slash,if=!(variable.need_bt&buff.bt_brutal_slash.up)
    if talent.brutalSlash and cast.able.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) and not (var.needBt and buff.btBrutalSlash.exists()) then
        if cast.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) then ui.debug("Casting Brutal Slash [Aoe Builder]") return true end
    end
    -- Swipe Cat
    -- swipe_cat,if=spell_targets.swipe_cat>4&!(variable.need_bt&buff.bt_swipe.up)
    if not talent.brutalSlash and cast.able.swipeCat("player","aoe",1,8) and #enemies.yards8>4 and not (var.needBt and var.btGen.swipe) then
        if cast.swipeCat("player","aoe",1,8) then ui.debug("Casting Swipe Cat [Aoe Builder - High Target Count]") return true end
    end
    -- Moonfire Cat
    -- moonfire_cat,target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking,if=dot.moonfire.refreshable&!(variable.need_bt&buff.bt_moonfire.up)
    if talent.lunarInspiration and cast.able.moonfireCat(var.maxMoonfireRefreshAdaptiveUnit) and debuff.moonfireCat.refresh(var.maxMoonfireRefreshAdaptiveUnit)
        and not (var.needBt and var.btGen.moonfireFeral)
    then
        if cast.moonfireCat(var.maxMoonfireRefreshAdaptiveUnit) then ui.debug("Casting Moonfire Cat [Aoe Builder]") return true end
    end
    -- Swipe Cat
    -- swipe_cat,if=!(variable.need_bt&buff.bt_swipe.up)
    if not talent.brutalSlash and cast.able.swipeCat("player","aoe",1,8) and not (var.needBt and var.btGen.swipe) then
        if cast.swipeCat("player","aoe",1,8) then ui.debug("Casting Swipe Cat [Aoe Builder]") return true end
    end
    -- Shred
    -- shred,target_if=max:target.time_to_die,if=(spell_targets.swipe_cat<4|talent.dire_fixation.enabled)&!buff.sudden_ambush.up&!(variable.easy_swipe&talent.wild_slashes)&!(variable.need_bt&buff.bt_shred.up)
    if cast.able.shred(var.maxTTDUnit) and (((#enemies.yards8<4 or talent.direFixation) and not buff.suddenAmbush.exists()
        and not (var.easySwipe and talent.wildSlashes) and not (var.needBt and var.btGen.shred)))
    then
        if cast.shred(var.maxTTDUnit) then ui.debug("Casting Shred [Aoe Builder - Low Target Count/Dire Fixation]") return true end
    end
    -- Thrash Cat
    -- thrash_cat,if=!(variable.need_bt&buff.bt_thrash.up)
    if cast.able.thrashCat("player","aoe",1,8) and not (var.needBt and var.btGen.thrash) then
        if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash Cat [Aoe Builder") return true end
    end
    -- Shred
    -- shred,target_if=max:target.time_to_die,if=!variable.easy_swipe&variable.need_bt&buff.bt_shred.down
    if cast.able.shred(var.maxTTDUnit) and not var.easySwipe and var.needBt and not var.btGen.shred then
        if cast.shred(var.maxTTDUnit) then
            ui.debug("Casting Shred [Aoe Builder - Bloodtalons Build]")
            var.btGen.shred = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Moonfire Cat
    -- moonfire_cat,target_if=max:dot.moonfire.ticks_gained_on_refresh,if=variable.need_bt&buff.bt_moonfire.down
    if talent.lunarInspiration and cast.able.moonfireCat(var.maxMoonfireFeralTicksGainUnit) and var.needBt and not var.btGen.moonfireFeral then
        if cast.moonfireCat(var.maxMoonfireFeralTicksGainUnit) then
            ui.debug("Casting Moonfire Cat [Aoe Builder - Bloodtalons Build]")
            var.btGen.moonfireFeral = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Rake
    -- rake,target_if=max:((dot.rake.pmultiplier<=persistent_multiplier)*25)+druid.rake.ticks_gained_on_refresh,if=variable.need_bt&buff.bt_rake.down
    if cast.able.rake(var.maxRakeRefresh25Unit) and var.needBt and not var.btGen.rake then
        if cast.rake(var.maxRakeRefresh25Unit) then
            ui.debug("Casting Rake [Aoe Builder - Bloodtalons Build]")
            var.btGen.rake = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
end -- End Action List - AoE

-- Action List - Berserk
actionList.Berserk = function()
    -- Ferocious Bite
    -- ferocious_bite,target_if=max:target.time_to_die,if=combo_points=5&dot.rip.remains>8&variable.zerk_biteweave&spell_targets.swipe_cat>1
    if cast.able.ferociousBite(var.maxTTDUnit) and comboPoints()==5 and debuff.rip.remains(var.maxTTDUnit)>8 and var.zerkBiteweave and #enemies.yards8>1 then
        if cast.ferociousBite(var.maxTTDUnit) then ui.debug("Casting Ferocious Bite [Berserk]") return true end
    end
    -- Call Action List - Finisher
    -- call_action_list,name=finisher,if=combo_points=5&!(buff.overflowing_power.stack<=1&active_bt_triggers=2&buff.bloodtalons.stack<=1&set_bonus.tier30_4pc)
    if comboPoints()==5 and not (buff.overflowingPower.count()<=1 and var.btGen.triggers==2 and buff.bloodtalons.count()<=1 and equiped.tier(30,4)) then
        if actionList.Finisher() then return true end
    end
    -- Call Action List - Aoe Builder
    -- run_action_list,name=aoe_builder,if=spell_targets.swipe_cat>1
    if #enemies.yards8>1 then
        if actionList.AoeBuilder() then return true end
    end
    -- Prowl
    -- prowl,if=!(buff.bt_rake.up&active_bt_triggers=2)&(action.rake.ready&gcd.remains=0&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.shadowmeld.up)
    if cast.able.prowl("player") and buff.catForm.exists() and autoProwl() and ui.mode.prowl == 1 and not buff.prowl.exists()
        and ((not (var.btGen.rake and var.btGen.triggers==2) and (cast.able.rake() and cd.prowl.remains()==0 and not buff.suddenAmbush.exists()
        and (debuff.rake.refresh(units.dyn5) or debuff.rake.pmultiplier(units.dyn5)<1.4) and not buff.shadowmeld.exists())))
    then
        if cast.prowl("player") then ui.debug("Casting Prowl [Berserk]") return true end
    end
    -- Shadowmeld
    -- shadowmeld,if=!(buff.bt_rake.up&active_bt_triggers=2)&action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up
    if ui.checked("Racial") and race == "NightElf" and cast.able.racial() and ui.useCDs() and not unit.moving()
        and unit.distance(units.dyn5) < 5 and not var.solo and var.friendsInRange
    then
        if ((not (var.btGen.rake and var.btGen.triggers==2) and cast.able.rake() and not buff.suddenAmbush.exists()
            and (debuff.rake.refresh(units.dyn5) or debuff.rake.pmultiplier(units.dyn5)<1.4) and not buff.prowl.exists()))
        then
            if cast.racial() then ui.debug("Casting Shadowmeld [Berserk]") return true end
        end
    end
    -- Rake
    -- rake,if=!(buff.bt_rake.up&active_bt_triggers=2)&(dot.rake.remains<3|buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier)
    if cast.able.rake() and ((not (var.btGen.rake and var.btGen.triggers==2) and (debuff.rake.remains(units.dyn5)<3 or buff.suddenAmbush.exists()
        and debuff.rake.applied(units.dyn5)>debuff.rake.pmultiplier(units.dyn5))))
    then
        if cast.rake() then
            ui.debug("Casting Rake [Berserk - Bloodtalons Build]")
            var.btGen.rake = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Shred
    -- shred,if=active_bt_triggers=2&buff.bt_shred.down
    if cast.able.shred() and var.btGen.triggers==2 and not var.btGen.shred then
        if cast.shred() then
            ui.debug("Casting Shred [Berserk - Bloodtalons Build]")
            var.btGen.shred = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Brutal Slash
    -- brutal_slash,if=active_bt_triggers=2&buff.bt_brutal_slash.down
    if talent.brutalSlash and cast.able.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) and var.btGen.triggers==2 and not var.btGen.brutalSlash then
        if cast.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) then
            ui.debug("Casting Brutal Slash [Berserk - Bloodtalons Build]")
            var.btGen.brutalSlash = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Moonfire Cat
    -- moonfire_cat,if=active_bt_triggers=2&buff.bt_moonfire.down
    if talent.lunarInspiration and cast.able.moonfireCat() and var.btGen.triggers==2 and not var.btGen.moonfireFeral then
        if cast.moonfireCat() then
            ui.debug("Casting Moonfire Cat [Berserk - Bloodtalons Build]")
            var.btGen.moonfireFeral = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Thrash Cat
    -- thrash_cat,if=active_bt_triggers=2&buff.bt_thrash.down&!talent.thrashing_claws&variable.need_bt
    if cast.able.thrashCat("player","aoe",1,8) and var.btGen.triggers==2 and not var.btGen.thrash and not talent.thrashingClaws and var.needBt then
        if cast.thrashCat("player","aoe",1,8) then
            ui.debug("Casting Thrash Cat [Berserk - Bloodtalons Build]")
            var.btGen.thrash = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Moonfire Cat
    -- moonfire_cat,if=refreshable
    if talent.lunarInspiration and cast.able.moonfireCat() and debuff.moonfireCat.refresh(units.dyn40AOE) then
        if cast.moonfireCat() then ui.debug("Casting Moonfire Cat [Berserk]") return true end
    end
    -- Brutal Slash
    -- brutal_slash,if=cooldown.brutal_slash.charges>1&(!talent.dire_fixation.enabled|debuff.dire_fixation.up)
    if talent.brutalSlash and cast.able.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8)
        and ((charges.brutalSlash.count()>1 and (not talent.direFixation or debuff.direFixation.exists(units.dyn8AOE))))
    then
        if cast.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) then ui.debug("Casting Brutal Slash [Berserk]") return true end
    end
    -- Shred
    -- shred
    if cast.able.shred() then
        if cast.shred() then ui.debug("Casting Shred [Berserk]") return true end
    end
end -- End Action List - Berserk

-- Action List - Builder
actionList.Builder = function()
    -- Thrash Cat
    -- thrash_cat,if=refreshable&(!talent.dire_fixation.enabled|talent.dire_fixation.enabled&debuff.dire_fixation.up)&buff.clearcasting.react&!talent.thrashing_claws.enabled
    if cast.able.thrashCat("player","aoe",1,8) and ((debuff.thrashCat.refresh(units.dyn8AOE)
        and (not talent.direFixation or talent.direFixation and debuff.direFixation.exists(units.dyn8AOE)) and buff.clearcasting.exists() and not talent.thrashingClaws))
    then
        if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash Cat [Builder - Clearcast]") return true end
    end
    -- Shred
    -- shred,if=(buff.clearcasting.react|(talent.dire_fixation.enabled&!debuff.dire_fixation.up))&!(variable.need_bt&buff.bt_shred.up)
    if cast.able.shred() and (((buff.clearcasting.exists() or (talent.direFixation and not debuff.direFixation.exists(units.dyn5))) and not (var.needBt and var.btGen.shred))) then
        if cast.shred() then ui.debug("Casting Shred [Builder - Clearcast/Dire Fixation]") return true end
    end
    -- Brutal Slash
    -- brutal_slash,if=cooldown.brutal_slash.full_recharge_time<4&!(variable.need_bt&buff.bt_brutal_slash.up)
    if talent.brutalSlash and cast.able.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8)
        and charges.brutalSlash.timeTillFull()<4 and not (var.needBt and var.btGen.brutalSlash)
    then
        if cast.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) then ui.debug("Casting Brutal Slash [Builder - Max Charges Soon]") return true end
    end
    -- Pool Resource
    -- pool_resource,if=!action.rake.ready&(dot.rake.refreshable|(buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier&dot.rake.remains>6))&!buff.clearcasting.react&!(variable.need_bt&buff.bt_rake.up)
    if ((not cast.able.rake() and (debuff.rake.refresh(units.dyn5) or (buff.suddenAmbush.exists()
        and debuff.rake.applied(units.dyn5)>debuff.rake.pmultiplier(units.dyn5) and debuff.rake.remains(units.dyn5)>6))
        and not buff.clearcasting.exists() and not (var.needBt and var.btGen.rake)))
    then
        return true
    end
    -- Shadowmeld
    -- shadowmeld,if=action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!(variable.need_bt&buff.bt_rake.up)&!buff.prowl.up
    if ui.checked("Racial") and race == "NightElf" and cast.able.racial() and ui.useCDs() and not unit.moving()
        and unit.distance(units.dyn5) < 5 and not var.solo and var.friendsInRange
    then
        if ((cast.able.rake() and not buff.suddenAmbush.exists() and (debuff.rake.refresh(units.dyn5) or debuff.rake.pmultiplier(units.dyn5)<1.4)
            and not (var.needBt and var.btGen.rake) and not buff.prowl.exists()))
        then
            if cast.racial() then ui.debug("Casting Shadowmeld [Builder]") return true end
        end
    end
    -- Rake
    -- rake,if=(refreshable|buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier)&!(variable.need_bt&buff.bt_rake.up)
    if cast.able.rake() and (((debuff.rake.refresh(units.dyn5) or buff.suddenAmbush.exists()
        and debuff.rake.applied(units.dyn5)>debuff.rake.pmultiplier(units.dyn5)) and not (var.needBt and var.btGen.rake)))
    then
        if cast.rake() then ui.debug("Casting Rake [Builder]") return true end
    end
    -- Moonfire Cat
    -- moonfire_cat,target_if=refreshable
    if talent.lunarInspiration then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if cast.able.moonfireCat(thisUnit) and debuff.moonfireCat.refresh(thisUnit) then
                if cast.moonfireCat(thisUnit) then ui.debug("Casting Moonfire Cat [Builder]") return true end
            end
        end
    end
    -- Thrash Cat
    -- thrash_cat,target_if=refreshable&!talent.thrashing_claws.enabled
    for i = 1, #enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        if cast.able.thrashCat("player","aoe",1,8) and debuff.thrashCat.refresh(thisUnit) and not talent.thrashingClaws then
            if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash Cat [Builder - Refresh]") return true end
        end
    end
    -- Brutal Slash
    -- brutal_slash,if=!(variable.need_bt&buff.bt_brutal_slash.up)
    if talent.brutalSlash and cast.able.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) and not (var.needBt and var.btGen.brutalSlash) then
        if cast.brutalSlash("player","aoe",ui.value("Brutal Slash Targets"),8) then ui.debug("Casting Brutal Slash [Builder]") return true end
    end
    -- Swipe Cat
    -- swipe_cat,if=spell_targets.swipe_cat>1|(talent.wild_slashes.enabled&(debuff.dire_fixation.up|!talent.dire_fixation.enabled))
    if not talent.brutalSlash and cast.able.swipeCat("player","aoe",1,8) and ((#enemies.yards8>1 or (talent.wildSlashes
        and (debuff.direFixation.exists(units.dyn8) or not talent.direFixation))))
    then
        if cast.swipeCat("player","aoe",1,8) then ui.debug("Casting Swipe Cat [Builder]") return true end
    end
    -- Shred
    -- shred,if=!(variable.need_bt&buff.bt_shred.up)
    if cast.able.shred() and not (var.needBt and var.btGen.shred) then
        if cast.shred() then ui.debug("Casting Shred [Builder]") return true end
    end
    -- Moonfire Cat
    -- moonfire_cat,if=variable.need_bt&buff.bt_moonfire.down
    if talent.lunarInspiration and cast.able.moonfireCat() and var.needBt and not var.btGen.moonfireFeral then
        if cast.moonfireCat() then
            ui.debug("Casting Moonfire Cat [Builder - Bloodtalons Build]")
            var.btGen.moonfireFeral = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Swipe Cat
    -- swipe_cat,if=variable.need_bt&buff.bt_swipe.down
    if not talent.brutalSlash and cast.able.swipeCat() and var.needBt and not var.btGen.swipe then
        if cast.swipeCat() then
            ui.debug("Casting Swipe Cat [Builder - Bloodtalons Build]")
            var.btGen.swipe = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Rake
    -- rake,if=variable.need_bt&buff.bt_rake.down&persistent_multiplier>=dot.rake.pmultiplier
    if cast.able.rake() and var.needBt and not var.btGen.rake and debuff.rake.applied(units.dyn5)>=debuff.rake.pmultiplier(units.dyn5) then
        if cast.rake() then
            ui.debug("Casting Rake [Builder - Bloodtalons Build]")
            var.btGen.rake = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Thrash Cat
    -- thrash_cat,if=variable.need_bt&buff.bt_thrash.down
    if cast.able.thrashCat() and var.needBt and not var.btGen.thrash then
        if cast.thrashCat() then
            ui.debug("Casting Thrash Cat [Builder - Bloodtalons Build]")
            var.btGen.thrash = true
            if var.btGen.timer - var.getTime <= 0 then var.btGen.timer = var.getTime + 4 end
            return true
        end
    end
end -- End Action List - Builder

-- Action List - Cooldown
actionList.Cooldown = function()
    if unit.distance(units.dyn5) < 5 then
        -- Use Item - Algethar Puzzle Box
        -- use_item,name=algethar_puzzle_box,if=fight_remains<35|(!variable.align_3minutes)
        if useTrinket(items.algetharPuzzleBox) and use.able.algetharPuzzleBox() and ((unit.ttdGroup(40)<35 or (not var.align3Minutes))) then
            if use.algetharPuzzleBox() then ui.debug("Using Algethar Puzzle Box [Cooldown]") return true end
        end
        -- Use Item - Algethar Puzzle Box
        -- use_item,name=algethar_puzzle_box,if=variable.align_3minutes&(cooldown.bs_inc.remains<3&(!variable.lastZerk|!variable.lastConvoke|(variable.lastConvoke&cooldown.convoke_the_spirits.remains<13)))
        if useTrinket(items.algetharPuzzleBox) and use.able.algetharPuzzleBox() and ((var.align3Minutes and (buff.bsInc.remains()<3 and (not var.lastZerk or not var.lastConvoke
            or (var.lastConvoke and cd.convokeTheSpirits.remains()<13)))))
        then
            if use.algetharPuzzleBox() then ui.debug("Using Algethar Puzzle Box [Cooldown - Align 3 Min]") return true end
        end
        if ui.alwaysCdNever("Berserk/Incarnation") and ui.useCDs() then
            -- Incarnation
            -- incarnation,target_if=max:target.time_to_die,if=(target.time_to_die<fight_remains&target.time_to_die>25)|target.time_to_die=fight_remains
            if cast.able.incarnationAvatarOfAshamane() and (((unit.ttd(var.maxTTDUnit)<unit.ttdGroup(40)
                and unit.ttd(var.maxTTDUnit)>25) or unit.ttd(var.maxTTDUnit)==unit.ttdGroup(40)))
            then
                if cast.incarnationAvatarOfAshamane() then ui.debug("Casting Incarnation [Cooldown]") return true end
            end
            -- Berserk
            -- berserk,if=fight_remains<25|talent.convoke_the_spirits.enabled&(fight_remains<cooldown.convoke_the_spirits.remains|(variable.align_cds&(action.feral_frenzy.ready&(combo_points<3|(time<10&combo_points<4))|time<10&combo_points<4)&cooldown.convoke_the_spirits.remains<10))
            if cast.able.berserk() and ((unit.ttdGroup(40)<25 or talent.convokeTheSpirits and (unit.ttdGroup(40)<cd.convokeTheSpirits.remains()
                or (var.alignCds and (cast.able.feralFrenzy() and (comboPoints()<3 or (unit.combatTime()<10 and comboPoints()<4))
                or unit.combatTime()<10 and comboPoints()<4) and cd.convokeTheSpirits.remains()<10))))
            then
                if cast.berserk() then ui.debug("Casting Berserk [Cooldown - Condition 1]") return true end
            end
            -- Berserk
            -- berserk,target_if=max:target.time_to_die,if=!variable.align_cds&!(!talent.frantic_momentum.enabled&equipped.witherbarks_branch&spell_targets.swipe_cat=1)&((!variable.lastZerk)|(variable.lastZerk&!variable.lastConvoke)|(variable.lastConvoke&(cooldown.convoke_the_spirits.remains<10&(!set_bonus.tier31_2pc|set_bonus.tier31_2pc&buff.smoldering_frenzy.up))))&((target.time_to_die<fight_remains&target.time_to_die>18)|target.time_to_die=fight_remains)
            if cast.able.berserk() and ((not var.alignCds and not (not talent.franticMomentum and equiped.witherbarksBranch() and #enemies.yards8==1)
                and ((not var.lastZerk) or (var.lastZerk and not var.lastConvoke) or (var.lastConvoke and (cd.convokeTheSpirits.remains()<10
                and (not equiped.tier(31,2) or equiped.tier(31,2) and buff.smolderingFrenzy.exists())))) and ((unit.ttd(var.maxTTDUnit)<unit.ttdGroup(40)
                and unit.ttd(var.maxTTDUnit)>18) or unit.ttd(var.maxTTDUnit)==unit.ttdGroup(40))))
            then
                if cast.berserk() then ui.debug("Casting Berserk [Cooldown - Condition 2]") return true end
            end
            -- Berserk
            -- berserk,if=fight_remains<23|(time+118)%%120<30&!talent.frantic_momentum.enabled&(equipped.witherbarks_branch|equipped.ashes_of_the_embersoul)&spell_targets.swipe_cat=1
            if cast.able.berserk() and ((unit.ttdGroup(40)<23 or (unit.combatTime()+118)%120<30 and not talent.franticMomentum
                and (equiped.witherbarksBranch() or equiped.ashesOfTheEmbersoul()) and #enemies.yards8==1))
            then
                if cast.berserk() then ui.debug("Casting Berserk [Cooldown - Condition 3]") return true end
            end
        end
        -- Racial: Berserking (Troll)
        -- berserking,if=!variable.align_3minutes|buff.bs_inc.up
        if ui.checked("Racial") and race == "Troll" and cast.able.racial() and ui.useCDs() and ((not var.align3Minutes or buff.bsInc.exists())) then
            if cast.racial() then ui.debug("Casting Berserking [Cooldown]") return true end
        end
        -- Use Item - Elemental Potion of Ultimate Power
        -- potion,if=buff.bs_inc.up|fight_remains<32|(!variable.lastZerk&variable.lastConvoke&cooldown.convoke_the_spirits.remains<10)
        if ui.useCDs() and ui.value("Potion") ~= 2 and (unit.instance("raid") or (unit.instance("party") and unit.ttd(units.dyn5) > 45)) and unit.isBoss("target") then
            if ui.value("Potion") == 1 and use.able.elementalPotionOfUltimatePower() and ((buff.bsInc.exists() or unit.ttdGroup(40)<32
                or (not var.lastZerk and var.lastConvoke and cd.convokeTheSpirits.remains()<10)))
            then
                if use.elementalPotionOfUltimatePower() then ui.debug("Using Potion [Cooldown]") return true end
            end
        end
        -- Use Item - Ashes Of The Embersoul
        -- use_item,name=ashes_of_the_embersoul,if=((buff.smoldering_frenzy.up&(!talent.convoke_the_spirits.enabled|cooldown.convoke_the_spirits.remains<10))|!set_bonus.tier31_4pc&(cooldown.convoke_the_spirits.remains=0|!talent.convoke_the_spirits.enabled&buff.bs_inc.up))
        if useTrinket(items.ashesOfTheEmbersoul) and use.able.ashesOfTheEmbersoul() and ((((buff.smolderingFrenzy.exists() and (not talent.convokeTheSpirits or cd.convokeTheSpirits.remains()<10))
            or not equiped.tier(31,4) and (cd.convokeTheSpirits.remains()==0 or not talent.convokeTheSpirits and buff.bsInc.exists()))))
        then
            if use.ashesOfTheEmbersoul() then ui.debug("Using Ashes Of The Embersoul [Cooldown]") return true end
        end
        -- Use Item - Witherbarks Branch
        -- use_item,name=witherbarks_branch,if=(!talent.convoke_the_spirits.enabled|action.feral_frenzy.ready|!set_bonus.tier31_4pc)&!(trinket.1.is.ashes_of_the_embersoul&trinket.1.cooldown.remains<20|trinket.2.is.ashes_of_the_embersoul&trinket.2.cooldown.remains<20)
        if useTrinket(items.witherbarksBranch) and use.able.witherbarksBranch() and (((not talent.convokeTheSpirits or cast.able.feralFrenzy() or not equiped.tier(31,4))
            and not (equiped.ashesOfTheEmbersoul(13) and cd.slot.remains(13)<20 or equiped.ashesOfTheEmbersoul(14) and cd.slot.remains(14)<20)))
        then
            if use.witherbarksBranch() then ui.debug("Using Witherbarks Branch [Cooldown]") return true end
        end
        -- Use Item - Mirror Of Fractured Tomorrows
        -- use_item,name=mirror_of_fractured_tomorrows,if=(!variable.align_3minutes|buff.bs_inc.up&buff.bs_inc.remains>15|variable.lastConvoke&!variable.lastZerk&cooldown.convoke_the_spirits.remains<1)&(target.time_to_die<fight_remains&target.time_to_die>16|target.time_to_die=fight_remains)
        if useTrinket(items.mirrorOfFracturedTomorrows) and use.able.mirrorOfFracturedTomorrows() and (((not var.align3Minutes or buff.bsInc.exists() and buff.bsInc.remains()>15
            or var.lastConvoke and not var.lastZerk and cd.convokeTheSpirits.remains()<1) and (unit.ttd(units.dyn5)<unit.ttdGroup(40)
            and unit.ttd(units.dyn5)>16 or unit.ttd(units.dyn5)==unit.ttdGroup(40))))
        then
            if use.mirrorOfFracturedTomorrows() then ui.debug("Using Mirror Of Fractured Tomorrows [Cooldown]") return true end
        end
        -- Convoke The Spirits
        -- convoke_the_spirits,target_if=max:target.time_to_die,if=fight_remains<5|(buff.smoldering_frenzy.up|!set_bonus.tier31_4pc)&(dot.rip.remains>4-talent.ashamanes_guidance&buff.tigers_fury.up&combo_points<2)&(debuff.dire_fixation.up|!talent.dire_fixation.enabled|spell_targets.swipe_cat>1)&((target.time_to_die<fight_remains&target.time_to_die>5-talent.ashamanes_guidance.enabled)|target.time_to_die=fight_remains)
        if ui.alwaysCdNever("Convoke The Spirits") and cast.able.convokeTheSpirits() and ((unit.ttdGroup(40)<5 or (buff.smolderingFrenzy.exists() or not equiped.tier(31,4))
            and (debuff.rip.remains(var.maxTTDUnit)>4-talent.ashamanesGuidance and buff.tigersFury.exists() and comboPoints()<2)
            and (debuff.direFixation.exists(var.maxTTDUnit) or not talent.direFixation or #enemies.yards8>1)
            and ((unit.ttd(var.maxTTDUnit)<unit.ttdGroup(40) and unit.ttd(var.maxTTDUnit)>5-talent.ashamanesGuidance) or unit.ttd(var.maxTTDUnit)==unit.ttdGroup(40))))
        then
            if cast.convokeTheSpirits() then ui.debug("Casting Convoke The Spirits [Cooldown]") return true end
        end
        -- Convoke The Spirits
        -- convoke_the_spirits,if=buff.smoldering_frenzy.up&buff.smoldering_frenzy.remains<5.1-talent.ashamanes_guidance
        if ui.alwaysCdNever("Convoke The Spirits") and cast.able.convokeTheSpirits() and buff.smolderingFrenzy.exists()
            and buff.smolderingFrenzy.remains()<5.1-talent.ashamanesGuidance
        then
            if cast.convokeTheSpirits() then ui.debug("Casting Convoke The Spirits [Cooldown - Smoldering Frenzy]") return true end
        end
        -- Use Item - Manic Grieftorch
        -- use_item,name=manic_grieftorch,target_if=max:target.time_to_die,if=energy.deficit>40
        if useTrinket(items.manicGrieftorch) and use.able.manicGrieftorch(var.maxTTDUnit) and energy.deficit()>40 then
            if use.manicGrieftorch(var.maxTTDUnit) then ui.debug("Using Manic Grieftorch [Cooldown]") return true end
        end
        -- Use Item - Mydas Talisman
        -- use_item,name=mydas_talisman,if=!equipped.ashes_of_the_embersoul&!equipped.witherbarks_branch|((trinket.2.is.witherbarks_branch|trinket.2.is.ashes_of_the_embersoul)&trinket.2.cooldown.remains>20)|((trinket.1.is.witherbarks_branch|trinket.1.is.ashes_of_the_embersoul)&trinket.1.cooldown.remains>20)
        if useTrinket(items.mydasTalisman) and use.able.mydasTalisman() and ((not equiped.ashesOfTheEmbersoul() and not equiped.witherbarksBranch()
            or ((equiped.witherbarksBranch(14) or equiped.ashesOfTheEmbersoul(14)) and cd.slot.remains(14)>20)
            or ((equiped.witherbarksBranch(13) or equiped.ashesOfTheEmbersoul(13)) and cd.slot.remains(13)>20)))
        then
            if use.mydasTalisman() then ui.debug("Using Mydas Talisman [Cooldown]") return true end
        end
        -- Use Item - Bandolier Of Twisted Blades
        -- use_item,name=bandolier_of_twisted_blades,if=!equipped.ashes_of_the_embersoul&!equipped.witherbarks_branch|((trinket.2.is.witherbarks_branch|trinket.2.is.ashes_of_the_embersoul)&trinket.2.cooldown.remains>20)|((trinket.1.is.witherbarks_branch|trinket.1.is.ashes_of_the_embersoul)&trinket.1.cooldown.remains>20)
        if useTrinket(items.bandolierOfTwistedBlades) and use.able.bandolierOfTwistedBlades() and ((not equiped.ashesOfTheEmbersoul() and not equiped.witherbarksBranch()
            or ((equiped.witherbarksBranch(14) or equiped.ashesOfTheEmbersoul(14)) and cd.slot.remains(14)>20)
            or ((equiped.witherbarksBranch(13) or equiped.ashesOfTheEmbersoul(13)) and cd.slot.remains(13)>20)))
        then
            if use.bandolierOfTwistedBlades() then ui.debug("Using Bandolier Of Twisted Blades [Cooldown]") return true end
        end
        -- Use Item - Fyrakks Tainted Rageheart
        -- use_item,name=fyrakks_tainted_rageheart,if=!equipped.ashes_of_the_embersoul&!equipped.witherbarks_branch|((trinket.2.is.witherbarks_branch|trinket.2.is.ashes_of_the_embersoul)&trinket.2.cooldown.remains>20)|((trinket.1.is.witherbarks_branch|trinket.1.is.ashes_of_the_embersoul)&trinket.1.cooldown.remains>20)
        if useTrinket(items.fyrakksTaintedRageheart) and use.able.fyrakksTaintedRageheart() and ((not equiped.ashesOfTheEmbersoul() and not equiped.witherbarksBranch()
            or ((equiped.witherbarksBranch(14) or equiped.ashesOfTheEmbersoul(14)) and cd.slot.remains(14)>20)
            or ((equiped.witherbarksBranch(13) or equiped.ashesOfTheEmbersoul(13)) and cd.slot.remains(13)>20)))
        then
            if use.fyrakksTaintedRageheart() then ui.debug("Using Fyrakks Tainted Rageheart [Cooldown]") return true end
        end
        -- Module - Basic Trinkets
        -- use_items
        module.BasicTrinkets()
    end -- End useCooldowns check
end -- End Action List - Cooldowns

-- Action List - Finisher
actionList.Finisher = function()
    -- Pool Resource
    -- pool_resource,for_next=1,if=buff.bs_inc.up
    -- Primal Wrath
    -- primal_wrath,if=(dot.primal_wrath.refreshable|(talent.tear_open_wounds.enabled|(spell_targets.swipe_cat>4&!talent.rampant_ferocity.enabled)))&spell_targets.primal_wrath>1&talent.primal_wrath.enabled
    if cast.able.primalWrath("player","aoe",1,8) and (((debuff.primalWrath.refresh(units.dyn8AOE) or (talent.tearOpenWounds or (#enemies.yards8>4 and not talent.rampantFerocity)))
        and #enemies.yards8>1 and talent.primalWrath))
    then
        if buff.bsInc.exists() then
            if cast.pool.primalWrath() then return true end
        end
        if cast.primalWrath("player","aoe",1,8) then ui.debug("Casting Primal Wrath [Finisher]") return true end
    end
    -- Rip
    -- rip,target_if=((set_bonus.tier31_2pc&cooldown.feral_frenzy.remains<2&dot.rip.remains<10)|(time<8|buff.bloodtalons.up|!talent.bloodtalons.enabled|(buff.bs_inc.up&dot.rip.remains<2))&refreshable)&(!talent.primal_wrath.enabled|spell_targets.swipe_cat=1)&!(buff.smoldering_frenzy.up&dot.rip.remains>2)
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if cast.able.rip(thisUnit) and (((((equiped.tier(31,2) and cd.feralFrenzy.remains()<2 and debuff.rip.remains(thisUnit)<10)
            or (unit.combatTime()<8 or buff.bloodtalons.exists() or not talent.bloodtalons or (buff.bsInc.exists() and debuff.rip.remains(thisUnit)<2))
            and debuff.rip.refresh(thisUnit)) and (not talent.primalWrath or #enemies.yards8==1) and not (buff.smolderingFrenzy.exists() and debuff.rip.remains(thisUnit)>2))))
        then
            if cast.rip(thisUnit) then ui.debug("Casting Rip [Finisher]") return true end
        end
    end
    -- Pool Resource
    -- pool_resource,for_next=1,if=!action.tigers_fury.ready&buff.apex_predators_craving.down
    -- Ferocious Bite
    -- ferocious_bite,max_energy=1,target_if=max:target.time_to_die,if=buff.apex_predators_craving.down&(!buff.bs_inc.up|buff.bs_inc.up&!talent.soul_of_the_forest.enabled)
    if cast.able.ferociousBite(var.maxTTDUnit) and ((energy()>=50 and (not buff.apexPredatorsCraving.exists()
        and (not buff.bsInc.exists() or buff.bsInc.exists() and not talent.soulOfTheForest))))
    then
        if not cast.able.tigersFury() and not buff.apexPredatorsCraving.exists() then
            if cast.pool.ferociousBite() then return true end
        end
        if cast.ferociousBite(var.maxTTDUnit) then ui.debug("Casting Ferocious Bite [Finisher - Max Energy]") return true end
    end
    -- Ferocious Bite
    -- ferocious_bite,target_if=max:target.time_to_die,if=(buff.bs_inc.up&talent.soul_of_the_forest.enabled)|buff.apex_predators_craving.up
    if cast.able.ferociousBite(var.maxTTDUnit) and (((buff.bsInc.exists() and talent.soulOfTheForest) or buff.apexPredatorsCraving.exists())) then
        if cast.ferociousBite(var.maxTTDUnit) then ui.debug("Casting Ferocious Bite [Finisher]") return true end
    end
end -- End Action List - Finisher

-- Action List - Variables
actionList.Variables = function()
    -- Variable - Need Bt
    -- variable,name=need_bt,value=talent.bloodtalons.enabled&buff.bloodtalons.stack<=1
    var.needBt = talent.bloodtalons and buff.bloodtalons.stack()<=1
    -- Variable - Align 3Minutes
    -- variable,name=align_3minutes,value=spell_targets.swipe_cat=1&!fight_style.dungeonslice
    var.align3Minutes = #enemies.yards8==1 and not unit.instance("party")
    -- Variable - Lastconvoke
    -- variable,name=lastConvoke,value=fight_remains>cooldown.convoke_the_spirits.remains+3&((talent.ashamanes_guidance.enabled&fight_remains<(cooldown.convoke_the_spirits.remains+60))|(!talent.ashamanes_guidance.enabled&fight_remains<(cooldown.convoke_the_spirits.remains+120)))
    var.lastConvoke = (unit.ttdGroup(40)>cd.convokeTheSpirits.remains()+3 and ((talent.ashamanesGuidance and unit.ttdGroup(40)<(cd.convokeTheSpirits.remains()+60))
        or (not talent.ashamanesGuidance and unit.ttdGroup(40)<(cd.convokeTheSpirits.remains()+120))))
    -- Variable - Lastzerk
    -- variable,name=lastZerk,value=fight_remains>(30+(cooldown.bs_inc.remains%1.6))&((talent.berserk_heart_of_the_lion.enabled&fight_remains<(90+(cooldown.bs_inc.remains%1.6)))|(!talent.berserk_heart_of_the_lion.enabled&fight_remains<(180+cooldown.bs_inc.remains)))
    var.lastZerk = (unit.ttdGroup(40)>(30+(buff.bsInc.remains()/1.6)) and ((talent.berserkHeartOfTheLion and unit.ttdGroup(40)<(90+(buff.bsInc.remains()/1.6)))
        or (not talent.berserkHeartOfTheLion and unit.ttdGroup(40)<(180+buff.bsInc.remains()))))
    -- Variable - Zerk Biteweave
    -- variable,name=zerk_biteweave,op=reset
    var.zerkBiteweave = false
    -- Variable - Regrowth
    -- variable,name=regrowth,op=reset
    var.regrowth = false
    -- Variable - Easy Swipe
    -- variable,name=easy_swipe,op=reset
    var.easySwipe = false
    -- Variable - Force Align 2Min
    -- variable,name=force_align_2min,op=reset
    var.forceAlign2Min = false
    -- Variable - Align Cds
    -- variable,name=align_cds,value=(variable.force_align_2min|equipped.witherbarks_branch|equipped.ashes_of_the_embersoul|(time+fight_remains>150&time+fight_remains<200|time+fight_remains>270&time+fight_remains<295|time+fight_remains>395&time+fight_remains<400|time+fight_remains>490&time+fight_remains<495))&talent.convoke_the_spirits.enabled&fight_style.patchwerk&spell_targets.swipe_cat=1&set_bonus.tier31_2pc
    var.alignCds = ((var.forceAlign2Min or equiped.witherbarksBranch() or equiped.ashesOfTheEmbersoul() or (unit.combatTime()+unit.ttdGroup(40)>150
        and unit.combatTime()+unit.ttdGroup(40)<200 or unit.combatTime()+unit.ttdGroup(40)>270 and unit.combatTime()+unit.ttdGroup(40)<295
        or unit.combatTime()+unit.ttdGroup(40)>395 and unit.combatTime()+unit.ttdGroup(40)<400 or unit.combatTime()+unit.ttdGroup(40)>490
        and unit.combatTime()+unit.ttdGroup(40)<495)) and talent.convokeTheSpirits and unit.instance("raid") and #enemies.yards8==1 and equiped.tier(31,2))
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
        br.player.actionList = actionList
        buff            = br.player.buff
        cast            = br.player.cast
        cd              = br.player.cd
        charges         = br.player.charges
        comboPoints     = br.player.power.comboPoints
        debuff          = br.player.debuff
        enemies         = br.player.enemies
        energy          = br.player.power.energy
        equiped         = br.player.equiped
        items           = br.player.items
        module          = br.player.module
        race            = br.player.race
        spell           = br.player.spell
        talent          = br.player.talent
        ui              = br.player.ui
        unit            = br.player.unit
        units           = br.player.units
        use             = br.player.use
        var             = br.player.variables

        -- General Variables - Init
        var.friendsInRange = false
        var.getTime = ui.time()
        var.htTimer = var.getTime
        var.lastForm = 0
        var.lastRune = var.getTime
        var.leftCombat = var.getTime
        var.lootDelay = 0
        var.minCount = 3
        var.noDoT = false
        var.profileStop = false
        var.unit5ID = 0

        -- Bloodtalons - Init
        var.btGen = var.btGen or {}
        var.btGen.brutalSlash = false
        var.btGen.moonfireFeral = false
        var.btGen.rake = false
        var.btGen.shred = false
        var.btGen.swipe = false
        var.btGen.thrash = false
        var.btGen.stack = 2
        var.btGen.timer = var.getTime
        var.btGen.triggers = 0

        -- Ticks Gain - Init
        var.ticksGain = var.ticksGain or {}
        var.ticksGain.rake = 5
        var.ticksGain.rip = 12
        var.ticksGain.thrash = 5

        br.player.initialized = true
    end

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    units.get(8,true)
    units.get(5)

    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(40) -- makes enemies.yards40
    enemies.get(20,"player",true) -- makes enemies.yards20nc
    enemies.get(13,"player",false,true) -- makes enemies.yards13f
    enemies.get(8) -- makes enemies.yards8
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(8,"target") -- makes enemies.yards8t
    enemies.get(5,"player",false,true) -- makes enemies.yards5f

    -- General Vars
    var.multidot            = ui.mode.cleave == 1 and ui.mode.rotation < 3
    var.getTime         = br._G.GetTime()
    var.kindredSpirit   = findKindredSpirit()
    var.lootDelay       = ui.checked("Auto Loot") and ui.value("Auto Loot") or 0
    var.minCount        = ui.useCDs() and 1 or 3
    if not unit.inCombat() and not unit.exists("target") then
        if var.profileStop then var.profileStop = false end
        var.leftCombat = var.getTime
    end
    var.btGen = var.btGen or {}
    var.unit5ID = br.GetObjectID(units.dyn5) or 0
    var.noDoT = var.unit5ID == 153758 or var.unit5ID == 156857 or var.unit5ID == 156849 or var.unit5ID == 156865 or var.unit5ID == 156869
    -- Add buff.bsInc.exists()
    buff.bsInc = buff.bsInc or {}
    buff.bsInc.exists = function()
        return buff.berserk.exists() or buff.incarnationAvatarOfAshamane.exists()
    end
    -- Add buff.bsInc.remain()
    buff.bsInc.remains = function()
        if buff.berserk.remain() > 0 then return buff.berserk.remain() end
        if buff.incarnationAvatarOfAshamane.remain() > 0 then return buff.incarnationAvatarOfAshamane.remain() end
        return 0
    end

    -- Friends In Range
    var.solo = #br.friend < 2
    var.friendsInRange = false
    if not var.solo then
        for i = 1, #br.friend do
            if unit.distance(br.friend[i].unit) < 15 then
                var.friendsInRange = true
                break
            end
        end
    end

    -- Variables
    -- variable,name=need_bt,value=talent.bloodtalons.enabled&buff.bloodtalons.down
    var.needBT = talent.bloodtalons and not buff.bloodtalons.exists() or false

    -- Bloodtalons - Reset
    if var.btGen.timer - var.getTime <= 0 or buff.bloodtalons.exists() or not unit.inCombat() then
        if var.btGen.brutalSlash then var.btGen.brutalSlash = false end
        if var.btGen.moonfireFeral then var.btGen.moonfireFeral = false end
        if var.btGen.rake then var.btGen.rake = false end
        if var.btGen.shred then var.btGen.shred = false end
        if var.btGen.swipe then var.btGen.swipe = false end
        if var.btGen.thrash then var.btGen.thrash = false end
        -- var.btGen.timer = var.getTime + 4
    end
    -- if not buff.bloodtalons.exists() and var.btGen.timer - var.getTime > 0 then var.btGen.stack = 2 end
    var.btGen.stack = 2 - buff.bloodtalons.stack()
    var.btGen.triggers = 0
    if not var.btGen.brutalSlash and talent.brutalSlash then var.btGen.triggers = var.btGen.triggers + 1 end
    if not var.btGen.moonfireFeral and talent.lunarInspiration then var.btGen.triggers = var.btGen.triggers + 1 end
    if not var.btGen.rake then var.btGen.triggers = var.btGen.triggers + 1 end
    if not var.btGen.shred then var.btGen.triggers = var.btGen.triggers + 1 end
    if not var.btGen.swipe and not talent.brutalSlash then var.btGen.triggers = var.btGen.triggers + 1 end
    if not var.btGen.thrash then var.btGen.triggers = var.btGen.triggers + 1 end

    -- -- Group Tracking
    -- -- Rake Ticks
    -- var.rakeTicksTotal = function(thisUnit)
    --     return not debuff.rake.exists(thisUnit, "EXACT") and 5 or math.floor(debuff.rake.duration(thisUnit,"EXACT") / 3)
    -- end
    -- var.rakeTicksRemain = function(thisUnit)
    --     return math.floor(debuff.rake.remain(thisUnit,"EXACT") / 3)
    -- end
    -- var.rakeTicksGain = function(thisUnit)
    --     return var.rakeTicksTotal(thisUnit) - var.rakeTicksRemain(thisUnit)
    -- end
    -- var.ticksGain.rake = var.rakeTicksGain(units.dyn5)

    -- -- Rip Ticks
    -- var.ripTicksTotal = function(thisUnit)
    --     return not debuff.rip.exists(thisUnit) and 12 or math.floor(debuff.rip.duration(thisUnit) / 2)
    -- end
    -- var.ripTicksRemain = function(thisUnit)
    --     return math.floor(debuff.rip.remain(thisUnit) / 2)
    -- end
    -- var.ripTicksGain = function(thisUnit)
    --     return var.ripTicksTotal(thisUnit) - var.ripTicksRemain(thisUnit)
    -- end
    -- var.ticksGain.rip = var.ripTicksGain(units.dyn5)

    -- -- Thrash Ticks
    -- var.thrashCatTicksTotal = function(thisUnit)
    --     return not debuff.thrashCat.exists(thisUnit) and 5 or math.floor(debuff.thrashCat.duration(thisUnit) / 3)
    -- end
    -- var.thrashCatTicksRemain = function(thisUnit)
    --     return math.floor(debuff.thrashCat.remain(thisUnit) / 3)
    -- end
    -- var.thrashCatTicksGain = function(thisUnit)
    --     return var.thrashCatTicksTotal(thisUnit) - var.thrashCatTicksRemain(thisUnit)
    -- end
    -- var.ticksGain.thrash = var.thrashCatTicksGain("target")

    -- -- Moonfire Cat Ticks
    -- var.moonfireFeralTicksTotal = function(thisUnit)
    --     return not debuff.moonfireCat.exists(thisUnit) and 8 or math.floor(debuff.moonfireCat.remain(thisUnit) / 2)
    -- end
    -- var.moonfireFeralTicksRemain = function(thisUnit)
    --     return math.floor(debuff.moonfireCat.remain(thisUnit) / 2)
    -- end
    -- var.moonfireFeralTicksGain = function(thisUnit)
    --     return var.moonfireFeralTicksTotal(thisUnit) - var.moonfireFeralTicksRemain(thisUnit)
    -- end
    -- var.ticksGain.moonfireFeral = var.moonfireFeralTicksGain("target")

    -- -- Total Ticks Gain / Min TTD / Max TTD
    -- var.maxTTD = 0
    -- var.maxTTDUnit = units.dyn5
    -- var.maxRakePan = 0
    -- var.maxRakePanUnit = units.dyn5
    -- var.maxRakePanTicksGain = 0
    -- var.maxRakePanTicksGainUnit = units.dyn5
    -- var.maxRakePanTicksGain25 = 0
    -- var.maxRakePanTicksGain25Unit = units.dyn5
    -- var.minTTD = 999
    -- var.minTTDUnit = units.dyn5
    -- var.adaptiveSwarm = units.dyn5
    -- for i = 1, #enemies.yards40 do
    --     local thisUnit = enemies.yards40[i]
    --     local thisTTD = unit.ttd(thisUnit) or 99
    --     if not unit.isUnit("target",thisUnit) then
    --         -- Adaptive Swarm Effectiveness - target_if=max:(1+dot.adaptive_swarm_damage.stack)*dot.adaptive_swarm_damage.stack<3*time_to_die
    --         if (1 + debuff.adaptiveSwarmDamage.stack(thisUnit)) * debuff.adaptiveSwarmDamage.stack(thisUnit) < 3 * thisTTD then
    --             var.adaptiveSwarmUnit = thisUnit
    --         end
    --         -- Moonfire Cat Ticks to Gain
    --         if var.ticksGain.moonfireFeral + var.moonfireFeralTicksGain(thisUnit) > var.ticksGain.moonfireFeral then
    --             var.ticksGain.moonfireFeral = var.ticksGain.moonfireFeral + var.moonfireFeralTicksGain(thisUnit)
    --         end
    --         -- 8 Yards Checks
    --         if unit.distance(thisUnit) < 8 then
    --             -- Thrash Ticks to Gain
    --             var.ticksGain.thrash = var.ticksGain.thrash + var.thrashCatTicksGain(thisUnit)
    --             -- Primal Wrath Ticks to Gain
    --             if talent.primalWrath then
    --                 var.ticksGain.rip = var.ticksGain.rip + var.ripTicksGainUnit(thisUnit)
    --             end
    --         end
    --         -- 5 Yards Checks
    --         if unit.distance(thisUnit) < 5 and unit.facing(thisUnit) then
    --             -- Rip Ticks to Gain
    --             if not talent.primalWrath then
    --                 var.ticksGain.rip = var.ticksGain.rip + var.ripTicksGain(thisUnit)
    --             end
    --             -- Rake Ticks to Gain
    --             var.ticksGain.rake = var.ticksGain.rake + var.rakeTicksGain(thisUnit)
    --             -- Max Rake Pandemic - max:dot.rake.pmultiplier<1.6|dot.rake.refreshable
    --             if (debuff.rake.pmultiplier(thisUnit) < 1.6 or debuff.rake.refresh(thisUnit)) and var.rakeTicksGain(thisUnit) > var.maxRakePan then
    --                 var.maxRakePan = var.rakeTicksGain(thisUnit)
    --                 var.maxRakePanUnit = thisUnit
    --             end
    --             -- Max Rake Pandemic Ticks to Gain - max:(dot.rake.pmultiplier<1.6|dot.rake.refreshable)*druid.rake.ticks_gained_on_refresh
    --             local rakeRefreshPan = 0
    --             if debuff.rake.pmultiplier(thisUnit) < 1.6 or debuff.rake.refresh(thisUnit) then
    --                 rakeRefreshPan = 1
    --             end
    --             if rakeRefreshPan * var.rakeTicksGain(thisUnit) > var.maxRakePanTicksGain then
    --                 var.maxRakePanTicksGain = rakeRefreshPan * var.rakeTicksGain(thisUnit)
    --                 var.maxRakePanTicksGainUnit = thisUnit
    --             end
    --             -- max:((dot.rake.pmultiplier<=persistent_multiplier)*25)+druid.rake.ticks_gained_on_refresh
    --             local rakeRefreshPan25 = 0
    --             if debuff.rake.pmultiplier(thisUnit) < 1.6 or debuff.rake.refresh(thisUnit) then
    --                 rakeRefreshPan25 = var.rakeTicksGain(thisUnit)
    --             end
    --             if rakeRefreshPan25 * 25 + var.rakeTicksGain(thisUnit) > var.maxRakePanTicksGain then
    --                 var.maxRakePanTicksGain25 = rakeRefreshPan25 * 25 + var.rakeTicksGain(thisUnit)
    --                 var.maxRakePanTicksGain25Unit = thisUnit
    --             end
    --         end
    --         if thisTTD < var.minTTD then var.minTTD = thisTTD var.minTTDUnit = thisUnit end
    --         if thisTTD > var.maxTTD then var.maxTTD = thisTTD var.maxTTDUnit = thisUnit end
    --     end
    -- end

    -- var.ripTicksGainUnit = function(ripUnit)
    --     return var.ripTicksGain(ripUnit)
    -- end

    -- var.rakeTicksGainUnit = function(rakeUnit)
    --     return var.rakeTicksGain(rakeUnit)
    -- end

    -- var.moonfireFeralTicksGainUnit = function(moonfireFeralUnit)
    --     return var.moonfireFeralTicksGain(moonfireFeralUnit)
    -- end

    -- var.maxRakeTicksGain = 0
    -- var.maxRakeTicksGainUnit = "target"
    -- var.lowestRip = 99
    -- var.lowestRipUnit = var.lowestTTDUnit
    -- for i = 1, #enemies.yards5f do
    --     local thisUnit = enemies.yards5f[i]
    --     -- Rake
    --     local rakeTicksGain = var.rakeTicksGainUnit(thisUnit)
    --     if rakeTicksGain > var.maxRakeTicksGain then
    --         var.maxRakeTicksGain = rakeTicksGain
    --         var.maxRakeTicksGainUnit = thisUnit
    --     end
    --     -- Rip
    --     if talent.sabertooth then
    --         local ripValue = debuff.rip.remains(thisUnit)
    --         if ripValue > unit.gcd(thisUnit) and ripValue < var.lowestRip then
    --             var.lowestRip = ripValue
    --             var.lowestRipUnit = thisUnit
    --         end
    --     end
    -- end
    -- var.maxMoonfireFeralTicksGain = 0
    -- var.maxMoonfireFeralTicksGainUnit = "target"
    -- var.moonfireRefresh = 0
    -- var.moonfireRefreshUnit = "target"
    -- for i = 1, #enemies.yards40 do
    --     local thisUnit = enemies.yards40[i]
    --     -- Moonfire Cat
    --     local moonfireFeralTicksGain = var.moonfireFeralTicksGainUnit(thisUnit)
    --     -- max:((ticks_gained_on_refresh+1)-(spell_targets.swipe_cat*2.492))
    --     if moonfireFeralTicksGain > ((var.maxMoonfireFeralTicksGain + 1) - (#enemies.yards8 * 2.492)) then
    --         var.maxMoonfireFeralTicksGain = moonfireFeralTicksGain
    --         var.maxMoonfireFeralTicksGainUnit = thisUnit
    --     end
    --     -- max:(3*refreshable)+dot.adaptive_swarm_damage.ticking
    --     if talent.lunarInspiration then
    --         local moonfireRefresh = 3 * (debuff.moonfireCat.refresh(thisUnit) and 1 or 0) + (debuff.adaptiveSwarmDamage.exists(thisUnit) and 1 or 0)
    --         if moonfireRefresh > var.moonfireRefresh then
    --             var.moonfireRefresh = moonfireRefresh
    --             var.moonfireRefreshUnit = thisUnit
    --         end
    --     end
    -- end

    -- target_if=min:target.time_to_die
    var.minTTD=99999
    var.minTTDUnit="target"
    for i=1,#enemies.yards5f do
        local thisUnit=enemies.yards5f[i]
        local thisCondition=unit.ttd(thisUnit)
        if thisCondition<var.minTTD then
            var.minTTD=thisCondition
            var.minTTDUnit=thisUnit
        end
    end

    -- target_if=max:(1+dot.adaptive_swarm_damage.stack)*dot.adaptive_swarm_damage.stack<3*time_to_die
    var.maxAdaptiveSwarm=0
    var.maxAdaptiveSwarmUnit="target"
    for i=1,#enemies.yards40 do
        local thisUnit=enemies.yards40[i]
        local toNumeric = debuff.adaptiveSwarmDamage.count(thisUnit)<3 and 1 or 0
        local thisCondition=(1+debuff.adaptiveSwarmDamage.count(thisUnit))*toNumeric*unit.ttd(thisUnit)
        if thisCondition>var.maxAdaptiveSwarm then
            var.maxAdaptiveSwarm=thisCondition
            var.maxAdaptiveSwarmUnit=thisUnit
        end
    end

    -- target_if=max:dot.rake.pmultiplier<1.6|dot.rake.refreshable
    var.maxProwlRakeRefresh=0
    var.maxProwlRakeRefreshUnit="target"
    for i=1,#enemies.yards5f do
        local thisUnit=enemies.yards5f[i]
        local thisCondition=(debuff.rake.pmultiplier(thisUnit)<1.6 or debuff.rake.refresh(thisUnit))
        if thisCondition and unit.ttd(thisUnit)>var.maxProwlRakeRefresh then
            var.maxProwlRakeRefresh=unit.ttd(thisUnit)
            var.maxProwlRakeRefreshUnit=thisUnit
        end
    end

    -- target_if=max:(dot.rake.pmultiplier<1.6|dot.rake.refreshable)*druid.rake.ticks_gained_on_refresh
    var.maxRakeRefreshTicksGain=0
    var.maxRakeRefreshTicksGainUnit="target"
    for i=1,#enemies.yards5f do
        local thisUnit=enemies.yards5f[i]
        local toNumeric = (debuff.rake.pmultiplier(thisUnit)<1.6 or debuff.rake.refresh(thisUnit)) and 1 or 0
        local thisCondition=(toNumeric*debuff.rake.ticksGainedOnRefresh(thisUnit))
        if thisCondition>var.maxRakeRefreshTicksGain then
            var.maxRakeRefreshTicksGain=thisCondition
            var.maxRakeRefreshTicksGainUnit=thisUnit
        end
    end

    -- target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking
    var.maxMoonfireRefreshAdaptive=0
    var.maxMoonfireRefreshAdaptiveUnit="target"
    for i=1,#enemies.yards40 do
        local thisUnit=enemies.yards40[i]
        local toNumeric = (debuff.moonfireCat.refresh(thisUnit) and 1 or 0)
        local toNumeric2 = (debuff.adaptiveSwarmDamage.exists(thisUnit) and 1 or 0)
        local thisCondition=(3*toNumeric)+toNumeric2
        if thisCondition>var.maxMoonfireRefreshAdaptive then
            var.maxMoonfireRefreshAdaptive=thisCondition
            var.maxMoonfireRefreshAdaptiveUnit=thisUnit
        end
    end

    -- target_if=max:dot.moonfire.ticks_gained_on_refresh
    var.maxMoonfireFeralTicksGain=0
    var.maxMoonfireFeralTicksGainUnit="target"
    for i=1,#enemies.yards40 do
        local thisUnit=enemies.yards40[i]
        local thisCondition=debuff.moonfire.ticksGainedOnRefresh(thisUnit)
        if thisCondition>var.maxMoonfireFeralTicksGain then
            var.maxMoonfireFeralTicksGain=thisCondition
            var.maxMoonfireFeralTicksGainUnit=thisUnit
        end
    end

    -- target_if=max:((dot.rake.pmultiplier<=persistent_multiplier)*25)+druid.rake.ticks_gained_on_refresh
    var.maxRakeRefresh25=0
    var.maxRakeRefresh25Unit="target"
    for i=1,#enemies.yards5f do
        local thisUnit=enemies.yards5f[i]
        local toNumeric = (debuff.rake.pmultiplier(thisUnit)<=debuff.rake.applied(thisUnit)) and 1 or 0
        local thisCondition=(toNumeric*25)+debuff.rake.ticksGainedOnRefresh(thisUnit)
        if thisCondition>var.maxRakeRefresh25 then
            var.maxRakeRefresh25=thisCondition
            var.maxRakeRefresh25Unit=thisUnit
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation==4 then
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
        -- Cat is 4 fyte!
        if unit.inCombat() and cast.able.catForm("player") and not buff.catForm.exists() and not buff.moonkinForm.exists()
            and #enemies.yards5f > 0 and not unit.moving() and ui.checked("Auto Shapeshifts")
        then
            if cast.catForm("player") then ui.debug("Casting Cat Form [Combat]"); return true end
        elseif (unit.inCombat() or (not unit.inCombat() and unit.valid("target"))) and (buff.catForm.exists() or buff.moonkinForm.exists()) and not var.profileStop
            and not ui.checked("Death Cat Mode") and unit.exists("target") and cd.global.remain() == 0
        then
            -- Wild Charge
            if ui.checked("Wild Charge")
                and cast.able.wildCharge("player") and unit.valid("target")
            then
                if cast.wildCharge("target") then ui.debug("Casting Wild Charge on "..unit.name("target").." [Out of Melee]"); return true end
            end
            -------------------------
            --- In Combat - Begin ---
            -------------------------
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if ui.value("APL Mode") == 1 and unit.inCombat() then
                -- Ferocious Bite
                for i = 1, #enemies.yards5f do
                    local thisUnit = enemies.yards5f[i]
                    if cast.able.ferociousBite(thisUnit) and unit.distance(units.dyn5) < 5 then
                        -- execute
                        if ferociousBiteFinish(thisUnit) and not usePrimalWrath() then
                            if ui.value("Ferocious Bite Execute") == 1 and ferociousBiteFinish(thisUnit) then
                                ui.print("Ferocious Bite Finished! "..unit.name(thisUnit).." with "..br.round2(unit.hp(thisUnit),0).."% health remaining.")
                            end
                            if cast.ferociousBite(thisUnit) then ui.debug("Casting Ferocious Bite on "..unit.name(thisUnit).." [Execute]"); return true end
                        end
                    end
                end
                -- Call Action List - Interrupts
                if actionList.Interrupts() then return true end
                -- Prowl
                -- prowl,if=buff.bs_inc.down
                if cast.able.prowl("player") and buff.catForm.exists() and autoProwl()
                    and ui.mode.prowl == 1 and not buff.prowl.exists() and not unit.resting()
                    and not buff.bsInc.exists()
                then
                    if cast.prowl("player") then ui.debug("Casting Prowl") return true end
                end
                -- Call Action List - Variables
                -- call_action_list,name=variables
                if actionList.Variables() then return true end
                -- Tigers Fury
                -- tigers_fury,target_if=min:target.time_to_die,if=!set_bonus.tier31_4pc&talent.convoke_the_spirits.enabled|!buff.tigers_fury.up|energy.deficit>65|set_bonus.tier31_2pc&action.feral_frenzy.ready|target.time_to_die<15&talent.predator.enabled
                if cast.able.tigersFury() and ((not equiped.tier(31,4) and talent.convokeTheSpirits
                    or not buff.tigersFury.exists() or energy.deficit()>65 or equiped.tier(31,2)
                    and cast.able.feralFrenzy() or unit.ttd(var.minTTDUnit)<15 and talent.predator))
                then
                    if cast.tigersFury() then ui.debug("Casting Tigers Fury") return true end
                end
                -- Rake
                -- rake,target_if=persistent_multiplier>dot.rake.pmultiplier,if=buff.prowl.up|buff.shadowmeld.up
                for i = 1, #enemies.yards5f do
                    local thisUnit = enemies.yards5f[i]
                    if cast.able.rake(thisUnit) and ((debuff.rake.applied(thisUnit)>debuff.rake.pmultiplier(thisUnit)
                        and (buff.prowl.exists() or buff.shadowmeld.exists())))
                    then
                        if cast.rake(thisUnit) then ui.debug("Casting Rake") return true end
                    end
                end
                -- Auto Attack
                -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
                if cast.able.autoAttack(units.dyn5) and not buff.prowl.exists() and not buff.shadowmeld.exists() then
                    if cast.autoAttack(units.dyn5) then ui.debug("Casting Auto Attack") return true end
                end
                -- Natures Vigil
                -- natures_vigil,if=spell_targets.swipe_cat>0
                if cast.able.naturesVigil() and #enemies.yards8>0 then
                    if cast.naturesVigil() then ui.debug("Casting Natures Vigil") return true end
                end
                -- Renewal
                -- renewal,if=variable.regrowth
                if cast.able.renewal() and var.regrowth then
                    if cast.renewal() then ui.debug("Casting Renewal") return true end
                end
                -- Adaptive Swarm
                -- adaptive_swarm,target_if=(!dot.adaptive_swarm_damage.ticking|dot.adaptive_swarm_damage.remains<2)&dot.adaptive_swarm_damage.stack<3&!action.adaptive_swarm_damage.in_flight&!action.adaptive_swarm.in_flight&target.time_to_die>5,if=!talent.unbridled_swarm.enabled|spell_targets.swipe_cat=1
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if cast.able.adaptiveSwarm(thisUnit) and ((((not debuff.adaptiveSwarmDamage.exists(thisUnit) or debuff.adaptiveSwarmDamage.remains(thisUnit)<2)
                        and debuff.adaptiveSwarmDamage.count(thisUnit)<3 and not cast.inFlight.adaptiveSwarmDamage() and not cast.inFlight.adaptiveSwarm()
                        and unit.ttd(thisUnit)>5) and (not talent.unbridledSwarm or #enemies.yards8==1)))
                    then
                        if cast.adaptiveSwarm(thisUnit) then ui.debug("Casting Adaptive Swarm") return true end
                    end
                end
                -- Adaptive Swarm
                -- adaptive_swarm,target_if=max:(1+dot.adaptive_swarm_damage.stack)*dot.adaptive_swarm_damage.stack<3*time_to_die,if=dot.adaptive_swarm_damage.stack<3&talent.unbridled_swarm.enabled&spell_targets.swipe_cat>1
                if cast.able.adaptiveSwarm(var.maxAdaptiveSwarmUnit) and debuff.adaptiveSwarmDamage.count(var.maxAdaptiveSwarmUnit)<3
                    and talent.unbridledSwarm and #enemies.yards40>1
                then
                    if cast.adaptiveSwarm(var.maxAdaptiveSwarmUnit) then ui.debug("Casting Adaptive Swarm - Unbridled Swarm") return true end
                end
                -- Call Action List - Cooldown
                -- call_action_list,name=cooldown,if=(time>3|!talent.dire_fixation.enabled|debuff.dire_fixation.up&combo_points<4|spell_targets.swipe_cat>1)&!(spell_targets=1&talent.convoke_the_spirits.enabled)
                if ((unit.combatTime()>3 or not talent.direFixation or debuff.direFixation.exists(units.dyn5) and comboPoints()<4 or #enemies.yards8>1)
                    and not (#enemies.yards8==1 and talent.convokeTheSpirits))
                then
                    if actionList.Cooldown() then return true end
                end
                -- Call Action List - Cooldown
                -- call_action_list,name=cooldown,if=dot.rip.ticking
                if debuff.rip.exists(units.dyn5) then
                    if actionList.Cooldown() then return true end
                end
                -- Feral Frenzy
                -- feral_frenzy,target_if=max:target.time_to_die,if=((combo_points<3|time<10&combo_points<4)&(!talent.dire_fixation.enabled|debuff.dire_fixation.up|spell_targets.swipe_cat>1)&(target.time_to_die<fight_remains&target.time_to_die>6|target.time_to_die=fight_remains))&!(spell_targets=1&talent.convoke_the_spirits.enabled)
                if cast.able.feralFrenzy() and ((((comboPoints()<3 or unit.combatTime()<10 and comboPoints()<4)
                    and (not talent.direFixation or debuff.direFixation.exists(var.maxTTDUnit) or #enemies.yards8>1)
                    and (unit.ttd(var.maxTTDUnit)<unit.ttdGroup(40) and unit.ttd(var.maxTTDUnit)>6 or unit.ttd(var.maxTTDUnit)==unit.ttdGroup(40)))
                    and not (#enemies.yards5f==1 and talent.convokeTheSpirits)))
                then
                    if cast.feralFrenzy() then ui.debug("Casting Feral Frenzy - AOE") return true end
                end
                -- Feral Frenzy
                -- feral_frenzy,if=combo_points<3&debuff.dire_fixation.up&dot.rip.ticking&(spell_targets=1&talent.convoke_the_spirits.enabled)
                if cast.able.feralFrenzy() and comboPoints()<3 and debuff.direFixation.exists(units.dyn5)
                    and debuff.rip.exists(units.dyn5) and (#enemies.yards5f==1 and talent.convokeTheSpirits)
                then
                    if cast.feralFrenzy() then ui.debug("Casting Feral Frenzy") return true end
                end
                -- Ferocious Bite
                -- ferocious_bite,target_if=max:target.time_to_die,if=buff.apex_predators_craving.up&(spell_targets.swipe_cat=1|!talent.primal_wrath.enabled|!buff.sabertooth.up)&!(variable.need_bt&active_bt_triggers=2)
                if cast.able.ferociousBite(var.maxTTDUnit) and ((buff.apexPredatorsCraving.exists() and (#enemies.yards8==1 or not talent.primalWrath or not buff.sabertooth.exists())
                    and not (var.needBt and var.btGen.triggers==2)))
                then
                    if cast.ferociousBite(var.maxTTDUnit) then ui.debug("Casting Ferocious Bite") return true end
                end
                -- Call Action List - Berserk
                -- run_action_list,name=berserk,if=buff.bs_inc.up
                if buff.bsInc.exists() then
                    if actionList.Berserk() then return true end
                end
                -- Wait
                -- wait,sec=combo_points=5,if=combo_points=4&buff.predator_revealed.react&energy.deficit>40&spell_targets.swipe_cat=1
                if comboPoints()==4 and buff.predatorRevealed.exists() and energy.deficit()>40 and #enemies.yards8==1 then
                    local waitFor = comboPoints()==5
                    if cast.wait(waitFor, function() return true end) then ui.debug("Waiting for Sec=Combo Points=5") return false end
                end
                -- Action List - Finisher
                -- call_action_list,name=finisher,if=combo_points>=4
                if comboPoints()>=4 then
                    if actionList.Finisher() then return true end
                end
                -- Action List - Aoe Builder
                -- call_action_list,name=aoe_builder,if=spell_targets.swipe_cat>1&combo_points<4
                if #enemies.yards8>1 and comboPoints()<4 then
                    if actionList.AoeBuilder() then return true end
                end
                -- Action List - Builder
                -- call_action_list,name=builder,if=!buff.bs_inc.up&spell_targets.swipe_cat=1&combo_points<4
                if not buff.bsInc.exists() and #enemies.yards8==1 and comboPoints()<4 then
                    if actionList.Builder() then return true end
                end
                -- Regrowth
                -- regrowth,if=energy<25&buff.predatory_swiftness.up&!buff.clearcasting.up&variable.regrowth
                if cast.able.regrowth() and energy()<25 and buff.predatorySwiftness.exists() and not buff.clearcasting.exists() and var.regrowth then
                    if cast.regrowth() then ui.debug("Casting Regrowth") return true end
                end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation

local id = 103
br.rotations[id] = br.rotations[id] or {}
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})


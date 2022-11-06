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
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.berserk },
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
            -- Covenant Ability
            br.ui:createDropdownWithout(section,"Covenant Ability",{"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}, 2, "|cffFFFFFFSet when to use Covenant Ability")
            -- Tiger's Fury
            br.ui:createCheckbox(section,"Tiger's Fury")
            br.ui:createDropdownWithout(section,"Snipe Tiger's Fury", {"|cff00FF00Enabled","|cffFF0000Disabled"}, 1, "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFuse of Tiger's Fury to take adavantage of Predator talent.")
            -- Berserk / Incarnation: King of the Jungle
            br.ui:createCheckbox(section,"Berserk/Incarnation")
            -- Owlweave
            br.ui:createDropdownWithout(section,"Owlweave",{"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}, 3, "|cffFFFFFFSet when to use Owlweaving.")
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
local anima
local buff
local cast
local cd
local charges
local comboPoints
local conduit
local covenant
local debuff
local enemies
local energy, energyDeficit
local equiped
local module
local power
local spell
local talent
local unit
local units
local use
local ui
local var = {}

-- General Locals
local btGen = {}
local multidot
local race
local range
local ticksGain = {}

-- Variables
var.bsInc = 0
var.clearcasting = 0
var.fbMaxEnergy = false
var.friendsInRange = false
var.getTime = br._G.GetTime()
var.htTimer = var.getTime
var.incarnation = 0
var.lastForm = 0
var.lastRune = var.getTime
var.leftCombat = var.getTime
var.lootDelay = 0
var.minCount = 3
var.noDoT = false
var.profileStop = false
var.sabertooth = 0
var.unit5ID = 0


-- Bloodtalons - Init
btGen.brutalSlash = false
btGen.moonfireFeral = false
btGen.rake = false
btGen.shred = false
btGen.swipe = false
btGen.thrash = false
btGen.stack = 2
btGen.timer = var.getTime
btGen.triggers = 0

-- Tick Remain - Init
ticksGain.rake = 5
ticksGain.rip = 12
ticksGain.thrash = 5

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
                if unit.distance(thisUnit) < threatRange and react < 4 and unit.enemy(thisUnit) and unit.canAttack(thisUnit) then
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
        and (multidot or (unit.isUnit(thisUnit,units.dyn5) and not multidot))
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
-- TF Predator Snipe
local function snipeTF()
    if ui.value("Snipe Tiger's Fury") == 1 and talent.predator and not cd.tigersFury.exists()
        and (#enemies.yards40 == 1 and unit.ttd(units.dyn40) > power.energy.ttm()) or #enemies.yards40 > 1
    then
        local lowestUnit = units.dyn5
        local lowestHP = 100
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            local thisHP = unit.hp(thisUnit)
            if thisHP < lowestHP then
                lowestHP = thisHP
                lowestUnit = thisUnit
            end
        end
        local timeTillDeath = 99
        local longestBleed = math.max(debuff.rake.remain(lowestUnit,"EXACT"), debuff.rip.remain(lowestUnit),
            debuff.thrashCat.remain(lowestUnit), debuff.feralFrenzy.remain(lowestUnit))
        if unit.ttd(lowestUnit) > 0 then timeTillDeath = unit.ttd(lowestUnit) end
        if lowestUnit ~= nil and timeTillDeath < longestBleed then return true end
    end
    return false
end
-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local GetSpellDescription = br._G["GetSpellDescription"]
    local desc = GetSpellDescription(spell.ferociousBite)
    local damage = 0
    local finishHim = false
    if ui.value("Ferocious Bite Execute") ~= 3 and comboPoints > 0 and not unit.isDummy(thisUnit) then
        local comboStart = desc:find(" "..comboPoints.." ",1,true)
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

--------------------
--- Action Lists ---
--------------------
local actionList = {}
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
        -- Lycara's Bargin - Torghast Anima Power
        if anima.lycarasBargin.exists() and debuff.lycarasBargin.stack("player") > 50 then
            if unit.form() ~= 0 then
                unit.cancelForm()
                ui.debug("Cancel Form [Lycara's Bargin]")
            elseif unit.form() == 0 then
                if cast.catForm("player") then ui.debug("Casting Cat From [Lycara's Bargin]") return true end
            end
        end
        -- Lycara's Twig - Torghast Anima Power
        if anima.lycarasTwig.exists() and not buff.lycarasTwig.exists() and not buff.prowl.exists() and not unit.inCombat() and ui.useCDs() and unit.distance("target") < 60 then
            if unit.form() ~= 0 then
                unit.cancelForm()
                ui.debug("Cancel Form [Lycara's Twig]")
            elseif unit.form() == 0 then
                if cast.catForm("player") then ui.debug("Casting Cat From [Lycara's Twig]") return true end
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
            if cast.able.tigersFury() and energyDeficit > 60 then
                if cast.tigersFury() then ui.debug("Casting Tiger's Fury [Death Cat Mode]") return true end
            end
            -- Savage Roar - Use Combo Points
            if cast.able.savageRoar() and comboPoints >= 5 then
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
                    and comboPoints > 0 and not buff.fieryRedMaimers.exists()
                then
                    if cast.maim(thisUnit) then ui.debug("Casting Maim on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
        -- Adaptive Swarm
        -- adaptive_swarm,target_if=((!dot.adaptive_swarm_damage.ticking|dot.adaptive_swarm_damage.remains<2)&(dot.adaptive_swarm_damage.stack<3|!dot.adaptive_swarm_heal.stack>1)&!action.adaptive_swarm_heal.in_flight&!action.adaptive_swarm_damage.in_flight&!action.adaptive_swarm.in_flight)&target.time_to_die>5|active_enemies>2&!dot.adaptive_swarm_damage.ticking&energy<35&target.time_to_die>5
        if ui.alwaysCdNever("Covenant Ability") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if ((not debuff.adaptiveSwarm.exists(thisUnit) or debuff.adaptiveSwarm.remains(thisUnit) < 2)
                    and (debuff.adaptiveSwarm.stack(thisUnit) < 3 or not buff.adaptiveSwarmHeal.stack() > 1)
                        and cast.inFlight.adaptiveSwarmHeal() and not cast.inFlight.adaptiveSwarm(thisUnit))
                    and unit.ttd(thisUnit) > 5 or #enemies.yards40 > 2 and not debuff.adaptiveSwarm.exists(thisUnit) and energy < 35 and unit.ttd(thisUnit) > 5
                then
                    if cast.adaptiveSwarm(thisUnit) then ui.debug("Casting Adaptive Swarm [Necrolord]") return true end
                end
            end
        end
        if ui.checked("Berserk/Incarnation") and ui.useCDs() and range.dyn5 then
            -- Berserk
            -- berserk
            if cast.able.berserk() and not talent.incarnationAvatarOfAshamane then
                if cast.berserk() then ui.debug("Casting Berserk") return true end
            end
            -- Incarnation - King of the Jungle
            -- incarnation
            if cast.able.incarnationAvatarOfAshamane() and talent.incarnationAvatarOfAshamane then
                if cast.incarnationAvatarOfAshamane() then ui.debug("Casting Incarnation: King of the Jungle") return true end
            end
        end
        -- Convoke the Spirits
        -- convoke_the_spirits,if=buff.tigers_fury.up&combo_points<3|fight_remains<5
        if ui.alwaysCdNever("Covenant Ability") and ((not talent.convokeTheSpiritsFeral and cast.able.convokeTheSpirits()) or (talent.convokeTheSpiritsFeral and cast.able.convokeTheSpiritsFeral())) 
            and ((buff.tigersFury.exists() and comboPoints < 3) or (unit.ttdGroup(5) < 5 and ui.useCDs() and not unit.isDummy(units.dyn5)))
        then
            if talent.convokeTheSpiritsFeral then
                if cast.convokeTheSpiritsFeral() then ui.debug("Casting Convoke the Spirits [Talent]") return true end
            else
                if cast.convokeTheSpirits() then ui.debug("Casting Convoke the Spirits [Night Fae]") return true end
            end
        end
        -- Racial: Berserking (Troll)
        -- berserking
        if ui.checked("Racial") and race == "Troll" and cast.able.racial() and ui.useCDs() then
            if cast.racial() then ui.debug("Casting Berserking") return true end
        end
        -- Shadowmeld
        -- shadowmeld,if=buff.tigers_fury.up&buff.bs_inc.down&combo_points<4&buff.sudden_ambush.down&dot.rake.pmultiplier<1.6&energy>40&druid.rake.ticks_gained_on_refresh>spell_targets.swipe_cat*2-2&target.time_to_die>5
        if ui.checked("Racial") and race == "NightElf" and cast.able.racial() and ui.useCDs() and not unit.moving()
            and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 and not var.solo and var.friendsInRange
        then
            if buff.tigersFury.exists() and not buff.berserk.exists() and not buff.incarnationAvatarOfAshamane.exists()
                and not buff.prowl.exists() and comboPoints < 4 and not buff.suddenAmbush.exists() and debuff.rake.applied(units.dyn5) < 1.6 and energy > 40
                and var.rakeTicksGainUnit(var.maxRakeTicksGainUnit) > (#enemies.yards8 * 2) - 2 and unit.ttd(units.dyn5) > 5
            then
                if cast.racial() then ui.debug("Casting Shadowmeld") return true end
            end
        end
        -- Potion
        -- potion,if=buff.bs_inc.up|fight_remains<cooldown.bs_inc.remains|fight_remains<25
        if ui.value("Potion") ~= 2 and unit.isBoss("target") then
            if ((unit.instance("raid") or (unit.instance("party") and unit.ttd(units.dyn5) > 45)) and (buff.berserk.exists() and buff.berserk.remain() > 18
                or buff.incarnationAvatarOfAshamane.exists() and buff.incarnationAvatarOfAshamane.remain() > 28))
            then
                if ui.value("Potion") == 1 and use.able.potionOfSpectralAgility() then
                    use.potionOfSpectralAgility()
                    ui.debug("Using Potion of Spectral Agility");
                end
            end
        end
        -- Trinkets
        module.BasicTrinkets()
    end -- End useCooldowns check
end -- End Action List - Cooldowns

-- Action List - Berserk Builders
actionList.BerserkBuilders = function()
    if talent.berserk then
        -- Rake
        -- rake,target_if=refreshable
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if cast.able.rake(thisUnit) and range.dyn5 and canDoT(thisUnit) and debuff.rake.refresh(thisUnit) then
                if cast.rake(thisUnit) then ui.debug("Casting Rake [Berserk Builders]") return true end
            end
        end
        -- Swipe
        -- swipe_cat,if=spell_targets.swipe_cat>variable.swipe_v_shred
        if cast.able.swipeCat("player","aoe",1,8) and (#enemies.yards8 > var.swipeVShred) then
            if cast.swipeCat("player","aoe",1,8) then ui.debug("Casting Swipe [Berserk Builders]") return true end
        end
        -- Shred
        -- shred
        if cast.able.shred() then
            if cast.shred() then ui.debug("Casting Shred [Berserk Builders]") return true end
        end
    end
end

-- Action List - Finisher
actionList.Finisher = function()
    -- Primal Wrath
    -- primal_wrath,if=spell_targets.primal_wrath>variable.pw_v_fb
    if cast.able.primalWrath("player","aoe",1,8) and range.dyn8AOE and #enemies.yards8 > var.pwVFb then
        if cast.primalWrath("player","aoe",1,8) then ui.debug("Casting Primal Wrath [Finish]") return true end
    end
    -- primal_wrath,target_if=refreshable,if=spell_targets.primal_wrath>1
    for i = 1, #enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        if cast.able.primalWrath(thisUnit) and debuff.rip.refresh(thisUnit) and (#enemies.yards8 > 1) then
            if cast.primalWrath("player","aoe",2,8) then ui.debug("Casting Primal Wrath [Finish - Refresh]") return true end
        end
    end
    -- Rip
    -- rip,target_if=refreshable
    if range.dyn5 and not var.noDoT
        and #enemies.yards5f < ui.value("Multi-DoT Limit")
        and debuff.rip.count() < ui.value("Multi-DoT Limit")
    then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if cast.able.rip(thisUnit) and canDoT(thisUnit) and debuff.rip.refresh(thisUnit) then
                if cast.rip(thisUnit) then ui.debug("Casting Rip [Finish]") return true end
            end
        end
    end
    -- Ferocious Bite
    -- ferocious_bite,max_energy=1,target_if=max:time_to_die
    if cast.able.ferociousBite() and var.fbMaxEnergy and range.dyn5 then
        if cast.pool.ferociousBite() then return true end
        if cast.ferociousBite() then ui.debug("Casting Ferocious Bite [Finish]") return true end
    end
    -- ferocious_bite,if=(buff.bs_inc.up&talent.soul_of_the_forest.enabled)
    if cast.able.ferociousBite() and range.dny5
        and ((buff.berserk.exists() or buff.incarnationAvatarOfAshamane.exists()) and talent.soulOfTheForest)
    then
        if cast.ferociousBite(var.lowestRipUnit) then ui.debug("Casting Ferocious Bite [Finish - BS/Inc Soul]") return true end
    end
end -- End Action List - Finisher

-- Action List - Bloodtalons
actionList.Bloodtalons = function()
    -- Rake
    -- rake,target_if=max:druid.rake.ticks_gained_on_refresh,if=(!ticking|(1.2*persistent_multiplier>=dot.rake.pmultiplier)|(active_bt_triggers=2&refreshable))&buff.bt_rake.down
    if cast.able.rake()
        and debuff.rake.count() < ui.value("Multi-DoT Limit")
        and #enemies.yards5f < ui.value("Multi-DoT Limit")
        and (not debuff.rake.exists(var.maxRakeTicksGainUnit) or (1.2 * debuff.rake.calc() >= debuff.rake.applied(var.maxRakeTicksGainUnit))
            or (btGen.triggers == 2 and debuff.rake.refresh(var.maxRakeTicksGainUnit))) and not btGen.rake
    then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [BT - Ticks Gain]")
            btGen.rake = true
            if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Lunar Inspiration
    -- lunar_inspiration,if=refreshable&buff.bt_moonfire.down
    if talent.lunarInspiration and cast.able.moonfireFeral(units.dyn40AOE) and debuff.moonfireFeral.refresh(units.dyn40AOE) and not btGen.moonfireFeral then
        if (multidot or (unit.isUnit(units.dyn40AOE,"target") and not multidot)) then
            if cast.moonfireFeral(units.dyn40AOE) then
                ui.debug("Casting Moonfire [BT - Refresh]")
                btGen.moonfireFeral = true
                if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
                return true
            end
        end
    end
    -- Thrash
    -- thrash_cat,target_if=refreshable&buff.bt_thrash.down
    if cast.able.thrashCat("player","aoe",1,8) and not btGen.thrash then
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if debuff.thrashCat.refresh(thisUnit) then
                if cast.thrashCat("player","aoe",1,8) then
                    ui.debug("Casting Thrash [BT - Refresh]")
                    btGen.thrash = true
                    if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
                    return true
                end
            end
        end
    end
    -- Brutal Slash
    -- brutal_slash,if=buff.bt_brutal_slash.down
    if cast.able.brutalSlash("player","aoe",1,8) and not btGen.brutalSlash then
        if cast.brutalSlash("player","aoe",1,8) then
            ui.debug("Casting Brutal Slash [BT]")
            btGen.brutalSlash = true
            if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Swipe
    -- swipe_cat,if=buff.bt_swipe.down
    if cast.able.swipeCat("player","aoe",1,8) and not talent.brutalSlash and not btGen.swipe then
        if cast.swipeCat("player","aoe",1,8) then
            ui.debug("Casting Swipe [BT]")
            btGen.swipe = true
            if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Shred
    -- shred,if=buff.bt_shred.down
    if cast.able.shred() and not btGen.shred then
        if cast.shred() then
            ui.debug("Casting Shred [BT]")
            btGen.shred = true
            if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Swipe
    -- swipe_cat,if=buff.bt_swipe.down
    if cast.able.swipeCat("player","aoe",1,8) and not talent.brutalSlash and not btGen.swipe then
        if cast.swipeCat("player","aoe",1,8) then
            ui.debug("Casting Swipe [BT - 2]")
            btGen.swipe = true
            if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Thrash
    -- thrash_cat,if=buff.bt_thrash.down
    if cast.able.thrashCat("player","aoe",1,8) and not btGen.thrash then
        if cast.thrashCat("player","aoe",1,8) then
            ui.debug("Casting Thrash [BT]")
            btGen.thrash = true
            if btGen.timer - var.getTime <= 0 then btGen.timer = var.getTime + 4 end
            return true
        end
    end
    -- Rake
    -- rake,if=buff.bt_rake.down&combo_points>4
    if cast.able.rake() and (not btGen.rake and comboPoints > 4) then
        if cast.rake() then return end
    end
end -- End Action List - Bloodtalons

-- Action List - Builder Cycle
actionList.BuilderCycle = function()
    -- Clearcasting
    -- run_action_list,name=clearcasting,if=buff.clearcasting.react
    if buff.clearcasting.exists() then
        if actionList.Clearcasting() then return true end
    end
    -- Rake
    -- rake,target_if=max:ticks_gained_on_refresh,if=refreshable|buff.sudden_ambush.up
    if cast.able.rake(var.maxRakeTicksGainUnit) and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or buff.suddenAmbush.exists()) then
        if cast.rake(var.maxRakeTicksGainUnit) then ui.debug("Casting Rake [Builder Cycle - Sudden Refresh]") return true end
    end
    -- Moonfire
    -- moonfire_cat,target_if=refreshable
    if talent.lunarInspiration and cast.able.moonfireFeral(units.dyn40AOE) and (debuff.moonfire.refresh(units.dyn40AOE)) then
        if cast.moonfireFeral(units.dyn40AOE) then ui.debug("Casting Moonfire [Builder Cycle]") return true end
    end
    -- Thrash
    -- pool_resource,for_next=1
    -- thrash_cat,target_if=refreshable
    if cast.able.thrashCat("player","aoe",3,8) and (debuff.thrashCat.refresh(units.dyn8AOE)) then
        if cast.pool.thrashCat("player","aoe",3,8) then return true end
        if cast.thrashCat("player","aoe",3,8) then ui.debug("Casting Thrash [Builder Cycle]") return true end
    end
    -- Brutal Slash
    -- brutal_slash
    if cast.able.brutalSlash("player","aoe",3,8) and talent.brutalSlash then
        if cast.brutalSlash("player","aoe",3,8) then ui.debug("Casting Thrash [Builder Cycle]") return true end
    end
    -- Swipe
    -- swipe_cat,if=spell_targets.swipe_cat>variable.swipe_v_shred
    if cast.able.swipeCat("player","aoe",var.swipeVShred,8) and not talent.brutalSlash and (#enemies.yards8 > var.swipeVShred) then
        if cast.swipeCat("player","aoe",var.swipeVShred,8) then ui.debug("Casting Swipe [Builder Cycle]") return true end
    end
    -- shred
    if cast.able.shred() then
        if cast.shred() then ui.debug("Casting Shred [Builder Cycle]") return true end
    end
end

-- Action List - Clearcasting
actionList.Clearcasting = function()
    -- Thrash
    -- thrash_cat,target_if=refreshable
    if cast.able.thrashCat("player","aoe",3,8) and (debuff.thrashCat.refresh(units.dyn8AOE)) then
        if cast.thrashCat("player","aoe",3,8) then ui.debug("Casting Thrash [Clearcasting]") return true end
    end
    -- Swipe
    -- swipe_cat,if=spell_targets.swipe_cat>variable.swipe_v_shred
    if cast.able.swipeCat("player","aoe",var.swipeVShred,8) and not talent.brutalSlash and (#enemies.yards8 > var.swipeVShred) then
        if cast.swipeCat("player","aoe",var.swipeVShred,8) then ui.debug("Casting Swipe [Clearcasting]") return true end
    end
    -- Shred
    -- shred
    if cast.able.shred() then
        if cast.shred() then ui.debug("Casting Shred [Clearcasting]") return true end
    end
    -- Brutal Slash
    -- brutal_slash
    if cast.able.brutalSlash("player","aoe",3,8) and talent.brutalSlash then
        if cast.brutalSlash("player","aoe",3,8) then ui.debug("Casting Brutal Slash [Clearcasting]") return true end
    end
end

-- Action List - Owlweave
actionList.Owlweave = function()
    -- Moonfire
    -- moonfire,line_cd=4*gcd
    if cast.able.moonfire() and buff.moonkinForm.exists() and cast.timeSinceLast.moonfire() >= 4 * unit.gcd(true) then
        if cast.moonfire() then ui.debug("Casting Moonfire [Owlweaving]") return true end
    end
    -- Starsurge
    -- starsurge
    if cast.able.starsurge() then
        if cast.starsurge() then ui.debug("Casting Starsurge [Finish]") return true end
    end
    -- Sunfire
    -- sunfire,line_cd=4*gcd
    if cast.able.sunfire() and cast.timeSinceLast.sunfire() >= 4 * unit.gcd(true) then
        if cast.sunfire() then ui.debug("Casting Sunfire [Finish]") return true end
    end
end -- End Action List - Owlweave

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
                if use.battleScarredAugmentRune() then ui.debug("Using Battle Scared Augment Rune") var.lastRune = var.getTime return true end
            end
            -- Prowl - Non-PrePull
            if cast.able.prowl("player")
                and buff.catForm.exists()
                and autoProwl()
                and ui.mode.prowl == 1
                and not buff.prowl.exists()
                and not unit.resting()
                -- and var.getTime - var.leftCombat > lootDelay
            then
                if cast.prowl("player") then ui.debug("Casting Prowl [Auto]") return true end
            end
        end -- End No Stealth
        -- Wild Charge
        if ui.checked("Displacer Beast / Wild Charge") and cast.able.wildCharge("target") and unit.valid("target") then
            if cast.wildCharge("target") then ui.debug("Wild Charge on "..unit.name("target")) return true end
        end
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Regrowth
            -- regrowth,if=talent.bloodtalons.enabled
            if cast.able.regrowth("player") and talent.bloodtalons and not buff.bloodtalons.exists()
                and var.htTimer < var.getTime - 1 and not buff.prowl.exists()
                and not cast.current.regrowth()
            then
                if unit.form() ~= 0 then
                    -- CancelShapeshiftForm()
                    unit.cancelForm()
                    ui.debug("Cancel Form [Pre-pull]")
                elseif unit.form() == 0 then
                    if cast.regrowth("player") then ui.debug("Casting Regrowth [Pre-pull]"); var.htTimer = var.getTime; return true end
                end
            end
            -- Azshara's Font of Power
            -- use_item,name=azsharas_font_of_power
            if (use.able.slot(13) or use.able.slot(14)) then
                local opValue = ui.value("Trinkets")
                if (opValue == 1 or (opValue == 2 and ui.useCDs())) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    for i = 13, 14 do
                        if use.able.slot(i) then
                            if equiped.azsharasFontOfPower(i) then
                                use.slot(i)
                                ui.debug("Using Azshara's Font of Power [Pre-pull - Slot "..i.."]")
                            end
                        end
                    end
                end
            end
            -- Prowl
            if cast.able.prowl("player") and buff.bloodtalons.exists()
                and ui.mode.prowl == 1 and not buff.prowl.exists()
                and (buff.latentArcana.remain() > 25
                    or not (equiped.azsharasFontOfPower(13) and equiped.azsharasFontOfPower(14))
                    or (equiped.azsharasFontOfPower(13) and not use.able.azsharasFontOfPower(13))
                    or (equiped.azsharasFontOfPower(14) and not use.able.azsharasFontOfPower(14)))
            then
                if cast.prowl("player") then ui.debug("Casting Prowl [Pre-pull]"); return true end
            end
            -- if buff.prowl.exists() then
            --     -- Pre-pot
            --     -- potion,name=old_war
            --     if ui.value("Potion") ~= 5 and ui.pullTimer() <= 1 and (unit.instance("raid") or unit.instance("party")) then
            --         if ui.value("Potion") == 1 and use.able.potionOfFocusedResolve() then
            --             use.potionOfFocusedResolve()
            --             ui.debug("Using Potion of Focused Resolve [Pre-Pull]");
            --         end
            --     end
            -- end -- End Prowl
            -- Berserk/Tiger's Fury Pre-Pull
            if ui.checked("Berserk/Tiger's Fury Pre-Pull") and ui.pullTimer() <= 1 and (unit.instance("raid") or unit.instance("party")) and unit.distance("target") < 8 then
                if cast.able.berserk() and cast.able.tigersFury() then
                    cast.berserk()
                    cast.tigersFury()
                    ui.debug("Casting Berserk and Tiger's Fury [Pre-Pull]")
                end
            end
        end -- End Pre-Pull
        -- Pull
        if unit.valid("target") and unit.exists("target") and unit.distance("target") < 5 then
            -- Auto Attack
            -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
            if not (buff.prowl.exists() or buff.shadowmeld.exists()) then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Pull]") return true end
                end
            end
        end
    end -- End No Combat
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------
    --- Locals ---
    --------------
    -- BR API
    if comboPoints == nil then
        anima           = br.player.anima
        buff            = br.player.buff
        cast            = br.player.cast
        cd              = br.player.cd
        charges         = br.player.charges
        conduit         = br.player.conduit
        covenant        = br.player.covenant
        debuff          = br.player.debuff
        enemies         = br.player.enemies
        equiped         = br.player.equiped
        module          = br.player.module
        race            = br.player.race
        power           = br.player.power
        spell           = br.player.spell
        talent          = br.player.talent
        ui              = br.player.ui
        unit            = br.player.unit
        units           = br.player.units
        use             = br.player.use
    end
    comboPoints         = power.comboPoints.amount()
    energy              = power.energy.amount()
    energyDeficit       = power.energy.deficit()
    multidot            = ui.mode.cleave == 1 and ui.mode.rotation < 3
    var.getTime         = br._G.GetTime()
    var.kindredSpirit   = findKindredSpirit()
    var.lootDelay       = ui.checked("Auto Loot") and ui.value("Auto Loot") or 0
    var.minCount        = ui.useCDs() and 1 or 3

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    units.get(8,true)
    units.get(5)
    if range == nil then range = {} end
    range.dyn40 = unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40
    range.dyn8AOE = unit.distance(units.dyn8AOE) < 8
    range.dyn5 = unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5

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
    if not unit.inCombat() and not unit.exists("target") then
        if var.profileStop then var.profileStop = false end
        var.leftCombat = var.getTime
    end
    var.unit5ID = br.GetObjectID(units.dyn5) or 0
    var.noDoT = var.unit5ID == 153758 or var.unit5ID == 156857 or var.unit5ID == 156849 or var.unit5ID == 156865 or var.unit5ID == 156869

    -- Sabertooth
    var.sabertooth = talent.sabertooth and 1 or 0

    -- Clearcasting
    var.clearcasting = buff.clearcasting.exists() and 1 or 0

    -- Incarnation: King of the Jungle
    var.incarnation = buff.incarnationAvatarOfAshamane.exists() and 1 or 0

    -- Brutal Slash
    var.brutal = talent.brutalSlash and 1 or 0

    -- Lunar Inspiration
    var.lunar = talent.lunarInspiration and 1 or 0

    -- Taste For Blood
    var.tastyBlood = conduit.tasteForBlood.enabled and 1 or 0

    -- Necrolord
    var.necro = covenant.necrolord.active and 1 or 0

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

    var.fbMaxEnergy = energy >= 50 or buff.apexPredatorsCraving.exists() or (energy >= 25 and (buff.berserk.exists() or buff.incarnationAvatarOfAshamane.exists()))

    var.bsInc = (buff.berserk.exists() or buff.incarnationAvatarOfAshamane.exists()) and 1 or 0

    -- Variables
    -- variable,name=swipe_v_shred,value=2
    var.swipeVShred = 2
    -- variable,name=pw_v_fb,op=setif,value=0,condition=talent.tear_open_wounds.enabled&talent.rip_and_tear.enabled,value_else=4
    var.pwVFb = talent.tearOpenWounds and talent.ripAndTear and 0 or 4

    -- Bloodtalons - Reset
    if btGen.timer - var.getTime <= 0 or buff.bloodtalons.exists() or not unit.inCombat() then
        if btGen.brutalSlash then btGen.brutalSlash = false end
        if btGen.moonfireFeral then btGen.moonfireFeral = false end
        if btGen.rake then btGen.rake = false end
        if btGen.shred then btGen.shred = false end
        if btGen.swipe then btGen.swipe = false end
        if btGen.thrash then btGen.thrash = false end
        -- btGen.timer = var.getTime + 4
    end
    -- if not buff.bloodtalons.exists() and btGen.timer - var.getTime > 0 then btGen.stack = 2 end
    btGen.stack = 2 - buff.bloodtalons.stack()
    btGen.triggers = 0
    if not btGen.brutalSlash and talent.brutalSlash then btGen.triggers = btGen.triggers + 1 end
    if not btGen.moonfireFeral and talent.lunarInspiration then btGen.triggers = btGen.triggers + 1 end
    if not btGen.rake then btGen.triggers = btGen.triggers + 1 end
    if not btGen.shred then btGen.triggers = btGen.triggers + 1 end
    if not btGen.swipe and not talent.brutalSlash then btGen.triggers = btGen.triggers + 1 end
    if not btGen.thrash then btGen.triggers = btGen.triggers + 1 end

    -- Group Tracking
    -- Rake Ticks
    var.rakeTicksTotal = function(thisUnit)
        return not debuff.rake.exists(thisUnit, "EXACT") and 5 or math.floor(debuff.rake.duration(thisUnit,"EXACT") / 3)
    end
    var.rakeTicksRemain = function(thisUnit)
        return math.floor(debuff.rake.remain(thisUnit,"EXACT") / 3)
    end
    var.rakeTicksGain = function(thisUnit)
        return var.rakeTicksTotal(thisUnit) - var.rakeTicksRemain(thisUnit)
    end
    ticksGain.rake = var.rakeTicksGain(thisUnit)

    -- Rip Ticks
    var.ripTicksTotal = function(thisUnit)
        return not debuff.rip.exists(thisUnit) and 12 or math.floor(debuff.rip.duration(thisUnit) / 2)
    end
    var.ripTicksRemain = function(thisUnit)
        return math.floor(debuff.rip.remain(thisUnit) / 2)
    end
    var.ripTicksGain = function(thisUnit)
        return var.ripTicksTotal(thisUnit) - var.ripTicksRemain(thisUnit)
    end
    ticksGain.rip = var.ripTicksGain(thisUnit)

    -- Thrash Ticks
    var.thrashCatTicksTotal = function(thisUnit)
        return not debuff.thrashCat.exists(thisUnit) and 5 or math.floor(debuff.thrashCat.duration(thisUnit) / 3)
    end
    var.thrashCatTicksRemain = function(thisUnit)
        return math.floor(debuff.thrashCat.remain(thisUnit) / 3)
    end
    var.thrashCatTicksGain = function(thisUnit)
        return var.thrashCatTicksTotal(thisUnit) - var.thrashCatTicksRemain(thisUnit)
    end
    ticksGain.thrash = var.thrashCatTicksGain("target")

    -- Moonfire Feral Ticks
    var.moonfireFeralTicksTotal = function(thisUnit)
        return not debuff.moonfireFeral.exists(thisUnit) and 8 or math.floor(debuff.moonfireFeral.remain(thisUnit) / 2)
    end
    var.moonfireFeralTicksRemain = function(thisUnit)
        return math.floor(debuff.moonfireFeral.remain(thisUnit) / 2)
    end
    var.moonfireFeralTicksGain = function(thisUnit)
        return var.moonfireFeralTicksTotal(thisUnit) - var.moonfireFeralTicksRemain(thisUnit)
    end
    ticksGain.moonfireFeral = var.moonfireFeralTicksGain("target")

    -- Total Ticks Gain / Lowest TTD / Max TTD
    var.lowestTTD = 999
    var.lowestTTDUnit = units.dyn5
    var.maxTTD = 0
    var.maxTTDUnit = units.dyn5
    for i = 1, #enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        local thisTTD = unit.ttd(thisUnit) or 99
        if not unit.isUnit("target",thisUnit) then
            -- Moonfire Feral Ticks to Gain
            ticksGain.moonfireFeral = ticksGain.moonfireFeral + var.moonfireFeralTicksGain(thisUnit)
            -- Thrash Ticks to Gain
            ticksGain.thrash = ticksGain.thrash + var.thrashCatTicksGain(thisUnit)
            -- Primal Wrath Ticks to Gain
            if talent.primalWrath then
                ticksGain.rip = ticksGain.rip + var.ripTicksGainUnit(thisUnit)
            end
        end
        -- 5 Yards Checks
        if unit.distance(thisUnit) < 5 and unit.facing(thisUnit) then
            if not unit.isUnit("target",thisUnit) then
                -- Rip Ticks to Gain
                if not talent.primalWrath then
                    ticksGain.rip = ticksGain.rip + var.ripTicksGain(thisUnit)
                end
                -- Rake Ticks to Gain
                ticksGain.rake = ticksGain.rake + var.rakeTicksGain(thisUnit)
            end
            -- variable,name=shortest_ttd,value=target.time_to_die
            -- cycling_variable,name=shortest_ttd,op=min,value=target.time_to_die
            if thisTTD < var.lowestTTD then var.lowestTTD = thisTTD var.lowestTTDUnit = thisUnit end
            if thisTTD > var.maxTTD then var.maxTTD = thisTTD var.maxTTDUnit = thisUnit end
        end
    end

    var.ripTicksGainUnit = function(ripUnit)
        return var.ripTicksGain(ripUnit)
    end

    var.rakeTicksGainUnit = function(rakeUnit)
        return var.rakeTicksGain(thisUnit)
    end

    var.maxRakeTicksGain = 0
    var.maxRakeTicksGainUnit = "target"
    var.lowestRip = 99
    var.lowestRipUnit = var.lowestTTDUnit
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        -- Rake
        local rakeTicksGain = var.rakeTicksGainUnit(thisUnit)
        if rakeTicksGain > var.maxRakeTicksGain then
            var.maxRakeTicksGain = rakeTicksGain
            var.maxRakeTicksGainUnit = thisUnit
        end
        -- Rip
        if talent.sabertooth then
            local ripValue = debuff.rip.remains(thisUnit)
            if ripValue > unit.gcd(thisUnit) and ripValue < var.lowestRip then
                var.lowestRip = ripValue
                var.lowestRipUnit = thisUnit
            end
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
            -- Auto Attack
            -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
            if range.dyn5 and not (buff.prowl.exists() or buff.shadowmeld.exists()) then
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
                end
            end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if ui.value("APL Mode") == 1 then
                -- Ferocious Bite
                for i = 1, #enemies.yards5f do
                    local thisUnit = enemies.yards5f[i]
                    if cast.able.ferociousBite(thisUnit) and range.dyn5 then
                        -- execute
                        if ferociousBiteFinish(thisUnit) and not usePrimalWrath() then
                            if ui.value("Ferocious Bite Execute") == 1 and ferociousBiteFinish(thisUnit) then
                                ui.print("Ferocious Bite Finished! "..unit.name(thisUnit).." with "..br.round2(unit.hp(thisUnit),0).."% health remaining.")
                            end
                            if cast.ferociousBite(thisUnit) then ui.debug("Casting Ferocious Bite on "..unit.name(thisUnit).." [Execute]"); return true end
                        end
                        -- ferocious_bite,target_if=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>10&(talent.sabertooth.enabled)
                        if debuff.rip.exists(thisUnit) and debuff.rip.remains(thisUnit) < 3
                            and debuff.rip.remains(thisUnit) > unit.gcd(true) and unit.ttd(thisUnit) > 10 and talent.sabertooth
                        then
                            if cast.ferociousBite(thisUnit) then ui.debug("Casting Ferocious Bite [Sabertooth]"); return true end
                        end
                    end
                end
                -- Call Action List - Interrupts
                if actionList.Interrupts() then return true end
                -- Tiger's Fury
                -- tigers_fury,if=energy.deficit>40|buff.bs_inc.up
                if cast.able.tigersFury() and (energyDeficit > 40 or var.bsInc == 1) then
                    if cast.tigersFury() then ui.debug("Casting Tiger's Fury") return true end
                end
                -- Call Action List - Cooldowns
                -- call_action_list,name=cooldown
                if actionList.Cooldowns() then return true end
                -- Ferocious Bite
                -- ferocious_bite,if=buff.apex_predators_craving.up
                if cast.able.ferociousBite() and range.dyn5 and buff.apexPredatorsCraving.exists() then
                    if cast.ferociousBite() then ui.debug("Casting Ferocious Bite [Apex Predator's Craving]"); return true end
                end
                -- Feral Frenzy
                -- feral_frenzy,if=combo_points<2
                if cast.able.feralFrenzy() and (comboPoints < 2) then
                    if cast.feralFrenzy() then ui.debug("Casting Feral Frenzy") return true end
                end
                -- Run Action List - Finisher
                -- call_action_list,name=finisher,if=combo_points=5
                if comboPoints == 5 then
                    if actionList.Finisher() then return true end
                end
                -- Action List - Bloodtalons
                -- call_action_list,name=bloodtalons,if=buff.bloodtalons.down
                if talent.bloodtalons and not buff.bloodtalons.exists() then
                    if actionList.Bloodtalons() then return true end
                end
                -- Action List - Berserk Builders
                -- call_action_list,name=berserk_builders,if=combo_points<5&(buff.bs_inc.up|buff.shadowmeld.up|buff.prowl.up)
                if comboPoints < 5 and (var.bsInc == 1 or buff.shadowmeld.exists() or buff.prowl.exists()) then
                    if actionList.BerserkBuilders() then return true end
                end
                -- Action List - Builder Cycle
                -- call_action_list,name=builder_cycle,if=combo_points<5
                if comboPoints < 5 then
                    if actionList.BuilderCycle() then return true end
                end
                -- Call Action List - Owlweave
                -- call_action_list,name=owlweaving,if=buff.bs_inc.down&energy<80
                if ui.alwaysCdNever("Owlweave") and var.bsInc == 1 and energy < 80 then
                    if actionList.Owlweave() then return true end
                end
                -- Cat Form - Owlweave
                if cast.able.catForm("player") and buff.moonkinForm.exists() then
                    if cast.catForm("player") then ui.debug("Casting Cat Form [Cancel Owlweave]"); return true end
                end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 103
--local _, br = ...
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

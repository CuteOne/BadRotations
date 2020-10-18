local rotationName = "CuteOne"
local br = _G["br"]
---------------
--- Toggles ---
---------------
local function createToggles()
    local CreateButton = _G["CreateButton"]
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.swipeCat },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.swipeCat },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shred },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.regrowth}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.berserk },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.berserk },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.berserk }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.survivalInstincts },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.survivalInstincts }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.skullBash },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.skullBash }
    };
    CreateButton("Interrupt",4,0)
    -- Cleave Button
	CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.rake },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.rake }
    };
    CreateButton("Cleave",5,0)
    -- Prowl Button
	ProwlModes = {
        [1] = { mode = "On", value = 1 , overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon = br.player.spell.prowl },
        [2] = { mode = "Off", value = 2 , overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon = br.player.spell.prowl }
    };
    CreateButton("Prowl",6,0)
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
            -- Opener
            br.ui:createCheckbox(section, "Opener")
            br.ui:createDropdownWithout(section, "Brutal Slash in Opener", {"|cff00FF00Enabled","|cffFF0000Disabled"}, 1, "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFuse of Brutal Slash in Opener")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
	    -- Berserk/Tiger's Fury Pre-Pull
            br.ui:createCheckbox(section, "Berserk/Tiger's Fury Pre-Pull")
            -- Travel Shapeshifts
            br.ui:createCheckbox(section,"Auto Shapeshifts","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
            -- Fall Timer
            br.ui:createSpinnerWithout(section,"Fall Timer", 2, 1, 5, 0.25, "|cffFFFFFFSet to desired time to wait until shifting to flight form when falling (in secs).")
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
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Augment Rune
            br.ui:createCheckbox(section,"Augment Rune")
            -- Potion
            br.ui:createDropdownWithout(section,"Potion", {"Focused Resolve","None"}, 1, "|cffFFFFFFSet Potion to use.")
            -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Greater Flask of the Currents","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "|cffFFFFFFSet Elixir to use.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Essences
            br.ui:createCheckbox(section,"Use Essence")
            -- Tiger's Fury
            br.ui:createCheckbox(section,"Tiger's Fury")
            br.ui:createDropdownWithout(section,"Snipe Tiger's Fury", {"|cff00FF00Enabled","|cffFF0000Disabled"}, 1, "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFuse of Tiger's Fury to take adavantage of Predator talent.")
            -- Berserk / Incarnation: King of the Jungle
            br.ui:createCheckbox(section,"Berserk/Incarnation")
            -- Trinkets
            br.ui:createDropdownWithout(section,"Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinkets.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
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
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
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
            br.ui:createSpinner(section, "Wildgrowth",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
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
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdown(section, "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Prowl Toggle
            br.ui:createDropdown(section, "Prowl Mode", br.dropOptions.Toggle,  6)
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
local buff
local cast
local comboPoints
local cd
local charges
local debuff
local enemies
local energy, energyRegen, energyDeficit
local equiped
local essence
local has
local item
local spell
local talent
local traits
local ttm
local unit
local units
local use
local ui

-- General Locals
local btGen = {}
local healPot
local inRaid
local inInstance
local lootDelay
local lowestHP
local multidot
local opener
local race
local range
local solo
local stealth
local ticksGain = {}
local travel, flight, cat
local var = {}

-- Variables
var.clearcasting = 0
var.enemyBlood = 0
var.fbMaxEnergy = false
var.friendsInRange = false
var.htTimer = GetTime()
var.incarnation = 0
var.lastForm = 0
var.lastRune = GetTime()
var.leftCombat = GetTime()
var.minCount = 3
var.noDoT = false
var.profileStop = false
var.reapingDelay = 0
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
btGen.timer = GetTime()
btGen.triggers = 0

-- Tick Remain - Init
ticksGain.rake = 5
ticksGain.rip = 12
ticksGain.thrash = 5

-- variable,name=4cp_bite,value=0
local cp4Bite = 0
-- variable,name=filler,value=1
local filler = 1
-- variable,name=rip_ticks,value=7
local ripTicks = 7
-- variable,name=thrash_ticks,value=8
local thrashTicks = 8
local bestRip = 0

-----------------
--- Functions ---
-----------------
local function autoProwl()
    if not unit.inCombat() and not buff.prowl.exists() then
        if #enemies.yards20nc > 0 then
            for i = 1, #enemies.yards20nc do
                local thisUnit = enemies.yards20nc[i]
                local react = unit.reaction(thisUnit) or 10
                if react < 4 and unit.enemy(thisUnit) and unit.canAttack(thisUnit) then
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
    if var.noDoT then return false end
    if not unit.isBoss(thisUnit) then return ((unitHealthMax > unit.healthMax("player") * 3)
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
        and (#enemies.yards40 == 1 and unit.ttd(units.dyn40) > ttm) or #enemies.yards40 > 1
    then
        local lowestUnit = units.dyn5
        lowestHP = 100
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            local thisHP = unit.hp(thisUnit)
            if thisHP < lowestHP then
                lowestHP = thisHP
                lowestUnit = thisUnit
            end
        end
        local timeTillDeath = 99
        local longestBleed = math.max(debuff.rake.remain(lowestUnit), debuff.rip.remain(lowestUnit),
            debuff.thrashCat.remain(lowestUnit), debuff.feralFrenzy.remain(lowestUnit))
        if unit.ttd(lowestUnit) > 0 then timeTillDeath = unit.ttd(lowestUnit) end
        if lowestUnit ~= nil and timeTillDeath < longestBleed then return true end
    end
    return false
end
-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local GetSpellDescription = _G["GetSpellDescription"]
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
    if talent.primalWrath and cast.able.primalWrath(nil,"aoe",1,8) and cast.safe.primalWrath("player",8,1)
        and ((ui.mode.rotation == 1 and #enemies.yards8 > 1) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
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
-- Razor Coral Target
local function razorTarget()
    local razorUnit = units.dyn40
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        if debuff.razorCoral.exists(thisUnit) then
            razorUnit = thisUnit
            break
        end
    end
    return razorUnit
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
        if cast.able.travelForm("player") and not unit.inCombat() and canFly() and not unit.swimming() and br.fallDist > 90
            --[[falling > ui.value("Fall Timer")]] and unit.level() >= 24 and not buff.prowl.exists()
        then
            if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then RunMacroText("/CancelForm") end
            if cast.travelForm("player") then ui.debug("Casting Travel Form [Flying]") return true end
        end
        -- Aquatic Form
        if cast.able.travelForm("player") and (not unit.inCombat() --[[or unit.distance("target") >= 10--]])
            and unit.swimming() and not travel and not buff.prowl.exists() and unit.moving()
        then
            if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then RunMacroText("/CancelForm") end
            if cast.travelForm("player") then ui.debug("Casting Travel From [Swimming]") return true end
        end
        -- Cat Form
        if cast.able.catForm() and not cat and not IsMounted() and not unit.flying() then
            -- Cat Form when not swimming or flying or stag and not in combat
            if unit.moving() and not unit.swimming() and not unit.flying() and not travel then
                if cast.catForm("player") then ui.debug("Casting Cat Form [No Swim / Travel / Combat]") return true end
            end
            -- Cat Form when not in combat and target selected and within 20yrds
            if not unit.inCombat() and unit.valid("target") and ((unit.distance("target") < 30 and not unit.swimming())
                or (unit.distance("target") < 10 and unit.swimming()))
            then
                if cast.catForm("player") then ui.debug("Casting Cat Form [Target In 20yrds]") return true end
            end
            -- Cat Form - Less Fall Damage
            if (not canFly() or unit.inCombat() or unit.level() < 24 or not IsOutdoors())
                and (not unit.swimming() or (not unit.moving() and unit.swimming() and #enemies.yards5f > 0))
                and br.fallDist > 90 --falling > ui.value("Fall Timer")
            then
                if cast.catForm("player") then ui.debug("Casting Cat Form [Reduce Fall Damage]") return true end
            end
        end
    end -- End Shapeshift Form Management
    -- Perma Fire Cat
    if ui.checked("Perma Fire Cat") and (use.able.fandralsSeedPouch() or use.able.burningSeeds())
        and not unit.inCombat() and not buff.prowl.exists() and cat
    then
        if not buff.burningEssence.exists() then
            -- Fandral's Seed Pouch
            if use.able.fandralsSeedPouch() and equiped.fandralsSeedPouch() then
                if use.fandralsSeedPouch() then ui.debug("Using Fandrel's Seed Pouch") return true end
            -- Burning Seeds
            elseif use.able.burningSeeds() then
                if use.burningSeeds() then ui.debug("Using Burning Seeds") return true end
            end
        end
    end -- End Perma Fire Cat
    -- Death Cat mode
    if ui.checked("Death Cat Mode") and cat then
        if unit.exists("target") and unit.distance(units.dyn8AOE) > 8 then
            ClearTarget()
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
                if cast.shred() then ui.debug("Casting Shred [Death Cat Mode]"); swipeSoon = nil; return true end
            end
            -- Swipe - AoE
            if cast.able.swipeCat() and #enemies.yards8 > 1 then
                if swipeSoon == nil then
                    swipeSoon = GetTime();
                end
                if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
                    if cast.swipeCat(nil,"aoe") then ui.debug("Casting Swipe [Death Cat Mode]") ; swipeSoon = nil; return true end
                end
            end
        end -- End 20yrd Enemy Scan
    end -- End Death Cat Mode
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                StopAttack()
                ClearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() and not IsMounted() and not stealth and not flight and not buff.prowl.exists() then
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
                if cast.rebirth(thisUnit,"dead") then ui.debug("Casting Rebirth on "..unit.name(thisUnit)) return true end
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
                and (unit.friend(thisUnit) or unit.player(thisUnit))
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
                and canDispel(thisUnit,spell.removeCorruption)
            then
                if cast.removeCorruption(thisUnit) then ui.debug("Casting Remove Corruption on "..unit.name(thisUnit)) return true end
            end
        end
        -- Soothe
        if ui.checked("Soothe") and cast.able.soothe() then
            for i=1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if canDispel(thisUnit, spell.soothe) then
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
            if not hasNoControl() and var.lastForm ~= 0 then
                CastShapeshiftForm(var.lastForm)
                if GetShapeshiftForm() == var.lastForm then
                    var.lastForm = 0
                end
            elseif hasNoControl() then
                if GetShapeshiftForm() == 0 then
                    cast.catForm("player")
                    ui.debug("Casting Cat Form [Breaking CC]")
                else
                    for i=1, GetNumShapeshiftForms() do
                        if i == GetShapeshiftForm() then
                            var.lastForm = i
                            CastShapeshiftForm(i)
                            ui.debug("Casting Last Form [Breaking CC]")
                            return true
                        end
                    end
                end
            end
        end
        -- Pot/Stoned
        if ui.checked("Pot/Stoned") and unit.inCombat() and (use.able.healthstone() or canUseItem(healPot))
            and (hasHealthPot() or has.healthstone()) and unit.hp() <= ui.value("Pot/Stoned")
        then
            if use.able.healthstone() then
                if use.healthstone() then ui.debug("Using Healthstone") return true end
            elseif canUseItem(healPot) then
                useItem(healPot)
                ui.debug("Using Health Potion")
            end
        end
        -- Heirloom Neck
        if ui.checked("Heirloom Neck") and unit.hp() <= ui.value("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then ui.debug("Using Heirloom Neck") return true end
            end
        end
        if talent.restorationAffinity and not (IsMounted() or IsFlying())
            and (ui.value("Auto Heal") ~= 1 or (ui.value("Auto Heal") == 1
            and unit.distance(br.friend[1].unit) < 40))
        then
            local thisHP = unit.hp()
            local thisUnit = "player"
            local lowestUnit = getLowestUnit(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 then thisHP = fhp; thisUnit = lowestUnit end
            -- Swiftmend
            local swiftPercent = ui.value("Swiftmend")
            if ui.checked("Swiftmend") and cast.able.swiftmend()
                and ((not inCombbat and thisHP <= swiftPercent) or (unit.inCombat() and thisHP <= swiftPercent/2))
            then
                if cast.swiftmend(thisUnit) then ui.debug("Casting Swiftmend on "..unit.name(thisUnit)) return true end
            end
            -- Rejuvenation
            local rejuvPercent = ui.value("Rejuvenation")
            if ui.checked("Rejuvenation") and cast.able.rejuvenation() and buff.rejuvenation.refresh(thisUnit)
                and ((not inCombbat and thisHP <= rejuvPercent) or (unit.inCombat() and thisHP <= rejuvPercent/2))
            then
                if cast.rejuvenation(thisUnit) then ui.debug("Casting Rejuvenation on "..unit.name(thisUnit)) return true end
            end
            -- Wild Growth
            if ui.checked("Wild Growth") and not unit.inCombat() and cast.able.wildGrowth() then
                for i = 1, #br.friend do
                    local thisUnit = br.friend[i].unit
                    local thisHP = unit.hp(thisUnit)
                    local lowHealthCandidates = getUnitsToHealAround(thisUnit, 30, ui.value("Wild Growth"), #br.friend)
                    if #lowHealthCandidates > 1 and not unit.moving() then
						if cast.wildGrowth(br.friend[i].unit) then ui.debug("Casting Wild Growth on "..unit.name(thisUnit)) return true end
					end
                end
            end
        end
        -- Regrowth
        if ui.checked("Regrowth") and cast.able.regrowth() and not (IsMounted() or IsFlying())
            and (ui.value("Auto Heal") ~= 1 or (ui.value("Auto Heal") == 1
            and unit.distance(br.friend[1].unit) < 40)) and not cast.current.regrowth()
        then
            local thisHP = unit.hp()
            local thisUnit = "player"
            local lowestUnit = getLowestUnit(40)
            local fhp = unit.hp(lowestUnit)
            if ui.value("Auto Heal") == 1 then thisHP = fhp; thisUnit = lowestUnit end
            if not unit.inCombat() then
                -- Don't Break Form
                if ui.value("Regrowth - OoC") == 2 then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= ui.value("Regrowth") and not unit.moving())
                        and (GetShapeshiftForm() == 0 or buff.predatorySwiftness.exists())
                    then
                        if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth [OoC No Break] on "..unit.name(thisUnit)) return true end
                    end
                end
                -- Break Form
                if ui.value("Regrowth - OoC") == 1 and unit.hp() <= ui.value("Regrowth") and not unit.moving() then
                    if GetShapeshiftForm() ~= 0 and not buff.predatorySwiftness.exists() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                    else
                       if cast.regrowth("player") then ui.debug("Casting Regrowth [OoC Break] on "..unit.name(thisUnit)) return true end
                    end
                end
            elseif unit.inCombat() and (buff.predatorySwiftness.exists() or unit.level() < 49) then
                -- Always Use Predatory Swiftness when available
                if ui.value("Regrowth - InC") == 1 or not talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= ui.value("Regrowth") and unit.level() >= 49) or (unit.level() < 49 and thisHP <= ui.value("Regrowth") / 2) then
                        if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth [IC Instant] on "..unit.name(thisUnit)) return true end
                    end
                end
                -- Hold Predatory Swiftness for Bloodtalons unless Health is Below Half of Threshold or Predatory Swiftness is about to Expire.
                if ui.value("Regrowth - InC") == 2 and talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= ui.value("Regrowth") / 2) or buff.predatorySwiftness.remain() < unit.gcd(true) * 2 then
                        if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth [IC BT Hold] on "..unit.name(thisUnit)) return true end
                    end
                end
            end
        end
        -- Survival Instincts
        if ui.checked("Survival Instincts") and unit.inCombat() and cast.able.survivalInstincts()
            and unit.hp() <= ui.value("Survival Instincts")
            and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0
        then
            if cast.survivalInstincts() then ui.debug("Casting Survival Instincts") return true end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() then
        local thisUnit
        -- Skull Bash
        if ui.checked("Skull Bash") and cast.able.skullBash() then
            for i=1, #enemies.yards13f do
                thisUnit = enemies.yards13f[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.skullBash(thisUnit) then ui.debug("Casting Skull Bash on "..unit.name(thisUnit)) return true end
                end
            end
        end
        -- Mighty Bash
        if ui.checked("Mighty Bash") and cast.able.mightyBash() then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                    if cast.mightyBash(thisUnit) then ui.debug("Casting Mighty Bash on "..unit.name(thisUnit)) return true end
                end
            end
        end
        -- Maim
        if ui.checked("Maim") and cast.able.maim() then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if canInterrupt(thisUnit,ui.value("Interrupt At"))
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
    if unit.distance(units.dyn5) < 5 then
        -- Berserk/Incarnation
        -- berserk,if=buff.prowl.down
        -- incarnation,if=buff.prowl.down
        if ui.checked("Berserk/Incarnation") and useCDs()
            and not buff.prowl.exists() and range.dyn5
        then
            if cast.able.berserk() and not talent.incarnationKingOfTheJungle then
                if cast.berserk() then ui.debug("Casting Berserk") return true end
            end
            if cast.able.incarnationKingOfTheJungle() and talent.incarnationKingOfTheJungle then
                if cast.incarnationKingOfTheJungle() then ui.debug("Casting Incarnation: King of the Jungle") return true end
            end
        end
        -- Tiger's Fury
        -- tigers_fury,if=energy.deficit>55|buff.berserk_cat.remains<13|buff.incarnation_king_of_the_jungle.remains<13
        if ui.checked("Tiger's Fury") and cast.able.tigersFury() and range.dyn5
            and (energyDeficit >= 55 or snipeTF() or (buff.berserk.exists() and buff.berserk.remain() < 13)
                or (buff.incarnationKingOfTheJungle.exists() and buff.incarnationKingOfTheJungle.remain() < 13))
        then
            if cast.tigersFury() then ui.debug("Casting Tiger's Fury") return true end
        end
        -- Shadowmeld
        -- shadowmeld,if=buff.tigers_fury.up&buff.berserk_cat.down&buff.incarnation_king_of_the_jungle.down&buff.prowl.down&combo_points<4&dot.rake.pmultiplier<1.6&energy>40
        if ui.checked("Racial") and race == "NightElf" and cast.able.racial() and useCDs()
            and unit.distance(units.dyn5) < 5 and not solo and var.friendsInRange --findFriends() > 0
        then
            if buff.tigersFury.exists() and not buff.berserk.exists() and not buff.incarnationKingOfTheJungle.exists()
            and not buff.prowl.exists() and comboPoints < 4 and debuff.rake.applied(units.dyn5) < 1.6 and energy > 40
            then
                if cast.racial() then ui.debug("Casting "..GetSpellInfo(spell.racial)) return true end
            end
        end
        -- Racial: Berserking (Troll)
        -- berserking,if=buff.tigers_fury.up|buff.berserk_cat.up|buff.incarnation_king_of_the_jungle.up
        if ui.checked("Racial") and race == "Troll" and cast.able.racial() and useCDs()
            and (buff.tigersFury.exists() or buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists())
        then
            if cast.racial() then ui.debug("Casting "..GetSpellInfo(spell.racial)) return true end
        end
        -- Potion
        -- potion,if=buff.berserk_cat.up|buff.incarnation_king_of_the_jungle.up
        if ui.value("Potion") ~= 2 and unit.isBoss("target") then
            if ((inRaid or (inInstance and unit.ttd(units.dyn5) > 45)) and (buff.berserk.exists() and buff.berserk.remain() > 18
                or buff.incarnationKingOfTheJungle.exists() and buff.incarnationKingOfTheJungle.remain() > 28))
            then
                if ui.value("Potion") == 1 and use.able.potionOfFocusedResolve() then
                    use.potionOfFocusedResolve()
                    ui.debug("Using Potion of Focused Resolve");
                end
            end
        end
        -- Trinkets
        if (use.able.slot(13) or use.able.slot(14)) then
            local opValue = ui.value("Trinkets")
            if (opValue == 1 or (opValue == 2 and useCDs())) and unit.distance(units.dyn5) < 5 then
                for i = 13, 14 do
                    if use.able.slot(i) then
                        -- Ashvanes Razor Coral
                        -- use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|debuff.conductive_ink_debuff.up&target.time_to_pct_30<1.5|!debuff.conductive_ink_debuff.up&(debuff.razor_coral_debuff.stack>=25-10*debuff.blood_of_the_enemy.up|target.time_to_die<40)&buff.tigers_fury.remains>10
                        if equiped.ashvanesRazorCoral(i) and (not debuff.razorCoral.exists(units.dyn5) or (debuff.conductiveInk.exists(units.dyn5) and unit.ttd(units.dyn5,30) < 1.5)
                            or not debuff.conductiveInk.exists(units.dyn30) and (debuff.razorCoral.stack(razorTarget()) >= 25 - (10 * var.enemyBlood) or (unit.ttd(units.dyn5) < 40 and useCDs()))
                            and buff.tigersFury.remain() > 10)
                        then
                            use.slot(i)
                            ui.debug("Using Ashvane's Razor Coral [Slot "..i.."]")
                        end
                        -- Cyclotronic Blast
                        if useCDs() and equiped.pocketSizedComputationDevice(i) and equiped.socket.pocketSizedComputationDevice(167672,1) then
                            -- use_item,effect_name=cyclotronic_blast,if=(energy.deficit>=energy.regen*3)&buff.tigers_fury.down&!azerite.jungle_fury.enabled
                            if energyDeficit >= energyRegen * 3 and not buff.tigersFury.exists() and not traits.jungleFury.active then
                                use.slot(i)
                                ui.debug("Using Cyclotronic Blast [Slot "..i.."]")
                            end
                            -- use_item,effect_name=cyclotronic_blast,if=buff.tigers_fury.up&azerite.jungle_fury.enabled
                            if buff.tigersFury.exists() and traits.jungleFury.active then
                                use.slot(i)
                                ui.debug("Using Cyclotronic Blast [Slot "..i.."]")
                            end
                        end
                        --Azshara's Font of Power
                        -- use_item,effect_name=azsharas_font_of_power,if=energy.deficit>=50
                        if useCDs() and equiped.azsharasFontOfPower(i) and energyDeficit >= 50 and not unit.moving() then
                            use.slot(i)
                            ui.debug("Using Azshara's Font of Power [Slot "..i.."]")
                        end
                        -- All Others
                        -- use_items,if=buff.tigers_fury.up|target.time_to_die<20
                        if not (equiped.ashvanesRazorCoral(i) or (equiped.pocketSizedComputationDevice(i) and equiped.socket.pocketSizedComputationDevice(167672,1))
                            or equiped.azsharasFontOfPower(i)) and (buff.tigersFury.exists() or (unit.ttd(units.dyn5) < 20 and useCDs()))
                        then
                            use.slot(i)
                            ui.debug("Using Trinket [Slot "..i.."]")
                        end
                    end
                end
            end
        end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        -- blood_fury,buff.tigers_fury | arcane_torrent,buff.tigers_fury
        if ui.checked("Racial") and cast.able.racial() and useCDs()
            and (race == "Orc" or race == "BloodElf")
        then
            if buff.tigersFury.exists() then
                if cast.racial("player") then ui.debug("Casting "..GetSpellInfo(spell.racial)) return true end
            end
        end
        -- Wrists - Wraps of Electrostatic Potential
        if equiped.wrapsOfElectrostaticPotential() and use.able.wrapsOfElectrostaticPotential() then
            local opValue = ui.value("Trinkets")
            if (opValue == 1 or (opValue == 2 and useCDs())) and unit.distance(units.dyn5) < 5 then
                if use.wrapsOfElectrostaticPotential() then ui.debug("Using Wraps of Electrostatic Potential") return true end
            end
        end
        -- Call ActionList - Essence
        if actionList.Essence() then return end
    end -- End useCooldowns check
end -- End Action List - Cooldowns

-- Action List - Essence
actionList.Essence = function()
    if ui.checked("Use Essence") then
        -- Essence: The Unbound Force
        -- the_unbound_force,if=buff.reckless_force.up|buff.tigers_fury.up
        if cast.able.theUnboundForce()
            and (buff.recklessForce.exists() or buff.tigersFury.exists())
        then
            if cast.theUnboundForce() then ui.debug("Casting The Unbound Force") return true end
        end
        -- Essence: Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=buff.berserk_cat.up|buff.incarnation_king_of_the_jungle.up
        if useCDs() and cast.able.memoryOfLucidDreams()
            and (buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists())
        then
            if cast.memoryOfLucidDreams() then ui.debug("Casting Memory of Lucid Dreams") return true end
        end
        -- Essence: Blood of the Enemy
        -- blood_of_the_enemy,if=buff.tigers_fury.up&combo_points=5
        if useCDs() and cast.able.bloodOfTheEnemy() and buff.tigersFury.exists() and comboPoints == 5 then
            if cast.bloodOfTheEnemy() then ui.debug("Casting Blood of the Enemy") return true end
        end
        -- Essence: Focused Azerite Beam
        -- focused_azerite_beam,if=active_enemies>desired_targets|(raid_event.adds.in>90&energy.deficit>=50)
        if cast.able.focusedAzeriteBeam() and (enemies.yards30r >= 3 or (useCDs() and energyDeficit >= 50
                and debuff.rake.remain(units.dyn5) > 5 and debuff.rip.remain(units.dyn5) > 5))
            and not (buff.tigersFury.exists() or buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists())
        then
            if cast.focusedAzeriteBeam(nil,"rect",var.minCount,30) then
                ui.debug("Casting Focused Azerite Beam")
                return true
            end
        end
        -- Essence: Purifying Blast
        -- purifying_blast,if=active_enemies>desired_targets|raid_event.adds.in>60
        if cast.able.purifyingBlast() and (#enemies.yards8t >= 3 or useCDs()) then
            if cast.purifyingBlast("best", nil, var.minCount, 8) then ui.debug("Casting Purifying Blast") return true end
        end
        if buff.tigersFury.exists() then
            -- Essence: Guardian of Azeroth
            -- guardian_of_azeroth,if=buff.tigers_fury.up
            if useCDs() and cast.able.guardianOfAzeroth() then
                if cast.guardianOfAzeroth() then ui.debug("Casting Guardian of Azeroth") return end
            end
            -- Essence: Concentrated Flame
            -- concentrated_flame,if=buff.tigers_fury.up
            if cast.able.concentratedFlame() then
                if cast.concentratedFlame() then ui.debug("Casting Concentrated Flame") return true end
            end
            -- Essence: Ripple In Space
            -- ripple_in_space,if=buff.tigers_fury.up
            if cast.able.rippleInSpace() then
                if cast.rippleInSpace() then ui.debug("Casting Ripple In Space") return end
            end
            -- Essence: Worldvein Resonance
            -- worldvein_resonance,if=buff.tigers_fury.up
            if cast.able.worldveinResonance() then
                if cast.worldveinResonance() then ui.debug("Casting Worldvein Resonance") return end
            end
        end
        -- Essence: Reaping Flames
        -- reaping_flames,target_if=target.time_to_die<1.5|((target.health.pct>80|target.health.pct<=20)&variable.reaping_delay>29)|(target.time_to_pct_20>30&variable.reaping_delay>44)
        if cast.able.reapingFlames() and (unit.ttd(units.dyn5) < 1.5
            or (((unit.hp(units.dyn5) > 80 or unit.hp(units.dyn5) <= 20) and var.reapingDelay > 29)
            or (unit.ttd(units.dyn5,20) > 30 and var.reapingDelay > 44)))
        then
            if cast.reapingFlames() then ui.debug("Casting Reaping Flames") return true end
        end
    end
end -- End Action List - Essence

-- Action List - Opener
actionList.Opener = function()
    -- Wild Charge
    if ui.checked("Wild Charge") and cast.able.wildCharge("target") and unit.valid("target")
        and unit.distance("target") >= 8 and unit.distance("target") < 30
    then
        if cast.wildCharge("target") then ui.debug("Casting Wild Charge on "..unit.name("target").." [Opener]") return true end
    end
    -- Start Attack
    -- auto_attack
    if ui.checked("Opener") and unit.isBoss("target") and not opener.complete then
        if unit.valid("target") and unit.distance("target") < 5
            and unit.facing("player","target") and unit.gcd() == 0
        then
            -- Begin
            if not opener.OPN1 then
                ui.print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
            -- Tiger's Fury
            -- tigers_fury
            elseif opener.OPN1 and not opener.TF1 then
                if cd.tigersFury.remain() > unit.gcd() then
                    castOpenerFail("tigersFury","TF1",opener.count)
                elseif cast.able.tigersFury() then
                    castOpener("tigersFury","TF1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Rake
            -- rake,if=!ticking|buff.prowl.up
            elseif opener.TF1 and not opener.RK1 then
                if debuff.rake.exists("target") then
                    castOpenerFail("rake","RK1",opener.count)
                elseif cast.able.rake() then
                    castOpener("rake","RK1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Moonfire
            -- moonfire_cat,if=!ticking
            elseif opener.RK1 and not opener.MF1 then
                if not talent.lunarInspiration or debuff.moonfireFeral.exists("target") then
                    castOpenerFail("moonfireFeral","MF1",opener.count)
                elseif cast.able.moonfireFeral() then
                    castOpener("moonfireFeral","MF1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Rip
            -- rip,if=!ticking
            elseif opener.MF1 and not opener.RIP1 then
                if debuff.rip.exists("target") or comboPoints == 0 then
                    castOpenerFail("rip","RIP1",opener.count)
                elseif cast.able.rip() then
                    if usePrimalWrath() then
                        castOpener("primalWrath","RIP1",opener.count)
                    else
                        castOpener("rip","RIP1",opener.count)
                    end
                end
                opener.count = opener.count + 1
                return
            -- Finish (rip exists)
            elseif opener.RIP1 and (debuff.rip.exists("target") or comboPoints == 0) then
                ui.print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (unit.exists("target") and not unit.isBoss("target")) or not ui.checked("Opener") then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Finisher
actionList.Finisher = function()
    -- Savage Roar
    -- savage_roar,if=refreshable
    if cast.able.savageRoar() and buff.savageRoar.refresh() then
        if cast.savageRoar("player") then ui.debug("Casting Savage Roar [Finish]") return true end
    end
    -- Primal Wrath
    -- primal_wrath,if=druid.primal_wrath.ticks_gained_on_refresh>(variable.rip_ticks>?variable.best_rip)|spell_targets.primal_wrath>(3+1*talent.sabertooth.enabled)
    if usePrimalWrath() and (not var.noDoT or #enemies.yards8 > 1) and range.dyn8AOE and (ticksGain.rip > ripTicks or ticksGain.rip > bestRip) or #enemies.yards8 > (3 + 1 * var.sabertooth) then
        if cast.primalWrath(nil,"aoe",1,8) then ui.debug("Casting Primal Wrath [Finish]") return true end
    end
    -- Rip
    -- rip,target_if=(!ticking|(remains+combo_points*talent.sabertooth.enabled)<duration*0.3|dot.rip.pmultiplier<persistent_multiplier)&druid.rip.ticks_gained_on_refresh>variable.rip_ticks
    if cast.able.rip() and range.dyn5 and not var.noDoT and not usePrimalWrath() then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot))
                and not UnitIsCharmed(thisUnit) and canDoT(thisUnit) and unit.facing("player",thisUnit)
            then
                if (not debuff.rip.exists(thisUnit) or (debuff.rip.remain(thisUnit) + comboPoints * var.sabertooth) < 24 * 0.3
                    or debuff.rip.calc() > debuff.rip.applied(thisUnit)) and ticksGain.rip > ripTicks and (unit.ttd(thisUnit) > 8 or unit.isDummy(thisUnit))
                then
                    if cast.rip(thisUnit) then ui.debug("Casting Rip [Finish]") return true end
                end
            end
        end
    end
    -- Maim
    -- maim,if=buff.iron_jaws.up
    if cast.able.maim() and buff.ironJaws.exists() and range.dyn5 then
        if cast.maim() then ui.debug("Casting Maim [Finish]") return true end
    end
    -- Ferocious Bite
    -- ferocious_bite,max_energy=1
    if cast.able.ferociousBite() and var.fbMaxEnergy --[[and not usePrimalWrath()]] and range.dyn5
        -- and (buff.savageRoar.remain() >= 12 or not talent.savageRoar)
        -- and (not debuff.rip.refresh(units.dyn5) or unit.hp(units.dyn5) <= 25
            -- or ferociousBiteFinish(units.dyn5) or unit.level() < 20 or unit.ttd(units.dyn5) <= 8
            -- or UnitIsCharmed(units.dyn5) or not canDoT(units.dyn5) or unit.isDummy(units.dyn5))
    then
        --if ui.value("Ferocious Bite Execute") == 1 and ferociousBiteFinish(units.dyn5) then
            --ui.print("Ferocious Bite Finished! "..unit.name(units.dyn5).." with "..round2(thp(units.dyn5),0).."% health remaining.")
        --end
        if cast.ferociousBite() then ui.debug("Casting Ferocious Bite [Finish]") return true end
    end
end -- End Action List - Finisher

-- Action List - Filler
actionList.Filler = function()
    -- Rake
    -- rake,target_if=variable.filler=1&dot.rake.pmultiplier<=persistent_multiplier
    if cast.able.rake() and filler == 1
        and range.dyn5 and debuff.rake.refresh(units.dyn5)
        and debuff.rake.count() < ui.value("Multi-DoT Limit")
        and #enemies.yards5f < ui.value("Multi-DoT Limit")
    then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if debuff.rake.refresh(thisUnit) then --debuff.rake.applied(this) < debuff.rake.calc() then
                if cast.rake(thisUnit) then ui.debug("Casting Rake [Filler - 1]") return true end
            end
        end
    end
    -- Rake
    -- rake,if=variable.filler=2
    if cast.able.rake() and filler == 2
        and range.dyn5 and debuff.rake.refresh(units.dyn5)
        and debuff.rake.count() < ui.value("Multi-DoT Limit")
        and #enemies.yards5f < ui.value("Multi-DoT Limit")
    then
        if cast.rake() then ui.debug("Casting Rake [Filler - 2]") return true end
    end
    -- Lunar Inspiration
    -- lunar_inspiration,if=variable.filler=3
    if cast.able.moonfireFeral() and talent.lunarInspiration and debuff.moonfire.refresh(units.dyn40)
        and not var.noDoT and range.dyn40
        and canDoT(units.dyn40) and debuff.moonfireFeral.count() < ui.value("Multi-DoT Limit")
        and #enemies.yards40 < ui.value("Multi-DoT Limit") and filler == 3
    then
        if cast.moonfireFeral() then ui.debug("Casting Moonfire [Filler - 3]") return true end
    end
    -- Swipe
    -- swipe,if=variable.filler=4
    if cast.able.swipeCat() and filler == 4 and not talent.brutalSlash
        and not unit.isExplosive("target") and range.dyn8AOE
    then
        if cast.swipeCat() then ui.debug("Casting Swipe [Filler - 4]") return true end
    end
    -- Shred
    -- shred
    if cast.able.shred() and range.dyn5 and not (buff.prowl.exists() or buff.shadowmeld.exists())
        and (((ui.mode.rotation == 1 and #enemies.yards5f == 1) or (ui.mode.rotation == 3 and #enemies.yards5f > 0)
            or talent.brutalSlash or not cast.safe.swipeCat("player",8,1))
        and (unit.isDummy() or unit.ttd(units.dyn5) <= 4 or not canDoT(units.dyn5) or buff.clearcasting.exists())
        or unit.isExplosive("target"))
    then
        if cast.shred() then ui.debug("Casting Shred [Filler]") return true end
    end
end -- End Action List - Filler

-- Action List - Stealth
actionList.Stealth = function()
    -- Bloodtalons
    -- run_action_list,name=bloodtalons,if=talent.bloodtalons.enabled&buff.bloodtalons.down
    if talent.bloodtalons and not buff.bloodtalons.exists() then
        if actionList.Bloodtalons() then return true end
    end
    -- Rake
    -- rake,target_if=dot.rake.pmultiplier<1.6&druid.rake.ticks_gained_on_refresh>2
    if cast.able.rake() then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if debuff.rake.applied(thisUnit) < 1.6 and ticksGain.rake > 2 then
                if cast.rake(thisUnit) then ui.debug("Casting Rake [Stealth]") return true end
            end
        end
    end
    -- Shred
    -- shred
    if cast.able.shred() then
        if cast.shred() then ui.debug("Casting Shred [Stealth]") return true end
    end
end -- End Action List - Stealth

-- Action List - Bloodtalons
actionList.Bloodtalons = function()
    -- Rake
    -- rake,target_if=(!ticking|(refreshable&persistent_multiplier>dot.rake.pmultiplier))&buff.bt_rake.down&druid.rake.ticks_gained_on_refresh>=2
    if cast.able.rake() and not btGen.rake then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if (not debuff.rake.exists(thisUnit) or (debuff.rake.refresh(thisUnit) and debuff.rake.calc() > debuff.rake.applied(thisUnit))) and ticksGain.rake >= 2 then
                if cast.rake(thisUnit) then 
                    ui.debug("Casting Rake [BT - Ticks Gain]") 
                    btGen.rake = true 
                    if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
                    return true 
                end
            end
        end
    end
    -- Lunar Inspiration
    -- lunar_inspiration,target_if=refreshable&buff.bt_moonfire.down
    if cast.able.moonfireFeral() and talent.lunarInspiration and not btGen.moonfireFeral then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                if debuff.moonfireFeral.refresh(thisUnit) then
                    if cast.moonfireFeral(thisUnit) then 
                        ui.debug("Casting Moonfire [BT]") 
                        btGen.moonfireFeral = true 
                        if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
                        return true 
                    end
                end
            end
        end
    end
    -- Thrash
    -- thrash_cat,target_if=refreshable&buff.bt_thrash.down&druid.thrash_cat.ticks_gained_on_refresh>8
    if cast.able.thrashCat() and not btGen.thrash then
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if debuff.thrashCat.refresh(thisUnit) and ticksGain.thrash > 8 then
                if cast.thrashCat(thisUnit) then 
                    ui.debug("Casting Thrash [BT - Ticks Gain]") 
                    btGen.thrash = true 
                    if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
                    return true 
                end
            end
        end
    end
    -- Brutal Slash
    -- brutal_slash,if=buff.bt_brutal_slash.down
    if cast.able.brutalSlash() and not btGen.brutalSlash then
        if cast.brutalSlash() then 
            ui.debug("Casting Brutal Slash [BT]") 
            btGen.brutalSlash = true 
            if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
            return true 
        end
    end
    -- Swipe
    -- swipe_cat,if=buff.bt_swipe.down&spell_targets.swipe_cat>1
    if cast.able.swipeCat() and not btGen.swipe and #enemies.yards8 > 1 then
        if cast.swipeCat() then 
            ui.debug("Casting Swipe [BT - Multi]") 
            btGen.swipe = true 
            if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
            return true 
        end
    end
    -- Shred
    -- shred,if=buff.bt_shred.down
    if cast.able.shred() and not btGen.shred then
        if cast.shred() then 
            ui.debug("Casting Shred [BT]") 
            btGen.shred = true 
            if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
            return true 
        end
    end
    -- Swipe
    -- swipe_cat,if=buff.bt_swipe.down
    if cast.able.swipeCat() and not btGen.swipe then
        if cast.swipeCat() then 
            ui.debug("Casting Swipe [BT]") 
            btGen.swipe = true 
            if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
            return true 
        end
    end
    -- Thrash
    -- thrash_cat,if=buff.bt_thrash.down
    if cast.able.thrashCat() and not btGen.thrash then
        if cast.thrashCat() then 
            ui.debug("Casting Thrash [BT - No Buff]") 
            btGen.thrash = true 
            if btGen.timer - GetTime() <= 0 then btGen.timer = GetTime() + 4 end
            return true 
        end
    end
end -- End Action List - Bloodtalons

-- -- Action List - Generator
-- actionList.Generator = function()
--     -- Regrowth
--     -- regrowth,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.down&combo_points=4&dot.rake.remains<4
--     -- regrowth,if=talent.bloodtalons.enabled&buff.bloodtalons.down&buff.predatory_swiftness.up&talent.lunar_inspiration.enabled&dot.rake.remains<1
--     if cast.able.regrowth() and talent.bloodtalons
--         and not buff.bloodtalons.exists() and buff.predatorySwiftness.exists()
--     then
--         if (comboPoints == 4 and debuff.rake.remain(units.dyn5) < 4)
--             or (talent.lunarInspiration and debuff.rake.remain(units.dyn5) < 1)
--         then
--             local opValue = ui.value("Auto Heal")
--             local thisUnit = br.friend[1].unit
--             if opvalue == 1 and unit.distance(thisUnit) < 40 then
--                 if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth on "..unit.name(thisUnit).." [BT]") return true end
--             elseif opValue == 2 then
--                 if cast.regrowth("player") then ui.debug("Casting Regrowth [BT < 5cp]") return true end
--             end
--         end
--     end
--     -- Brutal Slash
--     -- brutal_slash,if=spell_targets.brutal_slash>desired_targets
--     if cast.able.brutalSlash() and talent.brutalSlash and not unit.isExplosive("target") and not buff.bloodtalons.exists()
--         and (useThrash ~= 2 or debuff.thrashCat.exists(units.dyn8AOE)) and ui.mode.rotation < 3
--         and ((ui.mode.rotation == 1 and #enemies.yards8 >= ui.value("Brutal Slash Targets"))
--             or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
--         and range.dyn8AOE
--     then
--         if cast.brutalSlash("player","aoe",1,8) then ui.debug("Casting Brutal Slash [AOE]") return true end
--     end
--     -- Thrash
--     -- pool_resource,for_next=1
--     -- thrash_cat,if=(refreshable)&(spell_targets.thrash_cat>2)
--     if (cast.pool.thrashCat() or cast.able.thrashCat()) and (not var.noDoT or #enemies.yards8 > 1) and not unit.isExplosive("target")
--         and unit.ttd(units.dyn8AOE) > 4 and range.dyn8AOE
--     then
--         if (not debuff.thrashCat.exists(units.dyn8AOE) or debuff.thrashCat.refresh(units.dyn8AOE))
--             and ((ui.mode.rotation == 1 and #enemies.yards8 > 2) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
--         then
--             if cast.pool.thrashCat() then ChatOverlay("Pooling For Thrash: "..#enemies.yards8.." targets") return true end
--             if cast.able.thrashCat() then
--                 if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash [AOE]") return true end
--             end
--         end
--     end
--     -- pool_resource,for_next=1
--     -- thrash_cat,if=(talent.scent_of_blood.enabled&buff.scent_of_blood.down)&spell_targets.thrash_cat>3
--     if (cast.pool.thrashCat() or cast.able.thrashCat()) and (not var.noDoT or #enemies.yards8 > 1) and not unit.isExplosive("target")
--         and (talent.scentOfBlood and not buff.scentOfBlood.exists()
--         and ((ui.mode.rotation == 1 and #enemies.yards8 > 3) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)))
--         and unit.ttd(units.dyn8AOE) > 4 and range.dyn8AOE
--     then
--         if cast.pool.thrashCat() then ChatOverlay("Pooling For Thrash: Scent of Blood") return true end
--         if cast.able.thrashCat() then
--             if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash [Scent of Blood]") return true end
--         end
--     end
--     -- Swipe
--     -- pool_resource,for_next=1
--     -- swipe_cat,if=buff.scent_of_blood.up|(action.swipe_cat.damage*spell_targets.swipe_cat>(action.rake.damage+(action.rake_bleed.tick_damage*5)))
--     if (cast.pool.swipeCat() or cast.able.swipeCat()) and not talent.brutalSlash
--         and not unit.isExplosive("target") and buff.scentOfBlood.exists() and range.dyn8AOE
--     then
--         if cast.pool.swipeCat() then ChatOverlay("Pooling For Swipe - Scent of Blood") return true end
--         if cast.able.swipeCat() then
--             if cast.swipeCat("player","aoe",1,8) then ui.debug("Casting Swipe [Scent of Blood]") return true end
--         end
--     end
--     -- Rake
--     -- pool_resource,for_next=1
--     -- rake,target_if=!ticking|(!talent.bloodtalons.enabled&remains<duration*0.3)&target.time_to_die>4
--     -- rake,target_if=talent.bloodtalons.enabled&buff.bloodtalons.up&((remains<=7)&persistent_multiplier>dot.rake.pmultiplier*0.85)&target.time_to_die>4
--     if (cast.pool.rake() or cast.able.rake()) and (debuff.rake.count() < ui.value("Multi-DoT Limit")
--         and (#enemies.yards5f < ui.value("Multi-DoT Limit")
--             or not traits.wildFleshrending.active or traits.bloodMist.active))
--         and range.dyn5
--     then
--         local function rakeLogic(thisUnit)
--             if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot))
--                 and (unit.ttd(thisUnit) > 4 or unit.isDummy(thisUnit)) and not UnitIsCharmed(thisUnit)
--                 and canDoT(thisUnit) and unit.facing("player",thisUnit)
--             then
--                 if (not debuff.rake.exists(thisUnit) or (not talent.bloodtalons and debuff.rake.refresh(thisUnit)))
--                     or (talent.bloodtalons and buff.bloodtalons.exists() and debuff.rake.remain(thisUnit) <= 4.5
--                     and debuff.rake.calc() > debuff.rake.applied(thisUnit) * 0.85)
--                 then
--                     return true
--                 end
--             end
--             return false
--         end
--         if rakeLogic("target") then
--             if cast.pool.rake() then ChatOverlay("Pooling For Rake") return true end
--             if cast.rake("target") then ui.debug("Casting Rake on "..unit.name("target").." [Target]") return true end
--         end
--         for i = 1, #enemies.yards5f do
--             local thisUnit = enemies.yards5f[i]
--             if rakeLogic(thisUnit) then
--                 if cast.pool.rake() then ChatOverlay("Pooling For Rake") return true end
--                 if cast.rake(thisUnit) then ui.debug("Casting Rake on "..unit.name(thisUnit).." [Multi-DoT]") return true end
--             end
--         end
--     end
--     -- Moonfire
--     -- moonfire_cat,if=buff.bloodtalons.up&buff.predatory_swiftness.down&combo_points<5
--     if cast.able.moonfireFeral() and talent.lunarInspiration and not var.noDoT and range.dyn40
--         and canDoT(units.dyn40) and (debuff.moonfireFeral.count() < ui.value("Multi-DoT Limit")
--         and (#enemies.yards40 < ui.value("Multi-DoT Limit") or not traits.wildFleshrending.active or traits.bloodMist.active))
--     then
--         if buff.bloodtalons.exists() and not buff.predatorySwiftness.exists() and comboPoints < 5 then
--             if cast.moonfireFeral() then ui.debug("Casting Moonfire on "..unit.name(units.dyn40).." [BT]") return true end
--         end
--     end
--     -- Brutal Slash
--     -- brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))
--     if cast.able.brutalSlash() and talent.brutalSlash and not unit.isExplosive("target") and not buff.bloodtalons.exists()
--         and (useThrash ~= 2 or debuff.thrashCat.exists(units.dyn8AOE))
--         and (buff.tigersFury.exists() or charges.brutalSlash.timeTillFull() < unit.gcd(true))
--         and (#enemies.yards8 < ui.value("Brutal Slash Targets") or (ui.mode.rotation == 3 and #enemies.yards8 > 0))
--         and range.dyn8AOE
--     then
--         if cast.brutalSlash("player","aoe",1,8) then ui.debug("Casting Brutal Slash [Max Charges]") return true end
--     end
--     -- Moonfire
--     -- moonfire_cat,target_if=refreshable
--     if cast.able.moonfireFeral() and talent.lunarInspiration and not var.noDoT and range.dyn40
--         and (debuff.moonfireFeral.count() < ui.value("Multi-DoT Limit")
--         and (#enemies.yards40 < ui.value("Multi-DoT Limit") or not traits.wildFleshrending.active or traits.bloodMist.active))
--     then
--         for i = 1, #enemies.yards40 do
--             local thisUnit = enemies.yards40[i]
--             if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
--                 if canDoT(thisUnit) and debuff.moonfireFeral.refresh(thisUnit) then --or (unit.isDummy(thisUnit) and unit.distance(thisUnit) < 8) then
--                     if cast.moonfireFeral(thisUnit) then ui.debug("Casting Moonfire on "..unit.name(thisUnit).." [Multi-DoT]") return true end
--                 end
--             end
--         end
--     end
--     -- Thrash
--     -- pool_resource,for_next=1
--     -- thrash_cat,if=refreshable&((variable.use_thrash=2&(!buff.incarnation.up|azerite.wild_fleshrending.enabled))|spell_targets.thrash_cat>1)
--     -- thrash_cat,if=refreshable&variable.use_thrash=1&buff.clearcasting.react&(!buff.incarnation.up|azerite.wild_fleshrending.enabled)
--     if (cast.pool.thrashCat() or cast.able.thrashCat()) and (not var.noDoT or #enemies.yards8 > 1) and not unit.isExplosive("target") and unit.ttd(units.dyn8AOE) > 4
--         and debuff.thrashCat.refresh(units.dyn8AOE) and ui.mode.rotation < 3 and range.dyn8AOE
--     then
--         if (useThrash == 2 or (useThrash == 0 and buff.clearcasting.exists())
--             and ((not buff.incarnationKingOfTheJungle.exists() or traits.wildFleshrending.active)
--             or (ui.mode.rotation == 1 and #enemies.yards8 > 1) or (ui.mode.rotation == 2 and #enemies.yards8 > 0)))
--         then
--             if cast.pool.thrashCat() and not buff.clearcasting.exists() then ChatOverlay("Pooling For Thrash") return true end
--             if cast.able.thrashCat() or buff.clearcasting.exists() then
--                 if cast.thrashCat("player","aoe",1,8) then ui.debug("Casting Thrash [Use Thrash Variable "..useThrash.."]") return true end
--             end
--         end
--     end
--     -- Swipe
--     -- pool_resource,for_next=1
--     -- swipe_cat,if=spell_targets.swipe_cat>1
--     if (cast.pool.swipeCat() or cast.able.swipeCat()) and not unit.isExplosive("target") and not talent.brutalSlash and range.dyn8AOE--and multidot
--         and ((ui.mode.rotation == 1 and #enemies.yards8 > 1) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
--     then
--         if cast.pool.swipeCat() then ChatOverlay("Pooling For Swipe") return true end
--         if cast.able.swipeCat() then
--             if debuff.repeatPerformance.exists("player") and cast.last.swipeCat() then
--                 if cast.shred("player") then ui.debug("Casting Shred [Repeat Performance]") return true end
--             else
--                 if cast.swipeCat("player","aoe",1,8) then ui.debug("Casting Swipe [AOE]") return true end
--             end
--         end
--     end
--     -- Shred
--     -- shred,if=dot.rake.remains>(action.shred.cost+action.rake.cost-energy)%energy.regen|buff.clearcasting.react
--     if cast.able.shred() and range.dyn5 and not (buff.prowl.exists() or buff.shadowmeld.exists())
--         and ((ui.mode.rotation == 1 and #enemies.yards5f == 1) or (ui.mode.rotation == 3 and #enemies.yards5f > 0)
--             or talent.brutalSlash or unit.level() < 32 or unit.isExplosive("target") or not cast.safe.swipeCat("player",8,1))
--         and (debuff.rake.remain(units.dyn5) > ((cast.cost.shred() + cast.cost.rake() - energy) / energyRegen)
--             or unit.ttd(units.dyn5) <= 4 or not canDoT(units.dyn5) or buff.clearcasting.exists()
--             or unit.level() < 12 or unit.isExplosive("target"))
--     then
--         if debuff.repeatPerformance.exists("player") and cast.last.shred() then
--             if cast.swipeCat("player") then ui.debug("Casting Swipe [Repeat Performance]") return true end
--         else
--             if cast.shred() then ui.debug("Casting Shred") return true end
--         end
--     end
-- end -- End Action List - Generator

-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (IsFlying() or IsMounted()) then
        if not stealth then
            -- Flask / Crystal
            -- flask
            local opValue = ui.value("Elixir")
            if opValue == 1 and inRaid and use.able.greaterFlaskOfTheCurrents()
                and not buff.greaterFlaskOfTheCurrents.exists()
            then
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.greaterFlaskOfTheCurrents() then ui.debug("Using Greater Flask of the Currents") return true end
            elseif opValue == 2 and use.able.repurposedFelFocuser() and not buff.felFocus.exists()
                and (not inRaid or (inRaid and not buff.greaterFlaskOfTheCurrents.exists()))
            then
                if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if use.repurposedFelFocuser() then ui.debug("Using Repurposed Fel Focuser") return true end
            elseif opValue == 3 and use.able.oraliusWhisperingCrystal()
                and not buff.whispersOfInsanity.exists()
            then
                if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.oraliusWhisperingCrystal() then ui.debug("Using Oralius's Whispering Crystal") return true end
            end
            -- Battle Scarred Augment Rune
            -- augmentation,type=defiled
            if ui.checked("Augment Rune") and inRaid and not buff.battleScarredAugmentation.exists()
                and use.able.battleScarredAugmentRune() and var.lastRune + unit.gcd(true) < GetTime()
            then
                if use.battleScarredAugmentRune() then ui.debug("Using Battle Scared Augment Rune") var.lastRune = GetTime() return true end
            end
            -- Prowl - Non-PrePull
            if cast.able.prowl("player") and cat and autoProwl() and ui.mode.prowl == 1
                and not buff.prowl.exists() and not IsResting() and GetTime() - var.leftCombat > lootDelay
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
                and var.htTimer < GetTime() - 1 and not buff.prowl.exists()
                and not cast.current.regrowth()
            then
                if GetShapeshiftForm() ~= 0 then
                    -- CancelShapeshiftForm()
                    RunMacroText("/CancelForm")
                end
                if cast.regrowth("player") then ui.debug("Casting Regrowth [Pre-pull]"); var.htTimer = GetTime(); return true end
            end
            -- Azshara's Font of Power
            -- use_item,name=azsharas_font_of_power
            if (use.able.slot(13) or use.able.slot(14)) then
                local opValue = ui.value("Trinkets")
                if (opValue == 1 or (opValue == 2 and useCDs())) and unit.distance(units.dyn5) < 5 then
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
            if buff.prowl.exists() then
                -- Pre-pot
                -- potion,name=old_war
                if ui.value("Potion") ~= 5 and ui.pullTimer() <= 1 and (inRaid or inInstance) then
                    if ui.value("Potion") == 1 and use.able.potionOfFocusedResolve() then
                        use.potionOfFocusedResolve()
                        ui.debug("Using Potion of Focused Resolve [Pre-Pull]");
                    end
                end
            end -- End Prowl
            -- Berserk/Tiger's Fury Pre-Pull
            if ui.checked("Berserk/Tiger's Fury Pre-Pull") and ui.pullTimer() <= 1 and (inRaid or inInstance) and unit.distance("target") < 8 then
                if cast.able.berserk() and cast.able.tigersFury() then
                    cast.berserk()
                    cast.tigersFury()
                    ui.debug("Casting Berserk and Tiger's Fury [Pre-Pull]")
                end
            end
        end -- End Pre-Pull
        -- Rake/Shred
        -- buff.prowl.up|buff.shadowmeld.up
        if unit.valid("target") and opener.complete and unit.distance("target") < 5 then
            -- if cast.able.rake() and unit.level() >= 12 and not var.noDoT and not debuff.rake.exists("target") then
            --     if cast.rake("target") then ui.debug("Casting Rake on "..unit.name("target").." [Pull]"); return true end
            -- elseif cast.able.shred() then
            --     if cast.shred("target") then ui.debug("Casting Shred on "..unit.name("target").." [Pull]"); return true end
            -- end

            -- Run Action List - Stealth
            -- run_action_list,name=stealth,if=buff.berserk_cat.up|buff.incarnation.up|buff.shadowmeld.up|buff.sudden_ambush.up|buff.prowl.up
            if buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists() or buff.shadowmeld.exists() or buff.suddenAmbush.exists() or buff.prowl.exists() then
                if actionList.Stealth() then return true end
            end
            -- Auto Attack
            -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and range.dyn5 and not (buff.prowl.exists() or buff.shadowmeld.exists()) then
                StartAttack(units.dyn5)
            end
        end
    end -- End No Combat
    -- Opener
    if actionList.Opener() then return true end
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
        buff                               = br.player.buff
        cast                               = br.player.cast
        cd                                 = br.player.cd
        charges                            = br.player.charges
        debuff                             = br.player.debuff
        enemies                            = br.player.enemies
        equiped                            = br.player.equiped
        essence                            = br.player.essence
        has                                = br.player.has
        item                               = br.player.items
        opener                             = br.player.opener
        spell                              = br.player.spell
        talent                             = br.player.talent
        traits                             = br.player.traits
        ui                                 = br.player.ui
        unit                               = br.player.unit
        units                              = br.player.units
        use                                = br.player.use
    end
    comboPoints                        = br.player.power.comboPoints.amount()
    energy, energyRegen, energyDeficit = br.player.power.energy.amount(), br.player.power.energy.regen(), br.player.power.energy.deficit()
    healPot                            = _G["getHealthPot"]()
    inInstance                         = br.player.unit.instance() == "party"
    inRaid                             = br.player.unit.instance() == "raid"
    lootDelay                          = br.player.ui.checked("Auto Loot") and br.player.ui.value("Auto Loot") or 0
    lowestHP                           = br.friend[1].unit
    var.minCount                       = br.player.ui.useCDs() and 1 or 3
    multidot                           = br.player.ui.mode.cleave == 1 and br.player.ui.mode.rotation < 3
    race                               = br.player.race
    solo                               = #br.friend < 2
    stealth                            = br.player.buff.prowl.exists() or br.player.buff.shadowmeld.exists()
    travel, flight, cat                = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.catForm.exists()
    ttm                                = br.player.power.energy.ttm()

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    units.get(8,true)
    units.get(5)
    if range == nil then range = {} end
    range.dyn40 = unit.distance(units.dyn40) < 40
    range.dyn8AOE = unit.distance(units.dyn8AOE) < 8
    range.dyn5 = unit.distance(units.dyn5) < 5

    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(40) -- makes enemies.yards40
    enemies.yards30r = getEnemiesInRect(10,30,false) or 0
    enemies.get(20,"player",true) -- makes enemies.yards20nc
    enemies.get(13,"player",false,true) -- makes enemies.yards13f
    enemies.get(8) -- makes enemies.yards8
    enemies.get(8,"player",false,true) -- makes enemies.yards8f
    enemies.get(8,"target") -- makes enemies.yards8t
    enemies.get(5,"player",false,true) -- makes enemies.yards5f

    -- General Vars
    if not unit.inCombat() and not unit.exists("target") then
        if var.profileStop then var.profileStop = false end
        var.leftCombat = GetTime()
    end
    var.unit5ID = GetObjectID(units.dyn5) or 0
    var.noDoT = var.unit5ID == 153758 or var.unit5ID == 156857 or var.unit5ID == 156849 or var.unit5ID == 156865 or var.unit5ID == 156869

    -- Blood of the Enemy
    var.enemyBlood = essence.bloodOfTheEnemy.active and 1 or 0

    -- Jagged Wounds Rip Duration Adj
    ripDuration = talent.jaggedWounds and 1.6 * (24 / 2) or 24

    -- Sabertooth
    var.sabertooth = talent.sabertooth and 1 or 0

    -- Clearcasting
    var.clearcasting = buff.clearcasting.exists() and 1 or 0

    -- Incarnation: King of the Jungle
    var.incarnation = buff.incarnationKingOfTheJungle.exists() and 1 or 0

    -- Friends In Range
    var.friendsInRange = false
    while not solo and not var.friendsInRange do
        for i = 1, #br.friend do
            if unit.distance(br.friend[i].unit) < 15 then
                var.friendsInRange = true
            end
        end
    end

    var.fbMaxEnergy = energy >= 50

    -- Opener Reset
    if (not unit.inCombat() and not GetObjectExists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false
        opener.TF1 = false
        opener.RK1 = false
        opener.MF1 = false
        opener.RIP1 = false
        opener.complete = false
    end

    -- Variables
    -- variable,name=use_thrash,value=0
    -- variable,name=use_thrash,value=2,if=azerite.wild_fleshrending.enabled
    useThrash = traits.wildFleshrending.active and 2 or 0
    -- variable,name=reaping_delay,value=target.time_to_die,if=variable.reaping_delay=0
    if var.reapingDelay == 0 then var.reapingDelay = unit.ttd(units.dyn5) end
    -- cycling_variable,name=reaping_delay,op=min,value=target.time_to_die
    local lowestTTD = 999
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if unit.ttd(thisUnit) < lowestTTD then
            lowestTTD = unit.ttd(thisUnit)
        end
    end
    var.reapingDelay = lowestTTD
    -- variable,name=filler,value=0,if=azerite.wild_fleshrending.enabled
    if traits.wildFleshrending.active then
        filler = 0
    else
        if filler ~= 1 then
            for i = 1, #enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if debuff.rake.applied(thisUnit) <= debuff.rake.calc() then
                    filler = 1
                    break
                end
            end
        end
        if filler ~= 2 and not debuff.rake.exists(units.dyn5) then filler = 2 end
        if filler ~= 3 and talent.lunarInspiration and not debuff.moonfireFeral.exists(units.dyn40) then filler = 3 end
        if filler ~= 4 and #enemies.yards8 > 1 then filler = 4 end
    end
    -- variable,name=thrash_ticks,value=0,if=azerite.wild_fleshrending.enabled
    if traits.wildFleshrending.active then
        thrashTicks = 0
    end
    -- variable,name=best_rip,value=0,if=talent.primal_wrath.enabled
    bestRip = talent.primalWrath and 1 or 0
    -- cycling_variable,name=best_rip,op=max,value=druid.rip.ticks_gained_on_refresh,if=talent.primal_wrath.enabled
    if talent.primalWrath then
        local ripTicksGain = 0
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if not debuff.rip.exists(thisUnit) then ripTicksGain = ripTicksGain + 12 end
            if debuff.rip.exists(thisUnit) then ripTicksGain = ripTicksGain + (12 - math.floor(debuff.rip.remain(thisUnit) / 2)) end
        end
        bestRip = ripTicksGain
    end

    -- Bloodtalons - Reset
    if btGen.timer - GetTime() <= 0 or buff.bloodtalons.exists() then
        if btGen.brutalSlash then btGen.brutalSlash = false end
        if btGen.moonfireFeral then btGen.moonfireFeral = false end
        if btGen.rake then btGen.rake = false end
        if btGen.shred then btGen.shred = false end
        if btGen.swipe then btGen.swipe = false end
        if btGen.thrash then btGen.thrash = false end
        -- btGen.timer = GetTime() + 4
    end
    -- if not buff.bloodtalons.exists() and btGen.timer - GetTime() > 0 then btGen.stack = 2 end
    btGen.stack = 2 - buff.bloodtalons.stack()
    btGen.triggers = 0
    if not btGen.brutalSlash and talent.brutalSlash then btGen.triggers = btGen.triggers + 1 end
    if not btGen.moonfireFeral and talent.lunarInspiration then btGen.triggers = btGen.triggers + 1 end
    if not btGen.rake then btGen.triggers = btGen.triggers + 1 end
    if not btGen.shred then btGen.triggers = btGen.triggers + 1 end
    if not btGen.swipe and not talent.brutalSlash then btGen.triggers = btGen.triggers + 1 end
    if not btGen.thrash then btGen.triggers = btGen.triggers + 1 end

    -- Thrash Ticks to Gain
    ticksGain.thrash = 0
    for i = 1, #enemies.yards8 do
        local thisUnit = enemies.yards8[i]
        if not debuff.thrashCat.exists(thisUnit) then ticksGain.thrash = ticksGain.thrash + 5 end
        if debuff.thrashCat.exists(thisUnit) then ticksGain.thrash = ticksGain.thrash + (5 - math.floor(debuff.thrashCat.remain(thisUnit) / 3)) end
    end

    -- Rip Ticks to Gain
    ticksGain.rip = 0
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if not debuff.rip.exists(thisUnit) then ticksGain.rip = ticksGain.rip + 12 end
        if debuff.rip.exists(thisUnit) then ticksGain.rip = ticksGain.rip + (12 - math.floor(debuff.rip.remain(thisUnit) / 2)) end
    end

    -- Rake Ticks to Gain
    ticksGain.rake = 0
    for i = 1, #enemies.yards5f do
        local thisUnit = enemies.yards5f[i]
        if not debuff.rake.exists(thisUnit) then ticksGain.rake = ticksGain.rake + 5 end
        if debuff.rake.exists(thisUnit) then ticksGain.rake = ticksGain.rake + (5 - math.floor(debuff.rake.remain(thisUnit) / 3)) end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or pause() or ui.mode.rotation==4 then
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
        if unit.inCombat() and cast.able.catForm("player") and not cat
            and #enemies.yards5f > 0 and not unit.moving() and ui.checked("Auto Shapeshifts")
        then
            if cast.catForm("player") then ui.debug("Casting Cat Form [Combat]"); return true end
        elseif unit.inCombat() and cat and not var.profileStop
            and not ui.checked("Death Cat Mode") and unit.exists("target") and opener.complete and cd.global.remain() == 0
        then
            -- Wild Charge
            if ui.checked("Wild Charge")
                and cast.able.wildCharge("player") and unit.valid("target")
            then
                if cast.wildCharge("target") then ui.debug("Casting Wild Charge on "..unit.name("target").." [Out of Melee]"); return true end
            end
            -- -- Rake/Shred from Stealth
            -- -- rake,if=buff.prowl.up|buff.shadowmeld.up
            -- if (buff.prowl.exists() or buff.shadowmeld.exists()) and range.dyn5 then
            --     -- if debuff.rake.exists(units.dyn5) or unit.level() < 12 then
            --     if cast.able.rake() and unit.level() >= 12 and not var.noDoT and (not debuff.rake.exists(units.dyn5)
            --         or debuff.rake.calc() > debuff.rake.applied(units.dyn5) * 0.85)
            --     then
            --         if cast.rake(units.dyn5) then --[[ui.debug("Casting Rake on "..unit.name(units.dyn5).." [Stealth Break]");]] return true end
            --     elseif cast.able.shred() and debuff.rake.exists(units.dyn5) and debuff.rake.calc() <= debuff.rake.applied(units.dyn5) * 0.85 then
            --         if cast.shred(units.dyn5) then --[[ui.debug("Casting Shred on "..unit.name(units.dyn5).." [Stealth Break]");]] return true end
            --     end
            -- elseif not (buff.prowl.exists() or buff.shadowmeld.exists()) then


            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if unit.inCombat() then
                if actionList.Interrupts() then return true end
            end
            -------------------------
            --- In Combat - Begin ---
            -------------------------
            -- Auto Attack
            -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and range.dyn5 and not (buff.prowl.exists() or buff.shadowmeld.exists()) then
                StartAttack(units.dyn5)
            end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if ui.value("APL Mode") == 1 then
                -- Ferocious Bite
                -- ferocious_bite,target_if=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>10&(talent.sabertooth.enabled)
                if cast.able.ferociousBite() and range.dyn5 then
                    for i = 1, #enemies.yards5f do
                        local thisUnit = enemies.yards5f[i]
                        if ferociousBiteFinish(thisUnit) and not usePrimalWrath() then
                            if ui.value("Ferocious Bite Execute") == 1 and ferociousBiteFinish(thisUnit) then
                                ui.print("Ferocious Bite Finished! "..unit.name(thisUnit).." with "..round2(unit.hp(thisUnit),0).."% health remaining.")
                            end
                            if cast.ferociousBite(thisUnit) then ui.debug("Casting Ferocious Bite on "..unit.name(thisUnit).." [Execute]"); return true end
                        end
                    end
                end
                -- Call Action List - Cooldowns
                -- call_action_list,name=cooldown
                if actionList.Cooldowns() then return true end
                -- Run Action List - Finisher
                -- run_action_list,name=finisher,if=combo_points>=(5-variable.4cp_bite)
                if comboPoints >= (5 - cp4Bite) then
                    if actionList.Finisher() then return true end
                else
                    -- Run Action List - Stealth
                    -- run_action_list,name=stealth,if=buff.berserk_cat.up|buff.incarnation.up|buff.shadowmeld.up|buff.sudden_ambush.up|buff.prowl.up
                    if buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists() or buff.shadowmeld.exists() or buff.suddenAmbush.exists() or buff.prowl.exists() then
                        if actionList.Stealth() then return true end
                    end
                    -- Action List - Bloodtalons
                    -- pool_resource,if=talent.bloodtalons.enabled&buff.bloodtalons.down&(energy+3.5*energy.regen+(40*buff.clearcasting.up))>=(115-23*buff.incarnation_king_of_the_jungle.up)&active_bt_triggers=0
                    if talent.bloodtalons and not buff.bloodtalons.exists() and (energy + 3.5 * energyRegen + (40 * var.clearcasting)) >= (115 - 23 * var.incarnation) and btGen.stack == 0 then
                        ui.debug("Pooling for Bloodtalons")
                        return true
                    end
                    -- run_action_list,name=bloodtalons,if=talent.bloodtalons.enabled&(buff.bloodtalons.down|active_bt_triggers=2)
                    if talent.bloodtalons and (not buff.bloodtalons.exists() or btGen.stack == 2) then
                        if actionList.Bloodtalons() then return true end
                    end
                    -- Rake
                    -- rake,target_if=refreshable|persistent_multiplier>dot.rake.pmultiplier
                    if cast.able.rake() and (debuff.rake.refresh(units.dyn5) or debuff.rake.calc() > debuff.rake.applied(units.dyn5)) then
                        if cast.rake(units.dyn5) then ui.debug("Casting Rake") return true end
                    end
                    -- Feral Frenzy
                    -- feral_frenzy,if=combo_points=0
                    if cast.able.feralFrenzy() and (comboPoints == 0) then
                        if cast.feralFrenzy() then ui.debug("Casting Feral Frenzy") return true end
                    end
                    -- Lunar Inspiration
                    -- moonfire_cat,target_if=refreshable
                    if cast.able.moonfireFeral() and talent.lunarInspiration then
                        for i = 1, #enemies.yards40 do
                            local thisUnit = enemies.yards40[i]
                            if debuff.moonfireFeral.refresh(thisUnit) then
                                if cast.moonfireFeral(thisUnit) then ui.debug("Casting Moonfire") return true end
                            end
                        end
                    end
                    -- Thrash
                    -- thrash_cat,if=refreshable&druid.thrash_cat.ticks_gained_on_refresh>variable.thrash_ticks
                    if cast.able.thrashCat() and (debuff.thrashCat.refresh(units.dyn8AoE) and ticksGain.thrash > thrashTicks) then
                        if cast.thrashCat() then ui.debug("Casting Thrash") return true end
                    end
                    -- Brutal Slash
                    -- brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))&(spell_targets.brutal_slash*action.brutal_slash.damage%action.brutal_slash.cost)>(action.shred.damage%action.shred.cost)
                    if cast.able.brutalSlash() and (buff.tigersFury.exists() and charges.brutalSlash.timeTillFull() < unit.gcd(true))
                        and (#enemies.yards8 < ui.value("Brutal Slash Targets") or (ui.mode.rotation == 3 and #enemies.yards8 > 0))
                        and range.dyn8AOE 
                    then
                        if cast.brutalSlash() then ui.debug("Casting Brutal Slash") return true end
                    end
                    -- Swipe
                    -- swipe_cat,if=spell_targets.swipe_cat>2
                    if cast.able.swipeCat() and (#enemies.yards8 > 2) then
                        if cast.swipeCat() then ui.debug("Casting Swipe") return true end
                    end
                    -- Shred
                    -- shred,if=buff.clearcasting.up
                    if cast.able.shred() and buff.clearcasting.exists() then
                        if cast.shred() then ui.debug("Casting Shred") return true end
                    end
                    -- Call Action List - Filler
                    -- call_action_list,name=filler,if=energy.time_to_max<1
                    if ttm < 1 then
                        if actionList.Filler() then return true end
                    end
                end -- End Combo Point Check for Finisher
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 103
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

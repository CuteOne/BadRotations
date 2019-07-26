local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
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
            br.ui:createCheckbox(section,"Displacer Beast / Wild Charge","|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
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
            br.ui:createDropdownWithout(section,"Potion", {"Superior Battle Potion of Agility","Battle Potion of Agility","Potion of Prolonged Power","None"}, 1, "|cffFFFFFFSet Potion to use.")
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
            br.ui:createDropdownWithout(section,"Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Specter of Betrayal.")
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
local debug
local enemies
local energy, energyRegen, energyDeficit
local equiped
local flying, swimming, moving
local gcd
local gcdMax
local has
local healPot
local inCombat
local inRaid
local inInstance
local item
local level
local lootDelay
local lowestHP
local mode
local multidot
local opener
local php
local pullTimer
local race
local solo
local spell
local stealth
local talent
local thp
local traits
local travel, flight, cat
local ttd
local ttm
local units
local use

-- General Locals
local fbMaxEnergy
local focusedTime = GetTime()
local friendsInRange = false
local htTimer
local lastForm
local leftCombat
local minCount
local profileStop
local range
local ripDuration = 24
local useThrash

-----------------
--- Functions ---
-----------------
local function autoProwl()
    if not inCombat and not buff.prowl.exists() then
        if #enemies.yards20nc > 0 then
            for i = 1, #enemies.yards20nc do
                local thisUnit = enemies.yards20nc[i]
                local react = GetUnitReaction(thisUnit,"player") or 10
                if react < 4 and UnitIsEnemy("player",thisUnit) and UnitCanAttack("player",thisUnit) then
                    return true
                end
            end
        end
    end
    return false
end
-- Multi-Dot HP Limit Set
local function canDoT(unit)
    local unitHealthMax = UnitHealthMax(unit)
    if not isBoss(unit) then return ((unitHealthMax > UnitHealthMax("player") * 3)
        or (UnitHealth(unit) < unitHealthMax and getTTD(unit) > 10)) end
    local maxHealth = 0
    for i = 1, #enemies.yards5f do
        local thisMaxHealth = UnitHealthMax(enemies.yards5f[i])
        if thisMaxHealth > maxHealth then
            maxHealth = thisMaxHealth
        end
    end
    return unitHealthMax > maxHealth / 10
end
-- TF Predator Snipe
local function snipeTF()
    if getOptionValue("Snipe Tiger's Fury") == 1 and talent.predator and not cd.tigersFury.exists()
        and (#enemies.yards40 == 1 and ttd(units.dyn40) > ttm) or #enemies.yards40 > 1
    then
        local lowestUnit = units.dyn5
        lowestHP = 100
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            local thisHP = getHP(thisUnit)
            if thisHP < lowestHP then
                lowestHP = thisHP
                lowestUnit = thisUnit
            end
        end
        local timeTillDeath = 99
        local longestBleed = math.max(debuff.rake.remain(lowestUnit), debuff.rip.remain(lowestUnit),
            debuff.thrashCat.remain(lowestUnit), debuff.feralFrenzy.remain(lowestUnit))
        if ttd(lowestUnit) > 0 then timeTillDeath = ttd(lowestUnit) end
        if lowestUnit ~= nil and timeTillDeath < longestBleed then return true end
    end
    return false
end
-- Ferocious Bite Finish
local function ferociousBiteFinish(thisUnit)
    local desc = GetSpellDescription(spell.ferociousBite)
    local damage = 0
    local finishHim = false
    if getOptionValue("Ferocious Bite Execute") ~= 3 and comboPoints > 0 and not isDummy(thisUnit) then
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
        finishHim = tonumber(damage) >= UnitHealth(thisUnit)
    end
    return finishHim
end
-- Primal Wrath Usable
local function usePrimalWrath()
    if talent.primalWrath and cast.able.primalWrath(nil,"aoe",1,8) and cast.safe.primalWrath("player",8,1)
        and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
        and not isExplosive("target")
    then
        if getOptionValue("Primal Wrath Usage") == 1 and #enemies.yards8 >= 3 then return true end
        local ripCount = 0
        for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if debuff.rip.remain(thisUnit) <= 4 and (ttd(thisUnit) > 8 or isDummy(thisUnit)) then
                ripCount = ripCount + 1
            end
        end
        return ripCount > 1
    end
    return false
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Shapeshift Form Management
    if isChecked("Auto Shapeshifts") then --and br.timer:useTimer("debugShapeshift", 0.25) then
        -- Flight Form
        if cast.able.travelForm("player") and not inCombat and canFly() and not swimming and br.fallDist > 90
            --[[falling > getOptionValue("Fall Timer")]] and level>=58 and not buff.prowl.exists()
        then
            if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then RunMacroText("/CancelForm") end
            if cast.travelForm("player") then debug("Casting Travel Form [Flying]") return true end
        end
        -- Aquatic Form
        if cast.able.travelForm("player") and (not inCombat --[[or getDistance("target") >= 10--]])
            and swimming and not travel and not buff.prowl.exists() and moving
        then
            if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then RunMacroText("/CancelForm") end
            if cast.travelForm("player") then debug("Casting Travel From [Swimming]") return true end
        end
        -- Cat Form
        if cast.able.catForm() and not cat and not IsMounted() and not flying then
            -- Cat Form when not swimming or flying or stag and not in combat
            if moving and not swimming and not flying and not travel then
                if cast.catForm("player") then debug("Casting Cat Form [No Swim / Travel / Combat]") return true end
            end
            -- Cat Form when not in combat and target selected and within 20yrds
            if not inCombat and isValidUnit("target") and ((getDistance("target") < 30 and not swimming)
                or (getDistance("target") < 10 and swimming))
            then
                if cast.catForm("player") then debug("Casting Cat Form [Target In 20yrds]") return true end
            end
            -- Cat Form - Less Fall Damage
            if (not canFly() or inCombat or level < 58 or not IsOutdoors())
                and (not swimming or (not moving and swimming and #enemies.yards5f > 0))
                and br.fallDist > 90 --falling > getOptionValue("Fall Timer")
            then
                if cast.catForm("player") then debug("Casting Cat Form [Reduce Fall Damage]") return true end
            end
        end
    end -- End Shapeshift Form Management
    -- Perma Fire Cat
    if isChecked("Perma Fire Cat") and (use.able.fandralsSeedPouch() or use.able.burningSeeds())
        and not inCombat and not buff.prowl.exists() and cat
    then
        if not buff.burningEssence.exists() then
            -- Fandral's Seed Pouch
            if use.able.fandralsSeedPouch() and equiped.fandralsSeedPouch() then
                if use.fandralsSeedPouch() then debug("Using Fandrel's Seed Pouch") return true end
            -- Burning Seeds
            elseif use.able.burningSeeds() then
                if use.burningSeeds() then debug("Using Burning Seeds") return true end
            end
        end
    end -- End Perma Fire Cat
    -- Death Cat mode
    if isChecked("Death Cat Mode") and cat then
        if UnitExists("target") and getDistance(units.dyn8AOE) > 8 then
            ClearTarget()
        end
        if autoProwl() then
            -- Tiger's Fury - Low Energy
            if cast.able.tigersFury() and energyDeficit > 60 then
                if cast.tigersFury() then debug("Casting Tiger's Fury [Death Cat Mode]") return true end
            end
            -- Savage Roar - Use Combo Points
            if cast.able.savageRoar() and comboPoints >= 5 then
                if cast.savageRoar() then debug("Casting Savage Roar [Death Cat Mode]") return true end
            end
            -- Shred - Single
            if cast.able.shred() and #enemies.yards5f == 1 then
                if cast.shred() then debug("Casting Shred [Death Cat Mode]"); swipeSoon = nil; return true end
            end
            -- Swipe - AoE
            if cast.able.swipeCat() and #enemies.yards8 > 1 then
                if swipeSoon == nil then
                    swipeSoon = GetTime();
                end
                if swipeSoon ~= nil and swipeSoon < GetTime() - 1 then
                    if cast.swipeCat(nil,"aoe") then debug("Casting Swipe [Death Cat Mode]") ; swipeSoon = nil; return true end
                end
            end
        end -- End 20yrd Enemy Scan
    end -- End Death Cat Mode
    -- Dummy Test
    if isChecked("DPS Testing") then
        if GetObjectExists("target") then
            if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                profileStop = true
            end
        end
    end -- End Dummy Test
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() and not IsMounted() and not stealth and not flight and not buff.prowl.exists() then
        local opValue
        local thisUnit
        -- Rebirth
        if isChecked("Rebirth") and inCombat then
            opValue = getOptionValue("Rebirth - Target")
            if opValue == 1 then
                thisUnit = "target"
            elseif opValue == 2 then
                thisUnit = "mouseover"
            end
            if cast.able.rebirth(thisUnit,"dead") and UnitIsDeadOrGhost(thisUnit) 
                and (GetUnitIsFriend(thisUnit,"player") or UnitIsPlayer(thisUnit))
            then
                if cast.rebirth(thisUnit,"dead") then debug("Casting Rebirth on "..UnitName(thisUnit)) return true end
            end
        end
        -- Revive
        if isChecked("Revive") and not inCombat then
            opValue = getOptionValue("Revive - Target")
            if opValue == 1 then
                thisUnit = "target"
            elseif opValue == 2 then
                thisUnit = "mouseover"
            end
            if cast.able.revive(thisUnit,"dead") and UnitIsDeadOrGhost(thisUnit)
                and (GetUnitIsFriend(thisUnit,"player") or UnitIsPlayer(thisUnit))
            then
                if cast.revive(thisUnit,"dead") then debug("Casting Revive on "..UnitName(thisUnit)) return true end
            end
        end
        -- Remove Corruption
        if isChecked("Remove Corruption") then
            opValue = getOptionValue("Remove Corruption - Target")
            if opValue == 1 then
                thisUnit = "player"
            elseif opValue == 2 then
                thisUnit = "target"
            elseif opValue == 3 then
                thisUnit = "mouseover"
            end
            if cast.able.removeCorruption() and (GetUnitIsFriend(thisUnit) or UnitIsPlayer(thisUnit))
                and canDispel(thisUnit,spell.removeCorruption)
            then
                Print("Removing Corruption")
                if cast.removeCorruption(thisUnit) then debug("Casting Remove Corruption on "..UnitName(thisUnit)) return true end
            end
        end
        -- Soothe
        if isChecked("Soothe") and cast.able.soothe() then
            for i=1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if canDispel(thisUnit, spell.soothe) then
                    if cast.soothe(thisUnit) then debug("Casting Soothe on "..UnitName(thisUnit)) return true end
                end
            end
        end
        -- Renewal
        if isChecked("Renewal") and inCombat and cast.able.renewal() and php <= getOptionValue("Renewal") then
            if cast.renewal() then debug("Casting Renewal") return true end
        end
        -- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
        if isChecked("Break Crowd Control") and cast.able.catForm() then
            if not hasNoControl() and lastForm ~= 0 then
                CastShapeshiftForm(lastForm)
                if GetShapeshiftForm() == lastForm then
                    lastForm = 0
                end
            elseif hasNoControl() then
                if GetShapeshiftForm() == 0 then
                    cast.catForm("player")
                    debug("Casting Cat Form [Breaking CC]") 
                else
                    for i=1, GetNumShapeshiftForms() do
                        if i == GetShapeshiftForm() then
                            lastForm = i
                            CastShapeshiftForm(i)
                            debug("Casting Last Form [Breaking CC]") 
                            return true
                        end
                    end
                end
            end
        end
        -- Pot/Stoned
        if isChecked("Pot/Stoned") and inCombat and (use.able.healthstone() or canUseItem(healPot))
            and (hasHealthPot() or has.healthstone()) and php <= getOptionValue("Pot/Stoned")
        then
            if use.able.healthstone() then
                if use.healthstone() then debug("Using Healthstone") return true end
            elseif canUseItem(healPot) then
                useItem(healPot)
                debug("Using Health Potion") 
            end
        end
        -- Heirloom Neck
        if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then debug("Using Heirloom Neck") return true end
            end
        end
        if talent.restorationAffinity and not (IsMounted() or IsFlying())
            and (getOptionValue("Auto Heal") ~= 1 or (getOptionValue("Auto Heal") == 1
            and getDistance(br.friend[1].unit) < 40)) 
        then
            local thisHP = php
            local thisUnit = "player"
            local lowestUnit = getLowestUnit(40)
            local fhp = getHP(lowestUnit)
            if getOptionValue("Auto Heal") == 1 then thisHP = fhp; thisUnit = lowestUnit end
            -- Swiftmend
            local swiftPercent = getOptionValue("Swiftmend")
            if isChecked("Swiftmend") and cast.able.swiftmend() 
                and ((not inCombbat and thisHP <= swiftPercent) or (inCombat and thisHP <= swiftPercent/2)) 
            then
                if cast.swiftmend(thisUnit) then debug("Casting Swiftmend on "..UnitName(thisUnit)) return true end
            end
            -- Rejuvenation
            local rejuvPercent = getOptionValue("Rejuvenation")
            if isChecked("Rejuvenation") and cast.able.rejuvenation() and buff.rejuvenation.refresh(thisUnit) 
                and ((not inCombbat and thisHP <= rejuvPercent) or (inCombat and thisHP <= rejuvPercent/2)) 
            then
                if cast.rejuvenation(thisUnit) then debug("Casting Rejuvenation on "..UnitName(thisUnit)) return true end
            end
            -- Wild Growth
            if isChecked("Wild Growth") and not inCombat and cast.able.wildGrowth() then
                for i = 1, #br.friend do 
                    local thisUnit = br.friend[i].unit
                    local thisHP = getHP(thisUnit)
                    local lowHealthCandidates = getUnitsToHealAround(thisUnit, 30, getOptionValue("Wild Growth"), #br.friend)
                    if #lowHealthCandidates > 1 and not moving then
						if cast.wildGrowth(br.friend[i].unit) then debug("Casting Wild Growth on "..UnitName(thisUnit)) return true end
					end
                end
            end
        end
        -- Regrowth
        if isChecked("Regrowth") and cast.able.regrowth() and not (IsMounted() or IsFlying())
            and (getOptionValue("Auto Heal") ~= 1 or (getOptionValue("Auto Heal") == 1
            and getDistance(br.friend[1].unit) < 40))
        then
            local thisHP = php
            local thisUnit = "player"
            local lowestUnit = getLowestUnit(40)
            local fhp = getHP(lowestUnit)
            if getOptionValue("Auto Heal") == 1 then thisHP = fhp; thisUnit = lowestUnit end
            if not inCombat then
                -- Don't Break Form
                if getOptionValue("Regrowth - OoC") == 2 then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= getOptionValue("Regrowth") and not moving)
                        and (GetShapeshiftForm() == 0 or buff.predatorySwiftness.exists())
                    then
                        if cast.regrowth(thisUnit) then debug("Casting Regrowth [OoC No Break] on "..UnitName(thisUnit)) return true end
                    end
                end
                -- Break Form
                if getOptionValue("Regrowth - OoC") == 1 and php <= getOptionValue("Regrowth") and not moving then
                    if GetShapeshiftForm() ~= 0 and not buff.predatorySwiftness.exists() then
                        -- CancelShapeshiftForm()
                        RunMacroText("/CancelForm")
                    else
                       if cast.regrowth("player") then debug("Casting Regrowth [OoC Break] on "..UnitName(thisUnit)) return true end
                    end
                end
            elseif inCombat and buff.predatorySwiftness.exists() then
                -- Always Use Predatory Swiftness when available
                if getOptionValue("Regrowth - InC") == 1 or not talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if thisHP <= getOptionValue("Regrowth") then
                        if cast.regrowth(thisUnit) then debug("Casting Rebirth [IC Instant] on "..UnitName(thisUnit)) return true end
                    end
                end
                -- Hold Predatory Swiftness for Bloodtalons unless Health is Below Half of Threshold or Predatory Swiftness is about to Expire.
                if getOptionValue("Regrowth - InC") == 2 and talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= getOptionValue("Regrowth") / 2) or buff.predatorySwiftness.remain() < gcdMax * 2 then
                        if cast.regrowth(thisUnit) then debug("Casting Rebirth [IC BT Hold] on "..UnitName(thisUnit)) return true end
                    end
                end
            end
        end
        -- Survival Instincts
        if isChecked("Survival Instincts") and inCombat and cast.able.survivalInstincts()
            and php <= getOptionValue("Survival Instincts")
            and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0
        then
            if cast.survivalInstincts() then debug("Casting Survival Instincts") return true end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() then
        local thisUnit
        -- Skull Bash
        if isChecked("Skull Bash") and cast.able.skullBash() then
            for i=1, #enemies.yards13f do
                thisUnit = enemies.yards13f[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.skullBash(thisUnit) then debug("Casting Skull Bash on "..UnitName(thisUnit)) return true end
                end
            end
        end
        -- Mighty Bash
        if isChecked("Mighty Bash") and cast.able.mightyBash() then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                    if cast.mightyBash(thisUnit) then debug("Casting Mighty Bash on "..UnitName(thisUnit)) return true end
                end
            end
        end
        -- Maim
        if isChecked("Maim") and cast.able.maim() then
            for i=1, #enemies.yards5f do
                thisUnit = enemies.yards5f[i]
                if canInterrupt(thisUnit,getOptionValue("Interrupt At"))
                    and comboPoints > 0 and not buff.fieryRedMaimers.exists()
                then
                    if cast.maim(thisUnit) then debug("Casting Maim on "..UnitName(thisUnit)) return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupts

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if getDistance(units.dyn5) < 5 then
        -- Berserk
        -- berserk,if=energy>=30&(cooldown.tigers_fury.remains>5|buff.tigers_fury.up)
        if isChecked("Berserk/Incarnation") and cast.able.berserk()
            and useCDs() and not talent.incarnationKingOfTheJungle
        then
            if cast.able.berserk() and (energy >= 30 and (cd.tigersFury.remain() > 5 or buff.tigersFury.exists())) then
                if cast.berserk() then debug("Casting Berserk") return true end
            end
        end
        -- Tiger's Fury
        -- tigers_fury,if=energy.deficit>=60
        if isChecked("Tiger's Fury") and cast.able.tigersFury() then
            if cast.able.tigersFury() and (energyDeficit >= 60 or snipeTF()) then
                if cast.tigersFury() then debug("Casting Tiger's Fury") return true end
            end
        end
        -- Racial: Berserking (Troll)
        -- berserking
        if isChecked("Racial") and cast.able.racial() and useCDs() and race == "Troll" then
            if cast.racial() then debug("Casting "..GetSpellInfo(spell.racial)) return true end
        end
        if isChecked("Use Essence") then
            -- Essence: The Unbound Force
            -- the_unbound_force,if=buff.reckless_force.up|buff.tigers_fury.up
            if cast.able.theUnboundForce()
                and (buff.recklessForce.exists() or buff.tigersFury.exists())
            then
                if cast.theUnboundForce() then debug("Casting The Unbound Force") return true end
            end
            -- Essence: Memory of Lucid Dreams
            -- memory_of_lucid_dreams,if=buff.tigers_fury.up&buff.berserk.down
            if useCDs() and cast.able.memoryOfLucidDreams() and buff.tigersFury.exists()
                and not (buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists())
            then
                if cast.memoryOfLucidDreams() then debug("Casting Memory of Lucid Dreams") return true end
            end
            -- Essence: Blood of the Enemy
            -- blood_of_the_enemy,if=buff.tigers_fury.up
            if useCDs() and cast.able.bloodOfTheEnemy() and buff.tigersFury.exists() then
                if cast.bloodOfTheEnemy() then debug("Casting Blood of the Enemy") return true end
            end
        end
        -- Feral Frenzy
        -- feral_frenzy,if=combo_points=0
        if cast.able.feralFrenzy() and (comboPoints == 0) then
            if cast.feralFrenzy() then debug("Casting Feral Frenzy") return true end
        end
        if isChecked("Use Essence") then
            -- Essence: Focused Azerite Beam
            -- focused_azerite_beam,if=active_enemies>desired_targets|(raid_event.adds.in>90&energy.deficit>=50)
            if cast.able.focusedAzeriteBeam() and (#enemies.yards8f >= 3 or (useCDs() and energyDeficit >= 50
                    and debuff.rake.remain(units.dyn5) > 5 and debuff.rip.remain(units.dyn5) > 5))
                and not (buff.tigersFury.exists() or buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists())                
            then
                if cast.focusedAzeriteBeam(nil,"cone",minCount, 180) then
                    debug("Casting Focused Azerite Beam") 
                    return true 
                end
            end
            -- Essence: Purifying Blast
            -- purifying_blast,if=active_enemies>desired_targets|raid_event.adds.in>60
            if cast.able.purifyingBlast() and (#enemies.yards8t >= 3 or useCDs()) then
                if cast.purifyingBlast("best", nil, minCount, 8) then debug("Casting Purifying Blast") return true end
            end
            -- Essence: Heart Essence
            -- heart_essence,if=buff.tigers_fury.up
            if buff.tigersFury.exists() then
                -- Essence: Concentrated Flame
                if cast.able.concentratedFlame() then
                    if cast.concentratedFlame() then debug("Casting Concentrated Flame") return true end
                end
                -- Essence: Guardian of Azeroth
                if useCDs() and cast.able.guardianOfAzeroth() then
                    if cast.guardianOfAzeroth() then debug("Casting Guardian of Azeroth") return end
                end
                -- Essence: Worldvein Resonance
                if cast.able.worldveinResonance() then
                    if cast.worldveinResonance() then debug("Casting Worldvein Resonance") return end
                end
            end
        end
        -- Incarnation - King of the Jungle
        -- incarnation,if=energy>=30&(cooldown.tigers_fury.remains>15|buff.tigers_fury.up)
        if isChecked("Berserk/Incarnation") and cast.able.incarnationKingOfTheJungle()
            and useCDs() and talent.incarnationKingOfTheJungle
        then
            if (energy >= 30 and (cd.tigersFury.remain() > 15 or buff.tigersFury.exists())) then
                if cast.incarnationKingOfTheJungle() then debug("Casting Incarnation: King of the Jungle") return true end
            end
        end
        -- Potion
        -- potion,if=target.time_to_die<65|(time_to_die<180&(buff.berserk.up|buff.incarnation.up))
        if getOptionValue("Potion") ~= 4 and (inRaid or inInstance) and isBoss("target") then
            if (ttd(units.dyn5) > 45 and (buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists())) then
                if getOptionValue("Potion") == 1 and use.able.superiorBattlePotionOfAgility() then
                    use.superiorBattlePotionOfAgility()
                    debug("Using Superior Battle Potion of Agility [Pre-pull]");
                elseif getOptionValue("Potion") == 2 and use.able.battlePotionOfAgility() then
                    use.battlePotionOfAgility()
                    debug("Using Battle Potion of Agility [Pre-pull]");
                elseif getOptionValue("Potion") == 3 and use.able.potionOfProlongedPower() then
                    use.potionOfProlongedPower()
                    debug("Using Potion of Prolonged Power [Pre-pull]");
                end
            end
        end
        -- Shadowmeld
        -- shadowmeld,if=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<2.1&buff.tigers_fury.up&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
        if isChecked("Racial") and cast.able.shadowmeld() and useCDs() and race == "NightElf"
            and getDistance(units.dyn5) < 5 and not solo and friendsInRange --findFriends() > 0
        then
            if (comboPoints < 5 and energy >= cast.cost.rake() and debuff.rake.applied(units.dyn5) < 2.1
                and buff.tigersFury.exists() and (buff.bloodtalons.exists() or not talent.bloodtalons)
                and (not talent.incarnationKingOfTheJungle or cd.incarnationKingOfTheJungle.remain() > 18)
                and not buff.incarnationKingOfTheJungle.exists())
            then
                if cast.shadowmeld() then debug("Casting Shadowmeld") return true end
            end
        end
        -- Trinkets
        -- if=buff.tigers_fury.up&energy.time_to_max>3&(!talent.savage_roar.enabled|buff.savage_roar.up)
        if (use.able.slot(13) or use.able.slot(14)) and (buff.tigersFury.exists()
            or ttd(units.dyn5) <= cd.tigersFury.remain()) and (not talent.savageRoar or buff.savageRoar.exists())
        then
            local opValue = getOptionValue("Trinkets")
            if (opValue == 1 or (opValue == 2 and useCDs()))
                and getDistance(units.dyn5) < 5
            then
                for i = 13, 14 do
                    if use.able.slot(i) and (not equiped.pocketSizedComputationDevice(i) 
                        or (equiped.pocketSizedComputationDevice(i) and not equiped.socket.pocketSizedComputationDevice(167672,1))) 
                    then
                        use.slot(i)
                        debug("Using Trinket [Slot "..i.."]") 
                    end
                end
            end
        end
        if useCDs() and equiped.pocketSizedComputationDevice() and equiped.socket.pocketSizedComputationDevice(167672,1) and ttm > 3
            and not (buff.tigersFury.exists() or buff.berserk.exists() or buff.incarnationKingOfTheJungle.exists() or buff.memoryOfLucidDreams.exists())
            and (debuff.rake.remain(units.dyn5) > 3 and debuff.rip.remain(units.dyn5) > 3)
        then
            for i = 13, 14 do
                if use.able.slot(i) and equiped.pocketSizedComputationDevice(i) then
                    use.slot(i)
                    debug("Using Pocket Sized Computation Device [Slot "..i.."]") 
                end
            end
        end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        -- blood_fury,buff.tigers_fury | arcane_torrent,buff.tigers_fury
        if isChecked("Racial") and cast.able.racial() and useCDs()
            and (race == "Orc" or race == "BloodElf")
        then
            if buff.tigersFury.exists() then
                if cast.racial("player") then debug("Casting "..GetSpellInfo(spell.racial)) return true end
            end
        end
    end -- End useCooldowns check
end -- End Action List - Cooldowns

-- Action List - Opener
actionList.Opener = function()
    -- Wild Charge
    if isChecked("Wild Charge") and cast.able.wildCharge("target") and isValidUnit("target")
        and getDistance("target") >= 8 and getDistance("target") < 30
    then
        if cast.wildCharge("target") then debug("Casting Wild Charge on "..UnitName("target").." [Opener]") return true end
    end
    -- Start Attack
    -- auto_attack
    if isChecked("Opener") and isBoss("target") and not opener.complete then
        if isValidUnit("target") and getDistance("target") < 5
            and getFacing("player","target") and getSpellCD(61304) == 0
        then
            -- Begin
            if not opener.OPN1 then
                Print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
            -- Tiger's Fury
            -- tigers_fury
            elseif opener.OPN1 and not opener.TF1 then
                if cd.tigersFury.remain() > gcd then
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
            elseif opener.RIP1 then
                Print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Finisher
actionList.Finisher = function()
    -- Savage Roar
    -- pool_resource,for_next=1
    -- savage_roar,if=buff.savage_roar.down
    if (cast.pool.savageRoar() or cast.able.savageRoar()) and not buff.savageRoar.exists() then
        if cast.pool.savageRoar() then ChatOverlay("Pooling For Savage Roar") return true end
        if cast.able.savageRoar() then
            if cast.savageRoar("player") then debug("Casting Savage Roar [No Buff]") return true end
        end
    end
    -- Primal Wrath
    -- pool_resource,for_next=1
    -- primal_wrath,target_if=spell_targets.primal_wrath>1&dot.rip.remains<4
    -- pool_resource,for_next=1
    -- primal_wrath,target_if=spell_targets.primal_wrath>=2
    if usePrimalWrath() and range.dyn8AOE then
        if cast.primalWrath(nil,"aoe",1,8) then debug("Casting Primal Wrath") return true end
    end
    -- Rip
    -- pool_resource,for_next=1
    -- rip,target_if=!ticking|(remains<=duration*0.3)&(!talent.sabertooth.enabled)|(remains<=duration*0.8&persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die>8
    if (cast.pool.rip() or cast.able.rip()) and not usePrimalWrath() and range.dyn5
        and (buff.savageRoar.exists() or not talent.savageRoar)
    then
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot))
                and not UnitIsCharmed(thisUnit) and canDoT(thisUnit) and getFacing("player",thisUnit)
            then
                if (not debuff.rip.exists(thisUnit) or (debuff.rip.refresh(thisUnit) and not talent.sabertooth)
                    or (debuff.rip.remain(thisUnit) <= ripDuration * 0.8 and debuff.rip.calc() > debuff.rip.applied(thisUnit)))
                    and (ttd(thisUnit) > 8 or isDummy(thisUnit))
                then
                    if cast.pool.rip() then ChatOverlay("Pooling For Rip") return true end
                    if cast.able.rip(thisUnit) then
                        if cast.rip(thisUnit) then debug("Casting Rip") return true end
                    end
                end
            end
        end
    end
    -- Savage Roar
    -- pool_resource,for_next=1
    -- savage_roar,if=buff.savage_roar.remains<12
    if (cast.pool.savageRoar() or cast.able.savageRoar()) and buff.savageRoar.remain() < 12 then
        if cast.pool.savageRoar() then ChatOverlay("Pooling For Savage Roar") return true end
        if cast.able.savageRoar() then
            if cast.savageRoar("player") then debug("Casting Savage Roar [Less Than 12s]") return true end
        end
    end
    -- Maim
    -- pool_resource,for_next=1
    -- maim,if=buff.iron_jaws.up
    if (cast.pool.maim() or cast.able.maim()) and (buff.ironJaws.exists()) and range.dyn5 then
        if cast.pool.maim() then ChatOverlay("Pooling For Maim") return true end
        if cast.able.maim() then
            if cast.maim() then debug("Casting Maim") return true end
        end
    end
    -- Ferocious Bite
    -- ferocious_bite,max_energy=1
    if cast.able.ferociousBite() and fbMaxEnergy and not usePrimalWrath() and range.dyn5
        and (buff.savageRoar.remain() >= 12 or not talent.savageRoar)
        and (not debuff.rip.refresh(units.dyn5) or thp(units.dyn5) <= 25
            or ferociousBiteFinish(units.dyn5) or level < 20 or ttd(units.dyn5) <= 8
            or UnitIsCharmed(units.dyn5) or not canDoT(units.dyn5) or isDummy(units.dyn5))
    then
        if getOptionValue("Ferocious Bite Execute") == 1 and ferociousBiteFinish(units.dyn5) then
            --Print("Ferocious Bite Finished! "..UnitName(units.dyn5).." with "..round2(thp(units.dyn5),0).."% health remaining.")
        end
        if cast.ferociousBite() then debug("Casting Ferocious Bite") return true end
    end
end -- End Action List - Finisher

-- Action List - Generator
actionList.Generator = function()
    -- Regrowth
    -- regrowth,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.down&combo_points=4&dot.rake.remains<4
    -- regrowth,if=talent.bloodtalons.enabled&buff.bloodtalons.down&buff.predatory_swiftness.up&talent.lunar_inspiration.enabled&dot.rake.remains<1
    if cast.able.regrowth() and talent.bloodtalons
        and not buff.bloodtalons.exists() and buff.predatorySwiftness.exists()
    then
        if (comboPoints == 4 and debuff.rake.remain(units.dyn5) < 4)
            or (talent.lunarInspiration and debuff.rake.remain(units.dyn5) < 1)
        then
            local opValue = getOptionValue("Auto Heal")
            local thisUnit = br.friend[1].unit
            if opvalue == 1 and getDistance(thisUnit) < 40 then
                if cast.regrowth(thisUnit) then debug("Casting Regrowth on "..UnitName(thisUnit).." [BT]") return true end
            elseif opValue == 2 then
                if cast.regrowth("player") then debug("Casting Regrowth [BT < 5cp]") return true end
            end
        end
    end
    -- Brutal Slash
    -- brutal_slash,if=spell_targets.brutal_slash>desired_targets
    if cast.able.brutalSlash() and talent.brutalSlash and not isExplosive("target") and not buff.bloodtalons.exists()
        and (useThrash ~= 2 or debuff.thrashCat.exists(units.dyn8AOE)) and mode.rotation < 3
        and ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Brutal Slash Targets"))
            or (mode.rotation == 2 and #enemies.yards8 > 0))
        and range.dyn8AOE
    then
        if cast.brutalSlash("player","aoe",1,8) then debug("Casting Brutal Slash [AOE]") return true end
    end
    -- Thrash
    -- pool_resource,for_next=1
    -- thrash_cat,if=(refreshable)&(spell_targets.thrash_cat>2)
    if (cast.pool.thrashCat() or cast.able.thrashCat()) and not isExplosive("target") 
        and ttd(units.dyn8AOE) > 4 and range.dyn8AOE 
    then
        if (not debuff.thrashCat.exists(units.dyn8AOE) or debuff.thrashCat.refresh(units.dyn8AOE))
            and ((mode.rotation == 1 and #enemies.yards8 > 2) or (mode.rotation == 2 and #enemies.yards8 > 0))
        then
            if cast.pool.thrashCat() then ChatOverlay("Pooling For Thrash: "..#enemies.yards8.." targets") return true end
            if cast.able.thrashCat() then
                if cast.thrashCat("player","aoe",1,8) then debug("Casting Thrash [AOE]") return true end
            end
        end
    end
    -- pool_resource,for_next=1
    -- thrash_cat,if=(talent.scent_of_blood.enabled&buff.scent_of_blood.down)&spell_targets.thrash_cat>3
    if (cast.pool.thrashCat() or cast.able.thrashCat()) and not isExplosive("target") 
        and (talent.scentOfBlood and not buff.scentOfBlood.exists()
        and ((mode.rotation == 1 and #enemies.yards8 > 3) or (mode.rotation == 2 and #enemies.yards8 > 0)))
        and ttd(units.dyn8AOE) > 4 and range.dyn8AOE
    then
        if cast.pool.thrashCat() then ChatOverlay("Pooling For Thrash: Scent of Blood") return true end
        if cast.able.thrashCat() then
            if cast.thrashCat("player","aoe",1,8) then debug("Casting Thrash [Scent of Blood]") return true end
        end
    end
    -- Swipe
    -- pool_resource,for_next=1
    -- swipe_cat,if=buff.scent_of_blood.up
    if (cast.pool.swipeCat() or cast.able.swipeCat()) and not talent.brutalSlash 
        and not isExplosive("target") and buff.scentOfBlood.exists() and range.dyn8AOE
    then
        if cast.pool.swipeCat() then ChatOverlay("Pooling For Swipe - Scent of Blood") return true end
        if cast.able.swipeCat() then
            if cast.swipeCat("player","aoe",1,8) then debug("Casting Swipe [Scent of Blood]") return true end
        end
    end
    -- Rake
    -- pool_resource,for_next=1
    -- rake,target_if=!ticking|(!talent.bloodtalons.enabled&remains<duration*0.3)&target.time_to_die>4
    -- rake,target_if=talent.bloodtalons.enabled&buff.bloodtalons.up&((remains<=7)&persistent_multiplier>dot.rake.pmultiplier*0.85)&target.time_to_die>4
    if (cast.pool.rake() or cast.able.rake()) and (debuff.rake.count() < getOptionValue("Multi-DoT Limit")
        and (#enemies.yards5f < getOptionValue("Multi-DoT Limit") 
            or not traits.wildFleshrending.active or traits.bloodMist.active))
        and range.dyn5
    then
        local function rakeLogic(thisUnit)
            if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot))
                and (ttd(thisUnit) > 4 or isDummy(thisUnit)) and not UnitIsCharmed(thisUnit)
                and canDoT(thisUnit) and getFacing("player",thisUnit)
            then
                if (not debuff.rake.exists(thisUnit) or (not talent.bloodtalons and debuff.rake.refresh(thisUnit)))
                    or (talent.bloodtalons and buff.bloodtalons.exists() and debuff.rake.remain(thisUnit) <= 7
                    and debuff.rake.calc() > debuff.rake.applied(thisUnit) * 0.85)
                then
                    return true
                end
            end
            return false
        end
        if rakeLogic("target") then
            if cast.pool.rake() then ChatOverlay("Pooling For Rake") return true end
            if cast.rake("target") then debug("Casting Rake on "..UnitName("target").." [Target]") return true end
        end 
        for i = 1, #enemies.yards5f do
            local thisUnit = enemies.yards5f[i]
            if rakeLogic(thisUnit) then
                if cast.pool.rake() then ChatOverlay("Pooling For Rake") return true end
                if cast.rake(thisUnit) then debug("Casting Rake on "..UnitName(thisUnit).." [Multi-DoT]") return true end
            end 
        end
    end
    -- Moonfire
    -- moonfire_cat,if=buff.bloodtalons.up&buff.predatory_swiftness.down&combo_points<5
    if cast.able.moonfireFeral() and talent.lunarInspiration and range.dyn40
        and canDoT(units.dyn40) and (debuff.moonfireFeral.count() < getOptionValue("Multi-DoT Limit") 
        and (#enemies.yards40 < getOptionValue("Multi-DoT Limit") or not traits.wildFleshrending.active or traits.bloodMist.active))
    then
        if buff.bloodtalons.exists() and not buff.predatorySwiftness.exists() and comboPoints < 5 then
            if cast.moonfireFeral() then debug("Casting Moonfire on "..UnitName(units.dyn40).." [BT]") return true end
        end
    end
    -- Brutal Slash
    -- brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))
    if cast.able.brutalSlash() and talent.brutalSlash and not isExplosive("target") and not buff.bloodtalons.exists()
        and (useThrash ~= 2 or debuff.thrashCat.exists(units.dyn8AOE))
        and (buff.tigersFury.exists() or charges.brutalSlash.timeTillFull() < gcdMax)
        and (#enemies.yards8 < getOptionValue("Brutal Slash Targets") or (mode.rotation == 3 and #enemies.yards8 > 0))
        and range.dyn8AOE
    then
        if cast.brutalSlash("player","aoe",1,8) then debug("Casting Brutal Slash [Max Charges]") return true end
    end
    -- Moonfire
    -- moonfire_cat,target_if=refreshable
    if cast.able.moonfireFeral() and talent.lunarInspiration and range.dyn40
        and (debuff.moonfireFeral.count() < getOptionValue("Multi-DoT Limit")
        and (#enemies.yards40 < getOptionValue("Multi-DoT Limit") or not traits.wildFleshrending.active or traits.bloodMist.active))
    then
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                if canDoT(thisUnit) and debuff.moonfireFeral.refresh(thisUnit) then --or (isDummy(thisUnit) and getDistance(thisUnit) < 8) then
                    if cast.moonfireFeral(thisUnit) then debug("Casting Moonfire on "..UnitName(thisUnit).." [Multi-DoT]") return true end
                end
            end
        end
    end
    -- Thrash
    -- pool_resource,for_next=1
    -- thrash_cat,if=refreshable&((variable.use_thrash=2&(!buff.incarnation.up|azerite.wild_fleshrending.enabled))|spell_targets.thrash_cat>1)
    -- thrash_cat,if=refreshable&variable.use_thrash=1&buff.clearcasting.react&(!buff.incarnation.up|azerite.wild_fleshrending.enabled)
    if (cast.pool.thrashCat() or cast.able.thrashCat()) and not isExplosive("target") and ttd(units.dyn8AOE) > 4
        and debuff.thrashCat.refresh(units.dyn8AOE) and mode.rotation < 3 and range.dyn8AOE
    then
        if (useThrash == 2 or (useThrash == 1 and buff.clearcasting.exists())
            and ((not buff.incarnationKingOfTheJungle.exists() or traits.wildFleshrending.active)
            or (mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)))
        then
        -- if (useThrash == 2 and (not buff.incarnationKingOfTheJungle.exists() or traits.wildFleshrending.active))
        --     or ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)
        --     or (#enemies.yards8 > 0 and traits.wildFleshrending.active))
        --     or (useThrash == 1 and buff.clearcasting.exists()
        --         and (not buff.incarnationKingOfTheJungle.exists() or traits.wildFleshrending.active))
        -- then
            if cast.pool.thrashCat() and not buff.clearcasting.exists() then ChatOverlay("Pooling For Thrash") return true end
            if cast.able.thrashCat() or buff.clearcasting.exists() then
                if cast.thrashCat("player","aoe",1,8) then debug("Casting Thrash [Use Thrash Variable "..useThrash.."]") return true end
            end
        end
    end
    -- Swipe
    -- pool_resource,for_next=1
    -- swipe_cat,if=spell_targets.swipe_cat>1
    if (cast.pool.swipeCat() or cast.able.swipeCat()) and not isExplosive("target") and not talent.brutalSlash and range.dyn8AOE--and multidot
        and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
    then
        if cast.pool.swipeCat() then ChatOverlay("Pooling For Swipe") return true end
        if cast.able.swipeCat() then
            if cast.swipeCat("player","aoe",1,8) then debug("Casting Swipe [AOE]") return true end
        end
    end
    -- Shred
    -- shred,if=dot.rake.remains>(action.shred.cost+action.rake.cost-energy)%energy.regen|buff.clearcasting.react
    if cast.able.shred() and range.dyn5
        and ((mode.rotation == 1 and #enemies.yards5f == 1) or (mode.rotation == 3 and #enemies.yards5f > 0)
            or talent.brutalSlash or level < 32 or isExplosive("target"))
        and (debuff.rake.remain(units.dyn5) > ((cast.cost.shred() + cast.cost.rake() - energy) / energyRegen)
            or ttd(units.dyn5) <= 4 or not canDoT(units.dyn5) or buff.clearcasting.exists() 
            or level < 12 or isExplosive("target"))
    then
        if cast.shred() then debug("Casting Shred") return true end
    end
end -- End Action List - Generator

-- Action List - PreCombat
actionList.PreCombat = function()
    if not inCombat and not (IsFlying() or IsMounted()) then
        if not stealth then
            -- Flask / Crystal
            -- flask
            local opValue = getOptionValue("Elixir")
            if opValue == 1 and inRaid and use.able.greaterFlaskOfTheCurrents()
                and not buff.greaterFlaskOfTheCurrents.exists()
            then
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.greaterFlaskOfTheCurrents() then debug("Using Greater Flask of the Currents") return true end
            elseif opValue == 2 and use.able.repurposedFelFocuser() and not buff.felFocus.exists()
                and (not inRaid or (inRaid and not buff.greaterFlaskOfTheCurrents.exists()))
            then
                if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
                if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                if use.repurposedFelFocuser() then debug("Using Repurposed Fel Focuser") return true end
            elseif opValue == 3 and use.able.oraliusWhisperingCrystal()
                and not buff.whispersOfInsanity.exists()
            then
                if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
                if buff.felFocus.exists() then buff.felFocus.cancel() end
                if use.oraliusWhisperingCrystal() then debug("Using Oralius's Whispering Crystal") return true end
            end
            -- Lightforged/Defiled Augment Rune
            -- augmentation,type=defiled
            if isChecked("Augment Rune") and not buff.defiledAugmentation.exists()
                and (use.able.lightforgedAugmentRune() or use.able.defiledAugmentRune())
            then
                if use.able.lightforgedAugmentRune() then
                    if use.lightforgedAugmentRune() then debug("Using Lightforged Augment Rune") return true end
                end
                if use.able.defiledAugmentRune() then
                    if use.defiledAugmentRune() then debug("Using Defiled Augment Rune") return true end
                end
            end
            -- Prowl - Non-PrePull
            if cast.able.prowl("player") and cat and autoProwl() and mode.prowl == 1
                and not buff.prowl.exists() and not IsResting() and GetTime()-leftCombat > lootDelay
            then
                if cast.prowl("player") then debug("Casting Prowl [Auto]") return true end
            end
        end -- End No Stealth
        -- Wild Charge
        if isChecked("Displacer Beast / Wild Charge") and cast.able.wildCharge("target") and isValidUnit("target") then
            if cast.wildCharge("target") then debug("Wild Charge on "..UnitName("target")) return true end
        end
        if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
            -- Regrowth
            -- regrowth,if=talent.bloodtalons.enabled
            if cast.able.regrowth("player") and talent.bloodtalons and not buff.bloodtalons.exists()
                and (htTimer == nil or htTimer < GetTime() - 1)
            then
                if GetShapeshiftForm() ~= 0 then
                    -- CancelShapeshiftForm()
                    RunMacroText("/CancelForm")
                end
                if cast.regrowth("player") then debug("Casting Regrowth [Pre-pull]"); htTimer = GetTime(); return true end
            end
            -- Prowl
            if cast.able.prowl("player") and buff.bloodtalons.exists()
                and mode.prowl == 1 and not buff.prowl.exists()
            then
                if cast.prowl("player") then debug("Casting Prowl [Pre-pull]"); return true end
            end
            if buff.prowl.exists() then
                -- Pre-pot
                -- potion,name=old_war
                if getOptionValue("Potion") ~= 4 and pullTimer <= 1 and (inRaid or inInstance) then
                    if getOptionValue("Potion") == 1 and use.able.superiorBattlePotionOfAgility() then
                        use.superiorBattlePotionOfAgility()
                        debug("Using Superior Battle Potion of Agility [Pre-pull]");
                    elseif getOptionValue("Potion") == 2 and use.able.battlePotionOfAgility() then
                        use.battlePotionOfAgility()
                        debug("Using Battle Potion of Agility [Pre-pull]");
                    elseif getOptionValue("Potion") == 3 and use.able.potionOfProlongedPower() then
                        use.potionOfProlongedPower()
                        debug("Using Potion of Prolonged Power [Pre-pull]");
                    end
                end
            end -- End Prowl
            -- Berserk/Tiger's Fury Pre-Pull
            if isChecked("Berserk/Tiger's Fury Pre-Pull") and pullTimer <= 1 and (inRaid or #br.friend > 1) then
                if cast.able.berserk() and cast.able.tigersFury() then
                    cast.berserk()
                    cast.tigersFury()
                    debug("Casting Berserk and Tiger's Fury [Pre-Pull]")
                end
            end
        end -- End Pre-Pull
        -- Rake/Shred
        -- buff.prowl.up|buff.shadowmeld.up
        if isValidUnit("target") and opener.complete and getDistance("target") < 5 then
            if cast.able.rake() and level >= 12 and not debuff.rake.exists("target") then
                if cast.rake("target") then debug("Casting Rake on "..UnitName("target").." [Pull]"); return true end
            elseif cast.able.shred() then
                if cast.shred("target") then debug("Casting Shred on "..UnitName("target").." [Pull]"); return true end
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
    ---------------
    --- Toggles ---
    ---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    UpdateToggle("Cleave",0.25)
    br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
    UpdateToggle("Prowl",0.25)
    br.player.mode.prowl = br.data.settings[br.selectedSpec].toggles["Prowl"]

    --------------
    --- Locals ---
    --------------
    -- BR API
    buff                               = br.player.buff
    cast                               = br.player.cast
    comboPoints                        = br.player.power.comboPoints.amount()
    cd                                 = br.player.cd
    charges                            = br.player.charges
    debuff                             = br.player.debuff
    debug                              = br.addonDebug
    enemies                            = br.player.enemies
    energy, energyRegen, energyDeficit = br.player.power.energy.amount(), br.player.power.energy.regen(), br.player.power.energy.deficit()
    equiped                            = br.player.equiped
    flying, swimming, moving           = IsFlying(), IsSwimming(), GetUnitSpeed("player")>0
    gcd                                = br.player.gcd
    gcdMax                             = br.player.gcdMax
    has                                = br.player.has
    healPot                            = getHealthPot()
    inCombat                           = br.player.inCombat
    inInstance                         = br.player.instance=="party"
    inRaid                             = br.player.instance=="raid"
    item                               = br.player.items
    level                              = br.player.level
    lootDelay                          = getOptionValue("LootDelay")
    lowestHP                           = br.friend[1].unit
    minCount                           = useCDs() and 1 or 3
    mode                               = br.player.mode
    multidot                           = br.player.mode.cleave == 1 and br.player.mode.rotation < 3
    opener                             = br.player.opener
    php                                = br.player.health
    pullTimer                          = PullTimerRemain()
    race                               = br.player.race
    solo                               = #br.friend < 2
    spell                              = br.player.spell
    stealth                            = br.player.buff.prowl.exists() or br.player.buff.shadowmeld.exists()
    talent                             = br.player.talent
    thp                                = getHP
    traits                             = br.player.traits
    travel, flight, cat                = br.player.buff.travelForm.exists(), br.player.buff.flightForm.exists(), br.player.buff.catForm.exists()
    ttd                                = getTTD
    ttm                                = br.player.power.energy.ttm()
    units                              = br.player.units
    use                                = br.player.use

    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    units.get(8,true)
    units.get(5)
    if range == nil then range = {} end
    range.dyn40 = getDistance(units.dyn40) < 40
    range.dyn8AOE = getDistance(units.dyn8AOE) < 8
    range.dyn5 = getDistance(units.dyn5) < 5

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
    if leftCombat == nil then leftCombat = GetTime() end
    if lastForm == nil then lastForm = 0 end
    if profileStop == nil then profileStop = false end
    if not inCombat and not UnitExists("target") and profileStop == true then
        profileStop = false
    end

    -- Jagged Wounds Rip Duration Adj
    if talent.jaggedWounds then
        ripDuration = 1.6 * (24 / 2)
    else
        ripDuration = 24
    end

    -- Friends In Range
    friendsInRange = false
    while not solo and not friendsInRange do
        for i = 1, #br.friend do
            if getDistance(br.friend[i].unit) < 15 then
                friendsInRange = true
            end
        end
    end

    fbMaxEnergy = energy > 50

    -- Opener Reset
    if (not inCombat and not GetObjectExists("target")) or opener.complete == nil then
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
    if traits.wildFleshrending.active then
        useThrash = 2
    else
        useThrash = 1
    end

    -- ChatOverlay("Rake: "..round2(debuff.rake.remain("target"),0)..", Rip: "..round2(debuff.rip.remain("target"),0))
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not UnitExists("target") and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 
        -- or (cast.current.focusedAzeriteBeam() and GetTime() < focusedTime())
    then
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
        if inCombat and cast.able.catForm("player") and not cat
            and #enemies.yards5f > 0 and not moving and isChecked("Auto Shapeshifts")
        then
            if cast.catForm("player") then debug("Casting Cat Form [Combat]"); return true end
        elseif inCombat and cat and profileStop==false
            and not isChecked("Death Cat Mode") and UnitExists("target") and opener.complete and cd.global.remain() == 0
        then
            -- Wild Charge
            -- wild_charge
            if isChecked("Displacer Beast / Wild Charge")
                and cast.able.wildCharge("player") and isValidUnit("target")
            then
                if cast.wildCharge("target") then debug("Casting Wild Charge on "..UnitName("target").." [Out of Melee]"); return true end
            end
            -- Rake/Shred from Stealth
            -- rake,if=buff.prowl.up|buff.shadowmeld.up
            if (buff.prowl.exists() or buff.shadowmeld.exists()) and range.dyn5 then
                -- if debuff.rake.exists(units.dyn5) or level < 12 then
                if cast.able.rake() and level >= 12 and (not debuff.rake.exists(units.dyn5) 
                    or debuff.rake.calc() > debuff.rake.applied(units.dyn5) * 0.85) 
                then
                    if cast.rake(units.dyn5) then --[[debug("Casting Rake on "..UnitName(units.dyn5).." [Stealth Break]");]] return true end
                elseif cast.able.shred() and debuff.rake.exists(units.dyn5) and debuff.rake.calc() <= debuff.rake.applied(units.dyn5) * 0.85 then
                    if cast.shred(units.dyn5) then --[[debug("Casting Shred on "..UnitName(units.dyn5).." [Stealth Break]");]] return true end
                end
            elseif not (buff.prowl.exists() or buff.shadowmeld.exists()) then
                -- auto_attack
                if not IsAutoRepeatSpell(GetSpellInfo(6603)) and range.dyn5 then
                    StartAttack(units.dyn5)
                end
                ------------------------------
                --- In Combat - Interrupts ---
                ------------------------------
                if actionList.Interrupts() then return true end
                ---------------------------
                --- SimulationCraft APL ---
                ---------------------------
                if getOptionValue("APL Mode") == 1 then
                    -- Call Action List - Cooldowns
                    if actionList.Cooldowns() then return true end
                    -- Ferocious Bite
                    -- ferocious_bite,target_if=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>10&(talent.sabertooth.enabled)
                    if cast.able.ferociousBite() and range.dyn5 then
                        for i = 1, #enemies.yards5f do
                            local thisUnit = enemies.yards5f[i]
                            if (debuff.rip.exists(thisUnit) and debuff.rip.remain(thisUnit) < 3 and ttd(thisUnit) > 10
                                and talent.sabertooth) or (ferociousBiteFinish(thisUnit) and not usePrimalWrath())
                            then
                                if getOptionValue("Ferocious Bite Execute") == 1 and ferociousBiteFinish(thisUnit) then
                                    Print("Ferocious Bite Finished! "..UnitName(thisUnit).." with "..round2(thp(thisUnit),0).."% health remaining.")
                                end
                                if cast.ferociousBite(thisUnit) then debug("Casting Ferocious Bite on "..UnitName(thisUnit).." [Sabertooth / Execute]"); return true end
                            end
                        end
                    end
                    -- Regrowth
                    -- regrowth,if=combo_points=5&buff.predatory_swiftness.up&talent.bloodtalons.enabled&buff.bloodtalons.down
                    if cast.able.regrowth() and (comboPoints == 5 and buff.predatorySwiftness.exists()
                        and talent.bloodtalons and not buff.bloodtalons.exists())
                    then
                        local opValue = getOptionValue("Auto Heal")
                        local thisUnit = opValue == 1 and br.friend[1].unit or "player"
                        if (opValue == 1 and getDistance(thisUnit) < 40) or opValue == 2 then
                            if cast.regrowth(thisUnit) then debug("Casting Regrowth on "..UnitName(thisUnit).." [BT = 5cp]"); return true end
                        end
                    end
                    -- Call Action List - Finisher
                    -- call_action_list,name=finisher
                    if comboPoints > 4 then
                        if actionList.Finisher() then return true end
                    end
                    -- Call Action List - Generator
                    -- call_action_list,name=generator
                    if comboPoints <= 4 then
                        if actionList.Generator() then return true end
                    end
                end -- End SimC APL
            end -- End No Stealth | Rotation Off Check
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

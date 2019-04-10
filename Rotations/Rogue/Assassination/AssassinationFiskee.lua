local rotationName = "Fiskee - 8.1"
local opener, opn1, opn2, opn3, opn4, opn5, opn6 = false, false, false, false, false, false, false
br.rogueTables = {}
local rogueTables = br.rogueTables
rogueTables.enemyTable5, rogueTables.enemyTable10, rogueTables.enemyTable30 = {}, {}, {}
local enemyTable5, enemyTable10, enemyTable30 = rogueTables.enemyTable5, rogueTables.enemyTable10, rogueTables.enemyTable30
local resetButton
local garrotePrioList = ""
local fhbossPool = false
local dotBlacklist = "135824|139057|129359|129448|134503|137458|139185|120651"
local stunSpellList = "274400|274383|257756|276292|268273|256897|272542|272888|269266|258317|258864|259711|258917|264038|253239|269931|270084|270482|270506|270507|267433|267354|268702|268846|268865|258908|264574|272659|272655|267237|265568|277567|265540"
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.garrote },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.fanOfKnives },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mutilate }
    };
    CreateButton("Rotation",1,0)
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.vendetta },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.vendetta },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.vendetta },
        [4] = { mode = "Lust", value = 4 , overlay = "Cooldowns With Bloodlust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.vendetta }
    };
    CreateButton("Cooldown",2,0)
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    };
    CreateButton("Defensive",3,0)
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt",4,0)
    OpenModes = {
        [1] = { mode = "Std", value = 1 , overlay = "Standard Rotation", tip = "Uses standard opener logic.", highlight = 1, icon = br.player.spell.garrote },
        [2] = { mode = "Stun", value = 2 , overlay = "Stun Opener", tip = "Will stun target in opener.", highlight = 1, icon = br.player.spell.cheapShot }
    };
    CreateButton("Open",5,0)
    ExsangModes = {
        [1] = { mode = "On", value = 1 , overlay = "Exsanguinate On", tip = "Will use Exsanguinate.", highlight = 1, icon = br.player.spell.exsanguinate },
        [2] = { mode = "Off", value = 2 , overlay = "Exsanguinate Off", tip = "Will not use Exsanguinate.", highlight = 0, icon = br.player.spell.exsanguinate }
    };
    CreateButton("Exsang",6,0)
    TBModes = {
        [1] = { mode = "On", value = 1 , overlay = "Toxic Blade On", tip = "Will use Toxic Blade.", highlight = 1, icon = br.player.spell.toxicBlade },
        [2] = { mode = "Off", value = 2 , overlay = "Toxic Blade Off", tip = "Will not use Toxic Blade.", highlight = 0, icon = br.player.spell.toxicBlade }
    };
    CreateButton("TB",6,0)
    GarroteModes = {
        [1] = { mode = "On", value = 1 , overlay = "Garrote On", tip = "Will use Garrote outside stealth.", highlight = 1, icon = br.player.spell.garrote },
        [2] = { mode = "Off", value = 2 , overlay = "Garrote Off", tip = "Will not use Garrote outside stealth.", highlight = 0, icon = br.player.spell.garrote }
    };
    CreateButton("Garrote",7,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            br.ui:createDropdownWithout(section, "Poison", {"Deadly","Wound",}, 1, "Poison to apply.")
            br.ui:createDropdown(section, "Auto Stealth", {"|cff00FF00Always", "|cffFF000020 Yards"},  1, "Auto stealth mode.")
            br.ui:createDropdown(section, "Auto Tricks", {"|cff00FF00Focus", "|cffFF0000Tank"},  1, "Tricks of the Trade target." )
            br.ui:createCheckbox(section, "Auto Target", "|cffFFFFFF Will auto change to a new target, if current target is dead")
            br.ui:createCheckbox(section, "Auto Garrote HP Limit", "|cffFFFFFF Will try to calculate if we should garrote from stealth on units, based on their HP")
            br.ui:createCheckbox(section, "Disable Auto Combat", "|cffFFFFFF Will not auto attack out of stealth, don't use with vanish CD enabled, will pause rotation after vanish")
            br.ui:createCheckbox(section, "Dot Blacklist", "|cffFFFFFF Check to ignore certain units when multidotting")
            br.ui:createSpinnerWithout(section,  "Multidot Limit",  3,  0,  8,  1,  "|cffFFFFFF Max units to dot with garrote.")
            br.ui:createCheckbox(section, "Ignore Blacklist for FoK and CT", "|cffFFFFFF Ignore blacklist for Fan of Knives and Crimson Tempest usage")
            br.ui:createSpinner(section,  "Disable Garrote on # Units",  10,  1,  20,  1,  "|cffFFFFFF Max units within 10 yards for garrote usage outside stealth (FoK spam)")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Racial", "|cffFFFFFF Will use Racial")
            br.ui:createCheckbox(section, "Trinkets", "|cffFFFFFF Will use Trinkets")
            br.ui:createDropdown(section, "Potion", {"Agility", "Bursting Blood"}, 1, "|cffFFFFFFPotion to use")
            br.ui:createCheckbox(section, "Vanish", "|cffFFFFFF Will use Vanish")
            br.ui:createCheckbox(section, "Vendetta", "|cffFFFFFF Will use Vendetta")
            br.ui:createCheckbox(section, "Hold Vendetta", "|cffFFFFFF Will hold Vendetta for Vanish")
            br.ui:createSpinnerWithout(section,  "CDs TTD Limit",  5,  0,  20,  1,  "|cffFFFFFF Time to die limit for using cooldowns.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createSpinner(section, "Health Pot / Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createCheckbox(section, "Cloak of Shadows")
            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Evasion",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            br.ui:createCheckbox(section, "Auto Defensive Unavoidables", "|cffFFFFFF Will use feint/evasion on certain unavoidable boss abilities")
            br.ui:createSpinnerWithout(section,  "Evasion Unavoidables HP Limit",  85,  0,  100,  5,  "|cffFFFFFF Player HP to use evasion on unavoidables.")
            br.ui:createCheckbox(section, "Cloak Unavoidables", "|cffFFFFFF Will cloak on unavoidables")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Kick")
            br.ui:createCheckbox(section, "Kidney Shot")
            br.ui:createCheckbox(section, "Blind")
            br.ui:createSpinnerWithout(section,  "Interrupt %",  30,  0,  95,  5,  "|cffFFBB00Remaining Cast Percentage to interrupt at.")
            br.ui:createCheckbox(section, "Stuns", "|cffFFFFFF Auto stun mobs from whitelist")
            br.ui:createSpinnerWithout(section,  "Max CP For Stun",  3,  1,  6,  1,  "|cffFFBB00 Maximum number of combo points to stun")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
        ----------------------
        -------- LISTS -------
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Lists")
            br.ui:createScrollingEditBoxWithout(section,"Dot Blacklist Units", dotBlacklist, "List of units to blacklist when multidotting", 240, 40)
            br.ui:createScrollingEditBoxWithout(section,"Stun Spells", stunSpellList, "List of spells to stun with auto stun function", 240, 50)
            br.ui:createScrollingEditBoxWithout(section,"Garrote Prio Units", garrotePrioList, "List of units to prioritize for garrote", 240, 50)
            -- resetButton = br.ui:createButton(section, "Reset Lists")
            -- resetButton:SetEventListener("OnClick", function()
            --     local selectedProfile = br.data.settings[br.selectedSpec][br.selectedProfile]
            --     selectedProfile["Dot Blacklist UnitsEditBox"] = dotBlacklist
            --     selectedProfile["Stun SpellsEditBox"] = stunSpellList
            --     br.rotationChanged = true
            -- end)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    br.player.mode.open = br.data.settings[br.selectedSpec].toggles["Open"]
    br.player.mode.exsang = br.data.settings[br.selectedSpec].toggles["Exsang"]
    br.player.mode.tb = br.data.settings[br.selectedSpec].toggles["TB"]
    br.player.mode.garrote = br.data.settings[br.selectedSpec].toggles["Garrote"]
--------------
--- Locals ---
--------------
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local combatTime                                    = getCombatTime()
    local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
    local cd                                            = br.player.cd
    local debuff                                        = br.player.debuff
    local enemies                                       = br.player.enemies
    local energyDeficit, energyRegen                    = br.player.power.energy.deficit(), br.player.power.energy.regen()
    local gcd                                           = br.player.gcd
    local has                                           = br.player.has
    local healPot                                       = getHealthPot()
    local inCombat                                      = br.player.inCombat
    local level                                         = br.player.level
    local mode                                          = br.player.mode
    local moving                                        = isMoving("player") ~= false or br.player.moving
    local php                                           = br.player.health
    --local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local spell                                         = br.player.spell
    local stealth                                       = br.player.buff.stealth.exists()
    local stealthedRogue                                = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.4 or br.player.cast.last.vanish(1) or botSpell == spell.vanish
    local stealthedAll                                  = stealthedRogue or br.player.buff.shadowmeld.exists()
    local talent                                        = br.player.talent
    local targetDistance                                = getDistance("target")
    local thp                                           = getHP("target")
    local tickTime                                      = 2 / (1 + (GetHaste()/100))
    local trait                                         = br.player.traits
    local units                                         = br.player.units
    local use                                           = br.player.use
    local validTarget                                   = isValidUnit("target")

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    if not UnitAffectingCombat("player") then
        if fhbossPool then fhbossPool = false end
        if not talent.exsanguinate then
            if talent.toxicBlade then
                buttonTB:Show()
            end
            buttonExsang:Hide()
        else
            buttonExsang:Show()
            buttonTB:Hide()
        end
    end

    local garroteCount = 0

    units.get(5)
    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(30)

    local tricksUnit
    if isChecked("Auto Tricks") and GetSpellCooldown(spell.tricksOfTheTrade) == 0 and inCombat then
        if getOptionValue("Auto Tricks") == 1 and GetUnitIsFriend("player", "focus") and getLineOfSight("player", "focus") then
            tricksUnit = "focus"
        elseif getOptionValue("Auto Tricks") == 2 then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if UnitGroupRolesAssigned(thisUnit) == "TANK" and not UnitIsDeadOrGhost(thisUnit) and getLineOfSight("player", thisUnit) then
                    tricksUnit = thisUnit
                    break
                end
            end
        end
    end

    local function ttd(unit)
        if UnitIsPlayer(unit) then return 999 end
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then return ttdSec end
        if ttdSec == -1 then return 999 end
        return ttdSec
    end

    local function shallWeDot(unit)
        if isChecked("Auto Garrote HP Limit") and ttd(unit) == 999 and not UnitIsPlayer(unit) and not isDummy(unit) then
            local hpLimit = 0
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                local thisHP = UnitHealthMax(thisUnit)
                local thisRole = UnitGroupRolesAssigned(thisUnit)
                if not UnitIsDeadOrGhost(thisUnit) and getDistance(unit, thisUnit) < 40 then
                    if thisRole == "TANK" then hpLimit = hpLimit + (thisHP * 0.1) end
                    if (thisRole == "DAMAGER" or thisRole == "NONE") then hpLimit = hpLimit + (thisHP * 0.3) end
                end
            end
            if UnitHealthMax(unit) > hpLimit then return true end
            return false
        end
        return true
    end

    local function isTotem(unit)
        local eliteTotems = { -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = UnitCreatureType(unit)
        local objectID = GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
        end
        return false
    end

    local noDotUnits = {}
    for i in string.gmatch(getOptionValue("Dot Blacklist Units"), "%d+") do
        noDotUnits[tonumber(i)] = true
    end

    local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
        if isTotem(unit) then return true end
        local unitCreator = UnitCreator(unit)
        if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
        if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
        return false
    end

    local garroteList = {}
    for i in string.gmatch(getOptionValue("Garrote Prio Units"), "%d+") do
        garroteList[tonumber(i)] = true
    end

    local function clearTable(t)
        local count = #t
        for i=0, count do t[i]=nil end
    end

    --YOINK @IMMY
    function getapdmg(offHand)
        local useOH = offHand or false
        local wdpsCoeff = 6
        local ap = UnitAttackPower("player")
        local minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage("player")
        local speed, offhandSpeed = UnitAttackSpeed("player")
            if useOH and offhandSpeed then
                local wSpeed = offhandSpeed * (1 + GetHaste() / 100)
                local wdps = (minOffHandDamage + maxOffHandDamage) / wSpeed / percent - ap / wdpsCoeff
            return (ap + wdps * wdpsCoeff) * 0.5
            else
                local wSpeed = speed * (1 + GetHaste() / 100)
                local wdps = (minDamage + maxDamage) / 2 / wSpeed / percent - ap / wdpsCoeff
            return ap + wdps * wdpsCoeff
        end
    end
    function getmutidamage()
        return            
        (getapdmg() + getapdmg(true) * 0.5) * 0.35 * 1.27 * 
        (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
    end
    --YOINK @IMMY
    function getenvdamage(unit)
        if unit == nil then unit = "target" end
        local apMod         = getapdmg()
        local envcoef       = 0.16
        local auramult      = 1.27
        local masterymult   = (1 + (GetMasteryEffect("player") / 100))
        local versmult      = (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
        local dsmod, tbmod
        if talent.DeeperStratagem then dsmod = 1.05 else dsmod = 1 end 
        if debuff.toxicBlade.exists(unit) then tbmod = 1.3 else tbmod = 1 end
        return (apMod * combo * envcoef * auramult * tbmod * dsmod * masterymult * versmult)
    end

    clearTable(enemyTable5)
    clearTable(enemyTable10)
    clearTable(enemyTable30)
    local deadlyPoison10 = true
    if #enemies.yards30 > 0 then
        local highestHP
        local lowestHP
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) and (mode.rotation ~= 3 or (mode.rotation == 3 and GetUnitIsUnit(thisUnit, "target"))) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.objectID = GetObjectID(thisUnit)
                tinsert(enemyTable30, enemyUnit)
                if highestHP == nil or highestHP < enemyUnit.hpabs then highestHP = enemyUnit.hpabs end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then lowestHP = enemyUnit.hpabs end
                if enemyTable30.lowestTTDUnit == nil or enemyTable30.lowestTTD > enemyUnit.ttd then
                    enemyTable30.lowestTTDUnit = enemyUnit.unit
                    enemyTable30.lowestTTD = enemyUnit.ttd
                end
            end
        end
        if #enemyTable30 > 1 then
            for i = 1, #enemyTable30 do
                local thisUnit = enemyTable30[i]
                local hpNorm = (10-1)/(highestHP-lowestHP)*(thisUnit.hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if thisUnit.ttd > 1.5 then enemyScore = enemyScore + 5 end
                if thisUnit.distance <= 5 then enemyScore = enemyScore + 30 end
                if garroteList[thisUnit.objectID] ~= nil then enemyScore = enemyScore + 50 end
                if GetUnitIsUnit(thisUnit.unit, "target") then enemyScore = enemyScore + 100 end
                local raidTarget = GetRaidTargetIndex(thisUnit.unit)
                if raidTarget ~= nil then
                    enemyScore = enemyScore + raidTarget * 3
                    if raidTarget == 8 then enemyScore = enemyScore + 5 end
                end
                thisUnit.enemyScore = enemyScore
            end
            table.sort(enemyTable30, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        for i = 1, #enemyTable30 do
            local thisUnit = enemyTable30[i]
            local fokIgnore = {
                [120651]=true -- Explosive
            }

            if thisUnit.distance <= 10 then
                if fokIgnore[thisUnit.objectID] == nil and not isTotem(thisUnit.unit) then
                    tinsert(enemyTable10, thisUnit)
                    if deadlyPoison10 and not trait.echoingBlades.active and (getOptionValue("Poison") == 1 and not debuff.deadlyPoison.exists(thisUnit.unit)) or (getOptionValue("Poison") == 2 and not debuff.woundPoison.exists(thisUnit.unit)) then deadlyPoison10 = false end
                end
                if debuff.garrote.remain(thisUnit.unit) > 0.5 then garroteCount = garroteCount + 1 end
                if thisUnit.distance <= 5 then
                    tinsert(enemyTable5, thisUnit)
                end
            end
        end
        if isChecked("Auto Target") and inCombat and #enemyTable30 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable30[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable30[1].unit)
        end
    end
    --Just nil fixes
    if enemyTable30.lowestTTD == nil then enemyTable30.lowestTTD = 999 end

    --Variables
    local dSEnabled, sSActive, dDRank, sRogue
    if talent.deeperStratagem then dSEnabled = 1 else dSEnabled = 0 end
    if trait.shroudedSuffocation.active then sSActive = 1 else sSActive = 0 end
    if trait.doubleDose.rank > 2 then dDRank = 1 else dDRank = 0 end
    if stealthedRogue == true then sRogue = 1 else sRogue = 0 end
    local enemies10 = #enemyTable10

    if isChecked("Ignore Blacklist for FoK and CT") and mode.rotation ~= 3 then
        enemies10 = #enemies.get(10)
    end

    -- actions+=/variable,name=energy_regen_combined,value=energy.regen+poisoned_bleeds*7%(2*spell_haste)
    local energyRegenCombined = energyRegen + ((garroteCount + debuff.rupture.count()) * 7 / (2 * (1 / (1 + (GetHaste()/100)))))
    if not inCombat and mode.open ~= 1 and opener == true and not cast.last.kidneyShot(1) and not cast.last.kidneyShot(2) then
        opener, opn1, opn2, opn3, opn4, opn5, opn6 = false, false, false, false, false, false, false
    end
    if mode.open == 1 then opener = true end

    local garroteCheck = true

    if (isChecked("Disable Garrote on # Units") and enemies10 >= getOptionValue("Disable Garrote on # Units")) or mode.garrote == 2 then
        garroteCheck = false
    end

--------------------
--- Action Lists ---
--------------------
    local function actionList_Extra()
        if not inCombat then
            -- actions.precombat+=/apply_poison
            if not moving and getOptionValue("Poison") == 1 and buff.deadlyPoison.remain() < 300 and not cast.last.deadlyPoison(1) then
                if cast.deadlyPoison("player") then return true end
            end
            if not moving and getOptionValue("Poison") == 2 and buff.woundPoison.remain() < 300 and not cast.last.woundPoison(1) then
                if cast.woundPoison("player") then return true end
            end
            if not moving and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison(1) then
                if cast.cripplingPoison("player") then return true end
            end
            -- actions.precombat+=/stealth
            if isChecked("Auto Stealth") and IsUsableSpell(spell.stealth) and not cast.last.vanish() and not IsResting() and
            (botSpell ~= spell.stealth or (botSpellTime == nil or GetTime() - botSpellTime > 0.1)) then
                if getOptionValue("Auto Stealth") == 1 then
                    if cast.stealth() then return end
                end
                if #enemies.yards20nc > 0 and getOptionValue("Auto Stealth") == 2 then
                    if cast.stealth() then return end
                end
            end
        end
        --Burn Units
        local burnUnits = {
            [120651]=true -- Explosive
        }
        if UnitIsVisible("target") and burnUnits[GetObjectID("target")] ~= nil and targetDistance < 5 then
            if getenvdamage() >= UnitHealth("target") then
                if cast.envenom("target") then return true end
            end
            if cast.mutilate("target") then return true end
            if combo >= 4 then
                if cast.envenom("target") then return true end
            end
            return true
        end
    end
    local function actionList_Defensive()
        if useDefensive() then
            if isChecked("Auto Defensive Unavoidables") then
                --Powder Shot (2nd boss freehold)
                local bossID = GetObjectID("boss1")
                local boss2ID = GetObjectID("boss2")
                local boss = "boss1"
                if boss2ID == 126848 then 
                    bossID = 126848
                    boss = "boss2"
                end
                if bossID == 126848 and isCastingSpell(256979, boss) and GetUnitIsUnit("player", UnitTarget(boss)) then
                    if talent.elusiveness then
                        if cast.feint() then return true end
                    elseif getOptionValue("Evasion Unavoidables HP Limit") >= php then
                        if cast.evasion() then return true end
                    end
                end                
                --Azerite Powder Shot (1st boss freehold)
                if not fhbossPool and bossID == 126832 and br.DBM:getTimer(256106) <= 1 then -- pause 1 sec before cast for pooling
                    fhbossPool = true
                end
                if bossID == 126832 and isCastingSpell(256106, "boss1") then
                    fhbossPool = false
                    if GetUnitIsUnit("player", UnitTarget("boss1")) then
                        if cast.feint() then return true end
                    end
                end
                if fhbossPool then return true end
                --Spit gold (1st boss KR)
                if bossID == 135322 and isCastingSpell(265773, "boss1") and GetUnitIsUnit("player", UnitTarget("boss1")) and isChecked("Cloak Unavoidables") then
                    if cast.cloakOfShadows() then return true end
                end
                if UnitDebuffID("player",265773) and getDebuffRemain("player",265773) <= 2 then
                    if cast.feint() then return true end
                end
                --Static Shock (1st boss Temple)
                if (bossID == 133944 or GetObjectID("boss2") == 133944) and (isCastingSpell(263257, "boss1") or isCastingSpell(263257, "boss2")) then
                    if isChecked("Cloak Unavoidables") then
                        if cast.cloakOfShadows() then return true end
                    end
                    if not buff.cloakOfShadows.exists() then
                        if cast.feint() then return true end
                    end
                end
                --Noxious Breath (2nd boss temple)
                if bossID == 133384 and isCastingSpell(263912, "boss1") and (select(5,UnitCastingInfo("boss1"))/1000-GetTime()) < 1.5 then
                    if cast.feint() then return true end
                end
            end
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") and not inCombat then
                if hasEquiped(122668) then
                    if GetItemCooldown(122668)==0 then
                        useItem(122668)
                    end
                end
            end
            if isChecked("Health Pot / Healthstone") and (use.able.healthstone() or canUse(152494))
            and php <= getOptionValue("Health Pot / Healthstone") and inCombat and (hasItem(152494) or has.healthstone())
            then
                if use.able.healthstone() then
                    use.healthstone()
                elseif canUse(152494) then
                    useItem(152494)
                end
            end
            if isChecked("Cloak of Shadows") and canDispel("player",spell.cloakOfShadows) and inCombat then
                if cast.cloakOfShadows() then return true end
            end
            if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
                if cast.crimsonVial() then return true end
            end
            if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat and not stealth then
                if cast.evasion() then return true end
            end
            if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() then
                if cast.feint() then return true end
            end
        end
    end

    local function actionList_Interrupts()
        local stunList = {}
        for i in string.gmatch(getOptionValue("Stun Spells"), "%d+") do
            stunList[tonumber(i)] = true
        end
        if not stealthedRogue then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = getDistance(thisUnit)
                if useInterrupts() and canInterrupt(thisUnit,getOptionValue("Interrupt %")) then
                    if isChecked("Kick") and distance < 5 then
                        if cast.kick(thisUnit) then return end
                    end
                    if cd.kick.remain() ~= 0 then
                        if isChecked("Kidney Shot") then
                            if cast.kidneyShot(thisUnit) then return true end
                        end
                    end
                    if isChecked("Blind") and (cd.kick.remain() ~= 0 or distance >= 5) then
                        if cast.blind(thisUnit) then return end
                    end
                end
                if isChecked("Stuns") and distance < 5 and combo > 0 and combo <= getOptionValue("Max CP For Stun") then
                    local interruptID, castStartTime
                    if UnitCastingInfo(thisUnit) then
                        castStartTime = select(4,UnitCastingInfo(thisUnit))
                        interruptID = select(9,UnitCastingInfo(thisUnit))
                    elseif UnitChannelInfo(thisUnit) then
                        castStartTime = select(4,UnitChannelInfo(thisUnit))
                        interruptID = select(7,GetSpellInfo(UnitChannelInfo(thisUnit)))
                    end
                    if interruptID ~=nil and stunList[interruptID] and (GetTime()-(castStartTime/1000)) > 0.1 then
                        if cast.kidneyShot(thisUnit) then return true end
                    end
                end
            end
        end
    end

    local function actionList_Opener()
        if opener == false and validTarget and IsSpellInRange(GetSpellInfo(spell.cheapShot), "target") == 1 then
            if opn1 == false then
                if not isChecked("Disable Auto Combat") and stealthedRogue then
                    if combo >= 5 then
                        if cast.kidneyShot("target") then
                            opener, opn1 = true, true
                            return true
                        end
                        return true
                    end
                    if cast.cheapShot("target") then
                        opn1 = true
                        return true
                    end
                elseif (inCombat and (debuff.cheapShot.exists("target") or debuff.kidneyShot.exists("target"))) or not stealthedRogue then
                    opn1 = true
                end
            end
            if opn1 == true and opn2 == false then
                if cast.garrote("target") then
                    opn2 = true
                    return true
                end
            end
            if opn2 == true and opn3 == false and combo >= 4 then opn3 = true end
            if opn2 == true and opn3 == false then
                if cast.mutilate("target") then return true end
            end
            if opn3 == true and opn4 == false then
                if cast.rupture("target") then
                    opn4 = true
                    return true
                end
            end
            if opn4 == true then
                if cd.kidneyShot.remain() > 1 then opn5, opn6, opener = true, true, true end
                if opn5 == false and combo >= 4 and gcd < 0.5 then opn5 = true end
            end
            if opn4 == true and opn5 == false then
                if talent.markedForDeath then
                    if cast.markedForDeath("target") then return true end
                end
                if cast.mutilate("target") then return true end
            end
            if opn5 == true and opn6 == false then
                if cast.kidneyShot("target") then
                    opener, opn6 = true, true
                    return true
                end
            end
            return true
        end
    end

    local function actionList_PreCombat()
        -- actions.precombat+=/potion
        -- actions.precombat+=/marked_for_death,precombat_seconds=5,if=raid_event.adds.in>40
    end

    local function actionList_Cooldowns()
        -- actions.cds=potion,if=buff.bloodlust.react|debuff.vendetta.up
        if useCDs() and ttd("target") > 15 and isChecked("Potion") and (hasBloodLust() or debuff.vendetta.exists("target")) and targetDistance < 5 then
            if getOptionValue("Potion") == 1 and ttd("target") > 15 and use.able.battlePotionOfAgility() and not buff.battlePotionOfAgility.exists() then
                use.battlePotionOfAgility()
                return true
            elseif getOptionValue("Potion") == 2 and ttd("target") > getOptionValue("CDs TTD Limit") and use.able.potionOfBurstingBlood() and not buff.potionOfBurstingBlood.exists() then
                use.potionOfBurstingBlood()
                return true
            end
        end
        -- actions.cds+=/use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
        if useCDs() and isChecked("Trinkets") and ((cd.vendetta.remain() <= 1 and (not talent.subterfuge or debuff.garrote.applied() > 1)) or cd.vendetta.remain() > 45 or not isChecked("Vendetta")) and targetDistance < 5 and ttd("target") > getOptionValue("CDs TTD Limit") then
            if canUse(13) and not (hasEquiped(140808, 13) or hasEquiped(151190, 13)) then
                useItem(13)
            end
            if canUse(14) and not (hasEquiped(140808, 14) or hasEquiped(151190, 14)) then
                useItem(14)
            end
        end
        -- actions.cds+=/blood_fury,if=debuff.vendetta.up
        -- actions.cds+=/berserking,if=debuff.vendetta.up
        -- actions.cds+=/fireblood,if=debuff.vendetta.up
        -- actions.cds+=/ancestral_call,if=debuff.vendetta.up
        if useCDs() and isChecked("Racial") and debuff.vendetta.exists("target") and ttd("target") > 5 and targetDistance < 5  then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                if cast.racial("player") then return true end
            end
        end
        -- # If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or without any CP.
        -- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit*1.5|combo_points.deficit>=cp_max_spend)
        if #enemyTable30 > 1 and (enemyTable30.lowestTTD < (comboDeficit * 1.5) or comboDeficit >= comboMax) then
            if cast.markedForDeath(enemyTable30.lowestTTDUnit) then return true end
        end
        -- # If no adds will die within the next 30s, use MfD on boss without any CP.
        -- actions.cds+=/marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
        if #enemyTable30 == 1 and comboDeficit >= comboMax then
            if cast.markedForDeath("target") then return true end
        end
        if useCDs() and ttd("target") > getOptionValue("CDs TTD Limit") then
            -- # Vendetta outside stealth with Rupture up. With Subterfuge talent and Shrouded Suffocation power always use with buffed Garrote. With Nightstalker and Exsanguinate use up to 5s (3s with DS) before Vanish combo.
            -- actions.cds+=/vendetta,if=!stealthed.rogue&dot.rupture.ticking&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier>1&(spell_targets.fan_of_knives<6|!cooldown.vanish.up))&(!talent.nightstalker.enabled|!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5-2*talent.deeper_stratagem.enabled)
            if isChecked("Vendetta") and not stealthedRogue then
                if isChecked("Hold Vendetta") and (not talent.subterfuge or not trait.shroudedSuffocation.active or (debuff.garrote.applied("target") > 1 and (enemies10 < 6 or cd.vanish.remain() > 0)) or not isChecked("Vanish") or cd.vanish.remain() > 110) and (not talent.nightstalker or not talent.exsanguinate or (talent.exsanguinate and cd.exsanguinate.remain() < (5-2*dSEnabled))) and debuff.rupture.exists("target") then
                    if cast.vendetta("target") then return true end
                end
                if not isChecked("Hold Vendetta") and (not talent.nightstalker or not talent.exsanguinate or (talent.exsanguinate and cd.exsanguinate.remain() < (5-2*dSEnabled))) and debuff.rupture.exists("target") then
                    if cast.vendetta("target") then return true end
                end
            end
            if isChecked("Vanish") and not stealthedRogue and targetDistance < 5 and gcd < 0.2 and getSpellCD(spell.vanish) == 0 then
                -- # Extra Subterfuge Vanish condition: Use when Garrote dropped on Single Target
                -- actions.cds+=/vanish,if=talent.subterfuge.enabled&!dot.garrote.ticking&variable.single_target
                if talent.subterfuge and enemies10 == 1 and getSpellCD(spell.garrote) == 0 and not debuff.garrote.exists("target") then
                    if cast.pool.garrote(nil, nil, 2) then return true end
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Exsg + (Nightstalker, or Subterfuge only on 1T): Maximum CP and Exsg ready for next GCD
                -- actions.cds+=/vanish,if=talent.exsanguinate.enabled&(talent.nightstalker.enabled|talent.subterfuge.enabled&variable.single_target)&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier<=1)
                if talent.exsanguinate and (talent.nightstalker or (talent.subterfuge and enemies10 == 1)) and combo >= comboMax and cd.exsanguinate.remain() < 1 and (not talent.subterfuge or not trait.shroudedSuffocation.active or debuff.garrote.applied("target") <= 1) and getSpellCD(spell.garrote) == 0 then
                    if cast.pool.garrote() then return true end
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Nightstalker + No Exsg: Maximum CP and Vendetta up
                -- actions.cds+=/vanish,if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&combo_points>=cp_max_spend&debuff.vendetta.up
                if talent.nightstalker and not talent.exsanguinate and comboDeficit >= comboMax and (debuff.vendetta.exists("target") or not isChecked("Vendetta")) then
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Subterfuge + (No Exsg or 2T+): No stealth/subterfuge, Garrote Refreshable, enough space for incoming Garrote CP
                -- actions.cds+=/vanish,if=talent.subterfuge.enabled&(!talent.exsanguinate.enabled|!variable.single_target)&!stealthed.rogue&cooldown.garrote.up&dot.garrote.refreshable&(spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives|spell_targets.fan_of_knives>=4&combo_points.deficit>=4)
                if talent.subterfuge and (not talent.exsanguinate or enemies10 > 1) and not stealthedRogue and getSpellCD(spell.garrote) == 0 and debuff.garrote.refresh("target") and ((enemies10 <= 3 and comboDeficit >= 1 + enemies10) or (enemies10 >= 4 and comboDeficit >= 4)) then
                    if cast.pool.garrote(nil, nil, 2) then return true end
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Master Assasin: No stealth and no active MA buff, Rupture not in refresh range
                -- actions.cds+=/vanish,if=talent.master_assassin.enabled&!stealthed.all&master_assassin_remains<=0&!dot.rupture.refreshable
                if talent.masterAssassin and not stealthedAll and gcd < 0.1 and not buff.masterAssassin.exists() and not debuff.rupture.refresh("target") then
                    if cast.vanish("player") then return true end
                end
            end
        end
        -- # Exsanguinate when both Rupture and Garrote are up for long enough
        -- actions.cds+=/exsanguinate,if=dot.rupture.remains>4+4*cp_max_spend&!dot.garrote.refreshable
        if mode.exsang == 1 and talent.exsanguinate and getSpellCD(spell.exsanguinate) == 0 and debuff.rupture.remain("target") > 16 and (not debuff.garrote.refresh("target") or garroteCheck == false) and ttd("target") > 8 then
            if cast.exsanguinate("target") then return true end
        end
        -- actions.cds+=/toxic_blade,if=dot.rupture.ticking
        if talent.toxicBlade and mode.tb == 1 and ttd("target") > 3 and getSpellCD(spell.toxicBlade) == 0 and debuff.rupture.exists("target") then
            if cast.toxicBlade("target") then return true end
        end
    end

    local function actionList_Direct()
        -- # Envenom at 4+ (5+ with DS) CP. Immediately on 2+ targets, with Vendetta, or with TB; otherwise wait for some energy. Also wait if Exsg combo is coming up.
        -- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
        if combo >= (4 + dSEnabled) and ((debuff.vendetta.exists("target") or not useCDs() or ttd("target") < getOptionValue("CDs TTD Limit")) or debuff.toxicBlade.exists("target") or energyDeficit <= (25 + energyRegenCombined) or enemies10 > 1) and (not talent.exsanguinate or cd.exsanguinate.remain() > 2 or mode.exsang == 2 or ttd("target") < 8) then
            if cast.envenom("target") then return true end
        end
        -- actions.direct+=/variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target
        local useFiller = (comboDeficit > 1 or energyDeficit <= (25 + energyRegenCombined) or enemies10 > 1) and (not stealthedRogue or talent.masterAssassin)
        -- # With Echoing Blades, Fan of Knives at 2+ targets.
        -- actions.direct+=/fan_of_knives,if=variable.use_filler&azerite.echoing_blades.enabled&spell_targets.fan_of_knives>=2
        if useFiller and enemies10 >= 2 and trait.echoingBlades.active then
            if cast.fanOfKnives("player") then return true end
        end
        -- actions.direct+=/fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|spell_targets.fan_of_knives>=4+(azerite.double_dose.rank>2)+stealthed.rogue)
        if useFiller and (buff.hiddenBlades.stack() >= 19 or enemies10 >= (4 + dDRank + sRogue)) then
            if cast.fanOfKnives("player") then return true end
        end
        -- # Fan of Knives to apply Deadly Poison if inactive on any target at 3 targets
        -- actions.direct+=/fan_of_knives,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives>=3
        if not deadlyPoison10 and useFiller and enemies10 >= 3 then
            if cast.fanOfKnives("player") then return true end
        end
        -- actions.direct+=/blindside,if=variable.use_filler&(buff.blindside.up|!talent.venom_rush.enabled&!azerite.double_dose.enabled)
        if useFiller and thp < 30 and (buff.blindside.exists() or (not talent.venomRush and not trait.doubleDose.active)) then
            if cast.blindside("target") then return true end
        end
        -- # Tab-Mutilate to apply Deadly Poison at 2 targets
        -- actions.direct+=/mutilate,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives=2
        if useFiller and enemies10 == 2 then
            if (getOptionValue("Poison") == 1 and not debuff.deadlyPoison.exists("target")) or (getOptionValue("Poison") == 2 and not debuff.woundPoison.exists("target")) then
                if cast.mutilate("target") then return true end
            end
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if (getOptionValue("Poison") == 1 and not debuff.deadlyPoison.exists(thisUnit)) or (getOptionValue("Poison") == 2 and not debuff.woundPoison.exists(thisUnit)) then
                    if cast.mutilate(thisUnit) then return true end
                end
            end
        end
        -- actions.direct+=/mutilate,if=variable.use_filler
        if useFiller then
            if cast.mutilate("target") then return true end
        end
        --evis low level
        if level < 36 and combo >= 4 then
            if cast.eviscerate("target") then return true end
        end
        -- Sinister Strike
        if level < 40 then
            if cast.sinisterStrike("target") then return true end
        end
    end

    local function actionList_Dot()
        -- # Special Rupture setup for Exsg
        -- actions.dot=rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2)))
        if mode.exsang == 1 and enemies10 < 3 and talent.exsanguinate and ((combo>=comboMax and cd.exsanguinate.remain() < 1) or (not debuff.rupture.exists("target") and (combatTime > 10 or combo >= 2))) and ttd("target") > 10 then
            if cast.rupture("target") then return true end
        end
        -- actions.dot+=/pool_resource,for_next=1
        -- actions.dot+=/garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(target.time_to_die-remains>4&spell_targets.fan_of_knives<=1|target.time_to_die-remains>12)
        local vanishCheck, vendettaCheck = false, false
        if useCDs() and ttd("target") > getOptionValue("CDs TTD Limit") then
            if isChecked("Vanish") and cd.vanish.remain() == 0 then vanishCheck = true end
            if isChecked("Vendetta") and cd.vendetta.remain() <= 4 then vendettaCheck = true end
        end
        if (not talent.subterfuge or not (vanishCheck and vendettaCheck)) and comboDeficit >= 1 and garroteCheck and getSpellCD(spell.garrote) == 0 then
            if garroteCount <= getOptionValue("Multidot Limit") then
                for i = 1, #enemyTable5 do
                    local thisUnit = enemyTable5[i].unit
                    local garroteRemain = debuff.garrote.remain(thisUnit)
                    if ((garroteRemain == 0 and garroteCount < getOptionValue("Multidot Limit")) or (garroteRemain > 0 and garroteCount <= getOptionValue("Multidot Limit"))) and
                    debuff.garrote.refresh(thisUnit) and
                    (debuff.garrote.applied(thisUnit) <= 1 or (garroteRemain <= tickTime and enemies10 >= (3 + sSActive))) and
                    (not debuff.garrote.exsang(thisUnit) or (garroteRemain < (tickTime * 2) and enemies10 >= (3 + sSActive))) and
                    (((enemyTable5[i].ttd-garroteRemain)>4 and enemies10 <= 1) or enemyTable5[i].ttd>12) then
                        if cast.pool.garrote() then return true end
                        if cast.garrote(thisUnit) then return true end
                    end
                end
            end
        end
        -- # Crimson Tempest only on multiple targets at 4+ CP when running out in 2s (up to 4 targets) or 3s (5+ targets)
        -- actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4
        local crimsonTargets
        if enemies10 >= 5 then crimsonTargets = 1 else crimsonTargets = 0 end
        if talent.crimsonTempest and enemies10 >= 2 and debuff.crimsonTempest.remain("target") < (2+crimsonTargets) and combo >= 4 and not buff.stealth.exists() and not buff.vanish.exists() then
            if cast.crimsonTempest("player") then return true end
        end
        -- # Keep up Rupture at 4+ on all targets (when living long enough and not snapshot)
        -- actions.dot+=/rupture,cycle_targets=1,if=combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&target.time_to_die-remains>4
        if combo >= 4 and getSpellCD(spell.rupture) == 0 then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                local ruptureRemain = debuff.rupture.remain(thisUnit)
                if debuff.rupture.refresh(thisUnit) and (debuff.rupture.applied(thisUnit) <= 1 or (ruptureRemain <= tickTime and enemies10 >= (3 + sSActive))) and
                (not debuff.rupture.exsang(thisUnit) or (ruptureRemain < (tickTime *2) and enemies10 >= (3 + sSActive))) and (enemyTable5[i].ttd-ruptureRemain)>4 then
                    if cast.rupture(thisUnit) then return true end
                end
            end
        end
    end

    local function actionList_Stealthed()
        -- # Nighstalker, or Subt+Exsg on 1T: Snapshot Rupture
        -- actions.stealthed=rupture,if=combo_points>=4&(talent.nightstalker.enabled|talent.subterfuge.enabled&(talent.exsanguinate.enabled&cooldown.exsanguinate.remains<=2|!ticking)&variable.single_target)&target.time_to_die-remains>6
        if combo >= 4 and ttd("target") > 6 and (talent.nightstalker or (mode.exsang == 1 and talent.subterfuge and ((talent.exsanguinate and cd.exsanguinate.remain() <= 2) or not debuff.rupture.exists("target")) and #enemies.yards30 == 1)) then
            if cast.rupture("target") then return true end
        end
        -- # Subterfuge: Apply or Refresh with buffed Garrotes
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&refreshable&target.time_to_die-remains>2
        if talent.subterfuge then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                local garroteRemain = debuff.garrote.remain(thisUnit)
                if shallWeDot(thisUnit) and garroteRemain <= 5.4 and (enemyTable5[i].ttd - garroteRemain) > 2 then
                    if cast.pool.garrote() then return true end
                    if cast.garrote(thisUnit) then return true end
                end
            end
        end
        -- # Subterfuge: Override normal Garrotes with snapshot versions
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&remains<=10&pmultiplier<=1&target.time_to_die-remains>2
        if talent.subterfuge then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                local garroteRemain = debuff.garrote.remain(thisUnit)
                if debuff.garrote.exists(thisUnit) and garroteRemain <= 10 and (enemyTable5[i].ttd - garroteRemain) > 2 then
                    if cast.pool.garrote() then return true end
                    if cast.garrote(thisUnit) then return true end
                end
            end
        end
        -- # Subterfuge + Shrouded Suffocation: Apply early Rupture that will be refreshed for pandemic.
        -- actions.stealthed+=/rupture,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&!dot.rupture.ticking&variable.single_target 
        if talent.subterfuge and trait.shroudedSuffocation.active and not debuff.rupture.exists("target") and #enemies.yards30 == 1 then
            if cast.rupture("target") then return true end
        end
        -- # Subterfuge w/ Shrouded Suffocation: Reapply for bonus CP and extended snapshot duration
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&target.time_to_die>remains&combo_points.deficit>1
        if talent.subterfuge and trait.shroudedSuffocation.active and comboDeficit > 1 then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if enemyTable5[i].ttd > debuff.garrote.remain(thisUnit) then
                    if cast.pool.garrote() then return true end
                    if cast.garrote(thisUnit) then return true end
                end
            end
        end
        -- actions.stealthed+=/garrote,if=talent.subterfuge.enabled&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&prev_gcd.1.rupture&dot.rupture.remains>5+4*cp_max_spend
        if mode.exsang == 1 and talent.subterfuge and talent.exsanguinate and cd.exsanguinate.remain() < 1 and cast.last.rupture(1) and debuff.rupture.remain("target") > 17.5 then
            if cast.pool.garrote() then return true end
            if cast.garrote("target") then return true end
        end
    end
-----------------
--- Rotations ---
-----------------
    -- Pause
    if IsMounted() or IsFlying() or pause() or mode.rotation==4 then
        return true
    else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if actionList_Extra() then return true end

        if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
            if actionList_PreCombat() then return true end
        end -- End Out of Combat Rotation
        if actionList_Opener() then return true end
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
        if (inCombat or (not isChecked("Disable Auto Combat") and (cast.last.vanish(1) or (validTarget and targetDistance < 5)))) and opener == true then
            if cast.last.vanish(1) then StopAttack() end
            if actionList_Defensive() then return true end
            if actionList_Interrupts() then return true end
            --pre mfd
            if stealth and comboDeficit > 2 and talent.markedForDeath and validTarget and targetDistance < 5 then
                if cast.markedForDeath("target") then
                    combo = comboMax
                    comboDeficit = 0
                end
            end
            --tricks
            if tricksUnit ~= nil and validTarget and targetDistance < 5 then
                cast.tricksOfTheTrade(tricksUnit)
            end
            -- # Restealth if possible (no vulnerable enemies in combat)
            -- actions=stealth
            if IsUsableSpell(spell.stealth) and not cast.last.vanish() then
                cast.stealth("player")
            end
            -- actions+=/call_action_list,name=stealthed,if=stealthed.rogue
            if stealthedRogue then
                if actionList_Stealthed() then return true end
            end
            --start aa
            if validTarget and not stealthedRogue and targetDistance < 5 and not IsCurrentSpell(6603) then
                StartAttack("target")
            end
            -- actions+=/call_action_list,name=cds
            if validTarget then
                if actionList_Cooldowns() then return true end
            end
            -- actions+=/call_action_list,name=dot
            if actionList_Dot() then return true end
            -- actions+=/call_action_list,name=direct
            if actionList_Direct() then return true end
            -- actions+=/arcane_torrent,if=energy.deficit>=15+variable.energy_regen_combined
            -- actions+=/arcane_pulse
            -- actions+=/lights_judgment
            if useCDs() and isChecked("Racial") and targetDistance < 5 then
                if race == "BloodElf" and energyDeficit >= (15 + energyRegenCombined) then
                    if cast.racial("player") then return true end
                elseif race == "Nightborne" then
                    if cast.racial("player") then return true end
                elseif race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation 
local id = 259 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
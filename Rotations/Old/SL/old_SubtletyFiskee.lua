local rotationName = "Fiskee - 8.1"
local opener = true
local resetButton
local dotBlacklist = "135824|139057|129359|129448|134503|137458|139185|120651"
local stunSpellList = "274400|274383|257756|276292|268273|256897|272542|272888|269266|258317|258864|259711|258917|264038|253239|269931|270084|270482|270506|270507|267433|267354|268702|268846|268865|258908|264574|272659|272655|267237|265568|277567|265540"
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.nightblade },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.shurikenStorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shadowstrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.stealth}
    };
    CreateButton("Rotation",1,0)
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.shadowBlades },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.shadowBlades },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.shadowBlades },
        [4] = { mode = "Lust", value = 4 , overlay = "Cooldowns With Bloodlust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.shadowBlades }
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
    AoeModes = {
        [1] = { mode = "Std", value = 1 , overlay = "Standard AoE Rotation", tip = "Standard AoE Rotation.", highlight = 1, icon = br.player.spell.nightblade },
        [2] = { mode = "Prio", value = 2 , overlay = "Priority Target AoE Rotation", tip = "Priority Target AoE Rotation.", highlight = 1, icon = br.player.spell.eviscerate }
    };
    CreateButton("Aoe",5,0)
    SDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Shadow Dance", tip = "Using Shadow Dance.", highlight = 1, icon = br.player.spell.shadowDance },
        [2] = { mode = "Off", value = 2 , overlay = "Shadow Dance Disabled", tip = "Shadow Dance Disabled.", highlight = 0, icon = br.player.spell.shadowDance }
    };
    CreateButton("SD",6,0)
    SoDModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Symbols of Death", tip = "Using Symbols of Death.", highlight = 1, icon = br.player.spell.symbolsOfDeath },
        [2] = { mode = "Off", value = 2 , overlay = "Symbols of Death Disabled", tip = "Symbols of Death Disabled.", highlight = 0, icon = br.player.spell.symbolsOfDeath }
    };
    CreateButton("SoD",7,0)
    STModes = {
        [1] = { mode = "On", value = 1 , overlay = "Use Secret Technique", tip = "Using Secret Technique.", highlight = 1, icon = br.player.spell.secretTechnique },
        [2] = { mode = "Off", value = 2 , overlay = "Secret Technique Disabled", tip = "Secret Technique Disabled.", highlight = 0, icon = br.player.spell.secretTechnique }
    };
    CreateButton("ST",8,0)
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
            br.ui:createDropdown(section, "Auto Stealth", {"|cff00FF00Always", "|cffFF000020 Yards"},  1, "Auto stealth mode.")
            br.ui:createDropdown(section, "Auto Tricks", {"|cff00FF00Focus", "|cffFF0000Tank"},  1, "Tricks of the Trade target." )
            br.ui:createCheckbox(section, "Auto Target", "|cffFFFFFF Will auto change to a new target, if current target is dead.")
            br.ui:createCheckbox(section, "Disable Auto Combat", "|cffFFFFFF Will not auto attack out of stealth.")
            br.ui:createCheckbox(section, "Dot Blacklist", "|cffFFFFFF Check to ignore certain units when multidotting.")
            br.ui:createCheckbox(section, "Auto Nightblade HP Limit", "|cffFFFFFF Will try to calculate if we should nightblade units, based on their HP")
            br.ui:createSpinnerWithout(section,  "Multidot Limit",  3,  0,  8,  1,  "|cffFFFFFF Max units to dot with nightblade.")
            br.ui:createCheckbox(section, "Ignore Blacklist for SS", "|cffFFFFFF Ignore blacklist for Shrukien Storm usage.")
            br.ui:createSpinner(section,  "Save SD Charges for CDs",  0.75,  0,  1,  0.05,  "|cffFFFFFF Shadow Dance charges to save for CDs. (Use toggle to disable SD for saving all)")
            br.ui:createDropdownWithout(section, "MfD Target", {"|cff00FF00Lowest TTD", "|cffFF0000Always Target"},  1, "MfD Target.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Racial", "|cffFFFFFF Will use Racial")
            br.ui:createCheckbox(section, "Trinkets", "|cffFFFFFF Will use Trinkets")
            br.ui:createDropdown(section, "Potion", {"Agility", "Bursting Blood"}, 1, "|cffFFFFFFPotion to use")
            br.ui:createCheckbox(section, "Vanish", "|cffFFFFFF Will use Vanish")
            br.ui:createCheckbox(section, "Shadow Blades", "|cffFFFFFF Will use Shadow Blades")
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
            br.ui:createCheckbox(section, "Kidney Shot/Cheap Shot")
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
    br.player.ui.mode.aoe = br.data.settings[br.selectedSpec].toggles["Aoe"]
    br.player.ui.mode.sd = br.data.settings[br.selectedSpec].toggles["SD"]
    br.player.ui.mode.sod = br.data.settings[br.selectedSpec].toggles["SoD"]
    br.player.ui.mode.st = br.data.settings[br.selectedSpec].toggles["ST"]
    if not UnitAffectingCombat("player") then
        if not br.player.talent.secretTechnique then
            buttonST:Hide()
        else
            buttonST:Show()
        end
    end
--------------
--- Locals ---
--------------
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local combatTime                                    = getCombatTime()
    local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
    local cd                                            = br.player.cd
    local cdUsage                                       = useCDs()
    local charges                                       = br.player.charges
    local debuff                                        = br.player.debuff
    local enemies                                       = br.player.enemies
    local energy, energyDeficit, energyRegen            = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
    local falling, swimming, flying                     = getFallTime(), IsSwimming(), IsFlying()
    local gcd                                           = br.player.gcd
    local gcdMax                                        = br.player.gcdMax
    local has                                           = br.player.has
    local healPot                                       = getHealthPot()
    local inCombat                                      = br.player.inCombat
    local level                                         = br.player.level
    local mode                                          = br.player.ui.mode
    local moving                                        = isMoving("player") ~= false or br.player.moving
    local php                                           = br.player.health
    local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local spell                                         = br.player.spell
    local stealth                                       = br.player.buff.stealth.exists()
    local stealthedRogue                                = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.2 or br.player.cast.last.vanish(1)
    local stealthedAll                                  = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.2 or br.player.cast.last.vanish(1) or br.player.buff.shadowmeld.exists() or br.player.buff.shadowDance.exists() or br.player.cast.last.shadowDance(1)
    local talent                                        = br.player.talent
    local thp                                           = getHP("target")
    local tickTime                                      = 2 / (1 + (GetHaste()/100))
    local trait                                         = br.player.traits
    local units                                         = br.player.units
    local use                                           = br.player.use
    local validTarget                                   = isValidUnit("target")

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

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
        if isChecked("Auto Nightblade HP Limit") and ttd(unit) == 999 and not UnitIsPlayer(unit) and not isDummy(unit) then
            local hpLimit = 0
            if #br.friend == 1 then
                if UnitHealth(unit) > UnitHealthMax("player") * 0.40 then
                    return true
                end
                return false
            end
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                local thisHP = UnitHealthMax(thisUnit)
                local thisRole = UnitGroupRolesAssigned(thisUnit)
                if not UnitIsDeadOrGhost(thisUnit) and getDistance(unit, thisUnit) < 40 then
                    if thisRole == "TANK" then hpLimit = hpLimit + (thisHP * 0.15) end
                    if (thisRole == "DAMAGER" or thisRole == "NONE") then hpLimit = hpLimit + (thisHP * 0.3) end
                end
            end
            if UnitHealth(unit) > hpLimit then return true end
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

    local enemyTable30 = { }
    local enemyTable10 = { }
    local enemyTable5 = { }
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
                enemyUnit.facing = getFacing("player",thisUnit)
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
                local hpNorm = (5-1)/(highestHP-lowestHP)*(enemyTable30[i].hpabs-highestHP)+5 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if enemyTable30[i].facing then enemyScore = enemyScore + 30 end
                if enemyTable30[i].ttd > 1.5 then enemyScore = enemyScore + 10 end
                if enemyTable30[i].distance <= 5 then enemyScore = enemyScore + 30 end
                local raidTarget = GetRaidTargetIndex(enemyTable30[i].unit)
                if raidTarget ~= nil then 
                    enemyScore = enemyScore + raidTarget * 3
                    if raidTarget == 8 then enemyScore = enemyScore + 5 end
                end
                if UnitBuffID(enemyTable30[i].unit, 277242) then enemyScore = enemyScore + 50 end
                enemyTable30[i].enemyScore = enemyScore
            end
            table.sort(enemyTable30, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        for i = 1, #enemyTable30 do
            local thisUnit = enemyTable30[i]
            if thisUnit.distance <= 10 then
                tinsert(enemyTable10, thisUnit)
                if thisUnit.distance <= 5 then
                    tinsert(enemyTable5, thisUnit)
                end
            end
        end
        if #enemyTable5 > 1 then
            table.sort(enemyTable5, function(x)
                if GetUnitIsUnit(x.unit, "target") then
                    return true
                else
                    return false
                end
            end)
        end
        if isChecked("Auto Target") and inCombat and #enemyTable30 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable30[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable30[1].unit)
        end
    end
    --Just nil fixes
    if enemyTable30.lowestTTD == nil then enemyTable30.lowestTTD = 999 end

    --Variables
    local dSEnabled, stEnabled, subterfugeActive, sRogue, darkShadowEnabled, nsEnabled, tfdActive, vEnabled, mosEnabled, sfEnabled, aEnabled
    if talent.deeperStratagem then dSEnabled = 1 else dSEnabled = 0 end
    if talent.darkShadow then darkShadowEnabled = 1 else darkShadowEnabled = 0 end
    if talent.nightstalker then nsEnabled = 1 else nsEnabled = 0 end
    if talent.secretTechnique then stEnabled = 1 else stEnabled = 0 end
    if talent.vigor then vEnabled = 1 else vEnabled = 0 end
    if talent.masterOfShadows then mosEnabled = 1 else mosEnabled = 0 end
    if talent.shadowFocus then sfEnabled = 1 else sfEnabled = 0 end
    if talent.aEnabled then aEnabled = 1 else aEnabled = 0 end
    if talent.subterfuge then subterfugeActive = 1 else subterfugeActive = 0 end
    if trait.theFirstDance.active then tfdActive = 1 else tfdActive = 0 end
    if stealthedAll == true then sRogue = 1 else sRogue = 0 end
    local enemies10 = #enemyTable10
    local nbRemain = debuff.nightblade.remain("target")
    local ssThd = 0
    if enemies10 >= 3 then ssThd = 1 end

    -- # Only change rotation if we have priority_rotation set and multiple targets up.
    -- actions+=/variable,name=use_priority_rotation,value=priority_rotation&spell_targets.shuriken_storm>=2
    local priorityRotation = false
    if mode.aoe == 2 and enemies10 >= 2 then priorityRotation = true end

    if isChecked("Ignore Blacklist for SS") then
        enemies10 = #enemies.get(10)
    end

    local targetDistance = getDistance("target")

--------------------
--- Action Lists ---
--------------------
    local function actionList_Extra()
        if not inCombat then
            -- actions.precombat+=/stealth
            if isChecked("Auto Stealth") and IsUsableSpell(GetSpellInfo(spell.stealth)) and not cast.last.vanish() and not IsResting() then
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
            [120651]=true, -- Explosive
            [141851]=true -- Infested
        }
        if GetObjectExists("target") and burnUnits[GetObjectID("target")] ~= nil then
            if combo >= 4 then
                if cast.eviscerate("target") then return true end
            end
        end
    end
    local function actionList_Defensive()
        if useDefensive() then
            if isChecked("Auto Defensive Unavoidables") then
                --Powder Shot (2nd boss freehold)
                local bossID = GetObjectID("boss1")
                if bossID == 126848 and isCastingSpell(256979, "target") and GetUnitIsUnit("player", UnitTarget("target")) then
                    if talent.elusiveness then
                        if cast.feint() then return true end
                    elseif getOptionValue("Evasion Unavoidables HP Limit") >= php then
                        if cast.evasion() then return true end
                    end
                end
                --Azerite Powder Shot (1st boss freehold)
                if bossID == 126832 and isCastingSpell(256106, "boss1") and getFacing("boss1", "player") then
                    if cast.feint() then return true end
                end
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
            if isChecked("Health Pot / Healthstone") and (use.able.healthstone() or canUseItem(healPot))
                and php <= getOptionValue("Health Pot / Healthstone") and inCombat and (hasHealthPot() or has.healthstone())
            then
                if use.able.healthstone() then
                    use.healthstone()
                elseif canUseItem(healPot) then
                    useItem(healPot)
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
        if useInterrupts() and not stealthedAll then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = getDistance(thisUnit)
                if canInterrupt(thisUnit,getOptionValue("Interrupt %")) then
                    if isChecked("Kick") and distance < 5 then
                        if cast.kick(thisUnit) then return end
                    end
                    if cd.kick.remain() ~= 0 then
                        if isChecked("Kidney Shot/Cheap Shot") then
                            if cast.cheapShot(thisUnit) then return true end
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
                        if cast.cheapShot(thisUnit) then return true end
                        if cast.kidneyShot(thisUnit) then return true end
                    end
                end
            end
        end
    end

    local function actionList_Opener()
        opener = true
    end

    local function actionList_PreCombat()
        -- actions.precombat+=/potion
        -- actions.precombat+=/marked_for_death,precombat_seconds=5,if=raid_event.adds.in>40
    end

    local function actionList_CooldownsOGCD()
        -- # Use Dance off-gcd before the first Shuriken Storm from Tornado comes in.
        -- actions.cds+=/shadow_dance,use_off_gcd=1,if=!buff.shadow_dance.up&buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if mode.sd == 1 and cdUsage and not buff.shadowDance.exists() and buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5 then
            if cast.shadowDance("player") then return true end
        end
        -- # (Unless already up because we took Shadow Focus) use Symbols off-gcd before the first Shuriken Storm from Tornado comes in.
        -- actions.cds+=/symbols_of_death,use_off_gcd=1,if=buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if mode.sod == 1 and buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5 then
            if cast.symbolsOfDeath("player") then return true end
        end
    end

    local function actionList_Cooldowns()
        -- actions.cds=potion,if=buff.bloodlust.react|buff.symbols_of_death.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=10)
        if cdUsage and ttd("target") > 15 and isChecked("Potion") and (hasBloodLust() or (buff.symbolsOfDeath.exists() and (buff.shadowBlades.exists() or cd.shadowBlades.remain() <= 10))) and ttd("target") > getOptionValue("CDs TTD Limit") then
            if getOptionValue("Potion") == 1 and ttd("target") > 15 and use.able.battlePotionOfAgility() and not buff.battlePotionOfAgility.exists() then
                use.battlePotionOfAgility()
                return true
            elseif getOptionValue("Potion") == 2 and ttd("target") > getOptionValue("CDs TTD Limit") and use.able.potionOfBurstingBlood() and not buff.potionOfBurstingBlood.exists() then
                use.potionOfBurstingBlood()
                return true
            end
        end
        -- actions.cds+=/use_item,name=galecallers_boon,if=buff.symbols_of_death.up|target.time_to_die<20
        if cdUsage and isChecked("Trinkets") and (buff.symbolsOfDeath.exists() or not isChecked("Symbols of Death")) and ttd("target") > getOptionValue("CDs TTD Limit") then
            if canUseItem(13) and not (hasEquiped(140808, 13) or hasEquiped(151190, 13)) then
                useItem(13)
            end
            if canUseItem(14) and not (hasEquiped(140808, 14) or hasEquiped(151190, 14)) then
                useItem(14)
            end
        end
        -- actions.cds+=/blood_fury,if=buff.symbols_of_death.up
        -- actions.cds+=/berserking,if=buff.symbols_of_death.up
        -- actions.cds+=/fireblood,if=buff.symbols_of_death.up
        -- actions.cds+=/ancestral_call,if=buff.symbols_of_death.up
        if cdUsage and isChecked("Racial") and buff.symbolsOfDeath.exists() and ttd("target") > getOptionValue("CDs TTD Limit") then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                if cast.racial("player") then return true end
            end
        end
        -- # Use Symbols on cooldown (after first Nightblade) unless we are going to pop Tornado and do not have Shadow Focus.
        -- actions.cds+=/symbols_of_death,if=dot.nightblade.ticking&(!talent.shuriken_tornado.enabled|talent.shadow_focus.enabled|spell_targets.shuriken_storm<3|!cooldown.shuriken_tornado.up)
        if mode.sod == 1 and (debuff.nightblade.exists("target") or not shallWeDot("target")) and (not talent.shurikenTornado or talent.shadowFocus or enemies10 < 3 or not cd.shurikenTornado.exists()) and ttd("target") > getOptionValue("CDs TTD Limit") then
            if cast.symbolsOfDeath("player") then return true end
        end
        -- # If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or not stealthed without any CP.
        -- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.all&combo_points.deficit>=cp_max_spend)
        if getOptionValue("MfD Target") == 1 then
            if #enemyTable30 > 1 and (enemyTable30.lowestTTD < comboDeficit or (not stealthedAll and comboDeficit >= comboMax)) then
                if cast.markedForDeath(enemyTable30.lowestTTDUnit) then return true end
            end
        else
            if #enemyTable30 > 1 and (ttd("target") < comboDeficit or (not stealthedAll and comboDeficit >= comboMax)) then
                if cast.markedForDeath("target") then return true end
            end
        end
        -- # If no adds will die within the next 30s, use MfD on boss without any CP and no stealth.
        -- actions.cds+=/marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&!stealthed.all&combo_points.deficit>=cp_max_spend
        if #enemyTable30 == 1 and comboDeficit >= comboMax and not stealthedAll then
            if cast.markedForDeath("target") then return true end
        end
        -- actions.cds+=/shadow_blades,if=combo_points.deficit>=2+stealthed.all
        if cdUsage and comboDeficit >= (2 + sRogue) and isChecked("Shadow Blades") and ttd("target") > getOptionValue("CDs TTD Limit") then
            if cast.shadowBlades("player") then return true end
        end
        -- # At 3+ without Shadow Focus use Tornado with SoD and Dance ready. We will pop those before the first storm comes in.
        -- actions.cds+=/shuriken_tornado,if=spell_targets>=3&!talent.shadow_focus.enabled&dot.nightblade.ticking&!stealthed.all&cooldown.symbols_of_death.up&cooldown.shadow_dance.charges>=1
        if enemies10 >= 3 and not talent.shadowFocus and (debuff.nightblade.exists("target") or not shallWeDot("target")) and not stealthedAll and cd.symbolsOfDeath.exists() and charges.shadowDance.frac() >= 1 and ttd("target") > getOptionValue("CDs TTD Limit") then
            if cast.shurikenTornado("player") then return true end
        end
        -- # At 3+ with Shadow Focus use Tornado with SoD already up.
        -- actions.cds+=/shuriken_tornado,if=spell_targets>=3&talent.shadow_focus.enabled&dot.nightblade.ticking&buff.symbols_of_death.up
        if enemies10 >= 3 and talent.shadowFocus and (debuff.nightblade.exists("target") or not shallWeDot("target")) and buff.symbolsOfDeath.exists() and ttd("target") > getOptionValue("CDs TTD Limit") then
            if cast.shurikenTornado("player") then return true end
        end
        -- actions.cds+=/shadow_dance,if=!buff.shadow_dance.up&target.time_to_die<=5+talent.subterfuge.enabled&!raid_event.adds.up
        if mode.sd == 1 and cdUsage and not buff.shadowDance.exists() and ttd("target") <= (5 + subterfugeActive) and #enemyTable30 == 1 and ttd("target") > getOptionValue("CDs TTD Limit") then
            if cast.shadowDance("player") then return true end
        end
    end

    local function actionList_Finishers()
        -- # Eviscerate highest priority at 2+ targets with Shadow Focus (5+ with Secret Technique in addition) and Night's Vengeance up.
        -- actions.finish=eviscerate,if=talent.shadow_focus.enabled&buff.nights_vengeance.up&spell_targets.shuriken_storm>=2+3*talent.secret_technique.enabled
        if talent.shadowFocus and buff.nightsVengeance.exists() and enemies10 >= (2 + 3 * stEnabled) then
            if cast.eviscerate("target") then return true end
        end
        -- # Keep up Nightblade if it is about to run out. Do not use NB during Dance, if talented into Dark Shadow.
        -- actions.finish+=/nightblade,if=(!talent.dark_shadow.enabled|!buff.shadow_dance.up)&target.time_to_die-remains>6&remains<tick_time*2
        if (not talent.darkShadow or not buff.shadowDance.exists()) and (ttd("target") - nbRemain) > 6 and nbRemain < 4 and shallWeDot("target") then
            if cast.nightblade("target") then return true end
        end
        -- # Multidotting outside Dance on targets that will live for the duration of Nightblade, refresh during pandemic. Multidot as long as 2+ targets do not have Nightblade up with Replicating Shadows (unless you have Night's Vengeance too).
        -- actions.finish+=/nightblade,cycle_targets=1,if=!variable.use_priority_rotation&spell_targets.shuriken_storm>=2&(azerite.nights_vengeance.enabled|!azerite.replicating_shadows.enabled|spell_targets.shuriken_storm-active_dot.nightblade>=2)&!buff.shadow_dance.up&target.time_to_die>=(5+(2*combo_points))&refreshable
        local nbCount = debuff.nightblade.count()
        if not priorityRotation and enemies10 >= 2 and (trait.nightsVengeance.active or not trait.replicatingShadows.active or (enemies10 - nbCount) >= 2) and not buff.shadowDance.exists() and nbCount <= getOptionValue("Multidot Limit") then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if ttd(thisUnit) >= (5 + 2 * combo) and debuff.nightblade.refresh(thisUnit) and shallWeDot(thisUnit) then
                    if cast.nightblade(thisUnit) then return true end
                end
            end
        end
        -- # Refresh Nightblade early if it will expire during Symbols. Do that refresh if SoD gets ready in the next 5s.
        -- actions.finish+=/nightblade,if=remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
        if mode.sod == 1 and cdUsage and nbRemain < (cd.symbolsOfDeath.remain() + 10) and cd.symbolsOfDeath.remain() <= 5 and (ttd("target") - nbRemain) > (cd.symbolsOfDeath.remain() + 5) and shallWeDot("target") then
            if cast.nightblade("target") then return true end
        end
        -- # Secret Technique during Symbols. With Dark Shadow only during Shadow Dance (until threshold in next line).
        -- actions.finish+=/secret_technique,if=buff.symbols_of_death.up&(!talent.dark_shadow.enabled|buff.shadow_dance.up)
        if mode.st == 1 and cdUsage and buff.symbolsOfDeath.exists() and (not talent.darkShadow or buff.shadowDance.exists()) then
            if cast.secretTechnique("target") then return true end
        end
        -- # With enough targets always use SecTec on CD.
        -- actions.finish+=/secret_technique,if=spell_targets.shuriken_storm>=2+talent.dark_shadow.enabled+talent.nightstalker.enabled
        if mode.st == 1 and enemies10 >= (2 + darkShadowEnabled + nsEnabled) then
            if cast.secretTechnique("target") then return true end
        end
        -- actions.finish+=/eviscerate
        if cast.eviscerate("target") then return true end
        -- Sinister Strike
        if level < 40 then
            if cast.sinisterStrike("target") then return true end
        end
    end

    local function actionList_StealthCD()
        -- # Helper Variable
        -- actions.stealth_cds=variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=1.75
        local shdThreshold = false
        if charges.shadowDance.frac() >= 1.75 then
            shdThreshold = true
        end
        -- # Vanish unless we are about to cap on Dance charges. Only when Find Weakness is about to run out.
        -- actions.stealth_cds+=/vanish,if=!variable.shd_threshold&debuff.find_weakness.remains<1&combo_points.deficit>1
        if not shdThreshold and cdUsage and comboDeficit > 1 and targetDistance < 5 and isChecked("Vanish") and ttd("target") > getOptionValue("CDs TTD Limit") and debuff.findWeakness.remain("target") < 1 then
            if cast.vanish("player") then return true end
        end
        -- # Pool for Shadowmeld + Shadowstrike unless we are about to cap on Dance charges. Only when Find Weakness is about to run out.
        -- actions.stealth_cds+=/pool_resource,for_next=1,extra_amount=40
        -- actions.stealth_cds+=/shadowmeld,if=energy>=40&energy.deficit>=10&!variable.shd_threshold&debuff.find_weakness.remains<1&combo_points.deficit>1
        -- # With Dark Shadow only Dance when Nightblade will stay up. Use during Symbols or above threshold. Only before finishers if we have amp talents and priority rotation.
        -- actions.stealth_cds+=/shadow_dance,if=(!talent.dark_shadow.enabled|dot.nightblade.remains>=5+talent.subterfuge.enabled)&(!talent.nightstalker.enabled&!talent.dark_shadow.enabled|!variable.use_priority_rotation|combo_points.deficit<=1+2*azerite.the_first_dance.enabled)&(variable.shd_threshold|buff.symbols_of_death.remains>=1.2|spell_targets.shuriken_storm>=4&cooldown.symbols_of_death.remains>10)
        if mode.sd == 1 and ttd("target") > 3 and (cdUsage or (isChecked("Save SD Charges for CDs") and charges.shadowDance.frac() >= (getOptionValue("Save SD Charges for CDs") + 1)) or not isChecked("Save SD Charges for CDs")) and (not talent.darkShadow or nbRemain >= 5 + subterfugeActive) and (not talent.nightstalker or not talent.darkShadow or not priorityRotation or comboDeficit <= (1 + 2 * tfdActive)) and (shdThreshold or buff.symbolsOfDeath.remain() >= 1.2 or (enemies10 >= 4 and cd.symbolsOfDeath.remain() > 10)) then
            if cast.shadowDance("player") then return true end
        end
        -- actions.stealth_cds+=/shadow_dance,if=target.time_to_die<cooldown.symbols_of_death.remains&!raid_event.adds.up
        if mode.sd == 1 and cdUsage and ttd("target") < cd.symbolsOfDeath.remain() and ttd("target") > 3 and #enemyTable30 == 1 then
            if cast.shadowDance("player") then return true end
        end
    end

    local function actionList_Stealthed()
        -- # If stealth is up, we really want to use Shadowstrike to benefits from the passive bonus, even if we are at max cp (from the precombat MfD).
        -- actions.stealthed=shadowstrike,if=buff.stealth.up
        if stealth and targetDistance < 5 then
            if cast.shadowstrike("target") then return true end
        end
        -- # Finish at 4+ CP without DS, 5+ with DS, and 6 with DS after Vanish or The First Dance and no Dark Shadow + no Subterfuge
        -- actions.stealthed+=/call_action_list,name=finish,if=combo_points.deficit<=1-(talent.deeper_stratagem.enabled&(buff.vanish.up|azerite.the_first_dance.enabled&!talent.dark_shadow.enabled&!talent.subterfuge.enabled))
        local finishThd = 0
        if dSEnabled and ((buff.vanish.exists() or cast.last.vanish(1)) or (trait.theFirstDance.active and not talent.darkShadow and not talent.subterfuge)) then
            finishThd = 1
        end
        if comboDeficit <= (1 - finishThd) then
            if actionList_Finishers() then return true end
        end
        -- # At 2 targets with Secret Technique keep up Find Weakness by cycling Shadowstrike.
        -- actions.stealthed+=/shadowstrike,cycle_targets=1,if=talent.secret_technique.enabled&talent.find_weakness.enabled&debuff.find_weakness.remains<1&spell_targets.shuriken_storm=2&target.time_to_die-remains>6
        if talent.secretTechnique and talent.findWeakness and enemies10 == 2 then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if debuff.findWeakness.remain(thisUnit) < 1 and ttd(thisUnit) > 6 then
                    if cast.shadowstrike(thisUnit) then return true end
                end
            end
        end
        -- # Without Deeper Stratagem and 3 Ranks of Blade in the Shadows it is worth using Shadowstrike on 3 targets.
        -- actions.stealthed+=/shadowstrike,if=!talent.deeper_stratagem.enabled&azerite.blade_in_the_shadows.rank=3&spell_targets.shuriken_storm=3
        if not talent.deeperStratagem and trait.bladeInTheShadows.rank == 3 and enemies10 == 3 and targetDistance < 5 then
            if cast.shadowstrike("target") then return true end
        end
        -- actions.stealthed+=/shuriken_storm,if=spell_targets>=3
        if enemies10 >= 3 then
            if cast.shurikenStorm("player") then return true end
        end
        -- actions.stealthed+=/shadowstrike
        if targetDistance < 5 then
            if cast.shadowstrike("target") then return true end
        end
    end
    --Builders
    local function actionList_Builders()
        -- actions.build=shuriken_storm,if=spell_targets>=2
        if enemies10 >= 2 then
            if cast.shurikenStorm("player") then return true end
        end
        -- actions.build+=/gloomblade
        if cast.gloomblade("target") then return true end
        -- actions.build+=/backstab
        if cast.backstab("target") then return true end
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
            if IsUsableSpell(GetSpellInfo(spell.stealth)) and not cast.last.vanish(1) then
                cast.stealth("player")
            end
            --start aa
            if validTarget and not stealthedRogue and targetDistance < 5 and not IsCurrentSpell(6603) then
                StartAttack("target")
            end
            --
            if validTarget and ttd("target") > getOptionValue("CDs TTD Limit") and targetDistance < 5 then
                if actionList_CooldownsOGCD() then return true end
            end
            if gcd < getLatency() then
                -- # Check CDs at first
                -- actions+=/call_action_list,name=cds
                if validTarget and targetDistance < 5 then
                    if actionList_Cooldowns() then return true end
                end
                -- # Run fully switches to the Stealthed Rotation (by doing so, it forces pooling if nothing is available).
                -- actions+=/run_action_list,name=stealthed,if=stealthed.all
                if stealthedAll then
                    if actionList_Stealthed() then return true end
                end
                -- # Apply Nightblade at 2+ CP during the first 10 seconds, after that 4+ CP if it expires within the next GCD or is not up
                -- actions+=/nightblade,if=target.time_to_die>6&remains<gcd.max&combo_points>=4-(time<10)*2
                local cTime = 0
                if combatTime < 10 then
                    cTime = 1
                end
                if ttd("target") > 6 and nbRemain < gcdMax and combo >= 4 - cTime * 2 and shallWeDot("target") then
                    if cast.nightblade("target") then return true end
                end
                -- # Priority Rotation? Let's give a crap about energy for the stealth CDs (builder still respect it). Yup, it can be that simple.
                -- actions+=/call_action_list,name=stealth_cds,if=variable.use_priority_rotation
                if priorityRotation and validTarget and not stealthedAll and targetDistance < 5 then
                    if actionList_StealthCD() then return true end
                end
                -- # Used to define when to use stealth CDs or builders
                -- actions+=/variable,name=stealth_threshold,value=25+talent.vigor.enabled*35+talent.master_of_shadows.enabled*25+talent.shadow_focus.enabled*20+talent.alacrity.enabled*10+15*(spell_targets.shuriken_storm>=3)
                local stealthThd = 25 + vEnabled * 35 + mosEnabled * 25 + sfEnabled * 20 + aEnabled * 10 + 15 * ssThd
                -- # Consider using a Stealth CD when reaching the energy threshold and having space for at least 4 CP
                -- actions+=/call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&combo_points.deficit>=4
                if energyDeficit <= stealthThd and comboDeficit >= 4 and validTarget and not stealthedAll and targetDistance < 5 then
                    if actionList_StealthCD() then return true end
                end
                -- # With Dark Shadow, also use a Stealth CD when reaching the energy threshold and Secret Technique is ready. Only a gain up to 4 targets.
                -- actions+=/call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&talent.dark_shadow.enabled&talent.secret_technique.enabled&cooldown.secret_technique.up&spell_targets.shuriken_storm<=4
                if validTarget and not stealthedAll and energyDeficit <= stealthThd and talent.darkShadow and talent.secretTechnique and cd.secretTechnique.exists() and enemies10 <= 4 and targetDistance < 5 then
                    if actionList_StealthCD() then return true end
                end
                -- # Finish at 4+ without DS, 5+ with DS (outside stealth)
                -- actions+=/call_action_list,name=finish,if=combo_points.deficit<=1|target.time_to_die<=1&combo_points>=3
                if comboDeficit <= 1 or (ttd("target") <= 1 and combo >= 3) then
                    if actionList_Finishers() then return true end
                end
                -- # With DS also finish at 4+ against exactly 4 targets (outside stealth)
                -- actions+=/call_action_list,name=finish,if=spell_targets.shuriken_storm=4&combo_points>=4
                if enemies10 == 4 and combo >= 4 then
                    if actionList_Finishers() then return true end
                end
                -- # Use a builder when reaching the energy threshold
                -- actions+=/call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
                if energyDeficit <= stealthThd then
                    if actionList_Builders() then return true end
                end
                -- actions+=/arcane_torrent,if=energy.deficit>=15+variable.energy_regen_combined
                -- actions+=/arcane_pulse
                -- actions+=/lights_judgment
                if cdUsage and isChecked("Racial") and targetDistance < 5 then
                    if race == "BloodElf" and energyDeficit >= (15 + energyRegen) then
                        if cast.racial("player") then return true end
                    elseif race == "Nightborne" then
                        if cast.racial("player") then return true end
                    elseif race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then return true end
                    end
                end
            end
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation 
local id = 0 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
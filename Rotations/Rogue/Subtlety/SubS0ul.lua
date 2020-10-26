local rotationName = "SubS0ul - 9.0"
local opener = true
local resetButton
local dotBlacklist = "135824|139057|129359|129448|134503|137458|139185|120651"
local stunSpellList = "274400|274383|257756|276292|268273|256897|272542|272888|269266|258317|258864|259711|258917|264038|253239|269931|270084|270482|270506|270507|267433|267354|268702|268846|268865|258908|264574|272659|272655|267237|265568|277567|265540"
---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.shurikenStorm },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shadowstrike },
        [3] = { mode = "Off", value = 3 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.stealth}
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
        [1] = { mode = "Std", value = 1 , overlay = "Standard AoE Rotation", tip = "Standard AoE Rotation.", highlight = 1, icon = br.player.spell.rupture },
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
            br.ui:createDropdown(section, "Poison", {"Instant","Wound",}, 1, "Poison to apply")
            br.ui:createDropdown(section, "Auto Stealth", {"Always", "25 Yards"},  1, "Auto stealth mode.")
            br.ui:createDropdown(section, "Auto Tricks", {"Focus", "Tank"},  1, "Tricks of the Trade target." )
            br.ui:createCheckbox(section, "Auto Target", "Will auto change to a new target, if current target is dead.")
            br.ui:createCheckbox(section, "Disable Auto Combat", "Will not auto attack out of stealth.")
            br.ui:createCheckbox(section, "Dot Blacklist", "Check to ignore certain units when multidotting.")
            br.ui:createCheckbox(section, "Auto Rupture HP Limit", "Will try to calculate if we should rupture units, based on their HP")
            br.ui:createSpinnerWithout(section,  "Multidot Limit",  3,  0,  8,  1,  "Max units to dot with rupture.")
            br.ui:createSpinner(section, "Shuriken Toss out of range", 90,  1,  100,  5,  "Use Shuriken Toss out of range")
            br.ui:createCheckbox(section, "Ignore Blacklist for SS", "Ignore blacklist for Shrukien Storm usage.")
            br.ui:createSpinner(section,  "Save SD Charges for CDs",  0.75,  0,  1,  0.05,  "Shadow Dance charges to save for CDs. (Use toggle to disable SD for saving all)")
            br.ui:createDropdownWithout(section, "MfD Target", {"Lowest TTD", "Always Target"},  1, "MfD Target.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Racial", "Will use Racial")
            br.ui:createCheckbox(section, "Essences", "Will use Essences")
            br.ui:createSpinnerWithout(section,  "Reaping DMG",  10,  1,  50,  1,  "* 5k Put damage of your Reaping Flames")
            br.ui:createCheckbox(section, "Trinkets", "Will use Trinkets")
            br.ui:createDropdown(section, "Potion", {"Agility", "Unbridled Fury", "Focused Resolve"}, 3, "Potion with CDs")
            br.ui:createCheckbox(section, "Vanish", "Will use Vanish")
            br.ui:createCheckbox(section, "Shadow Blades", "Will use Shadow Blades")
            br.ui:createCheckbox(section, "Precombat", "Will use items/pots on pulltimer")
            br.ui:createSpinnerWithout(section,  "CDs TTD Limit",  5,  0,  20,  1,  "Time to die limit for using cooldowns.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createSpinner(section, "Health Pot / Healthstone",  25,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createCheckbox(section, "Cloak of Shadows")
            br.ui:createSpinner(section, "Crimson Vial",  40,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createSpinner(section, "Evasion",  50,  0,  100,  5,  "Health Percentage to use at.")
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "Health Percentage to use at.")
            br.ui:createCheckbox(section, "Auto Defensive Unavoidables", "Will use feint/evasion on certain unavoidable boss abilities")
            br.ui:createSpinnerWithout(section,  "Evasion Unavoidables HP Limit",  85,  0,  100,  5,  "Player HP to use evasion on unavoidables.")
            br.ui:createCheckbox(section, "Cloak Unavoidables", "Will cloak on unavoidables")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Kick")
            br.ui:createCheckbox(section, "Kidney Shot/Cheap Shot")
            br.ui:createCheckbox(section, "Blind")
            br.ui:createSpinnerWithout(section,  "Interrupt %",  0,  0,  95,  5,  "Remaining Cast Percentage to interrupt at.")
            br.ui:createCheckbox(section, "Stuns", "Auto stun mobs from whitelist")
            br.ui:createSpinnerWithout(section,  "Max CP For Stun",  3,  1,  6,  1,  " Maximum number of combo points to stun")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            br.ui:createDropdownWithout(section,  "Pause Mode", br.dropOptions.Toggle,  6)
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
    local buff                                = br.player.buff
    local talent                              = br.player.talent
    local trait                               = br.player.traits
    local essence                             = br.player.essence
    -- local runeforge                           = br.player.runeforge
    -- local conduit                             = br.player.conduit
    local cast                                = br.player.cast
    local php                                 = br.player.health
    local power, powmax, powgen               = br.player.power, br.player.powerMax, br.player.powerRegen
    local combo, comboDeficit, comboMax       = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
    local energy, energyDeficit, energyRegen  = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
    local cd                                  = br.player.cd
    local charges                             = br.player.charges
    local debuff                              = br.player.debuff
    local enemies                             = br.player.enemies
    local gcd                                 = br.player.gcd
    local gcdMax                              = br.player.gcdMax
    local has                                 = br.player.has
    local inCombat                            = br.player.inCombat
    local level                               = br.player.level
    local mode                                = br.player.ui.mode
    local race                                = br.player.race
    local racial                              = br.player.getRacial()
    local spell                               = br.player.spell
    local units                               = br.player.units
    local use                                 = br.player.use
    local stealth                             = br.player.buff.stealth.exists()
    local stealthedRogue                      = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.2 or br.player.cast.last.vanish(1)
    local stealthedAll                        = stealth or br.player.buff.vanish.exists() or br.player.buff.subterfuge.remain() > 0.2 or br.player.cast.last.vanish(1) or br.player.buff.shadowmeld.exists() or br.player.buff.shadowDance.exists() or br.player.cast.last.shadowDance(1)
    local combatTime                          = getCombatTime()
    local cdUsage                             = useCDs()
    local falling, swimming, flying           = getFallTime(), IsSwimming(), IsFlying()
    local healPot                             = getHealthPot()
    local moving                              = isMoving("player") ~= false or br.player.moving
    local pullTimer                           = br.DBM:getPulltimer()
    local thp                                 = getHP("target")
    local tickTime                            = 2 / (1 + (GetHaste()/100))
    local validTarget                         = isValidUnit("target")
    local inInstance                          = br.player.instance == "party" or br.player.instance == "scenario" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"
    local inRaid                              = br.player.instance == "raid" or br.player.instance == "pvp" or br.player.instance == "arena" or br.player.instance == "none"
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(25,"player", true) -- makes enemies.yards25nc
    enemies.get(30)

    if timersTable then
        wipe(timersTable)
    end

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
        if isChecked("Auto Rupture HP Limit") and ttd(unit) == 999 and not UnitIsPlayer(unit) and not isDummy(unit) then
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
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) and (mode.rotation ~= 2 or (mode.rotation == 2 and GetUnitIsUnit(thisUnit, "target"))) then
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
                local thisUnit = enemyTable30[i]
                local hpNorm = (10-1)/(highestHP-lowestHP)*(thisUnit.hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if thisUnit.ttd > 1.5 then enemyScore = enemyScore + 10 end
                if thisUnit.facing then enemyScore = enemyScore + 30 end
                if thisUnit.distance <= 5 then enemyScore = enemyScore + 30 end
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
            local sStormIgnore = {
                [120651]=true, -- Explosive
            }

            if thisUnit.distance <= 10 then
                if sStormIgnore[thisUnit.objectID] == nil and not isTotem(thisUnit.unit) then
                    tinsert(enemyTable10, thisUnit)
                end
                if thisUnit.distance <= 5 then
                    tinsert(enemyTable5, thisUnit)
                end
            end
        end
        -- if #enemyTable5 > 1 then
        --     table.sort(enemyTable5, function(x)
        --         if GetUnitIsUnit(x.unit, "target") then
        --             return true
        --         else
        --             return false
        --         end
        --     end)
        -- end
        if isChecked("Auto Target") and inCombat and #enemyTable30 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable30[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable30[1].unit)
        end
    end
    --Just nil fixes
    if enemyTable30.lowestTTD == nil then enemyTable30.lowestTTD = 999 end

    --Variables
    local dSEnabled, stEnabled, subterfugeActive, sRogue, darkShadowEnabled, nsEnabled, tfdActive, vEnabled, mosEnabled, sfEnabled, aEnabled, sndCondition
    if talent.deeperStratagem then dSEnabled = 1 else dSEnabled = 0 end
    if talent.darkShadow then darkShadowEnabled = 1 else darkShadowEnabled = 0 end
    if talent.nightstalker then nsEnabled = 1 else nsEnabled = 0 end
    if talent.secretTechnique then stEnabled = 1 else stEnabled = 0 end
    if talent.vigor then vEnabled = 1 else vEnabled = 0 end
    if talent.masterOfShadows then mosEnabled = 1 else mosEnabled = 0 end
    if talent.shadowFocus then sfEnabled = 1 else sfEnabled = 0 end
    if talent.aEnabled then aEnabled = 1 else aEnabled = 0 end
    if talent.subterfuge then subterfugeActive = 1 else subterfugeActive = 0 end
    if talent.gloomblade then gloombladeActive = 1 else gloombladeActive = 0 end
    if trait.theFirstDance.active then tfdActive = 1 else tfdActive = 0 end
    if trait.bladeInTheShadows.active then bitsActive = 1 else bitsActive = 0 end
    if stealthedAll == true then sRogue = 1 else sRogue = 0 end
    local enemies10 = #enemyTable10
    local ruptureRemain = debuff.rupture.remain("target")
    local ssThd = 0
    if enemies10 >= 4 then ssThd = 1 end

    -- # Used to determine whether cooldowns wait for SnD based on targets.
    -- variable,name=snd_condition,value=buff.slice_and_dice.up|spell_targets.shuriken_storm>=6
    if buff.sliceAndDice.exists() or enemies10 >= 6 then sndCondition = 1 else sndCondition = 0 end
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
            -- actions.precombat+=/apply_poison
            if isChecked("Poison") then
                if not moving and getOptionValue("Poison") == 1 and buff.instantPoison.remain() < 300 and not cast.last.instantPoison(1) then
                    if cast.instantPoison("player") then return true end
                end
                if not moving and getOptionValue("Poison") == 2 and buff.woundPoison.remain() < 300 and not cast.last.woundPoison(1) then
                    if cast.woundPoison("player") then return true end
                end
                if not moving and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison(1) then
                    if cast.cripplingPoison("player") then return true end
                end
            end
            -- actions.precombat+=/stealth
            if isChecked("Auto Stealth") and IsUsableSpell(GetSpellInfo(spell.stealth)) and not cast.last.vanish() and not IsResting() and
            (botSpell ~= spell.stealth or (botSpellTime == nil or GetTime() - botSpellTime > 0.1)) then
                if getOptionValue("Auto Stealth") == 1 then
                    if cast.stealth() then return end
                end
                if #enemies.yards25nc > 0 and getOptionValue("Auto Stealth") == 2 then
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
            if isChecked("Health Pot / Healthstone") and (use.able.healthstone() or canUseItem(169451)) and php <= getOptionValue("Health Pot / Healthstone") 
             and inCombat and (hasItem(169451) or has.healthstone()) then
                if use.able.healthstone() then
                    use.healthstone()
                elseif canUseItem(156634) then
                    useItem(156634)
                elseif canUseItem(169451) then
                    useItem(169451)
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
                    if cd.kick.remain() ~= 0 and distance < 5 then
                        if isChecked("Kidney Shot/Cheap Shot") then
                            if buff.shadowDance.exists() then
                                if cast.cheapShot(thisUnit) then return true end
                            end
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
                        if stealthedAll then
                            if cast.cheapShot(thisUnit) then return true end
                        end
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
        if isChecked("Precombat") and pullTimer <= 1.5 then
            if getOptionValue("Potion") == 1 and use.able.superiorBattlePotionOfAgility() and not buff.superiorBattlePotionOfAgility.exists() then
                use.superiorBattlePotionOfAgility()
                return true
            elseif getOptionValue("Potion") == 2 and use.able.potionOfUnbridledFury() and not buff.potionOfUnbridledFury.exists() then
                use.potionOfUnbridledFury()
                return true
            elseif getOptionValue("Potion") == 3 and use.able.potionOfFocusedResolve() and not buff.potionOfFocusedResolve.exists() then
                use.potionOfFocusedResolve() 
                return true
            end
        end
        -- actions.precombat+=/marked_for_death,precombat_seconds=15
        if isChecked("Precombat") and validTarget and pullTimer < 15 and stealth and comboDeficit > 2 and talent.markedForDeath and targetDistance < 25 then
            if cast.markedForDeath("target") then return true end
        end
        -- actions.precombat+=/Slice and Dice, if=precombat_seconds=1
        if isChecked("Precombat") and (pullTimer <= 1 or targetDistance < 10) and combo > 0 and buff.sliceAndDice.remain() < 6+(combo*3) then
            if cast.sliceAndDice() then return true end
        end
        -- -- actions.precombat+=/shadowBlades, if=runeforge.mark_of_the_master_assassin.equipped
        -- if isChecked("Precombat") and validTarget and cdUsage and targetDistance < 5 then -- and runeforge.markOfTheMasterAssassin.active()
        --     if cast.shadowBlades("player") then return true end
        -- end
    end

    local function actionList_CooldownsOGCD()
        -- Slice and dice for opener
        if enemies10 < 6 and ttd("target") > 6 and combo >= 2 and not buff.sliceAndDice.exists() and (combatTime < 6 and not cd.vanish.exists()) then
            if cast.sliceAndDice("player") then return true end
        end
        -- # Use Dance off-gcd before the first Shuriken Storm from Tornado comes in.
        -- actions.cds=shadow_dance,use_off_gcd=1,if=!buff.shadow_dance.up&buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if mode.sd == 1 and cdUsage and not buff.shadowDance.exists() and buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5 then
            if cast.shadowDance("player") then return true end
        end
        -- # (Unless already up because we took Shadow Focus) use Symbols off-gcd before the first Shuriken Storm from Tornado comes in.
        -- actions.cds+=/symbols_of_death,use_off_gcd=1,if=buff.shuriken_tornado.up&buff.shuriken_tornado.remains<=3.5
        if mode.sod == 1 and (buff.shurikenTornado.exists() and buff.shurikenTornado.remain() <= 3.5 or not talent.shurikenTornado) and ttd("target") > getOptionValue("CDs TTD Limit") and (combatTime > 1.5 or cd.vanish.exists()) then
            if cast.symbolsOfDeath("player") then return true end
        end
        -- actions.cds+=/shadow_blades,if=variable.snd_condition&combo_points.deficit>=2
        if cdUsage and sndCondition and not stealthedAll and comboDeficit >= 2 and isChecked("Shadow Blades") and ttd("target") > getOptionValue("CDs TTD Limit") and (combatTime > 1.5 or cd.vanish.exists()) then
            if cast.shadowBlades("player") then return true end
        end
    end

    local function actionList_Cooldowns()
---------------------------- SHADOWLANDS
        -- actions.cds+=/flagellation,if=variable.snd_condition&!stealthed.mantle"
        -- if sndCondition and not buff.masterAssassinsInitiative.exists() then
        --     if cast.flagellation("target") then return true end
        -- end
        -- actions.cds+=/flagellation_cleanse,if=debuff.flagellation.remains<2|debuff.flagellation.stack>=40
        --if debuff.flagellation.remain("target") < 2 or debuff.flagellation.stack() >= 40 then
        --     if cast.flagellation("target") then return true end
        -- end
        -- actions.cds+=/vanish,if=(runeforge.mark_of_the_master_assassin.equipped&combo_points.deficit<=3|runeforge.deathly_shadows.equipped&combo_points<1)&buff.symbols_of_death.up&buff.shadow_dance.up&master_assassin_remains=0&buff.deathly_shadows.down
        -- if (runeforge.markOfTheMasterAssassin.active and comboDeficit <= 3 or runeforge.deathlyShadows.active and combo < 1) and buff.symbolsOfDeath.exists() and buff.shadowDance.exists() and not buff.masterAssassin.exists() and not buff.deathlyShadows.exists() then
        --     if cast.vanish("player") then return true end
        -- end
---------------------------- SHADOWLANDS
        -- actions.cds+=/call_action_list,name=essences,if=!stealthed.all&variable.snd_condition|essence.breath_of_the_dying.major&time>=2
        if isChecked("Essences") and not IsMounted() and not stealthedAll and sndCondition or cast.able.reapingFlames() and (combatTime >= 2 or cd.vanish.exists())  then
            -- actions.essences=concentrated_flame,if=energy.time_to_max>1&!buff.symbols_of_death.up&(!dot.concentrated_flame_burn.ticking&!action.concentrated_flame.in_flight|full_recharge_time<gcd.max)
            if cast.able.concentratedFlame() and (energyDeficit/energyRegen) > 1 and not buff.symbolsOfDeath.exists() and (not debuff.concentratedFlame.exists(units.dyn5) and not cast.last.concentratedFlame() or charges.concentratedFlame.timeTillFull() < gcd) then
                if cast.concentratedFlame() then return true end
            end
            -- actions.essences+=/blood_of_the_enemy,if=!cooldown.shadow_blades.up&cooldown.symbols_of_death.up|fight_remains<=10
            if cast.able.bloodOfTheEnemy() and cd.shadowBlades.exists() and not cd.symbolsOfDeath.exists() or ttd("target") <= 10 then
                if cast.bloodOfTheEnemy("player") then return true end
            end
            -- actions.essences+=/guardian_of_azeroth
            if cast.able.guardianOfAzeroth() then
                if cast.guardianOfAzeroth("player") then return true end
            end
            -- actions.essences+=/the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10
            if cast.able.theUnboundForce() and (buff.recklessForce.exists() or buff.recklessForceCounter.stack() < 10)then
                if cast.theUnboundForce("target") then return true end
            end
            -- actions.essences+=/ripple_in_space
            if cast.able.rippleInSpace() then
                if cast.rippleInSpace() then return true end
            end
            -- actions.essences+=/worldvein_resonance,if=cooldown.symbols_of_death.remains<5|fight_remains<18
            if cast.able.worldveinResonance() and cd.symbolsOfDeath.remain < 5 or ttd("target") <= 18 then
                if cast.worldveinResonance("player") then return true end
            end
            -- actions.essences+=/memory_of_lucid_dreams,if=energy<40&buff.symbols_of_death.up
            if cast.able.memoryOfLucidDreams() and energy < 40 and buff.symbolsOfDeath.exists() then
                if cast.memoryOfLucidDreams("player") then return true end
            end
            -- Essence: Reaping Flames
            if cast.able.reapingFlames() then
                local reapingDamage = buff.reapingFlames.exists("player") and getValue("Reaping DMG") * 5000 * 2 or getValue("Reaping DMG") * 5000
                local reapingPercentage = 0
                local thisHP = 0
                local thisABSHP = 0
                local thisABSHPmax = 0
                local reapTarget, thisUnit, reap_execute, reap_hold, reap_fallback = false, false, false, false, false
                local mob_count = #enemies.yards30
                if mob_count > 10 then
                    mob_count = 10
                end

                if mob_count == 1 then
                    if ((br.player.essence.reapingFlames.rank >= 2 and getHP(enemies.yards30[1]) > 80) or getHP(enemies.yards30[1]) <= 20 or getTTD(enemies.yards30[1], 20) > 30) then
                        reapTarget = enemies.yards30[1]
                    end
                elseif mob_count > 1 then
                    for i = 1, mob_count do
                        thisUnit = enemies.yards30[i]
                        if getTTD(thisUnit) ~= 999 then
                            thisHP = getHP(thisUnit)
                            thisABSHP = UnitHealth(thisUnit)
                            thisABSHPmax = UnitHealthMax(thisUnit)
                            reapingPercentage = round2(reapingDamage / UnitHealthMax(thisUnit), 2)
                            if UnitHealth(thisUnit) <= reapingDamage or getTTD(thisUnit) < 2.5 or getTTD(thisUnit, reapingPercentage) < 2 then
                                reap_execute = thisUnit
                                break
                            elseif getTTD(thisUnit, reapingPercentage) < 29 or getTTD(thisUnit, 20) > 30 and (getTTD(thisUnit, reapingPercentage) < 44) then
                                reap_hold = true
                            elseif (thisHP > 80 or thisHP <= 20) or getTTD(thisUnit, 20) > 30 then
                                reap_fallback = thisUnit
                            end
                        end
                    end
                end

                if reap_execute then
                    reapTarget = reap_execute
                elseif not reap_hold and reap_fallback then
                    reapTarget = reap_fallback
                end

                if reapTarget ~= nil and not isExplosive(reapTarget) and getFacing("player",reapTarget) then
                    if cast.reapingFlames(reapTarget) then
                        return true
                    end
                end
            end
        end
        -- # Pool for Tornado pre-SoD with ShD ready when not running SF.
        -- actions.cds+=/pool_resource,for_next=1,if=!talent.shadow_focus.enabled
        if not talent.shadowFocus and cast.able.shurikenTornado() then
            if cast.pool.shurikenTornado() then return true end
        end
        -- # Use Tornado pre SoD when we have the energy whether from pooling without SF or just generally.
        -- actions.cds+=/shuriken_tornado,if=energy>=60&variable.snd_condition&cooldown.symbols_of_death.up&cooldown.shadow_dance.charges>=1
        if energy >= 60 and sndCondition and not cd.symbolsOfDeath.exists() and charges.shadowDance.frac() >= 1 then
            if cast.shurikenTornado("player") then return true end
        end
        -- actions.cds+=/serrated_bone_spike,cycle_targets=1,if=variable.snd_condition&!dot.serrated_bone_spike_dot.ticking|fight_remains<=5
        -- if sndCondition and not debuff.serratedBoneSpike.exists(enemyTable30.lowestTTDUnit) or ttd("target") <= 5 then
        --     if cast.serratedBoneSpike(enemyTable30.lowestTTDUnit) then return true end
        -- end
        -- # Use Symbols on cooldown (after first SnD) unless we are going to pop Tornado and do not have Shadow Focus. Low CP for The Rotten.
        -- actions.cds+=/symbols_of_death,if=variable.snd_condition&!cooldown.shadow_blades.up&(talent.enveloping_shadows.enabled|cooldown.shadow_dance.charges>=1)&(!talent.shuriken_tornado.enabled|talent.shadow_focus.enabled|cooldown.shuriken_tornado.remains>2)&(!runeforge.the_rotten.equipped|combo_points<=2)&(!essence.blood_of_the_enemy.major|cooldown.blood_of_the_enemy.remains>2)
        if mode.sod == 1 and sndCondition and cd.shadowBlades.exists() and (talent.envelopingShadows or charges.shadowDance.frac() >= 1) and 
         (not talent.shurikenTornado or talent.shadowFocus or cd.shurikenTornado.remain() > 2) and --and (not runeforge.theRotten.active or combo <= 2)
         (not essence.bloodOfTheEnemy.active or cd.bloodOfTheEnemy.remain() > 2) and ttd("target") > getOptionValue("CDs TTD Limit") then
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
        -- actions.cds+=/marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
        if #enemyTable30 == 1 and comboDeficit >= comboMax then
            if cast.markedForDeath("target") then return true end
        end
---------------------------- SHADOWLANDS
        -- actions.cds+=/echoing_reprimand,if=variable.snd_condition&combo_points.deficit>=3&spell_targets.shuriken_storm<=4
        -- if sndCondition and comboDeficit >= 3 and enemies10 <= 4 then
        --     if cast.echoingReprimand("target") then return true end
        -- end
        -- -- # With SF, if not already done, use Tornado with SoD up.
        -- -- actions.cds+=/shuriken_tornado,if=talent.shadow_focus.enabled&variable.snd_condition&buff.symbols_of_death.up
        -- if talent.shadowFocus and sndCondition and buff.symbolsOfDeath.exists() then
        --     if cast.shurikenTornado("player") then return true end
        -- end
        -- -- actions.cds+=/shadow_dance,if=!buff.shadow_dance.up&fight_remains<=8+talent.subterfuge.enabled
        -- if mode.sd == 1 and cdUsage and not buff.shadowDance.exists() and ttd("target") <= (8 + subterfugeActive) and ttd("target") > getOptionValue("CDs TTD Limit") then
        --     if cast.shadowDance("player") then return true end
        -- end
        -- actions.cds+=/potion,if=buff.bloodlust.react|buff.symbols_of_death.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=10)
---------------------------- SHADOWLANDS
        if cdUsage and ttd("target") > getOptionValue("CDs TTD Limit") and isChecked("Potion") and (hasBloodLust() or (buff.symbolsOfDeath.exists("target") and (buff.shadowBlades.exists() or cd.shadowBlades.remain() <= 10))) then
            if getOptionValue("Potion") == 1 and use.able.superiorBattlePotionOfAgility() and not buff.superiorBattlePotionOfAgility.exists() then
                use.superiorBattlePotionOfAgility()
                return true
            elseif getOptionValue("Potion") == 2 and use.able.potionOfUnbridledFury() and not buff.potionOfUnbridledFury.exists() then
                use.potionOfUnbridledFury()
                return true
            elseif getOptionValue("Potion") == 3 and use.able.potionOfFocusedResolve() and not buff.potionOfFocusedResolve.exists() then
                use.potionOfFocusedResolve() 
                return true
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
        -- # Specific trinktes 
        -- Very roughly rule of thumbified maths below: Use for Inkpod crit, otherwise with SoD at 25+ stacks or 15+ with also Blood up.
        -- actions.cds+=/use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|debuff.conductive_ink_debuff.up&target.health.pct<32&target.health.pct>=30|!debuff.conductive_ink_debuff.up&(debuff.razor_coral_debuff.stack>=25-10*debuff.blood_of_the_enemy.up|fight_remains<40)&buff.symbols_of_death.remains>8
        local BotEBuffActive = 0
        if buff.seethingRage.exists() then BotEBuffActive = 1 else BotEBuffActive = 0 end
        if isChecked("Trinkets") and not stealthedRogue and not debuff.razorCoral.exists("target") or (debuff.conductiveInk.exists("target") and thp < 32 and thp >= 30) or not debuff.conductiveInk.exists("target") and (debuff.razorCoral.stack() >= 25 - 10 * BotEBuffActive or ttd("target") < 40) and buff.symbolsOfDeath.remain() > 8 or (isBoss() and ttd("target") < 20) then
            if hasEquiped(169311, 13) and canUseItem(13) then
                useItem(13)
            end
            if hasEquiped(169311, 14) and canUseItem(14) then
                useItem(14)
            end
        end
        -- actions.cds+=/use_items,if=buff.symbols_of_death.up|fight_remains<20
        if cdUsage and isChecked("Trinkets") and (buff.symbolsOfDeath.exists() or not isChecked("Symbols of Death")) and ttd("target") > getOptionValue("CDs TTD Limit") or ttd("target") < 20 then
            if canUseItem(13) and not (hasEquiped(169311, 13) or hasEquiped(169314, 13) or hasEquiped(159614, 13)) then
                useItem(13)
            end
            if canUseItem(14) and not (hasEquiped(169311, 14) or hasEquiped(169314, 14) or hasEquiped(159614, 13)) then
                useItem(14)
            end
        end
    end

    local function actionList_Finishers()
        -- actions.finish=slice_and_dice,if=spell_targets.shuriken_storm<6&!buff.shadow_dance.up&buff.slice_and_dice.remains<fight_remains&buff.slice_and_dice.remains<(1+combo_points)*1.8
        if enemies10 < 6 and not buff.shadowDance.exists() and buff.sliceAndDice.remain() < ttd("target") and buff.sliceAndDice.remain() < (1 + combo)*1.8 then
            if cast.sliceAndDice() then return true end
        end
        -- # Helper Variable for Rupture. Skip during Master Assassin or during Dance with Dark and no Nightstalker.
        -- actions.finish+=/variable,name=skip_rupture,value=master_assassin_remains>0|!talent.nightstalker.enabled&talent.dark_shadow.enabled&buff.shadow_dance.up|spell_targets.shuriken_storm>=6
        local skipRupture = ((not talent.nightstalker and talent.darkShadow and buff.shadowDance.exists()) or enemies10 >= 6) or false -- buff.masterAssassin.exists() or 
        -- # Keep up Rupture if it is about to run out.
        -- actions.finish+=/rupture,if=!variable.skip_rupture&target.time_to_die-remains>6&refreshable
        if not skipRupture and ttd("target") > 6 and debuff.rupture.refresh("target") and shallWeDot("target") then
            if cast.rupture("target") then return true end
        end
        -- actions.finish+=/secret_technique
        if talent.secretTechnique then
            if cast.secretTechnique("target") then return true end
        end
        -- # Multidotting targets that will live for the duration of Rupture, refresh during pandemic.
        -- actions.finish+=/rupture,cycle_targets=1,if=!variable.skip_rupture&!variable.use_priority_rotation&spell_targets.shuriken_storm>=2&target.time_to_die>=(5+(2*combo_points))&refreshable
        local ruptureCount = debuff.rupture.count()
        if not skipRupture and not priorityRotation and enemies10 >= 2 and getSpellCD(spell.rupture) == 0 and ruptureCount <= getOptionValue("Multidot Limit") then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if ttd(thisUnit) >= (5 + 2 * combo) and debuff.rupture.refresh(thisUnit) and shallWeDot(thisUnit) then
                    if cast.rupture(thisUnit) then return true end
                end
            end
        end
        -- # Refresh Rupture early if it will expire during Symbols. Do that refresh if SoD gets ready in the next 5s.
        -- actions.finish+=/rupture,if=!variable.skip_rupture&remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
        if not skipRupture and ruptureRemain < cd.symbolsOfDeath.remain() + 10 and cd.symbolsOfDeath.remain() <= 5 and shallWeDot("target") and ttd("target") - ruptureRemain > cd.symbolsOfDeath.remain()+5 then
            if cast.rupture(thisUnit) then return true end
        end
        -- actions.finish+=/black_powder,if=!variable.use_priority_rotation&spell_targets>=3
        -- if not priorityRotation and enemies10 >= 3 then
        --     if cast.blackPowder("target") then return true end
        -- end
        -- actions.finish+=/eviscerate
        if cast.eviscerate("target") then return true end
    end

    local function actionList_StealthCD()
        -- # Helper Variable
        -- actions.stealth_cds=variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=1.75
        local shdThreshold = false
        if charges.shadowDance.frac() >= 1.75 then shdThreshold = true else shdThreshold = false end
        -- # Vanish if we are capping on Dance charges. Early before first dance if we have no Nightstalker but Dark Shadow in order to get Rupture up (no Master Assassin).
        -- actions.stealth_cds+=/vanish,if=(!variable.shd_threshold|!talent.nightstalker.enabled&talent.dark_shadow.enabled)&combo_points.deficit>1&!runeforge.mark_of_the_master_assassin.equipped
        if cdUsage and (not shdThreshold or not talent.nightstalker and talent.darkShadow) and comboDeficit > 1 and targetDistance < 5 and isChecked("Vanish") and ttd("target") > getOptionValue("CDs TTD Limit") then -- and not runeforge.markOfTheMasterAssassin.active
            if cast.vanish("player") then return true end
        end
---------------------------- SHADOWLANDS
        -- actions.stealth_cds+=/sepsis
        -- if cast.able.sepsis() then
        --     if cast.sepsis("target") then return true end
        -- end
---------------------------- SHADOWLANDS
        -- # Pool for Shadowmeld + Shadowstrike unless we are about to cap on Dance charges. Only when Find Weakness is about to run out.
        -- actions.stealth_cds+=/pool_resource,for_next=1,extra_amount=40
        -- actions.stealth_cds+=/shadowmeld,if=energy>=40&energy.deficit>=10&!variable.shd_threshold&combo_points.deficit>1&debuff.find_weakness.remains<1
        if cdUsage and isChecked("Racial") and race == "NightElf" and not cast.last.vanish() and not buff.vanish.exists() then
            if (cast.pool.racial() or cast.able.racial()) and energy >= 40 and energyDeficit >= 10 and not shdThreshold 
             and comboDeficit > 1 and debuff.findWeakness.remain(units.dyn5) < 1 then
                if cast.pool.racial() then return true end
                if cast.able.racial() then
                    if cast.racial() then return true end
                end
            end
        end
        -- # CP requirement: Dance at low CP by default.
        -- actions.stealth_cds+=/variable,name=shd_combo_points,value=combo_points.deficit>=4
        -- # CP requirement: Dance only before finishers if we have priority rotation.
        -- actions.stealth_cds+=/variable,name=shd_combo_points,value=combo_points.deficit<=1,if=variable.use_priority_rotation
        local shdComboPoints 
        if comboDeficit >= 4 or (comboDeficit <= 1 and priorityRotation) then shdComboPoints = 1 else shdComboPoints = 0 end
        -- # Dance during Symbols or above threshold.
        -- actions.stealth_cds+=/shadow_dance,if=variable.shd_combo_points&(variable.shd_threshold|buff.symbols_of_death.remains>=1.2|spell_targets.shuriken_storm>=4&cooldown.symbols_of_death.remains>10)
        if mode.sd == 1 and ttd("target") > 3 and cdUsage and ((isChecked("Save SD Charges for CDs") and buff.symbolsOfDeath.remain() >= 1.2 or charges.shadowDance.frac() >= (getOptionValue("Save SD Charges for CDs") + 1)) or (combatTime < 15 and not cd.vanish.exists()) or not isChecked("Save SD Charges for CDs"))
         and shdComboPoints and (shdComboPoints or buff.symbolsOfDeath.remain() >= 1.2 or enemies10 >= 4 and cd.symbolsOfDeath.remain() > 10) then
            if cast.shadowDance("player") then return true end
        end
        -- Burn remaining Dances before the fight ends if SoD won't be ready in time.
        -- actions.stealth_cds+=/shadow_dance,if=variable.shd_combo_points&fight_remains<cooldown.symbols_of_death.remains
        if mode.sd == 1 and cdUsage and shdComboPoints and ttd("target") < cd.symbolsOfDeath.remain() then
            if cast.shadowDance("player") then return true end
        end
    end

    local function actionList_Stealthed()
        -- # If Stealth/vanish are up, use Shadowstrike to benefit from the passive bonus and Find Weakness, even if we are at max CP (from the precombat MfD).
        -- actions.stealthed=shadowstrike,if=(buff.stealth.up|buff.vanish.up)
        if (stealth or buff.vanish.exists() or buff.shadowmeld.exists()) and targetDistance < 5 then
            if cast.shadowstrike("target") then return true end
        end
        -- # Finish at 3+ CP without DS / 4+ with DS with Shuriken Tornado buff up to avoid some CP waste situations.
        -- actions.stealthed+=/call_action_list,name=finish,if=buff.shuriken_tornado.up&combo_points.deficit<=2
        -- # Also safe to finish at 4+ CP with exactly 4 targets. (Same as outside stealth.)
        -- actions.stealthed+=/call_action_list,name=finish,if=spell_targets.shuriken_storm=4&combo_points>=4
        -- # Finish at 4+ CP without DS, 5+ with DS, and 6 with DS after Vanish
        -- actions.stealthed+=/call_action_list,name=finish,if=combo_points.deficit<=1-(talent.deeper_stratagem.enabled&buff.vanish.up)
        local finishThd = 0
        if dSEnabled and (buff.vanish.exists() or cast.last.vanish(1)) then finishThd = 1 else finishThd = 0 end
        if (buff.shurikenTornado.exists() and comboDeficit <= 2) or (enemies10 == 4 and combo >= 4) or (comboDeficit <= (1 - finishThd)) then
            if actionList_Finishers() then return true end
        end
        -- actions.stealthed+=/shiv,if=talent.nightstalker.enabled&runeforge.tiny_toxic_blade.equipped
        -- if talent.nightstalker and runeforge.tinyToxicBlade.active and (debuff.rupture.exists("target") or not shallWeDot("target")) and (buff.symbolsOfDeath.remain() > 8 
        --  or buff.shadowBlades.remain() > 9) and (ttd("target") > 3 or isBoss()) then
        --     if cast.shiv("target") then return true end
        -- end
        -- # For pre-patch, keep Find Weakness up on the primary target due to no Shadow Vault
        -- actions.stealthed+=/shadowstrike,if=level<52&debuff.find_weakness.remains<1&target.time_to_die-remains>6
        if level < 52 and debuff.findWeakness.remain("target") < 1 and ttd("target") > 6 then
            if cast.shadowstrike("target") then return true end
        end
        -- # Up to 3 targets keep up Find Weakness by cycling Shadowstrike.
        -- cycle_targets=1,if=debuff.find_weakness.remains<1&spell_targets.shuriken_storm<=3&target.time_to_die-remains>6
        -- actions.stealthed+=/shadowstrike,cycle_targets=1,if=debuff.find_weakness.remains<1&spell_targets.shuriken_storm<=3&target.time_to_die-remains>6
        if enemies10 <= 3 then
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
        -- # For priority rotation, use Shadowstrike over Storm 1) with WM against up to 4 targets, 2) if FW is running off (on any amount of targets), or 3) to maximize SoD extension with Inevitability on 3 targets (4 with BitS).
        -- actions.stealthed+=/shadowstrike,if=variable.use_priority_rotation&(debuff.find_weakness.remains<1|talent.weaponmaster.enabled&spell_targets.shuriken_storm<=4|azerite.inevitability.enabled&buff.symbols_of_death.up&spell_targets.shuriken_storm<=3+azerite.blade_in_the_shadows.enabled)
        if priorityRotation and (debuff.findWeakness.remain("target")<1 or talent.weaponmaster and enemies10 <= 4 or triat.inevitability.active and buff.symbolsOfDeath.exists() and enemies10 <= 3+bitsActive) and targetDistance < 5 then
            if cast.shadowstrike("target") then return true end
        end
        -- actions.stealthed+=/shuriken_storm,if=spell_targets>=3+(buff.premeditation.up|buff.the_rotten.up|runeforge.akaaris_soul_fragment.equipped&conduit.deeper_daggers.rank>=7)
        local stealthedsStorm = 0
        if buff.premeditation.exists() then stealthedsStorm = 1 else stealthedsStorm = 0 end -- or buff.theRotten.exists() or runeforge.akaarisSoulFragment.active and conduit.deeperDaggers.rank >= 7
        if enemies10 >= 3 + stealthedsStorm then
            if cast.shurikenStorm("player") then return true end
        end
        -- # Shadowstrike to refresh Find Weakness and to ensure we can carry over a full FW into the next SoD if possible.
        -- actions.stealthed+=/shadowstrike,if=debuff.find_weakness.remains<=1|cooldown.symbols_of_death.remains<18&debuff.find_weakness.remains<cooldown.symbols_of_death.remains
        if debuff.findWeakness.remain("target") <= 1 or cd.symbolsOfDeath.remain() < 1 and debuff.findWeakness.remain("target") < cd.symbolsOfDeath.remain() then
            if cast.shadowstrike("target") then return true end
        end
        -- gloomblade
        if cast.able.gloomblade() and talent.gloomblade then
            if cast.gloomblade("target") then return end
        end
---------------------------- SHADOWLANDS
        -- -- actions.stealthed+=/gloomblade,if=!runeforge.akaaris_soul_fragment.equipped&buff.perforated_veins.stack>=3&conduit.perforated_veins.rank>=13-(9*conduit.deeper_dagger.enabled+conduit.deeper_dagger.rank)
        -- if not runeforge.akaarisSoulFragment.active() and buff.perforatedVeins.stack() >= 3 and conduit.perforatedVeins.rank >= 13 - (9 * conduit.deeperDaggers + conduit.deeperDaggers.rank) then
        --     if cast.gloomblade("target") then return true end
        -- end
        -- -- actions.stealthed+=/gloomblade,if=runeforge.akaaris_soul_fragment.equipped&buff.perforated_veins.stack>=3&(conduit.perforated_veins.rank+conduit.deeper_dagger.rank)>=16
        -- if runeforge.akaarisSoulFragment.active() and buff.perforatedVeins.stack() >= 3 and (conduit.perforatedVeins.rank + conduit.deeperDaggers.rank) >= 16 then
        --     if cast.gloomblade("target") then return true end
        -- end
        -- -- # Use Gloomblade over Shadowstrike and Storm with 2+ Perforate at 2 or less targets.
        -- -- actions.stealthed+=/gloomblade,if=azerite.perforate.rank>=2&spell_targets.shuriken_storm<=2&position_back
        -- if trait.perforate.rank >= 2 and enemies10 <= 2 then
        --     for i = 1, #enemyTable5 do
        --         local thisUnit = enemyTable5[i].unit
        --         if not getFacing(thisUnit,"player") then
        --             if cast.gloomblade(thisUnit) then return true end
        --         end
        --     end
        -- end
---------------------------- SHADOWLANDS
        -- actions.stealthed+=/shadowstrike
        if targetDistance < 5 then
            if cast.shadowstrike("target") then return true end
        end
    end

    --Builders
    local function actionList_Builders()
        -- actions.build=shiv,if=!talent.nightstalker.enabled&runeforge.tiny_toxic_blade.equipped
        -- if talent.nightstalker and runeforge.tinyToxicBlade.active and (debuff.rupture.exists("target") or not shallWeDot("target")) and (buff.symbolsOfDeath.remain() > 8 
        --  or buff.shadowBlades.remain() > 9) and (ttd("target") > 3 or isBoss()) then
        --     if cast.shiv("target") then return true end
        -- end
        -- actions.build=shuriken_storm,if=spell_targets>=2+(talent.gloomblade.enabled&azerite.perforate.rank>=2&position_back)
        local buildersStorm = 0
        if talent.gloomblade and trait.perforate.rank >= 2 then buildersStorm = 1 else buildersStorm = 0 end
        if enemies10 >= 2 + buildersStorm then
            for i = 1, #enemyTable10 do
                thisUnit = enemyTable10[i].unit
                if not getFacing(thisUnit,"player") then
                    if cast.shurikenStorm("player") then return true end
                end
            end
        end
        -- actions.build+=/serrated_bone_spike,if=cooldown.serrated_bone_spike.charges_fractional>=2.75
        -- if charges.serratedBoneSpike.frac() >= 2.75 then
        --     if cast.serratedBoneSpike(enemyTable30.lowestTTDUnit) then return true end
        -- end
        -- actions.build+=/gloomblade
        if talent.gloomblade then
            if cast.gloomblade("target") then return true end
        end
        -- Sinister Strike
        if level < 14 then
            if cast.sinisterStrike("target") then return true end
        end
        -- actions.build+=/backstab
        if cast.backstab("target") then return end
        -- Use Shuriken Toss if we can't reach the target
        if isChecked("Shuriken Toss out of range") and not stealthedRogue and #enemyTable5 == 0 and energy >= getOptionValue("Shuriken Toss out of range") and inCombat then
            if cast.shurikenToss() then return true end
        end
    end
-----------------
--- Rotations ---
-----------------
    -- Pause
    if IsMounted() or IsFlying() or pause() or mode.rotation==3 then
        return true
    else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not cast.last.vanish(1) then
            if actionList_Extra() then return true end
        end
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
            if stealth and validTarget and comboDeficit > 2 and talent.markedForDeath and targetDistance < 10 then
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
            if IsUsableSpell(GetSpellInfo(spell.stealth)) and not IsStealthed() and not inCombat and not cast.last.vanish() then
                cast.stealth("player")
            end
            -- # Run fully switches to the Stealthed Rotation (by doing so, it forces pooling if nothing is available).
            -- actions+=/run_action_list,name=stealthed,if=stealthed.all
            if stealthedAll then
                if actionList_Stealthed() then return true end
            end
            --start aa
            if not stealthedRogue and validTarget and targetDistance < 5 and not IsCurrentSpell(6603) then
                StartAttack("target")
            end
            -- Off GCD Cooldowns
            if ttd("target") > getOptionValue("CDs TTD Limit") and validTarget and targetDistance < 5 then
                if actionList_CooldownsOGCD() then return true end
            end
            if validTarget and (combatTime > 1.5 or cd.vanish.exists()) then
                if gcd < getLatency() then
                    -- # Check CDs at first
                    -- actions+=/call_action_list,name=cds
                    if validTarget and targetDistance < 5 then
                        if actionList_Cooldowns() then return true end
                    end
                    -- # Apply Slice and Dice at 2+ CP during the first 10 seconds, after that 4+ CP if it expires within the next GCD or is not up
                    -- actions+=/slice_and_dice, if=spell_targets.shuriken_storm<6&fight_remains>6&buff.slice_and_dice.remains<gcd.max&combo_points>=4-(time<10)*2
                    local cTime = 0
                    if (combatTime < 10 and not cd.vanish.exists()) then 
                        cTime = 1
                    end
                    if enemies10 < 6 and ttd("target") > 6 and buff.sliceAndDice.remain() < gcdMax and combo >= 4-(cTime*2) and buff.sliceAndDice.remain() < 6+(combo*3) then
                        if cast.sliceAndDice("player") then return true end
                    end
                end
                -- # Priority Rotation? Let's give a crap about energy for the stealth CDs (builder still respect it). Yup, it can be that simple.
                -- actions+=/call_action_list,name=stealth_cds,if=variable.use_priority_rotation
                if priorityRotation and validTarget and not stealthedAll and targetDistance < 5 then
                    --print("Valid target: " .. (validTarget and 'true' or 'false'))
                    if actionList_StealthCD() then return true end
                end
                    -- # Used to define when to use stealth CDs or builders
                -- actions+=/variable,name=stealth_threshold,value=25+talent.vigor.enabled*20+talent.master_of_shadows.enabled*20+talent.shadow_focus.enabled*25+talent.alacrity.enabled*20+25*(spell_targets.shuriken_storm>=4)
                local stealthThd = 25 + vEnabled * 20 + mosEnabled * 20 + sfEnabled * 25 + aEnabled * 20 + 25 * ssThd
                -- # Consider using a Stealth CD when reaching the energy threshold
                -- actions+=/call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold
                if energyDeficit <= stealthThd and validTarget and not stealthedAll and targetDistance < 5 then
                    if actionList_StealthCD() then return true end
                end
                if gcd < getLatency() then
---------------------------- SHADOWLANDS               
                    -- actions+=/call_action_list,name=finish,if=runeforge.deathly_shadows.equipped&dot.sepsis.ticking&dot.sepsis.remains<=2&combo_points>=2
                    -- if runeforge.deadlyShadows.active and debuff.sepsis.exists("target") and debuff.sepsis.remain("target") <= 2 and combo >= 2 then
                    --     if actionList_Finishers() then return true end
                    -- end
                    -- actions+=/call_action_list,name=finish,if=cooldown.symbols_of_death.remains<=2&combo_points>=2&runeforge.the_rotten.equipped
                    -- if cd.symbolsOfDeath.remain() <= 2 and combo >= 2 and runeforge.theRotten.active then
                    --     if actionList_Finishers() then return true end
                    -- end
                    -- actions+=/call_action_list,name=finish,if=combo_points=animacharged_cp
                    -- if combo == animachargedCP then
                    --     if actionList_Finishers() then return true end
                    -- end
---------------------------- SHADOWLANDS
                    -- # Finish at 4+ without DS, 5+ with DS (outside stealth)
                    -- actions+=/call_action_list,name=finish,if=combo_points.deficit<=1|fight_remains<=1&combo_points>=3
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
                end
                -- # Lowest priority in all of the APL because it causes a GCD
                -- actions+=/arcane_torrent,if=energy.deficit>=15+energy.regen
                -- actions+=/arcane_pulse
                -- actions+=/lights_judgment
                -- actions+=/bag_of_tricks
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
local id = 261 --Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
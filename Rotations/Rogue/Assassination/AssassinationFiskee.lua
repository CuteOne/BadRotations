local rotationName = "Fiskee - 8.0.1"

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.garrote },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.fanOfKnives },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mutilate },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.stealth}
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
            br.ui:createCheckbox(section, "Tricks of the Trade on Focus")
            br.ui:createCheckbox(section, "Auto Target", "|cffFFFFFF Will auto change to a new target, if current target is dead")
            br.ui:createCheckbox(section, "Auto Garrote HP Limit", "|cffFFFFFF Will try to calculate if we should garrote from stealth on units, based on their HP")
            br.ui:createCheckbox(section, "Disable Auto Combat", "|cffFFFFFF Will not auto attack out of stealth, don't use with vanish CD enabled, will pause rotation after vanish")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            br.ui:createCheckbox(section, "Racial", "|cffFFFFFF Will use Racial")
            br.ui:createCheckbox(section, "Trinkets", "|cffFFFFFF Will use Trinkets")
            br.ui:createCheckbox(section, "Potion", "|cffFFFFFF Will use Potion")
            br.ui:createCheckbox(section, "Vanish", "|cffFFFFFF Will use Vanish")
            br.ui:createCheckbox(section, "Vendetta", "|cffFFFFFF Will use Vendetta")
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
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createCheckbox(section, "Kick")
            br.ui:createCheckbox(section, "Kidney Shot")
            br.ui:createCheckbox(section, "Blind")
            br.ui:createSpinnerWithout(section,  "Interrupt %",  30,  0,  95,  5,  "|cffFFBB00Remaining Cast Percentage to interrupt at.")
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
    local energy, energyDeficit, energyRegen            = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
    local falling, swimming, flying                     = getFallTime(), IsSwimming(), IsFlying()
    local gcd                                           = br.player.gcd
    local has                                           = br.player.has
    local healPot                                       = getHealthPot()
    local inCombat                                      = br.player.inCombat
    local mode                                          = br.player.mode
    local moving                                        = isMoving("player") ~= false or br.player.moving
    local php                                           = br.player.health
    local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local spell                                         = br.player.spell
    local stealth                                       = br.player.buff.stealth.exists()
    local stealthedRogue                                = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.subterfuge.exists()
    local stealthedAll                                  = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.subterfuge.exists() or br.player.buff.shadowmeld.exists()
    local talent                                        = br.player.talent
    local tickTime                                      = 2 / (1 + (GetHaste()/100))
    local trait                                         = br.player.traits
    local units                                         = br.player.units
    local use                                           = br.player.use

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    enemies.get(20)
    enemies.get(20,"player",true)
    enemies.get(30)

    local function shallWeDot(unit)
        if isChecked("Auto Garrote HP Limit") and getTTD(thisUnit) == 999 and not UnitIsPlayer(unit) then
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

    local function ttd(unit)
        if UnitIsPlayer(unit) then return 999 end
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then return ttdSec end
        if ttdSec == -1 then return 999 end
        return ttdSec
    end

    local function isTotem(unit)
        local creatureType = UnitCreatureType(unit)
        if creatureType ~= nil and GetObjectID(unit) ~= 125977 and GetObjectID(unit) ~= 127315 then --reanimate totem
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
        end
        return false
    end

    local noDotUnits = {
        [135824]=true, -- Nerubian Voidweaver
        [139057]=true, -- Nazmani Bloodhexer
        [129359]=true, -- Sawtooth Shark
        [129448]=true, -- Hammer Shark
        [134503]=true, -- Silithid Warrior
        [137458]=true, -- Rotting Spore
        [139185]=true, -- Minion of Zul
    }
    local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
        if isTotem(unit) then return true end
        unitCreator = UnitCreator(unit)
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
                if enemyUnit.distance <= 10 then
                    tinsert(enemyTable10, enemyUnit)
                    if deadlyPoison10 and not debuff.deadlyPoison.exists(thisUnit) then deadlyPoison10 = false end
                end
                if enemyUnit.distance <= 5 then tinsert(enemyTable5, enemyUnit) end
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
                enemyTable30[i].enemyScore = enemyScore
            end
            table.sort(enemyTable30, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
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
    local dSEnabled, sSActive, dDRank, sRogue
    if talent.deeperStratagem then dSEnabled = 1 else dSEnabled = 0 end
    if trait.shroudedSuffocation.active() then sSActive = 1 else sSActive = 0 end
    if trait.doubleDose.rank() > 2 then dDRank = 1 else dDRank = 0 end
    if stealthedRogue == true then sRogue = 1 else sRogue = 0 end
    local enemies10 = #enemyTable10

    -- actions+=/variable,name=energy_regen_combined,value=energy.regen+poisoned_bleeds*7%(2*spell_haste)
    local energyRegenCombined = energyRegen + ((debuff.garrote.count() + debuff.rupture.count()) * 7 % (2 * (GetHaste()/100)))

--------------------
--- Action Lists ---
--------------------
    local function actionList_Extra()
        if isChecked("Tricks of the Trade on Focus") and inCombat and GetUnitIsFriend("player", "focus") then
            cast.tricksOfTheTrade("focus")
        end
        if not inCombat then
            -- actions.precombat+=/apply_poison
            if not moving and buff.deadlyPoison.remain() < 300 and not cast.last.deadlyPoison() then
                if cast.deadlyPoison("player") then return true end
            end
            if not moving and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison() then
                if cast.cripplingPoison("player") then return true end
            end
            -- actions.precombat+=/stealth
            if isChecked("Auto Stealth") and IsUsableSpell(spell.stealth) and not cast.last.vanish() and not IsResting() then
                if getOptionValue("Auto Stealth") == 1 then
                    if cast.stealth() then return end
                end
                if #enemies.yards20nc > 0 and getOptionValue("Auto Stealth") == 2 then
                    if cast.stealth() then return end
                end
            end
        end
    end
    local function actionList_Defensive()
        if useDefensive() then
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") and not inCombat then
                if hasEquiped(122668) then
                    if GetItemCooldown(122668)==0 then
                        useItem(122668)
                    end
                end
            end
            if isChecked("Health Pot / Healthstone") and (use.able.healthstone() or canUse(healPot))
                and php <= getOptionValue("Health Pot / Healthstone") and inCombat and (hasHealthPot() or has.healthstone())
            then
                if use.able.healthstone() then
                    use.healthstone()
                elseif canUse(healPot) then
                    useItem(healPot)
                end
            end
            if isChecked("Cloak of Shadows") and canDispel("player",spell.cloakOfShadows) and inCombat then
                if cast.cloakOfShadows() then return end
            end
            if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
                if cast.crimsonVial() then return end
            end
            if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat and not stealth then
                if cast.evasion() then return end
            end
            if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() then
                if cast.feint() then return end
            end
        end
    end

    local function actionList_Interrupts()
        if useInterrupts() and not stealth then
            for i=1, #enemies.yards20 do
                local thisUnit = enemies.yards20[i]
                local distance = getDistance(thisUnit)
                if canInterrupt(thisUnit,getOptionValue("Interrupt %")) then
                    if isChecked("Kick") and distance < 5 then
                        if cast.kick(thisUnit) then return end
                    end
                    if cd.kick.remain() ~= 0 then
                        if isChecked("Kidney Shot") then
                            if cast.kidneyShot(thisUnit) then return end
                        end
                    end
                    if isChecked("Blind") and (cd.kick.remain() ~= 0 or distance >= 5) then
                        if cast.blind(thisUnit) then return end
                    end
                end
            end
        end
    end

    local function actionList_PreCombat()

        -- actions.precombat+=/potion
        -- actions.precombat+=/marked_for_death,precombat_seconds=5,if=raid_event.adds.in>40
    end

    local function actionList_Cooldowns()
        -- actions.cds=potion,if=buff.bloodlust.react|debuff.vendetta.up
        if useCDs() and ttd("target") > 15 and isChecked("Potion") and use.able.battlePotionOfAgility() and not buff.battlePotionOfAgility.exists() and (hasBloodLust() or debuff.vendetta.exists("target")) then
            use.battlePotionOfAgility()
            return true
        end
        -- actions.cds+=/use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
        if useCDs() and isChecked("Trinkets") and ((cd.vendetta.remain() <= 1 and (not talent.subterfuge or debuff.garrote.applied() > 1)) or cd.vendetta.remain() > 45 or not isChecked("Vendetta"))  then
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
        if useCDs() and isChecked("Racial") and debuff.vendetta.exists("target") and ttd("target") > 5  then
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
            -- actions.cds+=/vendetta,if=!stealthed.rogue&dot.rupture.ticking&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier>1)&(!talent.nightstalker.enabled|!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5-2*talent.deeper_stratagem.enabled)
            if isChecked("Vendetta") and not stealthedRogue and debuff.rupture.exists("target") and (not talent.subterfuge or trait.shroudedSuffocation.active() or debuff.garrote.applied("target") > 1 or not isChecked("Vanish")) and (not talent.nightstalker or not talent.exsanguinate or cd.exsanguinate.remain() < (5-2*dSEnabled)) then
                if cast.vendetta("target") then return true end
            end
            if isChecked("Vanish") and not stealthedRogue and getDistance("target") < 5 then
                -- # Extra Subterfuge Vanish condition: Use when Garrote dropped on Single Target
                -- actions.cds+=/vanish,if=talent.subterfuge.enabled&!dot.garrote.ticking&variable.single_target
                if talent.subterfuge and not debuff.garrote.exists("target") and enemies10 == 1 then
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Exsg + (Nightstalker, or Subterfuge only on 1T): Maximum CP and Exsg ready for next GCD
                -- actions.cds+=/vanish,if=talent.exsanguinate.enabled&(talent.nightstalker.enabled|talent.subterfuge.enabled&variable.single_target)&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier<=1)
                if talent.exsanguinate and (talent.nightstalker or (talent.subterfuge and enemies10 == 1)) and combo >= comboMax and cd.exsanguinate.remain() < 1 and (not talent.subterfuge or not trait.shroudedSuffocation.active() or debuff.garrote.applied("target") <= 1) then
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Nightstalker + No Exsg: Maximum CP and Vendetta up
                -- actions.cds+=/vanish,if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&combo_points>=cp_max_spend&debuff.vendetta.up
                if talent.nightstalker and not talent.exsanguinate and comboDeficit >= comboMax and (debuff.vendetta.exists("target") or not isChecked("Vendetta")) then
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Subterfuge + (No Exsg or 2T+): No stealth/subterfuge, Garrote Refreshable, enough space for incoming Garrote CP
                -- actions.cds+=/vanish,if=talent.subterfuge.enabled&(!talent.exsanguinate.enabled|!variable.single_target)&!stealthed.rogue&cooldown.garrote.up&dot.garrote.refreshable&(spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives|spell_targets.fan_of_knives>=4&combo_points.deficit>=4)
                if talent.subterfuge and (not talent.exsanguinate or enemies10 > 1) and not stealthedRogue and cd.garrote.remain() == 0 and debuff.garrote.refresh("target") and ((enemies10 <= 3 and comboDeficit >= 1 + enemies10) or (enemies10 >= 4 and comboDeficit >= 4)) then
                    if cast.vanish("player") then return true end
                end
                -- # Vanish with Master Assasin: No stealth and no active MA buff, Rupture not in refresh range
                -- actions.cds+=/vanish,if=talent.master_assassin.enabled&!stealthed.all&master_assassin_remains<=0&!dot.rupture.refreshable
                if talent.masterAssassin and not stealthedAll and not debuff.garrote.exists("target") and enemies10 == 1 then
                    if cast.vanish("player") then return true end
                end
            end
        end
        -- # Exsanguinate when both Rupture and Garrote are up for long enough
        -- actions.cds+=/exsanguinate,if=dot.rupture.remains>4+4*cp_max_spend&!dot.garrote.refreshable
        if talent.exsanguinate and debuff.rupture.remain("target") > (4 + 4 * comboMax) and not debuff.garrote.refreshable("target") then
            if cast.exsanguinate("target") then return true end
        end
        -- actions.cds+=/toxic_blade,if=dot.rupture.ticking
        if talent.toxicBlade and debuff.rupture.exists("target") then
            if cast.toxicBlade("target") then return true end
        end
    end

    local function actionList_Direct()
        -- # Envenom at 4+ (5+ with DS) CP. Immediately on 2+ targets, with Vendetta, or with TB; otherwise wait for some energy. Also wait if Exsg combo is coming up.
        -- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
        if combo >= (4 + dSEnabled) and ((debuff.vendetta.exists("target") or not useCDs() or ttd("target") < getOptionValue("CDs TTD Limit")) or debuff.toxicBlade.exists("target") or energyDeficit <= (25 + energyRegenCombined) or enemies10 > 1) and (not talent.exsanguinate or cd.exsanguinate.remain() > 2) then
            if cast.envenom("target") then return true end
        end
        -- actions.direct+=/variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target
        local useFiller = comboDeficit > 1 or energyDeficit <= (25 + energyRegenCombined) or enemies10 > 1
        -- # Poisoned Knife at 29+ stacks of Sharpened Blades.
        -- actions.direct+=/poisoned_knife,if=variable.use_filler&buff.sharpened_blades.stack>=29
        if useFiller and buff.sharpenedBlades.stack() >= 29 then
            if cast.poisonedKnife("target") then return true end
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
        -- actions.direct+=/blindside,if=variable.use_filler&(buff.blindside.up|!talent.venom_rush.enabled)
        if useFiller and (buff.blindside.exists() or not talent.venomRush) then
            if cast.blindside("target") then return true end
        end
        -- # Tab-Mutilate to apply Deadly Poison at 2 targets
        -- actions.direct+=/mutilate,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives=2
        if useFiller and enemies10 == 2 then
            if not debuff.deadlyPoison.exists("target") then
                if cast.mutilate("target") then return true end
            end
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if not debuff.deadlyPoison.exists(thisUnit) then
                    if cast.mutilate(thisUnit) then return true end
                end
            end
        end
        -- actions.direct+=/mutilate,if=variable.use_filler
        if useFiller then
            if cast.mutilate("target") then return true end
        end
    end

    local function actionList_Dot()
        -- # Special Rupture setup for Exsg
        -- actions.dot=rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2)))
        if talent.exsanguinate and ((combo>=comboMax and cd.exsanguinate.remain() < 1) or (not debuff.rupture.exists("target") and (combatTime > 10 or combo >= 2))) then
            if cast.rupture("target") then return true end
        end
        -- # Garrote upkeep, also tries to use it as a special generator for the last CP before a finisher
        -- actions.dot+=/pool_resource,for_next=1
        if cast.pool.garrote() then return true end
        -- actions.dot+=/garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(target.time_to_die-remains>4&spell_targets.fan_of_knives<=1|target.time_to_die-remains>12)
        local vanishCheck, vendettaCheck = false, false
        if useCDs() and ttd("target") > getOptionValue("CDs TTD Limit") then
            if isChecked("Vanish") and cd.vanish.remain() == 0 then vanishCheck = true end
            if isChecked("Vendetta") and cd.vendetta.remain() <= 4 then vendettaCheck = true end
        end
        if (not talent.subterfuge or not (vanishCheck and vendettaCheck)) and comboDeficit >= 1 then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                local garroteRemain = debuff.garrote.remain(thisUnit)
                if debuff.garrote.refresh(thisUnit) and
                (debuff.garrote.applied(thisUnit) <= 1 or (garroteRemain <= tickTime and enemies10 >= (3 + sSActive))) and
                (not debuff.garrote.exsang(thisUnit) or (garroteRemain < (tickTime * 2) and enemies10 >= (3 + sSActive))) and
                (((enemyTable5[i].ttd-garroteRemain)>4 and enemies10 <= 1) or enemyTable5[i].ttd>12) then
                    if cast.garrote(thisUnit) then return true end
                end
            end
        end
        -- # Crimson Tempest only on multiple targets at 4+ CP when running out in 2s (up to 4 targets) or 3s (5+ targets)
        -- actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4
        local crimsonTargets
        if enemies10 >= 5 then crimsonTargets = 1 else crimsonTargets = 0 end
        if talent.crimsonTempest and enemies10 >= 2 and debuff.crimsonTempest.remain() < (2+crimsonTargets) and combo >= 4 then
            if cast.crimsonTempest("player") then return true end
        end
        -- # Keep up Rupture at 4+ on all targets (when living long enough and not snapshot)
        -- actions.dot+=/rupture,cycle_targets=1,if=combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&target.time_to_die-remains>4
        if combo >= 4 then
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
        if combo >= 4 and ttd("target") > 6 and (talent.nightstalker or (talent.subterfuge and ((talent.exsanguinate and cd.exsanguinate.remain() <= 2) or not debuff.rupture.exists("target")) and enemies10 == 1)) then
            if cast.rupture("target") then return true end
        end
        -- # Subterfuge: Apply or Refresh with buffed Garrotes
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&refreshable&target.time_to_die-remains>2
        if talent.subterfuge then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if shallWeDot(thisUnit) and debuff.garrote.refresh(thisUnit) and (ttd(thisUnit) - debuff.garrote.remain(thisUnit)) > 2 then
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
                if debuff.garrote.exists(thisUnit) and garroteRemain <= 10 and debuff.garrote.applied(thisUnit) <= 1 and (enemyTable5[i].ttd - garroteRemain) > 2 then
                    if cast.garrote(thisUnit) then return true end
                end
            end
        end
        -- # Subterfuge + Shrouded Suffocation: Apply early Rupture that will be refreshed for pandemic.
        -- actions.stealthed+=/rupture,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&!dot.rupture.ticking
        if talent.subterfuge and trait.shroudedSuffocation.active() and not debuff.rupture.exists("target") then
            if cast.rupture("target") then return true end
        end
        -- # Subterfuge w/ Shrouded Suffocation: Reapply for bonus CP and extended snapshot duration
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&target.time_to_die>remains&combo_points.deficit>1
        if talent.subterfuge and trait.shroudedSuffocation.active() then
            for i = 1, #enemyTable5 do
                local thisUnit = enemyTable5[i].unit
                if enemyTable5[i].ttd > debuff.garrote.remain(thisUnit) and comboDeficit > 1 then
                    if cast.garrote(thisUnit) then return true end
                end
            end
        end
        -- # Subterfuge + Exsg: Even override a snapshot Garrote right after Rupture before Exsanguination
        -- actions.stealthed+=/pool_resource,for_next=1
        if cast.pool.garrote() then return true end
        -- actions.stealthed+=/garrote,if=talent.subterfuge.enabled&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&prev_gcd.1.rupture&dot.rupture.remains>5+4*cp_max_spend
        if talent.subterfuge and talent.exsanguinate and cd.exsanguinate.remain() < 1 and cast.last.rupture() and debuff.rupture.remain("target") > (5+4*comboMax) then
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
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
        if inCombat or (not isChecked("Disable Auto Combat") and (cast.last.vanish() or (isValidUnit("target") and getDistance("target") < 5))) then
            if actionList_Defensive() then return true end
            if actionList_Interrupts() then return true end
            -- # Restealth if possible (no vulnerable enemies in combat)
            -- actions=stealth
            if IsUsableSpell(spell.stealth) and not cast.last.vanish() then
                cast.stealth("player")
            end
            -- actions+=/call_action_list,name=stealthed,if=stealthed.rogue
            if stealthedRogue then
                if actionList_Stealthed() then return true end
            end
            -- actions+=/call_action_list,name=cds
            if actionList_Cooldowns() then return true end
            -- actions+=/call_action_list,name=dot
            if actionList_Dot() then return true end
            -- actions+=/call_action_list,name=direct
            if actionList_Direct() then return true end
            -- actions+=/arcane_torrent,if=energy.deficit>=15+variable.energy_regen_combined
            -- actions+=/arcane_pulse
            -- actions+=/lights_judgment
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
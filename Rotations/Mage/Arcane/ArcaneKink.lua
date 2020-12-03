local rotationName = "KinkyArcaneSL"
local rotationVer  = "v0.2.2"
local colorBlue      = "|cff3FC7EB"
local targetMoveCheck, opener, finalBurn = false, false, false
local lastTargetX, lastTargetY, lastTargetZ

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.arcaneOrb},
        [2] = {mode = "Sing", value = 2, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneMissiles},
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.runeofPower},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.runeofPower},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.arcaneBlast},
        [4] = {mode = "Lust", value = 4, overlay = "Cooldowns With Lust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.runeofPower}
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.prismaticBarrier},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.prismaticBarrier}
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
    }
    CreateButton("Interrupt", 4, 0)
    -- Arcane Orb Button
    ArcaneOrbModes = {
        [1] = {mode = "On", value = 1, overlay = "Auto AO Enabled", tip = "Will Automatically use Arcane Orb", highlight = 1, icon = br.player.spell.arcaneOrb},
        [2] = {mode = "Off", value = 2, overlay = "Auto AO Disabled", tip = "Will not use Arcane Orb", highlight = 0, icon = br.player.spell.arcaneOrb}
    }
    CreateButton("ArcaneOrb", 5, 0)

    -- Rune of Power Button
    RuneOfPowerModes = {
        [1] = {mode = "On", value = 1, overlay = "Auto Rune Of Power Enabled", tip = "Will Automatically use Arcane Orb", highlight = 1, icon = br.player.spell.runeofPower},
        [2] = {mode = "Off", value = 2, overlay = "Auto Rune Of Power Disabled", tip = "Will not use Arcane Orb", highlight = 0, icon = br.player.spell.runeofPower}
    }
    CreateButton("RuneOfPower", 1, 1)

    -- Final Burn Button
    FinalBurnModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Auto Final Burn Enabled", tip = "Will Enter Final Burn Automatically", highlight = 1, icon = br.player.spell.fireBlast},
        [2] = {mode = "On", value = 2, overlay = "Final Burn Enabled", tip = "Will Force Final Burn", highlight = 1, icon = br.player.spell.fireBlast},
        [3] = {mode = "Off", value = 3, overlay = "Final Burn Disabled", tip = "Final Burn Disabled", highlight = 0, icon = br.player.spell.fireBlast}
    }
    CreateButton("FinalBurn", 2, 1)
end
--------------- 
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {"None", GetBindingKey("Rotation Function 1"), GetBindingKey("Rotation Function 2"), GetBindingKey("Rotation Function 3"), GetBindingKey("Rotation Function 4"), GetBindingKey("Rotation Function 5")}
    local optionTable
    local function rotationOptions()
        local section
        ------------------------
        --- GENERAL  OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, colorBlue .. "Arcane" .. ".:|:. " ..colorBlue .. " General")
        -- APL

        br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFBB00SimC", "|cffFFBB00Leveling"}, 1, "|cffFFBB00Set APL Mode to use.")
        -- Dummy DPS Test

        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFBB00Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer

        br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffFFBB00Will precast Frostbolt on pull if pulltimer is active")
        -- Opener
        br.ui:createCheckbox(section,"Opener")

        -- Pet Management
        br.ui:createCheckbox(section, "Pet Management", "|cffFFBB00 Select to enable/disable auto pet management")
        br.ui:checkSectionState(section)

        ------------------------
        ---   DPS SETTINGS   ---
        ------------------------
       section = br.ui:createSection(br.ui.window.profile, colorBlue .. "DPS" .. ".:|:. " ..colorBlue .. " DPS Settings")
        -- Evocation Mana Percent
        br.ui:createSpinnerWithout(section, "Evocation Mana Percent", 25, 1, 100, 1, "|cffFFBB00Min. Mana Percent to use Evocation.")

        -- Arcane Explosion
        br.ui:createSpinnerWithout(section, "Arcane Explosion Units", 3, 1, 15, 1, "|cffFFBB00Min. number of units Arcane Explosion will be cast on.")

        -- Frozen Orb Units
        br.ui:createSpinnerWithout(section, "Arcane Orb Units", 2, 1, 15, 1, "|cffFFBB00Min. number of units Arcane Orb will be cast on.")

        -- Frozen Orb Key
        br.ui:createDropdown(section, "Arcane Orb Key", br.dropOptions.Toggle, 6, "|cffFFFFFFSet key to manually use Arcane Orb")

        -- Spellsteal
        br.ui:createCheckbox(section, "Spellsteal", "|cffFFBB00 Will use Spellsteal, delay can be changed using dispel delay in healing engine")

        -- Remove Curse
        br.ui:createDropdown(section, "Remove Curse", {"|cff00FF00Player","|cffFFFF00Target","|cffFFBB00Player/Target","|cffFF0000Mouseover","|cffFFBB00Any"}, 1, "","|ccfFFFFFFTarget to cast on, set delay in healing engine settings")

        -- Arcane Intellect
        br.ui:createCheckbox(section, "Arcane Intellect", "|cffFFBB00 Will use Arcane Intellect", true)

        -- Slow Fall
        br.ui:createSpinner(section, "Slow Fall Distance", 30, 0, 100, 1, "|cffFFBB00 Will cast slow fall based on the fall distance", true)   

        -- Comet Storm Units
        br.ui:createSpinnerWithout(section, "Comet Storm Units", 2, 1, 10, 1, "|cffFFBB00Min. number of units Comet Storm will be cast on.")

        -- Casting Interrupt Delay
        br.ui:createSpinner(section, "Casting Interrupt Delay", 0.3, 0, 1, 0.1, "|cffFFBB00Activate to delay interrupting own casts to use procs.")
        -- Casting Interrupt Delay
      --  br.ui:createCheckbox(section, "No Ice Lance", "|cffFFBB00Use No Ice Lance Rotation.")        
        -- Predict movement
        --br.ui:createCheckbox(section, "Disable Movement Prediction", "|cffFFBB00 Disable prediction of unit movement for casts")
        -- Auto target
        -- br.ui:createCheckbox(section, "Auto Target", "|cffFFBB00 Will auto change to a new target, if current target is dead")
        br.ui:checkSectionState(section)

        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
            section = br.ui:createSection(br.ui.window.profile, colorBlue .. "CDs" .. ".:|:. " ..colorBlue .. " Cooldowns")
        -- Cooldowns Time to Die limit
        br.ui:createSpinnerWithout(section, "Cooldowns Time to Die Limit", 5, 1, 30, 1, "|cffFFBB00Min. calculated time to die to use CDs.")

        -- Racial
        br.ui:createCheckbox(section, "Racial")

        -- Trinkets        
        br.ui:createDropdownWithout(section, "Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")


        br.ui:createDropdownWithout(section, "Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")
        -- Potion
        br.ui:createCheckbox(section, "Potion")

        -- Pre Pot
        br.ui:createCheckbox(section, "Pre Pot", "|cffFFBB00 Requires Pre-Pull logic to be active")

        -- AoE when using CD
        br.ui:createCheckbox(section, "Obey AoE units when using CDs", "|cffFFBB00 Use user AoE settings when using CDs")
        br.ui:checkSectionState(section)

        ------------------------
        --- Defensive OPTIONS ---
        ------------------------
            section = br.ui:createSection(br.ui.window.profile, colorBlue .. "DEF" .. ".:|:. " ..colorBlue .. " Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 45, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

        -- Use Mana Gem
        br.ui:createSpinner(section, "Use Mana Gem", 25, 0, 100, 5, "|cffFFBB0Mana Percent to Cast At")

        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")

        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
        end

        -- Ice Barrier
        br.ui:createSpinner(section, "Prismatic Barrier", 85, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

        -- Ice Barrier OOC
        br.ui:createCheckbox(section, "Prismatic Barrier OOC", "|cffFFBB00Keep Prismatic Barrier up out of combat")

        -- Ice Block
        br.ui:createSpinner(section, "Ice Block", 20, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")

        --Dispel
        --br.ui:createCheckbox(section, "Auto Dispel/Purge", "|cffFFBB00 Auto dispel/purge in m+, based on whitelist, set delay in healing engine settings")
        br.ui:checkSectionState(section)

        -- ------------------------
        -- ---     ESSENCES     ---
        -- ------------------------
               section = br.ui:createSection(br.ui.window.profile, colorBlue .. "AZI" .. ".:|:. " ..colorBlue .. " Essences")
        -- Essences Usage
        br.ui:createDropdownWithout(section, "Use Essences", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFBB00When to use Essences.")
        -- Focused Azerite Beam
        br.ui:createSpinner(section, "Focused Azerite Beam",  3,  1,  10,  1,  "|cffFFBB00 Min. units hit to use Focused Azerite Beam")
        -- Guardian of Azeroth
        br.ui:createCheckbox(section, "Guardian of Azeroth", "|cffFFBB00 Use Guardian of Azeroth (During CDs)")
        -- Memory of Lucid Dreams
        br.ui:createCheckbox(section, "Memory of Lucid Dreams", "|cffFFBB00 Use Memory of Lucid Dreams as per SimC Logic")
        -- Purifying Blast
        br.ui:createCheckbox(section, "Purifying Blast", "|cffFFBB00 Use Purifying Blast as per SimC Logic")
        -- Ripple in Space
        br.ui:createCheckbox(section, "Ripple in Space", "|cffFFBB00 Use Ripple in Space as per SimC Logic")
        -- Concentrated Flame
        br.ui:createCheckbox(section, "Concentrated Flame DPS", "|cffFFBB00 Use Concentrated Flame for DPS")
        br.ui:createSpinner(section, "Concentrated Flame HP", 30, 0, 100, 5, "|cffFFBB00 Use Concentrated Flame for healing")
        -- The Unbound Force
        br.ui:createCheckbox(section, "The Unbound Force", "|cffFFBB00 Use The Unbound Force as per SimC Logic")        
        -- Worldvein Resonance    
        br.ui:createCheckbox(section, "Worldvein Resonance", "|cffFFBB00 Use Worldvein Resonance as per SimC Logic")   
        -- Reaping Flames
        br.ui:createDropdown(section, "Reaping Flames", {"Always", "Snipe only"}, 1)
        br.ui:createSpinnerWithout(section, "Reaping Flames Damage", 30, 10, 100, 1)
        br.ui:checkSectionState(section)
        ------------------------
        ---Interrupt  OPTIONS---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percent to Cast At")
        -- Don't interrupt
        br.ui:createCheckbox(section, "Do Not Cancel Cast", "|cffFFBB00Will not interrupt own spellcasting to cast Counterspell")
        br.ui:checkSectionState(section)

        ------------------------
        ---TOGGLE KEY OPTIONS---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end
----------------
--- ROTATION ---
----------------
local function runRotation()
    --if br.timer:useTimer("debugArcane", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        br.player.ui.mode.rop = br.data.settings[br.selectedSpec].toggles["RuneOfPower"]
        br.player.ui.mode.fb = br.data.settings[br.selectedSpec].toggles["FinalBurn"]
        br.player.ui.mode.ao = br.data.settings[br.selectedSpec].toggles["ArcaneOrb"]
--------------
--- Locals ---
--------------
        local arcaneCharges                                 = br.player.power.arcaneCharges.amount()
        local arcaneChargesMax                              = br.player.power.arcaneCharges.max()
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local cl                                            = br.read
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local inCombat                                      = br.player.inCombat
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local friendly                                      = GetUnitIsFriend("target", "player")
        local moving                                        = isMoving("player") ~= false or br.player.moving
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local healPot                                       = getHealthPot()
        local has                                           = br.player.has
        local ui                                            = br.player.ui
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.ui.mode
        local perk                                          = br.player.perk   
        local hasPet                                        = IsPetActive()     
        local playerCasting                                 = UnitCastingInfo("player")
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local hasMouse                                      = GetObjectExists("mouseover")
        local php                                           = br.player.health
        local pullTimer                                     = br.DBM:getPulltimer()
        local power                                         = br.player.power.mana.amount()
        local powerPercent                                  = br.player.power.mana.percent()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.timeToMax
        local units                                         = br.player.units
        local trait                                         = br.player.traits
        local inInstance                                    = br.player.unit.instance() == "party"
        local inRaid                                        = br.player.unit.instance() == "raid"
        local manaPercent                                   = br.player.power.mana.percent()
        local lastSpell                                     = lastSpellCast
        local targetUnit                                    = nil
        local thp                                           = getHP("target")
        local travelTime                                    = getDistance("target") / 50 --Ice lance
        local ttm                                           = br.player.power.mana.ttm()
        local hasteAmount                                   = GetHaste() / 100
        local solo                                          = br.player.instance == "none"
        local units                                         = br.player.units
        local use                                           = br.player.use
        local pet                                           = br.player.pet.list
        local hasPet                                        = IsPetActive()
        local equiped                                       = br.player.equiped
        local ttd                                           = getTTD
        
        units.get(40)
        enemies.get(10)
        enemies.get(10, "target", true)
        enemies.get(40, nil, nil, nil, spell.arcaneBlast)

        local dispelDelay = 1.5
        if isChecked("Dispel delay") then
            dispelDelay = getValue("Dispel delay")
        end

        if profileStop == nil or not inCombat then
            profileStop = false
        end
        if leftCombat == nil then leftCombat = GetTime() end

        local var = {}
        var.ccMaxStack = 3
        var.var_prepull_evo = true
        var.var_rs_max_delay = 5
        var.var_ap_max_delay = 10
        var.var_rop_max_delay = 20
        var.var_totm_max_delay = 5
        -- (80-(mastery_value*100))
        var.var_barrage_mana_pct = 100
        var.var_ap_minimum_mana_pct = 15
        var.var_aoe_totm_charges = 2
        var.RadiantSparlVulnerabilityMaxStack = 4
        var.ClearCastingMaxStack = 3

                
    --blizzard check
    local aoeUnits = 0
    for i = 1, #enemies.yards10tnc do
        local thisUnit = enemies.yards10tnc[i]
        if ttd(thisUnit) > 4 then
            aoeUnits = aoeUnits + 1
        end
    end

   -- spellqueue ready
    local function spellQueueReady()
        --Check if we can queue cast
        local castingInfo = {UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end

    --cast time
    local function interruptCast(spellID)
        local castingInfo = {UnitCastingInfo("player")}
        if castingInfo[9] and castingInfo[9] == spellID then
            if isChecked("Casting Interrupt Delay") then
                if (GetTime()-(castingInfo[4]/1000)) >= getOptionValue("Casting Interrupt Delay") then
                    return true
                end
            else
                return true
            end
        end
        return false
    end

    --Player cast remain
    local playerCastRemain = 0
    if UnitCastingInfo("player") then
        playerCastRemain = (select(5, UnitCastingInfo("player")) / 1000) - GetTime()
    end

    -- Pet Stance
    local function petFollowActive()
        for i = 1, NUM_PET_ACTION_SLOTS do
            local name, _, _,isActive = GetPetActionInfo(i)
            if isActive and name == "PET_ACTION_FOLLOW" then
                return true
            end
        end
        return false
    end       

    units.get(40)
    enemies.get(10)
    enemies.get(10, "target", true)
    enemies.get(40, nil, nil, nil, spell.frostbolt)

    local dispelDelay = 1.5
    if isChecked("Dispel delay") then
        dispelDelay = getValue("Dispel delay")
    end

    if profileStop == nil or not inCombat then
        profileStop = false
    end
    --ttd
    local function ttd(unit)
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then
            return ttdSec
        end
        if ttdSec == -1 then
            return 999
        end
        return ttdSec
    end

    --calc damge
    local function calcDamage(spellID, unit)
        local spellPower = GetSpellBonusDamage(5)
        local spMod
        local dmg = 0
        local frostMageDmg = 0.81
        if spellID == spell.frostbolt then
            dmg = spellPower * 0.511
        elseif spellID == spell.iceLance then
            dmg = spellPower * 0.35
            if unit.frozen then
                dmg = dmg * 3
            end
        elseif spellID == spell.waterbolt then
            dmg = spellPower * 0.75 * 0.2925
        elseif spellID == spell.iceNova then
            dmg = spellPower * 0.45 * 400 / 100
        elseif spellID == spell.flurry then
            dmg = spellPower * 0.316 * 3
        elseif spellID == spell.ebonbolt then
            dmg = spellPower * 3.2175
        else
            return 0
        end
        return dmg * frostMageDmg * (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
    end

    local function calcHP(unit)
        local thisUnit = unit.unit
        local hp = UnitHealth(thisUnit)
        if br.unlocked then --EasyWoWToolbox ~= nil then
            local castID, _, castTarget = UnitCastID("player")
            if castID and castTarget and GetUnitIsUnit(unit, castTarget) and playerCasting then
                hp = hp - calcDamage(castID, unit)
            end
            for k, v in pairs(spell.abilities) do
                if br.InFlight.Check(v, thisUnit) then
                    hp = hp - calcDamage(v, unit)
                end
            end
            -- if UnitIsVisible("pet") then
            --     castID, _, castTarget = UnitCastID("pet")
            --     if castID and castTarget and UnitIsUnit(unit, castTarget) and UnitCastingInfo("pet") then
            --         local castRemain = (select(5, UnitCastingInfo("pet")) / 1000) - GetTime()
            --         if castRemain < 0.5 then
            --             hp = hp - calcDamage(castID, unit)
            --         end
            --     end
            -- end
        end
        return hp
    end

    --Spell steal
    local doNotSteal = {
        [273432] = "Bound By Shadow(Uldir)",
        [269935] = "Bound By Shadow(KR)"
    }
    local function spellstealCheck(unit)
        local i = 1
        local buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)
        while buffName do
            if doNotSteal[spellId] then
                return false
            elseif isStealable and (GetTime() - (expirationTime - duration)) > dispelDelay then
                return true
            end
            i = i + 1
            buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)            
        end
        return false
    end

    -- Blacklist enemies
    local function isTotem(unit)
        local eliteTotems = {
            -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = UnitCreatureType(unit)
        local objectID = GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
                return true
            end
        end
        return false
    end

    local noDotUnits = {
        [135824] = true, -- Nerubian Voidweaver
        [139057] = true, -- Nazmani Bloodhexer
        [129359] = true, -- Sawtooth Shark
        [129448] = true, -- Hammer Shark
        [134503] = true, -- Silithid Warrior
        [137458] = true, -- Rotting Spore
        [139185] = true, -- Minion of Zul
        [120651] = true -- Explosive
    }

    local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then
            return true
        end
        if isTotem(unit) then
            return true
        end
        local unitCreator = UnitCreator(unit)
        if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then
            return true
        end
        if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then
            return true
        end
        return false
    end

    local standingTime = 0
    if DontMoveStartTime then
        standingTime = GetTime() - DontMoveStartTime
    end

    --wipe timers table
    if timersTable then
        wipe(timersTable)
    end

    --local enemies table with extra data
    local facingUnits = 0
    local enemyTable40 = {}
    if #enemies.yards40 > 0 then
        local highestHP
        local lowestHP
        local distance20Max
        local distance20Min
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) and (mode.rotation ~= 2 or GetUnitIsUnit(thisUnit, "target")) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(enemyUnit.distance - 20)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.facing = getFacing("player", thisUnit)
                enemyUnit.calcHP = calcHP(enemyUnit)
                tinsert(enemyTable40, enemyUnit)
                if enemyUnit.facing then
                    facingUnits = facingUnits + 1
                end
                if highestHP == nil or highestHP < enemyUnit.hpabs then
                    highestHP = enemyUnit.hpabs
                end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then
                    lowestHP = enemyUnit.hpabs
                end
                if distance20Max == nil or distance20Max < enemyUnit.distance20 then
                    distance20Max = enemyUnit.distance20
                end
                if distance20Min == nil or distance20Min > enemyUnit.distance20 then
                    distance20Min = enemyUnit.distance20
                end
            end
        end
        if #enemyTable40 > 1 then
            for i = 1, #enemyTable40 do
                local hpNorm = (5 - 1) / (highestHP - lowestHP) * (enemyTable40[i].hpabs - highestHP) + 5 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0 / 0) then
                    hpNorm = 0
                end -- NaN check
                local distance20Norm = (3 - 1) / (distance20Max - distance20Min) * (enemyTable40[i].distance20 - distance20Min) + 1 -- normalization of distance 20, low is good
                if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0 / 0) then
                    distance20Norm = 0
                end -- NaN check
                local enemyScore = hpNorm + distance20Norm
                if enemyTable40[i].facing then
                    enemyScore = enemyScore + 10
                end
                if enemyTable40[i].ttd > 1.5 then
                    enemyScore = enemyScore + 10
                end
                enemyTable40[i].enemyScore = enemyScore
            end
            table.sort(
                enemyTable40,
                function(x, y)
                    return x.enemyScore > y.enemyScore
                end
            )
        end
        if isChecked("Auto Target") and #enemyTable40 > 0 and ((GetUnitExists("target") and (UnitIsDeadOrGhost("target") or (targetUnit and targetUnit.calcHP < 0)) and not GetUnitIsUnit(enemyTable40[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable40[1].unit)
            return true
        end
        for i = 1, #enemyTable40 do
            if UnitIsUnit(enemyTable40[i].unit, "target") then
                targetUnit = enemyTable40[i]
            end
        end
    end

    -- spell usable check
    local function spellUsable(spellID)
        if isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end

function cl:Mage(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
    if source == br.guid then
        -- CLear dot table after each death/individual combat scenarios. 
        if source == br.guid and param == "PLAYER_REGEN_ENABLED" then 
            VarConserveMana = 0
            VarTotalBurns = 0
            VarAverageBurnLength = 0
            VarFontPrecombatChannel = 0
        end       
        if param == "PLAYER_REGEN_DISABLED" then finalBurn = false opener = false var_init = false if not var_init then VarInit() end end
    end 
end

        local function castarcaneOrb(minUnits, safe, minttd)
        if not isKnown(spell.arcaneOrb) or getSpellCD(spell.arcaneOrb) ~= 0 then
            return false
        end  
        if mode.ao == 2 then return false end 
        local x, y, z = ObjectPosition("player")
        local length = 35
        local width = 17
        ttd = ttd or 0
        safe = safe or true
        local function getRectUnit(facing)
            local halfWidth = width/2
            local nlX, nlY, nlZ = GetPositionFromPosition(x, y, z, halfWidth, facing + math.rad(90), 0)
            local nrX, nrY, nrZ = GetPositionFromPosition(x, y, z, halfWidth, facing + math.rad(270), 0)
            local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, length, facing, 0)
            return nlX, nlY, nrX, nrY, frX, frY
        end
        local enemiesTable = getEnemies("player", length, true)
        local facing = ObjectFacing("player")        
        local unitsInRect = 0
        local nlX, nlY, nrX, nrY, frX, frY = getRectUnit(facing)
        local thisUnit
        for i = 1, #enemiesTable do
            thisUnit = enemiesTable[i]
            local uX, uY, uZ = ObjectPosition(thisUnit)
            if isInside(uX, uY, nlX, nlY, nrX, nrY, frX, frY) and not TraceLine(x, y, z+2, uX, uY, uZ+2, 0x100010) then
                if safe and not UnitAffectingCombat(thisUnit) and not isDummy(thisUnit) then
                    unitsInRect = 0
                    break
                end            
                if ttd(thisUnit) >= minttd then                
                    unitsInRect = unitsInRect + 1
                end
            end
        end
        if unitsInRect >= minUnits then
            CastSpellByName(GetSpellInfo(spell.arcaneOrb))
            return true
        else
            return false
        end
    end
  
    function mageDamage()
        local X,Y,Z = ObjectPosition("player")
        print(Z)
        Z = select(3, TraceLine(X, Y, Z + 10, X, Y, Z - 10, 0x110))
        print(Z)
    end

    -- Opener Variables
    if not inCombat and not GetObjectExists("target") then
        fbInc = false
    end

--------------------
--- Action Lists ---
--------------------
local function actionList_Leveling()
    if level >= 10 then
        -- Conjure Mana Gem
        if level >= 17
        and not inCombat 
        and cast.able.conjuremanaGem()
        and GetItemCount(36799) < 1
        then
            if cast.conjuremanaGem() then br.addonDebug("Casting Conjure Mana Gem" ) return true end
        end

        -- Presence of Mind
        if level >= 42 
        and cast.able.presenceofMind()
        and moving
        then
            if cast.presenceofMind() then return true end 
        end

        -- Touch of the Magi
        if level >= 34
        and not moving
        and cast.able.touchOfTheMagi()
        and arcaneCharges < 0
        then
            if cast.touchOfTheMagi() then return true end 
        end

        -- Arcane Power 
        if level >= 29
        and cast.able.arcanePower() 
        and arcaneCharges > 3
        then
            if cast.arcanePower() then return true end 
        end

        -- Evocation
        if level >= 27
        and not moving
        and cast.able.evocation()
        and manaPercent < 10 
        then
            if cast.evocation() then return true end 
        end

        -- Use Mana Gem
        if level >= 17
        and ui.checked("Use Mana Gem")
        and manaPercent <= ui.value("Use Mana Gem")
        and GetItemCount(36799) > 0 
        then
            if use.able.manaGem() then if use.manaGem() then br.addonDebug("Use Mana Gem") return true end end 
        end

        -- Arcane Missiles
        if level >= 24 then
            if cast.able.arcaneMissiles()
            and buff.clearcasting.exists()
            then
                if cast.arcaneMissiles() then return true end 
            end
        end

        -- Arcane Barrage
        if cast.able.arcaneBarrage() then
            -- If touch of the magi is ready. 
            if level >= 46 and cd.touchOfTheMagi.remain() <= gcdMax then if cast.arcaneBarrage() then return true end end 

            -- If unit is about to die. 
            if thp <= 35 and getTTD("target") >= gcdMax + cast.time.arcaneBarrage() then if cast.arcaneBarrage() then return true end end

            -- If we're low on mana.
            if manaPercent < 30 then if cast.arcaneBarrage() then return true end end

            -- If we're capped on arcane charges. 
            if arcaneCharges > 3 then if cast.arcaneBarrage() then return true end end
        end

        -- Arcane Orb Key
        if mode.arcaneOrb == 2 and isChecked("Arcane Orb Key") and SpecificToggle("Arcane Orb Key") and not GetCurrentKeyBoardFocus() and cast.able.arcaneOrb() then
            if castarcaneOrb(1, true, 4) then return true end 
        end

        -- Level 45 Arcane Orb
        if level >= 45 and talent.arcaneOrb
        and mode.arcaneOrb == 1
        and aoeUnits >= ui.value("Arcane Orb Units")
        or isBoss("target") or getTTD("target") >= 20 then
            if cast.able.arcaneOrb() then if castarcaneOrb(1, true, 4) then return true end end
        end

        -- Arcane Explosion
        if cast.able.arcaneExplosion() 
        and getDistance("target") <= 10 
        and manaPercent > 30 
        and #enemies.yards10tnc >= getOptionValue("Arcane Explosion Units") 
        then
            if cast.arcaneExplosion("player","aoe", 3, 10) then return true end
        end

        -- Arcane Blast
        if cast.able.arcaneBlast() and not moving then if cast.arcaneBlast() then return true end end
    end 
end


local function actionList_Extras()
    if not IsFlying() and not IsMounted() and not IsResting() then
        if isChecked("DPS Testing") and GetObjectExists("target") and getCombatTime() >= (tonumber(getOptionValue("DPS Testing")) * 60) and isDummy() then
            StopAttack()
            ClearTarget()
            if isChecked("Pet Management") and not talent.lonelyWinter then
                PetStopAttack()
                PetFollow()
            end
            print(tonumber(getOptionValue("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
            profileStop = true
        end

        --Prismatic Barrier
        if not IsResting() and not inCombat and not playerCasting and isChecked("Prismatic Barrier OOC") and not buff.prismaticBarrier.exists("player") and not IsMounted() and not IsFlying() then
            if cast.prismaticBarrier("player") then
                return true
            end
        end

                -- Arcane Intellect
        if isChecked("Prismatic Barrier") and br.timer:useTimer("PB Delay", math.random(15, 30)) then
            for i = 1, #br.friend do
                if not buff.prismaticBarrier.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                    if cast.prismaticBarrier() then return true end
                end
            end
        end

        -- Spell Steal
        if isChecked("Spellsteal") and inCombat then
            for i = 1, #enemyTable40 do
                if spellstealCheck(enemyTable40[i].unit) then
                    if cast.spellsteal(enemyTable40[i].unit) then return true end
                end
            end
        end

    if not inCombat and GetItemCount(36799) < 1 then
        if cast.conjuremanaGem() then br.addonDebug("Casting Conjure Mana Gem" ) return true end
    end
        -- Arcane Orb Key
        if mode.arcaneOrb == 2 or isChecked("Arcane Orb Key") and SpecificToggle("Arcane Orb Key") and not GetCurrentKeyBoardFocus() and cast.able.arcaneOrb() then
            if castarcaneOrb(1, true, 4) then return true end 
        end

        -- Arcane Intellect
        if isChecked("Arcane Intellect") and br.timer:useTimer("AI Delay", math.random(15, 30)) then
            for i = 1, #br.friend do
                if not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                    if cast.arcaneIntellect() then return true end
                end
            end
        end

        -- Trinkets
            -- Trinket 1
            if (getOptionValue("Trinket 1") == 1 or (getOptionValue("Trinket 1") == 2 and useCDs())) and inCombat then
                if use.able.slot(13) then
                    use.slot(13)
                end
            end

        -- Trinket 2
            if (getOptionValue("Trinket 2") == 1 or (getOptionValue("Trinket 2") == 2 and useCDs())) and inCombat then
                if use.able.slot(14) then
                    use.slot(14)
                end
            end      

        -- Slow Fall
        if isChecked("Slow Fall Distance") and cast.able.slowFall() and not buff.slowFall.exists() then
            if IsFalling() and getFallDistance() >= getOptionValue("Slow Fall Distance") then
                if cast.slowFall() then return end
            end
        end     
    end    
    end

    local function actionList_Interrupts()
        if useInterrupts() and cd.counterspell.remain() == 0 then
            if not isChecked("Do Not Cancel Cast") or not playerCasting then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if cast.counterspell(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end    

local function actionList_Defensive()
        if useDefensive() then
            --Ice Block
            if isChecked("Ice Block") and php <= getOptionValue("Ice Block") and cd.iceBlock.remain() <= gcd then
                if UnitCastingInfo("player") then
                    SpellStopCasting()
                end
                if cast.iceBlock("player") then
                    return true
                end
            end

            --Pot/Stone
            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                end
            end

            --Heirloom Neck
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                if hasEquiped(heirloomNeck) then
                    if GetItemCooldown(heirloomNeck) == 0 then
                        useItem(heirloomNeck)
                    end
                end
            end

            --Ice Barrier
            if isChecked("Prismatic Barrier") and not playerCasting and php <= getOptionValue("Prismatic Barrier") then
                if cast.prismaticBarrier("player") then
                    return true
                end
            end

            --Gift of the Naaru (Racial)
            if br.player.race == "Draenei"  and isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end

            --Remove Curse, Yoinked from Aura balance
            if isChecked("Remove Curse") then
                if getOptionValue("Remove Curse") == 1 then
                    if canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 2 then
                    if canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 3 then
                    if canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    elseif canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 4 then
                    if canDispel("mouseover",spell.removeCurse) then
                        if cast.removeCurse("mouseover") then return true end
                    end
                elseif getOptionValue("Remove Curse") == 5 then
                    for i = 1, #br.friend do
                        if canDispel(br.friend[i].unit,spell.removeCurse) then
                            if cast.removeCurse(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
        end
end

--[[
actions.cooldowns=lights_judgment,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
actions.cooldowns+=/bag_of_tricks,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
actions.cooldowns+=/call_action_list,name=items,if=buff.arcane_power.up
actions.cooldowns+=/potion,if=buff.arcane_power.up
actions.cooldowns+=/berserking,if=buff.arcane_power.up
actions.cooldowns+=/blood_fury,if=buff.arcane_power.up
actions.cooldowns+=/fireblood,if=buff.arcane_power.up
actions.cooldowns+=/ancestral_call,if=buff.arcane_power.up
# Prioritize using grisly icicle with ap. Use it with totm otherwise. 
actions.cooldowns+=/frost_nova,if=runeforge.grisly_icicle.equipped&cooldown.arcane_power.remains>30&cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=2&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd))
actions.cooldowns+=/frost_nova,if=runeforge.grisly_icicle.equipped&cooldown.arcane_power.remains=0&(!talent.enlightened.enabled|(talent.enlightened.enabled&mana.pct>=70))&((cooldown.touch_of_the_magi.remains>10&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack=0))&buff.rune_of_power.down&mana.pct>=variable.ap_minimum_mana_pct
actions.cooldowns+=/frostbolt,if=runeforge.disciplinary_command.equipped&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_frost.down&(buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down)&cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=2&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd))
actions.cooldowns+=/fire_blast,if=runeforge.disciplinary_command.equipped&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down&prev_gcd.1.frostbolt
# Always use mirrors with ap. If totm is ready as well, make sure to cast it before totm.
actions.cooldowns+=/mirrors_of_torment,if=cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=2&cooldown.arcane_power.remains<=gcd
actions.cooldowns+=/mirrors_of_torment,if=cooldown.arcane_power.remains=0&(!talent.enlightened.enabled|(talent.enlightened.enabled&mana.pct>=70))&((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack=0))&buff.rune_of_power.down&mana.pct>=variable.ap_minimum_mana_pct
# Always use deathborne with ap. If totm is ready as well, make sure to cast it before totm.
actions.cooldowns+=/deathborne,if=cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=2&cooldown.arcane_power.remains<=gcd
actions.cooldowns+=/deathborne,if=cooldown.arcane_power.remains=0&(!talent.enlightened.enabled|(talent.enlightened.enabled&mana.pct>=70))&((cooldown.touch_of_the_magi.remains>10&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack=0))&buff.rune_of_power.down&mana.pct>=variable.ap_minimum_mana_pct
# Use spark if totm and ap are on cd and won't be up for longer than the max delay, making sure we have at least two arcane charges and that totm wasn't just used.
actions.cooldowns+=/radiant_spark,if=cooldown.touch_of_the_magi.remains>variable.rs_max_delay&cooldown.arcane_power.remains>variable.rs_max_delay&(talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd|talent.rune_of_power.enabled&cooldown.rune_of_power.remains>variable.rs_max_delay|!talent.rune_of_power.enabled)&buff.arcane_charge.stack>2&debuff.touch_of_the_magi.down
# Use spark with ap when possible. If totm is ready as well, make sure to cast it before totm.
actions.cooldowns+=/radiant_spark,if=cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=2&cooldown.arcane_power.remains<=gcd
actions.cooldowns+=/radiant_spark,if=cooldown.arcane_power.remains=0&((!talent.enlightened.enabled|(talent.enlightened.enabled&mana.pct>=70))&((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack=0))&buff.rune_of_power.down&mana.pct>=variable.ap_minimum_mana_pct)
# Kyrian: Use totm if ap is on cd and won't be up for longer than the max delay. Align with rop if the talent is taken. Hold a bit to make sure we can RS immediately after totm ends
actions.cooldowns+=/touch_of_the_magi,if=buff.arcane_charge.stack<=2&talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay&covenant.kyrian.enabled&cooldown.radiant_spark.remains<=8
# Non-Kyrian: Use totm if ap is on cd and won't be up for longer than the max delay. Align with rop if the talent is taken.
actions.cooldowns+=/touch_of_the_magi,if=buff.arcane_charge.stack<=2&talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay&!covenant.kyrian.enabled
actions.cooldowns+=/touch_of_the_magi,if=buff.arcane_charge.stack<=2&!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay
actions.cooldowns+=/touch_of_the_magi,if=buff.arcane_charge.stack<=2&cooldown.arcane_power.remains<=gcd
# Use ap if totm is on cd and won't be up for longer than the max delay, making sure that we have enough mana and that there is not already a rune of power down.
actions.cooldowns+=/arcane_power,if=(!talent.enlightened.enabled|(talent.enlightened.enabled&mana.pct>=70))&cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.rune_of_power.down&mana.pct>=variable.ap_minimum_mana_pct
# Use rop if totm is on cd and won't be up for longer than the max delay, making sure there isn't already a rune down and that ap won't become available during rune.
actions.cooldowns+=/rune_of_power,if=buff.rune_of_power.down&cooldown.touch_of_the_magi.remains>variable.rop_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack&(cooldown.arcane_power.remains>15|debuff.touch_of_the_magi.up)
# Kyrian: RS is mana hungry and AB4s are too expensive to use pom to squeeze an extra ab in the totm window. Let's use it to make low charge ABs instant.
actions.cooldowns+=/presence_of_mind,if=buff.arcane_charge.stack=0&covenant.kyrian.enabled
# Non-Kyrian: Use pom to squeeze an extra ab in the totm window.
actions.cooldowns+=/presence_of_mind,if=debuff.touch_of_the_magi.up&!covenant.kyrian.enabled
actions.cooldowns+=/use_mana_gem,if=cooldown.evocation.remains>0&((talent.enlightened.enabled&mana.pct<=80&mana.pct>=65)|(!talent.enlightened.enabled&mana.pct<=85))
]]--
local function actionList_Cooldowns()
    if useCDs() and not moving and targetUnit.ttd >= getOptionValue("Cooldowns Time to Die Limit") or isBoss("target") or isDummy() then

    -- actions.cooldowns+=/potion,if=prev_gcd.1.icy_veins|target.time_to_die<30
    if isChecked("Potion") 
    and use.able.battlePotionOfIntellect() 
    and not buff.battlePotionOfIntellect.exists() 
    and buff.arcanePower.exists()
    and (cast.last.icyVeins() or ttd("target") < 30) 
    then
        use.battlePotionOfIntellect()
        return true
    end
    -- actions.cooldowns+=/mirror_image
    --if cast.mirrorImage() then return true end

    --racials
    if isChecked("Racial") then
        if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
            if race == "LightforgedDraenei" then
                if cast.racial("target","ground") then return true end
            else
                if cast.racial("player") then return true end
                end
            end
        end
    end

    --actions.cooldowns+=/touch_of_the_magi,if=buff.arcane_charge.stack<=2&!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay
    if cast.able.touchOfTheMagi()
    and arcaneCharges <= 2
    and not talent.runeofPower
    and cd.arcanePower.remain() > var.var_ap_max_delay
    then
        if cast.touchOfTheMagi() then return true end 
    end

    --actions.cooldowns+=/touch_of_the_magi,if=buff.arcane_charge.stack<=2&cooldown.arcane_power.remains<=gcd
    --Use ap if totm is on cd and won't be up for longer than the max delay, making sure that we have enough mana and that there is not already a rune of power down.
    if cast.able.touchOfTheMagi()
    and arcaneCharges <= 2
    and cd.arcanePower.remain() <= gcdMax
    then
        if cast.touchOfTheMagi() then return true end
    end

    --actions.cooldowns+=/arcane_power,if=(!talent.enlightened.enabled|(talent.enlightened.enabled&mana.pct>=70))&cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.rune_of_power.down&mana.pct>=variable.ap_minimum_mana_pct
    -- Use rop if totm is on cd and won't be up for longer than the max delay, making sure there isn't already a rune down and that ap won't become available during rune.
    if cast.able.arcanePower() and not talent.enlightened
    or talent.enlightened
    and manaPercent >= 70
    and cd.touchOfTheMagi.remain() > var.var_rop_max_delay
    and arcaneCharges > 3
    and not buff.runeofPower.exists()
    and manaPercent >= var.var_ap_minimum_mana_pct
    then
        if cast.arcanePower() then return true end
    end

    --actions.cooldowns+=/rune_of_power,if=buff.rune_of_power.down&cooldown.touch_of_the_magi.remains>variable.rop_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack&(cooldown.arcane_power.remains>15|debuff.touch_of_the_magi.up)
    if cast.able.runeofPower()
    and mode.rop ~= 2
    and not moving
    and cast.timeSinceLast.arcanePower() >= 15 or not cast.able.arcanePower() and not buff.runeofPower.exists()
    and not buff.runeofPower.exists()
    and cd.touchOfTheMagi.remain() > var.var_rop_max_delay
    and arcaneCharges > 3
    and cd.arcanePower.remain() > 15
    or debuff.touchoftheMagi.exists("target")
    then
        if cast.runeofPower() then return true end
    end

    --actions.cooldowns+=/presence_of_mind,if=debuff.touch_of_the_magi.up&!covenant.kyrian.enabled
    -- Shadowlands

    
   -- Mirror image when Arcane Power is not active, on CD
    if cast.able.mirrorImage() then if cast.mirrorImage() then return true end end

    --actions.cooldowns+=/use_mana_gem,if=cooldown.evocation.remains>0&((talent.enlightened.enabled&mana.pct<=80&mana.pct>=65)|(!talent.enlightened.enabled&mana.pct<=85))
    if cd.evocation.remain() > 0
    and talent.enlightened
    and manaPercent <= 80 and manaPercent >= 60
    or not talent.enlightened 
    and manaPercent <= 85
    then
        if use.able.manaGem() then if use.manaGem() then br.addonDebug("[Action:AoE] Mana Gem (1)") return true end end 
    end

end

local function actionList_Movement()
    --actions.movement=blink_any,if=movement.distance>=10
    --[[if cast.able.blink()
    and isChecked("Blink Hotkey") 
    and SpecificToggle("Blink Hotkey") 
    and not GetCurrentKeyBoardFocus() 
    then
       if cast.blink() then br.addonDebug("Blinking (Movement, target > 40yds)") return true end 
    end--]]

    --ctions.movement+=/presence_of_mind
   if cast.presenceofMind("player") then br.addonDebug("Presence of Mind (Movement)") return true end 
    --actions.movement+=/arcane_missiles,if=movement.distance<10
   --[[ if cast.able.arcaneMissiles() 
    and getDistance("target") < 40
    then 
        if cast.arcaneMissiles() then br.addonDebug("Arcane Missiles (Movement)") return true end 
    end--]]

    --actions.movement+=/arcane_orb
    if cast.able.arcaneOrb() then if castarcaneOrb(1, true, 4) then return true end end
    
    if  buff.arcanePower.exists() or debuff.touchoftheMagi.exists("target") or buff.runeofPower.exists() and not mode.fb == 3 or not mode.fb == 1 and cd.evocation.remain() > 30 then if cast.arcaneBarrage() then br.addonDebug("Arcane Blast (Movement-Not Burn Phase)") return true end end 

    --actions.movement+=/fire_blast
    if cast.able.fireBlast() then if cast.fireBlast() then return true end end
end -- End of Movement

--[[local function actionList_Final_Burn()
    --arcane_missiles,if=buff.clearcasting.react,chain=1
    if cast.able.arcaneMissiles() 
    and getDistance("target") <= 40
    and buff.clearcasting.exists() then 
        if cast.arcaneMissiles() then br.addonDebug("Cast Arcane Missiles (Final Burn, Clearcasting)") return true end 
    end

    --arcane_blast
    if cast.able.arcaneBlast()
    and not moving
    and getDistance("target") <= 40
    then
        if cast.arcaneBlast() then br.addonDebug("Cast Arcane Blast (Final Burn)") return true end 
    end

    --arcane_barrage
    if cast.able.arcaneBarrage() 
    and getDistance("target") <= 40
    then
        if cast.arcaneBarrage() then br.addonDebug("Cast Arcane Barrage (Final Burn)") return true end 
    end

end -- End of Final Burn--]]


local function actionList_AoE()
    --actions.aoe=use_mana_gem,if=(talent.enlightened.enabled&mana.pct<=80&mana.pct>=65)|(!talent.enlightened.enabled&mana.pct<=85)
    if talent.enlightened
    and manaPercent <= 80 and manaPercent >= 60
    or not talent.enlightened 
    and manaPercent <= 85
    then
        if use.able.manaGem() then if use.manaGem() then br.addonDebug("[Action:AoE] Mana Gem (1)") return true end end 
    end

    --actions.aoe+=/lights_judgment,if=buff.arcane_power.down
    if ui.checked("Racial") and br.player.race == "LightforgedDraenei" or br.player.race == "Vulpera" 
    and not buff.arcanePower.exists()  
    and cast.able.racial()
    then 
      if cast.racial() then br.addonDebug("[Action:AoE] Racial (Arcane Power:Down) (2)")return true end
    end
    
    if ui.checked("Racial") 
    and buff.arcanePower.exists() 
    and cast.able.racial()
    and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf" or race == "MagharOrc")
    then
        if cast.racial() then br.addonDebug("[Action:AoE] Racial (Arcane Power:up) (3)") return true end
    end

    --actions.aoe+=/bag_of_tricks,if=buff.arcane_power.down

    --actions.aoe+=/call_action_list,name=items,if=buff.arcane_power.up

    --actions.aoe+=/potion,if=buff.arcane_power.up
    if isChecked("Potion") 
    and use.able.battlePotionOfIntellect() 
    and not buff.battlePotionOfIntellect.exists() 
    and buff.arcanePower.exists() 
    then
        if use.battlePotionOfIntellect() then br.addonDebug("[Action:AoE] Battle Potion of Intellect (4)") return true end
    end

    --actions.aoe+=/berserking,if=buff.arcane_power.up
    --actions.aoe+=/blood_fury,if=buff.arcane_power.up
    --actions.aoe+=/fireblood,if=buff.arcane_power.up
    --actions.aoe+=/ancestral_call,if=buff.arcane_power.up
    --actions.aoe+=/time_warp,if=runeforge.temporal_warp.equipped
    --actions.aoe+=/fire_blast,if=(runeforge.disciplinary_command.equipped&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down&prev_gcd.1.frostbolt)|(runeforge.disciplinary_command.equipped&time=0)
    --actions.aoe+=/frost_nova,if=runeforge.grisly_icicle.equipped&cooldown.arcane_power.remains>30&cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd))
    --actions.aoe+=/frost_nova,if=runeforge.grisly_icicle.equipped&cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down)
    --actions.aoe+=/touch_of_the_magi,if=runeforge.siphon_storm.equipped&prev_gcd.1.evocation
    --actions.aoe+=/arcane_power,if=runeforge.siphon_storm.equipped&(prev_gcd.1.evocation|prev_gcd.1.touch_of_the_magi)
    --actions.aoe+=/evocation,if=time>30&runeforge.siphon_storm.equipped&buff.arcane_charge.stack<=variable.aoe_totm_charges&cooldown.touch_of_the_magi.remains=0&cooldown.arcane_power.remains<=gcd
    --actions.aoe+=/evocation,if=time>30&runeforge.siphon_storm.equipped&cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down),interrupt_if=buff.siphon_storm.stack=buff.siphon_storm.max_stack,interrupt_immediate=1
    --actions.aoe+=/mirrors_of_torment,if=(cooldown.arcane_power.remains>45|cooldown.arcane_power.remains<=3)&cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>5)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>5)|cooldown.arcane_power.remains<=gcd))
    --actions.aoe+=/radiant_spark,if=cooldown.touch_of_the_magi.remains>variable.rs_max_delay&cooldown.arcane_power.remains>variable.rs_max_delay&(talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd|talent.rune_of_power.enabled&cooldown.rune_of_power.remains>variable.rs_max_delay|!talent.rune_of_power.enabled)&buff.arcane_charge.stack<=variable.aoe_totm_charges&debuff.touch_of_the_magi.down
    --actions.aoe+=/radiant_spark,if=cooldown.touch_of_the_magi.remains=0&(buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd))
    --actions.aoe+=/radiant_spark,if=cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down)
    --actions.aoe+=/deathborne,if=cooldown.arcane_power.remains=0&(((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down)
    -- SHADOWLANDS ^^



    --actions.aoe+=/touch_of_the_magi,if=buff.arcane_charge.stack<=variable.aoe_totm_charges&((talent.rune_of_power.enabled&cooldown.rune_of_power.remains<=gcd&cooldown.arcane_power.remains>variable.totm_max_delay)
    --|(!talent.rune_of_power.enabled&cooldown.arcane_power.remains>variable.totm_max_delay)|cooldown.arcane_power.remains<=gcd)
    if cast.able.touchOfTheMagi()
    and not moving
    and (arcaneCharges <= var.var_aoe_totm_charges
    and talent.runeofPower
    and cd.runeofPower.remain() <= gcdMax 
    and cd.arcanePower.remain() > var.var_totm_max_delay)
    or (talent.runeofPower and cd.arcanePower.remain() > var.var_totm_max_delay)
    or cd.arcanePower.remain() <= gcdMax
    then
        if cast.touchOfTheMagi() then br.addonDebug("[Action:AoE] Touch of the Magi (5)") return true end 
    end

    --actions.aoe+=/arcane_power,if=((cooldown.touch_of_the_magi.remains>variable.ap_max_delay&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&buff.rune_of_power.down
    if cast.able.arcanePower()
    and ((cd.touchOfTheMagi.remain() > var.var_ap_max_delay
    and arcaneCharges > 3))
    or ((cd.touchOfTheMagi.remain() == 0 
    and arcaneCharges <= var.var_aoe_totm_charges))
    and not buff.arcanePower.exists()
    then
        if cast.arcanePower() then br.addonDebug("[Action:AoE] Arcane Power (6)") return true end 
    end

    --actions.aoe+=/rune_of_power,if=buff.rune_of_power.down&((cooldown.touch_of_the_magi.remains>20&buff.arcane_charge.stack=buff.arcane_charge.max_stack)|(cooldown.touch_of_the_magi.remains=0&buff.arcane_charge.stack<=variable.aoe_totm_charges))&(cooldown.arcane_power.remains>15|debuff.touch_of_the_magi.up)
    if cast.able.runeofPower()
    and mode.rop ~= 2
    and not moving
    and cast.timeSinceLast.arcanePower() >= 15 or not cast.able.arcanePower() and not buff.runeofPower.exists()
    and not buff.runeofPower.exists()
    and ((cd.touchOfTheMagi.remain() > 20 
    and arcaneCharges > 3))
    or ((cd.touchOfTheMagi.remain() == 0
    and arcaneCharges <= var.var_aoe_totm_charges
    and cd.arcanePower.remain() > 15
    or debuff.touchoftheMagi.exists("target")))
    then
        if cast.runeofPower() then br.addonDebug("[Action:AoE] Rune of Power (7)") return true end
    end                                                                                                                     

    --actions.aoe+=/presence_of_mind,if=buff.deathborne.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time
   --[[ if cast.able.presenceofMind()
    and isKnown(spell.deathBorne)
    and buff.deathBorne.exists()
    and (debuff.touchoftheMagi.exists("target")
    and debuff.touchoftheMagi.remain("target") <= arcaneCharges * cast.time.arcaneBlast())
    then
        if cast.presenceofMind() then br.addonDebug("[Action:AoE] Presence of Mind (8)") return true end
    end--]]
    --Shadowlands

    --actions.aoe+=/arcane_blast,if=buff.deathborne.up&((talent.resonance.enabled&active_enemies<4)|active_enemies<5)
    --[[if cast.able.arcaneBlast()
    and isKnown(spell.deathBorne)
    and buff.deathBorne.exists()
    and ((talent.resonance and  #enemies.yards10t < 5 ))
    then
         if cast.arcaneBlast() then br.addonDebug("[Action:AoE] Arcane Blast (Deathborne) (9)") return true end
    end--]]
     --Shadowlands

    --actions.aoe+=/supernova
    if cast.able.supernova()
    and getDistance("target") < 40
    then
        if cast.supernova() then br.addonDebug("[Action:AoE] Supernova (10)") return true end 
    end

    --actions.aoe+=/arcane_orb,if=buff.arcane_charge.stack=0
    if cast.able.arcaneOrb()
    and arcaneCharges < 1
    then   
       if castarcaneOrb(1, true, 4) then br.addonDebug("[Action:AoE] Arcane Orb (11)") return true end
    end

    --actions.aoe+=/nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.netherTempest()
    and (debuff.netherTempest.refresh("target")
    or not debuff.netherTempest.exists("target"))
    and arcaneCharges > 3
    then
        if cast.netherTempest() then br.addonDebug("[Action:AoE] Nether Tempest (12)") return true end 
    end

    --actions.aoe+=/shifting_power,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&cooldown.arcane_power.remains>0&cooldown.touch_of_the_magi.remains>0&(!talent.rune_of_power.enabled|(talent.rune_of_power.enabled&cooldown.rune_of_power.remains>0))
    --[[if cast.able.shiftingPower()
    and not buff.arcanePower.exists()
    and not buff.runeofPower.exists()
    and not debuff.touchoftheMagi.exists("target")
    and cd.arcanePower.remain() > 0
    and cd.touchOfTheMagi.remain() > 0
    and not talent.runeofPower
    or talent.runeofPower and cd.runeofPower.remain() == 0
    then
         if cast.shiftingPower() then br.addonDebug("[Action:AoE] Shifting Power (13)") return true end 
    end--]]
    -- Shadowlands

    --actions.aoe+=/arcane_missiles,if=buff.clearcasting.react&runeforge.arcane_infinity.equipped&talent.amplification.enabled&active_enemies<6
    -- Shadowlands
    --actions.aoe+=/arcane_missiles,if=buff.clearcasting.react&runeforge.arcane_infinity.equipped&active_enemies<4
    -- Shadowlands
    --actions.aoe+=/arcane_explosion,if=buff.arcane_charge.stack<buff.arcane_charge.max_stack
    if cast.able.arcaneExplosion()
    and getDistance("target") <= 10
    and arcaneCharges > 3
    and #enemies.yards10tnc >= ui.value("Arcane Explosion Units")
   -- or not ui.checked("Arcane Explosion Units")
    then
        if cast.arcaneExplosion("player","aoe", 3, 10) then br.addonDebug("[Action:AoE] Arcane Explosion (14)") return true end 
    end

    --actions.aoe+=/arcane_explosion,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&prev_gcd.1.arcane_barrage
    if cast.able.arcaneExplosion()
    and getDistance("target") <= 10
    and arcaneCharges > 3
    and cast.last.arcaneBarrage() or cast.timeSinceLast.arcaneBarrage() < gcdMax
    and #enemies.yards10tnc >= ui.value("Arcane Explosion Units")
    --or not ui.checked("Arcane Explosion Units")
    then
        if cast.arcaneExplosion("player","aoe", 3, 10) then br.addonDebug("[Action:AoE] Arcane Explosion (prev cast Arcane Barrage) (15)") return true end 
    end

    --actions.aoe+=/arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage()
    and arcaneCharges > 3
    then
        if cast.arcaneBarrage() then br.addonDebug("[Action:AoE] Arcane Barrage (16)") return true end 
    end


    --actions.aoe+=/evocation,interrupt_if=mana.pct>=85,interrupt_immediate=1
    if manaPercent >= 85 and UnitCastingInfo("player") and buff.evocation.exists() then br.addonDebug("[Action:AoE] Cancel Evocation") SpellStopCasting() return true end

    if cast.able.evocation()
    and not buff.runeofPower.exists()
    and manaPercent <= ui.value("Evocation Mana Percent")
    then
        if cast.evocation() then br.addonDebug("[Action:AoE] Evocation (17)") return true end
    end
end-- End of AoE

local function actionList_Opener()
  -- --actions.opener=variable,name=have_opened,op=set,value=1,if=prev_gcd.1.evocat
  opener = true

  --actions.opener+=/lights_judgment,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
if br.player.race == "LightforgedDraenei" or br.player.race == "Vulpera" 
  and not buff.arcanePower.exists() 
  and not buff.runeofPower.exists() 
  and cast.able.Racial()
  and not debuff.touchoftheMagi.exists("target") 
  then 
      if cast.Racial() then return true end
  end
  --actions.opener+=/potion,if=buff.arcane_power.up
   

  --actions.opener+=/berserking,if=buff.arcane_power
    if ui.checked("Racial") 
    and buff.arcanePower.exists() 
    and (race == "Troll" or race == "Orc" or race == "DarkIronDwarf" or race == "MagharOrc")
    then
        if cast.racial() then br.addonDebug("Casting Berserking") return true end
    end

    --actions.opener+=/fire_blast,if=runeforge.disciplinary_command.equipped&buff.disciplinary_command_frost.up
    -- SHADOWLANDS
    --actions.opener+=/frost_nova,if=runeforge.grisly_icicle.equipped&mana.pct>95
    -- SHADOWLANDS
    --actions.opener+=/mirrors_of_torment
    -- SHADOWLANDS

    --actions.opener+=/deathborne
    -- SHADOWLANDS
    --if csst.able.deathBorne() then if cast.deathBorne() then return true end end 

    --actions.opener+=/radiant_spark,if=mana.pct>40
    -- SHADOWLANDS

    --actions.opener+=/cancel_action,if=action.shifting_power.channeling&gcd.remains=0

    --actions.opener+=/shifting_power,if=soulbind.field_of_blossoms.enabled

    --actions.opener+=/touch_of_the_magi
    if cast.able.touchOfTheMagi() and not moving then if cast.touchOfTheMagi() then return true end end 

    --actions.opener+=/arcane_power
    if cast.able.arcanePower() then if cast.arcanePower() then return true end end 

    --actions.opener+=/rune_of_power,if=buff.rune_of_power.down
   -- if cast.able.runeofPower() and not moving and cast.timeSinceLast.arcanePower() >= 15 or not cast.able.arcanePower() and not buff.runeofPower.exists()then if cast.runeofPower() then return true end end

    --actions.opener+=/use_mana_gem,if=(talent.enlightened.enabled&mana.pct<=80&mana.pct>=65)|(!talent.enlightened.enabled&mana.pct<=85)
    if use.able.manaGem()
    and (talent.enlightened and manaPercent <= 80 and manaPercent >= 60)
    or (not talent.enlightened and manaPercent <= 85)
    then
        if use.manaGem() then return true end
    end
        

    --actions.opener+=/berserking,if=buff.arcane_power.up

    --actions.opener+=/time_warp,if=runeforge.temporal_warp.equipped

    --actions.opener+=/presence_of_mind,if=debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time
    if cast.able.presenceofMind()
    and debuff.touchoftheMagi.exists("target")
    and debuff.touchoftheMagi.remain("target") <= 2 * cast.time.arcaneBlast() 
    then
        if cast.presenceofMind() then return true end
    end

    --actions.opener+=/arcane_blast,if=dot.radiant_spark.remains>5|debuff.radiant_spark_vulnerability.stack>0
    --[[if cast.able.arcaneBlast()
    and debuff.radiantSpark.remain("target") > 5
    or debuff.radiantSpark.stack("target") > 0
    then
        if cast.able.arcaneBlast() then return true end 
    end--]]
    
    --actions.opener+=/arcane_blast,if=buff.presence_of_mind.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=action.arcane_blast.execute_time
    if cast.able.arcaneBlast()
    and not moving
    and buff.presenceOfMind.exists()
    and debuff.touchoftheMagi.remain("target") < cast.time.arcaneBlast() 
    then
        if cast.arcaneBlast() then return true end
    end

    --actions.opener+=/arcane_barrage,if=buff.arcane_power.up&buff.arcane_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage()
    and buff.arcanePower.exists()
    and buff.arcanePower.remain() <= gcdMax 
    and arcaneCharges > 3
    then
        if cast.arcaneBarrage() then return true end 
    end

    --actions.opener+=/arcane_missiles,if=debuff.touch_of_the_magi.up&talent.arcane_echo.enabled&buff.deathborne.down&debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time,chain=1
    if cast.able.arcaneMissiles()
    and debuff.touchoftheMagi.exists("target")
    and talent.arcaneEcho 
    and not buff.deathBorne.exists()
    and debuff.touchoftheMagi.remain("target") > cast.time.arcaneMissiles()
    then
        if cast.arcaneMissiles() then return true end 
    end

    --actions.opener+=/arcane_missiles,if=buff.clearcasting.react,chain=1
    if cast.able.arcaneMissiles()
    and buff.clearcasting.exists()
    then
        if cast.arcaneMissiles() then return true end 
    end

    --actions.opener+=/arcane_orb,if=buff.arcane_charge.stack<=2&(cooldown.arcane_power.remains>10|active_enemies<=2)
    if cast.able.arcaneOrb()
    and arcaneCharges <= 2 or cd.arcanePower.remain() > 10 or aoeUnits <= 2
    then
       if castarcaneOrb(1, true, 4) then return true end
    end

    --actions.opener+=/arcane_blast,if=buff.rune_of_power.up|mana.pct>15
    if cast.able.arcaneBlast()
    and not moving
    and buff.runeofPower.exists()
    or manaPercent > 15
    and ui.checked("Arcane Explosion Units") and aoeUnits >= ui.value("Arcane Explosion Units")
    or not ui.checked("Arcane Explosion Units")
    then
        if cast.arcaneBlast() then return true end
    end

    --actions.opener+=/evocation,if=buff.rune_of_power.down,interrupt_if=mana.pct>=85,interrupt_immediate=1
    if manaPercent >= 85 and buff.evocation.exists() then SpellStopCasting() return end 

    if cast.able.evocation()
    and not buff.runeofPower.exists()
    and manaPercent < ui.value("Evocation Mana Percent")
    then
        if cast.evocation() then return true end
    end

    --actions.opener+=/arcane_barrage
    if cast.able.arcaneBarrage() then if cast.arcaneBarrage() then br.addonDebug("Arcane Barrage Opener") return true end end 
end-- End of Opener

local function actionList_BurnPhase()
    -- Arcane Barrage
   --[[ if cast.able.arcaneBarrage()
    and arcaneCharges == 4
    and cd.touchOfTheMagi.remain() <= gcdMax
    then
        if cast.arcaneBarrage() then br.addonDebug("[Action:Burn] Arcane Barrage (4 Charges, TOTM Up)") return true end 
    end--]]

    -- Arcane Missiles
    if cast.able.arcaneMissiles()
    and buff.clearcasting.exists()
    then
        if cast.arcaneMissiles() then br.addonDebug("[Action:Burn] Arcane Missiles (Clearcasting)") return true end 
    end

    -- Arcane Blast
    if cast.able.arcaneBlast() then if cast.arcaneBlast() then br.addonDebug("[Action:Burn] Arcane Blast") return true end end 

    -- Evocation
    if manaPercent >= 85 and UnitCastingInfo("player") and buff.evocation.exists() then br.addonDebug("[Action:Rotation] Cancel Evocation") SpellStopCasting() return true end
     --  if UnitCastingInfo("player") == GetSpellInfo(spell.evocation) and manaPercent >= 83 then CancelUnitBuff("player", GetSpellInfo(spell.evocation)) br.addonDebug("Canceled Evo") return true end
    if cast.able.evocation() and manaPercent <= ui.value("Evocation Mana Percent") then
        if cast.evocation() then br.addonDebug("[Action:Burn] Casting Evocation") return true end
    end

    -- Reset Arcane Charges 
    --[[if cast.able.arcaneBarrage() and manaPercent < var_barrage_mana_pct and cd.evocation.remain() > gcdMax and not buff.arcanePower.exists() and arcaneCharges > 3 then
       if cast.arcaneBarrage() then return true end 
    end--]]

end-- End of Burn Phase

local function actionList_Rotation()
    --actions.rotation=variable,name=final_burn,op=set,value=1,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&!buff.rule_of_threes.up&target.time_to_die<=((mana%action.arcane_blast.cost)*action.arcane_blast.execute_time)
    if cast.able.arcaneBlast()
    and not moving
    and arcaneCharges > 3 
    and not buff.ruleOfThrees.exists() 
    and getTTD("target") <= (( power / 275))*cast.time.arcaneBlast()
    then
        if cast.arcaneBlast() then br.addonDebug("Casting Arcane Missiles (Starting FInal Burn)") finalBurn = true return true end
    end

    --aactions.rotation+=/arcane_blast,if=buff.presence_of_mind.up&debuff.touch_of_the_magi.up&debuff.touch_of_the_magi.remains<=action.arcane_blast.execute_tim
    if cast.able.arcaneBlast() 
    and not moving
    and buff.presenceOfMind.exists() 
    and debuff.touchoftheMagi.exists("target") 
    and debuff.touchoftheMagi.remain("target") <= cast.time.arcaneBlast() 
    then
        if cast.arcaneBlast() then br.addonDebug("Casting Arcane Blast (PoM, Magi)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=debuff.touch_of_the_magi.up&talent.arcane_echo.enabled&buff.deathborne.down&(debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time|cooldown.presence_of_mind.remains>0|covenant.kyrian.enabled),chain=1
    if cast.able.arcaneMissiles() 
    and debuff.touchoftheMagi.exists("target") 
    and talent.arcaneEcho 
    and not buff.deathBorne.exists() 
    and debuff.touchoftheMagi.remain("target") > cast.time.arcaneMissiles() or cd.presenceofMind.remain() > 0 
    then
       if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clear casting + expanded potential)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.expanded_potential.up
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.expandedPotential.exists() 
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clear casting + expanded potential)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&(buff.arcane_power.up|buff.rune_of_power.up|debuff.touch_of_the_magi.remains>action.arcane_missiles.execute_time),chain=1
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.arcanePower.exists() 
    and buff.runeofPower.exists() 
    and debuff.touchoftheMagi.remain("target") > cast.time.arcaneMissiles() 
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (Clearcasting + RoP, AP, + Magi Debuff)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.stack=buff.clearcasting.max_stack,chain=1
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.clearcasting.stack() == var.ccMaxStack 
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clearcasting max stack)") return true end
    end

    --actions.rotation+=/arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.remains<=((buff.clearcasting.stack*action.arcane_missiles.execute_time)+gcd),chain=1
    if cast.able.arcaneMissiles() 
    and buff.clearcasting.exists() 
    and buff.clearcasting.remain() <= ((buff.clearcasting.stack() * cast.time.arcaneMissiles()) + gcdMax)
    then
        if cast.arcaneMissiles() then br.addonDebug("Casting Arcane Missiles (clearcasting)")  return true end 
    end

    -- actions.rotation+=/nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.arcane_power.down&debuff.touch_of_the_magi.down
    if cast.able.netherTempest() 
    and debuff.netherTempest.refresh("target") or not debuff.netherTempest.exists("target") 
    and arcaneCharges > 3 and not buff.arcanePower.exists() 
    and not debuff.touchoftheMagi.exists("target") 
    then
        if cast.netherTempest() then br.addonDebug("Casting Nether Tempest") return true end
    end

    -- actions.rotation+=/arcane_orb,if=buff.arcane_charge.stack<=2
    if cast.able.arcaneOrb() and arcaneCharges <= 2 then if castarcaneOrb(1, true, 4) then br.addonDebug("Arcane Orb <=2 AC") return true end end

    -- actions.rotation+=/supernova,if=mana.pct<=95&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down
    if cast.able.supernova()
    and manaPercent <= 95 
    and not buff.arcanePower.exists() 
    and not buff.runeofPower.exists() 
    and not debuff.touchoftheMagi.exists("target") 
    then
       if cast.supernova() then br.addonDebug("Casting Supernova (no AP, No RoP, no Magi)") return true end 
    end
    
    -- actions.rotation+=/shifting_power,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&cooldown.evocation.remains>0&cooldown.arcane_power.remains>0&cooldown.touch_of_the_magi.remains>0&(!talent.rune_of_power.enabled|(talent.rune_of_power.enabled&cooldown.rune_of_power.remains>0))
    --if cast.able.shiftingPower() and not buff.arcanePower.exists() and not buff.runeofPower.exists() 
    --and not debuff.touchoftheMagi.exists("target") and cd.evocation.remain()  > 0 and cd.arcanePower.remain() > 0 and cd.touchOfTheMagi.remain() > 0 and not talent.runeofPower or talent.runeofPower and cd.runeofPower.remain() > 0 then
    --    if cast.shiftingPower() then return true end
    --end

    -- actions.rotation+=/arcane_blast,if=buff.rule_of_threes.up&buff.arcane_charge.stack>3
    if cast.able.arcaneBlast() 
    and not moving
    and buff.ruleOfThrees.exists() 
    and arcaneCharges > 3 then
        if cast.arcaneBlast() then return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=mana.pct<variable.barrage_mana_pct&cooldown.evocation.remains>0&buff.arcane_power.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&essence.vision_of_perfection.minor
    if cast.able.arcaneBarrage() and manaPercent < var.var_barrage_mana_pct and cd.evocation.remain() <= gcdMax and not buff.arcanePower.exists() and arcaneCharges > 3 then
       if cast.arcaneBarrage() then br.addonDebug("[Mode:Rotation] Arcane Barrage 1") return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=cooldown.touch_of_the_magi.remains=0&(cooldown.rune_of_power.remains=0|cooldown.arcane_power.remains=0)&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and cd.touchOfTheMagi.remain() <= gcdMax and cd.runeofPower.remain() <= gcdMax or cd.arcanePower.remain() <= gcdMax and arcaneCharges > 3 then
       if cast.arcaneBarrage() then br.addonDebug("[Mode:Rotation] Arcane Barrage 2") return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=mana.pct<=variable.barrage_mana_pct&buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&cooldown.evocation.remains>0
    if cast.able.arcaneBarrage() and manaPercent < var.var_barrage_mana_pct and not buff.arcanePower.exists() and not buff.arcanePower.exists() 
    and not debuff.touchoftheMagi.exists("target") and arcaneCharges > 3 and cd.evocation.remain() > 0 then
        if cast.arcaneBarrage() then br.addonDebug("[Mode:Rotation] Arcane Barrage 3") return true end 
    end

    -- actions.rotation+=/arcane_barrage,if=buff.arcane_power.down&buff.rune_of_power.down&debuff.touch_of_the_magi.down&buff.arcane_charge.stack=buff.arcane_charge.max_stack&talent.arcane_orb.enabled&cooldown.arcane_orb.remains<=gcd&mana.pct<=90&cooldown.evocation.remains>0
    if cast.able.arcaneBarrage() and not buff.arcanePower.exists() and not buff.runeofPower.exists() and not debuff.touchoftheMagi.exists("target")
    and arcaneCharges > 3 and talent.arcaneOrb and cd.arcaneOrb.remain() <= gcdMax and manaPercent <= 90 and cd.evocation.remain() > 0 then
        if cast.arcaneBarrage() then br.addonDebug("[Mode:Rotation] Arcane Barrage 4") return true end 
    end

    --actions.rotation+=/arcane_barrage,if=buff.arcane_power.up&buff.arcane_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and buff.arcanePower.exists() and buff.arcanePower.remain() <= gcd and arcaneCharges > 3 then
        if cast.arcaneBarrage() then br.addonDebug("[Mode:Rotation] Arcane Barrage 5") return true end 
    end

    --actions.rotation+=/arcane_barrage,if=buff.rune_of_power.up&buff.rune_of_power.remains<=gcd&buff.arcane_charge.stack=buff.arcane_charge.max_stack
    if cast.able.arcaneBarrage() and buff.runeofPower.exists() and buff.runeofPower.remain() <= gcd and arcaneCharges > 3 then
        if cast.arcaneBarrage() then br.addonDebug("[Mode:Rotation] Arcane Barrage 6") return true end 
    end

    -- actions.rotation+=/arcane_blast
    if cast.able.arcaneBlast() and not moving then if cast.arcaneBlast() then return true end

    -- Cancel Evocation 
    --actions.aoe+=/evocation,interrupt_if=mana.pct>=85,interrupt_immediate=1
    if manaPercent >= 85 and UnitCastingInfo("player") and buff.evocation.exists() then br.addonDebug("[Action:Rotation] Cancel Evocation") SpellStopCasting() return true end
  --  if UnitCastingInfo("player") == GetSpellInfo(spell.evocation) and manaPercent >= 83 then CancelUnitBuff("player", GetSpellInfo(spell.evocation)) br.addonDebug("Canceled Evo") return true end
    if cast.able.evocation() and manaPercent <= ui.value("Evocation Mana Percent") then
        if cast.evocation() then br.addonDebug("Casting Evocation (>= 85 mana)") return true end end -- Somehow cancel at 85% max mana
    end

    --actions.rotation+=/arcane_barrage
    if cast.able.arcaneBarrage() then if cast.arcaneBarrage() then br.addonDebug("[Mode:Rotation] Arcane Barrage 7") return true end end 
end-- End of Rotation

    -----------------------
    --- Extras Rotation ---
    -----------------------
    if actionList_Extras() then return true end
    --if ActionList_PreCombat() then return true end 
-----------------
--- Rotations ---
-----------------
    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif (inCombat and profileStop == true) or UnitChannelInfo("player") or IsMounted() or IsFlying() or pause(true) or isCastingSpell(293491) then
        if not pause(true) and IsPetAttackActive() and isChecked("Pet Management") then
            PetStopAttack()
            PetFollow()
        end
        return true
    else
         if (inCombat or cast.inFlight.arcaneMissiles() or targetUnit) and profileStop == false and targetUnit then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then
                return true
            end

        if getOptionValue("APL Mode") == 1 then
            if aoeUnits >= 2 then if actionList_AoE() then return end end 

            -----------------------
            ---     Opener      ---
            -----------------------
        if spellQueueReady() then

            if moving then if actionList_Movement() then return end end

            --[[if opener == false and ui.checked("Opener") and isBoss("target") or getTTD("target") >= 20 or isDummy() then
                if actionList_Opener() then return true end
            end--]]

            if useCDs() and isBoss("target") or getTTD("target") >= 20 or isDummy() then
                if actionList_Cooldowns() then return end
            end

          --  if finalBurn == false then

            if mode.fb == 1 and cd.evocation.remain() > 30 then
                if actionList_Rotation() then return end
            end

            if mode.fb == 3 then if actionList_Rotation() then return end end
        ---   end

            if mode.fb == 1 or mode.fb == 2 and cd.evocation.remain() <= 30 then
                if actionList_BurnPhase() then return end 
            end
        end

            if getOptionValue("APL Mode") == 2 then
                if actionList_Leveling() then
                    return true
                end
            end
        end -- End Spell Queue Ready
            -- Movement Rotation
            --if isMoving() then if actionList_Movement() then return end end
        end -- End In Combat Rotation

        end -- Pause
    --end -- End Timer
end -- End runRotation 
local id = 62
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

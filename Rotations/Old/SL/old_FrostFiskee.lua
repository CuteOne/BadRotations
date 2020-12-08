local rotationName = "Fiskee"
local targetMoveCheck, opener, fbInc = false, false, false
local lastTargetX, lastTargetY, lastTargetZ
local ropNotice = false
local lastIF = 0
local if5Start, if5End = 0, 0
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.frozenOrb},
        [2] = {mode = "Sing", value = 2, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.frostbolt},
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.icyVeins},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.icyVeins},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.frostbolt},
        [4] = {mode = "Lust", value = 4, overlay = "Cooldowns With Lust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.icyVeins}
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceBarrier},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceBarrier}
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
    }
    CreateButton("Interrupt", 4, 0)
    -- Frozen Orb Button
    FrozenOrbModes = {
        [1] = {mode = "On", value = 1, overlay = "Auto FO Enabled", tip = "Will Automatically use Frozen Orb", highlight = 1, icon = br.player.spell.frozenOrb},
        [2] = {mode = "Off", value = 2, overlay = "Auto FO Disabled", tip = "Will not use Frozen Orb", highlight = 0, icon = br.player.spell.frozenOrb}
    }
    CreateButton("FrozenOrb", 5, 0)
    -- Ebonbolt Button
    EbonboltModes = {
        [1] = {mode = "On", value = 1, overlay = "Ebonbolt Enabled", tip = "Will use Ebonbolt", highlight = 1, icon = br.player.spell.ebonbolt},
        [2] = {mode = "Off", value = 2, overlay = "Ebonbolt Disabled", tip = "Will not use Ebonbolt", highlight = 0, icon = br.player.spell.ebonbolt}
    }
    CreateButton("Ebonbolt", 6, 0)
    -- Comet Storm Button
    CometStormModes = {
        [1] = {mode = "On", value = 1, overlay = "Comet Storm Enabled", tip = "Will use Comet Storm", highlight = 1, icon = br.player.spell.cometStorm},
        [2] = {mode = "Off", value = 2, overlay = "Comet Storm Disabled", tip = "Will not use Comet Storm", highlight = 0, icon = br.player.spell.cometStorm}
    }
    CreateButton("CometStorm", 7, 0)
    -- Comet Storm Button
    ConeOfColdModes = {
        [1] = {mode = "On", value = 1, overlay = "Cone Of Cold Enabled", tip = "Will use Cone Of Cold", highlight = 1, icon = br.player.spell.coneOfCold},
        [2] = {mode = "Off", value = 2, overlay = "Cone Of Cold Disabled", tip = "Will not use Cone Of Cold", highlight = 0, icon = br.player.spell.coneOfCold}
    }
    CreateButton("ConeOfCold", 1, 1)
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
        section = br.ui:createSection(br.ui.window.profile, "General - 10152020")
        -- APL
        br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFBB00SimC", "|cffFFBB00Leveling", "|cffFFBB00Ice Lance Spam"}, 1, "|cffFFBB00Set APL Mode to use.")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFBB00Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
        br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffFFBB00Will precast Frostbolt on pull if pulltimer is active")
        -- Opener
        --br.ui:createCheckbox(section,"Opener")
        -- Pet Management
        br.ui:createCheckbox(section, "Pet Management", "|cffFFBB00 Select to enable/disable auto pet management")
        br.ui:checkSectionState(section)

        ------------------------
        ---   DPS SETTINGS   ---
        ------------------------
       section = br.ui:createSection(br.ui.window.profile, "DPS Settings")
        -- Blizzard Units
        br.ui:createSpinnerWithout(section, "Blizzard Units", 2, 1, 10, 1, "|cffFFBB00Min. number of units Blizzard will be cast on.")
        -- Frozen Orb Units
        br.ui:createSpinnerWithout(section, "Frozen Orb Units", 3, 1, 10, 1, "|cffFFBB00Min. number of units Frozen Orb will be cast on.")
        -- Arcane Explosion Units
        br.ui:createSpinner(section, "Arcane Explosion Units", 2, 1, 10, 1, "|cffFFB000 Number of adds to cast Arcane Explosion")
        -- Frozen Orb Key
        br.ui:createDropdown(section, "Frozen Orb Key", br.dropOptions.Toggle, 6, "|cffFFFFFFSet key to manually use Frozen Orb")
        -- Comet Storm Units
        br.ui:createSpinnerWithout(section, "Comet Storm Units", 2, 1, 10, 1, "|cffFFBB00Min. number of units Comet Storm will be cast on.")
        -- Casting Interrupt Delay
        br.ui:createSpinner(section, "Casting Interrupt Delay", 0.3, 0, 1, 0.1, "|cffFFBB00Activate to delay interrupting own casts to use procs.")
        -- Casting Interrupt Delay
        br.ui:createCheckbox(section, "No Ice Lance", "|cffFFBB00Use No Ice Lance Rotation.")        
        -- Predict movement
        --br.ui:createCheckbox(section, "Disable Movement Prediction", "|cffFFBB00 Disable prediction of unit movement for casts")
        -- Auto target
        -- br.ui:createCheckbox(section, "Auto Target", "|cffFFBB00 Will auto change to a new target, if current target is dead")
        br.ui:checkSectionState(section)

        -- ------------------------
        -- ---     ESSENCES     ---
        -- ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Essences")
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
        ---     UTILITY      ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Utility")
        -- Spellsteal
        br.ui:createCheckbox(section, "Spellsteal", "|cffFFBB00 Will use Spellsteal, delay can be changed using dispel delay in healing engine")
        -- Remove Curse
        br.ui:createDropdown(section, "Remove Curse", {"|cff00FF00Player","|cffFFFF00Target","|cffFFBB00Player/Target","|cffFF0000Mouseover","|cffFFBB00Any"}, 1, "","|ccfFFFFFFTarget to cast on, set delay in healing engine settings")
        -- Arcane Intellect
        br.ui:createCheckbox(section, "Arcane Intellect", "|cffFFBB00 Will use Arcane Intellect")
        -- Slow Fall
        br.ui:createSpinner(section, "Slow Fall Distance", 30, 0, 100, 1, "|cffFFBB00 Will cast slow fall based on the fall distance")                
        br.ui:checkSectionState(section)

        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
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
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 60, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
        end
        -- Ice Barrier
        br.ui:createSpinner(section, "Ice Barrier", 80, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
        -- Ice Barrier OOC
        br.ui:createCheckbox(section, "Ice Barrier OOC", "|cffFFBB00Keep Ice Barrier up out of combat")
        -- Ice Block
        br.ui:createSpinner(section, "Ice Block", 20, 0, 100, 5, "|cffFFBB00Health Percent to Cast At")
        --Dispel
        --br.ui:createCheckbox(section, "Auto Dispel/Purge", "|cffFFBB00 Auto dispel/purge in m+, based on whitelist, set delay in healing engine settings")
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
    ---------------
    --- Toggles ---
    ---------------
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    br.player.ui.mode.frozenOrb = br.data.settings[br.selectedSpec].toggles["FrozenOrb"]
    br.player.ui.mode.cometStorm = br.data.settings[br.selectedSpec].toggles["CometStorm"]
    br.player.ui.mode.ebonbolt = br.data.settings[br.selectedSpec].toggles["Ebonbolt"]
    br.player.ui.mode.coc = br.data.settings[br.selectedSpec].toggles["ConeOfCold"]
    --------------
    --- Locals ---
    --------------
    local activePet = br.player.pet
    local activePetId = br.player.petId
    local artifact = br.player.artifact
    local buff = br.player.buff
    local cast = br.player.cast
    local castable = br.player.cast.debug
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local deadMouse = UnitIsDeadOrGhost("mouseover")
    local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local essence = br.player.essence
    local equiped = br.player.equiped
    local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
    local friendly = GetUnitIsFriend("target", "player")
    local gcd = br.player.gcd
    local gcdMax = br.player.gcdMax
    local hasMouse = GetObjectExists("mouseover")
    local hasteAmount = GetHaste() / 100
    local hasPet = IsPetActive()
    local healPot = getHealthPot()
    local heirloomNeck = 122663 or 122664
    local inCombat = isInCombat("player")
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local lastSpell = lastSpellCast
    local level = br.player.level
    local lootDelay = getOptionValue("LootDelay")
    local manaPercent = br.player.power.mana.percent()
    local mode = br.player.ui.mode
    local moving = isMoving("player") ~= false or br.player.moving
    local pet = br.player.pet.list
    local php = br.player.health
    local playerCasting = UnitCastingInfo("player")
    local playerMouse = UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer = PullTimerRemain()
    local race = br.player.race
    local solo = br.player.instance == "none"
    local spell = br.player.spell
    local talent = br.player.talent
    local targetUnit = nil
    local thp = getHP("target")
    local travelTime = getDistance("target") / 50 --Ice lance
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local use = br.player.use
    local reapingDamage = getOptionValue("Reaping Flames Damage") * 1000

    -- Super scuffed IF tracker
    local curIF = select(3,AuraUtil.FindAuraByName(GetSpellInfo(116267), "player", "HELPFUL"))
    if curIF then
        if curIF ~= lastIF then
            if curIF == 1 and lastIF == 2 then
                if5Start = GetTime() + 5
                if5End = GetTime() + 7 - 0.1
            end
            lastIF = curIF
        end
    else
        if5Start = 0
        if5End = 0
    end
    local function ifCheck()
        if if5Start ~= 0 and isChecked("No Ice Lance") then
            --cast_time+travel_time>incanters_flow_time_to.5.up&cast_time+travel_time<incanters_flow_time_to.4.down
            local hitTime = GetTime() + cast.time.glacialSpike() + getDistance("target") / 40
            if hitTime > if5Start and hitTime < if5End then
                return true
            end
        end
        return false
    end

    -- Show/Hide toggles
    if not UnitAffectingCombat("player") then
        if not talent.cometStorm then
            buttonCometStorm:Hide()
        else
            buttonCometStorm:Show()
        end
        if not talent.ebonbolt then
            buttonEbonbolt:Hide()
        else
            buttonEbonbolt:Show()
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

    -- Ice Floes
    if moving and talent.iceFloes and buff.iceFloes.exists() then
        moving = false
    end

    --rop notice
    if not ropNotice and talent.runeOfPower then
        print("Rune Of Power talent not supported in rotation yet, use manually")
        ropNotice = true
    elseif ropNotice and not talent.runeOfPower then
        ropNotice = false
    end

    --buff cache locals
    local fofExists = buff.fingersOfFrost.exists()
    local bfExists = buff.brainFreeze.exists()
    local iciclesStack = buff.icicles.stack()

    if isCastingSpell(spell.frostbolt) then
        iciclesStack = iciclesStack + 1
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
    --is frozen
    local function isFrozen(unit)
        local function getRawDistance(unit)
            local x1, y1, z1 = ObjectPosition("player")
            local x2, y2, z2 = ObjectPosition(unit)
            return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2) + ((z2 - z1) ^ 2))
        end
        local distance = getRawDistance(unit)
        local travelTime = distance / 50 + 0.15 --Ice lance
        if buff.fingersOfFrost.remain() > (gcd + travelTime) or debuff.frostNova.remain(unit, "any") > (gcd + travelTime) or debuff.iceNova.remain(unit, "any") > (gcd + travelTime) or debuff.wintersChill.remain(unit) > (gcd + travelTime) then
            return true
        end
        return false
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
                if getOptionValue("APL Mode") == 2 then
                    enemyUnit.frozen = isFrozen(thisUnit)
                end
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

    --blizzard check
    local blizzardUnits = 0
    for i = 1, #enemies.yards10tnc do
        local thisUnit = enemies.yards10tnc[i]
        if ttd(thisUnit) > 4 then
            blizzardUnits = blizzardUnits + 1
        end
    end

    --
    local function castFrozenOrb(minUnits, safe, minttd)
        if not isKnown(spell.frozenOrb) or getSpellCD(spell.frozenOrb) ~= 0 or mode.frozenOrb ~= 1 then
            return false
        end  
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
            CastSpellByName(GetSpellInfo(spell.frozenOrb))
            return true
        else
            return false
        end
    end

    --Clear last cast table ooc to avoid strange casts
    if not inCombat and #br.lastCast.tracker > 0 then
        wipe(br.lastCast.tracker)
    end

    ---Target move timer
    if lastTargetX == nil then
        lastTargetX, lastTargetY, lastTargetZ = 0, 0, 0
    end
    if br.timer:useTimer("targetMove", 0.8) or combatTime < 0.2 then
        if UnitIsVisible("target") then
            local currentX, currentY, currentZ = ObjectPosition("target")
            local targetMoveDistance = math.sqrt(((currentX - lastTargetX) ^ 2) + ((currentY - lastTargetY) ^ 2) + ((currentZ - lastTargetZ) ^ 2))
            lastTargetX, lastTargetY, lastTargetZ = ObjectPosition("target")
            if targetMoveDistance < 3 then
                targetMoveCheck = true
            else
                targetMoveCheck = false
            end
        end
    end
    --Tank move check for aoe
    local tankMoving = false
    if inInstance then
        for i = 1, #br.friend do
            if (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and isMoving(br.friend[i].unit) then
                tankMoving = true
            end
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

    local function actionList_Extras()
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
        --Ice Barrier
        if not IsResting() and not inCombat and not playerCasting and isChecked("Ice Barrier OOC") then
            if cast.iceBarrier("player") then
                return true
            end
        end
        --Pet assist
        if isChecked("Pet Management") and UnitIsVisible("pet") and not petFollowActive() and (not inCombat or getDistance("target", "pet") > 40) then
            PetFollow()
        end
        -- Spell Steal
        if isChecked("Spellsteal") and inCombat then
            for i = 1, #enemyTable40 do
                if spellstealCheck(enemyTable40[i].unit) then
                    if cast.spellsteal(enemyTable40[i].unit) then return true end
                end
            end
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
            if isChecked("Ice Barrier") and not playerCasting and php <= getOptionValue("Ice Barrier") then
                if cast.iceBarrier("player") then
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
            if getDistance("target") < 12 and not isBoss("target") then
                if cast.frostNova("player") then
                    return true
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

    local function actionList_RoP()
        -- # With Glacial Spike, Rune of Power should be used right before the Glacial Spike combo (i.e. with 5 Icicles and a Brain Freeze). When Ebonbolt is off cooldown, Rune of Power can also be used just with 5 Icicles.
        -- actions.talent_rop=rune_of_power,if=talent.glacial_spike.enabled&buff.icicles.stack=5&(buff.brain_freeze.react|talent.ebonbolt.enabled&cooldown.ebonbolt.remains<cast_time)
        -- # Without Glacial Spike, Rune of Power should be used before any bigger cooldown (Ebonbolt, Comet Storm, Ray of Frost) or when Rune of Power is about to reach 2 charges.
        -- actions.talent_rop+=/rune_of_power,if=!talent.glacial_spike.enabled&(talent.ebonbolt.enabled&cooldown.ebonbolt.remains<cast_time|talent.comet_storm.enabled&cooldown.comet_storm.remains<cast_time|talent.ray_of_frost.enabled&cooldown.ray_of_frost.remains<cast_time|charges_fractional>1.9)
    end

    -- Essences
    local function actionList_Essences()
        -- actions.cooldowns=guardian_of_azeroth
        if isChecked("Guardian of Azeroth") and cast.able.guardianOfAzeroth() and (getOptionValue("Use Essences") == 1 or (getOptionValue("Use Essences") == 2 and useCDs())) then
            if cast.guardianOfAzeroth() then return true end
        end
        -- actions.essences=focused_azerite_beam,if=buff.rune_of_power.down|active_enemies>3
        if standingTime > 1 and isChecked("Focused Azerite Beam") and cast.able.focusedAzeriteBeam() and (getOptionValue("Use Essences") == 1 or (getOptionValue("Use Essences") == 2 and useCDs())) and essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remains() <= gcd and ((essence.focusedAzeriteBeam.rank < 3 and not moving) 
        or essence.focusedAzeriteBeam.rank >= 3) and not buff.runeOfPower.exists("player") and getFacing("player","target") and (getEnemiesInRect(10,25,false,false) >= getOptionValue("Focused Azerite Beam") or ((getEnemiesInRect(10,40,false,false) >= 1 or (getDistance("target") < 6 and isBoss("target")))))
        then
            if cast.focusedAzeriteBeam() then return true end
        end
        -- actions.essences+=/memory_of_lucid_dreams,if=active_enemies<5&(buff.icicles.stack<=1|!talent.glacial_spike.enabled)&cooldown.frozen_orb.remains>10
        if isChecked("Memory of Lucid Dreams") and cast.able.memoryOfLucidDreams() and (getOptionValue("Use Essences") == 1 or (getOptionValue("Use Essences") == 2 and useCDs())) and blizzardUnits < 5 and (iciclesStack <= 1 or not talent.glacialSpike) and cd.frozenOrb.remain() > 10 and useCDs() then
            if cast.memoryOfLucidDreams("player") then return true end
        end
        -- actions.essences+=/blood_of_the_enemy,if=(talent.glacial_spike.enabled&buff.icicles.stack=5&(buff.brain_freeze.react|prev_gcd.1.ebonbolt))|((active_enemies>3|!talent.glacial_spike.enabled)&(prev_gcd.1.frozen_orb|ground_aoe.frozen_orb.remains>5))
        
        if isChecked("Purifying Blast") and cast.able.purifyingBlast() and (getOptionValue("Use Essences") == 1 or (getOptionValue("Use Essences") == 2 and useCDs())) and blizzardUnits > 3 or not buff.runeOfPower.exists() then
            -- actions.essences+=/purifying_blast,if=buff.rune_of_power.down|active_enemies>3
                if cast.purifyingBlast("target") then return true end
        end
                -- actions.essences+=/ripple_in_space,if=buff.rune_of_power.down|active_enemies>3
        if isChecked("Ripple in Space") and cast.able.rippleInSpace() and (getOptionValue("Use Essences") == 1 or (getOptionValue("Use Essences") == 2 and useCDs())) and blizzardUnits > 3 or not buff.runeOfPower.exists() then
                if cast.rippleInSpace("target") then return true end 
        end
                -- actions.essences+=/worldvein_resonance,if=buff.rune_of_power.down|active_enemies>3
        if isChecked("Worldvein Resonance") and cast.able.worldveinResonance() and (getOptionValue("Use Essences") == 1 or (getOptionValue("Use Essences") == 2 and useCDs())) and blizzardUnits > 3 or not buff.runeOfPower.exists() then
                if cast.worldveinResonance("target") then return true end
        end
            -- actions.essences+=/concentrated_flame,line_cd=6,if=buff.rune_of_power.down
        if isChecked("Concentrated Flame DPS") and cast.able.concentratedFlame() and essence.concentratedFlame.active and cd.concentratedFlame.remain() <= gcd and (not debuff.concentratedFlame.exists("target") and not cast.last.concentratedFlame()
        or charges.concentratedFlame.timeTillFull() < gcd) and not buff.runeOfPower.exists("player") then
            if cast.concentratedFlame("target") then return true end
        end
        if isChecked("Concentrated Flame HP") and cast.able.concentratedFlame() and cd.concentratedFlame.remain() <= gcd and php <= getValue("Concentrated Flame HP") then
            if cast.concentratedFlame("player") then return true end
        end
        -- actions.essences+=/the_unbound_force,if=buff.reckless_force.up
        if isChecked("The Unbound Force") and cast.able.theUnboundForce() and buff.recklessForce.exists() and (getOptionValue("Use Essences") == 1 or (getOptionValue("Use Essences") == 2 and useCDs())) then
            if cast.theUnboundForce("target") then return true end
        end
        --actions.essences+=/reaping_flames,if=buff.rune_of_power.down
		for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            local distance = getDistance(thisUnit)
                if isChecked("Reaping Flames") and cast.able.reapingFlames(thisUnit) and not buff.runeOfPower.exists("player") and (getOptionValue("Reaping Flames") == 1) then
                    if cast.reapingFlames(thisUnit) then
                        br.addonDebug("Reaping 1")
                        return
                    end
                elseif isChecked("Reaping Flames") and cast.able.reapingFlames(thisUnit) and not buff.runeOfPower.exists("player") and getOptionValue("Reaping Flames") == 2 and (buff.reapingFlames.exists("player") and (UnitHealth(thisUnit) <= reapingDamage*2)) or (not buff.reapingFlames.exists("player") and (UnitHealth(thisUnit) <= reapingDamage)) then
                    if cast.reapingFlames(thisUnit) then
                        br.addonDebug("Reaping Snipe")
                        return
                    end
                end
        end     
    end

    local function actionList_Cooldowns()
        if useCDs() and not moving and targetUnit.ttd >= getOptionValue("Cooldowns Time to Die Limit") then
            -- actions.cooldowns=icy_veins
            if cast.icyVeins("player") then return true end
            -- actions.cooldowns+=/potion,if=prev_gcd.1.icy_veins|target.time_to_die<30
            if isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (cast.last.icyVeins() or ttd("target") < 30) then
                use.battlePotionOfIntellect()
                return true
            end
            -- -- actions.cooldowns+=/mirror_image
            -- if cast.mirrorImage("player") then return true end
            -- # Rune of Power is always used with Frozen Orb. Any leftover charges at the end of the fight should be used, ideally if the boss doesn't die in the middle of the Rune buff.
            -- actions.cooldowns+=/rune_of_power,if=prev_gcd.1.frozen_orb|target.time_to_die>10+cast_time&target.time_to_die<20
            -- # On single target fights, the cooldown of Rune of Power is lower than the cooldown of Frozen Orb, this gives extra Rune of Power charges that should be used with active talents, if possible.
            -- actions.cooldowns+=/call_action_list,name=talent_rop,if=talent.rune_of_power.enabled&active_enemies=1&cooldown.rune_of_power.full_recharge_time<cooldown.frozen_orb.remains
            -- actions.cooldowns+=/use_items  
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
    end

    local function actionList_Leveling()
        actionList_Cooldowns()
        if targetUnit.frozen or targetUnit.calcHP < calcDamage(spell.iceLance, targetUnit) or (inInstance and targetUnit.ttd < cast.time.frostbolt()) then
            if cast.iceLance("target") then
                return true
            end
        end
        if bfExists or isCastingSpell(spell.ebonbolt) then
            if cast.flurry("target") then
                return true
            end
        end
        if getDistance("target") < 12 and not isBoss("target") then
            if cast.frostNova("player") then
                return true
            end
        end
        if cast.able.arcaneExplosion() and getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= getOptionValue("Arcane Explosion Units") then
            CastSpellByName(GetSpellInfo(spell.arcaneExplosion))
        end
        if mode.frozenOrb == 1 and useCDs() then
            if castFrozenOrb(1, true, 4) then return true end
        else
        -- Frozen Orb Key
            if mode.frozenOrb == 2 and isChecked("Frozen Orb Key") and SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() then
                CastSpellByName(GetSpellInfo(spell.frozenOrb))
                return
            end
        end
        if mode.rotation ~= 2 and not playerCasting and blizzardUnits >= getOptionValue("Blizzard Units") and not tankMoving and not moving then
            if createCastFunction("best", false, getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then
                return true
            end
        end
        if targetUnit.calcHP > calcDamage(spell.iceNova, targetUnit) or #getEnemies("target", 8) > 2 then
            if cd.iceNova.remain() <= gcd and ((playerCasting and UnitCastID("player") == spell.frostbolt) or cast.inFlight.frostbolt()) then
                return true
            end
            if cast.iceNova("target") then
                return true
            end
        end
        if mode.coc == 1 then
            if castBestConeAngle then
                if castBestConeAngle(spell.coneOfCold,10,90,1,false) then return true end
            elseif getEnemiesInCone(90,10) >= 1 then
                if cast.coneOfCold("player") then return true end
            end
        end
        if moving then
            if cast.iceLance("target") then
                return true
            end
        end
        if cast.able.fireBlast("target") then 
            if cast.fireBlast("target") then return true end
        end
        if cast.frostbolt("target") then
            return true
        end
        if targetUnit.facing then
            if mode.ebonbolt == 1 and targetUnit.calcHP > (calcDamage(spell.frostbolt, targetUnit) * 2) and targetUnit.ttd > 4 then
                if cast.ebonbolt("target") then return true end
            end

        end
    end

    local function actionList_ST()
        -- # In some situations, you can shatter Ice Nova even after already casting Flurry and Ice Lance. Otherwise this action is used when the mage has FoF after casting Flurry, see above.
        -- arcane explosion
        if cast.able.arcaneExplosion() and getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= getOptionValue("Arcane Explosion Units") then
        CastSpellByName(GetSpellInfo(spell.arcaneExplosion))
         end    
        -- actions.single=ice_nova,if=cooldown.ice_nova.ready&debuff.winters_chill.up
        if debuff.wintersChill.exists("target") then
            if cast.iceNova("target") then return true end
        end
        -- # Without GS, Ebonbolt is always shattered. With GS, Ebonbolt is shattered if it would waste Brain Freeze charge (i.e. when the mage starts casting Ebonbolt with Brain Freeze active) or when below 4 Icicles (if Ebonbolt is cast when the mage has 4-5 Icicles, it's better to use the Brain Freeze from it on Glacial Spike).
        -- actions.single+=/flurry,if=talent.ebonbolt.enabled&prev_gcd.1.ebonbolt&(!talent.glacial_spike.enabled|buff.icicles.stack<4|buff.brain_freeze.react)
        if talent.ebonbolt and cast.last.ebonbolt() and (not talent.glacialSpike or iciclesStack < 4 or targetUnit.ttd < 3) then
            if cast.flurry("target") then return true end
        end
        -- # Glacial Spike is always shattered.
        -- actions.single+=/flurry,if=talent.glacial_spike.enabled&prev_gcd.1.glacial_spike&buff.brain_freeze.react
        if talent.glacialSpike and bfExists and (cast.last.glacialSpike() or targetUnit.ttd < 3) then
            if cast.flurry("target") then return true end
        end
        -- # Without GS, the mage just tries to shatter as many Frostbolts as possible. With GS, the mage only shatters Frostbolt that would put them at 1-3 Icicle stacks. Difference between shattering Frostbolt with 1-3 Icicles and 1-4 Icicles is small, but 1-3 tends to be better in more situations (the higher GS damage is, the more it leans towards 1-3). Forcing shatter on Frostbolt is still a small gain, so is not caring about FoF. Ice Lance is too weak to warrant delaying Brain Freeze Flurry.
        -- actions.single+=/flurry,if=prev_gcd.1.frostbolt&buff.brain_freeze.react&(!talent.glacial_spike.enabled|buff.icicles.stack<4)
        if cast.last.frostbolt() and bfExists and (not talent.glacialSpike or iciclesStack < 4 or targetUnit.ttd < 3) then
            if cast.flurry("target") then return true end
        end
        -- actions.single+=/frozen_orb
        if mode.frozenOrb == 1 and not moving and targetMoveCheck then
            if not isChecked("Obey AoE units when using CDs") and useCDs() then
                if castFrozenOrb(1, true, 4) then return true end
            else
                if castFrozenOrb(getOptionValue("Frozen Orb Units"), true, 4) then return true end
            end
        else
        -- Frozen Orb Key
            if mode.frozenOrb == 2 and isChecked("Frozen Orb Key") and SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() then
                CastSpellByName(GetSpellInfo(spell.frozenOrb))
                return
            end
        end
        -- # With Freezing Rain and at least 2 targets, Blizzard needs to be used with higher priority to make sure you can fit both instant Blizzards into a single Freezing Rain. Starting with three targets, Blizzard leaves the low priority filler role and is used on cooldown (and just making sure not to waste Brain Freeze charges) with or without Freezing Rain.
        -- actions.single+=/blizzard,if=active_enemies>2|active_enemies>1&cast_time=0&buff.fingers_of_frost.react<2
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if createCastFunction("best", false, 3, 8, spell.blizzard, nil, true, 3) then
                return true
            end
            if buff.fingersOfFrost.stack() < 2 and buff.freezingRain.exists() then
                if createCastFunction("best", false, 2, 8, spell.blizzard, nil, true, 3) then
                    return true
                end
            end
        end
        -- # Trying to pool charges of FoF for anything isn't worth it. Use them as they come.
        -- actions.single+=/ice_lance,if=buff.fingers_of_frost.react
        if not isChecked("No Ice Lance") then
            if fofExists and (not (bfExists and iciclesStack >= 5) or targetUnit.ttd < 3) then
                if cast.iceLance("target") then return true end
            end
        elseif fofExists and ((#getEnemies("target", 5) > 1 and talent.splittingIce) or targetUnit.ttd < 3) then
            if cast.iceLance("target") then return true end
        end
        -- actions.single+=/comet_storm
        if talent.cometStorm and not moving and mode.cometStorm == 1 and not isMoving("target") and targetUnit.ttd > 3 and ((not isChecked("Obey AoE units when using CDs") and useCDs()) or #getEnemies("target", 5) >= getOptionValue("Comet Storm Units")) then
            if cast.cometStorm("target") then
                if UnitIsVisible("pet") and not isBoss("target") then
                    C_Timer.After(playerCastRemain + 0.4, function()
                        if UnitIsVisible("target") then
                            local x,y,z = ObjectPosition("target")
                            castAtPosition(x,y,z, spell.petFreeze)
                        end
                    end)
                end
                return true 
            end
        end
        -- actions.single+=/ebonbolt
        if mode.ebonbolt == 1 and not moving and targetUnit.ttd > 5 and targetUnit.facing and not bfExists and (not talent.glacialSpike or iciclesStack >= 5) then
            if cast.ebonbolt("target") then return true end
        end
        -- # Ray of Frost is used after all Fingers of Frost charges have been used and there isn't active Frozen Orb that could generate more. This is only a small gain against multiple targets, as Ray of Frost isn't too impactful.
        -- actions.single+=/ray_of_frost,if=!action.frozen_orb.in_flight&ground_aoe.frozen_orb.remains=0
        if standingTime > 1 and cd.frozenOrb.remain() < 45 and targetUnit.facing then
            if cast.rayOfFrost("target") then return true end
        end 
        -- # Blizzard is used as low priority filler against 2 targets. When using Freezing Rain, it's a medium gain to use the instant Blizzard even against a single target, especially with low mastery.
        -- actions.single+=/blizzard,if=cast_time=0|active_enemies>1
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if buff.freezingRain.exists() then
                if not isChecked("Obey AoE units when using CDs") and useCDs() then
                    if createCastFunction("best", false, 1, 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                else
                    if createCastFunction("best", false, getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                end
            else
                if blizzardUnits >= 2 and not isChecked("Obey AoE units when using CDs") and useCDs() then
                    if createCastFunction("best", false, 2, 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                elseif blizzardUnits >= getOptionValue("Blizzard Units") then
                    if createCastFunction("best", false, getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                end
            end
        end
        -- # Glacial Spike is used when there's a Brain Freeze proc active (i.e. only when it can be shattered). This is a small to medium gain in most situations. Low mastery leans towards using it when available. When using Splitting Ice and having another target nearby, it's slightly better to use GS when available, as the second target doesn't benefit from shattering the main target.
        -- actions.single+=/glacial_spike,if=buff.brain_freeze.react|prev_gcd.1.ebonbolt|active_enemies>1&talent.splitting_ice.enabled
        if (bfExists or cast.last.ebonbolt() or ifCheck() or (not isChecked("No Ice Lance") and #getEnemies("target", 5) > 1 and talent.splittingIce)) and iciclesStack >= 5 and not moving and targetUnit.facing then
            if cast.glacialSpike("target") then return true end
        end
        -- actions.single+=/ice_nova
        if not moving and targetUnit.facing then
            if cast.iceNova("target") then return true end
        end
        -- fireblast
        if cast.able.fireBlast("target") then 
            if cast.fireBlast("target") then return true end
        end
        -- actions.single+=/use_item,name=tidestorm_codex,if=buff.icy_veins.down&buff.rune_of_power.down
        -- actions.single+=/frostbolt
        if not moving and targetUnit.facing and (isChecked("No Ice Lance") or not fofExists) then
            if cast.frostbolt("target") then return true end
        end
        -- actions.single+=/call_action_list,name=movement
        if talent.iceFloes and moving and not buff.iceFloes.exists() then
            if cast.iceFloes("player") then return true end
        end
        -- actions.single+=/ice_lance
        if cast.iceLance("target") then return true end
    end

    local function actionList_AoE()
        -- # With Freezing Rain, it's better to prioritize using Frozen Orb when both FO and Blizzard are off cooldown. Without Freezing Rain, the converse is true although the difference is miniscule until very high target counts.
        -- arcane explosion
        if mode.rotation ~= 2 and cast.able.arcaneExplosion() and getDistance("target") <= 10 and manaPercent > 30 and #enemies.yards10 >= getOptionValue("Arcane Explosion Units") then
            CastSpellByName(GetSpellInfo(spell.arcaneExplosion))
        end
        -- actions.aoe=frozen_orb
        if mode.frozenOrb == 1 and not moving and targetMoveCheck then
            if not isChecked("Obey AoE units when using CDs") and useCDs() then
                if castFrozenOrb(1, true, 4) then return true end
            else
                if castFrozenOrb(getOptionValue("Frozen Orb Units"), true, 4) then return true end
            end
        else
        -- Frozen Orb Key
            if mode.frozenOrb == 2 and isChecked("Frozen Orb Key") and SpecificToggle("Frozen Orb Key") and not GetCurrentKeyBoardFocus() then
                CastSpellByName(GetSpellInfo(spell.frozenOrb))
                return
            end
        end

        -- actions.aoe+=/blizzard
        if mode.rotation ~= 2 and not tankMoving and not moving and not playerCasting then
            if buff.freezingRain.exists() then
                if not isChecked("Obey AoE units when using CDs") and useCDs() then
                    if createCastFunction("best", false, 4, 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                else
                    if createCastFunction("best", false, getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, false, 3) then
                        return true
                    end
                end
            else
                if not isChecked("Obey AoE units when using CDs") and useCDs() then
                    if createCastFunction("best", false, 4, 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                else
                    if createCastFunction("best", false, getOptionValue("Blizzard Units"), 8, spell.blizzard, nil, true, 3) then
                        return true
                    end
                end
            end
        end
        -- actions.aoe+=/comet_storm
        if mode.cometStorm == 1 and not moving and not isMoving("target") and targetUnit.ttd > 3 and ((isChecked("Ignore AoE units when using CDs") and useCDs()) or #getEnemies("target", 5) >= getOptionValue("Comet Storm Units")) then
            if cast.cometStorm("target") then
                if UnitIsVisible("pet") and not isBoss("target") then
                    C_Timer.After(playerCastRemain + 0.4, function()
                        if UnitIsVisible("target") then
                            local x,y,z = ObjectPosition("target")
                            castAtPosition(x,y,z, spell.petFreeze)
                        end
                    end)
                end
                return true 
            end
        end
        -- actions.aoe+=/ice_nova
        if targetUnit.facing then
            if cast.iceNova("target") then return true end
        end
        -- # Simplified Flurry conditions from the ST action list. Since the mage is generating far less Brain Freeze charges, the exact condition here isn't all that important.
        -- actions.aoe+=/flurry,if=prev_gcd.1.ebonbolt|buff.brain_freeze.react&(prev_gcd.1.frostbolt&(buff.icicles.stack<4|!talent.glacial_spike.enabled)|prev_gcd.1.glacial_spike)
        if (cast.last.ebonbolt() and (not talent.glacialSpike or iciclesStack < 4 or targetUnit.ttd < 3)) or (buff.brainFreeze.exists() and ((cast.last.frostbolt() and (iciclesStack < 4 or not talent.glacialSpike or targetUnit.ttd < 3)) or cast.last.glacialSpike())) then
            if cast.flurry("target") then return true end
        end
        -- actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react
        if fofExists then
            if cast.iceLance("target") then return true end
        end
        -- # The mage will generally be generating a lot of FoF charges when using the AoE action list. Trying to delay Ray of Frost until there are no FoF charges and no active Frozen Orbs would lead to it not being used at all.
        -- actions.aoe+=/ray_of_frost
        if standingTime > 1 and targetUnit.ttd > 4 and targetUnit.facing then
            if cast.rayOfFrost("target") then return true end
        end
        -- actions.aoe+=/ebonbolt
        if mode.ebonbolt == 1 and not moving and targetUnit.ttd > 5 and targetUnit.facing and not bfExists and (not talent.glacialSpike or iciclesStack >= 5) then
            if cast.ebonbolt("target") then return true end
        end
        -- actions.aoe+=/glacial_spike
        if not moving and targetUnit.facing and iciclesStack >= 5 and bfExists then
            if cast.glacialSpike("target") then return true end
        end
        -- # Using Cone of Cold is mostly DPS neutral with the AoE target thresholds. It only becomes decent gain with roughly 7 or more targets.
        -- actions.aoe+=/cone_of_cold
        if mode.coc == 1 then
            if castBestConeAngle then
                if castBestConeAngle(spell.coneOfCold,10,90,4,false) then return true end
            elseif getEnemiesInCone(90,10) >= 4 then
                if cast.coneOfCold("player") then return true end
            end
        end
        -- actions.aoe+=/use_item,name=tidestorm_codex,if=buff.icy_veins.down&buff.rune_of_power.down
        -- actions.aoe+=/frostbolt
        if not moving and targetUnit.facing and not fofExists then
            if cast.frostbolt("target") then return true end
        end
        -- actions.aoe+=/call_action_list,name=movement
        if talent.iceFloes and moving and not buff.iceFloes.exists() then
            if cast.iceFloes("player") then return true end
        end
        -- actions.aoe+=/ice_lance
        if cast.iceLance("target") then return true end
    end

    local function actionList_Rotation()
        if (((fofExists and not isChecked("No Ice Lance")) or ((bfExists or ifCheck()) and iciclesStack > 5)) and interruptCast(spell.frostbolt)) or (bfExists and interruptCast(spell.ebonbolt)) then
            SpellStopCasting()
            return true
        end
        if spellQueueReady() then
            -- # If the mage has FoF after casting instant Flurry, we can delay the Ice Lance and use other high priority action, if available.
            -- actions+=/ice_lance,if=prev_gcd.1.flurry&!buff.fingers_of_frost.react
            if not isChecked("No Ice Lance") and cast.last.flurry() and not fofExists then
                if cast.iceLance("target") then return true end
            end
            -- actions+=/call_action_list,name=cooldowns
            if actionList_Cooldowns() then return true end
            -- essences
            if actionList_Essences() then return true end
            -- # The target threshold isn't exact. Between 3-5 targets, the differences between the ST and AoE action lists are rather small. However, Freezing Rain prefers using AoE action list sooner as it benefits greatly from the high priority Blizzard action.
            -- actions+=/call_action_list,name=aoe,if=active_enemies>3&talent.freezing_rain.enabled|active_enemies>4
            if ((blizzardUnits > 3 and talent.freezingRain) or blizzardUnits > 4) and (not inInstance or targetMoveCheck) then
                if actionList_AoE() then return true end
            end
            -- actions+=/call_action_list,name=single
            if actionList_ST() then return true end
        end
    end

    local function actionList_Opener()
        opener = true
    end

    local function actionList_PreCombat()
        local petPadding = 2
        if isChecked("Pet Management") and not talent.lonelyWinter and not (IsFlying() or IsMounted()) and level >= 5 and br.timer:useTimer("summonPet", cast.time.summonWaterElemental() + petPadding) and not moving then
            if activePetId == 0 and lastSpell ~= spell.summonWaterElemental then
                if cast.summonWaterElemental("player") then
                    return true
                end
            end
        end
        if not inCombat and not (IsFlying() or IsMounted()) then
            if (not isChecked("Opener") or opener == true) then
                if useCDs() and isChecked("Pre-Pull Logic") and GetObjectExists("target") and getDistance("target") < 40 then
                    local frostboltExecute = cast.time.frostbolt() + (getDistance("target") / 35)
                    if pullTimer <= frostboltExecute then
                        if isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
                            use.battlePotionOfIntellect()
                        end
                        if fbInc == false and cast.frostbolt("target") then
                            fbInc = true
                            return true
                        end
                    end
                end
                if targetUnit and (not isChecked("Opener") or opener == true) then
                    if isChecked("Pet Management") and not talent.lonelyWinter and not UnitAffectingCombat("pet") then
                        PetAssistMode()
                        PetAttack("target")
                    end
                    if getOptionValue("APL Mode") == 2 then
                        if moving or targetUnit.calcHP < calcDamage(spell.iceLance, targetUnit) then
                            if cast.iceLance("target") then
                                return true
                            end
                        else
                            if cast.frostbolt("target") then
                                return true
                            end
                        end
                    elseif getOptionValue("APL Mode") == 3 then
                        if cast.iceLance("target") then
                            return true
                        end
                    end
                end
            end
        end -- End No Combat
    end -- End Action List - PreCombat
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif (inCombat and profileStop == true) or IsMounted() or UnitChannelInfo("player") or IsFlying() or pause(true) or isCastingSpell(293491) or cast.current.focusedAzeriteBeam() then
        if not pause(true) and not talent.lonelyWinter and IsPetAttackActive() and isChecked("Pet Management") then
            PetStopAttack()
            PetFollow()
        end
        return true
    else
    -----------------------
    --- Extras Rotation ---
    -----------------------
        if actionList_Extras() then
            return true
        end
    -----------------------
    ---     Opener      ---
    -----------------------
        if opener == false and isChecked("Opener") and isBoss("target") then
            if actionList_Opener() then
                return true
            end
        end

    ------------------------------
    --- Out of Combat Rotation ---
    ------------------------------
        if actionList_PreCombat() then
            return true
        end
    --------------------------
    --- In Combat Rotation ---
    --------------------------        
        if (inCombat or cast.inFlight.frostbolt() or targetUnit) and profileStop == false and targetUnit and (opener == true or not isChecked("Opener") or not isBoss("target")) then
        --------------------------
        --- Defensive Rotation ---
        --------------------------
            if actionList_Defensive() then
                return true
            end
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
            if actionList_Interrupts() then
                return true
            end
            if br.queueSpell then
                ChatOverlay("Pausing for queuecast")
                return true 
            end
            if not pause(true) and targetUnit.calcHP > 0 and (targetUnit.facing or isChecked("Auto Facing")) then
                if isChecked("Pet Management") and not talent.lonelyWinter and UnitIsVisible("pet") and not GetUnitIsUnit("pettarget", "target") and targetUnit then
                    PetAttack()
                end
            --------------------------
            ---      Rotation      ---
            --------------------------
                if getOptionValue("APL Mode") == 1 then
                    if actionList_Rotation() then
                        return true
                    end
                elseif getOptionValue("APL Mode") == 2 then
                    if actionList_Leveling() then
                        return true
                    end
                elseif getOptionValue("APL Mode") == 3 then
                    if bfExists then
                        if cast.flurry("target") then return true end
                    end
                    if cast.iceLance("target") then
                        return true
                    end
                    -----------------------
                    ---     Essences    ---
                    -----------------------
                    if cd.global.remain() <= gcd then
                        if actionList_Essences() then 
                        return end
                    end
                end
            end
        end
    end
end
local id = 0
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)

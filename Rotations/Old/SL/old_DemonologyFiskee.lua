local rotationName = "Fiskee - 8.1"
local dreadstalkersActive, grimoireActive = false, false
local dreadstalkersTime, grimoireTime, ppDb, castSummonId, opener, summonTime
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of targets in range.",
            highlight = 1,
            icon = br.player.spell.handOfGuldan
        },
        [2] = {
            mode = "Mult",
            value = 2,
            overlay = "Multiple Target Rotation",
            tip = "Multiple target rotation used.",
            highlight = 0,
            icon = br.player.spell.implosion
        },
        [3] = {
            mode = "Sing",
            value = 3,
            overlay = "Single Target Rotation",
            tip = "Single target rotation used.",
            highlight = 0,
            icon = br.player.spell.shadowBolt
        },
        [4] = {
            mode = "Off",
            value = 4,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spell.drainLife
        }
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spell.summonDemonicTyrant
        },
        [2] = {
            mode = "On",
            value = 2,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.summonDemonicTyrant
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.shadowBolt
        },
        [4] = {
            mode = "Lust",
            value = 4,
            overlay = "Cooldowns With Lust",
            tip = "Cooldowns will be used with bloodlust or simlar effects.",
            highlight = 0,
            icon = br.player.spell.summonDemonicTyrant
        }
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.unendingResolve
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.unendingResolve
        }
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.spellLock
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.spellLock
        }
    }
    CreateButton("Interrupt", 4, 0)
    -- BSB Button
    BSBModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Bilescourge Bombers Enabled",
            tip = "Bilescourge Bombers Enabled.",
            highlight = 1,
            icon = br.player.spell.bilescourgeBombers
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Bilescourge Bombers Disabled",
            tip = "Bilescourge Bombers Disabled.",
            highlight = 0,
            icon = br.player.spell.bilescourgeBombers
        }
    }
    CreateButton("BSB", 5, 0)
    -- GF Button
    GFModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Grimoire Felguard Enabled",
            tip = "Grimoire Felguard Enabled.",
            highlight = 1,
            icon = br.player.spell.grimoireFelguard
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Grimoire Felguard Disabled",
            tip = "Grimoire Felguard Disabled.",
            highlight = 0,
            icon = br.player.spell.grimoireFelguard
        }
    }
    CreateButton("GF", 6, 0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {
        "None",
        GetBindingKey("Rotation Function 1"),
        GetBindingKey("Rotation Function 2"),
        GetBindingKey("Rotation Function 3"),
        GetBindingKey("Rotation Function 4"),
        GetBindingKey("Rotation Function 5")
    }
    local optionTable
    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
        br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
        br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
        br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffFFFFFFWill precast demonbolt on pull if pulltimer is active")
        -- Opener
        --br.ui:createCheckbox(section,"Opener")
        -- Pet Management
        br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
        -- Summon Pet
        br.ui:createDropdownWithout(section, "Summon Pet", {"Felguard", "Imp", "Voidwalker", "Felhunter", "Succubus", "None"}, 1, "|cffFFFFFFSelect default pet to summon.")
        -- Life Tap
        br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- Shadowfury Hotkey
        br.ui:createDropdown(section, "Shadowfury Hotkey (hold)", rotationKeys, 1, "", "|cffFFFFFFShadowfury stun with logic to hit most mobs. Uses keys from Bad Rotation keybindings in WoW settings")
        -- Shadowfury Target
        br.ui:createDropdownWithout(section, "Shadowfury Target", {"Best", "Target", "Cursor"}, 1, "|cffFFFFFFShadowfury target")
        -- No Dot units
        br.ui:createCheckbox(section, "Dot Blacklist", "|cffFFFFFF Check to ignore certain units for dots")
        -- Auto target
        br.ui:createCheckbox(section, "Auto Target", "|cffFFFFFF Will auto change to a new target, if current target is dead")
        -- Implosion Unit
        br.ui:createSpinnerWithout(section, "Implosion Units", 2, 1, 10, 1, "|cffFFFFFFMinimum units to cast Implosion")
        -- Multi-Dot Limit
        br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 7, 1, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")
        -- Bilescourge Bombers Target
        br.ui:createDropdownWithout(section, "Bilescourge Bombers Target", {"Target", "Best"}, 2, "|cffFFFFFFBilescourge Bombers target")
        -- Bilescourge Bombers Unit
        br.ui:createSpinnerWithout(section, "Bilescourge Bombers Units", 3, 1, 10, 1, "|cffFFFFFFMinimum units to cast Bilescourge Bombers")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Bilescourge Bombers with CDs
        br.ui:createCheckbox(section, "Ignore Bilescourge Bombers units when using CDs")
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Trinkets
        br.ui:createCheckbox(section, "Trinkets")
        -- Potion
        br.ui:createCheckbox(section, "Potion")
        -- Pre Pot
        br.ui:createCheckbox(section, "Pre Pot", "|cffFFFFFF Requires Pre-Pull logic to be active")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
        br.ui:createSpinner(section, "Pot/Stoned", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
        br.ui:createSpinner(section, "Heirloom Neck", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        -- Gift of The Naaru
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        end
        -- Dark Pact
        br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Drain Life
        br.ui:createSpinner(section, "Drain Life", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Health Funnel
        br.ui:createSpinner(section, "Health Funnel", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Unending Resolve
        br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        --Soulstone
        br.ui:createCheckbox(section, "Auto Soulstone Player", "|cffFFFFFF Will put soulstone on player outside raids and dungeons")
        --Soulstone mouseover
        br.ui:createCheckbox(section, "Auto Soulstone Mouseover", "|cffFFFFFF Auto soulstone your mouseover if dead")
        --Dispel
        br.ui:createCheckbox(section, "Auto Dispel/Purge", "|cffFFFFFF Auto dispel/purge in m+, based on whitelist, set delay in healing engine settings")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
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
    br.player.ui.mode.bsb = br.data.settings[br.selectedSpec].toggles["BSB"]
    br.player.ui.mode.gf = br.data.settings[br.selectedSpec].toggles["GF"]
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
    local equiped = br.player.equiped
    local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
    local friendly = friendly or GetUnitIsFriend("target", "player")
    local gcd = br.player.gcdMax
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
    local playerMouse = UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer = PullTimerRemain()
    local race = br.player.race
    local shards = UnitPower("player", Enum.PowerType.SoulShards)
    local summonPet = getOptionValue("Summon Pet")
    local solo = br.player.instance == "none"
    local spell = br.player.spell
    local talent = br.player.talent
    local thp = getHP("target")
    local trait = br.player.traits
    local travelTime = getDistance("target") / 16
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local use = br.player.use

    units.get(40)
    enemies.get(8, "target")
    enemies.get(10, "target")
    enemies.get(40)

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil or not inCombat then
        profileStop = false
    end
    if castSummonId == nil then
        castSummonId = 0
    end
    if summonTime == nil then
        summonTime = 0
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

    --Defensive dispel whitelist, value is for range to allies on the unit you are dispelling
    local dDispelList = {
        [255584] = 0, -- Molten Gold
        [255041] = 0, -- terrifying-screech
        [257908] = 0, -- Oiled Blade
        [270920] = 0, -- seduction
        [268233] = 0, -- Electrifying Shock
        [268896] = 0, -- Mind Rend
        [272571] = 0, -- choking-waters
        [275014] = 5, -- putrid-waters
        [268008] = 0, -- snake-charm
        [280605] = 0, -- brain-freeze
        [275102] = 0, -- shocking-claw
        [268797] = 0, -- transmute-enemy-to-goo
        [268846] = 0, -- echo-blade
        [263891] = 0 -- grasping-thorns
    }

    --Offensive dispel whitelist, value is for range to allies on the unit you are dispelling
    local oDispelList = {
        [255579] = 0, -- Gilded Claws
        [257397] = 0, -- Healing Balm
        [273432] = 0, -- Bound by Shadow
        [270901] = 0, -- Induce Regeneration
        [267977] = 0, -- tidal-surge
        [268030] = 0, -- mending-rapids
        [276767] = 0, -- Consuming Void
        [272659] = 0, -- electrified-scales
        [269896] = 0, -- embryonic-vigor
        [269129] = 0, -- accumulated-charge
        [268709] = 0, -- earth-shield
        [263215] = 0, -- tectonic-barrier
        [262947] = 0, -- azerite-injection
        [262540] = 0, -- overcharge
        [265091] = 0, -- gift-of-ghuun
        [266201] = 0, -- bone-shield
        [258133] = 0, -- darkstep
        [258153] = 0, -- watery-dome
        [278567] = 0 -- soul-fetish
    }

    local function dispelUnit(unit)
        local i = 1
        local remain
        local validDispel = false
        local dispelDuration = 0
        if UnitInPhase(unit) then
            if GetUnitIsFriend("player", unit) then
                while UnitDebuff(unit, i) do
                    local _, _, _, dispelType, debuffDuration, expire, _, _, _, dispelId = UnitDebuff(unit, i)
                    if (dispelType and dispelType == "Magic") and dDispelList[dispelId] ~= nil and (dDispelList[dispelId] == 0 or (dDispelList[dispelId] > 0 and #getAllies(unit, dDispelList[dispelId]) == 1)) then
                        dispelDuration = debuffDuration
                        remain = expire - GetTime()
                        validDispel = true
                        break
                    end
                    i = i + 1
                end
            else
                while UnitBuff(unit, i) do
                    local _, _, _, dispelType, buffDuration, expire, _, _, _, dispelId = UnitBuff(unit, i)
                    if (dispelType and dispelType == "Magic") and oDispelList[dispelId] ~= nil and (oDispelList[dispelId] == 0 or (oDispelList[dispelId] > 0 and #getAllies(unit, oDispelList[dispelId]) == 0)) then
                        dispelDuration = buffDuration
                        remain = expire - GetTime()
                        validDispel = true
                        break
                    end
                    i = i + 1
                end
            end
        end
        local dispelDelay = 1.5
        if isChecked("Dispel delay") then
            dispelDelay = getValue("Dispel delay")
        end
        if validDispel and (dispelDuration - remain) > (dispelDelay - 0.3 + math.random() * 0.6) then
            return true
        end
        return false
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
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(getDistance(thisUnit) - 20)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.facing = getFacing("player", thisUnit)
                if enemyUnit.facing then
                    facingUnits = facingUnits + 1
                end
                tinsert(enemyTable40, enemyUnit)
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
        if isChecked("Auto Target") and inCombat and #enemyTable40 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable40[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable40[1].unit)
        end
    end

    --Keybindings
    local shadowfuryKey = false
    if getOptionValue("Shadowfury Hotkey (hold)") ~= 1 then
        shadowfuryKey = _G["rotationFunction" .. (getOptionValue("Shadowfury Hotkey (hold)") - 1)]
        if shadowfuryKey == nil then
            shadowfuryKey = false
        end
    end
    -- spell usable check
    local function spellUsable(spellID)
        if isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end

    -- Opener Variables
    if not inCombat and not GetObjectExists("target") then
        -- openerCount = 0
        -- OPN1 = false
        -- AGN1 = false
        -- COR1 = false
        -- SIL1 = false
        -- PHS1 = false
        -- UAF1 = false
        -- UAF2 = false
        -- RES1 = false
        -- UAF3 = false
        -- SOH1 = false
        -- DRN1 = false
        -- opener = false
        ppDb = false
        prePull = false
    end

    -- Pet Data
    if summonPet == 1 then
        summonId = 17252
    elseif summonPet == 2 and HasAttachedGlyph(spell.summonImp) then
        summonId = 58959
    elseif summonPet == 2 then
        summonId = 416
    elseif summonPet == 3 and HasAttachedGlyph(spell.summonVoidwalker) then
        summonId = 58960
    elseif summonPet == 3 then
        summonId = 1860
    elseif summonPet == 4 then
        summonId = 417
    elseif summonPet == 5 then
        summonId = 1863
    end

    --Pet locals
    local wildImps = 0
    local tyrantActive = false
    local dreadstalkersRemain = 0
    local foundDreakstalker = false
    local felguardActive = false
    local foundGrimoire = false
    local grimoireRemain = 0

    if pet ~= nil then
        for k, v in pairs(pet) do
            local thisUnit = pet[k] or 0
            if thisUnit.id == 135002 and not tyrantActive and not UnitIsDeadOrGhost(thisUnit.unit) then
                tyrantActive = true
            elseif thisUnit.id == 55659 and not UnitIsDeadOrGhost(thisUnit.unit) then
                wildImps = wildImps + 1
            elseif thisUnit.id == 98035 and not UnitIsDeadOrGhost(thisUnit.unit) then
                if not dreadstalkersActive then
                    dreadstalkersTime = GetTime()
                end
                foundDreakstalker = true
                dreadstalkersActive = true
            elseif thisUnit.id == 17252 and not UnitIsDeadOrGhost(thisUnit.unit) then
                local grimoire = getBuffRemain(thisUnit.unit, 216187)
                if grimoire == 0 then
                    felguardActive = true
                end
                if grimoire ~= 0 then
                    if not grimoireActive then
                        grimoireTime = GetTime()
                    end
                    grimoireActive = true
                    foundGrimoire = true
                end
            end
        end
    end
    if not foundDreakstalker then
        dreadstalkersActive = false
    end
    if dreadstalkersActive then
        dreadstalkersRemain = dreadstalkersTime - GetTime() + 12
    end
    if not foundGrimoire then
        grimoireActive = false
    end
    if grimoireActive then
        grimoireRemain = grimoireTime - GetTime() + 12
    end

    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
    local function actionList_Extras()
        -- Dummy Test
        if isChecked("DPS Testing") then
            if GetObjectExists("target") then
                if getCombatTime() >= (tonumber(getOptionValue("DPS Testing")) * 60) and isDummy() then
                    StopAttack()
                    ClearTarget()
                    if isChecked("Pet Management") then
                        PetStopAttack()
                        PetFollow()
                    end
                    Print(tonumber(getOptionValue("DPS Testing")) .. " Minute Dummy Test Concluded - Profile Stopped")
                    profileStop = true
                end
            end
        end -- End Dummy Test
        if isChecked("Shadowfury Hotkey (hold)") and shadowfuryKey and not GetCurrentKeyBoardFocus() then
            if getOptionValue("Shadowfury Target") == 1 then
                if cast.shadowfury("best", false, 1, 8) then
                    return
                end
            elseif getOptionValue("Shadowfury Target") == 2 then
                if cast.shadowfury("target", "ground") then
                    return
                end
            elseif getOptionValue("Shadowfury Target") == 3 and isKnown(spell.shadowfury) and getSpellCD(spell.shadowfury) == 0 then
                CastSpellByName(GetSpellInfo(spell.shadowfury), "cursor")
                return
            end
        end
        --Burn Units
        local burnUnits = {
            [120651] = true, -- Explosive
            [141851] = true -- Infested
        }
        if GetObjectExists("target") and burnUnits[GetObjectID("target")] ~= nil then
        end
        --Soulstone
        if isChecked("Auto Soulstone Mouseover") and not moving and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
            if cast.soulstone("mouseover", "dead") then
                return true
            end
        end
        if isChecked("Auto Soulstone Player") and not inInstance and not inRaid and (not buff.soulstone.exists("player") or buff.soulstone.remain("player") < 100) and not inCombat and not moving then
            if cast.soulstone("player") then
                return
            end
        end
    end -- End Action List - Extras
    -- Action List - Defensive
    local function actionList_Defensive()
        if useDefensive() then
            -- Pot/Stoned
            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                end
            end
            -- Heirloom Neck
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                if hasEquiped(heirloomNeck) then
                    if GetItemCooldown(heirloomNeck) == 0 then
                        useItem(heirloomNeck)
                    end
                end
            end
            --dispel logic for m+
            if inInstance and isChecked("Auto Dispel/Purge") then
                if spellUsable(spell.devourMagic) then
                    for i = 1, #enemyTable40 do
                        local thisUnit = enemyTable40[i].unit
                        if dispelUnit(thisUnit) then
                            if cast.devourMagic(thisUnit) then
                                return true
                            end
                        end
                    end
                end
                if spellUsable(spell.singeMagic) or spellUsable(spell.singeMagicGrimoire) then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        if dispelUnit(thisUnit) then
                            if cast.singeMagic(thisUnit) then
                                return true
                            end
                            if cast.singeMagicGrimoire(thisUnit) then
                                return true
                            end
                        end
                    end
                end
            end
            -- Gift of the Naaru
            if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                if castSpell("player", racial, false, false, false) then
                    return
                end
            end
            -- Dark Pact
            if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
                if cast.darkPact() then
                    return
                end
            end
            -- Drain Life
            if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and isValidTarget("target") and not moving then
                if cast.drainLife() then
                    return
                end
            end
            -- Health Funnel
            if isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") and not moving then
                if cast.healthFunnel("pet") then
                    return
                end
            end
            -- Unending gResolve
            if isChecked("Unending Resolve") and php <= getOptionValue("Unending Resolve") and inCombat then
                if cast.unendingResolve() then
                    return
                end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive
    -- Action List - Interrupts
    local function actionList_Interrupts()
        if useInterrupts() then
            if talent.grimoireOfSacrifice then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if cast.spellLockgrimoire(thisUnit) then
                            return
                        end
                    end
                end
            elseif activePetId ~= nil and (activePetId == 417 or activePetId == 78158) then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if activePetId == 417 then
                            if cast.spellLock(thisUnit) then
                                return
                            end
                        end
                    end
                end
            end
        end -- End useInterrupts check
    end -- End Action List - Interrupts
    -- Action List - Cooldowns
    local function actionList_Cooldowns()
        if getDistance("target") < 40 then
            -- actions=potion,if=pet.demonic_tyrant.active|target.time_to_die<30
            if isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (tyrantActive or ttd("target") < 30) then
                use.battlePotionOfIntellect()
                return true
            end
            -- actions+=/use_items,if=pet.demonic_tyrant.active|target.time_to_die<=15
            if isChecked("Trinkets") then
                if canUseItem(13) then
                    useItem(13)
                end
                if canUseItem(14) then
                    useItem(14)
                end
            end
            -- actions+=/berserking,if=pet.demonic_tyrant.active|target.time_to_die<=15
            -- actions+=/blood_fury,if=pet.demonic_tyrant.active|target.time_to_die<=15
            -- actions+=/fireblood,if=pet.demonic_tyrant.active|target.time_to_die<=15
            if isChecked("Racial") and not moving then
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target", "ground") then
                            return true
                        end
                    else
                        if cast.racial("player") then
                            return true
                        end
                    end
                end
            end
        end -- End useCDs check
    end -- End Action List - Cooldowns

    local function actionList_BuildAShard()
        -- actions.build_a_shard=soul_strike
        if cast.soulStrike("target") then
            return true
        end
        -- actions.build_a_shard+=/shadow_bolt
        if not moving then
            if cast.shadowBolt("target") then
                return true
            end
        end
    end

    local function actionList_NetherPortalBuilding()
        -- actions.nether_portal_building=nether_portal,if=soul_shard>=5&(!talent.power_siphon.enabled|buff.demonic_core.up)
        if not moving and shards >= 5 and (not talent.powerSiphon or buff.demonicCore.exists()) then
            if cast.netherPortal("target") then
                return true
            end
        end
        -- actions.nether_portal_building+=/call_dreadstalkers
        if not moving then
            if cast.callDreadstalkers("target") then
                return true
            end
        end
        -- actions.nether_portal_building+=/hand_of_guldan,if=cooldown.call_dreadstalkers.remains>18&soul_shard>=3
        if not moving and cd.callDreadstalkers.remain() > 18 and shards >= 3 then
            if cast.handOfGuldan("target") then
                return true
            end
        end
        -- actions.nether_portal_building+=/power_siphon,if=buff.wild_imps.stack>=2&buff.demonic_core.stack<=2&buff.demonic_power.down&soul_shard>=3
        if wildImps >= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and shards >= 2 then
            if cast.powerSiphon("target") then
                return true
            end
        end
        -- actions.nether_portal_building+=/hand_of_guldan,if=soul_shard>=5
        if not moving and shards >= 5 then
            if cast.handOfGuldan("target") then
                return true
            end
        end
        -- actions.nether_portal_building+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end
    end

    local function actionList_NetherPortalActive()
        --bilescourge_bombers
        if mode.bsb == 1 and mode.rotation ~= 3 then
            if getOptionValue("Bilescourge Bombers Target") == 1 then
                if (#enemies.yards8t >= getOptionValue("Bilescourge Bombers Units") or (isChecked("Ignore Bilescourge Bombers units when using CDs") and useCDs())) then
                    if cast.bilescourgeBombers("target", "ground") then
                        return true
                    end
                end
            else
                if isChecked("Ignore Bilescourge Bombers units when using CDs") and useCDs() then
                    if cast.bilescourgeBombers("best", false, 1, 8) then
                        return true
                    end
                else
                    if cast.bilescourgeBombers("best", false, getOptionValue("Bilescourge Bombers Units"), 8) then
                        return true
                    end
                end
            end
        end
        -- actions.nether_portal_active=grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        if mode.gf == 1 then
            if cast.grimoireFelguard("target") then
                return true
            end
        end
        -- actions.nether_portal_active+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>40|cooldown.summon_demonic_tyrant.remains<12
        if not moving and (cd.summonDemonicTyrant.remain() > 40 or cd.summonDemonicTyrant.remain() < 12) then
            if cast.summonVilefiend("target") then
                return true
            end
        end
        -- actions.nether_portal_active+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if not moving and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14) then
            if cast.callDreadstalkers("target") then
                return true
            end
        end
        -- actions.nether_portal_active+=/call_action_list,name=build_a_shard,if=soul_shard=1&(cooldown.call_dreadstalkers.remains<action.shadow_bolt.cast_time|(talent.bilescourge_bombers.enabled&cooldown.bilescourge_bombers.remains<action.shadow_bolt.cast_time))
        if shards == 1 and (cd.callDreadstalkers.remain() < cast.time.shadowBolt() or (talent.bilescourgeBombers and cd.bilescourgeBombers.remain() < cast.time.shadowBolt())) then
            if actionList_BuildAShard() then
                return true
            end
        end
        -- actions.nether_portal_active+=/hand_of_guldan,if=((cooldown.call_dreadstalkers.remains>action.demonbolt.cast_time)&(cooldown.call_dreadstalkers.remains>action.shadow_bolt.cast_time))&cooldown.nether_portal.remains>(160+action.hand_of_guldan.cast_time)
        if not moving and (cd.callDreadstalkers.remain() > cast.time.demonbolt() and cd.callDreadstalkers.remain() > cast.time.shadowBolt() and cd.netherPortal.remain() > (165 + cast.time.handOfGuldan())) then
            if cast.handOfGuldan("target") then
                return true
            end
        end
        -- actions.nether_portal_active+=/summon_demonic_tyrant,if=buff.nether_portal.remains<10&soul_shard=0
        if not moving and buff.netherPortal.remain() < 5 and shards == 0 then
            if cast.summonDemonicTyrant("target") then
                return true
            end
        end
        -- actions.nether_portal_active+=/summon_demonic_tyrant,if=buff.nether_portal.remains<action.summon_demonic_tyrant.cast_time+5.5
        if not moving and buff.netherPortal.remain() < (cast.time.summonDemonicTyrant() + 0.5) then
            if cast.summonDemonicTyrant("target") then
                return true
            end
        end
        -- actions.nether_portal_active+=/demonbolt,if=buff.demonic_core.up
        if buff.demonicCore.exists() then
            if cast.demonbolt("target") then
                return true
            end
        end
        -- actions.nether_portal_active+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end
    end

    local function actionList_NetherPortal()
        -- actions.nether_portal=call_action_list,name=nether_portal_building,if=cooldown.nether_portal.remains<20
        if cd.netherPortal.remain() < 20 then
            if actionList_NetherPortalBuilding() then
                return true
            end
        end
        -- actions.nether_portal+=/call_action_list,name=nether_portal_active,if=cooldown.nether_portal.remains>160
        if cd.netherPortal.remain() > 165 then
            if actionList_NetherPortalActive() then
                return true
            end
        end
    end

    local function actionList_Implosion()
        -- actions.implosion=implosion,if=(buff.wild_imps.stack>=6&(soul_shard<3|prev_gcd.1.call_dreadstalkers|buff.wild_imps.stack>=9|prev_gcd.1.bilescourge_bombers|(!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan))&!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan&buff.demonic_power.down)|(time_to_die<3&buff.wild_imps.stack>0)|(prev_gcd.2.call_dreadstalkers&buff.wild_imps.stack>2&!talent.demonic_calling.enabled)
        if (wildImps >= 6 and (shards < 3 or cast.last.callDreadstalkers(1) or wildImps >= 9 or cast.last.bilescourgeBombers(1) or (not cast.last.handOfGuldan(1) or not cast.last.handOfGuldan(2))) and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) and botSpell ~= spell.implosion and not buff.demonicPower.exists()) or (ttd("target") < 3 and wildImps > 0 and useCDs()) or (cast.last.callDreadstalkers(2) and wildImps > 2 and not talent.demonicCalling) then
            if cast.implosion("target") then
                return true
            end
        end
        -- actions.implosion+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        if not moving and mode.gf == 1 and useCDs() then
            if cast.grimoireFelguard("target") then
                return true
            end
        end
        -- actions.implosion+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if not moving and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14 or not useCDs()) then
            if cast.callDreadstalkers("target") then
                return true
            end
        end
        -- actions.implosion+=/summon_demonic_tyrant
        if useCDs() and not moving then
            if cast.summonDemonicTyrant("target") then
                return true
            end
        end
        -- actions.implosion+=/hand_of_guldan,if=soul_shard>=5
        if shards >= 5 and not moving then
            if cast.handOfGuldan("target") then
                return true
            end
        end
        -- actions.implosion+=/hand_of_guldan,if=soul_shard>=3&(((prev_gcd.2.hand_of_guldan|buff.wild_imps.stack>=3)&buff.wild_imps.stack<9)|cooldown.summon_demonic_tyrant.remains<=gcd*2|buff.demonic_power.remains>gcd*2)
        if shards >= 3 and not moving and (((cast.last.handOfGuldan(2) or wildImps >= 3) and wildImps < 9) or cd.summonDemonicTyrant.remain() <= gcdMax * 2 or buff.demonicPower.remain() > gcdMax * 2 or not useCDs()) then
            if cast.handOfGuldan("target") then
                return true
            end
        end
        -- actions.implosion+=/demonbolt,if=prev_gcd.1.hand_of_guldan&soul_shard>=1&(buff.wild_imps.stack<=3|prev_gcd.3.hand_of_guldan)&soul_shard<4&buff.demonic_core.up
        if cast.last.handOfGuldan(1) and shards >= 1 and (wildImps <= 3 or cast.last.handOfGuldan(3)) and shards < 4 and buff.demonicCore.exists() then
            if cast.demonbolt("target") then
                return true
            end
        end
        -- actions.implosion+=/summon_vilefiend,if=(cooldown.summon_demonic_tyrant.remains>40&spell_targets.implosion<=2)|cooldown.summon_demonic_tyrant.remains<12
        if not moving and useCDs() and ((cd.summonDemonicTyrant.remain() > 40 and (#enemies.yards8t <= 2 or mode.rotation == 3)) or cd.summonDemonicTyrant.remain() < 12) then
            if cast.summonVilefiend("target") then
                return true
            end
        end
        -- actions.implosion+=/bilescourge_bombers,if=cooldown.summon_demonic_tyrant.remains>9
        if mode.bsb == 1 and (cd.summonDemonicTyrant.remain() > 9 or not useCDs()) then
            if getOptionValue("Bilescourge Bombers Target") == 1 then
                if (#enemies.yards8t >= getOptionValue("Bilescourge Bombers Units") or (isChecked("Ignore Bilescourge Bombers units when using CDs") and useCDs())) then
                    if cast.bilescourgeBombers("target", "ground") then
                        return true
                    end
                end
            else
                if isChecked("Ignore Bilescourge Bombers units when using CDs") and useCDs() then
                    if cast.bilescourgeBombers("best", false, 1, 8) then
                        return true
                    end
                else
                    if cast.bilescourgeBombers("best", false, getOptionValue("Bilescourge Bombers Units"), 8) then
                        return true
                    end
                end
            end
        end
        -- actions.implosion+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
        if shards < 5 and buff.demonicCore.stack() <= 2 then
            if cast.soulStrike("target") then
                return true
            end
        end
        -- actions.implosion+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&(buff.demonic_core.stack>=3|buff.demonic_core.remains<=gcd*5.7)
        if shards <= 3 and buff.demonicCore.exists() and (buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() <= gcdMax * 5.7) then
            if cast.demonbolt("target") then
                return true
            end
        end
        -- actions.implosion+=/doom,cycle_targets=1,max_cycle_targets=7,if=refreshable
        if talent.doom and debuff.doom.count() < getOptionValue("Multi-Dot Limit") then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if debuff.doom.refresh(thisUnit) then
                    if cast.doom(thisUnit) then
                        return true
                    end
                end
            end
        end
        -- actions.implosion+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end
    end

    local function actionList_Rotation()
        if useCDs() then
            if actionList_Cooldowns() then
                return true
            end
        end
        --
        -- actions+=/hand_of_guldan,if=azerite.explosive_potential.rank&time<5&soul_shard>2&buff.explosive_potential.down&buff.wild_imps.stack<3&!prev_gcd.1.hand_of_guldan&&!prev_gcd.2.hand_of_guldan
        if trait.explosivePotential.active and combatTime < 5 and shards > 2 and not buff.explosivePotential.exists() and wildImps < 3 and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) then
            if cast.handOfGuldan("target") then
                return true
            end
        end
        -- actions+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&buff.demonic_core.stack=4
        if shards <= 3 and buff.demonicCore.exists() and buff.demonicCore.stack() == 4 then
            if cast.demonbolt("target") then
                return true
            end
        end
        -- actions+=/implosion,if=azerite.explosive_potential.rank&buff.wild_imps.stack>2&buff.explosive_potential.remains<action.shadow_bolt.execute_time&(!talent.demonic_consumption.enabled|cooldown.summon_demonic_tyrant.remains>12)
        if trait.explosivePotential.active and wildImps > 2 and botSpell ~= spell.implosion and buff.explosivePotential.remain() < cast.time.shadowBolt() and (not talent.demonicConsumption or cd.summonDemonicTyrant.remain() > 12 or not useCDs()) then
            if cast.implosion("target") then
                return true
            end
        end
        -- actions+=/doom,if=!ticking&time_to_die>30&spell_targets.implosion<2
        if not debuff.doom.exists("target") and ttd("target") > 30 and (#enemies.yards8t < 2 or mode.rotation == 3) then
            if cast.doom("target") then
                return true
            end
        end
        -- actions+=/demonic_strength,if=(buff.wild_imps.stack<6|buff.demonic_power.up)|spell_targets.implosion<2
        if felguardActive and botSpell ~= spell.demonicStrength and useCDs() and (wildImps < 6 or buff.demonicPower.exists() or (#enemies.yards8t < 2 or mode.rotation == 3)) then
            if cast.demonicStrength("target") then
                return true
            end
        end
        -- actions+=/call_action_list,name=nether_portal,if=talent.nether_portal.enabled&spell_targets.implosion<=2
        if talent.netherPortal and useCDs() and (#enemies.yards8t <= 2 or mode.rotation == 3) then
            if actionList_NetherPortal() then
                return true
            end
        end
        -- actions+=/call_action_list,name=implosion,if=spell_targets.implosion>1
        if mode.rotation ~= 3 and #enemies.yards8t >= getOptionValue("Implosion Units") then
            if actionList_Implosion() then
                return true
            end
        end
        -- actions+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        if mode.gf == 1 and useCDs() then
            if cast.grimoireFelguard("target") then
                return true
            end
        end
        -- actions+=/summon_vilefiend,if=equipped.132369|cooldown.summon_demonic_tyrant.remains>40|cooldown.summon_demonic_tyrant.remains<12
        if not moving and useCDs() and (cd.summonDemonicTyrant.remain() > 40 or cd.summonDemonicTyrant.remain() < 12) then
            if cast.summonVilefiend("target") then
                return true
            end
        end
        -- actions+=/call_dreadstalkers,if=equipped.132369|(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if not moving and ((cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14) then
            if cast.callDreadstalkers("target") then
                return true
            end
        end
        local iDTalent, dCTalent = 0, 0
        if talent.innerDemons then
            iDTalent = 1
        end
        if talent.demonicConsumption then
            dCTalent = 1
        end
        -- actions+=/summon_demonic_tyrant,if=equipped.132369|(buff.dreadstalkers.remains>cast_time&(buff.wild_imps.stack>=3+talent.inner_demons.enabled+talent.demonic_consumption.enabled*3|prev_gcd.1.hand_of_guldan&(!talent.demonic_consumption.enabled|buff.wild_imps.stack>=3+talent.inner_demons.enabled))&(soul_shard<3|buff.dreadstalkers.remains<gcd*2.7|buff.grimoire_felguard.remains<gcd*2.7))
        if not moving and useCDs() and (dreadstalkersRemain > cast.time.summonDemonicTyrant() and (wildImps >= (3 + iDTalent + dCTalent * 3) or (cast.last.handOfGuldan(1) and (not talent.demonicConsumption or wildImps >= 3 + iDTalent))) and (shards < 3 or dreadstalkersRemain < gcdMax * 2.7 or grimoireRemain < gcdMax * 2.7)) then
            if cast.summonDemonicTyrant("target") then
                return true
            end
        end
        -- actions+=/power_siphon,if=buff.wild_imps.stack>=2&buff.demonic_core.stack<=2&buff.demonic_power.down&spell_targets.implosion<2
        if wildImps <= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and (#enemies.yards8t < 2 or mode.rotation == 2) then
            if cast.powerSiphon("target") then
                return true
            end
        end
        -- actions+=/doom,if=talent.doom.enabled&refreshable&time_to_die>(dot.doom.remains+30)
        if debuff.doom.refresh("target") and ttd("target") > (debuff.doom.remain() + 30) then
            if cast.doom("target") then
                return true
            end
        end
        -- actions+=/hand_of_guldan,if=soul_shard>=5|(soul_shard>=3&cooldown.call_dreadstalkers.remains>4&(!talent.summon_vilefiend.enabled|cooldown.summon_vilefiend.remains>3))
        if not moving and not cast.last.handOfGuldan(1) and (shards >= 5 or (shards >= 3 and cd.callDreadstalkers.remain() > 4 and (not talent.summonVilefiend or cd.summonVilefiend.remain() > 3))) then
            if cast.handOfGuldan("target") then
                return true
            end
        end
        -- actions+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
        if shards < 5 and buff.demonicCore.stack() <= 2 then
            if cast.soulStrike("target") then
                return true
            end
        end
        -- actions+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&((cooldown.summon_demonic_tyrant.remains<10|cooldown.summon_demonic_tyrant.remains>22)|buff.demonic_core.stack>=3|buff.demonic_core.remains<5|time_to_die<25)
        if shards <= 3 and buff.demonicCore.exists() and (cd.summonDemonicTyrant.remain() < 10 or cd.summonDemonicTyrant.remain() > 22 or buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() < 5 or ttd("target") < 25) then
            if cast.demonbolt("target") then
                return true
            end
        end
        -- actions+=/bilescourge_bombers
        if mode.bsb == 1 and mode.rotation ~= 3 then
            if getOptionValue("Bilescourge Bombers Target") == 1 then
                if (#enemies.yards8t >= getOptionValue("Bilescourge Bombers Units") or (isChecked("Ignore Bilescourge Bombers units when using CDs") and useCDs())) then
                    if cast.bilescourgeBombers("target", "ground") then
                        return true
                    end
                end
            else
                if isChecked("Ignore Bilescourge Bombers units when using CDs") and useCDs() then
                    if cast.bilescourgeBombers("best", false, 1, 8) then
                        return true
                    end
                else
                    if cast.bilescourgeBombers("best", false, getOptionValue("Bilescourge Bombers Units"), 8) then
                        return true
                    end
                end
            end
        end
        -- doom spread
        if talent.doom and mode.rotation ~= 3 and debuff.doom.count() < getOptionValue("Multi-Dot Limit") then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if debuff.doom.refresh(thisUnit) then
                    if cast.doom(thisUnit) then
                        return true
                    end
                end
            end
        end
        -- actions+=/call_action_list,name=build_a_shard
        if actionList_BuildAShard() then
            return true
        end
    end

    local function actionList_Opener()
        opener = true
    end

    local function actionList_CancelCast()
        local spellID = select(9, UnitCastingInfo("player"))
        if spellID == nil then
            spellID = 0
        end
        if shards >= 5 and spellID == spell.shadowBolt then
            SpellStopCasting()
            return true
        elseif shards < 3 and spellID == spell.handOfGuldan and cd.netherPortal.remain() <= 165 then
            SpellStopCasting()
            return true
        elseif spellID == spell.demonbolt and combatTime > 4 then
            SpellStopCasting()
            return true
        end
    end

    local function actionList_PreCombat()
        -- Summon Pet
        local petPadding = 2
        if talent.grimoireOfSacrifice then
            petPadding = 5
        end
        -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
        if isChecked("Pet Management") and not (IsFlying() or IsMounted()) and (not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) and level >= 5 and br.timer:useTimer("summonPet", cast.time.summonFelguard() + petPadding) and not moving then
            if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0) then
                if summonPet == 1 and (lastSpell ~= spell.summonFelguard or activePetId == 0) then
                    if cast.summonFelguard("player") then
                        castSummonId = spell.summonFelguard
                        return
                    end
                elseif summonPet == 2 and (lastSpell ~= spell.summonImp or activePetId == 0) then
                    if cast.summonImp("player") then
                        castSummonId = spell.summonImp
                        return
                    end
                elseif summonPet == 3 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                    if cast.summonVoidwalker("player") then
                        castSummonId = spell.summonVoidwalker
                        return
                    end
                elseif summonPet == 4 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                    if cast.summonFelhunter("player") then
                        castSummonId = spell.summonFelhunter
                        return
                    end
                elseif summonPet == 5 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                    if cast.summonSuccubus("player") then
                        castSummonId = spell.summonSuccubus
                        return
                    end
                end
            end
        end
        -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
        if talent.grimoireOfSacrifice and isChecked("Pet Management") and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
            if cast.grimoireOfSacrifice() then
                return
            end
        end
        if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask
            -- flask,type=whispered_pact
            -- Food
            -- food,type=azshari_salad
            if (not isChecked("Opener") or opener == true) then
                if useCDs() and isChecked("Pre-Pull Logic") and GetObjectExists("target") and getDistance("target") < 40 then
                    local demonboltExecute = cast.time.demonbolt()
                    if pullTimer <= demonboltExecute then
                        if isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
                            use.battlePotionOfIntellect()
                        end
                        if ppDb == false then
                            if cast.demonbolt("target") then
                                ppDb = true
                                return true
                            end
                        end
                    end
                end -- End Pre-Pull
                if isValidUnit("target") and getDistance("target") < 40 and (not isChecked("Opener") or opener == true) then
                    -- Life Tap
                    -- life_tap,if=talent.empowered_life_tap.enabled&!buff.empowered_life_tap.remains
                    if talent.empoweredLifeTap and not buff.empoweredLifeTap.exists() then
                        if cast.lifeTap() then
                            return
                        end
                    end
                    -- Pet Attack/Follow
                    if isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
                        PetAssistMode()
                        PetAttack("target")
                    end
                    -- actions.precombat+=/inner_demons,if=talent.inner_demons.enabled
                    if talent.innerDemons then
                        if cast.innerDemons("target") then
                            return true
                        end
                    end
                    -- actions.precombat+=/demonbolt (we use SB if no buff)
                    if buff.demonicCore.exists() then
                        if cast.demonbolt("target") then
                            return true
                        end
                    end
                    if cast.shadowBolt("target") then
                        return true
                    end
                end
            end
        end -- End No Combat
        if actionList_Opener() then
            return
        end
    end -- End Action List - PreCombat
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop == true then
        profileStop = false
    elseif (inCombat and profileStop == true) or IsMounted() or IsFlying() or pause(true) or mode.rotation == 4 then
        if not pause(true) and IsPetAttackActive() and isChecked("Pet Management") then
            PetStopAttack()
            PetFollow()
        end
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList_Extras() then
            return
        end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList_Defensive() then
            return
        end
        -----------------------
        --- Opener Rotation ---
        -----------------------
        if opener == false and isChecked("Opener") and isBoss("target") then
            if actionList_Opener() then
                return
            end
        end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList_PreCombat() then
            return
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and profileStop == false and isValidUnit("target") and getDistance("target") < 40 and (opener == true or not isChecked("Opener") or not isBoss("target")) and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            if actionList_CancelCast() then
                return
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then
                return
            end
            ---------------------------
            --- SimulationCraft APL ---
            ---------------------------
            if getOptionValue("APL Mode") == 1 and not pause() then
                -- Pet Attack
                if isChecked("Pet Management") and not GetUnitIsUnit("pettarget", "target") and isValidUnit("target") then
                    PetAttack()
                end
                -- rotation
                if actionList_Rotation() then
                    return
                end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End Timer
-- end -- End runRotation
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

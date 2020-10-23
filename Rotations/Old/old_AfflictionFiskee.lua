local rotationName = "Fiskee - 8.0.1"
local dsInterrupt = false

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.agony},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.seedOfCorruption},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shadowBolt},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonDarkglare},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.summonDarkglare},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonDarkglare},
        [4] = { mode = "Lust", value = 4 , overlay = "Cooldowns With Bloodlust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.summonDarkglare}
    };
   	CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spellLock},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spellLock}
    };
    CreateButton("Interrupt",4,0)
-- UA Mode
    UAModes = {
        [1] = { mode = "On", value = 1 , overlay = "UA spam enabled", tip = "UA spam enabled, default option for raids and dungeons", highlight = 1, icon = br.player.spell.unstableAffliction},
        [2] = { mode = "Off", value = 2 , overlay = "UA spam diabled", tip = "Will not spam UA, usefull for questing ect.", highlight = 0, icon = br.player.spell.unstableAffliction}
    };
    CreateButton("UA",5,0)
-- Phantom Singularity Button
    PSModes = {
        [1] = { mode = "On", value = 1 , overlay = "Phantom Singularity enabled", tip = "Rotation will use Phantom Singularity.", highlight = 1, icon = br.player.spell.phantomSingularity},
        [2] = { mode = "Off", value = 2 , overlay = "Phantom Singularity diabled", tip = "Phantom Singularity diabled.", highlight = 0, icon = br.player.spell.phantomSingularity}
    };
    CreateButton("PS",6,0)
-- Seed of Corruption Button
    SeedModes = {
        [1] = { mode = "On", value = 1 , overlay = "Seed of Corruption enabled", tip = "Rotation will use Seed of Corruption.", highlight = 1, icon = br.player.spell.seedOfCorruption},
        [2] = { mode = "Off", value = 2 , overlay = "Seed of Corruption diabled", tip = "Seed of Corruption diabled.", highlight = 0, icon = br.player.spell.seedOfCorruption}
    };
    CreateButton("Seed",7,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local rotationKeys = {"None", GetBindingKey("Rotation Function 1"), GetBindingKey("Rotation Function 2"), GetBindingKey("Rotation Function 3"), GetBindingKey("Rotation Function 4"), GetBindingKey("Rotation Function 5")}
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  2,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Opener
            --br.ui:createCheckbox(section,"Opener")
        -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
        -- Summon Pet
            br.ui:createDropdownWithout(section, "Summon Pet", {"Imp","Voidwalker","Felhunter","Succubus", "None"}, 1, "|cffFFFFFFSelect default pet to summon.")
        -- Mana Tap
            br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 8, 0, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")
        -- Phantom Singularity
            br.ui:createSpinnerWithout(section, "PS Units", 4, 1, 10, 1, "|cffFFFFFFNumber of Units Phantom Singularity will be cast on.")
        -- Phantom Singularity
            br.ui:createDropdownWithout(section, "Phantom Singularity Target", {"Target", "Best"}, 1, "|cffFFFFFFPhantom Singularity target")
        -- Burst target key
            br.ui:createDropdown(section,"Burst Target Key (hold)", rotationKeys, 1, "","|cffFFFFFFKey for bursting current target.")
        -- CDs with Burst target key
            br.ui:createCheckbox(section, "CDs With Burst Key", "|cffFFFFFF Pop CDs with burst key, ignoring CD setting")
        -- Shadowfury Hotkey
            br.ui:createDropdown(section,"Shadowfury Hotkey (hold)", rotationKeys, 1, "","|cffFFFFFFShadowfury stun with logic to hit most mobs. Uses keys from Bad Rotation keybindings in WoW settings")
        -- Shadowfury Target
            br.ui:createDropdownWithout(section, "Shadowfury Target", {"Best", "Target", "Cursor"}, 1, "|cffFFFFFFShadowfury target")
        -- No Dot units
            br.ui:createCheckbox(section, "Dot Blacklist", "|cffFFFFFF Check to ignore certain units for dots")
        -- Spread agony on single target
            br.ui:createCheckbox(section, "Spread Agony on ST", "|cffFFFFFF Check to spread agony when running in single target")
        -- Auto target
            br.ui:createCheckbox(section, "Auto Target", "|cffFFFFFF Will auto change to a new target, if current target is dead")
        -- Dot everything
            br.ui:createCheckbox(section, "Dot Everything (WARNING)", "|cffFFFFFF Will dot ALL units around, don't use in raids/dungeons")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- PS with CDs
            br.ui:createCheckbox(section,"Ignore PS units when using CDs")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
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
            br.ui:createCheckbox(section,"Auto Soulstone Player", "|cffFFFFFF Will put soulstone on player outside raids and dungeons")
        --Soulstone mouseover
            br.ui:createCheckbox(section,"Auto Soulstone Mouseover", "|cffFFFFFF Auto soulstone your mouseover if dead")
        --Dispel
            br.ui:createCheckbox(section,"Auto Dispel/Purge", "|cffFFFFFF Auto dispel/purge in m+, based on whitelist, set delay in healing engine settings")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
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
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions}}
    return optionTable
end
----------------
--- ROTATION ---
----------------
local function runRotation()
    -- if br.timer:useTimer("debugAffliction", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)
---------------
--- Toggles ---
---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    br.player.ui.mode.ua = br.data.settings[br.selectedSpec].toggles["UA"]
    br.player.ui.mode.ps = br.data.settings[br.selectedSpec].toggles["PS"]
    br.player.ui.mode.seed = br.data.settings[br.selectedSpec].toggles["Seed"]

--------------
--- Locals ---
--------------
    local activePet                                     = br.player.pet
    local activePetId                                   = br.player.petId
    local agonyCount                                    = br.player.debuff.agony.count()
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local castable                                      = br.player.cast.debug
    local combatTime                                    = getCombatTime()
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
    local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff                                        = br.player.debuff
    local enemies                                       = br.player.enemies
    local equiped                                       = br.player.equiped
    local falling, swimming, flying                     = getFallTime(), IsSwimming(), IsFlying()
    local friendly                                      = friendly or GetUnitIsFriend("target", "player")
    local gcd                                           = br.player.gcdMax
    local hasMouse                                      = GetObjectExists("mouseover")
    local hasteAmount                                   = GetHaste()/100
    local hasPet                                        = IsPetActive()
    local healPot                                       = getHealthPot()
    local heirloomNeck                                  = 122663 or 122664
    local inCombat                                      = isInCombat("player")
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local lastSpell                                     = lastSpellCast
    local level                                         = br.player.level
    local manaPercent                                   = br.player.power.mana.percent()
    local mode                                          = br.player.ui.mode
    local moving                                        = isMoving("player") ~= false or br.player.moving
    local pet                                           = br.player.pet.list
    local php                                           = br.player.health
    local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local shards                                        = br.player.power.soulShards.amount()
    local siphonCount                                   = br.player.debuff.siphonLife.count()
    local summonPet                                     = getOptionValue("Summon Pet")
    local solo                                          = br.player.instance=="none"
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local thp                                           = getHP("target")
    local traits                                        = br.player.traits
    local travelTime                                    = getDistance("target")/16
    local ttm                                           = br.player.power.mana.ttm()
    local units                                         = br.player.units
    local use                                           = br.player.use

    units.get(40)
    enemies.get(15,"target")
    if not isChecked("Dot Everything (WARNING)") then
        enemies.get(40)
    else
        enemies.yards40 = enemies.get(40, "player", true)
    end

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil or not inCombat then profileStop = false end
    if castSummonId == nil then castSummonId = 0 end
    if summonTime == nil then summonTime = 0 end

    local function ttd(unit)
        if UnitIsPlayer(unit) then return 999 end
        local ttdSec = getTTD(unit)
        if getOptionCheck("Enhanced Time to Die") then return ttdSec end
        if ttdSec == -1 then return 999 end
        return ttdSec
    end
    ---
    local function isCC(unit)
        if getOptionCheck("Don't break CCs") then return isLongTimeCCed(Unit) end
        return false
    end

    --Keybindings
    local shadowfuryKey = false
    local burstKey = false
    if getOptionValue("Shadowfury Hotkey (hold)") ~= 1 then
        shadowfuryKey = _G["rotationFunction"..(getOptionValue("Shadowfury Hotkey (hold)")-1)]
        if shadowfuryKey == nil then shadowfuryKey = false end
    end
    if getOptionValue("Burst Target Key (hold)") ~= 1 then
        burstKey = _G["rotationFunction"..(getOptionValue("Burst Target Key (hold)")-1)]
        if burstKey == nil then burstKey = false end
    end
    --if isBoss() then dotHPLimit = getOptionValue("Multi-Dot HP Limit")/10 else dotHPLimit = getOptionValue("Multi-Dot HP Limit") end

    if hasEquiped(132394) then agonyTick = 2 * 0.9 else agonyTick = 2 / (1 + (GetHaste()/100)) end
    local corruptionTick = 2 / (1 + (GetHaste()/100))
    local siphonTick = 3 / (1 + (GetHaste()/100))

    if debuff.unstableAffliction == nil then debuff.unstableAffliction = {} end

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

    function debuff.unstableAffliction.stack(unit)
        local uaStack = 0
        if unit == nil then
            if GetUnitExists("target") then unit = "target"
            else unit = units.dyn40
            end
        end
        for i=1,40 do
            local _,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
            if (buffSpellID == 233490 or buffSpellID == 233496 or buffSpellID == 233497 or
            buffSpellID == 233498 or buffSpellID == 233499) and GetUnitIsUnit(buffCaster, "player") then uaStack = uaStack + 1 end
        end
        return uaStack
    end

    function debuff.unstableAffliction.remain(unit)
        local remain = 0
        if unit == nil then
            if GetUnitExists("target") then unit = "target"
            else unit = units.dyn40
            end
        end
        for i=1,40 do
            local _,_,_,_,_,buffExpire,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
            if (buffSpellID == 233490 or buffSpellID == 233496 or buffSpellID == 233497 or
            buffSpellID == 233498 or buffSpellID == 233499) and GetUnitIsUnit(buffCaster, "player") then
                if (buffExpire - GetTime()) > remain then remain = (buffExpire - GetTime()) end
            end
        end
        return remain
    end
    -- Blacklist dots
    local noDotUnits = {
        [135824]=true, -- Nerubian Voidweaver
        [139057]=true, -- Nazmani Bloodhexer
        [129359]=true, -- Sawtooth Shark
        [129448]=true, -- Hammer Shark
        [134503]=true, -- Silithid Warrior
        [137458]=true, -- Rotting Spore
        [139185]=true, -- Minion of Zul
        [120651]=true -- Explosive
    }
    local function noDotCheck(unit)
        if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
        if isTotem(unit) then return true end
        unitCreator = UnitCreator(unit)
        if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
        if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
        return false
    end
    --Defensive dispel whitelist, value is for range to allies on the unit you are dispelling
    local dDispelList = {
        [255584]=0, -- Molten Gold
        [255041]=0, -- terrifying-screech
        [257908]=0, -- Oiled Blade
        [270920]=0, -- seduction
        [268233]=0, -- Electrifying Shock
        [268896]=0, -- Mind Rend
        [272571]=0, -- choking-waters
        [275014]=5, -- putrid-waters
        [268008]=0, -- snake-charm
        [280605]=0, -- brain-freeze
        [275102]=0, -- shocking-claw
        [268797]=0, -- transmute-enemy-to-goo
        [268846]=0, -- echo-blade
        [263891]=0, -- grasping-thorns
    }

    --Offensive dispel whitelist, value is for range to allies on the unit you are dispelling
    local oDispelList = {
        [255579]=0, -- Gilded Claws
        [257397]=0, -- Healing Balm
        [273432]=0, -- Bound by Shadow
        [270901]=0, -- Induce Regeneration
        [267977]=0, -- tidal-surge
        [268030]=0, -- mending-rapids
        [276767]=0, -- Consuming Void
        [272659]=0, -- electrified-scales
        [269896]=0, -- embryonic-vigor
        [269129]=0, -- accumulated-charge
        [268709]=0, -- earth-shield
        [263215]=0, -- tectonic-barrier
        [262947]=0, -- azerite-injection
        [262540]=0, -- overcharge
        [265091]=0, -- gift-of-ghuun
        [266201]=0, -- bone-shield
        [258133]=0, -- darkstep
        [258153]=0, -- watery-dome
        [278567]=0, -- soul-fetish
    }

    local function dispelUnit(unit)
    local i = 1
    local remain
    local validDispel = false
    local dispelDuration = 0
    if UnitInPhase(unit) then
        if GetUnitIsFriend("player",unit)then
            while UnitDebuff(unit,i) do
                local _,_,_,dispelType,debuffDuration,expire,_,_,_,dispelId = UnitDebuff(unit,i)
                if ((dispelType and dispelType == "Magic")) and dDispelList[dispelId] ~= nil and (dDispelList[dispelId] == 0 or (dDispelList[dispelId] > 0 and #getAllies(unit, dDispelList[dispelId]) == 1)) then
                    dispelDuration = debuffDuration
                    remain = expire - GetTime()
                    validDispel = true
                    break
                end
                i = i + 1
            end
        else
            while UnitBuff(unit,i) do
                local _,_,_,dispelType,buffDuration,expire,_,_,_,dispelId = UnitBuff(unit,i)
                if ((dispelType and dispelType == "Magic")) and oDispelList[dispelId] ~= nil and (oDispelList[dispelId] == 0 or (oDispelList[dispelId] > 0 and #getAllies(unit, oDispelList[dispelId]) == 0)) then
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
    if isChecked("Dispel delay") then dispelDelay = getValue("Dispel delay") end
    if validDispel and (dispelDuration - remain) > (dispelDelay-0.3 + math.random() * 0.6) then
        return true
    end
    return false
    end
    -- spell usable check
    local function spellUsable(spellID)
        if isKnown(spellID) and not select(2,IsUsableSpell(spellID)) and getSpellCD(spellID) == 0 then return true end
        return false
    end
    --local enemies table with extra data
    local enemyTable40 = { }
    if #enemies.yards40 > 0 then
        local highestHP
        local lowestHP
        local distance20Max
        local distance20Min
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) and (not isChecked("Dot Everything (WARNING)") or (isChecked("Dot Everything (WARNING)") and not isCC(thisUnit))) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(getDistance(thisUnit)-20)
                enemyUnit.hpabs = UnitHealth(thisUnit)
                enemyUnit.facing = getFacing("player",thisUnit)
                tinsert(enemyTable40, enemyUnit)
                if highestHP == nil or highestHP < enemyUnit.hpabs then highestHP = enemyUnit.hpabs end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then lowestHP = enemyUnit.hpabs end
                if distance20Max == nil or distance20Max < enemyUnit.distance20 then distance20Max = enemyUnit.distance20 end
                if distance20Min == nil or distance20Min > enemyUnit.distance20 then distance20Min = enemyUnit.distance20 end
            end
        end
        if #enemyTable40 > 1 then
            for i = 1, #enemyTable40 do
                local hpNorm = (5-1)/(highestHP-lowestHP)*(enemyTable40[i].hpabs-highestHP)+5 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local distance20Norm = (3-1)/(distance20Max-distance20Min)*(enemyTable40[i].distance20-distance20Min)+1 -- normalization of distance 20, low is good
                if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0/0) then distance20Norm = 0 end -- NaN check
                local enemyScore = hpNorm + distance20Norm
                if enemyTable40[i].facing then enemyScore = enemyScore + 10 end
                if enemyTable40[i].ttd > 1.5 then enemyScore = enemyScore + 10 end
                enemyTable40[i].enemyScore = enemyScore
            end
            table.sort(enemyTable40, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        if isChecked("Auto Target") and #enemyTable40 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable40[1].unit, "target")) or not GetUnitExists("target")) then
            TargetUnit(enemyTable40[1].unit)
        end
    end

    --azerite.cascading_calamity.enabled&(talent.drain_soul.enabled|talent.deathbolt.enabled&cooldown.deathbolt.remains<=gcd)
    local cascadingValue = 0
    if traits.cascadingCalamity.active and (talent.drainSoul or (talent.deathbolt and cd.deathbolt.remain() <= gcd)) then cascadingValue = cast.time.shadowBolt() end

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
    end

    -- Pet Data
    if summonPet == 1 and HasAttachedGlyph(spell.summonImp) then summonId = 58959
    elseif summonPet == 1 then summonId = 416
    elseif summonPet == 2 and HasAttachedGlyph(spell.summonVoidwalker) then summonId = 58960
    elseif summonPet == 2 then summonId = 1860
    elseif summonPet == 3 then summonId = 417
    elseif summonPet == 4 then summonId = 1863 end

    local creepingDeathValue = 0
    if talent.creepingDeath then creepingDeathValue = 1 end
    local writheInAgonyValue = 0
    if talent.writheInAgony then writheInAgonyValue = 1 end

    local seedTarget = seedTarget or "target"
    local dsTarget
    local seedHit = 0
    local seedCorruptionExist = 0
    local seedTargetCorruptionExist = 0
    local seedTargetsHit = 1
    local lowestShadowEmbrace = lowestShadowEmbrace or "target"

    local inBossFight = false
    for i = 1, #enemyTable40 do
        local thisUnit = enemyTable40[i].unit
        if isBoss(thisUnit) then
            inBossFight = true
        end
        if talent.shadowEmbrace and debuff.shadowEmbrace.exists(thisUnit) then
            if debuff.shadowEmbrace.exists(lowestShadowEmbrace) then
                shadowEmbraceRemaining = debuff.shadowEmbrace.remain(lowestShadowEmbrace)
            else
                shadowEmbraceRemaining = 40
            end
            if debuff.shadowEmbrace.remain(thisUnit) < shadowEmbraceRemaining then
                lowestShadowEmbrace = thisUnit
            end
        end
        local unitAroundUnit = getEnemies(thisUnit, 10, true)
        if mode.seed == 1 and getFacing("player",thisUnit) and #unitAroundUnit > seedTargetsHit and ttd(thisUnit) > 8 then
            seedHit = 0
            seedCorruptionExist = 0
            for q = 1, #unitAroundUnit do
                local seedAoEUnit = unitAroundUnit[q]
                if ttd(seedAoEUnit) > cast.time.seedOfCorruption()+3 then seedHit = seedHit + 1 end
                if debuff.corruption.exists(seedAoEUnit) then seedCorruptionExist = seedCorruptionExist + 1 end
            end
            if seedHit > seedTargetsHit or (GetUnitIsUnit(thisUnit, "target") and seedHit >= seedTargetsHit) then
                seedTarget = thisUnit
                seedTargetsHit = seedHit
                seedTargetCorruptionExist = seedCorruptionExist
            end
        end
        if getFacing("player",thisUnit) and ttd(thisUnit) <= gcd and getHP(thisUnit) < 80 then
            dsTarget = thisUnit
        end
    end
    -- actions=variable,name=spammable_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5|spell_targets.seed_of_corruption>=8
    local spammableSeed = false
    if (talent.sowTheSeeds and seedTargetsHit >= 3) or (talent.siphonLife and seedTargetsHit >= 5) or (seedTargetsHit >= 8) then
        spammableSeed = true
    end
    -- average = 1.0 / ( 0.184 * std::pow( active_agonies, -2.0 / 3.0 ) ) * dot_tick_time.total_seconds() / active_agonies;
    local timeToShard = 10
    if(agonyCount > 0) then
        timeToShard = 1.0 / (0.184 * math.pow(agonyCount, -2.0 / 3.0)) * agonyTick / agonyCount
    end

--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
    local function actionList_Extras()
    -- Dummy Test
        if isChecked("DPS Testing") then
            if GetObjectExists("target") then
                if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                    StopAttack()
                    ClearTarget()
                    if isChecked("Pet Management") then
                        PetStopAttack()
                        PetFollow()
                    end
                    Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    profileStop = true
                end
            end
        end -- End Dummy Test
        if isChecked("Shadowfury Hotkey (hold)") and shadowfuryKey and not GetCurrentKeyBoardFocus() then
            if getOptionValue("Shadowfury Target") == 1 then
                if cast.shadowfury("best",false,1,8) then return end
            elseif getOptionValue("Shadowfury Target") == 2 then
                if cast.shadowfury("target", "ground") then return end
            elseif getOptionValue("Shadowfury Target") == 3 and isKnown(spell.shadowfury) and getSpellCD(spell.shadowfury) == 0 then
                CastSpellByName(GetSpellInfo(spell.shadowfury),"cursor")
                return
            end
        end
        --Burn Units
        local burnUnits = {
            [120651]=true, -- Explosive
            [141851]=true -- Infested
        }
        if GetObjectExists("target") and burnUnits[GetObjectID("target")] ~= nil then
            if cast.unstableAffliction("target") then return true end
            if cast.shadowBolt("target") then return true end
        end
        --Soulstone
        if isChecked("Auto Soulstone Mouseover") and inCombat and not moving and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
            if cast.soulstone("mouseover","dead") then return true end
        end
        if isChecked("Auto Soulstone Player") and not inInstance and not inRaid and (not buff.soulstone.exists("player") or buff.soulstone.remain("player") < 100) and not inCombat and not moving then
            if cast.soulstone("player") then return end
        end
    end -- End Action List - Extras
	-- Action List - Defensive
    local function actionList_Defensive()
        if useDefensive() then
        -- Pot/Stoned
            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512))
            then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                end
            end
            -- Heirloom Neck
            if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                if hasEquiped(heirloomNeck) then
                    if GetItemCooldown(heirloomNeck)==0 then
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
                            if cast.devourMagic(thisUnit) then return true end
                        end
                    end
                end
                if spellUsable(spell.singeMagic) or spellUsable(spell.singeMagicGrimoire) then
                    for i = 1, #br.friend do
                        local thisUnit = br.friend[i].unit
                        if dispelUnit(thisUnit) then
                            if cast.singeMagic(thisUnit) then return true end
                            if cast.singeMagicGrimoire(thisUnit) then return true end
                        end
                    end
                end
            end
            -- Gift of the Naaru
            if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                if castSpell("player",racial,false,false,false) then return end
            end
            -- Dark Pact
            if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
                if cast.darkPact() then return end
            end
            -- Drain Life
            if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and isValidTarget("target") and not moving then
                if cast.drainLife() then return end
            end
            -- Health Funnel
            if isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") and not moving then
                if cast.healthFunnel("pet") then return end
            end
            -- Unending gResolve
            if isChecked("Unending Resolve") and php <= getOptionValue("Unending Resolve") and inCombat then
                if cast.unendingResolve() then return end
            end
        end -- End Defensive Toggle
    end -- End Action List - Defensive
	-- Action List - Interrupts
    local function actionList_Interrupts()
      if useInterrupts() then
        if talent.grimoireOfSacrifice then
          for i=1, #enemyTable40 do
            thisUnit = enemyTable40[i].unit
            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
              if cast.spellLockgrimoire(thisUnit) then return end
          end
        end
        elseif activePetId ~= nil and (activePetId == 417 or activePetId == 78158) then
          for i=1, #enemyTable40 do
            thisUnit = enemyTable40[i].unit
            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                if activePetId == 417 then
                    if cast.spellLock(thisUnit) then return end
                end
            end
          end
        end
    end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
    local function actionList_Cooldowns()
        if getDistance(units.dyn40) < 40 then
        if isChecked("Racial") and not moving then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
        end
        if isChecked("Trinkets") then
            if canUseItem(13) then
                useItem(13)
            end
            if canUseItem(14) then
                useItem(14)
            end
        end
      end -- End useCDs check
    end -- End Action List - Cooldowns

    local function actionList_Fillers()
        -- actions.fillers=deathbolt
        if not moving and (debuff.agony.exists() or debuff.corruption.exists()) then
            if cast.deathbolt() then return true end
        end
        -- actions.fillers+=/shadow_bolt,if=buff.movement.up&buff.nightfall.remains
        if moving and buff.nightfall.exists() and not talent.drainSoul then
            if cast.shadowBolt() then return true end
        end
        -- actions.fillers+=/agony,if=buff.movement.up&!(talent.siphon_life.enabled&(prev_gcd.1.agony&prev_gcd.2.agony&prev_gcd.3.agony)|prev_gcd.1.agony)
        if moving and (not ((talent.siphonLife and (cast.last.agony(1) or cast.last.agony(2) or cast.last.agony(3))) or not talent.siphonLife and cast.last.agony(1)) or talent.absoluteCorruption) then
            if cast.agony() then return true end
        end
        -- actions.fillers+=/siphon_life,if=buff.movement.up&!(prev_gcd.1.siphon_life&prev_gcd.2.siphon_life&prev_gcd.3.siphon_life)
        if moving and not cast.last.siphonLife() then
            if cast.siphonLife() then return true end
        end
        -- actions.fillers+=/corruption,if=buff.movement.up&!prev_gcd.1.corruption&!talent.absolute_corruption.enabled
        if moving and not cast.last.corruption() and (not talent.absoluteCorruption or not debuff.corruption.exists()) then
            if cast.corruption() then return true end
        end
        -- actions.fillers+=/drain_life,if=(buff.inevitable_demise.stack=100|buff.inevitable_demise.stack>60&target.time_to_die<=10)&(target.health.pct>=20|!talent.drain_soul.enabled)
        -- if not moving and not cast.last.drainLife() and (buff.inevitableDemise.stack() == 100 or (useCDs() and buff.inevitableDemise.stack() > 60 and ttd("target") <= 10)) and (thp >= 20 or not talent.drainSoul) and ttd("target") > 5 then
        --     if cast.drainLife() then return true end
        -- end
        -- haunt
        if not moving then
            if cast.haunt() then return true end
        end
        -- actions.fillers+=/drain_soul,interrupt_global=1,chain=1
        if not moving and not cast.current.drainSoul() then
        if cast.drainSoul() then
            dsInterrupt = true
            return true end
        end
        -- actions.fillers+=/shadow_bolt,cycle_targets=1,if=talent.shadow_embrace.enabled&talent.absolute_corruption.enabled&active_enemies=2&!debuff.shadow_embrace.remains&!action.shadow_bolt.in_flight
        if not moving and talent.shadowEmbrace and talent.absoluteCorruption and #enemyTable40 == 2 and not talent.drainSoul then
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if not debuff.shadowEmbrace.exists(thisUnit) then
                if cast.shadowBolt(thisUnit) then return true end
            end
        end
        end
        -- actions.fillers+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&talent.absolute_corruption.enabled&active_enemies=2
        if not moving and talent.shadowEmbrace and talent.absoluteCorruption and #enemyTable40 == 2 and not talent.drainSoul then
            if cast.shadowBolt(lowestShadowEmbrace) then return true end
        end
        -- actions.fillers+=/shadow_bolt
        if not moving and not talent.drainSoul then
            if cast.shadowBolt() then return true end
        end
    end
-- Action List - Burst Target
    local function actionList_BurstTarget()
        -- actions+=/haunt
        if not moving then
            if cast.haunt() then return true end
        end
        -- actions+=/summon_darkglare,if=dot.agony.ticking&dot.corruption.ticking&(buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains)
        if getSpellCD(spell.summonDarkglare) == 0 and (useCDs() or (isChecked("CDs With Burst Key") and burstKey)) and debuff.agony.exists() and debuff.corruption.exists() and (debuff.unstableAffliction.stack() == 5 or shards == 0) and (not talent.phantomSingularity or (talent.phantomSingularity and (cd.phantomSingularity.remain() > 0 or #enemies.yards15t < getOptionValue("PS Units") or mode.ps ~= 1))) then
            CastSpellByName(GetSpellInfo(spell.summonDarkglare))
            return true
        end
        --Agony
        if ttd("target") > 8 and debuff.agony.refresh() then
            if cast.agony() then return true end
        end
        --Siphon life
        if ttd("target") > 8 and debuff.siphonLife.refresh() and (not useCDs() or cd.summonDarkglare.remain() > shards * cast.time.unstableAffliction()) then
            if cast.siphonLife() then return true end
        end
        --Corruption
        if ttd("target") > 8 and debuff.corruption.refresh() then
            if cast.corruption() then return true end
        end
        -- actions+=/phantom_singularity
        if mode.ps == 1 and #enemies.yards15t >= getOptionValue("PS Units") or (isChecked("CDs With Burst Key") and burstKey) or (isChecked("Ignore PS units when using CDs") and useCDs()) then
            if cast.phantomSingularity("target", "aoe", 1, 15) then return true end
        end
        -- actions+=/vile_taint
        if not moving then
            if cast.vileTaint() then return true end
        end
        -- actions+=/dark_soul
        if useCDs() or isChecked("CDs With Burst Key") and not moving then
            if cast.darkSoul("player") then return true end
        end
        -- actions+=/berserking
        if isChecked("Racial") and race == "Troll" and (useCDs() or (isChecked("CDs With Burst Key") and burstKey)) and not moving then
            if cast.racial("player") then return true end
        end
        -- actions+=/unstable_affliction,if=cooldown.summon_darkglare.remains<=soul_shard*cast_time
        if not moving and ttd("target") > 2 and (((useCDs() or (isChecked("CDs With Burst Key") and burstKey)) and cd.summonDarkglare.remain() <= shards * cast.time.unstableAffliction()) or (not useCDs() and not isChecked("CDs With Burst Key"))) then
            if cast.unstableAffliction() then return true end
        end
        --Spread agony
        if isChecked("Spread Agony on ST") and mode.rotation == 3 then
            -- actions+=/agony,cycle_targets=1,max_cycle_targets=6,if=talent.creeping_death.enabled&target.time_to_die>10&refreshable
            -- actions+=/agony,cycle_targets=1,max_cycle_targets=8,if=(!talent.creeping_death.enabled)&target.time_to_die>10&refreshable
            if (talent.creepingDeath and agonyCount < 6) or (not talent.creepingDeath and agonyCount < 8) and agonyCount < getOptionValue("Multi-Dot Limit") then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if not debuff.agony.exists(thisUnit) and ttd(thisUnit) > 10 and not noDotCheck(thisUnit) then
                        if cast.agony(thisUnit) then return true end
                    end
                end
            end
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if ttd(thisUnit) > 10 and debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit) then
                    if cast.agony(thisUnit) then return true end
                end
            end
        end
        -- actions+=/call_action_list,name=fillers,if=(cooldown.summon_darkglare.remains<time_to_shard*(5-soul_shard)|cooldown.summon_darkglare.up)&time_to_die>cooldown.summon_darkglare.remains
        if ((useCDs() or (isChecked("CDs With Burst Key") and burstKey)) and cd.summonDarkglare.remain() < timeToShard * (5 - shards) and ttd("target") > cd.summonDarkglare.remain()) then
            if actionList_Fillers() then return true end
        end
        --UA
        if not moving and not cast.last.summonDarkglare() and ((talent.deathbolt and cd.deathbolt.remain() <= cast.time.unstableAffliction()) or (shards >= 2 and ttd("target") > 4 + cast.time.unstableAffliction()) or (ttd("target") <= 8 + cast.time.unstableAffliction() * shards)) then
            if cast.unstableAffliction() then return true end
        end
        -- actions+=/unstable_affliction,if=!variable.spammable_seed&contagion<=cast_time+variable.padding
        if not moving and debuff.unstableAffliction.remain() <= cast.time.unstableAffliction() and ttd("target") > 2 + cast.time.unstableAffliction() then
            if cast.unstableAffliction() then return true end
        end
        --actions.spenders+=/unstable_affliction,if=cooldown.deathbolt.up&prev_gcd.1.summon_darkglare
        if not moving and cast.last.summonDarkglare() and cd.deathbolt.remain() == 0 then
            if cast.unstableAffliction() then return true end
        end
        -- actions+=/call_action_list,name=fillers
        if actionList_Fillers() then return true end
    end
-- Action List - Rotation
    local function actionList_Rotation()
        -- actions+=/drain_soul,interrupt_global=1,chain=1,cycle_targets=1,if=target.time_to_die<=gcd&soul_shard<5
        if dsTarget ~= nil and (not cast.current.drainSoul() or (cast.current.drainSoul() and dsInterrupt)) and not moving and shards < 5 then
            if cast.drainSoul(dsTarget) then
                dsInterrupt = false
                return true
            end
        end
        -- actions+=/haunt
        if not moving and seedTargetsHit <= 2 then
            if cast.haunt() then return true end
        end
        -- actions+=/summon_darkglare,if=dot.agony.ticking&dot.corruption.ticking&(buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains)
        if getSpellCD(spell.summonDarkglare) == 0 and useCDs() and debuff.agony.exists() and debuff.corruption.exists() and (debuff.unstableAffliction.stack() == 5 or shards == 0) and (not talent.phantomSingularity or (talent.phantomSingularity and (cd.phantomSingularity.remain() > 0 or #enemies.yards15t < getOptionValue("PS Units") or mode.ps ~= 1))) then
            CastSpellByName(GetSpellInfo(spell.summonDarkglare))
            return true
        end
        -- actions+=/agony,cycle_targets=1,if=remains<=gcd
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if debuff.agony.exists(thisUnit) and debuff.agony.remain(thisUnit) <= gcd + cast.time.shadowBolt() and ttd(thisUnit) > 8 then
                if cast.agony(thisUnit) then return true end
            end
        end
        -- actions+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&talent.absolute_corruption.enabled&active_enemies=2&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=execute_time*2+travel_time&!action.shadow_bolt.in_flight
        if talent.shadowEmbrace and not talent.drainSoul and talent.absoluteCorruption and #enemyTable40 == 2 and debuff.shadowEmbrace.exists() and debuff.shadowEmbrace.remain() <= cast.time.shadowBolt() * 2 + travelTime and not cast.last.shadowBolt() then
            if cast.shadowBolt() then return true end
        end
        -- actions+=/phantom_singularity,if=time>40&(cooldown.summon_darkglare.remains>=45|cooldown.summon_darkglare.remains<8)
        if mode.ps == 1 and combatTime > 40 and (cd.summonDarkglare.remain() >= 45 or cd.summonDarkglare.remain() < 8) then
            if getOptionValue("Phantom Singularity Target") == 1 and (#enemies.yards15t >= getOptionValue("PS Units") or (isChecked("Ignore PS units when using CDs") and useCDs())) then
                if cast.phantomSingularity("target", "aoe", 1, 15) then return true end
            elseif getOptionValue("Phantom Singularity Target") == 2 then
                if isChecked("Ignore PS units when using CDs") and useCDs() then
                    if cast.phantomSingularity("best",false,1,10) then return true end
                else
                    if cast.phantomSingularity("best",false,getOptionValue("PS Units"),10) then return true end
                end
            end
        end
        -- actions+=/vile_taint,if=time>20
        if combatTime > 20 and not moving then
            if cast.vileTaint() then return true end
        end
        -- actions+=/seed_of_corruption,if=dot.corruption.remains<=action.seed_of_corruption.cast_time+time_to_shard+4.2*(1-talent.creeping_death.enabled*0.15)&spell_targets.seed_of_corruption_aoe>=3+talent.writhe_in_agony.enabled&!dot.seed_of_corruption.remains&!action.seed_of_corruption.in_flight
        if not moving and debuff.corruption.remain(seedTarget) <= cast.time.seedOfCorruption() + timeToShard + 4.2 *(1 - creepingDeathValue * 0.15) and seedTargetsHit >= 3 + writheInAgonyValue and debuff.seedOfCorruption.count() == 0 and not cast.last.seedOfCorruption(1) and not cast.last.seedOfCorruption(2) then
            if cast.seedOfCorruption(seedTarget) then return true end
        end
        -- Agony on seed dot if missing
        if not debuff.agony.exists(seedTarget) and debuff.seedOfCorruption.exists(seedTarget) then
            if cast.agony(seedTarget) then return true end
        end
        -- actions+=/agony,cycle_targets=1,max_cycle_targets=6,if=talent.creeping_death.enabled&target.time_to_die>10&refreshable
        -- actions+=/agony,cycle_targets=1,max_cycle_targets=8,if=(!talent.creeping_death.enabled)&target.time_to_die>10&refreshable
        if not debuff.agony.exists("target") and ttd("target") > 10 then
            if cast.agony("target") then return true end
        end
        if (talent.creepingDeath and agonyCount < 6) or (not talent.creepingDeath and agonyCount < 8) and agonyCount < getOptionValue("Multi-Dot Limit") then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if not debuff.agony.exists(thisUnit) and ttd(thisUnit) > 10 and not noDotCheck(thisUnit) then
                    if cast.agony(thisUnit) then return true end
                end
            end
        end
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if ttd(thisUnit) > 10 and debuff.agony.exists(thisUnit) and debuff.agony.refresh(thisUnit) then
                if cast.agony(thisUnit) then return true end
            end
        end
        -- actions.dots+=/siphon_life,target_if=min:remains,if=(active_dot.siphon_life<8-talent.creeping_death.enabled-spell_targets.sow_the_seeds_aoe)&target.time_to_die>10&refreshable&!(cooldown.summon_darkglare.remains<=soul_shard*action.unstable_affliction.execute_time)
        if talent.siphonLife and siphonCount < (8 - creepingDeathValue - seedTargetsHit) and siphonCount < getOptionValue("Multi-Dot Limit") then
        if (not debuff.siphonLife.exists("target") or debuff.siphonLife.refresh("target")) and ttd("target") > 10 then
            if cast.siphonLife("target") then return true end
        end
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if not debuff.siphonLife.exists(thisUnit) and ttd(thisUnit) > 10 and not noDotCheck(thisUnit) then
                if cast.siphonLife(thisUnit) then return true end
            end
        end
        end
        for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if ttd(thisUnit) > 10 and (debuff.siphonLife.exists(thisUnit) and debuff.siphonLife.refresh(thisUnit)) then
                if cast.siphonLife(thisUnit) then return true end
            end
        end
        -- actions+=/corruption,cycle_targets=1,if=active_enemies<3+talent.writhe_in_agony.enabled&refreshable&target.time_to_die>10
        if seedTargetsHit < 3 + writheInAgonyValue or moving or mode.seed == 2 then
            if (debuff.corruption.refresh("target") or not debuff.corruption.exists("target")) and ttd("target") > 10 then
                if cast.corruption("target") then return true end
            end
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if not debuff.corruption.exists(thisUnit) and ttd(thisUnit) > 10 and not noDotCheck(thisUnit) then
                    if cast.corruption(thisUnit) then return true end
                end
            end
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if (debuff.corruption.exists(thisUnit) and debuff.corruption.refresh(thisUnit)) and ttd(thisUnit) > 10 and not noDotCheck(thisUnit) then
                    if cast.corruption(thisUnit) then return true end
                end
            end
        end
        -- actions+=/phantom_singularity
        if mode.ps == 1 and combatTime <= 40 then
            if getOptionValue("Phantom Singularity Target") == 1 and (#enemies.yards15t >= getOptionValue("PS Units") or (isChecked("Ignore PS units when using CDs") and useCDs())) then
                if cast.phantomSingularity("target", "aoe", 1, 15) then return true end
            elseif getOptionValue("Phantom Singularity Target") == 2 then
                if isChecked("Ignore PS units when using CDs") and useCDs() then
                    if cast.phantomSingularity("best",false,1,10) then return true end
                else
                    if cast.phantomSingularity("best",false,getOptionValue("PS Units"),10) then return true end
                end
            end
        end
        -- actions+=/vile_taint
        if not moving then
            if cast.vileTaint() then return true end
        end
        -- actions+=/dark_soul
        if useCDs() and not moving then
            if cast.darkSoul("player") then return end
        end
        -- actions+=/berserking
        if isChecked("Racial") and race == "Troll" and useCDs() and not moving then
            if cast.racial("player") then return true end
        end
        -- actions+=/unstable_affliction,if=soul_shard>=5
        if shards >= 5 and not spammableSeed and not moving and ttd("target") > 2 + cast.time.unstableAffliction() then
            if cast.unstableAffliction() then return true end
        end
        -- actions+=/unstable_affliction,if=cooldown.summon_darkglare.remains<=soul_shard*cast_time
        if not moving and ttd("target") > 2 and useCDs() and cd.summonDarkglare.remain() <= shards * cast.time.unstableAffliction() then
            if cast.unstableAffliction() then return true end
        end
        -- actions+=/call_action_list,name=fillers,if=(cooldown.summon_darkglare.remains<time_to_shard*(5-soul_shard)|cooldown.summon_darkglare.up)&time_to_die>cooldown.summon_darkglare.remains
        if (useCDs() and cd.summonDarkglare.remain() < timeToShard * (5 - shards) and ttd("target") > cd.summonDarkglare.remain()) or mode.ua == 2 then
            if actionList_Fillers() then return true end
        end
        -- actions+=/seed_of_corruption,if=variable.spammable_seed
        if spammableSeed and not moving then
            if cast.seedOfCorruption(seedTarget) then return true end
        end
        -- actions.spenders+=/unstable_affliction,if=!variable.use_seed&!prev_gcd.1.summon_darkglare&(talent.deathbolt.enabled&cooldown.deathbolt.remains<=execute_time&!azerite.cascading_calamity.enabled|soul_shard>=2&target.time_to_die>4+execute_time&active_enemies=1|target.time_to_die<=8+execute_time*soul_shard)
        if not moving and not cast.last.summonDarkglare() and not spammableSeed and ((talent.deathbolt and cd.deathbolt.remain() <= cast.time.unstableAffliction() and not traits.cascadingCalamity.active) or (shards >= 2 and ttd("target") > 4 + cast.time.unstableAffliction() and enemyTable40 == 1) or (ttd("target") <= 8 + cast.time.unstableAffliction() * shards)) then
            if cast.unstableAffliction() then return true end
        end
        -- actions+=/unstable_affliction,if=!variable.spammable_seed&contagion<=cast_time+variable.padding
        if not spammableSeed and not moving and debuff.unstableAffliction.remain() <= (cast.time.unstableAffliction() + cascadingValue) and ttd("target") > 2 + cast.time.unstableAffliction() then
            if cast.unstableAffliction() then return true end
        end
        --actions.spenders+=/unstable_affliction,cycle_targets=1,if=!variable.use_seed&(!talent.deathbolt.enabled|cooldown.deathbolt.remains>time_to_shard|soul_shard>1)&contagion<=cast_time+variable.padding&(!azerite.cascading_calamity.enabled|buff.cascading_calamity.remains>time_to_shard)
        if not spammableSeed and not moving and (((not talent.deathbolt or cd.deathbolt.remain() > timeToShard or shards > 1) and (not traits.cascadingCalamity.active or (buff.cascadingCalamity.remain() > timeToShard))) or not inBossFight)  then
            for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if debuff.unstableAffliction.remain(thisUnit) <= (cast.time.unstableAffliction() + cascadingValue) and ttd(thisUnit) > 2 + cast.time.unstableAffliction() and not noDotCheck(thisUnit) then
                    if cast.unstableAffliction(thisUnit) then return true end
                end
            end
        end
        --actions.spenders+=/unstable_affliction,if=cooldown.deathbolt.up&prev_gcd.1.summon_darkglare
        if not moving and cast.last.summonDarkglare() and cd.deathbolt.remain() == 0 then
            if cast.unstableAffliction() then return true end
        end
        -- actions+=/call_action_list,name=fillers
        if actionList_Fillers() then return true end
    end -- End Action List - Haunt
    -- Action List - Opener
    local function actionList_Opener()
        opener = true
    end
    -- Action List - PreCombat
    local function actionList_PreCombat()
    -- Summon Pet
        -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
        local petPadding = 2
        if talent.grimoireOfSacrifice then petPadding = 5 end
        if isChecked("Pet Management") and not (IsFlying() or IsMounted()) and (not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) and level >= 5 and br.timer:useTimer("summonPet", cast.time.summonVoidwalker() + petPadding) and not moving then
            if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0) then
                if summonPet == 1 and (lastSpell ~= spell.summonImp or activePetId == 0) then
                    if cast.summonImp("player") then castSummonId = spell.summonImp return end
                elseif summonPet == 2 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                    if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker return end
                elseif summonPet == 3 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                    if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter return end
                elseif summonPet == 4 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                    if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus return end
                end
            end
        end
        -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
        if talent.grimoireOfSacrifice and isChecked("Pet Management") and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
            if cast.grimoireOfSacrifice() then return end
        end
        if not inCombat and not (IsFlying() or IsMounted()) then
        -- Flask
            -- flask,type=whispered_pact
        -- Food
            -- food,type=azshari_salad
            if (not isChecked("Opener") or opener == true) then
                if useCDs() and isChecked("Pre-Pull Timer") then --and pullTimer <= getOptionValue("Pre-Pull Timer") then
                    if pullTimer <= getOptionValue("Pre-Pull Timer") - 0.5 then
                        if canUseItem(142117) and not buff.prolongedPower.exists() then
                            useItem(142117);
                            return true
                        end
                    end
                    if pullTimer <= getOptionValue("Pre-Pull Timer") - 0.5 then
                        if talent.soulEffigy and not effigied then
                            if not GetObjectExists("target") then
                                TargetUnit(units.dyn40)
                            end
                            if GetObjectExists("target") then
                                if cast.soulEffigy("target") then return end
                            end
                        end
                    end
                end -- End Pre-Pull
                if isValidUnit("target") and getDistance("target") < 40 and (not isChecked("Opener") or opener == true) then
            -- Life Tap
                    -- life_tap,if=talent.empowered_life_tap.enabled&!buff.empowered_life_tap.remains
                    if talent.empoweredLifeTap and not buff.empoweredLifeTap.exists() then
                        if cast.lifeTap() then return end
                    end
            -- Pet Attack/Follow
                    if isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
                        PetAssistMode()
                        PetAttack("target")
                    end
                    -- actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3
                    if not moving and #getEnemies("target", 10, true) >= 3 then
                        if cast.seedOfCorruption("target") then return true end
                    end
                    -- actions.precombat+=/haunt
                    if not moving then
                        if cast.haunt("target") then return true end
                    end
                    -- actions.precombat+=/shadow_bolt,if=!talent.haunt.enabled&spell_targets.seed_of_corruption_aoe<3
                    if not moving and #getEnemies("target", 10, false) < 3 and not talent.haunt and not talent.drainSoul then
                        if cast.shadowBolt("target") then return true end
                    end
                    --else agony
                    if cast.agony("target") then return true end
                    --low level
                    if level < 10 and not moving then
                        if cast.shadowBolt() then return true end
                    end
                end
            end
        end -- End No Combat
        if actionList_Opener() then return end
    end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or (pause(true) and not cast.current.drainSoul()) or mode.rotation==4 then
        if not pause() and IsPetAttackActive() and isChecked("Pet Management") then
            PetStopAttack()
            PetFollow()
        end
        return true
    else
-----------------------
--- Extras Rotation ---
-----------------------
        if actionList_Extras() then return end
    --------------------------
    --- Defensive Rotation ---
    --------------------------
        if actionList_Defensive() then return end
    -----------------------
    --- Opener Rotation ---
    -----------------------
        if opener == false and isChecked("Opener") and isBoss("target") then
            if actionList_Opener() then return end
        end
    ---------------------------
    --- Pre-Combat Rotation ---
    ---------------------------
        if actionList_PreCombat() then return end
    --------------------------
    --- In Combat Rotation ---
    --------------------------
        if inCombat and profileStop==false and #enemyTable40 > 0
            and (opener == true or not isChecked("Opener") or not isBoss("target")) and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
            if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
            if getOptionValue("APL Mode") == 1 and not pause() then
    -- Pet Attack
                if isChecked("Pet Management") and not GetUnitIsUnit("pettarget","target") and isValidUnit("target") then
                    PetAttack()
                end
                --CDs
                if useCDs() then
                    if actionList_Cooldowns() then return end
                end
                -- Burst
                if (isChecked("Burst Target Key (hold)") and burstKey and not GetCurrentKeyBoardFocus()) or mode.rotation == 3 then
                    if actionList_BurstTarget() then return end
                end
                -- rotation
                if actionList_Rotation() then return end
            end -- End SimC APL
        end --End In Combat
    end --End Rotation Logic
end -- End Run Rotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
    shadowFury = false
})
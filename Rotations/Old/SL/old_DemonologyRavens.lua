local rotationName = "|cffC942FDTyrantRavens" -- Change to name of profile listed in options drop down

local dreadstalkersActive, grimoireActive = false, false
local dreadstalkersTime, grimoireTime, ppDb, castSummonId, opener, summonTime
---------------
--- Toggles ---
---------------
local function createToggles () -- Define custom toggles
-- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Rotation Enabled", tip = "DPS Rotation Enabled", highlight = 1, icon = br.player.spell.handOfGuldan },
        [2] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "DPS Rotation Disabled", highlight = 0, icon = br.player.spell.drainLife }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonDemonicTyrant },
        [2] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonDemonicTyrant }
    };
    CreateButton("Cooldown",2,0)
-- Bilescourge Bombers Button
    BilescourgeBombersModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Bilescourge Bombers Enabled", tip = "Use Bilescourge Bombers.", highlight = 1, icon = br.player.spell.bilescourgeBombers },
        [2] = { mode = "Off", value = 2 , overlay = "Bilescourge Bombers Disabled", tip = "Don't use Bilescourge Bombers.", highlight = 0, icon = br.player.spell.bilescourgeBombers }
    };
    CreateButton("BilescourgeBombers",3,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Use Defensive Abilities.", highlight = 1, icon = br.player.spell.unendingResolve },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Don't use Defensive Abilities.", highlight = 0, icon = br.player.spell.unendingResolve }
    };
    CreateButton("Defensive",4,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spellLock },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spellLock }
    }
    CreateButton("Interrupt",5,0)
end


-- Colors
local cPurple   = "|cffC942FD"
local cBlue     = "|cff00CCFF"
local cGreen    = "|cff00FF00"
local cRed      = "|cffFF0000"
local cWhite    = "|cffFFFFFF"
local cGold     = "|cffFFDD11"
local cLegendary= "|cffff8000"


-- Always				Will use the ability even if CDs are disabled.
-- Always Boss			Will use the ability even if CDs are disabled as long as the current target is a Boss.
-- OnCooldown			Will only use the ability if the Cooldown Toggle is Enabled.
-- OnCooldown Boss		Will only use the ability if the Cooldown Toggle is Enabled and Target is a Boss.

--createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, hideCheckbox)
function br.ui:createCDOption(parent, text, tooltip, hideCheckbox)
	local cooldownModes = {"Always", "Always Boss", "OnCooldown", "OnCooldown Boss"}
	local tooltipDrop = cPurple.."Always"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite..[[. 
]]..cPurple.."Always Boss"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite.." as long as the current target is a Boss"..[[. 
]]..cPurple.."OnCooldown"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite..[[. 
]]..cPurple.."OnCooldown Boss"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite.." and Target is a Boss."
	br.ui:createDropdown(parent, text, cooldownModes, 3, tooltip, tooltipDrop, hideCheckbox)
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
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
            br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffFFFFFFWill precast demonbolt on pull if pulltimer is active")
            -- Opener
            --br.ui:createCheckbox(section,"Opener")
            -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
            -- Summon Pet
            br.ui:createDropdownWithout(section, "Summon Pet", {"Felguard", "Imp", "Voidwalker", "Felhunter", "Succubus", "None"}, 1, "|cffFFFFFFSelect default pet to summon")
            -- -- Life Tap
            -- br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below")
            -- Shadowfury Hotkey
            br.ui:createDropdown(section, "Shadowfury Hotkey", rotationKeys, 1, "", "|cffFFFFFFShadowfury stun with logic to hit most mobs. Uses keys from Bad Rotation keybindings in WoW settings")
            -- Shadowfury Target
            br.ui:createDropdownWithout(section, "Shadowfury Target", {"Best", "Target", "Cursor"}, 1, "|cffFFFFFFShadowfury target")
            -- -- No Dot units
            -- br.ui:createCheckbox(section, "Dot Blacklist", "|cffFFFFFF Check to ignore certain units for dots")
            -- -- Auto target
            -- br.ui:createCheckbox(section, "Auto Target", "|cffFFFFFF Will auto change to a new target, if current target is dead")
            -- -- Implosion Unit
            -- br.ui:createSpinnerWithout(section, "Implosion Units", 2, 1, 10, 1, "|cffFFFFFFMinimum units to cast Implosion")
        br.ui:checkSectionState(section)
		-------------------------
        --- OFFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Offensive")
            -- -- Bilescourge Bombers with CDs
            -- br.ui:createCheckbox(section, "Ignore Bilescourge Bombers units when using CDs")
            -- Racial
            br.ui:createCDOption(section, "Racial", "Use Racial")
            -- Trinkets
            br.ui:createCDOption(section, "Trinket 1", "Use of Trinket 1")
            br.ui:createCDOption(section, "Trinket 2", "Use of Trinket 2")
            -- -- Potion
            -- br.ui:createCheckbox(section, "Potion")
            -- -- Pre Pot
            -- br.ui:createCheckbox(section, "Pre Pot", "|cffFFFFFF Requires Pre-Pull logic to be active")
            -- Demonic Tyrant
			br.ui:createCDOption(section, "Demonic Tyrant", "Use of Demonic Tyrant")
            -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 7, 1, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")
            -- Bilescourge Bombers Target
            br.ui:createDropdownWithout(section, "Bilescourge Target", {"Target", "Best"}, 2, "|cffFFFFFFBilescourge Bombers target")
            -- Bilescourge Bombers Unit
            br.ui:createSpinnerWithout(section, "Bilescourge Units", 1, 1, 10, 1, "|cffFFFFFFMinimum units to cast Bilescourge Bombers")
            -- Demonbolt dump
            br.ui:createSpinnerWithout(section, "Demonbolt Dump", 4, 1, 5, 1, "|cffFFFFFFUse Demonbolt on chosen value of Demonic Core stacks. Standard is 4.")
        br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healing Potion
			br.ui:createSpinner(section, "Healing Potion",  60,  0,  100,  5,  "Health Percentage to use at.")
			-- Healthstone
			br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "Health Percentage to use at.")
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
            -- --Soulstone
            -- br.ui:createCheckbox(section, "Auto Soulstone Player", "|cffFFFFFF Will put soulstone on player outside raids and dungeons")
            -- --Soulstone mouseover
            -- br.ui:createCheckbox(section, "Auto Soulstone Mouseover", "|cffFFFFFF Auto soulstone your mouseover if dead")
            -- --Dispel
            -- br.ui:createCheckbox(section, "Auto Dispel/Purge", "|cffFFFFFF Auto dispel/purge in m+, based on whitelist, set delay in healing engine settings")
        br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "|cffFFFFFFCast Percent to Cast At")
            br.ui:checkSectionState(section)
		----------------------
		--- TOGGLE OPTIONS ---
		----------------------
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
    br.player.ui.mode.bsb = br.data.settings[br.selectedSpec].toggles["BilescourgeBombers"]
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
    local hastar, playertar = hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local equiped = br.player.equiped
    local falling, swimming, flying = getFallTime(), IsSwimming(), IsFlying()
    local friendly = friendly or GetUnitIsFriend("target", "player")
    local gcd = br.player.gcdMax
    local gcdMax = br.player.gcdMax
    local hasPet = IsPetActive()
    local healPot = getHealthPot()
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
    local power, powmax, powgen, powerDeficit = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
    local pullTimer = PullTimerRemain()
    local race = br.player.race
    local shards											= shards or UnitPower("player", Enum.PowerType.SoulShards)
    local summonPet = getOptionValue("Summon Pet")
    local solo = br.player.instance == "none"
    shards = WarlockPowerBar_UnitPower("player")
    local spell = br.player.spell
    local spell_haste 										= 1 / (1 + (GetHaste()/100))
    local talent = br.player.talent
    local thp = getHP("target")
    local trait = br.player.traits
    local travelTime = getDistance("target") / 16
    local ttd                                           	= getTTD
    local units = br.player.units
    local use = br.player.use

    demonTable                  = demonTable or {}
    demonTable.demonicBag       = demonTable.demonicBag or {}
    demonTable.imps             = demonTable.imps or {}
    demonTable.impsEnergy       = demonTable.impsEnergy or {}
    demonicBag                  = demonTable.demonicBag
    Imps                        = demonTable.imps
    ImpEnergy                   = demonTable.impsEnergy

    local baselineDemons = {
        --[demon] = duration (0 to blacklist)
        [688] = 0,     --Imp
        [697] = 0,     --Voidwalker
        [691] = 0,     --Felhunter
        [712] = 0,     --Succubus
        [30146] = 0,   --Felguard
        [112866] = 0,  --Fel Imp
        [112867] = 0,  --Voidlord
        [112869] = 0,  --Observer
        [112868] = 0,  --Shivarra
        [112870] = 0,  --Wrathguard
        [240263] = 0,  --Fel Succubus
        [240266] = 0,  --Shadow Succubus
        [104317] = 0,  --Wild Imps, counted by other means
        [111898] = 15, --Grimoire: Felguard
        [193331] = 12, --Dreadstalker 1
        [193332] = 12, --Dreadstalker 2
        [265187] = 15, --Demonic Tyrant
        [264119] = 15  --Vilefiend
    }

    units.get(40)
    enemies.get(8, "target")
    enemies.get(10, "target")
    enemies.get(40)

    implosionTargets = #enemies.yards8t






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

    --- See if the current unit is really a boss
    -- @return Wether the boss is a boss1-2-3-4-5
    local function isTargetUnitEqualBossFrameUnit_local (thisUnit)
        if isDummy() then return true end
        return UnitIsUnit(thisUnit, "Boss1") or UnitIsUnit(thisUnit, "Boss2") or UnitIsUnit(thisUnit, "Boss3") or UnitIsUnit(thisUnit, "Boss4") or UnitIsUnit(thisUnit, "Boss5")
    end

    --- Get whether the unit is a boss.
    local function isBoss_local (thisUnit)
        if thisUnit == nil then thisUnit = "target" end
        if isValidUnit(thisUnit) then
            -- Check if the target is boss1 - boss5
            if isTargetUnitEqualBossFrameUnit_local(thisUnit) then return true end
            -- check classic isBoss()
            if isBoss(thisUnit) then return true end
        end
        return false
    end

    function CDOptionEnabled (OptionName)
        local OptionValue = getOptionValue(OptionName)
        -- Always				Will use the ability even if CDs are disabled.
        -- Always Boss			Will use the ability even if CDs are disabled as long as the current target is a Boss.
        -- OnCooldown			Will only use the ability if the Cooldown Toggle is Enabled.
        -- OnCooldown Boss		Will only use the ability if the Cooldown Toggle is Enabled and Target is a Boss.
        if isChecked(OptionName) then
            if OptionValue == 1 then
                return true
            end
            if OptionValue == 2 then
                return isBoss_local()
            end
            if OptionValue == 3 then
                return mode.cooldown == 1
            end
            if OptionValue == 4 then
                return mode.cooldown == 1 and isBoss_local()
            end
        end
    end

    -- --ttd
    -- local function ttd(unit)
    --     local ttdSec = getTTD(unit)
    --     if getOptionCheck("Enhanced Time to Die") then
    --         return ttdSec
    --     end
    --     if ttdSec == -1 then
    --         return 999
    --     end
    --     return ttdSec
    -- end

    -- Blacklist enemies
    local function isTotem (unit)
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

    -- local function noDotCheck (unit)
    --     if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then
    --         return true
    --     end
    --     if isTotem(unit) then
    --         return true
    --     end
    --     local unitCreator = UnitCreator(unit)
    --     if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then
    --         return true
    --     end
    --     if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then
    --         return true
    --     end
    --     return false
    -- end

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

    -- local function dispelUnit (unit)
    --     local i = 1
    --     local remain
    --     local validDispel = false
    --     local dispelDuration = 0
    --     if UnitInPhase(unit) then
    --         if GetUnitIsFriend("player", unit) then
    --             while UnitDebuff(unit, i) do
    --                 local _, _, _, dispelType, debuffDuration, expire, _, _, _, dispelId = UnitDebuff(unit, i)
    --                 if (dispelType and dispelType == "Magic") and dDispelList[dispelId] ~= nil and (dDispelList[dispelId] == 0 or (dDispelList[dispelId] > 0 and #getAllies(unit, dDispelList[dispelId]) == 1)) then
    --                     dispelDuration = debuffDuration
    --                     remain = expire - GetTime()
    --                     validDispel = true
    --                     break
    --                 end
    --                 i = i + 1
    --             end
    --         else
    --             while UnitBuff(unit, i) do
    --                 local _, _, _, dispelType, buffDuration, expire, _, _, _, dispelId = UnitBuff(unit, i)
    --                 if (dispelType and dispelType == "Magic") and oDispelList[dispelId] ~= nil and (oDispelList[dispelId] == 0 or (oDispelList[dispelId] > 0 and #getAllies(unit, oDispelList[dispelId]) == 0)) then
    --                     dispelDuration = buffDuration
    --                     remain = expire - GetTime()
    --                     validDispel = true
    --                     break
    --                 end
    --                 i = i + 1
    --             end
    --         end
    --     end
    --     local dispelDelay = 1.5
    --     if isChecked("Dispel delay") then
    --         dispelDelay = getValue("Dispel delay")
    --     end
    --     if validDispel and (dispelDuration - remain) > (dispelDelay - 0.3 + math.random() * 0.6) then
    --         return true
    --     end
    --     return false
    -- end

    --local enemies table with extra data
    -- local facingUnits = 0
    -- local enemyTable40 = {}
    -- if #enemies.yards40 > 0 then
    --     local highestHP
    --     local lowestHP
    --     local distance20Max
    --     local distance20Min
    --     for i = 1, #enemies.yards40 do
    --         local thisUnit = enemies.yards40[i]
    --         if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) then
    --             local enemyUnit = {}
    --             enemyUnit.unit = thisUnit
    --             enemyUnit.ttd = ttd(thisUnit)
    --             enemyUnit.distance = getDistance(thisUnit)
    --             enemyUnit.distance20 = math.abs(getDistance(thisUnit) - 20)
    --             enemyUnit.hpabs = UnitHealth(thisUnit)
    --             enemyUnit.facing = getFacing("player", thisUnit)
    --             if enemyUnit.facing then
    --                 facingUnits = facingUnits + 1
    --             end
    --             tinsert(enemyTable40, enemyUnit)
    --             if highestHP == nil or highestHP < enemyUnit.hpabs then
    --                 highestHP = enemyUnit.hpabs
    --             end
    --             if lowestHP == nil or lowestHP > enemyUnit.hpabs then
    --                 lowestHP = enemyUnit.hpabs
    --             end
    --             if distance20Max == nil or distance20Max < enemyUnit.distance20 then
    --                 distance20Max = enemyUnit.distance20
    --             end
    --             if distance20Min == nil or distance20Min > enemyUnit.distance20 then
    --                 distance20Min = enemyUnit.distance20
    --             end
    --         end
    --     end
    --     if #enemyTable40 > 1 then
    --         for i = 1, #enemyTable40 do
    --             local hpNorm = (5 - 1) / (highestHP - lowestHP) * (enemyTable40[i].hpabs - highestHP) + 5 -- normalization of HP value, high is good
    --             if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0 / 0) then
    --                 hpNorm = 0
    --             end -- NaN check
    --             local distance20Norm = (3 - 1) / (distance20Max - distance20Min) * (enemyTable40[i].distance20 - distance20Min) + 1 -- normalization of distance 20, low is good
    --             if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0 / 0) then
    --                 distance20Norm = 0
    --             end -- NaN check
    --             local enemyScore = hpNorm + distance20Norm
    --             if enemyTable40[i].facing then
    --                 enemyScore = enemyScore + 10
    --             end
    --             if enemyTable40[i].ttd > 1.5 then
    --                 enemyScore = enemyScore + 10
    --             end
    --             enemyTable40[i].enemyScore = enemyScore
    --         end
    --         table.sort(
    --             enemyTable40,
    --             function(x, y)
    --                 return x.enemyScore > y.enemyScore
    --             end
    --         )
    --     end
    --     if isChecked("Auto Target") and inCombat and #enemyTable40 > 0 and ((GetUnitExists("target") and UnitIsDeadOrGhost("target") and not GetUnitIsUnit(enemyTable40[1].unit, "target")) or not GetUnitExists("target")) then
    --         TargetUnit(enemyTable40[1].unit)
    --     end
    -- end

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
    -- wildImps = 0
    -- -- local TyrantActive = false
    -- -- local dreadstalkersRemain = 0
    -- -- local foundDreakstalker = false
    -- local felguardActive = activePetId == 17252 or false
    -- -- local foundGrimoire = false
    -- -- local grimoireRemain = 0

    -- if pet ~= nil then
    --     for k, v in pairs(pet) do
    --         local thisUnit = pet[k] or 0
    --         if thisUnit.id == 135002 and not TyrantActive and not UnitIsDeadOrGhost(thisUnit.unit) then
    --             TyrantActive = true
    --         elseif thisUnit.id == 55659 and not UnitIsDeadOrGhost(thisUnit.unit) then
    --             wildImps = wildImps + 1
    --         elseif thisUnit.id == 98035 and not UnitIsDeadOrGhost(thisUnit.unit) then
    --             if not dreadstalkersActive then
    --                 dreadstalkersTime = GetTime()
    --             end
    --             foundDreakstalker = true
    --             dreadstalkersActive = true
    --         elseif thisUnit.id == 17252 and not UnitIsDeadOrGhost(thisUnit.unit) then
    --             local grimoire = getBuffRemain(thisUnit.unit, 216187)
    --             if grimoire == 0 then
    --                 felguardActive = true
    --             end
    --             if grimoire ~= 0 then
    --                 if not grimoireActive then
    --                     grimoireTime = GetTime()
    --                 end
    --                 grimoireActive = true
    --                 foundGrimoire = true
    --             end
    --         end
    --     end
    -- end
    -- if not foundDreakstalker then
    --     dreadstalkersActive = false
    -- end
    -- if dreadstalkersActive then
    --     dreadstalkersRemain = dreadstalkersTime - GetTime() + 12
    -- end
    -- if not foundGrimoire then
    --     grimoireActive = false
    -- end
    -- if grimoireActive then
    --     grimoireRemain = grimoireTime - GetTime() + 12
    -- end



    -- variables for demon manager
    felguardActive = activePetId == 17252 or false
    ImpMaxCasts = 5
    ImpMaxTime = 20
    ImpsIncoming = ImpsIncoming and ImpsIncoming >= 0 and ImpsIncoming or 0
    TyrantDuration = 15
    TyrantStart = TyrantStart or 0
    TyrantActive = TyrantActive or false
    TyrantBuffPerEnergy = 10
    TyrantBuffPercent = TyrantBuffPercent or 0
    denonCount = demonCount or 0
    CountOnlyImps = true
    
    ImpsCasting = ImpsCasting or 0
    -- if 105174 == select(9, UnitCastingInfo("player")) then
    --     ImpsCasting = shards >= 3 and 3 or shards
    -- end
    
    
    --ImpsCasting = (105174 == select(9, UnitCastingInfo("player")) and (shards >= 3 and 3 or shards)
    if GetSpecialization() == 2 then
        local cl = br.read
        function cl:Warlock(...)
            local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()

            if source == br.guid and param == "SPELL_CAST_START" and spell == 105174 then
                shards = WarlockPowerBar_UnitPower("player")
                ImpsCasting = shards >= 3 and 3 or shards
            end
            if source == br.guid and param == "SPELL_CAST_FAILED" and spell == 105174 then
                ImpsCasting = 0
            end

            if source == br.guid and param == "SPELL_CAST_SUCCESS" then
                -- Hand of Guldan
                if spell == 105174 then
                    ImpsIncoming = ImpsIncoming + ImpsCasting
                    if not br.lastCast.hog then br.lastCast.hog = {} end
                    -- if br.lastCast then
                    --     tinsert(br.lastCast.hog, 1, GetTime())
                    --     if #br.lastCast.hog == 5 then
                    --         br.lastCast.hog[5] = nil
                    --     end
                    -- end
                    if br.lastCast.hog then
                        if ImpsCasting == 1 then
                            tinsert(br.lastCast.hog, 1, GetTime()+1.2*spell_haste)
                        elseif ImpsCasting == 2 then
                            tinsert(br.lastCast.hog, 1, GetTime()+1.2*spell_haste)
                            tinsert(br.lastCast.hog, 1, GetTime()+1.6*spell_haste)
                        elseif ImpsCasting == 3 then
                            tinsert(br.lastCast.hog, 1, GetTime()+1.2*spell_haste)
                            tinsert(br.lastCast.hog, 1, GetTime()+1.6*spell_haste)
                            tinsert(br.lastCast.hog, 1, GetTime()+2.0*spell_haste)
                        end
                    end
                end
                -- Line CD
                if not br.lastCast.line_cd then br.lastCast.line_cd = {} end
                br.lastCast.line_cd[spell] = GetTime()
            end

            -- DEMON MANAGER
            -- Imps are summoned
            if param == "SPELL_SUMMON" and source == br.guid and (spell == 104317 or spell == 279910) then
                if br.lastCast.hog[1] then tremove(br.lastCast.hog, #br.lastCast.hog) end
                local tyrantExtra = TyrantActive and TyrantDuration - (GetTime() - TyrantStart) or 0
                ImpEnergy[destination] = {ImpMaxCasts, GetTime() + ImpMaxTime + tyrantExtra - 0.1}
                C_Timer.After(ImpMaxTime + tyrantExtra, function()
                    for k in pairs(ImpEnergy) do
                        if GetTime() > ImpEnergy[k][2] then
                            ImpEnergy[k] = nil
                        end
                    end
                end)
                -- time to imp
                ImpsIncoming = ImpsIncoming - 1
            end
            -- Other Demons are summoned
            if param == "SPELL_SUMMON" and source == br.guid and not (spell == 104317 or spell == 279910) then
                if baselineDemons[spell] and baselineDemons[spell] > 0 then
                    demonicBag[destination] = GetTime() + baselineDemons[spell] - 0.1
                    C_Timer.After(baselineDemons[spell], function()
                        for k, v in pairs(demonicBag) do
                            if GetTime() > v then
                                demonicBag[k] = nil
                            end
                        end
                    end)
                    
                elseif not baselineDemons[spell] then
                    demonicBag[destination] = GetTime() + randomDemonsDuration - 0.1
                    C_Timer.After(randomDemonsDuration, function()
                        for k, v in pairs(demonicBag) do
                            if GetTime() > v then
                                demonicBag[k] = nil
                            end
                        end
                    end)
                end
            end
            -- Dreadstalkers active
            if param == "SPELL_SUMMON" and source == br.guid and (spell == 193331 or spell == 193332) then
                dreadstalkersActive = true
                C_Timer.After(12, function() dreadstalkersActive = false end)
            end
            -- Imps succesfully consume energy
            if param == "SPELL_CAST_SUCCESS" and ImpEnergy[source] and not TyrantActive then
                if ImpEnergy[source][1] == 1 then
                    ImpEnergy[source] = nil
                else
                    ImpEnergy[source][1] = ImpEnergy[source][1] - 1
                end
            end
            --Summon Demonic Tyrant
            if param == "SPELL_CAST_SUCCESS" and source == br.guid and spell == 265187 then
                --print("Tyrant Power: " .. TyrantBuffPercent)
                local remains
                
                TyrantActive = true
                TyrantStart = GetTime()
                
                if IsPlayerSpell(267215) then
                    table.wipe(ImpEnergy)
                end
                C_Timer.After(TyrantDuration, function()
                    TyrantActive = false 
                    for k in pairs(ImpEnergy) do
                        if GetTime() > ImpEnergy[k][2] then
                            ImpEnergy[k] = nil
                        end
                    end 
                    for k, v in pairs(demonicBag) do
                        if GetTime() > v then
                            demonicBag[k] = nil
                        end
                    end
                end)
                for k in pairs(ImpEnergy) do
                    remains = ImpEnergy[k][2] - GetTime()
                    ImpEnergy[k][2] = ImpEnergy[k][2] + TyrantDuration - 0.1
                    C_Timer.After(TyrantDuration + remains, function()
                        for k in pairs(ImpEnergy) do
                            if GetTime() > ImpEnergy[k][2] then
                                ImpEnergy[k] = nil
                            end
                        end      
                    end)
                end
                for k in pairs(demonicBag) do
                    remains = demonicBag[k] - GetTime()
                    demonicBag[k] = demonicBag[k] - 0.1
                    C_Timer.After(TyrantDuration + remains, function()
                        for k, v in pairs(demonicBag) do
                            if GetTime() > v then
                                demonicBag[k] = nil
                            end
                        end
                    end)
                end
            end
            -- Implosion
            if param == "SPELL_CAST_SUCCESS" and source == br.guid and spell == 196277 then
                table.wipe(ImpEnergy)
                --e.UpdateBuff()
            end
            -- Power Siphon
            if param == "SPELL_CAST_SUCCESS" and source == br.guid and spell == 264130 then
                local oldest, oldestTime = "", 2*GetTime()
                
                for i = 1, 2 do
                    for name, imp in pairs(ImpEnergy) do
                        oldestTime = math.min(imp[2], oldestTime)
                        if imp[2] == oldestTime then
                            oldest = name
                        end
                    end
                    
                    oldestTime = oldestTime*2
                    ImpEnergy[oldest] = nil
                end
            end
            -- Death
            if param == "UNIT_DIED" or param == "SPELL_INSTAKILL" or param == "UNIT_DESTROYED" then
                if ImpEnergy[destination] then
                    ImpEnergy[destination] = nil
                    
                elseif demonicBag[destination] then      
                    demonicBag[destination] = nil
                    
                elseif destination == br.guid then
                    table.wipe(ImpEnergy)
                    table.wipe(demonicBag)
                end
            end
        end
    end

    --local function UpdateTyrantBuffPercent ()
        TyrantBuffPercent = 0
        if ImpEnergy then
            for k, v in pairs(ImpEnergy) do
                TyrantBuffPercent = TyrantBuffPercent + v[1]*TyrantBuffPerEnergy
            end
        end
    --end
    --local function UpdateDemonCount ()
        demonCount = 0
        for k, v in pairs(ImpEnergy) do
            if k and v[1] > 0 then
                demonCount = demonCount + 1
            end
        end
        wildImps = demonCount
        if not CountOnlyImps then
            for k in pairs(demonicBag) do
                demonCount = demonCount + 1
            end
        end
    --end

    -- clean up imps incoming hog table
    -- for i=1, #br.lastCast.hog do
    --     if br.lastCast.hog[i] < GetTime() then
    --         br.lastCast.hog[i] = nil
    --     end
    -- end
    




    local function Imps_spawned_during (seconds)
        local imps = 0
        if br.lastCast.hog then
            for i=1, #br.lastCast.hog do
                if GetTime() + seconds >= br.lastCast.hog[i] then
                --if br.lastCast.hog[i] <= GetTime() + seconds then
                    imps = imps + 1
                end
            end
            return imps            
        end
        return 0
    end

    local function time_to_imps ()
        return br.lastCast.hog[1] or 999
    end

    local function Line_cd (spellid, seconds)
        if br.lastCast.line_cd then
            if br.lastCast.line_cd[spellid] then
                if br.lastCast.line_cd[spellid] + seconds >= GetTime() then
                    return false
                end
            end
        end
        return true
    end

    local function castBilescourgeBombers ()
        if mode.bsb == 1 then
            if getOptionValue("Bilescourge Target") == 1 then
                if (#enemies.yards8t >= getOptionValue("Bilescourge Units") or (isChecked("Ignore Bilescourge Bombers units when using CDs") and useCDs())) then
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
                    if cast.bilescourgeBombers("best", false, getOptionValue("Bilescourge Units"), 8) then
                        return true
                    end
                end
            end
        end
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
                    return true
                end
            elseif getOptionValue("Shadowfury Target") == 2 then
                if cast.shadowfury("target", "ground") then
                    return true
                end
            elseif getOptionValue("Shadowfury Target") == 3 and isKnown(spell.shadowfury) and getSpellCD(spell.shadowfury) == 0 then
                CastSpellByName(GetSpellInfo(spell.shadowfury), "cursor")
                return true
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
                return true
            end
        end
    end -- End Action List - Extras
    -- Action List - Defensive
    local function actionList_Defensive()
        if useDefensive() then
            -- Healthstone
            if isChecked("Healthstone") and php <= getOptionValue("Healthstone")
                and inCombat and (hasHealthPot() or hasItem(5512))
            then
                if canUseItem(5512) then useItem(5512) end
            end
            -- Health Pot
            if isChecked("Healing Potion") and php <= getOptionValue("Healing Potion")
                and inCombat and (hasHealthPot() or hasItem(5512))
            then
                if canUseItem(healPot) then useItem(healPot) end
            end
            -- --dispel logic for m+
            -- if inInstance and isChecked("Auto Dispel/Purge") then
            --     if spellUsable(spell.devourMagic) then
            --         for i = 1, #enemyTable40 do
            --             local thisUnit = enemyTable40[i].unit
            --             if dispelUnit(thisUnit) then
            --                 if cast.devourMagic(thisUnit) then
            --                     return true
            --                 end
            --             end
            --         end
            --     end
            --     if spellUsable(spell.singeMagic) or spellUsable(spell.singeMagicGrimoire) then
            --         for i = 1, #br.friend do
            --             local thisUnit = br.friend[i].unit
            --             if dispelUnit(thisUnit) then
            --                 if cast.singeMagic(thisUnit) then
            --                     return true
            --                 end
            --                 if cast.singeMagicGrimoire(thisUnit) then
            --                     return true
            --                 end
            --             end
            --         end
            --     end
            -- end
            -- Gift of the Naaru
            if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                if castSpell("player", racial, false, false, false) then
                    return true
                end
            end
            -- Dark Pact
            if isChecked("Dark Pact") and talent.darkPact and php <= getOptionValue("Dark Pact") then
                if cast.darkPact() then
                    return true
                end
            end
            -- Drain Life
            if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and isValidTarget("target") and not moving then
                if cast.drainLife() then
                    return true
                end
            end
            -- Health Funnel
            if isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") and not moving then
                if cast.healthFunnel("pet") then
                    return true
                end
            end
            -- Unending Resolve
            if isChecked("Unending Resolve") and php <= getOptionValue("Unending Resolve") and inCombat then
                if cast.unendingResolve() then
                    return true
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
                            return true
                        end
                    end
                end
            elseif activePetId ~= nil and (activePetId == 417 or activePetId == 78158) then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                        if activePetId == 417 then
                            if cast.spellLock(thisUnit) then
                                return true
                            end
                        end
                    end
                end
            end
        end -- End useInterrupts check
    end -- End Action List - Interrupts
    -- Action List - Cooldowns
    -- local function actionList_Cooldowns()
    --     if getDistance("target") < 40 then
    --         -- actions=potion,if=pet.demonic_tyrant.active|target.time_to_die<30
    --         -- if isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (TyrantActive or ttd("target") < 30) then
    --         --     use.battlePotionOfIntellect()
    --         --     return true
    --         -- end
    --         -- actions+=/use_items,if=pet.demonic_tyrant.active|target.time_to_die<=15
    --         if TyrantActive then
	-- 			if canUseItem(13) and CDOptionEnabled("Trinket 1") and not hasEquiped(165572, 13) then
	-- 				if useItem(13) then return true end
	-- 			end
	-- 			if canUseItem(14) and CDOptionEnabled("Trinket 2") and not hasEquiped(165572, 14) then
	-- 				if useItem(14) then return true end
	-- 			end
	-- 		end
    --         -- actions+=/berserking,if=pet.demonic_tyrant.active|target.time_to_die<=15
    --         -- actions+=/blood_fury,if=pet.demonic_tyrant.active|target.time_to_die<=15
    --         -- actions+=/fireblood,if=pet.demonic_tyrant.active|target.time_to_die<=15
    --         if isChecked("Racial") and not moving and TyrantActive then
    --             if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
    --                 if race == "LightforgedDraenei" then
    --                     if cast.racial("target", "ground") then
    --                         return true
    --                     end
    --                 else
    --                     if cast.racial("player") then
    --                         return true
    --                     end
    --                 end
    --             end
    --         end
    --     end -- End useCDs check
    -- end -- End Action List - Cooldowns




        -- # Executed before combat begins. Accepts non-harmful actions only.
        -- actions.precombat=flask
        -- actions.precombat+=/food
        -- actions.precombat+=/augmentation
        -- actions.precombat+=/summon_pet
        -- actions.precombat+=/inner_demons,if=talent.inner_demons.enabled
        -- actions.precombat+=/snapshot_stats
        -- actions.precombat+=/potion
        -- actions.precombat+=/demonbolt
    
    
    
    local function actionList_build_a_shard ()
        if WarlockPowerBar_UnitPower("player") < 5 then
            -- actions.build_a_shard=soul_strike,if=!talent.demonic_consumption.enabled|time>15|prev_gcd.1.hand_of_guldan&!buff.bloodlust.remains
            if felguardActive and not talent.demonicConsumption or combatTime > 15 or cast.last.handOfGuldan(1) and not hasBloodLust() then
                if cast.able.soulStrike() then
                    if cast.soulStrike() then return true end
                end
            end
            -- actions.build_a_shard+=/shadow_bolt
            if cast.able.shadowBolt() then
                if cast.shadowBolt() then return true end
            end
        end
    end
    
    local function actionList_dcon_opener ()
        -- actions.dcon_opener=hand_of_guldan,line_cd=30,if=azerite.explosive_potential.enabled
        if Line_cd(spell.handOfGuldan, 30) and trait.explosivePotential.active then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan() then return true end
            end
        end
        -- actions.dcon_opener+=/implosion,if=azerite.explosive_potential.enabled&buff.wild_imps.stack>2&buff.explosive_potential.down
        if trait.explosivePotential.active and wildImps > 2 and not buff.explosivePotential.exists() then
            if cast.able.implosion() then
                if cast.implosion() then return true end
            end
        end
        -- actions.dcon_opener+=/doom,line_cd=30
        if Line_cd(spell.doom, 30) then
            if cast.able.doom() then
                if cast.doom() then return true end
            end
        end
        -- actions.dcon_opener+=/hand_of_guldan,if=prev_gcd.1.hand_of_guldan&soul_shard>0&prev_gcd.2.soul_strike
        if cast.last.handOfGuldan(1) and shards > 0 and cast.last.soulStrike(2) then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan() then return true end
            end
        end
        -- actions.dcon_opener+=/demonic_strength,if=prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan&(buff.wild_imps.stack>1&action.hand_of_guldan.in_flight)
        if felguardActive and talent.demonicStrength then
            if cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) and (wildImps > 1 and cast.last.handOfGuldan(1)) then
                if cast.able.demonicStrength() then
                    if cast.demonicStrength() then return true end
                end
            end
        end
        -- actions.dcon_opener+=/bilescourge_bombers
        if talent.bilescourgeBombers then
            if castBilescourgeBombers() then return true end
        end
        -- actions.dcon_opener+=/soul_strike,line_cd=30,if=!buff.bloodlust.remains|time>5&prev_gcd.1.hand_of_guldan
        if Line_cd(spell.soulStrike, 30) then
            if felguardActive and not hasBloodLust or combatTime > 5 and cast.last.handOfGuldan(1) then
                if cast.able.soulStrike() then
                    if cast.soulStrike() then return true end
                end
            end
        end
        -- actions.dcon_opener+=/summon_vilefiend,if=soul_shard=5
        if talent.summonVilefiend and shards >= 5 then
            if cast.able.summonVilefiend() then
                if cast.summonVilefiend() then return true end
            end
        end
        -- actions.dcon_opener+=/grimoire_felguard,if=soul_shard=5
        if talent.grimoireFelguard and shards >= 5 then
            if cast.able.grimoireFelguard() then
                if cast.grimoireFelguard() then return true end
            end
        end
        -- actions.dcon_opener+=/call_dreadstalkers,if=soul_shard=5
        if shards >= 5 then
            if cast.able.callDreadstalkers() then
                if cast.callDreadstalkers() then return true end
            end
        end
        -- actions.dcon_opener+=/hand_of_guldan,if=soul_shard=5
        if shards >= 5 then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan() then return true end
            end
        end
        -- actions.dcon_opener+=/hand_of_guldan,if=soul_shard>=3&prev_gcd.2.hand_of_guldan&time>5&(prev_gcd.1.soul_strike|!talent.soul_strike.enabled&prev_gcd.1.shadow_bolt)
        if shards >= 3 and cast.last.handOfGuldan(2) and combatTime > 5 and (cast.last.soulStrike(1) or not talent.soulStrike and cast.last.shadowBolt(1)) then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan() then return true end
            end
        end
        -- # 2000%spell_haste is shorthand for the cast time of Demonic Tyrant. The intent is to only begin casting if a certain number of imps will be out by the end of the cast.
        -- actions.dcon_opener+=/summon_demonic_tyrant,if=prev_gcd.1.demonic_strength|prev_gcd.1.hand_of_guldan&prev_gcd.2.hand_of_guldan|!talent.demonic_strength.enabled&buff.wild_imps.stack+imps_spawned_during.2000%spell_haste>=6
        if CDOptionEnabled("Demonic Tyrant") then
            if cast.last.demonicStrength(1) or cast.last.handOfGuldan(1) and cast.last.handOfGuldan(2) or not talent.demonicStrength and wildImps + Imps_spawned_during(2 * spell_haste) >= 6 then
                if cast.able.summonDemonicTyrant() then
                    if cast.summonDemonicTyrant() then return true end
                end
            end
        end
        -- actions.dcon_opener+=/demonbolt,if=soul_shard<=3&buff.demonic_core.remains
        if shards <= 3 and buff.demonicCore.exists() then
            if cast.able.demonbolt() then
                if cast.demonbolt() then return true end
            end
        end
        -- actions.dcon_opener+=/call_action_list,name=build_a_shard
        if shards < 5 then
            if actionList_build_a_shard() then
                return true
            end
        end
    end
    
    local function actionList_implosion ()
        -- actions.implosion=implosion,if=(buff.wild_imps.stack>=6&(soul_shard<3|prev_gcd.1.call_dreadstalkers|buff.wild_imps.stack>=9|prev_gcd.1.bilescourge_bombers|(!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan))&!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan&buff.demonic_power.down)|(time_to_die<3&buff.wild_imps.stack>0)|(prev_gcd.2.call_dreadstalkers&buff.wild_imps.stack>2&!talent.demonic_calling.enabled)
        if (wildImps >= 6 and (shards < 3 or cast.last.callDreadstalkers(1) or wildImps >= 9 or cast.last.bilescourgeBombers(1) or (not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2))) and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) and not buff.demonicPower.exists()) 
            or (ttd("target") < 3 and wildImps > 0) or (cast.last.callDreadstalkers(2) and wildImps > 2 and not talent.demonicCalling) then
            if cast.able.implosion() then
                if cast.implosion() then return true end
            end
        end
        -- actions.implosion+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        if talent.grimoireFelguard and cd.summonDemonicTyrant.remain() < 13 then
            if cast.able.grimoireFelguard() then
                if cast.grimoireFelguard() then return true end
            end
        end
        -- actions.implosion+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if (cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14 then
            if cast.able.callDreadstalkers() then
                if cast.callDreadstalkers() then return true end
            end
        end
        -- actions.implosion+=/summon_demonic_tyrant
        if CDOptionEnabled("Demonic Tyrant") then
            if cast.able.summonDemonicTyrant() then
                if cast.summonDemonicTyrant() then return true end
            end
        end
        -- actions.implosion+=/hand_of_guldan,if=soul_shard>=5
        if shards >= 5 and cast.able.handOfGuldan() then
            if cast.handOfGuldan() then return true end
        end
        -- actions.implosion+=/hand_of_guldan,if=soul_shard>=3&(((prev_gcd.2.hand_of_guldan|buff.wild_imps.stack>=3)&buff.wild_imps.stack<9)|cooldown.summon_demonic_tyrant.remains<=gcd*2|buff.demonic_power.remains>gcd*2)
        if shards >= 3 and (((cast.last.handOfGuldan(2) or wildImps >= 3) and wildImps < 9) or cd.summonDemonicTyrant.remain() <= gcd * 2 or buff.demonicPower.remain() > gcd * 2) then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan() then return true end
            end
        end
        -- actions.implosion+=/demonbolt,if=prev_gcd.1.hand_of_guldan&soul_shard>=1&(buff.wild_imps.stack<=3|prev_gcd.3.hand_of_guldan)&soul_shard<4&buff.demonic_core.up
        if cast.last.handOfGuldan(1) and shards >= 1 and (wildImps <= 3 or cast.last.handOfGuldan(3)) and shards < 4 and buff.demonicCore.exists() then
            if cast.able.demonbolt() then
                if cast.demonbolt() then return true end
            end
        end
        -- actions.implosion+=/summon_vilefiend,if=(cooldown.summon_demonic_tyrant.remains>40&spell_targets.implosion<=2)|cooldown.summon_demonic_tyrant.remains<12
        -- actions.implosion+=/bilescourge_bombers,if=cooldown.summon_demonic_tyrant.remains>9
        if talent.bilescourgeBombers and cd.summonDemonicTyrant.remain() > 9 then
            if castBilescourgeBombers() then return true end
        end
        -- actions.implosion+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
        if felguardActive and shards < 5 and buff.demonicCalling.stack() <= 2 then
            if cast.able.soulStrike() then
                if cast.soulStrike() then return true end
            end
        end
        -- actions.implosion+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&(buff.demonic_core.stack>=3|buff.demonic_core.remains<=gcd*5.7)
        if shards <= 3 and buff.demonicCore.exists() and (buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() <= gcd * 5.7) then
            if cast.able.demonbolt() then
                if cast.demonbolt() then return true end
            end
        end
        -- actions.implosion+=/doom,cycle_targets=1,max_cycle_targets=7,if=refreshable
        -- actions.implosion+=/call_action_list,name=build_a_shard
        if shards < 5 then
            if actionList_build_a_shard() then 
                return true
            end
        end
    end

    local function actionList_nether_portal ()
        -- actions.nether_portal=call_action_list,name=nether_portal_building,if=cooldown.nether_portal.remains<20
        -- actions.nether_portal+=/call_action_list,name=nether_portal_active,if=cooldown.nether_portal.remains>165
    end

    local function actionList_nether_portal_active ()
        -- actions.nether_portal_active=bilescourge_bombers
        -- actions.nether_portal_active+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        -- actions.nether_portal_active+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>40|cooldown.summon_demonic_tyrant.remains<12
        -- actions.nether_portal_active+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        -- actions.nether_portal_active+=/call_action_list,name=build_a_shard,if=soul_shard=1&(cooldown.call_dreadstalkers.remains<action.shadow_bolt.cast_time|(talent.bilescourge_bombers.enabled&cooldown.bilescourge_bombers.remains<action.shadow_bolt.cast_time))
        -- actions.nether_portal_active+=/hand_of_guldan,if=((cooldown.call_dreadstalkers.remains>action.demonbolt.cast_time)&(cooldown.call_dreadstalkers.remains>action.shadow_bolt.cast_time))&cooldown.nether_portal.remains>(165+action.hand_of_guldan.cast_time)
        -- actions.nether_portal_active+=/summon_demonic_tyrant,if=buff.nether_portal.remains<5&soul_shard=0
        -- actions.nether_portal_active+=/summon_demonic_tyrant,if=buff.nether_portal.remains<action.summon_demonic_tyrant.cast_time+0.5
        -- actions.nether_portal_active+=/demonbolt,if=buff.demonic_core.up&soul_shard<=3
        -- actions.nether_portal_active+=/call_action_list,name=build_a_shard
    end
        
    local function actionList_nether_portal_building ()
        -- actions.nether_portal_building=nether_portal,if=soul_shard>=5&(!talent.power_siphon.enabled|buff.demonic_core.up)
        -- actions.nether_portal_building+=/call_dreadstalkers
        -- actions.nether_portal_building+=/hand_of_guldan,if=cooldown.call_dreadstalkers.remains>18&soul_shard>=3
        -- actions.nether_portal_building+=/power_siphon,if=buff.wild_imps.stack>=2&buff.demonic_core.stack<=2&buff.demonic_power.down&soul_shard>=3
        -- actions.nether_portal_building+=/hand_of_guldan,if=soul_shard>=5
        -- actions.nether_portal_building+=/call_action_list,name=build_a_shard
    end

    local function actionList_CancelCast ()
        local spellID = select(9, UnitCastingInfo("player"))
        if spellID == nil then
            spellID = 0
        end
        if shards >= 5 and spellID == spell.shadowBolt then
            SpellStopCasting()
            return true
        elseif spellID == spell.demonbolt and combatTime > 4 then
            SpellStopCasting()
            return true
        end
    end

    local function actionList_PreCombat ()
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
        -- if actionList_Opener() then
        --     return
        -- end
    end -- End Action List - PreCombat

    local function actionList_rotation ()
        -- # Executed every time the actor is available.
        -- actions=potion,if=pet.demonic_tyrant.active&(!talent.nether_portal.enabled|cooldown.nether_portal.remains>160)|target.time_to_die<30
        -- actions+=/use_items,if=pet.demonic_tyrant.active|target.time_to_die<=15
        if TyrantActive then
            if canUseItem(13) and CDOptionEnabled("Trinket 1") and not hasEquiped(165572, 13) then
                if useItem(13) then return true end
            end
            if canUseItem(14) and CDOptionEnabled("Trinket 2") and not hasEquiped(165572, 14) then
                if useItem(14) then return true end
            end
        end
        -- actions+=/berserking,if=pet.demonic_tyrant.active|target.time_to_die<=15
        -- actions+=/blood_fury,if=pet.demonic_tyrant.active|target.time_to_die<=15
        -- actions+=/fireblood,if=pet.demonic_tyrant.active|target.time_to_die<=15
        if TyrantActive and CDOptionEnabled("Racial") then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
                if race == "LightforgedDraenei" then
                    if cast.racial("target", "ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
        end
        -- actions+=/call_action_list,name=dcon_opener,if=talent.demonic_consumption.enabled&time<30&!cooldown.summon_demonic_tyrant.remains
        if talent.demonicConsumption and combatTime < 30 and cd.summonDemonicTyrant.remain() <= 0 then
            if actionList_dcon_opener() then return true end
        end
        -- actions+=/hand_of_guldan,if=azerite.explosive_potential.rank&time<5&soul_shard>2&buff.explosive_potential.down&buff.wild_imps.stack<3&!prev_gcd.1.hand_of_guldan&&!prev_gcd.2.hand_of_guldan
        if trait.explosivePotential.active and combatTime < 5 and shards > 2 and not buff.explosivePotential.exists() and wildImps < 3 and not cast.last.handOfGuldan(1) and not cast.last.handOfGuldan(2) then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan() then return true end
            end
        end
        -- actions+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&buff.demonic_core.stack=4
        if shards <= 3 and buff.demonicCore.exists() and buff.demonicCore.stack() >= getOptionValue("Demonbolt Dump") then
            if cast.able.demonbolt() then
                if cast.demonbolt() then return true end
            end
        end
        -- actions+=/implosion,if=azerite.explosive_potential.rank&buff.wild_imps.stack>2&buff.explosive_potential.remains<action.shadow_bolt.execute_time&(!talent.demonic_consumption.enabled|cooldown.summon_demonic_tyrant.remains>12)
        if trait.explosivePotential.active and wildImps > 2 and buff.explosivePotential.remain() < cast.time.shadowBolt() and (not talent.demonicConsumption or cd.summonDemonicTyrant.remain() > 12) then
            if cast.able.implosion() then
                if cast.implosion() then return true end
            end
        end
        -- actions+=/doom,if=!ticking&time_to_die>30&spell_targets.implosion<2
        -- actions+=/bilescourge_bombers,if=azerite.explosive_potential.rank>0&time<10&spell_targets.implosion<2&buff.dreadstalkers.remains&talent.nether_portal.enabled
        if talent.bilescourgeBombers and trait.explosivePotential.active and combatTime < 10 and implosionTargets < 2 and dreadstalkersActive and talent.netherPortal then
            if castBilescourgeBombers() then return true end
        end

        -- actions+=/demonic_strength,if=(buff.wild_imps.stack<6|buff.demonic_power.up)|spell_targets.implosion<2
        if felguardActive and talent.demonicStrength and ((wildImps < 6 or buff.demonicPower.exists()) or implosionTargets < 2) then
            if cast.able.demonicStrength() then
                if cast.demonicStrength() then return true end
            end
        end
        -- actions+=/call_action_list,name=nether_portal,if=talent.nether_portal.enabled&spell_targets.implosion<=2
        -- actions+=/call_action_list,name=implosion,if=spell_targets.implosion>1
        if implosionTargets > 1 then
            if actionList_implosion() then return true end
        end
        -- actions+=/grimoire_felguard,if=(target.time_to_die>120|target.time_to_die<cooldown.summon_demonic_tyrant.remains+15|cooldown.summon_demonic_tyrant.remains<13)
        -- actions+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>40|cooldown.summon_demonic_tyrant.remains<12
        -- actions+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        if (cd.summonDemonicTyrant.remain() < 9 and buff.demonicCalling.exists()) or (cd.summonDemonicTyrant.remain() < 11 and not buff.demonicCalling.exists()) or cd.summonDemonicTyrant.remain() > 14 then
            if cast.able.callDreadstalkers() then
                if cast.callDreadstalkers() then return true end
            end
        end
        -- actions+=/bilescourge_bombers
        if talent.bilescourgeBombers then
            if castBilescourgeBombers() then return true end
        end
        -- actions+=/hand_of_guldan,if=(azerite.baleful_invocation.enabled|talent.demonic_consumption.enabled)&prev_gcd.1.hand_of_guldan&cooldown.summon_demonic_tyrant.remains<2
        if (trait.balefulInvocation.active or talent.demonicConsumption) and cast.last.handOfGuldan(1) and cd.summonDemonicTyrant.remain() < 2 then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan() then return true end
            end
        end
        --2000/(1 / (1 + (GetHaste()/100)))
        -- TODO: Import Weakaura stuff to get the % for Tyrant and options.
        -- # 2000%spell_haste is shorthand for the cast time of Demonic Tyrant. The intent is to only begin casting if a certain number of imps will be out by the end of the cast.
        -- actions+=/summon_demonic_tyrant,if=soul_shard<3&(!talent.demonic_consumption.enabled|buff.wild_imps.stack+imps_spawned_during.2000%spell_haste>=6&time_to_imps.all.remains<cast_time)|target.time_to_die<20
        if CDOptionEnabled("Demonic Tyrant") then
            if shards < 3 and (not talent.demonicConsumption or (wildImps + Imps_spawned_during(2 * spell_haste) >= 6) and time_to_imps() < GetTime()+cast.time.summonDemonicTyrant() --[[ and time_to_imps.all.remains<cast_time ]]) or ttd("target") < 20 then
                if cast.able.summonDemonicTyrant() then
                    if cast.summonDemonicTyrant() then return true end
                end
            end
        end
        -- actions+=/power_siphon,if=buff.wild_imps.stack>=2&buff.demonic_core.stack<=2&buff.demonic_power.down&spell_targets.implosion<2
        if talent.powerSiphon then
            if wildImps >= 2 and buff.demonicCore.stack() <= 2 and not buff.demonicPower.exists() and implosionTargets < 2 then
                if cast.able.powerSiphon() then
                    if cast.powerSiphon() then return true end
                end
            end
        end
        -- actions+=/doom,if=talent.doom.enabled&refreshable&time_to_die>(dot.doom.remains+30)
        -- actions+=/hand_of_guldan,if=soul_shard>=5|(soul_shard>=3&cooldown.call_dreadstalkers.remains>4&(cooldown.summon_demonic_tyrant.remains>20|(cooldown.summon_demonic_tyrant.remains<gcd*2&talent.demonic_consumption.enabled|cooldown.summon_demonic_tyrant.remains<gcd*4&!talent.demonic_consumption.enabled))&(!talent.summon_vilefiend.enabled|cooldown.summon_vilefiend.remains>3))
        if shards >= 5 or (shards >= 3 and cd.callDreadstalkers.remain() > 4 and (cd.summonDemonicTyrant.remain() > 20 or (cd.summonDemonicTyrant.remain() < gcd*2 and talent.demonicConsumption or cd.summonDemonicTyrant.remain() < gcd*4 and not talent.demonicConsumption)) and (not talent.summonVilefiend or cd.summonVilefiend.remain() > 3)) then
            if cast.able.handOfGuldan() then
                if cast.handOfGuldan()  then return true end
            end
        end
        -- actions+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
        if felguardActive and shards < 5 and buff.demonicCore.stack() <= 2 then
            if cast.able.soulStrike() then
                if cast.soulStrike() then return true end
            end
        end
        -- actions+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&((cooldown.summon_demonic_tyrant.remains<6|cooldown.summon_demonic_tyrant.remains>22&!azerite.shadows_bite.enabled)|buff.demonic_core.stack>=3|buff.demonic_core.remains<5|time_to_die<25|buff.shadows_bite.remains)
        if shards <= 3 and buff.demonicCore.exists() and ((cd.summonDemonicTyrant.remain() < 6 or cd.summonDemonicTyrant.remain() > 22 and not trait.shadowsBite.active) or buff.demonicCore.stack() >= 3 or buff.demonicCore.remain() < 5 or  ttd("target") < 25 or buff.shadowsBite.exists()) then
            if cast.able.demonbolt() then
                if cast.demonbolt() then return true end
            end
        end
        -- actions+=/call_action_list,name=build_a_shard
        if actionList_build_a_shard() then return true end
    end




    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat then ImpsIncoming = 0 end
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
            return true
        end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList_Defensive() then
            return true
        end
        -- -----------------------
        -- --- Opener Rotation ---
        -- -----------------------
        -- if opener == false and isChecked("Opener") and isBoss("target") then
        --     if actionList_Opener() then
        --         return
        --     end
        -- end
        ---------------------------
        --- Pre-Combat Rotation ---
        ---------------------------
        if actionList_PreCombat() then
            return true
        end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and profileStop == false and isValidUnit("target") and getDistance("target") < 40 and (opener == true or not isChecked("Opener") or not isBoss("target")) and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
            if actionList_CancelCast() then
                return true
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList_Interrupts() then
                return true
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
                if actionList_rotation() then
                    return true
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

local rotationName = "Fiskee - 8.0.1"
local dsInterrupt = false
---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.chaosBolt},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.cataclysm},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.incinerate},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.darkSoul},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.darkSoul},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.incinerate},
        [4] = { mode = "Lust", value = 4 , overlay = "Cooldowns With Lust", tip = "Cooldowns will be used with bloodlust or simlar effects.", highlight = 0, icon = br.player.spell.darkSoul}
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
-- Cataclysm Button
    CataclysmModes = {
      [1] = { mode = "On", value = 1 , overlay = "Cataclysm enabled", tip = "Will use Cataclysm", highlight = 1, icon = br.player.spell.cataclysm},
      [2] = { mode = "Off", value = 2 , overlay = "Cataclysm disabled", tip = "Will not use Cataclysm", highlight = 0, icon = br.player.spell.cataclysm}
    };
    CreateButton("Cataclysm",5,0)
-- Summon Infernal Button
    InfernalModes = {
      [1] = { mode = "On", value = 1 , overlay = "Summon Infernal enabled", tip = "Will use Summon Infernal", highlight = 1, icon = br.player.spell.summonInfernal},
      [2] = { mode = "Off", value = 2 , overlay = "Summon Infernal disabled", tip = "Will not use Summon Infernal", highlight = 0, icon = br.player.spell.darkSoul}
    };
    CreateButton("Infernal",6,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local rotationKeys = {"None", GetBindingKey("Rotation Function 1"), GetBindingKey("Rotation Function 2"), GetBindingKey("Rotation Function 3"), GetBindingKey("Rotation Function 4"), GetBindingKey("Rotation Function 5")}
    local optionTable
    local function rotationOptions()
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createCheckbox(section, "Pre-Pull Logic", "|cffFFFFFFWill precast incinerate on pull if pulltimer is active")
        -- Opener
            --br.ui:createCheckbox(section,"Opener")
        -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
        -- Summon Pet
            br.ui:createDropdownWithout(section, "Summon Pet", {"Imp","Voidwalker","Felhunter","Succubus", "None"}, 1, "|cffFFFFFFSelect default pet to summon.")
        -- Mana Tap
            br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 8, 1, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")
        -- Cataclysm Units
            br.ui:createSpinnerWithout(section, "Cataclysm Units", 1, 1, 10, 1, "|cffFFFFFFNumber of Units Cataclysm will be cast on.")
        -- Cataclysm Target
            br.ui:createDropdownWithout(section, "Cataclysm Target", {"Target", "Best"}, 1, "|cffFFFFFFCataclysm target")
        -- Shadowfury Hotkey
            br.ui:createDropdown(section,"Shadowfury Hotkey (hold)", rotationKeys, 1, "","|cffFFFFFFShadowfury stun with logic to hit most mobs. Uses keys from Bad Rotation keybindings in WoW settings")
        -- Shadowfury Target
            br.ui:createDropdownWithout(section, "Shadowfury Target", {"Best", "Target", "Cursor"}, 1, "|cffFFFFFFShadowfury target")
        -- Rain of Fire Target
            br.ui:createDropdownWithout(section, "Rain of Fire Target", {"Target", "Best"}, 1, "|cffFFFFFFRain of Fire target")
        -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Rain of Fire Units", 3, 1, 10, 1, "|cffFFFFFFMinimum units to cast rain of fire")
        -- No Dot units
            br.ui:createCheckbox(section, "Dot Blacklist", "|cffFFFFFF Check to ignore certain units for dots")
        -- Predict movement
            br.ui:createCheckbox(section, "Predict Movement (Cata)", "|cffFFFFFF Predict movement of units for cataclysm (works best in solo/dungeons)")
        -- Auto target
            br.ui:createCheckbox(section, "Auto Target", "|cffFFFFFF Will auto change to a new target, if current target is dead")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Potion
            br.ui:createCheckbox(section,"Potion")
        -- Pre Pot
            br.ui:createCheckbox(section,"Pre Pot", "|cffFFFFFF Requires Pre-Pull logic to be active")
        -- Cata with CDs
            br.ui:createCheckbox(section,"Ignore Cataclysm units when using CDs")
        -- Summon Infernal Target
            br.ui:createDropdownWithout(section, "Summon Infernal Target", {"Target", "Best"}, 1, "|cffFFFFFFSummon Infernal Target")
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
        [2] = rotationOptions,
    }}
    return optionTable
end
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
        br.player.mode.cata = br.data.settings[br.selectedSpec].toggles["Cataclysm"]
        br.player.mode.infernal = br.data.settings[br.selectedSpec].toggles["Infernal"]

--------------
--- Locals ---
--------------
        local activePet                                     = br.player.pet
        local activePetId                                   = br.player.petId
        local artifact                                      = br.player.artifact
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
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = GetObjectExists("mouseover")
        local hasteAmount                                   = GetHaste()/100
        local hasPet                                        = IsPetActive()
        local havocActive                                   = br.player.debuff.havoc.count()
        local healPot                                       = getHealthPot()
        local heirloomNeck                                  = 122663 or 122664
        local immolateCount                                 = br.player.debuff.immolate.count()
        local inCombat                                      = isInCombat("player")
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local manaPercent                                   = br.player.power.mana.percent()
        local mode                                          = br.player.mode
        local moving                                        = isMoving("player") ~= false or br.player.moving
        local pet                                           = br.player.pet.list
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = PullTimerRemain()
        local race                                          = br.player.race
        local shards                                        = (UnitPowerDisplayMod(Enum.PowerType.SoulShards) ~= 0) and (UnitPower("player", Enum.PowerType.SoulShards, true) / UnitPowerDisplayMod(Enum.PowerType.SoulShards)) or 0
        local summonPet                                     = getOptionValue("Summon Pet")
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local travelTime                                    = getDistance("target")/16
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units
        local use                                           = br.player.use

        units.get(40)
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(40)

		    if leftCombat == nil then leftCombat = GetTime() end
	      if profileStop == nil or not inCombat then profileStop = false end
        if castSummonId == nil then castSummonId = 0 end
        if summonTime == nil then summonTime = 0 end

        --ttd
        local function ttd(unit)
          local ttdSec = getTTD(unit)
          if getOptionCheck("Enhanced Time to Die") then return ttdSec end
          if ttdSec == -1 then return 999 end
          return ttdSec
        end

        -- Blacklist enemies
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
          local unitCreator = UnitCreator(unit)
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

        --local enemies table with extra data
        local facingUnits = 0
        local enemyTable40 = { }
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
              enemyUnit.distance20 = math.abs(getDistance(thisUnit)-20)
              enemyUnit.hpabs = UnitHealth(thisUnit)
              enemyUnit.facing = getFacing("player",thisUnit)
              if enemyUnit.facing then facingUnits = facingUnits + 1 end
              if havocActive ~= 0 then enemyUnit.havocRemain = debuff.havoc.remain(thisUnit)
              else enemyUnit.havocRemain = 0 end
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
              if enemyTable40[i].havocRemain == 0 then enemyScore = enemyScore + 5 end
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

        --Keybindings
        local shadowfuryKey = false
        if getOptionValue("Shadowfury Hotkey (hold)") ~= 1 then
          shadowfuryKey = _G["rotationFunction"..(getOptionValue("Shadowfury Hotkey (hold)")-1)]
          if shadowfuryKey == nil then shadowfuryKey = false end
        end
        -- spell usable check
        local function spellUsable(spellID)
          if isKnown(spellID) and not select(2,IsUsableSpell(spellID)) and getSpellCD(spellID) == 0 then return true end
          return false
        end

        if lastImmolateT ~= nil and (lastImmolateT + 1.6) < GetTime() then lastImmolate = nil end

        --Infernal
        infernalActive = infernalActive or false
        infernalTime = infernalTime or nil
        local infernalRemain = 0
        local foundInfernal = false
        if pet ~= nil then
          for k, v in pairs(pet) do
            local thisUnit = pet[k] or 0
            if thisUnit.id == 89 and not UnitIsDeadOrGhost(thisUnit.unit) then
              if not infernalActive then
                infernalTime = GetTime()
              end
              foundInfernal = true
              infernalActive = true
              break
            end
          end
        end
        if not foundInfernal then infernalActive = false end
        if infernalActive then infernalRemain = infernalTime - GetTime() + 31 end

        --Havoc stuff
        local havocCheckUnits = 0
        local havocCheck = false
        local cataCheck = false
        local havocRemain = 0
        local havocMult = 1
        for i = 1, #enemyTable40 do
          local thisUnit = enemyTable40[i].unit
          if havocActive ~= 0 then
            local remain = enemyTable40[i].havocRemain
            if remain > havocRemain then havocRemain = remain end
          end
          if enemyTable40[i].ttd > (cast.time.chaosBolt() + gcdMax + 4) then havocCheckUnits = havocCheckUnits + 1 end
          if havocCheckUnits >= 2 and not havocCheck then havocCheck = true end
          if enemyTable40[i].ttd > 3 and not cataCheck then cataCheck = true end
        end
        if 1 + havocRemain > cast.time.chaosBolt() then havocMult = 2 end

        --RoF stuff
        local rofUnits = 0
        for i = 1, #enemies.yards10t do
          local thisUnit = enemies.yards10t[i]
          if ttd(thisUnit) > 3 then rofUnits = rofUnits + 1 end
        end

        --internalCombustion value
        local icValue = 0
        if talent.internalCombustion then icValue = 1 end

        ---Target move timer
        if lastTargetX == nil then lastTargetX, lastTargetY, lastTargetZ = 0,0,0 end
        targetMoveCheck = targetMoveCheck or false
        if br.timer:useTimer("targetMove", 0.8) or combatTime < 0.2 then
          if GetObjectExists("target") then
            local currentX, currentY, currentZ = GetObjectPosition("target")
            targetMoveDistance = math.sqrt(((currentX-lastTargetX)^2)+((currentY-lastTargetY)^2)+((currentZ-lastTargetZ)^2))
            lastTargetX, lastTargetY, lastTargetZ = GetObjectPosition("target")
            if targetMoveDistance < 3 then targetMoveCheck = true
            else targetMoveCheck = false end
          end
        end

        --havoc debuff
        local function havocDebuffExist(unit)
          if havocActive ~= 0 then
            if unit == nil then return debuff.havoc.exists()
            else return debuff.havoc.exists(unit) end
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
            prePull = false
            ppInc = false
        end

        -- Pet Data
        if summonPet == 1 and HasAttachedGlyph(spell.summonImp) then summonId = 58959
        elseif summonPet == 1 then summonId = 416
        elseif summonPet == 2 and HasAttachedGlyph(spell.summonVoidwalker) then summonId = 58960
        elseif summonPet == 2 then summonId = 1860
        elseif summonPet == 3 then summonId = 417
        elseif summonPet == 4 then summonId = 1863 end

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
          if cast.conflagrate("target") then return true end
          if cast.shadowburn("target") then return true end
          if cast.incinerate("target") then return true end
      end
      --Soulstone
      if isChecked("Auto Soulstone Mouseover") and not moving and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player") then
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
          for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
              if cast.spellLockgrimoire(thisUnit) then return end
            end
        end
        elseif activePetId ~= nil and (activePetId == 417 or activePetId == 78158) then
          for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
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
        -- actions.cds=summon_infernal,if=target.time_to_die>=210|!cooldown.dark_soul_instability.remains|target.time_to_die<=30+gcd|!talent.dark_soul_instability.enabled
        if mode.infernal == 1 and (ttd("target") >= 215 or not cd.darkSoul.exists() or buff.darkSoul.remain() > 15 or ttd("target") <= 35 + gcd or not talent.darkSoul or mode.cooldown == 4) then
          if getOptionValue("Summon Infernal Target") == 1 then
            if cast.summonInfernal("target", "ground") then return true end
          elseif getOptionValue("Summon Infernal Target") == 2 then
            if cast.summonInfernal("best",false,1,8) then return true end
          end
        end
        -- actions.cds+=/dark_soul_instability,if=target.time_to_die>=140|pet.infernal.active|target.time_to_die<=20+gcd
        if ttd("target") >= 145 or infernalActive or ttd("target") <= 25 + gcd or mode.cooldown == 4 then
          if cast.darkSoul("player") then return true end
        end
        if isChecked("Racial") and not moving then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
        end
        --actions.cds+=/potion,if=pet.infernal.active|target.time_to_die<65
        if isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() and (infernalActive or ttd("target") < 65) then
          use.battlePotionOfIntellect()
          return true
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

        local function actionList_cata()
          -- actions.cata=call_action_list,name=cds
          if useCDs() and not moving then
            if actionList_Cooldowns() then return end
          end
          -- actions.cata+=/rain_of_fire,if=soul_shard>=4.5
          if shards >= 4.5 and spellUsable(spell.rainOfFire) then
            if getOptionValue("Rain of Fire Target") == 1 and #enemies.yards10t >= getOptionValue("Rain of Fire Units") then
              if cast.rainOfFire("target", "ground") then return true end
            else
              if cast.rainOfFire("best",false,getOptionValue("Rain of Fire Units"),10) then return true end
            end
          end
          if not moving then
            -- actions.cata+=/cataclysm
            if mode.cata == 1 and spellUsable(spell.cataclysm) and cataCheck then
              if getOptionValue("Cataclysm Target") == 1 then
                if #enemies.yards8t >= getOptionValue("Cataclysm Units") or (useCDs() and isChecked("Ignore Cataclysm units when using CDs")) then
                  if isChecked("Predict Movement (Cata)") then
                    if createCastFunction("target","ground",1,8,spell.cataclysm,nil,true) then return true end
                  elseif not isMoving("target") or targetMoveCheck then
                    if cast.cataclysm("target", "ground") then return true end
                  end
                end
              elseif getOptionValue("Cataclysm Target") == 2 then
                if useCDs() and isChecked("Ignore Cataclysm units when using CDs") then
                  if isChecked("Predict Movement (Cata)") then
                    if createCastFunction("best",false,1,8,spell.cataclysm,nil,true) then return true end
                  else
                    if cast.cataclysm("best",false,1,8) then return true end
                  end
                else
                  if isChecked("Predict Movement (Cata)") then
                    if createCastFunction("best",false,getOptionValue("Cataclysm Units"),8,spell.cataclysm,nil,true) then return true end
                  else
                    if cast.cataclysm("best",false,getOptionValue("Cataclysm Units"),8) then return true end
                  end
                end
              end
            end
            -- actions.cata+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
            if spellUsable(spell.immolate) and not GetUnitIsUnit(lastImmolate, "target") and talent.channelDemonfire and not debuff.immolate.exists() and cd.channelDemonfire.remain() <= cast.time.chaosBolt() then
              if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
            end
            -- actions.cata+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 and debuff.havoc.count() == 0 then
              if cast.channelDemonfire() then return true end
            end
            -- actions.cata+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=8&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
            if spellUsable(spell.havoc) and #enemies.yards8t <= 8 and talent.grimoireOfSupremacy and infernalActive and infernalRemain <= 10 and havocCheck then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].ttd > 10 and enemyTable40[i].havocRemain == 0 and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=8&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
              if ttd("target") > 10 and not havocDebuffExist("target") then
                if cast.havoc("target") then return true end
              end
            end
            -- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&active_enemies<=8&((108*spell_targets.rain_of_fire%3)<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
            if spellUsable(spell.chaosBolt) and talent.grimoireOfSupremacy and infernalActive and infernalRemain > cast.time.chaosBolt()+1 and #enemies.yards40 <= 8 and ((108 * #enemies.yards8t % 3) < (240*(1+0.08*buff.grimoireOfSupremacy.stack())%2*havocMult)) then
              if not havocDebuffExist() and ttd("target") > 6 then
                if cast.chaosBolt() then return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].ttd > 6 and enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                  if cast.chaosBolt(thisUnit) then return true end
                end
              end
            end
            -- actions.cata+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4
            if #enemies.yards8t <= 4 then
              if havocCheck and spellUsable(spell.havoc) then
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].ttd > 10 and enemyTable40[i].havocRemain == 0 and not GetUnitIsUnit(thisUnit, "target") then
                    if cast.havoc(thisUnit) then return true end
                  end
                end
              -- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=4
                if ttd("target") > 10 and not havocDebuffExist("target") then
                  if cast.havoc("target") then return true end
                end
              end
            -- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=4
              if havocRemain > cast.time.chaosBolt() and spellUsable(spell.chaosBolt) then
                if not havocDebuffExist() and ttd("target") > 6 then
                  if cast.chaosBolt() then return true end
                end
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].ttd > 6 and enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                    if cast.chaosBolt(thisUnit) then return true end
                  end
                end
              end
            end
            -- actions.cata+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable&remains<=cooldown.cataclysm.remains
            if immolateCount < getOptionValue("Multi-Dot Limit") and spellUsable(spell.immolate) then
              if not GetUnitIsUnit(lastImmolate, "target") and not debuff.immolate.exists() and ttd("target") > 4 and (not havocDebuffExist() or facingUnits == 1) then
                  if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and not GetUnitIsUnit(thisUnit, lastImmolate) and not debuff.immolate.exists(thisUnit) and enemyTable40[i].ttd > 4 and enemyTable40[i].havocRemain == 0 then
                    if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
                end
              end
            end
            if spellUsable(spell.immolate) then
              if not GetUnitIsUnit(lastImmolate, "target") and debuff.immolate.exists() and debuff.immolate.refresh() and ttd("target") > 4 and not havocDebuffExist() and (not useCDs() or debuff.immolate.remain() <= cd.cataclysm.remain()) then
                if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and not GetUnitIsUnit(thisUnit, lastImmolate) and enemyTable40[i].ttd > 4 and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and enemyTable40[i].havocRemain == 0 and (not useCDs() or debuff.immolate.remain(thisUnit) <= cd.cataclysm.remain()) then
                  if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
                end
              end
            end
            -- actions.cata+=/rain_of_fire
            if getOptionValue("Rain of Fire Target") == 1 and #enemies.yards10t >= getOptionValue("Rain of Fire Units") then
              if cast.rainOfFire("target", "ground") then return true end
            else
              if cast.rainOfFire("best",false,getOptionValue("Rain of Fire Units"),10) then return true end
            end
            -- actions.cata+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
            if spellUsable(spell.soulFire) then
              if not havocDebuffExist() or facingUnits == 1 then
                if cast.soulFire() then return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                  if cast.soulFire(thisUnit) then return true end
                end
              end
            end
          end
          -- actions.cata+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains
          if spellUsable(spell.conflagrate) then
            if (not havocDebuffExist() and not debuff.conflagrate.exists()) or facingUnits == 1 then
              if cast.conflagrate() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 and (not GetUnitIsUnit(thisUnit, "target") or facingUnits == 1) then
                if cast.conflagrate(thisUnit) then return true end
              end
            end
          end
          -- actions.cata+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
          if spellUsable(spell.shadowburn) and charges.shadowburn.count() == 2 or not buff.backdraft.exists("player") or (buff.backdraft.remain("player") > (buff.backdraft.stack() * cast.time.incinerate())) then
            if not havocDebuffExist() or facingUnits == 1 then
              if cast.shadowburn() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                if cast.shadowburn(thisUnit) then return true end
              end
            end
          end
          if not moving and spellUsable(spell.incinerate) then
            -- actions.cata+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not havocDebuffExist() or facingUnits == 1 then
              if cast.incinerate() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                if cast.incinerate(thisUnit) then return true end
              end
            end
          end
        end

        local function actionList_fnb()
          -- actions.fnb=call_action_list,name=cds
          if useCDs() and not moving then
            if actionList_Cooldowns() then return end
          end
          -- actions.fnb+=/rain_of_fire,if=soul_shard>=4.5
          if shards >= 4.5 and spellUsable(spell.rainOfFire) then
            if getOptionValue("Rain of Fire Target") == 1 and #enemies.yards10t >= getOptionValue("Rain of Fire Units") then
              if cast.rainOfFire("target", "ground") then return true end
            else
              if cast.rainOfFire("best",false,getOptionValue("Rain of Fire Units"),10) then return true end
            end
          end
          if not moving then
            -- actions.fnb+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
            if spellUsable(spell.immolate) and not GetUnitIsUnit(lastImmolate, "target") and talent.channelDemonfire and not debuff.immolate.exists() and cd.channelDemonfire.remain() <= cast.time.chaosBolt() then
              if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
            end
            -- actions.cata+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 and debuff.havoc.count() == 0 then
              if cast.channelDemonfire() then return true end
            end
            -- actions.fnb+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
            if spellUsable(spell.havoc) and #enemies.yards8t <= 4 and talent.grimoireOfSupremacy and infernalActive and infernalRemain <= 10 and havocCheck then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].ttd > 10 and enemyTable40[i].havocRemain == 0 and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.fnb+=/havoc,if=spell_targets.rain_of_fire<=4&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
              if ttd("target") > 10 and not havocDebuffExist("target") then
                if cast.havoc("target") then return true end
              end
            end
            -- actions.fnb+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&active_enemies<=4&((108*spell_targets.rain_of_fire%3)<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
            if spellUsable(spell.chaosBolt) and talent.grimoireOfSupremacy and infernalActive and infernalRemain > cast.time.chaosBolt()+1 and #enemies.yards40 <= 4 and ((108 * #enemies.yards8t % 3) < (240*(1+0.08*buff.grimoireOfSupremacy.stack())%2*havocMult)) then
              if not havocDebuffExist() and ttd("target") > 6 then
                if cast.chaosBolt() then return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].ttd > 6 and enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                  if cast.chaosBolt(thisUnit) then return true end
                end
              end
            end
            -- actions.fnb+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4
            if #enemies.yards8t <= 4 then
              if havocCheck and spellUsable(spell.havoc) then
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].ttd > 10 and enemyTable40[i].havocRemain == 0 and not GetUnitIsUnit(thisUnit, "target") then
                    if cast.havoc(thisUnit) then return true end
                  end
                end
              -- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=4
                if ttd("target") > 10 and not havocDebuffExist("target") then
                  if cast.havoc("target") then return true end
                end
              end
            -- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=4
              if havocRemain > cast.time.chaosBolt() and spellUsable(spell.chaosBolt) then
                if not havocDebuffExist() and ttd("target") > 6 then
                  if cast.chaosBolt() then return true end
                end
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].ttd > 6 and enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                    if cast.chaosBolt(thisUnit) then return true end
                  end
                end
              end
            end
            -- actions.fnb+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable&spell_targets.incinerate<=8
            if #enemies.yards10t <= 8 and spellUsable(spell.immolate) then
              if immolateCount < getOptionValue("Multi-Dot Limit") then
                if not GetUnitIsUnit(lastImmolate, "target") and not debuff.immolate.exists() and ttd("target") > 4 and (not havocDebuffExist() or facingUnits == 1) then
                    if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
                end
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].facing and not GetUnitIsUnit(thisUnit, lastImmolate) and not debuff.immolate.exists(thisUnit) and enemyTable40[i].ttd > 4 and enemyTable40[i].havocRemain == 0 then
                      if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
                  end
                end
              end
              if not GetUnitIsUnit(lastImmolate, "target") and debuff.immolate.exists() and debuff.immolate.refresh() and ttd("target") > 4 and (not havocDebuffExist() or facingUnits == 1) then
                  if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and not GetUnitIsUnit(thisUnit, lastImmolate) and enemyTable40[i].ttd > 4 and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and enemyTable40[i].havocRemain == 0 then
                  if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
                end
              end
            end
          end
          if not moving then
            -- actions.fnb+=/rain_of_fire
            if getOptionValue("Rain of Fire Target") == 1 and #enemies.yards10t >= getOptionValue("Rain of Fire Units") then
              if cast.rainOfFire("target", "ground") then return true end
            else
              if cast.rainOfFire("best",false,getOptionValue("Rain of Fire Units"),10) then return true end
            end
            -- actions.fnb+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains&spell_targets.incinerate=3
            if #enemies.yards10t <= 3 and spellUsable(spell.soulFire) then
              if not havocDebuffExist() or facingUnits == 1 then
                if cast.soulFire() then return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                  if cast.soulFire(thisUnit) then return true end
                end
              end
            end
          end
          -- actions.fnb+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains&(talent.flashover.enabled&buff.backdraft.stack<=2|spell_targets.incinerate<=7|talent.roaring_blaze.enabled&spell_targets.incinerate<=9)
          if spellUsable(spell.conflagrate) and (talent.flashover and buff.backdraft.stack() <= 2) or #enemies.yards10t <= 7 or (#enemies.yards10t <= 9 and talent.roaringBlaze) then
            if (not havocDebuffExist() and not debuff.conflagrate.exists()) or facingUnits == 1 then
              if cast.conflagrate() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 and (not GetUnitIsUnit(thisUnit, "target") or facingUnits == 1) then
                if cast.conflagrate(thisUnit) then return true end
              end
            end
          end
          if not moving and spellUsable(spell.incinerate) then
          -- actions.fnb+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not havocDebuffExist() or facingUnits == 1 then
              if cast.incinerate() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                if cast.incinerate(thisUnit) then return true end
              end
            end
          end
        end

        local function actionList_inf()
          -- actions.inf=call_action_list,name=cds
          if useCDs() and not moving then
            if actionList_Cooldowns() then return end
          end
          -- actions.inf+=/rain_of_fire,if=soul_shard>=4.5
          if shards >= 4.5 then
            if getOptionValue("Rain of Fire Target") == 1 and #enemies.yards10t >= getOptionValue("Rain of Fire Units") then
              if cast.rainOfFire("target", "ground") then return true end
            else
              if cast.rainOfFire("best",false,getOptionValue("Rain of Fire Units"),10) then return true end
            end
          end
          if not moving then
            -- actions.inf+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
            if not GetUnitIsUnit(lastImmolate, "target") and talent.channelDemonfire and not debuff.immolate.exists() and cd.channelDemonfire.remain() <= cast.time.chaosBolt() then
              if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
            end
            -- actions.inf+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 and debuff.havoc.count() == 0 then
              if cast.channelDemonfire() then return true end
            end
            -- actions.inf+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4+talent.internal_combustion.enabled&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
            if #enemies.yards8t <= 4 + icValue and talent.grimoireOfSupremacy and infernalActive and infernalRemain <= 10 and havocCheck then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].ttd > 10 and enemyTable40[i].havocRemain == 0 and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.inf+=/havoc,if=spell_targets.rain_of_fire<=4+talent.internal_combustion.enabled&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
              if ttd("target") > 10 and not havocDebuffExist("target") then
                if cast.havoc("target") then return true end
              end
            end
            -- actions.inf+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&spell_targets.rain_of_fire<=4+talent.internal_combustion.enabled&((108*spell_targets.rain_of_fire%(3-0.16*spell_targets.rain_of_fire))<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
            if talent.grimoireOfSupremacy and infernalActive and infernalRemain > cast.time.chaosBolt()+1 and #enemies.yards8t <= 4 + icValue and ((108 * #enemies.yards8t %(3 - 0.16*#enemies.yards8t)) < (240*(1+0.08*buff.grimoireOfSupremacy.stack())%2*havocMult)) then
              if not havocDebuffExist() and ttd("target") > 6 then
                if cast.chaosBolt() then return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].ttd > 6 and enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                  if cast.chaosBolt(thisUnit) then return true end
                end
              end
            end
            -- actions.inf+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=3&(talent.eradication.enabled|talent.internal_combustion.enabled)
            if #enemies.yards8t <= 3 and (talent.eradication or talent.internalCombustion) then
              if havocCheck then
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].ttd > 10 and enemyTable40[i].havocRemain == 0 and not GetUnitIsUnit(thisUnit, "target") then
                    if cast.havoc(thisUnit) then return true end
                  end
                end
              -- actions.inf+=/havoc,if=spell_targets.rain_of_fire<=3&(talent.eradication.enabled|talent.internal_combustion.enabled)
                if ttd("target") > 10 and not havocDebuffExist("target") then
                  if cast.havoc("target") then return true end
                end
              end
            -- actions.inf+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=3&(talent.eradication.enabled|talent.internal_combustion.enabled)
              if havocRemain > cast.time.chaosBolt() then
                if not havocDebuffExist() and ttd("target") > 6 then
                  if cast.chaosBolt() then return true end
                end
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].ttd > 6 and enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                    if cast.chaosBolt(thisUnit) then return true end
                  end
                end
              end
            end
            -- actions.inf+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable
            if immolateCount < getOptionValue("Multi-Dot Limit") then
              if not GetUnitIsUnit(lastImmolate, "target") and not debuff.immolate.exists() and ttd("target") > 4 and (not havocDebuffExist() or facingUnits == 1) then
                  if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
              end
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and not GetUnitIsUnit(thisUnit, lastImmolate) and not debuff.immolate.exists(thisUnit) and enemyTable40[i].ttd > 4 and enemyTable40[i].havocRemain == 0 then
                    if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
                end
              end
            end
            if not GetUnitIsUnit(lastImmolate, "target") and debuff.immolate.exists() and debuff.immolate.refresh() and ttd("target") > 4 and (not havocDebuffExist() or facingUnits == 1) then
                if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and not GetUnitIsUnit(thisUnit, lastImmolate) and enemyTable40[i].ttd > 4 and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and enemyTable40[i].havocRemain == 0 then
                if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
              end
            end
          end
          if not moving then
          -- actions.inf+=/rain_of_fire
            if getOptionValue("Rain of Fire Target") == 1 and #enemies.yards10t >= getOptionValue("Rain of Fire Units") then
              if cast.rainOfFire("target", "ground") then return true end
            else
              if cast.rainOfFire("best",false,getOptionValue("Rain of Fire Units"),10) then return true end
            end
            -- actions.inf+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
            if not havocDebuffExist() or facingUnits == 1 then
              if cast.soulFire() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                if cast.soulFire(thisUnit) then return true end
              end
            end
          end
          -- actions.inf+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains
          if (not havocDebuffExist() and not debuff.conflagrate.exists()) or facingUnits == 1 then
            if cast.conflagrate() then return true end
          end
          for i = 1, #enemyTable40 do
            local thisUnit = enemyTable40[i].unit
            if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 and (not GetUnitIsUnit(thisUnit, "target") or facingUnits == 1) then
              if cast.conflagrate(thisUnit) then return true end
            end
          end
          -- actions.inf+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
          if charges.shadowburn.count() == 2 or not buff.backdraft.exists("player") or (buff.backdraft.remain("player") > (buff.backdraft.stack() * cast.time.incinerate())) then
            if not havocDebuffExist() or facingUnits == 1 then
              if cast.shadowburn() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                if cast.shadowburn(thisUnit) then return true end
              end
            end
          end
          if not moving then
            -- actions.inf+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not havocDebuffExist() or facingUnits == 1 then
              if cast.incinerate() then return true end
            end
            for i = 1, #enemyTable40 do
              local thisUnit = enemyTable40[i].unit
              if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                if cast.incinerate(thisUnit) then return true end
              end
            end
          end
        end

        local function actionList_Rotation()
          -- actions=run_action_list,name=cata,if=spell_targets.infernal_awakening>=3&talent.cataclysm.enabled
          if rofUnits >= 3 and mode.rotation ~= 3 then
            if talent.cataclysm then
              if actionList_cata() then return end
          -- actions+=/run_action_list,name=fnb,if=spell_targets.infernal_awakening>=3&talent.fire_and_brimstone.enabled
            elseif talent.fireAndBrimstone then
              if actionList_fnb() then return end
          -- actions+=/run_action_list,name=inf,if=spell_targets.infernal_awakening>=3&talent.inferno.enabled
            elseif talent.inferno then
              if actionList_inf() then return end
            end
          end
          if not moving then
            -- actions+=/cataclysm
            if mode.cata == 1 and spellUsable(spell.cataclysm) and cataCheck then
              if getOptionValue("Cataclysm Target") == 1 then
                if #enemies.yards8t >= getOptionValue("Cataclysm Units") or (useCDs() and isChecked("Ignore Cataclysm units when using CDs")) then
                  if isChecked("Predict Movement (Cata)") then
                    if createCastFunction("target","ground",1,8,spell.cataclysm,nil,true) then return true end
                  elseif not isMoving("target") or targetMoveCheck then
                    if cast.cataclysm("target", "ground") then return true end
                  end
                end
              elseif getOptionValue("Cataclysm Target") == 2 then
                if useCDs() and isChecked("Ignore Cataclysm units when using CDs") then
                  if isChecked("Predict Movement (Cata)") then
                    if createCastFunction("best",false,1,8,spell.cataclysm,nil,true) then return true end
                  else
                    if cast.cataclysm("best",false,1,8) then return true end
                  end
                else
                  if isChecked("Predict Movement (Cata)") then
                    if createCastFunction("best",false,getOptionValue("Cataclysm Units"),8,spell.cataclysm,nil,true) then return true end
                  else
                    if cast.cataclysm("best",false,getOptionValue("Cataclysm Units"),8) then return true end
                  end
                end
              end
            end
            -- actions+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&(refreshable|talent.internal_combustion.enabled&action.chaos_bolt.in_flight&remains-action.chaos_bolt.travel_time-5<duration*0.3)
            if spellUsable(spell.immolate) and immolateCount < getOptionValue("Multi-Dot Limit") then --TODO Add CB thingy
              if not GetUnitIsUnit(lastImmolate, "target") and not debuff.immolate.exists() and ttd("target") > 4 and (not havocDebuffExist() or facingUnits == 1) then
                  if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
              end
              if mode.rotation == 1 or mode.rotation == 2 then
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].facing and not GetUnitIsUnit(thisUnit, lastImmolate) and not debuff.immolate.exists(thisUnit) and enemyTable40[i].ttd > 4 and enemyTable40[i].havocRemain == 0 then
                      if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
                  end
                end
              end
            end
            if spellUsable(spell.immolate) and not GetUnitIsUnit(lastImmolate, "target") and ttd("target") > 4 and debuff.immolate.exists() and debuff.immolate.refresh() and (not havocDebuffExist() or facingUnits == 1 or mode.rotation == 3) then
                if cast.immolate() then lastImmolate = "target"; lastImmolateT = GetTime(); return true end
            end
            if spellUsable(spell.immolate) and (mode.rotation == 1 or mode.rotation == 2) then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and enemyTable40[i].ttd > 4 and not GetUnitIsUnit(thisUnit, lastImmolate) and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and enemyTable40[i].havocRemain == 0 then
                  if cast.immolate(thisUnit) then lastImmolate = thisUnit; lastImmolateT = GetTime(); return true end
                end
              end
            end
            -- actions+=/call_action_list,name=cds
            if useCDs() and not moving then
              if actionList_Cooldowns() then return true end
            end
            -- actions+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 and debuff.havoc.count() == 0 then
              if cast.channelDemonfire() then return true end
            end
            -- actions+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10
            if spellUsable(spell.havoc) and havocCheck and mode.rotation ~= 3 then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].ttd > 10 and enemyTable40[i].havocRemain == 0 and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
              -- actions+=/havoc,if=active_enemies>1
              if ttd("target") > 10 and not havocDebuffExist("target") then
                if cast.havoc("target") then return true end
              end
            end
            -- actions+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
            if spellUsable(spell.soulFire) then
              if not havocDebuffExist() or facingUnits == 1 or mode.rotation == 3 then
                if cast.soulFire() then return true end
              end
              if mode.rotation ~= 3 then
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                    if cast.soulFire(thisUnit) then return true end
                  end
                end
              end
            end
            -- actions+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&execute_time+travel_time<target.time_to_die&(talent.internal_combustion.enabled|!talent.internal_combustion.enabled&soul_shard>=4|(talent.eradication.enabled&debuff.eradication.remains<=cast_time)|buff.dark_soul_instability.remains>cast_time|pet.infernal.active&talent.grimoire_of_supremacy.enabled)
            if spellUsable(spell.chaosBolt) then
              if (not havocDebuffExist() or facingUnits == 1 or mode.rotation == 3) and (cast.time.chaosBolt() + (getDistance("target")/16)) < ttd("target") and (talent.internalCombustion or (not talent.internalCombustion and shards >= 4) or
              (talent.eradication and debuff.eradication.remain() <= cast.time.chaosBolt()) or (buff.darkSoul.remain("player") > cast.time.chaosBolt()) or (infernal and talent.grimoireOfService)) then
                if cast.chaosBolt() then return true end
              end
              if mode.rotation ~= 3 then
                for i = 1, #enemyTable40 do
                  local thisUnit = enemyTable40[i].unit
                  if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 and (cast.time.chaosBolt() + (enemyTable40[i].distance/16)) < enemyTable40[i].ttd and (talent.internalCombustion or (not talent.internalCombustion and shards >= 4) or
                  (talent.eradication and debuff.eradication.remain(thisUnit) <= cast.time.chaosBolt()) or (buff.darkSoul.remain("player") > cast.time.chaosBolt()) or (infernal and talent.grimoireOfService)) then
                    if cast.chaosBolt(thisUnit) then return true end
                  end
                end
              end
            end
          end
          -- actions+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains&((talent.flashover.enabled&buff.backdraft.stack<=2)|(!talent.flashover.enabled&buff.backdraft.stack<2))
          if spellUsable(spell.conflagrate) and (talent.flashover and buff.backdraft.stack() <= 2) or (not talent.flashover and buff.backdraft.stack() < 2) then
            if not havocDebuffExist() or facingUnits == 1 or mode.rotation == 3 then
              if cast.conflagrate() then return true end
            end
            if mode.rotation ~= 3 then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 and (not GetUnitIsUnit(thisUnit, "target") or facingUnits == 1) then
                  if cast.conflagrate(thisUnit) then return true end
                end
              end
            end
          end
          -- actions+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
          if spellUsable(spell.shadowburn) and charges.shadowburn.count() == 2 or not buff.backdraft.exists("player") or (buff.backdraft.remain("player") > (buff.backdraft.stack() * cast.time.incinerate())) then
            if not havocDebuffExist() or facingUnits == 1 or mode.rotation == 3 then
              if cast.shadowburn() then return true end
            end
            if mode.rotation ~= 3 then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                  if cast.shadowburn(thisUnit) then return true end
                end
              end
            end
          end
          if not moving and spellUsable(spell.incinerate) then
            -- actions+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not havocDebuffExist() or facingUnits == 1 or mode.rotation == 3 then
              if cast.incinerate() then return true end
            end
            if mode.rotation ~= 3 then
              for i = 1, #enemyTable40 do
                local thisUnit = enemyTable40[i].unit
                if enemyTable40[i].facing and enemyTable40[i].havocRemain == 0 then
                  if cast.incinerate(thisUnit) then return true end
                end
              end
            end
          end
        end

        local function actionList_Opener()
          opener = true
        end

        local function actionList_PreCombat()
        -- Summon Pet
            local petPadding = 2
            if talent.grimoireOfSacrifice then petPadding = 5 end
            -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
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
                    if useCDs() and isChecked("Pre-Pull Logic") and GetObjectExists("target") and getDistance("target") < 40 then
                      local incinerateExecute = cast.time.incinerate() + (getDistance("target")/25)
                        if pullTimer <= incinerateExecute then
                            if isChecked("Pre Pot") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() then
                                use.battlePotionOfIntellect()
                            end
                            if ppInc == false then if cast.incinerate("target") then ppInc = true; return true end end
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
                      -- actions.precombat+=/soul_fire
                      if talent.soulFire then
                        if cast.soulFire() then return true end
                      end
                      -- actions.precombat+=/incinerate,if=!talent.soul_fire.enabled
                      if not talent.soulFire then
                        if not moving then
                          if cast.incinerate() then return true end
                        else
                          if cast.conflagrate() then return true end
                        end
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
        elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or pause(true) or mode.rotation==4 then
          if not pause(true) and IsPetAttackActive() and isChecked("Pet Management") then
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
        if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40
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
            -- rotation
            if actionList_Rotation() then return end
          end -- End SimC APL
        end --End In Combat
      end --End Rotation Logic
    end -- End Timer
-- end -- End runRotation
local id = 267
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

local rotationName = "immy552225"
local br = br
br.rogueTablez = {}
local rogueTablez = br.rogueTablez
rogueTablez.enemyTable5,
  rogueTablez.enemyTable10,
  rogueTablez.enemyTable30 = {}, {}, {}
local enemyTable5,
  enemyTable10,
  enemyTable30 = rogueTablez.enemyTable5, rogueTablez.enemyTable10, rogueTablez.enemyTable30




---------------
--- Toggles ---
---------------
local function createToggles()
  RotationModes = {
    [1] = {
      mode = "",
      value = 1,
      overlay = "DPS Rotation Enabled",
      tip = "Enable DPS Rotation",
      highlight = 1,
      icon = br.player.spell.toxicBlade
    },
    [2] = {
      mode = "",
      value = 2,
      overlay = "DPS Rotation Disabled",
      tip = "Disable DPS Rotation",
      highlight = 0,
      icon = br.player.spell.crimsonVial
    }
  }
  CreateButton("Rotation", 1, 0)
  CleaveModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "Cleave on.", highlight = 1, icon = br.player.spell.rupture},
    [2] = {mode = "", value = 2, overlay = "", tip = "Cleave off.", highlight = 0, icon = br.player.spell.rupture}
  }
  CreateButton("Cleave", 2, 0)
  InterruptModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.kick},
    [2] = {mode = "T", value = 2, overlay = "", tip = "", highlight = 1, icon = br.player.spell.kick},
    [3] = {mode = "", value = 3, overlay = "", tip = "", highlight = 0, icon = br.player.spell.kick}
  }
  CreateButton("Interrupt", 3, 0)
  StunModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.kidneyShot},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.kidneyShot}
  }
  CreateButton("Stun", 3, 1)
  SpecialModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.vendetta},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.vendetta}
  }
  CreateButton("Special", 4, 0)
  OpenerModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.garrote},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.garrote}
  }
  CreateButton("Opener", 4, 1)
  FeintModes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.feint},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.feint}
  }
  CreateButton("Feint", 2, 1)
  Van1Modes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.crimsonTempest},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.crimsonTempest}
  }
  CreateButton("Van1", 5, 0)
  Van2Modes = {
    [1] = {mode = "", value = 1, overlay = "", tip = "", highlight = 1, icon = br.player.spell.vanish},
    [2] = {mode = "", value = 2, overlay = "", tip = "", highlight = 0, icon = br.player.spell.vanish}
  }
  CreateButton("Van2", 5, 1)
  CDafterModes = {
    [1] = {mode = "", value = 1, overlay = "before", tip = "", highlight = 0, icon = br.player.spell.crimsonTempest},
    [2] = {mode = "after", value = 2, overlay = "after", tip = "", highlight = 1, icon = br.player.spell.crimsonTempest}
  }
  CreateButton("CDafter", 6, 0)
  CDTargetModes = {
    [1] = {mode = "T", value = 1, overlay = "T", tip = "", highlight = 0, icon = br.player.spell.vanish},
    [2] = {mode = "HP", value = 2, overlay = "HP", tip = "", highlight = 0, icon = br.player.spell.vanish}
  }
  CreateButton("CDTarget", 6, 1)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
  local optionTable
  local function rotationOptions()
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = br.ui:createSection(br.ui.window.profile, "General")
    br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFF000020Yards"}, 2, "Stealthing method.")
    br.ui:createCheckbox(section, "Debug")
    br.ui:createCheckbox(section, "debug2")
    br.ui:createCheckbox(section, "Show hitbox+back")
    br.ui:createCheckbox(section, "Viable targets")
    br.ui:createCheckbox(section, "Respect PullTimer")
    br.ui:checkSectionState(section)
    ------------------------
    --- OFFENSIVE OPTIONS ---
    ------------------------
    section = br.ui:createSection(br.ui.window.profile, "Offensive")
    br.ui:createCheckbox(section, "Trinkets")
    br.ui:createCheckbox(section, "Vendetta + pot if bloodlust up")
    br.ui:createCheckbox(section, "Force Envenom")
    br.ui:createCheckbox(section, "Galecaller")
    br.ui:createCheckbox(section, "Racial")
    br.ui:createCheckbox(section, "No Pooling")
    br.ui:createCheckbox(section, "Apply Deadly Poison in melee")
    --br.ui:createCheckbox(section, "Toxic Blade/Exsa")
    br.ui:createCheckbox(section, "Search for orb/ghuunies")
    br.ui:createCheckbox(section, "Check AA")
    br.ui:createCheckbox(section, "Opener refresh")
    br.ui:createCheckbox(section, "Exsa no vendetta opener")
    br.ui:createCheckbox(section, "Toxic Blade on cd")
    br.ui:createCheckbox(section, "Check for finisher on aoe")
    br.ui:createCheckbox(section, "Prefer fok over finisher when energy positive")
    br.ui:createSpinnerWithout(section, "Dots HP Limit", 15, 0, 105, 1, "|cffFFFFFFHP *10k hp for dots to be AOE casted/refreshed on.")
    --br.ui:createSpinnerWithout(section, "Max Garrotes refresh SS",  3,  1,  6,  1,  "max garrotes ss")
    br.ui:checkSectionState(section)
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Defensive")
    br.ui:createSpinner(section, "Healing Potion/Healthstone", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
    br.ui:createSpinner(section, "Crimson Vial", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
    br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
    br.ui:createSpinner(section, "Evasion", 50, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
    br.ui:checkSectionState(section)

    section = br.ui:createSection(br.ui.window.profile, "Special")
    br.ui:createCheckbox(section, "AutoKidney", "|cffFFFFFF Auto Kidney dangerous casts")
    br.ui:createCheckbox(section, "AutoBlind", "|cffFFFFFF Auto Blind dangerous casts")
    br.ui:createCheckbox(section, "ShadowStep cam fixed", "Cam fix for perverts")
    br.ui:checkSectionState(section)

    -------------------------
    --- INTERRUPT OPTIONS ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    br.ui:createCheckbox(section, "Kick")
    br.ui:createCheckbox(section, "Kidneyshot")
    br.ui:createCheckbox(section, "Blind")
    br.ui:createSpinner(section, "Interrupt At", 0, 0, 100, 5, "|cffFFBB00Cast Percentage to use at.")
    br.ui:checkSectionState(section)
    ----------------------
    --- TOGGLE OPTIONS ---
    ----------------------
    section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
    -- Single/Multi Toggle
    br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle, 4)
    --Cooldown Key Toggle
    br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
    --Defensive Key Toggle
    br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle, 6)
    -- Interrupts Key Toggle
    br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
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
  -- print(UnitGUID("target").."     1")
  -- print(ObjectGUID("target").."     2")
  -- print(CheckInteractDistance(ObjectPointer("target"), 2))
  -- print(getDistance("target"))
  -- print(getSpellCD(61304))
  -- Start, CD, enabled, modRate = GetSpellCooldown(61304)
  -- print("Left = "..getSpellCD(61304)..". Start = "..Start..". CD = "..CD..". GetTime = "..GetTime())
  --Print("Running: "..rotationName)
  -- if UnitCastID("player") ~= 0 then
  --   print(UnitCastID("player"))
  -- end
  -- local name = GetSpellInfo(1943)
  -- print(getSpellCD(name))
  -- print(canpewpew)
  -- canpewpew = false


  ---------------
  --- Toggles ---
  ---------------
  UpdateToggle("Rotation", 0.25)
  UpdateToggle("Interrupt", 0.25)
  br.player.mode.interrupt = br.data.settings[br.selectedSpec].toggles["Interrupt"]
  br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
  br.player.mode.opener = br.data.settings[br.selectedSpec].toggles["Opener"]
  br.player.mode.stun = br.data.settings[br.selectedSpec].toggles["Stun"]
  br.player.mode.feint = br.data.settings[br.selectedSpec].toggles["Feint"]
  br.player.mode.van1 = br.data.settings[br.selectedSpec].toggles["Van1"]
  br.player.mode.van2 = br.data.settings[br.selectedSpec].toggles["Van2"]
  br.player.mode.special = br.data.settings[br.selectedSpec].toggles["Special"]
  br.player.mode.cdtarget = br.data.settings[br.selectedSpec].toggles["CDTarget"]
  br.player.mode.cdafter = br.data.settings[br.selectedSpec].toggles["CDafter"]
  --------------
  --- Locals ---
  --------------
  local buff = br.player.buff
  local cast = br.player.cast
  local cd = br.player.cd
  local combatTime = getCombatTime()
  local combo,
    comboDeficit,
    comboMax = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
  local combospend = ComboMaxSpend()
  local debuff = br.player.debuff
  local enemies = br.player.enemies
  local energy,
    energyDeficit,
    energyRegen = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
  local gcd = getSpellCD(61304)
  local gcdcheck = gcdcheck or 0
  -- local gcdleft = getSpellCD(61304)
  local healPot = getHealthPot()
  local inCombat = isInCombat("player")
  local mode = br.player.mode
  local php = br.player.health    
  -- local pullTimer = br.DBM:getPulltimer()
  local race = br.player.race
  local racial = br.player.getRacial()
  local solo = #br.friend < 2
  local spell = br.player.spell
  local stealth = buff.stealth.exists() or buff.vanish.exists() or buff.stealthsub.exists()
  --local stealthingAll = stealthingRogue or br.player.buff.shadowmeld.exists()
  local talent = br.player.talent
  -- local subtcheck = (true and gcdleft < br.player.buff.subterfuge.remain() and  br.player.buff.subterfuge.remain() >= 0.2 and br.player.buff.subterfuge.exists()) or false
  local stealthingRogue = stealth or buff.vanish.exists() or (buff.subterfuge.exists() and buff.subterfuge.remain() - getSpellCD(61304) >= 0.1) or botSpell == spell.vanish
  local trait = br.player.traits
  --local ttm = br.player.power.energy.ttm() -- ??
  local units = br.player.units
  local lootDelay = getOptionValue("LootDelay")
  -- print(debuff.rupture.applied("target"))
  -- if IsAddOnLoaded("Bigwigs") then
  --   print("BW")
  -- elseif IsAddOnLoaded("DBM-Core") then
  --   print("DBM")
  -- end

  -- if PullTimerRemain(true) then
  --   print(PullTimerRemain())
  -- end
   -- print(debuff.garrote.applied("target"))
  --local start,
  --  duration = GetSpellCooldown(1943)
  -- print("getSpellCD rup = "..duration)
  -- print("gcd br = "..gcd)
  --if stealthingRogue then print(br.player.buff.subterfuge.remain()) end
  --if asd then MouselookStop() end
  dotHPLimit = getOptionValue("Dots HP Limit") * 10000
  local forceenvstealth = false
  local sSActive
  if trait.shroudedSuffocation.active then
    sSActive = 1
  else
    sSActive = 0
  end

  if leftCombat == nil then
    leftCombat = GetTime()
  end
  if profileStop == nil then
    profileStop = false
  end

  
  
  
  --for i = 1, 40 do
  --  --local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer,
  --  --nameplateShowAll = UnitAura ("player", i)
  --  --if name and isCastByPlayer then
  --  --  print(name)
  --  --end
  --  local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitDebuff ("target", i)
  --  if name then
  --    print(spellId)
  --
  --  end
  --end
  
  --if br.selftracker == nil and br.player["spell"].debuffs ~= nil then
  --  br.selftracker = {}
  --  for i = 1, #br.player.debuffs do
  --    br.selftracker[i] = br.player.debuffs[i]
  --  end
  --end
--local tracker = br.selftracker
  
    --______________________________________
    enemies.get(20,nil,nil,nil,spell.blind)
    enemies.get(20,"player",true,nil,spell.blind)
    enemies.get(30,nil,nil,nil,spell.poisonedKnife)
    enemies.get(10)
    
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
    
    local function ttd(unit)
      if UnitIsPlayer(unit) then
        return 999
      end
      local ttdSec = getTTD(unit)
      if getOptionCheck("Enhanced Time to Die") then
        return ttdSec
      end
      if ttdSec == -1 then
        return 999
      end
      return ttdSec
    end
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function clearTable(t)
      local count = #t
      for i = 0, count do
        t[i] = nil
      end
    end

    clearTable(enemyTable5)
    clearTable(enemyTable10)
    clearTable(enemyTable30)
    local deadlyPoison10 = true
    local hasCTaoe = 0
    local fokIgnore = {
                [120651]=true, -- Explosive
                -- [136330]=true, -- Soul Thorns Waycrest Manor
                -- [134388]=true -- A Knot of Snakes ToS
            }
    if #enemies.yards30 > 0 then
        local highestHP
        local lowestHP
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if (not noDotCheck(thisUnit) or GetUnitIsUnit(thisUnit, "target")) and not UnitIsDeadOrGhost(thisUnit) and (mode.cleave == 1 or GetUnitIsUnit(thisUnit, "target")) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                if IsSpellInRange(GetSpellInfo(1766), enemyUnit.unit) == 1 then
                  enemyUnit.distance = 5
                elseif CheckInteractDistance(enemyUnit.unit, 2) then
                  enemyUnit.distance = 10
                elseif IsSpellInRange(GetSpellInfo(2094), enemyUnit.unit) == 1 then
                  enemyUnit.distance = 15
                else
                  enemyUnit.distance = 30
                end
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
         --vend score
        if #enemyTable30 > 1 then
            for i = 1, #enemyTable30 do
                local thisUnit = enemyTable30[i]
                local hpNorm = (10-1)/(highestHP-lowestHP)*(thisUnit.hpabs-highestHP)+10 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0/0) then hpNorm = 0 end -- NaN check
                local enemyScore = hpNorm
                if thisUnit.ttd > 1.5 then enemyScore = enemyScore + 5 end
                if thisUnit.distance <= 5 then enemyScore = enemyScore + 30 end
                -- if garroteList[thisUnit.objectID] ~= nil then enemyScore = enemyScore + 50 end
                -- if GetUnitIsUnit(thisUnit.unit, "target") then enemyScore = enemyScore + 100 end
                local raidTarget = GetRaidTargetIndex(thisUnit.unit)
                if raidTarget ~= nil then
                    enemyScore = enemyScore + raidTarget * 3
                    if raidTarget == 8 then enemyScore = enemyScore + 5 end
                end
                if cd.vendetta.remain() >= 100 then
                  if debuff.vendetta.exists(thisUnit.Unit) then enemyScore = enemyScore + 50 end -- vendetta score
                end
                if talent.toxicBlade and cd.toxicBlade.remain() >= 16 then
                  if debuff.toxicBlade.exists(thisUnit.Unit) then enemyScore = enemyScore + 40 end -- tb score
                end
                if talent.subterfuge and stealthingAll and UnitCastingInfo(thisUnit.Unit) then
                  local notinterruptible, spellidgarrote = select(8, UnitCastingInfo(thisUnit.Unit))
                  if not notinterruptible then enemyScore = enemyScore + 50 end
                end
                thisUnit.enemyScore = enemyScore

            end
            table.sort(enemyTable30, function(x,y)
                return x.enemyScore > y.enemyScore
            end)
        end
        for i = 1, #enemyTable30 do
            local thisUnit = enemyTable30[i]
            if thisUnit.distance <= 10 then
                if fokIgnore[thisUnit.objectID] == nil and not isTotem(thisUnit.unit) then
                  if deadlyPoison10 and not debuff.deadlyPoison.exists(thisUnit.unit) then deadlyPoison10 = false end
                  tinsert(enemyTable10, thisUnit)
                end
                if talent.crimsonTempest then
                  local hasCT = UnitDebuffID(thisUnit.unit, 121411, "player")
                  if hasCT then
                    hasCTaoe = hasCTaoe + 1
                  end
                end                
                if thisUnit.distance <= 5 then
                    tinsert(enemyTable5, thisUnit)
                end
            end
        end
      --print(hasCTaoe)
      if #enemyTable5 > 1 then
        -- if mode.special == 1 then
        -- table.sort(enemyTable5, function(x,y)
        --     return x.ttd > y.ttd
        -- end)
        for i = 1, #enemyTable5 do
          if enemyTable5.highestTTDUnit == nil or enemyTable5.highestTTD < enemyTable5[i].ttd then
            enemyTable5.highestTTDUnit = enemyTable5[i].unit
            enemyTable5.highestTTD = enemyTable5[i].ttd
          end
        end
        -- end
        
        table.sort(enemyTable5,function(x)
            if GetUnitIsUnit(x.unit, "target") and x.ttd > 15 then
              return true
            else
              return false
            end
          end
          )
        if isChecked("Auto Target") and inCombat and (UnitIsDeadOrGhost("target") or not GetUnitExists("target")) then
          TargetUnit(enemyTable5[1].unit)
        end
        -- table.sort(
        --         enemyTable5,
        --         function(x)
        --           if UnitBuffID(x.unit, 79140) then
        --             return true
        --           else
        --             return false
        --           end
        --         end
        -- )
      end
    end
    --Just nil fixes
    if enemyTable30.lowestTTD == nil then
      enemyTable30.lowestTTD = 999
    end
    if enemyTable5.highestTTD == nil then
      enemyTable5.highestTTD = 0
    end
    local enemies10 = #enemyTable10
    local enemies5 = #enemyTable5
    -- if isChecked("Ignore dontdot for fok") then
    --     enemies10 = #enemies.get(10)
    -- end
    
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    -- local function maRemain()
    --   if buff.masterAssassin.remain() < 0 then
    --     return gcd + 3
    --   else
    --     return buff.masterAssassin.remain()
    --   end
    -- end
    
    local function bleedscount()
      local counter = 0
      for k, v in pairs(br.enemy) do
        local thisUnit = br.enemy[k].unit
        local poison =
        UnitDebuffID(thisUnit, 2818, "player")
        local bleed = UnitDebuffID(thisUnit, 703, "player") or UnitDebuffID(thisUnit, 1943, "player")
        if UnitExists(thisUnit) then
          if poison and bleed then
            counter = counter + 1
          end
        end
      end
      return tonumber(counter)
    end
    --if ssbug == nil then ssbug = 0 end
    -- local function viabletargetcount()
    --     local counter = 0
    --     for i = 1, #enemies.yards5 do
    --                 local thisUnit = enemies.yards5[i]
    --                 if UnitHealth(thisUnit) > dotHPLimit and donotdot(thisUnit) then
    --                     counter = counter + 1
    --                 end
    --     end
    --     return tonumber(counter)
    -- end
    --if #enemies.yards9 < 2 then singleTarget = true else singleTarget = false end
    --local bleeds = debuff.garrote.count() + debuff.rupture.count()
    --Energy_Regen_Combined = energy.regen+poisoned_bleeds*7%(2*spell_haste);
    -- local energyregen1 = powerRegen + (bleedscount() * 7 / (2 * (GetHaste()/100)))
    --print(bleedscount)
    
    --local energyRegenCombined = energyRegen + bleedscount * 7 % (2 * (1 - GetHaste()/100))
    -- 7%(2*spell_haste)
    local energyRegenCombined = energyRegen + ((debuff.garrote.count() + debuff.rupture.count()) * 7 / (2 * (1 / (1 + (GetHaste()/100)))))
    -- print("gethaste ="..GetHaste())
    -- print("energyRegen ="..energyRegen)
    -- print("bleedscount ="..bleedscount)
    -- print("energyRegenCombined ="..energyRegenCombined)
    -- print("________________________________________________________")
    local function customTTM()
      local max = UnitPowerMax("player")
      local curr = UnitPower("player")
      local curr2 = curr
      return (max - curr2) / energyRegenCombined
    end
    -- if energyDeficit > 0 then
    --     print("br TTM = "..ttm)
    --     print("cu TTM = "..customTTM())
    -- end
    local ttm = customTTM()

    --bindings
    local spread = false
    if GetKeyState(0x10) and ttm > 2 then
      ChatOverlay("Spreading Mode")
      spread = true
    end
    if GetKeyState(0x12) then
      ChatOverlay("Spending energy")
      ttm = 0
    end

    --cds after workaround    
    local usecds = false 

    if mode.special == 1 then
      if mode.cdafter == 2 and energyRegenCombined >= 30 then
        usecds = true
      else
        usecds = true
      end
    end

    -- print(ttm)
    --print(spread)
    -- print("regen my"..energyRegenCombined)
    --local energyRegenCombined = powerRegen + bleedscount() * 7 / (2*(1 / (1 + (GetHaste() / 100))))
    local BleedTickTime,
    ExsanguinatedBleedTickTime = 2 / (1 + (GetHaste()/100)), 1 / (1 + (GetHaste()/100))
    --print(ExsanguinatedBleedTickTime)
    local shouldCTaoe = false
    if enemies10 - hasCTaoe > 0.5 * enemies10 and enemies10 >= 4 then
      shouldCTaoe = true
    end
    if mode.opener == 2 or opener == nil then
      RUP1 = false
      GAR1 = false
      VEN1 = false
      MUTI1 = false
      RUP2 = false
      EXS1 = false
      VAN1 = false
      VANGAR = false
      pulled = true
      opener = false
      if isChecked("Opener refresh") then
        toggle("Opener", 1)
      end
    end
    
    -- if ssbuggy ~= nil then
    -- print(ssbuggy)
    -- end
    -- if ssbuggytime ~= nil then
    --     if GetTime() >= ssbuggytime + ssbuggytime1
    --         then ssbug = 0
    --     end
    -- end
    -- local function ngs()
    --         local counter = 0
    --         for i = 1, #enemies.yards40 do
    --                     local thisUnit = enemies.yards40[i]
    --                     if debuff.garrote.applied(thisUnit) > 1 and debuff.garrote.exists(thisUnit) then
    --                         counter = counter + 1
    --                     end
    --         end
    --     return tonumber(counter)
    -- end
    -- print(ngs())
    --if ngs() == 0 then ssbug = false end
    --if getCombatTime() == 0 or cast.last.vanish() then garrotecountbuff = debuff.garrote.remainCount(1) end
    -- local function waitshit()
    --     if (mode.special == 2 and (not isBoss() or isDummy())) or mode.special == 1 then
    --          return true
    --     else
    --         return false
    --     end
    -- end
    -- function dotrangelos()
    -- local function drawHealers(healer)
    -- local LibDraw                   = LibStub("LibDraw-1.0")
    -- local facing                    = ObjectFacing("player")
    -- local playerX, playerY, playerZ = GetObjectPosition("player")
    -- local locateX, locateY, locateZ = GetObjectPosition(healer)
    -- local healerX, healerY, healerZ = GetObjectPosition(healer)
    -- if getLineOfSight("player",healer) then
    --     LibDraw.SetColor(0, 255, 0)
    -- else
    --     LibDraw.SetColor(255, 0, 0)
    -- end
    --     return LibDraw.Line(playerX, playerY, playerZ, healerX, healerY, healerZ)
    -- end
    -- for i = 1, #br.friend do
    --     local thisUnit = br.friend[i].unit
    --         if not GetUnitIsUnit(thisUnit,"player") and  UnitGroupRolesAssigned(thisUnit) == "HEALER" then
    --             drawHealers(thisUnit)
    --         end
    --     end
    -- end
    local dontdot = {
      [134503] = true, -- small adds on vel'
      [120651] = true, -- explosive orb
      [141851] = true, -- ghuunies
      [138530] = true -- 1st uldirboss blob small ?
      --[144081] = true, -- dummy test
    }
    local function donotdot(unit)
      if dontdot[GetObjectID(unit)] or UnitHealth(unit) <= dotHPLimit then
        return false
      else
        return true
      end
    end
    local function viabletargetcount()
      local counter = 0
      for i = 1, enemies5 do
        local thisUnit = enemyTable5[i].unit
        if UnitHealth(thisUnit) > dotHPLimit and donotdot(thisUnit) then
          counter = counter + 1
        end
      end
      return tonumber(counter)
    end
    local viabletargetcount = viabletargetcount()
    local function canvangar()
      local counter = 0
      for i = 1, enemies5 do
        local thisUnit = enemyTable5[i].unit
        if donotdot(thisUnit) and debuff.garrote.remain(thisUnit) <= 5.4 and not debuff.garrote.exsang(thisUnit) then
          counter = counter + 1
        end
      end
      return tonumber(counter)
      --if tonumber(counter) >= 3 then return true else return false end
    end
    local canvangar = canvangar()
    local function fokcccheck()
      if getOptionCheck("Don't break CCs") then
        for i = 1, #enemyTable10 do
          local thisUnit = enemyTable10[i].unit
          if isLongTimeCCed(thisUnit) then
            return false
          end
        end
      end
      return true
    end
    
    --print(donotdot("target"))
    --     local function Evaluate_Garrote_Target(unit)
    --   return TargetUnit:DebuffRefreshableP(S.Garrote, 5.4)
    --     and (TargetUnit:PMultiplier(S.Garrote) <= 1 or TargetUnit:DebuffRemainsP(S.Garrote) <= (HL.Exsanguinated(TargetUnit, "Garrote") and ExsanguinatedBleedTickTime or BleedTickTime) and EmpoweredDotRefresh())
    --     and (not HL.Exsanguinated(TargetUnit, "Garrote") or TargetUnit:DebuffRemainsP(S.Garrote) <= 1.5 and EmpoweredDotRefresh())
    --     and Rogue.CanDoTUnit(TargetUnit, GarroteDMGThreshold);
    -- end
    --local lowestDot = debuff.garrote.lowest(5,"remain")
    local function showviable()
      if GetUnitExists("target") and not UnitIsDeadOrGhost("target") then
        for i = 1, #br.om do
          local thisUnit = br.om[i]
          --print(thisUnit.unit)
          if donotdot(thisUnit.unit) and ttd(thisUnit.unit) >= 5 then
            -- then
            local tX,
            tY,
            tZ = GetObjectPosition(thisUnit.unit)
            local playerX,
            playerY,
            playerZ = GetObjectPosition("player")
            if tX and tY then
              if (getDistance(thisUnit.unit) > 5 and getDistance(thisUnit.unit) < 10) or (not getFacing("player", thisUnit.unit) and getDistance(thisUnit.unit) < 5) then
                LibDraw.SetColorRaw(1, 0, 0, 1)
                LibDraw.Circle(tX, tY, playerZ, 1)
              end
            end
          end
        end
      end
    end
    -- if isChecked("Show hitbox+back") then
    --     if GetUnitExists("target") and not UnitIsDeadOrGhost("target") then
    --         local LibDraw = LibStub("LibDraw-1.0")
    --         local playerX, playerY, playerZ = GetObjectPosition("player")
    --         local tX,tY,tZ = GetObjectPosition("target")
    --         local combatReachUnit = max(1.5, UnitCombatReach("target"))
    --         local combatRange = max(6, UnitCombatReach("player") + combatReachUnit + 1.3)
    --         if DrawTime == nil then DrawTime = GetTime() end
    --         if tX and tY then
    --             LibDraw.clearCanvas()
    --                     LibDraw.Circle(tX, tY, playerZ, combatRange)
    --         end
    --     end
    -- end
    
    local function startaa()
      for i = 1, enemies5 do
        if not getFacing("player", "target") then
          local thisUnit = enemyTable5[i].unit
          local firsttarget = GetObjectWithGUID(ObjectGUID("target"))
          -- CastSpellByID(6603,thisUnit)
          -- CastSpellByID(6603,firsttarget)
          --CastSpellByID(6603,thisUnit)
          if cast.auto(thisUnit) then
          end
          if cast.auto(firsttarget) then
          end
        end
      end
    end
    --local function EmpoweredDotRefresh()
    --    return #enemies.get(9) >= 3 + (trait.shroudedSuffocation.active and 1 or 0)
    --end
    
    SLASH_SPECIAL1 = "/bursterino"
    SlashCmdList["SPECIAL"] = function(msg)
      if mode.special == 2 then
        if toggle("Special", 1) then
          return true
        end
      end
    end
    
    -- SLASH_SPECIAL2 = "/shadowsteperino"
    -- SlashCmdList["SPECIAL"] = function(msg)
    --     local cd = GetSpellCooldown(36554)
    --     if cd == 0 then
    --         local face = ObjectFacing("Player");
    --         if cast.shadowstep("target") then C_Timer.After(.13, function() FaceDirection(face, true); end); return true end
    --     end
    -- end
    local function forceenvenom()
      if mode.van2 == 2 and mode.van1 == 2 then
        for i = 1, enemies5 do
          local thisUnit = enemyTable5[i].unit
          if debuff.vendetta.exists(thisUnit) or 
            --enemies10 >= 2 or
            talent.toxicBlade and debuff.toxicBlade.exists(thisUnit) or
            talent.elaboratePlanning and buff.elaboratePlanning.exists() and buff.elaboratePlanning.remain() <= 0.3 or
            --energyDeficit <= energyRegenCombined or
            talent.exsanguinate and (debuff.garrote.exsang(thisUnit) or (debuff.rupture.exsang(thisUnit) and debuff.rupture.remain(thisUnit) <= 2)) 
            or viabletargetcount == 1 and debuff.garrote.remain(thisUnit) <= 2 and cd.garrote.remain() <= gcd
          then
            if cast.envenom(thisUnit) then
              if isChecked("Debug") then
                print("force envenom 5y")
              end
              return true
            end
          end
        end
      end
      
        -- if debuff.vendetta.exists("target") or --or debuff.rupture.exsang(units.dyn5)
        --     talent.toxicBlade and debuff.toxicBlade.exists("target") or
        --     talent.elaboratePlanning and buff.elaboratePlanning.exists() and buff.elaboratePlanning.remain() <= 0.3 or
        --     energyDeficit <= 25 + energyRegenCombined or
        --     talent.exsanguinate and (debuff.garrote.exsang("target") or (debuff.rupture.exsang("target") and debuff.rupture.remain("target") <= 2)) or
        --     isChecked("No Pooling") or
        --     enemies10 >= 2 or
        --     solo
        --   then
        --   --and getFacing("player", thisUnit)
        --   if cast.envenom("target") then
        --     if isChecked("Debug") then
        --       print("force envenom")
        --     end
        --     return true
        --   end
        -- end
    end
    
    local ctoverenvenom = false
    local fokoverfinisher = false
    if isChecked("Prefer fok over finisher when energy positive") or isChecked("Check for finisher on aoe") then
      local dsmod = 1
      if talent.DeeperStratagem then
        dsmod = 1.05
      end
      local wdpsCoeff = 6
      local ap = UnitAttackPower("player")
      local minDamage,
      maxDamage,
      minOffHandDamage,
      maxOffHandDamage,
      physicalBonusPos,
      _,
      percent = UnitDamage("player")
      local speed,
      _ = UnitAttackSpeed("player")
      -- if useOH and offhandSpeed then
      --     local wSpeed = offhandSpeed * (1 + GetHaste() / 100)
      --     local wdps = (minOffHandDamage + maxOffHandDamage) / wSpeed / percent - ap / wdpsCoeff
      -- getapdmg = (ap + wdps * wdpsCoeff) * 0.5
      -- else
      local wSpeed = speed * (1 + GetHaste() / 100)
      local wdps = (minDamage + maxDamage) / 2 / wSpeed / percent - ap / wdpsCoeff
      local getapdmg = ap + wdps * wdpsCoeff
      -- end
      -- end
      local auramult = 1.27
      local masterymult = (1 + (GetMasteryEffect("player") / 100))
      local versmult = (1 + (GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100)
      local ctcoef = 0.036
      local envcoef = 0.16
      local fokcoef = 0.205
      local getctinitial = getapdmg * (combo + 1) * ctcoef * versmult * masterymult * auramult * enemies10
      --print(getctinitial)
      local getenvdamage = getapdmg * combo * envcoef * auramult * dsmod * masterymult * versmult
      if getctinitial >= getenvdamage then
        ctoverenvenom = true
      end
      local getfokdamage = (getapdmg * fokcoef * auramult * versmult + 358 + 519 + 519) * enemies10  --* --[[epmod *]] enemies10
      -- print(getfokdamage)
      if ((getfokdamage >= getctinitial and talent.crimsonTempest) or (getfokdamage >= getenvdamage and not talent.crimsonTempest)) and energyRegenCombined >= 30 and mode.cleave == 1 and not spread then
        fokoverfinisher = true
        -- print(fokoverfinisher)
      end
    end
    
    local function burnpool()
      for i = 1, enemies5 do
        local thisUnit = enemyTable5[i].unit
        if GetObjectID(thisUnit) == 120651 or GetObjectID(thisUnit) == 141851 then --and getFacing("player", thisUnit)
          if combo >= 4 or getenvdamage(thisUnit) >= UnitHealth(thisUnit) then
            if cast.pool.envenom() then
              ChatOverlay("Pooling For env  adds")
              return true
            end
            if cast.envenom(thisUnit) then
              if isChecked("Debug") then
                print("env burn targets")
              end
              return true
            end
          else
            if cast.pool.mutilate() then
              ChatOverlay("Pooling For mutilate adds")
              return true
            end
            if cast.mutilate(thisUnit) then
              if isChecked("Debug") then
                print("muti burn targets")
              end
              return true
            end
          end
        end
      end
    end
    
    -- local function poolcast(spell,unit)
    --     if cast.pool[spell] then return true end
    --     if CastSpellByID(spell,unit) then return end
    -- end
    
    -- local function usefiller()
    --     -- return ((comboDeficit > 1 and debuff.garrote.remain("target") > 4) or powerDeficit <= 25 + energyRegenCombined or not singleTarget) and true or false
    --     return (comboDeficit > 1 or powerDeficit <= 25 + energyRegenCombined) and true or false
    -- end
    
    -- local function bfrange()
    --     if talent.acrobaticStikes then return #enemies.get(9) end
    --     else return #enemies.get(6) end
    -- end
    
    --if leftCombat == nil then leftCombat = GetTime() end
    --if vanishTime == nil then vanishTime = GetTime() end
    
    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
    --[[local function actionList_Extras()
          end -- End Action List - Extras]]
    -- Action List - DefensiveModes
    local function actionList_Defensive()
      SLASH_FEINT1 = "/feinterino"
      SlashCmdList["FEINT"] = function(_)
        if not buff.feint.exists() or (buff.feint.exists() and buff.feint.remain() <= 0.8) or isDeBuffed("player", 230139) and mode.feint == 2 then
          if toggle("Feint", 1) then
            return true
          end
        end
      end
      -- Feint
      if mode.feint == 1 and not buff.feint.exists() then
        if cast.feint() and toggle("Feint", 2) then
          return true
        end
      end
      
      if not stealth then
        -- Health Pot/Healthstone
        if isChecked("Healing Potion/Healthstone") and php <= getOptionValue("Healing Potion/Healthstone") and inCombat and (hasHealthPot() or hasItem(5512)) then
          if canUse(5512) then
            useItem(5512)
          elseif canUse(healPot) then
            useItem(healPot)
          end
        end
        -- Crimson Vial
        if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
          if cast.crimsonVial() then
            return true
          end
        end
        -- Feint
        if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() then
          if cast.feint() then
            return true
          end
        end
        -- Evasion
        if isChecked("Evasion") and php <= getOptionValue("Evasion") and inCombat then
          if cast.evasion() then
            return
          end
        end
      end
    end -- End Action List - Defensive
    
    local function actionList_Stealthed()
      --# Nighstalker, or Subt+Exsg on 1T: Snapshot Rupture
      --actions.stealthed=rupture,if=combo_points>=4&(talent.nightstalker.enabled|talent.subterfuge.enabled&(talent.exsanguinate.enabled&cooldown.exsanguinate.remains<=2|!ticking)&variable.single_target)&target.time_to_die-remains>6
      if
      combo >= 4 and (talent.nightstalker or (talent.subterfuge and (talent.exsanguinate and mode.special == 1 and cd.exsanguinate.remain() <= 2 or not debuff.rupture.exists("target"))) and viabletargetcount == 1) and
              ttd("target") > 6
      then
        if cast.rupture() then
          if isChecked("Debug") then
            print("rupt ns/exsa")
          end
          return true
        end
      end
      
      if talent.subterfuge then
        -- # Subterfuge: Apply or Refresh with buffed Garrotes
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&refreshable&target.time_to_die-remains>2
        if mode.cleave == 1 then
          for i = 1, enemies5 do
            local thisUnit = enemyTable5[i].unit
            local garroteRemain = debuff.garrote.remain(thisUnit)
            if garroteRemain <= 5.4 and not debuff.garrote.exsang(thisUnit) and enemyTable5[i].ttd - garroteRemain > 2 and donotdot(thisUnit) then
              --and getFacing("player", thisUnit)
              if cast.garrote(thisUnit) then
                if isChecked("Debug") then
                  print("stealthed apl Apply or Refresh with buffed Garrotes" .. buff.subterfuge.remain() .. " left on subt")
                end
                return true
              end
            end
          end
        else
          local garroteRemain = debuff.garrote.remain("target")
          if garroteRemain <= 5.4 and not debuff.garrote.exsang("target") and ttd("target") - garroteRemain > 2 and donotdot("target") then
            --and getFacing("player", thisUnit)
            if cast.garrote("target") then
              if isChecked("Debug") then
                print("stealthed apl Apply or Refresh with buffed Garrotes target")
              end
              return true
            end
          end
        end
        -- # Subterfuge: Override older non-pandemic Garrotes as second prio
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&remains<=10&target.time_to_die-remains>2
        if mode.cleave == 1 then
          for i = 1, enemies5 do
            local thisUnit = enemyTable5[i].unit
            local garroteRemain = debuff.garrote.remain(thisUnit)
            if garroteRemain <= 10 and not debuff.garrote.exsang(thisUnit) and enemyTable5[i].ttd - garroteRemain > 2 and donotdot(thisUnit) then
              --and getFacing("player", thisUnit)
              if cast.garrote(thisUnit) then
                if isChecked("Debug") then
                  print("stealthed apl Override older non-pandemic Garrotes as second prio")
                end
                return true
              end
            end
          end
        else
          local garroteRemain = debuff.garrote.remain("target")
          if garroteRemain <= 10 and not debuff.garrote.exsang("target") and ttd("target") - garroteRemain > 2 and donotdot("target") then
            --and getFacing("player", thisUnit)
            if cast.garrote("target") then
              if isChecked("Debug") then
                print("stealthed apl Override older non-pandemic Garrotes as second prio target")
              end
              return true
            end
          end
        end
        -- # Subterfuge + Shrouded Suffocation: Apply early Rupture that will be refreshed for pandemic.
        -- actions.stealthed+=/rupture,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&!dot.rupture.ticking
        if trait.shroudedSuffocation.active and not debuff.rupture.exists("target") and viabletargetcount == 1 then
          if cast.rupture("target") then
            if isChecked("Debug") then
              print("stealthed apl Apply early Rupture that will be refreshed for pandemic target")
            end
            return true
          end
        end
        -- # Subterfuge w/ Shrouded Suffocation: Reapply for bonus CP and extended snapshot duration
        -- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&target.time_to_die>remains&combo_points.deficit>1
        if trait.shroudedSuffocation.active and comboDeficit > 1 then
          if mode.cleave == 1 then
            for i = 1, enemies5 do
              local thisUnit = enemyTable5[i].unit
              local garroteRemain = debuff.garrote.remain(thisUnit)
              if not debuff.garrote.exsang(thisUnit) and enemyTable5[i].ttd > garroteRemain and donotdot(thisUnit) then
                if cast.garrote(thisUnit) then
                  if isChecked("Debug") then
                    print("stealthed apl Reapply for bonus CP and extended snapshot duration")
                  end
                  return true
                end
              end
            end
          else
            local garroteRemain = debuff.garrote.remain("target")
            if not debuff.garrote.exsang("target") and ttd("target") > garroteRemain and donotdot("target") then
              if cast.garrote("target") then
                if isChecked("Debug") then
                  print("stealthed apl Reapply for bonus CP and extended snapshot duration target")
                end
                return true
              end
            end
          end
        end
      end
      -- # Subterfuge + Exsg: Even override a snapshot Garrote right after Rupture before Exsanguination
      -- actions.stealthed+=/pool_resource,for_next=1
      -- actions.stealthed+=/garrote,if=talent.subterfuge.enabled&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&prev_gcd.1.rupture&dot.rupture.remains>5+4*cp_max_spend
      if mode.special == 1 and debuff.garrote.remain(cdtarget) <= 12 and donotdot(cdtarget) and buff.subterfuge.exists("player") and buff.subterfuge.remain("player") <= 1.5 then
        if cast.pool.garrote() then 
          if isChecked("Debug") then
            print("stealthed apl garrote override pool")
          end
          return true end
        if cast.garrote(cdtarget) then
          if isChecked("Debug") then
            print("stealthed apl garrote override")
          end
          return true
        end
      end
    end
    -- Action List - Interrupts
    local function actionList_Interrupts()
      if mode.interrupt == 1 then
        for i = 1, #enemies.yards30 do
          local thisUnit = enemies.yards30[i]
          local distance = getDistance(thisUnit)
          if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
            if distance <= 5 then
              if isChecked("Kick") then
                if cast.kick(thisUnit) then
                  return
                end
              end
              if cd.kick.remain() ~= 0 then
                if combo > 0 and isChecked("Kidneyshot") then
                  if cast.kidneyShot(thisUnit) then
                    return true
                  end
                end
              end
            end
            if distance >= 5 and distance < 25 then
              if isChecked("Blind") then
                if cast.blind(thisUnit) then
                  return true
                end
              end
            end
          end
        end
      elseif mode.interrupt == 2 then
        if canInterrupt("target", getOptionValue("Interrupt At")) then
          if distance <= 5 then
            if isChecked("Kick") then
              if cast.kick("target") then
                return
              end
            end
            if cd.kick.remain() ~= 0 then
              if combo > 0 and isChecked("Kidneyshot") then
                if cast.kidneyShot("target") then
                  return true
                end
              end
            end
          end
          if distance >= 5 and distance < 15 then
            if isChecked("Blind") then
              if cast.blind("target") then
                return true
              end
            end
          end
        end
      end
    end -- End Action List - Interrupts
    local function actionList_Special()
      if mode.van1 == 1 and (not solo or isDummy("target")) then
        -- if debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) < 1.8 and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.remain("target") < 6 and cast.able.vanish() and not cd.garrote.exists() then
        --     if gcd >= 0.5 then return true end
        --     if power <= 70 then return true end
        --     if isChecked("Debug") then print("vanish tb cd") end
        --     if cast.vanish() then
        --         if actionList_Stealthed() then return true end
        --     end
        -- end
        
        if canvangar >= 2 and cd.garrote.remain() == 0 and cd.vanish.remain() == 0 then
          if gcd >= 0.5 then
            ChatOverlay("Pooling gcd For vanish")
            return true
          end
          if energy <= 70 then
            return true
          end
          if cast.vanish() then
            if isChecked("Debug") then
              print("vanish aoe use")
            end
            if actionList_Stealthed() then
              return true
            end
          end
        end
      end
      if mode.van2 == 1 and (not solo or isDummy("target")) then
        -- if debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) < 1.8 and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) and debuff.garrote.remain("target") < 6 and cast.able.vanish() and not cd.garrote.exists() then
        --     if gcd >= 0.5 then return true end
        --     if power <= 70 then return true end
        --     if isChecked("Debug") then print("vanish tb cd") end
        --     if cast.vanish() then
        --         if actionList_Stealthed() then return true end
        --     end
        -- end

        if combo >= 4 and not debuff.garrote.exsang("target") and ((debuff.garrote.applied("target") <= 1 and debuff.garrote.remain("target") <= 6.4) or (debuff.garrote.applied("target") > 1 and debuff.garrote.remain("target") <= 1)) then
          if cast.envenom("target") then
            if isChecked("Debug") then
              print("env pre vanish")
            end
          end
        end
        
        if cd.garrote.remain() == 0 and cd.vanish.remain() == 0 and not debuff.garrote.exsang("target") and debuff.garrote.applied("target") <= 1 and debuff.garrote.remain("target") <= 5.4 then
          forceenvstealth = true
          
          if gcd >= 0.5 then
            ChatOverlay("Pooling gcd For vanish")
            return true
          end
          if energy <= 70 then
            return true
          end
          if cast.vanish() then
            if isChecked("Debug") then
              print("vanish solo use")
            end
            if actionList_Stealthed() then
              return true
            end
          end
        end
      end
      
      if isChecked("Apply Deadly Poison in melee") then
        for i = 1, enemies5 do
          local thisUnit = enemyTable5[i].unit
          if UnitDebuffID(thisUnit, 268756) or ((debuff.garrote.exists(thisUnit) or debuff.rupture.exists(thisUnit)) and not debuff.deadlyPoison.exists(thisUnit)) then
            --print("refresh poison melee")
            local firsttarget = GetObjectWithGUID(ObjectGUID("target"))
            CastSpellByID(6603, thisUnit)
            CastSpellByID(6603, firsttarget)
          end
        end
      end
      
      -- if getDistance(units.dyn5) <= 5 then
      
      --     if not debuff.garrote.exists("target") and comboDeficit >= 2 then
      --         if cast.vanish() then end
      --         if cast.garrote() then return end
      --     end
      -- --pool for vanish
      -- if cd.vendetta.remain() > 0 and cd.exsanguinate.remain() > 0 and not cd.garrote.exists() and ((debuff.garrote.applied("target") > 1 and debuff.garrote.remain("target") < gcd) or not debuff.garrote.exists("target")) and comboDeficit >= 2 then
      --     if debuff.garrote.remain("target") > 0 then return true end
      
      -- end
      
      -- end
      -- if cd.vendetta.remain() > 0 and cd.exsanguinate.remain() > 0 and not cd.garrote.exists() and not debuff.garrote.exists("target") then
      --     if comboDeficit >= 2 and not debuff.garrote.exists() then
      
      -- end
      
      -- if stealthingRogue and debuff.garrote.exists() and combo==ComboMaxSpend() and debuff.rupture.refresh() then
      --     if cast.rupture() then return end
      -- end
      
      -- if stealthingRogue and (cast.last.rupture() or comboDeficit >= 2) then
      --     if cast.garrote() then return end
      -- end
    end
    
    local function actionList_OpenNoVend()
      if not br.player.moving and isChecked("Galecaller") then
        -- use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
        if canUse(13) and hasEquiped(159614, 13) then
          useItem(13)
        end
        if canUse(14) and hasEquiped(159614, 14) then
          useItem(14)
        end
      end
      
      if not RUP1 and cast.able.rupture() then
        if cast.rupture() then
          RUP1 = true
        end
      elseif RUP1 and not GAR1 and cast.able.garrote() then
        if cast.garrote() then
          GAR1 = true
        end
      elseif GAR1 and not VEN1 and cast.able.mutilate() then
        if cast.mutilate() then
          VEN1 = true
        end
      elseif VEN1 and not MUTI1 and cast.able.rupture() then
        if cast.rupture() then
          MUTI1 = true
        end
      elseif MUTI1 and not RUP2 and cast.able.exsanguinate() then
        if cast.exsanguinate() then
          RUP2 = true
        end
        if RUP2 then
          Print("Opener Complete")
          opener = true
          toggle("Opener", 2)
        end
        return
      end
    end
    
    local function actionList_Open()
      --if (opener == false and time < 1) and (isDummy("target") or isBoss("target")) and (cd.vanish > 0 or not buff.shadowBlades.exists()) then Print("Opener failed due do cds"); opener = true end
      if talent.subterfuge then
        if trait.shroudedSuffocation.rank > 0 then
          if talent.exsanguinate then
            if not RUP1 and cast.able.rupture("target") then
              if cast.rupture("target") then
                RUP1 = true
              end
            elseif RUP1 and not GAR1 and cast.able.garrote("target") then
              if cast.garrote("target") then
                GAR1 = true
              end
            elseif GAR1 and not VEN1 and cast.able.vendetta("target") then
              if isChecked("Racial") then
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                  if cast.racial("player") then
                  end
                end
              end
              if canUse(13) then
                useItem(13)
              end
              if canUse(14) then
                useItem(14)
              end
              if cast.vendetta("target") then
                VEN1 = true
              end
            elseif VEN1 and not MUTI1 and cast.able.mutilate("target") then
              if cast.mutilate("target") then
                MUTI1 = true
              end
            elseif MUTI1 and not RUP2 and cast.able.rupture("target") then
              if cast.rupture("target") then
                RUP2 = true
              end
            elseif RUP2 and not EXS1 and cast.able.exsanguinate("target") then
              if cast.exsanguinate("target") then
                EXS1 = true
              end
              if EXS1 then
                Print("Opener Complete")
                opener = true
                toggle("Opener", 2)
              end
              return
            end
          end
          if talent.toxicBlade then
            if not RUP1 and cast.able.rupture() then
              if cast.rupture() then
                RUP1 = true
              end
            elseif RUP1 and not GAR1 and cast.able.garrote() then
              if cast.garrote() then
                GAR1 = true
              end
            elseif GAR1 and not VEN1 and cast.able.vendetta() then
              if isChecked("Racial") then
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                  if cast.racial("player") then
                  end
                end
              end
              if canUse(13) then
                useItem(13)
              end
              if canUse(14) then
                useItem(14)
              end
              if cast.vendetta() then
                VEN1 = true
              end
            elseif VEN1 and not MUTI1 and cast.able.toxicBlade() then
              if cast.toxicBlade() then
                MUTI1 = true
              end
            elseif MUTI1 and not RUP2 and cast.able.envenom() then
              if cast.envenom() then
                RUP2 = true
              end
            elseif RUP2 and not EXS1 and cast.able.mutilate() then
              if cast.mutilate() then
                EXS1 = true
              end
              Print("Opener Complete")
              opener = true
              toggle("Opener", 2)
              return true
            end
          end
        end
        
        if trait.shroudedSuffocation.rank <= 0 then
          if talent.exsanguinate then
            if not RUP1 and cast.able.mutilate() then
              if cast.mutilate() then
                RUP1 = true
              end
            elseif RUP1 and not GAR1 and cast.able.rupture() then
              if cast.rupture() then
                GAR1 = true
              end
            elseif GAR1 and not VEN1 and cast.able.vendetta() then
              if isChecked("Racial") then
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                  if cast.racial("player") then
                  end
                end
              end
              if canUse(13) then
                useItem(13)
              end
              if canUse(14) then
                useItem(14)
              end
              if cast.vendetta() then
                VEN1 = true
              end
            elseif VEN1 and not MUTI1 and cast.able.mutilate() and combo < ComboMaxSpend() - 1 then
              if cast.mutilate() then
              end
            elseif VEN1 and not MUTI1 and combo >= ComboMaxSpend() - 1 then
              MUTI1 = true
            elseif MUTI1 and not RUP2 and cast.able.rupture() then
              if cast.rupture() then
                RUP2 = true
              end
            elseif RUP2 and not VAN1 then
              if gcd >= 0.2 then
                ChatOverlay("Pooling gcd For vanish")
                return true
              end
              if cast.vanish() then
                VAN1 = true
              end
            elseif VAN1 and not VANGAR and cast.able.garrote() then
              if cast.garrote() then
                VANGAR = true
              end
            elseif VANGAR and not EXS1 and cast.able.exsanguinate() then
              if cast.exsanguinate() then
                EXS1 = true
              end
              Print("Opener Complete")
              opener = true
              toggle("Opener", 2)
              return true
            end
          end
          if talent.toxicBlade then
            if combo < 4 and not GAR1 and cast.able.mutilate() then
              if cast.mutilate() then
                RUP1 = true
              end
            elseif not GAR1 and combo >= 4 and cast.able.rupture() then
              if cast.rupture() then
                GAR1 = true
              end
            elseif GAR1 and not VEN1 and cast.able.vendetta() then
              if isChecked("Racial") then
                if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
                  if cast.racial("player") then
                  end
                end
              end
              if canUse(13) then
                useItem(13)
              end
              if canUse(14) then
                useItem(14)
              end
              if cast.vendetta() then
                VEN1 = true
              end
            elseif VEN1 and not MUTI1 and cast.able.mutilate() then
              if cast.mutilate() then
                MUTI1 = true
              end
            elseif MUTI1 and not RUP2 and cast.able.toxicBlade() then
              if cast.toxicBlade() then
                RUP2 = true
              end
              Print("Opener Complete")
              opener = true
              toggle("Opener", 2)
              return true
            end
          end
        end
      end -- subt talent
      
      if talent.masterAssassin then
        if not GAR1 and cast.able.mutilate() then
          if cast.mutilate("target") then
            GAR1 = true
          end
        elseif GAR1 and not RUP1 and cast.able.rupture() then
          if cast.rupture("target") then
            RUP1 = true
          end
        elseif RUP1 and not VEN1 and cast.able.vendetta() then
          if isChecked("Racial") then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
              if cast.racial("player") then
              end
            end
          end
          if canUse(13) then
            useItem(13)
          end
          if canUse(14) then
            useItem(14)
          end
          if cast.vendetta("target") then
            VEN1 = true
          end
        elseif VEN1 and not MUTI1 then
          if gcd >= 0.2 then
            ChatOverlay("Pooling gcd For vanish")
            return true
          end
          if cast.vanish() then
            MUTI1 = true
          end
        elseif MUTI1 and not RUP2 and cast.able.toxicBlade() then
          if cast.toxicBlade("target") then
            RUP2 = true
          end
          Print("Opener Complete")
          opener = true
          toggle("Opener", 2)
          return true
        end
      end -- ma
    end
    -- Action List - Cooldowns
    local function actionList_Cooldowns()
      if cdtarget == nil then      
        if mode.cdtarget == 1 then
          if UnitExists("target") then
            cdtarget = "target"
          end
        else 
          table.sort(
            enemyTable5,
            function(x, y)
              return x.enemyScore > y.enemyScore
            end
          )
          cdtarget = enemyTable5[1].unit
        end
      end
              
      if cdtarget == nil or getDistance(cdtarget) > 5 then return true end

      if isChecked("Racial") and debuff.vendetta.exists(cdtarget) and ttd(cdtarget) > 5 then
        if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "Troll" then
          if cast.racial("player") then
            if isChecked("Debug") then
              print("racial")
            end
            return true
          end
        end
      end
        
      if talent.exsanguinate then
        if not debuff.rupture.exists(cdtarget) and combo >= 2 then
          if cast.rupture(cdtarget) then
            if isChecked("Debug") then
              print("new rupt cd")
            end
            return true
          end
        end
        
        if not debuff.garrote.exsang(cdtarget) and debuff.garrote.applied(cdtarget) <= 1 and debuff.garrote.remain(cdtarget) <= 12 and mode.van1 ~= 1 and mode.van2 ~= 1 then
          if cast.garrote(cdtarget) then
            if isChecked("Debug") then
              print("garrote new cd")
            end
            return true
          end
        end
        
        if cd.exsanguinate.remain() <= 5 and (debuff.garrote.remain(cdtarget) > 10 or debuff.garrote.applied(cdtarget) > 1) and combo >= 4 and debuff.rupture.remain(cdtarget) <= 20 then
          if cast.rupture(cdtarget) then
            if isChecked("Debug") then
              print("rupt before exsa cd")
            end
            return true
          end
        end
        
        if energyDeficit <= 30 and cast.able.vendetta(cdtarget) then
          if isChecked("Trinkets") then
            if canUse(13) then
              useItem(13)
            end
            if canUse(14) then
              useItem(14)
            end
          end
          if cast.vendetta(cdtarget) then
            if isChecked("Debug") then
              print("vendetta power use cd")
            end
            return true
          end
        end
        
        -- if (not solo or isDummy("target")) and not cd.garrote.exists() and (debuff.garrote.applied(GetObjectWithGUID(UnitGUID("target"))) <= 1 or debuff.garrote.remain() <= 5.4) and cast.able.vanish() and not debuff.garrote.exsang(GetObjectWithGUID(UnitGUID("target"))) then
        --     if gcd >= 0.2 then ChatOverlay("Pooling gcd For vanish") return true end
        --     if isChecked("Debug") then print("vanish cd exsa") end
        --     if cast.vanish() then
        --         if actionList_Stealthed() then return true end
        --     end
        -- end
        
        if debuff.garrote.remain(cdtarget) >= 5.4 and debuff.rupture.remain(cdtarget) >= 4 + (4 * comboMax) and (debuff.vendetta.exists(cdtarget) or cd.vendetta.remain() >= 5) then
          if isChecked("Galecaller") then
            -- use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
            if canUse(13) and hasEquiped(159614, 13) then
              useItem(13)
            end
            if canUse(14) and hasEquiped(159614, 14) then
              useItem(14)
            end
          end
          if cast.exsanguinate(cdtarget) then
            if isChecked("Debug") then
              print("exsa cd")
            end
            return true
          end
        end
        
        if cast.able.vendetta(cdtarget) then
          if gcd >= 0.5 then return true end
          if isChecked("Trinkets") then
            if canUse(13) then
              useItem(13)
            end
            if canUse(14) then
              useItem(14)
            end
          end
          if cast.vendetta(cdtarget) then
            if isChecked("Debug") then
              print("vendetta cd")
            end
            return true
          end
        end
        
        if cd.vendetta.remain() >= 5 and cd.exsanguinate.remain() >= 5 then
          toggle("Special", 2)
          cdtarget = nil
        end
      end -- end exsang cds
      if talent.masterAssassin then
        if cast.able.vendetta(cdtarget) then
          if gcd >= 0.5 then return true end
          if isChecked("Vendetta + pot if bloodlust up") and hasBloodLust() then
            if br.player.use.battlePotionOfAgility() then end
          end
          if isChecked("Trinkets") then
            if canUse(13) then
              useItem(13)
            end
            if canUse(14) then
              useItem(14)
            end
          end
          if cast.vendetta(cdtarget) then
            if isChecked("Debug") then
              print("vendetta tb talent cd")
            end
            return true
          end
        end
        
        if cast.toxicBlade(cdtarget) then
          if isChecked("Debug") then
            print("CDS Toxic Blade not spam")
          end
          return true
        end
        
        if (not solo or isDummy("target")) and combo >= 4 and debuff.toxicBlade.exists(cdtarget) and cd.vanish.remain() == 0 then
          if gcd >= 0.5 then
            ChatOverlay("Pooling gcd For vanish")
            return true
          end
          if energy <= 70 then
            return true
          end

          if cast.vanish() then
            StopAttack()
            if isChecked("Debug") then
              print("vanish tb cd")
            end
          end
        end
        
        if cd.vanish.remain() >= 5 and cd.vendetta.remain() >= 5 then
          cdtarget = nil
          toggle("Special", 2)
        end
      end
    end -- end Action List - Cooldowns
    --     if not talent.toxicBlade and isChecked("Toxic Blade on cd") then
    --       if ttd(cdtarget) >= 5 and debuff.rupture.exists(cdtarget) then
    --         if cast.toxicBlade(cdtarget) then
    --           if isChecked("Debug") then
    --             print("CDS Toxic Blade")
    --           end
    --           return true
    --         end
    --       end
    -- end -- End Action List - Cooldowns
    -- Action List - PreCombat
    local function actionList_PreCombat()
      
      local pulled = false
      if isChecked("Respect PullTimer") and _brPullTimer ~= nil and not pulled then
        if GetTime() > _brPullTimer or (GetTime() <= _brPullTimer + 3 and inCombat) then
          if stealth and getDistance("target") <= 5 and (not PullTimerRemain(true) or inCombat) and not pulled then
            if cast.garrote("target") then 
              pulled = true
              print("Garrote on pullTimer")
            return end
          end
        end
      end

      if not inCombat and not stealth then
          if isChecked("Stealth") then
            if getOptionValue("Stealth") == 1 or #enemies.yards20nc > 0 then
                if cast.stealth("player") then end
            end
          end
      end
      
      if ((not inCombat and buff.deadlyPoison.remain("player") <= 600) or not buff.deadlyPoison.exists("player")) and not br.player.moving and (botSpell ~= spell.deadlyPoison or (not botSpellTime or GetTime() - botSpellTime > 2)) then
        if cast.deadlyPoison("player") then return true end
      end
    end -- End Action List - PreCombat
    
    local function actionList_Dot()
      --Rupture anything if no bleeds
      -- if combo >= 1 and not talent.crimsonTempest and
      --     debuff.rupture.count() == 0 and
      --     enemies5 > 0  then
      --     if cast.rupture(enemyTable5[1].unit) then
      --         if isChecked("Debug") then print("dot apl Rupture if no bleeds") end
      --     return end
      -- end
      
      -- # Special Rupture setup for Exsg
      -- actions.dot=rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2)))
      if mode.special == 1 and enemies5 > 0 and enemies10 < 3 and talent.exsanguinate and ((combo >= comboMax and cd.exsanguinate.remain() < 1) or (not debuff.rupture.exists("target") and (combatTime > 10 or combo >= 2))) and ttd("target") > 10
      then
        if cast.rupture("target") then
          if isChecked("Debug") then
            print("dot apl Special Rupture setup for Exsg")
          end
          return true
        end
      end

      if isChecked("Prefer fok over finisher when energy positive") and not spread and trait.echoingBlades.rank >= 1 then
        if fokoverfinisher and enemies10 > 2 and mode.cleave == 1 and fokcccheck()  then
          if cast.fanOfKnives("player") then
            if isChecked("Debug") then
              print("dot apl FoK over finisher")
            end
            return true
          end
        end
      end
      -- # Garrote upkeep, also tries to use it as a special generator for the last CP before a finisher
      -- actions.dot+=/pool_resource,for_next=1
      -- actions.dot+=/garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&
      -- combo_points.deficit>=1&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&
      -- (!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)
      -- &!ss_buffed&(target.time_to_die-remains>4&spell_targets.fan_of_knives<=1|target.time_to_die-remains>12)
      if mode.van1 == 2 and mode.van2 == 2 and enemies5 > 0 then
        if mode.cleave == 1 then
          for i = 1, enemies5 do
            local thisUnit = enemyTable5[i].unit
            local garroteRemain = debuff.garrote.remain(thisUnit)
            if
            (not talent.subterfuge or not (
              cd.vanish.remain() <= 
              gcd and 
              cd.vendetta.remain() <= 4 and mode.special == 1 and (mode.van1 == 1 or mode.van2 == 1))) and comboDeficit >= 1 and garroteRemain <= 5.4 and
                    (debuff.garrote.applied(thisUnit) <= 1 or (garroteRemain <= BleedTickTime and enemies10 >= (3 + sSActive))) and
                    (not debuff.garrote.exsang(thisUnit) or (garroteRemain < ExsanguinatedBleedTickTime and enemies10 >= (3 + sSActive))) and
                    ((enemyTable5[i].ttd - garroteRemain > 4 and enemies10 <= 1) or enemyTable5[i].ttd - garroteRemain > 12) and
                    donotdot(thisUnit)
            then
              if energyRegenCombined <= 40 then
                if cast.garrote(thisUnit) then
                  if isChecked("Debug") then
                    print("dot apl Garrote upkeep")
                  end
                  return true
                end
              end
            end
          end
        else
          local garroteRemain = debuff.garrote.remain("target")
          if
          (not talent.subterfuge or not (cd.vanish.remain() <= gcd and cd.vendetta.remain() <= 4 and mode.special == 1 and (mode.van1 == 1 or mode.van2 == 1))) and comboDeficit >= 1 and garroteRemain <= 5.4 and
                  debuff.garrote.applied("target") <= 1 and
                  not debuff.garrote.exsang("target") and
                  (ttd("target") - garroteRemain) > 4 --[[and enemies10 <= 1]] and
                  donotdot("target")
          then
            if energyRegenCombined <= 25 then
              if cast.pool.garrote() then
                return true
              end
            end
            if cast.garrote("target") then
              if isChecked("Debug") then
                print("dot apl Garrote upkeep target")
              end
              return true
            end
          end
        end
      end

      -- # Crimson Tempest only on multiple targets at 4+ CP when running out in 2s (up to 4 targets) or 3s (5+ targets)
      -- actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4
      if talent.crimsonTempest and mode.cleave == 1 then
        if ((enemies10 >= 2 and debuff.crimsonTempest.remain("target") < 2 + (enemies10 > 5 and 1 or 0)) or shouldCTaoe) and combo >= 4 and fokcccheck() then
          if cast.crimsonTempest("player") then
            if isChecked("Debug") then
              print("dot apl Crimson Tempest at " .. debuff.crimsonTempest.remain("target") .. " targets")
            end
            return true
          end
        end
      end
      -- # Keep up Rupture at 4+ on all targets (when living long enough and not snapshot)
      -- actions.dot+=/rupture,cycle_targets=1,if=combo_points>=4&refreshable&
      -- (pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&
      -- (!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&
      -- target.time_to_die-remains>4
      if enemies5 >= 1 then
        if mode.cleave == 1 then 
          for i = 1, enemies5 do
            local thisUnit = enemyTable5[i].unit
            local ruptureRemain = debuff.rupture.remain(thisUnit)
            if
            ((combo == 4 and ruptureRemain < 6) or (combo == 5 and ruptureRemain < 7.2)) and (debuff.rupture.applied(thisUnit) <= 1 or (ruptureRemain <= BleedTickTime and enemies10 >= (3 + sSActive))) and
                    (not debuff.rupture.exsang(thisUnit) or (ruptureRemain < ExsanguinatedBleedTickTime and enemies10 >= (3 + sSActive))) and
                    (enemyTable5[i].ttd - ruptureRemain) > 4
            then
              if cast.rupture(thisUnit) then
                if isChecked("Debug") then
                  print("dot apl Keep up Rupture at 4+")
                end
                return true
              end
            end
          end
        else
          local ruptureRemain = debuff.rupture.remain("target")
          if ((combo == 4 and ruptureRemain < 6) or (combo == 5 and ruptureRemain < 7.2)) and debuff.rupture.applied("target") <= 1 and 
              (not debuff.rupture.exsang("target") or (ruptureRemain < ExsanguinatedBleedTickTime and enemies10 >= (3 + sSActive))) 
              and (ruptureRemain < 2 or debuff.vendetta.remain("target")) and (ttd("target") - ruptureRemain) > 4 then
            if cast.rupture("target") then
              if isChecked("Debug") then
                print("dot apl Keep up Rupture at 4+ target")
              end
              return true
            end
          end
        end
      end
      --CT USAGE w/o regen stuff
      -- if talent.crimsonTempest and mode.cleave == 1 and #enemyTable5 > 1 then
      --     if ((enemies10 >= 2 and debuff.crimsonTempest.remain() < 2 + (enemies10 > 5 and 1 or 0)) or shouldCTaoe) and bleedscount > 1 and combo >= 4 and fokcccheck() then
      --         if cast.crimsonTempest("player") then
      --             if isChecked("Debug") then print("dot apl Crimson Tempest at noregen "..enemies10.." targets") end
      --         return true end
      --     end
      -- end
    end -- End Action List - Build
    
    local function actionList_Direct()
      
      if mode.cleave == 1 and enemies5 >= 1 and isChecked("Force Envenom") and combo >= 4 and not spread and (cd.toxicBlade.remain() > ttm or not talent.toxicBlade) then forceenvenom() end
      if isChecked("Toxic Blade on cd") and enemies5 >= 1 and not GetKeyState(0x10) and mode.cdafter == 1 then
        if ttd("target") >= 5 and debuff.rupture.exists("target") then
          if cast.toxicBlade("target") then
            if isChecked("Debug") then
              print("cds before tb target")
            end
            return true
          end
        end
      end
      
      
      if isChecked("Check for finisher on aoe") and talent.crimsonTempest and mode.cleave == 1 and enemies10 >= 1 then
        if combo >= 4 and (ctoverenvenom or shouldCTaoe) then
          if cast.crimsonTempest("player") then
            if isChecked("Debug") then
              print("direct apl CT over ENV")
            end
            return true
          end
        end
      end
      
      -- # Envenom at 4+ (5+ with DS) CP. Immediately on 2+ targets, with Vendetta, or with TB; otherwise wait for some energy. Also wait if Exsg combo is coming up.
      -- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
      if enemies5 >= 1 then
        if mode.cleave == 1 and not fokoverfinisher and not spread then
          for i = 1, enemies5 do
            local thisUnit = enemyTable5[i].unit
            if
            combo >= (4 + (talent.DeeperStratagem and 1 or 0)) and
                    (debuff.vendetta.exists(thisUnit) or forceenvstealth --[[or enemyTable5.highestTTD < 25)]] or debuff.toxicBlade.exists(thisUnit) or ttm < 1 or (enemies10 > 1 and mode.cleave == 1)) and
                    (not talent.exsanguinate or mode.special == 2 or (mode.special == 1 and (cd.exsanguinate.remain() > 2 or enemyTable5.highestTTD < 10)))
            then
              if cast.envenom(thisUnit) then
                forceenvstealth = false
                if isChecked("Debug") then
                  print("direct apl Envenom at 4+")
                end
                return true
              end
            end
          end
        else
          if
          combo >= (4 + (talent.DeeperStratagem and 1 or 0)) and ((debuff.vendetta.exists("target") or ttd("target") < 15) or debuff.toxicBlade.exists(thisUnit) or ttm < 1) and
                  (not talent.exsanguinate or mode.special == 2 or cd.exsanguinate.remain() > 2 or ttd("target") < 8) and not spread
          then
            if cast.envenom("target") then
              if isChecked("Debug") then
                print("direct apl Envenom at 4+ target")
              end
              return true
            end
          end
        end
      end
      --actions.direct+=/variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target
      local usefiller = comboDeficit > 1 or ttm < 1 or (enemies10 > 1 and mode.cleave == 1)
      local usefillerfok = (comboDeficit > 1 or ttm < 1) and (enemies10 >= 1 and mode.cleave == 1)
      -- # With Echoing Blades, Fan of Knives at 2+ targets.
      -- actions.direct+=/fan_of_knives,if=variable.use_filler&azerite.echoing_blades.enabled&spell_targets.fan_of_knives>=2
      if usefillerfok and mode.cleave == 1 and trait.echoingBlades.active and enemies10 >= 2 then
        if cast.fanOfKnives("player",nil,1,10) then
          if isChecked("Debug") then
            print("direct apl With Echoing Blades, Fan of Knives at 2+ targets")
          end
          return true
        end
      end
      -- # Fan of Knives at 19+ stacks of Hidden Blades or against 4+ (5+ with Double Dose) targets.
      -- actions.direct+=/fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|spell_targets.fan_of_knives>=4+(azerite.double_dose.rank>2)+stealthed.rogue)
      if usefillerfok and mode.cleave == 1 and fokcccheck() and (buff.hiddenBlades.stack() >= 19 or enemies10 >= 4 + (trait.doubleDose.rank > 2 and 1 or 0) + (stealthingRogue and 1 or 0)) then
        if cast.fanOfKnives("player",nil,1,10) then
          if isChecked("Debug") then
            print("direct apl Fan of Knives at 19+ stacks ")
          end
          return true
        end
      end
      -- # Fan of Knives to apply Deadly Poison if inactive on any target at 3 targets.
      -- actions.direct+=/fan_of_knives,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives>=3
      if usefillerfok and mode.cleave == 1 and enemies10 >= 3 and fokcccheck() and not deadlyPoison10 then
        if cast.fanOfKnives("player",nil,1,10) then
          if isChecked("Debug") then
            print("direct apl Fan of Knives to apply Deadly Poison")
          end
          return true
        end
      end
      -- actions.direct+=/blindside,if=variable.use_filler&(buff.blindside.up|!talent.venom_rush.enabled&!azerite.double_dose.enabled)
      if mode.cleave == 1 then
        for i = 1, enemies5 do
          local thisUnit = enemyTable5[i].unit
          if usefiller and (buff.blindside.exists() or ((not talent.venomRush or not trait.doubleDose.active) and getHP(thisUnit) < 30)) then
            if cast.blindside(thisUnit) then
              if isChecked("Debug") then
                print("direct apl blindside aoe")
              end
              return true
            end
          end
        end
      else
        if usefiller and (buff.blindside.exists() or ((not talent.venomRush or not trait.doubleDose.active) and getHP("target") < 30)) then
          if cast.blindside("target") then
            if isChecked("Debug") then
              print("direct apl blindside target")
            end
            return true
          end
        end
      end
      -- # Tab-Mutilate to apply Deadly Poison at 2 targets
      -- actions.direct+=/mutilate,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives=2
      if usefiller and enemies5 == 2 and mode.cleave == 1 then
        for i = 1, #enemyTable5 do
          local thisUnit = enemyTable5[i].unit
          if not debuff.deadlyPoison.exists(thisUnit) then --and getFacing("player", thisUnit)
            if cast.mutilate(thisUnit) then
              if isChecked("Debug") then
                print("direct apl Tab-Mutilate to apply Deadly Poison at 2 targets")
              end
              return true
            end
          end
        end
      end
      --muti
      if usefiller and enemies5 > 0 then
        if mode.cleave == 1 then
          for i = 1, enemies5 do
            local thisUnit = enemyTable5[i].unit
            if not isLongTimeCCed(thisUnit) then
              if cast.mutilate(thisUnit) then
                --print(enemies10)
                if isChecked("Debug") then
                  print("direct apl muti")
                end
                return true
              end
            end
          end
        else
          if not isLongTimeCCed("target") then
            if cast.mutilate("target") then
              if isChecked("Debug") then
                print("direct apl target")
              end
              return true
            end
          end
        end
      end
      if usefillerfok and enemies10 > 1 and enemies5 == 0 then
        if cast.fanOfKnives("player",nil,1,10) then
          if isChecked("Debug") then
            print("direct apl Fan of Knives range")
          end
          return true
        end 
      end

    end -- End Action List - Finishers
    -- Action List - Mythic Stuff
    local function actionList_Stun()
      local stunList = {
        -- Stolen from feng pala
        [274400] = true,
        [274383] = true,
        [257756] = true,
        [276292] = true,
        [268273] = true,
        [256897] = true,
        [272542] = true,
        [272888] = true,
        [269266] = true,
        [258317] = true,
        [258864] = true,
        [259711] = true,
        [258917] = true,
        [264038] = true,
        [253239] = true,
        [269931] = true,
        [270084] = true,
        [270482] = true,
        [270506] = true,
        [270507] = true,
        [267433] = true,
        [267354] = true,
        [268702] = true,
        [268846] = true,
        [268865] = true,
        [258908] = true,
        [264574] = true,
        [272659] = true,
        [272655] = true,
        [267237] = true,
        [265568] = true,
        [277567] = true,
        [265540] = true
      }
      for i = 1, #enemyTable30 do
        local thisUnit = enemyTable30[i].unit
        local distance = enemyTable30[i].distance
        if (isChecked("AutoKidney") and distance <= 5 and combo > 0) or isChecked("AutoBlind") and distance <= 15 then
          local interruptID,
          castStartTime
          if UnitCastingInfo(thisUnit) then
            castStartTime = select(4, UnitCastingInfo(thisUnit))
            interruptID = select(9, UnitCastingInfo(thisUnit))
          elseif UnitChannelInfo(thisUnit) then
            castStartTime = select(4, UnitChannelInfo(thisUnit))
            interruptID = select(7, GetSpellInfo(UnitChannelInfo(thisUnit)))
          end
          if interruptID ~= nil and stunList[interruptID] and (GetTime() - (castStartTime / 1000)) > 0.1 then
            if cast.kidneyShot(thisUnit) then
              return true
            end
          end
          if interruptID ~= nil and stunList[interruptID] and (GetTime() - (castStartTime / 1000)) > 0.1 and (distance > 5 or cd.kidneyShot.remain() > 1.5) then
            if cast.blind(thisUnit) then
              return true
            end
          end
        end
      end
    end
    
      local function MythicStuff()
        local cloakPlayerlist = {}
        
        local evasionPlayerlist = {[256106] = true}
        
        local cloaklist = {}
        
        local evasionlist = {}
        
        local feintlist = {}

        local vanishList = {
          
        }
        
        if eID then
            -- print(eID)
            local bosscount = 0
            for i = 1, 5 do
                if GetUnitExists("boss" .. i) then
                  bosscount = bosscount + 1
                end
            end
            for i = 1, bosscount do
                local spellname, castEndTime,interruptID, spellnamechannel, castorchan, spellID
                thisUnit = tostring("boss" .. i)
                if UnitCastingInfo(thisUnit) then
                    spellname = UnitCastingInfo(thisUnit)
                    -- castStartTime = select(4,UnitCastingInfo(thisUnit)) / 1000
                    castEndTime = select(5, UnitCastingInfo(thisUnit)) / 1000
                    interruptID = select(9,UnitCastingInfo("target"))
                    castorchan = "cast"
                elseif UnitChannelInfo(thisUnit) then
                    spellname = UnitChannelInfo(thisUnit)
                    -- castStartTime = select(4,UnitChannelInfo(thisUnit)) / 1000
                    castEndTime = select(5,UnitChannelInfo(thisUnit)) / 1000
                    interruptID = select(8,UnitChannelInfo(thisUnit))
                    castorchan = "channel"
                end
                if spellname ~= nil then
                    local castleft = castEndTime - GetTime()
                        -- WriteFile("encountertest.txt", tostring(ObjectName("boss"..i)) .. "," .. tostring(castleft) .. " left," .. tostring(spellname) .. ", spellid =" .. tostring(interruptID) .. "\n", true)
                        -- print(castleft.." cast left"..spellname)
                        -- print(castleft.." channel left"..spellname)
                    -- if castleft <= 3 then
                        if (select(3, UnitCastID(thisUnit)) == ObjectPointer("player") or select(4, UnitCastID(thisUnit)) == ObjectPointer("player")) and castleft <= 0.2 then--GetUnitIsUnit("player", "boss"..i.."target") or   then
                            if cloakPlayerlist[interruptID] then
                                if cast.cloakOfShadows("player") then end
                            elseif evasionPlayerlist[interruptID] then
                                if cast.evasion("player") then end
                             elseif vanishList[interruptID] then
                                if cast.vanish("player") then end
                            end
                        else
                            if cloaklist[interruptID] then
                                if cast.cloakOfShadows("player") then end
                            elseif evasionlist[interruptID] then
                                if cast.riposte("player") then end
                            -- elseif shadowstepList[interruptID] then
                            --     if cast.shadowstep("target") then end
                            elseif feintlist[interruptID] then
                                if cast.pool.feint("player") and cd.feint.remains() <= castleft then return true end
                                if cast.feint("player") then return true end
                            end
                        end
                    -- end
                end
            end
          end
        end
      -- AddEventCallback("ENCOUNTER_START",function(...) encounterID = select(1,...) end)
      -- AddEventCallback("PLAYER_REGEN_ENABLED",function() encounterID = false end)
      --print(encounterID)
      -- if encounterID == 1004 then --- KR, 1st boss
      --     if UnitCastingInfo("boss1") then
      --         Boss1Cast,_,_,_,Boss1CastEnd = UnitCastingInfo("boss1")
      --     elseif UnitChannelInfo("boss1") then
      --         Boss1Cast,_,_,_,Boss1CastEnd = UnitChannelInfo("boss1")
      --     end
      --     if cast.able.cloakOfShadows("player") and
      --         spellonPlayer == 265773 and
      --         spellonPlayerTEndTime >= GetTime() + 3
      --     then
      --         if cast.cloakOfShadows("player") then
      --             if isChecked("Debug") then print("cloak auto") end
      --         return end
      --     end
      -- end
      --print(spellonPlayer)
    -- end
    ---------------------
    --- Begin Profile ---
    ---------------------
    --Profile Stop | Pause
    --print(swingTimer)
    -- poolcast.mutilate()
    -- if not IsMouselooking() then print("not") end
    -- if IsMouselooking() then print("yes") end
    -- print(debuff.rupture.duration("target"))
    if MythicStuff() then end
    
    if actionList_PreCombat() then return end
    
    if buff.stealth.exists() --or buff.shroud.exists()
     or isCasting("player") or pause() or IsMounted() or IsFlying() or mode.rotation == 2 then
      return true
    else
      --print(energyRegenCombined)
      --print(fokcccheck())
      --print(#enemies.yards5)
      --print(ttm)
      --print(energyRegenCombined)
      --print(debuff.garrote.exsang("target"))
      -- print("RUP1 is "..tostring(RUP1))
      -- print("GAR1 is "..tostring(GAR1))
      -- print("VEN1 is "..tostring(VEN1))
      --print(trait.shroudedSuffocation.rank)
      --print(debuff.garrote.applied(units.dyn5))
      --print(waitshit())
      -- if ssbuggy ~= nil then
      --     print("___________________")
      --ngs()
      --print(gcd)
      ---print(getDistance("target"))
      --print(isInRange(1329,"target"))
      --print(ssbug)
      -- print(ssbuggytime1)
      -- if debuff.rupture.exsang["target"] or debuff.garrote.exsang["target"] then
      --     print("exsanguinated")
      -- end
      -- print("below rupt")
      -- print(debuff.rupture.exsang("target"))
      -- print("below garrote")
      --print(debuff.rupture.exsang(units.dyn5))
      -- end
      --print(#enemies.yards5)
      --print("target Distance is - "..getDistance("target")..". Current dist is - "..currentDist)
      --print(debuff.rupture.exsang(units.dyn5).."exsang rupt")
      --print(debuff.garrote.exsang(units.dyn5).."exsang garrote")
      -- print(tostring(Evaluate_Garrote_Target("target")).."evaluate")
      -- print(tostring(debuff.rupture.refresh(units.dyn5)).."rupture")
      -- print(energyRegenCombined)
      -- print(debuff.garrote.applied(units.dyn5).." garrote coef")
      -- print(debuff.rupture.applied(units.dyn5).." ruptu coef")
      --print("Garrote calc"..debuff.garrote.calc()..". Rupture calc: "..debuff.rupture.calc()..".Print applied garrote"..debuff.rupture.applied())
      --print(bleeds)
      -- print(debuff.rupture.remain())
      --print(rtbReroll())
      --print(br.player.power.energy.ttm())
      -- if cast.sinisterStrike() then return end
      -- print(getDistance("target"))
      --print(inRange(193315,"target"))
      -- print(IsSpellInRange(193315,"target"))
      --if castSpell("target",193315,true,false,false,true,false,true,false,false) then return end
      --RunMacroText("/cast Коварный удар")
      -- if GetObjectID(units.dyn5) == 144081 then
      --     print("123")
      -- end
      --print(getSpellCD(703))
      --if actionList_Defensive() then return end
      if (mode.van2 == 1 or mode.van1 == 1) and cd.vanish.remain() >= 10 and talent.subterfuge then
        toggle("Van2", 2)
        toggle("Van1", 2)
      end
      if actionList_Defensive() then
        return
      end
      if mode.opener == 1 and inCombat and getSpellCD(61304) <= 0.2 then
        if isChecked("Exsa no vendetta opener") then
          if actionList_OpenNoVend() then
          end
        else
          if actionList_Open() then
          end
        end
        return true
      end
      --ChatOverlay("rotating")
      --ChatOverlay("erc =" .. energyRegenCombined)
      -- if isChecked("Search for orb/ghuunies") and br.player.instance=="party" then
      --     if burnpool() then return end
      -- end
      
      
      
      if inCombat or (botSpell == spell.vanish and (br.player.instance == "party" or isDummy("target"))) then
        if inCombat and not stealth and isValidUnit("target") and getDistance("target") <= 5 and not IsCurrentSpell(6603) and getFacing("player", "target") then
          StartAttack("target")
        end
        if stealthingRogue and enemies5 >= 1 then
          if actionList_Stealthed() then return end
        end

      -- if pewpewgcd ~= nil and botSpellTime ~= nil and botSpellTime + pewpewgcd - GetTime() >= 0.1 then return true end
        
        -- if isChecked("Viable targets") then
        --     LibDraw.clearCanvas()
        --     showviable()
        -- end
        if actionList_Special() then
          return true
        end

        if actionList_Interrupts() then
          return true
        end
        if mode.stun == 1 then
          if actionList_Stun() then
            return true
          end
        end
        ChatOverlay(usecds)
        if usecds and not GetKeyState(0x10) then
          if actionList_Cooldowns() then return true end
        end

        -- if isChecked("Check AA") and swingTimer == 0 then
        --     startaa()
        -- end

        
        --print(#br.player.enemies.yards5)
        --print(stealthingRogue)
        --print(bleeds)
        if isChecked("Search for orb/ghuunies") and br.player.instance == "party" then
          if burnpool() then
            return true
          end
        end
        
        --print(garrotecountbuff.."garrote........"..getCombatTime())
          if isChecked("Toxic Blade on cd") and getDistance("target") <= 5 and not GetKeyState(0x10) and mode.cdafter == 1 then
            if ttd("target") >= 5 and debuff.rupture.exists("target") then
              if cast.toxicBlade("target") then
                if isChecked("Debug") then
                  print("cds before tb target")
                end
                return true
              end
            end
          end
          if actionList_Dot() then
          end
          --if usefiller() then
          -- print("123")
          if actionList_Direct() then
          end
          --end
          if isChecked("Racial") then
            if race == "BloodElf" and energyDeficit >= (25 + energyRegenCombined) then
              if cast.racial("player") then
                return true
              end
            elseif race == "Nightborne" then
              if cast.racial("player") then
                return true
              end
            elseif race == "LightforgedDraenei" then
              if cast.racial("target", "ground") then
                return true
              end
            end
          end
      end -- End In Combat
    end -- End Profile
  end -- runRotation
local id = 259
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

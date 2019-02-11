---  Protection Warrior for 8.1 by Laksmackt and Rebecca  - 01/2019
--- Left Alt on Mouseover = Heroic Throw
--- Special Credits to Panglo for his Awesome Ignore Pain function ! :)

local rotationName = "ProtectionPAL"

---------------
--- Toggles ---
---------------
local function createToggles()
  -- Rotation Button
  RotationModes = {
    [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 0, icon = br.player.spell.thunderClap },
    [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.revenge },
    [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.devastate },
  };
  CreateButton("Rotation", 1, 0)
  -- Cooldown Button
  CooldownModes = {
    [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avatar },
    [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avatar },
    [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar }
  };

  CreateButton("Cooldown", 2, 0)
  -- Defensive Button
  DefensiveModes = {
    [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.shieldBlock },
    [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.shieldBlock }
  };
  CreateButton("Defensive", 3, 0)
  -- Interrupt Button
  InterruptModes = {
    [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Use Interrupts.", highlight = 1, icon = br.player.spell.pummel },
    [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
  };
  CreateButton("Interrupt", 4, 0)
  --Taunt Button
  TauntModes = {
    [1] = { mode = "On", value = 1, overlay = "Auto Taunt Enabled", tip = "Will taunt all.", highlight = 1, icon = br.player.spell.taunt },
    [2] = { mode = "Off", value = 2, overlay = "Auto Taunt Disabled", tip = "Will not taunt.", highlight = 0, icon = br.player.spell.taunt }
  };
  CreateButton("Taunt", 5, 0)
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
    section = br.ui:createSection(br.ui.window.profile, "General")
    br.ui:createCheckbox(section, "Open World Defensives", "Use this checkbox to ensure defensives are used while in Open World")
    br.ui:createCheckbox(section, "Battle Shout", "Keep Battle Shout Buff Up")

    br.ui:checkSectionState(section)
    ------------------------
    --- Cooldowns
    ------------------------
    section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
    br.ui:createCheckbox(section, "use Racials", "check here to auto use racials")
    br.ui:createCheckbox(section, "use Trinkets", "check here to auto use trinkets")

    br.ui:checkSectionState(section)
    -------------------------
    --- Defensives
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Defensive")
    br.ui:createSpinner(section, "Healthstone", 30, 0, 100, 5, "Your Health % to be cast at")
    br.ui:createSpinner(section, "Demoralizing Shout", 75, 0, 100, 5, "Your Health % to be cast at")
    br.ui:createSpinner(section, "Shieldwall", 35, 0, 100, 5, "Your Health % to be cast at")
    br.ui:createSpinner(section, "Rallying Cry", 20, 0, 100, 5, "Your Health % or Group % to be cast at")
    br.ui:checkSectionState(section)

    -------------------------
    --- Spell Usage ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Spell Usage")
    br.ui:createCheckbox(section, "Berserker Rage", "Use Berserker Rage on loss of Control")
    br.ui:createCheckbox(section, "Devastate", "Use Devastate")
    br.ui:createCheckbox(section, "Shield Slam", "Use Shield Slam")
    br.ui:createCheckbox(section, "Dragon Roar", "Use Dragon Roar")
    br.ui:createCheckbox(section, "Ravager", "Use Ravager")
    br.ui:createCheckbox(section, "Revenge", "Use Revenge")
    br.ui:createSpinner(section, "Victory Rush - Impending Victory", 80, 0, 100, 5, "Your Health % to be cast at")

    br.ui:checkSectionState(section)

    -------------------------
    -------------------------
    --- Interrupts
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    br.ui:createCheckbox(section, "Storm Bolt Interrupt", "Use Storm Bolt as an Interrupt")
    br.ui:createCheckbox(section, "Shockwave Interrupt", "Use Shockwave as an Interrupt")
    br.ui:createCheckbox(section, "Pummel Interrupt", "Use Pummel as an Interrupt")
    br.ui:createCheckbox(section, "Intimidating Shout Interrupt", "Use Intimidating Shout as an Interrupt")
    br.ui:createSpinner(section, "InterruptAt", 55, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")

    br.ui:checkSectionState(section)
    -------------------------
    --- Modifiers  ---
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Modifiers")
    br.ui:createDropdown(section, "Heroic Leap Hotkey", br.dropOptions.Toggle, 7, "Hold down the set hotkey and Heroic Leap will be casted at mouse cursor on next GCD.")
    br.ui:createDropdown(section, "Intercept Hotkey", br.dropOptions.Toggle, 7, "Hold down the set hotkey and Intercept will be casted at the current Mouseover target on next GCD.")

    br.ui:checkSectionState(section)

  end
  optionTable = { {
                    [1] = "Rotation Options",
                    [2] = rotationOptions,
                  } }
  return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
  if br.timer:useTimer("debugFury", 0.1) then
    --change "debugFury" to "debugSpec" (IE: debugFire)
    --Print("Running: "..rotationName)

    ---------------
    --- Toggles --- -- List toggles here in order to update when pressed
    ---------------
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)
    local tauntSetting = br.data.settings[br.selectedSpec].toggles["Taunt"]
    --------------
    --- Locals ---
    --------------
    local artifact = br.player.artifact
    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
    local gcd = br.player.gcd
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local lowestHP = br.friend[1].unit
    local mode = br.player.mode
    local perk = br.player.perk
    local php = br.player.health
    local power, powmax, powgen = br.player.power, br.player.powerMax, br.player.powerRegen
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local thisUnit = thisUnit
    local racial = br.player.getRacial()
    local ttd = getTTD("target")
    local spell = br.player.spell
    local talent = br.player.talent
    local ttm = br.player.timeToMax
    local units = br.player.units
    local friends = friends or {}
    local rage, powerDeficit = br.player.power.rage.amount(), br.player.power.rage.deficit()
    local hasAggro = UnitThreatSituation("player")
    friends.yards40 = getAllies("player", 40)
    if hasAggro == nil then
      hasAggro = 0
    end

    if leftCombat == nil then
      leftCombat = GetTime()
    end
    if profileStop == nil then
      profileStop = false
    end
    units.get(5)
    units.get(8)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)
    enemies.get(8, "target")
    --friends.get(8)
    ---------------------------------
    ---     Utility Functions   ---
    ---------------------------------
    local function mainTank()
      if (#enemies.yards30 >= 1 and (hasAggro >= 2)) or isChecked("Open World Defensives") then
        return true
      else
        return false
      end
    end
    -- Thanks to Panglo
    local function ipCapCheck()
      if buff.ignorePain.exists() then
        local ipValue = tonumber((select(1, GetSpellDescription(190456):match("%d+%S+%d"):gsub("%D", ""))), 10)
        local ipMax = math.floor(ipValue * 1.3)
        local ipCurrent = tonumber((select(16, UnitBuffID("player", 190456))), 10)
        if ipCurrent == nil then
          ipCurrent = 0
          return
        end
        if ipCurrent <= (ipMax * 0.2) then
          ---print("IP below cap")
          return true
        else
          --print("dont cast IP")
          return false
        end
      else
        --print("IP not on")
        return true
      end
    end
    local function castBestConeAnglexx(spell, angle, range, minUnits, checkNoCombat)
      if not isKnown(spell) or getSpellCD(spell) ~= 0 then
        return false
      end
      local curFacing = ObjectFacing("player")
      local enemiesTable = getEnemies("player", range, checkNoCombat)
      local playerX, playerY, playerZ = ObjectPosition("player")
      local angles = {}
      for i = 1, #enemiesTable do
        local unitX, unitY, unitZ = ObjectPosition(enemiesTable[i])
        if playerX and unitX then
          local angleToUnit = getAngles(playerX, playerY, playerZ, unitX, unitY, unitZ)
          tinsert(angles, angleToUnit)
        end
      end
      local numAngles = table.getn(angles)
      if numAngles == 0 or numAngles < minUnits then
        return false
      end
      table.sort(angles, function(a, b)
        return a < b
      end)
      angle = angle / 180 * math.pi
      local bestAngle, mostHit = angles[1], 0
      local i, j = 1, 2
      while i <= numAngles and j < numAngles * 2 do
        --local angleJ = j > numAngles and angles[j - numAngles + 1] + math.pi * 2 or angles[j]
        local angleJ = j > numAngles and angles[j - numAngles] + math.pi * 2 or angles[j]
        while i < j and angleJ - angles[i] > angle do
          i = i + 1
        end
        if j - i > mostHit then
          mostHit = j - i
          bestAngle = (angleJ - angles[i]) / 2 + angles[i]
        end
        j = j + 1
      end
      if mostHit + 1 >= minUnits then
        FaceDirection(bestAngle, true)
        CastSpellByName(GetSpellInfo(spell))
        FaceDirection(curFacing, true)
        return true
      end
      return false
    end
    local function castBestConeAngle(spell, angle, range, minUnits, checkNoCombat)
      if not isKnown(spell) or getSpellCD(spell) ~= 0 then
        return false
      end
      local curFacing = ObjectFacing("player")
      local enemiesTable = getEnemies("player", range, checkNoCombat)
      local playerX, playerY, playerZ = ObjectPosition("player")
      local coneTable = {}
      for i = 1, #enemiesTable do
        local unitX, unitY, unitZ = ObjectPosition(enemiesTable[i])
        if playerX and unitX then
          local angleToUnit = getAngles(playerX, playerY, playerZ, unitX, unitY, unitZ)
          tinsert(coneTable, angleToUnit)
        end
      end
      local facing, bestAngle, mostHit = 0, 0, 0
      while facing <= 6.2 do
        local units = 0
        for i = 1, #coneTable do
          local angleToUnit = coneTable[i]
          local angleDifference = facing > angleToUnit and facing - angleToUnit or angleToUnit - facing
          local shortestAngle = angleDifference < math.pi and angleDifference or math.pi * 2 - angleDifference
          local finalAngle = shortestAngle / math.pi * 180
          if finalAngle < angle / 2 then
            units = units + 1
          end
        end
        if units > mostHit then
          mostHit = units
          bestAngle = facing
        end
        facing = facing + 0.05
      end
      if mostHit >= minUnits then
        FaceDirection(bestAngle, true)
        CastSpellByName(GetSpellInfo(spell))
        FaceDirection(curFacing, true)
        return true
      end
      return false
    end
    local CastSpellByNameFace = function(SpellName, Target, ...)
      local castTime = select(4, GetSpellInfo(SpellName))
      if isChecked("Auto Facing") and castTime == 0 and UnitExists(Target or "Target") and UnitIsVisible(Target or "Target") and not ObjectIsFacing("Player", Target or "Target") then
        local facing = ObjectFacing("Player")
        local playerx, playery = ObjectPosition("Player")
        local targetx, targety = ObjectPosition(Target or "Target")
        if not playerx or not targetx then
          return
        end
        local angle = rad(atan2(targety - playery, targetx - playerx))
        local mouselookActive = false
        if IsMouselooking() then
          mouselookActive = true
          MouselookStop()
        end
        if angle < 0 then
          FaceDirection(rad(360 + atan2(targety - playery, targetx - playerx)), true)
        else
          FaceDirection(angle, true)
        end
        CastSpellByName(SpellName, Target, ...)
        FaceDirection(facing, true)
        if mouselookActive then
          MouselookStart()
        end
      else
        CastSpellByName(SpellName, Target, ...)
      end
    end
    -----------------------------
    ---      Modifiers        ---
    -----------------------------
    if isChecked("Heroic Leap Hotkey") and SpecificToggle("Heroic Leap Hotkey") then
      CastSpellByName(GetSpellInfo(spell.heroicLeap), "cursor")
      return
    end
    if IsLeftAltKeyDown() and cast.able.heroicThrow("mouseover") and getDistance("player", "mouseover") >= 8 and getDistance("player", "mouseover") <= 30 then
      CastSpellByName(GetSpellInfo(spell.heroicThrow), "mouseover")
      return
    end

    if isChecked("Intercept Hotkey") and SpecificToggle("Intercept Hotkey") then
      if GetUnitIsFriend("mouseover") and cast.able.intercept("mouseover") and getDistance("player", "mouseover") >= 0 and getDistance("player", "mouseover") <= 25 then
        if cast.intercept("mouseover") then
          return
        end
      elseif not GetUnitIsFriend("mouseover") and cast.able.intercept("mouseover") and getDistance("player", "mouseover") >= 8 and getDistance("player", "mouseover") <= 25 then
        if cast.intercept("mouseover") then
          return
        end
      end
    end

    -----------------------------
    ---    Combat Functions  ---
    -----------------------------

    local function antislow()
      if isChecked("Berserker Rage") and hasNoControl(spell.berserkerRage) then
        if cast.berserkerRage() then
          return
        end
      end
    end

    local function Defensives()
      if useDefensive() then

        --Healthston
        if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and inCombat then
          if canUse(5512) then
            useItem(5512)
          end
        end

        --demo shout
        if isChecked("Demoralizing Shout") and cast.able.demoralizingShout() then
          if not talent.boomingVoice and (php <= getOptionValue("Demoralizing Shout") or #enemies.yard8 >= 3) or talent.boomingVoice and rage <= 60 then
            if cast.demoralizingShout() then
              return true
            end
          end
        end
        -- shield block
        if cast.able.shieldBlock() and mainTank() and #enemies.yards8 >= 1 and (not buff.shieldBlock.exists() or (buff.shieldBlock.remain() <= (gcd * 1.5))) and not buff.lastStand.exists() and rage >= 30 then
          if cast.shieldBlock() then
            return true
          end
        end
        -- last stand when shieldblock is down - if bolster
        if talent.bolster and not buff.shieldBlock.exists() and cd.shieldBlock.remain() > gcd and mainTank() then
          if cast.lastStand() then
            return true
          end
        end
        --Victory rush / Impending Victory
        if isChecked("Victory Rush - Impending Victory") and (cast.able.victoryRush() or cast.able.impendingVictory()) and php <= getOptionValue("Victory Rush - Impending Victory") then
          if talent.impendingVictory then
            if cast.impendingVictory() then
              return true
            end
          elseif buff.victorious.exists() then
            if cast.victoryRush() then
              return true
            end
          end
        end

        --Rallying Cry
        if isChecked("Rallying Cry") then
          for i = 1, #friends.yards40 do
            if friends.yards40[i].hp <= getOptionValue("Rallying Cry") or php <= getOptionValue("Rallying Cry") then
              if cast.rallyingCry() then
                return true
              end
            end
          end
        end
        --ignore pain
        if cast.able.ignorePain() and mainTank() and ipCapCheck() then
          if buff.vengeanceIgnorePain.exists() and rage >= 42 then
            if cast.ignorePain() then
              return
            end
          end
          if rage >= 55 and not buff.vengeanceRevenge.exists() then
            if cast.ignorePain() then
              return
            end
          end
        end
        if isChecked("Shieldwall") and cast.able.shieldWall() and php <= getOptionValue("Shieldwall") then
          if cast.shieldWall() then
            return true
          end
        end
      end
    end

    local function Interrupts()
      if useInterrupts() then


        for i = 1, #enemies.yards20 do
          thisUnit = enemies.yards20[i]
          unitDist = getDistance(thisUnit)
          targetMe = UnitIsUnit("player", thisUnit) or false

          if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
            if isChecked("Pummel Interrupt") and cast.able.pummel() and unitDist < 6 then
              if cast.pummel(thisUnit) then
                return true
              end
            elseif isChecked("Shockwave Interrupt") and cast.able.shockwave and unitDist < 10 then
              if cast.shockwave() then
                return true
              end
            elseif isChecked("Storm Bolt Interrupt") and cast.able.stormBolt and unitDist < 20 then
              if cast.stormBolt() then
                return true
              end
            elseif isChecked("Intimidating Shout Interrupt") and unitDist <= 8 then
              if cast.intimidatingShout() then
                return true
              end
            end
          end
        end
      end
    end

    local function AttackSpells()


      --single target rotation
      if #enemies.yards8 == 1 then
        if GetUnitExists("target") and getFacing("player", "target") and not UnitIsDeadOrGhost("target") and getDistance("target") <= 8 then
          if isChecked("Shield Slam") and cd.shieldSlam.remain() == 0 and cast.able.shieldSlam() then
            if cast.shieldSlam() then
              return true
            end
          elseif isChecked("Revenge") and cast.able.revenge() and buff.revenge.exists() or (rage > 80 and cd.shieldBlock.remain() == 0) then
            for i = 1, #enemies.yards8 do
              local thisUnit = enemies.yards8[i]
              if not debuff.deepwoundsProt.exists(thisUnit) then
                if cast.revenge(thisUnit) then
                  return true
                end
              end
            end
          elseif cast.able.thunderClap() then
            if cast.thunderClap() then
              return true
            end
          elseif isChecked("Dragon Roar") and talent.dragonRoar and cast.able.dragonRoar(nil, "aoe") then
            if cast.dragonRoar(nil, "aoe") then
              return true
            end
          elseif isChecked("Ravager") and talent.ravager and cast.able.ravager then
            if cast.ravager("target", "ground") then
              return true
            end
          elseif isChecked("Devastate") and cast.able.devastate() then
            if cast.devastate() then
              return true
            end
          elseif getDistance("target") > 8 and getDistance("target") < 30 then
            if cast.heroicThrow("target") then
              return true
            end
          end
        end --single target rotation
      elseif #enemies.yards8 >= 2 then
        if GetUnitExists("target") and getFacing("player", "target") and not UnitIsDeadOrGhost("target") and getDistance("target") <= 8 then
          if cast.able.shockwave() and #enemies.yards8 >= 3 then
            if castBestConeAngle(spell.shockwave, 30, 7, 3, true) then
              return true
            end
          elseif cast.able.thunderClap() and talent.cracklingThunder then
            if cast.thunderClap("player", nil, 1, 12) then
              return true
            end
          elseif cast.able.thunderClap() then
            if cast.thunderClap("player", nil, 1, 8) then
              return true
            end
          elseif isChecked("Shield Slam") and cast.able.shieldSlam() then
            if cast.shieldSlam(units.dyn8) then
              return true
            end
          elseif isChecked("Dragon Roar") and talent.dragonRoar and cast.able.dragonRoar(nil, "aoe") then
            if cast.dragonRoar(nil, "aoe") then
              return true
            end
          elseif isChecked("Ravager") and cast.able.ravager() then
            if cast.ravager("target", "ground") then
              return true
            end
          elseif isChecked("Revenge") and cast.able.revenge() and buff.revenge.exists() or (rage > 80 and cd.shieldBlock.remain() == 0) then
            for i = 1, #enemies.yards8 do
              local thisUnit = enemies.yards8[i]
              if not debuff.deepwoundsProt.exists(thisUnit) then
                if cast.revenge(thisUnit) then
                  return true
                end
              end
            end
          else
            if cast.revenge() then
              return true
            end
          end
        elseif isChecked("Devastate") and cast.able.devastate() then
          for i = 1, #enemies.yards8 do
            local thisUnit = enemies.yards8[i]
            if not debuff.deepwoundsProt.exists(thisUnit) then
              if cast.devastate(thisUnit) then
                return true
              end
            else
              if cast.devastate() then
                return true
              end
            end
          end
        elseif cast.able.heroicThrow() then
          if cast.heroicThrow("target")
          then
            return true
          end
        end
      end
    end -- end attacks


    local function Cooldowns()

      -- Taunt
      if tauntSetting == 1 and cast.able.taunt() then
        for i = 1, #enemies.yards30 do
          local thisUnit = enemies.yards30[i]
          if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
            if cast.taunt(thisUnit) then
              return true
            end
          end
        end
      end

      if isChecked("use Trinkets") then
        local Trinket13 = GetInventoryItemID("player", 13)
        local Trinket14 = GetInventoryItemID("player", 14)

        -- Mchimba's Ritual Bandage
        if (Trinket13 == 159618 or Trinket14 == 159618) and GetItemCooldown(159618) == 0 and php <= 60 then
          useItem(159618)
        end
        --Big Red Button
        if (Trinket13 == 159611 or Trinket14 == 159611) and GetItemCooldown(159611) == 0 and #enemies.yards8t >= 2 then
          useItemGround("target", 159611, 30, 0, 8)
        end
        --Jes' howler
        if (Trinket13 == 159627 or Trinket14 == 159627) and GetItemCooldown(159627) == 0 and (#friends.yard8 >= 2 or php <= 50) then
          useItem(159627)
        end
        -- Vial of Animated Blood
        if (Trinket13 == 159625 or Trinket14 == 159625) and GetItemCooldown(159625) == 0 and buff.avatar.exists() then
          useItem(159625)
        end
        --doomsfury
        if (Trinket13 == 161463 or Trinket14 == 161463) and GetItemCooldown(161463) == 0 and buff.avatar.exists() then
          useItem(161463)
        end
      end

      -------------------------
      -------Auto racial-------
      -------------------------
      if isChecked("use Racials") and cast.able.racial() and #enemies.yards8 >= 1 and ttd > 6 then
        if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" or race == "Troll" or race == "Human" or race == "Gnome" or race == "Draenei" then
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
        if race == "Human" and hasNoControl() and not cast.able(berserkerRage) then
          if cast.racial("player") then
            return true
          end
        end
        if race == "Gnome" and hasNoControl() and not cast.able(berserkerRage) then
          if cast.racial("player") then
            return true
          end
        end
        if race == "Draenei" then
          for i = 1, #friends.yards40 do
            if friends.yards40[i].hp < 20 then
              if cast.racial(friends.yards40[i]) then
                return true
              end
            end
          end
        end


      elseif race == "BloodElf" then
        local torrentUnit = 0
        for i = 1, #enemies.yards8 do
          local thisUnit = enemies.yards8[i]
          if canDispel(thisUnit, select(7, GetSpellInfo(GetSpellInfo(69179)))) then
            torrentUnit = torrentUnit + 1
            if torrentUnit >= getOptionValue("Arcane Torrent Dispel") then
              if castSpell("player", racial, false, false, false) then
                return true
              end
              break
            end
          end
        end
      end

      if cast.able.avatar("player") and (ttd > 10 or #enemies.yards8 >= 3) and rage <= 80 and (cd.shieldSlam.remain() == 0 or cd.shieldSlam.remain() > 4) then
        if cast.avatar("player") then
          return true
        end
      end
    end
    -- Battle Shout
    if isChecked("Battle Shout") and cast.able.battleShout() then
      for i = 1, #br.friend do
        local thisUnit = br.friend[i].unit
        if not UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 100 and buff.battleShout.remain(thisUnit) < 600 then
          if cast.battleShout() then
            return
          end
        end
      end
    end
    -----------------------------
    ---      Rotation itself  ---
    -----------------------------
    if inCombat and not (IsMounted() or IsFlying()) then
      StartAttack()
      if Cooldowns() then
        return
      end
      if php <= 90 then
        if Defensives() then
          return
        end
      end

      if AttackSpells() then
        return
      end
      if antislow() then
        return
      end
      if Interrupts() then
        return
      end
    end

    -- Pause
    if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
      return true
    else

    end -- Pause
  end -- End Timer
end -- End runRotation
local id = 73 -- Change to the spec id profile is for.
if br.rotations[id] == nil then
  br.rotations[id] = {}
end
tinsert(br.rotations[id], {
  name = rotationName,
  toggles = createToggles,
  options = createOptions,
  run = runRotation,
})

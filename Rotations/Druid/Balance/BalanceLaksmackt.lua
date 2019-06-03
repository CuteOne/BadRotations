local rotationName = "Laksmackt" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles()
  -- Define custom toggles
  -- Rotation Button
  RotationModes = {
    [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of enemies in range.", highlight = 1, icon = br.player.spell.moonfire },
    [2] = { mode = "Mult", value = 2, overlay = "Multi Target rotation", tip = "Multi Target rotation", highlight = 1, icon = br.player.spell.starfall },
    [3] = { mode = "Sing", value = 2, overlay = "Force single target", tip = "Force single target", highlight = 0, icon = br.player.spell.solarWrath },
    [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.soothe }
  };

  CreateButton("Rotation", 1, 0)
  -- Cooldown Button
  CooldownModes = {
    [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.celestialAlignment },
    [2] = { mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.celestialAlignment },
    [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.celestialAlignment }
  };
  CreateButton("Cooldown", 2, 0)
  -- Defensive Button
  DefensiveModes = {
    [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.barkskin },
    [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.barkskin }
  };
  CreateButton("Defensive", 3, 0)
  -- Interrupt Button
  InterruptModes = {
    [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.solarBeam },
    [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.solarBeam }
  };
  CreateButton("Interrupt", 4, 0)
  -- FoN Button
  ForceofNatureModes = {
    [1] = { mode = "On", value = 1, overlay = "Force of Nature Enabled", tip = "Will Use Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature },
    [2] = { mode = "Key", value = 2, overlay = "Force of Nature hotkey", tip = "Key triggers Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature },
    [3] = { mode = "Off", value = 2, overlay = "Force of Nature Disabled", tip = "Will Not Use Force of Nature", highlight = 0, icon = br.player.spell.forceOfNature }
  };
  CreateButton("ForceofNature", 5, 0)

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
    br.ui:createSpinner(section, "Pre-Pull Timer", 2.5, 0, 10, 0.5, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
    br.ui:createCheckbox(section, "Opener")
    if br.player.talent.restorationAffinity then
      br.ui:createSpinner(section, "OOC Regrowth", 50, 1, 100, 5, "Set health to heal while out of combat. Min: 1 / Max: 100 / Interval: 5")
      br.ui:createSpinner(section, "OOC Wild Growth", 50, 1, 100, 5, "Set health to heal while out of combat. Min: 1 / Max: 100 / Interval: 5")
    end
    br.ui:createCheckbox(section, "Auto Shapeshifts")
    br.ui:createCheckbox(section, "Auto Soothe")
    br.ui:createSpinnerWithout(section, "Starsurge/Starfall Dump", 40, 40, 100, 5, "Set minimum AP value for Starsurge use. Min: 40 / Max: 100 / Interval: 5")
    br.ui:createCheckbox(section, "Auto Engage On Target", "Check this to cast moonfire on target OOC to engage combat")
    br.ui:checkSectionState(section)
    section = br.ui:createSection(br.ui.window.profile, "Healing")
    br.ui:createDropdown(section, "Rebirth", { "|cff00FF00Tanks", "|cffFFFF00Healers", "|cffFFFFFFTanks and Healers", "|cffFF0000Mouseover Target", "|cffFFFFFFAny" }, 3, "", "|ccfFFFFFFTarget to Cast On")
    br.ui:createCheckbox(section, "Revive target")
    br.ui:createDropdown(section, "Remove Corruption", { "|cff00FF00Player Only", "|cffFFFF00Selected Target", "|cffFFFFFFPlayer and Target", "|cffFF0000Mouseover Target", "|cffFFFFFFAny" }, 3, "", "|ccfFFFFFFTarget to Cast On")
    br.ui:checkSectionState(section)
    ------------------------
    --- COOLDOWN OPTIONS --- -- Define Cooldown Options
    ------------------------
    section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
    br.ui:createCheckbox(section, "Auto Innervate", "Use Innervate if you have Lively Spirit traits for DPS buff")
    br.ui:createCheckbox(section, "Int Pot", "Use Int Pot when Incarnation/Celestial Alignment is up")
    br.ui:createCheckbox(section, "Racial")
    br.ui:createCheckbox(section, "Use Trinkets")
    br.ui:createCheckbox(section, "Warrior Of Elune")
    br.ui:createCheckbox(section, "Fury Of Elune")
    br.ui:createCheckbox(section, "Incarnation/Celestial Alignment")
    br.ui:createSpinnerWithout(section, "Treant Targets", 3, 1, 10, 1, "How many baddies before using Treant?")
    br.ui:createDropdown(section, "Treants Key", br.dropOptions.Toggle, 6, "", "|cffFFFFFFTreant Key")

    br.ui:checkSectionState(section)
    -------------------------
    ---  TARGET OPTIONS   ---  -- Define Target Options
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Targets")
    br.ui:createSpinnerWithout(section, "Max Stellar Flare Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Stellar Flare. Min: 1 / Max: 10 / Interval: 1")
    br.ui:createSpinnerWithout(section, "Max Moonfire Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Moonfire. Min: 1 / Max: 10 / Interval: 1")
    br.ui:createSpinnerWithout(section, "Max Sunfire Targets", 2, 1, 10, 1, "|cff0070deSet to maximum number of targets to dot with Sunfire. Min: 1 / Max: 10 / Interval: 1")
    br.ui:createSpinnerWithout(section, "Lunar Strike Filler Targets", 2, 1, 10, 1, "|cff0070deSet to minimum number of targets to use Lunar Strike as filler spell. Min: 1 / Max: 10 / Interval: 1")
    br.ui:createSpinnerWithout(section, "Starfall Targets (0 for auto)", 0, 0, 10, 1, "|cff0070deSet to minimum number of targets to use Starfall. 0 to calculate")
    --    br.ui:createSpinnerWithout(section, "Fury of Elune Targets", 2, 1, 10, 1, "|cff0070deSet to minimum number of targets to use Fury of Elune. Min: 1 / Max: 10 / Interval: 1" )
    br.ui:checkSectionState(section)
    -------------------------
    --- DEFENSIVE OPTIONS --- -- Define Defensive Options
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Defensive")
    br.ui:createSpinner(section, "Potion/Healthstone", 20, 0, 100, 5, "Health Percent to Cast At")
    br.ui:createSpinner(section, "Renewal", 25, 0, 100, 5, "Health Percent to Cast At")
    br.ui:createSpinner(section, "Barkskin", 60, 0, 100, 5, "Health Percent to Cast At")
    br.ui:createSpinner(section, "Regrowth", 30, 0, 100, 5, "Health Percent to Cast At")
    br.ui:createSpinner(section, "Swiftmend", 15, 0, 100, 5, "Health Percent to Cast At")
    br.ui:checkSectionState(section)
    -------------------------
    --- INTERRUPT OPTIONS --- -- Define Interrupt Options
    -------------------------
    section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    br.ui:createCheckbox(section, "Solar Beam")
    br.ui:createCheckbox(section, "Mighty Bash")
    br.ui:createCheckbox(section, "Typhoon")
    -- Interrupt Percentage
    br.ui:createSpinner(section, "InterruptAt", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
    br.ui:checkSectionState(section)
    ----------------------
    --- TOGGLE OPTIONS --- -- Define Toggle Options
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
    -- Pause Toggle
    br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
    br.ui:checkSectionState(section)
  end
  optionTable = { {
                    [1] = "Rotation Options",
                    [2] = rotationOptions,
                  } }
  return optionTable
end
local function runRotation()


  ---------------
  --- Toggles --- -- List toggles here in order to update when pressed
  ---------------
  UpdateToggle("Rotation", 0.25)
  UpdateToggle("Cooldown", 0.25)
  UpdateToggle("Defensive", 0.25)
  UpdateToggle("Interrupt", 0.25)
  UpdateToggle("ForceofNature", 0.25)
  br.player.mode.forceOfNature = br.data.settings[br.selectedSpec].toggles["ForceofNature"]


  --------------
  --- Locals ---
  --------------
  -- local artifact                                      = br.player.artifact
  -- local combatTime                                    = getCombatTime()
  -- local cd                                            = br.player.cd
  -- local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
  -- local healPot                                       = getHealthPot()
  -- local level                                         = br.player.level
  -- local lowestHP                                      = br.friend[1].unit
  -- local lowest                                        = br.friend[1]
  local mana = getMana("player")
  -- local perk                                          = br.player.perk

  local power, powmax, powgen = br.player.power.astralPower.amount(), br.player.powerMax, br.player.powerRegen
  -- local ttm                                           = br.player.power.mana.ttm()
  --------------
  -- Player
  --------------
  local buff = br.player.buff
  local cast = br.player.cast
  local php = br.player.health
  local spell = br.player.spell
  local talent = br.player.talent
  local cd = br.player.cd
  local gcd = br.player.gcdMax
  local charges = br.player.charges
  local debuff = br.player.debuff
  local drinking = getBuffRemain("player", 192002) ~= 0 or getBuffRemain("player", 167152) ~= 0 or getBuffRemain("player", 192001) ~= 0
  local resable = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") and UnitInRange("target")
  local inCombat = isInCombat("player")
  local inInstance = br.player.instance == "party"
  local inRaid = br.player.instance == "raid"
  local solo = #br.friend == 1
  local race = br.player.race
  local racial = br.player.getRacial()
  local traits = br.player.traits
  local moving = isMoving("player")
  local ttd = getTTD
  local astralPowerDeficit = br.player.power.astralPower.deficit()

  -------------
  -- Raid
  ------------

  local tanks = getTanksTable()
  local lowest = br.friend[1]
  local friends = friends or {}
  -------------
  -- Enemies
  -------------
  local enemies = br.player.enemies
  local lastSpell = lastSpellCast
  local mode = br.player.mode
  local pullTimer = br.DBM:getPulltimer()
  local units = br.player.units
  local pewbuff = buff.incarnationChoseOfElune.exists() or buff.celestialAlignment.exists()
  local starfallRadius = nil

  enemies.get(45)
  enemies.get(15)
  enemies.get(8, "target") -- enemies.yards8t
  enemies.get(15, "target") -- enemies.yards15t
  enemies.get(12, "target") -- enemies.yards12t
  local function dps()
    local aoeTarget = 0
    if getValue("Starfall Targets (0 for auto)") == 0 then
      aoeTarget = 4
      if traits.arcanicPulsar.active then
        aoeTarget = aoeTarget + 1
      end
      if talent.starLord then
        aoeTarget = aoeTarget + 1
      end
      if talent.twinMoons then
        aoeTarget = aoeTarget + 1
      end
      if traits.arcanicPulsar.active and br.player.traits.streakingStars.rank >= 2 then
        aoeTarget = aoeTarget + 1
      end

      if talent.stellarDrift then
        starfallRadius = 15
      else
        starfallRadius = 12
      end

      if (race == "Troll") and isChecked("Racial") and useCDs() and pewbuff and ttd("target") >= 12 then
        cast.racial("player")
      end
    elseif getValue("Starfall Targets (0 for auto)") ~= 0 then
      aoeTarget = getValue("Starfall Targets (0 for auto)")
    end

    --trinkets
    -- pewbuff.
    if isChecked("Use Trinkets") and pewbuff or (cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) then
      if canUseItem(13) then
        useItem(13)
      end
      if canUseItem(14) then
        useItem(14)
      end
    end

    if isChecked("Int Pot") and canUseItem(109218) and not solo and useCDs() and pewbuff then
      useItem(109218)
    end
    --[[
         if isChecked("Int Pot") and canUseItem(163222) and not solo and useCDs() and (buff.celestialAlignment.exists() or buff.incarnationChoseOfElune.exists()) then
                    useItem(163222)
                end
    ]]


    -- Warrior of Elune
    if useCDs() and isChecked("Warrior Of Elune") and talent.warriorOfElune and not buff.warriorOfElune.exists() then
      if cast.warriorOfElune() then
        return true
      end
    end

    -- Innverate
    if isChecked("Auto Innervate") and cast.able.innervate() and getTTD("target") >= 12 then
      for i = 1, #br.friend do
        if UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" then
          if cast.innervate(br.friend[i].unit) then
            return true
          end
        end
      end
    end




    -- Incarnation  ap_check&!buff.ca_inc.up
    if talent.incarnationChoseOfElune and useCDs() and isChecked("Incarnation/Celestial Alignment") and
            debuff.sunfire.remain("target") > 8 and debuff.moonfire.remain("target") > 12 and
            (debuff.stellarFlare.remain("target") > 6 or not talent.stellarFlare) and power >= 40 and getTTD("target") >= 30 or hasBloodLust() then
      if cast.incarnationChoseOfElune("player") then
        return true
      end
    end

    if not talent.incarnationChoseOfElune and useCDs() and isChecked("Incarnation/Celestial Alignment") and
            power >= 40 and getTTD("target") >= 20 and
            (not traits.livelySpirit.active or buff.livelySpirit.exists() or solo or (traits.livelySpirit.active and cd.innervate.remain() >= 30)) and
            debuff.sunfire.remain("target") > 2 and debuff.moonfire.remain("target") > 2 and
            (debuff.stellarFlare.remain("target") > 1 or not talent.stellarFlare) or
            hasBloodLust()
    then
      if cast.celestialAlignment("player") then
        return true
      end
    end

    --	fury_of_elune
    if talent.furyOfElune and isChecked("Fury Of Elune") and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30) then
      if cast.furyOfElune(getBiggestUnitCluster(45, 1.25)) then
        return true
      end
    end


    -- Force Of Nature / treants
    if talent.forceOfNature and cast.able.forceOfNature() and br.player.power.astralPower.deficit() > 20 then
      if br.player.mode.forceOfNature == 1 and getTTD("target") >= 10
              and (pewbuff or cd.celestialAlignment.remain() > 30 or cd.incarnationChoseOfElune.remain() > 30)
              and (getValue("Treant Targets") >= #enemies.yards12t or isBoss())
      then
        if cast.forceOfNature("best", nil, 1, 15, true) then
          return true
        end
      elseif br.player.mode.forceOfNature == 2 and isChecked("Treants Key") and SpecificToggle("Treants Key") and not GetCurrentKeyBoardFocus() then
        if cast.forceOfNature("best", nil, 1, 15, true) then
          return true
        end
      end
    end

    --starLord cancellation
    if talent.starlord and power >= 87 and buff.starLord.exists() and buff.starLord.remain() < 8 then
      RunMacroText("/cancelaura starlord")
      --Print("Cancelling starLord at" .. buff.starLord.remain())
      return true
    end

    --Starfall
    if power >= 50 or talent.soulOfTheForest and power >= 40 then
      if (talent.stellarDrift and #enemies.yards15t >= aoeTarget) or #enemies.yards12t >= aoeTarget
              and (talent.starLord and (buff.starLord.remain() >= 8 or buff.starLord.stack() == 3) or not talent.starLord)
      then
        if cast.starfall("best", false, aoeTarget, starfallRadius) then
          return true
        end
      end
    end


    --starsurge
    --starsurge,if=(talent.starlord.enabled&(buff.starlord.stack<3|buff.starlord.remains>=5&buff.arcanic_pulsar.stack<8)|!talent.starlord.enabled&(buff.arcanic_pulsar.stack<8|buff.ca_inc.up))&spell_targets.starfall<variable.sf_targets&buff.lunar_empowerment.stack+buff.solar_empowerment.stack<4&buff.solar_empowerment.stack<3&buff.lunar_empowerment.stack<3&(!variable.az_ss|!buff.ca_inc.up|!prev.starsurge)|target.time_to_die<=execute_time*astral_power%40|!solar_wrath.ap_check



    if talent.starlord and power >= 40 and cast.able.starsurge and
            ((traits.streakingStars.active and pewbuff and not cast.last.starsurge(1)) or not pewbuff or not traits.streakingStars.active)
            and (buff.starLord.stack() < 3 and (buff.starLord.remain() >= 8) or not buff.starLord.exists())
            and (buff.arcanicPulsar.stack() < 8 or (power >= 75 and buff.arcanicPulsar.stack() == 8)) then

      if cast.starsurge(units.dyn45) then
        --Print("Stacks: " .. buff.starLord.stack() .. " Remain: " .. buff.starLord.remain() .. " pulsar: " .. buff.arcanicPulsar.stack())
        return true
      end
    elseif not talent.starlord then
      if (buff.arcanicPulsar.stack() < 8 or pewbuff) or
              buff.lunarEmpowerment.stack() + buff.solarEmpowerment.stack() < 4 and buff.solarEmpowerment.stack() < 3 and buff.lunarEmpowerment.stack() < 3 then
        if cast.starsurge(units.dyn45) then
          return
        end
      end
    end

    --dots
    for i = 1, #enemies.yards45 do
      local thisUnit = enemies.yards45[i]
      if debuff.sunfire.count() <= getOptionValue("Max Sunfire Targets") then
        if astralPowerDeficit >= 7 and debuff.sunfire.remain(thisUnit) < 5.4 and ttd(thisUnit) > 5.4 and ((traits.streakingStars.active and pewbuff and lastSpellCast ~= spell.sunfire) or not pewbuff) then
          if castSpell(thisUnit, spell.sunfire, true, false, false, true, false, true, true, false) then
            return true
          end
        end
      end
      if debuff.moonfire.count() <= getOptionValue("Max Moonfire Targets") then
        if astralPowerDeficit >= 7 and debuff.moonfire.remain(thisUnit) < 6.6 and ttd(thisUnit) > 6.6 and ((traits.streakingStars.active and pewbuff and lastSpellCast ~= spell.moonfire) or not pewbuff) then
          if castSpell(thisUnit, spell.moonfire, true, false, false, true, false, true, true, false) then
            return true
          end
        end
      end
      if debuff.stellarFlare.count() <= getOptionValue("Max Stellar Flare Targets") and not isMoving("player") then
        if talent.stellarFlare and astralPowerDeficit >= 12 and debuff.stellarFlare.remain(thisUnit) < 7.2 and ttd(thisUnit) > 7.2 and not cast.last.stellarFlare() then
          if castSpell(thisUnit, spell.stellarFlare, true, false, false, true, false, true, true, false) then
            return true
          end
        end
      end
    end

    --(!variable.az_ss|!buff.ca_inc.up)|variable.az_ss&buff.ca_inc.up&prev.solar_wrath)
    --&((buff.warrior_of_elune.up|buff.lunar_empowerment.up|spell_targets>=2&!buff.solar_empowerment.up)&(!variable.az_ss|!buff.ca_inc.up)|
    --variable.az_ss&buff.ca_inc.up&prev.solar_wrath)
    if (traits.streakingStars.active and pewbuff and not cast.last.lunarStrike(1)) or not traits.streakingStars.active or not pewbuff then
      if buff.owlkinFrenzy.exists()
              or buff.solarEmpowerment.stack() < 3 and buff.lunarEmpowerment.stack() == 3 and (buff.warriorOfElune.exists() or #enemies.yards8t >= 2 or buff.solarEmpowerment.stack == 0)
              or (traits.streakingStars.active and pewbuff and cast.last.solarWrath(1)) then
        if cast.lunarStrike(units.dyn45) then
          return true
        end
      end
    end
    --solar_wrath,if=variable.az_ss<3|!buff.ca_inc.up|!prev.solar_wrath
    if ((traits.streakingStars.active and pewbuff and not cast.last.solarWrath(1)) or not pewbuff) then
      if cast.solarWrath(units.dyn45) then
      end
    end

    if cast.sunfire(units.dyn45)
    then
      return true
    end

    --[[
    if mode.rotation == 3 or #enemies.yards40 == 1 then
      if single_rotation() then
        return true
      end
    end
    if mode.rotation == 2 or #enemies.yards40 > 1 then
      if aoe_rotation() then
        return true
      end
    end
  ]]

  end

  local function defensive()
    --Potion or Stone
    if isChecked("Potion/Healthstone") and php <= getValue("Potion/Healthstone") then
      if canUseItem(5512) then
        useItem(5512)
      elseif canUseItem(getHealthPot()) then
        useItem(getHealthPot())
      end
    end
    -- Renewal
    if isChecked("Renewal") and talent.renewal and php <= getValue("Renewal") then
      if cast.renewal("player") then
        return
      end
    end
    -- Barkskin
    if isChecked("Barkskin") and php <= getValue("Barkskin") then
      if cast.barkskin() then
        return
      end
    end
    -- Swiftmend
    if talent.restorationAffinity and isChecked("Swiftmend") and php <= getValue("Swiftmend") and charges.swiftmend.count() >= 1 then
      if cast.swiftmend("player") then
        return true
      end
    end
    -- Regrowth
    if isChecked("Regrowth") and not moving and php <= getValue("Regrowth") then
      if cast.regrowth("player") then
        return true
      end
    end
    -- Rebirth
    if isChecked("Rebirth") and cd.rebirth.remains() <= gcd and not isMoving("player") then
      if getOptionValue("Rebirth") == 1 then
        local tanks = getTanksTable()
        for i = 1, #tanks do
          local thisUnit = tanks[i].unit
          if UnitIsDeadOrGhost(thisUnit) and UnitIsPlayer(thisUnit) then
            if cast.rebirth(thisUnit, "dead") then
              return true
            end
          end
        end
      elseif getOptionValue("Rebirth") == 2 then
        for i = 1, #br.friend do
          local thisUnit = br.friend[i].unit
          if UnitIsDeadOrGhost(thisUnit) and UnitGroupRolesAssigned(thisUnit) == "HEALER" and UnitIsPlayer(thisUnit) then
            if cast.rebirth(thisUnit, "dead") then
              return true
            end
          end
        end
      elseif getOptionValue("Rebirth") == 3 then
        for i = 1, #br.friend do
          local thisUnit = br.friend[i].unit
          if UnitIsDeadOrGhost(thisUnit) and (UnitGroupRolesAssigned(thisUnit) == "TANK" or UnitGroupRolesAssigned(thisUnit) == "HEALER") and UnitIsPlayer(thisUnit) then
            if cast.rebirth(thisUnit, "dead") then
              return true
            end
          end
        end
      elseif getOptionValue("Rebirth") == 4 then
        if GetUnitExists("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover", "player") then
          if cast.rebirth("mouseover", "dead") then
            return true
          end
        end
      elseif getOptionValue("Rebirth") == 5 then
        for i = 1, #br.friend do
          local thisUnit = br.friend[i].unit
          if UnitIsDeadOrGhost(thisUnit) and UnitIsPlayer(thisUnit) then
            if cast.rebirth(thisUnit, "dead") then
              return true
            end
          end
        end
      end
    end

    -- Remove Corruption
    if isChecked("Remove Corruption") then
      if getOptionValue("Remove Corruption") == 1 then
        if canDispel("player", spell.removeCorruption) then
          if cast.removeCorruption("player") then
            return true
          end
        end
      elseif getOptionValue("Remove Corruption") == 2 then
        if canDispel("target", spell.removeCorruption) then
          if cast.removeCorruption("target") then
            return true
          end
        end
      elseif getOptionValue("Remove Corruption") == 3 then
        if canDispel("player", spell.removeCorruption) then
          if cast.removeCorruption("player") then
            return true
          end
        elseif canDispel("target", spell.removeCorruption) then
          if cast.removeCorruption("target") then
            return true
          end
        end
      elseif getOptionValue("Remove Corruption") == 4 then
        if canDispel("mouseover", spell.removeCorruption) then
          if cast.removeCorruption("mouseover") then
            return true
          end
        end
      elseif getOptionValue("Remove Corruption") == 5 then
        for i = 1, #br.friend do
          if canDispel(br.friend[i].unit, spell.removeCorruption) then
            if cast.removeCorruption(br.friend[i].unit) then
              return true
            end
          end
        end
      end
    end
  end

  local function interrupts()
    if useInterrupts() then
      for i = 1, #enemies.yards45 do
        local thisUnit = enemies.yards45[i]
        if canInterrupt(thisUnit, getValue("InterruptAt")) then
          -- Solar Beam
          if isChecked("Solar Beam") then
            if cast.solarBeam(thisUnit) then
              return
            end
          end
          -- Typhoon
          if isChecked("Typhoon") and talent.typhoon and getDistance(thisUnit) <= 15 then
            if cast.typhoon() then
              return
            end
          end
          -- Mighty Bash
          if isChecked("Mighty Bash") and talent.mightyBash and getDistance(thisUnit) <= 10 then
            if cast.mightyBash(thisUnit) then
              return true
            end
          end
        end
      end
    end

    if isChecked("Auto Soothe") then
      for i = 1, #enemies.yards45 do
        local thisUnit = enemies.yards45[i]
        if canDispel(thisUnit, spell.soothe) then
          if cast.soothe(thisUnit) then
            return true
          end
        end
      end
    end
  end

  local function PreCombat()
    -- Pre-Pull Timer
    if isChecked("Pre-Pull Timer") and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
      if PullTimerRemain() <= getOptionValue("Pre-Pull Timer") then
        if not br.player.buff.moonkinForm.exists() and not cast.last.moonkinForm(1) and not isMoving("player") then
          if cast.moonkinForm() then
            return true
          end
        end
        if cast.solarWrath() then
          return true
        end
      end
    end
  end
  local function extras()
    --Resurrection
    if isChecked("Revive target") and not inCombat and not isMoving("player") then
      if UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target", "player") then
        if cast.revive("target", "dead") then
          return true
        end
      end
    end
    -- Wild Growth
    if isChecked("OOC Wild Growth") and not isMoving("player") and php <= getValue("OOC Wild Growth") then
      if cast.wildGrowth() then
        return true
      end
    end
    -- Regrowth
    if isChecked("OOC Regrowth") and not isMoving("player") and php <= getValue("OOC Regrowth") then
      if cast.regrowth("player") then
        return true
      end
    end
    -- Shapeshift Form Management
    if isChecked("Auto Shapeshifts") then
      --and br.timer:useTimer("debugShapeshift", 0.25) then
      -- Flight Form
      if not inCombat and canFly() and not swimming and br.fallDist > 90 --[[falling > getOptionValue("Fall Timer")]] and level >= 58 and not buff.prowl.exists() then
        if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
          -- CancelShapeshiftForm()
          RunMacroText("/CancelForm")
          CastSpellByID(783, "player")
          return true
        else
          CastSpellByID(783, "player")
          return true
        end
      end
      -- Aquatic Form
      if (not inCombat --[[or getDistance("target") >= 10--]]) and swimming and not travel and not buff.prowl.exists() and isMoving("player") then
        if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
          -- CancelShapeshiftForm()
          RunMacroText("/CancelForm")
          CastSpellByID(783, "player")
          return true
        else
          CastSpellByID(783, "player")
          return true
        end
      end
      -- Travel Form
      if not inCombat and not swimming and br.player.level >= 58 and not buff.prowl.exists() and not travel and not IsIndoors() and IsMovingTime(1) then
        if GetShapeshiftForm() ~= 0 and not cast.last.travelForm() then
          RunMacroText("/CancelForm")
          CastSpellByID(783, "player")
          return true
        else
          CastSpellByID(783, "player")
          return true
        end
      end
      -- Cat Form
      if not cat and not IsMounted() and not flying and IsIndoors() then
        -- Cat Form when not swimming or flying or stag and not in combat
        if moving and not swimming and not flying and not travel then
          if cast.catForm("player") then
            return true
          end
        end
        -- Cat Form - Less Fall Damage
        if (not canFly() or inCombat or br.player.level < 58) and (not swimming or (not moving and swimming and #enemies.yards5 > 0)) and br.fallDist > 90 then
          --falling > getOptionValue("Fall Timer") then
          if cast.catForm("player") then
            return true
          end
        end
      end
    end -- End Shapeshift Form Management
  end

  -----------------
  --- Rotations ---
  -----------------
  -- Pause
  if (not IsMounted() or br.player.buff.travelForm.exists() or br.player.buff.flightForm.exists()) or mode.rotation == 4 then
    if pause() or drinking then
      return true
    else

      ---------------------------------
      --- Out Of Combat - Rotations ---
      ---------------------------------
      if not inCombat then
        if extras() then
          return true
        end
        if PreCombat() then
          return true
        end
      end
    end -- End Out of Combat Rotation
    -----------------------------
    --- In Combat - Rotations ---
    -----------------------------
    if inCombat then
      if not br.player.buff.moonkinForm.exists() and not cast.last.moonkinForm(1) and not isMoving("player") then
        if cast.moonkinForm() then
          return true
        end
      end
      if useInterrupts() then
        if interrupts() then
          return true
        end
      end
      if useDefensive() then
        if defensive() then
          return true
        end
      end
      if mode.rotation ~= 4 then
        if dps() then
          return true
        end
      end
    end -- End In Combat Rotation
  end -- Pause
end -- End runRotation

local id = 102
if br.rotations[id] == nil then
  br.rotations[id] = {}
end
tinsert(br.rotations[id], {
  name = rotationName,
  toggles = createToggles,
  options = createOptions,
  run = runRotation,
})
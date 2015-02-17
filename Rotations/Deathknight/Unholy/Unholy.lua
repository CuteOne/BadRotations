-- No BoS Support yet !!!
-- 2 different Rotations for Plague Leech / Defile and Unholy Blight / Necrotic Plague (Necroblight)
-- Rotation won't do anything if you choose another combination of talents!
-- AoE will only affect Bloodboil usage: Spread Diseases if there are 2 or more targets, spam Blood Boil as set in Options
-- use /uhopener or /uhopenernecro 5 seconds before Pull (if you want to have the perfect pull, press macro at 4+GCD seconds before pull)
-- Both opener will only start if: Army of the Dead is ready / Gargoyle is ready /  Pre-Pot is ready / You have a target
-- use /uhopenerreset or /uhopenernecroreset for emergency


if select(3,UnitClass("player")) == 6 then
  function UnholyDK()
    if currentConfig ~= "Unholy Chumii" then
      UnholyConfig();
      currentConfig = "Unholy Chumii";
    end
    UnholyToggles()
    GroupInfo()
    getRuneInfo()
    ------------------------------------------------------------------------------------------------------
    -- Locals --------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    local php = getHP("player")
    local power, powmax, powgen = getPower("player"), UnitPowerMax("player"), getRegen("player")
    local ttm = getTimeToMax("player")
    local enemies, enemiesList = #getEnemies("player",8), getEnemies("player",8)
    local GT = GetTime()
    local OUTBREAK_START, OUTBREAK_DURATION = GetSpellCooldown(_Outbreak)
    local OUTBREAK_COOLDOWN = (OUTBREAK_START - GT + OUTBREAK_DURATION)
    local SOULREAPER_START, SOULREAPER_DURATION = GetSpellCooldown(_SoulReaper)
    local SOULREAPER_COOLDOWN = (SOULREAPER_START - GT + SOULREAPER_DURATION)
    local BREATHOFSIN_START, BREATHOFSIN_DURATION = GetSpellCooldown(_BreathOfSindragosa)
    local BREATHOFSIN_COOLDOWN = (BREATHOFSIN_START - GT + BREATHOFSIN_DURATION)
    local DND_START, DND_DURATION = GetSpellCooldown(_DeathAndDecay)
    local DND_COOLDOWN = (DND_START - GT + DND_DURATION)
    local level = UnitLevel("player")
    --General Target Variables
    local tarUnit = {
      ["dyn0"] = "target", --No Dynamic
      ["dyn5"] = dynamicTarget(5,true), --Melee
      ["dyn10AoE"] = dynamicTarget(10,false), --Defensive Abilites
      ["dyn30"] = dynamicTarget(30,true), --Death Grip
      ["dyn30AoE"] = dynamicTarget(30,false), --Control Undead
    }
    local tarDist = {
      ["dyn0"] = getDistance("player",tarUnit.dyn0),
      ["dyn5"] = getDistance("player",tarUnit.dyn5),
      ["dyn10AoE"] = getDistance("player",tarUnit.dyn10AoE),
      ["dyn30"] = getDistance("player",tarUnit.dyn30),
      ["dyn30AoE"] = getDistance("player",tarUnit.dyn30AoE),
    }
    local thp = getHP(tarUnit.dyn5)
    local ttd = getTimeToDie(tarUnit.dyn5)
    local GCD = 1.5/(1+UnitSpellHaste("player")/100)
    local dRunes, bRunes, fRunes, uRunes = getRunes("death"), getRunes("blood") + getRunes("death"), getRunes("frost") + getRunes("death"), getRunes("unholy") + getRunes("death")
    local bPercent, fPercent, uPercent = getRunePercent("blood") + getRunes("death"), getRunePercent("frost") + getRunes("death"), getRunePercent("unholy") + getRunes("death")
    local bcStack = getBuffStacks("player",_BloodCharge,"player")
    local howRemain = getBuffRemain("player",_HornOfWinter)
    local empRemain = getBuffRemain("player",_EmpowerRuneWeapon)
    local dsRemain = getBuffRemain("player",_DarkSuccor)
    local amsRemain, amsCooldown = getBuffRemain("player",_AntiMagicShell), getSpellCD(_AntiMagicShell)
    local bosRemain, bosCooldown = getBuffRemain("player",_BreathOfSindragosa), getSpellCD(_BreathOfSindragosa)
    if getTalent(7,3) then
      if UnitDebuffID("target",_BreathOfSindragosaAura,"player") ~= nil then
        local bosDebuffRemain = getDebuffRemain("target",_BreathOfSindragosaAura,"player")
      else
        local bosDebuffRemain = nil
      end
    end
    local strPotRemain = getBuffRemain("player",156428)
    local srCooldown   = getSpellCD(_SoulReaper)
    local obCooldown   = getSpellCD(_Outbreak)
    local plCooldown   = getSpellCD(_PlagueLeech)
    local ubCooldown   = getSpellCD(_UnholyBlight)
    local dCooldown    = getSpellCD(_Defile)
    local raCooldown   = getSpellCD(_RaiseAlly)
    local dfCooldown   = getSpellCD(_Defile)
    local erwCooldown  = getSpellCD(_EmpowerRuneWeapon)
    --local suddendoom = getBuffRemain("player",_SuddenDoom)
    local PL           = getTalent(1,2)
    local UB           = getTalent(1,3)
    local BTap         = getTalent(4,1)
    local NP           = getTalent(7,1)
    local DEF          = getTalent(7,2)
    local BOS          = getTalent(7,3)
    --Specific Target Variables
    local ciRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_ChainsOfIce,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_ChainsOfIce,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_ChainsOfIce,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_ChainsOfIce,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_ChainsOfIce,"player"),
    }
    local ffRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_FrostFever,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_FrostFever,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_FrostFever,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_FrostFever,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_FrostFever,"player"),
    }
    local bpRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_BloodPlague,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_BloodPlague,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_BloodPlague,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_BloodPlague,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_BloodPlague,"player"),
    }
    local necRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_NecroticPlagueAura,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_NecroticPlagueAura,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_NecroticPlagueAura,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_NecroticPlagueAura,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_NecroticPlagueAura,"player"),
    }
    local hasDisease = {
      ["dyn0"] = ((ffRemain.dyn0>0 and bpRemain.dyn0>0) or necRemain.dyn0>0),
      ["dyn5"] = ((ffRemain.dyn5>0 and bpRemain.dyn5>0) or necRemain.dyn5>0),
      ["dyn10AoE"] = ((ffRemain.dyn10AoE>0 and bpRemain.dyn10AoE>0) or necRemain.dyn10AoE>0),
      ["dyn30"] = ((ffRemain.dyn30>0 and bpRemain.dyn30>0) or necRemain.dyn30>0),
      ["dyn30AoE"] = ((ffRemain.dyn30AoE>0 and bpRemain.dyn30AoE>0) or necRemain.dyn30AoE>0),
    }
    local necStacks = {
      ["dyn0"] = getDebuffStacks(tarUnit.dyn0,_NecroticPlagueAura,"player"),
      ["dyn5"] = getDebuffStacks(tarUnit.dyn5,_NecroticPlagueAura,"player"),
      ["dyn10AoE"] = getDebuffStacks(tarUnit.dyn10AoE,_NecroticPlagueAura,"player"),
      ["dyn30"] = getDebuffStacks(tarUnit.dyn30,_NecroticPlagueAura,"player"),
      ["dyn30AoE"] = getDebuffStacks(tarUnit.dyn30AoE,_NecroticPlagueAura,"player"),
  }
    ------------------------------------------------------------------------------------------------------
    -- Food/Invis Check ----------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if canRun() ~= true or UnitInVehicle("Player") then
      return false;
    end
    -- if IsMounted("player") then
    --   return false;
    -- end
    ------------------------------------------------------------------------------------------------------
    -- Pause ---------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isChecked("Pause Key") == true and SpecificToggle("Pause Key") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
    if isChecked("2nd Pause Key") == true and SpecificToggle("2nd Pause Key") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
    ------------------------------------------------------------------------------------------------------
    -- Spell Queue ---------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if _Queues == nil then
      _Queues = {
        [_BloodBoil]  = false,
      }
    end
    ------------------------------------------------------------------------------------------------------
    -- Input / Keys --------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    -- Defile
    if isKnown(_Defile) == true then
      if isChecked("DnD / Defile Key") == true and SpecificToggle("DnD / Defile Key") == true then
        if not IsMouselooking() then
          CastSpellByName(GetSpellInfo(43265))
          if SpellIsTargeting() then
            CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
            return true;
          end
        end
      end
    end
    -- DnD
    if isKnown(_Defile) == false then
      if isChecked("DnD / Defile Key") == true and SpecificToggle("DnD / Defile Key") == true then
        if not IsMouselooking() then
          CastSpellByName(GetSpellInfo(43265))
          if SpellIsTargeting() then
            CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
            return true;
          end
        end
      end
    end
    -- DnD
    if isKnown(_AntiMagicZone) == true then
      if isChecked("AMZ Key") == true and SpecificToggle("AMZ Key") == true then
        if not IsMouselooking() then
          CastSpellByName(GetSpellInfo(51052))
          if SpellIsTargeting() then
            CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
            return true;
          end
        end
      end
    end

    -- Opener --------------------------------------------------------------------------------------------
    if PL and DEF then
      unholyOpener()
    end
    if UB and NP then
      unholyOpenernecro()
    end
    ------------------------------------------------------------------------------------------------------
    -- Ress/Dispell --------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------
    -- Buffs ---------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isChecked("Horn of Winter") == true and (lastHOW == nil or lastHOW <= GetTime() - 5) then
      for i = 1, #nNova do
        if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{57330,19506,6673}) and (UnitInRange(nNova[i].unit) or UnitIsUnit(nNova[i].unit,"player")) then
          if castSpell("player",_HornOfWinter,true) then lastHOW = GetTime(); return; end
        end
      end
    end
    ------------------------------------------------------------------------------------------------------
    -- Out of Combat -------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if not isInCombat("player") then

    end -- Out of Combat end
    ------------------------------------------------------------------------------------------------------
    -- In Combat -----------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isInCombat("player") then
      ------------------------------------------------------------------------------------------------------
      -- Dummy Test ----------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if isChecked("DPS Testing") == true then
        if UnitExists("target") then
          if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
            StopAttack()
            ClearTarget()
            --print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
          end
        end
      end
      ------------------------------------------------------------------------------------------------------
      -- Queued Spells -------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------

      ------------------------------------------------------------------------------------------------------
      -- Defensive Cooldowns -------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if useDefensive() == true then
        -- Icebound Fortitude
        if isChecked("Icebound Fortitude") == true then
          if php <= getValue("Icebound Fortitude") then
            if castSpell("player",_IceboundFortitude,true) then
              return;
            end
          end
        end
        -- Anti Magic Shell
        if isChecked("Anti Magic Shell") == true then
          if php <= getValue("Anti Magic Shell") then
            if castSpell("player",_AntiMagicShell,true) then
              return;
            end
          end
        end
        -- Healthstone
        if isChecked("Healthstone / Potion") == true and php <= getValue("Healthstone / Potion")
          and isInCombat("player") and hasHealthPot() then
          if canUse(5512) then
            UseItemByName(tostring(select(1,GetItemInfo(5512))))
          elseif canUse(healPot) then
            UseItemByName(tostring(select(1,GetItemInfo(healPot))))
          end
        end
        -- Death Pact
        if isChecked("Death Pact") == true then
          if php <= getValue("Death Pact") then
            if castSpell("player",_DeathPact,true) then
              return
            end
          end
        end
        -- Death Siphon
        if isChecked("Death Siphon") == true then
          if php <= getValue("Death Siphon") then
            if castSpell("target",_DeathSiphon,false,false) then
              return;
            end
          end
        end
        -- Death Strike
        if isChecked("Death Strike") == true then
          if php <= getValue("Death Strike") then
            if castSpell("target",_DeathStrike,true) then
              return;
            end
          end
        end
        -- Death Strike
        if isChecked("Death Strike (Dark Succor)") == true then
          if UnitBuffID("player",_DarkSuccor) ~= nil then
            if php <= getValue("Death Strike (Dark Succor)") then
              if castSpell("target",_DeathStrike,true) then
                return;
              end
            end
          end
        end
        -- -- Death Strike (Dark Succor)
        -- if isChecked("Death Strike (Dark Succor)") == true then
        --   if UnitBuffID("player",_DarkSuccor) then
        --     if php <= getValue("Death Strike (Dark Succor)") then
        --       if castSpell("player",_DeathStrike,true) then
        --         return;
        --       end
        --     end
        --   end
        -- end
      end -- isChecked("Defensive Mode") end
      ------------------------------------------------------------------------------------------------------
      -- Offensive Cooldowns -------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if useCDs() == true then
        -- Orc / Troll Racial
        if isChecked("Racial (Orc/Troll)") then
          if select(2, UnitRace("player")) == "Troll" then
            if castSpell("player",26297,true) then
              return;
            end
          elseif select(2, UnitRace("player")) == "Orc" then
            if castSpell("player",20572,true) then
              return;
            end
          end
        end
        -- empower_rune_weapon,if=blood<1&unholy<1&frost<1
        -- if isChecked("Empower Rune Weapon") then
        --  if bRunes < 1 and uRunes < 1 and fRunes < 1 then
        --    if castSpell("player",_EmpowerRuneWeapon,true) then
        --      --print("ERW")
        --      return
        --    end
        --  end
        -- end
        --On use Trinkets
        if canTrinket(13) and useCDs() then
          RunMacroText("/use 13")
          if IsAoEPending() then
            local X,Y,Z = GetObjectPosition(Unit)
            CastAtPosition(X,Y,Z)
          end
        end
        if canTrinket(14) and useCDs() then
          RunMacroText("/use 14")
          if IsAoEPending() then
            local X,Y,Z = GetObjectPosition(Unit)
            CastAtPosition(X,Y,Z)
          end
        end
      end -- useCDs() end
      ------------------------------------------------------------------------------------------------------
      -- Do everytime --------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if not UnitExists("pet") then
        if castSpell("player",_RaiseDead,true) then
          --print("Call Pet")
          return
        end
      end
      ------------------------------------------------------------------------------------------------------
      -- Interrupts ----------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      -- Mind Freeze
      if isChecked("Mind Freeze") == true then
        castInterrupt(_MindFreeze, getValue("Mind Freeze"))
      end
      -- Mind Freeze
      if isChecked("Strangulate") == true then
        castInterrupt(_Strangulate, getValue("Strangulate"))
      end
      ------------------------------------------------------------------------------------------------------
      -- Rotation ------------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if PL and DEF then
      if openerstarted == false then
        ChatOverlay("PL_DEF", 0)
        -- actions.unholy=plague_leech,if=((cooldown.outbreak.remains<1)|disease.min_remains<1)&((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))
        if hasDisease.dyn30AoE and getDisease(30,true,"min")<1 and tarDist.dyn30AoE<30 then
          if obCooldown < 1 and ((bRunes < 1 and fRunes < 1) or (bRunes < 1 and uRunes < 1) or (fRunes < 1 and uRunes < 1)) then
            if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
              return
            end
          end
        end
        -- actions.unholy+=/soul_reaper,if=(target.health.pct-3*(target.health.pct%target.time_to_die))<=45
        if thp <= 45 then
          if (thp-3*(thp/ttd)<=45) and uRunes>=1 and tarDist.dyn5<5 then
            if castSpell(tarUnit.dyn5,_SoulReaper,false,false,false) then
              return
            end
          end
        end
        -- actions.unholy+=/blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
        if BTap then
          if (thp-3*(thp/ttd)<=45) and srCooldown == 0 then
            if bcStack >= 5 then
              if castSpell("player",_BloodTap,true) then
                return
              end
            end
          end
        end
        -- actions.unholy+=/summon_gargoyle
        if isChecked("Summon Gargoyle") and useCDs() then
          if castSpell("target",_SummonGargoyle,false,false) then
            return
          end
        end
        -- actions.unholy+=/outbreak,cycle_targets=1,if=(!talent.necrotic_plague.enabled&!(dot.blood_plague.ticking|dot.frost_fever.ticking))|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
        if (bpRemain.dyn30 == 0 or ffRemain.dyn30 == 0) and tarDist.dyn30AoE<30 then
          if castSpell(tarUnit.dyn30AoE,_Outbreak,true,false,false) then
            return
          end
        end
        -- actions.unholy+=/plague_strike,if=(!talent.necrotic_plague.enabled&!(dot.blood_plague.ticking|dot.frost_fever.ticking))|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
        if (bpRemain.dyn5 == 0 or ffRemain.dyn5 == 0) and uRunes >= 1 then
          if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
            return
          end
        end
        -- actions.unholy+=/blood_boil,cycle_targets=1,if=(!talent.necrotic_plague.enabled&!(dot.blood_plague.ticking|dot.frost_fever.ticking))|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
        if useAoE() then
          if enemies >= 2 then
            if canCast(_BloodBoil) then
              local unitDebuffed = false
              local unitNotDebuffed = false
              for i = 1, #enemiesTable do
                if GetObjectExists(enemiesTable[i].unit) then
                  if enemiesTable[i].distance < 8 then
                    if UnitDebuffID(enemiesTable[i].unit,55078,"player") then
                      unitDebuffed = true
                    else
                      unitNotDebuffed = true
                    end
                  end
                  if unitDebuffed == true and unitNotDebuffed == true then
                    if castSpell("player",_BloodBoil,true,false) then
                      --print("BB 1 AoE Spread Diseases")
                      return
                    end
                  end
                end
              end
            end
          end
        end
        -- actions.unholy+=/defile
        if useDefile() then
          if castGround("target",43265,6) then
            return
          end
        end
        -- actions.unholy+=/festering_strike,if=blood>1&frost>1
        if bRunes > 1 and fRunes > 1 then
          if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
            return
          end
        end
        -- actions.unholy+=/scourge_strike,if=((unholy>1|death>1)&active_enemies<=3)|(unholy>1&active_enemies>=4)
        if (enemies <= 3 and (uRunes > 1 or dRunes > 1)) or (uRunes > 1 and enemies >= 4) then
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            return
          end
        end
        -- actions.unholy+=/blood_boil,if=active_enemies>=4&death>=1
        if useAoE() then
          if enemies >= getValue("Blood Boil Spam") then
            if dRunes >= 1 then
              if tarDist.dyn10AoE<15 then
                if castSpell("player",_BloodBoil,true,false) then
                  return
                end
              end
            end
          end
        end
        -- actions.unholy+=/dark_transformation
        if castSpell("player",_DarkTransformation,true) then
          return
        end
        -- actions.unholy+=/blood_tap,if=buff.blood_charge.stack>10
        if bcStack > 10 then
          if castSpell("player",_BloodTap,true) then
            return
          end
        end
        -- actions.unholy+=/death_coil,if=(buff.sudden_doom.react|runic_power>80)&(buff.blood_charge.stack<=10)
        if (UnitBuffID("player",_SuddenDoom) or power > 80) and bcStack <= 10 then
          if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
            return
          end
        end
        -- actions.unholy+=/scourge_strike
        if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
          return
        end
        -- actions.unholy+=/festering_strike
        if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
          return
        end
        -- actions.unholy+=/death_coil
        if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
          return
        end
        -- actions.unholy+=/plague_leech
        if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
          return
        end
        -- actions.unholy+=/empower_rune_weapon
        if isChecked("Empower Rune Weapon") and useCDs() then
          if castSpell("player",_EmpowerRuneWeapon,true) then
            return
          end
        end
      end -- openerstarted end
      end -- PL_DEF end

      if UB and NP then
        if openernecrostarted == false then
          ChatOverlay("UB_NP", 0)
          -- actions.unholy=plague_leech,if=((cooldown.outbreak.remains<1)|disease.min_remains<1)&((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))
          if hasDisease.dyn30AoE and getDisease(30,true,"min")<1 and tarDist.dyn30AoE<30 then
            if obCooldown < 1 and ((bRunes < 1 and fRunes < 1) or (bRunes < 1 and uRunes < 1) or (fRunes < 1 and uRunes < 1)) then
              if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
                return
              end
            end
          end
          -- actions.unholy+=/soul_reaper,if=(target.health.pct-3*(target.health.pct%target.time_to_die))<=45
          if thp <= 45 then
            if (thp-3*(thp/ttd)<=45) and uRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_SoulReaper,false,false,false) then
                return
              end
            end
          end
          -- actions.unholy+=/blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
          if BTap then
            if (thp-3*(thp/ttd)<=45) and srCooldown == 0 then
              if bcStack >= 5 then
                if castSpell("player",_BloodTap,true) then
                  return
                end
              end
            end
          end
          -- actions.unholy+=/summon_gargoyle
          if isChecked("Summon Gargoyle") and useCDs() then
            if castSpell("target",_SummonGargoyle,false,false) then
              return
            end
          end
          -- actions.unholy+=/unholy_blight,if=(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
          if necRemain.dyn10AoE == 0 and getDistance("player","target") <= 5 then
            if castSpell("player",_UnholyBlight,true) then
              return
            end
          end
          -- actions.unholy+=/outbreak,cycle_targets=1,if=(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
          if necRemain.dyn30AoE == 0 and tarDist.dyn30AoE<30 then
            if castSpell(tarUnit.dyn30AoE,_Outbreak,true,false,false) then
              return
            end
          end
          -- actions.unholy+=/plague_strike,if=(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
          if necRemain.dyn5 == 0 and uRunes >= 1 then
            if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
              return
            end
          end
          -- actions.unholy+=/blood_boil,cycle_targets=1,if=(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
          if useAoE() then
            if enemies >= 2 then
              if canCast(_BloodBoil) then
                local unitDebuffed = false
                local unitNotDebuffed = false
                for i = 1, #enemiesTable do
                  if GetObjectExists(enemiesTable[i].unit) then
                    if enemiesTable[i].distance < 8 then
                      if UnitDebuffID(enemiesTable[i].unit,155159,"player") then
                        unitDebuffed = true
                      else
                        unitNotDebuffed = true
                      end
                    end
                    if unitDebuffed == true and unitNotDebuffed == true then
                      if castSpell("player",_BloodBoil,true,false) then
                        --print("BB 1 AoE Spread Diseases")
                        return
                      end
                    end
                  end
                end
              end
            end
          end
          -- actions.unholy+=/death_and_decay,if=active_enemies>1&unholy>1
          if useDefile() and #getEnemies("target",10) > 1 and uRunes > 1 then
            if castGround("target",43265,6) then
              return
            end
          end
          -- actions.unholy+=/festering_strike,if=blood>1&frost>1
          if bRunes > 1 and fRunes > 1 then
            if FSCount() > 0 then
              if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
                return
              end
            end
          end
          -- actions.unholy+=/scourge_strike,if=((unholy>1|death>1)&active_enemies<=3)|(unholy>1&active_enemies>=4)
          if (enemies <= 3 and (uRunes > 1 or dRunes > 1)) or (uRunes > 1 and enemies >= 4) then
            if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
              return
            end
          end
          -- actions.unholy+=/festering_strike,if=talent.necrotic_plague.enabled&talent.unholy_blight.enabled&dot.necrotic_plague.remains<cooldown.unholy_blight.remains%2
          if necRemain.dyn5 < (ubCooldown/2) then
            if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
              return
            end
          end
          -- actions.unholy+=/death_and_decay,if=active_enemies>1
          if useDefile() and #getEnemies("target",10) > 1 then
            if castGround("target",43265,6) then
              return
            end
          end
          -- actions.unholy+=/blood_boil,if=active_enemies>=4&death>=1
          if useAoE() then
            if enemies >= getValue("Blood Boil Spam") then
              if dRunes >= 1 then
                if tarDist.dyn10AoE<15 then
                  if castSpell("player",_BloodBoil,true,false) then
                    return
                  end
                end
              end
            end
          end
          -- actions.unholy+=/dark_transformation
          if castSpell("player",_DarkTransformation,true) then
            return
          end
          -- actions.unholy+=/outbreak,if=talent.necrotic_plague.enabled&debuff.necrotic_plague.stack<=14
          if necStacks.dyn30AoE <= 14 then
            if castSpell(tarUnit.dyn30AoE,_Outbreak,true,false,false) then
              return
            end
          end
          -- actions.unholy+=/blood_tap,if=buff.blood_charge.stack>10
          if bcStack > 10 then
            if castSpell("player",_BloodTap,true) then
              return
            end
          end
          -- actions.unholy+=/death_coil,if=(buff.sudden_doom.react|runic_power>80)&(buff.blood_charge.stack<=10)
          if (UnitBuffID("player",_SuddenDoom) or power > 80) and bcStack <= 10 then
            if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
              return
            end
          end
          -- actions.unholy+=/festering_strike
          if FSCount() > 0 then
            if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
              return
            end
          end
          -- actions.unholy+=/scourge_strike
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            return
          end
          -- actions.unholy+=/death_coil
          if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
            return
          end
          -- actions.unholy+=/plague_leech
          if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
            return
          end
          -- actions.unholy+=/empower_rune_weapon
          if isChecked("Empower Rune Weapon") and useCDs() then
            if castSpell("player",_EmpowerRuneWeapon,true) then
              return
            end
          end
        end -- openernecrostarted end
      end --UB_NP end

      if PL and BOS then
        PL_BOS()
      end

    end -- In Combat end
  end -- Spec End
end --DK End
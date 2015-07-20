if select(3, UnitClass("player")) == 2 then
  function PaladinProtection()
    -- Init if this is the first time we are running.
    if currentConfig ~= "Protection Gabbz & CML" then
      -- TEMP !
      protPaladin = cPaladin:new("Protection")
      --- TEMP
      PaladinProtToggles()
      PaladinProtOptions()
      if not (core and core.profile == "Protection") then
        PaladinProtFunctions()
      end
      core:ooc()
      core:update()

      currentConfig = "Protection Gabbz & CML"
    end

    -- Manual Input
    if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true
    end
    --if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
    --  return true
    --end
    if IsLeftAltKeyDown() then
      return true
    end

    if canRun() ~= true then
      return false
    end

    -- localising protCore functions stuff
    -- local with short names
    local buff,cd,mode,talent,glyph = core.buff,core.cd,core.mode,core.talent,core.glyph
    local holypower = core.holyPower
    if UnitAffectingCombat("player") then
      core:update()
    else
      core:ooc()
    end

    protPaladin:classUpdate()

    -- Buffs logic
    core:castBuffs()

    -- Only start if we and target is in combat or not in combat and pressing left control
    if UnitAffectingCombat("player") or protPaladin.inCombat --[[ or (not UnitAffectingCombat("player") and IsLeftControlKeyDown() )]] then

      -- actions=auto_attack
      if startAttackTimer == nil or startAttackTimer <= GetTime() - 1 then
        RunMacroText("/startattack")
      end

      -- make sure we have a seal(often removed by changing talents/glyph)
      -- Default: Insight
      if core.seal == 0 then
        if core:castSeal(2) then
          return
        end
      end

      core:survival()

      if core:castInterrupts() then
        return
      end

      -- we use defensive moves regardless of rotation
      -- actions+=/divine_protection,if=time<5|!talent.seraphim.enabled|(buff.seraphim.down&cooldown.seraphim.remains>5&cooldown.seraphim.remains<9)
      if core.combatLenght < 5 or not talent.seraphim or (buff.seraphim == 0 and cd.seraphim > 5 and cd.seraphim < 9) then
        core:castDivineProtection()
      end
      -- actions+=/guardian_of_ancient_kings,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down)
      if core.combatLenght < 5 or (buff.holyAvenger == 0 and buff.shieldOfTheRighteous == 0 and buff.divineProtection == 0) then
        core:castGuardianOfAncientKings()
      end
      -- actions+=/ardent_defender,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down)
      if core.combatLenght < 5  or (buff.holyAvenger == 0 and buff.shieldOfTheRighteous == 0 and buff.divineProtection == 0 and buff.guardianOfAncientKings == 0) then
        core:castArdentDefender()
      end
      -- actions+=/potion,name=draenic_armor,if=buff.shield_of_the_righteous.down&buff.seraphim.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down&buff.ardent_defender.down

      -- here we need a rotation selector
      if mode.rotation == 4 then
        if core.health > getValue("Max DPS HP") then
          rotationMode = 2
        elseif core.health < getValue("Max Survival HP") then
          rotationMode = 3
        else
          rotationMode = 1
        end
      else
        rotationMode = mode.rotation
      end

      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------

      -- # Standard survival priority list starts here
      if rotationMode == 1 then
        -- # This section covers off-GCD spells.
        -- actions+=/holy_avenger
        core:castHolyAvenger()
        -- actions+=/seraphim
        core:castSeraphim()
        -- actions+=/shield_of_the_righteous,if=buff.divine_purpose.react
        if buff.divinePurpose > 0 then
          core:holyPowerConsumers()
        end
        -- actions+=/shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)
        if (holypower == 5 or (holypower >= 3 and buff.holyAvenger > core.globalCooldown))
          and (not talent.seraphim or cd.seraphim > 5) or (holypower >= 3 and core.buff.bastionOfGlory > 0 and core.buff.bastionOfGlory < 3) then
          core:holyPowerConsumers()
        end

        -- # GCD-bound spells start here
        if talent.empoweredSeals then
          -- actions+=/seal_of_insight,if=!seal.insight&buff.uthers_insight.remains<cooldown.judgment.remains
          if core.seal ~= 2 and buff.uthersInsight < core.recharge.judgment and (mode.empS == 1 or mode.empS == 3) then
            if core:castSeal(2) then
              return
            end
          end
          -- actions+=/seal_of_righteousness,if=!seal.righteousness&buff.uthers_insight.remains>cooldown.judgment.remains&buff.liadrins_righteousness.down
          if core.seal ~= 1 and buff.uthersInsight > core.recharge.judgment
            and buff.liadrinsRighteousness < core.recharge.judgment and (mode.empS == 1 or mode.empS == 2) then
            if core:castSeal(1) then
              return
            end
          end
        end
        -- actions+=/avengers_shield,if=buff.grand_crusader.react&active_enemies>1&!glyph.focused_shield.enabled
        if buff.grandCrusader > 0 and core.aroundTarget7Yards > 1 and not glyph.focusedShield then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions+=/hammer_of_the_righteous,if=active_enemies>=3
        if core.aroundTarget7Yards >= 3 then
          if core:castHammerOfTheRighteous() then
            return
          end
        else
          -- actions+=/crusader_strike
          if core:castCrusaderStrike() then
            return
          end
        end
        -- actions+=/wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35
        if cd.crusaderStrike < 0.35 and getDistance("player",core.units.dyn5) < 5 and core.unitInFront then
          return
        end
        -- actions+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target
        -- actions+=/judgment
        if core:castJeopardy() then
          return
        end
        -- actions+=/wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35
        if cd.judgment < 0.35 then
          return
        end
        -- actions+=/avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled
        if core.aroundTarget7Yards > 1 and not glyph.focusedShield then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions+=/holy_wrath,if=talent.sanctified_wrath.enabled
        if talent.sanctifiedWrath then
          if core:castHolyWrath() then
            return
          end
        end
        -- actions+=/avengers_shield,if=buff.grand_crusader.react
        if buff.grandCrusader > 0 then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions+=/sacred_shield,if=target.dot.sacred_shield.remains<2
        if buff.sacredShield < 2 then
          if core:castSacredShield() then
            return
          end
        end
        -- actions+=/holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20
        if glyph.finalWrath and getHP(core.units.dyn8AoE) <= 20 then
          if core:castHolyWrath() then
            return
          end
        end
        -- actions+=/avengers_shield
        if core:castAvengersShield() then
          return
        end
        -- actions+=/lights_hammer,if=!talent.seraphim.enabled|buff.seraphim.remains>10|cooldown.seraphim.remains<6
        if core:castLightsHammer() then
          return
        end
        -- actions+=/holy_prism,if=!talent.seraphim.enabled|buff.seraphim.up|cooldown.seraphim.remains>5|time<5
        if core:castHolyPrism() then
          return
        end
        -- actions+=/consecration,if=target.debuff.flying.down&active_enemies>=3
        if core.melee9Yards >=3 then
          if core:castConsecration() then
            return
          end
        end
        -- actions+=/execution_sentence,if=!talent.seraphim.enabled|buff.seraphim.up|time<12
        if core:castExecutionSentence() then
          return
        end
        -- actions+=/hammer_of_wrath
        if core:castHammerOfWrath() then
          return
        end
        -- actions+=/sacred_shield,if=target.dot.sacred_shield.remains<8
        if buff.sacredShield < 8 then
          if core:castSacredShield() then
            return
          end
        end
        -- actions+=/consecration,if=target.debuff.flying.down
        if core:castConsecration() then
          return
        end
        -- actions+=/holy_wrath
        if core:castHolyWrath() then
          return
        end
        -- Seals
        if talent.empoweredSeals then
          -- actions+=/seal_of_insight,if=!seal.insight&buff.uthers_insight.remains<=buff.liadrins_righteousness.remains
          if core.seal ~= 2 then
            if buff.uthersInsight <= buff.liadrinsRighteousness and (mode.empS == 1 or mode.empS == 3) then
              if core:castSeal(2) then
                return
              end
            end
          end
          -- actions+=/seal_of_righteousness,if=!seal.righteousness&buff.liadrins_righteousness.remains<=buff.uthers_insight.remains
          if core.seal ~= 1 then
            if buff.liadrinsRighteousness <= buff.uthersInsight and (mode.empS == 1 or mode.empS == 2) then
              if core:castSeal(1) then
                return
              end
            end
          end
        end
        -- actions+=/sacred_shield
        if core:castSacredShield() then
          return
        end
      end

      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------

      -- # Max-DPS priority list starts here.
      if rotationMode == 2 then
        -- # This section covers off-GCD spells.
        -- actions.max_dps+=/holy_avenger
        core:castHolyAvenger()
        -- actions.max_dps+=/seraphim
        core:castSeraphim()
        -- actions.max_dps+=/shield_of_the_righteous,if=buff.divine_purpose.react
        if buff.divinePurpose > 0 then
          core:holyPowerConsumers()
        end
        -- actions.max_dps+=/shield_of_the_righteous,if=(holy_power>=5|talent.holy_avenger.enabled)&(!talent.seraphim.enabled|cooldown.seraphim.remains>5)
        -- actions.max_dps+=/shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)
        if (holypower == 5 or (holypower >= 3 and buff.holyAvenger > core.globalCooldown))
          and (not talent.seraphim or cd.seraphim > 5) or (holypower >= 3 and core.buff.bastionOfGlory > 0 and core.buff.bastionOfGlory < 3) then
          core:holyPowerConsumers()
        end
        -- # #GCD-bound spells start here.
        -- actions.max_dps+=/avengers_shield,if=buff.grand_crusader.react&active_enemies>1&!glyph.focused_shield.enabled
        if buff.grandCrusader > 0 and core.aroundTarget7Yards > 1 and not glyph.focusedShield then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions.max_dps+=/holy_wrath,if=talent.sanctified_wrath.enabled&(buff.seraphim.react|(glyph.final_wrath.enabled&target.health.pct<=20))
        if talent.sanctifiedWrath and (buff.seraphim > 0 or
          (glyph.finalWrath and getHP(core.units.dyn8AoE) <= 20)) then
          if core:castHolyWrath() then
            return
          end
        end
        -- actions.max_dps+=/hammer_of_the_righteous,if=active_enemies>=3
        if mode.aoe == 2 or (mode.aoe == 3 and core.aroundTarget7Yards >= 3) then
          if core:castHammerOfTheRighteous() then
            return
          end
        end
        -- actions.max_dps+=/judgment,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.down
        if talent.empoweredSeals and (core.seal == 1 and buff.liadrinsRighteousness == 0) then
          if core:castJeopardy() then
            return
          end
        end
        -- actions.max_dps+=/crusader_strike
        if core:castCrusaderStrike() then
          return
        end
        -- actions.max_dps+=/wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35
        if cd.crusaderStrike < 0.35 and getDistance("player",core.units.dyn5) < 5 and core.unitInFront then
          return
        end
        -- actions.max_dps+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target
        -- actions.max_dps+=/judgment
        if core:castJeopardy() then
          return
        end
        -- actions.max_dps+=/wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35
        if cd.judgment < 0.35 then
          return
        end
        -- actions.max_dps+=/avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled
        if core.aroundTarget7Yards > 1 and not glyph.focusedShield then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions.max_dps+=/holy_wrath,if=talent.sanctified_wrath.enabled
        if talent.sanctifiedWrath then
          if core:castHolyWrath() then
            return
          end
        end
        -- actions.max_dps+=/avengers_shield,if=buff.grand_crusader.react
        if buff.grandCrusader > 0 then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions.max_dps+=/execution_sentence,if=active_enemies<3
        if core.aroundTarget7Yards < 3 then
          if core:castExecutionSentence() then
            return
          end
        end
        -- actions.max_dps+=/holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20
        if glyph.finalWrath and getHP(self.units.dyn8AoE) <= 20 then
          if core:castHolyWrath() then
            return
          end
        end
        -- actions.max_dps+=/avengers_shield
        if core:castAvengersShield() then
          return
        end
        -- actions.max_dps+=/seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness
        if talent.empoweredSeals and core.seal ~= 1 and (mode.empS == 1 or mode.empS == 2) then
            if core:castSeal(1) then
              return
            end
        end
        -- actions.max_dps+=/lights_hammer
        if core:castLightsHammer() then
          return
        end
        -- actions.max_dps+=/holy_prism
        if core:castHolyPrism() then
          return
        end
        -- actions.max_dps+=/consecration,if=target.debuff.flying.down&active_enemies>=3
        if core.melee9Yards >= 3 then
          if core:castConsecration() then
            return
          end
        end
        -- actions.max_dps+=/execution_sentence
        if core:castExecutionSentence() then
          return
        end
        -- actions.max_dps+=/hammer_of_wrath
        if core:castHammerOfWrath() then
          return
        end
        -- actions.max_dps+=/consecration,if=target.debuff.flying.down
        if core:castConsecration() then
          return
        end
        -- actions.max_dps+=/holy_wrath
        if core:castHolyWrath() then
          return
        end
        -- actions.max_dps+=/sacred_shield
        if core:castSacredShield() then
          return
        end
        -- actions.max_dps+=/flash_of_light,if=talent.selfless_healer.enabled&buff.selfless_healer.stack>=3
        if talent.selflessHealer then
          if buff.selflessHealerStack == 3 then
            if core:castSelflessHealer() then
              return
            end
          end
        end
      end

      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------------------------------

      -- # Max survival priority list starts here
      if rotationMode == 3 then
        -- # Max survival priority list starts here
        -- # This section covers off-GCD spells.
        -- actions.max_survival+=/holy_avenger
        core:castHolyAvenger()
        -- actions.max_survival+=/seraphim,if=buff.divine_protection.down&cooldown.divine_protection.remains>0
        if buff.divineProtection == 0 and cd.divineProtection > 0 then
          core:castSeraphim()
        end
        -- actions.max_survival+=/shield_of_the_righteous,if=buff.divine_purpose.react
        if buff.divinePurpose > 0 then
          core:holyPowerConsumers()
        end
        -- actions.max_survival+=/shield_of_the_righteous,if=(holy_power>=5|incoming_damage_1500ms>=health.max*0.3)&(!talent.seraphim.enabled|cooldown.seraphim.remains>5)
        -- actions.max_survival+=/shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)
        if (holypower == 5 or (holypower >= 3 and buff.holyAvenger > core.globalCooldown))
          and (not talent.seraphim or cd.seraphim > 5) or (holypower >= 3 and core.buff.bastionOfGlory > 0 and core.buff.bastionOfGlory < 3) then
          core:holyPowerConsumers()
        end

        -- # #GCD-bound spells start here.
        -- actions.max_survival+=/hammer_of_the_righteous,if=active_enemies>=3
        if core.aroundTarget7Yards >= 3 then
          if core:castHammerOfTheRighteous() then
            return
          end
        else
          -- actions.max_survival+=/crusader_strike
          if core:castCrusaderStrike() then
            return
          end
        end
        -- actions.max_survival+=/wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35
        if cd.crusaderStrike < 0.35 and getDistance("player",core.units.dyn5) < 5 and core.unitInFront then
          return
        end
        -- actions.max_survival+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target
        -- actions.max_survival+=/judgment
        if core:castJeopardy() then
          return
        end
        -- actions.max_survival+=/wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35
        if cd.judgment < 0.35 then
          return
        end
        -- actions.max_survival+=/avengers_shield,if=buff.grand_crusader.react&active_enemies>1
        if buff.grandCrusader > 0 and core.aroundTarget7Yards > 1 then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions.max_survival+=/holy_wrath,if=talent.sanctified_wrath.enabled
        if talent.sanctifiedWrath then
          if core:castHolyWrath() then
            return
          end
        end
        -- actions.max_survival+=/avengers_shield,if=buff.grand_crusader.react
        if buff.grandCrusader > 0 then
          if core:castAvengersShield() then
            return
          end
        end
        -- actions.max_survival+=/sacred_shield,if=target.dot.sacred_shield.remains<2
        if buff.sacredShield < 2 then
          if core:castSacredShield() then
            return
          end
        end
        -- we want at least to keep uthersInsight
        -- NOTE: No longer in survial APL, but kept if seal=righteousness
        if talent.empoweredSeals then
          -- actions.max_survival+=/seal_of_insight,if=!seal.insight&buff.uthers_insight.remains<=buff.liadrins_righteousness.remains
          if core.seal ~= 2 then
            if buff.uthersInsight < core.recharge.judgment and (mode.empS == 1 or mode.empS == 3) then
              if core:castSeal(2) then
                return
              end
            end
          end
        end
        -- actions.max_survival+=/avengers_shield
        if core:castAvengersShield() then
          return
        end
        -- actions.max_survival+=/lights_hammer
        if core:castLightsHammer() then
          return
        end
        -- actions.max_survival+=/holy_prism
        if core:castHolyPrism() then
          return
        end
        -- actions.max_survival+=/consecration,if=target.debuff.flying.down&active_enemies>=3
        if core.melee9Yards >= 3 then
          if core:castConsecration() then
            return
          end
        end
        -- actions.max_survival+=/execution_sentence
        if core:castExecutionSentence() then
          return
        end
        -- actions.max_survival+=/flash_of_light,if=talent.selfless_healer.enabled&buff.selfless_healer.stack>=3
        if talent.selflessHealer then
          if buff.selflessHealerStack == 3 then
            if core:castSelflessHealer() then
              return
            end
          end
        end
        -- actions.max_survival+=/hammer_of_wrath
        if core:castHammerOfWrath() then
          return
        end
        -- actions.max_survival+=/sacred_shield,if=target.dot.sacred_shield.remains<8
        if buff.sacredShield < 8 then
          if core:castSacredShield() then
            return
          end
        end
        -- actions.max_survival+=/holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20
        if glyph.finalWrath and getHP(core.units.dyn8AoE) <= 20 then
          if core:castHolyWrath() then
            return
          end
        end
        -- actions.max_survival+=/consecration,if=target.debuff.flying.down&!ticking
        if core:castConsecration() then
          return
        end
        -- actions.max_survival+=/holy_wrath
        if core:castHolyWrath() then
          return
        end
        -- actions.max_survival+=/sacred_shield
        if core:castSacredShield() then
          return
        end
      end
    end
  end
end











--[[

    -- Only run rotation if we or our target is in combat.
    -- this should be handled by the dynamic target
      -- Locals Variables
      _HolyPower = UnitPower("player", 9) --ToDo: We should normalise the variables name, playerHP, buffDivine etc. _HolyPower is not consistent with the rest.
      playerHP = getHP("player")
      buffDivineCrusader = getBuffRemain("player",_DivineCrusader)
      buffHolyAvenger = getBuffRemain("player",_HolyAvenger)
      buffDivinePurpose = getBuffRemain("player",_DivinePurpose)
      buffGrandCrusader = getBuffRemain("player",85043) --Todo: Add this to spellist as _GrandCrusader, at the moment i dont know what hte purpose is of the differnt spelllist files
      buffSeraPhim = getBuffRemain("player",_Seraphim)
      sealOfTruth = GetShapeshiftForm() == 1 or nil
      sealOfRighteousness = GetShapeshiftForm() == 2 or nil
      sealOfInsight = GetShapeshiftForm() == 3 or nil



      -- function for handling units to attack
      ProtPaladinEnemyUnitHandler()

      --ProtPaladinFriendlyUnitHandler()

      -- If we are close to dying
      if ProtPaladinSurvivalSelf() then -- Check if we are close to dying and act accoridingly
        return true
      end

      -- If someone else is close to dying
      if ProtPaladinSurvivalOther() then -- Check if raidmember are close to dying and act accoridingly
        return
      end

      -- Interrupt
      if ProtPaladinInterrupt() then
        return true
      end
      -- Dispell Logics Todo, includes removal using Divine Shield and Hand of Protection
      if ProtPaladinDispell() then
        return true
      end

      -- If we are already casting then dont continue
      if castingUnit() then
        return false
      end

      if ProtPaladinControl("target") then
        return true
      end

      if ProtPaladinUtility() then
        --print("Casting Utility spell")
        return true
      end

      -- Check if we are missing any buffs
      if ProtPaladinBuffs() then -- Make sure that we are buffed, 2 modes, inCombat and Out Of Combat, Blessings, RF,
        return true
      end

      -- Handle the use of HolyPower
      if ProtPaladinHolyPowerConsumers() then
        -- Dont return since this is off GCD
        --print("We use HoPo now")
      end

      if ProtPaladinHolyPowerCreaters() then -- Handle the normal rotation
        --print("Something is cast within PowerCreaters")
        return true
      end
      --print("We did not do anything")
    end
  end
end]]

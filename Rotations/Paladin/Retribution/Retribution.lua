if select(3, UnitClass("player")) == 2 then
  function PaladinRetribution()
    if currentConfig ~= "Retribution Paladin" then --Where is currentConfig set? Is this only used for init?
      PaladinRetToggles() -- Setting up Toggles, AoE, Interrupt, Defensive CD, CD, Healing
      PaladinRetOptions() -- Reading Config values from gui?
      if not (core and core.profile == "Retribution") then
        PaladinRetFunctions()
      end

      core:ooc()
      core:update()
      currentConfig = "Retribution Paladin"
    end

    -- ToDo add pause toggle
    -- Manual Input
    if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true
    end
    if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
      return true
    end
    if IsLeftAltKeyDown() then
      return true
    end

    -- Food/Invis Check
    if canRun() ~= true then
      return false
    end

    -- localising retCore functions stuff
    -- local with short names
    local buff,cd,mode,talent,glyph = core.buff,core.cd,core.mode,core.talent,core.glyph
    local holypower = core.holyPower
    if UnitAffectingCombat("player") then
      core:update()
    else
      core:ooc()
    end

    -- Cast selected blessing or auto
    castBlessing()


    -- make sure we have a seal(often removed by changing talents/glyph)
    if core.seal == 0 then
      if core:castSeal(1) then
        return
      end
    end

    -- OFF-GCD here we add the spells we want to be spamming all the time
    if core.inCombat then
      -- Rebuke
      core:castRebuke()

      -- Divine Protection
      castDivineProtection()
    end

    -- GCD check -- it means we want off-gcd above
    if castingUnit() then
      return
    end

    -- Combats Starts Here
    if core.inCombat then
      -- Lay on Hands
      --castLayOnHands()
      -- Divine Shield
      if core:castDivineShield() then
        return
      end
      -- Selfless Healer
      if isChecked("Selfless Healer") and core:castSelfLessHealer() then
        return
      end
      -- Self Glory
      if isChecked("Self Glory") then
        core:castWordOfGlory()
      end
      --[[Always]]
      -- auto_attack
      if isInMelee() and getFacing("player","target") == true then
        RunMacroText("/startattack")
      end
      castCrowdControl("any",105593,20)
      -- execution_sentence
      if core:castExecutionSentence(core.units.dyn40) then
        return
      end
      -- lights_hammer (off gcd)
      if core:castLightsHammer() then
        return
      end
      -- Holy Avenger (off gcd)
      core:castHolyAvenger()
      -- Avenging Wrath (off gcd)
      core:castAvengingWrath()
      -- holy_prism 2+
      if core:castHolyPrism(2) then
        return
      end
      -- seraphim
      if core:castSeraphim() then
        return
      end
      --[[Single(1-2)]]
      ----------------
      -- Single 1-2 --
      ----------------
      if (core.melee8Yards < 3  and mode.aoe == 4) or mode.aoe == 1 then
        -- divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
        if (buff.divineCrusader > 0 and holypower == 5 and buff.finalVerdict > 0)
          -- divine_storm,if=buff.divine_crusader.react&holy_power=5&active_enemies=2&!talent.final_verdict.enabled
          or (buff.divineCrusader > 0 and holypower == 5 and core.melee8Yards == 2 and not talent.finalVerdict)
          -- divine_storm,if=holy_power=5&active_enemies=2&buff.final_verdict.up
          or (holypower == 5 and core.melee16Yards == 2 and buff.finalVerdict > 0)
          -- divine_storm,if=buff.divine_crusader.react&holy_power=5&(talent.seraphim.enabled&cooldown.seraphim.remains<=4)
          or (holypower == 5 and core.melee8Yards == 2 and talent.seraphim and cd.seraphim <= 4) then
          if core:castDivineStorm() then
            return
          end
        end
        -- templars_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
        if holypower == 5
          or ((buff.holyAvenger > 0 and holypower >= 3) and (not talent.seraphim or cd.seraphim > 4))
          -- templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<4
          or (buff.divinePurpose > 0 and buff.divinePurpose < 4) then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<4&!talent.final_verdict.enabled
        if buff.divineCrusader > 0 and buff.divineCrusader < 4 and not talent.finalVerdict then
          if core:castDivineStorm() then
            return
          end
        end
        if talent.finalVerdict
          -- final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
          and (holypower == 5 or (buff.holyAvenger > 1 and holypower >= 3)
          -- final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<4
          or (buff.divinePurpose > 0 and buff.divinePurpose < 4)) then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- hammer_of_wrath
        if core:castHammerOfWrath() then
          return
        end
        -- templars verdict to dump holy power if avenging wrath up
        if holypower >= 4 and buff.avengingWrath > 0 then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- judgment,if=talent.empowered_seals.enabled&((seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration*2)
        if talent.empoweredSeals then
          if (core.seal == true and buff.maraadsTruth < core.recharge.judgment*2)
            -- |(seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration*2))
            or (core.seal == false and buff.liadrinsRighteousness < core.recharge.judgment*2) then
            if core:castJudgment() then
              return
            end
          end
        end
        -- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
        if buff.blazingContempt and holypower <= 2 then
          if core:castExorcism() then
            return
          end
        end
        -- seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<(cooldown.judgment.duration)&buff.maraads_truth.remains<=3
        if talent.empoweredSeals then
          if core.seal ~= true and buff.maraadsTruth < core.recharge.judgment and cd.judgment <= 3 then
            if core:castSeal(1) then
              return
            end
          end
        end
        -- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
        if buff.divineCrusader > 0 and buff.finalVerdict > 0 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) then
          if core:castDivineStorm() then
            return
          end
        end
        -- final_verdict,if=buff.divine_purpose.react|target.health.pct<35
        if talent.finalVerdict and buff.divinePurpose > 0 or getHP(core.units.dyn5) < 35 then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- templars_verdict,if=buff.avenging_wrath.up|target.health.pct<35&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
        if (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and (not talent.seraphim or cd.seraphim > 4) then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- crusader_strike
        if core:castCrusaderStrike() then
          return
        end
        -- divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
        if buff.divineCrusader > 0 and (buff.avengingWrath > 0 or getHP(core.units.dyn5) < 35) and not talent.finalVerdict then
          if core:castDivineStorm() then
            return
          end
        end
        -- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
        if buff.divineCrusader > 0 and buff.finalVerdict > 0 then
          if core:castDivineStorm() then
            return
          end
        end
        -- final_verdict
        if talent.finalVerdict then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<(cooldown.judgment.duration)&buff.liadrins_righteousness.remains<=3
        if talent.empoweredSeals then
          if buff.maraadsTruth > 10 and core.seal == true
            and buff.liadrinsRighteousness < core.recharge.judgment
            and cd.judgment <= 3 then
            if core:castSeal(2) then
              return
            end
          end
        end
        -- judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled
        if glyph.doubleJeopardy then
          if core:castJeopardy() then
            return
          end
        end
        -- judgment
        core:castJudgment()
        -- templars_verdict,if=buff.divine_purpose.react
        if buff.divinePurpose > 0 then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
        if buff.divineCrusader > 0 and not talent.finalVerdict and (not talent.seraphim or cd.seraphim < 4) then
          if core:castDivineStorm() then
            return
          end
        end
        -- templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
        if holypower >= 4 and (not talent.seraphim or cd.seraphim > 4) then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- exorcism
        if core:castExorcism() then
          return
        end
        -- templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
        if holypower >= 3 and (not talent.seraphim or cd.seraphim > 4) then
          if core:castTemplarsVerdict() then
            return
          end
        end
        -- holy_prism 1
        if core:castHolyPrism(1) then
          return
        end
        -- seal fillers
        if talent.empoweredSeals then
          if not core.seal ~= true and buff.maraadsTruth < 7 then
            if core:castSeal(1) then
              return
            end
          end
          if core.seal == true and buff.maraadsTruth > 7 and buff.liadrinsRighteousness < 7 then
            if core:castSeal(2) then
              return
            end
          end
        end
        ----------------
        -- Cleave 3-4 --
        ----------------
      elseif (core.melee8Yards < 5  and mode.aoe == 4) or mode.aoe == 2 then
        --[[Cleave(3-4)]]
        -- final_verdict,if=buff.final_verdict.down&holy_power=5
        if talent.finalVerdict then
          if buff.finalVerdict == 0 and holypower == 5 then
            if core:castTemplarsVerdict(core.units.dyn5) then
              return
            end
          end
        end
        -- divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
        if buff.divineCrusader > 0 and holypower == 5 and buff.finalVerdict > 0 then
          if core:castDivineStorm() then
            return
          end
        end
        -- divine_storm,if=holy_power=5&buff.final_verdict.up
        if holypower == 5 and buff.finalVerdict > 0 then
          if core:castDivineStorm() then
            return
          end
        end
        -- divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
        if buff.divineCrusader > 0 and holypower == 5 and not talent.finalVerdict then
          if core:castDivineStorm() then
            return
          end
        end
        -- divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)&!talent.final_verdict.enabled
        if holypower == 5 and (not talent.seraphim or cd.seraphim > 4) and not talent.finalVerdict then
          if core:castDivineStorm() then
            return
          end
        end
        -- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
        if buff.blazingContempt and holypower <= 2 and buff.holyAvenger == 0 then
          if core:castExorcism() then
            return
          end
        end
        -- hammer_of_wrath
        core:castHammerOfWrath()
        -- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
        if talent.empoweredSeals then
          if core.seal == false and buff.liadrinsRighteousness <= 5 then
            if core:castJudgment() then
              return
            end
          end
        end
        -- divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>6)&!talent.final_verdict.enabled
        if holypower >= 4 and (not talent.seraphim or cd.seraphim > 6) and not talent.finalVerdict then
          if core:castDivineStorm() then
            return
          end
        end
        -- crusader_strike
        -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
        --castStrike()
        if core:castHammerOfTheRighteous() then
          return
        end

        -- divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>7)&!talent.final_verdict.enabled
        if holypower >= 3 and (not talent.seraphim or cd.seraphim > 7) and not talent.finalVerdict then
          if core:castDivineStorm() then
            return
          end
        end
        -- final_verdict,if=buff.final_verdict.down
        if buff.finalVerdict == 0 then
          if core:castTemplarsVerdict(core.units.dyn5) then
            return
          end
          -- divine_storm,if=buff.final_verdict.up
        elseif core:castDivineStorm() then
          return
        end
        -- holy_prism,target=self
        if core:castHolyPrism(2) then
          return
        end
        -- exorcism,if=glyph.mass_exorcism.enabled
        if glyph.massExorcism then
          if core:castExorcism() then
            return
          end
        end
        -- judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled
        if glyph.doubleJeopardy then
          if core:castJeopardy() then
            return
          end
        end
        -- judgment
        if core:castJudgment(core.units.dyn5) then
          return
        end
        -- exorcism
        if core:castExorcism() then
          return
        end
        ------------
        -- AoE 5+ --
        ------------
      elseif (core.melee8Yards >= 5 and mode.aoe == 4) or mode.aoe == 3 then
        --[[AoE(5+)]]
        -- divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>4)
        if holypower == 5 and (not talent.seraphim or cd.seraphim > 4) then
          if core:castDivineStorm() then
            return
          end
        end
        -- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
        if buff.blazingContempt and holypower <= 2 and buff.holyAvenger == 0 then
          if castExorcism() then
            return
          end
        end
        -- hammer_of_wrath
        if core:castHammerOfWrath() then
          return
        end
        -- hammer_of_the_righteous
        -- We use either Crusader Strike or Hammer of Right dependent on how many unfriendly
        if core:castHammerOfTheRighteous() then
          return true
        end

        -- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<=5
        if talent.empoweredSeals then
          if core.seal == false and buff.liadrinsRighteousness <= 5 then
            if core:castJudgment() then
              return
            end
          end
        end
        -- divine_storm,if=(!talent.seraphim.enabled|cooldown.seraphim.remains>6)
        if not talent.seraphim or cd.seraphim > 6 then
          if core:castDivineStorm() then
            return
          end
        end
        -- exorcism,if=glyph.mass_exorcism.enabled
        if glyph.massExorcism then
          if core:castExorcism() then
            return
          end
        end
        -- holy_prism,target=self
        if core:castHolyPrism(1) then
          return
        end
        -- judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled
        if glyph.doubleJeopardy and core:castJeopardy() then
          return
        end
        -- judgment
        if core:castJudgment() then
          return
        end
        -- exorcism
        if core:castExorcism() then
          return
        end
      end
    end
  end
end

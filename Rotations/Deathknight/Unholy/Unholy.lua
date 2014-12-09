if select(3,UnitClass("player")) == 6 then
  function UnholyDK()
    if currentConfig ~= "Unholy Chumii" then
      UnholyConfig();
      currentConfig = "Unholy Chumii";
    end
    UnholyToggles()
    GroupInfo();
  ------------------------------------------------------------------------------------------------------
  -- Locals --------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    local runicPower = UnitPower("player")
    local runesBlood = getRunes("blood")
    local runesUnholy = getRunes("unholy")
    local runesFrost = getRunes("frost")
    local runesDeath = getRunes("death")
  ------------------------------------------------------------------------------------------------------
  -- Food/Invis Check ----------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if canRun() ~= true or UnitInVehicle("Player") then
      return false;
    end
    if IsMounted("player") then
      return false;
    end
  ------------------------------------------------------------------------------------------------------
  -- Pause ---------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
  ------------------------------------------------------------------------------------------------------
  -- Spell Queue ---------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if _Queues == nil then
     _Queues = {
     }
    end
  ------------------------------------------------------------------------------------------------------
  -- Input / Keys --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------
  -- Ress/Dispell --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------

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
      if isChecked("DPS Testing") then
        if UnitExists("target") then
          if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
            StopAttack()
            ClearTarget()
            print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
          end
        end
      end
  ------------------------------------------------------------------------------------------------------
  -- Queued Spells -------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------
  -- Defensive Cooldowns -------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if useDefCDs() == true then

      end -- isChecked("Defensive Mode") end
  ------------------------------------------------------------------------------------------------------
  -- Offensive Cooldowns -------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if useCDs() == true then

      end -- useCDs() end
  ------------------------------------------------------------------------------------------------------
  -- Do everytime --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------
  -- Interrupts ----------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------
  -- Rotation ------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if not useAoE() then
        -- actions.single_target=plague_leech,if=cooldown.outbreak.remains<1
        if getSpellCD(_Outbreak) < 1 then
          if castSpell("target",_PlagueLeech,false,false) then
            return
          end
        end
        -- actions.single_target+=/plague_leech,if=!talent.necrotic_plague.enabled&(dot.blood_plague.remains<1&dot.frost_fever.remains<1)
        -- actions.single_target+=/plague_leech,if=talent.necrotic_plague.enabled&(dot.necrotic_plague.remains<1)
        -- actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=45
        -- actions.single_target+=/blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=45&cooldown.soul_reaper.remains=0)
        -- actions.single_target+=/summon_gargoyle
        -- actions.single_target+=/death_coil,if=runic_power>90
        -- actions.single_target+=/defile
        -- actions.single_target+=/dark_transformation
        -- actions.single_target+=/unholy_blight,if=!talent.necrotic_plague.enabled&(dot.frost_fever.remains<3|dot.blood_plague.remains<3)
        -- actions.single_target+=/unholy_blight,if=talent.necrotic_plague.enabled&dot.necrotic_plague.remains<1
        -- actions.single_target+=/outbreak,if=!talent.necrotic_plague.enabled&(!dot.frost_fever.ticking|!dot.blood_plague.ticking)
        -- actions.single_target+=/outbreak,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
        -- actions.single_target+=/plague_strike,if=!talent.necrotic_plague.enabled&(!dot.blood_plague.ticking|!dot.frost_fever.ticking)
        -- actions.single_target+=/plague_strike,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
        -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
        -- actions.single_target+=/run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
        -- actions.single_target+=/death_and_decay,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
        -- actions.single_target+=/scourge_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
        -- actions.single_target+=/festering_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<76&talent.breath_of_sindragosa.enabled
        -- actions.single_target+=/death_and_decay,if=unholy=2
        -- actions.single_target+=/blood_tap,if=unholy=2&cooldown.death_and_decay.remains=0
        -- actions.single_target+=/scourge_strike,if=unholy=2
        -- actions.single_target+=/death_coil,if=runic_power>80
        -- actions.single_target+=/festering_strike,if=blood=2&frost=2
        -- actions.single_target+=/death_and_decay
        -- actions.single_target+=/blood_tap,if=cooldown.death_and_decay.remains=0
        -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>10&(buff.sudden_doom.react|(buff.dark_transformation.down&rune.unholy<=1))
        -- actions.single_target+=/death_coil,if=buff.sudden_doom.react|(buff.dark_transformation.down&rune.unholy<=1)
        -- actions.single_target+=/scourge_strike,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=45)|(unholy>=1&death>=1)|(death>=2)
        -- actions.single_target+=/festering_strike
        -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>=10&runic_power>=30
        -- actions.single_target+=/death_coil
        -- actions.single_target+=/plague_leech
        -- actions.single_target+=/empower_rune_weapon
      end --single end
  -- AoE -----------------------------------------------------------------------------------------------
      if useAoE() then

      end --aoe end
    end -- In Combat end
  end -- Spec End
end --DK End
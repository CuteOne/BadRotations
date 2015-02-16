if select(3,UnitClass("player")) == 1 then

  function ProtectionWarrior()

    if currentConfig ~= "Protection Cpoworks" then
      WarriorProtToggles()
      WarriorProtOptions()
      if not (core and core.profile == "Protection") then
        ProtWarriorFunctions()
      end
      core:ooc()
      core:update()
      currentConfig = "Protection Cpoworks";
    end

    if canRun() ~= true then
      return false
    end

    if isChecked("Pause Key") and SpecificToggle("Pause Key") == true then
        ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
      end

      if isChecked("Heroic Leap Key") and SpecificToggle("Heroic Leap Key") == true then
      if not IsMouselooking() then
        CastSpellByName(GetSpellInfo(6544))
        if SpellIsTargeting() then
          CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
          return true;
        end
      end
    end
    if isChecked("Ravager Key") and SpecificToggle("Ravager Key") == true then
      if not IsMouselooking() then
        CastSpellByName(GetSpellInfo(152277))
        if SpellIsTargeting() then
          CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
          return true;
        end
      end
    end

    if isChecked("Mocking Banner Key") and SpecificToggle("Mocking Banner Key") == true then
      if not IsMouselooking() then
        CastSpellByName(GetSpellInfo(114192))
        if SpellIsTargeting() then
          CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
          return true;
        end
      end
    end

    -- localising protCore functions stuff
    -- local with short names
    local buff,cooldown,mode,talent,glyph = core.buff,core.cd,core.mode,core.talent,core.glyph

    if UnitAffectingCombat("player") then
      core:update()
    else
      core:ooc()
    end

    -- Buffs logic
    core:castBuffs()

    -- Only start if we and target is in combat
    if UnitAffectingCombat("player")  then

      -- actions=auto_attack
      if startAttackTimer == nil or startAttackTimer <= GetTime() - 1 then
        RunMacroText("/startattack")
      end

      -- here we need a rotation selector
      if mode.aoe == 3 then
        if core.melee5Yards >= 3 then
          rotationMode = 2
        else
          rotationMode = 1
        end
      else
        rotationMode = mode.aoe
      end




      --Gladiator
      if core.stance ==1 then
      --avatar
      --bloodbath
      --shield_charge,if=(!buff.shield_charge.up&!cooldown.shield_slam.remains)|charges=2
      -- TODO add shieldcharge charge support
      --if (buff.ShieldCharge == 0 and Cooldown.ShieldSlam == 0) then
      --  core:castShieldCharge
      --end
      --berserker_rage,if=buff.enrage.down
      --if buff.Enrage = 0 then
      --  core:castBerserkerRage
      --end
      --heroic_strike,if=(buff.shield_charge.up|(buff.unyielding_strikes.up&rage>=50-buff.unyielding_strikes.stack*5))&target.health.pct>20

      --heroic_strike,if=buff.ultimatum.up|rage>=rage.max-20|buff.unyielding_strikes.stack>4|target.time_to_die<10

      --call_action_list,name=single,if=active_enemies=1
      --call_action_list,name=aoe,if=active_enemies>=2

      end

      -- Protection
      if core.stance == 2 then
        --shield_block,if=!(debuff.demoralizing_shout.up|buff.ravager.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up)
        -- TODO add Demo Shout
        if getValue("Block or Barrier") == 1 then
          if not (buff.Ravager > 0 or buff.ShieldWall > 0 or buff.LastStand > 0 or buff.EnragedRegeneration > 0 or buff.ShieldBlock > 0) then
            core:castShieldBlock()
          end
          --shield_barrier,if=buff.shield_barrier.down&((buff.shield_block.down&action.shield_block.charges_fractional<0.75)|rage>=85)
          if buff.ShieldBarrier == 0 and (core.rage >= 85) then
            core:castShieldBarrier()
          end
        end

        if getValue("Block or Barrier") == 2 then
          if buff.ShieldBarrier == 0 and (core.rage >= 60) then
            core:castShieldBarrier()
          end
        end

        if mode.defensive == 1 then
          core:useHealthstone()
          core:castLastStand()
          core:castShieldWall()
          core:castEnragedRegeneration()
        end

        if mode.interupt == 1 then

        end

        --AoE Rotation
        if rotationMode == 2 then
          --bloodbath
          core:castBloodbath()
          --avatar
          core:castAvatar()
          --thunder_clap,if=!dot.deep_wounds.ticking
          if not UnitDebuffID("target", 115767) then
            core:castThunderClap()
          end
          --heroic_strike,if=buff.ultimatum.up|rage>110|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
          if buff.Ultimatum > 0 or core.rage > 110 or (talent.UnyieldingStrikes and buff.UnyieldingStrikesStack >= 6) then
            core:castHeroicStrike()
          end
          --shield_slam,if=buff.shield_block.up
          if buff.ShieldBlock > 0 then
            core:castShieldSlam()
          end
          --ravager,if=(buff.avatar.up|cooldown.avatar.remains>10)|!talent.avatar.enabled
          core:castRavager()
          --dragon_roar,if=(buff.bloodbath.up|cooldown.bloodbath.remains>10)|!talent.bloodbath.enabled
          if (buff.Bloodbath > 0 or cooldown.Bloodbath > 10) or not talent.Bloodbath then
            core:castDragonRoar()
          end
          --shockwave
          core:castShockwave()
          --revenge
          core:castRevenge()
          --thunder_clap
          core:castThunderClap()
          --bladestorm
          core:castBladestorm()
          --shield_slam
          core:castShieldSlam()
          --storm_bolt
          core:castStormBolt()
          --shield_slam
          core:castShieldSlam()
          --execute,if=buff.sudden_death.react
          if buff.SuddenDeath > 0 then
            core:castExecute()
          end
          --devastate
          core:castDevastate()
        end

        -- Single Target
        if rotationMode == 1 then
          --heroic_strike,if=buff.ultimatum.up|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
          if buff.Ultimatum > 0 or (talent.UnyieldingStrikes and buff.UnyieldingStrikesStack >= 6) then
            core:castHeroicStrike()
          end

          --bloodbath,if=talent.bloodbath.enabled&((cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(cooldown.storm_bolt.remains=0&talent.storm_bolt.enabled)|talent.shockwave.enabled)
          if talent.Bloodbath and ((cooldown.DragonRoar == 0 and talent.DragonRoar) or (cooldown.StormBolt == 0 and talent.StormBolt) or talent.Shockwave) then
            core:castBloodbath()
          end
          --avatar,if=talent.avatar.enabled&((cooldown.ravager.remains=0&talent.ravager.enabled)|(cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(talent.storm_bolt.enabled&cooldown.storm_bolt.remains=0)|(!(talent.dragon_roar.enabled|talent.ravager.enabled|talent.storm_bolt.enabled)))

          --shield_slam
          core:castShieldSlam()
          --revenge
          core:castRevenge()
          --ravager
          core:castRavager()
          --storm_bolt
          core:castStormBolt()
          --dragon_roar
          core:castDragonRoar()

          --impending_victory,if=talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
          --victory_rush,if=!talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time

          --execute,if=buff.sudden_death.react
          if buff.SuddenDeath > 0 then
            core:castExecute()
          end
          --devastate
          core:castDevastate()
        end
      end
    end

  end -- ArmsWarrior() end
end -- Class Check end
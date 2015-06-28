if select(3,UnitClass("player")) == 1 then

  function ArmsWarrior()

    if currentConfig ~= "Arms Chumii" then
      WarriorArmsConfig();
      currentConfig = "Arms Chumii";
    end
    WarriorArmsToggles();
    GroupInfo();
    ------------------------------------------------------------------------------------------------------
    -- Locals --------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    -- Player / Target values
    local rage = UnitPower("player")
    local php  = getHP("player")
    local thp  = getHP("target")
    -- Talents
    local enragedregen          = getTalent(2,1)
    local impvic                = getTalent(2,3)
    local slam                  = getTalent(3,3)
    local stormbolt             = getTalent(4,1)
    local dragonroar            = getTalent(4,3)
    local massreflect           = getTalent(5,1)
    local safeguard             = getTalent(5,2)
    local avatar                = getTalent(6,1)
    local bloodbath             = getTalent(6,2)
    local bladestorm            = getTalent(6,3)
    local ravager               = getTalent(7,2)
    local siegebreaker          = getTalent(7,3)
    local GT                    = GetTime()
    -- local CS_START, CS_DURATION = GetSpellCooldown(_ColossusSmash)
    -- local CS_COOLDOWN           = (CS_START - GT + CS_DURATION)
    -- local RV_START, RV_DURATION = GetSpellCooldown(_Ravager)
    -- local RV_COOLDOWN           = (RV_START - GT + RV_DURATION)
    -- local BLADESTORM            = UnitBuffID("player",_Bladestorm)
    local suddendeathup					= UnitBuffID("player",_SuddenDeathProc)
    local reckup								= UnitBuffID("player",_Recklessness)
    local bbathup								= UnitBuffID("player",_Bloodbath)
    local csup                  = UnitDebuffID("target",_ColossusSmash)
    local rendup                = UnitDebuffID("target",_Rend,"player")
    -- Dynamic Targeting
    local tarUnit = {
      ["dyn0"]      = "target", --No Dynamic
      ["dyn5"]      = dynamicTarget(5,true), --Melee
      ['dyn8AoE']   = dynamicTarget(8,false), -- BladeStorm
      ["dyn10"]     = dynamicTarget(10,true),
      ["dyn30"]  		= dynamicTarget(30,true), -- StormBolt
      ["dyn25AoE"]  = dynamicTarget(25,false),
      ["dyn40AoE"]  = dynamicTarget(40,false),
    }
    local tarDist = {
      ["dyn0"]      = getDistance("player",tarUnit.dyn0),
      ["dyn5"]      = getDistance("player",tarUnit.dyn5),
      ["dyn8AoE"]   = getDistance("player",tarUnit.dyn8AoE),
      ["dyn10"]     = getDistance("player",tarUnit.dyn10),
      ["dyn20AoE"]  = getDistance("player",tarUnit.dyn20AoE),
      ["dyn25AoE"]  = getDistance("player",tarUnit.dyn25AoE),
      ["dyn40AoE"]  = getDistance("player",tarUnit.dyn40AoE),
    }
    -- Debuffs
    local rendRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_Rend,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_Rend,"player"),
    }
    local csRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_ColossusSmash,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_ColossusSmash,"player"),
      ["dyn8AoE"] = getDebuffRemain(tarUnit.dyn8AoE,_ColossusSmash,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_ColossusSmash,"player"),
    }
    local bbRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_Bloodbath,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_Bloodbath,"player"),
      ["dyn8AoE"] = getDebuffRemain(tarUnit.dyn8AoE,_Bloodbath,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_Bloodbath,"player"),
    }
    -- Spell CDs
    local cscd = getSpellCD(_ColossusSmash)
    local mscd = getSpellCD(_MortalStrike)
    -- Misc
    local ttd = getTimeToDie(tarUnit.dyn5)
    local GCD = 1.5/(1+UnitSpellHaste("player")/100)
    ------------------------------------------------------------------------------------------------------
    -- Food/Invis Check ----------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if canRun() ~= true or UnitInVehicle("Player") then
      return false;
    end
    ------------------------------------------------------------------------------------------------------
    -- Pause ---------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isChecked("Pause Key") and SpecificToggle("Pause Key") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
    ------------------------------------------------------------------------------------------------------
    -- Spell Queue ---------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if _Queues == nil then
      _Queues = {
        [_Shockwave]  = false,
        [_Bladestorm] = false,
        [_DragonRoar] = false,
      }
    end
    ------------------------------------------------------------------------------------------------------
    -- Input / Keys --------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
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
    ------------------------------------------------------------------------------------------------------
    -- Out of Combat -------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if not isInCombat("player") then
      -- actions.precombat+=/stance,choose=battle
      if GetShapeshiftForm() ~= 1 then
        if castSpell("player",_BattleStance,true) then
          return;
        end
      end
      -- Commanding Shout
      if isChecked("Shout") == true and getValue("Shout") == 1 and not UnitExists("mouseover") then
        for i = 1, #members do --members
          if not isBuffed(members[i].Unit,{21562,109773,469,90364}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
            if castSpell("player",_CommandingShout,false,false) then return; end
        end
        end
      end
      -- Battle Shout
      if isChecked("Shout") == true and getValue("Shout") == 2 and not UnitExists("mouseover") then
        for i = 1, #members do --members
          if not isBuffed(members[i].Unit,{57330,19506,6673}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
            if castSpell("player",_BattleShout,false,false) then return; end
        end
        end
      end
    end -- Out of Combat end
    ------------------------------------------------------------------------------------------------------
    -- In Combat -----------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    -- if pause() ~= true and isInCombat("player") and canAttack("target","player") and not UnitIsDeadOrGhost("target") then
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
      if _Queues[Shockwave] == true then
        if castSpell("target",_Shockwave,false,false) then
          return;
        end
      end
      if _Queues[Bladestorm] == true then
        if castSpell("target",_Bladestorm,false,false) then
          return;
        end
      end
      if _Queues[DragonRoar] == true then
        if castSpell("target",_DragonRoar,false,false) then
          return;
        end
      end
      ------------------------------------------------------------------------------------------------------
      -- Do everytime --------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------

      -- actions+=/auto_attack
      if tarDist.dyn0<5 then
        RunMacroText("/startattack")
      end

      ------------------------------------------------------------------------------------------------------
      -- Defensive Cooldowns -------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if useDefensiveArms() == true then
        -- Die by the Sword
        if isChecked("Die by the Sword") == true then
          if getHP("player") <= getValue("Die by the Sword") then
            if castSpell("player",_DiebytheSword,true) then
              return;
            end
          end
        end
        -- Rallying Cry
        if isChecked("Rallying Cry") == true then
          if getHP("player") <= getValue("Rallying Cry") then
            if castSpell("player",_RallyingCry,true) then
              return;
            end
          end
        end
        -- Enraged Regeneration
        if isChecked("Enraged Regeneration") == true then
          if isKnown(_EnragedRegeneration) and getHP("player") <= getValue("Enraged Regeneration") then
            if castSpell("player",_EnragedRegeneration,true) then
              return;
            end
          end
        end
        -- Healthstone
        if isChecked("Healthstone") == true then
          if getHP("player") <= getValue("Healthstone") then
            if canUse(5512) then
              UseItemByName(tostring(select(1,GetItemInfo(5512))))
            end
          end
        end
        -- Vigilance Focus
        if isChecked("Vigilance on Focus") == true then
          if getHP("focus") <= getValue("Vigilance on Focus") then
            if castSpell("focus",_Vigilance,false,false) then
              return;
            end
          end
        end
        --Def Stance
        if isChecked("DefensiveStance") == true then
          if getHP("player") <= getValue("DefensiveStance") and GetShapeshiftForm() ~= 2 then
            if castSpell("player",_DefensiveStance,true) then
              return;
            end
          elseif getHP("player") > getValue("DefensiveStance") and GetShapeshiftForm() ~= 1 then
            if castSpell("player",_BattleStance,true) then
              return;
            end
          end
        end
      end -- isChecked("Defensive Mode") end
      ------------------------------------------------------------------------------------------------------
      -- Offensive Cooldowns -------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if useCDsArms() == true then
        -- actions+=/potion,name=draenic_strength,if=(target.health.pct<20&buff.recklessness.up)|target.time_to_die<25
        if (thp < 20 and reckup) or ttd < 25 then
          if canUse(109219) then -- WoD Potion
            UseItemByName(tostring(select(1,GetItemInfo(109219))))
          end
        end
        -- actions+=/recklessness,if=(dot.rend.ticking&(target.time_to_die>190|target.health.pct<20)&(!talent.bloodbath.enabled&(cooldown.colossus_smash.remains<2|debuff.colossus_smash.remains>=5)|buff.bloodbath.up))|target.time_to_die<10
        if (rendRemain.dyn5 > 0 and (ttd > 190 or thp < 20) and (bloodbath == false and (cscd < 2 or csRemain.dyn5 >= 5) or bbRemain.dyn5 > 0)) or ttd < 10 then
          if castSpell("player",_Recklessness,true) then
            return
          end
        end
        -- actions+=/bloodbath,if=(dot.rend.ticking&cooldown.colossus_smash.remains<5)|target.time_to_die<20
        if bloodbath then
          if (rendRemain.dyn5 > 0 and cscd < 5) or ttd < 20 then
            if castSpell("player",_Bloodbath,true) then
              return
            end
          end
        end
        -- actions+=/avatar,if=buff.recklessness.up|target.time_to_die<25
        if avatar then
          if reckup or ttd < 25 then
            if castSpell("player",_Avatar,true) then
              return
            end
          end
        end
        -- actions+=/blood_fury,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
        -- actions+=/berserking,if=buff.bloodbath.up|(!talent.bloodbath.enabled&debuff.colossus_smash.up)|buff.recklessness.up
        if isChecked("Racial (Orc / Troll)") then
          if (bloodbath and bbathup)
            or (not bloodbath and csRemain.dyn5 > 0)
            or reckup then
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
        end
        --On use Trinkets
        if isChecked("Use Trinket") then
          if canTrinket(13) and useCDsArms() then
            RunMacroText("/use 13")
            if IsAoEPending() then
              local X,Y,Z = GetObjectPosition(Unit)
              ClickPosition(X,Y,Z)
            end
          end
          if canTrinket(14) and useCDsArms() then
            RunMacroText("/use 14")
            if IsAoEPending() then
              local X,Y,Z = GetObjectPosition(Unit)
              ClickPosition(X,Y,Z)
            end
          end
        end
      end -- useCDs() end
      ------------------------------------------------------------------------------------------------------
      -- Interrupts ----------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------

      ------------------------------------------------------------------------------------------------------
      -- Main Rotaion --------------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if not useAoEArms() then
        ChatOverlay("Single", 0)
        -- actions.single=rend,if=!ticking&target.time_to_die>4
        -- if isChecked("Multi-Rend") and canCast(Rend) then
        --      if myEnemies == nil or myEnemiesTimer == nil or myEnemiesTimer <= GetTime() - 1 then
        --          myEnemies, myEnemiesTimer = getEnemies("player",5), GetTime();
        --      end
        --     	-- begin loop
        --     	if myEnemies ~= nil then
        --         for i = 1, #myEnemies do
        --           -- we check if it's a valid unit
        --           if getCreatureType(myEnemies[i]) == true then
        --             -- now that we know the unit is valid, we can use it to check whatever we want.. let's call it thisUnit
        --             local thisUnit = myEnemies[i]
        --             -- Here I do my specific spell checks
        --             if ((UnitCanAttack(thisUnit,"player") == true and UnitAffectingCombat(thisUnit) == true) or isDummy(thisUnit))
        --             and getDebuffRemain(thisUnit,_Rend) < 5
        --             and getDistance("player",thisUnit) < 5 then
        --               -- All is good, let's cast.
        --               if isGarrMCd(thisUnit) == false then
        --                 if castSpell(thisUnit,_Rend,false,false) then
        --                   return;
        --                 end
        --              end
        --            end
        --          end
        --        end
        --      end
        --    end

        -- Ko'ragh barrier<20% (finisher can be cast if barrier<20%)
        if GetUnitName("target")=="Ko'ragh" then
          if castSpell("target",_Execute,false,false) then
            return
          end
        end

        -- actions.single=rend,if=target.time_to_die>4&dot.rend.remains<5.4&(target.health.pct>20|!debuff.colossus_smash.up)
        if getDebuffRemain("target",_Rend,"player") < 5.4 and (thp > 20 or not csup) then
          if castSpell("target",_Rend,false,false) then
            return
          end
        end
        -- actions.single+=/ravager,if=cooldown.colossus_smash.remains<4&(!raid_event.adds.exists|raid_event.adds.in>55)
        if ravager and isChecked("Single BS/DR/RV") and not isChecked("Ravager Key") then
          if cscd < 4 then
            if castGround("target",152277,6) then
              return
            end
          end
        end
        -- actions.single+=/colossus_smash
        if castSpell("target",_ColossusSmash,false,false) then
          return
        end
        -- actions.single+=/mortal_strike,if=target.health.pct>20
        if thp > 20 then
          if castSpell("target",_MortalStrike,false,false) then
            return
          end
        end
        -- actions.single+=/bladestorm,if=(((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4))&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
        if bladestorm and isChecked("Single BS/DR/RV") then
          if (((csup or cscd > 3) and thp > 20) or (thp < 20 and rage < 30 and cscd > 4)) then
            if castSpell("player",_Bladestorm,true) then
              return
            end
          end
        end
        -- actions.single+=/storm_bolt,if=target.health.pct>20|(target.health.pct<20&!debuff.colossus_smash.up)
        if stormbolt then
          if thp > 20 or (thp < 20 and not csup) then
            if castSpell("target",_StormBolt,false,false) then
              return
            end
          end
        end
        -- actions.single+=/siegebreaker
        if siegebreaker then
          if castSpell("target",_Siegebreaker,false,false) then
            return
          end
        end
        -- actions.single+=/dragon_roar,if=!debuff.colossus_smash.up&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
        if dragonroar and isChecked("Single BS/DR/RV") then
          if not csup and getDistance("player","target") <= 8 then
            if castSpell("player",_DragonRoar,true) then
              return
            end
          end
        end
        -- actions.single+=/execute,if=buff.sudden_death.react
        if suddendeathup then
          if castSpell("target",_Execute,false,false) then
            return
          end
        end
        -- actions.single+=/execute,if=!buff.sudden_death.react&(rage>72&cooldown.colossus_smash.remains>gcd)|debuff.colossus_smash.up|target.time_to_die<5
        if not suddendeathup and (rage > 72 and cscd > GCD) or csup then
          if castSpell("target",_Execute,false,false) then
            return
          end
        end
        -- actions.single+=/impending_victory,if=rage<40&target.health.pct>20&cooldown.colossus_smash.remains>1
        if rage < 40 and thp > 20 and cscd > 1 then
          if castSpell("target",_ImpendingVictory,false,false) then
            return
          end
        end
        -- actions.single+=/slam,if=(rage>20|cooldown.colossus_smash.remains>gcd)&target.health.pct>20&cooldown.colossus_smash.remains>1
        if slam then
          if (rage > 20 or cscd > GCD) and thp > 20 and cscd > 1 then
            if castSpell("target",_Slam,false,false) then
              return
            end
          end
        end
        -- actions.single+=/thunder_clap,if=!talent.slam.enabled&target.health.pct>20&(rage>=40|debuff.colossus_smash.up)&glyph.resonating_power.enabled&cooldown.colossus_smash.remains>gcd
        if not slam then
          if thp > 20 and (rage >= 40 or csup) and hasGlyph(507) and cscd > GCD then
            if getDistance("player","target") <= 8 then
              if castSpell("player",_ThunderClap,true) then
                return
              end
            end
          end
        end
        -- actions.single+=/whirlwind,if=!talent.slam.enabled&target.health.pct>20&(rage>=40|debuff.colossus_smash.up)&cooldown.colossus_smash.remains>gcd
        if not slam then
          if getDistance("player","target") <= 8 then
            if thp > 20 and (rage >= 40 or csup) and cscd > GCD then
              if castSpell("player",_Whirlwind,true) then
                return
              end
            end
          end
        end
        -- actions.single+=/shockwave

      end -- Single Target end
      ------------------------------------------------------------------------------------------------------
      if useAoEArms() then
        ChatOverlay("AoE", 0)
        -- actions.aoe=sweeping_strikes
        if castSpell("player",_SweepingStrikes,true) then
          return
        end
        -- actions.aoe+=/rend,if=ticks_remain<2&target.time_to_die>4&(target.health.pct>20|!debuff.colossus_smash.up)
        -- actions.aoe+=/rend,cycle_targets=1,max_cycle_targets=2,if=ticks_remain<2&target.time_to_die>8&!buff.colossus_smash_up.up&talent.taste_for_blood.enabled
        -- actions.aoe+=/rend,cycle_targets=1,if=ticks_remain<2&target.time_to_die-remains>18&!buff.colossus_smash_up.up&active_enemies<=8
        if rendRemain.dyn5 < 4 and csRemain.dyn5 == 0 then
          if castDotCycle("all",_Rend,5,false,false,2) then
            return
          end
        end
        -- actions.aoe+=/ravager,if=buff.bloodbath.up|cooldown.colossus_smash.remains<4
        if ravager and isChecked("Multi BS/DR/RV") and not isChecked("Ravager Key") then
          if bbathup or cscd < 4 then
            if castGround("target",152277,40) then
              return
            end
          end
        end
        -- actions.aoe+=/bladestorm,if=((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4)
        if bladestorm and isChecked("Multi BS/DR/RV") then
          if (((csup or cscd > 3) and thp > 20) or (thp < 20 and rage < 30 and cscd > 4)) then
            if UnitBuffID("player",_SweepingStrikes) then
              if castSpell("player",_Bladestorm,true) then
                return
              end
            end
          end
        end
        -- actions.aoe+=/colossus_smash,if=dot.rend.ticking
        if rendup then
          if castSpell(tarUnit.dyn5,_ColossusSmash,false,false) then
            return
          end
        end
        -- actions.aoe+=/execute,cycle_targets=1,if=!buff.sudden_death.react&active_enemies<=8&((rage>72&cooldown.colossus_smash.remains>gcd)|rage>80|target.time_to_die<5|debuff.colossus_smash.up)
        if not suddendeathup and (rage > 72 and cscd > GCD) or csup then
          for i=1,#enemiesTable do
            local thisUnit = enemiesTable[i].unit
            local hp = enemiesTable[i].hp
            if hp<20 then
              if castSpell(thisUnit,_Execute,false,false,false,false,false,false,true) then
                return
              end
            end
          end
        end
        -- actions.aoe+=/mortal_strike,if=target.health.pct>20&active_enemies<=5
        if #getEnemies("player",5) <= 5 and thp > 20 then
          if castSpell(tarUnit.dyn5,_MortalStrike,false,false) then
            return
          end
        end
        -- actions.aoe+=/dragon_roar,if=!debuff.colossus_smash.up
        if dragonroar and isChecked("Multi BS/DR/RV") then
          if not csup and getDistance("player","target") <= 8 then
            if castSpell("player",_DragonRoar,true) then
              return
            end
          end
        end
        -- actions.aoe+=/thunder_clap,if=(target.health.pct>20|active_enemies>=9)&glyph.resonating_power.enabled
        if rage >= 40 or #getEnemies("player",8) >= 9 and hasGlyph(507) then
          if getDistance("player","target") <= 8 then
            if castSpell("player",_ThunderClap,true) then
              return
            end
          end
        end
        -- actions.aoe+=/rend,cycle_targets=1,if=ticks_remain<2&target.time_to_die>8&!buff.colossus_smash_up.up&active_enemies>=9&rage<50&!talent.taste_for_blood.enabled
        -- actions.aoe+=/whirlwind,if=target.health.pct>20|active_enemies>=9
        if #getEnemies("player",8) >= 9 then
          if castSpell("player",_Whirlwind,true) then
            return
          end
        end
        -- actions.aoe+=/siegebreaker
        if siegebreaker then
          if castSpell(tarUnit.dyn5,_Siegebreaker,false,false) then
            return
          end
        end
        -- actions.aoe+=/storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
        if cscd > 4 or csRemain.dyn30 > 0 then
          if castSpell(tarUnit.dyn30,_StormBolt,false,false) then
            return
          end
        end
        -- actions.aoe+=/shockwave
        -- actions.aoe+=/execute,if=buff.sudden_death.react
        if suddendeathup then
          if castSpell(tarUnit.dyn5,_Execute,false,false) then
            return
          end
        end
      end -- AoE end
    end -- In Combat end
  end -- ArmsWarrior() end
end -- Class Check end

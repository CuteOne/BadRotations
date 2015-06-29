if select(3,UnitClass("player")) == 1 then

  function FuryWarrior()

    if currentConfig ~= "Fury Warrior" then
      FuryOptions();
      currentConfig = "Fury Warrior";
    end
    FuryKeyToggles();
    GroupInfo();
    ------------------------------------------------------------------------------------------------------
    -- Locals --------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    -- Player / Target values
    local rage    = UnitPower("player")
    local maxrage = UnitPowerMax("player")
    local php     = getHP("player")
    local thp     = getHP("target")
    -- Talents
    local enragedregen          = getTalent(2,1)
    local impvic                = getTalent(2,3)
    local furiousstrikes				= getTalent(3,1)
    local suddendeathup					= getTalent(3,2)
    local thirst                = getTalent(3,3)
    local stormbolt             = getTalent(4,1)
    local shockwave							= getTalent(4,2)
    local dragonroar            = getTalent(4,3)
    local massreflect           = getTalent(5,1)
    local safeguard             = getTalent(5,2)
    local vigilance							= getTalent(5,3)
    local avatar                = getTalent(6,1)
    local bloodbath             = getTalent(6,2)
    local bladestorm            = getTalent(6,3)
    local angermanagement 			= getTalent(7,1)
    local ravager               = getTalent(7,2)
    local siegebreaker          = getTalent(7,3)
    -- Buffs / Debuffs
    local enraged 							= UnitBuffID("player",Enrage)
    local enragedRemain					= getBuffRemain("player",Enrage)
    local suddendeathup					= UnitBuffID("player",SuddenDeathProc)
    local reckup								= UnitBuffID("player",Recklessness)
    local bbathup								= UnitBuffID("player",Bloodbath)
    local ragingblowproc				= UnitBuffID("player",RagingBlowProc)
    local bloodsurgeup					= UnitBuffID("player",Bloodsurge)
    local meatcleaver 					= UnitBuffID("player",MeatCleaver)
    local meatcleaverstacks			= getBuffStacks("player",MeatCleaver)
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
    local ttd	= getTimeToDie(tarUnit.dyn5)
    local thpaoe = getHP(tarUnit.dyn5)
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
        [Shockwave]  = false,
        [Bladestorm] = false,
        [DragonRoar] = false,
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
        if castSpell("player",BattleStance,true) then
          return;
        end
      end
      -- Commanding Shout
      if isChecked("Shout") == true and getValue("Shout") == 1 and not UnitExists("mouseover") then
        for i = 1, #members do --members
          if not isBuffed(members[i].Unit,{21562,109773,469,90364}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
            if castSpell("player",CommandingShout,false,false) then return; end
        end
        end
      end
      -- Battle Shout
      if isChecked("Shout") == true and getValue("Shout") == 2 and not UnitExists("mouseover") then
        for i = 1, #members do --members
          if not isBuffed(members[i].Unit,{57330,19506,6673}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
            if castSpell("player",BattleShout,false,false) then return; end
        end
        end
      end
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
      if _Queues[Shockwave] == true then
        if castSpell("target",Shockwave,false,false) then
          return;
        end
      end
      if _Queues[Bladestorm] == true then
        if castSpell("target",Bladestorm,false,false) then
          return;
        end
      end
      if _Queues[DragonRoar] == true then
        if castSpell("target",DragonRoar,false,false) then
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
      -- actions+=/berserker_rage,if=buff.enrage.down|(talent.unquenchable_thirst.enabled&buff.raging_blow.down)
      if not enraged or (thirst and not ragingblowproc) then
        if castSpell("player",BerserkerRage,true) then
        ----print("Berserker Rage 1")
        end
      end
      ------------------------------------------------------------------------------------------------------
      -- Defensive Cooldowns -------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if useDefensiveFury() == true then
        -- Die by the Sword
        if isChecked("Die by the Sword") == true then
          if getHP("player") <= getValue("Die by the Sword") then
            if castSpell("player",DiebytheSword,true) then
              return;
            end
          end
        end
        -- Rallying Cry
        if isChecked("Rallying Cry") == true then
          if getHP("player") <= getValue("Rallying Cry") then
            if castSpell("player",RallyingCry,true) then
              return;
            end
          end
        end
        -- Enraged Regeneration
        if isChecked("Enraged Regeneration") == true then
          if enragedregen and getHP("player") <= getValue("Enraged Regeneration") then
            if castSpell("player",EnragedRegeneration,true) then
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
            if castSpell("focus",Vigilance,false,false) then
              return;
            end
          end
        end
        --Def Stance
        if isChecked("DefensiveStance") == true then
          if getHP("player") <= getValue("DefensiveStance") and GetShapeshiftForm() ~= 2 then
            if castSpell("player",DefensiveStance,true) then
              return;
            end
          elseif getHP("player") > getValue("DefensiveStance") and GetShapeshiftForm() ~= 1 then
            if castSpell("player",BattleStance,true) then
              return;
            end
          end
        end
      end -- isChecked("Defensive Mode") end
      ------------------------------------------------------------------------------------------------------
      -- Offensive Cooldowns -------------------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------
      if useCDsFury() == true then
        if isChecked("Use Potion") then
          if (thp < 20 and reckup) or ttd < 25 then
            if canUse(109219) then -- WoD Potion
              UseItemByName(tostring(select(1,GetItemInfo(109219))))
            end
          end
        end
        -- actions+=/recklessness,if=((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled
        if isChecked("Recklessness") then
          if ((ttd > 190 or thp < 20) and (bbathup or not bloodbath)) or ttd <= 12 or angermanagement then
            if castSpell("player",Recklessness,true) then
              ----print("Recklessness 1")
              return
            end
          end
        end
        -- actions+=/avatar,if=(buff.recklessness.up|target.time_to_die<=30)
        if avatar then
          if isChecked("Avatar") then
            if reckup or ttd <= 30 then
              if castSpell("player",Avatar,true) then
                ----print("Avatar 1")
                return
              end
            end
          end
        end
        -- actions+=/blood_fury,if=buff.bloodbath.up|!talent.bloodbath.enabled|buff.recklessness.up
        -- actions+=/berserking,if=buff.bloodbath.up|!talent.bloodbath.enabled|buff.recklessness.up
        if isChecked("Racial (Orc / Troll)") then
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
        --On use Trinkets
        if isChecked("Use Trinket") then
          if canTrinket(13) and useCDsFury() then
            RunMacroText("/use 13")
            if IsAoEPending() then
              local X,Y,Z = GetObjectPosition(Unit)
              ClickPosition(X,Y,Z,true)
            end
          end
          if canTrinket(14) and useCDsFury() then
            RunMacroText("/use 14")
            if IsAoEPending() then
              local X,Y,Z = GetObjectPosition(Unit)
              ClickPosition(X,Y,Z,true)
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
      if not useAoEFury() then
        ChatOverlay("Single", 0)
        -- Ko'ragh barrier<20% (finisher can be cast if barrier<20%)
        if GetUnitName("target")=="Ko'ragh" then
          if castSpell("target",Execute,false,false) then
            ----print("Execute Koragh Shield")
            return
          end
        end
        --   actions.single_target=bloodbath | Use bloodbath on cooldown, but only after bloodthirst/berserker rage have procced enrage
        if bloodbath and enraged then
          if castSpell("player",Bloodbath,true) then
            ----print("Bloodbath 1")
            return
          end
        end
        -- actions.single_target+=/wild_strike,if=rage>110&target.health.pct>20
        if rage > 110 and thp > 20 then
          if castSpell(tarUnit.dyn5,WildStrike,false,false) then
            ----print("WildStrike 1")
            return
          end
        end
        -- actions.single_target+=/bloodthirst,if=(!talent.unquenchable_thirst.enabled&rage<80)|buff.enrage.down
        if (not thirst and rage < 80) or not enraged then
          if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
            ----print("Bloodthirst 1")
            return
          end
        end
        -- actions.single_target+=/ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.cooldown>60|target.time_to_die<40))
        if ravager then
          if isChecked("Single BS/DR/RV") then
            if bbathup or (not bloodbath and ttd < 40) then
              if castGround("target",152277,6) then
                ----print("Auto Ravager 1")
                return
              end
            end
          end
        end
        -- actions.single_target+=/execute,if=buff.sudden_death.react
        if suddendeathup then
          if castSpell(tarUnit.dyn0,Execute,false,false) then
            ----print("Execute 1")
            return
          end
        end
        -- actions.single_target+=/siegebreaker
        if siegebreaker then
          if castSpell(tarUnit.dyn5,Siegebreaker,false,false) then
            ----print("Siegebreaker 1")
            return
          end
        end
        -- actions.single_target+=/storm_bolt
        if stormbolt then
          if castSpell(tarUnit.dyn30,StormBolt,false,false) then
            ----print("StormBolt 1")
            return
          end
        end
        -- actions.single_target+=/wild_strike,if=buff.bloodsurge.up
        if bloodsurgeup then
          if castSpell(tarUnit.dyn5,WildStrike,false,false) then
            ----print("WildStrike 2")
            return
          end
        end
        -- actions.single_target+=/execute,if=buff.enrage.up|target.time_to_die<12
        if enraged or ttd < 12 then
          if castSpell(tarUnit.dyn5,Execute,false,false) then
            ----print("Execute 2")
            return
          end
        end
        -- actions.single_target+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        if dragonroar then
          if isChecked("Single BS/DR/RV") then
            if bbathup or not bloodbath then
              if #getEnemies("player",8) >= 1 then
                if castSpell("player",DragonRoar,true) then
                  ----print("Auto DragonRoar")
                  return
                end
              end
            end
          end
        end
        -- actions.single_target+=/raging_blow
        if castSpell(tarUnit.dyn5,RagingBlow,false,false) then
          ----print("RagingBlow 1")
          return
        end
        -- actions.single_target+=/wild_strike,if=buff.enrage.up&target.health.pct>20
        if enraged and thp > 20 then
          if castSpell(tarUnit.dyn5,WildStrike,false,false) then
            ----print("WildStrike 3")
            return
          end
        end
        -- actions.single_target+=/bladestorm,if=!raid_event.adds.exists
        if bladestorm then
          if isChecked("Single BS/DR/RV") then
            if #getEnemies("player",8) >= 1 then
              if castSpell("player",Bladestorm,true) then
                ----print("Auto BladeStorm")
                return
              end
            end
          end
        end
        -- actions.single_target+=/impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
        if impvic then
          if not thirst and thp > 20 then
            if castSpell(tarUnit.dyn5,ImpendingVictory,false,false) then
              ----print("ImpendingVictory")
              return
            end
          end
        end
        -- actions.single_target+=/bloodthirst
        if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
          ----print("Bloodthirst")
          return
        end
      end -- Single Target end
      ------------------------------------------------------------------------------------------------------
      if useAoEFury() then
        -- 2 Targets
        if #getEnemies("player",8) == 2 then
          ChatOverlay("AoE 2 Targets", 0)
          -- actions.two_targets=bloodbath
          if bloodbath and enraged then
            if castSpell("player",Bloodbath,true) then
              ----print("AoE 2T Bloodbath 1")
              return
            end
          end
          -- actions.two_targets+=/ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
          if isChecked("AoE BS/DR/RV") then
            if (bloodbath and bbathup) or not bloodbath then
              if castGround("target",152277,6) then
                ----print("AoE 2T Ravager 1")
                return
              end
            end
          end
          -- actions.two_targets+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
          if isChecked("AoE BS/DR/RV") then
            if (bloodbath and bbathup) or not bloodbath then
              if castSpell("player",DragonRoar,true) then
                ----print("AoE 2T DragonRoar")
                return
              end
            end
          end
          -- actions.two_targets+=/bladestorm,if=buff.enrage.up
          if isChecked("AoE BS/DR/RV") then
            if enraged then
              if castSpell("player",Bladestorm,true) then
                ----print("AoE 2T Bladestorm")
                return
              end
            end
          end
          -- actions.two_targets+=/bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
          if not enraged or rage < 50 or not ragingblowproc then
            if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
              ----print("AoE 2T Bloodthirst 1")
              return
            end
          end
          -- actions.two_targets+=/execute,target=2
          -- actions.two_targets+=/execute,if=target.health.pct<20|buff.sudden_death.react
          if thpaoe < 20 or suddendeathup then
            if castSpell(tarUnit.dyn5,Execute,false,false) then
              ----print("AoE 2T Execute 1")
              return
            end
          end
          -- actions.two_targets+=/raging_blow,if=buff.meat_cleaver.up
          if meatcleaver then
            if castSpell(tarUnit.dyn5,RagingBlow,false,false) then
              ----print("AoE 2T RagingBlow 1")
              return
            end
          end
          -- actions.two_targets+=/whirlwind,if=!buff.meat_cleaver.up
          if not meatcleaver then
            if castSpell("player",Whirlwind,true) then
              ----print("AoE 2T Whirlwind 1")
              return
            end
          end
          -- actions.two_targets+=/wild_strike,if=buff.bloodsurge.up&rage>75
          if bloodsurgeup and rage > 75 then
            if castSpell(tarUnit.dyn5,WildStrike,false,false) then
              ----print("AoE 2T WildStrike 1")
              return
            end
          end
          -- actions.two_targets+=/bloodthirst
          if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
            ----print("AoE 2T Bloodthirst 2")
            return
          end
          -- actions.two_targets+=/whirlwind,if=rage>rage.max-20
          if rage >= (maxrage - 20) then
            if castSpell("player",Whirlwind,true) then
              ----print("AoE 2T Whirlwind 2")
              return
            end
          end
          -- actions.two_targets+=/wild_strike,if=buff.bloodsurge.up
          if bloodsurgeup then
            if castSpell(tarUnit.dyn5,WildStrike,false,false) then
              ----print("AoE 2T WildStrike 2")
              return
            end
          end
        end -- 2 Targets end
        -- 3 Targets
        if #getEnemies("player",8) == 3 then
          ChatOverlay("AoE 3 Targets", 0)
          -- actions.three_targets=bloodbath
          if bloodbath and enraged then
            if castSpell("player",Bloodbath,true) then
              ----print("AoE 3T Bloodbath 1")
              return
            end
          end
          -- actions.three_targets+=/ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
          if isChecked("AoE BS/DR/RV") then
            if (bloodbath and bbathup) or not bloodbath then
              if castGround("target",152277,6) then
                ----print("AoE 3T Ravager 1")
                return
              end
            end
          end
          -- actions.three_targets+=/bladestorm,if=buff.enrage.up
          if isChecked("AoE BS/DR/RV") then
            if enraged then
              if castSpell("player",Bladestorm,true) then
                ----print("AoE 3T Bladestorm")
                return
              end
            end
          end
          -- actions.three_targets+=/bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
          if not enraged or rage < 50 or not ragingblowproc then
            if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
              ----print("AoE 3T Bloodthirst 1")
              return
            end
          end
          -- actions.three_targets+=/raging_blow,if=buff.meat_cleaver.stack>=2
          if meatcleaverstacks >= 2 then
            if castSpell(tarUnit.dyn5,RagingBlow,false,false) then
              ----print("AoE 3T RagingBlow 1")
              return
            end
          end
          -- actions.three_targets+=/execute,if=buff.sudden_death.react
          -- actions.three_targets+=/execute,target=2
          -- actions.three_targets+=/execute,target=3
          if thpaoe < 20 or suddendeathup then
            if castSpell(tarUnit.dyn5,Execute,false,false) then
              ----print("AoE 3T Execute 1")
              return
            end
          end
          -- actions.three_targets+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
          if isChecked("AoE BS/DR/RV") then
            if (bloodbath and bbathup) or not bloodbath then
              if castSpell("player",DragonRoar,true) then
                ----print("AoE 3T DragonRoar")
                return
              end
            end
          end
          -- actions.three_targets+=/whirlwind
          if castSpell("player",Whirlwind,true) then
            ----print("AoE 3T Whirlwind 1")
            return
          end
          -- actions.three_targets+=/bloodthirst
          if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
            ----print("AoE 3T Bloodthirst 2")
            return
          end
          -- actions.three_targets+=/wild_strike,if=buff.bloodsurge.up
          if bloodsurgeup then
            if castSpell(tarUnit.dyn5,WildStrike,false,false) then
              ----print("AoE 3T WildStrike 1")
              return
            end
          end
        end -- 3+ Targets end
        if #getEnemies("player",8) >= 4 then
          ChatOverlay("AoE 4+ Targets", 0)
          -- actions.aoe=bloodbath
          if bloodbath and enraged then
            if castSpell("player",Bloodbath,true) then
              ----print("AoE 4+ Bloodbath 1")
              return
            end
          end
          -- actions.aoe+=/ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
          if isChecked("AoE BS/DR/RV") then
            if (bloodbath and bbathup) or not bloodbath then
              if castGround("target",152277,6) then
                ----print("AoE 4+ Ravager 1")
                return
              end
            end
          end
          -- actions.aoe+=/raging_blow,if=buff.meat_cleaver.stack>=3&buff.enrage.up
          if meatcleaverstacks >= 3 and enraged then
            if castSpell(tarUnit.dyn5,RagingBlow,false,false) then
              ----print("AoE 4+ RagingBlow 1")
              return
            end
          end
          -- actions.aoe+=/bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
          if not enraged or rage < 50 or not ragingblowproc then
            if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
              ----print("AoE 4+ Bloodthirst 1")
              return
            end
          end
          -- actions.aoe+=/raging_blow,if=buff.meat_cleaver.stack>=3
          if meatcleaverstacks >= 3 then
            if castSpell(tarUnit.dyn5,RagingBlow,false,false) then
              ----print("AoE 4+ RagingBlow 2")
              return
            end
          end
          -- actions.aoe+=/recklessness,sync=bladestorm
          -- actions.aoe+=/bladestorm,if=buff.enrage.remains>6
          if isChecked("AoE BS/DR/RV") then
            if enragedRemain > 6 or reckup then
              if castSpell("player",Bladestorm,true) then
                ----print("AoE 4+ Bladestorm")
                return
              end
            end
          end
          -- actions.aoe+=/whirlwind
          if castSpell("player",Whirlwind,true) then
            ----print("AoE 4+ Whirlwind 1")
            return
          end
          -- actions.aoe+=/execute,if=buff.sudden_death.react
          if thpaoe < 20 or suddendeathup then
            if castSpell(tarUnit.dyn5,Execute,false,false) then
              ----print("AoE 4+ Execute 1")
              return
            end
          end
          -- actions.aoe+=/dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
          if isChecked("AoE BS/DR/RV") then
            if (bloodbath and bbathup) or not bloodbath then
              if castSpell("player",DragonRoar,true) then
                ----print("AoE 4+ DragonRoar")
                return
              end
            end
          end
          -- actions.aoe+=/bloodthirst
          if castSpell(tarUnit.dyn5,Bloodthirst,false,false) then
            ----print("AoE 4+ Bloodthirst 2")
            return
          end
          -- actions.aoe+=/wild_strike,if=buff.bloodsurge.up
          if bloodsurgeup then
            if castSpell(tarUnit.dyn5,WildStrike,false,false) then
              ----print("AoE 3T WildStrike 1")
              return
            end
          end
        end -- 4+ Targets end
      end -- AoE end
    end -- In Combat end






  end -- Fury End
end -- Warrior End

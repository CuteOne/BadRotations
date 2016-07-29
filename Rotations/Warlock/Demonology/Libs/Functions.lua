if select(3,UnitClass("player")) == 9 then
  function DemonologyFunctions()
    -- we want to build core only only
    if core == nil then

      -- build core
      local demoCore = {
        -- player stats
        buff = { },
        cd = { },
        combatTime = 0,
        glyph = { },
        health = 100,
        inCombat = false,
        mana = 0,
        mode = { },
        recharge = { },
        loadTime = GetTime(),
        talent = { },
        units = { },
        spell = {
          corruption = 172,
          drainLife = 689,
          felguard = 30146,
          handOfGuldan = 105174,

          shadowbolt = 686,

        }
      }

      -- Global
      core = demoCore

      -- localise commonly used functions
      local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
      local UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies = UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies
      local player,data,GetShapeshiftForm,dynamicTarget = "player",bb.data,GetShapeshiftForm,dynamicTarget
      local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
      local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
      local canCast,isKnown,GetSpellCharges = canCast,isKnown,GetSpellCharges
      local UnitHealth,castDotCycle,print,UnitHealthMax = UnitHealth,castDotCycle,print,UnitHealthMax
      local GetSpellInfo,UnitCastingInfo,GetTime,floor = GetSpellInfo,UnitCastingInfo,GetTime,math.floor
      local useItem,getDebuffRemain = useItem,getDebuffRemain

      -- no external access after here
      setfenv(1,demoCore)

      -- Corrution Cycle
      function demoCore:castCorruptionCycle()
        if isChecked("Multi-Dotting") then
          return (castDotCycle("All",spell.corruption,40,true,false,3) == true and debug("Multi-Corruption"))  or false
        else
          return (getDebuffRemain(units.dyn40,spell.corruption,"player") < 3 and castSpell(units.dyn40,spell.corruption,true,false) == true and debug("Direct-Corruption")) or false
        end
      end

      -- Drain Life
      function demoCore:castDrainLife()
        if isChecked("Drain Life") then
          if health <= getValue("Drain Life") then
            return (castSpell(units.dyn40,spell.drainLife,false,true) == true and debug("Drain Life")) or false
          end
        end
      end

      -- Hand of Gul'dan
      function demoCore:castHandOfGuldan()
        return (castSpell(units.dyn40,spell.handOfGuldan,false,false,false) == true and debug("Hand of Gul'dan")) or false
      end

      -- Felguard
      function demoCore:castFelguard()
        if not UnitExists("pet") then
          return (castSpell(player,spell.felguard,true,true) == true and debug("Felguard"))
        end
      end

      -- Shadow Bolt
      function demoCore:castShadowbolt()
        return (castSpell(units.dyn40,spell.shadowbolt,false,true) == true and debug("Shadowbolt")) or false
      end

      function demoCore:ooc()
        -- update modes
        updateModes()
        -- Talents (refresh ooc)

        -- Glyph (refresh ooc)
        combatTime = GetTime()
        inCombat = false
        health = getHP(player)
        bb.friend = bb.friend
        buff.meta = UnitBuffID(player,103958)
      end

      -- this will be used to make the core refresh itself
      function demoCore:update()
        -- update modes
        updateModes()
        -- player stats
        bb.friend = bb.friend
        inCombat = true
        health = getHP(player)
        mana = UnitPower(player,0)
        -- Buffs
        buff.meta = UnitBuffID(player,103958)

        -- Cooldowns

        -- dynamic units
        units.dyn40 = dynamicTarget(40,true)
      end

      -- Debug
      function demoCore:debug()
        if debugEnabled == true then
          local time = (floor((GetTime() - combatTime)*1000))/1000
          print("|cffFFBF00<|cffFF0000Debug|cffFFBF00> <|cffFFFFFF"..time.."|cffFFBF00> |cffFFFFFF"..self)
        end
      end

      -- modes
      function demoCore:updateModes()
        -- Modes
        mode.aoe = data["DemoAoE"]
        mode.cooldowns = data["DemoCooldowns"]
        mode.defensive = data["DemoDefensive"]
        mode.healing = data["DemoInterrupts"]
        debugEnabled = isChecked("Debug")
      end

      -- Health Stone
      function demoCore:useHealthStone()
        if health <= getValue("Healthstone") then
          return useItem(5512) == true or false
        end
      end
    end
  end
end

if select(3,UnitClass("player")) == 9 then
  function AfflictionFunctions()
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
          shadowBolt = 686,
        }
      }

      -- Global
      core = demoCore

      -- localise commonly used functions
      local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
      local UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies = UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies
      local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
      local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
      local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
      local canCast,isKnown,enemiesTable,GetSpellCharges = canCast,isKnown,enemiesTable,GetSpellCharges
      local UnitHealth,castDotCycle,print,UnitHealthMax = UnitHealth,castDotCycle,print,UnitHealthMax
      local GetSpellInfo,UnitCastingInfo,GetTime,floor = GetSpellInfo,UnitCastingInfo,GetTime,math.floor
      local nNova,useItem,getDebuffRemain = nNova,useItem,getDebuffRemain

      -- no external access after here
      setfenv(1,demoCore)

      function demoCore:ooc()
        -- update modes
        updateModes()
        -- Talents (refresh ooc)

        -- Glyph (refresh ooc)
        combatTime = GetTime()
        inCombat = false
        health = getHP(player)
        nNova = nNova
      end

      -- this will be used to make the core refresh itself
      function demoCore:update()
        -- update modes
        updateModes()
        -- player stats
        nNova = nNova
        inCombat = true
        health = getHP(player)
        mana = UnitPower(player,0)
        -- Buffs

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
        mode.aoe = BadBoy_data["DemoAoE"]
        mode.cooldowns = BadBoy_data["DemoCooldowns"]
        mode.defensive = BadBoy_data["DemoDefensive"]
        mode.healing = BadBoy_data["DemoInterrupts"]
        debugEnabled = isChecked("Debug")
      end

      -- Health Stone
      function demoCore:useHealthStone()
        if useItem(5512) then
          return
        end
      end
    end
  end
end

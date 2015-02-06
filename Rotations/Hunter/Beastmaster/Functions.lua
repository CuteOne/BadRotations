if select(3, UnitClass("player")) == 3 then
  function HunterBeastFunctions()
    -- we want to build core only only
    if core == nil then

      -- build core
      local beastCore = {
        -- player stats
        buff = { },
        cd = { },
        health = 100,
        focus = 0,
        inCombat = false,
        targetEnemiesIn10 = 0,
        mode = { },
        talent = { },
        units = { },
        seal = true,
        spell = {
          -- add spells here
          adaptation = 152244,
          aMurderOfCrows = 131894,
          bestialWrath = 19574,
          exoticAmunition = 162534,
          focusingShot = 152245,
          glaiveToss = 117050,
          powershot = 109259,
          stampede = 121818,
        }
      }

      -- Global
      core = beastCore

      -- localise commonly used functions
      local isKnown,hasGlyph,getHP,getPower,getBuffRemain,UnitHealthMax = isKnown,hasGlyph,getHP,getPower,getBuffRemain,UnitHealthMax
      local castSpell = castSpell
      -- no external access after here
      setfenv(1,beastCore)

      function beastCore:ooc()
        -- Talents (refresh ooc)
        self.talent.adaptation = isKnown(self.spell.adaptation)
        self.talent.aMurderOfCrows = isKnown(self.spell.aMurderOfCrows)
        self.talent.exoticAmunition = isKnown(self.spell.exoticAmunition)
        self.talent.focusingShot = isKnown(self.spell.focusingShot)
        self.talent.glaiveToss = isKnown(self.spell.glaiveToss)
        self.talent.powershot = isKnown(self.spell.powershot)
        self.talent.stampede = isKnown(self.spell.stampede)
        self.inCombat = false
      end

      -- this will be used to make the core refresh itself
      function beastCore:update()
        self.inCombat = true
        -- player stats
        self.health = getHP(player)
        self.focus = getPower(player)
        -- Buffs
        -- Cooldowns
        self.buff.bestialWrath = getBuffRemain(player,self.spell.bestialWrath)
        -- Units
        self.targetEnemiesIn10 = #getEnemies(target,10)
        -- Modes
        self.mode.aoe = BadBoy_data["AoE"]
        self.mode.cooldowns = BadBoy_data["Cooldowns"]
        self.mode.defensive = BadBoy_data["Defensive"]
        -- dynamic units
        self.units.dyn25 = dynamicTarget(25,true)
        self.units.dyn30 = dynamicTarget(30,true)
        self.units.dyn30AoE = dynamicTarget(30,false)
        self.units.dyn40 = dynamicTarget(40,true)
        self.units.dyn40AoE = dynamicTarget(40,false)
      end

      -- Bestial Wrath
      function beastCore:castBestialWrath()
        if isSelected("Bestial Wrath") then
          if (isDummy(self.units.dyn40) or (UnitHealth(self.units.dyn40) >= 400*UnitHealthMax(player)/100)) then
            return castSpell(player,self.spell.bestialWrath,true,false) == true or false
          end
        end
      end








    end
  end
end























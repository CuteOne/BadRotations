if select(3, UnitClass("player")) == 1  then

  function ProtWarriorFunctions()

    -- build core
    local protCore = {
      profile = "Protection",
      -- player stats
      buff = { },
      combatStarted = 0,
      cd = { },
      globalCooldown = 0,
      glyph = { },
      health = 100,
      inCombat = false,
      melee5Yards = 0,
      mode = { },
      nova = {
        lowestHP = 0,
        lowestUnit = "player",
        lowestTankHP = 0,
        lowestTankUnit = "player"
      },
      rage =0,
      stance = 2,
      talent = { },
      units = { },
      spell = {
        Charge        = 100,
        DemoralizingBanner  = 114203,
        DemoralizingShout = 1160,
        Devastate     = 20243,
        Execute       = 5308,
        Hamstring     = 1715,
        HeroicLeap      = 6544,
        HeroicStrike    = 78,
        HeroicThrow     = 57755,
        Intervene     = 3411,
        IntimidatingShout   = 5246,
        LastStand     = 12975,
        MockingBanner   = 114192,
        Pummel        = 6552,
        RallyingCry     = 97462,
        Revenge       = 6572,
        ShatteringThrow   = 64382,
        ShieldBarrier   = 112048,
        ShieldBlock     = 2565,
        ShieldCharge = 156321,
        ShieldChargeBuff = 169667,
        ShieldSlam      = 23922,
        ShieldWall      = 871,
        SpellReflection   = 23920,
        Taunt       = 355,
        ThunderClap     = 6343,
        VictoryRush     = 34428,
        EnragedRegeneration = 55694,
        ImpendingVictory  = 103840,
        Bladestorm      = 46924,
        Shockwave     = 46968,
        DragonRoar      = 118000,
        MassSpellReflection = 114028,
        Safeguard     = 114029,
        Vigilance     = 114030,
        Avatar        = 107574,
        Bloodbath     = 12292,
        StormBolt     = 107570,
        Ravager           = 152277,
        Siegebreaker    = 176289,
        SuddenDeathTalent   = 29725,
        UnquenchableThirst  = 169683,
        UnyieldingStrikesTalent = 169685,
        UnyieldingStrikesAura = 169686,
        BattleStance    = 2457,
        DefensiveStance   = 71,
        GladiatorStance = 156291,
        BattleShout     = 6673,
        BerserkerRage     = 18499,
        CommandingShout   = 469,
      }
    }

    -- Global
    core = protCore

    -- localise commonly used functions
    local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
    local UnitBuffID,isInMelee,getSpellCD,getEnemies = UnitBuffID,isInMelee,getSpellCD,getEnemies
    local player,data,GetShapeshiftForm,dynamicTarget = "player",bb.data,GetShapeshiftForm,dynamicTarget
    local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
    local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
    local getGround,canCast,isKnown,sp = getGround,canCast,isKnown,core.spells
    local UnitHealth,print,UnitHealthMax = UnitHealth,print,UnitHealthMax
    local getDistance,getDebuffRemain,GetTime,getFacing = getDistance,getDebuffRemain,GetTime,getFacing
    local getOptionCheck = getOptionCheck
    local useItem, isBuffed, isBoss = useItem, isBuffed, isBoss
    -- no external access after here
    setfenv(1,protCore)

    function protCore:ooc()

      -- Talents (refresh ooc)
      self.talent.UnyieldingStrikes = isKnown(self.spell.UnyieldingStrikesTalent)
      self.talent.DragonRoar  = isKnown(self.spell.DragonRoar)
      self.talent.StormBolt = isKnown(self.spell.StormBolt)
      self.talent.Shockwave = isKnown(self.spell.Shockwave)
      self.talent.Bloodbath = isKnown(self.spell.Bloodbath)

      -- Glyph (refresh ooc)


      --Stance Selector
      if getValue("Stance") == 1 then
        self.stance = 1
      else
        self.stance = 2
      end

      self.inCombat = false
    end

    -- this will be used to make the core refresh itself
    function protCore:update()
      -- player stats
      self.health = getHP(player)
      self.rage = UnitPower(player)
      -- Buffs
      self.buff.ShieldBlock = getBuffRemain(player,self.spell.ShieldBlock)
      self.buff.ShieldBarrier = getBuffRemain(player,self.spell.ShieldBarrier)
      self.buff.ShieldCharge = getBuffRemain(player,self.spell.ShieldChargeBuff)
      self.buff.ShieldWall = getBuffRemain(player,self.spell.ShieldWall)
      self.buff.LastStand = getBuffRemain(player,self.spell.LastStand)
      self.buff.Ultimatum = getBuffRemain(player, 122510)
      self.buff.UnyieldingStrikesStack = getBuffStacks(player, self.spell.UnyieldingStrikesAura)
      self.buff.SuddenDeath = getBuffRemain(player,self.spell.SuddenDeathTalent)
      self.buff.Ravager = getBuffRemain(player, self.spell.Ravager)
      self.buff.EnragedRegeneration = getBuffRemain(player, self.spell.EnragedRegeneration)
      self.buff.Bloodbath = getBuffRemain(player, self.spell.Bloodbath)
      -- Cooldowns
      self.cd.DemoralizingShout = getSpellCD(self.spell.DemoralizingShout)
      self.cd.LastStand = getSpellCD(self.spell.LastStand)
      self.cd.ShieldBlock = getSpellCD(self.spell.ShieldBlock)
      self.cd.ShieldWall = getSpellCD(self.spell.ShieldWall)
      self.cd.DragonRoar = getSpellCD(self.spell.DragonRoar)
      self.cd.StormBolt = getSpellCD(self.spell.StormBolt)
      self.cd.Shockwave = getSpellCD(self.spell.Shockwave)
      self.cd.Bloodbath = getSpellCD(self.spell.Bloodbath)
      self.globalCooldown = getSpellCD(self.spell.Devastate)
      self.inCombat = true
      -- Units
      self.melee5Yards = #getEnemies(player,5) -- (meleeEnemies)
      -- Modes
      self.mode.aoe = data["AoE"]
      self.mode.cooldowns = UseCDs()
      self.mode.defensive = data["Defensive"]
      self.mode.interupts = data["Interrupts"]
      -- truth = true, right = false
      self.stance = GetShapeshiftForm()
      -- dynamic units
      self.units.dyn5 = dynamicTarget(5,true)
      self.units.dyn5AoE = dynamicTarget(5,false)
      self.units.dyn8AoE = dynamicTarget(8,false)
      self.units.dyn25AoE = dynamicTarget(25,false)
      self.units.dyn30 = dynamicTarget(30,true)
      self.units.dyn30AoE = dynamicTarget(30,false)
      self.units.dyn40 = dynamicTarget(40,true)

      -- Generic Lowest Tank and Raider
      local validMembers = 0

      -- others
      self.unitInFront = getFacing("player",self.units.dyn5) == true or false
      self.combatLenght = GetTime() - bb.data["Combat Started"]
    end

    --Cooldowns
    function UseCDs()
      if (bb.data['Cooldowns'] == 1 and isBoss()) or bb.data['Cooldowns'] == 2 then
        return true
      else
        return false
      end
    end

    -- Last Stand
    function protCore:castLastStand()
      return isChecked("Last Stand") and self.health <= getValue("Last Stand") and castSpell(player,self.spell.LastStand,true,false)
    end

    -- Shield Wall
    function protCore:castShieldWall()
      return isChecked("Shield Wall") and self.health <= getValue("Shield Wall") and castSpell(player,self.spell.ShieldWall,true,false)
    end

    -- Enraged Regeneration
    function protCore:castEnragedRegeneration()
      return isChecked("Enraged Regeneration") and self.health <= getValue("Enraged Regeneration") and castSpell(player,self.spell.EnragedRegeneration,true,false)
    end

    -- Healthstone
    function protCore:useHealthstone()
      return isChecked("Healthstone") and self.health <= getValue("Healthstone") and useItem(5512)
    end

    -- TODO create functions for shouts and other buffs we might want to add
    function protCore:castBuffs()
      --Def Stance
      if self.stance == 2 then
        if GetShapeshiftForm() ~= 2 then
          if castSpell("player",self.spell.DefensiveStance,true, false) then return; end
        end
      end
      --Glad stance
      if self.stance == 1 then
        if GetShapeshiftForm() ~= 1 then
          if castSpell("player",self.spell.BattleStance,true, false) then return; end
        end
      end
      -- Commanding Shout
      if isChecked("Shout") == true and getValue("Shout") == 1 and not UnitExists("mouseover") then
        for i = 1, #bb.friend do
          local unit = bb.friend[i]
          if not isBuffed(unit.unit,{21562,109773,469,90364})  and getDistance("player", unit.unit) < 40 then
            if castSpell("player",self.spell.CommandingShout,false,false) then return; end
          end
        end
      end
      -- Battle Shout
      if isChecked("Shout") == true and getValue("Shout") == 2 and not UnitExists("mouseover") then
        for i = 1, #bb.friend do
          local unit = bb.friend[i]
          if not isBuffed(unit.unit,{57330,19506,6673}) and getDistance("player", unit.unit) < 40 then
            if castSpell("player",self.spell.BattleShout,false,false) then return; end
          end
        end
      end
    end


    -- ShieldBlock
    function protCore:castShieldBlock()
      return castSpell(player,self.spell.ShieldBlock,true,false)
    end

    -- ShieldBarrier
    function protCore:castShieldBarrier()
      return castSpell(player,self.spell.ShieldBarrier,true,false)
    end

    -- Heroic Strike
    function protCore:castHeroicStrike()
      return castSpell(self.units.dyn5,self.spell.HeroicStrike,false,false)
    end

    -- ShieldSlam
    function protCore:castShieldSlam()
      return castSpell(self.units.dyn5,self.spell.ShieldSlam,false,false)==true or false
    end

    -- Revenge
    function protCore:castRevenge()
      return castSpell(self.units.dyn5,self.spell.Revenge,false,false)==true or false
    end

    -- Ravager
    function protCore:castRavager()
      return self.mode.cooldowns and isChecked("Auto Ravager") and castGround(self.units.dyn5,self.spell.Ravager,10)
    end

    -- StormBolt TODO Fix dyn range
    function protCore:castStormBolt()
      return self.mode.cooldowns and castSpell(self.units.dyn5,self.spell.StormBolt,false,false)
    end

    -- DragonRoar
    function protCore:castDragonRoar()
      return self.mode.cooldowns and castSpell(self.units.dyn5,self.spell.DragonRoar,true,false)
    end

    -- ImpendingVictory
    function protCore:castImpendingVictory()
      return castSpell(self.units.dyn5,self.spell.ImpendingVictory,false,false)
    end

    -- Execute
    function protCore:castExecute()
      return castSpell(self.units.dyn5,self.spell.Execute,false,false)==true or false
    end

    -- Devastate
    function protCore:castDevastate()
      return castSpell(self.units.dyn5,self.spell.Devastate,false,false)==true or false
    end

    -- Shockwave
    -- TODO add check box checks
    function protCore:castShockwave()
      return castSpell(self.units.dyn5,self.spell.Shockwave,true,false)
    end

    -- Bladestorm
    -- TODO add check box checks
    function protCore:castBladestorm()
      return self.mode.cooldowns and isChecked("Auto Bladestorm") and castSpell(self.units.dyn5,self.spell.Bladestorm,true, false)
    end

    -- Bloodbath
    function protCore:castBloodbath()
      return self.mode.cooldowns and isChecked("Auto Bloodbath") and castSpell(player,self.spell.Bloodbath,true, false)
    end

    -- Avatar
    function protCore:castAvatar()
      return self.mode.cooldowns and isChecked("Auto Avatar") and castSpell(player,self.spell.Avatar,true, false)
    end

    -- ThunderClap
    function protCore:castThunderClap()
      return castSpell(self.units.dyn5,self.spell.ThunderClap,true, false)==true or false
    end
  end  --end for ProtWArriorFunctions

end
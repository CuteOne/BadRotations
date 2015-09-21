if select(3,UnitClass("player")) == 10 then

  ------Member Check------
  function CalculateHP(unit)
    incomingheals = UnitGetIncomingHeals(unit) or 0
    return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
  end

  function GroupInfo()
    members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
    group.type = IsInRaid() and "raid" or "party"
    group.number = GetNumGroupMembers()
    if group.number > 0 then
      for i=1,group.number do
        if canHeal(group.type..i) then
          local unit, hp = group.type..i, CalculateHP(group.type..i)
          members[#members+1] = { Unit = unit, HP = hp }
          if hp < 90 then group.low = group.low + 1 end
          if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
        end
      end
      if group.type == "raid" and #members > 1 then table.remove(members,1) end
      table.sort(members, function(x,y) return x.HP < y.HP end)
    end
  end

  -- function getDistance2(Unit1,Unit2)
  --     if Unit2 == nil then Unit2 = "player"; end
  --     if ObjectExists(Unit1) and ObjectExists(Unit2) then
  --         local X1,Y1,Z1 = ObjectPosition(Unit1);
  --         local X2,Y2,Z2 = ObjectPosition(Unit2);
  --         local unitSize = 0;
  --         if UnitGUID(Unit1) ~= UnitGUID("player") and UnitCanAttack(Unit1,"player") then
  --             unitSize = UnitCombatReach(Unit1);
  --         elseif UnitGUID(Unit2) ~= UnitGUID("player") and UnitCanAttack(Unit2,"player") then
  --             unitSize = UnitCombatReach(Unit2);
  --         end
  --         local distance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2))
  --         if distance < max(5, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 4/3) then
  --             return 4.9999
  --         elseif distance < max(8, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 6.5) then
  --             if distance-unitSize <= 5 then
  --                 return 5
  --             else
  --                 return distance-unitSize
  --             end
  --         elseif distance-(unitSize+UnitCombatReach("player")) <= 8 then
  --             return 8
  --         else
  --             return distance-(unitSize+UnitCombatReach("player"))
  --         end
  --     else
  --         return 1000;
  --     end
  -- end
  -- -- if getEnemiesTable("target",10) >= 3 then
  -- function getEnemiesTable(Unit,Radius)
  --     local enemiesTable = {};
  --     if ObjectExists("target") == true and getCreatureType("target") == true then
  --         if UnitCanAttack("player","target") == true and UnitIsDeadOrGhost("target") == false then
  --             local myDistance = getDistance("player","target")
  --             if myDistance <= Radius then
  --                 table.insert(enemiesTable, { unit = "target" , range = myDistance });
  --             end
  --         end
  --     end
  --     for i=1,ObjectCount() do
  --         if bit.band(ObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
  --             local thisUnit = ObjectWithIndex(i);
  --             if UnitGUID(thisUnit) ~= UnitGUID("target") and getCreatureType(thisUnit) == true then
  --                 if UnitCanAttack("player",thisUnit) == true and UnitIsDeadOrGhost(thisUnit) == false then
  --                     local myDistance = getDistance("player",thisUnit)
  --                     if myDistance <= Radius then
  --                         table.insert({ unit = thisUnit , range = myDistance });
  --                     end
  --                 end
  --             end
  --         end
  --     end
  --     return enemiesTable;
  -- end

  function canToD()
    local thisUnit = dynamicTarget(5,true)
    if (getHP(thisUnit)<=10 or UnitHealth(thisUnit)<=UnitHealthMax("player")) and not UnitIsPlayer(thisUnit) then
      return true
    else
      return false
    end
  end

  function canEnhanceToD()
    local thisUnit = dynamicTarget(5,true)
    local boostedHP = UnitHealthMax("player")+(UnitHealthMax("player")*0.2)
    if (getHP(thisUnit)<=10 or (UnitHealth(thisUnit)<=boostedHP)) and UnitHealth(thisUnit) > UnitHealthMax("player") and not UnitIsPlayer(thisUnit) then
      return true
    else
      return false
    end
  end

  function useAoE()
    if ((BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2) and UnitLevel("player")>=46 then
      return true
    else
      return false
    end
  end


  function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
      return true
    else
      return false
    end
  end

  function useDefensive()
    if BadBoy_data['Defensive'] == 1 then
      return true
    else
      return false
    end
  end

  function useInterrupts()
    if BadBoy_data['Interrupts'] == 1 then
      return true
    else
      return false
    end
  end

  function getFacingDistance()
    if UnitIsVisible("player") and UnitIsVisible("target") then
      --local targetDistance = getRealDistance("player","target")
      local Y1,X1,Z1 = GetObjectPosition("player");
      local Y2,X2,Z2 = GetObjectPosition("target");
      local Angle1 = GetObjectFacing("player")
      local deltaY = Y2 - Y1
      local deltaX = X2 - X1
      Angle1 = math.deg(math.abs(Angle1-math.pi*2))
      if deltaX > 0 then
        Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
      elseif deltaX <0 then
        Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
      end
      local Dist = round2(math.tan(math.abs(Angle2 - Angle1)*math.pi/180)*targetDistance*10000)/10000
      if ObjectIsFacing("player","target") then
        return Dist
      else
        return -(math.abs(Dist))
      end
    else
      return 1000
    end
  end

  function usingFSK()
      if select(3,GetSpellInfo(101545)) == "INTERFACE\\ICONS\\priest_icon_chakra_green" then
          return true
      else
          return false
      end
  end

  function canFSK(unit)
  	local targetDistance = getRealDistance("player","target")
    if ((targetDistance < 5 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5)) 
      and not hasGlyph(1017)
      and ((getSpellCD(_FlyingSerpentKick)==0 and not usingFSK()) 
          or usingFSK())
      and (getFacingDistance() < 5 and getFacingDistance()>0)
      and not UnitIsDeadOrGhost(unit)
      and getTimeToDie(unit) > 10
      and not IsSwimming()
    then
      return true
    else
      return false
    end
  end

  function getOption(spellID)
    return tostring(select(1,GetSpellInfo(spellID)))
  end


  -- function castTimeRemain(unit)
  --  if select(6,UnitCastingInfo(unit)) then
  --      castEndTime = select(6,UnitCastingInfo(unit))
  --      return ((castEndTime/1000) - GetTime())
  --  else
  --      return 0
  --  end
  -- end
  -- if castTimeRemain("target")>0 and castTimeRemain("target")<1 then
  --  RunMacroText("/kneel")
  --  ChatOverlay("Kneeling to the Flame")
  -- end
  --Trapping
  -- if trapTimer==nil then trapTimer = 0 end
  -- if trapping==nil or not isInCombat("player") then trapping = false end
  -- if UnitCreatureType("target")=="Beast" and GetItemCount(113991) > 0 then
  --  if canUse(113991)
  --      and ((getDistance("player","target")<5 and getHP("target")<100)
  --          or (getDistance("player","target")<40 and getDistance("player","target")>=5))
  --      and getHP("target")>0
  --  then
  --      useItem(113991)
  --      trapTimer=GetTime()
  --  end
  --  if getDistance("player","target")<40 and getDistance("player","target")>=5
  --      and trapTimer <= GetTime()-4
  --  then
  --      if castSpell("target",_Provoke,false,false,false) then trapping = true return end
  --  end
  -- end

-- Def Windwalker Functions
function MonkWwFunctions()
    -- we want to build core only once
    if core == nil then
      
      -- Build core
      local wwCore = {
        profile = "Windwalker",
        -- player stats
        buff = { },
        cd = { },
        charges = { },
        channel = { },
        glyph = { },
        health = 100,
        chi = 0,
        chiMax = 0,
        chiDiff = 0,
        energyTimeToMax = 0,
        inCombat = false,
        melee5Yards = 0,
        melee8Yards = 0,
        melee10Yards = 0,
        melee12Yards = 0,
        mode = { },
        recharge = { },
        stacks = { },
        talent = { },
        units = { },
        spell = {
          blackoutKick               =   100784,  --Blackout Kick
          chiBrew                    =   115399,  --Chi Brew
          chiBurst          = 123986, --Chi Burst
          chiExplosion        = 152174, --Chi Explosion
          chiWave                    =   115098,  --Chi Wave
          cracklingJadeLightning     =   117952,  --Crackling Jade Lightning
          dampenHarm                 =   122278,  --Dampen Harm
          diffuseMagic        = 122783, --Diffuse Magic
          disable                    =   116095,  --Disable
          detox                      =   115450,  --Detox
          energizingBrew             =   115288,  --Energizing Brew
          expelHarm                  =   115072,  --Expel Harm
          fistsOfFury                =   113656,  --Fists of Fury
          flyingSerpentKick          =   101545,  --Flying Serpent Kick
          flyingSerpentKickEnd       =   115057,  --Flying Serpent Kick End
          fortifyingBrew             =   115203,  --Fortifying Brew
          hurricaneStrike     = 152175, --Hurricane Strike
          invokeXuen                 =   123904,  --Invoke Xuen
          jab                        =   108557,  --Jab
          legSweep                   =   119381,  --Leg Sweep
          legacyOfTheWhiteTiger      =   116781,  --Legacy of the White Tiger
          nimbleBrew                 =   137562,  --Nimble Brew
          paralysis                  =   115078,  --Paralysis
          provoke                    =   115546,  --Provoke
          quakingPalm                =   107079,  --Quaking Palm
          risingSunKick             =   107428,  --Raising Sun Kick
          resuscitate                =   115178,  --Resuscitate
          rushingJadeWind     = 116847, --Rushing Jade Wind
          serenity          = 152173, --Serenity
          spinningCraneKick          =   101546,  --Spinning Crane Kick
          stanceOfTheFierceTiger     =   103985,  --Stance of the Fierce Tiger
          stormEarthFire        = 137639, --Storm, Earth, and Fire
          stormEarthFireDebuff       =   138130,  --Storm, Earth, and Fire
          spearHandStrike            =   116705,  --Spear Hand Strike
          surgingMist       = 116694, --Surging Mist
          tigereyeBrew        = 116740, --Tigereye Brew Damage
          tigereyeBrewStacks          =   125195,  --Tigereye Brew Stacks
          tigersLust          = 116841, --Tiger's Lust
          tigerPalm                  =   100787,  --Tiger Palm
          touchOfDeath               =   115080,  --Touch of Death
          touchOfKarma               =   122470,  --Touch of Karma
          zenMeditation       = 115176, --Zen Meditation
          zenPilgramage              =   126892,  --Zen Pilgramage
          zenSphere                  =   124081,  --Zen Sphere
          deathNote                  =   121125, --Tracking Touch of Death Availability
          tigerPower                 =   125359, --Tiger Power
          comboBreakerTigerPalm      =   118864, --Combo Breaker: Tiger Palm
          comboBreakerBlackoutKick   =   116768, --Combo Breaker: Blackout Kick
          comboBreakerChiExplosion  = 159407, --Combo Breaker: Chi Explosion
          zenSphereBuff              =   124081, --Zen Sphere Buff
          disableDebuff              =   116706, --Disable (root)
        }
      }
    

      -- Global
      core = wwCore

      -- localise commonly used functions
      local getHP,getChi,getChiMax,hasGlyph,UnitPower,UnitPowerMax,getBuffRemain,getBuffStacks = getHP,getChi,getChiMax,hasGlyph,UnitPower,UnitPowerMax,getBuffRemain,getBuffStacks
      local UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies = UnitBuffID,IsSpellOverlayed,getSpellCD,getEnemies
      local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
      local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
      local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
      local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
      local UnitHealth,print,UnitHealthMax,getCharges = UnitHealth,print,UnitHealthMax,getCharges
      local canTrinket,useItem,GetInventoryItemID,UnitSpellHaste = canTrinket,useItem,GetInventoryItemID,UnitSpellHaste
      local getPower,getRegen,getRecharge,GetInventorySlotInfo,GetItemInfo = getPower,getRegen,getRecharge,GetInventorySlotInfo,GetItemInfo

      -- no external access after here
      setfenv(1,wwCore)

      -- Refresh out of combat
      function wwCore:ooc()
        -- Talents (refresh ooc)
        self.talent.chiWave     = isKnown(self.spell.chiWave)
        self.talent.zenSphere     = isKnown(self.spell.zenSphere)
        self.talent.chiBurst    = isKnown(self.spell.chiBurst)
        self.talent.serenity    = isKnown(self.spell.serenity)
        self.talent.chiBrew     = isKnown(self.spell.chiBrew)
        self.talent.chiExplosion  = isKnown(self.spell.chiExplosion)
        self.talent.hurricaneStrike = isKnown(self.spell.hurricaneStrike)
        self.talent.rushingJadeWind = isKnown(self.spell.rushingJadeWind)
        self.talent.powerStrikes  = isKnown(121817)

        -- GET Jab SpellID
        local itemId = GetInventoryItemID(player,select(1,GetInventorySlotInfo("MainHandSlot")))
        local _, _, _, _, _, _, SubType, _ = GetItemInfo(itemId)

        -- Jab IDS: Staff   - 108557,
        --      Axe   - 115687,
        --      Mace  - 115693,
        --      Sword   - 115695,
        --      Polearm - 115698
        if SubType == "Staves" then
          self.spell.jab = 108557
        elseif SubType == "One-Handed Axes" or SubType == "Two-Handed Axes" then
          self.spell.jab = 115687
        elseif SubType == "One-Handed Maces" or SubType == "Two-Handed Maces" then
          self.spell.jab = 115693
        elseif SubType == "One-Handed Swords" or SubType == "Two-Handed Swords" then
          self.spell.jab = 115695
        elseif SubType == "Polearms" then
          self.spell.jab = 115698
        end
        -- END get Jab Spellid

        -- Glyph (refresh ooc)
        self.glyph.touchOfDeath = hasGlyph(1014)

        self.inCombat = false
      end

      -- this will be used to make the core refresh itself
      function wwCore:update()
        -- player stats
        self.health   = getHP(player)
        self.chi    = getChi(player)
        self.chiMax   = getChiMax(player)
        self.chiDiff  = self.chiMax - self.chi

        -- Buffs
        self.buff.comboBreakerBlackoutKick  = getBuffRemain(player,self.spell.comboBreakerBlackoutKick)
        self.buff.comboBreakerChiExplosion  = getBuffRemain(player,self.spell.comboBreakerChiExplosion)
        self.buff.comboBreakerTigerPalm   = getBuffRemain(player,self.spell.comboBreakerTigerPalm)
        self.buff.energizingBrew      = getBuffRemain(player,self.spell.energizingBrew)
        self.buff.serenity          = getBuffRemain(player,self.spell.serenity)
        self.buff.tigereyeBrew        = getBuffRemain(player,self.spell.tigereyeBrew)
        self.buff.tigereyeBrewStacks    = getBuffRemain(player,self.spell.tigereyeBrewStacks)
        self.buff.tigerPower        = getBuffRemain(player,self.spell.tigerPower)
        self.buff.zenSphere         = getBuffRemain(player,self.spell.zenSphere)

        -- Buff Stacks
        self.stacks.tigereyeBrewStacks  = getBuffStacks(player,self.spell.tigereyeBrewStacks)
        self.stacks.stormEarthFire    = getBuffStacks(player,self.spell.stormEarthFire)

        -- Buff Charges
        self.charges.chiBrew  = getCharges(self.spell.chiBrew)

        -- Buff Recharge
        self.recharge.chiBrew   = getRecharge(self.spell.chiBrew)

        -- Cooldowns
        self.cd.fistsOfFury   = getSpellCD(self.spell.fistsOfFury)
        self.cd.hurricaneStrike = getSpellCD(self.spell.hurricaneStrike)
        self.cd.touchOfDeath  = getSpellCD(self.spell.touchOfDeath)
        self.cd.serenity    = getSpellCD(self.spell.serenity)
        self.cd.risingSunKick   = getSpellCD(self.spell.risingSunKick)
        self.cd.invokeXuen    = getSpellCD(self.spell.invokeXuen)

        -- Channel Time
        self.channel.fistsOfFury    = 4-(4*UnitSpellHaste(player)/100)
        self.channel.hurricaneStrike  = 2-(2*UnitSpellHaste(player)/100)

        self.energyTimeToMax  = (UnitPowerMax(player)-UnitPower(player)) / (10*(1+(UnitSpellHaste(player)/100)))
        

        -- Global Cooldown = 1.5 / ((Spell Haste Percentage / 100) + 1)
        --local gcd = (1.5 / ((UnitSpellHaste(player)/100)+1))
        --if gcd < 1 then
        --  self.cd.globalCooldown = 1
        --else
        --  self.cd.globalCooldown = gcd
        --end
        
        self.inCombat = true

        -- Units
        self.melee5Yards  = #getEnemies(player,5)
        self.melee8Yards  = #getEnemies(player,8)
        self.melee10Yards   = #getEnemies(player,10)
        self.melee12Yards   = #getEnemies(player,12) 

        -- Modes
        self.mode.sef     = BadBoy_data["SEF"]
        self.mode.cooldowns = BadBoy_data["Cooldowns"]
        --self.mode.defensive = BadBoy_data["Defensive"]
        --self.mode.healing = BadBoy_data["Healing"]

        -- dynamic units
        self.units.dyn5   = dynamicTarget(5,true)

        self.units.dyn8AoE  = dynamicTarget(8,false)
        self.units.dyn8   = dynamicTarget(8,true)

        self.units.dyn10  = dynamicTarget(10,true)

        self.units.dyn12  = dynamicTarget(12,true)
        self.units.dyn12AoE = dynamicTarget(12,false)

        self.units.dyn25  = dynamicTarget(25,true)
        self.units.dyn25AoE = dynamicTarget(25,false)

        self.units.dyn30  = dynamicTarget(30,true)
        self.units.dyn40  = dynamicTarget(40,true)
        self.units.dyn40AoE = dynamicTarget(40,false)
        -- 
      end

      -- Blackout Kick
      function wwCore:castBlackoutKick()
        return castSpell(self.units.dyn5,self.spell.blackoutKick,false,false) == true or false
      end

      -- Chi Brew
      function wwCore:castChiBrew()
        if isSelected("Chi Brew") then
          return castSpell(player,self.spell.chiBrew,true,false) == true or false
        end
      end

      -- Chi Burst
      function wwCore:castChiBurst()
        if isSelected("Talent Row 2") then
          return castSpell(self.units.dyn40,self.spell.chiBurst,false,false) == true or false
        end
      end

      -- Chi Explosion
      function wwCore:castChiExplosion()
        return castSpell(self.units.dyn30,self.spell.chiExplosion,false,false) == true or false
      end

      -- Chi Wave
      function wwCore:castChiWave()
        if isSelected("Talent Row 2") then
          return castSpell(self.units.dyn25AoE,self.spell.chiWave,true,false) == true or false
        end
      end

      -- Crackling Jade Lightning
      -- TODO: add into rotation if not in melee range and stand still for > 1
      function wwCore:castCracklingJadeLightning()
        return castSpell(self.units.dyn40,self.spell.cracklingJadeLightning,false,false) == true or false
      end

      -- Energizing Brew
      function wwCore:castEnergizingBrew()
        if isSelected("Energizing Brew") then
          return castSpell(player,self.spell.energizingBrew,true,false) == true or false
        end
      end

      -- Expel Harm
      function wwCore:castExpelHarm()
        return castSpell(player,self.spell.expelHarm,true,false) == true or false
      end

      -- TODO: Glyph range extend
      function wwCore:castFistsOfFury()
        return castSpell(self.units.dyn5,self.spell.fistsOfFury,false,false) == true or false
      end

      -- TODO: Flying Serpent Kick

      -- Fortifying Brew
      function wwCore:castFortifyingBrew()
        if isSelected("Fortifying Brew") and isSelected("Touch Of Death") then
          return castSpell(player,self.spell.fortifyingBrew,true,false) == true or false
        end
      end

      -- Hurricane Strike
      function wwCore:castHurricaneStrike()
        return castSpell(self.units.dyn12AoE,self.spell.hurricaneStrike,true,false) == true or false
      end

      -- Invoke Xuen
      function wwCore:castInvokeXuen()
        if isSelected("Invoke Xuen") then
          return castSpell(self.units.dyn40,self.spell.invokeXuen,true,false) == true or false
        end
      end

      -- Jab
      -- TODO: different spellids needed?
      function wwCore:castJab()
        return castSpell(self.units.dyn5,self.spell.jab,false,false) == true or false
      end

      -- TODO: Nimble Brew

      -- TODO: Paralysis

      -- TODO: Resuscitate

      -- Rising Sun Kick
      function wwCore:castRisingSunKick()
        return castSpell(self.units.dyn5,self.spell.risingSunKick,false,false) == true or false
      end

      -- TODO: Roll

      -- Rushing Jade Wind
      function wwCore:castRushingJadeWind() -- 8y
        return castSpell(player,self.spell.rushingJadeWind,true,false) == true or false
      end

      -- Serenity
      function wwCore:castSerenity()
        if isSelected("Serenity") then
          return castSpell(player,self.spell.serenity,true,false) == true or false
        end
      end

      -- TODO: Spear Hand Strike

      -- Spinning Crane Kick
      function wwCore:castSpinningCraneKick() -- 8y
        return castSpell(player,self.spell.spinningCraneKick,true,false) == true or false
      end

      -- Storm Earth Fire
      function wwCore:castStormEarthFire()
        return castSpell(self.units.dyn40AoE,self.spell.stormEarthFire,true,false) == true or false
      end

      -- Surging Mist
      function wwCore:castSurgingMist()
        return castSpell(player,self.spell.surgingMist,true,false) == true or false
      end

      -- Tigerpalm
      function wwCore:castTigerPalm()
        return castSpell(self.units.dyn5,self.spell.tigerPalm,false,false) == true or false
      end

      -- Tigereye Brew
      function wwCore:castTigereyeBrew()
        return castSpell(player,self.spell.tigereyeBrew,true,false) == true or false
      end

      -- Touch of Death
      function wwCore:castTouchOfDeath()
        if isSelected("Touch Of Death") then
          return castSpell(self.units.dyn5,self.spell.touchOfDeath,true,false) == true or false
        end
      end

      -- Touch of Karma
      function wwCore:castTouchOfKarma() -- TODO: range glyph, 25y
        return castSpell(self.units.dyn5,self.spell.touchOfKarma,true,false) == true or false
      end

      -- Zen Sphere
      -- Used on self or if already on player cast on focus
      function wwCore:castZenSphere()
        if isSelected("Talent Row 2") then
          if not UnitBuffID(player,self.buff.zenSphere) then
            return castSpell(player,self.spell.zenSphere,true,false) == true or false
          end
          if not UnitBuffID("focus",self.buff.zenSphere) then
            return castSpell("focus",self.spell.zenSphere,true,false) == true or false
          end
          return false
        end
      end

    end -- function wwCore:update()
  end -- function MonkWwFunctions()
end

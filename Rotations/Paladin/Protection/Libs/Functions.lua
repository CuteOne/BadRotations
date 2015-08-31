if select(3,UnitClass("player")) == 2 then
  function PaladinProtFunctions()
    -- we want to build core only only

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
      holyPower = 0,
      inCombat = false,
      melee5Yards = 0,
      melee8Yards = 0,
      melee16Yards = 0,
      mode = { },
      nova = {
        lowestHP = 0,
        lowestUnit = "player",
        lowestTankHP = 0,
        lowestTankUnit = "player"
      },
      recharge = { },
      talent = { },
      units = { },
      seal = true,
      spell = {
        arcaneTorrent = 28730, 
        ardentDefender = 31850,
        avengersShield = 31935,
        consecration = 26573,
        crusaderStrike = 35395,
        divineProtection = 498,
        divinePurpose = 86172,
        divinePurposeBuff = 90174,
        divineShield = 642,
        eternalFlame = 114163,
        executionSentence = 114157,
        fistOfJustice = 105593,
        flashOfLight = 19750,
        guardianOfAncientKings = 86659,
        hammerOfJustice = 853,
        hammerOfTheRighteous = 53595,
        hammerOfWrath = 24275,
        holyAvenger = 105809,
        holyPrism = 114165,
        holyWrath = 119072,
        judgment = 20271,
        layOnHands = 633,
        lightsHammer = 114158,
        rebuke = 96231,
        repentance = 20066,
        righteousFury = 25780,
        sanctifiedWrath = 171648,
        sacredShield = 20925,
        sealOfInsight = 20165,
        sealOfRighteousness = 20154,
        selflessHealerBuff = 114250,
        seraphim = 152262,
        shieldOfTheRighteous = 53600,
        turnEvil = 10326,
        wordOfGlory = 85673,
      }
    }

    -- Global
    core = protCore

    -- localise commonly used functions
    local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
    local UnitBuffID,isInMelee,getSpellCD,getEnemies = UnitBuffID,isInMelee,getSpellCD,getEnemies
    local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
    local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
    local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
    local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
    local UnitHealth,previousJudgmentTarget,print,UnitHealthMax = UnitHealth,previousJudgmentTarget,print,UnitHealthMax
    local getDistance,getDebuffRemain,GetTime,getFacing = getDistance,getDebuffRemain,GetTime,getFacing
    local spellCastersTable,enhancedLayOnHands,getOptionCheck = bb.im.casters,enhancedLayOnHands,getOptionCheck
    local useItem,shouldCleanseDebuff,castBlessing,UnitSpellHaste = useItem,shouldCleanseDebuff,castBlessing,UnitSpellHaste
    -- no external access after here
    setfenv(1,protCore)

    function protCore:ooc()
      -- Talents (refresh ooc)
      self.talent.empoweredSeals = isKnown(152263)
      self.talent.seraphim = isKnown(self.spell.seraphim)
      self.talent.sanctifiedWrath = isKnown(self.spell.sanctifiedWrath)
      -- Glyph (refresh ooc)
      self.glyph.doubleJeopardy = hasGlyph(183)
      self.glyph.consecration = hasGlyph(189)
      self.glyph.focusedShield = hasGlyph(191)
      self.glyph.finalWrath = hasGlyph(194)
      self.buff.righteousFury = UnitBuffID(player,self.spell.righteousFury)
      self.buff.sacredShield = getBuffRemain(player,self.spell.sacredShield)
      self.inCombat = false
    end

    -- this will be used to make the core refresh itself
    function protCore:update()
      -- player stats
      self.health = getHP(player)
      self.holyPower = UnitPower(player,9)
      -- Buffs
      self.buff.ardentDefender = getBuffRemain(player,self.spell.ardentDefender)
      self.buff.bastionOfGlory = getBuffRemain(player,114637)
      self.buff.holyAvenger = getBuffRemain(player,self.spell.holyAvenger)
      self.buff.divineProtection = getBuffRemain(player,self.spell.divineProtection)
      self.buff.divinePurpose = getBuffRemain(player,self.spell.divinePurposeBuff)
      self.buff.grandCrusader = getBuffRemain(player,85416)
      self.buff.guardianOfAncientKings = getBuffRemain(player,self.spell.guardianOfAncientKings)
      self.buff.liadrinsRighteousness = getBuffRemain(player,156989)
      self.buff.righteousFury = UnitBuffID(player,self.spell.righteousFury)
      self.buff.sacredShield = getBuffRemain(player,self.spell.sacredShield)
      self.buff.shieldOfTheRighteous = getBuffRemain(player,132403)
      self.buff.seraphim = getBuffRemain(player,self.spell.seraphim)
      self.buff.uthersInsight = getBuffRemain(player,156988)
      -- Cooldowns
      self.cd.crusaderStrike = getSpellCD(self.spell.crusaderStrike)
      self.cd.divineProtection = getSpellCD(self.spell.divineProtection)
      self.cd.judgment = getSpellCD(self.spell.judgment)
      self.cd.seraphim = getSpellCD(self.spell.seraphim)
      --self.globalCooldown = getSpellCD(61304)

      -- Global Cooldown = 1.5 / ((Spell Haste Percentage / 100) + 1)
      local gcd = (1.5 / ((UnitSpellHaste(player)/100)+1))
      if gcd < 1 then
        self.globalCooldown = 1
      else
        self.globalCooldown = gcd
      end

      self.inCombat = true
      -- Units
      self.melee5Yards = #getEnemies(player,5) -- (meleeEnemies)
      self.melee9Yards = #getEnemies(player,9) -- (Consecration)
      self.melee10Yards = #getEnemies(player,10) -- (Holy Wrath)
      self.melee15Yards = #getEnemies(player,15) -- Holy Prism on friendly AoE
      self.aroundTarget7Yards = #getEnemies(self.units.dyn5,7) -- (Hammer of the Righteous)
      -- Modes
      self.mode.aoe = BadBoy_data["AoE"]
      self.mode.cooldowns = BadBoy_data["Cooldowns"]
      self.mode.defensive = BadBoy_data["Defensive"]
      self.mode.healing = BadBoy_data["Healing"]
      self.mode.rotation = BadBoy_data["Rota"]
      self.mode.empS = BadBoy_data["EmpS"]
      -- Right = 1, Insight = 2
      self.seal = GetShapeshiftForm()
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
      self.combatLenght = GetTime() - BadBoy_data["Combat Started"]
      local cdCheckJudgment = select(2,GetSpellCooldown(self.spell.judgment))
      if cdCheckJudgment ~= nil and cdCheckJudgment > 2 then
        self.recharge.judgment = select(2,GetSpellCooldown(self.spell.judgment))
      else
        self.recharge.judgment = 4.5
      end
    end

    -- Bloodelf Racial
    function protCore:castArcaneTorrent()
      if canCast(self.spell.arcaneTorrent) then
        if castSpell("player",self.spell.arcaneTorrent,true,false) then
          return true
        end
      end
      return false
    end

    -- Ardent Defender
    function protCore:castArdentDefender()
      return isChecked("Ardent Defender") and self.health <= getValue("Ardent Defender") and castSpell(player,self.spell.ardentDefender,true,false)
    end

    -- Avenger's Shield
    function protCore:castAvengersShield()
      -- Todo: we need to check if AS will hit 3 targets, so what is the range of AS jump? We are usimg same logic as Hammer of Righ at the moment, 8 yard.
      -- Todo: We could add functionality that cycle all unit to find one that is casting since the Avenger Shield is silencing as well.
      return castSpell(self.units.dyn30,self.spell.avengersShield,false,false) == true or false
    end

    function protCore:castBuffs()
      -- Make sure that we are buffed
      -- Righteous Fury
      if self:castRighteousFury() then
        return true
      end
      -- Blessings Logic here party/raid check
      castBlessing()
      -- Food checks, flask, etc
    end

    -- Todo: populate list, link to profile, add option for it
    -- Cleanse
    function protCore:castCleanse()
      if isChecked("Cleanse") then
        for i = 1, #shouldCleanseDebuff do
          if UnitDebuffID("player",shouldCleanseDebuff[i].debuff) then
            return castSpell("player",cleanse,true,false) == true or false
          end
        end
      end
    end

    -- Consecration glyphed or not
    function protCore:castConsecration()
      if self.glyph.consecration then
        local thisUnit = self.units.dyn25AoE
        if UnitExists(thisUnit) and (isDummy(thisUnit) or not isMoving(thisUnit)) then
          if getGround(thisUnit) then
            return castGround(thisUnit,116467,30) == true or false
          end
        end
      else
        local consecrationDebuff = 81298
        if isInMelee(self.units.dyn5AoE) and getDebuffRemain(self.units.dyn5AoE,consecrationDebuff,"player") < 2 then
          return castSpell(player,self.spell.consecration,true,false) == true or false
        end
      end
    end

    -- Crusader Strike
    function protCore:castCrusaderStrike()
      return castSpell(self.units.dyn5,self.spell.crusaderStrike,false,false) == true or false
    end

    -- Divine Protection
    function protCore:castDivineProtection()
      return isChecked("Divine Protection") and self.health <= getValue("Divine Protection") and castSpell(player,self.spell.divineProtection,true,false)
    end

    -- Divine Shield
    function protCore:castDivineShield()
      if (isChecked("Divine Shield") and mode.defense == 2) or mode.defense == 3 then
        return self.health < getValue("Divine Shield") and castSpell(player,self.spell.divineShield,true,false) == true or false
      end
    end

    -- Execution sentence
    -- Todo: make sure we cast on a unit with as much HP as possible
    function protCore:castExecutionSentence()
      if isSelected("Execution Sentence") then
        if not self.talent.seraphim or not isSelected("Seraphim") or self.buff.seraphim > 5 then
          if (isDummy(self.units.dyn40) or (UnitHealth(self.units.dyn40) >= 400*UnitHealthMax("player")/100)) then
            return castSpell(self.units.dyn30,self.spell.executionSentence,false,false) == true or false
          end
        end
      end
      return false
    end

    -- Guardian Of Ancient Kings
    function protCore:castGuardianOfAncientKings()
      return isChecked("Guardian Of Ancient Kings") and self.health <= getValue("Guardian Of Ancient Kings") and castSpell(player,self.spell.guardianOfAncientKings,true,false)
    end

    -- Hammer of the Righteous
    -- Todo: Find best cluster of mobs to cast on
    function protCore:castHammerOfTheRighteous()
      return castSpell(self.units.dyn5,self.spell.hammerOfTheRighteous,false,false) == true or false
    end

    -- Hammer of Wrath
    function protCore:castHammerOfWrath()
      if canCast(self.spell.hammerOfWrath) then
        for i = 1,#enemiesTable do
          if enemiesTable[i].hp < 20 then
            return castSpell(enemiesTable[i].unit,self.spell.hammerOfWrath,false,false) == true or false
          end
        end
      end
    end


    function protCore:castHandOfFreedom()
      -- Todo: see against list of debuff we should remove.
      -- This is returning false since its not proper designed yet.
      return false
    end

    function protCore:castHandOfSacrifice()
      -- Todo: We should add glyph check or health check, at the moment we assume the glyph
      -- Todo:  We should be able to config who to use as candidate, other tank, healer, based on debuffs etc.
      -- Todo: add check if target already have sacrifice buff
      -- Todo Is the talent handle correctly? 2 charges? CD starts but u have 2 charges
      -- We need to have a list of scenarios when we should cast sacrifice, off tanking, dangerous debuffs/dots or high spike damage on someone.
      -- This is returning false since its not proper designed yet.
      return false
    end


    function protCore:castHandOfSalvation()
      -- Todo: find the lowest units, see if they have hight treath and salv them
      -- This is returning false since its not proper designed yet.
      return false
    end

    -- Holy Avenger
    function protCore:castHolyAvenger()
      if isSelected("Holy Avenger") then
        if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 400*UnitHealthMax(player)/100) then
          if self.talent.seraphim and self.buff.seraphim or (not self.talent.seraphim and self.holyPower <= 2) then
            return castSpell(player,self.spell.holyAvenger,true,false) == true or false
          end
        end
      end
    end

    -- Holy Prism
    -- Todo: find cluster of units to heal(single) or aoe around self
    -- Todo: Similiar to Lights Hammer, this can be improved, number of heals and enemies will give this a higher prio
    function protCore:castHolyPrism()
      if self.melee15Yards >= 2 then
        return castSpell(player,self.spell.holyPrism,true,false) == true or false
      else
        return castSpell(self.units.dyn30,self.spell.holyPrism,false,false) == true or false
      end
    end

    -- Holy Wrath
    -- Todo: better stun logic
    function protCore:castHolyWrath()
      return (getDistance(player,self.units.dyn8AoE) < 8 and castSpell(player,self.spell.holyWrath,true,false) == true) or false
    end

    -- Functionality regarding interrupting target(s) spellcasting
    -- ToDos: Add multiple interrupts such as binding light(if within 10 yards), Fist of Justice(stuns)
    -- Holy wrath on demons/undead
    function protCore:castInterrupts()
      -- we return as soon as we cast any interupt to avoid interupting more than once on same unit
      -- we return true only for gcd spells, returning true will stop rotation, without true will continue
      if #spellCastersTable > 1 then
        local numberofcastersinrangeofarcanetorrent = 0
        for i = 1, #spellCastersTable do
          if spellCastersTable[i].distance < 8 then
            numberofcastersinrangeofarcanetorrent = numberofcastersinrangeofarcanetorrent + 1
          end
        end
        if numberofcastersinrangeofarcanetorrent > 1 and self:castArcaneTorrent() then
          return
        end
      end
      if getOptionCheck("Avengers Shield Interrupt") then
        if castInterrupt(self.spell.avengersShield,getValue("Avengers Shield Interrupt")) then
          return true
        end
      end
      if getOptionCheck("Rebuke") then
        if castInterrupt(self.spell.rebuke,getValue("Rebuke")) then
          return
        end
      end
      if getOptionCheck("Arcane Torrent Interrupt") then
        if castInterrupt(self.spell.arcaneTorrent,getValue("Arcane Torrent Interrupt")) then
          return
        end
      end
    end

    -- Jeopardy 
    -- Uses Jeopardy if glyph is found, uses normal judgment if not
    function protCore:castJeopardy()
      -- Check if glyph is present
      if self.glyph.doubleJeopardy then 
        -- scan enemies for a different unit
        local enemiesTable = enemiesTable
        if #enemiesTable > 1 then
          for i = 1, #enemiesTable do
            local thisEnemy = enemiesTable[i]
            -- if its in range
            if thisEnemy.distance < 30 then
              -- here i will need to compare my previous judgment target with the previous one
              -- we declare a var in core updated by reader with last judged unit
              if self.previousJudgmentTarget ~= thisEnemy.guid then
                return castSpell(thisEnemy.unit,self.spell.judgment,true,false) == true or false
              end
            end
          end
        end
      else -- if no jeopardy glyph is found use normal judgment
        -- if no unit found for jeo, cast on actual target
        return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
      end
    end

    -- Judgment
    function protCore:castJudgment()
      return castSpell(self.units.dyn30AoE,self.spell.judgment,true,false) == true or false
    end

    -- Light's Hammer
    -- Todo: find best cluster of mobs/allies
    function protCore:castLightsHammer()
      -- Todo: Could use enhanced logic here, cluster of mobs, cluster of damaged friendlies etc
      if isSelected("Light's Hammer") then
        local thisUnit = self.units.dyn30AoE
        if UnitExists(thisUnit) and (isDummy(thisUnit) or not isMoving(thisUnit)) then
          if getGround(thisUnit) then
            return castGround(thisUnit,self.spell.lightsHammer,30) == true or false
          end
        end
      end
    end

    -- Righteous fury
    function protCore:castRighteousFury()
      if isChecked("Righteous Fury") then
        if not self.buff.righteousFury then
          return castSpell(player,self.spell.righteousFury,true,false) == true or false
        end
      end
      return false
    end

    -- Sacred shield
    function protCore:castSacredShield()
      return castSpell(player,self.spell.sacredShield,true,false) == true or false
    end

    -- Seals
    function protCore:castSeal(value)
      if value == 1 then
        return castSpell(player,self.spell.sealOfRighteousness,true,false) == true or false
      elseif value == 2 then
        return castSpell(player,self.spell.sealOfInsight,true,false) == true or false
      else
        return castSpell(player,self.spell.sealOfInsight,true,false) == true or false
      end
    end

    -- Selfless Healer
    -- Todo: We should find friendly candidate to cast on
    function protCore:castSelfLessHealer()
      if getBuffStacks(player,114250) == 3 then
        if self.health <= getValue("Selfless Healer") then
          return castSpell(player,self.spell.flashOfLight,true,false) == true or false
        end
      end
    end

    -- Seraphim
    -- Todo: need to handle holy power during holy avenger
    function protCore:castSeraphim()
      if isSelected("Seraphim") then
        if self.talent.seraphim and self.holyPower == 5 then
          --if isDummy(self.units.dyn5) or (UnitHealth(self.units.dyn5) >= 4*UnitHealthMax(player)) then
            return castSpell(player,self.spell.seraphim,true,false) == true or false
          --end
        end
      end
    end

    -- Shield of the Righteous
    -- Todo: We need to see what damage since SoR is physical only.
    -- Should add logic, ie abilities we need to cast SoR for, Piercong armor in Skyreach for example
    -- Todo: Add a event that read combatlog and populate incoming damage where we can track the last 10 damage
    -- to see if they are physical or magic in order to determine if we should use SoR
    function protCore:castShieldOfTheRighteous()
      return castSpell(self.units.dyn5,self.spell.shieldOfTheRighteous,false,false) == true or false
    end

    -- Word of glory
    -- Todo: add better logic for group support
    -- TODO: Calculate WoD heal, #ofHolyPower * 330% Spellpower * resolve * bastion of glory
    -- Only cast WoG if we are buffed with bastion of glory, base heal of 3 stacks is 11K(5% of hp)
    function protCore:castWordOfGlory(unit)
      if self.holyPower >= 3 or self.buff.divinePurpose then
        return castSpell(unit,self.spell.wordOfGlory,true,false) == true or false
      end
    end
    -- Handle the use of HolyPower
    function protCore:holyPowerConsumers()
      -- If we have bastion of Glory stacks >= 4
      if getBuffStacks("player",114637) >= 4 then
        if self.health < getValue("Word Of Glory On Self") then
          if self:castWordOfGlory(player) then
            return true
          end
        end
      end
      -- If we are not low health then we should use it on SoR
      if self:castShieldOfTheRighteous() then
        return true
      end
    end

    function protCore:checkForDebuffThatIShouldRemovewithHoF(unit)
      for i = 1, #snareToBeRemovedByHandsofFreedom do
        if UnitDebuffID(unit, snareToBeRemovedByHandsofFreedom[i]) then
          return true
        end
      end
      return false
    end

    -- This module will hold hands and
    -- Todo Blinding Light,Turn Evil,HoP,HoF,Redemption,Mass Resurrection,Reckoning
    function protCore:paladinUtility()
      -- We need to create options for these
      if getOptionCheck("Hand Of Freedom") then
        if self:checkForDebuffThatIShouldRemovewithHoF("player") then -- Only doing it for me at the moment, todo: add party/friendly units
          if self:castHandOfFreedom("player") then
            return true
        end
        end
      end
      -- Hand of Sacrifice
      if self:castHandOfSacrifice() then
        return true
      end
      -- Hand of Savlation
      if self:castHandOfSalvation() then
        return true
      end
    end

    -- Survival
    function protCore:survival() -- Check if we are close to dying and act accoridingly
      if enhancedLayOnHands() then
        return
      end
      if self.health < 40 then
        if useItem(5512) then -- Healthstone
          return true
        end
      end
      return false
    end

    -- Todo: not implemented, still need to think about it
    function protCore:paladinControl(unit)
      -- If no unit then we should check autotargetting
      -- If the unit is a player controlled then assume pvp and always CC
      -- Otherwise check towards config, always or whitelist.
      -- we have the following CCs HammerOFJustice, Fist of Justice, Repentance, Blinding Light, Turn Evil, Holy Wrath
      -- We should be able to configure, always stun, stun based on whitelist, stun if low health, stun if target is casting/buffed
      if getOptionCheck("Crowd Control") then
        if getValue("Crowd Control") == 1 then -- This is set to never but we should use the box tick for this so atm this is whitelist
        --Todo: Create whitelist of mobs we are going to stun always
        --Todo: Create whitelist of (de)buffs we are going to stun always or scenarios(more then x number of attackers
        elseif getValue("Crowd Control") == 2 then -- This is set to to CD

        elseif getValue("Crowd Control") == 3 then -- This is set to Always

        end
      end
      if unit then

      end
      -- put auto logic here
      return false
    end


  end
end

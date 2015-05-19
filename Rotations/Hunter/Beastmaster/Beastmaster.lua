if select(3, UnitClass("player")) == 3 then
  -- Rotation
  function  BeastHunter()
    if Currentconfig ~= "Beastmaster CodeMyLife" then
      BeastConfig()
      HunterBeastToggles()
      Currentconfig = "Beastmaster CodeMyLife"
    end

    local dynamicUnit = {
      dyn25 = dynamicTarget(25,true), -- wind shear
      dyn30 = dynamicTarget(35,true), -- purge
      dyn35AoE = dynamicTarget(35,false), -- earthquake
      dyn40 = dynamicTarget(40,true), -- flame shock
      dyn40AoE = dynamicTarget(40,false)
    }

    local player = {
      buff = {
        aspectCheetah = UnitBuffID("player",AspectOfTheCheetah) ~= nil,
        aspectPack = UnitBuffID("player",AspectOfThePack) ~= nil,
        bestialWrath = {
          duration = 15,
          remains = getBuffRemain("player",114050),
          up = UnitBuffID("player",114050)
        },
        misdirection = {
          remains = getBuffRemain("player",MisdirectionBuff),
          up = UnitBuffID("player",MisdirectionBuff) ~= nil
        },
        bloodLust = {
          up = hasBloodLust()
        },
        focusFire = {
          up = UnitBuffID("player",FocusFire) ~= nil
        },
        stampede = { 
          up = UnitBuffID("player",Stampede) ~= nil
        },
        steadyFocus = {
          remains = getBuffRemain("player",177668),
          up = UnitBuffID("player",177668) ~= nil
        },
        trapLauncher = TrapLauncher ~= nil,
        thrillOfTheHunt = {
          up = UnitBuffID("player",34720) ~= nil
        },
      },
      cooldowns = BadBoy_data["Cooldowns"],
      focus = getPower("player"),
      focusMax = UnitPowerMax("player"),
      focusDeficit = UnitPowerMax("player") - getPower("player"),
      focusRegen = getRegen("player"),
      focusTimeToMax = getTimeToMax("player"),
      gcd = 1,
      glyph = {
        pathfinding = hasGlyph(19560)
      },
      guidPlayer = UnitGUID("player"),
      guidFocus = UnitGUID("focus"),
      guidPet = UnitGUID("playerpet"),
      inCombat = UnitAffectingCombat("player") == true,
      interrupts = BadBoy_data["Interrupts"],
      hp = getHP("player"),
      moving = isMoving("player"),
      pet = {
        active = (not UnitIsDeadOrGhost("pet") and UnitExists("pet")),
        buff = {
          beastCleave = {
            remains = getBuffRemain("pet",118455),
            up = UnitBuffID("pet",118455) ~= nil
          },
          frenzy = {
            remains = getBuffRemain("pet",19615),
            stacks = getBuffStacks("pet",19615)
          },
          mendPet = UnitBuffID("pet",136) ~= nil
        },
        distanceToTarget = getDistance("pet","petTarget"),
        hp = getHP("pet")
      },
      spell = {
        bestialWrath = {
          cooldown = getSpellCD(BestialWrath),
          selected = isChecked("Bestial Wrath")
        },
        cobraShot = {
          castTime = select(4,GetSpellInfo(CobraShot))/1000
        },
        explosiveTrap = {
          selected = isChecked("Explosive Trap")
        },
        powerShot = {
          castTime = select(4,GetSpellInfo(PowerShot))/1000
        }
      },
      standing = isMovingStartTime == 0,
      talent = {
        aMurderOfCrows = isKnown(AMurderOfCrows),
        barrage = isKnown(Barrage),
        direBeast = isKnown(DireBeast),
        steadyFocus = isKnown(SteadyFocus),
        steadyFocus1st = BadBoy_data["1stFocus"]
      },
      target = {
        hp = getHP(dynamicUnit.dyn40),
        timeToDie = getTimeToDie(dynamicUnit.dyn40),
        enemiesIn10 = #getEnemies(dynamicUnit.dyn40,10)
      },
      time = BadBoy_data["Combat Started"] - GetTime(),
    }

    -- reset summon pet wait time
    if IsMounted("player") then
      waitForPetToAppear = nil
    end

    -- Food/Invis Check
    if not canRun() then
      return
    end
    -- off/gcd spells
    if player.inCombat then
      -- Counter Shot
      if player.interrupts == 2 and isChecked("Counter Shot") then
        castInterrupt(CounterShot,getValue("Counter Shot"))
      end
    end
    -- Aspect of the Cheetah/pack
    if isChecked("Auto-Aspect") then
      -- aspect select
      local aspectBuff = "aspectCheetah"
      local aspect = AspectOfTheCheetah
      if getValue("Aspect") == 2 then
        aspectBuff = "aspectPack"
        aspect = AspectOfThePack
      end
      -- normal checks
      if (not player.buff[aspectBuff] and isMovingStartTime and isMovingStartTime - GetTime() < -getValue("Auto-Aspect")
        and isMovingStartTime ~= 0 and not player.inCombat)
        or (player.buff[aspectBuff] and player.inCombat) then
        if castSpell("player",aspect,true,false) then
          return
        end
      end
    end
    -- cast/channel check
    if castingUnit() then
      return
    end
    -- Pet Management
    if isChecked("Auto Call Pet") and not player.pet.active then
      -- if BadBoy_data["Pet Dead"] is true, we want to revive it, otherwise, whistle select stable
      if BadBoy_data["Pet Dead"] == true then
        if castSpell("player",RevivePet,true,true) then
          return
        end
      else
        if castSpell("player",_G["CallPet"..getValue("Auto Call Pet")],true,false) then
          return
        end
      end

    end
    -- Mend Pet
    if isChecked("Mend Pet") and player.pet.hp <= getValue("Mend Pet") and not player.pet.buff.mendPet then
      if castSpell("pet",MendPet,true,false) then
        return
      end
    end
    if player.inCombat then
      -- Misdirection
      if isChecked("Misdirection") then
        local misdirectUnit = "pet"
        local focusTarget = UnitGUID("pettargettarget") or "No Target"
        if UnitExists("focus") then
          misdirectUnit = "focus"
          focusTarget = UnitGUID("focustargettarget") or "No Target"
        end
        local misdirectOption = getValue("Misdirection")
        local shouldMisdirect = false
        local focusSituation = UnitThreatSituation(misdirectUnit)
        -- 1 - Me.Aggro if facing me and aggro on me then misdirect
        if misdirectOption == 1 and focusTarget == player.guidPlayer then
          shouldMisdirect = true
          -- 2 - Any.Aggro - threat < 2 then misdirect
        elseif misdirectOption == 2 and focusTarget ~= "No Target" and focusTarget ~= UnitGUID(misdirectUnit) then
          shouldMisdirect = true
          -- 3 - Enforce - threat < 3 then misdirect
        elseif misdirectOption == 3 and focusTarget ~= "No Target" and focusSituation ~= 3 then
          shouldMisdirect = true
          -- 4 - Always - misdirect
        elseif misdirectOption == 4 then
          shouldMisdirect = true
        end
        if shouldMisdirect and not player.buff.misdirection.up then
          if castSpell("pet",34477,true,false) then
            return
          end
        end
      end
      -- Deterrence
      if isChecked("Deterrence") and player.hp <= getValue("Deterrence") then
        if castSpell("player",Deterrence,true,false) then
          return
        end
      end
      -- Feign Death
      if isChecked("Feign Death") and player.hp <= getValue("Feign Death") then
        if castSpell("player",FeignDeath,true,false) then
          return
        end
      end
      -- Intimidation
      if isChecked("Intimidation") then
        castCrowdControl("any",Intimidation,40)
      end
      -- stampede,if=buff.bloodlust.up|buff.focus_fire.up|target.time_to_die<=25
      if isSelected("Stampede") and (player.buff.bloodLust.up or player.buff.focusFire.up or player.target.timeToDie <= 25) then
        if castSpell(dynamicUnit.dyn40,Stampede,true,false) then
          -- start timer for stampede uptime calc
          return
        end
      end
      -- dire_beast
      if player.talent.direBeast then
        if castSpell(dynamicUnit.dyn40,DireBeast,false,false) then
          return
        end
      end
      -- actions+=/focus_fire,if=buff.focus_fire.down&((cooldown.bestial_wrath.remains<1&buff.bestial_wrath.down)|(talent.stampede.enabled&buff.stampede.remains)|pet.cat.buff.frenzy.remains<1)
      -- TODO: add stampede timer and condition
      if isSelected("Focus Fire") and player.pet.buff.frenzy.stacks == 5 and not player.buff.focusFire.up 
        and ((player.spell.bestialWrath.cooldown < 1 and not player.buff.bestialWrath.up) or player.pet.buff.frenzy.remains < 1) then
        if castSpell("player",FocusFire,true,false) then
          return
        end
      end
      -- bestial_wrath,if=focus>30&!buff.bestial_wrath.up
      if isSelected("Bestial Wrath") and player.focus > 30 and not player.buff.bestialWrath.up and player.pet.distanceToTarget <= 25 then
        if castSpell("player",BestialWrath,true,false) then
          return
        end
      end
      -- actions+=/multishot,if=active_enemies>1&pet.cat.buff.beast_cleave.remains<0.5
      if player.target.enemiesIn10 > 1 and player.pet.buff.beastCleave.remains < 0.5 then
        if castSpell(dynamicUnit.dyn40,MultiShot,false,false) then
          return
        end
      end
      -- actions+=/focus_fire,five_stacks=1,if=buff.focus_fire.down
      if isSelected("Focus Fire") and player.pet.buff.frenzy.stacks == 5 and not player.buff.focusFire.up then
        if castSpell("player",FocusFire,true,false) then
          return
        end
      end
      -- barrage,if=active_enemies>1
      if player.talent.barrage and player.target.enemiesIn10 > 1 then
        if castSpell(dynamicUnit.dyn40,Barrage,false,false) then
          return
        end
      end
      -- actions+=/explosive_trap,if=active_enemies>5
      if player.spell.explosiveTrap.selected then
        if not player.buff.trapLauncher then
          castSpell("player",TrapLauncher,true,false)
        end
        -- match the selectors
        local explosiveValue = getValue("Explosive Trap")
        if (explosiveValue == 2 and player.target.enemiesIn10 > 5) or explosiveValue == 3 then
          -- check if its a dummy or mobs have enough hp to be worth it
          if (isDummy(dynamicUnit.dyn40) or player.target.hp*player.target.enemiesIn10 >= 400*UnitHealthMax("player")/100) then
            if castGround(dynamicUnit.dyn40,TrapLauncherExplosive,40) then
              return
            end
          end
        end
      end
      -- actions+=/multishot,if=active_enemies>5
      if player.target.enemiesIn10 > 5 then
        if castSpell(dynamicUnit.dyn40,MultiShot,false,false) then
          return
        end
      end
      -- actions+=/kill_command
      if UnitExists("pet") and player.pet.distanceToTarget <= 25 and getLineOfSight("pet","target") then
        if castSpell(dynamicUnit.dyn40,KillCommand,false) then
          return
        end
      end
      -- actions+=/a_murder_of_crows
      if player.talent.aMurderOfCrows then
        if castSpell(dynamicUnit.dyn40,AMurderOfCrows,true,false) then
          return
        end
      end
      -- kill_shot,if=focus.time_to_max>gcd
      if player.focusTimeToMax > player.gcd then
        if castSpell(dynamicUnit.dyn40,KillShot,false,false) then
          return
        end
      end
      -- focusing_shot,if=focus<50
      if player.focus < 50 and player.standing then
        if castSpell(dynamicUnit.dyn40,FocusingShot,false,true) then
          return
        end
      end
      -- cobra_shot,if=buff.pre_steady_focus.up&(14+cast_regen)<=focus.deficit
      if player.talent.steadyFocus and player.talent.steadyFocus1st and (14+(player.spell.cobraShot.castTime*player.focusRegen)) <= player.focusDeficit then
        if castSpell(dynamicUnit.dyn40,CobraShot,false,false) then
          return
        end
      end
      -- actions+=/explosive_trap,if=active_enemies>1
      if player.spell.explosiveTrap.selected then
        if not player.buff.trapLauncher then
          castSpell("player",TrapLauncher,true,false)
        end
        -- match the selectors
        local explosiveValue = getValue("Explosive Trap")
        if (explosiveValue == 2 and player.target.enemiesIn10 > 1) or explosiveValue == 3 then
          -- check if its a dummy or mobs have enough hp to be worth it
          if (isDummy(dynamicUnit.dyn40) or player.target.hp*player.target.enemiesIn10 >= 400*UnitHealthMax("player")/100) then
            if castGround(dynamicUnit.dyn40,TrapLauncherExplosive,40) then
              return
            end
          end
        end
      end
      -- actions+=/cobra_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<4&focus<50
      if player.talent.steadyFocus and player.buff.steadyFocus.remains < 4 and player.focus < 50 then
        if castSpell(dynamicUnit.dyn40,CobraShot,false,false) then
          return
        end
      end
      -- glaive_toss
      if castSpell(dynamicUnit.dyn40,GlaiveToss,false) then
        return
      end
      -- barrage
      if castSpell(dynamicUnit.dyn40,Barrage,false) then
        return
      end
      -- powershot,if=focus.time_to_max>cast_time
      if player.focusTimeToMax > player.spell.powerShot.castTime then
        if castSpell(dynamicUnit.dyn40,PowerShot,false) then
          return
        end
      end
      -- cobra_shot,if=active_enemies>5
      if player.target.enemiesIn10 > 5 then
        if castSpell(dynamicUnit.dyn40,CobraShot,false,false) then
          return
        end
      end
      -- arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|buff.bestial_wrath.up
      if (player.focus > 35 and player.buff.thrillOfTheHunt.up) or player.buff.bestialWrath.up  then
        if castSpell(dynamicUnit.dyn40,ArcaneShot,false,false) then
          return
        end
      end
      -- actions+=/arcane_shot,if=focus>=75
      if player.focus >= 75 then
        if castSpell(dynamicUnit.dyn40,ArcaneShot,false,false) then
          return
        end
      end
      -- cobra_shot
      if castSpell(dynamicUnit.dyn40,CobraShot,false,false) then
        return
      end
    end
  end
end

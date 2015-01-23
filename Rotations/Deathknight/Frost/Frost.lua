if select(3, UnitClass("player")) == 6 then
  function FrostDK()
    if GetSpecialization() == 2 then
      if currentConfig ~= "Frost DK CuteOne" then
        FrostOptions();
        KeyToggles();
        currentConfig = "Frost DK CuteOne";
      end
      GroupInfo()
      getRuneInfo()
  --------------
  --- Locals ---
  --------------
      if leftCombat == nil then leftCombat = GetTime() end
      -- General Player Variables
      local profileStop = profileStop
      local lootDelay = getValue("LootDelay")
      local level = UnitLevel("player")
      local php = getHP("player")
      local power, powmax, powgen = getPower("player"), UnitPowerMax("player"), getRegen("player")
      local ttm = getTimeToMax("player")
      local enemies, enemiesList = #getEnemies("player",8), getEnemies("player",8)
      local falling, swimming = getFallTime(), IsSwimming()
      local oneHand, twoHand = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
      --General Target Variables
      local tarUnit = {
        ["dyn0"] = "target", --No Dynamic
        ["dyn5"] = dynamicTarget(5,true), --Melee
        ["dyn10AoE"] = dynamicTarget(10,false), --Defensive Abilites
        ["dyn30"] = dynamicTarget(30,true), --Death Grip
        ["dyn30AoE"] = dynamicTarget(30,false), --Control Undead
        ["dyn40"] = dynamicTarget(40,true),
      }
      local tarDist = {
        ["dyn0"] = getDistance("player",tarUnit.dyn0),
        ["dyn5"] = getDistance("player",tarUnit.dyn5),
        ["dyn10AoE"] = getDistance("player",tarUnit.dyn10AoE),
        ["dyn30"] = getDistance("player",tarUnit.dyn30),
        ["dyn30AoE"] = getDistance("player",tarUnit.dyn30AoE),
      }
      local hasMouse, deadMouse, playerMouse, mouseDist = ObjectExists("mouseover"), UnitIsDeadOrGhost("mouseover"), UnitIsPlayer("mouseover"), getDistance("player","mouseover") 
      local hastar, deadtar, attacktar, playertar = ObjectExists(tarUnit.dyn0), UnitIsDeadOrGhost(tarUnit.dyn0), UnitCanAttack(tarUnit.dyn0, "player"), UnitIsPlayer(tarUnit.dyn0)
      local friendly = UnitIsFriend(tarUnit.dyn0, "player")
      local thp = getHP(tarUnit.dyn5)
      local ttd = getTimeToDie(tarUnit.dyn5)
      -- Specific Player Variables
      local bloodpres = getBuffRemain("player",_BloodPresence)~=0
      local frostpres = getBuffRemain("player",_FrostPresence)~=0
      local unholypres = getBuffRemain("player",_UnholyPresence)~=0
      local dRunes, bRunes, fRunes, uRunes = getRunes("death"), getRunes("blood") + getRunes("death"), getRunes("frost") + getRunes("death"), getRunes("unholy") + getRunes("death")
      local bPercent, fPercent, uPercent = getRunePercent("blood") + getRunes("death"), getRunePercent("frost") + getRunes("death"), getRunePercent("unholy") + getRunes("death")
      local bcStack = getBuffStacks("player",_BloodCharge,"player")
      local rRemain = getBuffRemain("player",_Rime)
      local kmRemain = getBuffRemain("player",_KillingMachine)
      local howRemain = getBuffRemain("player",_HornOfWinter)
      local empRemain = getBuffRemain("player",_EmpowerRuneWeapon)
      local dsRemain = getBuffRemain("player",_DarkSuccor)
      local pofRemain, pofCooldown = getBuffRemain("player",_PillarOfFrost), GetSpellCooldown(_PillarOfFrost)
      local amsRemain, amsCooldown = getBuffRemain("player",_AntiMagicShell), GetSpellCooldown(_AntiMagicShell)
      local bosRemain, bosCooldown = getBuffRemain("player",_BreathOfSindragosa), GetSpellCooldown(_BreathOfSindragosa)
      local strPotRemain = getBuffRemain("player",156428)
      local srCooldown = GetSpellCooldown(_SoulReaper)
      local plCooldown = GetSpellCooldown(_PlagueLeech)
      local ubCooldown = GetSpellCooldown(_UnholyBlight)
      local dCooldown = GetSpellCooldown(_Defile)
      local dndCooldown = GetSpellCooldown(_DeathAndDecay)
      local raCooldown = GetSpellCooldown(_RaiseAlly)
      local oCooldown = getSpellCD(_Obliterate)
      local blight, bloodtap, runic, necrotic, defile, sindragosa = getTalent(1,3), getTalent(4,1), getTalent(4,2), getTalent(7,1), getTalent(7,2), getTalent(7,3)
      local t17x2 = false
      local simSpell, castingSimSpell = bb.im.simulacrumSpell, isSimSpell()
      --Specific Target Variables
      local ciRemain = {
        ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_ChainsOfIce,"player"),
        ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_ChainsOfIce,"player"),
        ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_ChainsOfIce,"player"),
        ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_ChainsOfIce,"player"),
        ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_ChainsOfIce,"player"),
      }
      local ffRemain = {
        ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_FrostFever,"player"),
        ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_FrostFever,"player"),
        ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_FrostFever,"player"),
        ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_FrostFever,"player"),
        ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_FrostFever,"player"),
      }
      local bpRemain = {
        ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_BloodPlague,"player"),
        ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_BloodPlague,"player"),
        ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_BloodPlague,"player"),
        ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_BloodPlague,"player"),
        ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_BloodPlague,"player"),
      }
      local necRemain = {
        ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_NecroticPlague,"player"),
        ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_NecroticPlague,"player"),
        ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_NecroticPlague,"player"),
        ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_NecroticPlague,"player"),
        ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_NecroticPlague,"player"),
      }
      local hasDisease = {
        ["dyn0"] = ((ffRemain.dyn0>0 and bpRemain.dyn0>0) or necRemain.dyn0>0),
        ["dyn5"] = ((ffRemain.dyn5>0 and bpRemain.dyn5>0) or necRemain.dyn5>0),
        ["dyn10AoE"] = ((ffRemain.dyn10AoE>0 and bpRemain.dyn10AoE>0) or necRemain.dyn10AoE>0),
        ["dyn30"] = ((ffRemain.dyn30>0 and bpRemain.dyn30>0) or necRemain.dyn30>0),
        ["dyn30AoE"] = ((ffRemain.dyn30AoE>0 and bpRemain.dyn30AoE>0) or necRemain.dyn30AoE>0),
      }
      --ChatOverlay(tostring(select(1,GetSpellInfo(simSpell))))
  --------------------------------------------------
  --- Ressurection/Dispelling/Healing/Pause/Misc ---
  --------------------------------------------------
    -- Profile Stop
      if isInCombat("player") and profileStop==true then
        return true
      else
        profileStop=false
      end
    -- Raise Ally
      if isInCombat("player") and raCooldown==0 and power>30 then
        if isChecked("Mouseover Targeting") and hasMouse and deadMouse and playerMouse and mouseDist<40 then
          if castSpell("mouseover",_RaiseAlly,true,true,false,false,true) then return end
        elseif hastar and deadtar and playertar and tarDist.dyn0<40 then
          if castSpell(tarUnit.dyn0,_RaiseAlly,true,false,false,false,true) then return end
        end
      end
    -- Pause
      if pause() then
        return true
      elseif not pause() then
  -------------
  --- Buffs ---
  -------------
      -- Horn of Winter
        if isChecked("Horn of Winter") and not hasmouse and not (IsFlying() or IsMounted()) and not isInCombat("player") then
            for i = 1, #members do
                if not isBuffed(members[i].Unit,{57330,19506,6673})
                  and (#nNova==select(5,GetInstanceInfo())
                    or select(2,IsInInstance())=="none"
                    or (select(2,IsInInstance())=="party" and not UnitInParty("player")))
                then
                    if castSpell("player",_HornOfWinter,true,false,false) then return end
                end
            end
        end
      -- Frost Presence
        if not frostpres and php > getOptionValue("Blood Presence") and (tarDist.dyn0<=20 and attacktar and not deadtar) then
          if castSpell("player",_FrostPresence,true,false,false) then return end
        end
      -- Unholy Presence
        if not unholypres and ((not isInCombat("player") and IsMovingTime(2) and ((hastar and tarDist.dyn0>20 or not hastar))) or (hastar and tarDist.dyn0>20 and power<40)) then
          if castSpell("player",_UnholyPresence,true,false,false) then return end
        end
      -- Path of Frost
        if not isInCombat("player") and IsSwimming() and not UnitBuffID("player",_PathOfFrost) then
          if castSpell("player",_PathOfFrost,true,false,false) then return end
        end
      -- Control Undead
        -- if UnitCreatureType(tarUnit.dyn30AoE)=="Undead" and uRunes>0 and not ObjectExists("pet")
        --   and (UnitClassification(tarUnit.dyn30AoE)~="normal" or UnitClassification(tarUnit.dyn30AoE)~="trivial" or UnitClassification(tarUnit.dyn30AoE)~="minus")
        -- then
        --   if castSpell(tarUnit.dyn30AoE,_ControlUndead,false,false,false) then return end
        -- end
      -- Flask / Crystal
        if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
            if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none")
              and not (UnitBuffID("player",109156) or UnitBuffID("player",109148)) --Draenor Str Flasks
            then
                if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
                    UseItemByName(tostring(select(1,GetItemInfo(118922))))
                end
            end
        end
  ------------------
  --- Defensives ---
  ------------------
        if useDefensive() and tarDist.dyn10AoE<10 then
          -- Blood Presence
          if isChecked("Blood Presence") and php <= getOptionValue("Blood Presence") and not bloodpres then
            if castSpell("player",_BloodPresence,true,false,false) then return end
          end
          -- Death Strike
          if isChecked("Death Strike") and php<=getOptionValue("Death Strike") and kmRemain==0 and dsRemain>0 and tarDist.dyn5<5 then
            if castSpell(tarUnit.dyn5,_DeathStrike,false,false,false) then return end
          end
          -- Icebound Fortitude
          if isChecked("Icebound Fortitude") and php <= getOptionValue("Icebound Fortitude") and isInCombat("player") then
            if castSpell("player",_IceboundFortitude,true,false,false) then return end
          end
          -- Anti-Magic Shell/Zone
          if getTalent(2,2) then
            if isChecked("Anti-Magic Zone") and php <= getOptionValue("Anti-Magic Zone") and isInCombat("player") then
              if castGround("player",_AntiMagicZone,5) then return end
            end
          else
            if isChecked("Anti-Magic Shell") and php <= getOptionValue("Anti-Magic Shell") and isInCombat("player") then
              if castGround("player",_AntiMagicShell,5) then return end
            end
          end
          -- Lichborne
          if isChecked("Lichborne") and hasNoControl(_Lichborne) then
            if castSpell("player",_Lichborne,true,false,false) then return end
          end
          -- Death Pact
          if isChecked("Death Pact") and php <= getOptionValue("Death Pact") and isInCombat("player") then
            if castSpell("player",_DeathPact,true,false,false) then return end
          end
          -- Death Siphon
          if isChecked("Death Siphon") and php <= getOptionValue("Death Siphon") and dRunes>=1 and isInCombat("player") then
            if castSpell(tarUnit.dyn5,_DeathSiphon,false,false,false) then return end
          end
          -- Conversion
          if isChecked("Conversion") and php <= getOptionValue("Conversion") and power>=50 and isInCombat("player") then
            if castSpell("player",_Conversion,true,false,false) then return end
          end
          -- Remorseless Winter
          if isChecked("Remorseless Winter") and (useAoE() or php <= getOptionValue("Remorseless Winter")) and isInCombat("player") then
            if castSpell("player",_RemorselessWinter,true,false,false) then return end
          end
          -- Desecrated Ground
          if isChecked("Desecrated Ground") and hasNoControl(_DesecratedGround) then
            if castSpell("player",_DesecratedGround,true,false,false) then return end
          end
        end
  ---------------------
  --- Out of Combat ---
  ---------------------
        if hastar and attacktar and not isInCombat("player")
          and ((not (IsMounted() or IsFlying() or friendly)) or isDummy())
        then
      -- Death Grip
          if tarDist.dyn0<30 and tarDist.dyn0>8 and ((select(2,IsInInstance())=="none" and #members==1) or hasThreat(tarUnit.dyn0)) then
            if castSpell(tarUnit.dyn0,_DeathGrip,false,false,false) then return end
          end
      -- Frost Strike
          if power>76 and tarDist.dyn0<5 then
            if castSpell(tarUnit.dyn0,_FrostStrike,false,false,false) then return end
          end
      -- Outbreak
          if ffRemain.dyn0==0 and bpRemain.dyn0==0 and tarDist.dyn0<30 and select(2,IsInInstance())=="none" and #members==1 then
            if castSpell(tarUnit.dyn0,_Outbreak,false,false,false) then return end
          end
      -- Unholy Blight
          if ffRemain.dyn0==0 and bpRemain.dyn0==0 and tarDist.dyn0<10 and select(2,IsInInstance())=="none" and #members==1 then
            if castSpell(tarUnit.dyn0,_UnholyBlight,false,false,false) then return end
          end
      -- Howling Blast
          if ffRemain.dyn0==0 and fRunes>=1 and tarDist.dyn0<30 and select(2,IsInInstance())=="none" and #members==1 then
            if getNumEnemies(tarUnit.dyn0,10)==1 and useCleave() then
              if castSpell(tarUnit.dyn0,_HowlingBlast,false,false,false) then return end
            else
              if castSpell(tarUnit.dyn0,_IcyTouch,false,false,false) then return end
            end
          end
      -- Plague Strike
          if bpRemain.dyn0==0 and bRunes>=1 and tarDist.dyn0<5 then
            if castSpell(tarUnit.dyn0,_PlagueStrike,false,false,false) then return end
          end
      -- Start Attack
          if tarDist.dyn0<5 then
            StartAttack()
          end
        end
  -----------------
  --- In Combat ---
  -----------------
        if isInCombat("player") then
    ------------------------------
    --- In Combat - Dummy Test ---
    ------------------------------
      -- Dummy Test
          if isChecked("DPS Testing") then
            if ObjectExists(tarUnit.dyn0) then
              if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                profileStop = true
                StopAttack()
                ClearTarget()
                print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                return true
              end
            end
          end
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
          if useInterrupts() then
        -- Mind Freeze
            if isChecked("Mind Freeze") and not castingSimSpell then
              if castInterrupt(_MindFreeze,getOptionValue("Interrupt At")) then return end
            end
        -- Strangulate
            if isChecked("Strangulate") and bRunes>0 and not castingSimSpell then
              if castInterrupt(_Strangulate,getOptionValue("Interrupt At")) then return end
            end
        -- Asphyxiate
            if isChecked("Asphyxiate") and not castingSimSpell then
              if castInterrupt(_Asphyxiate,getOptionValue("Interrupt At")) then return end
            end
        -- Dark Simulacrum
            if isChecked("Dark Simulacrum") and power>20 and (isInPvP() or castingSimSpell) then
              if castInterrupt(_DarkSimulacrum,10,true) then return end
            end
            if simSpell~=_DarkSimulacrum and getBuffRemain("player",_DarkSimulacrum)>0 and getCastTimeRemain(simUnit)<8 then
              if castSpell(simUnit,simSpell,false,false,true,true,false,true,false) then bb.im.simulacrum = nil return end
              --CastSpellByName(GetSpellInfo(simSpell),tarUnit.dyn40)
            end
            if simSpell~=nil and getBuffRemain("player",_DarkSimulacrum)==0 then
              bb.im.simulacrum = nil
            end
          end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
          if useCDs() and tarDist.dyn5<5 then
        -- Potion
            if canUse(109219) and (ttd<=30 or (ttd<=60 and pofRemain>0)) and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
              UseItemByName(tostring(select(1,GetItemInfo(109219))))
            end
        -- Empower Rune Weapon
            if isChecked("Empower Rune Weapon") and ttd<=60 and getRunes("Frost")==0 and getRunes("Unholy")==0 and strPotRemain>0 then
              if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
            end
        -- Trinkets
            if canTrinket(13) and useCDs() then
              RunMacroText("/use 13")
              if IsAoEPending() then
                local X,Y,Z = ObjectPosition(Unit)
                CastAtPosition(X,Y,Z)
              end
            end
            if canTrinket(14) and useCDs() then
              RunMacroText("/use 14")
              if IsAoEPending() then
                local X,Y,Z = ObjectPosition(Unit)
                CastAtPosition(X,Y,Z)
              end
            end
          end
    --------------------------
    --- In Combat Rotation ---
    --------------------------
        -- Start Attack
          if tarDist.dyn5<5 then
            StartAttack()
          end
        -- Death Grip
          if tarDist.dyn30<30 and tarDist.dyn30>8 and (select(2,IsInInstance())=="none" or hasThreat(tarUnit.dyn30)) then
            if castSpell(tarUnit.dyn30,_DeathGrip,false,false,false) then return end
          end
        -- Chains of Ice
          if not getFacing(tarUnit.dyn30AoE,"player") and getFacing("player",tarUnit.dyn30AoE)
            and isMoving(tarUnit.dyn30AoE) and tarDist.dyn30AoE>8 and fRunes>=1 and isInCombat(tarUnit.dyn30) and ciRemain.dyn30AoE==0
          then
            if castSpell(tarUnit.dyn30AoE,_ChainsOfIce,false,false,false) then return end
          end
        -- Death's Advance
          if isMoving("player") and hastar and not deadtar and tarDist.dyn0>=15 then
            if castSpell("player",_DeathsAdvance,true,false,false) then return end
          end
        -- Pillar of Frost
          if fRunes>=1 and tarDist.dyn5<5 then
            if castSpell("player",_PillarOfFrost,true,false,false) then return end
          end
        --------------------
        --- Single Target --
        --------------------
          if not useAoE() then
        -- Blood Tap (1H)
            --if=buff.blood_charge.stack>10&(runic_power>76|(runic_power>=20&buff.killing_machine.react))
            if oneHand and bcStack>10 and (power>76 or (power>=20 and kmRemain>0)) then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Plague Leech (2H)
            --if=disease.min_remains<1
            if twoHand and hasDisease.dyn30AoE and getDisease(30,true,"min")<1 and tarDist.dyn30AoE<30 then
              if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then return end
            end
        -- Soul Reaper
            --if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
            if thp-3*(thp/ttd)<=35 and fRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_SoulReaper,false,false,false) then return end
            end
        -- Blood Tap
            --if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
            if (thp-3*(thp/ttd)<=35 and srCooldown==0) and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Defile (2H)
            if twoHand and defile and uRunes>=1 and useCleave() and dCooldown==0 and not isMoving(tarUnit.dyn30AoE) and tarDist.dyn30AoE<30 then
              if castGround(tarUnit.dyn30AoE,_Defile,30) then return end
            end
        -- Blood Tap (2H)
            --if=talent.defile.enabled&cooldown.defile.remains=0
            if twoHand and defile and dCooldown==0 and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Howling Blast (2H)
            --if=buff.rime.react&disease.min_remains>5&buff.killing_machine.react
            if twoHand and rRemain>0 and getDisease(30,false,"min")>5 and kmRemain>0 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Obliterate (2H)
            --if=buff.killing_machine.react
            if twoHand and kmRemain>0 and fRunes>=1 and uRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_Obliterate,false,false,false) then return end
            end
        -- Blood Tap (2H)
            --if=buff.killing_machine.react
            if twoHand and kmRemain>0 and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Howling Blast (2H)
            --if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking&buff.rime.react
            if twoHand and not necrotic and ffRemain.dyn30==0 and rRemain>0 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Outbreak (2H)
            --!disease.max_ticking
            if twoHand and getDisease(30,true,"max")==0 and tarDist.dyn30AoE<30 then
              if castSpell(tarUnit.dyn30AoE,_Outbreak,false,false,false) then return end
            end
        -- Unholy Blight (2H)
            --if=!disease.min_ticking
            if getDisease(10,true,"min")==0 and useCleave() and tarDist.dyn10AoE<10 then
              if castSpell(tarUnit.dyn10AoE,_UnholyBlight,false,false,false) then return end
            end
        -- Breath of Sindragosa
            --if=runic_power>75
            if power>75 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_BreathOfSindragosa,false,false,false) then return end
            end
            --------------------------
            --- Boss Single Target ---
            --------------------------
            if isBoss() and bosRemain>0 then
            -- Obliterate
              --if=buff.killing_machine.react
              if kmRemain>0 and uRunes>=1 and fRunes>=1 and tarDist.dyn5<5 then
                if castSpell(tarUnit.dyn5,_Obliterate,false,false,false) then return end
              end
            -- Blood Tap
              --if=buff.killing_machine.react&buff.blood_charge.stack>=5
              if kmRemain>0 and bcStack>=5 and tarDist.dyn5<5 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
            -- Plague Leech
              --if=buff.killing_machine.react
              if kmRemain>0 and ffRemain.dyn30>0 and bpRemain.dyn30>0 and tarDist.dyn30<30 then
                if castSpell(tarUnit.dyn30,_PlagueLeech,true,false,false) then return end
              end
            -- Howling Blast (1H)
              --if=runic_power<88
              if oneHand and power<88 and fRunes>0 and tarDist.dyn30<30 then
                if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                  if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
                else
                  if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
                end
              end
            -- Blood Tap (2H)
              --if=buff.blood_charge.stack>=5
              if twoHand and bcStack>=5 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
            -- Plague Leech (2H)
              if twoHand and ffRemain.dyn30>0 and bpRemain.dyn30>0 and tarDist.dyn30<30 then
                if castSpell(tarUnit.dyn30,_PlagueLeech,true,false,false) then return end
              end
            -- Obliterate
              --if=unholy>0&runic_power<76
              if power<76 and uRunes>=1 and fRunes>=1 and tarDist.dyn5<5 then
                if castSpell(tarUnit.dyn5,_Obliterate,false,false,false) then return end
              end
            -- Howling Blast (2H)
              --if=((death=1&frost=0&unholy=0)|death=0&frost=1&unholy=0)&runic_power<88
              if twoHand and fRunes==1 and uRunes==0 and power<88 and tarDist.dyn30<30 then
                if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                  if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
                else
                  if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
                end
              end
            -- Blood Tap (1H)
              --if=buff.blood_charge.stack>=5
              if oneHand and bcStack>=5 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
            -- Plague Leech (1H)
              if oneHand and ffRemain.dyn30>0 and bpRemain.dyn30>0 and tarDist.dyn30<30 then
                if castSpell(tarUnit.dyn30,_PlagueLeech,true,false,false) then return end
              end
            -- Empower Rune Weapon (1H)
              if isChecked("Empower Rune Weapon") and getRunes("Frost")==0 and getRunes("Unholy")==0 then
                if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
              end
            end --End Boss Special
        -- Defile (1H)
            if oneHand and defile and uRunes>=1 and dCooldown==0 and not isMoving(tarUnit.dyn30AoE) and tarDist.dyn30AoE<30 then
              if castGround(tarUnit.dyn30AoE,_Defile,30) then return end
            end
        -- Blood Tap (1H)
            --if=talent.defile.enabled&cooldown.defile.remains=0
            if oneHand and defile and dCooldown==0 and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Howling Blast (1H)
            --if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<88
            if oneHand and sindragosa and bosCooldown<7 and power<88 and fRunes>=1 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Obliterate (1H/2H)
            --One - if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<76
            --Two - if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<76
            if sindragosa and ((oneHand and bosCooldown<3) or (twoHand and bosCooldown<7)) and power<76 and uRunes>=1 and fRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_Obliterate,false,false,false) then return end
            end
        -- Howling Blast (2H)
            --if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<88
            if twoHand and sindragosa and bosCooldown<3 and power<88 and fRunes>=1 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Frost Strike (1H)
            --buff.killing_machine.react|runic_power>88
            if oneHand and (kmRemain>0 or power>88) and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,false,false,false) then return end
            end
        -- Frost Strike (1H)
            --if=cooldown.antimagic_shell.remains<1&runic_power>=50&!buff.antimagic_shell.up
            if oneHand and amsCooldown<1 and power>=50 and amsRemain==0 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,false,false,false) then return end
            end
        -- Howling Blast (1H)
            --if=death>1|frost>1
            if oneHand and fRunes>1 and tarDist.dyn30<30 then
               if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Unholy Blight (1H)
            --if=!disease.ticking
            if oneHand and not hasDisease.dyn10AoE and tarDist.dyn10AoE<10 then
              if castSpell("player",_UnholyBlight,true,false,false) then return end
            end
        -- Howling Blast
            --if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
            if not necrotic and ffRemain.dyn30==0 and fRunes>=1 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Howling Blast
            --if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
            if necrotic and necRemain.dyn30==0 and fRunes>=1 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Plague Strike
            --if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking&unholy>0
            if not necrotic and bpRemain.dyn5==0 and uRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_PlagueStrike,false,false,false) then return end
            end
        -- Howling Blast (1H)
            --if=buff.rime.react
            if oneHand and rRemain>0 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Blood Tap (2H)
            --if=buff.blood_charge.stack>10&runic_power>76
            if twoHand and bcStack>10 and power>76 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Frost Strike (1H)
            --if=set_bonus.tier17_2pc=1&(runic_power>=50&(cooldown.pillar_of_frost.remains<5))
            if oneHand and t17x2 and power>=50 and pofCooldown<5 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,false,false,false) then return end
            end
        -- Frost Strike
            --if=runic_power>76
            if power>76 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,false,false,false) then return end
            end
        -- Howling Blast (2H)
            --if=buff.rime.react&disease.min_remains>5&(blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8)
            if twoHand and rRemain>0 and getDisease(30,false,"min")>5 and (bPercent>=1.8 or uPercent>=1.8 or fPercent>=1.8) and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Obliterate (2H)
            --if=blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8
            if twoHand and (bPercent>=1.8 or uPercent>=1.8 or fPercent>=1.8) and uRunes>=1 and fRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_Obliterate,false,false,false) then return end
            end
        -- Plague Leech (2H)
            --if=disease.min_remains<3&((blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95))
            if twoHand and hasDisease.dyn30AoE and getDisease(30,true,"min")<3 and ((bPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and bPercent<=0.95)) and tarDist.dyn30AoE<30 then
              if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then return end
            end
        -- Frost Stike (2H)
            --if=talent.runic_empowerment.enabled&(frost=0|unholy=0|blood=0)&(!buff.killing_machine.react|!obliterate.ready_in<=1)
            if twoHand and runic and (fRunes==0 or uRunes==0 or bRunes==0) and (kmRemain==0 or oCooldown>1) and power>25 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,true,false,false) then return end
            end
        -- Frost Strike (2H)
            --if=talent.blood_tap.enabled&buff.blood_charge.stack<=10&(!buff.killing_machine.react|!obliterate.ready_in<=1)
            if twoHand and bloodtap and bcStack<=10 and (kmRemain==0 or oCooldown>1) and power>25 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,true,false,false) then return end
            end
        -- Howling Blast (2H)
            --if=buff.rime.react&disease.min_remains>5
            if twoHand and rRemain>0 and getDisease(30,false,"min")>5 and tarDist.dyn30<30 then
              if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Obliterate (2H)
            --if=blood.frac>=1.5|unholy.frac>=1.6|frost.frac>=1.6|buff.bloodlust.up|cooldown.plague_leech.remains<=4
            if twoHand and (bPercent>=1.5 or uPercent>=1.6 or fPercent>=1.6 or hasBloodLust() or plCooldown<=4) and uRunes>=1 and fRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_Obliterate,false,false,false) then return end
            end
        -- Blood Tap (2H)
            --if=(buff.blood_charge.stack>10&runic_power>=20)|(blood.frac>=1.4|unholy.frac>=1.6|frost.frac>=1.6)
            if twoHand and ((bcStack>10 and power>=20) or (bPercent>=1.4 or uPercent>=1.6 or fPercent>=1.6)) and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Obliterate (1H)
            --if=unholy>0&!buff.killing_machine.react
            if oneHand and fRunes>0 and uRunes>0 and kmRemain==0 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_Obliterate,false,false,false) then return end
            end
        -- Frost Strike (2H)
            --if=!buff.killing_machine.react
            if twoHand and kmRemain==0 and power>25 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,true,false,false) then return end
            end
        -- Plague Leech (2H)
            --if=(blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95)
            if twoHand and ((bPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and bPercent<=0.95)) and hasDisease.dyn30AoE and tarDist.dyn30<30 then
              if castSpell(tarUnit.dyn30,_PlagueLeech,true,false,false) then return end
            end
        -- Howling Blast (1H)
            --if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains<3)|death+frost>=2
            if oneHand and (not (thp-3*(thp*ttd)<=35 and srCooldown<3 and fRunes>0) or fRunes>=2) and tarDist.dyn30<30 then
             if useCleave() or getNumEnemies(tarUnit.dyn30,10)==1 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(tarUnit.dyn30,_IcyTouch,false,false,false) then return end
              end
            end
        -- Blood Tap (1H)
            if oneHand and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Plague Leech (1H)
            if oneHand and ffRemain.dyn30>0 and bpRemain.dyn30>0 and tarDist.dyn30<30 then
              if castSpell(tarUnit.dyn30,_PlagueLeech,true,false,false) then return end
            end
        -- Empower Rune Weapon
            if isChecked("Empower Rune Weapon") and useCDs() and getRunes("Frost")==0 and getRunes("Unholy")==0 and tarDist.dyn5<5 then
              if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
            end
          end
        ----------------------
        --- Multiple Target --
        ----------------------
          if useAoE() then
        -- Unholy Blight
            if tarDist.dyn10AoE<10 then
              if castSpell("player",_UnholyBlight,true,false,false) then return end
            end
        -- Blood Boil
            --if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28
            if bpRemain.dyn10AoE>0 and ((not blight) or ubCooldown<49) and (lineTimer == nil or lineTimer <= GetTime()-28) and bRunes>=1 and tarDist.dyn10AoE<10 then
              if castSpell("player",_BloodBoil,true,false,false) then lineTimer=GetTime(); return end
            end
        -- Defile
            if defile and uRunes>=1 and dCooldown==0 and not isMoving(tarUnit.dyn30AoE) and tarDist.dyn30AoE<30 then
              if castGround(tarUnit.dyn30AoE,_Defile,30) then return end
            end
        -- Breath of Sindragosa
            --if=runic_power>75
            if power>75 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_BreathOfSindragosa,false,false,false) then return end
            end
            ----------------------------
            --- Boss Multiple Target ---
            ----------------------------
            if isBoss() and bosRemain>0 then
          -- Howling Blast
              if (fRunes>=1 or rRemain>0) and tarDist.dyn30<30 then
                if castSpell(tarUnit.dyn30,_HowlingBlast,false,false,false) then return end
              end
          -- Blood Tap
              --if=buff.blood_charge.stack>10
              if bcStack>10 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
          -- Death and Decay
              --if=unholy=1
              if uRunes==1 and not defile and dndCooldown==0 and hasThreat(tarUnit.dyn30AoE) and not isMoving(tarUnit.dyn30AoE) and tarDist.dyn30AoE<30 then
                if castGround(tarUnit.dyn30AoE,_DeathAndDecay,30) then return end
              end
          -- Plague Strike
              --if=unholy=2
              if uRunes==2 and tarDist.dyn5<5 then
                if castSpell(tarUnit.dyn5,_PlagueStrike,false,false,false) then return end
              end
          -- Blood Tap
              if bcStack>4 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
          -- Plague Leech
              if bpRemain.dyn30AoE>0 and ffRemain.dyn30AoE>0 and tarDist.dyn30AoE<30 then
                if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then return end
              end
          -- Plague Strike
              --if=unholy=1
              if uRunes==1 and tarDist.dyn5<5 then
                if castSpell(tarUnit.dyn5,_PlagueStrike,false,false,false) then return end
              end
          -- Empower Rune Weapon
              if isChecked("Empower Rune Weapon") and useCDs() and getRunes("Frost")==0 and getRunes("Unholy")==0 and tarDist.dyn5<5 then
                if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
              end
            end --End Boss Special
        -- Howling Blast
            if (fRunes>=1 or rRemain>0) and tarDist.dyn0<30 then
              if castSpell(tarUnit.dyn0,_HowlingBlast,false,false,false) then return end
            end
        -- Blood Tap
            --if=buff.blood_charge.stack>10
            if bcStack>10 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Frost Strike
            --if=runic_power>88
            if power>88 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,true,false,false) then return end
            end
        -- Death and Decay
            --if=unholy=1
            if uRunes==1 and not defile and dndCooldown==0 and hasThreat(tarUnit.dyn30AoE) and not isMoving(tarUnit.dyn30AoE) and tarDist.dyn30AoE<30 then
              if castGround(tarUnit.dyn30AoE,_DeathAndDecay,30) then return end
            end
        -- Plague Strike
            --if=unholy=2
            if uRunes==2 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_PlagueStrike,false,false,false) then return end
            end
        -- Blood Tap
            if bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Frost Strike
            --if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
            if (not sindragosa or bosCooldown>=10) and power>25 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_FrostStrike,true,false,false) then return end
            end
        -- Plague Leech
            if bpRemain.dyn30AoE>0 and ffRemain.dyn30AoE>0 and tarDist.dyn30AoE<30 then
              if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then return end
            end
        -- Plague Strike
            --if=unholy=1
            if uRunes==1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_PlagueStrike,false,false,false) then return end
            end
        -- Empower Rune Weapon
            if isChecked("Empower Rune Weapon") and useCDs() and getRunes("Frost")==0 and getRunes("Unholy")==0 and tarDist.dyn0<5 then
              if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
            end
          end
        end --In Combat End
    -- Start Attack
        if ObjectExists(tarUnit.dyn5) and isInCombat("player") and profileStop==false and tarDist.dyn5<5 then
          StartAttack()
        end
      end
    end
  end -- FrostDK() end
end -- Class Select end
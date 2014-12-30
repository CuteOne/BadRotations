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
      local hasMouse = UnitExists("mouseover")
      local deadMouse = UnitIsDeadOrGhost("mouseover")
      local playerMouse = UnitIsPlayer("mouseover")
      local level = UnitLevel("player")
      local php = getHP("player")
      local power, powmax, powgen = getPower("player"), UnitPowerMax("player"), getRegen("player")
      local ttm = getTimeToMax("player")
      local enemies, enemiesList = #getEnemies("player",8), getEnemies("player",8)
      local falling, swimming = getFallTime(), IsSwimming()
      local oneHand, twoHand = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
      --General Target Variables
      local deadtar, attacktar, hastar, playertar = UnitIsDeadOrGhost("target"), UnitCanAttack("target", "player"), UnitExists("target"), UnitIsPlayer("target")
      local tarDist = getDistance("target","player")
      local friendly = UnitIsFriend("target", "player")
      local thp,thp5 = getHP("target"),getHP(dynamicTarget(5,true))
      local ttd,ttd5 = getTimeToDie("target"), getTimeToDie(dynamicTarget(5,true))
      local thisUnit = dynamicTarget(5,true)
      local thisUnit30AoE = dynamicTarget(30,false)
      -- Specific Player Variables
      local bloodpres = getBuffRemain("player",_BloodPresence)~=0
      local frostpres = getBuffRemain("player",_FrostPresence)~=0
      local unholypres = getBuffRemain("player",_UnholyPresence)~=0
      local dRunes = getRunes("death")
      local bRunes = getRunes("blood") + getRunes("death")
      local fRunes = getRunes("frost") + getRunes("death")
      local uRunes = getRunes("unholy") + getRunes("death")
      local dPercent = getRunePercent("death")
      local bPercent = getRunePercent("blood") + getRunes("death")
      local fPercent = getRunePercent("frost") + getRunes("death")
      local uPercent = getRunePercent("unholy") + getRunes("death")
      local bcStack = bcStack
      local rRemain = getBuffRemain("player",_Rime)
      local kmRemain = getBuffRemain("player",_KillingMachine)
      local howRemain = getBuffRemain("player",_HornOfWinter)
      local pofRemain = getBuffRemain("player",_PillarOfFrost)
      local empRemain = getBuffRemain("player",_EmpowerRuneWeapon)
      local dsRemain = getBuffRemain("player",_DarkSuccor)
      local amsRemain = getBuffRemain("player",_AntiMagicShell)
      local srCooldown = getSpellCD(_SoulReaper)
      local bocCooldown = bocCooldown
      local plCooldown = getSpellCD(_PlagueLeech)
      local ubCooldown = getSpellCD(_UnholyBlight)
      local dCooldown = getSpellCD(_Defile)
      local amsCooldown = getSpellCD(_AntiMagicShell)
      local pofCooldown = getSpellCD(_PillarOfFrost)
      local raCooldown = getSpellCD(_RaiseAlly)
      local blight = getTalent(1,3)
      local bloodtap = getTalent(4,1)
      local runic = getTalent(4,2)
      local necrotic = getTalent(7,1)
      local defile = getTalent(7,2)
      local cindragosa = getTalent(7,3)
      local t17x2 = false
      --Specific Target Variables
      local ciRemain = getDebuffRemain("target",_ChainsOfIce,"player")
      local ffRemain = getDebuffRemain("target",_FrostFever,"player")
      local bpRemain = getDebuffRemain("target",_BloodPlague,"player")
      local necRemain = getDebuffRemain("target",_NecroticPlague,"player")
      local bocRemain = bocRemain
      if cindragosa then
        bocCooldown = getSpellCD(_BreathOfCindragosa)
        bocRemain = getDebuffRemain("target",_BreathOfCindragosa,"player")
      else
        bocCooldown = 120
        bocRemain = 999
      end
      if getBuffRemain("player",_BloodCharge)>0 then
        bcStack = select(4,UnitBuffID("player",_BloodCharge))
      else
        bcStack = 0
      end
  --------------------------------------------------
  --- Ressurection/Dispelling/Healing/Pause/Misc ---
  --------------------------------------------------
    -- Profile Stop
      if isInCombat("player") and profileStop==true then
        return true
      else
        profileStop=false
      end
    -- AutoLooter
      if isChecked("Auto Looter") then
        if not isInCombat("player") and getLoot() then
          return true
        end
      end
    -- Raise Ally
      if isInCombat("player") and raCooldown==0 and power>30 and tarDist<40 then
        if isChecked("Mouseover Targeting") and hasMouse and deadMouse and playerMouse then
          if castSpell("mouseover",ra,true,true,false,false,true) then return end
        elseif hastar and deadtar and playertar then
          if castSpell("target",rb,true,false,false,false,true) then return end
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
        if not frostpres and php > getOptionValue("Blood Presence") and (tarDist<=20 and attacktar and not deadtar) then
          if castSpell("player",_FrostPresence,true,false,false) then return end
        end
      -- Unholy Presence
        if not unholypres and ((not isInCombat("player") and IsMovingTime(2)) or (UnitExists("target") and tarDist>20 and power<40)) then
          if castSpell("player",_UnholyPresence,true,false,false) then return end
        end
      -- Path of Frost
        if not isInCombat("player") and IsSwimming() and not UnitBuffID("player",_PathOfFrost) then
          if castSpell("player",_PathOfFrost,true,false,false) then return end
        end
      -- Control Undead
        if UnitCreatureType("Undead") and uRunes>0 and not UnitExists("pet")
          and (UnitClassification("target")~="normal" or UnitClassification("target")~="trivial" or UnitClassification("target")~="minus") 
        then
          if castSpell("target",_ControlUndead,false,false,false) then return end
        end
      -- Flask / Crystal
        if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
            if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") 
              and not (UnitBuffID("player",156073) or UnitBuffID("player",156064)) --Draenor Agi Flasks
            then
                if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
                    UseItemByName(tostring(select(1,GetItemInfo(118922))))
                end
            end
        end
  ------------------
  --- Defensives ---
  ------------------
        if useDefensive() and tarDist<10 then
          -- Blood Presence
          if isChecked("Blood Presence") and php <= getOptionValue("Blood Presence") and not bloodpres then
            if castSpell("player",_BloodPresence,true,false,false) then return end
          end
          -- Death Strike
          if isChecked("Death Strike") and php<=getOptionValue("Death Strike") and kmRemain==0 and dsRemain>0 and tarDist<5 then
            if castSpell("target",_DeathStrike,false,false,false) then return end
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
            if castSpell("target",_DeathSiphon,false,false,false) then return end
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
          if tarDist<30 and tarDist>8 and select(2,IsInInstance())=="none" and #members==1 then
            if castSpell("target",_DeathGrip,false,false,false) then return end
          end
      -- Frost Strike
          if power>76 and tarDist<5 then
            if castSpell("target",_FrostStrike,false,false,false) then return end
          end
      -- Outbreak
          if ffRemain==0 and bpRemain==0 and tarDist<30 then
            if castSpell("target",_Outbreak,false,false,false) then return end
          end
      -- Unholy Blight
          if ffRemain==0 and bpRemain==0 and tarDist<10 then
            if castSpell("target",_UnholyBlight,false,false,false) then return end
          end
      -- Howling Blast
          if ffRemain==0 and fRunes>=1 and tarDist<30 then
            if getNumEnemies("target",10)==1 and useCleave() then
              if castSpell("target",_HowlingBlast,false,false,false) then return end
            else
              if castSpell("target",_IcyTouch,false,false,false) then return end
            end
          end
      -- Plague Strike
          if bpRemain==0 and bRunes>=1 and tarDist<5 then
            if castSpell("target",_PlagueStrike,false,false,false) then return end
          end
      -- Start Attack
          if getDistance(thisUnit, "player")<5 then
            StartAttack()
          end
        end
  -----------------
  --- In Combat ---
  -----------------
        if hastar and attacktar and isInCombat("player") then
    ------------------------------
    --- In Combat - Dummy Test ---
    ------------------------------
      -- Dummy Test
          if isChecked("DPS Testing") then
            if UnitExists("target") then
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
            if isChecked("Mind Freeze") then
              if castInterrupt(_MindFreeze,getOptionValue("Interrupt At")) then return end
            end
        -- Strangulate
            if isChecked("Strangulate") and bRunes>0 then
              if castInterrupt(_Strangulate,getOptionValue("Interrupt At")) then return end
            end
        -- Asphyxiate
            if isChecked("Asphyxiate") then
              if castInterrupt(_Asphyxiate,getOptionValue("Interrupt At")) then return end
            end
        -- Dark Simulacrum
            if isChecked("Dark Simulacrum") and power>20 then
              if castInterrupt(_DarkSimulacrum,getOptionValue("Interrupt At")) then return end
            end 
          end
    -----------------------------
    --- In Combat - Cooldowns ---
    -----------------------------
          if useCDs() and tarDist<5 then
        -- Potion
            if canUse(109219) and (ttd<=30 or (ttd<=60 and pofRemain>0)) and select(2,IsInInstance())=="raid" and isChecked("Agi-Pot") then
              UseItemByName(tostring(select(1,GetItemInfo(109219))))
            end
        -- Empower Rune Weapon
            if isChecked("Empower Rune Weapon") and ttd<=60 and strPotRemain>0 then
              if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
            end
        -- Trinket 1
            if isChecked("Trinkets") and canTrinket(13) and useCDs() then
              RunMacroText("/use 13")
            end
        -- Trinket 2
            if isChecked("Trinkets") and canTrinket(14) and useCDs() then
              RunMacroText("/use 14")
            end
          end
    --------------------------
    --- In Combat Rotation ---
    --------------------------
        -- Start Attack
          if getDistance(thisUnit, "player")<5 then
            StartAttack()
          end
        -- Death Grip
          if tarDist<30 and tarDist>8 and select(2,IsInInstance())=="none" then
            if castSpell("target",_DeathGrip,false,false,false) then return end
          end
        -- Chains of Ice
          if not getFacing("target","player") and getFacing("player","target") 
            and isMoving("target") and tarDist>8 and fRunes>=1 and isInCombat("target") and ciRemain==0
          then
            if castSpell("target",_ChainsOfIce,false,false,false) then return end
          end
        -- Death's Advance
          if isMoving("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") and tarDist>=15 then
            if castSpell("player",_DeathsAdvance,true,false,false) then return end
          end
        -- Pillar of Frost
          if fRunes>=1 and tarDist<5 then
            if castSpell("player",_PillarOfFrost,true,false,false) then return end
          end
        --------------------
        --- Single Target --
        --------------------
          if not useAoE() then
        -- Blood Tap (1H)
            if oneHand and bcStack>10 and (power>76 or (power>=20 and kmRemain>0)) then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Plague Leech (2H)
            if twoHand and ffRemain<1 and ffRemain>0 and bpRemain<1 and bpRemain>0 and tarDist<30 then
              if castSpell("target",_PlagueLeech,true,false,false) then return end
            end
        -- Soul Reaper
            if thp-3*(thp/ttd)<=35 and fRunes>=1 and tarDist<5 then
              if castSpell("target",_SoulReaper,false,false,false) then return end
            end
        -- Blood Tap
            if (thp-3*(thp/ttd)<=35 and srCooldown==0) and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Defile (2H)
            if twoHand and defile and uRunes>=1 and useCleave() and tarDist<30 then
              if castGround("target",_Defile,30) then return end
            end
        -- Blood Tap (2H)
            if twoHand and defile and dCooldown==0 and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Howling Blast (2H)
            if twoHand and rRemain>0 and ffRemain>5 and kmRemain>0 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Obliterate (2H)
            if twoHand and kmRemain>0 and fRunes>=1 and uRunes<=1 and tarDist<5 then
              if castSpell("target",_Obliterate,false,false,false) then return end
            end
        -- Blood Tap (2H)
            if twoHand and kmRemain>0 and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Howling Blast (2H)
            if twoHand and not necrotic and ffRemain==0 and rRemain>0 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Outbreak (2H)
            if twoHand and ffRemain==0 and bpRemain==0 and tarDist<30 then
              if castSpell("target",_Outbreak,false,false,false) then return end
            end
        -- Unholy Blight (2H)
            if ffRemain==0 and bpRemain==0 and useCleave() and tarDist<10 then
              if castSpell("target",_UnholyBlight,false,false,false) then return end
            end
        -- Breath of Cindragosa
            if power>75 and tarDist<5 then
              if castSpell("target",_BreathOfCindragosa,false,false,false) then return end
            end
            --------------------------
            --- Boss Single Target ---
            --------------------------
            if isBoss() and bocRemain>0 then
            -- Obliterate
              if kmRemain>0 and uRunes>=1 and fRunes>=1 and tarDist<5 then
                if castSpell("target",_Obliterate,false,false,false) then return end
              end
            -- Blood Tap
              if kmRemain>0 and bcStack>=5 and tarDist<5 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
            -- Plague Leech
              if kmRemain>0 and ffRemain>0 and bpRemain>0 and tarDist<30 then
                if castSpell("target",_PlagueLeech,true,false,false) then return end
              end
            -- Blood Tap
              if bcStack>=5 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
            -- Plague Leech
              if ffRemain>0 and bpRemain>0 and tarDist<30 then
                if castSpell("target",_PlagueLeech,true,false,false) then return end
              end
            -- Howling Blast (1H)
              if oneHand and power<88 and fRunes>0 and tarDist<30 then
                if useCleave() or getNumEnemies("target",10)==1 then
                  if castSpell("target",_HowlingBlast,false,false,false) then return end
                else
                  if castSpell("target",_IcyTouch,false,false,false) then return end
                end
              end
            -- Obliterate
              if power<76 and uRunes>=1 and fRunes>=1 and tarDist<5 then
                if castSpell("target",_Obliterate,false,false,false) then return end
              end
            -- Howling Blast (2H)
              if twoHand and ((dRunes==1 and fRunes==0 and uRunes==0) or (dRunes==0 and fRunes==1 and uRunes==0)) and power<88 and tarDist<30 then
                if useCleave() or getNumEnemies("target",10)==1 then
                  if castSpell("target",_HowlingBlast,false,false,false) then return end
                else
                  if castSpell("target",_IcyTouch,false,false,false) then return end
                end
              end
            end
        -- Defile (1H)  
            if oneHand and defile and uRunes>=1 and tarDist<30 then
              if castGround(thisUnit30AoE,_Defile,30) then return end
            end
        -- Blood Tap (1H)
            if oneHand and defile and dCooldown==0 and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Howling Blast (1H)
            if oneHand and cindragosa and bocCooldown<7 and power<88 and fRunes>=1 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end        
        -- Obliterate (1H/2H)
            if cindragosa and ((oneHand and bocCooldown<3) or (twoHand and bocCooldown<7)) and power<76 and uRunes>=1 and fRunes>=1 and tarDist<5 then
              if castSpell("target",_Obliterate,false,false,false) then return end
            end
        -- Howling Blast (2H)
            if twoHand and cindragosa and bocCooldown<3 and power<88 and fRunes>=1 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end 
        -- Frost Strike (1H)
            if oneHand and (kmRemain>0 or power>88) and tarDist<5 then
              if castSpell("target",_FrostStrike,false,false,false) then return end
            end
        -- Frost Strike (1H)
            if oneHand and amsCooldown<1 and power>=50 and amsRemain==0 and tarDist<5 then
              if castSpell("target",_FrostStrike,false,false,false) then return end
            end
        -- Howling Blast (1H)
            if oneHand and (dRunes>1 or fRunes<1) and tarDist<30 then
               if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Unholy Blight (1H)
            if oneHand and ffRemain==0 and bpRemain==0 and tarDist<10 then
              if castSpell("player",_UnholyBlight,true,false,false) then return end
            end  
        -- Howling Blast
            if not necrotic and ffRemain==0 and fRunes>=1 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Howling Blast
            if necrotic and necRemain==0 and fRunes>=1 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Plague Strike
            if not necrotic and bpRemain==0 and uRunes>=1 and tarDist<5 then
              if castSpell("target",_PlagueStrike,false,false,false) then return end
            end
        -- Howling Blast (1H)
            if oneHand and rRemain>0 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Blood Tap (2H)
            if twoHand and bcStack>10 and power>76 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Frost Strike (1H)
            if oneHand and t17x2 and power>=50 and pofCooldown<5 and tarDist<5 then
              if castSpell("target",_FrostStrike,false,false,false) then return end
            end
        -- Frost Strike
            if power>76 and tarDist<5 then
              if castSpell("target",_FrostStrike,false,false,false) then return end
            end
        -- Howling Blast (2H)
            if twoHand and rRemain>0 and ffRemain>5 and (bPercent>=1.8 or uPercent>=1.8 or fPercent>=1.8 or dRunes>=1) and fRunes>=1 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Obliterate (2H)
            if twoHand and (bPercent>=1.8 or uPercent>=1.8 or fPercent>=1.8 or dRunes>=2) and uRunes>=1 and fRunes>=1 and tarDist<5 then
              if castSpell("target",_Obliterate,false,false,false) then return end
            end
        -- Plague Leech (2H)
            if twoHand and ffRemain<3 and ffRemain>0 and bpRemain<3 and bpRemain>0 and ((bPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and bPercent<=0.95)) and tarDist<30 then
              if castSpell("target",_PlagueLeech,true,false,false) then return end
            end
        -- Frost Stike (2H)
            if twoHand and runic and (fRunes==0 or uRunes==0 or bRunes==0 or dRunes==0) and kmRemain==0 and power>40 and tarDist<5 then
              if castSpell("target",_FrostStrike,true,false,false) then return end
            end
        -- Frost Strike (2H)
            if twoHand and bloodtap and bcStack<=10 and kmRemain==0 and power>40 and tarDist<5 then
              if castSpell("target",_FrostStrike,true,false,false) then return end
            end
        -- Howling Blast (2H)
            if twoHand and rRemain>0 and ffRemain>5 and fRunes>=1 and tarDist<30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Obliterate (2H)
            if twoHand and (bPercent>=1.5 or uPercent>=1.6 or fPercent>=1.6 or dRunes>=2 or plCooldown<=4) and uRunes>=1 and fRunes>=1 and tarDist<5 then
              if castSpell("target",_Obliterate,false,false,false) then return end
            end
        -- Blood Tap (2H)
            if twoHand and ((bcStack>10 and power>=20) or (bPercent>=1.4 or uPercent>=1.6 or fPercent>=1.6)) and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Obliterate (1H)
            if oneHand and fRunes>0 and uRunes>0 and kmRemain==0 and tarDist<5 then
              if castSpell("target",_Obliterate,false,false,false) then return end
            end
        -- Frost Strike (2H)
            if twoHand and kmRemain==0 and power>40 and tarDist<5 then
              if castSpell("target",_FrostStrike,true,false,false) then return end
            end
        -- Plague Leech (2H)
            if twoHand and ((bPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and bPercent<=0.95)) and ffRemain>0 and bpRemain>0 and tarDist<30 then
              if castSpell("target",_PlagueLeech,true,false,false) then return end
            end
        -- Howling Blast (1H)
            if oneHand and (not (thp-3*(thp*ttd)<=35 and srCooldown<3 and fRunes>0) or fRunes>=2) and tarDist<30 then
             if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              else
                if castSpell("target",_IcyTouch,false,false,false) then return end
              end
            end
        -- Blood Tap (1H)
            if oneHand and bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Plague Leech (1H)
            if oneHand and ffRemain>0 and bpRemain>0 and tarDist<30 then
              if castSpell("target",_PlagueLeech,true,false,false) then return end
            end
        -- Empower Rune Weapon
            if isChecked("Empower Rune Weapon") and useCDs() and tarDist<5 then
              if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
            end
          end
        ----------------------
        --- Multiple Target --
        ----------------------  
          if useAoE() then
        -- Unholy Blight
            if tarDist<10 then 
              if castSpell("player",_UnholyBlight,true,false,false) then return end
            end
        -- Blood Boil
            if bpRemain>0 and (not blight or ubCooldown<49) and bRunes>=1 and tarDist<10 then
              if castSpell("player",_BloodBoil,true,false,false) then return end
            end
        -- Defile
            if defile and uRunes>=1 and tarDist<30 then
              if castGround(thisUnit30AoE,_Defile,30) then return end
            end
        -- Breath of Cindragosa
            if power>75 and tarDist<5 then
              if castSpell("target",_BreathOfCindragosa,false,false,false) then return end
            end
            ----------------------------
            --- Boss Multiple Target ---
            ----------------------------
            if isBoss() and bocRemain>0 then
          -- Howling Blast
              if fRunes>=1 and tarDist<30 then
                if castSpell("target",_HowlingBlast,false,false,false) then return end
              end
          -- Blood Tap
              if bcStack>10 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
          -- Death and Decay
              if uRunes==1 and tarDist<30 then
                if castGround(thisUnit30AoE,_DeathAndDecay,30) then return end
              end
          -- Plague Strike
              if uRunes==2 and tarDist<5 then
                if castSpell("target",_PlagueStrike,false,false,false) then return end
              end
          -- Blood Tap
              if bcStack>4 then
                if castSpell("player",_BloodTap,true,false,false) then return end
              end
          -- Plague Leech
              if bpRemain>0 and ffRemain>0 and tarDist<30 then
                if castSpell("target",_PlagueLeech,true,false,false) then return end
              end
          -- Plague Strike
              if uRunes==1 and tarDist<5 then
                if castSpell("target",_PlagueStrike,false,false,false) then return end
              end
          -- Empower Rune Weapon
              if isChecked("Empower Rune Weapon") and useCDs() and tarDist<5 then
                if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
              end
            end
        -- Howling Blast
            if fRunes>=1 and tarDist<30 then
              if castSpell("target",_HowlingBlast,false,false,false) then return end
            end
        -- Blood Tap
            if bcStack>10 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Frost Strike
            if power>88 and tarDist<5 then
              if castSpell("target",_FrostStrike,true,false,false) then return end
            end
        -- Death and Decay
            if uRunes==1 and tarDist<30 then
              if castGround(thisUnit30AoE,_DeathAndDecay,30) then return end
            end
        -- Plague Strike
            if uRunes==2 and tarDist<5 then
              if castSpell("target",_PlagueStrike,false,false,false) then return end
            end
        -- Blood Tap
            if bcStack>4 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Frost Strike
            if (not cindragosa or bocCooldown>=10) and tarDist<5 then
              if castSpell("target",_FrostStrike,true,false,false) then return end
            end
        -- Plague Leech
            if bpRemain>0 and ffRemain>0 and tarDist<30 then
              if castSpell("target",_PlagueLeech,true,false,false) then return end
            end
        -- Plague Strike
            if uRunes==1 and tarDist<5 then
              if castSpell("target",_PlagueStrike,false,false,false) then return end
            end
        -- Empower Rune Weapon
            if isChecked("Empower Rune Weapon") and useCDs() and tarDist<5 then
              if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
            end
          end
        end --In Combat End
    -- Start Attack
        if UnitExists(dynamicTarget(5,true)) and not stealth and isInCombat("player") and profileStop==false and tarDist<5 then
          StartAttack()
        end
      end
    end
  end -- FrostDK() end
end -- Class Select end
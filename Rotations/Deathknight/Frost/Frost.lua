if select(3, UnitClass("player")) == 6 then
  function FrostDK()
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
    --General Target Variables
    local deadtar, attacktar, hastar, playertar = UnitIsDeadOrGhost("target"), UnitCanAttack("target", "player"), UnitExists("target"), UnitIsPlayer("target")
    local tarDist = getDistance("target","player")
    local friendly = UnitIsFriend("target", "player")
    local thp,thp5 = getHP("target"),getHP(dynamicTarget(5,true))
    local ttd,ttd5 = getTimeToDie("target"), getTimeToDie(dynamicTarget(5,true))
    local thisUnit5 = dynamicTarget(5,true)
    local thisUnit30AoE = dynamicTarget(30,false)
    -- Specific Player Variables
    local dRunes = getRunes("death")
    local bRunes = getRunes("blood") + getRunes("death")
    local fRunes = getRunes("frost") + getRunes("death")
    local uRunes = getRunes("unholy") + getRunes("death")
    local dPercent = getRunePercent("death")
    local bPercent = getRunePercent("blood")
    local fPercent = getRunePercent("frost")
    local uPercent = getRunePercent("unholy")
    local bcStack = bcStack
    local rRemain = getBuffRemain("player",_Rime)
    local kmRemain = getBuffRemain("player",_KillingMachine)
    local howRemain = getBuffRemain("player",_HornOfWinter)
    local pofRemain = getBuffRemain("player",_PillarOfFrost)
    local empRemain = getBuffRemain("player",_EmpowerRuneWeapon)
    local dsRemain = getBuffRemain("player",_DarkSuccor)
    local srCooldown = getSpellCD(_SoulReaper)
    local bocCooldown = bocCooldown
    local plCooldown = getSpellCD(_PlagueLeech)
    local ubCooldown = getSpellCD(_UnholyBlight)
    local blight = getTalent(1,3)
    local bloodtap = getTalent(4,1)
    local runic = getTalent(4,2)
    local necrotic = getTalent(7,1)
    local defile = getTalent(7,2)
    local cindragosa = getTalent(7,3)
    --Specific Target Variables
    local ffRemain, ffRemain5 = getDebuffRemain("target",_FrostFever,"player"), getDebuffRemain(dynamicTarget(5,true),_FrostFever,"player")
    local bpRemain, bpRemain5 = getDebuffRemain("target",_BloodPlague,"player"), getDebuffRemain(dynamicTarget(5,true),_BloodPlague,"player")
    local necRemain = getDebuffRemain(dynamicTarget(5,true),_NecroticPlague,"player")
    local bocRemain = bocRemain
    if cindragosa then
      bocCooldown = getSpellCD(_BreathOfCindragosa)
      bocRemain = getDebuffRemain(dynamicTarget(5,true),_BreathOfCindragosa,"player")
    else
      bocCooldown = 120
      bocRemain = 999
    end
    if getBuffRemain("player",_BloodCharge)>0 then
      bcStack = getCharges(_BloodCharge)
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
  -- Pause
    if pause() then
      return true
    elseif not pause() then
-------------
--- Buffs ---
-------------
    -- Horn of Winter
      if isChecked("Horn of Winter") and not hasmouse and not (IsFlying() or IsMounted()) and not isInCombat("player") then
          for i = 1, #members do --members
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
      if GetShapeshiftForm()~=2 and php > getOptionValue("Blood Presence") then
        if castSpell("player",_FrostPresence,true,false,false) then return end
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
        if isChecked("Blood Presence") and php <= getOptionValue("Blood Presence") and GetShapeshiftForm()~=1 then
          if castSpell("player",_BloodPresence,true,false,false) then return end
        end
        -- Icebound Fortitude
        if isChecked("Icebound Fortitude") and php <= getOptionValue("Icebound Fortitude") then
          if castSpell("player",_IceboundFortitude,true,false,false) then return end
        end
        -- Anti-Magic Shell/Zone
        if getTalent(2,2) then
          if isChecked("Anti-Magic Zone") and php <= getOptionValue("Anti-Magic Zone") then
            if castGround("player",_AntiMagicZone,5) then return end
          end
        else
          if isChecked("Anti-Magic Shell") and php <= getOptionValue("Anti-Magic Shell") then
            if castGround("player",_AntiMagicShell,5) then return end
          end
        end
        -- Lichborne
        if isChecked("Lichborne") and hasNoControl(_Lichborne) then
          if castSpell("player",_Lichborne,true,false,false) then return end
        end
        -- Death Pact
        if isChecked("Death Pact") and php <= getOptionValue("Death Pact") then
          if castSpell("player",_DeathPact,true,false,false) then return end
        end
        -- Death Siphon
        if isChecked("Death Siphon") and php <= getOptionValue("Death Siphon") and dRunes>=1 then
          if castSpell(thisUnit5,_DeathSiphon,false,false,false) then return end
        end
        -- Conversion
        if isChecked("Conversion") and php <= getOptionValue("Conversion") and power>=50 then
          if castSpell("player",_Conversion,true,false,false) then return end
        end
        -- Remorseless Winter
        if isChecked("Remorseless Winter") and (useAoE() or php <= getOptionValue("Remorseless Winter")) then
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
        and select(2,IsInInstance())=="none" and #members==1
      then
    -- Death Grip
        if tarDist<30 then
          if castSpell("target",_DeathGrip,false,false,false) then return end
        end
    -- Frost Strike
        if power>76 and tarDist<=5 then
          if castSpell("target",_FrostStrike,false,false,false) then return end
        end
    -- Outbreak
        if ffRemain==0 and bpRemain==0 and tarDist<=30 then
          if castSpell("target",_Outbreak,false,false,false) then return end
        end
    -- Unholy Blight
        if ffRemain==0 and bpRemain==0 and tarDist<=10 then
          if castSpell("target",_UnholyBlight,false,false,false) then return end
        end
    -- Howling Blast
        if ffRemain==0 and fRunes>=1 and tarDist<=30 then
          if getNumEnemies("target",10)==1 and useCleave() then
            if castSpell("target",_HowlingBlast,false,false,false) then return end
          else
            if castSpell("target",_IcyTouch,false,false,false) then return end
          end
        end
    -- Plague Strike
        if bpRemain==0 and bRunes>=1 and tarDist<=5 then
          if castSpell("target",_PlagueStrike,false,false,false) then return end
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
            if castInterrupt(_MindFreeze,getOptionValue("Interrupts")) then return end
          end
      -- Asphyxiate
          if isChecked("Asphyxiate") then
            if castInterrupt(_Asphyxiate,getOptionValue("Interrupts")) then return end
          end
      -- Dark Simulacrum
          if isChecked("Dark Simulacrum") and power>20 then
            if castInterrupt(_DarkSimulacrum,getOptionValue("Interrupts")) then return end
          end 
        end
  -----------------------------
  --- In Combat - Cooldowns ---
  -----------------------------
        if useCDs() and tarDist<=5 then
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
      -- Death's Advance
        if isMoving("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") and tarDist>=15 then
          if castSpell("player",_DeathsAdvance,true,false,false) then return end
        end
      -- Pillar of Frost
        if fRunes>=1 and tarDist<=5 then
          if castSpell("player",_PillarOfFrost,true,false,false) then return end
        end
      --------------------
      --- Single Target --
      --------------------
        if not useAoE() then
      -- Plague Leech
          if ((ffRemain<1 and ffRemain>0) or (bpRemain<1 and bpRemain>0)) and tarDist<=30 then
            if castSpell(thisUnit5,_PlagueLeech,true,false,false) then return end
          end
      -- Soul Reaper
          if thp5-3*(thp5/ttd5)<=35 and fRunes>=1 and tarDist<=5 then
            if castSpell(thisUnit5,_SoulReaper,false,false,false) then return end
          end
      -- Blood Tap
          if (thp-3*(thp/ttd)<=35 and srCooldown==0) and bcStack>0 and tarDist<=5 then
            if castSpell("player",_BloodTap,true,false,false) then return end
          end
      -- Defile
          if defile and uRunes>=1 and useCleave() and tarDist<=30 then
            if castGround(thisUnit30AoE,_Defile,30) then return end
          end
      -- Blood Tap
          if defile and dCooldown==0 and bcStack>0 and tarDist<=5 then
            if castSpell("player",_BloodTap,true,false,false) then return end
          end
      -- Howling Blast
          if rRemain>0 and ffRemain5>5 and kmRemain>0 and fRunes>=1 and tarDist<=30 then
            if useCleave() or getNumEnemies("target",10)==1 then
              if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
            else
              if castSpell(thisUnit5,_IcyTouch,false,false,false) then return end
            end
          end
      -- Outbreak
          if ffRemain==0 and bpRemain==0 and tarDist<=30 then
            if castSpell(thisUnit5,_Outbreak,false,false,false) then return end
          end
      -- Unholy Blight
          if ffRemain==0 and bpRemain==0 and useCleave() and tarDist<=10 then
            if castSpell(thisUnit5,_UnholyBlight,false,false,false) then return end
          end
      -- Breath of Cindragosa
          if power>75 and tarDist<=5 then
            if castSpell(thisUnit5,_BreathOfCindragosa,false,false,false) then return end
          end
          --------------------------
          --- Boss Single Target ---
          --------------------------
          if isBoss() and bocRemain>0 then
          -- Obliterate
            if ((kmRemain>0 and uRunes>=1 and fRunes>=1)
              or (dsRemain>0 and isChecked("Death Strike") and php<=getOptionValue("Death Strike"))) and tarDist<=5
            then
              if isChecked("Death Strike") and php<=getOptionValue("Death Strike") then
                if castSpell(thisUnit5,_DeathStrike,false,false,false) then return end
              else
                if castSpell(thisUnit5,_Obliterate,false,false,false) then return end
              end
            end
          -- Blood Tap
            if kmRemain>0 and bcStack>=5 and tarDist<=5 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
          -- Plague Leech
            if kmRemain>0 and (ffRemain>0 or bpRemain>0) and tarDist<=30 then
              if castSpell(thisUnit5,_PlagueLeech,true,false,false) then return end
            end
          -- Blood Tap
            if bcStack>=5 and tarDist<=5 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
          -- Plague Leech
            if (ffRemain>0 or bpRemain>0) and tarDist<=5 then
              if castSpell(thisUnit5,_PlagueLeech,true,false,false) then return end
            end
          -- Obliterate
            if ((power<76 and uRunes>=1 and fRunes>=1)
              or (dsRemain>0 and isChecked("Death Strike") and php<=getOptionValue("Death Strike"))) and tarDist<=5
            then
              if isChecked("Death Strike") and php<=getOptionValue("Death Strike") then
                if castSpell(thisUnit5,_DeathStrike,false,false,false) then return end
              else
                if castSpell(thisUnit5,_Obliterate,false,false,false) then return end
              end
            end
          -- Howling Blast
            if ((dRunes==1 and fRunes==0 and uRunes==0) or (dRunes==0 and fRunes==1 and uRunes==0)) and power<88 and tarDist<=30 then
              if useCleave() or getNumEnemies("target",10)==1 then
                if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
              else
                if castSpell(thisUnit5,_IcyTouch,false,false,false) then return end
              end
            end
          end
      -- Obliterate
          if cindragosa and bocCooldown<7 and ((power<76 and uRunes>=1 and fRunes>=1) 
              or (dsRemain>0 and isChecked("Death Strike") and php<=getOptionValue("Death Strike"))) and tarDist<=5
          then
            if isChecked("Death Strike") and php<=getOptionValue("Death Strike") then
              if castSpell(thisUnit5,_DeathStrike,false,false,false) then return end
            else
              if castSpell(thisUnit5,_Obliterate,false,false,false) then return end
            end
          end
      -- Howling Blast
          if cindragosa and bocCooldown<3 and power<88 and fRunes>=1 and tarDist<=30 then
            if useCleave() or getNumEnemies("target",10)==1 then
              if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
            else
              if castSpell(thisUnit5,_IcyTouch,false,false,false) then return end
            end
          end
      -- Howling Blast
          if not necrotic and ffRemain5==0 and fRunes>=1 and tarDist<=30 then
            if useCleave() or getNumEnemies("target",10)==1 then
              if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
            else
              if castSpell(thisUnit5,_IcyTouch,false,false,false) then return end
            end
          end
      -- Howling Blast
          if necrotic and necRemain==0 and fRunes>=1 and tarDist<=30 then
            if useCleave() or getNumEnemies("target",10)==1 then
              if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
            else
              if castSpell(thisUnit5,_IcyTouch,false,false,false) then return end
            end
          end
      -- Plague Strike
          if not necrotic and bpRemain==0 and uRunes>=1 and tarDist<=5 then
            if castSpell(thisUnit5,_PlagueStrike,false,false,false) then return end
          end
      -- Blood Tap
          if bcStack>10 and power>76 and tarDist<=5 then
            if castSpell("player",_BloodTap,true,false,false) then return end
          end
      -- Frost Strike
          if power>76 and tarDist<=5 then
            if castSpell(thisUnit5,_FrostStrike,false,false,false) then return end
          end
      -- Howling Blast
          if rRemain>0 and ffReamin5>5 and (bPercent>=1.8 or uPercent>=1.8 or fPercent>=1.8) and fRunes>=1 and tarDist<=30 then
            if useCleave() or getNumEnemies("target",10)==1 then
              if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
            else
              if castSpell(thisUnit5,_IcyTouch,false,false,false) then return end
            end
          end
      -- Obliterate
          if (((bPercent>=1.8 or uPercent>=1.8 or fPercent>=1.8) and uRunes>=1 and fRunes>=1)
            or (dsRemain>0 and isChecked("Death Strike") and php<=getOptionValue("Death Strike"))) and tarDist<=5 
          then
            if isChecked("Death Strike") and php<=getOptionValue("Death Strike") then
              if castSpell(thisUnit5,_DeathStrike,false,false,false) then return end
            else
              if castSpell(thisUnit5,_Obliterate,false,false,false) then return end
            end
          end
      -- Plague Leech
          if ((ffRemain<3 and ffRemain>0) or (bpRemain<3 and bpRemain>0)) and ((bPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and bPercent<=0.95)) and tarDist<=30 then
            if castSpell(thisUnit5,_PlagueLeech,true,false,false) then return end
          end
      -- Frost Stike
          if runic and (fRunes==0 or uRunes==0 or bRunes==0 or dRunes==0) and kmRemain==0 and power>40 and tarDist<=5 then
            if castSpell(thisUnit5,_FrostStrike,true,false,false) then return end
          end
      -- Frost Strike
          if bloodtap and bcStack<=10 and kmRemain==0 and power>40 and tarDist<=5 then
            if castSpell(thisUnit5,_FrostStrike,true,false,false) then return end
          end
      -- Howling Blast
          if rRemain>0 and ffRemain>5 and fRunes>=1 and tarDist<=30 then
            if useCleave() or getNumEnemies("target",10)==1 then
              if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
            else
              if castSpell(thisUnit5,_IcyTouch,false,false,false) then return end
            end
          end
      -- Obliterate
          if (((bPercent>=1.5 or uPercent>=1.6 or fPercent>=1.6 or plCooldown<=4) and uRunes>=1 and fRunes>=1)
            or (dsRemain>0 and isChecked("Death Strike") and php<=getOptionValue("Death Strike"))) and tarDist<=5 
          then
            if isChecked("Death Strike") and php<=getOptionValue("Death Strike") then
              if castSpell(thisUnit5,_DeathStrike,false,false,false) then return end
            else
              if castSpell(thisUnit5,_Obliterate,false,false,false) then return end
            end
          end
      -- Blood Tap
          if ((bcStack>10 and power>=20) or (bPercent>=1.4 or uPercent>=1.6 or fPercent>=1.6)) and tarDist<=5 then
            if castSpell("player",_BloodTap,true,false,false) then return end
          end
      -- Frost Strike
          if kmRemain==0 and power>40 and tarDist<=5 then
            if castSpell(thisUnit5,_FrostStrike,true,false,false) then return end
          end
      -- Plague Leech
          if ((bPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and uPercent<=0.95) or (fPercent<=0.95 and bPercent<=0.95)) and (ffRemain>0 or bpRemain>0) and tarDist<=30 then
            if castSpell(thisUnit5,_PlagueLeech,true,false,false) then return end
          end
      -- Empower Rune Weapon
          if isChecked("Empower Rune Weapon") and useCDs() and tarDist<=5 then
            if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
          end
        end
      ----------------------
      --- Multiple Target --
      ----------------------  
        if useAoE() then
      -- Unholy Blight
          if tarDist<=10 then 
            if castSpell("player",_UnholyBlight,true,false,false) then return end
          end
      -- Blood Boil
          if bpRemain>0 and (not blight or ubCooldown<49) and bRunes>=1 and tarDist<=10 then
            if castSpell("player",_BloodBoil,true,false,false) then return end
          end
      -- Defile
          if defile and uRunes>=1 and tarDist<=30 then
            if castGround(thisUnit30AoE,_Defile,30) then return end
          end
      -- Breath of Cindragosa
          if power>75 and tarDist<=5 then
            if castSpell(thisUnit5,_BreathOfCindragosa,false,false,false) then return end
          end
          ----------------------------
          --- Boss Multiple Target ---
          ----------------------------
          if isBoss() and bocRemain>0 then
        -- Howling Blast
            if fRunes>=1 and tarDist<=30 then
              if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
            end
        -- Blood Tap
            if bcStack>10 and tarDist<=5 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Death and Decay
            if uRunes==1 and tarDist<=30 then
              if castGround(thisUnit30AoE,_DeathAndDecay,30) then return end
            end
        -- Plague Strike
            if uRunes==2 and tarDist<=5 then
              if castSpell(thisUnit5,_PlagueStrike,false,false,false) then return end
            end
        -- Blood Tap
            if bcStack>0 and tarDist<=5 then
              if castSpell("player",_BloodTap,true,false,false) then return end
            end
        -- Plague Leech
            if bpRemain>0 and ffRemain>0 and tarDist<=30 then
              if castSpell(thisUnit5,_PlagueLeech,true,false,false) then return end
            end
        -- Plague Strike
            if uRunes==1 and tarDist<=5 then
              if castSpell(thisUnit5,_PlagueStrike,false,false,false) then return end
            end
        -- Empower Rune Weapon
            if isChecked("Empower Rune Weapon") and useCDs() and tarDist<=5 then
              if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
            end
          end
      -- Howling Blast
          if fRunes>=1 and tarDist<=30 then
            if castSpell(thisUnit5,_HowlingBlast,false,false,false) then return end
          end
      -- Blood Tap
          if bcStack>10 and tarDist<=5 then
            if castSpell("player",_BloodTap,true,false,false) then return end
          end
      -- Frost Strike
          if power>88 and tarDist<=5 then
            if castSpell(thisUnit5,_FrostStrike,true,false,false) then return end
          end
      -- Death and Decay
          if uRunes==1 and tarDist<=30 then
            if castGround(thisUnit30AoE,_DeathAndDecay,30) then return end
          end
      -- Plague Strike
          if uRunes==2 and tarDist<=5 then
            if castSpell(thisUnit5,_PlagueStrike,false,false,false) then return end
          end
      -- Blood Tap
          if bcStack>0 and tarDist<=5 then
            if castSpell("player",_BloodTap,true,false,false) then return end
          end
      -- Frost Strike
          if (not cindragosa or bocCooldown>=10) and tarDist<=5 then
            if castSpell(thisUnit5,_FrostStrike,true,false,false) then return end
          end
      -- Plague Leech
          if bpRemain>0 and ffRemain>0 and tarDist<=30 then
            if castSpell(thisUnit5,_PlagueLeech,true,false,false) then return end
          end
      -- Plague Strike
          if uRunes==1 and tarDist<=5 then
            if castSpell(thisUnit5,_PlagueStrike,false,false,false) then return end
          end
      -- Empower Rune Weapon
          if isChecked("Empower Rune Weapon") and useCDs() and tarDist<=5 then
            if castSpell("player",_EmpowerRuneWeapon,true,false,false) then return end
          end
        end
      end --In Combat End
  -- Start Attack
      if UnitExists(dynamicTarget(5,true)) and not stealth and isInCombat("player") and profileStop==false and tarDist<=5 then
        StartAttack()
      end
    end
  end -- FrostDK() end
end -- Class Select end
if select(3, UnitClass("player")) == 4 then
  function CombatRogue()
    if Currentconfig ~= "Combat Defmaster" and rogueCombat == nil then
      rogueCombat = cCombat:new()
      setmetatable(rogueCombat, {__index = cCombat})
      CombatToggles()
      CombatOptions()
      rogueCombat:updateOOC()
      rogueCombat:update()
      Currentconfig = "Combat Defmaster"
    end
    -- ToDo add pause toggle
    -- Manual Input
    if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true
    end
    if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
      return true
    end
    if IsLeftAltKeyDown() then
      return true
    end
    
    if not UnitAffectingCombat("player") then
      rogueCombat:updateOOC()
    end
    rogueCombat:update()

    --[[
    -- --------------
    -- --- Locals ---
    -- --------------
    local kilRemain = getBuffRemain("player",_KillingSpree)
    local deeRemain = getBuffRemain("player",84747) --Deep Insight 30% buff
    local enemies = #getEnemies("player",8)
    local thisUnit = dynamicTarget(5,true)
    local tarDist = getDistance("target","player")
    local hasTarget = UnitExists(thisUnit)
    local hasMouse = UnitExists("mouseover")
    local level = UnitLevel("player")
    local php = getHP("player")
    local thp = getHP(thisUnit)
    local combo = getCombo()
    local power = getPower("player")
    local powmax = UnitPowerMax("player")
    local powgen = getRegen("player")
    local ttd = getTimeToDie(thisUnit)
    local ttm = getTimeToMax("player")
    local deadtar = UnitIsDeadOrGhost(thisUnit)
    local attacktar = canAttack("player", thisUnit)
    local swimming = IsSwimming()
    local stealth = getBuffRemain("player",_Stealth)~=0
    local lethalRemain = getBuffRemain("player",157584)
    local nonlethalRemain = getBuffRemain("player",_CripplingPoison)
    local recRemain = getBuffRemain("player",_Recuperate)
    local sapRemain = getDebuffRemain(thisUnit,_Sap)
    local vanRemain = getBuffRemain("player",_VanishBuff)
    local revRemain = getDebuffRemain(thisUnit,_RevealingStrike,"player")
    local sndRemain = getBuffRemain("player",_SliceAndDice)
    local ctRemain = getDebuffRemain(thisUnit,_CrimsonTempest,"player")
    local revDuration = getDebuffDuration(thisUnit,_RevealingStrike,"player")
    local dfaRemain = getBuffRemain("player",_DeathFromAbove)
    --local adrRemain = getbuffRemain("player",13750)
    local cdRush = getSpellCD(_AdrenalineRush)
    local ddRemain = getDebuffRemain(thisUnit,113780,"player")
    local antCharge = getCharges(_Anticipation)
    local lootDelay = getValue("LootDelay");


    -----------------------------
    --- Blade Freaking Flurry ---
    -----------------------------

    --Blade Flurry aoe on pita
    if enemies >1 and not UnitBuffID("player",13877) then
      if castSpell("player",_BladeFlurry) then return; end
    end
    -- Blade Flurry aoe off (hope this works right)
    if enemies <2 and UnitBuffID("player",13877) and getSpellCD(_BladeFlurry)==0 then
      if castSpell("player",_BladeFlurry) then return; end
    end

    ----------------------------------
    --- Poisons/Healing/Dispelling ---
    ----------------------------------

    if (isCastingSpell(_InstantPoison) and lethalRemain>5) or ((isCastingSpell(_LeechingPoison) and nonlethalRemain>5)) then
      RunMacroText("/stopcasting")
    end
    -- Lethal Poison
    if isChecked("Lethal") and lethalRemain<5 and getBuffRemain("player",2823)<5 and not isMoving("player") and not castingUnit("player") and not IsMounted() then
      if castSpell("player",2823,true,true) then return end --The casting spell id is different
    end
    -- Non-Lethal Poison
    if isChecked("Non-Lethal") and nonlethalRemain<5 and not isMoving("player") and not castingUnit("player") and not IsMounted() then
      if castSpell("player",_CripplingPoison,true,true) then return end
    end
    -- Recuperate
    if php < 25 and recRemain==0 and combo>0 then
      if castSpell("player",_Recuperate,true,false,false) then return end
    end
    -- Cloak of Shadows
    if canDispel("player") then
      if castSpell("player",_CloakOfShadows,true,false,false) then return end
    end
    -- Pause
    if pause() then
      return true
    else

      -------------
      --- Buffs ---
      -------------

      -- Flask / Crystal
      if isChecked("Flask / Crystal") then
        if (select(2,IsInInstance())=="raid" or select(2,IsInInstance())=="none") and not UnitBuffID("player",105689) then
          if not UnitBuffID("player",127230) and canUse(86569) then
            UseItemByName(tostring(select(1,GetItemInfo(86569))))
          end
        end
      end

      ------------------
      --- Defensives ---  Should I add Feint, Cloak and smoke bomb? Feint aoe dmg reduction, cloak spell dmg immune for large boss dmg
      ------------------  smoke bomb prob to situational..it's a raid def cooldown, targeted ability cancel and easy way to pull ranged in.

      if useDefensive() and not stealth then
        -- Evasion  Physical def cooldown waste to use on magic dmg... can we check dmg recieved? magic or physical
        if php<50 then
          if castSpell("player",_Evasion,true,false,false) then return end
        end
        -- Combat Readiness Physical def cooldown This is wasted if magic dmg
        if php<40 then
          if castSpell("player",_CombatReadiness,true,false,false) then return end
        end
        -- Recuperate add slider to change %
        if php<30 and combo>3 and recRemain==0 then
          if castSpell("player",_Recuperate) then return end
        end
        -- Vanish
        if isChecked("Vanish") and php<15 then
          if castSpell("player",_Vanish) then StopAttack(); ClearTarget(); return end
        end
      end
      -- Most defensive should be player controlled imo unless dmg type can be used
      ---------------------
      --- Out of Combat ---
      ---------------------

      if not (IsMounted() or IsFlying() or UnitIsFriend("target","player")) then
        -- Stealth
        if not isInCombat("player") and isChecked("Stealth") and (stealthTimer == nil or stealthTimer <= GetTime()-getValue("Stealth Timer")) and getCreatureType("target") == true and not stealth then
          -- Always
          if getValue("Stealth") == 1 then
            if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
          end
          -- Pre-Pot
          if getValue("Stealth") == 2 and getBuffRemain("player",105697) > 0 and tarDist < 20 then
            if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
          end
          -- 20 Yards
          if getValue("Stealth") == 3 and tarDist < 20 then
            if castSpell("player",_Stealth,true,false,false) then stealthTimer=GetTime(); return end
          end
        end


        -- Shadowstep
        if not isInCombat("player") and stealth and tarDist < 25 and tarDist >= 8 and level>=60 and getTalent(4,2) then
          if castSpell("target",_Shadowstep,false,false,false) then return end
        end

        -- Cloak and Dagger Ambush
        if stealth and tarDist < 40 and tarDist >= 8 and level>=60 and getTalent(4,1) and (power>60 or (power>15 and getTalent(1,3))) then
          if castSpell("target",_Ambush,false,false,false) then return end
        end

        -- Ambush Main opener
        if not isInCombat("player") and not noattack() and UnitBuffID("player",_Stealth) and combo<=5 and (power>60 or (power>15 and getTalent(1,3))) then
          if castSpell("target",_Ambush,false,false,false) then return end
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
          if UnitExists("target") then
            if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
              StopAttack()
              ClearTarget()
              print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
            end
          end
        end

        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------

        if useInterrupts() and not stealth then
          -- Kick
          if level>=18 then
            if castInterrupt(_Kick,getValue("Interrupts")) then return end
          end

          -- Gouge
          if castInterrupt(_Gouge,getValue("Interrupts")) then return end

          -- Blind
          if castInterrupt(_Blind,getValue("Interrupts")) then return end
        end

        -----------------------------
        --- In Combat - Cooldowns ---
        -----------------------------

        if useCDs() and not stealth and tarDist<5 then
          -- Preparation
          if vanRemain==0 and getSpellCD(_Vanish)>60 then
            if castSpell("player",_Preparation,true,false,false) then return end
          end
          -- Vanish
          if isChecked("Vanish") and combo<5 and power<60 and getCombatTime()>10 then
            if castSpell("player",_Vanish,true,false,false) then return end
          end
          -- Adrenaline Rush
          if getSpellCD(_KillingSpree)>15 then
            if castSpell("player",_AdrenalineRush,true,false,false) then return end
          end
          -- Killing Spree
          if cdRush >5 or (revRemain>3 and sndRemain>4) then
            if castSpell(thisUnit,_KillingSpree,true,false,false) then return end
          end
        end

        ------------------------------------------
        --- In Combat Rotation ---
        ------------------------------------------

        -- Slice and Dice
        if sndRemain<5 and power>25 and tarDist<5 and combo>3 then
          if castSpell("player",_SliceAndDice,true,false,false) then return end
        end

        -- Revealing Strike
        if revRemain<3 and tarDist<5 then
          if castSpell("target",_RevealingStrike,false,false) then return; end
        end

        -- Marked for Death
        if combo<=2 and getTalent(6,2) then
          if castSpell(thisUnit,_MarkedForDeath,true,false,false) then return end
        end

        -- Crimson Tempest
        if useAoE() and combo>4 and enemies>=5 and ctRemain<8 and power>35 and tarDist<5 then
          if castSpell(thisUnit,_CrimsonTempest,true,false,false) then return end
        end

        -- Death From Above
        if power>50 and getTalent(7,3) then
          if castSpell("target",_DeathFromAbove,false,false,false) then return end
        end

        -- Deep Insight Early finisher w/ 30% dmg buff
        if combo>=4 and deeRemain >=1 then
          if castSpell(thisUnit,_Eviscerate,false,false,false) then return end
        end

        -- Eviscerate
        if combo>4 and power>35 then
          if castSpell("target",_Eviscerate,false,false,false) then return end
        end

        -- Combo point builder
        if combo<5 and power>=70 then
          if castSpell("target",_SinisterStrike,true) then return; end
        end

      end --In Combat End
      -- Start Attack
      if tarDist<5 and not stealth then
        StartAttack()
      end 
    end]] -- Pause End
  end --Rogue Function End
end --Class Check End

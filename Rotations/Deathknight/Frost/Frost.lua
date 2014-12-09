if select(3, UnitClass("player")) == 6 then
  function FrostDK()
    if currentConfig ~= "Frost Chumii" then
      FrostOptions();
      FrostToggles();
      currentConfig = "Frost Chumii";
    end
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
    local tarDist = getDistance("target")
    local friendly = UnitIsFriend("target", "player")
    local thp = getHP("target")
    local ttd = getTimeToDie("target")
    -- Specific Player Variables
    local rRemain = getBuffRemain("player",_Rime)
    --Specific Target Variables
    local ffRemain = getDebuffRemain("target",_FrostFever,"player")
    local bpRemain = getDebuffRemain("target",_BloodPlague,"player")
--------------------------------------------------
--- Ressurection/Dispelling/Healing/Pause/Misc ---
--------------------------------------------------
  -- Profile Stop
    if isInCombat("player") and profileStop==true then
      return true
    else
      profileStop=false
    end

  -- Death DK mode
    -- if isChecked("Death DK Mode") then

    -- end
  -- Pause
    if pause() then
      return true
    elseif not pause() then--isChecked("Death DK Mode") then
-------------
--- Buffs ---
-------------
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
      -- if useDefensive() then

      -- end
---------------------
--- Out of Combat ---
---------------------
      if hastar and attacktar and not isInCombat("player") 
        and ((not (IsMounted() or IsFlying() or friendly)) or isDummy()) 
      then

      end
-----------------
--- In Combat ---
-----------------
      if isInCombat("player") then
        if castSpell("player",cf,true,false,false) then return end
      end
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
        -- if useInterrupts() then

        -- end
  -----------------------------
  --- In Combat - Cooldowns ---
  -----------------------------
        -- if useCDs() and UnitExists(dynamicTarget(5,true)) then

        -- end
  ------------------------------------------
  --- In Combat Rotation ---
  ------------------------------------------
      --Frost Fever
        if ffRemain<3 and (getFrost()>=1 or getDeath()>=1) then
          if castSpell("target",_HowlingBlast,true,false,false) then return end
        end
      --Blood Plague
        if bpRemain<3 and (getUnholy()>=1 or getDeath()>=1) then
          if castSpell("target",_PlagueStrike,true,false,false) then return end
        end
      --Obliterate
        if (getFrost()==2 or getDeath()==2) and (getUnholy()==2 or getDeath()==2) then
          if level<58 then
            if castSpell("target",_HowlingBlast,true,false,false) then return end
          else
            if castSpell("target",_Obliterate,true,false,false) then return end
          end
        end
      --Frost Strike
        if power>40 then
          if castSpell("target",_FrostStrike,false,false,false) then return end
        end
      --Howling Blast
        if rRemain>0 then
          if castSpell("target",_HowlingBlast,true,false,false) then return end
        end
      --Plague Leech
        if bpRemain>0 and ffRemain>0 and getFrost()<2 and getUnholy()<2 then
          if castSpell("player",_PlagueLeech,true,false,false) then return end
        end
      end --In Combat End
  -- Start Attack
      if UnitExists(dynamicTarget(5,true)) and not stealth and isInCombat("player") and cat and profileStop==false then
        StartAttack()
      end
    end
  end -- FrostDK() end
end -- Class Select end
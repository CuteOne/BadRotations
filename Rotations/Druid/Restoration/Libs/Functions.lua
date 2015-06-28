if select(3, UnitClass("player")) == 11 then
  -- SwiftMender
  function SwiftMender(lowestUnit,lowestHP)
    if isChecked("Swiftmend") and getSpellCD(18562) < 1 then
      if lowestHP <= getValue("Swiftmend") then
        if (getBuffRemain(lowestUnit,774,"player") > 1 or getBuffRemain(lowestUnit,8936,"player") > 1) then
          CastSpellByName(GetSpellInfo(18562),lowestUnit)
          return true
        end
      end
    end
  end

  function findShroom()
    if shroomsTable[1].x == nil then
      local myShroom = shroomsTable[1].guid
      for i = 1, GetObjectCountBB() do
        if GetObjectExists(GetObjectIndex(i)) == true then
          --print(UnitGUID(ObjectWithIndex(i)))
          if shroomsTable[1].guid == UnitGUID(GetObjectIndex(i)) then
            X, Y, Z = GetObjectPosition(GetObjectIndex(i))
            -- print("lol")
            shroomsTable[1] = { x = X, y = Y, z = Z, guid = myShroom }
            return true
          end
        end
      end
    else
      return true
    end
    return false
  end

  -- select(2,DruidCastTime()) > 2
  function DruidCastTime()
    local castDuration = 0
    local castTimeRemain = 0

    if select(6,UnitCastingInfo("player"))  then
      castStartTime = select(5,UnitCastingInfo("player"))
      castEndTime = select(6,UnitCastingInfo("player"))
    else
      castStartTime = 0
      castEndTime = 0
    end
    if castEndTime > 0 and castStartTime > 0 then
      castDuration = (castEndTime - castStartTime)/1000
      castTimeRemain = ((castEndTime/1000) - GetTime())
    else
      castDuration = 0
      castTimeRemain = 0
    end
    if castDuration and castTimeRemain  then
      return castDuration,castTimeRemain
    end
  end

  function isCastingDruid(Unit)
    if Unit == nil then
      Unit = "player"
    end
    if UnitCastingInfo(Unit) ~= nil or UnitChannelInfo(Unit) ~= nil
      or (GetSpellCooldown(61304) ~= nil and GetSpellCooldown(61304) > 0.001) then
      return true
    else
      return false
    end
  end

  function castMushFocus()
    if UnitExists("focus") and UnitAffectingCombat("focus") and UnitExists("focustarget")
      and UnitAffectingCombat("focus") and getDistance("focus","focustarget") < 5 then
      if castSpell("focus",145205,true,false) then
        return
      end
    end
  end

  function dpsRestoDruid()
    if isChecked("DPS Toggle") == true and SpecificToggle("DPS Toggle") == true  then
      -- Let's get angry :D
      makeEnemiesTable(40)
      if UnitExists("target") == true and UnitCanAttack("target","player") == true then
        myTarget = "target"
        myDistance = targetDistance
      elseif enemiesTable and enemiesTable[1] ~= nil then
        myTarget = enemiesTable[1].unit
        myDistance = enemiesTable[1].distance
      else
        myTarget = "target"
      end
      if UnitExists(myTarget) and UnitCanAttack(myTarget,"player") == true then
        if myDistance < 5 and not isChecked("No Kitty DPS") then
          --- Catform
          if not UnitBuffID("player",768) and not UnitBuffID("player",783) and not UnitBuffID("player",5487) then
            if castSpell("player",768,true,false) then
              catSwapped = GetTime()
              return
            end
          end
          if UnitBuffID("player",768) and catSwapped <= GetTime() - 1.5 then
            -- Ferocious Bite
            if getCombo() == 5 and UnitBuffID("player",768) ~= nil then
              if castSpell(myTarget,22568,false,false) then
                return
              end
            end
            -- Trash
            if getDebuffRemain(myTarget,106830) < 2 then
              if castSpell("player",106832,false,false) then
                return
              end
            end
            -- Shred
            if castSpell(myTarget,5221,false,false) then
              return
            end
          end
        else
          if UnitBuffID("player",768) ~= nil then
            CancelShapeshiftForm()
          end
          -- Moonfire
          if isChecked("Multidotting") and isChecked("MoonFire") then
            castDotCycle("all",8921,40,false,false,2)
          end

          if isStanding(0.1) == false then
            -- MonFire Spam
            if castSpell(myTarget,_Moonfire,false,false) then
              return
            end
          else
            -- if we dont have DoC then dot our target
            if not isKnown(158504) and isChecked("MoonFire")then
              if getDebuffRemain(myTarget,164812) < 2 then
                if castSpell(myTarget,_Moonfire,false,false) then
                  return
                end
              end
            end
            -- Wrath
            if castSpell(myTarget,5176,false,true) then
              return
            end
          end
        end
      end
    else
      if UnitBuffID("player",768) ~= nil then
        CancelShapeshiftForm()
      end
    end
  end

end

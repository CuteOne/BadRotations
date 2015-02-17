if select(3,UnitClass("player")) == 6 then
  local playerSpec = GetSpecialization()
  if playerSpec == 3 then
    -----------------------
    --- Bloodlust check ---
    -----------------------
    function hasLust()
      if UnitBuffID("player",2825)        -- Bloodlust
        or UnitBuffID("player",80353)       -- Timewarp
        or UnitBuffID("player",32182)       -- Heroism
        or UnitBuffID("player",90355) then  -- Ancient Hysteria
        return true
      else
        return false
      end
    end
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
            table.insert( members,{ Unit = unit, HP = hp } )
            if hp < 90 then group.low = group.low + 1 end
            if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
          end
        end
        if group.type == "raid" and #members > 1 then table.remove(members,1) end
        table.sort(members, function(x,y) return x.HP < y.HP end)
      end
    end

    function getRuneInfo()
      local bCount = 0
      local uCount = 0
      local fCount = 0
      local dCount = 0
      local bPercent = 0
      local uPercent = 0
      local fPercent = 0
      local dPercent = 0
      if not runeTable then
        runeTable = {}
      else
        table.wipe(runeTable)
      end
      for i = 1,6 do
        local CDstart = select(1,GetRuneCooldown(i))
        local CDduration = select(2,GetRuneCooldown(i))
        local CDready = select(3,GetRuneCooldown(i))
        local CDrune = CDduration-(GetTime()-CDstart)
        local CDpercent = CDpercent
        local runePercent = 0
        local runeCount = 0
        local runeCooldown = 0
        if CDrune > CDduration then
          CDpercent = 1-(CDrune/(CDduration*2))
        else
          CDpercent = 1-CDrune/CDduration
        end
        if not CDready then
          runePercent = CDpercent
          runeCount = 0
          runeCooldown = CDrune
        else
          runePercent = 1
          runeCount = 1
          runeCooldown = 0
        end
        if GetRuneType(i) == 4 then
          dPercent = runePercent
          dCount = runeCount
          dCooldown = runeCooldown
          table.insert( runeTable,{ Type = "death", Index = i, Count = dCount, Percent = dPercent, Cooldown = dCooldown})
        end
        if GetRuneType(i) == 1 then
          bPercent = runePercent
          bCount = runeCount
          bCooldown = runeCooldown
          table.insert( runeTable,{ Type = "blood", Index = i, Count = bCount, Percent = bPercent, Cooldown = bCooldown})
        end
        if GetRuneType(i) == 2 then
          uPercent = runePercent
          uCount = runeCount
          uCooldown = runeCooldown
          table.insert( runeTable,{ Type = "unholy", Index = i, Count = uCount, Percent = uPercent, Cooldown = uCooldown})
        end
        if GetRuneType(i) == 3 then
          fPercent = runePercent
          fCount = runeCount
          fCooldown = runeCooldown
          table.insert( runeTable,{ Type = "frost", Index = i, Count = fCount, Percent = fPercent, Cooldown = fCooldown})
        end
      end
    end

    function getRunes(Type)
      Type = string.lower(Type)
      local runeCount = 0
      local runeTable = runeTable
      for i = 1, 6 do
        if runeTable[i].Type == Type then
          runeCount = runeCount + runeTable[i].Count
        end
      end
      return runeCount
    end

    function getRunePercent(Type)
      Type = string.lower(Type)
      local runePercent = 0
      local runeCooldown = 0
      local runeTable = runeTable
      for i = 1, 6 do
        if runeTable[i].Type == Type and runeTable[i].Cooldown > runeCooldown then
          runePercent = runeTable[i].Percent
          runeCooldown = runeTable[i].Cooldown
        end
      end
      if getRunes(Type)==2 then
        return 2
      elseif getRunes(Type)==1 then
        return runePercent+1
      else
        return runePercent
      end
    end

    function useAoE()
      if (BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 2) or BadBoy_data['AoE'] == 2 then
        -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
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

    function useDefile()
      if BadBoy_data['Defile']==1 then
        return true
      else
        return false
      end
    end

    SLASH_DEFILE1 = '/defile';
    function SlashCmdList.DEFILE(msg, editbox)
      RunMacroText('/run _G["buttonDefile"]:Click()');
    end


    function getDisease(range,aoe,mod)
      if mod == nil then mod = "min" end
      if range == nil then range = 5 end
      local range = tonumber(range)
      local mod = tostring(mod)
      if aoe == nil then aoe = false end
      local dynTar = dynamicTarget(range,true)
      local dynTarAoE = dynamicTarget(range,false)
      local dist = getDistance("player",dynTar)
      local distAoE = getDistance("player",dynTarAoE)
      local ff = getDebuffRemain(dynTar,_FrostFever,"player")
      local ffAoE = getDebuffRemain(dynTarAoE,_FrostFever,"player")
      local bp = getDebuffRemain(dynTar,_BloodPlague,"player")
      local bpAoE = getDebuffRemain(dynTarAoE,_BloodPlague,"player")
      local np = getDebuffRemain(dynTar,_NecroticPlague,"player")
      local npAoE = getDebuffRemain(dynTarAoE,_NecroticPlague,"player")
      if mod == "min" then
        if aoe == false then
          if dist < range then
            if getTalent(7,1) then
              return np
            elseif ff <= bp then
              return ff
            else
              return bp
            end
          else
            return 99
          end
        elseif aoe == true then
          if distAoE < range then
            if getTalent(7,1) then
              return npAoE
            elseif ffAoE <= bpAoE then
              return ffAoE
            else
              return bpAoE
            end
          else
            return 99
          end
        end
      elseif mod == "max" then
        if aoe == false then
          if dist < range then
            if getTalent(7,1) then
              return np
            elseif ff <= bp then
              return bp
            else
              return ff
            end
          else
            return 0
          end
        elseif aoe == true then
          if distAoE < range then
            if getTalent(7,1) then
              return npAoE
            elseif ffAoE <= bpAoE then
              return bpAoE
            else
              return ffAoE
            end
          else
            return 90
          end
        end
      end
    end


    function FSCount()
      local ubStart, ubDuration, ubEnabled = GetSpellCooldown(115989)
      local ubReadyAt = ubStart > 0 and (ubStart + ubDuration) or GetTime()
      local npDuration, npExpires = select(6, UnitDebuff("target", "Necrotic Plague", nil, "player"))
      local npCount = npExpires and (math.max(ubReadyAt - npExpires) / 6) or 0
      return math.floor(0.5+npCount)
    end

    ---- Opener

    function unholyOpener()

      local GCD = 1.5/(1+UnitSpellHaste("player")/100)

      if unholyOpenerEvents == nil then
        -- Initialize
        RegisterCVar("startopener", 0)
        RegisterCVar("resetopener", 0)
        openerstarted = false
        opone = true
        optwo = true
        opthree = true
        opfour = true
        opfive = true
        opsix = true
        opseven = true
        opeight = true
        opnine = true
        unholyOpenerEvents = true
        print("|cffC41F3BUnholy Opener Variables Loaded")
      end

      SLASH_uhopener1 = "/uhopener"
      function SlashCmdList.uhopener(msg, editbox)
        SetCVar("startopener", 1)
        print("|cffC41F3BOpener started!")
      end

      SLASH_uhopenerreset1 = "/uhopenerreset"
      function SlashCmdList.uhopenerreset(msg, editbox)
        SetCVar("resetopener", 1)
      end

      if tonumber(GetCVar("startopener")) == 1 and getSpellCD(_SummonGargoyle) > 0 then
        SetCVar("resetopener", 1)
        SetCVar("startopener", 0)
        print("|cffC41F3BSummon Gargoyle is not ready - Opener stopped!")
      end

      if tonumber(GetCVar("startopener")) == 1 and getSpellCD(_ArmyOfTheDead) > 0 then
        SetCVar("resetopener", 1)
        SetCVar("startopener", 0)
        print("|cffC41F3BArmy of the Dead is not ready - Opener stopped!")
      end

      if tonumber(GetCVar("startopener")) == 1 and not canUse(109219) then
        SetCVar("resetopener", 1 )
        SetCVar("startopener", 0 )
        print("|cffC41F3BYou must have potions to start the opener!")
      end

      if tonumber(GetCVar("startopener")) == 1 and not UnitExists("target") then
        SetCVar("resetopener", 1 )
        SetCVar("startopener", 0 )
        print("|cffC41F3BYou must have a target to start the opener!")
      end

      if tonumber(GetCVar("resetopener")) == 1 then
        SetCVar("resetopener", 0 )
        openerstarted = false
        opone = true
        optwo = true
        opthree = true
        opfour = true
        opfive = true
        opsix = true
        opseven = true
        opeight = true
        opnine = true
        print("|cffC41F3BOpener resetted sucessfully!")
      end

      if tonumber(GetCVar("startopener")) == 1 then
        SetCVar("startopener", 0)
        openerstarted = true
        opone = false
        optwo = false
        opthree = false
        opfour = false
        opfive = false
        opsix = false
        opseven = false
        opeight = false
        opnine = false
      end

      if not openerstarted then return false end
      if UnitChannelInfo("player") then return true end
      if UnitCastingInfo("player") then return true end

      -- 1. Army of the Dead 6s before pull
      -- 2. Pre-pot
      -- 3. Deaths Advance
      -- 4. Summon Gargoyle
      -- 5. Outbreak
      -- 6. Festering Strike x1
      -- 7. Defile if the target will remain in the ground effect for 5 ticks or more, otherwise use Scourge Strike
      -- 8. Festering Strike x1
      -- 9. Scourge Strike unless Defile was not used.
      -- 10. If you have GCDs to fill (i.e. you will not cap runes), you can use Plague Leech here to gain a rune. Simply apply diseases first with Plague Strike and then Scourge Strike the second rune gained. Under Heroism/Bloodlust, this is not ideal as you will cap runes.

      if not opone and canCast(_ArmyOfTheDead) then
        CastSpellByName(tostring(GetSpellInfo(42650)),"player")
        print("|cffC41F3B1: Army of the Dead")
        delay = GetTime()
        opone = true
        return
      elseif not optwo and opone and canUse(109219) then
        --DELAY 4 seconds
        if delay == nil or delay <= GetTime() - 4 then
          UseItemByName(tostring(select(1,GetItemInfo(109219))))
          print("|cffC41F3B2: Pre-Pot")
          optwo = true
          return
        end
      elseif not opthree and optwo and canCast(_DeathAdvance) then
        --DELAY 4 seconds
        if delay == nil or delay <= GetTime() - 4 then
          CastSpellByName(tostring(GetSpellInfo(96268)),"player")
          print("|cffC41F3B3: Death Advance")
          opthree = true
          return
        end
      elseif not opfour and opthree and canCast(_SummonGargoyle) then
        if delay == nil or delay <= GetTime() - 4 then
          CastSpellByName(tostring(GetSpellInfo(49206)),"target")
          print("|cffC41F3B4: Summon Gargoyle")
          delay = GetTime()
          opfour = true
          return
        end
      elseif not opfive and opfour and canCast(_Outbreak) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(77575)),"target")
          print("|cffC41F3B5: Outbreak")
          delay = GetTime()
          opfive = true
          return
        end
      elseif not opsix and opfive and canCast(_FesteringStrike) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(85948)),"target")
          print("|cffC41F3B6: Festering Strike")
          delay = GetTime()
          opsix = true
          return
        end
      elseif not opseven and opsix and canCast(_ScourgeStrike) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(55090)),"target")
          print("|cffC41F3B7: Scourge Strike")
          delay = GetTime()
          opseven = true
          return
        end
      elseif not opeight and opseven and canCast(_FesteringStrike) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(85948)),"target")
          print("|cffC41F3B8: Festering Strike")
          delay = GetTime()
          opeight = true
          return
        end
      elseif not opnine and opeight and canCast(_ScourgeStrike) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(55090)),"target")
          print("|cffC41F3B9: Scourge Strike")
          delay = GetTime()
          opnine = true
          return
        end
      end

      if opone and optwo and opthree and opfour and opfive and opsix and opseven and opeight and opnine then
        SetCVar("startopener", 0 )
        SetCVar("resetopener", 1 )
        openerstarted = false
      end

      if openerstarted then return end



    end -- end unholyOpener()

    function openerdump()
      return openerstarted
    end





  end
end

if select(3, UnitClass("player")) == 11 then
  function MoonkinFunctions()

    -- Spell List
    _barkskin           = 22812
    _celestialAlignment = 112071
    _forceOfNature      = 33831
    _healingTouch       = 5185
    _incarnationboom    = 102560
    _markOfTheWild      = 1126
    _moonfire           = 8921
    _moonkinForm        = 24858
    _naturesVigil       = 124974
    _rejuvenation       = 774
    _solarBeam          = 78675
    _starfall           = 48505
    _starfire           = 2912
    _starsurge          = 78674
    _stellarFlare       = 152221
    _sunfire            = 93402
    _wrath              = 5176
    _moonfiredebuff = 164812
    _sunfiredebuff = 164815

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

    function hasfox()
      if UnitBuffID("player",172106) then
        return true
      else
        return false
      end
    end

    function sunfireremain(unit)
      local sfremain = getDebuffRemain(unit,164815,"player")
      return sfremain
    end
    function moonfireremain(unit)
      local mfremain = getDebuffRemain(unit,164812,"player")
      return mfremain
    end

    function dumpsfremain()
      return sunfireremain("target")
    end

    function dumpmfremain()
      return moonfireremain("target")
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

    function useBoomAoE()
      if (BadBoy_data['AoE'] == 2 and #getEnemies("player",40) >= 2) then
        -- if BadBoy_data['AoE'] == 1 or BadBoy_data['AoE'] == 2 then
        return true
      else
        return false
      end
    end

    function useBoomCDs()
      if BadBoy_data['MoonCooldowns'] == 2 and (isBoss() or isDummy("target")) then
        return true
      else
        return false
      end
    end

    function useBoomDef()
      if BadBoy_data['MoonDefensive'] == 2 then
        return true
      else
        return false
      end
    end

    function useStarfall()
      if BadBoy_data['Starfall'] == 1 then
        return true
      else
        return false
      end
    end

    function useMultidot()
      if BadBoy_data['Multidot'] == 1 then
        return true
      else
        return false
      end
    end

    function eclipseChangeTimer()
      local peakTimer
      local eclipsePosition
      local eclipseTimers
      local moon
      local currentPowerTime
      local extraTimer

      if GetEclipseDirection() == 'moon' then
          moon = true
      else
          moon = false
      end

      eclipsePosition = UnitPower('player',SPELL_POWER_ECLIPSE)
      currentPowerTime = math.asin(UnitPower('player', SPELL_POWER_ECLIPSE)/105)/math.pi*20
      peakTimer = math.asin(100/105)/math.pi*20
      extraTimer =( math.asin(105/105)/math.pi*20 - peakTimer)*2

      if moon and eclipsePosition > 0 then
          eclipseTimers = abs(currentPowerTime)
      elseif moon and eclipsePosition < 0 then
          eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
      elseif not moon and eclipsePosition < 0 then
          eclipseTimers = abs(currentPowerTime)
      else
          eclipseTimers = 20 - abs(currentPowerTime) - peakTimer-extraTimer
      end

      return (eclipseTimers/2)
    end

    -- Sunfire check
    function getSunfireStatus()
      if select(3,GetSpellInfo(_moonfire)) == select(3,GetSpellInfo(_sunfire)) then
        return true
      else
        return false
      end
    end

    function castSunfireCycle(units,duration)
      local units = units
      -- unit can be "all" or numeric
      if type(units) == "number" then
        units = units
      else
        units = 100
      end
      duration = duration or 1
      -- cycle our units if we want MORE DOTS
      if getDebuffCount(164815) < units then
        for i = 1, #enemiesTable do
          local thisUnit = enemiesTable[i]
          if thisUnit.isCC == false and UnitLevel(thisUnit.unit) < UnitLevel("player") + 5 then
            local dotRemains = getDebuffRemain(thisUnit.unit,164815,"player")
            if dotRemains < duration then
              if castSpell(thisUnit.unit,_moonfire,false,false) then
                return true
              end
            end
          end
        end
      end
    end

    function boomOpener()

      local GCD = 1.5/(1+UnitSpellHaste("player")/100)
      local starfirect = (select(4, GetSpellInfo(2912))/1000)
      local wrathct = (select(4, GetSpellInfo(5176))/1000)

      if boomOpenerEvents == nil then
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
        opten = true
        opeleven = true
        optwelve = true
        opthirt = true
        opfourt = true
        opfift = true
        opsixt = true
        opsevent = true
        opeightt = true
        opninet = true
        boomOpenerEvents = true
        print("|cffFF7D0ABoomkin Opener Variables Loaded")
      end

      SLASH_boomopener1 = "/boomopener"
      function SlashCmdList.boomopener(msg, editbox)
        SetCVar("startopener", 1)
        print("|cffFF7D0AOpener started!")
      end

      SLASH_boomopenerreset1 = "/boomopenerreset"
      function SlashCmdList.boomopenerreset(msg, editbox)
        SetCVar("resetopener", 1)
      end

      if tonumber(GetCVar("startopener")) == 1 and not getTalent(4,2) then
        SetCVar("resetopener", 1)
        SetCVar("startopener", 0)
        print("|cffFF7D0AIncarnation not learned - Opener stopped!")
      end

      if tonumber(GetCVar("startopener")) == 1 and getSpellCD(_celestialAlignment) > 0 then
        SetCVar("resetopener", 1)
        SetCVar("startopener", 0)
        print("|cffFF7D0ACelestian Alignment is not ready - Opener stopped!")
      end

      if tonumber(GetCVar("startopener")) == 1 and not UnitExists("target") then
        SetCVar("resetopener", 1 )
        SetCVar("startopener", 0 )
        print("|cffFF7D0AYou must have a target to start the opener!")
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
        opten = true
        opeleven = true
        optwelve = true
        opthirt = true
        opfourt = true
        opfift = true
        opsixt = true
        opsevent = true
        opeightt = true
        opninet = true
        print("|cffFF7D0AOpener resetted sucessfully!")
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
        opten = false
        opeleven = false
        optwelve = false
        opthirt = false
        opfourt = false
        opfift = false
        opsixt = false
        opsevent = false
        opeightt = false
        opninet = false
      end

      if not openerstarted then return false end
      if UnitChannelInfo("player") then return true end
      if UnitCastingInfo("player") then return true end
      -- 1. Pre-Pot
      -- 2. Incarnation (if spec'd)
      -- 3. Celestial Alignment
      -- 4. MF (also applies SF)
      -- 5. Starsurge
      -- 6. Starfire
      -- 7. Starfire
      -- 8. Starsurge
      -- 9. Starfire
      -- 10. Starfire
      -- 11. Moonfire (if duration will fall off before returning to Lunar)
      -- 12. Starfire until you swap to Solar Eclipse side
      -- <enter solar eclipse>
      -- 13. Sunfire
      -- 14. Wrath until almost peak eclipse
      -- 15. Starsurge
      -- 16. Wrath
      -- 17. Wrath
      -- 18. Wrath
      -- 19. Sunfire (refresh before leaving Solar)
      if not opone and canUse(109218) then
        UseItemByName(tostring(select(1,GetItemInfo(109218))))
        print("|cffFF7D0A1: Pre-Pot")
        opone = true
        return
      elseif not optwo and opone and canCast(_incarnationboom) then
        CastSpellByName(tostring(GetSpellInfo(102560)),"player")
        RunMacroText("/use 13")
        RunMacroText("/use 14")
        print("|cffFF7D0A2: Incarnation + Trinkets")
        optwo = true
        return
      elseif not opthree and optwo and canCast(_celestialAlignment) then
        CastSpellByName(tostring(GetSpellInfo(112071)),"player")
        print("|cffFF7D0A3: Celestial Alignment")
        opthree = true
        delay = GetTime()
        return
      elseif not opfour and opthree and canCast(_moonfire) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(8921)),"target")
          print("|cffFF7D0A4: Moonfire")
          delay = GetTime()
          opfour = true
          return
        end
      elseif not opfive and opfour and canCast(_starsurge) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(78674)),"target")
          print("|cffFF7D0A5: Starsurge")
          delay = GetTime()
          opfive = true
          return
        end
      elseif not opsix and opfive and canCast(_starfire) then
        if delay == nil or delay <= GetTime() - starfirect then
          CastSpellByName(tostring(GetSpellInfo(2912)),"target")
          print("|cffFF7D0A6: Starfire")
          delay = GetTime()
          opsix = true
          return
        end
      elseif not opseven and opsix and canCast(_starfire) then
        if delay == nil or delay <= GetTime() - starfirect then
          CastSpellByName(tostring(GetSpellInfo(2912)),"target")
          print("|cffFF7D0A7: Starfire")
          delay = GetTime()
          opseven = true
          return
        end
      elseif not opeight and opseven and canCast(_starsurge) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(78674)),"target")
          print("|cffFF7D0A8: Starsurge")
          delay = GetTime()
          opeight = true
          return
        end
      elseif not opnine and opeight and canCast(_starfire) then
        if delay == nil or delay <= GetTime() - starfirect then
          CastSpellByName(tostring(GetSpellInfo(2912)),"target")
          print("|cffFF7D0A9: Starfire")
          delay = GetTime()
          opnine = true
          return
        end
      elseif not opten and opnine and canCast(_starfire) then
        if delay == nil or delay <= GetTime() - starfirect then
          CastSpellByName(tostring(GetSpellInfo(2912)),"target")
          print("|cffFF7D0A10: Starfire")
          delay = GetTime()
          opten = true
          return
        end
      elseif not opeleven and opten and canCast(_moonfire) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(8921)),"target")
          print("|cffFF7D0A11: Moonfire")
          delay = GetTime()
          opeleven = true
          return
        end
      elseif not optwelve and opeleven and canCast(_starfire) then
        if UnitPower("player",8) < 0 then
          CastSpellByName(tostring(GetSpellInfo(2912)),"target")
        elseif (UnitPower("player",8) < 0 and eclipseChangeTimer() < starfirect) or UnitPower("player",8) > 0 then
          if delay == nil or delay <= GetTime() - starfirect then
            CastSpellByName(tostring(GetSpellInfo(2912)),"target")
            print("|cffFF7D0A12: Starfire")
            delay = GetTime()
            optwelve = true
            return
          end
        end
      elseif not opthirt and optwelve and getSunfireStatus() and canCast(8921) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(8921)),"target")
          print("|cffFF7D0A13: Sunfire")
          delay = GetTime()
          opthirt = true
          return
        end
      elseif not opfourt and opthirt and canCast(_wrath) then
        if delay == nil or delay <= GetTime() - wrathct then
          CastSpellByName(tostring(GetSpellInfo(5176)),"target")
          print("|cffFF7D0A14: Wrath")
          delay = GetTime()
          opfourt = true
          return
        end
      elseif not opfift and opfourt and canCast(_starsurge) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(78674)),"target")
          print("|cffFF7D0A15: Starsurge")
          delay = GetTime()
          opfift = true
          return
        end
      elseif not opsixt and opfift and canCast(_wrath) then
        if delay == nil or delay <= GetTime() - wrathct then
          CastSpellByName(tostring(GetSpellInfo(5176)),"target")
          print("|cffFF7D0A16: Wrath")
          delay = GetTime()
          opsixt = true
          return
        end
      elseif not opsevent and opsixt and canCast(_wrath) then
        if delay == nil or delay <= GetTime() - wrathct then
          CastSpellByName(tostring(GetSpellInfo(5176)),"target")
          print("|cffFF7D0A17: Wrath")
          delay = GetTime()
          opsevent = true
          return
        end
      elseif not opeightt and opsevent and canCast(_wrath) then
        if UnitPower("player",8) < 0 then
          CastSpellByName(tostring(GetSpellInfo(5176)),"target")
        elseif (UnitPower("player",8) < 0 and eclipseChangeTimer() < starfirect) or UnitPower("player",8) > 0 then
          if delay == nil or delay <= GetTime() - wrathct then
            CastSpellByName(tostring(GetSpellInfo(5176)),"target")
            print("|cffFF7D0A18: Wrath")
            delay = GetTime()
            opeightt = true
            return
          end
        end
      elseif not opninet and opeightt and getSunfireStatus() and canCast(8921) then
        if delay == nil or delay <= GetTime() - GCD then
          CastSpellByName(tostring(GetSpellInfo(8921)),"target")
          print("|cffFF7D0A19: Sunfire")
          delay = GetTime()
          opninet = true
          return
        end
      end

      if opone and optwo and opthree and opfour and opfive
      and opsix and opseven and opeight and opnine and opten
      and opeleven and optwelve and opthirt and opfourt and opfift
      and opsixt and opsevent and opeightt and opninet then
        SetCVar("startopener", 0 )
        SetCVar("resetopener", 1 )
        openerstarted = false
      end

      if openerstarted then return end
    end -- end boomOpener()

  end -- MoonkinFunctions() end
end -- select Class end

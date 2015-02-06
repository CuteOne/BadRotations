if select(3, UnitClass("player")) == 5 then

  -- get threat situation on player and return the number
  function getThreat()
    if UnitThreatSituation("player") ~= nil then
      return UnitThreatSituation("player")
    end
    -- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
    -- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
    -- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
    -- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
    return 0
  end

  -- Check if SWP is on 3 units or if #enemiesTable is <3 then on #enemiesTable
  function getSWP()
    local counter = 0
    -- iterate units for SWP
    for i=1,#enemiesTable do
      local thisUnit = enemiesTable[i].unit
      -- increase counter for each SWP
      if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,SWP,"player") then
        counter=counter+1
      end
    end
    -- return counter
    return counter
  end

  function safeDoT(datUnit)
    local Blacklist = {
      "Volatile Anomaly",
      "Rarnok",
    }
    if Unit == nil then return true end
    for i = 1, #Blacklist do
      if UnitName(datUnit) == Blacklist[i] then
        return false
      end
    end
    return true
  end

  -- count all PoM of Player in Raid
  function getPoM(options)

  end


  --[[                    ]] -- General Functions end


  --[[                    ]] -- Defensives
  function ShadowDefensive(options)
    -- Shield
    if isChecked("PW: Shield") and (BadBoy_data['Defensive'] == 2) and options.player.php <= getValue("PW: Shield") then
      if castSpell("player",PWS,true,false) then return; end
    end

    -- Fade (Glyphed)
    if hasGlyph(GlyphOfFade) then
      if isChecked("Fade Glyph") and (BadBoy_data['Defensive'] == 2) and options.player.php <= getValue("Fade Glyph") then
        if castSpell("player",Fade,true,false) then return; end
      end
    end

    -- Fade (Aggro)
    if IsInRaid() ~= false then
      if isChecked("Fade Aggro") and BadBoy_data['Defensive']==2 and getThreat()>=3 then
        --if isChecked("Fade Aggro") and BadBoy_data['Defensive'] == 2 then
        if castSpell("player",Fade,true,false) then return; end
      end
    end

    -- Healthstone/HealPot
    if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and hasHealthPot() then
      if canUse(5512) then
        UseItemByName(tostring(select(1,GetItemInfo(5512))))
      elseif canUse(healPot) then
        UseItemByName(tostring(select(1,GetItemInfo(healPot))))
      end
    end

    -- Desperate Prayer
    if isKnown(DesperatePrayer) then
      if isChecked("Desperate Prayer") and (BadBoy_data['Defensive'] == 2) and options.player.php <= getValue("Desperate Prayer") then
        if castSpell("player",DesperatePrayer,true,false) then return; end
      end
    end
  end
  --[[                    ]] -- Defensives end


  --[[                    ]] -- Cooldowns
  function DisciplineCooldowns(options)
    -- Mindbender
    if isKnown(Mindbender) and options.buttons.Cooldowns == 2 and options.isChecked.Mindbender then
      if castSpell("target",Mindbender) then return; end
    end

    -- Shadowfiend
    if isKnown(SF) and options.buttons.Cooldowns == 2 and options.isChecked.Shadowfiend then
      if castSpell("target",SF,true,false) then return; end
    end

    -- -- Power Infusion
    -- if isKnown(PI) and options.buttons.Cooldowns == 2 and isChecked("Power Infusion") then
    -- 	if castSpell("player",PI) then return; end
    -- end

    -- Berserking (Troll Racial)
    if isKnown(Berserking) and options.buttons.Cooldowns == 2 and options.isChecked.Berserking then
      if castSpell("player",Berserking,true,false) then return; end
    end

    -- Halo
    if isKnown(Halo) and options.buttons.Halo == 2 then
      if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
        if castSpell("player",Halo,true,false) then return; end
      end
    end

    -- Trinket 1
    if options.isChecked.Trinket1 and options.buttons.Cooldowns == 2 and canTrinket(13) then
      RunMacroText("/use 13")
    end

    -- Trinket 2
    if options.isChecked.Trinket2 and options.buttons.Cooldowns == 2 and canTrinket(14) then
      RunMacroText("/use 14")
    end
  end
  --[[                    ]] -- Cooldowns end

end

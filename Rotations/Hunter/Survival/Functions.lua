if select(3, UnitClass("player")) == 3 then

  function AutoCallPet()
    if bb.data["Check Auto Call Pet"] ~= 1 then
      autoCallPetValue = 7;
    else
      --if tryWhistle == nil then tryWhistle = 0; end
      --[[ if (not UnitExists("pet") or UnitIsDeadOrGhost("pet")) and tryWhistle <= GetTime() then
        if GetUnitSpeed("player") == 0 then
            tryWhistle = (GetTime()+3);
            autoCallPetValue = 0;
            return;
        end
    end]]
      if (not UnitExists("pet") or UnitIsDeadOrGhost("pet")) then
        if bb.data["Box Auto Call Pet"] == 1 then
          autoCallPetValue = 1;
        elseif bb.data["Box Auto Call Pet"] == 2 then
          autoCallPetValue = 2;
        elseif bb.data["Box Auto Call Pet"] == 3 then
          autoCallPetValue = 3;
        elseif bb.data["Box Auto Call Pet"] == 4 then
          autoCallPetValue = 4;
        elseif bb.data["Box Auto Call Pet"] == 5 then
          autoCallPetValue = 5;
        end
      else
        autoCallPetValue = 6;
      end
    end
  end

  function Cooldowns()
    local bestialWrath = 19574;
    local rapidFire = 3045;
    local focusFire = 82692;
    local frenzyStacks = 19615;
    local killCommand = 34026;
    local beastWithin = 34471;
    -- Bestial Wrath
    if bb.data["Check Bestial Wrath"] == 1
      and GetSpellCD(bestialWrath) < 1
      and GetSpellCD(killCommand) < 2
      and (bb.data["Box Bestial Wrath"] and GetFocus() > bb.data["Box Bestial Wrath"]) then
      cooldownValue = 1;
    -- Focus Fire
    elseif bb.data["Check Focus Fire"] == 1
      and select(4,UnitBuffID("player",frenzyStacks)) == 5
      and not (UnitBuffID("player", beastWithin) and GetFocus() > 12)-- Not under Beast Within
      and GetSpellCD(killCommand) > 1 -- Kill Command CD over 1 sec
      and (GetSpellCD(bestialWrath) > 20 or bb.data["Check Bestial Wrath"] == 0) -- Bestial Wrath CD over 20 sec
      and UnitBuffID("player", rapidFire) ~= true -- not under Rapid Fire
      and GetSpellCD(rapidFire) >= 5 then -- Rapid Fire CD over 5 sec
      cooldownValue = 2;
    else
      cooldownValue = 0;
    end
  end

  function Misdirection()
    if bb.data["Box Misdirection"] ~= nil then local MisdirectionValue = bb.data["Box Misdirection"]; end
    if bb.data["Box Misdirection"] ~= 0 and UnitExists("target") and UnitIsUnit("player","target") ~= 1 then
      local MisdirectionTarget = nil
      if UnitExists("focus") and not UnitIsDeadOrGhost("focus") then
        MisdirectionTarget = "focus"
      elseif UnitExists("pet") and not UnitIsDeadOrGhost("pet") then
        MisdirectionTarget = "pet"
      end
      if UnitThreatSituation("player", "target") == 3 then
        if MisdirectionTarget ~= nil then
          if castSpell(MisdirectionTarget,_Misdirection) then return; end
        end
      end
      if UnitThreatSituation("player", "target") == 1 and MisdirectionValue == 2 then
        if MisdirectionTarget ~= nil then
          if castSpell(MisdirectionTarget,_Misdirection) then return; end
        end
      end
      if MisdirectionValue == 3 then
        if MisdirectionTarget ~= nil then
          if castSpell(MisdirectionTarget,_Misdirection) then return; end
        end
      end
    end
  end

  function TargetValid(target)
    if UnitExists(target) ~= nil then
      if UnitIsDeadOrGhost(target) == nil then
        if UnitCanAttack("player",target) == 1 then
          if isInCombat(target) ~= nil then
            if IsSpellInRange(GetSpellInfo(SerpentSting),target) == 1 then
              return true;
            end
          end
        end
      end
    end
    return false;
  end

  function Exotic(slot)
    local exoticPets = { "Chimaera", "Core Hound", "Devilsaur", "Quilen", "Rhino", "Shale Spider", "Silithid", "Spirit Beast", "Water Strider", "Worm" }
    if select(4,GetStablePetInfo(slot)) == "Chimaera" or select(4,GetStablePetInfo(slot)) == "Core Hound" or select(4,GetStablePetInfo(slot)) == "Devilsaur" or
      select(4,GetStablePetInfo(slot)) == "Quilen" or select(4,GetStablePetInfo(slot)) == "Rhino" or select(4,GetStablePetInfo(slot)) == "Shale Spider" or
      select(4,GetStablePetInfo(slot)) == "Silithid" or select(4,GetStablePetInfo(slot)) == "Spirit Beast" or select(4,GetStablePetInfo(slot)) == "Water Strider" or
      select(4,GetStablePetInfo(slot)) == "Worm" or select(4,GetStablePetInfo(slot)) == nil then
      return false;
    else
      return true;
    end
  end

  function hasBloodLust()
    if UnitBuffID("player",2825)        -- Bloodlust
      or UnitBuffID("player",80353)       -- Timewarp
      or UnitBuffID("player",32182)       -- Heroism
      or UnitBuffID("player",90355) then  -- Ancient Hysteria
      return true
    else
      return false
    end
  end




end























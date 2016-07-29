if select(3,UnitClass("player")) == 3 then

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

  function Misdirection()
    if bb.data["Box Misdirection"] ~= nil then local MisdirectionValue = bb.data["Box Misdirection"]; end
    if bb.data["Box Misdirection"] ~= 0 and UnitExists("target") and UnitIsUnit("player","target") ~= 1 then
      local MisdirectionTarget = nil
      if UnitExists("focus") and not UnitIsDeadOrGhost("focus") then
        MisdirectionTarget = "focus"
      elseif UnitExists("pet") and not UnitIsDeadOrGhost("pet") then
        MisdirectionTarget = "pet"
      end
      if UnitThreatSituation("player","target") == 3 then
        if MisdirectionTarget ~= nil then
          if castSpell(MisdirectionTarget,_Misdirection) then return; end
        end
      end
      if UnitThreatSituation("player","target") == 1 and MisdirectionValue == 2 then
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

  function Exotic(slot)
    local exoticPets = { "Chimaera","Core Hound","Devilsaur","Quilen","Rhino","Shale Spider","Silithid","Spirit Beast","Water Strider","Worm" }
    for i = 1,#exoticPets do
      if exoticPets[i] == select(4,GetStablePetInfo(slot)) then
        return false
      end
    end
    if select(4,GetStablePetInfo(slot)) == nil then
      return false
    end
    return true
  end

  function castKillShot(unit)
    -- see what spell to use
    local killSpell = 53351
    local hpTreshold = 20
    if UnitLevel("player") >= 92 then
      killSpell = 157708
      hpTreshold = 35
    end
    --
    if getSpellCD(killSpell) == 0 and getHP("target") <= hpTreshold then
      if UnitCastingInfo("player") ~= nil then
        RunMacroText("/stopcasting")
        RunMacroText("/stopcasting")
        if castSpell(unit,killSpell,false,false) then
          return true
        end
      else
        if castSpell(unit,killSpell,false,false) then
          return true
        end
      end
    end
    return false
  end
end























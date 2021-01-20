function PokeRunner()
  if br.data.settings[br.selectedSpec].toggles["Check PokeRotation"] ~= 1 then return false; end
  -- pulsed


  --Print(br.data.wait .. " " .. br.data.abilitiesOnCD)




  -----------------------
  -- Abilities Display --
  -----------------------
  if C_PetBattles.IsInBattle() then
    pokeEnnemyFrame:Show()
    tipsToDisplay = 0;
    for i = 1, 10 do
      if _G["poke"..i.."Buff"] and _G["poke"..i.."Buff"]:IsMouseOver(0, 0, 0, 0) then
        tipsToDisplay = 1;
        ChangeTip(1,select(2,C_PetBattles.GetAbilityInfoByID(_G["poke"..i.."Value"])));
      end
    end
    for i = 1, 10 do
      if _G["poke"..i.."EnnemyBuff"] and _G["poke"..i.."EnnemyBuff"]:IsMouseOver(0, 0, 0, 0) then
        tipsToDisplay = 1;
        ChangeTip(1,select(2,C_PetBattles.GetAbilityInfoByID(_G["poke"..i.."EnnemyValue"])));
      end
    end
    if tipsToDisplay == 0 then
      ChangeTip(1,"");
    end
  else
    pokeEnnemyFrame:Hide()
    pokePlayerFrame:Hide()
  end

  -- if Attacking br.data.abilitiesOnCD == 1
  if C_PetBattles.GetAbilityState(1, activePetSlot, 1) ~= true and C_PetBattles.GetAbilityState(1, activePetSlot, 2) ~= true and C_PetBattles.GetAbilityState(1, activePetSlot, 3) ~= true then
    if br.data.abilitiesOnCD ~= 1 then
      br.data.abilitiesOnCD = 1
    end
  else
    if br.data.abilitiesOnCD ~= 0 then
      br.data.abilitiesOnCD = 0
    end
  end
  -- if Attacking if wait == 0 then Print Attacking and set wait = 2
  if br.data.abilitiesOnCD == 1 then
    if br.data.wait ~= 2 then
      --Print("ATTACKING "..br.data.wait)
      waiter = nil;
      br.data.wait = 2;
    end
    --if pokeValueFrame.Border ~= nil then pokeValueFrame.Border:SetTexture([[Interface\FullScreenTextures\LowHealth]]); end
  end
  -- if attack completed and wait == 2 and waiter == nil then set waiter = GetTime() wait = 1
  if br.data.abilitiesOnCD == 0 and br.data.wait == 2 then
    if waiter == nil then
      waiter = GetTime();
      --Print("WAIT")
      br.data.wait = 1;
    end
  end
  -- if wait == 1 and waiter ~= nil and waiter <= GetTime()-0.1 then Print Go set waiter = nil wait = 3
  if br.data.abilitiesOnCD == 0 and br.data.wait == 0 and waiter and waiter <= GetTime() - 0.1 then
    if br.data.wait ~= 3 then
      --Print(br.data.wait.. br.data.abilitiesOnCD)
      br.data.wait = 3;
      pokeValueFrame.Border:SetTexture([[Interface\FullScreenTextures\OutOfControl]]);
    end
  end

end


function PokeRotationRun()
  if pokeFrame == nil then
    br.data.wait = 1;
    pokeFrame = true
    pokePlayerFrame = CreateFrame("Frame", nil, UIParent)
    pokePlayerFrame:SetPoint("TOP",-300,-100)
    pokePlayerFrame:SetHeight(22)
    pokePlayerFrame:SetWidth(65)
    pokePlayerFrame:EnableMouse(true)
    pokePlayerFrame:SetMovable(true)
    pokePlayerFrame:RegisterForDrag("LeftButton")
    pokePlayerFrame:SetClampedToScreen(true)
    pokePlayerFrame:SetScript("OnDragStart", pokePlayerFrame.StartMoving)
    pokePlayerFrame:SetScript("OnDragStop", pokePlayerFrame.StopMovingOrSizing)

    pokePlayerFrame.Border = pokePlayerFrame:CreateTexture(nil, "BACKGROUND")
    pokePlayerFrame.Border:SetHeight(0)
    pokePlayerFrame.Border:SetWidth(75)
    pokePlayerFrame.Border:SetPoint("TOP",0,4)
    pokePlayerFrame.Border:SetTexture(frameColorR,frameColorG,frameColorB,0.75)
    pokePlayerFrame.Border:Hide();

    function PlayerBuffDisplay()
      if C_PetBattles.IsInBattle() ~= true then
        for i = 0, 10 do
          if _G["poke"..i.."Buff"] ~= nil then
            _G["poke"..i.."Buff"]:SetText("", 1, 1, 1, 0.7);
            _G["poke"..i.."Buff"]:Hide();
            _G["poke"..i.."Value"] = 0;
          end
        end
        return false
      end
      local numBuffs = (C_PetBattles.GetNumAuras(1, C_PetBattles.GetActivePet(1)) + C_PetBattles.GetNumAuras(1, 0))
      local numPetBuffs = C_PetBattles.GetNumAuras(1, C_PetBattles.GetActivePet(1))
      if numBuffs == nil then numBuffs = 0; end

      if numBuffs == 0 then
        pokePlayerFrame.Border:Hide();
      else
        pokePlayerFrame.Border:Show();
        calcHeight = numBuffs*22+10;
        pokePlayerFrame.Border:SetHeight(calcHeight);
      end

      if numBuffs > 0 then
        for i = 0, 10 do
          if numBuffs and numBuffs >= i then
            if numPetBuffs >= i then
              if _G["poke"..i.."Buff"] == nil then InsertPlayerBuff(i, C_PetBattles.GetAuraInfo(1, C_PetBattles.GetActivePet(1), i)) end
              _G["poke"..i.."Buff"]:Show();
              local buffID = C_PetBattles.GetAuraInfo(1, C_PetBattles.GetActivePet(1), i)
              _G["poke"..i.."Buff"]:SetText(buffID, 1, 1, 1, 0.7);
              _G["poke"..i.."Value"] = buffID;
            else
              if _G["poke"..i.."Buff"] == nil then InsertPlayerBuff(i, C_PetBattles.GetAuraInfo(1, 0, i-(numPetBuffs))) end
              _G["poke"..i.."Buff"]:Show();
              local buffID = C_PetBattles.GetAuraInfo(1, 0, i-numPetBuffs)
              _G["poke"..i.."Buff"]:SetText(buffID, 1, 1, 1, 0.7);
              _G["poke"..i.."Value"] = buffID;
            end
          else
            if _G["poke"..i.."Buff"] ~= nil then
              _G["poke"..i.."Buff"]:SetText("", 1, 1, 1, 0.7);
              _G["poke"..i.."Value"] = 0;
              _G["poke"..i.."Buff"]:Hide();
            end
          end
        end
      else
        for i = 0, 10 do
          if _G["poke"..i.."Buff"] ~= nil then
            _G["poke"..i.."Buff"]:SetText("", 1, 1, 1, 0.7);
            _G["poke"..i.."Value"] = 0;
            _G["poke"..i.."Buff"]:Hide();
          end
        end
      end
    end

    function InsertPlayerBuff(value,buffID)
      _G["poke"..value.."Buff"] = pokePlayerFrame:CreateFontString(nil, "ARTWORK");
      _G["poke"..value.."Buff"]:SetFontObject("MovieSubtitleFont");
      _G["poke"..value.."Buff"]:SetTextHeight(14);
      _G["poke"..value.."Buff"]:SetPoint("TOP",0,-((value*22)-17));
      _G["poke"..value.."Buff"]:SetTextColor(255/255, 255/255, 255/255,1);
      _G["poke"..value.."Buff"]:SetText(buffID, 1, 1, 1, 0.7);
      if (value*22)+26 > configHeight then
        configHeight = (value*22)+26;
        pokePlayerFrame:SetHeight(configHeight);
        pokePlayerFrame.Border:SetHeight(configHeight+10);
      end
      _G["poke"..value.."Value"] = buffID;
    end

    pokeEnnemyFrame = CreateFrame("Frame", nil, UIParent)
    pokeEnnemyFrame:SetPoint("TOP",300,-100)
    pokeEnnemyFrame:SetHeight(22)
    pokeEnnemyFrame:SetWidth(65)
    pokeEnnemyFrame:EnableMouse(true)
    pokeEnnemyFrame:SetMovable(true)
    pokeEnnemyFrame:RegisterForDrag("LeftButton")
    pokeEnnemyFrame:SetClampedToScreen(true)
    pokeEnnemyFrame:SetScript("OnDragStart", pokeEnnemyFrame.StartMoving)
    pokeEnnemyFrame:SetScript("OnDragStop", pokeEnnemyFrame.StopMovingOrSizing)

    pokeEnnemyFrame.Border = pokeEnnemyFrame:CreateTexture(nil, "BACKGROUND")
    pokeEnnemyFrame.Border:SetHeight(0)
    pokeEnnemyFrame.Border:SetWidth(75)
    pokeEnnemyFrame.Border:SetPoint("TOP",0,4)
    pokeEnnemyFrame.Border:SetTexture(frameColorR,frameColorG,frameColorB,0.75)
    pokeEnnemyFrame.Border:Hide();

    function EnnemyBuffDisplay()
      if C_PetBattles.IsInBattle() ~= true then
        for i = 0, 10 do
          if _G["poke"..i.."EnnemyBuff"] ~= nil then
            _G["poke"..i.."EnnemyBuff"]:SetText("", 1, 1, 1, 0.7);
            _G["poke"..i.."EnnemyValue"] = 0;
            _G["poke"..i.."EnnemyBuff"]:Hide();
          end
        end
        return false
      end
      local numBuffs = (C_PetBattles.GetNumAuras(2, C_PetBattles.GetActivePet(2)) + C_PetBattles.GetNumAuras(2, 0))
      local numPetBuffs = C_PetBattles.GetNumAuras(2, C_PetBattles.GetActivePet(2))
      if numBuffs == nil then numBuffs = 0; end

      if numBuffs == 0 then
        pokeEnnemyFrame.Border:Hide();
      else
        pokeEnnemyFrame.Border:Show();
        calcHeight = numBuffs*22+10;
        pokeEnnemyFrame.Border:SetHeight(calcHeight);
      end

      if numBuffs > 0 then
        for i = 0, 10 do
          if numBuffs and numBuffs >= i then
            if numPetBuffs >= i then
              if _G["poke"..i.."EnnemyBuff"] == nil then InsertEnnemyBuff(i, C_PetBattles.GetAuraInfo(2, C_PetBattles.GetActivePet(2), i)) end
              _G["poke"..i.."EnnemyBuff"]:Show();
              local buffID = C_PetBattles.GetAuraInfo(2, C_PetBattles.GetActivePet(2), i)
              _G["poke"..i.."EnnemyBuff"]:SetText(C_PetBattles.GetAuraInfo(2, C_PetBattles.GetActivePet(2), i), 1, 1, 1, 0.7);
              _G["poke"..i.."EnnemyValue"] = buffID;
            else
              if _G["poke"..i.."Buff"] == nil then InsertPlayerBuff(i, C_PetBattles.GetAuraInfo(2, 0, i-(numPetBuffs))) end
              _G["poke"..i.."Buff"]:Show();
              local buffID = C_PetBattles.GetAuraInfo(2, 0, i-numPetBuffs)
              _G["poke"..i.."Buff"]:SetText(buffID, 1, 1, 1, 0.7);
              _G["poke"..i.."Value"] = buffID;
            end
          else
            if _G["poke"..i.."EnnemyBuff"] ~= nil then
              _G["poke"..i.."EnnemyBuff"]:SetText("", 1, 1, 1, 0.7);
              _G["poke"..i.."EnnemyValue"] = 0;
              _G["poke"..i.."EnnemyBuff"]:Hide();
            end
          end
        end
      else
        for i = 0, 10 do
          if _G["poke"..i.."EnnemyBuff"] ~= nil then
            _G["poke"..i.."EnnemyBuff"]:SetText("", 1, 1, 1, 0.7);
            _G["poke"..i.."EnnemyValue"] = 0;
            _G["poke"..i.."EnnemyBuff"]:Hide();
          end
        end
      end
      --Print("done")
    end

    function InsertEnnemyBuff(value,buffID)
      _G["poke"..value.."EnnemyBuff"] = pokeEnnemyFrame:CreateFontString(nil, "ARTWORK");
      _G["poke"..value.."EnnemyBuff"]:SetFontObject("MovieSubtitleFont");
      _G["poke"..value.."EnnemyBuff"]:SetTextHeight(14);
      _G["poke"..value.."EnnemyBuff"]:SetPoint("TOP",0,-((value*22)-17));
      _G["poke"..value.."EnnemyBuff"]:SetTextColor(255/255, 255/255, 255/255,1);
      _G["poke"..value.."EnnemyBuff"]:SetText(buffID, 1, 1, 1, 0.7);
      if (value*22)+26 > configHeight then
        configHeight = (value*22)+26
        pokeEnnemyFrame:SetHeight(configHeight);
        pokeEnnemyFrame.Border:SetHeight(configHeight+10);
      end
      _G["poke"..value.."EnnemyValue"] = buffID;
    end
  end



end
















































function PokeEngine()
  if br.data.wait == 3 then
    local abilityNumber = br.data.pokeAttack
    if abilityNumber == 1 then
      C_PetBattles.UseAbility(1); return;
    elseif abilityNumber == 2 then
      C_PetBattles.UseAbility(2); return;
    elseif abilityNumber == 3 then
      C_PetBattles.UseAbility(3); return;
    elseif abilityNumber == 4 then
      C_PetBattles.SkipTurn(); return;
    elseif abilityNumber == 5 then
      C_PetBattles.ChangePet(1); return;
    elseif abilityNumber == 6 then
      C_PetBattles.ChangePet(2); return;
    elseif abilityNumber == 7 then
      C_PetBattles.ChangePet(3); return;
    elseif abilityNumber == 8 then
      C_PetBattles.UseTrap(); return;
    end
  end

  PlayerBuffDisplay();
  EnnemyBuffDisplay();
  if br.data.pokeValueanchor == nil then br.data.pokeValueanchor = "CENTER" end
  if br.data.pokeValuex == nil then br.data.pokeValuex = 0 end
  if br.data.pokeValuey == nil then br.data.pokeValuey = 0 end
  -- Register Base Values
  if not PokeEngineStarted then
    outOfBattleTimer = 0
    inBattleTimer = 0
    health1 = 100
    health2 = 100
    health3 = 100
    maxhealth1 = 100
    maxhealth2 = 100
    maxhealth3 = 100
    PetHP = 100
    Pet1HP = 100
    Pet2HP = 100
    Pet3HP = 100
    MoyHPP = 100
    MoyHP = 100
    activePetSlot = 1
    activePetHP =  100
    PetID = 1
    Pet1ID = 1
    Pet2ID = 2
    Pet3ID = 3
    PetPercent = 100
    numAuras = 1
    numNmeAuras = 1
    NmeactivePetSlot = 1
    NmeactivePetHP = 1
    NmePetID = 1
    NmePetPercent = 1
    nmePetHP = 100
    modifier = 1
    myspeed = 100
    nmespeed = 100
    quality = 100
    PetAbilitiesTable = {{ A1 = 1 , A2 = 1 , A3 = 1 }, { A1 = 1 , A2 = 1 , A3 = 1 }, { A1 = 1 , A2 = 1 , A3 = 1 }}
    -- Static Vars --
    --	RarityColorsTable[1]
    RarityColorsTable = {
      { Type = "Useless", 	Color = "999999" },
      { Type = "Common", 		Color = "FFFFFF" },
      { Type = "Uncommon", 	Color = "33FF33" },
      { Type = "Rare", 		Color = "00AAFF" },
    }
    --	TypeWeaknessTable[1].Color
    TypeWeaknessTable = {
      {	Num = 1, 	Type = "Humanoid",	Weak = 8,	Strong = 2, Resist = 5,	Color = "00AAFF"	},
      {	Num = 2, 	Type = "Dragonkin",	Weak = 4,	Strong = 6, Resist = 3,	Color = "33FF33"	},
      {	Num = 3, 	Type = "Flying",	Weak = 2,	Strong = 9, Resist = 8,	Color = "FFFF66"	},
      {	Num = 4, 	Type = "Undead",	Weak = 9,	Strong = 1, Resist = 2,	Color = "663366"	},
      {	Num = 5, 	Type = "Critter",	Weak = 1,	Strong = 4, Resist = 7,	Color = "AA7744"	},
      {	Num = 6, 	Type = "Magic",		Weak = 10,	Strong = 3, Resist = 9,	Color = "CC44DD"	},
      {	Num = 7, 	Type = "Elemental",	Weak = 5,	Strong = 10,Resist = 10,Color = "FF9933"	},
      {	Num = 8, 	Type = "Beast",		Weak = 3,	Strong = 5, Resist = 1,	Color = "DD2200"	},
      {	Num = 9, 	Type = "Aquatic",	Weak = 6,	Strong = 7, Resist = 4,	Color = "33CCFF"	},
      {	Num = 10, 	Type = "Mechanical",Weak = 7,	Strong = 8, Resist = 6,	Color = "999999"	},
    }
    PokeEngineStarted = true
    -- (PQI) OPTIONS --
    ObjectiveCheck				= true
    ObjectiveValue				= 1
    PetLevelingCheck			= true
    PetLevelingValue			= 6
    ReviveBattlePetsCheck 		= true
    ReviveBattlePetsValue		= 1
    PetHealValue				= 65
    PetHealCheck				= true
    CaptureValue				= 4
    CaptureCheck				= true
    NumberOfPetsValue			= 1
    AutoClickerValue			= 1
    AutoClickerCheck			= false
    FollowerDistanceValue		= 25
    FollowerDistanceCheck		= true

    LevelingPriorityValue 		= 3
    LevelingPriorityCheck		= true
    LevelingRarityValue 		= 4
    LevelingRarityCheck			= true
    SwapInHealthValue			= 65
    SwapInHealthCheck			= true
    SwapOutHealthValue			= 35
    SwapOutHealthCheck			= true
    -- PvP Queue
    PvPCheck					= false
    PvPSlotValue				= 1
    -- Pet Swapper
    PetSwapCheck				= true
    PetSwapValue				= 25
    PetSwapMinCheck				= true
    PetSwapMinValue				= 6
    -- Pause
    PauseKey					= false
    PauseKeyCheck				= false


    -- pokeValueFrame
    pokeValueFrame = CreateFrame("Frame", nil, UIParent);
    pokeValueFrame:SetBackdrop({ bgFile = [[Interface\BUTTONS\UI-EmptySlot]], tile = true, tileSize = 16 });
    pokeValueFrame:SetAlpha(1);
    pokeValueFrame:SetWidth(45);
    pokeValueFrame:SetHeight(45);
    pokeValueFrame.texture = pokeValueFrame:CreateTexture();
    pokeValueFrame.texture:SetAllPoints();
    pokeValueFrame.texture:SetTexture(25/255,25/255,25/255,1);
    pokeValueFrame:SetPoint(br.data.pokeValueanchor,br.data.pokeValuex,br.data.pokeValuey);
    pokeValueFrame:SetClampedToScreen(true);
    pokeValueFrame:SetScript("OnUpdate", pokeValueFrame_OnUpdate);
    pokeValueFrame:EnableMouse(true);
    pokeValueFrame:SetMovable(true);
    pokeValueFrame:SetClampedToScreen(true);
    pokeValueFrame:RegisterForDrag("LeftButton");
    pokeValueFrame:SetScript("OnDragStart", pokeValueFrame.StartMoving);
    pokeValueFrame:SetScript("OnDragStop", pokeValueFrame.StopMovingOrSizing);

    border = pokeValueFrame:CreateTexture(nil, "BACKGROUND");
    pokeValueFrame.Border = border;
    pokeValueFrame.Border:SetPoint("CENTER",0 ,0);
    pokeValueFrame.Border:SetWidth(57);
    pokeValueFrame.Border:SetHeight(57);
    pokeValueFrame.Border:SetTexture([[Interface\FullScreenTextures\LowHealth]],0.25);

    pokeValueFrame.valueText = pokeValueFrame:CreateFontString(nil, "OVERLAY");
    pokeValueFrame.valueText:SetFontObject("MovieSubtitleFont");
    pokeValueFrame.valueText:SetTextHeight(17);
    pokeValueFrame.valueText:SetPoint("CENTER",0,0);
    pokeValueFrame.valueText:SetTextColor(255/255, 255/255, 255/255,1);
    pokeValueFrame.valueText:SetText("Ta Mere", 1, 1, 1, 0.7);

    if SuperPetSwapper then SuperPetSwapper(); end
  end



  -- Run

  -- In Battle timer
  if inBattle then
    if inBattleTimer == 0 then
      inBattleTimer = GetTime()
    end
  elseif inBattleTimer ~= 0 then
    ChatOverlay("\124cFF9999FFBattle Ended "..GetBattleTime().." Min. "..select(2,GetBattleTime()).." Secs.")
    inBattleTimer = 0
  end
  -- Out of Battle timer
  if not inBattle then
    if outOfBattleTimer == 0 then
      outOfBattleTimer = GetTime()
    end
  elseif outOfBattleTimer ~= 0 then
    outOfBattleTimer = 0
  end
  --------------------------
  -- Battle States & Vars --
  --------------------------
  inBattle = C_PetBattles.IsInBattle()
  inWildBattle = C_PetBattles.IsWildBattle()
  inPvPBattle = C_PetBattles.GetTurnTimeInfo()
  if inBattle ~= true then pokeValueFrame:Hide(); else pokeValueFrame:Show(); end
  if inBattle then
    activePetSlot = C_PetBattles.GetActivePet(1)
    CanSwapOut = C_PetBattles.CanActivePetSwapOut()
    -- Number of Abilities the actual pet is using.
    ActivePetlevel = C_PetBattles.GetLevel(1, activePetSlot)
    if ActivePetlevel >= 4 then
      numofAbilities = 3
    elseif ActivePetlevel >= 2 then
      numofAbilities = 2
    else
      numofAbilities = 3
    end
    -- PetAbilitiesTable[1].A1
    PetAbilitiesTable = {
      -- Pet 1
      {
        A1 = C_PetBattles.GetAbilityInfo(1, 1, 1),
        A2 = C_PetBattles.GetAbilityInfo(1, 1, 2),
        A3 = C_PetBattles.GetAbilityInfo(1, 1, 3),
      },
      -- Pet 2
      {
        A1 = C_PetBattles.GetAbilityInfo(1, 2, 1),
        A2 = C_PetBattles.GetAbilityInfo(1, 2, 2),
        A3 = C_PetBattles.GetAbilityInfo(1, 2, 3),
      },
      -- Pet 3
      {
        A1 = C_PetBattles.GetAbilityInfo(1, 3, 1),
        A2 = C_PetBattles.GetAbilityInfo(1, 3, 2),
        A3 = C_PetBattles.GetAbilityInfo(1, 3, 3),
      }
    }
    AvailableAbilities = { 	PetAbilitiesTable[activePetSlot].A1, PetAbilitiesTable[activePetSlot].A2 ,PetAbilitiesTable[activePetSlot].A3 	}

    -- MY HP
    activePetHP = (100 * C_PetBattles.GetHealth(1, activePetSlot) / C_PetBattles.GetMaxHealth(1, activePetSlot))

    health1 = C_PetBattles.GetHealth(1, 1)
    maxhealth1 = C_PetBattles.GetMaxHealth(1, 1)

    health2 = C_PetBattles.GetHealth(1, 2)
    maxhealth2 = C_PetBattles.GetMaxHealth(1, 2)

    health3 = C_PetBattles.GetHealth(1, 3)
    maxhealth3 = C_PetBattles.GetMaxHealth(1, 3)

    PetID = C_PetBattles.GetDisplayID(1, activePetSlot)
    Pet1ID = C_PetBattles.GetDisplayID(1, 1)
    Pet2ID = C_PetBattles.GetDisplayID(1, 2)
    Pet3ID = C_PetBattles.GetDisplayID(1, 3)
    ActivepetGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(activePetSlot)
    PetPercent = floor(activePetHP)
    -- Nme HP
    NmeactivePetSlot = C_PetBattles.GetActivePet(2)
    NmeactivePetHP = (100 * C_PetBattles.GetHealth(2, NmeactivePetSlot) / C_PetBattles.GetMaxHealth(2, NmeactivePetSlot))
    NmePetID = C_PetBattles.GetDisplayID(1, NmeactivePetSlot)
    NmePetPercent = floor(NmeactivePetHP)
    -- Other vars
    usabletrap = C_PetBattles.IsTrapAvailable()
    -- My HP
    PetHP = (100 * C_PetBattles.GetHealth(1, activePetSlot) / C_PetBattles.GetMaxHealth(1, activePetSlot))
    PetExactHP = C_PetBattles.GetHealth(1, activePetSlot)
    Pet1ExactHP = C_PetBattles.GetHealth(1, 1)
    Pet2ExactHP = C_PetBattles.GetHealth(1, 2)
    Pet3ExactHP = C_PetBattles.GetHealth(1, 3)
    Pet1HP = floor((100 * health1 / maxhealth1))
    Pet2HP = floor((100 * health2 / maxhealth2))
    Pet3HP = floor((100 * health3 / maxhealth3))
    PetHPTable = { Pet1HP, Pet2HP, Pet3HP }

    MoyHPP = ((Pet1HP + Pet2HP + Pet3HP) / 3)
    MoyHP = floor(MoyHPP)

    -- Types
    PetType = C_PetBattles.GetPetType(1, activePetSlot)
    Pet1Type = C_PetBattles.GetPetType(1, 1)
    Pet2Type = C_PetBattles.GetPetType(1, 2)
    Pet3Type = C_PetBattles.GetPetType(1, 3)
    NmePetType = C_PetBattles.GetPetType(2, NmeactivePetSlot)
    NmePet1Type = C_PetBattles.GetPetType(2, 1)
    NmePet2Type = C_PetBattles.GetPetType(2, 2)
    NmePet3Type = C_PetBattles.GetPetType(2, 3)

    -- Buffs
    numAuras = C_PetBattles.GetNumAuras(1, activePetSlot)
    numNmeAuras = C_PetBattles.GetNumAuras(2, NmeactivePetSlot)

    WeatherID = C_PetBattles.GetAuraInfo(0, 0, 1)

    -- NME HP
    NMEPetHP = (100 * C_PetBattles.GetHealth(2, enemyPetSlot) / C_PetBattles.GetMaxHealth(2, enemyPetSlot))

    -- Active Ennemi Pet Check
    enemyPetSlot = C_PetBattles.GetActivePet(2)
    nmePetHP = (100 * C_PetBattles.GetHealth(2, enemyPetSlot) / C_PetBattles.GetMaxHealth(2, enemyPetSlot))

    -- Modifier Check
    mypetType = C_PetBattles.GetPetType(1, activePetSlot)
    nmepetType = C_PetBattles.GetPetType(2, nmePetSlot)
    --	modifier = C_PetBattles.GetAttackModifier(mypetType, nmepetType)

    -- Speed Check
    myspeed = C_PetBattles.GetSpeed(1, activePetSlot)
    nmespeed = C_PetBattles.GetSpeed(2, NmeactivePetSlot)

    -- Player active pet GUID
    ActivepetGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(activePetSlot)

    --	PQR_Event("PQR_Text" , "Pet: "..PetID.." HP: "..PetPercent.."% NmeHP:"..NmePetPercent.."%"  , nil, "0698FF")
  end

  -----------------
  -- Revive Pets --
  -----------------

  if not inBattle and ReviveBattlePetsCheck and not HealingDone then
    local Start ,CD = GetSpellCooldown(125439)
    HealCD = floor(Start + CD - GetTime())
    HealMinuts = floor(HealCD/60)
    HealSeconds = (HealCD - (HealMinuts * 60))

    if MoyHP ~= nil then
      if floor(Start + CD - GetTime()) == 0 then
        Pet1HP = 100
        Pet2HP = 100
        Pet3HP = 100
        MoyHP = 100
        pokeValueFrame.valueText:SetText("Heal", 1, 1, 1, 0.7);
        HealingDone = true
      end
      --		PQR_Event("PQR_Text" , "PokeRotation - "..MoyHP.."% // Heal "..HealMinuts.."m "..HealSeconds.."s" , nil, "0698FF")
    end
  end

  --[[                                       Functions                                             ]]

  if not PetFunctions then
    PetFunctions = true

    -- AbilitySpam(Ability) - Cast this single ability with checks.
    AbilitySpam = nil
    function AbilitySpam(Ability)
      if rotationRun == true then
        if PetAbilitiesTable[activePetSlot].A1 == Ability and C_PetBattles.GetAbilityState(1, activePetSlot, 1) == true then
          pokeValueFrame.valueText:SetText("1", 1, 1, 1, 0.7);
          br.data.pokeAttack = 1
          br.data.wait = 0
          rotationRun = false
        end
        if PetAbilitiesTable[activePetSlot].A2 == Ability and C_PetBattles.GetAbilityState(1, activePetSlot, 2) == true then
          pokeValueFrame.valueText:SetText("2", 1, 1, 1, 0.7);
          br.data.pokeAttack = 2
          br.data.wait = 0
          rotationRun = false
        end
        if PetAbilitiesTable[activePetSlot].A3 == Ability and C_PetBattles.GetAbilityState(1, activePetSlot, 3) == true then
          pokeValueFrame.valueText:SetText("3", 1, 1, 1, 0.7);
          br.data.pokeAttack = 3
          br.data.wait = 0
          rotationRun = false
        end
      end
    end

    -- Call to check ability vs enemy pet type.
    function AbilityTest(Poke_Ability)
      if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Strong == NmePetType then IsStrongAbility = true else IsStrongAbility = false end
      if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Weak == NmePetType then IsWeakAbility = true else IsWeakAbility = false end
      if IsStrongAbility then return 3 end
      if not IsWeakAbility and not IsStrongAbility then return 2 end
      if IsWeakAbility then return 1 end
    end

    -- AbilityCast(CastList, DmgCheck) - Cast this Ability List. DmgCheck - 1 = Strong  2 = Normal  3 = Weak  4 = all
    AbilityCast = nil
    function AbilityCast(CastList, DmgCheck)
      for i = 1, #CastList do
        if DmgCheck == nil then
          Poke_Ability = CastList[i]
          AbilitySpam(Poke_Ability)
        end
        if DmgCheck ~= nil then
          Poke_Ability = CastList[i]
          if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Strong == NmePetType then IsStrongAbility = true else IsStrongAbility = false end
          if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Weak == NmePetType then IsWeakAbility = true else IsWeakAbility = false end
          if DmgCheck == 1
            and IsStrongAbility then
            AbilitySpam(Poke_Ability)
          end
          if DmgCheck == 2
            and not IsStrongAbility
            and not IsWeakAbility then
            AbilitySpam(Poke_Ability)
          end
          if DmgCheck == 3
            and IsWeakAbility then
            AbilitySpam(Poke_Ability)
          end
          if DmgCheck == 4 then
            AbilitySpam(Poke_Ability)
          end
        end
      end
    end

    -- CapturePet() - Test for targets to trap.
    function CapturePet()
      if inBattle
        and C_PetBattles.GetBreedQuality(2, NmeactivePetSlot) >= CaptureValue
        and C_PetJournal.GetNumCollectedInfo(C_PetBattles.GetPetSpeciesID(2,NmeactivePetSlot)) < NumberOfPetsValue
        and CaptureCheck then
        if NmeactivePetHP <= 35
          and C_PetBattles.IsTrapAvailable() then
          br.data.pokeAttack = 8;
          br.data.wait = 0
          ChatOverlay("\124cFFFFFFFFTrapping pet")
        elseif NmeactivePetHP <= 65 then
          if Stun ~= nil then Stun() end
          if SimplePunch ~= nil then SimplePunch(3) end
          if SimplePunch ~= nil then SimplePunch(2) end
          if SimplePunch ~= nil then SimplePunch(1) end
        else
          if Stun ~= nil then Stun() end
          if SimplePunch ~= nil then SimplePunch(1) end
          if SimplePunch ~= nil then SimplePunch(2) end
          if SimplePunch ~= nil then SimplePunch(3) end
        end
      end
    end

    -- Return Time in minuts/seconds of the battle.
    function GetBattleTime()
      if inBattleTimer == nil then return 0 end
      if inBattleTimer ~= 0 then
        cTimermin =  floor((GetTime() - inBattleTimer)/60)
        cTimersec =  floor((GetTime() - inBattleTimer)) - (60 * cTimermin)
        return cTimermin, cTimersec
      else
        return 0
      end
    end

    -- Return the number of abilities the pet have according to his level.
    function GetNumofPetAbilities(PetSlot)
      local 	Petlevel = C_PetBattles.GetLevel(1, PetSlot)
      if Petlevel >= 4 then
        return 3
      elseif Petlevel >= 2 then
        return 2
      else
        return 1
      end
    end

    -- Call to see pet strenghts based on IsPetAttack() lists.
    function GetPetStrenght(PetSlot)
      if PetHPTable[PetSlot] ~= 0 then
        local IsPetStrenght = 0

        local petGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(PetSlot)
        local Abilities = { ability1, ability2, ability3 }
        for i = 1, GetNumofPetAbilities(PetSlot) do

          if AbilityTest(Abilities[i]) == 3
            and IsPetAttack(Abilities[i]) then
            IsPetStrenght = ( IsPetStrenght + 1 )
          end
          if AbilityTest(Abilities[i]) == 1
            and IsPetAttack(Abilities[i]) then
            IsPetStrenght = ( IsPetStrenght - 1 )
          end
        end
        return IsPetStrenght
      else
        return 0
      end
    end

    -- Immunity() - Test if the ennemy pet is Immune.
    function Immunity()
      for i = 1, #ImmunityList do
        local Poke_Ability = ImmunityList[i]
        if IsBuffed(Poke_Ability,2,Poke_Ability) then -- Si Aura = Buff
          return true
        end
      end
      if NmePetPercent <= 40 then
        for i = 1, #CantDieList do
          local Poke_Ability = CantDieList[i]
          if IsBuffed(Poke_Ability,2,Poke_Ability) then -- Si Aura = Buff
            return true
          end
        end
      end
      return false
    end

    -- IsBuffed(Ability, BuffTarget, ForceID) - Test if Ability - 1 is in List. Can test additional IDs.
    function IsBuffed(Ability, BuffTarget, ForceID)
      if inBattle then
        found = false
        for i = 1, C_PetBattles.GetNumAuras(BuffTarget, C_PetBattles.GetActivePet(BuffTarget)) do
          local auraID = C_PetBattles.GetAuraInfo(BuffTarget, C_PetBattles.GetActivePet(BuffTarget), i)
          if Ability ~= nil then
            if auraID == ( Ability - 1 ) then
              found = true
            end
          end
          if ForceID ~= nil then
            if auraID == ForceID then
              found = true
            end
          end
        end
        if found then
          return true
        else
          return false
        end
      end
    end

    -- IsBuffed(Ability, BuffTarget, ForceID) - Test if Ability - 1 is in List. Can test additional IDs.
    function IsMultiBuffed(Ability, BuffTarget, ForceID)
      if inBattle then
        if ForceID ~= nil then
          if IsBuffed(ForceID, BuffTarget) then
            return true
          end
        end
        for i = 1, #Ability do
          if IsBuffed(Ability[i], BuffTarget) then
            return true
          end
        end
      end
    end

    -- Return true if the attack is in one of these attacks.
    function IsPetAttack(PokeAbility)
      ToQuerryLists = { PunchList, HighDMGList, ThreeTurnHighDamageList }
      for i = 1, #ToQuerryLists do
        ThisList = ToQuerryLists[i]
        for j = 1 , #ThisList do
          if ThisList[j] == PokeAbility then
            return true
          end
        end
      end
      return false
    end

    -- Health from journal
    function JournalHealth(PetSlot)
      PetHealth = 100 * (select(1,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(PetSlot))) / select(2,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(PetSlot))) )
      if PetHealth == nil then
        return 0
      else
        return PetHealth
      end
    end

    -- Health from journal by GUID
    function JournalHealthGUID(PetGUID)
      PetHealth = 100 * (select(1,C_PetJournal.GetPetStats(PetGUID)) / select(2,C_PetJournal.GetPetStats(PetGUID)) )
      if PetHealth == nil then
        return 0
      else
        return PetHealth
      end
    end

    -- PetLevel
    function PetLevel(PetSlot)
      if inBattle then
        if PetSlot == nil then return 1 end
        local MyPetLevel = C_PetBattles.GetLevel(1, PetSlot)
        if MyPetLevel == nil then MyPetLevel = 1 end
        return MyPetLevel
      end
      if not inBattle then
        if PetSlot == nil then
          PetSlot = 1
        else
          local MyPetLevel = select(3, C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetPetLoadOutInfo(PetSlot)))
          if MyPetLevel == nil then
            MyPetLevel = 1
          end
          return tonumber(MyPetLevel)
        end
      end
    end

    -- Switch Pet
    function Switch()
      AbilityCast(SuicideList)
      -- Make sure we are not rooted.
      if CanSwapOut then
        if PetHP <= SwapOutHealthValue
          and SwapOutHealthCheck
          or PetLevelingCheck and activePetSlot == 1 then
          if activePetSlot == 1
            and Pet1HP <= SwapOutHealthValue
            or NMEPetHP < 100 then
            if GetPetStrenght(2) > GetPetStrenght(3)
              and Pet2HP >= SwapInHealthValue then
              pokeValueFrame.valueText:SetText("Pet 2", 1, 1, 1, 0.7);
              br.data.pokeAttack = 6
              br.data.wait = 0
              rotationRun = false;
            elseif Pet3HP >= SwapInHealthValue
              or Pet1HP == 0 then
              pokeValueFrame.valueText:SetText("Pet 3", 1, 1, 1, 0.7);
              br.data.pokeAttack = 7
              br.data.wait = 0
              rotationRun = false;
            end
          elseif activePetSlot == 2 then
            if GetPetStrenght(1) > GetPetStrenght(3)
              and Pet1HP >= SwapInHealthValue
              and not ( PetLevelingCheck and PetLevelingValue > C_PetBattles.GetLevel(1, 1) ) then
              pokeValueFrame.valueText:SetText("Pet 1", 1, 1, 1, 0.7);
              br.data.pokeAttack = 5
              br.data.wait = 0
              rotationRun = false;
            elseif Pet3HP >= SwapInHealthValue or Pet2HP == 0 then
              pokeValueFrame.valueText:SetText("Pet 3", 1, 1, 1, 0.7);
              br.data.pokeAttack = 7
              br.data.wait = 0
              rotationRun = false;
            end
          elseif activePetSlot == 3 then
            if GetPetStrenght(1) > GetPetStrenght(2)
              and Pet1HP >= SwapInHealthValue
              and not ( PetLevelingCheck and PetLevelingValue > C_PetBattles.GetLevel(1, 1) ) then
              pokeValueFrame.valueText:SetText("Pet 1", 1, 1, 1, 0.7);
              br.data.pokeAttack = 5
              br.data.wait = 0
              rotationRun = false;
            elseif Pet2HP >= SwapInHealthValue or Pet3HP == 0 then
              pokeValueFrame.valueText:SetText("Pet 2", 1, 1, 1, 0.7);
              br.data.pokeAttack = 6
              br.data.wait = 0
              rotationRun = false;
            elseif Pet2HP == 0 and Pet3HP == 0 then
              pokeValueFrame.valueText:SetText("Pet 1", 1, 1, 1, 0.7);
              br.data.pokeAttack = 5
              br.data.wait = 0
              rotationRun = false;
            end
          end
        end
      end
    end
  end

  --[[                                       Swap Config                                             ]]

  -- Disable all filters in Pet Journal --
  if IsSwapping == nil then IsSwapping = GetTime() end
  function SuperPetSwapper()
    -- Pet swap table --
    if enoughWait == nil then enoughWait = GetTime() + 2 end
    if enoughWait < GetTime()
      and not inBattle
      and PetSwapCheck
      and PetLevelingCheck
      and not PvPCheck
      and ObjectiveValue == 1 then

      -- Pet Leveling Slot 1
      if PetLevel(1) ~= nil and PetLevel(1) >= PetSwapValue or PetLevel(1) < PetSwapMinValue then -- or JournalHealth(1) <= SwapInHealthValue then

        CML_PetTable = { }

        for i = 1, select(2,C_PetJournal.GetNumPets()) do
          petID, _, _, _, level, favorite, _, _, _, _, _, _, _, isWild, canBattle, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)
          if petID ~= nil then
            if isWild then WildConvert = 1 else WildConvert = 0 end
            if Favorite then FavoriteConvert = 1 else FavoriteConvert = 0 end
            if canBattle
              and ( level < PetSwapValue and JournalHealthGUID(petID) >= SwapInHealthValue )
              and level >= PetSwapMinValue
              and petID ~= C_PetJournal.GetPetLoadOutInfo(1)
              and petID ~= C_PetJournal.GetPetLoadOutInfo(2)
              and petID ~= C_PetJournal.GetPetLoadOutInfo(3)
              and select(5, C_PetJournal.GetPetStats(select (1,C_PetJournal.GetPetInfoByIndex(i)))) >= LevelingRarityValue then
              table.insert( CML_PetTable,{
                ID = petID,
                Level = level,
                Favorite = FavoriteConvert,
                Wild = WildConvert,
              } )
              -- Print("Inserted "..petID.." "..level.." "..FavoriteConvert.." "..WildConvert)
            end
          end
        end

        table.sort(CML_PetTable, function(x,y) return x.Favorite < y.Favorite end)

        -- Level Sorts
        if LevelingPriorityValue == 1 or  3  then
          table.sort(CML_PetTable, function(x,y) return x.Level < y.Level end)
        end
        if LevelingPriorityValue == 2 or 4 then
          table.sort(CML_PetTable, function(x,y) return x.Level > y.Level end)
        end

        -- Wild Sorts
        if LevelingPriorityValue ==  3 or 4	then
          table.sort(CML_PetTable, function(x,y) return x.Wild < y.Wild end)
        end

        C_PetJournal.SetPetLoadOutInfo(1, CML_PetTable[1].ID)
      end

      -- Other pets check health
      for i = 1, 3 do
        if not ( i == 1 and PetLevelingCheck ) then
          if ( JournalHealth(i) <= SwapInHealthValue or PetLevel(i) ~= 25 )then

            CML_RingnersTable = { }

            for j = 1, select(2,C_PetJournal.GetNumPets()) do
              petID, _, _, _, level, favorite, _, _, _, _, _, _, _, isWild, canBattle, _, _, _ = C_PetJournal.GetPetInfoByIndex(j)
              if petID ~= nil then
                if isWild then WildConvert = 1 else WildConvert = 0 end
                if Favorite then FavoriteConvert = 1 else FavoriteConvert = 0 end
                if canBattle
                  and JournalHealthGUID(petID) >= SwapInHealthValue
                  and level >= PetSwapMinValue
                  and petID ~= C_PetJournal.GetPetLoadOutInfo(1)
                  and petID ~= C_PetJournal.GetPetLoadOutInfo(2)
                  and petID ~= C_PetJournal.GetPetLoadOutInfo(3)
                  and select(5, C_PetJournal.GetPetStats(select (1,C_PetJournal.GetPetInfoByIndex(j)))) >= 4 then
                  table.insert( CML_RingnersTable,{
                    ID = petID,
                    Level = level,
                    Favorite = FavoriteConvert,
                    Wild = WildConvert,
                  } )
                  -- Print("Inserted Ringner "..petID.." "..level.." "..FavoriteConvert.." "..WildConvert)
                end
              end
            end

            -- Favorites Sorts
            table.sort(CML_RingnersTable, function(x,y) return x.Favorite < y.Favorite end)

            -- Level Sorts
            table.sort(CML_RingnersTable, function(x,y) return x.Level > y.Level end)

            -- Switch Pet
            C_PetJournal.SetPetLoadOutInfo(i, CML_RingnersTable[1].ID)
          end
        end
      end
    end
  end


  --[[                                       Collections                                             ]]

  -- Collections
  if not LoadAllLists then
    LoadAllLists = true

    --Remove Debuffs/Buffs
    --667, Aged Yolk
    --763, Sear Magic
    --835, Eggnog
    --941, High Fiber

    --Only works if at least one ally is dead
    --665, Consume Corpse

    -- AoE Attacks to be used only while there are 3 Enemies.
    AoEPunchList = {
      299, -- Arcane Explosion
      319, -- Magma Wave
      387, -- Tympanic Tantrum
      404, -- Sunlight
      419, -- Tidal Wave
      668, -- Dreadfull Breath
      644, -- Quake
      649, -- BONESTORM
      741, -- Whirlwind
      768, -- Omnislash
      774, -- Rapid Fire
      923, -- Flux
    }

    -- Roots and other buffs. These debuff on us will disable Pet Swap.
    BuffNoSwap  = {
      248, -- Rooted
      294, -- Charging Rocket
      302, -- Planted
      338, -- Webbed
      370, -- Sticky Goo
    }

    -- Abilities that give immunity on the next spell
    CantDieList = {
      284, -- Survival
    }

    -- Attacks that are stronger if the ennemi have more life than us.
    ComebackList = {
      253, -- Comeback
      405, -- Early Advantage
    }

    -- Damage Buffs that we want to cast on us.
    DamageBuffList = {
      188, -- Accuracy
      197, -- Adrenal Glands
      216, -- Inner Vision
      223, -- Focus Chi
      252, -- Uncanny Luck
      263, -- Crystal Overload
      279, -- Heartbroken
      347, -- Roar
      375, -- Trumpet Strike
      426, -- Focus
      488, -- Amplify Magic
      521, -- Hawk Eye
      536, -- Prowl
      589, -- Arcane Storm
      614, -- Competitive Spirit
      740, -- Frenzyheart Brew
      791, -- Stimpack
      809, -- Roll
      936, -- Caw

    }

    -- Debuff to cast on ennemy. This list will check for Abilit-1 debuffs.
    DeBuffList = {
      --650, -- Bone Prison (Roots)
      152, -- Poison Fang
      155, -- Hiss
      167, -- Nut Barrage
      176, -- Volcano
      178, -- Immolate
      179, -- Conflagrate
      204, -- Call Lightning
      206, -- Call Blizzard
      212, -- Siphon Life
      248, -- Rooted
      249, -- Grasp
      305, -- Exposed Wounds
      314, -- Mangle
      339, -- Sticky Web
      352, -- Banana Barrage
      359, -- Sting
      369, -- Acidic Goo
      371, -- Sticky Goo
      380, -- Poison Spit
      382, -- Brittle Webbing
      398, -- Poison Lash
      411, -- Woodchipper
      447, -- Corrosion
      463, -- Flash
      497, -- Soothe
      501, -- Flame Breath
      515, -- Flyby
      524, -- Squawk
      527, -- Stench
      592, -- Wild Magic
      628, -- Rock Barrage
      630, -- Poisoned Branch
      631, -- Super Sticky Goo
      642, -- Egg Barrage
      743, -- Creeping Fungus
      756, -- Acid Touch
      784, -- Shriek
      786, -- Blistering Cold
      803, -- Rip
      811, -- Magma Trap
      909, -- Paralyzing Shock
      919, -- Black Claw
      932, -- Croak
      964, -- Autumn Breeze
    }

    SpecialDebuffsList = {
      { 	Ability = 270, 	Debuff = 271 	}, -- Glowing Toxin
      {	Ability = 362,  Debuff = 542	}, -- Howl
      { 	Ability = 448, 	Debuff = 781 	}, -- Creeping Ooze
      {	Ability = 468,  Debuff = 469	}, -- Agony
      {	Ability = 522,  Debuff = 738	}, -- Nevermore
      {	Ability = 580,  Debuff = 498    }, -- Food Coma/ Asleep
      { 	Ability = 632, 	Debuff = 633 	}, -- Confusing Sting
      { 	Ability = 657, 	Debuff = 658 	}, -- Plagued Blood
      { 	Ability = 784, 	Debuff = 494 	}, -- Shriek/ Attack Reduction
      {	Ability = 869,  Debuff = 153	}, -- Darkmoon Curse/ Attack Reduction
      {	Ability = 486,  Debuff = 153	}, -- Drain Power/ Attack Reduction
      {	Ability = 940,  Debuff = 939    }, -- Touch of the Animus
    }

    -- Abilities used to Deflect
    DeflectorList = {
      312, -- Dodge
      440, -- Evanescence
      490, -- Deflection
      764, -- Phase Shift
    }

    ExecuteList = {
      538, -- Devour
      802, -- Ravage
      917, -- Bloodfang
    }

    -- Apocalypse.
    FifteenTurnList = {
      519, -- Apocalypse
    }
    MeteorStrikeList = {
      518, -- Apocalypse
      519, -- Apocalypse
    }

    KamikazeList = {
      282, -- Explode
      321, -- Unholy Ascension
      568, -- Feign Death
      652, -- Haunt
      663, -- Corpse Explosion
    }

    -- Abilities to be cast to heal ouself instantly.
    HealingList = {
      123, -- Healing Wave
      168, -- Healing Flame
      173, -- Cautherize
      230, -- Cleansing Rain
      247, -- Hibernate
      273, -- Wish
      278, -- Repair
      298, -- Inspiring Song
      383, -- Leech Life
      533, -- Rebuild
      539, -- Bleat
      573, -- Nature's Touch
      576, -- Perk Up
      578, -- Buried Treasure
      598, -- Emerald Dream
      611, -- Ancient Blessing
      745, -- Leech Seed
      770, -- Restoration
      776, -- Love Potion
      922, -- Healing Stream
      -- Leech
      121, -- Death Coil
      160, -- Consume
      449, -- Absorb
      937, -- Siphon Anima
    }

    HighDamageIfBuffedList = {
      {	Ability = 221,  Debuff = 927	}, -- Takedown if Stunned
      {	Ability = 221,  Debuff = 174	}, -- Takedown if Stunned (second stun ID)
      {	Ability = 250,  Debuff = 338	}, -- Spiderling Swarm if Webbed
      { 	Ability = 423, 	Debuff = 491 	}, -- Blood in the Water if Bleeding.
      {	Ability = 461,  Debuff = 462	}, -- Light if Blinded
      {	Ability = 461,  Debuff = 954	}, -- Light if Blinded (second ID)
      { 	Ability = 345, 	Debuff = 491 	}, -- Maul if Bleeding.
    }
    HighDMGList = {
      908, -- Jolt

      120, -- Howling Blast
      170, -- Lift-Off
      172, -- Scorched Earth
      179, -- Conflagrate
      158, -- Counterstrike
      186, -- Reckless Strike
      204, -- Call Lightning
      209, -- Ion Cannon
      226, -- Fury of 1,000 Fists
      256, -- Call Darkness
      258, -- Starfall
      330, -- Sons of the Flame
      345, -- Maul
      348, -- Maul (Stun)
      376, -- Headbutt
      400, -- Entangling Roots
      402, -- Stun Seed
      414, -- Frost Nova
      442, -- Spectral Strike
      450, -- Expunge
      453, -- SandStorm
      456, -- Clean-Up
      457, -- Sweep
      460, -- Illuminate
      466, -- Nether Gate
      481, -- Deep Freeze
      493, -- Hoof
      506, -- Cocoon Strike
      508, -- Mosth Dust
      517, -- Nocturnal Strike
      518, -- Predatory Strike
      532, -- Body Slam
      541, -- Chew
      572, -- MudSlide
      586, -- Gift of Winter's Veil
      593, -- Surge of Power
      595, -- Moonfire
      607, -- Cataclysm
      609, -- Instability
      612, -- Proto-Strike
      621, -- Stone Rush
      645, -- Launch
      646, -- Shock and Awe
      649, -- Bone Storm
      669, -- Backflip
      746, -- Spore Shrooms
      752, -- Soulrush
      753, -- Solar Beam
      761, -- Heroic Leap
      762, -- Haymaker
      767, -- Holy Charge
      769, -- Surge of Light
      773, -- Shot Through The Heart
      777, -- Missile
      779, -- Thunderbolt
      788, -- Gauss Rifle
      792, -- Darkflame
      812, -- Sulfuras Smash
      814, -- Rupture
      912, -- QuickSand
      913, -- Spectral Spine
      916, -- Haywire
      942, -- Frying Pan

    }

    -- Buffs that heal us.
    HoTBuffList = {
      267, -- Phytosynthesis
      303, -- Plant
      574, -- Nature's Ward

    }
    -- Buffs that heal us.
    HoTList = {
      160, -- Consume
      230, -- Cleansing Waters
      268, -- Phytosynthesis
      302, -- Planted
      820, -- Nature's Ward
    }

    ImmunityList = {
      311, -- Dodge
      331, -- Submerged
      341, -- Flying
      340, -- Burrowed
      505, -- Cocoon Strike
      830, -- Dive
      839, -- Leaping
      852, -- Flying (Launch)
      926, -- Soothe
    }

    LastStandList = {
      283, -- Survival
      568, -- Feign Death
      576, -- Perk Up
      611, -- Ancient Blessing
      794, -- Dark Rebirth
    }

    LifeExchangeList = {
      277, -- Life Exchange
    }

    -- Attack that will damage next turn.
    OneTurnList = {
      159, -- Burrow
      407, -- Meteor Strike
      564, -- Dive
      606, -- Elementium Bolt
      645, -- Launch
      828, -- Sons of the Root
    }

    -- Attacks to be used for Pet Leveling
    PetLevelingList = {
      -- High Priority

      -- Low Priority
      155, -- Hiss
      492, -- Rake
    }

    -- Basic attacks
    PunchList = {
      -- High Priority
      156, -- Vicious Fang
      169, -- Deep Breath
      233, -- Frog Kiss
      293, -- Launch Rocket
      297, -- Pump
      301, -- Lock-On
      323, -- Gravity
      354, -- Barrel Toss
      377, -- Trample
      411, -- Woodchipper
      413, -- Ice Lance
      437, -- Onyx Bite
      459, -- Wind-Up
      471, -- Weakness
      476, -- Dark Simulacrum
      507, -- Moth Balls
      508, -- Moth Dust
      509, -- Surge
      529, -- Belly Slide
      563, -- Quick Attack
      566, -- Powerball
      594, -- Sleeping Gas
      616, -- Blinkstrike
      754, -- Screeching Gears
      765, -- Holy Sword
      775, -- Perfumed Arrow
      778, -- Charge
      849, -- Huge, Sharp Teeth!
      921, -- Hunting Party
      930, -- Huge Fang
      943, -- Chop
      958, -- Trihorn Charge
      -- Normal Priority
      110, -- Bite
      111, -- Punch
      112, -- Peck
      113, -- Burn
      114, -- Beam
      115, -- Breath
      116, -- Zap
      117, -- Infected Claw
      118, -- Water Jet
      119, -- Scratch
      121, -- Death Coil (Heal)
      122, -- Tail Sweep
      163, -- Stampede
      184, -- Quills
      193, -- Flank
      202, -- Trash
      210, -- Shadow Slash
      219, -- Jab
      276, -- Swallow You Whole
      347, -- Roar
      349, -- Smash
      355, -- Triple Snap
      356, -- Snap
      360, -- Flurry
      367, -- Chomp
      378, -- Strike
      384, -- Metal Fist
      390, -- Demolish
      393, -- Shadowflame
      406, -- Crush
      420, -- Slicing Wind
      421, -- Arcane Blast
      422, -- Shadow Shock
      424, -- Tail Slap
      429, -- Claw
      432, -- Jade Claw
      445, -- Ooze Touch
      449, -- Absorb
      452, -- Broom
      455, -- Batter
      472, -- Blast of Hatred
      473, -- Focused Beams
      474, -- Interupting Gaze
      477, -- Snowball
      478, -- Magic Hat
      482, -- Laser
      483, -- Psychic Blast
      484, -- Feedback
      492, -- Rake
      499, -- Diseased Bite
      514, -- Wild Winds
      525, -- Emerald Bite
      528, -- Frost Spit
      608, -- Nether Blast
      617, -- Spark
      626, -- Skitter
      630, -- Poisoned Branch
      648, -- Bone Bite
      668, -- Dreadfull Breath
      712, -- Railgun
      713, -- Blitz
      771, -- Bow Shot
      782, -- Frost Breath
      789, -- U-238 Rounds
      800, -- Impale
      801, -- Stone Shot
      826, -- Weakening Blow
      901, -- Fel Immolate
      910,  -- Sand Bolt
      -- Low Priority
      167, -- Nut Barrage
      253, -- Comeback
      307, -- Kick
      383, -- Leech Life
      389, -- Overtune
      501, -- Flame Breath
      509, -- Surge
      -- Three Turns
      124, -- Rampage
      163, -- Stampede
      198, -- Zergling Rush
      581, -- Flock
      666, -- Rabid Bite
      668, -- Dreadful Breath
      706, -- Swarm
      870, -- Murder
    }

    -- Attacks that are stronger if we are quicker.
    QuickList = {
      184, -- Quills
      202, -- Thrash
      228, -- Tongue Lash
      307, -- Kick
      360, -- Flurry
      394, -- Lash
      412, -- Gnaw
      441, -- Rend
      455, -- Batter
      474, -- Interrupting Gaze
      504, -- Alpha Strike
      535, -- Pounce
      571, -- Horn Attack
      617, -- Spark
      789, -- U-238 Rounds
      938, -- Interrupting Jolt
    }

    -- List of Buffs that we want to cast on us.
    SelfBuffList = {
      259, -- Invisibility
      318, -- Thorns
      315, -- Spiked Skin
      325, -- Beaver Dam
      366, -- Dazzling Dance
      409, -- Immolation
      426, -- Focus
      444, -- Prismatic Barrier
      479, -- Ice Barrier
      486, -- Drain Power
      488, -- Amplify Magic
      757, -- Lucky Dance
      905, -- Cute Face
      906, -- Lightning Shield
      914, -- Spirit Spikes
      944, -- Heat Up
      962, -- Ironbark
      -- Damage
      188, -- Accuracy
      197, -- Adrenal Glands
      208, -- Supercharge
      216, -- Inner Vision
      263, -- Crystal Overload
      279, -- Heartbroken
      347, -- Roar
      375, -- Trumpet Strike
      488, -- Amplify Magic
      520, -- Hawk Eye
      589, -- Arcane Storm
      791, -- Stimpack
    }

    SpecialSelfBuffList = {
      { 	Ability = 597, 	Buff = 823 	}, -- Emerald Presence
      {	Ability = 851,  Buff = 544	}, -- Vicious Streak
      {	Ability = 364,  Buff = 544	}, -- Leap
      {	Ability = 567,  Buff = 544	}, -- Rush
      {	Ability = 579,  Buff = 735	}, -- Gobble Strike
      {	Ability = 957,  Buff = 485	}, -- Evolution
    }

    ShieldBuffList = {
      165, -- Crouch
      225, -- Staggered Steps
      310, -- Shell Shield
      334, -- Decoy
      392, -- Extra Plating
      431, -- Jadeskin
      436, -- Stoneskin
      465, -- Illusionary Barrier
      751, -- Soul Ward
      760, -- Shield Block
      934, -- Bubble
      960, -- Trihorn Shield
    }

    SlowPunchList = {
      228, -- Tongue Lash
      233, -- Frog Kiss
      360, -- Flurry
      377, -- Trample
      390, -- Demolish
      394, -- Lash
      455, -- Batter
      475, -- Eyesurge
      529, -- Belly Slide
    }

    SootheList = {
      497, -- Soothe
    }

    SpeedBuffList = {
      162, -- Adrenaline Rush
      194, -- Metabolic Boost
      389, -- Overtune
      838, -- Centrifugal Hooks
    }

    SpeedDeBuffList = {
      357, -- Screech - 25%
      416, -- Frost Shock - 25%
      475, -- Eyeblast
      929, -- Slither
    }

    -- Pass Turn
    StunnedDebuffs = {
      498,
      822,
      927,
    }

    StunList = {
      227, -- Blackout Kick
      348, -- Bash
      350, -- Clobber
      569, -- Crystal Prison
      654, -- Ghostly Bite
      670, -- Snap Trap
      766, -- Holy Justice
      772, -- LoveStruck
      780, -- Death Grip
    }

    SuicideList = {
      282, -- Explode
      321, -- Unholy Ascension
      836, -- Baneling Burst
      652, -- Haunt
      663, -- Corpse Explosion
    }

    SwapoutDebuffList  = {
      358, --
      379, -- Poison Spit
      822, -- Frog Kiss
    }

    TeamDebuffList = {
      167, -- Nut Barrage
      190, -- Cyclone
      214, -- Death and Decay
      232, -- Swarm of Flies
      503, -- Flamethrower
      575, -- Slippery Ice
      640, -- Toxic Smoke
      642, -- Egg Barrage
      644, -- Rock Barrage
      860, -- Flamethrower
      920, -- Primal Cry
    }

    -- Attack that will damage in three turns.
    ThreeTurnList = {
      386, -- XE-321 Boombot
      513, -- Whirlpool
      634, -- Minefield
      418, -- Geyser
      606, -- Elementium Bolt
      647, -- Bombing Run
    }

    ThreeTurnHighDamageList = {
      124, -- Rampage
      218, -- Curse of Doom
      489, -- Mana Surge
      624, -- Ice Tomb
      636, -- Sticky Grenade
      917, -- Bloodfang
    }

    -- Attacks to Deflect.
    ToDeflectList = {
      296, -- Pumped Up
      331, -- Submerged
      340, -- Burrow
      353, -- Barrel Ready
      341, -- Lift-Off
      830, -- Dive
      839, -- Leaping

    }

    TeamHealBuffsAbilities = {
      511, -- Renewing Mists
      539, -- Bleat
      254, -- Tranquility
    }

    TeamHealBuffsList = {
      510, -- Renewing Mists
      255, -- Tranquility
    }

    TurretsList = {
      710, -- Build Turret
    }


    -- List of Pets to chase.
    MopList = {
      "Adder",
      "Alpine Chipmunk",
      "Alpine Foxling",
      "Alpine Foxling Kit",
      "Alpine Hare",
      "Amber Moth",
      "Amethyst Spiderling",
      "Anodized Robo Cub",
      "Arctic Fox Kit",
      "Ash Lizard",
      "Ash Viper",
      "Baby Ape",
      "Bandicoon",
      "Bandicoon Kit",
      "Bat",
      "Beetle",
      "Biletoad",
      "Black Lamb",
      "Black Rat",
      "Blighted Squirrel",
      "Blighthawk",
      "Borean Marmot",
      "Bucktooth Flapper",
      "Cat",
      "Cheetah Cub",
      "Chicken",
      "Clefthoof Runt",
      "Clouded Hedgehog",
      "Cockroach",
      "Cogblade Raptor",
      "Coral Adder",
      "Coral Snake",
      "Crested Owl",
      "Crimson Geode",
      "Crimson Shale Hatchling",
      "Crystal Beetle",
      "Crystal Spider",
      "Dancing Water Skimmer",
      "Darkshore Cub",
      "Death's Head Cockroach",
      "Desert Spider",
      "Dragonbone Hatchling",
      "Dung Beetle",
      "Effervescent Glowfly",
      "Elder Python",
      "Electrified Razortooth",
      "Elfin Rabbit",
      "Emerald Boa",
      "Emerald Proto-Whelp",
      "Emerald Shale Hatchling",
      "Emerald Turtle",
      "Emperor Crab",
      "Eternal Strider",
      "Fawn",
      "Fel Flame",
      "Festering Maggot",
      "Fire Beetle",
      "Fire-Proof Roach",
      "Fledgling Nether Ray",
      "Fjord Rat",
      "Fjord Worg Pup",
      "Forest Moth",
      "Fluxfire Feline",
      "Frog",
      "Fungal Moth",
      "Gazelle Fawn",
      "Gilded Moth",
      "Giraffe Calf",
      "Gold Beetle",
      "Golden Civet",
      "Golden Civet Kitten",
      "Grasslands Cottontail",
      "Grassland Hopper",
      "Grasslands Cottontail",
      "Grey Moth",
      "Grizzly Squirrel",
      "Grove Viper",
      "Hare",
      "Harpy Youngling",
      "Highlands Mouse",
      "Highlands Skunk",
      "Highlands Turkey",
      "Horned Lizard",
      "Horny Toad",
      "Huge Toad",
      "Imperial Eagle Chick",
      "Infected Fawn",
      "Infected Squirrel",
      "Infinite Whelping",
      "Irradiated Roach",
      "Jumping Spider",
      "Jungle Darter",
      "Jungle Grub",
      "King Snake",
      "Kuitan Mongoose",
      "Kun-Lai Runt",
      "Larva",
      "Lava Crab",
      "Leopard Scorpid",
      "Leopard Tree Frog",
      "Little Black Ram",
      "Locust",
      "Lofty Libram",
      "Lost of Lordaeron",
      "Luyu Moth",
      "Mac Frog",
      "Maggot",
      "Malayan Quillrat",
      "Malayan Quillrat Pup",
      "Marsh Fiddler",
      "Masked Tanuki",
      "Masked Tanuki Pup",
      "Mei Li Sparkler",
      "Mirror Strider",
      "Minfernal",
      "Molten Hatchling",
      "Mongoose Pup",
      "Mountain Skunk",
      "Nether Faerie Dragon",
      "Nether Roach",
      "Nexus Whelpling",
      "Nordrassil Wisp",
      "Oasis Moth",
      "Oily Slimeling",
      "Parrot",
      "Plains Monitor",
      "Prairie Dog",
      "Prairie Mouse",
      "Qiraji Guardling",
      "Rabbit",
      "Rabid Nut Varmint 5000",
      "Rapana Whelk",
      "Rat",
      "Rattlesnake",
      "Ravager Hatchling",
      "Red-Tailed Chipmunk",
      "Resilient Roach",
      "Roach",
      "Robo-Chick",
      "Rock Viper",
      "Ruby Sapling",
      "Rusty Snail",
      "Sand Kitten",
      "Sandy Petrel",
      "Savory Beetle",
      "Scarab Hatchling",
      "Scorpid",
      "Scorpling",
      "Scourged Whelpling",
      "Sea Gull",
      "Sidewinder",
      "Shimmershell Snail",
      "Shrine Fly",
      "Shore Crab",
      "Shy Bandicoon",
      "Sifang Otter",
      "Silent Hedgehog",
      "Silithid Hatchling",
      "Silky Moth",
      "Small Frog",
      "Snake",
      "Snow Cub",
      "Snowy Owl",
      "Softshell Snapling",
      "Spawn of Onyxia",
      "Spiky Lizard",
      "Spiny Lizard",
      "Spiny Terrapin",
      "Spirit Crab",
      "Sporeling Sprout",
      "Spotted Bell Frog",
      "Squirrel",
      "Stinkbug",
      "Stormwind Rat",
      "Stripe-Tailed Scorpid",
      "Stunded Shardhorn",
      "Stunted Yeti",
      "Summit Kid",
      "Sumprush Rodent",
      "Swamp Croaker",
      "Tainted Cockroach",
      "Tainted Moth",
      "Tainted Rat",
      "Thundertail Flapper",
      "Tiny Bog Beast",
      "Tiny Harvester",
      "Tiny Twister",
      "Toad",
      "Tolai Hare",
      "Tol'vir Scarab",
      "Topaz Shale Hatchling",
      "Tree Python",
      "Tundra Penguin",
      "Turkey",
      "Turquoise Turtle",
      "Twilight Beetle",
      "Twilight Fiendling",
      "Unborn Val'kyr",
      "Venomspitter Hatchling",
      "Warpstalker Hatchling",
      "Water Snake",
      "Water Waveling",
      "Wild Crimson Hatchling",
      "Wild Golden Hatchling",
      "Wild Jade Hatchling",
      "Yakrat",
      "Yellow-Bellied Marmot",
      "Zooey Snake",
    }
  end


  --[[                                       Abilities                                             ]]


  -- Abilities
  if not AttackFunctions then
    AttackFunctions = true

    -- AoE Attacks to be used only while there are 3 Enemies.
    AoEPunch = nil
    function AoEPunch()
      if nmePetSlot == 1 or 2 then
        AbilityCast(AoEPunchList)
      end
    end

    -- Abilities that are stronger if the enemy have more health than us.
    Comeback = nil
    function Comeback()
      if PetHP < NmePetPercent
        and not Immunity() then
        AbilityCast(ComebackList)
      end
    end

    -- Damage Buffs that we want to cast on us.
    DamageBuff = nil
    function DamageBuff()
      if not IsMultiBuffed(DamageBuffList, 1, 485) then
        AbilityCast(DamageBuffList)
      end
    end

    -- Debuff to cast on ennemy.
    DeBuff = nil
    function DeBuff()
      if NmePetPercent >= 45
        and not Immunity() then
        for i = 1, #DeBuffList do
          if not IsBuffed(DeBuffList[i], 2) then
            AbilitySpam(DeBuffList[i])
          end
        end
        for i = 1, #SpecialDebuffsList do
          if not IsBuffed(nil, 2, SpecialDebuffsList[i].Debuff) then
            AbilitySpam(SpecialDebuffsList[i].Ability)
          end
        end
      end
    end

    -- HighDamageIfBuffed to cast on ennemy.
    HighDamageIfBuffed = nil
    function HighDamageIfBuffed()
      if not Immunity() then
        for i = 1, #HighDamageIfBuffedList do
          if IsBuffed(nil, 2, HighDamageIfBuffedList[i].Debuff) then
            AbilitySpam(HighDamageIfBuffedList[i].Ability)
          end
        end
      end
    end

    -- Abilities to shield ourself to avoid an ability.
    Deflect = nil
    function Deflect()
      if IsMultiBuffed(ToDeflectList, 2) then
        AbilityCast(DeflectorList)
      end
    end

    -- Apocalypse
    DelayFifteenTurn = nil
    function DelayFifteenTurn()
      if NmeactivePetSlot == 1 then
        AbilityCast(FifteenTurnList)
      end
    end

    -- Damage in three turn
    DelayThreeTurn = nil
    function DelayThreeTurn()
      if NmeactivePetSlot ~= 3 then
        AbilityCast(ThreeTurnList)
      end
    end

    -- Damage in one turn.
    DelayOneTurn = nil
    function DelayOneTurn()
      if not ( NmeactivePetSlot == 3 and NmeactivePetHP <= 30 ) then
        AbilityCast(OneTurnList)
      end
    end

    -- Execute if enemi pet is under 30%.
    Execute = nil
    function Execute()
      if NmePetPercent <= 60
        and not Immunity() then
        AbilityCast(ExecuteList)
      end
    end

    -- Buffs that heal us.
    HoTBuff = nil
    function HoTBuff()
      if PetHP < ( PetHealValue + 10 )
        and not ( nmePetHP < 40 and enemyPetSlot == 3 ) then
        for i = 1, #HoTList do
          for j = 1, #HoTBuffList do
            local Poke_Ability = HoTBuffList[j]
            if not IsBuffed(Poke_Ability, 2) then
              AbilitySpam(Poke_Ability)
            end
          end
        end
      end
    end

    -- Suicide if under 20% Health.
    Kamikaze = nil
    function Kamikaze()
      if PetHP < 20
        and not Immunity() then
        AbilityCast(KamikazeList)
      end
    end

    LastStand = nil
    function LastStand()
      if PetHP < 25 then
        AbilityCast(LastStandList)
      end
    end

    LifeExchange = nil
    function LifeExchange()
      if PetHP < 35
        and nmePetHP > 70 then
        AbilityCast(LifeExchangeList)
      end
    end

    PassTurn = nil
    function PassTurn()
      if IsMultiBuffed(StunnedDebuffs, 1) then -- if we are stunned
        pokeValueFrame.valueText:SetText("Pass", 1, 1, 1, 0.7); -- skip turn
        br.data.pokeAttack = 4
        br.data.wait = 0
        rotationRun = false;
      end
    end

    -- Abilities for leveling.
    PetLeveling = nil
    function PetLeveling(HighDmgCheck)
      AbilityCast(PetLevelingList, HighDmgCheck)
    end

    -- Attack that are stronger if we are quicker.
    QuickPunch = nil
    function QuickPunch()
      if myspeed > nmespeed
        and not Immunity() then
        AbilityCast(QuickList)
      end
    end

    -- List of Buffs that we want to cast on us.
    SelfBuff = nil
    function SelfBuff()
      if activePetHP > 15
        and not ( NmePetPercent <= 40 and NmeactivePetSlot == 3 ) then
        if not IsMultiBuffed(SelfBuffList, 1) then
          AbilityCast(SelfBuffList)
        end
        for i = 1, #SpecialSelfBuffList do
          if not IsBuffed(nil, 1, SpecialSelfBuffList[i].Buff) then
            AbilitySpam(SpecialSelfBuffList[i].Ability)
          end
        end
      end
    end


    -- Direct Healing
    SimpleHealing = nil
    function SimpleHealing()
      if PetPercent < PetHealValue
        and PetHealCheck then
        AbilityCast(HealingList)
      end
    end

    SimpleHighPunch = nil
    function SimpleHighPunch(HighDmgCheck)
      if not Immunity() then
        AbilityCast(HighDMGList, HighDmgCheck)
      end
    end

    -- Basic Attacks.
    SimplePunch = nil
    function SimplePunch(HighDmgCheck)
      if HighDmgCheck ~= nil then
        AbilityCast(PunchList, HighDmgCheck)
      else
        AbilityCast(PunchList)
      end
    end

    ShieldBuff = nil
    function ShieldBuff()
      if not ( NmePetPercent <= 30
        and NmeactivePetSlot == 3 ) then
        if not IsMultiBuffed(ShieldBuffList, 1) then
          AbilityCast(ShieldBuffList)
        end
      end
    end

    SlowPunch = nil
    function SlowPunch()
      if not Immunity() then
        AbilityCast(SlowPunchList)
      end
    end

    SpeedBuff = nil
    function SpeedBuff()
      if myspeed < nmespeed then
        for i = 1, #SpeedBuffList do
          if not IsBuffed(SpeedBuffList[i], 1) then
            AbilitySpam(SpeedBuffList[i])
          end
        end
      end
    end

    SpeedDeBuff = nil
    function SpeedDeBuff()
      if NmePetPercent >= 45
        and myspeed < nmespeed
        and myspeed > ( 3 * nmespeed / 4 ) then
        for i = 1, #SpeedDeBuffList do
          if not IsBuffed(SpeedDeBuffList[i], 2) then
            AbilitySpam(SpeedDeBuffList[i])
          end
        end
      end
    end

    Stun = nil
    function Stun()
      if not Immunity() then
        AbilityCast(StunList)
      end
    end

    Soothe = nil
    function Soothe()
      AbilityCast(SootheList)
    end

    TeamDebuff = nil
    function TeamDebuff()
      if not ( NmeactivePetSlot == 3
        and NmePetPercent <= 55 ) then
        for i = 1, #TeamDebuffList do
          local found = false

          for j = 1, ( C_PetBattles.GetNumAuras(2, 0) or 0 ) do
            local auraID = C_PetBattles.GetAuraInfo(2, 0, j)
            if auraID == ( TeamDebuffList[i] - 1 ) then
              found = true
            end
          end

          if not found then
            AbilitySpam(TeamDebuffList[i])
          end

          --for i = 1, #SpecialTeamDebuffsList do
          --	if not IsBuffed(nil, 2, SpecialTeamDebuffsList[i].Debuff) then
          --		AbilitySpam(SpecialTeamDebuffsList[i].Ability)
          --	end
          --end

        end
      end
    end

    TeamHealBuffs = nil
    function TeamHealBuffs()
      if PetHP < PetHealValue
        and not ( nmePetHP < 40 and enemyPetSlot == 3 ) then
        for i = 1, #TeamHealBuffsAbilities do

          local found = false
          for j = 1, #TeamHealBuffsList do


            for k = 1, ( C_PetBattles.GetNumAuras(1,0) or 0 ) do

              local auraID = C_PetBattles.GetAuraInfo(1, 0, k)
              if auraID == TeamHealBuffsList[j] then
                found = true
              end
            end
          end

          if not found then
            AbilitySpam(TeamHealBuffsAbilities[i])
          end
        end
      end
    end

    -- Abilities that last three turns that does high damage.
    ThreeTurnHighDamage = nil
    function ThreeTurnHighDamage()
      if PetHP > 60 then
        AbilityCast(ThreeTurnHighDamageList)
      end
    end

    -- Robot Turrets
    Turrets = nil
    function Turrets(HighDmgCheck)
      if WeatherID ~= 454
        and not ( NmeactivePetSlot == 3
        and NmePetPercent <= 55 ) then
        AbilityCast(TurretsList, HighDmgCheck)
      end
    end

  end

  --[[                                       Normal Rotation                                             ]]

  -- Rotation

  if inBattle and ObjectiveValue == 1 and br.data.wait == 1 and br.data.settings[br.selectedSpec].toggles["Check PokeRotation"] == 1 then
    rotationRun = true
    HealingDone = nil
    Switch();
    SimpleHealing();
    CapturePet();
    PassTurn();
    Deflect();
    Execute();
    Kamikaze();
    LastStand();
    ShieldBuff();
    LifeExchange();
    DelayFifteenTurn();
    DelayThreeTurn();
    DelayOneTurn();
    TeamHealBuffs();
    HoTBuff();
    HighDamageIfBuffed();
    SelfBuff();
    DamageBuff();
    SpeedDeBuff();
    AoEPunch();
    ThreeTurnHighDamage();
    Turrets(1);
    SimpleHighPunch(1);
    SimplePunch(1);
    SimpleHighPunch(2);
    DeBuff();
    Soothe();
    Stun();
    TeamDebuff();
    Turrets(2);
    SpeedBuff();
    QuickPunch();
    Comeback();
    SimplePunch(2);
    Turrets(3);
    SimpleHighPunch(3);
    SimplePunch(3);
    rotationRun = false;
  end
end


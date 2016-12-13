function PokeUI()

  if not PokeUILoaded then
    PokeUILoaded = true;
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

  PlayerBuffDisplay();
  EnnemyBuffDisplay();
  if br.data.pokeValueanchor == nil then br.data.pokeValueanchor = "CENTER" end
  if br.data.pokeValuex == nil then br.data.pokeValuex = 0 end
  if br.data.pokeValuey == nil then br.data.pokeValuey = 0 end

end

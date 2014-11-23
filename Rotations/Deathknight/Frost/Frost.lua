if select(3, UnitClass("player")) == 6 then
  function FrostDK()
    if currentConfig ~= "Frost Chumii" then
      FrostOptions();
      FrostToggles();
      currentConfig = "Frost Chumii";
    end
    ------------------------------------------------------------------------------------------------------
    -- Locals --------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    local runicPower, runesBlood, runesUnholy, runesFrost, runesDeath = UnitPower("player"), getRunes("blood"), getRunes("unholy"), getRunes("frost"), getRunes("death")
    -- Food/Invis Check
    if canRun() ~= true or UnitInVehicle("Player") then return false; end
    if IsMounted("player") then return false; end
    ------------------------------------------------------------------------------------------------------
    -- Keys ----------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    -- Pause Key
    if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
    if isChecked("DnD_Key") and SpecificToggle("DnD_Key") == true then
      if not IsMouselooking() then
        CastSpellByName(GetSpellInfo(43265))
        if SpellIsTargeting() then
            CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
            return true;
        end
      end
    end
    ------------------------------------------------------------------------------------------------------
    -- Combat --------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isInCombat("player") then
    ------------------------------------------------------------------------------------------------------
    -- Dummy Test ----------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
      if isChecked("DPS Testing") then
        if UnitExists("target") then
          if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
            StopAttack()
            ClearTarget()
            print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
          end
        end
      end
    ------------------------------------------------------------------------------------------------------
    -- Single Target -------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
      if not useAoE() then
        if getHP("player") < 60 then
          if castSpell("target",_DeathStrike) then
            return;
          end
        end
        if not UnitDebuffID("target",_FrostFever,"player") then
          if castSpell("target",_HowlingBlast,false,false) then
            return;
          end
        end
        if not UnitDebuffID("target",_BloodPlague,"player") then
          if castSpell("target",_PlagueStrike,false,false) then
            return;
          end
        end
        if castSpell("target",_Obliterate,false,false) then
          return;
        end
        if castSpell("target",_FrostStrike,false,false) then
          return;
        end
        if UnitBuffID("player",_Rime) then
          if castSpell("target",_HowlingBlast,false,false) then
            return;
          end
        end
      end -- Single Target end

      if useAoE() then
        if getHP("player") < 60 then
          if castSpell("target",_DeathStrike) then
            return;
          end
        end
        if castSpell("target",_HowlingBlast,false,false) then
          return;
        end
        -- if not canCast(_DeathAndDecay) then
          if castSpell("target",_PlagueStrike,false,false) then
            return;
          end
        -- end
        if castSpell("target",_FrostStrike,false,false) then
          return;
        end
        if castSpell("target",_PlagueLeech,false,false) then
          return;
        end
      end -- Multi Target end
    end -- Combat end
  end -- FrostDK() end
end -- Class Select end
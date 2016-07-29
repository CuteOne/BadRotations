if select(3, UnitClass("player")) == 7 then
  -- Rotation
  function nRestoration()
    if currentConfig ~= "Restoration CodeMyLife" then
      RestorationConfig();
      RestorationToggles();
      currentConfig = "Restoration CodeMyLife";
    end

    -- Food/Invis Check
    if canRun() ~= true or UnitInVehicle("Player") then return false; end


    --[[Lowest]]
    lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, averageHealth = 100, "player", 100, "player", 0;
    for i = 1, #bb.friend do
      if bb.friend[i].role == "TANK" then
        if bb.friend[i].hp < lowestTankHP then
          lowestTankHP = bb.friend[i].hp;
          lowestTankUnit = bb.friend[i].unit;
        end
      end
      if bb.friend[i].hp < lowestHP then
        lowestHP = bb.friend[i].hp;
        lowestUnit = bb.friend[i].unit;
      end
      averageHealth = averageHealth + bb.friend[i].hp;
    end
    averageHealth = averageHealth/#bb.friend;

    -- Wind Shear
    if isChecked("Wind Shear") and UnitAffectingCombat("player") == true then
      if canInterrupt(_WindShear, tonumber(bb.data["Box Wind Shear"])) and getDistance("player","target") <= 25 then
        castSpell("target",_WindShear,false,false);
      end
    end

    --[[ 	-- On GCD After here
]]

    if castingUnit("player") then return false; end

    -- Astral Shift if < 30%
    if isChecked("Astral Shift") and getHP("player") <= getValue("Astral Shift") then
      if castSpell("player",_AstralShift,true) then return; end
    end
    -- Healing Stream if < 50%
    if isChecked("Healing Stream") and averageHealth <= getValue("Healing Stream") then
    --if castSpell("player",_HealingStream,true) then return; end
    end

    -- Shamanistic Rage if < 80%
    if isChecked("Shamanistic Rage") and getHP("player") <= getValue("Shamanistic Rage") then
      if castSpell("player",_ShamanisticRage,true) then return; end
    end

    -- Earthliving Weapon
    if isChecked("Earthliving Weapon") and GetWeaponEnchantInfo() ~= 1 then
      if castSpell("player",_EarthlivingWeapon,true) then return; end
    end

    -- Water Shield
    if isChecked("Water Shield") and UnitBuffID("player",_WaterShield) == nil and UnitBuffID("player",_EarthShield) == nil then
      if castSpell("player",_WaterShield,true,false) then return; end
    end



    --[[ 	-- Combats Starts Here
]]

    -- Earth Shield
    EarthShield()

         -- Pause when in Ghost Wolf Form
      if UnitBuffID("player",2645) ~= nil then return; end

      -- Healing Rain
      if canCast(_HealingRain,false,true) then
        if castHealGround(_HealingRain,18,80,3) then return; end
      end

      -- Mana Tide Totem
      if getMana("player") <= getValue("Mana Tide") then
        if castSpell("player",_ManaTide,true) then return; end
      end

      -- Healing Tide Totem
      if averageHealth <= getValue("Healing Tide") then
        if castSpell("player",_HealingTide,true) then return; end
      end

      -- Spirit Link Totem

      -- Purify Spirit
      for i = 1, #bb.friend do
        if bb.friend[i].dispel == true then
          if castSpell(bb.friend[i].unit, _PurifySpirit,true) then return; end
        end
      end

      -- Totemic Projection

      -- Chain Heal
      for i = 1, #bb.friend do
        if bb.friend[i].hp < getValue("Chain Heal") then
          local allies15Yards = getAllies(bb.friend[i].unit,15)
          if #allies15Yards >= 3 then
            local count = 0;
            for i = 1, #allies15Yards do
              if getHP(allies15Yards[i]) < getValue("Chain Heal") then
                count = count + 1
              end
            end
            if count > 3 then
              if castSpell(bb.friend[i].unit,_ChainHeal,true) then return; end
            end
          end
        end
      end

      -- Healing Stream Totem

      -- Healing Surge
      for i = 1, #bb.friend do
        if bb.friend[i].hp <= getValue("Healing Surge") then
          if castSpell(bb.friend[i].unit,_HealingSurge,true) then return; end
        end
      end

      -- Riptide
      for i = 1, #bb.friend do
        if bb.friend[i].hp <= 90 and getBuffRemain(bb.friend[i].unit,_Riptide) < 3 then
          if castSpell(bb.friend[i].unit,_Riptide,true) then return; end
        end
      end


      -- Healing Wave
      for i = 1, #bb.friend do
        if bb.friend[i].hp <= getValue("Healing Wave") then
          if castSpell(bb.friend[1].unit,_HealingWave,true) then return; end
        end
      end

      

      --Lightning Bolt if glyphed
      if hasGlyph(55453) == true and UnitCanAttack("target", "player") then
        if castSpell("target",_LightningBolt,false) then return; end
      end
   
  end
end

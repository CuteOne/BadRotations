if select(3, UnitClass("player")) == 7 then
    function cRestoration:RestorationKuu() 
        RestorationToggles();

        -------------
        ---Locals ---
        -------------
        local buff              = self.buff
        local inCombat          = self.inCombat
        local averageHealth     = 0
        
        for i = 1, #nNova do
          if UnitIsDeadOrGhost(nNova[i].unit) or getDistance(nNova[i].unit) > 40 then 
            nNova[i].hp = 100 
          end
          averageHealth = averageHealth + nNova[i].hp;
        end
        averageHealth = averageHealth/#nNova;

        if averageHealth < 80 and (isCastingSpell(self.spell.lavaBurst,"target") or isCastingSpell(self.spell.lightningBolt,"target")) then
          RunMacroText("/stopcasting")
        end
        --------------------
        --- Action Lists ---
        --------------------
        -- Action List - Extras
        local function actionList_Extras()
          -- Earth Shield
          -- We look if someone in Nova have our shield
          local foundShield = false
          if isChecked("Earth Shield") then
            for i = 1, #nNova do
              if self.charges.earthShield > 2 then
                if nNova[i].role == "TANK" or UnitIsUnit("focus",nNova[i].unit) then
                foundShield = true
                end
              end
            end
            -- if no valid shield found
            if foundShield == false then
              -- if we have focus, check if this unit have shield, if it's not ours, find another target.
              if UnitExists("focus") == true then
                if not UnitBuffID("focus", self.spell.waterShieldBuff) and not UnitBuffID("focus", self.spell.earthShieldBuff) and not UnitBuffID("focus", self.spell.lightningShieldBuff) then
                  if self.castEarthShield("focus") then print("recast focus")return end
                end
              else
              -- if focus was already buffed or is invalid then we chek nNova roles for tank.
                for i = 1, #nNova do
                  if not UnitBuffID(nNova[i].unit, self.spell.waterShieldBuff) and not UnitBuffID(nNova[i].unit, self.spell.earthShieldBuff) and not UnitBuffID(nNova[i].unit,self.spell.lightningShieldBuff) and nNova[i].role == "TANK" and nNova[i].hp < 100 then
                    if self.castEarthShield(nNova[i].unit) then return end
                  end
                end
              end
            end
          end
            -- Water Shield
          if isChecked("Water Shield") then
            if not self.buff.waterShield then
              if self.castWaterShield() then return end
            end
          end
          -- Purify Spirit
          if isChecked("Purify Spirit") then
            if getValue("Purify Spirit") == 1 then -- Mouse Match
              if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                for i = 1, #nNova do
                  if nNova[i].guid == UnitGUID("mouseover") and nNova[i].dispel == true then
                    if self.castPurifySpirit("mouseover") then return end
                  end
                end
              end
            elseif getValue("Purify Spirit") == 2 then -- Raid Match
              for i = 1, #nNova do
                if nNova[i].dispel == true then
                  if self.castPurifySpirit(nNova[i].unit) then return end
                end
              end
            elseif getValue("Purify Spirit") == 3 then -- Mouse All
              if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                for n = 1,40 do
                  local buff,_,_,count,bufftype,duration = UnitDebuff("mouseover", n)
                  if buff then
                    if bufftype == "Curse" or bufftype == "Magic" then
                      if self.castPurifySpirit("mouseover") then return end
                    end
                  else
                    break;
                  end
                end
              end
            elseif getValue("Purify Spirit") == 4 then -- Raid All
              for i = 1, #nNova do
                for n = 1,40 do
                  local buff,_,_,count,bufftype,duration = UnitDebuff(nNova[i].unit, n)
                  if buff then
                    if bufftype == "Curse" or bufftype == "Magic" then
                      if self.castPurifySpirit(nNova[i].unit) then return end
                    end
                  else
                    break;
                  end
                end
              end
            end
          end
          --Purge
          if isChecked("Purge") and canDispel("target",self.spell.purge) and not isBoss and ObjectExists("target") then
            if self.castPurge() then return end
          end
          -- Resuscitate
          if self.castAncestralSpirit() then return end
        end -- End Action List - Extras
        -- Action List - Defensive
        local function actionList_Defensive()
            -- Healthstone
            if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and inCombat then
                if canUse(5512) then
                    useItem(5512)
                end
            end
            -- Astral Shift
            if isChecked("Astral Shift") and getHP("player") <= getValue("Astral Shift") and inCombat then
              if self.castAstralShift() then return end
            end
        end -- End Action List - Defensive
        -- Action List - Interrupts
        local function actionList_Interrupts()
            -- Wind Shear
            if isChecked("Wind Shear") then
                for i=1, #getEnemies("player",25) do
                    thisUnit = getEnemies("player",25)[i]
                    if canInterrupt(thisUnit,getOptionValue("Wind Shear")) then
                        if self.castWindShear(thisUnit) then return end
                    end
                end
            end
        end -- End Action List - Interrupts
        -- Action List - Emergency Healing
        local function actionList_EmergencyHealing()
          -- Ascendance
            local ascendUnits = 0
            if isChecked("Ascendance") and inCombat then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Ascendance") and getDistance(nNova[i].unit) <= 40 then
                  ascendUnits = ascendUnits + 1
                  if ascendUnits >= getValue("Ascendance People") then
                    if self.castAscendance() then
                      ascendUnits = 0
                      return
                    end
                  end
                end
              end
            end
            -- Healing Tide Totem
            local htUnits = 0
            if isChecked("Healing Tide Totem") and inCombat then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Healing Tide Totem") and getDistance(nNova[i].unit) <= 40 then
                  htUnits = htUnits + 1
                  if htUnits >= getValue("HT Totem People") then
                    if self.castHealingTideTotem() then
                      htUnits = 0
                      return
                    end
                  end
                end
              end
            end
            -- Spirit Link Totem
            local slUnits = 0
            if isChecked("Spirit Link Totem") and inCombat then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Spirit Link Totem") and getDistance(nNova[i].unit) <= 10 then
                  slUnits = slUnits + 1
                  if slUnits >= getValue("SL Totem People") then
                    if self.castSpiritLinkTotem() then
                      slUnits = 0
                      return
                    end
                  end
                end
              end
            end
        end -- End Action List - Emergency Healing
        --Action List - Healing
        local function actionList_Healing()
           -- Healing Stream Totem
            if isChecked("Healing Stream Totem") and not self.totem.healingStreamTotem and inCombat then
              if self.castHealingStreamTotem() then return end
            end
            -- Healing Surge
            if isChecked("Healing Surge") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Healing Surge") then
                  if self.castUnleashLife() then end
                  if self.castHealingSurge(nNova[i].unit) then return end
                end
              end
            end
            -- Chain Heal
            if isChecked("Chain Heal") then
              for i = 1, #nNova do
                if nNova[i].hp < getValue("Chain Heal") then
                  local allies15Yards = getAllies(nNova[i].unit,15)
                  if #allies15Yards >= getValue("CH People") then
                    local count = 0;
                    for i = 1, #allies15Yards do
                      if getHP(allies15Yards[i]) < getValue("Chain Heal") then
                        count = count + 1
                      end
                    end
                    if count > getValue("CH People") then
                      if self.castUnleashLife() then end
                      if self.castChainHeal(nNova[i].unit) then return; end
                    end
                  end
                end
              end
            end
              -- Healing Rain
            if isChecked("Healing Rain") then
              if self.castHealingRain() then return end
            end
            --Healing Wave
            if isChecked("Healing Wave") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Healing Wave") then
                  if self.castHealingWave(nNova[i].unit) then return end
                end
              end
            end
            -- Riptide
            if isChecked("Riptide") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Riptide") then
                  if self.castRiptide(nNova[i].unit) then return end
                end
              end
            end
        end -- end function
        function actionList_Damage()
          -- Searing Totem
          if not self.totem.searingTotem and inCombat then
            if self.castSearingTotem() then return end
          end
          -- Flame Shock
          if not self.debuff.flameshock or self.debuff.duration.flameshock <= 9 then
            if self.castFlameShock("target") then return end
          end
          -- Lava Burst
          if self.castLavaBurst("target") then return end
          -- Frost Shock
          if self.castFrostShock() then return end
          -- Lightning Bolt
          if self.castLightningBoltResto("target") then return end
        end
   
---------------------
--- Begin Profile ---
---------------------
--------------
--- Extras ---
--------------
      if not UnitInVehicle("player") and not self.buff.ghostWolf then
          -- Run Action List - Extras
            if actionList_Extras() then return end
  -----------------
  --- Defensive ---
  -----------------
            if useDefensiveResto() then
          -- Run Action List - Defensive
              if actionList_Defensive() then return end
            end
      ------------------
      --- Interrupts ---
      ------------------
            if useInterruptsResto() then
      -- Run Action List - Interrupts
              if actionList_Interrupts() then return end
            end
      ----------------------
      --- Start Rotation ---
      ----------------------
            if useCDsResto() then
      -- Call Action List - Emergency Healing
              if actionList_EmergencyHealing() then return end
            end
            if useHealing() then
      -- Call Action List - Healing
              if actionList_Healing() then return end
            end
            if useDamageResto() and averageHealth >= 80 then
              if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_Damage() then return end
              end
            end
        end
    end -- End cResto
end -- End Select Shaman

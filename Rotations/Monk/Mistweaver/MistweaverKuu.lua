if select(2, UnitClass("player")) == "MONK" then
    function cMistweaver:MistweaverKuu() 
        MistweaverToggles()

        -------------
        ---Locals ---
        -------------
        local inCombat          = self.inCombat
        local stacks            = self.getBuffStacks
        local charges           = self.charges
        local buff              = self.buff


        --------------------
        --- Action Lists ---
        --------------------
        -- Action List - Extras
        local  function actionList_Extras()
            -- Change Stance
            if isChecked("Stance") then
              if self.castChangeStance() then return end
            end
            -- Tiger's Lust/Nimble Brew
            if hasNoControl() and self.talent.tigersLust then
                if self.castTigersLust() then return end
            elseif hasNoControl() then
                if self.castNimbleBrew() then return end
            end
            -- Detox
            if isChecked("Detox") then
              if getValue("Detox") == 1 then -- Mouse Match
                if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                  for i = 1, #nNova do
                    if nNova[i].guid == UnitGUID("mouseover") and nNova[i].dispel == true then
                      if self.castDetox("mouseover") then return end
                    end
                  end
                end
              elseif getValue("Detox") == 2 then -- Raid Match
                for i = 1, #nNova do
                  if nNova[i].dispel == true then
                    if self.castDetox(nNova[i].unit) then return end
                  end
                end
              elseif getValue("Detox") == 3 then -- Mouse All
                if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                  for n = 1,40 do
                    local buff,_,_,count,bufftype,duration = UnitDebuff("mouseover", n)
                    if buff then
                      if bufftype == "Magic" or bufftype == "Disease" or bufftype == "Poison" then
                        if self.castDetox("mouseover") then return end
                      end
                    else
                      break;
                    end
                  end
                end
              elseif getValue("Detox") == 4 then -- Raid All
                for i = 1, #nNova do
                  for n = 1,40 do
                    local buff,_,_,count,bufftype,duration = UnitDebuff(nNova[i].unit, n)
                    if buff then
                      if bufftype == "Magic" or bufftype == "Disease" or bufftype == "Poison" then
                        if self.castDetox(nNova[i].unit) then return end
                      end
                    else
                      break;
                    end
                  end
                end
              end
            end
            -- Resuscitate
            if self.castResuscitate() then return end
            -- Legacy of the Emperor
            if not inCombat and isChecked("Legacy of the Emperor") then
                if self.castLegacyoftheEmperor() then return end
            end
            -- Summon Jade Statue
            if isChecked("Jade Serpent Statue (Left Shift)") and IsLeftShiftKeyDown() then
              if not IsMouselooking() then
                CastSpellByName(GetSpellInfo(115313))
                if SpellIsTargeting() then
                  CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
                  return true
                end
              end
            end
        end -- End Action List - Extras
        -- Action List - Defensive
        local function actionList_Defensive()
            -- Healthstone
            if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and inCombat then
                if canUse(5512) then
                    useItem(5512)
                end
            end
            -- Fortifying Brew
            if isChecked("Fortifying Brew") and getHP("player")<=getValue("Fortifying Brew") and inCombat then
                if self.castFortifyingBrew() then return end
            end
        end -- End Action List - Defensive
        -- Action List - Interrupts
        local function actionList_Interrupts()
            -- Spear Hand Strike
            if isChecked("Spear Hand Strike") then
                for i=1, #getEnemies("player",5) do
                    thisUnit = getEnemies("player",5)[i]
                    if canInterrupt(thisUnit,getOptionValue("Spear Hand Strike")) then
                        if self.castSpearHandStrike(thisUnit) then return end
                    end
                end
            end
            -- Paralysis
            if isChecked("Paralysis") then
                for i=1, #getEnemies("player",20) do
                    thisUnit = getEnemies("player",20)[i]
                    if canInterrupt(thisUnit,getOptionValue("Paralysis")) then
                        if self.castParalysis(thisUnit) then return end
                    end
                end
            end 
        end -- End Action List - Interrupts
        -- Action List - Emergency Healing
        local function actionList_EmergencyHealing()
            -- Life Cocoon
            if isChecked("Life Cocoon") and inCombat then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Life Cocoon") then
                    if self.castLifeCocoon(nNova[i].unit) then return end
                end
              end
            end 
            -- Revival
            local revivalUnits = 0
            if isChecked("Revival") and inCombat then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Revival") then
                  revivalUnits = revivalUnits + 1
                  if revivalUnits >= getValue("Revival People") then
                    if self.castRevival(nNova[i].unit) then
                      revivalUnits = 0
                      return
                    end
                  end
                end
              end
            end
        end -- End Action List - Emergency Healing
        --Action List - Healing
        local function actionList_Healing()
            --Mana Tea
            if isChecked ("Mana Tea") and getMana("player") <= getValue("Mana Tea") and charges.manaTea >= 2 then
                if self.castManaTea() then return end
            end
            --Renewing Mist
            if isChecked("Renewing Mist") then
                for i = 1, #nNova do
                  if not UnitBuffID(nNova[i].unit,self.spell.renewingMistBuff) then
                    if self.castRenewingMist(nNova[i].unit) then return end
                  end
                end
            end
            --Surging Mist
            local isSoothing = UnitChannelInfo("player") == GetSpellInfo(_SoothingMist) or nil;
            if isSoothing and isChecked("Surging Mist") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Surging Mist") then
               -- if nNova[i].hp <= 105 then
                  if self.castHealingSurgingMist(nNova[i].unit) then return end
                end
              end
            end
            --Spinning Crane Kick/RJW
            local sckUnits = 0
            if isChecked("Spinning Crane Kick") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Spinning Crane Kick") and nNova[i].distance <= 8 then
                  sckUnits = sckUnits + 1
                  if sckUnits >= 3 then
                    if self.castHealingSpinningCraneKick() then 
                      sckUnits = 0
                      return
                    end
                  end
                end
              end
            end
            -- Uplift
            local totUnits = 0
            if isChecked("Uplift") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Uplift") and buff.renewingMist then
                  totUnits = totUnits + 1
                  if totUnits >= getValue("Uplift People") then
                    if self.castUplift() then
                      totUnits = 0
                      return;
                    end
                  end
                end
              end
            end
            --Expel Harm Heal
            if isChecked("Expel Harm") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Expel Harm") then
                  if self.castHealingExpelHarm(nNova[i].unit) then return end
                end
              end
            end
             -- Enveloping Mist
            local isSoothing = UnitChannelInfo("player") == GetSpellInfo(_SoothingMist) or nil;
            if isSoothing and isChecked("Enveloping Mist") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Enveloping Mist") then
             --   if nNova[i].hp <= 105 then
                  if self.castEnvelopingMist(nNova[i].unit) then return end
                end
              end
            end
            --Soothing Mist
            if isChecked("Soothing Mist") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Soothing Mist") then
                  if self.castSoothingMist(nNova[i].unit) then return end
                end
              end
            end 
            -- Chi Wave
            if isChecked("Chi Wave") then
              for i = 1, #nNova do
                if nNova[i].hp <= getValue("Chi Wave") then
                    if self.castHealingChiWave(nNova[i].unit) then return end
                end
              end
            end 
        end
---------------------
--- Begin Profile ---
---------------------
--------------
--- Extras ---
--------------
        -- Run Action List - Extras
            if actionList_Extras() then return end
-----------------
--- Defensive ---
-----------------
          if useDefensiveMist() == true then
        -- Run Action List - Defensive
            if actionList_Defensive() then return end
          end
    ------------------
    --- Interrupts ---
    ------------------
          if useInterruptsMist() then
    -- Run Action List - Interrupts
            if actionList_Interrupts() then return end
          end
    ----------------------
    --- Start Rotation ---
    ----------------------
          if useCDsMist() then
    -- Call Action List - Emergency Healing
            if actionList_EmergencyHealing() then return end
          end
          if useHealing() then
    -- Call Action List - Healing
            if actionList_Healing() then return end
          end
    end -- End cMistweaver
end -- End Select Monk
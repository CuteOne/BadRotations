if select(2, UnitClass("player")) == "MONK" then
    function cMistweaver:MistweaverKuu() 
        MistweaverToggles()

        -------------
        ---Locals ---
        -------------
        local buff              = self.buff
        local charges           = self.charges
        local inCombat          = self.inCombat
        local isSoothing        = UnitChannelInfo("player") == GetSpellInfo(_SoothingMist) or nil
        local myStance          = GetShapeshiftForm()
        local reMBuffed         = 0
        local lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, averageHealth = 100, "player", 100, "player", 0;
        
        for i = 1, #bb.friend do
          if UnitIsDeadOrGhost(bb.friend[i].unit) or getDistance(bb.friend[i].unit) > 40 then 
            bb.friend[i].hp = 100 
          end
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

        --------------------
        --- Action Lists ---
        --------------------
        -- Action List - Extras
        local  function actionList_Extras()
          -- Change Stance
          if isChecked("Stance") then
            if self.castChangeStance() then end
          end
          -- Tiger's Lust/Nimble Brew
          if isChecked("Control") then
            if hasNoControl() and self.talent.tigersLust then
                if self.castTigersLust() then end
            elseif hasNoControl() then
                if self.castNimbleBrew() then end
            end
          end  
          -- Detox
          if isChecked("Detox") then
            if getValue("Detox") == 1 then -- Mouse Match
              if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                for i = 1, #bb.friend do
                  if bb.friend[i].guid == UnitGUID("mouseover") and bb.friend[i].dispel == true then
                    if self.castDetoxMist("mouseover") then end
                  end
                end
              end
            elseif getValue("Detox") == 2 then -- Raid Match
              for i = 1, #bb.friend do
                if bb.friend[i].dispel == true then
                  if self.castDetoxMist(bb.friend[i].unit) then end
                end
              end
            elseif getValue("Detox") == 3 then -- Mouse All
              if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
                for n = 1,40 do
                  local buff,_,_,count,bufftype,duration = UnitDebuff("mouseover", n)
                  if buff then
                    if bufftype == "Magic" or bufftype == "Disease" or bufftype == "Poison" then
                      if self.castDetoxMist("mouseover") then end
                    end
                  else
                    break;
                  end
                end
              end
            elseif getValue("Detox") == 4 then -- Raid All
              for i = 1, #bb.friend do
                for n = 1,40 do
                  local buff,_,_,count,bufftype,duration = UnitDebuff(bb.friend[i].unit, n)
                  if buff then
                    if bufftype == "Magic" or bufftype == "Disease" or bufftype == "Poison" then
                      if self.castDetoxMist(bb.friend[i].unit) then end
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
          if isChecked("Legacy of the Emperor") then
              if self.castLegacyoftheEmperor() then end
          end
          -- Summon Jade Statue
          if isChecked("Jade Serpent Statue (Left Shift)") and IsLeftShiftKeyDown() and (IsInRaid() or UnitInParty("player") or inCombat) then
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
                    return
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
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Life Cocoon") then
                    if self.castLifeCocoon(bb.friend[i].unit) then return end
                end
              end
            end 
            -- Revival
            local revivalUnits = 0
            if isChecked("Revival") and inCombat then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Revival") then
                  revivalUnits = revivalUnits + 1
                  if revivalUnits >= getValue("Revival People") then
                    if self.castRevival() then
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
          if myStance == 1 then
            --Mana Tea
            if isChecked("Mana Tea") and getMana("player") <= getValue("Mana Tea") and lowestHP > 50 then
              if self.castManaTea() then end
            end
            --ReM Tracker
            for i = 1, #bb.friend do
              if UnitBuffID(bb.friend[i].unit,self.spell.renewingMistBuff) then
                reMBuffed = reMBuffed + 1
              elseif not UnitBuffID(bb.friend[i].unit,self.spell.renewingMistBuff) and reMBuffed ~= 0 then
                  reMBuffed = reMBuffed - 1
              end 
            end
            -- Uplift
            local totUnits = 0
            if isChecked("Uplift") then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Uplift") and buff.renewingMist then
                  totUnits = totUnits + 1
                  if totUnits >= getValue("Uplift People") then
                   if upliftTimer == nil then upliftTimer = 0; end
                    if GetTime() - upliftTimer > 0.75 then
                      if self.castUplift() then
                        totUnits = 0 
                        upliftTimer = GetTime()
                        return  
                      end
                    end
                  end
                end
              end
              if upliftTimer == nil then upliftTimer = 0; end
              if self.chi.count == self.chi.max and GetTime() - upliftTimer > 0.75 and inCombat then
                if self.castUplift() then return end
                upliftTimer = GetTime()
              end
            end
            -- Enveloping Mist
            if isSoothing and isChecked("Enveloping Mist") then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Enveloping Mist") and (currentTarget == bb.friend[i].guid) then
             --   if bb.friend[i].hp <= 105 then
                  if self.castEnvelopingMist(bb.friend[i].unit) then return end
                end
              end
            end
            --Renewing Mist
            if isChecked("Renewing Mist") and not isSoothing and (averageHealth > 80 or reMBuffed < 5) then
              for i = 1, #bb.friend do
                if not UnitBuffID(bb.friend[i].unit,self.spell.renewingMistBuff) then
                  if self.castRenewingMist(bb.friend[i].unit) then return end
                end
              end
            end
            --Surging Mist
            if isChecked("Surging Mist") and isSoothing then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Surging Mist") and (currentTarget == bb.friend[i].guid) then
               -- if bb.friend[i].hp <= 105 then
                  if self.castHealingSurgingMist(bb.friend[i].unit) then return end
                end
              end
            end
            --Spinning Crane Kick/RJW
            local sckUnits = 0
            if isChecked("Spinning Crane Kick") and getMana("player") > 35 then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Spinning Crane Kick") and bb.friend[i].distance <= 8 then
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
             --Expel Harm Heal
            if isChecked("Expel Harm") then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Expel Harm") then
                  if self.castHealingExpelHarm(bb.friend[i].unit) then return end
                end
              end
            end
            --Soothing Mist
            if isChecked("Soothing Mist") then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Soothing Mist") then
                  if self.castSoothingMist(bb.friend[i].unit) then return end
                elseif isSoothing and currentTarget == bb.friend[i].guid then
                  if bb.friend[i].hp >= getValue("Soothing Mist") then
                    RunMacroText("/stopcasting") return 
                  end
                end
              end
            end 
            -- Chi Wave
            if isChecked("Chi Wave") and not isSoothing then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Chi Wave") then
                  if self.castHealingChiWave(bb.friend[i].unit) then return end
                end
              end
            end 
            --Chi Brew
            if chiTimer == nil then chiTimer = 0; end
            if self.charges.chiBrew == 2 and GetTime() - chiTimer > 1 then
              if self.castChiBrew() then return end
              chiTimer = GetTime()
            end
          end -- end stance check
        end -- end function
        function actionList_Damage()
          if myStance == 2 then
              --Mana Tea
            if isChecked("Mana Tea") and getMana("player") <= getValue("Mana Tea") and charges.manaTea >= 2 then
                if self.castManaTea() then return end
            end
            --Surging Mist
            if self.charges.vitalMists == 5 then
              for i = 1, #bb.friend do
                if bb.friend[i].hp < 100 then
                  if self.castSurgingMist(bb.friend[i].unit) then return end
                end
              end
            end
            -- Chi Wave
            if isChecked("Chi Wave") then
              for i = 1, #bb.friend do
                if bb.friend[i].hp <= getValue("Chi Wave") then
                  if self.castHealingChiWave(bb.friend[i].unit) then return end
                end
              end
            end 
            --Expel Harm
            if isChecked("Expel Harm") and inCombat then
              for i = 1, #bb.friend do
                if self.castHealingExpelHarm(bb.friend[i].unit) then return end
              end
            end
            -- Tiger Palm
            if not self.buff.tigerPower then
              if self.castTigerPalm() then return end
            end
            -- Blackout Kick
            if not self.buff.craneZeal or self.charges.risingSunKick == 0 then
              if self.castBlackoutKick() then return end
            end
            -- Rising Sun Kick
            if self.chi.count >= 2 then
              CastSpellByName(GetSpellInfo(107428)) return 
            end
            -- Jab
            if self.castJab() then return end
          end
        end
   
---------------------
--- Begin Profile ---
---------------------
--------------
--- Extras ---
--------------
		  if not UnitInVehicle("player") then
	        -- Run Action List - Extras
	          actionList_Extras() 

	-----------------
	--- Defensive ---
	-----------------
	          if useDefensiveMist() == true then
	        -- Run Action List - Defensive
	            actionList_Defensive() 
	          end
      ---------------------
      --- Emerg Healing ---
      ---------------------      
            if useCDsMist() then
            -- Run Action List - Emergency Healing
              actionList_EmergencyHealing()
            end
	    ------------------
	    --- Interrupts ---
	    ------------------
	          if useInterruptsMist() then
	          -- Run Action List - Interrupts
	            actionList_Interrupts() 
	          end
	    ----------------------
	    --- Start Rotation ---
	    ----------------------
	          if useHealing() and (IsInRaid() or UnitInParty("player") or inCombat) then
	          -- Run Action List - Healing
	            actionList_Healing() 
	          end
	          if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
            -- Run Action List - Damage
	          	actionList_Damage() 
	          end
	      end
    end -- End cMistweaver
end -- End Select Monk
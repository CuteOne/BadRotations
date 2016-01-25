if select(2, UnitClass("player")) == "WARLOCK" then
    function cDestruction:DestructionKuu()
    
       DestructionToggles()
		local inCombat          = self.inCombat        
    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Dark Intent
            if isChecked("Dark Intent") then
                if self.castDarkIntent() then return end
            end
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if combatTime >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and inCombat then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healthPot) then
                        useItem(healthPot)
                    end
                end
        -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
            end -- End Interrupt Check
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
            end -- End No Combat Check
        end --End Action List - Pre-Combat
    -- Action list - Opener
        function actionList_Opener()
        end -- End Action List - Opener
    -- Action List - Single Target
        function actionList_SingleTarget()
        	-- Immolate
        	for i=1, #getEnemies("player",40) do
    	        if not self.debuff.immolate then
    	        	local thisUnit = getEnemies("player",40)[i]
    	        	local hasThreat = hasThreat(thisUnit)
    	        	if hasThreat then
        	        	if self.castImmolate(thisUnit) then return end
        	        end
            	end
	        end
	        -- Chaos Bolt
	        if self.castChaosBolt(self.units.dyn40) then return end
	        -- Incinerate
        	if self.castIncinerate(self.units.dyn40) then return end
        end -- End Action List - Single Target
    
---------------------
--- Begin Profile ---
---------------------
    -- Pause
    --    if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) then
--            return true
  --      else
--------------
--- Extras ---
--------------
    -- Run Action List - Extras
            if actionList_Extras() then return end
-----------------
--- Defensive ---
-----------------
    -- Run Action List - Defensive
                if actionList_Defensive() then return end
------------------
--- Pre-Combat ---
------------------
    -- Run Action List - Pre-Combat
                if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                    if actionList_PreCombat() then return end
                end
-----------------
--- In Combat ---
-----------------
                if inCombat then
    ------------------
    --- Interrupts ---
    ------------------
    -- Run Action List - Interrupts
                    if actionList_Interrupts() then return end
    ----------------------
    --- Start Rotation ---
    ----------------------
    -- Call Action List - Opener
                  
                    if actionList_Opener() then return end
    -- Call Action List - Single Target
                  
                    if actionList_SingleTarget() then return end
                end -- End Combat Check 
--        end -- End Pause
    end -- End Rotation Function
end -- End Class Check

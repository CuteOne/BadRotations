
if select(2, UnitClass("player")) == "WARLOCK" then
    function cDestruction:DestructionTest()
    
       DestructionToggles()
		local inCombat          = self.inCombat 
        local canFlask          = canUse(self.flask.wod.intellectBig) 
        local combatTime        = getCombatTime()
        local solo              = select(2,IsInInstance())=="none"     
        local t17_2pc           = self.eq.t17_2pc
        local lastPet           = lastPet or 0
        local threats           = threats or 0
        local trinketProc       = self.hasTrinketProc()
        local immolateTimer     = immolateTimer or 0  
        local FnBTimer          = FnBTimer or 0 
        local conflagrateTimer  = conflagrateTimer or 0
        local enemy40y   = getEnemies("player",40)
        local enemiesAroundTarget10y = getEnemies("target", 10)
    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
        function actionList_Extras()
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
        -- Dark Intent
            if isChecked("Dark Intent") then
                if self.castDarkIntent() then end
            end
         -- Summon Pet
            if self.summonDemon() then end
            --actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled&!talent.demonic_servitude.enabled
            if self.talent.grimoireofSacrifice and not self.talent.demonicServitude and UnitExists("pet") then
                if self.castGrimoireofSacrifice() then end
            end
            if self.buff.fireandBrimstoneBuff and self.ember.count < 2 then
                if GetTime() - FnBTimer > 0.75 then
                   if self.castFireandBrimstone() then FnBTimer = GetTime() end
                end
            end
        -- Soulstone
            if isInCombat("player") and isStanding(0.3) and UnitIsDeadOrGhost("mouseover")
              and UnitIsFriend("player","mouseover") and getSpellCD(20707) == 0 then
                CastSpellByName(GetSpellInfo(20707),"mouseover")
                return
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            -- Pot/Stoned
            if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and inCombat then
                if canUse(5512) then
                    useItem(5512)
                end
            end
            -- Heirloom Neck
            if isChecked("Heirloom Neck") and getHP("player") <= getValue("Heirloom Neck") then
                if hasEquiped(122668) then
                    if GetItemCooldown(122668)==0 then
                        useItem(122668)
                    end
                end
            end
            -- Ember Tap
            if isChecked("Ember Tap") and getHP("player") <= getValue ("Ember Tap") and inCombat then
                if self.castEmberTap() then return end
            end
            -- Unending Resolve
            if isChecked("Unending Resolve") and getHP("player") <= getValue("Unending Resolve") and inCombat then
                if self.castUnendingResolve() then return end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            -- Shadowfury
            if isChecked("Shadowfury") then
                for i=1, #getEnemies("player",30) do
                    thisUnit = getEnemies("player",30)[i]
                    if canInterrupt(thisUnit,getOptionValue("Shadowfury")) then
                        if self.castShadowFury(thisUnit) then return end
                    end
                end
            end
            if isChecked("Spell Lock") then
                for i=1, #getEnemies("player",30) do
                    thisUnit = getEnemies("player",30)[i]
                    if canInterrupt(thisUnit,getOptionValue("Spell Lock")) then
                        if self.castSpellLock(thisUnit) then return end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
                -- Flask
                -- flask,type=warm_sun
                if isChecked("Flask/Crystal") then
                    if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
                        useItem(self.flask.wod.intellectBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if self.useCrystal() then return end
                    end
                end
                --actions.precombat+=/incinerate
                if self.castIncinerate("target") then end
                -- Food 
                -- food,type=type=mogu_fish_stew
            end -- End No Combat Check
        end --End Action List - Pre-Combat
    -- Action list - Opener
        function actionList_Cooldowns()
            --actions=summon_doomguard,if=!talent.demonic_servitude.enabled&spell_targets.infernal_awakening<9
            if not self.talent.demonicServitude and self.enemies.yards40 < 9 then
                if self.castSummonDoomGuard("target") then end
            end
            --actions+=/summon_infernal,if=!talent.demonic_servitude.enabled&spell_targets.infernal_awakening>=9
            if not self.talent.demonicServitude and self.enemies.yards40 >= 9 then
                if self.castSummonInfernal("target") then end
            end
            --actions+=/berserking
            --actions+=/blood_fury
            --actions+=/arcane_torrent
            if (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
                if self.castRacial() then end
            end
            --actions+=/mannoroths_fury
            if self.talent.mannsFury then
                if self.castMannsFury() then end
            end
            --actions+=/dark_soul,if=!talent.archimondes_darkness.enabled|(talent.archimondes_darkness.enabled&(charges=2|target.time_to_die<40|trinket.proc.any.react|trinket.stacking_proc.any.react))
            if not self.talent.archiesDarkness or (self.talent.archiesDarkness and (self.charges.darkSoulInstability == 2 or getTimeToDie("target")<40 or trinketProc)) and not self.buff.darkSoulInstability then
                if dsTimer == nil then dsTimer = 0; end
                if GetTime() - dsTimer > 0.75 then
                   if self.castDarkSoulInstability() then dsTimer = GetTime() end
                end
            end
            --actions+=/service_pet,if=talent.grimoire_of_service.enabled&(target.time_to_die>120|target.time_to_die<=25|(buff.dark_soul.remains&target.health.pct<20))
            if self.talent.grimoireofService and (getTimeToDie("target")> 120 or getTimeToDie("target") <=25 or(self.buff.darkSoulInstability and getHP(self.units.dyn40) < 20)) then
                if self.castGrimoireFel(self.units.dyn40) then end
            end
        end -- End Action List - Cooldowns
    -- Action List - Single Target
        function actionList_SingleTarget()
            if  #enemiesAroundTarget10y == 1 then -- One Enemy
                if self.buff.fireandBrimstoneBuff then
                    if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                end
                --Shadowburn
                if getHP("target") < 20 and ((self.ember.count < 2 and not self.talent.charredRemains) or (self.ember.count < 2.5 and self.talent.charredRemains) or self.buff.darkSoulInstability) and getTimeToDie("target") <= 5 and not UnitDebuffID("target",self.spell.shadowburnDebuff,"player") and ObjectIsFacing("player","target") then
                   if self.castShadowburn("target") then return end
                end   
                -- Immolate
                if hasThreat("target") and ((getDebuffRemain("target",self.spell.immolateDebuff,"player") <= select(4,GetSpellInfo(self.spell.immolate))/1000)) and (self.cd.cataclysm > select(4,GetSpellInfo(self.spell.immolate))/1000 or not self.talent.cataclysm) and ObjectIsFacing("player","target") and not isMoving("player") then
                    if lastImmolateTarget ~= UnitGUID("target") and lastImmolateTime+5 < GetTime() then
                            if self.castImmolate("target") then return end
                    end
                end
                -- Conflagrate
                if self.charges.conflagrate == 2 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                 -- Cataclysm
                if self.cd.cataclysm == 0 and self.talent.cataclysm then
                    if self.castCataclysm() then return end
                end
                -- Chaos Bolt
                if ((self.ember.count > 3.5 and not self.talent.charredRemains) or (self.ember.count > 2.5 and self.talent.charredRemains) or self.buff.darkSoulInstability) and ObjectIsFacing("player","target") and hasThreat("target") then
                   if self.castChaosBolt("target") then return end
                end
                -- Conflagrate 1 Charge
                if self.charges.conflagrate == 1 then

                    if self.castConflagrate("target") then return end
                end
                -- Incinerate Filler
                if self.castIncinerate("target") then return end
            end -- One Enemy End

            if  #enemiesAroundTarget10y >= 2 and #enemiesAroundTarget10y < 4 and (self.talent.demonicServitude or self.talent.cataclysm) then -- 2 to 4 enemies with DS or Cata
                if self.buff.fireandBrimstoneBuff then
                    if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                end
                -- Cataclysm
                if self.cd.cataclysm == 0 then
                    if self.castCataclysm() then return end
                end
                --Shadowburn
                for i = 1, #enemy40y do
                    local thisUnit = enemy40y[i]
                    if getHP(thisUnit) < 20 and (self.ember.count < 3.5 or self.buff.darkSoulInstability) and getTimeToDie(thisUnit) <= 25 and not UnitDebuffID(thisUnit,self.spell.shadowburnDebuff,"player") and ObjectIsFacing("player",thisUnit) then
                        local sbtarget = thisUnit
                        for i = 1, #enemy40y do
                            local havocUnit = enemy40y[i]
                            if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,sbtarget) and not self.buff.havoc then
                                if self.castHavoc(havocUnit) then end
                            end
                        end
                        if self.castShadowburn(sbtarget) then return end
                    end
                end
                -- Conflagrate
                if self.charges.conflagrate == 2 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Chaos Bolt
                for i = 1, #enemy40y do
                    if (self.ember.count > 3.5 or self.buff.darkSoulInstability) and ObjectIsFacing("player",thisUnit) then
                        for i = 1, #enemy40y do
                            local havocUnit = enemy40y[i]
                            if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,"target") and not self.buff.havoc and not self.buff.fireandBrimestone then
                                if self.castHavoc(havocUnit) then end
                            end
                        end
                        if self.castChaosBolt("target") then return end
                    end
                end
                -- Conflagrate 1 Charge
                if self.charges.conflagrate == 1 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Incinerate Filler
                if self.castIncinerate("target") then return end
            end -- End 2 to 4 DS Cata

            if  #enemiesAroundTarget10y == 5 and (self.talent.demonicServitude or self.talent.cataclysm) then -- 5 enemies with DS or Cata
                -- Cancel FnB
                if self.ember.count < 2 and self.buff.fireandBrimstoneBuff then
                    if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                end
                -- Cataclysm
                if self.cd.cataclysm == 0 and self.talent.cataclysm then
                    if self.castCataclysm() then return end
                end
                --Shadowburn
                for i = 1, #enemy40y do
                    local thisUnit = enemy40y[i]
                    if getHP(thisUnit) < 20 and (self.ember.count < 3.5 or self.buff.darkSoulInstability) and getTimeToDie(thisUnit) <= 25 and not UnitDebuffID(thisUnit,self.spell.shadowburnDebuff,"player") and ObjectIsFacing("player",thisUnit) then
                        local sbtarget = thisUnit
                        for i = 1, #enemy40y do
                            local havocUnit = enemy40y[i]
                            if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,sbtarget) and not self.buff.havoc then
                                if self.castHavoc(havocUnit) then end
                            end
                        end
                        if self.castShadowburn(sbtarget) then return end
                    end
                end

                -- Immolate
                if not self.buff.havoc and self.ember.count >= 3.5 and not isMoving("player") then
                    for i=1, #enemy40y do
                        local thisUnit = enemy40y[i]
                        if ObjectIsFacing("player",thisUnit) then
                            if hasThreat(thisUnit) and (getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") - select(4,GetSpellInfo(self.spell.immolate))/1000) <= getDebuffDuration(thisUnit,self.spell.immolateDebuff,"player")*0.3 then
                                if lastImmolateTarget ~= thisUnit.guid and lastImmolateTime+5 < GetTime() then
                                    if not self.buff.fireandBrimstone then
                                        if GetTime() - FnBTimer > 0.75 then
                                            if self.castFireandBrimstone() then FnBTimer = GetTime() end
                                        end
                                    end
                                    if not isCCed(thisUnit) then 
                                        if self.castImmolate(thisUnit) then end
                                    end
                                end
                            end
                        end
                    end
                    if self.buff.fireandBrimstoneBuff then
                        if self.castFireandBrimstone() then return end
                    end
                end
                -- Conflagrate
                if self.charges.conflagrate == 2 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Chaos Bolt
                for i = 1, #enemy40y do
                    local havocUnit = enemy40y[i]
                    if (self.ember.count > 3.5 or self.buff.darkSoulInstability) and ObjectIsFacing("player",havocUnit) then
                        if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,"target") and not self.buff.havoc and not self.buff.fireandBrimestone then
                            if self.castHavoc(havocUnit) then end
                        end
                        if self.castChaosBolt("target") then return end
                    end
                end
                -- Conflagrate 1 Charge
                if self.charges.conflagrate == 1 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Incinerate Filler
                if self.castIncinerate("target") then return end
            end -- End 5 DS Cata   

            if  #enemiesAroundTarget10y >= 2 and #enemiesAroundTarget10y <= 3 and self.talent.charredRemains then -- 2 or 3 enemies with Charred Remains
                if self.buff.fireandBrimstoneBuff then
                    if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                end
                --Shadowburn
               for i = 1, #enemy40y do
                    local thisUnit = enemy40y[i]
                    if getHP(thisUnit) < 20 and (self.ember.count < 2.5 or self.buff.darkSoulInstability) and getTimeToDie(thisUnit) <= 25 and not UnitDebuffID(thisUnit,self.spell.shadowburnDebuff,"player") and ObjectIsFacing("player",thisUnit) then
                        local sbtarget = thisUnit
                        for i = 1, #enemy40y do
                           local havocUnit = enemy40y[i]
                           if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,sbtarget) and not self.buff.havoc then
                               if self.castHavoc(havocUnit) then end
                           end
                        end
                        if self.castShadowburn(sbtarget) then return end
                    end
                end
                -- Immolate
                if not self.buff.havoc and not isMoving("player") then
                    for i=1, #enemy40y do
                        local thisUnit = enemy40y[i]
                        if hasThreat(thisUnit) and ((getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") <= select(4,GetSpellInfo(self.spell.immolate))/1000)) and (self.cd.cataclysm > select(4,GetSpellInfo(self.spell.immolate))/1000 or not self.talent.cataclysm) and ObjectIsFacing("player",thisUnit)then
                             if lastImmolateTarget ~= thisUnit.guid and lastImmolateTime+5 < GetTime() then
                                if not isCCed(thisUnit) then
                                    if self.castImmolate(thisUnit) then return end
                                end
                            end
                        end
                    end
                end
                -- Conflagrate
                if self.charges.conflagrate == 2 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Chaos Bolt
                for i = 1, #enemy40y do
                    local havocUnit = enemy40y[i]    
                    if (self.ember.count > 2.5 or self.buff.darkSoulInstability) and getTimeToDie(havocUnit) >= 25 and ObjectIsFacing("player",havocUnit) then
                        if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,"target") and not self.buff.havoc and not self.buff.fireandBrimstone then
                            if self.castHavoc(havocUnit) then end
                        end
                        if self.castChaosBolt("target") then return end
                    end
                end
                -- Conflagrate 1 Charge
                if self.charges.conflagrate == 1 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Incinerate Filler
                if self.castIncinerate("target") then return end
            end -- 2 or 3 CR End                     
        end -- End Action List - Single Target
    -- Action List - AoE
        function actionList_MultiTarget()
            if  #enemiesAroundTarget10y >= 6 and (self.talent.demonicServitude or self.talent.cataclysm) then -- 6+ enemies with DS or Cata
                -- Cancel FnB
                if self.ember.count < 2 and self.buff.fireandBrimstoneBuff then
                    if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                end
                -- Cataclysm
                if self.cd.cataclysm == 0 then
                    if self.castCataclysm() then return end
                end
                --Shadowburn
                for i = 1, #enemy40y do
                    local thisUnit = enemy40y[i]
                    if getHP(thisUnit) < 20 and ((self.ember.count < 3.5 and not self.talent.charredRemains) or (self.ember.count < 2.5 and self.talent.charredRemains) or self.buff.darkSoulInstability or getTimeToDie(thisUnit) <= 25) and not UnitDebuffID(thisUnit,self.spell.shadowburnDebuff,"player") and ObjectIsFacing("player",thisUnit) then
                        local sbtarget = thisUnit
                        for i = 1, #enemy40y do
                            local havocUnit = enemy40y[i]
                            if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,sbtarget) and not self.buff.havoc then
                                if self.castHavoc(havocUnit) then end
                            end
                        end
                        if self.castShadowburn(sbtarget) then return end
                    end
                end
                -- Immolate
                if not self.buff.havoc and self.ember.count >= 3.5 and not isMoving("player") then
                    for i=1, #enemy40y do
                        local thisUnit = enemy40y[i]
                        if ObjectIsFacing("player",thisUnit)  then
                            if hasThreat(thisUnit) and (getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") - select(4,GetSpellInfo(self.spell.immolate))/1000) <= getDebuffDuration(thisUnit,self.spell.immolateDebuff,"player")*0.3 then
                                if lastImmolateTarget ~= thisUnit.guid and lastImmolateTime+5 < GetTime() then
                                    if not self.buff.fireandBrimstone then
                                        if self.castFireandBrimstone() then end
                                    end
                                    if not isCCed(thisUnit) then
                                        if self.castImmolate(thisUnit) then return end
                                    end
                                end
                            end
                        end
                    end
                end
                -- Conflagrate
                if self.charges.conflagrate == 2 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Chaos Bolt
                for i = 1, #enemy40y do
                    local havocUnit = enemy40y[i]
                    if ((self.ember.count > 3.5 and not self.talent.charredRemains) or (self.ember.count > 2.5 and self.talent.charredRemains) or self.buff.darkSoulInstability) and getTimeToDie(havocUnit) >= 25 and ObjectIsFacing("player",thisUnit) then
                        for i = 1, #enemy40y do
                            if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,"target") and not self.buff.havoc and not self.buff.fireandBrimstone then
                                if self.castHavoc(havocUnit) then end
                            end
                        end
                        if self.castChaosBolt("target") then return end
                    end
                end
                -- Conflagrate 1 Charge
                if self.charges.conflagrate == 1 then
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Incinerate Filler
                if self.castIncinerate("target") then return end

            end -- End 6+ DS Cata 

            if  #enemiesAroundTarget10y >= 4 and self.talent.charredRemains then -- 4+ enemies with Charred Remains
                if self.buff.fireandBrimstoneBuff and self.ember.count < 2 then
                    if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                end
                --Shadowburn
               for i = 1, #enemy40y do
                    local thisUnit = enemy40y[i]
                    if getHP(thisUnit) < 20 and (self.ember.count < 2.5 or self.buff.darkSoulInstability) and getTimeToDie(thisUnit) <= 25 and not UnitDebuffID(thisUnit,self.spell.shadowburnDebuff,"player") and ObjectIsFacing("player",thisUnit) and not self.buff.fireandBrimstone then
                        local sbtarget = thisUnit
                        for i = 1, #enemy40y do
                           local havocUnit = enemy40y[i]
                           if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,sbtarget) and not self.buff.havoc then
                               if self.castHavoc(havocUnit) then end
                           end
                        end
                        if self.castShadowburn(sbtarget) then return end
                    end
                end
                -- Immolate
                if not self.buff.havoc and self.ember.count >= 2 and not isMoving("player") then
                    for i=1, #enemy40y do
                        local thisUnit = enemy40y[i]
                        if ObjectIsFacing("player",thisUnit) then
                            if hasThreat(thisUnit) and (getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") - select(4,GetSpellInfo(self.spell.immolate))/1000) <= getDebuffDuration(thisUnit,self.spell.immolateDebuff,"player")*0.3 then
                                 if lastImmolateTarget ~= thisUnit.guid and lastImmolateTime+5 < GetTime() then
                                    if not self.buff.fireandBrimstone then
                                        if self.castFireandBrimstone() then end
                                    end
                                    if not isCCed(thisUnit) then
                                        if self.castImmolate(thisUnit) then return end
                                    end
                                end
                            end
                        end
                    end
                end
                -- Conflagrate
                if self.charges.conflagrate == 2 then
                   if hasThreat("target") and self.ember.count >= 2 and not self.buff.havoc then
                        if not self.buff.fireandBrimstone then
                            if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                        end
                    elseif self.ember.count < 2 and not self.buff.fireandBrimstone then
                        for i = 1, #enemy40y do
                           local havocUnit = enemy40y[i]
                           if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,"target") and not self.buff.havoc and not self.buff.fireandBrimstone then
                               if self.castHavoc(havocUnit) then end
                           end
                       end
                    end
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Chaos Bolt
                if (self.ember.count > 2.5 or self.buff.darkSoulInstability) and getTimeToDie("target") >= 25 and ObjectIsFacing("player","target") then
                    if not self.buff.havoc then
                        if not self.buff.fireandBrimstone then
                            if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                        end
                        if self.castChaosBolt("target") then return end
                    end
                end
                -- Conflagrate 1 Charge
               if self.charges.conflagrate == 1 then
                   if self.ember.count >= 2 and not self.buff.havoc then
                        if not self.buff.fireandBrimstone then
                            if GetTime() - FnBTimer > 0.75 then
                        if self.castFireandBrimstone() then FnBTimer = GetTime() return end
                    end
                        end
                    elseif self.ember.count < 2 and not self.buff.fireandBrimstone then
                        for i = 1, #enemy40y do
                           local havocUnit = enemy40y[i]
                           if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,"target") and not self.buff.havoc and not self.buff.fireandBrimstone then
                               if self.castHavoc(havocUnit) then end
                           end
                       end
                    end
                    if GetTime() - conflagrateTimer > 0.5 then
                        if self.castConflagrate("target") then conflagrateTimer = GetTime() return end
                    end
                end
                -- Incinerate Filler
                if hasThreat("target") then
                    for i = 1, #enemy40y do
                           local havocUnit = enemy40y[i]
                           if hasThreat(havocUnit) and not UnitIsUnit(havocUnit,"target") and not self.buff.havoc and not self.buff.fireandBrimstone then
                               if self.castHavoc(havocUnit) then end
                           end
                    end
                    if self.castIncinerate("target") then return end
                end
            end -- 4+ CR End
        end -- End Multitarget
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
            if actionList_Extras() then end
-----------------
--- Defensive ---
-----------------
    -- Run Action List - Defensive
            if useDefensiveDestro() then
                if actionList_Defensive() then end
            end
------------------
--- Pre-Combat ---
------------------
    -- Run Action List - Pre-Combat
            if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_PreCombat() then end
            end
-----------------
--- In Combat ---
-----------------
            if inCombat then
    ------------------
    --- Interrupts ---
    ------------------
    -- Run Action List - Interrupts
                if useInterruptsDestro() then
                    if actionList_Interrupts() then end
                end
    ----------------------
    --- Start Rotation ---
    ----------------------
    -- Aquire Target if None
                if not ObjectExists("target") or UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player") then
                    if solo then
                        for i = 1, #enemy40y do
                            local thisUnit = enemy40y[i]
                            if hasThreat(thisUnit) then
                                TargetUnit(thisUnit) return
                            end
                        end
                    else
                        for i = 1, #getAllies("player", 30) do
                            local thisUnit = getAllies("player", 30)[i]
                            if  UnitGroupRolesAssigned(thisUnit) == "TANK" then
                                AssistUnit(thisUnit) return
                            end
                        end
                    end
                end
    -- Call Action List - Cooldowns      
                if useCDsDestro() then
                    if actionList_Cooldowns() then end
                end
    -- Call Action List - Single Target
                --actions+=/run_action_list,name=single_target,if=spell_targets.fire_and_brimstone<6&(!talent.charred_remains.enabled|spell_targets.rain_of_fire<4)
                for i = 1, #enemiesAroundTarget10y do
                    local thisUnit = getEnemies("player",10)[i]
                    if hasThreat(thisUnit) then
                        threats = threats + 1
                    end
                end
                if useSTDestro() then
                    if  (threats < 6 and not self.talent.charredRemains) or (threats < 4) then
                        if actionList_SingleTarget() then return end
                    end
                end
                --actions+=/run_action_list,name=aoe,if=spell_targets.fire_and_brimstone>=6|(talent.charred_remains.enabled&spell_targets.rain_of_fire>=4)
                if useAoEDestro() then
                    if (threats >= 6 and not self.talent.charredRemains) or (threats >= 4) then
                        if actionList_MultiTarget() then return end
                    end
                end
            end -- End Combat Check 
--        end -- End Pause
    end -- End Rotation Function
end -- End Class Check

if select(2, UnitClass("player")) == "MONK" then
    function cWindwalker:WindwalkerCuteOne()
        WindwalkerToggles()
        -- GroupInfo()
        -- getLoot2()
    --------------
    --- Locals ---
    --------------
        local agility           = UnitStat("player", 2)
        local baseAgility       = 0
        local baseMultistrike   = 0
        local buff              = self.buff
        local canFlask          = canUse(self.flask.wod.agilityBig)
        local castTimeFoF       = 4-(4*UnitSpellHaste("player")/100)
        local castTimeHS        = 2-(2*UnitSpellHaste("player")/100)
        local cd                = self.cd
        local charges           = self.charges
        local chi               = self.chi
        local combatTime        = getCombatTime()
        local debuff            = self.debuff
        local enemies           = self.enemies
        local flaskBuff         = getBuffRemain("player",self.flask.wod.buff.agilityBig) or 0
        local glyph             = self.glyph
        local healthPot         = getHealthPot() or 0
        local inCombat          = self.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local level             = self.level
        local multistrike       = GetMultistrike()
        local php               = self.health
        local power             = self.power
        local race              = self.race
        local racial            = self.getRacial()
        local recharge          = self.recharge
        local regen             = self.powerRegen
        local solo              = select(2,IsInInstance())=="none"
        local t17_2pc           = self.eq.t17_2pc
        local t18_2pc           = self.eq.t18_2pc 
        local t18_4pc           = self.eq.t18_4pc
        local talent            = self.talent
        local thp               = getHP(self.units.dyn5)
        local ttd               = getTimeToDie(self.units.dyn5)
        local ttm               = self.timeToMax
        
    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Death Monk mode
            if isChecked("Death Monk Mode") then
                if enemies.yards40>1 and BadBoy_data['SEF']==1 then
                    local sefEnemies = getEnemies("player",40)
                    for i=1, #sefEnemies do
                        local thisUnit                  = sefEnemies[i]
                        local guidThisUnit              = UnitGUID(thisUnit)
                        local guidTarget                = UnitGUID("target")
                        local debuffStormEarthAndFire   = UnitDebuffID(thisUnit,self.spell.stormEarthAndFireDebuff,"player")~=nil or false

                        if not debuffStormEarthAndFire and guidThisUnit~=guidTarget and charges.stormEarthAndFire<2 and UnitIsTappedByPlayer(thisUnit) then
                            if castSpell(thisUnit,self.spell.stormEarthAndFire,false,false,false) then return end
                        elseif debuffStormEarthAndFire and guidThisUnit==guidTarget then
                            CancelUnitBuff("player", GetSpellInfo(self.spell.stormEarthAndFire))
                        end
                    end
                elseif charges.stormEarthAndFire>0 and enemies.yards40<2 then
                    CancelUnitBuff("player", GetSpellInfo(self.spell.stormEarthAndFire))
                end
                if not useAoE() then
                    if power>40 then
                        if self.castJab() then return end
                    elseif chi.count>2 then
                        if self.castBlackoutKick() then return end
                    end
                else
                    if power>40 then
                        if self.level<46 then
                            if self.castJab() then return end
                        else
                            if self.castSpinningCraneKick() then return end
                        end
                    elseif chi.count>2 then
                        if self.castRisingSunKick() then return end
                    end
                end
            end -- End Death Monk Mode
        -- Stop Casting
            if ((getDistance("target")<5 or (BadBoy_data['FSK']==1 and cd.flyingSerpentKick==0)) and isCastingSpell(self.spell.cracklingJadeLightning)) or (not useAoE() and isCastingSpell(self.spell.spinningCraneKick)) then
                SpellStopCasting()
            end
        -- Cancel Storm, Earth, and Fire
            if charges.stormEarthAndFire~=0 and (not inCombat or BadBoy_data['SEF']~=1) then
                CancelUnitBuff("player", GetSpellInfo(self.spell.stormEarthAndFire))
            end
        -- Tiger's Lust
            if hasNoControl() or (inCombat and getDistance("target")>10 and ObjectExists("target") and not UnitIsDeadOrGhost("target")) then
                if self.castTigersLust() then return end
            end
        -- Detox
            if canDispel("player",self.spell.detox) then
                if self.castDetox("player") then return end
            end
            if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                if canDispel("mouseover",self.spell.detox) then
                    if self.castDetox("mouseover") then return end
                end
            end
        -- Resuscitate
            if self.castResuscitate() then return end
        -- Legacy of the White Tiger
            if not inCombat and isChecked("Legacy of the White Tiger") then
                if self.castLegacyOfTheWhiteTiger() then return end
            end
        -- Expel Harm (Chi Builer)
            if not inCombat and BadBoy_data['Builder']==1 and chi.diff>=2 then
                if self.castExpelHarm() then return end
            end
        -- Provoke
            if not inCombat and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" and cd.flyingSerpentKick>1 and getDistance("target")>10 and ObjectExists("target") then
                if solo or #nNova==1 then
                    if self.castProvoke() then return end
                end
            end
        -- Flying Serpent Kick
            if BadBoy_data['FSK']==1 and ObjectExists("target") then
                if canFSK("target") and not isDummy() and (solo or inCombat) then
                    if self.castFlyingSerpentKick() then 
                        if inCombat and usingFSK() then 
                            if self.castFlyingSerpentKickEnd() then return end
                        end
                    end
                end
                if (not ObjectIsFacing("player","target") or getRealDistance("player","target")<8) and usingFSK() then
                    if self.castFlyingSerpentKickEnd() then return end
                end
        -- Roll
                if not canFSK("target") and getRealDistance("player","target")>10 and getFacingDistance()<5 and getFacing("player","target",10) then
                    if self.castRoll() then return end
                end
            end
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if combatTime >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        CancelUnitBuff("player", GetSpellInfo(self.spell.stormEarthAndFire))
                        StopAttack()
                        ClearTarget()
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    end
                end
            end
        -- Crackling Jade Lightning
            if getDistance("target")>=8 and (BadBoy_data['FSK']==1 and cd.flyingSerpentKick>1) and chi.diff>=2 and not isCastingSpell(self.spell.cracklingJadeLightning) and isInCombat("target") and not isMoving("player") then
                if self.castCracklingJadeLightning() then return end
            end
        -- Touch of the Void
            if (useCDs() or useAoE()) and isChecked("Touch of the Void") and inCombat and getDistance(self.units.dyn5)<5 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
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
        --  Expel Harm
                if isChecked("Expel Harm") and php<=getValue("Expel Harm") then
                    if (inCombat and chi.diff>=2) or not inCombat then
                        if self.castExpelHarm() then return end
                    end
                end
        -- Surging Mist
                if isChecked("Surging Mist") and php<=getValue("Surging Mist") and not inCombat then
                    if self.castSurgingMist() then return end
                end
        -- Touch of Karma
                if isChecked("Touch of Karma") and php<=getValue("Touch of Karma") and inCombat then
                    if self.castTouchOfKarma() then return end
                end
        -- Fortifying Brew
                if isChecked("Fortifying Brew") and php<=getValue("Fortifying Brew") and inCombat then
                    if self.castFortifyingBrew() then return end
                end
        -- Diffuse Magic
                if isChecked("Diffuse/Dampen") and (php<=getValue("Diffuse Magic") and inCombat) or canDispel("player",self.spell.diffuseMagic) then
                    if self.castDiffuseMagic() then return end
                end
        -- Dampen Harm
                if isChecked("Diffuse/Dampen") and php<=getValue("Dampen Harm") and inCombat then
                    if self.castDampenHarm() then return end
                end
        -- Zen Meditation
                if isChecked("Zen Meditation") and php<=getValue("Zen Meditation") and inCombat then
                    if self.castZenMeditation() then return end
                end
        -- Nimble Brew
                if isChecked("Nimble Brew") and hasNoControl() then
                    if self.castNimbleBrew() then return end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
        -- Quaking Palm
                if isChecked("Quaking Palm") then
                    for i=1, #getEnemies("player",5) do
                        thisUnit = getEnemies("player",5)[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castQuakingPalm(thisUnit) then return end
                        end
                    end
                end
        -- Spear Hand Strike
                if isChecked("Spear Hand Strike") then
                    for i=1, #getEnemies("player",5) do
                        thisUnit = getEnemies("player",5)[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castSpearHandStrike(thisUnit) then return end
                        end
                    end
                end
        -- Paralysis
                if isChecked("Paralysis") then
                    for i=1, #getEnemies("player",20) do
                        thisUnit = getEnemies("player",20)[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castParalysis(thisUnit) then return end
                        end
                    end
                end 
        -- Leg Sweep
                if isChecked("Leg Sweep") then
                    for i=1, #getEnemies("player",5) do
                        thisUnit = getEnemies("player",5)[i]
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castLegSweep(thisUnit) then return end
                        end
                    end
                end 
            end -- End Interrupt Check
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
        -- Flask
                -- flask,type=greater_draenic_agility_flask
                if isChecked("Agi-Pot") then
                    if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
                        useItem(self.flask.wod.agilityBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if self.useCrystal() then return end
                    end
                end
        -- Food 
                -- food,type=salty_squid_roll
        -- Stance
                -- stance,choose=fierce_tiger
        -- Snapshot Stats
                -- snapshot_stats
                if baseAgility==0 then
                    baseAgility = UnitStat("player", 2)
                end
                if baseMultistrike==0 then
                    baseMultistrike = GetMultistrike()
                end
        -- Potion
                -- potion,name=draenic_agility
        -- Start Attack
                -- auto_attack
                if ObjectExists("target") and not UnitIsDeadOrGhost("target") and getDistance("target")<5 then
                    StartAttack()
                end
            end -- End No Combat Check
        end --End Action List - Pre-Combat
    -- Action list - Opener
        function actionList_Opener()
        -- Tiger Eye Brew
            -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9
            if not buff.tigereyeBrew and charges.tigereyeBrew>=9 then
                if self.castTigereyeBrew() then return end
            end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
            -- blood_fury,if=buff.tigereye_brew_use.up
            -- berserking,if=buff.tigereye_brew_use.up
            -- arcane_torrent,if=buff.tigereye_brew_use.up&chi.max-chi>=1 
            if useCDs() then
                if buff.tigereyeBrew then
                    if (self.race == "Orc" or self.race == "Troll") then
                        if self.castRacial() then return end
                    end
                    if self.race == "Blood Elf" and chi.diff>=1 then
                        if self.castRacial() then return end
                    end
                end
            end 
        -- Fists of Fury
            -- fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.serenity.up&buff.serenity.remains<1.5
            if buff.remain.tigerPower>castTimeFoF and debuff.remain.risingSunKick>castTimeFoF and buff.serenity and buff.remain.serenity<1.5 then
                if self.castFistsOfFury() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=buff.tiger_power.remains<2
            if buff.remain.tigerPower<2 then
                if self.castTigerPalm() then return end
            end
        -- Legendary Ring
            -- use_item,name=maalus_the_blood_drinker
        -- Rising Sun Kick
            -- rising_sun_kick
            if self.castRisingSunKick() then return end
        -- Blackout Kick
            -- blackout_kick,if=chi.max-chi<=1&cooldown.chi_brew.up|buff.serenity.up
            if chi.diff<=1 and (cd.chiBrew==0 or buff.serenity) then
                if self.castBlackoutKick() then return end
            end
        -- Chi Brew
            -- chi_brew,if=chi.max-chi>=2
            if chi.diff>=2 then
                if self.castChiBrew() then return end
            end
        -- Serenity
            -- serenity,if=chi.max-chi<=2
            if chi.diff<=2 then
                if self.castSerenity() then return end
            end
        -- Jab
            -- jab,if=chi.max-chi>=2&!buff.serenity.up
            if chi.diff>=2 and not buff.serenity then
                if self.castJab() then return end
            end
        end -- End Action List - Opener
    -- Action List - Single Target
        function actionList_SingleTarget()
        -- Blackout Kick
            -- blackout_kick,if=set_bonus.tier18_2pc=1&buff.combo_breaker_bok.react
            if t18_2pc and buff.comboBreakerBlackoutKick then
                if self.castBlackoutKick() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=set_bonus.tier18_2pc=1&buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
            if t18_2pc and buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                if self.castTigerPalm() then return end
            end
        -- Rising Sun Kick
            -- rising_sun_kick
            if self.castRisingSunKick() then return end
        -- Blackout Kick
            -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
            if buff.comboBreakerBlackoutKick or buff.serenity then
                if self.castBlackoutKick() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
            if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                if self.castTigerPalm() then return end
            end
        -- Chi Wave
            -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
            if ttm>2 and not buff.serenity then
                if self.castChiWave() then return end
            end
        -- Chi Burst
            -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
            if ttm>2 and not buff.serenity then
                if self.castChiBurst() then return end
            end
        -- Zen Sphere
            -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
            for i =1, #nNova do
                thisUnit = nNova[i].unit
                if getDistance(thisUnit)<40 then
                    if ttm>2 and getBuffRemain(thisUnit,self.spell.zenSphereBuff)==0 and not buff.serenity then
                        if self.castZenSphere(thisUnit) then return end
                    end
                end
            end
        -- Chi Torpedo
            -- chi_torpedo,if=energy.time_to_max>2&buff.serenity.down&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
            if ttm>2 and not buff.serenity and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                if self.castChiTorpedo() then return end
            end
        -- Blackout Kick
            -- blackout_kick,if=chi.max-chi<2
            if chi.diff<2 then
                if self.castBlackoutKick() then return end
            end
        -- Expel Harm
            -- expel_harm,if=chi.max-chi>=2&health.percent<95
            if chi.diff>=2 and php<95 then
                if self.castExpelHarm() then return end
            end
        -- Jab
            -- jab,if=chi.max-chi>=2
            if chi.diff>=2 then
                if self.castJab() then return end
            end
        end -- End Action List - Single Target
    -- Action List - Single Target: Chi Explosion
        function actionList_SingleTargetChiExplosion()
        -- Chi Explosion
            -- chi_explosion,if=chi>=2&buff.combo_breaker_ce.react&cooldown.fists_of_fury.remains>2
            if chi.count>=2 and buff.comboBreakerChiExplosion and cd.fistsOfFury>2 then
                if self.castChiExplosion() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
            if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                if self.castTigerPalm() then return end
            end
        -- Rising Sun Kick
            -- rising_sun_kick
            if self.castRisingSunKick() then return end
        -- Chi Wave
            -- chi_wave,if=energy.time_to_max>2
            if ttm>2 then
                if self.castChiWave() then return end
            end
        -- Chi Burst
            -- chi_burst,if=energy.time_to_max>2
            if ttm>2 then
                if self.castChiBurst() then return end
            end
        -- Zen Sphere
            -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
            for i=1, #nNova do
                thisUnit = nNova[i].unit
                if getDistance(thisUnit)<40 then
                    if ttm>2 and getBuffRemain(thisUnit,self.spell.zenSphere)==0 then
                        if self.castZenSphere(thisUnit) then return end
                    end
                end
            end
        -- Expel Harm
            -- expel_harm,if=chi.max-chi>=2&health.percent<95
            if chi.diff>=2 and php<95 then
                if self.castExpelHarm() then return end
            end
        -- Jab
            -- jab,if=chi.max-chi>=2
            if chi.diff>=2 then
                if self.castJab() then return end
            end
        -- Chi Explosion
            -- chi_explosion,if=chi>=5&cooldown.fists_of_fury.remains>4
            if chi.count>=5 and cd.fistsOfFury>4 then
                if self.castChiExplosion() then return end
            end
        -- Chi Torpedo
            -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
            if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                if self.castChiTorpedo() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=chi=4&!buff.combo_breaker_tp.react
            if chi.count==4 and not buff.comboBreakerTigerPalm then
                if self.castTigerPalm() then return end
            end
        end -- End Action List - Single Target: Chi Explosion
    -- Action List - Cleave Target: Chi Explosion
        function actionList_CleaveTargetChiExplosion()
        -- Chi Explosion
            -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>2
            if chi.count>=4 and cd.fistsOfFury>2 then
                if self.castChiExplosion() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
            if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                if self.castTigerPalm() then return end
            end
        -- Chi Wave
            -- chi_wave,if=energy.time_to_max>2
            if ttm>2 then
                if self.castChiWave() then return end
            end
        -- Chi Burst
            -- chi_burst,if=energy.time_to_max>2
            if ttm>2 then
                if self.castChiBurst() then return end
            end
        -- Zen Sphere
            -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
            for i =1, #nNova do
                thisUnit = nNova[i].unit
                if getDistance(thisUnit)<40 then
                    if ttm>2 and getBuffRemain(thisUnit,self.spell.zenSphere)==0 then
                        if self.castZenSphere(thisUnit) then return end
                    end
                end
            end
        -- Chi Torpedo
            -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
            if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                if self.castChiTorpedo() then return end
            end
        -- Expel Harm
            -- expel_harm,if=chi.max-chi>=2&health.percent<95
            if chi.diff>=2 and php<95 then
                if self.castExpelHarm() then return end
            end
        -- Jab
            -- jab,if=chi.max-chi>=2
            if chi.diff>=2 then
                if self.castJab() then return end
            end
        end -- End Action List - Cleave Target: Chi Explosion
    -- Action List - Multi-Target: No Rushing Jade Wind
        function actionList_MultiTargetNoRushingJadeWind()
        -- Chi Wave
            -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
            if ttm>2 and not buff.serenity then
                if self.castChiWave() then return end
            end
        -- Chi Burst
            -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
            if ttm>2 and not buff.serenity then
                if self.castChiBurst() then return end
            end
        -- Zen Sphere
            -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
            for i =1, #nNova do
                thisUnit = nNova[i].unit
                if getDistance(thisUnit)<40 then
                    if ttm>2 and getBuffRemain(thisUnit,self.spell.zenSphere)==0 and not buff.serenity then
                        if self.castZenSphere(thisUnit) then return end
                    end
                end
            end
        -- Blackout Kick
            -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
            if buff.comboBreakerBlackoutKick or buff.serenity then
                if self.castBlackoutKick() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
            if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                if self.castTigerPalm() then return end
            end
        -- Blackout Kick
            -- blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
            if chi.diff<2 and cd.fistsOfFury>3 then
                if self.castBlackoutKick() then return end
            end
        -- Chi Torpedo
            -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
            if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                if self.castChiTorpedo() then return end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick
            if self.level<46 then
                if self.castJab() then return end
            else
                if self.castSpinningCraneKick() then return end
            end
        end -- End Action List - Multi-Target: No Rushing Jade Wind
    -- Action List - Multi-Target: No Rushing Jade Wind - Chi Explosion
        function actionList_MultiTargetNoRushingJadeWindChiExplosion()
        -- Chi Explosion
            -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
            if chi.count>=4 and cd.fistsOfFury>4 then
                if self.castChiExplosion() then return end
            end
        -- Rising Sun Kick
            -- rising_sun_kick,if=chi=chi.max
            if chi.count==chi.max then
                if self.castRisingSunKick() then return end
            end
        -- Chi Wave
            -- chi_wave,if=energy.time_to_max>2
            if ttm>2 then
                if self.castChiWave() then return end
            end
        -- Chi Burst
            -- chi_burst,if=energy.time_to_max>2
            if ttm>2 then
                if self.castChiBurst() then return end
            end
        -- Zen Sphere
            -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
            for i =1, #nNova do
                thisUnit = nNova[i].unit
                if getDistance(thisUnit)<40 then
                    if ttm>2 and getBuffRemain(thisUnit,self.spell.zenSphere)==0 then
                        if self.castZenSphere(thisUnit) then return end
                    end
                end
            end
        -- Chi Torpedo
            -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
            if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                if self.castChiTorpedo() then return end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick
            if self.level<46 then
                if self.castJab() then return end
            else
                if self.castSpinningCraneKick() then return end
            end
        end -- End Action List - Multi-Target: No Rushing Jade Wind - Chi Explosion
    -- Action List - Multi-Target: Rushing Jade Wind
        function actionList_MultiTargetRushingJadeWind()
        -- Chi Explosion
            -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
            if chi.count>=4 and cd.fistsOfFury>4 then
                if self.castChiExplosion() then return end
            end
        -- Rushing Jade Wind
            -- rushing_jade_wind
            if self.castRushingJadeWind() then return end
        -- Chi Wave
            -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
            if ttm>2 and not buff.serenity then
                if self.castChiWave() then return end
            end
        -- Chi Burst
            -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
            if ttm>2 and not buff.serenity then
                if self.castChiBurst() then return end
            end
        -- Zen Sphere
            -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
            for i =1, #nNova do
                thisUnit = nNova[i].unit
                if getDistance(thisUnit)<40 then
                    if ttm>2 and getBuffRemain(thisUnit,self.spell.zenSphere)==0 and not buff.serenity then
                        if self.castZenSphere(thisUnit) then return end
                    end
                end
            end
        -- Blackout Kick
            -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
            if buff.comboBreakerBlackoutKick or buff.serenity then
                if self.castBlackoutKick() then return end
            end
        -- Tiger Palm
            -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
            if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                if self.castTigerPalm() then return end
            end
        -- Blackout Kick
            -- blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
            if chi.diff<2 and cd.fistsOfFury>3 then
                if self.castBlackoutKick() then return end
            end
        -- Chi Torpedo
            -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
            if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                if self.castChiTorpedo() then return end
            end
        -- Expel Harm
            -- expel_harm,if=chi.max-chi>=2&health.percent<95
            if chi.diff>=2 and php<95 then
                if self.castExpelHarm() then return end
            end
        -- Jab
            -- jab,if=chi.max-chi>=2
            if chi.diff>=2 then
                if self.castJab() then return end
            end
        end -- End Action List - Multi-Target: Rushing Jade Wind
---------------------
--- Begin Profile ---
---------------------
    -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) then
            return true
        else
--------------
--- Extras ---
--------------
    -- Run Action List - Extras
            if actionList_Extras() then return end
            if not isChecked("Death Monk Mode") then
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
    -- Auto Attack
                    -- auto_attack
                    if getDistance(self.units.dyn5)<5 then
                        StartAttack()
                    end
    --  Invoke Xuen
                    -- invoke_xuen
                    if useCDs() then
                        if self.castInvokeXuen() then return end
                    end
    -- Storm, Earth, and Fire
                    -- storm_earth_and_fire,target=2,if=debuff.storm_earth_and_fire_target.down
                    -- storm_earth_and_fire,target=3,if=debuff.storm_earth_and_fire_target.down
                    if BadBoy_data['SEF']==1 then
                        if self.castStormEarthAndFire() then return end
                    end
    -- Call Action List - Opener
                    -- call_action_list,name=opener,if=talent.serenity.enabled&talent.chi_brew.enabled&cooldown.fists_of_fury.up&time<20
                    if talent.serenity and talent.chiBrew and cd.fistsOfFury==0 and combatTime<20 then
                        if actionList_Opener() then return end
                    end
    -- Chi Sphere
                -- chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<chi.max
                -- No way to code this?
    -- Potion
                -- potion,name=draenic_agility,if=buff.serenity.up|(!talent.serenity.enabled&(trinket.proc.agility.react|trinket.proc.multistrike.react))|buff.bloodlust.react|target.time_to_die<=60
                -- TODO: Potion usage
    -- Legendary Ring
                -- use_item,name=maalus_the_blood_drinker,if=buff.tigereye_brew_use.up|target.time_to_die<18
                -- TODO: Legendary Ring Usage
    -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,if=buff.tigereye_brew_use.up|target.time_to_die<18
                    -- berserking,if=buff.tigereye_brew_use.up|target.time_to_die<18
                    -- arcane_torrent,if=chi.max-chi>=1&(buff.tigereye_brew_use.up|target.time_to_die<18)
                    if useCDs() then
                        if buff.tigereyeBrew or ttd<18 then
                            if (self.race == "Orc" or self.race == "Troll") then
                                if castSpell("player",racial,false,false,false) then return end
                            end
                            if self.race == "Blood Elf" and chi.diff>=1 then
                                if castSpell("player",racial,false,false,false) then return end
                            end
                        end
                    end
    -- Chi Brew
                    -- chi_brew,if=chi.max-chi>=2&((charges=1&recharge_time<=10)|charges=2|target.time_to_die<charges*10)&buff.tigereye_brew.stack<=16
                    if chi.diff>=2 and ((charges.chiBrew==1 and recharge.chiBrew<=10) or charges.chiBrew==2 or ttd<charges.chiBrew*10) and charges.tigereyeBrew<=16 then
                        if self.castChiBrew() then return end
                    end
    -- Tiger Palm
                    -- tiger_palm,if=!talent.chi_explosion.enabled&buff.tiger_power.remains<6.6
                    if not talent.chiExplosion and buff.remain.tigerPower<6.6 then
                        if self.castTigerPalm() then return end
                    end
                    -- tiger_palm,if=talent.chi_explosion.enabled&(cooldown.fists_of_fury.remains<5|cooldown.fists_of_fury.up)&buff.tiger_power.remains<5
                    if talent.chiExplosion and (cd.fistsOfFury<5 or cd.fistsOfFury==0) and buff.remain.tigerPower<5 then
                        if self.castTigerPalm() then return end
                    end
    -- Tigereye Brew
                    -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack=20
                    if not buff.tigereyeBrew and charges.tigereyeBrew==20 then
                        if self.castTigereyeBrew() then return end
                    end
                    -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&buff.serenity.up
                    if not buff.tigereyeBrew and charges.tigereyeBrew>=9 and buff.serenity then
                        if self.castTigereyeBrew() then return end
                    end
                    -- tigereye_brew,if=talent.chi_explosion.enabled&buff.tigereye_brew_use.down
                    if talent.chiExplosion and not buff.tigereyeBrew then
                        if self.castTigereyeBrew() then return end
                    end
                    -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&cooldown.fists_of_fury.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
                    if not buff.tigereyeBrew and charges.tigereyeBrew>=9 and cd.fistsOfFury==0 and chi.count>=3 and debuff.risingSunKick and buff.tigerPower then
                        if self.castTigereyeBrew() then return end
                    end
                    -- tigereye_brew,if=talent.hurricane_strike.enabled&buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&cooldown.hurricane_strike.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
                    if talent.hurricaneStrike and not buff.tigereyeBrew and charges.tigereyeBrew>=9 and cd.hurricaneStrike==0 and debuff.risingSunKick and buff.tigerPower then
                        if self.castTigereyeBrew() then return end
                    end
                    -- tigereye_brew,if=buff.tigereye_brew_use.down&chi>=2&(buff.tigereye_brew.stack>=16|target.time_to_die<40)&debuff.rising_sun_kick.up&buff.tiger_power.up
                    if not buff.tigereyeBrew and chi.count>=2 and (charges.tigereyeBrew>=16 or ttd<40) and debuff.risingSunKick and buff.tigerPower then
                        if self.castTigereyeBrew() then return end
                    end
    -- Fortifying Brew
                    -- fortifying_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&(glyph.touch_of_death.enabled|chi>=3)
                    if isChecked("Fort Brew w/ ToD") and (thp<10 or UnitHealth("player")*1.2>=UnitHealth("target")) and cd.touchOfDeath==0 and (glyph.touchOfDeath or chi.count>=3) and ObjectExists("target") then
                        if self.castFortifyingBrew() then return end
                    end
    -- Touch of Death
                    -- touch_of_death,if=target.health.percent<10&(glyph.touch_of_death.enabled|chi>=3)
                    if (thp<10 or UnitHealth("player")>=UnitHealth("target")) and (glyph.touchOfDeath or chi.count>=3) then
                        if self.castTouchOfDeath() then return end
                    end
    -- Rising Sun Kick
                    -- rising_sun_kick,if=(debuff.rising_sun_kick.down|debuff.rising_sun_kick.remains<3)
                    if (not debuff.risingSunKick or debuff.remain.risingSunKick<3) then
                        if self.castRisingSunKick() then return end
                    end
    -- Serenity
                    -- serenity,if=chi>=2&buff.tiger_power.up&debuff.rising_sun_kick.up
                    if chi.count>=2 and buff.tigerPower and debuff.risingSunKick then
                        if self.castSerenity() then return end
                    end
    -- Fists of Fury
                    -- fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&energy.time_to_max>cast_time&!buff.serenity.up
                    if buff.remain.tigerPower>castTimeFoF and debuff.remain.risingSunKick>castTimeFoF and ttm>castTimeFoF and not buff.serenity then
                        if self.castFistsOfFury() then return end
                    end
    -- Hurricane Strike
                    -- hurricane_strike,if=energy.time_to_max>cast_time&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.energizing_brew.down
                    if ttm>castTimeHS and buff.remain.tigerPower>castTimeHS and debuff.remain.risingSunKick>castTimeHS and not buff.energizingBrew then
                        if self.castHurricaneStrike() then return end
                    end
    -- Energizing Brew
                    -- energizing_brew,if=cooldown.fists_of_fury.remains>6&(!talent.serenity.enabled|(!buff.serenity.remains&cooldown.serenity.remains>4))&energy+energy.regen<50
                    if cd.fistsOfFury>6 and (not talent.serenity or (not buff.serenity and cd.serenity>4)) and power+regen<50 then
                        if self.castEnergizingBrew() then return end
                    end
    -- Call Action List - Single Target
                    -- call_action_list,name=st,if=active_enemies<3&(level<100|!talent.chi_explosion.enabled)
                    if enemies.yards8<3 and (level<100 or not talent.chiExplosion) then
                        if actionList_SingleTarget() then return end
                    end
    -- Call Action List - Single Target: Chi Explosion
                    -- call_action_list,name=st_chix,if=active_enemies=1&talent.chi_explosion.enabled
                    if enemies.yards8==1 and talent.chiExplosion then
                        if actionList_SingleTargetChiExplosion() then return end
                    end
    -- Call Action List - Cleave Target: Chi Explosion
                    -- call_action_list,name=cleave_chix,if=(active_enemies=2|active_enemies=3&!talent.rushing_jade_wind.enabled)&talent.chi_explosion.enabled
                    if (enemies.yards8==2 or enemies==3 and not talent.rushingJadeWind) and talent.chiExplosion then
                        if actionList_CleaveTargetChiExplosion() then return end
                    end
    -- Call Action List - Multi-Target: No Rushing Jade Wind
                    -- call_action_list,name=aoe_norjw,if=active_enemies>=3&!talent.rushing_jade_wind.enabled&!talent.chi_explosion.enabled
                    if enemies.yards8>=3 and not talent.rushingJadeWind and not talent.chiExplosion then
                        if actionList_MultiTargetNoRushingJadeWind() then return end
                    end
    -- Call Action List - Multi-Target: No Rushing Jade Wind - Chi Explosion
                    -- call_action_list,name=aoe_norjw_chix,if=active_enemies>=4&!talent.rushing_jade_wind.enabled&talent.chi_explosion.enabled
                    if enemies.yards8>=4 and not talent.rushingJadeWind and talent.chiExplosion then
                        if actionList_MultiTargetNoRushingJadeWindChiExplosion() then return end
                    end
    -- Call Action List - Multi-Target: Rushing Jade Wind
                    -- call_action_list,name=aoe_rjw,if=active_enemies>=3&talent.rushing_jade_wind.enabled
                    if enemies.yards8>=3 and talent.rushingJadeWind then
                        if actionList_MultiTargetRushingJadeWind() then return end
                    end
    -- Tiger Palm
                    -- tiger_palm,if=buff.combo_breaker_tp.react
                    if buff.comboBreakerTigerPalm then
                        if self.castTigerPalm() then return end
                    end
                end -- End Combat Check 
            end -- End Death Monk Mode Check
        end -- End Pause
    end -- End Rotation Function
end -- End Class Check

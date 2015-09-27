if select(2, UnitClass("player")) == "DEATHKNIGHT" then
    function cFrost:FrostCuteOne()
------------------------
--- Global Functions ---
------------------------
        GroupInfo()
--------------
--- Locals ---
--------------
        local attacktar         = UnitCanAttack("target", "player")
        local buff              = self.buff
        local castingSimSpell   = isSimSpell()
        local cd                = self.cd
        local charges           = self.charges
        local deadtar           = UnitIsDeadOrGhost("target") or isDummy()
        local debuff            = self.debuff
        local disease           = self.disease
        local dynTar5AoE        = self.units.dyn5AoE
        local dynTar30AoE       = self.units.dyn30AoE
        local dynTable5AoE      = (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar5AoE, ["distance"] = getDistance(dynTar5AoE)}} 
        local dynTable30AoE     = (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar30AoE, ["distance"] = getDistance(dynTar30AoE)}} 
        local glyph             = self.glyph
        local inCombat          = self.inCombat
        local moving            = GetUnitSpeed("player")>0
        local oneHand, twoHand  = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
        local party             = select(2,IsInInstance())=="party"
        local php               = self.health
        local power             = self.power
        local raid              = select(2,IsInInstance())=="raid"
        local rune              = self.rune.count
        local runeFrac          = self.rune.percent
        local simSpell          = bb.im.simulacrumSpell
        local solo              = select(2,IsInInstance())=="none"
        local profileStop       = false
        local swimming          = IsSwimming()
        local talent            = self.talent
        local thp               = getHP("target")
    -- Profile Stop
        if inCombat and profileStop==true then
            return true
        else
            profileStop=false
        end
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        profileStop = true
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        return true
                    end
                end
            end
        -- Dark Simulacrum
            if simSpell~=_DarkSimulacrum and getBuffRemain("player",_DarkSimulacrum)>0 and getCastTimeRemain(simUnit)<8 then
                if castSpell(simUnit,simSpell,false,false,true,true,false,true,false) then bb.im.simulacrum = nil return end
                --CastSpellByName(GetSpellInfo(simSpell),tarUnit.dyn40)
            end
            if simSpell~=nil and getBuffRemain("player",_DarkSimulacrum)==0 then
                bb.im.simulacrum = nil
            end
        end -- End Action List - Extras
    -- Action List - Utility
        function actionList_Utility()
        -- Chains of Ice
            for i = 1, #dynTable30AoE do
                local thisUnit = dynTable30AoE[i].unit
                local chainsOfIceRemain = getDebuffRemain(thisUnit,self.spell.chainsOfIce,"player") or 0
                if not getFacing(thisUnit,"player") and getFacing("player",thisUnit) and isMoving(thisUnit) and getDistance(thisUnit)>8 and inCombat then
                    if self.castChainsOfIce() then return end
                end
            end
        -- Death's Advance
            -- deaths_advance,if=movement.remains>2
            if isMoving("player") and getNumEnemies("player",20)==0 and inCombat then
                if self.castDeathsAdvance() then return end
            end
        -- Death Grip
            if ((solo and #nNova==1) or hasThreat(self.units.dyn30AoE)) then
                if self.castDeathGrip() then return end
            end
        -- Gorefiend's Grasp
            if ((solo and #nNova==1) or hasThreat(self.units.dyn20AoE)) then
                if self.castDeathGrip() then return end
            end
        -- Unholy Presence
            if not buff.unholyPresence and self.enemies.yards30==0 and moving and (not inCombat or (inCombat and (power<40 or (power<70 and glyph.shiftingPresences)))) then
                if self.castUnholyPresence() then return end
            end
        -- Path of Frost
            if not inCombat and swimming and not buff.pathOfFrost then
                if self.castPathOfFrost() then return end
            end
        -- Raise Ally
            if isChecked("Mouseover Targetting") then
                if self.castRaiseAllyMouseover() then return end
            else
                if self.castRaiseAlly() then return end
            end
        end -- End Action List - Utility
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
        -- Anti-Magic Shell
                -- antimagic_shell,damage=100000,if=((dot.breath_of_sindragosa.ticking&runic_power<25)|cooldown.breath_of_sindragosa.remains>40)|!talent.breath_of_sindragosa.enabled
                if isChecked("Anti-Magic Shell") and php<=getOptionValue("Anti-Magic Shell") and not talent.antiMagicZone and ((buff.breathOfSindragosa and power<25) or cd.breathOfSindragosa>40 or (not talent.breathOfSindragosa)) then
                    if self.castAntiMagicShell() then return end
                end
        -- Anti-Magic Zone
               -- antimagic_shell,damage=100000,if=((dot.breath_of_sindragosa.ticking&runic_power<25)|cooldown.breath_of_sindragosa.remains>40)|!talent.breath_of_sindragosa.enabled
                if isChecked("Anti-Magic Zone") and php<=getOptionValue("Anti-Magic Zone") and (not isMoving("player")) and talent.antiMagicZone and ((buff.breathOfSindragosa and power<25) or cd.breathOfSindragosa>40 or (not talent.breathOfSindragosa)) then
                    if self.castAntiMagicZone() then return end
                end
        -- Blood Presence
                if isChecked("Blood Presence") and php<=getOptionValue("Blood Presence") and not buff.bloodPresence and self.enemies.yards30>0 then
                    if self.castBloodPresence() then return end
                end
        -- Conversion
                if isChecked("Conversion") and php <= getOptionValue("Conversion") and power>=50 and inCombat then
                    if self.castConversion() then return end
                end
        -- Death Pact
                if isChecked("Death Pact") and php <= getOptionValue("Death Pact") and inCombat then
                    if self.castDeathPact() then return end
                end
        -- Death Siphon
                if isChecked("Death Siphon") and php <= getOptionValue("Death Siphon") and inCombat then
                    if self.castDeathSiphon() then return end
                end
        -- Death Strike
                if isChecked("Death Strike") and php<=getOptionValue("Death Strike") and not buff.killingMachine and inCombat then
                    if self.castDeathStrike() then return end
                end
        -- Icebound Fortitude
                if isChecked("Icebound Fortitude") and php <= getOptionValue("Icebound Fortitude") and inCombat then
                    if self.castIceboundFortitude() then return end
                end
        -- Lichborne
                if isChecked("Lichborne") and hasNoControl(self.spell.lichborne) then
                    if self.castLichborne() then return end
                end
        -- Remorseless Winter
                if isChecked("Remorseless Winter") and (useAoE() or php <= getOptionValue("Remorseless Winter")) and inCombat then
                    if self.castRemorselessWinter() then return end
                end
        -- Desecrated Ground
                if isChecked("Desecrated Ground") and hasNoControl(self.spell.desecratedGround) then
                    if self.castDesecratedGround() then return end
                end
            end -- End Use Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
        -- Asphyxiate
                if isChecked("Asphyxiate") then
                    for i=1, #dynTable30AoE do
                        thisUnit = dynTable30AoE[i].unit
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castAsphyxiate(thisUnit) then return end
                        end
                    end
                end
        -- Dark Simulacrum
                if isChecked("Dark Simulacrum") and (isInPvP() or castingSimSpell) then
                    for i=1, #dynTable30AoE do
                        thisUnit = dynTable30AoE[i].unit
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castDarkSimulacrum() then return end
                        end
                    end
                end
        -- Mind Freeze
                if isChecked("Mind Freeze") then
                    for i=1, #dynTable5AoE do
                        thisUnit = dynTable5AoE[i].unit
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castMindFreeze() then return end
                        end
                    end
                end
        -- Strangulate
                if isChecked("Strangulate") then
                    for i=1, #dynTable30AoE do
                        thisUnit = dynTable30AoE[i].unit
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if self.castStrangulate(thisUnit) then return end
                        end
                    end
                end   
            end -- End Use Interrupts Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if useCDs() then
        -- Potion
                -- potion,name=draenic_strength,if=target.time_to_die<=30|(target.time_to_die<=60&buff.pillar_of_frost.up)
                if raid and (getTimeToDie(self.units.dyn5)<=30 or (getTimeToDie(self.units.dyn5)<=60 and buff.pillarOfFrost)) then
                    -- Draenic Strength Potion
                    if canUse(self.spell.strengthPotBasic) then
                        useItem(self.spell.strengthPotBasic)
                    end
                    -- Commander's Draenic Strength Potion
                    if canUse(self.spell.strengthPotGarrison) then
                        useItem(self.spell.strengthPotGarrison)
                    end
                end
        -- Empower Rune Weapon
                -- empower_rune_weapon,if=target.time_to_die<=60&buff.potion.up
                if getTimeToDie(self.units.dyn5)<=60 and buff.strengthPot then
                    if self.castEmpowerRuneWeapon() then return end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,sync=tigers_fury | berserking,sync=tigers_fury | arcane_torrent,sync=tigers_fury
                if (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
                    if self.castRacial() then return end
                end
        -- Legendary Ring
                -- use_item,slot=finger1
                -- TODO: Write Legendary Ring Usage 
            end -- End Use Cooldowns Check
        end -- End Action List - Cooldowns
    -- Action List - Pre-Combat
        function actionList_PreCombat()
        -- Flask / Crystal
            -- flask,type=greater_draenic_strength_flask
            if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
                if (raid or solo) and not (buff.strenthFlaskLow or buff.strengthFlaskBig) then--Draenor Str Flasks
                    if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
                        if self.useCrystal() then return end
                    end
                end
            end
        -- food,type=buttered_sturgeon
        -- Horn of Winter
            if isChecked("Horn of Winter") and not (IsFlying() or IsMounted()) and not inCombat then
                for i = 1, #nNova do
                    if not isBuffed(nNova[i].unit,{57330,19506,6673}) and (#nNova==select(5,GetInstanceInfo()) or solo or (party and not UnitInParty("player")))
                    then
                        if self.castHornOfWinter() then return end
                    end
                end
            end
        -- Frost Presence
            if not buff.frostPresence and php > getOptionValue("Blood Presence") and self.enemies.yards30>0 then
                if self.castFrostPresence() then return end
            end
        -- army_of_the_dead
        -- potion,name=draenic_strength
        -- pillar_of_frost
        -- Start Attack
            if attacktar and not deadtar and getDistance("target")<5 and not inCombat then
                StartAttack()
            end
        end -- End Action List - PreCombat
    -- Action List - Single Target: Boss
        function actionList_SingleBoss()
        -- Obliterate
            -- obliterate,if=buff.killing_machine.react
            if buff.killingMachine then
                if self.castObliterate() then return end
            end
        -- Blood Tap
            -- blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
            if buff.killingMachine and charges.bloodTap>=5 then
                if self.castBloodTap() then return end
            end
        -- Plague Leech
            -- plague_leech,if=buff.killing_machine.react
            if buff.killingMachine then
                if self.castPlagueLeech() then return end
            end
        -- Blood Tap
            -- blood_tap,if=buff.blood_charge.stack>=5
            if charges.bloodTap>=5 then
                if self.castBloodTap() then return end
            end
        -- Plague Leech
            -- plague_leech
            if self.castPlagueLeech() then return end
        -- Obliterate
            -- obliterate,if=runic_power<76
            if power<76 then
                if self.castObliterate() then return end
            end
        -- Howling Blast
            -- howling_blast,if=((death=1&frost=0&unholy=0)|death=0&frost=1&unholy=0)&runic_power<88
            if ((rune.death==1 and rune.frost==0 and rune.unholy==0) or rune.death==0 and rune.frost==1 and rune.unholy==0) and power<88 then
                if self.castHowlingBlast() then return end
            end
        end -- End Action List - Single Target: Boss
    -- Action List - Multi-Target: Boss
        function actionList_MultiBoss()
        -- Howling Blast
            -- howling_blast
            if self.castHowlingBlast() then return end
        -- Blood Tap
            -- blood_tap,if=buff.blood_charge.stack>10
            if charges.bloodTap>10 then
                if self.castBloodTap() then return end
            end
        -- Death and Decay
            -- death_and_decay,if=unholy=1
            if rune.unholy==1 then
                if self.castDeathAndDecay() then return end
            end
        -- Plague Strike
            -- plague_strike,if=unholy=2
            if rune.unholy==2 then
                if self.castPlagueStrike() then return end
            end
        -- Blood Tap
            -- blood_tap
            if self.castBloodTap() then return end
        -- Plague Leech
            -- plague_leech
            if self.castPlagueLeech() then return end
        -- Plague Strike
            -- plague_strike,if=unholy=1
            if rune.unholy==1 then
                if self.castPlagueStrike() then return end
            end
        -- Empower Rune Weapon
            -- empower_rune_weapon
            if useCDs() and isChecked("Empower Rune Weapon") then
                if self.castEmpowerRuneWeapon() then return end
            end
        end -- End Action List - Mutli-Target: Boss
    -- Action List - Single Target: 2 Hand Weapon
        function actionList_Single2H()
            if twoHand then
        -- Defile
                -- defile
                if self.castDefile() then return end
        -- Blood Tap
                -- blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
                if talent.defile and cd.defile==0 then
                    if self.castBloodTap() then return end
                end
        -- Howling Blast
                -- howling_blast,if=buff.rime.react&disease.min_remains>5&buff.killing_machine.react
                if buff.rime and disease.min.dyn30>5 and buff.killingMachine then
                    if self.castHowlingBlast() then return end
                end
        -- Obliterate
                -- obliterate,if=buff.killing_machine.react
                if buff.killingMachine then
                    if self.castObliterate() then return end
                end
        -- Blood Tap
                -- blood_tap,if=buff.killing_machine.react
                if buff.killingMachine then
                    if self.castBloodTap() then return end
                end
        -- Howling Blast
                -- howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking&buff.rime.react
                if not talent.necroticPlague and not buff.frostFever and buff.rime then
                    if self.castHowlingBlast() then return end
                end
        -- Outbreak
                -- outbreak,if=!disease.max_ticking
                if disease.max.dyn30==0 then
                    if self.castOutbreak() then return end
                end
        -- Unholy Blight
                -- unholy_blight,if=!disease.min_ticking
                if disease.min.dyn10AoE==99 then
                    if self.castUnholyBlight() then return end
                end
        -- Breath of Sindragosa
                -- breath_of_sindragosa,if=runic_power>75
                if power>75 then
                    if self.castBreathOfSindragosa() then return end
                end
        -- Run Action List - Single Boss
                -- run_action_list,name=single_target_bos,if=dot.breath_of_sindragosa.ticking
                if buff.breathOfSindragosa then
                    if actionList_SingleBoss() then return end
                end
        -- Obliterate
                -- obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<76
                if talent.breathOfSindragosa and cd.breathOfSindragosa<7 and power<76 then
                    if self.castObliterate() then return end
                end
        -- Howling Blast
                -- howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<88
                if talent.breathOfSindragosa and cd.breathOfSindragosa<3 and power<88 then
                    if self.castHowlingBlast() then return end
                end
        -- Howling Blast
                -- howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
                if not talent.necroticPlague and not debuff.frostFever then
                    if self.castHowlingBlast() then return end
                end
        -- Howling Blast
                -- howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
                if talent.necroticPlague and not debuff.necroticPlague then
                    if self.castHowlingBlast() then return end
                end
        -- Plague Strike
                -- plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
                if not talent.necroticPlague and not debuff.bloodPlague then
                    if self.castPlagueStrike() then return end
                end
        -- Blood Tap
                -- blood_tap,if=buff.blood_charge.stack>10&runic_power>76
                if charges.bloodTap>10 and power>76 then
                    if self.castBloodTap() then return end
                end
        -- Frost Stike
                -- frost_strike,if=runic_power>76
                if power>76 then
                    if self.castFrostStrike() then return end
                end
        -- Howling Blast
                -- howling_blast,if=buff.rime.react&disease.min_remains>5&(blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8)
                if buff.rime and disease.min.dyn30>5 and (runeFrac.blood>=1.8 or runeFrac.unholy>=1.8 or runeFrac.frost>=1.8) then
                    if self.castHowlingBlast() then return end
                end
        -- Obliterate
                -- obliterate,if=blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8
                if runeFrac.blood>=1.8 or runeFrac.unholy>=1.8 or runeFrac.frost>=1.8 then
                    if self.castObliterate() then return end
                end
        -- Plague Leech
                -- plague_leech,if=disease.min_remains<3&((blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95))
                if disease.min.dyn30<3 and ((runeFrac.blood<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.blood<=0.95)) then
                    if self.castPlagueLeech() then return end
                end
        -- Frost Strike
                -- frost_strike,if=talent.runic_empowerment.enabled&(frost=0|unholy=0|blood=0)&(!buff.killing_machine.react|!obliterate.ready_in<=1)
                if talent.runicEmpowerment and (rune.frost==0 or rune.unholy==0 or rune.blood==0) and ((not buff.killingMachine) or cd.obliterate>1) then
                    if self.castFrostStrike() then return end
                end
        -- Frost Strike
                -- frost_strike,if=talent.blood_tap.enabled&buff.blood_charge.stack<=10&(!buff.killing_machine.react|!obliterate.ready_in<=1)
                if talent.bloodTap and charges.bloodTap<=10 and ((not buff.killingMachine) or cd.obliterate>1) then
                    if self.castFrostStrike() then return end
                end
        -- Howling Blast
                -- howling_blast,if=buff.rime.react&disease.min_remains>5
                if buff.rime and disease.min.dyn30>5 then
                    if self.castHowlingBlast() then return end
                end
        -- Obliterate
                -- obliterate,if=blood.frac>=1.5|unholy.frac>=1.6|frost.frac>=1.6|buff.bloodlust.up|cooldown.plague_leech.remains<=4
                if runeFrac.blood>=1.5 or runeFrac.unholy>=1.6 or runeFrac.frost>=1.6 or hasBloodLust() or cd.plagueLeech<=4 then
                    if self.castObliterate() then return end
                end
        -- Blood Tap
                -- blood_tap,if=(buff.blood_charge.stack>10&runic_power>=20)|(blood.frac>=1.4|unholy.frac>=1.6|frost.frac>=1.6)
                if (charges.bloodTap>10 and power>=20) or (runeFrac.blood>=1.4 or runeFrac.unholy>=1.6 or runeFrac.frost>=1.6) then
                    if self.castBloodTap() then return end
                end
        -- Frost Strike
                -- frost_strike,if=!buff.killing_machine.react
                if not buff.killingMachine then
                    if self.castFrostStrike() then return end
                end
        -- Plague Leech
                -- plague_leech,if=(blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95)
                if (runeFrac.blood<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.blood<=0.95) then
                    if self.castPlagueLeech() then return end
                end
        -- Empower Rune Weapon
                -- empower_rune_weapon
                if useCDs() and isChecked("Empower Rune Weapon") then
                    if self.castEmpowerRuneWeapon() then return end
                end
            end -- End Two Hand Check
        end -- End Action List - Single Target: 2 Hand Weapon
    -- Action List - Single Target: 1 Hand Weapon
        function actionList_Single1H()
            if oneHand then
        -- Breath of Sindragosa
                -- breath_of_sindragosa,if=runic_power>75
                if power>75 then
                    if self.castBreathOfSindragosa() then return end
                end
        -- Rune Action List - Single Target: Boss
                -- run_action_list,name=single_target_bos,if=dot.breath_of_sindragosa.ticking
                if buff.breathOfSindragosa then
                    if actionList_SingleBoss() then return end
                end
        -- Frost Strike
                -- frost_strike,if=buff.killing_machine.react
                if buff.killingMachine then
                    if self.castFrostStrike() then return end
                end
        -- Obliterate
                -- obliterate,if=unholy>1|buff.killing_machine.react
                if rune.unholy>1 or buff.killingMachine then
                    if self.castObliterate() then return end
                end
        -- Defile
                -- defile
                if self.castDefile() then return end
        -- Blood Tap
                -- blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
                if talent.defile and cd.defile==0 then
                    if self.castDefile() then return end
                end
        -- Frost Strike
                -- frost_strike,if=runic_power>88
                if power>88 then
                    if self.castFrostStrike() then return end
                end
        -- Howling Blast
                -- howling_blast,if=buff.rime.react|death>1|frost>1
                if buff.rime or rune.death>1 or rune.frost>1 then
                    if self.castHowlingBlast() then return end
                end
        -- Blood Tap
                -- blood_tap,if=buff.blood_charge.stack>10
                if charges.bloodTap>10 then
                    if self.castBloodTap() then return end
                end
        -- Frost Strike
                -- frost_strike,if=runic_power>76
                if power>76 then
                    if self.castFrostStrike() then return end
                end
        -- Unholy Blight
                -- unholy_blight,if=!disease.ticking
                if disease.min.dyn30==99 then
                    if self.castUnholyBlight() then return end
                end
        -- Outbreak
                -- outbreak,if=!dot.blood_plague.ticking
                if not debuff.bloodPlague then
                    if self.castOutbreak() then return end
                end
        -- Plague Strike
                -- plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
                if not talent.necroticPlague and not debuff.bloodPlague then
                    if self.castPlagueStrike() then return end
                end
        -- Howling Blast
                -- howling_blast,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains<3)|death+frost>=2
                if (not (thp-3*(thp/getTimeToDie(self.units.dyn5))<=35 and cd.soulReaper<3)) or rune.death+rune.frost>=2 then
                    if self.castHowlingBlast() then return end
                end 
        -- Outbreak
                -- outbreak,if=talent.necrotic_plague.enabled&debuff.necrotic_plague.stack<=14
                if talent.necroticPlague and charges.necroticPlague<=14 then
                    if self.castOutbreak() then return end
                end
        -- Blood Tap
                -- blood_tap
                if self.castBloodTap() then return end
        -- Plague Leech
                -- plague_leech
                if self.castPlagueLeech() then return end
        -- Empower Rune Weapon
                -- empower_rune_weapon
                if useCDs() and isChecked("Empower Rune Weapon") then
                    if self.castEmpowerRuneWeapon() then return end
                end
            end -- End One Hand Check
        end -- End Action List - Single Target: 1 Hand Weapon
    -- Action List - Multi-Target
        function actionList_MultiTarget()
        -- Unholy Blight
            -- unholy_blight
            if self.castUnholyBlight() then return end
        -- Frost Strike
            -- frost_strike,if=buff.killing_machine.react&main_hand.1h
            if buff.killingMachine and oneHand then
                if self.castFrostStrike() then return end
            end
        -- Obliterate
            -- obliterate,if=unholy>1
            if rune.unholy>1 then
                if self.castObliterate() then return end
            end
        -- Blood Boil
            -- blood_boil,if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28
            if debuff.bloodPlague and ((not talent.unholyBlight) or cd.unholyBlight<49) and (lineCD == nil or lineCD <= GetTime()-28) then
                if self.castBloodBoil() then lineCD=GetTime(); return end
            end
        -- Defile
            -- defile
            if self.castDefile() then return end
        -- Breath of Sindragosa
            -- breath_of_sindragosa,if=runic_power>75
            if power>75 then
                if self.castBreathOfSindragosa() then return end
            end
        -- Run Action List - Multi-Target: Boss
            --  run_action_list,name=multi_target_bos,if=dot.breath_of_sindragosa.ticking
            if buff.breathOfSindragosa then
                if actionList_MultiBoss() then return end
            end
        -- Howling Blast
            -- howling_blast
            if self.castHowlingBlast() then return end
        -- BLood Tap
            -- blood_tap,if=buff.blood_charge.stack>10
            if charges.bloodTap>10 then
                if self.castBloodTap() then return end
            end
        -- Frost Strike
            -- frost_strike,if=runic_power>88
            if power>88 then
                if self.castFrostStrike() then return end
            end
        -- Death and Decay
            -- death_and_decay,if=unholy=1
            if rune.unholy==1 then
                if self.castDeathAndDecay() then return end
            end
        -- Plague Strike
            -- plague_strike,if=unholy=2&!dot.blood_plague.ticking&!talent.necrotic_plague.enabled
            if rune.unholy==2 and (not debuff.bloodPlague) and (not talent.necroticPlague) then
                if self.castPlagueStrike() then return end
            end
        -- Blood Tap
            -- blood_tap
            if self.castBloodTap() then return end
        -- Frost Strike
            -- frost_strike,if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
            if (not talent.breathOfSindragosa) or cd.breathOfSindragosa>=10 then
                if self.castFrostStrike() then return end
            end
        -- Plague Leech
            -- plague_leech
            if self.castPlagueLeech() then return end
        -- Plague Strike
            -- plague_strike,if=unholy=1
            if rune.unholy==1 then
                if self.castPlagueStrike() then return end
            end
        -- Empower Rune Weapon
            -- empower_rune_weapon
            if useCDs() and isChecked("Empower Rune Weapon") then
                if self.castEmpowerRuneWeapon() then return end
            end 
        end -- End Action List - Multi-Target
---------------------
--- Out Of Combat ---
---------------------
        if actionList_Extras() then return end
        if actionList_Utility() then return end
        if actionList_Defensive() then return end
        if actionList_PreCombat() then return end
-----------------
--- In Combat ---
-----------------
        if inCombat then
        -- Auto Attack
            -- auto_attack
            if ObjectExists("target") then
                StartAttack()
            end
            if actionList_Interrupts() then return end
        -- Pillar of Frost
            -- pillar_of_frost
            if self.castPillarOfFrost() then return end
            if actionList_Cooldowns() then return end
        -- Plague Leech
            -- if=disease.min_remains<1
            if disease.min.dyn30<1 then
                if self.castPlagueLeech() then return end
            end
        -- Soul Reaper
            -- if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
            if thp-3*(thp/getTimeToDie(self.units.dyn5))<=35 then
                if self.castSoulReaper() then return end
            end
        -- Blood Tap
            -- blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
            if (thp-3*(thp/getTimeToDie(self.units.dyn5))<35 and cd.soulReaper==0) then
                if self.castBloodTap() then return end
            end
        -- Run Action List - Single Target: Two Hand
            -- run_action_list,name=single_target_2h,if=spell_targets.howling_blast<4&main_hand.2h
            if self.enemies.yards30<4 then
                if actionList_Single2H() then return end
            end
        -- Run Action List - Single Target: One Hand
            --  run_action_list,name=single_target_1h,if=spell_targets.howling_blast<3&main_hand.1h
            if self.enemies.yards30<3 then
                if actionList_Single1H() then return end
            end
        -- Run Action List - Mutli-Target
            -- run_action_list,name=multi_target,if=spell_targets.howling_blast>=3+main_hand.2h
            if (self.enemies.yards30>=3 and oneHand) or (self.enemies.yards30>=4 and twoHand) then
                if actionList_MultiTarget() then return end
            end   
        end -- End Combat Check
    end -- End cFrost:FrostCuteOne()
end -- End Class Select

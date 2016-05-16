if select(2, UnitClass("player")) == "DEATHKNIGHT" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.howlingBlast },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.howlingBlast },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.icyTouch },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.deathPact}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.empowerRuneWeapon },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.empowerRuneWeapon },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.empowerRuneWeapon }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.iceboundFortitude },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.iceboundFortitude }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.mindFreeze },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.mindFreeze }
        };
        CreateButton("Interrupt",4,0)
    -- Cleave Button
        CleaveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = bb.player.spell.howlingBlast },
            [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = bb.player.spell.icyTouch }
        };
        CreateButton("Cleave",5,0)
    end

---------------
--- OPTIONS ---
---------------
    local function createOptions()
        local optionTable

        local function rotationOptions()
            -----------------------
            --- GENERAL OPTIONS ---
            -----------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "General")
                -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                -- Mouseover Targeting
                bb.ui:createCheckbox(section,"Mouseover Targeting","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFmouseover target validation.|cffFFBB00.")            
                -- Death Grip
                bb.ui:createCheckbox(section,"Death Grip")
                -- Gorefiend's Crasp
                bb.ui:createCheckbox(section,"Gorefiend's Grasp")
                -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
                -- Legendary Ring
                bb.ui:createDropdown(section,  "Legendary Ring", bb.dropOptions.CD,  2, "Enable or Disable usage of Legendary Ring.")
                -- Strength Potion
                bb.ui:createCheckbox(section,"Str-Pot")
                -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
                -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
                -- Empower Rune Weapon
                bb.ui:createCheckbox(section,"Empower Rune Weapon")
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Blood Presence
                bb.ui:createSpinner(section, "Blood Presence",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Death Strike
                bb.ui:createSpinner(section, "Death Strike",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Icebound Fortitude
                bb.ui:createSpinner(section, "Icebound Fortitude",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Lichbourne
                bb.ui:createCheckbox(section,"Lichborne")
                -- Anti-Magic Shell/Zone
                bb.ui:createSpinner(section, "Anti-Magic Zone",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                bb.ui:createSpinner(section, "Anti-Magic Shell",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Death Pact
                bb.ui:createSpinner(section, "Death Pact",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Death Siphon
                bb.ui:createSpinner(section, "Death Siphon",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Conversion
                bb.ui:createSpinner(section, "Conversion",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Remorseless Winter
                bb.ui:createSpinner(section, "Remorseless Winter",  75,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                -- Desecrated Ground
                bb.ui:createCheckbox(section,"Desecrated Ground")
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
                -- Mind Freeze
                bb.ui:createCheckbox(section,"Mind Freeze")
                -- Asphyxiate
                bb.ui:createCheckbox(section,"Asphyxiate")
                -- Strangulate
                bb.ui:createCheckbox(section,"Strangulate")
                -- Dark Simulacrum
                bb.ui:createCheckbox(section,"Dark Simulacrum")
                -- Interrupt Percentage
                bb.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
            bb.ui:checkSectionState(section)
            ----------------------
            --- TOGGLE OPTIONS ---
            ----------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Toggle Keys")
                -- Single/Multi Toggle
                bb.ui:createDropdown(section,  "Rotation Mode", bb.dropOptions.Toggle,  4)
                --Cooldown Key Toggle
                bb.ui:createDropdown(section,  "Cooldown Mode", bb.dropOptions.Toggle,  3)
                --Defensive Key Toggle
                bb.ui:createDropdown(section,  "Defensive Mode", bb.dropOptions.Toggle,  6)
                -- Interrupts Key Toggle
                bb.ui:createDropdown(section,  "Interrupt Mode", bb.dropOptions.Toggle,  6)
                -- Cleave Toggle
                bb.ui:createDropdown(section,  "Cleave Mode", bb.dropOptions.Toggle,  6)
                -- Pause Toggle
                bb.ui:createDropdown(section,  "Pause Mode", bb.dropOptions.Toggle,  6)
            bb.ui:checkSectionState(section)
        end
        optionTable = {{
            [1] = "Rotation Options",
            [2] = rotationOptions,
        }}
        return optionTable
    end

----------------
--- ROTATION ---
----------------
    local function runRotation()
        if bb.timer:useTimer("debugFrost", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)
            UpdateToggle("Cleave",0.25)
    --------------
    --- Locals ---
    --------------
            local attacktar         = UnitCanAttack("target", "player")
            local buff              = bb.player.buff
            local castingSimSpell   = isSimSpell()
            local cd                = bb.player.cd
            local charges           = bb.player.charges
            local deadtar           = UnitIsDeadOrGhost("target") or isDummy()
            local debuff            = bb.player.debuff
            local disease           = bb.player.disease
            local dynTar5AoE        = bb.player.units.dyn5AoE
            local dynTar30AoE       = bb.player.units.dyn30AoE
            local dynTable5AoE      = (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar5AoE, ["distance"] = getDistance(dynTar5AoE)}} 
            local dynTable30AoE     = (BadBoy_data['Cleave']==1 and enemiesTable) or { [1] = {["unit"]=dynTar30AoE, ["distance"] = getDistance(dynTar30AoE)}} 
            local glyph             = bb.player.glyph
            local inCombat          = bb.player.inCombat
            local level             = bb.player.level
            local moving            = GetUnitSpeed("player")>0
            local oneHand, twoHand  = IsEquippedItemType("One-Hand"), IsEquippedItemType("Two-Hand")
            local party             = select(2,IsInInstance())=="party"
            local php               = bb.player.health
            local power             = bb.player.power
            local pullTimer         = bb.DBM:getPulltimer()
            local raid              = select(2,IsInInstance())=="raid"
            local rune              = bb.player.rune.count
            local runeFrac          = bb.player.rune.percent
            local simSpell          = bb.im.simulacrumSpell
            local solo              = select(2,IsInInstance())=="none"
            local profileStop       = false
            local swimming          = IsSwimming()
            local talent            = bb.player.talent
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
                    local chainsOfIceRemain = getDebuffRemain(thisUnit,bb.player.spell.chainsOfIce,"player") or 0
                    if not getFacing(thisUnit,"player") and getFacing("player",thisUnit) and isMoving(thisUnit) and getDistance(thisUnit)>8 and inCombat then
                        if bb.player.castChainsOfIce() then return end
                    end
                end
            -- Death's Advance
                -- deaths_advance,if=movement.remains>2
                if isMoving("player") and getNumEnemies("player",20)==0 and inCombat then
                    if bb.player.castDeathsAdvance() then return end
                end
            -- Death Grip
                if isChecked("Death Grip") and ((solo and #nNova==1) or hasThreat(bb.player.units.dyn30AoE)) then
                    if inCombat then
                        if bb.player.castDeathGrip(thisUnit) then return end
                    end
                end
            -- Gorefiend's Grasp
                if isChecked("Gorefiend's Grasp") and ((solo and #nNova==1) or hasThreat(bb.player.units.dyn20AoE)) then
                    if bb.player.castGorefiendsGrasp() then return end
                end
            -- Unholy Presence
                -- if not buff.unholyPresence and moving and (not inCombat or (inCombat and getDistance(bb.player.units.dyn5)>10)) then --and (power<40 or (power<70 and glyph.shiftingPresences)))) then
                --     if bb.player.castUnholyPresence() then return end
                -- end
            -- Frost Presence
                if not buff.frostPresence --[[and php > getOptionValue("Blood Presence")]] and getDistance(bb.player.units.dyn5)<=10 then --and (power<40 or (power<70 and glyph.shiftingPresences)) then
                    if bb.player.castFrostPresence() then return end
                end
            -- Path of Frost
                if not inCombat and swimming and not buff.pathOfFrost then
                    if bb.player.castPathOfFrost() then return end
                end
            -- Raise Ally
                if isChecked("Mouseover Targetting") then
                    if bb.player.castRaiseAllyMouseover() then return end
                else
                    if bb.player.castRaiseAlly() then return end
                end
            end -- End Action List - Utility
        -- Action List - Defensive
            function actionList_Defensive()
                if useDefensive() and not IsMounted() then
            -- Anti-Magic Shell
                    -- antimagic_shell,damage=100000,if=((dot.breath_of_sindragosa.ticking&runic_power<25)|cooldown.breath_of_sindragosa.remains>40)|!talent.breath_of_sindragosa.enabled
                    if isChecked("Anti-Magic Shell") and php<=getOptionValue("Anti-Magic Shell") and incombat and not talent.antiMagicZone and ((buff.breathOfSindragosa and power<25) or cd.breathOfSindragosa>40 or (not talent.breathOfSindragosa)) then
                        if bb.player.castAntiMagicShell() then return end
                    end
            -- Anti-Magic Zone
                   -- antimagic_shell,damage=100000,if=((dot.breath_of_sindragosa.ticking&runic_power<25)|cooldown.breath_of_sindragosa.remains>40)|!talent.breath_of_sindragosa.enabled
                    if isChecked("Anti-Magic Zone") and php<=getOptionValue("Anti-Magic Zone") and (not isMoving("player")) and talent.antiMagicZone and ((buff.breathOfSindragosa and power<25) or cd.breathOfSindragosa>40 or (not talent.breathOfSindragosa)) then
                        if bb.player.castAntiMagicZone() then return end
                    end
            -- Blood Presence
                    if isChecked("Blood Presence") and php<=getOptionValue("Blood Presence") and not buff.bloodPresence and getDistance(bb.player.units.dyn5)<5 then --and (power<40 or (power<70 and glyph.shiftingPresences)) then
                        if bb.player.castBloodPresence() then return end
                    end
            -- Conversion
                    if isChecked("Conversion") and php <= getOptionValue("Conversion") and power>=50 and inCombat then
                        if bb.player.castConversion() then return end
                    end
            -- Death Pact
                    if isChecked("Death Pact") and php <= getOptionValue("Death Pact") and inCombat then
                        if bb.player.castDeathPact() then return end
                    end
            -- Death Siphon
                    if isChecked("Death Siphon") and php <= getOptionValue("Death Siphon") and inCombat then
                        if bb.player.castDeathSiphon() then return end
                    end
            -- Death Strike
                    if isChecked("Death Strike") and php<=getOptionValue("Death Strike") and not buff.killingMachine and inCombat then
                        if bb.player.castDeathStrike() then return end
                    end
            -- Icebound Fortitude
                    if isChecked("Icebound Fortitude") and php <= getOptionValue("Icebound Fortitude") and inCombat then
                        if bb.player.castIceboundFortitude() then return end
                    end
            -- Lichborne
                    if isChecked("Lichborne") and hasNoControl(bb.player.spell.lichborne) then
                        if bb.player.castLichborne() then return end
                    end
            -- Remorseless Winter
                    if isChecked("Remorseless Winter") and (useAoE() or php <= getOptionValue("Remorseless Winter")) and inCombat then
                        if bb.player.castRemorselessWinter() then return end
                    end
            -- Desecrated Ground
                    if isChecked("Desecrated Ground") and hasNoControl(bb.player.spell.desecratedGround) then
                        if bb.player.castDesecratedGround() then return end
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
                                if bb.player.castAsphyxiate(thisUnit) then return end
                            end
                        end
                    end
            -- Dark Simulacrum
                    if isChecked("Dark Simulacrum") and (isInPvP() or castingSimSpell) then
                        for i=1, #dynTable30AoE do
                            thisUnit = dynTable30AoE[i].unit
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castDarkSimulacrum() then return end
                            end
                        end
                    end
            -- Mind Freeze
                    if isChecked("Mind Freeze") then
                        for i=1, #dynTable5AoE do
                            thisUnit = dynTable5AoE[i].unit
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castMindFreeze() then return end
                            end
                        end
                    end
            -- Strangulate
                    if isChecked("Strangulate") then
                        for i=1, #dynTable30AoE do
                            thisUnit = dynTable30AoE[i].unit
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castStrangulate(thisUnit) then return end
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
                    if raid and (getTimeToDie(bb.player.units.dyn5)<=30 or (getTimeToDie(bb.player.units.dyn5)<=60 and buff.pillarOfFrost)) then
                        -- Draenic Strength Potion
                        if isChecked("Str-Pot") and canUse(109219) then
                            useItem(109219)
                        end
                        -- -- Commander's Draenic Strength Potion
                        -- if canUse(bb.player.spell.strengthPotGarrison) then
                        --     useItem(bb.player.spell.strengthPotGarrison)
                        -- end
                    end
            -- Empower Rune Weapon
                    -- empower_rune_weapon,if=target.time_to_die<=60&buff.potion.up
                    if getTimeToDie(bb.player.units.dyn5)<=60 and buff.strengthPot then
                        if bb.player.castEmpowerRuneWeapon() then return end
                    end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,sync=tigers_fury | berserking,sync=tigers_fury | arcane_torrent,sync=tigers_fury
                    if (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if bb.player.castRacial() then return end
                    end
            -- Legendary Ring
                    -- use_item,slot=finger1
                    if useCDs() and isChecked("Legendary Ring") then
                        if hasEquiped(124634) and canUse(124634) then
                            useItem(124634)
                            return true
                        end
                    end
                end -- End Use Cooldowns Check
            end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
            function actionList_PreCombat()
            -- Flask / Crystal
                -- flask,type=greater_draenic_strength_flask
                if isChecked("Flask / Crystal") and not (IsFlying() or IsMounted()) then
                    if (raid or solo) and not (buff.strenthFlaskLow or buff.strengthFlaskBig) then--Draenor Str Flasks
                        if not UnitBuffID("player",176151) and canUse(118922) then --Draenor Insanity Crystal
                            if bb.player.useCrystal() then return end
                        end
                    end
                end
            -- food,type=buttered_sturgeon
            -- Horn of Winter
                if isChecked("Horn of Winter") and not (IsFlying() or IsMounted()) and not inCombat then
                    if bb.player.castHornOfWinter() then return end
                end
            -- Frost Presence
                if not buff.frostPresence and php > getOptionValue("Blood Presence") and getDistance(bb.player.units.dyn5)<=8 then
                    if bb.player.castFrostPresence() then return end
                end
                if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
            -- Army of the Dead
                    -- army_of_the_dead
                    if bb.player.castArmyOfTheDead() then return end
            -- Pre-Pot
                    -- potion,name=draenic_strength
                    if isChecked("Str-Pot") and canUse(109219) then
                        useItem(109219)
                    end
            -- Pillar of Frost
                    -- pillar_of_frost
                    if bb.player.castPillarOfFrost() then return end
                end -- Pre-Pull
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
                    if bb.player.castObliterate() then return end
                end
            -- Blood Tap
                -- blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
                if buff.killingMachine and charges.bloodTap>=5 then
                    if bb.player.castBloodTap() then return end
                end
            -- Plague Leech
                -- plague_leech,if=buff.killing_machine.react
                if buff.killingMachine then
                    if bb.player.castPlagueLeech() then return end
                end
            -- Blood Tap
                -- blood_tap,if=buff.blood_charge.stack>=5
                if charges.bloodTap>=5 then
                    if bb.player.castBloodTap() then return end
                end
            -- Plague Leech
                -- plague_leech
                if bb.player.castPlagueLeech() then return end
            -- Obliterate
                -- obliterate,if=runic_power<76
                if power<76 then
                    if bb.player.castObliterate() then return end
                end
            -- Howling Blast
                -- howling_blast,if=((death=1&frost=0&unholy=0)|death=0&frost=1&unholy=0)&runic_power<88
                if ((rune.death==1 and rune.frost==0 and rune.unholy==0) or (rune.death==0 and rune.frost==1 and rune.unholy==0)) and power<88 then
                    if bb.player.castHowlingBlast() then return end
                end
            end -- End Action List - Single Target: Boss
        -- Action List - Multi-Target: Boss
            function actionList_MultiBoss()
            -- Howling Blast
                -- howling_blast
                if bb.player.castHowlingBlast() then return end
            -- Blood Tap
                -- blood_tap,if=buff.blood_charge.stack>10
                if charges.bloodTap>10 then
                    if bb.player.castBloodTap() then return end
                end
            -- Death and Decay
                -- death_and_decay,if=unholy=1
                if rune.unholy==1 then
                    if bb.player.castDeathAndDecay() then return end
                end
            -- Plague Strike
                -- plague_strike,if=unholy=2
                if rune.unholy==2 then
                    if bb.player.castPlagueStrike() then return end
                end
            -- Blood Tap
                -- blood_tap
                if bb.player.castBloodTap() then return end
            -- Plague Leech
                -- plague_leech
                if bb.player.castPlagueLeech() then return end
            -- Plague Strike
                -- plague_strike,if=unholy=1
                if rune.unholy==1 then
                    if bb.player.castPlagueStrike() then return end
                end
            -- Empower Rune Weapon
                -- empower_rune_weapon
                if useCDs() and isChecked("Empower Rune Weapon") then
                    if bb.player.castEmpowerRuneWeapon() then return end
                end
            end -- End Action List - Mutli-Target: Boss
        -- Action List - Single Target: 2 Hand Weapon
            function actionList_Single2H()
                if twoHand then
            -- Defile
                    -- defile
                    if bb.player.castDefile() then return end
            -- Blood Tap
                    -- blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
                    if talent.defile and cd.defile==0 then
                        if bb.player.castBloodTap() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=buff.rime.react&disease.min_remains>5&buff.killing_machine.react
                    if buff.rime and disease.min.dyn30>5 and buff.killingMachine then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Obliterate
                    -- obliterate,if=buff.killing_machine.react
                    if buff.killingMachine then
                        if bb.player.castObliterate() then return end
                    end
            -- Blood Tap
                    -- blood_tap,if=buff.killing_machine.react
                    if buff.killingMachine then
                        if bb.player.castBloodTap() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking&buff.rime.react
                    if not talent.necroticPlague and not buff.frostFever and buff.rime then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Outbreak
                    -- outbreak,if=!disease.max_ticking
                    if disease.max.dyn30==0 then
                        if bb.player.castOutbreak() then return end
                    end
            -- Unholy Blight
                    -- unholy_blight,if=!disease.min_ticking
                    if disease.min.dyn10AoE==99 then
                        if bb.player.castUnholyBlight() then return end
                    end
            -- Breath of Sindragosa
                    -- breath_of_sindragosa,if=runic_power>75
                    if power>75 then
                        if bb.player.castBreathOfSindragosa() then return end
                    end
            -- Run Action List - Single Boss
                    -- run_action_list,name=single_target_bos,if=dot.breath_of_sindragosa.ticking
                    if buff.breathOfSindragosa then
                        if actionList_SingleBoss() then return end
                    end
            -- Obliterate
                    -- obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<76
                    if talent.breathOfSindragosa and cd.breathOfSindragosa<7 and power<76 then
                        if bb.player.castObliterate() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<88
                    if talent.breathOfSindragosa and cd.breathOfSindragosa<3 and power<88 then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
                    if not talent.necroticPlague and not debuff.frostFever then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
                    if talent.necroticPlague and not debuff.necroticPlague then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Plague Strike
                    -- plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
                    if not talent.necroticPlague and not debuff.bloodPlague then
                        if bb.player.castPlagueStrike() then return end
                    end
            -- Blood Tap
                    -- blood_tap,if=buff.blood_charge.stack>10&runic_power>76
                    if charges.bloodTap>10 and power>76 then
                        if bb.player.castBloodTap() then return end
                    end
            -- Frost Strike
                    -- frost_strike,if=runic_power>76
                    if power>76 or (level<63 and power>40) then
                        if bb.player.castFrostStrike() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=buff.rime.react&disease.min_remains>5&(blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8)
                    if buff.rime and disease.min.dyn30>5 and (runeFrac.blood>=1.8 or runeFrac.unholy>=1.8 or runeFrac.frost>=1.8) then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Obliterate
                    -- obliterate,if=blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8
                    if runeFrac.blood>=1.8 or runeFrac.unholy>=1.8 or runeFrac.frost>=1.8 then
                        if bb.player.castObliterate() then return end
                    end
            -- Plague Leech
                    -- plague_leech,if=disease.min_remains<3&((blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95))
                    if disease.min.dyn30<3 and ((runeFrac.blood<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.blood<=0.95)) then
                        if bb.player.castPlagueLeech() then return end
                    end
            -- Frost Strike
                    -- frost_strike,if=talent.runic_empowerment.enabled&(frost=0|unholy=0|blood=0)&(!buff.killing_machine.react|!obliterate.ready_in<=1)
                    if talent.runicEmpowerment and (rune.frost==0 or rune.unholy==0 or rune.blood==0) and ((not buff.killingMachine) or cd.obliterate>1) then
                        if bb.player.castFrostStrike() then return end
                    end
            -- Frost Strike
                    -- frost_strike,if=talent.blood_tap.enabled&buff.blood_charge.stack<=10&(!buff.killing_machine.react|!obliterate.ready_in<=1)
                    if talent.bloodTap and charges.bloodTap<=10 and ((not buff.killingMachine) or cd.obliterate>1) then
                        if bb.player.castFrostStrike() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=buff.rime.react&disease.min_remains>5
                    if buff.rime and disease.min.dyn30>5 then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Obliterate
                    -- obliterate,if=blood.frac>=1.5|unholy.frac>=1.6|frost.frac>=1.6|buff.bloodlust.up|cooldown.plague_leech.remains<=4
                    if runeFrac.blood>=1.5 or runeFrac.unholy>=1.6 or runeFrac.frost>=1.6 or hasBloodLust() or cd.plagueLeech<=4 then
                        if bb.player.castObliterate() then return end
                    end
            -- Blood Tap
                    -- blood_tap,if=(buff.blood_charge.stack>10&runic_power>=20)|(blood.frac>=1.4|unholy.frac>=1.6|frost.frac>=1.6)
                    if (charges.bloodTap>10 and power>=20) or (runeFrac.blood>=1.4 or runeFrac.unholy>=1.6 or runeFrac.frost>=1.6) then
                        if bb.player.castBloodTap() then return end
                    end
            -- Frost Strike
                    -- frost_strike,if=!buff.killing_machine.react
                    if not buff.killingMachine then
                        if bb.player.castFrostStrike() then return end
                    end
            -- Plague Leech
                    -- plague_leech,if=(blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95)
                    if (runeFrac.blood<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.unholy<=0.95) or (runeFrac.frost<=0.95 and runeFrac.blood<=0.95) then
                        if bb.player.castPlagueLeech() then return end
                    end
            -- Empower Rune Weapon
                    -- empower_rune_weapon
                    if useCDs() and isChecked("Empower Rune Weapon") then
                        if bb.player.castEmpowerRuneWeapon() then return end
                    end
                end -- End Two Hand Check
            end -- End Action List - Single Target: 2 Hand Weapon
        -- Action List - Single Target: 1 Hand Weapon
            function actionList_Single1H()
                if oneHand then
            -- Breath of Sindragosa
                    -- breath_of_sindragosa,if=runic_power>75
                    if power>75 then
                        if bb.player.castBreathOfSindragosa() then return end
                    end
            -- Rune Action List - Single Target: Boss
                    -- run_action_list,name=single_target_bos,if=dot.breath_of_sindragosa.ticking
                    if buff.breathOfSindragosa then
                        if actionList_SingleBoss() then return end
                    end
            -- Frost Strike
                    -- frost_strike,if=buff.killing_machine.react
                    if buff.killingMachine then
                        if bb.player.castFrostStrike() then return end
                    end
            -- Obliterate
                    -- obliterate,if=unholy>1|buff.killing_machine.react
                    if rune.unholy>1 or buff.killingMachine then
                        if bb.player.castObliterate() then return end
                    end
            -- Defile
                    -- defile
                    if bb.player.castDefile() then return end
            -- Blood Tap
                    -- blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
                    if talent.defile and cd.defile==0 then
                        if bb.player.castDefile() then return end
                    end
            -- Frost Strike
                    -- frost_strike,if=runic_power>88
                    if power>88 then
                        if bb.player.castFrostStrike() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=buff.rime.react|death>1|frost>1
                    if buff.rime or rune.death>1 or rune.frost>1 then
                        if bb.player.castHowlingBlast() then return end
                    end
            -- Blood Tap
                    -- blood_tap,if=buff.blood_charge.stack>10
                    if charges.bloodTap>10 then
                        if bb.player.castBloodTap() then return end
                    end
            -- Frost Strike
                    -- frost_strike,if=runic_power>76
                    if power>76 or (level<63 and power>40) then
                        if bb.player.castFrostStrike() then return end
                    end
            -- Unholy Blight
                    -- unholy_blight,if=!disease.ticking
                    if disease.min.dyn30==99 then
                        if bb.player.castUnholyBlight() then return end
                    end
            -- Outbreak
                    -- outbreak,if=!dot.blood_plague.ticking
                    if not debuff.bloodPlague then
                        if bb.player.castOutbreak() then return end
                    end
            -- Plague Strike
                    -- plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
                    if not talent.necroticPlague and not debuff.bloodPlague then
                        if bb.player.castPlagueStrike() then return end
                    end
            -- Howling Blast
                    -- howling_blast,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains<3)|death+frost>=2
                    if (not (thp-3*(thp/getTimeToDie(bb.player.units.dyn5))<=35 and cd.soulReaper<3)) or rune.death+rune.frost>=2 then
                        if bb.player.castHowlingBlast() then return end
                    end 
            -- Outbreak
                    -- outbreak,if=talent.necrotic_plague.enabled&debuff.necrotic_plague.stack<=14
                    if talent.necroticPlague and charges.necroticPlague<=14 then
                        if bb.player.castOutbreak() then return end
                    end
            -- Blood Tap
                    -- blood_tap
                    if bb.player.castBloodTap() then return end
            -- Plague Leech
                    -- plague_leech
                    if bb.player.castPlagueLeech() then return end
            -- Empower Rune Weapon
                    -- empower_rune_weapon
                    if useCDs() and isChecked("Empower Rune Weapon") then
                        if bb.player.castEmpowerRuneWeapon() then return end
                    end
                end -- End One Hand Check
            end -- End Action List - Single Target: 1 Hand Weapon
        -- Action List - Multi-Target
            function actionList_MultiTarget()
            -- Unholy Blight
                -- unholy_blight
                if bb.player.castUnholyBlight() then return end
            -- Frost Strike
                -- frost_strike,if=buff.killing_machine.react&main_hand.1h
                if buff.killingMachine and oneHand then
                    if bb.player.castFrostStrike() then return end
                end
            -- Obliterate
                -- obliterate,if=unholy>1
                if rune.unholy>1 then
                    if bb.player.castObliterate() then return end
                end
            -- Blood Boil
                -- blood_boil,if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28
                if debuff.bloodPlague and ((not talent.unholyBlight) or cd.unholyBlight<49) and (lineCD == nil or lineCD <= GetTime()-28) then
                    if bb.player.castBloodBoil() then lineCD=GetTime(); return end
                end
            -- Defile
                -- defile
                if bb.player.castDefile() then return end
            -- Breath of Sindragosa
                -- breath_of_sindragosa,if=runic_power>75
                if power>75 then
                    if bb.player.castBreathOfSindragosa() then return end
                end
            -- Run Action List - Multi-Target: Boss
                --  run_action_list,name=multi_target_bos,if=dot.breath_of_sindragosa.ticking
                if buff.breathOfSindragosa then
                    if actionList_MultiBoss() then return end
                end
            -- Howling Blast
                -- howling_blast
                if bb.player.castHowlingBlast() then return end
            -- BLood Tap
                -- blood_tap,if=buff.blood_charge.stack>10
                if charges.bloodTap>10 then
                    if bb.player.castBloodTap() then return end
                end
            -- Frost Strike
                -- frost_strike,if=runic_power>88
                if power>88 then
                    if bb.player.castFrostStrike() then return end
                end
            -- Death and Decay
                -- death_and_decay,if=unholy=1
                if rune.unholy==1 then
                    if bb.player.castDeathAndDecay() then return end
                end
            -- Plague Strike
                -- plague_strike,if=unholy=2&!dot.blood_plague.ticking&!talent.necrotic_plague.enabled
                if rune.unholy==2 and (not debuff.bloodPlague) and (not talent.necroticPlague) then
                    if bb.player.castPlagueStrike() then return end
                end
            -- Blood Tap
                -- blood_tap
                if bb.player.castBloodTap() then return end
            -- Frost Strike
                -- frost_strike,if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
                if (not talent.breathOfSindragosa) or cd.breathOfSindragosa>=10 then
                    if bb.player.castFrostStrike() then return end
                end
            -- Plague Leech
                -- plague_leech
                if bb.player.castPlagueLeech() then return end
            -- Plague Strike
                -- plague_strike,if=unholy=1
                if rune.unholy==1 then
                    if bb.player.castPlagueStrike() then return end
                end
            -- Empower Rune Weapon
                -- empower_rune_weapon
                if useCDs() and isChecked("Empower Rune Weapon") then
                    if bb.player.castEmpowerRuneWeapon() then return end
                end 
            end -- End Action List - Multi-Target
    ---------------------
    --- Out Of Combat ---
    ---------------------
            if pause() or BadBoy_data['AoE']==4 then
                return true
            else
                if actionList_Extras() then return end
                if actionList_Utility() then return end
                if actionList_Defensive() then return end
                if actionList_PreCombat() then return end
                if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                    if getDistance("target")<5 then
                        StartAttack()
                    end
                end
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
                    if bb.player.castPillarOfFrost() then return end
                    if actionList_Cooldowns() then return end
                -- Plague Leech
                    -- if=disease.min_remains<1
                    if disease.min.dyn30<1 then
                        if bb.player.castPlagueLeech() then return end
                    end
                -- Soul Reaper
                    -- if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
                    if thp-3*(thp/getTimeToDie(bb.player.units.dyn5))<=35 then
                        if bb.player.castSoulReaper() then return end
                    end
                -- Blood Tap
                    -- blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
                    if (thp-3*(thp/getTimeToDie(bb.player.units.dyn5))<35 and cd.soulReaper==0) then
                        if bb.player.castBloodTap() then return end
                    end
                -- Run Action List - Single Target: Two Hand
                    -- run_action_list,name=single_target_2h,if=spell_targets.howling_blast<4&main_hand.2h
                    if bb.player.enemies.yards10<4 and twoHand and not useAoE() then
                        if actionList_Single2H() then return end
                    end
                -- Run Action List - Single Target: One Hand
                    --  run_action_list,name=single_target_1h,if=spell_targets.howling_blast<3&main_hand.1h
                    if bb.player.enemies.yards10<3 and oneHand and not useAoE() then
                        if actionList_Single1H() then return end
                    end
                -- Run Action List - Mutli-Target
                    -- run_action_list,name=multi_target,if=spell_targets.howling_blast>=3+main_hand.2h
                    if (bb.player.enemies.yards10>=3 and oneHand) or (bb.player.enemies.yards10>=4 and twoHand) or useAoE() then
                        if actionList_MultiTarget() then return end
                    end   
                end -- End Combat Check
            end -- End Rotation Pause
        end -- End Timer
    end -- runRotation
    tinsert(cFrost.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Select

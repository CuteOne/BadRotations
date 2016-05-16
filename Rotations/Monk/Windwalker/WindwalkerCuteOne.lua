if select(2, UnitClass("player")) == "MONK" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.spinningCraneKick },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.spinningCraneKick },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.jab },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.surgingMist}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.invokeXuen },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.invokeXuen },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.invokeXuen }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.dampenHarm },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.dampenHarm }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = bb.player.spell.spearHandStrike },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = bb.player.spell.spearHandStrike }
        };
        CreateButton("Interrupt",4,0)
    -- Storm, Earth, and Fire Button
        SEFModes = {
            [1] = { mode = "On", value = 2 , overlay = "Auto SEF Enabled", tip = "Will cast Storm, Earth, and Fire.", highlight = 1, icon = bb.player.spell.stormEarthAndFire},
            [2] = { mode = "Off", value = 1 , overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = bb.player.spell.stormEarthFire}
        };
        CreateButton("SEF",5,0)
    -- Flying Serpent Kick Button
        FSKModes = {
            [1] = { mode = "On", value = 2 , overlay = "Auto FSK Enabled", tip = "Will cast Flying Serpent Kick.", highlight = 1, icon = bb.player.spell.flyingSerpentKick},
            [2] = { mode = "Off", value = 1 , overlay = "Auto FSK Disabled", tip = "Will NOT cast Flying Serpent Kick.", highlight = 0, icon = bb.player.spell.flyingSerpentKick}
        };
        CreateButton("FSK",6,0)
    -- Chi Builder Button
        BuilderModes = {
            [1] = { mode = "On", value = 2 , overlay = "Chi Builder Enabled", tip = "Generates Chi when out of combat.", highlight = 1, icon = bb.player.spell.expelHarm},
            [2] = { mode = "Off", value = 1 , overlay = "Chi Builder Disabled", tip = "No Chi will be generated when out of combat.", highlight = 0, icon = bb.player.spell.expelHarm}
        };
        CreateButton("Builder",7,0)
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
            -- Death Monk
                bb.ui:createCheckbox(section,"Death Monk Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
            -- Legacy of the White Tiger
                bb.ui:createCheckbox(section,"Legacy of the White Tiger","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Legacy of the White Tiger usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.")
            -- Fortifying Brew w/ Touch of Death
                bb.ui:createCheckbox(section,"Fort Brew w/ ToD","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFuse of Fortifying to empower Touch of Death.")
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")         
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
            -- Agi Pot
                bb.ui:createCheckbox(section,"Agi-Pot")
            -- Legendary Ring
                bb.ui:createCheckbox(section,"Legendary Ring")
            -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
            -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")
            -- Serenity
                bb.ui:createCheckbox(section,"Serenity")
            -- Xuen
                bb.ui:createCheckbox(section,"Xuen")
            bb.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
             section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
            -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            --  Expel Harm
                bb.ui:createSpinner(section, "Expel Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Surging Mist
                bb.ui:createSpinner(section, "Surging Mist",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Touch of Karma
                bb.ui:createSpinner(section, "Touch of Karma",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Fortifying Brew
                bb.ui:createSpinner(section, "Fortifying Brew",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Diffuse Magic/Dampen Harm
                bb.ui:createSpinner(section, "Diffuse/Dampen",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Zen Meditation
                bb.ui:createSpinner(section, "Zen Meditation",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Nimble Brew
                bb.ui:createCheckbox(section,"Nimble Brew")
            bb.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = bb.ui:createSection(bb.ui.window.profile, "Interrupts")
            --Quaking Palm
                bb.ui:createCheckbox(section, "Quaking Palm")
            -- Spear Hand Strike
                bb.ui:createCheckbox(section, "Spear Hand Strike")
            -- Paralysis
                bb.ui:createCheckbox(section, "Paralysis")
            -- Leg Sweep
                bb.ui:createCheckbox(section, "Leg Sweep")
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
            -- SEF Toggle
                bb.ui:createDropdown(section,  "SEF Mode", bb.dropOptions.Toggle,  5)
            -- FSK Toggle
                bb.ui:createDropdown(section,  "FSK Mode", bb.dropOptions.Toggle,  5)
            -- Chi Builder Toggle
                bb.ui:createDropdown(section,  "Builder Mode", bb.dropOptions.Toggle,  5)
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
        if bb.timer:useTimer("debugWindwalker", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)
            UpdateToggle("SEF",0.25)
            UpdateToggle("FSK",0.25)
            UpdateToggle("Builder",0.25)
            
    --------------
    --- Locals ---
    --------------
            local agility           = UnitStat("player", 2)
            local baseAgility       = 0
            local baseMultistrike   = 0
            local buff              = bb.player.buff
            local canFlask          = canUse(bb.player.flask.wod.agilityBig)
            local castTimeFoF       = 4-(4*UnitSpellHaste("player")/100)
            local castTimeHS        = 2-(2*UnitSpellHaste("player")/100)
            local cd                = bb.player.cd
            local charges           = bb.player.charges
            local chi               = bb.player.chi
            local combatTime        = getCombatTime()
            local debuff            = bb.player.debuff
            local enemies           = bb.player.enemies
            local flaskBuff         = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig) or 0
            local glyph             = bb.player.glyph
            local healthPot         = getHealthPot() or 0
            local inCombat          = bb.player.inCombat
            local inRaid            = select(2,IsInInstance())=="raid"
            local level             = bb.player.level
            local multistrike       = GetMultistrike()
            local php               = bb.player.health
            local power             = bb.player.power
            local pullTimer         = bb.DBM:getPulltimer()
            local race              = bb.player.race
            local racial            = bb.player.getRacial()
            local recharge          = bb.player.recharge
            local regen             = bb.player.powerRegen
            local solo              = select(2,IsInInstance())=="none"
            local t17_2pc           = bb.player.eq.t17_2pc
            local t18_2pc           = bb.player.eq.t18_2pc 
            local t18_4pc           = bb.player.eq.t18_4pc
            local talent            = bb.player.talent
            local thp               = getHP(bb.player.units.dyn5)
            local trinketProc       = bb.player.hasTrinketProc()
            local ttd               = getTimeToDie(bb.player.units.dyn5)
            local ttm               = bb.player.timeToMax
        
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
                            local debuffStormEarthAndFire   = UnitDebuffID(thisUnit,bb.player.spell.stormEarthAndFireDebuff,"player")~=nil or false

                            if not debuffStormEarthAndFire and guidThisUnit~=guidTarget and charges.stormEarthAndFire<2 and UnitIsTappedByPlayer(thisUnit) then
                                if castSpell(thisUnit,bb.player.spell.stormEarthAndFire,false,false,false) then return end
                            elseif debuffStormEarthAndFire and guidThisUnit==guidTarget then
                                CancelUnitBuff("player", GetSpellInfo(bb.player.spell.stormEarthAndFire))
                            end
                        end
                    elseif charges.stormEarthAndFire>0 and enemies.yards40<2 then
                        CancelUnitBuff("player", GetSpellInfo(bb.player.spell.stormEarthAndFire))
                    end
                    if not useAoE() then
                        if power>40 then
                            if bb.player.castJab() then return end
                        elseif chi.count>2 then
                            if bb.player.castBlackoutKick() then return end
                        end
                    else
                        if power>40 then
                            if bb.player.level<46 then
                                if bb.player.castJab() then return end
                            else
                                if bb.player.castSpinningCraneKick() then return end
                            end
                        elseif chi.count>2 then
                            if bb.player.castRisingSunKick() then return end
                        end
                    end
                end -- End Death Monk Mode
            -- Stop Casting
                if ((getDistance("target")<5 or (BadBoy_data['FSK']==1 and cd.flyingSerpentKick==0)) and isCastingSpell(bb.player.spell.cracklingJadeLightning)) or (not useAoE() and isCastingSpell(bb.player.spell.spinningCraneKick)) then
                    SpellStopCasting()
                end
            -- Cancel Storm, Earth, and Fire
                if charges.stormEarthAndFire~=0 and (not inCombat or BadBoy_data['SEF']~=1) then
                    CancelUnitBuff("player", GetSpellInfo(bb.player.spell.stormEarthAndFire))
                end
            -- Tiger's Lust
                if hasNoControl() or (inCombat and getDistance("target")>10 and ObjectExists("target") and not UnitIsDeadOrGhost("target")) then
                    if bb.player.castTigersLust() then return end
                end
            -- Detox
                if canDispel("player",bb.player.spell.detox) then
                    if bb.player.castDetox("player") then return end
                end
                if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                    if canDispel("mouseover",bb.player.spell.detox) then
                        if bb.player.castDetox("mouseover") then return end
                    end
                end
            -- Resuscitate
                if bb.player.castResuscitate() then return end
            -- Legacy of the White Tiger
                if not inCombat and isChecked("Legacy of the White Tiger") then
                    if bb.player.castLegacyOfTheWhiteTiger() then return end
                end
            -- Expel Harm (Chi Builer)
                if not inCombat and BadBoy_data['Builder']==1 and chi.diff>=2 and not isUnitCasting("player") and GetNumLootItems()==0 then
                    if bb.player.castExpelHarm() then return end
                end
            -- Provoke
                if not inCombat and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" and cd.flyingSerpentKick>1 and getDistance("target")>10 and ObjectExists("target") then
                    if solo or #nNova==1 then
                        if bb.player.castProvoke() then return end
                    end
                end
            -- Flying Serpent Kick
                if BadBoy_data['FSK']==1 and ObjectExists("target") then
                    if canFSK("target") and not isDummy() and (solo or inCombat) then
                        if bb.player.castFlyingSerpentKick() then 
                            if inCombat and usingFSK() then 
                                if bb.player.castFlyingSerpentKickEnd() then return end
                            end
                        end
                    end
                    if (not ObjectIsFacing("player","target") or getRealDistance("player","target")<8) and usingFSK() then
                        if bb.player.castFlyingSerpentKickEnd() then return end
                    end
            -- Roll
                    if not canFSK("target") and getRealDistance("player","target")>10 and getFacingDistance()<5 and getFacing("player","target",10) then
                        if bb.player.castRoll() then return end
                    end
                end
            -- Dummy Test
                if isChecked("DPS Testing") then
                    if ObjectExists("target") then
                        if combatTime >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                            CancelUnitBuff("player", GetSpellInfo(bb.player.spell.stormEarthAndFire))
                            StopAttack()
                            ClearTarget()
                            StopAttack()
                            ClearTarget()
                            print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        end
                    end
                end
            -- Crackling Jade Lightning
                if getDistance("target")>=8 and ((BadBoy_data['FSK']==1 and cd.flyingSerpentKick>1) or BadBoy_data['FSK']==2) 
                    and not isCastingSpell(bb.player.spell.cracklingJadeLightning) and (isInCombat("target") or isDummy()) and not isMoving("player") 
                then
                    if bb.player.castCracklingJadeLightning() then return end
                end
            -- Touch of the Void
                if (useCDs() or useAoE()) and isChecked("Touch of the Void") and inCombat and getDistance(bb.player.units.dyn5)<5 then
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
                            if bb.player.castExpelHarm() then return end
                        end
                    end
            -- Surging Mist
                    if isChecked("Surging Mist") and php<=getValue("Surging Mist") and not inCombat then
                        if bb.player.castSurgingMist() then return end
                    end
            -- Touch of Karma
                    if isChecked("Touch of Karma") and php<=getValue("Touch of Karma") and inCombat then
                        if bb.player.castTouchOfKarma() then return end
                    end
            -- Fortifying Brew
                    if isChecked("Fortifying Brew") and php<=getValue("Fortifying Brew") and inCombat then
                        if bb.player.castFortifyingBrew() then return end
                    end
            -- Diffuse Magic
                    if isChecked("Diffuse/Dampen") and ((php<=getValue("Diffuse Magic") and inCombat) or canDispel("player",bb.player.spell.diffuseMagic)) then
                        if bb.player.castDiffuseMagic() then return end
                    end
            -- Dampen Harm
                    if isChecked("Diffuse/Dampen") and php<=getValue("Dampen Harm") and inCombat then
                        if bb.player.castDampenHarm() then return end
                    end
            -- Zen Meditation
                    if isChecked("Zen Meditation") and php<=getValue("Zen Meditation") and inCombat then
                        if bb.player.castZenMeditation() then return end
                    end
            -- Nimble Brew
                    if isChecked("Nimble Brew") and hasNoControl() then
                        if bb.player.castNimbleBrew() then return end
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
                                if bb.player.castQuakingPalm(thisUnit) then return end
                            end
                        end
                    end
            -- Spear Hand Strike
                    if isChecked("Spear Hand Strike") then
                        for i=1, #getEnemies("player",5) do
                            thisUnit = getEnemies("player",5)[i]
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castSpearHandStrike(thisUnit) then return end
                            end
                        end
                    end
            -- Paralysis
                    if isChecked("Paralysis") then
                        for i=1, #getEnemies("player",20) do
                            thisUnit = getEnemies("player",20)[i]
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castParalysis(thisUnit) then return end
                            end
                        end
                    end 
            -- Leg Sweep
                    if isChecked("Leg Sweep") then
                        for i=1, #getEnemies("player",5) do
                            thisUnit = getEnemies("player",5)[i]
                            if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                                if bb.player.castLegSweep(thisUnit) then return end
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
                            useItem(bb.player.flask.wod.agilityBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if bb.player.useCrystal() then return end
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
                    if useCDs() and canUse(109217) and inRaid and isChecked("Agi-Pot") and isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                        useItem(109217)
                    end
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
                    if bb.player.castTigereyeBrew() then return end
                end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,if=buff.tigereye_brew_use.up
                -- berserking,if=buff.tigereye_brew_use.up
                -- arcane_torrent,if=buff.tigereye_brew_use.up&chi.max-chi>=1 
                if useCDs() then
                    if buff.tigereyeBrew then
                        if (bb.player.race == "Orc" or bb.player.race == "Troll") then
                            if bb.player.castRacial() then return end
                        end
                        if bb.player.race == "Blood Elf" and chi.diff>=1 then
                            if bb.player.castRacial() then return end
                        end
                    end
                end 
            -- Fists of Fury
                -- fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.serenity.up&buff.serenity.remains<1.5
                if buff.remain.tigerPower>castTimeFoF and debuff.remain.risingSunKick>castTimeFoF and buff.serenity and buff.remain.serenity<1.5 then
                    if bb.player.castFistsOfFury() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=buff.tiger_power.remains<2
                if buff.remain.tigerPower<2 then
                    if bb.player.castTigerPalm() then return end
                end
            -- Legendary Ring
                -- use_item,name=maalus_the_blood_drinker
                if useCDs() and isChecked("Legendary Ring") then
                    if hasEquiped(124636) and canUse(124636) then
                        useItem(124636)
                        return true
                    end
                end
            -- Rising Sun Kick
                -- rising_sun_kick
                if bb.player.castRisingSunKick() then return end
            -- Blackout Kick
                -- blackout_kick,if=chi.max-chi<=1&cooldown.chi_brew.up|buff.serenity.up
                if chi.diff<=1 and (cd.chiBrew==0 or buff.serenity) then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Chi Brew
                -- chi_brew,if=chi.max-chi>=2
                if chi.diff>=2 then
                    if bb.player.castChiBrew() then return end
                end
            -- Serenity
                -- serenity,if=chi.max-chi<=2
                if useCDs() and isChecked("Serenity") and chi.diff<=2 then
                    if bb.player.castSerenity() then return end
                end
            -- Jab
                -- jab,if=chi.max-chi>=2&!buff.serenity.up
                if chi.diff>=2 and not buff.serenity then
                    if bb.player.castJab() then return end
                end
            end -- End Action List - Opener
        -- Action List - Single Target
            function actionList_SingleTarget()
            -- Blackout Kick
                -- blackout_kick,if=set_bonus.tier18_2pc=1&buff.combo_breaker_bok.react
                if t18_2pc and buff.comboBreakerBlackoutKick then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=set_bonus.tier18_2pc=1&buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
                if t18_2pc and buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                    if bb.player.castTigerPalm() then return end
                end
            -- Rising Sun Kick
                -- rising_sun_kick
                if bb.player.castRisingSunKick() then return end
            -- Blackout Kick
                -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
                if buff.comboBreakerBlackoutKick or buff.serenity then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
                if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                    if bb.player.castTigerPalm() then return end
                end
            -- Chi Wave
                -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
                if ttm>2 and not buff.serenity then
                    if bb.player.castChiWave() then return end
                end
            -- Chi Burst
                -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
                if ttm>2 and not buff.serenity then
                    if bb.player.castChiBurst() then return end
                end
            -- Zen Sphere
                -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
                for i =1, #nNova do
                    thisUnit = nNova[i].unit
                    if getDistance(thisUnit)<40 then
                        if ttm>2 and getBuffRemain(thisUnit,bb.player.spell.zenSphereBuff)==0 and not buff.serenity then
                            if bb.player.castZenSphere(thisUnit) then return end
                        end
                    end
                end
            -- Chi Torpedo
                -- chi_torpedo,if=energy.time_to_max>2&buff.serenity.down&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
                if ttm>2 and not buff.serenity and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                    if bb.player.castChiTorpedo() then return end
                end
            -- Blackout Kick
                -- blackout_kick,if=chi.max-chi<2
                if chi.diff<2 then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Expel Harm
                -- expel_harm,if=chi.max-chi>=2&health.percent<95
                if chi.diff>=2 and php<95 then
                    if bb.player.castExpelHarm() then return end
                end
            -- Jab
                -- jab,if=chi.max-chi>=2
                if chi.diff>=2 then
                    if bb.player.castJab() then return end
                end
            end -- End Action List - Single Target
        -- Action List - Single Target: Chi Explosion
            function actionList_SingleTargetChiExplosion()
            -- Chi Explosion
                -- chi_explosion,if=chi>=2&buff.combo_breaker_ce.react&cooldown.fists_of_fury.remains>2
                if chi.count>=2 and buff.comboBreakerChiExplosion and cd.fistsOfFury>2 then
                    if bb.player.castChiExplosion() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
                if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                    if bb.player.castTigerPalm() then return end
                end
            -- Rising Sun Kick
                -- rising_sun_kick
                if bb.player.castRisingSunKick() then return end
            -- Chi Wave
                -- chi_wave,if=energy.time_to_max>2
                if ttm>2 then
                    if bb.player.castChiWave() then return end
                end
            -- Chi Burst
                -- chi_burst,if=energy.time_to_max>2
                if ttm>2 then
                    if bb.player.castChiBurst() then return end
                end
            -- Zen Sphere
                -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
                for i=1, #nNova do
                    thisUnit = nNova[i].unit
                    if getDistance(thisUnit)<40 then
                        if ttm>2 and getBuffRemain(thisUnit,bb.player.spell.zenSphere)==0 then
                            if bb.player.castZenSphere(thisUnit) then return end
                        end
                    end
                end
            -- Expel Harm
                -- expel_harm,if=chi.max-chi>=2&health.percent<95
                if chi.diff>=2 and php<95 then
                    if bb.player.castExpelHarm() then return end
                end
            -- Jab
                -- jab,if=chi.max-chi>=2
                if chi.diff>=2 then
                    if bb.player.castJab() then return end
                end
            -- Chi Explosion
                -- chi_explosion,if=chi>=5&cooldown.fists_of_fury.remains>4
                if chi.count>=5 and cd.fistsOfFury>4 then
                    if bb.player.castChiExplosion() then return end
                end
            -- Chi Torpedo
                -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
                if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                    if bb.player.castChiTorpedo() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=chi=4&!buff.combo_breaker_tp.react
                if chi.count==4 and not buff.comboBreakerTigerPalm then
                    if bb.player.castTigerPalm() then return end
                end
            end -- End Action List - Single Target: Chi Explosion
        -- Action List - Cleave Target: Chi Explosion
            function actionList_CleaveTargetChiExplosion()
            -- Chi Explosion
                -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>2
                if chi.count>=4 and cd.fistsOfFury>2 then
                    if bb.player.castChiExplosion() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
                if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                    if bb.player.castTigerPalm() then return end
                end
            -- Chi Wave
                -- chi_wave,if=energy.time_to_max>2
                if ttm>2 then
                    if bb.player.castChiWave() then return end
                end
            -- Chi Burst
                -- chi_burst,if=energy.time_to_max>2
                if ttm>2 then
                    if bb.player.castChiBurst() then return end
                end
            -- Zen Sphere
                -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
                for i =1, #nNova do
                    thisUnit = nNova[i].unit
                    if getDistance(thisUnit)<40 then
                        if ttm>2 and getBuffRemain(thisUnit,bb.player.spell.zenSphere)==0 then
                            if bb.player.castZenSphere(thisUnit) then return end
                        end
                    end
                end
            -- Chi Torpedo
                -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
                if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                    if bb.player.castChiTorpedo() then return end
                end
            -- Expel Harm
                -- expel_harm,if=chi.max-chi>=2&health.percent<95
                if chi.diff>=2 and php<95 then
                    if bb.player.castExpelHarm() then return end
                end
            -- Jab
                -- jab,if=chi.max-chi>=2
                if chi.diff>=2 then
                    if bb.player.castJab() then return end
                end
            end -- End Action List - Cleave Target: Chi Explosion
        -- Action List - Multi-Target: No Rushing Jade Wind
            function actionList_MultiTargetNoRushingJadeWind()
            -- Chi Wave
                -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
                if ttm>2 and not buff.serenity then
                    if bb.player.castChiWave() then return end
                end
            -- Chi Burst
                -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
                if ttm>2 and not buff.serenity then
                    if bb.player.castChiBurst() then return end
                end
            -- Zen Sphere
                -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
                for i =1, #nNova do
                    thisUnit = nNova[i].unit
                    if getDistance(thisUnit)<40 then
                        if ttm>2 and getBuffRemain(thisUnit,bb.player.spell.zenSphere)==0 and not buff.serenity then
                            if bb.player.castZenSphere(thisUnit) then return end
                        end
                    end
                end
            -- Blackout Kick
                -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
                if buff.comboBreakerBlackoutKick or buff.serenity then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
                if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                    if bb.player.castTigerPalm() then return end
                end
            -- Blackout Kick
                -- blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
                if chi.diff<2 and cd.fistsOfFury>3 then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Chi Torpedo
                -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
                if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                    if bb.player.castChiTorpedo() then return end
                end
            -- Spinning Crane Kick
                -- spinning_crane_kick
                if bb.player.level<46 then
                    if bb.player.castJab() then return end
                else
                    if bb.player.castSpinningCraneKick() then return end
                end
            end -- End Action List - Multi-Target: No Rushing Jade Wind
        -- Action List - Multi-Target: No Rushing Jade Wind - Chi Explosion
            function actionList_MultiTargetNoRushingJadeWindChiExplosion()
            -- Chi Explosion
                -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
                if chi.count>=4 and cd.fistsOfFury>4 then
                    if bb.player.castChiExplosion() then return end
                end
            -- Rising Sun Kick
                -- rising_sun_kick,if=chi=chi.max
                if chi.count==chi.max then
                    if bb.player.castRisingSunKick() then return end
                end
            -- Chi Wave
                -- chi_wave,if=energy.time_to_max>2
                if ttm>2 then
                    if bb.player.castChiWave() then return end
                end
            -- Chi Burst
                -- chi_burst,if=energy.time_to_max>2
                if ttm>2 then
                    if bb.player.castChiBurst() then return end
                end
            -- Zen Sphere
                -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
                for i =1, #nNova do
                    thisUnit = nNova[i].unit
                    if getDistance(thisUnit)<40 then
                        if ttm>2 and getBuffRemain(thisUnit,bb.player.spell.zenSphere)==0 then
                            if bb.player.castZenSphere(thisUnit) then return end
                        end
                    end
                end
            -- Chi Torpedo
                -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
                if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                    if bb.player.castChiTorpedo() then return end
                end
            -- Spinning Crane Kick
                -- spinning_crane_kick
                if bb.player.level<46 then
                    if bb.player.castJab() then return end
                else
                    if bb.player.castSpinningCraneKick() then return end
                end
            end -- End Action List - Multi-Target: No Rushing Jade Wind - Chi Explosion
        -- Action List - Multi-Target: Rushing Jade Wind
            function actionList_MultiTargetRushingJadeWind()
            -- Chi Explosion
                -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
                if chi.count>=4 and cd.fistsOfFury>4 then
                    if bb.player.castChiExplosion() then return end
                end
            -- Rushing Jade Wind
                -- rushing_jade_wind
                if bb.player.castRushingJadeWind() then return end
            -- Chi Wave
                -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
                if ttm>2 and not buff.serenity then
                    if bb.player.castChiWave() then return end
                end
            -- Chi Burst
                -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
                if ttm>2 and not buff.serenity then
                    if bb.player.castChiBurst() then return end
                end
            -- Zen Sphere
                -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
                for i =1, #nNova do
                    thisUnit = nNova[i].unit
                    if getDistance(thisUnit)<40 then
                        if ttm>2 and getBuffRemain(thisUnit,bb.player.spell.zenSphere)==0 and not buff.serenity then
                            if bb.player.castZenSphere(thisUnit) then return end
                        end
                    end
                end
            -- Blackout Kick
                -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
                if buff.comboBreakerBlackoutKick or buff.serenity then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Tiger Palm
                -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
                if buff.comboBreakerTigerPalm and buff.remain.comboBreakerTigerPalm<=2 then
                    if bb.player.castTigerPalm() then return end
                end
            -- Blackout Kick
                -- blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
                if chi.diff<2 and cd.fistsOfFury>3 then
                    if bb.player.castBlackoutKick() then return end
                end
            -- Chi Torpedo
                -- chi_torpedo,if=energy.time_to_max>2&(((charges=2|(charges=1&recharge_time<=4))&!talent.celerity.enabled)|((charges=3|(charges=2&recharge_time<=4))&talent.celerity.enabled))
                if ttm>2 and (((charges.chiTorpedo==2 or (charges.chiTorpedo==1 and recharge.chiTorpedo<=4)) and not talent.celerity) or ((charges.chiTorpedo==3 or (charges.chiTorpedo==2 and recharge.chiTorpedo<=4)) and talent.celerity)) then
                    if bb.player.castChiTorpedo() then return end
                end
            -- Expel Harm
                -- expel_harm,if=chi.max-chi>=2&health.percent<95
                if chi.diff>=2 and php<95 then
                    if bb.player.castExpelHarm() then return end
                end
            -- Jab
                -- jab,if=chi.max-chi>=2
                if chi.diff>=2 then
                    if bb.player.castJab() then return end
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
                        if getDistance(bb.player.units.dyn5)<5 then
                            StartAttack()
                        end
        --  Invoke Xuen
                        -- invoke_xuen
                        if useCDs() then
                            if bb.player.castInvokeXuen() then return end
                        end
        -- Storm, Earth, and Fire
                        -- storm_earth_and_fire,target=2,if=debuff.storm_earth_and_fire_target.down
                        -- storm_earth_and_fire,target=3,if=debuff.storm_earth_and_fire_target.down
                        if BadBoy_data['SEF']==1 then
                            if bb.player.castStormEarthAndFire() then return end
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
                        if useCDs() and canUse(109217) and inRaid and isChecked("Agi-Pot") then
                            if buff.serenity or (not talent.serenity and trinketProc) or hasBloodLust() or ttd<=60 then
                                useItem(109217)
                            end
                        end
        -- Legendary Ring
                        -- use_item,name=maalus_the_blood_drinker,if=buff.tigereye_brew_use.up|target.time_to_die<18
                        if useCDs() and isChecked("Legendary Ring") and (buff.tigereyeBrew or ttd<18) then
                            if hasEquiped(124636) and canUse(124636) then
                                useItem(124636)
                                return true
                            end
                        end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                        -- blood_fury,if=buff.tigereye_brew_use.up|target.time_to_die<18
                        -- berserking,if=buff.tigereye_brew_use.up|target.time_to_die<18
                        -- arcane_torrent,if=chi.max-chi>=1&(buff.tigereye_brew_use.up|target.time_to_die<18)
                        if useCDs() then
                            if buff.tigereyeBrew or ttd<18 then
                                if (bb.player.race == "Orc" or bb.player.race == "Troll") then
                                    if castSpell("player",racial,false,false,false) then return end
                                end
                                if bb.player.race == "Blood Elf" and chi.diff>=1 then
                                    if castSpell("player",racial,false,false,false) then return end
                                end
                            end
                        end
        -- Trinkets
                        if useCDs() and isChecked("Trinkets") then
                            if canUse(13) then
                                useItem(13)
                            end
                            if canUse(14) then
                                useItem(14)
                            end
                        end 
        -- Chi Brew
                        -- chi_brew,if=chi.max-chi>=2&((charges=1&recharge_time<=10)|charges=2|target.time_to_die<charges*10)&buff.tigereye_brew.stack<=16
                        if chi.diff>=2 and ((charges.chiBrew==1 and recharge.chiBrew<=10) or charges.chiBrew==2 or ttd<charges.chiBrew*10) and charges.tigereyeBrew<=16 then
                            if bb.player.castChiBrew() then return end
                        end
        -- Tiger Palm
                        -- tiger_palm,if=!talent.chi_explosion.enabled&buff.tiger_power.remains<6.6
                        if not talent.chiExplosion and buff.remain.tigerPower<6.6 then
                            if bb.player.castTigerPalm() then return end
                        end
                        -- tiger_palm,if=talent.chi_explosion.enabled&(cooldown.fists_of_fury.remains<5|cooldown.fists_of_fury.up)&buff.tiger_power.remains<5
                        if talent.chiExplosion and (cd.fistsOfFury<5 or cd.fistsOfFury==0) and buff.remain.tigerPower<5 then
                            if bb.player.castTigerPalm() then return end
                        end
        -- Tigereye Brew
                        -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack=20
                        if not buff.tigereyeBrew and charges.tigereyeBrew==20 then
                            if bb.player.castTigereyeBrew() then return end
                        end
                        -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&buff.serenity.up
                        if not buff.tigereyeBrew and charges.tigereyeBrew>=9 and buff.serenity then
                            if bb.player.castTigereyeBrew() then return end
                        end
                        -- tigereye_brew,if=talent.chi_explosion.enabled&buff.tigereye_brew_use.down
                        if talent.chiExplosion and not buff.tigereyeBrew then
                            if bb.player.castTigereyeBrew() then return end
                        end
                        -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&cooldown.fists_of_fury.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
                        if not buff.tigereyeBrew and charges.tigereyeBrew>=9 and cd.fistsOfFury==0 and chi.count>=3 and debuff.risingSunKick and buff.tigerPower then
                            if bb.player.castTigereyeBrew() then return end
                        end
                        -- tigereye_brew,if=talent.hurricane_strike.enabled&buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&cooldown.hurricane_strike.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
                        if talent.hurricaneStrike and not buff.tigereyeBrew and charges.tigereyeBrew>=9 and cd.hurricaneStrike==0 and debuff.risingSunKick and buff.tigerPower then
                            if bb.player.castTigereyeBrew() then return end
                        end
                        -- tigereye_brew,if=buff.tigereye_brew_use.down&chi>=2&(buff.tigereye_brew.stack>=16|target.time_to_die<40)&debuff.rising_sun_kick.up&buff.tiger_power.up
                        if not buff.tigereyeBrew and chi.count>=2 and (charges.tigereyeBrew>=16 or ttd<40) and debuff.risingSunKick and buff.tigerPower then
                            if bb.player.castTigereyeBrew() then return end
                        end
        -- Fortifying Brew
                        -- fortifying_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&(glyph.touch_of_death.enabled|chi>=3)
                        if isChecked("Fort Brew w/ ToD") and (thp<10 or UnitHealth("player")*1.2>=UnitHealth("target")) and cd.touchOfDeath==0 and (glyph.touchOfDeath or chi.count>=3) and ObjectExists("target") then
                            if bb.player.castFortifyingBrew() then return end
                        end
        -- Touch of Death
                        -- touch_of_death,if=target.health.percent<10&(glyph.touch_of_death.enabled|chi>=3)
                        if (thp<10 or UnitHealth("player")>=UnitHealth("target")) and (glyph.touchOfDeath or chi.count>=3) then
                            if bb.player.castTouchOfDeath() then return end
                        end
        -- Rising Sun Kick
                        -- rising_sun_kick,if=(debuff.rising_sun_kick.down|debuff.rising_sun_kick.remains<3)
                        if (not debuff.risingSunKick or debuff.remain.risingSunKick<3) then
                            if bb.player.castRisingSunKick() then return end
                        end
        -- Serenity
                        -- serenity,if=chi>=2&buff.tiger_power.up&debuff.rising_sun_kick.up
                        if useCDs() and isChecked("Serenity") and chi.count>=2 and buff.tigerPower and debuff.risingSunKick then
                            if bb.player.castSerenity() then return end
                        end
        -- Fists of Fury
                        -- fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&energy.time_to_max>cast_time&!buff.serenity.up
                        if buff.remain.tigerPower>castTimeFoF and debuff.remain.risingSunKick>castTimeFoF and ttm>castTimeFoF and not buff.serenity then
                            if bb.player.castFistsOfFury() then return end
                        end
        -- Hurricane Strike
                        -- hurricane_strike,if=energy.time_to_max>cast_time&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.energizing_brew.down
                        if ttm>castTimeHS and buff.remain.tigerPower>castTimeHS and debuff.remain.risingSunKick>castTimeHS and not buff.energizingBrew then
                            if bb.player.castHurricaneStrike() then return end
                        end
        -- Energizing Brew
                        -- energizing_brew,if=cooldown.fists_of_fury.remains>6&(!talent.serenity.enabled|(!buff.serenity.remains&cooldown.serenity.remains>4))&energy+energy.regen<50
                        if cd.fistsOfFury>6 and (not talent.serenity or (not buff.serenity and cd.serenity>4)) and power+regen<50 then
                            if bb.player.castEnergizingBrew() then return end
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
                            if bb.player.castTigerPalm() then return end
                        end
                    end -- End Combat Check 
                end -- End Death Monk Mode Check
            end -- End Pause
        end -- End Timer
    end -- End runRotation
    tinsert(cWindwalker.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Check

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
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.tigerPalm },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.effuse}
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
            [2] = { mode = "Off", value = 1 , overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = bb.player.spell.stormEarthAndFireFixate}
        };
        CreateButton("SEF",5,0)
    -- Flying Serpent Kick Button
        FSKModes = {
            [1] = { mode = "On", value = 2 , overlay = "Auto FSK Enabled", tip = "Will cast Flying Serpent Kick.", highlight = 1, icon = bb.player.spell.flyingSerpentKick},
            [2] = { mode = "Off", value = 1 , overlay = "Auto FSK Disabled", tip = "Will NOT cast Flying Serpent Kick.", highlight = 0, icon = bb.player.spell.flyingSerpentKickEnd}
        };
        CreateButton("FSK",6,0)
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
            -- APL
                bb.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                bb.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Opener
                bb.ui:createCheckbox(section, "Opener")
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Roll
                bb.ui:createCheckbox(section, "Roll")         
            bb.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = bb.ui:createSection(bb.ui.window.profile,  "Cooldowns")
            -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
            -- Legendary Ring
                bb.ui:createCheckbox(section,"Legendary Ring")
            -- Potion
                bb.ui:createCheckbox(section,"Potion")
            -- Racial
                bb.ui:createCheckbox(section,"Racial")
            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
            -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")
            -- Serenity
                bb.ui:createCheckbox(section,"Serenity")
            -- Touch of Death
                bb.ui:createCheckbox(section,"Touch of Death")
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
            -- Effuse
                bb.ui:createSpinner(section, "Effuse",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Healing Elixir
                bb.ui:createSpinner(section, "Healing Elixir", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Leg Sweep
                bb.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
                bb.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
            -- Touch of Karma
                bb.ui:createSpinner(section, "Touch of Karma",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Diffuse Magic/Dampen Harm
                bb.ui:createSpinner(section, "Diffuse/Dampen",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
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
        if bb.timer:useTimer("debugWindwalker", math.random(0.15,0.3)) then
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
            
    --------------
    --- Locals ---
    --------------
            local agility           = UnitStat("player", 2)
            local artifact          = bb.player.artifact
            local baseAgility       = 0
            local baseMultistrike   = 0
            local buff              = bb.player.buff
            local canFlask          = canUse(bb.player.flask.wod.agilityBig)
            local cast              = bb.player.cast
            local castTimeFoF       = 4-(4*UnitSpellHaste("player")/100)
            local castTimeHS        = 2-(2*UnitSpellHaste("player")/100)
            local cd                = bb.player.cd
            local charges           = bb.player.charges
            local chi               = bb.player.chi
            local combatTime        = getCombatTime()
            local debuff            = bb.player.debuff
            local enemies           = bb.player.enemies
            local flaskBuff         = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig) or 0
            local gcd               = bb.player.gcd
            local glyph             = bb.player.glyph
            local healthPot         = getHealthPot() or 0
            local inCombat          = bb.player.inCombat
            local inRaid            = select(2,IsInInstance())=="raid"
            local lastSpell         = lastSpellCast
            local level             = bb.player.level
            local mode              = bb.player.mode
            local php               = bb.player.health
            local power             = bb.player.power
            local powerMax          = bb.player.powerMax
            local pullTimer         = bb.DBM:getPulltimer()
            local queue             = bb.player.queue
            local race              = bb.player.race
            local racial            = bb.player.getRacial()
            local recharge          = bb.player.recharge
            local regen             = bb.player.powerRegen
            local solo              = select(2,IsInInstance())=="none"
            local spell             = bb.player.spell
            local t17_2pc           = bb.player.eq.t17_2pc
            local t18_2pc           = bb.player.eq.t18_2pc 
            local t18_4pc           = bb.player.eq.t18_4pc
            local talent            = bb.player.talent
            local thp               = getHP(bb.player.units.dyn5)
            local trinketProc       = false --bb.player.hasTrinketProc()
            local ttd               = getTTD(bb.player.units.dyn5)
            local ttm               = bb.player.timeToMax
            local units             = bb.player.units
            if lastSpell == nil then lastSpell = 0 end
            if leftCombat == nil then leftCombat = GetTime() end
            if profileStop == nil then profileStop = false end

            if not inCombat then 
                opener = false
                OoRchiWave = false
                FSK = false
                iRchiWave = false
                EE = false
                ToD = false
                SER = false
                RSK1 = false
                SotW = false
                FoF1 = false
                RSK2 = false
                SCK = false
                BOK = false
                RSK3 = false
                TP1 = false
                TP2 = false
                FoF2 = false
                SEF = false
                WDP = false 
            end
             -- Mark of the Crane Count
            markOfTheCraneCount = 0
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.spec.debuffs.markOfTheCrane,"player") or 0
                if markOfTheCraneRemain > 0 then
                    markOfTheCraneCount = markOfTheCraneCount + 1
                end
            end
            if #enemies.yards5 > 0 then
                markPercent = (markOfTheCraneCount/#enemies.yards5)*100
            else
                markPercent = 0
            end
            -- ChatOverlay("Mark Count: "..markOfTheCraneCount..", Num Enemies: "..#enemies.yards5..", Mark %: "..markPercent)
            -- ChatOverlay("Mark of the Crane Remain: "..getDebuffRemain("target",spell.spec.debuffs.markOfTheCrane,"player"))
 
            -- if buff.stacks.hitCombo == 8 then maxCombo = true else maxCombo = false end
            -- if inCombat and maxCombo then 
            --     maxComboReached = true 
            -- elseif not inCombat or (maxComboReached and not maxCombo) then
            --     maxComboReached = false
            -- end
            -- if inCombat and maxComboReached and not maxCombo then
            --     print(select(1,GetSpellInfo(lastSpell)).." Reset Hit Combo!")
            --     maxComboReached = false
            -- end
            -- if inCombat and lastSpell ~= prevSpell then
            --     print(select(1,GetSpellInfo(lastSpell)))
            --     prevSpell = lastSpell
            -- end

    --------------------
    --- Action Lists ---
    --------------------
        -- Action List - Extras
            function actionList_Extras()
            -- Stop Casting
                if ((cd.risingSunKick == 0 or cd.fistsOfFury == 0 or cd.strikeOfTheWindlord == 0) and isCastingSpell(spell.cracklingJadeLightning)) then
                    SpellStopCasting()
                end
            -- Tiger's Lust
                if hasNoControl() or (inCombat and getDistance("target") > 10 and isValidUnit("target")) then
                    if cast.tigersLust() then return end
                end
            -- Detox
                if canDispel("player",spell.detox) then
                    if cast.detox("player") then return end
                end
                if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                    if canDispel("mouseover",spell.detox) then
                        if cast.detox("mouseover") then return end
                    end
                end
            -- Resuscitate
                if cast.resuscitate() then return end
            -- Provoke
                if not inCombat and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" 
                    and cd.flyingSerpentKick > 1 and getDistance("target") > 10 and isValidUnit("target") and not isBoss("target")
                then
                    if solo or #bb.friend == 1 then
                        if cast.provoke() then return end
                    end
                end
            -- Flying Serpent Kick
                if useFSK() then
                    if cast.flyingSerpentKick() then return end 
                    if cast.flyingSerpentKickEnd() then return end
                end
            -- Roll
                if isChecked("Roll") and getDistance("target") > 10 and isValidUnit("target") and getFacingDistance() < 5 and getFacing("player","target",10) then
                    if cast.roll() then return end
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
                -- if getDistance(units.dyn5) >= 5 and ((useFSK() and cd.flyingSerpentKick > 1) or not useFSK()) 
                --     and not isCastingSpell(spell.cracklingJadeLightning) and (hasThreat("target") or isDummy()) and not isMoving("player") 
                -- then
                --     if cast.cracklingJadeLightning() then return end
                -- end
            -- Touch of the Void
                if (useCDs() or useAoE()) and isChecked("Touch of the Void") and inCombat and getDistance(units.dyn5)<5 then
                    if hasEquiped(128318) then
                        if GetItemCooldown(128318)==0 then
                            useItem(128318)
                        end
                    end
                end
            -- Fixate - Storm, Earth, and Fire
                if isDummy("target") then
                    if cast.stormEarthAndFireFixate() then return end
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
            -- Diffuse Magic
                    if isChecked("Diffuse/Dampen") and ((php <= getValue("Diffuse Magic") and inCombat) or canDispel("player",bb.player.spell.diffuseMagic)) then
                        if cast.diffuseMagic() then return end
                    end
            -- Dampen Harm
                    if isChecked("Diffuse/Dampen") and php <= getValue("Dampen Harm") and inCombat then
                        if cast.dampenHarm() then return end
                    end
            -- Effuse
                    if isChecked("Effuse") and ((not inCombat and php <= getOptionValue("Effuse")) --[[or (inCombat and php <= getOptionValue("Effuse") / 2)]]) then
                        if cast.effuse() then return end
                    end
            -- Healing Elixir
                    if isChecked("Healing Elixir") and php <= getValue("Healing Elixir") then
                        if cast.healingElixir() then return end
                    end
            -- Leg Sweep
                    if isChecked("Leg Sweep - HP") and php <= getValue("Leg Sweep - HP") and inCombat and #enemies.yards5 > 0 then
                        if cast.legSweep() then return end
                    end
                    if isChecked("Leg Sweep - AoE") and #enemies.yards5 >= getValue("Leg Sweep - AoE") then
                        if cast.legSweep() then return end
                    end
            -- Touch of Karma
                    if isChecked("Touch of Karma") and php <= getValue("Touch of Karma") and inCombat then
                        if cast.touchOfKarma() then return end
                    end
                end -- End Defensive Check
            end -- End Action List - Defensive
        -- Action List - Interrupts
            function actionList_Interrupts()
                if useInterrupts() then
                    for i=1, #getEnemies("player",20) do
                        thisUnit = getEnemies("player",20)[i]
                        distance = getDistance(thisUnit)
                        if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                            if distance < 5 then
            -- Quaking Palm
                                if isChecked("Quaking Palm") then
                                    if cast.quakingPalm(thisUnit) then return end
                                end
            -- Spear Hand Strike
                                if isChecked("Spear Hand Strike") then
                                    if cast.spearHandStrike(thisUnit) then return end
                                end
            -- Leg Sweep
                                if isChecked("Leg Sweep") then
                                    if cast.legSweep(thisUnit) then return end
                                end
                            end
            -- Paralysis
                            if isChecked("Paralysis") then
                                if cast.paralysis(thisUnit) then return end
                            end
                        end
                    end 
                end -- End Interrupt Check
            end -- End Action List - Interrupts
        -- Action List - Cooldowns
            function actionList_Cooldown()
                if useCDs() and getDistance("target") < 5 then
            -- Legendary Ring
                    -- use_item,name=maalus_the_blood_drinker,if=buff.tigereye_brew_use.up|target.time_to_die<18
                    if isChecked("Legendary Ring") and (buff.tigereyeBrew or ttd<18) then
                        if hasEquiped(124636) and canUse(124636) then
                            useItem(124636)
                            return true
                        end
                    end
            -- Trinkets
                    if isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end                    
            -- Invoke Xuen
                    -- invoke_xuen
                    if isChecked("Xuen") then
                        if cast.invokeXuen() then return end
                    end
            -- Racial - Blood Fury / Berserking
                    -- blood_fury
                    -- berserking
                    if isChecked("Racial") and (race == "Orc" or race == "Troll") then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Touch of Death
                    -- touch_of_death,cycle_targets=1,max_cycle_targets=2,if=!artifact.gale_burst.enabled&equipped.137057&!prev_gcd.touch_of_death
                    -- touch_of_death,if=!artifact.gale_burst.enabled&!equipped.137057
                    -- touch_of_death,cycle_targets=1,max_cycle_targets=2,if=artifact.gale_burst.enabled&equipped.137057&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7&!prev_gcd.touch_of_death
                    -- touch_of_death,if=artifact.gale_burst.enabled&!equipped.137057&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7
                    if isChecked("Touch of Death")
                        and ((not artifact.galeBurst and hasEquiped(137057) and lastSpell ~= spell.touchOfDeath)
                            or (not artifact.galeBurst and not hasEquiped(137057))
                            or (artifact.galeBurst and hasEquiped(137057) and cd.strikeOfTheWindlord < 8 and cd.fistsOfFury <= 4 and cd.risingSunKick < 7 and lastSpell ~= spell.touchOfDeath)
                            or (artifact.galeBurst and not hasEquiped(137057) and cd.strikeOfTheWindlord < 8 and cd.fistsOfFury <= 4 and cd.risingSunKick < 7)) 
                    then
                        if hasEquiped(137057) then
                            for i = 1, #enemies.yards5 do
                                local thisUnit = enemies.yards5[i]
                                local touchOfDeathDebuff = UnitDebuffID(thisUnit,spell.spec.debuffs.touchOfDeath,"player") ~= nil
                                if not touchOfDeathDebuff then
                                    if cast.touchOfDeath() then return end
                                end
                            end
                        else
                            if cast.touchOfDeath() then return end
                        end
                    end
                end
            end -- End Cooldown - Action List
        -- Action List - Opener
            function actionList_Opener()
                if isBoss("target") and opener == false then
                    if talent.whirlingDragonPunch and talent.energizingElixir and getDistance("target") < 5 then
            -- Tiger Palm
                        if not TP1 and chi.count < 2 then
                            if cast.tigerPalm("target") then print("1: Tiger Palm"); TP1 = true; return end
            -- Touch of Death
                        elseif not ToD and not UnitDebuffID("target",spell.spec.debuffs.touchOfDeath,"player") then
                            if cd.touchOfDeath == 0 then
                                if cast.touchOfDeath("target") then print("2: Touch of Death"); ToD = true; return end
                            elseif cd.touchOfDeath > gcd then
                                ToD = true
                            end
            -- Storm, Earth, and Fire
                        elseif not SEF then
                            if charges.stormEarthAndFire > 0 and useSEF() then
                                if cast.stormEarthAndFire() then print("3: Storm, Earth, and Fire"); SEF = true; return end
                            elseif cd.stormEarthAndFire > gcd then
                                SEF = true
                            end
            -- Rising Sun Kick
                        elseif not RSK1 then
                            if cd.risingSunKick == 0 then
                                if cast.risingSunKick("target") then print("4: Rising Sun Kick"); RSK1 = true; return end
                            elseif cd.risingSunKick > gcd then
                                RSK1 = true
                            end
            -- Energizing Elixir
                        elseif not EE then
                            if cd.energizingElixir == 0 then
                                if cast.energizingElixir() then print("5: Energizing Elixir"); EE = true; return end
                            elseif cd.energizingElixir > gcd then
                                EE = true
                            end
            -- Fists of Fury
                        elseif not FoF1 then
                            if cd.fistsOfFury == 0 then
                                if cast.fistsOfFury("target") then print("6: Fists of Fury"); FoF1 = true; return end
                            elseif cd.fistsOfFury > gcd then
                                FoF1 = true
                            end
            -- Strike of the Windlord
                        elseif not SotW then
                            if cd.strikeOfTheWindlord == 0 then
                                if cast.strikeOfTheWindlord("target") then print("7: Strike of the Windlord"); SotW = true; return end
                            elseif cd.strikeOfTheWindlord > gcd then
                                SotW = true
                            end
            -- Tiger Palm
                        elseif not TP2 and chi.count < 2 then
                            if cast.tigerPalm("target") then print("8: Tiger Palm"); TP2 = true; return end
            -- Whirling Dragon Punch
                        elseif not WDP then
                            if cd.whirlingDragonPunch == 0 then
                                if cast.whirlingDragonPunch("target") then print("9: Whirling Dragon Punch"); WDP = true; return end
                            elseif cd.whirlingDragonPunch > gcd then 
                                WDP = true
                            end
            -- Rising Sun Kick
                        elseif not RSK2 then
                            if cd.risingSunKick == 0 then
                                if cast.risingSunKick("target") then print("10: Rising Sun Kick"); RSK2 = true; return end
                            elseif cd.risingSunKick > gcd then
                                RSK2 = true
                            end
                        elseif RSK2 then
                            opener = true
                        end
                    end
                    if talent.whirlingDragonPunch and talent.powerStrikes then
                        -- TP -> ToD -> TP + SEF -> FoF -> SotWL -> TP -> RSK -> WDP -> TP
                    end
                    if talent.serenity --[[and artifact.galeBurst]] then
                        -- Chi Wave (out of boss range on self) -> FSK (don’t hit anything) -> Prepotion -> Chi Wave (on target) 
                        -- -> EE ->  ToD -> On use trinket (if you have one) -> Serenity + RSK > SotW -> FoF -> RSK -> SCK -> BoK 
                        -- -> Serenity complete -> RSK -> TP -> FOF
                        if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
            -- Chi Wave (Out of Range)
                            if OoRchiWave == false and getDistance("target") >= 25 then
                                if cast.chiWave() then print("1: Chi Wave"); OoRchiWave = true; return end
                            end
            -- Potion
                            -- potion,name=old_war
                            if useCDs() and canUse(127844) and inRaid and isChecked("Potion") and getDistance("target") < 10 then
                                useItem(127844);
                                return
                            end
            -- Flying Serpent Kick (No Hit)
                            if FSK == false then
                                if getDistance("target") >= 15 then 
                                    if cast.flyingSerpentKick() then print("2: Flying Serpent Kick: Start"); return end
                                else
                                    if cast.flyingSerpentKickEnd() then print("3: Flying Serpent Kick: End"); FSK = true; return end
                                end
                            end
            -- Chi Wave (In Range)
                            if iRchiWave == false and not buff.serenity and cd.serenity == 0  and getDistance("target") < 25 then
                                if cast.chiWave() then print("4: Chi Wave"); iRchiWave = true; return end
                            end
                        end
                        if getDistance("target") < 5 then
            -- Energizing Elixir
                            if EE == false then
                                if cast.energizingElixir() then print("5: Energizing Elixir"); EE = true; return end
                            end
            -- Touch of Death
                            if ToD == false and not UnitDebuffID("target",spell.spec.debuffs.touchOfDeath,"player") then
                                if cast.touchOfDeath("target") then print("6: Touch of Death"); TOD = true; return end
                            end
            -- Trinkets
                            if isChecked("Trinkets") then
                                if canUse(13) then
                                    useItem(13)
                                end
                                if canUse(14) then
                                    useItem(14)
                                end
                            end
            -- Serenity
                            if SER == false and (cd.touchOfDeath > 0 or debuff.touchOfDeath) then
                                if cast.serenity() then print("7: Serenity"); SER = true; return end
                            end
            -- Rising Sun Kick
                            if buff.serenity then
                                if RSK1 == false then
                                    if cast.risingSunKick("target") then print("8: Rising Sun Kick"); RSK1 = true; return end
                                end
            -- Strike of the Windlord
                                if SotW == false then
                                    if cast.strikeOfTheWindlord("target") then print("9: Strike of the Windlord"); SotW = true; return end
                                end
            -- Fists of Fury
                                if FoF1 == false then
                                    if cast.fistsOfFury("target") then print("10: Fists of Fury"); FoF1 = true; return end
                                end
            -- Rising Sun Kick
                                if RSK2 == false then
                                    if cast.risingSunKick("target") then print("11: Rising Sun Kick"); RSK2 = true; return end
                                end
            -- Spinning Crane Kick
                                if SCK == false then
                                    if cast.spinningCraneKick("target") then print("12: Spinning Crane Kick"); SCK = true; return end
                                end
            -- Blackout Kick
                                if BOK == false then
                                    if cast.blackoutKick("target") then print("13: Blackout Kick"); BOK = true; return end
                                end
                            end
                            if not buff.serenity and cd.serenity ~= 0 then
            -- Rising Sun Kick
                                if RSK3 == false then
                                    if cast.risingSunKick("target") then print("14: Rising Sun Kick"); RSK3 = true; return end
                                end
            -- Tiger Palm
                                if (TP1 == false or TP1 == true and chi.count < 3) and lastSpell == spell.risingSunKick then
                                    if cast.tigerPalm("target") then print("15: Tiger Palm"); TP1 = true; return end
                                end
            -- Fists of Fury
                                if FoF2 == false then
                                    if cast.fistsOfFury("target") then print("16: Fists of Fury"); FoF2 = true; opener = true; return end
                                end
                            end
                        end 
                    end
                    -- if talent.serenity and not artifact.galeBurst then
                        -- Serenity -> RSK -> SotW -> SCK -> BoK -> SCK -> RSK -> SCK -> FoF
                    -- end
                end
            end
        -- Action List - Single Target
            function actionList_SingleTarget()
            -- Action List - Cooldown
                -- call_action_list,name=cd
                if actionList_Cooldown() then return end
            -- Racial - Arcane Torrent
                -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.
                if chi.max >= chi.count and ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" then
                    if castSpell("player",racial,false,false,false) then return end
                end
            -- Energizing Elixir
                -- energizing_elixir,if=energy<energy.max&chi<=1
                if power < powerMax and chi.count <= 1 then
                    if cast.energizingElixir() then return end
                end
            -- Strike of the Windlord
                -- strike_of_the_windlord,if=talent.serenity.enabled|active_enemies<6
                if ((talent.serenity and cd.serenity > 20) or not isChecked("Serenity") or not useCDs()) or (not talent.serenity and #enemies.yards5 < 6) then
                    if cast.strikeOfTheWindlord() then return end
                end
            -- Fists of Fury
                -- fists_of_fury
                if markPercent < 75 or #enemies.yards5 < 3 then
                    if cast.fistsOfFury() then return end
                end
            -- Rising Sun Kick
                -- rising_sun_kick
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.spec.debuffs.markOfTheCrane,"player")
                    if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                        if cast.risingSunKick(thisUnit) then return end
                    end
                end
            -- Whirling Dragon Punch
                -- whirling_dragon_punch
                if cast.whirlingDragonPunch() then return end
            -- Spinning Crane Kick
                -- spinning_crane_kick,if=active_enemies>=3&!prev_gcd.spinning_crane_kick
                if #enemies.yards5 >= 3 and markPercent >= 75 and lastSpell ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                end
            -- Rushing Jade Wind
                -- rushing_jade_wind,if=chi.max-chi>1&!prev_gcd.rushing_jade_wind
                if chi.max - chi.count > 1 and lastSpell ~= spell.rushingJadeWind then
                    if cast.rushingJadeWind() then return end
                end
            -- Blackout Kick
                -- blackout_kick,cycle_targets=1,if=(chi>1|buff.bok_proc.up)&!prev_gcd.blackout_kick
                if (chi.count > 1 or buff.blackoutKick) and lastSpell ~= spell.blackoutKick then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.spec.debuffs.markOfTheCrane,"player")
                        if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                            if cast.blackoutKick(thisUnit) then return end
                        end
                    end
                end
            -- Chi Wave
                -- chi_wave,if=energy.time_to_max>=2.25
                if ttm >= 2.25 then
                    if cast.chiWave() then return end
                end
            -- Chi Burst
                -- chi_burst,if=energy.time_to_max>=2.25
                if ttm >= 2.25 then
                    if cast.chiBurst() then return end
                end
            -- Tiger Palm
                -- tiger_palm,cycle_targets=1,if=!prev_gcd.tiger_palm
                if lastSpell ~= spell.tigerPalm then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.spec.debuffs.markOfTheCrane,"player")
                        if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                            if cast.tigerPalm(thisUnit) then return end
                        end
                    end
                end
            -- Crackling Jade Lightning
                -- crackling_jade_lightning,interrupt=1,if=talent.rushing_jade_wind.enabled&chi.max-chi=1&prev_gcd.blackout_kick&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>1&cooldown.strike_of_the_windlord.remains>1&cooldown.rushing_jade_wind.remains>1
                -- crackling_jade_lightning,interrupt=1,if=!talent.rushing_jade_wind.enabled&chi.max-chi=1&prev_gcd.blackout_kick&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>1&cooldown.strike_of_the_windlord.remains>1
                if chi.max - chi.count == 1 and lastSpell == spell.blackoutKick and cd.risingSunKick > 1 and cd.fistsOfFury > 1 
                    and cd.strikeOfTheWindlord > 1 and ((talent.rushingJadeWind and cd.rushingJadeWind > 1) or not talent.rushingJadeWind) 
                then
                    if cast.cracklingJadeLightning() then return end
                end
            end -- End Action List - Single Target 
        -- Action List - Storm, Earth, and Fire
            function actionList_SEF()
                if useSEF() then
            -- Energizing Elixir
                    -- energizing_elixir
                    if cast.energizingElixir() then return end
            -- Racial - Arcane Torrent
                    -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.
                    if chi.max >= chi.count and ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Call Action List - Cooldowns
                    -- call_action_list,name=cd
                    if actionList_Cooldown() then return end
            -- Storm, Earth, and Fire
                    -- storm_earth_and_fire
                    if cast.stormEarthAndFire() then return end
            -- Call Action List - Single Target
                    -- call_action_list,name=st
                    if actionList_SingleTarget() then return end
                end
            end -- End SEF - Action List
        -- Action List - Serenity
            function actionList_Serenity()
            -- Energizing Elixir
                -- energizing_elixir
                if cast.energizingElixir() then return end
            -- Call Action List - Cooldowns
                -- call_action_list,name=cd
                if actionList_Cooldown() then return end
            -- Serenity
                -- serenity
                if cd.touchOfDeath > 45 then
                    if cast.serenity() then return end
                end
            -- Strike of the Windlord
                -- strike_of_the_windlord
                if buff.serenity then
                    if cast.strikeOfTheWindlord() then return end
                end
            -- Rising Sun Kick
                -- rising_sun_kick,cycle_targets=1,if=active_enemies<3
                if #enemies.yards5 < 3 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.spec.debuffs.markOfTheCrane,"player")
                        if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                            if cast.risingSunKick(thisUnit) then return end
                        end
                    end
                end
            -- Fists of Fury
                -- fists_of_fury
                if markPercent < 75 or #enemies.yards5 < 3 then
                    if cast.fistsOfFury() then return end
                end
            -- Spinning Crane Kick
                -- spinning_crane_kick,if=active_enemies>=3&!prev_gcd.spinning_crane_kick
                if #enemies.yards5 >= 3 and markPercent >= 75 and lastSpell ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                end
            -- Rising Sun Kick
                -- rising_sun_kick,cycle_targets=1,if=active_enemies>=3
                if #enemies.yards5 >= 3 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.spec.debuffs.markOfTheCrane,"player")
                        if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                            if cast.risingSunKick(thisUnit) then return end
                        end
                    end
                end
            -- Blackout Kick
                -- blackout_kick,cycle_targets=1,if=!prev_gcd.blackout_kick
                if lastSpell ~= spell.blackoutKick then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.spec.debuffs.markOfTheCrane,"player")
                        if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                            if cast.blackoutKick(thisUnit) then return end
                        end
                    end
                end
            -- Spinning Crane Kick
                -- spinning_crane_kick,if=!prev_gcd.spinning_crane_kick
                if #enemies.yards5 >= 3 and markPercent >= 75 and lastSpell ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                end
            -- Rushing Jade Wind
                -- rushing_jade_wind,if=!prev_gcd.rushing_jade_wind
                if lastSpell ~= spell.rushingJadeWind then
                    if cast.rushingJadeWind() then return end
                end
            end
        -- Action List - Pre-Combat
            function actionList_PreCombat()
                if not inCombat then
            -- Flask / Crystal
                    -- flask,type=flask_of_the_seventh_demon
                    if isChecked("Flask / Crystal") then
                        if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                            useItem(bb.player.flask.wod.agilityBig)
                            return true
                        end
                        if flaskBuff==0 then
                            if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                                useItem(118922)
                                return true
                            end
                        end
                    end
            -- Food 
                    -- food,type=salty_squid_roll
            -- Snapshot Stats
                    -- snapshot_stats
                    if baseAgility == 0 then
                        baseAgility = UnitStat("player", 2)
                    end
                    if baseMultistrike == 0 then
                        -- baseMultistrike = GetMultistrike()
                    end
            -- Start Attack
                    -- auto_attack
                    if isValidUnit("target") and getDistance("target") < 5 then
                        StartAttack()
                    end
                end -- End No Combat Check
            end --End Action List - Pre-Combat

    ---------------------
    --- Begin Profile ---
    ---------------------
        -- Profile Stop | Pause
            if not inCombat and not hastar and profileStop==true then
                profileStop = false
            elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
                return true
            else
    ---------------------
    --- Queued Soells ---
    ---------------------
                if isChecked("Queue Casting") and #queue > 0 then
                    if castSpell(queue[1].target,queue[1].id,false,false,false) then return end
                end
    -----------------------
    --- Extras Rotation ---
    -----------------------
                if actionList_Extras() then return end
    --------------------------
    --- Defensive Rotation ---
    --------------------------
                if actionList_Defensive() then return end
    ------------------------------
    --- Pre-Combat Rotation ---
    ------------------------------
                if actionList_PreCombat() then return end
    -----------------------
    --- Opener Rotation ---
    -----------------------
                if opener == false and isChecked("Opener") and isBoss("target") then
                    if actionList_Opener() then return end
                end
    --------------------------
    --- In Combat Rotation ---
    --------------------------
            -- FIGHT!
                if inCombat and profileStop==false and isValidUnit(units.dyn5) and (opener == true or not isChecked("Opener") or not isBoss("target")) then 
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
                    if getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
        ---------------------------------
        --- APL Mode: SimulationCraft ---
        ---------------------------------
                    if getOptionValue("APL Mode") == 1 then
            -- Potion
                        -- potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                        -- TODO: Agility Proc
                        if canUse(127844) and inRaid and isChecked("Potion") then
                            if buff.serenity or buff.stormEarthAndFire or hasBloodLust() or ttd <= 60 then
                                useItem(127844)
                            end
                        end
            -- Call Action List - Serenity
                        -- call_action_list,name=serenity,if=talent.serenity.enabled&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=14&cooldown.rising_sun_kick.remains<=4)|buff.serenity.up)
                        if talent.serenity and ((useCDs() and artifact.strikeOfTheWindlord and cd.strikeOfTheWindlord <= 14 and cd.risingSunKick <= 4 and cd.touchOfDeath > 40) or buff.serenity) then
                            if actionList_Serenity() then return end
                        end
            -- Call Action List - Storm, Earth, and Fire
                        -- call_action_list,name=sef,if=!talent.serenity.enabled&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=14&cooldown.fists_of_fury.remains<=6&cooldown.rising_sun_kick.remains<=6)|buff.storm_earth_and_fire.up)
                        if not talent.serenity and ((artifact.strikeOfTheWindlord and cd.strikeOfTheWindlord <= 14 and cd.fistsOfFury <= 6 and cd.risingSunKick <= 6 and cd.touchOfDeath > 40) or buff.stormEarthAndFire) then
                            if actionList_SEF() then return end
                        end
            -- Call Action List - Serenity
                        -- call_action_list,name=serenity,if=(!artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<14&cooldown.fists_of_fury.remains<=15&cooldown.rising_sun_kick.remains<7)|buff.serenity.up
                        if (useCDs() and not artifact.strikeOfTheWindlord and cd.fistsOfFury <= 15 and cd.risingSunKick < 7 and cd.touchOfDeath > 40) or buff.serenity then
                            if actionList_Serenity() then return end
                        end
            -- Call Action Lsit - Storm, Earth, and Fire
                        -- call_action_list,name=sef,if=!talent.serenity.enabled&((!artifact.strike_of_the_windlord.enabled&cooldown.fists_of_fury.remains<=9&cooldown.rising_sun_kick.remains<=5)|buff.storm_earth_and_fire.up)
                        if not talent.serenity and ((not artifact.strikeOfTheWindlord and cd.fistsOfFury <= 9 and cd.risingSunKick <= 5 and cd.touchOfDeath > 40) or buff.stormEarthAndFire) then
                            if actionList_SEF() then return end
                        end             
            -- Call Action List - Single Target
                        -- call_action_list,name=st
                        if actionList_SingleTarget() then return end
            -- No Chi
                        if lastSpell == spell.tigerPalm then
                            if chi.count == 1 then
                                if cast.blackoutKick() then return end
                            end
                            if chi.count == 0 then
                                if cast.tigerPalm() then return end
                            end
                        end
                    end -- End Simulation Craft APL
        ----------------------------
        --- APL Mode: AskMrRobot ---
        ----------------------------
                    if getOptionValue("APL Mode") == 2 then
                        if useCDs() then
            -- Touch of Death
                            if not debuff.touchOfDeath then
                                if cast.touchOfDeath() then return end
                            end
            -- Trinkets
                            if isChecked("Trinkets") and getDistance(units.dyn5) < 5 then
                                if canUse(13) then
                                    useItem(13)
                                end
                                if canUse(14) then
                                    useItem(14)
                                end
                            end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                            if (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "BloodElf") then
                                if castSpell("player",racial,false,false,false) then return end
                            end
            -- Legendary Ring
                            if isChecked("Legendary Ring") then
                                if hasEquiped(124636) and canUse(124636) then
                                    useItem(124636)
                                    return true
                                end
                            end
            -- Potion
                            if canUse(109217) and inRaid and isChecked("Potion") then
                                if hasBloodLust() or ttd <= 60 then
                                    useItem(109217)
                                end
                            end
            --  Invoke Xuen
                            if isChecked("Xuen") then
                                if cast.invokeXuen() then return end
                            end
            -- Serenity
                            -- if CooldownSecRemaining(FistsOfFury) < 6 and CooldownSecRemaining(StrikeOfTheWindlord) < 5 and CooldownSecRemaining(WhirlingDragonPunch) < 5
                            if isChecked("Serenity") then
                                if cd.fistsOfFury < 6 and cd.strikeOfTheWindlord < 5 and cd.whirlingDragonPunch < 5 and cd.touchOfDeath > 45 then
                                    if cast.serenity() then return end
                                end
                            end
            -- Energizing Elixir
                            -- if AlternatePower = 0 and Power < MaxPower and not HasBuff(Serenity)
                            if chi.count == 0 and power < powerMax and not buff.serenity then
                                if cast.energizingElixir() then return end
                            end
            -- Storm, Earth, and Fire
                            -- if not HasBuff(StormEarthAndFire) and CooldownSecRemaining(FistsOfFury) < 11 and CooldownSecRemaining(WhirlingDragonPunch) < 14 and CooldownSecRemaining(StrikeOfTheWindlord) < 14
                            if useSEF() then
                                if not buff.stormEarthAndFire and cd.fistsOfFury < 11 and cd.whirlingDragonPunch < 14 and cd.strikeOfTheWindlord < 14 then
                                    if cast.stormEarthAndFire() then return end
                                end
                            end
                        end -- End Cooldown Check
                        if useAoE() then
            -- Storm, Earth, and Fire
                            -- if not HasBuff(StormEarthAndFire) and CooldownSecRemaining(FistsOfFury) < 11 and CooldownSecRemaining(WhirlingDragonPunch) < 14 and CooldownSecRemaining(StrikeOfTheWindlord) < 14
                            if useSEF() then
                                if not buff.stormEarthAndFire and cd.fistsOfFury < 11 and cd.whirlingDragonPunch < 14 and cd.strikeOfTheWindlord < 14 then
                                    if cast.stormEarthAndFire() then return end
                                end
                            end
            -- Spinning Crane Kick
                            if cast.spinningCraneKick() then return end
                        end
            -- Fists of Fury
                        if cast.fistsOfFury() then return end
            -- Whirling Dragon Punch
                        if cast.whirlingDragonPunch() then return end
            -- Strike of the Windlord
                        if ((talent.serenity and cd.serenity > 20) or not isChecked("Serenity") or not useCDs()) or not talent.serenity then
                            if cast.strikeOfTheWindlord() then return end
                        end
            -- Tiger Palm
                        -- if not WasLastCast(TigerPalm) and AlternatePower < 4 and Power > (MaxPower*0.9)
                        if lastSpell ~= spell.tigerPalm and chi.count < 4 and power > (powerMax * 0.9) then
                            if cast.tigerPalm() then return end
                        end
            -- Rising Sun Kick
                        if cast.risingSunKick() then return end
            -- Rushing Jade Wind
                        -- if AlternatePower > 1 or HasBuff(Serenity)
                        if chi.count > 1 or buff.serenity then
                            if cast.rushingJadeWind() then return end
                        end
            -- Chi Burst
                        if cast.chiBurst() then return end
            -- Chi Wave
                        if cast.chiWave() then return end
            -- Blackout Kick
                        -- if not WasLastCast(BlackoutKick) and (HasBuff(ComboBreaker) or AlternatePower > 1 or HasBuff(Serenity))
                        if lastSpell ~= spell.blackoutKick and (buff.comboBreaker or chi.count > 1 or buff.serenity) then
                            if cast.blackoutKick() then return end
                        end
            -- Tiger Palm
                        -- if not WasLastCast(TigerPalm) or AlternatePower < 2
                        if lastSpell ~= spell.tigerPalm or chi.count < 2 then
                            if cast.tigerPalm() then return end
                        end
                    end -- End AskMrRobot APL  
                end -- End Combat Check
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

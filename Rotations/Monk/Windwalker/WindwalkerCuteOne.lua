local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.spinningCraneKick },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.spinningCraneKick },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.tigerPalm },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.effuse}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.invokeXuenTheWhiteTiger },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.invokeXuenTheWhiteTiger },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.invokeXuenTheWhiteTiger }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
    };
    CreateButton("Interrupt",4,0)
-- Storm, Earth, and Fire Button
    SEFModes = {
        [1] = { mode = "On", value = 2 , overlay = "Auto SEF Enabled", tip = "Will cast Storm, Earth, and Fire.", highlight = 1, icon = br.player.spell.stormEarthAndFire},
        [2] = { mode = "Off", value = 1 , overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFireFixate}
    };
    CreateButton("SEF",5,0)
-- Flying Serpent Kick Button
    FSKModes = {
        [1] = { mode = "On", value = 2 , overlay = "Auto FSK Enabled", tip = "Will cast Flying Serpent Kick.", highlight = 1, icon = br.player.spell.flyingSerpentKick},
        [2] = { mode = "Off", value = 1 , overlay = "Auto FSK Disabled", tip = "Will NOT cast Flying Serpent Kick.", highlight = 0, icon = br.player.spell.flyingSerpentKickEnd}
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
        section = br.ui:createSection(br.ui.window.profile,  "General")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Opener
            br.ui:createCheckbox(section, "Opener")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Roll
            br.ui:createCheckbox(section, "Roll")
        -- Resuscitate
            br.ui:createDropdown(section, "Resuscitate", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")         
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        -- Flask / Crystal
            br.ui:createCheckbox(section,"Flask / Crystal")
        -- Potion
            br.ui:createCheckbox(section,"Potion")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
        -- Serenity
            br.ui:createCheckbox(section,"Serenity")
        -- Touch of Death
            br.ui:createCheckbox(section,"Touch of Death")
        -- Xuen
            br.ui:createCheckbox(section,"Xuen")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
         section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Effuse
            br.ui:createSpinner(section, "Effuse",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Detox
            br.ui:createCheckbox(section,"Detox")
        -- Healing Elixir
            br.ui:createSpinner(section, "Healing Elixir", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Touch of Karma
            br.ui:createSpinner(section, "Touch of Karma",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Diffuse Magic/Dampen Harm
            br.ui:createSpinner(section, "Diffuse/Dampen",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        --Quaking Palm
            br.ui:createCheckbox(section, "Quaking Palm")
        -- Spear Hand Strike
            br.ui:createCheckbox(section, "Spear Hand Strike")
        -- Paralysis
            br.ui:createCheckbox(section, "Paralysis")
        -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
        --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
        --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- SEF Toggle
            br.ui:createDropdown(section,  "SEF Mode", br.dropOptions.Toggle,  5)
        -- FSK Toggle
            br.ui:createDropdown(section,  "FSK Mode", br.dropOptions.Toggle,  5)
        -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
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
    if br.timer:useTimer("debugWindwalker", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("SEF",0.25)
        br.player.mode.sef = br.data.settings[br.selectedSpec].toggles["SEF"]
        UpdateToggle("FSK",0.25)
        br.player.mode.fsk = br.data.settings[br.selectedSpec].toggles["FSK"]
        BurstToggle("burstKey", 0.25)
        
--------------
--- Locals ---
--------------
        local agility           = UnitStat("player", 2)
        local artifact          = br.player.artifact
        local baseAgility       = 0
        local baseMultistrike   = 0
        local buff              = br.player.buff
        local canFlask          = canUse(br.player.flask.wod.agilityBig)
        local cast              = br.player.cast
        local castable          = br.player.cast.debug
        local castTimeFoF       = 4-(4*UnitSpellHaste("player")/100)
        local castTimeHS        = 2-(2*UnitSpellHaste("player")/100)
        local cd                = br.player.cd
        local charges           = br.player.charges
        local chi               = br.player.power.amount.chi
        local chiMax            = br.player.power.chi.max
        local combatTime        = getCombatTime()
        local debuff            = br.player.debuff
        local enemies           = br.player.enemies
        local flaskBuff         = getBuffRemain("player",br.player.flask.wod.buff.agilityBig) or 0
        local gcd               = br.player.gcd
        local glyph             = br.player.glyph
        local healthPot         = getHealthPot() or 0
        local inCombat          = br.player.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local lastSpell         = lastSpellCast
        local level             = br.player.level
        local mode              = br.player.mode
        local php               = br.player.health
        local power             = br.player.power.amount.energy
        local powerMax          = br.player.power.energy.max
        local pullTimer         = br.DBM:getPulltimer()
        local queue             = br.player.queue
        local race              = br.player.race
        local racial            = br.player.getRacial()
        local recharge          = br.player.recharge
        local regen             = br.player.power.regen
        local solo              = select(2,IsInInstance())=="none"
        local spell             = br.player.spell
        local t17_2pc           = br.player.eq.t17_2pc
        local t18_2pc           = br.player.eq.t18_2pc 
        local t18_4pc           = br.player.eq.t18_4pc
        local talent            = br.player.talent
        local thp               = getHP(br.player.units.dyn5)
        local trinketProc       = false --br.player.hasTrinketProc()
        local ttd               = getTTD(br.player.units.dyn5)
        local ttm               = br.player.power.ttm
        local units             = br.player.units
        if lastSpell == nil then lastSpell = 0 end
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end


        if not inCombat and not ObjectExists("target") then 
            OoRchiWave = false
            FSK = false
            iRchiWave = false
            EE = false
            ToD = false
            TP1 = false
            SER = false
            TP2 = false
            TP3 = false
            TP4 = false
            RSK1 = false
            RSK2 = false
            SotW = false
            FoF1 = false
            SCK = false
            BOK = false
            SEF = false
            WDP = false 
            opener = false
        end
        
        -- Mark of the Crane Count
        markOfTheCraneCount = 0
        for i=1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player") or 0
            if markOfTheCraneRemain > 0 then
                markOfTheCraneCount = markOfTheCraneCount + 1
            end
        end
        if #enemies.yards5 > 0 then
            markPercent = (markOfTheCraneCount/#enemies.yards5)*100
        else
            markPercent = 0
        end

        if not canToD then canToD = false end
        if ToDTime == nil then ToDTimer = GetTime() end
        if hasEquiped(137057) then
            if lastSpell == spell.touchOfDeath and not canToD then
                ToDTimer = GetTime() + 3;
                canToD = true
            end
            if canToD and GetTime() > ToDTimer then
                canToD = false
            end
        end
        -- ChatOverlay("Mark Count: "..markOfTheCraneCount..", Num Enemies: "..#enemies.yards5..", Mark %: "..markPercent)
        -- ChatOverlay("Mark of the Crane Remain: "..getDebuffRemain("target",spell.debuffs.markOfTheCrane,"player"))

        -- if buff.hitCombo.stack == 8 then maxCombo = true else maxCombo = false end
        -- if inCombat and maxCombo then 
        --     maxComboReached = true 
        -- elseif not inCombat or (maxComboReached and not maxCombo) then
        --     maxComboReached = false
        -- end
        -- if inCombat and maxComboReached and not maxCombo then
        --     Print(select(1,GetSpellInfo(lastSpell)).." Reset Hit Combo!")
        --     maxComboReached = false
        -- end
        -- if inCombat and lastSpell ~= prevSpell then
        --     Print(select(1,GetSpellInfo(lastSpell)))
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
        -- Resuscitate
            if isChecked("Resuscitate") then
                if getOptionValue("Resuscitate") == 1 
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.resuscitate("target") then return end
                end
                if getOptionValue("Resuscitate") == 2 
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.resuscitate("mouseover") then return end
                end
            end
        -- Provoke
            if not inCombat and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green" 
                and cd.flyingSerpentKick > 1 and getDistance("target") > 10 and isValidUnit("target") and not isBoss("target")
            then
                if solo or #br.friend == 1 then
                    if cast.provoke() then return end
                end
            end
        -- Flying Serpent Kick
            if mode.fsk == 1 then
                -- if cast.flyingSerpentKick() then return end 
                -- if cast.flyingSerpentKickEnd() then return end
            end
        -- Roll
            if isChecked("Roll") and getDistance("target") > 10 and isValidUnit("target") and getFacingDistance() < 5 and getFacing("player","target",10) then
                if cast.roll() then return end
            end
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if combatTime >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        CancelUnitBuff("player", GetSpellInfo(br.player.spell.stormEarthAndFire))
                        StopAttack()
                        ClearTarget()
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
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
            -- if isDummy("target") then
            --     if cast.stormEarthAndFireFixate() then return end
            -- end
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
        -- Dampen Harm
                if isChecked("Diffuse/Dampen") and php <= getValue("Dampen Harm") and inCombat then
                    if cast.dampenHarm() then return end
                end
        -- Diffuse Magic
                if isChecked("Diffuse/Dampen") and ((php <= getValue("Diffuse Magic") and inCombat) or canDispel("player",br.player.spell.diffuseMagic)) then
                    if cast.diffuseMagic() then return end
                end
        -- Detox
                if isChecked("Detox") then
                    if canDispel("player",spell.detox) then
                        if cast.detox("player") then return end
                    end
                    if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                        if canDispel("mouseover",spell.detox) then
                            if cast.detox("mouseover") then return end
                        end
                    end
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
            if useCDs() and getDistance(units.dyn5) < 5 then
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
                    if cast.invokeXuenTheWhiteTiger() then return end
                end
        -- Racial - Blood Fury / Berserking
                -- blood_fury
                -- berserking
                if isChecked("Racial") and (race == "Orc" or race == "Troll") and getSpellCD(racial) == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Touch of Death
                if isChecked("Touch of Death") then
                -- touch_of_death,cycle_targets=1,max_cycle_targets=2,if=!artifact.gale_burst.enabled&equipped.hidden_masters_forbidden_touch&(prev_gcd.2.touch_of_death|prev_gcd.3.touch_of_death|prev_gcd.4.touch_of_death)
                    if not artifact.galeBurst and hasEquiped(137057) and canToD then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if cast.touchOfDeath(thisUnit) then canToD = false; return end
                        end
                    end
                -- touch_of_death,if=!artifact.gale_burst.enabled&!equipped.hidden_masters_forbidden_touch
                    if not artifact.galeBurst and not hasEquiped(137057) then
                        if cast.touchOfDeath() then return end
                    end
                -- touch_of_death,cycle_targets=1,max_cycle_targets=2,if=artifact.gale_burst.enabled&equipped.hidden_masters_forbidden_touch&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7&(prev_gcd.2.touch_of_death|prev_gcd.3.touch_of_death|prev_gcd.4.touch_of_death)
                    if artifact.galeBurst and hasEquiped(137057) and cd.strikeOfTheWindlord < 8 and cd.fistsOfFury.remain <= 4 and cd.risingSunKick < 7 and canToD then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if cast.touchOfDeath(thisUnit) then canToD = false; return end
                        end
                    end
                -- touch_of_death,if=artifact.gale_burst.enabled&!talent.serenity.enabled&!equipped.hidden_masters_forbidden_touch&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7&chi>=2
                    if artifact.galeBurst and not talent.serenity and not hasEquiped(137057) and cd.strikeOfTheWindlord < 8 and cd.fistsOfFury <= 4 and cd.risingSunKick < 7 and chi >= 2 then
                        if cast.touchOfDeath() then return end
                    end
                -- touch_of_death,if=artifact.gale_burst.enabled&talent.serenity.enabled&!equipped.hidden_masters_forbidden_touch&cooldown.strike_of_the_windlord.remains<8&cooldown.fists_of_fury.remains<=4&cooldown.rising_sun_kick.remains<7
                    if artifact.galeBurst and not talent.serenity and not hasEquiped(137057) and cd.strikeOfTheWindlord < 8 and cd.fistsOfFury <= 4 and cd.risingSunKick < 7 then
                        if cast.touchOfDeath() then return end
                    end
                end
            end
        end -- End Cooldown - Action List
    -- Action List - Opener
        function actionList_Opener()
            if isBoss("target") and isValidUnit("target") and opener == false then
                if talent.whirlingDragonPunch and talent.energizingElixir then
                    -- TP -> TOD -> SEF+RSK -> EE+FoF -> SotW -> TP -> WDP with RSK coming off CD soon
                    if (isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") and not inCombat) or not isChecked("Pre-Pull Timer") then
        -- Chi Wave (Out of Range)
                        if not OoRchiWave then
                            if getDistance("target") >= 25 then
                                castOpener("chiWave","OoRchiWave",1)
                            else
                                Print("1: Chi Wave (Uncastable)");
                                OoRchiWave = true
                            end
        -- Flying Serpent Kick (No Hit)
                        elseif getDistance("target") < 15 and select(3,GetSpellInfo(101545)) == 463281 then                                   
                            if cast.flyingSerpentKickEnd() then return end
                        elseif OoRchiWave and not FSK then
                            if getDistance("target") >= 15 and mode.fsk == 1 then
                                castOpener("flyingSerpentKick","FSK",2)
                            else
                                Print("2: Flying Serpent Kick (Uncastable)");
                                FSK = true
                            end
        -- Potion
                        -- potion,name=old_war
                        elseif useCDs() and canUse(127844) and isChecked("Potion") and getDistance("target") < 15 then
                            Print("Potion Used!");
                            useItem(127844)
                        end
                    end
        -- Chi Wave (In Range)
                    if FSK and not iRchiWave then
                        if getDistance("target") < 25 then
                            castOpener("chiWave","iRchiWave",3)
                        else
                            Print("3: Chi Wave (Uncastable)");
                            iRchiWave = true
                        end
                    elseif getDistance("target") < 5 then
        -- Tiger Palm
                        if iRchiWave and not TP1 then
                            castOpener("tigerPalm","TP1",4)
        -- Touch of Death
                        elseif TP1 and not ToD then
                            if not debuff.touchOfDeath["target"].exists then
                                castOpener("touchOfDeath","ToD",5)
                            else
                                Print("5: Touch of Death (Uncastable)");
                                ToD = true
                            end
        -- Storm, Earth, and Fire
                        elseif ToD and not SEF then
                            if mode.sef == 1 then
                                castOpener("stormEarthAndFire","SEF",6)
                            else
                                Print("6: Storm, Earth, and Fire (Uncastable)");
                                SEF = true
                            end
        -- Rising Sun Kick
                        elseif SEF and not RSK1 then
                            castOpener("risingSunKick","RSK1",7)
        -- Energizing Elixir
                        elseif RSK1 and not EE then
                            castOpener("energizingElixir","EE",8)
        -- Fists of Fury
                        elseif EE and not FoF1 then
                            castOpener("fistsOfFury","FoF1",9)
        -- Strike of the Windlord
                        elseif FoF1 and not SotW then
                            castOpener("strikeOfTheWindlord","SotW",10)
        -- Tiger Palm
                        elseif SotW and not TP2 then
                            castOpener("tigerPalm","TP2",11)
        -- Whirling Dragon Punch
                        elseif TP2 and not WDP then
                            castOpener("whirlingDragonPunch","WDP",12)
        -- Rising Sun Kick
                        elseif WDP and not RSK2 then
                            castOpener("risingSunKick","RSK2",13)
                        elseif RSK2 then
                            Print("Opener Complete")
                            opener = true
                        end
                    end
                end -- End Whirling Dragon Punch + Energizing Elixir
                if talent.whirlingDragonPunch and talent.powerStrikes then
                    -- TP -> ToD -> TP + SEF -> FoF -> SotWL -> TP -> RSK -> WDP -> TP
                    if (isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") and not inCombat) or not isChecked("Pre-Pull Timer") or inCombat then
        -- Chi Wave (Out of Range)
                        if not OoRchiWave then
                            if getDistance("target") >= 25 then
                                castOpener("chiWave","OoRchiWave",1)
                            else
                                Print("1: Chi Wave (Uncastable)");
                                OoRchiWave = true
                            end
        -- Flying Serpent Kick (No Hit)
                        elseif getDistance("target") < 15 and select(3,GetSpellInfo(101545)) == 463281 then                                   
                            if cast.flyingSerpentKickEnd() then return end
                        elseif OoRchiWave and not FSK then
                            if getDistance("target") >= 15 and mode.fsk == 1 then
                                castOpener("flyingSerpentKick","FSK",2)
                            else
                                Print("2: Flying Serpent Kick (Uncastable)");
                                FSK = true
                            end
        -- Potion
                        -- potion,name=old_war
                        elseif useCDs() and canUse(127844) and isChecked("Potion") and getDistance("target") < 15 then
                            Print("Potion Used!");
                            useItem(127844)
                        end
                    end
        -- Chi Wave (In Range)
                    if FSK and not iRchiWave then
                        if getDistance("target") < 25 then
                            castOpener("chiWave","iRchiWave",3)
                        else
                            Print("3: Chi Wave (Uncastable)");
                            iRchiWave = true
                        end
                    elseif getDistance("target") < 5 then
        -- Tiger Palm
                        if iRchiWave and not TP1 then
                            castOpener("tigerPalm","TP1",4)
        -- Touch of Death
                        elseif TP1 and not ToD then
                            if not debuff.touchOfDeath["target"].exists then
                                castOpener("touchOfDeath","ToD",5)
                            else
                                Print("5: Touch of Death (Uncastable)");
                                ToD = true
                            end
        -- Tiger Palm
                        elseif ToD and not TP2 then
                            castOpener("tigerPalm","TP2",6)
        -- Storm, Earth, and Fire
                        elseif TP2 and not SEF then
                            if mode.sef == 1 then
                                castOpener("stormEarthAndFire","SEF",7)
                            else
                                Print("7: Storm, Earth, and Fire (Uncastable)");
                                SEF = true
                            end
        -- Fists of Fury
                        elseif SEF and not FoF1 then
                            castOpener("fistsOfFury","FoF1",8)
        -- Strike of the Windlord
                        elseif FoF1 and not SotW then
                            castOpener("strikeOfTheWindlord","SotW",9)
        -- Tiger Palm
                        elseif SotW and not TP3 then
                            castOpener("tigerPalm","TP3",10)
        -- Rising Sun Kick
                        elseif TP3 and not RSK1 then
                            castOpener("risingSunKick","RSK1",11)
        -- Whirling Dragon Punch
                        elseif RSK1 and not WDP then
                            castOpener("whirlingDragonPunch","WDP",12)
        -- Tiger Palm
                        elseif WDP and not TP4 then
                            castOpener("tigerPalm","TP4",13)
                        elseif TP4 then
                            Print("Opener Complete")
                            opener = true
                        end
                    end                
                end -- End Whirling Dragon Punch + Power Strikes
                if talent.serenity then
                    -- TP -> ToD -> Serenity + RSK -> SotWL ->  FoF -> RSK -> SCK -> BoK (If it will fit in Serenity)
                    if (isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") and not inCombat) or not isChecked("Pre-Pull Timer") or inCombat then
        -- Chi Wave (Out of Range)
                        if not OoRchiWave then
                            if getDistance("target") >= 25 then
                                castOpener("chiWave","OoRchiWave",1)
                            else
                                Print("1: Chi Wave (Uncastable)");
                                OoRchiWave = true
                            end
        -- Flying Serpent Kick (No Hit)
                        elseif getDistance("target") < 15 and select(3,GetSpellInfo(101545)) == 463281 then                                   
                            if cast.flyingSerpentKickEnd() then return end
                        elseif OoRchiWave and not FSK then
                            if getDistance("target") >= 15 and mode.fsk == 1 then
                                castOpener("flyingSerpentKick","FSK",2)
                            else
                                Print("2: Flying Serpent Kick (Uncastable)");
                                FSK = true
                            end
        -- Potion
                        -- potion,name=old_war
                        elseif useCDs() and canUse(127844) and isChecked("Potion") and getDistance("target") < 15 then
                            Print("Potion Used!");
                            useItem(127844)
                        end
                    end
        -- Chi Wave (In Range)
                    if FSK and not iRchiWave then
                        if getDistance("target") < 25 then
                            castOpener("chiWave","iRchiWave",3)
                        else
                            Print("3: Chi Wave (Uncastable)");
                            iRchiWave = true
                        end
                    elseif getDistance("target") < 5 then
        -- Tiger Palm
                        if iRchiWave and not TP1 then
                            castOpener("tigerPalm","TP1",4)
        -- Touch of Death
                        elseif TP1 and not ToD then
                            if not debuff.touchOfDeath["target"].exists then
                                castOpener("touchOfDeath","ToD",5)
                            else
                                Print("5: Touch of Death (Uncastable)");
                                ToD = true
                            end
        -- Serenity
                        elseif ToD and not SER then
                            castOpener("serenity","SER",6)
        -- Rising Sun Kick
                        elseif SER and not RSK1 then
                            if buff.serenity.exists then
                                castOpener("risingSunKick","RSK1",7)
                            else
                                Print("7: Rising Sun Kick (Uncastable)"); 
                                RSK1 = true
                            end
        -- Strike of the Windlord
                        elseif RSK1 and not SotW then
                            if buff.serenity.exists then
                                castOpener("strikeOfTheWindlord","SotW",8)
                            else
                                Print("8: Strike of the Windlord (Uncastable)"); 
                                SotW = true
                            end
        -- Fists of Fury
                        elseif SotW and not FoF1 then
                            if buff.serenity.exists then
                                castOpener("fistsOfFury","FoF1",9)
                            else
                                Print("9: Fists of Fury (Uncastable)"); 
                                FoF1 = true
                            end
        -- Rising Sun Kick
                        elseif FoF1 and not RSK2 then
                            if buff.serenity.exists then
                                castOpener("risingSunKick","RSK2",10)
                            else
                                Print("10: Rising Sun Kick (Uncastable)"); 
                                RSK2 = true
                            end
        -- Spinning Crane Kick
                        elseif RSK2 and not SCK then
                            if buff.serenity.exists then
                               castOpener("spinningCraneKick","SCK",10)
                            else
                                Print("11: Spinning Crane Kick (Uncastable)"); 
                                SCK = true
                            end
        -- Blackout Kick
                        elseif SCK and not BOK then
                            if buff.serenity.exists then
                               castOpener("blackoutKick","BOK",10)
                            else
                                Print("12: Blackout Kick (Uncastable)"); 
                                BOK = true
                            end
                        elseif BOK then
                            Print("Opener Complete");
                            opener = true;
                            return
                        end
                    end
                end -- End Serenity - Gale Burst
                if not (talent.serenity or (talent.whirlingDragonPunch and (talent.energizingElixir or talent.powerStrikes))) then
                    opener = true;
                    return
                end
            end -- End Boss and Opener Check
        end -- End Action List - Opener
    -- Action List - Single Target
        function actionList_SingleTarget()
        -- Action List - Cooldown
            -- call_action_list,name=cd
            if actionList_Cooldown() then return end
        -- Energizing Elixir
            -- energizing_elixir,if=energy<energy.max&chi<=1
            if power < powerMax and chi <= 1 and getDistance("target") < 5 then
                if cast.energizingElixir() then return end
            end
        -- Racial - Arcane Torrent
            -- arcane_torrent,if=chiMax-chi>=1&energy.time_to_max>=0.5
            if chiMax >= chi and ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" and getSpellCD(racial) == 0 and getDistance("target") < 5 then
                if castSpell("player",racial,false,false,false) then return end
            end
        -- Strike of the Windlord
            -- strike_of_the_windlord,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=10
            -- strike_of_the_windlord,if=equipped.convergence_of_fates&!talent.serenity.enabled
            -- strike_of_the_windlord,if=!equipped.convergence_of_fates
            if ((talent.serenity and cd.serenity >= 10) or not isChecked("Serenity") or not useCDs()) or (not talent.serenity and #enemies.yards5 < 6) then
                if not hasEquiped(140806) or (hasEquiped(140806) and (not talent.serenity or (talent.serenity and cd.serenity >= 10))) then
                    if cast.strikeOfTheWindlord() then return end
                end
            end
        -- Fists of Fury
            -- fists_of_fury,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=5
            -- fists_of_fury,if=equipped.convergence_of_fates&!talent.serenity.enabled
            -- fists_of_fury,if=!equipped.convergence_of_fates
            if markPercent < 75 or #enemies.yards5 < 3 then
                if not hasEquiped(140806) or (hasEquiped(140806) and (not talent.serenity or (talent.serenity and cd.serenity >= 5))) then
                    if cast.fistsOfFury() then return end
                end
            end
        -- Tiger Palm
            -- tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm&energy=energy.max&chi<=3&buff.storm_earth_and_fire.up
            if lastSpell ~= spell.tigerPalm and power == powerMax and chi <= 3 and buff.stormEarthAndFire.exists then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player")
                    if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                        if cast.tigerPalm(thisUnit) then return end
                    end
                end
            end
        -- Rising Sun Kick
            -- rising_sun_kick,cycle_targets=1,if=equipped.convergence_of_fates&talent.serenity.enabled&cooldown.serenity.remains>=2
            -- rising_sun_kick,cycle_targets=1,if=equipped.convergence_of_fates&!talent.serenity.enabled
            -- rising_sun_kick,cycle_targets=1,if=!equipped.convergence_of_fates
            if not hasEquiped(140806) or (hasEquiped(140806) and (not talent.serenity or (talent.serenity and cd.serenity >= 2))) then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player")
                    if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                        if cast.risingSunKick(thisUnit) then return end
                    end
                end
            end
        -- Whirling Dragon Punch
            -- whirling_dragon_punch
            if cast.whirlingDragonPunch() then return end
        -- Crackling Jade Lightning
            -- crackling_jade_lightning,if=equipped.the_emperors_capacitor&buff.the_emperors_capacitor.stack>=19
            if hasEquiped(144239) and buff.theEmperorsCapacitor.stack >= 19 then
                if cast.cracklingJadeLightning() then return end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick,if=active_enemies>=3&!prev_gcd.spinning_crane_kick
            if #enemies.yards5 >= 3 and markPercent >= 75 and (lastSpell ~= spell.spinningCraneKick or level < 78) then
                if cast.spinningCraneKick() then return end
            end
        -- Rushing Jade Wind
            -- rushing_jade_wind,if=chiMax-chi>1&!prev_gcd.rushing_jade_wind
            if chiMax - chi > 1 and (lastSpell ~= spell.rushingJadeWind or level < 78) then
                if cast.rushingJadeWind() then return end
            end
        -- Blackout Kick
            -- blackout_kick,cycle_targets=1,if=(chi>1|buff.bok_proc.up)&!prev_gcd.blackout_kick
            if (chi > 1 or buff.blackoutKick.exists) and (lastSpell ~= spell.blackoutKick or level < 78) then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player")
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
            if lastSpell ~= spell.tigerPalm or level < 78 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player")
                    if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                        if cast.tigerPalm(thisUnit) then return end
                    end
                end
            end
        end -- End Action List - Single Target 
    -- Action List - Storm, Earth, and Fire
        function actionList_StormEarthAndFire()
            if mode.sef == 1 then
        -- Tiger Palm
                -- tiger_palm,if=energy=energy.max&chi<1
                if power == powerMax and chi < 1 then
                    if cast.tigerPalm() then return end
                end
        -- Racial - Arcane Torrent
                -- arcane_torrent,if=chiMax-chi>=1&energy.time_to_max>=0.
                if chiMax >= chi and ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" and getSpellCD(racial) == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Call Action List - Cooldowns
                -- call_action_list,name=cd
                if actionList_Cooldown() then return end
                if getDistance("target") < 5 and not buff.stormEarthAndFire.exists then
        -- Storm, Earth, and Fire
                    -- storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&(cooldown.touch_of_death.remains<=8|cooldown.touch_of_death.remains>85)
                    -- storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&cooldown.storm_earth_and_fire.charges=2
                    -- storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&target.time_to_die<=25
                    -- storm_earth_and_fire,if=!buff.storm_earth_and_fire.up&cooldown.fists_of_fury.remains<=1&chi>=3
                    if cd.touchOfDeath <= 8 or cd.touchOfDeath > 85 or charges.stormEarthAndFire == 2 or ttd <= 25 or (cd.fistsOfFury <= 1 and chi >= 3) then
                        if cast.stormEarthAndFire() then return end
                    end
        -- Fists of Fury
                    -- fists_of_fury,if=buff.storm_earth_and_fire.up
                    if cast.fistsOfFury() then return end
        -- Rising Sun Kick
                    -- rising_sun_kick,if=buff.storm_earth_and_fire.up&chi=2&energy<energy.max
                    if chi == 2 and power < powerMax then
                        if cast.risingSunKick() then return end
                    end
                end
        -- Call Action List - Single Target
                -- call_action_list,name=st
                if actionList_SingleTarget() then return end
            end
        end -- End SEF - Action List
    -- Action List - Serenity
        function actionList_Serenity()
            if isChecked("Serenity") then
        -- Call Action List - Cooldowns
                -- call_action_list,name=cd
                if actionList_Cooldown() then return end
        -- Serenity
                -- serenity
                if getDistance("target") < 5 then
                    if cast.serenity() then return end
                end
                if buff.serenity.exists then
        -- Strike of the Windlord
                    -- strike_of_the_windlord
                    if cast.strikeOfTheWindlord() then return end
        -- Rising Sun Kick
                    -- rising_sun_kick,cycle_targets=1,if=active_enemies<3
                    if #enemies.yards5 < 3 then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player")
                            if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                                if cast.risingSunKick(thisUnit) then return end
                            end
                        end
                    end
        -- Fists of Fury
                    -- fists_of_fury
                    -- if markPercent < 75 or #enemies.yards5 < 3 then
                    if cast.fistsOfFury() then return end
                    -- end
        -- Spinning Crane Kick
                    -- spinning_crane_kick,if=active_enemies>=3&!prev_gcd.spinning_crane_kick
                    if #enemies.yards5 >= 3 --[[and markPercent >= 75 ]]and (lastSpell ~= spell.spinningCraneKick or level < 78) then
                        if cast.spinningCraneKick() then return end
                    end
        -- Rising Sun Kick
                    -- rising_sun_kick,cycle_targets=1,if=active_enemies>=3
                    if #enemies.yards5 >= 3 then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player")
                            if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                                if cast.risingSunKick(thisUnit) then return end
                            end
                        end
                    end
        -- Blackout Kick
                -- blackout_kick,cycle_targets=1,if=!prev_gcd.blackout_kick
                    if lastSpell ~= spell.blackoutKick or level < 78 then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            local markOfTheCraneRemain = getDebuffRemain(thisUnit,spell.debuffs.markOfTheCrane,"player")
                            if markOfTheCraneRemain < 5 or markOfTheCraneCount == #enemies.yards5 then
                                if cast.blackoutKick(thisUnit) then return end
                            end
                        end
                    end
        -- -- Spinning Crane Kick
        --         -- spinning_crane_kick,if=!prev_gcd.spinning_crane_kick
        --         if #enemies.yards5 >= 3 and markPercent >= 75 and (lastSpell ~= spell.spinningCraneKick or level < 78) then
        --             if cast.spinningCraneKick() then return end
        --         end
        -- Rushing Jade Wind
                    -- rushing_jade_wind,if=!prev_gcd.rushing_jade_wind
                    if lastSpell ~= spell.rushingJadeWind or level < 78 then
                        if cast.rushingJadeWind() then return end
                    end
                end
            end
        end
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
        -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if isChecked("Flask / Crystal") then
                    if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                        useItem(br.player.flask.wod.agilityBig)
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
        elseif (inCombat and profileStop==true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
            return true
        else
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
                if isChecked("Pre-Pull Timer") and inCombat then
                    opener = true;
                    return
                end
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
                    if canUse(127844) and inRaid and isChecked("Potion") and getDistance("target") < 5 then
                        if buff.serenity.exists or buff.stormEarthAndFire.exists or hasBloodLust() or ttd <= 60 then
                            useItem(127844)
                        end
                    end
        -- Touch of Death
                    -- touch_of_death,if=target.time_to_die<=9
                    if useCDs() and isChecked("Touch of Death") and ttd <= 9 then
                        if cast.touchOfDeath() then return end
                    end
        -- Call Action List - Serenity
                    -- call_action_list,name=serenity,if=(talent.serenity.enabled&cooldown.serenity.remains<=0)|buff.serenity.up
                    if useCDs() and isChecked("Serenity") and ((talent.serenity and cd.serenity <= 0) or buff.serenity.exists) then
                        if actionList_Serenity() then return end
                    end
        -- Call Action List - Storm, Earth, and Fire
                    -- call_action_list,name=sef,if=!talent.serenity.enabled&equipped.drinking_horn_cover&((cooldown.fists_of_fury.remains<=1&chi>=3)|buff.storm_earth_and_fire.up|cooldown.storm_earth_and_fire.charges=2|cooldowntarget.time_to_die<=25|cooldown.touch_of_death.remains>=85)
                    if mode.sef == 1 and not talent.serenity and hasEquiped(137097) and ((cd.fistsOfFury <= 1 and chi >= 3) or buff.stormEarthAndFire.exists or charges.stormEarthAndFire == 2 or ttd <= 25 or cd.touchOfDeath >= 85) then
                        if actionList_StormEarthAndFire() then return end
                    end
                    -- call_action_list,name=sef,if=!talent.serenity.enabled&!equipped.drinking_horn_cover&((artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.remains<=14&cooldown.fists_of_fury.remains<=6&cooldown.rising_sun_kick.remains<=6)|buff.storm_earth_and_fire.up)           
                    if mode.sef == 1 and not talent.serenity and not hasEquiped(137097) and ((artifact.strikeOfTheWindlord and cd.strikeOfTheWindlord <= 14 and cd.fistsOfFury <= 6 and cd.risingSunKick <= 6) or buff.stormEarthAndFire) then
                        if actionList_StormEarthAndFire() then return end
                    end
        -- Call Action List - Single Target
                    -- call_action_list,name=st
                    if actionList_SingleTarget() then return end
        -- -- No Chi
        --             if lastSpell == spell.tigerPalm then
        --                 if chi == 1 then
        --                     if cast.blackoutKick() then return end
        --                 end
        --                 if chi == 0 then
        --                     if cast.tigerPalm() then return end
        --                 end
        --             end
                end -- End Simulation Craft APL
    ----------------------------
    --- APL Mode: AskMrRobot ---
    ----------------------------
                if getOptionValue("APL Mode") == 2 then
                    if useCDs() then
        -- Touch of Death
                        if not debuff[units.dyn5].touchOfDeath.exists then
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
                        if (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") and getSpellCD(racial) == 0 then
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
                            if cast.invokeXuenTheWhiteTiger() then return end
                        end
        -- Serenity
                        -- if CooldownSecRemaining(FistsOfFury) < 6 and CooldownSecRemaining(StrikeOfTheWindlord) < 5 and CooldownSecRemaining(WhirlingDragonPunch) < 5
                        if isChecked("Serenity") then
                            if cd.fistsOfFury < 6 and cd.strikeOfTheWindlord < 5 and cd.whirlingDragonPunch < 5 then
                                if cast.serenity() then return end
                            end
                        end
        -- Energizing Elixir
                        -- if AlternatePower = 0 and Power < MaxPower and not HasBuff(Serenity)
                        if chi == 0 and power < powerMax and not buff.serenity.exists then
                            if cast.energizingElixir() then return end
                        end
        -- Storm, Earth, and Fire
                        -- if not HasBuff(StormEarthAndFire) and CooldownSecRemaining(FistsOfFury) < 11 and CooldownSecRemaining(WhirlingDragonPunch) < 14 and CooldownSecRemaining(StrikeOfTheWindlord) < 14
                        if mode.sef == 1 then
                            if not buff.stormEarthAndFire.exists and cd.fistsOfFury < 11 and cd.whirlingDragonPunch < 14 and cd.strikeOfTheWindlord < 14 and getDistance("target") < 5 then
                                if cast.stormEarthAndFire() then return end
                            end
                        end
                    end -- End Cooldown Check
                    if useAoE() then
        -- Storm, Earth, and Fire
                        -- if not HasBuff(StormEarthAndFire) and CooldownSecRemaining(FistsOfFury) < 11 and CooldownSecRemaining(WhirlingDragonPunch) < 14 and CooldownSecRemaining(StrikeOfTheWindlord) < 14
                        if mode.sef == 1 then
                            if not buff.stormEarthAndFire.exists and cd.fistsOfFury < 11 and cd.whirlingDragonPunch < 14 and cd.strikeOfTheWindlord < 14 and getDistance("target") < 5 then
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
                    if (lastSpell ~= spell.tigerPalm  or level < 78) and chi < 4 and power > (powerMax * 0.9) then
                        if cast.tigerPalm() then return end
                    end
        -- Rising Sun Kick
                    if cast.risingSunKick() then return end
        -- Rushing Jade Wind
                    -- if AlternatePower > 1 or HasBuff(Serenity)
                    if chi > 1 or buff.serenity.exists then
                        if cast.rushingJadeWind() then return end
                    end
        -- Chi Burst
                    if cast.chiBurst() then return end
        -- Chi Wave
                    if cast.chiWave() then return end
        -- Blackout Kick
                    -- if not WasLastCast(BlackoutKick) and (HasBuff(ComboBreaker) or AlternatePower > 1 or HasBuff(Serenity))
                    if (lastSpell ~= spell.blackoutKick or level < 78) and (buff.blackoutKick.exists or chi > 1 or buff.serenity.exists) then
                        if cast.blackoutKick() then return end
                    end
        -- Tiger Palm
                    -- if not WasLastCast(TigerPalm) or AlternatePower < 2
                    if lastSpell ~= spell.tigerPalm or chi < 2 or level < 78 then
                        if cast.tigerPalm() then return end
                    end
                end -- End AskMrRobot APL  
            end -- End Combat Check
        end -- End Pause
    end -- End Timer
end -- End runRotation
local id = 269
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
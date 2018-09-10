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
        [1] = { mode = "Boss", value = 1 , overlay = "Auto SEF on Boss Only", tip = "Will cast Storm, Earth and Fire on Bosses only.", highlight = 1, icon = br.player.spell.stormEarthAndFireFixate},
        [2] = { mode = "On", value = 2 , overlay = "Auto SEF Enabled", tip = "Will cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFire},
        [3] = { mode = "Off", value = 3 , overlay = "Auto SEF Disabled", tip = "Will NOT cast Storm, Earth, and Fire.", highlight = 0, icon = br.player.spell.stormEarthAndFireFixate}

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
        -- CJL OOR
            br.ui:createSpinner(section,"CJL OOR", 100,  5,  160,  5, "Cast CJL when 0 enemies in 8 yds when at X Energy")
        -- Cancel CJL OOR
            br.ui:createSpinner(section,"CJL OOR Cancel", 30,  5,  160,  5, "Cancel CJL OOR when under X Energy")
        -- Roll
            br.ui:createCheckbox(section, "Roll")
        -- Resuscitate
            br.ui:createDropdown(section, "Resuscitate", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        -- Tiger's Lust
            br.ui:createCheckbox(section, "Tiger's Lust")
        -- Whirling Dragon Punch
            br.ui:createCheckbox(section, "Whirling Dragon Punch")
        -- Provoke
            br.ui:createCheckbox(section, "Provoke", "Will aid in grabbing mobs when solo.")
        -- Spread Mark Cap
            br.ui:createSpinnerWithout(section, "Spread Mark Cap", 5, 0, 10, 1, "|cffFFFFFFSet to limit Mark of the Crane Buffs, 0 for unlimited. Min: 0 / Max: 10 / Interval: 1")
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
        -- Touch of the Void
            br.ui:createCheckbox(section,"Touch of the Void")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- Energizing Elixir
            br.ui:createDropdownWithout(section,"Energizing Elixir", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Energizing Elixir.")
        -- SEF Timer/Behavior
            br.ui:createSpinnerWithout(section, "SEF Timer",  0.3,  0,  1,  0.05,  "|cffFFFFFFDesired time in seconds to resume rotation after casting SEF so clones can get into place. This value changes based on different factors so requires some testing to find what works best for you.")
            br.ui:createDropdownWithout(section, "SEF Behavior", {"|cff00FF00Fixate","|cffFFFF00Go Ham!"}, 1, "|cffFFFFFFStorm, Earth, and Fire Behavior.")
        -- Serenity
            br.ui:createDropdownWithout(section,"Serenity", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Serenity.")
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
            br.ui:createSpinner(section, "Vivify",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Detox
            br.ui:createCheckbox(section,"Detox")
        -- Diffuse Magic/Dampen Harm
            br.ui:createSpinner(section, "Diffuse/Dampen",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Touch of Karma
            br.ui:createSpinner(section, "Touch of Karma",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
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
    --if br.timer:useTimer("debugWindwalker", math.random(0.15,0.3)) then
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
        local buff              = br.player.buff
        local cast              = br.player.cast
        local cd                = br.player.cd
        local charges           = br.player.charges
        local chi               = br.player.power.chi.amount()
        local chiDeficit        = br.player.power.chi.deficit()
        local chiMax            = br.player.power.chi.max()
        local combatTime        = getCombatTime()
        local debuff            = br.player.debuff
        local enemies           = br.player.enemies
        local energy            = br.player.power.energy.amount()
        local equiped           = br.player.equiped
        local gcd               = br.player.gcdMax
        local healthPot         = getHealthPot() or 0
        local inCombat          = br.player.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local mode              = br.player.mode
        local moving            = GetUnitSpeed("player")>0
        local php               = br.player.health
        local power             = br.player.power.energy.amount()
        local powerMax          = br.player.power.energy.max()
        local pullTimer         = br.DBM:getPulltimer()
        local race              = br.player.race
        local solo              = select(2,IsInInstance())=="none"
        local spell             = br.player.spell
        local talent            = br.player.talent
        local thp               = getHP("target")
        local traits            = br.player.traits
        local ttd               = getTTD("target")
        local ttm               = br.player.power.energy.ttm()
        local units             = br.player.units
        local use               = br.player.use

        units.get(5)
        enemies.get(5)
        enemies.get(8)
        enemies.yards12r = getEnemiesInRect(10,12,false) or 0

        if not inCombat or lastCombo == nil or not buff.hitCombo.exists() then lastCombo = 6603 end
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if SerenityTest == nil then SerenityTest = GetTime() end
        if SEFTimer == nil then SEFTimer = GetTime() end
        if FoFTimerOpener == nil then FoFTimerOpener = GetTime() end
        if castFSK == nil then castFSK = false end

        if isCastingSpell(spell.cracklingJadeLightning)
            and (getDistance(units.dyn5) <= 5 or (#enemies.yards8 == 0 and power <= getOptionValue("CJL OOR Cancel") and isChecked("CJL OOR Cancel")))
            and ((hasEquiped(144239) and buff.theEmperorsCapacitor.stack() < 19 and ttm > 3)
                or (hasEquiped(144239) and buff.theEmperorsCapacitor.stack() < 14 and cd.serenity.remain() < 13 and talent.serenity and ttm > 3)
                or not hasEquiped(144239))
        then
            SpellStopCasting()
        end

        local lowestMark = debuff.markOfTheCrane.lowest(5,"remain")

        -- Opener Reset
        if not inCombat and not GetObjectExists("target") then
            iRchiWave = false
            CWIR = false
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

        -- Touch of Deathable
        if not canToD then canToD = false end
        if ToDTime == nil then ToDTimer = GetTime() end
        if hasEquiped(137057) then
            if lastCombo == spell.touchOfDeath and not canToD then
                ToDTimer = GetTime() + 3;
                canToD = true
            end
            if canToD and GetTime() > ToDTimer then
                canToD = false
            end
        end

        -- Rushing Jade Wind - Cancel
        if not inCombat and buff.rushingJadeWind.exists() then
            if buff.rushingJadeWind.cancel() then return true end
        end

        -- ChatOverlay("SCK: "..round2(spinningCraneKickDmg(),0)..", FoF: "..round2(fistsOfFuryDmg(),0)..", > FoF: "..tostring(BetterThanFoF))
--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Stop Casting
            if isCastingSpell(spell.cracklingJadeLightning) then
                Print("channeling cjl")
            end
        -- Tiger's Lust
            if isChecked("Tiger's Lust") then
                if hasNoControl() or (inCombat and getDistance("target") > 10 and isValidUnit("target")) then
                    if cast.tigersLust() then return true end
                end
            end
        -- Resuscitate
            if isChecked("Resuscitate") then
                if getOptionValue("Resuscitate") == 1
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and UnitIsFriend("target","player")
                then
                    if cast.resuscitate("target") then return true end
                end
                if getOptionValue("Resuscitate") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("mouseover","player")
                then
                    if cast.resuscitate("mouseover") then return true end
                end
            end
        -- Provoke
            if isChecked("Provoke") and not inCombat and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green"
                and cd.flyingSerpentKick.remain() > 1 and getDistance("target") > 10 and isValidUnit("target") and not isBoss("target")
            then
                if solo or #br.friend == 1 then
                    if cast.provoke() then return true end
                end
            end
        -- Flying Serpent Kick
            if mode.fsk == 1 then
                -- if cast.flyingSerpentKick() then return true end
                if castFSK then
                    if cast.flyingSerpentKickEnd() then castFSK = false; return true end
                end
            end
        -- Roll
            if isChecked("Roll") and getDistance("target") > 10 and isValidUnit("target") and getFacingDistance() < 5 and getFacing("player","target",10) then
                if cast.roll() then return true end
            end
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
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
            if isChecked("CJL OOR") and (lastCombo ~= spell.cracklingJadeLightning or buff.hitCombo.stack() <= 1) and #enemies.yards8 == 0 and not isCastingSpell(spell.cracklingJadeLightning) and (hasThreat("target") or isDummy()) and not isMoving("player") and power >= getOptionValue("CJL OOR") then
                if cast.cracklingJadeLightning() then return true end
             end
        -- Touch of the Void
            if (useCDs() or useAoE()) and isChecked("Touch of the Void") and inCombat and #enemies.yards8 > 0 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
                    end
                end
            end
        -- Fixate - Storm, Earth, and Fire
            if getOptionValue("SEF Behavior") == 1 and not talent.serenity and not cast.current.fistsOfFury() then
                if cast.stormEarthAndFireFixate() then return true end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and inCombat then
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
                    if cast.dampenHarm() then return true end
                end
        -- Diffuse Magic
                if isChecked("Diffuse/Dampen") and ((php <= getValue("Diffuse Magic") and inCombat) or canDispel("player",br.player.spell.diffuseMagic)) then
                    if cast.diffuseMagic() then return true end
                end
        -- Detox
                if isChecked("Detox") then
                    if canDispel("player",spell.detox) then
                        if cast.detox("player") then return true end
                    end
                    if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                        if canDispel("mouseover",spell.detox) then
                            if cast.detox("mouseover") then return true end
                        end
                    end
                end
        -- Leg Sweep
                if isChecked("Leg Sweep - HP") and php <= getOptionValue("Leg Sweep - HP") and inCombat and #enemies.yards5 > 0 then
                    if cast.legSweep() then return true end
                end
                if isChecked("Leg Sweep - AoE") and #enemies.yards5 >= getOptionValue("Leg Sweep - AoE") then
                    if cast.legSweep() then return true end
                end
        -- Touch of Karma
                if isChecked("Touch of Karma") and php <= getOptionValue("Touch of Karma") and inCombat then
                    if cast.touchOfKarma() then return true end
                end
        -- Vivify
                if isChecked("Vivify") and php <= getOptionValue("Vivify") and not inCombat and cast.able.vivify() then
                    if cast.vivify() then return true end
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
        -- Spear Hand Strike
                        if isChecked("Spear Hand Strike") and cast.able.spearHandStrike(thisUnit) and  distance < 5 then
                            if cast.spearHandStrike(thisUnit) then return true end
                        end
        -- Leg Sweep
                        if isChecked("Leg Sweep") and cast.able.legSweep(thisUnit) and (distance < 5 or (talent.tigerTailSweep and distance < 7)) then
                            if cast.legSweep(thisUnit) then return true end
                        end
        -- Paralysis
                        if isChecked("Paralysis") and cast.able.paralysis(thisUnit) then
                            if cast.paralysis(thisUnit) then return true end
                        end
                    end
                end
            end -- End Interrupt Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        function actionList_Cooldowns()
            if useCDs() and getDistance(units.dyn5) < 5 then
        -- Trinkets
                if isChecked("Trinkets") then
                    if canUse(13) and not (hasEquiped(151190,13) or hasEquiped(147011,13)) then
                        useItem(13)
                    end
                    if canUse(14) and not (hasEquiped(151190,14) or hasEquiped(147011,14)) then
                        useItem(14)
                    end
                end
        -- Invoke Xuen
                -- invoke_xuen_the_white_tiger
                if isChecked("Xuen") and cast.able.invokeXuenTheWhiteTiger() then
                    if cast.invokeXuenTheWhiteTiger() then return true end
                end
        -- Racial - Blood Fury / Berserking / Arcane Torrent / Fireblood
                -- blood_fury
                -- berserking
                -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
                -- lightsJudgment
                -- fireblood
                -- ancestral_call
                if isChecked("Racial") and cast.able.racial() then
                    if (race == "BloodElf" and chiMax - chi >= 1 and ttm >= 0.5) or race == "Orc" or race == "Troll" or race == "LightforgedDraenei" or race == "DarkIronDwarf" or race == "MagharOrc" then
                        if race == "LightforgedDraenei" then
                            if cast.racial("target","ground") then return true end
                        else
                            if cast.racial("player") then return true end
                        end
                    end
                end
        -- Touch of Death
                -- touch_of_death,if=target.time_to_die>9
                if isChecked("Touch of Death") and cast.able.touchOfDeath() and ttd > 9 then
                    if cast.touchOfDeath() then return true end
                end
            end
        -- Storm, Earth, and Fire
            -- storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|(cooldown.fists_of_fury.remains<=6&chi>=3&cooldown.rising_sun_kick.remains<=1)|target.time_to_die<=15
            if (mode.sef == 2 or (mode.sef == 1 and useCDs())) and cast.able.stormEarthAndFire() and getDistance(units.dyn5) < 5
                and (charges.stormEarthAndFire.count() == 2 or (cd.fistsOfFury.remain() <= 6 and chi >= 3 and cd.risingSunKick.remain() <= 1) or ttd <= 15)
            then
                if cast.stormEarthAndFire() then return end
            end
        -- Serenity
            -- serenity,if=cooldown.rising_sun_kick.remains<=2|target.time_to_die<=12
            if (getOptionValue("Serenity") == 1 or (getOptionValue("Serenity") == 2 and useCDs()))
                and getDistance(units.dyn5) < 5 and (cd.risingSunKick.remain() <= 2 or ttd <= 12)
            then
                if cast.serenity() then return end
            end
        end -- End Cooldown - Action List
    -- Action List - Opener
        function actionList_Opener()
            if isChecked("Opener") and isBoss("target") and isValidUnit("target") and not opener then
        -- Potion
                -- potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                -- Agility Proc
                if inRaid and isChecked("Potion") and useCDs() then
                    if isChecked("Pre-Pull Timer") and pullTimer <= getOptionValue("Pre-Pull Timer") then
                        if canUse(127844) and talent.serenity then
                            useItem(127844)
                        end
                        if canUse(142117) and talent.whirlingDragonPunch then
                            useItem(142117)
                        end
                    end
                end
                if talent.whirlingDragonPunch and talent.energizingElixir then
                    -- TP1 -> CW1 -> TP2 -> TOD1 -> SEF1 -> RSK1 -> SOTW1 -> EE1 -> FOF1 -> WDP1 -> TP3 -> RSK2 -> BOK1
                    if getDistance("target") <= 5 then
        -- Tiger Palm
                        if not TP1 then
                            castOpener("tigerPalm","TP1",1)
        -- Chi Wave
                        elseif TP1 and not CWIR then
                            castOpener("chiWave","CWIR",2)
        -- Tiger Palm 2
                        elseif CWIR and not TP2 then
                            castOpener("tigerPalm","TP2",3)
        -- Touch of Death
                        elseif TP1 and not ToD then
                            if not debuff.touchOfDeath.exists() then
                                castOpener("touchOfDeath","ToD",4);
                                SerenityTest = GetTime()
                            else
                                Print("4: Touch of Death (Uncastable)");
                                ToD = true
                            end
        -- Storm, Earth, and Fire
                        elseif ToD and not SEF then
                            if GetTime() >= SerenityTest + (1 - 0.2 - getOptionValue("SEF Timer")) and mode.sef ~= 3 then
                                castOpener("stormEarthAndFire","SEF",5)
                            else
                                castOpener("5: Storm, Earth, and Fire (Uncastable)");
                                SEF = true
                            end
        -- Rising Sun Kick
                        elseif SEF and not RSK1 then
                            castOpener("risingSunKick","RSK1",6)
        -- Fist of the White Tiger
                        elseif RSK1 and not SotW and getDistance(units.dyn5) <= 5 then
                            castOpener("fistOfTheWhiteTiger","SotW",7)
        -- Energizing Elixir
                        elseif SotW and not EE then
                            if getOptionValue("Energizing Elixir") ~= 3 then
                                castOpener("energizingElixir","EE",8)
                            else
                                Print("8: Energizing Elixir (Uncastable)");
                                EE = true
                            end
        -- Fists of Fury
                        elseif EE and not FoF1 then
                            castOpener("fistsOfFury","FoF1",9)
        -- Whirling Dragon Punch
                        elseif FoF1 and not WDP and getDistance(units.dyn5) <= 5 then
                            castOpener("whirlingDragonPunch","WDP",10)
        -- Tiger Palm
                        elseif WDP and not TP3 then
                            castOpener("tigerPalm","TP3",11)
        -- Rising Sun Kick
                        elseif WDP and not RSK2 then
                            castOpener("risingSunKick","RSK2",12)
        -- Blackout Kick
                        elseif RSK2 and not BOK then
                            castOpener("blackoutKick","BOK",13)
                        elseif BOK then
                            Print("Opener Complete")
                            opener = true
                        end
                    end
                end -- End WDP + EE non-tier
                if talent.serenity then
                    -- TP -> ToD -> Serenity + RSK -> SotWL ->  FoF -> RSK -> SCK -> BoK (If it will fit in Serenity)
        -- Chi Wave (In Range)
                    if not iRchiWave then
                        if getDistance("target") < 25 then
                            castOpener("chiWave","iRchiWave",1)
                        else
                            Print("1: Chi Wave (Uncastable)");
                            iRchiWave = true
                        end
                    elseif getDistance("target") < 5 then
        -- Tiger Palm
                        if iRchiWave and not TP1 then
                            castOpener("tigerPalm","TP1",2)
        -- Touch of Death
                        elseif TP1 and not ToD then
                            if not debuff.touchOfDeath.exists() then
                                castOpener("touchOfDeath","ToD",3);
                                SerenityTest = GetTime()
                            else
                                Print("3: Touch of Death (Uncastable)");
                                ToD = true
                            end
        -- Serenity
                        elseif ToD and not SER then
                            if GetTime() >= SerenityTest + 0.7 and getOptionValue("Serenity") ~= 3 then
                                castOpener("serenity","SER",4)
                            else
                                Print("4: Serenity (Uncastable)");
                                SER = true
                            end
        -- Rising Sun Kick
                        elseif SER and not RSK1 then
                            if buff.serenity.exists() then
                                castOpener("risingSunKick","RSK1",5)
                            else
                                Print("5: Rising Sun Kick 1 (Uncastable)");
                                RSK1 = true
                            end
        -- Fist of the White Tiger
                        elseif RSK1 and not SotW and getDistance(units.dyn5) < 5 then
                            if buff.serenity.exists() then
                                castOpener("fistOfTheWhiteTiger","SotW",6)
                            else
                                Print("6: Strike of the Windlord (Uncastable)");
                                SotW = true
                            end
        -- Fists of Fury
                        elseif SotW and not FoF1 then
                            if buff.serenity.exists() then
                                castOpener("fistsOfFury","FoF1",7);
                                FoFTimerOpener = GetTime()
                            else
                                Print("7: Fists of Fury (Uncastable)");
                                FoF1 = true
                            end
        -- Rising Sun Kick
                        elseif FoF1 and not RSK2 and GetTime() >= FoFTimerOpener + 0.2 then
                            if buff.serenity.exists() then
                                castOpener("risingSunKick","RSK2",8)
                            else
                                Print("8: Rising Sun Kick 2 (Uncastable)");
                                RSK2 = true
                            end
        -- Spinning Crane Kick
                        elseif RSK2 and not SCK then
                            if buff.serenity.exists() then
                               castOpener("spinningCraneKick","SCK",9)
                            else
                                Print("9: Spinning Crane Kick (Uncastable)");
                                SCK = true
                            end
        -- Blackout Kick
                        elseif SCK and not BOK then
                            if buff.serenity.exists() then
                               castOpener("blackoutKick","BOK",10)
                            else
                                Print("10: Blackout Kick (Uncastable)");
                                BOK = true
                            end
                        elseif BOK then
                            Print("Opener Complete");
                            opener = true;
                            return
                        end
                    end
                end -- End Serenity - Gale Burst
                if not (talent.serenity or (talent.whirlingDragonPunch and talent.energizingElixir)) then
                    opener = true;
                    return
                end
            elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
				opener = true
            end -- End Boss and Opener Check
        end -- End Action List - Opener
    -- Action List - Single Target
        function actionList_SingleTarget()
        -- Cancel Rushing Jade Wind
            -- cancel_buff,name=rushing_jade_wind,if=active_enemies=1&(!talent.serenity.enabled|cooldown.serenity.remains>3)
            if buff.rushingJadeWind.exists() and ((mode.rotation == 1 and #enemies.yards8 == 1) or (mode.rotation == 3)) and (not talent.serenity or cd.serenity.remain() > 3) then
                --if buff.rushingJadeWind.cancel() then return true end
                CastSpellByID(spell.rushingJadeWind)
            end
        -- Whirling Dragon Punch
            -- whirling_dragon_punch
            if cast.able.whirlingDragonPunch() and isChecked("Whirling Dragon Punch") and talent.whirlingDragonPunch and cd.fistsOfFury.exists() and cd.risingSunKick.exists() then
                if cast.whirlingDragonPunch("player","aoe") then return true end
            end
        -- Rising Sun Kick
            -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(cooldown.fists_of_fury.remains>2|chi>=5|azerite.swift_roundhouse.rank>1)
            if cast.able.risingSunKick(lowestMark) and (cd.fistsOfFury.remain() > 2 or chi >= 5 or traits.swiftRoundhouse.rank() > 1) then
                if cast.risingSunKick(lowestMark) then return end
            end
        -- Rushing Jade Wind
            -- rushing_jade_wind,if=buff.rushing_jade_wind.down&energy.time_to_max>1&active_enemies>1
            if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and ttm > 1
                and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.rushingJadeWind() then return end
            end
        -- Fists of Fury
            -- fists_of_fury,if=energy.time_to_max>2.5&(azerite.swift_roundhouse.rank<2|(cooldown.whirling_dragon_punch.remains<10&talent.whirling_dragon_punch.enabled)|active_enemies>1)
            if cast.able.fistsOfFury() and ttm > 2.5 and (traits.swiftRoundhouse.rank() < 2 or (cd.whirlingDragonPunch.remain() < 10 and talent.whirlingDragonPunch)
                or ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)))
            then
                if cast.fistsOfFury(nil,"cone",1,45) then return end
            end
        -- Fist of the White Tiger
            -- fist_of_the_white_tiger,if=chi<=2&(buff.rushing_jade_wind.down|energy>46)
            if cast.able.fistOfTheWhiteTiger() and chi <= 2 and (not buff.rushingJadeWind.exists() or energy > 46) then
                if cast.fistOfTheWhiteTiger() then return end
            end
        -- Energizing Elixir
            -- energizing_elixir,if=chi<=3&energy<50
            if cast.able.energizingElixir() and (getOptionValue("Energizing Elixir") == 1 or (getOptionValue("Energizing Elixir") == 2 and useCDs()))
                and chi <= 3 and energy < 50 and getDistance("target") < 5
            then
                if cast.energizingElixir() then return true end
            end
        -- Blackout kick
            -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(cooldown.rising_sun_kick.remains>2|chi>=3)&(cooldown.fists_of_fury.remains>2|chi>=4|azerite.swift_roundhouse.enabled)&buff.swift_roundhouse.stack<2
            if cast.able.blackoutKick(lowestMark) and not cast.last.blackoutKick() and (cd.risingSunKick.remain() > 2 or chi >= 3)
                and (cd.fistsOfFury.remain() > 2 or chi >= 4 or traits.swiftRoundhouse.active()) and buff.swiftRoundhouse.stack() < 2
            then
                if cast.blackoutKick(lowestMark) then return true end
            end
        -- Chi Wave
            -- chi_wave
            if cast.able.chiWave() then
                if cast.chiWave(nil,"aoe") then return true end
            end
        -- Chi Burst
            -- chi_burst,if=chi.max-chi>=1&active_enemies=1|chi.max-chi>=2
            if cast.able.chiBurst() and ((chiMax - chi >= 1 and ((mode.rotation == 1 and #enemies.yards8 == 1) or (mode.rotation == 3 and #enemies.yards8 > 0))) or chiMax - chi >= 2) then
                if cast.chiBurst(nil,"rect",1,12) then return true end
            end
        -- Tiger Palm
            -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.tiger_palm&chi.max-chi>=2&(buff.rushing_jade_wind.down|energy>56)
            if cast.able.tigerPalm(lowestMark) and not cast.last.tigerPalm() and chiMax - chi >= 2 and (not buff.rushingJadeWind.exists() or energy > 56) then
                if cast.tigerPalm(lowestMark) then return true end
            end
        -- Flying Serpent Kick
            -- flying_serpent_kick,if=prev_gcd.1.blackout_kick&chi>1&buff.swift_roundhouse.stack<2,interrupt=1
            if mode.fsk == 1 and cast.able.flyingSerpentKick() and cast.last.blackoutKick() and buff.swiftRoundhouse.stack() < 2 then
                if cast.flyingSerpentKick() then return end
            end
        -- Fists of Fury
            -- fists_of_fury,if=energy.time_to_max>2.5&cooldown.rising_sun_kick.remains>2&buff.swift_roundhouse.stack=2
            if ttm > 2.5 and cd.risingSunKick.remain() > 2 and buff.swiftRoundhouse.stack() == 2 then
                if cast.fistsOfFury(nil,"cone",1,45) then return end
            end
        -- Tiger Palm (inefficient but breaks stall)
            if cast.able.tigerPalm(lowestMark) and energy >= 56 and chiMax - chi < 2 and cast.last.blackoutKick() then
                if cast.tigerPalm(lowestMark) then return end
            end
        end -- End Action List - Single Target
    -- Action List - AoE
        function actionList_AoE()
        -- Whirling Dragon Punch
            -- whirling_dragon_punch
            if cast.able.whirlingDragonPunch() and isChecked("Whirling Dragon Punch") and talent.whirlingDragonPunch and cd.fistsOfFury.exists() and cd.risingSunKick.exists() then
                if cast.whirlingDragonPunch("player","aoe") then return true end
            end
        -- Energizing Elixir
            -- energizing_elixir,if=!prev_gcd.1.tiger_palm&chi<=1&energy<50
            if cast.able.energizingElixir() and (getOptionValue("Energizing Elixir") == 1 or (getOptionValue("Energizing Elixir") == 2 and useCDs()))
                and not cast.last.tigerPalm() and chi <= 1 and energy < 50 and getDistance("target") < 5
            then
                if cast.energizingElixir() then return true end
            end
        -- Fists of Fury
            -- fists_of_fury,if=energy.time_to_max>2.5
            if cast.able.fistsOfFury() and ttm > 2.5 then
                if cast.fistsOfFury(nil,"cone",1,45) then return true end
            end
        -- Rushing Jade Wind
            -- rushing_jade_wind,if=buff.rushing_jade_wind.down&energy.time_to_max>1
            if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() and ttm > 1 then
                if cast.rushingJadeWind() then return end
            end
        -- Rising Sun Kick
            -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(talent.whirling_dragon_punch.enabled&cooldown.whirling_dragon_punch.remains<gcd)&cooldown.fists_of_fury.remains>3
            if cast.able.risingSunKick(lowestMark) and (talent.whirlingDragonPunch and cd.whirlingDragonPunch.remain() < gcd) and cd.fistsOfFury.remain() > 3 then
                if cast.risingSunKick(lowestMark) then return true end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick
            if cast.able.spinningCraneKick() and not cast.last.spinningCraneKick() and cd.fistsOfFury.remain() > gcd then
                if cast.spinningCraneKick() then return end
            end
        -- Chi Burst
            -- chi_burst,if=chi<=3
            if cast.able.chiBurst() and chi <= 3 and cd.fistsOfFury.remain() > gcd then
                if cast.chiBurst(nil,"rect",1,12) then return true end
            end
        -- Racial: Arcane Torrent
            -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
            if cast.able.racial() and isChecked("Racial") and race == "BloodElf" and chiMax - chi >= 1 and ttm >= 0.5 then
                if cast.racial() then return true end
            end
        -- Fist of the White Tiger
            -- fist_of_the_white_tiger,if=chi.max-chi>=3&(energy>46|buff.rushing_jade_wind.down)
            if cast.able.fistOfTheWhiteTiger() and chiMax - chi >= 3 and (energy > 46 or not buff.rushingJadeWind.exists()) then
                if cast.fistOfTheWhiteTiger() then return end
            end
        -- Tiger Palm
            -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.tiger_palm&chi.max-chi>=2&(energy>56|buff.rushing_jade_wind.down)
            if cast.able.tigerPalm(lowestMark) and not cast.last.tigerPalm() and chiMax - chi >= 2 and (energy > 56 or not buff.rushingJadeWind.exists()) then
                if cast.tigerPalm(lowestMark) then return end
            end
        -- Chi Wave
            -- chi_wave
            if cast.able.chiWave() then
                if cast.chiWave(nil,"aoe") then return true end
            end
        -- Flying Serpent Kick
            -- flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
            if mode.fsk == 1 and cast.able.flyingSerpentKick() and not buff.blackoutKick.exists() then
                if cast.flyingSerpentKick() then return end
            end
        -- Blackout Kick
            -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick
            if cast.able.blackoutKick(lowestMark) and not cast.last.blackoutKick() then
                if cast.blackoutKick(lowestMark) then return end
            end
        -- Spinning Crane Kick
            if cast.able.spinningCraneKick() and chiMax - chi < 2 and cast.last.blackoutKick() then
                if cast.spinningCraneKick() then return end
            end
        end -- End Action List - AoE
    -- Action List - Serenity
        function actionList_Serenity()
        -- Rising Sun Kick
            -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains
            if cast.able.risingSunKick(lowestMark) then
                if cast.risingSunKick(lowestMark) then return true end
            end
        -- Fists of Fury
            -- fists_of_fury,if=(buff.bloodlust.up&prev_gcd.1.rising_sun_kick&!azerite.swift_roundhouse.enabled)|buff.serenity.remains<1|active_enemies>1
            if cast.able.fistsOfFury() and ((hasBloodLust() and cast.last.risingSunKick() and not traits.swiftRoundhouse.active()) or buff.serenity.remain() < 1
                or ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0)))
            then
                if cast.fistsOfFury(nil,"cone",1,45) then return end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(active_enemies>=3|(active_enemies=2&prev_gcd.1.blackout_kick))
            if cast.able.spinningCraneKick() and not cast.last.spinningCraneKick() and (((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0))
                or (((mode.rotation == 1 and #enemies.yards8 == 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and cast.last.blackoutKick()))
            then
                if cast.spinningCraneKick(nil,"aoe") then return true end
            end
        -- Blackout Kick
            -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains
            if cast.able.blackoutKick(lowestMark) then
                if cast.blackoutKick(lowestMark) then return true end
            end
        end -- End Action List - Serenity
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
        -- Flask / Crystal
                -- flask,type=flask_of_the_seventh_demon
                if getOptionValue("Flask/Crystal") == 1 and inRaid and not buff.flaskOfTheSeventhDemon.exists() and use.able.flaskOfTheSeventhDemon() then
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.flaskOfTheSeventhDemon() then return true end
                end
                if getOptionValue("Flask/Crystal") == 2 and not buff.felFocus.exists() and use.able.repurposedFelFocuser() and not buff.flaskOfTheSeventhDemon.exists() then
                    -- if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
                    if use.repurposedFelFocuser() then return true end
                end
                if getOptionValue("Flask/Crystal") == 3 and not buff.whispersOfInsanity.exists() and use.able.oraliusWhisperingCrystal() then
                    if buff.flaskOfTheSeventhDemon.exists() then buff.flaskOfTheSeventhDemon.cancel() end
                    if buff.felFocus.exists() then buff.felFocus.cancel() end
                    if use.oraliusWhisperingCrystal() then return true end
                end
                if isValidUnit("target") and getDistance("target") < 5 and opener then
        -- Chi Burst
                -- chi_burst,if=(!talent.serenity.enabled|!talent.fist_of_the_white_tiger.enabled)
                    if cast.able.chiBurst() and (not talent.serenity or not talent.fistOfTheWhiteTiger) then
                        if cast.chiBurst(nil,"rect",1,12) then return true end
                    end
        -- Chi Wave
                -- chi_wave
                    if cast.chiWave(nil,"aoe") then return true end
        -- Start Attack
                -- auto_attack
                    if power > 50 then
                        if cast.tigerPalm("target") then StartAttack(); return true end
                    else
                        StartAttack()
                    end
                end
            end -- End No Combat Check
        -- Opener
            if actionList_Opener() then return true end
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
            if actionList_Extras() then return true end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return true end
---------------------------
--- Pre-Combat Rotation ---
---------------------------
            if actionList_PreCombat() then return true end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- FIGHT!
            if inCombat and profileStop==false and isValidUnit(units.dyn5) and opener and not isCastingSpell(spell.spinningCraneKick) then
    ------------------
    --- Interrupts ---
    ------------------
        -- Run Action List - Interrupts
                if actionList_Interrupts() then return true end
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
                if getOptionValue("APL Mode") == 1 then -- --[[and cd.global.remain() <= getLatency()]] and GetTime() >= SEFTimer + getOptionValue("SEF Timer") then
        -- Rushing Jade Wind
                    -- rushing_jade_wind,if=talent.serenity.enabled&cooldown.serenity.remains<3&energy.time_to_max>1&buff.rushing_jade_wind.down
                    if cast.able.rushingJadeWind() and talent.serenity and cd.serenity.remain() < 3 and ttm > 1 and not buff.rushingJadeWind.exists() then
                        if cast.rushingJadeWind() then return end
                    end
        -- Touch of Karma
                    -- touch_of_karma,interval=90,pct_health=0.5,if=!talent.Good_Karma.enabled,interval=90,pct_health=0.5
                    if isChecked("Touch of Karma") and useCDs() and cast.able.touchOfKarma() and php >= 50 and not talent.goodKarma then
                        if cast.touchOfKarma() then return true end
                    end
                    -- touch_of_karma,interval=90,pct_health=1,if=talent.Good_Karma.enabled,interval=90,pct_health=1
                    if isChecked("Touch of Karma") and useCDs() and cast.able.touchOfKarma() and php >= 100 and talent.goodKarma then
                        if cast.touchOfKarma() then return true end
                    end
        -- Potion
                    -- potion,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                    if inRaid and isChecked("Potion") and useCDs() and getDistance("target") < 5 then
                        if buff.serenity.exists() or buff.stormEarthAndFire.exists() or talent.serenity or hasBloodLust() or ttd <= 60 then
                            if canUse(127844) then
                                useItem(127844)
                            end
                            if canUse(142117) then
                                useItem(142117)
                            end
                        end
                    end
        -- Call Action List - Serenity
                    -- call_action_list,name=serenity,if=buff.serenity.up
                    if buff.serenity.exists() then
                        if actionList_Serenity() then return end
                    end
        -- Fist of the White Tiger
                    -- fist_of_the_white_tiger,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=3
                    if cast.able.fistOfTheWhiteTiger() and (ttm < 1 or (talent.serenity and cd.serenity.remain() < 2)) and chiMax - chi >= 3 then
                        if cast.fistOfTheWhiteTiger() then return end
                    end
        -- Tiger Palm
                    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=2&!prev_gcd.1.tiger_palm
                    if cast.able.tigerPalm(lowestMark) and (ttm < 1 or (talent.serenity and cd.serenity.remain() < 2)) and chiMax - chi >= 2 and not cast.last.tigerPalm() then
                        if cast.tigerPalm(lowestMark) then return end
                    end
        -- Call Action List - Cooldowns
                    -- call_action_list,name=cd
                    if actionList_Cooldowns() then return end
        -- Call Action List - Single Target
                    -- call_action_list,name=st,if=(active_enemies<4&azerite.swift_roundhouse.rank<3)|active_enemies<5
                    if ((mode.rotation == 1 and ((#enemies.yards8 < 4 and traits.swiftRoundhouse.rank() < 3) or #enemies.yards8 < 5))
                        or (mode.rotation == 3 and #enemies.yards8 > 0))
                    then
                        if actionList_SingleTarget() then return true end
                    end
        -- Call Action List - AoE
                    -- call_action_list,name=aoe,if=(active_enemies>=4&azerite.swift_roundhouse.rank<3)|active_enemies>=5
                    if ((mode.rotation == 1 and ((#enemies.yards8 >= 4 and traits.swiftRoundhouse.rank() < 3) or #enemies.yards8 >= 5))
                        or (mode.rotation == 2 and #enemies.yards8 > 0))
                    then
                        if actionList_AoE() then return end
                    end
                end -- End Simulation Craft APL
    ----------------------------
    --- APL Mode: AskMrRobot ---
    ----------------------------
                if getOptionValue("APL Mode") == 2 then
        -- Potion
                    if canUse(109217) and inRaid and isChecked("Potion") and useCDs() and getDistance("target") < 5  then
                        if hasBloodLust() or ttd <= 60 then
                            useItem(109217)
                        end
                    end
        -- Racial - Blood Fury / Berserking / Arcane Torrent / Fireblood
                    -- blood_fury
                    -- berserking
                    -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
                    -- fireblood
                    -- ancestral_call
                    if isChecked("Racial") and cast.able.racial() then
                        if (race == "BloodElf" and chiMax - chi >= 1 and ttm >= 0.5) or race == "Orc" or race == "Troll" or race == "LightforgedDraenei" or race == "DarkIronDwarf" or race == "MagharOrc" then
                            if race == "LightforgedDraenei" then
                                if cast.racial("target","ground") then return true end
                            else
                                if cast.racial("player") then return true end
                            end
                        end
                    end
        -- Trinkets
                    if isChecked("Trinkets") and getDistance(units.dyn5) < 5 and (buff.stormEarthAndFire.exists() or buff.serenity.exists() or not isBoss()) then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end
        -- Rushing Jade Wind
                    -- if TargetsInRadius(RushingJadeWind) < 3
                    if ((mode.rotation == 1 and #enemies.yards8 < 3) or (mode.rotation == 2 and #enemies.yards8 == 0) or mode.rotation == 3) and buff.rushingJadeWind.exists() then
                        if buff.rushingJadeWind.cancel() then return true end
                    end
        -- Touch of Karma
                    -- if FightDurationSec - FightSecRemain > 10
                    if cast.able.touchOfKarma() and combatTime > 10 then
                        if cast.touchOfKarma() then return true end
                    end
        --  Invoke Xuen
                    if isChecked("Xuen") and cast.able.invokeXuenTheWhiteTiger() and useCDs() then
                        if cast.invokeXuenTheWhiteTiger() then return true end
                    end
        -- Rushing Jade Wind
                    -- if TargetsInRadius(RushingJadeWind) >= 3
                    if cast.able.rushingJadeWind("player") and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) and not buff.rushingJadeWind.exists() then
                        if cast.rushingJadeWind("player") then return true end
                    end
        -- Touch of Death
                    -- TargetSecUnitDeath
                    if useCDs() and isChecked("Touch of Death") and cast.able.touchOfDeath() and ttd > 8 then
                        if cast.touchOfDeath() then return true end
                    end
        -- Serenity
                    if (getOptionValue("Serenity") == 1 or (getOptionValue("Serenity") == 2 and useCDs())) and cast.able.serenity() and useCDs() and talent.serenity then
                        if cast.serenity() then return true end
                    end
        -- Storm, Earth, and Fire
                    if (mode.sef == 2 or (mode.sef == 1 and useCDs())) and cast.able.stormEarthAndFire() and useCDs() and not talent.serenity then
                        if cast.stormEarthAndFire() then return true end
                    end
        -- Whirling Dragon Punch
                    if cast.able.whirlingDragonPunch() and isChecked("Whirling Dragon Punch") and talent.whirlingDragonPunch and cd.fistsOfFury.exists() and cd.risingSunKick.exists() then
                        Print("Casting Whirling Dragon Punch")
                        if cast.whirlingDragonPunch("player","aoe") then return true end
                    end
        -- Spinning Crane Kick
                    -- if not WasLastCast(SpinningCraneKick) and HasBuff(Serenity) and TargetsInRadius(SpinningCraneKick) >= 3
                    if cast.able.spinningCraneKick() and not cast.last.spinningCraneKick() and buff.serenity.exists() and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                        Print("Casting Spinning Crane Kick")
                        if cast.spinningCraneKick(nil,"aoe") then return true end
                    end
        -- Rising Sun Kick
                    if cast.able.risingSunKick() then
                        if cast.risingSunKick() then return true end
                    end
        -- Fists of Fury
                    if cast.able.fistsOfFury() then
                        if cast.fistsOfFury(nil,"cone",1,45) then return true end
                    end
        -- Spinning Crane Kick
                    -- if not WasLastCast(SpinningCraneKick) and TargetsInRadius(SpinningCraneKick) >= 3 and CooldownSecRemain(FistsOfFury) > 3
                    if cast.able.spinningCraneKick() and not cast.last.spinningCraneKick() and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) and cd.fistsOfFury.remain() > 3 then
                        Print("Casting Spinning Crane Kick 2")
                        if cast.spinningCraneKick(nil,"aoe") then return true end
                    end
        -- Blackout Kick
                    -- if not WasLastCast(BlackoutKick) and HasBuff(Serenity)
                    if cast.able.blackoutKick() and not cast.last.blackoutKick() and buff.serenity.exists() then
                        if cast.blackoutKick() then return true end
                    end
                    -- if not WasLastCast(BlackoutKick) and (AlternatePower >= 2 or HasBuff(ComboBreaker))
                    if cast.able.blackoutKick() and not cast.last.blackoutKick() and (chi >= 2 or buff.blackoutKick.exists()) then
                        if cast.blackoutKick() then return true end
                    end
        -- Spinning Crane Kick
                    -- if not WasLastCast(SpinningCraneKick) and HasBuff(Serenity)
                    if cast.able.spinningCraneKick() and not cast.last.spinningCraneKick() and buff.serenity.exists() then
                        if cast.spinningCraneKick(nil,"aoe") then return true end
                    end
        -- Fist of the White Tiger
                    -- if AlternatePowerToMax >= 3
                    if cast.able.fistOfTheWhiteTiger() and chiDeficit >= 3 then
                        if cast.fistOfTheWhiteTiger() then return true end
                    end
        -- Chi Burst
                    if cast.able.chiBurst() and ((mode.rotation == 1 and enemies.yards12r > 2) or (mode.rotation == 2 and enemies.yards12r > 0)) then
                        if cast.chiBurst(nil,"rect",1,12) then return true end
                    end
        -- Chi Wave
                    if cast.able.chiWave() then
                        if cast.chiWave(nil,"aoe") then return true end
                    end
        -- Tiger Palm
                    -- if not WasLastCast(TigerPalm)
                    if cast.able.tigerPalm() and not cast.last.tigerPalm() then
                        if cast.tigerPalm() then return true end
                    end
        -- Energizing Elixir
                    if cast.able.energizingElixir() and (getOptionValue("Energizing Elixir") == 1 or (getOptionValue("Energizing Elixir") == 2 and useCDs())) then
                        if cast.energizingElixir() then return true end
                    end
                end -- End AskMrRobot APL
            end -- End Combat Check
        end -- End Pause
    --end -- End Timer
end -- End runRotation
local id = 269
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

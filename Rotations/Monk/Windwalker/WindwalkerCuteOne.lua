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
-- 
    FOFModes = {
        [1] = { mode = "On", value = 2 , overlay = "FoF Enabled", tip = "Will cast Fists Of Fury.", highlight = 1, icon = br.player.spell.fistsOfFury},
        [2] = { mode = "Off", value = 1 , overlay = "FoF Disabled", tip = "Will NOT cast Fists Of Fury.", highlight = 0, icon = br.player.spell.fistsOfFury}
    };
    CreateButton("FOF",7,0)
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
            br.ui:createSpinnerWithout(section,"CJL OOR Cancel", 30,  5,  160,  5, "Cancel CJL OOR when under X Energy")
        -- Chi Burst 
            br.ui:createSpinnerWithout(section,"Chi Burst Min Units",1,1,10,1,"|cffFFFFFFSet to the minumum number of units to cast Chi Burst on.")
        -- FoF Targets
            br.ui:createSpinnerWithout(section, "Fists of Fury Targets", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Fists of Fury on.")
        -- Provoke
            br.ui:createCheckbox(section, "Provoke", "Will aid in grabbing mobs when solo.")
        -- Roll
            br.ui:createCheckbox(section, "Roll")
        -- Spread Mark Cap
            br.ui:createSpinnerWithout(section, "Spread Mark Cap", 5, 0, 10, 1, "|cffFFFFFFSet to limit Mark of the Crane Buffs, 0 for unlimited. Min: 0 / Max: 10 / Interval: 1")
        -- Tiger's Lust
            br.ui:createCheckbox(section, "Tiger's Lust")
        -- Whirling Dragon Punch
            br.ui:createCheckbox(section, "Whirling Dragon Punch")
        -- Whirling Dragon Punch Targets
            br.ui:createSpinnerWithout(section, "Whirling Dragon Punch Targets", 1, 1, 10, 1, "|cffFFFFFFSet to the minumum number of units to cast Whirling Dragon Punch on.")
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
            br.ui:createDropdownWithout(section,"Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 1.")
            br.ui:createDropdownWithout(section,"Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 2.")
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
        -- Detox
            br.ui:createCheckbox(section,"Detox")
        -- Diffuse Magic/Dampen Harm
            br.ui:createSpinner(section, "Diffuse/Dampen",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Effuse
            br.ui:createSpinner(section, "Vivify",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Leg Sweep
            br.ui:createSpinner(section, "Leg Sweep - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinner(section, "Leg Sweep - AoE", 5, 0, 10, 1, "|cffFFFFFFNumber of Units in 5 Yards to Cast At")
        -- Resuscitate
            br.ui:createDropdown(section, "Resuscitate", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
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
        UpdateToggle("FOF", 0.25)
        br.player.mode.fof = br.data.settings[br.selectedSpec].toggles["FOF"]

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
        local level             = br.player.level
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
        enemies.get(5,"player",false,true)
        enemies.get(8)
        enemies.get(8,"player",false,true)
        enemies.yards40r = getEnemiesInRect(10,40,false) or 0

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if openerCount == nil then openerCount = 0 end
        if SerenityTest == nil then SerenityTest = GetTime() end
        if SEFTimer == nil then SEFTimer = GetTime() end
        if FoFTimerOpener == nil then FoFTimerOpener = GetTime() end
        if castFSK == nil then castFSK = false end
        if fixateTarget == nil then fixateTarget = "player" end

        if isCastingSpell(spell.cracklingJadeLightning)
            and (getDistance(units.dyn5) <= 5 or (#enemies.yards8 == 0 and power <= getOptionValue("CJL OOR Cancel") and isChecked("CJL OOR")))
        then
            SpellStopCasting()
        end

        local lowestMark = debuff.markOfTheCrane.lowest(5,"remain") or units.dyn5
        if not inCombat or lastCombo == nil then lastCombo = 6603 end
        if lastCast == nil then lastCast = 6603 end
        local function wasLastCombo(spellID)
            return lastCombo == spellID
        end

        -- Opener Reset
        if not inCombat and not GetObjectExists("target") then
            openerCount = 0
            OPN1 = false
            XUEN = false
            TRNK1 = false
            TRNK2 = false
            FotWT = false
            TP1 = false
            TOD = false
            SEF = false
            SEFF = false
            RSK1 = false
            FOF = false
            WDP = false
            TP2 = false
            BOK1 = false
            TP3 = false
            RSK2 = false
            BOK2 = false
            TP4 = false
            BOK3 = false
            CBW = false
            BOK4 = false
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

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Stop Casting
            if isCastingSpell(spell.cracklingJadeLightning) then
             --   Print("channeling cjl")
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
                    and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
                then
                    if cast.resuscitate("target") then return true end
                end
                if getOptionValue("Resuscitate") == 2
                    and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and GetUnitIsFriend("mouseover","player")
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
                    if combatTime >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        CancelUnitBuff("player", GetSpellInfo(br.player.spell.stormEarthAndFire))
                        StopAttack()
                        ClearTarget()
                        StopAttack()
                        ClearTarget()
                        Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    end
                end
            end
        -- Crackling Jade Lightning
            if isChecked("CJL OOR") and (lastCombo ~= spell.cracklingJadeLightning or buff.hitCombo.stack() <= 1) and #enemies.yards8f == 0 and not isCastingSpell(spell.cracklingJadeLightning) and (hasThreat("target") or isDummy()) and not moving and power >= getOptionValue("CJL OOR") then
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
            if cast.able.stormEarthAndFireFixate("target") and getOptionValue("SEF Behavior") == 1
                and not talent.serenity and not cast.current.fistsOfFury() and not UnitIsUnit(fixateTarget,"target")
            then
                if cast.stormEarthAndFireFixate("target") then fixateTarget = ObjectPointer("target") return true end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Healthstone") and getHP("player") <= getOptionValue("Healthstone") and inCombat then
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
                if isChecked("Diffuse/Dampen") and php <= getOptionValue("Dampen Harm") and inCombat then
                    if cast.dampenHarm() then return true end
                end
        -- Diffuse Magic
                if isChecked("Diffuse/Dampen") and ((php <= getOptionValue("Diffuse Magic") and inCombat) or canDispel("player",br.player.spell.diffuseMagic)) then
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
                if (getOptionValue("Trinket 1") == 1 or (getOptionValue("Trinket 2") == 2 and useCDs())) and canUse(13) then
                    useItem(13)
                end
                if (getOptionValue("Trinket 2") == 1 or (getOptionValue("Trinket 2") == 2 and useCDs())) and canUse(14) then
                    useItem(14)
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
                if isChecked("Touch of Death") and cast.able.touchOfDeath() and ttd > 9 and cast.last.tigerPalm() then --and cd.fistsOfFury.remain() < gcd then
                    if cast.touchOfDeath("target") then return true end
                end
            end
        -- Storm, Earth, and Fire
            -- storm_earth_and_fire,if=cooldown.storm_earth_and_fire.charges=2|(cooldown.fists_of_fury.remains<=6&chi>=3&cooldown.rising_sun_kick.remains<=1)|target.time_to_die<=15
            if (mode.sef == 2 or (mode.sef == 1 and useCDs())) and cast.able.stormEarthAndFire() and getDistance(units.dyn5) < 5
                and (charges.stormEarthAndFire.count() == 2 or (cd.fistsOfFury.remain() <= 6 and chi >= 3 and cd.risingSunKick.remain() <= 1) or ttd <= 15) and not talent.serenity
                and (cast.last.touchOfDeath() or not useCDs() or not isChecked("Touch of Death") or cd.touchOfDeath.remain() > gcd)
            then
                if cast.stormEarthAndFire() then fixateTarget = "player"; return true end
            end
        -- Serenity
            -- serenity,if=cooldown.rising_sun_kick.remains<=2|target.time_to_die<=12
            if (getOptionValue("Serenity") == 1 or (getOptionValue("Serenity") == 2 and useCDs()))
                and getDistance(units.dyn5) < 5 and (cd.risingSunKick.remain() <= 2 or ttd <= 12)
            then
                if cast.serenity() then return true end
            end
        end -- End Cooldown - Action List
    -- Action List - Opener
        function actionList_Opener()
        -- Start Attack
            -- auto_attack
            if isChecked("Opener") and isBoss("target") and not opener then
                if isValidUnit("target") and getDistance("target") < 5 and getFacing("player","target") and getSpellCD(61304) == 0 then
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
            -- Begin
                    if not OPN1 then
                        Print("Starting Opener")
                        openerCount = openerCount + 1
                        OPN1 = true
                        return
            -- Xuen
                    elseif OPN1 and not XUEN then
                        if not talent.invokeXuenTheWhiteTiger or cd.invokeXuenTheWhiteTiger.remain() > gcd then
                            castOpenerFail("invokeXuenTheWhiteTiger","XUEN",openerCount)
                        elseif cast.able.invokeXuenTheWhiteTiger() then
                            castOpener("invokeXuenTheWhiteTiger","XUEN",openerCount)
                        end
                        openerCount = openerCount + 1; 
                        return
            -- Trinkets 
                    elseif XUEN and not TRNK1 then 
                        if not canUse(13) then 
                            Print(openerCount..": Trinket 1 (Uncastable)") 
                        elseif isChecked("Trinkets") and canUse(13) and not (hasEquiped(151190,13) or hasEquiped(147011,13)) then
                            useItem(13)
                            Print(openerCount..": Trinket 1")
                        end 
                        openerCount = openerCount + 1;                            
                        TRNK1 = true
                        return
                    elseif TRNK1 and not TRNK2 then 
                        if not canUse(14) then 
                            Print(openerCount..": Trinket 2 (Uncastable)") 
                        elseif isChecked("Trinkets") and canUse(14) and not (hasEquiped(151190,14) or hasEquiped(147011,14)) then
                            useItem(14)
                            Print(openerCount..": Trinket 2")
                        end
                        openerCount = openerCount + 1
                        TRNK2 = true 
                        return
            -- Fist of the White Tiger
                    elseif TRNK2 and not FotWT then 
                        if not talent.fistOfTheWhiteTiger or cd.fistOfTheWhiteTiger.remain() > gcd then
                            castOpenerFail("fistOfTheWhiteTiger","FotWT",openerCount)
                        elseif cast.able.fistOfTheWhiteTiger() then
                            castOpener("fistOfTheWhiteTiger","FotWT",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
                    --end
            -- Tiger Palm 1
                    elseif FotWT and not TP1 then
                        if wasLastCombo(spell.tigerPalm) then 
                            castOpenerFail("tigerPalm","TP1",openerCount)
                        elseif cast.able.tigerPalm() then
                            castOpener("tigerPalm","TP1",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
                    --end
            -- Touch of Death
                    elseif TP1 and not TOD then
                        if level < 32 or cd.touchOfDeath.remain() > 0 then 
                            castOpenerFail("touchOfDeath","TOD",openerCount)
                        elseif cast.able.touchOfDeath() then
                            castOpener("touchOfDeath","TOD",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
                    --end
            -- Storm, Earth, and Fire
                    elseif TOD and not SEF then
                        if level < 50 or not charges.stormEarthAndFire.exists() then 
                            castOpenerFail("stormEarthAndFire","SEF",openerCount)
                        elseif cast.able.stormEarthAndFire() then
                            castOpener("stormEarthAndFire","SEF",openerCount)
                            fixateTarget = "player"
                        end
                        openerCount = openerCount + 1
                        return
            -- Rising Sun Kick 1
                    elseif SEF and not RSK1 then 
                        if level < 10 or chi < 2 or cd.risingSunKick.remain() > gcd then 
                            castOpenerFail("risingSunKick","RSK1",openerCount)
                        elseif cast.able.risingSunKick() then
                            castOpener("risingSunKick","RSK1",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Fists of Fury 
                    elseif RSK1 and not FOF then 
                        if level < 20 or chi < 3 or cd.fistsOfFury.remain() > gcd then 
                            castOpenerFail("fistsOfFury","FOF",openerCount)
                        elseif cast.able.fistsOfFury() then
                            castOpener("fistsOfFury","FOF",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Whirling Dragon Punch 
                    elseif FOF and not WDP then 
                        if not talent.whirlingDragonPunch or cd.whirlingDragonPunch.remain() > gcd or (cd.fistsOfFury.remain() == 0 and cd.risingSunKick.remain() == 0) then 
                            castOpenerFail("whirlingDragonPunch","WDP",openerCount)
                        elseif cast.able.whirlingDragonPunch() then
                            castOpener("whirlingDragonPunch","WDP",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Tiger Palm 2 
                    elseif WDP and not TP2 then
                        if wasLastCombo(spell.tigerPalm) then 
                            castOpenerFail("tigerPalm","TP2",openerCount)
                        elseif cast.able.tigerPalm() then
                            castOpener("tigerPalm","TP2",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Blackout Kick 1
                    elseif TP2 and not BOK1 then
                        if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                            castOpenerFail("blackoutKick","BOK1",openerCount)
                        elseif cast.able.blackoutKick() then
                            castOpener("blackoutKick","BOK1",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Tiger Palm 3
                    elseif BOK1 and not TP3 then 
                        if wasLastCombo(spell.tigerPalm) then 
                            castOpenerFail("tigerPalm","TP3",openerCount)
                        elseif cast.able.tigerPalm() then
                            castOpener("tigerPalm","TP3",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Rising Sun Kick 2
                    elseif TP3 and not RSK2 then
                        if level < 10 or chi < 2 or cd.risingSunKick.remain() > gcd then 
                            castOpenerFail("risingSunKick","RSK2",openerCount)
                        elseif cast.able.risingSunKick() then 
                            castOpener("risingSunKick","RSK2",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Blackout Kick 2
                    elseif RSK2 and not BOK2 then
                        if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                            castOpenerFail("blackoutKick","BOK2",openerCount)
                        elseif cast.able.blackoutKick() then
                            castOpener("blackoutKick","BOK2",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Tiger Palm 4
                    elseif BOK2 and not TP4 then 
                        if wasLastCombo(spell.tigerPalm) then 
                            castOpenerFail("tigerPalm","TP4",openerCount)
                        elseif cast.able.tigerPalm() then
                            castOpener("tigerPalm","TP4",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Blackout Kick 3
                    elseif TP4 and not BOK3 then
                        if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                            castOpenerFail("blackoutKick","BOK3",openerCount)
                        elseif cast.able.blackoutKick() then
                            castOpener("blackoutKick","BOK3",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Chi Burst/Wave
                    elseif BOK3 and not CBW then 
                        if talent.chiBurst then 
                            if not cast.able.chiBurst() then 
                                castOpenerFail("chiBurst","CBW",openerCount)
                                openerCount = openerCount + 1
                            elseif cast.able.chiBurst() then
                                castOpener("chiBurst","CBW",openerCount)
                                openerCount = openerCount + 1
                            end
                        elseif talent.chiWave then 
                            if not cast.able.chiWave() then 
                                castOpenerFail("chiWave","CBW",openerCount)
                                openerCount = openerCount + 1
                            elseif cast.able.chiWave() then
                                castOpener("chiWave","CBW",openerCount)
                                openerCount = openerCount + 1
                            end
                        else 
                            CBW = true 
                        end
                        return
            -- Blackout Kick 4
                    elseif CBW and not BOK4 then
                        if chi < 1 or (chi == 0 and not buff.blackoutKick.exists()) or wasLastCombo(spell.blackoutKick) then 
                            castOpenerFail("blackoutKick","BOK4",openerCount)
                        elseif cast.able.blackoutKick() then
                            castOpener("blackoutKick","BOK4",openerCount)
                        end
                        openerCount = openerCount + 1
                        return
            -- Finish (rip exists)
                    elseif BOK4 then
                        Print("Opener Complete")
                        openerCount = 0
                        opener = true
                    end
                end
            elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
                opener = true
            end -- End Boss and Opener Check
        end -- End Action List - Opener
    -- Action List - Single Target
        function actionList_SingleTarget()
        -- Whirling Dragon Punch
            -- whirling_dragon_punch
            if isChecked("Whirling Dragon Punch") and cast.able.whirlingDragonPunch() and talent.whirlingDragonPunch and not moving
                and cd.fistsOfFury.exists() and cd.risingSunKick.exists() and #enemies.yards8 >= getOptionValue("Whirling Dragon Punch Targets") 
            then
                if cast.whirlingDragonPunch("player","aoe") then return true end
            end
        -- Rising Sun Kick 
            -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=chi>=5
            if cast.able.risingSunKick() and chi >= 5 then 
                if cast.risingSunKick() then return true end 
            end 
        -- Fists of Fury 
            -- fists_of_fury,if=energy.time_to_max>3
            if cast.able.fistsOfFury() and not cast.last.stormEarthAndFire() and (ttm > 3 and #enemies.yards8f >= getOptionValue("Fists of Fury Targets")) 
                and mode.fof == 1 and (ttd > 3 or #enemies.yards8f > 1)
            then 
                if cast.fistsOfFury() then return true end 
            end 
        -- Rising Sun Kick
            -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains
            if cast.able.risingSunKick() then
                if cast.risingSunKick() then return true end
            end
        -- Spinning Crane Kick 
            -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&buff.dance_of_chiji.up
            if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and buff.danceOfChiJi.exists() then 
                if cast.spinningCraneKick(nil,"aoe") then return true end 
            end
        -- Rushing Jade Wind
            -- rushing_jade_wind,if=buff.rushing_jade_wind.down&active_enemies>1
            if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists()
                and ((mode.rotation == 1 and #enemies.yards8 > 1) or (mode.rotation == 2 and #enemies.yards8 > 0))
            then
                if cast.rushingJadeWind() then return true end
            end
        -- Fist of the White Tiger
            -- fist_of_the_white_tiger,if=chi<=2
            if cast.able.fistOfTheWhiteTiger() and chi <= 2 then
                if cast.fistOfTheWhiteTiger() then return true end
            end
        -- Energizing Elixir
            -- energizing_elixir,if=chi<=3&energy<50
            if cast.able.energizingElixir() and (getOptionValue("Energizing Elixir") == 1 or (getOptionValue("Energizing Elixir") == 2 and useCDs()))
                and chi <= 3 and energy < 50 and getDistance("target") < 5
            then
                if cast.energizingElixir() then return true end
            end
        -- Blackout kick
            -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(cooldown.rising_sun_kick.remains>3|chi>=3)&(cooldown.fists_of_fury.remains>4|chi>=4|(chi=2&prev_gcd.1.tiger_palm))&buff.swift_roundhouse.stack<2
            if cast.able.blackoutKick() and not wasLastCombo(spell.blackoutKick) and buff.swiftRoundhouse.stack() < 2 and (((cd.risingSunKick.remain() > 3 or chi >= 3) 
                and (cd.fistsOfFury.remain() > 4 or chi >= 4 or ((chi == 2 or ttm <= 3) and wasLastCombo(spell.tigerPalm) or ttd <= 3 
                or #enemies.yards8f < getOptionValue("Fists of Fury Targets") or mode.fof == 2))) or buff.blackoutKick.exists())
            then
                if cast.blackoutKick() then return true end
            end
        -- Chi Wave
            -- chi_wave
            if cast.able.chiWave() then
                if cast.chiWave(nil,"aoe") then return true end
            end
        -- Chi Burst
            -- chi_burst,if=chi.max-chi>=1&active_enemies=1|chi.max-chi>=2
            if cast.able.chiBurst() and ((chiMax - chi >= 1 and enemies.yards40r == 1) or chiMax - chi >= 2)
                and ((mode.rotation == 1 and enemies.yards40r >= getOptionValue("Chi Burst Min Units")) or (mode.rotation == 3 and enemies.yards40r > 0)) 
            then
                if cast.chiBurst(nil,"rect",1,12) then return true end
            end
        -- Tiger Palm
            -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.tiger_palm&chi.max-chi>=2
            if cast.able.tigerPalm() and not wasLastCombo(spell.tigerPalm) and (chiMax - chi >= 2 or ttd < 3 or ttm < 3)
            then
                if cast.tigerPalm() then return true end
            end
        -- Flying Serpent Kick
            -- flying_serpent_kick,if=prev_gcd.1.blackout_kick&chi>3&buff.swift_roundhouse.stack<2,interrupt=1
            if mode.fsk == 1 and cast.able.flyingSerpentKick() and wasLastCombo(spell.blackoutKick) and chi > 3 and buff.swiftRoundhouse.stack() < 2 then
                if cast.flyingSerpentKick() then return true end
            end
        end -- End Action List - Single Target
    -- Action List - AoE
        function actionList_AoE()
        -- Rising Sun Kick
            -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=(talent.whirling_dragon_punch.enabled&cooldown.whirling_dragon_punch.remains<5)&cooldown.fists_of_fury.remains>3
            if cast.able.risingSunKick(lowestMark) and (talent.whirlingDragonPunch and cd.whirlingDragonPunch.remain() < 5) and cd.fistsOfFury.remain() > 3 then
                if cast.risingSunKick(lowestMark) then return true end
            end
        -- Whirling Dragon Punch
            -- whirling_dragon_punch
            if cast.able.whirlingDragonPunch() and isChecked("Whirling Dragon Punch") and talent.whirlingDragonPunch and not moving
                and cd.fistsOfFury.exists() and cd.risingSunKick.exists() and #enemies.yards8 >= getOptionValue("Whirling Dragon Punch Targets") 
            then
                if cast.whirlingDragonPunch("player","aoe") then return true end
            end
        -- Energizing Elixir
            -- energizing_elixir,if=!prev_gcd.1.tiger_palm&chi<=1&energy<50
            if cast.able.energizingElixir() and (getOptionValue("Energizing Elixir") == 1 or (getOptionValue("Energizing Elixir") == 2 and useCDs()))
                and cast.last.tigerPalm() and chi <= 1 and energy < 50 and getDistance("target") < 8
            then
                if cast.energizingElixir() then return true end
            end
        -- Fists of Fury
            -- fists_of_fury,if=energy.time_to_max>3
            if cast.able.fistsOfFury() and not cast.last.stormEarthAndFire() and (ttd > 3 or #enemies.yards8f > 1) and ttm > 3 
                and #enemies.yards8f >= getOptionValue("Fists of Fury Targets") and mode.fof == 1 
            then
                if cast.fistsOfFury() then return true end
            end
        -- Rushing Jade Wind
            -- rushing_jade_wind,if=buff.rushing_jade_wind.down
            if cast.able.rushingJadeWind() and not buff.rushingJadeWind.exists() then
                if cast.rushingJadeWind() then return true end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(((chi>3|cooldown.fists_of_fury.remains>6)&(chi>=5|cooldown.fists_of_fury.remains>2))|energy.time_to_max<=3)
            if cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick)
                and (((chi > 3 or cd.fistsOfFury.remain() > 6) and (chi >= 5 or cd.fistsOfFury.remain() > 2)) or ttm <= 3 or ttd <= 3 
                    or #enemies.yards8f < getOptionValue("Fists of Fury Targets") and mode.fof == 2) 
            then
                if cast.spinningCraneKick(nil,"aoe") then return true end
            end
        -- Chi Burst
            -- chi_burst,if=chi<=3
            if cast.able.chiBurst() and chi <= 3
                and ((mode.rotaion == 1 and enemies.yards40r >= getOptionValue("Chi Burst Min Units")) or (mode.rotation == 2 and enemies.yards40r > 0)) 
            then
                if cast.chiBurst(nil,"rect",1,12) then return true end
            end
        -- Fist of the White Tiger
            -- fist_of_the_white_tiger,if=chi.max-chi>=3
            if cast.able.fistOfTheWhiteTiger() and chiMax - chi >= 3 then
                if cast.fistOfTheWhiteTiger() then return true end
            end
        -- Tiger Palm
            -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=chi.max-chi>=2&(!talent.hit_combo.enabled|!prev_gcd.1.tiger_palm)
            if cast.able.tigerPalm(lowestMark) and (chiMax - chi >= 2 or ttd < 3 or ttm < 3) and (not talent.hitCombo or not wasLastCombo(spell.tigerPalm)) then
                if cast.tigerPalm(lowestMark) then return true end
            end
        -- Chi Wave
            -- chi_wave
            if cast.able.chiWave() then
                if cast.chiWave(nil,"aoe") then return true end
            end
        -- Flying Serpent Kick
            -- flying_serpent_kick,if=buff.bok_proc.down,interrupt=1
            if mode.fsk == 1 and cast.able.flyingSerpentKick() and not buff.blackoutKick.exists() then
                if cast.flyingSerpentKick() then return true end
            end
        -- Blackout Kick
            -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains,if=!prev_gcd.1.blackout_kick&(buff.bok_proc.up|(talent.hit_combo.enabled&prev_gcd.1.tiger_palm&chi<4))
            if cast.able.blackoutKick(lowestMark) and not wasLastCombo(spell.blackoutKick)
                and (buff.blackoutKick.exists() or (talent.hitCombo and wasLastCombo(spell.tigerPalm) and chi < 4) or ttd <= 3 or ttm <= 3)
            then
                if cast.blackoutKick(lowestMark) then return true end
            end
        end -- End Action List - AoE
    -- Action List - Serenity
        function actionList_Serenity()
        -- Rising Sun Kick
            -- rising_sun_kick,target_if=min:debuff.mark_of_the_crane.remains,if=active_enemies<3|prev_gcd.1.spinning_crane_kick
            if chi >= 2 and  cast.able.risingSunKick(lowestMark) and (#enemies.yards8 < 3 or wasLastCombo(spell.spinningCraneKick)) then
                if cast.risingSunKick(lowestMark) then return true end
            end
        -- Fists of Fury
            -- fists_of_fury,if=(buff.bloodlust.up&prev_gcd.1.rising_sun_kick)|buff.serenity.remains<1|(active_enemies>1&active_enemies<5)
            if chi >= 3 and  cast.able.fistsOfFury() and ((hasBloodLust() and wasLastCombo(spell.risingSunKick)) or buff.serenity.remain() < 1
                or (#enemies.yards8f > 1 and #enemies.yards8f < 5)) and mode.fof == 1
            then
                if cast.fistsOfFury() then return true end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick&(active_enemies>=3|(active_enemies=2&prev_gcd.1.blackout_kick))
            if chi >= 2 and cast.able.spinningCraneKick() and not wasLastCombo(spell.spinningCraneKick) and (((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0))
                or (((mode.rotation == 1 and #enemies.yards8 == 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) and wasLastCombo(spell.blackoutKick)))
            then
                if cast.spinningCraneKick(nil,"aoe") then return true end
            end
        -- Blackout Kick
            -- blackout_kick,target_if=min:debuff.mark_of_the_crane.remains
            if chi >= 1 and cast.able.blackoutKick(lowestMark) then
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
                if isValidUnit("target") and opener then
                    if getDistance("target") < 5 then
            -- -- Chi Burst
            --         -- chi_burst,if=(!talent.serenity.enabled|!talent.fist_of_the_white_tiger.enabled)
            --             if cast.able.chiBurst() and (not talent.serenity or not talent.fistOfTheWhiteTiger) 
            --                 and ((mode.rotaion == 1 and enemies.yards40r >= getOptionValue("Chi Burst Min Units")) or (mode.rotation == 2 and enemies.yards40r > 0)) 
            --             then
            --                 if cast.chiBurst(nil,"rect",1,12) then return true end
            --             end
            -- -- Chi Wave
            --         -- chi_wave
            --             if cast.able.chiWave() and (not talent.invokeXuenTheWhiteTiger or cd.invokeXuenTheWhiteTiger.remain() > gcd or not useCDs() or not isChecked("Xuen"))
            --                 and (not talent.fistOfTheWhiteTiger or cd.fistOfTheWhiteTiger.remain() > gcd or chi > 2) 
            --             then 
            --                 if cast.chiWave(nil,"aoe") then return true end
            --             end
            -- Start Attack
                    -- auto_attack
                        StartAttack()
                    end
            -- Crackling Jade Lightning 
                    if isChecked("CJL OOR") and getDistance("target") < 40 and not moving and power >= getOptionValue("CJL OOR") then 
                        if cast.cracklingJadeLightning("target") then StartAttack(); return true end                         
                    end
            -- Provoke 
                    if isChecked("Provoke") and not isBoss("target") and getDistance("target") < 30 and (moving or power < getOptionValue("CJL OOR")) then 
                        if cast.provoke("target") then StartAttack(); return true end 
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
            if inCombat and profileStop==false and isValidUnit(units.dyn5) and opener 
                and not cast.current.spinningCraneKick() and not cast.current.fistsOfFury() 
            then
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
        -- Touch of Karma
                    -- touch_of_karma,interval=90,pct_health=0.5
                    if isChecked("Touch of Karma") and useCDs() and cast.able.touchOfKarma() and php >= 50 then
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
                        if actionList_Serenity() then return true end
                    end
        -- Xuen 
                    if cast.able.invokeXuenTheWhiteTiger() and useCDs() and isChecked("Xuen") then 
                        if cast.invokeXuenTheWhiteTiger() then return true end 
                    end
        -- Fist of the White Tiger
                    -- fist_of_the_white_tiger,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=3
                    if cast.able.fistOfTheWhiteTiger() and (ttm < 1 or (talent.serenity and cd.serenity.remain() < 2)) and chiMax - chi >= 3 then
                        if cast.fistOfTheWhiteTiger() then return true end
                    end
        -- Tiger Palm
                    -- tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=(energy.time_to_max<1|(talent.serenity.enabled&cooldown.serenity.remains<2))&chi.max-chi>=2&!prev_gcd.1.tiger_palm
                    if cast.able.tigerPalm(lowestMark) and (ttm < 1 or (talent.serenity and cd.serenity.remain() < 2)) 
                        and chiMax - chi >= 2 and not wasLastCombo(spell.tigerPalm)
                    then
                        if cast.tigerPalm(lowestMark) then return true end
                    end
        -- Call Action List - Cooldowns
                    -- call_action_list,name=cd
                    if actionList_Cooldowns() then return true end
        -- Call Action List - Single Target
                    -- call_action_list,name=st,if=active_enemies<3
                    if level < 40 or ((mode.rotation == 1 and #enemies.yards8 < 3) or (mode.rotation == 3 and #enemies.yards8 > 0)) then
                        if actionList_SingleTarget() then return true end
                    end
        -- Call Action List - AoE
                    -- call_action_list,name=aoe,if=active_enemies>=3
                    if level >= 40 and ((mode.rotation == 1 and #enemies.yards8 >= 3) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                        if actionList_AoE() then return true end
                    end
                end -- End Simulation Craft APL
    ----------------------------
    --- APL Mode: AskMrRobot ---
    ----------------------------
                if getOptionValue("APL Mode") == 2 then

                end -- End AskMrRobot APL
            end -- End Combat Check
        end -- End Pause
    end -- End Timer
-- end -- End runRotation
local id = 269
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

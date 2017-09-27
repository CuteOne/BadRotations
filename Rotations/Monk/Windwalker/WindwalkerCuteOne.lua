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
        -- Challenge Skin Helper
            br.ui:createCheckbox(section, "Challenge Skin Helper")
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
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
        -- SEF Timer
            br.ui:createSpinnerWithout(section, "SEF Timer",  0.3,  0,  1,  0.05,  "|cffFFFFFFDesired time in seconds to resume rotation after casting SEF so clones can get into place. This value changes based on different factors so requires some testing to find what works best for you.")
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
        -- Draught of Souls
            br.ui:createCheckbox(section,"Draught of Souls")
        -- Gnawed Thumb Ring
            br.ui:createCheckbox(section,"Gnawed Thumb Ring")
        -- Ring of Collapsing Futures
            br.ui:createCheckbox(section,"Ring of Collapsing Futures")
        -- Specter of Betrayal
            br.ui:createCheckbox(section,"Specter of Betrayal")
        -- Vial of Ceaseless Toxins
            br.ui:createCheckbox(section,"Vial of Ceaseless Toxins")
        -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        -- Experimental BoK Code Checkbox :P
            -- br.ui:createCheckbox(section,"Experimental BoK Logic", "Should provide a dps gain, however not fully tested. Disable if causing issues.")
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
        -- Healing Winds
            br.ui:createSpinner(section, "Healing Winds", 50, 0, 100, 5, "|cffFFFFFFHealth To Use Transcendence (Healing Winds Perk)")
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
        local chi               = br.player.power.chi.amount()
        local chiMax            = br.player.power.chi.max()
        local combatTime        = getCombatTime()
        local debuff            = br.player.debuff
        local enemies           = enemies or {}
        local flaskBuff         = getBuffRemain("player",br.player.flask.wod.buff.agilityBig) or 0
        local gcd               = br.player.gcd
        local glyph             = br.player.glyph
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
        local queue             = br.player.queue
        local race              = br.player.race
        local racial            = br.player.getRacial()
        local regen             = br.player.power.energy.regen()
        local solo              = select(2,IsInInstance())=="none"
        local spell             = br.player.spell
        local t19_2pc           = TierScan("T19") >= 2
        local t19_4pc           = TierScan("T19") >= 4
        local t20_2pc           = TierScan("T20") >= 2
        local t20_4pc           = TierScan("T20") >= 4
        local t21_4pc           = false -- TODO: Add Tier 21
        local talent            = br.player.talent
        local thp               = getHP(br.player.units(5))
        local trinketProc       = false --br.player.hasTrinketProc()
        local ttd               = getTTD(br.player.units(5))
        local ttm               = br.player.power.energy.ttm()
        local units             = units or {}

        units.dyn5 = br.player.units(5)
        enemies.yards5 = br.player.enemies(5)
        enemies.yards8 = br.player.enemies(8)

        if not inCombat or lastCombo == nil or not buff.hitCombo.exists() then lastCombo = 6603 end
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if SerenityTest == nil then SerenityTest = GetTime() end
        if SEFTimer == nil then SEFTimer = GetTime() end
        if FoFTimerOpener == nil then FoFTimerOpener = GetTime() end
        if TPEETimer == nil then TPEETimer = GetTime() end
        if hasEquiped(137029) then FoFCost = 2 else FoFCost = 3 end

        -- ChatOverlay(round2(getDistance("target","player","dist"),2)..", "..round2(getDistance("target","player","dist2"),2)..", "..round2(getDistance("target","player","dist3"),2)..", "..round2(getDistance("target","player","dist4"),2)..", "..round2(getDistance("target"),2))

        
        if isCastingSpell(spell.cracklingJadeLightning) 
            and (getDistance(units.dyn5) <= 5 or (#enemies.yards8 == 0 and power <= getOptionValue("CJL OOR Cancel") and isChecked("CJL OOR Cancel"))) 
            and ((hasEquiped(144239) and buff.theEmperorsCapacitor.stack() < 19 and ttm > 3) 
                or (hasEquiped(144239) and buff.theEmperorsCapacitor.stack() < 14 and cd.serenity.remain() < 13 and talent.serenity and ttm > 3) 
                or not hasEquiped(144239))
        then
            SpellStopCasting()
        end


        -- function HoldBoK()
        --     if isChecked("Experimental BoK Logic") then
        --         if (chi >= FoFCost and cd.fistsOfFury.remain() <= gcd and cd.fistsOfFury.remain() ~= 0) or (chi >= 2 and ((cd.risingSunKick.remain() <= gcd and cd.risingSunKick.remain() ~= 0) or (cd.strikeOfTheWindlord.remain() <= gcd and cd.strikeOfTheWindlord.remain() ~= 0 and getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())))) or ((cd.whirlingDragonPunch.remain() <= gcd and cd.risingSunKick.remain() >= gcd and cd.fistsOfFury.remain() >= gcd) and cd.whirlingDragonPunch.remain() ~= 0) then
        --             return true
        --         else
        --             return false
        --         end
        --     else
        --         return false
        --     end
        -- end

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

        -- Last Combo Spell
        if lastCast == spell.tigerPalm
            or lastCast == spell.blackoutKick
            or lastCast == spell.flyingSerpentKick
            or lastCast == spell.spinningCraneKick
            or lastCast == spell.risingSunKick
            or lastCast == spell.fistsOfFury
            or lastCast == spell.touchOfDeath
            or lastCast == spell.cracklingJadeLightning
            or lastCast == spell.chiWave
            or lastCast == spell.rushingJadeWind
            or lastCast == spell.chiBurst
            or lastCast == spell.whirlingDragonPunch
            or lastCast == spell.strikeOfTheWindlord
        then
            if level < 78 or buff.hitCombo.stack() == 0 then
                lastCombo = 6603
            else
                lastCombo = lastCast
            end
        end
        local AttackPower = UnitAttackPower("player")
        local ArmorRedux = (1 - 0.3198)
        local Crit = (1 + (GetCritChance() / 100))
        local Mastery = (1 + (GetMasteryEffect("player") / 100))
        local Versatility = (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100)) 

        -- Mark of the Crane Count
        local markOfTheCraneCount = debuff.markOfTheCrane.count()

        local function windborneFerocity()
            return ((1 + (artifact.ferocityOfTheBrokenTemple.rank() * 0.05)) * (1 + (artifact.windborneBlows.rank() * 0.1)))
        end

        local function blackoutKickDmg()
            if chi >= 1 then
                return  (
                            (4.697 * AttackPower * ArmorRedux) -- Base Dmg
                            * ((1 + (artifact.darkSkies.rank() * 0.2)) * windborneFerocity()) -- + Traits
                            * (Mastery * Versatility * Crit) -- + Stats
                            * ((1 + (buff.hitCombo.stack() * 0.02)) * 1.26) -- + Buffs
                        )
            else
                return 0
            end
        end

        local function risingSunKickDmg()
            if chi >= 2 and cd.risingSunKick.remain() == 0 then
                return  (
                            (11.102 * AttackPower * ArmorRedux) -- Base Dmg
                            * ((1 + (artifact.risingWinds.rank() * 0.05)) * (1 + (artifact.tornadoKicks.rank() * 0.25)) * windborneFerocity()) -- + Traits
                            * (Mastery * Versatility * Crit) -- + Stats
                            * ((1 + (buff.hitCombo.stack() * 0.02)) * 1.26) -- + Buffs
                        )
            else
                return 0
            end
        end

        local function whirlingDragonPunchDmg()
            if #enemies.yards8 == 0 then wdpEnemies = 1 else wdpEnemies = #enemies.yards8 end
            if cd.whirlingDragonPunch.remain() == 0 then
                return  (
                            ((3 * 5.063) * AttackPower * ArmorRedux) -- Base Dmg
                            * windborneFerocity() -- + Traits
                            * (Mastery * Versatility * Crit) -- + Stats
                            * (1 + (buff.hitCombo.stack() * 0.02)) -- + Buffs
                            * wdpEnemies
                        )
            else
                return 0
            end
        end

        local function crosswindsDmg()
            if artifact.crosswinds.enabled() then
                return  (
                            (8 * AttackPower * ArmorRedux) -- Base Damage
                            * windborneFerocity() -- + Traits
                            * Versatility -- + Versatility
                            * Crit -- + Crit
                            * (1 + (buff.hitCombo.stack() * 0.02)) -- + Buffs
                        ) 
            else
                return 0
            end
        end

        local function fistsOfFuryDmg()
            local chiCost = hasEquiped(137029) and 2 or 3
            if getEnemiesInCone(5,90) == 0 then fofEnemies = 1 else fofEnemies = getEnemiesInCone(5,90) end
            if chi >= chiCost and cd.fistsOfFury.remain() == 0 then
                return  ((
                            ((5.734 * 5 ) * AttackPower * ArmorRedux) -- Base Damage
                            * ((1 + (artifact.fistsOfTheWind.rank() * 0.05)) * (1 + (buff.transferThePower.stack() * 0.03)) * windborneFerocity()) -- + Traits
                            * (Mastery * Versatility * Crit) -- + Stats
                            * (1 + (buff.hitCombo.stack() * 0.02)) -- + Buffs
                            * fofEnemies
                        )
                            + crosswindsDmg()
                        )
            else
                return 0
            end
        end

        local function strikeOfTheWindlordDmg()
            -- local minMain, maxMain, minOff, maxOff, _, _, dmgMulti = UnitDamage("player")
            -- local multiplier = dmgMulti * Versatility
            -- local mainDmg = (((minMain + maxMain) / 2) + AttackPower / 3.5 * 2.6) * multiplier
            -- local offDmg = mainDmg * 0.5
            -- local weapDmg = (mainDmg + offDmg) * ArmorRedux
            -- -- print(weapDmg)
            -- if hasEquiped(151811) then wlCD = 32 else wlCD = 40 end
            -- -- if artifact.strikeOfTheWindlord.enabled() and chi >= 2 and cd.strikeOfTheWindlord.remain() == 0 then
            --     return  (
            --                 ((weapDmg + (0.74 * AttackPower)) * 41.175 * ArmorRedux) -- Base Damage
            --             )
            -- -- else
                return 0
            -- end
        end

        local function spinningCraneKickDmg()
            if #enemies.yards8 == 0 then sckEnemies = 1 else sckEnemies = #enemies.yards8 end
            if chi >= 3 then
                return  (
                            (4.88 * AttackPower * ArmorRedux) -- Base Dmg
                            * (1 + (0.03 * artifact.powerOfAThousandCranes.rank() + math.floor(artifact.powerOfAThousandCranes.rank() / 3) * 0.01)) * windborneFerocity() -- + Traits
                            * (Mastery * Versatility * Crit) -- + Stats
                            * (1 + (buff.hitCombo.stack() * 0.02)) -- + Buffs
                            * (sckEnemies * (1 + (debuff.markOfTheCrane.count() * 0.4))) --  + Mark of the Crane
                        )
            else
                return 0
            end
        end

        -- Print("SCK: "..round2(spinningCraneKickDmg(),0)..", FoF: "..round2(fistsOfFuryDmg(),0)..", WDP: "..round2(whirlingDragonPunchDmg(),0)..", RSK: "..round2(risingSunKickDmg(),0).."BOK: "..round2(blackoutKickDmg(),0))

        -- Spinning Crane Kick Stuff
        if level >= 40 then
            -- if markOfTheCraneCount >= 16 then
            BetterThanWDP = spinningCraneKickDmg() > whirlingDragonPunchDmg() 
            -- if (markOfTheCraneCount >= 13 and #enemies.yards5 >= 3) or (markOfTheCraneCount >= 14 and #enemies.yards5 == 2) or markOfTheCraneCount >= 16 then
            BetterThanFoF = spinningCraneKickDmg() > fistsOfFuryDmg()
            -- if #enemies.yards8 >= 4 or (markOfTheCraneCount >= 2 and #enemies.yards8 == 3) or markOfTheCraneCount >= 9 then
            BetterThanRSK = spinningCraneKickDmg() > risingSunKickDmg()
            -- if #enemies.yards8 >= 3 or (markOfTheCraneCount >= 2 and #enemies.yards8 == 2) or markOfTheCraneCount >= 6 then
            BetterThanBOK = spinningCraneKickDmg() > blackoutKickDmg()
            BetterThanSOTW = (#enemies.yards8 >= 13 or (markOfTheCraneCount >= 2 and #enemies.yards8 == 10) 
                or (markOfTheCraneCount >= 3 and #enemies.yards8 == 8) or (markOfTheCraneCount >= 4 and #enemies.yards8 == 6) 
                or (markOfTheCraneCount >= 7 and #enemies.yards8 == 4) or (markOfTheCraneCount >= 9 and #enemies.yards8 == 3) 
                or (markOfTheCraneCount >= 13 and #enemies.yards8 == 2) or markOfTheCraneCount >= 14)
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

        -- Healing Winds - Transcendence Cancel
        if isChecked("Healing Winds") and buff.transcendence.exists() and (buff.healingWinds.exists() or php > getOptionValue("Healing Winds")) then
            CancelUnitBuff("player",GetSpellInfo(spell.buffs.transcendence))
        end

        -- Challenge Skin Heler
        if isChecked("Challenge Skin Helper") then
            for i=1, #getEnemies("player",20) do
                thisUnit = getEnemies("player",20)[i]
                distance = getDistance(thisUnit)
                if distance < 5 then
                    if isChecked("Leg Sweep") then
                        if cast.legSweep(thisUnit) then return end
                    end
                end
                if isCastingSpell(242733,thisUnit) then
                    Print("Fel Burst is Casting!")
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
                if isCastingSpell(241687,thisUnit) then
                    if isChecked("Paralysis") then
                        if cast.paralysis(thisUnit) then return end
                    end
                end
            end
        end

        -- Spread the Mark of the Crane
        local function spreadMark()
            local markUnit = units.dyn5                
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if debuff.markOfTheCrane.refresh(thisUnit) then
                    markUnit = thisUnit
                    break
                end
            end
            return markUnit
        end
        
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
                    if cast.tigersLust() then return end
                end
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
            if isChecked("Provoke") and not inCombat and select(3,GetSpellInfo(101545)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green"
                and cd.flyingSerpentKick.remain() > 1 and getDistance("target") > 10 and isValidUnit("target") and not isBoss("target")
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
                if cast.cracklingJadeLightning() then return end
             end
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
        -- Healing Winds
                if isChecked("Healing Winds") and php <= getOptionValue("Healing Winds") and artifact.healingWinds.enabled() and not moving then
                    if not buff.transcendence.exists() then
                        if cast.transcendence("player") then return end
                    end
                    if buff.transcendence.exists() then
                        if cast.transcendenceTransfer("player") then CancelUnitBuff("player",GetSpellInfo(spell.buffs.transcendence)); return end
                    end
                end
        -- Effuse
                if isChecked("Effuse") and not inCombat and php <= getOptionValue("Effuse") then
                    if cast.effuse() then return end
                end
        -- Healing Elixir
                if isChecked("Healing Elixir") and php <= getOptionValue("Healing Elixir") then
                    if cast.healingElixir() then return end
                end
        -- Leg Sweep
                if isChecked("Leg Sweep - HP") and php <= getOptionValue("Leg Sweep - HP") and inCombat and #enemies.yards5 > 0 then
                    if cast.legSweep() then return end
                end
                if isChecked("Leg Sweep - AoE") and #enemies.yards5 >= getOptionValue("Leg Sweep - AoE") then
                    if cast.legSweep() then return end
                end
        -- Touch of Karma
                if isChecked("Touch of Karma") and php <= getOptionValue("Touch of Karma") and inCombat then
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
                if isChecked("Trinkets") then
                    if canUse(13) and not (hasEquiped(151190,13) or hasEquiped(147011,13)) then
                        useItem(13)
                    end
                    if canUse(14) and not (hasEquiped(151190,14) or hasEquiped(147011,14)) then
                        useItem(14)
                    end
                end
        -- Gnawed Thumb Ring
                if isChecked("Gnawed Thumb Ring") and hasEquiped(134526) and canUse(134526) and select(2,IsInInstance()) ~= "pvp" then
                    if buff.touchOfKarma.exists() or buff.serenity.exists() or buff.stormEarthAndFire.exists() then
                        useItem(134526)
                    end
                end
        -- Ring of Collapsing Futures
                if isChecked("Ring of Collapsing Futures") and hasEquiped(142173) and canUse(142173) and not debuff.temptation.exists("player") then
                    useItem(142173)
                end
        -- Invoke Xuen
                -- invoke_xuen
                if isChecked("Xuen") then
                    if cast.invokeXuenTheWhiteTiger() then return end
                end
        -- Specter of Betrayal
                -- use_item,name=specter_of_betrayal,if=(cooldown.serenity.remains>10|buff.serenity.up)|!talent.serenity.enabled
                if isChecked("Specter of Betrayal") and hasEquiped(151190) and canUse(151190) then
                    if (cd.serenity.remain() > 10 or buff.serenity.exists()) or not talent.serenity then
                        useItem(151190)
                    end
                end
        -- Vial of Ceaseless Toxins
                -- use_item,name=vial_of_ceaseless_toxins,if=(buff.serenity.up&!equipped.specter_of_betrayal)|(equipped.specter_of_betrayal&(time<5|cooldown.serenity.remains<=8))|!talent.serenity.enabled|target.time_to_die<=cooldown.serenity.remains
                if isChecked("Vial of Ceaseless Toxins") and hasEquiped(147011) and canUse(147011) then
                    if (buff.serenity.exists() and not hasEquiped(151190)) or (hasEquiped(151190) and (combatTime < 5 or cd.serenity.remain() <= 8)) or not talent.serenity or ttd <= cd.serenity.remain() then
                        useItem(147011)
                    end
                end
        -- Racial - Blood Fury / Berserking
                -- blood_fury
                -- berserking
                -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
                if isChecked("Racial") and getSpellCD(racial) == 0 then
                    if (race == "BloodElf" and chiMax - chi >= 1 and ttm >= 0.5) or race == "Orc" or race == "Troll" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                end
        -- Touch of Death
                if isChecked("Touch of Death") then
                    -- touch_of_death,cycle_targets=1,max_cycle_targets=2,if=!artifact.gale_burst.enabled().enabled&equipped.hidden_masters_forbidden_touch&!prev_gcd.1.touch_of_death
                    if not artifact.galeBurst.enabled() and hasEquiped(137057) and canToD and lastCombo ~= spell.touchOfDeath then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if cast.touchOfDeath(thisUnit) then canToD = false; SerenityTest = GetTime(); return end
                        end
                    end
                    -- touch_of_death,if=!artifact.gale_burst.enabled().enabled&!equipped.hidden_masters_forbidden_touch
                    if not artifact.galeBurst.enabled() and not hasEquiped(137057) and canToD and lastCombo ~= spell.touchOfDeath then
                        if cast.touchOfDeath() then SerenityTest = GetTime(); return end
                    end
                    -- touch_of_death,cycle_targets=1,max_cycle_targets=2,if=artifact.gale_burst.enabled().enabled&((talent.serenity.enabled&cooldown.serenity.remains<=1)|chi>=2)&(cooldown.strike_of_the_windlord.remains<8|cooldown.fists_of_fury.remains<=4)&cooldown.rising_sun_kick.remains<7&!prev_gcd.1.touch_of_death
                    if artifact.galeBurst.enabled() and ((talent.serenity and cd.serenity.remain() <= 1) or chi >= 2) and (cd.strikeOfTheWindlord.remain() < 8 or cd.fistsOfFury.remain() <= 4) and cd.risingSunKick.remain() < 7 and canToD and lastCombo ~= spell.touchOfDeath then
                        for i = 1, #enemies.yards5 do
                            local thisUnit = enemies.yards5[i]
                            if cast.touchOfDeath(thisUnit) then canToD = false; SerenityTest = GetTime(); return end
                        end
                    end
                -- Draught of Souls
                    -- use_item,name=draught_of_souls,if=talent.serenity.enabled&!buff.serenity.up&energy.time_to_max>3
                    -- use_item,name=draught_of_souls,if=!talent.serenity.enabled&!buff.storm_earth_and_fire.up&energy.time_to_max>3
                    if isChecked("Draught of Souls") and hasEquiped(140808) and canUse(140808) then
                        if (talent.serenity and not buff.serenity.exists() and ttm > 3) or (not talent.serenity and not buff.stormEarthAndFire.exists() and ttm > 3) then
                            useItem(140808)
                        end
                    end                    
                end
            end
        end -- End Cooldown - Action List
    -- Action List - Opener
        function actionList_Opener()
            if isBoss("target") and isValidUnit("target") and opener == false then
        -- Potion
                -- potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                -- TODO: Agility Proc
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
                if talent.whirlingDragonPunch and talent.energizingElixir and t19_2pc then
                    -- TP -> ChiWave -> TP -> ToD -> SEF -> RSK -> SoTW -> EE -> FoF -> WDP -> RSK                    
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
                                SerenityTest = GetTime();
                            else
                                Print("4: Touch of Death (Uncastable)");
                                ToD = true
                            end
        -- Storm, Earth, and Fire
                        elseif ToD and not SEF then
                            if GetTime() >= SerenityTest + (1 - 0.2 - getOptionValue("SEF Timer")) then
                                castOpener("stormEarthAndFire","SEF",5)
                            end
        -- Rising Sun Kick
                        elseif SEF and not RSK1 then
                            castOpener("risingSunKick","RSK1",6)
        -- Strike of the Windlord
                        elseif RSK1 and not SotW and getDistance(units.dyn5) <= 5 then
                            castOpener("strikeOfTheWindlord","SotW",7)
        -- Energizing Elixir
                        elseif SotW and not EE then
                            castOpener("energizingElixir","EE",8)
        -- Fists of Fury
                        elseif EE and not FoF1 then
                            castOpener("fistsOfFury","FoF1",9)
        -- Whirling Dragon Punch
                        elseif FoF1 and not WDP and getDistance(units.dyn5) <= 5 then
                            castOpener("whirlingDragonPunch","WDP",10)
        -- Rising Sun Kick
                        elseif WDP and not RSK2 then
                            castOpener("risingSunKick","RSK2",11)
                        elseif RSK2 then
                            Print("Opener Complete")
                            opener = true
                        end
                    end
                end -- End Whirling Dragon Punch + Energizing Elixir T19_2PC
                if talent.whirlingDragonPunch and talent.energizingElixir and not t19_2pc then
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
                            if GetTime() >= SerenityTest + (1 - 0.2 - getOptionValue("SEF Timer")) then
                                castOpener("stormEarthAndFire","SEF",5)
                            end
        -- Rising Sun Kick
                        elseif SEF and not RSK1 then
                            castOpener("risingSunKick","RSK1",6)
        -- Strike of the Windlord
                        elseif RSK1 and not SotW and getDistance(units.dyn5) <= 5 then
                            castOpener("strikeOfTheWindlord","SotW",7)
        -- Energizing Elixir
                        elseif SotW and not EE then
                            castOpener("energizingElixir","EE",8)
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
                if talent.whirlingDragonPunch and talent.powerStrikes then
                    -- TP -> TOD -> TP + SEF -> FoF -> SotWL -> TP -> RSK -> WDP -> TP                    
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
        -- Tiger Palm
                        elseif ToD and not TP2 then
                            castOpener("tigerPalm","TP2",4)
        -- Storm, Earth, and Fire
                        elseif TP2 and not SEF then
                            if GetTime() >= SerenityTest + (1 - getOptionValue("SEF Timer")) then
                                castOpener("stormEarthAndFire","SEF",5)
                            else
                                Print("5: Storm, Earth, and Fire (Uncastable)");
                                SEF = true
                            end
        -- Fists of Fury
                        elseif SEF and not FoF1 then
                            castOpener("fistsOfFury","FoF1",6)
        -- Strike of the Windlord
                        elseif FoF1 and not SotW and getDistance(units.dyn5) < 5 then
                            castOpener("strikeOfTheWindlord","SotW",7)
        -- Tiger Palm
                        elseif SotW and not TP3 then
                            castOpener("tigerPalm","TP3",8)
        -- Rising Sun Kick
                        elseif TP3 and not RSK1 then
                            castOpener("risingSunKick","RSK1",9)
        -- Whirling Dragon Punch
                        elseif RSK1 and not WDP and getDistance(units.dyn5) < 5 then
                            castOpener("whirlingDragonPunch","WDP",10)
        -- Tiger Palm
                        elseif WDP and not TP4 then
                            castOpener("tigerPalm","TP4",11)
                        elseif TP4 then
                            Print("Opener Complete")
                            opener = true
                        end
                    end
                end -- End Whirling Dragon Punch + Power Strikes
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
                        elseif ToD and not SER and GetTime() >= SerenityTest + 0.7 then
                            castOpener("serenity","SER",4)
        -- Rising Sun Kick
                        elseif SER and not RSK1 then
                            --if buff.serenity.exists() then
                                castOpener("risingSunKick","RSK1",5)
                            --[[else
                                Print("5: Rising Sun Kick 1 (Uncastable)");
                                RSK1 = true
                            end]]
        -- Strike of the Windlord
                        elseif RSK1 and not SotW and getDistance(units.dyn5) < 5 then
                            --if buff.serenity.exists() then
                                castOpener("strikeOfTheWindlord","SotW",6)
                            --[[else
                                Print("6: Strike of the Windlord (Uncastable)");
                                SotW = true
                            end]]
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
                            --if buff.serenity.exists() then
                                castOpener("risingSunKick","RSK2",8)
                            --[[else
                                Print("8: Rising Sun Kick 2 (Uncastable)");
                                RSK2 = true
                            end]]
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
            -- energizing_elixir,if=chi<=1&(cooldown.rising_sun_kick.remains=0|(artifact.strike_of_the_windlord.enabled().enabled&cooldown.strike_of_the_windlord.remains=0)|energy<50)
            if chi <= 1 and (cd.risingSunKick.remain() == 0 or (artifact.strikeOfTheWindlord.enabled() and cd.strikeOfTheWindlord.remain() == 0 and (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()))) or power < 50) 
                and getDistance("target") < 5 and GetTime() >= TPEETimer + 0.4 
            then
                if cast.energizingElixir() then TPEETimer = GetTime(); return end
            end
        -- Racial - Arcane Torrent
            -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
            if chiMax - chi >= 1 and ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" and getSpellCD(racial) == 0 and getDistance("target") < 5 then
                if castSpell("player",racial,false,false,false) then return end
            end
        -- Tiger Palm
            -- tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm&energy.time_to_max<=0.5&chi.max-chi>=2
            if lastCombo ~= spell.tigerPalm and ttm <= 0.5 and chiMax - chi >= 2 and GetTime() >= TPEETimer + 0.4 then
                if cast.tigerPalm(spreadMark()) then TPEETimer = GetTime(); return end
            end
        -- Strike of the Windlord
            -- strike_of_the_windlord,if=!talent.serenity.enabled|cooldown.serenity.remains>=10
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                if (not talent.serenity or cd.serenity.remain() >= 10 or not isChecked("Serenity") or not useCDs()) and getDistance(units.dyn5) < 5 then
                    if BetterThanSOTW and lastCombo ~= spell.spinningCraneKick then
                        if cast.spinningCraneKick() then return end
                    elseif lastCombo ~= spell.strikeOfTheWindlord  then
                        if cast.strikeOfTheWindlord() then return end
                    end
                end
            end
        -- Rising Sun Kick
            -- rising_sun_kick,cycle_targets=1,if=((chi>=3&energy>=40)|chi>=5)&(!talent.serenity.enabled|cooldown.serenity.remains>=5)
            if ((chi >= 3 and power >= 40) or chi >= 5) and (not talent.serenity or cd.serenity.remain() >= 5 or not isChecked("Serenity") or not useCDs()) then
                if BetterThanRSK == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                else
                    if cast.risingSunKick(spreadMark()) then return end
                end
            end
        -- Fists of Fury
            -- fists_of_fury,if=talent.serenity.enabled&!equipped.drinking_horn_cover&cooldown.serenity.remains>=5&energy.time_to_max>2
            if talent.serenity and not hasEquiped(137097) and cd.serenity.remain() >= 5 and ttm > 2 then
                if BetterThanFoF == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                else
                    if cast.fistsOfFury() then return end
                end
            end
            -- fists_of_fury,if=talent.serenity.enabled&equipped.drinking_horn_cover&(cooldown.serenity.remains>=15|cooldown.serenity.remains<=4)&energy.time_to_max>2
            if talent.serenity and hasEquiped(137097) and (cd.serenity.remain() >= 15 or cd.serenity.remain() <= 4) and ttm > 2 then
                if BetterThanFoF == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                else
                    if cast.fistsOfFury() then return end
                end
            end
            -- fists_of_fury,if=!talent.serenity.enabled&energy.time_to_max>2
            if not talent.serenity and ttm > 2 then
                if BetterThanFoF == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                else
                    if cast.fistsOfFury() then return end
                end
            end
        -- Rising Sun Kick
            -- rising_sun_kick,cycle_targets=1,if=!talent.serenity.enabled|cooldown.serenity.remains>=5
            if not talent.serenity or cd.serenity.remain() >= 5 or not isChecked("Serenity") or not useCDs() then
                if BetterThanRSK == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                else
                    if cast.risingSunKick(spreadMark()) then return end
                end
            end
        -- Whirling Dragon Punch
            -- whirling_dragon_punch
            if cd.fistsOfFury.remain() ~= 0 and cd.risingSunKick.remain() ~= 0 and getDistance(units.dyn5) < 5 then
                if BetterThanWDP == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                elseif isChecked("Whirling Dragon Punch") then
                    if cast.whirlingDragonPunch() then return end
                end
            end
        -- Blackout Kick
            -- blackout_kick,cycle_targets=1,if=!prev_gcd.1.blackout_kick&chi.max-chi>=1&set_bonus.tier21_4pc&(!set_bonus.tier19_2pc|talent.serenity.enabled|buff.bok_proc.up)
            if chiMax - chi >= 1 and t21_4pc and (not t19_2pc or talent.serenity or buff.blackoutKick.exists()) then
                if BetterThanBOK == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                elseif lastCombo ~= spell.blackoutKick then
                    if cast.blackoutKick(spreadMark()) then return end
                end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick,if=(active_enemies>=3|(buff.bok_proc.up&chi.max-chi>=0))&!prev_gcd.1.spinning_crane_kick&set_bonus.tier21_4pc
            if (#enemies.yards8 >= 3 or (buff.blackoutKick.exists() and chiMax - chi >= 0)) and lastCombo ~= spell.spinningCraneKick and t21_4pc then
                if cast.spinningCraneKick() then return end
            end
        -- Crackling Jade Lightning
            -- crackling_jade_lightning,if=equipped.the_emperors_capacitor&buff.the_emperors_capacitor.stack>=19&energy.time_to_max>3
            -- crackling_jade_lightning,if=equipped.the_emperors_capacitor&buff.the_emperors_capacitor.stack>=14&cooldown.serenity.remains<13&talent.serenity.enabled&energy.time_to_max>3
            if ((hasEquiped(144239) and buff.theEmperorsCapacitor.stack() >= 19 and ttm > 3)
                or (hasEquiped(144239) and buff.theEmperorsCapacitor.stack() >= 14 and cd.serenity.remain() < 13 and talent.serenity and ttm > 3))
                and lastCombo ~= spell.cracklingJadeLightning 
            then
                if cast.cracklingJadeLightning() then return end
            end
        -- Spinning Crane Kick
            -- spinning_crane_kick,if=active_enemies>=3&!prev_gcd.1.spinning_crane_kick
            if #enemies.yards8 >= 3 and lastCombo ~= spell.spinningCraneKick then
                if cast.spinningCraneKick() then return end
            end
        -- Rushing Jade Wind
            -- rushing_jade_wind,if=chiMax-chi>1&!prev_gcd.rushing_jade_wind
            if chiMax - chi > 1 and lastCombo ~= spell.rushingJadeWind then
                if cast.rushingJadeWind() then return end
            end
        -- Blackout Kick
            -- blackout_kick,cycle_targets=1,if=(chi>1|buff.bok_proc.up|(talent.energizing_elixir.enabled&cooldown.energizing_elixir.remains<cooldown.fists_of_fury.remains))&((cooldown.rising_sun_kick.remains>1&(!artifact.strike_of_the_windlord.enabled().enabled|cooldown.strike_of_the_windlord.remains>1)|chi>2)&(cooldown.fists_of_fury.remains>1|chi>3)|prev_gcd.1.tiger_palm)&!prev_gcd.1.blackout_kick
            if (chi > 1 or buff.blackoutKick.exists() or (talent.energizingElixir and cd.energizingElixir.remain() < cd.fistsOfFury.remain())) 
                and ((cd.risingSunKick.remain() > 1 and (not artifact.strikeOfTheWindlord.enabled() or (cd.strikeOfTheWindlord.remain() > 1 and (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())))) or chi > 2) 
                    and (cd.fistsOfFury.remain() > 1 or chi > 3) or lastCombo == spell.tigerPalm)
            then
                if BetterThanBOK == true and lastCombo ~= spell.spinningCraneKick then
                    if cast.spinningCraneKick() then return end
                elseif lastCombo ~= spell.blackoutKick then
                    if cast.blackoutKick(spreadMark()) then return end
                end
            end
        -- Chi Wave
            -- chi_wave,if=energy.time_to_max>1
            if ttm > 1 and lastCombo ~= spell.chiWave then
                if cast.chiWave() then return end
            end
        -- Chi Burst
            -- chi_burst,if=energy.time_to_max>1
            if ttm > 1 and lastCombo ~= spell.chiBurst then
                if cast.chiBurst() then return end
            end
        -- Tiger Palm
            -- tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm&(chi.max-chi>=2|energy.time_to_max<1)
            if lastCombo ~= spell.tigerPalm and (chiMax - chi >= 2 or ttm < 1 or power > 50) then --and GetTime() >= SerenityTest + gcd and GetTime() >= TPEETimer + 0.2 then
                if cast.tigerPalm(spreadMark()) then TPEETimer = GetTime(); return end
            end
        -- Chi Wave
            -- chi_wave
            if lastCombo ~= spell.chiWave then
                if cast.chiWave() then return end
            end
        -- Chi Burst
            -- chi_burst
            if lastCombo ~= spell.chiBurst then
                if cast.chiBurst() then return end
            end
        end -- End Action List - Single Target
    -- Action List - Storm, Earth, and Fire
        function actionList_StormEarthAndFire()
            if (mode.sef == 2 or (mode.sef == 1 and useCDs())) then
        -- Tiger Palm
                -- tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm&energy=energy.max&chi<1
                if lastCombo ~= spell.tigerPalm and power == powerMax and chi < 1 and GetTime() >= TPEETimer + 0.2 then
                    if cast.tigerPalm(spreadMark()) then TPEETimer = GetTime(); return end
                end
        -- Racial - Arcane Torrent
                -- arcane_torrent,if=chi.max-chi>=1&energy.time_to_max>=0.5
                if chiMax >= chi and ttm >= 0.5 and isChecked("Racial") and race == "BloodElf" and getSpellCD(racial) == 0 then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Call Action List - Cooldowns
                -- call_action_list,name=cd
                if actionList_Cooldown() then return end
                if getDistance("target") < 5 then
        -- Storm, Earth, and Fire
                    -- storm_earth_and_fire,if=!buff.storm_earth_and_fire.up
                    if br.timer:useTimer("delaySEF1", gcd) and not buff.stormEarthAndFire.exists() then
                        if cast.stormEarthAndFire() then return end
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
        -- Tiger Palm
                -- tiger_palm,cycle_targets=1,if=!prev_gcd.1.tiger_palm&energy=energy.max&chi<1&!buff.serenity.up
                if lastCombo ~= spell.tigerPalm and power == powerMax and chi < 1 and not buff.serenity.exists() then
                    if cast.tigerPalm(spreadMark()) then TPEETimer = GetTime(); return end
                end
        -- Call Action List - Cooldowns
                -- call_action_list,name=cd
                if actionList_Cooldown() then return end
        -- Serenity
                -- serenity
                if getDistance("target") < 5 and GetTime() >= SerenityTest + gcd then
                    if cast.serenity() then SerenityTest = GetTime(); return end
                end
                if buff.serenity.exists() then
        -- Rising Sun Kick
                    -- rising_sun_kick,cycle_targets=1,if=active_enemies<3
                    if #enemies.yards5 < 3 and lastCombo ~= spell.risingSunKick then
                        if cast.risingSunKick(spreadMark()) then return end
                    end
        -- Strike of the Windlord
                    -- strike_of_the_windlord
                    if getDistance(units.dyn5) < 5 and lastCombo ~= spell.strikeOfTheWindlord and getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                        if cast.strikeOfTheWindlord() then return end
                    end
        -- Blackout Kick
                    -- blackout_kick,cycle_targets=1,if=(!prev_gcd.1.blackout_kick)&(prev_gcd.1.strike_of_the_windlord|prev_gcd.1.fists_of_fury)&active_enemies<2
                    if (lastSpell ~= spell.strikeOfTheWindlord or lastSpell ~= spell.fistsOfFury) and #enemies.yards5 < 2 then
                        if BetterThanBOK == true and lastCombo ~= spell.spinningCraneKick then
                            if cast.spinningCraneKick() then return end
                        elseif lastCombo ~= spell.blackoutKick then
                            if cast.blackoutKick(spreadMark()) then return end
                        end
                    end
        -- Fists of Fury
                    -- fists_of_fury,if=((equipped.drinking_horn_cover&buff.pressure_point.remains<=2&set_bonus.tier20_4pc)&(cooldown.rising_sun_kick.remains>1|active_enemies>1)),interrupt=1
                    if ((hasEquiped(137097) and buff.pressurePoint.remain() <= 2 and t20_4pc) and (cd.risingSunKick.remain() > 1 or #enemies.yards5 > 1)) then
                        if cast.fistsOfFury() then return end
                    end
                    -- fists_of_fury,if=((!equipped.drinking_horn_cover|buff.bloodlust.up|buff.serenity.remains<1)&(cooldown.rising_sun_kick.remains>1|active_enemies>1)),interrupt=1
                    if ((not hasEquiped(137097) or hasBloodLust() or buff.serenity.remain() < 1) and (cd.risingSunKick.remain() > 1 or #enemies.yards8 > 1)) and lastCombo ~= spell.fistsOfFury then
                        if cast.fistsOfFury() then return end
                    end
        -- Spinning Crane Kick
                    -- spinning_crane_kick,if=active_enemies>=3&!prev_gcd.spinning_crane_kick
                    if #enemies.yards8 >= 3 and lastCombo ~= spell.spinningCraneKick then
                        if cast.spinningCraneKick() then return end
                    end
        -- Rushing Jade Wind
                    -- rushing_jade_wind,if=!prev_gcd.1.rushing_jade_wind&buff.rushing_jade_wind.down&buff.serenity.remains>=4
                    if lastCombo ~= spell.rushingJadeWind and not buff.rushingJadeWind.exists() and buff.serenity.remain() >= 4 then
                        if cast.rushingJadeWind() then return end
                    end
        -- Rising Sun Kick
                    -- rising_sun_kick,cycle_targets=1,if=active_enemies>=3
                    if #enemies.yards5 >= 3 and lastCombo ~= spell.risingSunKick then
                        if cast.risingSunKick(spreadMark()) then return end
                    end
        -- Rushing Jade Wind
                    -- rushing_jade_wind,if=!prev_gcd.1.rushing_jade_wind&buff.rushing_jade_wind.down&active_enemies>1
                    if lastCombo ~= spell.rushingJadeWind and not buff.rushingJadeWind.exists() and #enemies.yards8 > 1 then
                        if cast.rushingJadeWind() then return end
                    end
        -- Spinning Crane Kick
                    --actions.serenity+=/spinning_crane_kick,if=!prev_gcd.1.spinning_crane_kick
                    if lastCombo ~= spell.spinningCraneKick then
                        if cast.spinningCraneKick() then return end
                    end
        -- Blackout Kick
                -- blackout_kick,cycle_targets=1,if=!prev_gcd.blackout_kick
                    if lastCombo ~= spell.blackoutKick then
                        if cast.blackoutKick(spreadMark()) then return end
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
                if isValidUnit("target") and getDistance("target") < 5 then
        -- Chi Burst
                -- chi_burst
                    if cast.chiBurst() then return end
        -- Chi Wave
                -- chi_wave
                    if cast.chiWave() then return end
        -- Start Attack
                -- auto_attack
                    if power > 50 then
                        if cast.tigerPalm("target") then StartAttack(); return end
                    else
                        StartAttack()
                    end
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
            if opener == true or not isChecked("Opener") or not isBoss("target") then
                if actionList_PreCombat() then return end
            end
-----------------------
--- Opener Rotation ---
-----------------------
            if opener == false and isChecked("Opener") and isBoss("target") then
                -- if isChecked("Pre-Pull Timer") and inCombat then
                --     opener = true;
                --     return
                -- end
                StartAttack()
                if actionList_Opener() then return end
            end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- FIGHT!
            if inCombat and profileStop==false and isValidUnit(units.dyn5) and (opener == true or not isChecked("Opener") or not isBoss("target")) and not isCastingSpell(spell.spinningCraneKick) then
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
                if getOptionValue("APL Mode") == 1 then -- --[[and cd.global.remain() <= getLatency()]] and GetTime() >= SEFTimer + getOptionValue("SEF Timer") then
        -- Potion
                    -- potion,name=old_war,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                    -- potion,name=prolonged_power,if=buff.serenity.up|buff.storm_earth_and_fire.up|(!talent.serenity.enabled&trinket.proc.agility.react)|buff.bloodlust.react|target.time_to_die<=60
                    if inRaid and isChecked("Potion") and useCDs() and getDistance("target") < 5 then
                        if buff.serenity.exists() or buff.stormEarthAndFire.exists() or hasBloodLust() or ttd <= 60 then
                            if canUse((127844)) and talent.serenity then
                                useItem(127844)
                            end
                            if canUse(142117) and talent.whirlingDragonPunch then
                                useItem(142117)
                            end
                        end
                    end
        -- Touch of Death
                    -- touch_of_death,if=target.time_to_die<=9
                    if useCDs() and isChecked("Touch of Death") and ttd <= 9 and lastCombo ~= spell.touchOfDeath then
                        if cast.touchOfDeath() then SerenityTest = GetTime(); return end
                    end
        -- Call Action List - Serenity
                    -- call_action_list,name=serenity,if=(talent.serenity.enabled&cooldown.serenity.remains<=0)|buff.serenity.up
                    if useCDs() and isChecked("Serenity") and ((talent.serenity and cd.serenity.remain() <= 0) or buff.serenity.exists()) then
                        if actionList_Serenity() then return end
                    end
        -- Call Action List - Storm, Earth, and Fire
                    -- call_action_list,name=sef,if=!talent.serenity.enabled&(buff.storm_earth_and_fire.up|cooldown.storm_earth_and_fire.charges=2)
                    if (mode.sef == 2 or (mode.sef == 1 and useCDs())) and not talent.serenity and (buff.stormEarthAndFire.exists() or charges.stormEarthAndFire.count() == 2) then
                        if actionList_StormEarthAndFire() then return end
                    end 
                    -- call_action_list,name=sef,if=!talent.serenity.enabled&equipped.drinking_horn_cover&(cooldown.strike_of_the_windlord.remains<=18&cooldown.fists_of_fury.remains<=12&chi>=3&cooldown.rising_sun_kick.remains<=1|target.time_to_die<=25|cooldown.touch_of_death.remains>112)&cooldown.storm_earth_and_fire.charges=1
                    if (mode.sef == 2 or (mode.sef == 1 and useCDs())) and not talent.serenity and hasEquiped(137097) and (cd.strikeOfTheWindlord.remain() <= 18 and cd.fistsOfFury.remain() <= 12 and chi >= 3 and cd.risingSunKick.remain() <= 1 or ttd <= 25 or cd.touchOfDeath.remain() > 112) and charges.stormEarthAndFire.count() == 1 then
                        if actionList_StormEarthAndFire() then return end
                    end
                    -- call_action_list,name=sef,if=!talent.serenity.enabled&!equipped.drinking_horn_cover&(cooldown.strike_of_the_windlord.remains<=14&cooldown.fists_of_fury.remains<=6&chi>=3&cooldown.rising_sun_kick.remains<=1|target.time_to_die<=15|cooldown.touch_of_death.remains>112)&cooldown.storm_earth_and_fire.charges=1
                    if (mode.sef == 2 or (mode.sef == 1 and useCDs())) and not talent.serenity and not hasEquiped(137097) and (cd.strikeOfTheWindlord.remain() <= 14 and cd.fistsOfFury.remain() <= 6 and chi >= 3 and cd.risingSunKick.remain() <= 1 or ttd <= 15 or cd.touchOfDeath.remain() > 112) and charges.stormEarthAndFire.count() == 1 then
                        if actionList_StormEarthAndFire() then return end
                    end
        -- Call Action List - Single Target
                    -- call_action_list,name=st
                    if actionList_SingleTarget() then return end
        -- Commenting this out for now, sub-optimal Chi usage
        -- Blackout Kick
                    -- 1 Chi and Last Spell == Tiger Palm catch
                    if chi == 1 and lastCombo ~= spell.blackoutKick then
                        if cast.blackoutKick() then return end
                    end
        -- Tiger Palm
                    -- Less than equal to 1 Chi and Last Spell == Blackout Kick
                    if (chi <= 1 and lastCombo ~= spell.tigerPalm) or buff.hitCombo.stack() == 0 then
                        if cast.tigerPalm() then return end
                    end
        -- Crackling Jade Lightning
                    if chi == 0 and lastCombo == spell.tigerPalm then
                        if cast.cracklingJadeLightning() then return end
                    end
                end -- End Simulation Craft APL
    ----------------------------
    --- APL Mode: AskMrRobot ---
    ----------------------------
                if getOptionValue("APL Mode") == 2 then
                    if useCDs() then
        -- Touch of Death
                        if not debuff.touchOfDeath.exists(units.dyn5) and lastCombo ~= spell.touchOfDeath then
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
        -- Potion
                        if canUse(109217) and inRaid and isChecked("Potion") and useCDs() and getDistance("target") < 5  then
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
                            if cd.fistsOfFury.remain() < 6 and cd.strikeOfTheWindlord.remain() < 5 and cd.whirlingDragonPunch.remain() < 5 then
                                if cast.serenity() then return end
                            end
                        end
        -- Energizing Elixir
                        -- if AlternatePower = 0 and Power < MaxPower and not HasBuff(Serenity)
                        if chi == 0 and power < powerMax and not buff.serenity.exists() then
                            if cast.energizingElixir() then return end
                        end
        -- Storm, Earth, and Fire
                        -- if not HasBuff(StormEarthAndFire) and CooldownSecRemaining(FistsOfFury) < 11 and CooldownSecRemaining(WhirlingDragonPunch) < 14 and CooldownSecRemaining(StrikeOfTheWindlord) < 14
                        if (mode.sef == 2 or (mode.sef == 1 and useCDs())) then
                            if br.timer:useTimer("delaySEF2", gcd) and not buff.stormEarthAndFire.exists() and cd.fistsOfFury.remain() < 11 and cd.whirlingDragonPunch.remain() < 14 and cd.strikeOfTheWindlord.remain() < 14 and getDistance("target") < 5 then
                                if cast.stormEarthAndFire() then return end
                            end
                        end
                    end -- End Cooldown Check
                    if useAoE() then
        -- Storm, Earth, and Fire
                        -- if not HasBuff(StormEarthAndFire) and CooldownSecRemaining(FistsOfFury) < 11 and CooldownSecRemaining(WhirlingDragonPunch) < 14 and CooldownSecRemaining(StrikeOfTheWindlord) < 14
                        if (mode.sef == 2 or (mode.sef == 1 and useCDs())) then
                            if br.timer:useTimer("delaySEF3", gcd) and not buff.stormEarthAndFire.exists() and cd.fistsOfFury.remain() < 11 and cd.whirlingDragonPunch.remain() < 14 and cd.strikeOfTheWindlord.remain() < 14 and getDistance("target") < 5 then
                                if cast.stormEarthAndFire() then return end
                            end
                        end
        -- Spinning Crane Kick
                        if lastCombo ~= spell.spinningCraneKick then
                            if cast.spinningCraneKick() then return end
                        end
                    end
        -- Fists of Fury
                    if lastCombo ~= spell.fistsOfFury then
                        if cast.fistsOfFury() then return end
                    end
        -- Whirling Dragon Punch
                    if isChecked("Whirling Dragon Punch") and getDistance(units.dyn5) < 5 and lastCombo ~= spell.whirlingDragonPunch then
                        if cast.whirlingDragonPunch() then return end
                    end
        -- Strike of the Windlord
                    if (((talent.serenity and cd.serenity.remain() > 20) or not isChecked("Serenity") or not useCDs()) or not talent.serenity) and getDistance(units.dyn5) < 5 and lastCombo ~= spell.strikeOfTheWindlord and getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                        if cast.strikeOfTheWindlord() then return end
                    end
        -- Tiger Palm
                    -- if not WasLastCast(TigerPalm) and AlternatePower < 4 and Power > (MaxPower*0.9)
                    if lastCombo ~= spell.tigerPalm and chi < 4 and power > (powerMax * 0.9) then
                        if cast.tigerPalm() then return end
                    end
        -- Rising Sun Kick
                    if lastCombo ~= spell.risingSunKick then
                        if cast.risingSunKick() then return end
                    end
        -- Rushing Jade Wind
                    -- if AlternatePower > 1 or HasBuff(Serenity)
                    if (chi > 1 or buff.serenity.exists()) and lastCombo ~= spell.rushingJadeWind then
                        if cast.rushingJadeWind() then return end
                    end
        -- Chi Burst
                    if lastCombo ~= spell.chiBurst then
                        if cast.chiBurst() then return end
                    end
        -- Chi Wave
                    if lastCombo ~= spell.chiWave then
                        if cast.chiWave() then return end
                    end
        -- Blackout Kick
                    -- if not WasLastCast(BlackoutKick) and (HasBuff(ComboBreaker) or AlternatePower > 1 or HasBuff(Serenity))
                    if lastCombo ~= spell.blackoutKick  and (buff.blackoutKick.exists() or chi > 1 or buff.serenity.exists()) then
                        if cast.blackoutKick() then return end
                    end
        -- Tiger Palm
                    -- if not WasLastCast(TigerPalm) or AlternatePower < 2
                    if lastCombo ~= spell.tigerPalm or chi < 2 then
                        if cast.tigerPalm() then return end
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

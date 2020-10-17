local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.shurikenStorm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.shurikenStorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.backstab },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.shadowBlades },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.shadowBlades },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.shadowBlades }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
    };
    CreateButton("Interrupt",4,0)
-- Cleave Button
    CleaveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.shurikenStorm },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.backstab }
    };
    CreateButton("Cleave",5,0)
    -- Shadow Dance Button
    ShadowDanceModes = {
        [1] = { mode = "On", value = 1 , overlay = "Shadow Dance Enabled", tip = "Rotation will use Shadow Dance.", highlight = 1, icon = br.player.spell.shadowDance },
        [2] = { mode = "Off", value = 2 , overlay = "Shadow Dance Disabled", tip = "Rotation will not use Shadow Dance. Useful for pooling SD charges as you near dungeon bosses.", highlight = 0, icon = br.player.spell.shadowDance },
        };
    CreateButton("ShadowDance",6,0)
-- Pick Pocket Button
    PickPocketModes = {
      [1] = { mode = "Auto", value = 1 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
      [2] = { mode = "Only", value = 2 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
      [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
    };
    CreateButton("PickPocket",7,0)
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
            -- Stealth
            br.ui:createDropdown(section,  "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
            -- Shadowstep
            br.ui:createCheckbox(section,  "Shadowstep")
            -- Opener
            br.ui:createCheckbox(section, "Opener")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Tricks of the Trade
            br.ui:createCheckbox(section, "Tricks of the Trade on Focus")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Agi Pot
            br.ui:createCheckbox(section, "Agi-Pot")
            -- Legendary Ring
            br.ui:createCheckbox(section, "Marked For Death - Precombat")
            -- Shadow Strike
            br.ui:createSpinnerWithout(section, "SS Range",  5,  5,  15,  1,  "|cffFFBB00Shadow Strike range, 5 = Melee")
            --Shuriken Toss OOR
            br.ui:createSpinner(section, "Shuriken Toss OOR",  85,  5,  100,  5,  "|cffFFBB00Check to use Shuriken Toss out of range and energy to use at.")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
            -- Shadow Blades
            br.ui:createDropdownWithout(section, "Shadow Blades",{"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"},2,"|cffFFFFFFWhen to use Shadow Blades.")
            -- Shadow Dance
            br.ui:createDropdownWithout(section, "Shadow Dance",{"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"},1,"|cffFFFFFFWhen to use Shadow Dance.")
            -- Shuriken Tornado
            br.ui:createDropdownWithout(section, "Shuriken Tornado",{"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"},1,"|cffFFFFFFWhen to use Shuriken Tornados.")
            -- Symbols of Death
            br.ui:createCheckbox(section, "Symbols of Death")
            -- Vanish
            br.ui:createCheckbox(section, "Vanish")
            -- NB TTD
            br.ui:createSpinner(section, "Nightblade Multidot", 8, 0, 16, 1, "|cffFFBB00Multidot Nightblade | Minimum TTD to use.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stone",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
           -- Cloak of Shadows
            br.ui:createCheckbox(section, "Cloak of Shadows")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Evasion
            br.ui:createSpinner(section, "Evasion",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Feint
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section, "Kick")
            -- Kidney Shot
            br.ui:createCheckbox(section, "Kidney Shot")
            -- Cheap Shot
            br.ui:createCheckbox(section, "Cheap Shot")
            -- Blind
            br.ui:createCheckbox(section, "Blind")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
            -- Cleave Toggle
            br.ui:createDropdown(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Pick Pocket Toggle
            br.ui:createDropdown(section,  "PickPocket Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
            -- Shadow Dance Toggle
            br.ui:createDropdown(section,  "ShadowDance Mode", br.dropOptions.Toggle,  6)
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
    -- if br.timer:useTimer("debugSubtlety", math.random(0.10,0.2)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Cleave",0.25)
        br.player.ui.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
        UpdateToggle("PickPocket",0.25)
        br.player.ui.mode.pickPocket = br.data.settings[br.selectedSpec].toggles["PickPocket"]
        UpdateToggle("ShadowDance",0.25)
        br.player.ui.mode.shadowDance = br.data.settings[br.selectedSpec].toggles["ShadowDance"]

--------------
--- Locals ---
--------------
        local buff                                                      = br.player.buff
        local cast                                                      = br.player.cast
        local cd                                                        = br.player.cd
        local charges                                                   = br.player.charges
        local combatTime                                                = getCombatTime()
        local combo, comboDeficit, comboMax                             = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local debuff                                                    = br.player.debuff
        local enemies                                                   = br.player.enemies
        local gcd                                                       = br.player.gcd
        local gcdMax                                                    = br.player.gcdMax
        local has                                                       = br.player.has
        local hastar                                                    = GetObjectExists("target")
        local healPot                                                   = getHealthPot()
        local inCombat                                                  = br.player.inCombat
        local mode                                                      = br.player.ui.mode
        local multidot                                                  = (br.player.ui.mode.cleave == 1 or br.player.ui.mode.rotation ~= 3)
        local php                                                       = br.player.health
        local power, powerDeficit, powerRegen                           = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
        local race                                                      = br.player.race
        local solo                                                      = #br.friend < 2
        local spell                                                     = br.player.spell
        local stealth                                                   = br.player.buff.stealth.exists()
        local stealthingAll                                             = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists() or br.player.buff.shadowDance.exists()
        local stealthingRogue                                           = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowDance.exists()
        local talent                                                    = br.player.talent
        local trait                                                     = br.player.traits
        local ttd                                                       = getTTD
        local units                                                     = br.player.units
	    local use                                                       = br.player.use

        units.get(5)
        units.get(30)

        enemies.get(5)
        enemies.get(10)
        enemies.get(10,"player",true)
        enemies.get(20)
        enemies.get(20,"player",true)
        enemies.get(30)

        if profileStop == nil then profileStop = false end

        -- Opener Variables
        -- if opener == nil then opener = false end
        if not inCombat and not GetObjectExists("target") then
            OPN1 = false
            SHB1 = false
            SHS1 = false
            NHB1 = false
            SOD1 = false
            SHD1 = false
            SHS2 = false
            SHS3 = false
            EVI1 = false
            SHS4 = false
            VAN1 = false
            SHS5 = false
            DFA1 = false
            SHD2 = false
            SHS6 = false
            SHS7 = false
            EVI2 = false
            opener = false
        end

        -- Numeric Returns
        if talent.darkShadow then darkShadow = 1 else darkShadow = 0 end
        if talent.deeperStratagem then deepStrat = 1 else deepStrat = 0 end
        if talent.deeperStratagem and buff.vanish.exists() then deepVanish = 1 else deepVanish = 0 end
        if combatTime < 10 then justStarted = 1 else justStarted = 0 end
        if talent.masterOfShadows then masterShadow = 1 else masterShadow = 0 end
        if talent.nightstalker then nightstalker = 1 else nightstalker = 0 end
        if not (talent.alacrity or talent.shadowFocus or talent.masterOfShadows) then notalent = 1 else notalent = 0 end
        if stealthingAll then stealthedAll = 1 else stealthedAll = 0 end
        if talent.subterfuge then subty = 1 else subty = 2 end
        if talent.vigor then vigorous = 1 else vigorous = 0 end
        if talent.secretTechnique then secretive = 1 else secretive = 0 end
        if talent.shadowFocus then focused = 1 else focused = 0 end
        if talent.alacrity then alacrity = 1 else alacrity = 0 end
        if #enemies.yards10 >= 3 then manyTargets = 1 else manyTargets = 0 end

        -- Timers
        if vanishTime == nil then vanishTime = GetTime() end
        if ShDCdTime == nil then ShDCdTime = GetTime() end
        if ShdMTime == nil then ShdMTime = GetTime() end

        -- SimC Specific Variables
        -- variable,name=stealth_threshold,value=25+talent.vigor.enabled*35+talent.master_of_shadows.enabled*25+talent.shadow_focus.enabled*20+talent.alacrity.enabled*10+15*(spell_targets.shuriken_storm>=3)
        local stealthThreshold = 25 + (vigorous * 35) + (masterShadow * 25) + (focused * 20) + (alacrity * 10) + (15 * manyTargets)
        -- variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=1.75
        local shdThreshold = charges.shadowDance.frac() >= 1.75


        -- Custom Functions
        local function timeSinceVanish()
            return GetTime() - vanishTime 
        end
        local function usePickPocket()
            if buff.stealth.exists() and not inCombat and (mode.pickPocket == 1 or mode.pickPocket == 2) then
                return true
            else
                return false
            end
        end
        local function isPicked(thisUnit)   --  Pick Pocket Testing
            if thisUnit == nil then thisUnit = "target" end
            if GetObjectExists(thisUnit) then
                if myTarget ~= UnitGUID(thisUnit) then
                    canPickpocket = true
                    myTarget = UnitGUID(thisUnit)
                end
            end
            if (canPickpocket == false or mode.pickPocket == 3 or GetNumLootItems()>0) and not isDummy() then
                return true
            else
                return false
            end
        end
        local function getPocketPicked()
            for i = 1, #enemies.yards10nc do
                local thisUnit = enemies.yards10nc[i]
                if (GetUnitIsUnit(thisUnit,"target") or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
                    if not isPicked(thisUnit) and not isDummy(thisUnit) then
                        if mode.pickPocket == 2 and debuff.sap.remain(thisUnit) < 1 then
                            if cast.sap(thisUnit) then return end
                        end
                        if cast.pickPocket(thisUnit) then return end
                    end
                end
            end
        end
        local function lowestTTD()
            local lowestUnit = "target"
            local lowestTTD = 999
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                local thisTTD = ttd(thisUnit) or 999
                if thisTTD > -1 and thisTTD < lowestTTD then
                    lowestUnit = thisUnit
                    lowestTTD = thisTTD
                end
            end
            return lowestUnit
        end
        local function autoStealth()
            for i = 1, #enemies.yards20nc do
                local thisUnit = enemies.yards20nc[i]
                if GetUnitReaction(thisUnit,"player") < 4 then return true end
            end
            return false
        end

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end
        -- Pick Pocket
            if usePickPocket() then
                getPocketPicked()
            end
        -- Tricks of the Trade
            if isChecked("Tricks of the Trade on Focus") and cast.able.tricksOfTheTrade("focus") and inCombat and UnitExists("focus") and GetUnitIsFriend("focus") then
                if cast.tricksOfTheTrade("focus") then return end
            end
        end -- End Action List - Extras
    -- Action List - Defensives
        local function actionList_Defensive()
            if useDefensive() and not stealth then
            -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") and not inCombat then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
        -- Pot/Stone
                if isChecked("Pot/Stone") and (use.able.healthstone() or canUseItem(healPot))
                    and php <= getOptionValue("Pot/Stone") and inCombat and (hasHealthPot() or has.healthstone())
                then
                    if use.able.healthstone() then
                        use.healthstone()
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
            -- Cloak of Shadows
                if isChecked("Cloak of Shadows") and canDispel("player",spell.cloakOfShadows) then
                    if cast.cloakOfShadows() then return end
                end
            -- Crimson Vial
                if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") and not buff.shadowDance.exists() then
                    if cast.crimsonVial() then return end
                end
            -- Evasion
                if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat then
                    if cast.evasion() then return end
                end
            -- Feint
                if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() and not buff.shadowDance.exists() then
                    if cast.feint() then return end
                end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() and not stealth then
                for i=1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
            -- Kick
                        -- kick
                        if isChecked("Kick") and distance < 5 then
                            if cast.kick(thisUnit) then return end
                        end
            -- Kidney Shot
                        if cd.kick.remain() ~= 0 and cd.blind.remain() == 0 then
                            if isChecked("Kidney Shot") then
                                if cast.kidneyShot(thisUnit) then return end
                            end
                        end
            -- Blind
                        if isChecked("Blind") and not buff.shadowDance.exists() and (cd.kick.remain() ~= 0 or distance >= 5) and not buff.shadowDance.exists() then
                            if cast.blind(thisUnit) then return end
                        end
                    end
            -- Cheap Shot
                        if isChecked("Cheap Shot") and buff.shadowDance.exists() and distance < 5 and cd.kick.remain() ~= 0 and cd.kidneyShot.remain() == 0 and cd.blind.remain() == 0 then
                            if cast.cheapShot(thisUnit) then return end
                        end
                end
            end -- End Interrupt and No Stealth Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            -- if useCDs() then Print("Cooldowns") end
            if getDistance(units.dyn5) < 5 then
        -- Potion
                -- potion,if=buff.bloodlust.react|target.time_to_die<=60|buff.symbols_of_death.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=10)
                if useCDs() and isChecked("Agi-Pot") and canUseItem(163223) and inRaid then
                    if hasBloodLust() or ttd(units.dyn5) <= 25 or (buff.symbolsOfDeath.exists() and (buff.shadowBlades.exists() or cd.shadowBlades.remain() <= 10)) then
                        useItem(163223)
                    end
                end
        -- Trinkets
                if useCDs() and isChecked("Trinkets") and (buff.shadowDance.exists() or buff.symbolsOfDeath.exists()) then
                    if canUseItem(13) and not (hasEquiped(140808, 13) or hasEquiped(151190, 13)) then
                        useItem(13)
                    end
                    if canUseItem(14) and not (hasEquiped(140808, 14) or hasEquiped(151190, 14)) then
                        useItem(14)
                    end
                end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury,if=buff.symbols_of_death.up
                -- berserking,if=buff.symbols_of_death.up
                -- fireblood,if=buff.symbols_of_death.up
                -- ancestral_call,if=buff.symbols_of_death.up
                if useCDs() and isChecked("Racial") and cast.able.racial() and buff.symbolsOfDeath.exists()
                    and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race == "MagharOrc")
                then
                    if cast.racial() then return end
                end
        -- Symbols of Death
                if isChecked("Symbols of Death") then
                    -- symbols_of_death,if=dot.nightblade.ticking
                    if cast.able.symbolsOfDeath() and (debuff.nightblade.exists(units.dyn5)) then
                        if cast.symbolsOfDeath() then return end
                    end
                end
        -- Marked For Death
                -- marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit|!stealthed.all&combo_points.deficit>=cp_max_spend)
                -- marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&!stealthed.all&combo_points.deficit>=cp_max_spend
                if isChecked("Marked For Death") and cast.able.markedForDeath() then
                    if getOptionValue("Marked For Death") == 1 then
                        if ttd("target") < comboDeficit or (not stealthingAll and comboDeficit >= comboMax) then
                            if cast.markedForDeath("target") then return end
                        end
                    end
                    if getOptionValue("Marked For Death") == 2 then
                        if ttd(lowestTTD()) < comboDeficit or (not stealthingAll and comboDeficit >= comboMax) then
                            if cast.markedForDeath(lowestTTD()) then return end
                        end
                    end
                end
        -- Shadow Blades
                -- shadow_blades,if=combo_points.deficit>=2+stealthed.all
                if (getOptionValue("Shadow Blades") == 1 or (getOptionValue("Shadow Blades") == 2 and useCDs())) and cast.able.shadowBlades() and (comboDeficit >= 2 + stealthedAll) then
                    if cast.shadowBlades() then return end
                end
        -- Shuriken Tornado
                -- shuriken_tornado,if=spell_targets>=3&dot.nightblade.ticking&buff.symbols_of_death.up&buff.shadow_dance.up
                if (getOptionValue("Shuriken Tornado") == 1 or (getOptionValue("Shuriken Tornado") == 2 and useCDs())) and cast.able.shurikenTornado()
                    and ((mode.rotation == 1 and #enemies.yards10 >= 3) or (mode.rotation == 2 and #enemies.yards10 > 0))
                    and debuff.nightblade.exists(units.dyn5) and buff.symbolsOfDeath.exists() and buff.shadowDance.exists()
                then
                    if cast.shurikenTornado() then return end
                end
        -- Shadow Dance
                -- shadow_dance,if=!buff.shadow_dance.up&target.time_to_die<=5+talent.subterfuge.enabled
                if mode.shadowDance == 1 and (getOptionValue("Shadow Dance") == 1 or (getOptionValue("Shadow Dance") == 2 and useCDs()))
                    and cast.able.shadowDance() and not cast.last.shadowDance() and (not buff.shadowDance.exists() and ttd(units.dyn5) <= 5 + subty)
                then
                    if cast.shadowDance() then ShDCdTime = GetTime(); return end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - Stealth Cooldowns
        local function actionList_StealthCooldowns()
            -- Print("Stealth Cooldowns")
            if getDistance(units.dyn5) < 5 then
        -- Vanish
                -- vanish,if=!variable.shd_threshold&debuff.find_weakness.remains<1&combo_points.deficit>1
                if useCDs() and isChecked("Vanish") and not solo and not cast.last.shadowmeld() and not buff.shadowmeld.exists() and not buff.shadowDance.exists() and gcd <= getLatency()*1.5 then
                    if cast.able.vanish() and (not shdThreshold and debuff.findWeakness.remain(units.dyn5) < 1 and comboDeficit > 1) then
                        cast.vanish();
                        vanishTime = GetTime();
                        StopAttack();
                        return
                    end
                end
        -- Shadowmeld
                -- pool_resource,for_next=1,extra_amount=40
                -- shadowmeld,if=energy>=40&energy.deficit>=10&!variable.shd_threshold&debuff.find_weakness.remains<1
                if useCDs() and isChecked("Racial") and not solo and race == "NightElf" and not cast.last.vanish() and not buff.vanish.exists() then
                    if (cast.pool.racial() or cast.able.racial()) and power >= 40
                        and powerDeficit >= 10 and not shdThreshold and debuff.findWeakness.remain(units.dyn5) < 1
                    then
                        if cast.pool.racial() then ChatOverlay("Pooling for Shadowmeld") end
                        if cast.able.racial() then
                            if cast.racial() then ShdMTime = GetTime(); return end
                        end
                    end
                end
        -- Shadow Dance
                -- shadow_dance,if=(!talent.dark_shadow.enabled|dot.nightblade.remains>=5+talent.subterfuge.enabled)&(variable.shd_threshold|buff.symbols_of_death.remains>=1.2|spell_targets.shuriken_storm>=4&cooldown.symbols_of_death.remains>10)
                -- shadow_dance,if=target.time_to_die<cooldown.symbols_of_death.remains
                if mode.shadowDance == 1 and (getOptionValue("Shadow Dance") == 1 or (getOptionValue("Shadow Dance") == 2 and useCDs()))
                    and cast.able.shadowDance() and not cast.last.shadowDance() and not buff.shadowDance.exists()
                then
                    if ((not talent.darkShadow or debuff.nightblade.remain(units.dyn5) >= 5 + subty)
                        and (shdThreshold or buff.symbolsOfDeath.remain() >= 1.2
                            or ((mode.rotation == 1 and #enemies.yards10 >= 4) or (mode.rotation == 2 and #enemies.yards10 > 0)) and cd.symbolsOfDeath.remain() > 10))
                    then
                        if cast.shadowDance() then ShDCdTime = GetTime(); return end
                    end
                    if (ttd(units.dyn5) < cd.symbolsOfDeath.remain()) then
                        if cast.shadowDance() then ShDCdTime = GetTime(); return end
                    end
                end
            end
        end
    -- Action List - Finishers
        local function actionList_Finishers()
            -- Print("Finishers")
        -- Eviscerate
            -- eviscerate,if=talent.shadow_focus.enabled&buff.nights_vengeance.up&spell_targets.shuriken_storm>=2+3*talent.secret_technique.enabled
            if cast.able.eviscerate() and (talent.shadowFocus and buff.nightsVengeance.exists() and #enemies.yards10 >= 2 + 3 * secretive) then
                if cast.eviscerate() then return end
            end
        -- Nightblade
            -- nightblade,if=(!talent.dark_shadow.enabled|!buff.shadow_dance.up)&target.time_to_die-remains>6&remains<tick_time*2&(spell_targets.shuriken_storm<4|!buff.symbols_of_death.up)
            if cast.able.nightblade() and ((not talent.darkShadow or not buff.shadowDance.exists()) and ttd(units.dyn5) - debuff.nightblade.remain(units.dyn5) > 6
                and debuff.nightblade.remain(units.dyn5) < 2 * 2 and (#enemies.yards10 < 4 or not buff.symbolsOfDeath.exists()))
            then
                if cast.nightblade() then return end
            end
            -- nightblade,cycle_targets=1,if=spell_targets.shuriken_storm>=2&(talent.secret_technique.enabled|azerite.nights_vengeance.enabled|spell_targets.shuriken_storm<=5)&!buff.shadow_dance.up&target.time_to_die>=(5+(2*combo_points))&refreshable
            if isChecked("Nightblade Multidot") and cast.able.nightblade() then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (GetUnitIsUnit(thisUnit,units.dyn10) and not multidot)) then
                        if (#enemies.yards10 >= 2 and (talent.secretTechnique or trait.nightsVengeance.active or #enemies.yards10 <= 5)
                            and not buff.shadowDance.exists() and ttd(thisUnit) >= (5 + (2 * combo)) and debuff.nightblade.refresh(thisUnit))
                        then
                            if cast.nightblade(thisUnit) then return end
                        end
                    end
                end
            end
            -- nightblade,if=remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
            if debuff.nightblade.remain(units.dyn5) < cd.symbolsOfDeath.remain() + 10 and cd.symbolsOfDeath.remain() <= 5
                and ttd(units.dyn5) - debuff.nightblade.remain(units.dyn5) > cd.symbolsOfDeath.remain() + 5
            then
                 if cast.nightblade(units.dyn5) then return end
            end
        -- Secret Technique
            -- secret_technique,if=buff.symbols_of_death.up&(!talent.dark_shadow.enabled|buff.shadow_dance.up)
            if cast.able.secretTechnique() and (buff.symbolsOfDeath.exists() and (not talent.darkShadow or buff.shadowDance.exists())) then
                if cast.secretTechnique() then return end
            end
            -- secret_technique,if=spell_targets.shuriken_storm>=2+talent.dark_shadow.enabled+talent.nightstalker.enabled
            if cast.able.secretTechnique() and (#enemies.yards10 >= 2 + darkShadow + nightstalker) then
                if cast.secretTechnique() then return end
            end
        -- Eviscerate
            -- eviscerate
            if cast.able.eviscerate() then
                if cast.eviscerate() then return end
            end
        end -- End Action List - Finishers
    -- Action List - Stealthed
        local function actionList_Stealthed()
            -- Print("Stealthed")
        -- Shadowstrike
            -- shadowstrike,if=buff.stealth.up
            if cast.able.shadowstrike() and (buff.stealth.exists()) then
                if cast.shadowstrike() then return end
            end
        -- Finisher
            -- call_action_list,name=finish,if=combo_points.deficit<=1-(talent.deeper_stratagem.enabled&buff.vanish.up)
            if comboDeficit <= 1 - deepVanish then
                if actionList_Finishers() then return end
            end
        -- Shuriken Toss
            -- shuriken_toss,if=buff.sharpened_blades.stack>=29
            if cast.able.shurikenToss() and (buff.sharpenedBlades.stack() >= 29) then
                if cast.shurikenToss() then return end
            end
        -- Shadowstrike
            -- shadowstrike,cycle_targets=1,if=talent.secret_technique.enabled&talent.find_weakness.enabled&debuff.find_weakness.remains<1&spell_targets.shuriken_storm=2&target.time_to_die-remains>6
            if cast.able.shadowstrike() and (talent.secretTechnique and talent.findWeakness
                and debuff.findWeakness.remain(units.dyn10) < 1 and #enemies.yards10 == 2 and ttd(units.dyn10) - debuff.findWeakness.remain(units.dyn10) > 6)
            then
                if cast.shadowstrike() then return end
            end
            -- shadowstrike,if=!talent.deeper_stratagem.enabled&azerite.blade_in_the_shadows.rank=3&spell_targets.shuriken_storm=3
            if cast.able.shadowstrike() and (not talent.deeperStratagem and trait.bladeInTheShadows.rank == 3 and #enemies.yards10 == 3) then
                if cast.shadowstrike() then return end
            end
        -- Shuriken Storm
            -- shuriken_storm,if=spell_targets.shuriken_storm>=3
            if cast.able.shurikenStorm() and ((mode.rotation == 1 and #enemies.yards10 >= 3) or (mode.rotation == 2 and #enemies.yards10 > 0)) then
                if cast.shurikenStorm() then return end
            end
        -- Shadowstrike
            -- shadowstrike
            if cast.able.shadowstrike() then
                if cast.shadowstrike() then return end
            end
        end
    -- Action List - Generators
        local function actionList_Generators()
            -- Print("Generator")
        -- Shuriken Toss
            -- shuriken_toss,if=!talent.nightstalker.enabled&(!talent.dark_shadow.enabled|cooldown.symbols_of_death.remains>10)&buff.sharpened_blades.stack>=29&spell_targets.shuriken_storm<=(3*azerite.sharpened_blades.rank)
            if cast.able.shurikenToss() and (not talent.nightstalker and (not talent.darkShadow or cd.symbolsOfDeath.remain() > 10)
                and buff.sharpenedBlades.stack() >= 29 and #enemies.yards10 <= (3 * trait.sharpenedBlades.rank))
            then
                if cast.shurikenToss() then return end
            end
        -- Shuriken Storm
            -- shuriken_storm,if=spell_targets.shuriken_storm>=2|buff.the_dreadlords_deceit.stack>=29
            if cast.able.shurikenStorm() and (((mode.rotation == 1 and #enemies.yards10 >= 2) or (mode.rotation == 2 and #enemies.yards10 > 0)) or buff.theDreadlordsDeceit.stack() >= 29) then
                if cast.shurikenStorm() then return end
            end
        -- Backstab / Gloomblade
            -- gloomblade
            if cast.able.gloomblade() and talent.gloomblade and not stealthingRogue and timeSinceVanish() > 0.5 then
                if cast.gloomblade() then return end
            end
            -- backstab
            if cast.able.backstab() and not talent.gloomblade and not stealthingRogue and timeSinceVanish() > 0.5 then
                if cast.backstab() then return end
            end
        end -- End Action List - Generators
    -- Action List - PreCombat
        local function actionList_PreCombat()
            if not inCombat and not (IsFlying() or IsMounted()) then
        -- Stealth
                -- stealth
                if isChecked("Stealth") and cast.able.stealth() and (not IsResting() or isDummy("target")) and not stealth then
                    if getOptionValue("Stealth") == 1 then
                        if cast.stealth() then return end
                    end
                    if autoStealth() and getOptionValue("Stealth") == 3 then
                        if cast.stealth() then return end
                    end
                end
                if isValidUnit("target") and mode.pickPocket ~= 2 then
        -- Potion
                    -- potion
                    if stealth then
                        if useCDs() and isChecked("Potion") and inRaid then
                            if canUseItem(127844) then
                                useItem(127844)
                            elseif canUseItem(142117) then
                                useItem(142117)
                            end
                        end
                    end
        -- Marked For Death
                    -- marked_for_death,if=raid_event.adds.in>40
                    if isChecked("Marked For Death - Precombat") and cast.able.markedForDeath("target") and combo <= 1 then
                        if cast.markedForDeath("target") then return end
                    end
        -- Shadowstep
                    if isChecked("Shadowstep") and cast.able.shadowstep("target") and (not stealthingAll or power < 40 or getDistance("target") > getOptionValue("SS Range"))
                        and (getDistance("target") >= 10 or getDistance("target") > getOptionValue("SS Range"))
                    then
                        if cast.shadowstep("target") then return end
                    end
        -- Shadowstrike
                    if cast.able.shadowstrike("target") and (not isChecked("Shadowstep") or stealthingAll)
                        and getDistance("target") <= getOptionValue("SS Range") and (isPicked("target") or not usePickPocket())
                    then
                        getPocketPicked()
                        if cast.shadowstrike("target") then return end
                    end
        -- Start Attack
                    if not cast.last.vanish() and getDistance("target") < 5 and (not buff.stealth.exists() or not buff.vanish.exists() or not buff.shadowmeld.exists()) then
                        StartAttack()
                    end
                end
            end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    --Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
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
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) then
------------------------------
--- In Combat - Interrupts ---
------------------------------
                if actionList_Interrupts() then return end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
        -- Shadowstep
                if isChecked("Shadowstep") and cast.able.shadowstep() and getDistance("target") >= 8 then
                    if cast.shadowstep("target") then return end
                end
        -- Shuriken Toss
                if isChecked("Shuriken Toss OOR") and cast.able.shurikenToss() and power >= getOptionValue("Shuriken Toss OOR") and getDistance(units.dyn30) > 8 and hasThreat(units.dyn30) and not stealthingAll then
                    if cast.shurikenToss() then return end
                end
                if getDistance(units.dyn5) < 5 then
        -- Cooldowns
                    -- call_action_list,name=cds
                    if actionList_Cooldowns() then return end
        -- Stealthed
                    -- run_action_list,name=stealthed,if=stealthed.all
                    if stealthingAll then
                        if actionList_Stealthed() then return end
                    end
        -- Auto Attack
                    -- auto_attack
                    if not cast.last.vanish() and (not buff.stealth.exists() or not buff.vanish.exists() or not buff.shadowmeld.exists()) and not IsAutoRepeatSpell(GetSpellInfo(6603)) and getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
        -- Nightblade
                    -- nightblade,if=target.time_to_die>6&remains<gcd.max&combo_points>=4-(time<10)*2
                    if cast.able.nightblade() and ttd(units.dyn5) > 6 and debuff.nightblade.remain(units.dyn5) < gcdMax and combo >= 4 - (justStarted * 2) then
                        if cast.nightblade() then return end
                    end
        -- Stealth Cooldowns
                    -- call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&(talent.dark_shadow.enabled&cooldown.secret_technique.up|combo_points.deficit>=4)
                    if powerDeficit <= stealthThreshold and (talent.darkShadow and cd.secretTechnique.remain() == 0 or comboDeficit >= 4) then
                        if actionList_StealthCooldowns() then return end
                    end
        -- Finishers
                    -- call_action_list,name=finish,if=combo_points.deficit<=1|target.time_to_die<=1&combo_points>=3
                    if comboDeficit <= 1 or ttd(units.dyn5) <= 1 and combo >= 3 then
                        if actionList_Finishers() then return end
                    end
                    -- call_action_list,name=finish,if=spell_targets.shuriken_storm=4&combo_points>=4
                    if #enemies.yards10 == 4 and combo >= 4 then
                        if actionList_Finishers() then return end
                    end
        -- Generators
                    -- call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
                    if powerDeficit <= stealthThreshold then
                        if actionList_Generators() then return end
                    end
        -- Racials
                    -- arcane_torrent,if=energy.deficit>=15+energy.regen
                    -- arcane_pulse
                    -- lights_judgment
                    if useCDs() and isChecked("Racial") and cast.able.racial() and not buff.shadowDance.exists()
                        and ((race == "BloodElf" and powerDeficit >= 15 + powerRegen) or race == "Nightborne" or race == "LightforgedDraenei")
                    then
                        if race == "LightforgedDraenei" then
                            if cast.racial("target","ground") then return true end
                        else
                            if cast.racial("player") then return true end
                        end
                    end
                end
            end -- End In Combat
        end -- End Profile
    -- end -- Timer
end -- runRotation
local id = 261
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

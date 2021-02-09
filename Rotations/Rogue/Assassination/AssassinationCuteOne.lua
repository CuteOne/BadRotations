local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.fanOfKnives },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.fanOfKnives },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mutilate },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.vendetta },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.vendetta },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.vendetta }
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
        [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.fanOfKnives },
        [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.mutilate }
    };
    CreateButton("Cleave",5,0)
-- Pick Pocket Button
    PickerModes = {
      [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
      [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
      [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
    };
    CreateButton("Picker",6,0)
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
            -- Opening Attack
            br.ui:createDropdown(section, "Stealth Breaker", {"Garrote", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
            -- Fna of Knives
            br.ui:createSpinnerWithout(section, "Fan of Knives", 2, 1, 10, 1, "|cffFFFFFFMinimal Enemies to use Fan of Knives on")
            -- Poison
            br.ui:createDropdownWithout(section, "Lethal Poison", {"Deadly","Wound","None"}, 1, "Lethal Poison to Apply")
            br.ui:createDropdownWithout(section, "Non-Lethal Poison", {"Crippling","None"}, 1, "Non-Lethal Poison to Apply")
            -- Poisoned Knife
            br.ui:createCheckbox(section, "Poisoned Knife")
            -- Stealth
            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
            -- Shadowstep
            br.ui:createCheckbox(section, "Shadowstep")
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
            -- Potion
            br.ui:createCheckbox(section, "Potion")
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF001st Only","|cff00FF002nd Only","|cffFFFF00Both","|cffFF0000None"}, 1, "|cffFFFFFFSelect Trinket Usage.")
            -- Exsanguinate
            br.ui:createDropdownWithout(section, "Exsanguinate", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Exsanguinate.")
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
            -- Toxic Blade
            br.ui:createDropdownWithout(section, "Toxic Blade", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Toxic Blade.")
            -- Vanish
            br.ui:createCheckbox(section, "Vanish")
            -- Vendetta
            br.ui:createDropdownWithout(section,"Vendetta", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Vendetta.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Evasion
            br.ui:createSpinner(section, "Evasion",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!",  "|cffFFFFFFHealth Percent to Cast At")
            -- Feint
            br.ui:createSpinner(section, "Feint", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Cloak of Shadows
            br.ui:createCheckbox(section, "Cloak of Shadows")
            -- Crimson Vial
            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Kick
            br.ui:createCheckbox(section,"Kick")
            -- Kidney Shot
            br.ui:createCheckbox(section,"Kidney Shot")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdown(section, "Cleave Mode", br.dropOptions.Toggle,  6)
            -- Pick Pocket Toggle
            br.ui:createDropdown(section, "Pick Pocket Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
    -- if br.timer:useTimer("debugAssassination", math.random(0.15,0.3)) then
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
        UpdateToggle("Picker",0.25)
        br.player.ui.mode.pickPocket = br.data.settings[br.selectedSpec].toggles["Picker"]

--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local cd                                            = br.player.cd
        local comboPoints, comboDeficit, comboMax           = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local combatTime                                    = getCombatTime()
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local energy, energyDeficit, energyRegen            = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
        local exsanguinated                                 = exsanguinated
        local gcd                                           = br.player.gcd
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local level                                         = br.player.level
        local mode                                          = br.player.ui.mode
        local multidot                                      = br.player.ui.mode.cleave == 1
        local php                                           = br.player.health
        local race                                          = br.player.race
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.stealth.exists()
        local stealthedRogue                                = br.player.buff.stealth.exists() or br.player.buff.vanish.exists()
        local stealthingAll                                 = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()
        local talent                                        = br.player.talent
        local trait                                         = br.player.traits
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.energy.ttm()
        local units                                         = br.player.units

        units.get(5)
        enemies.get(5)
        enemies.get(8)
        enemies.get(10)
        enemies.get(20,"player",true)
        enemies.get(30)

        if profileStop == nil then profileStop = false end
        if opener == nil then opener = false end
        if not inCombat and not GetObjectExists("target") and not cast.last.vanish() and not cast.last.shadowmeld() then
            OPN1 = false
            GAR1 = false
            MUT1 = false
            RUP1 = false
            VEN1 = false
            TOX1 = false
            KIN1 = false
            VAN1 = false
            ENV1 = false
            MUT2 = false
            GAR2 = false
            ENV2 = false
            opener = false
        end

        if rotationDebug == nil or (not inCombat and not UnitExists("target")) then rotationDebug = "Waiting" end

        tickTime = 2 / (1 + (GetHaste()/100))

        -- Variables
        -- variable,name=energy_regen_combined,value=energy.regen+poisoned_bleeds*7%(2*spell_haste)
        local energyRegenCombined = energyRegen + (debuff.garrote.count() + debuff.rupture.count()) * 7 / (2 * (GetHaste()/100))
        -- variable,name=single_target,value=spell_targets.fan_of_knives<2
        local singleTarget = ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Fan of Knives")) or (mode.rotation == 3 and #enemies.yards8 > 0))
        -- variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target
        local useFiller = comboDeficit > 1 or energyDeficit <= 25 + energyRegenCombined or not singleTarget

        -- Exsanguinated Bleeds
        if not debuff.rupture.exists(units.dyn5) then exRupture = false end
        if not debuff.garrote.exists(units.dyn5) then exGarrote = false end
        if not debuff.internalBleeding.exists(units.dyn5) then exInternalBleeding = false end
        if not debuff.crimsonTempest.exists(units.dyn5) then exCrimsonTempest = false end
        if cast.last.exsanguinate() then exsanguinateCast = true else exsanguinateCast = false end
        if exsanguinateCast and debuff.rupture.exists(units.dyn5) then exRupture = true end
        if exsanguinateCast and debuff.garrote.exists(units.dyn5) then exGarrote = true end
        if exsanguinateCast and debuff.internalBleeding.exists(units.dyn5) then exInternalBleeding = true end
        if exsanguinateCast and debuff.crimsonTempest.exists(units.dyn5) then exCrimsonTempest = true end
        if exRupture or exGarrote or exInternalBleeding or exCrimsonTempest then exsanguinated = true else exsanguinated = false end

        -- Master Assassin
        if masterAssassinRemain == nil then masterAssassinRemain = 0 end
        if not talent.masterAssassin or (not buff.stealth.exists() and masterAssassinTimer == nil) then masterAssassinTimer = GetTime() end
        if talent.masterAssassin and buff.stealth.exists() then masterAssassinTimer = GetTime() + 3 end
        masterAssassinRemain = masterAssassinTimer - GetTime()

        -- Numeric Returns
        if talent.deeperStratagem then deepStrat = 1 else deepStrat = 0 end
        if trait.shroudedSuffocation.active then suffocated = 1 else suffocated = 0 end
        if stealthedRogue then stealthed = 1 else stealthed = 0 end
        if #enemies.yards10 >= 5 then manyTargets = 1 else manyTargets = 0 end

        -- Custom Functions
        local function usePickPocket()
            if (mode.pickPocket == 1 or mode.pickPocket == 2) and buff.stealth.exists() and level > 13 then
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
            if (canPickpocket == false or br.player.ui.mode.pickPocket == 3 or GetNumLootItems()>0) and not isDummy() then
                return true
            else
                return false
            end
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
                    if combatTime >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end
        -- Pick Pocket
            if usePickPocket() and cast.able.pickPocket() then
                if (isValidUnit(units.dyn5) or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
                    if not isPicked(units.dyn5) and not isDummy(units.dyn5) then
                        if debuff.sap.remain(units.dyn5) < 1 and mode.pickPocket ~= 1 then
                            if cast.sap(units.dyn5) then return end
                        end
                        if cast.last.vanish() then
                            if cast.pickPocket() then return end
                        end
                    end
                end
            end
        -- Poisoned Knife
            if isChecked("Poisoned Knife") and cast.able.poisonedKnife() and inCombat and not buff.stealth.exists() and not (IsMounted() or IsFlying()) then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    local distance = getDistance(thisUnit)
                    if not (debuff.deadlyPoison.exists(thisUnit) or debuff.woundPoison.exists(thisUnit)) and distance > 8 then
                        if cast.poisonedKnife(thisUnit) then return end
                    end
                end
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
            -- Pot/Stoned
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and (hasHealthPot() or hasItem(5512)) then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    end
                end
            -- Cloak of Shadows
                if isChecked("Cloak of Shadows") and cast.able.cloakOfShadows() and canDispel("player",spell.cloakOfShadows) then
                    if cast.cloakOfShadows() then return end
                end
            -- Crimson Vial
                if isChecked("Crimson Vial") and cast.able.crimsonVial() and php < getOptionValue("Crimson Vial") then
                    if cast.crimsonVial() then return end
                end
            -- Evasion
                if isChecked("Evasion") and cast.able.evasion() and php < getOptionValue("Evasion") and inCombat then
                    if cast.evasion() then return end
                end
            -- Feint
                if isChecked("Feint") and cast.able.feint() and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() then
                    if cast.feint() then return end
                end
            end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() and not stealth then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
            -- Kick
                        -- kick
                        if isChecked("Kick") and cast.able.kick() then
                            if cast.kick(thisUnit) then return end
                        end
            -- Kidney Shot
                        if isChecked("Kidney Shot") and cast.able.kidneyShot() and cd.kick.remain() ~= 0 then
                            if cast.kidneyShot(thisUnit) then return end
                        end
                    end
                end
            end -- End Interrupt and No Stealth Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            rotationDebug = "Cooldowns"
            if getDistance(units.dyn5) < 5 then
        -- Potion
                -- potion,if=buff.bloodlust.react|target.time_to_die<=60|debuff.vendetta.up&cooldown.vanish.remains<5
                if isChecked("Potion") and (useCDs() or burst) and canUseItem(142117) then
                    if hasBloodLust() or ttd("target") <= 60 or debuff.vendetta.exists("target") and cd.vanish.remain() < 5 then
                        useItem(142117)
                    end
                end
        -- Trinket
                if getOptionValue("Trinkets") ~= 4 then
                    -- use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
                    if (cd.vendetta.remain() <= 1 and (not talent.subterfuge or debuff.garrote.applied(units.dyn5) > 1)) or cd.vendetta.remain() > 45 then
                        -- Use Gale Caller's Boon
                    end
                    if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUseItem(13) and not hasEquiped(140808, 13) then
                        useItem(13)
                    end
                    if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUseItem(14) and not hasEquiped(140808, 14) then
                        useItem(14)
                    end
                end
        -- Racial
                -- blood_fury,if=debuff.vendetta.up
                -- berserking,if=debuff.vendetta.up
                -- fireblood,if=debuff.vendetta.up
                -- ancestral_call,if=debuff.vendetta.up
                if isChecked("Racial") and cast.able.racial() and (debuff.vendetta.exists(units.dyn5)
                    and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race == "MagharOrc"))
                then
                    if cast.racial() then return end
                end
        -- Marked For Death
                -- marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit*1.5|combo_points.deficit>=cp_max_spend)
                -- marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
                if isChecked("Marked For Death") then
                    if getOptionValue("Marked For Death") == 1 then
                        if ttd(units.dyn5) < comboDeficit * 1.5 or comboDeficit >= comboMax then
                            if cast.markedForDeath() then return end
                        end
                    end
                    if getOptionValue("Marked For Death") == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if (multidot or (GetUnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                                if ttd(thisUnit) < comboDeficit * 1.5 or comboDeficit >= comboMax then
                                    if cast.markedForDeath(thisUnit) then return end
                                end
                            end
                        end
                    end
                end
        -- Vendetta
                -- vendetta,if=!stealthed.rogue&dot.rupture.ticking&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier>1)
                if getOptionValue("Vendetta") == 1 or (getOptionValue("Vendetta") == 2 and useCDs()) then
                    if cast.able.vendetta() and (not stealthedRogue and debuff.rupture.exists(units.dyn5)
                        and (not talent.subterfuge or not trait.shroudedSuffocation.active or debuff.garrote.applied(units.dyn5) > 1))
                    then
                        if cast.vendetta() then return end
                    end
                end
        -- Vanish
                if isChecked("Vanish") and (useCDs() or burst) and gcd == 0 and not solo then
                    -- vanish,if=talent.subterfuge.enabled&!dot.garrote.ticking&variable.single_target
                    if cast.able.vanish() and (talent.subterfuge and not debuff.garrote.exists(units.dyn5) and singleTarget) then
                        if cast.vanish() then StopAttack(); return end
                    end
                    -- vanish,if=talent.exsanguinate.enabled&(talent.nightstalker.enabled|talent.subterfuge.enabled&variable.single_target)&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier<=1)
                    if cast.able.vanish() and (talent.exsanguinate and (talent.nightstalker or talent.subterfuge and singleTarget) and comboPoints >= comboMax
                        and cd.exsanguinate.remain() < 1 and (not talent.subterfuge or not trait.shroudedSuffocation.active or debuff.garrote.applied(units.dyn5) <= 1))
                    then
                        if cast.vanish() then StopAttack(); return end
                    end
                    -- vanish,if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&combo_points>=cp_max_spend&debuff.vendetta.up
                    if cast.able.vanish() and (talent.nightstalker and not talent.exsanguinate and comboPoints >= comboMax and debuff.vendetta.exists(units.dyn5)) then
                        if cast.vanish() then StopAttack(); return end
                    end
                    -- vanish,if=talent.subterfuge.enabled&(!talent.exsanguinate.enabled|!variable.single_target)&!stealthed.rogue&cooldown.garrote.up&dot.garrote.refreshable&(spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives|spell_targets.fan_of_knives>=4&combo_points.deficit>=4)
                    if cast.able.vanish() and (talent.subterfuge and (not talent.exsanguinate or not singleTarget)
                        and not stealthedRogue and not cd.garrote.exists() and debuff.garrote.refresh(units.dyn5)
                        and (#enemies.yards8 <= getOptionValue("Fan of Knives") and comboDeficit >= 1 + getOptionValue("Fan of Knives")
                        or #enemies.yards8 >= getOptionValue("Fan of Knives") and comboDeficit >= 4))
                    then
                        if cast.vanish() then StopAttack(); return end
                    end
                    -- vanish,if=talent.master_assassin.enabled&!stealthed.all&master_assassin_remains<=0&!dot.rupture.refreshable
                    if cast.able.vanish() and (talent.masterAssassin and not stealthingAll and masterAssassinRemain <= 0 and not debuff.rupture.refresh(units.dyn8)) then
                        if cast.vanish() then StopAttack(); return end
                    end
                end
        -- Exsanguinate
                -- exsanguinate,if=dot.rupture.remains>4+4*cp_max_spend&!dot.garrote.refreshable
                if getOptionValue("Exsanguinate") == 1 or (getOptionValue("Exsanguinate") == 2 and useCDs()) or burst then
                    if cast.able.exsanguinate() and (debuff.rupture.remain(units.dyn5) > 4
                        + (4 * comboMax) and not debuff.garrote.refresh(units.dyn5))
                    then
                        if cast.exsanguinate() then return end
                    end
                end
        -- Toxic Blade
                -- toxic_blade,if=dot.rupture.ticking
                if getOptionValue("Toxic Blade") == 1 or (getOptionValue("Toxic Blade") == 2 and useCDs()) or burst then
                    if cast.able.toxicBlade() and (debuff.rupture.exists(units.dyn5)) then
                        if cast.toxicBlade() then return end
                    end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - Stealthed
        local function actionList_Stealthed()
            rotationDebug = "Stealthed"
        -- Rupture
            -- rupture,if=combo_points>=4&(talent.nightstalker.enabled|talent.subterfuge.enabled&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<=2&variable.single_target|!ticking)&target.time_to_die-remains>6
            if cast.able.rupture() and (comboPoints >= 4 and (talent.nightstalker or talent.subterfuge and talent.exsanguinate
                and cd.exsanguinate.remain() <= 2 and singleTarget or not debuff.rupture.exists(units.dyn5)) and ttd(units.dyn5) - debuff.rupture.remain(units.dyn5) > 6)
            then
                if cast.rupture() then return end
            end
        -- Envenom
            -- envenom,if=combo_points>=cp_max_spend
            if cast.able.envenom() and (comboPoints >= comboMax) then
                if cast.envenom() then return end
            end
        -- Garrote
            if cast.able.garrote() then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    -- garrote,cycle_targets=1,if=talent.subterfuge.enabled&refreshable&target.time_to_die-remains>2
                    -- garrote,cycle_targets=1,if=talent.subterfuge.enabled&remains<=10&pmultiplier<=1&target.time_to_die-remains>2
                    if talent.subterfuge and ttd(thisUnit) - debuff.garrote.remain(thisUnit) > 2 then
                        if (debuff.garrote.refresh(thisUnit) or (debuff.garrote.remain(thisUnit) <= 10 and debuff.garrote.applied(thisUnit) <= 1)) then
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
        -- Rupture
            -- rupture,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&!dot.rupture.ticking
            if cast.able.rupture() and (talent.subterfuge and trait.shroudedSuffocation.active and not debuff.rupture.exists(units.dyn5)) then
                if cast.rupture() then return end
            end
        -- Garrote
            -- garrote,cycle_targets=1,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&target.time_to_die>remains
            if cast.able.garrote() then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (talent.subterfuge and trait.shroudedSuffocation.active and ttd(thisUnit) > debuff.garrote.remain(thisUnit)) then
                        if cast.garrote(thisUnit) then return end
                    end
                end
            end
            -- pool_resource,for_next=1
            if cast.pool.garrote() then ChatOverlay("Pooling For Garrote - Stealthed") return true end
            -- garrote,if=talent.subterfuge.enabled&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&prev_gcd.1.rupture&dot.rupture.remains>5+4*cp_max_spend
            if cast.able.garrote() and (talent.subterfuge and talent.exsanguinate
                and cd.exsanguinate.remain() < 1 and cast.last.rupture(1) and debuff.rupture.remain() > 5 + 4 * comboMax)
            then
                if cast.garrote() then return end
            end
        end -- End Action List - Stealthed
    -- Action List - Dot
        local function actionList_Dot()
            rotationDebug = "Dot"
        -- Rupture
            -- rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2)))
            if cast.able.rupture() and (talent.exsanguinate and ((comboPoints >= comboMax and cd.exsanguinate.remain() < 1)
                or (not debuff.rupture.exists(units.dyn5) and (combatTime > 10 or comboPoints >= 2))))
            then
                if cast.rupture() then return end
            end
        -- Garrote
            -- pool_resource,for_next=1
            if cast.pool.garrote() then ChatOverlay("Pooling For Garrote - Dot") return true end
            -- garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1&refreshable
                -- &(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)
                -- &(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)
                -- &(target.time_to_die-remains>4&spell_targets.fan_of_knives<=1|target.time_to_die-remains>12)
            if cast.able.garrote() then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if ((not talent.subterfuge or not (cd.vanish.remain() == 0
                        and (cd.vendetta.remain() <= 4 and (getOptionValue("Vendetta") == 1 or (getOptionValue("Vedetta") == 2 and useCDs())))))
                        and comboDeficit >= 1 and debuff.garrote.refresh(thisUnit)
                        and (debuff.garrote.applied(thisUnit) <= 1 or debuff.garrote.remain(thisUnit) <= tickTime and #enemies.yards8 >= 3 + suffocated)
                        and (not exGarrote or debuff.garrote.remain(thisUnit) <= tickTime * 2 and #enemies.yards8 >= 3 + suffocated)
                        and (ttd(thisUnit) - debuff.garrote.remain(thisUnit) > 4 and #enemies.yards8 <= 1 or ttd(thisUnit) - debuff.garrote.remain(thisUnit) > 12))
                    then
                        if cast.garrote(thisUnit) then return end
                    end
                end
            end
        -- Crimson Tempest
            -- crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4
            if cast.able.crimsonTempest() and (#enemies.yards10 >= 2 and debuff.crimsonTempest.remain(units.dyn5) < 2 + manyTargets and comboPoints >= 4) then
                if cast.crimsonTempest() then return end
            end
        -- Rupture
            -- rupture,cycle_targets=1,if=combo_points>=4&refreshable
                -- &(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)
                -- &(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)
                -- &target.time_to_die-remains>4
            if cast.able.rupture() then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (comboPoints >= 4 and debuff.rupture.refresh(thisUnit)
                        and (debuff.rupture.applied(thisUnit) <= 1 or debuff.rupture.remain(thisUnit) <= tickTime and #enemies.yards8 >= getOptionValue("Fan of Knives") + suffocated)
                        and (not exRupture or debuff.rupture.remain(thisUnit) <= tickTime * 2 and #enemies.yards8 >= getOptionValue("Fan of Knives") + suffocated)
                        and ttd(thisUnit) - debuff.rupture.remain(thisUnit) > 4)
                    then
                        if cast.rupture(thisUnit) then return end
                    end
                end
            end
        end -- End Action List - Dot
    -- Action List - Direct
        local function actionList_Direct()
            rotationDebug = "Direct"
        -- Envenom
            -- envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
            if cast.able.envenom() and (comboPoints >= 4 + deepStrat and (debuff.vendetta.exists()
                or debuff.toxicBlade.exists() or energyDeficit <= 25 + energyRegenCombined or not singleTarget)
                and (not talent.exsanguinate or cd.exsanguinate.remain() > 2))
            then
                if cast.envenom() then return end
            end
        -- Poisoned Knife
            -- poisoned_knife,if=variable.use_filler&buff.sharpened_blades.stack>=29
            if isChecked("Poisoned Knife") and cast.able.poisonedKnife() and (useFiller and buff.sharpenedBlades.stack() >= 29) then
                if cast.poisonedKnife() then return end
            end
        -- Fan of Knives
            -- fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|spell_targets.fan_of_knives>=2+stealthed.rogue|buff.the_dreadlords_deceit.stack>=29)
            if cast.able.fanOfKnives() and (useFiller and (buff.hiddenBlades.stack() >= 19
                or ((mode.rotation == 1 and #enemies.yards8 >= getOptionValue("Fan of Knives") + stealthed) or (mode.rotation == 2 and #enemies.yards8 > 0))
                or buff.theDreadlordsDeceit.stack() >= 29))
            then
                if cast.fanOfKnives() then return end
            end
        -- Blindside
            -- blindside,if=variable.use_filler&(buff.blindside.up|!talent.venom_rush.enabled)
            if cast.able.blindside() and (useFiller and (buff.blindside.exists() or not talent.venomRush)) then
                if cast.blindside() then return end
            end
        -- Mutilate
            -- mutilate,if=variable.use_filler
            if cast.able.mutilate() and (useFiller) then
                if cast.mutilate() then return end
            end
        end -- End Action List - Direct
    -- Action List - Stealth Breaker
        local function actionList_StealthBreaker()
            rotationDebug = "Stealth Breaker"
            if getDistance("target") < 5 then
                if stealthingAll and isValidUnit("target") and (not isBoss("target") or not isChecked("Opener")) and opener == false then
            -- Rupture
                    if cast.able.rupture() and level >= 20 and comboPoints >= 2 and not debuff.rupture.exists(units.dyn5)
                        and combatTime < 10 and getOptionValue("Stealth Breaker") == 1
                    then
                        if cast.rupture("target") then opener = true; return end
                    elseif cast.able.rupture() and level >= 20 and comboPoints >= 4 and not debuff.rupture.exists(units.dyn5) and getOptionValue("Stealth Breaker") == 1 then
                        if cast.rupture("target") then opener = true; return end
            -- Garrote
                    elseif cast.able.garrote() and level >= 12 and not debuff.garrote.exists(units.dyn5) and cd.garrote.remain() <= 1 and getOptionValue("Stealth Breaker") == 1 then
                        if cast.garrote("target") then opener = true; return end
            -- Cheap Shot
                    elseif cast.able.cheapShot() and level >= 8 and getOptionValue("Stealth Breaker") == 2 then
                        if cast.cheapShot("target") then opener = true; return end
            -- Mutilate
                    elseif cast.able.mutilate() and level >= 40 then
                        if cast.mutilate("target") then opener = true; return end
            -- Sinister Strike
                    elseif cast.able.sinisterStrike() and level < 40 then
                        if cast.sinisterStrike("target") then opener = true; return end
                    end
                end
                opener = true
            end
        end
    -- Action List - Opener
        local function actionList_Opener()
            rotationDebug = "Opener"
        -- Shadowstep
            if isChecked("Shadowstep") and isValidUnit("target") and getDistance("target") > 8 and getDistance("target") < 25 then
                if cast.shadowstep("target") then return end
            end
        -- Start Attack
            -- auto_attack
            if isChecked("Opener") and isBoss("target") and opener == false then
                if isValidUnit("target") and getDistance("target") < 5 and mode.pickPocket ~= 2 then
            -- -- Begin
            --         if not OPN1 then
            --             Print("Starting Opener")
            --             OPN1 = true
            -- -- Garrote
            --         elseif OPN1 and (not GAR1 or (not debuff.garrote.exists("target") and cd.garrote.remain() == 0)) and power >= 45 then
            --             if castOpener("garrote","GAR1",1) then return end
            -- -- Mutilate
            --         elseif GAR1 and (not MUT1 or (not RUP1 and comboPoints== 0)) and power >= 55 then
            --             if castOpener("mutilate","MUT1",2) then return end
            -- -- Rupture
            --         elseif MUT1 and not RUP1 and power >= 25 then
            --             if comboPoints> 0 then
            --                 if castOpener("rupture","RUP1",3) then return end
            --             else
            --                 Print("3: Rupture (Uncastable)")
            --                 RUP1 = true
            --             end
            -- -- Vendetta
            --         elseif RUP1 and not VEN1 then
            --             if castOpener("vendetta","VEN1",4) then return end
            -- -- Toxic Blade
            --         elseif VEN1 and not TOX1 and power >= 20 then
            --             if talent.toxicBlade and isChecked("Toxic Blade") then
            --                 if castOpener("toxicBlade","TOX1",5) then return end
            --             else
            --                 Print("5: Toxic Blade (Uncastable)")
            --                 TOX1 = true
            --             end
            -- -- Kingsbane
            --         elseif TOX1 and not KIN1 and power >= 35 then
            --             if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
            --                 if castOpener("kingsbane","KIN1",6) then return end
            --             else
            --                 Print("6: Kingsbane (Uncastable)")
            --                 KIN1 = true
            --             end
            -- -- Vanish
            --         elseif KIN1 and not VAN1 then
            --             if isChecked("Vanish") and not solo then
            --                 if castOpener("vanish","VAN1",7) then return end
            --             else
            --                 Print("7: Vanish (Uncastable)")
            --                 VAN1 = true
            --             end
            -- -- Envenom
            --         elseif VAN1 and not ENV1 and power >= 35 then
            --             if comboPoints> 0 then
            --                 if castOpener("envenom","ENV1",8) then return end
            --             else
            --                 Print("8: Envenom (Uncastable)")
            --                 ENV1 = true
            --             end
            -- -- Mutilate
            --         elseif ENV1 and not MUT2 and power >= 55 then
            --             if castOpener("mutilate","MUT2",9) then return end
            -- -- Garrote
            --         elseif MUT2 and (not GAR2 or (not debuff.garrote.exists("target") and cd.garrote.remain() == 0)) and power >= 45 then
            --             if castOpener("garrote","GAR2",10) then return end
            -- -- Envenom
            --         elseif GAR2 and not ENV2 and power >= 35 then
            --             if comboPoints> 0 then
            --                 if castOpener("envenom","ENV2",11) then return end
            --             else
            --                 Print("11: Envenom (Uncastable)")
            --                 ENV2 = true
            --             end
            -- -- Finish
            --         elseif ENV2 then
            --             Print("Opener Complete")
            --             opener = true;
            --             return
            --         end
                    if actionList_Stealthed() then return end
                end
            elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
                if actionList_Stealthed() then return end
            end
        end -- End Action List - Opener
    -- Action List - PreCombat
        local function actionList_PreCombat()
            rotationDebug = "Pre-Combat"
            if not inCombat and not (IsFlying() or IsMounted()) then
        -- Apply Poison
                -- apply_poison
                if getOptionValue("Lethal Poison") == 1 and buff.deadlyPoison.remain() < 300 and not cast.last.deadlyPoison() then
                    if cast.deadlyPoison("player") then return end
                end
                if getOptionValue("Lethal Poison") == 2 and buff.woundPoison.remain() < 300 and not cast.last.woundPoison() then
                    if cast.woundPoison("player") then return end
                end
                if getOptionValue("Non-Lethal Poison") == 1 and buff.cripplingPoison.remain() < 300 and not cast.last.cripplingPoison() then
                    if cast.cripplingPoison("player") then return end
                end
        -- Stealth
                -- stealth
                if isChecked("Stealth") and cast.able.stealth() and not stealth and (not IsResting() or isDummy("target")) then
                    if getOptionValue("Stealth") == 1 then
                        if cast.stealth() then return end
                    end
                    if autoStealth() and getOptionValue("Stealth") == 3 then
                        if cast.stealth() then return end
                    end
                end
        -- Marked For Death
                -- marked_for_death,if=raid_event.adds.in>40
                if cast.able.markedForDeath("target") and isValidUnit("target") and mode.pickPocket ~= 2 then
                    if cast.markedForDeath("target") then return end
                end
            end
        -- Opener
            if actionList_StealthBreaker() then return end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    --Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
            return true
        else
            rotationDebug = "Rotating"
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
--------------------------
--- Interrupt Rotation ---
--------------------------
            if actionList_Interrupts() then return end
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
        -- Assassination is 4 shank!
            if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) and opener == true then
                rotationDebug = "In-Combat Rotation"
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
        -- Shadowstep
                if isChecked("Shadowstep") and getDistance("target") > 8 and getDistance("target") < 25 then
                    if cast.shadowstep("target") then return end
                end
        -- Start Attack
                if getDistance(units.dyn5) < 5 and not cast.last.vanish() and (not buff.stealth.exists() or not buff.vanish.exists() or not buff.shadowmeld.exists()) then
                    StartAttack()
                end
        -- Multi-Garrote
                if cast.able.garrote() and buff.subterfuge.exists() and (debuff.garrote.count() < 3 or debuff.garrote.count() >= #enemies.yards5) then 
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if debuff.garrote.refresh(thisUnit) then 
                            if cast.garrote(thisUnit) then return end 
                        end
                    end 
                end 
        -- Call Action List - Stealthed
                -- call_action_list,name=stealthed,if=stealthed.rogue
                if stealthedRogue then
                    if actionList_Stealthed() then return end
                end
        -- Call Action List - Cooldowns
                -- call_action_list,name=cds
                if actionList_Cooldowns() then return end
        -- Call Action List - Dot
                -- call_action_list,name=dot
                if actionList_Dot() then return end
        -- Call Action List - Direct
                -- call_action_list,name=direct
                if actionList_Direct() then return end
        -- Racials
                -- arcane_torrent,if=energy.deficit>=15+variable.energy_regen_combined
                -- arcane_pulse
                -- lights_judgment
                if isChecked("Racial") and cast.able.racial() and ((race == "Nightborne" or race == "LightforgedDraenei")
                    or (race == "BloodElf" and energyDeficit >= 15 + energyRegenCombined))
                then
                    if cast.racial() then return end
                end
            end -- End In Combat
        end -- End Profile
    -- end -- Timer
end -- runRotation
local id = 259
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

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
            br.ui:createDropdown(section, "Lethal Poison", {"Deadly","Wound"}, 1, "Lethal Poison to Apply")
            br.ui:createDropdown(section, "Non-Lethal Poison", {"Crippling","Leeching"}, 1, "Non-Lethal Poison to Apply")
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
            -- Artifact
            br.ui:createDropdownWithout(section,"Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
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
            -- Legendary Ring
            br.ui:createCheckbox(section, "Legendary Ring")
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
            -- Toxic Blade
            br.ui:createCheckbox(section, "Toxic Blade")
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
    if br.timer:useTimer("debugAssassination", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Cleave",0.25)
        br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
        UpdateToggle("Picker",0.25)
        br.player.mode.pickPocket = br.data.settings[br.selectedSpec].toggles["Picker"]

--------------
--- Locals ---
--------------
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end
        local addsIn                                        = 999
        local artifact                                      = br.player.artifact
        local attacktar                                     = UnitCanAttack("target","player")
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local cd                                            = br.player.cd
        local charge                                        = br.player.charges
        local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
        local cTime                                         = getCombatTime()
        local deadtar                                       = UnitIsDeadOrGhost("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local exsanguinated                                 = exsanguinated
        local flaskBuff, canFlask                           = getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)
        local gcd                                           = br.player.gcd
        local glyph                                         = br.player.glyph
        local hastar                                        = GetObjectExists("target")
        local healPot                                       = getHealthPot()
        local hemorrhageCount                               = hemorrhageCount
        local inCombat                                      = br.player.inCombat
        local lastSpell                                     = lastCast
        local level                                         = br.player.level
        local mode                                          = br.player.mode
        local multidot                                      = br.player.mode.cleave == 1
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powerDeficit, powerRegen               = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.racial
        local solo                                          = #br.friend < 2
        local spell                                         = br.player.spell
        local stealth                                       = br.player.buff.stealth.exists()
        local stealthing                                    = br.player.buff.stealth.exists() or br.player.buff.vanish.exists() or br.player.buff.shadowmeld.exists()
        local t18_4pc                                       = TierScan("T18") >= 4
        local t19_2pc                                       = TierScan("T19") >= 2
        local t19_4pc                                       = TierScan("T19") >= 4
        local t20_4pc                                       = TierScan("T20") >= 4
        local talent                                        = br.player.talent
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.energy.ttm()
        local units                                         = br.player.units

        units.get(5)
        enemies.get(5)
        enemies.get(8)
        enemies.get(10)
        enemies.get(20)
        enemies.get(30)

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

        -- Exsanguinated Bleeds
        if not debuff.rupture.exists(units.dyn5) then exRupture = false end
        if not debuff.garrote.exists(units.dyn5) then exGarrote = false end
        if not debuff.internalBleeding.exists(units.dyn5) then exInternalBleeding = false end
        if lastSpell == spell.exsanguinate then exsanguinateCast = true else exsanguinateCast = false end
        if exsanguinateCast and debuff.rupture.exists(units.dyn5) then exRupture = true end
        if exsanguinateCast and debuff.garrote.exists(units.dyn5) then exGarrote = true end
        if exsanguinateCast and debuff.internalBleeding.exists(units.dyn5) then exInternalBleeding = true end
        if exRupture or exGarrote or exInternalBleeding then exsanguinated = true else exsanguinated = false end

        -- Numeric Returns
        if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
        if talent.deeperStratagem and not t19_4pc then dStratNo4T19 = 1 else dStratNo4T19 = 0 end
        if talent.anticipation then antital = 1 else antital = 0 end
        if talent.masterPoisoner then masterPoison = 1 else masterPoison = 0 end
        if talent.exsanguinate then exsang = 1 else exsang = 0 end
        if talent.vigor then vigor = 1 else vigor = 0 end
        if not talent.exsanguinate then noExsanguinate = 1 else noExsanguinate = 0 end
        if not talent.venomRush then noVenom = 1 else noVenom = 0 end
        if artifact.urgeToKill.enabled() then urges = 1 else urges = 0 end
        if hasEquiped(137049) then insigniad = 1 else insigniad = 0 end
        if hasEquiped(140806) then convergingFate = 1 else convergingFate = 0 end
        if hasEquiped(144236) then legshoulders = true else legshoulders = false end
        if buff.masterAssassinsInitiative.remain() >= cd.global.remain() + 0.2 then mantled = 1 else mantled = 0 end
        if rotationDebug == nil or not inCombat then rotationDebug = "Waiting" end


        -- Energy Regen Combined
        -- variable,name=energy_regen_combined,value=energy.regen+poisoned_bleeds*(7+talent.venom_rush.enabled*3)%2
        local bleeds = debuff.garrote.count() + debuff.rupture.count()
        if talent.venom then venom = 1 else venom = 0 end
        local energyRegenCombined = powerRegen + bleeds * (7 + venom * 3) / 2

        -- Energy Time To Max Combined
        -- variable,name=energy_time_to_max_combined,value=energy.deficit%variable.energy_regen_combined
        local energyTTMCombined = powerDeficit / energyRegenCombined

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
            if (canPickpocket == false or br.player.mode.pickPocket == 3 or GetNumLootItems()>0) and not isDummy() then
                return true
            else
                return false
            end
        end

        -- ChatOverlay(tostring(rotationDebug))

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if GetObjectExists("target") then
                    if cTime >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        profileStop = true
                    end
                end
            end
        -- Pick Pocket
            if usePickPocket() then
                if (isValidUnit(units.dyn5) or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
                    if not isPicked(units.dyn5) and not isDummy(units.dyn5) then
                        if debuff.sap.remain(units.dyn5) < 1 and mode.pickPocket ~= 1 then
                            if cast.sap(units.dyn5) then return end
                        end
                        if lastSpell ~= spell.vanish then
                            if cast.pickPocket() then return end
                        end
                    end
                end
            end
        -- Poisoned Knife
            if isChecked("Poisoned Knife") and not buff.stealth.exists() and not (IsMounted() or IsFlying()) then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    local distance = getDistance(thisUnit)
                    if not (debuff.deadlyPoison.exists(thisUnit) or debuff.woundPoison.exists(thisUnit)) and distance > 8 and ((inCombat and isValidUnit(thisUnit)) or UnitIsUnit(thisUnit,"target")) then
                        if cast.poisonedKnife(thisUnit) then return end
                    end
                end
            end
        -- Tricks of the Trade
            if isChecked("Tricks of the Trade on Focus") and cast.able.tricksOfTheTrade("focus") and inCombat and UnitExists("focus") and UnitIsFriend("focus") then
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
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
            -- Cloak of Shadows
                if isChecked("Cloak of Shadows") and canDispel("player",spell.cloakOfShadows) then
                    if cast.cloakOfShadows() then return end
                end
            -- Crimson Vial
                if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
                    if cast.crimsonVial() then return end
                end
            -- Evasion
                if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat then
                    if cast.evasion() then return end
                end
            -- Feint
                if isChecked("Feint") and php <= getOptionValue("Feint") and inCombat and not buff.feint.exists() then
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
                        if isChecked("Kick") then
                            if cast.kick(thisUnit) then return end
                        end
            -- Kidney Shot
                        if cd.kick.remain() ~= 0 then
                            if isChecked("Kidney Shot") then
                                if cast.kidneyShot(thisUnit) then return end
                            end
                        end
                    end
                end
            end -- End Interrupt and No Stealth Check
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            rotationDebug = "Cooldowns"
            if (useCDs() or burst) and getDistance(units.dyn5) < 5 then
        -- Potion
                -- potion,if=buff.bloodlust.react|target.time_to_die<=60|debuff.vendetta.up&cooldown.vanish.remains<5
                if isChecked("Potion") and canUse(142117) then
                    if hasBloodLust() or ttd("target") <= 60 or debuff.vendetta.exists("target") and cd.vanish.remain() < 5 then
                        useItem(142117)
                    end
                end
        -- Draught of Souls
                if mode.dos == 1 and hasEquiped(140808) and canUse(140808) then
                    -- use_item,name=draught_of_souls,if=energy.deficit>=35+variable.energy_regen_combined*2&(!equipped.mantle_of_the_master_assassin|cooldown.vanish.remains>8)
                    if powerDeficit >= 35 + energyRegenCombined * 2 and (not hasEquiped(144236) or cd.vanish.remain() > 8) then
                        useItem(140808)
                    end
                    -- use_item,name=draught_of_souls,if=mantle_duration>0&mantle_duration<3.5&dot.kingsbane.ticking
                    if buff.masterAssassinsInitiative.remain() > 0 and buff.masterAssassinsInitiative.remain() < 3.5 and debuff.kingsbane.exists(units.dyn5) then
                        useItem(140808)
                    end
                end
        -- Specter of Betrayal
                -- use_item,name=specter_of_betrayal
                if hasEquiped(151190) and canUse(151190) then
                    useItem(151190)
                end
        -- Racial
                -- blood_fury,if=debuff.vendetta.up
                -- berserking,if=debuff.vendetta.up
                -- arcane_torrent,if=dot.kingsbane.ticking&!buff.envenom.up&energy.deficit>=15+variable.energy_regen_combined*gcd.remains*1.1
                if isChecked("Racial") and ((debuff.vendetta.exists(units.dyn5) and (race == "Orc" or race == "Troll"))
                    or (race == "BloodElf" and debuff.kingsbane.exists(units.dyn5) and not buff.envenom.exists() and powerDeficit >= 15 + energyRegenCombined * cd.global.remain() * 1.1))
                then
                    if castSpell("player",racial,false,false,false) then return end
                end
        -- Trinkets
                if getOptionValue("Trinkets") ~= 4 then
                    if (getOptionValue("Trinkets") == 1 or getOptionValue("Trinkets") == 3) and canUse(13) and not (hasEquiped(140808, 13) or hasEquiped(151190, 13)) then
                        useItem(13)
                    end
                    if (getOptionValue("Trinkets") == 2 or getOptionValue("Trinkets") == 3) and canUse(14) and not (hasEquiped(140808, 14) or hasEquiped(151190, 14)) then
                        useItem(14)
                    end
                end
        -- Marked For Death
                -- marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit*1.5|(raid_event.adds.in>40&combo_points.deficit>=cp_max_spend)
                if isChecked("Marked For Death") then
                    if getOptionValue("Marked For Death") == 1 then
                        if ttd(units.dyn5) < comboDeficit * 1.5 or comboDeficit >= comboMax then
                            if cast.markedForDeath() then return end
                        end
                    end
                    if getOptionValue("Marked For Death") == 2 then
                        for i = 1, #enemies.yards30 do
                            local thisUnit = enemies.yards30[i]
                            if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                                if ttd(thisUnit) < comboDeficit * 1.5 or comboDeficit >= comboMax then
                                    if cast.markedForDeath(thisUnit) then return end
                                end
                            end
                        end
                    end
                end
        -- Vendetta
                -- vendetta,if=!artifact.urge_to_kill.enabled().enabled|energy.deficit>=60+variable.energy_regen_combined
                if getOptionValue("Vendetta") == 1 or (getOptionValue("Vendetta") == 2 and useCDs()) then
                    if not artifact.urgeToKill.enabled() or powerDeficit >= 60 + energyRegenCombined then
                        if cast.vendetta() then return end
                    end
                end
        -- Exsanguinate
                -- exsanguinate,if=!set_bonus.tier20_4pc&(prev_gcd.1.rupture&dot.rupture.remains>4+4*cp_max_spend&!stealthed.rogue|dot.garrote.pmultiplier>1&!cooldown.vanish.up&buff.subterfuge.up)
                if not t20_4pc and (lastSpell == spell.rupture and debuff.rupture.remain(units.dyn5) > 4 + 4 * comboMax and (not stealthing or (cd.vanish.remain() > 0 and buff.subterfuge.exists()))) then
                    if cast.exsanguinate() then return end
                end
                -- exsanguinate,if=set_bonus.tier20_4pc&dot.garrote.remains>20&dot.rupture.remains>4+4*cp_max_spend
                if t20_4pc and debuff.garrote.remain(units.dyn5) > 20 and debuff.rupture.remain(units.dyn5) > 4 + 4 * comboMax then
                    if cast.exsanguinate() then return end
                end
        -- Vanish
                if isChecked("Vanish") and not solo then
                    -- vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&!talent.exsanguinate.enabled&mantle_duration=0&((equipped.mantle_of_the_master_assassin&set_bonus.tier19_4pc)|((!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)&(dot.rupture.refreshable|debuff.vendetta.up)))
                    if talent.nightstalker and combo >= comboMax and not talent.exsanguinate and buff.masterAssassinsInitiative.remain() == 0 and ((hasEquiped(144236) and t19_4pc)
                        or ((not hasEquiped(144236) or not t19_4pc) and (debuff.rupture.refresh(units.dyn5) or debuff.vendetta.exists(units.dyn5))))
                    then
                        if cast.vanish() then return end
                    end
                    -- vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&(dot.rupture.ticking|time>10)
                    if talent.nightstalker and combo >= comboMax and talent.exsanguinate and cd.exsanguinate.remain() < 1 and (debuff.rupture.exists(units.dyn5) or cTime > 10) then
                        if cast.vanish() then return end
                    end
                    -- vanish,if=talent.subterfuge.enabled&equipped.mantle_of_the_master_assassin&(debuff.vendetta.up|target.time_to_die<10)&mantle_duration=0
                    if talent.subterfuge and hasEquiped(144236) and (debuff.vendetta.exists(units.dyn5) or ttd(units.dyn5) < 10) and buff.masterAssassinsInitiative.remain() == 0 then
                        if cast.vanish() then return end
                    end
                    -- vanish,if=talent.subterfuge.enabled&!equipped.mantle_of_the_master_assassin&!stealthed.rogue&dot.garrote.refreshable&((spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives)|(spell_targets.fan_of_knives>=4&combo_points.deficit>=4))
                    if talent.subterfuge and not hasEquiped(144236) and not stealthing and debuff.garrote.refresh(units.dyn5)
                        and ((#enemies.yards10 <= 3 and comboDeficit >= 1 + #enemies.yards10) or (#enemies.yards10 >= 4 and comboDeficit >= 4))
                    then
                        if cast.vanish() then return end
                    end
                    -- vanish,if=talent.shadow_focus.enabled&variable.energy_time_to_max_combined>=2&combo_points.deficit>=4
                    if talent.shadowFocus and energyTTMCombined >= 2 and comboDeficit >= 4 then
                        if cast.vanish() then return end
                    end
                end
        -- Toxic Blade
                -- toxic_blade,if=combo_points.deficit>=1+(mantle_duration>=gcd.remains+0.2)&dot.rupture.remains>8
                if isChecked("Toxic Blade") then
                    if comboDeficit >= 1 + mantled and debuff.rupture.remain(units.dyn5) > 8 then
                        if cast.toxicBlade(units.dyn5) then return end
                    end
                end
            end -- End Cooldown Usage Check
        end -- End Action List - Cooldowns
    -- Action List - Finishers
        local function actionList_Finishers()
            rotationDebug = "Finishers"
        -- Death From Above
            -- death_from_above,if=combo_points>=5
            if combo >= 5 then
                if cast.deathFromAbove() then return end
            end
        -- Envenom
            -- envenom,if=combo_points>=4+(talent.deeper_stratagem.enabled&!set_bonus.tier19_4pc)&(debuff.vendetta.up|mantle_duration>=gcd.remains+0.2|debuff.surge_of_toxins.remains<gcd.remains+0.2|energy.deficit<=25+variable.energy_regen_combined)
            if combo >= 4 + dStratNo4T19 and (debuff.vendetta.exists(units.dyn5) or buff.masterAssassinsInitiative.remain() >= cd.global.remain() + 0.2
                or debuff.surgeOfToxins.remain(units.dyn5) < cd.global.remain() + 0.2 or powerDeficit <= 25 + energyRegenCombined)
            then
                if cast.eviscerate(units.dyn5) then return end
            end
            -- envenom,if=talent.elaborate_planning.enabled&combo_points>=3+!talent.exsanguinate.enabled&buff.elaborate_planning.remains<gcd.remains+0.2
            if talent.elaboratePlanning and combo >= 3 + noExsanguinate and buff.elaboratePlanning.remain() < cd.global.remain() + 0.2 then
                if cast.envenom(units.dyn5) then return end
            end
        -- Eviscerate
            if level < 36 and combo >= 5 then
                if cast.eviscerate(units.dyn5) then return end
            end
        end -- End Action List - Finishers
    -- Action List - Kingsbane
        local function actionList_Kingsbane()
            rotationDebug = "Kingsbane"
        -- Kingsbane
            if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
                -- kingsbane,if=artifact.sinister_circulation.enabled().enabled&!(equipped.duskwalkers_footpads&equipped.convergence_of_fates&artifact.master_assassin.rank()>=6)&(time>25|!equipped.mantle_of_the_master_assassin|(debuff.vendetta.up&debuff.surge_of_toxins.up))&(talent.subterfuge.enabled|!stealthed.rogue|(talent.nightstalker.enabled&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)))
                if artifact.sinisterCirculation.enabled() and not (hasEquiped(137030) and hasEquiped(140806) and artifact.masterAssassin.rank() >= 6)
                    and (cTime > 25 or not hasEquiped(144236) or (debuff.vendetta.exists(units.dyn5) and debuff.surgeOfToxins.exists(units.dyn5))
                        and (talent.subterfuge or not stealthing or (talent.nightstalker and (not hasEquiped(144236) or not t19_4pc))))
                then
                    if cast.kingsbane() then return end
                end
                -- kingsbane,if=buff.envenom.up&((debuff.vendetta.up&debuff.surge_of_toxins.up)|cooldown.vendetta.remains<=5.8|cooldown.vendetta.remains>=10)
                if buff.envenom.exists() and ((debuff.vendetta.exists(units.dyn5) and debuff.surgeOfToxins.exists(units.dyn5)) or cd.vendetta.remain() <= 5.8 or cd.vendetta.remain() >= 10) then
                    if cast.kingsbane() then return end
                end
            end
        end
    -- Action List - Maintain
        local function actionList_Maintain()
            rotationDebug = "Maintain"
        -- Rupture
            -- rupture,if=talent.nightstalker.enabled&stealthed.rogue&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)&(talent.exsanguinate.enabled|target.time_to_die-remains>4)
            if talent.nightstalker and stealthing and (not hasEquiped(144236) or not t19_4pc) and (talent.exsanguinate or ttd(units.dyn5) > 4) then
                if cast.rupture(units.dyn5) then return end
            end
        -- Garrote
            -- garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&set_bonus.tier20_4pc&((dot.garrote.remains<=13&!debuff.toxic_blade.up)|pmultiplier<=1)&!exsanguinated
            if talent.subterfuge and stealthing and comboDeficit >= 1 and t20_4pc and not exGarrote then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if ((debuff.garotte.remain(thisUnit) <= 13 and debuff.toxicBlade.exists(thisUnit))) then
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
            -- garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&!set_bonus.tier20_4pc&refreshable&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>2
            if talent.subterfuge and stealthing and comboDeficit >= 1 and not t20pc4 then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.garrote.refresh(thisUnit) and (not exsanguinated or debuff.garrote.remain(thisUnit) <= 1.5) and ttd(thisUnit) - debuff.garrote.remain(thisUnit) > 2 then
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
            -- garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&!set_bonus.tier20_4pc&remains<=10&pmultiplier<=1&!exsanguinated&target.time_to_die-remains>2
            if talent.subterfuge and stealthing and comboDeficit >= 1 and not t20_4pc then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.garrote.remain(thisUnit) <= 10 and not exsanguinated and ttd(thisUnit) - debuff.garrote.remain(thisUnit) > 2 then
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
        -- Rupture
            -- rupture,if=!talent.exsanguinate.enabled&combo_points>=3&!ticking&mantle_duration<=gcd.remains+0.2&target.time_to_die>6
            if not talent.exsanguinate and combo >= 3 and not debuff.rupture.exists(units.dyn5) and buff.masterAssassinsInitiative.remain() <= cd.global.remain() + 0.2 and ttd(units.dyn5) > 6 then
                if cast.rupture() then return end
            end
            -- rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2+artifact.urge_to_kill.enabled().enabled)))
            if talent.exsanguinate and ((combo >= comboMax and cd.exsanguinate.remain() < 1) or (not debuff.rupture.exists(units.dyn5) and (cTime > 10 or combo >= 2 + urges))) then
                if cast.rupture() then return end
            end
            -- rupture,cycle_targets=1,if=combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time)&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>6
            if combo >= 4 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.rupture.refresh(thisUnit) and debuff.rupture.remain(thisUnit) <= 2 and (not exsanguinated or debuff.rupture.remain(thisUnit) <= 2 * 2) and ttd(thisUnit) - debuff.rupture.remain(thisUnit) > 6 then
                            if cast.rupture(thisUnit) then return end
                        end
                    end
                end
            end
        -- Kingsbane
            -- call_action_list,name=kb,if=combo_points.deficit>=1+(mantle_duration>=gcd.remains+0.2)
            if comboDeficit >= 1 + mantled then
                if actionList_Kingsbane() then return end
            end
        -- Garrote
            -- garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1&refreshable&(pmultiplier<=1|remains<=tick_time)&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>4
            if (not talent.subterfuge or not (cd.vanish.remain() == 0 and cd.vendetta.remain() <= 4)) and comboDeficit >= 1 then
                for i = 1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.garrote.refresh(thisUnit) and debuff.garrote.remain(thisUnit) <= 2 and (not exsanguinated or debuff.garrote.remain(thisUnit) <= 2 * 2) and ttd(thisUnit) - debuff.garrote.remain(thisUnit) > 4 then
                            if power < 45 then
                                return true
                            else
                                if cast.garrote(thisUnit) then return end
                            end
                        end
                    end
                end
            end
            -- garrote,if=set_bonus.tier20_4pc&talent.exsanguinate.enabled&prev_gcd.1.rupture&cooldown.exsanguinate.remains<1
            if t20_4pc and talent.exsanguinate and lastSpell == spell.rupture and cd.exsanguinate.remain() < 1 then
                if cast.garrote() then return end
            end
        end -- End Action List - Maintain
    -- Action List - Generators
        local function actionList_Generators()
            rotationDebug = "Generator"
        -- Hemorrhage
            -- hemorrhage,if=refreshable
            if debuff.hemorrhage.refresh(units.dyn5) then
                if cast.hemorrhage() then return end
            end
            -- hemorrhage,cycle_targets=1,if=refreshable&dot.rupture.ticking&spell_targets.fan_of_knives<2+equipped.insignia_of_ravenholdt
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.hemorrhage.refresh(thisUnit) and debuff.rupture.remain(thisUnit) > 0 and #enemies.yards10 < 2 + insigniad then
                       if cast.hemorrhage(thisUnit) then return end
                    end
                end
            end
        -- Fan of Knives
            -- fan_of_knives,if=spell_targets>=2+equipped.insignia_of_ravenholdt|buff.the_dreadlords_deceit.stack>=29
            if ((mode.rotation == 1 and #enemies.yards8 >= (getOptionValue("Fan of Knives") + insigniad) or mode.rotation == 2) or buff.theDreadlordsDeceit.stack() >= 29) then
                if cast.fanOfKnives("player") then return end
            end
        -- Mutilate
            -- mutilate,cycle_targets=1,if=dot.deadly_poison_dot.refreshable
            if ((mode.rotation == 1 and #enemies.yards8 < getOptionValue("Fan of Knives")) or mode.rotation == 3 or level < 63) then
                for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if debuff.deadlyPoison.refresh(thisUnit) then
                            if level >= 40 then
                                if cast.mutilate(thisUnit) then return end
                            else
                                if cast.sinisterStrike(thisUnit) then return end
                            end
                        end
                    end
                end
                -- mutilate
                if level >= 40 then
                    if cast.mutilate() then return end
                else
                    if cast.sinisterStrike() then return end
                end
            end
        end -- End Action List - Generators
    -- Action List - Stealth Breaker
        local function actionList_StealthBreaker()
            if stealthing and isValidUnit("target") and (not isBoss("target") or not isChecked("Opener")) then
        -- Rupture
                if level >= 20 and combo >= 2 and not debuff.rupture.exists(units.dyn5) and cTime < 10 and not artifact.urgeToKill.enabled() and getOptionValue("Stealth Breaker") == 1 then
                    if cast.rupture("target") then opener = true; return end
                elseif level >= 20 and combo >= 4 and not debuff.rupture.exists(units.dyn5) and getOptionValue("Stealth Breaker") == 1 then
                    if cast.rupture("target") then opener = true; return end
        -- Garrote
                elseif level >= 12 and not debuff.garrote.exists(units.dyn5) and cd.garrote.remain() <= 1 and getOptionValue("Stealth Breaker") == 1 then
                    if cast.garrote("target") then opener = true; return end
        -- Cheap Shot
                elseif level >= 8 and getOptionValue("Stealth Breaker") == 2 then
                    if cast.cheapShot("target") then opener = true; return end
        -- Mutilate
                elseif level >= 40 then
                    if cast.mutilate("target") then opener = true; return end
        -- Sinister Strike
                else
                    if cast.sinisterStrike("target") then opener = true; end
                end
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
            -- Begin
                    if not OPN1 then
                        Print("Starting Opener")
                        OPN1 = true
            -- Garrote
                    elseif OPN1 and (not GAR1 or (not debuff.garrote.exists("target") and cd.garrote.remain() == 0)) and power >= 45 then
                        if castOpener("garrote","GAR1",1) then return end
            -- Mutilate
                    elseif GAR1 and (not MUT1 or (not RUP1 and combo == 0)) and power >= 55 then
                        if castOpener("mutilate","MUT1",2) then return end
            -- Rupture
                    elseif MUT1 and not RUP1 and power >= 25 then
                        if combo > 0 then
                            if castOpener("rupture","RUP1",3) then return end
                        else
                            Print("3: Rupture (Uncastable)")
                            RUP1 = true
                        end
            -- Vendetta
                    elseif RUP1 and not VEN1 then
                        if castOpener("vendetta","VEN1",4) then return end
            -- Toxic Blade
                    elseif VEN1 and not TOX1 and power >= 20 then
                        if talent.toxicBlade and isChecked("Toxic Blade") then
                            if castOpener("toxicBlade","TOX1",5) then return end
                        else
                            Print("5: Toxic Blade (Uncastable)")
                            TOX1 = true
                        end
            -- Kingsbane
                    elseif TOX1 and not KIN1 and power >= 35 then
                        if (getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs())) then
                            if castOpener("kingsbane","KIN1",6) then return end
                        else
                            Print("6: Kingsbane (Uncastable)")
                            KIN1 = true
                        end
            -- Vanish
                    elseif KIN1 and not VAN1 then
                        if isChecked("Vanish") and not solo then
                            if castOpener("vanish","VAN1",7) then return end
                        else
                            Print("7: Vanish (Uncastable)")
                            VAN1 = true
                        end
            -- Envenom
                    elseif VAN1 and not ENV1 and power >= 35 then
                        if combo > 0 then
                            if castOpener("envenom","ENV1",8) then return end
                        else
                            Print("8: Envenom (Uncastable)")
                            ENV1 = true
                        end
            -- Mutilate
                    elseif ENV1 and not MUT2 and power >= 55 then
                        if castOpener("mutilate","MUT2",9) then return end
            -- Garrote
                    elseif MUT2 and (not GAR2 or (not debuff.garrote.exists("target") and cd.garrote.remain() == 0)) and power >= 45 then
                        if castOpener("garrote","GAR2",10) then return end
            -- Envenom
                    elseif GAR2 and not ENV2 and power >= 35 then
                        if combo > 0 then
                            if castOpener("envenom","ENV2",11) then return end
                        else
                            Print("11: Envenom (Uncastable)")
                            ENV2 = true
                        end
            -- Finish
                    elseif ENV2 then
                        Print("Opener Complete")
                        opener = true;
                        return
                    end
                end
            elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
                opener = true
                if actionList_StealthBreaker() then return end
            end
        end -- End Action List - Opener
    -- Action List - PreCombat
        local function actionList_PreCombat()
            rotationDebug = "Pre-Combat"
            if not inCombat and not (IsFlying() or IsMounted()) then
        -- Apply Poison
                -- apply_poison
                if isChecked("Lethal Poison") then
                    if br.timer:useTimer("Lethal Poison", 3.5) then
                        if getOptionValue("Lethal Poison") == 1 and not buff.deadlyPoison.exists() then
                            if cast.deadlyPoison("player") then return end
                        end
                        if getOptionValue("Lethal Poison") == 2 and not buff.woundPoison.exists() then
                            if cast.woundPoison("player") then return end
                        end
                    end
                end
                if isChecked("Non-Lethal Poison") then
                    if br.timer:useTimer("Non-Lethal Poison", 3.5) then
                        if (getOptionValue("Non-Lethal Poison") == 1 or not talent.leechingPoison) and not buff.cripplingPoison.exists() then
                            if cast.cripplingPoison() then return end
                        end
                        if getOptionValue("Non-Lethal Poison") == 2 and not buff.leechingPoison.exists() then
                            if cast.leechingPoison() then return end
                        end
                    end
                end
        -- Stealth
                -- stealth
                if isChecked("Stealth") and not stealth and (not IsResting() or isDummy("target")) then
                    if getOptionValue("Stealth") == 1 then
                        if cast.stealth() then return end
                    end
                    if #enemies.yards20 > 0 and getOptionValue("Stealth") == 3 then
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            if UnitIsEnemy(thisUnit,"player") or isDummy("target") then
                                if cast.stealth("player") then return end
                            end
                        end
                    end
                end
        -- Marked For Death
                -- marked_for_death,if=raid_event.adds.in>40
                if isValidUnit("target") and mode.pickPocket ~= 2 then
                    if cast.markedForDeath() then return end
                end
            end
        -- Opener
            if actionList_Opener() then return end
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
            if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) then
                rotationDebug = "In-Combat Rotation"
-----------------------------
--- In Combat - Cooldowns ---
-----------------------------
                if opener == true then
                    if actionList_Cooldowns() then return end
                end
----------------------------------
--- In Combat - Begin Rotation ---
----------------------------------
        -- Shadowstep
                if isChecked("Shadowstep") and getDistance("target") > 8 and getDistance("target") < 25 then
                    if cast.shadowstep("target") then return end
                end
                if (not stealthing or (GetObjectExists(units.dyn5) and br.player.buff.vanish.exists())) and opener == true then
                    if getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
        -- Call Action List - Maintain
                    -- call_action_list,name=maintain
                    if actionList_Maintain() then return end
        -- Call Action List - Finisher
                    -- call_action_list,name=finish,if=(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)&(!dot.rupture.refreshable|(dot.rupture.exsanguinated&dot.rupture.remains>=3.5)|target.time_to_die-dot.rupture.remains<=6)&active_dot.rupture>=spell_targets.rupture
                    if (not talent.exsanguinate or cd.exsanguinate.remain() > 2) and (not debuff.rupture.refresh(units.dyn5) or (exRupture and debuff.rupture.remain(units.dyn5) >= 3.5)
                        or ttd(units.dyn5) - debuff.rupture.remain(units.dyn5) <= 6 or level < 20 ) and (debuff.rupture.count() >= #enemies.yards5 or level < 20)
                    then
                        if actionList_Finishers() then return end
                    end
        -- Call Action List - Builders
                    -- call_action_list,name=build,if=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined
                    if (comboDeficit > 1 or powerDeficit <= 25 + energyRegenCombined or level < 3) then
                        if actionList_Generators() then return end
                    end
                end
            end -- End In Combat
        end -- End Profile
    end -- Timer
end -- runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

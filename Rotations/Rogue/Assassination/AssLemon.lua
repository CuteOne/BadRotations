local rotationName = "Lemon" -- Change to name of profile listed in options drop down

local colorPurple   = "|cffC942FD"
local colorBlue     = "|cff00CCFF"
local colorGreen    = "|cff00FF00"
local colorRed      = "|cffFF0000"
local colorWhite    = "|cffFFFFFF"
local colorGold     = "|cffFFDD11"
local colorLegendary= "|cffff8000"
local colorBlueMage = "|cff68ccef"
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
        PoolModes = {
      [1] = { mode = "On", value = 1 , overlay = "Will pool energy for envenoms", tip = "Will pool energy for envenoms.", highlight = 1, icon = br.player.spell.envenom},
      [2] = { mode = "Off", value = 2 , overlay = "Wont pool energy for envenoms", tip = "Will not  pool energy for envenoms.", highlight = 0, icon = br.player.spell.envenom},
    };
    CreateButton("Pool",7,0)
    DosModes = {
      [1] = { mode = "On", value = 1 , overlay = "Will use dos vanish next chance", tip = "Will use dos vanish.", highlight = 1, icon = br.player.spell.envenom},
      [2] = { mode = "Off", value = 2 , overlay = "Will not  use dos vanish", tip = "Noob", highlight = 0, icon = br.player.spell.envenom},
    };
    CreateButton("Dos",8,0)
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
            br.ui:createSpinnerWithout(section, "Multi-Dot HP Limit", 15, 0, 105, 1, "|cffFFFFFFHP *1kk hp for Ruptures to be AOE casted/refreshed on.")
            br.ui:createSpinnerWithout(section, "Max rupture count", 3, 1, 105, 1, "|cffFFFFFFHP Max rupture count.")
            br.ui:createSpinnerWithout(section, "#enemies to switch fok/muti", 4, 0, 105, 1, "|cffFFFFFF#enemies When to switch fok/muti")
            -- Poison
            br.ui:createDropdown(section, "Lethal Poison", {"Deadly","Wound","Agonizing"}, 1, "Lethal Poison to Apply")
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
        br.ui:checkSectionState(section)
        
         ------------------------
        --- ITEM OPTIONS --- -- Define Item Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Items")
        br.ui:createCheckbox(section, "Potion")
        br.ui:createCheckbox(section,"Flask / Crystal")
        br.ui:createDropdownWithout(section, "Trinket 1 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 1",  80,  0,  100,  5,  colorRed.."When to use Trinket 1")
        br.ui:createDropdownWithout(section, "Trinket 2 Condition", {colorWhite.."On Cooldown",colorWhite.."On Boss Health",colorWhite.."On Self Health"}, 1, colorWhite.."On Cooldown = Use Trinket whenever available, value doesn't matter; On Boss Health = Use Trinket when boss health is below value; On Self Health = Use Trinket when your health is below value;")
        br.ui:createSpinner(section, "Trinket 2",  60,  0,  100,  5,  colorRed.."When to use Trinket 2")
        br.ui:checkSectionState(section)
        
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Potion
            br.ui:createCheckbox(section, "Racial")
            -- Marked For Death
            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
            -- Vanish
            br.ui:createCheckbox(section, "Vanish")
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

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("Interrupt",0.25)
    UpdateToggle("Cleave",0.25)
    br.player.mode.cleave = br.data.settings[br.selectedSpec].toggles["Cleave"]
    UpdateToggle("Picker",0.25)
    br.player.mode.pickPocket = br.data.settings[br.selectedSpec].toggles["Picker"]
    UpdateToggle("Pool",0.25)
    br.player.mode.pool = br.data.settings[br.selectedSpec].toggles["Pool"]
    UpdateToggle("Dos",0.25)
    br.player.mode.dos = br.data.settings[br.selectedSpec].toggles["Dos"]          
--------------
--- Locals ---
--------------
    local artifact                                      = br.player.artifact
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local combatTime                                    = getCombatTime()
    local combo, comboDeficit, comboMax                 = br.player.power.comboPoints.amount(), br.player.power.comboPoints.deficit(), br.player.power.comboPoints.max()
    local cd                                            = br.player.cd
    local cTime                                         = getCombatTime()
    local charges                                       = br.player.charges
    local debuff                                        = br.player.debuff
    local enemies                                       = enemies or {}
    local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
    local gcd                                           = br.player.gcd
    local healPot                                       = getHealthPot()
    local inCombat                                      = br.player.inCombat
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local level                                         = br.player.level
    local lowestHP                                      = br.friend[1].unit
    local mode                                          = br.player.mode
    local perk                                          = br.player.perk
    local pmultiplier                                   = 1.0
    local php                                           = br.player.health
    local power, powerDeficit, powerRegen               = br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen
    local pullTimer                                     = br.DBM:getPulltimer()
    local race                                          = br.player.race
    local racial                                        = br.player.getRacial()
    local spell                                         = br.player.spell
    local talent                                        = br.player.talent
    local ttm                                           = br.player.timeToMax
    local units                                         = units or {}
    local tier19_4pc                                    = TierScan("T19") >= 4
    local tier20_4pc                                    = TierScan("T20") >= 4
    
    units.dyn5 = br.player.units(5)
    enemies.yards5 = br.player.enemies(5)
    enemies.yards8 = br.player.enemies(8)
    enemies.yards10 = br.player.enemies(10)
    enemies.yards20 = br.player.enemies(20)
    enemies.yards30 = br.player.enemies(30)
    dotHPLimit = getOptionValue("Multi-Dot HP Limit")
    maxrupture = getOptionValue("Max rupture count")
    aoecount = getOptionValue("#enemies to switch fok/muti")
 
    local bleeds = debuff.garrote.count() + debuff.rupture.count()
    if talent.venom then venom = 1 else venom = 0 end 
    local energyRegenCombined = powerRegen + bleeds * (7 + venom * 3) / 2

    -- Energy Time To Max Combined
    -- variable,name=energy_time_to_max_combined,value=energy.deficit%variable.energy_regen_combined
    local energyTTMCombined = powerDeficit / energyRegenCombined

--          if debuff.vendetta then vendy = 1 else vendy = 0 end
--          if artifact.bagOfTricks.enabled() then trickyBag = 1 else trickyBag = 0 end
--          if talent.elaboratePlanning then ePlan = 1 else ePlan = 0 end
    -- Custom Functions
    
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
    if buff.masterAssassinsInitiative.duration() > cd.global.remain() + 0.2 then mantled = 1 else mantled = 0 end
    
    if artifact.urgeToKill.enabled() then urges = 1 else urges = 0 end
    
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end
    
    if opener == nil then opener = false end
    if not inCombat and not GetObjectExists("target") and lastSpell ~= spell.vanish then
        OPN1 = false
        GAR1 = false
        MUT1 = false
        RUP1 = false
        MUT2 = false
        MUT3 = false
        VAN1 = false
        RUP2 = false
        VEN1 = false
        MUT4 = false
        KIN1 = false
        ENV1 = false
        opener = false
    end
    
    local function usePickPocket()
        if (mode.pickPocket == 1 or mode.pickPocket == 2) and buff.stealth.exists() then
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
    
--------------------
--- Action Lists ---
--------------------

    local function actionList_Extras()
    -- TODO: Add Extra Features To Base Profile
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
        if isChecked("Poisoned Knife") and not buff.stealth.exists() then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                local distance = getDistance(thisUnit)
                if not (debuff.deadlyPoison.exists(thisUnit) or debuff.woundPoison.exists(thisUnit)) and distance > 5 and isValidUnit(thisUnit) then
                    if cast.poisonedKnife(thisUnit) then return end
                end
            end
        end
        return false
    end -- End Action List - Extras
    
    local function actionList_Opener()
    -- Shadowstep
        if isChecked("Shadowstep") and isValidUnit("target") and getDistance("target") > 8 and getDistance("target") < 25 then
            if cast.shadowstep("target") then return end
        end
    -- Start Attack
        -- auto_attack
        if isChecked("Opener") and isBoss("target") and getDistance("target") < 5 and opener == false then
            if isValidUnit("target") and mode.pickPocket ~= 2 then
                if not OPN1 then 
                    Print("Starting Opener")
                    OPN1 = true
                elseif (not GAR1 or (not debuff.garrote.exists("target") and cd.garrote.remain() == 0)) and power >= 45 then
        -- Garrote
                    if castOpener("garrote","GAR1",1) then return end
                elseif GAR1 and (not MUT1 or (combo == 0 and not debuff.rupture.exists("target"))) and power >= 55 then
        -- Mutilate
                    if castOpener("mutilate","MUT1",2) then return end
                elseif MUT1 and not RUP1 and power >= 25 then
        -- Rupture
                    if castOpener("rupture","RUP1",3) then return end
                elseif RUP1 and not MUT2 and power >= 55 then
        -- Mutilate
                    if castOpener("mutilate","MUT2",4) then return end
                elseif MUT2 and not MUT3 and power >= 55 then
        -- Mutilate
                    if castOpener("mutilate","MUT3",5) then return end
                elseif MUT3 and not VAN1 then
        -- Vanish
                    if castOpener("vanish","VAN1",6) then return end
                elseif VAN1 and not RUP2 and power >= 25 then
        -- Rupture
                    if castOpener("rupture","RUP2",7) then return end
                elseif RUP2 and not VEN1 then
        -- Vendetta
                    if castOpener("vendetta","VEN1",8) then return end
                elseif VEN1 and not MUT4 and power >= 55 then
        -- Mutilate
                    if castOpener("mutilate","MUT4",9) then return end
                elseif MUT4 and not KIN1 and power >= 35 then
        -- Kingsbane
                    if castOpener("kingsbane","KIN1",10) then return end
                elseif KIN1 and not ENV1 and power >= 35 then
        -- Envenom
                    if castOpener("envenom","ENV1",11) then return end
                elseif ENV1 then
                    opener = true;
                    Print("Opener Complete")
                    return
                end
            end
        elseif (UnitExists("target") and not isBoss("target")) or not isChecked("Opener") then
            if combo >= 2 and not debuff.rupture.exists(units.dyn5) and cTime < 10 and not artifact.urgeToKill.enabled() and getOptionValue("Stealth Breaker") == 1 then
                if cast.rupture("target") then opener = true; return end
            elseif combo >= 4 and not debuff.rupture.exists(units.dyn5) and getOptionValue("Stealth Breaker") == 1 then
                if cast.rupture("target") then opener = true; return end
            elseif level >= 48 and not debuff.garrote.exists(units.dyn5) and cd.garrote.remain() <= 1 and getOptionValue("Stealth Breaker") == 1 then
                if cast.garrote("target") then opener = true; return end
            elseif level >= 29 and getOptionValue("Stealth Breaker") == 2 then
                if cast.cheapShot("target") then opener = true; return end
            else
                if cast.mutilate("target") then opener = true; return end
            end
        end
        return false
    end -- End Action List - Opener
        
    local function actionList_PreCombat()
    -- Apply Poison
        -- apply_poison
        if isChecked("Lethal Poison") then
            if br.timer:useTimer("Lethal Poison", 3.5) then
                if getOptionValue("Lethal Poison") == 1 and not buff.deadlyPoison.exists() then
                    if cast.deadlyPoison() then return end
                end
                if getOptionValue("Lethal Poison") == 2 and not buff.woundPoison.exists() then
                    if cast.woundPoison() then return end
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
        if isChecked("Stealth") and not stealth and not inCombat and (not IsResting() or isDummy("target")) then
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
        if isValidUnit("target") then
            if cast.markedForDeath() then return end
        end
        return false
    end -- End Action List - PreCombat
    
    local function actionList_Interrupt()
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
        return false
    end -- End Action List - Interrupts
    
    local function actionList_Defensive()
        -- -- TODO: Add Defensive Abilities
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
        end
        return false
    end -- End Action List - Defensive
    
    local function actionList_Kingsbane()
-- Kingsbane
        if getOptionValue("Artifact") == 1 or (getOptionValue("Artifact") == 2 and useCDs()) then
            -- kingsbane,if=artifact.sinister_circulation.enabled().enabled&!(equipped.duskwalkers_footpads&equipped.convergence_of_fates&artifact.master_assassin.rank()>=6)&(time>25|!equipped.mantle_of_the_master_assassin|(debuff.vendetta.up&debuff.surge_of_toxins.up))&(talent.subterfuge.enabled|!stealthed.rogue|(talent.nightstalker.enabled&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)))
            if artifact.sinisterCirculation.enabled() and not (hasEquiped(137030) and hasEquiped(140806) and artifact.masterAssassin.rank() >= 6) 
                and (cTime > 25 or not hasEquiped(144236) or (debuff.vendetta.exists(units.dyn5) and debuff.surgeOfToxins.exists(units.dyn5)) 
                    and (talent.subterfuge or not stealthing or (talent.nightstalker and (not hasEquiped(144236) or not t19_4pc))))
            then
                if cast.kingsbane() then return end
            end
            -- kingsbane,if=!talent.exsanguinate.enabled&buff.envenom.up&((debuff.vendetta.up&debuff.surge_of_toxins.up)|cooldown.vendetta.remains<=5.8|cooldown.vendetta.remains>=10)
            if not talent.exsanguinate and buff.envenom.exists() and ((debuff.vendetta.exists(units.dyn5) and debuff.surgeOfToxins.exists(units.dyn5)) or cd.vendetta.remain() <= 5.8 or cd.vendetta.remain() >= 10) then
                if cast.kingsbane() then return end
            end
            -- kingsbane,if=talent.exsanguinate.enabled&dot.rupture.exsanguinated
            if talent.exsanguinate and exRupture then
                if cast.kingsbane() then return end
            end 
        end
        return false
    end
    
    local function actionList_Cooldowns()
        --actions.cds=potion,if=buff.bloodlust.react|target.time_to_die<=60|debuff.vendetta.up&cooldown.vanish.remains<5
        if isChecked("Potion") and canUse(142117) then
            if hasBloodLust() or getTimeToDie("target") <= 25 or debuff.vendetta.exists("target") and cd.vanish.remain() < 5 then
                useItem(142117)
            end
        end
        --actions.cds+=/use_item,name=draught_of_souls,if=energy.deficit>=35+variable.energy_regen_combined*2&(!equipped.mantle_of_the_master_assassin|cooldown.vanish.remains>8)
        if powerDeficit >= 35 + energyRegenCombined*2 and (not hasEquiped(137049) or cd.vanish.remain() > 8) then
            if hasEquiped(140808) and canUse(140808) then
                useItem(140808)
            end
        end
        --actions.cds+=/use_item,name=draught_of_souls,if=mantle_duration>0&mantle_duration<3.5&dot.kingsbane.ticking
        if buff.masterAssassinsInitiative.remain() > 0 and buff.masterAssassinsInitiative.remain < 3.5 and debuff.kingsbane.exists(units.dyn5) then
            useItem(140808)
        end
        --actions.cds+=/use_item,name=specter_of_betrayal,if=buff.bloodlust.react|target.time_to_die<=20|debuff.vendetta.up
        if hasEquiped(151190) and canUse(151190) then
            if hasBloodLust() or getTimeToDie("target") <= 20 or debuff.vendetta.exists("target") then
                useItem(151190)
            end
        end
        --actions.cds+=/blood_fury,if=debuff.vendetta.up
        --actions.cds+=/berserking,if=debuff.vendetta.up
        --actions.cds+=/arcane_torrent,if=dot.kingsbane.ticking&!buff.envenom.up&energy.deficit>=15+variable.energy_regen_combined*gcd.remains*1.1
        if isChecked("Racial") and ((debuff.vendetta.exists(units.dyn5) and (race == "Orc" or race == "Troll")) 
            or (race == "BloodElf" and debuff.kingsbane.exists(units.dyn5) and not buff.envenom.exists() and powerDeficit >= 16 + energyRegenCombined * cd.global.remain() * 1.1)) 
        then
            if castSpell("player",racial,false,false,false) then return end
        end
        
        --actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit*1.5|(raid_event.adds.in>40&combo_points.deficit>=cp_max_spend)
        if isChecked("Marked For Death") then
            if getOptionValue("Marked For Death") == 1 then
                if getTimeToDie(units.dyn5) < comboDeficit * 1.5 or comboDeficit >= comboMax then
                    if cast.markedForDeath() then return end
                end
            end
            if getOptionValue("Marked For Death") == 2 then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if getTimeToDie(thisUnit) < comboDeficit * 1.5 or comboDeficit >= comboMax then
                            if cast.markedForDeath(thisUnit) then return end
                        end
                    end
                end
            end
        end
        
        --actions.cds+=/vendetta,if=!artifact.urge_to_kill.enabled().enabled|energy.deficit>=60+variable.energy_regen_combined
        if not artifact.urgeToKill.enabled() or powerDeficit >= 60 + energyRegenCombined then
            if cast.vendetta() then return end
        end
        
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
            if talent.subterfuge and hasEquiped(144236) and (debuff.vendetta.exists(units.dyn5) or getTimeToDie(units.dyn5) < 10) and buff.masterAssassinsInitiative.remain() == 0 then
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
        --actions.cds+=/exsanguinate,if=prev_gcd.1.rupture&dot.rupture.remains>4+4*cp_max_spend&!stealthed.rogue|!dot.garrote.pmultiplier<=1&!cooldown.vanish.up&buff.subterfuge.up
        if lastSpell == spell.rupture and debuff.rupture.remain(units.dyn5) > 4 + 4 * comboMax and (not stealthing or (cd.vanish.remain() > 0 and buff.subterfuge.exists())) then
                if cast.exsanguinate() then return end
            end
        --actions.cds+=/toxic_blade,if=combo_points.deficit>=1+(mantle_duration>=gcd.remains+0.2)&dot.rupture.remains>8
        if comboDeficit >= 1 + mantled and debuff.rupture.remain(units.dyn5) > 8 then
            if cast.toxicBlade() then return end
        end
        return false
    end
    
    local function actionList_Maintain()
        --actions.maintain=rupture,if=talent.nightstalker.enabled&stealthed.rogue&(!equipped.mantle_of_the_master_assassin|!set_bonus.tier19_4pc)&(talent.exsanguinate.enabled|target.time_to_die-remains>4)
        if talent.nightstalker and buff.stealth.exists() and (not hasEquiped(137049) or not t19_4pc) and (talent.exsanguinate or getTimeToDie("target") > 4) then
            if cast.rupture() then return end
        end
        --actions.maintain+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&set_bonus.tier20_4pc&((dot.garrote.remains<=13&!debuff.toxic_blade.up)|pmultiplier<=1)&!exsanguinated
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
        
        --actions.maintain+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&!set_bonus.tier20_4pc&refreshable&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>2
        if talent.subterfuge and stealthing and comboDeficit >= 1 and not t20pc4 then
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.garrote.refresh(thisUnit) and (not exsanguinated or debuff.garrote.remain(thisUnit) <= 1.5) and getTimeToDie(thisUnit) - debuff.garrote.remain(thisUnit) > 2 then
                        if cast.garrote(thisUnit) then return end
                    end
                end
            end
        end
        
        --actions.maintain+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&stealthed.rogue&combo_points.deficit>=1&!set_bonus.tier20_4pc&remains<=10&pmultiplier<=1&!exsanguinated&target.time_to_die-remains>2
        if talent.subterfuge and stealthing and comboDeficit >= 1 and not t20_4pc then
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.garrote.remain(thisUnit) <= 10 and not exsanguinated and getTimeToDie(thisUnit) - debuff.garrote.remain(thisUnit) > 2 then
                        if cast.garrote(thisUnit) then return end
                    end
                end
            end
        end       
        
        --actions.maintain+=/rupture,if=!talent.exsanguinate.enabled&combo_points>=3&!ticking&mantle_duration<=gcd.remains+0.2&target.time_to_die>6
        if not talent.exsanguinate and comboPoints >= 3 and not debuff.rupture.exists(units.dyn5) and buff.masterAssassinsInitiative.remain() <= cd.global.remain() + 0.2 and getTimeToDie(units.dyn5) > 6 then
            if cast.rupture() then return end
        end
        --actions.maintain+=/rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2+artifact.urge_to_kill.enabled().enabled)))
        if talent.exsanguinate and ((combo >= comboMax and cd.exsanguinate.remain() < 1) or (not debuff.rupture.exists(units.dyn5) and (cTime > 10 or combo >= 2 + urges))) then
            if cast.rupture() then return end
        end
        
        --actions.maintain+=/rupture,cycle_targets=1,if=combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time)&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>6
        if combo >= 4 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.rupture.refresh(thisUnit) and (not exsanguinated or debuff.rupture.remain(thisUnit) <= 1.5) and getTimeToDie(thisUnit) - debuff.rupture.remain(thisUnit) > 6 then
                        if cast.rupture(thisUnit) then return end
                    end
                end
            end
        end
        
        --actions.maintain+=/call_action_list,name=kb,if=combo_points.deficit>=1+(mantle_duration>=gcd.remains+0.2)
        if comboDeficit >= 1 + mantled then
            if actionList_Kingsbane() then return end
        end
        
        --actions.maintain+=/pool_resource,for_next=1
        --actions.maintain+=/garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1&refreshable&(pmultiplier<=1|remains<=tick_time)&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>4
        if (not talent.subterfuge or not (cd.vanish.remain() == 0 and cd.vendetta.remain() <= 4)) and comboDeficit >= 1 then
            for i = 1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.garrote.refresh(thisUnit) and (not exsanguinated or debuff.garrote.remain(thisUnit) <= 1.5) and getTimeToDie(thisUnit) - debuff.rupture.remain(thisUnit) > 4 then
                        if power < 45 then 
                            return true
                        else
                            if cast.garrote(thisUnit) then return end
                        end
                    end
                end
            end
        end
        return false
    end
    
    local function actionList_Finishers()
        --actions.finish=death_from_above,if=combo_points>=5
        if talent.deathFromAbove and comboPoints>=5 then
            if cast.deathFromAbove() then return end
        end
        --actions.finish+=/envenom,if=combo_points>=4&(debuff.vendetta.up|mantle_duration>=gcd.remains+0.2|debuff.surge_of_toxins.remains<gcd.remains+0.2|energy.deficit<=25+variable.energy_regen_combined)
        if comboPoints >= 4 and debuff.vendetta.exists("target") or buff.masterAssassinsInitiative.remain() >= cd.global.remain() + 0.2 or debuff.surgeOfToxins.remain("target") < cd.global.remain() + 0.2 or powerDeficit <= 25 + energyRegenCombined then
            if cast.envenom() then return end
        end
        --actions.finish+=/envenom,if=talent.elaborate_planning.enabled&combo_points>=3+!talent.exsanguinate.enabled&buff.elaborate_planning.remains<gcd.remains+0.2
        if talent.elaboratePlanning and comboPoints >= 3 + buff.elaboratePlanning.remain() < cd.global.remain() + 0.2 and not talent.exsanguinate then
            if cast.envenom() then return end
        end
        
        return false
    end
    
    local function actionList_Build()
        --actions.build=hemorrhage,if=refreshable
        if debuff.hemorrhage.refresh(units.dyn5) then
            if cast.hemorrhage() then return end
        end
        --actions.build+=/hemorrhage,cycle_targets=1,if=refreshable&dot.rupture.ticking&spell_targets.fan_of_knives<2+talent.agonizing_poison.enabled+equipped.insignia_of_ravenholdt
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
        --actions.build+=/fan_of_knives,if=spell_targets>=2+equipped.insignia_of_ravenholdt|buff.the_dreadlords_deceit.stack>=29
        if ((mode.rotation == 1 and #enemies.yards8 >= (aoecount + insigniad) or mode.rotation == 2) or buff.theDreadlordsDeceit.stack() >= 29) then
            if cast.fanOfKnives("player") then return end
        end
        --actions.build+=/mutilate,cycle_targets=1,if=dot.deadly_poison_dot.refreshable
        if ((mode.rotation == 1 and #enemies.yards8 < aoecount) or mode.rotation == 3) then
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    if debuff.deadlyPoison.refresh(thisUnit) then
                        if cast.mutilate(thisUnit) then return end
                    end
                end
            end
        end
        
        --actions.build+=/mutilate
        if cast.mutilate() then return end
        return false
    end

-----------------
--- Rotations ---
-----------------
    function profile()
        -- Pause
        if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) or mode.rotation == 4 then
            return true
        else

---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                StopAttack()
            end -- End Out of Combat Rotation
            
            if actionList_Defensive() then return true end

            if actionList_Interrupt() then return true end
            
            if actionList_PreCombat() then return true end
            
            if opener == false then
                if actionList_Opener() then return true end
            end
-----------------------------
--- In Combat - Rotations --- 
-----------------------------
            if inCombat then
                if opener == false then
                    if actionList_Opener() then return end
                end
                
                if (not stealthing or (GetObjectExists(units.dyn5) and br.player.buff.vanish.exists())) then
                    if getDistance(units.dyn5) < 5 then
                        StartAttack()
                    end
                    
                    
                    if getOptionValue("Trinket 1 Condition") == 1 then 
                        if isChecked("Trinket 1") and inCombat and canUse(13) then
                            useItem(13)
                        end
                    elseif getOptionValue("Trinket 1 Condition") == 2 then
                        if isChecked("Trinket 1") and inCombat and getHP("target") <= getValue("Trinket 1") and canUse(13) and isBoss("target") then
                            useItem(13)
                        end
                    elseif getOptionValue("Trinket 1 Condition") == 3 then
                        if isChecked("Trinket 1") and inCombat and health <= getValue("Trinket 1") and canUse(13) then
                            useItem(13)
                        end
                    end
                    
                    if getOptionValue("Trinket 2 Condition") == 1 then 
                        if isChecked("Trinket 2") and inCombat and canUse(14) then
                            useItem(14)
                        end
                    elseif getOptionValue("Trinket 2 Condition") == 2 then
                        if isChecked("Trinket 2") and inCombat and getHP("target") <= getValue("Trinket 2") and canUse(14) and isBoss("target") then
                            useItem(14)
                        end
                    elseif getOptionValue("Trinket 2 Condition") == 3 then
                        if isChecked("Trinket 2") and inCombat and health <= getValue("Trinket 2") and canUse(14) then
                            useItem(14)
                        end
                    end
                    --actions+=/call_action_list,name=cds
                    if opener == true then
                        if actionList_Cooldowns() then return true end
                    end
                    --actions+=/call_action_list,name=maintain
                    if actionList_Maintain() then return true end
                    --# The 'active_dot.rupture>=spell_targets.rupture' means that we don't want to envenom as long as we can multi-rupture (i.e. units that don't have rupture yet).
                    --actions+=/call_action_list,name=finish,if=(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)&(!dot.rupture.refreshable|(dot.rupture.exsanguinated&dot.rupture.remains>=3.5)|target.time_to_die-dot.rupture.remains<=6)&active_dot.rupture>=spell_targets.rupture
                    if (not talent.exsanguinate or cd.exsanguinate.remain() > 2) and (not debuff.rupture.refresh(units.dyn5) or (exRupture and debuff.rupture.remain(units.dyn5) >= 3.5)) then
                        if actionList_Finishers() then return true end
                    end
                    --actions+=/call_action_list,name=build,if=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined
                    if comboDeficit > 1 or powerDeficit <= 25 + energyRegenCombined then
                        if actionList_Build() then return true end
                    end
                end
            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
    
    if UnitCastingInfo("player") == nil and getSpellCD(61304) == 0 then
        return profile()
    end
    
end -- End runRotation 


--local id = 259 -- Change to the spec id profile is for.
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
